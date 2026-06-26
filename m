Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F51C43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43FE6B010D; Fri, 26 Jun 2026 13:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B5A6B010E; Fri, 26 Jun 2026 13:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8955B6B0110; Fri, 26 Jun 2026 13:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 621D66B010D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:11:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C075CA0324
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:11:39 +0000 (UTC)
X-FDA: 84922705518.16.E69C63B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E093C000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:11:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lKKCG/0y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782493898;
	b=CATc3WVfOiWqjcWerh+RDvClQ7KUIxx59GAt99E2klltgPh95qwLXreSlmng5VGR6ZM4GM
	rGaEx4SBbdj9GsO7wj0975SdnCAKEh1dBWvQK4xZ8r0uEkrQslf4O+iCpHwuy3Qqxff0ym
	RYa2eUfu7mbIxfNEvAqZeco0xOjhDoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782493898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1TSg3m88zL9U7ax0KrJL2CCGkfVpyIHBvazIemMV5c=;
	b=I8UV1/hQQ5fx+GqBOqwi5jj2+GKDoZhcaV/VIzG+vePnWWXqMm50hvFIQD7F1uthFaO/uy
	htfXZY5l6jqeKpNs6ZPuxfrbrV5lU20qIJqjEZKrCCbdLFzpJf1aShudCuLkCstg5TghJb
	Y6aOF65wTwefyXuJteOx5rGfMV3b2gc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lKKCG/0y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D3E1600C8;
	Fri, 26 Jun 2026 17:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89EE1F000E9;
	Fri, 26 Jun 2026 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782493897;
	bh=M1TSg3m88zL9U7ax0KrJL2CCGkfVpyIHBvazIemMV5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lKKCG/0yHKC9L57TsKeQCQ7hpezVrAD50Shli5YkrEriDnPnkxMUX1GsztZ4ACfVs
	 0xlD9FmOUH/iaD+VQm4ll8fVmRalcWXJBaXNbIDG1WCMZwjOYjHQ7kRMbi6mqPLE/H
	 GdGk56ZM93qNgQizn75ELcyu4Z5+sqbEKjqI7k04LKr4l6b0tSRlf2GTcpluIVYs0e
	 ezI9goimgZyRTWIPUcev8VQS/fIyioWct4jaJIGslxcaC5mR7jjXVvo1vZrNKG13qZ
	 d+voLCSPev5s0kTRt0EUw5pvAPXYkbg6Fi1A6Ta/1IpEzbNygVjXhKJE0ZebhaVhlQ
	 UlQHNbIyqu6qA==
Message-ID: <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
Date: Fri, 26 Jun 2026 19:11:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aj6re83IC84lkFL0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E093C000D
X-Rspam-User: 
X-Stat-Signature: 1fwd4imw5k4hsgzotww7333k4farbpsq
X-HE-Tag: 1782493897-832670
X-HE-Meta: U2FsdGVkX1+LFb6O5kJM/EDHJ5RZ2fSIdkAupdkKXrbDsjaFuwqBHELYbO2fYVRP1iB3Xty8Izy8qUShf3Gi0nmscgXwCa66RHLAX5emLT3CNWIG7P0mPl7y7AwEA4J8I9qM7FVO289wILweLGxhJEWfSh0ohteHBawM/pDdR9AiIs8vf9i2IssWCYt1Jvuex6oCfsbXNeJ6bfu3IsywTkgsjuFjTIahN4b6DsGFICgoBbA8dfkIAGdDPByF+XLHTZ18TvzxjS/Q+rFtyopGvnybrdwIRPA+Qw3mlwS9JmZndpUkC/bAYi9dlJCdp8mO56AwDyXfKyixmLCvppRXQ+wYa4/JxvbAAEExF5qMayGcp44YGAy+d7fY3lLwFAaspQwtyXxLBDdvice6owYFebDMdGHZpUDVtWucwWV6AR8l1LWM9UF4dsCGROvwt+HDPBh7KL+YZPKMdik3qsRNhy0DmbEjrWuYZiiWdHveiy1ilaNAUhkwzD8VEFv6MLtX/YtFCN4v+P9pv9XBgn/ZJS9tYUTt1ShEESp14hF44JbzOL8vzwVh/x9kbDROtPI4N+nvLULp4y3kzZkZtGKT0j5V3aWQrB9mQdGrt4/ScrMPB5zCd8jfWGhiJeFwvThpKk4VSD3RtGbxeg1oeNYFrajSaebXiYC0BIwLFlaSnyjDrnlQPaMDZCrDJO8yxNdOmoiYFODHmoSZr4drIkKE6PS91LJhfoYb1UNezGT2I65kKYII7Ms3OTh1SNsvVQABae2k3Vp8xw8vmDcuORfKVHw9+H7Gxz6RBzwvvGPbeMwpOh4biApzqSzD0JeGdKnW+hvQd3MqxgptU+PcJjpN4G3CNvpBLK4ZrEJ+filcHablFN73VYFfoCItQsg4/iGrQHLQpOXpoPpfkR3lrf3C19ZY7m80DRyYrjkd/c5SDGxJGwf1TIiP9jpgYY0cXBVKPyWXyWBaM1V4TOn9yqb
 Pv1Ts8rK
 JIxXmojH5zZIUz7o+vs25rHBzsi30zLc2BCsjn1y8UK8Fw3QpYQ2J7+l4phNgg2X44VIhASvsjUPa7mZyrgZc+rG6y1jqg6ExmzE+JIMbiNDPFS7yjXaNeAvv9e0YcEmOZ1DPr0mejIt2mJ5qtxiu4cfEV0zcwkQ0dn2bChVxBqW3SerN0zD3b4JRCjiDhT/mk8u3S8St5dlRd9JDswNUmQC6PWSo2RgmUr6xVCfbejKyoYonSpADDJWLAD7CR2Ct1KTYKPGPA3Nb7KZ7AyIzUJH5oGcCx1SKLLS9/BH3r3+oEqebQl4QezcSOrz2+LkhCrRPNG1XsKdytMAG6+Nbd37nspjbwFaYPF35
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 18:49, Shakeel Butt wrote:
> On Fri, Jun 26, 2026 at 01:22:09PM +0900, Harry Yoo wrote:
>> 
>> Hi Shakeel,
>> 
> 
> [...]
> 
>> > What happened: a KMALLOC_NORMAL slab's obj_exts array (used by allocation
>> > profiling / memcg accounting) is itself kmalloc()'d from a KMALLOC_NORMAL
>> > cache,
>> 
>> Usually KMALLOC_NORMAL caches don't need obj_exts array, but yes,
>> this could happen if memory allocation profiling is enabled.
> 
> Yes, we have enabled memory allocation profiling fleet wide.
> 
> [...]
> 
>> 
>> > Fix it structurally by removing cycles of every shape: serve the array
>> > from a cache strictly larger than the one it describes whenever it would
>> > otherwise come from the same or a smaller cache.  Every reference edge
>> > then points from a smaller to a larger cache (here kmalloc-1k's array
>> > moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
>> 
>> This will fix the problem.
>> 
>> But this will waste memory as we need smaller obj_exts array
>> as the size gets larger.
>> 
>> We should probably create a new kmalloc type to avoid cycles instead?
>> (needed only when memory profiling is enabled, though)
>> 
>> That would also prevent recursion even further.
> 
> Yes but I assume that would add kmem caches even for users not using memory
> profiling. Anyways, I think that is a separate discussion. Am I understanding
> correctly that you don't have any concerns with this approach?

Umm, the memory waste is a concern?

Minimally I'd now want to only do that size bumping when allocation
profiling is enabled. Ideally that means both configured in and not booted
with "never".

We probably should have done that already in 280ea9c3154b2. Because AFAIU
memcg-only obj_exts array don't have this issue (or maybe they do have the
[1] issue? Harry?). But if memcg-only should keep avoiding the same size
bucket, it can keep what it was doing and only memalloc profiling would do
the strictly larger thing.

Suren's input would be also nice to have.

Thanks!

[1] https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com

>> 
>> > No slab can be self- or cross-pinned, the tear-down recursion is bounded
>> > by the number of kmalloc size classes (it terminates at the large-kmalloc
>> > path, which carries no obj_exts), and profiling/accounting coverage is
>> > unchanged - the array is still allocated, only relocated.
>> > 
>> > Reproduced on next-20260623 at the same geometry: churning
>> > kmalloc-512/kmalloc-1k under vm.mem_profiling and then shrinking leaves
>> > kmalloc-512 with thousands of unreclaimable objects without this patch
>> > (8056) and at baseline with it (847).
>> > 
>> > Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
>> 
>> Perhaps Cc: stable? v6.12 and v6.18 are affected.
> 
> Ack.
> 
> [...]
> 
>> > -	if (s->object_size == obj_exts_cache->object_size)
>> > -		return obj_exts_cache->object_size + 1;
>> > +	/* compare object_size, not the cache pointer (partitioned kmalloc caches) */
>> 
>> This comment is no longer relevant, by the way.
>> 
>> "compare object_size instead of cache pointers because there can be
>>  multiple caches of the same size" doesn't apply anymore.
>> 
> 
> I will remove the comment in next version.
> 
> Thanks for the review.
> 
>> > +	if (obj_exts_cache->object_size <= s->object_size)
>> > +		return s->object_size + 1;
>> >  
>> >  	return sz;
>> >  }
>> 
>> -- 
>> Cheers,
>> Harry / Hyeonggon
> 
> 
> 


