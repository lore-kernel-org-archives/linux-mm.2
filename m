Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC26EE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 20:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15E86B0089; Fri,  6 Feb 2026 15:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3AC6B0092; Fri,  6 Feb 2026 15:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFE26B0093; Fri,  6 Feb 2026 15:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA3586B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:14:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D957D5A13
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:14:33 +0000 (UTC)
X-FDA: 84415134426.10.8FAD26B
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A2C41A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:14:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=U3OzgVFZ;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770408871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2kf5hPOrCDamoohAxbiRlLxvzqHhWFTaCpLlhR4Cz4=;
	b=lEaFnkgmZeLQNDjyMhDlUZ7709HPiJVrmbLTUFhbHH0tjFmRuFdiCnCXyTt+iDr2T6GoXy
	VWnQtaxm4Npywg3/zVnmyPvT7fv4jxb/UJbipHz5v/UizC3Gtg+qunZYp9qJBHWkc7p9+H
	GrtAJIGm2hghhE1eRPasynr6v9gxPZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=U3OzgVFZ;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770408871; a=rsa-sha256;
	cv=none;
	b=CiiIKCn5kTJphVWa8A2E0vETevzAdOUHAl+DY29n1XJaJQ9BWyj+Qj3q7TlApvYty2kWxG
	KDA4EcCE0813JKM8Y5SaMIvPrvgvjSKHTvssRTKxWFsnq8HijfxFNYn9ss3VkiuYeML/Lz
	pHMahM1qGO/aCNGX/pgIhhvlRVZIeRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1770408869; x=1770668069;
	bh=+2kf5hPOrCDamoohAxbiRlLxvzqHhWFTaCpLlhR4Cz4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=U3OzgVFZIBr2yWLIFkvp+qLJ7OMU6WbgtRgbzfX4LqC6mVdkXIMJrXNRXNe3TsHhq
	 K5NTSR6IUNcyBaLdYZdB5va7AujRYtoCCDYv19ga8/F2Gt0nImbnW5RbeowaTtVa51
	 iEVFwkVor7mRHd9qQIky1IugJvDxWlYmz7r0BCaKNn45/R+1mveiTA6Vjz9f6ScRlf
	 sHGcxqYzU+ut0w9qC6gn04zQs1b0j6U3rlZ1XZ+zQV/EAw/Gs65r7xMCQOWVim5J4A
	 Ppny34ZP68kBUYt2gPF4VXGKSaHKWpFCtxcckR+0/mJHdTfLyFz7SW7bpDx+/CIz4H
	 BfIQ793ycU++g==
Date: Fri, 06 Feb 2026 20:14:25 +0000
To: =?utf-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, Andrew Morton <akpm@google.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: KASAN vs realloc
Message-ID: <aYZJ2Ohug6b9Vth0@wieczorr-mobl1.localdomain>
In-Reply-To: <CANP3RGeHnhufYyc0P2OiKJbXdZjPW41TP=JS6nYk9xGRU8UuKQ@mail.gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com> <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt> <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com> <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com> <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com> <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain> <CANP3RGeWLMQEMnC03pUr8=1+e27vma1ggiWGWcpX+PcZ=SsxUg@mail.gmail.com> <CANP3RGeHnhufYyc0P2OiKJbXdZjPW41TP=JS6nYk9xGRU8UuKQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: bd556a4a64f26ab613af6dbc5d550912c9ffd249
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: a6p9mikhnrm3o5fpx4snhrhws3kpcz4r
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A2C41A0008
X-HE-Tag: 1770408871-882931
X-HE-Meta: U2FsdGVkX19DOR3/9PpbjforfrcyOZgyAtMs7GsmcGqaRu6cDL22T3lcPxZPgyoYPnMHdzvSdy+tghctgu+337xrk4g4gzMk5x0klxeSArpCHgzf+GgPOupIXvjjpzU6wR084jPYD3tSzbkrPK9F9lMD8bzZW6FNFEJeep8iqMyb08blP3Z7OWFUURK1M7DWf6VJeAoiJk5yiGl908D9Zy+c8mY9UTtfw9A5uMGf8GketVks9t8IguRKOn+obocCpcFVdFmfsOO+16rwGpGArLywwFgUhIY4CnTa7TzAcMsOM+ySrHyYAze11kBGKfJVG5mDwhkeoTU+0573/sQD3yIKCOPbL9RoKV1Rgch3VE1TPeJ687a/ABQAkagGER1iOVuD3iOLmig1fkIQOAzw8lUYFMp3vYLT6J322AySkjkYyWZz5rq4NoisR43QYAuV6kzYZz7uUFxuIuFuQDg9goZP9GBuAFS9TJqeuT62W8lQJ+zWA1XMkNnvBvM841qt+NOaYT9ketDT3OmAr0cU/KWX/TfRQ5+Rb/uyspo75q8+H9Cwyr4VZPt9s8bt28JgFYCyK2xuWkU1DwyWQGSr3Zwepa6jaz1fn/mPtOZ3V546AeJzLdBgl9Vc56mYmRr9bVgX/FcgoYGvZy69/mRqmLt4ive3+wCiH+PykNTgQ/3ODk07nrzLLZYIaXmyuo/lcBAXkrzmfEQJrhTe0RX1i+RwmKtSYr6zbv31u5pi+lPbF4YR52MukqMpO5ob9huThowp96UgSWPByZgQFMqqV72UpjrHSvPzzk2hKCWiejiZSXX8KBEIHieLMXXvlNTfgyLfeNepNb6R9WLsIHOyzxT8bHlAYlehuFo/cPAtZAIxDGnD/ZG0zq7IbrVaiC5aOnWrd9mk8YTBbSMfBu/81gjnNxGJJCjafsfetEMCmObmkZ4vPqankf5f38pI5Jyenbmv6doCJz+jxxYV4ab
 AnJzpDDA
 VpvzCDbneRiB+xC3yamiiYISqNHGr0S3lwb9qnx4xN7WPIrSB7KZ9DnL5JZ4WpOZod0rUKi86YE1r0aYvSU8vah91MMZ4vmTk4RDy2Fsjh7a7nLCSFZaXYGZrrI7X5gUL0+3u1p1zmO2oOw5fGwQr9yO7zlQOQqK34NxqEzUQbz/3762pVA8PmJ6WmY+NfoQzj3j35UsomivySsO1xtH1kZk/FnqMBQITh0oRzuEaGsGSZtURCl4IPs+j1coI3Ac+X7NFY66qFaxeAVV4V6YOWXJSeBO92eAsB0IacKzW3+EK3Z8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From what I see kasan_poison_last_granule() is called through:

__kasan_vrealloc()
--> __kasan_unpoison_vmalloc()
----> kasan_unpoison()
------> kasan_poison_last_granule()

and the arguments are "addr + old_size" and "new_size - old_size" so it loo=
ks
okay I think.

On 2026-02-06 at 11:07:12 -0800, Maciej =C5=BBenczykowski wrote:
>While looking at:
>  https://android-review.git.corp.google.com/c/kernel/common/+/3939998
>  UPSTREAM: mm/kasan: fix KASAN poisoning in vrealloc()
>
>I noticed a lack of symmetry - I'm not sure if it's a problem or not...
>but I'd have expected kasan_poison_last_granule() to be called
>regardless of whether the size shrunk or increased.
>
>It is of course possible this is handled automatically by
>__kasan_unpoison_vmalloc() - I haven't traced that deep,
>in general these functions seem to have a terrible api surface full of
>razors... with hidden assumptions about what is and is not granule
>aligned.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


