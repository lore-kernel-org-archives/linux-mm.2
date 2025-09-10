Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B260CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DFC8E0005; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17838E0001; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D8A8E0002; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80FC28E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49E251607E9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:11 +0000 (UTC)
X-FDA: 83872595142.18.77735F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id C4F7A1C000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQa9N9h4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=moQxoCb3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dG7K8GH3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/zfZsb78";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3hjvzuOHMY42JWL8uS2aEHNxgCiX/TRsdBUhNeMoUs=;
	b=lCbsILTVoCgXVVBcSIqePeeUCi0fuuLWuMK2DBYYm6bazHDYWg8PjmCotYYOEb1KqDIrcA
	ZETxI3gPrbMF6SWsWKJ3nNT6cIP23xIGgQvlNx0zjONdfMLWEnYy4p+3TAu4h1Bhc2tLHY
	B/5BB5O+OB+Za9VgbQYmZVR/zYiWphs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CQa9N9h4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=moQxoCb3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dG7K8GH3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/zfZsb78";
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491269; a=rsa-sha256;
	cv=none;
	b=JhX1lVA+gAwckdTtmWujCOyWaavHm9Po0ZpucrpejqWkb7ALvTJsCrnTHi27bNSd7Nzp0A
	M4xBSmfMPqCmho0L2NTjV7pUWwmaNwbCiwAzY13ITwluWBzeCYCj9B+sqcOOzakmo8D7Kp
	UpC6NYDEPsd3w0s9+NFPl0t5xUWAyL0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CB47D5CA23;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3hjvzuOHMY42JWL8uS2aEHNxgCiX/TRsdBUhNeMoUs=;
	b=CQa9N9h4pDfX7nw/M+ubbl2raVQSIqyo9KLUKwBWyZ0tRfR5LSRwNV7ZlPozcAaF7IBRQv
	6Lb9YB2LVS7iw+NMa4nAUq69h1/MHapt4uTBe3U3v7fFNB2ulRRRdlY6QRmU4PulCkLpz4
	KuJWoio8RMV3lxDFAR/2zDIktVmkxC4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3hjvzuOHMY42JWL8uS2aEHNxgCiX/TRsdBUhNeMoUs=;
	b=moQxoCb30JS8lAp5uRVMgaLiLhdUOFhJ1SFaUEBI7EZJXZeKpN/k1d6Z812kRPkPDzcv36
	gMkCRc2PyiVAWOCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3hjvzuOHMY42JWL8uS2aEHNxgCiX/TRsdBUhNeMoUs=;
	b=dG7K8GH3wiohlmESb7yD9RKVBcv1OWZ40MD2XilJUpPWvEVpWuXtx/BgVJfDOLzzpGAeWa
	2JkUzKinBaQkv4fTqmgWLI1JvHAQcHQ/ajispnZRa8hZbAviiFlU62SDQ0je6of64eMot8
	JalcQjJhmEeqGVEDu0yHwu53aO1l2qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3hjvzuOHMY42JWL8uS2aEHNxgCiX/TRsdBUhNeMoUs=;
	b=/zfZsb78FvwKmW/C8Hqh2i72dMdU5YfyxbCqUY9iAjCg/h1+tbxNj3q6n4RJdg7vQEx9n2
	se7HWI2yCbgfzfAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B087013A54;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNDQKkEwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:05 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:03 +0200
Subject: [PATCH v8 01/23] locking/local_lock: Expose dep_map in
 local_trylock_t.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-1-ca3099d8352c@suse.cz>
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
 Alexei Starovoitov <ast@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C4F7A1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 55o8mkhbjegxnkabpqcniosr8tr3st8y
X-HE-Tag: 1757491268-934618
X-HE-Meta: U2FsdGVkX19RwcrK56cZkT4nK1IyZdPJIrL/jWDs/ag1tLuP/Jv23indmKMFoHMs0LQGj/wY/eRPyKMaWNsAiKiczEXPherVIisPhw7Bq9ZNOR5aWGaRL5kskQQZEtHBgf0eXhCm+FM2Rf8ly8m9gsKCJmJMdZ7AiVfsnuFBe+jU48/cDyqgMyERaSAg1Ei8hCIrPOpXyxb7nlJgLY3/v4CK/b4+tp4bYlswZazwArfBYQvzWsj7gRUWRzPAFmlI/DqmKH8LrRNEX0ajeVtxv+lERbVNJn1cs4PdOYrOuXnBPhkhQ3fRDBuSyP4Axn25AnQPvB2JXx0XOgI3kO6unrrgktvBOD/U8EnC5YeO9rOOaHCAUdYO7xy/Qc9rdvZA6FV+Yjce5Caw1wjlgO4mXdZDGF2lgBKWWzNlaJgHypKwTfd33m2mM5CbhyIjM9MG4SZSWTpOvA613tpyFlrYA6SltqvMV2fJ6/UBMNXXyf2ap5W/WU9T6sWnBAQEbpszCyq+ZnI+71TRHD4809Z4wsXzqutCSTuleqGgCYXjh3qLwzwGzgHFMeTmzbUBzR2sDZS2k/fMQmxdKvMTrUYxBzgSSURnR2PG50vak9qLHEb5gxrwAdD8tCuxUUKF7UYT0vB7Sjz9kbrJXdtbm+/kkzzaT9EqRwYI3gXZV/DXY1/itwty87Gp8KQAxuadVfCTIiqcaTOYtu7zmh0rupq8HilI+noO/ztJfUnULkgcOBez7tfBPSF9tMRV3Wi+vCnpzNZ9+S94Oji5frO61JAmZZoYu/qecmDcCODclA5o60KO1YDYPvrTD2If9MQGupcmxWJ8W7QaNqE6PBDbC8jJEBs96lEw/MZnMf8avzdw0Gy4EUXPVumFY0GQ+olFBDRPhG+7b6fDwEiWZPIG4q1VYx4u66zgvld7XmvVeNA29VQysEsf1/p/CTETAgvNFepwGsvExiAM+Vr6CjqKfm3
 4QpyWoVl
 tTXM4T5aEDdNKAitFVCMti3nsw2F53b5M0sUA6vtGD2FLjGGonnO6lpkRYVz26MO7Y5gzSp0QueXascAtiAa29TDXeYYc+YjANLyzg35StX2VagcBZip9OSrmC1zjwu/GPftF8Pi08sLBiOhZ7yYjtk6b6mEjVrtP7nPRVYUemOYkc7bhWA8hxcpfR7Zf0Bb2k+h0ycwgAbGzmvEf26+MBEJL6BoYbFeo2mz6eVtCo3n090AR8z4TCt40nZHtx/Ny1vPpXqJkYNwPVJg5KIfFO1ZR87qgdDjFVSyeFvl/kcDxjjpk+CtVkWwa3WV1c8dfBDwKb6JX/aGXnJ/pEkTIiEIw681oU3+tIMsCPgTQhEp2GOcer8f/52nbrY6WCBeDRLCh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

lockdep_is_held() macro assumes that "struct lockdep_map dep_map;"
is a top level field of any lock that participates in LOCKDEP.
Make it so for local_trylock_t.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/local_lock_internal.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index d80b5306a2c0ccf95a3405b6b947b5f1f9a3bd38..949de37700dbc10feafc06d0b52382cf2e00c694 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -17,7 +17,10 @@ typedef struct {
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
 typedef struct {
-	local_lock_t	llock;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+	struct task_struct	*owner;
+#endif
 	u8		acquired;
 } local_trylock_t;
 
@@ -31,7 +34,7 @@ typedef struct {
 	.owner = NULL,
 
 # define LOCAL_TRYLOCK_DEBUG_INIT(lockname)		\
-	.llock = { LOCAL_LOCK_DEBUG_INIT((lockname).llock) },
+	LOCAL_LOCK_DEBUG_INIT(lockname)
 
 static inline void local_lock_acquire(local_lock_t *l)
 {
@@ -81,7 +84,7 @@ do {								\
 	local_lock_debug_init(lock);				\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init(lock.llock)
+#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\

-- 
2.51.0


