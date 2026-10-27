Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D85F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M5HfFoAj
Received: by kanga.kvack.org (Postfix)
	id 56C466B0675; Tue, 27 Oct 2026 05:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE06B0677; Tue, 27 Oct 2026 05:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F1D6B0678; Tue, 27 Oct 2026 05:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9D76B0675
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:48:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6369A09AE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:48:52 +0000 (UTC)
X-FDA: 85367932104.18.1FCB91A
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F331180005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:48:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5HfFoAj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+/m5TRiUEroTYi/JhU/ZMYvRJ27fL3IgAeL8IYLhOs=;
	b=0ClmnFlLrJdE4skzWf8iTlSP33rwqWCubDrfWUL+3PNeYsi0RWqPPXdLktqV3NKYz+UPw4
	nKOd8xTPBSVUIvNNWlu9EsJpTP7xfdlYhIhqnHU3SJZF1s1nqVQy6oUKcwDgXmgtrtxKC0
	gMlsy9huXR5gHhriSZIGA66M4cwfkng=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5HfFoAj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094530;
	b=aTbFc1WthspSRU3jISO8PaQ+Wqg/f2baBNilYV78cZG0vqsUAiqcGJOikG2XMq2rQDYTbK
	FwWo96Gn4t5A60N2+bTbvCJp7n4zNoqLBcE13yx1TMGu5KDhmCFQEYzh2NFDDg9BomaUTT
	r9NMPaK+f7MJeoCiweTdbEGzxV5Q6Fk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w+/m5TRiUEroTYi/JhU/ZMYvRJ27fL3IgAeL8IYLhOs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094529; v=1; x=1793699329;
 b=M5HfFoAjUDnRgQrtlqwxlCzg/yUz3ct1gnJFOAIpEV4mZEEV3dK1BLmaugjdYXhR6Y1192oO
 bvxwaI9qa6LHkm0LAQTLWGbPluusZ6PGzBIq6PiGDoL/kcvoOndbK+wUxRwtkmmdvKO7NuAJ/E3
 CZvZDj4wGfkHNKwOBZvMDrNc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 74e52af488cb4c06;
	Tue, 27 Oct 2026 09:48:48 +0000
X-Mizu-Trace-ID: 74e52af488cb4c06
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 44/46] mm/cma: don't release CMA pages still in use
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-44-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 17:48:18 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>,
 Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C94DBF32-62A3-4010-808D-DEB2E17DC552@linux.dev>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-44-6f74bec9a5bb@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 9F331180005
X-Stat-Signature: pur4uyx897ayk6iqptsfpayujrhgkxx1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793094530-196512
X-HE-Meta: U2FsdGVkX18Ya9ptbM9a1SzLQTBfoqXM8MCEys+2w7nGhCYUfghn6XOFKBBGVWMQ8LvUvrJkB2NVKHgXk72xHM5R4bEz1gZfUvVw1t5a7+YBw521/pBBzMeFog+vkqI7dwxqPZoKfQ84c+TIKlKpAgeBAbpuT+HhqtW9AC5xXnNOOySQvgp5MrjTfdjGP/dWJeRZVfgVUJ4orgKmOJ0o7uQFifE+rybB4BxxU65HX1LnLHjDoS1LBY5JTY6a4w8/cPVQ4HXbGbSL3aYO7C3G2WPQ9VZmX+TijrJiUdkthWI31QmRhPLTpMcaeWXQ5w5HXx648A3LYoJJAkrs13vis7TER9LKuvRQMYXLx2G2+Wnuct4G/pTW1j1hxwLKh05rFdxQCSMsDbZzOgP+kPq0FYHnoEycwYFhBCAMnFwHvG/aqrvXfhrQuWIMgphfzx9wsfz8fHql/Xo/n3mue7t+D3QU0bnKIgbRJlH8L1kLNKdaP+/d5I8ozbr/AcHgY8FMAgbfmEwAajg8rKpoa3toNFj1EXtGZ1+povMA0USFUzuDjrG1+7u4Yjw7X7WpjUksMpoKuEaGpqvfWGHc3iNWTNH/76kQqvDzvAG7nNKnQyhjcw3EfSl/gxERnMm9b634lI+SfC9wTH6uzDylNnlIWmGAc/GnWMq5oxr6nz3pDtPNi51Mg0BfVzP2/eMfdNsdNL8EmYZliR1Vy5LWUN22C7SGENZOVOQ8gu/w4Lc7srFAtSAbe4iAck1WseBVX0ShUaDUYSyohV4F4V0hgsO569ThGhY/wZHJKUPJ+T6QeqfyzUuEllJy45L5TWDMSeMtBSc0QK//+SmMu1xu/eGDQ0Rg/etOy4ldWXFLFcO1DAOyr0HQ5OBjZ3uPECBV12JFukA2tQ6CwhIXAz8AdBg+a0zKecOzSJf3gY5fj/9gtpL/zm0HE/oJJNazXqDb6eMKmljHrGnI5Ev+xE3hYIX
 Va14aXun
 GneFfRt+fW3F773O/lU7Nu7iGTgZlQ53tZ+QePcKDWOVnib4HNd0a7rIc6n80kGu0Ci4l+Ttro5s+QOY9I32fSIxPu5X26p0J1hny57SzFJzLUvCJLK5r7DMN88AhHcSbeU1F5jSnEM7ExIs/hNfc5zTN4zNIarsFzmss21FiQJpYjZZYWrrZZXsnJ03ujBvet0KRBE2WjruxHZZTyxLTJwBUnAeMalzP7PDVyTmml6H5/1bfHBiBdX++KwqtgW+xFaj4rgrfw09IgTiWFmEPxKnia1tZlyzSAu4rOXvXkvVYDgCag/djRwRFdYUOvSsIPTAj604odcbBhgYcpcxBQ1r+CQ1APh0Y15Xy450fqM7WEybDOBlMA78mqaAk6KMhO64ZfMw+snd/l/X5bSGtdCPkIYhNP0Tq1YkYmmWY2Z0VTrnuIiI0kMG2BYcHERFRxOmIU9xkyESf0aOKJIBcoZajb8lYl9Vi866L58XGJhNYrAOSd6/yZraA8WIyQatSs6Gz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 07:18, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Rik van Riel <riel@surriel.com>
>=20
> When a driver calls dma_free_contiguous() before quiescing DMA, the
> page might still have a reference from the device.
> put_page_testzero() there returns false, WARN fires, but the code =
proceeds
> to free_contig_frozen_range() putting a live page onto buddy and =
clearing
> the bitmap. A subsequent allocation can hand the same PFN to a new
> owner while the original holder still references it.
>=20
> A concurrent put_page() that drops the last reference between the
> testzero loop and free_contig_frozen_range() can double-queue the page
> via page->lru, corrupting buddy lists.
>=20
> Avoid the corruption by not freeing a CMA region if any of the
> pages inside are still in use.
>=20
> Make it explicit in the warning that the driver allowed a leak.
>=20
> While at it, use page_ref_freeze() to make the semantics clearer and
> switch to pr_warn_ratelimited().
>=20
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Link: https://patch.msgid.link/20260811132045.5f114772@fangorn
> [ david: use page_ref_freeze() + pr_warn_ratelimited() ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


