Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C2EED3942E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BEE6B0089; Thu,  2 Apr 2026 10:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822E66B008A; Thu,  2 Apr 2026 10:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760E76B008C; Thu,  2 Apr 2026 10:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6472C6B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:37:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C91FBE0654
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:37:05 +0000 (UTC)
X-FDA: 84613868010.03.14A88B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21C2A140016
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:37:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvIXmouu;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775140624; a=rsa-sha256;
	cv=none;
	b=Zix4MSrKfTgo9IJe2Vjog77iacpBP7emyIm97Tx0XZ41advEmRYinxQzW+ims40joZhkoS
	CYpETjnnqjhe853Zi6JXbrqPq7t9ygs2tYApyOUUBxKuSnUswVtE/uetBSEjV0FSxhVWB9
	wH+B+3YAKc83AXoRtGljsCFRoZ+kReg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775140624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ILl4bqajhS14oy6HYJBLuNTLSLK+BgIsTmfiBH/noI=;
	b=W4WJB9hxFyFEj+4kSCTGnEQz4qvZVR1K3ZcGpHPZxBQbL46ZFe8yk62VqFQBXtejk+OkAQ
	LkmyHUEjseSqLrUcim1DX2i0PpQa+ex4nGMuop+EwRvPc2B4SOUvKo3f3DlqQ8e58MPaO0
	SCqDZY/MJ7ZBF4G76NRIhMGF3cKWGvw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvIXmouu;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83D1B60121;
	Thu,  2 Apr 2026 14:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3F1C116C6;
	Thu,  2 Apr 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775140623;
	bh=QiaYc6bmCawV6VUIowBRoKVqPAmV1+wQMNXQSnjt2ok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RvIXmouuVV9SqPjGgkGaI1+M8nGHGje1mOdW96Ke2al7DYx06XmM7fv+qUvJIcwts
	 5DKaFpDJyLkIn+VfwKl/qNFW/V0v3nFb/6Qs8i0S6bF2X3h91n+s+XiARDqfZsob1m
	 +3OYn+rS2zZjr5eQmrzpRQ1ABk1pEWz2MVZVhFN3mGghdlEVF6+QRwxou0k2AqPOkL
	 7WNGKHd2Q+pTnGkgIr12TpoIjM/qZdfUdzACaz+T/Ng8+Ve9iHbCYUuQwUTCZD++CD
	 oJRT20eYUr3HLV4yxi52RQw7nNMLsVdo2dFAzHEvMxI5tGQFqriYwGAkqqAwbiOcyk
	 ixOyF7fojCEwA==
Message-ID: <26e81ffe-08ad-4c3f-a360-d45c3cb32ee2@kernel.org>
Date: Thu, 2 Apr 2026 16:36:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/2] lib/tests/slub_kunit: add a test case for
 {kmalloc,kfree}_nolock
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Alexei Starovoitov <ast@kernel.org>
References: <20260330120517.104743-1-harry@kernel.org>
 <20260330120517.104743-3-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260330120517.104743-3-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21C2A140016
X-Stat-Signature: 556s1ndmkgofwk3wzhbjkf8iwamb6s3k
X-HE-Tag: 1775140623-509316
X-HE-Meta: U2FsdGVkX1+KVjwtelxXS51ifJ1EtaX9n8vCA1vXsnTbK87H82XdxpFf3ozTcbtKckCkRGeUICNDCN+cFMZwVDoPc8qYaIhHLRzS2DXX0k/r2w8ZbsLLpYeiierI1RN6IUBQSGBO9R68BIVTn3o6h014EtQ8Ck3d9L+JNC7vUSzva6N9A2uO4JoBekfoiCFQsWDTo3OGaTgZE9HIKwXeGIvdtqQVSov829/qN/3ZgSqzKC5oRjugL0EVktIGE2CUYXmidmEh4jH3aS1sf2mdosK/013ZOmPk2G8vymIOpfsEdhH2eD4zAtRqb3XPi7CCzYeG4ACf/MFJvvEZRx7vlJae/YsvO27djaFRwVldY69QXUYlazoaQkK/LwM3W79Z5lPN2dDtbghHREAgriobN6qh5Wfl/RAafOmrMybPrCGBq/dAxp4ZyWakEFDtctEP1FKNZRtFotATZ7zAKXqK+/ohe15dtgi3oz0RPcmcXo65ozrSJqwH4jGCSy7S7DTnzbUYs7BqTV8SmAVhcMyyQUzrN4wGwI7tkMgLpIOUl/2boDmXLd4ULTYmiItuR3nXGm8GoU039wLdXftokC6BBoVTtPitRICXuEp520yecuXkaW2q9GvOFe6Eyv6epZpd5GJpYY9T68/jSo4CUxdTi8inRXOlF/RLn75NyhUT3cc4lAlmWbzvsn9bgqILuWv7sCWiiTTCl4aF8b5NY8SN5vdlrQ8jsTkVKzAQNFEgbqeo20blk5AreJHuWMJjLOQPu/Li6E0WrvNw/ji6410UrGTjzk8QBDI1GMLPrH2byT7Hrx5N0F1R/9cC1kUvQv5BvsRfdaBn45gtRnj+z/y9rJt8TDW9cfpi+VZHz1Lu/FNpwXOmirLz9s9foZvHr+6Qb7IHVXtw8s96m3jLtKxTJMUjTHlDovunvNZEn13TCkZsK0Hf1M6JhxhmZfZR54Uz84kz8VAq/GW1vF+QfCv
 xCJ5wbyg
 cqPuw70wIqDxxhWzJnCcVaTprBZFsCSufJl3gkWjA2adr0fnWb5q3A0D0me8XavYZ4a3STUNETMOcL3au3Gyhw0/Er3TphsnFFnMxY0gyLinVfOM/5Gv1hqgh9WKee7WGuzKhAXxZbKfMJOIcAOtryCY34e6f1Z8qpvYxmKd7fB2I+Ardhw/dTJR3wIo/p8PVSxeOfWXaAp9ehUmpG1jnJiAKe7mJP2jWJmw1wNA9awKic2Xtcj9kd2Cl5Bq314pfnkUtB3gq47k2u0DOo1sCUeZr8aYGszfmYV9s7PBaX+EZqu/KbORMf6yD+gXbB9Rjglg45kFnuzzmG8hDwsBV0Xxq6TY145Q1kmEOPcUA/SF1fMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 2:05 PM, Harry Yoo (Oracle) wrote:
> Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
> kfree() is tricky, and it is even harder to ensure that slowpaths are
> properly tested. Lack of such testing has led to late discovery of
> the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
> !allow_spin").
> 
> Add a slub_kunit test that allocates and frees objects in a tight loop
> while a perf event triggers NMIs on the same task, invoking
> {kmalloc,kfree}_nolock() from the NMI handler.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

perf_event_create_kernel_counter() seems to only exist with
CONFIG_PERF_EVENTS, there's not even some "return -EINVAL" skeleton
otherwise, AFAICS. Didn't check the various other definitions, but guess
we'll need to put some/all of this behind #ifdef's then?

> ---
>  lib/tests/slub_kunit.c | 88 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 848b682a2d70..2ed5f90a748a 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/rcupdate.h>
>  #include <linux/delay.h>
> +#include <linux/perf_event.h>
>  #include "../mm/slab.h"
>  
>  static struct kunit_resource resource;
> @@ -291,6 +292,92 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
>  	kmem_cache_destroy(s);
>  }
>  
> +#define REPEAT_TIMES 1000
> +#define LOOP_SIZE 1000
> +static void *objects[LOOP_SIZE];
> +
> +struct nmi_context {
> +	struct kunit *test;
> +	int callback_count;
> +	int alloc_ok;
> +	int alloc_fail;
> +	struct perf_event *event;
> +};
> +
> +static struct perf_event_attr nmi_hw_attr = {
> +	.type = PERF_TYPE_HARDWARE,
> +	.config = PERF_COUNT_HW_CPU_CYCLES,
> +	.size = sizeof(struct perf_event_attr),
> +	.pinned = 1,
> +	.disabled = 1,
> +	.freq = 1,
> +	.sample_freq = 100000,
> +};
> +
> +static void kmalloc_kfree_nolock_in_nmi(struct perf_event *event,
> +					struct perf_sample_data *data,
> +					struct pt_regs *regs)
> +{
> +	void *objp;
> +	gfp_t gfp;
> +	struct nmi_context *ctx = event->overflow_handler_context;
> +
> +	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
> +	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
> +	objp = kmalloc_nolock(64, gfp, NUMA_NO_NODE);
> +
> +	if (objp)
> +		ctx->alloc_ok++;
> +	else
> +		ctx->alloc_fail++;
> +
> +	kfree_nolock(objp);
> +	ctx->callback_count++;
> +}
> +
> +static void test_kmalloc_kfree_nolock(struct kunit *test)
> +{
> +	int i, j;
> +	struct nmi_context ctx = { .test = test };
> +	struct perf_event *event;
> +	bool alloc_fail = false;
> +
> +	event = perf_event_create_kernel_counter(&nmi_hw_attr, -1, current,
> +						 kmalloc_kfree_nolock_in_nmi,
> +						 &ctx);
> +	if (IS_ERR(event))
> +		kunit_skip(test, "Failed to create perf event");
> +	ctx.event = event;
> +	perf_event_enable(ctx.event);
> +	for (i = 0; i < REPEAT_TIMES; i++) {
> +		for (j = 0; j < LOOP_SIZE; j++) {
> +			gfp_t gfp = (i % 2) ? 0 : __GFP_ACCOUNT;
> +
> +			objects[j] = kmalloc(64, gfp);
> +			if (!objects[j]) {
> +				j--;
> +				while (j >= 0)
> +					kfree(objects[j--]);
> +				alloc_fail = true;
> +				goto cleanup;
> +			}
> +		}
> +		for (j = 0; j < LOOP_SIZE; j++)
> +			kfree(objects[j]);
> +	}
> +
> +cleanup:
> +	perf_event_disable(ctx.event);
> +	perf_event_release_kernel(ctx.event);
> +
> +	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
> +		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
> +
> +	if (alloc_fail)
> +		kunit_skip(test, "Allocation failed");
> +	KUNIT_EXPECT_EQ(test, 0, slab_errors);
> +}
> +
>  static int test_init(struct kunit *test)
>  {
>  	slab_errors = 0;
> @@ -315,6 +402,7 @@ static struct kunit_case test_cases[] = {
>  	KUNIT_CASE(test_kfree_rcu_wq_destroy),
>  	KUNIT_CASE(test_leak_destroy),
>  	KUNIT_CASE(test_krealloc_redzone_zeroing),
> +	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
>  	{}
>  };
>  


