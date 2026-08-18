Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A57C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8216B07DD; Tue, 18 Aug 2026 08:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778CD6B07DE; Tue, 18 Aug 2026 08:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6693E6B07DF; Tue, 18 Aug 2026 08:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 411326B07DD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:01:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C422FC0C4E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:01:41 +0000 (UTC)
X-FDA: 85114250802.11.8360CDB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5151314000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:01:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QEO8N4dO;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787054499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSxxRZGefKh0In0u0GvJexPyMujQYJ1MaPf9PybNez8=;
	b=3YpQTtiwb2C9UMxN9g/B5B62W3rP5pvoEYWyoaGSlHpYUTzrKaa9+Ck+pPOuQD2Um3L89a
	+PT1sB6kMQ16aibZ916aGHd8sUd1ktrkD0sG81L6WRDlYtzptY5uIMpUinVyJVzzmJKJCX
	I3v/gKkhkcUDEuvJkeBtf7l4/Gdr6yU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QEO8N4dO;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787054499;
	b=yy/duMRgquUjo1JGFcPltRml3Fb7LV87Eded845CMWVeOy4ujc1ApuaByxeUPwI4TqEjUo
	76U375maNt2y7mCqeF3PqW6DY88U8lKZHxLD4VrROe32FQmOSzlzZs5gqFn23hPcXnumgH
	wRS4wb9kdQ+GcPITgJyJCIl4xx0t+kQ=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IAVoFf4121620;
	Tue, 18 Aug 2026 12:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HSxxRZGefKh0In0u0GvJexPyMujQYJ
	1MaPf9PybNez8=; b=QEO8N4dOFZJyWOraWG3QpYsTqgbPy15DVnacHTwS7Nmua7
	hPMyqfFwKr1GrtH3HM81G9SK4ff8IlUvMALTADrh6Jy3D5KmN2T/7zW8MozCMWGN
	dbUb2idIyVSFBFW/Xf5lQCH7Q6PcjWDD3UKf8dtZ+a8ND+S6Q4mD6ysDD8/V9jyR
	KXL1re+TBmbRn6PHSdlDQv7i9f4CRW8OalXnVkaAszxi/MOTaQMWMOZREfU9UV2D
	4eYK7miLz9SNE1bODuF1CC/iepg1oqdiVKputnkG+AIVzzxASlPRVMHbXB0aPSUN
	JtPOkn0lwpMJa7x+7/stTVAKbiiikq9WfmCb69CA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2dhkytvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 12:01:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IBuIli023448;
	Tue, 18 Aug 2026 12:01:35 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32eq36y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 12:01:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IC1Wpl51184008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 12:01:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 074FD2004D;
	Tue, 18 Aug 2026 12:01:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D491920040;
	Tue, 18 Aug 2026 12:01:31 +0000 (GMT)
Received: from tuxmaker (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Aug 2026 12:01:31 +0000 (GMT)
Date: Tue, 18 Aug 2026 14:01:30 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 3/4] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <20260818120130.1411942A70-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
 <CA+fCnZfMkPDVyy0t9W-3d55M2ba9wXoRyzj2EWWYLEW=QO3zWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fCnZfMkPDVyy0t9W-3d55M2ba9wXoRyzj2EWWYLEW=QO3zWg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA4OCBTYWx0ZWRfX/HzJ7nnyCHrh
 +HaoG7Id6qPNfsSLkUn8mpVhPXOsqePWVGHOcVMdnZc71woPoeBm51360tzgkp6pAXAUkmsKfdw
 uySTXd818WHVCgQiDXvFNCL+sQKyINLqnpzF4En1gWktv+YUG8hOvwg3+qyuSpoEiPdUSfUjHy5
 sVUMA5g6I0ktA4IXxQ/SJockakps4NfT2kGZkqekhp4rQS327gew3p3GltYmDT9HAYP3WccN4nf
 lW3+kHKC9OLej7j4SUzXSLWhHYHTAj6DI85bAimADWgotsdmfZdmdT1ad6tbRNh/5OTcKIQ4I53
 4iC8dCbroiEFZaaY5vwu/7/n5x2FUnKJokVbBJnWPeZ2I5NKoxmfysQyNzsbJz/7yyGpIiFvLEF
 5nRR0QluSHGgCq4jk5daT3oX9pRssJggUFa3GgQIOIF7nLtiqgIcmD2WFwdXSQAMonkNZvPBddA
 AfBuyIgIdoEp0+LpXfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA4OCBTYWx0ZWRfXxMSVUzPPppRN
 ief7nN+40tBCowkFDgNL4o/GB7pq7c2SdXf+jIMTMvFH7PEyZ0wkjsP0P9uBY0fYWrHJJmR51WA
 qSzR0/DJz/X8lToW9bcfQV0/KPJssgM=
X-Authority-Analysis: v=2.4 cv=JKkLdcKb c=1 sm=1 tr=0 ts=6a8449a1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=8Uvy48UusG5hzorP5EsA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: N5GgORfBdGiu4Lb-ApmOs7EFDv6zGCAn
X-Proofpoint-GUID: VKmHdYY6rFcIke9BaqPbB--R8GbSD7J7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180088
X-Rspamd-Queue-Id: 5151314000C
X-Stat-Signature: ymz3pyebp8w1sfacewrtqkipib8mi7yu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787054499-679548
X-HE-Meta: U2FsdGVkX1+EFIaHxihM5AVJA24xqQLXin9wnOVqSyYGsqpa3PbiNLvaxDCugy8EHsgDn1/6aZIJADM/s8my5sx7FdVIeL4kpCVg7sP4W107M8+LUXRPQ4Gja3K8mi/QxyVfE7Y6W6Jm7g0mnInUFy/HEb3aEFZa8e8zu/pRF2lPbgQRlGVfDJakQmVxgz6nWhB+wTkbf0zm68V3J9VNws2zIdiAa2hAVgB79e+G1fD972jgKH/WaQ5dM2oYTnIY3/pf8iCJXkLfhNGtMN1pTt3uyxWU2vQt74MD86hTGLQoe1XiNu8Jfgohph6kxBGGhbZo/7hDYpb/c5EL0I/fiAjtSiVY6LultiX2iH3khHBqI8/VzT3v1vPHQh7cDjqdEJKJEh7jkLw1dx+t6+ij4SfVCxgdueLWIvpo8g3vVrTIbL22MToqpT6fg1AuTRmDDSEBN1rIVg0qC01t6K2CUsuGNwSo/A6ZShg0HWvohk1zZ9wnCWtOzpGfyXfVNhofj4/2GORdtPMQpBo9aZ6/geCAyQYghW2Qzqv+zOiA/HCiWc2wW5n1s9d1EeEjiVk/fq0iFW1UW2crVKlzRx16gCpE3qrlkovU7tFzNA51q3qokZicJUc0shcJ91Y3mIHlWUHeC/R8WKA9socXnU9sfBv5K2dsKJHur0OMHnIuCfEBivIRb6Evf/EHdlfC6qBrY+ICW6fzt/5/YMU+sEO3IaUiwe+HpRpCeUmTD5pQFcg1lyulJxSeYVn5hV33V/3M6hGoWmJDaZKcRg+OTD3aof1kXqqAIZU/G74GqCiv1jWFrCDmcuo1HatWitsjdpfrEqvJ118khygkw9phffpfkLdm5/axDL35spRVsvvrYTH8E3VGIfKT2Z/VLV+D5NQ4BHz8kqBqZOkmSDL5ahUV8rzpzilK63wiTF3TUXKlXS1dKzif+Iy0ge8LLsAMZJpcRZ0jggIMAF83GfaTBQ0
 S0GOqC04
 T7oyyCOy7Uj9fjbB1tSdEaq/87CCuyrNhQpx+tc2U6JbSD+oupLWzT0arj+e+YkN4Q5hV0wMXb3as7otgbspnnuWRDOJzn3UYz84BlmA8LEGkg6pePphBlnlahTrrv8zk1BwvU2D4o6pS8LhOdzx6EmJLHzoC3SoHczh1hFn5/B6SX3fJAYB7K14WnFmdGibq2Z1NiGmT7uUO0vUYoadGMdiohKelouVmYvRbgNN7Yhsi5koE764GPzHjWkzil1cn8uLgbD1822YAsTppSd0KYZ/q3KzDey+vwrmpf1DdTVSpfyEXGyfLNtsZ2qoLS8/vsXM97fqTjM9dP+zR5W0dY+kKOn+CWuylsYja083SKcsGDjPO2DmfCgLbBv4zoE+NSozrey/N+syNkrf67jksaJ11ZaRhre37lbzSUuf36/ODNWiDuF5PvNwIMHG0UHK9qh8/fO0B1rvPwA19eIjrp2gNegXNgD3bWHlAIYzHDtY5jyh8t6g8kByHxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 12:11:34AM +0200, Andrey Konovalov wrote:
...
> Hi Alexander,
> 
> Should all this be limited to only s390?

The idea is to allow any architecture to opt-in. Once [1] is accepted
this may look redundant, but I still see the benefit in having it.

I only did not manage to circumvent the ugly __no_sanitize_address
for ptep_get_lockless() to make it avoid "bogus" kasan complains when
gup_fast walks a page table that entered the lazy mmu mode.

1. https://lore.kernel.org/linux-mm/20260806083926.1807279-1-usama.anjum@arm.com/

> Thanks!

