Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8B5606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=d87jxZYs
Received: by kanga.kvack.org (Postfix)
	id BB6306B05B3; Fri, 30 Oct 2026 05:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93B56B05B4; Fri, 30 Oct 2026 05:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4266B05B5; Fri, 30 Oct 2026 05:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7C96B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:20:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87639A057D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:20:53 +0000 (UTC)
X-FDA: 85378747986.08.1621084
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf04.hostedemail.com (Postfix) with ESMTP id 632AA40004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:20:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d87jxZYs;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793352051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwWDiQU31GhAJkKLOok0q5GmDT5UejWxDA7k4JTVj4M=;
	b=H2ebVZm1oFkS8950TTMDxLO/1WXFtDgSI2e8c0Co0gEDmnAz8bD6vilefwKdLAAmxWyuko
	lnCWhAHc6BEjmX3aTL8m8IEpU0/4NQA01qXCEYshCRIh6SQ2TbSrNazm/JSTpfPv0ITofv
	8mAm0T92/iiFvhRGBYxr2cGrnlaymw4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d87jxZYs;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793352051;
	b=chZEN7VDABUix2ILOXlX0tz1nnalpoe4AVDB2QMZfMGiOZbMRhFtF+4oqYeAUWHIuSSzby
	xH5a2jISJT8gGTU9mJ1fRN5wfHgACkr6Q70XLXkb7JyEb1uUhnkiv4NHdmsmO1x+LPrqon
	JT1+kdQdjv7+l2cjvJONeTKBmkovpFY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DwWDiQU31GhAJkKLOok0q5GmDT5UejWxDA7k4JTVj4M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793352050; v=1; x=1793956850;
 b=d87jxZYsXzSYCQ/xHD6fPWdvBbmfDED2jZYdIP/wz0YMDb65qjez3nTkqQ2OiGGUSbvTbfQM
 4fRPwHh32lyypRcBqLI618nMxfYTKzklpEZuKUGzwqzhkdwzTqJOKu5v5/QYZXXVsjgPD8Ix4e3
 f6sg9vfDv/TQg6Cbx/x5kjZ0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 222f0c8429a65a02;
	Fri, 30 Oct 2026 09:20:38 +0000
X-Mizu-Trace-ID: 222f0c8429a65a02
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 06/15] mm/hugetlb: fix mremap() racing with page migration
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-6-a0a033db180f@kernel.org>
Date: Fri, 30 Oct 2026 17:20:12 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 stable@kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9FFF0EF2-A99A-4448-9CA3-50E1733D6232@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-6-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 632AA40004
X-Stat-Signature: t3qfnsintrxmswow9qa49fhp1jedoar9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793352051-501363
X-HE-Meta: U2FsdGVkX1864F2OGWGHL0gmqDm8hPCjBqHHYS4tfZqpVz9znE0jq77Jru/XY+ispU4nwwmIHuboj50bpUn1y9TnXFc+9bIqTe7MAp6pUHecpN2ccbpuI2x2HUZ7cAc5MOh2UwX1oxBMJQ6/8BL7NYP5ySZjyfEGNUlgCu/9+w/K7Uimxp19PF2W0/fKE6Vx+j/IGPiMdiXotmtffdA0Vzy9DU4PE69tgRAKHUS9sjepnNo9QjXfFOQCmtaoMaJmgdW4btVLtCkrc33BRFY0zlJOPl67X9DIfKqvNK08PEdF+xbADTmtr9r6Qtf+Mj6tid/uf6TiUzstG3DO9sQzGfSkg10gs+HoB8xcoJgJEwmuf5i56Yc65KJOfv6IX5DzXB5HhPJmjQesHgwCAPzPQ4wBt+vmRv2Mk1aY0HJnS7xb7wt7KdGyrorJ+4WODn0gu7Gh2JRKy69KgjC/L1jmY5FqWVKLYeq+NLqw/aMzB2nCDbdER2/gzjck3klSrYHGt5jYVW5HMTHLwTcd1PRRCsI9/VjQLTi0w9QEH+2hpGSUjftwRxyoUpJAoivKqgdhm6abruzkXT1jdETnNvBu7FnP8DKwu5/TrxQphF/BWaVDyvovK5hp8CIE2hBlixN2xKG7Ab2YG3+kkPvZzMV/pWGJdl8PuCNz8Q5o7cysQwlPhAMc3Bus1S32I9Fw1K3SzH7JmbrXn216Mr4twq5bJQjDH0S1F1NXTH6F51268qqBbt9N2ynSVessERdakmurRisQETwujwBvMFWdns6qY4vAQaHyKkxZJv+oZOZeQ7MeVLuPP6Z3FZIKiG0mfYhwZ6sUqlDDupBezPPCd5YY0j4QNTT2nu+lYoonWyFKxII/kQeFUa1cCLD3OhE5KoyoXEON4cWTQtvEtpON60bP6pDH7yh98tA2++8T9FSKzRbAuCDMqaxMVAUNYqfQwnBGoyzfsH89a8XJ/TnDmfG
 sZ2Sq17d
 ymIJCth3ABEoZ73JGNPNCN6sNdTuAi9twSyEGMWTWHRBByebRVvVgZUla1/nfVEM+EhfpSCK53FBdRLnZe5n+up0bkWPCYhl7rZ6+O3BdCZWqFUyVByz7vJGJ8swt4NUFygiormDbhf6CvJSSRipiW0BEGt5J9K/RGsKj9tYR6dcMxwy7SA9tumjOeDM67KIJU36dIT5oup4VSSEhR9VzQZDeNI4pkm41YEtckoE6ssBpe2xmfiwzZiNkCj3D0EFeYy/tSm3yANMSMC3wgsbPCP7aJ0S4p2YboS4PqRVJLVyiWItXWJe/a4KJas3HeEoqFfCp6kYkh4hFkdu4UrhO9RxdperWOtEO7rx92sQln17lxF/o/kMn1mzyOXCBqqQLHBXf3cQ25BNRXgXnhsdS55mJRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> Migration of anon hugetlb folios walks the anon_vma, so the file's
> i_mmap_rwsem does not serialize it against move_hugetlb_page_tables().
>=20
> There are various issues with that. Most importantly, move_huge_pte()
> releases both page table locks before the TLB is flushed. Migration =
can
> then find the destination entry and finish migration, reusing the old
> folio while the TLB still has entries cached.
>=20
> Hold the anon_vma write lock across the move and the final TLB flush.
> This also prevents concurrent rmap walks from missing entries moved
> during rollback.
>=20
> When we must allocate a destination page table, flush the TLB before
> dropping the anon_vma lock, then reacquire it after allocation.
>=20
> Dropping the lock only works around lockdep: hugetlb folios are not
> reclaimed or migrated by allocation compaction, but their anon_vmas
> share the lock class used by ordinary anonymous memory. Having a
> separate lock class for hugetlb's anon_vma (like already done for
> i_mmap_rwsem via hugetlbfs_i_mmap_rwsem_key) requires more thought.
>=20
> There is a concern that this can block page migration of anonymous
> folios quite a while ... which is not really different to what happens
> to page-cache folios today. If ever a problem, we can temporarily
> release the lock.
>=20
> So let's keep it simple for now.

Make sense.

>=20
> It is a shame that hugetlb has to implement everything core-mm =
implements
> in a different way that just screams for problems.

Yeah, nightmare in MM.

>=20
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage =
backed vma")
> Cc: stable@kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


