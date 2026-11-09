Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D63606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AN+9b0iy
Received: by kanga.kvack.org (Postfix)
	id 3724E6B05B4; Mon,  9 Nov 2026 09:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349606B05B5; Mon,  9 Nov 2026 09:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286916B05BC; Mon,  9 Nov 2026 09:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05B496B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:27:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 813D7806C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:27:50 +0000 (UTC)
X-FDA: 85415809500.27.8EEA248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D67C514000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:27:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AN+9b0iy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794234469;
	b=PJfZ+IJhFhUt70wHRpQhKj5yL6tNuZnrP/eetN8TrStn5B0N4ZFUcwTFI3SOB44wddFTXx
	gVCzX5Cia9iLoRQ7QL4R3QWD4Jc237P7RqHmLF4CJgZbBbx3iKFlcMSlLTazxA/nmujbqZ
	4k/v1jZa3Hz6PkToon6aUpuh7Si7B9I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AN+9b0iy;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794234469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JV2g1MGII6AONd0SSqvxC6iZBiQWfA6j1ds9TAhkTTk=;
	b=qzSY8WbIw6+4PRmX/jmRdcm33XYG8wp9h+mPRlwBbyUp+p9TJ7Y4c++/4AOg+8eS8VovAP
	7H1Fi/az6pGcaCbCL0V2CGBr2LeW8++UEYOHgQ3EECkGt5R61xXEdqfCHqbofjgj3EQZYC
	f0yoLffumR0xheFmtXp7zR74Wrsd9tA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 341A045935;
	Mon,  9 Nov 2026 14:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0751F0089F;
	Mon,  9 Nov 2026 14:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234468;
	bh=JV2g1MGII6AONd0SSqvxC6iZBiQWfA6j1ds9TAhkTTk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AN+9b0iymNq3EFk/OjlrnobBewX4SeN8Cnv0ZcRTv20c+YxXZACx1+E2hEhEPIIhc
	 4WMrsQYpnJQEM688BOC9by03rPF2l4Pdlx8tgyPC0gzLhynRlDXLLs9JKvfY2Uyqmw
	 6JIV8V7Chmefg3Lnu8h4rs5048dpwR8xHPMrJmoK4SBrLBefLW/wbMsa0PoXU5+ym4
	 l/Nf6NQVS4ogUssygSp6MbLssLWM06crHDyrK1eeheTrX11JC9AjxvE5rwPb3qFAMU
	 hMxETBoWsuEe9xUkJz7963k1hNkAXjmEEFgT6UL7be9pnO77OHYw4/QM9PYHoLmUFT
	 1dazOiMaxGeig==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
References: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: free unused page table allocated by
 do_set_pmd()
Message-Id: <179423446371.18983.12929879882545410707.b4-ty@b4>
Date: Mon, 09 Nov 2026 15:27:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 5xuibok38fgqeayqfhhhg3dh85tt54y8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D67C514000E
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794234468-318743
X-HE-Meta: U2FsdGVkX1/D5VMTALALY+i2H8N1FLq6iRRKwfkYh57Pu9LIfcniQtdCnuPzEAeNvhRiL3S97JG4EimdUoGV9FNMBBbB7ges2JMZLOXfswMnJX9JSEVZKnbOil8IM/bjJLK93NE5R+4334BK3y2XLp3sbJDuyGNNd9+ZC3ksK1hGj22YokRR1dClJTj8mLn0rbeZjBZx3tR2NMC7AZjkUPyGU8ybXY+Q9toSNCjizemqAvKw7aALx3Az+nCyD1RcDSBttet+OTqSRzGFlM76jl48cfWFwJn9yCKgXYTxRFZK8lbv+GgIKCQeEr7LolVQA3Bwnxodds+v5X9rMUHBQ/3Zp2b8RM0rmuGVim92I1FQ7w/RqUB7x/u5XDs+p+ePulxCSz/jcFxhQ+X7s2543kAiR9aLA7V5ey7zh830HumLjHQTkhB9l15NnfI/0aGxrtBwJV2wj/6o/d5GH5fWIMPtWYSze/AyViBTRdW3sJnkLmFqf7tNZRJPPRcmvAH6gn0ZHA1L0rPKxtWjM7jq5z9KzAiIm0FEii+CBNdIymJr9tAKbuvomcjqeEBeSZpHgJj8RnzRL1BTMfjLDYLXUH22iThEcKGla2XTnnfDu/CwIScrb4T+14W0QlMXePePY9blX+4M3zUS8nGatoRzlwNQxDfcq9m0gxtu1iG6bHWpQSi4Q2wo80oE1hyX65k9LqtnI8F0kL+I99pB3qgnq9hdtObDjI/GXM7z2cDKbteszdSpKer4d97PxWxR5o8jTMDN6f/NgzTbRZvWVwFzDoA54gi7rP++/tCIN0b0YuNqte18kdwPhuRM9awaPDpnRTgnXPSlaYPI+dYPG4IKlIakPKe7Yb99W8SMZs0u1f5DQCBTru3hkoPFkYyLmhCBGnjLmquRbNX6g9apsIPHvNocwMnF6Dv+SaoWbo4k2lixrt/8ZaN5pq99Poh+/aCZ4NPCS3hHadsKt/cVqEL
 YkmtI7gR
 y44j/az0f4sdbgrB9Ef0/D1YDCn4HJ7iUao2BlCkA/jersezgC9zmdM9igIrSmDrp6LB87wUPrHRi0UWBw4QJkrGG286ez8+R+4Vd1yJn+yqf2/LLEogNQJO08T9odQGGWnhP/baEIZF2RtWLhGpMPJr5raE9Z2CmhEJ9Q7IURVMX7CtR8lZLZQ6tz5dJkptQgPe2KpsYhhLRkWmuJolDo4O6/nmu5CyYQPl7PKJvBV/9Ucrv0EyYjtybQpuX+JxIjTPuyBB9qtY3J9+JgVVFhve0VJueJS62QBym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 13:36:11 +0100, David Hildenbrand (Arm) wrote:
> This isn't super urgent, so it can wait for 7.5.

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm: free unused page table allocated by do_set_pmd()
      https://git.kernel.org/mm/core/c/e5111d38
[2/2] mm: don't allocate a page table under RCU in do_set_pmd()
      https://git.kernel.org/mm/core/c/bd4d4f8d

-- 
Cheers,

David


