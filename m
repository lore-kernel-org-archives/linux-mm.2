Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C13E9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFD66B0005; Wed, 11 Feb 2026 08:25:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73D06B0089; Wed, 11 Feb 2026 08:25:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954FD6B008A; Wed, 11 Feb 2026 08:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83F856B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:25:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E7AD696B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:25:34 +0000 (UTC)
X-FDA: 84432247788.04.F2F14C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EEC2100009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:25:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IY1BLjfx;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770816332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PIwUSQnjigR7OzC+8/roaEtOWyhHvSG2Ks4ERE2LUI=;
	b=fVWG/NzBRXocwysHhcXVe8o4D/HbU+VrDAgv5qZrlG5E9bez4R3AqtKB2AS8TUURpdroQ8
	SVqN7+UMgfvJzG1yPJk+emjnV5E5V77BgP1Nj70sVsMPDd+8+tRrURAsvGs+vpaB7R14H8
	AbKqF759e/S8o1qWSGd4Km7lOMg200U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770816332; a=rsa-sha256;
	cv=none;
	b=FQG0Uw9Hs8uPyeWDpGfAClKcVppwhoKaJN5jFp7V115F6dC9zOQGpXBGnCoq530xloKxdu
	1iyLss95M127JVsaqQorQtfzquX+9VCZu7ztDIkhxPb9cIUg5y2teFJUYIIHrV1YxxrC6V
	yl24y311V0ReUMlxe8ZN6JKOZqxeRFA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IY1BLjfx;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAC5E43842;
	Wed, 11 Feb 2026 13:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A817C4CEF7;
	Wed, 11 Feb 2026 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770816330;
	bh=8bP6jIC/KRpZ5dRqDOGx3ic6z30NOvMZ0jo3/v/qgNo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IY1BLjfxsgjinT3MEUNF7AFOKffzITdIZjopxTyKR6rQR70TxHPeohVo/zmDu3S+D
	 jGJg75qVkd9JA5PGyzxeLus7oPrLKFJZ48dP8de+Z7ZEkhHmvqWpOMLsg45xAY/HV/
	 XLL2W56ya5+sAzctEcRROezBTxi9J8VOP/sMDUDhAQRFP5ZH3k1BnF6hXqk4XCYNeY
	 iy6qNPABWgwNnPUl7XiuZj70VWvAr0UWH0eXl0iDUWkybAzqBX529aglOS6iXAU3/V
	 w3HJztIob+TfOTWk4s4zPrNrvsdFd3O2hVTDRmpqwEtQI80foZrUxJRNPa0JuVahi5
	 E7kBwyvLbcfHA==
Message-ID: <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
Date: Wed, 11 Feb 2026 14:25:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211125507.4175026-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EEC2100009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4k5s845emqdnngthwc1z34ng49rrkozs
X-HE-Tag: 1770816331-181636
X-HE-Meta: U2FsdGVkX18UNLtJMMvCUtsz+wijMXwuzV7Szp5wfmj5k+8LyBRhbMS7iax7kBnGPStsbjxxNTpjEeSziWAUOh/jiaLVyj750BQoqMsYBEgVEmm40UGDBQ7zAHXcTBKM+dTHBQuQteo+uenE0vaCVE/seQk1JhWHGhtk/eBjpBiMH/+Ey6rKp5M+0aYg2nTxcoMdHd4V3SKYQQjED4OgnxBdL64tY/Rzw83x4tdZ+KcAwYhJ1eG6uCtMR/02aQnMGcO7qK/2EnKW/5NonzFfBBjhgNDoQRWm6CkT7LHAh+6XJk/Ir8a3C+IjhcbKJUD1xch9pivdTUn32Dx2NJeLlFZxIGXs/ZvKcXkZw/uSJQHxaPp2v9I9Y2zF2PbVGau/+o9aKH7XSzL10ubaD9cGtHrYLSBf9Wd4OZ8DURIznt9zl2K3m4YFRcprq4LmTNzhueL05Af1gi/lSa9VeylJe2AJwAwiCltfCL8LRgHBY3oAanyYQPCFmWZRrmZyYSyugICLxvHL+ZSNiyIEUp4jLKfF/PqmLk6szzIV/tYFOC7mWh0uAb1fDdZNPgcQ3rArjgMk6o6Ati7s42Mr8scWetSwxwutqKAOIHnuhdx5y71T4YT4gSsASZFuevupK74kGwOvs5IwqIv3k2pQJWECDVb2QdLqy6eWkOO5AuOwtUhgSz+M/vyygoMIieM5Z8ASYj4JUMv9VIW8TC/5TcthOuCJYWHR2rGxTYrHBUwYPR/wZ/YFF/5D7RZghZ9mw6kA9CsP9DaCOVv1z3WRe+fQPgGQzn/jXrc1rL6SrC6lQwF6YlkUNQoP6corXS4roySVE7XiTpLX68J0ZGQu/Ul45OeOlDsbxXnooRki3685MyppMTnztte1fCXeZJ4kdVAuAynimFUWzdUGjUuNV+jqUsb89QgB8+manoEDymG6pYvvQYa4l1wOpO2i1WedqnTtGs5Rq5ZmcQKqdN/Lyev
 7wqBcOiD
 NB9phEg8VxJwQJ8vXbZingBB1JaGE5YPB0unBLoQFeQmiKHXp8IQ6NOdl/OfQWbPStDoyZ2R/XZzXqIW5ugy5knpkp92SgIakaGH7Lo8QRFcPkt0UDTEO746KWJzBrZEkX+Ru6fLQuLo2CGo99GIIswWX6iHyKA4pbyV8Se/PLLwloR3u3udZ65YSiFH/JMZVU0+Xj4SB0Gi4SjHTColvZE0D1ZJ+Z+OnEw8b29XnqEJbPbNzzgsrbdEdfXrufCgyVuTC2Zr8Wo8QXXmeX0t/nrAzaUQ/bslI1MjY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CCing ppc folks

On 2/11/26 13:49, Usama Arif wrote:
> When the kernel creates a PMD-level THP mapping for anonymous pages,
> it pre-allocates a PTE page table and deposits it via
> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
> PMD split or zap. The rationale was that split must not fail—if the
> kernel decides to split a THP, it needs a PTE table to populate.
> 
> However, every anon THP wastes 4KB (one page table page) that sits
> unused in the deposit list for the lifetime of the mapping. On systems
> with many THPs, this adds up to significant memory waste. The original
> rationale is also not an issue. It is ok for split to fail, and if the
> kernel can't find an order 0 allocation for split, there are much bigger
> problems. On large servers where you can easily have 100s of GBs of THPs,
> the memory usage for these tables is 200M per 100G. This memory could be
> used for any other usecase, which include allocating the pagetables
> required during split.
> 
> This patch removes the pre-deposit for anonymous pages on architectures
> where arch_needs_pgtable_deposit() returns false (every arch apart from
> powerpc, and only when radix hash tables are not enabled) and allocates
> the PTE table lazily—only when a split actually occurs. The split path
> is modified to accept a caller-provided page table.
> 
> PowerPC exception:
> 
> It would have been great if we can completely remove the pagetable
> deposit code and this commit would mostly have been a code cleanup patch,
> unfortunately PowerPC has hash MMU, it stores hash slot information in
> the deposited page table and pre-deposit is necessary. All deposit/
> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
> behavior is unchanged with this patch. On a better note,
> arch_needs_pgtable_deposit will always evaluate to false at compile time
> on non PowerPC architectures and the pre-deposit code will not be
> compiled in.

Is there a way to remove this? It's always been a confusing hack, now 
it's unpleasant to have around :)

In particular, seeing that radix__pgtable_trans_huge_deposit() just 1:1 
copied generic pgtable_trans_huge_deposit() hurts my belly.


IIUC, hash is mostly used on legacy power systems, radix on newer ones.

So one obvious solution: remove PMD THP support for hash MMUs along with 
all this hacky deposit code.


the "vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()" and similar 
checks need to be wrapped in a reasonable helper and likely this all 
needs to get cleaned up further.

The implementation if the generic pgtable_trans_huge_deposit and the 
radix handlers etc must be removed. If any code would trigger them it 
would be a bug.

If we have to keep this around, pgtable_trans_huge_deposit() should 
likely get renamed to arch_pgtable_trans_huge_deposit() etc, as there 
will not be generic support for it.

-- 
Cheers,

David

