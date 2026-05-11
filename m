Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CD0CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C406B00B8; Mon, 11 May 2026 06:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69966B00BB; Mon, 11 May 2026 06:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53656B00BD; Mon, 11 May 2026 06:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A427B6B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30D79C245A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:05 +0000 (UTC)
X-FDA: 84754824210.05.73C4610
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E57A180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OoxcaCVZ;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qg9BoGIRQX9a4/FMAbkw8BJqSowvqCXDuFdaccaN4l4=;
	b=k5+vbQMSim6lQQ5OjzZYULVNO/sLY03CV2tnts8o65pUl+VsrgC+kfYr19DHUce4VEIijG
	cEfCKaljoShxBLUOFgAqUpwTfGbRu8BHnS788zwnbO/X3UsFAyfOi9zaac6iucELLQmhg9
	bo/aMruzePUOlb4owNJdFtyb8SHd1K8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OoxcaCVZ;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496723; a=rsa-sha256;
	cv=none;
	b=xK1vvzqIiKGivc+g8XNuTRx50TzGI57gKz1oZoAvAW9jvnW1GQFaaQFnWI+ASwcau4h3d+
	XtkkAe1DTDXBKvIwJ9EmOiFAxDObt9PthGYji787Cf2xs63ek5DKam8jv/KxrTRHAXdJeg
	pTx776cmwVA0rxS4q3+YyE42NGu7mX8=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba17c8cfacso42471525ad.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 03:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778496722; x=1779101522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qg9BoGIRQX9a4/FMAbkw8BJqSowvqCXDuFdaccaN4l4=;
        b=OoxcaCVZmBR+LmU1wrPxgx3e9aPr+JpAHYvppJlM5ev+9fLPdU2BYR5UAPU2YYibqA
         qQBN9eCaYSTVNxeMgxD++QkEw7melGDXegpcS3VxQ4MxbN4mX9ePZrNOin4KsqF+iIu6
         GdTozMZmKgBu3Gc4rOrDFfRo6UkevnhFo9/PAaOEj/NLBEEDWsayXSfsHYCiZXUJ6ULS
         JikLhsVCdvFn/oidRmWc/OieDGqfUTL2QtHvmaS6AmcGRK+GY5MpBbebYWqJd+FRF0wt
         IgLMBwcD/G5CcVH+lfWEw+eGu70r398qpfmHOR0JYRoNifeJHGmrFeC72ogzeo2mG2sX
         Ob7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496722; x=1779101522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qg9BoGIRQX9a4/FMAbkw8BJqSowvqCXDuFdaccaN4l4=;
        b=oDVpr/Pjbi9X0dJxGO27sHZRuMzHHywf/3zqkC7vlfx4iF2P2EG3vgqah7TbsyyNNY
         55pxEyl2A4E1nE4eg4mcVUk8cNf8HnAMES/mxzYh0pznA/fUfnwQ1oZWQGd9hPiAUizS
         IXn7fId72s1zhjX1hGZR0LOuScBti/mcZgT6/BFSRE0lGwVFxiAbiIjtQem8Az9LWSSA
         vxOX+uXgjtOW2XmWSPoMZjQhSRFbk8aF53jMA44fZ3aGY5d4Nc7WMHlzKeEImSRgo4dm
         WUoR3mtxzLqitdCzSA9zxVrYe4ER2NqxhQZd+PyJxQpB50pkpifSNCNJwLPkEvAjxLK3
         BpFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rXeIumIUBQFBwjAU7sruASjv65H9JUp6aHqMaxOLt9Ttxs5ca+XhpNK1ZWTgZdpGqIe0gxTY59Q==@kvack.org
X-Gm-Message-State: AOJu0YyL7ngU2VpXfWmfr+iy4Ooie0nB9hKz3SkdTYGKATgFiT7Q2aRE
	AaDfkY49yWu0g26fCq15VBHq9etqrYzMQSSNdC1tkgn5InBzcZIWT4rV
X-Gm-Gg: Acq92OEY4CWOiPg5RxMU5NRA0a3XxSEAdxMMZ8THjD/sWS1AquqyysL4VOohjy8l/X5
	GBrd33NvUU0M28DyEIiqoyq3VLrOv/9OOa7tyV4YtN1+a4rwywx4UH/WC2UFAmsbvyZVnUXTLm0
	+2TrreG0Y5efRwO/zBLNacCJteGc0bDoMblq9sVEBMUySf7T4UWGvCktfbNTaFkcRRcW0Q/7VOH
	n8DMzb1JGAWLfzt4dsYj1EWCaqqTmsDli3zeSla72Hfy7WhftssXfmiZHNwA4mN5yOu+EJCWfGt
	eywHclFgPZVfUwcgNaPNAvAjPjSZnLkklyha8MEezQoimSP1fHexl5nYNzIlSzuigb0VWuhg9bv
	8wrWU/2HgKhB4JubfBs8t9WEAfodp/va3OWKBUcGslCh5NpmbPkKY5gl2amD/XNf95yEVEFkKJ2
	6WZcqVkrboGJWq1vx29PgHBuX03Lw3XepgmjVbdkjGhVUMI2bEyaR33BvTGnoNvg==
X-Received: by 2002:a17:903:1ad0:b0:2b0:6e60:9586 with SMTP id d9443c01a7336-2ba792a0c08mr266735895ad.17.1778496722209;
        Mon, 11 May 2026 03:52:02 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d409eesm98571745ad.32.2026.05.11.03.51.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 May 2026 03:52:01 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH 0/3] mm/zswap: Implement per-cgroup proactive writeback
Date: Mon, 11 May 2026 18:51:46 +0800
Message-Id: <20260511105149.75584-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E57A180004
X-Rspamd-Server: rspam06
X-Stat-Signature: ep9se8mke43up7n3x76d1mqdrwhzscbb
X-HE-Tag: 1778496723-400901
X-HE-Meta: U2FsdGVkX189ZuGmk7OT2KMXJ3r7xpHa9+PDi5xd8AqCw1Lc1b4EKonnABcinlA6WiggD+sWn5KZu4coZHkZCrRcLwVJyR3GsneLDWdG5M95nkbi4Da0dhuamfEqoqn3FRQ4FjeZ+9no1d+i5ZxNrNVCR0lqNwSYs4DF4aT6YgBIBrMxwB3N3EyeuvQ+aZfLQfSqSqbOQidxyA9smqRjTh+e1bQfZBh6jAAoAj+xdjT+E1XBgi4NpvN8uiu2f76Iy3OTjTsqcOvpZSHRfHQEVYzJcPRig+i8LA5R9CzQThyj6S4XQcHR6J8eyj4kJr3So4skGOqGZcChY5jG97QN0S67EsJRjiqxk89DZ+zLe00Ibeoz2jnB3OU/ZzfJPRX3rKf2Xe4ERtjnVY6LLEvBh7HX3ebkexYm2kT0M4CoHVtNewTOEirJVzp1WTN3eZiBPhM9WOZ/US53O520Wv/auqItxYuNJ9WMTHxYJrLwx1FrZ4ybVcEGt6/XJQROD1kJxOK/5Pq2o4sKG/PSOfr1Im9om8B+jfyyLbexl3P9W1a17Tuz74XD67E8vUo4XicAecT3H9a7SH31tKsqDIPZKEw1UQXn5O4xP5pOmiqx5iJwh9ZMVqAc4FZzCnH4CB4ykLuyBEYsEDoju/YYzUSFq9205/JcS77fy4iT53IChxjlCv82kKVcEex053L2DDiBMxiQtqxODWpGKclwDq0wGD5DC/w/BHxfAn96Vb9fXvZ17nwwtEdLmCT+fW4x4xpGlcKdqN1tk4tllRJpziIyTUcO1HfRj98gm+mkWMXEk6Er24QlldHuH5Cag1bxLtPTb/lx5Hbxk9uJcMQM9firv+S2dYzZe3UwdW2eowc2/TMmI6w906NIQ9ia4iuFqKjTU8fjia0rZ56bMzDRCR4oYNbM1R4apLgwAIzvFY4RTlInOdizo+a1wd5KvGOoY3ouml5/hWC8ag86STjXDUQ
 zoUy0uqv
 KAP9vgua5RdTOr5bp0s8v/MuwDCtF2VC35Lwi3YnP12w96f4mFukrDbKI0DOp/+UGqDk55Eqq5xQbQbF/kKuOgmTIOOg8/U5whar3Oa8i6Sni6mIDt/OwvHmR/S2KVvDflKmZzyEKA/UFbXmweIuzkJwab+aQo0IEwba2xb/TKfkmgsL0bOci2D9uDPnW0Fq1LKYLFvzYlfk4yu9wpDgHttbIC3ApAhHht9QOr4SYceGrW5mc10XcTSx0FRyhHC2/Yyso6bcTErF4VfLePAW2ZD7rrESKuTV2FQ+1m7DZiQZcPPO99xdaXakRUPnZV/z8InzMBhYNdMmTvDIybLgFarvAyOVk2sAC9HOy5D4cfR13qbxBFBrfEvRm/PrwD95VfcXSLsgQylEeUk7KU0NUJ9xAHzmEJB+GXPcygyTjuyStQfCji9I7ZNcHV3zClwNLdIMeEAmskA4zCAZdxZ45u/N9P4DNh482BVwOpdab/G/amvHmHTj5/cbNYe6vDtsdr5BOdML8I+uR8km+5xpEjKOOJrWIfqIG1MtrMY3J9g3rCmUWslKzVj7LQPbLTbrTFROT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap currently writes back pages to backing swap devices reactively,
triggered either by memory pressure via the shrinker or by the pool
reaching its size limit. However, this reactive approach makes writeback
timing indeterminate and can disrupt latency-sensitive workloads when
eviction happens to coincide with a critical execution window.

Furthermore, in certain scenarios, it is desirable to trigger writeback
in advance to free up memory. For example, users may want to prepare for
an upcoming memory-intensive workload by flushing cold memory to the
backing storage when the system is relatively idle.

To address these issues, this patch series introduces a per-cgroup
interface that allows users to proactively write back cold compressed
pages from zswap to the backing swap device.

Users can trigger writeback by writing to this interface with the following
parameters:

- "max=<bytes>" : Optional. The maximum amount of data to write back.
    (default: unlimited).
- "<age>" : Required. The minimum age of the pages to write back
    (in seconds). Only pages that have been in the zswap pool for at
    least this amount of time will be written back.

Example usage:
  # Write back pages older than 1 hour (3600 seconds), max 10MB
  echo "max=10M 3600" > memory.zswap.proactive_writeback

Patch 1: Move the global zswap shrink cursor into struct mem_cgroup as a
  per-memcg zswap_wb_iter, so patch 2 can scope writeback to a given memcg
  and make forward progress across its subtree on repeated invocations.

Patch 2: Add the memory.zswap.proactive_writeback cgroupv2 interface,
  allowing users to trigger writeback with optional size limit and
  age threshold.

Patch 3: Add a zswpwb_proactive counter to memory.stat and /proc/vmstat
  to track the number of writebacks triggered by proactive writeback.

Hao Jia (3):
  mm/zswap: Make shrink_worker writeback cursor per-memcg
  mm/zswap: Implement proactive writeback
  mm/zswap: Add per-memcg stat for proactive writeback

 Documentation/admin-guide/cgroup-v2.rst |  28 +++
 include/linux/memcontrol.h              |   6 +
 include/linux/vm_event_item.h           |   1 +
 include/linux/zswap.h                   |  17 ++
 mm/memcontrol.c                         |  80 +++++++
 mm/vmstat.c                             |   1 +
 mm/zswap.c                              | 303 ++++++++++++++++++++----
 7 files changed, 390 insertions(+), 46 deletions(-)

--
2.34.1

