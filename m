Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFD5606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlH6/ki1
Received: by kanga.kvack.org (Postfix)
	id 89D116B00EF; Fri, 13 Nov 2026 20:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E306B05B0; Fri, 13 Nov 2026 20:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B896B05B1; Fri, 13 Nov 2026 20:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5439D6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:14:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D142F1C3769
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:14:26 +0000 (UTC)
X-FDA: 85431954132.16.0481EAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42FDA100004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:14:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RlH6/ki1";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794618865;
	b=2TN3+b/H50qiShOEuAoSvnI4MXQ5a7ZNs30f7cboT5jTfdbYzP/hSj9easZtE+sZpvgIoX
	6oMhN1dpusY9xHRzIzY5kY6TdiFLsBVoxNXKeQI/NyejhP3wdrjMoeJTmzmbLepUC/tabb
	VbPKp/lDXyHKtdumMWicE27vgCDAFds=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RlH6/ki1";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794618865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyYy92siVxlbkOAXrPBxCpNpLxro7gVqdyR2tGshRfw=;
	b=Y+bH2t18+nLAg0dNMqgBx385W+Tlq8DCWhyvqf2cOojZTccW6H5uDakArJU2MtXHn2ykzl
	SLFazdyz1g7nhSZHvaX1UjpOmw6GbYVZXMu+0x66WOMyJe3RVMHv636IIGOuX5ZdhLMZlh
	OG4mlVtiOveO7OaHB7IBsA7LkvgVjHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF23261908;
	Sat, 14 Nov 2026 01:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3620B1F000C4;
	Sat, 14 Nov 2026 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794618864;
	bh=UyYy92siVxlbkOAXrPBxCpNpLxro7gVqdyR2tGshRfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlH6/ki13MdccZ31W7ZNOHZHNU4dwl06XOwI2e3Zs1ynQ6VT8B2LvBFPuM4eKNb+q
	 XtG2X2mKPQQflf5m/g4gwv8A6jrvYRbRz9V+3mWLpAYW8kWBw1GHcFpBBaHG+xcqDD
	 tpbANPB6ufF7J7sNbeg8ps2RMyNK08Zx9kBKfZg/sAdyq/hFCi4PjFOWU6PmUmcvWQ
	 cqSXj0BEyNspI5CBipxiw3UneGVz4VuhEIRCSxWsD03V+Is5hxLKAO1k+HE2Wo8/Ch
	 p+HI5RtpQHx9q2+sTQVOxUB1GgprMBo6jc1y1Jem/KJdrPuoVxIGpM+nlgPdq4DKUa
	 KUUfaDwuw3bBw==
From: SJ Park <sj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no memory
Date: Fri, 13 Nov 2026 17:14:16 -0800
Message-ID: <20261114011417.85494-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113192642.2618878-1-gourry@gourry.net>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 42FDA100004
X-Stat-Signature: 45rad7q4ipqsekhomhtt8eb97ik9jhup
X-Rspam-User: 
X-HE-Tag: 1794618865-534866
X-HE-Meta: U2FsdGVkX18jSref1wSFcguMbzJ/oZMrqUo5fdxPVfxysp/oMv3wPQpKZZl1GhVgtTKJsuPc99fp8fEV59VYCKXGYAAwpsQKvamIoedsDNVupQwcXKgATQ9Mj+/Bv8rVHpNF2owh3cF7b10CRunDpdUjRFO7/8x+L7zojYSJOlnoK1oJXNz+6QoGcS0YMH3941pH4BD9Ttm7tKppQpJenGL/IdJwj47r9BdqFQLHQqI7LpuJqGKoffIspmH92MYx0Jre1FMcEDa0pIzwp1Mzi2w1anaSPTlPJsKmwbk0bVdZFLY8nvrarM15CPpNfJaIqxi37RSUJg1w3kr86wPXIbNaiGVXIDfHkEpiBAd714hScm3GE3NkoPtk1pkrAAXu5Bd0Tp4/rkWAXzgOfm3KRXUiHjcbnxAvcn7Lzxv+AwrJ9trm6a7VaL4GbRnoUyQ//IAySJ7EFh6XdDfImvy2IJjZJq0T+UTmczCUw3wF9hpi/trNZz2CSAvuHLc0hdrgCD9x+uSzAoHDgNsmr22noLf3wzD4wVuLVLfMwEcDpO8TfbelFhkXLRSKpX+nY7ymnhEees4475LO61thj5l4m4FkyRz1ar4s5copOvNyYyFZaYwaxQuGjVAiDm+oHWLya+7ncBs8WQvjoPLY5VCsjwhDzN3bGjo9opFlXfNDfMdKO781tGUhgoXpL6+4qoqFbFfXeXz5GCxbgJq/a5peLqtAf/YN1bnkodQO2lPC4BFiQq6rIosj8gj4AIiVir2vdHEjaa5uVD/+AvC/uQ8s62HW1VswlR7h75TzdeZtEFs8/GqNLwagIakyuWAkCPkNIiepZRor78bDxttcNvEdmXscXv0heWQ+F2NEwOX3IRrmeV7nGoS84E4Si1CEGcHxxojxPdfjuXHmsjYOg2z9VDQYzCdoj+2HfNcdtSIIyYGedndmJrNeNJ3AhIlTVwArJ5nQZp1MmKdAL5aN/Kb
 h/XwWdSE
 y3w7DD2GA2Op9tZikbzCoUKvmJCMFaWi2K4llmLoHj0GMu/ixSb895WPWZFv/BBb6nLIp0enSjoV1VUUSFclRUEjJVEinuVwGGuQJDTfs1EOTa+g8IfsFzIWo1Xf+Wn4fuCZb5W8Bb+syA8j4dMJzfJ+67nDj238PFW96FnPExpK0DWyXjMghT/57AicLckchHxjjgyTv8WyFKcerh3XVK8d9y3qDD4YoHb/r/AS2/fRGfHKBSctdVCqu9y41RG7exiICEz7Bzz9Lup6hXX8PBy0G/6Oo56FVWZVOSenS5xW3rtpV3GdQ3mvE+QYQS40LH2t875DxTRdRrwKJnG0qQcpYdSk3OaUVIZpVdKmms4EPYF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 14:26:42 -0500 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
> it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
> 
> On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
> is removed, so offlining all memory on the nodes a bind policy names
> leaves it with none. The policy is then treated as movable-only, and
> movable allocations are restricted to nodes without memory.
> 
> This results in allocations failures, a VM_FAULT_OOM leak, and then
> an infinitely retrying fault that hangs the process.
> 
>   page allocation failure: order:0, mode:0x140dca ... nodemask=2
>   Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> 
> Ignore a bind policy whose nodes have no memory. policy_nodemask()
> already ignores a bind policy that does not intersect the cpuset.
> This covers hugetlb's policy_mbind_nodemask() as well.
> 
> If the nodes regain memory, the policy applies again.
> 
> CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
> isn't marked for stable.

Makes sense and looks good to me.

> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

