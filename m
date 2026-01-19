Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E356BCCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488206B014D; Mon, 19 Jan 2026 04:34:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456186B014F; Mon, 19 Jan 2026 04:34:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337C36B0150; Mon, 19 Jan 2026 04:34:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2223B6B014D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:34:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B15C91406DF
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:34:12 +0000 (UTC)
X-FDA: 84348202344.27.6272CAC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23C40180004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:34:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YV3pO5JV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wKszw5nA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YV3pO5JV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wKszw5nA;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768815250; a=rsa-sha256;
	cv=none;
	b=GWVFR/mdwaX8m+tgH4Os4q0HAX/iap3YqYEaWA7m+752CIu2OYM6wpdYd8Hn4/aQRrmVgH
	/WtrKGDFgKY3MunKFEM5Av/FSJqYMSvp7uAZUv987567VWLuXluhjDVsWqX4JyiuMc0oPF
	P4rDsLtvw3eM9k5wTkU+biLTXlXn6d0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YV3pO5JV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wKszw5nA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YV3pO5JV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wKszw5nA;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768815250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikLK1Mgji5k5g6jyOPReFRltrTEuDlSX80eK5Jr1uK4=;
	b=sLXBGzQCcSfAlhk1TcA3871NadhYh1dAAgnfvQCblzQ2RkMMMWA7KRSIc7MpIFt0jHN0o0
	+ks0lVpWft26u002PhJ0xyqurql/9Jf9WT2X3a39YDk7xU6w6idd8AJ5OMgFGGKCtMXs8A
	iJ3XsXQTeudxlnawwXAbXwuojwsJrsk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CA145BD44;
	Mon, 19 Jan 2026 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768815248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ikLK1Mgji5k5g6jyOPReFRltrTEuDlSX80eK5Jr1uK4=;
	b=YV3pO5JVs8tDCn2O+3X6BUTQW3U0ouPlo7goLSDSkyDXIP4iSVccogJ4/KzR4YGddJJXMu
	9q4auK2Z/0Ose/Y9XPpcwV2AqXI1lOixpZY6hNHwgEdpXqjZahn8psPFZK0Epmi0MPw6zS
	HuWkje/2RsjmVKFhfVnM4arp1Cyelbo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768815248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ikLK1Mgji5k5g6jyOPReFRltrTEuDlSX80eK5Jr1uK4=;
	b=wKszw5nAQu/uhKci0sbkUFQPyyKLfp1ADEz2oKYEn6PsIFmUJcOltygGTf36ztv3TIRxWR
	3b5QzNODRwBSevBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768815248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ikLK1Mgji5k5g6jyOPReFRltrTEuDlSX80eK5Jr1uK4=;
	b=YV3pO5JVs8tDCn2O+3X6BUTQW3U0ouPlo7goLSDSkyDXIP4iSVccogJ4/KzR4YGddJJXMu
	9q4auK2Z/0Ose/Y9XPpcwV2AqXI1lOixpZY6hNHwgEdpXqjZahn8psPFZK0Epmi0MPw6zS
	HuWkje/2RsjmVKFhfVnM4arp1Cyelbo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768815248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ikLK1Mgji5k5g6jyOPReFRltrTEuDlSX80eK5Jr1uK4=;
	b=wKszw5nAQu/uhKci0sbkUFQPyyKLfp1ADEz2oKYEn6PsIFmUJcOltygGTf36ztv3TIRxWR
	3b5QzNODRwBSevBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EFFC3EA63;
	Mon, 19 Jan 2026 09:34:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QpVoBpD6bWn1WAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 19 Jan 2026 09:34:08 +0000
Message-ID: <4f60e230-c76e-4ab3-a0f0-7598dcb15d1a@suse.cz>
Date: Mon, 19 Jan 2026 10:34:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
 <CAJuCfpERcCzBysPVh63g7d0FpUBNQeq9nCL+ycem1iR08gDmaQ@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpERcCzBysPVh63g7d0FpUBNQeq9nCL+ycem1iR08gDmaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23C40180004
X-Stat-Signature: dmo4mpdhppnjw6xbr8tsboqhzs44q9r4
X-Rspam-User: 
X-HE-Tag: 1768815249-903409
X-HE-Meta: U2FsdGVkX18HswPNyVhnXzYuyd+brwT/qUnhGaWSYzKkanhFokKg/SbsbONVP8iE4/nUVrHCq62UwY11rHdNxKTHRk1lONprZPplPu0aLSORuhpO1Dfp8tSHaClZYAXV0UVjkE4b9vAGT/ku8lwVFsqeDudwJolopWKdUUyZWt/sT4kHPh3iwTr4kV+4DzMyW2vq5uoE2cAFrq1C/9zsmcXDISc5OKDvj3s6GFqHhIKsvCt0NlNAkyZB/PCmm9v/vp+gHFP0cQfLbRMj37To+SK43IN3H1mmP/oVHyi/KwKhenQ8953x3scqMVFv9F1xK2mM7eVG2LPNEytNlil7zRxghTbDlzA9K/SBejfXVL3Q9+IWAVo+3LpHDaFGVHsq56j819Wb2AdlqW1Oggkdhz9MttJFz7sY2m1FHqv4okDPfo130zUSd6DiE7PXdzJmYMvreT3DsKGq0qtNMerNDdW88vGzX0Vmeqq2TTj+lKzy/9V2opnRCH7q+D6W83ZXOH/rZSy/bYKa3OLg/ELP4dap6evsHBbcjxLaoH/SR+H1CGABzega9nIm43Wvrifs813QMuhRfzjwaLBchEBBKPG1cbkHQyE9kcH2CD56sLg9j37FT4uUAMv7RjciruGt0EnrSjAM4fJT7F0O98QEK3ffHuBPW0gWpsGbxqbuWgs9xt5/JfouoVXMP0Zynvfy46QnyCHoCnBM7A2FffC+Iez4YSYQEW4AS92r9PwnrZd//5ieNu28fJQ0NnOL1wHp6/hajsE3XVdqwSunhrY/f7FeaOejx6CtEFIaeOQMOMBE34XwWiijX22+LI22qqU6JI/GXNWw9O0ZHJaQbUcN9G3XuvX8eqhHxGRtC55UoTo8gn1Z/QFc3yXClnlBgcDLvOj3FC1kkxj/+Xu3pbItNIMnMTwYxBKOhmHL90T+jmd+lVym9KIXWMcoAfPsbrxyrMsKNlmsvnJ5N0fRFkW
 tHt8vmzV
 UH5AMFtCOxg1+s84GN7RkVkNSnk+/bhq9RMi3rstx420WESRjiLTZSdWgPXO/rqbjGGQ1gK+ZJXLMvNqeoKqG4HL6W+iQVeAbeBTkH8DdrCkXwolA+qOSofFi8kWacVGKBGpV+OS4bZoTjYZ7JPfDzVW5B4VeCauFBVU+6tQSLvpLIKv6tpbjnm3w2HiEbh+4XddG0CDImszT86Fpl3I7NgP24JFP6Wuh8elW1c0wwaZVII3WnMxfP4icyNQTQbory4PDR+qaCcgZiV3lk7F5kwDKiT1l/awht2u0KZlDo54XPsUlIrT1Br0EpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/17/26 03:11, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> Thus sharing the single bootstrap sheaf like this for multiple caches
>> and cpus is safe.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 119 ++++++++++++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 81 insertions(+), 38 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index edf341c87e20..706cb6398f05 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -501,6 +501,18 @@ struct kmem_cache_node {
>>         struct node_barn *barn;
>>  };
>>
>> +/*
>> + * Every cache has !NULL s->cpu_sheaves but they may point to the
>> + * bootstrap_sheaf temporarily during init, or permanently for the boot caches
>> + * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
>> + * helper distinguishes whether cache has real non-bootstrap sheaves.
>> + */
>> +static inline bool cache_has_sheaves(struct kmem_cache *s)
>> +{
>> +       /* Test CONFIG_SLUB_TINY for code elimination purposes */
>> +       return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
>> +}
>> +
>>  static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
>>  {
>>         return s->node[node];
>> @@ -2855,6 +2867,10 @@ static void pcs_destroy(struct kmem_cache *s)
>>                 if (!pcs->main)
>>                         continue;
>>
>> +               /* bootstrap or debug caches, it's the bootstrap_sheaf */
>> +               if (!pcs->main->cache)
>> +                       continue;
> 
> I wonder why we can't simply check cache_has_sheaves(s) at the
> beginning and skip the loop altogether.
> I realize that __kmem_cache_release()->pcs_destroy() is called in the
> failure path of do_kmem_cache_create() and s->cpu_sheaves might be
> partially initialized if alloc_empty_sheaf() fails somewhere in the
> middle of the loop inside init_percpu_sheaves(). But for that,
> s->sheaf_capacity should still be non-zero, so checking
> cache_has_sheaves() at the beginning of pcs_destroy() should still
> work, no?

I think it should, will do.

> BTW, I see one last check for s->cpu_sheaves that you didn't replace
> with cache_has_sheaves() inside __kmem_cache_release(). I think that's
> because it's also in the failure path of do_kmem_cache_create() and
> it's possible that s->sheaf_capacity > 0 while s->cpu_sheaves == NULL
> (if alloc_percpu(struct slub_percpu_sheaves) fails). It might be
> helpful to add a comment inside __kmem_cache_release() to explain why
> cache_has_sheaves() can't be used there.

The reason is rather what Harry said. I'll move the check to pcs_destroy()
and add comment there.

diff --git a/mm/slub.c b/mm/slub.c
index 706cb6398f05..6b19aa518a1a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2858,19 +2858,26 @@ static void pcs_destroy(struct kmem_cache *s)
 {
 	int cpu;
 
+	/*
+	 * We may be unwinding cache creation that failed before or during the
+	 * allocation of this.
+	 */
+	if (!s->cpu_sheaves)
+		return;
+
+	/* pcs->main can only point to the bootstrap sheaf, nothing to free */
+	if (!cache_has_sheaves(s))
+		goto free_pcs;
+
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		/* can happen when unwinding failed create */
+		/* This can happen when unwinding failed cache creation. */
 		if (!pcs->main)
 			continue;
 
-		/* bootstrap or debug caches, it's the bootstrap_sheaf */
-		if (!pcs->main->cache)
-			continue;
-
 		/*
 		 * We have already passed __kmem_cache_shutdown() so everything
 		 * was flushed and there should be no objects allocated from
@@ -2889,6 +2896,7 @@ static void pcs_destroy(struct kmem_cache *s)
 		}
 	}
 
+free_pcs:
 	free_percpu(s->cpu_sheaves);
 	s->cpu_sheaves = NULL;
 }
@@ -5379,6 +5387,9 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 	struct slab_sheaf *sheaf = NULL;
 	struct node_barn *barn;
 
+	if (unlikely(!size))
+		return NULL;
+
 	if (unlikely(size > s->sheaf_capacity)) {
 
 		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
@@ -7833,8 +7844,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 void __kmem_cache_release(struct kmem_cache *s)
 {
 	cache_random_seq_destroy(s);
-	if (s->cpu_sheaves)
-		pcs_destroy(s);
+	pcs_destroy(s);
 #ifdef CONFIG_PREEMPT_RT
 	if (s->cpu_slab)
 		lockdep_unregister_key(&s->lock_key);


