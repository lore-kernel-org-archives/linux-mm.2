Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA849606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=CWZKUMOl
Received: by kanga.kvack.org (Postfix)
	id D27BB6B05B7; Mon, 26 Oct 2026 22:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9A96B05B8; Mon, 26 Oct 2026 22:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7A46B05B9; Mon, 26 Oct 2026 22:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92A9D6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 272301405E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:06:04 +0000 (UTC)
X-FDA: 85366765848.26.75A2174
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79D86140004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:06:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CWZKUM O";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793066762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbcsaSvYmqsc1/PGogALmAlsxQ4NtVNgPQ1FxMhmi+A=;
	b=7X9WClx/OfytirEaCcrXIugr+jjnRCrA+dd6171k+GxXq25rbp1hgyCnrw48WfrFr5m61H
	Db4FgIBrQ5dZSYTY6Z4SsKY4QBNfwvC8xVqKJjmnPVnkx8IGzgr81GHV6IO8DzN4tjGDeZ
	G9uFq9sOIu5ri+3ZvrZju4+hruLqrMg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CWZKUM O";
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793066762;
	b=Xu0vnVEX/PrZOIpAlq8g6O3Z4FychAYbhaM2AeG4M2L/oMVZwj9yRE5B2qg2L3A1+1PudS
	Tbq11IUwDpIdCaoJIqoSR3xcgcO01IyaWnfjh08PDByG0KzISTKvx8Aj7vRWJU5t+Qc+QA
	aHgH6S0g0nBccnGv/uEHquMN+uYKNyI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=BbcsaSvYmqsc1/PGogALmAlsxQ4NtVNgPQ1FxMhmi+A=; b=CWZKUM
	Olnx3u/Gk5d/OR91etCdue5a5CeEvh9PUqUSqSygUk5of/q0VBUBLnXBtQ2IAvjkhbniPBjcGJ5AJ
	zBfQQUrA0ZeKI7TGX302NhHs/ur3FPzRcq5M6b0MbQR0vP9icJJX5f5CLh/ck9GLTlhxJTH3OYQdd
	WvMY6xVWwNwR+GZMzxMuGji7f82nyk0ZKOcdh6DgF0SppBH9V107GJT6RjHLvk6VFYHa2mO8AqRKg
	r0D6xxl2JO9boBueLIeID4FZrS8rSfqex+cOpROWqy4bTb6t0CjFI5zmTuuIJNeHNGcWzLHLf97l7
	vOiE2PSWsmxrt/oipmdtcnhFJauQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLWY0-0000000B0qk-3U0e;
	Tue, 27 Oct 2026 02:04:20 +0000
Message-ID: <35420f2a3d5f3af10cd88fd9e3a977b4e17a0476.camel@surriel.com>
Subject: Re: [PATCH 03/46] mm/memfd: check for real shmem inodes before
 accessing shmem state
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton	
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko	 <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song	
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>, Kees
 Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn	
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins	
 <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush
 Yadav	 <pratyush@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>, Harry Yoo	 <harry@kernel.org>, Alistair
 Popple <apopple@nvidia.com>, Nico Pache	 <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain	 <dev.jain@arm.com>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau	 <kas@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, John Hubbard	 <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Will Deacon <will@kernel.org>,  "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Oscar Salvador
 <osalvador@suse.de>,  Minchan Kim <minchan@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,  Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>,  Nhat Pham <nphamcs@gmail.com>, Youngjun Park
 <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Ying Huang	
 <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, 	linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, 	linux-cxl@vger.kernel.org,
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Date: Mon, 26 Oct 2026 22:04:20 -0400
In-Reply-To: <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-3-6f74bec9a5bb@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79D86140004
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: af99pg3y5mfkjimb5zo4e943yf6q36rz
X-HE-Tag: 1793066762-39697
X-HE-Meta: U2FsdGVkX1/TQz5BArEL5hae3NInX87b3WaSvFqlLrC3QfJCCd26S7BL/RiJv0hq2p/PH/zjK19DuUiyBSaUBtTWnLIXpb/4z8yIp9L4M4NTfAbZAnC/3kQVOHAW3LoHWwHClEnC+MxHkR/jpavRFzY3h6MQnRUtFlVsT0fKaS9g8g+zW1S4cwHjvdj+kA3RIDMzLOX6r+k0wl8atIwQQAog9rBlbjltaRGB3Q8HMeZ6tn2EJfvOhO6/Q2mhuGazgsPDrrbDPomwg1SlDW6k6Cj7MIagUKtCMRQzN4eZV+09pwA7Y4VaQF5hFewYc0WOsX7G+c0ZuMcfen4AZGbiM54w2/gFRUi5aounF8M2n8feAgGC+9DACIxEbKKwqmuGpyJsWllrluBS/A+1UkOL5GMzMVCz3pnb/yLO5MpomLJaQaciLJUYeNisPAvUhv6CtRqUy7yiJ3uEAQHk5dylP2ccYChZk/o60hxfBFGOebjmbqCIoghdLhcOori0pzD1jhvohBmVD6Lapiudgt1GKIWIb4MXppsHS3kuKX9PrF132xMRhQIr1wOBONgyZPXjaV/EpocQMbNZuf9zyEB9WmhzQfpvY1z/HNc5L8IHI7lz6f/QnFBgEbAPwyEB2XVECaVW293zCQi/377YFAk3ylbPFwZNcOEWpFvG+Me/pV1pGvkEoc7euF9q9PgLGJ5Kp0btNS6OTveAFc8o93mqxnWlEQBOsCaMIXrWUw5LHLBQmK9MrcphecyxIF74FFHAVdYSp6/zeHdtCV9DrISC6AI70tRokmN+4MM89MFRNkRn/dJ/dVlRb2cfkQHO7lH8a2ZaBcXKv9pnF+ocTUXjGBvB61zeld2i4GT8NFo1hG1+k97gJlXcEdxhj2VYCHbO4s13dHSTCEqD0VrguYFxzJtdABigvOahMfBt9F7dvHAX5WBPJio+WWfjOd6B0b20wRsRICfL/4Cafq7yjch
 2UDwiYjI
 02VYmpikw8mEAU2N5eQrG2Kg2le1Uu3nLxDndkfQCcyqwC6uRqXCd4l0qhsxQadBYlWxMTfHroxQeK0kXSb884ZY4YlHGPgSQ83lnJLn3wdQJeq6DTIvSKjVFah3I268XP7Bwh4ZSZmPzjncDN9fTzBrcm8g3ylA8N3WomDQCd3pWKo84kL1r86RQELG1+tsewpOsmYQ/xGJe6IHvVRnfdj3UA6NPX3+iUwsbh9/m2Z0pgy1bpKlbmQGWEJXUMCdgD9H0DRjva7XBGxwFinsaAiDunqFDxsc/fwFniB5THeJ/UpS4cu+tfphZ4WvavFOIRjvutqqrCV38er5Z5Lnj0oHVx+wZNgVb8ucfh4WK1FEdHBomMpoSWtW9dlXOLmZ1ViyRVZsoNseE0ttlaMYIdpZBwurgCa6qArsP+84lNr6XFFhIc/O/Hh+u8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
> shmem_file() only checks a file's backing mapping. That mapping can
> belong
> to another file, as with a Coda file backed by a tmpfs container
> after
> mmap(). It does not establish that file_inode(file) is a shmem inode.
>=20
> Seal handling and memfd preservation use this check before accessing
> shmem inode state, so they can access an inode of the wrong type.
>=20
> Add file_inode_is_shmem() to check the inode's file operations in
> both
> paths. This identifies regular shmem inodes, including those used by
> memfds and ordinary tmpfs files, independently of wrapper file
> operations.
>=20
> Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file
> checking")
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

