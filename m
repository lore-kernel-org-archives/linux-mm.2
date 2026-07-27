Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41469C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC316B009D; Mon, 27 Jul 2026 13:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D796B009F; Mon, 27 Jul 2026 13:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DF76B00A4; Mon, 27 Jul 2026 13:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFBA06B009D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:18:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5633616014D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:18:36 +0000 (UTC)
X-FDA: 85035215832.16.BAB8366
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 565F0100006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:18:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrvT9X6n;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785172714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuWbOoJyujNfmWfTnbDRre0Xx+nHPBkZLj3gLNMEYTM=;
	b=6vCvd35mAoRFVRovpJi10ZtOS0GNTjLsNDcUwt+/sV3RMcUogqdy6ALyn7p0f39EWGHPIt
	rmEpkZOSYX/Qn+CaXZa32x1pgMldfxebl2v/KDWo/racM9sdIICY+VDF2F02pXNVyPY9o4
	mHl086VAJxXeqw5HvUtVcDbT6WcKofw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785172714;
	b=FJ5ucoywMt7kAK/sJlapWCn/WZ8Q2Dp/1w6bnrSSZ0omz7urV1EbGpEwqAHHuYKcNyqwwZ
	ASCwzKmE5FC+7X8bqN46pKh4yv/unUr+NwOW1rWeh6JJMCP8sM1QprELHjaGDmL7e6Gq0e
	mOtcVyXuGkEQREhz9mYBwigJHtTFwSU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrvT9X6n;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785172712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuWbOoJyujNfmWfTnbDRre0Xx+nHPBkZLj3gLNMEYTM=;
	b=SrvT9X6neSmjeBoZuqVI8g5upFQUa3BlCUtZ36e7neOQ65nl2n5rm5LE5ogKmPN4Tavk4Z
	5lu/hB5Ep+0rpZxAR12DEBl9RVmiLn4/CJkSj6nipM+1dr2plskjC/0MD03y2GIcLyKjwy
	qPMR3asJHVlIlP/BnwzOQs1q4+o2Q58=
From: Usama Arif <usama.arif@linux.dev>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] selftests/mm: skip khugepaged swap tests without swap
Date: Mon, 27 Jul 2026 10:18:25 -0700
Message-ID: <20260727171825.2835957-1-usama.arif@linux.dev>
In-Reply-To: <20260727095225.372655-4-usama.anjum@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jaiet6fahegc9ygigew4n419zgq8zp4r
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 565F0100006
X-HE-Tag: 1785172714-303281
X-HE-Meta: U2FsdGVkX1/7v/30yUvBvkSUBepJTauTPG1j0kL8k4qBr+ERZLXO5HnQfjwQuvEZucQJXv1NTaEMuFkrwV7pOZLGp2kdC2sa+UEVELiPj1CL0WbOONO/F0313naqkmbDQ9ZcDSvqs/umOtnbKipL6pQ0BFE3c2xAqHKMLaxNP5SvsERqUJmibsYyHW63uo5D5TzbgoW4+6qCtdyUELdAxfKu0Q2ldWDG0GraUxeO84tnAh+GG89RmLEHqhSSqEU2pwfuWQMnQO0XkvwFMcXPBCh1HkLlejbeOyJVIcFyFdpOUMcE3+G2XxbY4BjNujKo0o+0XEmHJJ7uQkSy/VrGlbw1991KJpyIWBka/JM2N1bsUAsUOpIp44N/3Mm3rMOfUp7/SBr/fmqNTWnJNnsZ16d1AYNTNu3EjDg87EarsCA5C8y8ICksyAXDyH6C9dYIMV52gpIgsCp8gTVwP+hyoAucxav7FWXbXiZaSAQoIsUIaxyL83j2Ilj4OUhQtbUOxbh3kHkaF2MbGmpm2855u7FlrErSv+gd0d4iboZ7Sm0XW5NaFZkP4S8aTHD6yuVOsia6x+guujExClPyAhKaim935eGnKP7Kaxif56rXnQnMlAZ+E/eoTkU9BvAL+PuAmsryVZz8xJRa5LVBDj6raPl95IzVOEF9Eu8f8IJvCNdfnPVGat/OZQQpZn4YyR1o2ez9CXyYtgPtKV+4ZB8jzXliIP2ad/+8tvO4Ahc8FrBDW6ggJGuBRVJ9ni6RBokAyzEx2kPCc12alqcxirxr07Gbtiqw1UR9KKFNv/2B+RQOJmNzyvkJl4M3YHObQ0Q/1HIzI+/l++ZPcFv5QpHU6fq94EcNwykn3fVzvUr7nnnZG2bc6vg+dP913scVwj4pOjpL23UB7oXiCTmNIHrJElaMGrkOZPUTxbH9/quXBgg5WVsXXQLmuuEPqCym2BSh66PQN5BI8tsczAw+hn5
 raK8uNqQ
 coRtlBxq7ycMV6u/i8pGiLCNz7QnZm8Ndes12rTNoQ+y/TA6ITnZot3UKzbHR5Kc9FfMsaUVQzu6IKNRfSM+EPijdlqc0WrOquTMYd1AVZpAg2NKKhMNa+QZVrY9dQmZDY9BrutV3LUvgAg2mh+uf9mT7Vma+REOrFqHDzbbCmBXHadvZNywkgMdLAnqTZvq16XrQeCAlAWNtJWmaa0MMjmKX/X6F83Sv4iHVj9o2Ky9Gdh2CqA6M+BkPfLaXSaSKNRBc3ZxcQyZtGon3e/JicWcsBAchkAbAzb9ACaBwU28W2UDq3czcs+yOmZmk8Hj3d2QrQ6XqXebwEm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 10:52:19 +0100 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> collapse_swapin_single_pte and collapse_max_ptes_swap require
> MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
> systems there is no backing store with which to create those entries,
> so check_swap() reports missing setup rather than broken khugepaged
> behavior.
> 
> Swapless configurations are common on Android and other constrained
> test devices. Failing these cases obscures actionable results from the
> rest of the khugepaged suite.
> 
> Check /proc/swaps before either swap-dependent case and skip when no
> active swap area exists. With swap present, retain the existing
> MADV_PAGEOUT and swap-entry assertions unchanged.
> 
> Print each existing swapout diagnostic before the prerequisite check
> so skip() completes a KTAP diagnostic line instead of emitting an
> unprefixed message.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Print swapout diagnostics before reporting no-swap skips.
> ---
>  tools/testing/selftests/mm/khugepaged.c | 38 +++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087d..54e888eb48bbc 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -100,6 +100,28 @@ static void skip(const char *msg)
>  	exit_status = KSFT_SKIP;
>  }
>  
> +static bool is_swap_enabled(void)
> +{
> +	char buf[MAX_LINE_LENGTH];
> +	FILE *file;
> +	bool enabled = false;
> +
> +	file = fopen("/proc/swaps", "r");
> +	if (!file)
> +		return false;
> +
> +	if (!fgets(buf, sizeof(buf), file))
> +		goto out;
> +
> +	/* Check for first active swap entry. */
> +	if (fgets(buf, sizeof(buf), file))
> +		enabled = true;
> +
> +out:
> +	fclose(file);
> +	return enabled;
> +}
> +

Could is_swap_enabled() be moved to vm_util.c. This will definitely be reusable
in other places.

>  static void save_settings(void)
>  {
>  	ksft_print_msg("Save THP and khugepaged settings...");
> @@ -734,10 +756,16 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  {
>  	void *p;
>  
> +	ksft_print_msg("Swapout one page...");
> +	if (!is_swap_enabled()) {
> +		skip("No active swap");
> +		ksft_test_result_report(exit_status, "%s\n", __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	ksft_print_msg("Swapout one page...");
>  	if (madvise(p, page_size, MADV_PAGEOUT))
>  		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>  	if (check_swap(p, page_size)) {
> @@ -760,10 +788,16 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
>  	void *p;
>  
> +	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
> +	if (!is_swap_enabled()) {
> +		skip("No active swap");
> +		ksft_test_result_report(exit_status, "%s\n", __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ops->fault(p, 0, hpage_pmd_size);
>  
> -	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
>  	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
>  		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
>  	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
> -- 
> 2.47.3
> 
> 

