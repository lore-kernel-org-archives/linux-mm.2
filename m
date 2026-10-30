Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A2B606A332
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830346B00EF; Fri, 30 Oct 2026 05:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808576B05B1; Fri, 30 Oct 2026 05:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EB36B05B2; Fri, 30 Oct 2026 05:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 567996B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:40:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0ED81C3DB1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:40:06 +0000 (UTC)
X-FDA: 85378796412.18.D6BA5FA
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0590940005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:40:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZexjLA3;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjoByvQgZF8hrJ3bMrfVpCnfunVN4IpvJDxs7mkxVe4=;
	b=qZV9w3M0oO9MCk+hhN3lpE6a6nY45tf8d7JNzwZ8F2PsFuII4mB93hcjpo3FCz8EbCThYz
	sakHdEnN1ZlMGrTl+/N6Geb0otshH7MVjN3MtjX6R0Cd2jLTG4YyXlzZ8gIpUvUHEjIqyW
	Bg5NRfBXgDXy6GWK3oPvlprhxSqJBoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZexjLA3;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353204;
	b=l3HWfszRFPEGj1ZG/2KDnZEmeaWioOkDTdszBIdJfzWOmgk9s6Ia3+lFn12vtKxL+qRO8k
	pVwA3PxJCfKNFAQY8+WwLHPRNJqoD973Zv35tyOmvzT+ay4LD9DdMldsOsOrCLoP1NhmYP
	LcbJXBBQpkvj4ary84fangrKTuMuT+o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GjoByvQgZF8hrJ3bMrfVpCnfunVN4IpvJDxs7mkxVe4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793353201; v=1; x=1793958001;
 b=qZexjLA3z72ct6BDu7Dc0m9BncpgG3hK4j1b3DwD3NTBjBZ20OkGtqQCD+B6oCyJi38c8XHe
 9b2RX+szEZRshADVCh8gg+NONUQycTdJN52pAqQDMvLEgbE702NFZ3cLusXxVA4wy+dTS9SAuUR
 yzwDlzgYu4KRlYFifvWrzh7g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 391089da5ea8dc07;
	Fri, 30 Oct 2026 09:40:00 +0000
X-Mizu-Trace-ID: 391089da5ea8dc07
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 07/15] hugetlbfs: fix unmapping folios from private VMAs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-7-a0a033db180f@kernel.org>
Date: Fri, 30 Oct 2026 17:39:38 +0800
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
 stable@kernel.org,
 Daehyeon Ko <4ncienth@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE1BEB7B-295B-4F93-9876-C397C2FF473B@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-7-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0590940005
X-Stat-Signature: uhdkmpbqqi3nwqksgorxfg4pckjpu3bq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793353203-827267
X-HE-Meta: U2FsdGVkX1+k/OwHUUSkvBjlybluzLhTOK9GmfZoHVqswR8Qsj2d0IAof9vYOQIcYMhH2dmIldkugd4pMVjZL+3VzdCVaepM6+pCBCP9Js8geQtZlOfyeAItIS6CgILSqfqMvDaIF/3ZzYxRonUeSV6qGwEW1/i+Ua2eDv/po2/Mg+DhyHZgvXXQii1dwqfVz0IwmAXFW8IooORKGR2HIj7qTRI8ufkRs1PtT462YP/I5eZilyJFSj/Y6QqAbQGXi3fVR4UVNUQ0sdTy+asEjN2Rhu/vBl+PSBuwmuygKHZPA3rvSsAfz51F0DkPmz/oNJydD9XbVf3iNLvBscN6QUwVWonVTFv2eKA0Xzc+d4TIGIs30isjSn84PDN2DqQ6bHOhgESi/zEQfziK/CwKbW7NbHx3LDCpaXHQKXZfpfbW0jYsJDf37LccYVw0VoBsj9qELXi0P7D6Orx4cb3LYQs9J2kMaO2vgHs9B6f50XNilmGLWpHdDxPYAl5YkZuw1c1Cz4cIkSoZzc3p8ipvOvBeZbCXL1lotITLOYZF445hYjcge046+v66LyNXy+jja4YAdB46iTa9abZ9x6ncWG4oObetKLXbCjf+9S7cc3jo92oZFx7BF7U1r11QSekac9VVtU8O2Dw+XxG3xFirriPgTWSacAXs4BcKVS/tStJ+zb6yG6kZuandMsSO2i3j6Z3JK5y5DzykO1C194tDYIIjXEEVFVBl9I9SOqXiO04R2ehmrTGwSNo7It1pBTHGGsgSVn7k0yyvqNEl4Y6LZT13T7dVVWBCQIWgzq1L/WvQSqP7bPDHYWbzN+/5Hq1na3XyWl3I2zZpIafmCUGeF245kPiWcsXZrRx4X4yTSoBc7obbM3I5itgEOrQ9x5SwupNriN9IL0NI+EVINUqb0JEF3wsj+du5+6QRpdOMR3phOiyL0m6NKvRDXP9MKgKTDQGlpzobb4yB8HrNzc7
 lbfOWcNX
 OYXzjQo7AQLiS8wYF8bUWrFTihsptIQn4g0EKrEdSDpHPgKhJpKjBMvQW4FlbctjbtWAnq96fTsSxp8FDxtogvsO66ouqn5JTCKsCJhoS3tmW2hRGTIN+Cd/33sBtIbEt5sP17QVeLAI4VQr9J2wNKqM6BgCq6QkHS+1d0dyY5zkkxuSlvCGl30z6rWLs/wVybtqeOBdJQnehv6kosRWCelJkqpoU+k1j6N07hmmKHUKxk2njtH8cs2PvMGRg54To5Du46aMazohXfVANlG/rWbau2gypEEPo+wc5H+WDqmB9A12Q+czASvrKg1X0SuIaGK1fD7KlmHUDV0ERh+f9LuZU0CzVhrQ5Q9+a8Zj5T71tduhnOL1wlOt/FXkSaKlFhKx1msKURd95eMA4Um2UejB8i5vW9/c1TpmAA+GGdfC7MnBp7+loBqSUzTJgVCHf9WRV
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
> hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
> hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb =
VMA
> locking was extended to private VMAs, this can also happen when
> vm_private_data contains a resv_map pointer; treating it as a
> hugetlb_vma_lock corrupts memory and can cause crashes or hangs.
>=20
> Only take the VMA lock when a shareable lock exists, as additional =
locking
> is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
> already provide the required protection for private VMAs.
>=20
> Fix generated by an LLM and sent by Josef Bacik in private.
>=20
> Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private =
VMAs")
> Cc: stable@kernel.org
> Tested-by: Daehyeon Ko <4ncienth@gmail.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: simplify description and comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


