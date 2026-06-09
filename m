Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D0ECD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748866B0095; Tue,  9 Jun 2026 10:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720246B0096; Tue,  9 Jun 2026 10:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CC96B0098; Tue,  9 Jun 2026 10:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 543556B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:13:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2C2D1C2D4D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:13:15 +0000 (UTC)
X-FDA: 84860566350.25.2DB346A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46C3380015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:13:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HG6mmjqR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63y6tZ25VbAMNcuEdojeAVEa+zeL2wocNZmc2fUBwgM=;
	b=ltRK4GFx4EAsRXDNQADyuMo5T1G9V1gIG3wckMenhmcJIvgUybecOClfabrSk301+DnaM4
	lYpEsU4fZwqshM9sY64vAFkwHiTV1Jo6dz26zWUXyykrBO6Yx3wV/gw8JE/GvF0nwCo9hJ
	Rxwxk7noz66q9ov55hv2voRdxl3KHD4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HG6mmjqR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014394;
	b=vt4gOuaq3gHNoLUgpNoCZ/ZCVIqdSmM6FaFnBQHiNThBPD/posrqF5uWWkzbgjjyO/GnEl
	84zChxZWJI21Lt6eqSZCKowkxc2qLZMueg4Yemr5HqIxdJ6JcLzhh063mvb9gHVSuxzVf2
	632z7Gipp6RkVs5A7kHgh2Z0jT2GWr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71F5040B16;
	Tue,  9 Jun 2026 14:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F41F00893;
	Tue,  9 Jun 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014393;
	bh=63y6tZ25VbAMNcuEdojeAVEa+zeL2wocNZmc2fUBwgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HG6mmjqR1ABZQRp6AjNYevSAgPM09oPs9ZykgDI+gUCKpMuj/9tQEGKcErg8NtQ/T
	 cxlAxyZnh92JxfBy91mfsqua9HetrSV8vnUiXdIXAVOgDNyc9Rt4HCzntYBVZW9nFR
	 kdzCx2mRZ7DtahQFkbYigFA6sRLtMBOp5gm781NtfPeETU6X+Mrx4hdvr93BE3XfVa
	 it3+/INVaH4w8ahSu5mvMKJOc9IluuE0xYAoaNSJYTBpU1avfrlIRN/n85WiUkfXhx
	 Oh+LhOE43z3ae3LaC5SWc7DhXeNES2DNbAsNjw4iMaFr0uCj6oXa1Kc372lDZq3tr6
	 tA+zj49UPlXeA==
Date: Tue, 9 Jun 2026 15:13:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>, aarcange@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH mm-unstable v1 1/3] mm/ksm: export ksm_is_running() to
 check KSM merge state
Message-ID: <aigfR1ifoT1Ibk3K@lucifer>
References: <20260609114619.144416-1-npache@redhat.com>
 <20260609114619.144416-2-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609114619.144416-2-npache@redhat.com>
X-Rspamd-Queue-Id: 46C3380015
X-Stat-Signature: i9madx1c7kn1uyemfht7zpawuybj7g6b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781014394-665652
X-HE-Meta: U2FsdGVkX19QtpiDcGaCHr0nB5G/VWH/dWWzLG5N2qt0u1QHuN7bVa6X6YrLx8mxZ7t2Gja+vJPnWTlGUo1wVTRXtV74pXRW13188/C4nt5pyttfXeGmAc5N0NhEv1T0UlW6Dm5p4YkXsBKU98cftjMvcVR/PjTDpDqkCEcbPD45Ld/WdZ6XyHePj4cWIx2GDhv57jRE/fWOtsTHjc3jczgB+lyANpixVL9HhbvYsWyWqHj/BiZuQFM069ow4MeXF53VMi5CdPu4fQMWqleb7klxxea3EFFMI5bRipbbWdQhhZ0B7m1rNE/niCeRQJZjg6oEbogJfVQSijwytsr85Pd2dbGQtRH0BlrDyC2juz+8e9Z17G4yiYscznjEGk8e9UUeqzD7BBISpEXXzOWxelVUzwSIIlm9c0I4cMgR3F7op0Vng6a1nFKnNfoOv9aIz3RAerqUiQiXRJ8r49aQgiwktkj20en0zYxR2e+gXfcApBVGel0adm4mesWwQYlYLmeW94WBTBAHS0jLzKgeVgjo4yvQAn0ZO+FS1xjylOZFYOIfk/NvSrweieEXeb7bYFLHId861IPwEm0uMnRgQGYe/V6UQKApS2zDw3nV+cDN+BsGoznkYHZLyD3hwrH/mIMQ/nrnbvRKXWDOjKWiEu2mYEtYV1PBRHX2SGVVNyDSI4OjMr1VnXeiijCFxqgF/YEQlu9ETYI5ja37C+5mOZSkQioeJCvSFtEiJjIYSX69Nt4hSmsDEn0WIA+vt1k/dgyWqRtJPwMfUHkSZm014+aoeexR5Uo7n9Ii0qG4MgJVV0fOlNcws3GPvBgu1G7M1dDzswoB32XS3uGVNhCrlRy1R16Sph8umGv/zXriE/JSPjq0aKs3znduA2PIyJBhmxrP4tXp9O1uWgr5I8e6pcVPK/CV4MZ1D0QxkxfIz/2aOgERzhIPYOhdTLsDCoZgtxA44CM/Y6CAAAsV5y5
 vJl9RSdh
 TTfSvokMmssVq7qFwXN5cpG2IgZd6U6yFUZVu57FxvxaF/B0Ddj/adPd8D30xcGr3rywOe5BV9OJsCCz0w59Q1CJMSXeIA+C7DBsh8YvBga5UgBQu/QB+NC2TKaMumc013sc6vzX02Tm8fmEPfLOH/pmj34/xrA7RBYNv8ks1ouocvC8H5xTPNji2Su2WQreRSOksQ8sdx24T0Ixo2wQEdXerjl2eD+smZgCTCQNmqex2MCLsrczxgohslDhLo7K4LUcAH2gQryyr+S3b8Xl3CF/c6eZtO8nuTmOjYk1jPdP9fCz1yY7CBf/vOWBRksDkhbl5KEz4x98fTbmxGhXuGuscYgbiYkofB9yraJmSC8XaDkVx2/nbvuSdS0OBQnh5YFCVTAQGHfLrSUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:46:13AM -0600, Nico Pache wrote:
> Add ksm_is_running() which returns true when KSM is actively merging
> (ksm_run & KSM_RUN_MERGE).
>
> This will be used by try_to_map_unused_to_zeropage() to skip zero-page
> remapping in VM_MERGEABLE VMAs when KSM is active.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  include/linux/ksm.h | 6 ++++++
>  mm/ksm.c            | 6 ++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index d39d0d5483a2..c1048b690a92 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -17,6 +17,7 @@
>  #ifdef CONFIG_KSM
>  int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  		unsigned long end, int advice, vm_flags_t *vm_flags);
> +bool ksm_is_running(void);
>  vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
>  			  vma_flags_t vma_flags);
>  int ksm_enable_merge_any(struct mm_struct *mm);
> @@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  	return 0;
>  }
>
> +static inline bool ksm_is_running(void)
> +{
> +	return false;
> +}
> +
>  static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..edc2b961ff59 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3015,6 +3015,12 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
>  }
>  EXPORT_SYMBOL_GPL(ksm_madvise);
>
> +bool ksm_is_running(void)
> +{
> +	return ksm_run & KSM_RUN_MERGE;
> +}
> +EXPORT_SYMBOL_GPL(ksm_is_running);

Why are we exporting this? What modules need this? We should never export unless
we have a very specific reason to.

> +
>  int __ksm_enter(struct mm_struct *mm)
>  {
>  	struct ksm_mm_slot *mm_slot;
> --
> 2.54.0
>

