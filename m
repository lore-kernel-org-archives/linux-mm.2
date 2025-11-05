Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C29CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450ED8E000B; Wed,  5 Nov 2025 06:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4016F8E0003; Wed,  5 Nov 2025 06:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3171D8E000B; Wed,  5 Nov 2025 06:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC2A8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:13:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9F7B1602AA
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:13:10 +0000 (UTC)
X-FDA: 84076291740.22.256F05E
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE19B160002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:13:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IynIMTyr;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf08.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762341189; a=rsa-sha256;
	cv=none;
	b=O7o2VZYlVUWbOw1K0ntiRPkECGgEqFcBKVXzcTs5UlzCc9t0tf4hsWJ5kDKRviWOnf8/hR
	0Nt7HrD+l+XYrd61j11KFlUGZktnVtf51I3rfNc71QXV9tmjhMeoWD7SY0uJLQ3gytg/xz
	Zz64PQo5TQMRgM3jGun9/P4cR+tKhOA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IynIMTyr;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf08.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762341189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhOL772gDQt3HjlEW0CKt9Wxom0RYSxrQeQWZ+rjImo=;
	b=2T0XfUOZAQY8LvMTKL4nBINl/76MZ2I0eiFFBXN/NIQH0hpfkA1fTpYRJmRGVHAsezwcka
	rmCaVxb2tPchgO18lDe3eRldi/vHcUcn2OJ8KhVCuBUiAmyAPjmBTMHjsWnkoahgqkwdpX
	Gd2OFuaPNtljcoxswmxl3F1Whs9lWHU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762341185; x=1762600385;
	bh=MhOL772gDQt3HjlEW0CKt9Wxom0RYSxrQeQWZ+rjImo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IynIMTyrNWBlf4PhOmhXwPzcshBVn1bvwsGpIzoT+fFZDNBYsCY4t116aDu5ENCsc
	 u9OIwrF5zikcMNOI4NqGkovwN0zaLpnRkdAi8buGUu73pc2/Lx2E8WX5oO+yea9aoQ
	 Jy2u/U/p3nX5d7IeaKkUJWrgP2GiCNnwyU1Nu06Ej/WO2Wsa7jSSvRL1WJ7F0NOKiZ
	 mWJD/b9C6YCsfwZIqlOUqqKmByhU1SzSAlsOWuMpaoyOBxMcPIsTZ/mOrIT9Vx+eLS
	 KwGAJ9Vk6UVm3LoycXsk4/SVrr2juYIj0IrzoyNXaIdWOPk5qqNDZzq/L2wnbxUb/D
	 RGQbgT+gxlcEQ==
Date: Wed, 05 Nov 2025 11:13:00 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <cc4xh64s47ftujtp76hizmjqaczbgpzvmpbtzjtya2tuqyc75x@3obiajea2eem>
In-Reply-To: <CA+fCnZdUMTQNq=hgn8KbNwv2+LsRqoZ_R0CK0uWnjB41nHzvyg@mail.gmail.com>
References: <cover.1762267022.git.m.wieczorretman@pm.me> <cf8fe0ffcdbf54e06d9df26c8473b123c4065f02.1762267022.git.m.wieczorretman@pm.me> <CA+fCnZdUMTQNq=hgn8KbNwv2+LsRqoZ_R0CK0uWnjB41nHzvyg@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 9bc93b4823ad8fa97869a332ca0a7f37c2bec3e2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE19B160002
X-Stat-Signature: gyo6twcd8fhk9g8es79x4cwseiimpppr
X-Rspam-User: 
X-HE-Tag: 1762341188-857851
X-HE-Meta: U2FsdGVkX18xZeTtmvJHjkEt16FBtKLgxHpddEyENWMPaE5wkVbY1JciM2LrQngzCvnVhX1we62xONTYrIiJ0OlkFSRzTpaP9lRomlPicI43AOH6Ip72+JTvU27hzVvjjCsR9fAOontgBoZkRZoe8PipKygUEL9d3s/JcBW6mek/3y0puFSqniN0UAkya+DgckC8i3r911gzJL3yU+oDAvGVrFZ7xXG9ZRnecd2PKwNtrJQovIeT/VJQt6GOmtI09dN50BoYI7JztFlPXEL62CGnyjNVXlvG/TBJy79ogm3vQCrn9NUhxDrW9HWpLkH2lcgDUNHJus9W+S5+HMWfXz/JnHiSE7RcSobt+E/KpdUrO9T1Fr338LgwNhwgMkibdbkFE7VOAul5DbGjCv6O5/SiBZ/++bog8yWNHUFEOyNqQpEs1uz5+2iYa7BmLoXPXWGiDtQgA3UQ+EtPP70j6YYTKv2IWSLB5tn2/CMaj0MYNUl5i0iFhR7v1+ma4SkN5JOXKdeBdJIIfYHaln+WA/4rU7ZMz0xZdm6PYCabUdizWITzAjiS4aL5PBepB9qeDCXjEZWz/gv9E0h/a6Fvpum+oX0m+iE2mHE2V/NWdZaDFLdAbKuPO+Z+qFWFcnSHhxC4GnXs344cI7pw1f1SKTJ1MIdVqc01ycbMukE6FViLGlxf7V5EkZEVcwWjpyFEPsZ7jgio2qyPzQCW6s7aGmiDpdC4TPnw9AfoQDIi5hAypaqU6XkJbCD1awF/ZAFugetAsLVSjAtV4U3z8U5SfGlciNhm9NXOQM/ud98u+HbaEFtlOKfK/XtmWAax/DB3YKw48WBLSJIv2dBESPCw8VBan2kwPo6nDin+b1/KNC1jWf7VRu/gEaCiG9z41kTeV2KvctJpwIhSFTTL1Jzmm6hXDwngXnaYFouYGDmIarjIEI339lAom8RQxEDSFfWFdjR0by/V6wxUNqOgcRq
 bmjlSZpP
 2dG7r5j9H55QswEx07p2vYNRd0sWRjCn/06Gf3aXqEb+9P84Xc3z9Fv+E1iD1FY49o82PyteRohGuVc5k1qaRUibCLhm59/CB8HpGoAfo4MT1n/JpFAk+8Rie6/NA/q/Ba5IM5Xv5zkwMg/sbxqytxCzCZmgCvabeAyvE7Lfr8buHVSdthIQM4E+VV5HpOKkrlOsMxPlqE/Ou3kSKBLSXjA1E9uWA+9/5aOKIQ3DN68x/TUXEytJuAdGGRY+WEKLx7aiSGf8O0AhKipr9kzXE+ZFd6zK5W9rmWh8XoIdHSxm6r5NDgFosVWImStyQthWFQ9pS5kO3ewKYvi0mo0XMsCQGchmx2i0IrAIJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 at 02:13:22 +0100, Andrey Konovalov wrote:
>On Tue, Nov 4, 2025 at 3:49=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
>> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
>> It was reported on arm64 and reproduced on x86. It can be explained in
>> the following points:
>>
>>         1. There can be more than one virtual memory chunk.
>>         2. Chunk's base address has a tag.
>>         3. The base address points at the first chunk and thus inherits
>>            the tag of the first chunk.
>>         4. The subsequent chunks will be accessed with the tag from the
>>            first chunk.
>>         5. Thus, the subsequent chunks need to have their tag set to
>>            match that of the first chunk.
>>
>> Unpoison all vm_structs after allocating them for the percpu allocator.
>> Use the same tag to resolve the pcpu chunk address mismatch.
>>
>> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
>> Cc: <stable@vger.kernel.org> # 6.1+
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> Tested-by: Baoquan He <bhe@redhat.com>
>> ---
>> Changelog v1 (after splitting of from the KASAN series):
>> - Rewrite the patch message to point at the user impact of the issue.
>> - Move helper to common.c so it can be compiled in all KASAN modes.
>>
>>  mm/kasan/common.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index c63544a98c24..a6bbc68984cd 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -584,12 +584,20 @@ bool __kasan_check_byte(const void *address, unsig=
ned long ip)
>>         return true;
>>  }
>>
>> +/*
>> + * A tag mismatch happens when calculating per-cpu chunk addresses, bec=
ause
>> + * they all inherit the tag from vms[0]->addr, even when nr_vms is bigg=
er
>> + * than 1. This is a problem because all the vms[]->addr come from sepa=
rate
>> + * allocations and have different tags so while the calculated address =
is
>> + * correct the tag isn't.
>> + */
>>  void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>>  {
>>         int area;
>>
>>         for (area =3D 0 ; area < nr_vms ; area++) {
>>                 kasan_poison(vms[area]->addr, vms[area]->size,
>> -                            arch_kasan_get_tag(vms[area]->addr), false)=
;
>> +                            arch_kasan_get_tag(vms[0]->addr), false);
>> +               arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(v=
ms[0]->addr));
>
>set_tag() does not set the tag in place, its return value needs to be assi=
gned.

Right, not sure how I missed that

>
>So if this patch fixes the issue, there's something off (is
>vms[area]->addr never used for area !=3D 0)?

Maybe there is something off with my tests then. I'll try to run them in a
couple of different environments.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


