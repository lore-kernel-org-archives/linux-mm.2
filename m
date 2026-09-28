Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83899C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3CB6B008A; Mon, 28 Sep 2026 04:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854816B0092; Mon, 28 Sep 2026 04:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744046B00A0; Mon, 28 Sep 2026 04:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 543856B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:53:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43D7D8014C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:23 +0000 (UTC)
X-FDA: 85262557086.03.A695537
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 771DE140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrFYJfwf;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PVeGOJnaKCpJJY0+kbJzTfUxuIOeJRjTWg+Uf9bzrY=;
	b=xGdFp3EuljQVzu6++7nWlLGLpHiGZvRhsX/hngf5/sw8ii9M6+vLtrEXWpsroUGca2HqDT
	LGh0c5kHuPfKcERQuZM2eE3dGhwcN1oRwZHqIbqIWbNDjU2Ddr1ei22E8wfUhkorsfdwB9
	w7MedvNsP+zJuzIJGWlJ7WGwRjh6Ezw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrFYJfwf;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585601;
	b=N3BYsjttkDr25kO1JABzqGkvkwV3Zw6xDJrVKzWOh1VPerFytRKhE2oAGjPKGvJIsvL+RZ
	r58hKCq2u2D+jvNscAaOgxZm+maLB1vx5R7MEzd4ywJV4DRyPvw7h3clMIvKjRRfYHMiT4
	N1BSdCiD8BJ/vABhLLR3X0kvaylXKvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EFAD43BE2;
	Mon, 28 Sep 2026 08:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110201F00893;
	Mon, 28 Sep 2026 08:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585600;
	bh=5PVeGOJnaKCpJJY0+kbJzTfUxuIOeJRjTWg+Uf9bzrY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hrFYJfwfCcGmTGKwfH4kA1bByopbzivdG95gwg9QPSMCGENY3BYLnIJuz03bHzn1m
	 Auytg8u9pwWvX2XtvlywvDnrVK9KT2YmJWuYTRSbLMbIj+BWVo2ucIYvOYthdKZo94
	 pvMD3pulkrFS7Hx+dQ29+b9K424ZJRXVXUIdZELDA+71CmEW2mr3AlD8jxMhNjScX8
	 zoQBOjv3qbDWZPo0Fo8+qslY0f1ixzEYJj3rMOf4XlhTW8tyVOiwxfJmzpuI1Xq/xL
	 hxqF2tmWBUKuwUZOBJuOxhfybAj4egnRehaLH8BOnjgHTWhDupwm49rZ/RDiMOUB0N
	 YeqNkMD711OUw==
Message-ID: <4e4223f4-dfec-4e82-97fe-25ae3a3b0f73@kernel.org>
Date: Mon, 28 Sep 2026 10:53:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: add tests for UFFDIO_MOVE of a
 uffd-protected swap entry
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org,
 rppt@kernel.org
Cc: peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
 shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
 <20260926124145.2878520-3-donggeunyoo.kernel@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926124145.2878520-3-donggeunyoo.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f5knczib54ynoznwtbgzp58naurgs3zf
X-Rspamd-Queue-Id: 771DE140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790585601-206369
X-HE-Meta: U2FsdGVkX1+lowH2dVUTANJX4VHpMAbOWbZHfny7dmCen1dI+giV4s84drE9juEdv5YOTTRhVj3CF3dtwJI+L3RuGwdt0lVJlTDwhOwRVxOCG23KdbHFN2mfrSABT8KHuWiorgn8l3fB6tQ3K10u93NGGOj7LKzhej/gOwNma+TUIlubhArWlLneNDWgzOyuS5UrQ+doiFBlheWnKxhdBYAhlah2iUTlNlXT/bf1JDORtpxZlwAu17tVUr2hSxa7q972eqPv7BX9z1vkfCtdJzOmAyoCubYFXBTXVP1yGUmzOsFbXeAJxRc13hsKCTom4/x93xchQVg9CH9YMVNfLWX3Y9f498Euc3JlBFKz2zSAP3zYnPCyYqsdcvqHWIZv66ijfag6IkMxbr95inElD0p4Ynb1xElDcLUfxJsRKkWlkakN1baxqt+Zc3AqQkQoZSX46fPKS4ojkXAAiyOD/hnzsaodrB6zgmOIRM/NWsACYQt97IuCdLEYHOonS1K+Kd0+1cRzQRINMwbQK455ZYkqilbv/fS2ynRE+Q8xPapgEhqBJWGTxyLUwvozmu5MU/0bK2MmFtwjvk+eYbNjl99Sgvtg20+L8i44D2ezqk8rbofKRknLDBQ3vvEeyBVIw9A2RUiMaDffi65X+t4Kf55FS9eXmKszfOS6pwcZHYuQPVBkAkP4ZdIIbeynbTP/oTZ6Bp+KC1UQUfh8nu9B2l/r0ViK1fpNTpVlFS5CWsP1iX0mwdzzWjs3cjeDAV4i8Ycn/d1GTyRaE7vGFxjJR+TNRiXSkZ3W4YSEqmJiTiVi/lvvwnDo/wWiI8IMNEW035sSfTa2ZksDqfId9ZQC9fgEU4rztxHhX+PLPF9StuNv9LHpXYvRvmJySmrYnB2XV+2CWflwH2Fqwq2xg7tXb47URcRXmnZZNns3Ztf8jfGb3f6xbNo5u0ZIQ4HVncKdx2Jcev3WxMh/QMzi6Mh
 q7oD3aBB
 6aKzPYfn3pEglh/l8AOr92D6fh8c7u80h1casguOAJD3CeICmlcQtMuOlLJFW+mUGvBXYqjP1A7+ARO5E7IT+DgpLBTQ9sYMICMDJvyE08eGfjCSK5OkUDUB3Buh2xkhwBkctRW/CVhck/W3mnvNTI0EYTsAe4bbwLtbTnDxfK4xa7PwfS9VwtulmWn4THQT1fp+x4CNpfTuBnbxeZ6eKoTBDOcGLVpDUh9xmiRsOZPp+oM6nFfCM9Z12wy23P4Mu6Xajf1wL+VlEvUMDT53yNBtnevtpfSVV7xxy40U0IzIATMkderRM2HUWQkk+FqYq94dznUfgJePnqSh+JO68/2DaTmotdvrPAHTDyBAqTq5GIdqCrJgZg1ikBslgx1tmN+HRcJ6nOQ4dzjDM9FNBB6oB98JBj3bPnlt4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 14:41, Donggeun Yoo wrote:
> Move a swapped-out page out of a write-protected or RWP-protected area into
> a destination registered for missing faults only, and read pagemap bit 57
> at the destination.  The destination was never protected, so the bit must
> be clear.
> 
> Assisted-by: LLM
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
>  1 file changed, 84 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index ef9b3956bdcfd..580178630eded 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -2037,6 +2037,75 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
>  			      uffd_move_pmd_handle_fault);
>  }
>  
> +/*
> + * Moving a swapped-out page out of a write-protected or RWP-protected area
> + * must not carry the uffd bit into a destination registered for missing
> + * faults only: such a bit is never cleared afterwards, so pagemap keeps
> + * reporting the page as uffd-tracked.
> + *
> + * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
> + */
> +static void uffd_move_swap_test_common(uffd_global_test_opts_t *gopts,
> +				       bool rwp)
> +{
> +	unsigned long page_size = gopts->page_size;
> +	struct uffdio_move move = { };
> +	int pagemap_fd;
> +
> +	if (rwp) {
> +		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
> +			err("register src failure");
> +	} else if (uffd_register(gopts->uffd, gopts->area_src, page_size,
> +				 false, true, false)) {
> +		err("register src failure");
> +	}

if ()

> +	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
> +			  true, false, false))
> +		err("register dst failure");
> +
> +	if (rwp)
> +		rwprotect_range(gopts->uffd, (unsigned long)gopts->area_src,
> +				page_size, true);
> +	else
> +		wp_range(gopts->uffd, (unsigned long)gopts->area_src,
> +			 page_size, true);
> +
> +	pagemap_fd = pagemap_open();
> +	if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
> +		err("MADV_PAGEOUT");
> +	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
> +		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
> +		goto out;
> +	}
> +
> +	move.dst = (unsigned long)gopts->area_dst;
> +	move.src = (unsigned long)gopts->area_src;
> +	move.len = page_size;
> +	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
> +		err("UFFDIO_MOVE");
> +
> +	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
> +		uffd_test_fail("uffd bit moved into an area registered for missing faults only");
> +	else
> +		uffd_test_pass();
> +out:
> +	close(pagemap_fd);
> +	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
> +	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
> +}
> +
> +static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
> +				   uffd_test_args_t *targs)
> +{
> +	uffd_move_swap_test_common(gopts, false);
> +}
> +
> +static void uffd_move_swap_rwp_test(uffd_global_test_opts_t *gopts,
> +				    uffd_test_args_t *targs)
> +{
> +	uffd_move_swap_test_common(gopts, true);
> +}
> +
>  static bool
>  uffdio_verify_results(const char *name, int ret, int error, long result)
>  {
> @@ -2359,6 +2428,21 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required = UFFD_FEATURE_MOVE,
>  		.test_case_ops = &uffd_move_test_pmd_case_ops,
>  	},
> +	{
> +		.name = "move-swap-wp",
> +		.uffd_fn = uffd_move_swap_wp_test,
> +		.mem_targets = MEM_ANON,
> +		.uffd_feature_required = UFFD_FEATURE_MOVE |
> +		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
> +		.test_case_ops = &uffd_move_test_case_ops,
> +	},
> +	{
> +		.name = "move-swap-rwp",
> +		.uffd_fn = uffd_move_swap_rwp_test,
> +		.mem_targets = MEM_ANON,
> +		.uffd_feature_required = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP,
> +		.test_case_ops = &uffd_move_test_case_ops,
> +	},
>  	{
>  		.name = "wp-fork",
>  		.uffd_fn = uffd_wp_fork_test,


-- 
Cheers,

David

