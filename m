Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4647CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EDF6B00AE; Mon, 15 Jun 2026 07:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246666B00B0; Mon, 15 Jun 2026 07:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CB56B00B1; Mon, 15 Jun 2026 07:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0843B6B00AE
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBD0C1A0A17
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:41 +0000 (UTC)
X-FDA: 84881992482.14.B8AB9A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BF56C0006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZh8Qh++;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524540;
	b=x0gQ3Sgr4b3Fc5rjunZ4r0KEBjVWnhHU8rKWgbUohfiC2N3SpdJ2xqkrLCo9Cu+dmw1NZa
	2Ib3mL6RzDIki5mbzYkT10nI14SIvwF31+5UPFG/CK0UpMsszhaQOi9MC/ODRfxVOo6e5O
	uAjCNfWAkOrGp/XFJ+HCOF/a8KGYtik=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZh8Qh++;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCbHjIdLkVYSp8h0SGNdIhVsAdl6qVmA4a+nq/MReUE=;
	b=fmNrB2wGX1y5JX+gjTH5txXxKcZq+V8FMgqrxZPuB1mosidtqqlNqXLu6w0AWPNDvE5K+e
	8tgePeqzNG81nZWaoJg82cfbOspt8FZuc0XGGRC/rfJgNsrctAbOWQBX9bsNPeyyhGNMrD
	TwbJVpRKaN+dhAZZK8S2lOsfYwkjg7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CA7642DA9;
	Mon, 15 Jun 2026 11:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CE71F00A3A;
	Mon, 15 Jun 2026 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524539;
	bh=vCbHjIdLkVYSp8h0SGNdIhVsAdl6qVmA4a+nq/MReUE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LZh8Qh++tEH61G+ntPZxPtE8ncOXV23Aq8trMYRQubFZDHRJHLoixTTMzM1fLxi59
	 fBftqx0TJkFGx9aKZjhW7DXbcxXzex8oOb6yzzWeZVwrkkVdzluaAErY4y00MLrSkc
	 TavxoN15HDPILsWRIADkQSFBvgYBvztqjSZLlpak+r7QAk3se3a5+YAKwxgd6dVfyl
	 NxpeMWPtxCSw3a2AalOSsO4swRzDs6h9bCcEuiTEdgKbJr2/9lt5RI6+ETN4ycQaYy
	 nPScRKdEP2Who43yDuIUlx5pitJXXC9uMGuZktMeEe0dSFjLhimEaVF6wVvBMyfWsX
	 RJ6/y3XNy7+zQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:47 +0200
Subject: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 1BF56C0006
X-Stat-Signature: uk7mpyyynpwj3zwutjs5x16e57byq53d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524539-472729
X-HE-Meta: U2FsdGVkX1/rV81W0vC+rYsANmjBQ28UTfo3OgR1a0TBJrlaDWS9boLunijp7dq397ufhoJDL8WPAG3srbAj4wRFsgR7j9n+hi12aHPJyRNacJ5XR7ZjCuoHFfCYwrDHZ3dWefN+te9OotPW9HSr7Z18E3H5Oe/QVtGW8OlsprQFzP0VtRrMJfTk/vgWZU3J7kpbH9+ozbYBCScHuAAbkVXBzTZ0eo+uihbntXQrpzjrt7XcOttPYAbDAsnxmAHhSKpq98aGWj/7sNkQSHZFIz9IYBLfqSFrVvXD7dLA2byunnGlM9xrkaPWTjkiWjuHqz5MPlnbdD0WSUoTxW2ZaK4H+EGVMITTFNapzztvC/u5LghzxP/VC7YDR87TeFPbymhwOXjUMIlPCDTp6760MsdqRHOmVFE3GK4lhIP1rngHsTv6mo1RrgXYGIqFZKHMqCMSF/Vvjdll8pyvkMaLVn/mOGJdmQSr0/GBoVuc1KYD8pLata+QwCkGMuCzbavqHvJAPVpM8QkN9o1X2BQxXfczh/pZYlSZ60kP3uil18jbfSj+YOaY3mgeegUPF0OCdVoLnbm0y/XYvKbd+YQrVPaxF4X6PE/rPTEZVjRuUmhPNH9+klTIPJ1WP5cyICbLSF8J8C98Y2Lhko8+pMnu0f3SHszXCPpXLGGqNiu9ATZjMnUp9DdbgIQRHgGySARw5GVkYIMjTWEkMt9XLYhJCw91oxCdWhelof2N0MiMhi3qfa1Orv5yKQ7v24bawTdtjhfuUiAN7CKqF0tx5I2tC3pwaXEbhbJXYR/QQjTZDtkB/O0cZysWurn+GI3kmct1vKMbS7Sq4bmrz/vyQdfu+ZOeG1fz/JiFahDTTeARPsS0RP6TUxQP1BhMLWnxLoovukVT1RQdf44ET4zER3+MbmD7fq2gidRjLZfT69c38QC623B6NOdjG0nu/qDTMBufack5QIN1Yrj9QBnkyZ+
 1IhtMEFa
 lU/3wBT4E45d4hrr/WtU0sHbL3LjmB1oBrU1wgI3j+GHgQH18VfXH/JqhLdd4dFAoeVit41Ny8TBa1WXZSa00QI21i6ASDiwP8djPaA0c/NrbvF0SvkeIxs7RoA4p0GliAQbkc4boBHPbONtx8nv6h7RMvlcwsqOS7ZY1Y87n9i0g/j44QNpIeGskFhpTF3G1C9DZ5fTZYi33f9j79Y4o5X/3H/XE3dR5cNnatr6/HIPyhpVds/psm6TwnH+cwqxXbJkwAEV0c9nFhbCni1if8+sGY2qv8XP0P0v5QQAV3JmoopPRLoeVAq9FlYgi8zxVVM5KranNulv7SbJO0pZfzL5eogKVnA8WgYb0dyUdcw7qCWCt5003MJHYfTUaTU77RktP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
gfp flags are a scarce resource, unlike slab's alloc_flags.

Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
__GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
family function should not recurse into another kmalloc*() for the
purposes of allocating auxiliary structures (obj_ext arrays or sheaves).

First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need
to special case kmalloc_nolock() anymore.

Note that until now the kmalloc_nolock() ignored the incoming gfp flags
and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
the incoming gfp flags (only augmented with __GFP_ZERO), because if
alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to
be also compatible with it. However, we might have added __GFP_THISNODE
for opportunistic slab allocation, as pointed out by Hao Li, and
__GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve this
by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ext
arrays as well.

To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at
this patch, until the next patch converts sheaves to
SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
next patch will remove the gfp part.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h |  1 +
 mm/slub.c | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 482b8e0fe797..281a65233795 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -21,6 +21,7 @@
 #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
 #define SLAB_ALLOC_NOLOCK	0x01 /* a kmalloc_nolock() allocation */
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
+#define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 383d39a22561..fc5b8c85b690 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2047,12 +2047,16 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
- * The allocated objcg pointers array is not accounted directly.
+ * The allocated objcg pointers array or sheaf is not accounted directly.
  * Moreover, it should not come from DMA buffer and is not readily
- * reclaimable. So those GFP bits should be masked off.
+ * reclaimable. Node restriction for the parent allocation also should
+ * not apply to the slab's internal objects, as well as __GFP_COMP used
+ * for new slab allocations.
+ * So those GFP bits should be masked off.
  */
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
-				__GFP_ACCOUNT | __GFP_NOFAIL)
+				__GFP_ACCOUNT | __GFP_NOFAIL | \
+				__GFP_THISNODE | __GFP_COMP)
 
 #ifdef CONFIG_SLAB_OBJ_EXT
 
@@ -2168,14 +2172,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
+	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
 
-	if (unlikely(!allow_spin))
-		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
-				     slab_nid(slab));
-	else
-		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+	/* This will use kmalloc_nolock() if alloc_flags say so */
+	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));
 
 	if (!vec) {
 		/*
@@ -2251,7 +2253,7 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 	}
 
 	/*
-	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
+	 * obj_exts was created with SLAB_ALLOC_NO_RECURSE flag, therefore its
 	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
 	 * warning if slab has extensions but the extension of an object is
 	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
@@ -2374,7 +2376,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
 
-	if (flags & __GFP_NO_OBJ_EXT)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE || flags & __GFP_NO_OBJ_EXT)
 		return;
 
 	slab = virt_to_slab(object);

-- 
2.54.0


