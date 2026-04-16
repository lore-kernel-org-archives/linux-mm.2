Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121DDF8D753
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EAE6B0089; Thu, 16 Apr 2026 10:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6762A6B008A; Thu, 16 Apr 2026 10:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3276B008C; Thu, 16 Apr 2026 10:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0C56B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:36:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 137271408D5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:36:23 +0000 (UTC)
X-FDA: 84664669446.09.8B13D09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67C741C0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:36:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBHAOBHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776350181; a=rsa-sha256;
	cv=none;
	b=z25X0Vs2H0bW4h1kytTSx8VjjAhH1JDtiIQ8ZHhfYMxBimDSQ+LeUgr+2oXQquUj4Cno6G
	P3bb+1twznLXSyTlZaDSE5jz6gnZ0HJBYq0b+/q0mOxu6frSnbe6l/ErGfrMAcs9wFMCkM
	YormRX46mP2T4Z98sajkaYPwyXUykls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iBHAOBHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776350181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih0Mhi0bAF/GjR1+besJ9yWBbKP/xg2JqaKUCF83KBQ=;
	b=HEpQ9vm9UVui0pTssaaE/AHapVcQNnR+5Hk7104nx6ppn1EBjK18UE/RL7lgcLPW622Lq+
	UqOKJECBp1UDhCR9mpe+BU0wo3OYiqQOCTDMvh0i4QSdGOFGGsZ0Nrdpx5b6R3HN5Tg+XP
	USWAvIKVooxZyTu98iyQuopREIn3kiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9726360126;
	Thu, 16 Apr 2026 14:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CA1C2BCAF;
	Thu, 16 Apr 2026 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776350180;
	bh=cF843hrr7++jdAx9OfSd4v0QFV2gBhvyqy2esA/Oxxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBHAOBHT1Knbjw9FqrwXzdHA1Ts5TiYLxZZltma9lFM36pYchlxMcO/g5CHi9zd3h
	 M5r6+rDGnIx8ss9vC+YX0IN+z5FPHjEMc2d9bHFGxrMnZegou2YJFgajjl9yn0LexB
	 iffAiLA1JF2UtsoNBB67W2zM/sGhHIj/S4NkTDretJ4ECOnSyO6ptNbSFaJh15zC6m
	 iAENOGCuYxEfJRoCT3h9jwcWcaTDLngvAsvmENX2faRZvSiibT86s/PdBfPh35iBLG
	 d+XTy9I6Vz3i0F/MCfTn1NVEmidBmMgXh7fw2pLcq3x5tNP6ofxxNtj/HrvOp0LonP
	 y/QkeW0rW7mGg==
Date: Thu, 16 Apr 2026 17:36:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aeDz3UAB54v2K8Hz@kernel.org>
References: <20260416102558.575210-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416102558.575210-1-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: 67C741C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: psryppxz8o638p3pz4wyx5puwf3wk7zt
X-Rspam-User: 
X-HE-Tag: 1776350181-356054
X-HE-Meta: U2FsdGVkX19BnHTvIKEsUz2jeMPLN6kTbzhoyfAL6NZoxCjYSzVH1qo3/fPWunCZHjY9fPqxCcrOUavawzlALM7kDQkGk7kfm0H+FwLHsasmkGWwIKnAA3z1tDMdrmw0nWgJwz4NxGjh4MjaTctHkY3mB/Q9BAhyAZFT47aVWi60kBjwPWg1/yUWlT/dcXUTXHKyYzTD3A/y//Ae82NntcsHw1GV6IeRs+qZjWg2DAblU2ZTlzXkxYtKD7vU2hStihupr+2eYTMRr9eEgXwSz6YNjwMiV+CDmk+gbrQTwz91GsQwgaixJHW3Ih/e4e70zM9Qo8XgP1R5FVKYw9K0xfIXkG/u5mcQekfEs4sFQ8OD0ceq0BNmkl/Ie/8/47eJl5cM4zJAKkTB1Jkr7kkr0LO/9TuiJfnKptT1/BbV1H7O7J0NBjZsO/ltme0uDviv5alpetkY98SW1dBSmd5gdIBScYHvjFIMfvPlbsh+4dRK9ChMaMcGcq2BGrl9i+lDEhNaUhvE+B/zsVZTMYcXRyNXZ1vIy4py73JP8VUK37qmrNmrJnutLIpIRgkOmmh4RNNj8Zh2yYC5Af6DvLtyHZ4o15Nm+ACICCVq8bwWf2DWpZ8E0aWG13CVso35LGZewSx8rxvHJAgOFaprcDSjoGqyxLeg/wApTgG6bykKcKgEx4LzjadC2/uDFfl1VeToDJw9/hWD4It52TIMGrSysnph8YAAuiHp3XNDMdRJ6B0j5iMhAZZUnckTOLkzguYJLn62IajGu1atI6YUeWuZ2gAeyUcdINxPUSZoY7GgjqKOgSZ4GqM0XqgUndCbgHzu7Nqv7fYsTRVw5igEct8Iv6hla+tFRKSk58GNSvUVJTNvaxIvZ9xFP2hC+gytJHpj3badyjCW/MZDKo8TJ+n6AVQ/1tAnaQjD6Uh0uk9xq/ZHhmfjI0aaAxu85gBgYNjX0lKEv3B9Ax3i8OaFR+2
 kqqmOloz
 x1TU6SKEvwfNEpiH9ZOD9mK40SuTnYlkWainc3S9FrLSBFPkmCJrMtM1B8XwQl2Zm/TN82Wm301VCTHLhxjUIqtnUkzGBG+QdfO2A9dfw0GUdfj43gcH3eoatlz06+fitJmzhhAv09Zhtn0UMrlG/sqefe6Wxm436d5aX13HLiTNtHzoMuwX57pxT+Kpmv3LzSi1FzNnohIJ1V3Mg+h+6M4vN6VKNtHAzzCHRAtMszcZo26jL9hMEImojq1+5j138B9JOAp5zLYif7FT7VvbCh29xTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
> 
> The existing under-allocation detection logic compares next absolute node
> ID (ret) and request count (n), which only works when nid starts at 0.
> 
> For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> fake node nid starts at 8, but only 4 fake nodes are created due to
> current FAKE_NODE_MIN_SIZE being 32MB, and
> split_nodes_size_interleave_uniform() returns 12. By existing
> under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> under-allocation will not be detected.
> 
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n).
> 
> Also, fix the outdated comment to match the actual return value.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
> ---
>  mm/numa_emulation.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..c1d0a76aef64 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
>   * Sets up fake nodes of `size' interleaved over physical nodes ranging from
>   * `addr' to `max_addr'.
>   *
> - * Returns zero on success or negative on error.
> + * Returns absolute node ID on success or negative on error.
>   */
>  static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
>  					      struct numa_meminfo *pi,
> @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  					n, &pi.blk[0], nid);
>  			if (ret < 0)
>  				break;
> -			if (ret < n) {
> +			if (ret - nid < n) {
>  				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
>  						__func__, i, ret, n);

The error message also should be updated, now it prints the last node ID
rather than number of created nodes. I think it's worse creating a
temporary variable for ret - nid to make the code clearer.

I'd also recommend running qemu without and with your patch and verifying
it works as intended.

>  				ret = -1;
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

