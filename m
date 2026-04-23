Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8813FFDEE49
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4656B0096; Thu, 23 Apr 2026 16:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056FE6B0098; Thu, 23 Apr 2026 16:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39916B0099; Thu, 23 Apr 2026 16:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC1876B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69F54404F3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:59 +0000 (UTC)
X-FDA: 84690974718.09.3E3442E
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89AE240006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nP1zCIWP;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976497; a=rsa-sha256;
	cv=none;
	b=FzJgkXqOx29EpjzSv3wM6iooAkvlMS4+Y6HkH0dDb5CGtLMi1K53lhEXlkppJESTatvDhM
	+MSmQ9O+qdZs4Ae/MsXbyHQ/1Nf/w5rNIrc6Nm9P3izJl+3+Z8XV34XJEr9ckodUM3IiQc
	zHOGH79qVgmylGrFKB1NWZcVeNlyiLs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nP1zCIWP;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X3Q1U8jtPjzBDt27pK0uFFX6FlshrkPhJlAa3Maqh/4=;
	b=LUPBOg/7koR2qwG+X+M5VSNAb2JaLC4A5tiy5FkB4htttGesXvj7C3oq5DmgqiNJSPSVw8
	LgldRG6J5T2R8pm5lxbCq8oGeXZ2lkj0VPU9zHLECkk1Bkympk9ZMwDCg/VzlEnZIZLIzz
	PhqVO5+iCDgyw3xsKMLtzHGomZV85X4=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7dcd689829eso3251375a34.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976496; x=1777581296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3Q1U8jtPjzBDt27pK0uFFX6FlshrkPhJlAa3Maqh/4=;
        b=nP1zCIWPdWysaVK0G4jkwulRGTdW4bR0itaxCWI4yYvyKxzLnIv79G2sGcUaWbLU5p
         ejQR1a1YClOgQ7WkGdsH/yZJkYnvenrHAT0zAf5luPkohakBxkCTu65RDSCs4d913t3Q
         2OlsLK4CcMguYC3iArbkZHuTDxcS+RBJdmJ2IQucQ0aO9jToyrKjeEOnybSi5Ln/9hPi
         aiOZIy7q14wPt8mZOQPgBxa0SBW7v4ZpGGmBEuwTUgMZq0EZdCG7cdbI448sY5N3nkBQ
         gHP1NOHOfesBSESZ7jnAa5kKTLK76UD8Qs9Ez9sLg7BIulMKvQc4jYpgxbXnQNUnancm
         roeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976496; x=1777581296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X3Q1U8jtPjzBDt27pK0uFFX6FlshrkPhJlAa3Maqh/4=;
        b=SZgRdgdScJLRFYrdY3pgtDl8FOao9qdq76+7ub9z5kg8Kao0B3usAfK2yQsf6/IRWM
         Erl7EmRpNWhIbX6uhNmTSPbDONqvnixEL4+hgxkt7/I5Ws30NOsbCk891XPEkyoYBywN
         1OJSdXb8TySqSX29JOXOOWlrjy8fNdcjqBQKmc4ALOEmnHMqa95kva45Y45NkZ3n3n1z
         tMV1/gaZKjBckJA6UhzN4sB+rGETejwUf7uPm+uPudULb54TKodE/+2lOx61ESaRVvM8
         m+5LC7fU+pi5NrsbTAb+yYEPEgHSAX6Ymw72bHF+daXBPCbxLGVCiG3Y6tfw9e2CaOmg
         FN+g==
X-Gm-Message-State: AOJu0YyMVBOuEtLp56AoZ94zTynfQfZeixvSCfsFamZzuGLNKg8LYu/E
	L3LOGTPcsSqnzOLeaosSfp0r/6eJsjDVHv5lH/FJQePxtunMx7uibXPjsg3ecA==
X-Gm-Gg: AeBDiestbZ9tQeLtLTYo0EfrxmvmwpmTyegacHZWftsJhFDlIxT0p8IXmxqoac79SBy
	UmRs9r0/FHz5PuONiA4bhR4L/Wsp+HjeoRMl/9rTQ7baqGMKCQVr0C6Ugz4M+ELpvf9FDrsH43+
	k+IjIsoWd1fE6IYFuII79RjpOjKvWUw8o9t31G4D9WT2e5Rkw9KAR5Qzq1qrxV+dyFBrfx8JcPz
	DHay6e7WoTHaaZFgN9yW0GJjRjsbHvSauziyg7jy0dE4ZxjVSEHmSZ7YoKl+1Tdblud659Z+cxU
	IygHIQgWqrlURD6krbF7rHbikpKKoARFj545ip68SZ8mI1fnZsT35CvogsJlGYOzFjgF5mNoi4u
	LDeE0HNoVbnQrdot3ICrnu52wNFQ0YvKi+Y/I3mJMB7LaZL7zqykpvmOr19Ba5PoJY7Rr8WzSa+
	/DqFNZY9EHGg8qO8qKtjJj/QFjaix7/nY4
X-Received: by 2002:a05:6820:298f:b0:695:a638:c6ba with SMTP id 006d021491bc7-695a638d134mr4634567eaf.7.1776976496089;
        Thu, 23 Apr 2026 13:34:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-694994277a4sm5603069eaf.4.2026.04.23.13.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 6/9 v2] mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
Date: Thu, 23 Apr 2026 13:34:40 -0700
Message-ID: <20260423203445.2914963-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89AE240006
X-Stat-Signature: u9t15umomzgbbzumi3rhcoyssbw1a93c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776976497-823203
X-HE-Meta: U2FsdGVkX18jXRE5NKKTIRh+tcduZdaFELIYVj/+kcZJOXDw88iTYJCa1JOB0GfvWKLuD/9JaXwcMUGXkkrTtKCYOEBW8WQJV9FRSS5a8C6uSdBKl6LSKXL9TOV0dp/cnAF0ys2gp9TwrjZxGjVQjfrGjMPQIJVPlSwFJob7ZcFRVg0wnzVsBYw0zxvQM8dwFQFTtjIZZpGKBw1FZO0li+jaOpWfOfr5lcFWqrYciLaeoRzG+5Q1RAAYUcskYSu3Sc38Fjsi9uF4kZUFmVoSY6d/HbbVMz84FuSsF3bOdAKS4FtOzjfZXEdBVuN+A/r0M1UIehOnMKPgMp76aDP2+rFZexmbG1nogpgZc5T8oMAQ0s6YV5Dwwh8EMnqD6vV+1aI50xMKyY8vdPguYd/q3stlD62vzPlZyj1GrEBR2EApHZoNzihu7isBVXWG9qADhQGWnSb47iJi7KvYqTbBb8zsWzFbCLOeIUlB40iZ3nP11hNB4IMrxY/9zLY41yT8GCIHL3kCHUMs0cmvQN3zmPuXPJRcpAK6El1g9pNt+1/caPm5p47kRn5aG9rJTkj62yQDztAopWjOc+72CmNwNlB5ZSOZRA6utT/xu7vM1PL+RNrpbkBjGDsdYXnIepzv1g73oL1d1kOxiX3oRZjIoVGLacvPdQiED8bEV6Bmn1zz6yObsrPsfcshxhTtt6M0MWU+K02bJ0WdAuC2jDqCKSJtrat90MVkpdlkL/aKHPY/ttJahDqgZBJa/fbwoLvcQx6KQPSC2qaWU5xuR6f2ABX/bn0WEUD91BwUBH4MrOMoD1Qi8MuVnRbsQhhz/h3ChRMojZeT8R0d3QLumqUkG5xpbmhcJ57uE73TJasxy4ePtLMlL5jEu51hk8pOTrZ7B9pzIvwg50Kk7PcrV94Qyktha/KDm0WVShe+X7g1cHElRbh4Rk3VJQcwM01dxgSaBIFevILB1uMQnabuEq7
 VOHdxoen
 J/Lke/UswV5VcH037ZlykH9ENLFAylqE5r6aIDNGSyhwleuS1DvYUnHllJdfzlFh1HIdvhv4vwP33xWG+cL3xpQuN+bbWVEuePi/alOirANcyWEgLOTorvDOg9iwlwlfHEYdfsXBxUTYtqP+WaNPJsZcw4lnsCP5P8jYIYwQ4Q9EtNDZC/K2sH8bRdjRzTdM+QUBtwaT6F0D/hI8H2YizpKjW6IoR8rY3Ntb51fI24/FV0WvAATBb11Swba9PFlXDQagvDeuSkpw+NNPasOA88ZoAUMvZevDVdbZiJeGNXpCearARkI26pL/Vi1WhsZA5iZ2sast/ot3PFq5pp/8jsbYkb6LCmKI6Z48RmIdK2TUcWujck5QAVkXalQQYUSrW9BFF75jLYI/339KWVDwFEUTDzT1C6uujAhJ8c2MHa/i2sV4W0cB9ZFpxKOv1GUpJ1vxNjH39dsJa49n1m37ybTNNkuKL2jPUdw6uaKF84twXapfOy3Ep+ifn+5sX8+cKU9Y6vJgnm8s06zSEbZJ+6n8199j/6b9Z2Rsrhq+3egA0vFU0rIjZ+eGN5QczOLA/eb2jEYmCl+lKRmQ=
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

All callers pass NULL to the new nodemask, so there are no functional
changes with this patch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/swap.h |  3 ++-
 mm/memcontrol-v1.c   |  6 ++++--
 mm/memcontrol.c      | 11 +++++++----
 mm/vmscan.c          | 11 ++++++-----
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1930f81e6be4d..493dd99f3165a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -367,7 +367,8 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
 						  unsigned int reclaim_options,
-						  int *swappiness);
+						  int *swappiness,
+						  nodemask_t *allowed);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe715..03df1cc71842c 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1500,7 +1500,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1532,7 +1533,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			return -EINTR;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3acb06388405c..3fb1ee1d18603 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2123,7 +2123,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2432,7 +2432,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4591,7 +4592,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -4651,7 +4653,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc9..615aa0c899dad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6807,7 +6807,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness, nodemask_t *allowed)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6823,6 +6823,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = allowed,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6848,7 +6849,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness, nodemask_t *allowed)
 {
 	return 0;
 }
@@ -7964,9 +7965,9 @@ int user_proactive_reclaim(char *buf,
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
-						 batch_size, gfp_mask,
-						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+					batch_size, gfp_mask, reclaim_options,
+					swappiness == -1 ? NULL : &swappiness,
+					NULL);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.52.0


