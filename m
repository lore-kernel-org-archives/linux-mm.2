Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE96FD6261A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBA56B0414; Fri, 23 Jan 2026 01:54:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EE76B0416; Fri, 23 Jan 2026 01:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1216B0417; Fri, 23 Jan 2026 01:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F23E6B0414
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:54:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E38DF1A0333
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:03 +0000 (UTC)
X-FDA: 84362313966.27.53B3AB4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8354E40003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIH49ban;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ck+22s2c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIH49ban;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ck+22s2c;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH0Ena7htnUNZ5YqbWqwyKSCHR1cGZCmyIRyJ4sibZE=;
	b=uuyz2ki2HVGjVUzc11tR9Kb0zUQRCe6LOk+cRjDkAbRcP6TKn4tzpTQ0LFJ8xP8wR3jYXs
	o6jqehDIAth7CTtgJ85+EfxTjQBnjHA3NwuzBQ+bjl3rfvOVyos8Pkz4QQVjdnmfg8+Qnl
	XUSV2Fur6jZMxp84elxk52oGLxajn5c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIH49ban;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ck+22s2c;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rIH49ban;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ck+22s2c;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151241; a=rsa-sha256;
	cv=none;
	b=3guCQ76EF+nRzWJsjsqGKBZvNIdICAzSweNWa7yY43XlxjaQilj2cR+Gb5vVQ+Wx0DGUHy
	xBKSJ8FWOMC1PAF3Q1twjQIBpl9+kDOM+GFLyTOOshRlxjzWCbZ83ut9zB8XWrBaVRL+IZ
	cNjkE+Sq1oXwvFA3ZVaK5axsrrSKG4c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 12D975BCD4;
	Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH0Ena7htnUNZ5YqbWqwyKSCHR1cGZCmyIRyJ4sibZE=;
	b=rIH49baniazlKH4x27xo4nyCOPxu27FoAT9c8X9/a+2zMJltEtz21t/Fipg5S0CwnnUeM6
	wiWze2gePRhKIG8Loz17SWtnn5jP82yBuYnEL6l+QHse/PIEMa433CgIWuymw1wUJFwzaN
	GptaoTnBr2dLk/v5sfpw8J6Y1xg+iTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH0Ena7htnUNZ5YqbWqwyKSCHR1cGZCmyIRyJ4sibZE=;
	b=ck+22s2cM8obkO6sPjDi/6dC3byG92C4A2+HJOIOue0sQ5mTlctCDJUS9nvXsYQWY8pG1Z
	0gVn8L8UP+x4c4BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH0Ena7htnUNZ5YqbWqwyKSCHR1cGZCmyIRyJ4sibZE=;
	b=rIH49baniazlKH4x27xo4nyCOPxu27FoAT9c8X9/a+2zMJltEtz21t/Fipg5S0CwnnUeM6
	wiWze2gePRhKIG8Loz17SWtnn5jP82yBuYnEL6l+QHse/PIEMa433CgIWuymw1wUJFwzaN
	GptaoTnBr2dLk/v5sfpw8J6Y1xg+iTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aH0Ena7htnUNZ5YqbWqwyKSCHR1cGZCmyIRyJ4sibZE=;
	b=ck+22s2cM8obkO6sPjDi/6dC3byG92C4A2+HJOIOue0sQ5mTlctCDJUS9nvXsYQWY8pG1Z
	0gVn8L8UP+x4c4BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E19B9139E9;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OJDONtYac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:55 +0100
Subject: [PATCH v4 17/22] slab: remove unused PREEMPT_RT specific macros
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-17-041323d506f7@suse.cz>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8354E40003
X-Stat-Signature: 5sah6mpbts9oata4y1zfsszteenyg9n9
X-Rspam-User: 
X-HE-Tag: 1769151241-927907
X-HE-Meta: U2FsdGVkX19Ile7NwPqs5q4QYNtz2SBzLham9e9L2/fAEhqyO2qUyiNzenlBIFnIrYlyGO7AUol1ZaquerQVNmiNKN4sh+xxVf1oXPjsnofxYsiWQ0y9pt0N+ez7TOz5xk2qhs9kJBhyq28CQlY/LkiaCTvSkM+jQc4dKy8tYnOaNAsJHohA4l4+ntch132i0w6kRqsLi0Riio0ihR0eyfoGUVLa+usWldum6tgFDYHidWNuLQcjs+i2VX9I8Jg3HERzTspxgtbxr12OzX3B6KZqF7r47I4UF6+a+hJDBO+n5wBeJTk7PuaqUy+WRerFENSsoXyBXUieeJTEv2NeGqqAu7Y7uNAyeR2PmlwEmcuxEN4qwc6gl8v5Ix16EWtyV2PovREskmDeNUElYryUS5Ii5MWMCtSGYREoTBcLSnGC8bt1BHDy+0zhYskbfhs5nViL/0j25c24FjJuqLx+mOnC6kCugFHCghlTP62hucOIXBYg7XzCxyWZD+skNO7HajzSSYTOpb6CpS+8kx0hfkRqk4KDibH4PnkMT09wtAiYSTudxJGyCXAsezWL6ljIR7kCdC04cHRAdzerSl0IxZtAfM6IlcCeDUWdiRo+J8jy7CRVd7PFujSLCTqgtpHKeH1xzrGYFAqo4fted2Bonx88zmbE1eEfWLtGJ7N1HYNIvmtlAWiWkeRMR0sDXgxw48XVCA5lNvrKMpJbnJZw44bRCxvogJAP1XvWCqRyE6KGByhxdFLAk7tDBcP1WexemPIVeUdnxXm1djg/qcjisgOK01DSMeFC2NlwusKYueeRYPMjiqDbfog4u2xz6SeQPVKEA30SLxeO1ffH41asnKpS8jc5Z/hbaDwLRFLUea40HK3oRX4sSxtVWW/jlkL3qQmhtgQcSu0uMQgN+vFteFf+dmD5avEZJU5lmbyC1KJl8FM+gJ4WR74Az9NvEj7MN7/SdqOHGQOQzwapj9u
 edBQdZNR
 voaCPwaaB0QHAkyc8q0XNL5vkHbOFulKBesY7zDC8vrImZlTCPUdIHYjvThwHZuG83LN2FlmfzyvbThQE9el9QZsMHzOtVCXP/l3bkqzl4q/clE6EiTy6aY7WbitKzBrFVLuiQMvC405qRb7UnVSSlsMW8KUSmt+8sx+vQeNBcth0tNvnaHfVlWWe+qQwNtH+vg/Ky9e2o7GSrm1/PFX1ecSHPpUzXCsXC9BF+YPdfbZ8/WJctt+YtF94sfjTy6FIh58SqxeYmPsjRwV7eZgk+GB90FVQhrZWPcoW3yQr/e3lfN1APteWctXI3Q==
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

Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8ecd5766635b..1d135baf5e9e 100644
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
@@ -713,7 +691,7 @@ static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *sla
 {
 	bool ret;
 
-	if (USE_LOCKLESS_FAST_PATH())
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lockdep_assert_irqs_disabled();
 
 	if (s->flags & __CMPXCHG_DOUBLE)

-- 
2.52.0


