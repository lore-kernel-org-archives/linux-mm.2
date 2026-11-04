Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E66606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uUMXzD5u
Received: by kanga.kvack.org (Postfix)
	id 9C4086B05B8; Wed,  4 Nov 2026 04:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973A76B05B9; Wed,  4 Nov 2026 04:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FEF6B05BA; Wed,  4 Nov 2026 04:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64EC06B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:56:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E96C48066E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:56:07 +0000 (UTC)
X-FDA: 85396980774.15.8BD296C
Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	by imf04.hostedemail.com (Postfix) with ESMTP id E40CB40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:56:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUMXzD5u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUBQPp4DgGesu/zc45i1HHgbshamqgArN5rt8GOl5tk=;
	b=fKMK5RzGDJB7Y03Jg5IN+Q58HsmJPazPpcqVmNjUoFS5VbBKoSTT80pqCD0svpcmQI5LlE
	5GKSaUKgontAkXsVwzRQvZKmMjK+1gUDxoVXZX8NhzKOpRC5cMYaQXI4VAiGE27s7Sx4Jx
	GWYwujJ3Gw9l0pYto39PubFgMeSEGKc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUMXzD5u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786166;
	b=678WbgyiMgsZjjdtQlzwS2S/McPV3pLHI5nZOOVhDKi8rLfgUJ0NjTK1qhMNjDNdcCyI//
	UsEUBPTt09+d6TYYdgFSvOGwT077UQwhruJVHrURiSo+V5ov3gsD6NJmMJP4m7h8V8DzKR
	FYVnU7pnvRJRe7sYn0Yg478SA6on+Iw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pUBQPp4DgGesu/zc45i1HHgbshamqgArN5rt8GOl5tk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793786163; v=1; x=1794390963;
 b=uUMXzD5u9LbfomWLcrC2JIgPQCBBTO3LbzHp+2JUyWLJ6xQdE2ZY1BMAOjdbQnBuSYP1qFjF
 1kVjlex4v2hhEIm4aXGxezQoohio+Baq+fuznIdzLaWT6CPUvg34hb8PWHYCrHxsPlWU02MiA01
 gVFlQhnLVU61YtHNeRs2gfcA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c43ff3afd577f723;
	Wed, 04 Nov 2026 09:56:02 +0000
X-Mizu-Trace-ID: c43ff3afd577f723
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 11/15] hugetlbfs: do not grow a sealed file in mmap()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org>
Date: Wed, 4 Nov 2026 17:55:32 +0800
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
 Chris Mason <mason@kernel.org>,
 stable@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <140D6576-3DB1-464D-8934-6857B84EA784@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-11-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E40CB40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mcxzn55qtgqcg3zgffm369bywa51mdz4
X-HE-Tag: 1793786164-73019
X-HE-Meta: U2FsdGVkX19o+xuXy/TaYR1Z1hQVJ9XIer6PpIxEcrDBZ37N6+0J7+Sm81F9pnpjVdpb6monhH8kiDiW7YG6921NR6PLO+9cnRCddSwFxVkRHiDZpHZSTbyV6fFxUIZr9wwqXj7ooBU3IatIZMZza/AyZlUKCCw6cWdsu2u5A9bizA905/R6JKHg1/UH8QgA2mUW/Jm6adRItPkv8tQLlh/8HK8c7Z4lSBxJuRBCNO1GXcDKDvFHdNvdAqByNxYgIfZ4vjcw0l5TZvJuVJCCVo/y/9aWGky5hAh+V3GB36GtWNEAOrEcM/pF5dqjPV17XUdWKIbW+z6imb7Bl3lrH8rQ4GREbzQlgg57uZuJY5lBWa+zvKsUOct+LQbQUkboy/Rcv5RGU/hXys9qolareSVmz69nUK0hPqA7P9/ZX4xG5o7TamPZ8SpuDSzxbtA9yOHne9AreoVQfbkHC6xxL7Y2TGcl/xVr0HwttVyG2kAriEjiJAYn7TvfAkVAK9DksiQqv66huTMLfkb/Ixn0b3M3EJNMzkFAiS9AWFfUFk/9CeneS8qstvqIzD4/0oqxSn+71crMp/dx1OtTqecr74f/yigMJYAvUb+Gf52YWuxEFY0Vx8vXmzhRXzIfBCG+qm3z7GlE5igAcBrG9rTcXcNpZM25JtkjcRGMTDFRQr0kBGwN2M2VnftvyF5PvPHuVhmGigVg+/QpN7Ezg7HhOvsW+yGnMhl3G87c/ew4E7/wa64uZ/cX1TyA6G32yN9orXmwJad8dv5mC4ZexbZ4+4aQY0j3f/jE4+c4c4isE2ZB2CyqQcKM0jL4bONcNJ8nH2ilJjfAXtFmswY1GM5teXZzgnZlEmYdYg6U9id53K/WNnjKQAEl1AwHj2lfQH7LsUgrqxstvfh5L0vbwdHPgPJOlAd2brswz3On4THSD5/jILieuIQibgnV/B0IKGftZZZDzLmwvsMsSLkBlFF
 zTWcQTbu
 dyLbjX1XMKN038AwF78R/ITHMrd1aanOgyhLR9QtIaO8+/9gZbM8gYO028AjJTDTUVVAUsq50oflDROEWjziEW8QiyqtTHaMoKLlcUHXXwByH8H1ON6fgK8doqjy84RziGG/s6IsDNgI9yiXGNogG5icqrx5qGd/2OAeslSxNLRqTUgKQTze49z0uaWz5VbM0lRM4KZxXt3UuGTWDsW3kmNq5u6q1ohAIZFUrAqKoFQQXNKNXFqHHkxlcjkbqGrRDV+4bo3qTSSILcXKWyhyWgcP0DUo+zkHUuQZaI1lG+CqdYE3Er8aPH7nK1M19/NBkOm/dekGHUpVD9sZEs2n8o5PyAo0OB1O1QdlZvox9LYRiRmTXvtJx/9ZqWGpDHF2j1LHieehU1Kgx0+3bNcyzM1qbzQ==
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
> From: Chris Mason <mason@kernel.org>
>=20
> hugetlbfs_file_mmap() grows a file when a writable mapping extends =
beyond
> EOF. We are missing seal checks similar to hugetlbfs_setattr() and
> hugetlbfs_fallocate(), allowing a user to grow a file that has =
F_SEAL_GROW
> set.
>=20
> To fix it, skip the resize when F_SEAL_GROW is set; mmap() still =
succeeds
> without growing the file.
>=20
> We currently also allow CoW mappings to grow a file. Disallowing this,
> maybe even only for read-only file descriptors, could break existing
> userspace, so we have to be more careful. QEMU's file backend is an
> example user that might rely on such things, and would suddenly start
> getting SIGBUS when faulting in memory outside EOF.
>=20
> So be careful and focus on F_SEAL_GROW for now.
>=20
> Fix generated by an LLM and sent by Chris Mason in private.
>=20
> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: drop comment; simplify+extend description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.



