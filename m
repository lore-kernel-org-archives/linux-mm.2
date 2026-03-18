Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2152103E173
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21D06B01F2; Wed, 18 Mar 2026 08:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3176B01F7; Wed, 18 Mar 2026 08:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1496B01F8; Wed, 18 Mar 2026 08:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA2A36B01F2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:59:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8744914073E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:59:53 +0000 (UTC)
X-FDA: 84559191066.16.239EDBB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D9E0C0004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:59:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8MsMl+P;
	spf=pass (imf10.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773838791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3h6AAxB1kHfz2+32UXslM63t/gfDPdKFvQe7BOefzXM=;
	b=PHRDhw9vOTMa2sFrISQ/wxuP3n/8yNBtVnwCjd2EylOw4y3SU/lZUC5Lbuja4qdNsRnbkd
	D5jqgPSa6NzJBR8MS8Rqvpgj7+5sUPrmrRx9HunBf5NPjvw6yOAQITeIz5mcjbKuC9ISuC
	BdtSxmp1KsvskL70OsJOjlkS/pQI/jo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8MsMl+P;
	spf=pass (imf10.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773838791; a=rsa-sha256;
	cv=none;
	b=pbr7b48x61ETidntqeRsjt2BXcvv8A6E4tBaozMp2IhXxtBZa9ljkdYWk07SApwZqK1Dw2
	xIKuCnx5ZsR2VDwcXXq/8RLUujTXohgZkD/2nnJO9t4HYbgntqSIqGw70qKb+0k/jP9nY+
	wX2Mm411ejVHh4A/VlM6Vq+gWBjPQX4=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82a3d3235c9so2807683b3a.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773838790; x=1774443590; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3h6AAxB1kHfz2+32UXslM63t/gfDPdKFvQe7BOefzXM=;
        b=T8MsMl+P2Ru5RWldFMu5CJ4HlbI9HIQY051axzNXOe7NYg4FiRveDVukusus0s3oVP
         CiqtxOhOqcrtAobvk7iCG6S56I43DlWUepjXcJtQ8ZiOoSJlphIfsa6WMcgSwPUe/Qw7
         rUH5HtgUdj8GSl3k5+MxD2PQ/uZTylha5lKTvKiQfVcTFhujB8JithWf5D0wPaW1lDdP
         +tuON85Dig8ly+s5IBh3bP0jz2xYwBXkgQijLmqUPChN6C3GNSQSFUU9iLvRpPBFp5uY
         OS2DVYZbfpCn25UGv/QncFQ9uKylDTdm/w7xBJoFxJnROt5BeV6W+OeEVARnZaRTOjv1
         iGPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773838790; x=1774443590;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3h6AAxB1kHfz2+32UXslM63t/gfDPdKFvQe7BOefzXM=;
        b=Dxx7AXPlwFtTasb8EV0yKP5JLfWudDOLxWeWmrTyMeeVlA9atp+7by8rTcKq9rwEn1
         p0kYv5N+0avRPpj4UEPlFXoah/cE9rsrByIcmayCy656W96qgvCoLIN9kJXls/Zb3NEA
         kStLi9zKU3nYb/K+a/Sm2ptxlWk9RwvLT+gtOGVP0Ply7oDL/n3OLpjKfUVPNWLp4Msk
         vRIgPQukS/3gwaB3kIZM13cEqp3hL2IkBXSe12Z6A7aGSBDvTjYOBw9ZUfH28+ef9CvV
         GxE12Ayq2KHd+VnL6qtTEIwKzNbltcBF1SfNxdhUTYnrb6EVsk0G/RynoUL5npmAlwgL
         eGkw==
X-Forwarded-Encrypted: i=1; AJvYcCV0NRiyF+bHXhq5CHdclD4bcQcvIOIsg4EOz+Az77xnj86KLgbud7PHW60yMmnhQLazp8fjz1xYjw==@kvack.org
X-Gm-Message-State: AOJu0YwQg0pKS31KjAh9NhCE9DhLB+m2MTroEYHeOVm+40orP7n2i+fZ
	r+ZddOKaBLldOjU8uWBnnbuSHa+p/rHyvRsEYk1bJEsdAmzCvHnqiEbo
X-Gm-Gg: ATEYQzw37CxXJvUhK8hk+bz5BKYeBINFf7gtatIi1bKd6viTMncVc4y78Ccy91BLtwF
	JL3yEjV6cB2bf9OmaunoYtEUSE1a8DnZTJggRl7jjS8Lux+bbzEME+7ZFOYrZofpAGOz9xuTox8
	KWjaUwhbPw2lTXSvPTcbvgM5wUxlUoA1evX3xa+DLpV2ez9EsgOZby5J/fFldS7V7ri6DA3mRcK
	n3tG7mCGIPnZI1ZAS0xBnBXquwV/8FyKY58+ovbMlmZkv8nwabsiURW1jBgnkiNub9JNORpHRMq
	YlC7DGjpOS4RZE5F/pwRd2NwLPgUbAvhC090HpPOSPhmANCp6/McAlHZbRZEl2afUBgXFbvSl9D
	1bv5ZDRE/l0/tvhcOgD3ZnexcOdtXnyowh7ei2RRapgMjixS1xa3BnicY2fhydMNehW/SUtqtWI
	/bQVaCcPwBlVZFzOzf0N/zusuW30HHsOovDRgJHjXNTA/va8h8EycI8wPDTWSZDJho9cs93GI8Y
	pkKnypb3evYlhjSLcP4DhrsFVJRpphDrPtvg/6Bb34ZoaSpJZgPM7M=
X-Received: by 2002:a05:6a00:8e02:b0:827:3222:c4c with SMTP id d2e1a72fcca58-82a6aeba634mr3245469b3a.39.1773838789979;
        Wed, 18 Mar 2026 05:59:49 -0700 (PDT)
Received: from ?IPV6:2408:84e2:440:5e9c:1dd4:d6f4:257c:2380? ([2408:84e2:440:5e9c:1dd4:d6f4:257c:2380])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b541cafsm2814048b3a.12.2026.03.18.05.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 05:59:49 -0700 (PDT)
Message-ID: <0cd1cd09-bb06-43c3-a3ed-8dce2c0a13aa@gmail.com>
Date: Wed, 18 Mar 2026 20:59:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Leno Hou <lenohou@gmail.com>
Subject: Re: [PATCH v4] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jialing Wang <wjl.linux@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260318-b4-switch-mglru-v2-v4-1-1b927c93659d@gmail.com>
 <CAGsJ_4xHvtjkPp5Ar16UXqZhQYHpdYcqCWMmFbGGUvK-kCH+uw@mail.gmail.com>
 <8c01a707-f798-4649-8441-d82dd0dac7b9@gmail.com>
 <CAGsJ_4y+SwwCtDu8zPYnuSdyS+1=q77d1Fwq6eHbqrnw8-6K=w@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAGsJ_4y+SwwCtDu8zPYnuSdyS+1=q77d1Fwq6eHbqrnw8-6K=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D9E0C0004
X-Stat-Signature: gcbdaydwakj1wbnc8dxgtdnh37hrts38
X-Rspam-User: 
X-HE-Tag: 1773838791-223438
X-HE-Meta: U2FsdGVkX1+dKDoVLCOd22wzWsgpLZ25xwxrmmJGhakWL/b91+I15/t1UJQLwwJsjx2uXkH39L52YvgpQLPdzqbPKbxnOx1RnZtJwGXiaR0AKqLYcSg08CfFJEpc9y4luOojdWBUMzKfkKzNIlMKq5TJ7eXThv+W9mVeCNuZi+EHsLpKDKVCzSazTL4Wvd4iP5ORE8MQL85TGcmYscCrJbQXiwzl7lZROjRHsQTHJSPtHqgeep9UDy13rcp+QkodB80j/9oI/80DffSTR3yapVWVIedxFD8HCc6PiNkBxZpHAJHvxpRsHL5NTBG0A7byyf79sarvDxuAPxUOWukkdTGkF4ghe//vs9ITMqyT1w4Fn+1bJWJG5dAnVBAEMK9e1lKa2K4B8mTvDjbrsrnJMnMDkT1ticsekCDgKfk0GvZeLE5QEhLY4ndGo6oZVUObwghWo0eSTFNX8juMYt048KILEVlMRRYLpUufMmXf3d817nWAVXc1gcEkAzDy8MsegXOT211kFq1qSndI+B1Y6zIgLDpeIfMPJrjejpv9I82FIEGuG+34sgW8Poahr3pbeL+FTe4tDJ2fdldORecqiG9V1ZMh+Vak143tEUD0uCwj0rDaiJ+3Q+Sj+Bdg3e/sxS2a194e/sAoKZbc9D3Mq6+K+7APpFCRfkxmhoNBVl/OB7bH+t+QkW8tUSRomiPhdKNKUAC//bG5rDh0j80oMuP32Tn3ZNFmsd/K6lutfSKuY/qFQfajrr/Xcni0rKumCkDQE4BcZJbWMHBxgRWyiyO5JhpQH7LSgldXbnVxfcaVdPFc86Uy3uFI93Xr6ViPkoXb7XOVkp5xfO8/F2yDIr4eW3KKem8cQ9SfUB1WmRG5Y7ff9iJshgCJYMgVOutW72CgPAJdHp8IKIduGFyP1+4/tGEBi99UlWaknjNFIUBvh0+PJiEvjCtV1TcTebnjYtK0R9xI2HguZvr9SZu
 CdzcZAT8
 g2NKW3wdz4gWEzIDLcbW3ScUhVkH+pRW/xBzqJ+u5VkILqtyDY7HHKzZwQaNO7zGDiXfkia1yDCbYvx9CMsy+ffH41I8g5SLg8m9T9/mLUev0Gpm6be908IxZTVnPRpfItgRhDDqvZJwXOS+r34Fa178dNkM21Ca0zeH2y6uyk5OFbWXcc2GLV6p3DAhef8eBTbJtofpqJGs9mmIfG7O+R+r3rFciaNCuGRRPCbUm9mk8FgOZ8GCqO47zkSmZNqQf/n8xcr0DcQYFSy2u6zXL3jl1anbaL2AmXqZzA13OEbPJtGY/LC9dxQT2S5qt6uLAf0qHN1WR/zZ8QgPU1yNFFtxGZm6F3SbaJxL4bbsIcGp2OVEHPzhr3adVMCOyIYyMGXF0mOD/ldqYBPIqHNtu/mWgbsSMAoPL1kAuSKppTcgI7FeQfA27HJJ3wgYE+P5AnwLw2MdxC+Cm9DyafyUpvCHJo06eR8XMsmGJW6YScM45ZCywJKC+hZ1qQ1YYeVKwwniSwVNeSMWPoWJ2tcfYrQs5L9hOAMF8+Hc9angPOOnMnP5rZwOFzpYKT385ozyygPzS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 4:30 PM, Barry Song wrote:
> On Wed, Mar 18, 2026 at 4:17 PM Leno Hou <lenohou@gmail.com> wrote:
[...]
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 33287ba4a500..88b9db06e331 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -886,7 +886,7 @@ static enum folio_references folio_check_references(struct folio *folio,
>>>>           if (referenced_ptes == -1)
>>>>                   return FOLIOREF_KEEP;
>>>>
>>>> -       if (lru_gen_enabled()) {
>>
>> documentation as following:
>>
>> /*
>>    * During the MGLRU state transition (lru_gen_switching), we force
>>    * folios to follow the traditional active/inactive reference checking.
>>    *
>>    * While MGLRU is switching,the generational state of folios is in flux.
>>    * Falling back to the traditional logic (which relies on PG_referenced/
>>    * PG_active flags that are consistent across both mechanisms) provides
>>    * a stable, safe behavior for the folio until it is fully migrated back
>>    * to the traditional LRU lists. This avoids relying on potentially
>>    * inconsistent MGLRU generational metadata during the transition.
>>    */
>>
>>>> +       if (lru_gen_enabled() && !lru_gen_draining()) {
>>>
>>> I’m curious what prompted you to do this.
>>>
>>> This feels a bit odd. I assume this effectively makes
>>> folios on MGLRU, as well as those on active/inactive
>>> lists, always follow the active/inactive logic.
>>>
>>> It might be fine, but it needs thorough documentation here.
>>>
>>> another approach would be:
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 33287ba4a500..91b60664b652 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -122,6 +122,9 @@ struct scan_control {
>>>           /* Proactive reclaim invoked by userspace */
>>>           unsigned int proactive:1;
>>>
>>> +       /* Are we reclaiming from MGLRU */
>>> +       unsigned int lru_gen:1;
>>> +
>>>           /*
>>>            * Cgroup memory below memory.low is protected as long as we
>>>            * don't threaten to OOM. If any cgroup is reclaimed at
>>> @@ -886,7 +889,7 @@ static enum folio_references
>>> folio_check_references(struct folio *folio,
>>>           if (referenced_ptes == -1)
>>>                   return FOLIOREF_KEEP;
>>>
>>> -       if (lru_gen_enabled()) {
>>> +       if (sc->lru_gen) {
>>>                   if (!referenced_ptes)
>>>                           return FOLIOREF_RECLAIM;
>>>
>>> This makes the logic perfectly correct (you know exactly
>>> where your folios come from), but I’m not sure it’s worth it.
>>>
>>> Anyway, I’d like to understand why you always need to
>>> use the active/inactive logic even for folios from MGLRU.
>>> To me, it seems to work only by coincidence, which isn’t good.
>>>
>>> Thanks
>>> Barry
>>
>> Hi Barry,
>>
>> I agree that using !lru_gen_draining() feels a bit like a fallback path.
>> However, after considering your suggestion for sc->lru_gen, I’m
>> concerned about the broad impact of modifying struct scan_control.Since
>> lru_drain_core is a very transient state, I prefer a localized fix that
>> doesn't propagate architectural changes throughout the entire reclaim stack.
>>
>> You mentioned that using the active/inactive logic feels like it works
>> by 'coincidence'. To clarify, this is an intentional fallback: because
>> the generational metadata in MGLRU becomes unreliable during draining,
>> we intentionally downgrade these folios to the traditional logic. Since
>> the PG_referenced and PG_active bits are maintained by the core VM and
>> are consistent regardless of whether MGLRU is active, this fallback is
>> technically sound and robust.
>>
>> I have added detailed documentation to the code to explain this design
>> choice, clarifying that it's a deliberate transition strategy rather
>> than a coincidence."
> 
> Nope. You still haven’t explained why the active/inactive LRU
> logic makes it work. MGLRU and active/inactive use different
> methods to determine whether a folio is hot or cold. You’re
> forcing active/inactive logic to decide hot/cold for an MGLRU
> folio. It’s not that simple—PG_referenced isn’t maintained
> by the core; it’s specific to active/inactive. See folio_mark_accessed().
> 
> Best Regards
> Barry

Hi Barry,
Thank you for your patience and for pointing out the version-specific 
nuances. You are absolutely correct—my previous assumption that the 
traditional reference-checking logic would serve as a robust fallback 
was fundamentally flawed.

After re-examining the code in v7.0 and comparing it with older versions 
(e.g., v6.1), I see the core issue you highlighted:

1. Evolution of PG_referenced: In older kernels, lru_gen_inc_refs() 
often interacted with the PG_referenced bit, which inadvertently 
provided a 'coincidental' hint for the legacy reclaim path. However, in 
v7.0+, lru_gen_inc_refs() has evolved to use set_mask_bits() on the 
LRU_REFS_MASK bitfield, and it no longer relies on or updates the legacy 
PG_referenced bit for MGLRU folios.

2. The Logic Flaw: When switching from MGLRU to the traditional LRU, 
these folios arrive at the legacy reclaim path with PG_referenced unset 
or stale. If I force them through the legacy folio_check_references() 
path, folio_test_clear_referenced(folio) predictably returns 0. The 
legacy path interprets this as a 'cold' folio, leading to premature 
reclamation. You are correct that forcing this active/inactive logic 
onto MGLRU folios is logically inconsistent.


3. My Revised Approach: Instead of attempting to patch 
folio_check_references() with a fallback logic, I have decided to keep 
the folio_check_references() logic unchanged.

The system handles this transition safely through the kernel's existing 
reclaim loop and retry mechanisms:

    a) While MGLRU is draining, folios are moved back to the traditional 
    LRU lists. Once migrated, these folios will naturally begin 
participating in the legacy reclaim path.

    b) Although some folios might be initially underestimated as 'cold' 
in the very first reclaim pass immediately after the switch, the 
kernel's reclaim loop will naturally re-evaluate them. As they are 
accessed, the standard legacy mechanism will correctly maintain the 
PG_referenced bit, and the system will converge to the correct state 
without needing an explicit fallback path or state-checking in 
folio_check_references().


This approach avoids the logical corruption caused by forcing 
incompatible evaluation methods and relies on the natural convergence of 
the existing reclaim loop.


Does this alignment with the existing reclaim mechanism address your 
concerns about logical consistency?

Best regards,
Leno Hou













