Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B2860A5BDD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GNXv1/7b
Received: by kanga.kvack.org (Postfix)
	id 20AAB6B05B5; Sat, 14 Nov 2026 02:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2976B05B6; Sat, 14 Nov 2026 02:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F3A6B05B8; Sat, 14 Nov 2026 02:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1BFD6B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9E2B12026B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:15 +0000 (UTC)
X-FDA: 85432850790.29.8D88021
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB433A0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="GNXv1/7b";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dol9r1sYlhR7CIgJNfl3WOVG5mT9B/6UaBUUhYtXcU8=;
	b=PqOE0GXrCOG/bb1jUPfcmbDxMeOTfyy3IFAtacwttNMLOmDtbTz887ROSHKZO6XljZGTW9
	SdPKGY01kAw6WbCf2k6u3O6DdpWZNdD6G/4XlSiSaQgsBLaer8S9+BPONKrl91abZsLd7Z
	74071v8pCnCD+O+dyfTSGknvR4Djgko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640214;
	b=vU9oINiLc8tR3XFol16SLBqendsKi1XC850pIUHgTN8UnWXSktZeU+hgR5g8zXCJ44XpG2
	PVJfX0YWLaQX3tw0mEw7NMNHyHz1b1nGBIiyv8p27SCZWzAsjP5b4RZI16SLTS9YpjfaYn
	/jCYvWmVDn8IGX1sxU//W80bq18Lv3Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="GNXv1/7b";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9495c633eb5so58041285a.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640213; x=1795245013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dol9r1sYlhR7CIgJNfl3WOVG5mT9B/6UaBUUhYtXcU8=;
        b=GNXv1/7bxk7Cf/rMztv69u6VsYlAQM+GoAikNzYkKhewjmpY56zeNpe/z9DrU3h7am
         YMkaAgm1Lp+tTwPth6NYAQaMe0PwprMRJUBoQ5Gy8v7ARpy37famPFX1OVbHsejYJttJ
         9rpA5bJbhN/tohuLQbRS+/1zpR69OLRV1Of2m1tfx2Anf6qM/y6xdKzheO6ZrM6EmyPq
         zs2WBKeDaa5dcxEhjFjFJyCDXFjEixM/HpVpAhxKQxhkJgOudmDOlM4mlEHIjLFzSDIN
         Izgo+RomB+UxCT5XwNiHQZ8+5ts31LOA9JH/AXn0PBH2EnsJks7GmEIuh5BY8mSNezz4
         esoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640213; x=1795245013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dol9r1sYlhR7CIgJNfl3WOVG5mT9B/6UaBUUhYtXcU8=;
        b=xJlsDaPqZl9kqGHeuXBQ9Fr8C/5eg/QQox19TCZ7JaYzHVeuz9DolKkUihU8DCGrVN
         8EV4mVMSJKxpcvC2euTIQ5wyFBDXZzu9isztG2hjGat3i4O/6CWKlCdGtsrBNmXxcuRL
         IWoaZ4EikqSzKNd8FSugTLPy4SNEvIIi9Ma4st0LVHEXZ5gwgn/4gV+MNDY1Xro1Uefs
         apg8sli5FrkbpAn7kCqvmnn1Q7fqFLRYeTZ/2in0v+eGkUP21i3Y0NODOOY+rkBma5my
         zzlOCVD98mMGrHv+Y9iDoqwt8pSOKoThXeOUTk2zfPNyOsdET6PKXXmHpqYvnZyy7LWY
         uIfQ==
X-Gm-Message-State: APuU4Z8ROIxlR+ovls2HGSTUHkjVJhtL3+Sff5icdzD96C79n8kjmn7B
	5z8JxagGGjXhLJ8tG6PpY+61AYREoE+AB3+6fSrdA+Y9zZPD5EI3AG3ZMdNEhy2AhDUbYo8m3SG
	b2oM6
X-Gm-Gg: AYBFou0+9bGPLGMd0JR9HQUHnhUbYrKDWpdqn2sjfS0LT7704vUfl5KC4FRVlU3jbdR
	g9e/oA8d/5zHjDl3cSEOfotkkL9lb/JYu+bgEmeTAABThVeyJazpZLkxwKG5SL11uB1L99a5/c5
	E5v2HYQi5oTSJ2oP0ZqIE5k1UQTit+uy8sNEtkB3rmzoUgFUKkbOlk5j6lGAQmgrNw9CF1mE/L2
	7doTVyhS6eDAL/40GNRhV9yhogtG3ypgvCWpKnN/DAffH2/uI3vi5YUrwBeCb/mhJdvlrrzeqhQ
	9sBeygCkXGYeMwwkSofXb4BRlvvdxCLm70gdx5uO08Od668IgPVKtYOSzFb7FpvkXa+wm1Mupf3
	fv0rbtacUh2o2/MIbgNXoFqlpEs2gIZR8rE7W5aJSVLZFvSIZ+5sWvlUyTEh7DJ9UqT0hHGpYUl
	35OO5LzzuNFxsUuv86KN4SZyav5A/SWGr4mTmScHvmQbs0JkibcPU9tbGKZW6Vg/55OEMnyiusg
	48EAfXV22NXHWEip9QE+c8Lbz5Lf2/FPbKTQA7gqGNukQSVGgzONaqmkDYiJvK/gkSWS8jDRN0y
	mR2EGraP2cIZrTLFl/bkB6HbcWS98CSZD5JnnvQ1ZNgCbqJCjWBLRY/2U8H5L4ldaHAZp30ew/y
	0b4d52ukGlMMyMwM=
X-Received: by 2002:a05:620a:7087:b0:949:402b:f18e with SMTP id af79cd13be357-9494bc7e777mr835710585a.66.1794640213010;
        Fri, 13 Nov 2026 23:10:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:12 -0800 (PST)
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
Subject: [PATCH 04/22] mm/page_alloc: build zonelists from common memory
Date: Sat, 14 Nov 2026 02:09:41 -0500
Message-ID: <20261114070959.3490008-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB433A0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zu6kmw91ojhjsgmp6ax9wtzgcqagoq7s
X-Rspam-User: 
X-HE-Tag: 1794640213-926374
X-HE-Meta: U2FsdGVkX1/IR4mNKPJ85QiatM0sB68g6/bkbzYiZc5LLjOcV48hRDYR+waqR65HmbGpG/8DQdZYbMVcyi9oc3cuHST+xPzvl6CJCpIh123nm855gaDM42uEMkMitv7dvljdoQt7tnlPjqO1H+I9yAQIx1F/p2Cj9A9lm+5BM9C5+Ny5M0QLOGBwOmNlPrrAtTGFYnsICRTG0GbOZ7O5NgMbCBOUuUZOPF7B9nO34OcvpMV0kLp1XJztBFF26ksqTx5kI3t2f4JpIlHhd0tQPFxIlSrsvNG0zjxNf+z3/3eQLXX4jVDTCIi8LETfjUacml+0V8iQi9RuKB05s1BWSSo0VYm72zb4n8Fgw45HKlpBvUMgQGY/e35fauqBPx3NOC/sa1dEXuE5RrnJ30+U4GnGuoESGCtr7+PKo95cJbgQ0Iz2PT2tiXt5HqikKNbYgiluaNWloqE5H3ptU842S0Kol7qb363oPUMy+BGJF9gtNXPP1bRUjai46pGpDiVRxTkhUYD0Oo0n3OyTdBhATMQIpHAuSHdAEbJqXkSqeBS85411Dt3aH4TbFMpNVyVMV5BOv94QNpA1NGSl3UcX/IlgMZZxt1mjcIaN55KxtDqlYGkNACxkXuQPgcqHKxxpUBesY4s0OjW/9nUb46c3KiPu8oLkMruSMorUJPhoyi3KjqDHRq4kiMbYrEn/itznt7Yx0FstawSgWikVueWg7HnsHU9cmQ9wH25LP8EO/WE5FL3EYUYAzKIBS0X/9ci0Be8UkPik95y2IYJvubEEEdQYNu14K+ILt19Ny8diM2B2XS9gPso5KmKgwUJFzsUssfbThXI0+x7jbUu+bMwa4/oEzbCknAiD6x5hnyVnsveC2IiYZGf/UCMlAbVf6ti8DHDsS2yH/tNnYZkf9/cgV61B7JDoyeqv5ZlQGJD8XYLiKQphHC8mbmy9EzpuE0fe1EhGaGWNqXAMZIc+nsU
 4DBR3H7g
 Fbs/Tc6diWJNizk6D7BjN9Lg5/UuToRCVBNx8nolVWgvhEzfaAE6b4j6nrBmje8XHorAVlpri7of4gKmR9L0ujkhqBIWwT9JUUqdZy7kRmUeEmrdg4JChT0o1VyrxjlSF9gtOWGCKbK1UFiSHbxXpK6tn9ruRQzas6j24XF5EgaYAKfYZUmPD7h/W1+46mBYKfeefw1z7TkzhuxyLiSzAATxboL5z8N7JFWrGmteNSGOGdjXlapJtvTrcaijzBxB2cp7ybAMegMv4BRc/usOEvzoFKIpkIIW8rV8CJbPAOtFcfvciLOEZOr/5Mga4WO87PKVACXivS60mzfwy0rujKGgYI1CCj0EUnjb5bHVq6T/gMkjGwV6LXt64cW3qChKnGp/TDiCV6wJBsT+S1ZN6Y4X4eUe6PsiCw5kzmcd7m7C9Jcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zonelists decide which nodes an allocation can reach.

The fallback lists hold every node in N_MEMORY, and a node's
__GFP_THISNODE list holds its own zones whatever the node's state.

Ordinary allocations should reach only common (general purpose) memory.

Build the fallback zonelists from N_MEMORY_COMMON, and __GFP_THISNODE
zonelists only for a common node.

The build_local_zonelist() refactor lets use reuse the code to build
a local-only zonelist for nodes outside the N_MEMORY_COMMON set later.

Every node with memory is common, and a memoryless node has no zones to
list, so the zonelists are unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6ffa972811462..580feeb608b7a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5906,17 +5906,14 @@ int find_next_best_node_in(int node, nodemask_t *used_node_mask,
 }
 
 
-/*
- * Build __GFP_THISNODE zonelists
- */
-static void build_thisnode_zonelists(pg_data_t *pgdat)
+/* Build a local-only zonelist when this node is eligible. */
+static void build_local_zonelist(pg_data_t *pgdat, int zlidx, bool eligible)
 {
-	struct zoneref *zonerefs;
-	int nr_zones;
+	struct zoneref *zonerefs =
+		pgdat->node_zonelists[zlidx]._zonerefs;
 
-	zonerefs = pgdat->node_zonelists[ZONELIST_NOFALLBACK]._zonerefs;
-	nr_zones = build_zonerefs_node(pgdat, zonerefs);
-	zonerefs += nr_zones;
+	if (eligible)
+		zonerefs += build_zonerefs_node(pgdat, zonerefs);
 	zonerefs->zone = NULL;
 	zonerefs->zone_idx = 0;
 }
@@ -5960,8 +5957,12 @@ static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
-	build_thisnode_zonelists(pgdat);
+	int nid = pgdat->node_id;
+
+	build_node_zonelist(pgdat, &node_states[N_MEMORY_COMMON],
+			    ZONELIST_FALLBACK);
+	build_local_zonelist(pgdat, ZONELIST_NOFALLBACK,
+			     node_state(nid, N_MEMORY_COMMON));
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
-- 
2.53.1-Meta


