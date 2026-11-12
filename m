Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D2C606D567
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=It6ShDUP
Received: by kanga.kvack.org (Postfix)
	id 493886B05C9; Thu, 12 Nov 2026 09:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B0E6B05CA; Thu, 12 Nov 2026 09:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A4E6B05CB; Thu, 12 Nov 2026 09:28:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10C246B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:28:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADA41A033C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:28:18 +0000 (UTC)
X-FDA: 85426697076.28.F24C37A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8AFBC000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:28:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=It6ShDUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGHAVjE9egfx0TL5yO8Wnc3z2E6MAvDLE5lotamLz9Y=;
	b=Ch8IOSiDUN+SYp5Y2GprBnpLeBy9NgzkcJUg9i1poEKMqIxWQ9w2ynfcU0zCr1RQL0AmkC
	Ltxm7Wbknsv+d1F4X4xF7TXbx3Iiy9llLtGRClJX6XAQTfEDxogwLHaQMEsEuadDeOfte5
	4qA3y4vENPU0pLibrVNhV7lNAXIC/1U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=It6ShDUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493696;
	b=IaXWIGuYPug7/yAAFvtLeSFyc1QZdILAb8LUUKLOE13rDuM1fcon5jOShuMrREZjOpJ73C
	wPtwRUQyxgSOJQ6mdC0VH+0vJZYySJrZJTUu8HGlyDDnNkVpTMQyBBpHJ1DHABrGSJqZd9
	53WpMo+4AGM8k6AP7e/QQtokpfexx+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06FDB47A4B;
	Thu, 12 Nov 2026 14:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665741F00A08;
	Thu, 12 Nov 2026 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493695;
	bh=JGHAVjE9egfx0TL5yO8Wnc3z2E6MAvDLE5lotamLz9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=It6ShDUP3loVhSB1J1dbWrBQs+P2Gd854WRFTGxjyH79q1OqnygFSFFTYtangJfzL
	 6ZYrOu61zkmI/Yueqt3O7svgOeNiVf59mBL7QTBBhLGyNdZjJRq+1CMdlypAYvjVHH
	 2HQTSTM7A/tODM2qZQo1rb3vxekL/QPvVXMi+1KuTskPhdgBq5zKg5Lec3G+lcMX6w
	 vBdcwDp11P4HjFIVbk8C9nczKjNlLXr7F2BRRrmmY82ENP6F+MYwpCRl1HnOQPvaiL
	 uYYb8QJmYd0kf2rxWMyalzN87Evghvs708tKewKQofWbkXNwAh9hzdsJvDsCJN4E9h
	 rZAfCLpfooJ8w==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id D3782198003A;
	Thu, 12 Nov 2026 09:28:04 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 12 Nov 2026 09:28:11 -0500
X-ME-Sender: <xms:9Mz1aow8wOBRRrvcBTNdEbXatcZVGj3_VkmONVfV9u7cF28_kRJWCA>
    <xme:9Mz1an1n7GllvM6tFpr0U77bzzoZeZzQ5jFS4Vgl2E9ZPpBnosrwQvhmhfUNYbkJc
    ehuI-mtzsc9ZOSZZMSqYmC9vQqOdr0OE0ZmZzJKkbMznmZ45kqjkRxU>
X-ME-Received: <xmr:9Mz1ahUD8IO9wm4Hx1pNkUKSlEi8MakBOzQ8eTsi9tE0Qa3an6CHg7cin58>
X-ME-Proxy-Cause: dmFkZTFTIeiygbRCBA1nU4GEH05qhStamhmNSoX0vHPTYZdYgAMI+CMH3M3m9jAOJmtlqx
    4CxZn2goV6sPlbh99O7NOAxJ082JAqSwWcexA+j2sCeoqqSCMWizR4n1VLKNjNnjVLK8z4
    FjyJbbS1lT+ccXhQhAOQ6e+pGzIY5WNJqZA/1/7tODdBCIL8FBdgka1io5Mnhan5LYD+uE
    IPip02MQ+Ux0ZDerQGeC0PcqiZpBPD317wk7pWyq3SMCU7w5oTRFis8+whrQbxVTXetaHA
    A4dynw5FjykDkomkb4d9RmZNDszj76xdTTB0vm2rGWEreC9ICrVcQ9IbeLBVw+LV7Q7nT6
    O0ECVWoP3Jb06bLRKhhGN/jTAwjd+4ax3nV0kC19Cr8N73m0yC7QMcEWorcQKcAEKBtSES
    VoHcAVKgZjLeLpbCJhzS0to/BMGFk9x7IhCReJWSoFbx/iRUD/KypKv1iJJbOz1lsSlKmq
    EDvlWlD/Hs7sX8NJ8/9F5msOAYBCwQ6QBXuDT0aTcaI+4NqPR5Gs6WgyB31fRCDp6ZFgJw
    Mp1YOoQDNX9Gtg6M8/ydAp6t5cRtIE76QMGBdQvmL3Ony5AnW+954zST4t5TUE9R0b+CY3
    xLsSompzBNs3kwgEp5MSu84k6BIefMNejtFogqv9QGMLkiet3f3ruQ8whz/Q
X-ME-Proxy: <xmx:9Mz1aoJRry5AJkZ2MMVegsOn4HORQAooppu7YhbjeEZm6HMAXD_67w>
    <xmx:9Mz1aqc8J3nMWPYX6MUv9jZJ85XR2Er911GLJsaaVySsdOkK2I4ReA>
    <xmx:9Mz1aoQg2-rFOKOjAQEB52tL1uK7s6qpZScuVwYbLi3akUwed6rNOQ>
    <xmx:9Mz1aspVfMaa5kgLYS33tyPN9gJG0YTo4FRhEgoCoLV5zJuJdqLZCQ>
    <xmx:9Mz1ahVhJJuv7wJcZRyyDnz7nbZ8VT7_UegZKk9UfI6OYC_FgQZuanre>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 09:28:03 -0500 (EST)
Date: Thu, 12 Nov 2026 14:28:02 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v2 07/18] mm: free the pages waiting for a grace
 period before isolation fails
Message-ID: <avW-RbkC78FkS7_n@thinkstation>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-8-kas@kernel.org>
 <sashiko-outbox-199100@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-199100@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A8AFBC000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: mo9dnhzktusceytqxie5ixn7ysj4gqy5
X-HE-Tag: 1794493696-724878
X-HE-Meta: U2FsdGVkX18To2n58PcQ/BC2PGz7+ykOhKKbkyy3uu2gjUd6CdM9VbRscy+deXdQ49hnsHWlcejQvna6NcfI1OuvanBJs2hDSWeN2tYb6e965pL+dkb0ylrbOYJSEXnDBhaQR6X0P4zSqmEn//zf0GAQkuy1OohiIrHUNMs5rLUsfa4KJhb3Wb7ySGX5dupNVh0yURT2hJ9eSxV6ZP/QRv0+sSxSyFZoj/qcGC7XRfv4L/lEO/kTOxa7m8Cr/bSQ4LRSRvxSDV0Z4dF6F+0e7UJJyLf1zZtZw88PoC7nEHQJ0jc2bvS5KOm5eHB+eh/8PHVuNSh7kQNm9x5bZP1IbE1s/8iJwTwPBjVzi752aGPgaej/BgQzACSUVieaezOoAsPGpuXvq52yRN6qZVvwpXrWV/aFyGX47RzQ7Nxs89J6372xvlaTBzvb526VWOtk0ZJB5aCsgSCgXmVU47N3vogiWKIXfjTZOUegZ/wgVBeQu+BOC1bdN/u64GhZQP/Qt0ESv5cLdxhfgJZnsi+EhdCzHTMun7N+4Y6W3bKjksCxR36BuzEM+UPvgfgIcehB6b/VzjFLnOq3WUxoVR7W742YRUZVmvecKZBTqFc5Z2A3Xcere5/VTYimv10J8YIHDoJ11Sf/kgTlOmv3CaBaOP2puY5ufCeX06yiV8lMxFA1/0ZWCEj/nBPmlHrXA7S9/Rh03AkdeValQCBsa1RY3mAB3cqwjj5XjwLTg/SU8n6wCn8VTbmGaeuIHT0gqDa5dTTBlR4xGgRiWQdoVu8QFZSAjz61MZig6clcZZRv0p/KCERzJ4+tvpBf3ifFc1xmsqulKMurHmFc7OyilaXXaDZc5PCaxqDM1su02bJDQ8Y7VgpBu5Ra7TOq5wfP3QMuzAHdJUz/APyXeZeHYw9SkFfHi4ISXUckcDFWmr/PAA1mYMHusXenLHFaE+edj1jvCgCCd8Cl1LwbMAn3fzZ
 NLnwJ3re
 ojiq5AmNVHcOcGz51wSOoXRAP3OWSU5a07y1/CEFP0xekDA7gmHCogXR9bh8E8MLxxZgwHPuRmdxno2fqovCbMAK6qnZKr4/+xIYmlBPG2xa79+HyH979Fx+M8LI7DDv85ugUPmMf4LK3BLhBMRj7+SuYQ3lM7juf4sfoAIbwRUC65k1qTKnjbWHq7CDQXqbBWFMXPptrS6VL7QBBSJ2b42DocpFiwwpxb53a2uWf0Z1OhjG5jAlX3ZNAlrPbEVWT508ZxgZksU2jhT/6vYya46/D/NV0HfTcC2Vfs4UoEqgHIatSap20WC/YFRe2qgDN9ucXmFRsAjhN9ek+5isVNCLfP7eD0RgbuyrJjzkK7fbK3YNJdxTcEI2RtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:03:37PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] mm: premature NR_FREE_RCU_PAGES decrement in rcu_free_pages() skips sync

Only the zone's last batch can make zone_rcu_free_waiting() read 0
while a work is still freeing it, and the pages reach the buddy lists
right after.  alloc_contig_range() fails as it does on a transient
page reference, and offline_pages() takes one more pass.  I don't
think the window is worth closing.

> - [Medium] mm: stale outer_start in alloc_contig_frozen_range_noprof() after RCU free merge

The first case is real.

In v3 alloc_contig_range() finds outer_start again and re-checks
whenever the check fails, not only when pages are waiting.

The second case is a free racing with isolate_freepages_range(), which
can happen without this series too.

> - [Medium] mm: page_is_unmovable() treats freed compound PG_rcu_free folios as unmovable

Valid.

In v3 the flag stays set until the grace period ends, and
page_is_unmovable() counts a large folio with PG_rcu_free and no
references as movable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

