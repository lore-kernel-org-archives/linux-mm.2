Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B275EC9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AB66B00A0; Mon, 12 Jan 2026 10:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F386B00B8; Mon, 12 Jan 2026 10:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAE56B00B9; Mon, 12 Jan 2026 10:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0D456B00B8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86557C1E6A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:43 +0000 (UTC)
X-FDA: 84323666406.27.582E664
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43AD9100005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BvgqrFK6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2onRvAUg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BvgqrFK6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2onRvAUg;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231061; a=rsa-sha256;
	cv=none;
	b=ansqWARE2obtOFnG+0b3DRcI4eAckmuBRAzvSvGJ9Hr4tMjAH4pFVe99JMgADMvXGU2Rw2
	sJPo6Z83dATe5LnTCK+wzB7PH670FJehSNwHcpgdP06smKggBI5tQyjOnSVyQKg620HF6L
	/5r0pgQ7IDgo/mKx2iZZxsUJecmR4+M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BvgqrFK6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2onRvAUg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BvgqrFK6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2onRvAUg;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RB7Ucfc9JWHOv3Ic49uJAd7t2evzS3bLNSohJ8k5FrU=;
	b=pLKP4U++eGZ3Ctm/IQTc2X0H99KfLUgy8QPYaNoQnAm73dMl50ctX++WWAnYS/a2sxEogT
	pnxb/7dRHWkWMxNEl3Wf1KE0i+oLizVHJsHVdXXW7HdETwsB6qDNVLyMp06yAr6wKNL7Rl
	n+Un2FfqBBd3JH+hEf2m+5xdLmXC8VE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21F445BCD6;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RB7Ucfc9JWHOv3Ic49uJAd7t2evzS3bLNSohJ8k5FrU=;
	b=BvgqrFK6RSsctp64rqXBA5QKXaSaRG8axt+WNbXiwvd86K8nXjSq4a/SPZFERkXxGjwiES
	IrNNrTzV4rMndNFRnp/B4dSXPpeYz/JlUH8eihOFqtGa3yDot1o070/QwT7Gsi9bVrXaSX
	u82ZVmcJqCsoJxZsEVHRKijdst52mmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RB7Ucfc9JWHOv3Ic49uJAd7t2evzS3bLNSohJ8k5FrU=;
	b=2onRvAUgGSD3e9VQUBirgxa+FqZ8Nac4XjMLimcX8BX3D1i2/trFoLIhL3vTP1BpidsASJ
	8IVH2NRJN+zJHCCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RB7Ucfc9JWHOv3Ic49uJAd7t2evzS3bLNSohJ8k5FrU=;
	b=BvgqrFK6RSsctp64rqXBA5QKXaSaRG8axt+WNbXiwvd86K8nXjSq4a/SPZFERkXxGjwiES
	IrNNrTzV4rMndNFRnp/B4dSXPpeYz/JlUH8eihOFqtGa3yDot1o070/QwT7Gsi9bVrXaSX
	u82ZVmcJqCsoJxZsEVHRKijdst52mmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RB7Ucfc9JWHOv3Ic49uJAd7t2evzS3bLNSohJ8k5FrU=;
	b=2onRvAUgGSD3e9VQUBirgxa+FqZ8Nac4XjMLimcX8BX3D1i2/trFoLIhL3vTP1BpidsASJ
	8IVH2NRJN+zJHCCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05AB23EA63;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +GoZAWsQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:59 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:17:09 +0100
Subject: [PATCH RFC v2 15/20] slab: remove unused PREEMPT_RT specific
 macros
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-15-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43AD9100005
X-Stat-Signature: nzehu54gbatjso7zhkqpkrud15fg8thx
X-Rspam-User: 
X-HE-Tag: 1768231061-161350
X-HE-Meta: U2FsdGVkX1/S6mBE1EUPIRQMjbmRzdX6WbDn1He/1d7P9nfAtqo0e0uVoTjXNhD/26s99Mp0tpg8+9FqjBjB2qenSuN+ssLZirLJHs+XOcpyS8brQAXDOM9Z8DbaSkNsH5OWbLTu7oxfh6UOS3+cel2T6WEJIkqOoXrHhZI5cs77wYLUd9pxJmgA+PlTJzIjvS7ZRMXvnd0wuGTDfdNP3lUr0gnK2b9seGLq6354edbN7m8dq4loYKZGIgq5wjN04rOGzPp0/DTYr/K753zYlr06/NgU8BQKKbkUqPKXEJD+M1OwC/q14iXVi2Mr7V2JM8qHwmFs2+nnyG/glSB94gL8YV1fEdRCjopT8+lZHYhPiETPtpvJcmF6fVur/TJsu3sV8SZ2Q3Eseab+x/MHsT0MUtFF3MK2rFlthgDGQTTL+t0ntueV5Bi3JCMBrqrHF5B6lLj9Swa7Ib5zOdvl6DRVvdlQdeNJTgGLGVVPbUlVi+YWnumaScCj57aa0HUQybHOyqiBVh9kMnPVGQLMVv965VwuFapa/u3PbR/1PpU28/dFBv2yG/8qWhdz2LVwkOR91MhfFzs1oBX9Eul1dfH1cd8642L3RnEFsyaL/7fO8zb1FulAaJZVbh+K9xyPoa0ZGwz/5NkZtcULL26D+o2RwahaqkL37Z6wE9ojqAc1rr1LdZHrbykfB/jIn7MV6LlK6UU07tKHf+B82rYECqivqNi84sUbvwGMeUJRZRwAiKMK71MNwDDEZHfoJ3zxXMbBgxZkvkv43f/X59sBHp2QCJRFyJJlpSckC09V7X+ld1dSsN6PcHvc6WAfQn0StMGAYRd7TBs/EhVl/1+7wkmuNXM0nou5Q+reE3ka/b0OjXHSeM+Q+EjEDk3m+R/NmhwYS/CCHVMP1uIpvTZXs4Z6C24/YvcP6zZHFo1HYuAjd7UBUkNMaitu4k8+ILVc2N7XbGn4kxhDXwSKTC8
 O1+jj4+M
 nLUufT6U4Q20+FCB5hRMBv9ytxVFM9supD8yGZeBZq4zYx09XrG3wvPRJxvOwGUDPNw6gE94wKPmgqC2hjvxv3kXJVfGQ7xj6omopzKyQ8L77+cZ10xHEu2I3cuAPaufzYvCziKX1GtoOqrXRRt5NdadcgHNaIVOTi1bR2izqN3ojM2SDNe0Tqq59RzIatBn6PYyv1IHGR3YDyllG5dO/B8K3tct9iDpNs7pZwucMRq4YEgUlq9vkH5EIqAVYGqfavJBN
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
index 882f607fb4ad..088b4f6f81fa 100644
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
@@ -707,7 +685,7 @@ static inline bool __slab_update_freelist(struct kmem_cache *s, struct slab *sla
 {
 	bool ret;
 
-	if (USE_LOCKLESS_FAST_PATH())
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lockdep_assert_irqs_disabled();
 
 	if (s->flags & __CMPXCHG_DOUBLE)

-- 
2.52.0


