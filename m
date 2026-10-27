Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7351F606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VASw8a7/
Received: by kanga.kvack.org (Postfix)
	id F36A86B074B; Tue, 27 Oct 2026 09:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7236B074D; Tue, 27 Oct 2026 09:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6726B074E; Tue, 27 Oct 2026 09:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B14696B074B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:39:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 456561A09BB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:39:02 +0000 (UTC)
X-FDA: 85368512124.21.54ED0F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 882FB80005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:39:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VASw8a7/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eP/VlP5fifIOIsGnDSJCoqWaClRY4R6jN0i/F3KlPYo=;
	b=ojUlHd0OhiA3XIgpEIEtWxZjHnhcSLKI/i3YVjlI/1YxNqTmCi9KaT4r3iy5b/u+Qyu+cu
	+yKilWxIpy94ZOaP0gZOm03b75szcGtsqLqH/inHRTFZDK1ktGlVRsOatusP4XC0AYBFh0
	zEKeozwuJOx6rBwM+0kEE1DjyskM7S4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VASw8a7/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108340;
	b=gIgMB/mUU4lukEaIePf35n6rBoqH9GicQ2VI3Ofp/72bMDwB5Gp6ZdIw2wo9e6VwXMfujy
	7Um8wbtW6EQrBHoT/xtTBstLFqGgHpvudk7YamTeoaXEI7vQgX/855Uk3bv0Nt2VE0XF7U
	4bXRW40W27Ek7HzpHfHpQ8HTI6I37sg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C49A660211;
	Tue, 27 Oct 2026 13:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489891F01829;
	Tue, 27 Oct 2026 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793108339;
	bh=eP/VlP5fifIOIsGnDSJCoqWaClRY4R6jN0i/F3KlPYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VASw8a7/5jcGyFhoJScT9XjbHReklX5yiUSfTG4A2q4yod4g6QT9/IUaeEs7b5JS2
	 lgFRQ0HhNb1tSz1cBuWVp9r92zhDA+IMGXGaljVYz1J4gmODMiI/WOp/Azxo7F584B
	 qU93QNYU4SfItBznQ2/Hvf2Top2U0zb/ea1S3Q/4hJesAcm+5NDslrgUh4rhQanbhx
	 2pMKsbR+x1oWldIOxLGxZQI5JeVxDgZkZlsaIRF1jNjwoGlJ8B0MCIIe88vHIqb82g
	 ZNyYTy4oBoxw82vv3tGkS8+x7Tld+Gf4XBps3FkzwZv/XBp4T0ifteuiC1qct41yBr
	 ZMK7s0iMp/vEA==
Message-ID: <f4fa7ecb-f4aa-4412-bf1e-049c5761407c@kernel.org>
Date: Tue, 27 Oct 2026 14:38:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/compaction: wait for pfn walkers before poisoning
 offlined memmap
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev,
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027042204.3741307-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 882FB80005
X-Stat-Signature: sqhyfpo3hja8sq4yi3qqdwpwnifhtq59
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793108340-66542
X-HE-Meta: U2FsdGVkX18Url3vFFuepTJgEuTea5GfyGOtDljcBHqhY3keXk1thYYlVtl2s2GMnsDH02Z9Co1/9Xsp/QPLstyJZs+GzzjpzAoMvOjZ4uZ3GNmiec+A35IvIE3tXW6S53Ol7ISgSh+RhVpC5lm1hwm0XG0+aK7OiHVQcXSsNZot3ufucpuikh6ZN/gKoQg1EqqXuFINabU+CC5CQ9yY/F3HunpZNkmEryj+l5yll/lNqwaQ/6slQZNMZrtzJnDKEi1rL7BlkW9s+I8Apu5GHSitSxCGNQSqdfrue7/By+9rJ4le/3NR0uYSufsYLXLJH2UQBy+j4cMRV6yqN9zNP/MVoyYoRxvY5uitM239LiWBi89f7X+V3t1o4KFnE1FeKAB1yh9QFzgK+kbFezIi3qekTGDwdDvdGucQpFqGe7Nrv6MYPdEB4i1ypfyLSJlM7Y8KdQvw/I5KG3sy+CrJWA1po62WOolswuEA+4lEnItr/mmFhINtBE1QiMrl/MUaBsRu0V+x3gie44uJhUi6ppYFjfS3Pyg+YHF8lQSUA9uPbwo7MaFn+RDeeS0ZjfKPxFU4FVLDXmKLaCSV2Mlc1Z/jz2z0+WeguARodpQdkr4DPkBILK7u7ckWdRmBMe7hSV+353mP8uwynzHw7Qwgo/vXqK3qslzUKcOxuxwv0lOLJ27rgdJKBnb7Iiy0VNk6Qhnnr9PktTfZ7FWXRKFi3eidkuxKrCYAmlCEkCueHiZAhdfSKEddtWL8mQSXK+Wja4xzLiHYRQtZoQcDWuu8+gx0Ti09d9gEvpc/jj0CqPw8DgdGwKfoWDWlV9tVdUCNkHxdFqYaFuK+OmYL0GQyz2vTXhB27ZKjgDq9xHDm/XofxXDL7N75aXwZ2jO6g+XrnQ41sG2wHvJFqsNzM0ksf9Ms1GwXgvhp3xh7fEw8m+RxC3PFUQXm0RHxzz60byg+1TISjfEi1A8NmDFSH5w
 6OefyeN/
 uENEpaNHqAXSqb37L1nSlDMWLv0Z0z2Ulo5JReUKcjuY8LcrAruJ6pMI2x7mUZG1/WVZvh/jdYWmup9Y7FCCBGiQyIaO3ZNDGnjcdXOdKs5hoYyE061O74l/G28UKG53RmBNKVWoTb7LtnkEloEblXDoxEMyWeiuE5QAvZA1uxvtu9OZmX1xXjFiaGWO+49/aL09/yqsIOYLLN5pYhkvt73KPiTIAl4IagzztHPJVmPp+cL/WQLKNf9Ly8dpfxc3b5dLvAqh3ogs7U/nAnklKHisvtTZwCzfPozmLMQncOkrJbrpHjETyfmAP0en/UvyvWNKJ14k3rJDJVTFIzo3eEH1D8KhnWdeNqRvAyt/HDAlA2NxjZzTL6i5VGlSGxkMwKeWD+4yjLmP5uZbhLf3ALDG2ougn/RycjW+t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 05:21, Gregory Price (Meta) wrote:
> Compaction checks that a pageblock is online, then uses its pages across
> lock drops and sleeps.  If offline poisons the memmap meanwhile, a
> DEBUG_VM kernel faults:
> 
>   CPU 1 (compaction)                  CPU 2 (offline_pages)
>   pageblock_pfn_to_page()
>     block is online
>   isolate_migratepages_block()
>     cond_resched()
>                                       offline_mem_sections()
>                                       remove_pfn_range_from_zone()
>                                         page_init_poison()
>     set_pageblock_skip(valid_page)
>       reads the zone of a poisoned page
> 
>   Oops: general protection fault, probably for non-canonical address 0xdffffc00000006a2
>   RIP: 0010:set_pfnblock_bit+0xa6/0x2b0
>    isolate_migratepages_block+0x2456/0x3c80
>    compact_zone+0x1638/0x3900
>    compact_node+0x12a/0x1f0
>    sysctl_compaction_handler+0xec/0x160
> 
> The free scanner faults the same way.  A contiguous zone skips the
> online check, since offline clears zone->contiguous only after
> poisoning.
> 
> Hold an SRCU-fast read section (pfn_walk) from the block check to the
> last use of its pages, and make remove_pfn_range_from_zone() clear
> zone->contiguous and wait for it before poisoning.  Offline pays one
> grace period per range.
> 
> Scanner positions outlive the section, and offline can shrink the zone
> meanwhile, so take the contiguous fast path only inside the current
> span, publish zone->contiguous with release, and keep the migrate
> scanner inside the zone.
> 
> With a kprobe parking the migrate scanner across the offline, base
> faults in 3 of 3 runs and this patch in none.  Unforced offline/online
> cycling under compaction faults in 8 of 24 runs on base and 0 of 12 with
> this patch.
> 
> Fixes: d33695b16a9f ("mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

BTW, the order of these patches is all wrong.

There are much more important fixes hiding in this series. And this change here
would certainly not be the first thing we'd backport.

Please create a proper series that only addresses the pfn_to_online_page()
situation, without different, more urgent fixes.

Because there is no way we will fast track anything like this here into stable
kernels.

-- 
Cheers,

David

