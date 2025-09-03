Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66195CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFADF8E001A; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F0F8E0024; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9052B8E001A; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 743838E0022
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AD901A065D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:29 +0000 (UTC)
X-FDA: 83847950298.18.CE91D09
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9E9A2A0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lcgO7m+f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vhzc6qP5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lcgO7m+f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vhzc6qP5;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=cMQZSCxanzOUHvKtM/AvmQJdIGJ5BbYWZz7bqFrx/cfP19gCBp6KYcQ0ojEY7T3C2BrEvb
	511A0LKpB0+yj1hy6CdISk/Y8RRL5uxFFde8clwn/IIMYoK4pwk+gKpXSN0u8TOECIHAmG
	r9SvlFiCVIv+7duYUCrT2Nk7TPivd2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904487; a=rsa-sha256;
	cv=none;
	b=8r7gW6+yfa4N0Gs0dGRzhdxnkuRf3GBka/H/IYe0DElvHERo81kYKihNqtUQhoNoKH/QIp
	QViqVi+gJT6rFvGRtKfdDhwsYQlzclReQOLnizG2wuaGzWGMqMllo7YBmAUuRrQCIGz/0F
	ZdSIzEP+F8Imhw0dKwKgvTAA1USgehw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lcgO7m+f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vhzc6qP5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lcgO7m+f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Vhzc6qP5;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8B421F74B;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=lcgO7m+fb5soZLD6tTGdgqUf95yjYRNc7HcSIk2zwh9a7DMfyNwXiS/k0hc0jf4N/WsNer
	fk5yu6yq4BzKVp2UP6c2gbT6OWelwqx6iYGSXHL3RU1Y3cJbf8zormFeJYcw2qz9wgSyI6
	VyiK4b1IORWktlKlbe6Hl5lHsm0wtF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=Vhzc6qP5e9IkNDjeKP79Np6thntUaimCqyf9G1z9LZHScmEe3LuL74PwzIM1tmCnVqqnn6
	iHdh3OliNB4T65Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=lcgO7m+fb5soZLD6tTGdgqUf95yjYRNc7HcSIk2zwh9a7DMfyNwXiS/k0hc0jf4N/WsNer
	fk5yu6yq4BzKVp2UP6c2gbT6OWelwqx6iYGSXHL3RU1Y3cJbf8zormFeJYcw2qz9wgSyI6
	VyiK4b1IORWktlKlbe6Hl5lHsm0wtF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqh/ojynYkYiIA62N7CbXckVi4xdirpy4Yia9XnPMB4=;
	b=Vhzc6qP5e9IkNDjeKP79Np6thntUaimCqyf9G1z9LZHScmEe3LuL74PwzIM1tmCnVqqnn6
	iHdh3OliNB4T65Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 927DA13B09;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GI14I9o7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 15:00:00 +0200
Subject: [PATCH v7 18/21] tools/testing: Add support for prefilled slab
 sheafs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-18-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E9A2A0008
X-Stat-Signature: hhn6aaqom4h6ojaqf4up6mghxxqadqy4
X-HE-Tag: 1756904486-382857
X-HE-Meta: U2FsdGVkX18QJn1bNDYB9XL4+S4Y/exbzQcX3WnpGcxpYB6bhclaFTginZtHrqMJOUC7mAWAEVkWm+LeOVEOyb1qGPqtUBXTMmXmHbKcHxv6W2mhYdUTFu2v8zHegwrBqzmFskpZ4+qRbe770++SFOMFoHAe4weugoIANgihCuPR2Ns6z5wbemHebqmhbokyOCzt2cdVLiCP0OtIwEL83CCPPOcY0vbELAcylUIdni52CZpXobw4GxyQ58gf0ZUjlg8kw0pwEoB6oXy2oFU7bOPG+4tLAgi0FQjSRAOihWz1JuYJ/Co1w9EuHbvcsPcTa08tXOniaLNcOt5Yr+1j+/W5zRHkP/tBvgdfbydXh+euE42OQ5aMUjUfZxTIUW7jGwwyGmsZtE7xkmKCIFm8tmllqONt4ZBms0cJfHwpo8f/yrOxZM1eJVecCP6doCYv8zxNoEddmTzAjXmcYJ2OVJmdPAi4fA0C2n6gNapn/XdIVncs4oyb5lDgnAD1wM+4X+tdYqg/9UEb/tb5YSeelpLlrDB25sERvJHci6Ev2LVa3gG+1z7z4c+OrVNzHtc2mhKy5wK5FjBWsDWkgm6MIVwOAH7NTpNkDVTUTUsjGPGz2Mcq3XloP/xRz/aoc/+W+PsE+VpASCml5FJ3yFdTH+BkqCJnmibNxCO2LmmxuiUg5XKRmomRPnwONIiM0sG9Zu07mVr5L+cnqLpay/0pkhN15KxPypbXAjoo7VZ0+cvAKZfz3DJ1WWXSmFs7hcPuqEnjpvkW6pUTlu/C/L9ujL1PfQpeF6FIu8kd5+QBoYGqaHKRgtSpEX6DY7/+Zh844J0EGeghILlZrONlx7mrrt2ATAnETUQewl9oe0hKkYR5IgRsuZkdvEYdzYuzRky+4yTjewmHZTQgHr581X0vQ7ANT98PfF01JM9ARyslUbrlHzuxEh559Jq3z8+3ykC9xg2AABLt0VVq8rQtyEN
 FMpLxWK2
 eBOzhobQ2qqPck5pO+nwCtcZEsU9scHVEMLHvpMEEV5mzvztzOFJA12Y8FmvMIqugUpYALv46u3laRrE+g25xmFALQfpZNt45PKPq4VQVzYcGwFCfHLri4nh6DqfdLlF+pnw4veoLDEc9hPE55zXPx1KwcFm528FjFDTj7Gm6ArWOHUtthZhKv5ZAKWR+vNKU64UfaZDZ2FJP2a8TQ7kC7WjoHLSZayDOFOKD1fy7A3T71PdcZPTgeS91RxYTFTHNlKVoH5H3yj6v1wA=
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


