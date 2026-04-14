Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E089F9D0CE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5228B6B0092; Tue, 14 Apr 2026 09:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA3F6B0093; Tue, 14 Apr 2026 09:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410506B0095; Tue, 14 Apr 2026 09:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4E26B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:13:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE2C81605DC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:13:05 +0000 (UTC)
X-FDA: 84657201930.01.A835FAD
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 891BDA0017
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:13:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=lhDeNvog;
	spf=pass (imf15.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776172384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljtr9WPSUnaAjZD/FtGwji3II/sbFJuzXTsBaHKsQSU=;
	b=L4MmpBxbdGDpXo4hwjNwGFxWkfJtY5Yw+DIJ4yUGOC1VnotmhsSyelaw6r95wk1WVJIOOG
	HM+uv/INNQAX5/GWUl98bIsgnQlnvcfl+2Ijo1RGzMMi12IF3fRFOjP4ZXvXkVbqVumajB
	mxVNRaDhNtMB1iDLEu+JrxT71aGEUeA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=lhDeNvog;
	spf=pass (imf15.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776172384; a=rsa-sha256;
	cv=none;
	b=Ys6w6F+y1HdtiIjXX4txuTU8XBVSg/xa2DAjgBoYPRenbT8mdAJwXNoJeiKxoe+qvRtPeA
	l8XzaBePm2+bUqf/Z4sO3P8+r8lSEy7AQ1HOAt9+A607sL9Gh5C9syhAfi18pf76daGNMg
	CORHc3qq+MDnjLiiwGBSGMVNjlDksd0=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 7FCA11A32A8;
	Tue, 14 Apr 2026 13:13:01 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 46E3160410;
	Tue, 14 Apr 2026 13:13:01 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 569A6104500A2;
	Tue, 14 Apr 2026 15:12:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776172379; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ljtr9WPSUnaAjZD/FtGwji3II/sbFJuzXTsBaHKsQSU=;
	b=lhDeNvog7+cXfwfKejAzO+yVIre7KeKOh4nxhyYR84tw7Qhs4CDNLFYshF/sNo/ddcHeul
	OAXDnRRPYFfdKmNFr6FNXLWBgkwR5bSerHfi1jG3QAuxmeyq9DKVn4ADpvD+k/LktKcxCV
	Qo+C51KQYvBPk2tQWgzerrUX38wX8fl9mns5nowg6aBHUe0QUCDETlFcTsN3Vd+g6AhDW1
	t0+PPdVn0VXoKLO/NdWsu8xr8pa5SfFsPWlNHjagwF2HUg4Jwz/bTTtoEDbu5jNS5UXcqe
	/1a7m2ycQR5Rypiiam1nxF1Kid65dAD8mzMdsDqIpVAnb6rsDVnu+pzT2qXnlw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Apr 2026 15:12:47 +0200
Message-Id: <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, "David Ahern" <dsahern@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Shuah Khan"
 <shuah@kernel.org>, "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
 "Alexandre Torgue" <alexandre.torgue@foss.st.com>, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo Frascino"
 <vincenzo.frascino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <ebpf@linuxfoundation.org>, "Bastien Curutchet"
 <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>,
 <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>,
 <linux-arm-kernel@lists.infradead.org>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Andrey Konovalov" <andreyknvl@gmail.com>,
 =?utf-8?b?QWxleGlzIExvdGhvcsOpIChlQlBGIEZvdW5kYXRpb24p?=
 <alexis.lothore@bootlin.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
In-Reply-To: <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 891BDA0017
X-Stat-Signature: m5jbcunha7corsxxnsy7cu9kbskjkq1t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776172383-712314
X-HE-Meta: U2FsdGVkX18hCZgqfWCZ/knZs6Gp1UV9XwZn/WC2ycX2tPlsvvh2BfRqr3ZbbavNnixkFSflL9T0GDTLL3q8xmlcQY67elY7n8DNUpMZTreFF05xHPVafGYanOSI3ylK//x+uOXImfk9/OReQQum+MCHRdBY1RBSpKTvgcNzF9mWevqVOrChkgW1lnJABm/SmlPDbED/aHulUZe8ziBYJtSqOgI1zOLcoW03L5/d0Kf7UcD4aJi+idwx3KBnylC6ddsGWGtKnuyn3VjDRMcy4K32JrkRz769TS4d4pJnozBi7B4V2kenZNoVaBTSwFJm1zCO5UJ9E/CcqKJU7n1yfw8rFQHXK7FjLCg7Q9YT6AV/GZ/MqJ8w5pl4OMFDusFJ2llbhiyYGev+5CfLSyA7PgzymITaoD0GUPXNzoDbFIvlx9bTpCBk+ROhnnJfZ4JCjdrj9JU3w4glQbh9USmwC9Cx4CneQE8mSnx9Kc7pxN2YvhjbfjEioo38pTB9MRG1x/tjaxgaZFrUKvh4ClLFssKkM7UCq+y0605tlAq7AdNMb+7NkcVCnV3t35fLE47w88VFMRGsZbMKjQuynC0/9kv9cp6Q7aLROCoZNt8csJ5quIAvT8niv7rou1TMtdIGwsBWf45DXIDSf4HmdWrJEA7XigY/EzSBp1d6qu2tUx696QhXsPIcBruzmrtaFMWm8kVrZbQL+u3bIYwVlYOw6MhpEzvV3/0R+CWXnKjVcRQgpCIdbQAH+xdsgz39Ue7Az+ZF3JHO+UKzomkF3kDOBxPzRCIzcR5tWwULCC0Y/0D6iTESoq3wStzGEYzdD2svJ2gIz4QZEF40nR/eZU/xkGuUHCIvJZ/14Rfbi/PxxH5g+7D2d/P670+3lIduCqi3Tmn262b0wlNlgbX+w//pq7Xzh3jXAvVziRvmLYYBWCikkxk590OMEl2Zaa/d8YoRR1wumPUtGt9j8RMHWcT
 j8EptQwh
 AmXoi2Ay3ASLWsoMrHriElR93Y+2Wb94FozG0a7Uab5fT/uPw9ixQPEbHpwfTVG70b+0T5oP7BJ613ABMufFHmyRKg2pOTi9pRp4Z0nbjJ8H5gbsR/Z+GNlCZfuV6FriPwT+m53hvz+gFv5vWceo5mVx08liGTczeEDFghz01QPmigu4zrX1dkAaJ8wp+jSw3R+H15Fvak+ztc1UnnZREsfAb30CL2P4Jj8DjX75CwCPRkLK0iyxuD31tMx2XpBoCNHYgJ5X88ofbJn9JhZu45xra7eIXz1IJ5deggRdwdMuQ1NyvpPNIn7B+EhOdU5bS+mBR1KD2JFw5E5/e5ejFBTgr+gqM11ECW6RahO1r6/VXM33nusFSDPBFC4F6pFx77YRZTgMTT4ohk+e3SFJXuKnqpEVRdrJ/ABZWCf9h0ZzDAPS9xTU8PJz5RbvILCHY5wa/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey, thanks for the prompt review !

On Tue Apr 14, 2026 at 12:19 AM CEST, Andrey Konovalov wrote:
> On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foundat=
ion)
> <alexis.lothore@bootlin.com> wrote:
>>

[...]

>> +#ifdef CONFIG_KASAN_GENERIC
>> +void __asan_load1(void *p);
>> +void __asan_store1(void *p);
>> +void __asan_load2(void *p);
>> +void __asan_store2(void *p);
>> +void __asan_load4(void *p);
>> +void __asan_store4(void *p);
>> +void __asan_load8(void *p);
>> +void __asan_store8(void *p);
>> +void __asan_load16(void *p);
>> +void __asan_store16(void *p);
>> +#endif /* CONFIG_KASAN_GENERIC */
>
> This looks ugly, let's not do this unless it's really required.
>
> You can just use kasan_check_read/write() instead - these are public
> wrappers around the same shadow memory checking functions. And they
> also work with the SW_TAGS mode, in case the BPF would want to use
> that mode at some point. (For HW_TAGS, we only have kasan_check_byte()
> that checks a single byte, but it can be extended in the future if
> required to be used by BPF.)

ACK, I'll try to use those kasan_check_read and kasan_check_write rather
than __asan_{load,store}X.

Alexis

--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


