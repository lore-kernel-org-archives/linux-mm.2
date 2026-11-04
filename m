Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553B6606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EX7ppEPP
Received: by kanga.kvack.org (Postfix)
	id 6F4CE6B05C2; Wed,  4 Nov 2026 04:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3D16B05C5; Wed,  4 Nov 2026 04:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593C66B05C6; Wed,  4 Nov 2026 04:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8E66B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:24:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB9F6A069F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:46 +0000 (UTC)
X-FDA: 85396901772.19.773CB70
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D9ED40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EX7ppEPP;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z94cg7ac1Y7ssrM7pMXNVdha6WnPl9D8zeq/vd59B+M=;
	b=SlymMBr4GDDNDz2+soUlNlZzbtSPBrJNDMeXZzhRMGBgMHG76w1uG1rBipEzlP+S/M41Tk
	2m8xrZnmppY5c3IqmvkeZkpYJsfFpDTUbMmDIIZsF38WibXcwPSkAsLp507dn1QrBoIwxo
	pCwffsWlcJgZKZ1sOdTGx2aGK4NqHg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784285;
	b=lyy5K5mYLP0mtRdNXDnVdD0xXdmtK9xXrh+5bjfcQMuto1jANVAoc9FYAeBsffXBRUHenL
	0YO6c/jI7/lP5hkJ1w+aLPRaC7WYjyyED5y37ZQQ+z2ADyVT+8xxCbergqc61C6CE/GkES
	rbOED1EmuJeCjP93mItGFl3Xg/t6RzQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EX7ppEPP;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z94cg7ac1Y7ssrM7pMXNVdha6WnPl9D8zeq/vd59B+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793784280; v=1; x=1794389080;
 b=EX7ppEPPaFtlHsu2VqjM1UaT7IQavLpZc2tjUMAdBemJipD4+ckQP/d52rZ59F0cF1x9DsBH
 IUxWJTDKJjptoy2MXwV8C9p+CbZwomGUWtnnf8b1zOhNujFY3axwLVkXUxUArQOvjUusimSdkPy
 NFEKajGaMsHkhUmJaP47nn6k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0fb9feb80626b30b;
	Wed, 04 Nov 2026 09:24:39 +0000
X-Mizu-Trace-ID: 0fb9feb80626b30b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 09/15] mm/memfd: recheck the page cache before allocating
 a hugetlb folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-9-a0a033db180f@kernel.org>
Date: Wed, 4 Nov 2026 17:24:00 +0800
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
 Josef Bacik <josef@toxicpanda.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC756308-6AB4-4A6F-9DF7-E66F337A320D@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-9-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: iz57xso7fdrmwfeseikb1xq1a6y97n9n
X-Rspamd-Queue-Id: 3D9ED40003
X-Rspam-User: 
X-HE-Tag: 1793784283-192642
X-HE-Meta: U2FsdGVkX1+6Q2/ZVj/+K1F9wvo+vaFeRcTIeKzc3CUW03T5ponv0m+6Njw/D0KHzc7oQnjtpcJvmh3rJ205BdyQ6R5vuxoOAK0ERrmoQcU1r7NNm1ZReFrGec/vynzXLhIMmWhlgqt3wMOPSZssiYB7vUJlv69PVh6TSVqfEQg3jvZ2j8YgHKxhGqsjyZzh/mdsomQQ4vtVBOQTksLFDDwkyhzuSatyZUm/97RnRAIG36PVMX38WtfCcOaXwhjfmHOOACTfmB9r1BIP3ndkZ12kgc5J2ye3t+YgKITUJHvxcEP6JU+MkMat9T7QPytaIHltR8NVL9d7Vow6ol6BoG5hZacwFU27OR+J43fvHcCP6AOTri1k2blyrjt2lX9/KIZ7egzaEpaakJqHBH02ElqRDbcFqLwplq4PxAnn1AFO1VcMbin0FEmRBotlYkIM5Kqk6Vw4EJ7F4pRejIhk6lcFylYzCnn83LsYki4HwKUdAhXyja0Vu7vU++S1uxfPNzhMwde7kr4vQ82xAdJ6YEcXU6aOgmwzS2Phn4ImC9ftmpajyb/OajRHW2Eqf+1Py9K72XZhOfmTRLA/SaZ0HXmzmQ4ENq8/NiFgvwYR3OMtC+TRsy5+NfstEn/YLjeKCpNsj42bg/rCx5+7+H3xrOfFknuCmdU0fxM/ypp/+J8ZqEnJC6A8aivd9Xul/kBRZj4zL6G815NF32PVaBqjZzfA748fNoog6qIXNQ93QKN7gIrzMJdxzmyvYBC0hBJrnOVBCbhYoCTKUyXjXz/x+qcl2LWTTtdU8Qrp23nwEJ2Cf5ZUuG15bpDBrdZaQNs3BeLE9i61YW0glphVB5KRPFPYrEwLgvRiEmA570imMyHZM6IZICKrQKrDEW0z+Rg7EzGIYAgv344UDBZ809nfeA/YHrGsZesaah1ysbhMAu9O2i8HpuquzMb3T7ZrHT+Lhr845Cecq+pnWBxG+f5
 YxKGPSgh
 5mjT+990b6leexnyCFJ428Aa7Eh15tUuHZ+KpuOaHW9BwbQnlgMnS/T02kqBjMbCJzj+5mGMGvArZc7hzDxvwC5PiPad1AzBbdZdDLA30am96Q1TL3wLInckJJsAZUzw9sd7sdfvNlpNvsEVi0DVP4gvA+7L6WkrZuSjOG7wrayaBzVCzcU+2WJPaVePAmXqNWdytaQ+EeRZXHgxjGlRk9V7FQiIDW6gqjldEr2lGCRvVj8h+tbxWgEEQKHs5iK9seBae5YHwGk9DYPRnbXWFXBI5UqcJFPYEZ/l5cCcfIZZ6WUzMZ/My5XIyuUbUptkqAsOQ0YJUdmMyjThcSfyfUpf2tAOwx+D5VwxkyQX/pboNmaqxPpfW0XEjfS+9xJQzQtM6GLgVMNNQP5TrDjIsANRqgBFLclCYIzTjZoVpPhnbeTk=
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
> A concurrent fault or PIN request can populate the page cache
> after memfd_pin_folios() misses it in the page cache but before
> memfd_alloc_folio() takes the fault mutex. The latter still tries to
> allocate another folio and can return -ENOMEM even though the =
requested
> folio is already cached.
>=20
> In particular, hugetlb_reserve_pages() finds the existing =
reservation-map
> entry and reserves nothing. If no global reservations remain,
> alloc_hugetlb_folio_reserve() fails even when the pool has free pages,
> effectively failing memfd_pin_folios().
>=20
> Recheck the page cache before reserving or allocating. If the folio is
> present, drop the lookup reference and return -EEXIST so
> memfd_pin_folios() retries its lookup.
>=20
> This is probably not worth backporting to stable.
>=20
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning =
memfd folios")
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


