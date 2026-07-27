Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F66C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715526B00A1; Mon, 27 Jul 2026 10:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECA16B00A6; Mon, 27 Jul 2026 10:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C636B00A9; Mon, 27 Jul 2026 10:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CDBC6B00A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:26:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8875C06E3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:26:14 +0000 (UTC)
X-FDA: 85034781468.19.BF3093D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2817A18000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:26:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCFTFoFB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSYcZBFPuC4PDoWkR8v2euqsjdGGE1vamaXLhHYCmrY=;
	b=Z+odwLGqcXsNF/es0pxLA/r0jI7GoMPAPIGSgQpSaTRPNhhu3V7CBNovV1Y1gRlhdN6ZeO
	cDxudvJsVRsXsce2ESDxHzNlFP6NCb5ZHb6DEpoiv6f5EICGo93UKN5JKuSNhWi72ghfo1
	CwAscf/7OwOUBWE1c8maQJHpqpYHicY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162373;
	b=aINtA2k1Mb0Fpq60J5kuUIJfOVscFUrt8KxTSosRC9PFbyW59hI2B8XDtH2It5oW0Wp9ah
	DAIyq2RrG/Qf7H5DC0j+SIpN/PqECfLoZaezQ6mheTXJ/CjtdMA7GBEjRu/muOGgMtrUuu
	ceUMaCqdF4f8b+eneosenxcIRGzpMXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCFTFoFB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6402F600B0;
	Mon, 27 Jul 2026 14:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9081F00A3A;
	Mon, 27 Jul 2026 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785162372;
	bh=SSYcZBFPuC4PDoWkR8v2euqsjdGGE1vamaXLhHYCmrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCFTFoFBLMD9idxq2HbdTAda/SlM8MutA1Intqy1oP0WrRvrjXO3eR4WCDpv0VOb8
	 7r1iYGpdhEstIu25vsbXS0FBiNRcpHAflnWXZAMWwbAPS75aD+eNMa9ycWuXF2drvm
	 Rzw+SIsGelKwLS6NGckfBPV55mEf9R4LinYPOLGM1A4CwHtjGRvr1cpQMD5k/7CIyZ
	 O2aEWUkEgGqL7nMMwvLZs/lL+Uhqan4iwYUokSOFe7in16GXHl4I5b2CItB9Y3GvoK
	 s/r8bQgnX/UZrfxpxhrpNWkDodb4N82p9c8NEPiYKQavi7i8OPjlg2jfMvkdfDPEyK
	 WILqzK9iMFT/g==
From: SJ Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: cover discrete System RAM areas with per-range regions
Date: Mon, 27 Jul 2026 07:26:03 -0700
Message-ID: <20260727142604.85548-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727095429.143527-1-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qzpg1wfxemej8zuar6gxyujizn5djkg6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2817A18000D
X-HE-Tag: 1785162372-434207
X-HE-Meta: U2FsdGVkX186n21VaAVk8t7C+K1igM3ek7Nod2Zu0ebzMCqS61Ou26wITWGI8TagRsA9PIpHeUxCyo3C2o+KLhVEgKbmV/RCat345OKFsX/SJjQEYzLnhVNZSIIwMx43ospfIsbLAgYOmy1uug8K5NNjmaWT9vDv6KwMyUwYGFklBIdvpidqw7FcrmnfgjFmD45GWnv+GtwnzFbXB3hjKL0lXTNvFLVho21jhVe8Afybx4Uokq5jjZRu161VXFUqBjGXCU8R0KcLw/jM+7Mbuy0Wcjuzw4Tjh9Fx7B77lMG1t/jTNnplHPZ9fBldCjwzGfcvpWK24INC7R3dJL9rot2i7rwEUlrZmOKb/RAS64/JQ7DJRSe6/4eZ/tvQNnh+2SkqvFFrwvnBuE7TbP/zAz9K+oq95wNCXBnqjkzjoHLTyoH92JkuRURNEZ+GI3Snv6jClG57Z/lgCQnWRK1vE0lr1a9pN52gGA+8/fnpv1VCZ7i+KUWq9cg1taB7mz2OUHZCkKBY7u/eEpH+VHNRJOSRyVtRqGGF0LaYMvTPoUbayucAxVpvmjcz84wgE1+rHSFF4p5PoWNjIjp3ckKJxySQ5L8Af+pcQRc3emSRp2VUa9SPWikefAHwnAa6OD8/wg10KfYnK8/QFUnVxbRhN5MdHWPXEPckl2GJv7PNhl0NHt1tX/zDRAu5hBt413bAWVgYQHuGKRRPwJ51Kv/TDph9wbVoYAvT5QJXWEkOE9nw3aVEyeSCqq5ThotKh0KGojUi9XAOoE/oF080AQzx+K4TKDb1VBI0S8fiYgnMgHMMkoSQ6aoE3hpGSqulEwgh/YpUA8TPO1WISkApiw8Vb/O4iwqLaUR8iCDoA87Vmzv6zowJrh1uf85LfjCR0yYcnJmoNDl9emSOLLnZkIwbPp0EZh6xI9BgzvSiLrCS/xDPJGO9tnnVJt1+PiLvrEVMf/8NEwcldpqgp5tpRck
 CrsOqjHf
 WaEt462Fq5RiI/+QwqXT1I4gBdho7R3t6Cxk+QyUx/tKm7aeCQ+dOahZ8nL7x0sibalByEkMwzB5EUcinC2YorgTj0JqEIk91hjhzGthaP5ObB3R+B51HQyWseeWtKI/KL8fZiSm4zeOjib/WHlX/+vOnNPpyXzJKRFC2bpyGKfchQF1BT7t/FglkJ8GfMw1ZABE8Tfi9kLtql8AeVGnQJpTp/xqOn32e0gJrs8QtNOcpFfTOfue+zQ4ORUQgReyuVCwCSqc95qzN8yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jiayuan,

On Mon, 27 Jul 2026 17:54:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> damon_set_region_system_rams_default(), introduced by commit 70d8797c15d6
> ("mm/damon: introduce damon_set_region_system_rams_default()"), is used by
> DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT to set the default monitoring
> target address range covering all 'System RAM' when the user does not
> specify a range.  It walks the 'System RAM' resources but keeps only the
> start of the first resource and the end of the last one, and then sets a
> single monitoring region spanning that whole [first_start, last_end] range.
> 
> On systems whose RAM is split into discrete areas that are far apart in the
> physical address space, that single region also covers the holes between
> them.  For example:
> 
>   $ sudo cat /proc/iomem | grep RAM
>   00001000-0009ffff : System RAM
>   00100000-4848c017 : System RAM
>   4848c018-48550c57 : System RAM
>   48550c58-48551017 : System RAM
>   48551018-48615c57 : System RAM
>   48615c58-48616017 : System RAM
>   48616018-486dac57 : System RAM
>   486dac58-4e563017 : System RAM
>   4e563018-4e627c57 : System RAM
>   4e627c58-4ef39017 : System RAM
>   4ef39018-4ef3f057 : System RAM
>   4ef3f058-4efe6017 : System RAM
>   4efe6018-4efec057 : System RAM
>   4efec058-50247fff : System RAM
>   50317000-56720fff : System RAM
>   56722000-59c19fff : System RAM
>   6bbfe000-6bbfefff : System RAM
>   6bc00000-777fffff : System RAM
>   100000000-1007effffff : System RAM
>   67e80000000-77e7fffffff : System RAM
> 
> Here the last two areas (about 1TB starting at 4GiB, and about 1.1TB
> starting at ~6.5TB) are separated by a ~5.5TB hole, and the single-region
> setup makes DAMON treat that entire hole as if it were memory.
> 
> This is harmful in a few ways.  The monitoring target regions are limited
> by max_nr_regions, so regions that fall into the hole waste that budget and
> leave fewer regions for the real RAM, coarsening the adaptive regions and
> degrading the monitoring accuracy.

The hole would look like not accessed.  As a result, the whole region will be a
few regions that very cold.  That wouldn't waste the budget that much.  Do you
have some specific setups that this cannot help?

> In addition, DAMOS actions on the paddr
> operations set walk such a region page by page, so a region that covers the
> hole is walked for its entire (empty) span on every application.

That makes sense.

> 
> Set a separate monitoring region for each discrete System RAM area instead,
> coalescing only truly adjacent (no gap in between) resources into one
> range, so holes between the areas are excluded.  The reported *start and
> *end still carry the overall first-start and last-end, so the user-visible
> default range reported via the module parameters is unchanged.

I'm concerned if this could result in having too many regions.  The gap between
user-visible parameters and internal state is also a concern.

A quick workaround would be adjusting the memory layout in BIOS, using DAMON
sysfs interface instead, or setting the monitor_region_{start,end} to cover
only the single area.  Have you considered such workarounds?

Let's complete this high level discussion first.


Thanks,
SJ

[...]

