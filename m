Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34062CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A476B008A; Mon,  8 Jun 2026 10:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B506B008C; Mon,  8 Jun 2026 10:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A286B0092; Mon,  8 Jun 2026 10:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 507856B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:31:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 000AA161A87
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:31:54 +0000 (UTC)
X-FDA: 84856984590.08.5D48829
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2893020014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:31:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dHnnZkFx;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2Tv9hG8BF6SBNjB6VRmLZtGoDlqqE/2YoO3HTRhEYA=;
	b=wOuhUOHvtVhloCgBYlKYCEGF5HtiqrVAVVZxhB4sGEpCW30Qiy3vx/KTpvnspdg417qKCS
	pxVwg5Mbm6PxqkhPIUtWhbbck3sx1C7x8dtshUOvmxdL5f7n+9dM8bdJ588tNBczKfXG+V
	QCPKWNhbcE2nS1XMgryAEOrDP8rBNqU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dHnnZkFx;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929113;
	b=wlrzGvyX5EHzMJ//xZ9YQUdDkTx3UtlItMThxSZ3kdo6ouf2u2sonfR8EjMY++XmZKG16d
	rT1/x/BpeBr6hl5SAstinSHfeK5Yyc4zR6hu+2RxgDLv0ixw+WwDD6zRxOVQ108gEqlSSb
	ErZLSIGGtfvuA9+VQTxPQV8JRqr4AvU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g2Tv9hG8BF6SBNjB6VRmLZtGoDlqqE/2YoO3HTRhEYA=; b=dHnnZkFxVDWnflPsfwmp9sQPpu
	zzf5qC2v2ANr29RNwOIh7FkBcRpKxS+A/ka8ZCWJfWYG/9GXigQ/ziMHHd5sO5wMdeFpujsbxngo6
	gjIky9fKqU0gPZn58322i9nl5M0NoWhl+84NVA9Uq3fN7daAn+E4N7naR2McHiLNd1iwlZlQm+W7p
	vqtVx4xMNuRFPWFrd3ol4HFw146pAKaUOHIacwdt9LGe2cuSt5o/dai8a5OQP7xa5QApONj0qs+Xn
	XkvlFYmOZE4gGkILymTwxBv9te6OYA0KHDmdozrnJ49DJihKXG4HHgKxD3dfgDPbheniOV9vIqn0X
	LNNOe6ow==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWb0g-0000000DrST-1l5C;
	Mon, 08 Jun 2026 14:31:26 +0000
Date: Mon, 8 Jun 2026 15:31:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
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
Message-ID: <aibSPsc33YQiYSMI@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
X-Rspamd-Queue-Id: 2893020014
X-Stat-Signature: 7cc1455mxsrx9kk6h75tj95q5tmkjtdo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780929113-20839
X-HE-Meta: U2FsdGVkX1+hnuGZWNp9oGiNNT54598/8/dbed7JfeaEZZTdQWseVj1PaLqMsVbawweA0CBlN40367virUTpehlepaKki+e2thy1HA8HKUgQ4p1/C6XWWTdJPQP8p4TMDbDQG5wKT90f4yKsVUtC0FNeKzyd2huI/c4S1N8IleWz9elueryuaQRYb162baYtvWlultepKuLKW5t9H5JMDhrpr884W7F8rfuGnhDyyajKcUD5aVBeV3tsxD7+7AKvs46qK0b05lj92gUef0h887bOOf8dUmAgvBw8jkbJNrGLqk1XpBDU4f24K9jwFcKmWlh1RDwAx9rs1YJ6+ym2VySX9BQA5NjtwrxCiDZpXWk5I3+Cp3kC9dkgDdXPkpeTTNEb5zEJMKRXddv7DmTuZEty3xKVqqNX/N1cjC3/oVSnLpW3SfK4Rjq9ukAlIqLWyqDPR1wWUDSNGaGLWUGgCxOzlXoGZN708MsoRRe+lsh4XzKWVWuhMPvyugbhgiUtj3/O5UtndUNZbpKi2yqp9ckXy/LsqQV/z5sgRzysUme9W+C26wrTebFbXBOtE2HoqI5nkgEIo0iQpFKU+czmxYbAY09qS3t5+e9fRcf3wmdUv/xoUb/KnxjUJxFkU1Du+NjpzYr00lk3Dxs4MBegZEn7qGDuqIO/yENnYBc/bq2TmeVHBye8xRP2KVyJ6k8DlDlRqM1W+oCFFUdP//7oUv2/J8qqpRuZPXrelrj2eNGeLHMQF+um2th/2GuG6qLWVXALZhGf2+jmHE4yp5qyGOyRdLdok+ffU3X9pELyJHH0claUnEQOJHXb+AT/95ry031j9zcdNw0RXTSuQWW1lCQFv1n7i2cff0T4J1DZtogGoU0RURl+nCJfCKRPZwY5XxYsBee3iquph9NuT2so6sEHAY96E/sll7MSAtDFxRqXim2B84JPKF+NZsY963cjAKwa3l0PDYTsHi+7x/i
 zT5jeYld
 p3FbMJ/Z5vv8nmyBULLCbcBCtrkx/8cjVKzCOv9UhdUTzNvtx2lZKk2NgbFuloCvc6odmI9qTDoCwozuqLYA5tHxjlOHIssGxkcek/2UBPJSQr7saNAvZTfwHT7zOSZYk9zIyGykjRKV2wl7g89y9xJStSGXOnq+Cv2fD7PSpEY0XyEAv3p4nnsDpuP5HFkrH5sFRtyOFxykQhiT7vRdsqdJe7X+7UlyzDju4yFsM5z1T65aJ6YFO9v5onBEMCsSb1Lc1kYTWpSE5u8aBDZHTW/TFOMsHN8e569ViHV/H1mGUM1L0lgDG8lT9e3un6ALbyM9acdgd+FSUqOnzZ1yykY+GtkGmU9Sa70FRTkNcn2kXNAGC9qQXFKaTHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:26:18PM +0200, David Hildenbrand (Arm) wrote:
> If that means that we would handle __GFP_ZERO consistently in the callers of
> alloc_frozen_pages(), that would also do I guess. We'd still have to pass the
> user address down to some degree, through folio interfaces only at least.

What I don't understand is how the kernel page allocator needs to know
the user address in order to effectively zero it, but the hypervisor is
able to zero the page without knowing the user address.  It feels like
somebody has x86-centric thinking where cache colouring doesn't matter.

