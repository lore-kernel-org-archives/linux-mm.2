Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED73ECD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 05:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E166B00F2; Fri,  8 May 2026 01:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149916B00F4; Fri,  8 May 2026 01:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F8E6B00F5; Fri,  8 May 2026 01:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5D656B00F2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:16:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 787BC1C0211
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:16:01 +0000 (UTC)
X-FDA: 84743090922.30.7561DE8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id E45E0140009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:15:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hDFW8P4G;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778217358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wJ63tP65AEOTgPUMy736erQ3R88UsIelTUW5fba5Ag=;
	b=1GJKBryuuCsIUFZrYem7PVy3NvXrhRuBUkpTk8yHOghDjesvmFVrGWQHVH+9MMDId/RzUk
	RJpiT5MExtgIlmlLu5Dx9yuH4pI9lzTHafExrWdisqKX+69Nhwp9kPc5DwkCi9pVoNAUdB
	oTik7TxsaDvaTvAPND116GSniMGv7B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778217358; a=rsa-sha256;
	cv=none;
	b=7tcas++Z0gKm2O/sm3vANZkJ73zuMFU5ldRuma1pEov7m7wk1gOYCNtb6X9Ixgh0Viv0DS
	2vWFPM1P+Ie03Y82vQuJFIhA6FzW6CkikxNKT8dRxJ61vDuuwOG26RSsG2Dr0Cyc2QFSWn
	gRVPnmsrznTcWWZq1DBiI7mgtSaTg4I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hDFW8P4G;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647GAMFJ1356523;
	Fri, 8 May 2026 05:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4wJ63tP65AEOTgPUMy736erQ3R88Us
	IelTUW5fba5Ag=; b=hDFW8P4GDHr+lnWqvwbRwTMuRrke6lBOGgTeeuX5jdyHvL
	/S4YIfJK2MPkV4KJCNovCzKufxYhv6nbLki/8v4E1ubXKmQFocufcLklFA7SQv5z
	aqpXShMXPxDHSPfey+db84347cIyscrtYnRw7dbylLGn3RN8WFJ44ZQmUtAQO9bi
	d/mhGWYZRyJqv6yJyHMzsBI17r3/e534M1RKYIVWdfw77lBR1Z0aaf82aOAKd7Pr
	JPKb+G3XkbPRIXGnU98HWtTbgUJQY/XI02e+RbWED5uhBmcZl7ACk9U1sNKNJIAU
	Hvn7LMRuigmksK0kEHIl05RRAHnvRJ7y/1LNamPA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7t5rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 05:15:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64859Q4L016852;
	Fri, 8 May 2026 05:15:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e10071uwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 05:15:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6485Flve44892528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 05:15:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C0AC2005A;
	Fri,  8 May 2026 05:15:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D5A92004F;
	Fri,  8 May 2026 05:15:46 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.36.7])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 May 2026 05:15:46 +0000 (GMT)
Date: Fri, 8 May 2026 07:15:45 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <4da2d354-808d-463e-ac85-5b1f3fd51618-agordeev@linux.ibm.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
 <20260507093433.q5xybwumryxclnqy@master>
 <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
 <20260508010040.o7bypjnfceeqloeq@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508010040.o7bypjnfceeqloeq@master>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDA0OSBTYWx0ZWRfX6XS3Cvw9NV0z
 xlYifDzHr3tyAeePigHppZ1FN8PzWP7QbruN2WUTtZXGOT3k/04LGDB+KiRMUYD0PdfTsUj6XuY
 pnnpt4CiB9m3Jb15iEmLkQCjtj4Rs4uRKQe026JSXqoPSqjmFLdMNRL05qi7NlRB3kwELSf0QbS
 gcCoCddrT/Y3SKtT3cF6+72NFcOabNbD0p78vaA2GAOhZ/7hUScbIiblUAiNMU2BucjM0ctvEBp
 S2hmEtikMAKFs2+VsXy/nPGDvlC3joq7B3o67U0dZWlmguC5I8TtU0KS3VaOzY3Nq4FF6f/2thW
 8eBhjggHDElre3pbbQ5xfCi0Ei3VOInP8/yZGYVo2JDmjSJ9zN3ZVj+/jJbPr9h7b6kYu33ipQC
 b3SQGA9i3pmEERHGqbTTkkNjNRhK0pqM5i2PTykON6c1J+G0EfQYLWV5NrZVWEOUc32GxyHM7cj
 N5KQW0lX4BRs04na3dA==
X-Proofpoint-GUID: XG4_XHjMB35HXTS7RQBDKeyexlMwZ0oo
X-Proofpoint-ORIG-GUID: 9n5EEfaIrT16Q-gA8mKmo7rgLx7Lijzc
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69fd7187 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=D19gQVrFAAAA:8
 a=KSUS2Lu9pVKMSydAcJkA:9 a=CjuIK1q_8ugA:10 a=W4TVW4IDbPiebHqcZpNg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080049
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E45E0140009
X-Stat-Signature: xfzjny4475ey5y8f4rrhrcpkj3e7ha3u
X-Rspam-User: 
X-HE-Tag: 1778217357-815339
X-HE-Meta: U2FsdGVkX1++EC9bvXKIyOfIJMSLJX6I6lJ3LwS9o8pv4hyk8wKBcVMCm4W3WjTK+muKKuS78aKqxs1eSj1I93qFpjAoRPA5ZyPeYK7NaOCotRhAQ1wVHXestD36A8n0u1lzVW9e4BfHRhmNrn7xKVi8aTFOqY3oxsEEFr9p2cCotCAj9QcS2LPFQP8kmII9Hp7hJTIPC7RUJ41IPJYcY788Efy1/l1CTfOaf7+BhhiquoppvgMESvCks2ciTMS9wy7uZTMPw66ktsOQuEFFJhz/I8JUN6mLtN1fFMtPze2JNFtrkBGxJQl4W/6Njq4TxqovtLqjEQLAH+lkkVUOfHO9mZJ02tAt1o6q7H4rDPq0nv4Htrn8eIQYPcrnzdOOMyC/t+TBHKQQNjJbSpgd5b6GJBbp4dSerpFJQG5n2UqE/oj6Ld/kOMdA4vBHHOAuNymJgL7+gw/aVssmEWf/5kUmJEGTll02FYbjz3JFHBn270fpQf4NYkuqiUNZcyl+FG9fw9UMTl/Fki3VJQ1wM/0vch3w8b4rglQRwjlUV5GeoYX5iKfVYrEEXuWMnnylRpV7S798uLDyCkMta6JxRkN9nnKbV48uSYVDT2KWC8iLR4t62ouAf1PhgBJ/4om5sar0+ffzSncXaRrmtJdS0wlP539pFyjTWWbl7DaThk7wcXTLK1DzmGPUbdsC3G663qytydQfBWpVYVMU8uSAwSCGXmUGNmKSKDimNoIYL8zht/MhDOoeCeI6I89PoIvKmRKA3KZfROvMMVCe57QXP9WRthacbUpKM7h9eS9k7OBgbcRzNOgIHm4zCixz3JAe2+7TpVC7/lzEUaJU/ID6i1sTpbOiTNfLiTKYIOl+58zGih5NSF2FWTbkgtc27sRBtXjJrFaP21quDdfuBKiNaphCj+OYi29Ou0VGARmmm6CUPhMsyI7rNZIR/QmTcK6BC9tX/HgPJEJ3TYERNl4
 miP+Z20q
 aUw1LJsXLXCK3bbPufzZ5Oivvq8Yi4/0EHO2rU3UXNA6IPbAh9US1a6IaiujCh1WNy0wsOgyiYCiz4IJ2deg/hM2y30fgegZJCr8YLfIdqdR8PDc338xIEu+zaqKBvvBmH+0y3kN5flNiqnewMuiCexyCTg+MaFmiti43wcWqlnFZgwu8ywpG29bnyXao4PmekIJgqDmv3WkqNB3M+hYMafqMDTh2+Kdxq9DGr2pupX+z3wqPZPo/q2kEHi/tqHsO65ykFk3lfDyje62jMkzNb+NB7csW/SB9Nn8BEgGnKDpplVs8o49pR33Hny/hhY1CH7ldSxcsnVhpo4XT8IeAwCNV7wlkW/uqe0UrpuuED6H/W0SeoaeQozfGmMF+joI17WGw09ldMECtdirU4Yi8YaxFjRLCCpxaigPQ8eoMZ7Ey+tiNW/EM1w+OzEOI9axJr61T2HHYvDlfqQbfx2atIlIErstMAGUQTshQ1uyRqxWedleEmgZHy7rSfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 01:00:40AM +0000, Wei Yang wrote:
> On Thu, May 07, 2026 at 12:32:09PM +0200, Alexander Gordeev wrote:
> >On Thu, May 07, 2026 at 09:34:33AM +0000, Wei Yang wrote:
> >> >@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >> > 				goto restart;
> >> > 			}
> >> > 			pvmw->pte++;
> >> >-		} while (pte_none(ptep_get(pvmw->pte)));
> >> >+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
> >> 
> >> As Oscar mentioned in lkml.org/lkml/2026/4/27/630, map_pte() may take the
> >> lock. So probably it is not right?
> >
> >If I read the code correctly map_pte() might take the lock, but also
> >might not take it. If it took the lock and uses ptep_get_lockless(),
> >then it is fine. But if it did not take the lock and uses ptep_get(),
> >then it is an issue.
> >
> 
> So the rule here is:
> 
>   * ptep_get_lockless() could be used for locked and not locked
>   * ptep_get() only used when locked
> 
> Right?

Yes, this is my assumption.

> >> > 
> >> > 		if (!pvmw->ptl) {
> >> > 			spin_lock(ptl);
> >> >-- 
> >> >2.51.0
> >> >
> >> 
> >> -- 
> >> Wei Yang
> >
> >Thanks!
> 
> -- 
> Wei Yang
> Help you, Help me

