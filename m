Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770CECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01FD8E0024; Wed, 10 Sep 2025 04:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2CF8E001A; Wed, 10 Sep 2025 04:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A988E0024; Wed, 10 Sep 2025 04:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A633F8E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D3CBBB565
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:29 +0000 (UTC)
X-FDA: 83872598418.30.6D633DF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42017140011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bG8byubO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FRqvZn76;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bG8byubO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FRqvZn76;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1197+hnB0r2rFuPElGqqXMK0u+WFyH+bVUAY0R1B8I=;
	b=rDLX3rOc1xcg+njk6MELdI1B4eSnJAB7GyiUq0tbykwB85W6EaWrUpWYNr+OJJE7+f07np
	Atg4J+1or8djndyoR9gFvCmYjU0sxB5xJDdYW6yzQjua1W0HBpP95HT2MfHgkKQZwkQPL7
	N7A8Wz3dcuQdy2XuXyk0ILyqjw0ya6E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bG8byubO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FRqvZn76;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bG8byubO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FRqvZn76;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491347; a=rsa-sha256;
	cv=none;
	b=5maygwZPzjRrhIUIrx7cwqGyId+YO4ZZ0djnGl9xvqaQImZHMgiUwGJYori/fvPKeMJaHi
	3D8Mq5U/vx5TCcug3e5ay0AnvtfpB33zybs2v/3ZsPAc5opWAF1JL8YMTW3vtaoMzS6nKx
	Jz1Alzs5cquDUiGmt6rZGh5xCkMk2o0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A30545CC0C;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1197+hnB0r2rFuPElGqqXMK0u+WFyH+bVUAY0R1B8I=;
	b=bG8byubOhLuFcRvQJ/p+M0Y2OV50g4nsGXfM8gfrJ0cPb0YCeaCHCfnTJRTX0itVNWk9uo
	mC9Dyy6Q3QiT2EQTB5SLttSap4J03aQo9rSc/ri6xVnc7mA8TQ7s1NurKh1r7sRigx0te1
	Jwx55wHfLrwjOGNwONXQYOQHnmUFadc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1197+hnB0r2rFuPElGqqXMK0u+WFyH+bVUAY0R1B8I=;
	b=FRqvZn76AmAanqTnKsjGlWhQU0riFgfbSy1PQwkbso/YR3aWuZCSzf9qHdHZWDEZNpZAvO
	8YLupf3mRiYc5hAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1197+hnB0r2rFuPElGqqXMK0u+WFyH+bVUAY0R1B8I=;
	b=bG8byubOhLuFcRvQJ/p+M0Y2OV50g4nsGXfM8gfrJ0cPb0YCeaCHCfnTJRTX0itVNWk9uo
	mC9Dyy6Q3QiT2EQTB5SLttSap4J03aQo9rSc/ri6xVnc7mA8TQ7s1NurKh1r7sRigx0te1
	Jwx55wHfLrwjOGNwONXQYOQHnmUFadc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1197+hnB0r2rFuPElGqqXMK0u+WFyH+bVUAY0R1B8I=;
	b=FRqvZn76AmAanqTnKsjGlWhQU0riFgfbSy1PQwkbso/YR3aWuZCSzf9qHdHZWDEZNpZAvO
	8YLupf3mRiYc5hAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C86213ABD;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2KgMIkMwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:24 +0200
Subject: [PATCH v8 22/23] maple_tree: Add single node allocation support to
 maple state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-22-ca3099d8352c@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42017140011
X-Stat-Signature: imi13a9nseomoykciqhecs9zntz5rik5
X-HE-Tag: 1757491347-697304
X-HE-Meta: U2FsdGVkX1/pGPelHAws0ORxWHm9fS2kMCsERv4UszSRbKhzxbWaDLTwhoP7o1f8Rmyo5tBOOIeVTWHtU/JU3rB5+SiKdv7JfVu4HJPnCYWqSgnsTyBgWUKyItfOxN3T7Ez0XcZMdGz8q8Ud6roNBcAN6LZqzyMSEYz2rZwkZrdC2s0LSJJ2EJ+wggyKHQzv3UCVFWHtA23QsNKILS3rkYF9Kxq1WrP74WgnzNKrIautr59qLKrdly4u6FogzHY44kMjFJpdliKirw1QwkQX9Cppawk02iqt0UTSiGp09vx8/2P5SZwFbMfEeFBZDlrPLUQhRFpoBbtPxYDlWRBHUK+778sZMuob/YVmVvdopSp1rDJm5CkK8R2T+MYBf+S+ZWrq0tkbdHa/rqDI65LP3JdLD6VX3X7qShCE22e1/ZE6MPKQTO0/JuNXTxiVwl58R8sk+n4VkRCkpDOw+K02GLMRKkSUDfkQ+jZ01MgOTO2fmY8fDNhoyMaMx6KeJAsygnvhMt9dwzahl+WvAn/HXfRVifnLRxtwEwlw1FzmEWoNgTgJwwqwRA4GOwHlRaPipwYlWF3pobIQdnXXtIJRfzyxYo/ix+/aqe7i5NmwzbiLcW6g+2V78zodQ3yx+oXak0+b9sUeCN8PILkLop5y2z0JGpaUBc9C8sHRI5COwZh7wVIBzPVBT0ot/2FaNPanG5kZoYAZOEqSaUsOWcQppQJPSsgh2ETW5qtOgnxziUJkQ9a3lUGxQz/0C7wd5+liLo9S6k8gEFRBMKMhhFRyqGhlQkpKB7BGFrL/2iQkDqcdgo1Jvy83C+5uLd669+wAGclM2epi+qpy2cZNl5JcQxTI/Saj6VNpgAnzOn41TNfg1xUlLUeMXWwRz0Bm0tQOGVMA+qYpbNcn+NBeoAwiodcK2q1qdRvq6B/l9zDGdU1KcNwKinxvkXIPbA+b2QVlhg9pS9TNoxzYl4wKJGp
 9FiDEc1v
 JXsHGFJ0UZibVOxHTo5u77UP4BLmobxb2ulCEI3JpyrUETaGhN+QpTdNzpYMEBzE4lZ9T5k4C+ROkOArRNxjoIsqU9DvCfaVGbpliRChpIeMt4NQzmiNcNNXoZaQZ1uNvIlKXp8YC0R4uE7TZcFNDEGwmXxES7yeTkuA3WWOoRaGTj6MPul/MhRbwmCmX+J4j+tb60Q7NldjiPmuNLb0I/9LGuNIe7PWP2Si/ZxLOe8HHHFRetqNe1NODAhTP36YtYz/PIzbaRQOqD/bZf7WZqPec/f5rfjKG06x12ThL9jvn17UYfcP7rVAHY6+BMer5ORu9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The fast path through a write will require replacing a single node in
the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
special case the node store operation by just allocating one node in the
maple state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/maple_tree.h       |  4 +++-
 lib/maple_tree.c                 | 47 +++++++++++++++++++++++++++++++++++-----
 tools/testing/radix-tree/maple.c |  9 ++++++--
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 166fd67e00d882b1e6de1f80c1b590bba7497cd3..562a1e9e5132b5b1fa8f8402a7cadd8abb65e323 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -443,6 +443,7 @@ struct ma_state {
 	unsigned long min;		/* The minimum index of this node - implied pivot min */
 	unsigned long max;		/* The maximum index of this node - implied pivot max */
 	struct slab_sheaf *sheaf;	/* Allocated nodes for this operation */
+	struct maple_node *alloc;	/* allocated nodes */
 	unsigned long node_request;
 	enum maple_status status;	/* The status of the state (active, start, none, etc) */
 	unsigned char depth;		/* depth of tree descent during write */
@@ -491,8 +492,9 @@ struct ma_wr_state {
 		.status = ma_start,					\
 		.min = 0,						\
 		.max = ULONG_MAX,					\
-		.node_request= 0,					\
 		.sheaf = NULL,						\
+		.alloc = NULL,						\
+		.node_request= 0,					\
 		.mas_flags = 0,						\
 		.store_type = wr_invalid,				\
 	}
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a3fcb20227e506ed209554cc8c041a53f7ef4903..a912e6a1d4378e72b967027b60f8f564476ad14e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1073,16 +1073,23 @@ static int mas_ascend(struct ma_state *mas)
  *
  * Return: A pointer to a maple node.
  */
-static inline struct maple_node *mas_pop_node(struct ma_state *mas)
+static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
 {
 	struct maple_node *ret;
 
+	if (mas->alloc) {
+		ret = mas->alloc;
+		mas->alloc = NULL;
+		goto out;
+	}
+
 	if (WARN_ON_ONCE(!mas->sheaf))
 		return NULL;
 
 	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
-	memset(ret, 0, sizeof(*ret));
 
+out:
+	memset(ret, 0, sizeof(*ret));
 	return ret;
 }
 
@@ -1093,9 +1100,34 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
  */
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
-	if (unlikely(mas->sheaf)) {
-		unsigned long refill = mas->node_request;
+	if (!mas->node_request)
+		return;
+
+	if (mas->node_request == 1) {
+		if (mas->sheaf)
+			goto use_sheaf;
+
+		if (mas->alloc)
+			return;
 
+		mas->alloc = mt_alloc_one(gfp);
+		if (!mas->alloc)
+			goto error;
+
+		mas->node_request = 0;
+		return;
+	}
+
+use_sheaf:
+	if (unlikely(mas->alloc)) {
+		kfree(mas->alloc);
+		mas->alloc = NULL;
+	}
+
+	if (mas->sheaf) {
+		unsigned long refill;
+
+		refill = mas->node_request;
 		if(kmem_cache_sheaf_size(mas->sheaf) >= refill) {
 			mas->node_request = 0;
 			return;
@@ -5180,8 +5212,11 @@ void mas_destroy(struct ma_state *mas)
 	mas->node_request = 0;
 	if (mas->sheaf)
 		mt_return_sheaf(mas->sheaf);
-
 	mas->sheaf = NULL;
+
+	if (mas->alloc)
+		kfree(mas->alloc);
+	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -5816,7 +5851,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
-	if (!mas->sheaf)
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas->status = ma_start;
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 72a8fe8e832a4150c6567b711768eba6a3fa6768..83260f2efb1990b71093e456950069c24d75560e 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35085,10 +35085,15 @@ static unsigned char get_vacant_height(struct ma_wr_state *wr_mas, void *entry)
 
 static int mas_allocated(struct ma_state *mas)
 {
+	int total = 0;
+
+	if (mas->alloc)
+		total++;
+
 	if (mas->sheaf)
-		return kmem_cache_sheaf_size(mas->sheaf);
+		total += kmem_cache_sheaf_size(mas->sheaf);
 
-	return 0;
+	return total;
 }
 /* Preallocation testing */
 static noinline void __init check_prealloc(struct maple_tree *mt)

-- 
2.51.0


