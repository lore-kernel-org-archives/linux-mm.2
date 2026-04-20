Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC40F36C58
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E876B0092; Mon, 20 Apr 2026 08:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030726B0093; Mon, 20 Apr 2026 08:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60746B0095; Mon, 20 Apr 2026 08:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3EDC6B0092
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:14:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84408BA9BF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:14:02 +0000 (UTC)
X-FDA: 84678825924.09.43DF80C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4757D100012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:14:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gZlCJ5pD;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776687240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nJgkI7RbD14lsI+Zd/4+PHkt3gvbu2pFlqS4g1GDZT8=;
	b=rZUwJhwIEIxnS/H2L7V3qAYuaZJeyNPlYm8IE/1UDmI7FDyoOMbBPPwX8sFEBzD7LPlXvm
	nTqlSOosFTizOXSZqY+ZSulRNBbNULbbM1AG4N60Oqb+jxNZw5kYRN/rlByHfMG7r5iUiy
	5Bn27kfwIbAuXcHms7haEkTyOA4rdMU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gZlCJ5pD;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776687240; a=rsa-sha256;
	cv=none;
	b=LKZUDJX2SybjBY3HIS5r+QtGlb3/qli82T4mE0n1JW0B/L2DvZZpcDS8ll5Fkyuxg3o8ec
	+LZGgrvZzqFaHehwfcScbBZZhUEuxIpWoLCwnHg5cIMYPuX8unc6NDoJOa1fHI64d0DwTl
	LC/nzg+o/6WZgFb9LLEOW7+syt1AYRI=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KBwhMR3108458;
	Mon, 20 Apr 2026 12:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=nJgkI7RbD14lsI+Zd/4+PHkt3gvbu2pFlqS4g1GDZ
	T8=; b=gZlCJ5pD5kc83eh5zvwSCEi9K3XB+Jhxx/wY6EVtWFO/Vn/0kfi36XFU7
	2oFHN/Eer94Ep4So2zkdKNr/V7mDWL578U97h91FTPxd44dasc5b8kgRTU/WIKXq
	JlMqZTiaja/LczxPc8ij8ps29D9Kg1Mo5rI3jt3sD86kU3YkdaWSDbxXvFymbSpw
	vYrAxJPzCpRsNKd/J6SErc8Tyeladv0t9reudoPsAeaSMF52PQf6ko34L2GVFRHf
	1tVsvNqyUhHCM9MePI4Qijn7wKmeN6UjZT9aVpMnuu3Iv+PxnZNcte66NQsQ5My/
	+JOKQJfXBUNKeeWAiE8ZUbrD3eeyA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2h9f0f9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:13:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KC5KJP021295;
	Mon, 20 Apr 2026 12:13:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmm9pvt7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:13:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KCDrKh31130260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:13:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26C0C2004B;
	Mon, 20 Apr 2026 12:13:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDC5420040;
	Mon, 20 Apr 2026 12:13:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 20 Apr 2026 12:13:52 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id CF88CE0749; Mon, 20 Apr 2026 14:13:52 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: [RFC PATCH 0/2] mm/gup: pgtable entry acccessors cleanup
Date: Mon, 20 Apr 2026 14:13:50 +0200
Message-ID: <cover.1776684344.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3GfFdJNwNXlttYprI9xIIKLTBOuuPMXI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExNSBTYWx0ZWRfX3+75nW9ikULN
 mk6WTmIRZda1SiewI32TVpWu8iMVv1xi9G+PVp3buQufIIvXGRvHANLKVyw1kIcUqFpsMcevp5t
 5keATs1YycwiEytJOmN8QE86QXE0/HavXDcewGxgcf/1J1Ixxd81jmcbj2vNQpqfOjfgpHHVL/r
 jNkkgMY7x+G80KXE2g8CCNw3zGvans2JJfYllW/g9oSxoQ2JgBr/WYnw7ph/nD36dbMwBwjlzZM
 ba2jhjD5MqZbuhlMzjiRHledWj/E/UzWpRTxVp8UvNLn7ltyOAsNFvMPDY/vzt6lsUYXtbfFv3H
 sEz96nCSGikjzvYDYm3Wq3lMGH1TrvXAC5mJ4sFxGtG9jkdJowIqeha4W9V/RVh6S7fKQ/6MP4k
 vNi0IGoc8oc7pSqJHDgwYd44+CqNDWyaO1+SJXhGFThfJsUDlLua0cpBEBoOx2AmQj7x4XVk1Ih
 +/Q2f/3IEg71+sgLu7Q==
X-Authority-Analysis: v=2.4 cv=XLYAjwhE c=1 sm=1 tr=0 ts=69e61885 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=aTGr7PAGRYz1C1UlONgA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: 3GfFdJNwNXlttYprI9xIIKLTBOuuPMXI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200115
X-Stat-Signature: nup5dnnqz8codw4m8t6srjam9j5bhust
X-Rspamd-Queue-Id: 4757D100012
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776687240-732391
X-HE-Meta: U2FsdGVkX19gkrW3DXJpM44yOctv5otReYn4jQ15SSkVZ5hu8nyUUFIvvmbaoicNtu8oVqq2GDxXWkHiwWagWho4KjSv7kmKU/KxV/gHqGlqojxcsClfKtpdNdaldUEsDFnLPDICeBjUQtwlBMCGRqAkZ62KIPRElYthJ+4+qQIXWW9EM3WoEoKw/Sx7DOkdW3KZbRzvIzW2rwC0pcG6+6fXBEHKSyPj81pBcsQOpPtoZhpGYsd8/uvDZSpjAPLkRu66eO/nBlkadct3WATlERC4jRT7jkBdMId0k4pXrYYKg9dYNYqh/PafqFhFMTSVY00+ZvSplEPvqT/huyIEzjvkZfDFTMlbdzVHF9s7F1BhMDA2HPm0fg4UXTKukGoQXl2MP+Y89hfkwRhDN72lwlljrBh8oFjfNnJJEo7E6JN7ID3CVX60pslqL/R3sghX0MtNLMNgzUMWgjNZcVoUXhlz6OHuDDE9Mt6grhmx+cO76VOzhe9nk2GHsgpUtsVKykWm2xbOCcBk8cWLz0IA/g9lKxtK0KcqXVrKpfHrH/oSXYW5284LVpvi6XsDfp7tdz1EG/3rOZYmZNcKM2I23HgYQplxNMDMZ/YpmVW6mw631MvpYmpBBooeaDe6xU91ULDMLi+zsLJ12GFWRm8DNElLEF9iaE6gRO9Tm4PUx7hNlQv9+SrIXYOGaR7juXUPn7ZOvaUUO7SJFdJV2klwAo9FDdZH6kzQdG++5ozYfaC1G7W3O2JEu6IHDcpE4UCLdQk3u1iRHfLmVhu5O9QtmmpK4wR8JpfoEoVby2nP3kDC3e97V/mx6wpXlJRxGqPFkqqE07aIvCD+SIAzIUOvK/HTrWdmFqUKFDqJjfjuj5FsG2VIiFMtVJ6EtLTgAdumpWo39ylH8JZHOwKbwC8ZTuwnbsfK9Tm9zaqAaGwzcr7Dc7oq6skGVUKQWZbztuoHnUdrXqi628cb5bEf1oY
 uTuQJViq
 p/qxO1LHJBH9fyOClmprWXJZi/GazE3OWXSiaQQ8rXP9Tnv+101YlUSGRWeVg1pyj4OFRwjrz9ZdvUJNFTmaDgZEiHzejuqbcAPz6JvhGC/H8iisGrCTL0E8FVanZ5JgC7tyGU/hn2qDIZK+jJ5P5WgcsC3rsT4Zfg+I9RQwYfEm59y8LUSD0x/JqFOa8bhcR5oMf4Zkupez1kHmdIV7s3AnsZm3IKM3+XgYddGfKnDq+XEqdHC4/tDG+tfYNkxyVQx9OiZHZGW7Q3+s6adO31An8X8NADB2qM63qCeJfP+8aSWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

This rework is necessary to allow a KASAN PTE access sanitizer
(so far s390-only) that hits on direct PTE entries dereferences,
like pte =3D *ptep as opposed to pte =3D ptep_get(ptep).

I am not posting the sanitizer itself (yet), since it does not
fly without the suggested patches, but I am not sure whether
these changes make sense for the generic case.

Thus, sending it as a RFC.

Thanks!

Alexander Gordeev (2):
  mm/gup: add missing pXdp_get() conversions
  mm/gup: add lockless access semantics on entries validation

 mm/gup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--=20
2.51.0


