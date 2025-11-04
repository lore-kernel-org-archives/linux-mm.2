Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7CBCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75C38E0127; Tue,  4 Nov 2025 05:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4DC38E0124; Tue,  4 Nov 2025 05:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D637A8E0127; Tue,  4 Nov 2025 05:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C531C8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:24:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6232113AF6B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:24:35 +0000 (UTC)
X-FDA: 84072540510.11.91A3B45
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 16ABD1C0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:24:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F22ZyU0O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dEnDLU+I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F22ZyU0O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dEnDLU+I;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762251873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUST+k1U2v9lp03HQYKCUSRvVl3dhQ0RkvE1dYJyp1o=;
	b=a+aH26V7/eTeot3F11iWA4o8YNgtemCDJZxketObJKpZQorPsy28PkM9W38+U3yFmvuQmo
	RMU3xNu/tKIEnMVaUEfWgnxdyMLPYjSBJyzFJyNF6VVFO71Sy4bTMCR6m9/M3hOZeXYLzA
	HrR1EHTHX1xCazFCKMXKWAwHuKUr5D4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762251873; a=rsa-sha256;
	cv=none;
	b=TEBJzx/nR41JL9sAKo6Y7iOJv2BQ3NIX5ssfKoVNHhXm7G4ExqPlP/D3hG8LnCe24GiVM4
	LINj0uKR2NmiTEMxies4Wj/FcTioQyjmtjWwK+m619Zx4sxpFUnQeXRUv46Z3yZ4jgm8f8
	1Imw4oiQicF5KM7LxkmuEPTIdqFrb5A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F22ZyU0O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dEnDLU+I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F22ZyU0O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dEnDLU+I;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 327021F387;
	Tue,  4 Nov 2025 10:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762251871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUST+k1U2v9lp03HQYKCUSRvVl3dhQ0RkvE1dYJyp1o=;
	b=F22ZyU0OIGfXA1u0JS5EOCFYZyKpvScHY10HJUuFKjT6B5JHaDP4ESwA5uodFGiDjuxoG1
	CYY22Vg4A9ObiRMF49kJNWO9EJEd6YG3L8Mwn7D6HpvCvRrlFKU+xXF1yF+LGYBEpzmvSa
	mak0CaKaLl5LBOkp1JjFXu5jS+4G5N0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762251871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUST+k1U2v9lp03HQYKCUSRvVl3dhQ0RkvE1dYJyp1o=;
	b=dEnDLU+IQsczLobueRkov04DKkoK6RLqFABHB2TaJN9RLqxNp7+ee6pWLzBhn5d+eFlbXe
	u94X+Qt7X8IvyPCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762251871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUST+k1U2v9lp03HQYKCUSRvVl3dhQ0RkvE1dYJyp1o=;
	b=F22ZyU0OIGfXA1u0JS5EOCFYZyKpvScHY10HJUuFKjT6B5JHaDP4ESwA5uodFGiDjuxoG1
	CYY22Vg4A9ObiRMF49kJNWO9EJEd6YG3L8Mwn7D6HpvCvRrlFKU+xXF1yF+LGYBEpzmvSa
	mak0CaKaLl5LBOkp1JjFXu5jS+4G5N0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762251871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUST+k1U2v9lp03HQYKCUSRvVl3dhQ0RkvE1dYJyp1o=;
	b=dEnDLU+IQsczLobueRkov04DKkoK6RLqFABHB2TaJN9RLqxNp7+ee6pWLzBhn5d+eFlbXe
	u94X+Qt7X8IvyPCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 253AD136D1;
	Tue,  4 Nov 2025 10:24:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T53hCF/UCWktUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 04 Nov 2025 10:24:31 +0000
Message-ID: <f59e2a0e-1da3-4670-84ee-679c2001f58f@suse.cz>
Date: Tue, 4 Nov 2025 11:24:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with
 debugging
To: Dev Jain <dev.jain@arm.com>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
 <5bb311a5-b59f-4897-b4d0-4e06d7d2b3f2@arm.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <5bb311a5-b59f-4897-b4d0-4e06d7d2b3f2@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 16ABD1C0006
X-Stat-Signature: dmzahbb6amsdbta46p17b5ny4xkzb5qm
X-HE-Tag: 1762251872-439612
X-HE-Meta: U2FsdGVkX18TNcW9CsGu0EIyHN+scr51DUzvdKROmWT9zdwIhCJBS8i9iFtC7wz8KcWXkkp6t0/DC0yxGtOLQ/SW1Lzv3Vm7RL25T6JNPIudJp/0/r5jgzIVIdjNRdqz3KOZH4qe6UkrWlphsS+E6c/VMpJ9X+QqF3bNy6xc1nLWC2YbjZ7MuGkL5x4jBfEaZ3JWBomPoz+gFR1k0tElTpHD6A1NTCIeligjNUTXdQSqLWmMmbZuQyYOJi72ElntQPeeIhZkjwKlcEr4x+Npf8irzh3AWfpdi1HbMUOVi2SI+OFn0TxQ5wlnO/Sumkl/V6YTmL1Sn6/uyh8FmmMj7OzNHP4cet4l0RNPnxHb/CbADKLHGKEGBuPgSHAdP/J0ODOH9hn7JuQH4Lacx0V5kNxuJW5VVU/LgNNDhVilppdFIemS5TFOvd6GVdiuGyezSzyP1ZOSoAWrNIjMNzLG+v9JzL/K+E06KInZP9CXbVUJb73q6tGPxxtAExsoggkf1mjJvMIbI4zlq+YRorzwMZwbBRC/UESdy0IAIw0MUb8KHTq7hSp0Hv/83dmohPb7yBOSZgCYBeNB3SU7q9ebRMVdLo9J48A4JJ9hqBiBcUq2BeH9lkXy2iCDPfMvaxBLP2MM+w/HzK0qZSe2BTUH9/o6uj4juMGw3B1QXJCbRg1Cm9RurH88kUYAoKlipDuVQFd6FhwmbX1+5HA/QVBr9UBCOX+c+ne98xIM1NUAwrEyp1XPoB4M7f+HBQwIazsTzFTDPFFqD9aW1V8BI95ppqkfmXjI2/GO+GonnBXNKI47M7qqLGU0NOl6nhNCvcLfWdWf3+5HX+KXMG1bSJ7KNhpi8ikFxOuu6yi2WWx1KXXtCL+HptwalKDqfAoMQ8EeV4cSPnHXkpfT++JcAFcvOSrUtUtPJagEI/uSfyYhCFIjJLfCIl+EUdy/oILkyekLlVa28mphaqnY8l7Gvca
 BrnalCXi
 y438iXegGvQBqFdQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/4/25 6:26 AM, Dev Jain wrote:
> 
> On 03/11/25 5:54 pm, Vlastimil Babka wrote:
>> In review of a followup work, Harry noticed a potential infinite loop.
>> Upon closed inspection, it already exists for kmalloc_nolock() on a
>> cache with debugging enabled, since commit af92793e52c3 ("slab:
>> Introduce kmalloc_nolock() and kfree_nolock().")
>>
>> When alloc_single_from_new_slab() fails to trylock node list_lock, we
>> keep retrying to get partial slab or allocate a new slab. If we indeed
>> interrupted somebody holding the list_lock, the trylock fill fail
> 
> Hi Vlastimil,
> 
> I see that we always take n->list_lock spinlock by disabling irqs. So
> how can we interrupt someone holding the list_lock?

From a NMI or e.g. a kprobe->bpf hook, which are the use cases for
kmalloc_nolock(). The word "interrupt" thus doesn't mean IRQ, but I'm
not sure which word would be better. "Preempt" would be perhaps even
more potentially misleading.

> If we are already in a path holding list_lock, and trigger a slab
> allocation
> and recursively end up in the same path again, we can get the situation
> you mention, is that possible?

There shouldn't be such recursion in the code itself, in the absence of
NMI/kprobe/etc.
>> deterministically and we end up allocating and defer-freeing slabs
>> indefinitely with no progress.
>>
>> To fix it, fail the allocation if spinning is not allowed. This is
>> acceptable in the restricted context of kmalloc_nolock(), especially
>> with debugging enabled.
>>
>> Reported-by: Harry Yoo <harry.yoo@oracle.com>
>> Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
>> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and
>> kfree_nolock().")
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>> as we discussed in the linked thread, 6.18 hotfix to be included in
>> slab/for-next-fixes
>> ---
>>   mm/slub.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index d4367f25b20d..f1a5373eee7b 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4666,8 +4666,12 @@ static void *___slab_alloc(struct kmem_cache
>> *s, gfp_t gfpflags, int node,
>>       if (kmem_cache_debug(s)) {
>>           freelist = alloc_single_from_new_slab(s, slab, orig_size,
>> gfpflags);
>>   -        if (unlikely(!freelist))
>> +        if (unlikely(!freelist)) {
>> +            /* This could cause an endless loop. Fail instead. */
>> +            if (!allow_spin)
>> +                return NULL;
>>               goto new_objects;
>> +        }
>>             if (s->flags & SLAB_STORE_USER)
>>               set_track(s, freelist, TRACK_ALLOC, addr,
>>
>> ---
>> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
>> change-id: 20251103-fix-nolock-loop-854e0101672f
>>
>> Best regards,

