Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8018CC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47EC6B017E; Tue, 18 Aug 2026 06:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8466B017F; Tue, 18 Aug 2026 06:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF736B0183; Tue, 18 Aug 2026 06:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A70146B017E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:48:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4976B140C28
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:48:16 +0000 (UTC)
X-FDA: 85114065792.20.362626D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B35CB1C0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:48:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kovZU/7y";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787050094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TwDFq2/nctY3UN8IAyIO34Zdwtve/TgTXGFFNJcRkJ0=;
	b=XaA3O45iapqyPz9/7IYRmErCArtSfsPGndKd18m5d77jxQkAXtGHTzIf/ff0WfLAkqKq20
	ojKCbgkFhu5Um2SOvSpwP0MaFPRBwGD7dR6XycTIU/7S8t/rLPmOUlLc7bMbFECGa49NMi
	ezGBzN1DWa+r29xa3pHjY0WsrhgBqcA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kovZU/7y";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787050094;
	b=GRkL2ydNT8IjwNoW/SlgRYjXrv+vEjdcDh7PYCF90CBdA5NtK1CQBMfhxV0wTGFgNGL3Ur
	dXPQNRCPP6NKp2JYNGfNLYxEYLcwvQBlnX/G/TNIMeIgjlXK+5VWVxo0up7I3WQfdIobtJ
	0ZAOE7l97jxX7I24dw8cza11lNspSMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37328601DE;
	Tue, 18 Aug 2026 10:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A171F000E9;
	Tue, 18 Aug 2026 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787050093;
	bh=TwDFq2/nctY3UN8IAyIO34Zdwtve/TgTXGFFNJcRkJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kovZU/7yFKFvJPqXoBS0X3229pO/YGiRjL/oizBOHC+qfQK8bfQhnZfdgUqDk7hkA
	 GaShO+716CkLWGmpVZaPOADp1L4ehZRqyIXUrAa5OvUC2AK1bja8tWz7fs5dyPAqV6
	 W+mehPIeD7NtE14bhH9nx00IlGeFThgElEQUqBLZgDNXNGOXhwBzgncEqHpuo6Kwst
	 Y8HDr8T+qP9uVd5sd2fdfat956HVYyXVw3zVpk/D27mBbPZ8jtc5arIHYXyBubhHJ3
	 R6CgzJarFMrdTTLwVzzFIyaAH0vFA8qzXbOXNfIPNCRXPuednxD7p3erzmiE2mHHQ/
	 BkrYzH323wq6g==
Date: Tue, 18 Aug 2026 11:47:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
Message-ID: <aoQ2XCILH-0h2B3G@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-13-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-13-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B35CB1C0007
X-Stat-Signature: w4dy3xzufy6xyiwz4jrhn3u8oe9wjrdf
X-Rspam-User: 
X-HE-Tag: 1787050094-304257
X-HE-Meta: U2FsdGVkX1+hjqSui0Vnaa7oCy+44itpk/QXIr51+JDCihvlWLi5xgkdvQiYToKVHHBnJP8lIT6MVI8FABR+q80VtZiCMN2XvnjRP3oV/sSA7tFPkQo9iLBPgWCWf0n2nODGKUj7KxFHM9FY5yiwwjEIr6nQ1qN2l2RVpJif/E1YLEGlFUZfYGWFvhHbUsJJdx4atCoOzZRVj8WBwq3N+dvhnb79Md4h+Lanoe+PpObxhHR26CypwCwehcqb1OlGNT2OA1DuJst+ZOPepv75182XJcCz08GgjHa0Jrkw1pUIZCy3OkZQjuz/z10mbdItmltqchAkZQmes4w9+/XYXDYlfLXBZe0zJVozjf3o8kpV0qk/3BzCHd2GGjoqcBRqI44Og1BVY87FytcNbDuMn1uJ632rlTOaJ+hwr2MG3TxYWZz5vxPHrcmexUrl7DMcZBDp+GFk4T0AnUqVXxE1WfrxKW5gp93s2G4OwiSGSmYgg8VgVlldV7yR02UUuSWyXxYABT+nhNlLGTFv1Nkb5rzPZJr/U5U29sc5VVIYrpxEbll9SvxwEJUAnmtq5dQW9KGZWQVUildlYaN3v+fVYyF/B4A/nSMkGE4sUc1jg2BBHY2m3woU7NIIQL/pKV2DNp1EhhptkyBpShUdqMRLbOGeAopi5YheUnOxj+6r3kqRobpFW7zKMox4Mka1MXbRSPHYUjOkTJaJOAglzEWf8PLZMcB4K0LTH/pKqso/oIEOimsGi0oIDrP8tezTfIPRO57Mg7pRX4H749WPKLPB5YjXE4f+AqY/kEqGi0GQsqgSUZNfmRyJjPvsI44j2Cr0RKRl/CSD5xpClRpaxkiRDzgHjiN53EiclhroWZ+0+pspcnxNaKRc3L3l+l9wkejzh7g6lSa8ifjvhIU3RZ0Lf0yFQ6g3H6AnNtM33IGmayMB8eLmmMqJZ3jNEzvMpVhEF9t6UObQeV24TUmqXIk
 tJDVUpfp
 zQflpvBRtdd3pcaqXy3fvVY+W2ESeC7Ylu3Oy/KHnm7UL32VVRXr1+2OBjNc/I5YsJLhLd4/uPoYtkJVsA+aybcjoopBaFQGr8CCB80MhP5OgKTY0U05ExtIdS7W/CQeDl+8DfrJppp+U1uFnEYRitnUNh2DLsEBCW6K4yjmiEu0uAvgN2QVv4/LFgBo1IK72euWBlI7wDzx9MNBrf9ypST0e73OphqocgCsJdQ5ivkT/MESvFu9GQDssDbtwyW5FijGmc5SWetkclG3sgvGl1GwkslfpSp2DJXauHvCIHOlvwmrW6spq2n0rC7YgGVfQ5sG2OiI008EWxQdwXn6OPb1g7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:54AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_order_mixed_sources() faults its region as order-2 folios and
> collapses them to the -c target.  Order 2 sits below the contpte threshold
> on both arm64 page-size configurations, so nothing in this suite unfolds a
> contpte source on purpose.
>
> Let -s name the source order alongside -c.  The case then faults at that
> order, keeping order 2 when -s is absent, and the source order has to be a
> supported mTHP order below the target.  The other mTHP cases are
> unaffected: mthp_push_target_order() enables only the target order.
>
> "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> larger mTHP.
>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Looks reasonable to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 0489967d6ee0..1844ddd77b59 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1389,10 +1389,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
>  static void collapse_order_mixed_sources(struct collapse_context *c,
>  					 struct mem_ops *ops)
>  {
> +	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
>  	struct thp_settings settings;
>  	void *p;
>
> -	if (collapse_order <= MIN_MTHP_ORDER) {
> +	/* Sources must be a supported mTHP order strictly below the target. */
> +	if (source_order >= collapse_order ||
> +	    !(thp_supported_orders() & (1UL << source_order))) {
>  		ksft_test_result_skip("%s: no source order below target\n",
>  				      __func__);
>  		return;
> @@ -1400,23 +1403,22 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
>
>  	mthp_push_target_order();
>
> -	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
> +	/* Fault the whole region as order-@source_order folios. */
>  	settings = *thp_current_settings();
> -	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
> +	settings.hugepages[source_order].enabled = THP_ALWAYS;
>  	thp_push_settings(&settings);
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  	thp_pop_settings();
>
>  	/*
> -	 * The order is enabled, but the allocator can still fall back under
> -	 * fragmentation.  That leaves nothing to collapse from, which is the
> -	 * machine's answer rather than a reason to end the run.
> +	 * The order is enabled and supported, but the allocator can still fall
> +	 * back under fragmentation.  That leaves nothing to collapse from,
> +	 * which is the machine's answer rather than a reason to end the run.
>  	 */
> -	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
> +	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, source_order,
>  					     pagemap_fd, kpageflags_fd)) {
> -		ksft_print_msg("No order-%d sources to collapse...",
> -			       MIN_MTHP_ORDER);
> +		ksft_print_msg("No order-%d sources to collapse...", source_order);
>  		skip("Skip");
>  		ops->cleanup_area(p, hpage_pmd_size);
>  		thp_pop_settings();
> @@ -1425,7 +1427,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
>  	}
>
>  	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
> -	ksft_print_msg("Collapse region backed by smaller large folios...");
> +	ksft_print_msg("Collapse region backed by order-%d sources...",
> +		       source_order);
>  	if (!khugepaged_wait_full_pass())
>  		fail("Timeout");
>  	else if (window_collapsed(p, hpage_pmd_size))
> @@ -1456,6 +1459,8 @@ static void usage(void)
>  	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
>  	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
>  	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
> +	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
> +	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
>  	exit(1);
>  }
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

