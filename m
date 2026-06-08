Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E6A9CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4076B0092; Mon,  8 Jun 2026 09:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB4F6B0093; Mon,  8 Jun 2026 09:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08DA6B0095; Mon,  8 Jun 2026 09:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9033E6B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:10:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D519A0B29
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:10:01 +0000 (UTC)
X-FDA: 84856778202.21.650BBA7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21E5814000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:09:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c4ZBBJoX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780924199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UXKBSwaQ6wOhFTdLFwEFzOnJtE2mdR9K9zfG4lUm6E=;
	b=4pq3lpIDaC2KOESBlCWYtu12Hbrrzabo7YD2uwYnSxn5PeKTZGSV9lCxgagomOLjrZExWc
	BOWEju37le7voU1RcbxRnp9C0oOQ9MScZZx2eJMjsu4g5frKvtF2phVEoNycQn0/WAzKUu
	0hJ57WkVNV4xJK/0XYTVqRWpKjOdydc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c4ZBBJoX;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780924199;
	b=55Tmb3hUx4PtQLGl0/Bq6arwrPciAmyfdwxF/Z1e1j3WdM0PCCEAnbYNQ4XofQcTlQFa5Y
	MPJv/MidjSKxE5yz3SPH4a8YU8/7UakVw9Kzc6x/ziXMb1SNEaVPlDPyHr0rlsfL1Flq2r
	77F4OkEDv44TO96OOt+hKyS2+XTkGZk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5UXKBSwaQ6wOhFTdLFwEFzOnJtE2mdR9K9zfG4lUm6E=; b=c4ZBBJoXs86PzCb6awPgQPSZFx
	du+H98mAuQFn1Yr8m3TURjgWKDh/ImzxoY5Zj9On05ZVYpUXYHn6cfeESDmMuUuZPCGlbjkaQyrvv
	Lt4GhZEUXwGQnT2dlOicXkqIVoKdj20NKsoDc5B3vum4jJr/6F6BX4W3dw/JZR2G8l0/xa3/Z0tdv
	e6SVjRM+lv7i1LQuZBt/a+kz2XNLvJNnS/aka+4XDv1EQN9WVbdaH7HSfUUB+LCqVAB8yr1oCWDbl
	CX8KT+fNycj8Yi8kE5u9ibWnQ3skqGPvRAIJ6qx09ZSMchlbpg9nizVP+TtN94JQX81fF93x7WGhl
	zjbkuLiA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWZeW-0000000Djex-3ITN;
	Mon, 08 Jun 2026 13:04:28 +0000
Date: Mon, 8 Jun 2026 14:04:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Gregory Price <gourry@gourry.net>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aia93IzhTgi1vGi6@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiagMc9Ng_AE_adh@lucifer>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21E5814000F
X-Stat-Signature: hwpe959bp3ga5g8fnszsgkrabbf7kaht
X-Rspam-User: 
X-HE-Tag: 1780924198-9773
X-HE-Meta: U2FsdGVkX1+rCEVHyOVRbapTWPKgWzoAErcQ96LVMf5z/rAa23RAZBINnGgBpl6Q95mrv0Q0GQWWI7PM087mJtEWJk3V5NV2uivYveBOEttRQdOTm2gh3P8z/flokaP/4CRMSz3iacNYraF9gfmqezRtAoBsO98pJF/jTTP8eKLUu3/FXx8BxxSiZuwDFtnjFNlw5yw37jYkGbsrN09Xp62fJgkdPsXBFreLvBT/SdhHpK6hrHU9jYMYOKRPGE1HVcUlHV5f3lxINbf3our5jqmmeqM5+MV1qp7oA5FRnSYAr8d4GMTh6raw2qvDJrB3kdntz6sYtRn069Yq/rwSs31mHcUO+sYCQTn5jkkY4IeKyLQ45eQnse/iyKX9QfmcMSLf8qpmDr164eRJ6xmHgWR/jhctAlN2pxQkRjtsTWVAoWuxUCIQa5GqRZ2KJJp7eoZOIEnuTqBbmuQis+4NxnEeNTLe+xdkwLyNMl+0kZX+o4d1tpR+AMIKFJpNK4ZOxqrP6/D0eHEMfNA/V452r0RFfFnrzehiiPuTeM3j2iRCtloXk9a1kgEZcz4d8A2zIgyw+32b2c/uPt/qJfbQuhej/KW4dHS6Esoo4riJz6mmzrJjyiff+wBoGOydE3k6dsdQM0P+sukZrZQBG6GTmAdoFIY0N7YC663axeK/ldZBxBkFCtCaFT29Pbw0WLUaMGhpKAu8Ek448QjgIzho5myIH+4KoTArARjyKBC1NU+leae98qVH9Osgwa/LcWTs2Hdm8j41UdOlrBSWKsHcTnVuMaGXdz3VySP/qAcFyjjZS3Ic3y2fLkHhAU/2wjSQIN3TYhXIVnxw2d1ztqtsN3000FYPQJiuskFq2vq7Zw4igsrH5yShUf4xiYwu51AtOJvJh7Bf1aQ2mXuvLLhloNK5hasxrIugxqSJAfn6h8Isfr2qPvgcCf5Wi/XxhCYyz4c56qR3xy77yjtYlZZ
 V9b+zSlI
 KU7khe5vSJbATxI3rycGyaTGfd5+2maXWYVasxXBHmAMOfyS8DCo9rIfamRrQxtnvv/5Rvs3bqLGv5k9uVi5AY+cMYCU6uP79mzZI/YTQJEEZkVpI1UUKcp5F458qnyGj97A0fliZb4juE6lVL3Xo23dr7CO0oJD2RnO4ike0j9fEUNv1A9jUPcKJ8hreQUKn8CVVYsPZvJ5ojlgGVDhZQm2V161KzB9LyaeajFhGPmamIyyRI1TX/983JqIeg3Rf+iH0H+w3s8Qbqnc7ZT8sRjfHM2U5Qjy+TswMyALeV6aNGtzWX5341mQFL6PtvwXKx1yTGLsQs5H0LDVhuMbVTsR++ryeKbIau/2jjLxPd6u9sHi1iRLmSpzzsi7oIePeHvc065MqVXtq1yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
> But instead of overloading user_addr to indicate all kinds of things, instead
> make life easier by actually breaking things out.
> 
> Like:
> 
> enum alloc_context_type {
> 	KERNEL_ALLOCATION,
> 	USER_MAPPED_ALLOCATION,
> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
> 	/* Perhaps some other states we want to encode? */
> };
> 
> struct alloc_context {
> 	...
> 
> 	enum alloc_context_type type;
> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
> 
> 	// Maybe something suggesting context or whether we init before in some
> 	// cases?
> };

Ugh, please, no.  As I suggested last time I commented on this
trainwreck of a series, lift the zeroing functionality from
alloc_frozen_pages() into its callers.

