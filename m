Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52760CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD86E8E0036; Tue, 19 Aug 2025 07:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0618E0001; Tue, 19 Aug 2025 07:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7798E0036; Tue, 19 Aug 2025 07:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 969B38E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:11:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35EC5138FDB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:11:10 +0000 (UTC)
X-FDA: 83793240300.26.A7FA5BD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A9AC40005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:11:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755601868; a=rsa-sha256;
	cv=none;
	b=l4nZdl6VB9YBCtg5BDkES1ghYWR70VA/BaLw89OABHbs6jwDzZxhy6OY/Ghcf7GVSJ8UTi
	UeyvU3L48PNtokYeUteR6x/kRBb/L0kWNxSWoHOVe/UMA03aicTWnv9YjFJsmWWpYRdD+I
	ONDTlUbwOspO6eSEyJnQqHxjXtAb6X8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755601868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SRN2/Oa2EMqxwks3QvT7WgYfSW+fdXNvFDlNPweVN8Y=;
	b=YbFqZPW0s1OgJDHN89c3aM7l/WBkZo634BzQlx4j0t4TiD4OsitSiJG1Qi0Kvux6smrNUv
	CohHN3WAX6ZFg8QwduL9VnY8DsmFCtRNvZkWmkSY7Sjs8nTW+JIBXfQADUEIU64FI/0HBG
	3PIEbFQ3FJro3BETs+nDU6oFPnf+3oM=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c5myq4b1Fz6H88F;
	Tue, 19 Aug 2025 19:08:03 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 706B014037D;
	Tue, 19 Aug 2025 19:11:03 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 19 Aug 2025 14:11:02 +0300
Message-ID: <7d458b5a-6920-472a-a83c-764c0f00c156@huawei-partners.com>
Date: Tue, 19 Aug 2025 14:10:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 mm-new 1/5] mm: thp: add support for BPF based THP
 order selection
To: Usama Arif <usamaarif642@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <hannes@cmpxchg.org>, <willy@infradead.org>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
	<ameryhung@gmail.com>, <rientjes@google.com>
CC: <bpf@vger.kernel.org>, <linux-mm@kvack.org>
References: <20250818055510.968-1-laoar.shao@gmail.com>
 <20250818055510.968-2-laoar.shao@gmail.com>
 <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 4A9AC40005
X-Stat-Signature: kp5dnhi3xza85865s7z6pndnf4b31qjw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755601867-687709
X-HE-Meta: U2FsdGVkX18sm6pzB5PTmXPCV0LN/rGUwalMxxmWwLDMV+MuVosdgeLzhl1cE/w8/FPOdnJkmVibhDiANYWKILv3IW4/1/If7uB5gayzCn/+lhmTvC4cuxpeUgOVpG+c1CfpqBlvG/XZHeNnuyRyUzzEeSbS67bcZJVAlQlQfjMELET+n+phtc+EuuOOPYtX20huo9xiQFvd0w/4vfjGjP7k9AuVHShgZ9z0B2l0lP0Yk/UuXXn0tVqUb2oDswkKo/ujFv1BEzbAMGZGDW+v9rOeWgLirJ0uoyr6NIe5F+ZHHceK/KWAIZbGEHGp7r4Rk3FdDNVvUAHtTfuVb3K6wPUTGKrkHQJt54HR/xGV97HrrOrovoaKgHwiy3Nv2sqm8KMi7gmMLy7Uk+4N7sqlQhX8+Ftxbzb3jDvyGAVMp9qc4oOOcRUDsz4r79iShBG9d5UoXt5aTfpOE7uk7XmVFZcdUPZ/E/m1+YwZLwbon0mr/DKyd9Nj6DEWmkjsVr1Jv9m+iQ4VHRNH2SCaioxbX/yvX3VFwqXBKuRmNt5tH7FOtzH38nckQ/LrLKpm/v9EcuCPgLGFLuEuPydkF+w/kk69wv8koGiAXZ/DrzkfMh5Y3dnymEsMkdOBRw3K+m/lhmyMAfoPKZxW6Sw5pA4O9xF9Tu9lvM4jAFlC9d5AE7DrpOmzoqSsiLtdHdePFJDZ+afib4ke7IJTKNvC2rRIkMQIEUErMfhAxS2tG4NR2Wuk410hSJG34jdzFExAMVOaHoztl3PP2xs3Ce66a2eSv9xhj84dvykObrDfwRCjngFE817faiJ6jKX6tBpWgRW9zJDYkl9KIpaiF2SJlkMRP04ibyl//tsv8JUCYNJJnqFG1joQpgtpxPVZaSJmnmaa4sv9AaEF+IvJ+aSUBUqBuRT5+aRpssE05oGaWsQcchb7/LXnwEWxEvNszUwmU9RH6Wlf4XtXfs7R9L9Uhi7
 52HNNsQh
 yG0PQt/l7zc0ipA11LVpFzAVfKb6ygLIkTJ9M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/18/2025 4:17 PM, Usama Arif wrote:
> 
> 
> On 18/08/2025 06:55, Yafang Shao wrote:
>> This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
>> THP tuning. It includes a hook get_suggested_order() [0], allowing BPF
>> programs to influence THP order selection based on factors such as:
>> - Workload identity
>>   For example, workloads running in specific containers or cgroups.
>> - Allocation context
>>   Whether the allocation occurs during a page fault, khugepaged, or other
>>   paths.
>> - System memory pressure
>>   (May require new BPF helpers to accurately assess memory pressure.)
>>
>> Key Details:
>> - Only one BPF program can be attached at a time, but it can be updated
>>   dynamically to adjust the policy.
>> - Supports automatic mTHP order selection and per-workload THP policies.
>> - Only functional when THP is set to madise or always.
>>
>> It requires CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION to enable. [1]
>> This feature is unstable and may evolve in future kernel versions.
>>
>> Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redhat.com/ [0]
>> Link: https://lwn.net/ml/all/dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local/ [1]
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>> ---
>>  include/linux/huge_mm.h    |  15 +++
>>  include/linux/khugepaged.h |  12 ++-
>>  mm/Kconfig                 |  12 +++
>>  mm/Makefile                |   1 +
>>  mm/bpf_thp.c               | 186 +++++++++++++++++++++++++++++++++++++
>>  mm/huge_memory.c           |  10 ++
>>  mm/khugepaged.c            |  26 +++++-
>>  mm/memory.c                |  18 +++-
>>  8 files changed, 273 insertions(+), 7 deletions(-)
>>  create mode 100644 mm/bpf_thp.c
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1ac0d06fb3c1..f0c91d7bd267 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -6,6 +6,8 @@
>>  
>>  #include <linux/fs.h> /* only for vma_is_dax() */
>>  #include <linux/kobject.h>
>> +#include <linux/pgtable.h>
>> +#include <linux/mm.h>
>>  
>>  vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
>>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>> @@ -56,6 +58,7 @@ enum transparent_hugepage_flag {
>>  	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
>>  	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
>>  	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
>> +	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
>>  };
>>  
>>  struct kobject;
>> @@ -195,6 +198,18 @@ static inline bool hugepage_global_always(void)
>>  			(1<<TRANSPARENT_HUGEPAGE_FLAG);
>>  }
>>  
>> +#ifdef CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION
>> +int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +			u64 vma_flags, enum tva_type tva_flags, int orders);
>> +#else
>> +static inline int
>> +get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +		    u64 vma_flags, enum tva_type tva_flags, int orders)
>> +{
>> +	return orders;
>> +}
>> +#endif
>> +
>>  static inline int highest_order(unsigned long orders)
>>  {
>>  	return fls_long(orders) - 1;
>> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
>> index eb1946a70cff..d81c1228a21f 100644
>> --- a/include/linux/khugepaged.h
>> +++ b/include/linux/khugepaged.h
>> @@ -4,6 +4,8 @@
>>  
>>  #include <linux/mm.h>
>>  
>> +#include <linux/huge_mm.h>
>> +
>>  extern unsigned int khugepaged_max_ptes_none __read_mostly;
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  extern struct attribute_group khugepaged_attr_group;
>> @@ -22,7 +24,15 @@ extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>  
>>  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>>  {
>> -	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
>> +	/*
>> +	 * THP allocation policy can be dynamically modified via BPF. Even if a
>> +	 * task was allowed to allocate THPs, BPF can decide whether its forked
>> +	 * child can allocate THPs.
>> +	 *
>> +	 * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
>> +	 */
>> +	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm) &&
>> +		get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER)))
> 
> Hi Yafang,
> 
> From the coverletter, one of the potential usecases you are trying to solve for is if global policy
> is "never", but the workload want THPs (either always or on madvise basis). But over here,
> MMF_VM_HUGEPAGE will never be set so in that case mm_flags_test(MMF_VM_HUGEPAGE, oldmm) will
> always evaluate to false and the get_sugested_order call doesnt matter?
> 
> 
> 
>>  		__khugepaged_enter(mm);
>>  }
>>  
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 4108bcd96784..d10089e3f181 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -924,6 +924,18 @@ config NO_PAGE_MAPCOUNT
>>  
>>  	  EXPERIMENTAL because the impact of some changes is still unclear.
>>  
>> +config EXPERIMENTAL_BPF_ORDER_SELECTION
>> +	bool "BPF-based THP order selection (EXPERIMENTAL)"
>> +	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
>> +
>> +	help
>> +	  Enable dynamic THP order selection using BPF programs. This
>> +	  experimental feature allows custom BPF logic to determine optimal
>> +	  transparent hugepage allocation sizes at runtime.
>> +
>> +	  Warning: This feature is unstable and may change in future kernel
>> +	  versions.
>> +
> 
> 
> I know there was a discussion on this earlier, but my opinion is that putting all of this
> as experiment with warnings is not great. No one will be able to deploy this in production
> if its going to be removed, and I believe thats where the real usage is.
> 
If the goal is to deploy it in Kubernetes, I believe eBPF is the wrong way to do it. Right 
now eBPF is used mainly for networking (CNI).

Kubernetes currently has something called Dynamic Resource Allocation (DRA), which is already 
in alpha version. It's main use is to share GPU and TPU among many pods. Still, we should 
take into account how likely the user space is going to use eBPF for controlling resources and 
how it integrates with the mechanisms currently available for resource control by the user 
space.

There is another scenario, when you you have a number of pods and a limit of huge pages you 
want to use among them. Something similar to HugeTLBfs. Could this be achieved with your 
ebpf implementation?

>>  endif # TRANSPARENT_HUGEPAGE
>>  
>>  # simple helper to make the code a bit easier to read
>> diff --git a/mm/Makefile b/mm/Makefile
>> index ef54aa615d9d..cb55d1509be1 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
>>  obj-$(CONFIG_NUMA) += memory-tiers.o
>>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>> +obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) += bpf_thp.o
>>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
>>  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>>  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>> diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
>> new file mode 100644
>> index 000000000000..2b03539452d1
>> --- /dev/null
>> +++ b/mm/bpf_thp.c
>> @@ -0,0 +1,186 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/bpf.h>
>> +#include <linux/btf.h>
>> +#include <linux/huge_mm.h>
>> +#include <linux/khugepaged.h>
>> +
>> +struct bpf_thp_ops {
>> +	/**
>> +	 * @get_suggested_order: Get the suggested THP orders for allocation
>> +	 * @mm: mm_struct associated with the THP allocation
>> +	 * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
>> +	 *                 When NULL, the decision should be based on @mm (i.e., when
>> +	 *                 triggered from an mm-scope hook rather than a VMA-specific
>> +	 *                 context).
>> +	 *                 Must belong to @mm (guaranteed by the caller).
>> +	 * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
>> +	 * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
>> +	 * @orders: Bitmask of requested THP orders for this allocation
>> +	 *          - PMD-mapped allocation if PMD_ORDER is set
>> +	 *          - mTHP allocation otherwise
>> +	 *
>> +	 * Rerurn: Bitmask of suggested THP orders for allocation. The highest
>> +	 *         suggested order will not exceed the highest requested order
>> +	 *         in @orders.
> 
> If we want to make this generic enough so that it doesnt change, should we allow suggested order to
> exceed highest requested order?
> 
>> +	 */
>> +	int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +				   u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;
>> +};
>> +
>> +static struct bpf_thp_ops bpf_thp;
>> +static DEFINE_SPINLOCK(thp_ops_lock);
>> +
>> +int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +			u64 vma_flags, enum tva_type tva_flags, int orders)
>> +{
>> +	int (*bpf_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +				   u64 vma_flags, enum tva_type tva_flags, int orders);
>> +	int suggested_orders = orders;
>> +
>> +	/* No BPF program is attached */
>> +	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>> +		      &transparent_hugepage_flags))
>> +		return suggested_orders;
>> +
>> +	rcu_read_lock();
>> +	bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
>> +	if (!bpf_suggested_order)
>> +		goto out;
> 
> 
> My rcu API knowledge is not the best, but maybe we could do:
> 
> if (!rcu_access_pointer(bpf_thp.get_suggested_order))
> 	return suggested_orders;
> 
> rcu_read_lock();
> bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
> 
> I believe this might be better as you dont acquire the rcu_read_lock and avoid
> the lockdep checks when you do rcu_access_pointer, but I might be wrong
> and hope you or someone on the mailing list corrects me if thats the case :)
> 
>> +
>> +	suggested_orders = bpf_suggested_order(mm, vma__nullable, vma_flags, tva_flags, orders);
>> +	if (highest_order(suggested_orders) > highest_order(orders))
>> +		suggested_orders = orders;
>> +
> 
> Maybe we should allow suggested_order to be greater than order if we want this to be truly generic?
> Not a suggestion to change, just to have a discussion.
> 
>> +out:
>> +	rcu_read_unlock();
>> +	return suggested_orders;
>> +}
>> +
>> +static bool bpf_thp_ops_is_valid_access(int off, int size,
>> +					enum bpf_access_type type,
>> +					const struct bpf_prog *prog,
>> +					struct bpf_insn_access_aux *info)
>> +{
>> +	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
>> +}
>> +
>> +static const struct bpf_func_proto *
>> +bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>> +{
>> +	return bpf_base_func_proto(func_id, prog);
>> +}
>> +
>> +static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
>> +	.get_func_proto = bpf_thp_get_func_proto,
>> +	.is_valid_access = bpf_thp_ops_is_valid_access,
>> +};
>> +
>> +static int bpf_thp_init(struct btf *btf)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int bpf_thp_init_member(const struct btf_type *t,
>> +			       const struct btf_member *member,
>> +			       void *kdata, const void *udata)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int bpf_thp_reg(void *kdata, struct bpf_link *link)
>> +{
>> +	struct bpf_thp_ops *ops = kdata;
>> +
>> +	spin_lock(&thp_ops_lock);
>> +	if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>> +		&transparent_hugepage_flags)) {
>> +		spin_unlock(&thp_ops_lock);
>> +		return -EBUSY;
>> +	}
>> +	WARN_ON_ONCE(bpf_thp.get_suggested_order);
> 
> Should it be WARN_ON_ONCE(rcu_access_pointer(bpf_thp.get_suggested_order)) ?
> 
>> +	WRITE_ONCE(bpf_thp.get_suggested_order, ops->get_suggested_order);
> 
> Should it be rcu_assign_pointer instead of WRITE_ONCE?
> 
>> +	spin_unlock(&thp_ops_lock);
>> +	return 0;
>> +}
>> +
>> +static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
>> +{
>> +	spin_lock(&thp_ops_lock);
>> +	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
>> +	WARN_ON_ONCE(!bpf_thp.get_suggested_order);
> 
> Maybe need to use use rcu_access_pointer here in the warning?
> 
>> +	rcu_replace_pointer(bpf_thp.get_suggested_order, NULL, lockdep_is_held(&thp_ops_lock));
>> +	spin_unlock(&thp_ops_lock);
>> +
>> +	synchronize_rcu();
>> +}
>> +
>> +static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
>> +{
>> +	struct bpf_thp_ops *ops = kdata;
>> +	struct bpf_thp_ops *old = old_kdata;
>> +	int ret = 0;
>> +
>> +	if (!ops || !old)
>> +		return -EINVAL;
>> +
>> +	spin_lock(&thp_ops_lock);
>> +	/* The prog has aleady been removed. */
>> +	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags)) {
>> +		ret = -ENOENT;
>> +		goto out;
>> +	}
>> +	WARN_ON_ONCE(!bpf_thp.get_suggested_order);
> 
> As above about using rcu_access_pointer.
> 
>> +	rcu_replace_pointer(bpf_thp.get_suggested_order, ops->get_suggested_order,
>> +			    lockdep_is_held(&thp_ops_lock));
>> +
>> +out:
>> +	spin_unlock(&thp_ops_lock);
>> +	if (!ret)
>> +		synchronize_rcu();
>> +	return ret;
>> +}
>> +
>> +static int bpf_thp_validate(void *kdata)
>> +{
>> +	struct bpf_thp_ops *ops = kdata;
>> +
>> +	if (!ops->get_suggested_order) {
>> +		pr_err("bpf_thp: required ops isn't implemented\n");
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
>> +			   u64 vma_flags, enum tva_type vm_flags, int orders)
>> +{
>> +	return orders;
>> +}
>> +
>> +static struct bpf_thp_ops __bpf_thp_ops = {
>> +	.get_suggested_order = suggested_order,
>> +};
>> +
>> +static struct bpf_struct_ops bpf_bpf_thp_ops = {
>> +	.verifier_ops = &thp_bpf_verifier_ops,
>> +	.init = bpf_thp_init,
>> +	.init_member = bpf_thp_init_member,
>> +	.reg = bpf_thp_reg,
>> +	.unreg = bpf_thp_unreg,
>> +	.update = bpf_thp_update,
>> +	.validate = bpf_thp_validate,
>> +	.cfi_stubs = &__bpf_thp_ops,
>> +	.owner = THIS_MODULE,
>> +	.name = "bpf_thp_ops",
>> +};
>> +
>> +static int __init bpf_thp_ops_init(void)
>> +{
>> +	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
>> +
>> +	if (err)
>> +		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
>> +	return err;
>> +}
>> +late_initcall(bpf_thp_ops_init);
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d89992b65acc..bd8f8f34ab3c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1349,6 +1349,16 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>  		return ret;
>>  	khugepaged_enter_vma(vma, vma->vm_flags);
>>  
>> +	/*
>> +	 * This check must occur after khugepaged_enter_vma() because:
>> +	 * 1. We may permit THP allocation via khugepaged
>> +	 * 2. While simultaneously disallowing THP allocation
>> +	 *    during page fault handling
>> +	 */
>> +	if (get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_PAGEFAULT, BIT(PMD_ORDER)) !=
>> +				BIT(PMD_ORDER))
>> +		return VM_FAULT_FALLBACK;
>> +
>>  	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>>  			!mm_forbids_zeropage(vma->vm_mm) &&
>>  			transparent_hugepage_use_zero_page()) {
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d3d4f116e14b..935583626db6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -474,7 +474,9 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>>  {
>>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>>  	    hugepage_pmd_enabled()) {
>> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>> +		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER) &&
>> +		    get_suggested_order(vma->vm_mm, vma, vm_flags, TVA_KHUGEPAGED,
>> +					BIT(PMD_ORDER)))
>>  			__khugepaged_enter(vma->vm_mm);
>>  	}
>>  }
>> @@ -934,6 +936,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>>  		return SCAN_ADDRESS_RANGE;
>>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
>>  		return SCAN_VMA_CHECK;
>> +	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, type, BIT(PMD_ORDER)))
>> +		return SCAN_VMA_CHECK;
>>  	/*
>>  	 * Anon VMA expected, the address may be unmapped then
>>  	 * remapped to file after khugepaged reaquired the mmap_lock.
>> @@ -1465,6 +1469,11 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>>  		/* khugepaged_mm_lock actually not necessary for the below */
>>  		mm_slot_free(mm_slot_cache, mm_slot);
>>  		mmdrop(mm);
>> +	} else if (!get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER))) {
>> +		hash_del(&slot->hash);
>> +		list_del(&slot->mm_node);
>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>> +		mm_slot_free(mm_slot_cache, mm_slot);
>>  	}
>>  }
>>  
>> @@ -1538,6 +1547,9 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>  		return SCAN_VMA_CHECK;
>>  
>> +	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_FORCED_COLLAPSE,
>> +				 BIT(PMD_ORDER)))
>> +		return SCAN_VMA_CHECK;
>>  	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
>>  	if (userfaultfd_wp(vma))
>>  		return SCAN_PTE_UFFD_WP;
>> @@ -2416,6 +2428,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>  	 * the next mm on the list.
>>  	 */
>>  	vma = NULL;
>> +
>> +	/* If this mm is not suitable for the scan list, we should remove it. */
>> +	if (!get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER)))
>> +		goto breakouterloop_mmap_lock;
>>  	if (unlikely(!mmap_read_trylock(mm)))
>>  		goto breakouterloop_mmap_lock;
>>  
>> @@ -2432,7 +2448,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>  			progress++;
>>  			break;
>>  		}
>> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>> +		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER) ||
>> +		    !get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_KHUGEPAGED,
>> +					 BIT(PMD_ORDER))) {
>>  skip:
>>  			progress++;
>>  			continue;
>> @@ -2769,6 +2787,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>>  		return -EINVAL;
>>  
>> +	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_FORCED_COLLAPSE,
>> +				 BIT(PMD_ORDER)))
>> +		return -EINVAL;
>> +
>>  	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
>>  	if (!cc)
>>  		return -ENOMEM;
>> diff --git a/mm/memory.c b/mm/memory.c
>> index d9de6c056179..0178857aa058 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4486,6 +4486,7 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
>>  static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>  {
>>  	struct vm_area_struct *vma = vmf->vma;
>> +	int order, suggested_orders;
>>  	unsigned long orders;
>>  	struct folio *folio;
>>  	unsigned long addr;
>> @@ -4493,7 +4494,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>  	spinlock_t *ptl;
>>  	pte_t *pte;
>>  	gfp_t gfp;
>> -	int order;
>>  
>>  	/*
>>  	 * If uffd is active for the vma we need per-page fault fidelity to
>> @@ -4510,13 +4510,18 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>  	if (!zswap_never_enabled())
>>  		goto fallback;
>>  
>> +	suggested_orders = get_suggested_order(vma->vm_mm, vma, vma->vm_flags,
>> +					       TVA_PAGEFAULT,
>> +					       BIT(PMD_ORDER) - 1);
>> +	if (!suggested_orders)
>> +		goto fallback;
>>  	entry = pte_to_swp_entry(vmf->orig_pte);
>>  	/*
>>  	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
>>  	 * and suitable for swapping THP.
>>  	 */
>>  	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
>> -					  BIT(PMD_ORDER) - 1);
>> +					  suggested_orders);
>>  	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
>>  	orders = thp_swap_suitable_orders(swp_offset(entry),
>>  					  vmf->address, orders);
>> @@ -5044,12 +5049,12 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>>  {
>>  	struct vm_area_struct *vma = vmf->vma;
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	int order, suggested_orders;
>>  	unsigned long orders;
>>  	struct folio *folio;
>>  	unsigned long addr;
>>  	pte_t *pte;
>>  	gfp_t gfp;
>> -	int order;
>>  
>>  	/*
>>  	 * If uffd is active for the vma we need per-page fault fidelity to
>> @@ -5058,13 +5063,18 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>>  	if (unlikely(userfaultfd_armed(vma)))
>>  		goto fallback;
>>  
>> +	suggested_orders = get_suggested_order(vma->vm_mm, vma, vma->vm_flags,
>> +					       TVA_PAGEFAULT,
>> +					       BIT(PMD_ORDER) - 1);
>> +	if (!suggested_orders)
>> +		goto fallback;
>>  	/*
>>  	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
>>  	 * for this vma. Then filter out the orders that can't be allocated over
>>  	 * the faulting address and still be fully contained in the vma.
>>  	 */
>>  	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
>> -					  BIT(PMD_ORDER) - 1);
>> +					  suggested_orders);
>>  	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
>>  
>>  	if (!orders)
> 
> 

-- 
Asier Gutierrez
Huawei


