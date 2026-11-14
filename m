Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3DB606A8B4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bM5HliHU
Received: by kanga.kvack.org (Postfix)
	id 9F9CA6B05B1; Sat, 14 Nov 2026 02:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989786B05B2; Sat, 14 Nov 2026 02:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCF76B05B4; Sat, 14 Nov 2026 02:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 562276B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BE09A0289
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:09 +0000 (UTC)
X-FDA: 85432850538.27.2D840F3
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA79EC0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bM5HliHU;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m1rh8YCtMa/eK/x1h9nBhdh93CAkPykNk2YYLlQM4w=;
	b=t/6nc9LQZCqPCoNFGdyu4ZPnu98K5nsGmXDihgg8qzBGNR+r3EF1nvzvj7ssZ0IKs6aERM
	/TSgBd/jnINK8amLD4kUSJ1fEyzYdXLirUnXp+c8m4b92ieP8rDczw6ZPOGZxansijWzWm
	GoSl0SrnvmIGSPlYB14gIgbSMS/opVE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640207;
	b=pXNOKJBwclNcIQ/qC5RDNmw3tPMEu6tYQiUmOq2ZxxkhZxpYrAE6oqEWs87A/QO23QFvs+
	pAgQNSLeZSJTq9sTETqlNO7yYaA+TGr9rLMO84uCogMKM7u+jrTPDkxAebJo9Chu9Z3TfO
	/onbbF/GSUJJIWMKHv1xm+ZXqCujV2M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bM5HliHU;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f1e5d7450so262327385a.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640207; x=1795245007; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8m1rh8YCtMa/eK/x1h9nBhdh93CAkPykNk2YYLlQM4w=;
        b=bM5HliHU8ur3yIAEdjyAn7CON6hCh+r+NA0wzU3ageitZidsY9XBo00Z3WtkxgMHWM
         s2cou2xPq4jO5uLRiLhOhf5BpSvVzNwc71gE/YBmf9roXnoSCjuA6gspDkwezgXWKrMv
         fAhaqhGW42joclKSN2fX9ZzS5qKBDw67XtXx4/9Qs/T498YRPMqeHdc7lusD9H4W90Lt
         +k3KR8qDAh0bNy1SfgNc4m8oONnbEQPE9NXBM9wgfW6tyo9JIVZgq+FNz54IPL++hu3C
         X/QbrbAGhv09FDVcvUT9iMal208HWtk/uhscwbnzG8rs3+fVW8jDCvTPKzRkw97R9kdB
         BFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640207; x=1795245007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8m1rh8YCtMa/eK/x1h9nBhdh93CAkPykNk2YYLlQM4w=;
        b=gC4PWB0xCi6ZJJadAt/QZVy+oldXvxf+OwSzZBaIHWcOtQbKYnbOaSy4MGWaVVvXae
         oCGUM3gWeIHAQyvEC2WT9Z91+J5sIsAmy9kCYkPNh4Sn1JOIgaykCubUaVTRSoerjRCo
         qOrLne7Jz3lFcLunN/Ac6P0nni8wcOWuKNv8STSWsBOicz7E7N8AKAB25Etym/xO3Irb
         btaL9UJtnFxpuzebmKmWEJTzs4G+MUMJZgrXD9MFpBIDMhT+rCTVdeQbm6RxXEOA+Ml2
         IotyqJSxxUA7xKaf4FYm7AnVA3BOmiNAotPQLXtmCQ1i7UiEhOsyRChaZ+bhTWO1E1nb
         gPXQ==
X-Gm-Message-State: APuU4Z+sNggOsjp5RLUk2EaC3iE+tI6SSe60PkdE79lt21GBxR7m+vuX
	3zSdjNeUmHjhMa9ZBfiuibPyv00+yF3mrKLT4Dl0tE8ySP1CygtsRonh6Zajtu2YYM9fwyFVdxV
	XUI0Z
X-Gm-Gg: AYBFou18/Uia1F+PEnQ4uywL3BTVdhf4kjmdNgqqJW4dzgiYpohcQoJmWa/STiUFj+o
	NSK1ZfsFew5VfYWspatfaDVLeGZHeQVspUuZn+5Cg6KMIaDFQPH5geNRnB7KMS4H9Zqpmg9rTrD
	4lD5EsInLwodylERd1mQVfxSVknzCGsaFJKrmDjAt7FWwIduLQLgiOBvpV6r1i3xO2FsuqzeaDr
	BpfG0Og+X57aX9iPi87jc8huW86QwTHsTgKiDcDN4U0sAGeNlac57PW1mI6VAYF3uFC+ayKTfN7
	5/1no+Webrq0Cb3duEh4TatcEALx+k5e+udiZU8J676xkfgclh3RDoLbc3sfR/zh0mYrwLB8Zky
	+N5dAXlar4JDN8OfEI6yAn2tHlL445S3pn8gNRomdp33TTIxnSKtXmjzTW+ZzzPW0+yDO8oRKid
	GaRxayHxljgmPNjFB3UDYAcBPe8Mruex/tv1yWfMlVNnH6yIj44mA0YkWGcLX3PJn2pWjQb98Yf
	QcRCe4zRO8ozb9OCqaR77DJFdrEmOdroA18yJf67zszKdv7e76B+R6CkS0mYdYKlW+ohYeMZYsy
	kz00QfIU1L98dJk6Ao33eWE2a7Xo73+s79e+9eTJ9f8F41EMW6e+fpC4ACSudWDb8PU9Dj2QCNB
	PcWMs5yQmVLDyxes=
X-Received: by 2002:a05:620a:6606:b0:93a:2d07:142f with SMTP id af79cd13be357-9494b9aec7amr802433485a.7.1794640206954;
        Fri, 13 Nov 2026 23:10:06 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:06 -0800 (PST)
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
Subject: [PATCH 01/22] mm: add node-state-filtered zone and node iterators
Date: Sat, 14 Nov 2026 02:09:38 -0500
Message-ID: <20261114070959.3490008-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: st5fwqy14ijio8xbokj3ubaapa3qtfm8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA79EC0006
X-HE-Tag: 1794640207-562142
X-HE-Meta: U2FsdGVkX19xlRwt5FERM0V7Tyw+OTqsaR7OHb1lGLEJH+1oGZ8S3Mi//lKNxDqABXDtmNI9iBDMjBqNBe69cSJuiDeCeGlybPNy5Z1fwlXQmq/1fOA1nFNqQjBfSPQhxF+tjUIy9GAgSwDYgeFzje1/sqXLpTCHAmGJqIVd7aV8nbBZo/RkmwU64Jqx/9wv1CS2PvXIXx9unASSPvyMr8RXTu1ISVSlGKx+iCQOQsenAXFCEePWhT9qT/zV7paMp3jSOmBXQJMA9KZJFIMkYjmo4JkNnW8kDDhT9PbkOQeDi/F4p9wNjyrIh/IW5sI0mlwQAJEkm7/TXNCyxrggFmDAW0/RRHDwUTgBgsJ2nW+fPkszLZF2lgpiZx5AIJN6orOv+CId4oicQlFhE/wDccTJMJ2/UB+Vsa66oocMeNje0g7aR7I6PP9sb29NsCMJJi6nfF5GrJC6tAlNmMHxeGf0ppwXUgOkaFBgLvPdwvTqMqAvrb7kl9JpE3a82Pxp1jNVpVu/T8O3U9F+I5btgV3pJA7AA0gcsRqg+e11q0JJyLyusKS/1sQUDu67hkbjjZjYC1/kqOBal7CPBbKKeRETsD01mvxkIbCdVNk+XhWpslTXPoJ1jYqVxsc3nPjYgkU29kmTFE8Ai+z0xZA/0GWZXHTPHfwQJhOmzu4fMYnCbuCmEw8t71ObD9ak2AFqRb3H2liUukkjlaJTX7Ycb5NRrMLXxVrukH/fzGgZKSpF6lFdbBVMHSsHMbvAI2GFLoQZETo15/fQZ8vo+4vqxixRL1ykFIM9m2K99YSVzj7g9G+iWBXC14Yn9B/Ukn9RRveWjPBbcWfIsmBheO0wm98ZfjylyXDLkkPr75y/8Du/nLvM40W98h4I+WWqGYfVYxSLESvp7+Mv8ALt0DrdWxPzNGgq9Do/B5hCnVmk/C7fioFdqIx9g9/47oOxKfhl6diEB4qlLalzEftMNxl
 3TNjNYeN
 50HP8DngGLSb9S1BVgJR7ghT31E3Sp38pT+XRJbbfmL02S2RgaCMwmj9yvwac+XlJk8bE94XsyliF9bU8PBkxMpoL0wW9plL0C/ZYZ2WGHdcAGhKZpBwjUxSC6vzkNPe/jrua66sZcfC42yj7QfaSkLGZZ92ukoZ+1SJ657yE6tta9RzXcT4k+4S5IM/VdZcHnyMyvyu5SGP8HhzasTIMzhMtyfAFKAKjMko082iH8HxleIrICakYcwfKv5vveyjaWyrPrjadHxU5uPSEODml9mUNopbW2nhnTpIfveiyTpbvc1ZYOP5lC8eDENm1sUvOcup6pFjkC1OHX8wvHcx29lWDYVUHAXkFYpEWWnLR4H1kMPfQxTIFb9TJd7pcqBcUz+d5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add node-state-filter helper functions/macros so MM walkers can select
their node eligibility explicitly.

Add nodemask intersection and nodemask/state iterators using the bitmap
intersection helpers, without allocating a temporary nodemask.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h   | 46 ++++++++++++++++++++++++++++++++++++++++
 include/linux/nodemask.h | 28 ++++++++++++++++++++----
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c161d563ce8fd..5ff190d870830 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1845,6 +1845,13 @@ extern struct zone *next_zone(struct zone *zone);
 			; /* do nothing */		\
 		else
 
+/* Populated zones on nodes in @state. */
+#define for_each_populated_zone_state(zone, state)	\
+	for_each_populated_zone(zone)			\
+		if (!node_state(zone_to_nid(zone), state))	\
+			; /* do nothing */		\
+		else
+
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
 	return zoneref->zone;
@@ -1937,6 +1944,45 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 			zone = zonelist_zone(z))
 
 
+static inline struct zoneref *
+next_zones_zonelist_state(struct zoneref *z, enum zone_type highest_zoneidx,
+			  const nodemask_t *nodes, enum node_states state)
+{
+	z = next_zones_zonelist(z, highest_zoneidx, nodes);
+	while (zonelist_zone(z) && !node_state(zonelist_node_idx(z), state))
+		z = next_zones_zonelist(++z, highest_zoneidx, nodes);
+	return z;
+}
+
+static inline struct zoneref *
+first_zones_zonelist_state(struct zonelist *zonelist,
+			   enum zone_type highest_zoneidx,
+			   const nodemask_t *nodes, enum node_states state)
+{
+	return next_zones_zonelist_state(zonelist->_zonerefs, highest_zoneidx,
+					 nodes, state);
+}
+
+/**
+ * for_each_zone_node_state - iterate zones in intersect(nodemask, node_state(state))
+ * @zone: The current zone in the iterator
+ * @z: The current pointer within zonelist->_zonerefs being iterated
+ * @zlist: The zonelist being iterated
+ * @highidx: The zone index of the highest zone to return
+ * @nodemask: Nodemask allowed by the allocator
+ * @state: The node state the zone's node must be in
+ *
+ * The state filter is part of the iteration rather than a trailing if, so that
+ * this expands to a single for statement: a macro ending in an unbraced if
+ * silently steals a following else from the caller.
+ */
+#define for_each_zone_node_state(zone, z, zlist, highidx, nodemask, state)	\
+	for (z = first_zones_zonelist_state(zlist, highidx, nodemask, state),	\
+		zone = zonelist_zone(z);					\
+		zone;								\
+		z = next_zones_zonelist_state(++z, highidx, nodemask, state),	\
+		zone = zonelist_zone(z))
+
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
  * @zone: The current zone in the iterator
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 607373bd83ee6..28a456c3f5964 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -386,6 +386,10 @@ static __always_inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *ori
 	for ((node) = 0; (node) < 1 && !nodes_empty(mask); (node)++)
 #endif /* MAX_NUMNODES */
 
+/* Iterate the nodes present in both masks without a temporary nodemask. */
+#define for_each_node_mask_and(node, mask1, mask2) \
+	for_each_and_bit(node, nodes_addr(mask1), nodes_addr(mask2), MAX_NUMNODES)
+
 /*
  * Bitmasks that are kept for all the nodes.
  */
@@ -411,6 +415,10 @@ enum node_states {
 
 extern nodemask_t node_states[NR_NODE_STATES];
 
+/* Iterate the nodes in a mask that also belong to the specified state. */
+#define for_each_node_mask_state(node, mask, state) \
+	for_each_node_mask_and(node, mask, node_states[state])
+
 #if MAX_NUMNODES > 1
 static __always_inline int node_state(int node, enum node_states state)
 {
@@ -435,15 +443,21 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(__node, __state) \
 	for_each_node_mask((__node), node_states[__state])
 
-#define first_online_node	first_node(node_states[N_ONLINE])
-#define first_memory_node	first_node(node_states[N_MEMORY])
+#define first_node_state(state)	first_node(node_states[state])
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return next_node(nid, node_states[state]);
+}
+
+#define first_online_node	first_node_state(N_ONLINE)
+#define first_memory_node	first_node_state(N_MEMORY)
 static __always_inline unsigned int next_online_node(int nid)
 {
-	return next_node(nid, node_states[N_ONLINE]);
+	return next_node_state(nid, N_ONLINE);
 }
 static __always_inline unsigned int next_memory_node(int nid)
 {
-	return next_node(nid, node_states[N_MEMORY]);
+	return next_node_state(nid, N_MEMORY);
 }
 
 static __always_inline void node_set_online(int nid)
@@ -481,6 +495,12 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(node, __state) \
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
+#define first_node_state(state)	0
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return MAX_NUMNODES;
+}
+
 #define first_online_node	0
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
-- 
2.53.1-Meta


