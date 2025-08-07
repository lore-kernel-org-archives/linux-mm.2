Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FB9C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D33E8E0002; Thu,  7 Aug 2025 06:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7825B8E0001; Thu,  7 Aug 2025 06:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A678E0002; Thu,  7 Aug 2025 06:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534DA8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:21:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E056D11665F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:21:26 +0000 (UTC)
X-FDA: 83749569372.26.C56F5F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78663100003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:21:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X6978Vhu;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754562084; a=rsa-sha256;
	cv=none;
	b=WdytHT/xOobo9SWRrqlG3uXEh+3PKdNKDaTHTEDwzAh7uUXu+b9MPR9r0GdJqcfi18a99b
	1N9MXb2t3jl2CdEgtT0SqML51jtjcgxkdtHOkUY3SjAGvvmb+dIXPA3JOH/130cWOqM7S9
	Yidk1rxA6LdSFlYs/E2LqpZ7Ztbx0Oo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X6978Vhu;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754562084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pPCKCDw2qqu0amhP0jmadWwdffE5h/laeuaPK5g2Y8=;
	b=DMdx3fMmd0Oc1NmPI91QzhhThmR52kRrLuozVWmfVLuGOGk0P024vKvfUXpLAvMtxlOtpi
	DzLrlU3+wmEmoQRXnBLIdPumYpqxtbOCHqS57p1gnQzLwsk28aGZgo4qgQovAUAurwqZ09
	gbf9gP9eL1SLXk2ye5MVwc0wc6Td9Cs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754562083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3pPCKCDw2qqu0amhP0jmadWwdffE5h/laeuaPK5g2Y8=;
	b=X6978VhunbcK2RDDO5eRl/BgiJyaGo/aTweC/dv5+MCRkPpfkD/zDEdZi0vER7oy1yhbl1
	R7ekVbD8j5tJf7mU8zcH2Ypatnw7Odko4twhFXHqp4bbvS9zMTwzXcMWnZ/XUmM97sSEOm
	AmWtVh3hBZgXe2z1T1U9MshRFJcTY2Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-kETyUlnRMWmnVqZQM0jfgw-1; Thu, 07 Aug 2025 06:21:22 -0400
X-MC-Unique: kETyUlnRMWmnVqZQM0jfgw-1
X-Mimecast-MFC-AGG-ID: kETyUlnRMWmnVqZQM0jfgw_1754562081
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459e30eeea3so4923925e9.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 03:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754562081; x=1755166881;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3pPCKCDw2qqu0amhP0jmadWwdffE5h/laeuaPK5g2Y8=;
        b=AHulywr1zFmdmgLeTEoid4X6ecB3x/1PnIPFlNCngbX3HZwcgc9ODg/1jyYr7KWrBz
         8A5tS19hJbuMapf9N9v60AuXos6piGMD2+2UCLdiFczUXE9Z7B2uUdueWoXJcOeRYr5b
         dOHvQ7OBLBDF/hCZ3NCxB0Ap6yn9K/fCLdyug+LgFKQ/FvK/jz0v9z1Z7cggzdws4pFr
         Ig1bVKkxTgYpoTNnIKuB/EWZsmheu0aYbSlrYAUKkhjGHwpwPxQqVKCCwOoVF3t5U+5S
         dJURjTsHlib2AM10GBN6H5vOW0n3BRvwwdZwOrYkiwsTr1peUxVPbp0sKcJJe1idd6+L
         dcfg==
X-Forwarded-Encrypted: i=1; AJvYcCXzOGvAh3TvIltWJnCyhidDguZtU+b9/NCwoYvhBIh8+qbcBbrICRNO3xgJmLxSRo6HbGzs5mYnFw==@kvack.org
X-Gm-Message-State: AOJu0YyvlI5fhlPv8B1KU/pou0ubhD9BPp6V0Tm62hcPcwiVib7fEIFM
	Zfl6q3pOxMf6F/F8+TGI8Zla6TyzWJc4Tjcjp8W59mZxTF0WHu7b0sXx2KXmWPhwVCd1IenWKOQ
	2LpwIFX0YGIdRmorqls58P2W//Nib4Xhi5HFkM5cemXmG3tfRZmc3
X-Gm-Gg: ASbGncv9LcYq/0aqWypjVaRjUFj5uCO4e/pC1WLhy0vhA6Kcfr/W5KznH88Bv1UvqX1
	iH37ELOgTMhgH9KrbU+O6OD92szAX9P2DFNZERCkddMO9WDdnrUL19m37azGfqn5ra69rwrHiyG
	ibeTOWhIHlyC7fJTaeCzgDDmsjbU8JyTO3m5JE/aAERyA5j9Q8LdEnyZvem0bVAk7rDDuadNemj
	0QcyGLFU+NAcdK1rNvXI9wExujgs4Gi9G4TkHeGMmz73boMvm31UPVOuODRKYjCyy4uwYTch5rw
	V0Cza4/AVtqZOzdIHHDE5w+MbGj790k+nJYl0lms8daG8C28NQvi525PJ8gaf72SkimzzwRytm7
	W3ztNvnvk/1AxILQhGVcK59YizGUTypN1FrmnwzqNI6jeG43WhcYudTqxXpAaC3XI7s8=
X-Received: by 2002:a05:600c:548b:b0:458:bc3f:6a7b with SMTP id 5b1f17b1804b1-459e748fd16mr58072755e9.18.1754562081222;
        Thu, 07 Aug 2025 03:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLvD/ci4VcJLffdp3IqvGO83bI1vYTvAdh4Ih6kxzqUVno/uCFkxRHyCn9UNUbRNUVCU+vsw==
X-Received: by 2002:a05:600c:548b:b0:458:bc3f:6a7b with SMTP id 5b1f17b1804b1-459e748fd16mr58072305e9.18.1754562080711;
        Thu, 07 Aug 2025 03:21:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eaeeesm359376465e9.25.2025.08.07.03.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 03:21:20 -0700 (PDT)
Message-ID: <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
Date: Thu, 7 Aug 2025 12:21:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 kernel test robot <oliver.sang@intel.com>
Cc: Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <ioworker0@gmail.com>,
 Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nivs-mtXOhYfuJw3h3USnYUaZ6X8io3Tjx2DsFKJxXU_1754562081
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78663100003
X-Stat-Signature: ofh6uzegyqxu97fncenw69t6xfew3kxw
X-HE-Tag: 1754562084-637360
X-HE-Meta: U2FsdGVkX18ClQNKvuGUvx82ujzdeG5jNFxKNjg7RcQQsThR7KlhzRQAU7NAW61eTgSvLbrIKBB6+G/spxcC/O+Ek6usKtXIUn/OYyI1N7or8KC7wKf+eaX4RkaxtJorLtnM48Fimw5WjeOUSf54RaKDahdmznPTNPm77xLLZ4ToqClk+5WELSTU1M4mRosvKRSI6/x2/3ZLWclMkkzn1DnWl5xZMOBegL9EwW4AaqLfqg/vMZbuaSeq/RpVKSpgmKjbz0XGYG+7wGzPtiSH7vO7POZ2Ip+G/8MR7xQ3/UQoFLO9+O4APxOu1D/U3+pvahq4xcr9hWKpqGWqLHE+0zvaPz+BoR5hrm5KDzgFt77Ge/lG+TOfqLpdTQZIsr5gi59b0e02/hutbpaHKp8Kc7DFS8DAg9PBQUuchi/J43H2cSrxGmsrWF5WDWL0iAggibRIXYgFkLXKPrwDFsKf5IZujeccEKARB7GYrAJdMSVyYK0oU+EQWWD4Vs7El1rEdJwVG5q2F7AGkCtEPtI5LyKANfqN1olD533QnmwzBerR6K/TPGQbHgu7C069Sy5wjookxhA6IzhV3ySG9xfK/5GhDlNkOUpNybMoFAajpNbP9GXfCIbbIKpu4ZBsYkEYeKG4w6aAuScG9HZi2zZo3hJiT9Cj3vEHpSH4ydCiUKoUQfZIllhtw5knYeZF0CTcFHm42N8aEm2rhRvA5OJZ9K2G2LxWHjulFf1T/VYpmtfGgVQXKDzApPOShVDz9CW60YhMl1Y5GKGQ4qAdStSGnW1TIWboje5HccviSOF13JLn1KQxoZbgzI9cY9Z7yo/QJFwtGj/NKYGG+YMvImI3c7UBPrmRTD5gbLESqRwbvJz3sbuOUIbbqhVn1CZY0cwBWTJTTSBVmQ27top0y1NPJn3+mH5RvmsPBhubZKPhxjnts8AstWz72ra3ObRpLs8o0ZjSVnrQds2Ok0Hecei
 bVknzSJX
 p25wgDxnv0pb6sJrZF+0FoGzsXqbtmtzta3mfh1ruvGqEAU60hdlydPOgeT6qZ1LkUbV/BCof85q9EjNObGOngFiD0IgJGWZlxRtIjP6nCssxRUCzVCY7PIs2NA2vQn3khf+T9bNxhGydjymZPb3c6oZ2UqC3zKNIhJU5xR0Z4bkeZAYf+JoFJCm/IgoPTo/El+ojhmrEwex8xX8jpfwQdS2Wap5hjW3gtngT323mIEoRjYGZIrnGv9n+SeXT1p/xAQb2SuAtNnMqoyEjHKGSs6HF3gQnXnv9aULTIyv8IEZptiPGoj8wu3udAHUPnWjwv8GVxh4SAZWGTpnMu45ckX4S3VcuEHFMw3H01PbVfCCppdH5BOxzaZsXx/r3kENDZsacHX042f2wStKEE2yYULz/cxecYSvkVVLPz71B+Y/u68h15LtBSsEOsICNiNlJd45tjVM3MCvxqUDu3gHYsAO2U4gZEQE56dh6ugOEtZtN1TceEEcFlpmkAmHPoPWe/fRF8KEVPmnvAVVm+OtB4olsSCkDV+f770RvE+HdD/B3FPgxfx8IEg8eROD/O3a8fGiW1XcQqzhj4+mf+6wcgXyJcy9VZN7KKaPt0cYX7iXjxDcudK4N4jfLgu3s9TOyj8jrxUlKHU06wus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 10:27, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a 37.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
>>
> 
> Dev - could you please investigate and provide a fix for this as a
> priority? As these numbers are quite scary (unless they're somehow super
> synthetic or not meaningful or something).
> 
>>
>> commit: f822a9a81a31311d67f260aea96005540b18ab07 ("mm: optimize mremap() by PTE batching")
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>
>> [still regression on      linus/master 186f3edfdd41f2ae87fc40a9ccba52a3bf930994]
>> [still regression on linux-next/master b9ddaa95fd283bce7041550ddbbe7e764c477110]
>>
>> testcase: stress-ng
>> config: x86_64-rhel-9.4
>> compiler: gcc-12
>> test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
>> parameters:
>>
>> 	nr_threads: 100%
>> 	testtime: 60s
>> 	test: bigheap
>> 	cpufreq_governor: performance
>>
>>
>>
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
>>
>>
>> Details are as below:
>> -------------------------------------------------------------------------------------------------->
>>
>>
>> The kernel config and materials to reproduce are available at:
>> https://download.01.org/0day-ci/archive/20250807/202508071609.4e743d7c-lkp@intel.com
>>
>> =========================================================================================
>> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>>    gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/bigheap/stress-ng/60s
>>
>> commit:
>>    94dab12d86 ("mm: call pointers to ptes as ptep")
>>    f822a9a81a ("mm: optimize mremap() by PTE batching")
>>
>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>> ---------------- ---------------------------
>>           %stddev     %change         %stddev
>>               \          |                \
>>       13777 ± 37%     +45.0%      19979 ± 27%  numa-vmstat.node1.nr_slab_reclaimable
>>      367205            +2.3%     375703        vmstat.system.in
>>       55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.KReclaimable
>>       55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.SReclaimable
>>      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>       11468            +1.2%      11603        stress-ng.time.system_time
>>      296.25            +4.5%     309.70        stress-ng.time.user_time
>>        0.81 ±187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        9.36 ±165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        0.81 ±187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        9.36 ±165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>        5.50 ± 17%    +390.9%      27.00 ± 56%  perf-c2c.DRAM.local
>>      388.50 ± 10%    +114.7%     834.17 ± 33%  perf-c2c.DRAM.remote
>>        1214 ± 13%    +107.3%       2517 ± 31%  perf-c2c.HITM.local
>>      135.00 ± 19%    +130.9%     311.67 ± 32%  perf-c2c.HITM.remote
>>        1349 ± 13%    +109.6%       2829 ± 31%  perf-c2c.HITM.total
> 
> Yeah this also looks pretty consistent too...

It almost looks like some kind of NUMA effects?

I would have expected that it's the overhead of the vm_normal_folio(), 
but not sure how that corresponds to the SLAB + local vs. remote stats. 
Maybe they are just noise?

-- 
Cheers,

David / dhildenb


