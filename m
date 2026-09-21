Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0369BC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039FA6B00C7; Mon, 21 Sep 2026 06:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D116B00DF; Mon, 21 Sep 2026 06:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E442B6B00E2; Mon, 21 Sep 2026 06:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C04C56B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:29:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 577888012E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:29:24 +0000 (UTC)
X-FDA: 85237397448.30.F91DE2A
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf10.hostedemail.com (Postfix) with ESMTP id 314A2C0008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:29:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p15ilvz9;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XX364YbvG8jWFmzVLkdOv/787yK8OiHA+jvcLZxESYE=;
	b=hEb3vJeKOdSprv5DMXfwrlFoaRLEnvMnfS201M+UJlbipyb6r4B0sWhLcP4qf+JQKBL0id
	GwliE0rq7RwjjsZDaiYdYsgmlBmGP+B+MUt5vQPsSCAlFDUpGusD1YMLCXMYVSm2AeF+1S
	GmsD0KaguSeTPnGibxv/+c5gYsNMswQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p15ilvz9;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986562;
	b=zFFFrsxTQamjH9sVs8zdiFWEIbYp2QIvT3PJzSsOi9hbYN6Oke8wZas9TGvf07apJ14Tgn
	pWL3svcDtiN7MEIF/p0ZERAqdagYSbkmZ0xdoZBKeARDJlWYiR2+5LFOwQVj9ODVcRhu/G
	3lbgO5nzzUHLTHxVw5vEWNNrqYMkgnc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mRSWnr+OOpF102n8uPqPG+ragjzLlcjBl6k7tY/W1dE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789986558; v=1; x=1790591358;
 b=p15ilvz9caQovSjp6/c1x4Twv+yxP4bEPVMjdRpz3eDU388u3QAaO/RU0KyXfhrTzaW4icZS
 sZ2WKOnwufbU3OYghTibc7bvUbISTP5ZwopV2Sq1ZeYQIBheu2+WofE11kYqEuGmsYQWyBkySOw
 h3xalsV2F2NqQRB029Bqtzq0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 58aaa6d2d129fc08;
	Mon, 21 Sep 2026 10:29:18 +0000
X-Mizu-Trace-ID: 58aaa6d2d129fc08
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
Date: Mon, 21 Sep 2026 03:29:12 -0700
Message-ID: <20260921102913.2970139-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 314A2C0008
X-Stat-Signature: qyb345yr4px9nuht3i3bijiqoyzoampf
X-Rspam-User: 
X-HE-Tag: 1789986561-853687
X-HE-Meta: U2FsdGVkX1/KBH9/s4sFvMQfrR1CRRW/EG5DmsPJKsMNiRgDe1xdbwvyN/tYzTo8XjfD9VoTUiZvP7nP4XfMFD6gQuRcnkr5vPuW2YzrOmt+g/YkMaztO8QF5cnQC5XYtJapjHrM9uLe7VfgGTC3p6cJxOuxpw50St97vYoPeG1uKyHD3r6C9ZPvVc7BZUz+PPSy8qRj0TW9u0TRlkCW4W/YP2v0dDsRxVJq2mDO1+jtsEDTfxD9/3G5RSTFY0vd314IInbe7kBjcM0ueMwtPsqkvdGMLT3arfg0dOKRi+eDetFSRLZPa5J9jsmvjgKQr7W1+FMctZr12DuqiKnQjeUJ6/DeTeN9CzC/PZQ1i8TJxV/g81ZPSbkB8o4Knzkbj1Yfz1W6ku2tnnNmJ9axPYYM4VGmcgp3x1mNZCELiWaddgQX/rNmbXuqC5prs/3ULVhr8SWgWFHCMYZ+rkJuOZy65UThyfBqdbiLie+T60D53t4X80x9IQfkweIi2CkraWKvgkIdF8eUc0tNhD/F8Rh+aN727VaeUuFgWqpe0IK6TE/PzgkBdHeg+hMWGlxvNOtNkp93BnacX1Xk2NaLWpCCnAE6MPuJTzHa5LIjlvdXYGckGBElul0zC0b4g2lP2e52T1Y/uMH5j+I5/uEHvU5EZ2q0F4WI4uBdXb3tK9HHW+LBmAqig/Y6lESZwjgky0pJ6YQj4txBo7v4bLNXiA1pr8kvuRC15CHvuLFqhkV/S0Qsb0mnv1Npyf/M3P068mOyH4HiXmNiDzwVHe+9xSrYz8eNnLBnGZ7Z/0i5ANYfKxXjwDcsPMY567+HKEEpwc556nq4ZgxXYHTjeQm3EYoZ+wPCW2NkAmntdyisW4J3/U4QImc4xW0f3k12XGG7EE6cnpywec2XuD5YCkgsMcnZq3l3DXVmnBkvN3zAeNkhsMIkBEjZ8XSuhudkJVwWRGKBNr90ZA3yETx8DLc
 xUU+xXzH
 Y6kwtkUTuftkDdSt3OCTtFaxGGtCtZ9PI0tRkEqXYVyAE6YvyVtiBryzgPR9W48Nj99K6nXePK2pUJN7jve6aInB665pzp91SPLR8CaLY89XnUpEtu1cQcIb/P+hjc++BuL1QLA8YOzqDoL2uDG+pQGIUJhOXJUbBRTqzoa6z9id/U4EFoCr3ubOhcDXZiUpz5V1mSvBEoh5mygV+VvdTK2J/PCglGZxwp9Utzbs/D58dFr6vMr+9tX+1mtsWytiquLbD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 21:45:35 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>  - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>    considered
>  - Filter out PMD and PUD orders from allowable orders when
>    PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/huge_memory.c | 25 ++++++++++++++++++++-----
>  mm/shmem.c       | 14 +++++++++-----
>  2 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a06025b87e7c..a2d6de3ea988 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -189,6 +189,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	else
>  		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>  
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>  	orders &= supported_orders;
>  	if (!orders)
>  		return 0;
> @@ -196,7 +205,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (!vma->vm_mm)		/* vdso */
>  		return 0;
>  
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>  		return 0;
>  
>  	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -979,7 +988,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>  	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>  	 * constant so we have to do this here.
>  	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>  		huge_anon_orders_inherit = BIT(PMD_ORDER);
>  
>  	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -1001,6 +1010,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>  	}
>  
>  	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>  	order = highest_order(orders);
>  	while (orders) {
>  		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -1091,9 +1109,6 @@ static int __init hugepage_init(void)
>  	int err;
>  	struct kobject *hugepage_kobj;
>  
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -

Removing this guard lets start_stop_khugepaged() run on a system
without PMD leaves. All mTHP orders default to never, but the global always
or madvise flag still makes hugepage_enabled() return true.

That starts an idle khugepaged thread and can unnecessarily raise
min_free_kbytes. Could hugepage_enabled() instead test whether
an enabled order remains after masking PMD_ORDER when
pgtable_has_pmd_leaves() is false?

>  	/*
>  	 * hugepages can't be allocated by the buddy allocator
>  	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bc2de3a7c1ea..8c0f7e3efeeb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2046,11 +2046,14 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>  	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>  	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> -	unsigned int global_orders;
> +	unsigned int global_orders, disabled_orders = 0;
>  
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>  		return 0;
>  
> +	if (!pgtable_has_pmd_leaves())
> +		disabled_orders = BIT(PMD_ORDER);
> +
>  	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>  						  shmem_huge_force, vma, vm_flags);
>  	/*
> @@ -2058,7 +2061,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	 * sysfs configs.
>  	 */
>  	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
> -		return global_orders;
> +		return global_orders & ~disabled_orders;
>  
>  	/*
>  	 * Following the 'deny' semantics of the top level, force the huge
> @@ -2072,7 +2075,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	 * means non-PMD sized THP can not override 'huge' mount option now.
>  	 */
>  	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>  
>  	/* Allow mTHP that will be fully within i_size. */
>  	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> @@ -2083,6 +2086,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	if (global_orders > 0)
>  		mask |= READ_ONCE(huge_shmem_orders_inherit);
>  
> +	mask &= ~disabled_orders;
>  	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>  }
>  
> @@ -5630,7 +5634,7 @@ void __init shmem_init(void)
>  	 * Default to setting PMD-sized THP to inherit the global setting and
>  	 * disable all other multi-size THPs.
>  	 */
> -	if (!shmem_orders_configured)
> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>  		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>  #endif
>  	return;
> -- 
> 2.55.0
> 
> 

