Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD03AC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979136B009E; Tue, 22 Sep 2026 09:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A566B009F; Tue, 22 Sep 2026 09:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866506B00A0; Tue, 22 Sep 2026 09:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD1B6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:27:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECC68A6638
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:27:41 +0000 (UTC)
X-FDA: 85241475522.05.90DC6E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C4B98000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:27:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScK32LSy;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790083660;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOgpW4IgnM+iWttR9xGzJPKFkLCxSHMpX5I4y07+yQM=;
	b=EbQ0DxbFtXdRLtbwUvSdIohje+4VynRM1MtZb/JRsFNZSjzUTrUuPpZnHVl0IaeBwQShCK
	wLr/Om9MXB7p+uUXG0BJjtvL7zzSUaiz3avNp/VdDO779lTN0pzJiyQyJozVSyykiNhsLg
	UH3XSHhvTJ1d5SXV6CXJzYQfHncm+H0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790083660;
	b=ZCOJ/Z1rnfRty7VANFXpKMvnA7oD9ZqmCIl62mi1SXDXwwJUMU6mBa9DlUqUav5NrKqzNX
	Dxr4ouMqXARcMm3/o9QpneTi5eVb4jXBm2RccwpfpdVqupctNL+tk/DONtj5uPNbDwazIE
	FW+qsKHjs0bmcstXjGCuvs4E/HhtQpE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScK32LSy;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9439B60DFF;
	Tue, 22 Sep 2026 13:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15EB1F000FF;
	Tue, 22 Sep 2026 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083659;
	bh=hOgpW4IgnM+iWttR9xGzJPKFkLCxSHMpX5I4y07+yQM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ScK32LSyDrY7d5+C8okcVeEUzggCwaZYw48LGkNFs79g2d6FsaGQjUnycanFRtVn/
	 hVgC5C16xSQSsH2ZWl7i3uAL/tMCQoA+/QwbuNe64iWM6kBd3o1Eb3mmpc7HjHD8Yx
	 kFY95VDNDpXS71ZTlFVcgX8Nqc/33yM7UhzutJO2t1MBcf/W7Rjhot17y1bDFDaJ3U
	 ljz6jq4Tl7ABUOVZvYSOLHqjIbCdkQ6img71hVkM5E+Bx1hisyF41hkCYvstoSB3tP
	 bGoAXpXw1TTnkBf9sdeMUMjmG8UJIdgk4LYOkKO09YGtGblsPQySTBTwIpEtSDfjqk
	 5B4IZ4Ors4mVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sourabh Jain" <sourabhjain@linux.ibm.com>
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, linux-mm@kvack.org, "Mike
 Rapoport" <rppt@kernel.org>, kexec@lists.infradead.org, =?utf-8?b?Uml0?=
 =?utf-8?b?ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "George Guo" <guodongtai@kylinos.cn>, "Pratyush
 Yadav" <pratyush@kernel.org>, linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>, "Alexander
 Graf" <graf@amazon.com>
In-Reply-To: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:27:38 +0000
Message-Id: <20260922132738.B15EB1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C4B98000B
X-Stat-Signature: 6yzkzfe5j8sz68mybnmpwngbsz38ku1r
X-Rspam-User: 
X-HE-Tag: 1790083660-915615
X-HE-Meta: U2FsdGVkX1+qiD51VZ+jqWOQ8emSPDISj0FioHMjzSX0zXVtldrDLNP1WH8OUqq5z44+kZDcu0quM1/VERA2BtXbRPeqfxpbVvr2Vd7Mfy5SPQVOLFchLdxuRqsyk4u5SIdpb14ojN9qNXM+ws6T8Jkfna7fhC6o3n30AAvgRbYQu4Xir0LF5mhKB6W7c5e8BGkrdsIXatsCNfsdW0tEwJRAcg61dTQRVuK6ohffitJTdyZt5Ybj/Xiqp1hU3yDbKqkvdkhiGeCn7e5bgpK8BB9ZLCNn1YOQNtjfyITXHH/jNGWWgAxJpLP+YUbB3X43XKRSmqvOR+vbkxy6e0zLj6c0u9ZP8W+FuTEMMybDoe47vUduswkFMjSUaO1Sc2YCzY5Z4pMBbWdRK24pk36j/iOhi0j2/YWPrYu1wZVxLb0jsbCTjvon84vJxHp+n7cYRqoOsIamRfHOJxVfLYA8dfyqX27MnchPdmVFIEyJMNdO/+0j/5FHqQjQnZKTA/cXu28VR03tbgicbmTV8C9DJtu5DcUjR3ptIu6gHMus9Q+Q5F3axxWgUTh77m8viIZwuppgRpiFRhBp3Eoy1K8UL+WHUUjRiLOUN7A8ZGSo21Kwm0Nf9x4oW0m39E+0COOsHua8NA7xrChwRa0FqkuAaLulH77wDD6zwp8jAlpYwmviyrZpa8JETBafIJ2xFR3DEenDIz6pq9zHATEqgjwGeSp+OcWfmp+D+YLuRs5QMtmBE6/49Zaf3QMM7v1STkxMyepuYJZ/rxkVksCTirA2GAy2OHs4yOPlSw5o8kYzwmsX+qqk7DNkEhDlPn5iUJgBnHWxPjxsgS7vbxIPGNYqkKdZ+u5jgyLjD65XUL88leOD6OfvQgyKD07fF2ckHTMGs78c/9J2Ts2q4oKIRE6wdLKzQN5XFqfuH1Ov2GU4MIR9btlvamz55Yy2ewSGLwhIogQB1lTgPd3jZ2jPYDd
 ld4Tuhmr
 6XU+7K8h85brrPtIU2ZjHHl2hJpJLKo+gW+ObFxd8nYV/6nHc8N4nlkiPs7Cb0e27dLrlTxMm0zYqRuSFWhD8hu9a9TVVKHaI3GJFCpUnPxr1A7rMdaXSIkNgFJlGng03zUyGdEIys5VQmutlIQ4pMdiGnpIQIflhfM5YLMsZTfQUFyIODUhl2fDJwnYbo+8tfGwGqHe8uoHOTgZe0WToCUEWvjsayWvz9gv8Z/VvwowOlU3L9ifS7zIr/LdaJy8rOP9MIyHxuTqRFPAyeNgNYOAYl4XOS0p47kTdxnfLm6NpGm9OLdmF8qS4CXlsYsqKtiSUVhbz0BR7QCvoaDq9VouuonVjCPVvkUUmlFgMogS13VJzYedMbCigvkil5rWJP5KcTCgvoPOxI0jsuI0dx/phlnsopUuQ8ZXj1J44PSP54S2BPfK9VjKAN5KQcR+/cpWjgpIczB8ecaY5tXwxn3K86fEmg0Lu8KLUkCRuU+O2PgWCIJU/7FTqFoKuvxYvBmVG5chzaznmk7Hcm5vwrGYC00A7/p+v9nCHOVoIofpm1DMHUiUIKjOr7tW9aydR0jS54onIIIOY1W1ekmQayxjlHszfvUQ9Kmf3I9ZPhdHCYrkmyBVjwzNipicZRP4UXOsbF5tYHwtGvVtVRWhakNaq3O6gqifez8GJnOKd9rAgG90Q8UJ5B8AfTmW4BajsPsfXHrTPTvPp0OM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kho: lowmem scratch exhaustion due to missing node-specific lowmem=
 reservations
--

commit 45b67db1813edaa6fb1bdfe7033f0598a814cd63
Author: Sourabh Jain <sourabhjain@linux.ibm.com>

kho: fix global scratch size calculation

This commit updates the scratch size calculations to correctly distinguish
between memory reserved for a specific NUMA node and memory reserved with
NUMA_NO_NODE. It introduces memblock_reserved_size_nid() to calculate
reserved memory based on reservation type and NUMA node, fixing an issue
where per-node reservations were incorrectly included in the global scratch
allocation.

> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 7c4d86daf86d5..dc809e1e768c0 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
[ ... ]
> @@ -787,17 +787,17 @@ static void __init scratch_size_update(void)
>  	if (scratch_scale) {
>  		phys_addr_t size;
> =20
> -		size =3D memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
> -						   NUMA_NO_NODE);
> -		size -=3D memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
> -						       NUMA_NO_NODE);
> +		size =3D memblock_reserved_size_nid(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NO=
DE,
> +						  MEMBLOCK_RSRV_KERN);

[Severity: High]
Does checking NUMA_NO_NODE here exclude node-specific lowmem reservations
(like node-bound DMA pools) from the lowmem scratch size calculation?

If the successor kernel requires lowmem for these node-specific reservations
during early boot, could shrinking the global lowmem scratch memory lead to
memblock allocation failures and a panic?

> +		size -=3D memblock_reserved_size_nid(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_N=
ODE,
> +						   MEMBLOCK_RSRV_HUGETLB);
>  		size =3D size * scratch_scale / 100;
>  		scratch_size_lowmem =3D size;
[ ... ]
> @@ -815,11 +815,11 @@ static phys_addr_t __init scratch_size_node(int nid)
>  	phys_addr_t size;
> =20
>  	if (scratch_scale) {
> -		size =3D memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						   nid);
> +		size =3D memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, nid,
> +						  MEMBLOCK_RSRV_KERN);

[Severity: High]
Are the node-specific lowmem reservations that were excluded from
scratch_size_lowmem now being counted here instead? Since this counts
with MEMBLOCK_ALLOC_ANYWHERE, will these reservations potentially be satisf=
ied
using scratch memory in highmem?

If the successor kernel restricts its memblock allocations to
MEMBLOCK_KHO_SCRATCH regions, won't it be unable to recreate its
node-specific lowmem reservations if the per-node scratch memory was placed
in highmem?

>  		/* Do not count HugeTLB pages. */
> -		size -=3D memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
> -						       nid);
> +		size -=3D memblock_reserved_size_nid(MEMBLOCK_ALLOC_ANYWHERE, nid,
> +						   MEMBLOCK_RSRV_HUGETLB);
>  		size =3D size * scratch_scale / 100;
>  	} else {
>  		size =3D scratch_size_pernode;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131217.6988=
09-1-sourabhjain@linux.ibm.com?part=3D1

