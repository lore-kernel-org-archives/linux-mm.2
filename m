Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18BCCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2A88E0012; Fri, 12 Sep 2025 07:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA998E0005; Fri, 12 Sep 2025 07:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0538E0012; Fri, 12 Sep 2025 07:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 283AB8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:34:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3EDA13BB60
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:34:45 +0000 (UTC)
X-FDA: 83880390930.27.43BE1AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4B7BF14000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:34:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lz3BmvmO;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757676883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWd+C+6xlO7ZNnElus07Td372OLIDupg0E/fPHS2G6s=;
	b=JM3MV0MGO9PgxGJL9gLqtYqYozgvjJ9k1XPf2ft11IRmzz0iKMnNp8kQLKErY8V2lUuTXg
	DWm4/UWbDGoctN70dRxVfFWKpSJQubm7BS3FZlZxbu1QcgNjhEOkBPNKFo/4AHMk3ICQl3
	lSkFdg/WYXN+RPWYRhZcurSbYGBrcd8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lz3BmvmO;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757676883; a=rsa-sha256;
	cv=none;
	b=IVZzo6JspaoTA6JjrGFF5oZdnSb1XCgcN8GJpsbT7y83Ys9ZzMtLfrTzrmKv+YKmrADof3
	iig6Sgbc6xJZKvKDW1DhIxJpgGChn2k7RJcAvodG3gjers2Oh1Mp/tSM+etmVdjOG2czqY
	KGcDQQYaATotZuoa3OrX0UOd/Ojc6QM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757676882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZWd+C+6xlO7ZNnElus07Td372OLIDupg0E/fPHS2G6s=;
	b=Lz3BmvmOLHBg/6PtImScADLSvnkSvbLTJCj/a/WTlvF5gSQUuwTULUQcgYQPULlq0SSYXV
	KqkohEldUl7R36u4fvakdAiYm6vFbloC8I7Y+/SmMv6DaYufEgi7pvlCT3YYcYrvn2ogBE
	cDvzx9W0B/XKTWarrkWnKaKMXn0EjnM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-3J2yfsODOu2qOL13THgnmw-1; Fri, 12 Sep 2025 07:34:41 -0400
X-MC-Unique: 3J2yfsODOu2qOL13THgnmw-1
X-Mimecast-MFC-AGG-ID: 3J2yfsODOu2qOL13THgnmw_1757676880
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45df7e734e0so11479145e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757676880; x=1758281680;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWd+C+6xlO7ZNnElus07Td372OLIDupg0E/fPHS2G6s=;
        b=W84DLfVDl4aVjKCyznDEqVOeRoCLohFbTPUFUQO1/P96NV//solb4n5GnOtZF0hcy7
         GioaDnMX2R6PH2BRNBNUaTw7WtA5+dXEfgle4TKWW4bfll/GvshMeA7/ovJcDD2Uxx4Y
         G51pMkj7hXYtMIOH2FVz/XNeCXBYUBTFIBlIcF1B2fFNt0brZZv+snMKpn0pMPZzGQLd
         B5fglevJWnvOvuafHfA0tfBoU7FQt3q/hgMNIOK8LrMR0FQXvMZ4HSf/xD6hA4DR2tgV
         feV0G18wwPCUZejmMu+wPQUrRaaoF18Np1aUouHnXen79K1/nPUGUI+ZrOhCFe3c/2Sy
         33yw==
X-Forwarded-Encrypted: i=1; AJvYcCX140x5ROgP0edSdHEOXfyk5Z8vxTLIbRz/azb9XRpLCOMx1KtMAqzONxkMlYUheYLjUVSm62SMsQ==@kvack.org
X-Gm-Message-State: AOJu0Ywb2+OZXd34vSerEbecwfwFuYn282noT7nudUPzL/ssZGSPguyd
	c6KeqIUCjODhiXfh5flb1apOU4D6OoMIJKuG4cR+VJWEGY0OJrZJkTdSnPIQh6YElXnA6btgRvF
	BzRt+Hiz7uLZYm0uUYbtzflHFuj6V9Zo8RGiJHa2AC4UBkaoOhluV
X-Gm-Gg: ASbGncu17vH/YzRofzZoqH49y47vXkhyl19/g75W4Ie9H5gPSPaA1wuVaRib7NNlrGq
	MCenpEmkJdA0loKwhWetuoWOJH9JPPv5rbkPujJg+mImEqljlM/OuK1q/t6u4MsYnZEhaSWqU28
	z9FqJcRVZVvHSSnL8jmRygt/Jv3w/PZmoR33F0toupF+Uma1qPW8YMVQXpRg7j7tJJh/fpeevnj
	AJ9273Dz7Km0+J+Z+z43qgihPs8t0LI8o/jH525+13MehTOMqBOnwrsMsyo9L4IoWp4Ec8+d0sZ
	piFJuZazPllY3CSEmRLOmq+LvFqwYqKtaDJk5ywSHyrXqnuThcT0tHodg8IuRRiHnEJwSkCE9C5
	NOkHIMebdAjCQahrWsCJN4BjEJFrTgx4JMn5q/LRXO8fFIAO1IQh7XlaI/uJbqQsc9bQ=
X-Received: by 2002:a05:600c:3b85:b0:45d:e285:c4ec with SMTP id 5b1f17b1804b1-45f216696c8mr21980655e9.4.1757676880128;
        Fri, 12 Sep 2025 04:34:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBCLdYjQPkVnjO0W8XKaGSgjZLsccprLNd6W9/Xe0KR1we4p5qR7REUfvO0pBQsst9YNwS0w==
X-Received: by 2002:a05:600c:3b85:b0:45d:e285:c4ec with SMTP id 5b1f17b1804b1-45f216696c8mr21980295e9.4.1757676879669;
        Fri, 12 Sep 2025 04:34:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607ccf9esm6158472f8f.40.2025.09.12.04.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 04:34:39 -0700 (PDT)
Message-ID: <d7a03a2b-d950-4645-80f2-63830bd84f76@redhat.com>
Date: Fri, 12 Sep 2025 13:34:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: next-20250912: riscv: s390: mm/kasan/shadow.c
 'kasan_populate_vmalloc_pte' pgtable.h:247:41: error: statement with no
 effect [-Werror=unused-value]
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 linux-riscv <linux-riscv@lists.infradead.org>, linux-s390@vger.kernel.org,
 lkft-triage@lists.linaro.org, Linux Regressions
 <regressions@lists.linux.dev>, Andrew Morton <akpm@linuxfoundation.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Anders Roxell <anders.roxell@linaro.org>,
 Ben Copeland <benjamin.copeland@linaro.org>
References: <CA+G9fYvQekqNdZpOeibBf0DZNjqR+ZGHRw1yHq6uh0OROZ9sRw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+G9fYvQekqNdZpOeibBf0DZNjqR+ZGHRw1yHq6uh0OROZ9sRw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ahTskYsxCLqSvnhV9gjx9huEpmB1hGiXBn4nocKqeWo_1757676880
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B7BF14000D
X-Stat-Signature: 9zjs1bbionp1gcnaxhmjdnmhako4dgh3
X-HE-Tag: 1757676883-225446
X-HE-Meta: U2FsdGVkX19eAWW7suEHzrnAIy98vBiqfICClyfzRMOMaghHCitgGn/t+HLmAKxiA0VZX/atd9/osi8ubMD5hmTAcLCwQ1A++OQNxUUq+DZ5iWyWGLLaKOCuFG6jvjtBPxXj0XM+lNUd7sBBueanOdC87ajp2MeH5xBmXtnyYNx1qkugFxSxkusxHcY2+zyWmfm9AwHeccUwqJgqLJnmlh8kvelrbtUAi0/kh4oXnbz7f2LNlDFbhyOF5DYo711DeBoiQfzZMCzLNTdyo/LhKNz2USL7q/rAbBQV/AtzWntl7H1jgjlOtcUm9ZYPmWnnESom0eLbRMl2/VRFGeI1u2wLDtD5gh2yIij/54FABsz2RF2HghTSBLw8nj+mPnhwwtlLMHNQrMTcXXAbj9RdGU7aqNr6cWR/GanYvfnl1padQs0/3SS1pbBkG+ZcPTvP9SKleN5YA9w+RZyqUAgVIgd2PznmRmI+l1qQlZiKQJfooBaD4W/wdIjcW2MQnM9QhdXiFOcd8GEHZqm2OTfC61javieKDpTCfcHWAi2wqprdk6Wjdc/uy4JdSrdMdRQe6OFvSLvwtkU/fSRRjf5Tl3N/uwOi4flduljRIy6WjJG7LKxin70S2yyJgCJIBOLDg7myhsEyLt8l1Siebq3F9YaYkUeqyRwAzRRYauEDcaQNv1Kh47Gwo0zSsc/IgIbMZYE+lh7qLaF05zZqDb6gSFvdaWLZ6O4S+Jfsp/pM/O4vRhqCth+DvsVT9dFOxbF3ljHIvWFcWa/FWkTCHt8eu+R8ZxvyN7+ahlz5JvfE8ZePSmiZH7oMuaZVvjnvcEoCJg6eZs/9ONRDQD8Yzzm2g4RhJjp8NwqcO2NVcZNioK4ruvxiQ5FwzcXXQwQI3uGE+5X7V/+GD9AuzNJnHVKFo5hg1NrDDpwnO2+wG6sB5QGDN4RG5paOefVgy2QVJEg8IfNU05NMCnjK7FvwVCa
 j4b644Hy
 WgtGtCCb3bRYxiQ2bjzfBzerl7Y1MbYP00NwXdv/DAoV1br1g/1FUJc+D/00a3G7pSA200Az6pfPGmng9Hpi7wI2EaL4wsWd1xpA8LPqQwyYh2d5d1w+Dgjs310VLqNuKZX3J2BuREWQomQdNc5PqcNVbMTCoxmZvr9heAQPXEDAIuzR79sUbXqx5k9uUfHjkg0yVRH/MSuolnc+MMVepeVy+JgFn/mLMXVq93NdEc4LVjxVy5HSg0VHgpk3Cb25+TCh8srd6UWCKwYM/TUqZKGjcS1yMO6tf5aRbinVk5ADroAXf3RD8J/LBIePXSD+GRNbqSKBd0lJLqfcUdJnThRlBqolb3VtLWWAf53eeXu62sjJ1Etaa52e9H8ijutruY3idOl8+eb4Jz2ThaQP/epXRLOrjrcwK389d8P6wx6CruzshFgtbNrH5Cw69EuhaPsr2V7GuFmKImilefwwMB5iJw0175qDmdf/1r0Xj7aimCEjIQ/CUW8P8DlGhCDKRrASrzddSp/46lLWr1r6ZISERFL8TjShK92QRpuozN7uyQCcfuPo7/HJBFy1DcXT4dEcDQ/a0o+NDPlH8H+ZceMaH9Vn6zflcom0J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 13:32, Naresh Kamboju wrote:
> The following build warnings / errors noticed on the riscv and s390
> with allyesconfig build on the Linux next-20250912 tag.
> 
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
> 
> Build regression: next-20250912 mm/kasan/shadow.c
> 'kasan_populate_vmalloc_pte' pgtable.h error statement with no effect
> [-Werror=unused-value]
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> $ git log --oneline next-20250911..next-20250912 --  mm/kasan/shadow.c
>    aed53ec0b797a mm: introduce local state for lazy_mmu sections
>    307f2dc9b308e kasan: introduce ARCH_DEFER_KASAN and unify static key
> across modes
> 
> ## Test log
> In file included from include/linux/kasan.h:37,
>                   from mm/kasan/shadow.c:14:
> mm/kasan/shadow.c: In function 'kasan_populate_vmalloc_pte':
> include/linux/pgtable.h:247:41: error: statement with no effect
> [-Werror=unused-value]
>    247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
>        |                                         ^
> mm/kasan/shadow.c:322:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
>    322 |         arch_enter_lazy_mmu_mode();
>        |         ^~~~~~~~~~~~~~~~~~~~~~~~
> mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
> include/linux/pgtable.h:247:41: error: statement with no effect
> [-Werror=unused-value]
>    247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
>        |                                         ^
> mm/kasan/shadow.c:497:9: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
>    497 |         arch_enter_lazy_mmu_mode();
>        |         ^~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 


I'm afraid these changes landed in -mm-unstable a bit too early.


-- 
Cheers

David / dhildenb


