Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D9ECD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ECF6B0005; Mon,  8 Jun 2026 10:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFA16B0088; Mon,  8 Jun 2026 10:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE4B6B008A; Mon,  8 Jun 2026 10:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5B96B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:15:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6309C161169
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:15:07 +0000 (UTC)
X-FDA: 84856942254.09.38DF617
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B5547100005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:15:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrSQ6NGW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JjRMFYZ9bfnyvS4nS4o2iK2w7M52sPr8xosvfHngF8=;
	b=BgL9Fw1eHfnA5B2mD07AoFIMcFWOGL5fp5mom/FkYguGZ5pVIWNj+XJ/R+NNAHoBnjQsd8
	2/8xEQ8X9EoV0x5gifi+m4Ll9NFuYPb6GNvq0Qi89cDwxWmvliYXWXL6hRDB4TQQSq4eGF
	QUS0w6n79k5Hb3WyoVuXJYVEvLUI8Lc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrSQ6NGW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928105;
	b=AyHnkh5cjJIq8rwpKahfPA8W4x6HVWHPuPIZKgAwpxmnz9g65JGqX8KBOxZ4tZ2wbkhDTs
	eLVLAdULWKmqLcgBTCUvjEU6q7bpd4kCzIVhR22FVreKM3HHbvkjbfyPfOlQ80Ryg5RZ/p
	0V63z2+9p0mENg3HqGTL/YlLEvPTz/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9333F40A38;
	Mon,  8 Jun 2026 14:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E7E1F00893;
	Mon,  8 Jun 2026 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780928104;
	bh=+JjRMFYZ9bfnyvS4nS4o2iK2w7M52sPr8xosvfHngF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lrSQ6NGWbgbwU+TrG/4asikVamSg3+rK6G39mFxSJGIY2txePMoj79z5wzKfUb98d
	 jWyaZ3wrYE7qZnx6lbMDlzmvoliM9J1192Th8k0MtLS9xbh73nM+0pEV7mcI5qNKDA
	 EUtZQkEIgtQcJUhqW5ZS0lkciWP6+l+H06X3NvRNS3W/sfSxoHWaaPNHNl5UBpZ7u0
	 5EF4iH6EsBBhZGCJ+U89dZiw639QkCq5Iv3mFjpiGYIxrK65bjTZ1T4kWZ5FZfhmhm
	 EEOwEbeU3LSRqRgQHrsv6UCcYlM4h2uZ1kFEDMvNrIuW4U8acH1N3rtFb1qdx9SoqK
	 gHO+8SMrX8MUg==
Date: Mon, 8 Jun 2026 15:14:51 +0100
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
Message-ID: <aibMs9DXuhH_5F2Z@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
 <aiaOZoa2vSCz_0wY@lucifer>
 <20260608094153-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608094153-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5547100005
X-Stat-Signature: 9hbi8zfhr1ygcntg53op5eok7fka11ad
X-Rspam-User: 
X-HE-Tag: 1780928105-649566
X-HE-Meta: U2FsdGVkX1+EQiq0CWG1qgVZ29sAPq24LxJZ0RJKxSIRO+EVNimoOFtWRh58MzQR8NZxrAxgM3KwvZow/OzlMRw2VxjvLw6LGqooLu0z0zY7XbZoIK+rARnICsUxVmNlHmmsWhkLfnWlwZHYJTFjJTVN9BwfEhqcTzZjn9TxePF7MKjLwiOrrWf3N5wc/J1EcCrfE7DbU3lso3bvO3SOZQLRUFfI4/ACgB/dVh5ZuKILxdXo4eOlNMr1AMbmQ3HdB5q4Ujv2M7fDiIZl24ZcQPEMRA232GEvIUecOlXaDRNRh2kYiTsszyQWNJwI23/L6oHgbzX9B3UX07KOzdWUkpB/xwM85fyXGIcRXr5JnhbD4wKmhUyvE5rUfPTYqvfFphWc4azbi5vCD4Lfmbi0jLxqtaC2XMSUkrIQDKlYz2Ikc4qjm65zdKcLfYWQlSPD50nxuCa6rPezA1Vovpl6chgert3RlD8AL0v61KjIebJhlCyZUn57drv2xCcwHJzfEArR1oDmMikgOVhevl2bjQno+gWP2W72z9x1+KSt9T8z/27XKIR8UV6FmZjRrJBxH5OuLlsueA4jPLdheaENAGH+Z/Yqhfx7BbcOrXxr1AS/4bHXfOcodMm8FIvt8oUL/jy2FfSb8nMpHvF/0riLqv6n80pbyZZshFt5a2s8IPxa+SIsvSLBs7h/GTQHr4lj3klMmHlXBm4CYC8ft1JE225STxuQ6+oDFJJ6Rwtg/1djvQ0xXTxbLBLlbhhbuj4cSDlZDozeKexgUWwXfdNbAANbRgLc1jHNvI0p/jLJfo7wPM0K4oBejpU7c6ItuYfWGhMZy8ZHeTCAkrJ19st4I9TnhurU3E9/3nKdXn74iMzMwsQsRGiRXU49fNXon+l1FIxrERxot0KZtA0QDtlH6FVCnpgqwA03hJ1ny1BI4dfocNk5H7Ku3IvqnhCEeMcLgp7/0jh0CYM00todmPf
 ZE443I+b
 bBtm/bmJm1T9Z2HjfX0aS8djhUrX2MVvpk3752pnYqT1qmD9KStBvJrfk3BvlLuGQAb5Csnnfu6AfXSq7PsJ9dtYNDtJn4AUgLnTv2Gp4SLt8lf+zs2Yo3o1WtkU5S4hGy31vqHHAXy02fJg7bF/1eTCRo2yyPygFZ0uq1t93HSxzaWV1b71JxGo5OBfFXpLtRoQnSfBup5iqX34JthWuctY0Ps9zxHOFhA7aDc9ZPZ2MBCdgdMrizn8NMvM/9KrXlF8h84+rcvln9qFFd4t/kMIly2mQnz1OtgVP9T4HlBgGX36irXwIIC+5WaQBt9MtAS5I2tICs1JJSybISn4pM/ENJ6tTI4GlQ0+61mRzaGCzjnTCCw9LvfftTDDvRq7SMe4HWsmGY4Jl7Or5162WYv/+BXytWMeEvQ76ZDkBQUpXWXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:48:34AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2026 at 10:43:21AM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 08, 2026 at 04:34:23AM -0400, Michael S. Tsirkin wrote:
> > > TestSetPageHWPoison() is called without zone->lock, so its atomic
> > > update to page->flags can race with non-atomic flag operations
> > > that run under zone->lock in the buddy allocator.
> > >
> > > In particular, __free_pages_prepare() does:
> > >
> > >     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > >
> > > This non-atomic read-modify-write, while correctly excluding
> > > __PG_HWPOISON from the mask, can still lose a concurrent
> > > TestSetPageHWPoison if the read happens before the poison bit
> > > is set and the write happens after.  Follow-up patches in this
> > > series add similar non-atomic flag operations as well.
> > >
> > > Fix by acquiring zone->lock around TestSetPageHWPoison and
> > > around ClearPageHWPoison in the retry path.  This
> > > serializes with all buddy flag manipulation.  The cost is
> > > negligible: one lock/unlock in an extremely rare path
> > > (hardware memory errors).
> > >
> > > Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> > > in this file operate on pages already removed from the buddy
> > > allocator or on non-buddy pages (DAX, hugetlb), so they do not
> > > need zone->lock protection.
> > >
> > > Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > Can we have Fixes: and Cc: stable and also send this separately please?
> >
> > These patches seem like unrelated fixups that you've discovered along the way,
> > and don't belong as part of the already rather large series, unless I'm missing
> > something here.
> >
> > Thanks, Lorenzo
>
> I think you are mising that they are a dependency, not unrelated.

Then say so.

> For example, this issue gets worse with the patchset as there are more
> places that manipulate flags without atomics. No?

It's your job to make that case, not mine.

>
>
> You are welcome to send this to stable, but I think stable rules
> preclude theoretical bugfixes.

It's a dependency but also theoretical?

>
> As for Fixes: the issue has been there for decades. I wouldn't know
> what to attribute it for.

Again, your job.

>
>
> I guess I could send these separately, too, why not. Not sure
> what this accomplishes, but hey.  But is that an ack? You want
> this fix merged even before the feature?

I already made the case as to why, as have other maintainers.

If you need to review what an ack looks like please consult
https://docs.kernel.org/process/5.Posting.html

Thanks, Lorenzo

