Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D963CCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1033A6B0005; Mon,  8 Jun 2026 10:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBA16B0088; Mon,  8 Jun 2026 10:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017D96B008A; Mon,  8 Jun 2026 10:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E67FF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:21:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0292C023C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:21:56 +0000 (UTC)
X-FDA: 84856959432.10.F60491A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8301A40013
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:21:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Zi/4pEzk";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/FvwH7hiTUiSgXuBMQJZGeWVoT1jQU76udfTFE9sNg=;
	b=CXa5eX4GJSh0RCeBUs8Grv3DB6sDWt2cLQSxCNu+xR26xJNZJctW3ZzIiKBeLo8dpTtjW8
	avIgpTeSSiu/ObdAuJ/OLgVQThbIpeCPOzyi0y872NWToSA2eyY1ncxufLiDklZqUfwTvS
	RQ+HWEP3xGzcM5zsrt6PuzfMJkywFOI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Zi/4pEzk";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928515;
	b=lKCtkZwFQ3+WqDrdEVU5sjBq+wKpFlTnvW44U1lWIgMF9odxNNt9WaQCd3TjKReaB8GzYS
	H/4d+PESQIKOYBCckjzVE0klZvKj0vhsonh7Dhci8HzXWqrftULnJzQbRlQe+0soPM5U09
	RUhWlREVm8+4IeKWRc2jc1BaSJKvsuM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h/FvwH7hiTUiSgXuBMQJZGeWVoT1jQU76udfTFE9sNg=; b=Zi/4pEzkbmp3eNe66ZAaDUYa1O
	fOc32vjLemygMfE9A3RkrAkbdgVmPv/sqfT6ysqFHPFFrBfvD55DXejRYaI6bCgYNF53/hH8jGHky
	zu2L5HVQnDcF4il0hThRMP3dfpVqmxdx9TRI2bb5Noz1rvTR4R4oY0DzWWRkWvgbefONG6Wum3uXx
	ESRmzCTd/xhw0qjCIGcHESk4G6UK3OP0GHqjxvOzNqPWEBaFFVOKjXCAQTlEY8XE7253MSrvrWYdh
	0isoec0vPjBh+/2uObNe0TStQX2gRd9NiZgD76bHAaeXhFt6O9yU/He8xxcMDaqHrYmp14YU0336T
	4kFGef8A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWaqz-0000000DqUd-1gvI;
	Mon, 08 Jun 2026 14:21:25 +0000
Date: Mon, 8 Jun 2026 15:21:25 +0100
From: Matthew Wilcox <willy@infradead.org>
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
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <aibP5W-fGcyPp9e4@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: 8301A40013
X-Rspam-User: 
X-Stat-Signature: t16hhtg3afek8bo5p4ztcjsbqx796q5k
X-Rspamd-Server: rspam09
X-HE-Tag: 1780928514-422126
X-HE-Meta: U2FsdGVkX1/2jkCtjYcJSR6FTCLExzQb8arurIlu47w/AfuUVudF79UHz9XVU2oq/ORRYv4pDnpzzNRGj6Wt7Aj/b9uxGmeQ1Ynl31UvQS7qtqWbKLNcGlMSv5bynUq7wgi4BklO56thnrg2ojqd/WQ6KoXW7mTsCn0N+bqiWWcdQG/iSj7gZNFr66q+NFPym2vN1EsbqjwbwWKBcsdBWTbZGgVCSy2kCY4p8yruUub1W6XmSsBrt1hssAoPhcWAcoisV6FSwhF01LrAPTkKU4VbyzQ4/HVi0GcpXZE2wtUggMZoEGSzV2Je/3rzg+8BILhfobxrlQQ8sumaQ6Q0H91uGTc/VLJ2qWU9DtWCjlz0ZSfFl34qmSa3+O6KoXXKzVOpF4M0c/KRpaJYwYjKlKydFKon3c/P8gE5yWocu2TfODqQ+5nHlOLUzPmngpHcSXnAuIA88T4S/2S8tZGbSGwas1d2CFPS2YvGuyAcqiURuWemfK4temRUDiXGoVDYHc+ws5mew4xQ+lrvGHt7/9vCfDDpiVV+wmBqAwUyax6n+U/PmVCXa6MDvOtoTaNAVc7Se1SrKTTU6aUUHIkkSA7nI+29VCfH1HjXPjYd29xDpRplFkc8SCG86I4QrZmUigVqsegzOKrFYv8GFYqhY1e6INHZoTB94JTTuQzOUpOJ3JJSMfu8t72F8x7mbS5qxV1BxIq11ZL3lyJDqTwxiDN0Xsk6WA5MRFjNU6W4lZT9YyrcyGG4QPUHu7QWyoCRww2MaxxHl/EjyeUcTABIswGNWADRHp2GdQMvRdYutSLOkh6zNiplMrDiD+Ou23s1vg+C9aA3vq4vcANrh90nW5ohVJlnr0o4uBuQIQ9Vjy0GxB7FmJGp+ONL8rd6LjNKYIiwnNnvumtynV8cL5LBztTbWXaUBr/louO4koymuSl36JtlSeFqN1I0ZddEHxmT45HJzel4yUa9Pbee50h
 HNOzIcHh
 kS7ef5VKVzclikVnGNJLtv0wVYUmsu2rtP8ysJRxu+6Hq7/MHZEo4r6nFZQuoL6zEMFjaxM+r6m7u5qmYij/88VoVpr1h4xsn50Bc7ZePpL9pXhhu11ZW+PBczbfLUcM6I4ZysKHyQf0QEX8DSUge3zvYpFOZuLm9Yka1t0UPnjot0orzHGO5WKPJmBvAgja+CRm172c2t3chULvIEfaXg/XItQQ8qsgsgE33NBD1tNbGf+mGm7DvHH/pT7BQOXUKh0n61Zt25oeZ03Z5uma6/iDNnbCePEo1xJTAdZDjEntuufkpjQTASBcF/UZ4CQB031JA+Hq4w5mrsCh9WKASRqmXhBhGD1geS2bT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:33:46AM -0400, Michael S. Tsirkin wrote:
> Further, on architectures with aliasing caches, upstream with init_on_alloc

Further to what?  Did you leave out some paragraphs here?

As far as I can tell, this patch series decides to trust that the
hypervisor has zeroed pages that it allocates to the guest.  But
as far as I can tell, the trend is towards less trust in the hypervisor
from the guest, not more.

