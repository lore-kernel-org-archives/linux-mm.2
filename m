Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93BEE88D73
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 01:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53826B0005; Fri,  3 Apr 2026 21:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B5E6B0089; Fri,  3 Apr 2026 21:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A766B008A; Fri,  3 Apr 2026 21:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF016B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:22:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FE8616040B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:22:24 +0000 (UTC)
X-FDA: 84619123008.17.9C28C8A
Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 61F5DC0008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:22:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hhJb57Qa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775265742; a=rsa-sha256;
	cv=none;
	b=J0wUe+q2JZ09K9cXzzNN4y8hnsrxh9ZmfWwIErGZ/O4pRPrV/uKFSB9NNiW7CWW2Q1fUpP
	N5M+k/cbu9as2HJKphe2EE3U7oA7sozso61gaU5GIzWwOx1X3pnZ4gVfg6L1CP4iPtEb8I
	fK5yphNr0Zb3RJcRn5MoMccNXQKO+6o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hhJb57Qa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775265742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pcK6sHgPs6gP5Y6uAT692eRrV9NjZEVTLIRYHBLXl5s=;
	b=WzJPS23HvV06c3wToqMCjNULEgs+rjjEH8zwIgTXMZV134+o64eW7QTbmaTChYzGxjKc9r
	53UoWOxKT+K0foK4F1jGt1/J76Wc3wzqdaGlcClkJFIp4PJdxL3Th4MuZVjv+QH50hQqNp
	YM1SLECvK46jUcI2CfoUa9rOFFZbzDE=
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-4152698e745so979347fac.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 18:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775265741; x=1775870541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pcK6sHgPs6gP5Y6uAT692eRrV9NjZEVTLIRYHBLXl5s=;
        b=hhJb57Qa/Y9PWHh8xGlDxG3d3UAY6/Ktjrl/1JSlD6V6z/+/GeXnC/oTtwX4CPC3Ol
         vI5uRNH983eHhg1KEs4w5jUjfgEJduC37iB3t00Brk6lkGJKctuYPiJT4/rbMNZdQEec
         pPrcxSnQWIFQYocoNS0OanmOX9g8bnkvdiYopyv0e+zxkaMdJwYP9Z2hMzz+ebtDOmwU
         xWFMQW4hks/RcB6N27zxRTt8UIznCo/TKDjTyM+T4WNs7aLzWQoY8OjjWnqvDa6TJZme
         VZ4AoXljs2sTMJ2ZXOv8M7Lu3MfgOJUXgqwaMXa62LFLhuAvHIYfi90eTS1gL7+Q6lZW
         QT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775265741; x=1775870541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcK6sHgPs6gP5Y6uAT692eRrV9NjZEVTLIRYHBLXl5s=;
        b=ZVHMRHMVH1FGQ73mZstJtKbitOP4Y+6fhBYzOQEsEIIoEtYBx2DI8kB4wTFjQAzifn
         YgLtTFsHQcdfO+nozR74iG40jd53XS1c6wbAFIo3IjRz+hA6wSyaFtTWN+6CEmZiCaLB
         kV5wE+fuf0E8AmpiY3ENZRbMVk5Xr+d50C+Bpcsjjcrn8fQYYsNZyUGDUhuXmW1dnPxj
         hEA2b2tPjyYf7Wu1Z7m8Agvv5k+HU1HyCaUiqpWU/YJ6Vraefj7sWFhS75ONDdICON7f
         TwZp001iP1dXkN2flQLjB6A3d6R0846jiIgEPjtybLKdjqtOVClMIBvkz+zE9pxEk8vv
         IkFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnNzxS6OLQbs558Dya+Lp7BBgOTHFWqElgDQt/+4qGvM6SAWJzVfODAd0mHWqn5ul6Ez7P/C0Usw==@kvack.org
X-Gm-Message-State: AOJu0YyRB3oyu9EjN1LHC1t1379tqRUCk866+Z0WTf313ch0UU15r7/V
	yZ0QrEtbNBG/6+DJsmTFChIn4JqizaaHsl/GL43oMisEKuEINblI/PU=
X-Gm-Gg: AeBDiet4TDw4iZKDuf9zmnkvjHzvMi5JaC7rlKV+ZkdqmfjyQnqNOQTMSCMaCQSykSO
	JUyvXF6yl5G3MxIPt8coVymHe0xU19Am8jd2m+2E1BQaDHtYoNi4B6Zsv3ztFOgDJJWL4pa8vZP
	zfvSaB819fwJZpnqF1plSkM8yRuKRtg6pEij66r1/mvTZh2lqHHMm2Hyegu4By5zvSofNbvFPbk
	u5YspDjJNjW/rm0B7DYhdPBBFnlAfbwmPgNxsLpnYk3yeDBmnBhY++aiRa681RzI5y2kWjKfocC
	ShIUnwT0G8ZwNKLzPwziN53WUSn2/dpD+Wjm2z40g2a9sn9sk2kXnVndB7ygHfFfHvpqo3/psyM
	PiSiuQ/WqsbU2ZRSZwo0svkBXquxr32egyt+Uk9lSbRFZPpI/QOU3Ikm1bg81oMjpiTPWyxUa40
	/V7FqWLnBznQ86RJR0s77UOg==
X-Received: by 2002:a05:6870:1718:b0:41c:b780:93c with SMTP id 586e51a60fabf-4230fbedf40mr2606467fac.8.1775265741311;
        Fri, 03 Apr 2026 18:22:21 -0700 (PDT)
Received: from localhost ([108.147.99.33])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb3c8282sm6117376fac.13.2026.04.03.18.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 18:22:20 -0700 (PDT)
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
	ravis.opensrc@gmail.com
Subject: [PATCH v5 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Fri,  3 Apr 2026 18:22:14 -0700
Message-ID: <20260404012215.1539-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gyjqdbsnwmyjdy45hrb9a9nx3docz1sz
X-Rspamd-Queue-Id: 61F5DC0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775265742-894141
X-HE-Meta: U2FsdGVkX1+rRiVVOwYMI6pISYSIugHUX6qVYOAww0VNZfFAzHiCjOED0XnR9pB03dWug61Uh0zrCxSKEMbdbnG6moX8KBzFeXp7fL/q/kMoEszu+dOdRT0SogZKbRRqjf+ZnL+jV/IXDIQn5hAqqG1S5TufxQE5ToSipG2cjhQhk7yyWgm2o0VK+MVX5CPUaW8sO5On44CiHCvgxwva2+YIyVvINdJKmTAECIobufewvgvOtlrqFAWaiUrMogWL/GjuBtkvv21+rmpIvUpzy1TAYcvBocd/uj6PZCl1OLtAGba3yHq1XvowW5LwstgtiZckSY3c/mPtAGCZVh1HRK6zv1jCJbEm94R0GsfYNNZMbc3zdqvSbJg8ZxOAT0YXJGUdtJmelhFE2cix4CWqh8DQayAeqtxBFioeQTlFzHfrAESFVFD/rSeP5Ni4wNXnRgrHUtPgBux6klF9H2dhYb2XN9kKlcHwBjdoA8gnv64EYYwkiUgkM15lJb/pEsypZcW8wF7OMTPZER2KjDpYL1yrGsbNA5fUFlw6KzwPMjpJMpdbUc8zqWqKJoL83yNCdM9wzWAJwS4gZgTwVHlVGbt5I2RBYo5V4lzel5gmuEjkFfXr79Yj8doVTbCT4s5720LM31060pUHtzIGGuoJkWtV6pcHaNi1b07/VGYtl4dEq8PcafaMbDYi7WJLfG7wD5nPRQbk4PC4H6thu7wpLyW4rwra4s2Fz6Oi2c87Nd/MttWP8Ufjf2gbYq1ufiH8eBOiVLlavVrDGKZW6Nu0iIqMrx/KSPjNvifeHDCIKzpl2YGLRr4mwx0aZXA8GRhbhkUzTLfHFf4bc2T4/M34Lrk+FP79q3tmvJicU+iYBl3vppLQQqqH/mbBMkeS1s+dSNUiBkl+wUe/4nLAg/ToVuzYH/cWUBhPPz+v78VOhhaQUeBxW2OrNltlo4wbBcqV8xf0EjTuAuQlBeAp3Jd
 Uq7tgGkq
 C7BxYHymvHLufrraqc6KKTrB35o3t6hQ9L9o1Tit4dGvWS3rZ8DYVLSFmrzuAUvsrwIzwwcEXr9aUFM2o3R4jbWiq6iETeXRaM1o2bMHrfHfsAxHNlw/CThecxOEgNAF/K+fcJfTTDh93/jFJOXqbRuyaRq9VVI1f+O643n6Pqi46U+3YXkWsoZxxIi9ciLkdF1h303OvOZaxzFMTgztBmaM1Z9hXZVNA4pqUGjP3BG3lUTGlkEhxybPH8aMjzx7luf2uD5uikY6lma6m73DvwWDpAnsRzAHDjykIhVzymADkpNxeHEJZJfvXOr8WI0hvGYKf9g4DCY6hAH2Ee7Gd+myJ4Z9dQnaBRn+6v5/UV79GCCTOI8YSgY7otUI72Ycy+T7wM5nnRy48KYEzePhRnibaPmmd/i3ursVITPzC7Y9KNKC8MDHsJWbfbqsbDLi64s30s1IUPPD9qzUYjEH0GpA3ga44FXbSuBXCgN2UEOy7clU+W0FHX+JmYl7JXQl03iFtFbTOLSGYo/dytRrKZF/8KGrfXL1oIPXVMSwISgU94vhZcYOE3KN2BlGwQvpScIEbVPLRl2eF8K9g2a04cMojeOM/LZ5MH1RJClK2mUsJVGCTq7BWTle2WNKVJfmkVfUav7gszzwW5mM1elexMuURLJjNlKbZNBDCs6AIVxBKd3M3KZ2qFVuinGTEyx/JXX8P108e/Xi/evJV/01k+3ZWenkiPmMcpDPL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces two new DAMOS quota goal metrics for controlling
memory distribution in heterogeneous memory systems (e.g., DRAM and CXL
memory tiering) using physical address (PA) mode monitoring.

Changes since v4:
=================
https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/

- Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP
  per review feedback
- Added clarifying comment for ops-common.h include (for damon_get_folio())
- Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
  #ifdef CONFIG_DAMON_PADDR guards around functions using damon_get_folio()
- Dropped RFC tag per maintainer feedback

This patch is based on top of damon/next.

Background and Motivation
=========================

In heterogeneous memory systems, controlling memory distribution across
NUMA nodes is essential for performance optimization. This patch enables
system-wide page distribution with target-state goals such as "maintain
30% of scheme-eligible memory on CXL" using PA-mode DAMON schemes.

What These Metrics Measure
==========================

node_eligible_mem_bp:
    scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000

node_ineligible_mem_bp:
    (total - scheme_eligible_bytes_on_node) / total * 10000

These metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
ratio:

    PUSH scheme: migrate_hot from node 0 -> node 1
      goal: node_ineligible_mem_bp, nid=0, target=3000
      "Move hot pages from DRAM to CXL if more than 70% of hot data is
       in DRAM"

    PULL scheme: migrate_hot from node 1 -> node 0
      goal: node_eligible_mem_bp, nid=0, target=7000
      "Move hot pages from CXL to DRAM if less than 70% of hot data is
       in DRAM"

The complementary goals create a feedback loop that converges to the
target distribution.

Testing Results
===============

Functionally tested on a two-node heterogeneous memory system with DRAM
(node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
migrate_hot actions was used to reach a target hot memory ratio between
the two tiers. Testing used the TEMPORAL goal tuner available in
damon/next and mm-unstable.

With the TEMPORAL tuner, the system converges quickly to the target
distribution. The tuner drives esz to maximum when under goal and to
zero once the goal is met, forming a simple on/off feedback loop that
stabilizes at the desired ratio.

With the CONSIST tuner, the scheme still converges but more slowly, as
it migrates and then throttles itself based on quota feedback. The time
to reach the goal varies depending on workload intensity.

Note: These metrics work with both TEMPORAL and CONSIST goal tuners.

Ravi Jonnalagadda (1):
  mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
    metrics

 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 186 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 190 insertions(+), 14 deletions(-)


base-commit: 97eefd14af390e1921f1fc5507140025095634e0
-- 
2.43.0


