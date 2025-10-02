Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 033B5CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6C08E0003; Thu,  2 Oct 2025 12:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557348E0002; Thu,  2 Oct 2025 12:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493F08E0003; Thu,  2 Oct 2025 12:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 388468E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:17:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D722C87892
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:17:15 +0000 (UTC)
X-FDA: 83953678830.11.3092FEC
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 853E140015
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:17:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759421834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIFW/REVXBnQN3iC9A7VYQz++PejQMyqKH9gYrvZCbc=;
	b=AaDTasZqsZ1B59pQMGTduNH2dZFxrDz4oVCeNtVLI844SaFgWeYJlEPaH7S1ZryacGKa5H
	JaCAAtqHqXvbA7p3VTy3AjuIk4fXQMBXGpQKQzvhPrXBABVQV1FUtJaqtfcBP9cgQ3VeA1
	iJPnpJhipvlWaYxl4lNBG8ddruD61JI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759421834; a=rsa-sha256;
	cv=none;
	b=c1rhFNsoykIo+XYDnUZwCfvTwRstJJmQsiU/yR/F/eyd6NyLIfDn5UaypfqhRNLyqk3w2J
	whHhhY+eKer4hizkX2owa81GXYk+8RHuNEqa1V27jSAjds2REwgUVe0toiOjJ5vp04+Rn4
	B/QHgSRuIDd+9L4y/Qk+3ufi3ajs9rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccxgV6Hykz6M4d6;
	Fri,  3 Oct 2025 00:13:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E933A1400D9;
	Fri,  3 Oct 2025 00:17:08 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 17:17:06 +0100
Date: Thu, 2 Oct 2025 17:17:05 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <yuanchu@google.com>,
	<kinseyho@google.com>, <hdanton@sina.com>, <harry.yoo@oracle.com>
Subject: Re: [RFC PATCH V3 06/17] mm/migration: migrate accessed folios to
 toptier node
Message-ID: <20251002171705.00007740@huawei.com>
In-Reply-To: <20250814153307.1553061-7-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
	<20250814153307.1553061-7-raghavendra.kt@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: 6nuo3uncug7a5g5xran14emhnd66156r
X-Rspamd-Queue-Id: 853E140015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759421833-109120
X-HE-Meta: U2FsdGVkX1+iKDHPV/2jPJW8K2NoCQ2NTGHQioHaS4kwQdUgIl0Ld2Jm5h8QmUVnesQFhcYyq21sZUqOtYWi1U0cvPc5NW6wEnn6Ll1IqkeJkb6bx7cYug/LFUaosAvHOzWBY2Ews8COaO7Z8eV0rebzA0DI3+QWPKlIeczAPujaDwwQ4O0RLVuIiRn8tv6djaFpDUXs1xhHvIZx6vTCkn4BwDgJuyATGR9mQCazO/RJfkVhyWuw2a6p4vr2IRHREGmUk/x05i+MqPN8ek/kMGOmxi/0YfxHCoerMpE1Y7L3YopYaEndNlxXEKmhrAiYnkw7rcAlznRvUPLV8BbWcDYgxcirhzsx6+9/Qxpzf1843n2962Fd/cPIbT3HdqIB7ckY4VXihW+7vk0HXRCp0m511Hpa72M4aOmWt2K5aJc7MjZx+yRiSTu+smD+0ySHg68vDM0BEw7cpI3FbI2TF7hJ6Ed4mbcaoUYTMJ6FXlBf+N4McYayNK4UMAbEDTxneStXttaofE3tQBobwUbOqXZDzi5r22h8bM/BB3cNvXfFE+IiRxu/c4uh4b5EEGj9cuvXyKlsN2LlsjrfgfL0GHJvzDW6SVKTm+44m9o/mgDKSM73G7vPncWgyTdVylh5qs6u6XL/GhKcC5WEZUvfGvGbhRk0apwyXIgTLa0CGtQjc1HuDfrdDNbpleJuXDnVuV50lV2kyLQZD/me35fkX6rgqv9lmmWp+Z/8GMV5/+FLo6LXu8Bvfsd3rWh36DAqm2Jxr9Bm/opqslmuodT2YrUJBnamBN7QIPBnUC1CDu57YQHFWrLUimFoWMgE6DnARhmh4/fXzfc7lXta2qNGw8k1W/ZuQcsPwcu3pq5DUhoSgkU8/+/1KjTCzdS98DYw9aMsuP1H+qggdvEjPZNDi6joKVxuXLkffCT8l7B/LSdLbbxxNRGW+w+z4XUyXbWZtUp8iSOaXaZ7eOJMhl2
 VNghvmKG
 EnY94VfcF+rLCwcGNpGs2RA8jQQnlJyEgXB7MWX52QI8SyannzQGr41JS/yBvT4Eoj9InrwXcMX3i6yVPOYJm7lNCUnRDOaJOhJjJ14JL3egDUiVM5mm9P94ycc/lbPt9s0ZJMdGUkM0+Pzf4t/5Y1DTNrJyVi0IuE5ka4UI9BjVjbU8fF6nD5zgmuJkDXcJUlQIN4rAoCoEqe57bUb52/XxmihTibJkYwkDz35JnNTiiRJMmKRuUFueQiqhxgV6qc2t4JpoZJMylMSNvwEw62CVlHIkbXQpGCt7Z7bspWNI5hRQX3xxZSWTmXTFTRL7sEECNZAZ6KY0seB6EvGwd/4G2yqu4quXlRpt4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 15:32:56 +0000
On Thu, 14 Aug 2025 15:32:56 +0000
Raghavendra K T <raghavendra.kt@amd.com> wrote:

> A per mm migration list is added and a kernel thread iterates over
> each of them.
> 
> For each recently accessed slowtier folio in the migration list:
>  - Isolate LRU pages
>  - Migrate to a regular node.
> 
> The rationale behind whole migration is to speedup the access to
> recently accessed pages.
> 
> Currently, PTE A bit scanning approach lacks the information about
> exact destination node to migrate to.
> 
> Reason:
>  PROT_NONE hint fault based scanning is done in a process context. Here
> when the fault occurs, source CPU of the fault associated the task is
> known. Time of page access is also accurate.
> With the lack of above information, migration is done to node 0 by default.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>

Some superficial stuff inline.  I'm still getting my head around the overall
approach.

> diff --git a/mm/kscand.c b/mm/kscand.c
> index 55efd0a6e5ba..5cd2764114df 100644
> --- a/mm/kscand.c
> +++ b/mm/kscand.c

>  static inline bool is_valid_folio(struct folio *folio)
>  {
>  	if (!folio || !folio_mapped(folio) || !folio_raw_mapping(folio))
> @@ -145,18 +272,113 @@ static inline bool is_valid_folio(struct folio *folio)
>  	return true;
>  }
>  
> -static inline void kmigrated_wait_work(void)
> +enum kscand_migration_err {
> +	KSCAND_NULL_MM = 1,
> +	KSCAND_EXITING_MM,
> +	KSCAND_INVALID_FOLIO,
> +	KSCAND_NONLRU_FOLIO,
> +	KSCAND_INELIGIBLE_SRC_NODE,
> +	KSCAND_SAME_SRC_DEST_NODE,
> +	KSCAND_PTE_NOT_PRESENT,
> +	KSCAND_PMD_NOT_PRESENT,
> +	KSCAND_NO_PTE_OFFSET_MAP_LOCK,
> +	KSCAND_NOT_HOT_PAGE,
> +	KSCAND_LRU_ISOLATION_ERR,
> +};
> +
> +

One line probably appropriate here.

> +static bool is_hot_page(struct folio *folio)
>  {
> -	const unsigned long migrate_sleep_jiffies =
> -		msecs_to_jiffies(kmigrate_sleep_ms);
> +	bool ret = false;
>  
> -	if (!migrate_sleep_jiffies)
> -		return;
> +	if (!folio_test_idle(folio))
> +		ret = folio_test_referenced(folio) || folio_test_young(folio);
>  
> -	kmigrated_sleep_expire = jiffies + migrate_sleep_jiffies;
> -	wait_event_timeout(kmigrated_wait,
> -			true,
> -			migrate_sleep_jiffies);
> +	return ret;
> +}
> +
> +static int kmigrated_promote_folio(struct kscand_migrate_info *info,
> +					struct mm_struct *mm,
> +					int destnid)
> +{
> +	unsigned long pfn;
> +	unsigned long address;
> +	struct page *page;
> +	struct folio *folio = NULL;
> +	int ret;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +	spinlock_t *ptl;
> +	pmd_t pmde;
> +	int srcnid;
> +
> +	if (mm == NULL)
> +		return KSCAND_NULL_MM;
> +
> +	if (mm == READ_ONCE(kmigrated_cur_mm) &&
> +		READ_ONCE(kmigrated_clean_list)) {
> +		WARN_ON_ONCE(mm);
> +		return KSCAND_EXITING_MM;
> +	}
> +
> +	pfn = info->pfn;
> +	address = info->address;
> +	page = pfn_to_online_page(pfn);
> +
> +	if (page)
> +		folio = page_folio(page);
> +
> +	if (!page || PageTail(page) || !is_valid_folio(folio))
> +		return KSCAND_INVALID_FOLIO;
> +
> +	if (!folio_test_lru(folio))
> +		return KSCAND_NONLRU_FOLIO;
> +
> +	if (!is_hot_page(folio))
> +		return KSCAND_NOT_HOT_PAGE;
> +
> +	folio_get(folio);
> +
> +	srcnid = folio_nid(folio);
> +
> +	/* Do not try to promote pages from regular nodes */
> +	if (!kscand_eligible_srcnid(srcnid)) {
> +		folio_put(folio);
> +		return KSCAND_INELIGIBLE_SRC_NODE;
> +	}
> +
> +	/* Also happen when it is already migrated */
> +	if (srcnid == destnid) {
> +		folio_put(folio);
> +		return KSCAND_SAME_SRC_DEST_NODE;
> +	}
> +
> +	address = info->address;
> +	pmd = pmd_off(mm, address);
> +	pmde = pmdp_get(pmd);
> +
> +	if (!pmd_present(pmde)) {
> +		folio_put(folio);
> +		return KSCAND_PMD_NOT_PRESENT;
> +	}
> +
> +	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
> +	if (!pte) {
> +		folio_put(folio);
> +		WARN_ON_ONCE(!pte);
> +		return KSCAND_NO_PTE_OFFSET_MAP_LOCK;
> +	}
> +
> +	ret = kscand_migrate_misplaced_folio_prepare(folio, NULL, destnid);
> +
> +	folio_put(folio);
> +	pte_unmap_unlock(pte, ptl);
> +
> +	if (ret)
> +		return KSCAND_LRU_ISOLATION_ERR;
> +
One line enough.

> +
> +	return  migrate_misplaced_folio(folio, destnid);
extra space after return.
>  }
>  
>  static bool folio_idle_clear_pte_refs_one(struct folio *folio,
> @@ -302,6 +524,115 @@ static inline int kscand_test_exit(struct mm_struct *mm)
>  	return atomic_read(&mm->mm_users) == 0;
>  }
>  
> +struct destroy_list_work {
> +	struct list_head migrate_head;
> +	struct work_struct dwork;
> +};
> +
> +static void kmigrated_destroy_list_fn(struct work_struct *work)
> +{
> +	struct destroy_list_work *dlw;
> +	struct kscand_migrate_info *info, *tmp;
> +
> +	dlw = container_of(work, struct destroy_list_work, dwork);
> +
> +	if (!list_empty(&dlw->migrate_head)) {

Similar to below.  I'm not sure this check is worth having unless something else ends
up under it later.

> +		list_for_each_entry_safe(info, tmp, &dlw->migrate_head,	migrate_node) {
> +			list_del(&info->migrate_node);
> +			kfree(info);
> +		}
> +	}
> +
> +	kfree(dlw);
> +}
> +
> +static void kmigrated_destroy_list(struct list_head *list_head)
> +{
> +	struct destroy_list_work *destroy_list_work;
> +

One blank line

> +
> +	destroy_list_work = kmalloc(sizeof(*destroy_list_work), GFP_KERNEL);
> +	if (!destroy_list_work)
> +		return;
> +
> +	INIT_LIST_HEAD(&destroy_list_work->migrate_head);
> +	list_splice_tail_init(list_head, &destroy_list_work->migrate_head);
> +	INIT_WORK(&destroy_list_work->dwork, kmigrated_destroy_list_fn);
> +	schedule_work(&destroy_list_work->dwork);
> +}

> +
> +static void kscand_cleanup_migration_list(struct mm_struct *mm)
> +{
> +	struct kmigrated_mm_slot *mm_slot;
> +	struct mm_slot *slot;
> +
> +	mm_slot = kmigrated_get_mm_slot(mm, false);
> +
> +	slot = &mm_slot->mm_slot;
Maybe combine these with declrations.

	struct kmigrated_mm_slot *mm_slot = kmigrated_get_mm_slot(mm, false);
	struct mm_slot *slot = &mm_slot->mm_slot;

seems clear enough (assuming nothing else is added later).

> +
> +	if (mm_slot && slot && slot->mm == mm) {
> +		spin_lock(&mm_slot->migrate_lock);
> +
> +		if (!list_empty(&mm_slot->migrate_head)) {
> +			if (mm == READ_ONCE(kmigrated_cur_mm)) {
> +				/* A folio in this mm is being migrated. wait */
> +				WRITE_ONCE(kmigrated_clean_list, true);
> +			}
> +
> +			kmigrated_destroy_list(&mm_slot->migrate_head);
> +			spin_unlock(&mm_slot->migrate_lock);
> +retry:
> +			if (!spin_trylock(&mm_slot->migrate_lock)) {
> +				cpu_relax();
> +				goto retry;
> +			}
> +
> +			if (mm == READ_ONCE(kmigrated_cur_mm)) {
> +				spin_unlock(&mm_slot->migrate_lock);
> +				goto retry;
> +			}
> +		}
> +		/* Reset migrated mm_slot if it was pointing to us */
> +		if (kmigrated_daemon.mm_slot == mm_slot)
> +			kmigrated_daemon.mm_slot = NULL;
> +
> +		hash_del(&slot->hash);
> +		list_del(&slot->mm_node);
> +		mm_slot_free(kmigrated_slot_cache, mm_slot);
> +
> +		WRITE_ONCE(kmigrated_clean_list, false);
> +
> +		spin_unlock(&mm_slot->migrate_lock);
> +		}

Something odd with indent here.

> +}
> +
>  static void kscand_collect_mm_slot(struct kscand_mm_slot *mm_slot)
>  {
>  	struct mm_slot *slot = &mm_slot->slot;
> @@ -313,11 +644,77 @@ static void kscand_collect_mm_slot(struct kscand_mm_slot *mm_slot)
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
>  
> +		kscand_cleanup_migration_list(mm);
> +
>  		mm_slot_free(kscand_slot_cache, mm_slot);
>  		mmdrop(mm);
>  	}
>  }
>  
> +static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
> +{
> +	int ret = 0, dest = -1;
> +	struct mm_slot *slot;
> +	struct mm_struct *mm;
> +	struct kscand_migrate_info *info, *tmp;
> +
> +	spin_lock(&mm_slot->migrate_lock);
> +
> +	slot = &mm_slot->mm_slot;
> +	mm = slot->mm;
> +
> +	if (!list_empty(&mm_slot->migrate_head)) {

If it's empty the iterating the list will do nothing. So is this check
useful?  Maybe other code comes under this check later though.


> +		list_for_each_entry_safe(info, tmp, &mm_slot->migrate_head,
> +				migrate_node) {
> +			if (READ_ONCE(kmigrated_clean_list))
> +				goto clean_list_handled;

Currently same a break. I assume this will change later in patch, if so
ignore this comment.

> +
> +			list_del(&info->migrate_node);
> +
> +			spin_unlock(&mm_slot->migrate_lock);
> +
> +			dest = kscand_get_target_node(NULL);
> +			ret = kmigrated_promote_folio(info, mm, dest);
> +
> +			kfree(info);
> +
> +			cond_resched();
> +			spin_lock(&mm_slot->migrate_lock);
> +		}
> +	}
> +clean_list_handled:
> +	/* Reset  mm  of folio entry we are migrating */
> +	WRITE_ONCE(kmigrated_cur_mm, NULL);
> +	spin_unlock(&mm_slot->migrate_lock);
> +}


> @@ -621,6 +1040,13 @@ static int __init kscand_init(void)
>  		return -ENOMEM;
>  	}
>  
> +	kmigrated_slot_cache = KMEM_CACHE(kmigrated_mm_slot, 0);
> +

Drop this blank line to keep call + error check closely associated.

> +	if (!kmigrated_slot_cache) {
> +		pr_err("kmigrated: kmem_cache error");
> +		return -ENOMEM;
> +	}
> +
>  	init_list();
>  	err = start_kscand();
>  	if (err)
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 2c88f3b33833..1f74dd5e6776 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2541,7 +2541,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
>   * Returns true if this is a safe migration target node for misplaced NUMA
>   * pages. Currently it only checks the watermarks which is crude.
>   */
> -static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
> +bool migrate_balanced_pgdat(struct pglist_data *pgdat,
>  				   unsigned long nr_migrate_pages)

Update parameter alignment as well.

>  {
>  	int z;

