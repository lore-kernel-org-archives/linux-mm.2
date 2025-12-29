Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD23DD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 11:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4E36B0088; Mon, 29 Dec 2025 06:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81D66B0089; Mon, 29 Dec 2025 06:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D986B008A; Mon, 29 Dec 2025 06:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C46D66B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:56:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 571FA1406A9
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:56:58 +0000 (UTC)
X-FDA: 84272357316.15.18977E3
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3DD8B140004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:56:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oluR3wP3;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767009416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bB3emZmucVN1uPHpduAK6KhrmkIMJw57149J91Ece0c=;
	b=ycEeKbFWXF5KE+JT33DlLNu63XMtCDP+eINr2Zsu/9RLOdav8MQUDZ8Bz2I/fKTU1Ribt2
	fSjCPD0ptiJy70pP5foj2loCyAbsOoJn2atQUlVKEtdo/QhZUcA+rqIPbdVrjq3BiMgCia
	KuBDOsO3/75JGq6fpG56d6cdsTJL3Yo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oluR3wP3;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767009416; a=rsa-sha256;
	cv=none;
	b=sZ3SjH9yFHa6YNIUyw3r14cSMxEoqcXGtpOp0Rw7uuis4rjW0VJlWcpopY1rArGQsIBD96
	AOc2AMJpxXJQUeqCXyogUKN2+WMhrsRwUNlAZVjmCdL9VDPxRB4VXlWaBGdCeZy9p8DcFh
	9h8Fg1QgV7ZLdI1pBdRsI6f/1uA/bjY=
Date: Mon, 29 Dec 2025 19:56:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767009413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bB3emZmucVN1uPHpduAK6KhrmkIMJw57149J91Ece0c=;
	b=oluR3wP3aHDwiT/bP9WayJPD+hzp2XQ6wGg7CCwyfQD2cegoRosNsfJs59n7HJt+3F5NfK
	zlnshSAvfyYAHQHLkQLjj8wPHUYKzbPKJSi6ndlHGHNfsF+IQmcxCsRhywBtamWUYV7m4Z
	mgl3ma8uo4IuE0Gf/lUQlY0W6OuKlzA=
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
Subject: Re: [PATCH] slub: clarify object field layout comments
Message-ID: <k52hessiwmea5aozrs6vs7riecvoqkbhxyrtismbg5f6fl447e@p4w3ru3wvf4c>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-8-harry.yoo@oracle.com>
 <graryni6wadpi3ytfq7zimj2kbmm7dumxvhxtzmxndrv5s2y67@ju4cdnsmos6e>
 <aUq1x_BowqYpHZAQ@hyeyoo>
 <zex6wgdlxk5vgwm7ou657fdmi27xnxihdndlszfa2chghamfuz@grhtfqw7gm7o>
 <aUrCXYdziRWP9PfV@hyeyoo>
 <c6owr44jdncf7q5zqgq4wn4pm57ai4cd3upauwmwszopuddf5g@52mkqbe2m27j>
 <aUt_1uDe05diks7b@hyeyoo>
 <z7d52kjvlzxohbly42flhtebqc7knfvilierrjr4r5776rxhgy@lcqmkcpzklse>
 <aVIoyh9fXoxKTUSa@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aVIoyh9fXoxKTUSa@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3DD8B140004
X-Stat-Signature: yd7jyyczyjcq176hmy6g6at6zsccjy14
X-Rspam-User: 
X-HE-Tag: 1767009415-234442
X-HE-Meta: U2FsdGVkX1/5uuzj6fkYL7LdLtKFcs1DU3rNUxvsUG0nH7gRVmCZ/MuIyu811KgJ/7vRZ7F56wk5w5jxLRGgmrxG7hMgDf5BLcAdCME60Nr4zyn4is21jGlE2lW/V2lfW2Z9LwMV91VYlVnwlK32uD3BvKedFCXSGNJlXt9cz50jBNKe5usMSUp++VhAEQNKRx9toVphs0Ywuvqb7705PDa2gy9B9NapvAd6ewHAC2ltx8IriROWSQa1kBE5j1shwEKu7+m5dDvqh0CLMuwyolEjIqClzlnVVaXKQpgmMJxQkJTEh9b2vs4H7Cg9n5cOLF2RmdMYm7qcif8wKkzjbVZPlma5TrQZ0XJrw44HOY/KD9Xm2W5Jd3W6lVU0y1ggpQPTvxrvuiq12QTXjW2qqgZ76os79zfPbVi7AuhHguxSaNEOe/D4BTP/+kJ2t1i66KqqPVnkrzyIdDX65ZAGkLto6iFRjx+3gVRwe1NzwySLFHmPGKXOAZoSIRIWzZbbEBeMkLZMKodD66pUQULuXpnDLK2aWyaGmnpemBaVaLDXa0smQVBZsszRBr9u7Cl9Ok5EUk+i/k9+TNPUGDl/38FKgMieW3TWIcfJ8dNoSIYQnEDmUOIVkNZ1HjuTIlAirHLFx3eoCSWT0uIlbAMO0Qw3j3jsp++fLEp2mh1CoFLUcvrSQASroyP7TYF+KLmlKopxpHqEJVjCsKVeSDCoBseZ9+9ozV3HsWEc4ghq549PXrDeyede4fRDJm7yPRCODS1gJvb3mvZdxZzxvrif2MzkyPyFCGRHAF1J+lbLnGCD8ApGi0r1qtmu1uuDXqe3AJsN+BHhcJHNLq+jZiFQ30nkADldgHnpommzLKI6IPuUphFfZbjcewVGkXqbYsHGLCpCn/Kd+vlIn2sR7kn+8THlRmOyRVyukrg7FYWbC2bD5MMpkl1Y3PyV0C8u9isEB4CNv6lh9OWj/VhfOfM
 LNcbtUqJ
 rRtih3SvScjIO1fcmfqmt3cW9lz7J4XOeeDVxAD+a3rWDqhJyd1j6q1/7NXNFN6y2V5upTYSZvwuC3L9amuUKTgCGy2Um8cPEmLt4eMQFHhlHeZp14eRQrsBAIHtz7imIo1prJxGpNzX9GyhVG0kjZEFHoifvgHYGqtZhbU98lS2/biLFos/6e9+V6FVTmxbqWaiMhYTWqn6NroEvnlrpqU+OhmZkvSzNejS95Zgkzj0ph5hih9fX7JmqzY1Ad6RksvvthPlO22PYnoUuYh6wYOw1V+R/LQ5MPdHPQ3oSHSWTYC3PuO0N7CEdiYXBbYrLq1AKKqhBV0LMqow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 04:07:54PM +0900, Harry Yoo wrote:
> On Wed, Dec 24, 2025 at 08:51:14PM +0800, Hao Li wrote:
> > The comments above check_pad_bytes() document the field layout of a
> > single object. Rewrite them to improve clarity and precision.
> > 
> > Also update an outdated comment in calculate_sizes().
> > 
> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > Hi Harry, this patch adds more detailed object layout documentation. Let
> > me know if you have any comments.
> 
> Hi Hao, thanks for improving it!
> It looks much clearer now.

Hi Harry,

Thanks for the review and the Acked-by!

> 
> few nits below.
> 
> > + * Object field layout:
> > + *
> > + * [Left redzone padding] (if SLAB_RED_ZONE)
> > + *   - Field size: s->red_left_pad
> > + *   - Filled with 0xbb (SLUB_RED_INACTIVE) for inactive objects and
> > + *     0xcc (SLUB_RED_ACTIVE) for objects in use when SLAB_RED_ZONE.
> 
> nit: although it becomes clear after reading the Notes: section,
> I would like to make it clear that object address starts here (after
> the left redzone) and the left redzone is right before each object.

Good point. I’ll make this explicit in v2.

> 
> > + * [Object bytes]
> > + *   - Field size: s->object_size
> > + *   - Object payload bytes.
> > + *   - If the freepointer may overlap the object, it is stored inside
> > + *     the object (typically near the middle).
> > + *   - Poisoning uses 0x6b (POISON_FREE) and the last byte is
> > + *     0xa5 (POISON_END) when __OBJECT_POISON is enabled.
> > + *
> > + * [Word-align padding] (right redzone when SLAB_RED_ZONE is set)
> > + *   - Field size: s->inuse - s->object_size
> > + *   - If redzoning is enabled and ALIGN(size, sizeof(void *)) adds no
> > + *     padding, explicitly extend by one word so the right redzone is
> > + *     non-empty.
> > + *   - Filled with 0xbb (SLUB_RED_INACTIVE) for inactive objects and
> > + *     0xcc (SLUB_RED_ACTIVE) for objects in use when SLAB_RED_ZONE.
> > + *
> > + * [Metadata starts at object + s->inuse]
> > + *   - A. freelist pointer (if freeptr_outside_object)
> > + *   - B. alloc tracking (SLAB_STORE_USER)
> > + *   - C. free tracking (SLAB_STORE_USER)
> > + *   - D. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
> > + *   - E. KASAN metadata (if enabled)
> > + *
> > + * [Mandatory padding] (if CONFIG_SLUB_DEBUG && SLAB_RED_ZONE)
> > + *   - One mandatory debug word to guarantee a minimum poisoned gap
> > + *     between metadata and the next object, independent of alignment.
> > + *   - Filled with 0x5a (POISON_INUSE) when SLAB_POISON is set.
> >
> > + * [Final alignment padding]
> > + *   - Any bytes added by ALIGN(size, s->align) to reach s->size.
> > + *   - Filled with 0x5a (POISON_INUSE) when SLAB_POISON is set.
> > + *
> > + * Notes:
> > + * - Redzones are filled by init_object() with SLUB_RED_ACTIVE/INACTIVE.
> > + * - Object contents are poisoned with POISON_FREE/END when __OBJECT_POISON.
> > + * - The trailing padding is pre-filled with POISON_INUSE by
> > + *   setup_slab_debug() when SLAB_POISON is set, and is validated by
> > + *   check_pad_bytes().
> > + * - The first object pointer is slab_address(slab) +
> > + *   (s->red_left_pad if redzoning); subsequent objects are reached by
> > + *   adding s->size each time.
> > + *
> > + * If slabcaches are merged then the object_size and inuse boundaries are
> > + * mostly ignored. Therefore no slab options that rely on these boundaries
> >   * may be used with merged slabcaches.
> 
> For the last paragraph, perhaps it'll be clearer to say:
> 
>   "If a slab cache flag relies on specific metadata to exist at a fixed
>    offset, the flag must be included in SLAB_NEVER_MERGE to prevent
>    merging. Otherwise, the cache would misbehave as s->object_size and
>    s->inuse are adjusted during cache merging"

Agreed. I’ll reword that paragraph along your suggestion to emphasize
the fixed-offset metadata requirement.

> 
> Otherwise looks great to me, so please feel free to add:
> Acked-by: Harry Yoo <harry.yoo@oracle.com>

I'll include this Acked-by in v2. Thanks!

-- 
Thanks
Hao
> 
> -- 
> Cheers,
> Harry / Hyeonggon

