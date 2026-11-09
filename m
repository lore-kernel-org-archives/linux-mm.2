Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297CE606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PFk7jMUM
Received: by kanga.kvack.org (Postfix)
	id 4A3FA6B05B5; Sun,  8 Nov 2026 20:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4557F6B05B7; Sun,  8 Nov 2026 20:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AE06B05B8; Sun,  8 Nov 2026 20:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6D96B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:50:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9276140528
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:50:53 +0000 (UTC)
X-FDA: 85413901986.27.D27780F
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8AA311A0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:50:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PFk7jMUM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794189052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7Bnt0oaHObCRAYHP9jDNv4qbPY14ASkahF3dtA4y2s=;
	b=n/DgqeFggfrWbIgIhiP2S41bBJYyM/3UwelqLCZpWYNywslePfbFjq2ya+/TMXElT7rmPm
	NiIwF/lFDYZMDO9k+HD6IAm9pfK/eyj2NOqC/lnFGtBjbedl2yTM5aw9LpTITtE30gHV80
	S84mnz71EsgJqZU74SMzL/IAlGDoO6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794189052;
	b=jZgZnE6fWKY89/ybFT2fOr5Dk5FTUcLZwnxiNfSXggHmVhCJjw3m660dxOxDjLsvsh7pqQ
	Xh4E6uI7vpPPS1+ftsWO3KCIqQ7r7vMfSA9zVhqaAOGAc22VbvMksZgCs3abIYcHiANuA9
	9y6cMWZhHuP95QqVRA+weY8mfgw08sY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PFk7jMUM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V8t2DsGsOlEEZeIAghkdXZSawCAIBraQf2pr/ZV9ZYE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794189050; v=1; x=1794793850;
 b=PFk7jMUMChfz9psSEwtr0OYbxIi9BbBbddxigtvq7g7LihnCOYef+y/9EwqQoQz3EbSKH+QB
 hive4t5oKHrdSFuFeVI4elLql9AeINrfw/RYJd6sb8nad3FMw8Nh6pt6tEydxxQYma+r6z9b4cU
 2Nj2WjvZcoOjMDREb8OmFKD0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab26c670e0a08f52;
	Mon, 09 Nov 2026 01:50:49 +0000
X-Mizu-Trace-ID: ab26c670e0a08f52
X-Migadu-Flow: FLOW_OUT
Message-ID: <04d2e2ba-e6d3-486e-bf38-7d6b1902eeb1@linux.dev>
Date: Mon, 9 Nov 2026 09:50:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: pkeys: wait for the child in become_child()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@linux.intel.com, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 hongfu.li@linux.dev
References: <20261106164639.2959195-1-clopez@suse.de>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20261106164639.2959195-1-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 81iobhdxzx174bjtw5dr5mbpbmemujeb
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8AA311A0002
X-HE-Tag: 1794189051-847312
X-HE-Meta: U2FsdGVkX18ddCUCkxpXRH/YicdMbl0GvMGw9xdElOH56GYiBI6Lhuhpr12DjqOXp7bj0jtuBou5iYXYu7rKos/Q2qfT3xCLRgnF3WrQBIFXVXEcKNxfB3vm9a+L6esKkYSiB7jvSrVmVKch7qCWHRRvu3w1Picyvo1iBFglVhSuP+UeWxWF4VG4qFx/4g58Bq/NFIWEQl6Tz8W04dGQoQE9kNuMVuyYQIqw0HnECYaZfowjTi2EDdWHPklSMmU8xCZK7Tn+bd+BumBaPI6+jnnn+DHUq8i/1nNN90IKpUNKm/cUquLmX7yeD0X3SqJf2qfAdjh3vvdbZDUYeW8ZftLrpyfq2aG0J7bl1MyKdH7QAxaU8rtmmSDivCHeanQwFIsLojwlIyq5bXGicPRtVNjffxgFrWFJFYQ4b6ne4B/LGsl2iLwUZDb1JPfaLpNz9L7BMMtXLtlNJZ9+jGD9Xh5FX48IGH1DwUMyPuMRHQTJpBi4RuoGS9fHeHHUnTDGMTkZb1ngS7HNF4mI2x2Ds3vaRBzJNRisuPTq7cnVjBCXLDhbIZNSTaye7QjyA8Ac5f4eUIijc7VaVmw2fIjmhqaC5O7Lf73w/e1MzxyBwsW+axffkswtPOSWZ9T6zvH5W6aiUsaboSXBs8RN9THMvLppFoeNITP4N21sNv8XdCf0otBPYNYSP5uaZl8uGjjDmVt33ay0b2XzFayEY0EobZPHZLU4tc6M3LbGdKBO4XygY4GMpKJQxbFieXj6GAUteiNIn7fmNzfIAqh22aXz2cqjnd9uKnT4zmTgVR0u74PLTV4K/+NX0VXlWKVXCG5tMWCB2trV4g8x2dYzWtwoWQXPzPjSizL6P/ujx7WSRC245/RtMyn9TcvgXx7l6VeEUOFH2w5A/3SU7hS0EGt0c4zAZJNpsCghJQtrhOCx7C9/xwhZwE19GQyqKgdArKZll9RuKzlAzpt94iYb+SK
 IH3ujkon
 dgdmUGsBznaZFDUq1/500L7BNU/DxdqJt/alupQanN5F8ui0N4XAX4y81M1pd+oyqoBQof5ArxaUpX0aQKgtaASlQ7me3Lm3M/jXX0n89yUpez++rt1r1XcOIAmGMcXf2d0ghYd70yTfJCFaeJCpY2o0ksG9X5nPHvhfmYq+JRX22YTmwIwb+lHY6ATjyFICqWtdXHu6PDeD78lBTeNm+Dq10lbbC13oInC27TuwLeVKgTmzTPHwtOV+HvHK6qiSfR2pdkhP80dAaXz/xyGSkyQxrBXy6XYCAJz+LuaQXEPkS+3yHshvc5rYl10mzA0TH+M9srVoYCWzyupn5iHnhIxTYbTLtw4Z+3VxYb9qp/wN/Hm+ziJgzU5TRNrBr2mJ+B87lNoyf1psGyNK/9Uwoe+Y7zatpVaaBg/fa6e08PWd5r5AyTF08onfbkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/7/26 00:46, Carlos López 写道:
> become_child() forks during test_pkey_alloc_exhaust() and has the parent
> exit, so that the remaining tests run in the child. However, the test
> runner only waits for the original process, so it sees the test finish
> early with a success status while the remaining tests keep running in
> the background. Failures after the first fork are thus not reported in
> the exit status, and the remaining tests overlap with the next selftest.
>
> Fix this by waiting for the child in the parent and exiting with its
> status. A previous fix avoided waiting, arguing that the parents would
> keep holding their resources [1]. Particularly, the parent keeps the
> hugetlb reservation of its test memory, so the child runs out of hugetlb
> pages after a few iterations. Avoid this by freeing the test memory
> before waiting.
>
> Link: https://lore.kernel.org/all/20240419115027.3848958-1-usama.anjum@collabora.com [1]
> Fixes: e1812933b17b ("x86/selftests/pkeys: Fork() to check for state being preserved")
> Signed-off-by: Carlos López <clopez@suse.de>

Hi Carlos,

This is a great catch, thank you for working on the fix.

I reproduced it locally: without the patch, a failure after become_child()
is not reflected in the result and the runner still prints
"ok 1 protection_keys_64"; with your patch the same failure is reported as
"not ok 1 protection_keys_64 # exit=1". So the fix works as described.

Tested-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>

> ---
>   tools/testing/selftests/mm/protection_keys.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index b7882ab97683..5dece144ab95 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -1009,9 +1009,10 @@ static void test_pkey_syscalls_bad_args(int *ptr, u16 pkey)
>   	pkey_assert(err);
>   }
>   
> -static void become_child(void)
> +static void become_child(int *ptr)
>   {
>   	pid_t forkret;
> +	int status;
>   
>   	forkret = fork();
>   	pkey_assert(forkret >= 0);
> @@ -1021,7 +1022,16 @@ static void become_child(void)
>   		/* in the child */
>   		return;
>   	}
> -	_exit(0);
> +
> +	/*
> +	 * Wait for the child to finish the tests and pass on its result.
> +	 * Free the test memory first, as it may reserve pages from the
> +	 * small hugetlb pool that the child needs.
> +	 */
> +	free_pkey_malloc(ptr);
> +	if (waitpid(forkret, &status, 0) != forkret || !WIFEXITED(status))
> +		_exit(KSFT_FAIL);
> +	_exit(WEXITSTATUS(status));
>   }
>   
>   /* Assumes that all pkeys other than 'pkey' are unallocated */
> @@ -1060,7 +1070,7 @@ static void test_pkey_alloc_exhaust(int *ptr, u16 pkey)
>   		 * preserved across fork().
>   		 */
>   		if (i == NR_PKEYS*2)
> -			become_child();
> +			become_child(ptr);
>   	}
>   
>   	dprintf3("%s()::%d\n", __func__, __LINE__);
>
> base-commit: 843c58022865a7b0f9743416c2b48bc2632da23c

-- 
Best regards,
Hongfu


