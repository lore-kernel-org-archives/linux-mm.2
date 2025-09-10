Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC50CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCEE8E0022; Wed, 10 Sep 2025 04:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056FA8E001A; Wed, 10 Sep 2025 04:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87FB8E0022; Wed, 10 Sep 2025 04:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5F1E8E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AF2886C66
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:23 +0000 (UTC)
X-FDA: 83872598166.14.4CB5B80
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E8DC18000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QAwn/o0h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="B2VvFl8/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QAwn/o0h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="B2VvFl8/";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491341; a=rsa-sha256;
	cv=none;
	b=UDz3o5uWNe0yRamg2m4zSZ7TR3GLBGTQHFn01tYz2XNQs8lU2rnTrLxeWDWpZW7idvIseI
	EJYIjB2WPxzZtKVbygRSEQGIxjIlUqOXVWT/DDc/2CQRbjo2bAIjNPJlms24MPZvXJ74uL
	OIglCpleiZrvuxnQl93c6vlF6znykgA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QAwn/o0h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="B2VvFl8/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QAwn/o0h";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="B2VvFl8/";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBs29MGarWPPgfpNi/IH3TvKAOWJMh4Zi3GI/cxY2Sw=;
	b=EeGlzIDbew9ProWQzRYiAxXnwe9R5Ka0C9LilnSCBhHL8llGlQ/EXOdpAox0+0Gn1Q7i8s
	tZNYeykBK7T2GO/iMtH8Ej+is+JvHorJkFSPz0dEKzIZFTJh9augWUolvmaWL1vSCEL5E9
	60gzVcDu7wko3+tSawF6E+W3qCb++tE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B83E35CC1E;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBs29MGarWPPgfpNi/IH3TvKAOWJMh4Zi3GI/cxY2Sw=;
	b=QAwn/o0hQcy3b0jhfKJ5rtaMkm65Q8ExQ8JQMpeYcwN68k1Sp4WdAYXg6sZHeaVJE4VAfY
	+9p1R1DBduVlM5S1LZO549DDZto6jHWa5DXUYgyADQUjM/l6dLgrAzp5poGUW8hF5zraVf
	S6WBfzUUEpbM9u8JIIqlqOmV6P3WGCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBs29MGarWPPgfpNi/IH3TvKAOWJMh4Zi3GI/cxY2Sw=;
	b=B2VvFl8/JpnCy5aMxPz4vU4D0g9UTbSLnV/oaY9FdpZusIYBkxwJddeUb53zKiUd0VNkAZ
	j6/0eYHhIq0Iu0Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBs29MGarWPPgfpNi/IH3TvKAOWJMh4Zi3GI/cxY2Sw=;
	b=QAwn/o0hQcy3b0jhfKJ5rtaMkm65Q8ExQ8JQMpeYcwN68k1Sp4WdAYXg6sZHeaVJE4VAfY
	+9p1R1DBduVlM5S1LZO549DDZto6jHWa5DXUYgyADQUjM/l6dLgrAzp5poGUW8hF5zraVf
	S6WBfzUUEpbM9u8JIIqlqOmV6P3WGCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBs29MGarWPPgfpNi/IH3TvKAOWJMh4Zi3GI/cxY2Sw=;
	b=B2VvFl8/JpnCy5aMxPz4vU4D0g9UTbSLnV/oaY9FdpZusIYBkxwJddeUb53zKiUd0VNkAZ
	j6/0eYHhIq0Iu0Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A12C613ABF;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0IQQJ0MwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:25 +0200
Subject: [PATCH v8 23/23] maple_tree: Convert forking to use the sheaf
 interface
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-23-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E8DC18000A
X-Stat-Signature: ca1kcp4thcocd66xo6aeb64hz43iba8t
X-Rspam-User: 
X-HE-Tag: 1757491341-952254
X-HE-Meta: U2FsdGVkX1/bYhoYBhH4QC3mk2xGvOfYtrJSoEHjpeu+UyPMrq7O3rdgMvNc7WFEO1qIqg5ZeslUpvN0aqR6583QnIcPakC6JV7Z3idPDEhAvchdJHB/OZdMspLBx6lcO5yPmUTngklptJqTtgej8cwVMpHVh0UTgqXqWkt1N/Ocr/gCPOzlRdzyXLged5EL27Y40AvQiBlvSO5iR909JWwwp3rwghErkM4bIAnna8Lq4D3biYvD7o9BKmZrl8X1qPz1NvIPgS+o8WRtIz8FYOGEGFxHC/441f/UxVTWISyFB7grt81mHbVkAHaFww04KEMKtYg7gZkqtSZOQ7KFelaE0rR/aJRBqwmxPLl5pHsJ4Rnjk4dcvjoRPGa1c1wqNdA3ABxDASW8V9YZeECjrp5gSSfw6ICgAW23kQIlXeLEqyJLmIzSzKdoWSHPa+5T3ahtYu6B/Lx0aC2S1bi0pN3+Hx1feNkXl8mX6oBoCQdtKWc1Nxpzoevta4GhVXplmFaYcPa+fdfMrJpAlwuD+Hm5aZatBXMgdu/iW1NJ236ivhtq1J1CedBZjaeUmM8gM7cAuC16/0LYeEN9ZzwALgs0eRIJw8SsdjpYmFCnY3nJzAEvBZyZ7EbbCRLgNmjoSUdEmDxUQyRbvde4cobnsoi2Xir0Hwv+stbsNdybVd5sPVEEJPWIfFQ7XrQMQWacvfwFeX4CXXA0jwCxux8KJMp8axqjzvNiGw6XlyX/KrOD+4gh3eJnnWxMdESVpUPEcrYrE3b6oEpP3uuX0mAEI04xzEpTU+ZXcT9RhXGTjccroSxaLdj+8YvwZV8dRisrqtf0bpI+nj6cEVBmAGWAsp8E41ZluTHL7gMMcq8Y3g3jAqoMdGBz3iADrg06jFa8MzIoquivH1Ua10MejZZpk/yw6Xj4mJs5026kgtXvGIHCQnpp377I5u7u8dccozqAlN838Dz3YtZBgdlsiDc
 59QvwpzE
 Can92F69AjSd+oosx8VuD4ny7FN4XRhofKD7bd76T+T1LNbY/3mtJ3pTD+9fBAiSfXZQ//6iHVvOe0UxrnHrwchMNmW+FMJb7LlkssXYvWH2UzxykLmKq0zgHyyEC+z7idTUAS+dFWLmgtK/OW5FKJffe0ot0kpGxLV9BQJXEGJuj0c/7CVMgzg0NFU9afjk2LGZRWCbdchCOCAMgt8QV4EWFO5sqLYZNznqGdZiWUQY+y+qNuVTUFioUrsVgp64dQ6RjUZl7PbBM0oapJmSL9PurTOlGD6peTdIsOepufR73DOSFFfZdh87OvUL7IM7ixEwwg+bjYqUI0k1NY+MkrkhI9ipuMkE21uBNElF5fSacJDTJGpTTdPpL/+J8c9LEDcANJBL8+bZOBFICpeoGNDt39Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Use the generic interface which should result in less bulk allocations
during a forking.

A part of this is to abstract the freeing of the sheaf or maple state
allocations into its own function so mas_destroy() and the tree
duplication code can use the same functionality to return any unused
resources.

[andriy.shevchenko@linux.intel.com: remove unused mt_alloc_bulk()]
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a912e6a1d4378e72b967027b60f8f564476ad14e..bb51424053a5c4ceece7604877dfa3cd3780944a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -172,11 +172,6 @@ static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 	return kmem_cache_alloc(maple_node_cache, gfp);
 }
 
-static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
-{
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -1150,6 +1145,19 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 	mas_set_err(mas, -ENOMEM);
 }
 
+static inline void mas_empty_nodes(struct ma_state *mas)
+{
+	mas->node_request = 0;
+	if (mas->sheaf) {
+		mt_return_sheaf(mas->sheaf);
+		mas->sheaf = NULL;
+	}
+
+	if (mas->alloc) {
+		kfree(mas->alloc);
+		mas->alloc = NULL;
+	}
+}
 
 /*
  * mas_free() - Free an encoded maple node
@@ -5208,15 +5216,7 @@ EXPORT_SYMBOL_GPL(mas_preallocate);
 void mas_destroy(struct ma_state *mas)
 {
 	mas->mas_flags &= ~MA_STATE_PREALLOC;
-
-	mas->node_request = 0;
-	if (mas->sheaf)
-		mt_return_sheaf(mas->sheaf);
-	mas->sheaf = NULL;
-
-	if (mas->alloc)
-		kfree(mas->alloc);
-	mas->alloc = NULL;
+	mas_empty_nodes(mas);
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6241,7 +6241,7 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	struct maple_node *node = mte_to_node(mas->node);
 	struct maple_node *new_node = mte_to_node(new_mas->node);
 	enum maple_type type;
-	unsigned char request, count, i;
+	unsigned char count, i;
 	void __rcu **slots;
 	void __rcu **new_slots;
 	unsigned long val;
@@ -6249,20 +6249,17 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	/* Allocate memory for child nodes. */
 	type = mte_node_type(mas->node);
 	new_slots = ma_slots(new_node, type);
-	request = mas_data_end(mas) + 1;
-	count = mt_alloc_bulk(gfp, request, (void **)new_slots);
-	if (unlikely(count < request)) {
-		memset(new_slots, 0, request * sizeof(void *));
-		mas_set_err(mas, -ENOMEM);
+	count = mas->node_request = mas_data_end(mas) + 1;
+	mas_alloc_nodes(mas, gfp);
+	if (unlikely(mas_is_err(mas)))
 		return;
-	}
 
-	/* Restore node type information in slots. */
 	slots = ma_slots(node, type);
 	for (i = 0; i < count; i++) {
 		val = (unsigned long)mt_slot_locked(mas->tree, slots, i);
 		val &= MAPLE_NODE_MASK;
-		((unsigned long *)new_slots)[i] |= val;
+		new_slots[i] = ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
+					    val);
 	}
 }
 
@@ -6316,7 +6313,7 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 			/* Only allocate child nodes for non-leaf nodes. */
 			mas_dup_alloc(mas, new_mas, gfp);
 			if (unlikely(mas_is_err(mas)))
-				return;
+				goto empty_mas;
 		} else {
 			/*
 			 * This is the last leaf node and duplication is
@@ -6349,6 +6346,8 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 	/* Make them the same height */
 	new_mas->tree->ma_flags = mas->tree->ma_flags;
 	rcu_assign_pointer(new_mas->tree->ma_root, root);
+empty_mas:
+	mas_empty_nodes(mas);
 }
 
 /**

-- 
2.51.0


