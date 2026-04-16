Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80646F433F2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC97A6B0089; Thu, 16 Apr 2026 01:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79F06B0095; Thu, 16 Apr 2026 01:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68CC6B0096; Thu, 16 Apr 2026 01:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9239B6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:51:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D1F21A06E5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:51:38 +0000 (UTC)
X-FDA: 84663347076.02.8E2F201
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id CDE29180004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:51:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sXHr8Edz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318696; a=rsa-sha256;
	cv=none;
	b=sasZ8WWAZTB9i+c55diZyohjxFd1vcTBcyKKoETqc1R8z6yRN+xVLwSRbUHAULKEnL/Ct8
	gjC0Ygo6KIMH+ClaQ9byDSUMnmI11jE1TB1BLAwiPBPffX/TR0wAHcNeD3LauWmZClNnha
	fj+gP2lZPLH2/L71Rmbp2t7EBTacM/8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sXHr8Edz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8ZRn9J58C2tx9KmJMMxW40X0fA9L1IY5FebFkKSNqs=;
	b=Hhv+bpWqZIwSLw4M8sCu6//wmztKoBwgemuWVcpddPx2PJ/2GZqhiD7OoK9dK8NyCCL+1G
	2WuZDC97JAxgqx04SaxiG7weNxEyoCkyECD10BiQgH4gtHYgQkCu5ZAfpIUNVJ40wSMLei
	4vn69dP7sIJ75qezNaXais2KEz/EdCc=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FH5aTh1834640;
	Thu, 16 Apr 2026 05:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=U8ZRn9J58C2tx9KmJMMxW40X0fA9L1
	IY5FebFkKSNqs=; b=sXHr8EdzAdYtC7Dy/MQGRJ6gCJmuB9HC5SfiA6Jov2hRn4
	BpUtV4s4rnevLNx2lfedSMiq/7cxZ/lATxTtjcKi0cG2DzWtGXklAHTapxDm2+ec
	wtd+Bm81Fu7phUj73Ll2w5PC2FCCBEhA6LDmJVdBKp8cAGxZqvpnxkSmdYIFN3BF
	D5UnWHaJX3NcKQ6jqwjcSP/zCK9/Tc8lBFZib4Fk+2AiZrnIDnEseBOrgcx//0pk
	6Y3zQysqvD7cTBfs44kRIC9gnzrVx/joAbxDYc1YYfWn4j0dMIraNr6y8UM72k35
	qSOeT5TharBdevNzLxWs9ue3b69gmtZ6x/c9YdDg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rkv3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:51:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G2fCnP003299;
	Thu, 16 Apr 2026 05:51:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh935bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:51:30 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G5pRqs8585520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 05:51:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34B3920040;
	Thu, 16 Apr 2026 05:51:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79A1F20043;
	Thu, 16 Apr 2026 05:51:26 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.42.253])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 16 Apr 2026 05:51:26 +0000 (GMT)
Date: Thu, 16 Apr 2026 07:51:24 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <140b7365-e3c9-4bbe-ae10-15332ab97b62-agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <924c91e711e8b16470eb2af7e31d0b6ffcf2940c.1776264097.git.agordeev@linux.ibm.com>
 <20260416054045.10407A20-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416054045.10407A20-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA1MiBTYWx0ZWRfX5pIGN9vk30we
 dEdDpjHcN3OtZZhU9RR6MeNf2QNxxFkV0hzShlf5P32vZ/72MVdRnUOWgAxVNPplaFNcT7/QSIj
 SY48LJKBDrMU+HVnn0iunlzFd4dEWGN9mvCyZfloITf19pxIuel2ViUn1UuCcCuKrtdT0Ha01Vg
 /OuqiETY1NC9qBcwMWOAXzx2f7kI6n2ofhS825l2tlzwjHweZCOHZAcj8zNOnh3yMq3k754+rfg
 FflZ67AzX/ZpvN/HkPVVwt8ZvutgINT6fmLfnla0yRzg3kweZL/aDR8lAttzHHfb5XAV7DWrPnb
 9CmmK+3kTHDLOIEXy2AXfgmT9z2CV1ml7G2+4rl7ojVbARA4EdhLNc0oOYLSQiRRCT3dgfIntaZ
 J+ZHcjZVXsUbhx9dTS3Y9MUckE/QT1hYqjEIRXjIjJFs0m3hBFva0/ZvNhwnXzDL0zVo2QTos/G
 7c5UeehORU3RaYMGSgg==
X-Proofpoint-ORIG-GUID: UEg3ZGRPSaxBIgycQGOzLqPcS2ClwgUn
X-Proofpoint-GUID: UEg3ZGRPSaxBIgycQGOzLqPcS2ClwgUn
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69e078e3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=glRYRA6g95Ob0rDooU8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160052
X-Rspamd-Server: rspam10
X-Stat-Signature: qyjq6omkdem51cpbaxgfzbc5ht4wbngn
X-Rspam-User: 
X-Rspamd-Queue-Id: CDE29180004
X-HE-Tag: 1776318695-36812
X-HE-Meta: U2FsdGVkX1/8QKN0Jv4wBuTtnWC6YJXrM5klXe4Ll6guJUdw2GW86p/N0fiv34dGM6VZekPLXdgi3rXmYB3UOjChfbog3kZP8vRfp/0hHFgt2yHTK7jXr0PFqYuOHHvInZT+8jK5gd0R1cp7jNlTpWZtMbEGTkCfCuLjYoJH+vE7iut3qvkwiygEkj5DZxiFS/hRGJikBUKvDqXcdmroL7D9Ma0E5cDtaKvQCq65QVLQim9IHzzNZCjk3qv+JP11U79qF7MEXUX/3At3lA6AWrKaVbXTUw7FPkTD5MmHUNfy2Xb+Ne4XUbhSIlAuvIrVfP/R8HU2HMx2u+OZMrkOqsrr5stEnbCpl8uanGtbD8jOaexzQG4InhNnJYmqr3xAwXa+l6iW5HrQ4du6G1wuVzOi7f+HyAfTM7RpCiatqEHG3ZYJiUmlWl/hk5zJX4SEfTZkipJAiB73AvxTB1s/d+rpqB8xXuD+x8hTdbPANEFC3iS9sXL1RlnZQce6gwyAR6ud/2c0HgGBIzebFlSFsuE1FxSpSTfphUf2LvYW1bPRLs7hLz7zWFaqQFf4bGv5+Vhzbhod86eSBzo5tVAhTR2NNOy8w1mO+d4QBuWmMvT2iaBuORlFr232DbXAn3ZUnabIueRL09T3Y7HHK4w3PdbPbJo5EMECrDNwsul5IWepLj/LR++U0PEJ2gndH4snYToQ9pfoTaffeAP8ad2By7IcfkmirZiNUBl0xG5TGxjBYYLmEW0GnjlqDJqvWdd2onzqSSbjrhoK36GTsU35T93FlWcq+8qdUIdYZFO6WDGsZkYKJMDnA6UIGpesAwZcK7pVWQ+Z/idmp0i9xEJ9G+7fyIGpRG5w6EI+W1GQK384yDGMHc2GMR8pRTKkxnF71cGEdi4qH7bvZ1Z35uXiABTaffshCRjbYe7S/OJfvyYAgtaA68IUGE8xD/Q5osZgWvyM+3M/O7PJB3PrsJA
 ZNhY7jDD
 EU4qFlyJAoBOn06PwCYBRK+FhLcMkXwLtA+tKttxm5zcbipzBn88R6lpfAybuP9b2w2jerkg/il6DCQaKGBIIubj4bmx8SI08Qnrggxe8M5cuTc5zWntULyw/x+ejRYnoFFEge4Ff2km0okzWk0cm1BAbQQtvgs4F7oxqKBB7tufMRl1b9g8uMkIlops6DYMZBPB60cbk90HsjlJiVdt6+swLBy0GKDDLAYXxA4/ICT5CWJKo0aOq1TB8SxwVBWhwBh6Ba3dotuD7hVSL5s2TaB5kMOLEQheVlZuRr66gzcD7C0KB+8tCUTC0qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:40:45AM +0200, Heiko Carstens wrote:
> > +#if !defined(CONFIG_IPTE_BATCH) || defined(__DECOMPRESSOR)
> > +static inline
> > +bool ipte_batch_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > +					  unsigned long addr, pte_t *ptep,
> > +					  int *res)
> > +{
> > +	return false;
> > +}
> 
> Why does this depend on __DECOMPRESSOR? Which code in the decompressor
> would generate a call to the ipte_batch functions?

Any call to ptep_get() or set_pte().

