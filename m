Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4144CCF2D0
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B576B0143; Mon, 19 Jan 2026 04:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5466B0145; Mon, 19 Jan 2026 04:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0F86B0146; Mon, 19 Jan 2026 04:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFC2C6B0143
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:13:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAD2C160694
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:13:55 +0000 (UTC)
X-FDA: 84348151230.03.339A2AD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7BD2A14000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:13:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quUkNXI8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jYX9y27W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quUkNXI8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jYX9y27W;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768814033; a=rsa-sha256;
	cv=none;
	b=AyoZjjLvR3Tm0jC+5kLYST6HGe0pgH5rqDVYJcJov78PtrdTTSWs62eGk2KqnukMRrFarf
	bp0MjBzbW4bndcWwiS9QRwX3Gqb2W8cY3rJBxtAVyg5ZdfKAwbnJniIXJmaorcPxEeU5Ok
	ecv+Vk2Tex31CKqCgAvOs/Z/XyjA77g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quUkNXI8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jYX9y27W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quUkNXI8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jYX9y27W;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhooBqjIFB2Zss7F6dtPfbhQAxjPz0yCTX0IY1G6TwY=;
	b=ti8A6Xth7gkvOCRrICt+o+N/fT6OHfxp42S5VS9l+jeDF6cP09KtmnBKK8GZcyIIynvQ5U
	n2ESsh0jykhhA9Zn39/KKnZ233DVrPvBeDXeLl8oifaASe8vKExNJ5tk0Mm4kgQnSIRqPn
	Wu8Ag1NHK2879VcfC9DLmeI0qtiRrdM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B814336FE;
	Mon, 19 Jan 2026 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768814031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XhooBqjIFB2Zss7F6dtPfbhQAxjPz0yCTX0IY1G6TwY=;
	b=quUkNXI8whjFLXWQEgtlqwb32btvqRwOBu9Kvhxud89O3mPo6629RCETHf8qy+6O3xc/zw
	Z6i3iMI86eABtBJ5GYZmsq1t+0LD2ZieYJAIBnZMeTKfyURACAGYgLFtF5hJ8Qd8nSHPFO
	pul/4lqAegwdIbXIPOZtNNqUjjpnMRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768814031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XhooBqjIFB2Zss7F6dtPfbhQAxjPz0yCTX0IY1G6TwY=;
	b=jYX9y27Wks0FdQuI6wroIgn1vU/1z8p4cyNoHI6b/nvSjBKPpbe51MwiUuUqpsd921RmyX
	piwd/dX+3zLKQcCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768814031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XhooBqjIFB2Zss7F6dtPfbhQAxjPz0yCTX0IY1G6TwY=;
	b=quUkNXI8whjFLXWQEgtlqwb32btvqRwOBu9Kvhxud89O3mPo6629RCETHf8qy+6O3xc/zw
	Z6i3iMI86eABtBJ5GYZmsq1t+0LD2ZieYJAIBnZMeTKfyURACAGYgLFtF5hJ8Qd8nSHPFO
	pul/4lqAegwdIbXIPOZtNNqUjjpnMRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768814031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XhooBqjIFB2Zss7F6dtPfbhQAxjPz0yCTX0IY1G6TwY=;
	b=jYX9y27Wks0FdQuI6wroIgn1vU/1z8p4cyNoHI6b/nvSjBKPpbe51MwiUuUqpsd921RmyX
	piwd/dX+3zLKQcCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5D7AD3EA65;
	Mon, 19 Jan 2026 09:13:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OFZ/Fs/1bWnsQwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 19 Jan 2026 09:13:51 +0000
Message-ID: <41048e09-5dd9-42a6-b5d8-dadee3ecfd9c@suse.cz>
Date: Mon, 19 Jan 2026 10:13:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
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
 <aW2nlIlXFXGk4yx1@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aW2nlIlXFXGk4yx1@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7BD2A14000B
X-Stat-Signature: kgduy3ca85e3zzd45kbqqjn7qzgw9a98
X-Rspam-User: 
X-HE-Tag: 1768814033-783891
X-HE-Meta: U2FsdGVkX1/QkeencjqhcFkrw7/O7CsXtnoH4WcfLeQOz6DcJp6DFqiy2zKbTwUoDkLGN36vAETPaB+DtN5kmdjmQxdxr29IBNa1P05drJpulpKXde0FhzVwdk34ZKEVTvmRKPxWdgA4e0pcQdFXhvuWTKPlrSWP1qZLzG3GOq35a+7PM1qZUpBD9qBOlaFp0F9+6Fe7AZdY4gdB8QQP0TMFCRh9ag4pZaPyPBlUlgBpS2BPNUInM7966rfD+L4PCcJ6c9b4QTTB/1R/mZ/5u8IW1b5sIuDJABywrhHcwS22E6eqCOXh4RKczTx+Ufir+/iQarB+eKLs8XzOFQfR4AzXso3wGt2jRRZvEWqR+dbGObiQWwj0Ub1+6YaUqDtoTpvTKwvQ6sufcwPCfv4tghs/i1igpHOEaKUFPrS3tBcv3kEcEgIo3jurVWa2gOyDOM5BcoS8MWKoGwxoNqAelBgZJU7Hhy64X14/RrdaaG8xiUGhwa/inX+dSIQYQfSWpO2buQn8B6BZzU20UOdqvbhRQBxa4qzeWYMuCWw9xRNVoYArgZ41jbOGN2xT1UaEunPAIqS6qy8wX4s5K6wzEcpATq6PXqRnJjyOW/F9ys4CSDzzVRjwgXs4yRlcZdzz1/yWgNdn0AK/knvrz4nYhzgktVIVJtZN7toinDQuWi0mK91VDHyad2xRoWFD61lYN+63wroLwHe7O5+8TE9bef6jYX93V+YZ58iMSyPOIbNoleQpXN+43mvrkJgTPhO37G3lhjrxDPZT6BD6uFo78ZWTnzxm4wlllGEsakqwj2GSgwLtk18Q/5r3/Oa3ACuOyCbJrT0x8Lcvh1uYZoleAN7XXYnVsOqf4rVayoVmiHABA9JIh/mJMrz6F9xRb1wb/ESxqACv+hg6ahI5hnBSbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 04:40, Harry Yoo wrote:
> On Sat, Jan 17, 2026 at 02:11:02AM +0000, Suren Baghdasaryan wrote:
>> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>> >
>> > Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
>> > sheaves enabled. Since we want to enable them for almost all caches,
>> > it's suboptimal to test the pointer in the fast paths, so instead
>> > allocate it for all caches in do_kmem_cache_create(). Instead of testing
>> > the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
>> > kmem_cache->sheaf_capacity for being 0, where needed, using a new
>> > cache_has_sheaves() helper.
>> >
>> > However, for the fast paths sake we also assume that the main sheaf
>> > always exists (pcs->main is !NULL), and during bootstrap we cannot
>> > allocate sheaves yet.
>> >
>> > Solve this by introducing a single static bootstrap_sheaf that's
>> > assigned as pcs->main during bootstrap. It has a size of 0, so during
>> > allocations, the fast path will find it's empty. Since the size of 0
>> > matches sheaf_capacity of 0, the freeing fast paths will find it's
>> > "full". In the slow path handlers, we use cache_has_sheaves() to
>> > recognize that the cache doesn't (yet) have real sheaves, and fall back.
>> 
>> I don't think kmem_cache_prefill_sheaf() handles this case, does it?
>> Or do you rely on the caller to never try prefilling a bootstrapped
>> sheaf?
> 
> If a cache doesn't have sheaves, s->sheaf_capacity should be 0,
> so the sheaf returned by kmem_cache_prefill_sheaf() should be
> "oversized" one... unless the user tries to prefill a sheaf with
> size == 0?

I'll add a

        if (unlikely(!size))
                return NULL;

to kmem_cache_prefill_sheaf() so we don't have to deal with oversized
sheaves of size 0 just for this theoretical case...


