Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCDBC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142526B0095; Wed, 16 Sep 2026 09:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11AA36B0096; Wed, 16 Sep 2026 09:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030066B0098; Wed, 16 Sep 2026 09:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1C756B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:50:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DAC9A5D01
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:50:11 +0000 (UTC)
X-FDA: 85219759422.17.864F933
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B408A100005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:50:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TENOv2mY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789566609;
	b=W1YSUvqwS38yO07O/kVj4wsBe12ZHF8eQEvTux7JTAoGSZfjVXkuT9Tu9wOHrbil1UccnT
	/OROaVbxCsyA9u+/2Qal8RdUnwmVM21kkA8Pn0INB4MbUb3busKV8xqBn9pffW6kUi3ch+
	srIPyOfbUtNNEUeNS9YvPks7DFRXSQw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TENOv2mY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789566609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ea/X1PEXIoAtZRJsb0QUC6x0uLicSdZWT8UrCNjTPg=;
	b=LPsu5GSVobohh0sdAX1xZfh/gMTnvseaqmWdc3B97eB4fTcUMOAdSTE6X7Acj+PKfK7hvR
	fGJAEfIHHaeNLuVZFDw4lSwQtMSe5fx+7nOy+OKaZWt6PoEX3O7mmwhqeDS6nAKbXcJzHU
	/pcL0Y7gZkDMnl7nrybNXnohQ8tBbzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E71CA43452;
	Wed, 16 Sep 2026 13:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB71F00893;
	Wed, 16 Sep 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789566608;
	bh=6Ea/X1PEXIoAtZRJsb0QUC6x0uLicSdZWT8UrCNjTPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TENOv2mY9VBUtbYx7ionqGDUTCHXNRIV1+nZOfSYNkPCt/UfoSwfgrIgU2Irz1qnY
	 XpgtpJo3mUxvE7s6Gad1bChoM/PcakcXt0SApuXi5wtSfJhLzCVbhbfSY5hgiWJoDg
	 TljTmiSGVZw2x3xLMitYaOhnrbeG4e4dAqQGJaK88xup/LrA0ddxI0WVWgW3foSBIf
	 t/uh9DialPGj3G3t4jF+k+x7XkoqJCKNkqVEYrYEpgP059RL+2nbsptj2BNRLxWqGN
	 DiLhjZpvjeUyjRW5jS8T77rP/tbRKo6F2Nh1+jZ9o6qU1fW4ySEbd1ugGaursheMD+
	 LHjqWXLi7RTSw==
Date: Wed, 16 Sep 2026 14:50:06 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Message-ID: <aqqMIBejvh60JyMO@thinkstation>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
 <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
 <aqPlMzUIw-4g2iOX@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPlMzUIw-4g2iOX@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B408A100005
X-Stat-Signature: 5dz7i8hs9gyf7qtm11omgz7rjbojqpih
X-HE-Tag: 1789566609-952129
X-HE-Meta: U2FsdGVkX19hjV/gv8bl9+OFJ+HMiPB/yuR3RVL1PO8+pcHMS8Jr9bEBkezZtqCcb/b+19AhLx3PVLakk/jHrYE6FLeDFkS0AFvcizisBKPkwtwr27jpEbVJqxoRPd51QCWEpHu/lcCMeUKkNlA4ZH3UHMSjq3PH4F+hlcAHto7CDN9YFut4MB4qHM1gukpotvWpofAwkNlh77Nm71HC4GEUyuqh/HykEAhtPkEoaBuT1toabR6x8tbCAgacA0t+4b7LID1e/GLQkbkpPCLJrQ3eK943BGRa+ylZcpAGqH7cmRwMnKZiL9SMnIqmGzygSE1XoG5Rk/2RAVribJHkN4diMOmsZ/CIxvI2WewhyjLu5olX+Hx/lBNlF/tq8JBNW1+56SwPOBILyXbgkEUfuXQerrMH9pPgShWDYZCcIQmfGvX6ZWaEUrfJ1252i/lsE/5KgiQ3OBzw47V+bA85GUVi8Y+VYlp578LAdXnnp31YWKahnIXuzZAK6yRWy3jmob5zE7dS3FbTimeIfbSJpOOaBXMDz9H4WYC7PkiRsSYBrfpn49QS7qnNZAEhuXr/VrEfw9QcpyOLQg0eBxxjPMuX+EYzqSlfFbJ8GB7kgKrtRyft/BxlXlS/J9VPbko2IlR6kIYOE1DPPEmT11a6DuKa92/juiDOy0rg+/Gnm2BsWfCHwYm9D53tcE8pQ2hmBa6uwJHA3jiakA6hMsMrPY8HL8/APOJt+uxBkfKxUqEnVwtT4YJmLFfJZk3yRImtDZGMzA8UZi8o/PbvUjZKTyLzrZLYxWUweroH/0yEoGwFpG/o5F9nwf4K5QtaIypvT1F0XwC909hgyUW2VFJUDYbl/57QGLN4Yo59t+x3LTY/ZvI+Zu9Sos6jfgojhPhy4VlJsiABmc1FKK3IgeCkUyTawFIPcxUr7dLSZBl5PCLRV5clgm4m5puBxcKYTCgAaS0lwnm6RPQc0kZbOYI
 bh2ICSrJ
 8eRESv/x85X0cCEK3pD73MlH+OwcSFUJVwa6akVj4BG3TkrApgTeTJl89MMfhJUWuFWQWMlG9jiKRwIVZ62GqxdA6gqkir1JhPvOKoTRs7H6q5PeWg6Aoz1dE0lRtZuV8vtsN9TaDbVe+PLBPPpnt4HhjlopY/ZpNczbsIe5Xk2c4zZusDqzhth/sgwmAYSVW6mzX9U3NtX/RthLmwlrHz3qqKrdFOiBFNnFEKxcCPu/irZ4gDd5vmgtZL/pH78g4LtUjLxpsVJd4o+R7lqVK/Q9VoeeciVEa9CWe4e6fvfvmIQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for chiming in late, trying to catch up...

On Fri, Sep 11, 2026 at 09:06:25PM +0800, Hao Li wrote:
> On Mon, Sep 07, 2026 at 03:38:22PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 8/24/26 14:25, Hao Li wrote:
> Thanks for pointing this out. I looked into this bursty alloc-and-free behavior
> a bit deeper and ran some further experiments.
> 
> The core question we want to answer is: why does such a massive volume of
> object allocations and frees fall straight through to the node partial list
> layer, rather than being caught and handled at the barn/sheaf layer? In SLUB's
> current design, the per-CPU main/spare sheaves act as the L1 cache, the barn as
> L2, and the node partial list as L3. For the mmap1 benchmark (which heavily
> stresses the maple tree), the allocation path uses kmem_cache_prefill_sheaf()
> rather than the generic allocation APIs, and the frees go through kfree_rcu().
> 
> Then, here is what happens during allocation: kmem_cache_prefill_sheaf()
> normally borrows the spare sheaf directly. If the sheaf holds fewer objects
> than requested, it refills it to capacity from the node partial list layer and
> this completely bypasses the barn layer.

Nice observation, Hao!

> Once the maple tree finishes
> allocating a batch of objects, it returns the sheaf back to pcs->spare via
> kmem_cache_return_sheaf(). So in essence, this prefill path is just funneling
> objects directly from the node partial list into the maple tree through the
> spare sheaf. It skips the barn layer.

Nice observation.

> Then on the free side: these objects are freed via kfree_rcu, and then
> rcu_free_sheaf() checks if there is still room on the barn's full list. But
> since the allocation path never actually pulled from the barn, the full list
> stays permanently saturated. As a result, rcu_free_sheaf() always falls back to
> sheaf_flush_unused(), flushing objects straight into the node partial list
> layer. It skips the barn layer too.

Nice observation.

> So looking at this behavior, the benchmark does seem to reveal a gap in this
> allocation path, where a huge amount of traffic ends up bypassing the barn
> layer entirely.

Indeed.

So, either refilling or flushing partial sheaves bypasses the barn layer.
This is particularly a problem for prefilled sheaf users because they
perform refills and flushes more frequently.

Partial sheaves serve alloc and free for ordinary users, but often times
that's not the case for prefilled sheaf users.

> To see if we can address this, I draft an experimental patch. It introduces a
> new field, barn->sheaf_partial, which is a single sheaf rather than a list.
> 
> [The patch code is included at the end of this email.]
> 
> Whenever kmem_cache_prefill_sheaf() runs, it detaches pcs->spare and checks
> whether it holds enough objects for the request.
> 
> If so, it returns it right away as in the original code.
> 
> If not, call __prefill_sheaf_pfmemalloc() and then go into
> barn_replace_partial_sheaf() to swap the non-full spare sheaf with a full sheaf
> from the barn. The full sheaf is handed to the caller, while the non-full sheaf
> is temporarily stashed into barn->sheaf_partial. This largely avoids falling
> back to the node partial list. If barn->sheaf_partial already has a sheaf, we
> merge them together, and any resulting full or empty sheaves are placed back
> into the barn accordingly.
> 
> The key idea here is simply to let __prefill_sheaf_pfmemalloc() pull a sheaf
> from the barn's full list, which makes room on the list for future
> rcu_free_sheaf() calls.

And the idea is to provide a place for a partial sheaf to say to avoid
flushing and refilling it, and which helps avoiding bypassing the barn
layer.

The reason why we don't need a list of partial sheaves because we want
to merge them and move the partial sheaf to full or empty list.

Makes sense to me :-)

> Here are the numbers with just this experimental patch applied (without the
> parking patch):
> 
> baseline: 28779879
> after experimental patch: 35550211 (+23.5%)
> 
> metric                              before             after             delta      change
> =============================================================================================
> aliases                                  0                 0                 0      +0.00%
> align                                  256               256                 0      +0.00%
> alloc_fastpath                      23,259            59,287            36,028    +154.90%
> alloc_node_mismatch                      0                 0                 0      +0.00%
> alloc_slab                      10,171,378         4,796,346        -5,375,032     -52.84%
> alloc_slowpath                           0                 0                 0      +0.00%
> barn_get                               441       193,807,528       193,807,087  +43947185.26%
> barn_get_fail                            0               377               377         new
> barn_put                               441       181,694,607       181,694,166  +41200491.16%
> barn_put_fail                  272,868,220       156,335,632      -116,532,588     -42.71%
> cache_dma                                0                 0                 0      +0.00%
> cmpxchg_double_fail                744,975           357,255          -387,720     -52.04%
> cpu_partial                              0                 0                 0      +0.00%
> cpu_slabs                                0                 0                 0      +0.00%
> destroy_by_rcu                           0                 0                 0      +0.00%
> free_add_partial               337,390,126       162,178,648      -175,211,478     -51.93%
> free_fastpath                        5,204            14,081             8,877    +170.58%
> free_rcu_sheaf               8,731,794,372    10,816,953,777     2,085,159,405     +23.88%
> free_rcu_sheaf_fail                      0                 0                 0      +0.00%
> free_remove_partial             10,170,229         4,794,785        -5,375,444     -52.85%
> free_slab                       10,170,229         4,794,785        -5,375,444     -52.85%
> free_slowpath                   18,697,056        11,563,127        -7,133,929     -38.16%
> hwcache_align                            0                 0                 0      +0.00%
> min_partial                              5                 5                 0      +0.00%
> object_size                            256               256                 0      +0.00%
> objects                             14,774            14,596              -178      -1.20%
> objects_partial                     14,774            14,596              -178      -1.20%
> objs_per_slab                           64                64                 0      +0.00%
> order                                    2                 2                 0      +0.00%
> order_fallback                           0                 0                 0      +0.00%
> partial                              1,913             2,544               631     +32.98%
> poison                                   0                 0                 0      +0.00%
> reclaim_account                          0                 0                 0      +0.00%
> red_zone                                 0                 0                 0      +0.00%
> remote_node_defrag_ratio               100               100                 0      +0.00%
> sanity_checks                            0                 0                 0      +0.00%
> sheaf_alloc                    145,870,437       151,536,660         5,666,223      +3.88%
> sheaf_capacity                          32                32                 0      +0.00%
> sheaf_flush                  8,731,787,311     5,002,740,743    -3,729,046,568     -42.71%
> sheaf_free                     145,870,431       151,536,655         5,666,224      +3.88%
> sheaf_prefill_fast           3,500,187,266     4,331,383,393       831,196,127     +23.75%
> sheaf_prefill_oversize                   0                 0                 0      +0.00%
> sheaf_prefill_slow                     322               646               324    +100.62%
> sheaf_refill                 8,750,484,664     5,014,304,944    -3,736,179,720     -42.70%
> sheaf_return_fast            3,500,187,348     4,331,383,596       831,196,248     +23.75%
> sheaf_return_slow                      240               443               203     +84.58%
> slab_size                              256               256                 0      +0.00%
> slabs                                1,913             2,544               631     +32.98%
> slabs_cpu_partial                        0                 0                 0      +0.00%
> store_user                               0                 0                 0      +0.00%
> total_objects                      122,432           162,816            40,384     +32.98%
> trace                                    0                 0                 0      +0.00%
> usersize                                 0                 0                 0      +0.00%
> 
> derived                                                  before             after      change
> =============================================================================================
> page allocator churn (alloc_slab + free_slab)        20,341,607         9,591,131     -52.85%
> 
> As we can see from the data, barn_get and barn_put spike significantly, which
> shows a large part of the traffic is redirected into the barn. This eases slab
> alloc/free churn and cuts page allocator allocations/frees by 52.85%.

Cool!

> All in all, I feel we could probably focus on evaluating and pursuing this
> experimental patch first. For maple tree performance specifically, it seems
> like it might be the better fit compared to the parking mechanism (which is
> probably better suited for generic allocation pressure outside of maple tree).

Sounds good.

Keeping eyes on seeing if we do (or don't) need the parking idea after
this.

[ now moving on to the actual code... ]

-- 
Cheers,
Harry / Hyeonggon

