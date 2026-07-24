Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F7EC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8206B00AE; Fri, 24 Jul 2026 06:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88AB6B00AF; Fri, 24 Jul 2026 06:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79E56B00B0; Fri, 24 Jul 2026 06:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83B776B00AE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:27:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DDA8A01C4
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:27:46 +0000 (UTC)
X-FDA: 85023294132.24.EB68D0B
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id B972D1C0007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:27:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N4ziqE8w;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccsuifxVD4ccTawr4skf2XENOpZrUTl0tM5ESKoH++4=;
	b=GPmr7Kjoyd37gswB+1lIx4JDOG1Pm2PUPjC6P80mLGVexe/moQnhRTJjw3q4hckUb4J0HL
	sYo6QgwcZcl/O2U2JxCvP9kGxDubNOaByxLCvZzZ7pyAowwAAvTzH4aZ62MKRlwGguftRO
	Z9m8dxCdlj2MN++C8A5swAKAvi8fwvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888864;
	b=yn/u19No4IYRAT43IHRhOUmcEqkE/opyU4WOlv4VNbaPZrCBxSPMXe/rdAoIRUrPl9mzEW
	5/mdDO6Lwn5NTQ2jiJ8tFeAgJ3E4bIP8phAmi8ozANFt0SVEs/hDQFT9paLZE8WRFo9MIZ
	8r3Lf6d2chVHddCZS14GWey1EhOTHzU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N4ziqE8w;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f6b71e13-0eb4-41bd-b2c5-30bf48a174f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784888858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccsuifxVD4ccTawr4skf2XENOpZrUTl0tM5ESKoH++4=;
	b=N4ziqE8wqT1nGDUzerglRm6kGNykObDiNIcnOZpr5A5XqStRs+sJFKIlJBhGUnWym+FzhA
	LD3d0d2X+zuK+vVMdutpO0/xLyNlBurgiNU9erAcSpt/tLEAPt+Cuz3FjQqh2lHQiU1Le4
	YV8rWix0eKZneWpH/PlsA3p2OqygvIg=
Date: Fri, 24 Jul 2026 11:27:26 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-11-usama.arif@linux.dev>
 <amJoe_iRHEaMdo9i@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amJoe_iRHEaMdo9i@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B972D1C0007
X-Stat-Signature: 151ejb9whi5aoc6iapc77zak4uz5t8yt
X-Rspam-User: 
X-HE-Tag: 1784888862-387343
X-HE-Meta: U2FsdGVkX18REdlgE7z5yKJb4tDEj+e5wP2Z4EQVd8lHbKAXzQ1YvCBrBmVsgxJgiMZi8SN7C9vWk43s5+3m3ZvQ2lIJC8NQ7/cBPLCwTd6f9zKOs3SwA7eBYUGaIT4Qm8SAJNsuO4FNZnUa7EzwfvxQz0EH/NpopN5xaNfX/y8amQ7nY4x62wlIfmhEbGW0gSf7/Pr+izyt8AQTkAC+ZakgsyzJmbGmkSVaZ9GBOiTCa/hXxUwRBSEUtnHzAWOKNc+9TM1Pkn2oquNr+ZxBHo3VlO5b6JPEERa9+mQqRQOUtW4AFsm6dv8vd0wvI97ac3nwDMmplOBXFytkAR5soYf3Q9KbQ1fegiVpuP+TRIw6gkM04SCXYqVYMcIEj99hXXD3EHg/c0Ad7K0PZMRNpzb6N4rT1fMugzkg5xq8mu3vnIUENtFgvPKqba6NPLMXk6Vfx3Yrutr81oGNZB0nBsCCrBNYHqV2fY/zzebvR4sIqTEhYHejTZyNGuEN/oQ/CiNMbRpBYxjg0XFYE3LR4j8OIwpSp4SqW/Sh8kUiHBwumaZ+p9DnYqdziz+2UE3McCstVcl99N8b76BnmSpT4T1t5X6YyYX/cDIGWXiJhQ+E0peiLi0O8MuEQSC/FDQN+P3rxSwL814X0nRdLIuLggNhevdWqKNFj+R2309OCldk3pvTk5QTgoiU/CjwgszhHPYtHmaMNIYUiq9gqcIe7JATLVP0t5aVvqMQ1g3q/dXUhh2HPCqfSVc/icSuxvq3OwtxDi6x5KDWNJSgGc/siDV1wsA+fUxRJCD0VsDVyKE4Ti/+CXfJ7zBrg+wURuxzT0yLHqW52KrrU71MWUIhTmKFo4JW2dY6t3SgkThk6Ds2bsbtNVkDSh9Rp5fU8DM2I49NFFaQwx+u5VUQDe26hTtOtZbvEUIfHBm1Oh5ag0V4K9/vM+MkwvSWqqz/TjNwwQy0O7pd8dJPRHeUSnx
 eqObcgLr
 63tVjX4Kkzs1yop0Af20OTnKCu7uXk5DQ/qnxFLnzMn2uhpLWjqJhccGWq0/gKAlkqjzHoY2k5JMbynUN7h0NtSOZMTxbJ36DpjoVw5l36wQQzWkbjravbTZ6mKl2Fgtdp9NwpVjTmGJXXCyR3TKbDLBrE9NgT53Jr5An+Kuagdv8qw8oHpWr8kciG9P0WwI969gJ2iHoCcOSFsXIyXudnzKjKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/2026 20:16, Matthew Wilcox wrote:
> On Wed, Jul 22, 2026 at 08:19:41AM -0700, Usama Arif wrote:
>> +++ b/mm/rmap.c
>> @@ -2282,6 +2282,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				goto walk_abort;
>>  			}
>>  
>> +#ifdef CONFIG_THP_SWAP
>> +			/*
>> +			 * If the folio is in the swap cache and we're not
>> +			 * asked to split, install a PMD-level swap entry.
>> +			 */
>> +			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
>> +			    folio_test_anon(folio) &&
>> +			    folio_test_swapcache(folio)) {
>> +				if (set_pmd_swap_entry(&pvmw, folio))
>> +					goto walk_abort;
>> +
>> +				add_mm_counter(mm, MM_ANONPAGES,
>> +					       -HPAGE_PMD_NR);
>> +				add_mm_counter(mm, MM_SWAPENTS,
>> +					       HPAGE_PMD_NR);
>> +				goto walk_done;
>> +			}
>> +#endif
>> +
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>  				/*
>>  				 * We temporarily have to drop the PTL and
> 
> This makes me sad.  It feels like we're bolting more complexity onto
> try_to_unmap() instead of removing TTU_SPLIT_HUGE_PMD entirely.
> 
> Ideally we'd just cope with folios of whatever size (including
> PMD and PUD mapped folios) and only handle hugetlb weirdness when we
> absolutely have to.  Similarly, we could split PUDs to PMDs and
> PMDs to PTEs when we need to, without the caller specifying
> TTU_SPLIT_anything.
> 
> Is there a reason we can't do that?

I will prototype what the code would look like without TTU_SPLIT_HUGE_PMD
and get back to you on this. Looking at the code right now, I feel like I
would be shifting complexity, but let me try and do something about this.

