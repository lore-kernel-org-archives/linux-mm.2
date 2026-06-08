Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258CCCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0F26B00A7; Mon,  8 Jun 2026 05:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898746B00AA; Mon,  8 Jun 2026 05:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5506B00AB; Mon,  8 Jun 2026 05:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB696B00A7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:57:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32B0F40A20
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:57:04 +0000 (UTC)
X-FDA: 84856291968.25.26F3CBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7855240007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:57:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UkTtnLeN;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780912622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1+02I8/mz51EwWNuh6VrtfUH5JJ8Oucs5gbUQNRuzQ=;
	b=NWKZF0Tbrv7oOz60VAI56jjdVoeHWGRNiqCpB2KOxFNfIzniFAZvRGs6FTkmx3/NV2moNR
	KdWL2+HV94QysHGSnd4NitnjWHMmkN/m+qoOsZk8/wwhkLeKYTzD0w2j4KKybGoAcRvhYD
	2GXtfACaUDsKmNOw0DS8ozpncRx7Unc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780912622;
	b=VOK7fumY8rF9jT4j6gT2LJmS1tnf7UJ1HZMMjWQY0NrYUxZvH6lWwm8rIwz/O7gUuQ0gKA
	7D1EQyrQn1YyI1HSyt4y+b5AO29Qu10CiUUdO0pCbYT+aj7EkFT6JLx+DlFUmdx91W+Pr7
	gmmYJmuIvJWX+GdmX9kPWXTFknX1L1k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UkTtnLeN;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CBAE44364;
	Mon,  8 Jun 2026 09:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18B71F00893;
	Mon,  8 Jun 2026 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780912621;
	bh=P1+02I8/mz51EwWNuh6VrtfUH5JJ8Oucs5gbUQNRuzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UkTtnLeNlq2eQb6waQhRAxcdvreXzCydPiLS98J0WqRAb5SmaejJ9aM7CLiNGo2Bi
	 kEln4O1pbX0mexH/ttKADhNMlt4M8FhyEXL3oefVBhb0euY+qYUIhUgni4T/ljYKWx
	 PjbGwZm7xjAomfdSaT/NIuNHt9aC4+E3eEPjshL3qx7ao3xrHiv9qBAaQ2OOKMdaNu
	 Ce1aI0qTrEts39TQm/72ZBoPZ3CY4YGaC96EhVfzHnzwe4OvAG8TM1L1qvmWOQ57yH
	 glYdspkvbrY1ZTAskwYXyDhMeKa7jXyjldLReW+zfzAXgiETtSM0wX7zTkbdtqJ7Vh
	 BZqfqHR1dmhvA==
Date: Mon, 8 Jun 2026 10:56:48 +0100
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
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 05/37] mm: hugetlb: remove dead alloc_hugetlb_folio
 stub
Message-ID: <aiaQ_I2kxfC2hVsD@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <a9b5764c69269e5c0518e496b057a75354373b43.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9b5764c69269e5c0518e496b057a75354373b43.1780906288.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7855240007
X-Stat-Signature: 5zisyycenpwbzyqtpo8n1r73emzq8q31
X-HE-Tag: 1780912622-586290
X-HE-Meta: U2FsdGVkX1+nlC36TqGxpR3TU2VDHf3ShrB1CPs04e8R5UJTTBvpHtKE5hY1MFs5nK8fplLV+tTDrWS2NWP7zxtNT1lhY8JrCAMrw92Evy8CV+CZLUeigjSM1j0zo/tHGMWHWEpAcFj5pIFTEoqUJCcLPJ8X/DwXc/tMayqvLvYFduF5qgLX9iP9vsh7aMVrny3IRNLLXMZBFrT9th65N7FpBAFJ6HIKTu0oVchiNs/x9ef/Aa+Z/Crncu+3RYtFhQE5kcoZxBC51tlst3GypqNaySGwPH6c18v/Nvoq5uymySTVMql02oIrh8plcuyWkdoFoJOEHMOrL85B0dPvDFU9Y3b3e6VMstmMYzsf/W/JzcOuYSfd4VKDKoaKBfToNT86NhrV9AR6msbeviwzw+zAOWcN2GKUDNguch2ThOX7aQ2AnxcqD2sLU6aqnzRnkQmIHery9WhK3gtiXPUyvN9EFv3qA0sgq13lZJTNJ5l5rJTkPFmSkHyIcsAaO3v6Z9HWe39fN3vZ4C2GVYcpMLpxZ9/7qieOeHTdcZLlt60Yo14ASPAd1ty5T6ZDPwzmbsaBKKsOEjGbD+GWAWvz6C4kFQdDIC9zHT+ViuehG999H0DcC1t7RKoIpEWyVwd04gvXi+H1NCJYbIH2r7dYUHHnCoal2MdcWL7aXNHSWnbhSdTy/sw4AOl5fnvTVSLZspn8XJ8k7s3IsdIEBUeXhMVQWCKdFycYYixvBJ6hlWJwL7v9+A0MnZV1Z+9TJvH0x0VuymynMzm97aGIQo4RatScSQ9/W6EzNdHXhPZOHzpNngBmJ2jHbUqVz0HhX/XDodQVUpy78YCE9ADp5ZElYhE1SmfRBBh+DtQmKbbw0W1X6UQ8M35Kyrqqrg0ejzgN9mZZ4YumgnHNLMNigFmIvDwPvHsMRs/lFPjdKxFjOPVjWjpzkSZXLhLV2/AKFi2OTReo4iGRRvxRvxZQx+0
 +8JiIs+l
 zat+lSN6tK6gP3EbldWmAce28bZxyq8joHeM9OHAFjSiP2mXIwii5T96GcN9hcZL7Tepa5f80PWKWqtY8anwhM9TiyiFFpyCRvDB+lNxn7k8hd2Chdv0HuKxkR3XYJebZB2bh81Pu49svdBhLHoEFt8lzM3PmxXuzTrApV8J3pajamnmSCLMDfN6ybfhbZ8B8a4ta1s349HGrWdTncUt55h4nHwiq4hEhMYlqPIL/Q8z5cPEKrV+BCV2/qngOERFpdBTXsGc9hRCdRIVRcQgM9CJ6iamcNYhtmMCjYaxOYZlLfhJWF6W6CHVF7h5WT8xEErWjOwsRMUOgPJ1IGGPw/e1YU54/fBm7QCfNjSRIouBwEcAWeCLlhEBFGjM70DLyDGQwWdH+woZv2jRThtDB0ryvgD6D5qVy+XzN0EA+mE2l5bdt51mxsx2uBedS8l/vjOIsFl6KY2mY/jQKP36gCm5/9/XgVyznH/hGmoPVkF8Ls44dGqOT7oQio8brvCmvx27Jxe954rDQ3GjyBPfF/6cvi0I3O2qSwmDF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:34:57AM -0400, Michael S. Tsirkin wrote:
> Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().
>
> The stub is dead code: all callers are in mm/hugetlb.c
> (CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),

obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o

mm/hugetlb.c seems dependent on CONFIG_HUGETLBFS not CONFIG_HUGETLB_PAGE?

> and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
> selecting it independently.
>
> The stub is also broken: it returns NULL, but all callers check
> IS_ERR(folio), so a NULL return would not be caught and would
> crash on the subsequent folio dereference.
>
> Remove it now since follow-up patches change the signature of
> alloc_hugetlb_folio and would otherwise need to update the
> broken stub too.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

The logic seems good but you should fix up the commit message. With that
fixed:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thanks, Lorenzo

> ---
>  include/linux/hugetlb.h | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 5957bc25efa8..1f7ae6609e51 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1123,13 +1123,6 @@ static inline void wait_for_freed_hugetlb_folios(void)
>  {
>  }
>
> -static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
> -					   unsigned long addr,
> -					   bool cow_from_owner)
> -{
> -	return NULL;
> -}
> -
>  static inline struct folio *
>  alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>  			    nodemask_t *nmask, gfp_t gfp_mask)
> --
> MST
>

