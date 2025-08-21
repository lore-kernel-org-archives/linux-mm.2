Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83094CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B9B8E0020; Thu, 21 Aug 2025 08:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13C38E0008; Thu, 21 Aug 2025 08:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02A88E0020; Thu, 21 Aug 2025 08:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF7BF8E0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:43:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FD8483387
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:43:35 +0000 (UTC)
X-FDA: 83800730790.04.D5B35F2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07D414000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:43:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WHhp+HVG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755780213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d97PCBN2Mxcf1G3G9AAb1UIrmlS+H3GNt0ptuWZnCQY=;
	b=XcCFCEy5/5AnwBZiJynj6WH30maAuAaEz+JZpLWTkMTX8+wyUpHTgmIjQV58bAB435TIWW
	LTTL+E8bBe2fw9w5FyN9pTKrc8ruO5d4WUH7DQkkuH8s7krXypoeHd65ioWq2coOOgEZEt
	PF8lH/CvVe3Gcxf8RG6TS1zZPE+mhHI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WHhp+HVG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755780213; a=rsa-sha256;
	cv=none;
	b=VQRu/qArMSbtVTTag9YmDLgpaeSzjhs1LTyxPHXM8PchbBRuFgsIK7Z2zZj/ltXHSqjL4+
	nms/8wR5sO1Ur3U+Z4GTT0D1H5SU1Wj4uGKxiZCnyBvlt6VlxxNijBhuON4Z+AeC5m4zpA
	kHgAzyqgDUaqg7ZpJ4PVcBK3wRi6MOE=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57L6xFRI012155;
	Thu, 21 Aug 2025 12:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=d97PCBN2Mxcf1G3G9AAb1UIrmlS+H3
	GNt0ptuWZnCQY=; b=WHhp+HVGEZd37dzp23AaHYjs5XhRjb4gqo1PgkzYqID8mY
	nBiJNUnMLrPDgEkjSDBsUhk0OHQd4EhiTl6Opp5v8I3DYRLZNHtjblPuPzA+kG7y
	GVy9eIASvUk3LD13t0H4kWCsPV1ghHtasS2tI8P2R2ft9q+ECNHAXoTn3hAan88R
	4wID8bjmeHD7XgGogEM/wXKnSa35vagwkd3mbNtRb7TXhLfhR3DHDRr+GWmdNRrr
	HB4nJQuUa+hmt+eSC+QXkIZNELTCeTgpkMoKR+7IEbuGgVHH4MoDWDU5zmo7vZnh
	/X6HUhsZY0LeJK6FAmTHNFq36EjghwIuRmklvyhA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vrhpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Aug 2025 12:43:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57LCbp68002952;
	Thu, 21 Aug 2025 12:43:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vrhpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Aug 2025 12:43:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57LAvdb3024782;
	Thu, 21 Aug 2025 12:43:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48my5w092c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Aug 2025 12:43:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57LChQSZ18350366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 12:43:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE5BE20049;
	Thu, 21 Aug 2025 12:43:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A72AC20040;
	Thu, 21 Aug 2025 12:43:25 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.155.202.194])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 21 Aug 2025 12:43:25 +0000 (GMT)
Date: Thu, 21 Aug 2025 14:43:24 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, richard.weiyang@gmail.com,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v4] mm: fix accounting of memmap pages
Message-ID: <aKcUbInGFUiwCgrw@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
 <687b556e-0196-4a38-986a-2e7b0308e03d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687b556e-0196-4a38-986a-2e7b0308e03d@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDIyMiBTYWx0ZWRfX029ekrewtJmY
 ww6QxLB3XPyK7ozqdFd0htWAU+zhYGhrJW8GE5tUvR1O84vO31XihtYybo+RHWn19eaNjWmpVpJ
 TRrV+iI/iqGOjYqXtlnjHsYWTYny/uIa3q2p9jeIKQbJKL9vwUCnF8cnaYiD2suOolptm0qOt4f
 Ad4784HoubASlYgbnGcQCt8w7bgIhKkih2hXWEu4JRJxG+nTKqbIW9LAD7oxhtl8/gLe/PiMbcf
 upoQP17bSUnXOt4CGIpp8SQ/AwswvoZGSOkW8FG9Hy+Hi8HCNCaYVYF7A8/PltAZ2fKr/MkkISx
 JDPZKacQJOpZIvJT37iMC1hKFMxrgUocKYnO91NijJDkx5DaKa8basqAxmHcj7m6/CF8uzGXCX4
 U6zrs3/aYks6fWVCl+zdl6P9qe1fuQ==
X-Proofpoint-ORIG-GUID: tuiJ1kOYy3Fj02YDJPICwUxi5SgNcJEc
X-Authority-Analysis: v=2.4 cv=T9nVj/KQ c=1 sm=1 tr=0 ts=68a71474 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=ItlAY4iKiLxSNNkFt-cA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: k1Y4_EmX4WIVx7zjsJrzB7zq2DAIfDDd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2508110000 definitions=main-2508190222
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07D414000A
X-Stat-Signature: 3rjbcptdswffnzrtc67m6uyykzgg5a6f
X-Rspam-User: 
X-HE-Tag: 1755780212-256213
X-HE-Meta: U2FsdGVkX19OAtY9Oz7CMntb0Z/gYTmht5cMftAtmGgdcfNiTayTp4ugqpfGzwdZxDWHZpwi6G44pLi9QGSUVsZe2LARC0s4llKFUtV1Ikj5iHmYIpwyjkntPnVxoGzFWzvhYDnnRs3nKmBp49/Hwy1qRXKygC/I2NYNwRQXU2IG7Z7HQbA3ci01ab+Zy2mUlhNTHXn4URf65BeT93B14CGZJQ0dE+0YciegJh4TuZItFm9/Oajlt9uw6mCbIITNzn+FjxV1UlvMhIE5t/zlJTZfY2FkAQk+0b1NhVtHZ5P3mxk/sWlKRiKVUGTSkGEEkeIL4AJdWqlQAdANcYqrfWQ+rmi8SzFamuvLBDPka4L+/wkE/IjEgt+sM6y3hK9Yl5oIGLbQ5Z3wB0fJMpsH/G2LHvZApn3mabFHO7xENEnFOGYHGR8jpnr3Yw0I7En9Z2H3KNKXaLSRkGQAB5ZzrrI0nO++GIhJafGFCPVDRn5UG7XlCWe8gV+fhkINS7F2XMDTSZNhxoVKqa0cuj/hjBl0PMpIaT6Wf4/VHRdPo+3s/JqMvHo/k6y8jAOUWwUnn25WLuBJj2GuezdD+eOzfu4z5FLNYXogaLldKBWNI7mmWgk0gevGkD/+P3APTpYb8rtz+51JWNmY4wNfth1KeTe4dEDvkGzs4Y21QubjGOrTiAA82t3pHQ5PMphXb995aAzRXV3HJq9a7mruG4dw/sTIEC/1j5N8x/SEwt+NT2NZyX6719CYxNbDuCXm7JpECBoBPRB6da0Jz4pwJAXq4gr/HiFfJnzYKgcAkPVlGiIaNMPAJyQsbzNZ4vYXpR0EVcaWoEUJE5YvDURDJhlYi4FgpyaDwqU4CHTaw+0hkeuU6P1f8cCpav6fFEbRrxjUb41tJWMBbJlNz87HjuKGOl0311IHzOPyQccrafHuzBd5HRHM4A1RvepAkI+pQIASBfOrJDw73y1ZOuGm8S4
 UtLq7JiV
 qR+GAfnnmDTRrSLmy/frsgsaqj/KdVwyrEzfgNUKa9cVEpvfgQVO5DMkzkWSP3iOUZHyRWiS5irR7v1cSk/vCs4GsIhnwLU1KDrNwPMALkFMUxAKT6a24qSlQvGFrqqxpzBaVSTj+SIamUOFEAS4vh3FMcbCZVeu7ESRmAk7YbpKl8h6oyPwJj3vdF2XLaaTbhBse/DgEK4WQGplB+trpPr/A+bpN4DIoFtIckTMLapgkJTwkiyU+9TJpyrNFD2+JuIYhxU9bM0CTbBqgKhMdgE2PVA16HAjNRhZVonPSOAmR3/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/mm/sparse.c b/mm/sparse.c
> > index 066cbf82acb8..24323122f6cb 100644
> > --- a/mm/sparse.c
> > +++ b/mm/sparse.c
> > @@ -454,9 +454,6 @@ static void __init sparse_buffer_init(unsigned long size, int nid)
> >   	 */
> >   	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
> >   	sparsemap_buf_end = sparsemap_buf + size;
> > -#ifndef CONFIG_SPARSEMEM_VMEMMAP
> > -	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
> > -#endif
> >   }
> >   static void __init sparse_buffer_fini(void)
> > @@ -567,6 +564,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
> >   				sparse_buffer_fini();
> >   				goto failed;
> >   			}
> > +			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> > +							   PAGE_SIZE));
> 
> IIRC, we can have partially populated boot sections, where only some
> subsections actually have a memmap ... so this calculation is possibly wrong
> in some cases.

In section_activate():

/*
 * The early init code does not consider partially populated initial
 * sections, it simply assumes that memory will never be referenced.  If
 * we hot-add memory into such a section then we do not need to populate
 * the memmap and can simply reuse what is already there.
 */
if (nr_pages < PAGES_PER_SECTION && early_section(ms))
        return pfn_to_page(pfn);

The patch ignores the accounting here, based on the comments
described above for partially populated initial sections.

memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
if (!memmap) {
        section_deactivate(pfn, nr_pages, altmap);
        return ERR_PTR(-ENOMEM);
}
memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));

only bookkeeping for newly allocated memmap is performed.

Also before this patch, __populate_section_memmap() did memmap
accounting for !NULL usecases. This patch also does similar change,
but covers memmap accounting for both CONFIG_SPARSEMEM_VMEMMAP +
!CONFIG_SPARSEMEM_VMEMMAP usecases and memmap accounting based on
allocation resource. 

Let me know, if this sounds right.

Thank you.

