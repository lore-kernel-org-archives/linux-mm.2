Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F4AE74907
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF2F6B0005; Tue, 23 Dec 2025 22:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C7C6B0088; Tue, 23 Dec 2025 22:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799056B008A; Tue, 23 Dec 2025 22:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 652D86B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:19:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB77313B572
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:19:15 +0000 (UTC)
X-FDA: 84252908670.11.FBB85F3
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id BBA1B140012
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:19:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gvXFAIgR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766546354; a=rsa-sha256;
	cv=none;
	b=tKVyPzCCsJuN/yN6f+c1Ng1cDDSygZlBPwGWqQggaPjkYh93SreygGcaZEhrMDOdCymdMw
	Bcuw46HYLXGynzQNl3HoTUp6q+GglKhUda8aab9aLDwuaD8/nSpTl1CRHO7NggJzAFywjw
	1UrrgEz8HRmY85AYUPIEdrohtXRFeI8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gvXFAIgR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766546354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oswkuqTYHUBzus0t0fqLYz06bL+cZstFaMSGw9VGWQ=;
	b=W+cn0jUifHaT+lKbzvL3+52N2gliUAI7uX9eGBtmTxU/lTMoZbRMdGAXOBUiZiTqE6MV0E
	RQaelYYGoulEyhWM+lOiRpSpxVWtS6ONDtIWhLy/YSIZmtVVO64BxT3WP0jPwW+4q2G8U8
	dDvIeSuubUtje0o02vKyuziWeQ167cM=
Date: Wed, 24 Dec 2025 11:18:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766546351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8oswkuqTYHUBzus0t0fqLYz06bL+cZstFaMSGw9VGWQ=;
	b=gvXFAIgRJN5XCpsXXDgESzfw6K7sQjtFNBY0ViOC6cMza5FexO6DA4TatMuwduoGECeldY
	gMwgwGWI+jqBq5jmqfD2nK/46pXPjW6wkz/iM346nkf9M/OxcJSoNCdkh1AK0GqdbsRBq9
	uwtNuJ3ZXv1iQ6rofxLmrnVXH7OYOKY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH V4 7/8] mm/slab: save memory by allocating slabobj_ext
 array from leftover
Message-ID: <c6owr44jdncf7q5zqgq4wn4pm57ai4cd3upauwmwszopuddf5g@52mkqbe2m27j>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-8-harry.yoo@oracle.com>
 <graryni6wadpi3ytfq7zimj2kbmm7dumxvhxtzmxndrv5s2y67@ju4cdnsmos6e>
 <aUq1x_BowqYpHZAQ@hyeyoo>
 <zex6wgdlxk5vgwm7ou657fdmi27xnxihdndlszfa2chghamfuz@grhtfqw7gm7o>
 <aUrCXYdziRWP9PfV@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aUrCXYdziRWP9PfV@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBA1B140012
X-Stat-Signature: u1eofjkzk3f4mqb4o4nihtik9t4mia4a
X-Rspam-User: 
X-HE-Tag: 1766546353-226035
X-HE-Meta: U2FsdGVkX19zJUIKKsuOMFG5aZzo1FhN4jK5gdXopfXH97t9c7r9H1ky0Ra1KO9Amlrdma291/aYMZSnNmHVx3Dd3XiX+/JWiFlCPldxO3tNQp9PfGiwM2HLG2rQqJzYeRprIczSdLHTCkl4WbDqpaQh4ijoDvHV8XNQWhk22PhwO0Zl3HtV9iYulWS22yCaZS2m9dyoJiIQik7W800IXAs9w9XYtiblI3Ir5HvSg0ZdB6evOiBoefxi+/77+JVR0UpggMV/fO0baMclhRgfcq7FRvo0f6HFqTz7aqLsvHanZRWcUNbb5JUclsqYGwLfzOhDtLUFwbge6SCqSvjXGfN3AS4vfRovvcFGctjFirWta6CLAPmc6OuSR77ptLgc0zqbtUwKkiHnQmt5u6QTTuZBuE1trUmCzwqkz9kqHPVZVWiMaIhUxb90TrJkuUbfTC6/aMDQXA4e/o4OrmCKBk78TVnGv9qyCkwGWQZEDwmSSo9GvK5aSUrCQErxcAlBgc77TItsUiSAkEtDS9OdArZtkSjw3/ydLt32jn4oEod+x9l91QPPuvjtM2Wvxp85bNjrQU+eZWoWiA82RNrSgrN54OqpZinmHGwYeOQoa/k0biJgwJRgenMfaUWrCFvK6MMgILg4wJJqzWMkT4jsrDypshjzjKom08Q5JdOvhRHOsFYrJF1T3JXMDuv3wpmUyzJFY9DC1YXRJ7Un2MnfDFAp4X2x83dRIRuanKlyh0cU60xEA8haORei6Ct2Q4m3o/fwokqKKOUDi2+VhNbUEMXamWEGVrr3PR+Vww83Dn+jZcLkD9wXPBe5BqxhpxIi+/8Brd+no5BhndR/xIttUb3W1aqKpxGIAYSH33aZYeK7H6NY+koHmclqdx1GvDfQLpvP97SKsJa43apg/9Fqyl8yxaVDB9XboxAwaa4iEQDciiwYgtgRgAu9RU/ht/J++xZm32a8mEvIibD6YCA
 CoMgzLiH
 BhbahKcfUmCR8Nk6q8VbAcxqa1GY7+Xv9xp+3mvJkpEcBvuasDZp3NYdtkDbqPexgeUOBDLlLROR5fJw24dEr7fpkzSYS8fRTpvrg6BrigHukT8FUubtvFOF/BGfzQgs5tVD00o6SzPt8Gyt7xPY2HcMKkYuIBMOc+wLKZmC5npBYUaoOEGESqsmSzILtkaXfzYvQaLN0vhD1jBq+ZzNdZr7LRNIXtZLAR748NnLvqZ9XbC5ErbndLRaTXZ6v5x90Lg82Duv/iofLU4UoWJief7agOjAU8fXMT8qmZG+i6H+cd00QrgtDlaW8OcLO+pSU0umMSt0xPmjiBHrLdvypDBvY3QUqja4LaUulyceaD2UAiChpKxnJ7hTpzQOv5VRMkpMC00l1PFR3I9rS5yWDoqHvTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 01:25:01AM +0900, Harry Yoo wrote:
> On Wed, Dec 24, 2025 at 12:08:36AM +0800, Hao Li wrote:
> > On Wed, Dec 24, 2025 at 12:31:19AM +0900, Harry Yoo wrote:
> > > On Tue, Dec 23, 2025 at 11:08:32PM +0800, Hao Li wrote:
> > > > On Mon, Dec 22, 2025 at 08:08:42PM +0900, Harry Yoo wrote:
> > > > > The leftover space in a slab is always smaller than s->size, and
> > > > > kmem caches for large objects that are not power-of-two sizes tend to have
> > > > > a greater amount of leftover space per slab. In some cases, the leftover
> > > > > space is larger than the size of the slabobj_ext array for the slab.
> > > > > 
> > > > > An excellent example of such a cache is ext4_inode_cache. On my system,
> > > > > the object size is 1144, with a preferred order of 3, 28 objects per slab,
> > > > > and 736 bytes of leftover space per slab.
> > > > > 
> > > > > Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> > > > > profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> > > > > fits within the leftover space.
> > > > > 
> > > > > Allocate the slabobj_exts array from this unused space instead of using
> > > > > kcalloc() when it is large enough. The array is allocated from unused
> > > > > space only when creating new slabs, and it doesn't try to utilize unused
> > > > > space if alloc_slab_obj_exts() is called after slab creation because
> > > > > implementing lazy allocation involves more expensive synchronization.
> > > > > 
> > > > > The implementation and evaluation of lazy allocation from unused space
> > > > > is left as future-work. As pointed by Vlastimil Babka [1], it could be
> > > > > beneficial when a slab cache without SLAB_ACCOUNT can be created, and
> > > > > some of the allocations from the cache use __GFP_ACCOUNT. For example,
> > > > > xarray does that.
> > > > > 
> > > > > To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> > > > > MEM_ALLOC_PROFILING are not used for the cache, allocate the slabobj_ext
> > > > > array only when either of them is enabled.
> > > > > 
> > > > > [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> > > > > 
> > > > > Before patch (creating ~2.64M directories on ext4):
> > > > >   Slab:            4747880 kB
> > > > >   SReclaimable:    4169652 kB
> > > > >   SUnreclaim:       578228 kB
> > > > > 
> > > > > After patch (creating ~2.64M directories on ext4):
> > > > >   Slab:            4724020 kB
> > > > >   SReclaimable:    4169188 kB
> > > > >   SUnreclaim:       554832 kB (-22.84 MiB)
> > > > > 
> > > > > Enjoy the memory savings!
> > > > > 
> > > > > Link: https://lore.kernel.org/linux-mm/48029aab-20ea-4d90-bfd1-255592b2018e@suse.cz
> > > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > > > ---
> > > > >  mm/slub.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > >  1 file changed, 151 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > > index 39c381cc1b2c..3fc3d2ca42e7 100644
> > > > > --- a/mm/slub.c
> > > > > +++ b/mm/slub.c
> > > > > @@ -886,6 +886,99 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
> > > > >  	return *(unsigned long *)p;
> > > > >  }
> > > > >  
> > > > > +#ifdef CONFIG_SLAB_OBJ_EXT
> > > > > +
> > > > > +/*
> > > > > + * Check if memory cgroup or memory allocation profiling is enabled.
> > > > > + * If enabled, SLUB tries to reduce memory overhead of accounting
> > > > > + * slab objects. If neither is enabled when this function is called,
> > > > > + * the optimization is simply skipped to avoid affecting caches that do not
> > > > > + * need slabobj_ext metadata.
> > > > > + *
> > > > > + * However, this may disable optimization when memory cgroup or memory
> > > > > + * allocation profiling is used, but slabs are created too early
> > > > > + * even before those subsystems are initialized.
> > > > > + */
> > > > > +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> > > > > +{
> > > > > +	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
> > > > > +		return true;
> > > > > +
> > > > > +	if (mem_alloc_profiling_enabled())
> > > > > +		return true;
> > > > > +
> > > > > +	return false;
> > > > > +}
> > > > > +
> > > > > +static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
> > > > > +{
> > > > > +	return sizeof(struct slabobj_ext) * slab->objects;
> > > > > +}
> > > > > +
> > > > > +static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
> > > > > +						    struct slab *slab)
> > > > > +{
> > > > > +	unsigned long objext_offset;
> > > > > +
> > > > > +	objext_offset = s->red_left_pad + s->size * slab->objects;
> > > > 
> > > > Hi Harry,
> > > 
> > > Hi Hao, thanks for the review!
> > > Hope you're doing well.
> > 
> > Thanks Harry. Hope you are too!
> > 
> > > 
> > > > As s->size already includes s->red_left_pad
> > > 
> > > Great question. It's true that s->size includes s->red_left_pad,
> > > but we have also a redzone right before the first object:
> > > 
> > >   [ redzone ] [ obj 1 | redzone ] [ obj 2| redzone ] [ ... ]
> > > 
> > > So we have (slab->objects + 1) red zones and so
> > 
> > I have a follow-up question regarding the redzones. Unless I'm missing
> > some detail, it seems the left redzone should apply to each object as
> > well. If so, I would expect the memory layout to be:
> > 
> > [left redzone | obj 1 | right redzone], [left redzone | obj 2 | right redzone], [ ... ]
> > 
> > In `calculate_sizes()`, I see:
> > 
> > if ((flags & SLAB_RED_ZONE) && size == s->object_size)
> >     size += sizeof(void *);
> 
> Yes, this is the right redzone,
> 
> > ...
> > ...
> > if (flags & SLAB_RED_ZONE) {
> >     size += s->red_left_pad;
> > }
> 
> This is the left red zone.
> Both of them are included in the size...
> 
> Oh god, I was confused, thanks for the correction!

Glad it helped!

> 
> > Could you please confirm whether my understanding is correct, or point
> > out what I'm missing?
> 
> I think your understanding is correct.
> 
> Hmm, perhaps we should update the "Object layout:" comment above
> check_pad_bytes() to avoid future confusion?

Yes, exactly. That’s a good idea. Also, I feel the layout description in
the check_pad_bytes() comment isn’t very intuitive and can be a bit hard
to follow. I think it might be clearer if we explicitly list out each
field. What do you think about that?

> 
> > > > do we still need > s->red_left_pad here?
> > > 
> > > I think this is still needed.
> > > 
> > > -- 
> > > Cheers,
> > > Harry / Hyeonggon
> 
> -- 
> Cheers,
> Harry / Hyeonggon

