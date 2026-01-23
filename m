Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34DDD62602
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5FC6B03F8; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4E16B03FA; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2EB6B03FB; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5660C6B03F8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0296D160363
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:20 +0000 (UTC)
X-FDA: 84362312202.26.04BB6F9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id C931F1C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gi3T+Xls;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q9pnIhD8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gi3T+Xls;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q9pnIhD8;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEKVD7jaQE+LDv05PIHRGwJ26LSVOziITzWTXSPhpJk=;
	b=QFIa+B5oe9EjTBUj45+4BE/vkD1pMj+BRCmzOTbvg//CbuMNhBkimJftJj9ZEijDz23Xua
	xKpTBWIsuCNQ0E1xQ0a9Y0ag0PAkXz4iBI10M/qn+xk6f1oaBP8BOVauLnrGWGyYF84Jst
	zqzWB0Q4+URklCVpTWVMUgKWVqETj5c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gi3T+Xls;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q9pnIhD8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gi3T+Xls;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q9pnIhD8;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151199; a=rsa-sha256;
	cv=none;
	b=Ow0q7bzHd5O9EKA3Midq1FG04E1ej7Udi50AowA+2XE9MfV1FYSLlsMEZRNzHh0aU7xIxO
	oWHyfZOk5O0/Zd1EjEj73k1Dt07mwtcjn3oCQ7pe8SALMTtQIAsVWbxMuRTlZCTtfPtpRb
	lnXD0atE9fzSyR+DRAQb+XCkgxczkhs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9EAF33376A;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEKVD7jaQE+LDv05PIHRGwJ26LSVOziITzWTXSPhpJk=;
	b=Gi3T+XlsDlqP0QQ71QXovXJrIlfjBGQeRqSBfbyQFpBKtEpHW5IgZGdCchVZs6aKCnB0TX
	JSei/5QvWeNHR1Rmv6rtBGVw6+Gk4QjAHZBNJHDaao9btn6eVFPC686TxQWfTeWou9isfh
	Ow8hOUG5opux48LL58BvidGqcCy+cDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEKVD7jaQE+LDv05PIHRGwJ26LSVOziITzWTXSPhpJk=;
	b=Q9pnIhD8MFvOie+v6Hqk7CLnQQHVeGsOmf7qdQlSNz504NBYXUHG1V0G9PhcDnxT9qPr2x
	YMLYiDqFZWzBygDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEKVD7jaQE+LDv05PIHRGwJ26LSVOziITzWTXSPhpJk=;
	b=Gi3T+XlsDlqP0QQ71QXovXJrIlfjBGQeRqSBfbyQFpBKtEpHW5IgZGdCchVZs6aKCnB0TX
	JSei/5QvWeNHR1Rmv6rtBGVw6+Gk4QjAHZBNJHDaao9btn6eVFPC686TxQWfTeWou9isfh
	Ow8hOUG5opux48LL58BvidGqcCy+cDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEKVD7jaQE+LDv05PIHRGwJ26LSVOziITzWTXSPhpJk=;
	b=Q9pnIhD8MFvOie+v6Hqk7CLnQQHVeGsOmf7qdQlSNz504NBYXUHG1V0G9PhcDnxT9qPr2x
	YMLYiDqFZWzBygDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1514139ED;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0DYFK9Uac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:44 +0100
Subject: [PATCH v4 06/22] slab: add sheaves to most caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C931F1C0002
X-Stat-Signature: zjmdt7phs1n59egw9ttp11pi3jzt94rb
X-Rspam-User: 
X-HE-Tag: 1769151198-466048
X-HE-Meta: U2FsdGVkX1/e47eBqN7EyphyqA1043ZA37W6w+u4Ipe9OMGS89JblBoVf+s6WZYXl/Hsza8/QaDx1dEqjG/Om5aPAIOacGXOarITNXcZmhU9p+Nwvzv3FSJWZzAZtp5pr/2oW9qN1viKVe+m00/wBLY4cH72PphjRd0GchBZc+Wi4ta6zxw4VrmwwfQwbaLlzqK1aKtYJZoN8bI4AqyDuA1gJvH2J2/+PInMBAf6xysw75v9KQ98W1I1jXXpK8pYm1zR94bEz+8oxHMYAor54qNdN8Y9dAz0HtzkQZssEfAOJsNjPWk93OcOnO5zE1WI6jRloa6aw1PvYekGB7GjNUbI0oK9hN4cRl75QA1sepyNzoFq2nRCkSlXO65wcGRjcqb+qlwIqabvaOOKcXy88nFLFSk5pdNWAmjxaqSKcOzhNIMIpSA9fRUaoewxbEPDxCdI9ELiV73Q+pgWkfpab27Hv5Q2Fr89501kzUPeo0rgbJyDUn7RzIDzdxnFZSXD6ww+lxkfA67Hx9iwaFhkaNfHt52z8C5J+CBifYUs36OxJ0N91BWwPAdJASodw2p9v5XKf81ltsXkzsfnO+pIBdtiusmkJ2lXj5Km0D6G2LQy30Ob+q4Hrm+ovgn4r7h9Q6XcWIlPdyIxCfoqDa20zEurzX/CVZPiibvqgt4KrgsEx2Iz9BryjIHnoWOcXlciMiqV+Dd9/Q+QzYoJtT064pkd6F/0mkZWi/6+Gol6b9Ti0gihvqPw7fQ1HxJhD1Fvrm9ckZ3hrtDKWDI5zTVOARxxu+xcRmAJnCn9Q0vmIapTmTFXFC+SG6D5xtJqybiwJkh925L8uP0rHDkPEwJ5owwx+7Ofeb7xikaOa/LFUk285SSr/2MvIjBhAG8OA58wbPWlO5YkR0V9AQMfoaKXnW6vQkvmVKcHH+EadnkLMIW763SPIbjXqaW/+EXl8oHKLgsXSAIbtWEPIeC2hMi
 +6qglxVt
 fi8U8hfXxa/0q9ZpVvOTjZ6DH5K9eMfRe1MPZ5BiMcM7U5rDNf6cCDh3VB5uIg6oZRbyCCEDfsbjAomhPubzuMrtHgFirf4nNZp/mcOoWP7fLptxY4IGm8lzaDkGR4pRO1MotnlfyLY21EVDogMeNJqj/Alt/8WWg8dWty/y7ZK6NtDcDRrxCmBcCxFdiQXeQ35W0bTG4m/kD+D9xPKrenWXibrFw/6A8fL/KYH0+pqzbpEymTliRyh71f4IgEHqUinT36bgxWmEmcr9tF4C4xTfsKCAqD9KtVTFAFVOzLFWJ2cU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the first step to replace cpu (partial) slabs with sheaves, enable
sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
and calculate sheaf capacity with a formula that roughly follows the
formula for number of objects in cpu partial slabs in set_cpu_partial().

This should achieve roughly similar contention on the barn spin lock as
there's currently for node list_lock without sheaves, to make
benchmarking results comparable. It can be further tuned later.

Don't enable sheaves for bootstrap caches as that wouldn't work. In
order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
even for !CONFIG_SLAB_OBJ_EXT.

This limitation will be lifted for kmalloc caches after the necessary
bootstrapping changes.

Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
recursion with kmemleak tracking (thanks to Breno Leitao).

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  6 ------
 mm/slub.c            | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2482992248dc..2682ee57ec90 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -57,9 +57,7 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
-#ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
-#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -238,11 +236,7 @@ enum _slab_flag_bits {
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /* Slab created using create_boot_cache */
-#ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
-#else
-#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
-#endif
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
diff --git a/mm/slub.c b/mm/slub.c
index 9d86c0505dcd..594f5fac39b3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7880,6 +7880,53 @@ static void set_cpu_partial(struct kmem_cache *s)
 #endif
 }
 
+static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
+					     struct kmem_cache_args *args)
+
+{
+	unsigned int capacity;
+	size_t size;
+
+
+	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
+		return 0;
+
+	/*
+	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
+	 * have sheaves to avoid recursion when sheaf allocation triggers
+	 * kmemleak tracking.
+	 */
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return 0;
+
+	/*
+	 * For now we use roughly similar formula (divided by two as there are
+	 * two percpu sheaves) as what was used for percpu partial slabs, which
+	 * should result in similar lock contention (barn or list_lock)
+	 */
+	if (s->size >= PAGE_SIZE)
+		capacity = 4;
+	else if (s->size >= 1024)
+		capacity = 12;
+	else if (s->size >= 256)
+		capacity = 26;
+	else
+		capacity = 60;
+
+	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
+	size = struct_size_t(struct slab_sheaf, objects, capacity);
+	size = kmalloc_size_roundup(size);
+	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
+
+	/*
+	 * Respect an explicit request for capacity that's typically motivated by
+	 * expected maximum size of kmem_cache_prefill_sheaf() to not end up
+	 * using low-performance oversize sheaves
+	 */
+	return max(capacity, args->sheaf_capacity);
+}
+
 /*
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
@@ -8014,6 +8061,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	/* kmalloc caches need extra care to support sheaves */
+	if (!is_kmalloc_cache(s))
+		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
+
 	/*
 	 * Determine the number of objects per slab
 	 */
@@ -8618,15 +8669,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
 	set_cpu_partial(s);
 
-	if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
-					&& !(s->flags & SLAB_DEBUG_FLAGS)) {
+	if (s->sheaf_capacity) {
 		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
 		if (!s->cpu_sheaves) {
 			err = -ENOMEM;
 			goto out;
 		}
-		// TODO: increase capacity to grow slab_sheaf up to next kmalloc size?
-		s->sheaf_capacity = args->sheaf_capacity;
 	}
 
 #ifdef CONFIG_NUMA

-- 
2.52.0


