Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB71C5DF7E
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25E46B085D; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF5D6B02D5; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB1C6B085F; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA056B02D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 071D8C084C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:35 +0000 (UTC)
X-FDA: 85111430670.29.6465890
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB5D120006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kG43H0jB;
	spf=pass (imf03.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987353;
	b=72o/e4FBeauwhXysrC1gidMIBbDLnMirWfo2D1wQkZR3xNJHc2tCxNcsZs6HicZesBRKYN
	IQb3PAKsvOjgby2UIy17TyEt/H/Su/PPRL4+Z6GSqfHVT7mykjN/uFi6H9ynJnExL144s1
	TFkyO0GOCbNj7L+abOu7WxQcX9o/y/w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kG43H0jB;
	spf=pass (imf03.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987353;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sndHjI9YLuuLAUATMwNa6axIKcD6SyxamsQxbA4nyLs=;
	b=u13GjvdQw4KVQWsQIB8eca8n/7S5BCVe/wM4k9c40Sq+ZC3TajpSakWzFQVocJQFvCfF9b
	EvdcMio2looQd/42VEb8HvEUES/1cb3H/O+2+ZgP4rv/tMDyYOk3/G5CceNbbjKgN4IAx9
	NRLU223glr+NnvirKfkYbRGJP96xgwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F0C143427;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D4A9C2BD04;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=kuEHwBXtGwctLu6qKXdhOx+wx0UojFjK0d0zFur0xrI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kG43H0jBu0rVsrd1NgkPvUPGMVMYK1kcKXsqFvXQLFPW25EqEaT4L8YJtveEm67Xp
	 xC2Eo58kMX6Xkx0/UTlExtNVLTnnDeS7WAheSzyLL2lYCwJ6gkfBLmDDmMlX70yQ/h
	 5j2WkCHzpipz91qd/luctZvN68eIOKYZ/+nl3PYMicNksHUsDxpxIcCt72EqAuE113
	 uSbjPK0MfO5S1+wbLj5kwrYh72yXDi+OgaEZ/I8oBGhrtc4ExYRjMSb1QycWxONZOh
	 Btzx7BoGq3Xq7JiAoNB73R5znsZd6vQwAYUuYUZerPMkj6dgBlKV4B/Hp4XlUyt0n+
	 ztyybcMMTRNxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E31C5DF66;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:18 -0600
Subject: [PATCH 4/9] drm/gpuvm: Route gpuva_op allocations to
 folio_scratchpad
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-4-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=2727;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=hfnn2JXUUX2MnAJuI+XocbzOzt9nFPPM4gsyoKFfaV8=;
 b=tOf7FwZgeFhwjRf2P61V+1ciBVYTcBIRJ4/DWzCwZDYpfrvSen9nBPACUBxDKUMeVVJ8v4CaP
 mkzXUqlmIs3DYZ8/WvkgAQUjjUavZdG8d4TJsDC7vinDqpN8OckRK7E
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DB5D120006
X-Stat-Signature: 7pz11qdnn67gwwxcheowmg8t4af368mf
X-HE-Tag: 1786987352-342258
X-HE-Meta: U2FsdGVkX19AUo8MGci5JdXqvqkirGenMwOjZ58wh3a7DOrbh/C7n2oAdXi7xl/p2Txal2kTcKQzSf+WUZhtOJq+yqW/HG1lsW2ksFx8cmjH56C357b2feW1Q/96l8+83IbgDQWg/W1GrRaIL/3HdwdwgL0b80VCHgDS1R+rJhGywF3Kjl+etYjEgGCiZV3bbKuaXrn6JnCQlB3qjXbhBwusN5GyyGGYu3258uKLtfehdETb2rniZfhiTrijpo+VaK1vLAPCy37xuq0CrD0ahgtyaYNpI1zJXUGCZIeL3NDdmvSeDMouPt9bguQjvjnGTgUF225eg/eQpepxgs+hmy44NXJesLoHZR6V68tQEPfEW3NqKV7bmojhaWseO8taEB4uA+zsysqISN4ir3zPfIjji9IptMGXA/b9fUR+rgVrDlrdqgkEqPtfnWCJIA9Jkqw0ESSiFSeojZlN+12RTkJrif8KaurwvXDBQwCl9j84IfrNb9novZ+HLBzu4k4v1mtqkRIek+4Gp+HRfqrTg9FPPLGoAuWFWvpSHZdJoph6sPvaHgWOMpeVkO4wrHPCbXB4Wy2Vki+VVf8NdckV/chOTTl3lN9OCITCJ+OZBgEADaectOo50BNASeCp3egG42KxAe4eJTQJVNFB60yisVniOVnRryWZu7T3Z56vj/pq15RXYLbu+P9/YaVx6/J2eN7orlqeiDlYJMBhCNtmIeSuyr4EmkU47VznZMpxFe2CKWYoymwF8SretevUndPH2dSMyxYQbPx4yQ29qPsdmU4yA2b98xDYWH6XYXRRSEKf2ncw7G4k3A2e6xiWQKBK/Kj/siwYjZpOST7/6LYXnWld86poEs7bdPP0bWYJH8AhYHGwvt9P6ihH2O1v9i6MAbL7Q2hb+g84XqOHEuZ67EfLNxy09qYcv8vhaWItosNuTRFBoyD3076lnK3INHdcysY+fCt73iHiwoDxyME
 74EmafAJ
 8NZlyJt3sGT5cvcFyFaJI0uZeX01pxJMpFEsEvbtCsIcRVbyYQqtFsQgplPz53StNKYtoZVasGdI7nHpvOvb2nqzw/ZmF1uh+FJNu9bBJnQYeSjWh26aHArDg3FxGrtqlllgXjHEL8oVK4EYaw6HdXahJ4+7cY4XAGl7r6j1VfL/hbCSE6oHXrNb7viNSDygyEHBQWq/7xLCIObvskjeMA79prkuAnHPOfq3YENy5Sz6ZdF9kJozR05rYlz4lr2qxv+ipwhbhpQ/0+2Qj3G+tBdjF8P/iEu3P8vb61Sdl+naIULrQyPpinQuKCTWtAlPGa4/xjD1TR9ID+nJ6ELuwxz8Xq+emBLqL5Nr3a5LzE+GKGBe0Ilan1SaV/Fzhc6TnjEPvY8HzEkXvjRodFPZjg89U/6gb63lhGolI6lT1iA4oT6s2/Ub1Lnpeavb5cpk6peGPVZ3B3C0xrubz+O/n8vhHtb+XH3EuX/HWozrdZg45MxUrLClO+lE0d3+0ylQhW2jXmbn09EMA9Ws5km4ybVbGtPpamliqV+TnFeJ+E8T/Cs6wW5epvwsgBNxTH7/1DOusK0s4RkYEebIyatXEQ8/cNggKKkd6lU90kgXhu1neKgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Embed a struct folio_scratchpad inside struct drm_gpuvm and route
default gpuva_op allocations in gpuva_op_alloc() to
folio_scratchpad_alloc_obj(), with O(1) bulk teardown in
drm_gpuvm_fini().

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/gpu/drm/drm_gpuvm.c | 11 +++++++++--
 include/drm/drm_gpuvm.h     |  6 ++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index c422c5af1f4b..6bb82ac9e2d6 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1109,6 +1109,8 @@ drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,
 	spin_lock_init(&gpuvm->evict.lock);
 
 	init_llist_head(&gpuvm->bo_defer);
+	folio_scratchpad_init_key(&gpuvm->va_scratchpad, get_order(SZ_64K),
+				  &gpuvm_scratchpad_key);
 
 	kref_init(&gpuvm->kref);
 
@@ -1155,6 +1157,7 @@ drm_gpuvm_fini(struct drm_gpuvm *gpuvm)
 	drm_WARN(gpuvm->drm, !llist_empty(&gpuvm->bo_defer),
 		 "VM BO cleanup list should be empty.\n");
 
+	folio_scratchpad_free(&gpuvm->va_scratchpad);
 	drm_gem_object_put(gpuvm->r_obj);
 }
 
@@ -2849,6 +2852,9 @@ drm_gpuvm_sm_unmap_exec_lock(struct drm_gpuvm *gpuvm, struct drm_exec *exec,
 }
 EXPORT_SYMBOL_GPL(drm_gpuvm_sm_unmap_exec_lock);
 
+DEFINE_FOLIO_POOL_STATIC_KEY_PARAM(gpuvm_scratchpad_key, va_scratchpad,
+				   "Toggle DRM GPUVM range folio scratchpad allocator");
+
 static struct drm_gpuva_op *
 gpuva_op_alloc(struct drm_gpuvm *gpuvm)
 {
@@ -2858,7 +2864,8 @@ gpuva_op_alloc(struct drm_gpuvm *gpuvm)
 	if (fn && fn->op_alloc)
 		op = fn->op_alloc();
 	else
-		op = kzalloc_obj(*op);
+		op = folio_scratchpad_alloc_obj(gpuvm, va_scratchpad,
+						struct drm_gpuva_op, GFP_KERNEL);
 
 	if (unlikely(!op))
 		return NULL;
@@ -2875,7 +2882,7 @@ gpuva_op_free(struct drm_gpuvm *gpuvm,
 	if (fn && fn->op_free)
 		fn->op_free(op);
 	else
-		kfree(op);
+		folio_scratchpad_free_elem(op);
 }
 
 static int
diff --git a/include/drm/drm_gpuvm.h b/include/drm/drm_gpuvm.h
index 655bd9104ffb..362b1d88d30d 100644
--- a/include/drm/drm_gpuvm.h
+++ b/include/drm/drm_gpuvm.h
@@ -30,6 +30,7 @@
 #include <linux/llist.h>
 #include <linux/rbtree.h>
 #include <linux/types.h>
+#include <linux/folio_pool.h>
 
 #include <drm/drm_device.h>
 #include <drm/drm_gem.h>
@@ -338,6 +339,11 @@ struct drm_gpuvm {
 	 * @bo_defer: structure holding vm_bos that need to be destroyed
 	 */
 	struct llist_head bo_defer;
+
+	/**
+	 * @va_scratchpad: folio scratchpad for transient GPU VA range allocations
+	 */
+	struct folio_scratchpad va_scratchpad;
 };
 
 void drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,

-- 
2.55.0



