Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99FF103E173
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1AC6B01F3; Wed, 18 Mar 2026 08:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273626B01F5; Wed, 18 Mar 2026 08:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1620C6B01F6; Wed, 18 Mar 2026 08:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 034446B01F3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:56:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98874C26C9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:56:57 +0000 (UTC)
X-FDA: 84559183674.24.BD278DA
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id A88034000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:56:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kpVuBF4Y;
	spf=pass (imf27.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773838615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjM0VqiCcCdc+rIPYxygRPKv3xEtt67Nq+C/ca8TllM=;
	b=kSbam0HzHZQDJ5+A+ZH7uBMPIylu3+ZyJd58+cpKCx/P8HCUhJ1MaUM/P1XrkZAFH0Y8Uu
	9KZpnteErbfbObih+9XQa7NU+Y2PgemhBMEcbjN27g+rIafM+x4OySoJBMhTKfe8YfO/9U
	i1MQrjb6GmVTZLcrqlInuQhYbnHWlEA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kpVuBF4Y;
	spf=pass (imf27.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773838615; a=rsa-sha256;
	cv=none;
	b=AEZ+YgXsvzzBL2POII0bStgIKcgHYOh6SNRhLPQ2LbV8BfI9sWLdphobcR5KkwLclQ3iRO
	8vmybSNPjNxfcz4rG4fdXUCuiu6kbkZLtu/EqLqBsGfW8JYwkrmnWWQeHVjXGSUcg7dPw+
	3K23dK9MjeDqvQsUeup04D9JDSsteQs=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so83134425ad.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773838614; x=1774443414; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TjM0VqiCcCdc+rIPYxygRPKv3xEtt67Nq+C/ca8TllM=;
        b=kpVuBF4Yo98y8Ugi5pOFPCdOBGcwvKoczxnBofr4ryrUq968Gu4f/G/3tD/1tBxran
         5uH85BHLX5qqzIOV8fw7t4IOiduG7tGHnV9fbWCO1GFhD36CD7XfrH1XcpJ1eu+zDSim
         G+SoJuBs5HXWsn3T6hqyXMJumcXwpELcoMC6yaW3NlT8QS/hzR/R9M8SPmqI0X8w0f7+
         +IphoHQLfCnXc4n0rwfFWGs6HwSczF7fSmvdfNoZjlQISfct2vmPtcheKuxfSdhYPOQv
         HDXt9y/YrMh7LVlUWkO2TskScslMYiy7WxVaMATd5RfPrzrsHQA6lFvjmxqRmqBV//TU
         /Aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773838614; x=1774443414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TjM0VqiCcCdc+rIPYxygRPKv3xEtt67Nq+C/ca8TllM=;
        b=SF4We3bXnfPU14QLky/DjQO7EZYoySbKDbfXiDsHgs3irvT9hYToXnvvc+VMes46wh
         Pqv74AgIuCL/7sme0Um6elqthcQFLdHa83XefSzX+PeIeVtgn3NlGHxFMQNJTXA1jDUJ
         xtbkr2qvO1pC3Zc8gogZO9tu+SFXiuSR//S1pUcuhQQo4TQAXiINw9qxdLdq/5/loPBP
         GwQYTE4gi5zbk3p8zF34uYUhs/zJnx1WQWz0/enGI3AuR2Nfpz7H6fLz2aqtNSQkPTFj
         qnaCA+qyL7OeXapDIF6Vb5qlndhhsvyIg95LO9T8unvyvs0KzC5lQQktvoAPVmm6W6Zv
         UaLg==
X-Forwarded-Encrypted: i=1; AJvYcCV1CD9I+s9Y0UgXEF4I4wRDqZgYAgJvKlNV/kWsen7D/90os3NkW7DB4bN1tAf1HxA9sPsE5eJqZg==@kvack.org
X-Gm-Message-State: AOJu0YymF9QQMnK0dRLWMOteoOMICBQbx7S6SHiKwu95TGGx16zppSSh
	QECAWuZBm5reE9ZOCu5E+iS17XCinkgUfqAwPZMGL5dnhs1Y1aIfYk2p
X-Gm-Gg: ATEYQzzNCSqv9jd2rHOp+J7qw0e+STEUycNRArhJKVCsJPCUEKE6FiOf/TvgL8boZPY
	NKvEOmtpRHS4TEJ0pNC8XgqQCIIscfMOZS3TESJfoHzgX72inrn0aB6yGuyG01i+MojIO4DQbUq
	fTFMzKj85in7rYTcePgghxnzOzohroN+sFvzGBJeOYWqGdXo1o7Y/7GnorIBTG7h4Wnbj5Jv/9x
	BFtT0rg0A6Kyc4cNc5Yw2CliJ5rx0Fd0h3OxqDX8kmC7nnajrEiGczy5TVItOIay02RZNhFOz/v
	nFZDDiX6oJBo8wWC6ar30CLy41Sb0KA5ozW6NOjJzkDuOH7aPIcd5GWMNx4WM2CvRQH2Fy53Rl1
	kIpHNyEiPyw3kAH2oQ+aSQ4AttYAJ9X0IhwTObOFofeGKXaUZ/R4VzxfuFwFhOe0DsOt6LH3P0g
	QvqE0By5Sdg1Xp/RCzZpvMrzI1SY/DTIsfGxCGCMihlr3MunxkSrNRyJNRkloAjFv58LzPNDy0K
	K2kqFTJGN7qvQIDPikPo0PEQPy1xN4UicSLxbi3R/j7k38VS5Cs1NE=
X-Received: by 2002:a17:903:41d2:b0:2ad:e521:28cd with SMTP id d9443c01a7336-2b06e3ee3f7mr36706635ad.36.1773838614042;
        Wed, 18 Mar 2026 05:56:54 -0700 (PDT)
Received: from ?IPV6:2408:84e2:440:5e9c:1dd4:d6f4:257c:2380? ([2408:84e2:440:5e9c:1dd4:d6f4:257c:2380])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e608a66sm26149695ad.61.2026.03.18.05.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 05:56:53 -0700 (PDT)
Message-ID: <4807e460-054c-49ed-9792-f5000d7b3820@gmail.com>
Date: Wed, 18 Mar 2026 20:56:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <CAGsJ_4y+SwwCtDu8zPYnuSdyS+1=q77d1Fwq6eHbqrnw8-6K=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A88034000F
X-Stat-Signature: x5qhmp7e9pi53ptkidumc5wsu6z6sh4e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773838615-518598
X-HE-Meta: U2FsdGVkX18/6N0TSkXuGru+4VvXfMcJhhtsWiE+JtVsDkCJeT6aePODg/Y8uFJeQsH99gky8UlyKAng0DQtjPsCo876gRXNmsryL3D2WU82zEdN0jBsFeIJypDyACC8F2Urq8Y42ZFZdtzYTM50vqvHpcu4bZRoL3NnNEo47BsPdEHf83TJIYymkqPBq47Ah+hEd2MupuvAYJ/HZO+vBlk58EPOAryV9kHqZszoJI8RSpWSOXgQZMuIg8ApJnJ5158vXWYTMWi9R5cY0gd1aY6cfHUVesAT4PBn5Yo2TkhvzvaHVLJD+n2cIA7DwxdWiQw69eXNW/7vjTJPENUuJeUy9+YtyYVwe1IUaws8ew0G6yZGMm4yWAH+HBo2lfrUVo+BPEtzcEGGlGC/qWwYwIZcozzgP+HvmxO4UVe6UlUW2cqaPzF1gfNUubzPtzo9dndbKZ3l08olN05RTb2I+ZLJKf4+689zR1phqNxV2Y9XEdNMBnbrWe/HwAjn0+xo4iYpn80Pax5x8TiTqQb+jZASmPj/v1oQjX4vvkyxvrIU0P2PmzYXT0HFOw103nq2yvDRDbVm2mXpc5PVFTINrcb7PzNHmRHdoMv9cHMORMlm240vpj7MwvmaA4W73d3PGpOQ2IX7Dmgd6y0b6Ekx+Gk9gxSr6BxBYogG+Hx5mkGpPwPe5dY99kll+Tx+lAvnUrwlwsC+EWSe6QYp7EUXibMlgMlV3ffBCIEBq/c8ZvNcVNfxtF0oAGNN9m3xxFqrCv9CDSTQiCqO9Lfdvf2EFEr1Ot9s0e6/JPKifyZSZYRsH0+3GW0w1hl5tJqoHBBCe2tHkZvXgfb0o4Oo2RvWZawqnmoVraem5kUhJZzeDI6QoPanZfg0z2sajHgaaC1PboYQFYm/EaPG43kdovPi4ivdORwCT6GGLufXckXug3lGzAOQ6MA/3RnJiefrPf1gx2fyU81DWXvTczutqNc
 CmtcjFgK
 60q83ejM/0XjlADnmsKVIc4yl2mIhQxpX6Rtp0CAhP9gECXDRBMG/7Rynnwq4RBHZpqvk9YPq2Kt91l55nO33V4LJKmCTpi+fT9IOcTXIK00Wgd5HSSVSdy5/H8Sqocadsl/RT/K+u/9X3gdePEliodyy0gL8tO5IB4gEIHPSBx9P0HuM2p5dPcEjVEgcYwj3my9VZFyoUZ83MneAH9QitE00CJjwauWTwFVn169k9QSmEnmRA7CeNAe1NTJ1hNkd1ahh6SbnM8sSczNVnucHY41qYJNh+hQmcbrxZ6/GsnqlxRVftFofWelCL8KN+HnUtaTDb+B4t0c+k5A5H6wQ5LCjeSC7Zidl9PYcWr5ImSKWnfGZnG4NZj3yIGhdM/F14/nFfQOMSY+lQOn5uTne03cVZLOaiDCRtqI/Y/YSs6oDQeA+1EnHx4B1uOkObRGcM2TcI8tP//JGvRkDmoApOLcH2V1vo/lGiEMf0L7a3YLhBuoKY2WUGViJ3Lb7jBs2rYJT0EO19RsWlJFmOQAbs648fm6LpWoENvSOlhQfj/q2L5z2gsCJ5jSBTRsS9kaV1bjg
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













