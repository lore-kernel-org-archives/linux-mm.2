Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0ADD0D172
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DC56B0092; Wed,  7 Jan 2026 15:47:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B616B0093; Wed,  7 Jan 2026 15:47:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318856B0095; Wed,  7 Jan 2026 15:47:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 209CB6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:47:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF20FB944B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:47:55 +0000 (UTC)
X-FDA: 84306354510.16.E76121C
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7FB7100003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:47:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=HrnCPams;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767818874; a=rsa-sha256;
	cv=none;
	b=xF2aEgedSAxUGYdzwqgw+DhdQjKTRJEZ+z4gMZ5sNROJHLAEr11IiJIiNvL8uydi62oAk/
	/VYvGwCSx9Fx0cFTUFDLFgnjG1YIDFPBAZyn5fm0bM6vzr9kb1Mt30HaLiE3/Y8sE2UiXY
	DD1LibKabeDrgIZYgXHK5kCR8u0R85U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=HrnCPams;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eso9ElNo5qBp7Bizk6jVYXP8Y8WMkmD3C4PN6vDbFik=;
	b=OZZ7pUU3xObFTDHTAuWjZKBbyMZnoB9qSQfcju/ar6n2jeMUzjYgR5BRGEXsFj0ZXS38FL
	R6/dWnpizF+dOdGW3hn2jbgu28X0ZZgBM5VqQX9EYSVUh75qa0nYEzI+gbpCj5gL/TbOoE
	HI+mURuAmzeAq54HC1SyDfGwoubp4NM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1767818870; x=1768078070;
	bh=eso9ElNo5qBp7Bizk6jVYXP8Y8WMkmD3C4PN6vDbFik=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=HrnCPamsU5lr+cZ6d2dDIGTIHUfSPse6CKlllr5JaFbRVANQZY1Jg7E2b5nqNEKq4
	 7teUtVlHNOAP2arwCjDYG36nfbgfG97uHIMdKd+Eq4n0hmgJmkiN7y0WY6BqItthr8
	 k0ePdfFdVS01q9OQAodwqdk58tWolPSWmZyqmFHiv/2EZMs8vv0OjTFVkCG6ehA/nA
	 8kyocBN8Wa6VNgTFdgpqRRBV0YWNmCHwdvZBIffNwzbBHZ+fW32NJI2/3b3HkrB9G0
	 PE25qICSdnCXTgFAOS78aJhpPJJkgckrXCZQxJIrtrEYBYwMtycEcI7+OQuuUMlpEE
	 +WnF7s3uuuqTQ==
Date: Wed, 07 Jan 2026 20:47:46 +0000
To: Kees Cook <kees@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: =?utf-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, joonki.min@samsung-slsi.corp-partner.google.com, Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: KASAN vs realloc
Message-ID: <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
In-Reply-To: <202601071226.8DF7C63@keescook>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com> <202601071226.8DF7C63@keescook>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 653d54c7561a9f7268c6702e5a88189d6c4a52ac
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7FB7100003
X-Stat-Signature: txsqwg99f9j6833my54jyqwz3guxwqbd
X-Rspam-User: 
X-HE-Tag: 1767818873-145600
X-HE-Meta: U2FsdGVkX18/AAWkRdspko5G8ZyC9EbhBlV4hBFuuQF1cU1TL7FB/mo2HTcH1/UspB7YhZ1Pl51Ww3taiwMexUqF8ktk2VkG73/wv/CebyFjT+ccMMSTe3uJCRsi8tIJ9zvZmQdLkvWjBDvt4r6Kp7JMktDLSNsPv4WigKPIf82HgQwky7mvttKagOvWnj6D60X3dOqCUqkyiksRIO5marFeu6V6m24eO3rzHndCgyHmTwS7pkiEcwYDZ/eiFF0gQlOX2fFex2xFf4gD02yVXRKHUIRLJT8HpYchG+l4uvnEoSTBTaDvU9CLRhW2Vh6cBHikHqhIzj7TbHZFdlc2o7Apy1k4OxeJPJf9iYBXWSgg39pYNx3653/CUaDnLI7qOuvgaCmGC8wl54+YmbX8n85QE3QijXO2YobEDL/mcozvsG3+ZGEyLnsm0acEbPSi4p3PKwNTS/jaP2nkvG1YZAezWa0zPU0u1Eb25813Glt8172GGemvP0GKWpXhJTjCg0+2MXCTX2jCVveoB9gUdEX/laa/X/G20RAP/Zc82QL1qk+28nNXWqSviWPRu1n1uV4G+AGV04Qna8m1xP5B/6KkCjy6TpaGT/sqc05SmpatVSz52i/3Xu1++cX4+jQDuJil0x+tbDJsUYtOpLdl6ZI76qM0t10SIWUugmQuGwCpxfUR7YWg3vhM2D4q5VrXKLSJhQzMltVPsIV0RcpmH5TcuJxiR9T9aJBLluCp3Cv38pan4SEcMjNhNzRjtDMD1UI+fAERsohXCBJ4E+qGYDukuTRu/s0Oko3sWO8aE4nD25mOzDaafaZhNwrQeq3uLL+CqdXYE/WlCd8N2TVDJ4sICMuL+ytkVS9+ZTCxYsoGWJKqARKtK6eBX0gOZBesTytgL9tkn35ZUN8wyFmMku4/nzLfLn0xuUGzehy/DaVkaTtmsye5AfTN4XvfaBaFOh3i8Y1XsOQ7sM07412
 wUod/cJP
 XfyGmNrHtC2Um8ysM8Z8rY/zW3v6WnmbwLTJwxV11v/Y6fr+Ctll6rbIqLCElMwpwsWJSIzyw4IuRPeIDjpbhRxRHqUlf+QEOfhvKZRWIGOZfm6pH0NrFxzfjaB+vyLFyXphZNHoTBqrYF/9mUZfqplZy13hlN1waAiCDh8IMwmxoror1Ztdub/qLu4Z4iOziNpEMPxA8TYNItb4gCAImd5GNBZ3lGxIdDU7yFAkBTJCD9EO/eeW0okKY9uwsxvIABWZSggbd5fXDqlV3bSuK6nwfGUBfMspScCv4yH1q+hRFmwaeyUg9De7Xey5dzzK2APvcEEQL0YV9DBbeGo/SOOcD/cp+FnmqPyP6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-07 at 12:28:27 -0800, Kees Cook wrote:
>On Tue, Jan 06, 2026 at 01:42:45PM +0100, Maciej =C5=BBenczykowski wrote:
>> We've got internal reports (b/467571011 - from CC'ed Samsung
>> developer) that kasan realloc is broken for sizes that are not a
>> multiple of the granule.  This appears to be triggered during Android
>> bootup by some ebpf program loading operations (a struct is 88 bytes
>> in size, which is a multiple of 8, but not 16, which is the granule
>> size).
>>
>> (this is on 6.18 with
>> https://lore.kernel.org/all/38dece0a4074c43e48150d1e242f8242c73bf1a5.176=
4874575.git.m.wieczorretman@pm.me/
>> already included)
>>
>> joonki.min@samsung-slsi.corp-partner.google.com summarized it as
>> "When newly requested size is not bigger than allocated size and old
>> size was not 16 byte aligned, it failed to unpoison extended area."
>>
>> and *very* rough comment:
>>
>> Right. "size - old_size" is not guaranteed 16-byte alignment in this cas=
e.
>>
>> I think we may unpoison 16-byte alignment size, but it allowed more
>> than requested :(
>>
>> I'm not sure that's right approach.
>>
>> if (size <=3D alloced_size) {
>> - kasan_unpoison_vmalloc(p + old_size, size - old_size,
>> +               kasan_unpoison_vmalloc(p + old_size, round_up(size -
>> old_size, KASAN_GRANULE_SIZE),
>>       KASAN_VMALLOC_PROT_NORMAL |
>>       KASAN_VMALLOC_VM_ALLOC |
>>       KASAN_VMALLOC_KEEP_TAG);
>> /*
>> * No need to zero memory here, as unused memory will have
>> * already been zeroed at initial allocation time or during
>> * realloc shrink time.
>> */
>> - vm->requested_size =3D size;
>> +               vm->requested_size =3D round_up(size, KASAN_GRANULE_SIZE=
);
>>
>> my personal guess is that
>>
>> But just above the code you quoted in mm/vmalloc.c I see:
>>         if (size <=3D old_size) {
>> ...
>>                 kasan_poison_vmalloc(p + size, old_size - size);
>>
>> is also likely wrong?? Considering:
>>
>> mm/kasan/shadow.c
>>
>> void __kasan_poison_vmalloc(const void *start, unsigned long size)
>> {
>>         if (!is_vmalloc_or_module_addr(start))
>>                 return;
>>
>>         size =3D round_up(size, KASAN_GRANULE_SIZE);
>>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>> }
>>
>> This doesn't look right - if start isn't a multiple of the granule.
>
>I don't think we can ever have the start not be a granule multiple, can
>we?
>
>I'm not sure how any of this is supposed to be handled by KASAN, though.
>It does seem like a round_up() is missing, though?
>
>-Kees
>
>--
>Kees Cook

I assume the error happens in hw-tags mode? And this used to work because
KASAN_VMALLOC_VM_ALLOC was missing and kasan_unpoison_vmalloc() used to do =
an
early return, while now it's actually doing the unpoisoning here?

If that's the case, I agree, the round up seems to be missing; I can add it=
 and
send a patch later.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


