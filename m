Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CF3CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DAA6B00AB; Mon,  8 Jun 2026 05:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE696B00AD; Mon,  8 Jun 2026 05:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E45A6B00AE; Mon,  8 Jun 2026 05:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913116B00AB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:43:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EAF51C2A6C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:43:37 +0000 (UTC)
X-FDA: 84856258074.29.2CB65C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C46F4180004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:43:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FG6271fy;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780911815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWzNwd41K014rRzleNCcA3bHTWanKla6egxzBAWBDSE=;
	b=VC3T7oC61T1iJ2zU+5Ox6bn/AUSpjKvUtp+wdam7LcRFSKXOtpywfeb+bmxr8CFpR9FDjh
	Rg3oAPsZDsps2qDnNMyNpV7TWgAPtnD+6908Y9JSXc3HATknt0vjK524dBvJ+zyFgYZJ64
	l5VEVlFmB2vAp9OoN9beARkeTqGz4fg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780911815;
	b=g+ADsHGYE0o6tjMSQgyWoHK8T74m3a10E3J2P6S+aQrVUvOVKbL+vaVkGC+qWN+bDURv7y
	rj3CoDJZBDsHzd2/ukHpV8Cu+hDzF+Ydr5rpsshkTeivQoB0K93rHn91EzgA6tC9fCx1ax
	1h6Pkt88D+v33UylW21LxBtonCTyxqk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FG6271fy;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B604843915;
	Mon,  8 Jun 2026 09:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FB91F00893;
	Mon,  8 Jun 2026 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780911814;
	bh=NWzNwd41K014rRzleNCcA3bHTWanKla6egxzBAWBDSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FG6271fyWdED+PCEocy1/8B9zEZikn30HwkNdCmZM2JH0pcqFK5H6+CtzcXXt0EDY
	 fRTPOyA7R6sPYsZcfZ8+Hey3Z0ZXYGI4wQqrXgKpC1xFjJjQQyeEA1dLg/ACBKk2PK
	 6JiKAnszdqKmvXR1Lyq75wgNuznoXK+fYknlLtMVmctJJTzh5YaUGFc005dDMb85WI
	 Eu2ML59W2SP4WEUSYk/pvv3Xvk4+bLgT0/oyStQBYuDynQQBBEvcA8WNbrwF3zCmst
	 e937L5T05nDdGOQ7RdulyfDazoZqNmRtiN4VnLvJ2G5NIeKwB/UXzIZ3KnpA5jOamn
	 ozOEQnZPyPmZQ==
Date: Mon, 8 Jun 2026 10:43:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, 
	Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH v10 02/37] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <aiaOZoa2vSCz_0wY@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C46F4180004
X-Stat-Signature: g6ius443jedpxpi1zbjh6xctyomrpntu
X-HE-Tag: 1780911815-254651
X-HE-Meta: U2FsdGVkX180WWc+Gyo5L+bgUbGHrVu2ncicKOOULnO9vAwJbyBfiGeuJF4IRrYoktmPFAZqzgkHcUwOdF7AXwPfWUPdN/LSsuvnzEJdXGiSo+6v5kqhTicsteSwN5rVBdbMqRg8u9ZRqk0kn+Y2vxGvXKWCDwRLVQlhRsiaoWFaMPy29b+MekgxX2DtKx46dRqmOq3YHL0hA6GFNo3SUYMbGsCGprIewDKYI5UJeiwB7nDMJ4B/5M7yy7psvo+8x9iXN7d0G/Oe4UZA73mW54z1Ul+eSAXVEsbvLwI1nwHUISKWEesVsO22tAmg7MZirmoTRRHxv4PH00DKC8GGidOLs4EsiV4S1KZOWS1SNBhQdnXQKY8vEivCdOocSXjAlCn/cRicRq7Nt19RfJ7k2ywfpVlan80gZEnoNQWAWGBeVjXh++9OXO7YS0oKGDz18qkigI0FtwXPHmtzizChqeLuz31Esx0Y3YHymF1Lhr/3jidT30i8vFxGhPUwKx9V7KZrzSD9TYz3Tho5s27RZ0EQlJFdQlLthUZoVyl8WNWKEQIMc5aedIE5GPoCvBkVz9Mbv7YTRCoRsI3OxLIuVg/9Lfn2POG+hIjOzr9yt+tyuF9wkd2SIIvfNHDVGbZZEK6IdiZYtdM6sB6aVqysNb9Bd2ePtsNRyt/Nac/uAMJRor3rcRDMRPgrOqmubyKcp4nbzMNkmQ9VCGKx15nrfXwKZ3habgjeqkZhmViwKosJy1gAwOjWWshxGviQFOcEc42DRPTzYjII9bbQXBYoivZBCcOv0HItlrFI9qnQn5Kc6XgmoQKHIVM2YSEBc8pCcxqwQ5HuXs3My5Uf9lFyDlt53KWjEoMs/5+KFQRM4Cg25AyalogwmJtk6kxjsenDJn2y3xdSAIy6lsxRtgBvrjuxFdQBP6GhlQPS33XE4rVsmYF5wpJxkzA97PQfAys554G93sWUF/Mj5CayGDG
 V2HS2Opb
 zyWOHcbv2KK2tZHYmZ642h3ppTy0zK39SMORmnrCZiaFWMIu7UO2VwcwuBXAtsUlTOIqM3bJOnDkWJGzsUmn+ADOnYtIUK53kbQIX2nBRK+F/F5TjU2xnI5gJtTTCUqrC7K55Ulj6dLs89fWgGw8RFHlleVBbfc4/eOS2AwBbZSARSSkUHjAQyF5QSmst8g4EgkQe4Vs02CUGb2W50j4Hj/4C/SRUQlZ3KHqLoemjutph7Zxg83VRJH3KWbh0w/JwnbCQsDaTj94h7v68puQ2Asw6DxAlupvfb9EHx2L+xGds5KMBansD55rurtnREj+KWS1tOujrEqa3emSW+2po1c6Ta1CfFyqA5/heFReMnz2Hu2Ea9JtEvEXNcpmMwC42vnAsWk6gGxLzN4GEfoMBoBD3oyKt6lXEeIjto0mo+4ryCd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:34:23AM -0400, Michael S. Tsirkin wrote:
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
> is set and the write happens after.  Follow-up patches in this
> series add similar non-atomic flag operations as well.
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
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Can we have Fixes: and Cc: stable and also send this separately please?

These patches seem like unrelated fixups that you've discovered along the way,
and don't belong as part of the already rather large series, unless I'm missing
something here.

Thanks, Lorenzo

> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/memory-failure.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..3880486028a1 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2348,6 +2348,8 @@ int memory_failure(unsigned long pfn, int flags)
>  	unsigned long page_flags;
>  	bool retry = true;
>  	int hugetlb = 0;
> +	struct zone *zone;
> +	unsigned long mf_flags;
>
>  	if (!sysctl_memory_failure_recovery)
>  		panic("Memory failure on page %lx", pfn);
> @@ -2390,7 +2392,11 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (hugetlb)
>  		goto unlock_mutex;
>
> +	/* Serialize with non-atomic buddy flag operations */
> +	zone = page_zone(p);
> +	spin_lock_irqsave(&zone->lock, mf_flags);
>  	if (TestSetPageHWPoison(p)) {
> +		spin_unlock_irqrestore(&zone->lock, mf_flags);
>  		res = -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
>  			res = kill_accessing_process(current, pfn, flags);
> @@ -2399,6 +2405,7 @@ int memory_failure(unsigned long pfn, int flags)
>  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>  		goto unlock_mutex;
>  	}
> +	spin_unlock_irqrestore(&zone->lock, mf_flags);
>
>  	/*
>  	 * We need/can do nothing about count=0 pages.
> @@ -2420,7 +2427,10 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> +					/* Serialize with non-atomic buddy flag operations */
> +					spin_lock_irqsave(&zone->lock, mf_flags);
>  					ClearPageHWPoison(p);
> +					spin_unlock_irqrestore(&zone->lock, mf_flags);
>  					retry = false;
>  					goto try_again;
>  				}
> --
> MST
>

