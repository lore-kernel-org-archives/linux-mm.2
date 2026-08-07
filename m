Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B03FC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1E46B0098; Fri,  7 Aug 2026 16:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDB26B0099; Fri,  7 Aug 2026 16:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8DA26B009B; Fri,  7 Aug 2026 16:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A48956B0098
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4148F1601B4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:12 +0000 (UTC)
X-FDA: 85075592784.21.B665B64
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7C6E6160007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ibXf7cd6;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEYEX02IKWE90JSQ/XOJ17bp5Gj7dbgYbm77S6gqa2M=;
	b=SrDAXnL2EjxbzI9OrKjwGl9YcWBlM76wFrUWpK39EwEW+Wy55djQqdcdiBeFeEO9nDXbXO
	UkH0OZ8tWcVOE4l8ViWh8lUjMXdscZ21igjKzi5ml9w/knwgI6ZS3pN/JsezDQpVYsskDj
	3uvjzU11izD2UubnnPU2RSO/hke0wks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134070;
	b=y97ShfZNO/yX4CJx/MoptH1589qSLhk8AA3DNtn0q2kPkU38xEho4EEft9N93Y4AWuOnAy
	AXO79KYeOQuo3ndYj+x2grqAZgUvHGIaQe0nSYFkASbg0ww5BzNASkqwjZ6c9j7TP9VUqB
	kE87w8gUDt11KDudE27AoqgV9EKdh2Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ibXf7cd6;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-44aeefa1c00so1921071fac.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134069; x=1786738869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEYEX02IKWE90JSQ/XOJ17bp5Gj7dbgYbm77S6gqa2M=;
        b=ibXf7cd6rUA2dsKEQHyPjesvFB/diSqqezjQ6q7VjVXOwnpIlmIXjp603TI8XBy1K/
         cIWbu2ZXA24iWaLdQLemgAHE71C1s1jLzuaHnQVYWUIMD1JmbhncZTCjLpPw/nI2OcUR
         m+ZNqhM4DU04o9A9O4achUl3swGjC2aB9lBpDzxP2KKj7fWYwF9ueg+tD9FBFrpkb3rd
         vm+byfZ6392EsIILNuiuGiVQ9AywDk9IAHHc7IxgQsoRoJCKmh16FrUbpdJWd3QWLVpS
         v0OoIYYbUGexNRvzny6wnqDJMkLeGb7vJU8O0yQtMp0qJrII2d+x1NsDuZk/QeZYj0Ak
         LSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134069; x=1786738869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VEYEX02IKWE90JSQ/XOJ17bp5Gj7dbgYbm77S6gqa2M=;
        b=SqtpfNZVL0YFI2pc67VVuKShTls0iuWexcUE3mjylZnKwbezpWuY3lgtMFjHfmwetW
         nLOWg+OFP44q654PlCEBf9koQyucHYkkBgPG2kqViBBDY8kW/Bdxmtf9ugUju8kD+g1G
         Sifb70vuUsb4iX81pkbetTgawkgRMyICOoL+Wr6BQMTvytvDNdJ79IuMxEWqJagOYxoY
         ypJ9VX+cHwb6dSpFawYpN821e+GTVK0rncMIuVud9VSHkq4Lnc8LgExLVw+ZnzxdklL7
         7959dBOGQqll+B61VYEOEIWC6MEGGSXtLyBlw2MHhl1whsT2aP84HQmfRVTtptFNZK4q
         N4BQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr25wqWxv3mfbsX/PtOM6Ai1pBTMGGxWVLN0Gqbck5FDir3s26htQD6jRFWQDgTzCoJKoRhOcd2OA==@kvack.org
X-Gm-Message-State: AOJu0YyqbEsa6gCnbDKKeLbf68LlEgE2VDYnMeG8/tCZxcOjTgNAfMs2
	pqulexuEWBBBYC6KOBkHIAMo8rn2i1hftp+TzuRjEswYrUVGmmNQuFju
X-Gm-Gg: AR+sD12724WEiiNbxves9TUTuFu23AkDZkqZJhWQKOUIbOY9z6/tF7gdrlADpl3FiId
	sL7ev3SvOqfgDrYF//juS4Pw38S/+ctLopWl2BluumwBkJqxxTPf9emUyw9Gwv42OqhUCKjregW
	p5pcVh4kN1ceSmWW1JYUrsxBHWBgmXsKzGtRj3+O7QeB80kC17/KhQfRgv7ar7lPqqbtFodcw0a
	5Z5AOkjB2ulyhIhfxRdU0+tbsvDxEQMLPSiCvMMiaTujwN4+NhxhtKCkmO1ALU7R+9Z4ksAcZgg
	Jm9sYUcwatCpey+3DKlqEOmux9xsU0xe1Gy+UJPYinzM0k2K9LojiUK7ZtwVmeC1TU6X1nfeE2y
	TBqmz53uV/jq9HiTpzyNEu5IB0eikBmfgQHCjL5UXKDJm2w1e2rRSYmNww96Go5EAQiF9PRILQ+
	eHMyJWDcu8fs2HV9aPGcrvX1LLf324TNHWVvkZMHIO37j59u/1HH1JxknOSw6CSWEJaNTMo61Jd
	Eg7lxDKcUjxgtY6iqEGlSpU9SKVwrWqN1y/SF4=
X-Received: by 2002:a05:6870:478d:b0:424:801:49fe with SMTP id 586e51a60fabf-45a15e2f25dmr397157fac.8.1786134069430;
        Fri, 07 Aug 2026 13:21:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a9e431sm2643069fac.6.2026.08.07.13.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 06/14] mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
Date: Fri,  7 Aug 2026 13:20:49 -0700
Message-ID: <20260807202059.2620949-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C6E6160007
X-Stat-Signature: qu5z53yz7xhbcs16wkfwbdir7mgkcx66
X-HE-Tag: 1786134070-439041
X-HE-Meta: U2FsdGVkX1+0ai6Hst/3bSrWQPaXR7pw8OFObK25hl7G8NKr7uFiFGBfwWrp7xBKOMDIsszPS5lV7ZoDxuisC/MIaTvopo/NiBHoX3Gnrlc/6TuYAqsl9Fg5pbEJeKdiQiPdKT3Ii9hZNlwXJc+L7B1Te7MjTkjr25PQ7Qgtr366LtBNvU9gI83vh0poJ4wGiZlA/S2eI0cI8H5poEHAO4HASskMswYZT9DjwQy8R9GdTWkt6lqBtiRcHRXdUZ3vPXBiOocObm4oj2Lm5z2obx1zdAy2+50Uxcj0yvii2RGfohlSo0comaECZH7IeCZJH4Du7nuG06ejKkRSW1upR4sft7JUr3OJmmfTRmH7qK8AvH40TdXn7w5D5rYY0TdnGYOFL9NqDXMt5J/EiMvLlsO/wt/4j5ED4r6+3TXL8mWH4/DheyXzLUYy1/W/jaE3w05XUvjL6smq5Es0IESZyt2rwfWWW3FhvcT43o4WkaNrWJQPj1aD/j0epGLGP2XES6ZZrrd8B0LH2tv9emAins1lhmJHo+eiYuumaNLvXgaBolgu9MG7+Q6nMdjiD6mbOHwJT0NdsjLuDLmdtnziKI0vku1unx+cyjHCCC5Hpk9l7M7Dgo9AGAqShwZdPfLzEuXNnTyU0mGI1SQ/UnDa6R/TfTf2wJfw7Uh91mvaFkOg+I4ZTUP1b72OjIkv7x5DMvJ3nHKZ1Ors9wV1PhCDGEsmQCN4qtEpSviADSF+2iqvzxlHIcewudNDvryZ0tuVed1LfT3AL/etlDlcBX4J4uIUGhWyTrFBco27GR5/n4vACzzMzQCNPK9MPK+kUWoYFOVE1CsmtJa9lzinTG98HFXLw8d0hYwtjMvkWibk+2OuZKJruGa6jtdiBvl1I4sRcO7Df8QJzhFNco1UszDHcVm8E37dhYKwrF+yMopu6/LnhYbHqsXAZhdtWmkOJFHMQ0C/4GMXpWvKrU4a2s+
 KJWHUq+s
 CEHuwDXcb6YEIJeb//1UUQnpTdFcfPyaOnJVYOzQ9ApGwvPcBuJoWHGsW5+4ppxHWX3KKx8pyF5wxdPkilBnPbnGPs41pywUjfy91kgda98sChNcnbjqE93R+RUwZ6Z7k5Vq4T3ajNVdJI8xYlEGrQoPbSmAehkFZ4Xh5cv2MbkH7ABUMuoAeED8PVZpNEJVmkFsD+aGovfH7LEHawzVFBw3W2xZeRLUXg35rLc1QVscGEjCLoq3ufgL+6p/xpFkf1bivBQT3Hf3kWCyc6foI56kS50E4WBuvZBDur/KJOIL/79glm1vGbrXm3dgtYjbtS5VTI7ZN3uj5ZWyZEs8sdDS0pfPh+h13dUZep5eu5sZnP8Ak3lFZaAYZCAlg4/TsyUve1G1DWRK2zbQ6dUZpJOKtcNnl8Ud63CgiIA9iUT5LIHQa/IjHQ9wSEv9DBoMtIBGSHXsUQKHRaBsVMGpsEiot/t0bbPhUd8oxHV05KoquyahlqreN5McBQcmQl5PO2fTFM5LOrVeNsP51AvCjD6MiyNoEuv0qYbjU+Pt8tt2ERuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new nodemask parameter to try_to_free_mem_cgroup_pages to allow
selective reclaim on certain nodes. This new function signature can be
used in future patches to selectively perform reclaim on toptier and
place downward pressure when toptier limits are breached but memcg-wide
limits are not yet breached.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/internal.h      |  3 ++-
 mm/memcontrol-v1.c |  5 +++--
 mm/memcontrol.c    | 11 +++++++----
 mm/vmscan.c        | 10 +++++++---
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f47f06c555481..5f2f6a1757bd9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -84,7 +84,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   const nodemask_t *allowed);
 unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 				     gfp_t gfp_mask, bool noswap,
 				     pg_data_t *pgdat,
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 835fc8e511844..688896b59efe4 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1815,7 +1815,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1851,7 +1852,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			break;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+					MEMCG_RECLAIM_MAY_SWAP, NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index defd04acfb3fd..6c67d9d2c9ac7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2397,7 +2397,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2710,7 +2710,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4946,7 +4947,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5007,7 +5009,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17d2b793cbfc4..ffe7ea3c5aff6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6859,7 +6859,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *allowed)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6875,6 +6876,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = allowed,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6900,7 +6902,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *allowed)
 {
 	return 0;
 }
@@ -8033,7 +8036,8 @@ int user_proactive_reclaim(char *buf,
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+						 swappiness == -1 ? NULL : &swappiness,
+						 NULL);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.53.0-Meta


