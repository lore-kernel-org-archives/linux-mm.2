Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A12C5CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 17:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5298007A; Mon, 27 Oct 2025 13:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D555E8000A; Mon, 27 Oct 2025 13:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D4B8007A; Mon, 27 Oct 2025 13:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABF518000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:08:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62CF3B6F51
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:08:44 +0000 (UTC)
X-FDA: 84044528568.14.C887A5E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0860A160011
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:08:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="AP/QchWX";
	spf=pass (imf08.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761584922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+YnKl1CrIrZJI+jzZyMIk5/iGctAvk+Uu1N1BWz42o=;
	b=YSVtjLAC8duoIO1R60TYUtLyT+5Zy/Nbuj3QLlFGc9iGfjYNam4sEdw+DUCq7axAPkPKLM
	iYtcztpCAsErsiOjmoaCg4HxAMtpZG+Q8747iSfFRU7lY8LqwmIrXHv3AbQPkbKh8NjmPT
	rMjPP9+hAkYBLzI3XBerkK4EzGb4AGs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="AP/QchWX";
	spf=pass (imf08.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761584922; a=rsa-sha256;
	cv=none;
	b=k6vNwXbAXBs/yu4D+hEEQXXC0E41pet/2zb+tnAY05d+gWpi5NXGryMqmUmYRRl949SX/h
	4dKFksyNB3Qtyv8uhmbLRU+f9FW9t/txEoySyQxMpB8Y1a2EiWhzm3AU6ZlLo4AI/OHXs6
	DeS5Lsm63/JAGqSYpkYEsj3ad+06v9U=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDLf4u023398;
	Mon, 27 Oct 2025 17:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=A+YnKl1CrIrZJI+jzZyMIk5/iGctAv
	k+Uu1N1BWz42o=; b=AP/QchWXQdne0bWePAXyCKclddZNZu8i7WZ40JhWINNNns
	khjrDlMyURhVdb9kHc42jGzAz7CBzpNUBgEq+6q2tbFoKGzH/cAaK/RYRUnNToy9
	LjVI7YwDog4t9349PpoFGDzBFJcVlAvIzhkvb9TD1sYtMon8BG1CsnZsjBdrETUs
	f7hEv4npvsZtb0uJmpPGTwCrjH0Y/CliZmVvGKr5m4GLYmZoZeZBKDBS6h8hePLE
	imndMVNyFR2VfBS9gltwla51oGbYqy9CsVcN59X7pjz/BuPDEN8jMDzoPDHbcwzQ
	pTIjW36NsD6VQf0vJ9ZBc05VnA+L7nhvOlzwlgRw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p71yv4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 17:08:23 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59RH5imf010059;
	Mon, 27 Oct 2025 17:08:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p71yv4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 17:08:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59RFEl3L030460;
	Mon, 27 Oct 2025 17:08:21 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a1acjpmx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 17:08:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59RH8HXh36962730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 17:08:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 582A220043;
	Mon, 27 Oct 2025 17:08:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23B1820040;
	Mon, 27 Oct 2025 17:08:16 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 27 Oct 2025 17:08:16 +0000 (GMT)
Date: Mon, 27 Oct 2025 18:08:14 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Gregory Price <gourry@gourry.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
        Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <e8483d5a-7b03-4ae7-97c7-157af55879c6-agordeev@linux.ibm.com>
References: <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
 <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
 <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EK7LLW1zqR14UEm-qP1tp6NfXAmFReR6
X-Proofpoint-ORIG-GUID: VOJEHKfLfHkaI1BCCtzOrXAtTP6TyvpG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAyNCBTYWx0ZWRfX0P0eV63ApyQa
 JVYUBiJ7e4hixThpPeihq5N8pK5i/dDm2AJ4IHrwG8jN/xtE7o3Iwn2cflFYUh6HSfmZgsV9azu
 V732AzY82NfPEJySFQ1r+DcKCH0s7d3K7a+qUN2nyZ9GKRkPvReFreSu1RLlKyOwqPNoPdVIOOC
 D2blpK243mcc/RCz20BtbxMitQkJanHtA7dK8R7y7rrakkQ7bqJUOFM/ZfSMFFErkhIrf2VxOEr
 CYUtzbqL93R2NQID7p8SiXfQitlzxuR6FYZFHcj3uzh3k9puJ2ZuPA2Oel7HpuhMCY1joaApUeg
 YyR4UHMtRLe3T6AZwwjT0tO9WMoUyCjaXc8kkshXPt5aAfNcr0SaMgQFKD9Zom54ot/XFgY6L1f
 ky123Y4Sh+nUYIfv2Zlk6bhTjCCPPQ==
X-Authority-Analysis: v=2.4 cv=G/gR0tk5 c=1 sm=1 tr=0 ts=68ffa707 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=OE0-M_IHMqe_YGGL9GEA:9 a=CjuIK1q_8ugA:10 a=DXsff8QfwkrTrK3sU8N1:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250024
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0860A160011
X-Stat-Signature: xzjqtc598pj3anjzjwaf65ecyw7m55a6
X-Rspam-User: 
X-HE-Tag: 1761584921-823190
X-HE-Meta: U2FsdGVkX185iypgKqp9xD/G4kzN8ItGjH1ClSUi1d5NweHzecZ5WgTjN16DPzaeBzIL8Kx0QZbNBzRFMvHpjbqKvxmaBMe30uH5YFCpv2HdW+Ohwat6biZDjVIK3R3JavzhI+i8mg3HTdw5R8YU+nCVHy3LQOVklzgjQTLwq9ev+IU+uwCdLfN1V4Q1Dj6T1V74hVVmqSHsdq19MMASNXaMt+/XCwrsMrLgjPwx/M4uhI6cVya50Jt3Aa4vJvsvsKJAzLyPSVc6cij456oJvIOR1Yk4sK6Jj00gi9RKgij4uATLbUgTx5bVApQ7q7xCU01vPyfOIyWQOiJqyLff4PRUhtuHuJoGg40RQ9lToTD/5xKfTx39O+pO8H5oAvHEvKLUbhx3UWfzVxO3ZopkFSdOegz0whtVU51i0FiFFeW7Q4ZFh3G4b0b2vfAl87Lh5BQppAJZCOunWFn14Hq5Kqq/0/x2aUN7LQInIHoIXNWMoVCUVoim8xxYb2ADEwKLdMfVKRbnQzo1cdqCyQYqPefcEjrl8slsEMUaGK/qKk36SmMs8e3bpGov4zmwmWZkuauP/O0AgwgpIDkih7HOZYNQFOF4LfpAFoc1WD/Iq2/MeoLkfXHMyG4wxmj9DMUAvjdFKr1qvlb8NtyTKfs3jxPpwCGNMDj5nhWhcVvIZIBLm/TdAbYlSQDyygMgY4xjXbD+5UcwJx3/Iqi0L6EDgjpauCfQuQszXa1oL6Bo/rz46vR75rnJkFdthfa0pdunJyPvEWGgx8hBmEsWTpCvzVYMFo6TgJ5IUMGDX6xVCNLuQSYWQ5YVZZRvVWgY0ugIY9JTKvsBJU7XeOchEOzTB6qKdaZFEw5xLkyvLo9jaB2QZrizj1CX/oQvu6c6C3LFlNAisAp3b3/gB7p0A6f7WIX88++UJbu1XtkAuhw/jBKHIa3jNuyADRVkT2niaFe3uQ9UoHkZ/Xd0/1F3igN
 nShyM6n+
 ju5+fjQO7a2EASJxZHEKiMjpJ8wwiO3D1ylwFZhch6fw6/JQIsoPNzXpzDFtcfLhNAV8IBioyflKMBOpxCjX2+NgJJwC7UTckwjB6z6EeFziE3kPEvxnXKjc80ItePRrT4rL7EnSbBebO3oJ8cDd3/rBu//RFHlWzkujNWYJP/3lywKVejhmR2dcB6kVBBXD2ULKOwNiIJJrEQNycP+HtvlFoSCfyUUpfxGnq/MX5Oos0uUW3NfkqsndV+M0HKjs55lhOL1LJKaTQAE9oapGOYChAAmTCNg6XC6X+KLNNiU4D7aM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:38:05PM +0000, Lorenzo Stoakes wrote:
> Yeah but leaf_entry_t encapsulates BOTH swap and non-swap entries.
> 
> So that's nice.
> 
> What do you propose calling non-swap leaf entries? It starts spiralling down a
> bit there.

Absent?

