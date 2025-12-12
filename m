Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6203BD43367
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 04:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21A26B0005; Thu, 11 Dec 2025 23:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9426B0006; Thu, 11 Dec 2025 23:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F946B0007; Thu, 11 Dec 2025 23:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A28196B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:41:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AF69134E66
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:41:03 +0000 (UTC)
X-FDA: 84209569206.17.5F2F6EC
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 304C71C000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:41:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ClgzUaV6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765514461; a=rsa-sha256;
	cv=none;
	b=wNgkzkTYPRYmyuMO/fbtEI0bVEh6hHUmhDurTSRMLrZ8OQT0FqhPRYAuSeGpvwU/JcttjV
	12vER0+40PxyYA4/Vo8WIzqnGpvlUZBYWWShR04PWA3O6ukUfmSCe8QtF5UrwP3CIlL2tW
	P/AOmgsK4zxMJYcmIuWxfZ797KOuaw8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ClgzUaV6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765514461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKAqM3auLcUWVEG/CGpBLBCuxFDBqzTE3fKRBrAdSPA=;
	b=g1hgHu6HFPyVFjwceDKwgF+RvwpKlytQAqgos1SpQKuX6Az961rXkruBRWlCVNTAQ4kmLT
	afzXSQikxtOeN4x+P415RRqMKAzKLOr9LsnDhsxYwDgWDK95HIn2FU8/IGjRX7bSqAecId
	DwQYsX4SlOh9PADgSkWQqMctQC4uxmY=
Date: Fri, 12 Dec 2025 04:40:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765514458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKAqM3auLcUWVEG/CGpBLBCuxFDBqzTE3fKRBrAdSPA=;
	b=ClgzUaV6JPUtQzlZahw94WSyjGJZeE5TJs/CVOmwIa/6tY7Cjgylvd2FokG5CpMSQ1FAdz
	tDYi8jcjq/kCbmcrGDGsBflOfOtib7FkNO+13YQ/zFWGjnTaE2fYkt2jph1vEPY0Wzgo7/
	5K5RkqEU/3x6TzjgvhJ0lH3Wp6u0o+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
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
Message-ID: <okfbc6hqk63qn4bxcryhmfmtjnzzaswtk2emev7lpjr5flrwiu@3g2o7geu5zgm>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
 <3i4jpzank53niagxzddc3vmzi5s3o5kmernzitktyavd5jwvp5@ytxzww57ux7a>
 <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472875DB2900920EB2C51DCC9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 304C71C000A
X-Stat-Signature: eoho5a6168a385mgkuwwrqxkwj6k1pk4
X-Rspam-User: 
X-HE-Tag: 1765514460-1919
X-HE-Meta: U2FsdGVkX18zWwMbbPmaKUS7CNuocdED9XHi4cXqZzMbA6Wieb8LLULm+kMY+ndnJG+0OxbIjvTtsCpTuw21ONG47tulSpLEhfBcWOHMqLIF5HD8cv3Ur17PE/oUfEf/MmvDEOLCu939ZkDJo5f3uhUPhdGY26DVnoB8N6cZzSUdProhm/bt1Fh3PpfTQ3iekM2+Jt5Ot5RcrY14j/vFEkKgQeeyvnrgQ1zY3SHdvzeHgUsFucPKq/HhHklV7CA8fSsvBA/Qb8V+Zi7yFnu6TSTb5tHT3X8LU9VYDtuGW8dkXUbRZrMf3fMvIYfYw0kZuYxFgqRHKPGH2/fQSReS08Q4YBdp0mPZoV1We6KXMFW+JXo2QmSLQ9O6JmXs5Q5LmAiEuEcUVTtp/TEC9f0iKz+uTi4HrSGvr770lGTwQfMEs5hgRvnjHzug0qIIQzp+hSFW6DsN2XbgBRf6zB7xDb2CpqEkmdIuQor/iChMLwcoLCzHvhQmDtxPDoSnN/Qf3w1jJZcx0KN6DHETYzw9OkaEVybyCZ879n9MYds43Zt0TtDQeamPTaodZnYK3qD9+oShF/a6VoLuP+yM5XTkK8E31CnpExAM6fMoO1E/W0xefer/mwlSkl2uNW5xMFwkdpuZvtU8Bqb7PB8HwHTOGdmv1s4L/0RDqtQoPExWZ2ObJb5akVegKHEpwIC6iMG2J8oX+XQ9IPOKd4nfINHwZZSWx4gh51jGlpyw22pubGz5jV0oalO+B5BCBT9zvzWetZdyu3XF6HIyeapMogYU/7jeUWYiP2urCMcBSgZ7bMg1nWvK4o2+ypX0zr+JxbSytH0GDFseusKIMsqRY0JPOEbtaD7RgP5ejmycXKXDf2RPZmLLIoBcte7sC6i0zLuL0rVbSZqLjGj9//zLlJOldgbOESFVmfMLdCgXHm2FzT13RxeHs1T5NikbwKfjl7tP9WzMp3GsALHsp6Yhrzv
 IYL80g6J
 rf6CIEz2gsFqvYl4S4VgwzZKzVj8zcJ0ySzjpEIRHEOCv3+31+GlYHEvNxXXvGJaOMTBVpjt5QehL4I1S2XnEwvSt9SWTfobwS2YIlR9RT9NG9ZKt+420OLhJE8iZxrETDNc8A4qFIvDVCh1VCVoXQii7tEsW83k+OMZNjtpOGU+AMqp0oUOn6A3mFqcrS97W2J7TVoE++AMmeIuT/OyIV6HLI9dc8sh6WjmDoSTYh+l1wswHcyvDLRmtxVoFkVwUVI8sdPQtVmM0HffU6jb622b8uYb1VSU3oizTDYGDfFyyTTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 01:43:54AM +0000, Sridhar, Kanchana P wrote:
[..]
> > 
> > Instead of this:
> > 
> > > +/*
> > > + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number
> > otherwise.
> > > + * The code for __kmem_cache_alloc_bulk() indicates that this positive
> > number
> > > + * will be the @size requested, i.e., @nr_entries.
> > > + */
> > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > **entries,
> > > +							   unsigned int
> > nr_entries,
> > > +							   gfp_t gfp)
> > > +{
> > > +	int nr_alloc = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
> > > +					     nr_entries, entries);
> > > +
> > 
> > Add this here:
> > 	/*
> > 	 * kmem_cache_alloc_bulk() should return nr_entries on success
> > 	 * and 0 on failure.
> > 	 */
> > 
> 
> Sure.
> 
> > > +	WARN_ON(!nr_alloc || (nr_alloc != nr_entries));
> > 
> > WARN_ON_ONCE() is sufficient, and why do we WARN if
> > kmem_cache_alloc_bulk() fails? I thought that was expected in some
> > cases.
> 
> I can change this to a WARN_ON_ONCE(). The code for kmem_cache_alloc_bulk()
> makes sure that either all entries are allocated, or none are allocated
> (partial allocations are freed and 0 returned in case of the latter). It can be expected
> to fail based on this.

Right, I mean specifically the !nr_alloc case. This should be expected,
so we should not WARN in this case, right? IIUC, we should do:

	WARN_ON_ONCE(nr_alloc && nr_alloc != nr_entries)

> 
> I believe there was an earlier comment for which I added the WARN_ON? I can
> either change this to WARN_ON_ONCE() or drop the WARN_ON_ONCE(), since
> we anyway have a fallback mechanism.
> 
> > 
> > > +
> > > +	return nr_alloc;
> > > +}
> > > +
> > 
[..]
> > > +static bool zswap_store_pages(struct folio *folio,
> > > +			      long start,
> > > +			      long end,
> > > +			      struct obj_cgroup *objcg,
> > > +			      struct zswap_pool *pool,
> > > +			      int nid,
> > > +			      bool wb_enabled)
> > >  {
> > > -	swp_entry_t page_swpentry = page_swap_entry(page);
> > > -	struct zswap_entry *entry, *old;
> > > -
> > > -	/* allocate entry */
> > > -	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > -	if (!entry) {
> > > -		zswap_reject_kmemcache_fail++;
> > > -		return false;
> > > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > > +	u8 i, store_fail_idx = 0, nr_pages = end - start;
> > > +
> > > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > > +
> > > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
> > 
> > Is this equivalent to just passing in 'entries'?
> 
> It is, however, I wanted to keep this equivalent to the failure case call to
> zswap_entries_cache_free_batch(), that passes in the address of the
> batch index that failed xarray store.

I understand, but I think it's clearer to pass 'entries'. Also, can we
make zswap_entries_cache_alloc_batch() take in the proper type and avoid
the cast at the callsites?

> 
> > 
> > > +						      nr_pages, GFP_KERNEL)))
> > {
> > > +		for (i = 0; i < nr_pages; ++i) {
> > > +			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL,
> > nid);
> > > +
> > > +			if (unlikely(!entries[i])) {
> > > +				zswap_reject_kmemcache_fail++;
> > > +				/*
> > > +				 * While handling this error, we only need to
> > > +				 * call zswap_entries_cache_free_batch() for
> > > +				 * entries[0 .. @i-1].
> > > +				 */
> > > +				nr_pages = i;
> > > +				goto store_pages_failed;
> > > +			}
> > > +		}
> > 
> > 
> > Maybe move the fallback loop into zswap_entries_cache_alloc_batch()?
> 
> I could, however, I would need to modify the API to return the error index "i",
> so that the "goto store_pages_failed" works. Imo, inlining this makes the error
> handling more apparent, but let me know.

Hmm yeah. Maybe make zswap_entries_cache_alloc_batch() free the already
allocated entries on failure? Then if zswap_entries_cache_alloc_batch()
fails we exit without goto store_pages_failed. This is the first failure
mode so we don't need any further cleanup anyway.

