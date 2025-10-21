Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC88CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 23:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F4E8E0007; Tue, 21 Oct 2025 19:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFEA8E0002; Tue, 21 Oct 2025 19:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905B98E0007; Tue, 21 Oct 2025 19:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8123B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:44:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13FD9BAABF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:44:52 +0000 (UTC)
X-FDA: 84023754024.13.69A9109
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 633021C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:44:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m77/AqGx";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761090290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0m7npUBSf5o4yjDCd8zm+922gGFcJ0A29MB3XlxsDkQ=;
	b=F30dLu8rk2toJBY3bzkXT3cbjQwcfT8HuYGALRTn21cFmsqx0hhUlxtT8MZ+FySlU4RbM1
	N5cjVzRWAVWr2d1JcB5Km1YfdUlyv1sNYl+SkCG4ekezLSTS/dIYk86Qev0oAakEafYeuO
	C4+6nUH+HH2agGPXyeRNQMKYYD82RwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761090290; a=rsa-sha256;
	cv=none;
	b=5xst7nN+wwp79PcghTSD2nrrHpkJQ77v/6JyFfp6CWdkJRYgsycD9tbLu635vUBOn2JbnZ
	pSISZuTXXWy1fzcWM5MbDnju5Gvazy3b1pScWAeheOPUR4CrnPgQKsyZVrcO20CFDCU5GJ
	km9LEPOoLh5xTOZjvtQ7yKQoACKX/80=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m77/AqGx";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761090288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0m7npUBSf5o4yjDCd8zm+922gGFcJ0A29MB3XlxsDkQ=;
	b=m77/AqGxEWO9nu0IM9sZqAjEg3798PSwzQclIVvw50s1wbc0OEs1BlytuEp/FS9nWlYYyM
	RxxW7wBJu9Jbehs44nvPGpt9S4HMV+oPILVkqf6hJd2eJESXgmwMDxDVixuBCAQ9vNNUhU
	Qzic/zCOzHxspVLRor4yTB0I3MbiebM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] memcg: manually uninline __memcg_memory_event
Date: Tue, 21 Oct 2025 16:44:25 -0700
Message-ID: <20251021234425.1885471-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: mfspzznm16nr61h5rp5gf15macmfekxc
X-Rspam-User: 
X-Rspamd-Queue-Id: 633021C0006
X-HE-Tag: 1761090290-379314
X-HE-Meta: U2FsdGVkX1/klb2K5C9yiAsR/N8QaGwQTo0VlOikscirOTjTks2MmEKpnFIHSFEiOMcMVQKWSvajU7b/Uj9oVTFdT2W7njYSmUJwWaCTIwVTJ9tTWGomepM7ePl9QShEPyoS4/iDRfst14BSGWdlF9yEXyROd4Oxxn/SfTdQpOB4F23CHQ34T5uyKzG3j4+EcgxPckzy5xNVuDcKa6s2bLKseDhKpj6y3LMUAUvYDuNnDuR5ZnLE7G76Qh09DYqXtEaBdzb+9f1uu4RwlIfyPP8elR9qU8S0QL/iXo8qFzmsq+KejEvhQfIeRdmhIkolsNmq1j6W083k+D74zg0TGc0ihWvLeOEQebJGkywx/tHOmQTULLEk8KP7pebwpYYEdcOgJzixvAqNoH1L24Hi3xufIY5Nd9NYuVvQZVrl3ksG4gIZXTSJRZ53gQY2XpSB9MmTK6Q/BuIKPLcbcwZ7iQvvbdoWHLERU6gobPrkD8sC7q9lPdc5I9QpTsRVHNCnSLP3prM2HR6UnkWFKmeXYC2vF9ldAgazyMwXaNbPoVXD+62Krjv2F7LL/4zktFLGAyM0DIqN5DuULmA9xRl74s8rqBvP0dtHic+8y6X7QxRayFXFJT0YUSKdI3mZDoZgDmhDqmwxO+Q+DYq2q4ArFpIRbggS1+M+tUJjhwbwlhKTIV6j2HC2tVjhqSl3rg8qmPdKSGrksEdkxwb7dA7Th7WX9xTi1v9YoG8hlhnu5qQ1hvrcSvKy6yrHEJ1glRugK4yzOygNRvy6j8BTLHGpV4RZQ/BvzB/0M/Gmv+O7czt8/LBg3jL4xWYLaVGT6AkiR1J5QSM2Jdn75ND5u7CUxAC68w6YPTVAoKzZPmxmtKYerNXzc0k2YjoynSjiPZK2aD/R5Sh5y1dyeB6+Rh2n8qUaSV1wTpinOSi3Fql9oSuOnhI9PWPnutNZoZXLx1fIC39shJBm+sXYhSVfUrJ
 fbujcMwa
 ccN9xcSMdYC9A5bQIjWVwgiGfVPHtOrZlbLaA7VN4E0TBQkZ2qjbtn6bG3vrqlJg+spHUDrMZSZl/UgraLhldGBwZgN9VCchuLKOuYp4S88bF1/h4qiw6/SQ+ww+Kg70lLtDB04E69boj88wKgOlKCm/f76S9UfauB4frg9qb+CLzAxgUmdj4zbGAI+A3XqQ+MK4IQ6Z6+9U+KyAen9HuWdOHb125JNR5Qo2fXuoQDs4mTm4FGKTa9E4GU/xATrPk265EokWT1H17f60p1OzqCUKynA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function __memcg_memory_event has been unnecessarily marked inline
even when it is not really performance critical. It is usually called
to track extreme conditions. Over the time, it has evolved to include
more functionality and inlining it is causing more harm.

Before the patch:
$ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
   text    data     bss     dec     hex filename
  35645   10574    4192   50411    c4eb mm/memcontrol.o
  54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
  34644    1065       0   35709    8b7d net/ipv4/tcp_output.o

After the patch:
$ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
   text    data     bss     dec     hex filename
  35137   10446    4192   49775    c26f mm/memcontrol.o
  54322    1562       0   55884    da4c net/ipv4/tcp_input.o
  34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 32 ++------------------------------
 mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d37e7c93bb8c..8d2e250535a8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1002,36 +1002,8 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void __memcg_memory_event(struct mem_cgroup *memcg,
-					enum memcg_memory_event event,
-					bool allow_spinning)
-{
-	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
-			  event == MEMCG_SWAP_FAIL;
-
-	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
-	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
-
-	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event && allow_spinning)
-		cgroup_file_notify(&memcg->events_local_file);
-
-	do {
-		atomic_long_inc(&memcg->memory_events[event]);
-		if (allow_spinning) {
-			if (swap_event)
-				cgroup_file_notify(&memcg->swap_events_file);
-			else
-				cgroup_file_notify(&memcg->events_file);
-		}
-
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-			break;
-		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
-			break;
-	} while ((memcg = parent_mem_cgroup(memcg)) &&
-		 !mem_cgroup_is_root(memcg));
-}
+void __memcg_memory_event(struct mem_cgroup *memcg,
+			  enum memcg_memory_event event, bool allow_spinning);
 
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1a95049d8b88..93f7c76f0ce9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1626,6 +1626,37 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
 	return page_counter_read(&memcg->memory);
 }
 
+void __memcg_memory_event(struct mem_cgroup *memcg,
+			  enum memcg_memory_event event, bool allow_spinning)
+{
+	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
+			  event == MEMCG_SWAP_FAIL;
+
+	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
+	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
+
+	atomic_long_inc(&memcg->memory_events_local[event]);
+	if (!swap_event && allow_spinning)
+		cgroup_file_notify(&memcg->events_local_file);
+
+	do {
+		atomic_long_inc(&memcg->memory_events[event]);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
+
+		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+			break;
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			break;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
+}
+EXPORT_SYMBOL(__memcg_memory_event);
+
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				     int order)
 {
-- 
2.47.3


