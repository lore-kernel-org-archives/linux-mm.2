Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D503EC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3113E6B00DC; Wed, 23 Jul 2025 09:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299BE6B00DF; Wed, 23 Jul 2025 09:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1624E6B00E0; Wed, 23 Jul 2025 09:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 025F06B00DC
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC20D16052A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:37 +0000 (UTC)
X-FDA: 83695626714.12.EF7E79D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80E801C0017
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XHGdGzm6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G7h+Bn4B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XHGdGzm6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G7h+Bn4B;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fn4jC0LbpW83Xy3GBIO/Fb5+psgfkoknW+IQl2hd0g=;
	b=bhAoWqzGcTuN+l9SIBRc77c/tyU7r4reKl0iSrHhHbI1Mv5v3IBS5vwphOkDeajLxmbMQM
	9IIVXPsTqduxnjJcLwFs/FnSPgjVEO+OvKbkA8+QefC5cWO+Y2iTULbxsKVkrIBJO9Yprj
	KfQGCuHY357W84DI0sOwtpHgf1nQ9e4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277735; a=rsa-sha256;
	cv=none;
	b=Cy8eZ7JVeUQnRR4n2qKBEqjSLXW3ttVDzrUwABivcvljlHU/HMuZsTiyZAvcaNLDJbYBLa
	o4xW/A9Qr62HKPYhH8wGRnuyNuh9CNSIkuhqOzV2zbDmw4RzyZeNFfgSwnUcAFKA1ACj64
	svY/U/3wjGewLpRRJd0N7IrCu7umyNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XHGdGzm6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G7h+Bn4B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XHGdGzm6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G7h+Bn4B;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 562FF1F792;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fn4jC0LbpW83Xy3GBIO/Fb5+psgfkoknW+IQl2hd0g=;
	b=XHGdGzm6NEY6gd28f42z9hE54zRf3WER4Ee6OsNibRJNSg1JKCmBGAiVHdQ8pyj3o8uMre
	0TycU1VNl5TxazwOmSBMAi0OG7xykllmaUjOO39kxOUMJqYfxgySAG7HuD2Sx8AO63HOFL
	ARRI/NOSv/avAcotFJ5D0d/a78XdV7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fn4jC0LbpW83Xy3GBIO/Fb5+psgfkoknW+IQl2hd0g=;
	b=G7h+Bn4BySgaHS/bv3XrlBjpXz1UUCb5XfINdztjNigaDxC5+MMDEv/iRV5C+y7+b+fkYb
	vHgHz+1gN2P9N6CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fn4jC0LbpW83Xy3GBIO/Fb5+psgfkoknW+IQl2hd0g=;
	b=XHGdGzm6NEY6gd28f42z9hE54zRf3WER4Ee6OsNibRJNSg1JKCmBGAiVHdQ8pyj3o8uMre
	0TycU1VNl5TxazwOmSBMAi0OG7xykllmaUjOO39kxOUMJqYfxgySAG7HuD2Sx8AO63HOFL
	ARRI/NOSv/avAcotFJ5D0d/a78XdV7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fn4jC0LbpW83Xy3GBIO/Fb5+psgfkoknW+IQl2hd0g=;
	b=G7h+Bn4BySgaHS/bv3XrlBjpXz1UUCb5XfINdztjNigaDxC5+MMDEv/iRV5C+y7+b+fkYb
	vHgHz+1gN2P9N6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F59D13AFC;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eJgwDwjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:39 +0200
Subject: [PATCH v5 06/14] tools: Add sheaves support to testing
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-6-b792cd830f5d@suse.cz>
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
X-Rspamd-Queue-Id: 80E801C0017
X-Stat-Signature: 8ik98et3e6b994cqebpn1xkr8rwpze4s
X-Rspam-User: 
X-HE-Tag: 1753277735-549977
X-HE-Meta: U2FsdGVkX19QDN+A56H3Qn7LiEGRj8rTGmAZ2i17BP0tnDt6RjZiiJWxqdgKhv8jFuUeIgOCgso+C9BHTc1Db1ag9H0vMGEGEhbdvSFIapT4l5yCemIciQoFyDaw8Q4eDaJcswLKyVrbHiE0Rm1BMfoMNCi0qQ6rg+7CfH7Kac6yTTS023xmdknUcXoB/1XwQkWzQJTrhR6kpKw/gH9S8dukm+cP1MzsvS6uj77+Uwq1C4K/yKsGOTO7VD4CnqTAlWTKktjMW2ia7cXdtZrFI1uRxMxRjn/1JlugTXWUf6BNtwlPE/ofTGmAaYtB5G8PX5Tc/wgcrh4ho+2tF7//m9baICI6rUShtoeAVxQyq42/JOtgg2EvZMTzI4lZp2evPhCkWc9aMKkK6+0vsh6YpMQpe/6vXAThEDjmXVSFMQUJgfjzi6uOECm6o5kY07xdvjWfF+jkekFyga9qAXNKzQ03SMR5hbhxmG0i3SbAGLEvxbn3oXFcQYcTWm8yg61A1+GDYZc6zFFAqRuQgK9N4bKwseuX/y3DMwYIHfkv8ok/GO+rX16QgsWTZ5gX4asyQWcmzIPpX2AwKv3R8b7qD4f8pR4b++U0HY5vP6IntCzLvRhpe/9ZXylkOadehkQ6l+czO36GRQrD2AGqC06+WVdqmBa2xorQKO949WgfvyTXGhrNt9OD7i4Zsf3ii+E1uQjAPq+Khhkb/aQFn3SOAzSAZ1CVqkYDTgVAYNVOXrFA4uv0KSqeiQL+NICU4EkiKr7cfsSzsYyFa3G0wEPvMKS2wAtTMJJrKtaeR0jTL/mZ/vq3WUjXCemihIeoIUATrdy20N8HqnDOZPrXHtEnttdbWkAsJUpmdpticuO8nPhcsCBjpx3WWDzpFit4Xa4ThANyXBRx9LoZwOQzCroXRIoUy/O8d9KmhLTjHKRtiW6kP5vfkJJ2YbE4vHN5FyfWmfsLZku+YaThGMMRHZp
 RRMbQgS1
 iwudTqm5b2mzcvhfHfI8AKAH+OIGv3e/QeqEDQeBziBwg8kwGGPE/NZmkJVgH1V/M4CCdPxwfXY/OnnItvosSxC0ihv8iftM+ViINFecZCa4WqVXBMlR9g6sb3fyqxw3HQqn8aUvMQ1mFbQ08CwHN0vpH3Rmwvjm8w2pV0xqI31hMZ5snzBSapSg168a+rWhwQC0IpXtdfXOiXiI5hI++uacxnGyopvOpF3i+RnRpZ4XCaf+ReUAiksvFdErcQnfx4c55PM8oS15G+PQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Allocate a sheaf and fill it to the count amount.  Does not fill to the
sheaf limit to detect incorrect allocation requests.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/include/linux/slab.h   | 24 +++++++++++++
 tools/testing/shared/linux.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index d1444e79f2685edb828adbce8b3fbb500c0f8844..1962d7f1abee154e1cda5dba28aef213088dd198 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -23,6 +23,13 @@ enum slab_state {
 	FULL
 };
 
+struct slab_sheaf {
+	struct kmem_cache *cache;
+	unsigned int size;
+	unsigned int capacity;
+	void *objects[];
+};
+
 struct kmem_cache_args {
 	unsigned int align;
 	unsigned int sheaf_capacity;
@@ -80,4 +87,21 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
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
+
 #endif		/* _TOOLS_SLAB_H */
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index f998555a1b2af4a899a468a652b04622df459ed3..e0255f53159bd3a1325d49192283dd6790a5e3b8 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -181,6 +181,12 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 	if (kmalloc_verbose)
 		pr_debug("Bulk alloc %zu\n", size);
 
+	if (cachep->exec_callback) {
+		if (cachep->callback)
+			cachep->callback(cachep->private);
+		cachep->exec_callback = false;
+	}
+
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs >= size) {
 		struct radix_tree_node *node;
@@ -270,6 +276,84 @@ __kmem_cache_create_args(const char *name, unsigned int size,
 	return ret;
 }
 
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+{
+	struct slab_sheaf *sheaf;
+	unsigned int capacity;
+
+	if (size > s->sheaf_capacity)
+		capacity = size;
+	else
+		capacity = s->sheaf_capacity;
+
+	sheaf = malloc(sizeof(*sheaf) + sizeof(void *) * s->sheaf_capacity * capacity);
+	if (!sheaf) {
+		return NULL;
+	}
+
+	memset(sheaf, 0, size);
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
+	if (sheaf->size) {
+		//s->non_kernel += sheaf->size;
+		kmem_cache_free_bulk(s, sheaf->size, &sheaf->objects[0]);
+	}
+	free(sheaf);
+}
+
+void *
+kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf *sheaf)
+{
+	if (sheaf->size == 0) {
+		printf("Nothing left in sheaf!\n");
+		return NULL;
+	}
+
+	return sheaf->objects[--sheaf->size];
+}
+
 /*
  * Test the test infrastructure for kem_cache_alloc/free and bulk counterparts.
  */

-- 
2.50.1


