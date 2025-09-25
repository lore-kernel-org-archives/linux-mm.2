Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDB0CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048468E0012; Thu, 25 Sep 2025 05:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FBF8E0001; Thu, 25 Sep 2025 05:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57218E0012; Thu, 25 Sep 2025 05:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D439A8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:53:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C6071A03E3
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:53:23 +0000 (UTC)
X-FDA: 83927309886.02.2D9CDE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23037180015
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:53:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=elbYzxQT;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758794001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IZ5ZyHPjVPn/a1sUZGku96Q30DI6b1ntIDJki2HPWc=;
	b=yCPIg6zEnwNDxaVu0DCioN9TuNptzwFdetORY7NKeIA2lmuAaJpQBcDNNe7sQsuBuAKlzv
	YCJPqXYSWreiWj3PQpEqO69hkDLsN5RxNVYgndV3Mbn6O7U7Vz6kzFEqrA0MXkOiiH5OfH
	Yr1EleP21OsifXu730T0yObZ+g8tLrQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=elbYzxQT;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758794001; a=rsa-sha256;
	cv=none;
	b=HCATJVU2tXw9UU7XxunbeHZXmaWQoHaOOU/7r9stueuhoHkblIs+JPrFhcPCr/ki4KXrJb
	20j6bvqrlst3ZE8dglenfO4VeoRYw5fUUR8lGhmtB/8uujj4lRr8JhPXu3GOtLTPIl4n5I
	LDU3IEBImeFHe8bi+nBkIwoFbge7a68=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758794000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5IZ5ZyHPjVPn/a1sUZGku96Q30DI6b1ntIDJki2HPWc=;
	b=elbYzxQT6+Ax5sYfhlHXMzEHiAOZVu/kujkHVLoayPff8eWHO+4zCyU4Kad5R4aJsW7sdp
	OfqpeJZqJIkS402sSs3LHyIz0ksKijsiyrXRB6JOnLZLoMM4BKHZw3tH6lZEG3PuCaY+TM
	Y1twZLIEb/JoEZhQKy8RipWS94MgTL4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-KoAWdLzgP_K6ER6H1GZfVg-1; Thu, 25 Sep 2025 05:53:13 -0400
X-MC-Unique: KoAWdLzgP_K6ER6H1GZfVg-1
X-Mimecast-MFC-AGG-ID: KoAWdLzgP_K6ER6H1GZfVg_1758793992
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso3876445e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758793992; x=1759398792;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5IZ5ZyHPjVPn/a1sUZGku96Q30DI6b1ntIDJki2HPWc=;
        b=B+iaZqonKeQdLfSWs6eH5ooVV51MLrilUcuW4phvRAaT3WADfm6O3D54P0bX0REGH1
         AFzvd3fRYV3xPxMWCN6dnPkHf2+AL2VMf4nRKyFAqi2ab94r3lS5N1O7LPmcW6y3XSmj
         FO7prWhWf67P7phQf1rA2Y7HCa/nP0lx/RTmz4r7widwRcFB1cmyeg9M/TWj0YI00DhC
         doiYYznsZkwt1LKaBeodntBOxseJT7Dtjx1mbP6qqQGWd+u4f2dj2FzuRYfRd1yr1Pg+
         uXTIpAsPZXYBRfmPFgyPcf1lCVd4bsm+E0Q+3DWBGOj/dvyYXtFho9setdcoTmErAtQZ
         giPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFbPhxdMkh96niVXaMRgRNnf88zxVul2D9ILpuk2K2iGNRHqR34oqD0st9Ym3VvBRnrFOEv1U03g==@kvack.org
X-Gm-Message-State: AOJu0YzAroHBGYl9VrUJosDZ9wBF04+OTCuWDT5F8oguoNyyG2b0bRCs
	SRnDCVMJCKsiJpQIfAb71A4bvZGe8/f/y7LvOmcDKb6Kvqm51dlDnrt+u7tlYaJyJlrZeV1YCQ1
	qNukbeSMntO7DxfREviRqqxXJk0eLVqlAepk8rvAm/vIkldiB3Ikd
X-Gm-Gg: ASbGnctr6FqpqJ4f5FD8GdVGZ3tkWYuKQflktBaagguHbgW8wcKLzk7JVZ8G1J9JTO8
	M3Bc2FVP9SR0XL8bLgD5AVzje3W3CKQyrSTmU0vvfU3NAG2RzBQirJaKr47S0fpfMQV8w7QD/HU
	xjP7R6pauYdM9KqeX/9hB36KmO1zL33IxLHhEGTNn3Hvb1reZdDO7qpdOiqtc29ARcgq11p1/kZ
	gp9lHI9G2hoyXDyzvcq7p7pr1CskjE2UEEpaAyM+65CUHp0/FvXRsfx3xlUiQmELjcGCfufttvj
	xT/hZ8cw3HIWRS0aiLIUoZQfuKz8mp1zxX4rllWcg/wMOs1tZ8hqZIM7nhrcmPCvA4gVX5iBeSF
	BXONDH+FwWoSa/Ef24tv6SzfdTRNe663ws7HW8iN4kC0qXmwLkDskvgnV37xIx/S4gbuH
X-Received: by 2002:a05:600c:8b71:b0:46e:2d0d:804c with SMTP id 5b1f17b1804b1-46e329ae509mr28235985e9.11.1758793991631;
        Thu, 25 Sep 2025 02:53:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQdx4XV7EntPUilqRyAJNwUvFZd26RTmvdykMXr/gjLo1hfbQKEF9ym8IJ49CBAyUk65IGGg==
X-Received: by 2002:a05:600c:8b71:b0:46e:2d0d:804c with SMTP id 5b1f17b1804b1-46e329ae509mr28235655e9.11.1758793991123;
        Thu, 25 Sep 2025 02:53:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996d7dsm72815125e9.4.2025.09.25.02.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:53:10 -0700 (PDT)
Message-ID: <df1e62e6-57ac-4a5f-bf62-71fea47481af@redhat.com>
Date: Thu, 25 Sep 2025 11:53:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
To: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-3-balbirs@nvidia.com>
 <azcaqmqwdslvoei7ma4obtpxcdv7jdqfdc3ny4sylgwelwhfvo@okwd6y2oq5q4>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <azcaqmqwdslvoei7ma4obtpxcdv7jdqfdc3ny4sylgwelwhfvo@okwd6y2oq5q4>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kBocc7V5AGYId4lebUVdwLWwVVhHKgzkkKOrcBMcsUs_1758793992
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 23037180015
X-Stat-Signature: 9o6495nt191h85a9kdbddpxyr4e69enk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758794000-77014
X-HE-Meta: U2FsdGVkX1/yHNJs8BnMHxvAEqmTmWEAtmNFwwEfWsXOzsNScuaMlwHPy61MjIG7jvq4WvYVVFdEZIfTu/DATULrnbLhUmPVJyZGUtzgIdY9zEOxLZ8OOOfglR3v+JExPdTOfLnxbnB4qY6cjtWBlsLLbadWfxaV7kMWhflq+Jt7SwW5H39Gi7dG76RJDwMl6lYE+Pjyi1pwos5xZF+e6s2Yb8hNWWqBTN8FqR6N6NLSL+qpmu3xIrlnRMneaktId/m1g+9kv4ql+S/vAIqO/8RNt6WTjOetA6ni8TlaBQ7D6vP0HhGgyQSi4gu3Hj24bHEqVFOKGtXUMI/GEqxL7xKHl+tfZhKvh6Jas+Li0CjwZ1wEElg3NHd5DJxM5/cjSC0uyZ4hHrru0GG7MU5ircS1ekFbKeeoTTTO/e+WPW1AM+M3NVsOIWj65EG7bTsS82p++fhj6DgyGQ6jz/gV5y63RdUeDGSLkfS7wJMuJ7gBXKbLeR5ElmgV9lSSW1hUcmigLBJB0brkdD0Ep9OaK60JtrbuF3K4u7cKqyLT/a0Cjvlo98YXivj6V+rsMj2v2ScTAdYQygknpJh3nV9PkFkFPtAcI2MzrpOI9usmPWtXblXU5jNw0UcT3mWXz0KhdO+dmLW4LOXkCMap5dkvpWLYpOsJqe+z5+9EqbHho+JKDJu5mT6hugiA0NKXXJGvzqeNSgiN14CaMRKbPh1LBDu6eCA/632MswZpFVp34PCO8st0cFj3RqVqTAI0w05TOhrKRu3xMeJDrMSfklxcD14CLh+D3RmSDUu4lyvlFGOLCagLsQMtqX5rRH9DzvU/89z+SRVUdfhktfRiNFhGLCaKrsJHwH4ac6/wawsDrEgSG/z24ExzlgVn6sqevVJA6VxWFbSMS8S2yqOUxevPLYLTL7Wv1SIVfCql93IjnKf9CiC6WxBbzk+teB2XD3WITe6wO+HEpR21qHiKuH1
 omtYZmN2
 yfMqeh1ep1V2mY/rw3W/pmFNPpNVZlysEvPcPNshVBGPqbV2S9VN2e3+yaXdK4MqA2jbUQlszd2r27K8q9+I3hOnh4hatuhov858k7tTEMQg55JPGs9imhEfWG0E/3ryONNblykIvXonnJdr9j2fcE4BiQ29Y99PsY80k5VOoh5dm5rGgSTh9SK5AhnrR8CPqi6hqo+bv5yhclpyWQcB9tuSHKDnJV/z+3g4QX+DgNOlVLsHhMabzSDIRG58a/NVPps7oThsux3pkfbdh451veBBqmoqq/QMqr2B/GHx/5iww2rDzihjc+2LVEKmysKK9mZ8Y8WIezJbfFvCiG1aIud8tk+7cchumOprzllzWG7Tjva9526BNyKeQZA5eU7lT/h2VzVs+OScq8NItEmyZHigdvbEHAqwPXH25A/plnfFShSNB33dq8F9i1pMV8qDyZ2qTCzWTaXxaIZKL/Co1R4BDKai8eqsgbPS6k6I0dDgrp5kC+lFPpuC6YWEAlztAJ154xiY1I7BWo/FZDHMIC3TD/zoZVCOuav/k0Wpw+rA/qpAktwMfbmiv3rY3WyFJRUqqviGAOZDBrnCS8Uq/BDXkIqyKNIGkMH4w17ASLr9V/Sx/03cEkgFUBZfT9CZNoFryWhUFgoUgDJNme6i+zYvANJF+3dQTe4tYC7vn6OkNAqH8/z+NvzbSFM2nIgD7kfsPde0D43ALalhKrcWjdhhe9PRFQrWQC+Ixift7Qm/EHkt5kcxFraA16hO2aEGlgfnNPId7sIt7pbFFRiXe+04b+RidXcbW50Y7ICi1tfz4FsAIVk5ppNAhyNAB5tU3JCqm1Z2y+/oWtIESAkcmVQ1PWTcDX8oL4fBinYlRG07kgKcCjVK0LxRZO7qUSuRNZpqbMqGC6+iiaf1rDFaRqKv8FV9bkbnEkC5suQ3ycPgzPeaDezXzJe+qP/J4BhMwSIMUY4XjYdC2mGWDh9wn+y5qalfz
 b6r9FSqS
 25dgzrF5z/sA6j1qqSf0ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 02:25, Alistair Popple wrote:
> On 2025-09-16 at 22:21 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>> Extend core huge page management functions to handle device-private THP
>> entries.  This enables proper handling of large device-private folios in
>> fundamental MM operations.
>>
>> The following functions have been updated:
>>
>> - copy_huge_pmd(): Handle device-private entries during fork/clone
>> - zap_huge_pmd(): Properly free device-private THP during munmap
>> - change_huge_pmd(): Support protection changes on device-private THP
>> - __pte_offset_map(): Add device-private entry awareness
>>
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>> ---
>>   include/linux/swapops.h | 32 +++++++++++++++++++++++
>>   mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
>>   mm/pgtable-generic.c    |  2 +-
>>   3 files changed, 80 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>> index 64ea151a7ae3..2687928a8146 100644
>> --- a/include/linux/swapops.h
>> +++ b/include/linux/swapops.h
>> @@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>   }
>>   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>   
>> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
>> +
>> +/**
>> + * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
>> + * @pmd: The PMD to check
>> + *
>> + * Returns true if the PMD contains a swap entry that represents a device private
>> + * page mapping. This is used for zone device private pages that have been
>> + * swapped out but still need special handling during various memory management
>> + * operations.
>> + *
>> + * Return: 1 if PMD contains device private entry, 0 otherwise
>> + */
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
>> +}
>> +
>> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +	return 0;
>> +}
>> +
>> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>>   static inline int non_swap_entry(swp_entry_t entry)
>>   {
>>   	return swp_type(entry) >= MAX_SWAPFILES;
>>   }
>>   
>> +static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
> 
> I can't think of a better name either although I am curious why open-coding it
> was so nasty given we don't have the equivalent for pte entries. Will go read
> the previous discussion.

I think for PTEs we just handle all cases (markers, hwpoison etc) 
properly, manye not being supported yet on the PMD level. See 
copy_nonpresent_pte() as an example.

We don't even have helpers like is_pte_migration_entry().

>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index 567e2d084071..0c847cdf4fd3 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>   
>>   	if (pmdvalp)
>>   		*pmdvalp = pmdval;
>> -	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
>> +	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> 
> Why isn't is_pmd_non_present_folio_entry() used here?


I thought I argued that

	if (!pmd_present(pmdval)))

Should be sufficient here in my last review?

We want to detect page tables we can map after all.
-- 
Cheers

David / dhildenb


