Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E901088E6C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBBA26B03BA; Wed, 18 Mar 2026 23:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C9D6B03BC; Wed, 18 Mar 2026 23:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B526B03BD; Wed, 18 Mar 2026 23:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 912E46B03BA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:14:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35E911B75AE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:14:21 +0000 (UTC)
X-FDA: 84561344322.20.8E0916F
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7706B40006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:14:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eyv7fCfR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lenohou@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=lenohou@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKvMcKFaJqWhdEDJm7I22Ycbq4zxryzlgrB1A0RyvyY=;
	b=K8TXx1MK7BelxpcTYj6FD1+tHHfnlLsqJrZnton0ekElFr4TwbMgLUqMwCR20eIgm1nFe6
	tzr2p238RxrEyV8uPSDxzTCcToE0e6o2isqM5F6gk/te1C8Ro4a6k5x7H1ELtbmOVXVg+L
	iECP3I1iVWXl8tzrGal0U+q8vAKxiq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890059; a=rsa-sha256;
	cv=none;
	b=NL9gvUGcVXTkK8G4ChYG7pS1C8uA6WkYD/54bO1jjuYrZ+w//0feeKAL2jbl2zXQXwLQ4z
	93AwQJ9Lrks15Bm+xgvXfJSl1Gg7zFEj1zbY23qtGycS+zK1oPFCKkJPjrBYKrEv3Rgtan
	Xbw/q0NNY5OpJjOQDeyu1tIJTeexQhY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eyv7fCfR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lenohou@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=lenohou@gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so98661a91.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773890058; x=1774494858; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VKvMcKFaJqWhdEDJm7I22Ycbq4zxryzlgrB1A0RyvyY=;
        b=Eyv7fCfRwehCEEBs+yeSe/zFj5YXNYes5a+TZb3OKjBiebPju5tSR1PaZxsI1xoH4C
         Jd3VYJFE2b4KyGceWJB3GxZQIHjGbH1lDBR73hYK8OZ40NiwImbU04Hm9o4tiPDcMIbs
         /Nb8leXI70/qC355iCHkjVfKQpb4K+nV0lbBXTa8I1KT/abTE8JLpll6akaKKsHW6TGB
         VQqv7Hf4ErzpnyHV0VJtAjR0sRTZHDgI7QNoO2m8VAhxGiIVVSjk+TyAOirsRTA/C8Ut
         xF2BR25zUMfn9T14PGSbISl31kkXVM+GbNV4Hbh9GoXAuCcQrWDhgF35GKbS65IOJ4o0
         xeeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773890058; x=1774494858;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKvMcKFaJqWhdEDJm7I22Ycbq4zxryzlgrB1A0RyvyY=;
        b=emxpBavDKRTHXAaPGnXu670lhP2nGEwd4V6/pdrslGv7laVPwBJBXrtX8/rpK5Noxb
         xNH1QbX7jo6NROShniQN9T2+g+BBujo5N1aXSvQXQ93XsFa9588uWBMaRNrxRk72ph7k
         5NwG1vHvfaDSuPUwINtA6VFlos3maincJXXzJVYuxL3b0UtYE/kz72ZfoJs2AsmNMVcq
         bbm48kWC1JwBMpFp9yP56T9qSIKHTXilg2/3aqZAL6wUjbbqtyWxswDkENCCvRjNRPqk
         VoHN03zAM8IYNMHZrKucmJ2Cu3Bdw3A1BDE7CRXLVvACuDsxVF3ntU3/giXiWri+4330
         zLwg==
X-Forwarded-Encrypted: i=1; AJvYcCXhiGUmt8BSO0b9WifxkEWBbfxemCoUkPLemxmYbwCbRIjV4RFyxd8X/f9zZ/h6KE+ZAc/pjJ/N8w==@kvack.org
X-Gm-Message-State: AOJu0YzNoIdakH1Xqwm7oGkfvGFpjJ9TIPuDqzn8PMEVYGS4hahX69N1
	aMxvX9DCL/8/4fRNvTE5+FPAhyFZH0HutwyBuqyIB8+cMKR/hR2m/tBG
X-Gm-Gg: ATEYQzzHpMmsLVFEERjGKcwLQCfhkoB36cIn3cH0qr8AdMQrOc0XLIkBBoaO1RlM9UD
	tVXAdCIBW3SzwdMMWQLe6EOcdUQ4vX4l2rkkFTxSk1m5b9J+3T3k0ind7qeBfq3dcPm7s6tSnq7
	zSHWp4IKV1uWxNZooxhH0sbMzS6FSNncLRwdwh8kfgzlTV4eJWQE/rmRrJEonN/xMxWzXFPczA+
	ajxe5uE8MwpkISN/D7boElgUSga0HGfLqRF6+NAT/VAl7ORTBpYDikcalk53lPKK1+XOjAoXzuQ
	MQz55Kh2W9ZD60Hn+JDAdQoIm1PbIGtECX88RB5DtSujOS7PXJ1x1MePN4zplXZ48aEj3fa04mL
	kbbgzVeSqBcik2vAjFNF8RrPsRGLuuv+CrOUBM/AUaFN3Ss88TwLfkSO4RBXMVUfUMa2qKXYpvs
	JDcCD6WRZX7/pjj6wfeWrTT5O3UrU23oQ1LloavKry3TaJ64EJSnT4RObl6Z2leJlRzDIUaUlps
	d2MVAHDNXZiTDnRPhxHQswooxac+/pIysdiEoT7woMq4G9aSQ==
X-Received: by 2002:a17:90b:2d4f:b0:35b:96bb:47b5 with SMTP id 98e67ed59e1d1-35bb9e87d51mr5385781a91.15.1773890057825;
        Wed, 18 Mar 2026 20:14:17 -0700 (PDT)
Received: from ?IPV6:2408:840d:1c00:46ad:3de1:fd36:5f98:c03? ([2408:840d:1c00:46ad:3de1:fd36:5f98:c03])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc610c1efsm1113203a91.14.2026.03.18.20.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 20:14:17 -0700 (PDT)
Message-ID: <f27eee3d-e8d7-420f-8525-b0f94706c0c3@gmail.com>
Date: Thu, 19 Mar 2026 11:14:10 +0800
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
 <4807e460-054c-49ed-9792-f5000d7b3820@gmail.com>
 <CAGsJ_4yZEOS+Ht38hqeUGnzLktuVUfvCgusqS4JQCb34eYLXYQ@mail.gmail.com>
Content-Language: en-US
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <CAGsJ_4yZEOS+Ht38hqeUGnzLktuVUfvCgusqS4JQCb34eYLXYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7706B40006
X-Stat-Signature: txe6j75rx4e8pmypfaq3if9864oxzzdh
X-Rspam-User: 
X-HE-Tag: 1773890059-104448
X-HE-Meta: U2FsdGVkX1+6gxmpHaHHhGKG8rrjqVHnv3gnsLHU8ezTJQJ4uyV84II7bx2uRcZ5VmD6mNz+2SnO2JEuWcIROdqYUVXVkCHJ/sT/+TdJctS8apE/ih0h/kixr/0+njnSNNDhkSPfXIU5f1DMIEZ7CDptvpt4w+/qk0r2al72IIT3JA4Lk2CM0JyxutAWP/axAI2oT+P4N4CAitJx61m9wqa0sTBBh3mKE6hOUb/hCv2oHQI9xKebBnrSaQzCu01kFPtgvslZ8x9yiWrZT5WSaOyEiAhU/GJuJWn+hIzvVVj3MyC8OFyOZdrSYU8FTQKKuZNLmmxxZUkzKTj05FP9DhCwXgkxMK+GmZ/bMe3T7YkJIx7A+LtoTCT55oO/eJ9M1F+Aa3J8BapSrreIWEYhHIqNCVmP/KP8FBzhysUBumdotRbgN/+t5iYhEtoXH+EsZp7q8iX36dbXR5QgnntxdabLJH85V4bHP4lFwwbpcKYIaW+eAO2+8e+X7zA4R6rVySmbd9SOakQRul2jLReSfqohsIu0w95afklWiJXJyEecynQ0sia8jqOSPmwctgZ/KDZrlMdOqMqj4Zlo/jeXt3unh6rAJ6QVkb9n2iqZqMr1nfT1+T5+zNoP43XnOYOs8Oz4igruWq3rtNeqTo8192Np3xBQeyVfOGdN6YOCcZb6ldiCeEh/U5ivnVLR9BzSXSi68FsLqPPEagsy0EDYIo7ac6P9zdh9ISuSYUdl13tTMPX4cx34nM/q9CTFWIZV+wF2QOmFLvANKfPuE+aPe4pM1/uF0PQMFpET75/yhUMoMzxsAb5vIpjox5/iwFQn7FuL5ddmQXztpglj5na/MI5886w5H05dP78mri36jRQL955so/MorBeM8znRpOMmp6etJGFrNEMKZ0Ti/DyyBQFe3W/shn/Q5uHNDwPzoyyEHs7/v4axXwkJ6mkR6ORiOiWVlp64xgNqVZ8nU3L
 ZsRTSIgY
 ESaXtJWBnXIf5P+IAIg/bVjKdZQCkTridHnJRlBWcn7kS5s+YDV98JoMyQeYqenecNkpcYuXGvsuIfgSFwihVcSwgMr8gLF6HXbjdwNYgSonOslAG+mxoxml1eqGA0XQYSnGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 5:29 AM, Barry Song wrote:
> On Wed, Mar 18, 2026 at 8:56 PM Leno Hou <lenohou@gmail.com> wrote:
>>
>> On 3/18/26 4:30 PM, Barry Song wrote:
>>> On Wed, Mar 18, 2026 at 4:17 PM Leno Hou <lenohou@gmail.com> wrote:
>> [...]
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index 33287ba4a500..88b9db06e331 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>> @@ -886,7 +886,7 @@ static enum folio_references folio_check_references(struct folio *folio,
>>>>>>            if (referenced_ptes == -1)
>>>>>>                    return FOLIOREF_KEEP;
>>>>>>
>>>>>> -       if (lru_gen_enabled()) {
>>>>
>>>> documentation as following:
>>>>
>>>> /*
>>>>     * During the MGLRU state transition (lru_gen_switching), we force
>>>>     * folios to follow the traditional active/inactive reference checking.
>>>>     *
>>>>     * While MGLRU is switching,the generational state of folios is in flux.
>>>>     * Falling back to the traditional logic (which relies on PG_referenced/
>>>>     * PG_active flags that are consistent across both mechanisms) provides
>>>>     * a stable, safe behavior for the folio until it is fully migrated back
>>>>     * to the traditional LRU lists. This avoids relying on potentially
>>>>     * inconsistent MGLRU generational metadata during the transition.
>>>>     */
>>>>
>>>>>> +       if (lru_gen_enabled() && !lru_gen_draining()) {
>>>>>
>>>>> I’m curious what prompted you to do this.
>>>>>
>>>>> This feels a bit odd. I assume this effectively makes
>>>>> folios on MGLRU, as well as those on active/inactive
>>>>> lists, always follow the active/inactive logic.
>>>>>
>>>>> It might be fine, but it needs thorough documentation here.
>>>>>
>>>>> another approach would be:
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index 33287ba4a500..91b60664b652 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -122,6 +122,9 @@ struct scan_control {
>>>>>            /* Proactive reclaim invoked by userspace */
>>>>>            unsigned int proactive:1;
>>>>>
>>>>> +       /* Are we reclaiming from MGLRU */
>>>>> +       unsigned int lru_gen:1;
>>>>> +
>>>>>            /*
>>>>>             * Cgroup memory below memory.low is protected as long as we
>>>>>             * don't threaten to OOM. If any cgroup is reclaimed at
>>>>> @@ -886,7 +889,7 @@ static enum folio_references
>>>>> folio_check_references(struct folio *folio,
>>>>>            if (referenced_ptes == -1)
>>>>>                    return FOLIOREF_KEEP;
>>>>>
>>>>> -       if (lru_gen_enabled()) {
>>>>> +       if (sc->lru_gen) {
>>>>>                    if (!referenced_ptes)
>>>>>                            return FOLIOREF_RECLAIM;
>>>>>
>>>>> This makes the logic perfectly correct (you know exactly
>>>>> where your folios come from), but I’m not sure it’s worth it.
>>>>>
>>>>> Anyway, I’d like to understand why you always need to
>>>>> use the active/inactive logic even for folios from MGLRU.
>>>>> To me, it seems to work only by coincidence, which isn’t good.
>>>>>
>>>>> Thanks
>>>>> Barry
>>>>
>>>> Hi Barry,
>>>>
>>>> I agree that using !lru_gen_draining() feels a bit like a fallback path.
>>>> However, after considering your suggestion for sc->lru_gen, I’m
>>>> concerned about the broad impact of modifying struct scan_control.Since
>>>> lru_drain_core is a very transient state, I prefer a localized fix that
>>>> doesn't propagate architectural changes throughout the entire reclaim stack.
>>>>
>>>> You mentioned that using the active/inactive logic feels like it works
>>>> by 'coincidence'. To clarify, this is an intentional fallback: because
>>>> the generational metadata in MGLRU becomes unreliable during draining,
>>>> we intentionally downgrade these folios to the traditional logic. Since
>>>> the PG_referenced and PG_active bits are maintained by the core VM and
>>>> are consistent regardless of whether MGLRU is active, this fallback is
>>>> technically sound and robust.
>>>>
>>>> I have added detailed documentation to the code to explain this design
>>>> choice, clarifying that it's a deliberate transition strategy rather
>>>> than a coincidence."
>>>
>>> Nope. You still haven’t explained why the active/inactive LRU
>>> logic makes it work. MGLRU and active/inactive use different
>>> methods to determine whether a folio is hot or cold. You’re
>>> forcing active/inactive logic to decide hot/cold for an MGLRU
>>> folio. It’s not that simple—PG_referenced isn’t maintained
>>> by the core; it’s specific to active/inactive. See folio_mark_accessed().
>>>
>>> Best Regards
>>> Barry
>>
>> Hi Barry,
>>
>> Thank you for your patience and for pointing out the version-specific
>> nuances. You are absolutely correct—my previous assumption that the
>> traditional reference-checking logic would serve as a robust fallback
>> was fundamentally flawed.
>>
>> After re-examining the code in v7.0 and comparing it with older versions
>> (e.g., v6.1), I see the core issue you highlighted:
>>
>> 1. Evolution of PG_referenced: In older kernels, lru_gen_inc_refs()
>> often interacted with the PG_referenced bit, which inadvertently
>> provided a 'coincidental' hint for the legacy reclaim path. However, in
>> v7.0+, lru_gen_inc_refs() has evolved to use set_mask_bits() on the
>> LRU_REFS_MASK bitfield, and it no longer relies on or updates the legacy
>> PG_referenced bit for MGLRU folios.
>>
>> 2. The Logic Flaw: When switching from MGLRU to the traditional LRU,
>> these folios arrive at the legacy reclaim path with PG_referenced unset
>> or stale. If I force them through the legacy folio_check_references()
>> path, folio_test_clear_referenced(folio) predictably returns 0. The
>> legacy path interprets this as a 'cold' folio, leading to premature
>> reclamation. You are correct that forcing this active/inactive logic
>> onto MGLRU folios is logically inconsistent.
>>
>>
>> 3. My Revised Approach: Instead of attempting to patch
>> folio_check_references() with a fallback logic, I have decided to keep
>> the folio_check_references() logic unchanged.
>>
>> The system handles this transition safely through the kernel's existing
>> reclaim loop and retry mechanisms:
>>
>>      a) While MGLRU is draining, folios are moved back to the traditional
>>      LRU lists. Once migrated, these folios will naturally begin
>> participating in the legacy reclaim path.
>>
>>      b) Although some folios might be initially underestimated as 'cold'
>> in the very first reclaim pass immediately after the switch, the
>> kernel's reclaim loop will naturally re-evaluate them. As they are
>> accessed, the standard legacy mechanism will correctly maintain the
>> PG_referenced bit, and the system will converge to the correct state
>> without needing an explicit fallback path or state-checking in
>> folio_check_references().
>>
>>
>> This approach avoids the logical corruption caused by forcing
>> incompatible evaluation methods and relies on the natural convergence of
>> the existing reclaim loop.
>>
>>
>> Does this alignment with the existing reclaim mechanism address your
>> concerns about logical consistency?
> 
> My gut feeling is that we probably don’t need to worry
> too much about the accuracy of hot/cold evaluation during
> switching, since the system is already in a volatile state
> at that point. So as long as we avoid introducing unusual
> logic—such as forcing active/inactive decisions onto MGLRU
> folios—I’m fine with it.
> 
> Ideally, we would add an sc->lru_gen boolean so we know
> exactly where the folios come from, rather than relying on
> folio_lru_gen(folio) != -1, which can be misleading.
> However, if this doesn’t bring much improvement, it may
> not be worth increasing the complexity.
> 

Hi Barry,


Thank you for the guidance~


To address your concerns regarding readability and maintainability:

1. Naming: I'll rename the transition state to lru_gen_switching 
(instead of draining) to better reflect its purpose.

2. Documentation: I'll add the documentation to explain why we disable
look-around optimization when LRU is switching.

This approach keeps the patch minimal and fix for the OOM issue during 
switching without introducing complexity.

See next v5 patch later.

---
Best regards,
Leno Hou



