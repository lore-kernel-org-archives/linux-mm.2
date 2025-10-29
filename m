Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5ED1CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF678E010F; Wed, 29 Oct 2025 18:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1867D8E0106; Wed, 29 Oct 2025 18:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074788E010F; Wed, 29 Oct 2025 18:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA7E98E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:31:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 759E5887C4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:31:34 +0000 (UTC)
X-FDA: 84052599708.17.850AEB4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2030C140012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:31:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3Ch5U8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9EvsHW0P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3Ch5U8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9EvsHW0P;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761777092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh8+yU8fmyt+6MD4ipOXHynaGNBJYzYXvAUebA2Mox0=;
	b=0vm9NZd1hv4CFkqhXouCIm3wdGBh9JaBBvCDQx58hlcTo3jjN6FUP/Xy7PZaH2gWzHWMS5
	ypOPZgL1WPz5MtOTg/p5mLlKZgKgZ91a3orhH7Ly2d+kL53E5X7IlZ0REV5Ul1LP/eub5j
	+5xa0DfKaHtUjsRCnT6SMtokEJBkzs0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3Ch5U8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9EvsHW0P;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z3Ch5U8f;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9EvsHW0P;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761777092; a=rsa-sha256;
	cv=none;
	b=j1QnVupEkd8Xiby+R5OEfkH9N39eXtTs1D6szdyzUP2uuzOdK2JAkUbYwHYGq5b7hQ69VJ
	843a1d+THT5hwn2SWdduekJvKT6VYqUOou8CqEGtoVrcksnE22w/rhxnywSWiebSNr417k
	WFjcMPg5RC9US6kCENYuYdzDn/x1ua4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8EDBB5CB0F;
	Wed, 29 Oct 2025 22:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761777090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dh8+yU8fmyt+6MD4ipOXHynaGNBJYzYXvAUebA2Mox0=;
	b=z3Ch5U8fPmN90eBEJ2w+yjBdJEK6r5CXo7K3SpBXvOMynjVUjuEDfDORPVez0hsrXt04uZ
	8oRPfCDQghzdvHof3qUFE4VCLD8RRr1ET2ucb4/cHqFUI6Bk7DrX+l2SU9u8fwYySX8AM/
	wBMU9bC4H/bmsID1qVF38PdpQkaynus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761777090;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dh8+yU8fmyt+6MD4ipOXHynaGNBJYzYXvAUebA2Mox0=;
	b=9EvsHW0PpZFX3GjwUziMQJFfTwUcvegUJ6rn0nKLe9sVgEvkK5VQaoWbD3NqMBVRvheI14
	CHp/XTgKyL+6CHDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761777090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dh8+yU8fmyt+6MD4ipOXHynaGNBJYzYXvAUebA2Mox0=;
	b=z3Ch5U8fPmN90eBEJ2w+yjBdJEK6r5CXo7K3SpBXvOMynjVUjuEDfDORPVez0hsrXt04uZ
	8oRPfCDQghzdvHof3qUFE4VCLD8RRr1ET2ucb4/cHqFUI6Bk7DrX+l2SU9u8fwYySX8AM/
	wBMU9bC4H/bmsID1qVF38PdpQkaynus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761777090;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dh8+yU8fmyt+6MD4ipOXHynaGNBJYzYXvAUebA2Mox0=;
	b=9EvsHW0PpZFX3GjwUziMQJFfTwUcvegUJ6rn0nKLe9sVgEvkK5VQaoWbD3NqMBVRvheI14
	CHp/XTgKyL+6CHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D7111349D;
	Wed, 29 Oct 2025 22:31:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yRNXGsKVAmluCAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 22:31:30 +0000
Message-ID: <df8b155e-388d-4c62-8643-289052f2fc5e@suse.cz>
Date: Wed, 29 Oct 2025 23:31:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 11/19] slab: remove SLUB_CPU_PARTIAL
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-11-6ffa2c9941c0@suse.cz>
 <CAADnVQKBPF8g3JgbCrcGFx35Bujmta2vnJGM9pgpcLq1-wqLHg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQKBPF8g3JgbCrcGFx35Bujmta2vnJGM9pgpcLq1-wqLHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2030C140012
X-Stat-Signature: wznu7aj3khm4bqj7o9rf3egd4tctmo6a
X-Rspam-User: 
X-HE-Tag: 1761777091-942562
X-HE-Meta: U2FsdGVkX1+Sw00lW0NO85wb6/EhTtbcPtDapemd05uUvUk/CNaa7DnrsxHurS12+T45uDncE2DpBhG+isc1jzHEnNatEjHFL1jzbEX6rMeJRJDj39nhomv7P5WQx4/Hj+k02yLi7E1sC0PtEo3haU19n13cWukwILTFwJtlyVgaBun66POnxSKuiCNlhVGiSQSCpzMhcPTazv2Of7ZYPCdxNep9luLnAMyKv8EItKaflKrU97mUW4PGwJVV+keux8XDiTgasek/GOEEFyBP6msnQt5Dw7jmbpm1talxY1DEolvodjEkMzze8EtRvH6mloqRc8byDr6gNoXga87KhHRLR3c3/vy7It6kfjQU3+PZRHkGVDk+3/durZkkwt8vC0Xo//aTIEQJ8HVeZPSKj+Tdh/uQXroHBoSSlMM1yMfrtr0KrDNDMZ68jQUSZU1uorvGcLh0Q91sCs/kCunFGeWd48sbZhMgqyzHx9IfPO7bUsEq3ZF0mLwACvJVkt1hIUmYA5LYDGM75jrdPoIPoLJMWTjVh5SJTa3o6utOXZC20mTHbB4rnOZ0H1r6mTBweg2sx4pyPKqmILW6dA83JrxTRhYtNcmilkgEW81GOaV7XIM1ynG2VBPPuMdKdgi5cOIMbt3hZ1XpmL6S2jUf0jC3UIvuNkISvNS7zVSaFUK96i9XbCvLTNa54ADnHRiN6/FrDpoWOWx8hjp3bwXAfpJdIeK2PYxTxLFB8wyM/F9aysazK3c3grIhJ+lR+B3NEr4r00Z5Jf8zqTsxMj5q4A1MaUcWwZ0drFsyxg+MobHLLF0E7tDa8Dtn/sc3ATEpLFnmX5rdlgfoJX2MAjlku6RegtlzH7+yOiIqWd72c1lYUjvuGoZ1T6HFBayO/x+APBFpWNiJcXaUSDXXM6qvsVfnVjOAIevQNGGjY9rdi6EKfNcFj5dvCD9s71aZ7IYJya8CEvI32wM2qxNAkUR
 HLOQKInp
 yIlYYj925RyF16rK8g4QblV3P99VNdFhGSSUh1tiAA+G8f5BZh6ualMa4gdtJsBB5fwFqgzfMEYw6ZK5eHlYphNd7iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:43, Alexei Starovoitov wrote:
> On Thu, Oct 23, 2025 at 6:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>>  static bool has_pcs_used(int cpu, struct kmem_cache *s)
>> @@ -5599,21 +5429,18 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>>                 new.inuse -= cnt;
>>                 if ((!new.inuse || !prior) && !was_frozen) {

This line says "if slab is either becoming completely free (1), or becoming
partially free from being full (2)", and at the same time is not frozen (=
exclusively used as a c->slab by a cpu), we might need to take it off the
partial list (1) or add it there (2).

>>                         /* Needs to be taken off a list */
>> -                       if (!kmem_cache_has_cpu_partial(s) || prior) {

This line is best explained as a negation. If we have cpu partial lists, and
the slab was full and becoming partially free (case (2)) we will put it on
the cpu partial list, so we will avoid the node partial list and thus don't
need the list_lock. But that's the negation, so if the opposite is true, we
do need it.

And since we're removing the cpu partial lists, we can't put it there even
in case (2) so there's no point in testing for it.
> I'm struggling to convince myself that it's correct.

It should be per above.

> Losing '|| prior' means that we will be grabbing
> this "speculative" spin_lock much more often.
> While before the change we need spin_lock only when
> slab was partially empty
> (assuming cpu_partial was on for caches where performance matters).

That's true. But still, it should happen rarely that slab transitions from
full to partial, it's only on the first free after it became full. Sheaves
should make this rare and prevent degenerate corner case scenarios (slab
oscillating between partial and full with every free/alloc). AFAIK the main
benefit of partial slabs was the batching of taking slabs out from node
partial list under single list_lock and that principle remains with "slab:
add optimized sheaf refill from partial list". This avoidance of list_lock
in slab transitions from full to partial was a nice secondary benefit, but
not crucial.

But yeah, the TODOs about meaningful stats gathering and benchmarking should
answer that concern.

> Also what about later check:
> if (prior && !on_node_partial) {
>        spin_unlock_irqrestore(&n->list_lock, flags);
>        return;
> }

That's unaffected. It's actually for case (1), but we found it wasn't on the
list so we are not removing it. But we had to take the list_lock to
determine on_node_partial safely.

> and
> if (unlikely(!prior)) {
>                 add_partial(n, slab, DEACTIVATE_TO_TAIL);

This is for case (2) and we re adding it.

> Say, new.inuse == 0 then 'n' will be set,

That's case (1) so it was already on the partial list. We might just leave
it there with n->nr_partial < s->min_partial otherwise we goto slab_empty,
where it's removed and discarded.

> do we lose the slab?
> Because before the change it would be added to put_cpu_partial() ?

No, see above. Also the code already handled !kmem_cache_has_cpu_partial(s)
before. This patch simply assumes !kmem_cache_has_cpu_partial(s) is now
always true. You can see in __slab_free() it in fact only removes code that
became dead due to kmem_cache_has_cpu_partial(s) being now compile-time
constant false.

> but... since AI didn't find any bugs here, I must be wrong :)
It's tricky. I think we could add a "bool was_partial == (prior != NULL)" or
something to make it more obvious, that one is rather cryptic.

