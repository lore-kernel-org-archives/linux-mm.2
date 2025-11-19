Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CF1CF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC816B00BA; Wed, 19 Nov 2025 08:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACAA6B00BC; Wed, 19 Nov 2025 08:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BA96B00BD; Wed, 19 Nov 2025 08:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 346E56B00BA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:41:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D49C813B087
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:41:11 +0000 (UTC)
X-FDA: 84127467942.30.788CFB1
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 058038001E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:41:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ScbSrdF4;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/bYghiR1NKi6Ugt9MldXXYgGqUjbAjc5MFUJnrN65w=;
	b=CWNANH5Bxzhg4zulP1f712m+qJRvbXJYCpk8iPNgFiQ4yebTq9NMregdt6Er3vLDZ+RtPV
	sWMkm4lGPeShhanaCoTrAL02REduuKa5sw8XRMT7V8bJ4sdVuOZsv70Ea0oxf+cNdAhBvS
	QQxVLAPl0ni4qoGjeRtFp0EDRwzJdgw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ScbSrdF4;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559670; a=rsa-sha256;
	cv=none;
	b=CHcRDBv1C8lxV4m4V+bAm6iVZdNeB5P0AKN6gLEhQM4lSh4AOFqzdr7aquWr6izktryZpv
	1kkjawLE3BC22xOrVKCqjPa16g0XZYPuYu2vV/d04LT5ov0/jmMay3ar03hRyjhHyv/IvE
	Njcm2QIYJVYPLS6PW5ypuYZCRfhkV34=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7636c96b9aso124949166b.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763559668; x=1764164468; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/bYghiR1NKi6Ugt9MldXXYgGqUjbAjc5MFUJnrN65w=;
        b=ScbSrdF4Ql5Y3ww7B2uD1O9zu9MooP84fMx6f2rsDTgexcALR3497sE2kiV9pxmcQq
         OJfuA8OIJGctYVk+D7TSpi4wWNge7Q9MH7WwSZxJZndbP/Mb97LDQ66c6x5PFHSnZ0RN
         sH1cZTrLalqyZNhXHXmINi7PU8ydaM1bUdItzzxzlheFqB68jkkZ6fZAMys0c6yVzx3q
         97RMxMsr2KZp9fS+9uq+qTr/570T4C2kp6no/yx//qe7Jm40Adltd8qBK6zO2Pn0GrO+
         IPrg2npoy7gHbKwuoqP6B0Yh7WMLHs5HUqV7RAjKKxEOppXItZOAvBdN3zcrGEQWxbhq
         NgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763559668; x=1764164468;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/bYghiR1NKi6Ugt9MldXXYgGqUjbAjc5MFUJnrN65w=;
        b=Zghk6wXi8jBfn9mg6jDeCx5L82b1W3PWBsMqa4knN0M0j6dMxuH8pkINEEHdg7pj7W
         PUE2MCSK5LtDrahrV4UJ66Z5YPMDuOzMSv5eLL8++hodbCCtbgYd4JsQO0q01tCR5O8q
         dVS2Xl3U1P85dlxRqEIHE/OmTFjNYdelWiYgnO7EY7Ve1W6hzBuz8/mncy/G2CRb2HX/
         KRwQnnaLdbPbsoEoctWky91ka661w/+Oh7Ba1ta/N3sODtyWQCLN1bK+XGS5vjBQVzxz
         PUSBN0Ae6v2r7pB5xGcwoCLIc9eE51cU5TSEXUMAkJ+lQx5HrQ/JDsGPvw86zGTatDqL
         7A+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOPFU0/dp3ycLSM9Olx7F6u1NYT0U0J1dSo5eBN91iSPH53u5WS3CiMwmh/mYEYjrGWeTuB5dipg==@kvack.org
X-Gm-Message-State: AOJu0Yyu61zKn9RRtoj5mOUWahsGEdKHdVboi55+30+JE5cQbeVanG9v
	Ux2RKd8NpChRSHQCZVIb3wZdKVAMUiB4khL2Ox83UmqYQZ9MEay7iz7h
X-Gm-Gg: ASbGncunViOxl/33psQILQO0sYFynP++ODqy0D0Jbwv8fAMbE746TenwSSKxzyMG9VR
	Gyfny2hLxJl4JIZzplY08HFvo3F9oUcU3cbb8s+ho6e/D/aPjRT/5WuT+qLR3ocTJ8gKWCUlYXT
	aohjPRVyZFRGaJIQaJrtxGak16+cfx3KrpG6pkczWrNAWLhmKMCwFgQSgIeJ7+ffm4Paimdvrik
	17Wpjjsm/wdH7mXZMV8vlcLt0PmpUE0EpXx/6yX4kxMGBXIY3Sh/bp7PchY7j4eAp0JpmFsGq1x
	F1Rg5PmQMPLG1BdymmI41V7Rp93XSmz16qDPf2vuukVgcfo3qEbM61Su68KTkb56Y3V8WXCPCdP
	23+nbscQseN5w25zgx2aZQmHfIzWO1wvCspiXZI5+rzkcKVb7969r7PLUmaNXua5SSdh36KOxjB
	gFlGpOA8ldEj1J6A==
X-Google-Smtp-Source: AGHT+IFLZtFqPwcZsXNVn485Ak8+kST95+upGdcVr5akj8JIUOsSoxuzBdGr+yhvA650LKVUGjHUzw==
X-Received: by 2002:a17:907:7b91:b0:b70:fd2f:6a46 with SMTP id a640c23a62f3a-b736780c18fmr2213378266b.20.1763559667699;
        Wed, 19 Nov 2025 05:41:07 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad45afsm1629403166b.24.2025.11.19.05.41.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 05:41:07 -0800 (PST)
Date: Wed, 19 Nov 2025 13:41:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119134106.t7jmnl2k5w265en6@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 058038001E
X-Stat-Signature: 6g87effaihuzwy7n6pojeezrc76izenp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763559669-841179
X-HE-Meta: U2FsdGVkX1+5EIXKFQdmHMt0T1UKEjuaVjEUrpxsuY9E1bSVcJmG51tG9VWqNAU9RR98ZlARy8mYHY/CMWYWEGkP3JuMGki6XEGKJsQ7ORwgWMhnn98wcDiZnSm9NbPrlEV8LxMUzpsTZ5xdPeiT8XKDK8cL+ku7bJzHKdRw9g8bS5KV5dN9UsXubQ+VQ1Gx8XHx83wUW/OjFzpoZCxIhl7FYNavCp54/B1bf5QFv0XPnJRjEE0+uZ50ANrq6JhZ2p/OJxilqw5YSsyr9zfevyJmB4qYUafWulh4j+FIsfDbrpHHL+G3KL0ezEOVuAvDO9GQxxBqXuSs08X1SltToyeDtBO/de82BX+sPENetgAd/Z/DYXF0IXXoMhREqhg8FAD9woBU0HgssQR5+kpDnTKwyHAy6Xaf45H54zqnYqV6SPLJHXCJUVB7v3jmAczQA2OJiCZBZuhAEmq81ml40g60aJJflHhEuOnz3ZpPtHkHzIisjiIlkBT0Uoi6dA9mar0qwPGz8r/BrnkcJGPxrL2g62wxzWPB+HG/zm/gs5Rm/ng0J7jmfGuUvl3NXEdpV5ZcY28PpTmXdpOozzYSq+mNRgT8aAj8n6DAm2cnmWZ2PuZq9h06JStmZabOBEeZzqgIsGtSpeTgKzFEppXP/JN8/Nm4nYrTLX64/v/stVSUPfSmI7baOkw4ni6A4YQ8DYmxHkvpgEauBKXUDxF5JZ3LduRssHpL1gEyTXQD40sN+LkPZkYnhedFtYmfvTm0gB3ZmhVNyJ+q6ZkV4/jSSkocmAG8d9MzrOOXYBqSRAcZOdh8NkW9oRnV30Vg2kOOL4kRwr1dB56KimX2atm08sVPB+CJy0vGQqdIGhPpXpLdZkk/lia+QQA1dFFuDFkZeTdTKmbV5pG11PzX8gbwJOXljNOTTIT0c0E3GhaqQ0Zs6j/ZR+yU3RnSFQdweuQq1QHttV54E1CfjdmEur2
 1/ELkuAc
 H9dYMJMruJQSQsNl+FzHFT48/8Bp4NyS6TFqr4R7DUuvpVxxEGHeSzRnzycRklEXjPnBKBvZww/q6DQr4twEDLO/AGeRJ47ouKXk8GM0re1zJDR47NiQZdjUPSStJtp0O2aiOv0fenJ5HNQLWI7P91+yt09foWEoNdMsTmznodnG+2bNXaGpeeGb2y4WspbchjyMX8BkK5i51shf8AJMSleX5J56NohrFz4XEiT4cuXqfVhV+LcggxosT278tLqMzp+A19LyjWk8O039gi2vERYUAYdcv0D88l5hK8QT2IDwGdMEDr+13tl3yeQU9GgrXdKYg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 08:08:01AM -0500, Zi Yan wrote:
>On 19 Nov 2025, at 7:54, David Hildenbrand (Red Hat) wrote:
>
>>>
>>>> So I think we should try to keep truncation return -EBUSY. For the shmem
>>>> case, I think it's ok to return -EINVAL. I guess we can identify such folios
>>>> by checking for folio_test_swapcache().
>>>>
>>>
>>> Hmm... Don't get how to do this nicely.
>>>
>>> Looks we can't do it in folio_split_supported().
>>>
>>> Or change folio_split_supported() return error code directly?
>>
>>
>> On upstream, I would do something like the following (untested):
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2f2a521e5d683..33fc3590867e2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3524,6 +3524,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                                 "Cannot split to order-1 folio");
>>                 if (new_order == 1)
>>                         return false;
>> +       } else if (folio_test_swapcache(folio)) {
>> +               /* TODO: support shmem folios that are in the swapcache. */
>> +               return false;

Hmm... we are filtering out all swapcache instead of just shmem swapcache?

Is it possible for (folio->mapping && folio_test_swapcache(folio)) reach here?
Looks the logic is little different, but maybe I missed something.

OK, my brain is out of state. Hope I don't make stupid mistake.

>>         } else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>             !mapping_large_folio_support(folio->mapping)) {
>>                 /*
>> @@ -3556,6 +3559,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                                 "Cannot split to order-1 folio");
>>                 if (new_order == 1)
>>                         return false;
>> +       } else if (folio_test_swapcache(folio)) {
>> +               /* TODO: support shmem folios that are in the swapcache. */
>> +               return false;
>You are splitting the truncate case into shmem one and page cache one.
>This is only for shmem in the swap cache and ...
>
>>         } else  if (new_order) {
>>                 if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>                     !mapping_large_folio_support(folio->mapping)) {
>> @@ -3619,6 +3625,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>         if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>>                 return -EINVAL;
>>  +       /*
>> +        * Folios that just got truncated cannot get split. Signal to the
>> +        * caller that there was a race.
>> +        *
>> +        * TODO: support shmem folios that are in the swapcache.
>
>this is for page cache one. So this TODO is not needed.
>
>> +        */
>> +       if (!is_anon && !folio->mapping && !folio_test_swapcache(folio))
>> +               return -EBUSY;
>> +
>>         if (new_order >= folio_order(folio))
>>                 return -EINVAL;
>>  @@ -3659,17 +3674,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>                 gfp_t gfp;
>>                  mapping = folio->mapping;
>> -
>> -               /* Truncated ? */
>> -               /*
>> -                * TODO: add support for large shmem folio in swap cache.
>> -                * When shmem is in swap cache, mapping is NULL and
>> -                * folio_test_swapcache() is true.
>> -                */
>> -               if (!mapping) {
>> -                       ret = -EBUSY;
>> -                       goto out;
>> -               }
>> +               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>>                  min_order = mapping_min_folio_order(folio->mapping);
>>                 if (new_order < min_order) {
>>
>>
>> So rule out the truncated case earlier, leaving only the swapcache check to be handled
>> later.
>>
>> Thoughts?
>
>I thought the truncated case includes both page cache and shmem in the swap cache.
>
>Otherwise, it looks good to me.
>
>>>
>>>>
>>>> Probably worth mentioning that this was identified by code inspection?
>>>>
>>>
>>> Agree.
>>>
>>>>>
>>>>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: <stable@vger.kernel.org>
>>>>
>>>> Hmm, what would this patch look like when based on current upstream? We'd
>>>> likely want to get that upstream asap.
>>>>
>>>
>>> This depends whether we want it on top of [1].
>>>
>>> Current upstream doesn't have it [1] and need to fix it in two places.
>>>
>>> Andrew mention prefer a fixup version in [2].
>>>
>>> [1]: lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
>>> [2]: lkml.kernel.org/r/20251118140658.9078de6aab719b2308996387@linux-foundation.org
>>
>> As we will want to backport this patch, likely we want to have it apply on current master.
>>
>> Bur Andrew can comment what he prefers in this case of a stable fix.
>
>That could mess up with mm-new tree[1] based on Andrew's recent feedback.
>
>[1] https://lore.kernel.org/all/20251118140658.9078de6aab719b2308996387@linux-foundation.org/
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

