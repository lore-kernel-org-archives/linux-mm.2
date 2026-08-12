Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48257C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E066B0203; Wed, 12 Aug 2026 08:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41C36B0205; Wed, 12 Aug 2026 08:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56676B0206; Wed, 12 Aug 2026 08:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95B46B0203
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:49:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62E7414027B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:49:30 +0000 (UTC)
X-FDA: 85092598500.18.0D7E74C
Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9415CC0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:49:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJNpiUxz;
	spf=pass (imf22.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786538968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JbWT0UV8aRx7hOisJJVgwNElFMB0lERRSO4ktMatdwE=;
	b=ER0iG1cwRkBuyEYoHtbxnOaKNIZbbef3VDCZea37spX3q5+1G+vZ+GKe5+l+ktc9JH2c7p
	JXuqEDAQlV0HDN7h4rw1CPQFlxDSE7k5Y52+wT/Ws9ESWOFJxBQpjeGSC3+TMOoBFOAiRy
	RKgBu7JeEMum3NLVr/rrDncIMhAOLzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786538968;
	b=usmouSCxfeZnfnawCuwN1TFkOIZ+XehLRMhCjL7P+JccxIf/yrn0MwHBFJvR5uR8GxCb+4
	iicm9JNwU9ovJQBgApjG7Z21rYo57NnCmOrYBHAgmkjOky4++9M0whQ3XRptLbPRZaXfR+
	ByQX6SyJ8VDwgtvYHBewJ/czrNIA9BI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJNpiUxz;
	spf=pass (imf22.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T3euLRUWi5X4en4gbGyeNy19X/iP7P5qMnlk87Y3JzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786538964; v=1; x=1787143764;
 b=cJNpiUxzrSq3A5+7llRRqpKNporOSA/pwvc1DR13ALr/S8ODWk4sPhxaZZcRbcOF1Ei77mXs
 B3cz5tpS/xMHsuU/KDq9JJRCMenH/g2Wm1gJ6QV6H9IzYfJNEk4I0cdy9ITvZd61uV6ZXuPiOJt
 0HPYQymNIgyqjGHzVvO6wmIE=
X-Envelope-To: linux-mm@kvack.org
Received: from zgp.. (240a:4280:d800:21e:3f98:c0ba:a57d:551c)
	by smtp.migadu.com with ESMTPS id 8d02885b92efdee5;
	Wed, 12 Aug 2026 12:49:14 +0000
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg metadata
Date: Wed, 12 Aug 2026 20:48:58 +0800
Message-ID: <20260812124858.73487-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ogzgfgnypes8qutpn9p33rzhnb1csop3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9415CC0004
X-HE-Tag: 1786538966-979784
X-HE-Meta: U2FsdGVkX1+GrfncAsyRHSWi1NyPtJudygxvOgDRmbAW1Lf+4pqs/e4+SCG+h0QCXq4zAGPe/MEcnCBcjxcKxgiV6yCV1f2a7iHXxNZLN8Mq9g8YUsp1Ll/Aed0b5QQsxF1TDoni6dl+azxRpsBvZRsTQaynJlyUBIg9JLYDXuTionrZimQDxcBv4IBXA4+eCotlvvErkqlUwa+xt2CGxlzmXcy6vjvP7oRdpxGsyBSC4watLxg0jwE3AFP9+GDzpnVg3EJ0ccIXnGmuNTvrsh9oBZKn/nnfiW7SG5hlZEiEVrQ9rf06oquQHgTVXMk39ECcw0l26RJCEn11tFFDO26UVGQ53oJIIj665EDUF+dtXCo9RVNeh0dui/8B+i2glU2+4QK9XRRj14ONaaAJ3iCkfKEq4idW50aIRJKsl+Lzt+DOyeg1r26LY01zE6YE+6XhEa+IyGHeQkkYFhCyMCvI22x4ns/luT4GsWXXh75Mnc73TyDiUD3EtVLspZPJHlMe5qV9kXQusx74KXbPmbWjYnSxsbuWIhi3WrqPGnqwk6v2yGTpPg/AhYpiU7nqXyl5oI/qxl11EDM5v7jl6x2kNKQdE02x4UV/u6ZYb0kfFKBqA8ELtAXRw7KieT9JA+w9R+yrdCGIBMJeiWEVcri6mAq8862WpIFGKIy+MAfrFJahGmssu47QV5AeGrwnTUEVrIDgW0y7zdOcAmvuWDwEQ+oYWBh5ySI0WB64SZgrjLGX3UQjyN8BPEH7FRaHdJVGizm6ls21HwNihMsy1Er3HMzq4ZFzX8tfWCcacyKLE0cHnVv3oWSKfZyJASChCMDR9O/3HeSOx5P+/8diu9NQAm6XD8t0DyMkxg4vG4ZfzZY6/jXAcEeWq9pAVRmPehd4q7OYKvMP/sul+Pb1GIL0O3Mi63ftRXygWV4bIUrQASCc9Uts3qB3Zqm9Vxgrj0NOcS10X/R3KmGMa1F
 QlDpoZuv
 Zdcro4/bEaGMI+Pe6EjqKt/TYXN9xqJ+dwPUKEmFa0dx7uvNVAlks/V20UBwC2zzEFvXFh+Qw7B6k9GD3RoT7fGaOpTmFAQJmi7uEGzbvzOfQ0WOURHzKYhDJ2pVi0znFyu1fSWKndMRuJfgI+AoCKJIHwralcbepZpQe054s6FfTDpxo+v71WddLe+9qJplg7LVqYgiBcs797Q/puWmg73v8NPNuPYY+E4+STO+x2eW2eDyvl3aIIhcNqLIFrTawuZ2MA6umRDnXnxdeLkFc+bzMwYO7lxR8i5E8K4IhKrobxvc9BBOA/O+s96Yt+LjcbOthQy3ohusNiZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

obj_full_size() adds the size of an obj_cgroup pointer to s->size to
account for slabobj_ext storage, which normally resides outside the
object.

Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
unused space within s->size"), slabobj_ext can reside in object padding
already covered by s->size. The extra charge then accounts for the same
memory twice.

The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
layout. Use it to omit the extra charge only for in-object metadata.
Unlike in-object metadata, slab-leftover and separately allocated metadata
are not covered by the per-object s->size charge, so retain the existing
charge for those cases.

Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1312441a02b..aef480f46891 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
-static inline size_t obj_full_size(struct kmem_cache *s)
+static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
 {
 	/*
 	 * For each accounted object there is an extra space which is used
-	 * to store obj_cgroup membership. Charge it too.
+	 * to store obj_cgroup membership. Charge it too, unless it is stored
+	 * in object padding already covered by s->size.
 	 */
+	if (obj_exts_in_object(slab))
+		return s->size;
+
 	return s->size + sizeof(struct obj_cgroup *);
 }
 
@@ -3539,7 +3543,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				  gfp_t flags, unsigned int slab_alloc_flags,
 				  size_t size, void **p)
 {
-	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
 	size_t i;
@@ -3580,6 +3583,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		size_t obj_size;
 
 		slab = virt_to_slab(p[i]);
 
@@ -3590,6 +3594,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				continue;
 		}
 
+		obj_size = obj_full_size(s, slab);
+
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
@@ -3632,7 +3638,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, unsigned long obj_exts)
 {
-	size_t obj_size = obj_full_size(s);
+	size_t obj_size = obj_full_size(s, slab);
 
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;

base-commit: e7f630142df2afccce90555e4972e60008222311
-- 
2.43.0


