Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF49FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B352B6B00B5; Mon, 29 Jun 2026 09:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5576B00B6; Mon, 29 Jun 2026 09:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986EE6B00B7; Mon, 29 Jun 2026 09:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76C9C6B00B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:00:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5010C3442
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:00:56 +0000 (UTC)
X-FDA: 84932960112.14.F565B16
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE1E640006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:00:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq07vjhl;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738055;
	b=pNdqtgK+0kAhJ5JGdEkmC1EIwttzUZGBgjLIChDgEAPDvfp1TEkBLw1EhS5PcT5kd/IJc0
	Uk/WUjAF0/XxfOmbXf6Aqg+jbfSBnZGA95k0qoimceTfSz6wgMIYMtk63YF0koEYTN/E8c
	hSSUyHWMHVWn7azyVp8RbB0Erxcm3so=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mj2gt/hTNZzbuZtdAFTmoZ+udDIFe1awW9U5cT+0b8=;
	b=RbU5pKrIRJx0+z0yEWrbtfL/NGRz9Fnc1nt/bQ1VQy0VxdYqUq3LRy7hO9IVojjsb1aCRg
	Rg+hqSaNOsD5vsxPrazeoILEieqT4nniSv5NPpdEjXTHNIfhA5ZUTSNOeZ3HPKvksCYHYK
	GKroUzNbIR5UyOl9hzhqMxDpQmbwQpA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tq07vjhl;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782738053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Mj2gt/hTNZzbuZtdAFTmoZ+udDIFe1awW9U5cT+0b8=;
	b=Tq07vjhl1bPKN9Z63p9ufM43vhudCB5raWPV/KUTdZ9voQE2TI3vu89IcpO2wmPowcgJVG
	xtEBN80W1RgfrbgXx52uEU1ufqhctorpGvEZFp2o1J/R0BtEpyMaGmtAFT9Z88h2r2D5Ks
	+WhAn8Ftb9wc6n5nvBSwokO27VAuVw4=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	tj@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Date: Mon, 29 Jun 2026 05:59:36 -0700
Message-ID: <20260629130042.2649505-2-usama.arif@linux.dev>
In-Reply-To: <20260629130042.2649505-1-usama.arif@linux.dev>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE1E640006
X-Stat-Signature: o9o96b1r7psd1heaa443qk58ns1cx9h8
X-HE-Tag: 1782738054-762341
X-HE-Meta: U2FsdGVkX19Medq5ykY2sKOMsn41dwBlxjwxfbHQAka9SDdycm7pBFyFq2Q6aA2aJt9bvINubezNDLZPlWM7T/5ejV4JwXwQ997pkGb9EmJgar1is34E4vhpl4v4f+e55h9erkBs905+wATgFAVeAIJH1Znwc1Q82ay2xtdjXaIrukcTua2QLHzso2Mtbw3Hsp6Wrp6xF3DD8I2B746hkySYeZaX/ohWM0BivN3PQ6pQUhb12vSutKEWv6Rve/GIutueF7Fb22o/B44o/tEKtPJiyTzQGFQKc/ZyZCM4RUd9z9XdY64wNzO9QhJveUNvIZKFtlBmTVsNsyBuHs7JCfHw9LUg9+/a9blVeGdAHMKXqF8HLHb0hOql+3ImzdY9Qu484B2eDU7+QkPVz6ssDpJNmraPaWjD7G+qeEv1RrC71eVAfx0QoG3FHBYSjLvUZbErMBkbkzo42YA9SQFokMxG7shFqAr34Sbvfno9Q4qeLH6qcb7Beiys925xae7Xr7NhDgbyNmHyrRbiuhIJUDCkGFcMBiZOKPCO/ZmwJTgQkedBrIpciUggshSbg8RCNKW1TuRw6PE5JdCC5QA+CQ13AVAcO1SRC2402gswucAjY7oHzGuiBma7GyBGrd3Ug9W0PUacpDWgFuS2GlE4Ko8G6WDKgyvOdrx2Yr7RBFCKh8b9wlCmde+2UAzCGYr0qgMiUzkoDszOvkQ44UGQtZ/GLC7H/cHUsMVnpfMVIpAdhpcwhLg2v7VxM4Mgye677VZUE4xlFSgyu6HgtuYagwRVY7u+zXl8nObW8M4MiN8UFzWtilfFdzBwOvF87XNKTH+BuOae8+vXYZhjzV9TNAY0vCDIei3fPqAsn+o58TNzGY3BV3/kN3ahsv5IjfCcsrf0+6TBvz85jrYIwffIQFWAGX2SKKXrRHfbCXfKy3LyCI03kVcS0ZA1VghLYfOgn48XmT8aOmrWEQCOFfo
 bPjytduD
 H5M55dG/2ijceSpAw5nE+6rsOnhQTh13HxACWBkoGIu4Snq2hrAxwQu1A5d/gQcZzrQB22OlcEJczsltppklrJzqUdXrVVStsZuNkQLRf805zDPnQBQwleNdvfJImzvdWPcywchhNGJmj/3ZELojDL6XfdsKoYQ96D9Dw6/KrAPdNHM/98vGlI2RhdvDSJGTXF6LiDyRYDqelVWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmpressure() has two outputs gated by the @tree argument:

  @tree=false drives in-kernel socket pressure (mem_cgroup_set_
              socket_pressure), consumed by TCP/SCTP. This only
              applies on cgroup v2; on v1 socket memory is charged
              separately via tcpmem and the consumer reads
              memcg->tcpmem_pressure instead.

  @tree=true  drives userspace eventfd notifications via the v1
              memory.pressure_level / cgroup.event_control interface.
              v2 has no equivalent: userspace gets reclaim signals
              through memory.pressure (PSI), which does not touch
              vmpressure.

The existing early return covered v1 + @tree=false. The symmetric
v2 + @tree=true case was falling through and doing the full lock /
accumulate / schedule_work / parent-walk dance for an events list
that can never be populated. bpftrace on a 176-core production host
(cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
~16,200 @tree=true vmpressure() calls per minute. Add an early return
that skips cgroup v2 + tree = true which avoids us doing all this work.
On a v2-only host this also eliminates a lock contention path that can
serialise reclaimers on a single global sr_lock.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmpressure.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f053554e5826..c82cee1ab43b 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	/*
-	 * The in-kernel users only care about the reclaim efficiency
-	 * for this @memcg rather than the whole subtree, and there
-	 * isn't and won't be any in-kernel user in a legacy cgroup.
+	 * Only two combinations have a consumer:
+	 *   cgroup v2 + tree=false -> in-kernel socket pressure
+	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
+	 * Skip the other two: nothing consumes the result.
 	 */
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
+	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
-- 
2.53.0-Meta


