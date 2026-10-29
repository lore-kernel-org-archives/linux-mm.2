Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34178606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NxV2zbRI
Received: by kanga.kvack.org (Postfix)
	id 512816B05B4; Wed, 28 Oct 2026 23:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2206B05B5; Wed, 28 Oct 2026 23:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DA66B05B6; Wed, 28 Oct 2026 23:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17AE76B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:41:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0C0AA759B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:41:48 +0000 (UTC)
X-FDA: 85374264696.12.F0E7686
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2FC5DA0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:41:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxV2zbRI;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245307;
	b=y7gXnW9vY4QA0qxgxNC0Dkr9nmvNfWL0nbA063JLY17Lfi95beCWTyjNNss8wPIJ2JKDBZ
	7iF/P0JvCPeLLjrPalvFE24P2bOQ58/mteXv9EpkUdwqwwDW//hdCbhyy2JM/4H6o3mJ5v
	D+itgmWdLvlFSY2TDNXEJfDRS4oxSYY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NxV2zbRI;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfpksgeRXYSviYFeyWHR5mqkoXxAslF2D1vkefSL3uw=;
	b=44pyl/0bA+o7j7daajZ5pMGdcKNmWWvW6e3ftl2r4mpPK3auvnodshqhyQ/wkOplhHKXxd
	HpEneanb9LoE4upiEk5mV1TmPTNI1o2RjFq8SbfvDAiOuyR00SfkxeZhtzAuabdfArcG2B
	WH0VwU4y/wCZvrALaSTIKJKnrMkWglo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SfpksgeRXYSviYFeyWHR5mqkoXxAslF2D1vkefSL3uw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793245302; v=1; x=1793850102;
 b=NxV2zbRImUBwLKbaCg/zWhoTSvWR2eSfQzp5or3rZukb97Uuetb23hfqkeJZqlF/85Uv7SQV
 14s70j8cLPyw9jp/T7OE1W8F9ax2XsvgOtzbsLJ+K8zxGU3m0hjhT/SGpjNMU8Qv+D01RB5EhgF
 NXXHqIlq3oU27FdrMaowEbaY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id dc9967750c407019;
	Thu, 29 Oct 2026 03:41:42 +0000
X-Mizu-Trace-ID: dc9967750c407019
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 03/15] mm/hugetlb: preserve reservations when shrinking on
 HIGHMEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-3-a0a033db180f@kernel.org>
Date: Thu, 29 Oct 2026 11:41:12 +0800
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
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A4D91A63-87BD-4BFA-A12B-22A8513A496F@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-3-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: g5tkcxe8enjzy1jsyjg6tuc6irfrx95r
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FC5DA0002
X-Rspam-User: 
X-HE-Tag: 1793245304-777376
X-HE-Meta: U2FsdGVkX18DLy6mM4MFV9q32go+B4F+gMyEusaM8lfrWjunjekTxRry2A9qG0xo8lNS3EJgLVwtUOIGt7KcpW25EavrM9u6tNnzeKvOA0fMvkdwluDE5XiFuD2F+L4UANUgLWhSd3LQ628zRoe0QOB5cgWMMq1UdgXVcmrLrlhIeqtRlUv1Vl71mkKxUJ1deudBgFwhGAPgiWSXd0sFdQkTrF7rDMisaEp/znq5w+txP0LJvnhk6CcwuLMpWzRINpP5DFf7RXnzslEv3zjbUGT94cYReZ2Y1ucZZ7slToy+Nz4gsFGgVOuaaImo389+VUSw9VhYuL4XGOc4VLw2EJRzbDo4kHS2vvB3dCCS23/f52uiICzVoctMDwkxQQ2cBODGLDVKI85GoDR4sRKmWqmDnJiOvgrUgoSrdCB0hyf872k1/GR+Y3FnQGKYU/zy/YvkHeycavGKxyU2GD4PLQlQsDzGm5dYmj5IUH9JJ1CQ42znfZn2XhtfQfnq3Qa5tYVMFLuEV0XKuIjQ5Lt2UMm5mzLuV6TUWYNXvdQCm6eLcT+EVJFQO7l8OuTw7TtUAO4LErRfvz0FnoCAB99W/K0W3QH/c9nx2lUWa5hPShYC9bVFPKs0K1OFhO8v6un4Ncuts6qkXv8iVISQRye/AAs9BZInAw8tdjYb8LwH2VroqmgD0knotz/5XkcSeMcrKEUpF9W6c708EWQq3yBXVEPZr9COfd702xo/X2pc/CN5O8LT7Ghmz7QoRP1G/4ycTUjpf18ZhY32JJut8+ZtJnRwEQ2EbRhYlx6fVqGTrPlbEDJqB6st+gATysp13JsO/LKD8b5cVPMAuQGxC0sxh9V9J9o5z7ok5ucEryqC9QNTrMsLa1ke6hRbe0217YRVjvM8lUfQMporHW5ltn0bLoxmDkfVZ5y9KN6AvuRUqOff8grqwPfIOSnXjVOW/peHf7AGRev2S50EGg0Bb+/
 AxqERp57
 RXvG7peaNlPYaRoaK4ZOqYSgaNfuR2gYn++P0tmZrOTlRbaT6JTDqI7kVk2uIn5RNR28hy+VetfJYggMloqAdar7VFbTiDAyr+svXz7xZICtQ1tZC2b24dE4wMIfEKouRUWoRH8fHCMpSHBdb3oZ+j08NC9++Ms/T9FZp+F7vpuk5N2rmnxDYytCsikxkyrTCEn7ogt/sfwg7F0sKTptrJUETUCSqdIXEncFKxsoCmv+seVvF2NxhQuDHvPQrx9Pd7ikPM9BBSsChpWCYAVN1EtRT0vJzoG1eqFc1RdnI/gYOpM1fE7+jyEzPNnuEyoJyZ8Jxm4NFYoshDNv4WzJu5GzTyAm7nm1OtI16msa8yevjrzA=
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
> try_to_free_low() drops the hugetlb_lock while freeing lowmem folios.
> set_max_huge_pages() then resumes freeing folios using the
> min_count computed before that unlock. Reservations created in between
> can consequently lose their backing.
>=20
> Collect lowmem folios on the caller's existing page_list instead. Keep
> the hugetlb_lock held through both selection passes, and free the =
combined
> list at the caller's existing unlock point.
>=20
> Likely not stable-worthy.
>=20
> Fixes: 1121828a0c21 ("hugetlb: call update_and_free_page without =
hugetlb_lock")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


