Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F249CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91516B0005; Tue,  9 Jun 2026 08:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42656B0088; Tue,  9 Jun 2026 08:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30B46B008A; Tue,  9 Jun 2026 08:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A18106B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:50:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 619FC1205AB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:50:29 +0000 (UTC)
X-FDA: 84860357778.27.D133456
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F8F4180006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:50:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cdt+CAZ0;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009427;
	b=RUiec+xL4fuCir+1CwLRnf3mrvTfoge14C3O5oA/aP9+7ee3YByJmIro6TyrYPeb+efgDV
	0VvxVApmqUoKCITIZ9jdcqkFtIMPLlyW3oGwoxkamul/NP5rKjGqWXJ950bpD99VJ+je1r
	3wHfbRiyL0mOIqnelWLA+eEisq0wgWU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cdt+CAZ0;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdHGTwdDjeOX6/H0pQYNbcK0Ox1mB9eHL0227/K+pZQ=;
	b=5FuK4Fz3IPEEd+2sUnKYL9o2h4cUte2MxzGuibntrZwUlV6zW+zUO95Rw+imWI0Ag7LrOD
	JPHYp1sOcHbiCPdWEvT3N0c/SwGERs8LzMtVcXvw3pBUgtCcU2jI7QNS7/5CSOdRNeHOvT
	WxW+AR7PgNjAV3v7V7bkjB6A0o85hn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5730242B65;
	Tue,  9 Jun 2026 12:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CFA1F00898;
	Tue,  9 Jun 2026 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781009426;
	bh=bdHGTwdDjeOX6/H0pQYNbcK0Ox1mB9eHL0227/K+pZQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cdt+CAZ0XV+OoPMVLwWScdwFiyQQose8vQjGgXSlQ5j29RiUUsnRQ4rog57EpXEDY
	 crkIpW4Ybx4oBYjyjoupfH4IzVknrSUyol1Lj3ExMnokWCQPAovYKJkv0Y8h83wGsg
	 nLPQKZ/7Oyygvt9Et78ivCsznofChes7uPrduaB5ODPBq5szkK6pc/cL51P+gv5OTj
	 zEBWvHSKhagX1kbRwKLuqnmJ1whhMNyamiakzxFrnaCtPKIEDoPJz1gfDeY59CNttH
	 ifa5NdxZtg+2rXTz/ZDKWR/ydteYb77bqOgzMeNCwfc/BR7IjgFe/aj86u5hWnlz4a
	 Y3aPafEDgnexg==
Message-ID: <ca50c71e-2350-4958-b30f-a041f12e6f8f@kernel.org>
Date: Tue, 9 Jun 2026 14:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F8F4180006
X-Rspam-User: 
X-Stat-Signature: u5qdcqtpc5nn33h4pi3jofe61rhjgb84
X-HE-Tag: 1781009427-12281
X-HE-Meta: U2FsdGVkX1+gcRHAV0eHKwDuN2g0O48s19inypYQ6RUvPTd0B5r3+C+3vkb9DDiSB143qcp7gS7J2X4jbMBItjVXLwJWRvgKlKMUkqWELqtVJ25WhD3GVMcAa8I+H6VBYBzHOh+oeH+pPqm0k1cioWMZlSm3vejbdRLZHcl+66bM/ly/019PzAPr43fNAJNR5fTyKv2CTnoXGwI3lT9fRCzA7GyWaGAoIkZrN5g6cb2A1N8b0krYsl7B+3INCFb3dSIjanpEiII1l8aWKt+tJdUYPNNy518mKaVt8l7wa4V0ID4pZJCWRZDYr9MSXMC896YGOLnDfhme3iYM1ybuu30x9AWFpGfEVbhVFoa41CxowV3CIonyCUq4BnQOnU2Akky8bMz5K7L7gOQQCcw196YgpYqCcdpGhTJ4KY1kq04dB6hm9SCNz2wcK3yYuiHz6eo4lBcKUzgpghgpkW32NjpfeUwWNGPpwY7TmXv1cpcsOdyU000bcbd9dlZsv/OjnksGLQIak2SOfxaAKhqntYU/+uAsE4d1rCVQnVHlG4vTeT1YULFVPqyN1EgtX9o+8G1f1Y332h9bA3bMH81UoakG3HcOgeo1+RxC1zjAvoJK+q3tvI3L+p3pyMHm/T+KmjSwHbtDzzczZiwi336l0hE7MMQscccEznrxj7XLBFvzFo5Fo6mZuOipMsriJDDrPcapfjrcIC2Mg8zUFhW3VVrIMx6MWF17BBHjvbpzUb6jq5Mbz5r5sTot7mlqzn2CmPdqF5HeE/tmV+hcahNKV2/MQ07ObLVqdtJjFWkgsZ5fnGlfXwK03mkmH4vbAUfQT2IBunI5Nq4QT5xGWdWaGVVwKCjfZbyiI3Lw51BYOZLNKdyz2mEu8HkoXpszaAYlEl2rJjuOdjc/+PJhdhL9W+2kt48YWJbZ3xXX9qbau8hqRVgqtZWgrm4jEj5VX/+/FdXLqgSmwcCREgLMDjz
 4TlOLuoC
 tDvsA8Ahj3RA4/uxhfjrekvdmfg8d8MELa8sk+r+oa0DKTO86xWY40kA6KkQTDBtZ/AWe+/uCZgHXaRb27M9acqDVtnmvHrfTndkh6TbtECNXH00nc8tCZLdo3J/+7w+NSuv92AgbmLRx8N8pJWWC2MJ7DEt3kQNbqH0jczwDbP1aZzsYiWfjZUsHpNaCl2iTQLh+z+icVNoMjI8eRy+8DBP2zucQ434RI/A+wf6yjuQu8RkGgo4Lx6rZ3Pg63hIXLXiOkg2Iyq7ypzklamfxpPX/7NBbFshzOXfQ9nLsnMpfCsflNC6FO604OXJLXwQGnvts2gSAyp7sWl9uinypWd+kDfUeeTm618T4BLYIEnsDVZZwpvu0BDzoMLoEESGMHmaEnVB5VkVY5/wbgD1uqUEJjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 12:12, Michael S. Tsirkin wrote:
> TestSetPageHWPoison() is called without zone->lock, so its atomic
> update to page->flags can race with non-atomic flag operations
> that run under zone->lock in the buddy allocator.
> 
> In particular, __free_pages_prepare() does:
> 
>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> This non-atomic read-modify-write, while correctly excluding
> __PG_HWPOISON from the mask, can still lose a concurrent
> TestSetPageHWPoison if the read happens before the poison bit
> is set and the write happens after.  Will only get worse if/when
> we add more non-atomic flag operations.
> 
> Fix by acquiring zone->lock around TestSetPageHWPoison and
> around ClearPageHWPoison in the retry path.  This
> serializes with all buddy flag manipulation.  The cost is
> negligible: one lock/unlock in an extremely rare path
> (hardware memory errors).
> 
> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> in this file operate on pages already removed from the buddy
> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> need zone->lock protection.
> 
> Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---

memory_failure() is documented that it must not be called with the spinlock
held, so this cannot deadlock. In particular, we would grab the lock already in
take_page_off_buddy().

LGTM, thanks

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

