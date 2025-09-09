Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B992CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762616B0029; Tue,  9 Sep 2025 05:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713006B002A; Tue,  9 Sep 2025 05:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4EF6B00A4; Tue,  9 Sep 2025 05:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 412A36B0029
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08F311A045B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:50 +0000 (UTC)
X-FDA: 83869151940.03.0B0AC63
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E09010000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQ1U5lSa;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RxmiKOX9ZqvhLioBhgvr1KVktvLZ6CG0rToqxQ3c5A=;
	b=Yal1e9iay7CDOOO0mLEfVdq1sSs7hmSuOW4P6DAZ6O37BLDpHtl7tBbTflkeYrI9VlEQDu
	cycI29tJHxlT/ujMqCW4oCD8IDX59nLKxo7dS2E5LMcuB9q+6LESPjE1zOCCoQ2b4LIINB
	fN5xMnls1rg7DW2bkg8h6LJ7QcD55xQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409288; a=rsa-sha256;
	cv=none;
	b=zxo17uHxCP8oOdrNkd/MKf+qFiHavaxAJpaDsowdOoQXOOurfsSchm25jy2a2aSZJy42hB
	mbH9/6+xpgjMRAyTQoOov8Kh92WQTkbLcufuPQHHKbB+Win6kPTKpaDlltMhFxOz4uBCUk
	cqRDpiWRDa1q2S+j69asdKj5XNusRF8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQ1U5lSa;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f6f7edf45so5109058e87.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409286; x=1758014086; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/RxmiKOX9ZqvhLioBhgvr1KVktvLZ6CG0rToqxQ3c5A=;
        b=PQ1U5lSa/vnLtxy4HI/l0lOOCnxS7njDmJhvXatQTWfXeSB1BcMoFj6VZSIZ0IJtCN
         SXQNQDn3kVbTNLVrICLsYnQubva30QHe1i8NrCQWexv4rv4Wy/rvkugvanT4WPd7Fh9m
         WNMt1w08FzWl6Go9Rors72kz/uq+yjOCZmsmM1DOnOxUynWUxWfEftmYR/4mGWyLGXJo
         XJ8gwAIBFsbLCIY/QzWcBOXNSatgrUibkwla5x8ndJf3hsa6dRWzzz9Qfhc2tHB9uwgX
         NZbD31Nz2JsiaHJ8BmHFEr/gl9u5r1ZnhPkpdamRt29ktDsf8aUBKBVoLCRQK7Hm+tUt
         NTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409286; x=1758014086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RxmiKOX9ZqvhLioBhgvr1KVktvLZ6CG0rToqxQ3c5A=;
        b=p/6gvhbJBdTOZ/IqegdbNn+6vTdQrzotHMjiAjqJMtFTwmpQWgmUEJ7oFDt91LEknC
         veTe8yoEHf+G6hePp5g1RFddzHgsbPknxpYEjyZu7jpGtqnWrp9K46u7TZ27/M3sUIdV
         MUvhP9svnAgd1o2eYD2dJt34sSOMqIrjsx5/GoBuMDM3phTDX+flJy9ZneMD2u/Vowe6
         VHNKaXlk6x3Kthl9cUS3SlWO4zr6fKy88ZUIMjk+0p0vRwj//ZSl69CEPnD1QBAhwfpP
         C5Efa9QK2u4coZVanbtr24soUoK9YW0CuVRmSm5I2o0cpkIIf351YLSUpqxQadigCGIi
         5qbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS3M+vtF1N4Ty58GZ/upud4iEQItqL2S1GGFPD3LsLIOjhJeQM8wlmIksJmrsmmJApKwLbHn7Rzg==@kvack.org
X-Gm-Message-State: AOJu0Yy2F1S3IJATzwYUPc6kRoTIXpw8yswoPjox33960WK1LvW3bjOa
	aC1Asim3dHWP2Ec0FHyD96lhvYLKvypYGfBEpa6cCTtHthPK7no/sAhW
X-Gm-Gg: ASbGncuuYDg/RpfWvDuOLQDoSDULMQLb8JiFvqFq6XIBwfOAjIqRQA8BHWoIvilUCTe
	8/W4hMDWzhSneNQMXLoBtI9euNFjSvlOE7X60vllg/Q/m+vPWhoWJWx+uApZTWXKo936ZMjlNyA
	q1gjh3afRd2ZYnW07PAqVC8/07UH1LXLIyrvGcP68knQfHESEP/P05jtBYm3MmWBb+qEUQ6HcpR
	hxQKdROBlBX2D2XU0SU7hKAozFKfW41gwfxYhY7cb5PFzlFJZ0enn0u9Y4pQQqNNbHXhK2EJ65+
	j9Grh+CYLrv+TeYioqNahgCCexzJsHm4vqQUoeVqeQN2aDz20aX1N5jrInHW6OpWUugfUOS4OTp
	r8151ty+bI/3fdTDT9X5tVWsOfgVciaZXCER/ooqUduS5WLl9M6gdnG/K0xjO
X-Google-Smtp-Source: AGHT+IFf6hq4f3MPnoPFO1ztcKAg+1ws4rmkr3VqrlRe2DP1k8mBc6kVk8q2eX06JVy1oqjj8YH2sQ==
X-Received: by 2002:a05:6512:10d6:b0:568:993c:f047 with SMTP id 2adb3069b0e04-568993cfb7bmr498526e87.42.1757409285803;
        Tue, 09 Sep 2025 02:14:45 -0700 (PDT)
Received: from pc636 (host-95-203-28-174.mobileonline.telia.com. [95.203.28.174])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56817f72e64sm384445e87.104.2025.09.09.02.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 9 Sep 2025 11:14:43 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>,
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
Message-ID: <aL_wAxNv5ifF2IRD@pc636>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
 <aL7FFpIMmXtzzSL1@pc638.lan>
 <6f8274da-a010-4bb3-b3d6-690481b5ace0@suse.cz>
 <aL_uhPtztx7Ef0T2@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL_uhPtztx7Ef0T2@pc636>
X-Rspamd-Queue-Id: 0E09010000A
X-Stat-Signature: ryn8jihqb9qqs9r5hxes5q7kqi5trhfj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757409287-50108
X-HE-Meta: U2FsdGVkX1/O1phJoAut6ybacZ2GR/6NtrgSguBgdRlTTl3t1Gmj+vVuiaYDsOL81Kk606KHuFCp+we2zBEYtaZTXmwxdREQhXPfwW8zU2YKTa/mIqzxsTw+iTYwTBUxU5uV+fmx5Q7lsk2YLYXKFdDtLNAg3VaULp8KzklYH9wngxXElSFrUf5nDxIiV20XWc/GEQMCjb5CDwk3Hxq6/gfcfgmAkW52IGALIuYXC2AJPe6O2bag0DE/Eh2vSdYXGC0TCdk0MQrdWmVECs8sSjyF/BrVYb6XrdchLYkllzE64iVxjsHD/sQayVTer2Jph9FEDlRVPWgHYqlZr/Y1bN1zRr/897Hg/zWAumgrs8XRO3SxIPOuG1SCmlAEGTkhGZ8u6F+YApA9eGHYe7PjjhA0qg0DdRK3oKpSLzzQQQlr1XamS6Rl8eecAebzeVehGSyyIhNvXMSBQev2Ncof+WPFUfnWOARlmdTLyqd/rVBw5b58QpWIy2WiPiw8Djgo7vVIfLN9dAed2VId/DRxgTjN8Dux1EBLteeUrILNsfkufuT5R7AXd6sOTCKZTUoshFrBHoUPu4nv7z5GxElWxhYbfxzfgSodwGRLULGjWruR0XmINneReUvxxmUovMXQxEe4Uy/mQGZZFk53olnMcsiegkga8z9KPle6kenk5iqmirYjla9nPuMD/1hCzbHbHo3E1CAOcLEmEtozBN1QL/Q+fjyMfC5YTOl08PtgXtozLXHCudUqCUYXw+rPqIMRrdNCXrJDlxIPFjVjNPkV2p72CwqLVGON7+gSNDK12MBYss46PneXXFhOFieSrn5EIx+6y2VbAO8mPD78IIDAO6WCs0RTC9IRVBa/gbgm87lALL5VQ+kIZPUMDamMRzxFYJrDaK3vOKmnjjY0Bhgsk/9LeFZsmYnevBewlxnpB7yhbpMVwF3UlvAillLq14BpMqw9JzQuY1b0DozhEcv
 aSyGShnJ
 Da6HlV5X9P44AGqBNQE5dm6uKmNIYDREOt+agm6Tkt9eQIN9zo9g+0hxr1D+CIscrSN97iw41XfgFnl1o4n9gUyVPFltNGD7YxbN6J6FyQaoOfgTUi0EUxjBL9OQZavkBx0EapLfeOFUM8WB0jIXWL+n9FvgkUE/xMN8/CFvX9im1PRHeUrC/G5DHuvTKgMzF00LnkYPzXplxzj+Wo+LdX15Wb5r/d6G2i3uKBXVIm95rCxpWgyLC0iqPJJwN4UZuMELrVOTHsHddkvjbbTMqLfuiAaC4XGRwg8x9fgd7cTIme9BiLahT111r7QMHnB/RFYwzT60C9qiT1dwKNPE5sTulxovy3jv7WJPrv1ZGZQX9hRtAvpr0ydgWnsPUuObu56rt6Us94matRdk6HLji+1Rf8dK/l00m9bUnb7QjKmjGH3gHrwm2XDOxW+cml1A38iDLD7/Hr45/6GntCOd37TlSqWB9HX4mFVmcwdAJ/68j6Xc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:08:20AM +0200, Uladzislau Rezki wrote:
> On Mon, Sep 08, 2025 at 02:45:11PM +0200, Vlastimil Babka wrote:
> > On 9/8/25 13:59, Uladzislau Rezki wrote:
> > > On Wed, Sep 03, 2025 at 02:59:46PM +0200, Vlastimil Babka wrote:
> > >> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> > >> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> > >> addition to main and spare sheaves.
> > >> 
> > >> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> > >> the sheaf is detached and submitted to call_rcu() with a handler that
> > >> will try to put it in the barn, or flush to slab pages using bulk free,
> > >> when the barn is full. Then a new empty sheaf must be obtained to put
> > >> more objects there.
> > >> 
> > >> It's possible that no free sheaves are available to use for a new
> > >> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> > >> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> > >> kfree_rcu() implementation.
> > >> 
> > >> Expected advantages:
> > >> - batching the kfree_rcu() operations, that could eventually replace the
> > >>   existing batching
> > >> - sheaves can be reused for allocations via barn instead of being
> > >>   flushed to slabs, which is more efficient
> > >>   - this includes cases where only some cpus are allowed to process rcu
> > >>     callbacks (Android)
> > >> 
> > >> Possible disadvantage:
> > >> - objects might be waiting for more than their grace period (it is
> > >>   determined by the last object freed into the sheaf), increasing memory
> > >>   usage - but the existing batching does that too.
> > >> 
> > >> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> > >> implementation favors smaller memory footprint over performance.
> > >> 
> > >> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> > >> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> > >> many had to fall back to the existing implementation.
> > >> 
> > >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > >> ---
> > >>  mm/slab.h        |   2 +
> > >>  mm/slab_common.c |  24 +++++++
> > >>  mm/slub.c        | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > >>  3 files changed, 216 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/mm/slab.h b/mm/slab.h
> > >> index 206987ce44a4d053ebe3b5e50784d2dd23822cd1..f1866f2d9b211bb0d7f24644b80ef4b50a7c3d24 100644
> > >> --- a/mm/slab.h
> > >> +++ b/mm/slab.h
> > >> @@ -435,6 +435,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
> > >>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
> > >>  }
> > >>  
> > >> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> > >> +
> > >>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
> > >>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
> > >>  			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
> > >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> > >> index e2b197e47866c30acdbd1fee4159f262a751c5a7..2d806e02568532a1000fd3912db6978e945dcfa8 100644
> > >> --- a/mm/slab_common.c
> > >> +++ b/mm/slab_common.c
> > >> @@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
> > >>  		kvfree_rcu_list(head);
> > >>  }
> > >>  
> > >> +static bool kfree_rcu_sheaf(void *obj)
> > >> +{
> > >> +	struct kmem_cache *s;
> > >> +	struct folio *folio;
> > >> +	struct slab *slab;
> > >> +
> > >> +	if (is_vmalloc_addr(obj))
> > >> +		return false;
> > >> +
> > >> +	folio = virt_to_folio(obj);
> > >> +	if (unlikely(!folio_test_slab(folio)))
> > >> +		return false;
> > >> +
> > >> +	slab = folio_slab(folio);
> > >> +	s = slab->slab_cache;
> > >> +	if (s->cpu_sheaves)
> > >> +		return __kfree_rcu_sheaf(s, obj);
> > >> +
> > >> +	return false;
> > >> +}
> > >> +
> > >>  static bool
> > >>  need_offload_krc(struct kfree_rcu_cpu *krcp)
> > >>  {
> > >> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
> > >>  	if (!head)
> > >>  		might_sleep();
> > >>  
> > >> +	if (kfree_rcu_sheaf(ptr))
> > >> +		return;
> > >> +
> > > Uh.. I have some concerns about this.
> > > 
> > > This patch introduces a new path which is a collision to the
> > > existing kvfree_rcu() logic. It implements some batching which
> > > we already have.
> > 
> > Yes but for caches with sheaves it's better to recycle the whole sheaf (as
> > described), which is so different from the existing batching scheme that I'm
> > not sure if there's a sensible way to combine them.
> > 
> > > - kvfree_rcu_barrier() does not know about "sheaf" path. Am i missing
> > >   something? How do you guarantee that kvfree_rcu_barrier() flushes
> > >   sheafs? If it is part of kvfree_rcu() it has to care about this.
> > 
> > Hm good point, thanks. I've taken care of handling flushing related to
> > kfree_rcu() sheaves in kmem_cache_destroy(), but forgot that
> > kvfree_rcu_barrier() can be also used outside of that - we have one user in
> > codetag_unload_module() currently.
> > 
> > > - we do not allocate in kvfree_rcu() path because of PREEMMPT_RT, i.e.
> > >   kvfree_rcu() is supposed it can be called from the non-sleeping contexts.
> > 
> > Hm I could not find where that distinction is in the code, can you give a
> > hint please. In __kfree_rcu_sheaf() I do only have a GFP_NOWAIT attempt.
> > 
> For PREEMPT_RT a regular spin-lock is an rt-mutex which can sleep. We
> made kvfree_rcu() to make it possible to invoke it from non-sleep contexts:
> 
> CONFIG_PREEMPT_RT
> 
> preempt_disable() or something similar;
>  kvfree_rcu();
>   GFP_NOWAIT - lock rt-mutex
> 
> If GFP_NOWAIT semantic does not access any spin-locks then we are safe
> or if it uses raw_spin_locks.
> 
And this is valid only for double argument, single argument you can
invoke from sleeping context only, then you can allocate.

--
Uladzislau Rezki

