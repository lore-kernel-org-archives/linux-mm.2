Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED967C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 20:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D976B0005; Sat, 27 Jun 2026 16:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D816B0088; Sat, 27 Jun 2026 16:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5596B008A; Sat, 27 Jun 2026 16:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674AF6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 16:22:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D0718C152
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:22:53 +0000 (UTC)
X-FDA: 84926816226.07.ACC6D69
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA91B20003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:22:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gHzHj2YT;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782591771;
	b=BcooyK1/QFCxCnYFhU6IKLPRQ+nAeGVBhTXPRCWxFFZLseXLPcnX3RswkvRxcizdlKeeD1
	troHD/M/ge64XmjYjGS9jIlAYNgCkktU1c1wg4wN61+hMO3bFSBW3iCfmKau+55Gjd3R/C
	wcpIXYxErRh+7EYRttIjHxPA4w3AT0U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782591771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WwSxUHfK3Ujh5X+1LGpk4GjnutPBz0h9+pc9vXkph2E=;
	b=Rrb2oisWRgrbD0c3PEsrkZ56yLRb+EVIMK/+E0Gao4vVBFonygqKyc17P8Xn5K/rduhIO9
	pcxYiiT2gxz/ShtzIHSuYmTaiy5ze+bRjS+777PeOUbbbteS15bw9gtQcxUp7Z5INia1FM
	dPebhJIol/HDM2hIFpvy6jalAUoDiHo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gHzHj2YT;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92213351918so281401785a.0
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782591771; x=1783196571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WwSxUHfK3Ujh5X+1LGpk4GjnutPBz0h9+pc9vXkph2E=;
        b=gHzHj2YTHGJEj5N9sNfelVo5c9/5yGtJoOaoSkiMzVePrsfnP1SpEm9udOB11NVlXl
         U5fp2hkI9ayRM2C3dNCVrZw2zt36fk2/b7s78ZesE23sL3uErS4RwMrlDLfVNn9VyXXr
         HWx297qBOQVVKi3uDel0mq7e6qBW/gHhs3FVN/pJSblhpyZ2LHds2EnltGg3SdL26la8
         /xvYUseRgapkHaX3phac/1mrHmux3NVCcCUG/arvuVRF94WHfCxG1eONGziNwQ8DXyH8
         IPqD1YxQYlcKtF0e9B/PdpTuHlqzW6UKa2J8paTxYfIjyUPAKvZ1XN/pWjdX7fK91sPA
         MQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782591771; x=1783196571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwSxUHfK3Ujh5X+1LGpk4GjnutPBz0h9+pc9vXkph2E=;
        b=XnVpuwFLlCTvBYPeu7p9EJhlWzqmUk4OS7WISjT9dy4YrtfKj9zVIQKbQQR2Q78IeF
         Ya1drpF1xDSLpJ9nJeR2BUt0coW8dNd5nGYSyX61uPeJICb17GV1IrCeyhlxmWTmBp8e
         8hw4RH0keimvHSpQnXuc5nuhUnOP+XyuQLbGD1ksBj2eMn4J2wXHH7JI+bV5kqgb0Mj6
         kUfW2Dqfv85UrGJciBsFj2lfPnWcM5k76iDd3h6/cz8PhEuYIYgJqKr0hie/bBb1uhfe
         kKUhXkjzapXb7kh99BP6mDjE07rjYEU73OhhWf6722LGfnPK+LMoLPerMwuYdE7Dry6+
         kypw==
X-Gm-Message-State: AOJu0Yz53bqAN6tiE38h0t/3uykifGvvxBQiXw9DZ9wxro5Cz9T/V8bb
	dgiH1uOyyopGVdHJzQP9x+k+Gb6d59a8nWZFcVgBnPZWRtQNKKbFyPGmtgj4dXgRo7K00X/bb1H
	QW4MW
X-Gm-Gg: AfdE7cnE6BP157H4rfRnlBAowrEcZO6SOVzcb63YwjrXE9U7oDJjPfcrzdZnW2FUPWy
	pFvo5AxUoAiWPcyY6CgTNKJJtXbQzl9dHp/tJomBW0BrRfXGST5DskP1n+xUga5KIMfXXYfSvv6
	goqvlemCrVnLmHSPyPZ/XdemwFM5nIZUu87RyiolVN6OuuL/bojRD0y2m0IhW6AqsynD+JrumtA
	LD92D3EJ7jbobpMblchQ8it9xZ+Bwf7bMtVhr3hw2xG8S7Vll5NsW+4k5rY/xNM3eGVNMO140KK
	PoFq3FxE/0m2WTMmPlgPkcGD3gz0s7p3uW2foyKLv56ooSnv2ubIAnV9g//Wi2MiptDn+din10g
	4x5oAqNHGGkU9cUuE0RjaXFPHBFPvSq7QplYuzifCWBdaWNCc2j1RpLzO0etHi4V20h2APo3TL4
	HbivWj5sLvEBQ/o5lsVD/pnOXFQSQ7jPD/GLAl8QyxmpO22vRawIIWYJ0Y7SD7Ry4snL9QIh+8B
	Q==
X-Received: by 2002:a05:620a:2892:b0:915:9fba:878b with SMTP id af79cd13be357-9293a0dc1fdmr1634247985a.9.1782591770824;
        Sat, 27 Jun 2026 13:22:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92600c7bf55sm1540125485a.46.2026.06.27.13.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 13:22:50 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	mgorman@techsingularity.net,
	hannes@cmpxchg.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a node comes online
Date: Sat, 27 Jun 2026 16:22:43 -0400
Message-ID: <20260627202243.758289-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA91B20003
X-Stat-Signature: 6o7p63q41agwsmyfedg5ehehbyggozhs
X-HE-Tag: 1782591771-720304
X-HE-Meta: U2FsdGVkX1/46X4h+ZVvwyVTYqWPdXQk26snW+GXGdrD2BKAgtR50mSnI4Km8p1/2RdQHIcozIP5CF7Upkj9qIm8MW0QwZAgiJX1UGeWy4BXYP9K6GgEZB3sm55E1/up6ceTLsaPQfYQZqyrrrSeoWC3IlPEhLm3mGmMOJZEkPSXLOIphmQAqOwR5MArvP9XM0W0c6vMP7axFVCtpl3+1aDlar2rlZpn4SboJCSFwbvyEOT2Fve/I8thjIDeYM7QVhpabjimPOQwrWqkLq2KqwU2L9BTjI8dq+bhCJHTjAg9sZCmRsM1CAaMLbnmaeZ/Tmcnl/+VVsvAZiE1XSFvaGp7Conhoib4OjQZYiWIlgmzzchCL+Pqy4A1IZuQIlQARF18JacxdXS+shvwCKYr6dvCVlRKuyITE985JLMIEupv5s/gFwkI4H8tPdUBhh4H2KSbjfytW/RXs0woAzhf5nsIHDt5MmltZZ22d1s+j0s2rnVO3nmeURQm5NvIWqN8g1WMWoVnRk5owVLrQgTmJeeDuaP1eOXGdwPh5iakXb353u5zcgvSyzthXTWxcLjBFNMsVMkIlkTHRcAzsMxOyOFLJnV0uEU4ECqlbzx2F5vMmfW4M6ldudrsmomsFTZBPN/TaNXB/4u8MFgLGbCJJHbc1sBpYHjNQqzpNJaW7TrEuzFzPILjNFybfOuipr+ZgEHkEcm6mq14JhnK9Lml2lhW8cJaIVvG9fYsrANcskDyMq32Uhf2wF7Iu2qhcaSt7PVwVQtZ9G/iG8Xd5qsyDFsPYVnTT8cjc/MoLWn6U3dR2IA2KMx7jknK1XOlhtaQmn+YqZoX1Y1LXQxVjF3MnhLyb3NOx/ZDAOnKBpLJF7ul03iUpJ7DqemQwWRbbDRoqLltbjAMfCCQz2mqfFBwXbilq4DAjRiLCeCYCQ0waQZibqPvLzCs91DiDQmoszndhXF+7+u6z9sq6YJqAIz
 PG2JqECn
 kW+OBM0NwmUGdaRTE/xKIBBpAvNkHHEiQuRhMM9VekivvH/+NXOLYp9jumLuTtnpmPEgncE7Q0Vl/hG9LcA2ZagMJv04BsPP0YgJeaolm4HUW4hX8OE9IZrnCD854FqPSgqeqLpKOXos1E/FT8f5O2/EHT8sixpfTwBS7GN5m1NE/asUR4gAB+FkK7Qw46j8sLIAyxSSHcmX6eYKESr8+WuVh85UJ9GxRkuDucyymJ3ABVqiSF2gkFtUfCieF452pfd1YwMPOKUR16DP0JwV0TPdatDVURce5gfJIIlQ+ZOXeVOjRXa94+CUg1NO2KS1zFq6X58fGs7eCH18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.
A balanced counter can sit split as global=+N / per-cpu=-N.

The folds reconciling the split only walk online nodes, so when
try_offline_node() marks a node offline the per-cpu deltas are stranded.

A subsequent online resets the per-cpu area but not pgdat->vm_stat[],
orphaning the +N permanently.  All NR_VM_NODE_STAT_ITEMS are affected.

The existing code zeroes the per-cpu counters and causes a permanent
skew. Fold the stranded deltas instead, before the node rejoins the
online set. The node is not online yet and the hotplug lock is held,
so the remote access to per-cpu values is safe.

Discovered when node compaction hung for a nearly empty node, as the
math to determine throttling broke.  Reproduced by repeated memory
hotplug/unplug cycles on a node under pressure: NR_ISOLATED_ANON
ratchets up and never returns to zero.

Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mm_init.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f5301d4de91a..c119f6f1497d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1536,7 +1536,7 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
-	int cpu;
+	int cpu, i;
 
 	pgdat_init_internals(pgdat);
 
@@ -1554,10 +1554,17 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 	pgdat->node_start_pfn = 0;
 	pgdat->node_present_pages = 0;
 
-	for_each_online_cpu(cpu) {
-		struct per_cpu_nodestat *p;
+	/*
+	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
+	 * offline nodes) - reconcile this at online. Foreign access to counters
+	 * is safe: the node is not online yet and we hold the hotplug lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
 
-		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+			if (p->vm_node_stat_diff[i])
+				node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
 		memset(p, 0, sizeof(*p));
 	}
 
-- 
2.53.0-Meta


