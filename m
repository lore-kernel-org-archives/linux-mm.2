Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB4FC88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75E56B008C; Tue, 15 Sep 2026 23:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28F96B0092; Tue, 15 Sep 2026 23:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64DB6B0093; Tue, 15 Sep 2026 23:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3BEC6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:05:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D20C1A04CB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:05:25 +0000 (UTC)
X-FDA: 85218134610.15.9BEBA8F
Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2FDD0140003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:05:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsTxT0MK;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789527923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoJdHtWD8u2OpWB5LgfZc9nKRHqZctBi023N7rIRV58=;
	b=I71Zrt55VvFyNu8+9sRjldyNZO/jLPNIzJPIZGHnfeVU1xGoHM9P6VesIBWIX9qRdJ525U
	BrPrCfeGBmvtOXtO/IbBAarkv6xSyHHqK9RMaEr1TTLXzODoQElP5upJpvyUZtKOGkkTFw
	WLAWZRcJsco+m+V9S0BG7xFoPD3BZbs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsTxT0MK;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789527923;
	b=KaWP75O6hd+0943oGJw5U7iEgKM9Nk7reyySETPCfKsiLMyFsy9CBsncr+RQOTWqen0s4t
	ZgpyNUR5rVD9aO07jGNTyQc9QR+2xoeHcKCWZvx23XSmrgHwngMOkdgvQ4ppTLZfqKWp5C
	I8zTBA63lnVCWU6QTWnq+sgp7jTeQ70=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WLf1stpeXJJXUPVOOAEMB3BX3rGdPNogSeeY2FwLjKw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789527921; v=1; x=1790132721;
 b=fsTxT0MKaI5mBWYC96jjQqL6OEeZsWxV3uokFm5+tPCN0GWje3D32kIKl64vvs9ZDGnD8Wmc
 tNCvZfOY8deGBNGwaMrjq9uI5y4lKAXVgwf9tI+RBHEMLqnnLA7BaBcAEnUkcebGjAqKlkcIcZu
 UjyKlr+pRurY1RijVyxuIc/A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 94ae2165ced7c340;
	Wed, 16 Sep 2026 03:05:21 +0000
X-Mizu-Trace-ID: 94ae2165ced7c340
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 11:05:12 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, harry@kernel.org, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Message-ID: <aqoCdn2OkTWcDwF1@fedora>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
 <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
 <aqPlMzUIw-4g2iOX@fedora>
 <819fbc70-4c6b-4202-ada0-c3ef8ace1408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <819fbc70-4c6b-4202-ada0-c3ef8ace1408@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FDD0140003
X-Stat-Signature: 5noexgqc8nq5ggii3mjq4d1nyy4wnax7
X-Rspam-User: 
X-HE-Tag: 1789527922-170526
X-HE-Meta: U2FsdGVkX1+GgWx6M9uytx+9LyETvmLwcmQF67FZw+JWRmmtT7KAUc8SDwEF5Xm6zhu/vlUtqSOEyc5iMEhtyAqzarDourcwI4UCHIAsVNCRxWO8MvDF+y7hIVuUwlP5M0Y4fAxLvwj8NpuHg6t4CfZ+mpUkgIq4IsP4pTpdwy7tEI6oV8GrRyBNApV4FLvDMg/c3EcEMOXXdougj+zyo+5jLzyVbIXqvPbQUDeVsQ4fc6j7HQionVkUPPtyQWkuM8SsYhwUCWMDhNGsgSE6n6CsTEPD7mW1ZYtdqXQVBdEoGzL/xZRnqS08MrC1bkh9k4IA0O0B3xG1lAD/VNODwfsw6I3Pc123HtXY0yjSGdproKX3wcP+zYCxQr8THFMPspdaSkVYv8YIjF0u75GlYU+neqeb8K1cL/k3pfYWEWiRCiatP1eEjFh5OUgtGk4f3q9JoTx1CJRO5NzmTs2ksDqDZuG8NPOsRMYjGXaDxjjEPSPjPBENcWLiZv9lEn3Dy4o6P/JVpek7PEd5IH65VMjg7MxnPVYbeJj50jiRxAc5/4W8bWFJ8zMMdXDSe4KAub+Skke7Qw5YqWzMImqcdlfGaywoTY80CdagwcypQ7twLgcI83IcSBCphgH0P3GjgfxxXsMvKt9rAXMDhap2N72A+sJOvipp3oicPtt1IFwi/l7dfUw2JoG1rkeZTTlRmtUIqiFBG/zETJxMYLqOdKd69TUaxfoDndGpgZIcHoDCgExQt7Kr4wakeWz+2Q549aaXr2U6FrQSmarKstM+VlWq66st1hQsaqPnCMhSSp6/C1U4hCIzLnWNWFt5RBveIeQT8Gwp6qT+V9AMRC0asb/IckNWn0RFeTrGGSCLZaFWA/Pu7J5fHGwdIbbkIptUg7v/n5KFAAl6Q9q/Li0ZI9MxXNRCFAtbiKLkq446W6OEhsn6+3QUqEOjmjFXTOoFdxfAX2Ch5VyDxHoPeGM
 ayoiZcTR
 zLC2Yt4PlNkQ9L1T5UFRP1kAe6AL4WD0ipjaQbns205hfvCAhGUFV3N1jhu/D/hqZ6aiH+GkDM/QnnknMfQRUN7NIm5W2c/DF8Dd1NmIk2C2IrdQecWWNHZTj2qqmsiKjE30QE34+xaGoLRw8o64YtsPObp+6IT3Sgs72pE6Z4DYkMBcs1rZkIPlSxfikL5g0hWiNwMkaCSSgdxs5k7W20jlmwiHAAhfb0hg1XxUpfL0FoysTLMEkrrJOxvQASw1gmuvgBrzE4xGEi+6Q2gTet/ki+UPY/9FrJpPrBiAdvS613VAWM+Umj8JBuz6fR2IvI8+uaHf22sPNDbQLtAxsrjU/Bf3UgQJyVkOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:43:58AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/11/26 15:06, Hao Li wrote:
> > On Mon, Sep 07, 2026 at 03:38:22PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 8/24/26 14:25, Hao Li wrote:
> >> > Introduce a mechanism called parking to mitigate lock contention in the
> >> > free slowpath.
> >> 
> >> Interesting!
> > 
> > Thanks!
> > 
> >> 
> >> > In the free slowpath, when __slab_free() transitions a full slab into a
> >> > partial/empty slab through a free operation, it must acquire the list
> >> > lock to add these newly freed partial/empty slabs to the partial list.
> >> > 
> >> > Why must partial and empty slabs converted from full slabs be added to
> >> > the partial list? Because only by doing so can the sheaf refill or alloc
> >> > slowpath see these partial slabs and allocate from them. Therefore, the
> >> > list insertion must be performed, which requires acquiring the lock and
> >> > leads to heavy lock contention under high concurrency.
> >> > 
> >> > Analysis of profiling data from the will-it-scale mmap1 benchmark shows
> >> > that full -> partial transitions account for a large proportion, second
> >> > only to partial -> partial.
> >> > 
> >> > With extra instrumentation added to __slab_free(), the following data
> >> > was collected for the maple_node cache (in counts):
> >> > 
> >> >   partial->partial    843017414
> >> >   full->partial       550719384
> >> >   partial->empty      17459564
> >> >   full->empty         2
> >> 
> >> That's a lot inded. I'd be careful if it's some specific aspect of the test,
> >> i.e. lots of parallel allocations followed by lots of frees, that wouldn't
> >> be that common in realistic workloads. But worth looking into at least.
> >> If it's this kind of pathologic behavior, then I expect changing sheaf size
> >> as suggested by Pedro wouldn't help much.
> > 
> > Thanks for pointing this out. I looked into this bursty alloc-and-free behavior
> > a bit deeper and ran some further experiments.
> > 
> > The core question we want to answer is: why does such a massive volume of
> > object allocations and frees fall straight through to the node partial list
> > layer, rather than being caught and handled at the barn/sheaf layer? In SLUB's
> > current design, the per-CPU main/spare sheaves act as the L1 cache, the barn as
> > L2, and the node partial list as L3. For the mmap1 benchmark (which heavily
> > stresses the maple tree), the allocation path uses kmem_cache_prefill_sheaf()
> > rather than the generic allocation APIs, and the frees go through kfree_rcu().
> > 
> > Then, here is what happens during allocation: kmem_cache_prefill_sheaf()
> > normally borrows the spare sheaf directly. If the sheaf holds fewer objects
> > than requested, it refills it to capacity from the node partial list layer and
> > this completely bypasses the barn layer. Once the maple tree finishes
> > allocating a batch of objects, it returns the sheaf back to pcs->spare via
> > kmem_cache_return_sheaf(). So in essence, this prefill path is just funneling
> > objects directly from the node partial list into the maple tree through the
> > spare sheaf. It skips the barn layer.
> > 
> > Then on the free side: these objects are freed via kfree_rcu, and then
> > rcu_free_sheaf() checks if there is still room on the barn's full list. But
> > since the allocation path never actually pulled from the barn, the full list
> > stays permanently saturated. As a result, rcu_free_sheaf() always falls back to
> > sheaf_flush_unused(), flushing objects straight into the node partial list
> > layer. It skips the barn layer too.
> > 
> > So looking at this behavior, the benchmark does seem to reveal a gap in this
> > allocation path, where a huge amount of traffic ends up bypassing the barn
> > layer entirely.
> 
> Great find! Indeed that's a big gap for prefilled sheaf users, doh.

Thanks for confirming! :)

> 
> > To see if we can address this, I draft an experimental patch. It introduces a
> > new field, barn->sheaf_partial, which is a single sheaf rather than a list.
> > 
> > [The patch code is included at the end of this email.]
> > 
> > Whenever kmem_cache_prefill_sheaf() runs, it detaches pcs->spare and checks
> > whether it holds enough objects for the request.
> > 
> > If so, it returns it right away as in the original code.
> > 
> > If not, call __prefill_sheaf_pfmemalloc() and then go into
> > barn_replace_partial_sheaf() to swap the non-full spare sheaf with a full sheaf
> > from the barn. The full sheaf is handed to the caller, while the non-full sheaf
> > is temporarily stashed into barn->sheaf_partial. This largely avoids falling
> > back to the node partial list. If barn->sheaf_partial already has a sheaf, we
> > merge them together, and any resulting full or empty sheaves are placed back
> > into the barn accordingly.
> 
> Makes sense to me!
> 
> > The key idea here is simply to let __prefill_sheaf_pfmemalloc() pull a sheaf
> > from the barn's full list, which makes room on the list for future
> > rcu_free_sheaf() calls.
> > 
> > Here are the numbers with just this experimental patch applied (without the
> > parking patch):
> > 
> > baseline: 28779879
> > after experimental patch: 35550211 (+23.5%)
> > 
> > metric                              before             after             delta      change
> > =============================================================================================
> > aliases                                  0                 0                 0      +0.00%
> > align                                  256               256                 0      +0.00%
> > alloc_fastpath                      23,259            59,287            36,028    +154.90%
> > alloc_node_mismatch                      0                 0                 0      +0.00%
> > alloc_slab                      10,171,378         4,796,346        -5,375,032     -52.84%
> > alloc_slowpath                           0                 0                 0      +0.00%
> > barn_get                               441       193,807,528       193,807,087  +43947185.26%
> > barn_get_fail                            0               377               377         new
> > barn_put                               441       181,694,607       181,694,166  +41200491.16%
> > barn_put_fail                  272,868,220       156,335,632      -116,532,588     -42.71%
> > cache_dma                                0                 0                 0      +0.00%
> > cmpxchg_double_fail                744,975           357,255          -387,720     -52.04%
> > cpu_partial                              0                 0                 0      +0.00%
> > cpu_slabs                                0                 0                 0      +0.00%
> > destroy_by_rcu                           0                 0                 0      +0.00%
> > free_add_partial               337,390,126       162,178,648      -175,211,478     -51.93%
> > free_fastpath                        5,204            14,081             8,877    +170.58%
> > free_rcu_sheaf               8,731,794,372    10,816,953,777     2,085,159,405     +23.88%
> > free_rcu_sheaf_fail                      0                 0                 0      +0.00%
> > free_remove_partial             10,170,229         4,794,785        -5,375,444     -52.85%
> > free_slab                       10,170,229         4,794,785        -5,375,444     -52.85%
> > free_slowpath                   18,697,056        11,563,127        -7,133,929     -38.16%
> > hwcache_align                            0                 0                 0      +0.00%
> > min_partial                              5                 5                 0      +0.00%
> > object_size                            256               256                 0      +0.00%
> > objects                             14,774            14,596              -178      -1.20%
> > objects_partial                     14,774            14,596              -178      -1.20%
> > objs_per_slab                           64                64                 0      +0.00%
> > order                                    2                 2                 0      +0.00%
> > order_fallback                           0                 0                 0      +0.00%
> > partial                              1,913             2,544               631     +32.98%
> > poison                                   0                 0                 0      +0.00%
> > reclaim_account                          0                 0                 0      +0.00%
> > red_zone                                 0                 0                 0      +0.00%
> > remote_node_defrag_ratio               100               100                 0      +0.00%
> > sanity_checks                            0                 0                 0      +0.00%
> > sheaf_alloc                    145,870,437       151,536,660         5,666,223      +3.88%
> > sheaf_capacity                          32                32                 0      +0.00%
> > sheaf_flush                  8,731,787,311     5,002,740,743    -3,729,046,568     -42.71%
> > sheaf_free                     145,870,431       151,536,655         5,666,224      +3.88%
> > sheaf_prefill_fast           3,500,187,266     4,331,383,393       831,196,127     +23.75%
> > sheaf_prefill_oversize                   0                 0                 0      +0.00%
> > sheaf_prefill_slow                     322               646               324    +100.62%
> > sheaf_refill                 8,750,484,664     5,014,304,944    -3,736,179,720     -42.70%
> > sheaf_return_fast            3,500,187,348     4,331,383,596       831,196,248     +23.75%
> > sheaf_return_slow                      240               443               203     +84.58%
> > slab_size                              256               256                 0      +0.00%
> > slabs                                1,913             2,544               631     +32.98%
> > slabs_cpu_partial                        0                 0                 0      +0.00%
> > store_user                               0                 0                 0      +0.00%
> > total_objects                      122,432           162,816            40,384     +32.98%
> > trace                                    0                 0                 0      +0.00%
> > usersize                                 0                 0                 0      +0.00%
> > 
> > derived                                                  before             after      change
> > =============================================================================================
> > page allocator churn (alloc_slab + free_slab)        20,341,607         9,591,131     -52.85%
> 
> Very nice!
> 
> > 
> > As we can see from the data, barn_get and barn_put spike significantly, which
> > shows a large part of the traffic is redirected into the barn. This eases slab
> > alloc/free churn and cuts page allocator allocations/frees by 52.85%.
> > 
> > Additionally, NUMA performance also seems to see some improvement. Under the
> > maple tree benchmark, the free_slowpath metric likely reflects objects that
> > enter add_ptr_to_bulk_krc_lock() due to nid mismatches and are eventually freed
> > via kfree_bulk(). This metric also shows a noticeable drop.
> > 
> > Metrics like alloc_fastpath did improve, but their absolute numbers are small
> > and likely unrelated to the maple tree test.
> > 
> > The tradeoff is a increase in slab fragmentation, with total_objects and slabs
> > growing by 32.98%. I suspect this happens because as more traffic gets routed
> > to the barn layer, objects end up being more scattered, which ends up pinning
> > more slabs.
> 
> Maybe it's partially also due to the fact that the test can run faster (as
> we discussed earlier), thus have e.g. more kfree_rcu() objects in flight
> (free_rcu_sheaf above increased a lot), etc. So I wouldn't worry too much.

Yeah, make sense, and I tested it multiple times, this impact is bounded.

> 
> > For comparison: the parking mechanism reduces lock contention at the node
> > partial list layer, while this experimental patch absorb the traffic earlier at
> > the barn layer. They are independent in mechanism. Interestingly, both
> > approaches deliver very comparable performance improvements. A bit
> 
> Great.
> 
> > frustratingly, combining the two only squeezes out an extra ~1% gain, I'm still
> > investigating why that is.
> 
> I don't think it would be bad if this change rendered the parking approach
> unnecessary. I suspect Pedro would be very happy :)

Exactly. The parking approach is a bit invasive, while partial sheaves feel
much cleaner.

> 
> > Phew, that turned out to be quite a long write-up!
> 
> Thanks for that :)
> 
> > All in all, I feel we could probably focus on evaluating and pursuing this
> > experimental patch first. For maple tree performance specifically, it seems
> > like it might be the better fit compared to the parking mechanism (which is
> > probably better suited for generic allocation pressure outside of maple tree).
> 
> Agreed! I'd try to look at the code ASAP. For now we can probably... eh...
> park the parking patch :) and its possible improvements.

Haha, totally agree, thanks! No rush though, take your time. :)

> 
> Thanks again!

-- 
Thanks,
Hao

