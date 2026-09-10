Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21299C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D1F6B0092; Thu, 10 Sep 2026 00:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7256B0093; Thu, 10 Sep 2026 00:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FFB6B0095; Thu, 10 Sep 2026 00:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D09296B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:59:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B2B01203D4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:59:29 +0000 (UTC)
X-FDA: 85196649258.16.25BD1EE
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6378FA0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:59:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UbIvo9qb;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789016366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ql/2tajP1TkT4UOmZZW/kIFnjsqRcP7DEEYotvDlhI=;
	b=44GGhP1Ec3VY7DBf00/MPRzf3/YknNipyRsksCQxwYUtvpyzfsf1SHJFS6c6Bmy1U0OAVH
	4gb2JMPqXQqXOW5q2XZgzgi1TV+44rX5QqZXQ4EvtEiVVWpsdIQRg3t3ZBIQhonK5HyQJh
	wH+VPogYcOzz8s3z5O0+yB56EnzBDf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789016366;
	b=otqyyLNv5K++nMQdiPmIOzLTuEhaArDExIBgRG6DtYxYVNZHtAq09AhbpCQpy6AEWCe8Hw
	D9U45ZjfTGFH7mOLdCVjNnZVLfHxlm+wFhGE+jNJcLpnOICVzJeTXXS2UVPScDjDRCQMZB
	kFvwdkkKExc8Ol4e3zKSV0YQMbY3AHU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UbIvo9qb;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789016360; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5ql/2tajP1TkT4UOmZZW/kIFnjsqRcP7DEEYotvDlhI=;
	b=UbIvo9qbZh5qMbwTwMJblW9ksoDgWDzFho8JXpudXt66pu3Dfh2+kbs2Y62iSn/UcO6kk+VICd2qTeLiXItZwZjtTMkFAtfNqWohVGMaa31R6HzJ7koJFFOnupuEJJZIjLxkcAm1Hlt5iHjuUgXcRjfc1fCXUjiGiU128S/HwqQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAgbVTJ_1789016355;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAgbVTJ_1789016355 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 12:59:16 +0800
Message-ID: <162af233-ae81-40e6-8c71-d13a41b5d892@linux.alibaba.com>
Date: Thu, 10 Sep 2026 12:59:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/19] selftests/mm: add order-parameterized khugepaged
 collapse cases
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-12-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-12-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jcekzik4hep9qqnpfbc69ko7yjzcz1aa
X-Rspamd-Queue-Id: 6378FA0005
X-HE-Tag: 1789016365-647895
X-HE-Meta: U2FsdGVkX1+YpZJ1NSgXWL6BNfNKZD5YmBX99iXyr29gB4dUyhXYwzkNUQ9uA19TehB8HmeNlAwmDar9KsbOh7ryK60xOtYW96PRjCjEhRiIVGjLjekmGPLQVhmorPttYHExVhRsnGfffk3C8o3V2r3/6IW7jSg8AjIpf2eZRItHQNd+ZPgXp6/me3Svpd2IkiVc5SZoArjxmpqd9GGyV14cg/k8z4/F+J7V3fMvouxVSgGYRK9Pt2aRgPB8Z2KDTczb1Ki588wKWzP5EIrA9F1oGwtASId/0JVbi/L62AeTlkkRIjPDe8YTP74/FcQRIx5ZsJ6FfWH1wJ7pvyFVZB8ZZEehrwv79nwuB8r9M/94WAmm0OhMB3+E4Cw8lQGN2YZQ3DCxB9mj8Fs21gXnlabr82co24hy1Fx9VbjcPE8Bv+Wa+NBnoMHsH2JI6cLXUi1lS8PUFxRr22x7YlD/VLLWdAjlNIx28RHoEN7hiu/HxPW4Jj9/HFkKQMwkom53z3nEbjUQ8PRv3s/LeMfzS8mdpmioporPB+uqxpHRUa9xiRfV8u5ujokMgVxJbpSPj+k5WZ9WgRo6y+grEDkidNN5Og9tDL6s79oFen+lJ6gIiTh+95h+X01rFLdL0OAeZ1lhqfMln+Zm4d5iluMaB6XapG+9sT1lquPaIHtebfoBGOsCOxJ45RE4BLazAjRC4nUbUOimkj312h6v7A0fsdWwtDw/ipQWZQiyuT4uHf9Grcxk30qkM1sRz3RtmWO1hrH3hiLpsg0ZT7XmkUhQdWLpiJQchtC4jNdgS+JTxIPweAkW9CimtpESGTUZwPc2DJyGMjCUF2FWJMZenqGNbl9mdw+nzd3aqqUGmHy90P+ZbpusQD8ieqlUHSKZRG2kxh+WWMwR9Vocmw2aSZRmJL2tj9WtIigrQFbN5TKvip9jrCCBCxRJSHhIxF7vqnjudOka9xARc8lMKovnDcJ
 07DYnhYA
 pb6y1GIxxEKaG5KyZKgTVxtqjFP1xuTF/ftSN66FPy3KX37PEIWMVZ1OaAJ9/lFQ0ATdWSmErEVP27UZ8kZk3DQXBlACvWDjt0VglAREi11KI9dfhIfm3/NbATR0Sk3ahJBS7bsR+OmxGGCOaE8cBuI3Zq+N+snArEBhppQR9+IAkD0CD4jJMW+wzk+pxVP/RwT0J/HzTWRhOIbs99FMtlKUNdlpKWxRg3rLxUt9QnfXYktmPxvilPdsmc/lLktSn7Y39bzO8YqGcw+k85Ib5YST9wmHsGyYFy9Mxu4+MqK60Lh1fv21gM4nNeqz7xH1MMzUGLCiXNL38O2bOn6DMR4l1NtudZpQNo6NbXiGKHMJ/R6Vc1epVWt4r7YeT9xGbS5qshy48g6kJ21UtuVAFJE41Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The mthp_khugepaged context runs the generic cases at a sub-PMD order,
> which answers how many folios of that order a range ends up with.  It
> cannot say which order-sized window they landed in, so "the populated
> window collapsed" and "the empty window next to it collapsed instead" look
> alike.
> 
> Add four cases that check each window on its own, with the folio-order
> helpers in vm_util:
> 
> - collapse_order_single_window(): only the populated window collapses;
> - collapse_order_partial_window(): the default max_ptes_none lets a window
>    with one present PTE collapse;
> - collapse_order_max_ptes_none(): with max_ptes_none=0 a full window
>    collapses and one missing a page does not;
> - collapse_order_mixed_sources(): sources that are already large folios of
>    a smaller order collapse to the target.
> 
> Each case faults its region before MADV_HUGEPAGE with only the target
> order enabled, so the sources are order 0 and the result can only come
> from khugepaged.  They wait for a full pass rather than for the result to
> appear: without a completed pass, "not collapsed" and "not scanned yet"
> are the same thing.
> 
> Assisted-by: LLM
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 212 ++++++++++++++++++++++++
>   1 file changed, 212 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index e9bc8fe8a1f8..fb4efaf67c40 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -31,6 +31,8 @@ static unsigned long page_size;
>   static int hpage_pmd_nr;
>   static int anon_order;
>   static int collapse_order;
> +static int pagemap_fd = -1;
> +static int kpageflags_fd = -1;
>   
>   #define PID_SMAPS "/proc/self/smaps"
>   #define TEST_FILE "collapse_test_file"
> @@ -1207,6 +1209,198 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
>   	ksft_test_result_report(exit_status, "%s\n", __func__);
>   }
>   
> +/* Smallest order khugepaged will consider for mTHP collapse */
> +#define MIN_MTHP_ORDER 2
> +
> +/* Time budget for one khugepaged pass in the collapse_order_* cases */
> +#define MTHP_PASS_TIMEOUT_S 30
> +
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
> +	 * Only the target order, and only for madvise: the cases fault their
> +	 * region first, so the sources stay order 0 whatever -s asked for.
> +	 */
> +	settings.thp_enabled = THP_NEVER;
> +	for (i = 0; i < NR_ORDERS; i++)
> +		settings.hugepages[i].enabled = THP_NEVER;
> +	settings.hugepages[collapse_order].enabled = THP_MADVISE;
> +	thp_push_settings(&settings);
> +}
> +
> +static bool all_windows_at_order(void *p, size_t len)
> +{
> +	return is_range_backed_by_order(p, len, collapse_order,
> +					pagemap_fd, kpageflags_fd);

Like I mentioned in patch 8, you can implement these helpers using 
check_large_folios() in vm_util.c. Then you do not need to add new 
'pagemap_fd' and 'kpageflags_fd' variables.

> +}
> +
> +static bool any_window_at_order(void *p, size_t len)
> +{
> +	size_t window = mthp_window_size();
> +	char *addr = p;
> +
> +	for (; len >= window; addr += window, len -= window) {
> +		if (all_windows_at_order(addr, window))
> +			return true;
> +	}
> +	return false;
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
> +	if (any_window_at_order(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> +	ksft_print_msg("Collapse one fully populated window...");
> +	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
> +		fail("Timeout");
> +	else if (all_windows_at_order(p + window, window) &&
> +		 !any_window_at_order(p, window) &&
> +		 !any_window_at_order(p + 2 * window,
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
> +	if (any_window_at_order(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> +	ksft_print_msg("Collapse window with single PTE entry present...");
> +	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
> +		fail("Timeout");
> +	else if (all_windows_at_order(p, mthp_window_size()))
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
> +	if (any_window_at_order(p, hpage_pmd_size))
> +		ksft_exit_fail_msg("Unexpected large folio after fault\n");
> +
> +	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> +	ksft_print_msg("Collapse full window, not the one missing a page...");
> +	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
> +		fail("Timeout");
> +	else if (all_windows_at_order(p, window) &&
> +		 !any_window_at_order(p + window, window))
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
> +	settings = *thp_current_settings();
> +	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
> +	thp_push_settings(&settings);
> +	p = ops->setup_area(1);
> +	ops->fault(p, 0, hpage_pmd_size);
> +	thp_pop_settings();
> +
> +	/*
> +	 * The allocator can fall back to smaller folios under fragmentation;
> +	 * having nothing to collapse from is not a failure.
> +	 */
> +	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
> +				      pagemap_fd, kpageflags_fd)) {
> +		ksft_print_msg("No order-%d sources to collapse...",
> +			       MIN_MTHP_ORDER);
> +		skip("Skip");
> +		ops->cleanup_area(p, hpage_pmd_size);
> +		thp_pop_settings();
> +		ksft_test_result_report(exit_status, "%s\n", __func__);
> +		return;
> +	}
> +
> +	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> +	ksft_print_msg("Collapse region backed by smaller large folios...");
> +	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
> +		fail("Timeout");
> +	else if (all_windows_at_order(p, hpage_pmd_size))
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
>   static void usage(void)
>   {
>   	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
> @@ -1375,6 +1569,20 @@ int main(int argc, char **argv)
>   
>   	parse_test_type(argc, argv);
>   
> +	if (mthp_khugepaged_context &&
> +	    !(thp_supported_orders() & (1UL << collapse_order)))
> +		ksft_exit_skip("Order %d is not a supported anon THP order\n",
> +			       collapse_order);

This check can be moved into parse_test_type(), where the 
'mthp_khugepaged' parameter is parsed.

> +
> +	if (mthp_khugepaged_context) {
> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +		if (pagemap_fd < 0)
> +			ksft_exit_fail_perror("open(/proc/self/pagemap)");
> +		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +		if (kpageflags_fd < 0)
> +			ksft_exit_fail_perror("open(/proc/kpageflags)");

When you change to use check_large_folios(), these fds can be removed 
from this file.

> +	}
> +
>   	setbuf(stdout, NULL);
>   
>   	/*
> @@ -1425,6 +1633,10 @@ int main(int argc, char **argv)
>   	TEST(collapse_empty, madvise_context, anon_ops);
>   
>   	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);

These test cases look good to me. Thanks.

