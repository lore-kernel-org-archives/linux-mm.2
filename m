Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876F0CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E968E0025; Wed, 10 Sep 2025 04:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FD68E001A; Wed, 10 Sep 2025 04:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17718E0025; Wed, 10 Sep 2025 04:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03E28E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81ABCBB58E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:35 +0000 (UTC)
X-FDA: 83872598670.27.FF39DAC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4BEB5C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MnPJRboF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=esJ5Hvj2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MnPJRboF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=esJ5Hvj2;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=e3X4ZmJi/AIKl/3SmZgDRf7y+vDPcgbfypO4KaA91pMMTHo18/Qb0D7h41Ng8tCthzrDfX
	Xq3xQX6b1u6lPCgRYykLKq0lyzVJsjVRiWZzw5pY1hlAK8JP9sAlKsRO+h3UxkyV/CYmxC
	uapUm3KmJCQ3IzLz5XzQzq3755/U2V4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491353; a=rsa-sha256;
	cv=none;
	b=S6eXLv3u/yKVk4YeTu/rObdkdLn547K2gmVFcCwQC2ynnr8qFBspGY1MA0usu9Vr6ZfjwP
	+t9jnx93a5qUb4EIqz801qWQ2A86MXpz6b784gZiztNYih0gDcOoJrXXwXkU/+h9gSfAyM
	Qdue/tTONQ8TMwdWOn2DZ+Nvc6meKZA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MnPJRboF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=esJ5Hvj2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MnPJRboF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=esJ5Hvj2;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78E7E5CB97;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=MnPJRboFgZMIbt5IKIPfJ6iLTv8kHaJ/WplabiJTV8bqN/ghZC3smI8JFrAxu6K5HJlvVT
	ORVtIah1FGK/csqvSMRCBd9CP1uNxoCbtgLJb7t34guamaJrPAjZ6gw+C0BY6tZYyJ8/QN
	j/R++l4QTRXYqwbfxLgCfT4Z7paEWck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=esJ5Hvj2liQq/UumgoT0wUhi+UkAhJVchiVMkWRwQpaoHKltMer0pkevyzBz5htNbm3uXR
	MszEvC4j57xYb6DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=MnPJRboFgZMIbt5IKIPfJ6iLTv8kHaJ/WplabiJTV8bqN/ghZC3smI8JFrAxu6K5HJlvVT
	ORVtIah1FGK/csqvSMRCBd9CP1uNxoCbtgLJb7t34guamaJrPAjZ6gw+C0BY6tZYyJ8/QN
	j/R++l4QTRXYqwbfxLgCfT4Z7paEWck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=esJ5Hvj2liQq/UumgoT0wUhi+UkAhJVchiVMkWRwQpaoHKltMer0pkevyzBz5htNbm3uXR
	MszEvC4j57xYb6DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 638E713ABF;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IDsFGEMwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:22 +0200
Subject: [PATCH v8 20/23] tools/testing: Add support for prefilled slab
 sheafs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-20-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BEB5C0006
X-Stat-Signature: aybz7af51jndu7zzeddxprqiqhc757ek
X-Rspam-User: 
X-HE-Tag: 1757491353-316050
X-HE-Meta: U2FsdGVkX19/mXOBwla8cnHEBCsRlWGC7tgK5nfl4sDZpz3RqE5h3WDN4GqAIfl93sMubUovVqlh07IMqHdW1fhVw26a/IEeAGPbX462Kt5Jhut+G8b7YYJDoCJC5lBWnKjcp4HlHGT+U+qOfMmdfQZ+oTUfJ7hftNqJ9TwVLiROTpTzRVc1s4CtWSQp8VqaAGZtS4Z161dgpdQZPlhZQwx+blofv01CrJUMfyhYUfi4UULz7dkzuJriPX8sUD9ddzhY/yPRgfQoj2fkaA3+UUFfP8Re80rPktMFfbg/71MypTwnLkJqvMchDnSgp+hNAv/3ShsNEJ9XyPQzuQjUC37XvdgTv94evS4EPwmWwKuiD42lXeyO6mHzPXf4St630yRRkBHqiZKS6Lc1qnpv0cjCZG4VcSsXh7s12DfC2gshubNk/MdAoyyIRD4BMEAYG8AAEp4dIfmCEpW2xOuY8uLi6YkRaoqqYPSeKKSRJ/e0jy8YUGkf087lXEhrPqF8a9HgnFWSHARSKb5NOhotefg6mnWT7W0w+CY/902KsgN0pWY9lxY5s+ijAELibqsUxY6B4ZnnhtHnQoyhhQtxp1ulamn8qQfhDDYRxelfLX0etnYeHW8Rf8Ru2faIecYcIZtXJxCT3qLLK5tOd7V6/eMikDi3fXM6booY4mD+ggn+09wYDDyES2WFu5RgciTqBG6y2WpFK+1VSO0ZaBnAj10an44t6yJ3JGtsORsYwQEHbeuO8Y8yTCfZbw8Q2CganPVaNyzwuffyp5TwLM5oiQw8BpPX+o+75BrWkUMCEeUwZ5z7VXN2+2upm34n8lYLxtbRHLXpSYYXprzZ0gztJP7QG1EaKI8WAWU5cvO1dc0B8/L1+8e/6GUZCFIaJQnWAQnyUJJ/uI24OMPUKZ0BUf92rYvMfOTfttQMUE9+H0Y4kqsP+O053cS32fVJztLx11srq1hbIkEvAybjKUU
 uSzTPEQ/
 7zlu1yTNY+432w/N+aAdYcGxluMZUrPiLRkG5ZtVV7KMwN76JjX401NhXIcEXoC0uzT+jR6xhTpT+DV6MNE1mEMjR1qVO2+pURufE+b5qAWRmH7Uj/bb6/6ZJhuhLhHe52X094s3t60MuLWEsALpSnyry7nrwtO6UEtxuAipYoCwe/vYGGmSfcmm8KZhD8bRwuJfuJuUneM9Wh/ldFVoebDgs5SEu9eN1w7ZMojsi9waOhJED7ycWpUi8Y7FHZ+s1KxVKQJa2WwyvzOU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Add the prefilled sheaf structs to the slab header and the associated
functions to the testing/shared/linux.c file.

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


