Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62896C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C676B00C3; Mon, 12 Jan 2026 10:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58CB6B00C5; Mon, 12 Jan 2026 10:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92E46B00C6; Mon, 12 Jan 2026 10:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A92856B00C3
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:18:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72B03C1DFA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:18:06 +0000 (UTC)
X-FDA: 84323667372.09.D7ADDDB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62E6714000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:18:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IG9ja2+bxsL/bb2xoXNKNEkZ4+2cAFzoZkTz7V/9QxQ=;
	b=kRTYeCJgUa4XtfpCs6TWpYiBaet+N5mKtHfod7yYLmvt+lramnU9GZ9manPDxZV+bMae1K
	9VLk98S41GvpQ3VtmLMRqDmTgLYMevAVnebSnzxv+FTI0COBZyA7iPtKQhwD1A2HfUymGH
	1dT+kyYEMeSXSZfHJdPw2ECZ5Oo2K7k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231084; a=rsa-sha256;
	cv=none;
	b=NlJQcKuR0SFmhXL8INt4MAvrban2mvl71KIpWNgHUJxfFSVFBrwML3P3/sk4QjUMpScarr
	iRUJLP2KENBu/swegb+ko+Kf/EqwZpresLCe5635OKKuwRtGoGfTdBdg7PRcYtOuykg/Ph
	3C1R/MQ0hFIuPGXDyGIt5LSqm7B6dkQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 877E7497;
	Mon, 12 Jan 2026 07:17:56 -0800 (PST)
Received: from [10.57.95.123] (unknown [10.57.95.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B6053F694;
	Mon, 12 Jan 2026 07:18:02 -0800 (PST)
Message-ID: <aa38c43c-0907-4b49-8e76-a2ade35089cd@arm.com>
Date: Mon, 12 Jan 2026 15:18:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: kmsan: add tests for high-order page freeing
Content-Language: en-GB
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com,
 kasan-dev@googlegroups.com
References: <20260112145150.3259084-1-glider@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260112145150.3259084-1-glider@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 62E6714000D
X-Stat-Signature: gwjk363gqassi4kxzejehwyj5qwsui1x
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768231084-745422
X-HE-Meta: U2FsdGVkX1+ewi+2VOtWHWR9KTL/7A/X8H2/r6pkZqza75mvMv5r2G+YB0sz2mR8fFiPFFmUZUza8mgr7Ba2wjLC/4zeQXWc5cFqnMdF8V/wqZAbljuURodmjYQm8KDdz51eeW7beR9xKtn7NhpQ5heBypAS0iCiHKTW1ugVLgP0B08YfoSyBMKvwC6ZurhGKwLTbWgOOFoy5RWRSL7b1FAI1mBy/Ua4M4eTYWUol/BjDWktkdK71izKhJAkPmfZe/Kaov/gncM8VXQWyqulhGPqJTJQYxb7HQKmKfNyciW6s5QTZi7Ut0dKPxI/ecDlmWwtnKzp0IOFZSJUU2mX0VxuZo05BlLWobAlG4QknPZHfI6f7Apyg8ao7jVTOVaMAGm5bB4M45T2txJJR4hzEiTUTGDfMudSUMkNvwhUUZAhj6WTEWu6SIpI7V4WjtsLiGALCZOGscqddIX1U8VVTcW08nR4HvN5X4Sd24vTxEcGYx+m3RJH9DWO8a74aChExIjHx3VGUYnH3061CZos9Gh9HGSPIIJuUM9d0aXQr1BrYAj3vwI8AitP907A7lldF6+hhZCLnfeUusLrZJWprkPH7SbD9UEVrMDvi+ZArxrMKFF5jBHI4XDv/NOoBnYDFfBan8GmUZPAPkpmyqu69UJ5g45AuxOM1w0ClP6AuEGocwaZyqlqY8kac8ea9N/DBXSMPs9nqeZYLTGLnh3xO3SXtCLI6prQnQK9jAD693Ikojy5lprkzJlwXtENCBLQruHy/KQjuAF6jBUar/i9DxKf9uVBoRD0s3cDZuyFOoioHsvzzQQzNVQaJz05VJ2BQz13fmYBn70XDOIQ0tjblDzKH27YmhtEE7TaeDKMg764vpvEfMYkpMiHh2X0GmeEVw4PxHEnrFwJfsABsNr63fzphQ/ox9PntuNwJQxOxaipPqkOlzPmMoR73lpPjoWk8ANsYLe4ZEZQvTlQti0
 izmhTU8J
 RFTnQPTmlt+GqYjF3fILFjmSkumMLM5xq1hSuP9Gq0x3cgo4fT3wNq2FAj3UQW/qk62J//wrwwnVOrE5BnZfFzS+yo2nhExanxorNvw7Uux8dASnWNXb4TlOjBo/tpzMVc1DUtEGMGCvylt0M9u3QhFQI6I/9V/ol8f9hdecYO6iB3lwfdG2TkrHLbUZxua2mlUM7DXwTLr0WP6gdL4WTG9V4bv21CMGEBjUnfh2TdvClEE0sHtEZoIPCHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/2026 14:51, Alexander Potapenko wrote:
> Add regression tests to verify that KMSAN correctly poisons the full memory
> range when freeing pages.
> 
> Specifically, verify that accessing the tail pages of a high-order
> non-compound allocation triggers a use-after-free report. This ensures
> that the fix "mm: kmsan: Fix poisoning of high-order non-compound pages"
> is working as expected.
> 
> Also add a test for standard order-0 pages for completeness.
> 
> Link: https://lore.kernel.org/all/20260104134348.3544298-1-ryan.roberts@arm.com/
> Signed-off-by: Alexander Potapenko <glider@google.com>
> ---
>  mm/kmsan/kmsan_test.c | 48 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
> index 902ec48b1e3e6..25cfba0db2cfb 100644
> --- a/mm/kmsan/kmsan_test.c
> +++ b/mm/kmsan/kmsan_test.c
> @@ -361,7 +361,7 @@ static void test_init_vmalloc(struct kunit *test)
>  	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
>  }
>  
> -/* Test case: ensure that use-after-free reporting works. */
> +/* Test case: ensure that use-after-free reporting works for kmalloc. */
>  static void test_uaf(struct kunit *test)
>  {
>  	EXPECTATION_USE_AFTER_FREE(expect);
> @@ -378,6 +378,50 @@ static void test_uaf(struct kunit *test)
>  	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
>  }
>  
> +/* Test case: ensure that use-after-free reporting works for freed pages. */
> +static void test_uaf_pages(struct kunit *test)
> +{
> +	EXPECTATION_USE_AFTER_FREE(expect);
> +	const int order = 0;
> +	volatile char value;
> +	struct page *page;
> +	volatile char *var;
> +
> +	kunit_info(test, "use-after-free on a freed page (UMR report)\n");
> +
> +	/* Memory is initialized up until __free_pages() thanks to __GFP_ZERO. */
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	var = page_address(page);
> +	__free_pages(page, order);
> +
> +	/* Copy the invalid value before checking it. */
> +	value = var[3];
> +	USE(value);
> +	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
> +}
> +
> +/* Test case: ensure that use-after-free reporting works for alloc_pages. */
> +static void test_uaf_high_order_pages(struct kunit *test)
> +{
> +	EXPECTATION_USE_AFTER_FREE(expect);
> +	const int order = 1;
> +	volatile char value;
> +	struct page *page;
> +	volatile char *var;
> +
> +	kunit_info(test,
> +		   "use-after-free on a freed high-order page (UMR report)\n");
> +
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	var = page_address(page) + PAGE_SIZE;
> +	__free_pages(page, order);
> +
> +	/* Copy the invalid value before checking it. */
> +	value = var[3];
> +	USE(value);
> +	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
> +}

test_uaf_pages() and test_uaf_high_order_pages() are the same except for the
value of order. Does it make sense to create a single parameterized helper that
gets called from the 2 tests wrappers?

Functionally looks correct though, so either way, feel free to add:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> +
>  /*
>   * Test case: ensure that uninitialized values are propagated through per-CPU
>   * memory.
> @@ -683,6 +727,8 @@ static struct kunit_case kmsan_test_cases[] = {
>  	KUNIT_CASE(test_init_kmsan_vmap_vunmap),
>  	KUNIT_CASE(test_init_vmalloc),
>  	KUNIT_CASE(test_uaf),
> +	KUNIT_CASE(test_uaf_pages),
> +	KUNIT_CASE(test_uaf_high_order_pages),
>  	KUNIT_CASE(test_percpu_propagate),
>  	KUNIT_CASE(test_printk),
>  	KUNIT_CASE(test_init_memcpy),


