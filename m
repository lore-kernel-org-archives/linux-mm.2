Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CD5CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13746B009F; Mon,  8 Jun 2026 06:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4906B00A0; Mon,  8 Jun 2026 06:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2656B00A2; Mon,  8 Jun 2026 06:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C48B6B009F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:55:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E07DA0A8B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:55:25 +0000 (UTC)
X-FDA: 84856439010.02.1D9EF47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81D15A0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:55:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lir9dBSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780916123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkFcWF5JTiPoYbuHF+MxogHmgdF/NJn+y/NKo4MF3iM=;
	b=SyhBAihFhiRU/9OqwcPgc5iWf8UXEhFasO+dm2lBbSBeW4txY88Ys6WKrZLCsHwinDZYd8
	Bi7d/VpW8Tg0q9HSe/pIyaJvKCTwB+dyvSlphv+uLK7QlGaeKZztyvAoa9hywDedDx+auz
	EcXw0zWrSWZlJmcCjX0Z18OfyDHrLlE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lir9dBSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780916123;
	b=fccrHqfBMtI4ON62MTnBo1TcktHB+LKgQn6gYvWMefw0fE7D7elrlJXSq8ZYvv+c5NoqBh
	l9pF3eJPvFEf8bKBo5JAo7UheqbzFPzCh1ftJliW+YIC1gatMayX9LEPSu6MsLvkUaenQZ
	duF0s3Na7Dl+B5oAL/Afm6453Y661Jo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7227540675;
	Mon,  8 Jun 2026 10:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A021F00893;
	Mon,  8 Jun 2026 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780916122;
	bh=RkFcWF5JTiPoYbuHF+MxogHmgdF/NJn+y/NKo4MF3iM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lir9dBSgZmimjDEhxR8SDkMKxpEDGYdhVawCpyjLK0rhdWiZex9NMoyHylSp6fHdw
	 ZJLqUT5y4cpIKvnnRFpL5Np6rFwSzD72u1V/CV2I2tf84aS+OHY5dIDT8K1kddvCih
	 5AyinxH6cylas9XLXnQPbfZ5zDaJbjWknWGU6mhhkYH5JysQNbC22qmX6x343NLaHt
	 4LJ82rOWfDVBOapvoj+jVKtuhBUmurD5ydnLJQndv3o+Z/hNLqFBT4aTlZlS01XC0V
	 7G39o+g0HSS2X+USPeAisdfF9ICgjlERoIquSzG83+uYkOsFqlKlWqVhZzbYHY7ds3
	 a4rbBTcu5fx7g==
Date: Mon, 8 Jun 2026 11:55:09 +0100
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
Subject: Re: [PATCH v10 13/37] mm: use __GFP_ZERO in
 vma_alloc_zeroed_movable_folio
Message-ID: <aiafcGY1PqN7edUa@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <862a59e98104db76ee3998460bfc55e937c218c4.1780906288.git.mst@redhat.com>
 <aiaau7RIhkJMS_oe@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaau7RIhkJMS_oe@lucifer>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xiured3y3aurrxqz6fgnkxft5wwn3g1z
X-Rspamd-Queue-Id: 81D15A0003
X-HE-Tag: 1780916123-736979
X-HE-Meta: U2FsdGVkX19JjbReAERhbjnv/Fn5dpLEaoKOYcdq7YLxADpZOyPMbGGgHDXAvzVg7PtT763DdxmCEqejp/XRv8PHcrz3NVdihZxqtlh1jO4o0a57PGUNNfgFkQhHP+tD8VVbNlDu3LpL7W/OR96f87FNYsIzI3BlATVgSr0kJzeTz0DpStiTnjUslwpIaBGdQh6YscbWCyqTtBVwk+7LqMub7lEeZtNfQlVe5DOamZ72XfugFQoE6CXlB611SHOQQ5vbRW7vLHXLv2YOpbbW/bMUx0eswz2gYIaDba2StDzeL0TloPMA+mopXbAyqrmx7bKgOAv4HJeHMoW8Mr/TGkqsvxUQKv6qQxBfbvkKUpBt4hGLx1lDNzpGsz1CXngbn0zj+OI+V4vZdPqS7kJ3lbQ/f+9O0WjYMWSn7ZNghwSgvMVh9FcaF2fY/LjW65P6H0HR4w3+ZJQlBx0pWRz5CfdKdhDkBcrjJjxk04jmR6+hkEDWEy6DKBjMrQH6ghLrd7dmIowTVWWkTvR+EK9k8j8+Q4EBVNmVdjkV20wCepMhmgZH7dEtz9zmH6nqoOQq63taUiZ/ZaJ/jzIVncaMMuL1cvqnn5jkVsUTnGLOBgdy9ctgwvNLaqvYuvkL4cebgdAbG1M0F+tdt6bhHY0ybqs9+4XqnuMao/s9+zbdFGshhMlvmfyxvg1yRI7GI3Ne5vD2BLNANmRf9apvBGj8ea55QkcR1zhC7uibQQQ6fhHX2XySvyJoNb9eSW1chTlZn+f3ekHPPDcJwgx/kCTkkLo49yYkSjm5u3WXc6bQme9sYSQS7QCkvSZwVj1EFECR1dwLTIDlw9X33+EbJd2yZj3yPmhLY3sQQTkTqgl7EozKORxTq+L1eYsl9LxChYLGQWK48W8AMXsWmbuWCHYub2H8Utpzh4utUvlZTFSnNLcwlTsy3ZaZ0Lrcw/SBEMF7dy/ZSPQUBTcUJ280AGg
 o/IpXiLN
 Xu5TCzMtuRuoq9mc9+Egk8NzapqKmDJ06Ocel054diqzbodQPvhzDXCcfimQPHjidRM8rOvuxfpJDJKbVjVUOhcMb06pGmmuFjCHK1Yjjd9GcdcpV4arlH8mYZZ6bKedVCSS7gIwlQ8ROX2zA0Pol36jgChPFbLyeKeUcqiY76Lr7uaG2VOGF6NQw8DLYrlGIxC1I5uZhV9Ura+XPd4cKQcWETONC9mJ/ISrKhjyQgXzVJkx7UI/29zWxVn7bsqpOE6gd8qAdLIXMBt1Zz9YBblnejxvf1ikpylPIp3snQm+zrrbMXTydVr+drE+h87J71atcYIcYtu6K57TFBoONQ+sXxHojVMuZ9m/dCEwUDhv/VLNQnAg4H8475OKT+HNKmfKJXG2xy4REyd/iF+y7JX0Vog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:40:02AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:36:51AM -0400, Michael S. Tsirkin wrote:
> > Now that post_alloc_hook() handles cache-friendly user page
> > zeroing via folio_zero_user(), convert vma_alloc_zeroed_movable_folio()
> > to pass __GFP_ZERO instead of zeroing at the callsite.
> >
> > Note: before this series, replacing clear_user_highpage() with
> > __GFP_ZERO was unsafe on cache-aliasing architectures because
> > __GFP_ZERO uses clear_page() without a dcache flush. With this
> > series, it is safe if the caller passes a valid user address
> > (not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
>
> Wait, so now you're making actual correctness predicated on correctly
> passing the right user address??
>
> > it to post_alloc_hook() for the dcache flush via
> > folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.
>
> Yeah, ok I'm beating a dead horse a bit here, but no to this approach.
>
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  include/linux/highmem.h | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> > index d7aac9de1c8a..8b0afaabbc6e 100644
> > --- a/include/linux/highmem.h
> > +++ b/include/linux/highmem.h
> > @@ -320,13 +320,8 @@ static inline
> >  struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> >  				   unsigned long vaddr)
> >  {
> > -	struct folio *folio;
> > -
> > -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> > -	if (folio && user_alloc_needs_zeroing())
>
> So now we are unconditionally zeroing the pages even if
> !user_alloc_needs_zeroing()? You don't mention this in the commit message
> and it seems like it'll regress performance?

OK sorry I see in 12/37 you do this there instead.

>
> > -		clear_user_highpage(&folio->page, vaddr);
> > -
> > -	return folio;
> > +	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
> > +			      0, vma, vaddr);
> >  }
> >  #endif
> >
> > --
> > MST
> >
>
> Thanks, Lorenzo

