Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36B6CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837596B008A; Fri,  9 Oct 2026 11:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D1E6B008C; Fri,  9 Oct 2026 11:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724436B0092; Fri,  9 Oct 2026 11:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD446B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:27:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42F90160455
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:27:15 +0000 (UTC)
X-FDA: 85303466430.29.28B7A07
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00E19120007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:27:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FaTIUcQT;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791559633;
	b=ri4xqzlaZynS5fns540oR1fQdTbdsD8iejfcKShB8G8ArEr5icNHPiReTaGeDvyVv2Y2aO
	zZRo668vxdT+hyZdAQUusjvPOPPzQT9hHbPYJXSlGaMyg9eRvP5zjK9s/qA89nSG4gWRJX
	8G+5cu3nwnpTauRmdy2ckGJUSVjGsbk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FaTIUcQT;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791559633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbC7h89PQCVrXdvtwtWv6RLON+qjdsUuPxfdt1fh2oU=;
	b=ctX3QGpxW1tce/r1B4Vj1FUL+mLFMmZpn8yX4OFO5E6zttASu1i/s2dWj/hB2VcYKZvzOs
	hHPLmtuw7KmB+quRwATwUktStaETPhuHoqm5yBEBd8LJVHRZ9N5laOI6a/LNk/GveyDHLd
	Na8P4k8k7n4ptyIlICag9bsjmDzk2/M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oYvjI9crgDoGo2keD2njZ5LJDYD26IF+7c19OHok5yY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791559630; v=1; x=1792164430;
 b=FaTIUcQTpLUxLOWoOuXERinzwamZPq62wFKl29V91EopPpxE9Ga+VyaHNuMWFGATmZWZf1jF
 irPiqu8J7Jw8uEehaAgaYXJS/i+wvyUsHTRk8XFHBne8PYfBHjD+u9go03x+UnE3bwUJHDmSXoM
 oXW+HInQUVP93W+cLrCr3zqg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c49cc065a38ee442;
	Fri, 09 Oct 2026 15:27:10 +0000
X-Mizu-Trace-ID: c49cc065a38ee442
X-Migadu-Flow: FLOW_OUT
Message-ID: <b887f721-124c-49ce-8b5b-c1edf0c24e40@linux.dev>
Date: Fri, 9 Oct 2026 16:27:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: zswap: use stack requests for synchronous
 decompression
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-3-usama.arif@linux.dev>
 <CAO9r8zMFm+JsboodgkG-jdQ9eTk+JHo=d-3Dw8PUcEqjr3+xVg@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zMFm+JsboodgkG-jdQ9eTk+JHo=d-3Dw8PUcEqjr3+xVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00E19120007
X-Stat-Signature: 8h9skmr6cxbutea3ty6hnjsmjtkxee6k
X-HE-Tag: 1791559632-332054
X-HE-Meta: U2FsdGVkX19V6u35zN+QMnsJKgpN7LkIbMqRwgvzx9ouLlykY5D/G6ALZx1+bt90hdm9yGnxk200e8jy3g/Hx2wG52c8rN/5c1NW+RoQAVunb/RI7rc/bNqWJ+oonjWfbUIUBluBZCpaW/3S8g8kQlJUaJHiXKrg1VTuf4BCieKKCedBCUfyWHyG01Ecnj6WGfcuac0oFTo29aBMtyiKSdJTnTxcWF51T5HkpMPrSuNlfm/V9ZMk7nQB5d4gZ4KIikhr7lOtNTh9SrCB3ZiAvB5ElX16t99LNOkD4CL2vuJHDVtHLy7ZCO7E95+BHne/tkNG1lbv7fWOj3v/HxZKDd7FvqEIdRdxLfMbyPKEPPF7cjgoUcMofp9mB5cUig+/S9YVP002ubsrjzPe2dHVfbpEs9ck2GjolKnZoCaJo6hv7AZm61naeA6tZxyKpQn6IQGf1BcZqumtppLMiI6TkSeYMhiDu+w9aRrN457SX47mPqWd0xDvgd3ylqtvQaf0I2XvCOkJkN4+3OnAP6V/sLMmLspDkXoI2UDYA0NSX5niDyKdpsWlb72Yg5+jlQSGAeGCJ/ZysVY13nQ9Z9Do9D0RMxwRHL6Hlci7VxwVm3X9oGrg0d2oSwpQgA/e6ycHxN6oosD6o6p5+R4zrKR/aZisZWPTK3XKQKKewp5Vrq9gASJAdG/Z/hEPuSXDF2cm3lLdcqPjZT4Gx0KbEQPYTeEirypN4yZ8SG/oadbub1zWIciWTmXOUNTIR3fbWPIcyMl5pbIfU7kL1P6gzV/q4JKrFC6Vw2/Jy9zOfWOdGaNN49Ghj8L+JBme7Uyt98OsiEIcGKmIuY3GkLOMqgb3HydM1LEbJsThMml9I5hadDvg7CPMuib76WCGXuVxKMxI+5vcNwqpQuEFCjojG2UY9G41xY3TYg0q+put3LnNjlI1GU5oTgU8smbLD60AFataIcpsON8OsZIcKPO5ayr
 1ISh0Xy1
 nQ4LWMLxANuK381n1NyD0WH30GEQlq49nzN/sQyTRAovMHpwCSp0JdccJBW6DIno9jEz/ZRxJPpP2ZPS/+V4qBFUtVrwDOj/r097KEpWLrS6mA440zV0sVDHOkWHbhToZVvfCxHepc2REILIqre3HZZDWVZOGV5uFo4/gtI1Pwx4B5nJiTaHbuRBRUpVCUAZjc3EmeLg9B7gJYiEw1oJCxnG7OgfKtKDBrl5GzmAooycAyZxMzGPJfTr5b2/f5CX5KtKq9T96RayxnNRCAqa/dn8H2fRNboe/laQjv4SQfggquKjIEYn6cJ4Bdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/2026 23:28, Yosry Ahmed wrote:
> On Mon, Oct 5, 2026 at 5:23 PM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> With separate requests for compression and decompression, loads still
>> serialize on the per-CPU decompression mutex. A low-priority load that
>> is preempted after the codec drops its stream lock keeps holding the mutex
>> and stalls every other load on that CPU, including higher-priority ones.
>>
>> Synchronous algorithms whose requests need no extra context can use an
>> on-stack request, so decompress with one and take no zswap lock. All
>> in-tree software compressors qualify. Asynchronous algorithms, and
>> synchronous ones with request context, keep the per-CPU request and
>> mutex, which is still taken before the zsmalloc read lock.
>>
>> Reading the per-CPU context without the mutex is safe. Since
>> commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
>> pool"), it is set up before its CPU comes online and is not torn down
>> until the pool is destroyed. The codecs keep their own stream locks, and
>> crypto_acomp_decompress() rejects on-stack requests only for
>> asynchronous transforms, which never take this path.
>>
>> For software compressors this drops the heap request added by the
>> previous patch. The on-stack request and wait take 216 bytes, which
>> makes the load path about 270 bytes deeper on x86-64. Asynchronous
>> algorithms pay this too.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/zswap.c | 65 +++++++++++++++++++++++++++++++++++++-----------------
>>  1 file changed, 45 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 54187b1ef751d..7e7fb6e7ec24c 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -147,7 +147,7 @@ struct zswap_acomp_req {
>>  struct crypto_acomp_ctx {
>>         struct crypto_acomp *acomp;
>>         struct zswap_acomp_req comp;
>> -       struct zswap_acomp_req decomp;
>> +       struct zswap_acomp_req decomp;  /* unused by synchronous algorithms */
>>         u8 *buffer;
>>  };
>>
>> @@ -851,15 +851,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>>                 goto fail;
>>         }
>>
>> -       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
>> -           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
>> -               pr_err("could not alloc crypto acomp_request %s\n",
>> -                      pool->tfm_name);
>> -               goto fail;
>> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp))
>> +               goto req_fail;
>> +
>> +       /* Synchronous algorithms decompress with an on-stack request. */
>> +       if (acomp_is_async(acomp_ctx->acomp) ||
>> +           crypto_acomp_reqsize(acomp_ctx->acomp) > MAX_SYNC_COMP_REQSIZE) {
> 
> Where does the requirement on crypto_acomp_reqsize() come from? I see
> crypto_acomp_compress() and crypto_acomp_decompress() only checking
> acomp_is_async().

ACOMP_REQUEST_ON_STACK() reserves sizeof(struct acomp_req) plus
MAX_SYNC_COMP_REQSIZE, which is currently zero. A synchronous acomp
algorithm can advertise a larger request context via cra_reqsize. Checking
only acomp_is_async() would then leave that context outside the reserved
stack storage.

The core already applies the same size restriction to synchronous fallback
transforms in crypto_acomp_init_tfm(). The operation functions only reject
asynchronous stack requests; they do not validate the amount of storage
provided.

> 
> Regardless, these are crypto-specific details that shouldn't be
> checked directly by zswap. Ideally we'd have something like
> acomp_can_use_stack_req() or something.
> 

Done for v2. Added documented acomp_can_use_stack_req() in the public acomp
header. It checks both synchronous completion and request-context size;
zswap now uses that helper.


> Also, could you please CC Herbert on future iterations? I would like
> to get his eyes on any crypto-related changes if possible.

Will do! Thanks! get_maintainers.pl didnt add him.

> 
>> +               if (zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp))
>> +                       goto req_fail;
>>         }
>>
>>         return 0;
>>
>> +req_fail:
>> +       pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
>>  fail:
>>         acomp_ctx_free(acomp_ctx);
>>         return ret;
>> @@ -951,19 +956,14 @@ static bool zswap_compress(struct folio *folio, long index,
>>         return comp_ret == 0 && alloc_ret == 0;
>>  }
>>
>> -static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>> +static bool __zswap_decompress(struct zswap_entry *entry,
>> +                              struct zswap_pool *pool, struct acomp_req *req,
>> +                              struct crypto_wait *wait, struct folio *folio)
>>  {
>> -       struct zswap_pool *pool = zswap_entry_pool(entry);
>>         struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
>>         struct scatterlist output;
>> -       struct crypto_acomp_ctx *acomp_ctx;
>>         int ret = 0, dlen;
>>
>> -       if (WARN_ON_ONCE(!pool))
>> -               return false;
>> -
>> -       acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>> -       mutex_lock(&acomp_ctx->decomp.mutex);
>>         zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
>>
>>         /* zswap entries of length PAGE_SIZE are not compressed. */
>> @@ -980,15 +980,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>>         } else {
>>                 sg_init_table(&output, 1);
>>                 sg_set_folio(&output, folio, PAGE_SIZE, 0);
>> -               acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
>> -                                        entry->length, PAGE_SIZE);
>> -               ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
>> -               ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
>> -               dlen = acomp_ctx->decomp.req->dlen;
>> +               acomp_request_set_params(req, input, &output, entry->length,
>> +                                        PAGE_SIZE);
> 
> Just use a single line :)
> 
>> +               ret = crypto_acomp_decompress(req);
>> +               ret = crypto_wait_req(ret, wait);
>> +               dlen = req->dlen;
>>         }
>>
>>         zs_obj_read_sg_end(pool->zs_pool, entry->handle);
>> -       mutex_unlock(&acomp_ctx->decomp.mutex);
>>
>>         if (!ret && dlen == PAGE_SIZE)
>>                 return true;
>> @@ -1002,6 +1001,32 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>>         return false;
>>  }
>>
>> +static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>> +{
>> +       struct zswap_pool *pool = zswap_entry_pool(entry);
>> +       struct crypto_acomp_ctx *acomp_ctx;
>> +       bool ret;
>> +
>> +       if (WARN_ON_ONCE(!pool))
>> +               return false;
>> +
>> +       acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> 
> We probably want a comment here explaining the two possible paths?

Added for v2.

> 
>> +       if (!acomp_ctx->decomp.req) {
>> +               ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
>> +               DECLARE_CRYPTO_WAIT(wait);
>> +
>> +               acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +                                          crypto_req_done, &wait);
> 
> I would rather add a wrapper for this (e.g.
> zswap_set_acomp_req_callback()) to avoid the mental toil of checking
> that we are passing in the same things as zswap_cpu_comp_prepare().

Added for v2.

> 
> 
>> +               return __zswap_decompress(entry, pool, req, &wait, folio);
> 
> Hmm would it be more readable if we create a dummy zswap_acomp_req
> object here and have __zswap_decompress() take in __zswap_decompress
> instead of taking in the req and wait separately?


I would keep req and wait as separate arguments. zswap_acomp_req includes a
mutex that stack decompression never uses, and taking the address of its
wait can still reserve the entire wrapper on the stack. Removing the mutex
from that type would add more restructuring. The shared callback helper and
path comment make the setup consistent while keeping the existing stack
footprint.


> 
>> +       }
>> +
>> +       mutex_lock(&acomp_ctx->decomp.mutex);
>> +       ret = __zswap_decompress(entry, pool, acomp_ctx->decomp.req,
>> +                                &acomp_ctx->decomp.wait, folio);
>> +       mutex_unlock(&acomp_ctx->decomp.mutex);
>> +       return ret;
>> +}
>> +
>>  /*********************************
>>  * writeback code
>>  **********************************/
>> --
>> 2.53.0-Meta
>>


