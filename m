Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B99EE109C023
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DDE66B0005; Wed, 25 Mar 2026 10:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4E56B0093; Wed, 25 Mar 2026 10:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2096B0095; Wed, 25 Mar 2026 10:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2916B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:31:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B04048C78D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:30:59 +0000 (UTC)
X-FDA: 84584822238.11.DF4484F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3C5D140019
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:30:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TaQIHaHW;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TaQIHaHW;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449058; a=rsa-sha256;
	cv=none;
	b=bq3h0H9jIcR5AaXOf/DijVY5B+fMSpvOQ+V5VgyYzMkCDxVg1vkWpb006N9ZiZggGWntN3
	xQAd0xDzRvymNQ4tzagv8ilMO0LKcCcrMHl4cEsWZtSreHT4GNvyKEVEr03yRTYyMbAZQb
	J5JVYX9lxoEkOXOWqfh/vR1uaIv68hs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3GIm7jDRW+XH5XVY90MpKj8RWWo0PpypE2Y+M6Iohw=;
	b=mTniL6SE0RRgc853uoPhV0+Lz5EbfNY2d171wPUrcGYPq9IL+waKy1HRL34AESYBiKu4QI
	Yb4rYDFQJOeF4gInYucp97Hn5oczGriPaV2YPB713RVNzy9+g/hp7v/xXSunLrug7POF69
	eP549Bt+4r1NXt4eWb8UETYJaT8h80E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B04C64384E;
	Wed, 25 Mar 2026 14:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B78C4CEF7;
	Wed, 25 Mar 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774449056;
	bh=OQpFqKWwxd25pMaM9w94n955k1tKNdmUpjsCAsICsLw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TaQIHaHWbJ6OUKi24wqoY+iG7ETzPh3y8yky8t9lE2ya70DC44uMkF+BB78PCkwcf
	 dqGq2cXMEa/6DXJsiByERFpuL+S53MExhWTyLJBpj6fUQLDZazmgoAqEJiY/0w7QUu
	 IBdf/pwBSKOzYueJW79w0pMXQ0CEnoslYfFBmKGI=
Date: Wed, 25 Mar 2026 07:30:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck
 <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, Dave
 Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-Id: <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>
In-Reply-To: <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
	<568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
	<20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
	<24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C3C5D140019
X-Stat-Signature: qir7d8m5io15pbdo11qarkacstuzz6pk
X-Rspam-User: 
X-HE-Tag: 1774449057-972453
X-HE-Meta: U2FsdGVkX18kebZUV2mmDR5WiiSpwZpXxa0yBbyoBcRZYgBOiRvgndp1eH/n6XmQB+zbin5+FnaSRcT/gw+zh/4aBxQ+Z98q0yS/Pfdll5lC0r7AyIow3p1MbydtEIOUwIgVBRQSjvMjJ7z1/QwZUzUL2Yb+gVX7c6bBhp1mN96jkyeNS48ts8DKOCmZIvp//yRHwUOjlWvv3RjpIdvrd934dXHw5/tZ7/SuT8cHhbFoZoTheyLy2HqtF0TqApSXI/fHY2FAvVIJ5isxgJEy8yTd3K9elLIQtMD3LFTQ+4oDKnLoPLgTP0pMSuPee8pfHr4uKPDep3yLXq/YgF0thDgY/sRhkrOMJcoRrg+s634niZFs8UAOP0FpC+iHM8LCp2Qy2vZzPWaFlqIb3vofF3J5hbBr4c7LwIYb/RTZKRQd0iQLAdJ77SdPpN7A35ZYHcUCHBJSYrnSLMGwhPm3DhPG9+gU/xGpflsCzp9AbWiYyO8nD60RaD9HBUCuePhLINHsX2lSmdyNgyGgBFf1U45FepP94wrTUNDe4xzwb6AXLJVTqDMzwPptD5FmMZsnk8PYFRSNCblvklwR3nohwKKBSrKFTir5FdjA98UHPos3HoFHGZTVdvXQhb11/OGO7OUmQ+CNcZ2DJdlBKV8bkbad7IGspKBrsjFchd8iuNnp1j9Vd7HDWw8KLaWKbrGJOmcbVNueAFzM11Bn7nTv9u7tt4eyLDqBIt9WT4xLjwnZqMG1JrJrCCR+YyiOksm6xLDftUv0kJIYtVPsuRGxIsObycBGoS7d3+tlf8xpAqoE8QV5ogGcNz0rbeWFWIzdeNq9znuCN1DwOZ4ybAUjTNILiTckrLhxkbch19cgLlYkWa8CgVGWKC/tAyyJt88EeSXZx24yxOq+lfdAslJ8EAWHByaWfCiYXWQWGkrIuJzyri0YYTlJn3845BlO9Ue2igXjLlQsDZcgBo2NZOz
 uYNl6DKM
 cF7x2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 07:08:22 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> > On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> > > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > > it.
> > >
> > > While we're here, update the helper function comments to be more
> > > consistent.
> > >
> > > Also add the same to the VMA test headers.
> >
> > fwiw, we have no review tags on this one.
> 
> Based on the discussion we had about this previously I was under the impression
> if submitted by a maintainer that wasn't required?

Well, it's a gray area.  Obviously it's better if people's stuff is
checked by co-maintainers or by others.

I'm not inclined to make a fuss about it though (hence "fwiw").  Quite
a lot of unreviewed maintainer-authored material ends up going upstream
and I don't think that's causing much harm.

In a lot of cases this is pretty much unavoidable because the patch
comes from a sole maintainer (SJ, Sergey, Ulad, Liam come to mind). 
But when the author has co-maintainers, perhaps those people could step
up.

> I'll nag people, but I'm a bit surprised if this is why you haven't moved this
> to mm-stable, given how trivially obviously correct this patch is.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
shows my expected merging order.  It looks like this one will be in the
next batch ->mm-stable.


