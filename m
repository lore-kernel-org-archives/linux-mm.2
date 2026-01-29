Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A37FD73E9C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0BE6B00AF; Thu, 29 Jan 2026 16:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EAB6B00B1; Thu, 29 Jan 2026 16:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7FFA6B00B2; Thu, 29 Jan 2026 16:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7DAB6B00AF
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:58:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FE94C1D66
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:22 +0000 (UTC)
X-FDA: 84386365644.17.C4D3799
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf22.hostedemail.com (Postfix) with ESMTP id 788BEC0007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:58:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OerDB1dC;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769723900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C7ZtJvE3dpFWqwjZMa9omEQRwNhNuc19ZVJnJ8avCkY=;
	b=k7ig71yzjLXRbT3YXXIS9TyevJElc6yS38QMy1g00tx9UQKHdLvtDRF0K1u+c5aW5rg+3q
	JZzXF/E6BjkMbsT4c6f4l29aiC1pB9YdZ7+4N1pgZMpAG4eQ95uDimoYZd/+SGL4k3ycP6
	Ya4aiRSuSnlqOJegB8eUI9bl0f1hifY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OerDB1dC;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769723900; a=rsa-sha256;
	cv=none;
	b=PKZIXEMNUNIaOd5Y3M2jMce8ULr8lqIaDnMdOR8HdYaVmaj8O6N3acvmfOxdN5UHbfkD1g
	B7OiXq25PmKmVF1IF4U1+6GKt3vKKvstr95RQRrLDA6qhZ111QRcV4gQ4/Jp7/lY9iu/Ea
	8s55Gy5lO3mgyLk/5++z0ihc20Jzais=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-1233c155a42so2488077c88.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769723899; x=1770328699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C7ZtJvE3dpFWqwjZMa9omEQRwNhNuc19ZVJnJ8avCkY=;
        b=OerDB1dCfnotDai71l8ucw338M+EnJbdUzpLS60PxE1nIlMc4ZOvl3d2SjHZH+cMlT
         jTU8fkAFr+Kik5ZCBfR9Xst0vb9XF1+VoNYik2KbtxkMk1GxAflAkOhVqg7RDjDDy7jq
         1VU14MEJiP/zRCXmHNJ1GR8FosKfBrjKgIPgf1/ucVkWa8xVnnYYDMKGkgwnpIxXk2Qd
         czdIdSAWVUK880xCHrMIQxwf6fvp6iDj5iRXqz31iaEnIikinx0jcdvN6f4/mzV1xYr9
         fKyUhHPs9sdyX2mM2X+sKkKaKRnzG0yxrZhKnTOr3+shh/ZfThJ1lWeHh5g4jCBXxvmv
         937w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769723899; x=1770328699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7ZtJvE3dpFWqwjZMa9omEQRwNhNuc19ZVJnJ8avCkY=;
        b=kJzqFvzD4rGRRVCz1bDAKsbSZJ15MdObdkLVBay+8QNIhqmNP8ZHDOWNti0JUmInnF
         +0KaOhB5T6vBOhXMBEWmIGSCwMut25Fi/3G13HRDGbrCNFcPFwJDxJw5+qoQTDvL4uNG
         wx8sAfSetZd2wPNCYP/QDNCqgkakZn+Zy2bQs1Azaq8JbDmQnYHPjBSxmVZcENKVUhzQ
         DPShPuarYTkRX9zwpD2v+VP5D3PeFTIdRT5eWzylYr3LzAvN++Pfc5OA6T7z4JTdjU0i
         7s9m3rFCT1HvmZXzxYs1be9euGi7Vc/hyy9AGhd1ZVIsQ2QetDPy1NRLwrz+FfT1VUEI
         W4sw==
X-Forwarded-Encrypted: i=1; AJvYcCVr2cEtIkjiuV2WoPenB25P+clr0W72Y7jUVZSMhSPqHJaEfAJ9ECWAyl9bLtseHRdITSPxiiY4lQ==@kvack.org
X-Gm-Message-State: AOJu0YzjyjdhbEVinTabcNwJ4m2ZgOh+iW0nIfxbNY3M+8LxlnV64TuS
	0fA1R/qvC6/GiGFi2BQH58BAeZnL9ix9n93d5WpnzN9VyHbi58oZXCU=
X-Gm-Gg: AZuq6aJBTdXIvfDuA26DO3opzAA6iYb+9yV8XJz5kdN0LmDBDqZGGlmCClpTCXXGMzE
	25jCGthomGVjkSX+HJLyP6n3M67HvM1eAisjn9qFvM1NJDJP0DjI22YzFvIVL1d/ghXFR6O+rpY
	S9HPlSb08g+tdNN+NEMLQee0SeXPp4+q36nqKmTnjoXB+3El6U/bqwL5Tn6O9LYTQmDrxKNrQIr
	2OLWPxQ7u7auPeIzl6uCue+45HTbh8Y8hJT2rtLGItIigN/lGJXebMYGL7o44y1xa4NnOU6rKML
	ogCsjTzBcZDtbopkbJI7+CRB72yO5UUfV40h46PPX/fEiR81w4aAQPdAl7qtimUhbt/ThuJxdNY
	uNbXSIeHos/CPK3Afv4UbN2L95VT8IolmRgtrzyWwD3VMcOnzHGWxukWHEV9HhBmmnR2MDEjMlt
	Vg3ayoTC9obw==
X-Received: by 2002:a05:7022:68aa:b0:124:a610:62f6 with SMTP id a92af1059eb24-125c1006e73mr427951c88.44.1769723899034;
        Thu, 29 Jan 2026 13:58:19 -0800 (PST)
Received: from localhost ([137.201.204.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1af8a7bsm8593035eec.34.2026.01.29.13.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:58:18 -0800 (PST)
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
Subject: [RFC PATCH v2 0/3] mm/damon: Introduce node_target_mem_bp Quota Goal Metric
Date: Thu, 29 Jan 2026 13:58:11 -0800
Message-ID: <20260129215814.1618-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 788BEC0007
X-Stat-Signature: dth98ja1c1sockzbg4ujhoffba3g6w8g
X-Rspam-User: 
X-HE-Tag: 1769723900-257045
X-HE-Meta: U2FsdGVkX1/PkPul3HCOXZueBYIlpXP9ZrWYHeeQC1rq+KBng8wYa93/INnHzf7iiYufF+7e3bq74NkHIZkqTRnsRMM09kFcs44CBwjg2ySw7Ny2GUf+uJfwrIIifHSTk6/Dfc0XiS+bo/6S0UBk+8PmCYUwse/7V6sHEwDn/gPF1Lcrt6xb5BAVhK7qZBDnFHFFLMPntb+jL/WRZqrEdxbVpcS9+Lbuv+GwTi3pLOxrQQOW/jisn8PXtHzVowa0dZjDKNQzrSS11i0syCG8USBSYZ2DdCKpy8tsa6w4+dYPhZQOYfsBIXtMOQ2ErPbW0MhqRVRHsW/h+R//TIsImk6+Ju31x+JaNJq7s6urMTUf/tbBngyEJQU/B0/QighcqeRzvKgfHVn8hdxJFm296Sy2xq18X5VCuBaVtN+WtrdgULlQc2z/sMFKfzHiw80cLMiQ/do46qrC87BT4YVMAi3fUvd2cbw7P1HXQKCKBMty5uz2j3efgXbEEjB1l2Xku5BnDAqWGMtpZvSwq9DdIeQFd+VQBpMCWYk1otiHyWchyBcYShN/eM3/GYbbn0N1b6UPwEPbTe0e9PTNUUqdx1wkahbLsL1j55kcr9ORghEcbFHWyG7Zt7ff8mMB9nDYEs8K9nVOUKGDTWTBWqaglZX1GEMDVBTz/3dcWpLbSxgiBzGSPQGFP1WguoUPDkkn3uyIcy3wylZhWYEx8+NE+7KIwA0kVj6DNhsa1jzq76A0Td0aIUhgC3GVc/SrLnEjA/lbrTmYYcciF+HsfMhzM4oz2/C63pPvpiksvC/UJpiLk9ea0eirrKxbN9a66TgXNAH6yK3bkTd7vPOz+P/QWqmQHvqUV91P4w7fQmO7/FLKalVG+Zo8KpGJp/OwCiW5I+5BtwCUPiSLWhQOO9e0yZy6RtrtUtcfEXj7VdDgITr/0DHERPQfMlwP9VWxCtdyhsH5ssXhKvk3esdpaVS
 ar3nC3wP
 BYGZy/XyXnKeoeCIsCzI+uYkY1PjZJrcxhdTPe2vRl0vtCiWntoXf/h7yc9osbCC4dBEJ2RPr2fXn+WgWUhg8Q+pwq5HU2s39WepBXkw0TSjbPtxZafBaMnpN/dpzbTQ7Dx0dvwj3pyWLDRuGFJbm/6LHs0raQFzcxY0V2ix91HV4YvdLIHcQ0VHZvBmyRkWy1+TrnB9eWb1uCKoz+DvVR5te53b7zxU8GQ6sBdVOOcLcNIsVUO3AWDcYSjb11MOMURm8FbU+EZ224tuAhMZdxmpbOhynDjTnDjEoPnkpc3bdvESRg2kcfdJa1KoyaSLkE397DRnALHydjflEJ3WCN3qt0Glr+b9F2iLLG3457gaMVVZ4x0xWwRzSdvvWXN1Kq1cmlqsHS9IQKcGaExHpc/OaAnX+EH2S0f1i83hTMPpJsCcvmUKZNOwPOmlD4QTOd01kYBQD2O+wfmZ1as6qXKniQBFODmW2gWWSizNHnkdVwtBtmlZ9D+ZjJ1pxWSQgj/OP/0iZ4dENnQy8wgoO05N4hGpxByWOVnD1dSYQt9DVyakEi7KzGPvTuXHazVy003i+X+PhoQxTJIoznKHaTAULnIR0Tg3FKOU9K4fp9pQdNTkXBXXnSb5FHALSxL9hZuZVvIroXwEtNzdSLX4YQktS1HLVJY6fnaBYhH+6Ws+ZS7PXH8n0sIRszw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a new DAMON quota goal metric, `node_target_mem_bp`,
designed for controlling memory migration in heterogeneous memory systems
(e.g., DRAM and CXL memory tiering).

v1: https://lore.kernel.org/linux-mm/20260123045733.6954-1-ravis.opensrc@gmail.com/T/#u

Changes since v1:
=================

- Renamed metric from `node_sys_bp` to `node_target_mem_bp` for consistency
  with existing node-related quota goal metrics (node_mem_used_bp,
  node_mem_free_bp) as suggested by SJ.

- Fixed the metric calculation:
  * Numerator: Now correctly counts only scheme-eligible bytes (regions
    matching the scheme's access pattern criteria).
  * Denominator: Now uses node capacity instead of total system memory.

- Removed the get_goal_metric() ops callback. The implementation now
  resides in core.c, following the existing pattern for other metrics
  that have ops-layer dependencies.

- Removed the early-exit optimization patch. As SJ noted, this would
  introduce a behavioral change for existing users and should be an
  opt-in feature with a properly designed interface. This can be
  addressed in a separate follow-up series.

- Removed capacity clamping logic (was tied to early-exit behavior).

Background and Motivation
=========================

A previous patch series [1] added weighted interleave support for DAMON
migrate_{hot,cold} actions for vaddr schemes. That approach requires VMA
offset information to determine target nodes, which for paddr schemes
would require costly rmap walks.

This series takes a different approach for PA-based migration control
using basis points (bp) target-state goals instead of weight-based
action rates, avoiding the need for rmap walks entirely.

What This Metric Does
=====================

The `node_target_mem_bp` metric measures:

    scheme_eligible_bytes_on_node / node_capacity

expressed in basis points (bp, 1/10000).

"Scheme-eligible bytes" are regions that match the scheme's access pattern
criteria (size, nr_accesses, age). This allows users to specify goals like:

    "Migrate hot pages until node N contains X% hot memory"

Unlike weight-based approaches that specify ACTION RATES, this metric
specifies a TARGET STATE, which naturally prevents oscillation issues
that would occur with weight-based PA migration without rmap.

Two-Context Setup for Hot Page Distribution
===========================================

For distributing hot pages between two NUMA nodes (e.g., DRAM node 0 and
CXL node 1), two DAMON contexts work together:

    Context 0: monitors node 0, migrate_hot -> node 1
      goal: node_target_mem_bp, nid=0, target=6000
      "Migrate hot pages out when node 0 exceeds 60% hot"

    Context 1: monitors node 1, migrate_hot -> node 0
      goal: node_target_mem_bp, nid=1, target=4000
      "Migrate hot pages out when node 1 exceeds 40% hot"

Each context migrates excess hot pages to the other node. The system
converges when both nodes reach their target hot memory ratios.

Complementary to Existing vaddr Migration
=========================================

This series complements rather than replaces the vaddr weighted interleave
migration:

  vaddr migration (weight-based):
    - Per-process control
    - Fine-grained interleave patterns via VMA offset
    - Deterministic placement based on weights

  paddr migration (bp-based, this series):
    - System-wide control
    - Target-state goals for node capacity management
    - No rmap overhead

Patch Organization
==================

1. mm/damon/core: add DAMOS_QUOTA_NODE_TARGET_MEM_BP metric
   - Adds new enum value and documentation

2. mm/damon/core: implement NODE_TARGET_MEM_BP metric calculation
   - Adds damos_get_node_target_mem_bp() function
   - Updates function signatures to pass ctx and scheme through call chain

3. mm/damon/sysfs-schemes: expose NODE_TARGET_MEM_BP metric
   - Exposes metric as 'node_target_mem_bp' in sysfs

Status
======

These patches have been compile-tested but have NOT been tested on actual
hardware. Feedback on the design and approach is appreciated.

References
==========

[1] mm/damon/vaddr: Allow interleaving in migrate_{hot,cold} actions
    https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gmail.com/

Ravi Jonnalagadda (3):
  mm/damon/core: add DAMOS_QUOTA_NODE_TARGET_MEM_BP metric
  mm/damon/core: implement NODE_TARGET_MEM_BP metric calculation
  mm/damon/sysfs-schemes: expose NODE_TARGET_MEM_BP metric

 include/linux/damon.h    |  5 +++
 mm/damon/core.c          | 66 +++++++++++++++++++++++++++++++++++-----
 mm/damon/sysfs-schemes.c |  5 +++
 3 files changed, 69 insertions(+), 7 deletions(-)

-- 
2.43.0


