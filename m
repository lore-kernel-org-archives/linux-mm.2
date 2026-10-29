Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02707606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kKimkzyM
Received: by kanga.kvack.org (Postfix)
	id 2B47B6B05B3; Wed, 28 Oct 2026 23:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B4B6B05B5; Wed, 28 Oct 2026 23:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2986B05B6; Wed, 28 Oct 2026 23:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02866B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:51:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71006C01E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:51:47 +0000 (UTC)
X-FDA: 85374289854.16.8C8F181
Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	by imf13.hostedemail.com (Postfix) with ESMTP id 670F920003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:51:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kKimkzyM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXfmsX/yQpRThvRvFibuXD3vPcTXDbmM4UJssVVOAKc=;
	b=686YZ3L/X5FifpcFS/zrmFRWkgYgA6EyM7VbagHfIxoKbPZw8XoPZcbE8v692zDCzrypVr
	8xlIvAq6nhi0CUq2zg30nEfIfHeQvDHANfRj/i/57QJzkQAIp12I1RjyrGZTZCQjay2lXI
	rgf/TQeaGT5JbmnDBd7Rfqs7zxT9c0U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kKimkzyM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245905;
	b=SExVaK94EAoI3ALDYCRzjJQkCZWPRKPo38qEYgA/IfNXXDJ67frGVnbR9UynCTYcc7fdrT
	5dfeNJn4YkMJ/t82S4US3cR7ZCaG71i3Xqhcrrk/pvKnxpi0T6Rl7Z0wswpSbEAW5HQFgq
	BZ5IhXnDDkENa8Qzvxsh1F13JwVsDa8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=716xbJigIsWZtYo06Vb5k1w3O79is5fyZrfOLJIQCDQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793245901; v=1; x=1793850701;
 b=kKimkzyMPeC7s5+fbgeXF8tpg/Q20CMWuvnl55Scox90nZ4dUkgyeG+w0oApM+0nWA4fRHkg
 q/pfBgaWt9rb3eD6HUd7Wny2AINRQQZRfUAHY9eATkwakdCHmJE5s3+3NeXmKraZBCz+10zFbr1
 2tzeKUEeN5Os5kX7uiceRtZA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 718d34fddc079b55;
	Thu, 29 Oct 2026 03:51:40 +0000
X-Mizu-Trace-ID: 718d34fddc079b55
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 05/15] mm/hugetlb: keep surplus folios when the pool
 shrinks
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-5-a0a033db180f@kernel.org>
Date: Thu, 29 Oct 2026 11:51:13 +0800
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
 Josef Bacik <josef@toxicpanda.com>,
 stable@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8DF234F5-8EAF-427C-928C-8DD6E53FC501@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-5-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 670F920003
X-Stat-Signature: ypann9kpy46dewuo4p9bahndgrryy1am
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793245905-102017
X-HE-Meta: U2FsdGVkX19D09KdDPHhQG6nwe2Tc9nBe/DgeV+QfsCRSRA5aYmjvHKeXWuftFD/LSY7kgTqyGSHgKPNUZZpBVe+LsQQiwvmxgLnWhNkdilhpbDs3T4lOIQIunHksQB3AxOc8d5tQ86JJKx4+q7khPILfQQxAwueATpQ4rRVurvwF6rNAmDaQHSwiVvsxXBbq7dtOlOct9W04twZBJc6IlkPtQVZ4riIphJpB2G7k/xY6ocUTXagLKwWeI3piFX5fAcE30i8eixguMa9ruvne5vftCSsv9HLQqvmQRt4IJDhSRIjSeaBIcbp3FdVgL59eAoQ2SQ4xVtWT89bsyENYTLUvRIZDvcE21EBVKAc61tmsHDo4Fq0nuddsBkvLBgfxPycPvEGyEQzBgT/fZtZBiGVWHn/ZvwMpLGYzC22n1kGA9zZzE8bwIJ3AiUWdZr/jcezblYekXv6NRigPEHWOiy0dr8Q2PzD75Mv7ITxHECbQZIG5aX/nKDGky+ta5kV7tHuIxzYzOCUcb1PFrnT9RUXirUDrFahtNB3M4r3xRceGtmQIBfdigAsMgvhetaXQEv4FS6scS9gVH4VD/dzvXOmh++HiBQ/plWiiXOipzRvSUFLJxNwhlgZoVqRPMEi3EfD0OBcpWtDZRm4PZUEUApOjXLbV/U6mOHDLFkKt7ZWGP/TN520JKjesfQxKmPPimoZgmYkVmVrgCGj+le4Ev++BFfHoxyUc7m8sKq11Q0zsBzV97Bs2/+IDotLDABUR13SS+sKwPhTD1vUNtXbxN0EMQET95RDeRUr4vQ9OvjX0V4Nam1lUxP4Ghw0l7NIYiY+kJU0ydem6anWMtS0LhD6sb06HeC9J1NVkJraaLAKZ6pI4G9WE35hUuI4/4mtgdGhhBVSWkEewXd26+2klLElASxMXChoXIiqTiumfYYc5EkVcSqC8lFfdKX8p4Jo099+bo1g+kiiD2jsG8m
 JhaKScAc
 n/8Y3nTz9qAkVSPE8gtQbdNt/39mhHwzJEJauc+kNqbGMC7D+GzHguDFfUB6bFlLV1DyXzY8QIY40nCvSOdvea91F485JurpaoWxLMv1RB5yUidEbLVouTE+PXKK6rGAsNzqor54m6LHoW1dPi9yzW8NR7jJZIeUZXmhP04KKjWm45Yo/8Y49/W6yhNcj2qA0jtInPVChvVSgIcFVSTjstpWKgMiqpykRZQyjTjJLwUrk+sWtYkc+vi1+62fNTVVJruBE4osTv4hqS/3EZKg3/1swSytEegKsxgCppoBqgL3/3DB7GTUArHhqJ9wzZnb57RhqbrNxSEeTz+Ug9okXbP/arqr22VCe7n1T7KkJJZdEiYdjvIAayEIZjIjtZh0Yb7wivtmHlwARZG4nXaYcwb+nd4iJBcYOf4XFZY7SYZ+NSyQ=
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
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> Surplus folios are accounted per node. When shrinking the pool,
> set_max_huge_pages() removes free folios through
> remove_pool_hugetlb_folio() and accounts them as persistent folios.
>=20
> It can select a node whose folios are all surplus and leave its =
surplus
> count larger than its total count. Free surplus folios can back
> reservations created by gather_surplus_pages().
>=20
> For example, with nr_overcommit_hugepages =3D 8 on two nodes:
>=20
>  (node columns show total/free/surplus)
>=20
>                                      total free surp   node0   node1
>  mmap() of one page, bound to node 0     1    1    1   1 1 1   0 0 0
>  node1/nr_hugepages =3D 7                  8    8    1   1 1 1   7 7 0
>  nr_hugepages =3D 6                        7    7    1   0 0 1   7 7 0
>  munmap()                                7    7    1   0 0 1   7 7 0
>  nr_hugepages =3D 0                        1    1    1   0 0 1   1 1 0
>=20
> After shrinking to six persistent folios, node 0 has no folios but its
> surplus count is still one. Releasing the reservation cannot clear =
that
> count, and shrinking the pool to zero leaves one free page on node 1.
>=20
> A later write to node0/nr_hugepages underflows the unsigned per-node
> persistent count: 0 - 1, resulting in allocation of many folios.
>=20
> Use persistent_huge_pages_node() to skip nodes with no persistent =
folios,
> as adjust_pool_surplus() does. This also excludes temporary folios.
>=20
> Fixes: e4e574b767ba ("hugetlb: Try to grow hugetlb pool for MAP_SHARED =
mappings")
> Cc: stable@kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: cleanup code and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


