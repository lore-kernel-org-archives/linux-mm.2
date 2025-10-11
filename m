Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BC2CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 03:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F558E0033; Fri, 10 Oct 2025 23:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56E88E0011; Fri, 10 Oct 2025 23:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993C98E0033; Fri, 10 Oct 2025 23:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8744B8E0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 23:25:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 246C659358
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:25:15 +0000 (UTC)
X-FDA: 83984392590.21.CD63B3D
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf05.hostedemail.com (Postfix) with ESMTP id 29CD510000C
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 03:25:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IHiwSM+r;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760153113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cgrLws/g/ZDDcluUo1suv7XC4LyyVazKzOg2Lmmaec=;
	b=DwlJKO4DInkjP0XO5oK8tRKNXwUpxXV4GrBrkAzQVEOqRb8Zl8FJHrsG0O9yqBfsk7Tun0
	egrnXmrZh7VA+we62IkwSjzm8UCYyobs5JDygcSGdCdk5KknRcbZm/Srh0oCJuFpMf3rUC
	DwiFdkjUwXVVtImMNg7UtBnNIy+O+9w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=IHiwSM+r;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760153113; a=rsa-sha256;
	cv=none;
	b=gFpl6SwlQk0mFEnPLJNOvZFZM3f8q0kVEWLUonIQ4G4Uzgw7p2d568kUlWE7DAsIi6FQtA
	pJkvBtAPqdxPjnDVSvHSah7k7YaLxquopNtk3TuMfUBlgx0RHKIG7tsiJjbf1emZjmcFjW
	mGLWxrfd2iSjmcA3mWL1Nh52iWYTyH8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1cgrLws/g/ZDDcluUo1suv7XC4LyyVazKzOg2Lmmaec=;
	b=IHiwSM+rfVffy/uqQarOd7ri7XZqbY0rLnx3v4fUehrUQYgNVqcSsEPVo7VoPmrFvvPLFLaZx
	Ku6Q5WivarotbzeMQF6McotHTUwGs1J4hJlXJtAcxchh1E7oa/DgobJPCaJ45q/kQ3LqZDYse27
	CvSx9MRX1HH/sJzzpzEB9d0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4ck89q1HxkzmV99;
	Sat, 11 Oct 2025 11:24:47 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D1CEC140338;
	Sat, 11 Oct 2025 11:25:04 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 11:25:04 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 11:25:03 +0800
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Longlong Xia <xialonglong2025@163.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>,
	<wangkefeng.wang@huawei.com>, <xu.xin16@zte.com.cn>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Longlong Xia
	<xialonglong@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <29b87f61-7e10-449a-21fa-106b4ae3442b@huawei.com>
Date: Sat, 11 Oct 2025 11:25:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251009070045.2011920-2-xialonglong2025@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29CD510000C
X-Stat-Signature: 3wm5iy88zk9sy9htmgab8metkwh4iwnz
X-Rspam-User: 
X-HE-Tag: 1760153110-561590
X-HE-Meta: U2FsdGVkX18DECjRPagDT/kaaH+Q7iBcr9xNbKKVPW3+rAkm2qZ8tOOqefuXBoMnfewpNAO1HoG5cSFT26ear/qyU1j3ppQ+kDP5PjY/OrxPEsJtcrwTas8ip03wRJBZkiOgNE2DJe4xYfeP4cLmpbchBkzHrLLNNFqmXkR1EnWd/8GUwkNda0j9bPuJMxwVylITmCrROMa7lrssc+RoC1zkMMJFd42lTfQnzjzVmkNqq9TOwxIFhvztpyr3z5yxrYQhFNIzKN9N72b5B9lKiEEIOX5tSIhZQypTsBMkuNOWS5NS/VyBDzDHduNrjoq7O49yGvGIYbk+NGwGxDkAArjZgGAiQ+f2GfxpEVBbGSP1O7WXASDoWjQ/L4UobRLFKEeR9MFcOeNCQWf+2E7UWh+Gk5MD4PTNHnyiDd8YVflWmEXwIs4TM8l1GvA9sWTA820tTnpzN9pzdP2zo9YK0ieoxopzybE6hhxOb9b2nb7Ym7eQtfXbO0EceyWRr6YsrzjBWrMG+5nSkH2aIO+OtZT2fpU6DSAx1IfHrVkkYmSqJDQSlkQXuPDNYv30tTxvvD4Sl1cmMFiVcNZIoDlxqC1IGXcMlIOb4ai3DfpC04mHTg//Z5d3g12uajnLKpDJYfsQHxzpk2hICmWhk29svPzuj5S6iNETxKap2ga6ijUEYg8CffU6/L4JVmg9jhm+4FlBTL3iHLJBiPZ3jc5aIJ9jEpU7vVORpEL0wUpjDZJlciwLSCyk6iF1vTtIiZTGj5mWbOuHq6abd5nSw5NAkUtnBX7GC15YzYAZ5Reb4iFhT8Z02H7nvWjgs9i+0YXE9axgqugRp0w6tXL4g5rp6t/g4c05WWVE6n9jlNSCcuRvOpSwAwTVqyrf/nAOl9pHrKOasM/WeLj6pGKTYvMp48SNPmu17wn8+EDBjRP/W0ACU/WAwOatCLzyERHk82RZsoMg+Vd7S9N9vfgJwk3
 uEojNkCS
 hV5ZOex5Pk4VnyoZzzDH4aWv6dG9bO0f/hmaOGf8ObUiMiaXw4f2KQgBWjWZnYdhuN4fUf9BRjehoUxzWkNIclNJN3Z5AwyYO/s2Zallwnbhwp5hsh7CjsSVrYlpgcvdMtT1vCNkBuBTFrvSDYVSPZQls+/Iofd6ET6jmR73GTLlYZzpnXas/BT7Q1N7yPRSntWss3FiI+K2gBKP0CvtusVCrxTlEEivDdclhXm+wi2Yd8eiSl4jwf/VCrXyoGmMWOr86QpOiGLJVTOAfiw79pKpWwBcPxlG+3tVSWdTZZ2dPSh8SKPWF85CWaGihRmdDBAYEDeR2fXd9HgKk+quCH9paWdyHb0ZWLE5p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/9 15:00, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
> 
> This patch introduces a recovery mechanism that attempts to migrate
> mappings from the failing KSM page to another healthy KSM page within
> the same chain before resorting to killing processes.
> 
> The recovery process works as follows:
> 1. When a memory failure is detected on a KSM page, identify if the
> failing node is part of a chain (has duplicates)
> 2. Search for another healthy KSM page within the same chain
> 3. For each process mapping the failing page:
> - Update the PTE to point to the healthy KSM page
> - Migrate the rmap_item to the new stable node
> 4. If all migrations succeed, remove the failing node from the chain
> 5. Only kill processes if recovery is impossible or fails

Thanks for your patch. This looks really interesting to me and
I think this might be a significant improvement. :)

> 
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/ksm.c | 183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..590d30cfe800 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3084,6 +3084,183 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  }
>  
>  #ifdef CONFIG_MEMORY_FAILURE
> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *dup_node)
> +{
> +	struct ksm_stable_node *stable_node, *dup;
> +	struct rb_node *node;
> +	int nid;
> +
> +	if (!is_stable_node_dup(dup_node))
> +		return NULL;
> +
> +	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
> +		node = rb_first(root_stable_tree + nid);
> +		for (; node; node = rb_next(node)) {
> +			stable_node = rb_entry(node,
> +					       struct ksm_stable_node,
> +					       node);
> +
> +			if (!is_stable_node_chain(stable_node))
> +				continue;
> +
> +			hlist_for_each_entry(dup, &stable_node->hlist,
> +					     hlist_dup) {
> +				if (dup == dup_node)
> +					return stable_node;
> +			}
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct folio *
> +find_target_folio(struct ksm_stable_node *failing_node, struct ksm_stable_node **target_dup)
> +{
> +	struct ksm_stable_node *chain_head, *dup;
> +	struct hlist_node *hlist_safe;
> +	struct folio *target_folio;
> +
> +	if (!is_stable_node_dup(failing_node))
> +		return NULL;
> +
> +	chain_head = find_chain_head(failing_node);
> +	if (!chain_head)
> +		return NULL;
> +
> +	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
> +		if (dup == failing_node)
> +			continue;
> +
> +		target_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
> +		if (target_folio) {
> +			*target_dup = dup;
> +			return target_folio;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static int replace_failing_page(struct vm_area_struct *vma, struct page *page,
> +			struct page *kpage, unsigned long addr)
> +{
> +	struct folio *kfolio = page_folio(kpage);
> +	struct mm_struct *mm = vma->vm_mm;
> +	struct folio *folio = page_folio(page);
> +	pmd_t *pmd;
> +	pte_t *ptep;
> +	pte_t newpte;
> +	spinlock_t *ptl;
> +	int err = -EFAULT;
> +	struct mmu_notifier_range range;
> +
> +	pmd = mm_find_pmd(mm, addr);
> +	if (!pmd)
> +		goto out;
> +
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
> +				addr + PAGE_SIZE);
> +	mmu_notifier_invalidate_range_start(&range);
> +
> +	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	if (!ptep)
> +		goto out_mn;
> +
> +	if (!is_zero_pfn(page_to_pfn(kpage))) {
> +		folio_get(kfolio);
> +		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
> +		newpte = mk_pte(kpage, vma->vm_page_prot);
> +	} else {
> +		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
> +		ksm_map_zero_page(mm);
> +		dec_mm_counter(mm, MM_ANONPAGES);
> +	}
> +
> +	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
> +	ptep_clear_flush(vma, addr, ptep);
> +	set_pte_at(mm, addr, ptep, newpte);
> +
> +	folio_remove_rmap_pte(folio, page, vma);
> +	if (!folio_mapped(folio))
> +		folio_free_swap(folio);
> +	folio_put(folio);
> +
> +	pte_unmap_unlock(ptep, ptl);
> +	err = 0;
> +out_mn:
> +	mmu_notifier_invalidate_range_end(&range);
> +out:
> +	return err;
> +}
> +
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
> +{
> +	struct ksm_rmap_item *rmap_item;
> +	struct hlist_node *hlist_safe;
> +	struct folio *failing_folio = NULL;
> +	struct folio *target_folio = NULL;
> +	struct ksm_stable_node *target_dup = NULL;
> +	int err;
> +
> +	if (!is_stable_node_dup(failing_node))
> +		return false;
> +
> +	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
> +	if (!failing_folio)
> +		return false;
> +
> +	target_folio = find_target_folio(failing_node, &target_dup);
> +	if (!target_folio) {
> +		folio_put(failing_folio);
> +		return false;
> +	}
> +
> +	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
> +		struct mm_struct *mm = rmap_item->mm;
> +		unsigned long addr = rmap_item->address & PAGE_MASK;
> +		struct vm_area_struct *vma;
> +
> +		mmap_read_lock(mm);

I briefly looked at the code and find lock order might be broken here.
mm/filemap.c documents the lock order as below:

 *  ->mmap_lock
 *    ->invalidate_lock		(filemap_fault)
 *      ->lock_page		(filemap_fault, access_process_vm)
 *

But mmap_lock is held after folio is locked here. Is this a problem?

Thanks.
.

