Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C241606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gNzLclvd
Received: by kanga.kvack.org (Postfix)
	id 53DA56B066E; Tue, 27 Oct 2026 05:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515336B066F; Tue, 27 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D056B0670; Tue, 27 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23CD86B066E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:44:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B777E140963
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:44:42 +0000 (UTC)
X-FDA: 85367921604.17.33FFA1C
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf08.hostedemail.com (Postfix) with ESMTP id AAEDB160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:44:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gNzLclvd;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094280;
	b=ntNG2AWDeKB2Mc+LeIACOUGkJn1aW8wup6S2DKn6WJjpW4vpUjWT7+OwKG7fnvXOs7S6SU
	gpc1VQgqei+VoFhXVZmWkwykHv4XQCx74OCeGioXmEWh0gCCpXly46OyBOOwoAPvpiyMv+
	xJGjFTN09P+hsAFfli0fb/fZWyd3bok=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gNzLclvd;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gg4vR3fmVnG5maxAfXCLUk2K7fJTSLOiXsuwQyP13c=;
	b=RF+HriHYMbeBczcr3GK6n4Fpm/dQlroliJHO38YDGz09/rXh27y8+vq5eiuBFdkvToVwaJ
	cxVg8S/xvP1l7rrNHnh5FS3DI2mzD6YgrmhsqTq3tPgZ3A11qHuC8tfFKpFBYCF6BFvdxN
	QQVT+kcM5MNUlRtGaPEwJnhUCugHbAs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+gg4vR3fmVnG5maxAfXCLUk2K7fJTSLOiXsuwQyP13c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094279; v=1; x=1793699079;
 b=gNzLclvdu9m1gyvv0pSAmIjLpny2p0E4lbCIgdharCug0gruLgksOqUPZHjJjYvzCRrMZEqZ
 BhMKbq2Tt5gWy1KtiCZ7kwh9wWR1Po4osGjY8vUU/f1n8v2J0dH2J2mW12ceWGdmUh6+8ngwqDK
 /m6YU/MKq9hmnUlKgC7g+22I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d06deef23f08d73b;
	Tue, 27 Oct 2026 09:44:38 +0000
X-Mizu-Trace-ID: d06deef23f08d73b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 22/46] mm/gup: check for overflow when converting nr_pages
 to bytes in GUP-fast
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 17:44:07 +0800
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
Message-Id: <DD785D08-2054-4DED-9EC2-A7464BAAAFE0@linux.dev>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-22-6f74bec9a5bb@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: AAEDB160006
X-Stat-Signature: fyyug339u77w9a5bn1o453yinpa5t7fo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793094280-816461
X-HE-Meta: U2FsdGVkX19eCFO3KAjUO3mMP0aI0BvQ6whg2I/Tsc1FFNyjGfg+RuNRLGKChVNY1/JUUZC9kBasFNtY5UWntUunhuCwMB4rEnw1NNFJvyAG1PSuAciMVmtf3NUexsbH20r6SbtvKlfLsjLO74SQXqSWA2HSKyxunw1db8UNHRdUSW/O68MbcyIuvP44uyo07BEPUorUIheCAsi99AsZYDFdl9f528pUUyd/gEH6/Aoy37J3wudzDZ5vEwjp61JR1gUdf5f0iqeLSX9tt79VD7j1DTvQi9ExC32poh7fLNJyyuUMbrWoCcvHEPnW6xJv5I0o5rGiKYxYGgnza4FPVm5Pzh2N5T/VbIUtanE2q2YjUQ2ENhQGpxsIU9mv9rEvuYbVOcRed35jB0S3Z7Dn+XwoBZvhldzTrNyegm2OJmYOMNuDw9+pnnTVKGI9QzEj1eTpDC3BAPGpPb7sMNfNRdk7X2Hcewu+vEaR261vgSERugS+qiDv4WpDFm/GO/LKzd0dtYy18aJMmJLXyCaI3lXXnkOLtVsPeuW6DESd7b1aSJ/fBNPqCtmqrvclX/NVqE0XTRoR7lU0UO5QvfBAxyrWMnf31dmIPVLZU1GW7WdPvbx15fkvkoS0kvzittGkCw9hu6SUWRLDeZlLqrG9mSXsvprxlVBWbzovcqSZTNR96tQwIPWs0Vg/9jasVkyGCAqUsWYX/MBxKStNVj71WgpcXoyVxWNlf6WngfOp0vTbQjC6atI9wJRqZIZZN5+UFNoOv8I+dothEok1olIHqde1V4iwgpBfOvgI6KA/HwXf+Ur+i8j4VKm4jMMW2SeCQXvNRGZG7BWjp7VvM3WEF6wmZ9lFWErCwKT6lT6sTn9bmVeh94gfBQYoALlKawIyJdyXLdxi+gOViWULqFjeMtBrXbK4hInrmx6iM2svYQrGZORnqAKKWzxIpia0TuWmvWC6QMsIS0TDN5xkmgQ
 zzwLkHc/
 s3joztbKoFj46vGl0w+9HL5ovAh2kQbobG064uZ2QDMswimSNSrbwO4ttABvAYCRE80dm5nXqloFM5FQzPZTAzVyyEeU2oAbOyEtpDySbmXwIrJsfTpO7s6S3J/bVYWXtd4aHKwDAPOfNz1QfbloAK9Vxo79+p5Usk04TPnIIFH8ZiuoIJAysFvi+EyikXJaXoCx6Jft6jfuXjUYtiyLVoXJocP79paJuxqMd7xuBNqYFdSau+IrOrnY04B6H0LihImXfwERAMi0KbULqBpi6GN9ux27Rp95YFzj5ZcoJambNT7Hma7eZtCKRlN72LqWmW40/8+7fVAcH6Qnna/59UFtKLE+XNYJJRQyMLSMPAHI1anJ1bZ4eBJWnihVwSHP6Q8kSK6bCMJHrrEvSTtqYnpVoBQ==
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
> The overflow check in gup_fast_fallback() only covers the addition to
> start. The preceding nr_pages << PAGE_SHIFT can already have truncated
> the length on 32bit.
>=20
> Users such as RapidIO's rio_dma_transfer() can derive such page counts
> from a 64-bit userspace length.
>=20
> Let's just check_shl_overflow() to reject any such overflow with
> -EOVERFLOW early.
>=20
> Fixes: c28b1fc70390 ("mm/gup: reorganize =
internal_get_user_pages_fast()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


