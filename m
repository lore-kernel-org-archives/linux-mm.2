Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04577C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DFE6B0106; Fri, 26 Jun 2026 12:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D1F6B0107; Fri, 26 Jun 2026 12:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24996B0108; Fri, 26 Jun 2026 12:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 862EA6B0106
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:50:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5F8E1204EA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:50:07 +0000 (UTC)
X-FDA: 84922651254.25.2316151
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf17.hostedemail.com (Postfix) with ESMTP id E589E40010
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:50:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utx+UmZe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782492606;
	b=kRQ4PlR421CUVhxM3+teOebdaKu6ZqUX6WeuyoKEpBbpLVY6xL/2c2h3f9lUcImjMBGj9/
	jSaJXG9fuVToYbj37SZXbFLHv8q1sKvpI/OZAUQpgCc/7ABkJWM5UkSKo7e+VZDMROj+a2
	wtBiGnDOzBDv3ZR9c//ALUxXkAzkD28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782492606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wIxc7zqXaahNH/JR/e34vtbkcr3/Y8V9iV+zarWuiI=;
	b=2oDdZYkALEp7xHLfGyp64HNM1Hfu9cfftXzQjrjjHz3KtLuks+2yTuSCZ+UCwKphL+pIqo
	+HZUW2dmLZakkOFJsKf6iO1bserWPFdX234qPeVfvGTvtwEqECPi9k9FGBIeu6KVvWw+uQ
	/KPBHYkFcXM4f4YfitT4bdNM2EJpXC0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utx+UmZe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 26 Jun 2026 09:49:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782492599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0wIxc7zqXaahNH/JR/e34vtbkcr3/Y8V9iV+zarWuiI=;
	b=utx+UmZew4KsX9WqKAaZgFYGFw6EAszggXDrU/MjS5lkqQbDp5t9ARMxZ0BFpZ7wI6nC6d
	UcdgtxHnnew0TWH+o443bRPGfNlhyHm9gH0STpInqOZLq15/pfGBFuZfPtBrJ6tF5hypXY
	+aaCXIR0kfSBpf4BMk9R7RJBeS6oK2w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Message-ID: <aj6re83IC84lkFL0@linux.dev>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E589E40010
X-Rspam-User: 
X-Stat-Signature: mfykqk1f3sxqdthzt9536y1jc5naf3wj
X-HE-Tag: 1782492602-610976
X-HE-Meta: U2FsdGVkX192DqHkaY321pN6ZC/ZQ6XjtJr9YO/Rend+MYKKt9NlIlygCtgoQDf25SoaORe+dffAslC+P36za1/t5iMI92FwX8zu813sZ0Y4OhNdSvck2yNM4ReaPTfX/vwQdvsmMcAAgEq5qKcekS2UQyfqzSpExdi5/zX19KONDWM7MaK9p2mycqc2k8LGaoDAkcFUgidCknkK6cqm8h5nI9uo/ixFrovaLpbQSq3tn2qw45sJa8Ysdq70Jav6wL6qMN6qgnFDKoOPBXMdZ1x80qikASS4bEnPyKJkdieDq2dqZMTyMGOh16gx4bKg5zZrJb0HoUqnHGvup9oxBHmSer2VA9Ch/1sK9umPN+sBx/4VGKvexjTlY+2S1669yi0CTODCbRtLZS12Gw2aPjUqCHsLkAIUXhjA5y5J4rDRFztSIYXYOgWDQ+cKeoidNvDe9XNkO0OTVYePtKRomefDyWxoV+g1TJp4cidDqCkgeDTY4eOENDkgkm64L3jnel6P2HFkyNq5wiHyV5yKhgvzRk/3RXt7CcR1o4bpM16NYmI3C1g7L8qWflXKHycZm3V+oV7DxoEOQWES1Wy8xFqlWHJjv2OvFd/2srKr6xncwAxNhpU6jGwM8bGiQ2vn5BxGdSlLi+idvKZbxzrwKbRvqIn7cmKvRwSJB2wG2cDQHGIQ74GOa+EsJ5hV3izLcKK0XZCqed2xvwHU7rEUVkegOZmUdsuxSsNZSewHHkXAdvf4Lm4joU+sqqsGsDze/k0YxlRytzBEaJj6X5fUYkf09rZVLFU9UYwXmwH4b3cGRyy32ZrVmOqJUlhZvYirQ2cmd2elhz6IUTyneSXiA8ftT+wyOCb2dWnuoftgBncJTZ0Nj5XeTF/dLZHqUhQcu59+yMQXc/wdvmM2l5jm2LZ+cmevrp5NoMv5vKm6xUa2UxbZU6krU46G5UEeNCDRMm+dtxuCjERBn2LB3wC
 emgX0O48
 kCx+J6N3c4ckCDtW1XcCAwnUfVkglQ1B90H7VutENA6huyL8scmHg1geOLt3r492bGBJLDENtTexO1r1kZXBkolDlUQCbO4pnwrVYmWgBUCg5L/0dFe5ZZqbwnfJZBu8hLRmBlSrpHy98S+JA2zGw3ef14yLT8MHItK0F1CL6zuof+TDLVH5GF/zmPkoMhMGl+sLk4pQC39TUx/vSksC3GzP1ynit9MpcI9TNxelmYKsHBkyHMpHz0Zn8ZqtI+P3yY/NC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 01:22:09PM +0900, Harry Yoo wrote:
> 
> Hi Shakeel,
> 

[...]

> > What happened: a KMALLOC_NORMAL slab's obj_exts array (used by allocation
> > profiling / memcg accounting) is itself kmalloc()'d from a KMALLOC_NORMAL
> > cache,
> 
> Usually KMALLOC_NORMAL caches don't need obj_exts array, but yes,
> this could happen if memory allocation profiling is enabled.

Yes, we have enabled memory allocation profiling fleet wide.

[...]

> 
> > Fix it structurally by removing cycles of every shape: serve the array
> > from a cache strictly larger than the one it describes whenever it would
> > otherwise come from the same or a smaller cache.  Every reference edge
> > then points from a smaller to a larger cache (here kmalloc-1k's array
> > moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
> 
> This will fix the problem.
> 
> But this will waste memory as we need smaller obj_exts array
> as the size gets larger.
> 
> We should probably create a new kmalloc type to avoid cycles instead?
> (needed only when memory profiling is enabled, though)
> 
> That would also prevent recursion even further.

Yes but I assume that would add kmem caches even for users not using memory
profiling. Anyways, I think that is a separate discussion. Am I understanding
correctly that you don't have any concerns with this approach?

> 
> > No slab can be self- or cross-pinned, the tear-down recursion is bounded
> > by the number of kmalloc size classes (it terminates at the large-kmalloc
> > path, which carries no obj_exts), and profiling/accounting coverage is
> > unchanged - the array is still allocated, only relocated.
> > 
> > Reproduced on next-20260623 at the same geometry: churning
> > kmalloc-512/kmalloc-1k under vm.mem_profiling and then shrinking leaves
> > kmalloc-512 with thousands of unreclaimable objects without this patch
> > (8056) and at baseline with it (847).
> > 
> > Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> 
> Perhaps Cc: stable? v6.12 and v6.18 are affected.

Ack.

[...]

> > -	if (s->object_size == obj_exts_cache->object_size)
> > -		return obj_exts_cache->object_size + 1;
> > +	/* compare object_size, not the cache pointer (partitioned kmalloc caches) */
> 
> This comment is no longer relevant, by the way.
> 
> "compare object_size instead of cache pointers because there can be
>  multiple caches of the same size" doesn't apply anymore.
> 

I will remove the comment in next version.

Thanks for the review.

> > +	if (obj_exts_cache->object_size <= s->object_size)
> > +		return s->object_size + 1;
> >  
> >  	return sz;
> >  }
> 
> -- 
> Cheers,
> Harry / Hyeonggon




