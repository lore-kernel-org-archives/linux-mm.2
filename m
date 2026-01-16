Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7D5D47CD1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742856B0088; Fri, 16 Jan 2026 05:33:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFF16B0089; Fri, 16 Jan 2026 05:33:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1786B008A; Fri, 16 Jan 2026 05:33:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 498AE6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:33:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9BC81A056E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:33:08 +0000 (UTC)
X-FDA: 84337464456.06.A096E9A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 735EE100002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:33:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aqbZvnhA;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768559586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YXd/m3+AVM4e1ysf2ifYY+anBmpbJHUpwkVBLh6Ky4=;
	b=3HrTXNequ003ddPwjuUGt4SEUIWeJHm/SOhMo/3zSIyaI9p1SMYgYyexlmLhpUZkZDamIG
	EWp/UX5ZkQ5iNQSRuOQwKBWkoVe9AqtVw2373zikWgZhz964ArKNpRICnZ76QjGGo8kCvv
	WVfDgND/q7oljxS1jNChyZz3/2Zk420=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768559586; a=rsa-sha256;
	cv=none;
	b=p51peIB+suDolTlD9JcjPomsZBBboekrRpNjKrd0wFPpPc8VsbPqIq0suF8H3U7ZixZOt9
	0soMAS+cGdoWypecpG+y2Qbe/Zbyu2lYc1hQXbI36bt2JrxriLJyZz0G/z6YDLY9F8T4aq
	Gv2s5EeBWWkIgUxCZtuygCF5/tAjV8w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aqbZvnhA;
	spf=pass (imf05.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768559585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5YXd/m3+AVM4e1ysf2ifYY+anBmpbJHUpwkVBLh6Ky4=;
	b=aqbZvnhA9yWJ/xcIdIA5AbMoRqsTqnICNfAyME6LXmHNl09TeUm/NeJ6OceKdBPZdo9eJk
	S/vvzgNLWgSAMM0T6i1V9tt9i2aw/eQyNYmiHFkEu6SFkWHm8PTDRwwU2Yed0Jsoa51Qjp
	0NhW6W3Hl4LIaD0jGGdP8Lz0oqGnfIU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-eRUbEzq1PWSe4sZOXYlnjQ-1; Fri, 16 Jan 2026 05:33:04 -0500
X-MC-Unique: eRUbEzq1PWSe4sZOXYlnjQ-1
X-Mimecast-MFC-AGG-ID: eRUbEzq1PWSe4sZOXYlnjQ_1768559583
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-383558ea1b7so9879101fa.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768559583; x=1769164383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YXd/m3+AVM4e1ysf2ifYY+anBmpbJHUpwkVBLh6Ky4=;
        b=FqyJOM7/mQJakT6mZNMps+a7NKcvaJyCP7CpjtOqcuWOGgKjDbz8ff1sjIs/Zxi5xf
         G1BukVm8cnNc38wXL/evbhPMe4dbug5RRM4tw/tnUv+zhujaZ8ij/7FLQzODqnxEbXZl
         jj6QnfqgID6sO4zMYIlNWcX8+yfNPOrk4tr3IPjnKUtWm7Y+AxWPSz4E8rRHyQtz1vwy
         66+fQvuFXXRdFZuGIX06GBtB+9ByfTYZX/C114WrnkPqPlH7/bGr266KDoR7j40yxu7H
         ju2XPimS/2/eq4RH/1j0WISWUJGQ/MvOfmzwo0yTGu1Cdf9V261b9cA0lQk9pwB3w0sN
         p5UA==
X-Forwarded-Encrypted: i=1; AJvYcCXb9tO91MWszaQne5ElzGYSXD0okByEzsZmuN/YfARMNB0t+TXOEoEMcUrVixziOFfkpjrxp8lJAg==@kvack.org
X-Gm-Message-State: AOJu0YzoVmxlhqGplSPFC7ZhIDz99S3n7PNfok5mbKOfaLZ+jOPKZQ4/
	wgvsEpgmu/Oqqc5eJMw/noePN5js9a2K426u1JhqysWFi1MG7Bympg8Y0yNr5ftb1TyZHVoPP4v
	Cd1hXt/yIFvxv7SWF7gXUIMaXrC1E8PzSIdVcaHU7uwoictkMhCo=
X-Gm-Gg: AY/fxX7UTq7b3nisGKIRIH0OBb3O+IMiQI5NlnaERqWppbd5EmGxRuvCW+wGOo2/L1k
	swSOMZPTk72IXryAfU7Smwf8LzkbYEwMb832XuyakLCfmK6/pNBBe6sHcUxnOiWOJIfkHzIUGGL
	ql2gbOubhHZuDocLx/M52sOScbw6p6nADsJhptU45Yac8/xWI2MGQDTxLwSWg+9+8JQcKU1dy8K
	Bk5eJ+8sq38XXEuSW/Jc4VHZ905wrNtVLUnLfFEHLnZJgd/uJISjPZ60S450R63LAE9x7xexIP2
	mjY44rpLQvXmgyNv8Qr2cQhZ4S1itsfnWP6lNrSJG10sQWzqLK9lpgS3GLl+BwHsQ2lMo2/SmHu
	VWWqnt2X+jtSbdTyiYvr0hTlIsAQvvn3nNEs=
X-Received: by 2002:a2e:be8f:0:b0:37b:b00b:799d with SMTP id 38308e7fff4ca-38384269cdemr6704121fa.24.1768559582725;
        Fri, 16 Jan 2026 02:33:02 -0800 (PST)
X-Received: by 2002:a2e:be8f:0:b0:37b:b00b:799d with SMTP id 38308e7fff4ca-38384269cdemr6703981fa.24.1768559582254;
        Fri, 16 Jan 2026 02:33:02 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384fb9ab8sm6522041fa.48.2026.01.16.02.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 02:33:01 -0800 (PST)
Message-ID: <0a5e6358-9383-4605-bfb7-d2cc48335458@redhat.com>
Date: Fri, 16 Jan 2026 12:33:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Migrate on fault for device pages
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, linux-mm@kvack.org
References: <20260114091923.3950465-1-mpenttil@redhat.com>
 <65cf6d71-9440-423a-9a70-b6b40622440e@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <65cf6d71-9440-423a-9a70-b6b40622440e@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: II6PK3-1MMLjWaxOFvQJ0zLCeewTjV74xnMrvVtTHK4_1768559583
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 735EE100002
X-Rspam-User: 
X-Stat-Signature: tcq5abghayu9e55tp9pgozg47kuj3kxk
X-HE-Tag: 1768559586-618083
X-HE-Meta: U2FsdGVkX19btm82Ig5xFVqYuI2wZgnJ29GZYy7WIeh91XRByPtBiN65CXASVoQg2/hgcmptcG9BPgabP2zO2j1yjTNbALbiCrbGhE9nvhDJ0ILSoFP1opu3BXy5jQf3GH0oI8TZZM9yKPu1L7GlJ0eOIKVeQ16h+fhAGFzVZgV6wZVFArV1TZAVcPozklYB2l19PAU/dQjUXbeDl7ek+ZYb6QtnStARI5UCiRawpqyxFLNfxVREGU9SMU4lkiRSp8tFLc29rNF7ldHsBF0aUieM4jFkFdkR4CJB2twVnfS1fFbXwgtHABXDYz7vr+fuEk/dvA7udKqLQ0usKuON4KGDiPYfkc4ClSXDqtN7Klv2EszSUaMiIajknac8hiwkk07Z2NnSc9p/Otazrdwzj9uH5IIHNt4JPJda50UMi4lpJ0CsetLDc42VbwaSBYufD8Ok+7vHxJkgmBmpge1au0UVZ31h9R2GpM/+6USj4z9/WO9zw/mnyS5a7a+EqBq1duT3fAE0rR+esut5/0TmQn2CCCPmqbTBBY2paHvhEJk+rt/w5mV0uOmnZQdycAICq+jXdWzDOxZaWu2Cz8Zm/dFDVdFjI6KzVrfDRfXQeP0H8n+1tDfihAe9uikw29NNhADtdlq9VR/9wUq3ujbZUE8pgsFUkXPjKxp0HnExiHUA8ioS0zBmJ/ovUPgzs6Vc0s1kFDZdTurpM/zvjbPdcJErBL+6EImhTPXf+pJ4w9rkfnwgpva1R6D1LuVev2gkIJq+R8azzj1bFA3MqkCm+f7QvuUEht7gZwSsdSfmkY3OhiM0Fn9kcxaF/hZA49MsFHumqLIO17hhW3zszc8QvbrY2aZ85nBml/lRac36nYcHc0adcm9eUaORyjMtV37Wc5+cZ+t1jP0eTosdwyx+YEKHTy+ntpgdB4J2k9KX35xssSdefFvPelZXOoCMBKkVp0RxZqdHRbeYVNHMPBq
 LRD/t6JN
 kKi7cUtSaHFccD6LPLaUKN/d2leHLACU02Pcr0beFpxuoJX6btpyxqJO0i9Zp3nZcnS6DJ8aJpGBsfSU+M+JnAdrqo2LnOnktviP6/B7uj+/Agw+wJpPto8rZvq4MQV+kI3lTlpBDu7Ufu2n99KjKXQZaBnSfA7mKgk+inl5FV/w8X6NwEWhC+KiRS6mrI6XalCRxBZ0AT4nY+3zOZPRJ4w1NWtUfaOn9Wfidlh1t97rt9NlSm/FDUHCHIpo73MBWmEGhbeh3sN0HpmGu3P3tkrT/SmudH35YGRH8vwHFkHN8kMhY46slAi09QN7ejW7ffmdreToSTN2yHVQhTxItZWazMZ4IUzowXuruweQD55/YnOMa+SEHj2L0DYYUxl7QARhyFZqMjFsOPQqgO2c22itaXp7+iZZVSe7+Q4WCqN7r7vqusfbdVblZ+KY1B6OY7vwTCN3SR+NVY1/ZMH740Rr5m8DyPpDKGZHE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir!

On 1/16/26 01:16, Balbir Singh wrote:

> On 1/14/26 20:19, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly. One page table walk
>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
>> Tested in X86-64 VM with HMM test device, passing the selftests.
>> Tested also rebased on the
>> "Remove device private pages from physical address space" series:
>> https://lore.kernel.org/linux-mm/20260107091823.68974-1-jniethe@nvidia.com/
>> plus a small patch to adjust with no problems.
>>
>> Changes from RFC:
>>   - rebase on 6.19-rc5
>>   - adjust for the device THP
>>   - changes from feedback
>>
>> Revisions:
>>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>>   
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>>
>> Mika Penttilä (3):
>>   mm: unified hmm fault and migrate device pagewalk paths
>>   mm: add new testcase for the migrate on fault case
>>   mm:/migrate_device.c: remove migrate_vma_collect_*() functions
>>
>>  include/linux/hmm.h                    |  17 +-
>>  include/linux/migrate.h                |   6 +-
>>  lib/test_hmm.c                         | 100 +++-
>>  lib/test_hmm_uapi.h                    |  19 +-
>>  mm/hmm.c                               | 657 +++++++++++++++++++++++--
>>  mm/migrate_device.c                    | 589 +++-------------------
>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>  7 files changed, 869 insertions(+), 573 deletions(-)
>>
>
> I see some kernel test robot failures, I assume there will be a new version
> for review?
>
> Balbir
>
Yes I will fix those and send a new version. The test robot failures are basically 
missing guards for !MIGRATE configs.

Thanks,
Mika


