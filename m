Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D69D5B16C
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693A56B0010; Mon, 15 Dec 2025 09:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66AC26B0012; Mon, 15 Dec 2025 09:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581686B0022; Mon, 15 Dec 2025 09:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 473136B0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:27:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3AB41354B0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:27:02 +0000 (UTC)
X-FDA: 84221932284.10.F488B13
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEC35A000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:27:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCeGM6sn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808820; a=rsa-sha256;
	cv=none;
	b=t7wipqFa3LHvhjs1XNuQ2NcGNd8sTrxj4awn9UluC0D3WQPc0ZjIuzafIsVccisWulr3l8
	iWH3i5YHkc713ctJgQVZ9VGAqqUa2QQtMfhuKLQ9QIh5lwcwadPrZkD4L9+/24Ch2opNvO
	jjxV2lMZjcXjVcDX29usAaQYWuCAmlQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCeGM6sn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcq1j6544AWTrXFS++mwFnDhDMKc8xPfVFYYuvKVzWQ=;
	b=Z9vxg2ZBMT8QV/7qJHy3HC9fZpFr+5CV0dhlT3X7NngcvE7c0hpRsubArDSsCoM6uERBtT
	GvC9rp6YdDZ7MK7cmiuCnAB1Nx17p6Sdirz2IrvLrm99hJcQRvaXuLsmG2uwSDfS25lR/t
	n+rJA3uVon+n5Z5mxIkc5rR8JSjpdkA=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78d6eb6956cso30123137b3.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765808820; x=1766413620; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dcq1j6544AWTrXFS++mwFnDhDMKc8xPfVFYYuvKVzWQ=;
        b=gCeGM6snICcTuXG4F0o7whUrXdnbSRLuUJ5Pl4OPu5wrgeLUE1kl19KsYEJSXkGO+o
         wPquhfOCbKhwkX7/17dm9KHa7uuH0Ja2n1/oe3hnyCvTf/tZp5/hqzw6kmcUikaEocur
         3B4JibIpBVlEP4OzOCSkclB90JAGxOa1z/ZAEruRzQxHK8MfSk7BS47oVInnQWZ0pWXd
         Y6MtJ6yRLwSqwlRWd86AYivnKoHlTiqFBGLjjCyIFxk/DzpeC2fxbvgGVqxOjVg2hyJL
         liZmxOsdHM+b2fph1ed/HZa1dqZQVwW3XKHUC8hgglbwOsCcC+9ZwGUjaIXr7pcWcVEv
         yxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765808820; x=1766413620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dcq1j6544AWTrXFS++mwFnDhDMKc8xPfVFYYuvKVzWQ=;
        b=iwc2Y3R/Ysrz1lqfd1Um1o6dBMeeWWOhgp6SPVqoStGACTJbq6MsfVoDZKgej6LAh7
         UEvFeux08ZDEraUc1qbmjpt3+47JSS69VpLf4d932Cb3ROJz6Tx1MSs6m2DvrQfWiVSH
         EHazK4F4qFAXlrOvi7d4X/1J2hohUEmT+ApJFXp5pC4RKYsI1m888bexrJ205Za/nS0K
         rU3o8bofU67mq1DhOmQS5SRCswQPRdwJQyjS9bDszao1P7nwrFo66vnWVKaRcqGfL37v
         Gj5wIP/ZbS/hKpyHZUkKa4dKO3Odwmth5BuAgWHsdFCD1sGMjK+dwfUtT0NXxS5Yp2rd
         AZWg==
X-Forwarded-Encrypted: i=1; AJvYcCU5DJC+Y3Hry1jG9QS/EAqf1884wkLnjIiOnDvPQHXbEgYyvVn1YBi5fVX/11F9EXZq6bDYd79YvA==@kvack.org
X-Gm-Message-State: AOJu0Yxn/mt/gpYIVf017OP1GE+q/Js2woidAhUwBM1D9JaVg1Y8UNN3
	Maeh8Y4ozqlgKd+yx+e/Qx7wk8XrdxOfcIqx1AShSNaO73u0d/LiJlbf
X-Gm-Gg: AY/fxX4FLbUDsZvuJCRlifExj6c6J7uLz1CISKy0Dp8+Vv++a/RpXw/EqUA9P1Xz4yJ
	jR0LOquj4iGGTVMx4K0XOjIEL/S8tYKBfflkKt5Bw08vjbmkdaay7NkddCeLOAvH86dskbIyyrd
	P8zZRPnhvBRC0wHFuXhy1tGYTR9fZO2uVya520j2X5eSxERGUTLkpz3ie0b+iTUSABAtRfprd6q
	kUFCBIgZlQ/GRtcGlAqEcCg+YcjpuqclwMUgPEiyabnaCO0RwZdOGp1YWSI/i+2EXEz0vaWbpx2
	ZLW98sArBvmilO8Sgt7/C32l/xowa2mY2rslJAehFUoNzdoe2HBEb8tbputzXApFfkyB+ZQq3tP
	Z0ruwp6PHnIoFvIVF7dMT9zVfDj9QLIsSromsRRI6yR5+JBrDPMYmLghJi/fnTWOD+XGMroOwpR
	PP+r+u4dtV6dux6yEy7UBMBj8PzZGG3NKr3raS4A==
X-Google-Smtp-Source: AGHT+IF4a51y57BzF37Vo9369cXMn6T0B92c877kSdcZ6vwpnS/AOu/LuwtwBmWQVHYV+/9EHDVqvg==
X-Received: by 2002:a05:690c:dd6:b0:787:e015:8561 with SMTP id 00721157ae682-78e66d8030cmr89937457b3.20.1765808819563;
        Mon, 15 Dec 2025 06:26:59 -0800 (PST)
Received: from [192.168.2.226] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e749e55edsm28402847b3.33.2025.12.15.06.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 06:26:59 -0800 (PST)
Message-ID: <b9e3921a-2a54-4adb-b19c-802e2aa1aa75@gmail.com>
Date: Mon, 15 Dec 2025 22:26:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, alexs@kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Magnus Lindholm <linmag7@gmail.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-mm@kvack.org
References: <20251214065546.156209-1-alexs@kernel.org>
 <686b85ff-6a5a-4608-af97-55aee1582c5c@kernel.org>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <686b85ff-6a5a-4608-af97-55aee1582c5c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEC35A000F
X-Stat-Signature: 85huxaiyzkyfmmk5qjey4ujcxm4h3n6y
X-HE-Tag: 1765808820-437577
X-HE-Meta: U2FsdGVkX1/dhfDrP9kwtWirJ8mlbFib9simnfpPqp01IIedtiFi78llSa6fYlUSkeNznYvZhORj7JWLsgfwt+MxyiUVm/fvLfrePCCfPNXI/0pZuWDrDSWG0RBa5P7NCurtI9g68b044AOBxlUqjjWHYd93DCgZ0qyMETh7UwzNEvvQnERIkBIGDw2QMKmCVvhpHafIrBaPcjtx62ZpdFaP61UC9xwYDJiz/UYEizG3XSeNiGwraCgwdiM3xuy6t2mq5AOZNL3m3Gmce/pyJnANr9Ln3pWFKmpySgy+gabqbmIjInvb154tNlj3b/aFgOl0R6k3CpQmyxP/52KF2e7wWIk/Z9OxrrE2Q72RUJJjesBwNLyjON6cAM8Y6NQ+JeRyhCmDvwvOUIFkK++jK4Iip5iWCQqw41ctY2hmnTp4bHEX8MTZJBg+8ZFR4hAiaQvfZeWNTx297GvKeUOWE5O+CK4E/MPVkJqRaG0w9gYCdjUvpymBx+ZsHH2FvVz8pFZw9CWiq23HU5RzG5F1daka0M2rFs6dZVjg7PGFlkzGesppKsizW9HGV9yHgSns00Jak8EgJovXWxv2Ai38ftn3xHlxb430kv685VBd94caYuM6wTYnl2HRIukYUl4Q5oomyeSNJGXwuzGHFRlH70z5tdoW5WpGkIdGmz0wk4QwZkaV0ALai1ifYqJxYiVfo4roJvNqf6fmfy3RiunPhWqfHELspa6gRUPwtqZse+mNq18vmokjG4ZSeXSy8ABsSp9CNHA1+PI9V1fDThdKzx2qD3bhmiZeBY7NhHDLVRGjk/3J7mbqb74kPoiIxuK0l6jpNPpP0oU8MIyJWCVfRB9XTXBAmSX8qmX5aG5SxExcnYFY4noCwkU5QSRiE5T58sLA6TCK7vpnCZZZe5mHeSAytgH6bKUUCpSA2i2LEixi9dlKWuMZOXMM3GKd9d73Ts5ZVHmZbpk1F939VEQ
 mEzawkSm
 jaJ8uAkHweS1NUmGJWF/UA9OW9iSgAlbNoz30tFezA2iBJYtaZ6NegPEuABsaS29gxow7GKC5N0pcvi68kOKhkHo/cikm9OVIXr70IgP9lnfws+ZR39ZQoW5RdwDdLItaZylHINOpF/hIPeUgBm50EWXUSZ5KBGBEAk1yaOC6ayP75pabDSQs7n63ebyOuBJTiQVXqHqO+8wNMUgOEPiE8LQ97gMsCdNnoimt+RZigHox6V4UDgiEwHHCki97kJxUNxAmKp45IGu3Olx4aIsUFiUgxemZ0BYEUT/41xWnM2WEBNpUqXbOXiLvwTenRbqeBO5mnxMDExcgcKFEH9mc9GQjp0fdf43Yt95eRVjgVYLNgJARbw4SD3zuqDFPlCJWQGgjDS1TLM6XmV4t7sp9t7pu8Z0b0jPfusdFk55YD1wiQo+tEbGSrzexoGo1Bfjgz/tjNibn2rkOJlSl0U7Ozxx50+g3Jac/DdyzxUUJU1Ylf+8b2YmWuQd1Mae1lBRyxEfv/3K4cO7xtAZU6Yh6We1EDd9K72kTQgjiaK9B8hCg1A465LjQxiTKmIoSWmsTs7FMq2f3Cgtqyvt+sa2iX96B031oraGHJTPH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 14:06, Christophe Leroy (CS GROUP) wrote:
> 
> Le 14/12/2025 à 07:55, alexs@kernel.org a écrit :
>> From: Alex Shi <alexs@kernel.org>
>>
>> 'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
>> instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
>> functions, That's a bit weird.
>>
>> So let's convert the pgtable_t to precise 'struct ptdesc *' for
>> ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
>> pgtable_trans_huge_deposit() to use correct ptdesc.
>>
>> This convertion works for most of arch, but failed on s390/sparc/powerpc
>> since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
>> archs? If we could have a solution, we may remove the pgtable_t for other
>> archs.
> 
> The use of struct ptdesc * assumes that a pagetable is contained in one 
> (or several) page(s).
> 
> On powerpc, there can be several page tables in one page. For instance, 
> on powerpc 8xx the hardware require page tables to be 4k at all time, 
> allthough page sizes can be either 4k or 16k. So in the 16k case there 
> are 4 pages tables in one page.

Hi Christophe,

Thanks a lot for the info.

> 
> There is some logic in arch/powerpc/mm/pgtable-frag.c to handle that but 
> this is only for last levels (PTs and PMDs). For other levels 
> kmem_cache_alloc() is used to provide a PxD of the right size. Maybe the 
> solution is to convert all levels to using pgtable-frag, but this 
> doesn't look trivial. Probably it should be done at core level not at 
> arch level.

Uh, glad to hear some idea for this, would you like to give more 
detailed explanation of your ideas?

Thanks a lot

> 
> Christophe
> 
>>
>> Signed-off-by: Alex Shi <alexs@kernel.org>
>> ---
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/ 
>> powerpc/include/asm/book3s/64/pgtable.h
>> index aac8ce30cd3b..f10736af296d 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -1320,11 +1320,11 @@ pud_t pudp_huge_get_and_clear_full(struct 
>> vm_area_struct *vma,
>>   #define __HAVE_ARCH_PGTABLE_DEPOSIT
>>   static inline void pgtable_trans_huge_deposit(struct mm_struct *mm,
>> -                          pmd_t *pmdp, pgtable_t pgtable)
>> +                          pmd_t *pmdp, struct ptdesc *pgtable)
>>   {
>>       if (radix_enabled())
>> -        return radix__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
>> -    return hash__pgtable_trans_huge_deposit(mm, pmdp, pgtable);
>> +        return radix__pgtable_trans_huge_deposit(mm, pmdp, 
>> page_ptdesc(pgtable));
>> +    return hash__pgtable_trans_huge_deposit(mm, pmdp, 
>> page_ptdesc(pgtable));
>>   }
> 
> I can't understand this change.
> 
> pgtable is a pointer to a page table, and you want to replace it to 
> something that returns a pointer to a struct page, how can it work ?

Sorry for the bothering. Right, it can't work as I mentioned in commit 
log. I just want to bring up this issue, and hope you expert to give 
some ideas.

Thanks

