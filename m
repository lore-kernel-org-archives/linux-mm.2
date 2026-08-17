Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42737C5DF80
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCDC6B0180; Mon, 17 Aug 2026 13:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057506B0766; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A0E6B02D3; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0E1E6B02D2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24CF98084A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
X-FDA: 85111430628.12.F6B62C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F1D010000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifKnws5C;
	spf=pass (imf05.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987352;
	b=U98DzZt98zpAq39pRtVuQFTf0ogxThF6MFB1HGYhhYY9a9CXPbWQ5raS4mG1MMdPoXPc/f
	MiaamvyhIfbrDFiS9lEecM/qeLeL9B1uy7CgrHmYKeal6K7aqhPjPnqTHx/8+P95Z95jqu
	tCtqI8Ee48h8fpw+pHMgl0Lhc/CVvv4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ifKnws5C;
	spf=pass (imf05.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987352;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwF3TWOG3HhooMr5m4Lv5DjA1NrVpqtjXmUTlWMkAwI=;
	b=OC1SCb8OYsNW7ZnVkwH7HlVp7s65m5rUuWMXIo/S2qx6n4MihOr7bNOQj8pQ+i2mISjM4L
	RxsWuvwlidSuPepk1Ios+9SAikR6BHAw4eHy0UtOJibAt9VWB0JiUR0+YxnsHLHB8Tf9u8
	9MJkeczZMqusShm5hCxKUM6Cff89xhc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED47C44034;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C97EAC2BCFD;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987350;
	bh=U1+Ek/3s/WPSEWc+Ji9eDDTMwh4oU/I3rpqWvBD4/dE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ifKnws5CPv2vi0ZSSyMwNFx4srNsY5jJt7UxYma2Zri19tbwn1erPuOK9QL3+NuaB
	 +p8V3e3FsUTypKV18FKwrz4jLAdL/JMZN/FwFmuzCvAivepiGFUJPKC6tZ9s4giEv7
	 f4QlUmN+k+1gbYTd5PdZhaQfjJysS0sVO2zgZqeNe9uPOcoRUdcsj5VskHRCYkRc51
	 pkKo0tNfrP4DUjFlryhnf0k7Hl2kaDmVvY2oef7Tm5YiWm60HLv1OQ478ALvHop1fY
	 WoSjf1vTEDHPB9lgjVJFiMu8KzM/8+qOJAVz9kkMeyTDAHZSkxp8LdPLBjsz74uNiu
	 l+iTYjeweruug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41D5C5DF7A;
	Mon, 17 Aug 2026 17:22:30 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:16 -0600
Subject: [PATCH 2/9] netfilter/nf_tables: Add folio_scratchpad collector to
 struct nftables_pernet
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-2-0c1d230aa3af@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=7401;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=dSEV/cYCZ3Qb6/NhIB64Wuhs+Fc/mi4yHqcEj2j33Gk=;
 b=JwPFc40mfBR4l4YApSTZHSCZ60JTvPi2kTFJYnQLHTMRj0R/cy/XYGAl2tIVO8F41I9bQT35N
 I3eRa3fAx4RD7q8aW/DO5QQmwa/bXaAKx8GdSbIDsNvNBRYUqAEOm6f
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspamd-Queue-Id: 0F1D010000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: to4q8h17rkp151cy5nfbe6ux7ab8prub
X-HE-Tag: 1786987351-807695
X-HE-Meta: U2FsdGVkX1/9Wvn688Z7w3q3LmVly835dRZHvj1Y15alE4wEsYjYRoWXK+1y34xrG0NDAbWdn8uxTARBnUr1OANbzIq4dEXZnENJSQrPSsKVazglT0NQT63RNzjuaLHqc1CellofB51nhyVPmEf0gxq+bn/poc8cc1mTy/UVuxFUhrkVo99+fB85qYLemccU7EOD/aqdANgxAhPiILVpzZpRglJlhvKqVv5/ryG3vSxdfQXTymGb8+pv6JK4FQHyebuwnB5qTYI68jr075usMwj+jXCOznAINpj3h/EnVdj+nwR7eOtMuLvzEcwjiBTos2IlUiIzPaTsGvsy8Axo1Ts+rBX7ZvOqxt+wqmIduxKGQiIbtrQfuTIRhDdOV+l+cMJew5KroT9S0F+glbvzOET5+OIS+UBZtM9IPHaHmQfJZIpVTh/OsSTmkKu/qWxANac572rulKqjpkR2ITCfGpJeUyPHYxlf4qNRgk/+/oNL2PPgtoVB10xQvjVelLW6+4TMaa5gitDgNlVx8obrSzEseOao4X4lkRZ5z32662WajBYv8jJE/gYvmA/uAJj/T7DCff9H+jDHjegBmXOl3DNGdvmXoiwHda0YzYOEe32CJdZ5l1/+wJ7BxiQCZRJpUcUKf0BbnD87rc1J8UhC0bn5o4Q/5btdtklJR2dFc/0bNHogvI6/p8mk4vw9a3u91hwKWBbxNGgq0khRQPtbQlZF2ol+iR5aK5WmBH5iPY0BPHNsE9Wz27O9PhNDQP7NWEoZt2XnfgsTT530gMbHkXnAtvRFPcKepXqSRPAMEZQ1MELPJ6ijkJENV5tOyg5oz+9jFkh28RD8/um25JARJ3PPPzPAh7/ZejLc3ouIL03FBkggyqVxzhXMTKjYgPiLYCM6VCJtObLMHnowMHu4d7QFHtNtUMxUmh9ZVWNT55+C1/Tq44OjnEs0wsekQt3Zqe/fUun8pTRZ7pSMQ5R
 3MpGBdOh
 z7oI5BrXcpdWW4HVSk6Z9YA/Q06xEt951wYc8DjXMZk88P5jK4pRwzVtk6YLXHQa4o2+oaWSGT3Ut8tb2yLVSGPQf28KPGKxbsaGmsVt8pQG5VvDwKqCdhJL302dEVIaiN/8XVjbDKCKr6ITcm46SXCkRi/6vO+2ifXhuQLSfM3CH+BmBSw8sxZMQFLpe5OYwlc7dU1BUvJhM+FZMxUwtViCtcQRLgF78iNW998P396kt8WskragOBV4IXmLMK6vYa/Y2JFim70uTPOHb68pJQ1ouWJyg1id09FzYinAQS6Iidi3zKs9xh5Hjeybd7hdj/hTnYQJ4gdInfsg1JeBNyPiopqnQCJ9D4Jb4AavGG79ojo9qEvPxCKUNEoWESfegE35L6LDB/JnQqqHTw7+Duw27h82WIxy3evG4jOwdcpXOukTOhqP3Hbh8Utpey6OuRZsYeq87sJ6YAfs99ufTINDONnf4Qqe0D7fI3zfKPus43Un/Oxol3tPVeKGdI8z1uLwFmrODXMqSEg1DibtVb3ujz6gOwNz8G5xD8WnDdjKDbKPnk4eYl7snr4F6f/WCj/NUQJgpceeF+IM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Embed a struct folio_scratchpad inside struct nftables_pernet to support
variable-sized region allocations and O(1) bulk teardown for Netfilter
batch transactions.

Route nft_trans_alloc allocations directly to folio_scratchpad_alloc_bytes(),
releasing all transaction objects in O(1) bulk via folio_scratchpad_free()
during commit/abort cleanup workers.

Controlled in-kernel ftrace function profiling on 10,015 netfilter batch
transaction allocations demonstrates ~12% faster allocation and ~7.6%
faster destroy worker teardown compared to standard SLUB.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 51 ++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3be612145c13..b4a6cc1f46af 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1941,6 +1941,8 @@ __printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
 static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
 #endif
 
+#include <linux/folio_pool.h>
+
 struct nftables_pernet {
 	struct list_head	tables;
 	struct list_head	commit_list;
@@ -1949,6 +1951,7 @@ struct nftables_pernet {
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
+	struct folio_scratchpad	trans_scratchpad;
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	u64			tstamp;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index af357f6c5070..8b9e0c905d84 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -173,12 +173,17 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
+DEFINE_FOLIO_POOL_STATIC_KEY_PARAM(nft_trans_scratchpad_key, trans_scratchpad,
+				   "Toggle nf_tables transaction folio scratchpad allocator");
+
 static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 					 int msg_type, u32 size)
 {
+	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct nft_trans *trans;
 
-	trans = kzalloc(size, GFP_KERNEL);
+	trans = folio_scratchpad_alloc_bytes(nft_net, trans_scratchpad, size,
+					     __alignof__(struct nft_trans), GFP_KERNEL);
 	if (trans == NULL)
 		return NULL;
 
@@ -194,6 +199,18 @@ static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
 	return trans;
 }
 
+/*
+ * nft_trans_free - release a transaction object.
+ *
+ * Scratchpad-backed objects are not individually freed; they are reclaimed in
+ * bulk by folio_scratchpad_free() at batch commit/abort boundary.  Kzalloc'd
+ * objects reside on slab pages and are released immediately via kfree().
+ */
+static inline void nft_trans_free(struct nft_trans *trans)
+{
+	folio_scratchpad_free_elem(trans);
+}
+
 static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -219,7 +236,7 @@ static void nft_trans_list_del(struct nft_trans *trans)
 static void nft_trans_destroy(struct nft_trans *trans)
 {
 	nft_trans_list_del(trans);
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
@@ -519,8 +536,10 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 	/* krealloc might free tail which invalidates list pointers */
 	list_del_init(&tail->nft_trans.list);
 
-	new_trans = krealloc(tail, struct_size(tail, elems, nelems),
-			     GFP_KERNEL);
+	new_trans = folio_scratchpad_realloc(tail,
+					     struct_size(tail, elems, old_nelems),
+					     struct_size(tail, elems, nelems),
+					     GFP_KERNEL);
 	if (!new_trans) {
 		list_add_tail(&tail->nft_trans.list,
 			      &nft_net->commit_list);
@@ -600,7 +619,7 @@ static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *tr
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
 	if (nft_trans_try_collapse(nft_net, trans)) {
-		kfree(trans);
+		nft_trans_free(trans);
 		return;
 	}
 
@@ -3068,7 +3087,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 err_trans:
 	free_percpu(stats);
-	kfree(trans);
+	nft_trans_free(trans);
 err_hooks:
 	if (nla[NFTA_CHAIN_HOOK]) {
 		list_for_each_entry_safe(h, next, &hook.list, list) {
@@ -7636,7 +7655,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return set_full ? -ENFILE : 0;
 
 err_element_clash:
-	kfree(trans);
+	nft_trans_free(trans);
 err_set_size:
 	if (!(flags & NFT_SET_ELEM_CATCHALL))
 		atomic_dec(&set->nelems);
@@ -7904,7 +7923,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 
 fail_ops:
-	kfree(trans);
+	nft_trans_free(trans);
 fail_trans:
 	kfree(elem.priv);
 fail_elem_key_end:
@@ -8287,7 +8306,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	return 0;
 
 err_free_trans:
-	kfree(trans);
+	nft_trans_free(trans);
 err_trans:
 	module_put(type->owner);
 	return err;
@@ -10253,7 +10272,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	if (trans->put_net)
 		put_net(trans->net);
 
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void nf_tables_trans_destroy_work(struct work_struct *w)
@@ -10275,6 +10294,8 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 		nft_trans_list_del(trans);
 		nft_commit_release(trans);
 	}
+
+	folio_scratchpad_reset(&nft_net->trans_scratchpad);
 }
 
 void nf_tables_trans_destroy_flush_work(struct net *net)
@@ -11244,7 +11265,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
-	kfree(trans);
+	nft_trans_free(trans);
 }
 
 static void nft_set_abort_update(struct list_head *set_update_list)
@@ -11468,6 +11489,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		nf_tables_abort_release(trans);
 	}
 
+	folio_scratchpad_reset(&nft_net->trans_scratchpad);
+
 	return err;
 }
 
@@ -11499,6 +11522,9 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	else
 		nf_tables_module_autoload_cleanup(net);
 
+	folio_scratchpad_free(&nft_net->trans_scratchpad);
+	folio_scratchpad_init(&nft_net->trans_scratchpad, 4);
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
@@ -12142,6 +12168,8 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
+	folio_scratchpad_init_key(&nft_net->trans_scratchpad, get_order(SZ_64K),
+				  &nft_trans_scratchpad_key);
 	mutex_init(&nft_net->commit_mutex);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
@@ -12186,6 +12214,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
+	folio_scratchpad_free(&nft_net->trans_scratchpad);
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)

-- 
2.55.0



