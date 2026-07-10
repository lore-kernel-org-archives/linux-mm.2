Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203B0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013046B00A1; Fri, 10 Jul 2026 10:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2CD06B00A3; Fri, 10 Jul 2026 10:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E696F6B00A9; Fri, 10 Jul 2026 10:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B13B46B00A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:55:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45D401C3BFE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:55:35 +0000 (UTC)
X-FDA: 84973165830.12.364ED73
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf31.hostedemail.com (Postfix) with ESMTP id A64FE20003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:55:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGyXMR06;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fy3HvPYERYOqHKmADP27Z6ZkjciyXUnr8qNN8o2XjUs=;
	b=KgY0fyPFVrFXwLWMYpxdAhr9nk/fA3KtQ/7bxV0nLNtacdGRPmgEzUi6onygb3uLHoS4Qf
	9vyr0plMGnd1TEHTa3cgubu3Bld528onhfgSt6eaQDw2awRwOKqMmWE6dhZcN5ZDSxzvHN
	jBKPPOcTFNBgTV/XbVWZFKa2NS+WP7w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGyXMR06;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695333;
	b=xkzd+zC5n/pH/umGrO4jsAEoLF4CsxqzctruWYVUdBNpd9QQrSClvwqPgILHD0VYZnLyez
	/WYZWezCDVDrdtLLO3thuNznOTX2BSYxnBO96EAT05VxQV17S0jr3TDAioroNm+xyQbH5p
	fHJfOLJQd5gYaIjSEmMUFLJqr/uPzjs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783695328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fy3HvPYERYOqHKmADP27Z6ZkjciyXUnr8qNN8o2XjUs=;
	b=fGyXMR064tcSGEiL7ZJCkwjrUPXiTV3PC8VGFVxUFYXjtZCczyoRfE9Jk7biyIW2o8UmeS
	jeWD/ZaGCrz5k3IPSntW3fAFXoFnOwVVYkVHMwVYHRC/BU319ZjGcM1subEkpzhXcdQlem
	AI04lSdQzYt0VufhKtL9NiRsgZdBios=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 05/10] memory-failure: Remove raw_hwp_list_head()
Date: Fri, 10 Jul 2026 07:55:21 -0700
Message-ID: <20260710145522.1718437-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-6-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A64FE20003
X-Stat-Signature: ea4xyny98uninr7zhzgbwswiwg1tnppq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783695331-129010
X-HE-Meta: U2FsdGVkX18BkeA1633tWeT8uVBbk1jf1rX4IXOUL4QKJ76iTnZ/lFRFQiKOqTx7BlRDsGao8S9wZghNpnOXL9VLLKUIZuDM9zp19erdNF0hfX0cG+hVi4WSeLtsU7BaNCIsSG0wZi5rHpVFfPA38FyqzoM9CuKJm+p5dD5McrFQasOwhvh8RB/RTgDI8gOzOIw3d7kwIVjLmXmU7PjnHGTSoT1Yd3iy+jB4pth2mMu6HCU2OcflBSypDaUJWUD6R4R32qj3B8A5Jgp3WpE2aYaenD09j7DfkLxd1MP8d23FiLcypgwAFIfapx8SoOSug3nfv83iFGFYQCNTmox7YKW04Z8zbu6zyBgBmfTCqnmP4ImdtrCQlbmCtVgnHr0H3+z5H+BKt8DnANP+tW2DN5odBRo2ThXSAxoOokydg9uiDhFFpSbYjiWsKaDWvZrjuqP/RI24kbiNpPdYrcK7JGLPOgZp8+e106Obmrefi9Weym07YBAugC1r+UgIzS4LWgf5jacCZU0+PhN9kEgd515a4PN6fb1wu89ek/B1APFU5bQ2ytY+n8d0jAB1rZnG1Enf529VkZ0JIOa8wf99nex3B+Y+Ce2ZlU4tr5lKPQKFWk53s0Gn/ddgCPWKJ76Rk56MVvUaQzx0jWDiToVebj/jyIWdEGFSGJyijRh55ac6I4jI18PUsy/+pUtzDP2DS4I0H1CjFlWutjiI7xP/7f7EMS4DxzJrlgJUw/nLncXE+QcblUvnE+qaqlDMAoVzv7cupjehwHj34w1e3BYMFnxrz5YXQT6bqWC3ThgxZ9Xl86NeeHP0kxMeJFcQ1EGIix/Sp2pQCUz1C+M0C7tOD79zJEeANc1q25jATKtNrW07lDz8y7+YKXF67hMk4OcV1oPcBORvUPK6uzRCOIUeXn/AQgC0aPg44ubLQb8sbksX87bqxzZIt/FbtEi1BHvpPhDDniA3tTEcNEnEBby
 qVMoo/W8
 xuPNr/blgPVZ+0UuWdyjtxdB1NS5HFnjq3prYB7h2VE692NRw0h/AGvkzvMiH6lTxjOOOX/7+/ylwWqjwPPF1n2lwKD/+j1XII+jlgFvXReTO7ptAkZS3rxFtEUp55KzbusADnpWrRcr2js1B65dbMolqErVEKb6MI5Akni03EOVsIEZo7lkLJvRD97s6Pm6kDCiyDJf6bCrgNwifVd5VNmf4YaRCtESaK6SJJmXyGxLwMuwwBMQ/b5Pg3Z0EKQcH78lDd98D6a/eLJOu3OraW2JqHp85reqYccbxe7NvhnXwHH9fB9vBYMaxx0agxdUsmKRRdPdqz+D9M8RpBZ9wVBKlMlaKLa8NLm9cbfgia4+Xeo9tdq3lXqGKqc2wUuuyHUyV2du/vwQIavPYQMbwnFHoi7aFMRaZNEXAS/l+7KuWQ4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:33 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> There's no need to hide the llist_head; we can just declare it
> directly in struct folio and do away with raw_hwp_list_head().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm_types.h |  4 ++--
>  mm/memory-failure.c      | 19 +++++--------------
>  2 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..d46f81f94848 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -387,7 +387,7 @@ typedef unsigned short mm_id_t;
>   * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
>   * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
>   * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
> - * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
> + * @_hugetlb_hwpoison: Raw error pages, see struct raw_hwp_page.

s/_hugetlb_hwpoison/hugetlb_hwpoison/ in the doc above, apart
from that, LGTM.

Also good to add No functional change intended in the commit message.

Acked-by: Usama Arif <usama.arif@linux.dev>

>   * @_deferred_list: Folios to be split under memory pressure.
>   * @_unused_slab_obj_exts: Placeholder to match obj_exts in struct slab.
>   *
> @@ -499,7 +499,7 @@ struct folio {
>  			void *_hugetlb_subpool;
>  			void *_hugetlb_cgroup;
>  			void *_hugetlb_cgroup_rsvd;
> -			void *_hugetlb_hwpoison;
> +			struct llist_head hugetlb_hwpoison;
>  	/* private: the union with struct page is transitional */
>  		};
>  		struct page __page_3;
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51508a55c405..53063e2a1f97 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1810,21 +1810,15 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
>  
>  /*
>   * Struct raw_hwp_page represents information about "raw error page",
> - * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
> + * constructing singly linked list from folio->hugetlb_hwpoison field.
>   */
>  struct raw_hwp_page {
>  	struct llist_node node;
>  	struct page *page;
>  };
>  
> -static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
> -{
> -	return (struct llist_head *)&folio->_hugetlb_hwpoison;
> -}
> -
>  bool is_raw_hwpoison_page_in_hugepage(struct page *page)
>  {
> -	struct llist_head *raw_hwp_head;
>  	struct raw_hwp_page *p;
>  	struct folio *folio = page_folio(page);
>  	bool ret = false;
> @@ -1844,8 +1838,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
>  
>  	mutex_lock(&mf_mutex);
>  
> -	raw_hwp_head = raw_hwp_list_head(folio);
> -	llist_for_each_entry(p, raw_hwp_head->first, node) {
> +	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
>  		if (page == p->page) {
>  			ret = true;
>  			break;
> @@ -1863,7 +1856,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  	struct raw_hwp_page *p, *next;
>  	unsigned long count = 0;
>  
> -	head = llist_del_all(raw_hwp_list_head(folio));
> +	head = llist_del_all(&folio->hugetlb_hwpoison);
>  	llist_for_each_entry_safe(p, next, head, node) {
>  		if (move_flag)
>  			SetPageHWPoison(p->page);
> @@ -1887,7 +1880,6 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>   */
>  static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>  {
> -	struct llist_head *head;
>  	struct raw_hwp_page *raw_hwp;
>  	struct raw_hwp_page *p;
>  	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
> @@ -1899,8 +1891,7 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>  	 */
>  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>  		return MF_HUGETLB_FOLIO_PRE_POISONED;
> -	head = raw_hwp_list_head(folio);
> -	llist_for_each_entry(p, head->first, node) {
> +	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
>  		if (p->page == page)
>  			return MF_HUGETLB_PAGE_PRE_POISONED;
>  	}
> @@ -1908,7 +1899,7 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>  	raw_hwp = kmalloc_obj(struct raw_hwp_page, GFP_ATOMIC);
>  	if (raw_hwp) {
>  		raw_hwp->page = page;
> -		llist_add(&raw_hwp->node, head);
> +		llist_add(&raw_hwp->node, &folio->hugetlb_hwpoison);
>  	} else {
>  		/*
>  		 * Failed to save raw error info.  We no longer trace all
> -- 
> 2.47.3
> 
> 

