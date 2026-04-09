Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED4AE98FC2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CB26B008A; Thu,  9 Apr 2026 05:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E3C6B008C; Thu,  9 Apr 2026 05:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C646B0092; Thu,  9 Apr 2026 05:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE156B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:34:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F4551A06E7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:34:12 +0000 (UTC)
X-FDA: 84638506344.03.144423F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id E56611C0009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:34:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LDgfYNQF;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775727250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HurkI0CJf/Nu5967eiEijc+p528Xi2gytTLN16mcO2g=;
	b=zcLmiNZ7BDa4fl8Tw1g8nZNYIgsVQJ5J3JIV6RVfkBw00UQSa8PnCoaj9CIFUq0yTNKz9P
	wRqK6BwjtYyylNY/yEE9cQ0/R5A/eAnEiWXxWq+nucXkpBvlc0+KrzR3eNvj5O6ckxJep2
	9GScCpCReBuD2G160sY+1hEdr0boCoM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LDgfYNQF;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775727250; a=rsa-sha256;
	cv=none;
	b=3CjOrWZs2t7ha+oCuYRNIIgg8Gw8YZyUtKm/CBe8rIE9+lWyKc3udrNeGA/H2b39awQEvw
	tNqJh6dLjlUyHL0jm5hq7fTOZdX+ZyAHVXiqRxnBBmkVbZ91zGUBxVwsdRY1j20C2f34qS
	EapS9+sKUVDKRIZnel5M2FalNkakqR4=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6395TJrG1527709;
	Thu, 9 Apr 2026 09:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HurkI0CJf/Nu5967eiEijc+p528Xi2
	gytTLN16mcO2g=; b=LDgfYNQF+X8wdvPPZYQfpW5vfaauNlJ/DGgELputfIFYnH
	1xUoELkpaCJxYaDeNKG8mf20uyXtqSqsZEdFaL/Dl0X2HEC0VKrG9QK+y4+mmg94
	Mm/z29o7ZIcuLEByq1UjMg4vtA/smL0u0QMVvJXLxZMo0gXPjg5Ib5n15fpHaI6I
	xQJmu1FUIxiG7Vz/w0o4KGfbto6yDLBXR/pQqBuCAf5iWtORtrru5ZVtWf0nj6Se
	L6vT9aivhyJ6JX7xKFw2+PoaPA0mZQtpOBHcKo5t8Epf005IzNWm8U3cGpRrzyVI
	mUcwiB1yaoUSvBuRfrvGTDgDVDu3O+cQBpgdkSFQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2g3erf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:34:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63983OAM013824;
	Thu, 9 Apr 2026 09:34:01 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmf4b14q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 09:34:01 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6399Y0vL17433176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 09:34:00 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EA345805C;
	Thu,  9 Apr 2026 09:34:00 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 912FA58059;
	Thu,  9 Apr 2026 09:33:52 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 09:33:52 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------2ZxHWC0gcjIUuTnyPJge0UFM"
Message-ID: <13213d74-da49-45e0-bfb2-c2257a20991a@linux.ibm.com>
Date: Thu, 9 Apr 2026 15:03:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/53] selftests/mm: rename hugepage-* tests to hugetlb-*
To: Mike Rapoport <rppt@kernel.org>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-7-rppt@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260406141735.2179309-7-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KeridwYD c=1 sm=1 tr=0 ts=69d7728a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=glNXOQ5OGSLuttjN6J8A:9 a=QEXdDO2ut3YA:10
 a=Keij7DgZ2t4NoIn4_dEA:9 a=w3xQWfkRXVWKEavN:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-ORIG-GUID: qEDJAwk9KWG773Sp0qVrZTVO_nTTtxFj
X-Proofpoint-GUID: _ONAHAhlxLTel5QRJ_ghbFqZF-lE4T9_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDA4MiBTYWx0ZWRfX6pq3INrCQ4dY
 GL/2TOn0HkGiezzh73ILb7/wQXkKV80V5hJso6jjkqEoctZdf9Phd8sjO0KcA1+CfEB5v7OAfIs
 IfLzwSXHMAPXrkQZ53hAGI6F9DvXNQIrzJNoCIT8btKhwiWTP3xj1C1Uo9K12Wku/FmGVW+t4WX
 pijq7yMxI181ZBy0dTeSIyvKb1upwtTwLgHWWS02Tqq9ox0TZ1ojZgemeZketZB4fwkNwOxPIUD
 CRRzSodmObaef1IAlJkkwV+xPpK6dNUX5XA3EvcrDeVqt2sE46wNEzem+Zdl3oQC9iSpzZlPXdZ
 ZI660II5MsFeLbmu0dj2ej86/c9NAzgkw61kgxDI0j66l+I0u6SDqoRHVKjqhO+5Euw2OzHh2a7
 MRas4ONQo0BfaA73cz4Ouy+GehizRD+ev2AfQ47NUd1XFJPQp+ylvfGs1YQKLLY1LvB1/TlPRgg
 Nk6ibS/8+2dtKLu3AOA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_02,2026-04-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090082
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E56611C0009
X-Stat-Signature: csg15849p5gmdurmtjscbo3fybmp6c4x
X-Rspam-User: 
X-HE-Tag: 1775727249-974666
X-HE-Meta: U2FsdGVkX19xic/dkYtHqTcIkTLp5CaO6pI7m93op+bTK9HkdEx8S3oS3oPa6l7gmDj1v2y9KC55uZ4Zf+tswuvyXsMZohXbEz2VJGO+SgwmuF2DW8Bkq5ROkrNiJhU0UHxxeEO8hf2cJ8R7P8sH+A6hFSr94AcbvO2KScxx7PZ0fRbkOLdb+ulnzkKTC8+6O57DAkVroLMSV/bwyQiNHptXqyFmTFC6MimGUttlwfYXTDa2LlR4oXYRAnajqjlvXUdOHuFZa0ihMMBC0kqkZbxvcnzZw6r2McOkc1JKJoWDAFI1za0BveUax42adzFkPb8awgZGlgq1+Hc04Pgt0+gv0R9OdWBdmeUzVS6p7trcINmr0IfiD3FlXur26ooglYr0ZnapTMkrq6YGP9Wt3yzVkpysCd679IBeuKG6rLn55vRRfmbxnVNL6lriokPnKrU7S7qgvqwV8y6rWXDjm+y8jB04muh/gmRfs2tsXsfI54pbXneu28iZjUy8IFF8HRCCMd5p5lNXPwyPY9pq3ggrfh1Qob+2+m5NjYzsO/eIwjlCh0tTXrUqgxsS0mfVJeCbd2K8PEiAUB5F42TG6sEGqJ/CirjUDTIMg9v5XYeeQGt8qptpzdqKieWUv3g4fs9ohQYYZfJDlWN74C9mL3ywUkQz7RSWGqI5+1TQ92iA3PTK2IhbYt4Gh6/o4hhtQneTZlMOTZPnYLXMhZUHj/eAdBETkuzyD1YNBMSCwVAjtjhJnl3l5AoKR8LfcdyvRQ/EFIjgr3AI3U8hJ7XJ3nC1z7RxTgMn8zUA+goVLJD90UCRRDmH3i9WP9NxI6AgKKwZbR0rZYE6GvYtuZFehldIsoeqpWrlmcare4eiGjxHqVlSBaJ9UA39jpnPGQSlD4mm1te+YXHw2HgNec6ikHvfhOzLBpAsj3Pa6pFs48FSEJpG3MPiiGNcXeUorVfjr1B8Pc6PkTbG5ic5f5H
 wEgaxkjF
 q/mXPs/GHZssf2u23LgUSpkv5nE+/esFsa1PJqQO/cb3sVtws1dAotznOYGoQ+R8lX2b1rau1VhehJk8zF+/3rkWF1cs9fkgRpNnY89K0hWb8jWS5l5AzmLSRxxAJZ+qXxfjVFwkm79OnZN8NQymLE2bZ76Bt9FhhF4nAwkIS3xn2rtyz3RvLvkR6wHfULY8XVBF1gOi21NlsGW1q1amzHfzVeZzTqYzKTXZJBBjAXHD+DkwyUqKjhLHOidPZdnK4n3ZO1+lG1MigYUF+5PrM6H2cSX3pQeLMBm12m5IsodgHIdmyCiFcsbfRZDsoLwixNOIiZfY3OpuY/AEVzd495HitHPBLHVQEDnwzGeTVPqG1Xpe543YU7YrOFdncP9kPOkEDvQj4hFhXb/Al0w4zdSRcdYeh5O1k/k6jGABZpw/9LUTsmBCNCPCH3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------2ZxHWC0gcjIUuTnyPJge0UFM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mike

On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)"<rppt@kernel.org>
>
> hugepage could mean both THP and HugeTLB these days.
>
> Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.
>
> Signed-off-by: Mike Rapoport (Microsoft)<rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/.gitignore                     | 4 ++++
>   tools/testing/selftests/mm/Makefile                       | 8 ++++----
>   tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
>   .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
>   .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
>   .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
>   .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
>   tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
>   8 files changed, 16 insertions(+), 12 deletions(-)
>   rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index b0c30c5ee9e3..9ccd9e1447e6 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -4,6 +4,10 @@ hugepage-mmap
>   hugepage-mremap
>   hugepage-shm
>   hugepage-vmemmap

Should we consider removing this from |.gitignore|? Otherwise, this 
looks good to me.

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet

> +hugetlb-mmap
> +hugetlb-mremap
> +hugetlb-shm
> +hugetlb-vmemmap
>   hugetlb-madvise
>   hugetlb-read-hwpoison
>   hugetlb-soft-offline
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cbda989f6b6a..a6955660a806 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -63,10 +63,10 @@ TEST_GEN_FILES += hmm-tests
>   TEST_GEN_FILES += hugetlb-madvise
>   TEST_GEN_FILES += hugetlb-read-hwpoison
>   TEST_GEN_FILES += hugetlb-soft-offline
> -TEST_GEN_FILES += hugepage-mmap
> -TEST_GEN_FILES += hugepage-mremap
> -TEST_GEN_FILES += hugepage-shm
> -TEST_GEN_FILES += hugepage-vmemmap
> +TEST_GEN_FILES += hugetlb-mremap
> +TEST_GEN_FILES += hugetlb-shm
> +TEST_GEN_FILES += hugetlb-vmemmap
> +TEST_GEN_FILES += hugetlb-mmap
>   TEST_GEN_FILES += khugepaged
>   TEST_GEN_FILES += madv_populate
>   TEST_GEN_FILES += map_fixed_noreplace
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 5b12041fa310..898cc90b314f 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-madvise:
> + * hugetlb-madvise:
>    *
>    * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
>    * on hugetlb mappings.
> diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mmap.c
> rename to tools/testing/selftests/mm/hugetlb-mmap.c
> index de210043045a..71a444d8b1cb 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-mmap:
> + * hugetlb-mmap:
>    *
>    * Example of using huge page memory in a user application using the mmap
>    * system call.  Before running this application, make sure that the
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mremap.c
> rename to tools/testing/selftests/mm/hugetlb-mremap.c
> index b8f7d92e5a35..1c87c39780c5 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mremap.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-mremap:
> + * hugetlb-mremap:
>    *
>    * Example of remapping huge page memory in a user application using the
>    * mremap system call.  The path to a file in a hugetlbfs filesystem must
> diff --git a/tools/testing/selftests/mm/hugepage-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-shm.c
> rename to tools/testing/selftests/mm/hugetlb-shm.c
> index ef06260802b5..de8f5d523084 100644
> --- a/tools/testing/selftests/mm/hugepage-shm.c
> +++ b/tools/testing/selftests/mm/hugetlb-shm.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-shm:
> + * hugetlb-shm:
>    *
>    * Example of using huge page memory in a user application using Sys V shared
>    * memory system calls.  In this example the app is requesting 256MB of
> diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> similarity index 100%
> rename from tools/testing/selftests/mm/hugepage-vmemmap.c
> rename to tools/testing/selftests/mm/hugetlb-vmemmap.c
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 61b450032af8..b9e520194634 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -282,18 +282,18 @@ run_test() {
>   
>   echo "TAP version 13" | tap_output
>   
> -CATEGORY="hugetlb" run_test ./hugepage-mmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mmap
>   
>   shmmax=$(cat /proc/sys/kernel/shmmax)
>   shmall=$(cat /proc/sys/kernel/shmall)
>   echo 268435456 > /proc/sys/kernel/shmmax
>   echo 4194304 > /proc/sys/kernel/shmall
> -CATEGORY="hugetlb" run_test ./hugepage-shm
> +CATEGORY="hugetlb" run_test ./hugetlb-shm
>   echo "$shmmax" > /proc/sys/kernel/shmmax
>   echo "$shmall" > /proc/sys/kernel/shmall
>   
> -CATEGORY="hugetlb" run_test ./hugepage-mremap
> -CATEGORY="hugetlb" run_test ./hugepage-vmemmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mremap
> +CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
>   CATEGORY="hugetlb" run_test ./hugetlb-madvise
>   CATEGORY="hugetlb" run_test ./hugetlb_dio
>   
--------------2ZxHWC0gcjIUuTnyPJge0UFM
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi Mike</font></p>
    <div class="moz-cite-prefix">On 4/6/26 7:46 PM, Mike Rapoport wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-7-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">From: "Mike Rapoport (Microsoft)" <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>

hugepage could mean both THP and HugeTLB these days.

Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.

Signed-off-by: Mike Rapoport (Microsoft) <a class="moz-txt-link-rfc2396E" href="mailto:rppt@kernel.org">&lt;rppt@kernel.org&gt;</a>
---
 tools/testing/selftests/mm/.gitignore                     | 4 ++++
 tools/testing/selftests/mm/Makefile                       | 8 ++++----
 tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
 .../selftests/mm/{hugepage-mmap.c =&gt; hugetlb-mmap.c}      | 2 +-
 .../selftests/mm/{hugepage-mremap.c =&gt; hugetlb-mremap.c}  | 2 +-
 .../selftests/mm/{hugepage-shm.c =&gt; hugetlb-shm.c}        | 2 +-
 .../mm/{hugepage-vmemmap.c =&gt; hugetlb-vmemmap.c}          | 0
 tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
 8 files changed, 16 insertions(+), 12 deletions(-)
 rename tools/testing/selftests/mm/{hugepage-mmap.c =&gt; hugetlb-mmap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-mremap.c =&gt; hugetlb-mremap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-shm.c =&gt; hugetlb-shm.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c =&gt; hugetlb-vmemmap.c} (100%)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b0c30c5ee9e3..9ccd9e1447e6 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -4,6 +4,10 @@ hugepage-mmap
 hugepage-mremap
 hugepage-shm
 hugepage-vmemmap</pre>
    </blockquote>
    <p><font face="monospace">Should we consider removing this from <code
          data-start="224" data-end="236">.gitignore</code>? Otherwise,
        this looks good to me.<br>
        <br>
      </font></p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a></p>
    <p><font face="monospace">-Donet</font></p>
    <blockquote type="cite"
      cite="mid:20260406141735.2179309-7-rppt@kernel.org">
      <pre wrap="" class="moz-quote-pre">
+hugetlb-mmap
+hugetlb-mremap
+hugetlb-shm
+hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cbda989f6b6a..a6955660a806 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -63,10 +63,10 @@ TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-soft-offline
-TEST_GEN_FILES += hugepage-mmap
-TEST_GEN_FILES += hugepage-mremap
-TEST_GEN_FILES += hugepage-shm
-TEST_GEN_FILES += hugepage-vmemmap
+TEST_GEN_FILES += hugetlb-mremap
+TEST_GEN_FILES += hugetlb-shm
+TEST_GEN_FILES += hugetlb-vmemmap
+TEST_GEN_FILES += hugetlb-mmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 5b12041fa310..898cc90b314f 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-madvise:
+ * hugetlb-madvise:
  *
  * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
  * on hugetlb mappings.
diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-mmap.c
rename to tools/testing/selftests/mm/hugetlb-mmap.c
index de210043045a..71a444d8b1cb 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-mmap:
+ * hugetlb-mmap:
  *
  * Example of using huge page memory in a user application using the mmap
  * system call.  Before running this application, make sure that the
diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-mremap.c
rename to tools/testing/selftests/mm/hugetlb-mremap.c
index b8f7d92e5a35..1c87c39780c5 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-mremap:
+ * hugetlb-mremap:
  *
  * Example of remapping huge page memory in a user application using the
  * mremap system call.  The path to a file in a hugetlbfs filesystem must
diff --git a/tools/testing/selftests/mm/hugepage-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-shm.c
rename to tools/testing/selftests/mm/hugetlb-shm.c
index ef06260802b5..de8f5d523084 100644
--- a/tools/testing/selftests/mm/hugepage-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-shm:
+ * hugetlb-shm:
  *
  * Example of using huge page memory in a user application using Sys V shared
  * memory system calls.  In this example the app is requesting 256MB of
diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
similarity index 100%
rename from tools/testing/selftests/mm/hugepage-vmemmap.c
rename to tools/testing/selftests/mm/hugetlb-vmemmap.c
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 61b450032af8..b9e520194634 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -282,18 +282,18 @@ run_test() {
 
 echo "TAP version 13" | tap_output
 
-CATEGORY="hugetlb" run_test ./hugepage-mmap
+CATEGORY="hugetlb" run_test ./hugetlb-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
 shmall=$(cat /proc/sys/kernel/shmall)
 echo 268435456 &gt; /proc/sys/kernel/shmmax
 echo 4194304 &gt; /proc/sys/kernel/shmall
-CATEGORY="hugetlb" run_test ./hugepage-shm
+CATEGORY="hugetlb" run_test ./hugetlb-shm
 echo "$shmmax" &gt; /proc/sys/kernel/shmmax
 echo "$shmall" &gt; /proc/sys/kernel/shmall
 
-CATEGORY="hugetlb" run_test ./hugepage-mremap
-CATEGORY="hugetlb" run_test ./hugepage-vmemmap
+CATEGORY="hugetlb" run_test ./hugetlb-mremap
+CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 
</pre>
    </blockquote>
  </body>
</html>

--------------2ZxHWC0gcjIUuTnyPJge0UFM--


