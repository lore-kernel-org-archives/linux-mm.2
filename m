Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA68C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 03:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4916B0005; Sat, 27 Jun 2026 23:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74D46B0088; Sat, 27 Jun 2026 23:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966046B008A; Sat, 27 Jun 2026 23:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64B866B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 23:23:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1DFF1C631C
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 03:23:33 +0000 (UTC)
X-FDA: 84927876306.07.7BCE59B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 75D9540003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 03:23:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ebi4YUnh;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782617010;
	b=cj9Fl/3YB9fjKHW8fsFaSeQX3Xdp9c5DrkCK6x7NK+I9Na0BL5pWkTiysAcah7Ib3XIH7F
	i7j4/h9iIfZs7W2HxLw+adGIb6TwjTjdXa1BEPtcWPUMZaQLrhD8WxhOzlIqsgvfXok4xe
	5SVEBQyk7gtWGMc/FV7/3k/jwig0U4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782617010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLd9VAaSv4zTPzb8ADl5Mo8ij7MWawo9NF5gj929yqY=;
	b=MntLrw5Na58MMLyyOxnMEHzcwXZKwGpUVrFaXq80+D++pCNSWFGhUqZwJ/lb9cnnjOQrBy
	2CS0snkzqWJmnZdWjSqq9Ch8nSh2RQ/4xGOGCvthm1Xx4rMGgm7ngf83KsERkcs/1VB8Pq
	7Ezbt088LjvmyihpuwqbDNHOtEbCMXQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ebi4YUnh;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 27 Jun 2026 20:23:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782617007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rLd9VAaSv4zTPzb8ADl5Mo8ij7MWawo9NF5gj929yqY=;
	b=Ebi4YUnhCJvH6XWtRsJn4n8jcVz9Ov+QBEbOG8OF44b5mOBstpkqNU3YVbYVw5lZJIqQ8q
	gEJ9bE51FkRByR6r9KMFElJS/A6P12qNW5x/1PwwlkbRyICqZBAccwHimtG7qe7BG5Vx5x
	IZjjTOOPDJ/jU3fMw8DoWFXP5pHyPpQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Message-ID: <akCSftF6mrsKsz1V@linux.dev>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akCJRTnmA2um3CIy@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 75D9540003
X-Stat-Signature: yhk7bqs9g6e5o4kdzyjqmuye4bgs4h6t
X-HE-Tag: 1782617009-763379
X-HE-Meta: U2FsdGVkX18E1oatlcN28+WtY1HKN1rcsmX7zVyGeCSuChEgBgtD0EtcJitat8Ej7VBLFynVyTD43q+mwB9AN4Si5ujVElXyqhLXD79anQazgQ3oWol7sjhcNs1COeUB4TlGduAx2idyolGvgYiV4X3D2lTs4aBTDtvOlVLAqmkpTCC7ip1d0zfoEkxN+681Hd8MaSR2b3ERN/ANjj7Cj2tUzom+Zkt0BDLt5Y3Q0Kt1YLjed913vq8XtgMVSR7B4QyHJGeMiheeS0NCRRlcLQlFZQBI/Wogm566mJbTzwkeyznATTBZzXF+JgHi5EEeZXzk/jS5uMpsXg6gxkkawbvIrhggn7eX0M7/vJq9e3JykmDIGjbY8LC2W2f9K7b8CJILhb6lf/M+yH9gmjjg7Gdr99CPBr75ITnl152qCwhz79+YYukAZp+LxDKybFu2n0TdAkfqRLYpu7fDeSKoYXWbxEYJlhiw2dIE/f23ddT5yrDMTn2KKdUr1zHfHnT49qBnAftzj7Pucps8o9WxXiI40p/S1pnGej4vOeoWENIHtajYIl3TitvStpYyGGKw3fYdH3RytJLvMbQONNDN39M4L4n13qnftT6ikUG63z4iDtetyurzqf5q5zf5Gir8itM4jtZ7VjdctehsOiRZIrusgZ5iDu533zOEdAdWsWa9enew3/CGadegSb4C7KT9///yPvhk0Ry+lUp2Ugr/Gr6FDR8a/TLYpDixkUt9m71B0JQf5BYhUHkJVVwKSNvj3gvO6FcAepmh3NbfOTFXZgNauMEBhKzxPyIHAjQeqAdGJ2q0TsjSwr94PSdhKMOMsdwCbCSgOExc546FqG9lOgs2YAzN4qiQGQZih2HBke+tRQOwQ2quOaeAx2+3GROhKmgnCWtZm5WPr//1pRITF5tlGnYHJwkt/zZxcznCLEKuqHNbk7qkrtGcwB76cx8mlt9Wpyv+JZ9cyByy4JC
 403V2Qea
 woC34d6VxncIkuRfTwdblROYuSVIJ8fV0XauKajZBSx6c0ec8X7AELy1aF/ND0tWLeMY/vT68zKkXsrDD86tkuKSeFXNF7yfBnV8F/aCNI4GHkofyVHVEF9a+PblwyECROCGwI67RMSpQAHh6+BBlvg1X4BPK+L5TW4Rw4yPQxtn1gYIAU5RelZDhFyDrgmRd+oJt8YcOqTO2whCYg9UsBeBfHVFMg+B9cZHuthsIne8f6B2EDsTeD0J5kSoMR+E8GQISW4zOvKryJffJkaeVVRpOH5KspY8MgroUHiFIUUmd7Nd1MDNXNnwcEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrote:
> [...]
> > >> > Fix it structurally by removing cycles of every shape: serve the array
> > >> > from a cache strictly larger than the one it describes whenever it would
> > >> > otherwise come from the same or a smaller cache.  Every reference edge
> > >> > then points from a smaller to a larger cache (here kmalloc-1k's array
> > >> > moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
> > >> 
> > >> This will fix the problem.
> > >> 
> > >> But this will waste memory as we need smaller obj_exts array
> > >> as the size gets larger.
> > >> 
> > >> We should probably create a new kmalloc type to avoid cycles instead?
> > >> (needed only when memory profiling is enabled, though)
> > >> 
> > >> That would also prevent recursion even further.
> > > 
> > > Yes but I assume that would add kmem caches even for users not using memory
> > > profiling. Anyways, I think that is a separate discussion. Am I understanding
> > > correctly that you don't have any concerns with this approach?
> > 
> > Umm, the memory waste is a concern?
> > 
> > Minimally I'd now want to only do that size bumping when allocation
> > profiling is enabled. Ideally that means both configured in and not booted
> > with "never".
> > 
> > We probably should have done that already in 280ea9c3154b2. Because AFAIU
> > memcg-only obj_exts array don't have this issue (or maybe they do have the
> > [1] issue? Harry?). But if memcg-only should keep avoiding the same size
> > bucket, it can keep what it was doing and only memalloc profiling would do
> > the strictly larger thing.
> 
> memcg should not have this issue as normal kmalloc caches do not serve memcg
> charged objects. 

I am wrong here as I went back and see d8df600b67d7.

> 
> So here we can do dedicated caches as Harry suggested or make this size bumping
> very specialized as Vlastimil suggested. What do we want long term? Orthogonally
> we do want this fix to be backported easily to older stable kernels. I will see
> how does this narrowed down size bumping looks like.
> 

BTW I think we need something like the following, right?

	if (mem_alloc_profiling_enabled()) {
		if (obj_exts_cache->object_size <= s->object_size)
			return s->object_size + 1;
	} else {
		if (obj_exts_cache->object_size == s->object_size)
			return s->object_size + 1;
	}

> > 
> > Suren's input would be also nice to have.
> > 
> > Thanks!
> > 
> > [1] https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
> > 

