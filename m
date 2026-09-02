Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D752DC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7EEF6B009E; Wed,  2 Sep 2026 12:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56F46B00A1; Wed,  2 Sep 2026 12:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D4C6B00A2; Wed,  2 Sep 2026 12:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8DF36B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:41:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4732EA02CD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:41:28 +0000 (UTC)
X-FDA: 85169387856.10.4D65324
Received: from mta0.migadu.com (out-110.mta0.migadu.com [91.218.175.110])
	by imf12.hostedemail.com (Postfix) with ESMTP id EED9340004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:41:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HRgF1s/T";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8eU27HvRP7a0r/EohKeiYdmtGVIzstpFyFLzJ9g2Co=;
	b=Psszml/0D1qnIRjfQ9b0xRhG3OafifTNFyNjBzm3WpQr2EsBhE3zQRPGNEsj6FFnPpCT6f
	aU82j2aJNQBbRNiqR/z0fwl+f0yqu9jAYld4d0zvSFtso+vyjeFeTRmaod0yZk3IrUgoxs
	m3Q7uYAtqKVLfNF+oKiletv5LJMPa0w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HRgF1s/T";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788367286;
	b=XTIL61MvhJ3MRRM/9Q2430whEYqDDhyFAxV3TMjPw81X5mcI7AnfWUS9p1O98HhIbHcUqE
	yVw9neQEXBvnjvwnORYkJEDIRCmeYELsE3fFGifIiUIXjmRuQ2277/VXinVrGsvFoqjMst
	m8BlG3zs7vELshK+8QyhPr7vC+Ln5fA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ou4zikGxkHmecP2znZ+Jqd5Qm8DfcxsyZmVSinR4NLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788367284; v=1; x=1788972084;
 b=HRgF1s/TOMv9wBU5/2ufXbzeUgvcpXKsqefyMOBIEOgbvw/qAW2GsZO9ah7/agCQXgC/8MQl
 Qfus9sJ6ElMY97V69Z8mFT4WkM07pARQasNfRMFERES9MnSmrPRcolImayGNLu0OTwywaXHKnGB
 JN1NhzPfCTQm/PKal8nWNusA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 338eeb5a5200f8e7;
	Wed, 02 Sep 2026 16:41:13 +0000
X-Mizu-Trace-ID: 338eeb5a5200f8e7
X-Migadu-Flow: FLOW_OUT
Message-ID: <75232acb-6c87-4a1b-8f5d-c635a62ecff3@linux.dev>
Date: Wed, 2 Sep 2026 17:41:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Nimrod Oren <noren@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901190123.3511535-1-noren@nvidia.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EED9340004
X-Stat-Signature: c8drjfbisu1cykfu3pejjz84uh39eedq
X-Rspam-User: 
X-HE-Tag: 1788367285-132117
X-HE-Meta: U2FsdGVkX19GvWBs08+e90qnInwmdurkTynPHHC7ofQ4Eg2wFhAWhOBzimRsNLtGJwBj4gLc59xFgEJfRVdAXl937rummmKikfiyutuaSnVDrf73lzFCGE8QGsmfIJxpPOeHQdMvVIdP11S9wkSp+DnDlE/tp1zUsbDbMMbejm1OZ5Rpkx5eyhJcivYcghZuDEvvzGTaPNdSZpMlcru2FPZie3rC1UnwwylUo1h9thROttw/4BXgKPJyikggCSM5PSkaj6OIGt6+kwbtxPiwcIxfyDOJXoJowS1KFy1pbONkKKy/sRnVl8+HOV72eMlpmI33LtulBRfiYm8PjUVU/TaFm+kmE0qdKGKHuKrXVhG2uSkhWxfYVG0btITpm2uKMU/OIP0UvxK9GFKCsdPomWzjfqF14q2D12t67cHdnBTC2hGhuntnEwX8tzc7x06NUOvf3WhIEiZo/qicobFMA/9YTPnuydpDCcTM1AwvUcd2sdE14qwUWxHDhYC/Wa92kMKFIi0oipyit+bMky/E1Ci3SQrwFfVL0QqtNcc1ojdDg7RiCswhMlNU+NiKUJ6ZHxc7zP3Qqq0CRUNNc6V8wMfGk2Db2M0t8awBVjqd0tl7hV7/0URcQYseKejxdMR1SXYCWbeNioGTgu/MUCOTzi7659Sl6ltmArhJHCSTI1WGYoABR23W77ATelmN800bDPmrVTcceNExw4FgC9qj/AlyLoDya64+BjDxrT01uUvr42Rov1eIapzJTOYldQTdqAv2O8mvsAHni1hl3o3UNEAZw0GDYE2FAXfSP7wq3q6SeWLYmxij8XhSXLtIqcv7R/zvvIIXU2oRqy6TxQ+V5E5eEGquJ8U6DFeVtzu63n8MAqayVIaSp6PqG/IovP4JWcQo5rs24IGLpM7ibNwA2LT0MJ4LbqYqPLYRzzaApQCIh7HDCRvBARFs3VumVYBUnAdoGUZNsnjavYpoJFu
 f9KC0u+K
 mU1tEP94MYf5maiBA/AdauI07rrkRBf7I6YYB5asljtDFd5a8ov6vHKsneZzMAt76wyxxeFrUYOiKHcrwTCdOBnyT6yrTv3c4gOkFYGmd0YEQPjdLRWRJaVN3WPPOZi2JJbVGTg+nhQBQ97A/qzKUQjlryb9DxTRvu5uyMpaMyNwWUC2u2RnTUNXD73+A9HLF1ZOwSw8uWcIhfl1E8y7dRkHfxD1PsILUqpSEYpMIBAAx5c43j4LmK/+GeB43jfokB7ot0QzcjKE1dQohfFqpYORJr/WfMsEwVyijLKw3BoOJxvIoqz2FZRK0pN3hdioSPUi5IgPQRA9JwJMBndcnVAAhBkKyVyBBEfVOS4s/OdzrJOCNF8bT9wI8v61D2AmXICRLqJiC7iAJEc8NyqDywBXYyRZ2dx93DnDcEOV7FXtKC3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/2026 20:01, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
> 
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Even with that cap, min_free_kbytes can reach excessive levels.
> 
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
> 
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
> 
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Could this negatively affect x86 and arm64 systems using 4 KiB
pages?

This change reduces the free-memory headroom available for
compaction. That could reduce THP allocation success, especially
for GFP_TRANSHUGE_LIGHT allocations, which fail quickly rather
than performing direct reclaim or compaction.

With defrag=madvise, faults in MADV_HUGEPAGE regions may instead
incur additional synchronous reclaim or compaction latency.
khugepaged itself will not start later, but it may encounter more
fragmented memory and perform more work or fail more often.

I think it would be good to provide THP success, fallback, and
allocation-latency results under memory pressure for x86 and
arm64 4 KiB systems?


