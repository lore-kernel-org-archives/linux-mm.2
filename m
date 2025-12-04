Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06358D1D88B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 08:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0D56B0005; Thu,  4 Dec 2025 03:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1C96B0010; Thu,  4 Dec 2025 03:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF5F6B0011; Thu,  4 Dec 2025 03:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBAC6B0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 03:01:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2E751608B4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:01:03 +0000 (UTC)
X-FDA: 84181042806.29.0063B9D
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	by imf23.hostedemail.com (Postfix) with ESMTP id F080614000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:01:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=cKTHayI7;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764835262; a=rsa-sha256;
	cv=none;
	b=EQf/R2O22XaLGUaLLccwkdiClKccE+2Jj2r5PVLc+K9TJXMvY1/YvfYvnwq83cl8R88bog
	81Na0mLgVSV4aMW+qPzJnZK/W3xUj6PdVEHVdbFI1IqvIi+mSEu2gZfUNqspJW15v5ehz5
	oQq5o3rSLUqcV2qHzA9ERjVodP+aZRk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=cKTHayI7;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764835262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4FXTFHzuPffFYRyp6V0hVOyP7tuWfTZncVwhcPuX9A=;
	b=EkXna9OnyahNm/S5hwwXTtUySdkqL9wnscZo0gtrIVnBVr15GYXNf8sxLwJJ+LBwpky0zJ
	N/bpjengEJj966WvG5KnEISqpJxhgnGa6hsmPkdnt7Dkc5xggCZRPARK3BjHQYJfi6TEyW
	ulR8W95XqkC/5c0iR5ezkl8hXvpUZqg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764835259; x=1765094459;
	bh=i4FXTFHzuPffFYRyp6V0hVOyP7tuWfTZncVwhcPuX9A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cKTHayI7NDW43zw81lUMTpPRn9uwQkUbRr+XYxDJM0qNryYWACf2aStPOFZN6prqY
	 v/mzdDGKBptFGjxNarTkl2bTp9fJcP1JksTFjOCDqj5uyG4LpLSBNMKt8CXZaSz0h0
	 tl4jVcMY2ifJaMmqdU9/XzsWFbyH11awkHT64+5FMNavyPQ1ooD0J0CkLAbaX32Hjs
	 HZXoe5w7chAGg6EUdLqoOHk6XOWkdu08tx5sgVjjeCzFsZvQrYRSKjaZvqcIH79MmM
	 nCuQaiw98Ytz7ZP0kzftNNs+JCtLPYailKgiRTH3unnBC5SdiYg+OzuWa5du4sT4BW
	 QAoXk4koBlPuw==
Date: Thu, 04 Dec 2025 08:00:54 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <yb3cniky6tpgwmdkp5652dzrbkkplkzsrywl76borcb7b4zmya@s4smffgybwgf>
In-Reply-To: <CA+fCnZeCayQN3448h6zWy55wc4SpDZ30Xr8WVYW7KQSrxNxhFw@mail.gmail.com>
References: <cover.1764685296.git.m.wieczorretman@pm.me> <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me> <CA+fCnZdzBdC4hdjOLa5U_9g=MhhBfNW24n+gHpYNqW8taY_Vzg@mail.gmail.com> <phrugqbctcakjmy2jhea56k5kwqszuua646cxfj4afrj5wk4wg@gdji4pf7kzhz> <CA+fCnZeCayQN3448h6zWy55wc4SpDZ30Xr8WVYW7KQSrxNxhFw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 25c7909c6bfc2f467818931ed514a481d5a0ae37
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F080614000A
X-Stat-Signature: 6oosmid3uwbg7ug96o8on9mtn4wqp3i6
X-Rspam-User: 
X-HE-Tag: 1764835261-957720
X-HE-Meta: U2FsdGVkX1+xCfTeBjFCFMqY93LaY93JophNYAEAUDER1v47hiYNhDXDQiMVNEqJLiKD0VeX6jwzH00jEKMwFsShCRHZ6VhqMZGAHo239RFTU0gP8YOLnBtAnZsRRmmlFd4Ad6B0PPRZ218IBMMLbh4MN20BPSZtfTJZ7jtBZEbh5tBFA2nMeZHFPoUWq80hN3h6ic3+5a9nLEh29JdTA0U9EdrHxtVRqy9cNNnlVjhoMkVh7qiORRdZbpHykyrz/9cFAlUZ0cGaQFwB0HeXUMEt61mH3RveM6lMPVPbu4WqFTNKy33E1bCe/pF42caHfnFrEX92e4jns3NVqmZzKngzZEye67eJYSZt5lA4W7PNEI6Z3goS474BmyIOlFyCMUZHS2Ss6wV9cFIFBbacieILG2X4I9q0HYNOW0V+VxhgLWTbnNrBNlXgkqkV5Crmh3LVwDN0Q0jbg4V5zMnA5TNtyb1wJlc2QUKa1CbQj/8VnM4kTo5QBIQ9clpvRgtVwQUk+Lb5UwVn11NnkZaZkDICJeltsdvhSqCrZ+yqUocg4t1IisV9/NLDWviKtGyH9OICcByNvcHmDyG6tLCvTGjl8yQaCUUFTyt1spikrDc/KHf6yFHmdGmn8FA/UMxnIPTlrz13xhEZ7Incz77gMvE3nf+fCNkK5H3WKqi/mRchOTywuWfQS3rS+V0tq5G6FNAxdix9h7dzEBaybRP5eOfe+zq2IG798DOnOh2EM/t7rk2apRUA2txV/u8j05ng7exlQw30XTAgAZeD6Ehcwc5iPSPnZlsnJ0hH1uFvILQ3uGsbEtsMDN5H79wt3TAg+a61Rv5sI/A80aP0XN+I1m/CBaj/OZvUvtcV76DlgSC+fHPfjmYSjizI4wumQ/ObGJjXZ/GPHiaguKsdWlsqk/kj5ihjQQRoC4IRvyZYKPtwXkcnWzWDGhsb0E/JpRvz32xHnh0a5t8hLrMrp0R
 D8rEI8ro
 7dzvGG/TkA6R3hTy+wQYlDSxydabBuWsc7di3DUF/0R1o1Gl+eGAmB7EoUVQvUiJojMjT0E/uy5dscYNnhcgsl70775KpDs7YhsKoYOPO9ohWDViJGljwwh5KB6GFZcBIcmWMmvyHdTAJ3uM791ucA4WhT+5ZSHA1qCeQZIOjP7uxSIS66VsZBn5e6MmFSsNkcimNhc4ooGmZgDoSAnFMAa3Ql7DB8B3ZFH6NF6gHZQ1wjYZ0luiL3iCPZ1rjmHZ1tJ93YDbJs3k8EE5qlZT7Y8uNZKqPFzRtpCL83PXMm5MGWXRtOOgu2VZZIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-04 at 01:43:36 +0100, Andrey Konovalov wrote:
>On Wed, Dec 3, 2025 at 5:24=E2=80=AFPM Maciej Wiecz=C3=B3r-Retman
><m.wieczorretman@pm.me> wrote:
>> I was sure the vms[0]->addr was already tagged (I recall checking this
>> so I'm not sure if something changed or my previous check was wrong) but
>> the problem here is that vms[0]->addr, vms[1]->addr ... were unpoisoned
>> with random addresses, specifically different random addresses. So then
>> later in the pcpu chunk code vms[1] related pointers would get the tag
>> from vms[0]->addr.
>>
>> So I think we still need a separate way to do __kasan_unpoison_vmalloc
>> with a specific tag.
>
>Why?
>
>Assuming KASAN_VMALLOC_KEEP_TAG takes the tag from the pointer, just do:
>
>tag =3D kasan_random_tag();
>for (area =3D 0; ...) {
>    vms[area]->addr =3D set_tag(vms[area]->addr, tag);
>    __kasan_unpoison_vmalloc(vms[area]->addr, vms[area]->size, flags |
>KASAN_VMALLOC_KEEP_TAG);
>}
>
>Or maybe even better:
>
>vms[0]->addr =3D __kasan_unpoison_vmalloc(vms[0]->addr, vms[0]->size, flag=
s);
>tag =3D get_tag(vms[0]->addr);
>for (area =3D 1; ...) {
>    vms[area]->addr =3D set_tag(vms[area]->addr, tag);
>    __kasan_unpoison_vmalloc(vms[area]->addr, vms[area]->size, flags |
>KASAN_VMALLOC_KEEP_TAG);
>}
>
>This way we won't assign a random tag unless it's actually needed
>(i.e. when KASAN_VMALLOC_PROT_NORMAL is not provided; assuming we care
>to support that case).

Oh, right yes, that would work nicely. I thought putting these behind
helpers would end up clean but this is very neat too.

I suppose I'll wait for Jiayuan to update his patch and then I'll make
these changes on top of that.

Thanks! :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


