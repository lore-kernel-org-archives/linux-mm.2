Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB1A606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 07:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jDsz5NPE
Received: by kanga.kvack.org (Postfix)
	id C64C26B05B3; Mon,  9 Nov 2026 02:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B686B05B4; Mon,  9 Nov 2026 02:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A766B05B5; Mon,  9 Nov 2026 02:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87AA56B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:58:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 089E7405F4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:58:38 +0000 (UTC)
X-FDA: 85414828716.30.CE39CB2
Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9B0C940003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:58:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jDsz5NPE;
	spf=pass (imf07.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794211116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PloZYG0YlqPd0fPMNHXUmlTaSF0KwWiGUtevmIvK6NQ=;
	b=4XDt542vwh/6GQavWdvlD66tYS/lrcr1ZOOMSyhnjfVXQQMP4OyrqV1S4nnMwRwpcbDRR1
	BDTe8vSdAK4Nhaq4RGNq9MO3ZAPYNfqPBLpZ7V0Dav1o4EMn7EPNlO1PcssV2BGPs17Tfy
	0UNwCscMLunRvMGK5H5r1U9uNC+g+9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794211116;
	b=31XBJl8M+gJmwbGHOCRFC9Ue8CVE8o6cJRBYL+2A5iG2MTA6Q9fyAcs6dOk9N+Lhw9Yngk
	6mxW4hihVZq+XYsP/Om4A3bnjZ9p28hlN9+xm82qQLhUa2MQF2n2iAglOTx+BkjttSWT87
	I1C7Jc11DRwZ51fHx1Rc0pPh7XtGcuo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jDsz5NPE;
	spf=pass (imf07.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ocbWO5IN6PY3KV/uwG1iNS01RNg/k/IKh6ElI1rBuPw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794211114; v=1; x=1794815914;
 b=jDsz5NPEXmW0n4XySYpeZvBk67Q/Ex4ebBHe56Pon+ZpDp9eYJByCcATsaN1BPTxiLq30H+2
 8NeHTQvtsLQfDmooa5wNeKHR73DG4MMjzb4O9FiZJXRJDA2in8OyP7YFo2KBCgyWt1SXloIKagC
 8IM7RHVNOt9MW1uDJjy3y32U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f10b76554c95204d;
	Mon, 09 Nov 2026 07:58:33 +0000
X-Mizu-Trace-ID: f10b76554c95204d
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 15:58:24 +0800
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
Message-ID: <avF9IBJWGp31Q0iq@dgvxl46587.localhost.localdomain>
References: <20261106034841.233085-1-xu.xin@linux.dev>
 <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com>
X-Stat-Signature: 5fdp8m4b6rmi5mqo4y5bq13jo668fh3a
X-Rspamd-Queue-Id: 9B0C940003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794211115-454355
X-HE-Meta: U2FsdGVkX196q37DgYK0/ESZ6YsHdZaq8Nfwpqd9FJ08ue+klHJZPIn7kyWwM1inWeaDqh90lEeiCcBfkumJbGh1Pu/hIaIfEBqfL3RoglaryHc75VCKmMpzBJxL35p+MTHpMncjFOUZO8pAkXMc5x0N5ogQdvqatvPR2U38WGKDpBsHwHIBRChOJOklE9UyDaxaq7jGq3G4+YmVnE/hdI+O/THgxAGksqLswYfgDcSsxn5c0rkLxxpLPeBhNYFFc9OFZCJM6x9n8qDX3X+UEqo8skHIMqWPEWBlSxI2sIRT/itjF/IxmBQfeDkiSLzYdqR+1c6JFtiU7vICFpKlk1t53VEXmn8UE7NFDaWzouOVSmwCAReBTSfk/OgA+n5ZRJaLevy0quPg7NC6un3LP6dU+XqWJUkbmRBOMi0xE7IFkCwMeqyTT4xD1PVfLCtWYKZVrgoCdBIEndAVgtpmzwoPnOf46/8wqPQL8/8mUlXi4qFKH9Y/vpaBI+lIQag6GTEX96GwZUwpMoGaqX1Vs5LQHRUeLG1EJiZRTg5XhQe9DaXr5j5afXWuh/BeVCa4dm3wUB/JF0EB/grGCcmd6T73yca6PpUTCnB8sC21oRvN6eREgNrbbB9OrauHNArmRonFUxeRKjRvKmpnZQkq2p+QMQhzK26BKQ4HQ5qFJ2zleP7jDLIONv9LZuVnaEYkf/+o2bkX99tn15U51J8VMJX5xm2mG07VAMDkwkxZ9zhA8H/AY9o8Xg9yhnyZHN0skYfvV8OmnuyolDKbANYpB4S+FeAVY4yi0Hk5C7iTyVvJkCtNRrZZF0UAaDyw3W4uhKuyOnq49a1Wcp+DyuyNwIC6xzdKkTQnOHX8fmQWEXxBCB9yjzPHltNBk/0EIOA+Ew5v0ODU996ACrh626Cq5FJpcyg56sGolPIarz9Vfy4SvxWganHWQEiTsFk7nxvl3sqPxbgInXxHD1tCyFg
 gs4slHHd
 P8icSmGMUDZ09WlWUKLWLuxoLL+zW22ePTehXSaPp+GorFAnAObfFReL6esS7keMQK6dWGGwXrQSKzvv8+aDBzmQZE3CrDQrqdmytB54qCMGgNm7q6d2/hIbVOLluTcryracWinSy5ln+IQ2PImtMIaWaL1b1i7fy7aidRJ2Ra8n3zZfp6RI29KT5tpLapkgDJzPpkdnlDgVkm/9CXaAmyMeUM6y0Ai0PS6vJPRHyflJLPAFZxlwW+Cc59dhsCTjmoD0EV1CEMPtkoe4pF+X+EYNh5tlTOxOWTlzrE/DVQrAeKVU7etMxI8bPkQ==
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
> > Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
> > which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> > pages with the kernel zero page and skip the stable and unstable trees
> > entirely for pages that carry data.
> > 
> > The attribute requires use_zero_pages to be 1, and the two are kept
> > consistent by symmetric constraints: it cannot be enabled while
> > use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> > off while it is active (-EBUSY). The new attribute can be changed at
> > any time and is only effective for pages merged after the change.
> > 
> > Benefits in three aspects
> > =========================
> > - Memory saving:
> >    On memory-constrained systems such as Android and embedded devices,
> >    zero-filled anonymous pages are the largest source of duplicate
> >    anonymous memory. They are produced by userspace allocators: the
> >    zeroing of freshly allocated Java objects and buffers in the ART heap
> >    (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
> >    preallocated media buffers. Merging them with the kernel zero page
> >    frees a significant amount of physical memory, which matters as DRAM
> >    costs keep rising. With this enabled, we measured 100MB–300MB saving
> >    tested with several popular applications on aarch64 (Android).
> > 
> > - CPU overhead reduction:
> >    Merging only zero pages also reduces the overhead of ksmd. A page that
> >    is not merged with the zero page carries data and can never be merged
> >    with the zero page, so there is no point in searching the stable tree
> >    or inserting it into the unstable tree for it. Skipping those tree
> >    operations for data-bearing pages reduces both the CPU time and the
> >    rhashtable memory footprint of ksmd, which makes zero page merging
> >    practical on low-resource devices where full KSM scanning would be too
> >    expensive.
> > 
> > - Security:
> >    Finally, this shrinks the KSM side-channel attack surface: only zero
> >    pages are ever merged, so the sharing status of data-bearing pages is
> >    no longer observable through KSM timing side channels.
> > 
> > Note
> > =====
> > - Suitable for Android, embedded and low-memory devices, where zero-page
> >    deduplication is wanted but full KSM scanning is too costly, and reduced
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
>
 
Thanks for sharing your work — the motivation is clear and our goals are compatible

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

I'd like to take you up on the collaboration, with a few adjustments to your diff:

I'd keep only the precise check in should_skip_page() before get_next_rmap_item(),
and remove page_maybe_zero(), ksm_skip_nonzero_pages(), and nr_to_skip.

Two concerns drive this:

(1) 'nr_to_skip' conflicts semantically with 'pages_to_scan'. nr_to_skip (initialized to 1024,
reset per walk) is an independent cap on how much work one walk may do, decoupled from the
user-facing pages_to_scan knob. pages_to_scan controls how many pages one scan cycle processes,
but the pages skipped inside a walk are not accounted for in that budget, so the actual amount
of work ksmd does is no longer fully described by pages_to_scan. A user tuning pages_to_scan to
bound ksmd's CPU/power on a battery-powered device would no longer get a bound they can reason
about.

(2) The same non-zero page can go through page_maybe_zero() more than once. It's only a heuristic
(first and last word), so a page that is zero at both ends but carries data in the middle passes
the fast filter, is returned as a candidate, and is then rejected by the exact pages_identical()
check in should_skip_page(). Because KSM re-walks the same address range on every subsequent scan
cycle, that same page is fed through page_maybe_zero() again on each cycle and rejected again
— the cost is paid repeatedly while the page is never actually filtered out.

Given the above, I'd like to drop ksm _skip_nonzero_pages() and the coarse filter in the page
walking path from this round of submission, to keep the code simpler and clearer overall.
The precise check in should_skip_page() is kept, so non-zero pages still never get an rmap_item
— the metadata saving you're after is preserved. Also, I'll keep the attribute name consistent
with yours.

On the tags: I'd like to credit you as Co-developed-by and add your Signed-off-by, per
submitting-patches.rst, with my own Signed-off-by above them.

If you have concerns, let me know before I post.

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

