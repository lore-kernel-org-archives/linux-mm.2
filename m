Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4778606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 08:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JTPleKM3
Received: by kanga.kvack.org (Postfix)
	id A961A6B05B0; Sat,  7 Nov 2026 03:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A489C6B05B1; Sat,  7 Nov 2026 03:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935F46B05B2; Sat,  7 Nov 2026 03:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 609AE6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:14:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7F25A7C67
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:13:59 +0000 (UTC)
X-FDA: 85407609798.18.53053FD
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0967A160002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:13:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JTPleKM3;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794039238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrm76w9rpad5J89LN1+sAR7614MRl47f4Z3wrRNQXTA=;
	b=8MtHruslz0CskA1GZyfr2i1koa4fWpWC1mCkCjjli3+G+bGk6KFEZwe9TKfXk26fXxno1C
	a+K9k53hZ5zftTd+iPjYLm4xoVwK9S+LBAiijQFCnIG4B18bDgRG1HUwY0Mz1NZx7pY7aL
	bAg3Oj5eiTFp6XLT2mYo0oOnn+QH438=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794039238;
	b=UEQ01TdfZfjonrYb2ej7Fg3kYpxYvpoE/w9PCjovEvdq1G+LQrbmk6kU7+9ubYLltq2GeD
	NlgNYOs2k6VItFmUKH9N+w4haYzJ007fUYfbjurLKtilquqXTFuYJMJYpCVWnqBoOfdnTm
	eqh2Ik2+FdcoNjr+pR21FLEHPkmB53o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JTPleKM3;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zrm76w9rpad5J89LN1+sAR7614MRl47f4Z3wrRNQXTA=;
	b=JTPleKM3usprA9fXb+iReU66pKnKs0LzQGOfC3eRWgXaVBndOB9OdRy1o8KnYZwumCkge1ZCd
	gsoqsQpc18yExnQ0s5iodR/Fr1rs1tgh9m0+hVG2rO4RHqXcR4/On3F1us6cVv4fj5QQexlsMm0
	THy2PFVAGzajMUoVyQoPYmE=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jM82B55Pxz1K97J;
	Sat,  7 Nov 2026 16:13:38 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7627F4057C;
	Sat,  7 Nov 2026 16:13:45 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 7 Nov 2026 16:13:41 +0800
Message-ID: <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
Date: Sat, 7 Nov 2026 16:13:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: <xu.xin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>
CC: Chengming Zhou <chengming.zhou@linux.dev>, Lorenzo Stoakes
	<lstoakes@gmail.com>, "Liam R . Howlett" <liam.howlett@oracle.com>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20261106034841.233085-1-xu.xin@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam06
X-Stat-Signature: 8mmub7j3wi8x8wdcy8bpfwh8xgykg8zr
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0967A160002
X-Rspam-User: 
X-HE-Tag: 1794039235-920890
X-HE-Meta: U2FsdGVkX1+UdhQ8llKxLpWOCOKfempfTCQvfM+mvZU9kk/vYgATK7mrB7WWfhSHb3AvJ+Tow+JOur+T13Ar635/N+xniIzATOM3vUrJwr7sKf6TPl4mdct+RNvp3k5ao6yCLWTPygbmcDbwLZgrSEAN5xn0diUbf8akfgLGDHlSJ1EiiL42XOukO9Ckiqn0uo1UWdLcdg88SrYf/lRTmVlTk/hAKUhVJy8+rjX1P1LslcIXp1CL3YpRHoR+/MdRLev3bX30tChgHaPcxMaGrdobM6duxZzhKc1bgI41l5l6uHMmErkqQuTYWhYaxYihwHbNU6a+Fsx8F+oJHmVquPJjusWwkErve+gVf/ib2J8DhvQXScG9WnIKTtTdPB89b7WLYFd8plXfkso2HV8qdCNMbQ19xE09eSXaM4U9R4kr1I4oYI03MrtDWrkXyNnnCvpeIU3zq/UQE93neDS/Anr89A6Su8V+cY5S2NvEVuCBIkv95U8h3HbpRGyeLWen1qf3oDogQUt2nIGAxeb6KfgrqbE3v8IGkNMzHyAgOfD7+uEWiP/5IjFraDMIhcPJnV/T5HfTvODE/r7/adKJd3CJPqi4USFSyraRr3lOlFBzCas31Y3GsZEH0KrdxUcVktX7fVw3efHbddwGHBiz2D3vdtmsQg0T8w1mJ1J1/RalsawKsi7iz/FluwCcjQFk4vWE0Z8FrgtcMEwXb53xUoxddeE6O95G1CHqndwri0/n/tloeVck2EAgeaBvgbrSWQ//yHPlgin6gizeuNcFehFO15/u9tkEwy7hkPTXSkLQMHTjN7nrWCzalG5bMqLI6U4SGKdnkQ6m+k+CKrSt/CMFV6yTFwS/pbZI9NtrOrqikKfYGBuYvqcePB70uMM72CtIbuyi9DZQ4JpEwJtx5B41BqfuJdVTEas8+0E2hsx1cmUDr+dBZg+ceNJ9j7AwJvlfoIr0SGSo/eExb+6
 ElZSQHqL
 9e6fCxqYaiBkKtktLQcKRw/1+Bb1MSaNEwzDGWJd6/3GB7hN64FHv+sJ2RgeDOXTf6n8b2NOlwfAUrX7uQ0wIwraFwHFh9ZPgxZLsN3RL2aSLM316sOzkYN5PZ/c+Oo3pOMpCxWgCPLrpfC5BW2mcm1CkYgsIx+/Mb1OnH9QF2aFyizoRLNc9+ahkC+5Vg+q9KuoHQSMC/weIx4dKiAbJXaY490qhWJ0GGjFcT5nnkoYxeLwB1xBIqE/rO+AanwJFFutGDOTRjG5/w2LkW+k14L4KwdHMdJq/L7bMwlHvV8sznEyBnsIaDw+6ZfsRq7utXnSxkkMKMzURI1movdmQ8v/l4EUU8kqK/5dMhs7kU+CehVm9gO2gnf8HVVnlN+MgFFwUHupA9xak8xM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/6 11:48, xu.xin@linux.dev 写道:
> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
>
> Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
> which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> pages with the kernel zero page and skip the stable and unstable trees
> entirely for pages that carry data.
>
> The attribute requires use_zero_pages to be 1, and the two are kept
> consistent by symmetric constraints: it cannot be enabled while
> use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> off while it is active (-EBUSY). The new attribute can be changed at
> any time and is only effective for pages merged after the change.
>
> Benefits in three aspects
> =========================
> - Memory saving:
>    On memory-constrained systems such as Android and embedded devices,
>    zero-filled anonymous pages are the largest source of duplicate
>    anonymous memory. They are produced by userspace allocators: the
>    zeroing of freshly allocated Java objects and buffers in the ART heap
>    (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
>    preallocated media buffers. Merging them with the kernel zero page
>    frees a significant amount of physical memory, which matters as DRAM
>    costs keep rising. With this enabled, we measured 100MB–300MB saving
>    tested with several popular applications on aarch64 (Android).
>
> - CPU overhead reduction:
>    Merging only zero pages also reduces the overhead of ksmd. A page that
>    is not merged with the zero page carries data and can never be merged
>    with the zero page, so there is no point in searching the stable tree
>    or inserting it into the unstable tree for it. Skipping those tree
>    operations for data-bearing pages reduces both the CPU time and the
>    rhashtable memory footprint of ksmd, which makes zero page merging
>    practical on low-resource devices where full KSM scanning would be too
>    expensive.
>
> - Security:
>    Finally, this shrinks the KSM side-channel attack surface: only zero
>    pages are ever merged, so the sharing status of data-bearing pages is
>    no longer observable through KSM timing side channels.
>
> Note
> =====
> - Suitable for Android, embedded and low-memory devices, where zero-page
>    deduplication is wanted but full KSM scanning is too costly, and reduced
>    KSM side-channel exposure is desired. Many handset vendors may prefer
>    this knob, which can be used as a default fallback policy.
>
> - Not suitable for server and virtualization workloads containing many
>    non-zero duplicate pages, where vanilla KSM provides better memory
>    savings.

It’s a coincidence that I’m also working on similar optimizations.
In our scenario, we have a MySQL instance with over 700 GB of anonymous
memory. Most of this memory belongs to the buffer pool, which caches
data from storage; these pages cannot be merged. Of the remaining memory,
around 15 GB is consumed by hashtables, which contain many zero-filled
pages that are eligible for merging to reduce memory footprint.

When we enabled KSM for the entire MySQL instance, ksmd created rmap_item
metadata for each candidate page.The massive metadata overhead wiped out
any gains from page merging, and even resulted in a negative benefit.

For this reason, I’m trying to make ksmd merge only zero pages. The goal
is to have ksmd skip scanning non-zero pages entirely, thereby avoiding
the rmap_item metadata cost introduced by scanning non-mergeable pages.

1) Before get_next_rmap_item(), check whether the page is all zeros.
If not, skip it directly to avoid allocating an rmap_item.

2) When walking page tables to find candidate pages in ksm_next_page_pmd_entry(),
check whether the first and last contents are zero as a quick filter.
This is intended to speed up page-table traversal.

Would you mind to collaborate? For example, by including my optimization
as the second patch in your patch series?

Here is the diff. Basic functionality has been tested.

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..8a02976b0aba 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -296,6 +296,9 @@ static unsigned int zero_checksum __read_mostly;
  /* Whether to merge empty (zeroed) pages with actual zero pages */
  static bool ksm_use_zero_pages __read_mostly;
  
+/* Whether to merge empty (zeroed) pages only */
+static bool ksm_only_merge_zero_pages __read_mostly;
+
  /* Skip pages that couldn't be de-duplicated previously */
  /* Default to true at least temporarily, for testing */
  static bool ksm_smart_scan = true;
@@ -2524,8 +2527,42 @@ struct ksm_next_page_arg {
  	struct folio *folio;
  	struct page *page;
  	unsigned long addr;
+	unsigned int nr_to_skip;
  };
  
+static inline bool page_maybe_zero(struct page *page)
+{
+	unsigned long *p;
+	bool ret = true;
+	unsigned int last_pos = PAGE_SIZE / sizeof(*p) - 1;
+
+	p = kmap_local_page(page);
+	if (p[0] || p[last_pos])
+		ret = false;
+	kunmap_local(p);
+	return ret;
+}
+
+static struct page *ksm_skip_nonzero_pages(struct page *page,
+					   unsigned long *addr,
+					   unsigned long nr,
+					   unsigned int *nr_to_skip)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr; i++) {
+		if (!*nr_to_skip)
+			break;
+		(*nr_to_skip)--;
+		if (page_maybe_zero(page + i))
+			break;
+	}
+	if (i == nr)
+		return NULL;
+	*addr += i << PAGE_SHIFT;
+	return page + i;
+}
+
  static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
  		struct mm_walk *walk)
  {
@@ -2563,6 +2600,13 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
  				goto not_found_unlock;
  
  			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+			if (ksm_only_merge_zero_pages) {
+				page = ksm_skip_nonzero_pages(page, &addr,
+					(end - addr) >> PAGE_SHIFT,
+					&private->nr_to_skip);
+				if (!page)
+					goto not_found_unlock;
+			}
  			goto found_unlock;
  		}
  		spin_unlock(ptl);
@@ -2585,6 +2629,14 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
  
  		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
  			continue;
+
+		if (ksm_only_merge_zero_pages && !folio_test_ksm(folio)) {
+			page = ksm_skip_nonzero_pages(page, &addr, 1,
+						      &private->nr_to_skip);
+			if (!page)
+				continue;
+		}
+
  		goto found_unlock;
  	}
  
@@ -2609,6 +2661,33 @@ static struct mm_walk_ops ksm_next_page_ops = {
  	.walk_lock = PGWALK_RDLOCK,
  };
  
+static bool should_skip_page(struct ksm_rmap_item **rmap_list,
+				  unsigned long addr, struct folio *folio,
+				  struct page *page)
+{
+	struct ksm_rmap_item *rmap_item;
+
+	if (!ksm_only_merge_zero_pages)
+		return false;
+
+	if (folio_test_ksm(folio))
+		return false;
+
+	if (pages_identical(page, ZERO_PAGE(0)))
+		return false;
+
+	while (*rmap_list) {
+		rmap_item = *rmap_list;
+		if ((rmap_item->address & PAGE_MASK) > addr)
+			break;
+		*rmap_list = rmap_item->rmap_list;
+		remove_rmap_item_from_tree(rmap_item);
+		free_rmap_item(rmap_item);
+	}
+	return true;
+}
+
+
  static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  {
  	struct mm_struct *mm;
@@ -2705,6 +2784,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  
  			int found;
  
+			ksm_next_page_arg.nr_to_skip = 1024;
  			found = walk_page_range_vma(vma, ksm_scan.address,
  						    vma->vm_end,
  						    &ksm_next_page_ops,
@@ -2722,6 +2802,14 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  			if (tmp_page) {
  				flush_anon_page(vma, tmp_page, ksm_scan.address);
  				flush_dcache_page(tmp_page);
+
+				if (should_skip_page(ksm_scan.rmap_list, ksm_scan.address, folio, tmp_page)) {
+					folio_put(folio);
+					ksm_scan.address += PAGE_SIZE;
+					mmap_read_unlock(mm);
+					return ERR_PTR(-EAGAIN);
+				}
+
  				rmap_item = get_next_rmap_item(mm_slot,
  					ksm_scan.rmap_list, ksm_scan.address);
  				if (rmap_item) {
@@ -2824,6 +2912,10 @@ static void ksm_do_scan(unsigned int scan_npages)
  		rmap_item = scan_get_next_rmap_item(&page);
  		if (!rmap_item)
  			return;
+		if (rmap_item == ERR_PTR(-EAGAIN)) {
+			ksm_pages_scanned++;
+			continue;
+		}
  		cmp_and_merge_page(page, rmap_item);
  		put_page(page);
  		ksm_pages_scanned++;
@@ -3674,6 +3766,28 @@ static ssize_t use_zero_pages_store(struct kobject *kobj,
  }
  KSM_ATTR(use_zero_pages);


