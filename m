Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DCCC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF8A6B008C; Wed, 16 Sep 2026 06:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A5D6B0092; Wed, 16 Sep 2026 06:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422946B0093; Wed, 16 Sep 2026 06:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F043B6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:39:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 771D11406BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:39:26 +0000 (UTC)
X-FDA: 85219278732.21.7E98C94
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20F4A140008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:39:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FwzjFTdp;
	spf=pass (imf09.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789555164;
	b=XYfUtI/YuzxKJKynZ3mV8Zdhs8Fxa/peF4oZ/6bqDCt5iSD+MMEyGlmx1yJQ0Tk/EG/7cp
	XX0Rd3x/ESzyhcS5YRFp0RR7Bs24KxzGsE0OtQXfKdMDNAQO4qLkzk0FQ4g4581rEs1tQs
	+JbJuTFh0yvAxHnYXz9d5B/g1euxJVI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FwzjFTdp;
	spf=pass (imf09.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789555164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3H4eiYHlM52Ul5TlDNK99t0Z8JheOeMJcD5v1zuGgA=;
	b=3ylB1wp8YcP499t+xpzfI03apbkM5xSsNHbljOpRJuHbT92YXEukjdGP2yNLkXoBbDI4ab
	bwL/A7eSK710sFGe9J81ZeoSZLZsFYEJM0AUxa/kPoEcDsUhTWq1v/Un8V9YqTphuNK3lI
	WpE9M3FlqCAVV7tqWXRbwH/LMLqY9Rk=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLViLw1963941;
	Wed, 16 Sep 2026 10:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+3H4eiYHlM52Ul5TlDNK99t0Z8JheO
	eMJcD5v1zuGgA=; b=FwzjFTdpGMKZbZRS23HIk8U0MGP4RCIubNPxVJBrRmep6a
	3K0vmk4Z7xG2DbaUfczGOeAvbK6UTdcQnUqxzRbIcBSWjhEOIBRBylgU8TNYY03g
	pJOUMGRRwWxCcSVUi+WIEuHm1EJNHFW4+mExpbkVZxevgyDSNd2+lWMVv1i4LC6Z
	Qb2T83OmNGcgKitCoeBoiXa3TnANfc4BE32ap3Yaqvs0eVwgvxFBzkJLD/dI6wTa
	hBoEt88JdhZJZujhUq1vvUmA0Y705sJ4D2CDhSagVoBSk8oSb548wEJSgqHHDvvw
	OJ8CaJJZt59apmaCbx2q/OMHSaZ41z6P63Hp976g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf540fs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 10:39:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G7Xrus414631;
	Wed, 16 Sep 2026 10:39:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq03bwudd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 10:39:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GAdEI510158450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 10:39:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C67B920043;
	Wed, 16 Sep 2026 10:39:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6374820040;
	Wed, 16 Sep 2026 10:39:14 +0000 (GMT)
Received: from osiris (unknown [9.111.77.138])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Sep 2026 10:39:14 +0000 (GMT)
Date: Wed, 16 Sep 2026 12:39:13 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <20260916103913.15587Ea3-hca@linux.ibm.com>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-11-e931086fdde1@kernel.org>
 <20260916092720.15587B52-hca@linux.ibm.com>
 <aqpuG_QJdsMj6_so@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqpuG_QJdsMj6_so@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ys9KpCB49CI4_-bPZyIr8JYvriTUPdLD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEzOCBTYWx0ZWRfX2rTLPgQNpSTR
 rmiT5VZ8LEr/X+t2cOLO0vxyY5DopxT+shkWE73PTv5vkKDuIA6n7s7RwAQ1udUa9UGbHphZ2iS
 hfb4g2rSYfwlVBOOkaladzjuXI7HKNk=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aaa71d7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=eNkaPj_DA2v-bknRGywA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ys9KpCB49CI4_-bPZyIr8JYvriTUPdLD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEzOCBTYWx0ZWRfX83wVa+jXeFQF
 jtOhLzmACExMLaKf2nueWLwOkLK+n+b0r5volL41zQEbxbMbguLvXEfJjjy9RshjVoWcDgf/PNK
 sBYzhSEZsx5mjRc/u5GRfvW1f2KJyj7Ubq//tbiJrND4uId2UwQIRW5WwbuZ8cb9xLWh3prfQV2
 P2MDTR3dOzr5heurqsz1AUELHr6FAdNs5aslrFHOUGaKthDJOnaQ7TL6m7p5Ywg6beGmqo4wcKI
 ntS/HVjR7LhC5h5j70FoxxlpHkCAhrGmTJkfNC1lfzlwOdTSTdH/af32hYjEKvM3f/gSLRM1tyr
 Dg5CP3GYTATqaRNb/W7T/05VRLWDQ3TrDm7FdfXBrZ7tOA7p8lsqfoNXdoql3cVV0lgvUWgFZxh
 nzkUW5gTKVKNpjddN7L8UT240iYakdcyufU1xu9EYewjLbVzuc4zmfs1Va4Ie9RfeSWUMNLDGFB
 KoZqcAz6JjLBlrHcFlw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160138
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20F4A140008
X-Rspam-User: 
X-Stat-Signature: fxt1k148ufyuwn9rt187juziokja8xem
X-HE-Tag: 1789555163-660270
X-HE-Meta: U2FsdGVkX1/dv8HPbaA2uP5PI/lrVEZWZQRsA1lzRnSBngZz6o+5XguMyPEXBSFsQnYwG0bMK9RF5hIYbYZg5YMEYg+BHQ+Zy4foDnyHku4gCUx2+X3R4Vfy19BPKM6pnhSAdtLmLuATnVggH+Eg4lpuaypH+10f06gqtOwBOSeKbtkwTr1PjUOkp9nth/kjcVB/6bsgdzwebmZfE/4r9n3+k+a+6TIzJEJAaZsaPolgCbUiHS1g3ac9+INUedHYLyhUFBzln/XbS0dAdwLpjuVm7HNN6PrZfz3ucKMS1qY7+x5rq9iVTFYunCbb2N/RPEyi3kmIY4SxEHf+phOkaHTF+03D1AWLwoAIvINi09SouKoAkS5nPuJVz63JbLGnYmTYsrs58OxKr+QHKjW9kWEkSz55jCIOjAK99KA21kDaavIlXhCE4tWZUmaGLyxmqa8zPRGGaYV7vYYsmIB+SNIDg9DvWhEWq1RwLdsVxdLFOjEU0dmJV2QC/W2KHuolyyiIMzK3bAPQ0oMr+VC7OG4fFTlnk8r6lQlzD2nqXzP2m5sf5WAZ+pCe4J8UoFWIrKPhyEEH04xceMtzj0DHiGCTYD5mmH6CbVjKSOydpHVrhgiHVOYotwtGyDzKRo1FSo53XkK/CTTpggfSLsPKfGkSRpUmCjm9obs5tmqnsia/j1WvnT9/6Gx/IwYIu3ZfcnXhI8N6OH46A1hfGlrAcG9WYpAwh+MdRbEf90EiLEPuXO9ksNf1dhXS3VKbuPc/yiCJSR37nvBEiaEVN2GeQhH5nUG9ZaCTt/jOoapPjfpY8Qu1tq486n8bbIiYRKLhlIuBcoBnOZE5+i6LMdZDX9cTNlNNMCot0ar4W3iC9S4EP4gqI2aePh8zkp4VgELTJcBI+MOh14nnHJqbDNfrmODZv+SkDxBqVwufMexAHIn49jr+HcJtX2U1gu/3lsSanUEb3OCBITNFNGZnA73
 zmU++cdZ
 AdzsBzmwfQ3qWOEC+KjCIOCn/McN4f3oO2WyLs4T81i5nrk8GJ0Kyl3m2OJ8zwJjwMoo4m6Kh05FGhVWF5WfQrHhfEPyn8RmOt0pN+c01LCRKjXLDnVofMgirvmok9XdqEwcjyPLMqbzqm8xC8vcwGF3jBWXU+iB8IH/ZSC3FlnwyWkUV8wy1BgFyNHw5jxScrZ8TEEMjO7g8KzHTVdnN7nIuef4Q8t4eBE9sNB8yX3U05CJblAlZ+6JT18SXkadd0QAPvr0stF8Mmj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 01:23:23PM +0300, Mike Rapoport wrote:
> On Wed, Sep 16, 2026 at 11:27:20AM +0200, Heiko Carstens wrote:
> > On Thu, Sep 10, 2026 at 02:00:13PM +0300, Mike Rapoport (Microsoft) wrote:
> > > __qdio_allocate_qs() allocates the storage list information block of a
> > > queue.
> > > 
> > > This memory can be allocated with kmalloc() as there's nothing special
> > > about it to go directly to the page allocator.
> > ...
> > > @@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
> > >  			return -ENOMEM;
> > >  		}
> > >  
> > > -		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
> > > +		q->sl_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > >  		if (!q->sl_page) {
> > 
> > Speaking about unnecessary changes: why is this a conversion to
> > kzalloc() instead of kmalloc()?
> 
> An LLM went wild and I missed it in my review :)
> Same in another patch.

I guess we want a v3 then, even if this is trivial.

