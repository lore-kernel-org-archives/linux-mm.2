Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED3B606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AT4Au7mV
Received: by kanga.kvack.org (Postfix)
	id B53C16B05BF; Wed, 11 Nov 2026 03:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30996B05C0; Wed, 11 Nov 2026 03:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AD16B05C1; Wed, 11 Nov 2026 03:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849936B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:20:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 185FDA791A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:40 +0000 (UTC)
X-FDA: 85422121680.27.04B9132
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67141140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AT4Au7mV;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384758;
	b=E8JlP9GpDvqJNrXJpr9+1uNbRc8kDnPm2WY2Z5fLe8DRrvBo2YZwOMr5gK9WBE0+DIYFx+
	rk3xIPkW7SvkXPqmCStIv7oCi4stG/KUv1O72CofAVE2Kt+WJlJV+O+O27BF+iaY6qzFzF
	j2pqSWKTCnqgYJerVE92rXGL0t6d2hk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AT4Au7mV;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOpaFrA5WG6cRTCN6gZ0dyNSh1aJ9ayc3GdsVFIh8g8=;
	b=bM+A9vco9Ry16FsT5soT8Ia6LHUMpEMAbi8T9NVAPX2GBXlB1wRl3lOt36rLBqUr2CrDGl
	iv3HJJAiEl6uT4osdv6pKJeAYXy7xFTLFivQxp+QtRT8rsGKHLrxUy/QBjQ5E9n7uyNi2C
	rlQsDpxsxJgBpUUd08b0xA0/6ErDHY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEC1F60DD9;
	Wed, 11 Nov 2026 08:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8125A1F00A05;
	Wed, 11 Nov 2026 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384757;
	bh=MOpaFrA5WG6cRTCN6gZ0dyNSh1aJ9ayc3GdsVFIh8g8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AT4Au7mVz+nz+pxtKL2YwsNVaLoq55LneXErwbkRbtJk3ZmW2DUML7Xu9QZnlF9sq
	 YeJWnKorrTuaJCBmWnK4xzP+KEqeWO0czNM6mByfCApZAyjcQq9nqVWnE1Gis1KvIe
	 I8wSwpw7/YWwF1wwJ9juXoweNKt611pW/eCz6w4PdGcvq+4v99U1evfRqbPpfjKodN
	 G/gARu/Fmvi0tdVi/tBelpvztJsg7mC4nErNxAdJq2TrlyucS5oZyh1o3msHBObllv
	 Qpnq0UqK9Mbr33DZfb3Hhw5KwAsoqE4zZvkDsHHnjnwVapTC8wcXG8PvXfxj5hnYL9
	 GSux4VBNa5ktw==
Date: Wed, 11 Nov 2026 10:12:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, balbirs@nvidia.com,
	david@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm: optimize HugeTLB bootmem hugepage init
Message-ID: <avQjbt-QUp-W3_9v@kernel.org>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110114859.76343-1-lizhe.67@bytedance.com>
X-Stat-Signature: ktyu6xxi6naetmrt5ek754ufe7h7hupj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67141140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794384758-416286
X-HE-Meta: U2FsdGVkX1+YvsNcfDXyQ7FdKz/EqVkwVnjHzPKSxKDMm1YxPYI8Aqh6vGU1Pwb6TIdDkIIl87c2qP5fP2C07roaNo2DvITBKVdZVv6fMltp3Johq6AlGM12FeVBpCqMhDBcdjDLGPVlHtolrqFqBCEUwwTgUHzJ8eI6Qu3tn65iM/4ZyO704RsiBxqsWqNA+VuALk4IhfCNH7/1zD9GBwXC7J0iXN0NJtnspLUe6dcw7FHFSIvBb2kMNqteG1ph+i1p76/B2QYjtJgidci6DyNG4+nUz01u0j8EvIn5gmcPMIp1u6DtosYeI9bZoYoMZy2RGQeUh9uXpNvxaNkHsdkZ8bOIyW7JJUjhKyh2iS0ZE0Nyp6od7HHCW3GlIy+VPcmBxZwFDB89ND+aauUT8gFGPYVtEO1x0x2wsUdg5ZJ5yAtfR+HLrpeDVEM0njkLdeKMPFhghrHqRxdF0F15HkilzzA9++mllDVJL53kY65MdNoveCph8+4VBdnZq/Us0Yiu6lXJXC1G+KRU6tt37YsJkvB4DEFIpg/66oM8vyiKaZMuZZy90K8zzX9DmEEwRh+vE4SUK3jjZBgVIQEjc26W1TETRpXoJMM6EhoUvVbdCttCvs9eSVdQv5uHbyJHzm7+kt7zBXCnhtwvXXGgQhJ6ot+/QAmBUgkhAuTPAdfapNvKr1ptPQSx85EKnqPg0mqI1Z+s2lov5s4PtOi/uSiy6QxjsQo+KpUS07gYRNR7NaxblsV00vYjv9g6xASoXui6r58R5vjSS7yuEL06HCfouJK1frfpf2c0XtEspBIr5lE2U/18dh/qpAb400DZtiB8sOA6r54elGlaxslfniYuuyelvAiGeF1Grs6cZxUfHCbjclBR+DNCi3Bix8I78o0c7yGAsVra6i6GONA8Iyg93nlRNf0G+4s+IAVDvsLtAbszS9nHnz/P4L5QlCNm9a0UbuDL8sPj4yDcS52
 JxLZ6Jfd
 H7X/kLHUe/oAjLzkQZEUycdC5GD3tp9VljprQkc1IIOdIY2gNj77iH7aNbYKJRBRLyU+Jg7pUhvdYbctmMleoT60+vn9d1lJrs8iR9u9zTuODiLmCoJEUq5ggeNxUFogf94ViJbGhrULmkL/F7I48kpkZ+2BP2o5/UnQx4U0migE9Tb8idLji39qTXpsxR4BT5he4+wKiodb4+lKD/CAFTcm0iXOcbXbMt3PiLtq8uqoezVxAILZlxFe4o9ViJCUg9RKRPGUPnP4+hKZYn9gYIvpWgRjFIlU1r/Y+B5k9Peq/KSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Tue, Nov 10, 2026 at 07:48:57PM +0800, Li Zhe wrote:
> This series speeds up the fallback initialization path for HugeTLB tail
> struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
> optimization (HVO) is unavailable or fails.
> 
> Patch 1 factors the existing ZONE_DEVICE template-copy operation into
> memmap_init_page_from_template().
> 
> Patch 2 reuses that helper in hugetlb_folio_init_tail_vmemmap():
> initialize the first tail page normally, copy it into a local template,
> then initialize the remaining tail pages by refreshing only PFN-dependent
> fields before copying the template.
> 
> In the earlier discussion, Mike asked whether the same kind of
> template-based initialization also helps the ordinary struct page
> initialization path:
> 
> https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/
> 
> I tested that direction as well, but did not see a measurable benefit
> for ordinary struct page initialization. The measurable improvement I
> could find is in the HugeTLB bootmem hugepage tail path, where gigantic
> pages can require initializing a large number of tail struct pages when
> HVO does not cover the allocation.
> 
> Tested on an arm64 QEMU/KVM guest with 4K base pages and 64 boot-time 1G
> hugepages. HVO is unavailable on arm64 in v7.4-rc1, so the fallback tail
> initialization path is exercised.
> 
> Results averaged over five boots, measured with a temporary
> jiffies-based printk:
> 
>   base (v7.4-rc1):  318.4 ms
>   with this patch:  202.4 ms

Are there numbers for x86 without HVO as well?
We need to be sure this does not regress that use case.
 
> This is a 36.43% reduction in the measured fallback tail initialization
> time. The temporary measurement instrumentation is not part of this
> series.
> 
> Li Zhe (2):
>   mm/mm_init: factor out memmap_init_page_from_template()
>   mm/hugetlb: optimize bootmem hugepage tail vmemmap init
> 
>  mm/hugetlb.c | 20 +++++++++++++++-----
>  mm/mm_init.c | 34 ++++++++++++++++++++--------------
>  mm/mm_init.h |  2 ++
>  3 files changed, 37 insertions(+), 19 deletions(-)
> 
> ---
> v1: https://lore.kernel.org/all/20261105120615.16817-1-lizhe.67@bytedance.com/#t
> 
> Changes in v2:
> - Add a comment for the template-before-copy ordering, as suggested by
>   Muchun Song.
> - Drop the empty-range guard in hugetlb_folio_init_tail_vmemmap()
>   as suggested by Balbir Singh and Mike Rapoport; current callers are
>   expected to pass a non-empty range.
> 
> -- 
> 2.20.1

-- 
Sincerely yours,
Mike.

