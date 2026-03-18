Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2551077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE796B02E6; Wed, 18 Mar 2026 15:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786616B02E8; Wed, 18 Mar 2026 15:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BFC6B02E9; Wed, 18 Mar 2026 15:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 551406B02E6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:08:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14AB554E8A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:08:57 +0000 (UTC)
X-FDA: 84560121114.22.981BB6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2DD2B80013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:08:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DC2a0uCQ;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9mKVwa6vsUmWHqI0OSFKEaOfvWTxQGO1i2JeECq6pA=;
	b=whQG+Yq2K2p58PLaSinx2Sd6tEv8NRhfuvg6g3qXwQ1Ex1kGBQbXeLdYmcrh7WMXrQcX24
	xhBhsOZ5p55M8H9ztPM/oWF8ZVZGm+Yo8aIpD9gdF3+zDXdaU/+GOMz5y3EYjRaVO/t2XZ
	PdBVLx713iOw2j6kXDPRFkmPecuh3zA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860933; a=rsa-sha256;
	cv=none;
	b=wD8eIJT8yfaC5LaYhkrkILypQj3Q3ryJZNp2n1PMqXjFsQFue4DVWBweVuroKsD6tkxkiZ
	mBi0XxMhq0o44CcMcdMbMfSY+lE5kajzlBwVsjhujWcI+gkdo3QwTNePpp20nwOm8Cxo1p
	mnUIiAF9zfLtkL5k5eEFFqtPCcP4ky0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DC2a0uCQ;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773860932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9mKVwa6vsUmWHqI0OSFKEaOfvWTxQGO1i2JeECq6pA=;
	b=DC2a0uCQPgv6mZwXJLFUjA8WN25gM26p7EDHuSGiQAKGyT8qeVI7QOgGnnScswnoxR4WPt
	8FEeTjneOOUwXHJpO3pL2l/sHibFwLEIHkXuA9RQnKBVY5h70VzreFvR/EHdO0Y0eSN6VI
	t1kiXyN4Giey2DAfkHi3drxVwXZ4ULM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-umeDd6AWMnKEcjRQ2YXA4w-1; Wed, 18 Mar 2026 15:08:51 -0400
X-MC-Unique: umeDd6AWMnKEcjRQ2YXA4w-1
X-Mimecast-MFC-AGG-ID: umeDd6AWMnKEcjRQ2YXA4w_1773860931
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-89c4a339b6bso14222166d6.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773860931; x=1774465731;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9mKVwa6vsUmWHqI0OSFKEaOfvWTxQGO1i2JeECq6pA=;
        b=TW+bhiuy8KJTPRHbTHu4GPe1vbYsbESAMDrZBtIH0pnfkNYocWem6RLYz8dc4FXZx4
         XA8eU/TDUzr77OHdKpfbbpObuTtGYupkJhvJKzPxJLIfe3EK1dEccYk4v6fwotlQPned
         JvlhM5s/av4kqUQRlieFZfpdsN/0GMbAG4eGWARv9UXxVyLOaNsB9k4/YRoSMhzpI30v
         +7AabgMj/6XBNpsoUrcjYQ+tOPSgoG8Ydyt0mUEMg9/gHj0oJyOmNhdG3LBF6JO+++6I
         K8KDaA4eCGac+E7wBtbKhNJHX4cAVibXn/2fKiGhrBufL5GiLvzWqbORz8BvDQ9nrZn1
         hBpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQRT8k8zrqCkNiidyx/+D+2Y7dArKXStt0tpUhQYUKmcegWjGqCII0yY1cSp1/kKEU9GSIN5+VCg==@kvack.org
X-Gm-Message-State: AOJu0YzK6SonLLYHxy+JuJRMcpiVEKEhyZ9ABQ5X00F4306f0JAJfagb
	DTrwSa/ZBws0WWLNWYckzPy4ktnask8A88oVXTfvY78OMGzrbSt65NUSKSmS3iDO49UqV+8Yawv
	ZH4AZ2Mzq/6w15HCBVpqP/DpHn2khawwfb4itxeUNIXlem8yGfa6B
X-Gm-Gg: ATEYQzw/QxRNI74gTxBK2Nm3EFCdYzbKmfX1PoWsGT3dGMRJY1aPhac1cI8V0jJZ6P5
	Sm/AKTrtY7ebsCWoS78DT+wHtEQ3pnfgbLuNATbc05LVqt2xNmMt7njCzGcHMJeHODNnZ9bJTAQ
	E6jQP9guhS8NNH5J1pfWuffsdqR+G4YtQ/WTOPmVyMRsIM5BJABdZAj3AjxfRF5j76vGWtbZEgn
	huKhIilzUUUYT/J0tPFPxqvASZrSglEuVQHDczuvTPG3+RFLiREx/sZaSZZlvSaAahEwUauw0iV
	+cUnQHILIgdICfjkZm6uOYoA+EMN6/Xw+uF8un9ftUISKHIb0OAhLYhI47c4USAYfAZaGSQKyK4
	wovHsuMfO3OFkooftKTWxP2R9BSoHpi8ojFK9lYxcxKreuvLBKxk+XTS/5FDH
X-Received: by 2002:ad4:5762:0:b0:899:ff66:814f with SMTP id 6a1803df08f44-89c7743a5efmr10892546d6.21.1773860930485;
        Wed, 18 Mar 2026 12:08:50 -0700 (PDT)
X-Received: by 2002:ad4:5762:0:b0:899:ff66:814f with SMTP id 6a1803df08f44-89c7743a5efmr10891856d6.21.1773860929913;
        Wed, 18 Mar 2026 12:08:49 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b7df8c0sm32931796d6.0.2026.03.18.12.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 12:08:49 -0700 (PDT)
Message-ID: <1adffe75-cc91-4c55-bde7-9406bf656c72@redhat.com>
Date: Wed, 18 Mar 2026 13:08:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 13/13] Documentation: mm: update the admin
 guide for mTHP collapse
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, david@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
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
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032706.234519-1-npache@redhat.com>
 <638caee3-af71-47c7-bdc8-a905d3143387@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <638caee3-af71-47c7-bdc8-a905d3143387@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fglQuiDeGXY4NG9bK2BjencaFgVU3hkw19ZC3dDzGR0_1773860931
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DD2B80013
X-Stat-Signature: batuwc76rswrnzpwtrtapoqf8isgxto6
X-Rspam-User: 
X-HE-Tag: 1773860932-933628
X-HE-Meta: U2FsdGVkX1/TPSqmw8A7NEK8hq6yhLFtqmv3fLtty29Zc+AbDYok7qGw/IwYhgotQJ4Fd1vQTTPDPGmuNtWTETADGpCAxkyQ4+GhaYX+8SkxsXMilY/pj0RoYBf0noBJd6Lsp1cRBVkiFt47J2gKBSCkSwroLsbMUKErq5D+kSSmDfar+3Zhq30q5J1dL8p9eYe6Ks1cL3PbDf7VDipFXxVefDgSjqPCdupBm/hjwttnkndwc2PiwIAv8+AYjik5tCQsgi/pJF4m57lTsArDAX5F1xmQd22k5mc4OgN+iMtnt/x5aNrz7hN0VHCHMNxp29EgDW6IQnKiTo6AT06tESIekiMnyN36gY7zqULVGEqazzPNCVmVUpQLW21tIdlK+IVT+pHC73odMReTcFaZ4sijbz2bBDuzsZB9Ov7RYYZrMzoi8AiwokemfVdSosNuL3BW1E7zP8e1KsBUurQvPn4IVFM9RSu8RM2a5la/MNXX+BJ7/3UTafqHwi2Eu6JJ+7EGPAf6hXmEobisohkO6pTWWM93E3CHY8zkxqDB1VOwExMuKgjLx4+xsNImk7rWaM7bFrojpVHBHjP+AdafcuRrBbJHlJPOd3ScZO3NU4jms/lEosWYIDaW0oIr9CdhHkjyTynNeOaAO6HGej+r1NgJsqCUk56YbTUmrjAOAzFYFYdwa+k6m+4XDy1Ggp1Ie060KfHZ5G9CxQ680yucDqnStanO4KtCnKt6OZCPY3LJSXbnKu2v0V8zaV7RmX7X2mK3UL7py+//f4HGcGWX/GvJGq8PLZlc3ruRgjhCIm9BuKYVXIM7HusZroO0XVpb9k8cvFyfRk7zGiohT50jz67dY3qN4AJbQXGMd2FFxMsqEDYS4ozrLxJ1HHpNMu5h7rUDgMhJGWu8C06eJK5cb3D4La5FbDaLNtADdZE4jzr09IZQYBMHaix2yi6yCfJHiPOFfLpt49J7kEPDqhK
 Ne9hu6Dq
 3+eS/tCfDr9Cwqct3b8pLJj92bGY621s/H8IFYrZUir7/unjWk4HTwU6JTGWUT6ZX2XohCnXRZOSQksKR/yguBHWJdYuFjxlsL960rLroGUoCGtQmh6y1YzfAPOd1Mn32A891457wDbhakEjDNPRhUKiiDebLx/QZORFU19W2J/ViihxVqwrYpRKMbyO/IK8qFXRai6suJ0aVIQpUMcGxggImkOBQsQOBxPxURfoH1YJ0+A9NNufNP/37HK4QSK7/jrwezUiL7u3/rtS2LlHSUGjK5ofESBiSRG0z+s7SjkM5Ff7bKqibrNXL8tvarRFknKWDwdghWfS0GECT4MbNR9H8VHjQIzxc9zjfHJNpi7PM4Inwhwj9Gr+LIFdo3BGD6wOpOgk7DHaWBYpdVgWova3zbxBJIDeFLbozb1uOuhd38vIWkcLX9tky+Xt/1igGlH3cN6EC4PB3VHPgN6Ra7y2K8eESwrRucJtyOG7NmBoSgn4mNLFoFPzmbQS7MLZ510qkV+tmqgrihByURSxhQb1R1vyo49O9MUmtTyjBeoQMlpt9uqNCeETghN45hu67NS3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 5:02 AM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Feb 25, 2026 at 08:27:06PM -0700, Nico Pache wrote:
>> Now that we can collapse to mTHPs lets update the admin guide to
>> reflect these changes and provide proper guidance on how to utilize it.
>>
>> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> LGTM, but maybe we should mention somewhere about mTHP's max_ptes_none
> behaviour?

IIRC we decided to strictly leave that out of the manual. I used to have it in
here. @david?

> 
> Anyway with that addressed:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
>> ---
>>  Documentation/admin-guide/mm/transhuge.rst | 48 +++++++++++++---------
>>  1 file changed, 28 insertions(+), 20 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index eebb1f6bbc6c..67836c683e8d 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -63,7 +63,8 @@ often.
>>  THP can be enabled system wide or restricted to certain tasks or even
>>  memory ranges inside task's address space. Unless THP is completely
>>  disabled, there is ``khugepaged`` daemon that scans memory and
>> -collapses sequences of basic pages into PMD-sized huge pages.
>> +collapses sequences of basic pages into huge pages of either PMD size
>> +or mTHP sizes, if the system is configured to do so.
>>
>>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>>  interface and using madvise(2) and prctl(2) system calls.
>> @@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_underused, and enable it by writing
>>  	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>>  	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>>
>> -khugepaged will be automatically started when PMD-sized THP is enabled
>> +khugepaged will be automatically started when any THP size is enabled
>>  (either of the per-size anon control or the top-level control are set
>>  to "always" or "madvise"), and it'll be automatically shutdown when
>> -PMD-sized THP is disabled (when both the per-size anon control and the
>> +all THP sizes are disabled (when both the per-size anon control and the
>>  top-level control are "never")
>>
>>  process THP controls
>> @@ -264,11 +265,6 @@ support the following arguments::
>>  Khugepaged controls
>>  -------------------
>>
>> -.. note::
>> -   khugepaged currently only searches for opportunities to collapse to
>> -   PMD-sized THP and no attempt is made to collapse to other THP
>> -   sizes.
>> -
>>  khugepaged runs usually at low frequency so while one may not want to
>>  invoke defrag algorithms synchronously during the page faults, it
>>  should be worth invoking defrag at least in khugepaged. However it's
>> @@ -296,11 +292,11 @@ allocation failure to throttle the next allocation attempt::
>>  The khugepaged progress can be seen in the number of pages collapsed (note
>>  that this counter may not be an exact count of the number of pages
>>  collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
>> -being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
>> -one 2M hugepage. Each may happen independently, or together, depending on
>> -the type of memory and the failures that occur. As such, this value should
>> -be interpreted roughly as a sign of progress, and counters in /proc/vmstat
>> -consulted for more accurate accounting)::
>> +being replaced by a PMD mapping, or (2) physical pages replaced by one
>> +hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
>> +or together, depending on the type of memory and the failures that occur.
>> +As such, this value should be interpreted roughly as a sign of progress,
>> +and counters in /proc/vmstat consulted for more accurate accounting)::
>>
>>  	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
>>
>> @@ -308,16 +304,19 @@ for each pass::
>>
>>  	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
>>
>> -``max_ptes_none`` specifies how many extra small pages (that are
>> -not already mapped) can be allocated when collapsing a group
>> -of small pages into one large page::
>> +``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
>> +when collapsing a group of small pages into one large page::
>>
>>  	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>>
>> -A higher value leads to use additional memory for programs.
>> -A lower value leads to gain less thp performance. Value of
>> -max_ptes_none can waste cpu time very little, you can
>> -ignore it.
>> +For PMD-sized THP collapse, this directly limits the number of empty pages
>> +allowed in the 2MB region. For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1)
>> +are supported. Any other value will emit a warning and no mTHP collapse
>> +will be attempted.
>> +
>> +A higher value allows more empty pages, potentially leading to more memory
>> +usage but better THP performance. A lower value is more conservative and
>> +may result in fewer THP collapses.
>>
>>  ``max_ptes_swap`` specifies how many pages can be brought in from
>>  swap when collapsing a group of pages into a transparent huge page::
>> @@ -337,6 +336,15 @@ that THP is shared. Exceeding the number would block the collapse::
>>
>>  A higher value may increase memory footprint for some workloads.
>>
>> +.. note::
>> +   For mTHP collapse, khugepaged does not support collapsing regions that
>> +   contain shared or swapped out pages, as this could lead to continuous
>> +   promotion to higher orders. The collapse will fail if any shared or
>> +   swapped PTEs are encountered during the scan.
>> +
>> +   Currently, madvise_collapse only supports collapsing to PMD-sized THPs
>> +   and does not attempt mTHP collapses.
>> +
>>  Boot parameters
>>  ===============
>>
>> --
>> 2.53.0
>>
> 


