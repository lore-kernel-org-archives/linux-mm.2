Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DFEC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120EF6B00A0; Tue, 22 Sep 2026 09:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8BF6B00A1; Tue, 22 Sep 2026 09:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29CD6B00A2; Tue, 22 Sep 2026 09:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C51236B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:55:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48C6E40499
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:55:24 +0000 (UTC)
X-FDA: 85241545368.01.E6DEABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8769C40007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:55:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlD8MKaU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790085322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAErR5nUF5jYNRVD6fb923LvqrMdmDoaO1mDvYNJTgo=;
	b=ERgQxaf2R3vlbcDct74NJmtEuu6PCg2FFVo4TUyES5/AwKYJkSp820I5EwHH6z75G8d2iS
	qLge420KRC+qQCWuonUSSBhIoO4mGDcCh2k9OcddIJxqECQG/G0irbwPRmcL2hG42BG356
	+Q+jRPdRDJITHLqYp2kQXA0RE9mTDUw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlD8MKaU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790085322;
	b=dLLYYVZj6EmgH6Kmm7G31/nSMpCwMOSQrL4Yhb7SsNjkdWFdVlhxfCTE9ipKo5E8qNxnFy
	IfKGvGEYoenbpmvB/Dm1GhgFuBreOsZcgiCP/Xp8THt/QMdfICjUEOrjirT4RSaAveJ4z9
	sMfKBcH/eRNv/EnPptKdoViM1VDxOaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03AFE6020F;
	Tue, 22 Sep 2026 13:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B041F000FF;
	Tue, 22 Sep 2026 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790085321;
	bh=vAErR5nUF5jYNRVD6fb923LvqrMdmDoaO1mDvYNJTgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WlD8MKaUgx0yamc8h91fzZpUq+67Jj9i2OaP2jc0DoDFTbLwN9NDh1giPE8DcEJAz
	 8QWzyr2rLUvwsXjaUtU6g7x2xqFukPXEX5DFPVrrWpAp8KVHpLmXAfibyQaYG0DoHu
	 X2n7EiLG27ZV6U4BpIQotcFuxlULVn6OWfchYpZncZeDU2n2fXWOiiDF+NvyfxOdLu
	 ZMxE6Bl8h5EHVZd78B1q8CztRTwFAtCeqaT28dtbKsRpowV0rEIATOCZYAw14xPuo8
	 3Q0h0CLxLrJbKw1Fi34UpGfNSNU02cwvUYxH+xXZJUoUr4mYQ+0YEVE3GZkw5TFyzW
	 lwkbI4TJnWnjg==
Message-ID: <462b217c-a422-4818-bac1-7f204f32fa29@kernel.org>
Date: Tue, 22 Sep 2026 15:55:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260920084946.3266279-1-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260920084946.3266279-1-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zgd4zke84uucqneq77cfp8qj9u5tjyby
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8769C40007
X-HE-Tag: 1790085322-748949
X-HE-Meta: U2FsdGVkX1+yGg6UdWcKTuZ5r+6uWtXxc+VtHAlSp33GuJaw6AME5SKbwSh5P4YOIVzArVNP+gQsIsrOP4H1qPTMvFmkqwwCOfvdBakz7voOxPqdy6KoBWtl7/xawLCqtc/0QwpItluiVWfcc/WbTr6BQpVy5rP1Rpe1LsqJaYD5lv7M/dCr9PfYm6yN4s2Ox/j0a4Uk6D9MM8RldDW81v5gEmpcnmFHLS2OgOaQsBJ28zWBvxURCaqPhIMPwjRJtfheGJ3+q3NAMzntskxVzj0mhCnLNSrj6vkM/WbgSv7J+OevQCP3Jmjv/ZwM3aroRuv/q+3vhZxc69MNtZ1I2nJw/05+D2aUaNP7STS+oyvrwlLjNeFQHQ2KQg76PkwqDmn9BynCWkFc6/cmG9VxtPnLejZOlLue1eE7CGuHHsT7WDsSdTpyTxSMmqdSQuUVBS8W4+luK+9ufUS8802ilc+K+W8xZmj9ebs9tkagxoV5P+B6uUXBLP9NvuWNSBK6gis7sxdDvB9c6LnuG/g3WXk4yPpGdOqiFKh1HX4ju1HVCRXhh+XO/fgjk6gQSuHZB/5GdpnBvcybFg6FKaDNI6Utx+X0h5MkYbbsvIXpbFrYHBXmCMXYv45ptF6Bu/QwvS4VyWicvHhxV9G2tSENiDHuN2YfpeFiZh3yMtPTgEe0lrH1uTusiqWOlQgmxbTObfzkaafTmtAGsKX7xhqFLMbz/2z8qzub7n4fAW6AAYsOYmX+BN5S4b+xcjS2JKOKn3yhXh0+XO+O7s7P4laUMt4ZrbuaJXxTIB75zP6pWifRy8lrYcY7caWu8wOnF4tG0W59hRdmDy4ouoBQRVYYDWk05MAJq/VcGdslQSpryDSDIYajABq+iUZq4StKbpET/Z2JIsJEuxAJSLEVwkQUHBIKe0xTG/kTjAKJvS3hSFj7MedHr3ni4N8UpD863RBcIUs83onh+8TKSIF7dUF
 YDcW986V
 lonPaKUutop1jEf/v0c+9g44++DK6NfjZvXR22XHw82PkNKMsbPcivixLVoZKAu7dX9x7TtJ+7h574+MNmYWsO3otvpz0aoWvB998gizGZDfm5vaUzqDx+gmRGkrhs5WsfJq63VpFbFy+O8CeMNsBKywAJGvevHLdTK2PxE9Zg7v6oZKElTHyhUw9tyQqQHTwQF5lcuAOZSSRrOzW8r1NpYUbHIztvvvsteZnVF4GwVRwB6fZjW8FRix1JZ6RRUlMVyxp4Y72jyFigjDD3rAZ7EfdPPtdPlpBTRRS6VsVb1XBK32zWvJHXAsOYI4xEYDMMUuMktlh5WhjadJCeWmJ/ICi+sOJiopfIghhOIzUPkGHACadPntPORSb+AiCq62c+qRw80bwu4yAlTSqasvTF1VWXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/26 10:49, Yuan Liu wrote:
> This series introduces a pages_with_online_memmap member into struct
> zone to avoid pageblock-by-pageblock scans across the entire zone and
> improve memory hotplug performance.
> 
> Approach
> ========
> Add a new zone member, pages_with_online_memmap, that tracks the
> number of pages within the zone span that have an online memory map,
> including present pages and memory holes whose memory map has been
> initialized and for which pfn_to_online_page() succeeds.
> 
> For early boot memory, pages_with_online_memmap is calculated in
> memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
> included in pages_with_online_memmap, and hole PFNs for which
> pfn_to_online_page() succeeds are also counted in
> init_unavailable_range(). For hotplugged memory,
> pages_with_online_memmap is updated through adjust_present_page_count(),
> which is called during memory online and offline operations. When
> spanned_pages == pages_with_online_memmap, every PFN in the zone span
> has a valid memmap entry, so pfn_to_page() can be called for any PFN
> within the zone span without an additional pfn_valid() check.
> 
> Note: this counter may temporarily undercount when pages with an
> online memory map exist outside the current zone span. Such pages
> are only created during boot, when initializing the memory map of
> pages that do not fall into any zone span. The undercount itself
> can only happen after boot, during memory hotplug, when growing
> the zone to cover such pages and later shrinking it back, which
> may result in a "too small" value. This is safe: it merely
> prevents detecting a contiguous zone.
> 
> The contiguity check using pages_with_online_memmap is stricter than
> the old pageblock-by-pageblock scan. The old set_zone_contiguous()
> iterated at pageblock granularity via pageblock_pfn_to_page(), so a
> zone could be marked contiguous even if a subsection-sized hole
> existed within a pageblock. The new check requires
> spanned_pages == pages_with_online_memmap, meaning every PFN in the
> zone span must satisfy pfn_to_online_page().
> 
> Performance
> ===========
> 1. For VM hotplug performance data, please refer to Patch 2.
> 2. This series also benefits CXL hotplug. Performance results are
>    as follows
>    https://lore.kernel.org/all/20260409023552.GA2807@AE/
> 
> Tested cases
> ============
> 1. Hotplug/unplug correctness with both online_movable and online
>    policies, including partial unplug, middle-block offline gaps, and
>    edge-block span shrink.
> 2. Large scale (256G/512G) plug/unplug performance.
> 3. Boot-time subsection holes (aligned/unaligned, in-zone and
>    cross-zone) with correct pages_with_online_memmap accounting.
> 4. kernelcore=mirror: verified no overcounting.
> 
> Patch overview
> ==============
> Patch 1 makes shrink_zone_span() more robust when memory/hole boundary
> falls within a subsection. It checks the full subsection range to avoid
> incorrectly shrinking the zone span during memory unplug.
> 
> Patch 2 introduces pages_with_online_memmap to replace
> pageblock-by-pageblock scans across the entire zone for zone contiguity
> checks.
> 
> v10 changes:
>     1. Rebased onto v7.3-rc3.
>     2. Added Acked-by: Mike Rapoport (Microsoft) on patch 2 and reworded
>        the init_unavailable_range() comment as suggested.

Thanks, I'm planning on queuing this tomorrow.

-- 
Cheers,

David

