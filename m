Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2126E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZErz2gHT
Received: by kanga.kvack.org (Postfix)
	id 9356A6B0B51; Wed, 25 Nov 2026 21:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C806B0B53; Wed, 25 Nov 2026 21:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822496B0B54; Wed, 25 Nov 2026 21:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3E86B0B51
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:03:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C79A1140226
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:03:34 +0000 (UTC)
X-FDA: 85475623548.06.D0C3BDA
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4958020009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:03:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZErz2gHT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658613;
	b=V6j1aczqfOABf/IVfc+OJ/JWQiHEy9N6RYSXxa6TOWBB1lPcedGaSVxpRVUeRboz4ItA6s
	aL/zUeRjQdVWC/7hfmP361+xENZEgCp5Wtkjs57zPiMRRkBJR0mh20JsBxn2bbM1DZieAP
	XKnJ3cVcNdbVIZbWB6QVFO/WWT+XtIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDPdURnq3OYJxD9FHhva4DbPjq66mRuiBiRc8sZ8u50=;
	b=T16mon4aDWycawtf7Six7hQaWhUat211HjBVwQAUkL+cvREfDLj9WoollJEwcsLShyLNYv
	rBNbNQoZjxo01NZtXoMgeAwcyZZtnAE01pMt7HT9jUWTSZScPZ/14hlOu98FljTJxj2lXe
	0qmPJW1nEUjiamq12n8K3a+2y2pnmwk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZErz2gHT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mDPdURnq3OYJxD9FHhva4DbPjq66mRuiBiRc8sZ8u50=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658606; v=1; x=1796263406;
 b=ZErz2gHTqsz8fab7qlaB/35lX5tzDF84D27Q3qVrATZPxzLDk9sBcv4U0VvjoYWHWc+zcj5b
 idNoA3INzUORoNAmYbOeoHPnn/zi9Dd5M+b2ckpPS5++szpfnoFxQwlFB23r4OEYO3rZlqvMBnC
 p5DjSxP24y7eMF6a17IEFdZE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 99fa385bc754693e;
	Thu, 26 Nov 2026 02:03:26 +0000
X-Mizu-Trace-ID: 99fa385bc754693e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 02/21] mm/hugetlb: fix truncated copy result in
 UFFDIO_COPY
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:03:04 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <36B2540E-D15B-4A56-88B3-2283A26B40BA@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-2-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Stat-Signature: e9yrpcedoh13daut9k3ryi5geg5pkke1
X-Rspamd-Queue-Id: 4958020009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795658611-225103
X-HE-Meta: U2FsdGVkX1/39F+CHAcdJ6PCm1BQH7CAbdXqDRkjfuMcawwrtmexkX0aYyIjYthO49DOJIvKz72dHwobms1iWJTcAg6KcVdCMCY4fMOah+bUZjfH4D+0FiGwUqsTSj/jOEo8AqHBvU4nyoiEkkVZLUx3FReoLtO/inIdRf2EjA4ofnfJsjdYR7bySky5ROqzA8H5rUfUdRoEb1ScpayZUyZ9a1StS1fBMZQmK7X3AowLUOzADT8p6bktD1k0QoRD5TBpknDsxpKM+krS2q6JH2kAZT3DlID+Qh3FGrtWXiY7aSvetoGjCUrufsrhIBWfIB13m6zrMC0oZexY0MOK2lka54/X7YPiTWntamhcIfV/3VNy151Qn05Ukz2c874TXoZbXrxXVPodAPH85wdgC6ah4sgR1AH2FpCUQEpwtV5UrUv2xQ2xwOy9N0JHNmvbdzLm818f2j4gL6tXbd491CQEwe4Oss0ruwGUtyGjtOdzhwG3XlfgrHaarCj+rrtIcUwmQVXupTB5szs6IJx0zk/Z7j6ciMjyxB/DRDdYpMqGP4BRnPETiZOm1iOYtq7zD/baKUk0SbxdDRmWHPxNm+1l5jUo0/tJDsx1mIg7Vzl1W3LLerfQevMh51I+R7dBIBN6Mdwt53nEq17eK4e4SxWO2bZk1hY9MzAP1Y+A3A8t9HCFMjRlc//lyewLNWnJLqJNDV636lqiszqeY81Bs+mLpcfDExgK8pyhKBPrYPErR6HX3DZ1IlYJhuDgzC+Gnr3NtVgBfBv1E98XlBmioj4//H/BIk1GttkQ9XHw5Xd5FieNQtpTQvZw5pK+wiCIAsHWt4TCDJMz3rg9qpeX50EiiXeaEHp/k1YRDlCiwl+uUAa6cjb7Tn48a10Wrg4uJjh4IyUtZ64+FEfVSs8gAB/yFQ71AmAe2kUJEKguIzef3wml1eAXu6T+RqLi89jPHyAvzoSsg7S3EMmGmIj
 N6Kpqo73
 t2TkY/hXRL0HtWI0sCvjAzL+JTpXTuxbq9/vlXPJlL00CV1GRB0ofkpO8mfRMIO4nvuBEVa2x2a/azPgaTwbuk5D0f2lGQ72JqBdXWikPjGJty9W2ok2NTDVooxK0ZjdVRKyREYgXw0V14P9XPvCVFfc3OVQe/qSvrw0ocyMxX/QFbxnYgtSUvEO1godutfHZvGG0g67WSrVJ6NB+ZzRtVWhfq91vYXBDs+G0Hb/ATx/+UY/7tmglpJV2iYPx7ifEz6JlFLRZIrtPYff06OPPTO++6DPW6cUyvGsjRrX9+tiqz7VUgJ/O5flhzhn3mz54pjMiKNFzNunPK6li6XVl1/7fT4MppDHaL5CMpInOYbIrF3jeMzYdasj5Ma20BfyC4b4awftf/uzqTGiXORqrp/YVxbY8KMtNHBsR2oqKmhwC0/CveG1GTPV/TOT2Cq3IJ6ehTIXXExtU54Q+zc/umz4BxcY9UVk3PfOtR8jkS+goSYji2GLhEfhDRxRZ10kZ683RYNUFNxO/j+7O8CDlCzwRF7uhgpO1FsFUxuuAfEqHpTMtCHL5hq4Ux67uvkX6eHxPHqAcbwl7fgkLGpyAApNKObP9/AGJq7kjyZHdTDbHHdM4ijvdIuILmIvRtrDW+EtfD7iVPwFdGaTK1c87Uc8F4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> Folios that span more bytes than can fit into an unsigned integer =
(e.g.,
> 16 GiB folios on arm64) are problematic with UFFDIO_COPY: the result
> from copy_folio_from_user() can be truncated, possibly indicating
> success instead of an error.
>=20
> We will then continue with the folio that has stale data, and make it
> accessible to user space.
>=20
> For example, if copy_folio_from_user() fails such that the number of
> bytes not copied is a multiple of 4 GiB, we'll get an effective ret =3D=3D=

> 0.
>=20
> Let's fix it by simply testing the return value directly.
>=20
> This has medium urgency, as it's an information leak.
>=20
> Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add =
hugetlb_mcopy_atomic_pte for userfaultfd support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: cleanup code and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



