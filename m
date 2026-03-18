Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB1F1088E5D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659756B038A; Wed, 18 Mar 2026 19:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3B26B038C; Wed, 18 Mar 2026 19:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAF46B038D; Wed, 18 Mar 2026 19:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 349066B038A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:41:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F176EC094C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:34 +0000 (UTC)
X-FDA: 84560808108.12.18DCC78
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 30BA01C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i1BY13Xy;
	spf=pass (imf20.hostedemail.com: domain of 3Kzi7aQsKCNwQMSP8TN8LB8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Kzi7aQsKCNwQMSP8TN8LB8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773877293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn/QznSYS8PkR/CPS2jvk7ULex3hHuKEEqYbEge1aWI=;
	b=toYTbfDop3CEbpd0I0R/Ri5rLT9t0o6BlYtfuHbPKAb5OGtnkB8WBqYrqf1TvBwWP9n0JN
	WSd2MkXtvztMHAkCLqWiMLlds17TNUNo0+NUqWvHtVPKVesUUOKVTsCOM6KvY9iCiwUfoE
	oG+bzdKdMGyEkZMYMwfJ7izuzp4daVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773877293; a=rsa-sha256;
	cv=none;
	b=JY/IxCmV5Cu8aXnok5v65cXDLhF52gWCVw78/81O9iPWwO4MRq0Jo2jFXjEX2VtsGXE3Id
	OGOfuw0x0Cyh3ES3XpMSMDuWbYPXyqtPOTim4CQtKDuMFTCk5pIJQK0CzRhO0le52Qkxv9
	ZMO5d0W314tXbsZkYli365i7cIP9X34=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i1BY13Xy;
	spf=pass (imf20.hostedemail.com: domain of 3Kzi7aQsKCNwQMSP8TN8LB8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Kzi7aQsKCNwQMSP8TN8LB8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82a07f4597aso50102b3a.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773877292; x=1774482092; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sn/QznSYS8PkR/CPS2jvk7ULex3hHuKEEqYbEge1aWI=;
        b=i1BY13XyrYPHERL72FiZcOdr9/82ftw5Jro/yFWR8d07UKaOHsC2hiva9ZrB8K/JFj
         UvFU2WahlpKet58MGVVMc/YQbP4dK3t+O0HqGt2QRMk1p7XO6KIQecIIGZiEE789Sy9m
         Do3D2RZ7EBQRkV8l/eLxs06zg/FNwLr23KKnRnTG9J5JxEsYCWsFvUhpWb4/hW9HZWXe
         GEAl2e19uNhs8Kf46JfQQDNgxd3GIZ8gzLwRsuDuboeN7x+x1ZwcgHyVAxFrSCBCd9cg
         y82JhWLa32yR68SvEb0kxLHLxnzXdoIhByrXKbCaaik5QVexB9bH1Q/QtNNbqG5d2i6Z
         Rb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773877292; x=1774482092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sn/QznSYS8PkR/CPS2jvk7ULex3hHuKEEqYbEge1aWI=;
        b=fG3CpSKNzIrAHWvak79Oyzp7xawFB49U9GPJJ/1lxFZzxzoIDILpMFRiKJss3m+Wvm
         vr+JW23ubt6JlpAlejhYQTCmUvZqrHzFXaZtBLysu4sPoTmHE7Ea+yjVVz0X84m3FCSK
         acsBLWQ+ucM19HoZnY20yai1b+Qegs8GAT+Id1PUpSwjPCQTZbq3+/2ZyB/FOArt+tLz
         gbgEeHI5uxxGyHQRIZ0mwCcet3sjKJETylJf3fO9Os6kNzxVCZfyWNJ+/XRoUcsorEy5
         h4hbb9Ilwk+MqDG+fzY7IfhJh2xY9Vu0V3f5P2Z1zTrqsp67O5xHYM18r+SHyhyYT9jw
         0Biw==
X-Forwarded-Encrypted: i=1; AJvYcCXY9bbKNOPWJM/d1VF+31Mq7FPxiJXoEtVtxaEn5Y5Cnv5PxGXkaM7NpGn68ku6JIq11VAhIJ6MWw==@kvack.org
X-Gm-Message-State: AOJu0YylD8n5uorsu99rabhwaZ7vd4d2NlELNzfCRA9rDGA4TrdQTLuV
	rlMevC12lmAIZelUh4VexEnAOswKCVL/29uppRwwgtAT9swJQEznkU3LdeEyAEb5lnp0yMQyNDP
	r/+rrBUlPR6KRxQIhBt0PAYbseg==
X-Received: from pfbbe11.prod.google.com ([2002:a05:6a00:1f0b:b0:82a:6cac:7561])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6c94:b0:829:809e:8977 with SMTP id d2e1a72fcca58-82a6af3c066mr4494854b3a.49.1773877291734;
 Wed, 18 Mar 2026 16:41:31 -0700 (PDT)
Date: Wed, 18 Mar 2026 23:41:26 +0000
In-Reply-To: <20260318234126.3216529-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260318234126.3216529-1-souravpanda@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260318234126.3216529-3-souravpanda@google.com>
Subject: [LSF/MM/BPF TOPIC][RFC PATCH 2/2] mm/hugetlb: skip hugetlb shrinking
 for proactive reclaim
From: Sourav Panda <souravpanda@google.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, songmuchun@bytedance.com, 
	osalvador@suse.de, mike.kravetz@oracle.com, mathieu.desnoyers@efficios.com, 
	willy@infradead.org, david@redhat.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, weixugc@google.com, gthelen@google.com, 
	souravpanda@google.com, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30BA01C000A
X-Stat-Signature: e6uzxncqgxkort7gebh3hn3byiy795b3
X-Rspam-User: 
X-HE-Tag: 1773877292-645356
X-HE-Meta: U2FsdGVkX1/wkbRqAEjRx0U/6kQLzJ2z+/55v0HB816IZr4vkrtf4Fq8IWSpyerxrdpGuyfoMrpuAEITg6G2i7MPN8GM5nTOS1VZVpemED15qTJBv4vi4jUCTYrC5OtbGbV/o/zb08LUvQAFDaz2EUw1JjLvKLJNcPAhSHN3nh+SgUfu43Q8mNfjjLnBasb1f9HylmsCbPQ3DZ/t+X3Ui0zSflMLm44jIXCKzKwk/7AzQiESEjfk3dx4MDohrlspXVV3fVXmzVgdY5Bvckc02ukLBZwUiHjJVFt5xnbwLzyqSPAarjmhnN2iazyckToqpJy79lhrgP2KLr6XX5RJ5AG/NRjg+qiIBiKzFk4aGw/yqnvz6Oe344JQ9uvFuKg14PaGPHF+2uMJkJ62DvVg1OhDqN++WxdhLOCAL3tXIH4EBl6MSdrZWvJWTtWPCCG1WpiW3SH6ckktsdDGW4AWZcSw5P3+Sr8IbhhR0mIo2ziYUO9fW02Fee041CvenjR5erue041FUtgf1sRDCKLVUgXCWhtM06qxort7swSkhx2EwbEcxiTSp3Zhr7Fi8lKka8pBlywnCGYfbXK/HV41S8rtp1vgZCyD3UiziZF+5Ix7RG9+Iz15EHF5uGRkVvtmR6wbu9YClU7XsQtfLvygU2xTgPgkiQsYz42Rg1Fyjy/A3+MwN8ToqOiAu1YJ2/ojmNqZkAmZGKbtfoeHfoRR7mNYj2U4oL07UgZchzFMQrkMTQBG0ngl3Y7XMimrnQFkyI6EAyDnialY/4kUyPGe598FMJk7c5iFSICJgUA27cxpKF1VLRaqsk1yjCC7xgcWak5IUq3cTyGTq40JzorIad9Nl66O37hX5i+sWmq9d1VK0IN0orFJNOGiCKINg0ll1g1DbIxf7fpBbiki4+e6f3u2p772Z06sZy1O8SKr917kpycwatE6Og9Xhy994Rnh9CKFCAIIHIJv3NOld0k
 KhbtHgPR
 +G3jYoSt/3GFW6o8EYZW+vdB8GJ5KqWStVv0N3SJTql30aJrFWWpPxD/0owIv9oe8NCelBVkCjx/EGYlNsAC3rRRWGu5ot5gh9VEQfBGO5u7DDQ0IAt5lHwoiTW+LhTLZla5HzzDxbcScvMtMxnYGJEsPVIhM4vxgG4CxnZyEDqFmlMDdS4zqCLkTN8pjNfWJFTLuPTCNDObjRXT9jjWedbC3lnoeX8AQIAtEaO7f0JF+mO7fdu/RXwsdBxK8lHelPzxcio++D7pgKOZArnvs5OEoSLQ1KcZZMpGV8/rWJKaCjJQNkF6KyCGZRXu00WUnMaXQsKH+7/qbZ20Oj9VhZFyCFUTHqZx0WB/lljDPvLeDMqFwlfaEliuygW2RQsFXEja3f0uF++lpQu2JVdTeOMH5xkFrpR1RmOTEo8ri4vJyTZM4rtEhnw9LnrnY9E+j8fpdt1JIOPFIgiVjmJPfT0/luU+uYxmLyYd99GkUaV/cXVNFDTPSakMHSh1H//PN/e1mxImZFioHCXV5LjqrW4HAWU99Ytlct/UIy9ORiLTRAv5vWYZ+cop0bTPTrf7vmg23KES8tkTT7iMFILxTWOeZbiRH5QMBv0Cj9qj3RuGeDPY41J9Ioq5UiG9ipTQWBKLWPCWXUWcN0tWLLAU6J1Nln7vER2Pqb6twCv8DMlVl/3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Scan control can indicate if we are in the proactive reclaim mode.

Pass that to shrinker control and preclude frozen memory hugetlb
shrinking if set.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 include/linux/shrinker.h |  1 +
 mm/hugetlb.c             |  6 ++++++
 mm/internal.h            |  2 +-
 mm/shrinker.c            | 10 ++++++----
 mm/vmscan.c              |  6 +++---
 5 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 5374c251ee9e..973d5fd68803 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -52,6 +52,7 @@ struct shrink_control {
 	unsigned long nr_scanned;
 
 	s8 priority;
+	bool proactive;
 
 	/* current memcg being shrunk (for memcg aware shrinkers) */
 	struct mem_cgroup *memcg;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d4953ff1dda1..a70aed7c8665 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4145,6 +4145,9 @@ static unsigned long hugepage_shrinker_count(struct shrinker *s,
 	if (sc->priority >= DEF_PRIORITY - 6)
 		return 0;
 
+	if (sc->proactive)
+		return 0;
+
 	if (!gigantic_page_runtime_supported())
 		return 0;
 
@@ -4193,6 +4196,9 @@ static unsigned long hugepage_shrinker_scan(struct shrinker *s,
 	if (sc->nr_to_scan == 0)
 		return SHRINK_STOP;
 
+	if (sc->proactive)
+		return SHRINK_STOP;
+
 	if (!gigantic_page_runtime_supported())
 		return SHRINK_STOP;
 
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..cccb68d723d4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1660,7 +1660,7 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority);
+			  int priority, bool proactive);
 
 int shmem_add_to_page_cache(struct folio *folio,
 			    struct address_space *mapping,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 8a7a05182465..21b8f0b9d092 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -467,7 +467,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 
 #ifdef CONFIG_MEMCG
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
-			struct mem_cgroup *memcg, int priority)
+			struct mem_cgroup *memcg, int priority, bool proactive)
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
@@ -530,6 +530,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 				.nid = nid,
 				.memcg = memcg,
 				.priority = priority,
+				.proactive = proactive,
 			};
 			struct shrinker *shrinker;
 			int shrinker_id = calc_shrinker_id(index, offset);
@@ -586,7 +587,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 }
 #else /* !CONFIG_MEMCG */
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
-			struct mem_cgroup *memcg, int priority)
+			struct mem_cgroup *memcg, int priority, bool proactive)
 {
 	return 0;
 }
@@ -613,7 +614,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
  * Returns the number of reclaimed slab objects.
  */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority)
+			  int priority, bool proactive)
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
@@ -626,7 +627,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 	 * oom.
 	 */
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
-		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
+		return shrink_slab_memcg(gfp_mask, nid, memcg, priority, proactive);
 
 	/*
 	 * lockless algorithm of global shrink.
@@ -656,6 +657,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			.nid = nid,
 			.memcg = memcg,
 			.priority = priority,
+			.proactive = proactive,
 		};
 
 		if (!shrinker_try_get(shrinker))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..39151d1edeff 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -432,7 +432,7 @@ static unsigned long drop_slab_node(int nid)
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
+		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0, false);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	return freed;
@@ -4925,7 +4925,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	success = try_to_shrink_lruvec(lruvec, sc);
 
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority, sc->proactive);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
@@ -6020,7 +6020,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		shrink_lruvec(lruvec, sc);
 
 		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
-			    sc->priority);
+			    sc->priority, sc->proactive);
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
-- 
2.53.0.983.g0bb29b3bc5-goog


