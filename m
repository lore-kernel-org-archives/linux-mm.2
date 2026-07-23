Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E769C4453D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2456B0092; Wed, 22 Jul 2026 22:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9416B0093; Wed, 22 Jul 2026 22:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2576B0096; Wed, 22 Jul 2026 22:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC256B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:26:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83E97140358
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:58 +0000 (UTC)
X-FDA: 85018453716.19.10B2F9D
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf16.hostedemail.com (Postfix) with ESMTP id E171A180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:26:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W+yfMqsu;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784773616;
	b=hBFAhFoJ556dBUtXqkdsGVzYfMuCu3BnG9x/a/LoE7i88XjrpfTcMQ1D3urHxWKUtbqpZh
	13/4soUcZ/XpiCeQfOHT0yEMA/paGF03XotTTPDAhRwrc6M0OG2WuzOX3N+2EcttNNwoCg
	nxXFzuaO/C32awOMXO/gSWvlRk/y6pk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=W+yfMqsu;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784773616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLbZtzCxthaNWVF5N0W4ct6DQK9Fm8OY2JCZO3GLGxo=;
	b=l5uLp2E16tZ2ug8bYDZ+iZ93siZ7L3YHmZ9AOb9Jk/nidmbNI3J1mWCDfplzPyqNkpK2zU
	ivOjnD+K56vyhSPx5wFx75mm3iJuO2+o0dRBceH0NLp2dzC3OAmfg4ThvHaMrmhUDNapk3
	a3FsymQ78YSdJAaOjrBuMZJoRLuAdag=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784773612; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jLbZtzCxthaNWVF5N0W4ct6DQK9Fm8OY2JCZO3GLGxo=;
	b=W+yfMqsuVrYlmKbMoN/9ks9NS8loSTnpP815XKJHRWV2w7hTJWuAsMu65iVkARgahR3Drx8zw814cI+FH4T8kwqcH2cYgHm9qWDnwVMQcZzV7cGlr1E/I1p8LDbydtnLM3h4Szs8+7DqOI6e7QZzvxc1e876+S26uEfX/2NTrko=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X7eY5qR_1784773606;
Received: from 30.15.245.94(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7eY5qR_1784773606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 10:26:50 +0800
Message-ID: <a786425e-be9b-4a06-9f9b-535419fd0c87@linux.alibaba.com>
Date: Thu, 23 Jul 2026 10:26:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: mglru: promote mapped executable folios after
 first usage
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mhocko@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
 <f57d94b1d85bb3d620d89bb739128f0d929bf9c6.1784509721.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4zBpd2o0chB84P=hNYAeM34E6xiFYMb89nrq5epr2GbVA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zBpd2o0chB84P=hNYAeM34E6xiFYMb89nrq5epr2GbVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 55pcegcupnhykp46ymk5583k7aq95sh6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E171A180004
X-Rspam-User: 
X-HE-Tag: 1784773614-995311
X-HE-Meta: U2FsdGVkX1+WE1eAKaqX/K2nvuW2eQjgVXGoKrgzHQtcf990B1LmO7LIi/hkmCkMnW2j3CLP7zSevJqX0B/txUcBeNlq94PX45wjcPIcbkS/B/iH9ejrv9WalnJaEL9/h/D2yh+OO3kMvFd5TRYtaf7nc/q9vUBz1lv04+OIQ1aeCy2Uu3L9os2/QcKN+uAyByP6uxQc+i2BUWSvajpvGnFwdbjSBkymtM0UUd0wnW2HLhVB5Z/YmIc2aV+LEv2N/a0GWEI/Im1b2+exF+NXSGQVYqIg7RSeFdomVAVPDmhGeLwYOd49qKmfLNQBA3lkxPh4uIIPdBb26EdEq2Y6US/rRGlixww25ommW7MHFCGlTmobaXM+55dtB0jIg30I4m1/eau0ovU1klbkkBH581+quFuDdjL2RtB4X+rUDLokqeZLcHpG2CCQwsasn7uCKT+s6AiEaJCB8gvBSbMquwAgChCGpNA3XSQqliEfIgq2L5/FrXb3RvGPgoc13WMxX0i4GcWY586rEAatR61RneZ2lFNs6slny3Dr14YDh3DSAmfdgp/GSumNTWUwYjastmKH2OcSNgSUxF0zGsg8+Po2U2c3L5o5o6x2PNXdVLkbWlGGma7Vk4J8WpGThy6BV3fFJi9sVuO1dmrhndlgaTnWTcIGJoytBvUV8+ynsjmmfxOLmcB5RKzAJxW3SdcKIPKUGzKSBskF5pVem1d8THDS6NYGg17WquDXeSBvxA9S52XlduBEcFQkOveMOpoUlglVEFp+Ao+TIA+GUusbj2ZP8jGeRd41vORnf+s9Xa18x63bCyj2Yk6fRE1q9UPVYeYZuIgZWLYs6FRpP1I1PabZ/WhDzuKCSM7XvJiv2iV3b3iDWqM70pVLxawySk4KK1BHQouEdy04WDDEH4WM9j0F42/6nuRF9WxrC2kzXp6tpxAogU5+h7ztu9Mgfn8ikd+PKhukRqE2eZm9R4v
 p595CDRV
 D9RAK8zWZk8/gCkWHxp4t9aEhS+lXnMi5Suqcb6UuxAF1mXZdWc9hwMtTIp3ToP0s2rKFqah7ELig8tdUZRb50kXZzpT9tp19kerpCX6I3aBBzSSU8pgici/Up/mCbJB0Meot02Xqa7z8jg5tUqTJ3Wt9QXpnd7zbrsWLvzvVdeFwiabFQ/aRm/16uMB0gp+GSgH4v8CxsP4Z9WI0VAMdsROEvK45FuM/gJykFF6kgmqjKr7tOdAXeB0h/VroOiaWrZoJrwRgY19+Y/XdkcaRpggFZOb0cz3szIjIFW/LaQnB1SOrO+jJv/7UCCstX2ObVSNuN1QhIIrI3rcf05py1LrAfHlULg/PqLABUsoR7oM95x1LOqK/ON2j8bNOysLBFWNeOmMC75hy7IeEeGoayO4uaW74Elann84tW8r9qDxBE9vHaVq/tyXi1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/26 4:31 PM, Barry Song wrote:
> On Mon, Jul 20, 2026 at 7:12 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Classical LRU protects mapped executable file folios through commit
>> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
>> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
>> after first usage"), giving executable code a better chance to stay in
>> memory, avoiding IO thrashing and improving workload performance.
>>
>> However, MGLRU's protection of mapped executable file folios is less
>> reliable. Although shrink_folio_list() checks references, the access flag
>> of mapped executable file folios may have already been checked and
>> cleared by lru_gen_look_around() or walk_mm(). Additionally,
>> folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
>> flag for mapped executable file folios, which causes shrink_folio_list()
>> to ignore the first usage of these mapped executable file folios and
>> reclaim them easily.
>>
>> Follow the classical LRU's logic, promoting mapped executable file folios
>> after their first usage in folio_update_gen() and lru_gen_set_refs(),
>> giving executable code a better chance to stay in memory.
>>
>> On my 32-core Arm machine, with the memcg limit set to 2G, running
>> 'make -j32' to build kernel showed some improvement in sys time.
>>
>> base                    patched
>> 9248.543s               7861.579s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
>> ---
>>   mm/vmscan.c | 43 +++++++++++++++++++++++++++----------------
>>   1 file changed, 27 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 8f0c31a4848e..b1ec65fb8947 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -841,10 +841,16 @@ enum folio_references {
>>    * with PG_active set. In contrast, the aging (page table walk) path uses
>>    * folio_update_gen().
>>    */
>> -static bool lru_gen_set_refs(struct folio *folio)
>> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>>   {
>>          /* see the comment on LRU_REFS_FLAGS */
>>          if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>> +               /* Activate file-backed executable folios after first usage. */
>> +               if (is_exec_file_folio(folio, vma_flags)) {
>> +                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
>> +                       return true;
>> +               }
>> +
> 
> Hi Baolin,
> 
> Do you see any performance difference if you change the code to
> something like the following?
> 
> -static bool lru_gen_set_refs(struct folio *folio)
> +static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>   {
> +       /* Activate file-backed executable folios after first usage. */
> +       if (is_exec_file_folio(folio, vma_flags)) {
> +               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS,
> BIT(PG_workingset));
> +               return true;
> +       }

I tried that, and there was no obvious difference. I think the original 
logic also promotes the exec folio when it is accessed again, so I 
prefer to keep the same logic as folio_update_gen().

As I mentioned earlier[1], lru_gen_set_refs() needs some rework, and 
I'll think about how to optimize this function later.

[1] 
https://lore.kernel.org/all/eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com/

