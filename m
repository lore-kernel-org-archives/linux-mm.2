Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF6E4CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A816B00B1; Mon, 11 May 2026 11:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301D36B00E8; Mon, 11 May 2026 11:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217716B00EB; Mon, 11 May 2026 11:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 157526B00B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7569401DA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:54:08 +0000 (UTC)
X-FDA: 84755585376.18.C8E31D8
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5ADB40007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:54:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n6NKt4cw;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20yoGM3whVtKvNYZZgGIezStzCSDmI46twhVwHYN4Ew=;
	b=1rVoThKgVqn0ZSN+dlaGoceWC2CWXXR3nHI+Aofyg1tVb+ubp40aU55TAOQN2vlb8SMISk
	c6VIre0TbxXhjWUAuE9bqYNdTeVjBvEaZj5pq299bi5s8UiJrb/LcPm9iDgvefqTKDmILV
	ze6E4kDDaLGnLMr6jiZ0YWPZ9rSenpw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n6NKt4cw;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514847; a=rsa-sha256;
	cv=none;
	b=W65e8Qu5xqTO2mtqWvg6O/0h2Fq4+FWqJnIz5RdEFuoKnGDXQlR/URcw5zFzGZOQ+ozwMv
	bIROrCFqc5uUKl36GkztmUWoHSmUWGpJG+kGAt0CaROhZkaTWlQpOsHVYAvuciWo4LbSML
	w9pplxl3x/zokLWkxdOW9moOTmAFIMI=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8b62ca1d28eso39642136d6.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778514846; x=1779119646; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=20yoGM3whVtKvNYZZgGIezStzCSDmI46twhVwHYN4Ew=;
        b=n6NKt4cwkTXH/7PPqm+aRgwxq0ktuDnwgJn43oYOQJ0quwcuefTP3lMCWOy0tZ3Z1c
         p1N39e4Has5e/E2aV7GaAtOEzZNivhy5m/S81u8Tfw+g/V96PoJu4ahh3EqRRS9Rcqq5
         Zj2IpMTTSTwe7wevLxKtPCvNWv14zHBu+cNIJDZBoxyLqnKwwVHCvAUfUzLPFGhNCMl7
         O/QNHQFM1KX2W20zLwydk1OjcQMD8k4WG2GdU/dJn9CYe73bYx5hCiZKx9na2OCtoker
         kcpff53dDVeY3h1CEMcXtpnM+xpy8EVHIQS8fqJs8Xw+g5MtjKJoQeW/3oMqDRYDx5ab
         MnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778514846; x=1779119646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20yoGM3whVtKvNYZZgGIezStzCSDmI46twhVwHYN4Ew=;
        b=NpYAVfRTW4KvUtuY0OLppsFEdSGfQFLCmTUHPrEsHVmXbpKnYnc6KfrF9JJU4c9Iwj
         WSRVUs/3YA3VdMqR+UU9lbvMiM8xCzzavsRjrpjGadDlWN4fsWLW6h9zOqTTMVet49Ri
         poMWgCBmJEq74KOr5DDHPuYgFx3AsMZBpxcg0XKAm8AY7fivmTfW/F64YWrjaZ083WiN
         zRB+6XQAsW9qNBgGXCSTqyRMk2nendovxTaRwxqW6nXqcxx7Oz37kodifxRN6HpRTk+/
         8/3tO8OonXxCzXo6GNoxy/InZ/M1lBYq6WzybOCCz1p6xDhIWZ7i1BxzuykdaJb7ANXm
         EJxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4f60/HRDwaGARPEDPzHZhQIvsEq+8a76/LLbkFf6/kbu84rrc4AHi6JgYflA2egTbv2e/wy+Wnw==@kvack.org
X-Gm-Message-State: AOJu0Yx5CcjY0iYU/ZuSIYZRkEltf6XIDxeCrzcfTx71nf9m+GYi/vs+
	DOlq2Xp/fKbtWhzIVrX02Z86XHoeIQAMwP2EtX54vFX9Ia51+njqMMS+z84sccX2rFs=
X-Gm-Gg: Acq92OHCD6BC7Eu9NGNJ0dMJwu2pg+2dBW4P041tjjwQWw5p3jok70NWLaGVTceEefz
	duHcKmI+9G3D2MsY2v1TncALO0AcL7xgWpAqNnPM4GrtgTy/Pd49vP7LSLPLyUpVCxflYpd3BgV
	5B8KB9li18SDU4bt0rZ94hMchYMzJt0KUdkof03pES67aXpkkQe+4gFqvQch/SpQ5i/TAfYrjYp
	Y5FVa4+1/rM0llcUdHqUTOL4+et3QjTGo3nh5catRzqjGCHbdQZcC1hxkVp+ZPeZZtpDj6gILwN
	y01SOMDUiSYQ1/WiFX+fOEltJ7tDrNVIgpLuqBMn1PDGsdM1clQISsqk8cKZGcbqkjGceV21W93
	OJNJezVT0WKQdHSeeb49Zm9yQpSFva+TXb/UxQpt2S8ODII+AXeB7L1X5zSDSkzQxzIqEjWDY9S
	cULoGQCNohiHPTEyiRBAU0wFuGr0Gtvp6hjBIBw4XLVgxNSkuG9z6+E2HrwZFH3x4exY+oPLcUx
	dlQby92WQte
X-Received: by 2002:a05:6214:c45:b0:8bd:7192:9506 with SMTP id 6a1803df08f44-8bd71929608mr325423396d6.7.1778514845601;
        Mon, 11 May 2026 08:54:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53d831ac7sm309701326d6.49.2026.05.11.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:54:04 -0700 (PDT)
Date: Mon, 11 May 2026 11:54:02 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH resend v6 05/30] mm: page_alloc: move prep_compound_page
 before post_alloc_hook
Message-ID: <agH7mtbcEzogYuk3@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <6345727fdfa76157ba0518e2148d1848e0bdbc16.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6345727fdfa76157ba0518e2148d1848e0bdbc16.1778489843.git.mst@redhat.com>
X-Stat-Signature: 4zpetkss71eppzxua36b76zftmhd3i31
X-Rspamd-Queue-Id: E5ADB40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778514846-544121
X-HE-Meta: U2FsdGVkX18KhhGNODPVrj1WI1bzlIFNm8TTd1pYjZXnoXCMXWsQJFGd1a4pPxGxQDIK/XbCdS/SurGO0x/fg1ojB4IX5KEjlGqW4WDuuw9g4TL0QQOJHyy3Cfqi+Jx8vpDmKTmrN0FOhGTORFW/eVDOeBnLQ4dDMBreEUJEHGHszAL5rg0bTBu2ITi8aUjGv3iaQmlepkVJ+TSLwFLtCcn2ff1b2VC6mXWBs59xcHCuI02DjofbWGhm9kCDdlEK28j5MzIr3RfWSpYnzYuSvf1plVrlxsURqGhfplXPgsP4Z4YeX35dEFurtE5pzHAlHhlVIjcbZixLCYA7115O96JRIaEwmKcv+VYxDbRU8ILH/2NOO+8n/y9SBOb4wreLGVK4nEOqrt7358j0oZsE1wn7r6Z7Tz+wb/tUsXLVeWVBoP4aywScux91YAN6xyMkw237B/z7HoxO6qusXQCk3TCxRgXE4w5mz4ZqsCJHbnQP4IcKMVnnjG9XXU8drL6PO5Ud/DO7QesWCVA9lIk99aHTdeiANcvrs9t9e6MI0h1vta01Gj62FzVnHXgeCiwqZAcPcckEniIVj8iEAoY3oKnroqSKslgrcEk6kc7WowG/edXzp0dbRafuQ+QmlrZgsSjxdn5HPOVfCAvb5gfNBI6cunl6JJJXcUes57hebJFvNWaFxX99Wkg2lfwS8i+yqDLoiIJe8pzsBWld6OSeAYPGXtF4s9NrDz1WgdJIJzhuupaNr8hrKCcAaplJi30g4J3DpdSHc90/yknAaVXeyeiouw6ym9OhoGHGcOiKm+NIjbSqPvUIaGbKRSwCvc13ZNDzlO949fP/M0BKizkHGPq0FidCTE75lCELiEEKaiSW1JV0LiWF2Rpq4zPS1XcZjCdmE2sPG8EKK0wNvp7vIs8QNR/l5w/nG4ZonDuIUtJoIIfrWb6IszOqvDC4xbrBCKpAcuFmubl3gPhlALe
 oyJPz1KV
 tXj4hivhiqqd1nqRNEqme6xh0V9DzZhAAYl/AeY0fzakc8p2X0Ix5R1fUCJnY0YINxHUZy8K+kOFUXjlb3THKAZAeFIuGftvenNWLbDYIY64McYbHQm8qoqTPLwAcVU5/66AZCVsZvCLE79SwqIuz9WZhWmtnnIv93ULxOjPAgqUeDrK1iwPmuHDgubYmzJ1m2FO21T05wgZRYVxKkrURT1JO454J84+10jKKXC6q+iqK+hBQCnyU0qr9zf2tT4oC6qdS658OtyQ73fRY9U583avjz9uqiWSZj0o4sddt0fFIMBy27/P1Rln6CbTZfl1yBvmPVe4uY02ijqcxCeAqgcfhOGFQkcacRgwtQGbn27pj9kvDX+BbTEUhvUzRESsVTvZvikl88qY27plwi020m1vXUhsh0BITbBOii7WLD/ZpgQcIgf3j91gX9a9KzPpt9Tq9660huQxtJjM5H15qiYb4hTESZ0uvf/VGjX/HVf3zP3Bk1LJSO02KsOxZu036HjiTU+hHLoTR4OoW+bnezRUe8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:06AM -0400, Michael S. Tsirkin wrote:
> Move prep_compound_page() before post_alloc_hook() in prep_new_page().
> 
> The next patch adds a folio_zero_user() call to post_alloc_hook(),
> which uses folio_nr_pages() to determine how many pages to zero.
> Without compound metadata set up first, folio_nr_pages() returns 1
> for higher-order allocations, so only the first page would be zeroed.
> 
> All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
> debug, page owner, etc.) use raw page pointers with explicit order
> counts and are unaffected by this reordering.
> 
> Note: compaction_alloc_noprof() has the opposite ordering
> (post_alloc_hook before prep_compound_page).  This is fine because
> compaction always passes USER_ADDR_NONE, so folio_zero_user() is
> never called there and folio_nr_pages() is never reached inside
> post_alloc_hook().
>

We can't really know that this will stay true forever, may as well
change the ordering there to prevent a tripping hazard.

Possibly you might want to just squash this change with the next patch
and add a comment that the ordering is now explicit and required that
way to be correct.

(possibly patches 4-5-6 should just be one patch, since it's all really
 the same change, but 4 seems fine by itself).

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Reviewed-by: Gregory Price <gourry@gourry.net>

