Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A6A8CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7650A6B0007; Thu, 20 Nov 2025 00:40:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7159A6B002B; Thu, 20 Nov 2025 00:40:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C046B002C; Thu, 20 Nov 2025 00:40:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 538A26B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:40:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CBF48905F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:54 +0000 (UTC)
X-FDA: 84129886428.27.1A6F738
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01892180008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYdhT5dU;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763617252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij3CZTiXFrpU/rmr2/hRZVBLGTLP5tsrztxvPsm3IUM=;
	b=oHb+kKuIeHAc4a8i9fvf8NKYK/+LbQjHdS1L9HODdRxe3GlEv3kp4KdnTQHDP1HwoENhrv
	h/kcvE4rVJ0j6whqQJaQQ7QjHkWkrSAGNY9xUXJUO5NeFFBp+upTREnp39AoaeDkhQvJsQ
	Un35NajY4MQjJYKUsl0fwbcE99uJfPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763617252; a=rsa-sha256;
	cv=none;
	b=3vXQ7NbGVSWnqlKlF+lkaNvNfSQBRzpuDdEXowSws59nOc20Y7A8W1FxFnVCCaAtt6Egvl
	nTj+BZ72ta1edEjpqfHqaw3Qbn0+hRRjJ3nPInilt5/XTqlb5vEGS5ohHGOY7Wa6b1d+OK
	0WcWIw5OC4p/QFNeAovOg4/ZXj3KZKs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYdhT5dU;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5ad2b75f-748a-4e93-8d11-63295bda0cbf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763617249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ij3CZTiXFrpU/rmr2/hRZVBLGTLP5tsrztxvPsm3IUM=;
	b=sYdhT5dU3FtwgTHC76n+k9PosD+C5XAY0ZmggWmW7CL9+DmYwksSch3iIvZ/go5zudOmyE
	6b70vhIA2aOFm/CP3jMFG4xNhLKrwRvbcJfOCIxi1clOauRoJlMyM+UT6wm9hkc5nZhIuK
	D1adzO2n/rYet5pAyLAcoq8mTPdkBvY=
Date: Thu, 20 Nov 2025 13:40:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
Content-Language: en-US
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: shuah@kernel.org, mkoutny@suse.com, linux-mm@kvack.org,
 muchun.song@linux.dev, linux-kselftest@vger.kernel.org,
 shakeel.butt@linux.dev, linux-kernel@vger.kernel.org, tj@kernel.org,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev
References: <20251120031619.1828911-1-zhangguopeng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251120031619.1828911-1-zhangguopeng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tbz7bakgzg4uswbzex5jkxfyhey96dmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 01892180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763617251-107015
X-HE-Meta: U2FsdGVkX18kZquGjoPgS/+0wRZnqwNv+IqrHfkIjaO+/jKADNM9rBPxr3iigVd2ueH1KQnOZP/sj7LYPK7Zw1bFsYfzKq64tdgL5EWtu1FL54bLDjcUMeMT45Zrf8mLQGpQQoYXCPYq2UtrS9aT9pfwnPgk34LOY7DrmekFHqddIbmm430nhHlEfQCcGLFfxtl9icn0/1VWcaNXCAxFKigL/+x7QBk64pzOAScu+/PwoGtct989DrMZKJUocqSvPIErvDTn6EyDDqAXoSoP9sp3MhEULxaShkphDL2dvIwgnyArvV/QLZC66qgNxRNKrx6HdY+e2zqbdRvuzoVAZkmXyahw6JEjLTMzOogbWa3SMWVSL1CwV2NQx8+NOe1RycZnWl2iP2KGPkvuNBxvRyRXMy4MPWDu+q93mLRkMOZWCVnKrprd1MQtMKhtnDwUntX2lD7LMEaScL2aqS6Br+rG5W8Fdqof7VHVDawxvLloIUaJPWSQWyXPWGvqwwHoHGPmI+HWmGpybLZ2qHKfiNZWJhLZcduhIg3PBe0pVG99VyGhZEAejEosUN2bm5vm8o8k96vB9l0TQkcDfUqHknZqQqI7ugaXbpSaHKfq4ZxvAJTJVFml97bFhSDC1uBdW6VjRgsN8QaGkMBvMgGW2uoe26u0QRXIyDjC3r/Pc0rml4G9Omew8Q+JHQCSD6FZ3WMHdf2pY167w0UhQlKZdhVtiTbnVyRJMaOa+YUwYe2frQ61i7kkEqcnkcgO1vIH229Cb3pZj08fQBfuZYmSU6T8GSP6ioKHJK5Qr1PdhSX07CVa9Fr2VEeYIDk2k8dFdhGQgGPuqui8hrdh658q0K+V8YXBRaxyyFQxvbSrt5TkjIo8ROlenDNQcKXBi1QMnAmIJog4s7ulcWa947tzcK45glAGbpYd7ef9bqCwCBABcbcwTu2l5dyozFaDru3QECh637Mo0wHrBlhTGds
 AR1v53A8
 xjhiT7hgrDAgrZFQjgW6+g9L9dbRL0vRuAvodyAU6aWTR0WZqCe0iyOgTZVuwjkYEpgJyTyZNailoBqoZ5hylFCZNczg8LpVXqlWjo511Ew4ZcylslUvOJEXGtK3/1x2ZCeqOvwLqo8tRpF+bI3JdxiDble45IA7dBgqrZTwT4PZHmVz2WWlLDLzWb/V8aUoINWiLeUTXzmCnuFdUaIXo6n6aRoCytSrXVPKYsfhvz+9PVTc4f58jjjEJ4qvoTQ9sbfoE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/20 11:16, Guopeng Zhang wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
> 
>    - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>    - memcg statistics are updated asynchronously via the rstat flushing
>      worker, so the "sock " value in memory.stat can stay non-zero for a
>      short period of time even after all socket memory has been uncharged.
> 
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
> 
> Make the test more robust by polling memory.stat for the "sock "
> counter and allowing it some time to drop to zero instead of checking
> it only once. The timeout is set to 3 seconds to cover the periodic
> rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
> scheduling slack. If the counter does not become zero within the
> timeout, the test still fails as before.
> 
> On my test system, running test_memcontrol 50 times produced:
> 
>    - Before this patch:  6/50 runs passed.
>    - After this patch:  50/50 runs passed.
> 
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> v2:
>   - Mention the periodic rstat flush interval (FLUSH_TIME = 2*HZ) in
>     the comment and clarify the rationale for the 3s timeout.
>   - Replace the hard-coded retry count and wait interval with macros
>     to avoid magic numbers and make the 3s timeout calculation explicit.
> ---
>   .../selftests/cgroup/test_memcontrol.c        | 30 ++++++++++++++++++-
>   1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 4e1647568c5b..7bea656658a2 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -24,6 +24,9 @@
>   static bool has_localevents;
>   static bool has_recursiveprot;
>   
> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */
> +#define MEMCG_SOCKSTAT_WAIT_INTERVAL_US    (100 * 1000)    /* 100 ms */

Nit: Defines are usually placed at the top of the file (e.g., after the
#include block). Placing them between global variables and functions
looks a bit out of place, IMHO ...
Otherwise, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>
[...]

Cheers,
Lance

