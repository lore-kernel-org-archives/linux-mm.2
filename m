Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A84BFCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145BF8E0039; Thu, 23 Oct 2025 09:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DEA8E0002; Thu, 23 Oct 2025 09:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033B08E0039; Thu, 23 Oct 2025 09:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E10CE8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADD10B652B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:41 +0000 (UTC)
X-FDA: 84029521842.07.F722C2E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 84A592000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YQw5bU+Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I+wC7SNH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="N03/pxcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9wE2UIBD;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBqIeAt8PqOShiWRW8bX5+U1W1IZCUvUQH43Nd+h/zE=;
	b=YX4ItMP99Ktikmai1nUe96Qj3cvcJlcYOsKbKuif1bftTbZdOAsRLTc/mlqVSJcO87xppo
	DbxI+3hGXK00twiy+mH0Dtq9mAOSSDA6IL+oAaXsvsfSIcmHIVamG+FczBi9FAY62289eT
	0UVvoNljIo9B+iKHiBKFUT+lT7upMQQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YQw5bU+Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I+wC7SNH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="N03/pxcX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9wE2UIBD;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227619; a=rsa-sha256;
	cv=none;
	b=gcWnlRACyaWNq66HtiFitIRNhsS2veDK3euk1c5ip9pKTx6FxIMYdU3HfTZTPkf/zHbufI
	pBFSZ6MQDVCQ+430/DeYIVOsX1ppXXlwClJXFoHj5HhXvXObtu5TY59h+FQ/4IX7MGxYTH
	dEHyo7Gu+KjM1AgSdkf2j2R8nTOn0Xw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4D8F211F6;
	Thu, 23 Oct 2025 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBqIeAt8PqOShiWRW8bX5+U1W1IZCUvUQH43Nd+h/zE=;
	b=YQw5bU+ZNX5ArHuJFtj22KbWxbjoaF0CKRjypRfZTCM0XFntJFxSGFmx1CztrJCF2YIi17
	GDqp/T6anLFn5e25sBOES95RxZyscnwk1V6XQuJ4uniGMUrAME67SCyX4sAu2ULT8AuGM4
	7gDKO3+AoYpKmBtprrWfETFmsmLKA8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBqIeAt8PqOShiWRW8bX5+U1W1IZCUvUQH43Nd+h/zE=;
	b=I+wC7SNHC0vPp33Sa3nrdxFGEgcy6EB0zVvmoZ8B398WB3YBKw6YoV2zheE8y3vwnEHsv+
	GVWn+J1+RhkKklBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBqIeAt8PqOShiWRW8bX5+U1W1IZCUvUQH43Nd+h/zE=;
	b=N03/pxcXs0OuyClaX98QPEtfzweWUNNSSj8Y1uRNunwDY2YnplKEe13w6EzcIpcv0Oi/pP
	aQWRuSyqsIyOKVMtM0jW8Ilo6BlCAy1qaJMvyEaF4a4LCRyVGXozxhfq3sNZwIqzZN9R0y
	lJ2b6pBX9s5FMKbjtbOuJysYwYCUW84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBqIeAt8PqOShiWRW8bX5+U1W1IZCUvUQH43Nd+h/zE=;
	b=9wE2UIBDUOLcLk8TyuN1BryTkaGT0OC69IhTaPZulmTPiFRe2/CAmhW3b9dq+KR6clt5XU
	vr8G6DEkrg2M22BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79A9413AEB;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AMNqHTUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:27 +0200
Subject: [PATCH RFC 05/19] slab: add sheaves to most caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-5-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Stat-Signature: kqyppiq6w6kztdtk4oqbafzijzfqj1q4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84A592000B
X-HE-Tag: 1761227619-479387
X-HE-Meta: U2FsdGVkX19AXZaE9O8pryUNKU8oLDsGhehuSSdWExcwBZBuETnVAYiurnj7axZT4UFd6EtpSJaQ4WL9gtthbuW3f6ZEc5j1PuwBlyGmdmncIgc+GSNNn4eREJ/JOx3PJMKxx5e2P1ACwFtcYA8IRu87zJbxY3kzeDPhThjcSgXBQg3EBHyHrDFrbpj0imd8kFk4XAfxitBI1M4qL4hcnsYkYy7M+/rGVIp0XSfVqpiiwOkmka3pjHmhRWdg9uNkfqQiVR+6eBZpUoFgDeCaDO44mib7G3Eh1Z2lEQv/GYmJZWvYQUFOUbBss1b22UBPDV1NN/WKB+gVAktyWTINdUZKZ64YiYnpgipecrY9RzFF2cxkZg4HpwExPp+4oJtBqYXQcHT25fGz765bx1fsv2rajKq5HGTnynd5qMJeedytDJDotqrZrmXTtHSSOTyN6w2molXfvCFs9ldEcetK72ygMqb70jw+s8v9vBgd6yxGfKaYqFYjF+Ufsl+vd7hnzTa72otv/zZPPbS2to8IrtPCFKs8/phCjfVrIN3C4ccb34wYQQdFZZI8KrQV2ZElUGULkrsBpl+TxOGw3APrVYDrySYq7GqZIu0g/99XroWgRtjmz0Xx+iEvwZtL91eo4TIONbCxvt2i/i8YXgkFnEkgdQjCcDutonjeDI+a12FFOF/mFpg/NvhfHJMeeHI4eNWU+3FBaVfooqxHNH3w7GiQGL8/aZEXnpJTGxMP4OejBEh/E+7yZN3iu1Xhachye/+rR6JYMUHMOeQ1SHZg+LmNBPmJk/1H9iaKj/dbpogS183bW9WTbr6Ia3jqA39RbsI3Jel2QLCnagUDz7ORkkucIlGz1SKM/9Hbqw3Zj0e35pujafOVGiN4y/MO9groSdNDLl4F4ZSo+dPWaDS/Me8qHab5ojgNnZK9rEf/vqhuKLhQiOaYj7SLobNnRTSulj1lR2PglHV5lZhB2wb
 k5i6a8Gd
 EQ8O39vNhfNVzrS6R+jNFVQD/HLaUuWlT6x1gjpnhMGR0V9T6mLiAtGowPWhPAx+pa8lt0By+r4ogAHQ+mc22bTIeOlbKl5PUse7yA2lJ737jdKIMwjHceyU43+yp3fmBRG9gjBuYQa6Pg6wb8R0PfNMpNReDmghkav9Zhatky4KULuepclZeF6RQq5E7YzpvIC4mpwmE27qCPo3Aw9g0M2+bcgOJz8PEMS0szuj3tGZBbz8sgNvwcqONDTW7wS5llQQN83392qE3CpyvfbwnJJaz5ZMlb2fOACIb
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

Don't enable sheaves for kmalloc caches yet, as that needs further
changes to bootstraping.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  6 ------
 mm/slub.c            | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cf443f064a66..e42aa6a3d202 100644
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
index f2b2a6180759..a6e58d3708f4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7810,6 +7810,48 @@ static void set_cpu_partial(struct kmem_cache *s)
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
+	/* bootstrap caches can't have sheaves for now */
+	if (s->flags & SLAB_NO_OBJ_EXT)
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
@@ -7944,6 +7986,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	/* kmalloc caches need extra care to support sheaves */
+	if (!is_kmalloc_cache(s))
+		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
+
 	/*
 	 * Determine the number of objects per slab
 	 */
@@ -8562,15 +8608,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
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
2.51.1


