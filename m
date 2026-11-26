Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051DB606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uz/N4q9K
Received: by kanga.kvack.org (Postfix)
	id 9DBE96B0B59; Wed, 25 Nov 2026 21:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CDA6B0B5B; Wed, 25 Nov 2026 21:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855E26B0B5C; Wed, 25 Nov 2026 21:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4946B0B59
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:07:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9109C1A027B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:07:57 +0000 (UTC)
X-FDA: 85475634594.04.E110C5D
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74858C0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:07:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uz/N4q9K";
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658875;
	b=WsWPeFIMVGpyRbZAwJKRpbcuNwN8oT9UXu1HiCTC1wsdpjTsxNbuIX1jOJ215IpDvi8S9q
	h6tzxM2nGzKoZ1kvqc4kPOP38RihEu13eNfgrco483N/U9Ce7BEmzYrCTzf5n0aTYvx1Vf
	2Ss7Oy8v4SmrjJaoeiRSUmEycyP9kn8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QLSDXfx2Y3U/9u0/2RkJvZIPOqyHoT/oK2W5AWt4wc=;
	b=Q3socikDtxmNOCZYyWijolbqPxoe+gKnoo4YqUhy4RjkvgtZfpMC1NpOpiPs9vcVPHT+AK
	FcrKlKUmaKLAXtOdBWTQSQou5vI6owj4grGxaFFmr6D73tfbS81onDFxM0NcSaM3fhYDze
	vcgYB6zo7IJmhC68TrDdyhlve4r7ilw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uz/N4q9K";
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0QLSDXfx2Y3U/9u0/2RkJvZIPOqyHoT/oK2W5AWt4wc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658874; v=1; x=1796263674;
 b=uz/N4q9Kwga3uQDEn7wsrBLEvVTVGwzWV+3DruxjQzETN2986gyEE43cDVb2BkQwJkbSvXIN
 uonW8NthD0JSPBUdyUrCViplVAUM7P7pBf6jUnSXJm96cqllpr5OcZPeilUsO1rsv9lAFWMjSsr
 cnOWpqJudhSWSehEhZ/GUGAU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 648b555ab3881891;
	Thu, 26 Nov 2026 02:07:53 +0000
X-Mizu-Trace-ID: 648b555ab3881891
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 09/21] mm/hugetlb: don't zap non-present entries when
 unmapping a folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-9-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:07:31 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3FBE1B4F-DD8A-49FC-844C-8E073C5B7623@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-9-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Queue-Id: 74858C0008
X-Stat-Signature: 7onbbmy413ei8rf8xqc3n3b1nmnd8ohc
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795658875-925627
X-HE-Meta: U2FsdGVkX18lT2uPtu++PQyrQ4n1xrm0D7aFtVTWo9gEfuG6SfoE+0hxQzNgBqehEmAQg6vyfPgd6Jc3O/NuZfjoMqWW1rh2xjTqat1LZcyhnHYPbdqZ/a23NLbX5OTAbQMZzLtdZMohM5QTAQowJvNc9o7/YlqsdePfGcsoI34/3IGvC4ffP8ndTu492AnscZC9wqLZdFmWSu5WiKZ19Ro0fSO3uQ02GN+8nDrPyV3fRNtiJR6MLMh63+SMjMT3qjHVwXbhkzh4Viy2tNqPpBKkjna+2PEous0kCn/zko3PKu/dOSZDF6AMlWyQ06SEBRc1ZbfIFU18dO5bY5j6w0KxZTQFR/WB2CtFqDmVG6aWc3wPYnKHHcMSJ8V2rE2dPSOBfL1EG9vUTcVb4gumpW5R2MMjQvBb8oc4RxzuVH4wfymNO5pdfwFtSgPCce/2fN0+g0SnIMJPkb3VORflPJ8djZ5l27p9hkYbpQVZD3V8E9d0AnpIV/fB5o1hKHUwdZBWSS63hY2+RLsFsfN2/kzJyPPD/uOJ11yFNoHLKMdy0NiN4yreLmAHnwTQXnZxUhAZVbgnOnWqCNv11LcYDRvE/9ZmJU77laJYeeniQ35S+5zU7LzppIOyuuKsEYOjVFNz654S4fjXkZVJ3hCEp7oe/R2Ksd2Q7++8Squ7+FrRaFJAwheH0D2oKTECgXNdSXl5UR2FU36QBrJ0krS9g7idBnxzOdyo3TMn4FsbwkHxWFHFgowTJc6wnavTd1CUEtiZUJaCqfFf7Fu8+FjeTrKbV4AykHEUouQuztB1rpmRC+f4/76GxxQ7eKVQSmLiI02GwIE68dkpgvqVWhifPo6FAnglyRPfVjCueR53wG/eaP2auXTWIYaDl2HfhD9WPciXZCC6azLHmvB36iQcLjOzgEgoH4xpNbJiiLFGaMr2Yv5BSYHGLIqEScRVQfJDwD3qGTga3CndtsXxiGR
 Dcg8EmRB
 NLeYlx6gpmCcA30XdXbIcqL/kkA+b4SvWAblc/ycGu4QCMmdE/OuH40AGqGBTSbjxnQ2I5PEhxEnhHKpxZNoqd9fWICx1S14xrKm0OlDJtwDb9t+Em6XMTpcfUSBLLvvRB8rRWkWonlReW5QdUVAy9evocvUlphb44ZiBrgmfyEe+ewoyIZ+bPEspgxoumyEmS7lxXB96TtspPuRug93O/oJz3WZYpbs2czxqKxFo+GC9uYVvHYVpNdSHEKj72qw2OKv9/sV3knhUdZfHgHz8eh6kLRb0YPSwAwsxH3NBjAg81+LYoyvhs7fZQC+ZL1X6WAHdakS5b0/gliwYVmD1nXp/nsvWh+nVBY7mtSafs5y3BbPcyuZf115INscr4/LhEpbUf4qR7WUsa00MdZ22cAvJNRHPa/IFMRXymYjEYScZ+xzejGdOoFRUe+B2xUAycY2R+Goi/du4DI4csOIHLr+xm7ZkiLdjIv6joVhWyZ7P4WyaoMyPIUQYmTPN2VDGxXLgHpYi6KuS3xKpiKh1op6AaDz9s7Y6PvAp1jAgHLcELrHR3dK7GgM8wwG875dnIQJzSq64l9zzcyiupIF/E3ZBWG4MTzlKn4J/PIlAtOYtPBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> When the owner of a private hugetlb mapping fails to allocate a folio
> for COW, unmap_ref_private() unmaps the old folio from the forked
> children, and marks them with HPAGE_RESV_UNMAPPED, so they get a =
SIGBUS
> on their next access.
>=20
> hugetlb_unmap_range() is supposed to only unmap that folio, but it
> clears non-present page table entries unconditionally.
>=20
> A child can silently lose its COWed folio while it is getting =
migrated,
> or a hwpoison entry or uffd poison marker, without HPAGE_RESV_UNMAPPED
> getting set. Consequently, it would not SIGBUS on the next access.
>=20
> Let's fix it by ignoring non-present entries when unmapping a folio. =
As
> the folio is locked, migration entries of that folio do not apply.
>=20
> This has low urgency, as it requires a failing COW allocation in the
> owner racing with migration or memory failure in the child. Let's not =
CC
> stable.
>=20
> Fixes: 8c4894c6bc79 ("hwpoison, hugetlbfs: fix "bad pmd" warning in =
unmapping hwpoisoned hugepage")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



