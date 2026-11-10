Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F4E60A6F6B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FkxRLQKe
Received: by kanga.kvack.org (Postfix)
	id DEEE56B05B9; Tue, 10 Nov 2026 05:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC74A6B05BA; Tue, 10 Nov 2026 05:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D045A6B05BB; Tue, 10 Nov 2026 05:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE136B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:05:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80A461A0552
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:30 +0000 (UTC)
X-FDA: 85418777220.26.D27636E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E14A420003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkxRLQKe;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794305129;
	b=xXzytpXPGlMmMg3Xwbo07W6FuIosOZdSqop6srxgjWiQeYlqtGLTzCsnW31JdTCOZWvbpL
	iDAeeATS4JxaxiI2EcosB7mETt4DDnlTt5c4KOFEiEPCc0V3+hSicS+7ZxbgIPWMLj7ATG
	mZDcqx2+OMLorJsRDBlUwsiVKiA3a0w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FkxRLQKe;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794305129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7JHToNvmvovrxsCT+NsYxHL5scA7i94JGOHZjSN1bs=;
	b=h4gLSu473OBMJZY70MpBueDfJAIN4Pa5vvHXarM2g/ke9n3b9pM0G4e9fs4BDysQAR/CRc
	5n55l8HKDae+IrFGtKg7eFMzRb5o2F3iAeoPqSPcKRU+uzcHZKOruAvX3VG69jluHW6Zj/
	WUwxBJW/RQ4TsdYd+sD6wcLz59tlDIg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D6196385B;
	Tue, 10 Nov 2026 10:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD241F008A4;
	Tue, 10 Nov 2026 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794305128;
	bh=n7JHToNvmvovrxsCT+NsYxHL5scA7i94JGOHZjSN1bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FkxRLQKe2exp2p0YBuRQCorQW8fK+JO16bZr31sSfbbg66nXkxqHsgponQcdBK0jX
	 DavDBSPy277+yZXKBuTxwIBFw44WRdpUQ63FuWtJJLKGi7WUV5STiwvF1mgjz+D+s9
	 2R3Zw5dfR3kp3fgXtxCypQsKsIjuRwRiI2Q5KT525LpWnU9ICcu+uzDOiLYFpvxkAU
	 vtn+DgLDVhMLMXx3dM1BGJ6IVMrSmMzlUlOag0e4HVtvDX8dhJHzkpfejT26Pf9LSJ
	 odI8MM+xQgHW8NPsi+f9yRInvQzSygij6hL4uFUzd9HXeq1XBPygQHUrwSKyNM524Q
	 LhEEWntTWrKqw==
Date: Tue, 10 Nov 2026 10:05:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, corbet@lwn.net, 
	david@kernel.org, link@vivo.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	odys.yuan@gmail.com, rppt@kernel.org, surenb@google.com, tujinjiang@huawei.com, 
	vbabka@kernel.org, xiao.wang@vivo.com
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages
 under only_merge_zero_pages
Message-ID: <avLrHrnpP3tuXXPZ@gremlin>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
 <20261110074451.220524-2-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110074451.220524-2-xu.xin@linux.dev>
X-Stat-Signature: xqczb8fir9xb68z7mwwa35wmocedqqup
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E14A420003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794305128-114190
X-HE-Meta: U2FsdGVkX1/Fz8Mu1eURyyIASMpuV8Q73t7Kr+d7NlmcnpUBD8CNIZMzy1VwIXN4WlMJF5GQNEYynhk6SIT0FjBTRaYUhAHWgZ0HheoC1P+ZyZRJ9bMHtvvQKUPIEIdSx5D4q/X6bWrnUhDgp694qMNE8tXkKihV0PJE0SFX+VLZKv0woE/WEC4nn7BG9DT+7w3Ri6LPJ5QJQi9Kq6SjoncItsNLqswXPwMGkILGU6omqWZBWZiqaj+NNogx9LfAFDtDDP/FiRf3d6RxicZXK+BGkpNdBPIbyRXyTJ1zu0jdLzFJ524E1qrZX3IZnNq4S0zBX9xE2fdXUHjo0MasMEuHxoZE55qnBrxh/ROkIUM/o0oBx4Imefb0WnODHEESxIeBZ7D7ouGVJqucHgBQ1DsuBrtUNlbRzNyhmm39us5fUuvzyjr7M0vfusUt11sdGqYe86p3TKP7Hzie7J+MNl1mUvkyP+ZQJr6iX017cNRsnM2Br0LREJFWiZ1dGi/NMqcPqcJNL0U8kYPOjIR0tt0BXvqXQVgu/YhLOGvIdc0kor/Jj74qena2BwC4VsPKk4COY0EoTqtznWl0eekVm839V7EzS1FiPZFe7SNJ5FghQky44j8mVHTPgH8aKN0wEp473PO1ZvnmUVaouiDoPxUt8sYV+Zov6Vsow+iSlv4jbGJIAG+JcW1jhV6S+bbx94u1B2WvZK13Abqaawxtll1TtmR1dGhGdYMvVugqAQhG8Z2RTAjGIx9KLpHFapRNzzdemqD4ptHGrzxop6Hr9QpJUn3ElgO4n4FbB9viCGKt3cDat0z2owZaNyMR8LYnrUkgf46IpFtgNAqwEwnp55Gc9BoDUBNF0k+eMVEvZvo5wSOdAR7szn0Ia4V28gwDkDm06dCthIhhLQzyznOnMHGKIvqzvRdWx+ovLcs8gLIU4Tf2qJUvS3OjgZMg97G25jYunwY/yMEQ4EZcAB9
 RrqlBvLG
 0HSRPEu4OsnKbqeTgz1JdujB7bLbKEnoOxpshFOuEq83dCCTxhP6JPnSnUmjjjuW667YFPCnx+jqaXVhic2BRBEK79FYeYGeZCHQbmn4tkHeOhmwygv7DR9kNL/gt8OUFZ3GNruZY8gK8rfJEfVeQnYB+VQAisFzjljSZXBKtdyDT3LboltH1Zl+PmFs7xOCi/kfyF/UlJDRf8HQM6juv7Y7P05xnjJHknSiJvhMq/BnhhR+b/jCMf5aWVZbkHtigvOmcw5jqzR2rcsGe/lGP5wdHpUZ8XNlixHtdJwas9KHwdViEAPdmGYSFUbwS7VquCHZqvTWyGLEhakHkFolIOKBOKuwJrf2SHNdDmS4O5LGBiiHFSD1hZ2wHQDmICeQy9U7bsUKaPyVPyKeoEjL9F8vf1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:44:49PM +0800, Xu Xin (vivo) wrote:
> When only_merge_zero_pages is enabled, ksmd only ever merges empty
> (zeroed) anonymous pages with the kernel zero page. A page that carries
> data can never be merged, yet the current code still allocates an
> rmap_item for it in scan_get_next_rmap_item() before cmp_and_merge_page()
> decides to skip it.
>
> On workloads with a large amount of non-mergeable anonymous memory this
> is a real cost: every scanned non-zero page pays for an rmap_item
> allocation, and the rmap_items accumulate in the per-mm pending list.
> For example, a MySQL instance with hundreds of gigabytes of anonymous
> memory (mostly buffer pool pages that cannot be merged) ends up with
> ksmd creating rmap_item metadata for each candidate page; the metadata
> overhead can wipe out any gain from the zero-page merging and even turn
> the net benefit negative.
>
> Add should_skip_non_zero_page(), called in scan_get_next_rmap_item() before
> get_next_rmap_item(), which, when only_merge_zero_pages is enabled,
> checks whether the candidate page is all zeros. A non-zero page is
> skipped entirely: no rmap_item is allocated for it, and any stale
> pending rmap_items below it are freed (as get_next_rmap_item() would).
> The page is reported back to ksm_do_scan() as ERR_PTR(-EAGAIN), which
> counts it as scanned and continues, so the pages_to_scan budget is
> preserved.
>
> The all-zero check (pages_identical() against the kernel zero page) reads
> the whole page. For a non-zero page this is a net win: the extra page read
> is cheaper than the rmap_item allocation and the stable/unstable tree
> operations it would otherwise trigger.
>
> A page that is zero now but is written before cmp_and_merge_page() runs
> is still handled correctly, because the checksum-based decision in
> cmp_and_merge_page() (added by the previous patch) is the authoritative
> one.
>

Please re-write this in your own words.

It's rambling on and never gets to the point of _what this patch does and
why_.

I'm not interested in reading a novel to understand the code :)

It seems very LLM generated, LLMs are _terrible_ at writing commit messages
and commits, please re-write all of that.

> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> Co-developed-by: Jinjiang Tu <tujinjiang@huawei.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Why are this and the other patches in-reply-to 1/4? That's not how you send
a series in mm.

> ---
>  mm/ksm.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 49f3728a3d03..e641c37ee096 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2535,6 +2535,69 @@ static bool should_skip_rmap_item(struct folio *folio,
>  	return true;
>  }
>
> +/*
> + * Determines whether a candidate page should be skipped entirely when
> + * only_merge_zero_pages is enabled, before an rmap_item is allocated for
> + * it.
> + *
> + * A page that is not all zeros carries data and can never be merged with
> + * the kernel zero page, so there is no point in allocating an rmap_item
> + * for it. Skipping it here avoids the rmap_item metadata cost that full
> + * KSM would otherwise pay for every non-mergeable page.
> + *
> + * @rmap_list: head of the per-mm pending rmap_item list
> + * @addr:      address of the candidate page
> + * @folio:     folio containing the candidate page
> + * @page:      the candidate page
> + *
> + * Returns true if the page should be skipped (and any stale pending
> + * rmap_items below @addr are freed), false if it should be processed.
> + */

This is a really weird mix of kdoc style + not kdoc style while not being a
kdoc, for a static function?

> +static bool should_skip_non_zero_page(struct ksm_rmap_item **rmap_list,
> +			     unsigned long addr, struct folio *folio,
> +			     struct page *page)
> +{
> +	struct ksm_rmap_item *rmap_item;
> +
> +	if (!ksm_only_merge_zero_pages)
> +		return false;
> +
> +	/*
> +	 * Pages already merged by KSM are handled by cmp_and_merge_page();
> +	 * do not skip them here.
> +	 */
> +	if (folio_test_ksm(folio))
> +		return false;
> +
> +	/*
> +	 * An all-zero page is exactly what we want to merge with the kernel
> +	 * zero page; process it.
> +	 */
> +	if (pages_identical(page, ZERO_PAGE(0)))
> +		return false;
> +
> +	/*
> +	 * The page carries data: free any pending rmap_items that are below
> +	 * it (they are stale, as get_next_rmap_item() would), and skip it so
> +	 * no rmap_item is allocated for it.
> +	 *
> +	 * Compare the masked address, unlike get_next_rmap_item() which
> +	 * compares the raw rmap_item->address (which may carry the
> +	 * UNSTABLE/STABLE_FLAG bits). That is intentional: a pending
> +	 * rmap_item at the same address as a non-zero page is stale and must
> +	 * be freed here, not returned for processing.
> +	 */

We don't need a prose version of the code, and it reads like AI slop, we
don't want AI slop comments, thanks.

> +	while (*rmap_list) {
> +		rmap_item = *rmap_list;

Why is rmap_item function-scoped when it could be block-scoped here...

> +		if ((rmap_item->address & PAGE_MASK) > addr)
> +			break;
> +		*rmap_list = rmap_item->rmap_list;
> +		remove_rmap_item_from_tree(rmap_item);
> +		free_rmap_item(rmap_item);
> +	}

This code is very ugly.

Newline...

> +	return true;


> +}
> +
>  struct ksm_next_page_arg {
>  	struct folio *folio;
>  	struct page *page;
> @@ -2737,6 +2800,16 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  			if (tmp_page) {
>  				flush_anon_page(vma, tmp_page, ksm_scan.address);
>  				flush_dcache_page(tmp_page);
> +
> +				if (should_skip_non_zero_page(ksm_scan.rmap_list,
> +						     ksm_scan.address, folio,
> +						     tmp_page)) {
> +					folio_put(folio);
> +					ksm_scan.address += PAGE_SIZE;
> +					mmap_read_unlock(mm);
> +					return ERR_PTR(-EAGAIN);
> +				}
> +

I don't love just shoving more logic into an already massive function. No
to this.

At some point technical debt has to be paid, clean up this code first please.

>  				rmap_item = get_next_rmap_item(mm_slot,
>  					ksm_scan.rmap_list, ksm_scan.address);
>  				if (rmap_item) {
> @@ -2839,6 +2912,15 @@ static void ksm_do_scan(unsigned int scan_npages)
>  		rmap_item = scan_get_next_rmap_item(&page);
>  		if (!rmap_item)
>  			return;
> +		if (rmap_item == ERR_PTR(-EAGAIN)) {
> +			/*
> +			 * A non-zero page was skipped under
> +			 * only_merge_zero_pages: it was examined but not
> +			 * merged, so count it as scanned and keep going.
> +			 */

Similarly schloppy.

> +			ksm_pages_scanned++;
> +			continue;
> +		}
>  		cmp_and_merge_page(page, rmap_item);
>  		put_page(page);
>  		ksm_pages_scanned++;
> --
> 2.34.1
>

All in all adding far too much complexity in a cycle which is
fix-focused...

--
Cheers, Lorenzo

