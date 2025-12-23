Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB14E6FE24
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC8F6B0005; Tue, 23 Dec 2025 11:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA2F6B0089; Tue, 23 Dec 2025 11:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6F96B008A; Tue, 23 Dec 2025 11:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF4D6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:09:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B108FC0F15
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:09:15 +0000 (UTC)
X-FDA: 84251220270.04.9A1809B
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E30E4000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:09:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cPqc7w7/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506154; a=rsa-sha256;
	cv=none;
	b=dD6lDfVUEu3IohCdCBYa1YSSZ+ycCKlrDGRHfxLc4oui6GKo5MnmSY4v1kIFnxPoJN6JdA
	xRX3odnabWO50xjcAg8B+bhCbYsJkjudNfWM7X0D/PMeRuEavxPtZIyTETwzQESXE8rzfX
	ff/n9FEVGwily8mJw2N1RpM1UtB0PZw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cPqc7w7/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRHlLJkSrDB1D+zQb/dTsxZCxO2afpT1zq6PqLAXbQI=;
	b=8GDmNzAFM7BOoTF8+LreBo61LB2UMw15eoaaFZ4cX5NW5of0AMQOrj4BGNxwS8DLxW4Oac
	kBkNSV71df3jzPwzQQAj61qnPjFzt3JxNbZszLe14e6YdaAozBl0vRGOssK9OPIKdpAa63
	fXhKetJaB6bEB1zJyDhmaBciqc1R56c=
Date: Wed, 24 Dec 2025 00:08:36 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766506150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XRHlLJkSrDB1D+zQb/dTsxZCxO2afpT1zq6PqLAXbQI=;
	b=cPqc7w7/X07bIpzdwHmn07rHMzYNpXBSdG1IgEJ46i2zRsqyHBXmjfxhEd5baz5OXordbo
	Bn+9LNtFqXM+ET5Z7M4bSQqrmaBtluoU/X3UhPwT/GaHbeo4OPGs2NdHWf+YSNJolJXl4X
	jawKc5iy3spTfUKyWXJ+AyPq+6hOTcU=
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
Message-ID: <zex6wgdlxk5vgwm7ou657fdmi27xnxihdndlszfa2chghamfuz@grhtfqw7gm7o>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-8-harry.yoo@oracle.com>
 <graryni6wadpi3ytfq7zimj2kbmm7dumxvhxtzmxndrv5s2y67@ju4cdnsmos6e>
 <aUq1x_BowqYpHZAQ@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUq1x_BowqYpHZAQ@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5E30E4000C
X-Stat-Signature: 1eagbrzfumg85cwpbz6t5yoc8sqwqbzr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766506153-157525
X-HE-Meta: U2FsdGVkX18UI3NnViK1CZqym3h+hGjUfTF23f0qxbBJmgEWzm6taWOzk4b0qQoXn7YbW77HAlbVwQ88CmLkrjyNvsTPC/BVSJy9vujPHWdFuEWWOACwJCKdp609cRvpx/RgSYDtsURO6K+uhpPKtrH82mLVkDQhyzmzLWG8hBRGVfEQLBkNPm4MCLNbDfI9SNQSCRQ6CGZepYYUn+zvyOQANkSTJsvazhPIUOVL8cFBH8kZo0nCgFTe3RKlR9vx8HuVIj7cYaugQhmJ7c2Kkl3k4NFg+p1CY9/g7rL+y/6Ye7lgewd/vKupI01bMxbc9vo+/whw0rahMfPccIBckUMv0sRkeq0O2+9YfSg6oLsC33LADVTMiklL4jPA2nXHfm/yvuS+GrdC7t9sMxmrlFWvKD9gUau+830UBD8g5C9kVDtXYcipAbdYumFgKJAqqV/u93fSmchjyQybid5eEa62K6xsj1lMUR+fOSSIzcIUWejKZsd1T0COe4BVEcwuNC/KiqqD33LOQGNcnG7/CbJd2mKMM73dgh3dMhPjQ8OCIe56cYorWVbUf5Sy5u4KO5SjJNQP0u1fOGR8flKZX7NJ3RlNJveahsENAbMmdVczizkCTdorYEYjWqzAFVdRkqPzad0hmn7Y23fChFcJLMwU9G1d736x5d5h+kkjBo9LNq9InMqIrHoMPNfXi5Jv2L1fLrTecmV4sC9Jvua6PfuN1320gzacvf0k9xM/cup4c9KlRp6PSUvAr+5UZwPOjmIY/W6Sodf9/v2XU6rVfWZDyAslQcrdeHkbkDuFhfq3+oQPf0jcE2VSMhjH/IPx3V5Vm9lGRGKtHG2C/KVseQcMSJaNfuMmDdjHcr3Cav1ARsNCT6irJ6LRCP2qTl+SkmAK2eq6kFzqrmyn8BN9sUgNNfJGpYrdZ6gdObVGIYePDhi/G1WmeXTBLj5YDVQWeHWeWmTugETyBBs34Zq
 wNy6ZvHq
 cDgWU53+SW+kw5IE4fZHp4ZeW8gyAbgMAU7i+ILSIdVNXIrXpyFts7EyaFKRo93oPHbyWc/2UAv93kS/ED1+IwFrIqVF8PZqBXKI08DfLPAANAiJQvQ/2S3wKgCD2E0DlXnlbFprJTIv0/MEZohAuyeiTO4/nccOcnoVFtrx8edZ5vB8Sqgj0T2mqi7OniOk/3IEcwaP9zD2b1f9lHUNNzoaFv44K1fwAQyviWV+Utz8+JnPH5lLolvJeb/8ocXvm4lbkp5cku948JZEYPiZI1htVmyb0ps2A2ZmPgmFc2ynqI3yCjM9hn4QQH0mlyPUic2mn5eWK0b55g7NenyMUdJEBX8zcIgHIWqO0cmTHkJW3SgIVQB83Qt/hkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 12:31:19AM +0900, Harry Yoo wrote:
> On Tue, Dec 23, 2025 at 11:08:32PM +0800, Hao Li wrote:
> > On Mon, Dec 22, 2025 at 08:08:42PM +0900, Harry Yoo wrote:
> > > The leftover space in a slab is always smaller than s->size, and
> > > kmem caches for large objects that are not power-of-two sizes tend to have
> > > a greater amount of leftover space per slab. In some cases, the leftover
> > > space is larger than the size of the slabobj_ext array for the slab.
> > > 
> > > An excellent example of such a cache is ext4_inode_cache. On my system,
> > > the object size is 1144, with a preferred order of 3, 28 objects per slab,
> > > and 736 bytes of leftover space per slab.
> > > 
> > > Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> > > profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> > > fits within the leftover space.
> > > 
> > > Allocate the slabobj_exts array from this unused space instead of using
> > > kcalloc() when it is large enough. The array is allocated from unused
> > > space only when creating new slabs, and it doesn't try to utilize unused
> > > space if alloc_slab_obj_exts() is called after slab creation because
> > > implementing lazy allocation involves more expensive synchronization.
> > > 
> > > The implementation and evaluation of lazy allocation from unused space
> > > is left as future-work. As pointed by Vlastimil Babka [1], it could be
> > > beneficial when a slab cache without SLAB_ACCOUNT can be created, and
> > > some of the allocations from the cache use __GFP_ACCOUNT. For example,
> > > xarray does that.
> > > 
> > > To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> > > MEM_ALLOC_PROFILING are not used for the cache, allocate the slabobj_ext
> > > array only when either of them is enabled.
> > > 
> > > [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> > > 
> > > Before patch (creating ~2.64M directories on ext4):
> > >   Slab:            4747880 kB
> > >   SReclaimable:    4169652 kB
> > >   SUnreclaim:       578228 kB
> > > 
> > > After patch (creating ~2.64M directories on ext4):
> > >   Slab:            4724020 kB
> > >   SReclaimable:    4169188 kB
> > >   SUnreclaim:       554832 kB (-22.84 MiB)
> > > 
> > > Enjoy the memory savings!
> > > 
> > > Link: https://lore.kernel.org/linux-mm/48029aab-20ea-4d90-bfd1-255592b2018e@suse.cz
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  mm/slub.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 151 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 39c381cc1b2c..3fc3d2ca42e7 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -886,6 +886,99 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
> > >  	return *(unsigned long *)p;
> > >  }
> > >  
> > > +#ifdef CONFIG_SLAB_OBJ_EXT
> > > +
> > > +/*
> > > + * Check if memory cgroup or memory allocation profiling is enabled.
> > > + * If enabled, SLUB tries to reduce memory overhead of accounting
> > > + * slab objects. If neither is enabled when this function is called,
> > > + * the optimization is simply skipped to avoid affecting caches that do not
> > > + * need slabobj_ext metadata.
> > > + *
> > > + * However, this may disable optimization when memory cgroup or memory
> > > + * allocation profiling is used, but slabs are created too early
> > > + * even before those subsystems are initialized.
> > > + */
> > > +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> > > +{
> > > +	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
> > > +		return true;
> > > +
> > > +	if (mem_alloc_profiling_enabled())
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > > +
> > > +static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
> > > +{
> > > +	return sizeof(struct slabobj_ext) * slab->objects;
> > > +}
> > > +
> > > +static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
> > > +						    struct slab *slab)
> > > +{
> > > +	unsigned long objext_offset;
> > > +
> > > +	objext_offset = s->red_left_pad + s->size * slab->objects;
> > 
> > Hi Harry,
> 
> Hi Hao, thanks for the review!
> Hope you're doing well.

Thanks Harry. Hope you are too!

> 
> > As s->size already includes s->red_left_pad
> 
> Great question. It's true that s->size includes s->red_left_pad,
> but we have also a redzone right before the first object:
> 
>   [ redzone ] [ obj 1 | redzone ] [ obj 2| redzone ] [ ... ]
> 
> So we have (slab->objects + 1) red zones and so

I have a follow-up question regarding the redzones. Unless I'm missing
some detail, it seems the left redzone should apply to each object as
well. If so, I would expect the memory layout to be:

[left redzone | obj 1 | right redzone], [left redzone | obj 2 | right redzone], [ ... ]

In `calculate_sizes()`, I see:

if ((flags & SLAB_RED_ZONE) && size == s->object_size)
    size += sizeof(void *);
...
...
if (flags & SLAB_RED_ZONE) {
    size += s->red_left_pad;
}

Could you please confirm whether my understanding is correct, or point
out what I'm missing?

> 
> > do we still need > s->red_left_pad here?
> 
> I think this is still needed.
> 
> -- 
> Cheers,
> Harry / Hyeonggon

