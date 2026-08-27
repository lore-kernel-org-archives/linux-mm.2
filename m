Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DD2C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FE86B0095; Thu, 27 Aug 2026 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049076B0096; Thu, 27 Aug 2026 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78606B0099; Thu, 27 Aug 2026 12:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3916B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:51:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 313FD40133
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:51:22 +0000 (UTC)
X-FDA: 85147640004.03.67AC160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9A00D140004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:51:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogM8dAnL;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849479;
	b=5vffo0GVMRLeV/B77boj+T7YIG21DAs3hGWUgpn65lkAwLpuh0qbzXZJ0zs+2Bo8Zx1KbJ
	Eg+b6l6L95Rd0g0lj45R49JtV/Lebv59bxhieRoY9Ix0CSreEBe65lHG2Lu2vWL/n0c+My
	1PO+sbkpDTGUCLyOCGXBdDWT34wxA9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRYkuSjpv9ZkS7Rdz5bnIJBpsVr/K+M+nPKcq7+TMlo=;
	b=7KkcquzPkNXp/3T4IN8RbNSx057Qx1FpqlEn+XzZnSmF5qu01ff3vj4zG/XdSx7S3bUGa0
	N1irHV8TpUUrByQ4wL1ZbmmmYfyG2m8cj6WzZs7D11clhc/qrKLRUzQhLZB1y5mJ+HN2UE
	ZRyclc4VrtE1p1plrEDS+AX4yAyE47g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogM8dAnL;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27BFA600D2;
	Thu, 27 Aug 2026 16:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39521F000E9;
	Thu, 27 Aug 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787849478;
	bh=gRYkuSjpv9ZkS7Rdz5bnIJBpsVr/K+M+nPKcq7+TMlo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ogM8dAnLix+zEJplAVPe+BUWbbUsVuHdlJ1wreZI9mgtlGLZsT9KW6vmUi39jfdou
	 RwqOOSZN4BllKCzHlZbHovfVyvLh52WoppH0BnghcC5JYn9zsrA1iUuMc6WthnMDyp
	 lU/IKCtv6Ij6Jqi3uI+uphNXAF9uFFAGuxNWFYbfoZvCRDkHj4G71CSvUb7fnLDW5L
	 jpBIBEykwv/QRG45KMe5WKbOIes4FjJfUKmOtGaHiS3XS8/7f8QPswDybCJ+LpCLD/
	 GtSTry87rPDLJxhEXG6vYrV44cG/AmvW6RhT4EtM7w0L1bg2dZYNZCbxd3uVK5+sIH
	 ndhA98qxlcmTA==
Message-ID: <ba386e23-1b05-4897-98b0-ced78df6dc25@kernel.org>
Date: Thu, 27 Aug 2026 18:51:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/18] mm/huge_memory: lift order-0 restriction for
 swapcache split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A00D140004
X-Stat-Signature: ib99xfrcquju9cru148wqmj39anb6k7b
X-HE-Tag: 1787849479-94574
X-HE-Meta: U2FsdGVkX1+x7fYg5ljpAyBHyPCQrLVLvgjWDLsDNZJrO+kMDGyv1kkj6mDhPKfpXydfamjwyDpEQj6OjWgZCOdp1jSqjl+ixJL+uGUp+fuq/X3IDYKMnc/EGiD4LN32KL7TIHEzEiSr9Fdoph4SqvEFhUcxOe8+MRmpyx+lhKa7Pn9qV3xwXPzgxA9S0geumVNEUUNu0aUveKNrF9L0ffnjDvZrvKKCHxdE93tVUp85vK0ymF7oU5siPg29M/12C/1I9Jm9hyDRCbVZe+aTQ37PHw7q4NJlS1diZZhG4xnDry0rT8htZ861GeoYJpThpFlabMFxUavNeeQhVvCIxaQDzyCLvt4+YCQTxALgDgC42oh1aaIvDwBzW68/YqWCLaOGEAhEcFP82+e7MTZToVsUEZ2fUeO69rsIMtNa3fzAlvC+w14MrX6SzmbDJr7IdBdEL6jKFBarUQ9rpy//DZoqZnv5YK6l0snHoukNuTjR/L93zjm3YDMeARJkgFH7rxG240bKmMgRpNAJggklUjKIVm0y0GrQ98zEcpfLoDtFrwgTcpXXyuzDmipKzEZd3pPfILGd2D8p+79i61kDi6qspCISpGD7NX2MomrR4Eml3mEOQWSvvTTrS2rwu9aalbkLllNmQ0Av+Ebdfd/EiSM+WPYXJ8EZsYZ67EAJR4eLbhbkWi1E2eG+IlAY4ahlKpnUTagIRfd1ysDu1+FLovsJdv6lM6rLrzLsjo1/GrAeBZbU3+MGh/TvKzM/9m6dGSbz3+8gtd1nFwB8lx+r9qUmlXl1oy9PG6cxpFofzQo0boSWSMb6aLl3DjMzlg65RUi7Oux0jWMTA2tlyBxVybwvmZrcNEWmc69aeVrucPKypONU9l2HMMKQIxeksbhwerBzM56/0XBjDp9YS1DjaeCuhhoiOo2ylED2ZwFfye2evJeJXTBAcoNZ/uTikERCcXqMdrJp/JrDuIOd+YP
 o8tnRdMv
 ieYBLTaGwg/21rxRceV5PtwD+/SxPgjCT2/iK710R1WlE8WxjHwGx/pT3yRyjYr2EU62sCclIgYIU5fPHuDIlh1uFBxONrAIeV4OscI6ATLYiYx5qXHNE8vnoZK3YSJCbpI6JXQj5SJYqcmtEUH6XIqwddQS76kdTfdGTN/9kxoj+UrbtOr7CNfNWVoWBmTzOGNUI1jD2Y9/o/jN9EF37hBiyU3CvQbnFsfRai7oYsLbbu1VgNVCUFXIuiPIcuBYZ2gtYwdPqs9N6+WBx/kC1VHmJX/Bxd2uXL9SIMUmB3uYu7NTIZwGGS3arALyBOqswZZEwBqJ0mBfYoi27TffL4VBEn1iyV8F28p7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The restriction that swapcache folios can only be uniformly split to
> order 0 dates back to when the swap cache was managed via address_space
> mapping (swap_address_space).  The old split loop only created order-0
> sub-folios with a fixed stride, so non-uniform split and non-zero order
> were rightfully blocked.
> 
> After the swap cache switched to swap table under a cluster lock,
> __swap_cache_replace_folio already gained the ability to replace any
> number of entries for any sub-folio size in one cluster, and the old
> swap_address_space locking and limit was removed. The restriction
> became obsolete but persisted through multiple refactorings.
> 
> Drop it now: swapcache folios can be split to any supported order with
> either uniform or non-uniform split, except order-1 which is not
> supported for anon folios. Mappingless swap cache folios could be either
> anon or shmem, so for now we just simply forbid order-1 for all swapcache.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

In contrast to the other cleanup patches, this patch changes behavior.

I would suggest to send all cleanups first, and send this out separately, such
that it gets proper attention and doesn't get buried in a sequence of
harmlessly-looking cleanups :)

-- 
Cheers,

David

