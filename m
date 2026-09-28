Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C85CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5430E6B0099; Mon, 28 Sep 2026 08:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3BF6B009B; Mon, 28 Sep 2026 08:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A1D6B009D; Mon, 28 Sep 2026 08:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7266B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F5D81401E4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:04 +0000 (UTC)
X-FDA: 85263037608.02.60E3D64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D42DD160009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fqrf3Z9A;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8P10dL4hMXu7vX0PWvRPQhhCrae/q3zz2jG9lav8OI=;
	b=PN0HUeiuk4snvpr2pz8QfqyCOoaoWx0kfWBHDD6kCS7uZb5Z00MSdvo0QUcH5cu19nWErN
	G9wfmIlshZOkL8cvoahAlbmZ7IkTlDQo78LliruIJpbSrE3vHekub67UKi24xuWjwT5uKU
	Gpr5eyJAZxGu7xXYkZEYkeu77LdjTgg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597042;
	b=3DudH5/ZhbdLq0//eR+/eGwOTn49K/q/5SZuyr2YCbQLgVug7VKlpkvBGlaMTUxLs1VnYd
	4MFBFXZ15lzcB3lFW8KM3887bTEhkwfZQSOVSq1M+nx8BS9Mvu9xyJzo8oXmS45NyAqc7Y
	66VFqMxyS46A4mGlyz3cmyZp+jKRcT4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fqrf3Z9A;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 521E560052;
	Mon, 28 Sep 2026 12:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F61F000FF;
	Mon, 28 Sep 2026 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597042;
	bh=l8P10dL4hMXu7vX0PWvRPQhhCrae/q3zz2jG9lav8OI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fqrf3Z9AmsyYalf4WIQtZIPDGFskCtQzDdeFUQFvnbt0e21AGt/iyUow0pjpj0Bcq
	 ZS3nJaMPUOuGKS2S/SNBSiIP0OEcCr3gNEees9i23odqtTKLLKZxPnhq/XLrfsh74h
	 QuLdyCZgL3fmgASjt4IGH6RtBeetD9G5Is5QdBdLipE0Rs06j6I6z8K/Fd3B2epO7R
	 Ins8DCY161m4xyPwJd97FrtiJXQNyFKZEe3/wlqssvSOPcu3EoqgsLYguzOuMAbbcX
	 6GiJtbJrIZZhZxq8k3OPkYqeU2QgpuGifd5IGeYAKhxUobamdknzGW2rDzjaqWPRCF
	 +3E3AhbIvYiSg==
Message-ID: <abd32250-6ba1-443b-b8e4-7772bcdd325a@kernel.org>
Date: Mon, 28 Sep 2026 14:03:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/12] mm/collapse: declare the collapse interface in
 collapse.h
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-12-kirill@shutemov.name>
 <63f49a8b-cabf-4b93-a7e2-76b62c463a90@kernel.org>
 <arU8w9qDCvKod7PO@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arU8w9qDCvKod7PO@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D42DD160009
X-Stat-Signature: cnyqtcf9e5dcjch4nr3kahner186y9x5
X-HE-Tag: 1790597042-726623
X-HE-Meta: U2FsdGVkX182xQj0y0rnfjL92e+s0CMlnKS2/wHwh6t6sns1NMzOIMN5Vd7HfYxllKN3/eoLEbuyKhxnxyLrGOC2I0YcsyI88ZId3lLswbc/lBJv/sC7zXpGoc0x9J6ba/f2HpCTkp4NlVIixfE/5+mMLvUn9gmF3EuF6nIqUQB9cSuAAJIZ9JOvQ4nkw3ybZ27NpqT8aLT3UpjreROVBOa36zhticnF9TrZ6+hOMIY2Ul5FfR/T8MsLWQXmzrULE4rICRfIyFnr1PLfj0SIolTQa/fdDSVsNg2GtEUo3LzP8lsOZBOTyKACVWndmQvs4mWPwC52oeDssaneyVOwozlSpVfZn+MZ5kJOP6vD301jkzvxPo1TIc74t9Tzxgp+fLaXmSfybQ08eWWJAaJi2W9PpDUvLtStjyljdwZXgMBXDiC7phoKO2W4DrFz8eo25RGfMjigdle03simW+q3PSYJ/HEDew3/uBp7Jk19qGxqb6dccjrxdVYAPwwp42L1fReVtXNTMsfDEnyWJQ2byWe6vQpPCYCj2PDoxhh6XPRQxbV/72qtbl+2Zi8VWylBawxemQ5ZrUA4ZhaWPYshiCJMiWpj9uigcvWZbR3+8AaitI86JqBih5C/S8YFviBFqrbmIvDOuueGqRMR9DEyhKRNg2YVIWKzylvVwfcDRvpakYFpxEsVcec+4FI9JdPljBp6fgU4mvwO2KtNJ/tlCmOAFkR+YfEYIRvA54HW9jrdcUB7APXUJcZXKv9ra90C3MP9RblUI9SzepTeqhKEDBrRszUZevVPLeTzn3y0BnXSgPlJRL1ci8CaTJ3oCKXXjm2O+oud0BeqiRwd1MBoXMD1MN9ad4RZnXJnoQ+llZIJepM7w+Pty/DKsf/0YPCi+obs0WpsSIEBCnV1TXsmTpcOACi1Ip4448Pakw8v1aT1zirn3iitms6iMIWvk/sIlu2d8no/e/+BXBJHsRP
 dP1tbh3K
 WVNgIvxGgzuqzD91qzjnaU7P3km/+2IpBxEV7Z3OAqMENIkumTKb+pN4vw41GDIXbfXwW/4ikRdvpoYvgLBEYZyujV4IKELtqr3YMC6O1I4aNi7EDLLOs09EDcFqp1WvKQR0AuAgDjEzSfgIonB+cfDLAhETpdBeFp08UZWEG9D5SbWOPcamNvnudnCrzH+KLUsnqPkxxGChh7Vk1RG9Bu6tkDyA/Rv1d39s1MlREu40GfUh3w4FpaWZDw3sWDIDac23McySbXJrhBmBwYAz80W2Jag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 17:22, Kiryl Shutsemau wrote:
> On Wed, Sep 23, 2026 at 03:34:11PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/16/26 11:31, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> A collapse takes four calls:
>>>
>>>   - collapse_control_init() - set up the control a caller carries;
>>>   - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
>>>   - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
>>
>> As discussed, having a single collapse_pmd() function might be cleaner if that's
>> easily possible.
> 
> Answered on patch 9: the two calls are the point.
> 
>>>   - collapse_control_release() - done with the control.
>>
>> And as discussed, I hope we can just get rid of a release function that's not
>> actually supposed to release anything right now (unless I was missing an update
>> in one of the patches).
> 
> Will remove in v4.
> 
>>> All four are static in khugepaged.c, as are collapse_possible_orders(),
>>> which says what a VMA allows, and the revalidate a caller needs once a
>>> collapse has given the mmap_lock up.  No other file can ask for a collapse
>>> without them.
>>>
>>> Declare them in collapse.h, with a comment stating the order they are
>>> called in and who holds the lock over each step.  Each function says
>>> what it needs and what it does where it is defined.
>>>
>>> hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
>>> what a collapse offers now, not a helper of the daemon.
>>
>> Is it just me or is collapse_vma_revalidate() an odd part of this interface?
>>
>> You'd expect a matching function that performs the initial validation on a given
>> vma.
>>
>> Maybe we should have a
>>
>> 	orders = collapse_vma_validate(vma)
>>
>> that really just wraps collapse_possible_orders(), an expose that instead to the
>> collapse users?
>>
>> So they'd use collapse_vma_validate() to then call collapse_vma_revalidate()
>> after temporarily dropping the mmap lock?
> 
> collapse_vma_revalidate() re-checks what the scan ran under: a VMA at
> the address, anonymous if the scan went that way, covering the PMD
> range, allowing this order.
> 
> A collapse_vma_validate() could bundle what the callers check before a
> scan, for the sake of symmetry. Feels like overkill to me.


I much rather have a consistent collapse_* interface than mixing in other weird
functions.

I saw that you already sent a v4 (too fast ...) so I might complain about the
same thing there once more and we'd end up with the same discussion there once
more. Which is expected when people don't wait for replies.

-- 
Cheers,

David

