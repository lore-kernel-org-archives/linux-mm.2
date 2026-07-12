Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A90FC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF16C6B0005; Sun, 12 Jul 2026 03:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2206B0088; Sun, 12 Jul 2026 03:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB636B008A; Sun, 12 Jul 2026 03:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCEC6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:20:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 180EA169CE3
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:20:22 +0000 (UTC)
X-FDA: 84979276284.10.3FE9167
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F926C0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:20:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P/xcvQTC";
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783840820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grjb9ebFtPJOuGs5Ha/8LM7ishbheMMgbim5Gam+4Ow=;
	b=z/vwuKv0q4qKyyu5ZePqXFkYDZbSymUqe3E76SrItKbmPlcYefZRScoNtiWWCP5lsK0QLG
	16kZ+3EsI5HwjdGeQLRpl6v50xw9/zLo69r59ycrPaywcrS8lA9RE8Wn1/ZZsSc81rVmRy
	gmgrHC16SSm3T3Y+3yH8TJwRpMmyk2M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="P/xcvQTC";
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783840820;
	b=DJDpHRWl5V3/qkpoCPWpVHiapOhakFzb6zFDMp2bQNalBsVP+Y5CNEWhNY3IkOapoxedKX
	NZu3Or9BRFZBABS0cQ3xACUpxRvTTRcea1xzp1GKi0D/6dMhC/0+2UI+n2f2/50bpat6n1
	Fmwowal21xoUf3A5VV3armv/eHtkjIQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DCEA1682;
	Sun, 12 Jul 2026 00:20:14 -0700 (PDT)
Received: from [10.163.129.143] (unknown [10.163.129.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2294D3F85F;
	Sun, 12 Jul 2026 00:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783840818; bh=twWPQttIw1Mi3lb5FSJdbQL2/I7h0z8qEhsYTcqS75E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P/xcvQTC5mAiu40BmBCx4/5Dhcbd3LRhwZFpTHyQVCTQt5F3q5YIB2yDBqhwKj1lh
	 OXXHbT7wFB2+0H2Ar929JckO06lkGutqMiIu9b9Dox29S7k1YlCb/b/yCweINlvtNG
	 FA1DabFpxNOcoSO5ARxfIYrDFPExBt7RjxmLOASU=
Message-ID: <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
Date: Sun, 12 Jul 2026 12:50:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F926C0002
X-Stat-Signature: oqan5gawja9bkmdnca8bxo18x8hyzys3
X-HE-Tag: 1783840819-35546
X-HE-Meta: U2FsdGVkX18Y1ZOlpXenm4Zsa5CWrycOYH4EBRP747mjE9VTQrd4A+6G6h+DdDjLgc3t0SDzHiU2z6gUgd8uWHWXX90K0LFGeBUxyk1Ez6EhIj2QPv7B+AlM7uhbhSXPv9kb7fQ1s4kdFNsJNFUtsLx/SXllj6am75AOJrQ4g+BmwfE2H/602XNeD+xi8eOafoVM84zaNUl9b1F+S6C95tpRHrvhxetxKCk+7osZ4/ZY1ZRkfZYbeIM9td50dRRIeeQ5DXKugK3Xn+LHmAfJw/Y8lZJFNIS4tEz/1jLj1DTrf2FdQ4X0b/14MsTl+LuD/vuvuWH9p5gnNgC4SwVBoCXdBkYEtIyXbp5XDJSxsXqlQOR81qYC19tM6hAStdva//wXQwnDpx8pldCETjqnLU3tD3uu2+bkPk16+yBiIGfrW+o6S3KmZGjNu9dyTNzHL7oqOnjB7MinupYfiWHgwjxnc+xwEsV1fO6JWBFS7gBMB+wYOUs7xNPDOOIPmVtjHaAEaU0FY6Dwb0aEvMAzDGn7b0vhkxNxz6BZG3FHPl53IJcuFjVwazwXAJ/bro8uxXTxWbiS7C/mm1aN37Yz7ignftrpCdZ6KT6Y2pT4gk25KZ+hQhqocRlyRINP3AUtGaCX0BbAXjcLqPASncdUrNAINJAbki979usX9dey5yQaAcPUYfkwXRYQRGFeMI3KO/5W90fE8KP6wxH+WXXKkTDZOvZ+vaPx4Da97m49YSieStCLm4TXuaMJJnSwb+Ugl6K4P4qtkUG199X6cF4a9BmjZOe67Ttiwc8W5IS9cYe6IndCZj9s2BbG1q8XwDzEXLY+w3nkkSBry+qfblqS6Lfg9PfAokv8ezvgghfBYiQQphd4n8uL8UahvPkIb3YqbNwzOXj69GFmR0+fVlZ11C+A0WnDVojqjhr9HFcNSspqUvS3Lpm5+EbZEhkNI8QH3N0XO6KFvWJwszOLFTj
 fyCUvGS/
 5nS1LvCVoXaCtZRUt7bzFZWeRD00IcYsHUQ8zdnJ3ByReiHb5SuR4r/wkAKlRZKYX9MDbH8Au0+ouYlCDhAyGiKHbghHfZ94psfs7USY3x+koZ3D4guSovcEx2iBxRte8Llfob5CGONQKzPMjMR6ZgGvuAJnaCe7/PkelkR/PvNJPZ34YvpjeHAiMFsIMAaHvfUQd6jBCIHJJ2PInpah5jXOX9gQ1M7zVWB1iOxCPgSLxWPmbxw0mgiFT8CIcXAT0H82JkDIp7uZ189nz6nG/TDocHQFZXKg1QzwMe0zPU37E9VOEo+iIe3F8BHGE0kbGStCA6lIoVP6VJ1RJYprjOYuWE09FRwfcLrqjNIaoTAM6PAAeg4zPssc9SkWCxalcAo6k2XRjBJeSLAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 4:19 pm, Lorenzo Stoakes wrote:
> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
> 
> The former category is used only by arm64 arch code operating on ranges it
> both wholly owns and does not concurrently write.
> 
> The latter category consists of kernel page table walkers operating on
> ranges that are wholly owned (but which need exclusion against concurrent
> writers).
> 
> The lock used for exclusion is the mmap lock, and for kernel ranges this
> the mmap lock on init_mm.
> 
> ptdump is a special case being both the only user of
> walk_page_range_debug(), and the only case in which it walks ranges it does
> not own.
> 
> This presents a problem, as page tables may be freed under ptdump. And
> indeed there is a use-after-free bug in the kernel as a result, which this
> series addresses.
> 
> vmap promotes page tables to huge leaf entries where possible, freeing the
> lower leaf page table when it does. It does this with no meaningful locks
> held against concurrent ptdump walks.
> 
> As a result, use-after-free can currently occur. This series addresses the
> issue by having the vmap huge promotion logic acquire the mmap read lock
> while both setting the huge page table entry and freeing the prior leaf
> page table.
> 
> The ptdump code already acquires the mmap write lock, so by doing so we
> ensure that the ptdump walker only ever observes either the huge page table
> entry or the existing page table entry, and nothing is freed underneath it.
> 
> A mitigation for this issue was already applied for arm64 in commit
> a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
> has to deal with carefully.
> 
> This mitigation resolves the issue by acquiring the mmap read lock on
> init_mm on vmap page table free if a ptdump is in progress.
> 
> However the fix in this series would cause a deadlock if we were to simply
> apply it for arm64 without also reverting the change.
> 
> This is because vmap may acquire the read lock before ptdump attempts to
> acquire the write lock, which then gets queued, and rwsem starvation rules
> mean that the (unacknowledged) nested mmap read lock in the arm64 code
> would also block, meaning the original read lock is never released and thus
> deadlock.
> 
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit
> a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), keeping the
> enablement of huge vmap support, and removing the ifdeffery with the
> partial revert patch.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Will Deacon had pushed back on a similar approach:
https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/

Although now when I read back that thread, it feels more so like my
incompetency to convince :) because:

1. I don't think this pmd_free_pte_page() path is a hot path at all

2. We are doing a try lock which is almost guaranteed to succeed,
   so it's not like we are losing out on block mappings

3. Any overhead from the try lock will get dominated by the pgtable
   page free/TLB flush

I guess you did not take the RCU approach because that would put code
into the generic kernel pgtable freeing path.

I liked the RCU approach because I hate the fact that ptdump takes
an mmap_write_lock when it is literally only reading the pgtables.
But your approach is simpler and fixes the problem at the particular spot
and not hammers the fix into a generic path. So overall, ACK.


> Lorenzo Stoakes (2):
>       mm/vmalloc: acquire init_mm read lock on huge vmap promotion
>       Revert "arm64: Enable vmalloc-huge with ptdump"
> 
>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  include/linux/mmap_lock.h       |  1 +
>  mm/pagewalk.c                   | 22 +++++++++++----------
>  mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
>  6 files changed, 51 insertions(+), 69 deletions(-)
> ---
> base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
> change-id: 20260710-series-vmap-race-fix-2a4cac988938
> 
> Cheers,


