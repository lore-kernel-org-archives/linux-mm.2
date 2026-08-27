Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FCDC61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF26A6B0088; Thu, 27 Aug 2026 08:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9296B008A; Thu, 27 Aug 2026 08:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEC56B0099; Thu, 27 Aug 2026 08:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 950D16B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:19:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24356403E9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:19:26 +0000 (UTC)
X-FDA: 85146954732.06.F62522E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13AC44000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:19:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqE0yanI;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787833164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBV6AY4FuaDgv8cnc1J4F5Qidn7lm5sMxwr2dKZvdfQ=;
	b=iKfQIrf1or2ZcADm11jJHa9vVDNYqqLyB71HWAsQhnA0gTsqizzYwBJZsZK0rCLy3kT10M
	BPnEDy7Y3/Ezw6FZXrxnYOYGajy9p4sW2YX9z+nKTQy9ZXaqm5iorPsgTHUWzm395mOJ3U
	SSgB5adpvjj1zWrr5fVEYvDrFUxBxVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787833164;
	b=tMge8gwCH1Dwo5U2zCLB7n1Sy60i/o1id0A0qq0xvZmcxqCbmIov+1rtkucAhGTvGwj2To
	dAsXbVGFddDikcCv8TwxUSwGSb18VpPJ5gXJD+J703hAsyCCn8SLyocxrZSIIkuScVvWff
	B/c2KG0T8ZthIiklNIVKqwtkP+8jsKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqE0yanI;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27DB81691;
	Thu, 27 Aug 2026 05:19:19 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 427173F85F;
	Thu, 27 Aug 2026 05:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787833162; bh=NHYgfhHExdZGRzQbbWsfmteTMOojXU3ciyLD+vd7IoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TqE0yanIRsRMANdjtjpIvo7tplqWOUwRNFEv7JrsZYHEuU8nrY0fqcFCDm0Z55YEb
	 upbCxgUbS36Tt2TpPF7DsfXww9rVPcZguaQe+kRWOyvKIJFAzciHeUidcgdsF/Dp4A
	 id/HxdE2OyIoh1KZHGEp5eLyYMF4LbRjiaIkQS6g=
Date: Thu, 27 Aug 2026 13:19:16 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 00/18] mm/huge_memory: clean up folio split and lift
 swapcache split limits
Message-ID: <apArRLFDroxOKWUV@e129823.arm.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13AC44000A
X-Stat-Signature: enk3a3173w8s6ouruxudq19kp3gssmrw
X-HE-Tag: 1787833163-877567
X-HE-Meta: U2FsdGVkX1/D82j5AS2KuGRlDDko2jTRBj4EbJEU2u/csJUR4K4ejpP20iKTF9M6B8xXuh+e3v04ocOBNMS4OjWnzvlanhO1BJsbXX3MB+JFqYJZ3ZYWiN7y2dqQ4jz+O+rKLUy6OLJx0wt2Z53CyeCCl22weQJoW6hHV90RGDYEoBZPtENBqfaqc2lwmdHx/3gBXXoWMdEmTw6P4X1eQn+rsNXd7VdKhaVEz1RjwUDR1tYvFb7XYSSZ65iGpmhs8xNKd444XiMLe8cdTQAMCmTITtZiB4fmNQpVGAdf/DcNsSfK6RVssAABLXz2SexBKUCAaxNEAZYNbH14rkGj3AVyc3Xg20NdvQeJa8VR7/8ke5d0rhQoLG0lAtCqW2AMNeTsezKcKzHV5SQA4arQtlW9DPRSWnRkT1i4imqjRbK3rjv6QBEda43vzy7EPw2/QEHW4NpsJ1evT8UaKfa1P4+wUCE1t5/uA9t/a2lEwXWSdfk3lmUmRrilfWsn5nVL4C/pObbDdLhp9HALKE+wKpMZkZVllhc8NLIQLm/wIE/84lPbLH0LFXBRUZJ66Gen9w6V0eI8qfFbCcEgny6qBwSIJYERIPB3Z517QkqWIXSS/wHmLS4sOPICYj41ShmyoQvU/TwyCXxx3XxpspIYOQGsBSdgqP6fsTLTvhDIdK4+hzJUk4F1kaW63GauidFffpK2NYZpPPDbcehD+E6zXXzsSAp+hOCVZy5fO4wKPkx81vkSEBIh0wbI4YUHutSzSkaEVB5KTyomADKuzHUxbJr0IVbTuQw0aAqxKR9OYMUwaHEptSs7m8sV4ShudfFBGe/4kQot8fgvaiILe3gpm0TuWJpl5TAh266D8hk1Ay+g2Yxr71Vcg4ocqSRjKXkBD3SDHaJ6cRCmtXoQVhApannEFfpHhIsWO+Abc0g1+eV0JyyGpXoA2RSAiZsuOdhwAfPmxtTg8b4U0V7bxVo
 ZY09lZR+
 GdidXC3YkTMWmzK4iyVWOfXaM5QNjknibOQ/FYyWU1dLJ8pgPWsHXTdKQRB1fVelYnXMFKOUtrbv2NeiI77tL5tw4WOdNesI16lmdAHnGYJCwJWr/wd5FkbhDM8e5OGduzdq3WwoffCpeAuHfVh5NC9qnk6u2LdjFtn+58grHW7zACGAzVzLTViuG14r5A9QsgOgD/vgrCt4Vv/vQRZxkxvPzfRP8r/CU71jR4Neg9pvDryicUrVUBRmtWl8Czxv5LBJUBcoLWxT7uQfkTDlHTXHXVyN8kLh1aKZr6BgidpfeX8hu8xfn+g+N3SnEYWJqhmOnv8NaK6QNwSiCG7IIiJgK+fyP9tk+0g7534ozNn2bQQKWgs3f5M8UqhutjXDb39tgU59UbLFOJAMdSWkBGFhvNeUKN36qiKuXAUBfx/BWfkkFEmyVy4gxgyLNPEp6pGcPkSq/63Og7bU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This series clean up the split code, add better swap cache split support
> for mappingless, large order, uniform and non-uniform split.  Generic
> performance is on par or slightly better, and stack usage is reduced.
> 
> The swap cache infrastructure can handle non-uniform or high order folio
> replace, so there is no reason for either restriction from the THP side.
> What stands in the way is the mixed anon/file folio split routine,
> which makes lifting the restrictions hard to follow, and it already
> carries some buggy or redundant checks.
> 
> So this series cleans up the split path and separates anon and file
> splitting into two helpers.  The file split path never sees a swap
> cache folio, and that is now enforced up front: a folio that is both
> in the page cache and the swap cache can only be a shmem folio, which
> remains unsupported and is rejected early.  That helps to rule out swap
> cache handling in that part completely.  Only the anon split path
> handles swap cache folios, with an anon mapping or mappingless:
> either way the splitting is similar, and non-uniform split is
> supported as well.
> 
> Order-1 is still forbidden for swap cache splitting.  In theory it is
> doable for shmem swap cache folios, but a mappingless swap cache
> folio cannot currently be told apart from a shmem one, so forbid it
> for all swap cache folios for now.
> 
> Testing:
> 
> The in-tree split_huge_page_test selftest (uniform, non-uniform and
> in-folio-offset splits of anon and pagecache folios) passes 62/62 on
> the patched kernel.
> 
> ftrace function_graph tracing filtered on __folio_split() was used to
> compare per-call durations between the base and the patched kernel on
> the same x86-64 box (interleaved runs across alternating reboots;
> 135 split calls per run, 50 test run):
> 
> Before: 67.9 us, stddev: 1.59
> After:  66.4 us, stddev: 1.19
> 
> The patched kernel is slightly faster. The stack usage is also reduced
> by about ~10%, with a very slight growth of huge_memory.o.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v3:
> - Get rid of for_each_folio_safe and open code it.
> - Check if the folio is mapped before freeing it swap cache to avoid
>   potential performance lose.
> - Initial test and binary analyze showed everything is very similiar to
>   previously series.
> - Drop the redundant mapping argument of __split_frozen_folio
> - Link to v2: https://patch.msgid.link/20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com
> 
> Changes in v2:
> - Return -EBUSY instead of -EINVAL for swap cache & shmem folio split
>   attempt.
> - Introduce a for_each_folio_safe macro to dedupliate the code and
>   hightlight the reason we need to keep the iterate safe from folio
>   freeing. [ Zi Yan ]
> - Rename __split_unmapped_folio() to __split_frozen_folio [ Zi Yan ]
> - Rename __folio_freeze_split_unmap_anon. [ Zi Yan ]
> - Several comment improments [ Zi Yan ]
> - Drop an unused do_lru argument.
> - Previouse test results are basically unchanged, stack usage reduced,
>   object very slightly larger.
> - Link to v1: https://patch.msgid.link/20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com
> 
> ---
> Kairui Song (18):
>       mm/swap: fix off-by-one in swap cache replace sanity check
>       mm/huge_memory: fix rejection of swap cache folios with a mapping
>       mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
>       mm/huge_memory: split the routine for splitting anon and file folio
>       mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
>       mm/huge_memory: consolidate irq and locking for folio split
>       mm/huge_memory: move EOF trimming into the file split helper
>       mm/huge_memory: move unmap and remap into the split helpers
>       mm/huge_memory: move anon_vma and filemap management into split helpers
>       mm/huge_memory: move memcg switch into the file split helper
>       mm/huge_memory: allow splitting mappingless swap cache folios
>       mm/huge_memory: add kerneldoc for the split helpers
>       mm/huge_memory: drop the unused do_lru argument of the file split helper
>       mm/huge_memory: clean up after-split folio freeing in __folio_split
>       mm/huge_memory: lift order-0 restriction for swapcache split
>       mm/huge_memory: clarify supported split orders in comment
>       mm/huge_memory: count only swap cache refs in anon folio split
>       mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio
> 
>  mm/huge_memory.c | 633 +++++++++++++++++++++++++++++--------------------------
>  mm/swap_state.c  |   3 +-
>  2 files changed, 338 insertions(+), 298 deletions(-)
> ---
> base-commit: 4b2ae13f3393ef4b4bce0021e8762790354f369f
> change-id: 20260804-swap-thp-cleanup-6ce2be6cf3b8
> 
> Best regards,
> --  
> Kairui Song <kasong@tencent.com>

Nice cleanup. this series look good to me.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

-- 
Sincerely,
Yeoreum Yun

