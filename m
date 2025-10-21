Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1D2CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5AC48E0003; Tue, 21 Oct 2025 03:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C324D8E0002; Tue, 21 Oct 2025 03:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21508E0003; Tue, 21 Oct 2025 03:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0D528E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:04:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02A3913ABC6
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:04:47 +0000 (UTC)
X-FDA: 84021233856.01.8907FF5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5BD43C000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:04:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nJUF1Sii;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CDFaaZ1U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JRo30k8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UY6yhdWy;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKa23txq5VZUcJ3KpkIgUf0mRuHZ2KAGGjulu7Eo99s=;
	b=ATOd+yS1nu+B7Ev+4pI5OokTgmzEdA9WryqOyQgwihknNqt8s8Eb4o7EnLQfwBxl2CYpib
	k96etP9YF7nfr/znGpwemDofa5qyNfQgWrnLyy24VGDziNjuU0Z6ajVOjR20gMSO80jnEJ
	rF0p9wWz9g6JGfXn6KTJXVNOG+4nrc0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nJUF1Sii;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CDFaaZ1U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JRo30k8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UY6yhdWy;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030285; a=rsa-sha256;
	cv=none;
	b=Tr49YWSJtxVHMvUoGMaiCB51UWXg49J3Yol3tCXNsISx6cQOTmG3r4xPqcfR7+9ODa4imF
	AmJvzTqGSsSiW+FP8vgYGizqsITMo1R+gl53tt86wCXpV4SZEPJmOPCHyhXG+PwBNJw9Y4
	qw/GyXC5Q86w97oaAyeCYJWzjWiWKJ0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 669F6211E9;
	Tue, 21 Oct 2025 07:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761030279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UKa23txq5VZUcJ3KpkIgUf0mRuHZ2KAGGjulu7Eo99s=;
	b=nJUF1SiiczGXdcJgqVdI10l5W3jAiIMIz/vFLGByHgcgBR1Fb76iL33fLu1/t2yL8DGw2i
	A8oYP5lEGXkxJM/Eddlst0M+/f6CRN/eBvSy2zuPn64/pAUIG9KIyO7N8z80jCASAQsVwV
	z4rzqZOHdJ2+1+fRfF8pzE4nqUsF7Lo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761030279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UKa23txq5VZUcJ3KpkIgUf0mRuHZ2KAGGjulu7Eo99s=;
	b=CDFaaZ1U4RVA4MONSr3k68hzq23fEQIPc481aV7/8k6aBmmEOlYMOcquhB9mxR5Vl7LSS+
	agiGUBVWJP8mXxCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761030275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UKa23txq5VZUcJ3KpkIgUf0mRuHZ2KAGGjulu7Eo99s=;
	b=JRo30k8rYa3bP1bS2eHkjrV16N81bi+ALvbpYx7eVyroiHV+TQBR/s5GvDqmV3CbY9yBb5
	WjjXAXYK/czIxA3raAMTRliYok2qrqzZ9DqUntHjlXCiysMs+zdtrZ+GZopY4Og/kahyY8
	c3Tg/TpZoxmOO12OqQWFl1eknt3OBFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761030275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UKa23txq5VZUcJ3KpkIgUf0mRuHZ2KAGGjulu7Eo99s=;
	b=UY6yhdWykkfCRRy6ZK+k+gNZnRHDbGZoS0fdr/1JW+GyCqSE81lGzy8Qag0A9z1RALUzXW
	6Z7z4QJlNfYtq8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B696139D2;
	Tue, 21 Oct 2025 07:04:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id owgTEoMw92h/OwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 21 Oct 2025 07:04:35 +0000
Message-ID: <1e1376fd-1d38-4dde-918a-d4e937d4feac@suse.cz>
Date: Tue, 21 Oct 2025 09:04:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] slab: Avoid race on slab->obj_exts in
 alloc_slab_obj_exts
To: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>,
 stable@vger.kernel.org
References: <20251021010353.1187193-1-hao.ge@linux.dev>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251021010353.1187193-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BD43C000A
X-Stat-Signature: tqaicyoz1mxh7o5d816nu7kb45abgwd5
X-Rspam-User: 
X-HE-Tag: 1761030285-51382
X-HE-Meta: U2FsdGVkX1806iUl24RUclWsukLxzcroZrDsIlTI6cCnjB/NbRIYGjAUXdVww1Tsmm4ja6F5cRwp0OiNvZ33XHePpTSL2EdKrr8Om8eNrM6ToXTXVA6Ck1XLzDqhq/dOH4z1lu35W61U51eMJoRE52JRDyW2d7PYNQR8/mb6buxCxrum9CiBzSMxj1559oTW5umeDPK/UfwTz1Q3DuqP+9Ts25LTS1w+5WQ+5CzhLaatai+62AGz0QOn/oOOAA4D6kBXXFz05VGt/1QZL4KSCeMG/eqSOmqSeJaoYiXrMrEuhbf5U6Lq1t/FdZZR0F3GZuNUqbUWzgEHBSzvDvGJNyL5SJ3kfdJCZ/uJdburve5riJnAI87Pi7n7WtBQegudO48grk2icHCGPhOtRa8rsl50hn0xKipdbh0MMg4/5GrNIHX6AZUegR7Z+v6FHlffbNtFeuSW/jWRktz30jA1/7y9NCb5VT2TtMZgyIN+6R1Qk4jCAUJGTHbhzF2tYDwNqK1Wdi/nfFtC+aZGXRx3Tp5GsrmyWzNTQvXivIXmjKw/BaTxtZuhgnUhamRZxijTscpS9Zoys1xk5jA2w5dR9yGzW7fJ0FecJtJ8j+g5NvkRNvCt5m3tjR21nSDdyIbAsxVzrhDWP8fkKKT3tLJV09EeUbq+R3nONnn/tNu2k+Z+8sRsP86NJNQFe2zqgSejSVgnzxHC0KKDBtLsO+7CApAYDne0ewOUKYUppd3YNzYBPV+jkgx5yXsBuMwyRhdS4CW2d7kbbCwoCof2rWSfE4i/mtsWbcJ3MC8b9x6TP0spd4iXYA5i33m62/4nE66GSRL348z5Ynm9pf9o5Gs9r8/k6mKtoGU20NBIkIkX2UhJBrPWd8MyEusjYJORl1VTPspcc5N7EK32lA5vqhAZH7ieDekowt6pQrpZAQD+KkbdbdF9fiQdEKAnHzPvVI1A+z/LVgUSNCmMBspkkCv
 0dVXrzV1
 /Lu2a5Sf6M7XaKExanCnXnx/NYlIrTuT0/VZivc/APmMXAPCpR2N82Oli4bhtXnbjPLzJhy8oLEQXTyECl8rRvJ09HmxSlGKzPQmyq3Q7S9B7/r3RsfCPrlT0YXzcGjzg5UPSIY3BAsH2zFIOsCiNdX+JKyl7xq5IxVMN12kEHRoc1xviF9sSkzH2ousMwLsxfLKpH5ihtjm07EtRNQPX6CuYuTK1DbPM+exl3smTfIK22tXDoH5OmWfXi1LVlfRoCUY0QBotVIY9zj6OVCBfOKkXuglieWv1N2b7QaBC9OcX7d3gSUOLNJ8wdh/6+47u9kGqh3RHZe+1gW4z0f5k4wfBs1fp6D0LuN4Rqw9xW8MfFO3WUigKQ7FZujKRKcxO535N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 03:03, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> If two competing threads enter alloc_slab_obj_exts() and one of them
> fails to allocate the object extension vector, it might override the
> valid slab->obj_exts allocated by the other thread with
> OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
> expects a valid pointer to dereference a NULL pointer later on.
> 
> Update slab->obj_exts atomically using cmpxchg() to avoid
> slab->obj_exts overrides by racing threads.
> 
> Thanks for Vlastimil and Suren's help with debugging.
> 
> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>

Added to slab/for-next-fixes, thanks!

> ---
> v3: According to Suren's suggestion, simplify the commit message and the code comments.
>     Thanks for Suren.
> 
> v2: Incorporate handling for the scenario where, if mark_failed_objexts_alloc wins the race,
>     the other process (that previously succeeded in allocation) will lose the race, based on Suren's suggestion.
>     Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/slub.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2e4340c75be2..d4403341c9df 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>  
>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>  {
> -	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
> +	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>  }
>  
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2136,6 +2136,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  #ifdef CONFIG_MEMCG
>  	new_exts |= MEMCG_DATA_OBJEXTS;
>  #endif
> +retry:
>  	old_exts = READ_ONCE(slab->obj_exts);
>  	handle_failed_objexts_alloc(old_exts, vec, objects);
>  	if (new_slab) {
> @@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		 * be simply assigned.
>  		 */
>  		slab->obj_exts = new_exts;
> -	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
> -		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
> +	} else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
>  		/*
>  		 * If the slab is already in use, somebody can allocate and
>  		 * assign slabobj_exts in parallel. In this case the existing
> @@ -2158,6 +2158,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		else
>  			kfree(vec);
>  		return 0;
> +	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
> +		/* Retry if a racing thread changed slab->obj_exts from under us. */
> +		goto retry;
>  	}
>  
>  	if (allow_spin)


