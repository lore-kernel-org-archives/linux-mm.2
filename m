Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CD8606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=AAVc/08V
Received: by kanga.kvack.org (Postfix)
	id C07046B05B6; Mon, 26 Oct 2026 22:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE8C6B05B7; Mon, 26 Oct 2026 22:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE316B05B8; Mon, 26 Oct 2026 22:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85EFD6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:18:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F2454090F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:18:19 +0000 (UTC)
X-FDA: 85366796718.28.FC9A947
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D6B918000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:18:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="AAVc/0 8";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGaKz0ghX7Lbonx8PvJJJqD0p/WMYPC2YliZwFbr0fY=;
	b=P89x591gKycmn9Ex3WUl5yr3j4d4FTcOUSi+epTQgvTHn5RRM01LS2YPzAGvR4RP1+RyRc
	PTLw2iaOcX3cq7aMGXOcgblP2zFOD6xw2roYmzS/Qsbe8pYCIntRasD1ng95Lj1I4kMWF5
	L0fIx4ZIjvKMsC5LUpvuJub6XbrnVbc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="AAVc/0 8";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793067497;
	b=05i73yrCEJRxJTAcWSWqquIStV6HwE8iXP5rtI9zomvRukmnXkLFNcqmcxeecokmZQCLVD
	RJuByYbvm1sw+12s7uqQ9nlqcxdU385VLSCNwl5vu6R9c3OMl8fs19xLhdS57aTEBTuYN8
	Jp0pTLozqxkgiGzUBW62zr/OobhEJVM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=qGaKz0ghX7Lbonx8PvJJJqD0p/WMYPC2YliZwFbr0fY=; b=AAVc/0
	8VsTK9mY92KOp5wEbhgroVTHRCfftI50sRYAJL1JakNYXe+BTepKbKwB6Z414AlpfS+DUDqYZ+/Eh
	nj5OxnhFMAPMtHr6a/UJArBMlo0zPGvXYzSP1AyfZimUEGGpKcN/pXFGUhEd5cPb7Dgv67jI1G4uP
	55e644clgrRX4+HyA5EnIo6nQpVv4Na5C+pF7/iF0yMcG+jx4Pb5juMQq7eJznU+ew7NwWmld1Do7
	JjXyIXADjvO6IyFgjI58QIOi9mZPYlrJwYQaR08EmI3Mg0q8v1woNBDGgbAYg+CVCPeVTETY9liEP
	8I8zspCUGpVJFYfua7YslrF00KSg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLWkM-0000000B1GF-0On5;
	Tue, 27 Oct 2026 02:17:06 +0000
Message-ID: <db8ec1a4c7cb160c794888a0aa51b8f3eacb2044.camel@surriel.com>
Subject: Re: [PATCH 05/46] mm/truncate: look again if a folio left the
 mapping
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
 stable@vger.kernel.org, Josef Bacik	 <josef@toxicpanda.com>
Date: Mon, 26 Oct 2026 22:17:05 -0400
In-Reply-To: <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
	 <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
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
X-Rspamd-Queue-Id: 6D6B918000D
X-Rspam-User: 
X-Stat-Signature: hu8o5swxsx595no88wj4dkch5hnmrthd
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793067497-395799
X-HE-Meta: U2FsdGVkX19gYCSpyvunAyDdKzJ3KMaZgroqvwDbOpB//+mWati4REQstBtnbCXK6sGcBfacfM5gimQLwKk48HxGxd9wF7obfLDoCVUpVFbLuiR1MzqLKoRTJ5oBq0O9G7xpTVgx6MHaTVxZZeCh8928y9OL7c/XC6g973gRzuQ51Vb5D/4xX/buTTagbs3Zd0uWOFaIOHM6uuqx/mi16E3LcvN3/fnMVvv14l+p8IuDqPwX7zPtkszJMbxC35o9F+RJZzBFxXy0k4v7lzTVa0dJrFemZztjMnmIV5Z2Z9QLG1wyQ/qnTXu7anRYaMvsS8zPCHpd0fOdUOTmYFSnZ5T6YWvSxs4zn/r4VjzxmZihF2+O7SGzh75yYWPTwSxyX309O1tSgfCrtLz1oUaX0gE1c+etWCAPMWKv9BT93Er5snfBcUDZZ3A2MyYtjhCsLW732BP7wxKC3DkhvKz0VuIRKlLj+TgKIr/GqJ1AxsWlF2/Mq20Niuh3Y6oDUIdxJ0qy3PkmcM8QHHcA7lwXYkOuYqrCMuZ6KNT6Ojy7bfRgMou98MaEGwTxSJM9EXkkkVG2WedwOBNCVFEd9GqiqrrMKwwgF+VjNsrxJtwIX2G4c2wkpk4QkmHxXXQFPSMhybBGOZBbnHC9lSFnJfQu9iKzkm5N3YHzLG3TzYTbjXIfK+u0kHMa3om+GYhR/664P8zF9ERg2GDgLWFI59+ZQyBIkuP/33JZO1LRc1q8Geqln+xt9T+K+YnHw08RlGs1k39tsOs0aOvkPSQPBhFsJP1yCikMtSK6R/ulzm3hfj/4B0Y2zNZTYpM5r+ExWxDvaxaAMj/njMOItiDwRTQByaKIuWYbYS05Q+dJPaCDcXW+mLIXPLPkwLh185yEGKiK+ioOil5jV6GPcPeHCvbxx3mbXPtbpD60HuX8IBfLBF8k443xXT4iIHzMyjReMq0nteIOkxpLMG9K91kOOgK
 BWMAUYNA
 PpjtPHXjNiJ8gGqJts8qCPs5C56yoF7gAIKUU2b7MEgzd8TWb1H3k2+s39uJmC62biC+ZvRoNEF5IDNJvFfY6A/Vl0ZhWCFrLhQInHq6BxAjUcVrE/IsFt4zKCJPWBvsvXBLI12Hroq9taLIIo46J0kMbQh1KAdoNASrfzSbGP3ZMVV0ckxV5Ue/u7hj8+k5eqSLWKBvd9rmnzqNcB3Dc1E3gRTJHVt2D7z4egzlLVLpa2w/DLMhbN1YRiRhFERQTgi3VpRo/mFUVvIjvUesupc/zQOWumxgxoJK29rkUsgEefwV1WOG2iac2zB4G//RVO7NZB79GDvR9p04+H5IzWR1OXhL05zi9S8qVU0mI7p35OFHK9HfCayF7X5cZTN5iN9re/A0WYVCGk/MjV8GSN6TBrKUit3Sf8RPkFVYsnNtJDNK36fzIwQLIPB/+h1Bi1oGqh+fF9+MGGonh+V1FXRwkP/TcmFGi/i9g12OQj1tDokOtqjhvngibiMzGcVJxbBdt0ahr2/ehYWyOvvLatwiYFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
>=20
> In that scenario, the collapsed folio with the data from before the
> write
> stays in the page cache after the write has returned.
>=20
> This used to be impossible, as khugepaged only collapsed files that
> nobody
> had open for writing.
>=20
> Restart the lookup at that index, like shmem_undo_range() does. The
> same
> problem seems to exist in truncate_inode_pages_range() as well when
> truncate_inode_folio() fails, so handle it there as well.
>=20
> Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio
> collapse for writable files")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

