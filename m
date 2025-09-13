Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E9A3CAC593
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 20:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E1C6B0006; Sat, 13 Sep 2025 16:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E4A6B0007; Sat, 13 Sep 2025 16:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47E26B0008; Sat, 13 Sep 2025 16:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE3E26B0006
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 16:32:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D4B71A01CD
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:32:59 +0000 (UTC)
X-FDA: 83885376078.20.A7CCD78
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 24675180002
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:32:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uL1vOO8A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wq+V+a/Z";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uL1vOO8A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wq+V+a/Z";
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757795577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpRJZ9I95GmOVaMkK/sESDsiFIQvQ5KFj4dQmisZ5f0=;
	b=NKtGVlBBeij5K4S9iVAOSL9GuV7pED7cuD2/YlJcOv17AvbkkhSLsZb1IGXoAwGDDl93wF
	GvHoFNDuf8RoFviv9Rk55eswk7dt8v5f1fjs1FjgyNYgwR9cM5SQmJ/hl/MEtZSHuLu+W8
	+ITUt0axdFNc4NecIiJyH7c7buPWkbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757795577; a=rsa-sha256;
	cv=none;
	b=RXe7gqPLqnoBCGXDx89MHOzMo8p9PMOe+weZDCOkv/vYW8L5qmF5XNXL8AiTe/r0SrOGwA
	dROeufHDva/phdSBhhRGnFJsiluDwVa2Cy5dR8BzjePwMOV4mENImzcOct1U/sdH0cQGLp
	Ko2f4ssBZxqRa5zLyEqx+hZ3S6Js16o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uL1vOO8A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wq+V+a/Z";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uL1vOO8A;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="wq+V+a/Z";
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7EFC635226;
	Sat, 13 Sep 2025 20:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757795574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dpRJZ9I95GmOVaMkK/sESDsiFIQvQ5KFj4dQmisZ5f0=;
	b=uL1vOO8AMkos9j6t0UAlhApuIadXfq3j8WmqNpNZLPg2+cy2E/qVOxPALciFGZG2+NABuy
	tRewSBF3AoZY4avZVQkvaO6IZJLc9cMacmXsFlxEyGiIpOUrw69ZDtcNf5T6XALFlBzJ/P
	aYLTO6PW2CCrVPT/GI6b2XtdeapO4Vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757795574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dpRJZ9I95GmOVaMkK/sESDsiFIQvQ5KFj4dQmisZ5f0=;
	b=wq+V+a/Z+AaQ7JDlKetlW214a3l4Kc3IhloUXUP4BBTPwLmiIIMYvUeqsxJP7Cq/BKW4Pk
	iNwM+jfMPEct9nDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757795574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dpRJZ9I95GmOVaMkK/sESDsiFIQvQ5KFj4dQmisZ5f0=;
	b=uL1vOO8AMkos9j6t0UAlhApuIadXfq3j8WmqNpNZLPg2+cy2E/qVOxPALciFGZG2+NABuy
	tRewSBF3AoZY4avZVQkvaO6IZJLc9cMacmXsFlxEyGiIpOUrw69ZDtcNf5T6XALFlBzJ/P
	aYLTO6PW2CCrVPT/GI6b2XtdeapO4Vw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757795574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dpRJZ9I95GmOVaMkK/sESDsiFIQvQ5KFj4dQmisZ5f0=;
	b=wq+V+a/Z+AaQ7JDlKetlW214a3l4Kc3IhloUXUP4BBTPwLmiIIMYvUeqsxJP7Cq/BKW4Pk
	iNwM+jfMPEct9nDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 616311372E;
	Sat, 13 Sep 2025 20:32:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zXW8FvbUxWiYYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 13 Sep 2025 20:32:54 +0000
Message-ID: <b923fd8a-4f07-4689-a0cf-4ac5b85c6fe5@suse.cz>
Date: Sat, 13 Sep 2025 22:32:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
 <ja3gd6bdckiuanm3xu4hszpjm7euvffm3k7tmu7drh6mdel7m6@oyr635vikumk>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <ja3gd6bdckiuanm3xu4hszpjm7euvffm3k7tmu7drh6mdel7m6@oyr635vikumk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24675180002
X-Stat-Signature: z13xntcza6wwne7xiix46t6tdxyx69gd
X-Rspam-User: 
X-HE-Tag: 1757795576-678814
X-HE-Meta: U2FsdGVkX18sfEwqmeUzRfa2YlvY7hnDFu90mftNGjkca5edNgYP3nv3Cbo9SMdVcFPMwlXpesNMfX3PWSnIK8YvCNu2iTyHuqETqpHUBxt5INC0LwAzCSZj2+BBdzffrKbOvBHZoTyV4t4oaqQpqsYNi9hxggw6/V79bFNQ+dWrHqahFbW63tBgs4rqWU6pgrGFsipWuCAX6cmJfgRukt7W+7RbhnW9Iw9zrgQwQEqZyzGkDpvTlGVIuqgZl/s8LcwYWiu/rM8Qrc/crqyj7NVOorIQX55fM9q/zMCJZisj98kiE5LYiApp9WgJrgfrpTjBHuxiyPxB43T6beeu62/mET3N5u9IbB0We08T7G6nfroOKpJRtcStRb1QGDs34YmQwjNQmorKO9swWUza+xCHtaytl+/VebMV6LG7FwQyUY8F78gmG56rvOvh394Zg/LO1Vq2yD7vZNBS9APhdTISPhBYEMZxEKR9qWbQSoyaSc91GWVYfoQX/QbQoewfufjCAWySc3GpK0UlYkH8zHRocbZk22lpZ91GYBxLXQAYOa0mkmto6CswafRGsc2vI63Hxgle60R2F9G/aRr7S6PVOJ69YvSJ3T2yLWQLniyJV0JPvFMRbVh1DI1QoOIRGmcTBxNy1jMp23tmhKlKEY2ItmecaD8txlDnsoh646Yb0UvARS7tsFsjONMROQRCOpNNmvrv39ZATkyR+EE0eX6tbWFkXehIwDxiy2kqWEwW1WINe5NGIuypl2agR4EVXVW92wAwtpmPOxC59Wv7xy/axcr2bl3MhI1RO8ntJnOPB1jdphl3JC36AVcXvS/7LI9q9jS8pZCjrQX5A6Ry5TYvzGJHnmzsynUgyg3Hn988h1IdkcRE6ZywU/HhJhtI/BwCaUiJrqnIxLfkt1caLxtm59RnuLGDic+vhK3RPoGEgEZpcCUBEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/25 16:35, Mateusz Guzik wrote:
> On Wed, Jul 23, 2025 at 03:34:34PM +0200, Vlastimil Babka wrote:
>> The sheaves do not distinguish NUMA locality of the cached objects.
> 
> While currently sheaves are opt-in, to my understanding the plan is to
> make this the default.
> 
> I would argue a hard requirement for a general purpose allocator in this
> day and age is to provide node-local memory by default. Notably if you
> have a workload which was careful to bind itself to one node, it should
> not receive memory backed by other nodes unless there is no other
> option. AFAIU this is satisifed with the stock allocator on the grounds
> of running on a given domain, without having to explicitly demand memory
> from it for everyting.
> 
> I expect the lack of NUMA-awareness to result in increased accumulation
> of "mismatched" memory as uptime goes up, violating the above.

Yeah this is addressed in later patch in the series "mm, slub: skip percpu
sheaves for remote object freeing" and then "mm, slab: allow NUMA restricted
allocations to use percpu sheaves" further improves it. I should update
commit log in this patch too.

> I admit though I don't have a good solution as to how to handle the
> "bad" frees. Someone (I think you?) stated that one of the previous
> allocators was just freeing to per-domain lists or arrays and that was
> causing trouble -- perhaps this would work if it came with small limits
> in place for how big these can get?

Yes, the alien arrays of SLAB, with their dreaded periodical flushing.
To avoid that the later patch simply skips the percpu sheaf. Only about 5%
of frees seem to be remote, so 95% will still benefit.


