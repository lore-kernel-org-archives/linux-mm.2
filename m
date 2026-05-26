Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB4ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C096B00C1; Tue, 26 May 2026 10:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC8C6B00C2; Tue, 26 May 2026 10:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4776B00CE; Tue, 26 May 2026 10:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 049CA6B00C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:44:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C83B88D51C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:44:17 +0000 (UTC)
X-FDA: 84809841354.13.098DB0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E6FA40013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:44:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEmcb7WZ;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyIIbjBTqwfbMVlKvJKq+a7b1lcX+MkWTKq5+X2mHLA=;
	b=tRU8saLfcfcz8mQ71UyliwAPilRJpZfoZTteaTdCf1x2cxd47Jd86376kuBsxcJk+BUwsa
	23DtRF00PbUueVREhlwpwJpppHYs6VDw4FjQIPbAuu6K/oa8VpclnWKaXBFoenvf/pvaf0
	m8h4GQlNekaD5/8PHCpPFkLbhOP7WJA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jEmcb7WZ;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806655; a=rsa-sha256;
	cv=none;
	b=P5tVg8+DlbN8nYwJf6UW/nKvTDxbHnp9Ygkz5Z//Rcg4BfsCy/vwXBB1jCamn7fXzLJx+u
	FMYv+Jh61j4koKAkL8hrVG5J8YAydfjxx05AX4N/8GmguQZ0r0j7dVFj66aa+wFdmqi4jM
	jW/6o80Jgd8dYjgRB4c8hkdum6eOBL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779806654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HyIIbjBTqwfbMVlKvJKq+a7b1lcX+MkWTKq5+X2mHLA=;
	b=jEmcb7WZJqPUl/zcoPpn4nQaNpqoGaRyp55ybQFbrZBiskQxQlGojb8vyFcLpL7e+4DI6L
	S7wV+WOzf6PuLjL9O12Ki1pHqhiRhiZ85n5pcHlyIw5eL2PlesXdGPttMTh6tMFcz6Z/g5
	fePXXu7zbVtNFqDePyIGTGF0kdxkqIY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-rHy-IwtwO_mHCb5_GAaWfQ-1; Tue, 26 May 2026 10:44:11 -0400
X-MC-Unique: rHy-IwtwO_mHCb5_GAaWfQ-1
X-Mimecast-MFC-AGG-ID: rHy-IwtwO_mHCb5_GAaWfQ_1779806650
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48fd33b4921so69142665e9.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 07:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779806650; x=1780411450;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HyIIbjBTqwfbMVlKvJKq+a7b1lcX+MkWTKq5+X2mHLA=;
        b=Qb9+uQ9Q9hoUh3l3PR8DLfkEZ7DLdTYS41/TRPEdPM5Ln35ptGV2zCYH0nW2OQOj2j
         Z5Y/jAaVl2wa+2VY7yD/+zbVHfaPiy7NDi0OdSTbcEF0RsJL3J8GsqQ2wqlXvQte3Uz+
         0CjVpv0732RF1LhTddgbAAdkNECiNSpUrKrahhk/YGo/EaoKzH75Tua1TCgDpgkV7RR/
         /6GOF1rdP9+WY3HqPLSR1YoPjqAdjWQOexwe2J0+RGXBMg1RieeRKYYO7p1Jy57asTn9
         Cz9zqEKMYcMDsjjOuv/qHvNhLAxD6eEZ67LHTN4vFJKPSBSVtJVvHnni32SgeAUP9PLZ
         ajMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8exOSvypbh9jMeRd0pDslEmwjFYMa4iIpGm0wlhqaNxDIhJWVDPdJrDJIqlJd2sEN8L2tjaDkaAA==@kvack.org
X-Gm-Message-State: AOJu0YyJC0doQ+mlzTyKWTTChLIf5mx+sE4nb48NjYG6lEEvCn6HD471
	187Fpcp64+AYZsl59qNNQHjqYpdJb+96o4NTcFmGUVR3wzxpM5DC2HekSjqkAcIepqsB3KlLIKg
	iwXuCY/6ZlJLbleGj8XyeEojYdaIX1SUQAeqbJT/FrRSehOUHLgTN
X-Gm-Gg: Acq92OEJggR1I+/HuVtzlrfCEgDU1BB0/57XLDyQ+S9cLqz4XXSTeHbtEt6VA9JEmuU
	rbDWnyhz1Vft9u2aMh54i7JWHT2sRM2nDWDdOTyCmfyBkl60UxiVWeoi7bzk5lYoui4ftpZ3JEV
	SM/LcTlpoWh6kujhTz3xLqtkBBGtAM3qXGxs4O2cInhW/tstIEV1F769xdeIZgLL9JlHcG0zuha
	TCvcmX46KHyCbtEsUP9sg3wlCbUVQm3v5lWvMpkHldhZw3n2pJfIf5LyBzdifJ0FaXQ802nqqfo
	CzQeFlycpTEhY1yE61qdfJjlNe1N29vA+9MH6UWy8LQwGwpxQkH8dzMMWaaOYbPqqPlnluF6UCn
	AJXlrCUBvZ8Twq7nA52pmb2w=
X-Received: by 2002:a05:600c:4583:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-49042252732mr314245345e9.0.1779806649601;
        Tue, 26 May 2026 07:44:09 -0700 (PDT)
X-Received: by 2002:a05:600c:4583:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-49042252732mr314244805e9.0.1779806649077;
        Tue, 26 May 2026 07:44:09 -0700 (PDT)
Received: from [192.168.1.144] ([88.147.84.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454b7d57sm327015375e9.15.2026.05.26.07.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 07:44:08 -0700 (PDT)
Message-ID: <b457f6e9-ae12-4e1f-8484-f3043ca62276@redhat.com>
Date: Tue, 26 May 2026 08:45:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 14/14] Documentation: mm: update the admin
 guide for mTHP collapse
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Bagas Sanjaya <bagasdotme@gmail.com>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-15-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260522150009.121603-15-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DB_2gTJ2024CGjWIcoogkFg9rCAyIQlP0uX-dq3bctw_1779806650
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 47xkkuz9kfdirg6wqfax5crjf4wa33oy
X-Rspamd-Queue-Id: 3E6FA40013
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779806655-648224
X-HE-Meta: U2FsdGVkX1/EDciXv+fkEDHHHpukxirbPkbNsQtDGZiJu7dw8J3ekuFs9VAKNmAdxhmKWMc0uwRsTaS2w28BIIPxUbGmhTpBHbsV777un/HPZVdp07VW6i6h0mMxVme/+vEILez97FzVW3J6aA7Hojxvk8YuWWDXgAZMVdOGVm5OhWYSoVTIpd8Gz+uu92s0r6IBIYfChrV/y7M8YOnhT/Lq84BQiQM98tVDUbcmCwiqEVVtgxcMruksJXIYbf/Nxq7qw5gdNq4HkNKVIS4mM4DyH0k04Oqm08A1buxS8awinZb4S/hlb3KOr8nhZ18/oryH4UgXB+Gjhr6w5Faz8aNHguKkTjCWTKYt9pK+N/1Qo8C43UAZS9jPc85UUKdRKzDBBqwjRLa0oq9TZq9AcgsQCwLuaDjWinwJMH5ZYaaOJb/S4d1832l4+bm4rwerGy+d81CTtcK76O6UIu9nDG1Okx99fPrO2AEiwGBhgqFhY1IBcteQ3tKW9zPHEfiWK4MjaCp6IIDt46Q8B7uxnlv3/CFe4EF0KbthywGFrYnEIdsLrvVi4jZJ0oLVlSHMZTy/PlGaocE26WCdlsL8JZHHAiwN7lSFjuYFDeIQyH0TgjghcWPqgPwAXMOMnzvhwvgYtoSAa6vdMVxlRwkdBo4hnI6QbMj/dg+X1s90S3kiXVjC2Xzu5Db2Vi8+ok2yFHt/N1q6vllXvGqF2m58t8vpOFmlmkJaFzQ2SEUp2LnMNFAbFGkjk1rrvBNmmQZwkuZ9CZk1RJN/PwQxUtnIyVD29U55cCi1oX0IGLHb4vLYOkL938KM1VjF/a4jE5S+EWDW4rAb9nMdz2M3FfAL4gT/GoFDYNc4yDvRDwMRHsIPP6Gz+WCUTtklgnRSJOwrIpFjCuOEb80KDOPL2sGdSOPNKhf+b/4UwTI2BKC/g2E4PF1VRPCCtToKyzh+LMEPGHn/4NnMSRtKPVHxo2c
 6B3NBn2u
 VkRh5urth9Y3yxo7Hzwrs7LTbhtjXqS/GcsEzGNEpk862mB9Jr6k+yCm06lQ8IxnxTsJsfnfSIcozGUTMxzrF4q2JzMrw2JKWXtXETt+FWZ/KCB3y3rx565aGKNhHFft1q12lwomok6OiIQxb6dabSGLugmWpIIC7UdrSmo940yN5mlOsWV+UOhMfP7Ubx8zQUtTwIXnEyDYaOpzDf+1fuzRoeiUHeOxC5ZNMFyP6oLy46GJ2Z67iBoOsymdh3d7Z2qCJg7OfEsvLGfR2y/XZelLxR7fpCqpIMvAiwLN0xjq4sceAVguFYJr0wvpF/R+tXV7yIcIKncCAl4mqM8fk2jXZnUu13Hg30FNC+7chd6/mSJDz8Y2Lov7mNNI9TNZbvxg/BcZy9UYR9sEYBqiHqx0QR8Xvm8wOQvqdCqGjdNn/wXYWgszpPM49cCwgMGgYmN4eicL4k7gBz8KDTlLRHUtSgdQNvdKloWudbwzcVxlf+5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 9:00 AM, Nico Pache wrote:
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidance on how to utilize it.
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Hi Andrew,

Can you please append the following fixup to this commit. 

The changes are simply undoing a deleted note i added and reworking it slightly to reflect the new khugepaged behavior.

Cheers!
--Nico

commit d81806992231ef920c731e62468a3a1b2ef6b869
Author: Nico Pache <npache@redhat.com>
Date:   Tue May 26 07:47:42 2026 -0600

    fixup: add back note and edit doc about khugepaged limits
    
    Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 644869d3adfd..ebec1e6b0e6b 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -265,6 +265,11 @@ support the following arguments::
 Khugepaged controls
 -------------------
 
+.. note::
+   khugepaged currently only searches for opportunities to collapse file/shmem
+   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
+   sizes.
+
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's


>  Documentation/admin-guide/mm/transhuge.rst | 50 +++++++++++++---------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 80a4d0bed70b..644869d3adfd 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -63,7 +63,8 @@ often.
>  THP can be enabled system wide or restricted to certain tasks or even
>  memory ranges inside task's address space. Unless THP is completely
>  disabled, there is ``khugepaged`` daemon that scans memory and
> -collapses sequences of basic pages into PMD-sized huge pages.
> +collapses sequences of basic pages into huge pages of either PMD size
> +or mTHP sizes, if the system is configured to do so.
>  
>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>  interface and using madvise(2) and prctl(2) system calls.
> @@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_underused, and enable it by writing
>  	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>  	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>  
> -khugepaged will be automatically started when PMD-sized THP is enabled
> +khugepaged will be automatically started when any THP size is enabled
>  (either of the per-size anon control or the top-level control are set
>  to "always" or "madvise"), and it'll be automatically shutdown when
> -PMD-sized THP is disabled (when both the per-size anon control and the
> +all THP sizes are disabled (when both the per-size anon control and the
>  top-level control are "never")
>  
>  process THP controls
> @@ -264,11 +265,6 @@ support the following arguments::
>  Khugepaged controls
>  -------------------
>  
> -.. note::
> -   khugepaged currently only searches for opportunities to collapse to
> -   PMD-sized THP and no attempt is made to collapse to other THP
> -   sizes.
> -
>  khugepaged runs usually at low frequency so while one may not want to
>  invoke defrag algorithms synchronously during the page faults, it
>  should be worth invoking defrag at least in khugepaged. However it's
> @@ -296,11 +292,11 @@ allocation failure to throttle the next allocation attempt::
>  The khugepaged progress can be seen in the number of pages collapsed (note
>  that this counter may not be an exact count of the number of pages
>  collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
> -being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
> -one 2M hugepage. Each may happen independently, or together, depending on
> -the type of memory and the failures that occur. As such, this value should
> -be interpreted roughly as a sign of progress, and counters in /proc/vmstat
> -consulted for more accurate accounting)::
> +being replaced by a PMD mapping, or (2) physical pages replaced by one
> +hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
> +or together, depending on the type of memory and the failures that occur.
> +As such, this value should be interpreted roughly as a sign of progress,
> +and counters in /proc/vmstat consulted for more accurate accounting)::
>  
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
>  
> @@ -308,16 +304,21 @@ for each pass::
>  
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
>  
> -``max_ptes_none`` specifies how many extra small pages (that are
> -not already mapped) can be allocated when collapsing a group
> -of small pages into one large page::
> +``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
> +when collapsing a group of small pages into one large page::
>  
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>  
> -A higher value leads to use additional memory for programs.
> -A lower value leads to gain less thp performance. Value of
> -max_ptes_none can waste cpu time very little, you can
> -ignore it.
> +For PMD-sized THP collapse, this directly limits the number of empty pages
> +allowed in the 2MB region.
> +
> +For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. At
> +HPAGE_PMD_NR - 1, we collapse to the highest possible order. Any intermediate
> +value will emit a warning and mTHP collapse will default to max_ptes_none=0.
> +
> +A higher value allows more empty pages, potentially leading to more memory
> +usage but better THP performance. A lower value is more conservative and
> +may result in fewer THP collapses.
>  
>  ``max_ptes_swap`` specifies how many pages can be brought in from
>  swap when collapsing a group of pages into a transparent huge page::
> @@ -337,6 +338,15 @@ that THP is shared. Exceeding the number would block the collapse::
>  
>  A higher value may increase memory footprint for some workloads.
>  
> +.. note::
> +   For mTHP collapse, khugepaged does not support collapsing regions that
> +   contain shared or swapped out pages, as this could lead to continuous
> +   promotion to higher orders. The collapse will fail if any shared or
> +   swapped PTEs are encountered during the scan.
> +
> +   Currently, madvise_collapse only supports collapsing to PMD-sized THPs
> +   and does not attempt mTHP collapses.
> +
>  Boot parameters
>  ===============
>  


