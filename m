Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8290B60A2635
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=P0d0Ea80
Received: by kanga.kvack.org (Postfix)
	id D54D76B05B4; Sat, 14 Nov 2026 02:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D566B05B5; Sat, 14 Nov 2026 02:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80306B05B6; Sat, 14 Nov 2026 02:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 833C86B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1F23A0289
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:11 +0000 (UTC)
X-FDA: 85432850622.24.53F4065
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25531140003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P0d0Ea80;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra1qoxU4QdTYWMO3cOdicsi3ZqR2JP+4Yyk7L1wLDNk=;
	b=693biUPQUYSi44QZkZodCQ1x5O+aHxah5ffDT6Acx3vrhFQtOM5VlEnJ5EiafeCF6D3BOk
	wf0ZHsazw9Xlid7TftGWfwNtrqxnC0wnYxIMj1wiPFglsp79YISMg5C3vwH76NCuMMrpfp
	WMomsuRKPW2E/59a1IgR1Z//g+5u4hc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640210;
	b=hMOK0FN7O0zj+LN0h74CoGJ+HkcQjpS4e6DgJhXRvYSKSEgHJvmt5pIxMv0JJi9TQ3tDny
	KfkZ4OoCD2VLSMiCpj/7O0LnL0zUeA1ecCpATJDWADgLGz/m/Rp14cfKZ8FjfIKt5L1NMJ
	RFux17Cuf7Dg6A32kfetoE5gn18tQsQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P0d0Ea80;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91ea2e29d90so38110476d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640209; x=1795245009; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ra1qoxU4QdTYWMO3cOdicsi3ZqR2JP+4Yyk7L1wLDNk=;
        b=P0d0Ea80Ag58R4t8O2RaNStB15EZKtGTgZI9P8k14IEaesQlsD58GH9/ROa2x1efpC
         P4LjlzNBU/UjTP6YKLYncX8JvLrgezYs7621SPrKgjQBPTMlwuT1P5SPNUeLgFWIJm8e
         tpdIQ0xJ4KSmejIZZhFrYeY0DIf2GXk6QLKz9gUux98rQKjY93vvV7NcM0cH1/vCb6Jq
         MgK3UhjMoIrkd6rubOR9syecqAlV1YBL+hGbJMNI8xvun2qXfo87WNPql6kLDjjSy8XF
         YlwIty9KteLSQuqewaLkOA1VvftaJXEQGkcaeAaLpkBPx5Ia4qq7Ixhx6upJ/3G+UW4p
         /tVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640209; x=1795245009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ra1qoxU4QdTYWMO3cOdicsi3ZqR2JP+4Yyk7L1wLDNk=;
        b=mhz/Mxoeffa+uSJkvASYsbBEa+6Vsupi9QkucsZcqPP9QuXtMNsjYpqPTyLsYwhaWk
         Z5wHyH1HjdLM34KV7nH2T4yD7BJKmZ3apXwP4OUl8OMMX5pOcKyOC28vycNA5P8q3rC+
         yUIcPws4esW6u5OGsdhvJIUvTylJihFvcvAOP6PNxZteWGFe8LBeKl53sCoUivPg3iay
         f89CqHwlpLJRoK+jtKFTncyFMvsEOXKe3HoimaDhrWx00OprPbYLVzpy4rksUurG3mkb
         fo/dQXAUaMeX6mDiLgQC8cfh6O8I4c4wtio2xYnFHog0vOBfCScDPLk4Ox3szexxS/0N
         QPrw==
X-Gm-Message-State: APuU4Z+c9l/zCkAa0nOVmZE8nDyXLlf/VC2MtI5miGBX42OQl8IJbV7I
	v7FPSgAPGhz808nUL/0ikbYZ1t/eARgFbYrpgrnRP6wctXtaFWsS3HEkep+E3M2fy/KsSgvE0mn
	gKwCs
X-Gm-Gg: AYBFou1SbisIJdTKDMzxpZYIjHTbnbUseO95DlpGUW80qN5uDa+GMe1Gv+YBpqADK4a
	ssWIau1UTt/M59q7/f8vC3R+C9hvWdrV4lJYLsaIqZyf5peR/gLUHt3AoboA/M99kJK3oAE0dvb
	5bhRfKRRApAmhH3j5bze+Fkdbw4/qgZaU1bgdymM3rZBvoZng3Ro35di8BSsXF+jbBNy+iL5pwP
	SzSF1NnTcYy2m+LXXbSVOqZIlYyLOpdwvhYzwTzz03Za3Dau2hcr9Sdl30Yesu+RybdjVPnnIB7
	KVCwxG8/h7XkQui72Qn+oBR+uGTLj+5bAN/o5FdKBRfBVa9HiKZjogKSlDQ/LGldswyxRmm1tAZ
	yGjFpoPaff8ChioYx2kBdrRWqwXRNkjkJ2Gb6i1L6wfbnRnynekHaDaZcidPoVZcFwv85GMudbE
	QcTWd8uZg6mBKg1S58X3DRZdlOIhelzvGlIuWFCvj07YWFOm1BOcEUrtrbuo0TI0hnm5smWp291
	y/OjBPgMHeP9Q9XRTWfKuGyA68fxp5/GmXw3ruwRl9FlAjBF0VdHeUTSwcYeC20q+4V5eAba6Va
	zvbq1T3E4VrL8rbbQS3wofBTY958vUP+SVdd9W9rqinpNbI16vga0A5xBGeK0P+UjzkuQST7Fxg
	wQ0vREAlu+w7CzSygevGy3HFyBKc0IYK5YsSj
X-Received: by 2002:a05:6214:18f1:b0:91f:1a70:4b0c with SMTP id 6a1803df08f44-91f1a70a6famr79219716d6.4.1794640209017;
        Fri, 13 Nov 2026 23:10:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:08 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 02/22] mm: publish and clear node memory states via helpers
Date: Sat, 14 Nov 2026 02:09:39 -0500
Message-ID: <20261114070959.3490008-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7746fkdrm3chg5f1pwuk6cr6s9pffpgq
X-Rspamd-Queue-Id: 25531140003
X-Rspam-User: 
X-HE-Tag: 1794640210-232211
X-HE-Meta: U2FsdGVkX1+K/K0AIjJlryuBDU1b/Kxo+kV8dQK2Vwf6mBLbdfhPVsP6jJ5wI6M/NL1u0Dd0cJu9dLbwumsHe7aIimF4mUY3DQ+bILGp6sxIQxxcqsv4oOk/q6wMVa4VOwP56y9ZQot/D2sQnilmDc4QjzHJwYtO217wmgq3uMzBaFiw8CSC9CIM3tKrmJonZ05L4C8ZqcYs83lyaiJGZQH3zY8gzfg6mzFu+z/pE3pjlQtI30KTT2c73ae3f/RMTvN9wmSDY9GjNRtDWB4MMXv88Yi+HxhbCiMhJNilArEqVpo2SUR9kKBP9UXijyYdN4/HvD7w1KCMbtP5YFaEgatNnRk8mTx0vTF6ayXJUT+yrC6Pt6ZzPznOYE4r0usAsG+2waZa6d5VqUAE5Y6kjjMzaxCvHGnO5LIql1pJeuc9qaaZRij+Mv57FJIx/IKUkOpkCUXdCxz6hyQHzW31V4eYTVj9EgpZo+ey8QpdWRw4nsualcAAHSMwE6q5P112CF7EMa9d3BnUpnV22HNixQc5jEQktuPTmjVNP3HKZ40cBn6d+ddax2iUeFL6JolC3ecHwJLeUu/M4luKQliSxQH1OfM0kqWuS4WIcZ+9mHpxEeHzfUNWKrls6Dv5YiTAmRFIdmJgRYcStFrlCMhcJ0FV2IrqARjIqE+u8ZYaClHjLQ7P+GSg1k0VVQm83T358kW7eLT/MKnPL063IN0M66L7Sp5wjgmJShRaOT9hfpRYe3k4PR3vMqa7ba/4DDOuD9zdOm0CDwMBasa08GdWXGrHZTUyr3vTExUXLf7DY9S4FT45QqWcVowfKFh1kOpHn6+/+KfaB7yqHijMQBCN6C4PIk+5pBR+s+M/U4BiaKxkr+YrMk+rM4c4l1IA425zfOgrhsurjPbkB2Chim5XjQGdyjosewslrpDRUgw4Y6zCKOWdsHIFuPSE/vCEY6EAHmKWnpuNANTsuEskCEY
 cLsHUjWI
 5yRq8jHAQMIZX5yn1XUX61J2/vuDpz5r0ZO49S2Q3jSoRwJiFTCdVv+q8UpykwaRBNZbd9eEOS/Emhk4iy2YaIiT8qGSzAgXesUsmH2XalxFwE4xe3+9DO9oPsyq7/sXILXWEwVfu6zaRAFKp/ljaSAvUTSWEzS67sbP5FJW98DxE1GjwB/0o5wQR0jWZ4Wuo9pHfDH2YyXB+RPJUiXSPPP880zGdCBQ4jBQLoHeDzDV1T6vlArpN6VowSqO8oKrCHkgOmwiLeNJlJhZwaNsXO6Trs9zMWMjna47IKmn88Yk32LY3aAPIQ49/DVsgHovhEjnP5sJYUZ/6UxyloqXAPAOcJSHoLeHlUkyYfhHpkKdV0US8/gKerqsoyRPVO+OuthZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

N_MEMORY, N_NORMAL_MEMORY and N_HIGH_MEMORY are set separately in
free_area_init(), check_for_memory() and online_pages(), and cleared
in offline_pages().

Centralize those updates in node_set/clear_memory_state().

Behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h       |  3 +++
 mm/memory_hotplug.c | 11 ++++-------
 mm/mm_init.c        | 14 ++++++--------
 mm/page_alloc.c     | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0a..608a83c34c224 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,6 +62,9 @@ void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 
+void node_set_memory_state(int nid, bool high, bool normal);
+void node_clear_memory_state(int nid);
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index f04a248d8adaf..490f400498f14 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1184,14 +1184,11 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	online_pages_range(pfn, nr_pages);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
-	if (node_arg.nid >= 0)
-		node_set_state(nid, N_MEMORY);
 	/*
-	 * Check whether we are adding normal memory to the node for the first
-	 * time.
+	 * Publish this node's memory states, including any newly-normal zone.
+	 * Hotplug never adds highmem.
 	 */
-	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
-		node_set_state(nid, N_NORMAL_MEMORY);
+	node_set_memory_state(nid, false, zone_idx(zone) <= ZONE_NORMAL);
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
@@ -2146,7 +2143,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
 	if (node_arg.nid >= 0)
-		node_clear_state(node, N_MEMORY);
+		node_clear_memory_state(node);
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678b..b4c4dba93652d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1763,21 +1763,21 @@ static void __init free_area_init_node(int nid)
 	lru_gen_init_pgdat(pgdat);
 }
 
-/* Any regular or high memory on that node? */
+/* Publish the memory states of a node that has present pages. */
 static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
+	bool high = false, normal = false;
 
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (populated_zone(zone)) {
-			if (IS_ENABLED(CONFIG_HIGHMEM))
-				node_set_state(pgdat->node_id, N_HIGH_MEMORY);
-			if (zone_type <= ZONE_NORMAL)
-				node_set_state(pgdat->node_id, N_NORMAL_MEMORY);
+			high = IS_ENABLED(CONFIG_HIGHMEM);
+			normal = zone_type <= ZONE_NORMAL;
 			break;
 		}
 	}
+	node_set_memory_state(pgdat->node_id, high, normal);
 }
 
 #if MAX_NUMNODES > 1
@@ -1924,10 +1924,8 @@ static void __init free_area_init(void)
 		 *memory-less node. The pgdat will get fully initialized by
 		 *hotadd_init_pgdat() when memory is hotplugged into this node.
 		 */
-		if (pgdat->node_present_pages) {
-			node_set_state(nid, N_MEMORY);
+		if (pgdat->node_present_pages)
 			check_for_memory(pgdat);
-		}
 	}
 
 	calc_nr_kernel_pages();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8532af052d74b..834d199ff8429 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,21 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
+void __meminit node_set_memory_state(int nid, bool high, bool normal)
+{
+	node_set_state(nid, N_MEMORY);
+	if (high)
+		node_set_state(nid, N_HIGH_MEMORY);
+	if (normal)
+		node_set_state(nid, N_NORMAL_MEMORY);
+}
+
+void __meminit node_clear_memory_state(int nid)
+{
+	node_clear_state(nid, N_NORMAL_MEMORY);
+	node_clear_state(nid, N_MEMORY);
+}
+
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
-- 
2.53.1-Meta


