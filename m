Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E53606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UBKJ7sW2
Received: by kanga.kvack.org (Postfix)
	id 5A2A16B00EF; Tue, 10 Nov 2026 06:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553606B05B0; Tue, 10 Nov 2026 06:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441CC6B05B1; Tue, 10 Nov 2026 06:22:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1919C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:22:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98FF6A046D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:22:26 +0000 (UTC)
X-FDA: 85418971092.18.0B985BA
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7972F14000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:22:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UBKJ7sW2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr0Loj1l7QJmya8XzBVn5nKxenToThw/bSNGb0oeKBE=;
	b=nFWNXAopEPC36AUDPOQLdLy8MI5AAGPJABjD1PKWlUfM1sFm8xtstBHyuvblky6V6MIM/8
	fpZNWDa36IW7efEvqj30UNS8buZwQu/1OmKG712F0AgBFJFoOdWb1dV09JJCctrYGICcA+
	zeTpAKHWfB96rslZ6tt+18WsATmv/BY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UBKJ7sW2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309745;
	b=k5ad1sgzuIJ/nrDXLaIGt4pAnTowc/5o3HtpwN/ajr6UEeruW2yuD8Tst5fzfV2sRujlk2
	w2q/t6Mbp0elwnu0Nhpi4Y+KDy1eW0Ipxr9Kw97VXctPoxj1VF7FP4F7STyv+5Lt+yVX5s
	GoqQGWVkUl2xdNlzlkp1jfGRoFw9/6I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F+1UAVXb+agKFYnFE0eZcwVLRxkbjSKhuGkJWx+TCO8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309741; v=1; x=1794914541;
 b=UBKJ7sW2M9yPqhVJlOC9FoA5d2I9puBmA6wSVHs3LB2Dj/PxaBSWSiTY8FOpmZfmK9/GoGk7
 Sy9qZVIsesLraUNgzP4QaQIMvQxa93kxm/ItOe0TGQFNVDnvhw0j6M6/JCUVBKIvKrJxAAlU4kv
 QAu5KDcVguWt0Xj8hHJNg7+4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d3b4e8450789c000;
	Tue, 10 Nov 2026 11:22:21 +0000
X-Mizu-Trace-ID: d3b4e8450789c000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 19:22:06 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, corbet@lwn.net,
	david@kernel.org, link@vivo.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, odys.yuan@gmail.com, rppt@kernel.org,
	surenb@google.com, tujinjiang@huawei.com, vbabka@kernel.org,
	xiao.wang@vivo.com
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages
 under only_merge_zero_pages
Message-ID: <avL+Xj5/Md58Gc98@dgvxl46587.localhost.localdomain>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
 <20261110074451.220524-2-xu.xin@linux.dev>
 <avLrHrnpP3tuXXPZ@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avLrHrnpP3tuXXPZ@gremlin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7972F14000B
X-Stat-Signature: itikm991318keh5ayotx7e47amg7onjd
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309744-182752
X-HE-Meta: U2FsdGVkX1+nuHROyrzXPG10tBXT/juVFGYUfrO9XSy1tqQpHbOTAinAEvxRO0MkZCKtjAzTlLcBHrGGBunAHpnGTxsBNnmNF4/ND+x/rLDtb410cU6AqhlOPk1VHQzO7VrxTO4MvpXmbJLeMka/73yTDMp9uUQMmFrFYPLj+ehyRLK7+BnqjHXNJZ6C5gk1CSU57fFd8csysKLeWkZ7qVpVVrrllE/YHVtPjt6mqs4nCMSeF2cnSF2SnU8jbmHuyG4USYr6iSk/vQejfG/soi+UwopTh1hcdOQp8MinESCPgmHN7bhLCp1PYOZPA+DsHKggDvDiLgrQlu/FptpC/s/MTZkU7OmrKVv5EeaXhu+dhjpqrCXzrlb+zWtuRhMrtfWoP6Nsil3ZMEIiUwiAP/MkXniQqciG2a+JR6a5YYcik5NlEYLGVOER4OCfvue28brxJ5nWVJVBRbk+YkGDgDBqFprxZ+W/0CT5lGATIHhz2/G0YriHu7t8W8EUC5/zo50XgbzPtB8IIFdWpGYJWCwtx3/myMcIz8YIL8OrMOS8xnndo5R4dZ0rw0IesHv5VBUsy8GoG/HXNZmOvEpffDuI5DcTBIYubZ9gHwu++eQCuG0xTFj2UnVfuHOuzFtFOxyZQUL9Wek/ynK0lCwHlkuaW//jM1mhFhqUpDQBEWvtbt3AyrZy4EbCNwxXBvLlMvGkkSr7Wq3nEPuB4cGnTe4X08mJBNQPkL50znugWqXLF6g5U3ur/VwuDIolH3GiPXoqjwbk35Swc7kSmP9Lr3hssF4X874IBBdD7E0ks16E/xhPgdp3EA5OT+NRoHG0a2ILJj63xGsJwxmzncSfm2brKi6WDpK9g0m9FPvO2AUuR0EZpOSI1RbrSjjT1HbNsObsnYEFGiCknZsvyxWk+6dzglqRROC5jzRN1hGCTAJBSpGgKJJLzeBZ1klQuy5Nn9+FGQExYQcnMUbBSZP
 z7rpC6HR
 zE5G7IKLj1vgHEb2P4j7EQzFh8RgICZnL+bAEBM3jjsZ+hqDhO/HukbPSoWnE4gmYGr5DfzKs/Tlo2hzGJfRd5RCnsD+cumuX4izRgInJkms06wMocpF+AIA7d70VMA5rrecAVS+Cxmt/13jyi+RN1hHYib7luXZlo6zZ/zq5k2mz7oPrP3ECVZMC7yVWUWdBy2XnrBVm0K/bwO2uI8Y3Yhx93bt7KuVn3PC6D0hgjIRhwR1nAHOBWvFHUWna6L5Cyv47V2PB5AF2a9tK2UeAzV/3ZwE4gEIKf6H77aghzf9V5gXsegX3aboVETlh6GJZptLm1UF+NqdlFL+wSBioQt025DtKbIfGr+1zvUbJ+ObLfzHxuQxAQsmR5JxXxRQ1ZuNT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:05:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 03:44:49PM +0800, Xu Xin (vivo) wrote:
> > When only_merge_zero_pages is enabled, ksmd only ever merges empty
> > (zeroed) anonymous pages with the kernel zero page. A page that carries
> > data can never be merged, yet the current code still allocates an
> > rmap_item for it in scan_get_next_rmap_item() before cmp_and_merge_page()
> > decides to skip it.
> >
> > On workloads with a large amount of non-mergeable anonymous memory this
> > is a real cost: every scanned non-zero page pays for an rmap_item
> > allocation, and the rmap_items accumulate in the per-mm pending list.
> > For example, a MySQL instance with hundreds of gigabytes of anonymous
> > memory (mostly buffer pool pages that cannot be merged) ends up with
> > ksmd creating rmap_item metadata for each candidate page; the metadata
> > overhead can wipe out any gain from the zero-page merging and even turn
> > the net benefit negative.
> >
> > Add should_skip_non_zero_page(), called in scan_get_next_rmap_item() before
> > get_next_rmap_item(), which, when only_merge_zero_pages is enabled,
> > checks whether the candidate page is all zeros. A non-zero page is
> > skipped entirely: no rmap_item is allocated for it, and any stale
> > pending rmap_items below it are freed (as get_next_rmap_item() would).
> > The page is reported back to ksm_do_scan() as ERR_PTR(-EAGAIN), which
> > counts it as scanned and continues, so the pages_to_scan budget is
> > preserved.
> >
> > The all-zero check (pages_identical() against the kernel zero page) reads
> > the whole page. For a non-zero page this is a net win: the extra page read
> > is cheaper than the rmap_item allocation and the stable/unstable tree
> > operations it would otherwise trigger.
> >
> > A page that is zero now but is written before cmp_and_merge_page() runs
> > is still handled correctly, because the checksum-based decision in
> > cmp_and_merge_page() (added by the previous patch) is the authoritative
> > one.
> >
> 
> Please re-write this in your own words.
> 
> It's rambling on and never gets to the point of _what this patch does and
> why_.
> 
> I'm not interested in reading a novel to understand the code :)
> 
> It seems very LLM generated, LLMs are _terrible_ at writing commit messages
> and commits, please re-write all of that.

Indeed, the description was generated by LLM, but I thought that was clear enough
to present what this patch do and why. Aparrently, you don't like that style, I'll
rewrite that by handd.

The goal is only to avoid rmap_item allocation for pages that can never merge
under only_merge_zero_pages. The implementation is simple.

I'll send a v3 with those changes.

> 
> > Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> > Co-developed-by: Jinjiang Tu <tujinjiang@huawei.com>
> > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> 
> Why are this and the other patches in-reply-to 1/4? That's not how you send
> a series in mm.

That was my mistake
> 
> > ---
> >  mm/ksm.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 82 insertions(+)
> >
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 49f3728a3d03..e641c37ee096 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -2535,6 +2535,69 @@ static bool should_skip_rmap_item(struct folio *folio,
> >  	return true;
> >  }
> >
> > +/*
> > + * Determines whether a candidate page should be skipped entirely when
> > + * only_merge_zero_pages is enabled, before an rmap_item is allocated for
> > + * it.
> > + *
> > + * A page that is not all zeros carries data and can never be merged with
> > + * the kernel zero page, so there is no point in allocating an rmap_item
> > + * for it. Skipping it here avoids the rmap_item metadata cost that full
> > + * KSM would otherwise pay for every non-mergeable page.
> > + *
> > + * @rmap_list: head of the per-mm pending rmap_item list
> > + * @addr:      address of the candidate page
> > + * @folio:     folio containing the candidate page
> > + * @page:      the candidate page
> > + *
> > + * Returns true if the page should be skipped (and any stale pending
> > + * rmap_items below @addr are freed), false if it should be processed.
> > + */
> 
> This is a really weird mix of kdoc style + not kdoc style while not being a
> kdoc, for a static function?
> 

Will simplify it.

> > +static bool should_skip_non_zero_page(struct ksm_rmap_item **rmap_list,
> > +			     unsigned long addr, struct folio *folio,
> > +			     struct page *page)
> > +{
> > +	struct ksm_rmap_item *rmap_item;
> > +
> > +	if (!ksm_only_merge_zero_pages)
> > +		return false;
> > +
> > +	/*
> > +	 * Pages already merged by KSM are handled by cmp_and_merge_page();
> > +	 * do not skip them here.
> > +	 */
> > +	if (folio_test_ksm(folio))
> > +		return false;
> > +
> > +	/*
> > +	 * An all-zero page is exactly what we want to merge with the kernel
> > +	 * zero page; process it.
> > +	 */
> > +	if (pages_identical(page, ZERO_PAGE(0)))
> > +		return false;
> > +
> > +	/*
> > +	 * The page carries data: free any pending rmap_items that are below
> > +	 * it (they are stale, as get_next_rmap_item() would), and skip it so
> > +	 * no rmap_item is allocated for it.
> > +	 *
> > +	 * Compare the masked address, unlike get_next_rmap_item() which
> > +	 * compares the raw rmap_item->address (which may carry the
> > +	 * UNSTABLE/STABLE_FLAG bits). That is intentional: a pending
> > +	 * rmap_item at the same address as a non-zero page is stale and must
> > +	 * be freed here, not returned for processing.
> > +	 */
> 
> We don't need a prose version of the code, and it reads like AI slop, we
> don't want AI slop comments, thanks.

Sorry, this is to clarify the difference between get_next_rmap_item() and here.
Maybe too verbose to you ? I can simplify those words.

> 
> > +	while (*rmap_list) {
> > +		rmap_item = *rmap_list;
> 
> Why is rmap_item function-scoped when it could be block-scoped here...

You are right. Will fix it.

> 
> > +		if ((rmap_item->address & PAGE_MASK) > addr)
> > +			break;
> > +		*rmap_list = rmap_item->rmap_list;
> > +		remove_rmap_item_from_tree(rmap_item);
> > +		free_rmap_item(rmap_item);
> > +	}
> 
> This code is very ugly.
> 
> Newline...
> 
> > +	return true;
> 
> 
> > +}
> > +
> >  struct ksm_next_page_arg {
> >  	struct folio *folio;
> >  	struct page *page;
> > @@ -2737,6 +2800,16 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> >  			if (tmp_page) {
> >  				flush_anon_page(vma, tmp_page, ksm_scan.address);
> >  				flush_dcache_page(tmp_page);
> > +
> > +				if (should_skip_non_zero_page(ksm_scan.rmap_list,
> > +						     ksm_scan.address, folio,
> > +						     tmp_page)) {
> > +					folio_put(folio);
> > +					ksm_scan.address += PAGE_SIZE;
> > +					mmap_read_unlock(mm);
> > +					return ERR_PTR(-EAGAIN);
> > +				}
> > +
> 
> I don't love just shoving more logic into an already massive function. No
> to this.
> 
> At some point technical debt has to be paid, clean up this code first please.

Emmm... I agree scan_get_next_rmap_item() is already too large and needs cleanup.

But it is the main KSM scan path, and a refactor there is high-risk. The cleanup
deserves a separate series with careful review and testing.

> 
> >  				rmap_item = get_next_rmap_item(mm_slot,
> >  					ksm_scan.rmap_list, ksm_scan.address);
> >  				if (rmap_item) {
> > @@ -2839,6 +2912,15 @@ static void ksm_do_scan(unsigned int scan_npages)
> >  		rmap_item = scan_get_next_rmap_item(&page);
> >  		if (!rmap_item)
> >  			return;
> > +		if (rmap_item == ERR_PTR(-EAGAIN)) {
> > +			/*
> > +			 * A non-zero page was skipped under
> > +			 * only_merge_zero_pages: it was examined but not
> > +			 * merged, so count it as scanned and keep going.
> > +			 */
> 
> Similarly schloppy.
> 
> > +			ksm_pages_scanned++;
> > +			continue;
> > +		}
> >  		cmp_and_merge_page(page, rmap_item);
> >  		put_page(page);
> >  		ksm_pages_scanned++;
> > --
> > 2.34.1
> >
> 
> All in all adding far too much complexity in a cycle which is
> fix-focused...
> 
> --
> Cheers, Lorenzo

