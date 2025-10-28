Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0148CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CEF800D4; Mon, 27 Oct 2025 20:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1267D800C9; Mon, 27 Oct 2025 20:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0155A800D4; Mon, 27 Oct 2025 20:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE627800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:26:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EBA813A71B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:26:25 +0000 (UTC)
X-FDA: 84045631530.22.724BAD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC6E0C0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:26:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HVHUBUje;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761611183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvP5sA9aOHD93fv3CeXWa2cweMcNxslCQn0oWh8x4E8=;
	b=K5SU/dpzEnQTNG9optdwjnyAHHD21bSoTuJemklf3RSehUVpeIBgxtxI3Dwc/N3L0u6ITa
	OteLPyrDHrfKXzvDcNIbzKdvu7dMmFRNhyY03rb2o/DjTA10EcKr+StEBS/pF9bHHOW4hW
	AI61EGbCcdXKaNiQo/tLUmLWFQzJC/k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HVHUBUje;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761611183; a=rsa-sha256;
	cv=none;
	b=YyTrNVNK4QHljm+xu6ExyK4z/taF81+ZYn9cOLXdszM2Kw3wzGjFAJ6zddZdeTXLQIWSEt
	J6tiF28yaT5HfwiLQ/85bJwklYVN530n58dZeG4cJeaIWaL+oaoXdC4lazTiiKyA1J1pkt
	GUpU+rCMFfHPAIcx6+gLm3FvAVWlKlQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE49F602DE;
	Tue, 28 Oct 2025 00:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE4EC4CEF1;
	Tue, 28 Oct 2025 00:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761611182;
	bh=03OjAGrl9Ce/K7jq0kNHfmZRLQY0iB8bbCx2CK6fD4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HVHUBUjezRvJcZmKT1mk7OhneauH29p/qrVO4e2mCpCeGowlb7n+7PIoWHCmgPwVp
	 cGWdtpvpmgPv8LCLCDA+/sQBYoVF8rwrHZBJUczjUqqrFJ3YEU94X0MniJ2Zuwlaod
	 uf2xiA/fC7qtULW2v3xM5g7PPCDVdKpuqd4Xx2qE=
Date: Mon, 27 Oct 2025 17:26:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <alex@shazbot.org>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
 <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>,
 <Smita.KoralahalliChannabasappa@amd.com>, <u.kleine-koenig@baylibre.com>,
 <peterz@infradead.org>, <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
In-Reply-To: <20251026141919.2261-3-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC6E0C0006
X-Stat-Signature: nnowsbr87twtd5mjjugrk43wuy5q9ftq
X-Rspam-User: 
X-HE-Tag: 1761611183-408296
X-HE-Meta: U2FsdGVkX18mbgRxnUBnO+lW0EZhOgOcNQ653GE4ivj/vSboTdTGX+qVqqR1zWhy9mKE/eJNCkOCqkG2SgDT0bJf6iI/3eD6QfWPDngzn2DqCfSWQYJjt527RPKmPlWlpR0DU0e5koVeQRfng1DBXGsiejZ08iDhqixFhBYBcY1xsruVtLZZ1L44L9/FdWiy6LxlKLFXamj4Qdi9CA+giYnUnXoi9UQW/Xxk3RNI0lPrFonBUrc4+frVdGBMjok42nRG9sVv9aRuJZ/OO8rRJtNGR49fgbkYfu7UUurPHPg8eV4lDPEbRcOOKtfCWbj/zWHl0IbNkL9hb99l4IcKAG8/7tV0NKxF8EmXL4IzNRFNq0TrfaQJ3Ce4LCp72PRy9qVYlBM1OLQFIriCQczHpL5nYB+/GRHAJ4caOE+PZrlif3u5SqMqaZrB2gX+VedxShRzajh80niRh3CxW+THF0YyRBYIvYrEPP+gfagm1ujiSVcSACVeJ9snCwrQIlXenouCwNZTNbDliQsRJq6+VUftSb2n/ELnac3kduw4rS1chUnKb1LBwTzhsmkznlT/4rtkEWySpaHDJ3M72yuvtEvKggcAdxOg9PxHRf5DAG2on+vWuu6yB4zQg3u4YVlxqoUqpWw1KhGFVUXGhBf7+HySq2/QlDUkINqWiQ0G4/ewhpFyix0xT6TbX3/Wexl3rCB4xhbVqIw24rMRcVaLCjTGlCOB5IymxkVM3OhINHDED27/orOWX2NVzFdBGs8CDSi3eZbHUNhm8QiClX5tCePMsWbJ9ugPEXZDmh1L32g3SdbnVWZar6PkkNou8d0iibr9CDeVpZ+h4G0W1Y4JW02NYhHm+8TthWHYhgpVOdajuCBunhCpmMS5kp4cyivHLdMoJDaNlSUw+TONVE3VdYgBcAOHPTRpJpmrje6jsOeBiSrSwsH5eXgf095D3d7ao4ng9EBNnDam/aaKKsa
 nCUVxJhn
 sCk4drKXh+b9CBny2iewaWmemtYYnYNwYAZj2x06Yor1rDUxxZILlDOzT6E34fBAhMbHoK/s41+JChDvJmx6qKqAs8dIjbAYDVsNq0/37SLaII5JA335+xMRVxHKXVc1er/aFTZz1cj04898hVpsc0tX6nQoY7Lwa/blm9uLZ15qER1p6A5HQ6NTHL6v28KIN1tvgTKiZlvCH5ASXAT7wMAwRaKNFzWoXy2vfkCiBvP06nYK/v7gYR4YPKda74DKIibO1R36w5bhny/MQ3p1pfzfRXMG6AVE5NKWxB2Z58V1lVMYeCd75lBYDmlaJRTQGLvvCyB/dOjkrru32TYdNjxP0wA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Oct 2025 14:19:18 +0000 <ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Poison (or ECC) errors can be very common on a large size cluster.
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_space
> to determine the mapping VMA.
> 
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> faulty PFN using kill_procs().
> 
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
> mapped in such as way would need breaking the PMD/PUD mapping into PTEs
> that will get mirrored into the S2. This can greatly increase the cost
> of table walks and have a major performance impact.
> 
> ...
>
> @@ -2216,6 +2222,136 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>  	kill_procs(&tokill, true, pfn, flags);
>  }
>  
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	if (!pfn_space)
> +		return -EINVAL;

I suggest this be removed - make register_pfn_address_space(NULL)
illegal and let the punishment be an oops.

> +	scoped_guard(mutex, &pfn_space_lock) {
> +		if (interval_tree_iter_first(&pfn_space_itree,
> +					     pfn_space->node.start,
> +					     pfn_space->node.last))
> +			return -EBUSY;
> +
> +		interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +	guard(mutex)(&pfn_space_lock);
> +
> +	if (pfn_space &&
> +	    interval_tree_iter_first(&pfn_space_itree,
> +				     pfn_space->node.start,
> +				     pfn_space->node.last))
> +		interval_tree_remove(&pfn_space->node, &pfn_space_itree);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static void add_to_kill_pfn(struct task_struct *tsk,
> +			    struct vm_area_struct *vma,
> +			    struct list_head *to_kill,
> +			    unsigned long pfn)
> +{
> +	struct to_kill *tk;
> +
> +	tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
> +	if (!tk)
> +		return;

This is unfortunate.  GFP_ATOMIC is unreliable and we silently behave
as if it worked OK.

> +	/* Check for pgoff not backed by struct page */
> +	tk->addr = vma_address(vma, pfn, 1);
> +	tk->size_shift = PAGE_SHIFT;
> +
> +	if (tk->addr == -EFAULT)
> +		pr_info("Unable to find address %lx in %s\n",
> +			pfn, tsk->comm);
> +
> +	get_task_struct(tsk);
> +	tk->tsk = tsk;
> +	list_add_tail(&tk->nd, to_kill);
> +}
> +
> +/*
> + * Collect processes when the error hit a PFN not backed by struct page.
> + */
> +static void collect_procs_pfn(struct address_space *mapping,
> +			      unsigned long pfn, struct list_head *to_kill)
> +{
> +	struct vm_area_struct *vma;
> +	struct task_struct *tsk;
> +
> +	i_mmap_lock_read(mapping);
> +	rcu_read_lock();
> +	for_each_process(tsk) {
> +		struct task_struct *t = tsk;
> +
> +		t = task_early_kill(tsk, true);
> +		if (!t)
> +			continue;
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
> +			if (vma->vm_mm == t->mm)
> +				add_to_kill_pfn(t, vma, to_kill, pfn);
> +		}
> +	}
> +	rcu_read_unlock();

We could play games here to make the GFP_ATOMIC allocation unnecessary,
but nasty.  Allocate the to_kill* outside the rcu_read_lock, pass that
pointer into add_to_kill_pfn().  If add_to_kill_pfn()'s
kmalloc(GFP_ATOMIC) failed, add_to_kill_pfn() can then consume the
caller's to_kill*.  Then the caller can drop the lock, allocate a new
to_kill* then restart the scan.  And teach add_to_kill_pfn() to not
re-add tasks which are already on the list.  Ugh.

At the very very least we should tell the user that the kernel goofed
and that one of their processes won't be getting killed.

> +	i_mmap_unlock_read(mapping);
> +}
> +
> +/**
> + * memory_failure_pfn - Handle memory failure on a page not backed by
> + *                      struct page.
> + * @pfn: Page Number of the corrupted page
> + * @flags: fine tune action taken
> + *
> + * Return:
> + *   0             - success,
> + *   -EBUSY        - Page PFN does not belong to any address space mapping.
> + */
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +	struct interval_tree_node *node;
> +	LIST_HEAD(tokill);
> +
> +	scoped_guard(mutex, &pfn_space_lock) {
> +		bool mf_handled = false;
> +
> +		/*
> +		 * Modules registers with MM the address space mapping to the device memory they
> +		 * manage. Iterate to identify exactly which address space has mapped to this
> +		 * failing PFN.

We're quite lenient about >80 columns nowadays, but overflowing 80 for
a block comment is rather needless.

> +		for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> +		     node = interval_tree_iter_next(node, pfn, pfn)) {
> +			struct pfn_address_space *pfn_space =
> +				container_of(node, struct pfn_address_space, node);
>
> +			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +
> +			mf_handled = true;
> +		}
> +
> +		if (!mf_handled)
> +			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED);
> +	}
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a different
> +	 * physical page at a given virtual address, so all userspace
> +	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +	 * MF_MUST_KILL)
> +	 */
> +	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +	kill_procs(&tokill, true, pfn, flags);
> +
> +	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +


