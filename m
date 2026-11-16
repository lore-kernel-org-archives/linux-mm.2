Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9CE606A33F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=rwMGbKeg
Received: by kanga.kvack.org (Postfix)
	id 88CEF6B05B1; Mon, 16 Nov 2026 12:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B716B05B7; Mon, 16 Nov 2026 12:47:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7514F6B05B8; Mon, 16 Nov 2026 12:47:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540246B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:47:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCE9A1401BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:47:39 +0000 (UTC)
X-FDA: 85441714638.01.D4C477E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 95D2E1C0011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:47:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rwMGbKeg;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794851257;
	b=OJPOowYpkTOzYBEvOW+AxjloklN0Sygh5/SmE8zhQjjq40XHvKWevI4iFVThepIWjcg4yb
	5OkrNMorCJIeCd/1WKad5J56WcGqTgmFMtu/KGIm4HgA7i25n3GPIWx+H6+CaHVymbGNkb
	3xzElDnaSY0II0p1SMxGzuhbPrQF1Fo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794851257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSkurEuqzWY07J42xz49JInftf8xvjfRIqM1YL0tZ5c=;
	b=OFI2+WDBKXsDQSTwZltLDTYvrSYpIdzFRtAngKvj2th9ABvw+dZxA6rG9s8eQ8eIjOxNgo
	AHjM5Qn7LPLsnV/fuHNDH3H4Bp5npmW3hZZH6OAq8NJo44IcwNRC+Jw5pfzfxXvihkzWaG
	XiIZxAJP+cQg0qS/8n6BFKg75f5GUbU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rwMGbKeg;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGGQBjV3773693;
	Mon, 16 Nov 2026 17:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=lSkurEuqzWY07J42xz49JInftf8xvj
	fRIqM1YL0tZ5c=; b=rwMGbKegakPvE0CIQtAqgEn+oh3LlHxF+nvZRS2PoVXJHB
	zJuLlPoWa/NHFe5JbYkg6HJkEBQKeCWrywf1dK+v3njdnWn1PEtC4vFDkc2oKZ97
	A/s9d81Aih4CUM4G0010EbH4iePu7mAgJYFvneGj/dwQZv+sYcEI/8kaGTCSG/sa
	0YJ9vpkRHOPuwIoR5bacd5JCzp5YS80ymccJRNeDhPUda5t+VzHrad+mGzcFXScK
	DpHlbyfA1ktUGm63n2aNRyQWBqGz07rDFX4216ag3+Ac+hK6ISXXeqfJJtLhFqjP
	2qM/vQzFGni61Y69TVyy9OPyEMKi7wHqwC+KB9sQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxf9ve8d0-1311
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 17:47:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGCKXv22351239;
	Mon, 16 Nov 2026 13:13:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hy2bv9u55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:13:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGDCwLW53084420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 13:12:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B526220043;
	Mon, 16 Nov 2026 13:12:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 434472004B;
	Mon, 16 Nov 2026 13:12:58 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 13:12:58 +0000 (GMT)
Date: Mon, 16 Nov 2026 14:12:56 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/5] s390/vmur: Replace __get_free_page() with kmalloc()
Message-ID: <20261116131256.125125Cdd-hca@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-2-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-char-ready-v1-2-3db507722530@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7AiCKN4979fldUbYW-Neq7KI7iaDNVkX
X-Authority-Analysis: v=2.4 cv=dtxOmFg4 c=1 sm=1 tr=0 ts=6afb41b7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=Y6TpkvVB5ZIwULgkomUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX5TOywkPDj7lQ
 HNrmfuLln6FgDAm5tONoVF0myIyvvgTGjKb2TaA8+KWG0MI/i7Rr9lWiIOb8/EKtsV4TlffUA0Q
 PeFcv79OZg2atJqk9oQfW5lLLdvyYaL3gsKWTOl6CyEizeBKqFlULaTxTdGlZux7EIwbJ+Y1Fsj
 FNBUuYcKwgtTb0+irzTRS7b7MVAkqDJxaEZy3onXIMI20Oc4vX800/etJ+kY8nlgxgl1qk52E2O
 C6C3LfX/UOWErrxoodoRokstcA8W5xQvUYWaB111dTf0EFwacVWfbuu2nlCpqb9oeONp8bdjFFC
 lAZzjc/N01SzKaK2DSIxOpJUkY3pSOczCzrqhBEgvVdqMJIwlLUnSicUiUmOlyz7Cv1HWQ6MxJl
 +/Rb4NP1mhsW4w69qOMRCKFxdDqPx+D/K0NG8POO9nMNykMcpBzkcUxzL9vhGB5ssWETrHaU1lc
 ielt9eBk1RF8wfvpA4g==
X-Proofpoint-ORIG-GUID: 7AiCKN4979fldUbYW-Neq7KI7iaDNVkX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX/oHTORHLiPRG
 spGtUexLGQ2GCSjwYhnFHs/FNuOQaz4quf96OKEXlzhWJe7LE2Cgwhjp1ZZSO1Xu58OczsAdxLi
 HKBfiPs3FW4s1seTCiNkygpH8TCORJs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160069
X-Rspamd-Queue-Id: 95D2E1C0011
X-Stat-Signature: ij4e11yiksxo51o5zp5ka5xr3pxgusih
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794851257-241150
X-HE-Meta: U2FsdGVkX19o5DFx0bebZBATOapJyKwCyzU2YunioeYKbGf9y0U/duaxIE7VACGLN5UndNac3TpvPso+ezql8zq5AaOVA6Zw4Xm8yq+wvMpezYY7PxBXqe3sSQhxAQo9WZV4qs09vbsNXVEPEqclCM74yj2/YhURgdS2WtcKXq9zZvkwStyC83AT4XEBfs/L6vkED2kpvT+gX1IsY/H3Cjy/mxgR77DkoMHMa6U5shCR4MGKyd63HZacA/NJtXbOgFTJoHU71VNIJrhZa60XWOm33TTwdiz8J6bU3IYpY8q4dLtI9UNi/f22FTnHNBFm28K6Z+FTu/HfqqaTFVtqgJXCPdrhuAyezK8R0I3TjRtBUq/W4jld5/IZuLYFto9xoaarmIaZU1Tg4s8jtpNnR0ZP1wnn9c5MizwlvdxfprQbbTC1lmZaocMpXQ0hFAauqvTCelkVLkcEdtjzKt5wkHyPoS7tMf+RHKxEktXiib2PhV3iTvTrnetHTJFOuOQ21em/QzCB9AY/XGWbWr6P3TKPmE08MrX6LtR+Sq9ir1NsuhkoA827wlRozwzUJoy2JHrEUWhUxsyMluMF9SuDWmiFoH0lCNZ6ylC14xbQRG9zXOQGAJa0SicHlUnG4PQjWitWtbGlfa2Pu+dqN6eEneSM/KPw3sDomwP633/gynBXOuFd4hjn9sFU15q1+ifeYwHRjfa6jp5uJkETzYbhpoxL1XPoCAPX2n1L2oiBGeTpwFpamcdtyi8i2jDfIoo2tyjitA4Sv3PUWFwCPDxlCBMLNMRLiRsg2I6qRdawmcsZX5/f2OTZc5ntqbijDH4y9Y8SeMuRrKlgFnwtIlrHmswxBl+UCcd7CdGDrc+yGeLTNzh9jceuA0AaXQ3T3i4wx8kTEAmaHKv9KiV7tKpnNnJnyODix0NuM6V0hwjCNKIch7Mr52ZDQIhpa+7kmdp/fdGA0Q0pHrm/TremS69
 KEEbgaD8
 PjhsMtRU+UKBrGyaHofR5hjYvtHJikhhOE2LpClcxtkZRpKKurYSadTR6oVuGzKm/90pdB+3boc145h6fiBUDQnKEJg/ROblFeckijSgmxPROUihHf5LDUYeavDp+HtCyMV3GXLOSlCk8vB/vnffCUkEaJM6FJ5KFuXV0g3fuGeXb6dlForPt15hJQ0vqjmXCqsXCBz0xHqX3/FaPGKN8j2AEdEJ65i7dJ0m83F5zSOHHstSoH55Fuuu2NDb5AdGEcMUN0esdvW+y17tqlMb1+LaV/Ic6mbyHX0ae5RvafCwlHzTJ2eo8VCeTlmiCcqww1LGvGRFPFWvKUsHHUcLdJxhK2NmJMAzbXcYc1qb2Yt4ibOK1vTahn0QkLJN2gY1zS5/I0D0+3KXvn9gZVYMcSh84gs9hCE24Zz8yaq9vtq6CaXDuJ9nRyAJ6JOQCZkE44ZQh/vKUS48oIKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:48:59AM +0200, Mike Rapoport (Microsoft) wrote:
> diag14_read() and verify_uri_device() allocate the buffers that receive
> the spool file data returned by z/VM DIAGNOSE 0x14.
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
> Replace use of __get_free_page() with kmalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/vmur.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

