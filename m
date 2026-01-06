Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31ADBC47BC4
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 08:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F17A6B0005; Tue,  6 Jan 2026 03:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79ECC6B008A; Tue,  6 Jan 2026 03:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656736B0093; Tue,  6 Jan 2026 03:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52B4D6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:28:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1517CB86F5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:28:34 +0000 (UTC)
X-FDA: 84300862548.29.BFC9E3C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id B501F4000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:28:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNYnzVxe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K7zaTXcK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNYnzVxe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K7zaTXcK;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767688112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvKwPH/bBOdM6Vqgx5KzmOB0oEuOsw5gHG+7gbN9Y54=;
	b=5Lm1RZFbEfTw8m/IzbR1MUxM9XrcniNmgp4SJ8T25lXcFuyfK+1GGKGYUtHiySjGHb0K6V
	thdVC0vxzzPKl4/cvrGxcT8rNSsNun4brhFdjrHvpfUpIuG5TGyN8emtG50QECNtVw/Sd4
	u+/tELGpWgRZHJUO65HInFRfuOkBIq0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNYnzVxe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K7zaTXcK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sNYnzVxe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K7zaTXcK;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767688112; a=rsa-sha256;
	cv=none;
	b=b7kfUEbrc5MeMgbpJZMJRfmG6tsXqEg28qJotznraKn86LTNBj680EJXU1dPUumxjo2FYE
	XJWKjMbSfkNa1gYG/eZ5Kny8li7Z5GLGftfJl8cDzvDsu7uPDq0Jf3wHDUiNQX6e/AasMt
	kLD+q1yHQDRImNbw49+KIf7B5tMkZoQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2463C33919;
	Tue,  6 Jan 2026 08:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767688110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tvKwPH/bBOdM6Vqgx5KzmOB0oEuOsw5gHG+7gbN9Y54=;
	b=sNYnzVxeR/bZ8vGV0nF5yiqdoV5vZLHCsj3otCOF21QQUn9V2IFuwJa1ycg0tQvZPcLbPq
	SWJvv4OOTXAa/nlqMFmpudHhyxOFA4u4zo0CrrnmrYnU5argXvc5Ho5iVL9Rl6GI/DzDCk
	iySBvlZo9CBil6x55fkSsLqy12UIBX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767688110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tvKwPH/bBOdM6Vqgx5KzmOB0oEuOsw5gHG+7gbN9Y54=;
	b=K7zaTXcKE77J8MZVHMPM7QPEoYqCKgmmSe9vrlh5JsxeDyl/Tr6M50jLEZq3/Dds9tWhB6
	QY5EQZjxqazkKvDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767688110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tvKwPH/bBOdM6Vqgx5KzmOB0oEuOsw5gHG+7gbN9Y54=;
	b=sNYnzVxeR/bZ8vGV0nF5yiqdoV5vZLHCsj3otCOF21QQUn9V2IFuwJa1ycg0tQvZPcLbPq
	SWJvv4OOTXAa/nlqMFmpudHhyxOFA4u4zo0CrrnmrYnU5argXvc5Ho5iVL9Rl6GI/DzDCk
	iySBvlZo9CBil6x55fkSsLqy12UIBX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767688110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tvKwPH/bBOdM6Vqgx5KzmOB0oEuOsw5gHG+7gbN9Y54=;
	b=K7zaTXcKE77J8MZVHMPM7QPEoYqCKgmmSe9vrlh5JsxeDyl/Tr6M50jLEZq3/Dds9tWhB6
	QY5EQZjxqazkKvDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0704E3EA63;
	Tue,  6 Jan 2026 08:28:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DCpeAa7HXGmVNAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 08:28:30 +0000
Message-ID: <04624b16-40ea-42c6-b687-4013796e4779@suse.cz>
Date: Tue, 6 Jan 2026 09:28:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/page_alloc: prevent pcp corruption with
 SMP=n
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>,
 Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
 <20260105164036.32a22c2e@gandalf.local.home>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260105164036.32a22c2e@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: cwid55enq93h447r6nbg8s9mt6ar93tx
X-Rspam-User: 
X-Rspamd-Queue-Id: B501F4000A
X-HE-Tag: 1767688111-916860
X-HE-Meta: U2FsdGVkX1/VjLnW35vF3OgkJuKo0QumBCxi8Me6ET1FiwRtRGILPy+4Q4M0YaiX6+6LNfQuX8IHWeQWAYqiVFr204ZLE5CRQLHAlRY+nQ0ml19dh6l0UocdWCNM3Ml2QTfSveWbPuZuSNLQbPD2aVW7ETxea06BhWpcGlnTOG462VtdKkSdrMk9ZAyfUMtsGK5xLt+JmRWduNVju6sVBzUy6JMan1v51dVm0oOy37K/TiXTMoD4byhm3840ll/n6iMOMkaZf+VOxV08ERfkZizScai/SyubAlGYXeaY9Z+1c4jBM9UGeWz3nJN1bmsj9l6o94DBzViO2W33vdlzhhmAxcY29+MoBkuas8coIZuyEB6Z9pzA/3sEgYlsqg9zsoxjbszhTkt3W8R+7W6QDgdxnfLG/rhJDCfZHC1MD9LfJ67BkiPzyM4Yh7qlkMzPFce3o26wkKoi20uGSq9maTkBqGLayWAnknw1a5L4KUlOLW3DLuBzpX8Ui7r/agh9S/Fxpb4/BXX6u1XF05UDP1iU3T0BD6YWmJ4F5u6il8Qwa+4MetCDa1hfO5EvKJ/vseGBdNpHb57mgn3XbDcGCTrOXGn+DA70FyKLG4F1zCfV50hnNtQ03pzjaUUZb6zapQL3wnu0+kIwwAyFNnv64hoPxZ18lU2qX9SyFjeqScZkmg/I4vUN2kVuRykQQkS4Ww3VkHoxRMUa75tlvnkZ/7B3mb/Bb2599LnHOPEZo5SWkculmEAYLBImE+OgxD1RNY+qQ0IjtCVpDiRekTUiV2jXEN3UWeJkwNwqb0c35l+SgfHQ9mNtLgf6gV6SnkhFyWriZikgBcukqIJKxdBvaGQij9FiIFCR+9WGimA2E5EHHr/IkOIU47v9wdaaOr7A7lBV25hCtBBGS47Vydj9+osUBWBKAi/e0iNJBuhVe8rMZbx8DNBaBWqbNLVJmKoMmJG4I4XLxRciW/PxHd6
 3Ui5iK7/
 1rgV27C1V1jEg1+chYj8y4cBrdbDKR4l3lc9K80u9uYB4P2HqUXnTQ7+xtReeQyqzWzN+DI6pFJS7aVOQnUFkVXVgLIE/KidmCh3B5Qj3wI7zwF1Ey2iVAvSH6nranftDf0b9WAbV7vt1qPDHsmw+6qZYbKhq7g+yetUTCsTji73M3W4k9tf6/N2avTtE/Dt+127Pf2HkDt3H+U2A3aQNC1wXyv/tZ7D+2PigL9InSKNuY85UvQAiRdk+vcfc5d0jTeHO1m5ESusb0g+cCJupiPqGRUkmb7b/RtO4lNjRrMcBL1bGBov6WE7GGOVbf8+z6EtcfbE+/OU1Dlk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 22:40, Steven Rostedt wrote:
> On Mon, 05 Jan 2026 16:08:56 +0100
> Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> +++ b/mm/page_alloc.c
>> @@ -167,6 +167,31 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
>>  	pcp_trylock_finish(UP_flags);					\
>>  })
>>  
>> +/*
>> + * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
>> + * a potentially remote cpu drain) and get interrupted by an operation that
>> + * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
>> + * spinlock assumptions making the trylock a no-op. So we have to turn that
>> + * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
>> + * remote cpu's so we can only be locking the only existing local one.
>> + */
>> +#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
>> +static inline void __flags_noop(unsigned long *flags) { }
>> +#define spin_lock_maybe_irqsave(lock, flags)		\
>> +({							\
>> +	 __flags_noop(&(flags));			\
>> +	 spin_lock(lock);				\
>> +})
>> +#define spin_unlock_maybe_irqrestore(lock, flags)	\
>> +({							\
>> +	 spin_unlock(lock);				\
>> +	 __flags_noop(&(flags));			\
>> +})
>> +#else
>> +#define spin_lock_maybe_irqsave(lock, flags)		spin_lock_irqsave(lock, flags)
>> +#define spin_unlock_maybe_irqrestore(lock, flags)	spin_unlock_irqrestore(lock, flags)
>> +#endif
>> +
> 
> These are very generic looking names for something specific for
> page_alloc.c. Could you add a prefix of some kind to make it easy to see
> that these are specific to the mm code?
> 
>  mm_spin_lock_maybe_irqsave() ?
OK, I think it's best like this:

----8<----
From a6da5d9e3db005a2f44f3196814d7253dce21d3e Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 6 Jan 2026 09:23:37 +0100
Subject: [PATCH] mm/page_alloc: prevent pcp corruption with SMP=n - fix

Add pcp_ prefix to the spin_lock_irqsave wrappers, per Steven.
With that make them also take pcp pointer and reference the lock
field themselves, to be like the existing pcp trylock wrappers.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ec3551d56cde..dd72ff39da8c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -177,19 +177,21 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
  */
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 static inline void __flags_noop(unsigned long *flags) { }
-#define spin_lock_maybe_irqsave(lock, flags)		\
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
 ({							\
 	 __flags_noop(&(flags));			\
-	 spin_lock(lock);				\
+	 spin_lock(&(ptr)->lock);			\
 })
-#define spin_unlock_maybe_irqrestore(lock, flags)	\
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
 ({							\
-	 spin_unlock(lock);				\
+	 spin_unlock(&(ptr)->lock);			\
 	 __flags_noop(&(flags));			\
 })
 #else
-#define spin_lock_maybe_irqsave(lock, flags)		spin_lock_irqsave(lock, flags)
-#define spin_unlock_maybe_irqrestore(lock, flags)	spin_unlock_irqrestore(lock, flags)
+#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
+		spin_lock_irqsave(&(ptr)->lock, flags)
+#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
+		spin_unlock_irqrestore(&(ptr)->lock, flags)
 #endif
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
@@ -2601,9 +2603,9 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2626,9 +2628,9 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	}
 }
 #endif
@@ -2643,7 +2645,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 	int count;
 
 	do {
-		spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2652,7 +2654,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 	} while (count);
 }
 
@@ -6148,12 +6150,12 @@ static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	spin_lock_maybe_irqsave(&pcp->lock, UP_flags);
+	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	spin_unlock_maybe_irqrestore(&pcp->lock, UP_flags);
+	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)
-- 
2.52.0



