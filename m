Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057DFC982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD576B00B5; Fri, 16 Jan 2026 09:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BFD6B00B6; Fri, 16 Jan 2026 09:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554E06B00B7; Fri, 16 Jan 2026 09:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 439466B00B5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD125138F2D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:34 +0000 (UTC)
X-FDA: 84338090508.10.B41D072
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FF99100014
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k9V8NlvM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KtR4ezr7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k9V8NlvM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KtR4ezr7;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkNKfm5uHwOYSqEkkRpaI5Z97WwBojUZ970Bd/6ZMy4=;
	b=Ijx+6HhmwezZYDV+knDO97ZJb44n/wzKkOxAXxTgVwmAVZIW40uO6lIW9Kk46A51iH+1vO
	BS708QM7b5Q08djg0liVRzT5Mvm85juoS6CQlmApWGWXhzRqZ2btT+woiDhvl/sKK3sG9B
	IYtuVxiIRFIQ5EC776B+wPUbAB4xm7o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k9V8NlvM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KtR4ezr7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k9V8NlvM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KtR4ezr7;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574492; a=rsa-sha256;
	cv=none;
	b=0x5FnqLOeVjbUPnSn0fwER9EXFD2tEQ33IdekgZsGfihqqVhSWi+uTS3NV4o40bdHtu4pR
	3goBXLUsJU6rmUvYsVJvf85V/JiczAru87ZOYKNdfXBiGgctkN0EtaaXF1jQJGZwiqoPpb
	x9Pxf+Pt+VRmeUymHI65SN+s89Ss2VQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6908E337D0;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkNKfm5uHwOYSqEkkRpaI5Z97WwBojUZ970Bd/6ZMy4=;
	b=k9V8NlvMwmkOKtd99HUQtxJnd1GfExIKg2jpJ3UIf3KlOqkLIh6lyGhYiRrfwbrxhKWlOt
	Zi6tb5WJoMbx4Pe7Xwx4ddFuS8+UKiUdzhvCZw4EPhiVi2+UfvRHGzCoeTy4kUT6nHJEsy
	vquAdE5YysNJEG7ilTl3YmfwRGJ92r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkNKfm5uHwOYSqEkkRpaI5Z97WwBojUZ970Bd/6ZMy4=;
	b=KtR4ezr7PlgdoC95hBhP/wvIOkgBrL5saiTWjeveq/fK8DVDye6Cr3lwH/fpzXyJ9cqWyZ
	YDDtB1NIiW4oZqCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkNKfm5uHwOYSqEkkRpaI5Z97WwBojUZ970Bd/6ZMy4=;
	b=k9V8NlvMwmkOKtd99HUQtxJnd1GfExIKg2jpJ3UIf3KlOqkLIh6lyGhYiRrfwbrxhKWlOt
	Zi6tb5WJoMbx4Pe7Xwx4ddFuS8+UKiUdzhvCZw4EPhiVi2+UfvRHGzCoeTy4kUT6nHJEsy
	vquAdE5YysNJEG7ilTl3YmfwRGJ92r8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MkNKfm5uHwOYSqEkkRpaI5Z97WwBojUZ970Bd/6ZMy4=;
	b=KtR4ezr7PlgdoC95hBhP/wvIOkgBrL5saiTWjeveq/fK8DVDye6Cr3lwH/fpzXyJ9cqWyZ
	YDDtB1NIiW4oZqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DE2F3EA63;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFrAEuZNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:38 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:36 +0100
Subject: [PATCH v3 16/21] slab: remove unused PREEMPT_RT specific macros
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-16-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
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
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FF99100014
X-Stat-Signature: 7xekirrqrhzx4fnm8wdhe5ken34s1k8q
X-HE-Tag: 1768574492-91690
X-HE-Meta: U2FsdGVkX1/eQcHow4ah/nurww7RJm01IjvrsDYqSyGFD7Bp4dhbW63PiWx4r8wsUFn3XcKJR+pE+jdUdiyBkCvLMK7QBOTz/Tmw/iGsc1iOIpPEyi5NCqowohTMcQ+LjzVM47UxFtzQF+SZ4J/jPKfMSlXZkrpL2CgJn6esHpoSq3odS7x8X2oCF3SvmebmcO4iwpdG9FFaSVU77L95ThNj777es1NOB59a6UrGGgUhisbgKhEwpri/pG73T3Cxk1GFAvB1oGZicStI7bRTkEMlWi4Vp2UBezoJ3DlYg8x3RdkjXWo/o/xFpb8lBbcrRruwxOEPejMAPMqKy9xF/9cIXr3qxQL360CCIZyWHuNTdzLPiOlimtQ0E2iPRWZ5B5NDp3F6etF8ikzJqurpsi2twz+ZGZZYDX3PptCX93433cfKTjO2PrzkqC34deDZWxZfIrgCJv65Nh1GeaupXdKAMdowkhNPgJnu18x6L9LTtmztEZ5AD/zbLDFj8rVRw5+VJx5lTQMFp5V+8gQvH/yuDzvaynYBY9Bgf6LfoJLVBd3/c477zFAZDBhqmq1P5qa09vupEb297wu8k4x8vTg9sHb1m8nY/4gVZyd082E6UjWDEl4WzCDSctpwIHKXvjElOghsBm5vffIVuQ/5Ec9zRcAisAS5uDsuTmmXEDGetgpq3OOGwjN8m0Od5FgCIeK+utZP1YpqmSXpv8VLdEjrvJ822QC4r70jGfbqJpdcJptA7oMB3ASXC7f+73o8QtrmmHFFJU2GlgT9Ugw6tEWx89S1ViU2xVqTOCDjnsE1VhRGFXXDjqQfAUGWu4vni72gbDSkAE2+dvU5mL71y9fXnvUkCPgv9kAybELMl+B7nwn1o41F3X8LuPyWZHud9rmlD2Vh0y+02LEJBsfEuFrN7bNJZboTm0RErMbpmzya+xz9gxlNHVCwqURenZTE+M7opw6ABksZEkiiA7C
 Ud9MZxNv
 /pWVN2tkKxsR7xER3SKnjtx/Hq/PuTHXAr44rZKiO5kshbVViHz6D7QudoQk65zX8tTLy0SBTX6EN/Xhe8BU/HNzOGIwY8m+zlmxDQ+NFVQmyPFhd1a407GC5jGPJti3d9Kn7kf/lpl4lHJ356RrcsFho8o0sDnVNKXnucmtnlSG4T0JaZ0otFe4r3HZsdPx9w+OTJv8vaTr9kqBu6EgFv+T7bZ11JtzjztPC3P55iiPVsJ18Jo2Yu4pIWX56mq9LVzRW2BQ7UlUeIC50OhKM3FmKkQ==
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index bb72cfa2d7ec..d52de6e3c2d5 100644
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
@@ -719,7 +697,7 @@ static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *sla
 {
 	bool ret;
 
-	if (USE_LOCKLESS_FAST_PATH())
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lockdep_assert_irqs_disabled();
 
 	if (s->flags & __CMPXCHG_DOUBLE)

-- 
2.52.0


