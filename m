Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C58CD98E0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0992D8E0003; Thu, 13 Nov 2025 15:53:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0615C8E0002; Thu, 13 Nov 2025 15:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1748E0003; Thu, 13 Nov 2025 15:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCBF78E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:53:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8986E527FF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:53:01 +0000 (UTC)
X-FDA: 84106783362.07.6D6657A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8785D140003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:52:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7bI5Gju;
	spf=pass (imf26.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763067179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84lvdulY0qnFoCJ6XUO2ia2/3a1L4AL9KztS4+YBAEg=;
	b=0kgX6sFX2kce+o32m7Dyp9YmsXM/OkCzN6uKkHtmXjx1MtKJjc7J8br9Y3NTBuzYkZvKCe
	NW4ch3iMtLtXFdbTl7te06iLhL+vNlWpd978B2lDgCqLM2Ri8OlorDIs1TWz/HTB8qUncj
	S7tUh6WGPL+/CtyBQpY52pwjqOw7Pkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763067179; a=rsa-sha256;
	cv=none;
	b=RYgY0v4EOFHctmjTGfpoO2JRFw8lhmR19GbZf/8UX/yn4GwjAXEfbEGv0JU9AEbxLKg9cL
	r3TN5Krwp09I6cZWA6IAGn0hW8leTzgdW6bc2eNDof/+pu+0HyACKZ1VrN7/xe1q80prnM
	3Sk7zrWxuopwqpL3in5ASqLNYAVM3vw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7bI5Gju;
	spf=pass (imf26.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 13 Nov 2025 20:52:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763067177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84lvdulY0qnFoCJ6XUO2ia2/3a1L4AL9KztS4+YBAEg=;
	b=V7bI5Gju2EJRSRHgp239TUsyw5KI7Esvkt2yCv1n0XDaQGfsEwFonJBP2YktWJ+8sqYw2L
	wtYC0hJuLvi1u/rZOm/aZjcMMuEE76GgDxIXFnFqjKIX1UhJj2WKhGQn6sEf8mr0fuF4Y0
	TEDAgGAsxDQEnXdtQT5NwWmOHUFwQ64=
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
Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
Message-ID: <gnm6hcqlzna4p3unrad2sur7pnyovr7f2sfuiufzweu2zbfb2r@ia422moyti7v>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmJcsQy5foaS6HecqLyF1gKBhbLvbw6kM9bZmJ7UMBFw@mail.gmail.com>
 <SJ2PR11MB84726D144013B971838DC0DEC9C3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SJ2PR11MB84726D144013B971838DC0DEC9C3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8785D140003
X-Stat-Signature: ox9973so36m4h6ki47kqnb7f3hnwz7po
X-HE-Tag: 1763067179-884482
X-HE-Meta: U2FsdGVkX18IqDJCVOVCZgtSg3uetGu7q0j2GOq/9tL0s4wgYk8Qw4+FVM+tx5Gze2yXdqoM2d23Y+YBt2/qG6a+kxZP1j9THiL1wCWVayo+wMD0uXfEfJ3kUBVvbVgHtzZENEb+uD5rbFwy77SbaqYVwZ6J2Mkp51BGYEEkJfNnAPGHHbHyMq7Jc62ldVGzP1zEBFX4MNFX/oO8rpeZse3qplVuMaReALOxcw+RfexaHMRUlO78ZKG6oON5upNAI69LoBP/n/y2yl1VC3rBiNQXEjj7xaAreBHJO2m2bT/1A6dDjc4ADqlIIVz4TQ+G0tMX2NOicCs0txZmwaCM8gqTws+bIP9gcC1D8Bp32LM/CvKIqRakYtpRBGCHYeKRqFY+jRZ0cOmAf4FrGXshI2DLZHU3xkgUGw33NTES/JRKNUutSFIQ3Nj63YkBon/e6nMiiM3u4tP4Kj4sAcg/ry7/6Xc6X7eZchQAfR/zcvD4bhzge62IMSH5ESu7sIO4zzy6OiZDCaY7MjMMsPuV3JPNKMe5a7ytkdNkBgB0TWyBoyOMkwia9fWHF+eYc2wu8ZNWFeZjl0P2OnQEN9bSakO9WA6HT2PdvZ0vfJLG2nBVV13dKn59WsP5R6JVCCS/b+GVN4DCy56/h2sNwiF53h2PN6FY6gA+BXZ9cuhF8XDtIG8+rPBt/qpaPiM+5mGrTHwHyIMebC8fA2WPHujR+4eVPd1+AqyxhCoVykMtuxEFhD7g+ehQ4eMcgEeZWy5+o437ky9u8uCsDykLqq0WQKwRc/OLhrZAiqStAYv5Ljzn8P9YrM2UMOPVQ133ywMcD0W4ty3Y698Su1HUKSYEy2PyIK7iprJQiaLA6gET2CtKYGwCQecmLU+GJ9GkQKQDGv+6FWpn1gkFlgedUKw0jyAFSjr69vebgXnBXfnzZADeLzO1zUpDpiV16URBRs5WgovVmeRh/CG/aLkzp4H
 CGWmV9ui
 sOApgbeeT19J+Yc8HSrb9I/yawyeoBYuc4VqD6y/ugHMCgB/nrrNNA9pN30lEF1x3j5yLRONqY7hkP4AD42MsIvmu9bks9srzAJNBVuHFpzZKvvY6PWfpx5wA0BwKSr5LsajEI0B+IF3RKuCy2FLNs4gmy0wzgz69H+9h7Hwtk2bVGdcNU4Rcdpa70gH8SxkdY/ILaXk/IkedW58UYUgbL5L9D5GFmBR4M8s1ATvuCI0ExSUV/sJuxHRj9MjVGMLnt22+cr9RrHs7CriSzXMYvwvFReFRVxJp0cvZe13dUuqs8QJWXEwbWiNA6aYQJoJh0XqjL8k0OXcTBopW2F/UhbWfgg6JqZJ96b3jazm2uWFZfGW0VKyN63PW9jR7zWFC7hj0NdLV1oiACj45gzX7IogOfmDKIp3Abibbho9cWuw++I+e09+OSqLgTBskuhKZdT1cp6KOv1qzLF1C+IOQd3uQgDGBlWZwQsSdMwIiZP2LACnS/p83wk9KxIo8uwm/1tGiAYu3XpRQBZ5WOwJ0oEG33OwohiLiofGV0cSQ8MRuv8Kwu9Yph2g8kiS5+AvFeyogcAaMSM8PBWdZtZC9dZ52507pYxYE/LVPQKC6HSmK7J0zaIyJt7ROGEJ9Nsg5FdDWkYu8ZBOMgv9mMRV3Vkh/8/QkJKxGVRIjCfCK1916sViSuDuItqFUQ70AABd4rQ/vx3qcmiWvtGxlNtpcUO88ozcox5Dd7oaaWIfARvLONrPsylLnH0YuGypbyB2lycSF3/1+4rrbmx/2rlkSdmu9klPYwbArPfZFNtADe00pbl08aP/0O0+AoAE9eA0yEHuMFAj0q0D5hhEldhZUYl+vEi+08mSuheNf5tV/0+GvT3+VKO6IklfTHAuJlGSAAb5S//BfEbK3FVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 02:28:23AM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Nhat Pham <nphamcs@gmail.com>
> > Sent: Thursday, November 6, 2025 9:46 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a
> > large folio in batches.
> > 
> > On Tue, Nov 4, 2025 at 1:12 AM Kanchana P Sridhar
> > <kanchana.p.sridhar@intel.com> wrote:
> > >
> > > This patch makes two major changes:
> > >
> > > First, we allocate pool batching resources if the compressor supports
> > > batching:
> > >
> > >   This patch sets up zswap for allocating per-CPU resources optimally
> > >   for non-batching and batching compressors.
> > >
> > >   A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
> > >   limit on the number of pages in large folios that will be batch
> > >   compressed.
> > >
> > >   It is up to the compressor to manage multiple requests, as needed, to
> > >   accomplish batch parallelism. zswap only needs to allocate the per-CPU
> > >   dst buffers according to the batch size supported by the compressor.
> > >
> > >   A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
> > >   Yosry's suggestion. pool->compr_batch_size is set as the minimum of
> > >   the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE.
> > Accordingly,
> > >   pool->compr_batch_size compression dst buffers are allocated in the
> > >   per-CPU acomp_ctx.
> > >
> > >   zswap does not use more than one dst buffer yet. Follow-up patches
> > >   will actually utilize the multiple acomp_ctx buffers for batch
> > >   compression/decompression of multiple pages.
> > >
> > >   Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used
> > for
> > >   batching. There is a small extra memory overhead of allocating
> > >   the acomp_ctx->buffers array for compressors that do not support
> > >   batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).
> > >
> > > Next, we store the folio in batches:
> > >
> > >   This patch modifies zswap_store() to store a batch of pages in large
> > >   folios at a time, instead of storing one page at a time. It does this by
> > >   calling a new procedure zswap_store_pages() with a range of indices in
> > >   the folio: for batching compressors, this range contains up to
> > >   pool->compr_batch_size pages. For non-batching compressors, we send up
> > >   to ZSWAP_MAX_BATCH_SIZE pages to be sequentially compressed and
> > stored
> > >   in zswap_store_pages().
> > >
> > >   zswap_store_pages() implements all the computes done earlier in
> > >   zswap_store_page() for a single-page, for multiple pages in a folio,
> > >   namely the "batch":
> > >
> > >   1) It starts by allocating all zswap entries required to store the
> > >      batch. New procedures, zswap_entries_cache_alloc_batch() and
> > >      zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
> > >      to optimize the performance of this step.
> > >
> > >   2) The entry doesn't have to be allocated on the same node as the page
> > >      being stored in zswap: we let the slab allocator decide this in
> > >      kmem_cache_alloc_bulk(). However, to make sure the current zswap
> > >      LRU list/shrinker behavior is preserved, we store the folio's nid as
> > >      a new @nid member in the entry to enable adding it to the correct
> > >      LRU list (and deleting it from the right LRU list). This ensures
> > >      that when the folio's allocating NUMA node is under memory
> > >      pressure, the entries corresponding to its pages are written back.
> > >
> > >      The memory footprint of struct zswap_entry remains unchanged at
> > >      56 bytes with the addition of the "int nid" member by condensing
> > >      "length" and "referenced" into 4 bytes using bit fields and using
> > >      the 4 bytes available after "referenced" for the "int nid". Thanks
> > >      to Nhat and Yosry for these suggestions!
> > >
> > >   3) Next, the entries fields are written, computes that need to be happen
> > >      anyway, without modifying the zswap xarray/LRU publishing order. This
> > >      avoids bringing the entries into the cache for writing in different
> > >      code blocks within this procedure, hence improves latency.
> > >
> > >   4) Next, it calls zswap_compress() to sequentially compress each page in
> > >      the batch.
> > >
> > >   5) Finally, it adds the batch's zswap entries to the xarray and LRU,
> > >      charges zswap memory and increments zswap stats.
> > >
> > >   6) The error handling and cleanup required for all failure scenarios
> > >      that can occur while storing a batch in zswap are consolidated to a
> > >      single "store_pages_failed" label in zswap_store_pages(). Here again,
> > >      we optimize performance by calling kmem_cache_free_bulk().
> > >
> > > This commit also makes a minor optimization in zswap_compress(), that
> > > takes a "bool wb_enabled" argument; computed once in zswap_store()
> > > rather than for each page in the folio.
> > >
> > > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > > Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > > ---
> > >  mm/zswap.c | 336 ++++++++++++++++++++++++++++++++++++-------------
> > ----
> > >  1 file changed, 232 insertions(+), 104 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index cb384eb7c815..257567edc587 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
> > >
> > >  #define ZSWAP_PARAM_UNSET ""
> > >
> > > +/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
> > > +#define ZSWAP_MAX_BATCH_SIZE 8U
> > > +
> > >  static int zswap_setup(void);
> > >
> > >  /* Enable/disable zswap */
> > > @@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
> > >         struct crypto_acomp *acomp;
> > >         struct acomp_req *req;
> > >         struct crypto_wait wait;
> > > -       u8 *buffer;
> > > +       u8 **buffers;
> > >         struct mutex mutex;
> > >         bool is_sleepable;
> > >  };
> > > @@ -149,6 +152,9 @@ struct crypto_acomp_ctx {
> > >   * The only case where lru_lock is not acquired while holding tree.lock is
> > >   * when a zswap_entry is taken off the lru for writeback, in that case it
> > >   * needs to be verified that it's still valid in the tree.
> > > + *
> > > + * @compr_batch_size: The max batch size of the compression algorithm,
> > > + *                    bounded by ZSWAP_MAX_BATCH_SIZE.
> > >   */
> > >  struct zswap_pool {
> > >         struct zs_pool *zs_pool;
> > > @@ -158,6 +164,7 @@ struct zswap_pool {
> > >         struct work_struct release_work;
> > >         struct hlist_node node;
> > >         char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > +       u8 compr_batch_size;
> > >  };
> > >
> > >  /* Global LRU lists shared by all zswap pools. */
> > > @@ -182,6 +189,7 @@ static struct shrinker *zswap_shrinker;
> > >   *              writeback logic. The entry is only reclaimed by the writeback
> > >   *              logic if referenced is unset. See comments in the shrinker
> > >   *              section for context.
> > > + * nid - NUMA node id of the page for which this is the zswap entry.
> > >   * pool - the zswap_pool the entry's data is in
> > >   * handle - zsmalloc allocation handle that stores the compressed page data
> > >   * objcg - the obj_cgroup that the compressed memory is charged to
> > > @@ -189,8 +197,11 @@ static struct shrinker *zswap_shrinker;
> > >   */
> > >  struct zswap_entry {
> > >         swp_entry_t swpentry;
> > > -       unsigned int length;
> > > -       bool referenced;
> > > +       struct {
> > > +               unsigned int length:31;
> > > +               bool referenced:1;
> > > +       };
> > 
> > Maybe make these macro-defined constants?
> > 
> > Code mostly LGTM otherwise.
> 
> Thanks, Nhat! With respect to the suggestion to make the bit-fields
> as macro-defined constants, I was browsing through kernel headers
> that use bit-fields, and it appears the convention is to use integers
> rather than constants.

Yeah I think that's the common case, let's keep the numbers as-is.

