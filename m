Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7586C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E306B010D; Thu, 16 Jul 2026 12:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9158F6B010E; Thu, 16 Jul 2026 12:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8530E6B010F; Thu, 16 Jul 2026 12:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDCC6B010D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:49:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5583A0241
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:48:59 +0000 (UTC)
X-FDA: 84995224398.06.5768590
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73EC8A0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:48:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DmRBhybb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784220538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YolakZC7+j4Triip+5AUHmDQgBfWSYQIrahb3DvaRqQ=;
	b=Na5X9mdMtWG3OyFmuVUjS860Jy0DQr+7aEzNTVevhpqQ682yW5GIgWjT4PxXzMXP6sP7WM
	VIaKnWQwBrld8NQZ2TLTpfFfFHBqiUm9dd1opS4SXEM/yLQeMM8tm2U94drGye3BYF3JCn
	RbAQkhY529skK25WTcptnFxxdh6yXus=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DmRBhybb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784220538;
	b=I3Myu6WxSO9vVauWCrraweeX0myLoQHiOyq4NsgsmuiQDneVZN0ONTz964msafdS+SUeA/
	tgZI5uppy8reVuYYaWBh4LrUHZN3Y8pVSC8TuPzir+rQy3MP0qatJH0/B3nc4xsOfiy2sg
	Q0E7wNhFBKVAhESKg0+us3fNI2dK/gM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YolakZC7+j4Triip+5AUHmDQgBfWSYQIrahb3DvaRqQ=; b=DmRBhybbCSzjOTtB6P0D9mXEdU
	yxc52/21jT9BQH1HCdU0Fxtxppp8xo7Cw8gmaLjV39caaOv/rod9RZJFZ47/ITb+erC8p7J00Soft
	nwMO9EJQ6eB1liCZiaSV4Jr1z/9H7SMYlyvjtqn4tRmt9MteyMbAIblO8nUf6vEA6etbdfyyaq8Zq
	39BQuu4wc7kk74TeSYD21Uw5zl0v25dRj69cW7lkeU5WtVK7wQSzBk/8wqzNKS+jgkmvKSBvcrbzM
	6Mp/lqi2xahBjs3CMQmRzrmZMSsN3onlbw2DQwijz3r5hY3Pi6bRJqBLVSU7Yp7/w6BhOXNNFaRmg
	bXiXDUiw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkPFr-00000002tsW-2hhO;
	Thu, 16 Jul 2026 16:48:11 +0000
Date: Thu, 16 Jul 2026 17:48:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	iommu@lists.linux.dev, loongarch@lists.linux.dev,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Message-ID: <alkLSzQvzT9zJbY1@casper.infradead.org>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 73EC8A0003
X-Stat-Signature: 1kasknfqepftbr34uo35nwriha41bokz
X-HE-Tag: 1784220537-726181
X-HE-Meta: U2FsdGVkX18BHfBAN6Uqbel88zXCKC1xc3PZCHxSCcPQ2RDPipZorWBGR7QrI0aK49Ge13YGKI0pKRUnnwIcra77oBrpRWiYbJWM4o4rmlqYh0ftnOSvcWrU+CbSG2EbzYR/rOBOtnVBbHj9SouqmMn6jXuFYnoJ5ryjDuOG6vmLT5UQpWbMCvR5xvzRfWEybD12i3kFNUpoDxfqhwDhJBwp3sHPN8607moMUSaBX10xJ32nq0wtNjKmvAclNTy8k3JkrlkT6zxtqcGDOS5xcXXyZgAWVumJyGM1c9OABLW0TAYUpEYIGHjP2RObfQ/FHEyWsFxDVWS4HS2XD/Na3oGOjIGhV4UNKa3Vd9IxGkGYh0I52FjV/adsBL53DSA3B8LylTymmUVQEDcIbTUq/VW3GlE6nW2zCnOpCZrCjbw8kkUK9yDwJHB5raSjhVLrjpveHfZrmvuNSBLTleAIDZGgwobj/BUhJdiRx8U4qomw4GvO5joOMfXsgpJspOd4eIKnNRvSmfkbeBt+S4eHoB9DG766euE38uT4tYpZG0JqI9CTnuoTTZG+W23KaTeHHu4mEUmSpnUP0Qwh7Eo/a1Aurj9G5aBk5DrsDjJiZzx+RpMbxyhCSmjkXC0/rr0va++GRv5XiUNHYTH2ELx1ZJ59fXdjkpIVbz8CC0oY3dcpBBKK131dnKj302BpPK2aG+QpzfiGetdogOX/FJz30KGEOONFCjeDXlG9LY3dipnSRYFZn2JjZ8327/CXawyQ5n1s4QBQaXwvaYrcuwEPkOiG9TvT8i2OILyFlbte5bW1aLfMGvyPj4STBe6KZkbH0/RAxZKGS9Akc1V3tAvQ+2zgfnugqEt8HbC4CRHuLRPBoLnHhu0oe+bSFQwd6ffJ6ZlkG5O+8lAzl86fx2aKyvZ231U6Fm/iq1cnAlYMKqAPOp8adijlD2+oo2y4IIdzR0Pusw+hi51KXT95Gc2
 u8Hs683Y
 e9tHvhPLIhe6GcOt4Z6OsWm6K9nX0OwIZL/3wofLL3pY+eE3Nl4F1NRpR5hEiavprP0/p0f1/i/6OKonVJhRmfbifPM/QxzLhcvkT4cWP5KmQgssVynvC4ygk6fiptMb9D8B4+KUgfH0VXvVixZTHSDkbttjnIbhTXkE0R1awefjAQQel4jiXL94hl9wGNayelefbfsLbmERLvg2ciVaHDK5brhGfvAI01Qgrvi5hiaGcFbo8EvwNe3yqYflU/Gkx1O7T8bNAZF2qbUcoa6+jrwXwuF7JnDDzx+LO6tkjPBDOflf3pc0BqjynMidrl019ESuF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:30:10PM +0000, Brendan Jackman wrote:
> There are no external users for this surface, reduce the scope.
> -struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> -		struct mempolicy *mpol, pgoff_t ilx, int nid);

Hm.  So what we're saying is that allocations which respect mempolicy are
only for core mm and not for, eg, device drivers to do.  Is that really
what we want to say?  I don't think so, because that's inconsistent
with having just widened __filemap_get_folio_mpol to allow guest_memfd
to specify a mempolicy.


