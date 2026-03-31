Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A780010F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC466B0092; Tue, 31 Mar 2026 16:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4726B0095; Tue, 31 Mar 2026 16:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9D96B0096; Tue, 31 Mar 2026 16:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD8296B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:50:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5962F8B7E4
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:50:54 +0000 (UTC)
X-FDA: 84607552428.13.138E595
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6525F40009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:50:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0ekHcU8;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774990252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ho/lxcLP1M5/u0UNdE+ZMlKo93vNUCFOIO+Ln7ZTxZU=;
	b=m7AmKQR74z8N+a83LXigLZDZx2A1KBiOMYwoTBCLK6ElHCfOB86zTBQ9NKhlYut7PzDNCF
	WeL8bWZvuh6O1p0a/SoeXSIZiypVTYK2NWOVq8/PIejmkPGUGO9+TSwAMp7btUvygeRESt
	Ed+olpnJiUF9O68s+9IwEgWN4Ci0N2g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L0ekHcU8;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774990252; a=rsa-sha256;
	cv=none;
	b=rKlVMQX++UrrpDzB6qQT9iVo57bwIN3JkLsl0rAylgQhcHAYyAgub8F+aXWUy6rzvEovbX
	e+gCZH92EqopyUYCOWflwmet8IG0VQcKekU3pTgSulfs3Woc92czY8ArnlqtLqTpI6jhR5
	xDTY9m850jKOyb9lKgAbUGIrQCvfV+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E29E043E75;
	Tue, 31 Mar 2026 20:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120B0C19423;
	Tue, 31 Mar 2026 20:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774990250;
	bh=VK5A4yy0VGMGiyXdNogpkOycz3ulih/Q35ZzZi3/ebQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L0ekHcU8aNxw4cMIJhgWfXXXKP5fXHi3LkO2rqW6zLNI1wPu7ssDqAQmTPZz580wD
	 nwl6fHS2MgUzWVlrLtfcWMKq2s/RGhvBBceLAwg30j6zxYztucryxJC+X9diEyRi9z
	 GtxdAg+bnItIiYefGAHCHK+6PjEYfhGFVwTeVGbGwjK8R50ZStqSIqwCDr748/goSN
	 hzZq1G9UCmZu82yR/jX9kOb/TqZC1ZYVpvr7naTxHK+jaNiqZv6UINRR7LTKblzygU
	 pVPzl5c7sW4GqgitT4Dr0PMTWnAyW5wxlbyy+mFx6HMEQlKO9b1wOXSSzQ9QZMWSNc
	 9wcO0z/+FPeDw==
Message-ID: <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
Date: Tue, 31 Mar 2026 22:50:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6525F40009
X-Stat-Signature: 84sqyp31be1jqsx18zd5kphpz86pc6di
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774990252-469651
X-HE-Meta: U2FsdGVkX196lvXZ30bIlAf0RSnZI/dwbSgxMyGQsoI3Gvk9h/kh5TcJamXXX87m0l80VjPanXkaEmg8KyfG9C/dCfqE0N9FzYMdohPYEv/Mg1LpcZwWctCQshTabuy7INKemx6anwe/QyanF6qE9Z4vEB39Jmdh5i0TNhlJKqBeBKwRUktetsnzxiyi9G20J3gb3LOctgGwThPVCjYq6QHnZVLWxwvuedaO3u9fMT6PIMynHiARmVU4hrgQDBgaJiFmTf4nAQf5AMwKeUfQ6wwurWt2VgLdF9CC5lhyuCsf2cg+jXdm3iu5fdEq5MDuQXhffSj9Uicaylr5etFVOmQQxyJUnR4xLQIz8jXkcgGqsiq1m6Tg8KlhJUWbZz+ipbtmXkIDnm/03+yHpNNZZIdo03lNQQ8p0yC+k5zLbuIj5Zg/uTX+qAlTG1GCci7f8QkRrchAiPNQU/1gS/J/iykFpBzEQ6E1EivQeFnEmQaFHYOZt8iPN4HwmOWIgWsBceWv6MOgjekj/G49DUlyC8t5RGUvcPIcCLFJjQF11KTk+XFT2KgYQGGdnzZ8js39m4lau4WRQpMXDUsQRP7uh3bHVbqtsNgcf572gi6s+Ou+36KopMd+8Ra1BifPByJJx6Ua5r4MJ82kjdBaABV9F7IXn11NgMB2LF4N4jljKAX1sZJmbTGlvbuFaneeDoUfSwS8h5s8wxzuEw/QmcuTD8vMxr/BOW7fiQIwTXQvl9fB6+XbYy/BC0ZWNtA6hSAOlRAJt4k9EWnXoyDxyH5gIFCPRhJ+Ldy0Rf6cYRWckSexUun4z9D8+E7wHRRhxVYNrwesMNnvepMjg5RxxPPCKKKjGr9dgb4wFzImga+4+zMW3qVuSGOFkOtIzO6JXARgFQSSPY5BKxWwA8fgwFBxUq848OwLX83rU/FdhZoQdfWeQo8fIZfsSdzjBQPGWTTRjxT6x7Ux2UcOnLBQV6Z
 3zGkE3yj
 SkuZlTXCrrZz23sQ6SKW1KIBW7bsLFNwFTzJea6XU5AVlgVlKg9wzsSb6ANYSb5XfELZI4HNMjdJD0SEka2G5mNMsa+t/fOh2nY2phDCUcP05ZfnTw9c7tovNH8L9R5SsFxTySu5ByNKgL7Gy9aZFSuwgM/PBhKClwUvxJDn2bs7LVUeTjBoWNqtDZup1YoCUc2WS3KaEmOlHcMvtsvw++KkIyFSFWj0y6wfMl8VNNRrbNXUwPR8qNAib7Pg2QPcNOJqUGpNI01snYfPGRUAr+3ocZFKYP3MWGJD2+kLjs5L5qIXVOFlJcjoiNPC9U/tDpHUbl6PqiRbr14FiQ7Po7ohkltQVNmmQEbYAvPQrytBn8BC8LTiP3n5iXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 22:06, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 31, 2026 at 10:00:58PM +0200, David Hildenbrand (Arm) wrote:
>> On 3/31/26 16:15, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> That updates mmap_unlocked which will be handled in the loop or on exit:
>>>
>>> 		if (mmap_unlocked) {
>>> 			...
>>> 			mmap_read_lock(mm);
>>> 			mmap_unlocked = false;
>>> 			*lock_dropped = true;
>>> 			...
>>> 		}
>>>
>>> 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
>>>
>>> ...
>>>
>>> out_maybelock:
>>> 	/* Caller expects us to hold mmap_lock on return */
>>> 	if (mmap_unlocked) {
>>> 		*lock_dropped = true;
>>> 		mmap_read_lock(mm);
>>> 	}
>>>
>>
>> Right.
>>
>> The original code used
>>
>> 	bool mmap_locked = true;
>>
>> If the fix get squashed, maybe we should revert to that handling to
>> minimize the churn?
> 
> Well collapse_single_pmd() and all descendents would need to be updated to
> invert the boolean, not sure it's worth it.

The code is confusing me.

In the old code, collapse_single_pmd() was called with "mmap_locked ==
true" and set "mmap_locked=false".

Now we call it with "mmap_unlocked=false" and it sets "mmap_unlocked=true".

So far so good.

However, collapse_scan_pmd() consumed "mmap_locked", now it effectively
consumes "mmap_unlocked".

I think I have to squash your fix into Nicos patch to make sense of this. :)


-- 
Cheers,

David

