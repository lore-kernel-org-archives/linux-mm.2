Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3453ED340BB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7648A6B0088; Tue, 27 Jan 2026 11:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B996B0089; Tue, 27 Jan 2026 11:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DB16B008A; Tue, 27 Jan 2026 11:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 515DC6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:49:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00F7013A3B6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:49:16 +0000 (UTC)
X-FDA: 84378329154.15.4C81882
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D66240011
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:49:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxTuCuTz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meY4jLiB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxTuCuTz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meY4jLiB;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769532554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVPzjDhsLmzRydt/bW/u19lXQFWf/7UL4OeT4KXrjI4=;
	b=2j4R6KuD51s88akTYo5hqO08u1F0+nyqJjO6ClqVFZ67i38JceqwKx8hkahDqa3uOVZIoe
	fbtuCN3Z9HWp2Xh4pbD4cHYXxH5RhKBOgiz8k6zvOf0RPowogPATNJRc+kYrSu78FUrL4k
	xjRfQNGnwfKJljn2bXhZ3wrNvsO2A5c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxTuCuTz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meY4jLiB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxTuCuTz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=meY4jLiB;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769532554; a=rsa-sha256;
	cv=none;
	b=0vyQo8PcenKbTLWFp9xZAitOH3XIK3poJQ4dUg+tbOjshNzgbamdXdjahEqpCfYIH7gQcb
	DMqLC0I6A0zYF/cNrTFn9nvh26GKzpv+fAhV5g+CHhRSdkD6Aox318TuoryIq7RexvTPmm
	fegzp/WsK3V4R0ViY0MRxPj6zFWdcnE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BCCA337CB;
	Tue, 27 Jan 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769532552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YVPzjDhsLmzRydt/bW/u19lXQFWf/7UL4OeT4KXrjI4=;
	b=FxTuCuTz1uliLmY9udBn8ioYanBR7vmVHNhrUyAu3XPUyM3yk+xQabQdDQ6xNvA5DRN4qQ
	4PnR23eUnsqeWsMXCbEP5U3tWhnGRsAZTPGlMj0/QQEgabzGU78WSCVT7XMG/m1ctr+lpw
	q7nEtqbC2FoZN0uvl29F25e+dZbSR1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769532552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YVPzjDhsLmzRydt/bW/u19lXQFWf/7UL4OeT4KXrjI4=;
	b=meY4jLiBWscrszgQc3UFiqM9E3RR2wX2n3rXRnio4pwkYBi0h66FCFMuJGPXL+zgqCBG8B
	7vnH315SPgq56QCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769532552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YVPzjDhsLmzRydt/bW/u19lXQFWf/7UL4OeT4KXrjI4=;
	b=FxTuCuTz1uliLmY9udBn8ioYanBR7vmVHNhrUyAu3XPUyM3yk+xQabQdDQ6xNvA5DRN4qQ
	4PnR23eUnsqeWsMXCbEP5U3tWhnGRsAZTPGlMj0/QQEgabzGU78WSCVT7XMG/m1ctr+lpw
	q7nEtqbC2FoZN0uvl29F25e+dZbSR1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769532552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YVPzjDhsLmzRydt/bW/u19lXQFWf/7UL4OeT4KXrjI4=;
	b=meY4jLiBWscrszgQc3UFiqM9E3RR2wX2n3rXRnio4pwkYBi0h66FCFMuJGPXL+zgqCBG8B
	7vnH315SPgq56QCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 397EE3EA61;
	Tue, 27 Jan 2026 16:49:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bZKxDYjseGnsTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 16:49:12 +0000
Message-ID: <62706310-5144-4edf-8377-540ee947181f@suse.cz>
Date: Tue, 27 Jan 2026 17:49:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] mm/slab: factor out slab_args_unmergeable()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Hai Li <hao.li@linux.dev>, linux-mm@kvack.org
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-2-harry.yoo@oracle.com>
 <f6b85926-04b6-4c02-a6f2-1e141c9426b0@suse.cz> <aXjq99QW3EzOuyYP@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXjq99QW3EzOuyYP@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: 6trkgou3i7dk7cfknsdoz6whmqbtah1h
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D66240011
X-HE-Tag: 1769532554-766646
X-HE-Meta: U2FsdGVkX18FLGtGGzcAmuYkJG7sx+L9CizQkG6AI/ukxmFJdXmJL6UQOLrIsrHp0piBE6vA7h58YOpWumy8W8Atv5K5WzGkF3ITel5/W09l4GFGz1dvQrx/fzTnUgF8eruJ8ZyrHEUmO6nnhhmxpR6367l8+nzOb4IqUhml8ARzBb1hEtNf4OD2v40PsZGEhOY9bEb8464oJoeBR62iqwzRrnCewbrEyY56SHLqRZ8v8cPowYKzZgT2pLHvoEjRBeQWCYJIJwUq6zy0063sUft5GHqQRu3+2XNEhtpHoYCRJ2akLuWer5LhRnoylnnuHVWpYl0MIdOgF8o1vTCfV/AZ+pu4a1p+bIbvVXmfITfj+fpVLmESVAqi5ygptnPaTXI/0+FWh+3pMDPmGdfHuJQRbdUDWwb9pUlbk/q2abwBl34fSWNMHPqERlM6zrHIJg6cdsDcTtba9eqCqL3s4fddrE5MBZB+Slm8dui/IU1s2ynMA7w1eeJfptecda98kubM8G4cQBcwqhvkGGL6f1KJAO2GtspdHumJ1e7W54SeIXLR3T4DTuthjZS1bXR26/QGbMEPXDM85xehOVD3afLudrgvWrgzU2ooLbEOSQXC1ppMsTMu99Y8huwmcR4rkzMKbpbJUjzTWl1WhqbxX0zbbZ67l6fKWmem1KVTmKjncixbbpG/OWFv4/pNU42xbWJkfWnmYrG0Oc9d+PWO3mDY3kXSA8XCg20FW0rGIqsCGQFw3G0DwnZrOzGUBpjfc17JQl9ygpS8Qk0PRju1RHIgb83urvpM456GNJiThyAfO0Xc1ckiIV3LXh3tm1dquGlF1wMgrJJW8AoOZjm9ccmtPl4TOEib72QUuTSl06PAuHuzj+OUCOYClEMSgvZse+M82wdmKO/ofhIFDpexu5nYyZvVTGJkWOQD2tqXWZ8CDvAtLgI9fsJdDSBAHNsXanwoeF2lgwEhOr95LX5
 rXq4ZIUa
 NPjgEB3RECbK7IKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 17:42, Harry Yoo wrote:
> On Tue, Jan 27, 2026 at 05:35:50PM +0100, Vlastimil Babka wrote:
>> On 1/27/26 11:31, Harry Yoo wrote:
>> > slab_mergeable() determines whether a slab cache can be merged, but it
>> > should not be used when the cache is not fully created yet.
>> > 
>> > Extract the pre-cache-creation mergeability checks into
>> > slab_args_unmergeable(), which evaluates kmem_cache_args, slab flags,
>> > and slab_nomerge to determine if a cache will be mergeable before it is
>> > created.
>> > 
>> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> > ---
>> >  mm/slab_common.c | 28 ++++++++++++++++++----------
>> >  1 file changed, 18 insertions(+), 10 deletions(-)
>> > 
>> > diff --git a/mm/slab_common.c b/mm/slab_common.c
>> > index 2e80d323f550..904414c3ebb8 100644
>> > --- a/mm/slab_common.c
>> > +++ b/mm/slab_common.c
>> > @@ -174,24 +174,32 @@ int slab_unmergeable(struct kmem_cache *s)
>> >  	return 0;
>> >  }
>> >  
>> > -static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
>> > -		const char *name, struct kmem_cache_args *args)
>> > +static bool slab_args_unmergeable(struct kmem_cache_args *args,
>> > +				  slab_flags_t flags)
>> >  {
>> > -	struct kmem_cache *s;
>> > -	unsigned int align;
>> > -
>> >  	if (slab_nomerge)
>> > -		return NULL;
>> > +		return true;
>> 
>> I think this still logically belongs to find_mergeable() and not here, so
>> moved there. Agreed?
> 
> But then patch 2/2 should be modified to check slab_nomerge then?

Yeah I would do that as well,

> And even slab_unmergeable() does slab_nomerge check, so perhaps it's
> more consistent to do it in slab_args_unmergeable().

But this is true so I'll leave both as you did, thanks!



