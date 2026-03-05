Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8AFF33A75
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57B66B0088; Thu,  5 Mar 2026 09:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB4A6B0089; Thu,  5 Mar 2026 09:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9A06B008C; Thu,  5 Mar 2026 09:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDC376B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:51:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65F4616015C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:51:22 +0000 (UTC)
X-FDA: 84512297604.12.26985F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9299DC0002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:51:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772722280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/w8TcpKcTnsFexEJat+yvEFtYbwnKnSmrwKbNj1qvfE=;
	b=1S0HpCw8GgDtH9nUZaSq8FEo5IwGhWs8k+3FUWxcp1APZsAZGXaIqwfUj/xcrptej4hDsi
	1ju1sW7KgnESNUS/uhXP9/kuscO5EAb/rNIU/FF38cuBowlB3IcLKN18ENC57TVNVsN20Q
	B9gmBDfmDttQTSAxXcpnwzveWLYHU8Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772722280; a=rsa-sha256;
	cv=none;
	b=tVKf2PPP060/RIWO+0P9n1G/D7ejpIjBSsxbpvCf5ijiK9s+kRlVj3YEjkWpymW7GFhkmo
	1idGNM6bOdvQ6AulaByQLG6YfxohWcJ2wLFRTp0jjZm1odrUAptmR66EFSbsZ02+ectsBO
	TluHybEnGPfYu86iTeGad5BAx9FsuEA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C8BB339;
	Thu,  5 Mar 2026 06:51:11 -0800 (PST)
Received: from [10.43.18.28] (e126510-lin.lund.arm.com [10.43.18.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8559A3F694;
	Thu,  5 Mar 2026 06:51:09 -0800 (PST)
Message-ID: <daac1fce-e3a1-4be3-a016-ca0fcfc5f851@arm.com>
Date: Thu, 5 Mar 2026 15:51:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9299DC0002
X-Stat-Signature: cwk7xa6unci47fehpk6h57wwhqs374ay
X-Rspam-User: 
X-HE-Tag: 1772722278-14582
X-HE-Meta: U2FsdGVkX187pAtIvmeIAe3UAtZfO61IqRMNnp6lDutTh/K7X58pubduKJBeGaOE2A8O9muOpy47KN8fBkzTswUKvQLCuBr3Dcz+ql6qGH9LAwp+GH0Uyvgkm6mk7z3u+MuwkZpAWcPISH3ficoK00Gb4W9JmnbmeAWizagrb9LdjH64GT6LyxgIfcmB7MUyhGa/zXEPjVH7l9x3oC882Ap2J4+wJXgybZH/Ug5nciD9e59hQmlrMklYjpFgPMRfpGjamsee4lF4oLi6TRafThpy6tQ3nINa4gsnNaWLcQ6Jdp6OMyep5S89uIRi+Vbov/XN2JnDVWMhtJpDnIrdT2YhB8oZg8yTQzjuHkP9AVz3j5187GQF7eLnUNPJcwAzLSq/vnGP8uyHG4YqIfBTzk21ujWAEDwbu3NZ8NXHykBN48iieQyPoGunQs1tBoomzW8H7uRhO2sgj9zMZORpklsfBe7w5sTNwDCG+VRDNRhglkwqt1lnQlNWJHJAdTg0BlBoZxf5Fuh6TgW4qjpoENLox9QXEUQAejohxAeqVpJJXTimacz0BYs7iIwzJNQO3gVBXiqxoCLdrHNrn+r3BvoIBNeSS3OKzpE8CH8w/cmwNRUXsOEBd4i7Avuu8T4D1ObbCDgfRmgA5oUrXQsnyek6707xehuG/1AuTUVJHIJXcugaO2RBSToClE3cbKKAHt5iPZvGwLHhtA8Qy/pALEjZLuZH7imcfjMGRApGwN3YReJ6anvVBjC38lzFH3HANq1dd2cLlvNKahCoA0BX+5X1qsxNSUehO8NoZb2Ja+ruUoYsn9Br2HlX3CocotnTaZc5p5GcMv6T8kkoIz479OYki+Hi2D72RTFBHgF48qBYVJ8qX2qwEOQx1cPPyvpSdzQyB7dcTv5CbRpAqk/Zj39Npgr47c11P5Z3oy2m86Ps4De1gHiN2buEs9wlCbSsw+/Lo7sZdx2VkkLC5dr
 Phm06kSU
 JMdmCuF+zF9hUBsdlEgMc3ekt1EIWb54eP339+2qb/DyFr0/iODHZ5pH6LaKIyv0p15erPZtthXjReflVt0ItE8V0ZQw3klIkgaVcVFpu9MUtFuQOMoe29ufBoO4NRVfVoKcgc0gFQmrrT2DWdhA391O9747GsdovaabJNBlKkkxEVcIgXncUAResrKlAriLpdmFytLMe1KEmSZrD5QnvysuWVtXH1ei3Vm3gKFgc0ghHKbf/PNg046w3E6DTXvPu4tc+Ww9v9EoANgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/02/2026 17:34, Brendan Jackman wrote:
> .:::: Design: Introducing "freetypes"
>
> The biggest challenge for efficiently getting stuff out of the direct
> map is TLB flushing. Pushing this problem into the page allocator turns
> out to enable amortising that flush cost into almost nothing. The core
> idea is to have pools of already-unmapped pages. We'd like those pages
> to be physically contiguous so they don't unduly fragment the pagetables
> around them, and we'd like to be able to efficiently look up these
> already-unmapped pages during allocation. The page allocator already has
> deeply-ingrained functionality for physically grouping pages by a
> certain attribute, and then indexing free pages by that attribute, this
> mechanism is: migratetypes.
>
> So basically, this series extends the concepts of migratetypes in the
> allocator so that as well as just representing mobility, they can
> represent other properties of the page too. (Actually, migratetypes are
> already sort of overloaded, but the main extension is to be able to
> represent _orthogonal_ properties). In order to avoid further
> overloading the concept of a migratetype, this extension is done by
> adding a new concept on top of migratetype: the _freetype_. A freetype
> is basically just a migratetype plus some flags, and it replaces
> migratetypes wherever the latter is currently used as to index free
> pages.
>
> The first freetype flag is then added, which marks the pages it indexes
> as being absent from the direct map. This is then used to implement the
> new __GFP_UNMAPPED flag, which allocates pages from pageblocks that have
> the new flag, or unmaps pages if no existing ones are already available.

This approach seems very interesting to me, and I wonder if it could be
applied to another use-case.

I am working on a security feature to protect page table pages (PTPs)
using pkeys [1]. This relies on all PTPs being mapped with a specific
pkey (in the direct map). That requires changing a mapping attribute
rather than making it invalid, but AFAICT this is essentially the same
problem as the one you're trying to solve.

There are however extra challenges with mapping PTPs with special
attributes. The main one, which you mention in patch 17, is that
splitting the direct map may require allocating PTPs, which may lead to
recursion.

[1] introduces a dedicated page table allocator on top of the buddy
allocator, which attempts to cache PMD-sized blocks if possible. It
ensures that no recursion occurs by using a special flag when allocating
PTPs while splitting the direct map, and keeping a reserve of pages
specifically for that situation (patch 15 and 24). There is also special
handling for early page tables (essentially keeping track of them and
setting their pkey once we can split the direct map).

Do you think that this freetype infrastructure could be used for that
purpose, instead of introducing a layer on top of the buddy allocator? I
expect that much of the special handling for allocating PTPs can be kept
separate. Ensuring that protected pages are always available to split
the direct map may be difficult though... This is deeply embedded in the
allocator I proposed.

- Kevin

[1]
https://lore.kernel.org/linux-hardening/20260227175518.3728055-1-kevin.brodsky@arm.com/


