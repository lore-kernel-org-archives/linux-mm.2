Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB5AFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9B96B008C; Tue, 28 Apr 2026 11:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0F06B0092; Tue, 28 Apr 2026 11:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D003B6B0093; Tue, 28 Apr 2026 11:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFC356B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:31:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D2211C024F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:31:12 +0000 (UTC)
X-FDA: 84708353184.28.FF8983B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BF06A0012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:31:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N1VUL26b;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777390270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diSdyLIb6qxTxRQkvX16OzTJ90L/VwoWu+uz3BR1JEU=;
	b=6ry29fdFFDFhhcdOiMEKF53Z6L+yflseF+uaazHr7jtRHR8QE8FiiWCluDUFK04xhzgt3v
	MjJWaTtrt9KKMcdCYp5gKVVYPTAPJRb/3AnqC6xDWJiS6BxP0Ep3mW9SKCURQVEpRPqdQg
	XZ5pzL25FtEWF9AtL1QJGnbxRmaAdxA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N1VUL26b;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777390270; a=rsa-sha256;
	cv=none;
	b=P3tDwIee3Ih+jchax5X95Tyn5fjdNzHKu1QqK6rHlpssWYsWT74sb1lpiWNF6h9audeOC0
	7urVGrJJNqP6sjBGfnTuyeokQ/59AE+1Sbvq0Q3OFi41scWjBJyTRW8z1ZYzyS/bG4ChOw
	5sTd5/0xJdf0DyBs62ROKAEprZuL7pU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D44E405D6;
	Tue, 28 Apr 2026 15:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67AEC2BCAF;
	Tue, 28 Apr 2026 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777390269;
	bh=dCSRhnFrakZnTo4Xpc4kvr9Rlo4/ax/YxLWl2hghJ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1VUL26bqPJE+qR9QHl9MpzVHe7s19tUMLOM8oSd8Aw7sdJz1FDoc68i9hMQ3btSp
	 zOSQbpUuv57a4Yp64721BiKjJdrI7j7yaVbzWOeIoXSwT7ONxBz8BYbqSzUIkooYJG
	 i1vTzHIb3DxBarHHVeS1CVAiXEmuGRxhq9Y6H+NfZmyLYankMFdBVfz7D3amrDck67
	 UvEtzDxk9uNfY8ZXZ6JCZswnapzu1XOewROvNrnfELHl+z8Gv99PVgJid1nsmZ3mKA
	 fn6PDn0XItXI7YHh0q4kKSHukMAc3ZJ5hXNuJYFrNI1OGkqKrio93OZsrKC+t3XXFk
	 DrBnA06ssbDGA==
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
Subject: Re: [PATCH v9.2] mm/damon: add node_eligible_mem_bp goal metric
Date: Tue, 28 Apr 2026 08:31:06 -0700
Message-ID: <20260428153106.125910-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428030520.701-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tser3cujxodcqriwxcjeffuzripm1xo8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9BF06A0012
X-Rspam-User: 
X-HE-Tag: 1777390270-641475
X-HE-Meta: U2FsdGVkX1+CHVKNzZbnWuPo8XnPmIW/HyecauPH2dujvCfKc+3iXDMD/AfJUz/nhjDn3ka5Lcn4lPhUIrWTjdiFVVdccf6YvxdzZmgLW97s5IBYDPQOjzHIR2xWxGi1168QDgn/AG9XtMMsz2CA2XcPBvwNTo3jYKgRtY2IKhOWHWK70roR9Ps9HLtNS8BoBiy55njtESdMyF4VoeA5tZdzr+FTX/wBvARhmgDNfok3vD8oeTgztFK48a03c1b8aGl7/+KS/TjKAD8EZR4SPOaBikNhvVEJwcNjm1Gjgahbe4xhdqaA2y45+SYj/QQuSggqeoU+5NxJPi1l9o+x+ykbi3MsTfiRhwV6b04o6t3h/KRd22fhUBd7RqJQ7piEj6Q1wJoeZg/bWTDjZ3WPjFZVJN2HbWuJ+lzTH26ggAJunhE2EhcWhr/yxkeZGAU1GN5elgEkL+lvlMA/3BefJFIwyLIugjSo5v6KFfLtJbpX0J+uwjfhn+lasOr+8Xj8cawL79sD4+7FwrK/p8LGlqQY9kiLeLM6m2N2QsJYYVYLopAhu0yPWa+6J2rxKiPFVGKTsabQacSaiEYkDEBqXtsm6OYNPzVyCUz+js6PDQJ6Ux7yAbPHaw8dCR69pOfLKRNUdcrlEbgt4dE/LdxE9bW6MwG/LlsfZBOu+ozCKbQM7PoBKJLkTZ9e3qRz8rqRn7ftyoWkM2uu1+Yn/ySF5X/GKhu0A8VxgjZnW9kwgcLb7JqqB97zs6yK1mU5/9Se9z6Vck/2iNXQ2gVDKQq6R6F1XiX7SwIZ7T3mJp9KfA3tgVtj4TX4igcFqW0Cwo/hDHr+dR5BfSP03svXvKHn2nqvSWb/140+njWl0wceTa6L8DyXN+942jYbjBvx83i6dF9LSq6hvt4wW21qVql6UoN9VA9s7AJNrRXic5iOOJrgFTl2cJ1zgGdg1px9GBq9SG6SHHb6yhEiYFRHV3U
 vtZyNeT5
 bPytRdWfcF7d+r7q5OASNJeO90M1y3OccMbw9z9eBhIvgtX1dm49DAPomxWkKa3dKF2c9nrWEH9/LrEBm1k2rK4xGpDCC5m7ufdhzgZLtepb2//tEzWMjp045vV9saUQV0wf3Z5JURFtXAHvgAtzikBaA6Ep4pNRU8OmGYJO7Ix8mYomTR4Au2N8ypgtvAjeer3CEXp9X5OOR/QPg8O5WST+hXy2JtzJpoM+6zITrTH53FBYe+z1x0Nx07R9v1RjTHyZ6ZNvBBe9EGqHr7MNxBAqJW/W9OdHBBB5h8M7eiDZbTxBZhPWOisLcv8Zmenb3eD9maVG/93TEmeKRlRu9H0tJmw7kn9z11xv7H+2G+xYRjR9l9ON4wWV7VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 20:05:20 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Background and Motivation
> =========================
> 
> In heterogeneous memory systems, controlling memory distribution across
> NUMA nodes is essential for performance optimization. This patch enables
> system-wide page distribution with target-state goals such as "maintain
> 60% of scheme-eligible memory on DRAM" using PA-mode DAMON schemes.
> 
> Rather than using absolute thresholds, this metric tracks the ratio of
> memory that matches each scheme's access pattern filters on a target
> node, enabling the quota system to automatically adjust migration
> aggressiveness to maintain the desired distribution.
> 
> What This Metric Measures
> =========================
> 
> node_eligible_mem_bp:
>     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> 
> Two-Scheme Setup for Hot Page Distribution
> ==========================================
> 
> For maintaining 60% of hot memory on DRAM (node 0) and 40% on CXL
> (node 1):
> 
>     PULL scheme: migrate_hot to node 0
>       goal: node_eligible_mem_bp, nid=0, target=6000
>       addr filter: node 1 address range (only migrate FROM CXL)
>       "Move hot pages to DRAM if less than 60% of hot data is in DRAM"
> 
>     PUSH scheme: migrate_hot to node 1
>       goal: node_eligible_mem_bp, nid=1, target=4000
>       addr filter: node 0 address range (only migrate FROM DRAM)
>       "Move hot pages to CXL if less than 40% of hot data is in CXL"
> 
> Each scheme independently measures its own eligible memory and adjusts
> its quota to achieve its target ratio. The schemes work in concert
> through DAMON's unified monitoring context, with the quota autotuner
> balancing their relative aggressiveness.
> 
> Implementation Details
> ======================
> 
> The implementation adds a new quota goal metric type
> DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP to the existing DAMOS quota goal
> framework. When this metric is configured for a scheme:
> 
> 1. During each quota adjustment cycle, damos_get_node_eligible_mem_bp()
>    is called to calculate the current memory distribution.
> 
> 2. The function iterates through all regions that match the scheme's
>    access pattern (via __damos_valid_target()) and calculates:
>    - Total eligible bytes across all nodes
>    - Eligible bytes specifically on the target node (goal->nid)
> 
> 3. For each eligible region, damos_calc_eligible_bytes() walks through
>    the physical address range, using damon_get_folio() to look up
>    each folio and determine its NUMA node via folio_nid().
> 
> 4. Large folios are handled by calculating the exact overlap between
>    the region boundaries and folio boundaries, ensuring accurate
>    byte counts even when regions partially span folios.
> 
> 5. The ratio (node_eligible / total_eligible * 10000) is returned
>    as basis points, which the quota autotuner uses to adjust the
>    scheme's effective quota size (esz).
> 
> The implementation requires CONFIG_DAMON_PADDR since damon_get_folio()
> is only available for physical address space monitoring.
> 
> Testing Results
> ===============
> 
> Functionally tested on a two-node heterogeneous memory system with DRAM
> (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
> migrate_hot actions was used to reach a target hot memory ratio between
> the two tiers.
> 
> With the TEMPORAL tuner, the system converges quickly to the target
> distribution. The tuner drives esz to maximum when under goal and to
> zero once the goal is met, forming a simple on/off feedback loop that
> stabilizes at the desired ratio.
> 
> With the CONSIST tuner, the scheme still converges but more slowly, as
> it migrates and then throttles itself based on quota feedback. The time
> to reach the goal varies depending on workload intensity.
> 
> Note: This metric works with both TEMPORAL and CONSIST goal tuners.
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>

So, this looks good to me.  I find no blocker [1] from Sashiko review, too.  I
added this to damon/next tree.  Unless others find concerns or this is added to
mm-new by Andrew soon, I will repost this for mm-new merge.

[1] https://lore.kernel.org/20260428035754.116202-1-sj@kernel.org


Thanks,
SJ

[...]

