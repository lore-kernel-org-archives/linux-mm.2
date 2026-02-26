Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1ACAFC5921
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433666B0131; Thu, 26 Feb 2026 14:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398B06B013A; Thu, 26 Feb 2026 14:29:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBE16B020D; Thu, 26 Feb 2026 14:29:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09FD46B0131
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:53 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8E7116018F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:52 +0000 (UTC)
X-FDA: 84487597824.13.EEE3290
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id E13001A000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAZFc8kQ;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQnJpZ9tlMxlAvSH4/u9efMTjBoGOkCwurLY+eANTp4=;
	b=JK6MUxzJDGi/shqanfJFOJAE0nRhRBejE4OTavOZuvg+pDtP6iJrA0kqgOZiwAfik0iS32
	Uz7rg88ACBlBDHtG8hN6B/3xJwHX1xeseLouFsKmL7604z7EHWV4pt3UwxglQkJ4oGGorB
	uUA6qBLxQJNQD2lEje0P3YE1bivMq0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134190; a=rsa-sha256;
	cv=none;
	b=FbPjYyL7MKR/ga89viN112Xo8bwGrgcBdcT6JpL4LAQMm2eBIA+U+KS+hrdrgleVsDd7HU
	8QN2iRWjSJiA/kx6qx9tyXzCq2ui7+SYg7udryNKaMakiKDaXstlLdTcJoAUrk6rStnqzq
	oOEKwr86+AYDLiavpOk2iTIW3tE4Edw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAZFc8kQ;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-463960df4f9so979059b6e.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134190; x=1772738990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQnJpZ9tlMxlAvSH4/u9efMTjBoGOkCwurLY+eANTp4=;
        b=gAZFc8kQajoqm0uj75Z3upM0VDEp8qMp1IQOSA4kuodqjSQD/+A+BJxeeOmkApnX7l
         NmOu6BsYA2PKwuC3QInSonjMF8hKmFSXeoXb9b8okC65wDPuNKrPIQyrbJ6zCi5uldGW
         cnACqbiU+PMP13LyA/gbp2fYeWwICnYUsFkdyJ6z0kwyeyJVtDLaBuh9h3XBDGJxjSTN
         8AsQvsv+QD0UvyE2ZMGGP2AzIn3iRjwVU+QEoLLAf206REq+DXnPVASBOlzn2xBNmjXg
         7D6Vfs+YK7W2a3cyNLVKIbymS3E4uq+N8huF+OjrWb/x7GFz2rZOn3CJjlT/1EopeFjw
         4vFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134190; x=1772738990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BQnJpZ9tlMxlAvSH4/u9efMTjBoGOkCwurLY+eANTp4=;
        b=vR6m00seRPaxJ3yhago6/tGzrU3+VnQlcdsxTV23L7s0Aso28LvIu6aMNRER1yfh7A
         LNOcR5//U2gg5u5Q82kCj7GZfWz/xun3Nlk4YXXADikewO8rd6qCOeHNYcB4UYw1WQ9j
         XkzcdsacAVXj/Nf8R7xoYOK7mEPGl3Av1orN1UUAeeBIHlB4xalpI6cHcEOiNwliiRYd
         VpeKsbhOKJnRqokD9fbHLkNrxG/Kd78xnS6A6ywNSrPNwq+sRLNVIxUZ8Hmf5iw7Y10w
         h7YU/u8KDuNfswahu6vzhO2ZUTQJttbZcHMuH9Ay/rxEHRzug2RGKNC7bUbzOY0Fp39h
         VarQ==
X-Forwarded-Encrypted: i=1; AJvYcCURGklXGNk+TqkDxdvcU9A7kc8E1VxxgBDzIgrbFNcmrlrg6epWIOns2PEU0Zn1mWyz9vUd2ahPCA==@kvack.org
X-Gm-Message-State: AOJu0YwQPRxkKzLqxSvXjv8R12EQ+4Qdq6E/G66808hclUxC44OL8ewL
	f016Iw81YEd+ELKybiUVQgCEiKtKPn2s7foMXzs7fpiJYcO8sjO9/0A6
X-Gm-Gg: ATEYQzy041mkVSg7I9AzpQwamoEbqXO4iM7Pp5Oqku5kJnaQyPSPpf5Laq6Y1LkBAaP
	h3eCeNA8dz4vAWuYtqhkoGGoXlNRVj/fiBYm1XTY0aGPfxg6JDtrGZfF+PqYkVZ02wHex49Qd2S
	QfgMSoVBEPWsvYTnBxlHX8UX0oFSVvG/tdh93bfQrecWay8yb2iRF5IYLfJxr18V2bLXkeHSPj6
	AsOdBbJoIte9Cr9pQxfWkHdLCQxJdz7coffAIatyOBPCCg0AdZIA4csp8Q0s74Iw+SwdpbSS4zS
	EQ7jc970ZRCAqiIwI8V7YcI8lPjL/noX8jKkkJiEqsFsX4mU9kq0F7L+epiZHz0nsaB7T8YXToK
	GhTJ6UpyI4grV2Vb659Le3VE4Gd92yU7dqnr8k412sfr6KanfU2QeFRw/OowwdmW8oeCQe7d1S6
	EUpYv0OQ/6tXuqbkSaXRlwhA==
X-Received: by 2002:a05:6808:c1e2:b0:45c:8c23:12b3 with SMTP id 5614622812f47-464bec872bdmr142745b6e.61.1772134189833;
        Thu, 26 Feb 2026 11:29:49 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4f::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb0991f5sm498612b6e.0.2026.02.26.11.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
Date: Thu, 26 Feb 2026 11:29:29 -0800
Message-ID: <20260226192936.3190275-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E13001A000F
X-Stat-Signature: gyh9reu9rf9obnzi4h573pfsy9bjbrbx
X-Rspam-User: 
X-HE-Tag: 1772134190-653271
X-HE-Meta: U2FsdGVkX1+nk9KeQwjqhiOEE/l0sWPpLMdmGObFy98iUp9AoVKfNibBfQYbWuGzyT7zYgbdzQo98roEmBAf+tySiUtVHx6/5sbkg+tuwmdyIOkXByQwDiYdXeaJIFyIIGIHJBvhCD4fJiUwfsrGK1DBN2hogQCuvfCdwBceyZfdFXAHoJzwwnKw3F/Xt+8rEdKbLtwHiyUm7xxc5BxRxzL9+YLU1iEhY84xs1RR8zRJXN2urDLQD+BHiIm4hL0LzeII4p3i0WuzZnhgy0q/FXBcXtsutsP8EAPTQ3u9Fk+xpeQ5gB9jA9Jj6rIsn/YdECTG3+2kjqHSt1z1E/ER5FrdgMO8rRgBa8dh+K4+Z2F6TSD8M75w8vZMTtlJxEcljlCL8frZQCR7fND2G2jpGao+PUlrSg32H3EQ1WUHsxmy6C47XF9Q3EJvTeAYDT+1bSsflXJqSGSuu1S8r+cu+Uxh6H3WGg/XPpDE48cpRWXBocdaUT45ZzPUkUB6piHIG7rAIqZuzOxhCHbIYXkq6UMshIfDPpykpWXoZkjy0uAK8lDBfYP8pc6m8u1t5x0V/qw34dxBsxfV8lUoB+27t6zedr2VaFozLAN6OvL1FcrSFhJ+4a/HJivBNCFL65wkTQjTjZ8cCTb/2+te7cETSuADvn/iZLTwy8gDcAQuE+5OCsPsFKjItOSCSJyLbIo8ZCRjJDAxRb1qsgpDucze4ndvi1SjcHldqorODe9u2YYqjvbN5r7aQm1P4Sp6rYPTVpw2yhqIRcbGUdIAc4UVIvjiUEaKjM3nh0deLEJKpmkFVlpXWuBKmMeYWWhsxmXznDf5HswxO1jXyl+tmByfVLaQZ1J+J/gz0y/ELgXzUDCcOlRyKlRUzT+F1JRN2rbidKsVMy2HYLeR3isPiC9PtBSP8cfpRksUIcuOGCGyyfDjbDJJyEQekS3Dnh2Z7EnsnGyTMCWWCbyh4MMQxIF
 oG7ZdpZa
 SSji9Bfuy+xeTs2nYNXagHWzj1CWdYjJNFNEKyeNWE7u2xqzoVjRHFsq6kjvSQMVXJXQkRt3spNyVV8LrGTX7h+rUz5xmzUBfBuqtgKMbsm2mlD/u0zakjD8M49/URSqnF4wbxjUywPzonrEBppGsmopLSU1EBdRKK+atG5eaTTvl9NZPZXXvOm5IqwHDPlHqKn06WUBaehA6PjFoif8/m/yUGYjdeej6+aHtLO//7HO7WLP0XxC2jFXFraIN3LYU4xk+P04dAkXKIysDwNxle821C4xCV57VPNht0+a0zOh6VQlRcn/T3jn5QSlfzVDKZdF6/T9S93R8KP2FjZaN77Wq4eJ3gfhKGy1PZ/Fgn21UPLnq2PFsR+m+4BgBtJMsZ+fOpDy7/f48JHOgzKxysR3Ezd9rGJggkKoj45MdgMlyBDSXdwg+noDaetyUlssQV6w12EjA5LtfXmD+AMqaMyanlCucwlyDwT10S5tDvJaOLx2ItjGApk1g5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that zswap_entries do not directly track obj_cgroups of the entries,
handle the lifetime management and charging of these entries into the
zsmalloc layer.

One functional change is that zswap entries are now no longer accounted
by the size of the compressed object, but by the size of the size_class
slot they occupy.

This brings the charging one step closer to an accurate representation
of the memory consumed in the zpdesc; even if a compressed object
doesn't consume the entirety of a obj slot, the hole it creates between
the objects is dead space the obj is accountable for.

Thus, account the memory each object makes unusable, not the amount of
memory each object takes up.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 10 -------
 mm/memcontrol.c            | 51 ----------------------------------
 mm/zsmalloc.c              | 57 ++++++++++++++++++++++++++++++++++++--
 mm/zswap.c                 |  8 ------
 4 files changed, 55 insertions(+), 71 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6c82c8f73e1..dd4278b1ca35 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1824,22 +1824,12 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
-void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
-void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
-static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
-					   size_t size)
-{
-}
-static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
-					     size_t size)
-{
-}
 static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..3432e1afc037 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5433,57 +5433,6 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 	return ret;
 }
 
-/**
- * obj_cgroup_charge_zswap - charge compression backend memory
- * @objcg: the object cgroup
- * @size: size of compressed object
- *
- * This forces the charge after obj_cgroup_may_zswap() allowed
- * compression and storage in zswap for this cgroup to go ahead.
- */
-void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
-{
-	struct mem_cgroup *memcg;
-
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
-
-	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
-
-	/* PF_MEMALLOC context, charging must succeed */
-	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
-		VM_WARN_ON_ONCE(1);
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
-	rcu_read_unlock();
-}
-
-/**
- * obj_cgroup_uncharge_zswap - uncharge compression backend memory
- * @objcg: the object cgroup
- * @size: size of compressed object
- *
- * Uncharges zswap memory on page in.
- */
-void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
-{
-	struct mem_cgroup *memcg;
-
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
-
-	obj_cgroup_uncharge(objcg, size);
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
-	rcu_read_unlock();
-}
-
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 067215a6ddcc..88c7cd399261 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 	return true;
 }
 
+static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
+			    int size, unsigned long offset)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
+
+	/* PF_MEMALLOC context, charging must succeed */
+	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
+		VM_WARN_ON_ONCE(1);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	rcu_read_unlock();
+}
+
+static void zs_uncharge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
+			      int size, unsigned long offset)
+{
+	struct mem_cgroup *memcg;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	obj_cgroup_uncharge(objcg, size);
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	rcu_read_unlock();
+}
+
 static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
 			      int size)
 {
@@ -1018,6 +1056,12 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 	return true;
 }
 
+static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
+		            int size, unsigned long offset) {}
+
+static void zs_uncharge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
+			      int size, unsigned long offset) {}
+
 static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
 			      int size) {}
 
@@ -1334,8 +1378,11 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (objcg)
+	if (objcg) {
+		obj_cgroup_get(objcg);
+		zs_charge_objcg(zpdesc, objcg, class->size, off);
 		zpdesc_set_obj_cgroup(zpdesc, obj_idx, class->size, objcg);
+	}
 
 	if (!ZsHugePage(zspage))
 		off += ZS_HANDLE_SIZE;
@@ -1501,6 +1548,7 @@ static void obj_free(int class_size, unsigned long obj)
 	struct link_free *link;
 	struct zspage *zspage;
 	struct zpdesc *f_zpdesc;
+	struct obj_cgroup *objcg;
 	unsigned long f_offset;
 	unsigned int f_objidx;
 	void *vaddr;
@@ -1510,7 +1558,12 @@ static void obj_free(int class_size, unsigned long obj)
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_zpdesc);
 
-	zpdesc_set_obj_cgroup(f_zpdesc, f_objidx, class_size, NULL);
+	objcg = zpdesc_obj_cgroup(f_zpdesc, f_objidx, class_size);
+	if (objcg) {
+		zs_uncharge_objcg(f_zpdesc, objcg, class_size, f_offset);
+		obj_cgroup_put(objcg);
+		zpdesc_set_obj_cgroup(f_zpdesc, f_objidx, class_size, NULL);
+	}
 
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
diff --git a/mm/zswap.c b/mm/zswap.c
index 55161a5c9d4c..77d3c6516ed3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -711,10 +711,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 
-	if (objcg) {
-		obj_cgroup_uncharge_zswap(objcg, entry->length);
-		obj_cgroup_put(objcg);
-	}
 	if (entry->length == PAGE_SIZE)
 		atomic_long_dec(&zswap_stored_incompressible_pages);
 	zswap_entry_cache_free(entry);
@@ -1437,10 +1433,6 @@ static bool zswap_store_page(struct page *page,
 	 * when the entry is removed from the tree.
 	 */
 	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
 	atomic_long_inc(&zswap_stored_pages);
 	if (entry->length == PAGE_SIZE)
 		atomic_long_inc(&zswap_stored_incompressible_pages);
-- 
2.47.3


