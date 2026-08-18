Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 368F1C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387286B0828; Tue, 18 Aug 2026 06:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EFF6B0829; Tue, 18 Aug 2026 06:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C176B082A; Tue, 18 Aug 2026 06:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0995E6B0828
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:38:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B07C91A0C01
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:38:55 +0000 (UTC)
X-FDA: 85114042230.14.8FF8690
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3910C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:38:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKnndPHH;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787049534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9vim7+PBiNxEAKW29JQ/88PPU5qvRNC7N85lUb/8B4=;
	b=RSrcRRUrfWubEjoz4XUeKLCRNOpIXks1aeAI28RgBp6ZLg3HccF721Zjybfxb7cPeTRbKc
	5zv6/WUqH6NQ1JRuULSzyYcctryWE+q4DU9u//Upnw9Mo9ZUPRJTa+t1kJXOzPL11YGM9I
	qfrIY2qd5zOpmrMt4TlULQ7/hzrQ6Rg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKnndPHH;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787049534;
	b=QJTZcXcCUF94jVrR9SPkd8R2CmhBxSPXTnuBl80sQANKuuV5okIMdjpfg8EgveETOjNNMh
	CyaZGVwZAkUXFlTK4KAcqtXDLG6lgPjDri0IGBJ3wts72ZsPYERtkfpR4fZWRuaXG1sh1P
	PjHccjyuoYgT9r1FQFEsJKaGT+jYkJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3304641B5E;
	Tue, 18 Aug 2026 10:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50411F000E9;
	Tue, 18 Aug 2026 10:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787049533;
	bh=a9vim7+PBiNxEAKW29JQ/88PPU5qvRNC7N85lUb/8B4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GKnndPHHhO+6b2PuX4aPjgqmT2cDGQ0nPrALWvMpZD4gnvx2j3earMD3SCjpC05Ci
	 BMZx4pP8P3Mrg/gAVk+dmalVJW2QSmJmpJeaWcg1dHhhVLm43j3j5L1ZHNqWAkGnze
	 5V/BwxBQu4Ra1MuENOTJXQVXJZyTc/XDwuVpLM4z/sc6sa/30feGT9CsTMBZFc2Xqe
	 /HnEA8ExofEb4DIQzvlx36+g6h8TUorfMmMwDyl4Jh+YzvET2YitdSbD+9Cp2NUxuj
	 XcujgicgBxm0G+RNc5mB6EuUJ30xRZ7UO6i+PFj3ii9kGlwFKBf4FrXEGBpkCTnzKa
	 3jQjTss0irO0A==
Date: Tue, 18 Aug 2026 11:38:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 11/19] selftests/mm: add order-parameterized
 khugepaged collapse cases
Message-ID: <aoQ11Zo40gJw7qI8@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-12-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-12-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3910C0004
X-Stat-Signature: amjujwabyzpawy1y8jhd196fuxwkr4uc
X-Rspam-User: 
X-HE-Tag: 1787049533-306684
X-HE-Meta: U2FsdGVkX19m3cyDdaW7XksRVLfNjJKSyiN22Boq+jyXHJ28uA2eDC/+HdgAozuGT1JmnAA3T6c7ETV72cocrn6EHL2nPAzDF9jLPythYla/75fX5ir62nJjemA0+7lLnqehvJOhE2jFkjtJr5nEgoZoWzbi9C14TOh2tbm0cIwMei4QXgIRctWxoZ6KZhb/nIkePmJ9k3VOY1KcNsD33Fhl+Mdwcch12Kjk6AE5ytol0wyTojAjuK77ayrW2pQ+1L+JU3GPxcc8hnDI+MT1QnIrv82ixnOdsPkCgXVEcImrPcHqdFr303hbVsT/nuaYBWdMXSLGNrHxWEH1RJSIckUU/S3tPb5WvD+jmC7+nS1eEku0aC6WOJBRpOIl7rt2wP0T542HB1XrIdieLkDb8+UsZvMrAHlZPtGjRs4kZ6WoHiGNNn/AdUxWxR152XTvGNZiF/0xd0h7UTOyexLNr4Q5xztS6+6WPnxSMXU/w53OTecxLjy51FR+HlNLva9Agte2SwCVBYaUBpUnZaNZgDPfmQh+alH+VMdud46WeJ4Qp4eHlmpTYo9qj08kQtelWA01kvIzQ5OIy8vR7SYGB2hGzSSsmDHcOs8wURkXy4BG0CMitGBqX5m/5Apku+k70sNBartjIuavWItpTsoQN1310scUq4cJlSzmiwVNx3+vKf+q+BsbRTaF7925WArZBVmoI50NiZKQGoBWA+Y8GtAVGTq6r6jDVQ4siN8xYJL/WlwOA9+Hf9/JmO6zvgRdxiWav/1CHRnTp6AoCKmHpeqClIz4Wx2wLG0o6gWkbY8YihDM4jnY6pRj9rPN1/d4ZvpAiIBLD/HSKqksU9f1+PVXw4jiEFbNvcQ/StK/Kjw+98L8oGO7nxkP+C2ZrYY9qlkC1agyYtmbThHirvoGOzV+6duNb1hnbWqOOxTpcL1+zKsmfipzgvkWXvP+cr5DSh+VowNt3Zt58kcr0nR
 xcjota+I
 YoqTmFL08hq0vlAXqg2gJDkXGECHMZiRdHJWVCbbKmMj7RJZA3TxKcaNmUg1OVa+iNsSTbkFGIYWUzffYaR0Yzz7LSwpi5Akn6+FNE0CDon0jM7LzyKdkRyukQM7mCOB76oMqNe6cipzMa0YO1u0U7jmXrFahSFvsHOHem++BFN07R1qj26ZUshJB2PYBIS3jCchXi9YeuVhWSuMuGudHd3DH/1BbFfS381svBmuOpuz3O8sDgBciXZfMap1s8KswD5D1Z7FPbc9vw8ooR6/+qvKElrKrKUVz4poLfpxqR9lqraj4XLnztm154tjcgc4mTMzqWFBnb6DxQ7ql7d5FYqC7FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:53AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> The mthp_khugepaged context runs the generic cases at a sub-PMD order,
> which answers how many folios of that order a range ends up with.  It
> cannot say which window they are in, so "the populated window collapsed
> and its neighbour did not" and "one window collapsed twice" look alike.
>
> Add four cases that check each aligned window on its own, with the
> folio-order helpers in vm_util:
>
> - collapse_order_single_window(): only the populated window collapses;
> - collapse_order_partial_window(): the default max_ptes_none lets a window
>   with one present PTE collapse;
> - collapse_order_max_ptes_none(): with max_ptes_none=0 a full window
>   collapses and one missing a page does not;
> - collapse_order_mixed_sources(): sources that are already large folios of
>   a smaller order collapse to the target.
>
> Each case faults its region before MADV_HUGEPAGE with only the target
> order enabled, so the sources are order 0 and the result can only come
> from khugepaged.  They wait for a full pass rather than for the result to
> appear: without a completed pass, "not collapsed" and "not scanned yet"
> are the same thing.
>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Same comments on comments as other patches - far too dense, read like a
discussion and not a terse description of something the code doesn't make
clear.

Please write comments yourself, LLMs are terrible at it (I mean I feel the
same goes for code also).

> ---
>  tools/testing/selftests/mm/khugepaged.c | 230 ++++++++++++++++++++++++
>  1 file changed, 230 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 0008862e7cbc..0489967d6ee0 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -31,6 +31,8 @@ static unsigned long page_size;
>  static int hpage_pmd_nr;
>  static int anon_order;
>  static int collapse_order;
> +static int pagemap_fd = -1;
> +static int kpageflags_fd = -1;
>
>  #define PID_SMAPS "/proc/self/smaps"
>  #define TEST_FILE "collapse_test_file"
> @@ -1227,6 +1229,216 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
>  	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>
> +/* Smallest order khugepaged will consider for mTHP collapse. */
> +#define MIN_MTHP_ORDER 2
> +
> +/*
> + * Order-parameterized collapse cases for the mthp_khugepaged context.  What
> + * they add over the generic cases run under that context is per-window
> + * detection: which aligned window collapsed, and which of its neighbours did
> + * not.  check_huge() answers how many folios of the order the range holds,
> + * which cannot tell one window from another.
> + *
> + * The region is faulted before MADV_HUGEPAGE, and the target order is only
> + * enabled for madvise, so the sources are always order 0 and the collapse
> + * product can only have come from khugepaged.
> + */
> +static size_t mthp_window_size(void)
> +{
> +	return page_size << collapse_order;
> +}
> +
> +static void mthp_push_target_order(void)
> +{
> +	struct thp_settings settings = *thp_current_settings();
> +	int i;
> +
> +	/*
> +	 * The target order, for madvise only, and nothing else enabled: the
> +	 * cases fault their region before MADV_HUGEPAGE, so the sources are
> +	 * order 0 whatever -s asked the fault path for.  That matters for the
> +	 * cases built around a hole -- a large source folio would fill it in
> +	 * and the window would collapse after all.
> +	 * collapse_order_mixed_sources enables the source order it wants on
> +	 * top of this.
> +	 */
> +	settings.thp_enabled = THP_NEVER;
> +	for (i = 0; i < NR_ORDERS; i++)
> +		settings.hugepages[i].enabled = THP_NEVER;
> +	settings.hugepages[collapse_order].enabled = THP_MADVISE;
> +	thp_push_settings(&settings);
> +}
> +
> +static bool window_collapsed(void *p, size_t len)
> +{
> +	return is_range_backed_by_folio_orders(p, len, collapse_order,
> +					       pagemap_fd, kpageflags_fd);
> +}
> +
> +/* No aligned window in [p, p + len) is backed at the target order. */
> +static bool window_not_collapsed(void *p, size_t len)
> +{
> +	size_t window = mthp_window_size();
> +	char *addr = p;
> +
> +	for (; len >= window; addr += window, len -= window) {
> +		if (window_collapsed(addr, window))
> +			return false;
> +	}
> +	return true;
> +}
> +
> +static bool khugepaged_wait_full_pass(void)
> +{
> +	/* Wait up to 30 seconds for the pass to complete. */
> +	return khugepaged_full_pass(30);
> +}
> +
> +static void collapse_order_single_window(struct collapse_context *c,
> +					 struct mem_ops *ops)
> +{
> +	size_t window = mthp_window_size();
> +	void *p;
> +
> +	mthp_push_target_order();
> +
> +	p = ops->setup_area(1);
> +	ops->fault(p, window, 2 * window);
> +	if (!window_not_collapsed(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
> +	ksft_print_msg("Collapse one fully populated window...");
> +	if (!khugepaged_wait_full_pass())
> +		fail("Timeout");
> +	else if (window_collapsed(p + window, window) &&
> +		 window_not_collapsed(p, window) &&
> +		 window_not_collapsed(p + 2 * window,
> +				      hpage_pmd_size - 2 * window))
> +		success("OK");
> +	else
> +		fail("Fail");
> +
> +	validate_memory(p, window, 2 * window);
> +	ops->cleanup_area(p, hpage_pmd_size);
> +	thp_pop_settings();
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
> +static void collapse_order_partial_window(struct collapse_context *c,
> +					  struct mem_ops *ops)
> +{
> +	void *p;
> +
> +	mthp_push_target_order();
> +
> +	p = ops->setup_area(1);
> +	ops->fault(p, 0, page_size);
> +	if (!window_not_collapsed(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
> +	ksft_print_msg("Collapse window with single PTE entry present...");
> +	if (!khugepaged_wait_full_pass())
> +		fail("Timeout");
> +	else if (window_collapsed(p, mthp_window_size()))
> +		success("OK");
> +	else
> +		fail("Fail");
> +
> +	validate_memory(p, 0, page_size);
> +	ops->cleanup_area(p, hpage_pmd_size);
> +	thp_pop_settings();
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
> +static void collapse_order_max_ptes_none(struct collapse_context *c,
> +					 struct mem_ops *ops)
> +{
> +	struct thp_settings settings;
> +	size_t window = mthp_window_size();
> +	void *p;
> +
> +	mthp_push_target_order();
> +	settings = *thp_current_settings();
> +	settings.khugepaged.max_ptes_none = 0;
> +	thp_push_settings(&settings);
> +
> +	p = ops->setup_area(1);
> +	ops->fault(p, 0, 2 * window - page_size);
> +	if (!window_not_collapsed(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
> +	ksft_print_msg("Collapse full window, not the one missing a page...");
> +	if (!khugepaged_wait_full_pass())
> +		fail("Timeout");
> +	else if (window_collapsed(p, window) &&
> +		 window_not_collapsed(p + window, window))
> +		success("OK");
> +	else
> +		fail("Fail");
> +
> +	validate_memory(p, 0, 2 * window - page_size);
> +	ops->cleanup_area(p, hpage_pmd_size);
> +	thp_pop_settings();
> +	thp_pop_settings();
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
> +static void collapse_order_mixed_sources(struct collapse_context *c,
> +					 struct mem_ops *ops)
> +{
> +	struct thp_settings settings;
> +	void *p;
> +
> +	if (collapse_order <= MIN_MTHP_ORDER) {
> +		ksft_test_result_skip("%s: no source order below target\n",
> +				      __func__);
> +		return;
> +	}
> +
> +	mthp_push_target_order();
> +
> +	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
> +	settings = *thp_current_settings();
> +	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
> +	thp_push_settings(&settings);
> +	p = ops->setup_area(1);
> +	ops->fault(p, 0, hpage_pmd_size);
> +	thp_pop_settings();
> +
> +	/*
> +	 * The order is enabled, but the allocator can still fall back under
> +	 * fragmentation.  That leaves nothing to collapse from, which is the
> +	 * machine's answer rather than a reason to end the run.
> +	 */
> +	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
> +					     pagemap_fd, kpageflags_fd)) {
> +		ksft_print_msg("No order-%d sources to collapse...",
> +			       MIN_MTHP_ORDER);
> +		skip("Skip");
> +		ops->cleanup_area(p, hpage_pmd_size);
> +		thp_pop_settings();
> +		ksft_test_result_report(exit_status, "%s\n", __func__);
> +		return;
> +	}
> +
> +	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
> +	ksft_print_msg("Collapse region backed by smaller large folios...");
> +	if (!khugepaged_wait_full_pass())
> +		fail("Timeout");
> +	else if (window_collapsed(p, hpage_pmd_size))
> +		success("OK");
> +	else
> +		fail("Fail");
> +
> +	validate_memory(p, 0, hpage_pmd_size);
> +	ops->cleanup_area(p, hpage_pmd_size);
> +	thp_pop_settings();
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
>  static void usage(void)
>  {
>  	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
> @@ -1395,6 +1607,20 @@ int main(int argc, char **argv)
>
>  	parse_test_type(argc, argv);
>
> +	if (mthp_khugepaged_context &&
> +	    !(thp_supported_orders() & (1UL << collapse_order)))
> +		ksft_exit_skip("Order %d is not a supported anon THP order\n",
> +			       collapse_order);
> +
> +	if (mthp_khugepaged_context) {
> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +		if (pagemap_fd < 0)
> +			ksft_exit_fail_perror("open(/proc/self/pagemap)");
> +		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +		if (kpageflags_fd < 0)
> +			ksft_exit_fail_perror("open(/proc/kpageflags)");
> +	}
> +
>  	setbuf(stdout, NULL);
>
>  	/*
> @@ -1450,6 +1676,10 @@ int main(int argc, char **argv)
>  	TEST(collapse_empty, madvise_context, anon_ops);
>
>  	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
>
>  	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
>  	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
> --
> 2.54.0
>

--
Cheers, Lorenzo

