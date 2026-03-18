Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AD2FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403826B011F; Wed, 18 Mar 2026 04:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB906B0121; Wed, 18 Mar 2026 04:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F13C6B0122; Wed, 18 Mar 2026 04:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB4A6B011F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:17:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30E31D485
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:17:08 +0000 (UTC)
X-FDA: 84558478536.14.1D8C34C
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5E9D40008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:17:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ze8TfuSu;
	spf=pass (imf11.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773821827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WLb3z75FyW4V0wEi4APXz2nEEb3hslQr/9K17bOZZ0=;
	b=Gktsdh6kWJv60a9zue8FWjhoDu8mvxVVsA+0ZLqp/w5/oMDFG+mzUe2fPohu55BXoK2gWv
	SvI2AsRM0d18H4trHwUzyDo9j8gNVk6MHykdmeVwT7VDfhqWoteQd6YqG3ZNGo7QxazGhJ
	rbgPTBCkNjoAjNSbbGOBbFBnGQK+Rto=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ze8TfuSu;
	spf=pass (imf11.hostedemail.com: domain of lenohou@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773821827; a=rsa-sha256;
	cv=none;
	b=SdEzns2jz/zmsRH6tH6qUGN4zM/ovmpdg/QjhBVx0ZPs/9V22ZRqEFGOhMLkgDsN5EjOOY
	dnVJfDV4SDdKWGQHcZk67aTlHvXljuFqkuq0KvN9AMSLYN4pjxqVGRpuAKyUA92+3bgQOp
	9UCCHk9PizVubptKTtd9IxuG4QU98jw=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-829a568f3ccso358336b3a.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773821826; x=1774426626; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1WLb3z75FyW4V0wEi4APXz2nEEb3hslQr/9K17bOZZ0=;
        b=Ze8TfuSuJaxOHAyKjY8jsp5e2sxC2VDxZCkcZwaGWUfbWANC7was7yBMtjfzOJK6G3
         8tszorY4+2z6c4lzmiKn+KsrXHDzIxpogr6Bx/CBVTbM7DUbt1V+E5QHRqSn0zbWCZ2E
         G+gQ1eyKQe5lKBq5dhvle1PPywtS3/FP2auq2piNpysNrweGh0IqGhSRUhCn8oqaIuXg
         /bQfIJDmCn0Z00eMHouxzv8M6F4Jp3ZxNu194pH2JRrGIiAwKKLMahL85hIrT0hhpH+K
         5+ZhRxP06/gw4cYxUaYExhNhi5P+sW5pN9uOaC2HKZE1/5xKwP9l+uuUGk5etmF4EpGi
         1Faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773821826; x=1774426626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WLb3z75FyW4V0wEi4APXz2nEEb3hslQr/9K17bOZZ0=;
        b=FafPwDzRqWHFi+qg1zO3gdAMsb2GHwhYNWe/nCFbNuQzH7WyaJWmA0yJfhDCb5Tg7R
         MHJE/y5QuzG+2wc2wbg93FeTXz5qRAZgZrgoCXivq3e54XaOH6XpR0UGJ16lLyRfsQPR
         qFSi2SVnIKkbcPzCh0I+h7AM2ZXSps2kFzI4+y/2KycYiY9ECMsa1C+L8wzyMhFtbBJ/
         HubopEZ0a7F3Hf80ilMkbTAch0C099g945rMiVkbXeGoch6JhQW8JsKU+BUDDUhLhD5d
         F8Z8sTu+dAA4X/SLjMjj/zdW9SKCKG1j+MJjdVHOxfv5P0DX9iCy8n4IadoWeN97bRLi
         Apfw==
X-Forwarded-Encrypted: i=1; AJvYcCVFoTLWtVlavEqxrJA8dYygrtOGvAohx8vRCGAxmRTxZVUSIczQXQvz6HaYflP9TETVvC4byL2Byw==@kvack.org
X-Gm-Message-State: AOJu0YxcfhfSZ5M7KmEITG7+QQOUxXeWO6MxpNV1tAgN8c+HZDCDxH8s
	eF7b06aoc3VHpX4T3E3q+wyVFKFuuLRqPcA6o09wEs2Qq09k+5Avt6JH
X-Gm-Gg: ATEYQzyezs4WvJ8KB/s6TP8fEU5uXJrYZ1xPb2VU+Ny1H8EvjQbYVAXYZweTkJ/4Nm8
	E9f1ZMW42+GRa3lIcROoCflLm94165G78NyK93+E0CTjN4kuIFNsU1AvXNKAu0CkTViSAu53DN4
	QjeZPMw2mP48hLKE9ATMS+EvEkH4cY0wt2v7x8txnksyPsUQOnxdjILxNKnUX10PF8PDF89UbTc
	gHRtSRdDgc0cvcxPAFiX/YbJ6qnrlth1+VX+SyiNkVMs28hmqSmFM4vY5/vu1XC9av0mIOLA3oy
	XHLafcoa+EkiXPFNn0UVcmES9vjj/43zpVRovx/n7JMBddF25hklFYDEk5pKQKkhITGUGkX48s2
	2KZT07IJOTuIyOqVeV8Ap0fIwBwG9axn7sGIvy7+Oldj1OtfugLyqzH2i4SoC9lvbEhmjBiw+7Q
	ssjZ6Bp8qEMsPInPqgryizsClm2mjdzBtExKumxpGLhm3NXvp54hwwrK3n9yEP4j5NtDHL0V/pN
	8NImlKdW03rAQCSxIVvglhGkvYEH4FLeFCPm0VN2F53
X-Received: by 2002:a05:6a00:198c:b0:82a:110b:e212 with SMTP id d2e1a72fcca58-82a6a8ea5c3mr2384304b3a.0.1773821825209;
        Wed, 18 Mar 2026 01:17:05 -0700 (PDT)
Received: from ?IPV6:2408:84e2:440:5e9c:59ce:3c05:93bc:f8f8? ([2408:84e2:440:5e9c:59ce:3c05:93bc:f8f8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6af06bd7sm1822165b3a.0.2026.03.18.01.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 01:17:04 -0700 (PDT)
Message-ID: <8c01a707-f798-4649-8441-d82dd0dac7b9@gmail.com>
Date: Wed, 18 Mar 2026 16:16:58 +0800
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
Content-Language: en-US
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <CAGsJ_4xHvtjkPp5Ar16UXqZhQYHpdYcqCWMmFbGGUvK-kCH+uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5E9D40008
X-Stat-Signature: tkujff6om9ggf3xpoabj9bms5bdak6f7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773821826-698591
X-HE-Meta: U2FsdGVkX1/4OeGTmop5nQnE6Prc6SGBCNjoI+J4/EBAO0U5j9ioOyGVoqgTY56nq3kGEzxAA1TzBpI4P05HqYIU+W9D9BN4Jd5XpZzjnlDLJSzjbkovnHuH3Gt+J8wDXfF+VoP/EbAgfA6660cQiKgtB/+tdkGy5nwsYmYYaBobBlOJdaXGLSClc5R5ecA82M0fhUfkBcRZ1s21zOxlYZSQ/BPfOXlkX7iGIpNBKrUiTwL1ObG2r+dJbgZ/pJ3aDoEEhSf15eZKJ5eguN2ybYH8+wHuUnbGsGOXzKaOIi67v5rCOL/lc2KtAS2at0e92TjuYRNDY8caMixLYcHDxVVjgZg6RkALpPnN2VhxYLTgHIKYl6KmsQTc1o3ZTil0Sbd9d4FExBDMaPYcHHb7xxJE7TZlrdP1BUOsqs55wezXjuDSXZoZ2OyVmLpS+W4eVXTSHSgAjFBJwPW2qF+pI/CGQH/wWbEpdxO75mrpGtEjRy2syQzgbNRMQwrs1e+cxuoiSC0VlCRYwnq/5pcf+l5jYqjeKKlaUrGEAb1c70V4vOLHhQEOWJ4iRtk8bx1+iasRxyVdQOq6/ncETo3TmhawVrtTQ/Thnz8iUfRN6iZV6s6vKngLIRo4PaJPgJrXUr7mWfPlxJAtsF8gNhoIleBaUF94vk5nAyJrxrnlz5VPYpzyXAAU55GfHdq/7LYBWTR287NQsA4n+LV+RVvhy4rrH70iDl3TgEUFBwoXqf+N3gFENnhRrWcZRKCNViqE7Ta3Ycw5tsZvvAFW8Go7rdarf26nyA6W6cm4br0NKAjO4llhGJBgoS15RhF2whHka7DV80GlkPlqGof3nOORzZhDLwHRv13kCLkPy5xuLFLgCTV0oMKQi2OVuGVRRbkkGFk24AAKWenwSO/CgikRVeoSRbuShyVdpH2HscwntnAcTxwVgd4ZKMJdC5YUSkyf3vhp0XnNTHAIgtWroge
 c1FiitPF
 1M2svQr04Pbr4q9cOTNj/l9dvht3kfP3JQebKCILbKQ4ysB7BODtX1GJFaTk4CwtgzDkrySrLcwdax6rBbzxncl4Sw9igjUQTLppp+91EmuvS73oMIzaOP50zPxxGixAvz87TSzSrhIRtwk2zeDJaZOgWy3JZ78bBbRo81Q5fNawE29hj5+eVRYH+uAvoU4yv4Sh2lHRnofCF4pAFk9W0I07LJgqM4rAFJos95TZZMURHzYvcxs+9H2HR0dZtQUld0rVzf/0c8P9/lKIrq1NSZIUeit1NgHYhXn4pD/0vEoFZsTxPbOmC9ve0XE37ha/XI6hnwPd6k7IuNiG5VmxltZTJcuo3YZuVUKFLKCmq9D+rjU7T0FdjjT0OrJIg8fZyzz42TXqEpuTSqY+UA1EvSLgJcUGB7d+dCeXv3d08CPJZrUgXJ4BWTySbmbz71kwPI4EUFbigVw1AuOjussIdu4HjWTNYWLmCPCDop0kj7RQrpldY54unkC9Mj1mdhur6joNieT7nk7AfK+Kig0ScVgM1Gwccqd6FU0q0PLi6BjloY+jSQx3Xvy0gzVyqBv53WTRfHhKo00Etq2N2nxbnbTKJGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 3:16 PM, Barry Song wrote:
> On Wed, Mar 18, 2026 at 11:29 AM Leno Hou via B4 Relay
> <devnull+lenohou.gmail.com@kernel.org> wrote:
>>
>> From: Leno Hou <lenohou@gmail.com>
> 
> [...]
> 
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index ad50688d89db..1f6b19bf365b 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -102,6 +102,12 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
>>
>>   #ifdef CONFIG_LRU_GEN
>>
>> +static inline bool lru_gen_draining(void)
>> +{
>> +       DECLARE_STATIC_KEY_FALSE(lru_drain_core);
>> +
>> +       return static_branch_unlikely(&lru_drain_core);
>> +}
> 
> Can we name it lru_gen_switch() or lru_switch?
> Since “drain” implies disabling MGLRU, the operation
> could just as well be enabling it. Also, can we drop
> the _core suffix?

OK. Next V5 patch will be:

+static inline bool lru_gen_switching(void)
+{
+       DECLARE_STATIC_KEY_FALSE(lru_switch);
+
+       return static_branch_unlikely(&lru_switch);
+}

> 
> 
>>   #ifdef CONFIG_LRU_GEN_ENABLED
>>   static inline bool lru_gen_enabled(void)
>>   {
>> @@ -316,6 +322,11 @@ static inline bool lru_gen_enabled(void)
>>          return false;
>>   }
>>
>> +static inline bool lru_gen_draining(void)
> 
> lru_gen_switching()? >
>> +{
>> +       return false;
>> +}
>> +
>>   static inline bool lru_gen_in_fault(void)
>>   {
>>          return false;
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 6398d7eef393..0b5f663f3062 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -966,7 +966,7 @@ static bool folio_referenced_one(struct folio *folio,
>>                          nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
>>                  }

OK. I'll be add following ducumentation that just you said.
/* When LRU is switching, we don’t know where the surrounding folios
are. —they could be on active/inactive lists or on MGLRU. So the 
simplest approach is to disable this look-around optimization.
*/
>> -               if (lru_gen_enabled() && pvmw.pte) {
>> +               if (lru_gen_enabled() && !lru_gen_draining() && pvmw.pte) {
> 
> Ack. When LRU is switching, we don’t know where the
> surrounding folios are—they could be on active/inactive
> lists or on MGLRU. So the simplest approach is to
> disable this look-around optimization.
> But please add a comment here explaining it.
> 
> 
>>                          if (lru_gen_look_around(&pvmw, nr))
>>                                  referenced++;
>>                  } else if (pvmw.pte) {
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 33287ba4a500..88b9db06e331 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -886,7 +886,7 @@ static enum folio_references folio_check_references(struct folio *folio,
>>          if (referenced_ptes == -1)
>>                  return FOLIOREF_KEEP;
>>
>> -       if (lru_gen_enabled()) {

documentation as following:

/*
  * During the MGLRU state transition (lru_gen_switching), we force
  * folios to follow the traditional active/inactive reference checking.
  *
  * While MGLRU is switching,the generational state of folios is in flux.
  * Falling back to the traditional logic (which relies on PG_referenced/
  * PG_active flags that are consistent across both mechanisms) provides
  * a stable, safe behavior for the folio until it is fully migrated back
  * to the traditional LRU lists. This avoids relying on potentially
  * inconsistent MGLRU generational metadata during the transition.
  */

>> +       if (lru_gen_enabled() && !lru_gen_draining()) {
> 
> I’m curious what prompted you to do this.
> 
> This feels a bit odd. I assume this effectively makes
> folios on MGLRU, as well as those on active/inactive
> lists, always follow the active/inactive logic.
> 
> It might be fine, but it needs thorough documentation here.
> 
> another approach would be:
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..91b60664b652 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -122,6 +122,9 @@ struct scan_control {
>          /* Proactive reclaim invoked by userspace */
>          unsigned int proactive:1;
> 
> +       /* Are we reclaiming from MGLRU */
> +       unsigned int lru_gen:1;
> +
>          /*
>           * Cgroup memory below memory.low is protected as long as we
>           * don't threaten to OOM. If any cgroup is reclaimed at
> @@ -886,7 +889,7 @@ static enum folio_references
> folio_check_references(struct folio *folio,
>          if (referenced_ptes == -1)
>                  return FOLIOREF_KEEP;
> 
> -       if (lru_gen_enabled()) {
> +       if (sc->lru_gen) {
>                  if (!referenced_ptes)
>                          return FOLIOREF_RECLAIM;
> 
> This makes the logic perfectly correct (you know exactly
> where your folios come from), but I’m not sure it’s worth it.
> 
> Anyway, I’d like to understand why you always need to
> use the active/inactive logic even for folios from MGLRU.
> To me, it seems to work only by coincidence, which isn’t good.
> 
> Thanks
> Barry

Hi Barry,

I agree that using !lru_gen_draining() feels a bit like a fallback path. 
However, after considering your suggestion for sc->lru_gen, I’m 
concerned about the broad impact of modifying struct scan_control.Since 
lru_drain_core is a very transient state, I prefer a localized fix that 
doesn't propagate architectural changes throughout the entire reclaim stack.

You mentioned that using the active/inactive logic feels like it works 
by 'coincidence'. To clarify, this is an intentional fallback: because 
the generational metadata in MGLRU becomes unreliable during draining, 
we intentionally downgrade these folios to the traditional logic. Since 
the PG_referenced and PG_active bits are maintained by the core VM and 
are consistent regardless of whether MGLRU is active, this fallback is 
technically sound and robust.

I have added detailed documentation to the code to explain this design 
choice, clarifying that it's a deliberate transition strategy rather 
than a coincidence."



Best Regards,
Leno Hou


