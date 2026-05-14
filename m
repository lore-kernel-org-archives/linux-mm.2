Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF66CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 15:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FD46B0005; Thu, 14 May 2026 11:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577936B0088; Thu, 14 May 2026 11:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E626B008A; Thu, 14 May 2026 11:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39EF76B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:32:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99E571205BF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:32:32 +0000 (UTC)
X-FDA: 84766417344.07.AC6F0C8
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB01120010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:32:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XYhNN/fP";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778772750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0Jrdww3R9YJMBWZEBaj/2VHLPNdS7oRIHQummGxhrc=;
	b=01z7vFL1kP6bZ5YrWcwvj4baAzptlvowwwgU225noGFmshQSw76j/PM1H727LPV/LZCA28
	ncg6WtfNCPy/46WVJowxHB1XCuJh9tHVLfP/sAiQoksjnSZzkjJYWoMuLVxRK7+X4m4dec
	LcNm1gVCU+I18eHEhyOENW4OXhx8L5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778772750; a=rsa-sha256;
	cv=none;
	b=FcsutXDRLdfF5q9hTYLvWAmjhm69CLa+BJZGOS2+f4zEXLTFtFGQJBbp4EOxORiV/Tr5ok
	lSc3gyPV8Jaq3IdZuinfWtjsQ94/iFj4BfLWEeeLG+k4SvurW9v0z2fgvx9ZaNcuNL0/qU
	x3dhakILbJsRGXIoJzOR8ThluakcUXY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XYhNN/fP";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-95fa7cd1392so1016437241.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 08:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778772749; x=1779377549; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p0Jrdww3R9YJMBWZEBaj/2VHLPNdS7oRIHQummGxhrc=;
        b=XYhNN/fP6Q02nZI1ZU8qdlDyFfN15qwgBf+V72T8hlCoR1u3ggQifYAIeoN+/tRB6Q
         1VGc2mqbWQGFEi/2jqXwbzcv1CpUFTzk5VI/yd6pRFkppMfBUBbD8OFitw9MpGpp2LyU
         Y5BstpwSz+jVDvB08S6wsODKs/sbnjqQRCSwci4mChhGIQXixdnkQyqoE1v7mKdFLJP3
         CoN0mogIW5zgSnOHdXADS0L+8S/6li9YbcN2cm4T8hsoAhRT6AS/2D7BBvQ4SpjraSVQ
         g5KU+ywMC2tZlgOrYmfun41sAdt6uedAoUllMPZEUuxaSMkwp2DRWnWciJph9wMv/JYH
         PnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778772749; x=1779377549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p0Jrdww3R9YJMBWZEBaj/2VHLPNdS7oRIHQummGxhrc=;
        b=Dc9HUkNkdNVc3G/pnPr/IlXwVpJ1AVnJhAhtY/Z68pL9D1lXziy6BrEHVQBCAI7WjJ
         PvHxkKGXGvvJT8P/4B+92daZLwWwKcqQFWArP8pcqoVZq7OZfCA0LMYUYmc0XEZSl8xD
         WyKnu7JRlX36kJMM1cGcz8Wf6MhEu/nRm0VxLq1kAA+5HG2aQDhPe8ttZejKNAucoS8B
         ufINxuaCs+uDjDVQ9INtPhIC4yTw5bao4k3cafIsbvH+WgYGgQShL3u5qorGQK9JuEpm
         O/7yrIMMR6lMGSCgiwgmsRFkyDOI6aOzfApzHSZ3oC1zQ4/IcpoN6il/NfvRE/5SM3Tp
         9Gng==
X-Forwarded-Encrypted: i=1; AFNElJ9kUc5d3XV2UX4mbS+gTY7zdumNtMKnlOmIq2lO5EW5xg0NrktQsPM/sQBF+x011WYqZdgASDurZg==@kvack.org
X-Gm-Message-State: AOJu0YzXrfEVLFe0BZhVpOriC7str6nbjnWrJSBeb4YJjTV7UJz1daNz
	DMJEvj31I6RoxQYBfzQz/8pNNItO04XT7mACkz2TKnCKtFMO8vlO73a+PYQ8EtrAboY=
X-Gm-Gg: Acq92OF5fRXdeuFl2+HyWTvD2ipTHv0mDisgglGQPlbqjWJfcW7XjuvHbEEyPeYcLMb
	oXTfQ7zJp2DTQJw3PLeLzvihmdMC8jxgmCubStbFvf1PbvVS2var4DiS3NFq7S/xtbQS6qnvmZA
	S0RxEizH55vCNyxkEvw9mhdZPt7nNVQrpfPJ/0ree/QQru3hL88w/W6SZLTLmECi3+XazTmRr4c
	tvrMB609c0jmz829twQ+yg7unXop6VYDSzNYylyW2xJgo+6O0bAWgN8J3me7LAvv8iksyLm/tm2
	+3cMDeSI7JugcGD+dQzcVAR+eBK3M3zhjKfwoki2GN2bKtLSxq/oUJlk22afDfrlGUw20hVN/Ax
	dpq7FZvmDuA5Th0JY2NuniYVo1GX4STsoH/GaqtFv3VVDvBIwIp7T+djhdKrxDf5a+i9bZ/ODWo
	G1EHKtIzZZn0tuRdmDlQf9vtnpBh21bXWghcHM/yeeU000NaZ/Z1KARnNdlmdvNFT0K0Q+rCJY/
	3xiJ0gBakagfReTxBPy6cM=
X-Received: by 2002:a05:6102:604d:b0:632:eef7:4b7f with SMTP id ada2fe7eead31-63775d3d1b5mr4496453137.22.1778772749628;
        Thu, 14 May 2026 08:32:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36e638sm275535485a.9.2026.05.14.08.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 08:32:29 -0700 (PDT)
Date: Thu, 14 May 2026 11:32:26 -0400
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
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514104735-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB01120010
X-Stat-Signature: zer9ese4jxz86prwf7d9yw4wbnhw1qbf
X-Rspam-User: 
X-HE-Tag: 1778772750-303352
X-HE-Meta: U2FsdGVkX1+r4SSL822alX2kbBqIOoXOtPqZm8E4n3KhJHAUD4OHCziXx5lwLq2A4phVprvUeaM1SPqyIGbx+QxvIVZI58Vdapwivjl23yjdmPN6caAQ9t5h9m9mf2d7g0GtypCaxphx7qMsdaOqG+H1jMApQyrUlalZaup6BdUBNAbhGiFEu9Z0zImr9dI75xDTMpHYFRobIPEFOL5WvQIbz83QltXIrHauLF9phsNOm3B8LfDXXF5iSUOTs38uNbTzfJUB40/4jImA9/4pX5yhay9nMtZBLTw+HeSuxma13dDm6NuDQcq4cYxnoJIn9uRqas9uiq1iIcNFaxxGpCBbmABUy34NzIvF+li3Nh/KdkeffOn3X/GoIIWpFvHOLUdtFjX34nEEKL+0JkYTmMzbHktskRcUL7KjGL5MO8MODm9xBTN7Da8QuUdVdCqimcHE0CNn2PVcb3zVj8MZgoRqjxiOo5iWNzel1nvlCOkTxA8PneQpfpQzrC0U1xhvt82NICakXMnLHPY8esIhuRRAgZ2/KQc9Oivb9fBLq0MiVpQD49aIiNSPIh7NawY69HBnQUmUlqK54AOwOvujMmEb0MdhxJokyYZHZrQyYQRdGbS3YRUMxJkakLCAMGVTyCpFlvLFZdIotSxcg1ReyMutztyGbD8VRabqFbXNAwn3p+SZuwKjXqL8aDZx8g5eUB66JfOfFfQMAtStypfuOLCA0YIp9LN83AsR1oVe8axMwzX4m9ypwLezgz2a3qd8XZEEbxz0Hqwm6Z5Xvmg4uIiIlj7KzMLt8uxkItethPHZoxbNDHGYRoXa/Jz3OpM7Wff4SnEL92cFVLMYZZWr7UJVx/paIAEF4UHR/Wus3Y8t7O2EZOfNmns72icRAAuSWM5N4/rPC1wGRTAT0jeVI39Ltp2FOIKR0bSwVeVz7eQNvsYGxVITK/iP2npGecfeNCc2x55wskZgXY5weAW
 L/zh0g6J
 vxRG45uVTV9N+QfzsKe05iLZ+E8jyaBIHHcBr3CYPlPwPyP7IE4TkDY05F7bbsJZJABefLrJwknvGVjcxsBjOH805qObLqrVmzoP6xf00/2xrtCZnYRDWHMI1+eByzV43SlLYjvd/QucmwfluBUdZDvn8sZ96fLRl+/h8lEqt3z5B7eH0SNBXZoDyG5FqwkZWnbx9lCSC89O5RoIaEFo0fA5xl/9kG0urUp9v1nV/7VzSw7x4le+hNHG4Hfd0s9wk5V31JWIGW0A9U0xsty/7NnlrchacbLHnIdFrwgVgYSjTVqTFqF2R24t7+TOTYTmC+zxenfNy9ThcSZcvec7CxYRCBWvmdxw766mMKS01tPzfi4KaqeLyKOuAhbpr373JB0bu94+RMttA0V4sbw1QVtDsdxyCsFDl8HNXbZgYNeV0x8XpLjx1yePQYLw9cdVoJnsJKkV+2iVxVBZisAUuwTYcVidCWBRQaPZLtCfnNl+l5xOfW5g7d/yVp/LDZOoxQhSHSWlap/rhahHD1Lu55DHSnVEDbRDYDPOtk2ybzfHKIX1A7AxNgqtlYERg55ZMqqgLKC+PexPa+7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:48:28AM -0400, Michael S. Tsirkin wrote:
> On Thu, May 14, 2026 at 07:51:03AM -0400, Gregory Price wrote:
> > On Tue, May 12, 2026 at 05:05:16PM -0400, Michael S. Tsirkin wrote:
> > > When a reported free page is split via expand() to satisfy a
> > > smaller allocation, the sub-pages placed back on the free lists
> > > lose the PageReported flag.  This means they will be unnecessarily
> > > re-reported to the hypervisor in the next reporting cycle, wasting
> > > work.
> > > 
> > > While I was unable to quantify the performance difference, it is
> > > an obvious waste, even if small.
> > > 
> > > Propagate the PageReported flag to sub-pages during expand(),
> > > both in page_del_and_expand() and try_to_claim_block(), so
> > > that they are recognized as already-reported.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Assisted-by: Claude:claude-opus-4-6
> > ... snip ...
> > > @@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
> > >  						int high, int migratetype)
> > >  {
> > >  	int nr_pages = 1 << high;
> > > +	bool was_reported = page_reported(page);
> > >  
> > >  	__del_page_from_free_list(page, zone, high, migratetype);
> > > -	nr_pages -= expand(zone, page, low, high, migratetype);
> > > +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
> > >  	account_freepages(zone, -nr_pages, migratetype);
> > >  }
> > >  
> > 
> > Maybe mildly out of scope but worth asking:  Are there other flags that
> > should be retained/propogated on a split?  If so, rather than pass
> > was_reported, should we just take a temporary copy of the page flags and
> > pass them all in?
> > 
> > ~Gregory
> 
> 
> Not that I can see, no.
> 

You do this exact thing again later :]

https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/

~Gregory

