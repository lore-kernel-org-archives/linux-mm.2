Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11500C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F0F6B008A; Tue, 14 Jul 2026 04:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6A76B008C; Tue, 14 Jul 2026 04:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024E56B0093; Tue, 14 Jul 2026 04:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D50226B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:36:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B72A402DB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:36:30 +0000 (UTC)
X-FDA: 84986725740.11.CB2D5C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4043280007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:36:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rw7b4Ah+;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784018188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDGBGxMLY2f3fvwCi3z4JyjX5BZvDlkMXPcR3ZxGc6s=;
	b=3ivC84OdBNgA3Ill0L5O8C7ec4Aqm1mtXtLkPHMbU7q7xV9ZZOR2p/fhTlQ0ZSfBTTYVWQ
	EBEMbh5Y2sx8kJmx0GZZD5hLYI+mZ1RLiR4IfnBbVrQ4QvuKuUIX60XAbIx/vF4LyF7p6c
	dTspFCRPKp8pKZzfrRo/Xye2WE578K8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rw7b4Ah+;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784018188;
	b=BFe31MlxJTMoQHOB6LB5NLud8c1viM1npNc3n9qjxiZHOgDTq8ntEJNYlVk0aYwpZh6Gdy
	PmvKVhkUsXnBryi2BMjGFLLBPbEMi3surXyHJmZuoJBuOJiwEwBMx+msQoY5U4o8MSGUNO
	RXEi13v0qJLgBtPXdMLb/FyM1gabhtg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C13E51476;
	Tue, 14 Jul 2026 01:36:22 -0700 (PDT)
Received: from [10.174.43.51] (unknown [10.174.43.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F4743F7B4;
	Tue, 14 Jul 2026 01:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784018186; bh=AGh5lIWu+Wfrmi++dxD+3aI9DBae6CwPDFEGYSFnVIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rw7b4Ah+uga3FnevhlB/g0Y+OhmjMpx14GqulYuXCa//NJplqDatQszbIzym3ESTS
	 sW9yHfsriNZHqLPswLscBCKXftbr0qmWcmhocrkKU1NYPwT6nfnJwbTcrPXFtiUE7A
	 rtngZO/Fhzaxh7c0pZgrcQhTQJrcs+OabQ3b3I0E=
Message-ID: <929dedc2-eea3-4153-be6d-d2dd727fed89@arm.com>
Date: Tue, 14 Jul 2026 14:06:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Wen Jiang <jiangwenxiaomi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, Wen Jiang <jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4043280007
X-Stat-Signature: 6grmjxs8tros8tubf4dd6jt7m687kmd5
X-HE-Tag: 1784018188-35036
X-HE-Meta: U2FsdGVkX1+oApOsMVuJ512NbxL8iecZfUcvKZgscfVTGUbZDunquRrPkCmv6vwTQIl+lLTpZsVdP4w1d621oOlAOA2E4ebZCcYLMxKILLBW4dbJ7GI69BTJYfospOUTQqyuJT8uHYG2qsx6CPKW93Bm9RvvBNhXgUp1OZWJkLb875pZu+yQWhSSYopX4SLR5U7y42PybiTa36FOfWAw5zRVhqluONOpYXSYxLNMy79xxneoI9lZGZSOYIOj7PvLOfz6Y4doXiFdxAU6Ylko2uzBvW7B0lCPamjZyHPupJoXtWad1c4DCQjCo0ON6bhG8nkvTTgDRoskBbSYiM1NTPgT3tCcg+8HrLfp/jDEqhq60Xz0XrVLilv6+zO/h5ZDL9q/V+EerMFYXDbfNMlzUsbDgGiK3652OecqjbOQLTlDkm/B+rMdRJFRiXHtj0My7rZTAZBYc5at3myXYdTElC2/v/DQ2Bek1TdFW2niOwtARSLLrcLlWRX+bX7ojW969bCDjpyyAtWWpNLe1GFjWs7HDTI32Lx+F7jbQk0s/R82fQbhj8kKSv3laUrupP8d1Ve7zQUaMtwWX/qmMPutqhU//u5r8Af0NhpPiaesr7lybFkeJG8MHYw/ytWmYoJHqmUi29l/33I6L+flcRc/YTUOTTsOG5auo4OBHYm3Ie6ZveMbkSVRcY0kxPYSRdILs+VSWku/cwvszM6IOWw4J19Ldc3XHg3qSaSG1YuTWSm1MBlnm1hLePy9f9uPmeOMMhWHW/HmyPs+8sBhLgdGfLEdlL7Ads3o5m64xD51q8jYcIQdEQIAA2QW1e3/OOGRSK8PbizbcaxgbkUz78gBq/TYl1t9cyyGWX8ne5DGvgeds8z6EKUDhg+qNdE63tHc5y24LSpsj6z3M3tVa+BtdJqi+a38z+NXmXUho4k8+2htliFWyVZ+oQGqghicC9qFsUC3XO2Fpjlj5hp7TRZ
 X/qSjPzT
 Pd2yuwkvZQFg3gHAcX+CJr3r/NQKW2uYU+RYklXx93Q542y4Sz44vWrxTzc3TwRsnu3xqRDxfuNnDiawmnw37jkfNtP6j+6pp81e2s+u5rRiD4HyDGMCRHp7mpj2ZDD0Sc+ymHwlMe9RK11C07XUZ/HNr3Vi6A1cTWGvuro4uYenuThS4MMT/hUCWL6l6F5QOluFDT25Jdun/jErF753lOUVxyuMPn5iFOpU8NhRTO6guPkGpdtDQ/cBu8ifVStW4c7mAYr0U1DiPnhr0fqHXMfoFKhWBHcisFX8GOMuboJf/KrzS95K7QxhE7F/Ybh3OdvE+94K3/LTjCKcn1FEc/oWRAvDr+AUrZLufISBbOoSo6GWYlCa49LvIlODSKo+lr1ib2EXN8iq6e8ntGu29sJ6pjb3GOId3ubz6DsAV0U4izZz2ceTyXSLUvbCI+cHofiN60GzjvLCTSE/4M6vpfLCnx7oxevSz7lcL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 2:24 PM, Wen Jiang wrote:
> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>
>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>> is physically fully or partially contiguous.
>>
>> Thanks, I added this to mm.git's mm-new branch for wider testing.
>>
>> AI review asked some questions, and some of them are new since the v5
>> series:
>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
> 
> Hi Andrew,
> 
> I've gone through the Sashiko findings:
> 
> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
>   is added. The extra sizes are only used by init_mm kernel mappings via.

But not sure if that is a right approach. If these multi CONT_PTE
sized mappings need to be supported in vmalloc() but without adding
corresponding HugeTLB sizes, probably these required helpers could
just be factored outside HugeTLB.
> 
> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
>     array of valid struct page pointers.
> 
> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
>     already discussed in the V3 thread, and a separate fix was proposed
>     there.
> 
> Thanks,
> Wen


