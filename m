Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03FC6CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613EF8E0042; Mon,  1 Sep 2025 07:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB308E003B; Mon,  1 Sep 2025 07:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5018A8E0042; Mon,  1 Sep 2025 07:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F29B8E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E04B1A07D2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:48 +0000 (UTC)
X-FDA: 83840411256.16.1DEF2A7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB3E914000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="nlPUE/e7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wxl/KWzB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="nlPUE/e7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wxl/KWzB";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gsZxO7UwDiPyyfTVlyF4n/52yTA0EMnZqzW234FbC8=;
	b=sxCRJaL5Hqib8h3Rba90oI/8nLtwfgH1e5pJpQIcl0YJAMBCAbr74Az3xCtcMS0HqLS3lA
	ZXqzNNy9VZaLekJhopkVLEd3wlWnJ6LujNUejvH7c+qoK/CR5iFpqo8w563a5VMSJV9Ma6
	RWflsL3B04xOxaoxWLcTfhUwwnhlgxg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="nlPUE/e7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wxl/KWzB";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="nlPUE/e7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wxl/KWzB";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724986; a=rsa-sha256;
	cv=none;
	b=CkgBMTAiZhAT/VAftJf41srepOj1ZSETovko8nGksii7MPjVScPKils4JAA5Iqwm6SY7z6
	Uvbk/fKN9irLkdKUeG6bgcQWWLGiXcpFJ71E4tE0xkNcasrEQ3gPlHMiY4QCCdEyIIBQzf
	gU/dDHZ17w4nRuoxw/J0/njkzcSo9B4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2495F2117F;
	Mon,  1 Sep 2025 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1gsZxO7UwDiPyyfTVlyF4n/52yTA0EMnZqzW234FbC8=;
	b=nlPUE/e7F+X8WrUw6J4qfcaLHa1uKKS4XsuggwRVtF7gTcz6nFif/WwVknP27fkOgF8s+Y
	c+EmrfkGo3vXsFVUVjzCG1vpuxoslzDrD/1Puf/BAybyr8hg2XeZZ68zHLelYE+w82cAC9
	XaT0ZxkP1W+ocEUdOALgCcVJZY1mdRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1gsZxO7UwDiPyyfTVlyF4n/52yTA0EMnZqzW234FbC8=;
	b=wxl/KWzB0/GJpacisYIzHBgqZs9iqq7+mJn12vMwX9zQiiIWqooa/mHXaGDOtTjlqsCTbv
	FZdwNt8oIPrStaCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1gsZxO7UwDiPyyfTVlyF4n/52yTA0EMnZqzW234FbC8=;
	b=nlPUE/e7F+X8WrUw6J4qfcaLHa1uKKS4XsuggwRVtF7gTcz6nFif/WwVknP27fkOgF8s+Y
	c+EmrfkGo3vXsFVUVjzCG1vpuxoslzDrD/1Puf/BAybyr8hg2XeZZ68zHLelYE+w82cAC9
	XaT0ZxkP1W+ocEUdOALgCcVJZY1mdRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1gsZxO7UwDiPyyfTVlyF4n/52yTA0EMnZqzW234FbC8=;
	b=wxl/KWzB0/GJpacisYIzHBgqZs9iqq7+mJn12vMwX9zQiiIWqooa/mHXaGDOtTjlqsCTbv
	FZdwNt8oIPrStaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E11A1378C;
	Mon,  1 Sep 2025 11:08:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oAwtA8Z+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:09:02 +0200
Subject: [PATCH 12/12] maple_tree: Convert forking to use the sheaf
 interface
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-12-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: CB3E914000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5p4di1okgad1j7owtwdsk96jqzty66fs
X-HE-Tag: 1756724985-726680
X-HE-Meta: U2FsdGVkX1+iQRGgugU0QuGAgIRoXF/C+E2eFyi8HK9CVvUbvQqObSl60TJblZpGZ+fAjWf/hS1az/RDLawJboAOhP7rXEgC5gMeaQVc1d+9v4RIC7bgf6vcWQ781U3v+Fa3eiN1eZJOfCyvx0tRwFcdxdlLoz/9hrtaRyKwcoMkkc3QASirBvcV4DFOzMmhRyAZUtlk5UTenqdp5+Y1gbfQ4N1iCKxp3eRhZ1zBVg/fwVyATbYvJJBiW9YKz67ZiPdgDZaI7p/1dVoH3toh3N2zx/R1oFvzJC4JQU5Dmzx72ADO77pI2tysu3iUR0LN0aLfv6EB6u3t9B/5ICeoUDwUj0WbQ9fW4mBGuqiaqMBn2Yl2rYklhGmea34NrSuGQ1shQxfPnJBf5z4oiSSzYmuDuxnBIus0CIlWzQ7FNZhH53yLwAWoMqSTSFYvEyYwTS5MwCMYzCabe2E/SeE4Rwio30V90WZ2jJpd/AFtgPpme2oY4ryP8WXn8zvxahieJ/1Wydd6O41soVQXgh/KagwFOuyplQPCoYmE9xNsgkGGW0sPVXileVGWqsDU1oKiFkWZChCHW3QypK6NBt8DMrZKTRiLVPiRAmGtuEshyrEgCRy6+q8Wv18RuxRWX3o9Co1AfmAqO+0/bo+9MYV1MELvRzN3XToLaqVTyqzvhAJuC64CC7HzxZetsrXhKva+52PQ51+SI+IC/z6p+yAbXAZLaCWhBKR1dOgUKW9ztDgVsBHm1YhXgOCr9HyPlCjDw5Wuf1MhlWQGrbu38XLN/Sd9dNSTDhXeAA4Dk179IUQttLcU9hD/q2BfaeyKNwHE5bjukisYnaNqXgSRnmSvC+8T2CTJ0u5kG38j/YXk3Jx4xMoH5ShSfOPdcrA5xP0FkU6hV3fuS2C8nVlwx6LUZBGihwvta35KhdyhCxUu8/8BUf8qO705qlayDWUDI0e/tKzsaYKZJTxgg/EuZJB
 kceoUaTP
 zA8NrMB4rk51otZXn2y26zeFaA6c6LrG3mA8tizjmiFU7djEOnNnZ9G1Hxh6DUW26pjTQ75UPxgLtGMwOffm6eC+co5IuWTpRDJ7uShVXINaOukcBwkxIZ0mslupF/Qjctq+APJhx5xBNpEufmSJ+cfd15zMvUHbK0DoixBdUE2BRwtQhejIru+V4UMPWfUVrht01dnRX5Kpkt0oIcmt3co5Mr1fV6UKTw2KPtNstM5YcXv8NcS1xcuyQTNIQ7A9iTwSQOfTMEye0qQdkDA0JfEUPQfm6s3K5bhMpoeivrL1ZJYFMvE+yBwyVUVcThst67oTd2oCbmzRIUdSpsnMrOsKjFhG3/iG52DUfvqCMVYoZynFtnKnW5+URtAHM0AVVjp4q
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
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 61a322f945c28f5c3297c506923f00bcce5c7bca..5ef15e39fda8c7c65035fb7ed125b82dfa52ca69 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1172,6 +1172,19 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
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
@@ -5408,15 +5421,7 @@ void mas_destroy(struct ma_state *mas)
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
-		kfree(mas->alloc);
-	mas->alloc = NULL;
+	mas_empty_nodes(mas);
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6504,7 +6509,7 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	struct maple_node *node = mte_to_node(mas->node);
 	struct maple_node *new_node = mte_to_node(new_mas->node);
 	enum maple_type type;
-	unsigned char request, count, i;
+	unsigned char count, i;
 	void __rcu **slots;
 	void __rcu **new_slots;
 	unsigned long val;
@@ -6512,20 +6517,17 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
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
 
@@ -6579,7 +6581,7 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 			/* Only allocate child nodes for non-leaf nodes. */
 			mas_dup_alloc(mas, new_mas, gfp);
 			if (unlikely(mas_is_err(mas)))
-				return;
+				goto empty_mas;
 		} else {
 			/*
 			 * This is the last leaf node and duplication is
@@ -6612,6 +6614,8 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 	/* Make them the same height */
 	new_mas->tree->ma_flags = mas->tree->ma_flags;
 	rcu_assign_pointer(new_mas->tree->ma_root, root);
+empty_mas:
+	mas_empty_nodes(mas);
 }
 
 /**

-- 
2.51.0


