Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA96C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711C76B0095; Thu, 27 Aug 2026 11:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C48A6B0096; Thu, 27 Aug 2026 11:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5654C6B0098; Thu, 27 Aug 2026 11:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26F0D6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:58:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9812D1A045B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:58:31 +0000 (UTC)
X-FDA: 85147506822.08.F733D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D2D5D20008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:58:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuvYdEUG;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787846309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6F1CmlViOZAv7ScdpKDj4KMGRJno7AOUlTrCO7k1xM=;
	b=Hg0EWBENNSfFDthrKFo1HU0Ys4PZbcQ4c3wYxLHszmm0WpIS1/gmPIxWKdA3f8P5XGN7aV
	4Ta55sD5UZIT4rqqKeSQbjaojRECmU7d5jH4LDaMQ8UOniXmpy4ucGFBIE+QPZIE/O5MgC
	dgEUTQ0qFpjHkeoVFyUspQ1jRlMLZpQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuvYdEUG;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787846309;
	b=jNjbRlHNgahx17rJCKKGiRlBLdcaJk4shadEgvEfHmTHx866gcT/tg0lfhIb+QoPNuorfk
	JZVSgB8JbeZ/VX6XuzxF6BGBv0+L6EjwSzlYqVaCoS6qVD5z44kgHyaWPasZ7cdHRK2tbi
	8fXiYU3W3qrYbJtIoNt5xusW18Krjjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F6C600D2;
	Thu, 27 Aug 2026 15:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3416C1F000E9;
	Thu, 27 Aug 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846309;
	bh=j6F1CmlViOZAv7ScdpKDj4KMGRJno7AOUlTrCO7k1xM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IuvYdEUGfFZHsjDqrO3R3icx/zIgT8pMZ/kZa56FxwIxStQoFO0r0hSM8mLtTLCyN
	 pqcjwK8SZHPICdndkn/dK6o8R9vpsFIfZUAnDvCgJpHDWNZixYX0GeRYWhxRVn0zid
	 iROWgn+A45NWlds4wpAF6a+T6snS0vCp+WgsaOPqutp1FhQtn4ngXacsbFhEV8yRUw
	 mT4UAAoRbw+p0YJMOZDOdIMNVrGILItRwJcAEdjziG8XqKl8HmI1Ft95TH/9j36qLB
	 a1ucmi/HX0RRUUma2nTGd+VPWyQdBmbjAvMrzbZnwFRrpsQrpNjKkFHB+TutE0S4jy
	 fpOmavz6Zq98A==
Message-ID: <8acccec9-acd7-48e4-a461-0a3e706466c8@kernel.org>
Date: Thu, 27 Aug 2026 17:58:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: Kiryl Shutsemau <kirill@shutemov.name>, kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
 <apBJ7PeX7c2dD9kk@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apBJ7PeX7c2dD9kk@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x8ayzm4p5hia1dtyih88ydnrtkawp41d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2D5D20008
X-Rspam-User: 
X-HE-Tag: 1787846309-397462
X-HE-Meta: U2FsdGVkX18brFE4e0CE2ly18gOI08GeqENHGmvjEtNNZGdh++pNJHSlabc//46ASBYiTBovsm+CtVrrEwgYsTNjlTb7H4mjLSBjzRjBHznfIDWKnoeuonkmKJVJ0qq+x6oXHFnO0M/J+nT0VxT6lMndvqnezpd/ewq1hOoGSqJM7/zoZRAJTXL8LRERwxhnXKJ6Ehqcn7ivtS0lpQHJYeVwRDJBuZOLw2qpksPHt+mus6h9p7owQ0uv86mnvgytaLpLq3akiY8crSZLsbgTdyfs9WN23sI+dMInFG0yo1P/rO30Q4OnisXlt/A06s0UZ5t8R39mtmbvu4Z3TM1Cu1J8AUmVGu0YIq9Kn8uoQ3M8asQB547Bjlu5ixibw3SxnMjlW3WOhXo1rr8JmUC3MIjYAzvlDifVN7/349JfMA0T0J/OJTS9RpUrgigpFpgiFVSSviCo7OYWy+lzIGW0o2yHDokFA5dpBTeLqIGC++SqI2iTQMMRY97KYnMqX6k/QRymv5nDRE2EZKt26IzdVdv36qutoGGy9OZNcXVmnN9qD59Ddmfucg3oGXZ7V+ZPq6l2jryeJfUqMsIC31Srk0Aek/7dGJWy9VDMll+uFB6Tawh+dm9c950fTQ/jwyTQ3kZKlL+OOqcrwjzVgInRt+j+EvfZE8LyVg0+WYQ8d7ObL6rB/6WSIAs7tYOrY2q8Q2TbZaj6DtroV87CTpGUTEJ1O2yNfqL85muUUWXWuhUtRSUrYdI1tlkfyr+SyIxpU40vjnedU3CgfzgOhJl+ZyeePMdZRgdnuob9K8fbodgDkzhAp8UnRcSU0SMNrjzAuATb2izj5yoqDdzAWQdZumokzvygyyfPhl0hMJv6WehS+Muls+UPhO4oVrwlI0W/vcwYwD8n090vh7rrqFY85gJSI5xdJBwGnWBzo2BKTEGgx56ffvuaoaV245KPhsufy+kNkg0I6M1IBpb8aLV
 ngt505CT
 KFz5av0SDZQ2l0QBkVXlWSI1WT0vx0TXcec98WB3F1bnI3Rff0H2cg2QZCFZMcgHS0bfrQ2vmDw32UrVLuDmQUckrvbCwNqVBrCtGHfI5dDEXuT3tLTfgjTES2O+XiTs72xlV4/3XU/M/m5jKRgcQ+jXQMCY0VVVqxp1F7ULLaG7aaWfBoJPRPmZDa4RIzmM+MXEZ9ARGTvp7wESc9Y4xfqfS9Rdgqg1xXkV10jq+zS1yfa8jCuD08JkNw/Nv+cO9Zphtp8y3QpiUST8/e6EuNw62uPNQ1aDomumckDhO+abvDqeqSu6HECTgMqY3Jm2qoUs1hs2gl6T9PYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 16:33, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 02:55:15AM +0800, Kairui Song via B4 Relay wrote:
>> From: Kairui Song <kasong@tencent.com>
>>
>> A folio in the swap cache cannot be split if it has a mapping (shmem).
>> The split code does a defensive check for this in
>> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
>> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
>> rejects the split and returns -EINVAL without unfreezing the folio or
>> restoring the counters. That error path is buggy: if it is ever taken,
>> it leaves the folio frozen and stuck, skews the counters, and fires
>> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
> 
> If you are going to repost this, could you make "This error path is
> buggy" a new paragraph?
> 
>>
>> Check for this case up front in folio_check_splittable and return
>> -EBUSY before any state is modified, so the split routine always backs
>> out cleanly.
>>
>> Also fix a bracket style issue that checkpatch.pl keeps complaining
>> about.
>>
>> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
>> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
> 
> This is inert bug, right? I don't think we want the commit to be
> backported. I expect stable machinery to pick it up based on Fixes.
> 
> Is there a way to express "not stable material" while keeping Fixes: in
> place?
In mm, stable never picks stuff up automatically.

it's usually best to write in the patch description why the decision was made
that it should or should not be, stable material.

-- 
Cheers,

David

