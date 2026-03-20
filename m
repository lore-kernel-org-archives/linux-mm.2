Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3317C1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A2D6B0145; Fri, 20 Mar 2026 15:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521EA6B0146; Fri, 20 Mar 2026 15:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438476B0147; Fri, 20 Mar 2026 15:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32DC06B0145
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:05:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEE01C1909
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:05:01 +0000 (UTC)
X-FDA: 84567368802.09.B5A6F75
Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id 205D6100018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:04:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXjxkTeL;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hrbpczjmQlWdU+8xGkQY54294j65e0aZRYcB8uO4mU0=;
	b=q2UQPMQ5QGwmUTzhrqYoJ7zwS/HlhJ9+k1L1h5ETAEEGxDMaJMQz/VB+T+bcwOgOOPEeLK
	JlJUH7ojjjo4KTjsTG5mLlEaihZ/TAxKHkbMQldg8xjhAPh1g+40PVVU/VHCO2UUfmp1E+
	GQhHS6v+LPEbQ+6EnEkNTxVWYopOCRg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXjxkTeL;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033500; a=rsa-sha256;
	cv=none;
	b=PzT6L9WnrGcrPXf6mbZTb0x17YKtK0y55tXZ0rnAnv9ltakZ23tl8JEl9tSC+jagX127GO
	yGtDm9V3X9h6f5HkwlpzLxOvdhiQBlLOcEb6YqNz6UUEtIoPwQthR69ybyUkqs1A4rQnox
	84M16dWpz/2XuqHwspnRbcnkFUAzETE=
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-64c9707fc11so630555d50.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774033499; x=1774638299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hrbpczjmQlWdU+8xGkQY54294j65e0aZRYcB8uO4mU0=;
        b=dXjxkTeL7rAMbOSS/Yxw/pq2pY4zhnYwKRyaNDBN8mlEv8kK+kGzrRaFc+aEpn98OJ
         be6UhKgrMQEfnT2xL43VCMANFajTp34gQSaMXBW5i7Fwog7EO++Yar24QrtqKI3ZV14r
         MpPy2oPJTpVFBhd2Fv4rt04ah6sRybLYkC0KUraQmiz1RKX6lxBdg/CTnXPtt1W6mYyc
         cqBvLxVBrtcPF7PmfgCGH7D52nlzIAHOSTwrSzQLex0Sc7d7FQqgChshlylUuAxPLmBE
         zL35gCaJj7d5NKgCS6B8QRsCryxMD+JZ6y9QDy2K0ISVfdWljgpOJaxYkeMUXCTa7lmF
         eDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774033499; x=1774638299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrbpczjmQlWdU+8xGkQY54294j65e0aZRYcB8uO4mU0=;
        b=dF+NM3WaZklrPp+TNFH8Yd23soXcC64RPY/B35xYxSGS47DcSaD0lrrTMVm5bW/UWW
         sFN91dzipwer8Qxlv01RqyB2SEdo1NKUJNM/j10/43XoM8H1GMy1hjERUmt1ezT/amj9
         6gFO2yGwQ/ka24c5FDpFYG6qpf0oJuoQs7P/HZk4AA0PjxG7zOlEatwkCh84IUaEXebP
         6MGZP1CtQG7IAHoHQSQ1iJufMlIIyeWUjoDcVYBIkJAtd01rbYGFz20ZTzlV76kpqhfn
         8EPHoyhYYzyyksbwaMUu9Qd8SRYDvFTciZCL1ftqwbPnbu9cBXGNW4u2SLvUuwLdf8bT
         F7Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVbxvs9ZneW2JlGXzK2l6Rj/tPFuWnP1dEL+vbRTEnKT6Gi60YJM//HTcVa5tjdrhv2/52UwhW9Bw==@kvack.org
X-Gm-Message-State: AOJu0YzFUKxLlLKXoXmOTxJSGBQTbCGS9zIQS2brga0sd3TUtXHOsz0d
	re5P1Mg8/qtwaNgx0kT961LTIz4iuSsApiYp8hb3mU207kvaWYBJWyg=
X-Gm-Gg: ATEYQzxmR8elQBdAmch94HMdgvOOa1yf5k1yhxOT6tRW8KIlYEnfwnNa3qIczl0lNVd
	ZqE4jinDKhU+wsFQg3IeoTfsX46nPEfddt2X9OICWW/k5VjgGAXecAwqGZKyM5wd0Q1Gti6PYEY
	edx34hdH44pDBMMWY9P3/akKgcJ30cggYST7IfLkq655SbBuwtD1g0ZV9r+OQFaEEzlKYJ76/re
	/BUhZ1KgKf8CK/4YFX/K2dFNGOSfLLbNobwnsAr4SnOYvbwhpMDePRDCne8w557xcDSr3MYYuax
	tNgQ94Ehoicv+ry7dzd7VavNkvyiaIFMkxf1FXD1n2ovsI8rkGYyD9SreIJxizck5sdkInh0FVj
	oz7+EN1ax8v9wEqcluN/5ZK9j8LxpkImgHpHoB10eORzeRjEELBaA/9KABNj+1Tz+vaCmoEIPZ7
	FkCZ7rb7vyx+G1B6nyH9sDhbkMrK1l5qKwEjbbnHLlO0Zo1o9TbHIU37qdwvvxvL6QLC6PQTgiG
	g==
X-Received: by 2002:a05:690e:16e4:b0:649:e501:21a6 with SMTP id 956f58d0204a3-64eaa6b8bdbmr3383035d50.16.1774033499004;
        Fri, 20 Mar 2026 12:04:59 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabecf140sm1983409d50.17.2026.03.20.12.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:04:58 -0700 (PDT)
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
Subject: [RFC PATCH v4 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Fri, 20 Mar 2026 12:04:52 -0700
Message-ID: <20260320190453.1430-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 205D6100018
X-Stat-Signature: eyzut7qysjy76b7ikb3ugphwqysyj89e
X-Rspam-User: 
X-HE-Tag: 1774033499-881481
X-HE-Meta: U2FsdGVkX1/O2vxxgo124vGTIyC56HjHlqQ7h0HVzYjW5xIoEe9pU4oWEZuyBVkNySFHYwA1Ifubundy/qxTSI6ckcNL5luCMp+Fg3SNuaoGCoZW/XS7Lti0cSUANpMFfVO5dr6H2LGft+cuOCFrz0PLEndNndzUifRWeru6AcvMBukAYJkjg/yfFOiyPiIMzDUZo5CVumYeYBXAsLaRmotGAthEruEwNzNvLAojltBNTG8JrXwBAy/VeOSpAWLmJa7jIz3GamHaOUg84pEAKTD5sFsgKsdW5WgrpUWsvuNx3/J7clBpuYoXpwZGiCUQSy6j0V0WcTR0ZcAij4yp0YZqMfJq9Oiyr9ikazdY/glLCeba5XnwqiMXNL168ehTiBXZnqIyry2fpbAjsALS2Lwj5B7ku59jHn9Q5N60ZQd0IeMG6NhYLLHCsXWNFhNTfsG50wTJRe7mubL1Uqv0goD5/uZnKarTmtPKOnt4qb+UxywvoO3eMHwKMODoXMFE0p2VA6BSqShw06lNpgfeCdF9X98wojku/HNz69MeX0fBCzpiKpzq/VH0ZU3TGVSryauzX/L+VON/8NnEpFCqDYdg8kFTXN8+M9/3QyZ3EqzWdqMAfXwzkJrKcXasNO6tp/oUuWySOiKnk4HRCKOwb0vtPkldg2BhrCX3EDr6ugBXSICnAPV6mAWawWhpIGIPcHOxOkul4SqecQMrf6yGQg4FYvSzjlj8kklxoXMnVTG6bWJ7lmQsjXrEIcFcCQhnAw04U44jaeqfZXGhwglO1JwY3BUjTuEwGAhT2x4+UcPU7QgTc/n3Pec4LFbhCvHvapyXTpG2sM1MgE+6vLZxGboabqup0x5QSZAaStPr+sI/OxHgDl0ORFAyp3sl6fN9Rz2O4c8aX/iTg4NYrYCylGYdtHijm5BAHTHjtpXduxw21SGhliPHWvhkEPi6niwnm1yVaCC2bIKr28hqvij
 fy7qQdEx
 AnWzf+iXa7s4DIABYhr9poe4+H1ykT5sB4F4DN5vNZ84wFbCVwekHllIWItmcPrPB5NwDmBoi/q2fZiWLFMhD5TIwiAsL/on9sBwg9ol7uGMQ5D5YMwzjv2+VbS0NhUIBw9qb39dHfrNjT83DNob49XYAh+GXKREuec1BwZwFi14pTt6+vNOwKp2KHApgIiMMgwnQlbAZ3GBVYC3HP6yTUEr/hTrp00+Q4QYmb8sPGawskCxzczo7n7t7C/dzM5MM9sTW7bNOoDKs2wojGkTyMLBGVnuGLSQ9+C4kdl2AGLMy3ufIvS4oaP2biPxMOeN5uuq7y8hFVkWuGjmtDvXJtKgMrztdutCp5lE/NJAtLkRp71Ojoawd0PP01dqdZ8qONZ/kDL/jSK9HFSy04pAqVtX57VwdkusObCboK18zJABovsnCqOIDSErft9uZrHBOYtMTIbcX2G3vf7k9vqbEID8CdF2rZQM0lVPXDL2efQUV7fJKm36J7jjQlj3bGAKa0efxCroT/PLVlA2rey+c2TQ6YtowII4BNCc+AjX6T78tQ095MgU+bl2z0FnLwDb7eHecr98CuGNfJQi8S96iLPZa4TtEdPsN9pyoho7d3Wv5R+E7k+6QmJEXN4IJCNlzYaK2/bBFJPq69JRmPaZHPE/lDM+2vtWPARNuhnCMQdcNQmMyPLMNUkdmdF8PnksnLjb+PtsyToyXsKkGRXEq7ApCpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces two new DAMON quota goal metrics for controlling
memory distribution in heterogeneous memory systems (e.g., DRAM and CXL
memory tiering) using physical address (PA) mode monitoring.

v3: https://lore.kernel.org/linux-mm/20260223123232.12851-1-ravis.opensrc@gmail.com/

Changes since v3:
=================

- The first two patches from v3 (goal_tuner initialization fix and
  esz=0 quota bypass fix) are now in damon/next. This submission
  contains only the core metrics patch, rebased on top of those fixes.

- Simplified implementation: removed per-node eligible_bytes array, now
  iterates scheme-eligible regions directly for each goal evaluation.

- Handle regions crossing node boundaries: uses damon_get_folio() to
  determine actual NUMA node placement of each folio rather than
  assuming uniform node placement within a region.

- Pass scheme pointer directly to metric calculation functions, avoiding
  container_of() derivation from quota pointer.

- Fixed 80-column wrapping issues.

Background and Motivation
=========================

In heterogeneous memory systems, controlling memory distribution across
NUMA nodes is essential for performance optimization. This patch enables
system-wide page distribution with target-state goals like "maintain 30%
of scheme-eligible memory on CXL" using PA-mode DAMON schemes.

What These Metrics Measure
==========================

node_eligible_mem_bp:
    scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000

node_ineligible_mem_bp:
    (total - scheme_eligible_bytes_on_node) / total * 10000

The metrics are complementary: eligible_bp + ineligible_bp = 10000 bp.

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining 30% of hot memory on CXL (node 1):

    PUSH scheme: migrate_hot from node 0 -> node 1
      goal: node_ineligible_mem_bp, nid=0, target=3000
      "Push hot pages out until 30% of hot memory is NOT on DRAM"

    PULL scheme: migrate_hot from node 1 -> node 0
      goal: node_eligible_mem_bp, nid=0, target=7000
      "Pull hot pages back until 70% of hot memory IS on DRAM"

The complementary goals create a feedback loop that converges to the
target distribution.

Dependencies
============

This patch is based on SJ's damon/next branch which includes the
TEMPORAL goal tuner required for these metrics.

Testing Results
===============

Functionally tested on a two-node heterogeneous memory system with DRAM
(node 0) and CXL memory (node 1). Used PUSH+PULL scheme configuration
with migrate_hot action to maintain a target hot memory ratio between
the two tiers.

With the TEMPORAL goal tuner, the system converges quickly to the target
distribution. The tuner drives esz to maximum when under goal and to
zero once the goal is met, forming a simple on/off feedback loop that
stabilizes at the desired ratio.

With the CONSIST tuner, the scheme still converges but more slowly, as
it migrates and then throttles itself based on quota feedback. The time
to reach the goal varies depending on workload intensity.

Ravi Jonnalagadda (1):
  mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
    metrics

 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 158 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 164 insertions(+), 12 deletions(-)

-- 
2.43.0


