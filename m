Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA4BC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A956B00A0; Wed,  5 Aug 2026 10:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351D76B00A1; Wed,  5 Aug 2026 10:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2903E6B00A2; Wed,  5 Aug 2026 10:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3C866B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:55:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 800C6A04EB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:55:59 +0000 (UTC)
X-FDA: 85067515638.10.89FC3B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E20A3180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:55:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqcKapRv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785941758;
	b=3EU9xAPba+QgkVAT3nPQlVRX91Ny6OIYic1FRnYD3szbaQDWlwbLcRpseWi4AlW8XMWI+E
	vBUnkZE434HpPLXYPKensFuKo+QJqSbxLX8jqNKabuc4cZyWUVdeV6/HM3odviSw4GXLHA
	QDPeq4XbC8mCp1nPbe4JrpM95+f+Tk0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqcKapRv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nASxGYceAPd+py7TH+InOS6PcP614iOzRyIcA7fA2qI=;
	b=PV6m3vwe2i/f5kKm4BS2S0PtqtgIztm002QXDkpp555L6Oy0ZKMFRFXk8Kuc7jfhTiP3xs
	27tYL18VTOSpR3HATauAoo4Yn6IUrODTKmaWCYflZz63D0hzGaa4oLryCNg/RaFKonwkgc
	08/hw/S3tX/RSi3iiNo3wIXNTLiEwSo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32FBF4086E;
	Wed,  5 Aug 2026 14:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5E81F000E9;
	Wed,  5 Aug 2026 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785941756;
	bh=nASxGYceAPd+py7TH+InOS6PcP614iOzRyIcA7fA2qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqcKapRv3Of+kM5WF0RjhMOufytZiUaRvqbullaKqFxthXLGRSkfrMJvGzYhu0gaA
	 y6kz+8jpywltwp+P/SGG3AYB2jD/HXUetI0xV10Ev8I4IxUAjQFGxt6Z6MEqmMjK4C
	 BUb458NF/51vUQb9BbQRfG3T8091l7fqVFJdBB/qf9t9Tp0RcPVUvi6VLfw0VHX2Nd
	 5IR4ObUhx/CLDTKd7IBjpBJ96dNcA4nLFSCJOmIIv73q7JfUmVr8KfQgRjUe5PJYRv
	 /H3wTYBmeDTIWhsPKGhTzR/b+x5GtKlG5/Mt07Rov7xEIF+rUXqLXkNrUTX45GkZLl
	 G8dpE2gUvkICw==
Date: Wed, 5 Aug 2026 17:55:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v2] mm/sparse: keep mem_section_usage_size() internal
Message-ID: <anNO9PlAebCdclSJ@kernel.org>
References: <20260805022536.1206575-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805022536.1206575-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E20A3180008
X-Stat-Signature: ztxfcuh7o1xdgqmqd9mp684d5mcqih89
X-Rspam-User: 
X-HE-Tag: 1785941757-831517
X-HE-Meta: U2FsdGVkX18NQsVP8YHuW4qSinTu1mwt9FkJBqPWUwXCP0MvbLkd7aYsgnIMmC0Qhzor2n1vaI1ZX7WHLysXO7wWbCthD6BETYQFcT8rfw06GyTXx3rWhwGNAjxkpBfr8Kc54nGDRa4/ccyxUk6JTvuzkOwoZBB4TWNxisyb5YO7q/LfnaZeeV337FiKeJbmAHtFtLPE1Bn+IIAp9fzvSqfile5VWm4+sJdZuVyPZV5ZgOMsU4evkm1JphwkBiDqkHZnygWUfzmdvlfa0PL+JajR3p8C997Rw/AEyDsHoKdK+ndUw39ThmPeO5chi1HuClWU32syWmQOq12EaVERAdiWLjZGSHiFqs7HEWRS6iL7kOuHB6GNsl7fnZZykLlRHGMPERAe0ZbAVm4+Ms+sZDgErtZlNQ4xOTMzsKrOt3H7uu1I9ccqOZhVwFQFJOjmiwQyoS5wtPB7HtihLsHy6JkiM82Dcb77ugMIS+qLq44KTIdOixwGaS2DNZmBoh/ZhQ6TKsZVPjqdwCvaHRUhHq6LNa3xou8hIdUfbWKl3Bdd3gbcc3V7P6idS80Eo4YIU8BChbR1nxz5zbtbEMvayWt+mqIi2lZ6HK5jTHjmXBY1wNMJHfaAf2ej1prT1nMGwXTa7cuqR508SQ6SXEaguxq8SSIGR9G6GcDKU6yXYt4mZWTnotePAxTppTXc5lab4ewzRSbIBHY/b3UCBlKvOIYanrSfeXIy9I7Lv4n4qhyvfv6Bw4NxG3x14P7dSdLpYcmRoPxpblN7BbhtSxHR9MVQLzap55sB82ksXnkr3HON6kufEz0FFlZU6ACOJjRBx7iwCnf8ybAlfkqCW/B1xjsFko4Mj3nSFt9aCxQDdXr1GDL19nDzU5GbOojBA+jPtIuOHCAukBnLpeDCtDvm6aaLYpWCy75yd2Kd/m0JdeR6EezJQ9jw4vcJgKVkNQzI6QeNLOTowd6pqEqYMaK
 BHiJFod0
 hxj71NhE7DtOXR8DnEqxLE/mxGi5bwOZe6/xcfG8P5zGunlYfwKHS2CX1bQcevOZpwPpY8IruJdSHYfaK0S7sbO9eI0fx1MP1Qo6POfcBx0wXmsm/E1vDNUFnmf9snkZ0Ac/rsCvXoQuzqRgrS7D86ISyJCpvQ9UE33ki1SDdpSVqLO80oanW+yjUtU4yOYHfBBXZU8E6ZAhlI+7poeNLs6x6ID0RS2/BlLWHOvIGlk6OWiENdJm0i+Y5lfWWX6yZ6AyDND8kiLvnutPH63DoWl20bPxowi9RceG6hrE8lkIs25FDCi7W2XVv0vP/PvvazlywbW/OSBGasFqSWSPFHa4FMqajv9jH20np
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:25:36AM +0800, Muchun Song wrote:
> mem_section_usage_size() is only needed by sparsemem implementation code
> after commit ae751d567baa ("mm/bootmem_info: stop marking mem_section_usage
> as MIX_SECTION_INFO"), so keeping the declaration in mmzone.h now exposes
> the helper to all mmzone.h users for no reason.
> 
> Move the helper to sparse.h so sparse.c and sparse-vmemmap.c can share it
> through the internal header. While doing so, calculate the allocation size
> with struct_size_t(), which ties the expression to the pageblock_flags
> trailing array instead of open-coding the struct header plus bitmap size.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Mention that ae751d567baa removed the last external user (David)
> - Use struct_size_t() for the mem_section_usage size calculation (David)
> ---
>  include/linux/mmzone.h |  1 -
>  mm/sparse.c            | 10 ----------
>  mm/sparse.h            |  6 ++++++
>  3 files changed, 6 insertions(+), 11 deletions(-)

-- 
Sincerely yours,
Mike.

