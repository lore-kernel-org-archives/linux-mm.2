Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B273CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE3194000A; Tue,  9 Sep 2025 05:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8603940007; Tue,  9 Sep 2025 05:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BC094000A; Tue,  9 Sep 2025 05:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81FEE940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:08:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43761160459
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:08:27 +0000 (UTC)
X-FDA: 83869135854.22.AE55283
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BEEC4000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:08:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KmR2f/ro";
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m15/6HK6IXoWcPOIkEnGT9WR5ix6JXTW5qiMEnkeKfY=;
	b=pJkMCXYNo0P7W7M7g1zkvWQSBxXV1wrK5KLIC0G+Ir1ORnDcoTiFzzTa8EVasF14dwz1QF
	xRBTi1a+iAd9xh5jBUM2sy5CEAOGbtQ8KRuTHQuY4p5n4+I+sYaH/gl9jnl3M9eaChMpBw
	Z1imfHL+2mPovkl28++0eU5BQnuSSi8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KmR2f/ro";
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408905; a=rsa-sha256;
	cv=none;
	b=NpZfkHjR+jAREGl2jlgMuXlDoWkTQjO+MbqFd9REPu/4mT1lxAd6OBOEaxTTDaANPiG5g+
	2MrLWJPWeChAXTWavPHEB33WY2YGDKo0lzd5f7aV3AXErrebcNl+dP7MPgNGBrV1ntDGAU
	5gK99jeSBB8OiUNQHz6Yb05LJCLuHAY=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55f68d7a98aso6312825e87.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757408903; x=1758013703; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m15/6HK6IXoWcPOIkEnGT9WR5ix6JXTW5qiMEnkeKfY=;
        b=KmR2f/ron/2eZEMrB5oE332chafAvlPC+7CI57hMwR78mIRpZdiGUOs9c9uEBgjy2I
         ye/02M7Soo0V4WTHsC0/zYSM4ZvkbsJZBGFAVT3sUVphCIKrLauxONyPYrgCek4s1AJw
         z3/6dV4yM17trGFneWGDusYS4M5oX/6XoJSg37FgR6q+M1xhIYgauCbpMKSLucubKxDu
         vqZB7TCnT0vG0cyWUyDSPrmchiBNpmivqRSFwGKV4CA8eCf4QyGc5+kFdO5DyOVG362p
         yba7ERJdpsnbmYzgRkaOpk+wdoFM9v86m1qdHOV9HYwnM8AXqRRi6I3LzGXP1VF2ZJAk
         1f9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757408903; x=1758013703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m15/6HK6IXoWcPOIkEnGT9WR5ix6JXTW5qiMEnkeKfY=;
        b=pYc8oA/mDivn2HawRyiuu3LHvV15E0Y9TlsQiM3VdpNbegMOaynk844tzcKioumyim
         Xam9pRPTZV7oOk1Y3sCR/eEP30v8gKEg/HoBJ5zqo98xO/vpCjrCYDZpJkVurkbp+Oxn
         4Bb0jYoCRuddizvKoIZLRRWcQuupq2p36sUvEOHK98RsmbxZWJLbP+ntWOlYgmqk7Eaw
         u1VHge0U2YVr4vmUhQSklPTLwKIQDkvoFrpuwRaMN5GnAkkgVnxVWFoSYOsDk4KYf8tf
         K94B5yq9tV28jBGJNSlmh3t2jZCAEjl7RGYCWXZJCtMWoX4rzbrYXTS1vZif4zRjd5KL
         Yfow==
X-Forwarded-Encrypted: i=1; AJvYcCW5htjJmCikUHTF4tgNzUtbJx9d9yT2r4hR8FcommLG0e2u0JXX5MZS7bDhLfiFMlCiUVUn1KV+wg==@kvack.org
X-Gm-Message-State: AOJu0YxgRTNcykSTQqU45hE5eyxmgduj5JH1CZL95CwUn2Jz8neOlKBf
	Qnx2+8zm/k4xd0OAN5iPMl8Dl20D7EaA9+aCK05o5geEiwlt6Elkz7sw
X-Gm-Gg: ASbGncvwKAe+HC8OJnKi0lLASYxYjWSebdGN1XrZYCfjyu9MHtm+GYrfkJ0Tjxra3S5
	sQ6tTcdu4QXzAHGhX9gqyGMKD4V8QkM7pulvqab2ka0WWwcW26XN2FRQpB0naSJt5I5WHuziG+P
	AWxIE3lO+ryJ4fgkgSzvKQWp4mOTB8pCRqnquD5fnaUDij7T/uWJVATslflnx/4omIOurGM9Plw
	LSQlrovnfL3wJEkqj2grc4VCUidGnQBNiZz1WcBeQAkuYSSp4hz153iMtvMtvxNl17Gi8aOvSaN
	jACHW8kaa5fzSDzSCFVeteEKNMyFr0MwK3WjEYaqtE+NwRSj55Ncjk/eyqA3KvNIsiI53OvrBqw
	FItSkpv/fdroF9/zzdbmBP50WufV9tEzXy5gGqZVxSEkGRtidJXdIFL8dvcRp2cumb/utgo4=
X-Google-Smtp-Source: AGHT+IEnyV5ZBqivGAbEdD2OGowTdG9/z5D2YczrchhVQjLP1DvK2+GKpP7bXLYhTGA7oyfnNfxlPw==
X-Received: by 2002:a05:6512:63c5:20b0:563:3ac3:1ec1 with SMTP id 2adb3069b0e04-5633ac31f71mr2335880e87.54.1757408902875;
        Tue, 09 Sep 2025 02:08:22 -0700 (PDT)
Received: from pc636 (host-95-203-28-174.mobileonline.telia.com. [95.203.28.174])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5680c4246f2sm390317e87.26.2025.09.09.02.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:08:22 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 9 Sep 2025 11:08:20 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v7 04/21] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aL_uhPtztx7Ef0T2@pc636>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
 <aL7FFpIMmXtzzSL1@pc638.lan>
 <6f8274da-a010-4bb3-b3d6-690481b5ace0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f8274da-a010-4bb3-b3d6-690481b5ace0@suse.cz>
X-Rspamd-Queue-Id: 6BEEC4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: pkwd6h6ge96yxj1ee3dat3yzr9uch8na
X-Rspam-User: 
X-HE-Tag: 1757408905-296666
X-HE-Meta: U2FsdGVkX1/M9zCdvTZo98ioYE9aSymgHQ7Eo4fRF7cXQcx+jWPM9hy7DpaP0mGkfKN5yLEnlFMaw1nb0IIsxlKmQ4zBAi468rK5Ae+zSutATLRWcSJCpsRwMH84h1iltPbA+dG0niCyf5VY6H8qknXOCTFt6TGW4v7xOI84C9ptyriNo3s10jg7QzqbIFtCmIAxo6hsbcfIBL8N3qBtAJHFX+PbqREzjbkWXJ1E9AvS1oPQaivIEewiPK/53G0mtsUaRlanlpeYCew1KZWHWMrZ2rcnzR75JR4B4NwvURRQ5H5Mca6cEh6fI0TNdyGlM9QuLhmfDgRBJqvgcSbnVOr/LXpBjxzrxcJBcwjHmwgnFG1MxiF265/ztV92cequ3ZuBgcKDnkLV3y53sfJD4aZLX03k6atzxOxJ3rI0mfJ0b7chB2YTNbiSUDH/FU0p7MwGyY+lOVXOXLaSaMPYpSJxlnKPJmMlJn9P2hv8Zh0pYwL+1VZ7q1Xo+f33lQiq7j4TJcZnxKKBeyOVvoBXnBR3qUnMWfKBj3HoUeIwoooL5aQ69GzsH5nvb0iZCk7PJj6xG6pKeo00KhsMG2wJMYIylG6p+ajVcHWs18eJfVRx6P49QNVWJq89yGBYCyhqPkB4o7Gfp1NJKE+XsgFqIt62kxyQ6PWSBGjthNL12Wv0VrsGJN2sHPAn50ZwGd8mZwzVStXwQeczTAmPnWs4duDm58aPAnp/YKTC9De9pUZR1AcNPtfaveng3n2+Uooz9v+FbOse4p6au+78n5zSTxPBonx/1mLHGLcAf3CfNet+FdmxqeI1wlTowYjBgO9dNS+6IUGi/39FIWp5tWGaawgF3hK58bkHwIaWcsMQRotpkwjY54QtUaAhKDA7j3XpL4do4zGCfhkqaFYmJq2a9mkIDthJPeiSExE7EC9RDQAHjJqAouATaYRUEvJ25K8vn1xkSyhALA4HliKQ2Ma
 WSm9cYwO
 gTjEG4pcmlFFBdHAIfx3PJN7IQ69ppdiz+5omKzFrCrSplB0f/CXneKsdK27kIj06RT2Jj6Gv0j4ewTZl3rmK52JafCfoclzLzsgV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:45:11PM +0200, Vlastimil Babka wrote:
> On 9/8/25 13:59, Uladzislau Rezki wrote:
> > On Wed, Sep 03, 2025 at 02:59:46PM +0200, Vlastimil Babka wrote:
> >> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> >> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> >> addition to main and spare sheaves.
> >> 
> >> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> >> the sheaf is detached and submitted to call_rcu() with a handler that
> >> will try to put it in the barn, or flush to slab pages using bulk free,
> >> when the barn is full. Then a new empty sheaf must be obtained to put
> >> more objects there.
> >> 
> >> It's possible that no free sheaves are available to use for a new
> >> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> >> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> >> kfree_rcu() implementation.
> >> 
> >> Expected advantages:
> >> - batching the kfree_rcu() operations, that could eventually replace the
> >>   existing batching
> >> - sheaves can be reused for allocations via barn instead of being
> >>   flushed to slabs, which is more efficient
> >>   - this includes cases where only some cpus are allowed to process rcu
> >>     callbacks (Android)
> >> 
> >> Possible disadvantage:
> >> - objects might be waiting for more than their grace period (it is
> >>   determined by the last object freed into the sheaf), increasing memory
> >>   usage - but the existing batching does that too.
> >> 
> >> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> >> implementation favors smaller memory footprint over performance.
> >> 
> >> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> >> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> >> many had to fall back to the existing implementation.
> >> 
> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> >>  mm/slab.h        |   2 +
> >>  mm/slab_common.c |  24 +++++++
> >>  mm/slub.c        | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>  3 files changed, 216 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 206987ce44a4d053ebe3b5e50784d2dd23822cd1..f1866f2d9b211bb0d7f24644b80ef4b50a7c3d24 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -435,6 +435,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
> >>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
> >>  }
> >>  
> >> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> >> +
> >>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
> >>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
> >>  			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
> >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> index e2b197e47866c30acdbd1fee4159f262a751c5a7..2d806e02568532a1000fd3912db6978e945dcfa8 100644
> >> --- a/mm/slab_common.c
> >> +++ b/mm/slab_common.c
> >> @@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
> >>  		kvfree_rcu_list(head);
> >>  }
> >>  
> >> +static bool kfree_rcu_sheaf(void *obj)
> >> +{
> >> +	struct kmem_cache *s;
> >> +	struct folio *folio;
> >> +	struct slab *slab;
> >> +
> >> +	if (is_vmalloc_addr(obj))
> >> +		return false;
> >> +
> >> +	folio = virt_to_folio(obj);
> >> +	if (unlikely(!folio_test_slab(folio)))
> >> +		return false;
> >> +
> >> +	slab = folio_slab(folio);
> >> +	s = slab->slab_cache;
> >> +	if (s->cpu_sheaves)
> >> +		return __kfree_rcu_sheaf(s, obj);
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  static bool
> >>  need_offload_krc(struct kfree_rcu_cpu *krcp)
> >>  {
> >> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
> >>  	if (!head)
> >>  		might_sleep();
> >>  
> >> +	if (kfree_rcu_sheaf(ptr))
> >> +		return;
> >> +
> > Uh.. I have some concerns about this.
> > 
> > This patch introduces a new path which is a collision to the
> > existing kvfree_rcu() logic. It implements some batching which
> > we already have.
> 
> Yes but for caches with sheaves it's better to recycle the whole sheaf (as
> described), which is so different from the existing batching scheme that I'm
> not sure if there's a sensible way to combine them.
> 
> > - kvfree_rcu_barrier() does not know about "sheaf" path. Am i missing
> >   something? How do you guarantee that kvfree_rcu_barrier() flushes
> >   sheafs? If it is part of kvfree_rcu() it has to care about this.
> 
> Hm good point, thanks. I've taken care of handling flushing related to
> kfree_rcu() sheaves in kmem_cache_destroy(), but forgot that
> kvfree_rcu_barrier() can be also used outside of that - we have one user in
> codetag_unload_module() currently.
> 
> > - we do not allocate in kvfree_rcu() path because of PREEMMPT_RT, i.e.
> >   kvfree_rcu() is supposed it can be called from the non-sleeping contexts.
> 
> Hm I could not find where that distinction is in the code, can you give a
> hint please. In __kfree_rcu_sheaf() I do only have a GFP_NOWAIT attempt.
> 
For PREEMPT_RT a regular spin-lock is an rt-mutex which can sleep. We
made kvfree_rcu() to make it possible to invoke it from non-sleep contexts:

CONFIG_PREEMPT_RT

preempt_disable() or something similar;
 kvfree_rcu();
  GFP_NOWAIT - lock rt-mutex

If GFP_NOWAIT semantic does not access any spin-locks then we are safe
or if it uses raw_spin_locks.

> > - call_rcu() can be slow, therefore we do not use it in the kvfree_rcu().
> 
> If call_rcu() is called once per 32 kfree_rcu() filling up the rcu sheaf, is
> it still too slow?
>
You do not know where in a queue this callback lands, in the beginning,
in the end, etc. It is part of generic list which is processed one by
one. It can contain thousands of callbacks.

If performance is not needed then it is not an issue. But in
kvfree_rcu() we do not use it, because of we want to offload
fast.

--
Uladzislau Rezki

