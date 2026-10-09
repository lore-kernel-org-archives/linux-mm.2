Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A65ECA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A276B008A; Fri,  9 Oct 2026 11:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB796B008C; Fri,  9 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA896B0092; Fri,  9 Oct 2026 11:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 827B16B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:07:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EEBF1C3BF4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:07:23 +0000 (UTC)
X-FDA: 85303416366.07.1F7F5E2
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf26.hostedemail.com (Postfix) with ESMTP id B79DF140003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:07:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i+ZYF2zv;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791558441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWBqf6ojxCNQCKuDFh1m9VyRonME7UrxoPwKh1HJPXc=;
	b=sysRREEK61BIUM2AVsK2CF1P8M2ghHtGLc5ZnogbkiB9QwMgWa4YP3R2WyTit3ys2cdLC/
	641/eLYLZ34X96dS60PxJmnhUQ3pAYNhULZVxkzh3Axs8dCcHQt/l321u7gqkr2r9EHmmi
	oES1WfbpQkwBHZFr3lcEegWzyu7PVKE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i+ZYF2zv;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791558441;
	b=DVpq30Q529xaAheDPEbpfTUIFGLHuJjcAXYySIVXcTruRRJskYxIkbTGbJ9etDXTnhALHu
	RaZ2OZynlGnAFw5B2xrhHMezrLWAqhwKcC26qiGHCqf/sDSPJ3bqcu2QYikbaXGe6V9DlY
	DdFsff8tXZGW/BicTUcnyqyM3kpNMfE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2q4HFbJwewXeqyQtO6Fho3xQ9TR3Tl8vkll4qv6dMzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791558439; v=1; x=1792163239;
 b=i+ZYF2zvZesYiTVc9Icd8XX0d3P+C4sTkXMn9ejOK5yaeg0mupaKB3gq7xQytllhBF3JYC7Q
 QBmxnKea4rvU+9a+W1X0xAiF0Gj4RWuUOWqSNgM2ra+VxayYkesmLki2hv6dJ+0CzZh/wlzYmBn
 XAvmMo2qFNRztdcJXyCNrpZk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3c44e9004eab4323;
	Fri, 09 Oct 2026 15:07:18 +0000
X-Mizu-Trace-ID: 3c44e9004eab4323
X-Migadu-Flow: FLOW_OUT
Message-ID: <3465c889-de07-48b7-b6b4-7fc8dcac4e67@linux.dev>
Date: Fri, 9 Oct 2026 16:07:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression
 requests
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev>
 <CAO9r8zPm4B1_wtAUMeSR9PQ5ja+kJz14Ub7MCuJit_NSH2DQsQ@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zPm4B1_wtAUMeSR9PQ5ja+kJz14Ub7MCuJit_NSH2DQsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B79DF140003
X-Rspam-User: 
X-Stat-Signature: s3ah81pkmzu7oymbmwd8hjifhnkhowoj
X-HE-Tag: 1791558440-540527
X-HE-Meta: U2FsdGVkX19WJwALA+kSW8nsXxbmYaXoj47Rjzpgox1559hECbT/mmiCjZcQCjVxgZI5uJvSnO9kx6V8PmFyBEvE1wf3zK1f7j5rPegTZjQ1nrJegwPfwciV+uL6SFnv0xUIemhyg5i2H0ytDNbdN0J5ApS22beo5xwHrxyy7cbSj4QKnzEBVGpufAhJVVKi/qNegvkirAclrByx99zEIVXufrgssZObTdsgN8OPcv2GE4jK90mzZnXz9Z0aa4xoEcPqF1vRptaS5ss5clPfgsUl/4p3JT+05ox+H8EfF6n2eVmy1IaHc7UPcISOTFpCgfLN7AkGj5eRzccb3RZAloD4EpQnFNEA8Wjn3RmYrg4ZJCGV7Fuu6g7tYffMThJ/CHf4Yhe7Vb1WNJyqZx3rfcvFIbVYtuHJRW5w9mXGwYu9bciG43IgKypzJo+VDcDnv3Ap25GhBa8B3C8vFRDprruhHvQf1K0BiV7FoXVnz3dfPaa9i7IzEQNH01LT6nGj+sSqVv6f8P+/OPB4kxfFKad4TqJ72X0J9e3EKpYESKX7TIkIQhqkCT5R0vh1aJP3J50nrca1lABpnkb5m1oyWBiTjjR2LxPaSE3rd2TJnxUci7CJ96pz3YPyghrOwBII2Y5VUge8ItOvEZ/VIZ6HZJN9rz4wc4qPN1ErJ8Nx7CPTynWZls20yU64roQEwj06pOJ9xH13yM0qhTeoAsUM2CcA92ooM3m0ZyiVS4TzlBp6SuiPbUkQPuhH5VqZB5kWq0606f0Z5W/Ol1kNDP9GfDihLuxWdfIINNXsfO6dGflnpoVegZRUQJVjFG/3SNZ7j36JUtCXoz7K+oM/WGQ8ZJKCL4lLls27wQDJZwNtfIP16s9uwxSghwO3lGtKy3p9QazyfeVPJMUakV5faQsponfSPxTemsFOqcCW6UYUHJ+ylucOee5Rv1bFIeQnBZBfnxisfQWn7AYrOIw5lfp
 BgUmeQ/U
 4v5iwMk++LcxD1Syt/ifX8oDdELoGroAipQdkYloF7LxHMbYriBV53GW6iylBiVQgOKToW4XhW+kkwoiXyeQ2A/R9F9UZgYc7aeT4DSbDu8VEU1giovfWhsLqTSGIXg2jgJmfKkOBMmOqHqK0EgvylKWy9F4m4juXnk2xXiUZl8DutN1cIaPhA/YOtNVntFmIYtvmNwy/UBUqbHxdfXKnF6ONwJK/wpka7Ha5hLq4lqemL4/ODxCu++C1Z6JlMmmELMgVcEeyGMvoeERvQp2vZOonPRXsAiCN/0QnD/D5LzJZAphHVzPU/LcDpeJT8wogl5W6i910s3LjUOswywgvgzWXXHo/1pRxizue
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/2026 23:01, Yosry Ahmed wrote:
> On Mon, Oct 5, 2026 at 5:23 PM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Stores and loads serialize on the same per-CPU acomp request and mutex.
>> A low-priority store can be preempted as soon as the compressor drops
>> its stream lock, while it still holds the mutex. A higher-priority load
>> on that CPU then waits until the store runs again, which can take a
>> long time when other tasks are runnable.
>>
>> Give compression and decompression their own request, completion wait
>> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
>> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
>> compression. The two requests can share the per-CPU transform: no
>> in-tree implementation modifies transform state while (de)compressing,
>> and shared codec state has its own locking.


Hello Yosry!

Thanks for the reviews!

> 
> I am a bit uncomfortable with this. If future changes modify the
> transform state while (de)compressing, it may result in nasty bugs.

Independent acomp requests can share a transform. UBIFS already uses its
shared compr->cc for compression and decompression without caller
serialization. IPComp also submits per-packet requests on a shared
transform, and EROFS allows concurrent decompression on one transform.

Drivers synchronize their shared state internally. For example, HiSilicon
protects its transform-owned request bitmap with req_lock. Unsynchronized
shared state would break those existing callers too. Separate compression
and decompression transforms would still leave concurrent stack
decompressions sharing a transform.


> 
> As for the buffer, I would also prefer some protection, but I feel
> less strongly about this. For example, we can put it inside
> zswap_acomp_req and not initialize it for the decompression request.
> Alternatively, we can have an intermediary struct that contains
> zswap_acomp_req + buffer, and use that for the compression request.


Done for next revision. Added zswap_comp_ctx containing the compression
request and output buffer. Allocation, use and cleanup now go through that
context. The compression mutex protects the buffer until zs_obj_write()
finishes, and decompression has no buffer member.

> 
>> Loads can still wait for
>> each other on the decompression mutex, and stores still serialize on
>> the compression mutex.
>>
>> This follows the proposal from Sergey Senozhatsky for the same split
>> for zram [1].
>>
>> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/zswap.c | 89 +++++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 52 insertions(+), 37 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index ae19e301fced7..54187b1ef751d 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -137,14 +137,20 @@ bool zswap_never_enabled(void)
>>  * data structures
>>  **********************************/
>>
>> -struct crypto_acomp_ctx {
>> -       struct crypto_acomp *acomp;
>> +struct zswap_acomp_req {
>>         struct acomp_req *req;
>>         struct crypto_wait wait;
>> -       u8 *buffer;
>>         struct mutex mutex;
>>  };
>>
>> +/* Separate requests, so that decompression does not wait for compression. */
>> +struct crypto_acomp_ctx {
>> +       struct crypto_acomp *acomp;
>> +       struct zswap_acomp_req comp;
>> +       struct zswap_acomp_req decomp;
>> +       u8 *buffer;
>> +};
>> +
>>  /*
>>   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
>>   * The only case where lru_lock is not acquired while holding tree.lock is
>> @@ -270,14 +276,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
>>         if (!acomp_ctx)
>>                 return;
>>
>> -       /*
>> -        * If there was an error in allocating @acomp_ctx->req, it
>> -        * would be set to NULL.
>> -        */
>> -       if (acomp_ctx->req)
>> -               acomp_request_free(acomp_ctx->req);
>> -
>> -       acomp_ctx->req = NULL;
>> +       acomp_request_free(acomp_ctx->comp.req);
>> +       acomp_ctx->comp.req = NULL;
>> +       acomp_request_free(acomp_ctx->decomp.req);
>> +       acomp_ctx->decomp.req = NULL;
>>
>>         /*
>>          * We have to handle both cases here: an error pointer return from
>> @@ -796,6 +798,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
>>  /*********************************
>>  * compressed storage functions
>>  **********************************/
>> +static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
>> +                               struct crypto_acomp *acomp)
>> +{
>> +       /* acomp_request_alloc() returns NULL in case of an error. */
>> +       areq->req = acomp_request_alloc(acomp);
>> +       if (!areq->req)
>> +               return -ENOMEM;
>> +
>> +       crypto_init_wait(&areq->wait);
>> +
>> +       /*
>> +        * if the backend of acomp is async zip, crypto_req_done() will wakeup
>> +        * crypto_wait_req(); if the backend of acomp is scomp, the callback
>> +        * won't be called, crypto_wait_req() will return without blocking.
>> +        */
>> +       acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +                                  crypto_req_done, &areq->wait);
>> +
>> +       mutex_init(&areq->mutex);
>> +       return 0;
>> +}
>> +
>>  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>>  {
>>         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>> @@ -827,25 +851,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>>                 goto fail;
>>         }
>>
>> -       /* acomp_request_alloc() returns NULL in case of an error. */
>> -       acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
>> -       if (!acomp_ctx->req) {
>> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
>> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
>>                 pr_err("could not alloc crypto acomp_request %s\n",
>>                        pool->tfm_name);
>>                 goto fail;
>>         }
>>
>> -       crypto_init_wait(&acomp_ctx->wait);
>> -
>> -       /*
>> -        * if the backend of acomp is async zip, crypto_req_done() will wakeup
>> -        * crypto_wait_req(); if the backend of acomp is scomp, the callback
>> -        * won't be called, crypto_wait_req() will return without blocking.
>> -        */
>> -       acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> -                                  crypto_req_done, &acomp_ctx->wait);
>> -
>> -       mutex_init(&acomp_ctx->mutex);
>>         return 0;
>>
>>  fail:
>> @@ -866,14 +878,15 @@ static bool zswap_compress(struct folio *folio, long index,
>>         bool mapped = false;
>>
>>         acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>> -       mutex_lock(&acomp_ctx->mutex);
>> +       mutex_lock(&acomp_ctx->comp.mutex);
>>
>>         dst = acomp_ctx->buffer;
>>         sg_init_table(&input, 1);
>>         sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
>>
>>         sg_init_one(&output, dst, PAGE_SIZE);
>> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
>> +       acomp_request_set_params(acomp_ctx->comp.req, &input, &output,
>> +                                PAGE_SIZE, dlen);
>>
>>         /*
>>          * it maybe looks a little bit silly that we send an asynchronous request,
>> @@ -885,10 +898,12 @@ static bool zswap_compress(struct folio *folio, long index,
>>          * existing method to send the second page before the first page is done
>>          * in one thread doing zswap.
>>          * but in different threads running on different cpu, we have different
>> -        * acomp instance, so multiple threads can do (de)compression in parallel.
>> +        * acomp instance, and compression and decompression use separate
>> +        * requests, so multiple threads can do (de)compression in parallel.
>>          */
>> -       comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
>> -       dlen = acomp_ctx->req->dlen;
>> +       comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->comp.req),
>> +                                  &acomp_ctx->comp.wait);
>> +       dlen = acomp_ctx->comp.req->dlen;
>>
>>         /*
>>          * If a page cannot be compressed into a size smaller than PAGE_SIZE,
>> @@ -932,7 +947,7 @@ static bool zswap_compress(struct folio *folio, long index,
>>         else if (alloc_ret)
>>                 zswap_reject_alloc_fail++;
>>
>> -       mutex_unlock(&acomp_ctx->mutex);
>> +       mutex_unlock(&acomp_ctx->comp.mutex);
>>         return comp_ret == 0 && alloc_ret == 0;
>>  }
>>
>> @@ -948,7 +963,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>>                 return false;
>>
>>         acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>> -       mutex_lock(&acomp_ctx->mutex);
>> +       mutex_lock(&acomp_ctx->decomp.mutex);
>>         zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
>>
>>         /* zswap entries of length PAGE_SIZE are not compressed. */
>> @@ -965,15 +980,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>>         } else {
>>                 sg_init_table(&output, 1);
>>                 sg_set_folio(&output, folio, PAGE_SIZE, 0);
>> -               acomp_request_set_params(acomp_ctx->req, input, &output,
>> +               acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
>>                                          entry->length, PAGE_SIZE);
>> -               ret = crypto_acomp_decompress(acomp_ctx->req);
>> -               ret = crypto_wait_req(ret, &acomp_ctx->wait);
>> -               dlen = acomp_ctx->req->dlen;
>> +               ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
>> +               ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
>> +               dlen = acomp_ctx->decomp.req->dlen;
>>         }
>>
>>         zs_obj_read_sg_end(pool->zs_pool, entry->handle);
>> -       mutex_unlock(&acomp_ctx->mutex);
>> +       mutex_unlock(&acomp_ctx->decomp.mutex);
>>
>>         if (!ret && dlen == PAGE_SIZE)
>>                 return true;
>> --
>> 2.53.0-Meta
>>


