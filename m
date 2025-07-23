Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C61C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0522E6B00E6; Wed, 23 Jul 2025 09:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001F76B00E8; Wed, 23 Jul 2025 09:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C7E6B00E9; Wed, 23 Jul 2025 09:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA2F86B00E6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E8A014070E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:50 +0000 (UTC)
X-FDA: 83695627260.16.6020DD8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 356944000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sn6d6Wfc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3DXGttR4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sn6d6Wfc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3DXGttR4;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzLrbkIiOuwOvdyzKWDx4NnuEyUkSbgCzU8mbhcB3rk=;
	b=Xve9BwyY/3xi1J87uHHiO9R024Mz1OtiDbJ3QjLHPkIdUF3K5ho6nV7rRq2xXf3R3mK1ln
	lwsrnsIGSLQUJ5uX/9vRfSr7GsiAmhlNsoNSgctj3v4hmaNR79+3fFI22OaYlFWxS0ezQQ
	urhAzpjZU035B6/RKmHhCLesJc/KfgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277747; a=rsa-sha256;
	cv=none;
	b=hZxU7OO27pRkZYCdqSONmKbcdN9QyJaCR6lDUzM+E74G8iEo1J9lZuwf5g2jSBb8C+q9Ya
	K+A6QPqcf19crg3NdSWcGDMzYogHG46Jn4drkTMoa1D9UU7Jf5PQR9Y+oHed3TTSY8vRIx
	fBJe2npcP3nL7KjWr2QYmmqAoIQaI1U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sn6d6Wfc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3DXGttR4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sn6d6Wfc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3DXGttR4;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AF611F794;
	Wed, 23 Jul 2025 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzLrbkIiOuwOvdyzKWDx4NnuEyUkSbgCzU8mbhcB3rk=;
	b=sn6d6WfcnZz0DB5GiAC6bKFdOor9xAUmtBOjzv7UyoUJi3Brgkx5qyprggCv0Jz+3zOEBw
	VAtyXImFe99kv+r3YDGZME13MuC05nGNUHzdZ4oneFTxPl9nqQx/Ouv962zpAgZk2qzTC4
	9imwhDfigzZKEOTRlrH+cY08NQ+0Uro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzLrbkIiOuwOvdyzKWDx4NnuEyUkSbgCzU8mbhcB3rk=;
	b=3DXGttR4IxzgIWDb2FW7GeODLV2hRB1+1SJUyMLWvyXK6xe4UaC+7BfWGz+b3dUeL4MiHq
	BeWT8hkanTBQ29CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzLrbkIiOuwOvdyzKWDx4NnuEyUkSbgCzU8mbhcB3rk=;
	b=sn6d6WfcnZz0DB5GiAC6bKFdOor9xAUmtBOjzv7UyoUJi3Brgkx5qyprggCv0Jz+3zOEBw
	VAtyXImFe99kv+r3YDGZME13MuC05nGNUHzdZ4oneFTxPl9nqQx/Ouv962zpAgZk2qzTC4
	9imwhDfigzZKEOTRlrH+cY08NQ+0Uro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzLrbkIiOuwOvdyzKWDx4NnuEyUkSbgCzU8mbhcB3rk=;
	b=3DXGttR4IxzgIWDb2FW7GeODLV2hRB1+1SJUyMLWvyXK6xe4UaC+7BfWGz+b3dUeL4MiHq
	BeWT8hkanTBQ29CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD4CB13ADD;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gCa6NQjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:47 +0200
Subject: [PATCH v5 14/14] maple_tree: Convert forking to use the sheaf
 interface
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-14-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 356944000E
X-Stat-Signature: 6gbkbbfiwgcn1ta3dn7j7s445ruhzpi7
X-Rspam-User: 
X-HE-Tag: 1753277746-81126
X-HE-Meta: U2FsdGVkX1+7Y/rYz7gdd3JhG/uTLxXIIo5di6c0BRtw+UEEv+GAuktAikmPiW0RhwDAqAsKwJ0euJLRIF+MPjpvRadWu0ZYXxJ9DbKOre8TJ5RoNle4SH8ho0CuJZtAZd4TbzCkmrJdKg2Xulyrx11pxshWUcOcp3AzjdF02AM6PcKNEz88aK4qGdcmflPQ5NHo9nIcMa2hCe9khXjhf7OEQJTGrdYQU676eSiSfjveBr0QtUCj407aENr2edziYAHlfWfTdala/GUqmyc7uWLpNrtq99oYgdcvowpZyA3dWaGJoJWr1iZmaVM35iMRG0HEnhAKcPG1H851RL6NsFTHu/3Po7OCPpHksG1tVNvlPu4X8y1yixEhoXvcZ8tMeJgp1r2s56Wsf0nvmB4Ni/hJmUV6p429OQpm0ERmDt8ZsyXK+JgMmMxzLiRNaobG7+4/70ns6+guO8JlKCJn5YCEGgU+J/M+SMwhUTBZPGCPfrS4URyAZD+wuzsYcKTFe0a0BVSRSsyKn4yEA9InQEfqVJx3c7fEUv6esn/bVgOh/TB6pHayWo1Y4QXUnSOGPHM/leu+Xx7lXX/25S/387kJAfT4ObQu8SyJBHGcLFZuoeZ11SbX9sdzd/P6L0MNXRpeOlSoIz2znvAqw42lJBSpCOExmFl06rCmXLT1FxanHYRXgGDW5pfzJqLxGgxyWIaIVuUF5w8RjFe9GIpB84xiTfuNPMxtHaRanWr1Co9u+yfK5t9pTv6nyeu/jXeEJGPX8A3sJCY55KK0RmobIfjLa+EZYHSCJXrnoRPEiEtT2n+D3JTErdfS7Q1YrJAGHJCw/WSUYaAXXHrZjw3PDtm5oMmErf8d3/a3Z0IqSd4ryAxa6Y624lhF9ZMgNjSpDV+cd6FemuApOuVGAJeO3z9a9AqP+5d5iQ63Osj4hu6nh2St91TR1na17uZt9YbU94ralmdb+E/QErr/QV6
 m4h98aL5
 W3zHLz3Uh4/886Fxt/VNHj2u/Sr2hKqGav0ROKQQ6u9iAmIU3v6nYehK7uCp2PQKGQJIaIMQtuAOAQXMilSYHWHT1v0tRovVJcRB0F1+5kEo2e0+dgLdcFuFA+yDhDKA6jE1noxbpJnC9nn1eofTX8T81YiNw76EXjGFcQ01ulvQle/sVMyqMHXOYgUZqqkrbAV1KFJ/+v9N+ud/VVg7T8Y4KbLRgyCdAqy/k/nncdjyf0PW9vresSrEK80O3Q5fWT+tfi+npYQCD6ipYxxv2tpsmorJqSbokURqiX910jGY1p9F6IzTymxhN1086TAkexcfJeiErXeNiUWO2rSwH6KzKHKetiNGI5Rr9d+J8mFq5QzZrhNuhW1c8kJEJ9oikOlQ5QgCeE+FQr1c=
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

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9aa782b1497f224e7366ebbd65f997523ee0c8ab..180d5e2ea49440248aaae04a066276406b2537ed 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1178,6 +1178,19 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
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
+		mt_free_one(mas->alloc);
+		mas->alloc = NULL;
+	}
+}
 
 /*
  * mas_free() - Free an encoded maple node
@@ -5414,15 +5427,7 @@ void mas_destroy(struct ma_state *mas)
 		mas->mas_flags &= ~MA_STATE_REBALANCE;
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
-
-	mas->node_request = 0;
-	if (mas->sheaf)
-		mt_return_sheaf(mas->sheaf);
-	mas->sheaf = NULL;
-
-	if (mas->alloc)
-		mt_free_one(mas->alloc);
-	mas->alloc = NULL;
+	mas_empty_nodes(mas);
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6499,7 +6504,7 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	struct maple_node *node = mte_to_node(mas->node);
 	struct maple_node *new_node = mte_to_node(new_mas->node);
 	enum maple_type type;
-	unsigned char request, count, i;
+	unsigned char count, i;
 	void __rcu **slots;
 	void __rcu **new_slots;
 	unsigned long val;
@@ -6507,20 +6512,17 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
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
 
@@ -6574,7 +6576,7 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 			/* Only allocate child nodes for non-leaf nodes. */
 			mas_dup_alloc(mas, new_mas, gfp);
 			if (unlikely(mas_is_err(mas)))
-				return;
+				goto empty_mas;
 		} else {
 			/*
 			 * This is the last leaf node and duplication is
@@ -6607,6 +6609,8 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 	/* Make them the same height */
 	new_mas->tree->ma_flags = mas->tree->ma_flags;
 	rcu_assign_pointer(new_mas->tree->ma_root, root);
+empty_mas:
+	mas_empty_nodes(mas);
 }
 
 /**

-- 
2.50.1


