Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F46606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 21:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RpkJzhWG
Received: by kanga.kvack.org (Postfix)
	id F1E8D6B05EC; Thu, 12 Nov 2026 16:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7496B05ED; Thu, 12 Nov 2026 16:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE58B6B05EE; Thu, 12 Nov 2026 16:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8A706B05EC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:47:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27942161C5A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:47:47 +0000 (UTC)
X-FDA: 85427804574.14.F1B7C8D
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6458B40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:47:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RpkJzhWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794520065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OtdlhKZ9G3DOjiAGL5mHW576xMlg85nEbvlb8HjXia4=;
	b=ceuOOZspsIcZ5QFq/KMeC9c/WelOH9O3UgTlFGPZmcMPEshpKD+Cc8IdWkwdV0QcDQQipT
	/KufHZo75F5G5/rqUDDF3tx5G4oNGoXw5R/ujyBHpvtRPVdd+Sb5x+0q0VSWdGjBQV1RF7
	dG6t+dfKHsrqZo5I8/s9FyQGf9aKXsk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RpkJzhWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794520065;
	b=2xVrJDSFlyfUHQAgiOIf9ome0CHzv2nb+iAgBhNcWTy67C3brn23rmbKZ8scQC73bs7kZs
	FCHlNOos+/QPh9GyO8FsV7DVZ5Rv6pmtPPbc7GAb/ldWgLSWo/Jkqev7wY4hFgSvq1YuTq
	+muS5eulOVGpe0wO7HuesUAS0r5p2AE=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso4723077b3.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794520064; x=1795124864; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OtdlhKZ9G3DOjiAGL5mHW576xMlg85nEbvlb8HjXia4=;
        b=RpkJzhWGF9yFApD9adZW4AwFvbD9wo6aRBLvhh+DissL3lqoScGK+kMuK4FagXUhaZ
         +DNSIIsZvgV7QQSKBSC4S/VcoJ0FRNUCvnv0urpRNMH5LY9ytu31MLw5q4cAH7O2yhrF
         oTxdqHJiVWcZffee03GCBqY5V4LO2xrxI7SQKQyerBwXfkSpDqar+ekJ1HbgwCaJUy3u
         WibOkZJW6q+MYQKlzgzX6g9byQn74MVT7R9mXKQjaXcawDbB2xeBc6ehuzPQ08OqXHZo
         XWxUk57TdAVHrfbvW2qhPjFWkrLNAsJRVAVhuN8A2xeiqTu6WIY74FHqSQLdREsnHpgI
         7Azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794520064; x=1795124864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OtdlhKZ9G3DOjiAGL5mHW576xMlg85nEbvlb8HjXia4=;
        b=mG02jdZeqPiUPxg/2xFJLu9a0ssBmtxzTKn34inOnUyoOMe1IKp6jvo74dH/0+8re+
         ul9CnFuFNEFbRg2mENd/1ycLUBd3d4HCUdYamKBqofpQbe5emcQ+P2yqww6jroU2wH+N
         O6HhADXSkxucvwi68tqHWsUe/0LDRg3R2kTZ7/eh5YbdshGEShzQFqLSOBCkx4iJjK/N
         /W+WgBfiCfLHBP+JDsVsz4HQfEQt4TdXGa26GVa6cxWoWxm/kTznubRxg5VpmRDIJhsA
         zL536Ml+L8FOJ53oO0uXGQTTl7L84SFVhT6miiXKLNoLBewT0C/0q7BT5Sg0AiU9lJfI
         v/mQ==
X-Forwarded-Encrypted: i=1; AL+hErHcuFgw/M813z1qGm463YITiZZnDZyT+1yCupwlPUd2TtdzSF0Ml8OQ42blPw2QDav6e+jbcYQ4Yw==@kvack.org
X-Gm-Message-State: APuU4Z/8Tyieyl249RK0Wpl/bV9JhPkxLJJ+lOmg29DJkOAy/C4A3Ymd
	U3XtsNm95SKu42ud2x6nyW5MI2I6In7IPmcPlS0u+kbn0QhimXAi6z5z
X-Gm-Gg: AYBFou1zR2by6qRE25lMjYHGl7CpKN3iBuH3Z6QUPbZ/8U1vJpQ5lGNtaUEj29rmnf2
	esGdjDpGlWRtswZYJTKGwrc85lIxnxaaQQFp0Zv4bMZ9/9+T6XUtC1Q1DJPtKBX12VTkxYi6ueQ
	JfEju8XRNWn7khkBfNG2co2sDrpP3dYVFDGgDJGGQl2VdFC7TxSlatlT41FK0PiSMxJ/klzcB1x
	blqXauouZ/MMGrKB7qBz/c9E626/OA0kh6YlsMWhJyT3HO5nGlStbX0nfyRL2P2LEfgiskHCqn4
	CXdABw5qlkXsvLiyQ8JY3K2AtLjH6YEM4SI/zxjRbJgBQLI7lWDGz4mJXdoBv8OotGJam+k0HZH
	WLcy2B+f+Q47xecLGSM5IU0PuRsqrHFXRLbS0+Ax5K9eIxPymSWxJk8Zx8Jj0ut2uPfBYdUIQHy
	yVQ3+BmvxHTwEQR1KZ+u81SlYASF8Vjb0TAPFcTXHik/IB/DzR+/HZ9NIyELIwhrjbheqtXBy3E
	iEZJehHDRBGfr0+dUus5xf268+++3H9hvUa51KvC7E6Y/NwGGiukfhianJRvmyHvtKy7CvU7pNK
	5Oqs7AEBjZCEGkvgDVjAHXcr/+xuQg7gWbGJiykjWt66EjtroGoQwoTnUlk=
X-Received: by 2002:a05:690c:e3ed:b0:8b1:f47:9c07 with SMTP id 00721157ae682-8b4aa25caf7mr6200957b3.25.1794520064454;
        Thu, 12 Nov 2026 13:47:44 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa931272sm5987177b3.16.2026.11.12.13.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 13:47:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	Daniel Hodges <hodgesd@meta.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3] mm/page_alloc: only skip kswapd nodes below their kswapd watermark
Date: Thu, 12 Nov 2026 13:47:37 -0800
Message-ID: <20261112214738.3002458-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6458B40006
X-Stat-Signature: fabpsgi3hrs7993z6zxahj19kke1aozf
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794520065-366495
X-HE-Meta: U2FsdGVkX1+ZjeC8HqYviqWvEIEeezJOPZ703/2SSUbBAPAaNhK3o2VIpdRjLFzbqcnf43dP23g8h+eNbzZkpdmeuLxeIZT7LSts30tCZhmmTQ9hsc63dpujGbQiPnmv7r99IpdzgBIgdDykm9m2cBGjD5rNYL+FaUY53twNWWknWMKQuioxHL3MfGTcEr/LmeXB7JdtAa36xEQQQN+6nLDnaVqCgg7UTQBJwZqwNwXcXu1SLkbVyXkIJcG3X/5PqE0Mqv9XIHRcB6k8VzSCJlf3jsQx5sQfkaZDaY/J7gyvss5ojVubZFMJh/N3WY4Pf4tDt6hHBF7K/eLxK+dwV9ZRv6as4wZDsufy47IVqO4upbdA0ssLGJLaxLB+dE/dLLxaPLhZAQ/h5JmRiMpctIFYN/MzZIrkRl+ZEFmiLlvD7ICdY1851JrXhwv0aQzfkmT8S+zpfJxvLv1qA17mJKCQr+aLJv5ivE+K8TXrT+HNZtJu429jRN4K15Ksw79Tyd2Ti014dy8rEV0aekPjL+TevTTRnHyqiE+SfhV9E0zg7VRGsRMefhjqFzBWGzXd91Srd7upAxNiBTpn0HXtiV9CXZ9aqNqWTgIKkOHeL21KDtm9+noLtyHrdNKIX13W1KYXtAgBMbTCRLTen536LFWHJA5gIt5D5P+a+nTQVNsIFg1VbStprvt632VXFRqC1EKnyrkxb2HPihIgho5NwEKPSvHaAZHHKziQE9ppma4pEncvUSKm2kC+wj2KU0ppWDFgW2TglKjktPHQn4RdONmzDsD17fa1/cPrWbsijKIvZdtFUpND+2ie3ui1ZaBt+zEnsn0EcqzKl2P8s6xNXkpLVnLDgjBRug/aAmLoQ9UlHUvxi3eQ+1iTWgCQllxeXBXDUQ/KjcMgwobwh99WKErwLQzVBoqOaJLzuhQbbqiEeGvOmzR78iEwoEeMFzR1sczZnxrzqOkyxCe8ynD
 XsAiHVJo
 YJI3dm2ZWGyWHkzpJqXKWzN8RL1cqyZuJTAaUxvWkNJoqZHZwrbMVNvYcy13yZrtyKseXdJOBcqAgmEVunYHiRfR0IYHWe/OxezRRZRZkdjrzzk5lmfvJXZULQQFiVy36I65k0gABLnWBIWKhRf+K09clK8pP3lP3NSRV88OwaPQs5M0Dy49z+OgGL+SHpDVKJerJpkiaEPL9FTex0t6hhFGdMxYftt120lEtruuVAgFAShUBa/Dk2Y6YgN5fFVAj3iKiwRa13beMsLjG2q+7kUL4UHz3baGd4PaLlHrEdb3RNnsEO4hAU8AM0IGmogi/jpUVHhAKde5ANaSe82tLpu8OUkdjbWr3yqj+bs2CtpdKl6mOJmiq4xkBYtOnTcqX1jzc+O4xl8klSSwGzahqRAYwSbSxfvxuFSKOpvuzwlShfCllMRzOKwuNNpSr1kgYqelmjrjMu5Qp6qlqGP/sGOz86dQwjXLiltxc8fq6bOlXLaYlqvenr9Z7Aq1hB0r2hfd5L/1MWXM7koIaKW4DkCw5nNBWlkxZfBpiK604nxAmEyxVzEWKUjHFBX5uFDxFI3rVD6mqsFTfhvyW84ER4NIX0z6sXfyge/J3dgRtNyhskC9hABE+Mm+NIoVq5vqU5V/5XShq6vmSqPCNEw1z3PQtF4ZmVA8iUG4isMz5Jb9ZCSf1LHwrbR3obsCFPKFnxTdBP8BSR6vYS58t1r0ZfHzEoOTLo/bYZiOX55OgXPMNeID0ECT9k2HPNCbLefdGkPyOeBrnTiny5vtJhboPxDtwLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
NUMA restrictions") makes get_page_from_freelist() skip any node with
kswapd running to avoid piling on already-pressured nodes.

This assumes that kswapd was woken to create free space, although kswapd
can be woken up for other reasons, like higher order allocation
failures. Thus, fragmented nodes with failed high order allocations will
always wake up kswapd and direct order-0 allocations to the fallback
path, even when there is free space.

This behavior was observed on 2-NUMA Meta production workloads where
faults would pile on already pressured remote nodes while stranding
memory on the relatively empty local node, causing unnecessary pressure.

Only skip nodes with kswapd running if the node is under the relevant
low-memory watermark.

On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
and defrag=defer, I ran a process that prefers allocating on node0.
With a fragmented node0:
- Before the patch, 66% of faults were served from node0
- After the patch, 100% of faults were served from node0

Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
Suggested-by: Daniel Hodges <hodgesd@meta.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v2 --> v3:
- Shortening cover letter, suggested by Gregory and Johannes
- Collect signatures

v1 --> v2:
- Added a Fixes tag and separated this from the other cleanup patches
- Check zone_watermark_fast with no flag to match the call in
  pgdat_balanced().
- Calculates mark outside the zone_watermark_fast check to match the
  style for the other zone checks.
- Wordsmithing commit message to explain the unaddressed gap.
- Yes, this is ugly. I have another series to clean this code up but
  I wanted this to be a feature-minimal patch so that it could be
  easily backported. Things will be much prettier once those are landed.

 mm/page_alloc.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8532af052d74b..56121c3f9c4a7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -45,6 +45,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/sysctl.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
 #include <linux/memcontrol.h>
@@ -3799,6 +3800,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
+	enum zone_watermarks kswapd_watermark =
+		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
+		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3866,16 +3870,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 		/*
-		 * If kswapd is already active on a node, keep looking
-		 * for other nodes that might be idle. This can happen
-		 * if another process has NUMA bindings and is causing
-		 * kswapd wakeups on only some nodes. Avoid accidental
-		 * "node_reclaim_mode"-like behavior in this case.
+		 * If kswapd is already active on a node and the zone is below
+		 * its kswapd watermark for this request, keep looking for
+		 * other nodes that might be idle. This can happen if another
+		 * process has NUMA bindings and is causing kswapd wakeups on
+		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
+		 * behavior in this case.
 		 */
 		if (skip_kswapd_nodes &&
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			skipped_kswapd_nodes = true;
-			continue;
+			mark = wmark_pages(zone, kswapd_watermark);
+			if (!zone_watermark_fast(zone, order, mark,
+					ac->highest_zoneidx, 0, gfp_mask)) {
+				skipped_kswapd_nodes = true;
+				continue;
+			}
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.0-Meta


