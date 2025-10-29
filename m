Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731D6CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 12:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428CE8E006A; Wed, 29 Oct 2025 08:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFC08E0045; Wed, 29 Oct 2025 08:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315BB8E006A; Wed, 29 Oct 2025 08:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 204668E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:50:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9AF113BD4B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:50:04 +0000 (UTC)
X-FDA: 84051134328.16.68580F5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 998AA100010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:50:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GowXhPmN;
	spf=pass (imf14.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761742202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAgBTvcu80fXe1fwekyVRC1/bvwUvUT01UOXn7IaFcw=;
	b=fKulHTrNnddKZnJjbaU+V3+jSElM3d8xUx88qeyevKX/GdDr0e0wEYb1YGmttpL4j+O/jM
	gjuSim3JBJC+3Xzn+7OGkmtbleV6WYz+Z7FbGEkvUCS3G9H8LOkr/jk3ugYR5rg5gSWZbd
	GVLGDL3wQX+Qvsm7TOJdDnwTMJhGT6U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GowXhPmN;
	spf=pass (imf14.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761742202; a=rsa-sha256;
	cv=none;
	b=Prvhdqp+vkFG6ds4mYb6AwiFm4E0CxHOUarBVKMGfLZt3GnRK/gdwevTIg2A3azwQ/FSp9
	s6/deqspnFRWMS10BkirJgFCsGS1hptEm6ABU80aXV8TXlaG8FGE53IhC1WmS7nAn2meos
	MYNpOqWRSnphEvKAkvzy0xYkczVsGlI=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TBHOBO026005;
	Wed, 29 Oct 2025 12:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KAgBTvcu80fXe1fwekyVRC1/bvwUvU
	T01UOXn7IaFcw=; b=GowXhPmN50B8D8idGyqNnq9J0FAlWPYP7kD2Rmh4Q5NETS
	derlG0pNjxRp1uOkOd++Up22tK2CrDqEQpb5fxpCV6OD4Q4Fng9RQmeK+qZVh1bA
	0hqpIczKCgL1O6IzzGIrZR8GmN1M5vY29O2iUOVu+eb4nif2WoW7LeuoFPCnKKe4
	yvOhdBTq9H9BZowPTjxlcS4ablwmRkITvbQrXBJrZ7NQwnPkpFf86e8jVHMyOsAW
	oU8DVPrGXqDWnwzBD33HBO78MUxOHoPqLIM/jPMklwsvGyy14vjb5QxPIi4iOaUz
	1s3AMTuTp0uzu8d5Seg/DiJCLCiAG+x3lkQOPtMw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aak487-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 12:49:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59T9kxoN030747;
	Wed, 29 Oct 2025 12:49:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wwkb0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 12:49:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TCntFQ44433838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 12:49:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DC9020040;
	Wed, 29 Oct 2025 12:49:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0CFC20043;
	Wed, 29 Oct 2025 12:49:54 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Oct 2025 12:49:54 +0000 (GMT)
Date: Wed, 29 Oct 2025 13:49:53 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>, borntraeger@linux.ibm.com,
        joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
Message-ID: <20251029124953.8393Cc7-hca@linux.ibm.com>
References: <20251028211533.47694-1-luizcap@redhat.com>
 <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
 <20251029104457.8393B96-hca@linux.ibm.com>
 <9a8254b9-92f8-4530-88e8-fca3b7465908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8254b9-92f8-4530-88e8-fca3b7465908@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=69020d77 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jL9k_VB0GEcHRAsgpWwA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: d7fou95aMW-uoHoBvQs44vXWPA3v3hlP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX/oTo6Xh50MtI
 tyftiHDyPqefL6i4ewtPwSFaHIfzYG5hcU61cVUCmE90icNKNJPTPq2CeETrBXDHeI0rfosiAQy
 K6ZTRo5A7we91nVh7IppPMSZN8yrpEPNjTjmrsrK28U9Xgz4MO2dRmcScvGoQx0iHbFV8ABTarp
 odLOX8K8D+KdOEOSAlIm2XNTojsSqNjGYdiCQOX7+GmbYtyHz0AnRA4jiGZ5u5KBbpTBWKEcgVn
 Zn7Bkm78kGwYsfxNvb/77vQlYtBAgylrI//8hvqa916XjUWCSw7QwYAw+cdvxUvYX+CI5G9jgnv
 OK2GtuYXvZhVIT81bggT50K+vpwF85EZ8LUrZ/Dx8caprN82Fr8OnUromFPNKBb27BB6p37t/TC
 N3kUgCnqtPVrQ5t7cUHB4gB/Jke0Iw==
X-Proofpoint-GUID: d7fou95aMW-uoHoBvQs44vXWPA3v3hlP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_05,2025-10-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 998AA100010
X-Stat-Signature: ugk5z57t5dcbogz6ebc8fs4a5xn3qw34
X-Rspam-User: 
X-HE-Tag: 1761742202-790984
X-HE-Meta: U2FsdGVkX19ftLHKW3u1Q/+/NwZhpqhaszaTrzrKPDKaNzB3PDvvl4PSLHbYoI2bUz2C321YbzXzY8aCCrQsei6zd0Cms2SWKG41b7JvecHqgKtwSO9UCJUpljQvEmvPU/wdeDHGATFriSwdUovziys/MvJyz86xmG/d5oB5YGDDFC+A+0nYYweeHccCkFCmM/aZ6+tVDDbF2Hz6462AEwXR4ltlsWjxt2QwDrnXvexny8Lz4B3pB71n51QMU010sQbUhOb6GgLsu25Z0E/ZZPn9EDirYRna4GhheP3tI7dj2LQYk4PODNKdgEc0S6LPpzDDlR2Bz/sghWX3JRd6gjc2YXmH5VzQECrJJ8HHlpnaViIUjN5+rYyMaiy9lFxYWaFfVgAsVewtAfPCfl6YbdF9qTTBAqQn/u05qkegesxrZ3vwR6dFU98XzvzRJ+EuH/n9+Fd3zmDHZCYWwJtCzkPDT2UQxOa28u1zxMq7NlCuLHrU8dbYIiZaD8xY43u2vg7IUc/EfE11Kq09p3a3L+uzQ84jEc7YYURodGWCXdo+AGxyvnSMkFuIPNfoSx/f0zmM2mYivLRrDhdIZHKC02nN26BKnd3sugrcay6QAXg0ywlQcIYl46FohqpXG4JQZHrXamEDkX/bRaIcRmpJLuX+Hdhon/BGFg2aJP35PppAkjPj7S7z/XbGidEOCOxhKYwxbDJY74KVptuIsGOzyIEgz5rWuhR6nBr+d8gqDOB/UpDmzhecUhx1craxGlj5JCztLDzV2al+e2vKfzAzT0Lro4ujOR0UQq9wET+DMHlwRvzFGgpW334CSXP55cfAdXjfcEQ/xT+XZzkmnpaFF4Ux4NCXQtTlaYVsm6FZStA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 01:15:44PM +0100, David Hildenbrand wrote:
> BTW, I'm staring at s390x's flush_tlb() function and wonder why that one is
> defined. I'm sure there is a good reason ;)

Yes, I stumbled across that yesterday evening as well. I think its only
purpose is that it wants to be deleted :). I just didn't do it yet since I
don't want to see a merge conflict with this patch.

I also need to check if the only usage of flush_tlb_page(), which is also a
no-op for s390, in mm/memory.c is not indicating a problem too.

> > Changing active entries without the detour over an invalid entry or using
> > proper instructions like crdte or cspg is not allowed on s390. This was solved
> > for other parts that change active entries of the kernel mapping in an
> > architecture compliant way for s390 (see arch/s390/mm/pageattr.c).
> 
> Good point. I recall ARM64 has similar break-before-make requirements
> because they cannot tolerate two different TLB entries (small vs. large) for
> the same virtual address.
> 
> And if I rememebr correctly, that's the reason why arm64 does not enable
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP just yet.

Ok, let's wait for Gerald. Maybe there is a non-obvious reason why this works
anyway.

