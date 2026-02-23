Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0F2EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED976B0089; Mon, 23 Feb 2026 07:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1CB6B008A; Mon, 23 Feb 2026 07:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4536B008C; Mon, 23 Feb 2026 07:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB6E86B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:32:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65BBBC02B7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:51 +0000 (UTC)
X-FDA: 84475660542.19.7AC1B38
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9512A1C0012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Omds1BoG;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XWeTUTocNncqBZlX9GEiXOVVLoIbjlo/yvE3a+/Ll3A=;
	b=2kRGeZcEIRRT4Oqd7iYc5f3MZZR/hPtAKNQj3BXbT5+JR18Rr+j0gY5zKmAXr6Cs+BUsTJ
	MJOh2+OKebDwyVg9pnRhOYK8L6uB9exAQoZ4/KVAXrsFiPmffPJyofq8rWqSDWfwZPb+B1
	rp3qGlRk1vXJTsOvTfVbTnwof0jO75k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849969; a=rsa-sha256;
	cv=none;
	b=rptU50yLQB+helGBXtxaYeLWjbt9fmI9redCLGsJhDA7S2ErSMFLqHIV1f63O4IWgBQULF
	fGOF+EGScO5wLGe1jQZlNLf48CgOo2uQwfcfcjtR5CiZd9jQvi9U6xZT5HI2KhbxtVnYsP
	zLPlE6CaiVhnL/b9GypnsflgNDJFsuw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Omds1BoG;
	spf=pass (imf18.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-823081bb15fso2541882b3a.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771849968; x=1772454768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XWeTUTocNncqBZlX9GEiXOVVLoIbjlo/yvE3a+/Ll3A=;
        b=Omds1BoG+VMQIu7W+21Y7nkf4JK8AYIjSKasEGuy4E1zqR1uGoUsPY1ptVtVxoBPEp
         XJpZOFB1vCsr+Qa5agJ38JC3ur3fv3wPFOOJ/Brp6470W5Yb1q/RNzJvgcAHvYq4Uhyf
         Herss08k96F/uvwdD/fuxGBWxFCDcqVQPGFIzRzKLA3tT3FCfpJxof/7gTMRjw68wWU0
         VBkFYm7Dlr4EWdZqyU4HEx3V+ZL6wnMLmQWd9doAh4WGEOVXBiMKNFA0YGoHl+SgYabq
         mxXJSUj0fArdGf9+iyaBWWVLdADLy79hOiSA2ObUpWf0kcejYXvjZpijWoX0da7VbhvH
         V8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771849968; x=1772454768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWeTUTocNncqBZlX9GEiXOVVLoIbjlo/yvE3a+/Ll3A=;
        b=J9T8f9+0lbfviPB2mCgWhK2tcJk6LxBZc+04v/m+C3QzyiE0dam57a8xPHN8H9qlTC
         tqEiId0UytNUaPVlT92Zc8QuWUOS+7PPIP/xmHY19dUGwYQgPiFlYW0Uf1hnUwEH1A7e
         NDAl8+H0M1bb1PM1yTLpz4SsBNqwcwSPtJLwNalk5vEEfHnDYvuvc25Obog0jr8XbCYa
         QOyOapjAMaAT9d965Sb/ONCVDi1uFCu5QkGrDgVvYKBB6F+40EAQqwccQMx5zWIOvsuB
         Ja/07DuEN3TJ6x61rfDlZ3bJtY0d6rMwLxSKWMzPuSPLjy/8fNJC2cOmpVpcJ3GYaH2k
         q95w==
X-Forwarded-Encrypted: i=1; AJvYcCXjxoLg8ch16eRCCyOJ/ck5pZU5WUtK5QxIphWAIpBbGmnAneuSX74kGLWctDdF+orVgssDIXMOLw==@kvack.org
X-Gm-Message-State: AOJu0Yyfn/vqnubirmz1Tj+fbhRxifKMnQDHopJ3DrbeNuwhinXcU0HF
	QnoZCGeYbGQJrXJ10D3GaHi8DRT6VZ5n7/+cdtM/6IXKdPlpxF1Vvwo=
X-Gm-Gg: AZuq6aJubZT9Ctv1xcsvJPz++JsoKyRSO/sQg15nSJXWwLk5Xz3XuHxRTp5RxGrdD60
	AeOWFhpgyB3VnkEZLvdLWw1QEEC9+VgwC89OrVgFk7ecgHO7JbiZEZw5Hsdk+83Gdifk37r3niX
	WnYXoM8X7uvj3vhN9fEGYeGTHEwnWqAPXmvZFT4x6HIUQsQEiFGJQy/T7IkHiqLkuJVzfO+BAhu
	++F+P5xROG5HfcOIvWVqbTShyYNjOsVibSitS5qmm+HGNxDy45E3P5zBhgdlGGQQ4roCUuQzntx
	q+dGbs7MM94/yHyJP+nH7N+05Mm49uuaFJTpYID2oeZCk/JQyRtFu+uT9k/UXMpH2xDfPXS8j/9
	mAK+SI0NsUghAHKQk2ndKlEnwLbC+ZPH6ZS6z/D0stfPRf/0v2n0GlnHlxSrtk8dw8GzhA35ykw
	hqjVK1pDlINXNvGk4vYsvisz5gmZ0RxAXrOFg7MArMqjQVc56mqBZNUcI=
X-Received: by 2002:a05:6a21:6b12:b0:334:96ed:7a75 with SMTP id adf61e73a8af0-39545ed4a53mr7607282637.24.1771849968248;
        Mon, 23 Feb 2026 04:32:48 -0800 (PST)
Received: from LAPTOP-FDBL0TVI.localdomain ([49.37.157.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a73e1sm7454739a12.13.2026.02.23.04.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 04:32:47 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v3 0/4] mm/damon: Introduce node_eligible_mem_bp and node_ineligible_mem_bp Quota Goal Metrics
Date: Mon, 23 Feb 2026 12:32:28 +0000
Message-ID: <20260223123232.12851-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: qibbud14fzmof4xwbqddmiduypnqe5yc
X-Rspamd-Queue-Id: 9512A1C0012
X-Rspam-User: 
X-HE-Tag: 1771849969-751061
X-HE-Meta: U2FsdGVkX1/qd+PiPL2HEqK8J5+8s4ylf/BSQThLahco55ivZ8DEhZuTpRN9n3uHTUjeemySMpOBggs96NPC8GLfEZG4u4fa5dfr+B3sawOV2f8inxkBBjMyRpm8v+u7e5jTukFtFKuN0tGK5youz/fhP//L20CS9wC74hC7lcXRm5pvWNFJCcZxhyYuGfxQSBL38BSvBodmvBFUhYj6pFJN+5Bz2Ms4DPPeExqMAQR8iswRvDAguSj/u3CBK7KenlPpzbw1F3PwbX4xzLPQVjDCa6amh0V5Q60y25YlbKUxv7tE4yN9X5oyMO4ArK+pnIvt4OMIa6CsauQRGLyQZ0hC7r6h3Fpv5W1aTxyXgZspKBw2jy17meFZZs/le+k4eHXSLoAMnoXB/Lo0aCP3EyeCPaCU8N+BewCXLlrrATpvLP3zWOY1GiuQW5Vl5CRcT5ZZMHgfnS3hz7SmS/vS2QRUoKIqpzYzsgtpOSHkrVlR+pEU3vbJcJFiZajxNUHWJS/QsqB3dR0FZB4fqlN9w/IjUnYJ099EhJViNPCsC9oMf+nB3JiROJOZy83G9a1pqjhylJfoDdYMoj+vh+7/ulJ+hxZLRQg+9aZAogBxhVxF9lp/0wd/NV5GuqdcL08UH1ihOekfONxFkwi839g8TI+2BSKB+55MMr5TrkaY9YQujyoXU/6bBlSkA+pOsShgpIeeeedWrUlDSpacNzKG89fgoUNXDdwS0PAoqebYk7k8exbL0A6PtqTOViJT0AY95WGmqSDDg1SQmxJUOTSSTb0jDyq6Wu13cw16hEY/GHM/LVtl9u3e7kMpdwBgfJabT1UU0Jy+c8skfqHaGbzoTujfU1/xglBMeEDkeM4wDUeyQJkQWMFbKMRxVJbOhFkgPlc8EKhTl5hZvhl1HMIdOEeux4E/kn3xJlafO+759+LDYY6yhwKb/PeO3Ccfyq7kmilPuZtK5+3KLr0JBsP
 vwfxcQsG
 7MPH8h7F4n4jZmwiyANa0BghYqVdrv995pA6BluwYibXybYFvaG/GF/P1uLzavCZ5R4wrwUfM9YWLqd/LtOrTN+d2U6YUxDglf0e1qpwZMjt2Sj/B9cnPsw4qIBKtCuYtRHpZ/Oe3aLYxIQwKWAZdRaDumQ8ZXvxjAz5vNjqk0RqOTllHgolZlxeuTZFKhg2DrwKyCMuhKeCGkfoqPOJ3qX2hgrp8ENWqWVZuG5Q094J+Z1tF3YIzNWuEBVbQUml/IeyU9YKvUe/NyLQmJ1sbF5/X+bT1YrMcCxnuljcxVJrMGFr/fx0TSyd9YgebqWUP69jLChSa9els4oMDvLlUcO/6zi/ehws5ZqLNp4+IauEG71rApL/VqCl9YwFGAamhFmUxlhfo9ebhl4Fbn4AKGa//YtMKtHTkuWDbc2uPwN0dsWyal79QEzTyyJcpjQ31T0h+i3jka/+rEGfljKa+LMkXVhJ8dmgRNRqNVScsFuyBhBaKFg3vNTMEJlSyNdO/4EEN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000151, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series introduces two new DAMON quota goal metrics for controlling
memory migration in heterogeneous memory systems (e.g., DRAM and CXL
memory tiering) using physical address (PA) mode monitoring.

v2: https://lore.kernel.org/linux-mm/20260129215814.1618-1-ravis.opensrc@gmail.com/

Changes since v2:
=================

- Split single metric into two complementary metrics:
  * node_eligible_mem_bp: hot memory present ON the specified node
  * node_ineligible_mem_bp: hot memory NOT on the specified node.
  This enables both PUSH and PULL schemes to work together.

- Added PA-mode detection lag compensation cache (see dedicated section
  below for design details).

- Added fix for esz=0 quota bypass that allowed unlimited migration when
  goal was achieved.

- Added fix for goal_tuner sysfs setting being ignored due to
  damon_new_scheme() always defaulting to CONSIST.

- Rebased on SJ's damon/next branch which includes the TEMPORAL goal
  tuner required for these metrics.

Background and Motivation
=========================

In heterogeneous memory systems, controlling hot memory distribution
across NUMA nodes is essential for performance optimization. This series
enables system wide hot page distribution with target-state goals like
"maintain 30% of hot memory on CXL" using PA-mode DAMON schemes.

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining 30% of hot memory on CXL (node 1):

    PUSH scheme (DRAM->CXL): migrate_hot from node 0 -> node 1
      goal: node_eligible_mem_bp, nid=1, target=3000
      Activates when node 1 has less than 30% hot memory

    PULL scheme (CXL->DRAM): migrate_hot from node 1 -> node 0
      goal: node_ineligible_mem_bp, nid=1, target=7000
      Activates when node 1 has more than 30% hot memory

Both schemes use the TEMPORAL goal tuner which sets esz to maximum when
under goal and zero when achieved. Together they converge to equilibrium
at the target distribution.

What These Metrics Do
=====================

node_eligible_mem_bp measures:
    effective_hot_bytes_on_node / total_hot_bytes * 10000

node_ineligible_mem_bp measures:
    (total_hot_bytes - effective_hot_bytes_on_node) / total_hot_bytes * 10000

The metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.

PA-Mode Detection Lag and Cache Design
======================================

In PA-mode, when pages are migrated:
1. Source node detection drops immediately (pages are gone)
2. Target node detection increases slowly (new addresses need sampling)

This asymmetry causes temporary underestimation of hot memory on the
target node. Without compensation, the system keeps migrating even after
reaching the goal.

The cache addresses this by remembering how much was recently migrated.
When calculating effective hot memory:
- Source node: reduce detected amount by recent migrations out
- Target node: boost detected amount by recent migrations in

The cache uses a rolling window to track migrations over time, and
expires after a configurable timeout (default 10s) when no migration
activity occurs. It also detects when its baseline becomes stale due
to new hot memory appearing in the workload.

Dependencies
============

This series is based on SJ's damon/next branch which includes:

- mm/damon/core: introduce damos_quota_goal_tuner [1]
- mm/damon/core: set quota-score histogram with core filters [2]
- mm/damon: always respect min_nr_regions from the beginning [3]
- mm/damon/core: disallow non-power of two min_region_sz [4]

[1] https://lore.kernel.org/linux-mm/20260212062314.69961-1-sj@kernel.org/
[2] https://lore.kernel.org/linux-mm/20260131194145.66286-1-sj@kernel.org/
[3] https://lore.kernel.org/linux-mm/20260217000400.69056-1-sj@kernel.org/
[4] https://lore.kernel.org/linux-mm/20260214214124.87689-1-sj@kernel.org/

Patch Organization
==================

1. mm/damon/sysfs: set goal_tuner after scheme creation
    - Fixes goal_tuner initialization order in sysfs scheme creation

2. mm/damon: fix esz=0 quota bypass allowing unlimited migration
    - Ensures esz=0 stops migration rather than bypassing quota entirely

3. mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
    - Adds the two complementary metrics for hot memory distribution control

4. mm/damon: add PA-mode cache for eligible memory detection lag
    - Implements rolling window cache to compensate for PA-mode detection lag
    - Adds configurable cache timeout via sysfs

Testing Status
==============

Functionally tested on a two-node heterogeneous memory system (DRAM + CXL)
with PUSH+PULL scheme configuration.

This is an RFC and feedback on the design is appreciated.

Ravi Jonnalagadda (4):
  mm/damon/sysfs: set goal_tuner after scheme creation
  mm/damon: fix esz=0 quota bypass allowing unlimited migration
  mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
    metrics
  mm/damon: add PA-mode cache for eligible memory detection lag

 include/linux/damon.h    |  51 ++++
 mm/damon/core.c          | 496 +++++++++++++++++++++++++++++++++++++--
 mm/damon/sysfs-schemes.c |  43 ++++
 3 files changed, 576 insertions(+), 14 deletions(-)

-- 
2.43.0


