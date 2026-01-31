Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF1FD79768
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96376B0005; Sat, 31 Jan 2026 07:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77B56B0088; Sat, 31 Jan 2026 07:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76656B008A; Sat, 31 Jan 2026 07:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9533A6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:56:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A91CED4F7D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:55:59 +0000 (UTC)
X-FDA: 84392256438.04.8D35915
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id ABB3AA000B
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:55:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=cvHWM7wkYxbKK8uomcWj5m9rQdeiSiORcP1v8LWtM5o=;
	b=Q0dLMCOOGY6gGehYsoRhG9x5FaNoUiSdXAe3MozzwS1UoH2Uv9J4szHAPf5OvaC7fi180y
	Wn7QTTRmnJanO9jdVQJcZfKCF3XHYtjD+xJJGnoMQQTTNuS6guLzucIHYuVRnB+cdkb91L
	bvu7xrGN4Mocm4C50RQQuDEbOFmAoDE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769864158; a=rsa-sha256;
	cv=none;
	b=eEePHwgaN7gNcZ7qwFtrjPIqMDlgF3+L/NOrPY0zYHx12DLSPwsB12BATK4Att3Z9Yj4AW
	HFUOtQ2yfuoNSTPRL3PJeBLOURrv4EQ/nCNvflwdxNXg7cLmOBPHmXGTNXZhJBzmJIxhhO
	BQd9+zRcgVajKEMhfnbyRgKOC9EyBDM=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Jan 2026 21:55:45 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH v3 0/5] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Sat, 31 Jan 2026 21:54:49 +0900
Message-Id: <20260131125454.3187546-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pun1x6e6a7t8w3dt9cmftqr9s8oiedoo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABB3AA000B
X-HE-Tag: 1769864155-780284
X-HE-Meta: U2FsdGVkX1/0Nq1TC22gIqdZF4228xyc0/dz5QPHhzehcpdbQ2kjyqUdmssiBqnDo03Nj/y5g01fBkMVj+hQWFXGtH2DAj7g5AGuMKnEO/DpEwOz0JfvpqPxTxuczWRWC4NVCO/ZGaONwcr9OjPDP70nO/WEgafF8tqRZA1z8xWbAdAQhxIDx1ClTn9eFxbZByqHCmaOde6t0ngwg+6GDbLp8fyAN0C4UEwhDR4gopnnXJZUz3RBbXbPb0WhEXIRiPSUlKZ8DffhCz0yHtxeJ1ni3dabVdzPasSOmQPF1pvSWB71lHLLh11UEk/79/GNkRz61hnkAN7RvYV4SQfBhMR7cn+B8dbt33o8Ysi5bLwPf89UQX3tfrSgm5tsBzb6KGJheWhKDjUEctTuB8wPJb+IkdNj3C5tIyCCd7883+vcDIHtOldSOlQtLc8dEQszKdfErKk65yuVMbeKqAJ7QpV3FYbCIIgQ6i441QLrBUzYfgo9OU60LL2RBuD92cBlI23LOYYDQyHYEWAD7kKgJz/taWAW+ocSqPcCIgO7uG3decGKBkq6X4yTkIDMJeZebf+5bfHHKYlsihKjpiOwmcsI6Js4cUfBF8yb4I+hbY+u4KnatCsVXiqygmC1D0/rDd4ggbLj9V7VlH9fktdvn8JQHJv8tir5YFRy+WVxjY1PL77aW6OPPtpa4XQUnZ8R7JbZO5f9m6YtHbb+OBgkFUYBv4/83EVctjd/WR3VSbjqutAQgiz8SpTo0t51nk6Ub4QMkv/XkfHH5+YSxnH1yL46RGsX7DdrHr7WNVMuntfge+qvZ8j8YpEnObu6fAuuUcCvwH17ZF8tMMjBZoGm3UBT12LlVY3LPbLVgjn0Uhu/Yx3DQZcC6p2EaQs4LM3sep+jzaTmKUdLugbR/F6qRMejaVoCdKn6fj3+LLkFvukj9hv6IAVvHqErek7VRV8VQmkpgPL2PaHsJNpyyqT
 KFe3KU5C
 z8gGOnXLjwvEqzwiqQY+AgSu3Y7ogqpo1CUUfTW8TnNw6QZ20knO9rBKY+oANE3DMVjV4dbCr4Tz1NZSJpMMoX3UZzNVW16VzA3a6rKbZQBayV5bMxrkOpCK0p3fvvPs1Ar86XTWj5mM3/hs3Rl3qJgNm8OOkECa+/IXk+IqDT3GmuVYpKe8yJSXslEvtgQVTC6+yIkLDfNnF1mNhngqjtV5YDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the third version of the RFC for the "Swap Tiers" concept,
incorporating LPC 2025 feedback and subsequent bug fixes.

Previous approach: https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.park@lge.com/
RFC v2: https://lore.kernel.org/linux-mm/20260126065242.1221862-1-youngjun.park@lge.com/
RFC v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

v3 addresses bug fixes found during testing and adds clarifications to
improve patch reviewability.

Overview (Recap)
================
Swap Tiers enable cgroup-based swap device assignment by grouping swap
devices into named tiers. This allows faster devices (e.g., SSD) to be
dedicated to latency-sensitive workloads while slower devices (e.g., HDD,
network) serve background tasks. The concept was suggested by Chris Li.

Key Changes after LPC 2025(RFC v1)
==================================
The most significant change in v2 was adopting strict cgroup hierarchy
semantics based on LPC 2025 feedback. 

v1 allowed children to explicitly select tiers ("+tier") regardless of
parent configuration, violating standard cgroup principles.

v2 enforces proper hierarchy: child configurations are always subsets of
parent. Default is all tiers enabled; use "-tier" to exclude.

Example:
  Global: SSD, HDD, NET
  Parent: -HDD → uses SSD, NET
  Child: -SSD → uses NET (intersection)

  If SSD deleted: Child uses NET (exclusions reset)
  If NEW added: All cgroups use it by default

This ensures children cannot access resources denied by ancestors,
matching standard cgroup behavior.

For detailed rationale, see v2 RFC and LPC presentation.

Changes in RFC v3
=================
- Fixed swap_alloc_fast() tier eligibility check
- Fixed tier_mask restoration on error paths  
- Fixed priority -1 tier deletion bug
- Fixed !CONFIG_MEMCG build failures
- Improved commit messages
- Fix improper error handling
- Fixed coding style violations
- Fixed tier deletion propagation to cgroups

Changes in RFC v2
=================
- Strict cgroup hierarchy compliance (LPC 2025 feedback)
- Percpu swap device cache to preserve fastpath performance (Kairui Song, Baoquan He)
- Simplified tier structure (Chris Li)
- Removed explicit "+" selection; default is all tiers, use "-" to exclude  (Chris Li)
- Removed CONFIG_SWAP_TIER; now base kernel feature (Chris Li)
- Effective tier calculation moved to configuration time (swap.tiers write)
- Mixed operation support for "+" and "-" in /sys/kernel/mm/swap/tiers (Chris Li)
- Commit reorganization for clarity (Chris Li)
- Added tier priority modification support
- Added documentation for swap tiers concept and usage (Chris Li)

Real-world Results
==================
App preloading on our internal platform using NBD as separate tier.
(Our first real-world use case. We plan to refine and expand this usage.)

Without separate swap tier,
- Cannot selectively avoid default flash swap, unable to reduce flash wear and lifespan issues.
- Can't selectively assign NBD to specific apps that need it.

Result (cold launch vs. preloaded):
- Streaming App A: 13.17s → 4.18s (68% faster)
- Streaming App B: 5.60s → 1.12s (80% faster)  
- E-commerce App C: 10.25s → 2.00s (80% faster)

Performance validation against baseline (no tiers configured) shows
negligible overhead (<1%) in kernel build and vm-scalability benchmarks.
Detailed results in v2 cover letter.

Any feedback welcome.
Youngjun Park

Youngjun Park (5):
  mm: swap: introduce swap tier infrastructure
  mm: swap: associate swap devices with tiers
  mm: memcontrol: add interface for swap tier selection
  mm, swap: change back to use each swap device's percpu cluster
  mm, swap: introduce percpu swap device cache to avoid fragmentation

 Documentation/admin-guide/cgroup-v2.rst |  27 ++
 Documentation/mm/swap-tier.rst          | 109 ++++++
 MAINTAINERS                             |   2 +
 include/linux/memcontrol.h              |   3 +-
 include/linux/swap.h                    |  17 +-
 mm/Makefile                             |   2 +-
 mm/memcontrol.c                         |  85 +++++
 mm/swap.h                               |   4 +
 mm/swap_state.c                         |  72 ++++
 mm/swap_tier.c                          | 469 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  84 +++++
 mm/swapfile.c                           | 133 +++----
 12 files changed, 938 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
-- 
2.34.1

