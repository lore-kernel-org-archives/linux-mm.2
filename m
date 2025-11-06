Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3141CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209AA8E0016; Thu,  6 Nov 2025 10:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA148E0002; Thu,  6 Nov 2025 10:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9728E0016; Thu,  6 Nov 2025 10:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7A1F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:01:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9229014011F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:01:04 +0000 (UTC)
X-FDA: 84080494848.23.165CFC4
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id 35BF1140009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:01:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GDYgoEl4;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N20bsF88qmtxzuIu4gZ0s1r8sTe/QYH+2BKK9mK/6ww=;
	b=nRfBfhCQqVe6W0Wz1lf6Yg9gXVv+kjgu9Fihcx/OBKKpcOb3eU9hgUkPAL45W0AOkMUONB
	nvI31vT8goaIBkeI1Qm/HXM/hEUz+lNQzz6cxuTNSHKggAtKm9eD1xOnJBFf7dK0rt7QfR
	GjP1A13jYnGY3Sv5dyQmGYBYvOUYjsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441263; a=rsa-sha256;
	cv=none;
	b=ORiXDxk3S2sKMrBnf1o7punEIWNVhWZavrTkELW+2UcR7+7imI5Bdx57Xj2IBdrg1tXw7q
	7lzQl1zADtGul8tmkQry78kdOogcLEMui80q405lCIjeZXTgnOwIDsscdG0ahpgWNe0+Sf
	pR9rOKQSKuEICztfTLkXDx0X0FyfG9o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GDYgoEl4;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762441258; x=1762700458;
	bh=N20bsF88qmtxzuIu4gZ0s1r8sTe/QYH+2BKK9mK/6ww=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=GDYgoEl4LngLY9+ZW1gVaKIEyG1SHIh1SrAsD0+vRBpdfjCgYfaPLDAPwJfY3+yzw
	 FM3YmOlNxdYCwvJIbRt5N+t44b4i6tycDlu2qT+b9CTSO2CW3ZuVk4ODp1LRjvE+zq
	 U6/rFnbBoh6thQdjr+7rJvDv8h1HYgsLNqtsX7U/Z+hlsF5GCWKAjXB1dzGUj8uGhh
	 Z9hvn1NzeQJfGZMeqGeoKSj/c8khdplqqaypqby7h+36/mTHSXYtuOq4GYSm8VSr17
	 Wm6KvSW8MZ4R139G/SiBRC0gjQ5eTyQXUndhuv6XFYXclR1d11kW1EM+NN+7EeIvxE
	 JzF/g66ef3xhg==
Date: Thu, 06 Nov 2025 15:00:48 +0000
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <v75jgljobtrc6d7plw2x5caloipqkclfhh6w3quylarqrzczkk@5blzaptwme4l>
In-Reply-To: <00818656-41d0-4ebd-8a82-ad6922586ac4@lucifer.local>
References: <cover.1762267022.git.m.wieczorretman@pm.me> <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me> <00818656-41d0-4ebd-8a82-ad6922586ac4@lucifer.local>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 321924270825e08940ed773dce8975504f8a0244
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 35BF1140009
X-Stat-Signature: fw5x45ckgjzt6bhcjwyewh34s66wk8md
X-HE-Tag: 1762441261-322894
X-HE-Meta: U2FsdGVkX18iPIUYVWI6ABcNkdaDtx1Fzyt/hCfLcvc6EY/v8X2joO9k1dz86DnTLvtYgItcK+wh0QZADfscLASlBMaxZ38oeG/oTYFaLt5Wa3pBKiN+gXk5pW19DRSLiE8qZ6SxU4Zp1V1ju8f2jhy6+wH/WocAE2Tf6jUaAdjDOgOIlmPMu+wMKNVCeIYfBBUNGcsVqgloKWwqKQvU+uRavorG18YZL+mce/POi5VEPk2PJ2MruhSUH9AA4CmYZJIuNmIsSVBzyuPv/y2tfjN6u6NBoGhamuoYailYgs+FOWjxgbi5up6qnnzFyUtcQWsTPSIt5qcxuYE0LYjmncgcaqEfwaXq9JzKQk2pNDOkxXZbmlmEdDJUg3nD8Y4/bXbIzFprc6oiHyT1lr4N17OiYn+taFfS2wBHyl8UYzTzSfzKlPcEbMNg0Z8TbtgF9+gxtahosS+7C8y/7R3LJfFDgTIt4OLHEzJoSPKoOs9pF754YPiK9/wbnBmE1tRVGyreiZnt6Kx/djQbHV71uxXPkyiobophLG6J5dnjGlSSIaM7hTBnbnSOU5QJ1fndxbibhNpHDk/Y7oNLzokOvMqq2dWGxHw9hsJg+G5U/thl3tP0UpROrP7D/yPCnLts5AVbCrcCsWl8pGRNCvV7ZqVQ1lvbGhGCZvEiYL7ovf5utJSdJj6z+/hLCthmKZFvZ1FowfI/kcZ87a3SO3h+bW5E/4yxsbhBfmmMiKClT7m5ioBIo11kp1Y2AWlPZBcxG6W9lFEhuPB3mvoG2q2HR3MT6sTJaXwjUk4bwagCt6h7vJGsBQ8ga4hLTMCRhddn1yvOPvtrF6lKbd9z2+SYTi3VSK6DPvphZcz794eVBt8CS/xstRmxSMLR1BZUIBS9BDC2zYLSBzcgEuUCGYu4jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As Andrey noticed I'll have to rework this function to be a proper
refactor of the previous thing.

This solution seems okay, after noticing the issue I was thinking about
adding a new file for vmalloc code that is shared between different
KASAN modes. But I'll have to add different mode code in here too
anyway. So it's probably okay to keep this function behind the ifdef, I
see shadow.c and hw-tags.c doing something similar too.

On 2025-11-05 at 22:00:41 +0000, Lorenzo Stoakes wrote:
>Hi,
>
>This patch is breaking the build for mm-new with KASAN enabled:
>
>mm/kasan/common.c:587:6: error: no previous prototype for =E2=80=98__kasan=
_unpoison_vmap_areas=E2=80=99 [-Werror=3Dmissing-prototypes]
>  587 | void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vm=
s)
>
>Looks to be because CONFIG_KASAN_VMALLOC is not set in my configuration, s=
o you
>probably need to do:
>
>#ifdef CONFIG_KASAN_VMALLOC
>void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>{
>=09int area;
>
>=09for (area =3D 0 ; area < nr_vms ; area++) {
>=09=09kasan_poison(vms[area]->addr, vms[area]->size,
>=09=09=09     arch_kasan_get_tag(vms[area]->addr), false);
>=09}
>}
>#endif
>
>That fixes the build for me.
>
>Andrew - can we maybe apply this just to fix the build as a work around un=
til
>Maciej has a chance to see if he agrees with this fix?
>
>Thanks, Lorenzo
>
>On Tue, Nov 04, 2025 at 02:49:08PM +0000, Maciej Wieczor-Retman wrote:
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
>> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
>> It was reported on arm64 and reproduced on x86. It can be explained in
>> the following points:
>>
>> =091. There can be more than one virtual memory chunk.
>> =092. Chunk's base address has a tag.
>> =093. The base address points at the first chunk and thus inherits
>> =09   the tag of the first chunk.
>> =094. The subsequent chunks will be accessed with the tag from the
>> =09   first chunk.
>> =095. Thus, the subsequent chunks need to have their tag set to
>> =09   match that of the first chunk.
>>
>> Refactor code by moving it into a helper in preparation for the actual
>> fix.
>>
>> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
>> Cc: <stable@vger.kernel.org> # 6.1+
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> Tested-by: Baoquan He <bhe@redhat.com>
>> ---
>> Changelog v1 (after splitting of from the KASAN series):
>> - Rewrite first paragraph of the patch message to point at the user
>>   impact of the issue.
>> - Move helper to common.c so it can be compiled in all KASAN modes.
>>
>>  include/linux/kasan.h | 10 ++++++++++
>>  mm/kasan/common.c     | 11 +++++++++++
>>  mm/vmalloc.c          |  4 +---
>>  3 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index d12e1a5f5a9a..b00849ea8ffd 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> @@ -614,6 +614,13 @@ static __always_inline void kasan_poison_vmalloc(co=
nst void *start,
>>  =09=09__kasan_poison_vmalloc(start, size);
>>  }
>>
>> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
>> +static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct =
**vms, int nr_vms)
>> +{
>> +=09if (kasan_enabled())
>> +=09=09__kasan_unpoison_vmap_areas(vms, nr_vms);
>> +}
>> +
>>  #else /* CONFIG_KASAN_VMALLOC */
>>
>>  static inline void kasan_populate_early_vm_area_shadow(void *start,
>> @@ -638,6 +645,9 @@ static inline void *kasan_unpoison_vmalloc(const voi=
d *start,
>>  static inline void kasan_poison_vmalloc(const void *start, unsigned lon=
g size)
>>  { }
>>
>> +static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, in=
t nr_vms)
>> +{ }
>> +
>>  #endif /* CONFIG_KASAN_VMALLOC */
>>
>>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) &&=
 \
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index d4c14359feaf..c63544a98c24 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/string.h>
>>  #include <linux/types.h>
>>  #include <linux/bug.h>
>> +#include <linux/vmalloc.h>
>>
>>  #include "kasan.h"
>>  #include "../slab.h"
>> @@ -582,3 +583,13 @@ bool __kasan_check_byte(const void *address, unsign=
ed long ip)
>>  =09}
>>  =09return true;
>>  }
>> +
>> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>> +{
>> +=09int area;
>> +
>> +=09for (area =3D 0 ; area < nr_vms ; area++) {
>> +=09=09kasan_poison(vms[area]->addr, vms[area]->size,
>> +=09=09=09     arch_kasan_get_tag(vms[area]->addr), false);
>> +=09}
>> +}
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 798b2ed21e46..934c8bfbcebf 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigne=
d long *offsets,
>>  =09 * With hardware tag-based KASAN, marking is skipped for
>>  =09 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
>>  =09 */
>> -=09for (area =3D 0; area < nr_vms; area++)
>> -=09=09vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->addr,
>> -=09=09=09=09vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
>> +=09kasan_unpoison_vmap_areas(vms, nr_vms);
>>
>>  =09kfree(vas);
>>  =09return vms;
>> --
>> 2.51.0
>>
>>
>>


