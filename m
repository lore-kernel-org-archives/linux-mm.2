Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF11CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B098E8E000E; Wed, 12 Nov 2025 10:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB99B8E0002; Wed, 12 Nov 2025 10:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981828E000E; Wed, 12 Nov 2025 10:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82B348E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:56:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B30F5893D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:56:25 +0000 (UTC)
X-FDA: 84102407130.22.F66C28E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id A27271A0013
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:56:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Zi+7AE/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEMfzyI7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Zi+7AE/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEMfzyI7;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSA9Dr5E9tfo4xrQ+2Wj8n1qncu7n0/mScQ8QxAnOoQ=;
	b=Qk4S4ZU48Qyh9+HmfVNT/u+2xqRBoRePL3j152uszFI75h8LI5uUO6yB3puUZu4li8FpyN
	82P98YFg28aPljG8VqsmoCVcbEc+JYRQVI32SPlLEDfbcZWwclF52We22QnF9rBsj8WtR5
	51XiYzJikojQ5lE9OxDsGDdZTilpgcQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Zi+7AE/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEMfzyI7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Zi+7AE/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nEMfzyI7;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962983; a=rsa-sha256;
	cv=none;
	b=tK9heJiJeu2TimysbPs80r8yQGfqSuub9ZlzoeaPIkPhFr1lTcTg+pgPVayPwyDHhcSSQZ
	n9ly/5ZJhIApO9Jk4yXhJNs4TGqPKpgMf22TIM7TwG5x5f2PU/IgYkojwrRFi2phZldS1F
	G565kR775051b5yF9ymLKRC5w1SopSQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 049D41F7EC;
	Wed, 12 Nov 2025 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762962980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HSA9Dr5E9tfo4xrQ+2Wj8n1qncu7n0/mScQ8QxAnOoQ=;
	b=Zi+7AE/zfIqZQKcZQWQgC4brl8dA0tQS8lt5kCVzWKi4FVsl4458yYXjCG1zh9sTynqeV/
	liY1uz8Ys1Qd7rQ+2GFxkNyXksf3rZXJ4k8VDq7IhIBtYjHnTtlnezgCwRmlz3HtQY/+l6
	AKpH/88XKOBU0ZJOVN051jHCOzHhP1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762962980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HSA9Dr5E9tfo4xrQ+2Wj8n1qncu7n0/mScQ8QxAnOoQ=;
	b=nEMfzyI7kZRUYI+9owCtb3ngDk4pGLU7xRD24sFEIc9/4Wi8y8qnKCVtYnX3NgurK0pd2K
	Jcbjjypa2sEj7qDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762962980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HSA9Dr5E9tfo4xrQ+2Wj8n1qncu7n0/mScQ8QxAnOoQ=;
	b=Zi+7AE/zfIqZQKcZQWQgC4brl8dA0tQS8lt5kCVzWKi4FVsl4458yYXjCG1zh9sTynqeV/
	liY1uz8Ys1Qd7rQ+2GFxkNyXksf3rZXJ4k8VDq7IhIBtYjHnTtlnezgCwRmlz3HtQY/+l6
	AKpH/88XKOBU0ZJOVN051jHCOzHhP1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762962980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HSA9Dr5E9tfo4xrQ+2Wj8n1qncu7n0/mScQ8QxAnOoQ=;
	b=nEMfzyI7kZRUYI+9owCtb3ngDk4pGLU7xRD24sFEIc9/4Wi8y8qnKCVtYnX3NgurK0pd2K
	Jcbjjypa2sEj7qDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4F0E3EA61;
	Wed, 12 Nov 2025 15:56:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uWaTNyOuFGmwCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 15:56:19 +0000
Message-ID: <4b72bcad-5174-49c7-ad90-63a9c312df0b@suse.cz>
Date: Wed, 12 Nov 2025 16:56:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mempool: add mempool_{alloc,free}_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251111135300.752962-1-hch@lst.de>
 <20251111135300.752962-8-hch@lst.de>
 <c691c9c1-a513-4db3-95f6-3d24111680b7@suse.cz> <20251112154754.GB7209@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251112154754.GB7209@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A27271A0013
X-Stat-Signature: ha9kmkh6mk4jr9tinb1qdyrftjh9gcsb
X-Rspam-User: 
X-HE-Tag: 1762962982-44925
X-HE-Meta: U2FsdGVkX18eSeRoWYPDrrJ/USayBLauY792l+//XV8BVkZOO1XK3fKMzibovy4D+t7RBTWIK0lNSZHCyNLfRbFA8y0ySL/odUmK7fCPJ/WGh8nfukMtAx6sSyHmr/VluiOXUXMyqWkLBgv5SrneKVqcTTe7Zr6qZ6pyjF2kSkQ0MTrQ2YwGkCgeS97m5gNFvqHLF5/XHf+ej161AOkeLVm37w/v+eVjuMSBlQsiMw2ow1ul480OthE2QF/rXdiorw0JX1x8NJMw/miyNbq8n792nz3WbcGSGtz0wODLVzvJgGTbMNwsZ8mP0PzziqF+uNHBJBOPdu6U+JmxKmaK7gpgMSXlZfmK2HAC5WMZlQQp1m3Wsxbk0rp7kAcAkWaIVvt6xn9soSou1bsObCPBn2Ds7hRpUMPm19Egrp9t68eAWojvsp4k3Deh+GI7L1iO1OO3kFr3AGlnrIxXv/9TmSvth9huPPbBZKgJrFpMfrbIcQ/mcSRAuHF9F7hFw6NbADL7rlfymbYnofUQJmxplmM9oYcARhd3iS0DSJSMwlozvWyomxb5yBKywWkXPYUhX0IgRUvtENv9Vm+fZVez6XdpgvoOMGDnh93kc9EeoEEo8oclqqWPObxgQDLPaaHwk4ABSh0Nokrh5IDVxGRSJnRoDEHrA+W+Va/WdBKEXFXwnyA9LRMMeKYA3Z/qPu06D+qG7wGuRxS4ZPk4q3InlIcfRbg+Wpz3BtxWT0lYgwREaZmbQ/fSLxn34Q3qqlS+OQT5zOTty7H74h3N5AXmxyx6jzBZptEGZswx/HdhO8KU9tm2aUoibx6yOnsGyZGZZyNh/vphKrSMvsIe4tc/uiD1hlJLNv+uOhmZbZ7GCw4gbaBE/i6+XiNPH7ziwFcCeVbZA5vTVX/YR9VAZuTTneSvAJHCrcQ4EyiT5U5cTVubhMu2pcQev9MyAAsv8K6gcPnR0GRIgeMOtWcFRoU
 SzqEelGb
 rOD8h6QmWtvM90uJ5TkuDcmqd//hboEMwcwIXaP4Meo7CJegDgOUY5K7qOad5rH1guoaxq4dXT13ew1wpTKcETtHpG9Vm6gJC25Zf66fcKCOZd7fK1a+c1n7FG/1KVIrx/Tb2llD8LRRsaTEUy97fdMTCNyFrEqlZjp9QaiEo051MbTMX5HLMyGq2Y3VPHDY5Izjvyo0+l3n4S08vWrxEogwqujNFeYPrjdG3uslxcqpABSqsMvfZ7q0NDt4+4w+FrNi6tv8osateF99E9QRr1d+ekCm8g+VS9Ts21rFa5PmAodJgdGhNzypfo10P2tjb9t5P8dpf6pYcktQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/25 16:47, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 01:20:21PM +0100, Vlastimil Babka wrote:
>> > +	if (IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc", NULL,
>> > +			&fail_mempool_alloc)) ||
>> > +	    IS_ERR(fault_create_debugfs_attr("fail_mempool_alloc_bulk", NULL,
>> > +			&fail_mempool_alloc_bulk)))
>> > +		return -ENOMEM;
>> 
>> Pedantically speaking the error (from debugfs_create_dir()) might be
>> different, probably doesn't matter in practice.
> 
> Yeah, this is an initcall, so the exact error really does not matter.
> But adding an error variable isn't that annyoing, so I'll switch to
> that.
> 
>> >  	unsigned long flags;
>> > -	void *element;
>> > +	unsigned int i;
>> >  
>> >  	spin_lock_irqsave(&pool->lock, flags);
>> > -	if (unlikely(!pool->curr_nr))
>> > +	if (unlikely(pool->curr_nr < count - allocated))
>> 
>> So we might be pessimistic here when some of the elements in the array
>> already are not NULL so we need in fact less. Might be an issue if callers
>> were relying on this for forward progress? It would be simpler to just tell
>> them not to...
> 
> Yes.  I think alloc_pages_bulk always allocates from the beginning
> and doesn't leave random holes?  That's what a quick look at the code
> suggest, unfortunately the documentation for it totally sucks.

Yeah I think it's fine with alloc_pages_bulk. It would only be a concern is
the bulk alloc+mempool user used up part of the allocated array, NULLing
some earlier pointers but leaving later ones alone, and then attempted to
refill it.

>> > + * @pool:	pointer to the memory pool
>> > + * @elems:	partially or fully populated elements array
>> > + * @count:	size (in entries) of @elem
>> > + * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.
>> 
>> We should say __GFP_DIRECT_RECLAIM is mandatory...
> 
> It's not really going to fit in there :)  Maybe I should have ignored
> Eric's request to mention __GFP_ZERO here and just keep everything
> together.

I thought it can be multiline, but if not, can refer to the notes below and
explain there, yeah.

>> > +repeat_alloc:
>> > +	/*
>> > +	 * Try to allocate the elements using the allocation callback.  If that
>> > +	 * succeeds or we were not allowed to sleep, return now.  Don't dip into
>> > +	 * the reserved pools for !__GFP_DIRECT_RECLAIM allocations as they
>> > +	 * aren't guaranteed to succeed and chances of getting an allocation
>> > +	 * from the allocators using GFP_ATOMIC is higher than stealing one of
>> > +	 * the few items from our usually small pool.
>> > +	 */
>> 
>> Hm but the code doesn't do what the comment says, AFAICS? It will try
>> dipping into the pool and might succeed if there are elements, only will not
>> wait for them there?

> Yeah, that comment is actually stale from an older version.
> 
>> 
>> > +	for (; i < count; i++) {
>> > +		if (!elems[i]) {
>> > +			elems[i] = pool->alloc(gfp_temp, pool->pool_data);
>> > +			if (unlikely(!elems[i]))
>> > +				goto use_pool;
>> > +		}
>> > +	}
>> > +
>> > +	return 0;
>> > +
>> > +use_pool:
>> 
>> So should we bail out here with -ENOMEM when !(gfp_mask & __GFP_DIRECT_RECLAIM)?
> 
> No, I don't want the !__GFP_DIRECT_RECLAIM handling.  It's a mess,
> and while for mempool_alloc having it for compatibility might make some
> sense, I'd rather avoid it for this new interface where the semantics
> of failing allocations are going to be really annoying.

OK.

>> > +	if (!mempool_alloc_from_pool(pool, elems, count, i, gfp_temp)) {
>> > +		gfp_temp = gfp_mask;
>> > +		goto repeat_alloc;
>> 
>> Because this seems to be an infinite loop otherwise?
> 
> You mean if someone passed in !__GFP_DIRECT_RECLAIM and got the warning
> above?  Yes, IFF that code makes it to production and then runs into
> a low-memory situation it would.  But it's an API abuse.  The other
> option would be to just force __GFP_DIRECT_RECLAIM.

True, so let's ignore it.



