Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB08606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ZRqApd5k
Received: by kanga.kvack.org (Postfix)
	id 71B536B05B9; Tue, 17 Nov 2026 10:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC416B05BA; Tue, 17 Nov 2026 10:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB3E6B05BB; Tue, 17 Nov 2026 10:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEFF6B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:34:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0876404C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:34:19 +0000 (UTC)
X-FDA: 85445007438.11.D30C782
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 279E1120013
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:34:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZRqApd5k;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794929657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRImLx5dLXwC4aZvAd+LIfkYnFZY54GHr5TiPnpbInE=;
	b=olsRPLYHj+w/KTJpfdd4bfp9aC2Z6C1WrmkKMHC20a7tw9EiDa2y8sWWbNyOHsM3PGRPwB
	BqQocxstcqZ1m5IfNDrhPM2KPtQEiFAdyb5t2w7k7XX2AEnOiBOMK0dO+xT9xDMc9TPybd
	5DrwAf/P8Xa/bGkn4OAtIejlU2vZFf8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZRqApd5k;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794929657;
	b=tJUGEOUTAiZFWgIWf7+8xg0KCDPTjCetRuwicla+iYQ+XLn03Is9estCx4N2Q2yxl/rr1i
	J7WHknZks5WCxItY+Di1TH1djRCw0tHdFBsLWKV6wjfxi44OYulM0TFBBpPgoa+XXCHo0g
	1a1iYsvZ4LcR/Wr3Ji7BI0ud2nTafmw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHFQqbf2730846;
	Tue, 17 Nov 2026 15:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cRImLx5dLXwC4aZvAd+LIfkYnFZY54
	GHr5TiPnpbInE=; b=ZRqApd5kAP50zP/d/0pQZ4bIXODCvV5LVzpOdJ6QpJB4S5
	Vmeb56Q36ao9fJgHKr76U8ylPQfiboVQnlcqnR3QOLgjz4Qr30MZKS/zJJJYv3ph
	jeCtILk66Fqx9hoVyY7xDSpwOcEnIyztHaZulUc1Y9pD89bZkNLsUzSm7vUfs1Nf
	9uipyKKzqMv4os4LLdrRuSynCqkWmpz71bJ+wCsr+RZXMaAwjJ3Phj4vKiVp9AiJ
	dAVOqDOBJ/HGUoq6PrvxENUTIsvV7sXWndVGfiRV47/wfxcPcvCsqOWL5kgiEUSo
	2x7QAK9SoWhVLiQ/eLqZPu4i5XCKfBxPk5rh1h7Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxfc542j5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 15:34:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHC4tvn1514811;
	Tue, 17 Nov 2026 15:34:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j02juckk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Nov 2026 15:34:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AHFY8j944958040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Nov 2026 15:34:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98FBE20049;
	Tue, 17 Nov 2026 15:34:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C5422004B;
	Tue, 17 Nov 2026 15:34:08 +0000 (GMT)
Received: from osiris (unknown [9.111.0.235])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Nov 2026 15:34:08 +0000 (GMT)
Date: Tue, 17 Nov 2026 16:34:06 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
Message-ID: <20261117153406.32016C4e-hca@linux.ibm.com>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
 <20261117-s390-sclp-ready-v2-12-e518c99622c6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-s390-sclp-ready-v2-12-e518c99622c6@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA2MSBTYWx0ZWRfX7tW/KpOHGqgx
 KB9hf3BwQQ3M1Zp0KI8nfaCNgoxja25UPwtxXh2j2rpIoS2iFBCvKDn+aZQ/i2nXkW0KURXVyNh
 ulb3uR0WKdQQL5D0clhH9ae+Wv6dzks=
X-Authority-Analysis: v=2.4 cv=Fu6QbGrq c=1 sm=1 tr=0 ts=6afc73f6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=oQSlCnxA2W13FdGThSAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA2MSBTYWx0ZWRfX9YJHoEBdfUJs
 sd8Ekmj6MI/tTMruvyz5cVFMpXD83yVF/emttZCUhu4pExcf1GrY+wAeVb+fWhC8eh8c11WtVCR
 ydPGqSbaisTULgwQZQfC8OfpqehaGlSnBX3uu2rU1OKAAl28UGAfzeimkvbpKRkdJHEyU4vJxAI
 jMhC1uefpb4HRcuneTswbpPX3aMl/jGPYJp2ejcmjkQzzbHgO++iRVMVC6vTUo2YBnVGGUf+oJR
 +ggceJjksi+XHLBgmDyW4dPLtx2wyCZ8Ls/yRQZTmYq8iusXTiCwWxwxvIEeV1YIXjuDVfTtvm9
 lTCpqKJxsHhscA88pFmudYAMDve6jcgdfjPBwjNb5m14Skl/hmwKETts+tvSqxLy7WAwhhdnxI0
 oXeRHJbTNSC1gddR5XWaiNVo4uZCRTetM/QtxRSht06zFFOUGpViZNvoieYXXkdBN1OjdjRjd5u
 e836q+9acyGLcVfJAvA==
X-Proofpoint-GUID: r6MQuHWPwaGD3PGuoazSz22i6fl7WIJG
X-Proofpoint-ORIG-GUID: r6MQuHWPwaGD3PGuoazSz22i6fl7WIJG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_03,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611170061
X-Rspamd-Queue-Id: 279E1120013
X-Stat-Signature: 3gbwagreaockq8mrgs98118wnngx9z5t
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794929656-534868
X-HE-Meta: U2FsdGVkX1/mq2JxE5bkaLQZVGfkUzAvkNKH5vDeRdyjXfMqsQF3sY+SgSUS18k/QB2b+f9sbyWV7CkVIdUMavRwS8st2xrJL4N8wohkh53gxxIPhWVT34Nml9nFaMyfKLSqSjcZlgrZUZR9grq3B+teFzX83Bc9etTph3+bfP8GP3CKY0aIB5VyDnyejlKy2kKh6p7zx+/gc5gCVgi24qZMXr3+haSG6bC959jYKoWEOLHqmKMEh7hxTw2lbng++ZAmYRzoyeW7U2ADLudbHys4Jk9Z32EbjE1U8ybN/3v5+Qw4i/VU1WDW8x8brKlzzIV0pkkBMOEObDu4Q+fJKZi3tJ9FRosqsviYtKoCjKBaKvz+LOdMYf1q6dXv2cFphj0vyWhN8hfEAz8RXejmxrRlnhw10TzRhYV1uvXOAAz/ZqV85ySJ4cVAkkOtVH5ELi8eWmy1Iq1IAywkrdA8n3XsOrocppCHi32T7dNl+Kju6/1uwYA6c0JhEie20n1zVKNNrYveOS/m3Nir5+7EM85tCtygr/vsVN4AAzJVsD9addFF//zLfO2CPEK5w+wMV+QjU76UUGJdMdV7qwbQIpDHfrE4FieO6SMKF0hghuvIeHvhxG6wbaP0Gyj7mjoYitJCXkJDKkXDtNB/m2oDGY+MWnwzVf2U3sD642HmHTPEzXpIQyMrdMwUAE53A87gjZgVt+oj3mMtZG40fglLnG1Tw8hzNgpgiO347dY5kjY24GfVEHDGHR0qyovG0ThlHnIoeecX739YHG2DQ81DXeiBFK7W02twzPysW212A6LiwNNpIEQLBVSJ1D86k81mmrbkJQ6USff0xoslXSakX4d/Gnil5Un34myMkO5h3+o1TgE0FPumOvmPGydHCHQpGqTmfl99hvIfwg4U7AmgoJGxvvVqKfeeFNA0E2G6uULDyZM9/6csS7JyIeNoBaZHRunnC9nTXg3nS7bgZOe
 WE0JeInv
 65+pDmdNvUlIqwom8m5NCm4hiFVBnMWY3WkmsKlKe8bGrelVA6FYJoMywlAuN21sZG8d1T6D9coZBtIlnfLkYVxr2P1rZXiHDkvA3tVlYfSEUSc3+kp52MRl5vCFsmbh4vu0A01IXt73BvV5LocDXwhkM3/QQa0EQ4DlLORSBxjCA2/teQWbnj91R/14iBf7Ma+/ljRZ6c6JeO80jz8/ymdnNca19jWl1OSNnCgyHHqNKn4r55ZhozBOhQxHtWOdUlVZoRFIwiNMhd4Q43XxK9LpPl4nCbiY4X47pqk0/hWjJqS7ZH6gnhyezgxNcJQuURL3pWlXMiFPaB3J5UOs9tTR5EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 03:07:04PM +0200, Mike Rapoport (Microsoft) wrote:
> sclp_ftp_et7() allocates the SCCB used for an HMC file transfer request
> and sclp_ftp_startup() allocates the buffer for the SYSIB 2.2.2 stored
> by stsi() in the debug code.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> While on it, make the SYSIB 2.2.2 buffer a struct sysinfo_2_2_2 pointer
> to get rid of the casts.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/sclp_ftp.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

Thanks for the series. Will be picked up and routed via s390.

