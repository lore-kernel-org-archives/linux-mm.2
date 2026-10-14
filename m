Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D76CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80916B008A; Tue, 13 Oct 2026 23:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32586B008C; Tue, 13 Oct 2026 23:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947F66B0092; Tue, 13 Oct 2026 23:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6388E6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:22:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6BB2A041B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:22:40 +0000 (UTC)
X-FDA: 85319784480.01.F203F17
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29C5D40002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:22:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nzoJGRdT;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791948157;
	b=ssM+JyGusSaBPxkjc3VLgq2I3fr++5au1ioIALXxfYeX8SW0SIko2KF/aY8JrVo2ZZAsNM
	pySQfn7k6pOwSfHI75EfJxpmfuih8Z9ooTCrTiCuosOAKpBcpqSux2Jh/HECbDRrEcaH36
	dbLTBDFBdhwCcZYQG9Lr8VhvTTeq0oc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nzoJGRdT;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791948157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdka3fW2xfZWec1SEge8s2+5rN/8mzzIM3aBDPfyI00=;
	b=Ht4fCwzhwgjGsY+KD82rg7CppAZwfEJOHkvvDOyYyJtHWniY7f6fFBDFsZdGbbQcYZzjwM
	dNeDmr8Ynl1G6GP8ySnfpH+YHnGls5/fSj2SXzirklskpJs2ypX5b4xJDl11q8gUUUKrUN
	U6LGFiYARNreRMsWNO65GlbsD2UuQcc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791948151; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fdka3fW2xfZWec1SEge8s2+5rN/8mzzIM3aBDPfyI00=;
	b=nzoJGRdTK0eJ/D030mB+d/QPtxMm8/rKj8tG35afiow6H7O6gKUDXq9fRsN82IgAnBm5BMiPNEvS5R348L88s/SLZtp6sAPIhusmsx9cupfGALzlRzsp2BdfP1gGuUSSN2MWBGLGmPdqCur3Qd0YPvUom+y8vG8iyx7AgV7n77Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XCnt-tC_1791948149;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCnt-tC_1791948149 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 11:22:30 +0800
Message-ID: <8c1a1c3a-df87-42a5-874a-0e1283a6b31e@linux.alibaba.com>
Date: Wed, 14 Oct 2026 11:22:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during
 retrying missed rotated folios
To: Kairui Song <ryncsn@gmail.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu.xie@google.com, weixugc@google.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, Yu Zhao <yuzhao@google.com>,
 Bo Zhang <zhangbo56@xiaomi.com>
References: <20261003054216.9155-1-baohua@kernel.org>
 <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
 <asd-8uoATmpH9YN9@KASONG-MC4>
 <CAMgjq7DR6h6GTKASQo_fHx1hyzw_zJZ1OHP-dzy3RDcTcZJUxQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DR6h6GTKASQo_fHx1hyzw_zJZ1OHP-dzy3RDcTcZJUxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29C5D40002
X-Rspam-User: 
X-Stat-Signature: yxdu7zzo5dysmkhf1sfncm3ydpjueftk
X-HE-Tag: 1791948155-563965
X-HE-Meta: U2FsdGVkX18WawVJHFxnPg8X9q2sGNoCpJdI37mLIUsEQkutm7AeCgLlVrYcaIKGifR7XPKVFoXmjhI3j05CKhBaXHfHNEDgfokPCpHz8kO9bZJX8sAr6iIjV8k6AUvknksbFClns/HIrLBzWjJ+HCOw1EPq+rR8rEHu10c5H0xedbsxNipvSj1FJoA/sYzFWsTshezoAvfNjECVuhGQ1ufdFcOUTvN9IJjFqpQYQv8k8gEj+T4tQV1/9drv2B3KVckn4uYGtNQTWsZ+UW004RGhHNmClfBrSseemDVBZFjGzSBW+DiDaBFx7xpjqycfYlD7IBeYxTy18b6/Gk2MCKtIY/bDO0ejUPiNnOzNHGTly6AxnsQ9py/DhMRTXYaEgF+RXvn6bkpGXbD2VUjSgg1Ohcgl/Gqp4G0NbFE143Lf3TqtLPkZSWOGWp/YINhjrWSY0ZUeeIgboYxXASX0W3KMO4iVBNS2OsnOh3iMiXfs2UFOx+j8ujJUPGPc0Y1W6YE0QgxXrn7qtXKOPluIcvTvXDIg4kksUhkNsxAjKTGJWRuPDJBffFuwt2Dt7598aB/nzIbgJEyIbonq7BC9D59gRH9Bstq7FxyxiPbNl+ilOEF22WGTxgF+P5gB8vYDUTh6jepebWm2utFxGXJSXQpk6bAKd03t3Q6KMz1UcJrhd51bKus4poX7SKeVjE7gle523Dp6vpafgB8OjIhHwy7fGSvwzRynlQ9G5kFY/6kuRmZaTj/NHTlTt8brCaPbr4jRJTksNcHCxh3/KbWo+dsyzWp9kTz2sYNV4A/pqXBl1e2zmyPqt+ibZbpWAVtFmXDpiXAO58DYDuP+gEG2ACkPaSyGZsv1AjNPGer1WxO5MVFxdFx4Dya5EJmJu+YBuzarbRpExZTMVjnDnkcUwnp0HSzHx7cEjbaQ/CG+xOfTPaoZ1myP8ZnFR2vWTD8lTzdWHrtGpuJUQtw6RNc
 wajyIvyD
 9+rQTX9VSw70APGixFiPHl2hD8u1WpSk3gp/S8c0WSDmPxpq2IhoAgp/JS64fRl+EplpLix+R94Fb3I+2VOnP6h0a2eRs3ePky+U6AjCv8zmmtqYUAfjB12i/lwJcEGyrdOZhXWSZVAhC7TbvxkJq4dMk+Gm0hhTjeLofkOPPDGrjM5QPiQFzM4U2yLXFOwereMczB1sf97PMjFAd4YS5eKR+6hxVl148dC5IMRaXOHu8nPrt1hu3kbdzqneWj09zR9TjpT1kZC3cBBrXV4WepU9+KXEwoO2S6+tREVjKO88+ASpMbYl+VjELOUEzhojKaL7/2Qm5g/6j6+aicEYSEVyAVP5bQhu8o8gswRa01pzCQ/PFlW22OT1e0L0zFr2/nYJTHkTlvhBkoNBgeiDYnFP5uU/wmf3CZFRa+trL4o4+zzCjuJkRwv0Ezp18XgYvSczyEQtRxTglVtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/8/26 7:52 PM, Kairui Song wrote:
> On Thu, Oct 8, 2026 at 1:43 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Thu, Oct 08, 2026 at 02:52:35PM +0100, Baolin Wang wrote:
>>> Hi Barry,
>>>
>>> On 10/3/26 1:42 PM, Barry Song (Xiaomi) wrote:
>>>> Since commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
>>>> `folio_test_referenced()` was accidentally removed when checking for
>>>> missed rotated folios. As a result, kept folios without an active set
>>>> could be added to the retry list and eventually reclaimed.
>>>>
>>>> The impact should be very small, as we have the `folio_mapped(folio)`
>>>> check before retrying. Kept folios won't have `try_to_unmap()` called,
>>>> so this is really only applicable to folios that are unmapped by users
>>>> after `folio_referenced()` has been called.
>>>>
>>>> I'm not sure if anyone else has seen any issues with this. Sending an
>>>> RFC to check whether it is worth fixing.
>>>>
>>>> Fixes: 4d5d14a01e2c ("mm/mglru: rework workingset protection")
>>>> Cc: Yu Zhao <yuzhao@google.com>
>>>> Reported-by: Bo Zhang <zhangbo56@xiaomi.com>
>>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>>> ---
>>>>    mm/vmscan.c | 7 +++++--
>>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 91295070ca33..6a931b576b7d 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -994,8 +994,10 @@ static enum folio_references folio_check_references(struct folio *folio,
>>>>              return FOLIOREF_KEEP;
>>>>      if (lru_gen_enabled() && !lru_gen_switching()) {
>>>> -           if (!referenced_ptes)
>>>> +           if (!referenced_ptes) {
>>>> +                   folio_clear_referenced(folio);
>>>>                      return FOLIOREF_RECLAIM;
>>>> +           }
>>>
>>> I've also been investigating the issue of referenced folios being reclaimed
>>> recently. The background is that classical LRU will return FOLIOREF_KEEP for
>>> folios accessed once via page table, giving the accessed folio another
>>> chance.
>>
>> Hi, thanks for looking into this.
>>
>>>
>>> However, for MGLRU, if the folio's pagetable access has already been
>>> consumed by aging or lru_gen_look_around(), referenced_ptes may be 0 at that
>>> point, leading to reclaiming folios that were accessed via page table, which
>>> could cause more refaults (I don't have data yet).
>>
>> If we go with MGLRU-FG, aging or lru_gen_look_around may move the folio
>> to newer gen which is identical to the behavior of promoting at eviction
>> time.
>>
>>> But it's not easy to maintain logic consistent with classical LRU, because
>>> we cannot distinguish whether this one access count comes from page table or
>>> file descriptors (for anonymous pages, it can be distinguished). I'm not
>>> sure if Kairui's MGLRU-FG patchset helps with this case (I haven't looked at
>>> it carefully yet).
>>
>> It definatly helps, check this one:
>> https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-4-cbd4546a5bd9@tencent.com/

OK. Great.

>> folio_inc_lru_refs and variants will promote the folios in a consistent way.
>> See "First access only defers eviction from the oldest gen" part, I believe
>> that is the issue you worries about?

Seems so. I'll look at your patchset closely.

>> BTW promote then to newest gen directly does over protect them, I've see
>> regression with that.

Agree. A folio with only one access indeed should not enter the newest gen.

>>> Perhaps at least for anonymous pages, if the referenced flag is set, we
>>> should return FOLIOREF_KEEP to give it another scan chance.
>>
>> No I think we really shouldn't do that, it will over protect single used
>> folios. Promoting them to second newest gen or second oldest gen seems
>> a good idea and similiar to CLRU, and this is the behavior of MGLRU-FG.
> 
> Oh I also mean that protecting them by lookaround / walking, and not
> at eviction seems better? As the rmap here have higher overhead and
> can see stall hotness info.

Sounds good to me. Thanks.

