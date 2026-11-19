Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C686606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mZmgybaJ
Received: by kanga.kvack.org (Postfix)
	id 41EDB6B05D4; Thu, 19 Nov 2026 03:43:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4CA6B05D5; Thu, 19 Nov 2026 03:43:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330F46B05D6; Thu, 19 Nov 2026 03:43:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15AAA6B05D4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:43:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 861271408D3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:43:43 +0000 (UTC)
X-FDA: 85451230326.15.F93F73C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9087C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:43:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mZmgybaJ;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795077822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtghJIjWql+xP2DKVq/IwfJvHxOsZQ8g4qMYFaP1EDA=;
	b=XbVfwVdJe8FkBjzBvMA6vSAU7/nLeK8tBg8j0Rvnv8ZacpYAKIUwXamg5WW8cf546hCzhi
	MeHkdSvl2V43a26W1Eo1o1XOu7SFeJsU7OVtf6uSkcF4rN4r6WID5uU1tYinqhQfDSkc5q
	V/5GEwbNtM2R3MR50IhmlGwZXH3wQ1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795077822;
	b=FbpUBBeLO/u7I79f0o+8NYGLpSlyDCNfvnnhEHHre20EXgn5xU8yRNaJyuyE/7u/tUNg29
	7a0LlSoZ8wHuhPKkchdnd1ubm+pekBi3+JjFuIUbpwtkASW7pNMgIuhx61l9S47voURrj+
	l8Wb9yFNrtwakIrnk5SD3KuKJmsh5fM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mZmgybaJ;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 189C960EE9;
	Thu, 19 Nov 2026 08:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729B81F000C4;
	Thu, 19 Nov 2026 08:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795077820;
	bh=rtghJIjWql+xP2DKVq/IwfJvHxOsZQ8g4qMYFaP1EDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mZmgybaJg/L2vOzYXR9VuaQbUN59V4Q9issn5IeVH5fWmmbGuYLdTVH8e5kAqkzsR
	 u/n+KaV5BBry8nJCAWIPUSETtpucShA8286lPYdkMMMhWwyZHLOph6eDqC+yBsgU0O
	 JZ0i62IgfmDVJFBqGH7vRP79oQGZl+o6pxzZ3vkk=
Date: Thu, 19 Nov 2026 00:43:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 azpijr@gmail.com, lance.yang@linux.dev, fvdl@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 0/3] mm: hugetlb: fix CMA-related issues
Message-Id: <20261119004339.98c7e39ba863695691c7b921@linux-foundation.org>
In-Reply-To: <cover.1794907279.git.zhengqi.arch@bytedance.com>
References: <cover.1794907279.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pauk7x387j8gm8nhnb15kzp9yyaxuea9
X-Rspam-User: 
X-Rspamd-Queue-Id: B9087C0005
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795077821-357959
X-HE-Meta: U2FsdGVkX19A/GgsXsow8CHIkRFNmOHk535cxYiLPHkVbASml21WSAWGe4CtARJBcM3Zq6oBV58e8QkL4lmN0l/bG/R9ShU8thJmyH6x5ag5x+F2wPk9bYlbGWibqSjQbD8HKHoHNeZ0K/769fcMpm9iRtmvpuL2iNsDC7IX8hsCat0abqmUXFfM4C1FHhxM+V95B8swD2ZkbD+G/QBaF4dKGqZ+Cgzpmv5Opv2KMld7kpG1sMTZGAIRoFJxCSSoVMGpZE6R86QdEZag7KqcndVjsFeF8NzJLSe47IEf1pNSfCIH/wyCwHzYlcMmZ4fKNA3GSW0UjOomNGhDtNTx5oBnVwjDtKJ2mf+5UbTTX+Ww4m+bHITgq3f26J+zP1Vkubmw4qqKvK+m6rVa1/2EE3xZXL2MixR3DmtVQEAwWoub1bf3wI+o1nHm1gMLnFRQkIJ2cAmcdSqYyg7BK/tm79z3yyfOg7tFO1xyheuVy3pQYKidLr1l1R0CiNSkUBqVqNG+SsRm4K955fFfSwo4bBBMidsXWqHlvLHbo+cfDklky1pOlCEVOf+dw5X0kSp8ziVn25Rk7SlnkMUJ5f++wyK3dzEckOoK1BwnonZVnOlCuxl88cGozWqOHcs3Tto9iuXlsRQCN5d7wLGnmyFtmpYJYr8WXIycDXYj+lYaVVbUFNdJdrglS75uRHzwnu6rD/IalrmcaCufCFSQYB1TelNwBDZm+I9ZSd7lg0oZiBeZs4XDVatLzH+K9gErWIZquWnsjdFC1MalyztdNHYSrVIknFRbd9iG/f7rDEos3uJkfBwlya6PIZKd8X7qind809MtYWGNBBwvbDxsdcB0Q5OHnX6J2xUChKM1pDA1zUduZv3epupSZfKZMJMw3zOyBmkGtsNNXQGvoj5+MlkEa6omgkBrClZoPp/k2kgy9VKYXhLjB0kKW7Q6xvaK1ADgd+5+WuResyyjIVFvaPq
 7Wr4w/Ha
 0xHafOeTbJb+5LEnfiwRk41QpoFhwbBz260MAU1JpAh9TivMSIm+WYNr+pIUJduD/ePh7glpiqNY/4DBOiTVM2FRn2nH9gQ2akQiNbo8Yv5DQCJGEiHXIhTgUJ0JJttGEzC1iDQo4CBX89wfONu9wxu2KleW4+5QoFnz1zRN+UJWBJecBQKiWAlmPRFOZjTaHwUsn6bplTz6fSP9hiGOu4vrWCL6BVqhO9mvh6L4DPLn6T9XGgbNzXOZoR63SzbQtK5PprLCtUMxqWUtDw0Sxt9Lt6LvgNuHKkkhMjvnX2Zdq/wixPi6P+L/Ktg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 17:33:56 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> This series fixes three CMA-related issues in HugeTLB reservation,
> long-term pinning and allocation:
> 
>  - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
>    CPUs that advertise 1 GiB page support.
>  - Allow long-term pins of explicitly CMA-allocated HugeTLB folios,
>    which already own the CMA memory.
>  - Preserve the caller's GFP mask when allocating from CMA.

I fed this into LLM-driven testbot, both confirmatory and adversarial
testing.  All looks good.

Tested-by: Andrew Morton <akpm@linux-foundation.org>


: Tested the three-patch mm: hugetlb: fix CMA-related issues v5
: series before and after applying it. The 32-bit boots covered non-PAE
: and PAE kernels. The 64-bit tests used a two-node VM with 12 GiB of
: RAM and CMA-backed 1 GiB HugeTLB pages.
: 
: 1. x86: hugetlb: disable default CMA reservations on 32-bit kernel
: 
: Without the series, non-PAE boot warned and reserved an unusable
: 64 MiB CMA area. A PAE boot also reserved an unusable 1 GiB area.
: With the series, both kernels rejected hugetlb_cma= and reserved
: neither area.
: 
: 2. mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
: 
: A long-term pin of a HugeTLB page allocated from CMA failed with
: ENOMEM before the series and succeeded afterward. As a negative
: control, I found an ordinary anonymous page inside CMA on each
: kernel. Long-term pinning migrated it out of CMA before succeeding
: on both. The change did not permit pinning that borrowed page in
: place.
: 
: 3. mm: hugetlb: fix GFP mask propagation to CMA
: 
: On a preferred-node allocation, the caller cleared
: __GFP_DIRECT_RECLAIM. CMA received it set before the series and
: clear afterward. I then exhausted node 0's CMA area: further 1 GiB
: pages fell back to node 1 on both kernels, and a fourth fault raised
: SIGBUS after both areas were full. The fallback's reclaim-enabled
: mask reached CMA on both kernels.
: 
: Allocation latency and general memory-pressure behavior were not
: measured.


