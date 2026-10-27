Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B81606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=I4TZvnuF
Received: by kanga.kvack.org (Postfix)
	id 870DE6B05B2; Mon, 26 Oct 2026 22:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821566B05B3; Mon, 26 Oct 2026 22:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710DA6B05B6; Mon, 26 Oct 2026 22:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6966B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:08:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8819A1405D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:08:04 +0000 (UTC)
X-FDA: 85366770888.30.4552DC4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF066100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:08:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="I4TZvn u";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793066882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLq4wxz5oEh5R1sh+VJJCccBAQfxGPFlpx22HnajP3g=;
	b=Cq3jIlqT0bKPh5UlPwPMHovZa/DoiTljLPpH7VklCnc8dt4lC//Js6ocLNMo0H80sqjSXr
	G3DO9EnEhwoVcmsAF9xpsw/1g+2JswPCC9ULwjZIpGWH91VqAe2sPXUE2iMKRKGKFLi9+h
	M49dQzMq10J3Tddq0pZ+ZGsLtrhwQjw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="I4TZvn u";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793066882;
	b=r9GhFftaB/+aLQJtfKcOEsD/ZsNluOpTuaa0H+0d0paoSMTlmL/Vn3SW+bQKahSMDJTfGu
	0/BFrr4odblftapPrZakeWwuPXV9uUlNFvJOcHJgKAM1qLxBus7zO6Ttu+l9rOnUyeed8G
	PCDJhIeNuYdG/mPPzSWXbDehzNn4yoU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=oLq4wxz5oEh5R1sh+VJJCccBAQfxGPFlpx22HnajP3g=; b=I4TZvn
	uFx5nXaNn5b4N6dTFJOZnQFvfCyMSRe1WmZf0oJ6ac5FdYlGx4P4oZcraSi6f8oHxdUKQRL2hhMv2
	k1T8Qhk4DMEliLIEGV8Z9vwg9OjZR0LHm1fw7Q4EGvmnlyqmSPcCxJDJVd3+v/SvoT1lDE5OhhWJh
	bB0TywZtbrrrqxcpI/RWp69SqjcAEJ93TnMT1V6Mt8msESZgTNg0CoUeCX2noFZdIztNs0cPT7B/y
	9e9Au7mlP2j0PqR5y1+9tf4+O0p9v7VEND/Q6vD2t3xAaX7LNz89F3FQppIO6jBl/Ye+nt7mv8PxY
	jNU/oTDZc+eq68lcC1MXDWmrSHAA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLWaN-0000000B10v-3TRT;
	Tue, 27 Oct 2026 02:06:47 +0000
Message-ID: <639cb6dca4ab423272e05b90562ec49c7bdb12f9.camel@surriel.com>
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
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
 linux-arch@vger.kernel.org, 	linux-cxl@vger.kernel.org, Josef Bacik
 <josef@toxicpanda.com>, 	stable@vger.kernel.org
Date: Mon, 26 Oct 2026 22:06:47 -0400
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
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
X-Rspamd-Queue-Id: BF066100008
X-Rspam-User: 
X-Stat-Signature: giyhhq6zagbif9ir4b5x1gotyrtdbwbr
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793066882-535716
X-HE-Meta: U2FsdGVkX1/rYfoK7Ck1G8Mlo3CAeuiarmDv7jl89aBl/jtm0IFl9+28ZY6xMStsO9McZVkmGmXD11jYSRM7F+QjcbjsUrRc9ps2kZCbkScsuMoHlA6jhLD8YZ2F54UJj/buHYROx3jkPslgYMZlh2T8DqfyPPGVFCRf0qbXq3y+IPmfqjNFsZAaHB0LQ5NcQ4BwkxTbStqFhYO9YJ9BL54mFeozoTkocN8WiNbvnF8HDK4g+UDjSlFjtVrwqnCIbkb446QAeW2eLUGwo1eGqOte2wY3LV6IcZrW/ofcwxBIaB1JE0IgF4YzIasiQGloe3f4rC56ERmKmgQZJOY5o6LsB1HjdDMJF59mQMh+qH0AGriYxxsWs3f9V71nkIH1d3B9BPSmXt6C3WSbqaewvIZzJXVCT+kciuGsr89mO9WU+ndJrbd5ZAw0HenksZHl1qQyiQCOeWgfEWSk1oPj04gXLtjh+42fKULh/bWNpmo477CKzvcFQmmSjYoKumFddiHyNaN3X9kQvfY8WAgnCOR13TzxRxrDkmk6kBH+Ul6FlkhB8ZA2P27iVSHzR2N+VCCXslf4lEr8HIPTuCKEjUe99Q/9Hrlvt/jdLCZALyg09PXYxyzSy0wTv81k89VNxYdrSsLbdF6GkrhEdNCVM6uh8Prq13VW8so0xJ/9cEEiLnTa1kD0EigNWj+riqqXMc16DpCcVQrXyeT48WYRQ8UTqBVEY1MRcVwdxDkkJAa95SsiirmnRR3Z0VUBfrgQAUxWmEq6aYMIf61IbhH2HucSe/PiCljnQz0C8VPXzWgj0Yyzj96XneDPDpo0r2i6UhXCbBgW9jfnGm074w7gTLUYFkdowl53bUIVZ+PqW0F25xEXEcfK/rVv/5JyIWZsN/9bNm82AQihznbTel/uEXARLpqDNvaL5tv9d8blwD9YTXxWt7uztT22hu5wrIRU1EqForNQ/HpaUaLgzzK
 ekWbKE/u
 u6UD0GI7uAsQn8xdaePMmmy5IwNUPngFP4J7SIZhN+1JTPXdS/sK8VHB7+6ieuG/xxyVjpshmx+tNhaWl6DcC/UjZAvnx+5DM4JPfdesKI7CxwLsayw+6TXsAr165eHJTHZfIhpsOBoB8G49gYCWv09xvan86nMnCB+EA1s0uUFHTqWHle8P4ks4Cp9jkkBiC/sBgrmlTdknp2n6L5FU08PcfEMRyWfgPrKzWtakWFisSx/tsjzZ2K0wXXVQEkVOcIg9U6JLs761oYV0IoIK5Dr+cb0eDNiYL8uKdlOrit9o/HGiYolsODzjoXaesZ7ayaiowQ3/P5Yx5p7zglEj8CRpHLQbu2oVgLioxAjpQb+/TNpynzH4Em1RjIrwU9qqdKYuIMCK/StofMsEQEyu7PCx9lzmdab0uSFNP/NTtnq7v+wKO4DGEk4B9XVLiOUCSpzhNPVi2i05lYuE2b7362YDDyBgB24wbgQ5aHY3+bSfz1ycbbyC19K8vBoC0n/FHpglBLTbCptpGgZ1L8i2RsziLBQISP5GMwPm04EHjnz+idv8erRbiPyffG3fXS1lPt0JX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>=20
>=20
> Set the flag when the memfd is created.=C2=A0 As for any other regular
> file the
> lock is only taken if the file is reachable in more than one way, and
> nothing a memfd does in read or write waits for another operation on
> the
> same file.=C2=A0 This cannot be done for all alloc_file_pseudo() files:
> anon
> inode files such as eventfd are S_IFREG as well, and a blocked read
> holding
> ->f_pos_lock would lock out the write that is supposed to wake it.
>=20
> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

