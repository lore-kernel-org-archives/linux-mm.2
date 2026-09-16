Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A095C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D2A6B0098; Wed, 16 Sep 2026 05:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEF46B0099; Wed, 16 Sep 2026 05:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14E06B009B; Wed, 16 Sep 2026 05:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76806B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:27:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1A751A0665
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:27:32 +0000 (UTC)
X-FDA: 85219097544.26.27BD1D2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id B33C818000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:27:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RUzpbz8Y;
	spf=pass (imf06.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789550850;
	b=OyLdDzgPqziX/r1iAMuqwxkJZgUy8Cb/eYF8p3LhG42GFjWqEWToKt7MoY13rw6mWMtoaK
	tT0i1mMt7lIXuOv5SROlpd68kS2bGtfdg8fwFYgYvV1Qj9pmTqyLkI9UYFE/jHxr4W2dPQ
	Sp7tXKEqX7Z+s9z8cTnb0joGeDbvtMc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RUzpbz8Y;
	spf=pass (imf06.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789550850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/3jT32KmSfKpWdIJD3/VNO8qiz+e7Q3XqDSL2uo5is=;
	b=VYoKI4P8f9lAn5Kaifv3qCjOVoY0pymptK9IT8ywlDZSLHf4x/EZ4WTAcXkQkzOUk9SNXS
	tivbVzVM2Jju0sEpHIsWFzeBrKhCOrnNMVLPlNpcF74iqK0l3apVbnhJxIequgXOd7ISZ3
	9A1cr5s/CHAMkuXqL1+/3L+9vNldXUc=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLW5W91806375;
	Wed, 16 Sep 2026 09:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2/3jT32KmSfKpWdIJD3/VNO8qiz+e7
	Q3XqDSL2uo5is=; b=RUzpbz8YZ8dmoapigdBVgcIdHZcQoMTpLGiLc6gBzIIVPK
	v3SD78t8WXI4WIhko8iwi/myapHcDILEhB5pym4TTweV7MnK0Bw9j2WVNYLSgPtU
	mx3NMaj/l+lls/DLFl+JNSeWL+k5W8FOdkJKKtnfHyGJR1vf9soaNWZDqeeLmqiN
	CU4Y5JZ3TVMB+IT5Ih9togOTHBw4XOMxmHGGzBM805fAnIPpgs/zVB4/tw1ESWIh
	mkBdXmW4KnB/HxI3/kXfeLO4d0vGpYOvb40ciaTGyqYj2s1RqZ5adeCWHCrzO7Ra
	RTWSJ5M4VoZn7XBrUzmsZDSBaTe12P0CNlcOskNg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5huq9d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:27:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G7Wcml1354827;
	Wed, 16 Sep 2026 09:27:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d65wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:27:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G9RM0Z31064636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 09:27:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92C7E20043;
	Wed, 16 Sep 2026 09:27:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F45320040;
	Wed, 16 Sep 2026 09:27:22 +0000 (GMT)
Received: from osiris (unknown [9.111.77.138])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Sep 2026 09:27:22 +0000 (GMT)
Date: Wed, 16 Sep 2026 11:27:20 +0200
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
Subject: Re: [PATCH v2 11/13] s390/qdio_setup: Use kzalloc() for the storage
 list
Message-ID: <20260916092720.15587B52-hca@linux.ibm.com>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-11-e931086fdde1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-s390-cio-ready-v2-11-e931086fdde1@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfX3EfgxXjPBT5o
 BBUjfOoIbHpPqoaIMHP7eooh33xckQldVv2ACcxJptWGjGm072Wf2o8f+AQMtzoHo8t+AfDN/Je
 jJePbNj379FOrKCNLjNGz4iAIrLUGd8gmTNXewHn+8BqjnudqCUcKQM+uYlllLJMKssGOha69eT
 6DA8YUTD8KOrcnwAfPEGZwHO7yig3iJRxtpAF9wBtcmRpBN9O/Rh8NxbYw1qYrLQsFwRX+xQXos
 UKS2wfjfim8TucXX7kUz9WjvC5HZBVM+3RHOaNi8G97dHZS1sFNV7Z+iLN0gxGADILdqEN/s+up
 aNnMjFvwRBF+767uSltCBStRsIYztL0kaWeHJwCkI0J6Z3Gy3eG2B4O8Va9DMJNV2Iw4tbDZr4j
 VTui0MD9SH32Vc+4rI8luLcZzaDvAfeXTzWAuhVQtxY3p/gGHleYBURkxYY1vbtdQbguZRDj15v
 +eE4tpocfE3IEJ9yVqg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfX/spbEafXLIZk
 qPDrbpGZsKtGMKS2mpEw43VfY8k44CX7phBrfDUXkE3Si507jeJO9y5LjMxsKaMefZnkR1++19z
 /vbLROzXSS1WOe0ZmMFv0u/su7dOUXE=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aaa60ff cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=qeVUGtoKjQMzvgjGzkwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: fUUTaSIfwXODyVtJLznONvEXRuGwHtSo
X-Proofpoint-GUID: fUUTaSIfwXODyVtJLznONvEXRuGwHtSo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160116
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B33C818000C
X-Stat-Signature: pyszg7d4hcp68xaipe6gaycskezpgkxc
X-HE-Tag: 1789550850-357800
X-HE-Meta: U2FsdGVkX1+ltyYn/8XDHsX3uj0VrbD3N1yR9r0IemoxGJWzcpmlkHvQk4G+d0DKVTorRxar+gmIOHx3C2n7+fKii6i19NdoryBE8BW4PX6vK1FmEdOqrfWQsst9lS9NKzt2AjEA8Xdfyr0b0CmJMqTo2nOwBNrbG08KfjY+xOSJeo5rzVgF9S9Qo6/Tqne0Oa13XuNnxf8wbsjEN8xQEYbyqYPclJlIVAiwtlSAeJrvElXaJiP2TzM0xpBs2CW0usav2ishb4O24+InHJaTq/2HpBHMrj0/SCKb4f0oJBTzZbRsImXErM7ImPG2DsqFEFmGFlr3Zh5zP2A74e6jExqLpVvdpQbrkIb1kHoDVlbETLAVXMAM8BczXzBIOt1C7EhjJ5YE6rXNPQmG6h4M7/z/1YqFRQ3z+UuIxGFb1WdrjdPa0KgtvNrBYr6a7XKNFFF8HiOB6TwLua+SHPSr7w2gBtHQhfsPQM/OwvPTUbeXVaIQwO+B4k0m3YE/j29HYto05v1tssmFYZ6K8j5Q27ddzaQR/NyL4jkRCtFFapiaRTNCYrtCBJTVx4vzdxuuyX2d74yDVFEbCEwIlZxK7l+Jr7U8yTW7Eim29cZ2thHzdKJKxrIKBnHdjT6pXC09hp9KYGJgUDvOCRpJR9RN3n7H9mAxTMvWlW7YHkIvadxh5OT1suJ1pM6NE2I4uzkLYJHj3WU/QZvpph/TdUmer2i9Pd8+Q0de1xuA20OcS+f8C5634auLiPBVQwqH8IQfGV6ChMCXHxj9nxSwdYYn/+awJZpHDeWXFb6bA+4ESnm7jiTefuQgIValKM80o8Fl45jdYPtYN6rd+uBfUoQVPgOILRaRDIc04TcmPikxz/lczxI2awHFm51zfIzx+2Gmm8E22rfmI9iqOXxpZ3D0+0+d5zC6DzPtsu3TBgh/lnRg0Xz2IHMf1nSf+B8lR/V6gxFHKBCmLxINOQeQnrD
 ZvYbFqw6
 88E8sOUhBNNqWe13T8aUCgaws9TZ67sWnG99hZe4j5CA7nKIuPL7TRBSfSn8u9AkQgoaZRaGCigOO6C/3astwmAm9rIW15b0KCXa0SYfGXh7C1TZPcj+3mGJM0nErsIl6n2rK3nrA2BjFMTzEcT1kJri6MT5epqUma9NZbEoF/KYca2DNsf9rioUDswx6iTgV3CdFF5AfVmeWb9KzhgSF18wjC/BsZ+vJAscEqr1aUa5vPft+m1gRsR0JKUe/ahQ1hbftMjCSjmsvQGfNusbQWuB2TeVP8lPf4ob021CSR+iiG1QfN2FKvR3XVRsw6RUYhO7klqZ5d0J8/VObEHnndw9gVBmQ31Nxn+cs8OyQqTucmIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:00:13PM +0300, Mike Rapoport (Microsoft) wrote:
> __qdio_allocate_qs() allocates the storage list information block of a
> queue.
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
...
> @@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
>  			return -ENOMEM;
>  		}
>  
> -		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
> +		q->sl_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  		if (!q->sl_page) {

Speaking about unnecessary changes: why is this a conversion to
kzalloc() instead of kmalloc()?

