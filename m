Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5F0C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 20:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025036B0088; Thu, 27 Aug 2026 16:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19006B008A; Thu, 27 Aug 2026 16:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E078F6B008C; Thu, 27 Aug 2026 16:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBB486B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:23:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 487C14018F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:23:09 +0000 (UTC)
X-FDA: 85148173698.15.8BCDA6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2A03A4000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGxWQLRB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787862186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjanLRpIWvJ0YaQezIW8S6gqVSS4etNpFvTBJ8O4/5w=;
	b=YIAZe+A1NwDPWWXV7MWNsYsfdDuJPv5XY0rg5nxT6wX7vSFkET5Eia2tisy+9MAazuLoTb
	7aREKcvcgGo2y12MetUBgHVTQUXusn0YCJBd0teo8+BYrgCGmxWDpAzKf+aIvjhKiDEiQ8
	wE1gh3Me05rNK8mJ/oQouyjum2TvTp0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGxWQLRB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787862186;
	b=U+Mk4hyMP8Clej2quqMXFkKGVdArqmaDwvsMax5YzvQ7lpECNk1OgHGJTnyYRkIRJUTGkG
	7dzZBd1xqzRc/+4vIU4dm5SYbFkRdQcKsR+SXDqyqUI7l3JIVFsazN49C3wQ/in57aGREx
	TFw7eldL5UJWBpCgffMbierr8hn9zq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC8054118A;
	Thu, 27 Aug 2026 20:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C30F1F000E9;
	Thu, 27 Aug 2026 20:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787862184;
	bh=LjanLRpIWvJ0YaQezIW8S6gqVSS4etNpFvTBJ8O4/5w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XGxWQLRBPbFyXyxR+HgbW8owHBHKpnIOupar9wq1mXEQWUONYBBEG8foUMl0e8A6s
	 CIafrK93qKMBzvox5vqHxJtUSsQ/ROrT3Ja80Pk8N3+Z1tQnt3Rh3jZjNFEN+kF5A8
	 4sLklsJl2vPKDji7w33lAWc9Dm/vXNDVOQVAp6pcmo64sfKOpGLXdsiIC4dNzFui6k
	 bf8JEZFsGRL8mw8p8q/DhfioTXdyW9k+k9Pyi125DK8pMwx4Q+dOn7XpyFSTOgwJR2
	 h/fgTa1dyAnJLPatj+i7d/FwKX1P6mtsfDbZHjGtAXPBxxuzx2Bfj5T3NM8vamYGWj
	 w0PUO8NLzPt7g==
Message-ID: <79aaca61-4e4d-4f1c-9492-41b00bf6ff04@kernel.org>
Date: Thu, 27 Aug 2026 22:22:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/18] mm/huge_memory: lift order-0 restriction for
 swapcache split
To: Kairui Song <ryncsn@gmail.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com>
 <ba386e23-1b05-4897-98b0-ced78df6dc25@kernel.org>
 <CAMgjq7Dg5pf_MR=C_KqixYmyfXyD3UpKoR_6aO=aBpZsY4yJEA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7Dg5pf_MR=C_KqixYmyfXyD3UpKoR_6aO=aBpZsY4yJEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: stw87ssqo94wbmrh1e546rjw4efq8w7n
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A03A4000B
X-Rspam-User: 
X-HE-Tag: 1787862186-316030
X-HE-Meta: U2FsdGVkX19Cygk1Rim32NV2KnsZxPbcIG5GptUJReWgvB/KrLdgScDlStKGZo1qvbRxPhUv3ZolRlZ8FDrQvUzovyA/dSYBpeFi5e/w/c2MqUEAxrlyHVgWVG33cztnBsyAUvggCC3IdkIkqFCi/USG2ktoco/3vXiPJroD9uq2UKEuRLs6gAqmOlwr9qpVv1+V0rtLbIjewkmUVfgLkACaauV5WF2v4hjJBLVd5oueHeKQzPxfzodwDZQj36nVlZ4NQxUn0NMw2+OpJH9H0+UUyF5kKLTgU/6xl1wVNupW/P2A1r9tQ1k/lPy1iVCSDhfCSQFB3MZ9xoXSvQulGmeFixHZDWtxL8mNuh+iMorqVWiPJJZjOzVldTtrvVi7Lv4pMplZa8yet3YoR4TVeyrPwjHZ+gMgYaosmSoyATDj3t5BRZmTyYb7ji/hGuXlfIifBFs0L4k0W1bFqtxfNk0TSuaWoCPKY6psWC206xBP49PZChjtaAWZB5QUyRCOUghK+kLwVZbao7MK6p7GmLJk8WEfwcyJFHDNwh9hlC8t21fBdhjEDIwZ65ooeGh48N1TCX2vwntFbzg9JW/4nWJdZ4NVZ6kwzKVeCOu1RrEgnRVMNrWOo+RvfCxG7Gn35jC8Q3WLDESmTemSuPZ251RM1oJyZObJR7CBej7MjiNW8N2SHRXw17FxJCWl65e0UaiczTKL4vzfFsUWJJHP2ycLonL53ny793qnA8y/QfuOnDpIF+ZP8FFDnQVBZdQy6NExFGDEZWB0lb+eUN3e5ey3WsJvYFACMjI2grz4enueiM2PFnBkXYMauQ7D05LgT5qZtH/Yzsz78wiMhPP456qJzW1RlgUgQBiEsxp3Q7nbzk120bzR3ijX7HA710UQvY5TKcecYnkTbJlfQ4NWa2RXYXny6rhNsN18rXIRNoOitDFlc/CUDxM7yWBaWabnTj+myLINtF3NrpRg/Bp
 3UXN4dJx
 8HUbcKHZUIKwhj92fq3Cr1lCddTI5CL2Yz4Cldhrq9aI+bq6PRA4Wnjq1vojKXOekWVWAPcxK5BImRLnDPp5iBQ6JyPtXnpkfgROOUOq+L3p1X+2mYLrCm744iXsyE25oA171mL5ozN+pbpN0yI8RRgePO0PXTBccKyuOy39JvPDNpM7njcFtxGNjyhqAmCjafGkrw/3T6i+ew5plOxm3o55TyvPsFQE1zC2xfO9KGAw53B6nYRRo21w/aVyS9mdQc1hg6/bGbacN7nRYkeW7vsrldYfEvq+rMi+4ljFj+QTdCrzaxNqM89UV3v8hgJTFv4vdipuqUcq3h1+Z/VVmnnSoE5sgoDiKmTl3/5JZ7QI3eZzb7RSMV1LGfNgH6R9KxhEMkt+3P40vRGzsXOgG8/Bkzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 19:48, Kairui Song wrote:
> On Fri, Aug 28, 2026 at 12:51 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The restriction that swapcache folios can only be uniformly split to
>>> order 0 dates back to when the swap cache was managed via address_space
>>> mapping (swap_address_space).  The old split loop only created order-0
>>> sub-folios with a fixed stride, so non-uniform split and non-zero order
>>> were rightfully blocked.
>>>
>>> After the swap cache switched to swap table under a cluster lock,
>>> __swap_cache_replace_folio already gained the ability to replace any
>>> number of entries for any sub-folio size in one cluster, and the old
>>> swap_address_space locking and limit was removed. The restriction
>>> became obsolete but persisted through multiple refactorings.
>>>
>>> Drop it now: swapcache folios can be split to any supported order with
>>> either uniform or non-uniform split, except order-1 which is not
>>> supported for anon folios. Mappingless swap cache folios could be either
>>> anon or shmem, so for now we just simply forbid order-1 for all swapcache.
>>>
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>> In contrast to the other cleanup patches, this patch changes behavior.
>>
>> I would suggest to send all cleanups first, and send this out separately, such
>> that it gets proper attention and doesn't get buried in a sequence of
>> harmlessly-looking cleanups :)
> 
> No problem, send this later then :)

On second thought, the

"mm/huge_memory: allow splitting mappingless swap cache folios"

is already such a change. And I guess only having both these behavior-changing
things separated from the cleanups might be harder, right?

-- 
Cheers,

David

