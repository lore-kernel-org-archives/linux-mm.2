Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711C4606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cJVSDYyj
Received: by kanga.kvack.org (Postfix)
	id 0D4E96B05B1; Thu,  5 Nov 2026 02:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085C36B05B2; Thu,  5 Nov 2026 02:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04D46B05B7; Thu,  5 Nov 2026 02:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1E586B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:16:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A85A0C0965
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:54 +0000 (UTC)
X-FDA: 85400208348.16.872A3B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 211CC140002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJVSDYyj;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793863013;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yklh8vYj0UXnqUyJIMwNZihY2Dzfm6RgE/a4D51hGLA=;
	b=o4m1cDeh68I0zc6F4Lhi9dS8gxIiuRk1A+dP8epGSTjq/M5+ojH9SaApwXPEeJwpWSrBFp
	Dqt9fVmh+N0lIoeiqj/x5SuVeOe/hGSsrk1lk8hN0PBNgbywJ64/GKinsxxv8nOpU4TSNf
	DrLglHJ52IYMkQRLpjjufbp6pkPaf7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793863013;
	b=4JHWao5VK16W/r5ONliQhsg3YggFHcRkFUV9yhBTH/bxCjmpfwNhx1jzRrzKQvg9PRre1w
	iPbeYRZg1XDtMgDdop9+iCt1QCYU7IVVUT8wDZCc+Yd4fSfUtuib4ySpiR/HamSw1Xra2R
	+CKIf/WCYLJxuxEtiXyDgWzmFyK45HE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJVSDYyj;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4DDF60267;
	Thu,  5 Nov 2026 07:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFD61F00919;
	Thu,  5 Nov 2026 07:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793863012;
	bh=yklh8vYj0UXnqUyJIMwNZihY2Dzfm6RgE/a4D51hGLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cJVSDYyjPXxstNjrsuGugagaGgQ+jN6u/iQbhDVMB9vHl0dlcgSN//irWMcliniUf
	 DzqL0d2K923Rjhzg+kwmmwZACl0/K0gGEd8G+S6/nD15Zw41+/H5tHLm3cF5GmeQHf
	 67GOy6/LnCrqkiW7iuVGjcsAWdI4PdFnOzz95ntvua1ml/IVHo8QE9A53g/SxlcTEF
	 knGz6a9U12Xprvd6kccYTTnQGU34mEABNQEW6sxNE7ZeyzCy9bWxdQWrR/Qk+9XSQz
	 zkr1j3nYw3fAb67N72l9phZdDowwf2OF76J5UDIJZPmZEiv8DQTxscO2kJnoxKS0hN
	 ABx0DLIvEDEtw==
Message-ID: <sashiko-outbox-198654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "David Hildenbrand" <david@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Mike Rapoport" <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Lance Yang" <lance.yang@linux.dev>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Qi Zheng" <qi.zheng@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Huacai Chen" <chenhuacai@kernel.org>, "WANG
 Xuerui" <kernel@xen0n.name>, linux-mm@kvack.org, x86@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261105061217.13302-5-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
 <20261105061217.13302-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 07:16:50 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: udxwwmye6fr5b87tcqrirsait5s1wrdj
X-Rspamd-Queue-Id: 211CC140002
X-Rspam-User: 
X-HE-Tag: 1793863013-952233
X-HE-Meta: U2FsdGVkX19uyF6WzN3z0CPtkqq7nyCbbhWVmOdXAgrwKbabtKl09/hQsarIRnFV+qavN0Tjja4iB6cauZ+AsuXRJvy0GH9YnZQhKV9yQv6Iuj6NUhTSb9Vus07MSUH5rqC/QSS8AvK5ECUoXkfTzMUj5eL68w7mRgMqgXgDB5BZCdCpfHa3M4oNnLnNKo4DdvoiO8pR8062kYzxI4Jl81Zf5Kp4T1po12g+eNzqD6hy7982JunH3f4eAKstWdOaZfMvqp06MV5yVaTsQFMvzyQ65Q3ivz8pF2qJWAaf9M1wYag9LzChFQjGirkS3z3jP6F9gSOCkKJQV+M7jfbY8FfiKto8lRaaVJFoBJZSReoTg0x6V0dte7CbntviA3vddpS44Jy/7UtxV4K+4TAF1sJZF0ru+DmtalM+ImjwJu102kCS4kExG64x9il8evW7AnewBPI+bwftfy/8y1w7dZ3JNGRSuo29LOY6bXEkkG/DgzC64kVn/SV+U5WzTWFs2RmzvyR0r+mvRC6Ne8QOINRfnOQcYA16ciPPvk1+gsJmAJUcA6RA/VE19Rn1cNzK5yjbGOeHC9iiRa+PYmguusDVKdI/ImyBHzjArkCsMHdiukHAX/ZzMUUuEf3PSaYpcQd4pXUFd7AbFMgTtMxAxh4PA8lYrDOCgwVAKU2AWxtihs9dnT/Cu6wnHS108UwKwN1m5GI/e+Xj9ZEjQC0OH4tMBRDpCHpnvm+Xl7rCK9SNZknmlYw9Y3+sGCpFGfotx9tT4+q1x53QmRiDkmUBDwGbCOsnO7y5UZbkgUrODAIEBZYdw62AO2XF0yImcxpA3J2/RK/8fuwGo4tODbNN0Sa2J6UYAoSYfdKBl5M70xzR5ITOJONc5tZVC4mPCQco3vKkQGx3uBo+YC4I6vHpZotmbx9BpFqrkd+7YN1lmkClLVIWLFzaPwujd84ndRvV8tfOhibrGGT/YlHv7h2
 TLosUt7y
 frHD6GojDGjoG+39/UMtNFJNs/l3YTawM91thAMXyhMl3chz6rPtsoI7x1cT04qUsd6jRxHjhE1hTlhPeZWZNZ9E00aQcywfl+WqpoHwqkAcimefA81Q9b7wcAlD3k4zW+TKzYq79/XDdPtf4Hnvq7oewj8iIt1wHYGNJpwlxYL2j6TRIlz1oJsyZQgBAGpnmrlTEKpKxCmcBHThMJiS59I92BdNm+Yj3tS4exDIBWIkPlhvACVvMBZIXPbPIwEi4+MuvKEtT6uDpK9yhGJoN358KOx1nQmq/RW455tvRSu/RBoacL0cPor98coCBzIRZfuzHdqSJ9zr46URrxmFhV7VdQUruENS2egxWeO3y9hj+AA9JJQE3CAWoXr5cbMFv2yYwFqv+uL7oj2ld/Cvjvhp7iaLttebe/dIWPzVhEt/zFPrCVvGw9Gl0eWptLEu5GYbBOXwwnbOSBA1ZbnvAHVSIrHh+Gi3Ge3tPHaUrYGEoVlsjyZ1yd5tzqcc9rlt1rqIG940QJ35+tbzrjfQNIntU8UD0+RgFKCJ7KuDLSlnt+ExSswyf1tP0F67ZtQhrcVjJe9KR/G1t3A/OrvF1ooEie2I/WBvoWCfQ37SZbOm1O4g5NhEjsgVh22r7uap/s2FU2nBLCEGz/5OntWUTL79ix+2tikYCXk+/jfIXJrD/poX3H/RboEJy9VWb6cEXK1l+EeqtZ+04z1m1E/XX/8ziqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] mm/vmemmap: undeclared vmemmap in section_vmemmap_optimization_disa=
ble()
--

commit f0544b0eb7001e7264ebe693d049cf0cf0631ccd
Author: Muchun Song <muchun.song@linux.dev>

mm/sparse-vmemmap: drop vmemmap_can_optimize()

This commit removes the DAX-specific vmemmap_can_optimize() helper and reli=
es
on section_vmemmap_optimizable() and section_vmemmap_optimization_disable()
to decide whether a section uses vmemmap optimization.

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a060a71504015..2fa5ce73b382a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -38,7 +38,6 @@
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kcsan-checks.h>
> -#include <linux/vmemmap-optimization.h>

[Severity: Low]
Does this cause a build regression on LoongArch 64-bit configurations with
CONFIG_VMEMMAP_OPTIMIZATION enabled (such as loongson64_defconfig), or when
linux/vmemmap-optimization.h is included before asm/pgtable.h defines
vmemmap?

In arch/loongarch/include/asm/pgtable.h, asm/page.h (which pulls in
include/asm-generic/memory_model.h) is included first, defining:

    #define __page_to_pfn(page)	(unsigned long)((page) - vmemmap)

Later in arch/loongarch/include/asm/pgtable.h, linux/vmemmap-optimization.h
is included so MAX_FOLIO_VMEMMAP_ALIGN is available before defining vmemmap:

    #include <linux/mm_types.h>
    #include <linux/mmzone.h>
    #include <linux/vmemmap-optimization.h>
    ...
    #define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_VMEMMAP_ALIGN)
    #define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))

Because section_vmemmap_optimization_disable() in
include/linux/vmemmap-optimization.h is a static inline function that calls
page_to_pfn():

    static inline void section_vmemmap_optimization_disable(unsigned long s=
tart,
            unsigned long end)
    {
        unsigned long pfn =3D page_to_pfn((struct page *)start);

the preprocessor expands page_to_pfn() at the point where
linux/vmemmap-optimization.h is included, before the vmemmap macro is
defined, leaving an undeclared vmemmap identifier in the function body.

Additionally, removing the linux/vmemmap-optimization.h include from
include/linux/mm.h (where it was placed after linux/pgtable.h) means any
translation unit that includes linux/vmemmap-optimization.h before
asm/pgtable.h on architectures where vmemmap is defined in asm/pgtable.h wi=
ll
hit the same undeclared vmemmap error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105061217.1330=
2-1-songmuchun@bytedance.com?part=3D4

