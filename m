Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D59C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1CE86B0099; Fri, 24 Jul 2026 06:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5C46B009B; Fri, 24 Jul 2026 06:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6E36B009D; Fri, 24 Jul 2026 06:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 609FC6B0099
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:21:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E846FA1096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:21:03 +0000 (UTC)
X-FDA: 85023277206.05.D896E4D
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05556140002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:21:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lxuT+V3N;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHv4nBZUAA4QHT3/Nk9dUVsgZ03YSj5oD2kL/0soAWU=;
	b=ccUWbXSXvw0m7NklwI9OEtnRNdlifFfMUPtYyUIgch1Hg3NDWpVyf5EIv0iC5mwefIt1u/
	/jb1RXksMiXnfV+T2fqQy8+c72H2LQqAFeeQZ2kH3QDHCKNtYUVSL5LgiP2RfG7QdOWFsu
	ZtyJpFTcqhHF96WLwyFsm8z/AtmMzT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888462;
	b=iN+ALaL3Lh66fPn6Dd/yrTsFhayJp6wxs9jrVS5QmFGCtOtW414DHBn2bgs9RP3SRpvjY2
	hZdUWGevJphm+D4JosfHcoBRwtO72Fd5JbzilCQ+9SPur3QCzKBESPpzKjQxbDczHJk2K+
	9Qbsy80Y2OsFQwUrZ07N2OwUwoA2/kA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lxuT+V3N;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso2790825ad.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784888461; x=1785493261; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OHv4nBZUAA4QHT3/Nk9dUVsgZ03YSj5oD2kL/0soAWU=;
        b=lxuT+V3NWFrVOxHtneiozOXTqTC2Q8ZI+Z07TxO4cA82zq9ZMZ22FDfh4JSizTyRoO
         Wq82yvxgGT4FdpYZAWkVauGBeyAyxwikdn8ms09jveM4/aXNdpr9MVktr7CMZ7K+IGY2
         sDg5IqNt4EkttJ+xvRrpWZRT+8GSsN2zIKPEEEQjBiPXcp4bwA3auLhvp4GXvSyCKMb1
         zRGS3nOT1ej6IQjNNRKwwMR5C2jXFkB+hbxF8E2PpBTPXwQS1qpPqO8YCC0waJqPoi6o
         1SdlzNpJxci/bOVyXsbo9jlu2ZeTpeJy3ehX1lA0HFMEZ54JaOJDQsLzxfwJrteVAZmC
         qRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784888461; x=1785493261;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OHv4nBZUAA4QHT3/Nk9dUVsgZ03YSj5oD2kL/0soAWU=;
        b=asYzw+67+OZqVxRqwNdlRR3fCqaSdC3cnI/OJ9KywG75fHFb8JxywY/XH3cYCNZhwq
         C8KR3mcCjpDS8JnQ51uY0PX5NUJiKPLzITeYTNOl/4xVN1iiwaiAOPF9EAiF9ZMN6Yzb
         AXeOg+FS7+ver2aJqnkQCb1//3pUWsz1aD8rNBXI3N+XYW+1gMTubjPPddIIAkiaDjPq
         syp4FWVhFV0F6iBIdj9Vkll9+tFIi7iqJuWxdsCPFWdrM5fKyA62rXUMmySnxYaYZUJe
         UAbTzajAoJgLyI+NVEpG+trn6TanFKG6g6VAchhQ18uag9lGyjRaXHtiPXJffJkSn60s
         cGkg==
X-Forwarded-Encrypted: i=1; AHgh+Rp3qy8CtS6oxFoIiiPfgMDXU86akq8cIqp1U8PRUKf0XHoWVlN8Xa025mx5nQZLFWo6DryyffUs5g==@kvack.org
X-Gm-Message-State: AOJu0Yy3fkyMBDpsAPT1CqEdWBQyK7VYBKJ32gkJZCe4tDMFaETNbZqs
	jY4M5fzfSCsX3JPpqQ9jdpPWEvYbmtTeD0FO95/q4gMBxsc0chS9vRxJ
X-Gm-Gg: AR+sD13B9uPLiWUGFGjsqLTsesN4fu76iDLvpqivSMFKwUSggRkH1+cEekkI6fMgy04
	VySXl5wZllrc/2vCXpr7KzndTE0BfnSA/GKFdexlKt9t7gLOO3AfZVWtu36+etQlp3nplD3bBcK
	TDRHHTSbF5g3I6GobErGPDEbZPuk2Jc+4+XCsDRyMshQq/2cGrLHnVY2TXuokhM60jtdOK8ZdJE
	p5DE07c7aiQqhjTdc1A4FJzSK13RLfWiLtmZGiprBBMG0L+3wkEg3D7xihw6jQDKpG0KmFvVnrb
	1QWoz3P9l6GcTIoCAVv/zIIvHY1brT/hF4tbhHe4xPH6R9Xf83YuWDj4+OcPfeW1VT5bxLkWgKn
	dfeGYWV5VMfbxBOi8UPcuRaQhnvundLQMCP/Tpr/SQ4Vg954iCt1Av1Jiv9GIddsSfioQ+dsjz7
	Fk3lqV9UCvw2rNCxPetaBelQ==
X-Received: by 2002:a17:903:2f88:b0:2cf:bf32:b754 with SMTP id d9443c01a7336-2cfbf32bf7amr33103845ad.8.1784888460802;
        Fri, 24 Jul 2026 03:21:00 -0700 (PDT)
Received: from [10.125.192.96] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa2cd0sm48812475ad.4.2026.07.24.03.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:21:00 -0700 (PDT)
Message-ID: <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
Date: Fri, 24 Jul 2026 18:20:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
To: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org>
 <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qt8xio6qb9tccqtc7bfs9esis1zs7xxt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05556140002
X-HE-Tag: 1784888461-86482
X-HE-Meta: U2FsdGVkX1/Rk09B0NORDrrXS0V5mJSFd4xqaI4d8C4EEQ8Tr6F0MaDcVMdjSg2rZ6iMaPE6iKefrp/nRXF+sIDcOBrcquEkW/9TWAB8E/2Seo6BaTRt2+TAilUG+dLnfz0kPrli2wzvm0q7nGvIt3TSyUFqMJOVuCwEuYzQxNc6ezWndmgtLCuSffhbYPl4LL0TY4+NuSgbPIGRN553NnN/7iPb+dzGLNNATHP+ovQgyzw6Iymt/AryCMvcl7oyKB2wvCIqCGFjhbiH7qvECqRhjpjaRRX0gTsnmcfmQTlmNq9fBkaZVNQ5Tpv2nI0EHiEXt5FI3/QIoBqnXRZhazPo4roCDB94lR07TdbLDtk6xHf6Pmnnk2x8HXWN0tXEzMg0k6JSOGNFjd+hkcWWD3MrxlyhXVuDYmGbhvbOfJWbZXuj5sZO/aWP9dzSVF1KEbeFtRd88Wm8md99cl6lIYLZDQY06a7+GUkazB2PIvLMrIAkIfKQa2SuG3reLyfUa2UcDJPr24kRQ7m4TcY5JVl0UlfR3e8huVjWXX4NSfFwJ1r12L8dVpErtbKqKNUiWEPRbdBjpO8IfwtFa7IpKJ6J+cB4QO29FdrECoPtdngcEE+7fg4BkFO4mDclLnShRl1IeKVIyTZeSWm6OhIbl583lYwZBEoy3+c+IP1uFScUMfXVEzIAimTZLvUSWI9NVBurjVmfESzwm8zf4h/hZg2cZglfnUTgHsWeFz2Qm55PfprGyw/y1A9xxx7j5uw59r5sNnZSYn/KmY8hZNWZ4rjXBQ8/Dj4vFJ+UOahVxwH9IV/sCwHYGFQ/dtZRX101t46N/QPihporOu0By054gW9bXckby9PIjOJvXioVipWI4PmC5jLO0oe2xNPX//ucSoCtbK59eFLP/zvs1Vrx1q/DfVfF9/hsHlZI9wAwf5hMpCEhajo2Vw7WdEJSMnQx8WvfDtkhfiM8yngZYIh
 0EE3Rv3a
 csCXd+TqC+D8KWVYmL86uPsz/7cBtzLQWtzwnsALhmUT8A8XqJXOaQ4BU7l9GcnHTT3P5ILtMApkHHThNI2sV3P6KHHv4n2RjA+al96GWXJyFrh8jKeuSWQDgX4RodN3XURbu263yQ9iANwUgM9B5uB4FQjF49LAnxUbVlc7DqgUzSibQ7JV1PTzuW0mpICe/Wqb8CXW1gpVcqQLHbN5spUjNSSmv5y/87+rsoLn667+dzj3utBIgbKJ4IF2aa76XUmmP6BN+/I25LxJ9ORC8ioN4AJ8O3aUpZg+sWZMjAHg0MDjSFeGPS6a13izjuaqXvA0vZP8sIC2g7mGWYi76KLQKfwZdnM6YP5UN3iESMrBlmBAlwQSdExTsG4Ziwr0xS+XOGTywN+oonlL2oCMOD6LZnrXo2vMz63+QMdD6m1h5a/Uym/lHikAuFJEdAJ9BQP8rm3FLaopgtf9z5yxtapCyUwzxohMjrDbiXTEMXqq+S4wplSwa1XtvPijeV1oHpQETg39US8WAnp78q9faI5JMz88K4dnPuVNJQtN9OfLVKMfqK96cEFom+eRNVK9Y+zjJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/24 00:39, Yosry Ahmed wrote:
> On Thu, Jul 23, 2026 at 6:55 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
>>> On Wed, Jul 22, 2026 at 7:27 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>>>
>>>> On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
>>>>> @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
>>>>>                        goto resched;
>>>>>                }
>>>>>
>>>>> -             ret = shrink_memcg(memcg);
>>>>> +             ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>>>>                /* drop the extra reference */
>>>>>                mem_cgroup_put(memcg);
>>>>>
>>>>> @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
>>>>>        objcg = get_obj_cgroup_from_folio(folio);
>>>>>        if (objcg && !obj_cgroup_may_zswap(objcg)) {
>>>>>                memcg = get_mem_cgroup_from_objcg(objcg);
>>>>> -             if (shrink_memcg(memcg)) {
>>>>> +             if (shrink_memcg(memcg, 1)) {
>>>>
>>>> Why 64 for the global limit but only 1 for the cgroup limit? That
>>>> seems arbitrary in multiple ways.
>>>
>>> I suggested that we keep the writeback here without batching and do
>>> that change separately, mainly out of abundance of caution as
>>> writeback is done synchronously here so the extra latency could be
>>> problematic. I think we probably want to measure the performance
>>> impact of that separately.
>>>
>>> That being said, this path is potentially too expensive anyway due to
>>> the flush, but I would rather we do some basic measurements before
>>> batching here.
>>>
>>> What do you think?
>>
>> It's not an unknown, right? We know this works for direct reclaimers,
>> cgroup limit reclaim e.g., and what the latency implications are.
>>
>> Because of how reclaim works, we also know it'll call zswap_store() in
>> batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
>> each call shrink_memcg() once we're at the limit - while still risking
>> rejections due to compressibility differences.
>>
>> My worry is that if we start with an inconsistency, we'll be stuck
>> with it for a long time.
>>
>> I'd rather start with the clean, consistent version. Dial it back only
>> if we have data to justfiy the complication that we can put into a
>> comment and the changelog that outlines why exactly it's different.
> 
> I am fine with doing that and basically always using NR_ZSWAP_WB_BATCH
> as the batch size in shrink_memcg(), but I would be more comfortable
> if we did some sanity testing.
> 
> Hao, would you be able to do some smoke testing with NR_ZSWAP_WB_BATCH
> used for all paths, and memory.zswap.max set in a way that induces
> writeback? You can probably set memory.zswap.max to 1% of total memory
> instead of the global pool limit and rerun the same test.

Building on Test Case 2, I set zswap.max=320M (~1% of total system 
memory) and updated both invocation paths of shrink_memcg() to process 
batches of 32 or 64. The resulting benchmark data is shown below.
(Note: Test Case 2 also sets max_pool_percent=1.)

                       baseline-cgroup   batch-all-32-cgroup 
batch-all-64-cgroup
shrink_worker wakeups        7,238             766               367
shrink_memcg calls      12,059,142       1,961,194           983,878
written_back                28,277         301,157           327,997
zswap_store calls         1,349,572       1,168,190         1,114,549
   store succeeded            492,861         521,315           459,246
   store rejected             856,712         646,875           655,303
   store reject rate            ~63%           ~55%              ~58%
pool_limit_hit              510,130          50,096            57,715
pswpout                     884,989         948,032           983,300
pswpin                    1,251,268       1,638,668         1,878,453

Thanks,
Hao

