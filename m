Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22041CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674DD8E0005; Fri, 12 Sep 2025 09:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625788E0002; Fri, 12 Sep 2025 09:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECF58E0005; Fri, 12 Sep 2025 09:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF358E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:48:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E27EC1DF5F7
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:48:08 +0000 (UTC)
X-FDA: 83880727056.09.843D119
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 445BD160012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:48:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKESeuEz;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757684886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3448OdTgFs0YiOnfQSy1wV2L7Q5FFoX8LkMxHWDXQ0=;
	b=gGFwGqmW+l9byZqZss4s7PODhDjFlYfcLoGdKRDg+Pn9yzqJZb6MsVGqqEo6IDG5F0BGhz
	zJGa9xUDxUZkJsr6Qfp9Xmlp3IBQQndFtOc4KByopLoaDlIaibGuZzLFEF6WyYUVSNEhci
	CaV6LvSxXFfzJwBJ+FrOCWLupG/hH70=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKESeuEz;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757684886; a=rsa-sha256;
	cv=none;
	b=trV8Pj6rvdzgRasGvAQ+EjVZnea0rJV5XXuRtlvKvx/7gMTIZqvHP0ydSkgYOmPT7HAv8i
	9k2sdBhNk1xyfpHkPDRQYUvJW5ntggLoet+f3l40Nb9pz4RhXq+FN2mxh+VUg4URn7o59o
	xySMszEqhfXq8XT4xpgo/JcSQ9LRaTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757684885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w3448OdTgFs0YiOnfQSy1wV2L7Q5FFoX8LkMxHWDXQ0=;
	b=OKESeuEzeJ+wcnuQbU9T8lHQ7I8sF/ZV0rN3wyN9nJVMYe2L0cPQmih13+Uzv2GFLzHPF/
	kMU74qMUa6cp3y5mOZjkRKV0MAkZGZ7CCWSNG+Ki8h5TdZfq8hGEmYfaJTSEkOjSlbr18c
	cl+7VaPNUX/sQ8NMRuA21/67vPDpTQw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-30QzHiJJM0idqa-8yHEMVw-1; Fri, 12 Sep 2025 09:48:02 -0400
X-MC-Unique: 30QzHiJJM0idqa-8yHEMVw-1
X-Mimecast-MFC-AGG-ID: 30QzHiJJM0idqa-8yHEMVw_1757684881
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e2055ce8b7so898125f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757684881; x=1758289681;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w3448OdTgFs0YiOnfQSy1wV2L7Q5FFoX8LkMxHWDXQ0=;
        b=ll+kUVRl92zi+3+OpLzH+AjqiGwtUP6gfnlUgR1jIMdfayf6VbEc4moE3bQZ9ExZo3
         Wc08ibn8O3qzr/IErxELAZx0krDA5BYSQz+5T8I2ieQJyDc5wm29fzY7Z14rLbElvi10
         9pWyqOoVw8B5SEjxpPCMfDYDZvXCV9Q0vD3jofPy+tnFbsZ1t1lvQLaIBWXtMBv3+hsx
         +hKnwj2477I98T+Ckgas9g0k96W31xMqI0iElLtsqdUlsOj+xoY9fs1fxyF3avAaaUBl
         DOytva7V54eYqw/gl8NRvmjayZ6tx1Ki3gdukWaCe4KvXHIKd5BefhBCiZMpGInWVPOI
         OXew==
X-Gm-Message-State: AOJu0YypJSPPpLEr29COcVxL7hoya/9Rw5bXndVVYWSQJi1V01ux+XLo
	mUNotByK4Vzuee0GSRzS6kb3onlEmHHvjYeGUNrHuts0PVJpd7tPAzetd2v3/xk+FHZJG8lt8+0
	hsoVmcbvu+wXBi2qSMUsBaxLQMf9LVe1Uc6d2AM+V2MVqMrUNm2zh
X-Gm-Gg: ASbGnctIvwlEwwUynBtqqZEpIsaSSEbCBwusi4Ofwg3atg+aufS5XCJcRyYjwQH4lBX
	jteQzo/dlPR4wB20/BrLBSlNtwcg8G3yhlhj9ieyWeM74TPiHSM6uM8Pt7DTHkQ+Dncx0WrQYZa
	xJ3zCkUuKRpGqfpF/d7bgXM2ZoygrxicNjk2h8itIDp1/F9bJz7P7D9l5v3sMRXNlTtRmRxXz8C
	XMmJKKFtyF0t7LV5ZPPp1szEjyRLdwG3XliSRtSA9mXp2BTvNiCFVwIsoTYlldlnVC7c9jG62vC
	/2sVEXwTIjx+hvpQ4xsjq4NDfeMWEXmKYVy50VIzuY9elHPB9Qi4vJQOFvEXDhTOUI7N0oX63xs
	28ATPzELQhGWsZj6eEJ+HD/w+Y95S3R3nmOyqm+odylNbuW9AsqcsqpO9znsq7Q2yTdM=
X-Received: by 2002:a05:6000:2903:b0:3e0:152a:87b4 with SMTP id ffacd0b85a97d-3e7659db0ecmr2929895f8f.35.1757684881148;
        Fri, 12 Sep 2025 06:48:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR3i6SRCrcMcssae1nGWwzt+oNV7vkhRgpzb3bl3dJ8CMEtAZfsOX+4eMBZZIz5FBmhHDpKA==
X-Received: by 2002:a05:6000:2903:b0:3e0:152a:87b4 with SMTP id ffacd0b85a97d-3e7659db0ecmr2929876f8f.35.1757684880716;
        Fri, 12 Sep 2025 06:48:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd691sm6839560f8f.32.2025.09.12.06.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:48:00 -0700 (PDT)
Message-ID: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
Date: Fri, 12 Sep 2025 15:47:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VZsVifzNVz8AI504V_PKzZbk6PVYUnC6K_NROh7GCGE_1757684881
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 445BD160012
X-Stat-Signature: xqexsd6kwwxziqjrxg7n3jccntantwwx
X-HE-Tag: 1757684886-437754
X-HE-Meta: U2FsdGVkX1+rv641MQNr5fCToSk7Vx0HukJn/8RhKhZf1x56QVTTWQzF0zEs790hlZpKqRJrjuU6+zOKllhyGv1zWHXXrr7mlg3TaCKB2Zu3ydPUp9NH9jdYU1Kd1Fm+giT+yucOc7+RdrTyWb+Vt806ZSJgDBhin0GJCEs0xHOBu2Ch3IXsGmj1FhPeOipR12FbrquRq2S98Ngq3LcIp432+aUhGGQ7zvy9rXz07NtPzBbFZ9d2O1pwPxaDMrBb24vPuntM3TOS+X74Pw3Uj49Vc9lxT+SOQPwxGssglSGOYy5kNTzUa5do33kqWOdHC+pDfCgVD1HeM+Yt8rqNgbIUx/ZLeHozDxhjjLMu5QTndPnjfi3tULrlUtarZwtc/cO01VvWDKIQauiUMbP3WkurlQnsWJupdZ3Xvh5+kZgdWk89OY8b5dbvoXDiTz6bBnLJgoVjzd86FNPb+wU2egxtRdx1/eoLof44qyNThZvJ86jeSgr/XLOm5PUb9zxLGlFYB03gksrGKoCZ0Kil0i8udKBgGfIKkaw1uVW1EWffzQYdcLWi90Er/Iesr1PtKpN1eOhQsV2SKeAZ4YTpLf2UtZttwWuViPp6ao4Xvse2QENRzIm8lUUAwOJcfsT9Ad8jyssV4zTsSbFYwsSYnleDXkaTY01gCOXsAGOM9swWk1dDsg34xWAYRcdZbs8MVkIOXVi83CGc1yuDN0wjocsZkPQyZNlYJs73o39jEkq2nXPed8kPJ/2Hsj49MiaNOPWI266VN2xlXavgExpm9/+DvEq3b347QT+jVc1ueUz9TdR98w0kOsFKfyp1Hod/RkF7ThwjoSKyOCgGhTQJqroWZHSWbtLfGxIPMFcHLhlPexvHCSC4mlo+WnrBW2Z2DLyqUuRGfdDFFADfaIpfQKbXKlocc3hqzswsepxbU+3irXQrRbn4AUqs4JQPXfMN8Od0g8ua11m6ei3zuZm
 KqwvgrV5
 OVl16OWEUg8J7+UJgdEylX67bMBsYsx/w09CXe9Z6+gE5zCLRRctiELb5/sKpn5MzNHRyIBnqsYQk3Wc8jp8/1K0lFmjMJ0MTw0h9N6ung+3CId+N+xv0LqnFE8baIF3gYM5rOe3pwthxdzooyn0ECoozG6BkofYmpJLSv9W5jdzi5AZvHjoNjWwx/vCOfHHKZFzro8SJupLQCFCDi5Dg6IMHN5XZyTbE290l7nH8X0oJLq/PFV0OZG8/t1G2JB6chmqtoI9i7/uUGpiesOQvM2FKHVya12dURu2ZI2Tiy3foNUQlMqIWulLkqZ9cs1M+bL+8D4Aci/lstM5RjJRHO9HLOzPJbeShAKPi4SdV5yT8l4KkLkllH1qTjQq9C2EiO5tRRumaNs/bf6ZqR1l0hUjkhGCCDUSEUkPUnDkCMt1enkNx0tQhSQ+rTHvDmArOsZsSGLuMTgiympd0NEsQZK7lz8KKUd1TJ+/TbsrBu5SJ+85jPY/ZCscZMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:19, Kiryl Shutsemau wrote:
> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
>> The following series provides khugepaged with the capability to collapse
>> anonymous memory regions to mTHPs.
>>
>> To achieve this we generalize the khugepaged functions to no longer depend
>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
>> pages that are occupied (!none/zero). After the PMD scan is done, we do
>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
>> range. The restriction on max_ptes_none is removed during the scan, to make
>> sure we account for the whole PMD range. When no mTHP size is enabled, the
>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
>> by the attempted collapse order to determine how full a mTHP must be to be
>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
>> contains swapped out, or shared pages, we don't perform the collapse. It is
>> now also possible to collapse to mTHPs without requiring the PMD THP size
>> to be enabled.
>>
>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
>> mTHP collapses to prevent collapse "creep" behavior. This prevents
>> constantly promoting mTHPs to the next available size, which would occur
>> because a collapse introduces more non-zero pages that would satisfy the
>> promotion condition on subsequent scans.
> 
> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.

BTW, I thought further about this and I agree: if we count zero-filled 
pages towards none_or_zero one we can avoid the "creep" problem.

The scanning-for-zero part is rather nasty, though.

-- 
Cheers

David / dhildenb


