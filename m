Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB5ECFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FE26B002D; Thu, 27 Nov 2025 18:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900246B002F; Thu, 27 Nov 2025 18:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE3E6B002D; Thu, 27 Nov 2025 18:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69CB76B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:36:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13A9D12C68
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:36:57 +0000 (UTC)
X-FDA: 84157999674.19.4B64A44
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id E903F20014
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:36:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m77tV44C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WakdwEOx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m77tV44C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WakdwEOx;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06B+KtFJcCLWM7OEI7FlFF/W4XFxMu+OBjhz+zAvX5U=;
	b=3NonWH3xhZGp3lmci96X1ypgknArncL5tuAeU67j+rgXnWa5rk6wSLjSLC/6w6T962WRx4
	TBj8yK+XTwmDRW5uVzv0OEsGzWfCDfdQInAi/iPOAIVZhw9LDCu6UTGBbyYiE+kmR4v2x+
	YHIshhH26KdMGIeKXzUzn/0z3H8cLbo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m77tV44C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WakdwEOx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m77tV44C;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WakdwEOx;
	spf=pass (imf13.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286615; a=rsa-sha256;
	cv=none;
	b=lWutVBSR3afZJK1w+Mwk8BxAqJ7LLc2lUj9d+7U9NiPARw2jo/yjRKWPbnJNkPBu/WHMix
	Q3IH8be/CKaStn8i1N1l6jR3sf7ExQs+9BWZBKa4f1GX24elcZZMsKLaspkepSAbNboBG/
	ux3O9lY38oR+9lxkaP57oW6bgKj9hD4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 686EC5BD08;
	Thu, 27 Nov 2025 23:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06B+KtFJcCLWM7OEI7FlFF/W4XFxMu+OBjhz+zAvX5U=;
	b=m77tV44CYc/2L7cd1qBEUBNYPDDIy0bqrn1B719+3vvEplXfuboWDpFmJbYSBn7QIvsA6W
	HGNEqySFlzOPY4XWvW2Q74oXT0ap9ZGfyJeoqWRrpODaYMbu9JTJrzz4xXa2SVWA7EyTvE
	6TBog3CQxs3XF3B3bC8G2YBN7uyDAOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06B+KtFJcCLWM7OEI7FlFF/W4XFxMu+OBjhz+zAvX5U=;
	b=WakdwEOxdOUsDIqxLQRe6FKZZu/JvXqwQ4BSruah9UsBSU7dFru6PKLccknVef63HMBFiY
	pdpR0Hx3xu91eUAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06B+KtFJcCLWM7OEI7FlFF/W4XFxMu+OBjhz+zAvX5U=;
	b=m77tV44CYc/2L7cd1qBEUBNYPDDIy0bqrn1B719+3vvEplXfuboWDpFmJbYSBn7QIvsA6W
	HGNEqySFlzOPY4XWvW2Q74oXT0ap9ZGfyJeoqWRrpODaYMbu9JTJrzz4xXa2SVWA7EyTvE
	6TBog3CQxs3XF3B3bC8G2YBN7uyDAOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06B+KtFJcCLWM7OEI7FlFF/W4XFxMu+OBjhz+zAvX5U=;
	b=WakdwEOxdOUsDIqxLQRe6FKZZu/JvXqwQ4BSruah9UsBSU7dFru6PKLccknVef63HMBFiY
	pdpR0Hx3xu91eUAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C44B3EA63;
	Thu, 27 Nov 2025 23:36:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zCs2OpTgKGlAGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 27 Nov 2025 23:36:52 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-mm@kvack.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	Mateusz Guzik <mjguzik@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 1/4] lib/percpu_counter: Split out a helper to insert into hotplug list
Date: Thu, 27 Nov 2025 18:36:28 -0500
Message-ID: <20251127233635.4170047-2-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127233635.4170047-1-krisman@suse.de>
References: <20251127233635.4170047-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E903F20014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5m6yy7mgmfi3rxopng47b5ad1ra58xxg
X-HE-Tag: 1764286614-309807
X-HE-Meta: U2FsdGVkX19vXjnUHaXN4Qp54dduzq1+MJ14dlapX3DYksUnzCSPrIieUf2LdogiIwUjqU9xvceonULcdPsPVOMHDfHS1N7w3qViM5nJSYn8GHeyyqOVIxvCIywEvxjG6MQCnY15Y4jYpjuaWJizttLElXkVsOhmANrrYB/MymH6ofSqiuWr96Oeus1/Mp6YmiXFPBoGSdYvnYKBhWjmhoGUGe61i3BlxpZo8TTWGYjtHT6cKlyvfSiPBjsppo9VO/gB5n6+C4omRrqwLG8dLjnNCqpUb/ATl9BmAXcNty8wb8N1jE2HwfnjHGSyv7CaUFc+cX77zOMWByRuvElDMCPBGrTt0/XyXkkhL61xIhwmHAqT+v2l8Ute2NeCru3ams9zSxIX+CUS5HmukvYuY3suV//n1XfDGSW155BcLJAvxrX8Z4whJlHLTczVuQ37ItycWHYM6w18QpPpKO8F/ApnbnICjWDQBO8AOeokBgAJanReLdYtM5t6iYZe+M5UkddXBlBy4Ibp6m2LevzOaFYbL446r3FdK7hLcOkQ0nGf/kqeFGXDsfxRjCz++/juhjD3B0tByGmvcvxeltIJc1OP3fYdvmxMAT0cpUbrJTLIwwQtbqBMp4oaWQ5qLZ1cp/2Qjryt9yr1j4Edrq/tuRoFeVzrggIejFX0JrX7hALoht8CNOG94+20yHkABihSjWQ2gu6fJLEDUUED27/0aRmu57FttOc61yrGPAj5odaTnQLwS0Hw8jG+7YgE/DqgSrm1sJ0l1KOws1Wyxt7WNVDISRTg9zuf5DzPs4b4RIpfqquFgNCdyx+Aeby8p9DaHwyneWSJf/7rzglqoO33SM/YrrSXZuyioksHWCwhghCtOYOnNzCh3mvbhs7axc5n8vsYtfkRxxgXJI68I5dZdLquq2VSsxSc/P9D9XmhuIT5IPmcwS/RCYmwkQjibKAlAh5rpsGtgsDZilLCqAw
 BVOD81mF
 1UH3opGmYRVP6dQq11rqM5W469Xiurj8MH6/HnzQTWeMyHWM/oy2+hsPf+Uo7pHdS8fmfTORlfcnnNIIQeXA0G8vWGPk+AD03QBZWk0L27NzNhkuUaWr8YZKBfgPYccwcPC28L/kOXAk5THDZtb5p/eGXFrR7Vq1YnTEUvX2UTFt5xmIATdUsYd8nC+smD/PhCqbSPn5286jxodaJ95e6S0Yj5yjcw9HrjgRdp79Tj66LLeUqK+Fi0jkZFr3GLBOzQFzAl1Ne6lxPXzMQSgUEIYEkIZdRHt5uSpQHNMIwLNjYm+itHKOEgzZ08w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation to using it with the lazy pcpu counter.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 lib/percpu_counter.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 2891f94a11c6..c2322d53f3b1 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -185,11 +185,26 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+static int cpu_hotplug_add_watchlist(struct percpu_counter *fbc, int nr_counters)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&percpu_counters_lock, flags);
+	for (i = 0; i < nr_counters; i++) {
+		INIT_LIST_HEAD(&fbc[i].list);
+		list_add(&fbc[i].list, &percpu_counters);
+	}
+	spin_unlock_irqrestore(&percpu_counters_lock, flags);
+#endif
+	return 0;
+}
+
 int __percpu_counter_init_many(struct percpu_counter *fbc, s64 amount,
 			       gfp_t gfp, u32 nr_counters,
 			       struct lock_class_key *key)
 {
-	unsigned long flags __maybe_unused;
 	size_t counter_size;
 	s32 __percpu *counters;
 	u32 i;
@@ -205,21 +220,12 @@ int __percpu_counter_init_many(struct percpu_counter *fbc, s64 amount,
 	for (i = 0; i < nr_counters; i++) {
 		raw_spin_lock_init(&fbc[i].lock);
 		lockdep_set_class(&fbc[i].lock, key);
-#ifdef CONFIG_HOTPLUG_CPU
-		INIT_LIST_HEAD(&fbc[i].list);
-#endif
 		fbc[i].count = amount;
 		fbc[i].counters = (void __percpu *)counters + i * counter_size;
 
 		debug_percpu_counter_activate(&fbc[i]);
 	}
-
-#ifdef CONFIG_HOTPLUG_CPU
-	spin_lock_irqsave(&percpu_counters_lock, flags);
-	for (i = 0; i < nr_counters; i++)
-		list_add(&fbc[i].list, &percpu_counters);
-	spin_unlock_irqrestore(&percpu_counters_lock, flags);
-#endif
+	cpu_hotplug_add_watchlist(fbc, nr_counters);
 	return 0;
 }
 EXPORT_SYMBOL(__percpu_counter_init_many);
-- 
2.51.0


