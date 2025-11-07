Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4A0CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46A18E000F; Fri,  7 Nov 2025 08:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7F58E000D; Fri,  7 Nov 2025 08:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBEDE8E000F; Fri,  7 Nov 2025 08:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B667E8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:52:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C6C513B176
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:52:08 +0000 (UTC)
X-FDA: 84083949936.06.C74BD6A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4462CA0007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:52:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DZNvXY9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJP9ZOW+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DZNvXY9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJP9ZOW+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523526; a=rsa-sha256;
	cv=none;
	b=ZkDNH3ZIg7SFXIVglcE5KUiTgqrhPY5kd7G8sa631g9WxMqL0A+qFmlEQqb/5Y/kFqxs9E
	rl/nzsn1jMEdmzZT9XapeAZzo6TdktVw5dFMqzdzkr6R7QqbJGym92SGwa3bOIyj+4KS2p
	Edn7Ugw7vRRdSxo89Zz5JpzHo6LpJC0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DZNvXY9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJP9ZOW+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DZNvXY9Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XJP9ZOW+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lbjp9eBdivzL6P8LhBfaJka806WwCcsNNUIAdQf/UyI=;
	b=jGOvFupvt4RQnY3VKFyDAv1gQ2Dyj4feErt6W2aDitzizqhIgQy5ZrVBMUlL/bK1n5cC4Y
	Ii7+UTaTIKMyZM8XXnfAyG4uYm3gGJfU5cx637Ox/v9e8zUPr6K8kyxOfPSJqGdHcojL9T
	yvco9f0VsfpyRTvVoMYbRSSxob7VhC8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF08A1F461;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbjp9eBdivzL6P8LhBfaJka806WwCcsNNUIAdQf/UyI=;
	b=DZNvXY9Y5Cevgwr5I91ouI7W/s/MxZbXP47IXlE4UjiYOYdRSlRE1YWxmZagun2nQqh7IR
	Szu4FwLkhjMCz+IjYVZPQskmg7DTl9BN01feerW2us4n6UlLWRnQKnxgIaDhs91AZHGQcj
	xqWgOCjPJfqVc2VGPrQQ+qd+kFS8eQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbjp9eBdivzL6P8LhBfaJka806WwCcsNNUIAdQf/UyI=;
	b=XJP9ZOW+umo9kwWSM++dRKu32L8N+xdF/kBMG28busVSzwXF+bFkYhd5BPtNlqnjqDG8w4
	Cr/QFzMCa3zh6GBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbjp9eBdivzL6P8LhBfaJka806WwCcsNNUIAdQf/UyI=;
	b=DZNvXY9Y5Cevgwr5I91ouI7W/s/MxZbXP47IXlE4UjiYOYdRSlRE1YWxmZagun2nQqh7IR
	Szu4FwLkhjMCz+IjYVZPQskmg7DTl9BN01feerW2us4n6UlLWRnQKnxgIaDhs91AZHGQcj
	xqWgOCjPJfqVc2VGPrQQ+qd+kFS8eQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbjp9eBdivzL6P8LhBfaJka806WwCcsNNUIAdQf/UyI=;
	b=XJP9ZOW+umo9kwWSM++dRKu32L8N+xdF/kBMG28busVSzwXF+bFkYhd5BPtNlqnjqDG8w4
	Cr/QFzMCa3zh6GBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABD0913C01;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2G+nKXL5DWlFCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 13:51:46 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 07 Nov 2025 14:51:26 +0100
Subject: [PATCH 4/4] slab: use struct freelist_counters as parameters in
 relevant functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-slab-fms-cleanup-v1-4-650b1491ac9e@suse.cz>
References: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
In-Reply-To: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 4462CA0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 5xkwuck97jq3x36ti6o1s1xdff9yme31
X-Rspam-User: 
X-HE-Tag: 1762523526-959014
X-HE-Meta: U2FsdGVkX1/QPY4J9GoIYVMseOWgmx585B5dMqMGSc8VLnYHse8VGUW8bk7UpAo/J7qGOe7ZnznMhYvxG9KR2GJ3ECUgcyFdEwJmbSj8X4/cWCU9GVjM7KYWqx1gyxWT6e1UcIoioDWFAOZeLMysmTxHH+CESLMAEkQhjEVNpgJDyJbKj4ejCf4za7YziWPuZYIWhv44nFIHm2pTeolbSWfCAXkU3yf4Eo43jIKjGTKgrAMnZ4qJMOR6Ff6IrkFa7Q7pdy8fLvtF2Ur5bN5ssnwyXXe+yEwtdOZJ55egVdgi+Z8i+Us8pMpnb0zPxt41CBkNK/50sFlK/G5dWIViYwAF5WGFCAYQwc0sTIGDd/YjJ24wqZp6UDfg3jPwOnJ/GG4w/wHPdiMGUruqltOK4e1hU2AG6Q+SN2OgctPFzMOQa4SoFnuZTgE/0ZLWC7lDMSGV3UqUbYnAoTOqA9ZzbtklAeVMmYVqfxLaMSXon+9q36BxyJyiq0L6Jt7qHRLq7Nscx4LcC3Dnz8jW9YwAvqaovug51sqGQP8HN+QmLk8n+zgZu/mjNil2e6cd7i1Jr/Ulk1RuViHiJuOFPFu4R67InWPG1KdMvs5ABVmsbww6bHCM1CZvoD21kGm72iBhnzLly0F4IglfgJQdaJZ7HgCP3FC3YaXnrX7dciOmtBT7qKIKCsMRHRysmdNsUWV4HVbQb/JpUmk0VTJc0XCEpIpD5zOAbs+DkplsfE1CYn5OM7EehMdxp3UMetWU101d8E+uZa/I7q+3B425VadJfJ9u58BqyRwBY90JEvgqMiLYAMZIsR0eiGUkHiD+aZc3kdHgyw7ODjjAZ/0nakQzth1HAXRSfcER3raSUelUCvmp0w3iPaDtUlrOFxQHizN8NPY2jCBDgg3GUwU2UIC6riscTekAYVEwTZzRO2ktfvD+HXnSfX3JQycoUSP2UPx4LouCM8XosQgrjR7Y8Wc
 lBtLyEUo
 wQzIhoLnepVh6oxDs6Fg/vxhg9TE/wUD+uUBl6/2vQYwXGhBOuOIO1YAb2IBiC6amxpl7SdJv/H/KcLD4rjql+4gQO75UQKR8d4oG7p7+UoK44aOhY3OVfy4CCO92B+XTbyKvui7nktBipaVDjl3sQsCuQy0LpjfIMBe98Ly/IVbI8NblRGcKWQAknQeWO539KkBI8s4qI6M9h3vV1tgbo28UVWFhFiDev3cANlKKUp3ODw0YEQwdC7NQVaTepLbMs+7K0X/HPjA0jNUiiKyFr20SmIa9AKOtDll42K8Y3lkRbgQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In functions such as [__]slab_update_freelist() and
__slab_update_freelist_fast/slow() we pass old and new freelist and
counters as 4 separate parameters. The underlying
__update_freelist_fast() then constructs struct freelist_counters
variables for passing the full freelist+counter combinations to cmpxchg
double.

In most cases we actually start with struct freelist_counters variables,
but then pass the individual fields, only to construct new struct
freelist_counters variables. While it's all inlined and thus should be
efficient, we can simplify this code.

Thus replace the 4 parameters for individual fields with two
freelist_aba_t pointers wherever applicable. __update_freelist_fast()
can then pass them directly to try_cmpxchg_freelist().

The code is also more obvious as the pattern becomes unified such that
we set up "old" and "new" struct freelist_counters variables upfront as
we fully need them to be, and simply call [__]slab_update_freelist() on
them.  Previously some of the "new" values would be hidden as one of the
many parameters and thus make it harder to figure out what the code
does.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 126 ++++++++++++++++++++++++++------------------------------------
 1 file changed, 52 insertions(+), 74 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a55e0af26ec7..ddd71f4937fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -759,34 +759,29 @@ static __always_inline void slab_unlock(struct slab *slab)
 }
 
 static inline bool
-__update_freelist_fast(struct slab *slab,
-		      void *freelist_old, unsigned long counters_old,
-		      void *freelist_new, unsigned long counters_new)
+__update_freelist_fast(struct slab *slab, struct freelist_counters *old,
+		       struct freelist_counters *new)
 {
 #ifdef system_has_freelist_aba
-	struct freelist_counters old = { .freelist = freelist_old, .counters = counters_old };
-	struct freelist_counters new = { .freelist = freelist_new, .counters = counters_new };
-
 	return try_cmpxchg_freelist(&slab->freelist_counters,
-				    &old.freelist_counters,
-				    new.freelist_counters);
+				    &old->freelist_counters,
+				    new->freelist_counters);
 #else
 	return false;
 #endif
 }
 
 static inline bool
-__update_freelist_slow(struct slab *slab,
-		      void *freelist_old, unsigned long counters_old,
-		      void *freelist_new, unsigned long counters_new)
+__update_freelist_slow(struct slab *slab, struct freelist_counters *old,
+		       struct freelist_counters *new)
 {
 	bool ret = false;
 
 	slab_lock(slab);
-	if (slab->freelist == freelist_old &&
-	    slab->counters == counters_old) {
-		slab->freelist = freelist_new;
-		slab->counters = counters_new;
+	if (slab->freelist == old->freelist &&
+	    slab->counters == old->counters) {
+		slab->freelist = new->freelist;
+		slab->counters = new->counters;
 		ret = true;
 	}
 	slab_unlock(slab);
@@ -802,22 +797,18 @@ __update_freelist_slow(struct slab *slab,
  * interrupt the operation.
  */
 static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *slab,
-		void *freelist_old, unsigned long counters_old,
-		void *freelist_new, unsigned long counters_new,
-		const char *n)
+		struct freelist_counters *old, struct freelist_counters *new, const char *n)
 {
 	bool ret;
 
 	if (USE_LOCKLESS_FAST_PATH())
 		lockdep_assert_irqs_disabled();
 
-	if (s->flags & __CMPXCHG_DOUBLE) {
-		ret = __update_freelist_fast(slab, freelist_old, counters_old,
-				            freelist_new, counters_new);
-	} else {
-		ret = __update_freelist_slow(slab, freelist_old, counters_old,
-				            freelist_new, counters_new);
-	}
+	if (s->flags & __CMPXCHG_DOUBLE)
+		ret = __update_freelist_fast(slab, old, new);
+	else
+		ret = __update_freelist_slow(slab, old, new);
+
 	if (likely(ret))
 		return true;
 
@@ -832,21 +823,17 @@ static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *sla
 }
 
 static inline bool slab_update_freelist(struct kmem_cache *s, struct slab *slab,
-		void *freelist_old, unsigned long counters_old,
-		void *freelist_new, unsigned long counters_new,
-		const char *n)
+		struct freelist_counters *old, struct freelist_counters *new, const char *n)
 {
 	bool ret;
 
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		ret = __update_freelist_fast(slab, freelist_old, counters_old,
-				            freelist_new, counters_new);
+		ret = __update_freelist_fast(slab, old, new);
 	} else {
 		unsigned long flags;
 
 		local_irq_save(flags);
-		ret = __update_freelist_slow(slab, freelist_old, counters_old,
-				            freelist_new, counters_new);
+		ret = __update_freelist_slow(slab, old, new);
 		local_irq_restore(flags);
 	}
 	if (likely(ret))
@@ -3774,10 +3761,7 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 		} else {
 			new.freelist = old.freelist;
 		}
-	} while (!slab_update_freelist(s, slab,
-		old.freelist, old.counters,
-		new.freelist, new.counters,
-		"unfreezing slab"));
+	} while (!slab_update_freelist(s, slab, &old, &new, "unfreezing slab"));
 
 	/*
 	 * Stage three: Manipulate the slab list based on the updated state.
@@ -4389,27 +4373,24 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
  */
 static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 {
-	struct freelist_counters new;
-	unsigned long counters;
-	void *freelist;
+	struct freelist_counters old, new;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
 
 	do {
-		freelist = slab->freelist;
-		counters = slab->counters;
+		old.freelist = slab->freelist;
+		old.counters = slab->counters;
 
-		new.counters = counters;
+		new.freelist = NULL;
+		new.counters = old.counters;
 
-		new.inuse = slab->objects;
-		new.frozen = freelist != NULL;
+		new.inuse = old.objects;
+		new.frozen = old.freelist != NULL;
 
-	} while (!__slab_update_freelist(s, slab,
-		freelist, counters,
-		NULL, new.counters,
-		"get_freelist"));
 
-	return freelist;
+	} while (!__slab_update_freelist(s, slab, &old, &new, "get_freelist"));
+
+	return old.freelist;
 }
 
 /*
@@ -4417,26 +4398,22 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
  */
 static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
 {
-	struct freelist_counters new;
-	unsigned long counters;
-	void *freelist;
+	struct freelist_counters old, new;
 
 	do {
-		freelist = slab->freelist;
-		counters = slab->counters;
+		old.freelist = slab->freelist;
+		old.counters = slab->counters;
 
-		new.counters = counters;
+		new.freelist = NULL;
+		new.counters = old.counters;
 		VM_BUG_ON(new.frozen);
 
-		new.inuse = slab->objects;
+		new.inuse = old.objects;
 		new.frozen = 1;
 
-	} while (!slab_update_freelist(s, slab,
-		freelist, counters,
-		NULL, new.counters,
-		"freeze_slab"));
+	} while (!slab_update_freelist(s, slab, &old, &new, "freeze_slab"));
 
-	return freelist;
+	return old.freelist;
 }
 
 /*
@@ -5864,10 +5841,8 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	void *old_head;
 	bool was_frozen, was_full;
-	struct freelist_counters new;
-	unsigned long counters;
+	struct freelist_counters old, new;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
 	bool on_node_partial;
@@ -5891,13 +5866,19 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			spin_unlock_irqrestore(&n->list_lock, flags);
 			n = NULL;
 		}
-		old_head = slab->freelist;
-		counters = slab->counters;
-		set_freepointer(s, tail, old_head);
-		new.counters = counters;
-		was_frozen = !!new.frozen;
-		was_full = (old_head == NULL);
+
+		old.freelist = slab->freelist;
+		old.counters = slab->counters;
+
+		was_full = (old.freelist == NULL);
+		was_frozen = old.frozen;
+
+		set_freepointer(s, tail, old.freelist);
+
+		new.freelist = head;
+		new.counters = old.counters;
 		new.inuse -= cnt;
+
 		/*
 		 * Might need to be taken off (due to becoming empty) or added
 		 * to (due to not being full anymore) the partial list.
@@ -5926,10 +5907,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			}
 		}
 
-	} while (!slab_update_freelist(s, slab,
-		old_head, counters,
-		head, new.counters,
-		"__slab_free"));
+	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
 
 	if (likely(!n)) {
 

-- 
2.51.1


