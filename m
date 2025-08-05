Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5EEC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906008E0005; Tue,  5 Aug 2025 10:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6A98E0001; Tue,  5 Aug 2025 10:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F438E0005; Tue,  5 Aug 2025 10:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63C438E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:32:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D2F0C0248
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:32:52 +0000 (UTC)
X-FDA: 83742945384.12.A7D7E7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 61FCF1C0011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:32:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xk+WWLhu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404369; a=rsa-sha256;
	cv=none;
	b=jVmO1AH9Ihzf6sChgPiPO3lEE4BmZNUVyig9YfpOYL5TWbHwPPyPWgL/2IQPC5/JN7wDN9
	RT01YGUAyHEbMRfkUVr1qVf5dogYnkG9na8AyaqKOreIXdZIswQ+0VmI24DDm2apo5Vnei
	StRVKE4CV1WKdtc07Jjwbrf8HuXzEdI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xk+WWLhu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ix3nGBaIbmH4NveMsKrbtk5kqoYYY0SEMHv1/oWenw8=;
	b=IB3NXOsWsINFjyNFST85rYb2mtfHIieJPmBtCB7rEqSzm4PUQ57pllPZLnqOv4bYXT/sp7
	tljEiO3hIFebkCqWiUArx4Ya5UglNaKXEcSZk2rKPuSoZoE+5Siu5h4F3OCMu55Yqe0h2o
	TJdxe9a/z/9QYB7w3+ZsRseAdocOJvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754404368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ix3nGBaIbmH4NveMsKrbtk5kqoYYY0SEMHv1/oWenw8=;
	b=Xk+WWLhujQ86Js3pockCTrh6v8MJx+76NUavn9ERD+xdlj29C4/se9vOohqwt81myTVhzy
	iHSSsE+8Y9ub+AutdwmsP1NwvpgYSHTvUoq/Y2k4BsoYfn3szaGv20Ij3RMiXzOHiEexTC
	O5mqA+peEVJybCR6QY4iMWdHvwHyioA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-JQFuacXYOAiAkEjtU3osIQ-1; Tue, 05 Aug 2025 10:32:47 -0400
X-MC-Unique: JQFuacXYOAiAkEjtU3osIQ-1
X-Mimecast-MFC-AGG-ID: JQFuacXYOAiAkEjtU3osIQ_1754404366
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b8d62a680bso2198647f8f.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404366; x=1755009166;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ix3nGBaIbmH4NveMsKrbtk5kqoYYY0SEMHv1/oWenw8=;
        b=SCKPPHYosq/D5DR5USszGjHA8bbH1NWkOZ0Py1oe4rNMwrziChY/vrF2suVFi9yrRl
         mVUg8S8YQxon4sLWicH7f+G8Y+qaaRF8tgbU+z0mrfszu3pomaJg5zBfw0lUR9l+s+QE
         CsPyLk9xHkBmjK4kZHn5eDFGAKwj+wyCgXU5ELpWnI+6T/+a/LEcrP5UVJW1ZQkRt0hC
         4F6LUYxNHbJ8sihLd0sn0sIsP6RpQJ6zRwhMfZx7KLiB8N8nkYwE788gG1O9jSn8eqjk
         w7JDU+egMgsBgZC+7YGP8vyn3+q8W400ILUIuW/HrX/cStM+kIK78SpsTSP2CpjjF10Z
         amHw==
X-Forwarded-Encrypted: i=1; AJvYcCWJJNnRXArDT1sim0P0LJTnSlXZmFfEVmGTTQ74hM4IfPXp+QehSEDfK949ZzNlvhn0S3CxU4RzJA==@kvack.org
X-Gm-Message-State: AOJu0YzJw3Eujk+IPi8B40f/ArUplV8Zoz0N6eU8Dl0b2JP7vfL2iTDH
	EOBABzvJk6V0mZmRwETc0l0yOxOy8h27cjVocjaFvSBOusiVVMyVeCibcgi2nrQHmxXPGT6D/Qg
	0UAtitnM0pk3hbfsgCd8oDtDostaL/kFAV9OzOQ2GLNOiSsrKnqFruF9oSk7luKE=
X-Gm-Gg: ASbGncs+wwUyuoC1eGUo9kzE/jicRhCIAmmc776sWSR50tD+LIsqqyfVRSr5fv//6fP
	kVwzcnTKJFEto1F8MGxsSMv+G7tBWoMhfz4x5UuYMHsJ8ScIKMo5HqsoMMi4vhibUNhTV96/s+v
	eMpAZ53xxlzv2rOeLRT0lquc+yLuqwKBRk1QQAiPgtI9EVy/BsDqcjMbkF7FNBiZiEH9hCJqi1X
	0uReDSsicG8GtUa7LiRyzuFRU3/deMS3RHSncrdOZRKGbh7MCuj8cSIK6WOdLyV/gtuV4bwDgVy
	20GCGRauzNSNiANpvZ+hSLVHa0drvtWL7eMC5uew5BsXg3RdvQuQphf6uuNJ/3FitG7rXlGSUNr
	PNb2uS4ll/itWvdYWjL2ygMzrTKcUxTjMOJOr2FM/39KwQ8UON7j0srm1bSiG46dpV04=
X-Received: by 2002:a05:6000:4312:b0:3b8:de54:6e64 with SMTP id ffacd0b85a97d-3b8ebed0110mr3358763f8f.26.1754404366286;
        Tue, 05 Aug 2025 07:32:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0eBgMt32IIG2M76/hGwmlKj6yIjDo80GNw04npLTQhTH6LwgB3ZPD9we6BR1M9vQkbIGY7g==
X-Received: by 2002:a05:6000:4312:b0:3b8:de54:6e64 with SMTP id ffacd0b85a97d-3b8ebed0110mr3358701f8f.26.1754404365758;
        Tue, 05 Aug 2025 07:32:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac036sm19299061f8f.15.2025.08.05.07.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:32:44 -0700 (PDT)
Message-ID: <be784521-5507-4d6a-8028-2816c1a18325@redhat.com>
Date: Tue, 5 Aug 2025 16:32:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
 <66c2b413-fa60-476a-b88f-542bbda9c89c@redhat.com>
 <a22beba8-17ae-4c40-88f0-d4027d17fdbc@gmail.com>
 <e608f766-8750-4781-bd23-8fa95b6d683a@redhat.com>
 <955ed533-dd7e-45e6-a2cb-f379a5878ef7@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <955ed533-dd7e-45e6-a2cb-f379a5878ef7@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DAc8Xr3-hG6I_n3uuxzm2YolDJZwk23jkFt-aYtnJYA_1754404366
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61FCF1C0011
X-Stat-Signature: upp9pac5b4xbs95e16n6ct8hjqsghefw
X-Rspam-User: 
X-HE-Tag: 1754404369-450823
X-HE-Meta: U2FsdGVkX1/eowA3mFxE2D7qFSxG6yfo6EOgKTB4TbG21o8c5QsWAsKgVX/s1tW2kdkJPHoCYGc8w+pZdhrqAHWA0lu0Ai8JYCQtpqbWaH71/xo6JgdyvOen/tXNstzesTLuOnW8xP/RiqezdFSS6xvzxm0q3dMitLFvdb0+mXaPpyleqAkADFO6dAd3UIBwNjWUelVmgAvlPCgvGE1477i2C7FRQNOuHx6kQ803eZ+4uL/zYOeu1+5m2K5zwX2HrpbZizUozdm7RCPi6y3SoUZRU+S60p4MtsYmV1boofVz6U39hve1uvUEl6aEzNmsqPiJ9NB4qu7eIrYyi+742aAsoOrozncnMTZhQqYJgxtbUrEfjmBBUZExiY9CfnO8UxEFfCsJQ+SmxOcjxaJeJ2/1C6sFSGT9dBrd0z8JzWeUI0TNtRU7AUjTdsyJ5E820OR93ESmNVMYjqhnJ/iJCSn6rNYmfeikNGFF7igVSZw4ZfKpkOUQ7tcRaHL4gl93fDMveTJn7u9RGoG9vy/ew2XdqWbYxNKct4Izq9ckorP7cBlgLZRzXswKJk2WOrSFhEnwtRQBAT6jU/Hz3N/hODQfSvOMyWv0/aBCbaGgjAHmntuSAGz/ZP42PyzqIARhRJaBAtKv9/jyvXecoLpCpLHMZD2MMe/pid8tu01OxtI+Xz6s40uxUH9Zi3rHYpOrAkn6SIsgrzerw+5CHr0cUo5/ivsZhcnfweDFntNa4920RRWTjwvkMDhfyentwN9YbSy74rdHSUwDphgZzYmA0KGeosAm0xoZn+gyr2SG2RB4nFWNmf88joCNI/aJ7euAf2DSR/qw1+FF17wt73wWA8Qx4JbEwNEL3SHR+FBHWbd2sKolr5LOY+SuDO6ulDPjwFfXoHnPOt1qQzHglFBLoFuIofbKpcNe8RL+STwYqrtlY7UpiabvZ8Havj/UTyt0aB3+4c4yw6oAHMYacCN
 TdCzN0Va
 CcScsX064kMqdLZP+4ukUNRGhj3TPHSi5ahk9NwGxEirtV+NXFw5JEYSbZdlIzJrMeNlpmdQOY/Srdq70LafmCPQjHf45Em60yj2mTUMPXlmDzQ/VQtV6WxvjAQhPG8F8Ci+axth4iS+T+Bnz0fYnsG4/TaG3xHVrEZm/wdHg8naEDIGqMz2Wsr3+vnjKXn9omqRe/61ZOaugxEYD+6Hcuw0X99mh9ckMo8L8TlXk0Ze6+LAZXBwgTpipW5de7dZ8/zwoKZOFJsI7UqH/QxIYeMspMPN5K2T2983ZiRnZXwapy/gzSbkz2osPfbGuX6p7+p6C+YdVUrtAx7F43eSpT+slrNIjWCY/0pTEpZs+xNN2WnRfUbYuto03FxwJHmqh2PLE5Y9N9T59NqLWQIv+JoFHtTVFGWBEPk1j2wiBFU0ZHy0512ao+c/Xp9BoNqTM/gdfsgdoTN3Op7r7czErHfjeIor3gfPGTw8hToIXeWoLxtTLK4GwG3S9KEBf80wJbf5J7aBtueD4+Ai4F08jnnGlmArw8AKJbYO091OwaRvTZoKSQO4XF1KhIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 16:26, Usama Arif wrote:
> 
> 
> On 05/08/2025 13:55, David Hildenbrand wrote:
>> On 05.08.25 14:46, Usama Arif wrote:
>>>
>>>
>>> On 05/08/2025 13:39, David Hildenbrand wrote:
>>>>> +FIXTURE_SETUP(prctl_thp_disable_completely)
>>>>> +{
>>>>> +    if (!thp_available())
>>>>> +        SKIP(return, "Transparent Hugepages not available\n");
>>>>> +
>>>>> +    self->pmdsize = read_pmd_pagesize();
>>>>> +    if (!self->pmdsize)
>>>>> +        SKIP(return, "Unable to read PMD size\n");
>>>>> +
>>>>> +    thp_save_settings();
>>>>> +    thp_read_settings(&self->settings);
>>>>> +    self->settings.thp_enabled = variant->thp_policy;
>>>>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
>>>>
>>>> Oh, one more thing: should we set all other sizes also to THP_INHERIT or (for simplicity) THP_NEVER?
>>>>
>>>
>>> hmm do we need to? I am hoping that we should always get the PMD size THP no matter what the policy
>>> for others is in the scenario we have?
>>
>> Assuming 64K is set to "always", couldn't it mislead us in the "madvise"/"never" test cases in some scenarios?
>>
> 
> I tried it with 64K to always and seems to be ok. check_huge_anon checks AnonHugepages from smaps which
> only indicates the pmd mapped THPs only. So I think should be ok?

Ah, yes. If that's the case, then we can focus on PMD only and not care 
about how the others are configured.

-- 
Cheers,

David / dhildenb


