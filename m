Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F391077610
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86FB6B02FF; Wed, 18 Mar 2026 16:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37526B0300; Wed, 18 Mar 2026 16:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D446B0301; Wed, 18 Mar 2026 16:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C69246B02FF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75E5556C52
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:02 +0000 (UTC)
X-FDA: 84560259924.25.EE2F4D3
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C0C840016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tb8tXqQw;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fGu/XcrTRq1flrtcSeYIVqct01kI0jM/rXSQN6Lz7ok=;
	b=ZSnn1fR4FkEA//BJAWj9TH+lNzBjQw9VYD2XvHw4/bGmFUBbu9RVbGpWWTUdd7Y+fszLWM
	f2V9Vz1j3+QZSPJJNOQQX8PyFBYIAoFXWpghDXSYPYNaGOJ9E64gDX20chW7l8iY363kuq
	uiJRBBrnZaqi8RqTc0HeKYnWTtABXf0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tb8tXqQw;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864240; a=rsa-sha256;
	cv=none;
	b=owUvn5ozh7AcLSuFUP69sam98iCgkSvHkOfPE6ePpkxTBHosL2izaIGH6kEZ765KfZ52f1
	469YUXyyIeOI47fIUJIR9Z3TWZ/y4ktnp1zQg71Y9vIBG7fEcsLy2YY7iEbBFEVm0LJOXV
	OZ/5DzXaTFKK3xzZInJm8Gb0B/nAdJ4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89c52db6231so4211386d6.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864239; x=1774469039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fGu/XcrTRq1flrtcSeYIVqct01kI0jM/rXSQN6Lz7ok=;
        b=Tb8tXqQwEyTwWq4XQfy8gOAW6831uJb/bcOSs8PlucOyGGCkKJ4kRZ/f50LkD/uS7C
         mBvx2Vbqyw1vsZy5lKzGKSoibMQJGRMHgnrioD629RV+MB5KqXOjVlnR2WRoFP0nMHOR
         3zYLIm7+F9Xj5FgVpNLPr/+yVn/jX6PWvV93n5ApwLmU4rmhdFLvDGOJ3vAkb73CHo4Q
         p5pGv+6gO00hF6sNOLNUjajavxFDV9qkiyMHrjmxmEiHniZpKMRHiknVQrMvl2OHJfle
         t2NTlyPQzz2+bt4aLaW2r3nhT+f8ws/7r4qUuNOOqUtTqGVnO8hojE1Eb7P8bu6hdN9q
         ucLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864239; x=1774469039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGu/XcrTRq1flrtcSeYIVqct01kI0jM/rXSQN6Lz7ok=;
        b=JqZnrwu26WcrC1RdmCe2gtpSg8l031UgMxigKnv5n++XkFoXGsHBznul8YvuGa4vYk
         y3svX71cCwnaf7mhM1gSvYSna6DQI3X74S7TzMMniTTOuQU7Fie901aMnvB64b1oQNm4
         IuKA9ya07Eg9z0vLZCoQZucHOeKUHg+0dysPC4mlteuXJYF4iDHCzP0CZkrjrfy1NnGF
         6vRlmbCsjulzuQ6Bg4IYGfBQrje2sAa0blnyFzm3zLLyap3P0UhkCU4wrGb9GKrSCTvQ
         M76XeHQjTGtsOMSYBkcStJt9Nh4Qp9bgh42E5pkZ+xySf9TsmWGfOhcURwmbBaoAjM54
         lFqw==
X-Forwarded-Encrypted: i=1; AJvYcCV+ylPR2ndtM3x/dpcy3NEsNOQ7xCI4Be0UzPgB/B/GdBiGaluznTr/g3ZQsZ0ltmRJg1mTIWGMbg==@kvack.org
X-Gm-Message-State: AOJu0YwiKPr+Zj10JIOMcrdmlrDSYX6X9qYpQbC7un35K+QFMWhKcYoT
	CSGDiMqXbDWGacQdrVunwk7S6HJr9GTMhpTPhrmoSaWqmajejhEsBoPaufsbnDj+p7g=
X-Gm-Gg: ATEYQzxWc0l3jcwEaV/sCKXElrDUa9TgYvJ+AwUP/XprrZJ0ukh149XpE3VRUCudxOs
	IxT9noJK3QoEZLeuAh1rTBy/L+kM44JNcwQ4O+3G3PGiiAHxEkfxnW0YVNPXXdZAstxDrp7+UOr
	GX3oQuxFMLjlohs6JKjY1Q4MHiREDWzCBYvk/Qw9SwskoLnCIefHDGPBipztFnkJiJkG/RsTt7s
	qiI8w5UnIbHk6yXyBIFDI0l7wMoKv0gtzOSyowoeO0jGQ367AMO1guAAxLgib0lavM28e4xcgKq
	jF12ex3oruGcbmxFl7qVx55TcWjJPp/Iakk4NX95CiPKc4exvwE+suTXhLzqJqrbg7BjXBFuSkp
	nf6rXuf7rOogwABc/tVkEjP6al59RBH3rK+OVFH4TCqW2Zvikc9gmw4ElS8eRqs5cPFHIxjKyx0
	zx2L9r/pMxu9LAUNwG7Um4lA==
X-Received: by 2002:a05:6214:5081:b0:89c:62fe:330c with SMTP id 6a1803df08f44-89c6b73392amr63680026d6.63.1773864239269;
        Wed, 18 Mar 2026 13:03:59 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b8e225fsm29544756d6.3.2026.03.18.13.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:03:58 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
Date: Wed, 18 Mar 2026 15:53:18 -0400
Message-ID: <20260318200352.1039011-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C0C840016
X-Stat-Signature: w9h3co9d1uxom7w4n6wgpcdrmndszp9y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773864240-710630
X-HE-Meta: U2FsdGVkX18kT/ihFkVJ0APXqFkhONTNnl1lZB/HhFKZgLyiNDgf+Y4hgtgAooL/Qb2OUdW7ODv+FgAna+LlI9myQfK5P6cWLqatCiP5Wm+/VOT67QvxDz2Jzo50sYWVQUm11v+H7M5wRgdRj7iq18jSjLf2aep5qsOWT8OYn31hW6kUytEngtC1gh6l9C5UzjoQ+xqFhLwWP2d9+ybBvC2FU1hSodToJumXvfYWcazAOZ1cOHILvMIPY+AemmcSHC1jjfg3QH/IHrYl+jTuasppKJm5/OLiaXTWNfxd0IV9dIF9lSuaJNtyhOJEfEAOG6PYmnrM7yTbC5mW8JyjNq9JP5sroN8la0QCNByUZa0j0Aaa9BznXPP38eAhAXf7kwXo9Aw1De9hKPffZezDonriETUoMy85EJXwgevmBw12jC+y1OJscMjTymjZST/yaviUmo7ufN1LrnDSTvtxyLc/BJz4r7dvL64Pn1lSCKt4wJ57StNr4U2tQ2WYQzLalinBkclmc7QVwH2E1KOAIlzYH+Kv7zUdlE2bfMbF+MPprJvCGUp8fA9I3VeqJIO/ql+FrACsz+Ob+fR6M1LlZq2gfRSHNTQN9eBd/Bu+RW5k1aPTLzjoV4SqHuMos6xE9jvp6O7+32RbkX3g1c59Uwww1Cgn9WVghRcWcmXsO0HKnjc69jyKWKG9RCCh/30uPO1VYGHY57swHHHXUMsVNF3jrJrQF/rMVJg3VQJjqJgZN09fzAumfoKDyKjAvic2ZTuC6yey+6LpahE87qst+pg3P7Z6QSg3y5aoZ8MbwZHqTPDRopqkR9eu6vhQNp0cvx6vcy+YSXWAGxs91KiC1sKijZrSWGb7k71hzBxalYChLtpHfDs3c9LHOSwuWl522JErZRSx1Yg7N+GcxiWIwxHDf/6NLYFB5/yGx3jBGVenfbL7zxDrbu7hxffdKLsPc0TOoOh9dng5cfzoJft
 nFhHBhhO
 YbbHwhJUCHlKXjn/DkduXsWwBNg2wGS4DSlEj0h2r0tbv7fzCNwr9cdOcv8qNySpcadx5DKRiVBljsXJKZkbidZ1T2UZ1So87WEknYATcgbdV7UAkkUYx81Beu4nk6DNM1gzUVrTixkQT4YxiOpdLVQVMcqF7+O2VGLUeXZp7LZsOmkcGmxIRUT3PKZNSEKjIeKw9vSUl/j+oxopywW1ZQgaNAR7IgN21qwWAyvCJvKec5Kqv5C4Ywfn+/Okg4GG/k+dyiqvfNDABE2iomt0j9I1DU1YsfKc2Ew/7WkySKLXexxjhcfJTRaNZCFJPeaDDrMctkI98PHlMUXgVuIPdYeExFgezCnTi28nlV1w5LYISJko2GyVqcddE36L9aSMPegKkvixpzU5ZQAx5vVRIw01g3WHvKvZf2Nfb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is version 3 of switching the THP shrinker to list_lru.

Changes in v3:
- dedicated lockdep_key for irqsafe deferred_split_lru.lock (syzbot)
- conditional list_lru ops in __folio_freeze_and_split_unmapped() (syzbot)
- annotate runs of inscrutable false, NULL, false function arguments (David)
- rename to folio_memcg_list_lru_alloc() (David)

Changes in v2:
- explicit rcu_read_lock() in __folio_freeze_and_split_unmapped() (Usama)
- split out list_lru prep bits (Dave)

The open-coded deferred split queue has issues. It's not NUMA-aware
(when cgroup is enabled), and it's more complicated in the callsites
interacting with it. Switching to list_lru fixes the NUMA problem and
streamlines things. It also simplifies planned shrinker work.

Patches 1-4 are cleanups and small refactors in list_lru code. They're
basically independent, but make the THP shrinker conversion easier.

Patch 5 extends the list_lru API to allow the caller to control the
locking scope. The THP shrinker has private state it needs to keep
synchronized with the LRU state.

Patch 6 extends the list_lru API with a convenience helper to do
list_lru head allocation (memcg_list_lru_alloc) when coming from a
folio. Anon THPs are instantiated in several places, and with the
folio reparenting patches pending, folio_memcg() access is now a more
delicate dance. This avoids having to replicate that dance everywhere.

Patch 7 finally switches the deferred_split_queue to list_lru.

Based on mm-unstable.

 include/linux/huge_mm.h    |   6 +-
 include/linux/list_lru.h   |  46 ++++++
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 342 ++++++++++++++-----------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   7 +
 mm/list_lru.c              | 196 ++++++++++++++++---------
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 ++++---
 mm/mm_init.c               |  15 --
 11 files changed, 323 insertions(+), 371 deletions(-)


