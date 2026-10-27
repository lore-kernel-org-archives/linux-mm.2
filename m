Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A3D606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IK7uwDYg
Received: by kanga.kvack.org (Postfix)
	id 438C76B0678; Tue, 27 Oct 2026 05:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8726B0679; Tue, 27 Oct 2026 05:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9DC6B067A; Tue, 27 Oct 2026 05:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6346B0678
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:51:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FB011A0920
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:51:04 +0000 (UTC)
X-FDA: 85367937648.22.12B026E
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9968640004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:51:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IK7uwDYg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YikRuHrgcQQEQeNLoopicKeEponOUqqAXOCmGgP7bMc=;
	b=TlOwHjIY11ofwZonXPyEPX2pAmVYXK1xSpm9LAP0ybwmqdMs0IBw69RqYd7XOzefNRVnRQ
	QtLqueK5jnn/s8LmlAc3IuKzl+pXHFyp/yz3pE/9GUJoY/9C/e3nvrjpPWizvxywS7ECVD
	mODGw6fdjQOWHuw0HkyguVBoRZbOq/A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IK7uwDYg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094662;
	b=eWRa8eABZ++EbXIyraSsekORSFThB65vol75K6mhI0mMWNsiWwowuVWiKlc/2KXQFtPaeu
	FeCQoM9aoOVDIvknZDMjzT4qiIS6yjXGvUqxaPeT6zrvPBw/IQ7Ctc1/odItUCSReXIr6R
	LEkUk8V/aFVqwCi1ZDtmACraH9B4MRU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YikRuHrgcQQEQeNLoopicKeEponOUqqAXOCmGgP7bMc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094661; v=1; x=1793699461;
 b=IK7uwDYgWnddzMvKWJw3ya6jd1O95pxiSUka2B+d5LCvMVJF0eAMpUph7VCpo576csv7uSk+
 RkWa1+WT24INtT8JnumhbrIqAEhPNriR3IJ5BOtfXhCFSYVDbHBk/S3Oe6w++M3F5lyKhOZXvxs
 0YEaxOC7g+vVBRZSfwe0o1YE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 7697935976e69603;
	Tue, 27 Oct 2026 09:50:59 +0000
X-Mizu-Trace-ID: 7697935976e69603
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 26/46] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 17:50:32 +0800
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
 Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <377FB184-1E61-4BF8-AC3E-33A79EC56658@linux.dev>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-26-6f74bec9a5bb@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 9968640004
X-Stat-Signature: d9omi1tkidew5jjugyc6gtgttsu7qg9x
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793094662-645260
X-HE-Meta: U2FsdGVkX185bxGq+o6mGTZj3LAHNFQOfvkcPsk98AERTmVVge3mfmg+biF8XNbcAw75cPoaTRO7HemoYaDRYhdVsHD/b32Vp0B/oBN6fpKYICqBS2tZC5nOwJ1P7YCIn7IQABKigZ8q7tWutcUt9YoxfQGSl7AfNry4+G2MyQg4sGQ0NanXqulz4+yrBkOt2yXZXmGygnKOwdZr6iCtmKCdg05yRZg1lIo/OIq2W2e+ybRmjtvOXF2imQEmOgsO/ccoqUx1KsFmFPquCN86GE2VCQn5AUYV6eg1JWEq7kNyji5LapKjw8hw6WfrlIAyZr83ND06wUuvUUeX5x+yhW6OkoJRYKr/PCHyJcEOm0u8Cj9iOA3j/i2DJnQ5N35ITFTZ1nPVgjOzlT4ClVDBmzC6AlZEWFWqtQ6h/CQx0WAYa1PP82FOaix0vYedC1yG8WyPIWFTdvV4cDxhzpmz28j0QCIyclRi1btPPWqBmwbr50w0TZ6xDeGZ1tM5KTjIHoKoGVDSBsLQo31Zkf/tTgA2+wzc7Hy5tO2oOl2eRp+rVmVz5vs/Nke4H4cjeHTbeA0QyZmYXVe437dFSu2UIcraZZC0qwEekqxpAGMLG813Wf4Ee+1veReFmIR+/mQWivrFEpL3Hihyn9hO3jYOzLuuenf6BD22d/GQ7ImMl2vTHC/XfBNBk3JxCDuKg8dswx+P/0zpJQQ6HUegXH9UfR1jcBCiFAhqpt6SGg1qL29nlnqFJBbbjKD2X63xGE1sprmpXAcKbOyDLDu0pL1Nqz4hmvHGTvWHBTw0BJh5uWmBTNcnSU2zhVhZ6ByzZB6uGcgnTr35ypcq2YS5Mxz0M+QzO2/uFCuSTAcQDCXWwNnHlvODELCoi4c0slCR6P+CH2H6gIFnSWBp32R7WPaoxurLIvqKaYlPWAHDfA8Tucw6eR2l/dq9xkk+LGGELeqyh8Pl/eNI1M+rabeBtcN
 A40vJAH/
 22PG9QuxBcnjOn5oHxlwtLmszhNT3mzBgRdZjJL7sByXvvzRNhdD7oeEGGxSGlxW7EEvicA/iXhfxgFBI08MuerYXfrP8/02Q6MYyTth4CTKqtuyS8UoNyGF+4NBAVt1DeWQvlCwRCSVxj0aDXrXFoVz05JOytRpzFp6f3UdPTjVBMECoCwJMkH6SIFE1VtxjIW5AgzrLzFk5NPNRsgEsSyGllSovdMueIte41C5KWRN7cgkXICIdNMEA0BDNk8Wkt5uMs9thBq7ouy9GcqwaAZvwUas41aqZUdZpUEUrT2K7dmI3U5OcvISSj3EbYPFSVgC+rz9TyyDuu4PBjUGYfhKofuajdkdk8GUaDJ6QPFiFTCvyz7LcvY0MH2jh1/IBasopfx3NhGnu8oazcvr2PSp5+TAXDezdIcoHtKsNhNUqtPzj0b88hLtSJYCM75CQD8xaHni6Gjo3VaX2+1NnOmbBCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 07:17, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> __tlb_adjust_range() takes the size of the range which has to be =
flushed
> as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), =
get
> and pass an unsigned long. Consequently, a range that is 4 GiB or =
larger
> gets truncated, possibly to 0.
>=20
> On arm64 with hugetlb, a 64k kernel can flush 16 GiB hugetlb PMDs, and =
a
> 16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
> at least these two scenarios are affected.
>=20
> Fix it by flushing the proper range instead of the truncated one.
>=20
> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for =
handling hugetlb pages")
> Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when =
unsharing PMD tables using mmu_gather")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: use two-tab indent, simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


