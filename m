Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13310CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 00:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AEA58E019B; Tue, 12 Aug 2025 20:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686AD8E0196; Tue, 12 Aug 2025 20:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C888E019B; Tue, 12 Aug 2025 20:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 468A28E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:07:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB9F41165C8
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:07:36 +0000 (UTC)
X-FDA: 83769795312.25.A977305
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CDB91C000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:07:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eWVvdBO7;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755043654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0a9MFRY1h7MOvR8Wbw07bYMzAo5BjE+mq1YNqJVPV/0=;
	b=5hgnY2XsQC9SIJJOHEIXjoQ+qkqwSzya8XdWUDMNUFiVYN9/TYDQ0rgnc9xF4JryCGV/le
	DVsUkbUpSNeL+YOvYlcWyF2wva+e5TaVKChnUMhVAZmxfMp1caF8roV/V0WBRLH/4ksnbq
	1HNzBOqKy/6LzwhQvt5wZ5gyHDwnd6Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eWVvdBO7;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755043654; a=rsa-sha256;
	cv=none;
	b=Hu5i8nHt+WBGot3VNdAagpR+0djnRQL0DeKu9vbAKD5zDyVA6yrd2I/LpSo84CUjnLda9R
	1TzuiHPa/nwNwFqJDj28K9ryybjTosajiJ3rX/X62j6Kj23Km5mSd9CTTSwMTy0YE5OMEN
	5AGAfe6983f6rhCDI0H8wpvPGGg5MpY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755043653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0a9MFRY1h7MOvR8Wbw07bYMzAo5BjE+mq1YNqJVPV/0=;
	b=eWVvdBO7kaWROlDpyH76CeXgbDoIGb8ozYls2T8GjRxtaf8pNlhFnmKHR5xJ9YbMI9fAlC
	uXRR5C15jRD3SDvX1YKBLCDanjjAwJr7ycrCZdldPfg8UXJp59hXqHFPL7frVH0H8RGVRI
	f8vc62d8waV+rZpApNyxa4vV441CpCA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-_7Z_u0GkMna5hN0MQVJXfg-1; Tue, 12 Aug 2025 20:07:31 -0400
X-MC-Unique: _7Z_u0GkMna5hN0MQVJXfg-1
X-Mimecast-MFC-AGG-ID: _7Z_u0GkMna5hN0MQVJXfg_1755043650
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55ba198c6f6so5451729e87.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755043650; x=1755648450;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0a9MFRY1h7MOvR8Wbw07bYMzAo5BjE+mq1YNqJVPV/0=;
        b=kGcqQbw5ZPzE2A3oiThOjHQ7J2cW2QH0WU2whfWbJdgeske+9XP20egReF7NDiwCHe
         Fok6ZJcPx9qkK2QVecvj0FbsWSpzh4ptKZJOp1NCinhSl+kw4S0Y70h2lxk/FfBs5Qos
         tfyFXVUiVIRzGave/5VJY1BWwTxdrCptI+BP0vBKQQb3jA2rdCGDFHoOKmZdrCOgdM7B
         MeYOis8+whySKN3cmuuSEHbEWTKf3Aug8nrTRvq0GDIJcmIZcTddNfaO7xNHKw2qiTUq
         R+lPx4tpzQ/6D+2amkX7WSrFQQiMtWze99R2RpuPc3j1dn99MFWbubodfmlTdoeaqwg2
         wJmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd2kWBw9pUiQQJACRhMxB9akUHOJYYjoHTjC+k/OfH/jbUWmRpnSh2ozFDEV50XWOMyPcldBkW9A==@kvack.org
X-Gm-Message-State: AOJu0YwbCLIblBgmmAo2Ap+Kx1JXAu0+fXIGCPgAs3k1NgZe8jjROMl2
	Zrzia4H1yJGUgR8tWv12ILNYg+c3+TdY/Bf8ZKBi6RU/loijBE7k+zYdyRdgH4mfL4+pdE/FgTe
	9SC3V1MZiOYFi7ibXXxfbiAxALxMTNbPOpfzsmfZgrSp2q5Pwekw=
X-Gm-Gg: ASbGncueDxIpPURmc1PugwF+pEH08mzXd0z0wawY/kLOBMD6uqjzEb0ZZxYPjxy0hK9
	k62465LPKYefXapjfyTp1Z86Fe+Lzk2M2MQOHU3k3cMXt6r1PqHjZ2gxRyfJ7VglhNG4RzWIOM8
	7jgSe96s4mCIqwABtaYcP3i5E6YJfLDDRVBeKuJ/XANThXKFpVhxJ4Ty5YjpoKzBKUfRLxy+MRB
	3PmvpG/EP462MGe+aRiN46dl7B/9T/kRE16LzSSufqrBDQpVTc1jAe0kHdEhH5J+gItHUa0MuZf
	KH1ijBuZkTdtN6Nqj2AWiqmhChp/BmD3DVsRYJuEYzNGzhnW8FCqaGfIGXDjOymMVA==
X-Received: by 2002:a05:6512:ba1:b0:55b:8afb:e638 with SMTP id 2adb3069b0e04-55ce03b91b8mr315102e87.28.1755043650218;
        Tue, 12 Aug 2025 17:07:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoQmb2RmNCvZXTt3hToKciHGnkn/S73hvzckTVORzr7wB8qpotmzY9QkrR7LiLIPfgHMO0bA==
X-Received: by 2002:a05:6512:ba1:b0:55b:8afb:e638 with SMTP id 2adb3069b0e04-55ce03b91b8mr315092e87.28.1755043649706;
        Tue, 12 Aug 2025 17:07:29 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8898be9bsm5046839e87.12.2025.08.12.17.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 17:07:29 -0700 (PDT)
Message-ID: <23a3e9b9-ad35-4469-884d-279aac0868de@redhat.com>
Date: Wed, 13 Aug 2025 03:07:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 03/11] mm/migrate_device: THP migration of zone device pages
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-4-balbirs@nvidia.com>
 <81ca37d5-b1ff-46de-8dcc-b222af350c77@redhat.com>
 <9207451b-ebd1-46d5-b277-2adf3028f361@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <9207451b-ebd1-46d5-b277-2adf3028f361@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fx_kOCEulsQ3YWkWdxtRPM93rV6BBgjbvy1D_iAjcAs_1755043650
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CDB91C000C
X-Stat-Signature: ixjzgddnjh6gd4xc57q6tjj4j6yahdh5
X-Rspam-User: 
X-HE-Tag: 1755043653-557666
X-HE-Meta: U2FsdGVkX1/Lw4mNCa08uSSvE1w3paJcwY8HrWLpohu9xpnJX2O2tFpPxzfBBZj6kyYAOvXHbC3YO9okoMLFC0FPm3yICU93NEnUEfaVFDucYNNMttgOFxLK46+FPgy49D4z/TcDt0PemWBMCjwVvFYSz9nXN2nXs+IyWE1oE67vR1Hmc6tQsgFMYrVAQ2PMGacc+7tSNxFCzptal2gCX7h7sePrqS4qkU8ro6tvNBcd+kRQP7yZ18THcxcrvyjp4/hwnckYibzYsOtau5JELpNihciTrDHEihjm16nOeZwUGP7cbVDR8jgWBZ7OOmXFtJgjnVqbavVTMK6n306tgc8uXErlZm5ukw9F9X+2ZBQWoBkSVWs9ihb4NBsPSnqj6K+hOwt1fmykj8HchzRbRRTPuqxDxGJ2UpMJwf+LvRmTxbwlM3QcAVemjDDGw1+657WrGMdTQ3vXjXrPjfmQcOPJew+zRV5O0SDtZM1GeNO3BEOmWuQblpFxjmt6xK/SPWv7T4PZxnj6dLJihAtA1NRMT40qXUOGeyzl7s4sXDlpjPeUN+F5EvXvdJUntK04nBoMNt7uuDLPzKgXSY+2h0Y6D8Y6+iK/lLfSwBg0542++5PIHBmgRHgSUL+EsLg+rydnkEm0e0X0xGdxQoBdFL7l+PHztWymhdxIWt/dlgNlf+PBu4A7nhy4xu/vRvLRW9MRvdQDe4s9jxewsKYyHelvDIRMJf+Yz3jyyX+Hb8aVU9bzOSC2XhzS5FSxS2hyv/+BZZndOaAe7CePJrrmT7p60Ak1nwAprfCb/KJGcLH5ufl1mWt6j5R8P77YyoggqrWIqq0cUvl9nB3AnHis7eIhwbPJOyNsBFJD/SphdAZ2m4Q6x/AHQPX1RNkxLl0dZFrK3Mzj+oHeWskBhLrIPmlbT9ZZTquKJds5rzOpXbzyHBvYOr7qic4X/t/DaiX7sEe2CJHWE1yltVM5nrL
 upGB8Wz5
 XpzA8ULHacvN13aEagWDnjt3J+QC+m9PE9/O83frKz4DZVeIqTZkWAeTcAuAXshTyH1s4hLeUSI3t0lpI+ag21Q1+5Jt7vas5kafL+GpTvxC+EdGeba49LvxjWXSEH6DEcdUq458ncwAEOJMcSmLGoqgHFwLzxSMx0lAXE3c4pMXCLrHYnnbhxZ4Jri7IVRa9AjJsgjS+c4zjkZWMaj3npnyLj1AZHBbr+gW1MpAb/38xmkK56H51gWmhG+O4ROqGyn4PF0kfbJWgF0YcWWi36lsPOq2D+AgeDJghDw64CfU3ofvCEcGT789/EGXKUnH2nNJGy2/wosuPpZJoj6BA3MKY5bxy7Qk2GQtEWBqstfWD3cMt1PtL2HICbvZC8RNcq/4e9ZCl7u/UuoVk0KrNZPAVMw2gxTj8DhjZ9MXi9PpsL+6x6ofG1u4MgfWm5xqFsvtQSdFnNRONnjJZ9iwb/2RVUWy7YnRyIJnhYemI8E05SU+KdK9ZpMaeR6H3UN7OyivcLJEWDwk15b/x+PICFihNGA2olVKq3aA3nRpTQp7Vr1ZHORecy6d15rX1h7GIbX6kbBmvthcGcEmC6PJUnSRSMJIQe277l7UTslWv+UA/sOX/OFxk0s0M7WBAWMr7FGjP7sXhdYUObaXp8GvZ9LDhvz7KsRpaoo70Cac5EMTX3NLzDQITgpQsz7Zw7rpv7wcp0Ol7nrQ9Indzw/EpEphgI9bw0d5Ev/29aHpv29sBbLbykGCqbUG2jwGU/vORuhVeZH/P8vav8/Mwg4yPeeRAIv1a0ZYOgeJ6bUiTkasmwjhWJkJmAtS4TcsudzdGXTp9t4lNRwAGmEid6KLrf5t/PgtdLFlK5JR2EYADzmw8NUey/Scb2tAfkYjK4T0hnAZzuJchnJJnZ80IJhoiRFsqjcRfKQtcOcd49UbhUUtXUwMx1XgDkcS+q/+hDgnWVl1o14utukjfHADaeI3G9WFitwSW
 yZR3xAZS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/13/25 02:36, Balbir Singh wrote:

> On 8/12/25 15:35, Mika Penttilä wrote:
>> Hi,
>>
>> On 8/12/25 05:40, Balbir Singh wrote:
>>
>>> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
>>> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
>>> device pages as compound pages during device pfn migration.
>>>
>>> migrate_device code paths go through the collect, setup
>>> and finalize phases of migration.
>>>
>>> The entries in src and dst arrays passed to these functions still
>>> remain at a PAGE_SIZE granularity. When a compound page is passed,
>>> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
>>> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
>>> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
>>> representation allows for the compound page to be split into smaller
>>> page sizes.
>>>
>>> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
>>> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
>>> and migrate_vma_insert_huge_pmd_page() have been added.
>>>
>>> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
>>> some reason this fails, there is fallback support to split the folio
>>> and migrate it.
>>>
>>> migrate_vma_insert_huge_pmd_page() closely follows the logic of
>>> migrate_vma_insert_page()
>>>
>>> Support for splitting pages as needed for migration will follow in
>>> later patches in this series.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>>  include/linux/migrate.h |   2 +
>>>  mm/migrate_device.c     | 457 ++++++++++++++++++++++++++++++++++------
>>>  2 files changed, 396 insertions(+), 63 deletions(-)
>>>
>>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>>> index acadd41e0b5c..d9cef0819f91 100644
>>> --- a/include/linux/migrate.h
>>> +++ b/include/linux/migrate.h
>>> @@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>>>  #define MIGRATE_PFN_VALID	(1UL << 0)
>>>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>>>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>>> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>>>  #define MIGRATE_PFN_SHIFT	6
>>>  
>>>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>>> @@ -147,6 +148,7 @@ enum migrate_vma_direction {
>>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>>>  };
>>>  
>>>  struct migrate_vma {
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 0ed337f94fcd..6621bba62710 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/pagewalk.h>
>>>  #include <linux/rmap.h>
>>>  #include <linux/swapops.h>
>>> +#include <asm/pgalloc.h>
>>>  #include <asm/tlbflush.h>
>>>  #include "internal.h"
>>>  
>>> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>  	if (!vma_is_anonymous(walk->vma))
>>>  		return migrate_vma_collect_skip(start, end, walk);
>>>  
>>> +	if (thp_migration_supported() &&
>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
>>> +						MIGRATE_PFN_COMPOUND;
>>> +		migrate->dst[migrate->npages] = 0;
>>> +		migrate->npages++;
>>> +		migrate->cpages++;
>>> +
>>> +		/*
>>> +		 * Collect the remaining entries as holes, in case we
>>> +		 * need to split later
>>> +		 */
>>> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>> +	}
>>> +
>>>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>>>  		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
>>>  		migrate->dst[migrate->npages] = 0;
>>> @@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
>>>  	return 0;
>>>  }
>>>  
>>> -static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>> -				   unsigned long start,
>>> -				   unsigned long end,
>>> -				   struct mm_walk *walk)
>>> +/**
>>> + * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
>>> + * folio for device private pages.
>>> + * @pmdp: pointer to pmd entry
>>> + * @start: start address of the range for migration
>>> + * @end: end address of the range for migration
>>> + * @walk: mm_walk callback structure
>>> + *
>>> + * Collect the huge pmd entry at @pmdp for migration and set the
>>> + * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
>>> + * migration will occur at HPAGE_PMD granularity
>>> + */
>>> +static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>> +					unsigned long end, struct mm_walk *walk,
>>> +					struct folio *fault_folio)
>>>  {
>>> +	struct mm_struct *mm = walk->mm;
>>> +	struct folio *folio;
>>>  	struct migrate_vma *migrate = walk->private;
>>> -	struct folio *fault_folio = migrate->fault_page ?
>>> -		page_folio(migrate->fault_page) : NULL;
>>> -	struct vm_area_struct *vma = walk->vma;
>>> -	struct mm_struct *mm = vma->vm_mm;
>>> -	unsigned long addr = start, unmapped = 0;
>>>  	spinlock_t *ptl;
>>> -	pte_t *ptep;
>>> +	swp_entry_t entry;
>>> +	int ret;
>>> +	unsigned long write = 0;
>>>  
>>> -again:
>>> -	if (pmd_none(*pmdp))
>>> +	ptl = pmd_lock(mm, pmdp);
>>> +	if (pmd_none(*pmdp)) {
>>> +		spin_unlock(ptl);
>>>  		return migrate_vma_collect_hole(start, end, -1, walk);
>>> +	}
>>>  
>>>  	if (pmd_trans_huge(*pmdp)) {
>>> -		struct folio *folio;
>>> -
>>> -		ptl = pmd_lock(mm, pmdp);
>>> -		if (unlikely(!pmd_trans_huge(*pmdp))) {
>>> +		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>>>  			spin_unlock(ptl);
>>> -			goto again;
>>> +			return migrate_vma_collect_skip(start, end, walk);
>>>  		}
>>>  
>>>  		folio = pmd_folio(*pmdp);
>>>  		if (is_huge_zero_folio(folio)) {
>>>  			spin_unlock(ptl);
>>> -			split_huge_pmd(vma, pmdp, addr);
>>> -		} else {
>>> -			int ret;
>>> +			return migrate_vma_collect_hole(start, end, -1, walk);
>>> +		}
>>> +		if (pmd_write(*pmdp))
>>> +			write = MIGRATE_PFN_WRITE;
>>> +	} else if (!pmd_present(*pmdp)) {
>>> +		entry = pmd_to_swp_entry(*pmdp);
>>> +		folio = pfn_swap_entry_folio(entry);
>>> +
>>> +		if (!is_device_private_entry(entry) ||
>>> +			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
>>> +			(folio->pgmap->owner != migrate->pgmap_owner)) {
>>> +			spin_unlock(ptl);
>>> +			return migrate_vma_collect_skip(start, end, walk);
>>> +		}
>>>  
>>> -			folio_get(folio);
>>> +		if (is_migration_entry(entry)) {
>>> +			migration_entry_wait_on_locked(entry, ptl);
>>>  			spin_unlock(ptl);
>>> -			/* FIXME: we don't expect THP for fault_folio */
>>> -			if (WARN_ON_ONCE(fault_folio == folio))
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> -			if (unlikely(!folio_trylock(folio)))
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> -			ret = split_folio(folio);
>>> -			if (fault_folio != folio)
>>> -				folio_unlock(folio);
>>> -			folio_put(folio);
>>> -			if (ret)
>>> -				return migrate_vma_collect_skip(start, end,
>>> -								walk);
>>> +			return -EAGAIN;
>>>  		}
>>> +
>>> +		if (is_writable_device_private_entry(entry))
>>> +			write = MIGRATE_PFN_WRITE;
>>> +	} else {
>>> +		spin_unlock(ptl);
>>> +		return -EAGAIN;
>>> +	}
>>> +
>>> +	folio_get(folio);
>>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>>> +		spin_unlock(ptl);
>>> +		folio_put(folio);
>>> +		return migrate_vma_collect_skip(start, end, walk);
>>> +	}
>>> +
>>> +	if (thp_migration_supported() &&
>>> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>>> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>>> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>>> +
>>> +		struct page_vma_mapped_walk pvmw = {
>>> +			.ptl = ptl,
>>> +			.address = start,
>>> +			.pmd = pmdp,
>>> +			.vma = walk->vma,
>>> +		};
>>> +
>>> +		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
>>> +
>>> +		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
>>> +						| MIGRATE_PFN_MIGRATE
>>> +						| MIGRATE_PFN_COMPOUND;
>>> +		migrate->dst[migrate->npages++] = 0;
>>> +		migrate->cpages++;
>>> +		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>>> +		if (ret) {
>>> +			migrate->npages--;
>>> +			migrate->cpages--;
>>> +			migrate->src[migrate->npages] = 0;
>>> +			migrate->dst[migrate->npages] = 0;
>>> +			goto fallback;
>>> +		}
>>> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
>>> +		spin_unlock(ptl);
>>> +		return 0;
>>> +	}
>>> +
>>> +fallback:
>>> +	spin_unlock(ptl);
>>> +	if (!folio_test_large(folio))
>>> +		goto done;
>>> +	ret = split_folio(folio);
>>> +	if (fault_folio != folio)
>>> +		folio_unlock(folio);
>>> +	folio_put(folio);
>>> +	if (ret)
>>> +		return migrate_vma_collect_skip(start, end, walk);
>>> +	if (pmd_none(pmdp_get_lockless(pmdp)))
>>> +		return migrate_vma_collect_hole(start, end, -1, walk);
>>> +
>>> +done:
>>> +	return -ENOENT;
>>> +}
>>> +
>>> +static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>> +				   unsigned long start,
>>> +				   unsigned long end,
>>> +				   struct mm_walk *walk)
>>> +{
>>> +	struct migrate_vma *migrate = walk->private;
>>> +	struct vm_area_struct *vma = walk->vma;
>>> +	struct mm_struct *mm = vma->vm_mm;
>>> +	unsigned long addr = start, unmapped = 0;
>>> +	spinlock_t *ptl;
>>> +	struct folio *fault_folio = migrate->fault_page ?
>>> +		page_folio(migrate->fault_page) : NULL;
>>> +	pte_t *ptep;
>>> +
>>> +again:
>>> +	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>>> +
>>> +		if (ret == -EAGAIN)
>>> +			goto again;
>>> +		if (ret == 0)
>>> +			return 0;
>>>  	}
>>>  
>>>  	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>> @@ -222,8 +334,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>  			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
>>>  		}
>>>  
>>> -		/* FIXME support THP */
>>> -		if (!page || !page->mapping || PageTransCompound(page)) {
>>> +		if (!page || !page->mapping) {
>>>  			mpfn = 0;
>>>  			goto next;
>>>  		}
>>> @@ -394,14 +505,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
>>>  	 */
>>>  	int extra = 1 + (page == fault_page);
>>>  
>>> -	/*
>>> -	 * FIXME support THP (transparent huge page), it is bit more complex to
>>> -	 * check them than regular pages, because they can be mapped with a pmd
>>> -	 * or with a pte (split pte mapping).
>>> -	 */
>>> -	if (folio_test_large(folio))
>>> -		return false;
>>> -
>> You cannot remove this check unless support normal mTHP folios migrate to device, 
>> which I think this series doesn't do, but maybe should?
>>
> mTHP needs to be a follow up series, there are comments in the cover letter. I had an
> assert earlier to prevent other folio sizes, but I've removed it and the interface
> to drivers does not allow for mTHP device private folios.
>
> Balbir
>
pte mapped device private THPs with other sizes also can be created as a result of pmd and folio splits. 
Your should handle them in one place consistently not by different drivers. 
As pointed by Matthew, there's the problem with the fault_page if not split and just ignored.


--Mika


