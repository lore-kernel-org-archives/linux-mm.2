Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9F8F36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DA06B0005; Fri, 10 Apr 2026 00:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF026B0089; Fri, 10 Apr 2026 00:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7050D6B008A; Fri, 10 Apr 2026 00:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB716B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:21:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2C21140392
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:21:56 +0000 (UTC)
X-FDA: 84641348232.10.6CB949D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0A51880004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:21:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V7lLGyCR;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775794915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6uHJXCSUTxlOlhJ1YH5vcsGK/++2J1B0XW1TG+HJgk=;
	b=sWKsj+gRusbdbAFh9mvJ2n8XLj2chJ+OLRuega2cwMJfWLa80iwjDlCHo/oH8+DfFzkUbv
	Ij12CoaHmCaVo4pUvREHzde8S98Di36Qoym0ZQbjtDoapg2+oU595cdDlHgGUXrYNFhJLh
	M3fpvFpW4NJOG5/aERWe7QTpe2/ijIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775794915; a=rsa-sha256;
	cv=none;
	b=oATOJ0LIYaDe5zZonpuVhdIgjneTxas4NZQFlh05L6z6K6XBKugFk7QwhIXqrUSZua66cC
	oFB3e9DkFZY+U8DmT6SyfYnykRzg2g0PQvQ/AlnWuOHhrDsrtieNThnaXKlQpjXjPPjDs7
	ou1YOI4cOoYWgWKTng5Z1IVsk3hmASE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V7lLGyCR;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 845DC2008;
	Thu,  9 Apr 2026 21:21:48 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 668AD3FAF5;
	Thu,  9 Apr 2026 21:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775794914; bh=yNYtRWemxBehsStI8lS7zwbuvuaTycWq8O+12cp0kh0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V7lLGyCRjzBFKUjJy+Tws9lDROrQyWlkUAfTsMgWOPjwWM4bQpWwJ7us2nynvVNU+
	 /HHMG0BJUWIRBfYoH5pUaQ5zBK9mvngorFK4TzUQjF2xigTG21/X0vRfbEMRa5pvIA
	 tE5gLPUsBiB3zI+Vp6r3xRWJKI42w0c3dDz1YYsU=
Message-ID: <18173611-b233-42a4-867d-1e474feee534@arm.com>
Date: Fri, 10 Apr 2026 09:51:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 01/16] mm: Abstract printing of pxd_val()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-2-anshuman.khandual@arm.com>
 <adeAhYW-hJ7-6-Xy@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <adeAhYW-hJ7-6-Xy@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ip416i45r8br6ubadf879obpyz5d56kx
X-Rspamd-Queue-Id: 0A51880004
X-Rspam-User: 
X-HE-Tag: 1775794914-524887
X-HE-Meta: U2FsdGVkX181T1XRTkvPW1wuLjtS9IuIFXq7nK6Hy7vG+XxVDByQlAnYqiRtvLUTJqkxOy+hcZsjW/P1GU1PFdUlHt6KpUoawq6o1+qxwOPAsdPH2oIrNsrkU/iHiV7lHv9vShlwHlAmsVmxJLwI4hrYaUAyku19p/eSLXWFfqcIHUHpJgclRtkqX3UGUrUndThiyZkHg2jOncIjvjrhgm+ul7wjNhEpEF/CPgv9LfcillCaofgukGXpw9T3CgNncGzg0OHf0LGjdrneIpzsqOhal1Xv88MdMwbeW28zvFE6Cfk/WppgU8A8arvX6pxvK6fyp5xYpqpXhU6Wmo/ZgCMmIYU5rPXDCTTbJA9pt46LrL4d4e2KfOF2lV9Qs1MJ2GT1Zp6IFoC4oHlz44ea815Sg8mtiLo/+tF3au4zxNPVaqMZ/KOQLVnhtrSFKEOMAb4tyyLBwYo/C5Cf8PZ5vzghxvQUcpRMin9nUbQvUxVwZ2pUEghXZwGQ528Vz6VSYnTTEDuMRd0az0jRfJaCynqL1ha+rnr46Ys2g8KS4umzp/7juArRB8OplS8CfsNTXsNdp17ByfQW3KLrrskz1f0SHtv7FyR8uIyLYgFoarQb6Y25KJozA1SVowp/W1wiYwj0aGpvH7QzUNRnDPGTmmh8eBY3J0CZTnpRTL2kLcttv9R5FZjwpZBvvM1olhdDobgoHjcrn2ba1cNIrIlOG2GgJuvgigNYO9ttYRaN44cMfqnc2qw1BHBDspzUfgreU69rmMkzR8FAcyeRd/BUvCdvRum4yXv0wvgFFOeVPK+ouLooTDMQnzWTI4R7pnPC7lpvcLJUwOgCm/KjHyejF2k//7hcc/qQ/cdxgmieLqBBpgiavgHrfFHw62nzuki1rz63bs3dliP0ty73aq2Wr8UskUR02YWDhVikAN/Uy+KjS13y8AH+cm5+mFXmsAGb7NXmqmwC+reUiE7me5R
 8h4eW7Ph
 pP9emca2DKOeRPz6if+Y1xGPF7SP7RmpgC02CCrWm3tnmdM0u6O3DHLILrjd5X73V9bAu4F6OP7AuJLtSlZSgQbScv+wCXpEEnUljbEnC7b8skkTVJthSkCbPWRq8qN4CW9/tY+BiuCvlRd9oWH/y2YYlQfIFz3m78Shjlkwkuc44kn8ppMtCw4RCh+pOUNMOaX/t9PdePEh2m/FlDXaS5ZiVo5WoxHCe1P/Ku/RyjWpiNbhTWDgXFUJJhDOUC8syhin8vM5aaiFrkKwaYKiOK1uBpsBTmibGm9ppEyFG7bZ4Dpc5AGWgr0rR7ZOPkprLvG4ezilmQKD1I98kouCotdSDnyR4uhKXAxLmIJiiOgErx2Zv2GCcBTvSbrsOaXp68Y5Jed20sDJSXXJJydyOPV7FEtoAUUi/axyNNgaHwqmrcyqEeIEmqe5u1LTQQYVYS5LrPhfRYx5xuyH614umYBJXd7coRtuc/wiBuOp2YmFQ2EKVioEWUQ+P6K2a12HWCZMCjv3S4LUo7S02w34mLEtg0YU7zULazOH6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/04/26 4:03 PM, Mike Rapoport wrote:
> Hi Anshuman,
> 
> On Tue, Feb 24, 2026 at 10:41:38AM +0530, Anshuman Khandual wrote:
>> Ahead of adding support for D128 pgtables, refactor places that print
>> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
>> macro to prepare the argument(s). When using D128 pgtables in future,
>> we can simply redefine __PRIpte and __PTIpte_args().
>>
>> Besides there is also an assumption about pxd_val() being always capped
>> at 'unsigned long long' size but that will not work for D128 pgtables.
>> Just increase its size to u128 if the compiler supports via a separate
>> data type pxdval_t which also defaults to existing 'unsigned long long'.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  include/linux/pgtable.h |  5 +++++
>>  mm/memory.c             | 29 +++++++++++++++++++----------
>>  2 files changed, 24 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index a50df42a893f..da17139a1279 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -17,6 +17,11 @@
>>  #include <asm-generic/pgtable_uffd.h>
>>  #include <linux/page_table_check.h>
>>  
>> +#ifndef __PRIpte
>> +#define __PRIpte		"016llx"
>> +#define __PRIpte_args(val)	((u64)val)
>> +#endif
>> +
>>  #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
>>  	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
>>  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 07778814b4a8..cfc3077fc52f 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -532,9 +532,15 @@ static bool is_bad_page_map_ratelimited(void)
>>  	return false;
>>  }
>>  
>> +#ifdef __SIZEOF_INT128__
>> +	typedef u128 pxdval_t;
> 
> I don't think the typedef should be indented.

Sure will drop the indent from pxdval_t.

> 
>> +#else
>> +	typedef unsigned long long pxdval_t;
>> +#endif
> 
> Don't we want this in, say, include/linux/pgtable.h?
> 

Sure will move the typedef into the above header.

