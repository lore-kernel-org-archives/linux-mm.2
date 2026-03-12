Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38A21067040
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FE76B0088; Thu, 12 Mar 2026 11:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201246B0089; Thu, 12 Mar 2026 11:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101CA6B008A; Thu, 12 Mar 2026 11:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F355D6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:02:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E0041C2E6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:02:59 +0000 (UTC)
X-FDA: 84537728478.27.8F2762A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1DE9F1C001A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:02:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MC0pt+Pe;
	spf=pass (imf21.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773327777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yQLPhF/8tvYIDT5F8gEZIM1Lj5cCvoGcEOmMxBZOxo=;
	b=s5kSn4TRyLZgYBo3AR2XBnSjbtm+UW2blp0djlD8n0Xt63u5+4zfsGxQJ/Ox9xWCRe4WTF
	TPiPbvFjNgd8Snkb9pr+OT0zcJc0frP1lSnuf+R1nXzHOugHq8X3/OgBKbbqyxaYYjN1G8
	3gQHEZ1RZSTSSAhoYqCtJKTI64GwO80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773327777; a=rsa-sha256;
	cv=none;
	b=RwSgXnAyUPYfWTA96uzatdEWfe9Zy0eFEh0xxaELaa3yEcOMLmIjOlbwFtC4xlj4sjxgzj
	CwfQXqQesCkT+ggsSAk6DtpolTiphfRjO0xbJ+YLG4F0jzRer3QOsQzWgNEnFuYZNPGfDA
	hRohJi7wZGoYIZz7RmZYaUmgdUEnlhE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MC0pt+Pe;
	spf=pass (imf21.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CEYoAI2256683;
	Thu, 12 Mar 2026 15:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=9yQLPhF/8tvYIDT5F8gEZIM1Lj5cCv
	oGcEOmMxBZOxo=; b=MC0pt+PeqJ/Fx0rQPpGYhy4twD3b2Kc3SyGf6uydq7veOf
	8wSyVumxfYcS/RzLsLeDh8kl9tD8R4upozst/SCAgDPTqUvZAmWAxmio9y7OUnuT
	z+9VkyVr2PtgAtjQ0Lx8hCSh12XXatgaPxqxwMvKJXGxkJkYajZHeGG8FFjLWuwt
	A8sSjHM0AL5l7/rGDzvXX3n/TnC1GNUMHMp8KZgOej48GZLIJZLI1hfjuva/1XP4
	1J3vzIqfnclM5Nt7mo5XR2o0alAXT63fVux788NDDz7JkbrDWVUnoTDzw6dMHvhx
	oQjkY8po5xcP4wjIRBxqWDT9CJV+bVyXkR6qLRFw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh92b9bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 15:02:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CEN16g025674;
	Thu, 12 Mar 2026 15:02:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8as0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 15:02:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CF2hgt59965898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 15:02:43 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 613C32004E;
	Thu, 12 Mar 2026 15:02:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80C7120043;
	Thu, 12 Mar 2026 15:02:42 +0000 (GMT)
Received: from localhost (unknown [9.111.83.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Mar 2026 15:02:42 +0000 (GMT)
Date: Thu, 12 Mar 2026 16:02:40 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-ID: <ttbskgg@ub.hpns>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
 <ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ca77f3489453c2fe01b25e50e53b778929e0dfc5.1772812343.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1KsyIx1BDwTPWaT_bYuVWvLadqDOw4WH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDEyMSBTYWx0ZWRfX9FVH7vrUmovR
 J4ljyZrodPGRPdSk7n1B/Cu0G49IAvTOnb9rnFhx7k/ZMkrjauFEAfl9mgAdqYFQ5AIeON+I65L
 aBHB+xoH0lQifsBvM+fDapqU7iShTN1mwz6wfd4HDoQHyRNUuL3SE4S+xE7l9cxyu/+VssBqPe8
 FtomLZUnwBdwc6mhzgyI+QBRIj0VvjIIMzoW/dhIAaRL2RNh8URukhOHG2aIpg3TrvdODgERw94
 bu/MNsCRkWPsIKbo7rlefYFNmgpmKQz9p4ndZ+DRs20cVYl1l6HF2M4uoujYP0HyT7PBzGeqfT+
 8NU/fKpq9pAf5Ac3EfQsegHyszKU98eJp54aJoGeN2WHCSsZHn/zujIQWl+iQTzwRz4TdtyIETZ
 5GC2PliLsfoRSNNNxjHHjgzxZZUP16hgpTMMKnK5UhAY3UAhROBg9q4VyPk1g6GDwAdF7Qhb7JE
 ektOqp8PyzdLfyWK8Og==
X-Proofpoint-GUID: 1KsyIx1BDwTPWaT_bYuVWvLadqDOw4WH
X-Authority-Analysis: v=2.4 cv=XNk9iAhE c=1 sm=1 tr=0 ts=69b2d598 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=Z4Rwk6OoAAAA:8 a=qw9MI_8u0g6XvTY13mQA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120121
X-Stat-Signature: twq4yx5wd5gzagxbtebpr9aktjonw69p
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DE9F1C001A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773327776-935640
X-HE-Meta: U2FsdGVkX1+ff7+I5VjZ5m9972jwB0LeWCNhaXW6OE3b28EFGjt0wvhdjdYh/P4f1DsybsuvMtQHgrMVZmuCJYhu3wkThp1XGoj4BhpWG/Qtl5AMNh8usr74zTsMrVz3F52+MmWYLLzryCzEnPvj6Lk0Wf6e2bazPywXqUCw9OtJbuC+3Hd6iRrHRXrPYfqbMBKGDYk4/AJJ94c5GxOcKVygdHl3/O4fA0q5Z2nEwPZ0CYvXasAkCFV/2idOBRnUD9A7o8WV/Jvtz//03eRyNDgu6fwDUt7wPfonEcDi3ry2i5foHz8ISIZqO99nqi25eKcGnNts0y3jmyiDBWi7T1dYaF+gMmNlaMMq78YZDefW+BsxbqeeNBzuekH2jg0/4uuYXuwXxsHTWXqMkOdDcJbPvTS+1p10y+E8y9ZKfJQ50xNpGthmufyCF5MMqh5r3iGdyAlqD8oZzUvLQr4Fc4686Kok8J9hXZkl1+d4bfB6L/GeYlHyDfKJqDYvUREvsy3kkiUK9T9m+iQk9VAnTPJ+OHOY7VPkg7S8QN3V87jr0F3xeKgsa3D3AXOGAVdnOOGQMb13khcPsrj216aRqIFLZ5QXXV5+XzTirYKQVt+bfQ/I/K5yx601PXn+kgpAsMmnyb2ZKvjlEfhKmT5Ef3EuunXsAA/X3eJM/wuw9tAFwWK/q05Rdw2xipfNknp0FSkesE2jxgVvvX4Z8F1YDO+UGIvzrwP2g+5lLumXNNMG/8qX+w8zr3cKEUBbl+Ww9YLLFSt0g98ou1EcLLQ7HRj7Ltho6ab2Oi6cHCjhcdipre39O3QOLnb32CiYWv3xmf1Bq4cCJeCGTe8SVmvq78QQH4SabYW9RPYl+Y8jqUPUYNc2L7WqEtqvrAZIIfyd684bp6S+j6brN6IEKzV7zfzt8mUZoqrTAPU9yZr85/Yyn5Tf7gmtEylmcx3yWkcW00q7UInZcc2eDQEu269
 U78Za/I4
 mgbTu6IrN7/XKvuIVlXwpF2kzMuHHVOm9XvgZyIlQZ95uKLsrYuDMM1KUqRbpLxTB3BhEJ4Mz8LiXvTGPHAeIdn4Fyvlw2H5OSjIFw9Wqjd4NQ5G5Jpw5bP8sjbmKingJ/KuX541ewW0+bL/WGdgJrTdb4Obj7dXJmbtbtqdgfJG3tRAO7ffQoMQeh2Kx2UqtRv9yhdwOpd1FOZojXsBQ/wWfPBu9vPK60Cbyi3pBvqaGSF+A5NUprLf84ycsRKue2cdVM5E9NETLsfW8PwLkTlNWSGLX6zz1cOSj2QSOC/2JyCt7Wa+MgVaP6MWE9Poo58ApwJrNc5Ffd571qcoJ5QOSJT5/IvTBuSOPAvgMlqkjtDWSVm/t/4Q6sX/oedU7JNKW+kAmJkxZHertdWD5xFU61XYB5mCtKT/D86g97Va5769yRo9IjlBDAUuAm2dT063chnQjZx0vE4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 05:16:30PM +0100, Alexander Gordeev wrote:
> From: Tobias Huschle <huschle@linux.ibm.com>
> 
> Unlike other architectures, s390 does not have means to
> distinguish kernel vs user page table entries - neither
> an entry itself, nor the address could be used for that.
> It is only the mm_struct that indicates whether an entry
> in question is mapped to a user space. So pass mm_struct
> to pxx_user_accessible_page() callbacks.
> 
> [agordeev@linux.ibm.com: rephrased commit message, removed braces]
> 
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Tobias Huschle <huschle@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/arm64/include/asm/pgtable.h             |  6 +++---
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
>  arch/powerpc/include/asm/pgtable.h           |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  6 +++---
>  arch/x86/include/asm/pgtable.h               |  6 +++---
>  mm/page_table_check.c                        | 15 ++++++---------
>  8 files changed, 24 insertions(+), 27 deletions(-)

Andrew, may I get your Reviewed-by or Ack-by for v2 so I can take it
via the s390 tree as well?

Thank you.

