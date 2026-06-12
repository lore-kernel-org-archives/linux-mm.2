Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C034FCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 13:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D026B0005; Fri, 12 Jun 2026 09:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064B96B0088; Fri, 12 Jun 2026 09:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC0A6B008C; Fri, 12 Jun 2026 09:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB6BB6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:00:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71D59120860
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:00:20 +0000 (UTC)
X-FDA: 84871269000.27.2002243
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5F57C2000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:00:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDzLj9Td;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781269218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5cKrQ8XoilTd3EvksxiyBDmUV+Zq1bN2ucdCZNbT3k=;
	b=YLLsfbWYyorKT7t98Y4S9z0xM4ir3lhO0CWIQN7K/gefFzPqAk6pAPZu1yQLhSNFvcKpqB
	oaoUV5zfT+3TmkRvKwTP3JgATdV9Frx3ze/SWwpxbiEg0JmX+pEXGQ2d/rEiJH1hImYiKZ
	F5/7QV40ZTWDev0aOwhDxrb8xOVSIic=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDzLj9Td;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781269218;
	b=On6Rk/A8IBZnrijEIKfdrOt2J0m+JUCBw0pl+4CHBR6Apfg8qp6VuDXmoo6GKUTeHjXeAa
	VCrRAEQcCBNd5n5r0npZdQVh2PARl9wrj3fme2FvVKG+iNbq6l338xwpllE+eqNyFir1Pd
	Az2woyJJd7YnwcL+CgkNa7UYxe7zQPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53F6343C7E;
	Fri, 12 Jun 2026 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C131F000E9;
	Fri, 12 Jun 2026 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781269217;
	bh=I5cKrQ8XoilTd3EvksxiyBDmUV+Zq1bN2ucdCZNbT3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NDzLj9TdTc+gapbavhk1TKOehUjch5DVPUrGHb7Tu7eCVNLbHumrh8eo3OLab5JIX
	 TETnwWBlI5TJGiIYt5gk9WamVgWTEUtq5xUvonfwtQnkEm2e2Hvk3xtN9cAQJEV82r
	 Lh13a/MX0aj9JB6igGczV/ws8g+a7QW99r37dKKqNHsMP2bGNRHa5PbbUq6SmC2EqX
	 3CXR8eE3OCgu4rebP39sekUok0NsAPXD1O3bySy+Nq3TsO5pTfQLKgL3aBk2GGvnZU
	 pMcMqq6cvDeudlZBwCeQGiad9m1FMmrhhrRd7eO269xRDqTNn5pAdS9ohq5vsiO1pd
	 yeE9WuiQ5haLA==
Message-ID: <eb6e6133-8df8-472d-860f-c54b520ee3b9@kernel.org>
Date: Fri, 12 Jun 2026 15:00:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/16] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
Content-Language: en-US
To: hu.shengming@zte.com.cn
Cc: harry@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn,
 cai.qu@zte.com.cn
References: <20260612205230395zeZ-tyvcj3PnuOeD0ppp3@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260612205230395zeZ-tyvcj3PnuOeD0ppp3@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F57C2000D
X-Stat-Signature: m7iz8iw5xfr1wsyok8snocrjr38readu
X-Rspam-User: 
X-HE-Tag: 1781269218-16875
X-HE-Meta: U2FsdGVkX1/h4y5Q8ZvW276/pBbH2DueV9EZHbEOGLSGoceA0a1Jj2m2FhgEehfLl1Q7szYZSW+SykZeXK/9mgsVyrCXJIklCqvb7/DCH5xGThHov4aooYgH0jo68B2OQRm8xadsCcU92ZLrX6dP+t4E9xGfS7wanIp65ErrU02xdgz0dagq1dc3w1IFBeBjB3IamkMbibUo/vI7WePjapCX4T3LbO+ATTOIEyQC3PmSzw5Iyy1rluaCBZsPjakYGje2/IygSaXafwMxCINCQ0QHVnJAR/YRGZmGDD8u7Z3ki3sPTmsxbYNngyJ47jCtR/WpdCJXgV9QElDW8zV16vHr4R6XHIiFRlryyqy/M5WsGEqmmiV1QTqkrU7rvHsErOx8kq/l4CRDl+NGnDj+Guqr5qWH+TtxKuRcWo/j8hPDFTmNJiWttrGjTc6UkFJWLMASRJdpDfonPOwRDsD/WSBRlKGVnPyCKW/swe4FEurSJgj+Br35fZl27BoN0/BGWr8FfsvZdgTMA5bgbdVatnb/2iOsrJpW7mSBTX4FUhd1H6XrsL8QFrFXeUNbjTHMSny0n83dzDTWcCyZGQJ2UHJvsOWxCSZqfe1S+Ox9jwRlKk8O9o0UgZaJ55fVG11JUIb6l1V9d9TO9z9rOB2xtQkKGSN0bKz/CDWG1Zt7QCIkBSqctw7/sCmMjkGi5RcVI5nWN1tstbwk11RRATWf02MsEpejijLykYVMcTrnkL2zk0UgSwQX+DNRkKJhiwHqe6RR1q6qGx7d6IMwW68m+CZ8xdPk2myLVJbPddzjA8Mznm+z6bppNdjfmBU4ICmfsMBTg01xTROf6WD/qGAa98N3W8avjpIYlcACDvzEK2uRVhEJCP5TRQvFSX7J/DvcFKzbg5Xx/5ZOY6oJIHHAddVHVyXY48dR+ncEki56lSVcwhI2W5iqRjDf5Czq3+uNJKklFqP0N+QabWYU/OE
 KNoSBJJw
 7GDOQlvUMBZDqJpoAf14xxWbuES9NT1Ky7I5VSvv1kYklyWa5BBDCr/eif6Qeb0Q6HkxR+6Y1URM2FHtbspABBDMlrcrBy55Oau3V6I9ZWse0tnVGV2mXBUJLZIFS+f3evl/3QL2ZChuK9Q/AUI/vGoVyUyf1XM2YT+0DWTdz4jOqdT3xgtQv34/PUYIXRIS8oSRmWMNJb0VLkgochh7Pp//G970rGRLYlcdWN/DkuGfba9TfX4UOOa+Sce7zkY7nbMdz4mUqZrwRROBca6vsexZ2IoU20ClAfGQUmtSg7yTgAeVIvpaLXzhXc6ssgPGZ00kA4H7zUH3a8t+6keZu3EUuC/x7uTO/DMMg1JKLwzdLZ+AcAimcr5G1ZMFq/ytx7vLgR1/RL0KRsu1S6IcCJdaq0Zb82kJZGp2oTjwJx2SmsjlbfScVdOzP9vQ2kK1xeFDC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 14:52, hu.shengming@zte.com.cn wrote:
> Vlastimil Babka (SUSE) wrote:
>> The two flags are added internally so there's no point for warning if
>> they are passed by the caller as well, so allow them. This will allow
>> simplifying obj_ext allocation under kmalloc_nolock().
>> 
>> Also it's not necessary to have the extra alloc_gfp variable for adding
>> the two flags. The original gfp_flags parameter is not used anywhere
>> except for the warning. So remove alloc_gfp and directly modify and use
>> gfp_flags everywhere.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  include/linux/slab.h |  3 ++-
>>  mm/slub.c            | 19 ++++++++++---------
>>  2 files changed, 12 insertions(+), 10 deletions(-)
>> 
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index ce1c867dc0ba..b955f3cbb732 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -1040,7 +1040,8 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>>   * kmalloc_nolock - Allocate an object of given size from any context.
>>   * @size: size to allocate
>>   * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
>> - * allowed.
>> + * allowed. Also __GFP_NOWARN and __GFP_NOMEMALLOC are allowed but added
>> + * internally thus not necessary.
>>   * @node: node number of the target node.
>>   *
>>   * Return: pointer to the new object or NULL in case of error.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 6845e15c148a..847cad5203b2 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5388,7 +5388,6 @@ EXPORT_SYMBOL(__kmalloc_noprof);
>>  
>>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
>>  {
>> -	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>>  	size_t orig_size = size;
>>  	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
>>  	struct kmem_cache *s;
>> @@ -5396,7 +5395,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
>>  	void *ret;
>>  
>>  	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>> -				      __GFP_NO_OBJ_EXT));
>> +			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
>> +
>> +	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
>>  
> 
> Hi Vlastimil,
> 
> While reviewing your patch, I spotted a potential GFP flag mismatch along the kmalloc_flags()
> -> __kmalloc_nolock_noprof() call path. I cloned the slab/for-next branch to verify this and
> successfully triggered a VM_WARN_ON_ONCE() in the __kmalloc_nolock_noprof() path.
> 
> Here is the observed trace:
> 
> [   57.283791] ------------[ cut here ]------------
> [   57.284226] WARNING: mm/slub.c:5407 at __kmalloc_nolock_noprof+0x3ec/0x450, CPU#6: insmod/379
> [   57.285060] Modules linked in: slub_nolock(O+)
> [   57.285494] CPU: 6 UID: 0 PID: 379 Comm: insmod Tainted: G           O        7.1.0-rc3-00036-g5ade53586fae-dirty #5 PREEMPT(lazy) 
> [   57.286608] Tainted: [O]=OOT_MODULE
> [   57.286941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> [   57.288018] RIP: 0010:__kmalloc_nolock_noprof+0x3ec/0x450
> [   57.288543] Code: 01 00 8b 4c 24 04 41 89 c2 e9 dd fc ff ff b8 10 00 00 00 e9 f9 fd ff ff 90 0f 0b 90 f7 04 24 ff de b7 ff 0f 84 54
> [   57.290252] RSP: 0018:ffffa82840c73b68 EFLAGS: 00010206
> [   57.290752] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffa82840c73bc8
> [   57.291428] RDX: 0000000000000000 RSI: 00000000002c2100 RDI: 0000000000000100
> [   57.292124] RBP: 0000000000000000 R08: ffffffffb853c968 R09: 0000000000009ffb
> [   57.292821] R10: 00000000000001d7 R11: ffffffffb850c980 R12: 00000000002c2100
> [   57.293485] R13: 0000000000000000 R14: ffffa82840c73bc8 R15: 0000000000000003
> [   57.294159] FS:  0000000006fa8880(0000) GS:ffff8f4ef9d5a000(0000) knlGS:0000000000000000
> [   57.294914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   57.295464] CR2: 0000000006fac528 CR3: 000000003f9b6003 CR4: 0000000000770ef0
> [   57.296124] PKRU: 55555554
> [   57.296443] Call Trace:
> [   57.296702]  <TASK>
> [   57.296914]  ? vprintk_emit+0x22e/0x280
> [   57.297295]  __kmalloc_flags_noprof+0x216/0x530
> [   57.297735]  ? _printk+0x56/0x70
> [   57.298053]  ? alloc_slab_obj_exts+0x89/0x1e0
> [   57.298474]  alloc_slab_obj_exts+0x89/0x1e0
> [   57.298876]  new_slab+0x2bc/0x660
> [   57.299200]  ___slab_alloc+0x2ae/0x660
> [   57.299603]  __kmalloc_nolock_noprof+0x151/0x450
> [   57.300050]  _kmalloc_nolock_noprof+0x47/0x70
> [   57.300490]  ? slub_nolock_init+0x127/0xff0 [slub_nolock]
> [   57.301013]  slub_nolock_init+0x127/0xff0 [slub_nolock]
> [   57.301566]  ? __pfx_slub_nolock_init+0x10/0x10 [slub_nolock]
> [   57.302197]  do_one_initcall+0x44/0x220
> [   57.302598]  ? do_init_module+0x1e/0x240
> [   57.302990]  do_init_module+0x5f/0x240
> [   57.303357]  __do_sys_init_module+0x162/0x190
> [   57.303783]  do_syscall_64+0xf7/0x550
> [   57.304159]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   57.304648] RIP: 0033:0x4b8839
> [   57.304954] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 40
> [   57.306676] RSP: 002b:00007ffea38fdce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
> [   57.307376] RAX: ffffffffffffffda RBX: 00007ffea38fe080 RCX: 00000000004b8839
> [   57.308044] RDX: 000000000062d4b5 RSI: 0000000000002790 RDI: 0000000006fa9d20
> [   57.308710] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000002790
> [   57.309366] R10: 0000000006fa9cc0 R11: 0000000000000246 R12: 00007ffea38fe088
> [   57.310040] R13: 000000000062d4b5 R14: 0000000000000000 R15: 0000000000000000
> [   57.310737]  </TASK>
> [   57.310963] ---[ end trace 0000000000000000 ]---
> 
> With "# CONFIG_KMALLOC_PARTITION_CACHES is not set":
> RSI: 00000000002c2100 -> gfp_flags
> 
> Decoding the GFP bits:
> 
>   0x00000100 = __GFP_ZERO
>   0x00002000 = __GFP_NOWARN
>   0x00080000 = __GFP_NOMEMALLOC
>   0x00040000 = __GFP_COMP
>   0x00200000 = __GFP_THISNODE
> 
> The root cause:
> 
> Previously, the obj_ext allocation path(alloc_slab_obj_exts()) called kmalloc_nolock() with a
> fixed set of flags(__GFP_ZERO | __GFP_NO_OBJ_EXT). After switching to kmalloc_flags(), the
> full GFP mask from the upper allocation path propagates through the call chain.
> 
> In detail, ___slab_alloc() may append __GFP_THISNODE, and allocate_slab() adds __GFP_COMP
> via s->allocflags. Both flags flow down unchanged into __kmalloc_nolock_noprof().
> 
> This patch only permits four flags (__GFP_ACCOUNT, __GFP_ZERO, __GFP_NOWARN and __GFP_NOMEMALLOC).
> Since neither __GFP_THISNODE nor __GFP_COMP is in the allowed set, the warning is triggered.
> 
> Would the following fix be acceptable?
> 
>     +#define KMALLOC_NOLOCK_ALLOWED_GFP \
>     +       (__GFP_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_NOMEMALLOC)
>     +
>     /*
>     * The only version of kmalloc_node() that takes alloc_flags and thus can
>     * determine on its own whether to handle the allocation via kmalloc_nolock() or
>     @@ -5548,6 +5564,7 @@ void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
>                     return __do_kmalloc_node(size, NULL, flags, node,
>                                     PASS_TOKEN_PARAM(token), &ac);
>             } else {
>     +               flags &= KMALLOC_NOLOCK_ALLOWED_GFP;
>                     return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
>                                                 flags, node, &ac);
>             }

Thanks, Hao Li pointed out __GFP_THISNODE and I filtered it from nested
allocations like this:
https://lore.kernel.org/all/49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org/
It makes sense to filter out __GFP_COMP too as that's a page allocator flag
and not useful for (nested) kmalloc allocations, so I'll add that



