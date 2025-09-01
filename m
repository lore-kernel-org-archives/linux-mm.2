Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E395CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B088E003E; Mon,  1 Sep 2025 07:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C098E003B; Mon,  1 Sep 2025 07:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3588E003E; Mon,  1 Sep 2025 07:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B15B8E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 405431D7ACD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:25 +0000 (UTC)
X-FDA: 83840410290.22.0D8C4ED
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id F319EC0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fOSewe5A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BWOLqaNY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fOSewe5A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BWOLqaNY;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htQ+/TA5SKDWSG5dnn2v4RIOWxXiBF6DNi9KcdkVFvU=;
	b=rNfH8jSVH1HEQzEXCs81MbABaizE06u9JWPz99wg4JjOy8ZdvYAiZFG4WcjM5nwpFWMiwe
	GnW1Fr7J6FfKYBHPc1FJ5vDvXmL2GOpBNGDNwH+spQZmMMMoaQrFXFSnqLIZjSDMS9AwpQ
	vDvIPXgZTLVJG9VooiqDKexU8ZTNvao=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fOSewe5A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BWOLqaNY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fOSewe5A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BWOLqaNY;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724963; a=rsa-sha256;
	cv=none;
	b=DlmnPyAyE9VYifdQopila1HR1qfoy9YRkTcUu9i70YEYBFl3CeOQHpB/tmu7egDNy6jfY9
	776I4ZjLnvOptHAOtfbhJC5UzQ6oPXOFDCOrAOtMnuMY5P9LKADGlR05DO9/fGiBTHa5G7
	tNK1SGCXnMY45yU8XUyWQS3r2rAQHGk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D641F1F38C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htQ+/TA5SKDWSG5dnn2v4RIOWxXiBF6DNi9KcdkVFvU=;
	b=fOSewe5ApnD56gxuszMv1ZxWgYnHilfM5JvSQ57oZnziFZrZC2Cr0kGjzNbx4C598jb+RO
	XMazmhNa9fZfCpKrq1LNP2fKaPjv7tpHfZXZIVp00ITgoAZcbCJ19V2nnvgrEutWSGkkq1
	jb91GDUJlRoXd8ZBSEj6G1wlJjqtPB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htQ+/TA5SKDWSG5dnn2v4RIOWxXiBF6DNi9KcdkVFvU=;
	b=BWOLqaNYD0gV3me+lqMPb2sV/a5rtUVLASqnMxiAvcHVsCv4HPe7F/brqal5/xn99eBSa0
	usVtg+TSxavBBBCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htQ+/TA5SKDWSG5dnn2v4RIOWxXiBF6DNi9KcdkVFvU=;
	b=fOSewe5ApnD56gxuszMv1ZxWgYnHilfM5JvSQ57oZnziFZrZC2Cr0kGjzNbx4C598jb+RO
	XMazmhNa9fZfCpKrq1LNP2fKaPjv7tpHfZXZIVp00ITgoAZcbCJ19V2nnvgrEutWSGkkq1
	jb91GDUJlRoXd8ZBSEj6G1wlJjqtPB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=htQ+/TA5SKDWSG5dnn2v4RIOWxXiBF6DNi9KcdkVFvU=;
	b=BWOLqaNYD0gV3me+lqMPb2sV/a5rtUVLASqnMxiAvcHVsCv4HPe7F/brqal5/xn99eBSa0
	usVtg+TSxavBBBCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFA781378C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPGFLsV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:59 +0200
Subject: [PATCH 09/12] tools: Add sheaf to slab testing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-9-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F319EC0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x17677xiud3a4ifi947p5351ejp6f4i4
X-HE-Tag: 1756724962-179303
X-HE-Meta: U2FsdGVkX19zTDnt63McR2bL5VwpKISxzCg230STH4QMcvtdgpI8W210zbUOIYANtO53Tsal114RTXbxDN+YuGoJ+XEZHvePHo7DMFh4P32xrClzq7KUaEi6bfKCs8dsmN65RzfLgYnd4pexm9PitB/SPNl1/ECXXrpGBZjAL/+iAaAWPn5LSAF+i/Mkg1+KLwRnkOF+GrTkkLyet/l4HBXzfqQl0xZc6Pz0qOgUI8MqYLDf72e6R4EdyvgK6T/roKVnMTGm687RmduIyCu6QWKB2F5ds/pYGFzYvURdU7kVSn7glBwhzJA5hTkSd3kBCMReQQte1GkO2bW9pWwjNFUTNMEAmR+Tn2+wZQwbKIgLOxcbg9WbkNe7bLzlMQrQxgW0Hm+QGq8ofEu5QG+K14FwO0Ir3X/8+kqNAhWgQEC7JdVjcEjTxI4M7B0EoM0T2jI64rYDm+O8JM7TSNPU5OnL6YDcD2ew+HWuHJt/6HyvFewbR7wa00nh4nLHP4PMaGl/miswnQdWnI2JD1uv/IwbwnCIFkXcMn2CBLjEtIZT9C9/CR6F9mG6kvmURq3KOFmi5EyPIWzXzOLVU2SQYasrpoYNl6t6b39bvMpesUhl4+Tzr5mYEkN5O6yBIU8mPDseunL12vkL3nQCtoXH6MLRcuoMDXidcUdYfXXVnDrngD7TZb5tJ4bY+4Nz3BgWNKa1FQnHKu3nqVrwXm4kqk3Q/8ERzoGe5AbLMigMYjvS69UW1B1J8Z6KYw0Cm9IecBYM/4hBfJ2c6bAjHbhn09/K3SGdavNjbxCc/1sqSt3QFf/Izv9kykIZEBswpysr9sERx+4UOtTFYoltzxKrfFSjRgkn54jj5Xt0hRqwddHMIkPUzDseMbSNVPav941vWXM3HA1ztSTgE1mxdYMXt9cBsZEuTbZSnh0ktbJoMt9TdChEKmGZC+D+F/fhiYtKvvc/5mADTLBItEILAfa
 6p30crJ7
 qtTKhDFPBTSa47DPK+jMHzpOP9o7GzHx7OI4/mowVOLHkiwE69itUOpUC24fU7VlmbsmdwH3uGi5GZh8R5kLiGGkqLfRvk5MhKW5v9xcP5OCxh1II0JLa/svhjjvjNpWpNdpjLn/+4d4DZAX7u3U8Ujg2AeUxYhiZcrvgZWRTv8YKY2HsR41LhDe1wuzAbi1GWHJzFystzAw5oFWVObd8kw6G2l4u9NHmullLTkLY9bByuxGagWjhbpgIkZXpISZxrPJWEIXbEjDtNovH2ImFqjbxYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Add the sheaf structs to the slab header and the functions to the
testing/shared/linux.c file.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h   | 28 ++++++++++++++
 tools/testing/shared/linux.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index c5c5cc6db5668be2cc94c29065ccfa7ca7b4bb08..94937a699402bd1f31887dfb52b6fd0a3c986f43 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -123,6 +123,18 @@ struct kmem_cache_args {
 	void (*ctor)(void *);
 };
 
+struct slab_sheaf {
+	union {
+		struct list_head barn_list;
+		/* only used for prefilled sheafs */
+		unsigned int capacity;
+	};
+	struct kmem_cache *cache;
+	unsigned int size;
+	int node; /* only used for rcu_sheaf */
+	void *objects[];
+};
+
 static inline void *kzalloc(size_t size, gfp_t gfp)
 {
 	return kmalloc(size, gfp | __GFP_ZERO);
@@ -173,5 +185,21 @@ __kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
 int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			  void **list);
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
+
+void *
+kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf *sheaf);
+
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf *sheaf);
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf **sheafp, unsigned int size);
+
+static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
+{
+	return sheaf->size;
+}
 
 #endif		/* _TOOLS_SLAB_H */
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 97b8412ccbb6d222604c7b397c53c65618d8d51b..4ceff7969b78cf8e33cd1e021c68bc9f8a02a7a1 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -137,6 +137,12 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list)
 	if (kmalloc_verbose)
 		pr_debug("Bulk free %p[0-%zu]\n", list, size - 1);
 
+	if (cachep->exec_callback) {
+		if (cachep->callback)
+			cachep->callback(cachep->private);
+		cachep->exec_callback = false;
+	}
+
 	pthread_mutex_lock(&cachep->lock);
 	for (int i = 0; i < size; i++)
 		kmem_cache_free_locked(cachep, list[i]);
@@ -242,6 +248,89 @@ __kmem_cache_create_args(const char *name, unsigned int size,
 	return ret;
 }
 
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+{
+	struct slab_sheaf *sheaf;
+	unsigned int capacity;
+
+	if (s->exec_callback) {
+		if (s->callback)
+			s->callback(s->private);
+		s->exec_callback = false;
+	}
+
+	capacity = max(size, s->sheaf_capacity);
+
+	sheaf = calloc(1, sizeof(*sheaf) + sizeof(void *) * capacity);
+	if (!sheaf)
+		return NULL;
+
+	sheaf->cache = s;
+	sheaf->capacity = capacity;
+	sheaf->size = kmem_cache_alloc_bulk(s, gfp, size, sheaf->objects);
+	if (!sheaf->size) {
+		free(sheaf);
+		return NULL;
+	}
+
+	return sheaf;
+}
+
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+		 struct slab_sheaf **sheafp, unsigned int size)
+{
+	struct slab_sheaf *sheaf = *sheafp;
+	int refill;
+
+	if (sheaf->size >= size)
+		return 0;
+
+	if (size > sheaf->capacity) {
+		sheaf = kmem_cache_prefill_sheaf(s, gfp, size);
+		if (!sheaf)
+			return -ENOMEM;
+
+		kmem_cache_return_sheaf(s, gfp, *sheafp);
+		*sheafp = sheaf;
+		return 0;
+	}
+
+	refill = kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
+				       &sheaf->objects[sheaf->size]);
+	if (!refill)
+		return -ENOMEM;
+
+	sheaf->size += refill;
+	return 0;
+}
+
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+		 struct slab_sheaf *sheaf)
+{
+	if (sheaf->size)
+		kmem_cache_free_bulk(s, sheaf->size, &sheaf->objects[0]);
+
+	free(sheaf);
+}
+
+void *
+kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf *sheaf)
+{
+	void *obj;
+
+	if (sheaf->size == 0) {
+		printf("Nothing left in sheaf!\n");
+		return NULL;
+	}
+
+	obj = sheaf->objects[--sheaf->size];
+	sheaf->objects[sheaf->size] = NULL;
+
+	return obj;
+}
+
 /*
  * Test the test infrastructure for kem_cache_alloc/free and bulk counterparts.
  */

-- 
2.51.0


