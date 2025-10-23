Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF300CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1748C8E0018; Thu, 23 Oct 2025 07:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCE58E000D; Thu, 23 Oct 2025 07:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDF98E0011; Thu, 23 Oct 2025 07:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE6AD8E0011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:54:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 622F1129B42
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:54:55 +0000 (UTC)
X-FDA: 84029222550.18.D23F419
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1817140010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:54:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Pui08ptZSq0nWsSYP3N10MY9UesZb5InUZ8xTSO70=;
	b=JWBIkyYKAEDbmUTR6vT2eQU+/8eP/Njgr49EZXYPJ6g3E7VwN48AiPvOPhGptqmRqrmMf7
	cUmmIpTXAYAgfIbn9Uc6t7/kXY0I56u5dbWX0BvkYN58bnME3ZZEC4oOjdoSWb2BwIwaXi
	zTGJib+d8j03yioleOGuLQQD9UV62n0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220493; a=rsa-sha256;
	cv=none;
	b=RNq7ufOZOEqaSVgOrcPVZFke5l9wpxp3YfQKsbMZEre/A5/ql7oOyS9GPj74+Vf8osk8JJ
	vOetRcdOQU6YU2lK20WPAUR/okQ9PNouQaSpc2OdCmTPOFowV54uMv3wGcaszGxAbsEYvQ
	wExl9zJBr8VysIdByr5y1WUF6SNyDyw=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cskq62wcKz2CgpS;
	Thu, 23 Oct 2025 19:49:54 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 31E2E14011B;
	Thu, 23 Oct 2025 19:54:46 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:54:45 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:54:45 +0800
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: Longlong Xia <xialonglong2025@163.com>
CC: <markus.elfring@web.de>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <wangkefeng.wang@huawei.com>,
	<qiuxu.zhuo@intel.com>, <xu.xin16@zte.com.cn>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Longlong Xia
	<xialonglong@kylinos.cn>, <david@redhat.com>, <lance.yang@linux.dev>
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <20251016101813.484565-2-xialonglong2025@163.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <af769443-e855-81d0-a44a-d5890f5d1d2f@huawei.com>
Date: Thu, 23 Oct 2025 19:54:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251016101813.484565-2-xialonglong2025@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: C1817140010
X-Rspamd-Server: rspam03
X-Stat-Signature: 96yuiosj1q9aw7n5ytm9o871qk1fz1ao
X-HE-Tag: 1761220491-583959
X-HE-Meta: U2FsdGVkX19j/awrFiWoWDj9viWJL/SvT4shZ0SgIYXT8BY5TDwHSpz6RwZPHDwpO+MQiayYtRGJ+qXeP6bRjxGSINi2qJl3jPdhFc9WPilH0eb2noFrmLn0JiKPsnVfy4STZpttecZpF5Go44454Wrl2U2YN4LjKc+FFXidUhhiHIQwPC4mf0+ZT1GflvO+yENOQfwoFDYSr4CeCjEPSdp4j4By/X+MpjsgMvpxg9w3d2yptYrPBre7XCr6rJwgVJ346HGKCgwhRCSpVlfYWw/S4YCCzUtTkUBIKusng5K929ART/b4kh63C1CQ0goTRW5CgqA9n/ld6WV/MHNavbGIXtrBFxOamGxoTyD5mL7VYoeqyV8ugcf0BSmEvJ3pn2+c20sO3VM38Th63Iu6MlKUGcDpg0l5cI2e+acU3e9k8AtXARtafW3RqghUCBvEz5y9qf0W5RFrg1BiH3pxSa6Kz9pe7flxAjDAbu4jMaebMjEGgegrFSDzpecgPj2C3smVbqxKffa0ZirpcDwhfaefc52Brrb51xTfRJE6XclvCqC/Ct0R0r//xYAVdlXp3swPDqG+eKg+XrYOSIHz9hQW1itRVVlPGZIzqyVp6FCW07UYNx5CLpyKA8wLxkal/oOjumK69sQXbWlDamqbwvYqIxYHScvse83rMLDLF7YckDaCdNeBZlN77gaN5Ltbg/gx01EuclcsLKT3//e12yCtWCDiKUz0lgTAyoPLbS6DrcrVCPP8E76E0KwC50yGPVTmYMZLgNyqwZTY75wZJHdx5G/OB953PWUSAk0zzTliAm75tsQEJKLAQwd/M5ew7uN2lKCkCIyoIrEo0MzcbhSDQnWYGqdu0hx3V67FwMZ/Zd1Tx2VABGCW8SAItaYNVvQjG/0S+Ie6DIp0ONPM+ANJl9aoZFkGzpQjEztAyRkh2AxMcFbl7lULjC38iCfT1l4KDeWu5dtsnP/pQ1C
 xt2z72qO
 R6s8mu185bBcu8ynvOfznczYRin2xH5UfkoqpnM1ROvGWONLibRAiAeBXZgxrtakSYiGS3r0nEFPczXqLPl0nVy+rGAt8lFQr3ORNl4KGggt4q2G5YJDy/wATGHqX79j9xMbo0SZSWtuWHwrqHdy/4ulvokZZBuTP+5FMlPUMJBoJnvAR5mQjRVOMEoZ6irXDQQ1Bk5VvP1+iKKkzCKqj5kJIeLIMk1qTp2ergsspZkIy7Bh3bWjql+QgxaXhZrKNbTToA801Izfn31xY9rPw/mNBjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/16 18:18, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
> 
> This patch introduces a recovery mechanism that attempts to
> migrate mappings from the failing KSM page to a newly
> allocated KSM page or another healthy duplicate already
> present in the same chain, before falling back to the
> process-killing procedure.
> 
> The recovery process works as follows:
> 1. Identify if the failing KSM page belongs to a stable node chain.
> 2. Locate a healthy duplicate KSM page within the same chain.
> 3. For each process mapping the failing page:
>    a. Attempt to allocate a new KSM page copy from healthy duplicate
>       KSM page. If successful, migrate the mapping to this new KSM page.
>    b. If allocation fails, migrate the mapping to the existing healthy
>       duplicate KSM page.
> 4. If all migrations succeed, remove the failing KSM page from the chain.
> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>    error) does the kernel fall back to killing the affected processes.
> 
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Thanks for your patch. Some comments below.

> ---
>  mm/ksm.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 246 insertions(+)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..9099bad1ab35 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3084,6 +3084,246 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
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
> +					struct ksm_stable_node,
> +					node);
> +
> +			if (!is_stable_node_chain(stable_node))
> +				continue;
> +
> +			hlist_for_each_entry(dup, &stable_node->hlist,
> +					hlist_dup) {
> +				if (dup == dup_node)
> +					return stable_node;
> +			}
> +		}
> +	}

Would above multiple loops take a long time in some corner cases?

> +
> +	return NULL;
> +}
> +
> +static struct folio *find_healthy_folio(struct ksm_stable_node *chain_head,
> +		struct ksm_stable_node *failing_node,
> +		struct ksm_stable_node **healthy_dupdup)
> +{
> +	struct ksm_stable_node *dup;
> +	struct hlist_node *hlist_safe;
> +	struct folio *healthy_folio;
> +
> +	if (!is_stable_node_chain(chain_head) || !is_stable_node_dup(failing_node))
> +		return NULL;
> +
> +	hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hlist_dup) {
> +		if (dup == failing_node)
> +			continue;
> +
> +		healthy_folio = ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK);
> +		if (healthy_folio) {
> +			*healthy_dupdup = dup;
> +			return healthy_folio;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct page *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
> +		struct folio *healthy_folio,
> +		struct ksm_stable_node **new_stable_node)
> +{
> +	int nid;
> +	unsigned long kpfn;
> +	struct page *new_page = NULL;
> +
> +	if (!is_stable_node_chain(chain_head))
> +		return NULL;
> +
> +	new_page = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_ZERO);

Why __GFP_ZERO is needed?

> +	if (!new_page)
> +		return NULL;
> +
> +	copy_highpage(new_page, folio_page(healthy_folio, 0));
> +
> +	*new_stable_node = alloc_stable_node();
> +	if (!*new_stable_node) {
> +		__free_page(new_page);
> +		return NULL;
> +	}
> +
> +	INIT_HLIST_HEAD(&(*new_stable_node)->hlist);
> +	kpfn = page_to_pfn(new_page);
> +	(*new_stable_node)->kpfn = kpfn;
> +	nid = get_kpfn_nid(kpfn);
> +	DO_NUMA((*new_stable_node)->nid = nid);
> +	(*new_stable_node)->rmap_hlist_len = 0;
> +
> +	(*new_stable_node)->head = STABLE_NODE_DUP_HEAD;
> +	hlist_add_head(&(*new_stable_node)->hlist_dup, &chain_head->hlist);
> +	ksm_stable_node_dups++;
> +	folio_set_stable_node(page_folio(new_page), *new_stable_node);
> +	folio_add_lru(page_folio(new_page));
> +
> +	return new_page;
> +}
> +

...

> +
> +static void migrate_to_target_dup(struct ksm_stable_node *failing_node,
> +		struct folio *failing_folio,
> +		struct folio *target_folio,
> +		struct ksm_stable_node *target_dup)
> +{
> +	struct ksm_rmap_item *rmap_item;
> +	struct hlist_node *hlist_safe;
> +	int err;
> +
> +	hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->hlist, hlist) {
> +		struct mm_struct *mm = rmap_item->mm;
> +		unsigned long addr = rmap_item->address & PAGE_MASK;
> +		struct vm_area_struct *vma;
> +
> +		if (!mmap_read_trylock(mm))
> +			continue;
> +
> +		if (ksm_test_exit(mm)) {
> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		vma = vma_lookup(mm, addr);
> +		if (!vma) {
> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		if (!folio_trylock(target_folio)) {

Should we try to get the folio refcnt first?

> +			mmap_read_unlock(mm);
> +			continue;
> +		}
> +
> +		err = replace_failing_page(vma, &failing_folio->page,
> +				folio_page(target_folio, 0), addr);
> +		if (!err) {
> +			hlist_del(&rmap_item->hlist);
> +			rmap_item->head = target_dup;
> +			hlist_add_head(&rmap_item->hlist, &target_dup->hlist);
> +			target_dup->rmap_hlist_len++;
> +			failing_node->rmap_hlist_len--;
> +		}
> +
> +		folio_unlock(target_folio);
> +		mmap_read_unlock(mm);
> +	}
> +
> +}
> +
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_node)
> +{
> +	struct folio *failing_folio = NULL;
> +	struct ksm_stable_node *healthy_dupdup = NULL;
> +	struct folio *healthy_folio = NULL;
> +	struct ksm_stable_node *chain_head = NULL;
> +	struct page *new_page = NULL;
> +	struct ksm_stable_node *new_stable_node = NULL;
> +
> +	if (!is_stable_node_dup(failing_node))
> +		return false;
> +
> +	guard(mutex)(&ksm_thread_mutex);
> +	failing_folio = ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOCK);
> +	if (!failing_folio)
> +		return false;
> +
> +	chain_head = find_chain_head(failing_node);
> +	if (!chain_head)
> +		return NULL;

Should we folio_put(failing_folio) before return?

Thanks.
.

