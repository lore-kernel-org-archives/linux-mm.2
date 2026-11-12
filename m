Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8009D606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 04:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=bOlrVnZ+
Received: by kanga.kvack.org (Postfix)
	id 5B6EB6B00EF; Wed, 11 Nov 2026 23:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E3C6B05B2; Wed, 11 Nov 2026 23:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6706B05B3; Wed, 11 Nov 2026 23:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11DC26B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:14:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B8661404AC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:14:36 +0000 (UTC)
X-FDA: 85425150552.17.ED2F25E
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD14740003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:14:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=bOlrVnZ+;
	spf=pass (imf27.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794456874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
	b=7GoCol2BUBLM7JLV7teEbG0CY8jtbvNG7LJALhPWJq8GkyCgQ8gELykSYtQJcJlRRBKTVJ
	EuQd7ZpIgOAVP7pMzLjo9PNey7H0Tn36P17W30gzFDrJX2LapyQSFt2s8hFean2ivtcWQT
	2vm14yvDncVVbgIch5HwYjxUIAJOXec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794456874;
	b=K6zrPPg5bw1NdVeRUoPyMSuEaLTUY22JHLOBwWsJGAHdZD5Ha8QdFtRPTdmzYF+ZjOxz2r
	x9KF19/hKIAVqXqybcMHFzP2IHgtWh55qO0HsN7O5NZQlyl8wCqJVb4MdecD6BT5CGTL2a
	WymuwDIF9sOU2nsVNN1/c9PXCCmfP4g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=bOlrVnZ+;
	spf=pass (imf27.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b179528d56so962858a91.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794456873; x=1795061673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
        b=bOlrVnZ+zj7FGhGmvg43IsfH/Yr8FL/JRx1UaoaJ+FPl04dzeTM9s3geONTolrbZHz
         6Li/d0velpxgskXuZFctRj4YsoOulpSOi0hvUunGd6ZqBu5P2Enh6X0nqFnfRIkqJsvT
         9gFdy6qz9eL3FPjqQjYrdHxc+/dE847gkbePZQOhPEcQfteJuuwkVzmY3ma0gfiJxbTF
         j3friz+x2srOqlvCq85HSCh0Zg7YVPFbEZkdwmAN0BGgyOlpgKXkOozB4nXEJ1Z7+DOO
         ghSmwMKGwiqsUWKiV1QJJlysDs2z7Rs0z78VVG3kYICDW8DF+2C6Xyq5CfNkyOeXZPOh
         LouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794456873; x=1795061673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
        b=bmoanRCHN1VGqEt2yzEGLUEJ7rI4yRfmg6Bp2fTD+5kuWlMEONaKOyXZ7i0Cp7NZco
         wYFNkzSu+rx/76VQDaFyFbs6ZeLj2nkrbdFB/kI7NLJHDOB/oSSy5AWI/gug6LqXWXFy
         V/U7iEyNm1pntY5heOihP7dNF3AW9gSRKDB5rI/l/SPLcEDqwwQP3wCT539PHBrFUmC7
         D5RbZKb3dV7KM6C/rahsa7zIqIL12OT9msNKZIuzkMBARz3fmJPhPOWNO66VkyyCbqdW
         3+9La0DyOrbT0PXhBuTCf16jmWYca7adJi7huJUWud4jFgG5YuIpGgMWpf2iYwYieFyZ
         Ddkg==
X-Forwarded-Encrypted: i=1; AL+hErHqeloQFY9pX8+7s76O/mB9pRGtSmFZA5n6YlVVvDuyuYBAiDB0KWZ+KcIRiWsEvWe3V9j1fSwVLw==@kvack.org
X-Gm-Message-State: APuU4Z/lmogUA6FPBhSFNajKobTgWHHKy3qQKAWfO5u2CVusCGJx2ns+
	anajrW5BKttLS+qOftjq72oX1tSv51vQlvozuRnpSjFQH/ClCXJYzfrZ6Apn1kf66iM=
X-Gm-Gg: AYBFou2gW/fYrkAAnqLUfpN2ohthWrtKakV4KzTECrLYDfeLCIUe/WNs+wnkFIYC20U
	wx6ZW/NIqo8BRe8huyuKDSr9K4bFzHkHAni5bXmOb4qxSlKVPtAS88HCIiRkSvQC59iX0NaBW8X
	6dUyUGGzNo/tugG05MxBj6Af0WeEbHCDj1l+LjdLz3OPNkObRcAAeInxSoNdqf5OZRxvg0M+YYh
	or8mgagVFV9Nt4NYtOBpsn23PlVnMDZCtYZeZ/l3mlelUMI+mFz8GaETt9vXN/VoUl+eX2UBMyZ
	aPP+nTS4mxvjtPM8/sWM1f3hXpnTDKaT4SEktCYc1XUdxIan2io/qejPxR4dcvJImv1zkJo+Q9m
	q/ZrhCbEGNppuZTCP8DSZMJ4uBhLNBEDX46ZP8tftdhxbl2dLb6lZRHv/zvlN9fwE6Jr04xnAit
	dq9lXwBvC0tncD2LuUcb5pU9gOsVkLIJ1omyXseWHoFP7GoUZ8fYxZo1GRHWCx3V/hcNE8p58J0
	pQ/M/AweksnwZXIfInhK2TbOXWm+T601cWaQ9xbb/qZVdHE/QaPMBsUUMMDghaioUPirKWKEWYs
	E56nLzC5r2q/q962pUo6i238nqssvNMyWCNI6AZkLMIgwbsTqV455WKoGZf6nOeMxQKH2/3gQCc
	mjHPuwmP7E92E3eE=
X-Received: by 2002:a17:90b:1e47:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b182fcd7b0mr3552008a91.63.1794456873292;
        Wed, 11 Nov 2026 20:14:33 -0800 (PST)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com ([143.92.118.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b182de1dafsm3451131a91.3.2026.11.11.20.14.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:14:32 -0800 (PST)
From: Runli <mingyu.he@shopee.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	littleswimmingwhale@gmail.com,
	Runli <mingyu.he@shopee.com>
Subject: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
Date: Thu, 12 Nov 2026 12:13:48 +0800
Message-Id: <20261112041348.66915-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84bpjjsxrw9qgqk6czg9mk3hopacbh7p
X-Rspamd-Queue-Id: AD14740003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794456874-383416
X-HE-Meta: U2FsdGVkX1/V6uSJ+ct2IpICgHjt4IAe8+6Xb5UCxhM0n2zIitQwYll2yczySmXar4GtfH623ctutKoleD+I/JY/TWY8gxxPV/mxo9n49/Tdu+4hubKJXXA9PvA/QK5sv+ladIDJnUJHTWThEshuf2f36dIXR38NMuDSnLwmL7SMwoH1AUFLKlNv2IntImZLrspAhA2ezY/FduPhPOytidEiuRPsHodjYuwJQAhH7CnJ5Y77xw4PHKsrObr86gYgzWluo5oQ4aWnINLI2tSyy7cFWHfOFiOMYfUtiHgFqpa9IHW64C8Goff+6UN4+fhPA0GEguUZZiCAeOQjuJToErnWnDMgCn5nFSwrxARq6J9/pUNC6s3eX54x4AN1KhIZMdPX8hiH4Pn1gGc5anlvQSYSotpsrlfJPh3cTbSs1gIzPP5Koo9iEYCsR1QnJucvOC2bznm529jrph31LYQdUVIniSaQNGiCGo70vNnEA7YS20oX5udpbmvL+aa3avNySEtc34P7nLLpOqEJwrlAmqHERAMC2UwfT1f8edrFJqTuhIhr/oEJA44lTMLXoTs4U4I1iHbOZFsx11QiWziR1MuNHv/OD6uZSd3vXBUB48kDehq4tS89InZEFAHAPyJyAWiNqPtCJIZ8F0e+UnoLYjt7jGQvnpDQF8hUIFR4PLxG/F40hhlMbVY16DG05LFGBkEo8e+5kxXePCzZ6WAvDoGd/4rOwoM/D4bfLoQDyj2Z5FLTXuQhM/SSYdqsB43dM1lSmztZqm6hSDC9A1kLey+t3Gvzc1BRvk/L5ezlXh4xr1PjYDxZiFnm7/gXGXBHnw+dROKoKC1hQOHB/ZAESq/biNgehYPNXU+tApIoLmBFaO/Gb3PNW9UpdcgqDZBPxazKX+ZnbgjKv8+Q3xgd+zr7rVq5NNtQguStpHZlRseq8N7Yd16Is2GzFI3iXqXR9DZRcuRVmzz5oxJEZuv
 8HEAAahP
 6Shd20plFIC3utT+Z169UqaRaWDktehe44it9E7uwsmh9AtDovID3ve+EpOLYrbbn7YhbedQ1ISe45xTjDlP+R8CUDrFNjeaOpa5EgNYzwKIUK1f8Ms9bUzMbk5lFOQzwtKBjk8je/Q3b+s/VxaszFlck09DCz0/9d3BKGYA8Cztyhur1ubGH+kng2kBOYXQaeeXx8J+nCTjSBYs0/kNKrsPQRhy03EyjSsQAXzOV6dFAmTdCfruNq7ug40nfULAkNRIXVqG4/9g4QVw4hTO6xIFJlw2rCovnk0ipdOPJB3nKHm20roZyp2Yf9G6Wjb9CMMnk0+w7/7SzlSTf89ixHSaq0LBzZQCU/ThgPYyatZjwGuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
the flush threshold. A concurrent flush can leave an ancestor below the
threshold, so the early exit prevents it from receiving further updates.

Consider root and leaf on a 4-CPU system, with a threshold of 256.
CPU 0 is flushing another CPU's stats after CPU 1's stats have already
been flushed. The counts below are shared stats_updates counters:

  CPU 0 (root flush)                CPU 1 (leaf updates)
  ------------------               --------------------
  clear leaf->stats_updates
                                   add 64 to leaf and root
  clear root->stats_updates
  finish flush
                                   leaf = 64, root = 0
                                   4 more batches of 64:
                                     leaf = 320, root = 256
                                   next update:
                                     leaf > threshold
                                     break; root is not updated

Root remains at the threshold, which is insufficient to trigger a flush,
while further leaf updates keep taking the early exit. The periodic
forced flush restores progress, but until then the root's aggregated
statistics can fall far behind. For example, page cache grows at rate of
1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
the actual usage.

Make bpf_mem_cgroup_flush_stats() force a flush without waiting for the
periodic flusher, while preserving the memcg flush bookkeeping.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Changes since v2:
- Add mem_cgroup_flush_stats_force() and use it in the BPF kfunc to
  preserve the memcg flush bookkeeping.

v2: https://lore.kernel.org/all/20261111071434.34547-1-mingyu.he@shopee.com/

Changes since v1:
- Make the BPF kfunc flush unconditionally, as suggested by Shakeel.
- Leave memcg_rstat_updated() unchanged.

v1: https://lore.kernel.org/all/20260911032905.63683-1-mingyu.he@shopee.com/

 include/linux/memcontrol.h |  5 +++++
 mm/bpf_memcontrol.c        |  5 +++--
 mm/memcontrol.c            | 17 +++++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..e4131a368d8c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -988,6 +988,7 @@ void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
+void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1464,6 +1465,10 @@ static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
 
+static inline void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg)
+{
+}
+
 static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..f04be9479e38 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -154,11 +154,12 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
  * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
  * @memcg: memory cgroup
  *
- * Propagate memory cgroup's statistics up the cgroup tree.
+ * Flush the memory cgroup subtree and propagate its statistics up the cgroup
+ * tree, regardless of the number of pending updates.
  */
 __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_force(memcg);
 }
 
 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..0057e0ab5a45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -824,6 +824,23 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	__mem_cgroup_flush_stats(memcg, false);
 }
 
+/**
+ * mem_cgroup_flush_stats_force - unconditionally flush memory cgroup statistics
+ * @memcg: root of the subtree to flush, or NULL for the root memory cgroup
+ *
+ * Flush the statistics regardless of the number of pending updates.
+ */
+void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	__mem_cgroup_flush_stats(memcg, true);
+}
+
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-- 
2.39.2 (Apple Git-143)


