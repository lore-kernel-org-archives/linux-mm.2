Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A30C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 05:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2556B008C; Thu, 10 Sep 2026 01:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9816B0093; Thu, 10 Sep 2026 01:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF0E6B0095; Thu, 10 Sep 2026 01:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0EC6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:09:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3DE61C2205
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:09:12 +0000 (UTC)
X-FDA: 85196673744.23.1CF7C5D
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 135AB1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:09:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IPAHEByV;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789016951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM97NZNkgRQvm4z0BalpDvlSr5wYN5Y0N3YdRoica9U=;
	b=DffzNdhR9JhAnb5L1r+sl3Y/511K/RYYmWB9Mp8eeF6JlBBE7dYi2eSd16pWLByQYWXtnH
	c141lPgRwZmcN25DBXroG/RbWGhehZML7QHxxx7J+Fmkv2xs3ABxr+rKtRjrPSYplu6uM3
	EYOiLMaWYs7okWEs4CEifU2QEMzvSoU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IPAHEByV;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789016951;
	b=d8YlEwZV/blZQEIaqyclm6r32ESp7WGnzvbZidSlxp6jjuXTgN8z02eqEHz1IyD+tCVfa8
	gFuvRHLuoYgJLSHrb7C+9RP81FrhcTdBhErtvuYRKauPwAjPR3e+Av3sm3zcj9ExRHbeHk
	pMGV3upiod3Qm1v7FZ3YsxRPib1lDoE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789016945; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iM97NZNkgRQvm4z0BalpDvlSr5wYN5Y0N3YdRoica9U=;
	b=IPAHEByVWQafrAmxw53ErU29wo2J3viol0RmtlSIaHaChJL1FF4wnc7IUM2jO5ovGj2gwOErk2iGtFfFsu9jHWmyopa3dkgF+OVfpNoQ0GyJ2OczlQL85HX3mQfsrx6/gtrWe36BuqLxtWMd+88LJCAtWSFC6GaWcrwDL810jyI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAgbYFF_1789016941;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAgbYFF_1789016941 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 13:09:02 +0800
Message-ID: <4aeaa283-a417-45a9-9298-8123192dc707@linux.alibaba.com>
Date: Thu, 10 Sep 2026 13:09:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
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
 <20260908125105.1510704-13-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-13-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 135AB1C0002
X-Stat-Signature: 6oi7ot7frm59m8iqtoskud63w7y83meb
X-Rspam-User: 
X-HE-Tag: 1789016947-946429
X-HE-Meta: U2FsdGVkX1+4xg7AZPxcrEITGdtRYmzVQH1FiAwMSji0y/XaYlN8pAR69LmDg1J4MOaNhJDtF+2O77oJfyROBAYUFTXsWsQQdFBTfKdzZHbzEKdVQuNQwOe6NOJhdpH25/suVemXCxk0eLkQqvbgiZqjKyCqIfMlON3cZpM80G+wRK92u9PzqNIXYgG6MW9h9ZTGgvLUufZd7UfT6XrJ3egAJQv0M+GW8OIo0m7sGJmpwZ0++yWiF20ujMhUarzPtMaOuEnkMTziIISszELA79uXkmwltER46fX3qJyxjgxam14aITBaoscAGg3FfsVsnynUwdksjDYLJyskov5nU9DWZbYaNdrySSY6JIelSIwg+JYJv7VoUx53NePjIG3/yEejM9GXWWfv9OBhRN6ytixFSFlUVH4gURrMGFfHp/4cIfGUYuoN7mMhg+ofvimYNcK7I9cejGP41ltmO3wgTHXxqHE86coaHGfpf/5n+ZA30w/p0CP4mW509BoXEGWZYfkCuzOzSVhLq7zO9pFgO1EWxkPiv6CGdTe0UFSzo0JJ7RHdkDYj5EDSuaKfQzXtQv76Ubt1DODy4I4ve7PIqzf5LdGEXujIqkPy57QWh97iKsUKdUvNEGWLERTYn6NUshjs5Wcjx7WwhZRc2JNrLWCSxMLHiicTdDyfOPTiLyquAm2dV5XNCaQSikgcWaYZgnJ64owC704ckQjuEbsqzu4YAeGyegAgjitERzm6f70P6V+u3TuErR4j7AGTQ7sUghsq0WS0qfMS7v+FzO2TLshRmjF0K+XXiMlIjntH7DxkrMiWiAiF6YgfooQ58Dy72gd2E8AB1UwlQKdmzgKwiWgPT3jLS4saYQ1GTXfUdMBAm+J5XCSr4uKFVfN94Efj3cJGWzP19sV3Bpri6Ct0f5oe/Hu8GoyLMwF3jjUetQ1PHNxvOQSB9uzl5ZkbRLVLPf/8BIzbgK1MXsqVkui
 ZgT/L/gi
 oRGY8BTun4orCKwcNynKNPrf74ultdR6276Ww9BCx9FSnFcZPqJ5NH+QJYEThk/MJ3/pG60z+eVy9HbkZ9x7Fhsb5ODCHGKxuHq+A6Iqb4UxFgMCD4ewttuQCOtekKGXQxDZkN4GMn/Mc5PodPD3Fveh+btRRuUH69CGDacDiiVFEyTmRRuNhfbUY8gc22xLu2GfaiS62kjbiEH/ytLySVTcmXKbRrkfsaqy7QCx+pk2Ti1G9gi375GHyip/lHfJ3lJXuE29DyrhaockYU1hRmPfl16cLzliLXRQ/dBbJ6xD8MOTDvFLDVeZeje84uTZwkw64cm29wj4QRq4DeIChzMGfdGxZAMGHSvEQMTZ7KV2mDxQ5IDtqHh8nyY5oD2oRP36/SNHAMLKzBXQPVZK8eyVh+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_order_mixed_sources() faults its region as order-2 folios and
> collapses them to the -c target.  Order 2 is below the contpte size on
> every arm64 page size, so nothing in this suite collapses a contpte-mapped
> source on purpose.
> 
> Let -s name the source order alongside -c.  The case then faults at that
> order, keeping order 2 when -s is absent, and the source order has to be a
> supported mTHP order below the target.  The other mTHP cases are
> unaffected: mthp_push_target_order() enables only the target order.
> 
> "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> larger mTHP.

Make sense. But we should validate invalid parameter combinations for 
'-s' and '-c'. For example, when I set the following unreasonable 
parameters, some test cases fail, so such invalid configurations should 
be rejected.

[root@]# ./khugepaged -s 7 -c 6 mthp_khugepaged:anon
TAP version 13
# Save THP and khugepaged settings... OK
1..8
# Allocate huge page on fault... OK
# Split huge PMD on MADV_DONTNEED... OK
ok 1 allocate on fault and split
#
# Run test: collapse_full (mthp_khugepaged:anon)
# Collapse multiple fully populated PTE table.... Fail
not ok 2 collapse_full
#
# Run test: collapse_empty (mthp_khugepaged:anon)
# Do not collapse empty PTE table.... OK
ok 3 collapse_empty
#
# Run test: collapse_single_mthp (mthp_khugepaged:anon)
# Collapse PTE table with half PTE entries present.... Fail
not ok 4 collapse_single_mthp
#
# Run test: collapse_order_single_window (mthp_khugepaged:anon)
# Collapse one fully populated window... OK
ok 5 collapse_order_single_window
#
# Run test: collapse_order_partial_window (mthp_khugepaged:anon)
# Collapse window with single PTE entry present... OK
ok 6 collapse_order_partial_window
#
# Run test: collapse_order_max_ptes_none (mthp_khugepaged:anon)
# Collapse full window, not the one missing a page... OK
ok 7 collapse_order_max_ptes_none
#
# Run test: collapse_order_mixed_sources (mthp_khugepaged:anon)
ok 8 # SKIP collapse_order_mixed_sources: no supported source order 
below target
# 1 skipped test(s) detected. Consider enabling relevant config options 
to improve coverage.
# Totals: pass:5 fail:2 xfail:0 xpass:0 skip:1 error:0

> Assisted-by: LLM
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index fb4efaf67c40..b15cd07fc0b3 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1352,11 +1352,13 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
>   static void collapse_order_mixed_sources(struct collapse_context *c,
>   					 struct mem_ops *ops)
>   {
> +	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
>   	struct thp_settings settings;
>   	void *p;
>   
> -	if (collapse_order <= MIN_MTHP_ORDER) {
> -		ksft_test_result_skip("%s: no source order below target\n",
> +	if (source_order >= collapse_order ||
> +	    !(thp_supported_orders() & (1UL << source_order))) {
> +		ksft_test_result_skip("%s: no supported source order below target\n",
>   				      __func__);
>   		return;
>   	}
> @@ -1364,7 +1366,7 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
>   	mthp_push_target_order();
>   
>   	settings = *thp_current_settings();
> -	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
> +	settings.hugepages[source_order].enabled = THP_ALWAYS;
>   	thp_push_settings(&settings);
>   	p = ops->setup_area(1);
>   	ops->fault(p, 0, hpage_pmd_size);
> @@ -1374,10 +1376,9 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
>   	 * The allocator can fall back to smaller folios under fragmentation;
>   	 * having nothing to collapse from is not a failure.
>   	 */
> -	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
> +	if (!is_range_backed_by_order(p, hpage_pmd_size, source_order,
>   				      pagemap_fd, kpageflags_fd)) {
> -		ksft_print_msg("No order-%d sources to collapse...",
> -			       MIN_MTHP_ORDER);
> +		ksft_print_msg("No order-%d sources to collapse...", source_order);
>   		skip("Skip");
>   		ops->cleanup_area(p, hpage_pmd_size);
>   		thp_pop_settings();
> @@ -1387,7 +1388,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
>   
>   	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
>   		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> -	ksft_print_msg("Collapse region backed by smaller large folios...");
> +	ksft_print_msg("Collapse region backed by order-%d sources...",
> +		       source_order);
>   	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
>   		fail("Timeout");
>   	else if (all_windows_at_order(p, hpage_pmd_size))
> @@ -1418,6 +1420,7 @@ static void usage(void)
>   	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
>   	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
>   	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
> +	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
>   	exit(1);
>   }
>   


