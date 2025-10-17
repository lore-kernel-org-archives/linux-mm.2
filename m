Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C74CCD199
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 02:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4668E0008; Fri, 17 Oct 2025 22:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9857E8E0006; Fri, 17 Oct 2025 22:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873918E0008; Fri, 17 Oct 2025 22:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70AF78E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:48:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 179A9B9265
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 02:48:29 +0000 (UTC)
X-FDA: 84009701538.27.1D1F9C7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99BB116000C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 02:48:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mH0TK5WH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of vinicius.gomes@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760755707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9KHyritfTg/yTZkb6RALLTHSuifvD4D5Xd+G7m9W0I=;
	b=C8iDJb90skuWUAf4mhAlaKdrlk4ctckEd6JCFxIYSLmy0kA0mmGTAjlyhW7R3s+tbpGmhu
	nKLDrR7bmUSMyKpGOTQRB8TFLmqad30h2o3aJi64jPzsB45kVfbVvFOyskKtVFyZ6Ev0TA
	D1ehdCLtwlwt2ynIT+4fwIF0p14hIoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760755707; a=rsa-sha256;
	cv=none;
	b=UcrtISVl50u6vIEJW5PjM7RsH8cHEGOzp5mm2daFTLK56G89eaLeUpgMLVphgmm13lN0FI
	8yu/s45221TL4pYVnemezdsdsc3xn5bkBEdgNDIB8hr5e32IOc460rHZ9ZPauiZgSzShnB
	AB9z5kAcQgjLoZF+kS7CdAkaLCPCpcQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mH0TK5WH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of vinicius.gomes@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760755707; x=1792291707;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=tEp8HH2rBzZ9bHQxIDQ0t/JriZ4BYmHaJTITiE1LyPQ=;
  b=mH0TK5WHJcvSRg4szVCkUrIR5AxE7p4YJ20cT7AHY34qrdyUlNGqqmPW
   Z+PN/Hz0O6KVicj4tNUkAyYkwTjpX7i7lm1zsRZbV2cWJmoU8L2wsH4yP
   2lOnSIKXd9Lxl6m+G2BtTc2Rnyi9CebB8kwMrhjaE+uQbBJOcZQF7rIrB
   ++p/B12Dw97IO2JbFd8FJDNkzZKJ3W8YfE3i/h31xy78NnDA7S4Kaxd9V
   repChIZD486N6DOVulzdo3cMeGAxDa2MXRkXto4Hx2MfHQ3KoYzt6T52m
   om/hnFL/kLRa96oqyguqC4p1w8xGH4PLpq0zx0/o9N5Qc1l3K0MCPUwgE
   A==;
X-CSE-ConnectionGUID: +AOo7q5cSGqncxupLIh2gQ==
X-CSE-MsgGUID: T8dNn1czRryln/m/lRCjow==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66802750"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66802750"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:48:25 -0700
X-CSE-ConnectionGUID: NoGyMQ7ZTdSUCMLtUYDo0g==
X-CSE-MsgGUID: DQPBNYLuTRa+xl2lmWU85A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="182495563"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.125.108.63])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 11:26:03 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Baolu Lu <baolu.lu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>, Kevin
 Tian <kevin.tian@intel.com>, Jann Horn <jannh@google.com>, Vasant Hegde
 <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Alistair Popple
 <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>, Uladzislau
 Rezki <urezki@gmail.com>, Jean-Philippe Brucker
 <jean-philippe@linaro.org>, Andy
 Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R
 .
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, iommu@lists.linux.dev, security@kernel.org,
 x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Jiang,
 Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
In-Reply-To: <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
 <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
 <11cad2be-9402-4d45-8d2b-c92d8962edfc@linux.intel.com>
 <20251017140101.GM3901471@nvidia.com>
 <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com>
Date: Fri, 17 Oct 2025 11:26:02 -0700
Message-ID: <87zf9pjsg5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 99BB116000C
X-Rspamd-Server: rspam02
X-Stat-Signature: bsk3siodzn1i5mkoyjrpozshd1mce4w4
X-HE-Tag: 1760755706-307452
X-HE-Meta: U2FsdGVkX19txI40mJ3FAMxZjmYRZOZ4KCmWcBqOCjaU73ZsMLn1uomQs2A/rDEh5oBDGOu8FzgQikj/jzgVWMgZLjaOg79jf51GkVnO/Qz5ximvQBRqUisan2h4sij8wDD1SStIbVEfVVKIPD/qRGtL0je+dsDc2N2WnMbYTn8czEBF9INyIOMHQgZ4f5G4r5r7sL5ejCfdMZG+QwDLNLaylznb0sBlhB5t4khCjoGHf5LEOsprZkv/vUCm6Zo+L/8AgGnOVwEwkicYFO5a+AZHlQ3cTvNaGqlCRR2bQxB9SG6Nq9k8UOHiWQJUg++/f7BTLls1o558ij9gqX8SiwvhAF69R7zJs/kU/xlBHJtNbGHKvBxP7phFhMpT7h9G6QEM0NIK0vtnA9oGddf5MpN+36W6ee5NkdPCxuymTGFt6m0El6pwfZEdJUVHxIQnsKcB1QfmPg0/iTkMDhG7nlDg0Dl+1dxe+nX+E/S0NuoLz18Mw+RlTBAqmJjGaQR5nJ3ds2L8C1XkCSSNK68Pp9NwGsuxRSRsajXKHt7jm4YdvRNwiNFULWvVWAUTMF3CMSvC87f1fnLBGNlPmJUJ7L6sdZ1upP9Mz4pwYwrBNLExwwFcLkPA2gLh/OsIg2UIPdwTJ7i9kIsKPa/UfvxIygiNXXoK4w5milI3K9nx0beyS9ZrftmVsnQfbNcaeLwbbHyRd+fam8LzpCMo6/tMa40Fr/R1ASQdFM0tgULqawQbRX70MT25bcuwUUR+McbBwuY+LHt9uBHScRNV9+B6bMrzYz5hd5NZ5MQiepCYCuHVf8x5px/S70viSAYdsxMMuLWendXkmOkqcqfbd8wy+ZDLTWiEcpsNy0tLTfPNKclZiUTH6Cfd4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dave Hansen <dave.hansen@intel.com> writes:

> On 10/17/25 07:01, Jason Gunthorpe wrote:
>>>> The other alternative is to have arch_vmap_pmd_supported() return false
>>>> when SVA is active, or maybe when it's supported on the platform.
>>>>
>>>> Either of those are 10-ish lines of code and easy to backport.
>>> Hi iommu folks, any insights on this?
>> IDK, the only SVA user on x86 I know is IDXD, so if you do the above
>> plan you break IDXD in all stable kernels. Doesn't sound OK?
>
> Vinicius, any thoughts on this?
>

This won't break IDXD exactly/totally, it would cause it to be
impossible for users to create shared DSA/IAA workqueues (which are the
nicer ones to use), and it will cause the driver to print some not happy
messages in the kernel logs. The in-kernel users of IDXD (iaa_crypto for
zswap, for example) will continue to work.

In short, I am not happy, but I think it's workable, even better if
there are alternatives in case people complain.

> I'm thinking that even messing with arch_vmap_pmd_supported() would be
> suboptimal. The easiest thing is to just stick the attached patch in
> stable kernels and disable SVA at compile time.
>
> There just aren't enough SVA users out in the wild to justify more
> complexity than this.
> diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
> index c9103a6fa06e..0b0e0283994f 100644
> --- a/arch/x86/entry/vsyscall/vsyscall_64.c
> +++ b/arch/x86/entry/vsyscall/vsyscall_64.c
> @@ -124,7 +124,8 @@ bool emulate_vsyscall(unsigned long error_code,
>  	if ((error_code & (X86_PF_WRITE | X86_PF_USER)) != X86_PF_USER)
>  		return false;
>  
> -	if (!(error_code & X86_PF_INSTR)) {
> +	/* Avoid emulation unless userspace was executing from vsyscall page: */
> +	if (address != regs->ip) {
>  		/* Failed vsyscall read */
>  		if (vsyscall_mode == EMULATE)
>  			return false;
> @@ -136,13 +137,16 @@ bool emulate_vsyscall(unsigned long error_code,
>  		return false;
>  	}
>  
> +
> +	/* X86_PF_INSTR is only set when NX is supported: */
> +	if (cpu_feature_enabled(X86_FEATURE_NX))
> +		WARN_ON_ONCE(!(error_code & X86_PF_INSTR));
> +
>  	/*
>  	 * No point in checking CS -- the only way to get here is a user mode
>  	 * trap to a high address, which means that we're in 64-bit user code.
>  	 */
>  
> -	WARN_ON_ONCE(address != regs->ip);
> -
>  	if (vsyscall_mode == NONE) {
>  		warn_bad_vsyscall(KERN_INFO, regs,
>  				  "vsyscall attempted with vsyscall=none");
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 39f80111e6f1..e3ce9b0b2447 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -665,6 +665,7 @@ static unsigned long mm_mangle_tif_spec_bits(struct task_struct *next)
>  static void cond_mitigation(struct task_struct *next)
>  {
>  	unsigned long prev_mm, next_mm;
> +	bool userspace_needs_ibpb = false;
>  
>  	if (!next || !next->mm)
>  		return;
> @@ -722,7 +723,7 @@ static void cond_mitigation(struct task_struct *next)
>  		 */
>  		if (next_mm != prev_mm &&
>  		    (next_mm | prev_mm) & LAST_USER_MM_IBPB)
> -			indirect_branch_prediction_barrier();
> +			userspace_needs_ibpb = true;
>  	}
>  
>  	if (static_branch_unlikely(&switch_mm_always_ibpb)) {
> @@ -732,9 +733,11 @@ static void cond_mitigation(struct task_struct *next)
>  		 * last on this CPU.
>  		 */
>  		if ((prev_mm & ~LAST_USER_MM_SPEC_MASK) != (unsigned long)next->mm)
> -			indirect_branch_prediction_barrier();
> +			userspace_needs_ibpb = true;
>  	}
>  
> +	this_cpu_write(x86_ibpb_exit_to_user, userspace_needs_ibpb);
> +
>  	if (static_branch_unlikely(&switch_mm_cond_l1d_flush)) {
>  		/*
>  		 * Flush L1D when the outgoing task requested it and/or
> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
> index f2f538c70650..a5d66bfd9e50 100644
> --- a/drivers/iommu/intel/Kconfig
> +++ b/drivers/iommu/intel/Kconfig
> @@ -48,7 +48,10 @@ config INTEL_IOMMU_DEBUGFS
>  
>  config INTEL_IOMMU_SVM
>  	bool "Support for Shared Virtual Memory with Intel IOMMU"
> -	depends on X86_64
> +	# The kernel does not invalidate IOTLB entries when freeing
> +	# kernel page tables. This can lead to IOMMUs walking (and
> +	# writing to) CPU page tables after they are freed.
> +	depends on BROKEN
>  	select MMU_NOTIFIER
>  	select IOMMU_SVA
>  	help

-- 
Vinicius

