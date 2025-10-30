Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A00ECCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1BB280017; Thu, 30 Oct 2025 12:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9818B280003; Thu, 30 Oct 2025 12:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7394C280017; Thu, 30 Oct 2025 12:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5958A280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:39:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF63E1601AA
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:39:23 +0000 (UTC)
X-FDA: 84055341006.20.E32780D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 406D81C0005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:39:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eHmm86lF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OAgraI62;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eHmm86lF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OAgraI62;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wiy+U/AQlM6qnKofaU0EH6uvOrXsym1vqU/rghgli48=;
	b=oUo+2LvZv1kiHU0Vfynr7HC+1qgJ6z+IpCaQk70lHVkE78AGc8PovPkbY+HtZtZR8bw2v0
	OjpflgRiTU6Gu5u42PcG+uYGeF3ahTZB9RSc7l/l84gAA80A4AbBbVEEYHyColJLnNLHVI
	sqLNRDcUw03DXJuSKTJl1ZE00a4t8m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842361; a=rsa-sha256;
	cv=none;
	b=bXJP6JrgDy+BljPNdDf4Rl9nxDc84rNzZC+Eco3bY2hlaHrLijfyAzoE+66gV10I5mUOQf
	2cVglaZkgckASt7Jj4Q1ioVDi4luvueiCr63r4AbswVL9S89h0oKjh4QNoZeqsipTNR3bC
	9K5JeX+33w+WWAkxr91azUSUIApEsvo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eHmm86lF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OAgraI62;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eHmm86lF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OAgraI62;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B1841F8B8;
	Thu, 30 Oct 2025 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761842359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wiy+U/AQlM6qnKofaU0EH6uvOrXsym1vqU/rghgli48=;
	b=eHmm86lFHYAfqWqJgZF5JvYesJjmVDuLRKiC1TaRZJkHwLhcZzVScC8qJ1F2NWqIarp7tb
	RLybPislVLLOmBVhyLAwZgCDwp4dhvwz/BYDzBMh2IxuHlUGvKbqVsetS8nlGIWzjt1KB5
	oY8whzVrWAk7NLuhojUUaC3bjTaVjUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761842359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wiy+U/AQlM6qnKofaU0EH6uvOrXsym1vqU/rghgli48=;
	b=OAgraI62465BGDHP2x4wlx/Li1smzJmxDus9HWxvvzW+DEaRU+ikVIlFmKHCjBp3AvLa98
	tyEMpK38ktSRwdBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761842359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wiy+U/AQlM6qnKofaU0EH6uvOrXsym1vqU/rghgli48=;
	b=eHmm86lFHYAfqWqJgZF5JvYesJjmVDuLRKiC1TaRZJkHwLhcZzVScC8qJ1F2NWqIarp7tb
	RLybPislVLLOmBVhyLAwZgCDwp4dhvwz/BYDzBMh2IxuHlUGvKbqVsetS8nlGIWzjt1KB5
	oY8whzVrWAk7NLuhojUUaC3bjTaVjUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761842359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wiy+U/AQlM6qnKofaU0EH6uvOrXsym1vqU/rghgli48=;
	b=OAgraI62465BGDHP2x4wlx/Li1smzJmxDus9HWxvvzW+DEaRU+ikVIlFmKHCjBp3AvLa98
	tyEMpK38ktSRwdBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65CA013393;
	Thu, 30 Oct 2025 16:39:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lP9OGLeUA2m9IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 16:39:19 +0000
Message-ID: <aa71ebf3-4445-49cf-a68a-0effc567fee7@suse.cz>
Date: Thu, 30 Oct 2025 17:39:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 0/7] mm/slab: reduce slab accounting memory
 overhead by allocating slabobj_ext metadata within unused slab space
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com,
 glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027122847.320924-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251027122847.320924-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 406D81C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: pn5fxooe3nr9ycx33n9wiswxr6y3deuz
X-HE-Tag: 1761842361-917488
X-HE-Meta: U2FsdGVkX18mqOlXDN/MDkKQ1smrJT6oZY2mpp2wfQJIgPCholne1Q4EOsu2XTEwQccFmd4Mo7yId2tZ8aH+BkiPDbtWTje5HdsbjaJd9Fg8kAPyzyROnhShI+1GrYFOfpaWWx0bTPpXxh450tTFt5aHXCWhaQSf9ng/OqGjNqQP+D/OWCAgRx3HJmc6/KgqN2Z9h+DYM7yrYrWLXapYa9VoDQX3WlN2+XHYuY2SCkQPOsgusTQ+YI94XpllBXRQmWPrRhUJL0xVoIFD0WgL2tVbBF4tv4+cPREbGOcCCe8ycV3WbUt+luj7bMI1zdy7sTWBAWj54qz057KzulA/TbbTEQMZFk9aW3I0J04F2biGNdDITRafNRicznCSLsKkH3vevphYEZq6Jbc0PaEXpNR4qM3kALJY69Qvi9CXbBemHOGClRkHU9VOjA1x95/b7oRsJH2ztoHVPqq+IvYzxvijCM0lZUZHOyeC/m8IojFHyl4dmKlGKlnWd1ZLjupW88bl8RjVU4ZV8LTeWACLXpl8+5xexdq3Ayp4k1Xd+dDMhaipI3Yq5A1yfJsMFyqTOeYFWEuBpLStYRCNOCUce2+ZNUj9oTw7M0dBG5fOjscCoKKVUYphIo6X6ik+Xx/nRkdt30/vIVx++8s8rzDq8TQbanVq7eJRV4nf7A8PKO0VizjDTBUxFf4tkg6GdFiBLxluTBbAgrz6zPrphSJ7KS38C90myudaAvu3Q7HKtueH2XkGgj6bmTLK34+U1ll+gcZBSyqTuoL6OCsHs0OqxfYqUSAqfkasgtwYYRkFOwTLfloVYxYeGRK2na1KdDhXgsZsdEY8/AGM9XjfIuCS/mQtYpBvwvprnqdJX2PTLWrUEV7fN92IZcO0Ora0RklLXIzZTc5kBsv4FPB1jFVN4ItyPmgOFU/hkyxHuNJsTqp86nQua/dgF7LqqsArL470AlRZY3mHMey0kD/3sST
 aPBUo3J4
 dRmP7MTfVgH6as7Rxv95lYvh++81l07ItV8QnqLCcMc2U4pKSz1YpSADxMbppHi/uTsMFhpc9M+wSXKcQOmB1PRnKtR/SPQHlHYZ9g5tOelgsv4f0fzfu9HQx3yd4J3OXNNifm6j+rVdF3J96VmAmWDZNPW/vuMovyk44c8zSFBVJXvvqKXwX6k2T3TOPJakK0cXlXLJO3m5hqDcYMZTVhugB+yhTWVQ6zmf2OK+9+9X9cWyYHKTWdIwEGVdvetkrlCb2exDn+bTCOwiNBhu7ubDo/YAAHJFvngrmfcUVGMaUZV1qjPK5p9alGUKaaW0G6HJTFWctVA0v73bsSkpI8IJyKMpq2BTtiEsP9hIZP/+wgJFLAPxI+TV54ijSI0rCB00UEbz7C5npgzLO5zQtA6FjkWWPuIoIEVb9OvA/NiB5BWKCMZpH3jEf3IJlK6+JM2rtOXGY4pZlqUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/27/25 13:28, Harry Yoo wrote:
> RFC v2: https://lore.kernel.org/linux-mm/20250827113726.707801-1-harry.yoo@oracle.com/
> 
> RFC v2 -> v3:
>   - RFC v3 now depends on the patch "[PATCH V2] mm/slab: ensure all metadata
>     in slab object are word-aligned"

Looks like there's some outstanding feedback on that patch. Also on this
series already, so I'll wait for the next version before looking in detail,
but overall it looks good to me! Thanks!

>   - During the merge window, the size of ext4 inode cache has shrunken
>     and it couldn't benefit from the change anymore as the unused space
>     became smaller. But I somehow found a way to shrink the size of
>     ext4 inode object by a word...
> 
>     With new patch 1 and 2, now it can benefit from the optimization again.
> 
>   - As suggested by Andrey, SLUB now disables KASAN and KMSAN, and reset the
>     kasan tag instead of unpoisoning slabobj_ext metadata (Patch 5).
> 
> When CONFIG_MEMCG and CONFIG_MEM_ALLOC_PROFILING are enabled,
> the kernel allocates two pointers per object: one for the memory cgroup
> (obj_cgroup) to which it belongs, and another for the code location
> that requested the allocation.
> 
> In two special cases, this overhead can be eliminated by allocating
> slabobj_ext metadata from unused space within a slab:
> 
>   Case 1. The "leftover" space after the last slab object is larger than
>           the size of an array of slabobj_ext.
> 
>   Case 2. The per-object alignment padding is larger than
>           sizeof(struct slabobj_ext).
> 
> For these two cases, one or two pointers can be saved per slab object.
> Examples: ext4 inode cache (case 1) and xfs inode cache (case 2).
> That's approximately 0.7-0.8% (memcg) or 1.5-1.6%% (memcg + mem profiling)
> of the total inode cache size.
> 
> Implementing case 2 is not straightforward, because the existing code
> assumes that slab->obj_exts is an array of slabobj_ext, while case 2
> breaks the assumption.
> 
> As suggested by Vlastimil, abstract access to individual slabobj_ext
> metadata via a new helper named slab_obj_ext():
> 
> static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
>                                                unsigned long obj_exts,
>                                                unsigned int index)
> {
>         return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * index);
> } 
> 
> In the normal case (including case 1), slab->obj_exts points to an array
> of slabobj_ext, and the stride is sizeof(struct slabobj_ext).
> 
> In case 2, the stride is s->size and
> slab->obj_exts = slab_address(slab) + s->red_left_pad + (offset of slabobj_ext)
> 
> With this approach, the memcg charging fastpath doesn't need to care the
> storage method of slabobj_ext.
> 
> Harry Yoo (7):
>   mm/slab: allow specifying freepointer offset when using constructor
>   ext4: specify the free pointer offset for ext4_inode_cache
>   mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
>   mm/slab: use stride to access slabobj_ext
>   mm/memcontrol,alloc_tag: handle slabobj_ext access under KASAN poison
>   mm/slab: save memory by allocating slabobj_ext array from leftover
>   mm/slab: place slabobj_ext metadata in unused space within s->size
> 
>  fs/ext4/super.c      |  20 ++-
>  include/linux/slab.h |   9 ++
>  mm/memcontrol.c      |  34 +++--
>  mm/slab.h            |  94 ++++++++++++-
>  mm/slab_common.c     |   8 +-
>  mm/slub.c            | 304 ++++++++++++++++++++++++++++++++++++-------
>  6 files changed, 398 insertions(+), 71 deletions(-)
> 


