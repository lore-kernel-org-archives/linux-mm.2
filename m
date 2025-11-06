Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEA7CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499C28E0014; Thu,  6 Nov 2025 09:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470FB8E0002; Thu,  6 Nov 2025 09:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386948E0014; Thu,  6 Nov 2025 09:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2768A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:57:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1958140124
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:57:17 +0000 (UTC)
X-FDA: 84080485314.29.8507569
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AEBB1A000D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:57:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tlr7txt2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+E8gymJw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tlr7txt2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+E8gymJw;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441035; a=rsa-sha256;
	cv=none;
	b=4hJSl1dF4h36CgbYBffluVk4ANIeyM04bnWBLNupqSyYW8VYW5KWPJj68kGxOAXHY+rBcM
	0f6kzYBYb4HtfIOzLp+fbpzKns5yoTxwlBt+XL+wt/4Gd9VIGCPrRoABg4uUz1w8gdAT/M
	XuJhACve1ZnhZPrzB8LiQGz0OU8y+zk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tlr7txt2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+E8gymJw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tlr7txt2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+E8gymJw;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFfsS/NRuyrY1q4COHS7QrBquvacCQPEpJ6EDB+xD64=;
	b=4EvklNc46tlUlF2Hh0NLDbg33rR60t0Mi/zP2bsn8feLut4+HV7PRaryyVnaRcAPAFK+O4
	/0pcCPlpfqHdG2Z1rESOjNpIR++Mvf1RggtXa621G44+N8xvkReOmneJA3FataJCB51Q9i
	pexsOgMSxaN5Oao3DRBQRLys8pIfrhw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CEC0A211EE;
	Thu,  6 Nov 2025 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762441033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lFfsS/NRuyrY1q4COHS7QrBquvacCQPEpJ6EDB+xD64=;
	b=tlr7txt2adQdrktVMMpU6KoF1X8lIGjzyP8cNO9QE1eFC/z5f/6gCLRFiG8z52COgJqfb1
	da3kKIP+066yF3VcMmOIpLFqaBfMmjTtWWYm901z2hzg96qywF1fb/oMsYS12j3fT7re63
	/z54T/+hiA+uVmyfdbUeW7L8O7oZ6Sw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762441033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lFfsS/NRuyrY1q4COHS7QrBquvacCQPEpJ6EDB+xD64=;
	b=+E8gymJwhspAFJqZIwgR5pEC1GSmcd7WKfoMSmyJ3nUddAz1/arhKmNzdihwMQ8Zk4fjyo
	dX72SkxYvI8aUEAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762441033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lFfsS/NRuyrY1q4COHS7QrBquvacCQPEpJ6EDB+xD64=;
	b=tlr7txt2adQdrktVMMpU6KoF1X8lIGjzyP8cNO9QE1eFC/z5f/6gCLRFiG8z52COgJqfb1
	da3kKIP+066yF3VcMmOIpLFqaBfMmjTtWWYm901z2hzg96qywF1fb/oMsYS12j3fT7re63
	/z54T/+hiA+uVmyfdbUeW7L8O7oZ6Sw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762441033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lFfsS/NRuyrY1q4COHS7QrBquvacCQPEpJ6EDB+xD64=;
	b=+E8gymJwhspAFJqZIwgR5pEC1GSmcd7WKfoMSmyJ3nUddAz1/arhKmNzdihwMQ8Zk4fjyo
	dX72SkxYvI8aUEAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AABF113A31;
	Thu,  6 Nov 2025 14:57:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IIQFKEm3DGlyYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 14:57:13 +0000
Message-ID: <f933b80c-0170-4c0c-bf91-7c862127e96d@suse.cz>
Date: Thu, 6 Nov 2025 15:57:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-4-hch@lst.de>
 <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz>
 <20251106141306.GA12043@lst.de>
 <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz>
 <20251106144846.GA15119@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251106144846.GA15119@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AEBB1A000D
X-Stat-Signature: usf975tdy6rrr9fo6rqbstefkj3aetk3
X-HE-Tag: 1762441035-9671
X-HE-Meta: U2FsdGVkX1/cKwe36Mvz3TBziuAiZ8phur/g4HTTbsZ4CiNE0x7s0TbYqwZjSzeOympt+p2jKdDztZnk0QzlrDbDqKbRacJAWU/6nlXT/EINsBi5F84ai930HS8W4Yd7GObbms4ehKnPH3Hpb0VMX8vOdp/FWKvHfH3cLxvFpRJEs1G2p0G/eSgWDIfgjZaBeQfCUWwEsfWMu9ckA1sYAtbIgAgq9PxTlo7F+YfF4lYnfywNFzdlTxq1sHh0mxPI4UHyYSehDWNEdbZmd7JTXEyFNg2eVa/hVHixkN2my0pQwxIxU4thHEE41gKsGrl0VlbK5aM0+XR/sw6JKLRRgE0Xh1zkfGTubFzJsfblw4a002YZuBootIj39Vi4q1cJkLne8jw1cAzrdrrhwGVaEeI2++v1T0VW8VMpCrFpmSS5IN3BiFQ1Z3L6LAZNnJQrLUsN1PUIv2x93o4WQKQq9UqsKjvZVdGVWXz/uGaAQwJI3Y0+tmUB3UaypEesfCI5QXaGqbBMwjqLYF1Uj8iIaEcjQMBOu49cGFCFymu0KUBEJzwbMW4EVSxLcJIe6WB2jdu+H5dWv4dJdzJQxexxpB385pVlX/H30f55TDqRs0+/3jIw/TYZMSpTlYRk9m6LfkQVTxvX6z7qfrRqezToHmHzq0y5YU9zclnVcJSX3YweLs5OV87RirteZnNPAuOARiSSSgtiQmP8fOsn4PeARZXg2B3OtR8k+A/sGj9JZAx5JSRyv9mlkUaBmfOIhVVTg/FLysAHwQa6g/zxJtr5qc+0Gxt74TLHrmKwzpw54VA/rvDzmpzzp1/GHw+mt3+nmiZJqfU3XtI5s1ZifC5b7B4mLcMAx54EpdQT8h/5jiW4Fc8zCicJPd4DftUJPUZaaBMuRwdFgxKZvOr8uSwOcEQfruJ6u4BnVUrJGHZeE2M1ZIV1gT64TsP6lOhVkJLTsokrc4TirDarDO9xTXZ
 VSEEzQYg
 FA9CEoKjzhbgs4RQpjD8Ii74kkqF3BkcPuwDLRsvtiOAo1eaR/g785swdR51up/WOGxszh3vSAaz/DswbyCEwjpW7/VAKJqPCa2B/g29iZTSgUkZ/pxHw26MNLl6VvUZ+jt/d03geDfd3nMp0b/041oBJwQ0RgrVzDRTQevECLopdA4I8nMGn1wAHdfSv8TjOx2fkihAGLNY+XXbJgy1UdZgSR3H9PXaxFkNkUT8iUd867PD8mJm6QYWPHONHUCWDBAlLlx9himzGRGvUVM5pnbrlVcyj2Nj1N8zO+JpRc56IlXqT/yZAcT+2js28LKVNlWu/e2yq7hGreoc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 15:48, Christoph Hellwig wrote:
> On Thu, Nov 06, 2025 at 03:27:35PM +0100, Vlastimil Babka wrote:
>> >> Would it be enough to do this failure injection attempt once and not in
>> >> every iteration?
>> > 
>> > Well, that would only test failure handling for the first element. Or
>> > you mean don't call it again if called once?
>> 
>> I mean since this is (due to the semantics of mempools) not really causing a
>> failure to the caller (unlike the typical failure injection usage), but
>> forcing preallocated objecs use, I'm not sure we get much benefit (in terms
>> of testing caller's error paths) from the fine grained selection of the
>> first element where we inject fail, and failing immediately or never should
>> be sufficient.
> 
> I guess. OTOH testing multiple failures could be useful?

Maybe, guess I don't care that much, as long as it's not causing overhead on
every iteration when disabled, which it shouldn't.

>> > Yes, this looks like broken copy and paste.  The again I'm not even
>> > sure who calls into mempool without __GFP_DIRECT_RECLAIM reset, as
>> > that's kinda pointless.
>> 
>> Hm yeah would have to be some special case where something limits how many
>> such outstanding allocations can there be, otherwise it's just a cache to
>> make success more likely but not guaranteed.
> 
> I think the only reason mempool_alloc even allows !__GFP_DIRECT_RECLAIM
> is to avoid special casing that in callers that have a non-constant
> gfp mask.  So maybe the best thing would be to never actually go to
> the pool for them and just give up if alloc_fn fails?

Yeah, but I guess we could keep trying the pool for the single allocation
case as that's simple enough, just not for the bulk.

>> >> >   * This function only sleeps if the free_fn callback sleeps.
>> >> 
>> >> This part now only applies to mempool_free() ?
>> > 
>> > Both mempool_free and mempool_free_bulk.
>> 
>> But mempool_free_bulk() doesn't use the callback, it's up to the caller to
>> free anything the mempool didn't use for its refill.
> 
> You're right.  So mempool_free_bulk itself will indeed never sleep and
> I'll fix that up.


