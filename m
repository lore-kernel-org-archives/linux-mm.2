Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DF5606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QfsxkYUt
Received: by kanga.kvack.org (Postfix)
	id 0C4026B05BA; Sun,  8 Nov 2026 21:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0755A6B05BB; Sun,  8 Nov 2026 21:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5E46B05BC; Sun,  8 Nov 2026 21:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC1A56B05BA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:02:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D91F1C3D96
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:02:50 +0000 (UTC)
X-FDA: 85413932100.29.51CD48C
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A1E0140005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:02:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QfsxkYUt;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794189768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlBkNshnRvxJvLUnOog48HaeDLXWwV/RjD/R7Dtxa2c=;
	b=PGVScPUhZymeY2AZBVbg4SjkpykN7IBUpWYMg5BxV+qTIM046iGX6hbjsbtGtRiCF7KXq6
	El0v6yD5ihWVqgXzDc/jNFwszYeFuxOYr2GWfBbuGxAjtQcB58hfnMYXNk26hS6Tpiy/5x
	pmvN0UVAyC57/1lsuto7/PBSxO+oC+M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QfsxkYUt;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794189768;
	b=KfOOWhYpU6HuhHhjVkkIqPbPRIk9NHTNUXpYWFp0PqeKrzEnteyPLt+1GTo9GC7jDaJbDz
	Pd6ggELlwfP2yn9LruM+LaFbGGtha0DwurvNd4b5gGBICu73FJc81xPtYQ85xZWsYIbCaI
	c2VC5vcPaKH2G1UZO2tiAr8YXRXQKD8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F+9QGNn78TE5UhAcrJSZwwSQiT+HhmNF2N5MpN7+7xQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794189766; v=1; x=1794794566;
 b=QfsxkYUt8+Hrwi1g7IxsfMOz6RfW7IBYwMaMj66AQeL1EolLGytsakgcbGfvxn89SvYkCs96
 Xksj7OWRhjcqLanQFxic96OMeXeYOq5mfvVZAhhUjuI8mKOwkLVoWaI5SWp84bf2bapegxuv6ht
 bk4iUiPxyz+wh6/q2KNf/Rcs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e9f324b00c252f44;
	Mon, 09 Nov 2026 02:02:46 +0000
X-Mizu-Trace-ID: e9f324b00c252f44
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 10:02:26 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only
 empty anonymous pages
Message-ID: <avEpskVC/NRPFt4d@dgvxl46587.localhost.localdomain>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
X-Stat-Signature: b5bsgtnbm1my74wz4sfke9j7dd5xtdzx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1A1E0140005
X-HE-Tag: 1794189767-594369
X-HE-Meta: U2FsdGVkX19X+PwLrnuOe5THVcpgEdbVgj+NRMbK6+DxnUG+r9Igtzo3jaALh1m6RfpQQMbvKYXAbA+2OCiZhnAnjkq1+6YYqdjnDTp5Txpf0zM1e3sWwoDRjYTNoOg6J7pQalKr3SQyiI8x8IDxxRZPPqKw6lVw4rTAHQjXV69nnsIW3H+SB2AxN7WmQYSNpGPXOoJC4VoWMtihW4ADOi1rqyiWkik9YkDFHzhFJK//USTPZ9Sq2k4I2Snezo/MJdoCDTeGZIJisP6h3C2aIQadshurJ474gjPGth0S+1D1Y8u7iYguj3/ll2dO5R41UiUmvyoX8ezkiLpgCOgE4HTeQOo3GZkff1bcthPCqMeXxavjJ0U5vICkEwLFEly6sCPCaBnG762sVaO7UlbzyYi/36aVwlAWWyd2YGfcLaYp++Af4uLN5ba+seQzbqeUM++4jkQ1GpjWahq6oaa9tNSIdNGLc1DEt/2yMffe1shTaW0SYhlMebGrI87R+2ljUHVtAFD7bmR8pJnwdJ/bd+QF3GL8EpFa2nyHATb2sv6vd68VXx+PFQBWZyiWWTTLErYneznKgcoH3Uv2ePAQsdigXNUPDimdQSYGGVco1n9i3jKexf+c5xX4ZYWzPuXUnQDzhR1mBwfT+6mLZyh5eAD+Si+DpvkL0qxSd52eB4fxDZp6SC2/8dy/2M54KUc6kysffeFXc7oBZ1DVmLvF2Jr6T4vwFvThYpngYstmP7mxXXztyF5n7BfgWFSTs/KoomnoiS57mS1IhkKSGc/CndkncX8vu8QzoFoPTSneFfNv5WxxF0+5GqT9ehx2I965pzzj228oC/RBgO7F3ret6TLkb4ZVBpqqLqo34rSpcrfAbev8RY3EGdavktDFUZ5g+30ELhsY2UhIZ2N2d2Kw733ZT0sEuPH83Y//iOYdYNFONpX9reSLif2+a7m+95j8ghJDOsMY6vAVYpCj01B
 QT55G17j
 blzr96zGVS0rJWsk2dF5v1lCXWSb5RK/LbOiSWTQk5UgPhB88I/lAdea0sxQkJGRH2mPP+4h/QGGpn3+jkXrCXii8V4nQAljT+dwS818Kgb35lxFiN9zpw4K1DQVlcD1MHYiS89Gsig6tNzx0nJ+lA2sQY2YK+mPnTHCtpovJ+hTyMT47uFjBhrEVIqlQdP7+rfXBXdMQg88x8anANZrV4PJmsHPtP+jyxShvNOYlX4/3c42+GUc5LF3xckThBYjg2fOSWxiem7yO5gnIjDEgCnvzdNp8Ox924bfaiUaZhGruZ6JLR+47XzNjyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 04:13:40PM +0800, Jinjiang Tu wrote:
> 
> 在 2026/11/6 11:48, xu.xin@linux.dev 写道:
> > From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> > 
> >    KSM side-channel exposure is desired. Many handset vendors may prefer
> >    this knob, which can be used as a default fallback policy.
> > 
> > - Not suitable for server and virtualization workloads containing many
> >    non-zero duplicate pages, where vanilla KSM provides better memory
> >    savings.
> 
> It’s a coincidence that I’m also working on similar optimizations.
> In our scenario, we have a MySQL instance with over 700 GB of anonymous
> memory. Most of this memory belongs to the buffer pool, which caches
> data from storage; these pages cannot be merged. Of the remaining memory,
> around 15 GB is consumed by hashtables, which contain many zero-filled
> pages that are eligible for merging to reduce memory footprint.
> 
> When we enabled KSM for the entire MySQL instance, ksmd created rmap_item
> metadata for each candidate page.The massive metadata overhead wiped out
> any gains from page merging, and even resulted in a negative benefit.
> 
> For this reason, I’m trying to make ksmd merge only zero pages. The goal
> is to have ksmd skip scanning non-zero pages entirely, thereby avoiding
> the rmap_item metadata cost introduced by scanning non-mergeable pages.

Skip generating ksm_rmap_item for non-zero pages ? That dose make sense to me.

> 
> 1) Before get_next_rmap_item(), check whether the page is all zeros.
> If not, skip it directly to avoid allocating an rmap_item.
> 
> 2) When walking page tables to find candidate pages in ksm_next_page_pmd_entry(),
> check whether the first and last contents are zero as a quick filter.
> This is intended to speed up page-table traversal.
> 
> Would you mind to collaborate? For example, by including my optimization
> as the second patch in your patch series?

Happy to do it.

> 
> Here is the diff. Basic functionality has been tested.
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b189..8a02976b0aba 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -296,6 +296,9 @@ static unsigned int zero_checksum __read_mostly;
>  /* Whether to merge empty (zeroed) pages with actual zero pages */
>  static bool ksm_use_zero_pages __read_mostly;
> +/* Whether to merge empty (zeroed) pages only */
> +static bool ksm_only_merge_zero_pages __read_mostly;
> +
>  /* Skip pages that couldn't be de-duplicated previously */
>  /* Default to true at least temporarily, for testing */
>  static bool ksm_smart_scan = true;
> @@ -2524,8 +2527,42 @@ struct ksm_next_page_arg {
>  	struct folio *folio;
>  	struct page *page;
>  	unsigned long addr;
> +	unsigned int nr_to_skip;
>  };
> +static inline bool page_maybe_zero(struct page *page)
> +{
> +	unsigned long *p;
> +	bool ret = true;
> +	unsigned int last_pos = PAGE_SIZE / sizeof(*p) - 1;
> +
> +	p = kmap_local_page(page);
> +	if (p[0] || p[last_pos])
> +		ret = false;
> +	kunmap_local(p);
> +	return ret;
> +}
> +
> +static struct page *ksm_skip_nonzero_pages(struct page *page,
> +					   unsigned long *addr,
> +					   unsigned long nr,
> +					   unsigned int *nr_to_skip)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < nr; i++) {
> +		if (!*nr_to_skip)
> +			break;
> +		(*nr_to_skip)--;
> +		if (page_maybe_zero(page + i))
> +			break;
> +	}
> +	if (i == nr)
> +		return NULL;
> +	*addr += i << PAGE_SHIFT;
> +	return page + i;
> +}
> +
>  static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  		struct mm_walk *walk)
>  {
> @@ -2563,6 +2600,13 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
>  				goto not_found_unlock;
>  			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
> +			if (ksm_only_merge_zero_pages) {
> +				page = ksm_skip_nonzero_pages(page, &addr,
> +					(end - addr) >> PAGE_SHIFT,
> +					&private->nr_to_skip);
> +				if (!page)
> +					goto not_found_unlock;
> +			}
>  			goto found_unlock;
>  		}
>  		spin_unlock(ptl);
> @@ -2585,6 +2629,14 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
>  		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
>  			continue;
> +
> +		if (ksm_only_merge_zero_pages && !folio_test_ksm(folio)) {
> +			page = ksm_skip_nonzero_pages(page, &addr, 1,
> +						      &private->nr_to_skip);
> +			if (!page)
> +				continue;
> +		}
> +
>  		goto found_unlock;
>  	}
> @@ -2609,6 +2661,33 @@ static struct mm_walk_ops ksm_next_page_ops = {
>  	.walk_lock = PGWALK_RDLOCK,
>  };
> +static bool should_skip_page(struct ksm_rmap_item **rmap_list,
> +				  unsigned long addr, struct folio *folio,
> +				  struct page *page)
> +{
> +	struct ksm_rmap_item *rmap_item;
> +
> +	if (!ksm_only_merge_zero_pages)
> +		return false;
> +
> +	if (folio_test_ksm(folio))
> +		return false;
> +
> +	if (pages_identical(page, ZERO_PAGE(0)))
> +		return false;
> +
> +	while (*rmap_list) {
> +		rmap_item = *rmap_list;
> +		if ((rmap_item->address & PAGE_MASK) > addr)
> +			break;
> +		*rmap_list = rmap_item->rmap_list;
> +		remove_rmap_item_from_tree(rmap_item);
> +		free_rmap_item(rmap_item);
> +	}
> +	return true;
> +}
> +
> +
>  static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  {
>  	struct mm_struct *mm;
> @@ -2705,6 +2784,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  			int found;
> +			ksm_next_page_arg.nr_to_skip = 1024;
>  			found = walk_page_range_vma(vma, ksm_scan.address,
>  						    vma->vm_end,
>  						    &ksm_next_page_ops,
> @@ -2722,6 +2802,14 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  			if (tmp_page) {
>  				flush_anon_page(vma, tmp_page, ksm_scan.address);
>  				flush_dcache_page(tmp_page);
> +
> +				if (should_skip_page(ksm_scan.rmap_list, ksm_scan.address, folio, tmp_page)) {
> +					folio_put(folio);
> +					ksm_scan.address += PAGE_SIZE;
> +					mmap_read_unlock(mm);
> +					return ERR_PTR(-EAGAIN);
> +				}
> +
>  				rmap_item = get_next_rmap_item(mm_slot,
>  					ksm_scan.rmap_list, ksm_scan.address);
>  				if (rmap_item) {
> @@ -2824,6 +2912,10 @@ static void ksm_do_scan(unsigned int scan_npages)
>  		rmap_item = scan_get_next_rmap_item(&page);
>  		if (!rmap_item)
>  			return;
> +		if (rmap_item == ERR_PTR(-EAGAIN)) {
> +			ksm_pages_scanned++;
> +			continue;
> +		}
>  		cmp_and_merge_page(page, rmap_item);
>  		put_page(page);
>  		ksm_pages_scanned++;
> @@ -3674,6 +3766,28 @@ static ssize_t use_zero_pages_store(struct kobject *kobj,
>  }
>  KSM_ATTR(use_zero_pages);
> 

