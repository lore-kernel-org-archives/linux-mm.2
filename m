Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76DCCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6F68E0033; Thu, 23 Oct 2025 09:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0321F8E0002; Thu, 23 Oct 2025 09:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63198E0033; Thu, 23 Oct 2025 09:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEEB68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B7A5C0AB1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:23 +0000 (UTC)
X-FDA: 84029521086.15.3013A19
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 715D21C0015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sTZx0sLtvJo4J0O41JGYb8/wviWvNFZ0we7krvm2Y4s=;
	b=hogI5tNGMbJURJgh4F4mBwpvxk6GiPuqkRSFDVw0BHXQ+4NGvfliu0imSw9JJTxyV2KG2P
	HMtXK8QgsFa+AjfVlwtt8+h5MTIyn9IRECywHmZobvCRXh8eqPlSTdNNHEkTJZf7zZ+qMr
	F7T1cIIxYTDGSgBXF+1otWe7m1QyrMc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227601; a=rsa-sha256;
	cv=none;
	b=Rhl/iMXZUC8UVudKgtp7lPITiXrWsRHz/VMkd8kpe38jrxwpdLsQj+pwzIQvZfJLrBhXcP
	iIC9udmpiuquefZ3xJ6aS3ocvB/KMm+G6bchru4F1pkBU5lGOkpacbCbOAqnKS4t0l+EAD
	3Ki6kqRBNztMLVkjw1jh7QIlAZasNDM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE58721250;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A73C713B0E;
	Thu, 23 Oct 2025 13:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WHqMKDYz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:38 +0200
Subject: [PATCH RFC 16/19] slab: remove unused PREEMPT_RT specific macros
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-16-6ffa2c9941c0@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 715D21C0015
X-Stat-Signature: tddtqfu75fwstfrdsq6ci8e411mx8e35
X-Rspam-User: 
X-HE-Tag: 1761227601-479745
X-HE-Meta: U2FsdGVkX1+G6NHtImY7MkHMqe/Yl8GkU2BL1ngmHWocSLIMgSZbNUttRQi6B9Wysd7qr3Fc7DhZzKMnJ0vIPjzmY+y3WkxUtbD5yoeZ8j/iGsQ9j39JOadelLXf8+SsQ84kABeJQ7b8xiyrqO9Xw66AhwfjNdLe+ZZbxSgQNsJeGumMMAkj1ua/ZZ8kYnXu+23TYa6ldwFk7K1EwLGIdwQ/mxHPHqqQuLMSxNwjqW7xIlEW+7eWsCgzwAI+FWvysAFLQ8QHHuVWSCP7V/b/OTbwzBWJG5qVobx9m/yTNaAsUgu2kmphKs2xp41fzjENWCFwrz2fR12kAd10PLoOTt3tqAmOPLqpAvq+BDBDZ4xNLWnrm4uKC0da5r7qO2/2w5mlRWa9cAz8lXNlOy892eTCyQzXH0tbcqWqGAjHrgsCv+pf8m6AlzUCUg2WQFGPKaNGqghxWV0BR964kN52mw5j0hENKoAjG2uc7djUOff8HzPHQCyc0XWBESB2KNknHS3ikTbCTBV+CuX/0xnKFF13ddkDpBPoZoVaSdhUchfyoReO/HGLgr5867KTEHC9XP4FRsBJqKyw7ER16af9OsAo/Aj8CAbJVcBlDsA615wgTx67YX+/MCfAqES3EaVZtEyhEyt1ZZr4S/EUzMQkT3kflKMfkWIHA6Fi5ETKrxifrcmcPE7FKjWFJFoynfW6G+02XL9/8W6ominjy14LjBe+GdpvH3n1qD049W8wkWGD9pQksc77KlgZChaPNSFfYjbbady5D0hZGBuylb1yKRcHXpJbp9okbJS08B1QbC0QFxyy9TyYI7ICUeuwk/hPMOCI+RmF2kWeaI/ymA09K6Cv9HkU3BOf4oag1oqVO6avhNpxOdGhWm/nlYL117SJ1smaJiZRbluBhafxn6NeEkwVNPOCPSLqfgISfvH0b7Wto205lSVKBvdkewMOt95obHKIIk1keXhyHUYJrzP
 wT7ilrHb
 OcYo1Sq8bUwNMHmVcnzdwgXrP9Azem22u9/5ju3E/EI4AAKqMn3xzYBErmMq86EMlCdNsCRWi4eAKaHZ9JBkJCxg9QkYJ1VyfPqmcTZ81U8Ui01PekHln718dcIC8k4o9z/Z4xHEHDH9ZJrvvUo1aGRcoMClgvSfTz1TgHW65Hc9n0z8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The macros slub_get_cpu_ptr()/slub_put_cpu_ptr() are now unused, remove
them. USE_LOCKLESS_FAST_PATH() has lost its true meaning with the code
being removed. The only remaining usage is in fact testing whether we
can assert irqs disabled, because spin_lock_irqsave() only does that on
!RT. Test for CONFIG_PREEMPT_RT instead.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index dcf28fc3a112..d55afa9b277f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -201,28 +201,6 @@ enum slab_flags {
 	SL_pfmemalloc = PG_active,	/* Historical reasons for this bit */
 };
 
-/*
- * We could simply use migrate_disable()/enable() but as long as it's a
- * function call even on !PREEMPT_RT, use inline preempt_disable() there.
- */
-#ifndef CONFIG_PREEMPT_RT
-#define slub_get_cpu_ptr(var)		get_cpu_ptr(var)
-#define slub_put_cpu_ptr(var)		put_cpu_ptr(var)
-#define USE_LOCKLESS_FAST_PATH()	(true)
-#else
-#define slub_get_cpu_ptr(var)		\
-({					\
-	migrate_disable();		\
-	this_cpu_ptr(var);		\
-})
-#define slub_put_cpu_ptr(var)		\
-do {					\
-	(void)(var);			\
-	migrate_enable();		\
-} while (0)
-#define USE_LOCKLESS_FAST_PATH()	(false)
-#endif
-
 #ifndef CONFIG_SLUB_TINY
 #define __fastpath_inline __always_inline
 #else
@@ -715,7 +693,7 @@ static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *sla
 {
 	bool ret;
 
-	if (USE_LOCKLESS_FAST_PATH())
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lockdep_assert_irqs_disabled();
 
 	if (s->flags & __CMPXCHG_DOUBLE) {

-- 
2.51.1


