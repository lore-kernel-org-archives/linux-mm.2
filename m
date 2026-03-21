Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88630109448A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 16:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56156B00D9; Sat, 21 Mar 2026 12:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07496B00DB; Sat, 21 Mar 2026 12:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D156B00DC; Sat, 21 Mar 2026 12:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C005D6B00D9
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:57:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 532081405EA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:57:51 +0000 (UTC)
X-FDA: 84570677142.05.7F8AFF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DD58D80008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:57:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OeSB1fvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774112269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZntwsB1kspslG5ErE48b0yQcpnW+xiVqA8yodgtzz0=;
	b=PwFi018+yulz5vOzCuhilSoAAEX3Tjb8ZyzO6R5OQrxphp+cywoE9plrEb3BnJYJx8L9Iu
	xleBx2XC9dqgcma8ushkQcplb+L9C/mXNoYGKpBYkoEIfpUipMRYdUnwDLqJhVHI3b9Ev2
	P9obl88I6YXkrjvfS2BxSeO4tvDz3gQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774112269; a=rsa-sha256;
	cv=none;
	b=I5FLnAbliNtW2fbMupjyQStS+6KCk4omK16kNF9RMgQAGtoUavpm3UhDt5yQIYVbYn6CJj
	NxF+BYSP8rJFdpMQDo4GqiK5ZP4EVloqHierhiOVF4zPiiMp49uWVMeo5x0iLoNtxf5E+o
	s2c/yQbeRoWAxaBG68EhTTvebrE96p8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OeSB1fvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41A06600AE;
	Sat, 21 Mar 2026 16:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF18C19421;
	Sat, 21 Mar 2026 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774112268;
	bh=4so0ChGaWqOM6KdH3LDG9GhHIY2dSUYkn8Ys1l42Dds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeSB1fvrhp6SsMGhqRMJAOMTLzXJNLGYF+bx1OoCEcnLdzJeC66W3PkeVARDsWD/M
	 2aqK3Ky8L7PEyHM8VSKUs6ACAta6xjkC3eg0pQk4r7EY6TTEoNAwAdV3Gi8HDxOrA7
	 P9vjq3wtbf1Yr5og79mfjFtLylGXe/J+G4s3lebNimpid9CEtjq2toF1nNLkNyIBlK
	 OwqtCg8Tq+/onv+8vEzwfRqirA8wAqvkGeLFZJ2bYksBtRay1Bk8JVqROuzLmfTBg3
	 xvsPCwO3SpR24yMQxhLR2GUtPAXbsFJsirm1xMI0lnw+svYVG/uKS2ZuVDyqfEJYJ6
	 MNIL99OPYGVSw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sat, 21 Mar 2026 09:57:45 -0700
Message-ID: <20260321165746.84394-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320190453.1430-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD58D80008
X-Stat-Signature: zmcw1tddaubdmch1swcekhd53wpgkepw
X-Rspam-User: 
X-HE-Tag: 1774112269-676385
X-HE-Meta: U2FsdGVkX18HWoj7YGRNAOMr2dFTn0iBOHiA4cSjZ0NGumAgfoia7Ry5pFblAY6UcH2dgpkjJ5V2vj+6AUP2TziF6o8er7umUIpr4mm1LuzDkojLSGYdvGItVFEC6mU4osMzXiNN4QDp3xKf0SFI2foDTgK8jytHHscEu3oYo6fp1GEkF586YwaoE7Lz+Tnq7+DH87IyPiqBIC0dIeKONd8oRdI6UaOf4dLEIyuRhjZzvh6Rg1aTSOudWUDE3opW1OQNOoUctXteuZ6gYaQnC1hVwQwkqEIleMCt3OWmA9LDgQ9Mq4X1v/tmvLpfq8rAptHNBbzG0VT3DcqRq7y+6S9UsmMpfOw8i4rurFsc7vacRn2FWH3KyAqTlVHR+BcMtVpsu3xJyq5fbK712SPrP5ZJvile8/7bHS6E843gYXEMgmCJZzuXDLFmwad8iUbbSe4SUNgtVXUyoE3cQMCOmMGj8k8nnFGO0AbHcOd+cjU4y6LSClysh97T203kM5zkGMf4ntwuPm4wI8JTsrB9lBOVPoRIGzhdQHQahP8bPU22Wd9oJ3gxT2zytGFSM6n9N+zQNsr9R5a/BFKqbcm3UY+hfEXPA+oPQEfuoH65NN3VXzf5Jp1R3pXZJuigWt/OslxC+Fxy6b0FbCqiHj/WuuFNV/5/CKn3W4wJArjD6IGDMYy7cqxLHtH6EJwQf9SsPtllYPZaIky8msOb/RCG1yqGw7U3dASk7kB5E72+WOHAGvrcL4mrV8bhdMNO3FWITOUhWhtbCnVdbooy2POIZfK4vQjmtlBOgX8149tale+JGQGnmy4PMkA+NRkCt4R8TNrKdCkciRFwtKbdYJ0G8PEgAQy/s6FEMJqv7hNrTQvttoAnxWPhZJLJiT7s1uqCyghST5MEm+5DDoAImkiWJFKDHaduJ9acl28CJqTkDnBOaXONcmpSee3KnBh/Eh0UuKBgLRK8/e665EKoa/K
 QE/5bOwt
 +o+osbh7WDz4lzYiLZkqp8a4nb3onDEIW4BPk72UNnGGbGRzxHZMQ0wgm+pfkwjXe53K0wVx0Uy8Abp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,


Thank you for this patch!  TL; DR: Other than trivial things I commented below
and to the patch, I believe it is time to drop the RFC tag, and work on merging
this.

On Fri, 20 Mar 2026 12:04:52 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This patch introduces two new DAMON quota goal metrics for controlling

s/DAMON/DAMOS/ ?

> memory distribution in heterogeneous memory systems (e.g., DRAM and CXL
> memory tiering) using physical address (PA) mode monitoring.
> 
> v3: https://lore.kernel.org/linux-mm/20260223123232.12851-1-ravis.opensrc@gmail.com/

The above link would better to be put on 'Chage since v3' section below.

> 
> Changes since v3:
> =================
> 
> - The first two patches from v3 (goal_tuner initialization fix and
>   esz=0 quota bypass fix) are now in damon/next. This submission

It is not also in mm-unstable :)

>   contains only the core metrics patch, rebased on top of those fixes.
> 
> - Simplified implementation: removed per-node eligible_bytes array, now
>   iterates scheme-eligible regions directly for each goal evaluation.
> 
> - Handle regions crossing node boundaries: uses damon_get_folio() to
>   determine actual NUMA node placement of each folio rather than
>   assuming uniform node placement within a region.
> 
> - Pass scheme pointer directly to metric calculation functions, avoiding
>   container_of() derivation from quota pointer.
> 
> - Fixed 80-column wrapping issues.

Thank you for addressing all my comments!

> 
> Background and Motivation
> =========================
> 
> In heterogeneous memory systems, controlling memory distribution across
> NUMA nodes is essential for performance optimization. This patch enables
> system-wide page distribution with target-state goals like "maintain 30%
> of scheme-eligible memory on CXL" using PA-mode DAMON schemes.
> 
> What These Metrics Measure
> ==========================
> 
> node_eligible_mem_bp:
>     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> 
> node_ineligible_mem_bp:
>     (total - scheme_eligible_bytes_on_node) / total * 10000
> 
> The metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.
> 
> Two-Scheme Setup for Hot Page Distribution
> ==========================================
> 
> For maintaining 30% of hot memory on CXL (node 1):

I think it could help easy reading if the above sentence also explains
node 0 is DRAM.  For example,

For maintaining hot memory on DRAM (node 0) and CXL (node 1) in 7:3 ratio:

> 
>     PUSH scheme: migrate_hot from node 0 -> node 1
>       goal: node_ineligible_mem_bp, nid=0, target=3000
>       "Push hot pages out until 30% of hot memory is NOT on DRAM"

Seems the sentence assumes the actor is in DRAM.  It was not very clear to me.
How about making it clear?  E.g.,

"Move hot pages from DRAM to CXL, if more than 70% of hot data is in DRAM"

> 
>     PULL scheme: migrate_hot from node 1 -> node 0
>       goal: node_eligible_mem_bp, nid=0, target=7000
>       "Pull hot pages back until 70% of hot memory IS on DRAM"

If the above example is good for you, to be consistent with it, how about
rewording like below?

"Move hot pages from CXL to DRAM, if less than 70% of hot data is in DRAM"

> 
> The complementary goals create a feedback loop that converges to the
> target distribution.
> 
> Dependencies
> ============
> 
> This patch is based on SJ's damon/next branch which includes the
> TEMPORAL goal tuner required for these metrics.

Your test might be depend on the feature.  But this patch series itself is not,
as users could also use it with CONSIST tuner?

Also, as I mentioned above, the feature is now also in mm-unstable tree.

> 
> Testing Results
> ===============
> 
> Functionally tested on a two-node heterogeneous memory system with DRAM
> (node 0) and CXL memory (node 1). Used PUSH+PULL scheme configuration
> with migrate_hot action to maintain a target hot memory ratio between
> the two tiers.
> 
> With the TEMPORAL goal tuner, the system converges quickly to the target
> distribution. The tuner drives esz to maximum when under goal and to
> zero once the goal is met, forming a simple on/off feedback loop that
> stabilizes at the desired ratio.
> 
> With the CONSIST tuner, the scheme still converges but more slowly, as
> it migrates and then throttles itself based on quota feedback. The time
> to reach the goal varies depending on workload intensity.

Sounds reasonable!

Do you plan to further evaluate some performance metrics?  I'd not strongly
request that, but it would be very nice if we can have that.

Regardless of your answer to the above question, I think the current code and
the test is good enough to consider merging this.  I suggest dropping the RFC
tag from the next spin.

Thank you for doing this, Ravi!


Thanks,
SJ

[...]

