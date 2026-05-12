Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411F9CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFF76B0088; Tue, 12 May 2026 04:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0326B008A; Tue, 12 May 2026 04:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F5D6B008C; Tue, 12 May 2026 04:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5869E6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:52:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 092561A03CC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:52:02 +0000 (UTC)
X-FDA: 84758150484.24.CE4D3F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2FDC840013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:52:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXnwiJZe;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=123Ndpn9usB/fj80V/gGvMswDkYDBrGca0qJpzvvx/A=;
	b=xk+OoqSHZW8uvmxeSAmdNs+PhOf6y3WLnUnBCoqr9JyYZuRJOVYGccneibVzAXSqz41iVA
	TEG5g/rucSfkwAeLK9mTseAyJzcH0efj2EWnC/G7gbcKBdIh6++6HXjoQvyN06uaAAILOC
	KGJn0Ev4m9DWBpy0JUEvd32W8zJVGfk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXnwiJZe;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575920; a=rsa-sha256;
	cv=none;
	b=8pSS4wSyx2k80sE5x8Rp0DaT6NLM5F5Q9BMJMj0tw2HBYaWO2ZaJJNdRY7P3kUpHIW/fdN
	sfj73/29tzi/FipxDveK2KrmOAKCl7xf49dmDr0O7+mYL7I30OQbO5iEjcE/ld7P3kSS91
	+hRGP29Cx4/ou/iKI2ooXMVUZNQbwjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3551041721;
	Tue, 12 May 2026 08:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C458C2BCB8;
	Tue, 12 May 2026 08:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778575919;
	bh=8kkUYwgGflfxYAXUpjpPomPnxblGEVzpqXI2HInpT68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iXnwiJZeM/RS29oCQlPf5nX4nxFha2hJZIb0XFte7bpFVx2elbJJoheHEzVPJxkFb
	 TqUdOFywJqqqGUDoQA6Wkl4pEdLNL+jdbP46ee692tBJU0LAxde/x80sgpCWu2nucf
	 +48/JRBUdVsAoj/+5i3ZXVnGxrHih7As30BZIGs4lTRaiBOvDDkUXceU2BFXEfHqi0
	 uJwE3Pr61euYVS/WmDaLrbqdwcNCWCMAMShh7djh/Q5QKk1oSroyTEQkjB+MeccMKv
	 L3Is85duQwVuakH+LKH8lB6PeIXxeBCxTRgg1lEZPOn3cnKiF4/fLfBDXY7aRr2OwT
	 DSS9QISwm9ZEg==
Message-ID: <b80eb915-9d50-4eb0-b72d-a16664fd74e1@kernel.org>
Date: Tue, 12 May 2026 10:51:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)
To: Oscar Salvador <osalvador@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <agLolRUSzT9gnMZn@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agLolRUSzT9gnMZn@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ifwfneboi8wrfkpjy7qkw13hkw4dxx4x
X-Rspamd-Queue-Id: 2FDC840013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778575920-874954
X-HE-Meta: U2FsdGVkX18QwED7/7Unnnp3ezBXxYeyVbLOv39Rd5qdfyIIQa3QPFAyQA1WD45JeE+Mz52IsSG7s8ltAecn+7GFV0F3MPX2F6L+Bf73c5grJwdcfg2AYLg9Utte2NN+P9syIRJQ/nIre0fJe5EXUcPTVUNKSkuZJBel4SyK+wR2b8DFY+LLq8v5grPBcCro2K1q+GUWbqX9Q/F6z+tYzabZvTM7YmDKC3zNWqntViRA3oNWZxUiZkVsG/8LwkP+B0eNpSKg438mI5slKOvKxkeRfTc5wz8r5z5wxfuPF6o9f3Z3eweFb07Nc3/foXBqD4pP9UueZUS5tpFPijwpiOW3SMnl4nnSeuUeN8O5V13ocMh2hRZGa3LAsn8wwbL8LhJO6TnEFWWEtgEdaKKzAPm9GBLrONJJccsIZaHlioyKXeOO8BFx7AvDPKNukBWI6tMk9BwbFaAssOfW9APmnD1/cKpyI6tSbYbyM+s1BOm4vQxsWvfx+SzOFE5Yeo4g2ZxU/jw3xk3iB9wjhLnslEBSgJRmJm9q95vy9KneWtoiagxrUVlMi3Yv4kC8r32XODTFJX2bnp8JC+V+TaugNnIDpqNac46qMXH716fUV8YN9svmbDUogwmrjqy7Tg6Pcfld+P2jaBvvFwmGUntxbY0NKo9mhwNkWoWFrB+5o05+Ed2Xv38wiWksCgJW7L9r2Kh41phvEt7V8bbvaBZLpo9Rw1akyecqo9hIZXjQ8f2swARreVkNkYiEeLcnnJg2ipAUbGkvDWaPtFvD7BIZXLQa2sgI4qNBqdEdAypDc4WzWsKipvA08wCGUREqAQRPvRZoLxX7bBrFwsRt1XXxns8SQWvGBCr8gg8TdXMFtfIRct/ocjVxC6p2UaR/AkA8YxL4H1nGvLvZc5rZkSApJrdkPQ0VFAvD/d8KEgL0udNUOIRw2eTBfGHRiHwVo5G0S0nzNRIEl9/s+W1ZzYv
 Cwwd3E3+
 p9oEzqPjiuX8SzLrygveeZQuK/UoT9fUxfdg/n7qFcuFiiJxoP9stPiNw80xCbv7+7eSIzjTskjqm+S+kKW82gfXrW2iWDZ0gE748nNvIts6fVTp/PUX+7uA2BmMuYP8eTDTWUS/FWHMh6EkJ1p1bMixm2RTSipkxcXl6r+K6f18+B7Tpx8lfPD56umJn83PlqI8NGGWm5eGUxP0j3MOxxzan44JOOcYYrt/LfoJ9v/7rY76jdjc5cifwpU/zt5I613HwjYrD7f3OXXgKwtCuj9aWABjRfQTKrQxMPl7/8CK4EM/C+PHvS7F9zh8OwDoeFq/XwVpCpjZrvaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 10:45, Oscar Salvador wrote:
> On Mon, May 11, 2026 at 04:05:28PM +0200, David Hildenbrand (Arm) wrote:
>> We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE. As a first step,
>> let's limit the remaining harm to x86 and core code, removing
>> sparc, ppc and s390 leftovers, starting the stepwise removal by removing
>> and simplifying some code.
>>
>> Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
>> remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.
>>
>> Tested on x86-64 with hugetlb vmemmap optimization in combination with
>> KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
>> remove the vmemmap pages from kmemleak in put_page_bootmem") does not
>> reappear -- hoping I managed to trigger the original problem.
>>
>> Heavily cross-compiled, but let's let build bots run on it for a bit.
>>
>> [1] https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org 
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Awesome cleanup David, thanks for doing this ;-)

Thanks for the review, I'm sure you'll enjoy part 2 :)

-- 
Cheers,

David

