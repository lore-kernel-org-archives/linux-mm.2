Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB333CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 22:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C4D8E0095; Wed, 15 Oct 2025 18:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CF58E0027; Wed, 15 Oct 2025 18:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02AEC8E0095; Wed, 15 Oct 2025 18:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF4EB8E0027
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:24:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF2B95874D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:24:30 +0000 (UTC)
X-FDA: 84001778700.05.1280E98
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id D3605140010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:24:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PWg2J37x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760567069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIr+d68g84l91W3HwMz0ACZJQKOkzX4zJJOPAlhsoUQ=;
	b=tMJegTeDyQeZtC6vY6dWpA3fvmO3OJpN0Brbi2/0HlzLYC8B3tLy0HvHAoQ67XyHsonPgx
	grJ1EROwu3INaR+SN+IHbOgus4yNl4zs3udNy19YWZLVTPVmeeJr6W6crnIH5N0/ur07++
	LCOfxELXATZbYYxSuZ25IqihONgvVHI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PWg2J37x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760567069; a=rsa-sha256;
	cv=none;
	b=sCYepBMiAh49ZSwvHiuoZ1Mrb3SkZE3BIITomqhoFCBlrfP7m9Hmgc3ZZJ4QSyTbk4u8Hc
	BqucLkzKdyXuhdttIHD4BDrhdtAA6Fs5MSCvu1Ge9LbXx8PWHyP+L1V7WcXn54U/rvq2Rw
	MGneqiMJYQFL1PxU4t/bTnDlQNxegzw=
Date: Wed, 15 Oct 2025 22:24:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760567066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIr+d68g84l91W3HwMz0ACZJQKOkzX4zJJOPAlhsoUQ=;
	b=PWg2J37xTFtci3yVqYYX89J4w3nkCje5JhlfDTC4VGW21RO8zYwFfK40C/DfNG7rMQwzvm
	6gWbSUQgBZBfCT3hpSW637lCncfcshMqpxcKCWxt4EFvGIqebOwgChqdlu7vk0k/finMFB
	SmtZgtHrtNqnEFXp5M4v6uMzgClJfEE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Message-ID: <wn6pnt2nm5pguceiquctilul6lrk3ckycypwnw2zfxqrlgi2cf@5qn32ewswfl7>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <xnwqi5jnawvxdciqapfhhkneynsdr3dx36hmqe7jn4shm3uc3y@iyi5qqfubqey>
 <CAKEwX=NyUR6UE0PhXCaHOdta4=gVvRj7QgZtpPaLADpfXYyvZw@mail.gmail.com>
 <PH7PR11MB812102541D5106A6D0E21E28C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=NkaaCkoyULr4J+5-F+L5bRhM0F8JsV2DS0Mk=xYhncRw@mail.gmail.com>
 <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH7PR11MB812150A977B6F9F68ACDBCC9C9E8A@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D3605140010
X-Rspamd-Server: rspam03
X-Stat-Signature: mti5uw1gst1wrstbjnfyjip69ujsmrje
X-HE-Tag: 1760567068-961750
X-HE-Meta: U2FsdGVkX1/hkQphbkEC8iO8IbBA4JwbpOmC9izhk24EeiS1YYw7TDpp3Mdnm2FxKZSETzQieFweVsEz3KyfWk1uRmEq6DVrYZxJKBf7lJ+9nlsM+zR/tyQnNirtV4cxGxnvElMfonLsM+AF4TT24YuIXbHZOt0IFdqOBaH5bDTugJWDDO3uwIWJZFqARXx3gX5Lz158rtia9GaJVgtJhfll21bfz312EqmAB3fwAW0IU+a+pfwJEtNJ22pOTXXx2oPNl2yLkU50bQW8BCuZdrBMZNwg1xnYt7xlXzEsDE8yH7ltycFbk/zxNS3GEyeGzZO4mgULnP3zKy7LZpA7f2KwUjdln2vY+21G7hjw1vjLuSe2KusLgbUluXvN4YWkFSJTrYt68V+qKPSwDzzhiYTgMCrND4RJo9zAkilTtd431L13WyP/ru02MMCZEeQXXzjCMdY+g1bbF7omiqjNzK/wd/DVyDXDlUyA9K1++FC4DxZv0zlF8faiKtBBXZUgWnSBWZ444HWfMBuPpAw9fogRuBfVBQY+BWYWo4TIo8lRfuQLABfaxd07nIF6Zp7RDe4OQiag9Hlj+IYnTyfv4MamHd93VJ83SrM5lTag7oXcfqfqw4Sr2VDNN2u2zAs2lbTe/BW31nLZU72MiPHM7dYk1N0shnDa2+zD7IkH425MQdHLSM5PywPBcBGQ27ZXRcwfRNT389P9E1EjLWsF9gsrZmjIs9WXzEvtqsBiI8RnBhDjVUnHjK2BU7gu25kvalTekHFz3a2BJ7UZVWP7xQ0vXmunpoIvTAY62EUF1zoGyFlg7e3wQU5jAOKbf6GiCfD8kmeEPVXUrKiytC2oyjojjvPiVxS3twZDNQyYvukFh8sIIPVnAyiueJaibm5XtDGj+6zEnFoLUtyXn/zIYQvXwhQeSmY4DE6cNZW6kF3/WWSkmSVHDUFd02gb5jMeN1Gg4LWjiIRPiRrpaCQ
 mdH7XpbD
 ODzla9gFmWOhHUJgE9iMoXAXyuf8jEZtwburT9EN7dAKXr7StYGjgPROK0sAs7R7OZJgPlzxAwado3VKWhMiZgiH1tNMawjQUP2AhpQdlZ0B5kgjerjdCANad4LKAGtdeGsuVYgHNSAxDwmviJqj070PaehIawv1E9VvToXDzACBZZGcgNYpJwzFZTVEcNv6iWYqokBcnyTxwTYnqmRLNLCl2vbuFuOSwnB+ddZuN3oQWtVNT+MK3BYUTGeYUYGFlhnbpeNFTIQWiS7Lz15KMiqdrayk7HR7pZqEKOnZVVEYg1p49YB5c2dKOvHHJhtwVVkH6VdVqcU60/b3mK/o/rVlkXHRPa24cBDDZRw/LCjxga4VFsdgzl2rcnedqYLkkl9cUvy5+4Ibmza2GtdS0Go4qKX3nPC7BVo36PBNK+yDDyVfZe5OpavutfsyQU+I9eAcFCp4JYqV2YJ7sFWT6ViEDKLsnHtxBY/AHcyjGuVvrCfh2O8I8o2mtEKxiVd7l4MRaba/HE7dH2bcLFvayXk7VIHBF9wNgZL8gtgyB1JlRNfJAogtJIHM+NDH+Cg1sJc9buWtCncu5ZpQKJjGp1rODXluGzxRya/YspMvtdUQ43Doulows3jNJWU+5Z2e9NmFYXVH0kzwuxT9oHIryNz+LmKWMG98oYVAzgaNzlPWElHV5nDiFNH0HTJJtChqlys6Pfjygc53yhBLkSlNzaykSIMOSYAhbnN7sd4xXFzT57byv3oThaM2NQpPn9PuAzfd7VPguLAD62qNjM5awTklhvxWUIwt1PPf618fHhbZgKxxnC+VFyWCgZ6TI7pnvA9TXwxm3lbh98R/UjdXPuafVyZRuSW53Yd3Ku/UifGZG/2cl1oifcPnxmBKLde0M2hO0k3+Xdtcze3XDXY9gdG0WO/Ju6Fc4/hah
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:15:12PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Wednesday, October 15, 2025 10:04 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: Yosry Ahmed <yosry.ahmed@linux.dev>; linux-kernel@vger.kernel.org;
> > linux-mm@kvack.org; hannes@cmpxchg.org; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
> > 
> > On Tue, Oct 14, 2025 at 8:42 PM Sridhar, Kanchana P
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Nhat Pham <nphamcs@gmail.com>
> > > > Sent: Tuesday, October 14, 2025 9:35 AM
> > > > To: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; linux-
> > > > kernel@vger.kernel.org; linux-mm@kvack.org; hannes@cmpxchg.org;
> > > > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > > > ryan.roberts@arm.com; 21cnbao@gmail.com;
> > > > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > > > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > > > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > > > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > > > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > > > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> > <vinicius.gomes@intel.com>;
> > > > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > > > <vinodh.gopal@intel.com>
> > > > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > > > large folio in batches.
> > > >
> > > > On Tue, Oct 14, 2025 at 8:29 AM Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > wrote:
> > > > >
> > > > > [..]
> > > > > > > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > > > > > > >   struct work_struct release_work;
> > > > > > > >   struct hlist_node node;
> > > > > > > >   char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > > > > > > + u8 compr_batch_size;
> > > > > > > > + u8 store_batch_size;
> > > > > > >
> > > > > > > I don't think we need to store store_batch_size, seems trivial to
> > > > > > > calculate at store time (perhaps in a helper).
> > > > > > >
> > > > > > > Taking a step back, is there any benefit to limiting store_batch_size
> > to
> > > > > > > compr_batch_size? Is there a disadvantage to using
> > > > > > > ZSWAP_MAX_BATCH_SIZE
> > > > > > > even if it's higher than the HW compression batch size?
> > > > > >
> > > > > > Thanks Yosry, for the code review comments. I had a discussion with
> > > > > > Barry earlier on these very same topics as follow up to his review
> > > > comments
> > > > > > for v11, starting with [1]. Can you please go through the rationale for
> > > > > > these design choices, and let me know if you have any questions:
> > > > > >
> > > > > > [1]: https://patchwork.kernel.org/comment/26530319/
> > > > >
> > > > > I am surprised that calculating the value in zswap_store() causes a
> > > > > regression, but I am fine with keeping the precalculation in this case.
> > > > >
> > > > > I think there's a bigger problem here tho, more below.
> > > > >
> > > > > > > > + */
> > > > > > > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > > > > > > **entries,
> > > > > > > > +                                                    unsigned int
> > > > > > > nr_entries,
> > > > > > > > +                                                    gfp_t gfp)
> > > > > > > > +{
> > > > > > > > + return kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > nr_entries,
> > > > > > > entries);
> > > > > > >
> > > > > > > We currently use kmem_cache_alloc_node() in
> > > > zswap_entry_cache_alloc() to
> > > > > > > allocate the entry on the same node as the compressed page. We
> > use
> > > > > > > entry_to_nid() to get the node for LRU operations.
> > > > > > >
> > > > > > > This breaks that assumption.
> > > > > >
> > > > > > You bring up a good point. I was looking at the code in slub.c and my
> > > > > > understanding thus far is that both, bulk allocations and
> > > > kmem_cache_alloc_node()
> > > > > > allocations are made from a per-CPU "cpu_slab" that is allocated by
> > SLUB.
> > > > > >
> > > > > > IIUC, the concern you are raising is in the mainline, the entry is
> > allocated
> > > > on
> > > > > > the same node as the compressed page, and gets added to the LRU list
> > of
> > > > that
> > > > > > node. IOW, the node to which the compressed page belongs is the one
> > to
> > > > whose
> > > > > > LRU the entry will be added.
> > > > > >
> > > > > > With this patch, with kmem_cache_alloc_bulk(), the entry will be
> > created
> > > > on
> > > > > > the per-CPU slab of the CPU on which zswap_store() is called and will
> > be
> > > > > > added to the LRU of that per-CPU slab's NUMA node. Hence, the end
> > > > result
> > > > > > could potentially be that the zswap_entry for a page could potentially
> > be
> > > > > > on a different NUMA node/memcg than the page's NUMA node.
> > > >
> > > > I think only the NUMA node is the problem, not the memcg.
> > > >
> > > > > >
> > > > > > This is my thinking as to how this will impact the zswap shrinker:
> > > > > >
> > > > > > 1) memcg shrinker: if the memcg the entry ends up in is on the
> > > > zswap_list_lru,
> > > > > >     the entry will be written back.
> > > > > > 2) Global shrinker: will cycle through all memcg's that have pages in
> > the
> > > > > >     zswap_list_lru, and the entry will be written back.
> > > > > >
> > > > > > Based on this, it is not clear to me if there is a problem, and would like
> > to
> > > > > > request you, Nhat and others to provide insights as well.
> > > > > >
> > > > > > Interestingly, most of the code in slub.c has unlikely(!node_match(slab,
> > > > node)).
> > > > > > Does this imply some higher level mm slab allocation requirements?
> > > > > >
> > > > > > I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if
> > we
> > > > > > think this would be more correct.
> > > > >
> > > > > I saw your other response as well, but I think one thing is not clear
> > > > > here. The zswap entry will get written back "eventually", sure, but
> > > > > that's not the problem.
> > > > >
> > > > > If the zswap entry is on the wrong node lru, two things happen:
> > > > > (a) When the "right" node is under memory pressure, we cannot free
> > this
> > > > >     entry by writing it back since it's not available in the lru.
> > > > > (b) When the "wrong" node is under memory pressure, it will potentially
> > > > >     writeback entries from other nodes AND report them as being freed
> > > > >     from this node.
> > > > >
> > > > > Both (a) and (b) cause less effective reclaim from the zswap shrinker.
> > > > > Additionally (b) causes the shrinker to report the wrong amount of freed
> > > > > memory from the node. While this may not be significant today, it's very
> > > > > possible that more heuristics start relying on this number in the
> > > > > future.
> > > > >
> > > > > I don't believe we should put zswap entries on the wrong LRU, but I will
> > > > > defer to Nhat for the final verdict if he has a different opinion.
> > > >
> > > > Oh shoot. Yeah I missed that part.
> > > >
> > > > In the past, we sort of did not care - zswap was very poorly designed
> > > > for NUMA architecture in general, and most of our test setups have
> > > > been single-node, so these kinds of discrepancies did not show up in
> > > > performance numbers.
> > > >
> > > > But we are getting more multi-node systems:
> > > >
> > > > 1. Bigger hosts (memory-wise) tend to also have more than one nodes.
> > > > It scales better that way (especially because a lot of structures and
> > > > locks protecting them are node-partitioned).
> > > >
> > > > 2. We have also seen different memory media that are often expressed
> > > > to the kernel as nodes: CXL, GPU memory, etc.
> > > >
> > > > This will necessitate tightening memory placement. We recently had to
> > > > fix one such issue:
> > > >
> > > >
> > https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3a
> > > > da6c8217d5b
> > > >
> > > > So I'm a bit nervous about this change, which will make us use the wrong
> > > > LRU...
> > > >
> > > > Some work around:
> > > >
> > > > 1. Can we squeeze an extra int field anywhere in struct zswap_entry?
> > > >
> > > > 2. Can we pump nid all the way to zswap_lru_add()?
> > > >
> > > > This is still not 100% ideal - the metadata (struct zswap_entry) will
> > > > still be allocated on the wrong node. But at least the data are
> > > > properly managed, i.e on the right LRU.
> > >
> > > Thanks, Nhat and Yosry for the discussion. Thank you Nhat, for the
> > > zsmalloc change log reference and for the work arounds!
> > >
> > > Following your suggestion in (2), can we pass in the folio's nid from
> > > zswap_store_pages() to zswap_lru_add(), as follows:
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 263bc6d7f5c6..44665deece80 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -694,9 +694,9 @@ static inline int entry_to_nid(struct zswap_entry
> > *entry)
> > >         return page_to_nid(virt_to_page(entry));
> > >  }
> > >
> > > -static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry
> > *entry)
> > > +static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry
> > *entry,
> > > +                         int nid)
> > >  {
> > > -       int nid = entry_to_nid(entry);
> > >         struct mem_cgroup *memcg;
> > >
> > >         /*
> > > @@ -1758,7 +1758,7 @@ static bool zswap_store_pages(struct folio *folio,
> > >                  *    an incoherent entry.
> > >                  */
> > >                 if (likely(entry->length))
> > > -                       zswap_lru_add(&zswap_list_lru, entry);
> > > +                       zswap_lru_add(&zswap_list_lru, entry, nid);
> > >         }
> > >
> > >         return true;
> > > --
> > >
> > > I believe this will add the entry to the LRU node of the folio being
> > > compressed. If so, we may be able to avoid adding an int field to
> > > struct zswap_entry?
> > 
> > Hmm that might not work for zswap_lru_del() :(
> > 
> > zswap_entry_free() might be called in context where we do not have
> > access to the node information (zswap_load()) for e.g.
> 
> I was thinking that zswap_lru_del() would follow a similar approach,
> i.e., zswap_load() would pass the folio's nid to zswap_lru_del(), but
> you're right, this would not work if the process faulting in the page
> is running on a different node than the one that stored the page.
> 
> > 
> > Another alternative: can we instead determine the node from the
> > compressed object's storage? i.e store zswap_entry in the LRU
> > corresponding to the node that holds the compressed data?
> > 
> > You'll probably need the new zsmalloc API to get the node information.
> > And can zsmalloc migrate a backing page to a different node? This
> > seems complicated...
> 
> That's a great idea! It might be worth exploring if our goal is to maintain
> parity with the current status for nodes/LRU/shrinker. 
> 
> Good point about zsmalloc migrating a backing page to a different node:
> although wouldn't this be a problem with the current status quo also?
> 
> To summarize my understanding: the current approach ensures that the
> NUMA node in which the page was allocated, is the one that will hold the
> compressed data (the zsmalloc commit log you shared), and is the node
> which, under memory pressure, will cause the entry to be written back.
> 
> The entry being allocated on the same NUMA node as the page being
> stored in zswap, imho is a "mechanism" to achieve the above. When the
> page is faulted in, it is possible that the process has migrated to a different
> node, and the folio is now assigned a different nid. IOW, there is no more
> significance to the entry's nid than to facilitate the current approach, IIUC.
> 
> I think your suggestion (1) wherein we store the NUMA node as an int field
> in the entry can accomplish the same thing. The entry doesn't have to be
> allocated on the same node as the page being stored in zswap: we could
> let the slab allocator decide this (potentially more optimal system-wide?).
> 
> The entry int field could also be more fail-safe than looking up the zsmalloc
> node info (which could have migrated the compressed zspage [still need to
> verify]).
> 
> I think the entry int field might also be cleaner with changes encapsulated
> to zswap_lru_add()/del(). If we rely on zsmalloc node derivation, it might
> require changes in zswap_decompress(). The downside is we add an int
> member to the zswap_entry.
> 
> If its Ok with you, can I evaluate the feasibility of (1) and update shortly
> after gathering data with usemem30 and kernel_compilation?
> I am trying to avoid the latency penalty of not using the bulk allocation
> API, and at the same time, ensure we don't change the NUMA node/LRU
> lists/shrinker functionality. Based on the data I had gathered recently
> in [1], reverting to use kmem_cache_alloc_node() for the batch in
> zswap_store_pages() impacts latency considerably.
> 
> [1] https://patchwork.kernel.org/comment/26590517/
> 
> > 
> > Taking a step back though, do we have to use the bulk allocation API
> > here? Calling the single-allocation version 512 times for a PMD-sized
> > page is no worse than the status quo, correct? We can leave this part
> > unoptimized for now - in the future, if the use case justifies it, we
> > can talk to slab allocator maintainers and ask for guidance on a
> > lock-optimized cross-node bulk allocation API.
> 
> Definitely. This is a sound fallback strategy if (1) doesn't work out, and
> even if it does, we feel that adding an int field to the metadata is not
> acceptable/needed. I will make sure to share before/after data with
> usemem30 and kernel_compilation with the different options (the
> int field in zswap_entry, bulk vs. single allocation).

I am against increasing the size of struct zswap_entry. On x86_64, there
is a 3 byte hole after 'referenced'. We can technically use that,
although the node id is usually an int, which is 4 bytes on x86_64.

In practice, I think 2 bytes (i.e. short) should be enough, but it will
be ugly to cast the node id to a short. We should at least WARN on
overflow.

Or we can take the simple route and drop the bulk allocation.

