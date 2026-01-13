Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BF2D29DE2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7876B008C; Tue, 13 Jan 2026 03:15:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB556B0092; Tue, 13 Jan 2026 03:15:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383CF6B0093; Tue, 13 Jan 2026 03:15:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 258926B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:15:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2EB2C0A39
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:44 +0000 (UTC)
X-FDA: 84326231808.11.A316F26
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC0E9100003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:15:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9ipNHRO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768292143; a=rsa-sha256;
	cv=none;
	b=INiVmyABACalTy6UstGoD8q/Hf4oROgjgh3VDLIvjuGqwFCbJUfXmd8APC+sUC56/nZleJ
	WRNTE273C8/eBsPrwwF0KE0n64FIaeWRmolJjIM5hWMfMGz11wMCv8FCmts6QlvEke8aZd
	fP9mCf7BApzc9HLEPHFQP4vy2LkRnKQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9ipNHRO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768292143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn+2HMuW53bWkoRvrsYzvFUGyuuVFRazgaZ3DqLSbig=;
	b=mu3SlL5rGFZbN2tSMvzLx42V0UiiulhGtUCIVtLCQp+bwxEmUz5+LHbtt+vfdFaAViJ4+g
	0V1P8LzBdyxJf5OPrqE6oHuVvLP9sOZiRk6h6quUZX0JMVH4Rz/aepQV+zB4n0kED10atm
	f3d85mfUTMcncu+zrA/GvzOjlNJy1WE=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c56188aef06so1462042a12.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768292142; x=1768896942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fn+2HMuW53bWkoRvrsYzvFUGyuuVFRazgaZ3DqLSbig=;
        b=F9ipNHROVTJ7lbXWd/FAOuzPBh6BS25lG4IIcplaMLRuaWJklxvMBDQE4V5evj8nIW
         /fGJljiEx6OBUw1jZSjgHaTO8bYMcMkqgzWFNR7LjPyNVI0Xuhi/MJaTbQcHeMs5FVpO
         KBZ3b9syPCZx7SB1VuO+yjRsHmw1TCraYvEy03Vc8Hh4i7bao76ijTzQU9IrnNZLHxgp
         4MjGlXqQnKknDtFALCQIsXmxwdhjMLJjDXLyTAuloV4E7yIPVJ8tEmDay7ySdVB7Ve5f
         vn2j5ZJ3C6dmZx4iT63jJR7LO+QTMpn6wDegNhSBv36lhu/okYNBYyqKWQW6LKLolgFY
         YB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768292142; x=1768896942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fn+2HMuW53bWkoRvrsYzvFUGyuuVFRazgaZ3DqLSbig=;
        b=N3EfU0Hs/lSbeZSiOsEQYt0xn8PgeAaEe+e9637Dual2mRyoKmb4kUQ1laBDRrbiwW
         55lM2DP8cosOwaZ+xhSjcjA89Hob09bRaGDRUSCxv6dRdQi36zbVn/jf4pNuwSayzSMl
         IsVE2WJ8p47ohBDcn35PgEwZmzxyE/ajYJoC/ufhnAMkY7HxAE5kXfANck0ARCm01B5U
         Fx2CYe/sg5WOU74PehuRrcUv6y23EH/An2EGR+dMNozr+pT/6z8bRvNzs2R1bWrQp/lF
         luoWsvvDAe0fvSQOvhMVSU7lH8RpiU89VlbYqZUD7jGo6YdzrLSvecjndMup/XAnlBdc
         OoqA==
X-Forwarded-Encrypted: i=1; AJvYcCUXfw1G78KvO3td0KYomb62VNwwZPFtahR4eQVEapFsnHPmUxiv24M5ef48WvUxCZpALxUhjxw8OQ==@kvack.org
X-Gm-Message-State: AOJu0YxzVDKAuXVpcE58SLEYqcZAP6w+yK/7urj5YtbjbGSjeVTbpJHw
	t3uJh0Jm6YsUHWSrpQ+2usUk0pk/OkCnzUsqqPxEAbDeGwcdxoLiIn8V
X-Gm-Gg: AY/fxX46vAnxWUXgnnLvsipwWoesiriCDuC3Jj6f9bhYG+E5b6E5QfaK5YauwxjYgH8
	14DturTdjER8auSjngG8z7enVbnD5w9DGyJMFOLTfeIhFRGIOjByXjI3PYNA0RFB/N9mT5aPSGN
	KmO5215HhK5DjeJrmtPSvJNh1xyA3joUVcQFsUTL97pTQBb7MEQ7oD6FPVQu40+PQV/gjzPGxTN
	DOXnr1jv/x6DzZslno+MGHQ998wMlXGfb3ubFYuMah3zCYM1TifBaNI012c03HWM73DGbac7ss1
	LK6Nq4Y50NVi/CR4/l57yA5uUqhrwSK0CKvrflXTTrOuua2bnXpMiShTtwR8+URWfm6QcXWtg1a
	1yXpF8LW2OPUSG+2o9jxAI+Y6tIjnpI6zmRQMKSwasf/xYefv0FYaU/80FUjDuYy+npignyxC8d
	3hS6+ilBHfn5qIbs6SjWGsIXMCGA==
X-Google-Smtp-Source: AGHT+IED9gfPtbQO5QOad8Z+7M8wVwtLncJwWLcyW2QnowsMI6f260Caic2klkdpN/rarjVFLNQLMQ==
X-Received: by 2002:a17:90b:3852:b0:343:b610:901c with SMTP id 98e67ed59e1d1-34f68cb9036mr19913726a91.26.1768292141715;
        Tue, 13 Jan 2026 00:15:41 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:180a:3788:c683:2f64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-350ff05492dsm657199a91.3.2026.01.13.00.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:15:41 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	bingjiao@google.com,
	jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Tue, 13 Jan 2026 17:14:53 +0900
Message-ID: <20260113081453.8293-4-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260113081453.8293-1-akinobu.mita@gmail.com>
References: <20260113081453.8293-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n6pqkzf5z79h6tt8tfigjrgts6trxwhk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC0E9100003
X-HE-Tag: 1768292142-168364
X-HE-Meta: U2FsdGVkX1+NGvGkZpIxzPClDfdbsVoG/YoHmloWRCzAzC8k0ys7iiSRSlnCgfnqVfC+X/3X9SPMa2tvK1UHBwC+dybUtbYXRpOFtv30GYyg0gRu5lgZueBr8QJnE3TDCOWFtWAZVO4pkpkLwhGnM0oA/WgCvsR5YpNLZg9xjn74j0pY267xYn/Vtj3YGqy7BJNX2TFhEDE0kBRV10AHtKn5DW0lXxK4PJN3+kRAzE/dEtyW0K5gT96myqnmHgnHKmuDbMUulo1cjWmOiK76iPhcObErJSqSh/QpHeLLnA5M1ABF6K/Ilw0c0UahGEzjKERYw0Z/IX08FlZN14fQ88CUc5J37OSHqOGhlEqrRRI4T8BuPNyXifTiJ9ydjPkE9JSqihAtTsaptmNK8zkHW3Km5Z0mdL42QPzjLr4RyqTIsykwH6qoZKsGKgP2/0OSshTJJjHpxAd4TD2i6ilkkkqlA6r2HyZasr5LQwRr+S6jJBneYLS4K5CMMsRBZH7tUw9tVJ9mcJh4UJw9McLZdu6SfG+pIDpS7QiVGeX4xrtOHSpnqXWjzg6VbijO+4jtHps/I2jbOnM7QP7OPjPV6vgamtXco+LCEYVSlR6myRCiyvZaI3Fv6utsucwgiicoN+1NLGuU00BEGPaBQZYnmiFuy7GtoX0kbT5GCkhfTJhI7yJV5mFqaAWsKYyJGxzA0a3ZaT7prdliBy3I2/9IBaMItx29TcwKAanMZLl0/RA5zBuOuSFc0USTMCowsHrsdmlDzm5DuYFVdErjbYCJ99dWZMGRWKTLekOlu4FsR4Io7k0aN4fZkLUpbkdG05PjbV57hW8FV4bcyEl/8nLp54+zaAveD+4WRISoZMbIDHowhF7GMm80gq73QvVZCLd2OKLzuORTwlTJBHWAn8klgrcRUkDae+HsqieYfStXcLr7+cXODBGuklJbxDEfK4w9dvyek4oLilPOwU8Sblr
 KPiK+AIc
 wDaO2DzICsFsb5SKERw972EyfOR1pzQja/0QFVm8ONpr5N7+VG0DJ9rk/T/iRJs5BedaOiK48vvsmGBNaSLnuBe4MkTeV2PJsdfPl+P3W+JZ2crOUBnWrvtqhJ2JbscIWTebMbeLKrBgVrVU51gLdPiYh36KSaSXVcPDq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

Here's the command to reproduce:

$ sudo swapoff -a
$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory
size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
/sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
invoked and the system will become inoperable, regardless of whether MGLRU
is enabled or not.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM.  You can create two-fake memory-tiers by booting a single-node
system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
parameters.

The reason for this issue is that memory allocations do not directly
trigger the oom-killer, assuming that if the target node has an underlying
memory tier, it can always be reclaimed by demotion.

So this change avoids this issue by not attempting to demote if the
underlying node has less free memory than the minimum watermark, and the
oom-killer will be triggered directly from memory allocations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v4:
- add a code comment in can_demote()

v3:
- rebase to linux-next (next-20260108), where demotion target has changed
  from node id to node mask.

v2:
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

 mm/vmscan.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f35afc5093dc..f980c533c778 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -358,7 +358,22 @@ static bool can_demote(int nid, struct scan_control *sc,
 
 	/* Filter out nodes that are not in cgroup's mems_allowed. */
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
-	return !nodes_empty(allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	/* Check if there is enough free memory in the demotion target */
+	for_each_node_mask(nid, allowed_mask) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(nid);
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
+			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+						ZONE_MOVABLE, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.43.0


