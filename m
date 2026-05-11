Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052EDCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712586B0147; Mon, 11 May 2026 12:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BFA6B0148; Mon, 11 May 2026 12:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1B46B0149; Mon, 11 May 2026 12:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AAA66B0147
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:37:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE1C9A01E5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:05 +0000 (UTC)
X-FDA: 84755693610.15.7CE5527
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2CF38100014
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F9c4In86;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPk5XHw7qn/fXCccKXVO5r2Z4HwdHblAfBNUt8aXN5s=;
	b=KECLYyUUN2uZx2b+UtYN/0ScFfKNNnj8IGPuFLO5M9v5oUjF86YSc57IqKbyNEfMqnAyd0
	S69vFC3X1jSseZ4RNfWyLK+lydp7fHChDYqLqkZuiqfNCGOl7Cxquqn6bLy8y0M0Xm4dPo
	YbdDO4HaVqLaEqUZklv+rQNesA9Yalg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517424; a=rsa-sha256;
	cv=none;
	b=BW5Qgnhii5dObyqDM8Gxx5kxT4FWB6pgMk8V33/uWdzXy4Tigtih2CRD8tOtRNeEdrTCnA
	JtMq9qXk5ehTHhrSyTgrZ5atCbg6mIo9Zsg/qUuBAagH8+DBjkGV+KNWwtsyPqc82opZPY
	Kue/4vovopbwgDfS5yjG0H1fm29twXI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=F9c4In86;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8eab809593cso485328685a.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778517423; x=1779122223; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPk5XHw7qn/fXCccKXVO5r2Z4HwdHblAfBNUt8aXN5s=;
        b=F9c4In86Qt1R9JQcSsf5+RFP8Ao+Ia9vRM9d4PqJXOHo60o16ZH1DNRzNpdOUixRa2
         DWJjOrfbOSLMyDgepyvgtoTtJBpPdhss5IdmN8M1WqdGhBZVBikHzI9zTH+EoVCaPEhQ
         RuM2/aZbr4Tmaz5BoaUBDv4qW5F004M2VItsEykZPboOLpo1R4oKJDMhedJsHcWJNLiO
         YTig6v4zzW6D/9Q9JquyZK0YpVlmOG8NHyhj75M1Twbwa/+xka8ryZMbNmh18ixDXrCD
         1wjFr/jR+CbbuBKnFdQojSJT7Bi0WIzyWSrhwPb9owyijms/3BvxBZb2Qu5SvOy47V3e
         3JYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778517423; x=1779122223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DPk5XHw7qn/fXCccKXVO5r2Z4HwdHblAfBNUt8aXN5s=;
        b=sgd1OEDSNVEeQ+Zw66dPb6am/Yj/ATw8sLxCEyTUGWjGjxL8teDMvew48/Yjicge+/
         +L7CqvO3xdi5mdreOoQ3LmBgf0h1mk2VN3HU7KvEKc1hf7oQjYgl4YxENRBqvIJQ3JJI
         1O1FL93o9vzvQrZm2HYN9yY8YEggw9s93KvNEQ63TI3/HDAOeh3ONyqsZvVcf75h+N4t
         3PtBsQHsq0OnfMREjoyZJX6sxjuuorZmIBWaoImfEe/t6YwLAtMY1AgkqKIaGXFL3xQJ
         UHFZJ3BSxgVztRSqGzWNcbxnNaxhRrzQOGsJwzNsw8fqaLdRBHtC/+EpA/+yC2Zc7FVF
         U+xQ==
X-Forwarded-Encrypted: i=1; AFNElJ+S6XTo7LdiQuIQFvs3+KnmKSt1P3oLdZQ0zFLuE24uC/0t921dei0vFmQvnmsahHcla3YJwqzgEA==@kvack.org
X-Gm-Message-State: AOJu0YzqMfoQIgXmwKgBWOS0XjYPUPZMEE3x/KvKJChJQ7lL5uOSYPLU
	sG2tnpp1mYd4omPyyEfWUJH22AX8yGvq0mHzucnm4Fn0tTAURuk8FHG0zjHv5FYa2HU=
X-Gm-Gg: Acq92OF6zascLESXCCVjhjh/N3YY2JnMdMrvKPfi8fLaBKRG99ivKQBSghsccMhzFGc
	3GaPInrMxR0Buy4M1zY+EqCf+AdG++7I+voMpMthy7nFjSCtEFB6mHF9SdnpduRgAmbCEu358Qb
	wIZ0AyJMyJP5ShBLtUczd795rLFbWBxzHtg6dF9DHQmj4JLhu5wgtX8HHrKmU78b6MG9xCHkpWe
	LPYVKVbsFEqQZiGbAflsOeR6DrQv5lULT/Iw6//M+tQRmhSOnBTIRCTtvUd0i+jp2af3QeHAFFB
	UDCO6ZQygxRWzX40M9FBbwwuFsKgjY92uLXOvmfvs/j+YYFz0pYoMwyxQBOnLFOIfFmaTBwCtTo
	aud5RRin7QphFcn8HW/aLtawd6+S2laiWLhnXJVBdRClRmNLZaeXoYO6S/PlHMO2ayu8iEfT4SD
	OIvX58KwoBNuI9hdzTCfT0+voOIL3NTEM3vSNwSXUFs7c3ElkChLy9MCd55iRFS7vjF3+rVGZOY
	m8qg82HMVxg
X-Received: by 2002:a05:620a:17aa:b0:8cf:f2ec:c52c with SMTP id af79cd13be357-9090dfffe49mr1442495885a.7.1778517422959;
        Mon, 11 May 2026 09:37:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b87bd588sm1178556285a.29.2026.05.11.09.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:37:01 -0700 (PDT)
Date: Mon, 11 May 2026 12:36:59 -0400
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
Subject: Re: [PATCH resend v6 14/30] mm: hugetlb: use __GFP_ZERO and skip
 zeroing for zeroed pages
Message-ID: <agIFq63QZugkWcXJ@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CF38100014
X-Rspam-User: 
X-Stat-Signature: 9sgrkoaxsjkb1mm3z4wpsptmiy1r86zs
X-HE-Tag: 1778517423-574890
X-HE-Meta: U2FsdGVkX188zNmxGEAnt+1buuSY7XUzSRKRGhRclsvByZUYKoNjfidyEWiD3YOVCC4cLIiEjaFtPUsyy/QIV9mpFQq6+GCK/EB0+O9xl5kPtxAQSzNk3HeYn1WCHtWmVfx1bOm4qC+MRk5h2s36gWIthBwbHblmhkt+3Uo8aXtg5LmwAqdSG1/aF/S/S04IU/fAbrONXOtva47+9Jyhqd16ckSLabylm6lmDubLYv1UDzJWy+QDeZnkom1H3fozjB39yea3hSF5IwcH78pTHkfYf7ge4SqG/MIuNIWWEhZc89zMFLo5nE8sUiz8uwFel8XCfQEJP3kUbAHhpr/NVhWmy+BBwjDhV7evqnlIBiASRjiVfi7KVQS8KXmHAMFmnw8p4i316roSxXAfLWtdMBUCTYzgRHXFWsPqlAzvMKSGng6DM0dhZoOX2Dp570Oyy73emYqRMVTXg0n35iWc36s5y7IyGZXhVlI5JwX54TEUYns5w6FDRMaafkVCq70voWNIX6HQUwt/ltYs2zkETDgpPgEczoos683K53YhDfB//rrp03h5zMm+4pdPNjwqXy+5ZpeZNBAKEXp3usPF6BcEET8mXWCHFZXRmlitT1r/Q3YR73wHoCOpW8VRybYYm3MgtD40J/5w7jdTfmDcfKiwgSHjEVGx7k9z2Ur3TqOovWWRgb5kZVqbIpwCtrhfjFs3nHNjfgQt/c1U0VbThIiNHXbrmeZxVNTFCyRNr59LJ/sZqxqpr5rSY0OnzP0EkwafZCkbdXFpeSUtNIiNJ+nDmPlxB0YaXHx8S8pdF1AnXU6TGtRWk6WvkbgCdgLgt9UIWeLLSYXKGZoWlr+vZMxBXdG3JCTdfk86dKPY7zeTbxTrevjW9UAeigVjdudhCmrXqTyamyHdopfG4E13VDAlRg8deDnw88FeFlGzSBfVQwqg7kxcjn+hAPVT7UpFdRvYwszIIe1ReHrTW0k
 zKuHADW7
 E0RU8e84Vk+1JM9zzq04CYgWoCZSkdM3S3xlwWMrtfKFbVHSJ5CrwtW5YRoTjkhdWuwqnLyHBpxeQoeUA6KLH/19Mrz3FffQti+ATj67d9CAVom0pIFEzf9EPEvZsUwMaFcBbTCKnWmzMWyQAqdNgkvRLp6Lx0r8GMfnm5BvFSmMCJDvRavoZq1qFiD5gugLe38hYKWulOO54TqoTkbWOFiKKIcygvFOAzj2eZZA6IxV2/p6yqZ8Y8UdGKXiCS5/w4aG7XCMhq/fwpR48R2hMLOHBiMIAss6wmTuI5DWvCQcVCSPGjK6yRJst5hcJ8YNVsFzFkBwa238nJE2DcLuBdbnstF7/NNHkqiIhQ+tvaSXzBbY2p3sprzjOpdhLtSs5NRh3FzMJ4ywzkE0meTYzpruDM1TC/nOLW8XzzMIxPWUgJSbCpyvrNQkU0zRvG5go1NUD76K0PNqwWnnehZy64mLvkzwgyqhDAv2QD+7M8yHsUaDenkH3PDjZw1TV7qoqu1+j+K2jc1zvZ2h/XGHIlgHZ1/QELcV7SjPat+1Rc4Dx1GtiN1qXaXu+/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:03:02AM -0400, Michael S. Tsirkin wrote:
> Convert the hugetlb fault and fallocate paths to use __GFP_ZERO.
> For pages allocated from the buddy allocator, post_alloc_hook()
> handles zeroing.
> 
> Hugetlb surplus pages need special handling because they can be
> pre-allocated into the pool during mmap (by hugetlb_acct_memory)
> before any page fault.  Pool pages are kept around and may need
> zeroing long after buddy allocation, so a buddy-level zeroed
> hint (consumed at allocation time) cannot track their state.
> 
> Add a bool *zeroed output parameter to alloc_hugetlb_folio()
> so callers know whether the page needs zeroing.  Buddy-allocated
> pages are always zeroed (zeroed by post_alloc_hook).  Pool
> pages use a new HPG_zeroed flag to track whether the page is
> known-zero (freshly buddy-allocated, never mapped to userspace).
> The flag is set in alloc_surplus_hugetlb_folio() after buddy
> allocation and cleared in free_huge_folio() when a user-mapped
> page returns to the pool.
> 
> Callers that do not need zeroing (CoW, migration) pass NULL for
> zeroed and 0 for gfp.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  fs/hugetlbfs/inode.c    | 10 ++++++--
>  include/linux/hugetlb.h |  8 +++++--
>  mm/hugetlb.c            | 52 ++++++++++++++++++++++++++++++-----------
>  3 files changed, 53 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 8b05bec08e04..24e42cb10ade 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -810,14 +810,20 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  		 * folios in these areas, we need to consume the reserves
>  		 * to keep reservation accounting consistent.
>  		 */
> -		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
> +		{
> +		bool zeroed;
> +
> +		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false,
> +					   __GFP_ZERO, &zeroed);

This feels like a very odd pattern:

  1) ask for __GFP_ZERO
  2) Have to check whether it was actually zeroed

Seems like the zeroing piece should just be sunk in if you're going to
ask for __GFP_ZERO anyway.  And in that case, maybe just `bool zero` as
an argument, rather than GFP (to avoid future overloading of flags).

~Gregory

