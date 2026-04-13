Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943ADF531C2
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9596B0088; Mon, 13 Apr 2026 14:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9C56B008A; Mon, 13 Apr 2026 14:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698736B0092; Mon, 13 Apr 2026 14:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E1E6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:24:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6126E2676
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:24:17 +0000 (UTC)
X-FDA: 84654357354.06.03BFDAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0B00100009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:24:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V7YRYx7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104656; a=rsa-sha256;
	cv=none;
	b=e3zfhxV+Sz4QODFjLca0J9FEpSggrhvEBGlGcAwRhqxskdlbhja9xmPPksbrIfN2V69cCd
	WZBmAHOXaAvtQusqiMktStGMh1ZtDtTNt/G0n2iQ8Roy+qtao3USvsXh8orqRA1Asr1HMd
	aEWqhDGQbb8W2TwSDeATOguhMaH8Rpw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V7YRYx7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xHndqa7quoz64ESTzNsUuLpn7BMgI9EePdSEazpsvU=;
	b=reFr9IF3rRiYic/Ct41H/sDRa6CYkI18Ls+stYiK2cf9RxfNNzxOecrksIufVINrB3ibrg
	ykHeQSWVa0uEN8izP2hWwICQvU7TL0aDwkuIgRsY2FJeahkHUlZdAyGWkIhQOVr7jyCy3l
	LBEbNpJ4ABclXR07NxGCnbObTfTZmho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76BC441670;
	Mon, 13 Apr 2026 18:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC12C2BCAF;
	Mon, 13 Apr 2026 18:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776104654;
	bh=1dBsOleOnhiObx6RxrLsv5izIUrE3OsdjfJS2UI9550=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V7YRYx7VUupyHmv4MvZN3iIjTh2NB1qRFB6IL0xvTS8r2NlwcW4Ny8p4Yc3qJUBfs
	 aPCG0hxfp1qkBlK867E2oQgvfy/wzmhASB746j4gZXqKOLFBraKCeNpYjW6xcdt0O6
	 fwCxIUVK1/XberaMAcW4AXV70wVPOEhy2lSIfc9AEgggVPm2Kv9udGwDU+b1gtStNE
	 S64H3wOzzZ7WX70cANjOA/A2PSJnPwInsiVFOG9ozXZpj2v/CwOCl6in/3zt1XuJNv
	 QMQ4jDlVvK2RjZ+HUCEpy0ozXw21OeCgnI9+N0tIVep/I20XujG5PEboTSvvvNUSs5
	 /yQASIJLQ9heQ==
Message-ID: <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
Date: Mon, 13 Apr 2026 20:24:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260413130633.knzkliyqvjhuz2kd@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413130633.knzkliyqvjhuz2kd@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ygkyr95b8cb9nezoipnyksypdtjsp8wg
X-Rspamd-Queue-Id: F0B00100009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776104655-217132
X-HE-Meta: U2FsdGVkX19h5lC59AHgvKEtslvy+wlcbJcVtydlGTqggu4V9llVpro83GxA8A8KrpCKRgVS/Uw9EqpP0Lg7T25tIMmDMwOMOpkoIEffKMN+i4OU7WrU616kPpwrhlD8abb1QdCI38yhj69X3Lm9L2FN3vfrN5GZCBEERcE5kr1SZykumkx2Z5uUWkjx1iSedfk5M3hJbldoP6AMxa1ZjvAWF0+SYLXIJdAjchgQp15vYpexBM/PhmkiNF/Z5DErkabESq2yYtM8DoSMtcf4/R+l75rG0rA+yRmxB/w4igIKuuR+y97MxJiOTVmSnZsT4rF3q413mA7nnz6+I1HsBayEi1u+gSWjZUjFN8qZ357P36LiWm+c+6foNGUR6JfM4kjVOZzIf4Cy+AqF2P7fOKSwtpItsThiJAKGTFgUUcURZFl4mqUtBB028Qgskg3ywGLYRBZrOMw1mp/nqMuD6Z6BJidKhPSeBsriDIzijGZ7UcpgxIQoZ3kv2Jdcxf6QpmMvJ9r9Yj8Z3/g+lZIYvHzilDZwnfcyWSKyDebrxVt/cGrIv5cfOlCCooBZOGZJX9RZTk+GXTT9/CBfQkIdAecLkQ/4fz0+H4g6KvlYVOuqtSMWu24s7cG8yIebAIhn0HH52nQ7YNQjDDbayr3NGN6qiSQyZ8S1zNLr9A1QBNsdPPLADAdS1tim9JvDQsRcZKtLUySxPtjiP/fvoxTjgO4UkXoLKFOqS5u3NR4GeXtcEfJnJK/EANECugkIz1j7gAnmjofKkHQXIJVDn7A+6p0HMlU9kIRBgsJDU2O3Mmuyp7/MNYDXIoJPqxGshIqdD5C92fM/JhNAR+MNSG3Nb+LAa2oV01QPSWMQ8bwbjp6QmJ2SYtwkx0f2zXpGzvrxASEbqKLOO5cCTZJBkhssy8LgBcGhwNj3V9uU/bFYfBu2UlIjisYJWoQGk0NH4f+YfQ8dNe5i4bgvjy3EpGR
 pfeO6o2E
 nzZuhxevuTrsDV4tK4N1hn3h9PS8fTXHormaU8eu9vP/v9cmCgU3yN8Ha9LWzevMpGtQACZtkD97pl6+tiCciIHNqcQ7bM0LwndU1FLouJJgm+BoLvldQctkWQvOYPSsFYaZCUR59PtogxcaCxQErp27HvhtagWiLdykm1ISJQJJKHIqZOeJzC3QxhZuyBB+6B41yOhzjFMqYfv60ILGeQnmyMC5JwnYtO7wk6spFHfKcbnJyn462O899pGhAyTliiLtL7FuHhiIfzyOXnSRDhYbijYgI4vmxb+xCBxUhErRzlHJAU7M/PvbAfhbM1qTG/Kfv2/0hWCbAiTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   With the last memblock region fits in Node 1 Zone Normal. 
> 
>   Then I punch a hole in this region with 2M(subsection) size with following
>   change, to mimic there is a hole in memory range:
> 
>     @@ -1372,5 +1372,8 @@ __init void e820__memblock_setup(void)
>             /* Throw away partial pages: */
>             memblock_trim_memory(PAGE_SIZE);
>      
>     +       memblock_remove(0x140000000, 0x200000);
>     +
>             memblock_dump_all();
>      }
>     
>   Then the memblock dump shows:
> 
>      MEMBLOCK configuration:
>       memory size = 0x000000017fd7dc00 reserved size = 0x0000000005a97 9c2
>       memory.cnt  = 0x4
>       memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
>       memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
>   +-  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 1 flags: 0x0
>   +-  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 1 flags: 0x0
> 
>   We can see the original one memblock region is divided into two, with a hole
>   of 2M in the middle.

Yes, that makes sense.

> 
>   Not sure this is a reasonable mimic of memory hole. Also I tried to
>   punch a larger hole, e.g. 10M, still see the behavioral change.
> 
> The /proc/zoneinfo result:
> 
>     w/o patch
> 
>     Node 1, zone   Normal
>       pages free     469271
>             boost    0
>             min      8567
>             low      10708
>             high     12849
>             promo    14990
>             spanned  786432
>             present  785920
>             contigu  0           <--- zone is non-contiguous
>             managed  766024
>             cma      0
>     
>     with patch
> 
>     Node 1, zone   Normal
>       pages free     121098
>             boost    0
>             min      8665
>             low      10831
>             high     12997
>             promo    15163
>             spanned  786432
>             present  785920
>             contigu  1           <--- zone is contiguous
>             managed  773041
>             cma      0
> 
>   This shows we treat Node 1 Zone Normal as non-contiguous before, but treat
>   it a contiguous zone after this patch.
> 
> Reason:
> 
>   set_zone_contiguous()
>       __pageblock_pfn_to_page()
>           pfn_to_online_page()
> 	      pfn_section_valid() <--- check subsection
> 
>   When SPARSEMEM_VMEMMEP is set, pfn_section_valid() checks subsection bit to
>   decide if it is valid. For a hole, the corresponding bit is not set. So it
>   is non-contiguous before the patch.
> 
>   After this patch, the memory map in this hole also contributes to
>   pages_with_online_memmap, so it is treated as contiguous.

That means that mm init code actually initialized a memmap, so there is
a memmap there that is properly initialized?

So init_unavailable_range()->for_each_valid_pfn() processed these
sub-section holes I guess.

subsection_map_init() takes care of initializing the subsections. That
happens before memmap_init() in free_area_init().

Is there a problem in for_each_valid_pfn()?


And I think there is in first_valid_pfn:

	if (valid_section(ms) &&
	    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
		rcu_read_unlock_sched();
		return pfn;
	}

The PFN is valid, but we actually care about whether it will be online.
So likely, we should skip over sub-sections here also for early sections
(even though the memmap exist, nobody should be looking at it, just like
for an offline memory section).

> 
> Some question:
> 
>   I suspect with !SPARSEMEM_VMEMMEP, we always treat Zone Normal as
>   contiguous, because we don't set subsection. So it looks the behavior is
>   different from SPARSEMEM_VMEMMEP. But I didn't manage to build kernel with
>   !SPARSEMEM_VMEMMEP to verify.
> 
>   I see the discussion on defining zone->contiguous as safe to use
>   pfn_to_page() for the whole zone. For this purpose, current change looks
>   good to me. Since we do allocate and init memory map for holes.

Right.

> 
>   But pageblock_pfn_to_page() is used for compaction and other. A pfn with
>   memory map but no actual memory seems not guarantee to be a usable page. So
>   the correct usage of pageblock_pfn_to_page() is after
>   pageblock_pfn_to_page() return a page, we should validate each page in the
>   range before using? I am a little lost here.

These non-existent pages (holes) are no different than allocated
un-movable memory. So compaction code must deal with them. Just like
smaller memory holes that don't cover a full memory section.

-- 
Cheers,

David

