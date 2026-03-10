Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FF7EB104F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0476B008A; Tue, 10 Mar 2026 07:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040CB6B008C; Tue, 10 Mar 2026 07:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85CE6B0092; Tue, 10 Mar 2026 07:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7B8D6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:38:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A40BBB54B6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:44 +0000 (UTC)
X-FDA: 84529956168.30.B580191
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7D31140005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="FH/3u5FI";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773142722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdvSAzoo6YoHXW8kKXpbNqTJIz++VEopwb6mVs5rsKU=;
	b=cIWfldXvMUzfey3XhZLGLAO8PfCYnxG6GFr9sfn01QNTu8PneSausP87czNaziQX8KleV+
	BqN7+Dtpuur6B/MqT3RYqYb64SC8eW1fi5kB5wy4o6VYmBipHZBUg3jeOr/N+hSulyyFBE
	wmJGnGL913QwX6lhRVJNDnXglQnrpo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773142722; a=rsa-sha256;
	cv=none;
	b=kxkvwPW6IYAtoLJutHCeoGs6wQ2cDV46Q3awSuqhEdcWpf+/r/dmZeu8QFow2jgPTPAcfZ
	5dlGejacO4C5C+7QTpUEnIK05iDpxHwl9MwpvBd4GJITcpwO5UNtBL0MhEPEbht3slPyKD
	Z9QpBkPV2R4RYHfj6ZVk2JDQpaLXFmI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="FH/3u5FI";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf09.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fd
	vSAzoo6YoHXW8kKXpbNqTJIz++VEopwb6mVs5rsKU=; b=FH/3u5FIhRb7GWs2B0
	GQ/iKMBFiJHemM7v5rQQnuH/+tN3x5HvfMScgYCBdpL806IiSXHHOn+OARoRQ4Dm
	PXrEwwzMMaHH/H3Gr/puXqMR/pxe9rReHnBNqnp8p6yfrwbwB90d1JLh9e0irkNV
	mI7Kg/kt8a6cIPEPSXk3mHdUQ=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAXvQ+eArBpwhXAAA--.11763S3;
	Tue, 10 Mar 2026 19:38:09 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 1/2] mm/slab: move obj_exts_in_slab() definition to slab.h
Date: Tue, 10 Mar 2026 11:38:03 +0000
Message-ID: <20260310113804.245647-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310113804.245647-1-ranxiaokai627@163.com>
References: <20260310113804.245647-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXvQ+eArBpwhXAAA--.11763S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF4DCr4xXw1DGw15Cw17Wrg_yoW5Gr18pF
	yrG3ZrtrWvvry2grW7Jr48G34Yv34ftry8JrWxKwnYqa4Fvw4DtF10qry0vF98uas2gFnx
	Xws5KFy8Ww4jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRkR6wUUUUU=
X-Originating-IP: [117.176.242.62]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgEve2mwAqFlcwAA3-
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C7D31140005
X-Stat-Signature: hqekciirr4497o51ywu3poz46f1p56qr
X-Rspam-User: 
X-HE-Tag: 1773142721-512476
X-HE-Meta: U2FsdGVkX19FqWXA8oFGJJcmDcl2ibdK3IkSWTIGtDrXEIKPKTmlWNW8gsPJiYWngedFb5DH5JgVs3UQengBo9VWneOOueuo16cyea3tOWNRSv/dS+ORerUxH5gqKhkAjBR52YpVycpl75AOLmNWYyAP1uSgsatiY1XNU6y5MLxca4MgpjLEYPaaHVmKZRGUGifkdegW7S3yZ4/OoJCtszsRjZpZgO/sJHCSWFL3T3X0cH4lM/bM4iFkwav5LigUlXpnW2cJTAdntgQY/s4N8aJp20ZMzW8sGORRRnzI8HwLDCximylsmWYO66aZNKViOB3mh6GGcbeb08Y7vBF+j6/syQu9iaKYsgJsSjmd133FLp7wC/dZRRPwUmOqRqqb7bqg5otxgDd4HdrU4K4XOSKy5Y1JTeOgkiega4f2ZWcY5Y/hWpAKpOJ7dJGMmdvOIBxqgaRLph8SLl5Jds8FVbr+fi4L8mmXu5t9+63/LWwpOB57VPrsRrtNz91ssTtcgiFQEwyS12VHaW/kJrlL5tEfB2KWviRAew+Mm3P4+a2cI2C72KkAy6rmW4y7Tm8fA0/Ekv3wM5U6w2F+XMrThYZ8JZrORMXkxgnTR0kMlZTcAfKYpDrVYEErOckamNhSIuuC37pduYLgpJ1qEP44Agzcxojdhg9TyE33FPd+USgqElERsRd0kWOLW028s7SfEn7DlxQmbp6OSIG8hHMZIuIYuZkzAnF2OsmBrpjoFdPKopfmsKS7xqdJNsdAGSGohJmfrQuD2NyT/vgg96mS2uvOMuNH/g63J8QGM4FHJHLmS6E5qPnMbPfgAqVslApJtwsnZbFy3bQLE7eE5uQUpH//VxtRaaimKRZg7EVExoZwLUGOiKycYUWzvLhbJGym+7fJhER+Tduc9RlmSiCqRtHpKVpAYt0XUt09K/vNMWLDBCkLKV1Wc9O+2VghZaqhkmOSvhZkW37ZKJ6HDML
 +3ydPNor
 G982DEnwu0fxqzzZPGgeFNmuHTdAj3JDvcd5wDYFRpxw7SVdVWVSqrTdGOl5UXetgujSSrxLQQCvkayzwD+R2MQk9E7XzLOji6rukaVJ+C1H5VNpgX0Ap6PtgnrUeGGFlKjr0gVVApFeBt+HilixdT9Th/xPjQgrlckyfIecFdZpp65ojyuCdeVN94PiOvLKM0n3KW1WrIINdYNxWqmfOqsuX20UlTiv0yt/vhLB6RZOps0z73dO39iOiSC1bP9eX2QFnTw0kDpdw5Xn0McLZMsVxlM1SYhF3WlNYgdpPMNcB9+kcQNhl1QAQtuFlomCOUjUYlHGChY/Lik/JWse+Bq9+rPP0xRu9HUdy3LdnwQq1HyqjfLUC+RFc7e0vibA+hSn8XpuKYr6J45wU7JUP+3ASOJH7Lt2gTnQ/DEWhJgfYXTiuhTz7MmyHX0COXKQ7q+1kOD2hyKDwMgrsm+yneVeGb9jLW4Pcjgxt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Move the definition of obj_exts_in_slab() to slab.h. This is in
preparation for the next patch, which needs to access this helper
from memcontrol.c.

No functional change intended.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/slab.h | 19 +++++++++++++++++++
 mm/slub.c | 19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 77242024e7d5..8354d5669ee7 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -597,6 +597,21 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 	return kasan_reset_tag(obj_ext);
 }
 
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	unsigned long obj_exts;
+	unsigned long start;
+	unsigned long end;
+
+	obj_exts = slab_obj_exts(slab);
+	if (!obj_exts)
+		return false;
+
+	start = (unsigned long)slab_address(slab);
+	end = start + slab_size(slab);
+	return (obj_exts >= start) && (obj_exts < end);
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
                         gfp_t gfp, bool new_slab);
 
@@ -617,6 +632,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
 static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
 
+static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
+{
+	return false;
+}
 
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
diff --git a/mm/slub.c b/mm/slub.c
index 1871c5ef354a..845a67736688 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -808,20 +808,6 @@ static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
 	return objext_offset + objext_size <= slab_size(slab);
 }
 
-static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
-{
-	unsigned long obj_exts;
-	unsigned long start;
-	unsigned long end;
-
-	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts)
-		return false;
-
-	start = (unsigned long)slab_address(slab);
-	end = start + slab_size(slab);
-	return (obj_exts >= start) && (obj_exts < end);
-}
 #else
 static inline bool need_slab_obj_exts(struct kmem_cache *s)
 {
@@ -845,11 +831,6 @@ static inline bool obj_exts_fit_within_slab_leftover(struct kmem_cache *s,
 	return false;
 }
 
-static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
-{
-	return false;
-}
-
 #endif
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
-- 
2.25.1



