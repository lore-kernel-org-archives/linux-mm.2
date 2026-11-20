Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B15606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGojT1pX
Received: by kanga.kvack.org (Postfix)
	id 2F4A56B05B7; Fri, 20 Nov 2026 04:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCA36B05B8; Fri, 20 Nov 2026 04:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E25E6B05B9; Fri, 20 Nov 2026 04:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E939E6B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:32:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AEF9A0E57
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:32:13 +0000 (UTC)
X-FDA: 85454981346.28.20A6E80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 865DB18000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:32:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGojT1pX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795167131;
	b=dUMT8sXwamYgxaT38f12X4VNS/mZyd4qGtsIA5zZ88KScChDQYsWRTKPufzALuXeVzjzwY
	CyviMMf8YYpOcp59KMREJgplHHAX2dBr9BoO9NkxM3aXgvprboI8q9tIwUE5PShtX5b7sE
	mMzTI/Q8f9NVsHBY4lKZQE+QdJ2NbLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795167131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSB4v976klsbBf90H4eh8WMDP091ijp/LUuy+yy+YWo=;
	b=lHC8sshPiO9G7zwXcoOMmMKc95wFvlHzweC/Az69e4cGjNdY4bO/oUVbFSRvT0ZuL0QHZU
	EroBCZavgtJpjlvsNUrzMwd4KwuqW475VDxVN4YgswJrBhdnXZ0611Z8Im3NgeqU7YaXhg
	atOPovhvFvZMlqgNilRajoi27PqLLL8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGojT1pX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11AA9624DC;
	Fri, 20 Nov 2026 09:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB451F000C4;
	Fri, 20 Nov 2026 09:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795167130;
	bh=MSB4v976klsbBf90H4eh8WMDP091ijp/LUuy+yy+YWo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hGojT1pXLm0ARgaNzFbFL04UU8kien9rUf3A2JXL5vIP/AZMP4XCa6PqZHVOTkzl3
	 Kbo2++p0L5+OG6Eu1wwXm4m+du4rVCua+tRUOr92Qm+61aw/WeZ5G+r62F1UbaLBCM
	 WWM+7kt1N5lVCRMPtHaWDULUSA1Cu2RsSqFOKdoNDFfajKT8gFUJg/3GIXokJhqIk7
	 0eSDk5PphEeCCSsW+lFAT4d3putSLevVPyNAa1cW62Xhx/eHgKw+vn7qygQdZuS7GK
	 HP0L4Q7nWAEpbQo3KM/vV8DOdLn7qD2gK49wT2zk47eAtaHcSUG5x9Ee/eEjoOFXM1
	 WmPf3pA/ty+rA==
Message-ID: <857f5928-5aad-4e15-ad45-f8701e064c49@kernel.org>
Date: Fri, 20 Nov 2026 10:32:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/secretmem: Keep locked memory accounting until inode
 eviction
To: Mike Rapoport <rppt@kernel.org>
Cc: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261030152407.113568-1-pocj8ur4in@gmail.com>
 <45ce0b42-d45a-44e3-b300-607989e618c5@kernel.org>
 <av6m4wU7iDOGviIa@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <av6m4wU7iDOGviIa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 865DB18000E
X-Stat-Signature: k8f6aqsdsyw3jac7se4qcmuw41ni9tsd
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795167131-792100
X-HE-Meta: U2FsdGVkX18hNyjoxDRK/zSxnzDgZR18KXuwNiUcjSfdwlozWsxgXyIHR6ZOQL07PaW2Wf+VjvtbDXzs/iy7oKGjYg2AvTJ4NsQ0NFNVsi/PNcwQ5Vegs6n+3IEf84wD+Vbii1ggk2IvHt/tSdxzMvvK3cQVzjqyyYczjRS7C+IuxxMVNPQHkGDhJ7kdD3eDQs6tX06xocfcIHrnjkS9W9Q54nvJiYkNnNcrleLhILF7EcODh+JlyYeUX1oEsL5a0R0HuI6A1xPIeg0jphDzhoH4GXhUf7hsQDOCn33svM1EkeYadVVnHlizTEVrttSWl/pPiQCZwEcbrJVop0h+mh4vuihEDJ2VOSnrCMjwSbZyQxI+Y/cQs+dma44iEAXdM2ObrTGzVvv2OE0uYvIzUI+ciTnv8dVkOGS167SFV6pMPqERg8uuMCPZnvG4CQ4QhEVYEZyEgB6LdXy2AG3TAklylSQxGKnaplnuuwQRCsEIQLq2zxmpZqqGHC229FMafhc10gI9JpZ0PBj8pClMj9nHagMrsirlfEyfp1i0+RDiOiT/2h6GMRS3EiFhd8jtwgW5RFo1taSjbN/+aRq1xd53U3QKVc/NHsSVQ3cMplTUwmEwOxI0KIkqV/TebvqzrjFK+sb0toEKRjMEgMZFs7kIZS69WTa6GAqnIDNLqaPREtq/cxGyfpNGOPrWyGrbyoPs0uVSBzk8VSS5tZW0X/+OJgSnaapsT/kE4tJ/T6GmAG3NQPz0dAPY/cA8gF2tE8FMpoJYSXMZ8pe8jJPTqIjlYUGy8m36t1cS2V1rLTcn1JEDQHIU4tN9uTkUH0GHL60mMyiOdP6QSKkicVZdPuAIYi1T54ZirrxrfQD0/yxIWpxFHTEiyAR8x7VQuB6h14454hFw557NdF5jZP0AEdUj9+IBEhAqdF1kq4xE5gCWHLdhMVpLZfOX9A/6WQPdxVdiKgYgDI9UwuRMGsW
 5JI2VSww
 dZVCwqoUF7whXpbAiWEoPZm+pcUecboFH+0PspjN9F/kEwblTg5WW4t4Wxq3US/6Z0GFiVaT+/LcXd7HAHXn7rsYYJHLimIJDMCJCgYthPK0Y3S5rBEpdPZAR3t9AFL3rGeXkSeb475+rSYLeCRliwOoSM3OVFdxUZfOL80mXItgJ5xwxuj0XjfcuSqycldcKOIR0hsiSqcV0xSbCWgikjiQAG9/d0hZ7eoiDBJQBwj8RdSX6M4Iri2I/+XwqI2e24bSirZusaxSp+bZ+ddBJT3MheGFhVI3bx9JWu4Lvs06NXaxm3r+PYUwDAaKT8/UyCcEq4t1bhpEwmkINyrUrRUvmQyAtQ2DzQJE5/LTFTXabr7EIHXsfmuBJaxwUzAXIYyj2Hx8vuPfOd//dLXy3KsVALAKdAlKNWYsQNkvF3+BlOsJfcimfiimJ4Elh/Dp+hlucuevmK4yBCfN1Dk5sogSpsR72o9iT+2CwER6+Jm+E3TFiB3akdfiGVRE9rMx6WQQT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 08:36, Mike Rapoport wrote:
> On Wed, Nov 18, 2026 at 11:59:57PM +0100, David Hildenbrand (Arm) wrote:
>> On 10/30/26 16:24, Baek Kyu, Kim wrote:
>>> A secretmem inode can outlive its original file. An O_PATH descriptor
>>> opened through /proc/self/fd keeps the inode and its unevictable folios
>>> alive after the mapping and original descriptor are closed. The file
>>> release path nevertheless drops the locked-memory charge, allowing the
>>> same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.
>>>
>>> Move private-state and locked-memory accounting cleanup to inode eviction,
>>> after truncating the page cache. Keep secretmem_users active over the same
>>> lifetime so that the hibernation guard covers retained secret pages. Let
>>> iput() handle file-creation failures and tolerate an inode with no private
>>> state.
> 
> I don't like the last part, see below.
> 
>>> Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
>>> Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
>>
>> Lorenzo, Mike, this problem seems real to me. Can you take a look?
> 
> Yep, it's real and the fix is correct.
>  
>>> ---
>>> On an arm64 QEMU guest with an 8 KiB RLIMIT_MEMLOCK, an O_PATH reference
>>> retained two secretmem pages. The baseline dropped the charge to zero and
>>> allowed a further one-page fault; the patch kept both pages charged and
>>> rejected that fault until the last path reference closed. The Image
>>> was built with KASAN and lockdep. Hibernation, other architectures,
>>> and long-running concurrency were not tested.
>>>
>>>  mm/secretmem.c | 31 ++++++++++++++++++-------------
>>>  1 file changed, 18 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>>> index 384f5cfc457f..fa8be360bd2a 100644
>>> --- a/mm/secretmem.c
>>> +++ b/mm/secretmem.c
>>> @@ -185,18 +185,14 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
>>>  {
>>>  	struct secretmem_inode_state *state = inode->i_private;
>>>  
>>> +	if (!state)
>>> +		return;
>>> +
> 
> Its really not obvious how we can get here with state == NULL. 
> 
> And since it is needed only for error path in secretmem_file_create(), I
> suggest rearranging the initialization so that we never get here with NULL
> state. 
> Allocate the state before creating the inode and adjust error handling in
> secretmem_file_create() so that we always get to iput with valid i_private.

Ack, Kim, can you resend (putting me on CC ?)

-- 
Cheers,

David

