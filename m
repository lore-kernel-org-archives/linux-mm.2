Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B477C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B87F6B009B; Wed, 16 Sep 2026 05:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091DD6B009D; Wed, 16 Sep 2026 05:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99E96B009E; Wed, 16 Sep 2026 05:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5B2A6B009B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:28:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59EC01604BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:28:22 +0000 (UTC)
X-FDA: 85219099644.20.7334446
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 247022000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:28:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MN7RndIj;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789550900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqKTsTEHQgdrEF0IaXA94EH5N6/r92TjKqtPeQ92GtI=;
	b=f/dumcTDOZ2aniWOe34MUUVPnONIkbEsxML6O1d1FlbD2g/KL1SjhBhjSsL3e7uNBtv+pQ
	vGLwv6NN2L76/v25KumY4ofSxoba3fhDvgCk7dFcIOcmSDOP2M7ijqbQRgaleH0xsVM8yh
	aeQL6CLXBN9hv6Ln/KNCbw8XEK7I0KQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MN7RndIj;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789550900;
	b=4Px9NPr2BpSMLuSB2IjgzAudPPkZ/JM1RXTwNEL4ghaadqJnhth620sm8aNgES//320Fg+
	qCNLG1sCimtH9IX8ayLlGoS0c+0EOIgUaJXEhx6VQPjfgGpG0PaXvLHXgau8cbx5PTWK7W
	LTaIclSeWtWyVduwD/8bd3L0CFjk2hg=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLVl7e791542;
	Wed, 16 Sep 2026 09:28:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=eqKTsTEHQgdrEF0IaXA94EH5N6/r92
	TjKqtPeQ92GtI=; b=MN7RndIjGQMted+4PCMbo/bKWakskDW9seWVKDnLzZmWC9
	iyf1m+LAAKwrJdMuz3O0yswtYACUR1aDIUiNIDZd96CTAzn6I3zWc7JodifFPNJP
	JMaIbWIR1di57VjUhkJvAGAdXUfkMIB1rleJzLg316Qgt1GAMD3d3TvPaaUYJt/4
	MG+Eho4oO/wsSKho9gKSGA7GxtPFtCUYeOV9qpAiJqOYpYqSSJKy4Bdh6DMYvgAF
	iscg6jiMglQ2hfLfjh9lykGRcGn8Xx4uVUqlbTKPQlOVcM/ydJcbUXQLyt7aC0nn
	D9vrk/sSBhpKNDEr25nsHdMfQgkGYr11a9hCf3DQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmw5e3hy4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:28:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G7ZKuL388918;
	Wed, 16 Sep 2026 09:28:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxsdnka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:28:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G9SD7d37618160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 09:28:13 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2714E20040;
	Wed, 16 Sep 2026 09:28:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6B7820043;
	Wed, 16 Sep 2026 09:28:12 +0000 (GMT)
Received: from osiris (unknown [9.111.77.138])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Sep 2026 09:28:12 +0000 (GMT)
Date: Wed, 16 Sep 2026 11:28:11 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] s390/qdio_setup: Use kzalloc() for the SSQD
 request
Message-ID: <20260916092811.15587Cf8-hca@linux.ibm.com>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-12-e931086fdde1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-s390-cio-ready-v2-12-e931086fdde1@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfXw3DE19lOJhvi
 b+fQYDB6sE27QD9eWOhBZOaIQ66FvPha87CoU7PwV6Bv32MPA5x6mrnaYxZpeo+/UqW6j/87wQz
 /GCnq1YFVlKRlD22sdapQklNVzJw5qZWNoY5xXVgIK1eK2CD6m72qcqX6lrK9QJ755/ukhd+Z5f
 gH9FU99+nugo5ADNBCtJBSy+8RKPK4vGLUFRajQCqWK4tXIM7y6WMoWK3OOk4FYeqsXxUj3NCw/
 PHQTxItA8hOpLZ6w1y3fC4DXjOtsuSALYXZ/yM77ThXZQhFIBBmooJO0K8xCC6n3mMoeVrZqTLq
 jGRkvMojYCARIijFKYMS2sM0ccP/5j4xiXgWcnqV1aNqCpsqFks7ntkVO2T7nTK3kLDi4whhjFn
 bhAy+ejLy6uCLky1HTA7BnNkcBuPPgqEvde4DT30j8tte5uxiVwZ8jOO3drdMnxDL8AFuzNhC5Z
 cHlGbKsGcrJowH4ULnw==
X-Authority-Analysis: v=2.4 cv=E/NYNqdl c=1 sm=1 tr=0 ts=6aaa6131 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ue7VF2Eu2BNBYPlTsnYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: aH6S4rG5YzAQ_nfapeuiPhb48dM7Z8oH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfXxTIiGgGcB4PS
 iJ2h/j3gwdCEe/QEkilBFK4F3tBHg82wrx58FrhBEuqIwW5oiCJ4m0Bd3VeY/WIFCJyEfnKxkLo
 luLE8D1c2P+MdUsN5khKtRGZWrGBMn4=
X-Proofpoint-GUID: aH6S4rG5YzAQ_nfapeuiPhb48dM7Z8oH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160116
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 247022000B
X-Stat-Signature: q81jofukrz7u8qt4hdzibd7zf97wuw71
X-Rspam-User: 
X-HE-Tag: 1789550899-296983
X-HE-Meta: U2FsdGVkX1+NpNekswEErf6m6i/9vSTiFdL/M+CHtHmeY/0XMPF2JED2FTkc8ZL19+PeP8hZR0HYtqRe2GXCBlHcaqFqvRy/Xo8erPKq4IKjmdtVFDWMzDUv5NGwfBlnGqBQQIo3m1ozwU4VzZ32KXFudSWd+1JEAdItDRD7vWUAW56YOpppdIjPqy5SHfglE6ZtvqMYMDHdLPdLw7J6dNTGYml4crKMZ93J5qwaqgp3VyVqQ2GHnj0/Vp8vGVAf5++G/z26cI2eAsOV8n2N2Es7c2EAGO/tMkDYomAyXQPmz+FsD0OgKuCHwMkAtOqvenOrXtUmM11W29wD0xOrJA1lYGXN5VmdayVtmdh0IUBeLMOMYokxVtrU/8EwL8b1CRWXURP+BWOvkUuokoYWWLTh/NjqWhfldFYrDY9dEl4fMKRoq7Xc+CvwJOZaUl5nXeV3m24LoKP85E3SCecjaTABCTyGYamEfFlrRNjOCFh0VkJG2RZAFwqVrly0d5aHHEyeWB+wMhvZnc5S4sTRKOCRdKyq/ipzS+VCWNSUdPPAa2lyC96EbbBm4xhf/IJo6I+drLtr/OENIrtJwgqqY9FKLJ52woK9CBD6tBMiM01Of7wzIS2yFELXWPAa2cKmA7044xnDDRksy13+LNO9+LyJz3p4nIVNP55P6pxQcO2lEq4Xh/PvwfFHWXvIPX/r0ByCCFwjDrYQ1a9R3CKVqOQrVgX48qMMS4a4A8qtq6OxbOmWnx9ViD8UxmI+kXQDxo0Qdwlbr+DT14t94InIlmmgHQAHRDbwVq1hEZ7AwqDl9gPZiV9Ikh1C8tjTSIu2pPiDT16H+r0flNYG77OXUoCdJTkId/7MvoMnHUwIMP9UCUgw8heg3yTIBJpwssyDYkWxTrrNfXvpoOJ10xDjy3EyfaH8LaGsGTGGso750gLiOZCbrwZWIeJX/fSBTxDa8LYjHY0O/NwEedX6A2B
 VQKX0qXj
 SlY9cSkCPKULSQWGij6BK+DGWWnty9h/2YVDNkloHZjUamCO2U1ATE4AEDDVz8UzbquE1m4hQwM1ZUEdjPXKB6Lj9TlPvTA3Db4zaXtezbzq3zgquXRF9ZhAOajfQrNxfazrNO+428z0ttM9E6QiJFTLi330hC9TG7ZR1XdIYyx2VhnVXheAED/0ySngRxCfi5x6jC3Ms1E3Szt7whmJrpOL7MuzOcLn6jMiMETyWw/dPG9xRVkFp6z8ACyYe6Dd/AIL1lBR38veOYV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:00:14PM +0300, Mike Rapoport (Microsoft) wrote:
> qdio_setup_get_ssqd() allocates the request block for the Store
> Subchannel QDIO Data (SSQD) CHSC command.
...
> diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
> index 7ca8f61a2387b..c0215a7d29a81 100644
> --- a/drivers/s390/cio/qdio_setup.c
> +++ b/drivers/s390/cio/qdio_setup.c
> @@ -249,7 +249,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
>  
>  	DBF_EVENT("getssqd:%4x", schid->sch_no);
>  	if (!irq_ptr) {
> -		ssqd = (struct chsc_ssqd_area *)__get_free_page(GFP_KERNEL);
> +		ssqd = kzalloc(PAGE_SIZE, GFP_KERNEL);

Same here. The conversion should change the allocation to kmalloc()
not kzalloc().

