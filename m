Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9212CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0856B0005; Thu, 14 May 2026 09:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7DC26B008A; Thu, 14 May 2026 09:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DD06B008C; Thu, 14 May 2026 09:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA7796B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:49:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 567BD1C04A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:49:39 +0000 (UTC)
X-FDA: 84766158078.03.7CABD01
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 53C091A0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:49:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UcevzLCS;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778766577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPX+//kFk8/jIPUJw7pgOciEeGW6jgVvj62i43St87w=;
	b=6b8KeT6kbRq8C2SxpIdwo9Y2uni6+YZ7eWKWLE6RRf16emECO9UoQ1qk+JzR4bh2qzhVTw
	Hm0o+bEooUuS/LRighFHdNUt84Vmf2miNZFHu+pQ60iaCPTehvczNkySY/OCXoOiSkOJs8
	DkUOm16Njjih2tw4DPLZVPxVzGmi1oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778766577; a=rsa-sha256;
	cv=none;
	b=u052xazts3dHOdpow7yMD0DZFjBuPMK7OZ4EeOOyAk5W6/JQVyJql8Ytn+934PJ9rCNSAW
	vPtZN0u0Si7ESCLabC7wgQYMEGsChUjImkX0x5ZZ6MnP6L3g+8u4+lW9BaCTR3VH1XGIok
	3YwEhIl/SP4BeLGrRufrAM3y/YJ/3Ew=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UcevzLCS;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-90ca6f20872so362378485a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778766576; x=1779371376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oPX+//kFk8/jIPUJw7pgOciEeGW6jgVvj62i43St87w=;
        b=UcevzLCSQWW8FzqC8c/NqWESLJ+RVtB55NqZf5ORWNRgegEGnt0lM4zWab6d1QJy6f
         HxYpfXV4Dq0jP8/VF/K/jplI31h9DJkvR2iYL1Qy/1Ix3vfw/u2TqeZJ6KeE+gp66QD/
         sJ51QLLaGNK8Eml+PtawY3Rn4YCy+FBvqBhPVQH8i0QB6UnBF0CqwRZN0qJUbaCqKdBq
         6tUeliQQn4MJwkCuswVcgoxCT6ZJBL1bUGlib0icu5vrtWL8VHpTBs17ZTUVZzgtcjeb
         EchdtFAc6zMrPxCkCX729NdqjXhcxWLOGEQzRQi1A02UJkIswvYmW0wff4E7muTgsHLx
         eHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778766576; x=1779371376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPX+//kFk8/jIPUJw7pgOciEeGW6jgVvj62i43St87w=;
        b=acdBRNRvIOUW9/2ElLhnmABL53w17f5D98S0Qi8tmBDifmQb0tlEbqduZCzIU1pqTS
         TJM7zAW8HFcX/mo6AVHYBjRaJGk0FQkXuXbfHRukshNVKY3iGFErcXQBrz8ek2dSWy4c
         QgQQNvGOCjGX8WCnNbH0Dbq5gPrwvPGg+Thl1wYDy500mHxbs7HxSBqt8ErYL7/zrdNo
         JTr7/qG7Fe5B/APLVcUm4OYBiUyS7a7roFN/pvU03Fq2ovvTKGAfBbXnvchyPclNFvbv
         htWCSwcl5DJtCWnj9JX25R6RpK6Xht0p8OjXt/guxxNukdBw400GFZWMowuIYIha1bbg
         zN5g==
X-Forwarded-Encrypted: i=1; AFNElJ/R4xfNGFyF2mg8d8JwTqwBazAvNW/v/MQuz2RGUIqGe3pzskqbyk0p9M4gvWwXUz+JOv6lXBNiiA==@kvack.org
X-Gm-Message-State: AOJu0Yx8OKI5WCX/G55HG4ETjVtBXwXRJppzrVou4iddqWr6TYaOMFiJ
	Ua0RRSXn//LeX/QdUEXdze3TduDgo1hOxV0TJ8Ooe6OA3fWFRnE8KGPY5Tw08Sh5YhM=
X-Gm-Gg: Acq92OFkh5+6kzRXEfWTc9rZ4cnT5VORszNxWdGFz1d/pqJGaphF6khTITP/RFvvMG6
	KPKPzwrPP/jbznnrwERG/YkZ2rIrO1Cto5nEUChrOOPxZKmj2kMFWU+jIxAY0H39Dq7AdsUNFR9
	faE6Tj+0aimyRuL99fUgEw4fNQxbfIcNnGeiPgwvhfmNzOIC5Hv2WJ/aSfw9Mhb1pRF556OdQi9
	pD3Y59AxbVR2LKiraZfnQ5Y+wt6nZ4kSmDSTI/xqv6HWJu1Y2eSTF+ynuN1ImbCpfAtpBRELFc5
	63CtPfLTl9VcebJJeFGpmoJiu3KvlpQ4UOAkepQozqymW1EMivj72TPyIoqIjjbQ1Cf3EjeusFg
	9D+m3/ErGKswxHpWyuJgkJzbQ+tQQk0W0YdKKQP8YqMaX+CDzZWOGXyBSv9LywOHhnGJ1jHI9+6
	/OgBCagXPiS/ihXyo8UrylUvx44+TyxKciRKyu25DknpJec8SBu/7l8EayewF/A3x9UnsBacYsX
	EB+eSnIsubF
X-Received: by 2002:a05:620a:45a5:b0:8cd:c152:ee6b with SMTP id af79cd13be357-910af5599d3mr518683585a.8.1778766576120;
        Thu, 14 May 2026 06:49:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bd62e233sm248608685a.45.2026.05.14.06.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:49:35 -0700 (PDT)
Date: Thu, 14 May 2026 09:49:33 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: Re: [PATCH v7 09/31] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <agXS7dMmtJrPhu9W@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45d1ea85b574399459a64fdba28fcf04abfa3e7e.1778616612.git.mst@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53C091A0009
X-Stat-Signature: bfifmisim3ob1nzc98wu3syeco3yfpe8
X-Rspam-User: 
X-HE-Tag: 1778766577-153771
X-HE-Meta: U2FsdGVkX1810DqVWOnaSgVvnUQ6Yk4LvBKwW0gYEnsusvg2T5lwEB0sxLa33cblT2wC4YGjiI/2YF7+2C8M9vYqevmrqlavn5+lasmNxd1LhpfundioZ+aiyBr7PndfEDi9bQui28f0ba0I3pIBEc5Gi6cNEWdEZodDtxCHMqpTPZWPOQQidFcKrj7MMHpSThs6q4A4fJiW0EmbMghSiOb3xHctT2G0z+j+jqUUZrrhCVNLO2paJw9F54sxqMy6JNKn4errNJgtBpvV/BVVIHHjCwKbUQlZS56aC40JXGP4xPhzNQb82QthYOc7at/LoqJfxqMXz2SKZy1YDwOdsz6pjiNXmAYufJ299JG7bQCiG/G3YHZ/wo0mofkoKM8KbxcJJphSepRQ/RpJ1A224cbMyy6TGDxsrZyB2EsoDfHjwMhiOofnfgk6QODTInsr4biZ04OQhYbJmaUkvM03KJ0EoXm49J0BqzZQfE+vIaoickl+5YxS4eMIz14L7d13Wt8W089ZgA/U8/OrOs1IazH2k3DTFc2RLwD66daCnrCTf5xB8Sy5zBgpwnZ+wCAoBabnIS1tL755GCciva2EFKCXJAYrqR/srwY5Qrb21hdIk0lT3aNjLZASXYnJXJIv9ICdZnLcMu1y2eneMVwVf5SqXBxSY5K71bTBPmoJgeui7xaZwnI4Grq0ZM16xzofrmiyw2R6k9OFBQSqC5Gw8V4/rROoutwBt8kBehr92PICM/vrYTSsp/5uWMJ74J6efWcAKBtSg1spJnDvFd1J5vYUUP6rO5GqS3hZSnHZlEQZKGsbjNwXefP5nKAkPXhW4AYk2qcHQZzgPXS6zc7h04Eezg6NIE/S/nofOOI74dllID5lVpk51ka2cgakYqbJPzk1eakxezERbWBIoS5WZkmfIhwUR6akRYRCJILTcFaqYkJ514ESCxl+8fsN+tj71ObPRVN6kj4fOxsf3Rp
 FbUGa/ME
 dgWaG5OWgnnf3qSz1R8jIp5oNMjG2AWyEFydy1RaPi7v3OtmoEC8TMu5bFmu+uImPbB6nvY5W2cANacaVoEbrlCGO1k6hUlrPz1gySCjfT6/kfpyFLCtVRqiwZsxM/Ypp7H8REQ1eStPFeqCAtIMoyXQmKPbi4MpXrSzpRwVt06DVBxLZx5C9ZkBkTBA5FV40PYUEfR0tBpOEroIIshazKJSvklg7lzHmj65M8okfp9JK5rbuYYwYoIl/9OuPnlYbRIJe04X2S6hVbLkZuEWYiYp9Kh8nDfXKFX9P/+R+wXdAoEQspKSi1IwT7qRAvu+D0dHKOT1cFHwIRGP/oorMX3V+qwahtXmMihxbwlbqK1Oy00JtAbqVXtdDS3iSYHmhHLKLVb/1Y183oaz9nVXmAcsSUOQcCYwPcdNFYQWn2rRbuRciZdBWj1t/zNjhLd5tnjoxv2DfYQ/SiVnI9vHZw/KybIJeAZITdrpcr61ZvY/6wRtC/Whquj9oxWKsuEQfdEp8ViMMw5VhDCJcEJovyYK5KxdVYMheJpQwDYk3ZvUwcGbLFg4lL/aTsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:05:54PM -0400, Michael S. Tsirkin wrote:
> When post_alloc_hook() needs to zero a page for an explicit
> __GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
> instead of kernel_init_pages().  This zeros near the faulting
> address last, keeping those cachelines hot for the impending
> user access.
> 
> folio_zero_user() is only used for explicit __GFP_ZERO, not for
> init_on_alloc.  On architectures with virtually-indexed caches
> (e.g., ARM), clear_user_highpage() performs per-line cache
> operations; using it for init_on_alloc would add overhead that
> kernel_init_pages() avoids (the page fault path flushes the
> cache at PTE installation time regardless).
> 
> No functional change yet: current callers do not pass __GFP_ZERO
> for user pages (they zero at the callsite instead).  Subsequent
> patches will convert them.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/page_alloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index db387dd6b813..76f39dd026ff 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1861,9 +1861,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  		for (i = 0; i != 1 << order; ++i)
>  			page_kasan_tag_reset(page + i);
>  	}
> -	/* If memory is still not initialized, initialize it now. */
> -	if (init)
> -		kernel_init_pages(page, 1 << order);
> +	/*
> +	 * If memory is still not initialized, initialize it now.
> +	 * When __GFP_ZERO was explicitly requested and user_addr is set,
> +	 * use folio_zero_user() which zeros near the faulting address
> +	 * last, keeping those cachelines hot.  For init_on_alloc, use
> +	 * kernel_init_pages() to avoid unnecessary cache flush overhead
> +	 * on architectures with virtually-indexed caches.
> +	 */
> +	if (init) {
> +		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
> +			folio_zero_user(page_folio(page), user_addr);
> +		else
> +			kernel_init_pages(page, 1 << order);
> +	}

Open question but not necessarily in-scope:

Should __GFP_ZERO just be implied if (user_addr != USER_ADDR_NONE)?

Putting aside how that's done without introducing another gfp flag
(maybe something explicit like `alloc_pages_nozero(...)` ), it seems
like a very short jump to just adding __GFP_ZERO to any user-alloc by
default.

I'd be curious to know how many callers across the system omit
__GFP_ZERO when allocating a user-page, and whether there might be
scenarios where we subtly miss it (seems unlikely and narrow, but very
possibly something a driver could do unintentionally).

~Gregory

