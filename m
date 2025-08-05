Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9746EC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3250E6B00A5; Tue,  5 Aug 2025 08:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5616B00A6; Tue,  5 Aug 2025 08:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DB96B00A7; Tue,  5 Aug 2025 08:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 072496B00A5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:55:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73C14C044E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:55:36 +0000 (UTC)
X-FDA: 83742700272.28.DD94AF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id BDD651C0009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:55:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L8lBbh7T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754398534; a=rsa-sha256;
	cv=none;
	b=JiWQbgm+H8lWV+p6H3dSXg8QRJb3L3nZulu2CrFvXougIx9IgmnXyl7JVTRRnOhXnZwj0E
	2C6oBFtivykk39RXkIggNSPRlFsdye/mYWzui2KMRL7VMVdP8F1fLdOPa8vFCNhQJJJtaL
	lwq6ZS5RGAgwD+tMwgwDwwBqeX/eRX8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L8lBbh7T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754398534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXQVWi/b7AMP+vy5HeVixIeMAJNnKqw2TByOJlo+1Us=;
	b=o3CIA/FfrgEAifV4LWpaiLekNY8mY5hdrV3e/48J7SDGEcQLtFm9wl/q1uFy5o6J3YzU5A
	wliGM8f5tEFtZlXEQ5az1pN9fHsEOw6YvGx9kU+zww4JVC0G5WEZHTipn1s6epy7/f+Bng
	M6Aq0rr6H3upF+m8GvVHtPggeKwAHPQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754398533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mXQVWi/b7AMP+vy5HeVixIeMAJNnKqw2TByOJlo+1Us=;
	b=L8lBbh7T27aXSSGPz7RK28s88I9pw58pBXvBkNx5nEMz2PN++Mp376H7oRA9lT9SyYPE/q
	ZuFpFB4HCY76wXukr2KvjByftKDSC1B4KRe5LMb/ixz6T1/eg0pVFf/4VbO8UVpz5E13G7
	Qv3hNJj0RcsnfxlwGotQjex5rQp+6rg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-JbUGfn3uN3Wy0ZfnhygYHw-1; Tue, 05 Aug 2025 08:55:31 -0400
X-MC-Unique: JbUGfn3uN3Wy0ZfnhygYHw-1
X-Mimecast-MFC-AGG-ID: JbUGfn3uN3Wy0ZfnhygYHw_1754398530
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-458c0845b34so15393805e9.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:55:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754398530; x=1755003330;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mXQVWi/b7AMP+vy5HeVixIeMAJNnKqw2TByOJlo+1Us=;
        b=Mug02eaZPViatEotS8v4Hzaq8EN0fXUulEohevtO3aUTZbuP862MGxFth9zMYcU46d
         OfGc7pnOJ2XbGBVUDlF70vrq4Tt+pGnRebid31tuou19wZu/lYLMNZ28fmyqH791LaMD
         mud0LPBVKnLnMadD2FM0i3hvzc00JztDH5tUFrqfLK/teCAs5u6wfd1l10c98RNVclFc
         zESuGzyieoTiy37Up1RIOHqbG9ZpUaFQh+Gw67ZY59X9Cviom2UWW8Nuy0jhxyAqX9eM
         l0YwD10+EXsIjKFJXJAU7mrZo7H+M4VRJv5tW3ao0oEIGkXTjwFVgOrHQ0kDWGcFCtJB
         7k3A==
X-Forwarded-Encrypted: i=1; AJvYcCWm7WqAXhLPqRVtjJKvGaH5hUJlAepeGgsh32wZvIZa0Ug5GVvLPtOaxijGth0tDWc8NQ+zyQzYfQ==@kvack.org
X-Gm-Message-State: AOJu0YyxAa3Bo8ZCg2LSfs0Vm+Zm6aTlVQ5PwCDvQd/NibuBy99bKdyk
	0RLBh0vI3Kd5DhtmjdaqSzFVVUPxwTZnH5whkR9bI7O+Z5bU4DqRBq37fb4xqPLcXQGGKjEyaXG
	xfpnFuVoTYw2y2ZdVEgmMu4JhdvMQIUFFkBYIHRaBHwLqGxsWQbtb
X-Gm-Gg: ASbGncu0HfDTytI/3AG7zaPOhKiwc2YPRYGLZ/pQnmsrgitAyInzgzTOxcIotjF93oz
	Awtnhdj/JxtGkQCH+yPV4/OuM7LLDcQn4tR+E4pnzjwdWHwWEswvIMSsDbLe1lCuhjuCp5gNyDh
	hclHQPhDR7DskQ5P3T3WvHMqy+SRZAXDuN2Ch97JnEvEJIX5vAnHxp5i9EiD+75kYDQauMuA38h
	Vs/KFfdM9irHrBo+XIE71u0YqXei6IFjRFtNqMm6tUPEpDY7zSIbiZOyo/xISWZ0H8b1irLg0yE
	tsQfrUhHid1BTOcvorsn0SlByLlgAcbn8SXc5AmP18NprFcWPw3Zmwr+5VTa00oG9sFBurk=
X-Received: by 2002:a05:6000:2287:b0:3b8:d2d1:5c11 with SMTP id ffacd0b85a97d-3b8d94d3549mr10242832f8f.51.1754398530403;
        Tue, 05 Aug 2025 05:55:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoW0VEHeHdM6KbOLWiBmAjo9TG0Lqe1CZviyoNOwGriAOTp++1O5KXtJScToSn/9LRd7ABaA==
X-Received: by 2002:a05:6000:2287:b0:3b8:d2d1:5c11 with SMTP id ffacd0b85a97d-3b8d94d3549mr10242807f8f.51.1754398529950;
        Tue, 05 Aug 2025 05:55:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4534b3sm19065920f8f.47.2025.08.05.05.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:55:29 -0700 (PDT)
Message-ID: <e608f766-8750-4781-bd23-8fa95b6d683a@redhat.com>
Date: Tue, 5 Aug 2025 14:55:27 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <a22beba8-17ae-4c40-88f0-d4027d17fdbc@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9BKC90CFhTYvDzSE0uGoCzYWU87e0hFvDHiUfY3NUHg_1754398530
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shxe3jkqt1wuti83qer55xs91ka45wzp
X-Rspam-User: 
X-Rspamd-Queue-Id: BDD651C0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754398533-774946
X-HE-Meta: U2FsdGVkX192IyPHz8vsgOETmi5JSU+Y0oVjxUo5WRn3ZJr5ByW/Wn4eKVi4q/bITK5fkxPmJiCEhDE6iBOp1OTz0pJt6ScT49S53TzNZg/JCb8Ti+ZYt30seVOyrCZnSUhORdGjDd6XYK2YXE84NEyAwdlMbFz2bMIkAYinfO38C1lsBU5woRKBbSVoixDIBYc4mUozUjslMvELOOLmkTsbaAdbNyI+1IT63CW5D7X2ayF8PekajUsQvt+ZmFIGtoSvOpUIwVd2PEXg9kanu2aV5NWkHemQa/xxhqNofVG8ZB53r5vIo6IrtB+xYgfh/xksoRONlU9UGH38icdn4oEkA1eHFLZ+uNtyqrPJkBZsrK5nKgQCTxlYkKT63VFdz/FOFbjjMdZy19oLyN/rsB3XKrD8jgVJN7Zks9ynsAp/LzHJFbXWkoCLykj5i1omdp0lNyIFQUDd0kkHoErHh77NZVCnwyVoqq6n+KubM7Xdg8xHdWhmgZZ+5mII3IKr48+1k+timLCMXk19aUWfRBykoFpiBfMV6xcbzJXvn3MsJMSdD6Zb0wmLuE7tv9U1Nu6curoRQvi3nT6ComcfYn5ACAWGHFgFfbnhqIIwquRjnCNtS118jovAko9EacESalagPqSXw+ozB9jZG3Naej9XitDMpo/98NcDQ5JnhrXQzk+ymJxto92BaApzOp6OOW7VXXmGSGZ6EXwmdD5C8RmNS4VLvCy/7gDoc2rIBvsxnL4w/fEjOmN+a2QqsN+xzQCim5H3MmQJQ0syjSDTzVp4exfHhAK/R7TbFnwZk5qnz9K4a7xzG7w04b9WgyC0F8QHOVfx/so8h2+nTXUfehTsTQyLctHvQYKVYwAVwVwWEX0PP/b61EEMA6UZXqoL3ZNXMCtJSYeAMZs0Uum4JlYPIbLT0Nwh0ag863ZRaVC470sbrg0ocgeEUalrVTsaoSiQmcQkzw1frK7AlzZ
 br+MX1+i
 hkWTR3a3GaPRUw6pKSJxePy9lHtDN88jSMTlH/0H2SK6lvlpiu95zIWexMO1MCyKkmGUDIlDllGpqF7RUWGGb0LJiZy/9Zs0Kz/JF0y/CphJx0qEnyvd35a+nymwUD+9CfTj2Q9L44qerOVqbE4oA8UUB8YzKNRUdGF8m+9gwoeEVQGJBetbUNfX6d4qL/EmtlXPZz8+V11zFA0K5d/rRdxJmm3Kior2HmEa0F6COT3/WwO440x0r0Pf+S0iN5Z4rzYrKgs9kW2c7xjGfGsRtuCZfsZsTVrogNO/v5hnjWA2N5T5U5vi2zManKVP40o+LPgJAU4Tiqn0kYBedHdAMRyS6m3o/XmMjDSpwmN/0RuGz+IE/lVC2vEBl3ZBqCBSEL2GEhoXvrqanAmV8KYJR7aHIasTu5cJrgXXy0sw43qxZZBaK4h51nvjHbvMcf0khUkgWSMBM8kYLm1j9EuOTXEDWdWNz0LPwtOMQc3Ys043Sk/G/BAeyrQqdX78b7gkvDv8WCtCI1xiJpPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 14:46, Usama Arif wrote:
> 
> 
> On 05/08/2025 13:39, David Hildenbrand wrote:
>>> +FIXTURE_SETUP(prctl_thp_disable_completely)
>>> +{
>>> +    if (!thp_available())
>>> +        SKIP(return, "Transparent Hugepages not available\n");
>>> +
>>> +    self->pmdsize = read_pmd_pagesize();
>>> +    if (!self->pmdsize)
>>> +        SKIP(return, "Unable to read PMD size\n");
>>> +
>>> +    thp_save_settings();
>>> +    thp_read_settings(&self->settings);
>>> +    self->settings.thp_enabled = variant->thp_policy;
>>> +    self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
>>
>> Oh, one more thing: should we set all other sizes also to THP_INHERIT or (for simplicity) THP_NEVER?
>>
> 
> hmm do we need to? I am hoping that we should always get the PMD size THP no matter what the policy
> for others is in the scenario we have?

Assuming 64K is set to "always", couldn't it mislead us in the 
"madvise"/"never" test cases in some scenarios?

-- 
Cheers,

David / dhildenb


