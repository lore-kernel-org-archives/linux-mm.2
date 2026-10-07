Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1833CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206D76B0096; Wed,  7 Oct 2026 07:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6F06B0098; Wed,  7 Oct 2026 07:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD436B0099; Wed,  7 Oct 2026 07:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4E886B0096
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:02:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79403401A8
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:02:38 +0000 (UTC)
X-FDA: 85295541996.04.9D88571
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34AC610000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:02:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gqULa/IK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791370956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9rRkiPjOI8cUrtm1C2zqE2rRjFQhzcbZqdoL9SHgZA=;
	b=szcGW3HzhqEIwj2Ta7uX+5b+hQjoJ/KIkBiH/gzXjoIyjD0xrzY8evsMRI7qwgmrrbYhCf
	X9ZxN+3+U8S3YUgRbRFciKRTFcosoI4Ljb1FyYSDWS7LPNVipsN9xrSy907VYV+8pO2EoK
	pPNEHLJQqwgiVT+1HJoJKMAXeA3S3pU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gqULa/IK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791370956;
	b=wSXJ11dDn/28bVLZnraRA1vUjWLKtRNcsvgukUbKk4CqIR/K2aqYk5j3ZgvA+0m3VO7uuf
	KzKKVkcrgSsJ8fUvPnOd2fhkvEuYlu3hpn49FgUcfeX+lgrb3yMbeNwGdLX5xYhcHTtMk5
	R7M/n6TAWlczh1MjYp3c8u3NYxskQ8I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kbp4UUDGxBCJYQv99MekkXfWeMMWcYb62G5irxFuKAk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791370954; v=1; x=1791975754;
 b=gqULa/IKXohH3ONV3vkGKAYyCyHyc+FdbYqhucikc7V8Rl8xOAs3ebxY8uMjy9B+XsfLPE31
 PRRCXdTXIfwjJgPKyeMPDdkYIpmUu0kmbulnqqnAFb01rzGcKnA+ZmUmW9SCT2VH/pHyqBV5k6s
 ZI3gFFmO/YCoOwYjqpEMkIhA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fcf850624a10237b;
	Wed, 07 Oct 2026 11:02:34 +0000
X-Mizu-Trace-ID: fcf850624a10237b
X-Migadu-Flow: FLOW_OUT
Message-ID: <65503b6e-5038-4709-8f16-cd7922286963@linux.dev>
Date: Wed, 7 Oct 2026 13:02:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression
 requests
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, terrelln@fb.com, yosry@kernel.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev>
 <CAKEwX=O=QNWUCTn9kcCwu9V3pTrSwTj8SMCMS6Z-8fwhGjrkdA@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAKEwX=O=QNWUCTn9kcCwu9V3pTrSwTj8SMCMS6Z-8fwhGjrkdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34AC610000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: mqqmmuzuc8dmck9ippci1zuyrusfz4z4
X-HE-Tag: 1791370955-790792
X-HE-Meta: U2FsdGVkX18TeD+FOFTKyrjXZNz0fhyOz5P2Ps7QcgpK+YQyXHFHY6O5iItkdENVs2VBxNBDrMVRxz+nMR6mCqntTRMCXoVLcbuQRdlMAcQpmEyS9RjVgpj7QTplHtms2Wi0dmhsu/7O9lCzNJlCzJWT/sZnZLDorAn6DUPJXUPAnvskVq15by2+xayWGMNt/r0XgRlGOm6SLG3iFOnnnxGDUsRYWhSxeSKzn+9P+nTuxgxqvQ9+3PMe2CUcI1zyzCZ7eAYC55E6arHrP5ebvGVF0s7kT7UujmIn4CgqV7Waq0y4mJ+a3KWbHMunj4vOpCbXYofObRULtVmBMQu0gY+tj1iFdiPeJ1yw7OBFMi9Q1dzvzHgWhgLbj4FnEZFMqI/c4JgMRQxUOeHNb5SeShJICVbyoPwxEwu90x/A1CCexKRGrag/IUvIehq8MS4Sya3iOH1IJMeU1nRCY3g+y5TSuI8DJ/TCvKGDmrcWOHg6a0xsSl+14/p/cZK3SA8S7kBfOwY9bgtcWPsyZjVAUnE69vCh3i6+730Bndb2i5GJ66qsUvr76N4smpda73ElIATM2y44qtBUjwX9NXM5TzjtOz1LKQ5CjF0SIpfg3tDXpZH+nOsEXeN4av+k+cJrXNxeYruVTDxyYDhDoPHuv/F9kOWjuX51GXSUKyXCkokXylkOv3CJlfpALRLmymrZNxpv2zNUUY0Puqf/w3s7l6JvHv2QcD1hXD+DoJtuYkpq3kmgQM2G3DP4P5FH2d7N7el8dLIgIiEPfOLstrkClQraigY/LNv/Ptv/VM92Og0jCtdjeYzptAtDCIkFcbWO3Z6h/NyI9/y6dfvBr30NIS+eCyJqy4xMknkK/GUvnRPxl9jPbK10zChYHzY9SoLAulZf6s6EToMpGItOGCec7ir81Do4YdAEEqDJFyzbaMwqPkcyS6KQWPW9V6OivpX5VfpFBrBn68/YVEOn/wV
 S/S+tXaD
 WtEsqdxcxb94Uw+EK1/dTLhcS8OkBEiIqC6fjpmjdHe085ptAKf0QyNYc9s8km83MaXv1uw0v1T4id7yTYCgsVLAbM42nAAyWapXuMwCIuZ5wd3ETfr97fbaxENDne0wtanFHd3DyaU12jBtvjFa6H7t1b9Bs6EaDClcoT7ybDWqcxBwY1eHABBdH7gbbTdjOUuTH6jR+XjvY3jcsktJqhx587WDc8Aa293us4LnfeL4gW7TQHhM5nvBjXhLuhaWv/68fxUdnYpzayJg6cD1Zy1h7vt+WsnPiBfyFUd3/jtbaf/mGaiwmnNK5pjOmuAWTCA6gQe3ANKkJWJLQeDlEnycmVRG0fsttGRoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/10/2026 11:47, Nhat Pham wrote:
> On Tue, Oct 6, 2026 at 2:23 AM Usama Arif <usama.arif@linux.dev> wrote:
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
>> and shared codec state has its own locking. Loads can still wait for
>> each other on the decompression mutex, and stores still serialize on
>> the compression mutex.
>>
>> This follows the proposal from Sergey Senozhatsky for the same split
>> for zram [1].
> 
> Thanks, zram peeps :P
> 
>>
>> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Code mostly LGTM. Just one question:
> 
> [...]
> 
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
> 
> Hmm do we not have to null check here anymore? Does
> acomp_request_free() handle NULL itself too?

Yes, since v6.15 it starts with "if (!req || ...) return;", so the
check in acomp_ctx_free() was redundant.


> 
> For instance, taking the code blob below:
> 
>> -       /* acomp_request_alloc() returns NULL in case of an error. */
>> -       acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
>> -       if (!acomp_ctx->req) {
>> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
>> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
>>                 pr_err("could not alloc crypto acomp_request %s\n",
>>                        pool->tfm_name);
> 
> Here, we can success with the comp's req but fail with the decomp's req, right?

Right. decomp.req is then NULL, as zswap_acomp_req_init() stores what
acomp_request_alloc() returned, and acomp_ctx_free() frees comp.req
and skips decomp.req. After patch 2, decomp.req also stays NULL for
synchronous algorithms, since the per-CPU contexts are zeroed, and
acomp_ctx_free() relies on the same NULL handling.



