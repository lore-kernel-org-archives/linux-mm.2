Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00E1606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZQnT2Dwd
Received: by kanga.kvack.org (Postfix)
	id 960046B0B55; Wed, 25 Nov 2026 21:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9375F6B0B57; Wed, 25 Nov 2026 21:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DE16B0B58; Wed, 25 Nov 2026 21:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 609906B0B55
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:05:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E75AF1A0268
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:05:20 +0000 (UTC)
X-FDA: 85475628000.11.D4F73E5
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6567140009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:05:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZQnT2Dwd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658719;
	b=mRDLsB9MRRLHhw7wCvcFtbnw7NYPsQKBfCd6vTwXkTFGaZrF6VJFzKTgWFrACqBvS0XaPf
	lDiwQLZXk/464drGqViVK2gvFg7mEQ+TgXCFHV7JsHwclzaseLXDWQ1C3wm1NcbSW4NhW7
	V+0EYSNhSxePUV9WHtbZUShgZBdefyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f8HopAilRekX4oDmbEUHNnRptZx1Qep0LVLshbVfgc=;
	b=IFBGzOCsMDFGssFrwEYjvMFhaF8+fe4AC49balpme9J8izpJMCpC06L6ipG5R4iUDIk5ul
	ACeJwAPsW9qVHNh+qiIAtCI5ZPQqhNi6WH0SqTpG+Bb/OCbdN21yA1QXYQUpj2cYaI3qr/
	A8mqqFqBE6pKO2jG8ZXnUDlynYi0Dt4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZQnT2Dwd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5f8HopAilRekX4oDmbEUHNnRptZx1Qep0LVLshbVfgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658717; v=1; x=1796263517;
 b=ZQnT2Dwd4OZHvVTwdB+ZOAhxiIQZ514z1N2rUUTvnQYjr9MULJRHrTUmxrahjznEPZqNmMoL
 ZtAM01J4woT4VYWvbM5HSERLVNGHbKspuEhx7A1r0J6qgn8KEjr+GtZJxZGqD0ZyCRiyDIbBUB7
 stJckE0FmD73ku1/3AZAocCg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4765b56b99f04d54;
	Thu, 26 Nov 2026 02:05:10 +0000
X-Mizu-Trace-ID: 4765b56b99f04d54
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 04/21] mm/memfd: mark new hugetlb folios migratable
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-4-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:04:48 +0800
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
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <98C27A06-0FE2-428A-9B13-63E9CB0C648E@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-4-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: D6567140009
X-Stat-Signature: ctf6s731rdbrjkuweyg6z78dszzeo4bu
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795658718-693153
X-HE-Meta: U2FsdGVkX1/GBuW1WSb3DHaUkn916s/3CYmgrwvzX3kCOQeV8KCWzlkxgV5XRweVmH7b16RLWpdYIjm0Pf7twoDzWSBpF/snKnAAwB/E+hxMoLGrGDu3lVE5Kf6ae6Vwa6cgr56H4dfZ9qEQXX+6o4p1G4bKHni1uWohIGcnchF6calahP25Plt/zEPFpopescZIEwpaglq3P3NRfkx9Me3IJsQCH8THyHv2SUbWw8l+DRJ9vamTL3+dfKU2AFtwiIqtLGU6EoK+BW+gC7+Ae+nISeVM1plXhuRy7V23Wew++6cblCO/rFi4N6LHHRIrt4bzX6MUw1Ey/JuFsYI/Z54WrXeD2JbrE4HABBa6skES821lViiH+VLWNWH3PZQVF66Ap28jHQYwsKFrEBG4dJVmHX9mJWBFBiPNRfy4kRV8KKO+d25wzRjfbVv47oZGPaEuhpd2iogH5rq/1959LYkgza+9FGHn3C/c6posOS6sYb9gDe6TQXpsGGpN6XV3kjtiqQ9hE2j2FeoEc7S4isrpBGRNmobgCg23Q0oZ7dNjYoXOxRdxgQwa/97uPRpTlKf3EAAtN9xawcznMxv/z8dSPPAX+J5ug1tLGwwPWqVsZ5Kky5Zsmq55VFFY9AsE1Bvm6YXxM5U2loexn/X/tVa/S6ZgOVVSX8jPl4Yp9eJ+LqryKtEDZDQPirO0UPe4F8nJpKCCTkOFu5zt4E9fq6Y/by7UVyEmQMUqAQ/rfDg4sSYkEwVuwLDKvJ+NVOc6TqrDcidXXmBj1tloGsXM8L/eyUCW07iujocwG4Ox9ZRVVHUP30jNyDqGA6EYvt1iADhA0FVfqlnqcoPfwCQe+uj5Km77A14trkfI+CFRPkFtVE0axfn4k/J1EKOczeEuNmv6YMkwUYIjpZu1c8FiWBYyF+cxm1AEMdcpLRwfOl7r0Fs8m1FQUN3gpIAehwpOPbceNKjj2wIhGL0Vsl3
 DCdg05Rs
 aYyO5TGqlWBQwuYgBrpxY7UAUEZU/aynmhyehUuuiZqkQbVhG0U5i9C9dKmTBd7e+6DCDdTOWas6EXAzmmRbiTMlrjNif7n7OIrdkXqtTdyjmEPEZwLCGLDzvk4+Gc+UIhRA7LujCYvZuV4XfwMokOOOkAPaxqMFh3YCy6cKbCQYpRvs08e4fClJDer3LHbVEdiRoZZLGHCLXNJ4ZV700PI+4qJ7/Bhokt/yO3qEt/Z57hPH0NPIPhdMznln2thUkvP8x23u0w/f4xngJPWnW4HjAWQXig31qvKpNlZCKZrsZD7mPj4NvhqsOjX0sPcqL5Ji6vTeTUMwW4AiK/0jco76zjvzeO1QzCT5Q2xNs8l9mEpM7SxspQleWsZUa4Bz2jxQaJmUBhxW2/X71poNviCSpHSRSGeJ5TUzlXAC/f/ly1n2zV4H0X7P6iX+z7F/gu5YKB2/Arf1T+Irt7zHHLCJ3bgrpLgle/TgjQ6BhU1U8865E1qaGU8ZzFrlXd3yGWz9Hj2f2RhucYxo7MVZsqYoy40/iIyLnduH0NgrEiO89F3Vxn3CxMjgrbwRV+K87BpuF6UVuu6CZgw9/8fc9YLSi6GmEn3JZTBsJwh0/CuUKg6M=
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
> memfd_alloc_folio() adds a new hugetlb folio to the page cache, but
> never sets it migratable, unlike hugetlb_no_page() and
> hugetlbfs_fallocate().
>=20
> Later faults will find it as an existing folio and never set the
> migratable flag.
>=20
> Such a folio can never be isolated for migration, even once it is no
> longer pinned, which breaks memory offlining, alloc_contig_range() and
> memory failure handling.
>=20
> Let's fix it by setting the new folio migratable after adding it to =
the
> page cache, like hugetlbfs_fallocate() already does.
>=20
> This has low urgency.
>=20
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning =
memfd folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



