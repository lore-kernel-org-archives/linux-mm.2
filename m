Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAD5C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02096B00A2; Thu, 20 Aug 2026 04:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9406B00A3; Thu, 20 Aug 2026 04:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF4F6B00A4; Thu, 20 Aug 2026 04:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4AF6B00A2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 136F6C0507
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:27 +0000 (UTC)
X-FDA: 85121003814.01.075BFC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 648E720007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+fX4A+c;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNxWCi3yGoXYWUtnpfwteYPUr0j/rlA3LzUwoatWwKs=;
	b=ztB/BCYyBN2rSaOZweae+BJZ+9rcWLOw+7QK7718/p5SXuP9y7ySIbRLkp9QZ+/9SEqiYR
	KA78yaRoqK8q8NtyU2cLzYmGcv/WDBBYi8nutQEshMb7H26/FnBWw/6k/8WXD+BLY2FH4U
	K2zd3taVlF+8D20A1OsJguF6CUwTX4o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+fX4A+c;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215285;
	b=a5IkwAhQxVFXx2pF/XFjruqlMOcFURFohiZeAFqt6rH6RyKwbEPkor9ylAvnGPJxMZP7n2
	uLWgb2waGRoEVR9Qw2Rm8Z4jgKo7USkvQAcg5xABJsqmBB/gvffSJAwoaNBSRK9IeH2Lw8
	1UDuxUzb9IYdq1/3Lx3QCtbdJwJ6xJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 017CA618A9;
	Thu, 20 Aug 2026 08:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F8D1F000E9;
	Thu, 20 Aug 2026 08:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215284;
	bh=jNxWCi3yGoXYWUtnpfwteYPUr0j/rlA3LzUwoatWwKs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=O+fX4A+cfqy2cu5BO8P/JfVmsMImoss5n48YQ3xypQhyEM+oLIrHih8bInNvcCMZb
	 GOemMbD1pzlmKwgBnjl+LWFjvX8wnRF4mzbXuWDTwI85BU4z/+sOn2pOrvvj5HeNpu
	 MsayuynthssBO7r7ZQr7uoi0JpIaJJHq2LKZTLyH7sUq/nFes48yZNFEpze5a8/Jz4
	 Kc0rw6JwHs8l0kV4fng9drAEgR+GIwQkU43S2YyqHzkZRDeVKUMxKBaN/SWxnU/5fq
	 UCnpbmd+/aE+KqhTNS96PY18JprbZ8m9qOEAqDVs1lvSAxgOvTJm0tnoKH0Ez+tvB3
	 rpWHnZ4zhfmUw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 11/19] selftests/mm: add order-parameterized
 khugepaged collapse cases
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-12-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-12-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.18230284669032818374.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 648E720007
X-Stat-Signature: 9d5qeh8jd954outfq43te4jdfz5hzwpp
X-Rspam-User: 
X-HE-Tag: 1787215285-340117
X-HE-Meta: U2FsdGVkX18Y5RlZnUgii80gV0Cg7hNA8r2RGZYKlBy6ztbXkRozQIwFHXWNKCLu9DfTgT2lkOj31ovCDI6EFzLWIFIOeEDdTRUVUesdJcJWGqn9/YY+Jy0vDaS/Pcnl2QSG8CBkqvD60AMufAMnfzPXcBInxAVtKqlRvGTRaybyTJCdw9HoLvD6xstR4Yq2eQsO5FnqOXrY/q50jKDNqlw5TWa0k+ZhpJt7OqnnwoDX9iFi3vFbcRrUCAHIM82gjToAcAYUj2ikue5dF9XuhgEHPtlkLVdIN6roHpO4kor4k3d9ayLFoX3+vgqCszhpiP8S5lyLRHN+s9coyeI1L/TyMRFeM9A1dBZsSCxjDP1HYzMKBearAPQ/3j3q38MymXNT4swa8ZeWwQKDCajyqdPfEedOXd0AqcP8g8+ZBMdSpswqJvGPnaDXPtKcIwtyKeHZ+TB6hkf6g+aSKUgoMejxZP1JFkjqUmgrHaHGGkVHccJKOi36V/6synzQ/3zFG+d7YTs+2J2VpCxrjaMcfQ566LIvYkzSgi8mqw0no1P7mrkHPz7NW6XP8fYZ5Qi8Bo+nSlY+WRvNVJGRO+7KaLhHRsMpmgtnN4Z18vaRi2VEXK63c59LtlAuRdc83VAvKaMbux6ZlxQhEXMxnTNhS40XBazhny9K243eRhtomFQRWbuk239YY6EJEOar/MzObv/MgFIzRITAM/hMdEoPVhtWRg2zW7dC4WC+dey8h77pZRK9w9p5QkgmlXw+QEZ8Z7VpLxwT5fD5pUddx0ZTR5RPhgLWdc4XM+fndvJpaFVUxeydroWA5xfqr328Jw/WgnAEvXTC6GkuZbGcsBwGtldE5wmBttFOduODF60NEHt9rOeMWpvV+BEG1eE4uUvinbYsaPD5myfMimbae/z/djyMeYCCSVgpeCnAk900SWfM8AxzvkLvN74JUNj9oCgb9iLJaC4H9R1UlCWNCI0
 h7gKw0tH
 49rOKZEgfkGdQnIV6bXqDEStIwFi3e2OiMjOAEMfoXidWPD6ivLJU+R8NixHKbcHgP1YohD09Gg3W2nWlpJf8f7OKzUv9hAOHXkoic6KIaLHz8tKbh3+l7UEO0qFVhOE4wtc/2X3HhavkGGrntk9XrubIuJfgBcx+0RyX84Uv1VwpoYeOznn9XQTB90C/lERNH+FF7yZckWzLtPDHe6qVUEjycoxveJ/UKSSLuGCy1l40/FLN06AO3oTR/qVq/7ZmGO/iQa9bQHm5Rieo6vb+djaUVKBh+1Y5APRtHWIWPeirLdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 5aa92de93ec1..56e364320145 100644
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
> @@ -1261,6 +1263,216 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
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

This comment again reads like in the context of the changes driven by
the current prompt.

> + *
> + * The region is faulted before MADV_HUGEPAGE, and the target order is only
> + * enabled for madvise, so the sources are always order 0 and the collapse
> + * product can only have come from khugepaged.
> + */

Hmm, what claude tries to tell us here?

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

I'd expect window_not_collapsed to be !window_collapsed.
Maybe we need to add some order notion to both of them, like
exact_order, any_order or something like that?

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

Isn't it clear from the call? And do we really need this wrapper?

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

!window_not_collapsed  reads weird

-- 
Sincerely yours,
Mike.


