Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2599C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A086B0095; Wed, 16 Sep 2026 05:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B356B0096; Wed, 16 Sep 2026 05:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A966B0098; Wed, 16 Sep 2026 05:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0E16B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:25:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 664BFA067D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:25:17 +0000 (UTC)
X-FDA: 85219091874.16.33BBF3A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1097B40002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:25:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ldIN66i8;
	spf=pass (imf27.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789550715;
	b=8RcllZSyZOWHMv3ZfHMhAh43+72GeFeLjBDmx+LyCziCYSK90Yoq8IdiHSC25rVBD8VZ4Q
	/StMOSauIs6xiOJdLGMGy9OYUsmbtSgzCQP9w+kTMPf66MHmkw3+SzCY/1VdDWqsGMc1e3
	IdBFEj235LX22ebZ5lVz42GxAVXA7hU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ldIN66i8;
	spf=pass (imf27.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789550715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZ+Ccevsvuty6HV46TCyBPDp7xS5D2OwvS5lkpCi+iQ=;
	b=yl+HkdMudyRY1hRMF+65LVKdaiT8N92tOl3zv9wcGSZItTGXISrSjLORQW30aEmu0bbCuc
	pBEdIsHpqwgo4PsLhpyBptx/hnHd5ETVYoKIidlNx7w9pNAVo54YoTSo9XohIKkoE0Ofvk
	UmH4gkEgvfnbPSl9JBEzioTEp4+VpFo=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLVe6i1951647;
	Wed, 16 Sep 2026 09:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=HZ+Ccevsvuty6HV46TCyBPDp7xS5D2
	OwvS5lkpCi+iQ=; b=ldIN66i8vpDl8fqfqbjs6PXetPPKso944h32ENdyEUBAxs
	zCgkX7x276q/nxizdxKzDbYIX/iLYzKCMQIDTSkNgEZQVURxGniql8F4gChoOZgb
	jMJsfx0eKtV7Q8wQSf1hrlxrGfm12R7pW+bRR7D9kpSxxYhfW3cWXKR7qNZWQMyC
	qKyrHXIlQAmXnXRRV1Wv3VP69G1KO5UwmL0Q/V3IrkVIjluOljeyFg9AgveB2NMO
	bgLBcnNK6Xo5uPz6eHDJwU7XEVt3siQkYmIl3yY/YIgl/xfFgnUyu1UmgLB7k7CC
	N6K4htIZ5fteMsWEXuEFUXRjDYTXF1f/JzIiNdmA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx83ur9y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:25:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G7eegd414559;
	Wed, 16 Sep 2026 09:25:11 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq03bwkt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 09:25:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G9P7hU27066864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 09:25:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA10A20043;
	Wed, 16 Sep 2026 09:25:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 423A120040;
	Wed, 16 Sep 2026 09:25:07 +0000 (GMT)
Received: from osiris (unknown [9.111.77.138])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Sep 2026 09:25:07 +0000 (GMT)
Date: Wed, 16 Sep 2026 11:25:05 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/13] s390/cmf: Use kmalloc() for the CMB area
Message-ID: <20260916092505.15587Ae2-hca@linux.ibm.com>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-6-e931086fdde1@kernel.org>
 <20260914175952.14910Fc6-hca@linux.ibm.com>
 <aqmQf-H4yeSnE2Ko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqmQf-H4yeSnE2Ko@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfX69fUZptnnHUU
 LrrBMk4p73kYj02sbSnZri/y2AhmHbqevea4IIiaytd0Kq+FJB2PQ/W0U3wmgWlO5WFi+MOvuEV
 oEkveSBkpOAgaUHmMMwc9cmVp8KN+8BWe6xWmHtDXR56RAmVhCVE2H/SoEvTGpDwuJDvgpi+AFx
 1gaxDpuGfCuL+zHWZdN6sQ8fD0VLA62fTeKZA/UxwKXsdCAf802MGlJgVXmS6I3KmY1H69Ig4MP
 IBY2iq2h8QeCFiZ1AIjfBVlOVvjdoajgMYnvzd8MVWQ7DVVfmawNNRxMw51OJUDu+HO3MIsdo2a
 4gaPfomddxQooCUrBSxj4UJ0INoijEAxCcqOvMbUl0IL9K0lgruC89rzkIgzg+I+rNjrNTHIQAj
 cCOrgpq4wKQtRkZCNtWHbYG7/BfzZBJah5SI3vxXPlrkgBtvPjl/J4lpNLXtlEdOCEvw/HQUQw+
 zHKYMUNbh+94N9+NLYw==
X-Proofpoint-ORIG-GUID: g8mDs6ZcI7hyKXA-rqQ11cv1ZxLPEDED
X-Proofpoint-GUID: g8mDs6ZcI7hyKXA-rqQ11cv1ZxLPEDED
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExNiBTYWx0ZWRfX71SwQcJHROeH
 /6MGV/0cYTm5Hq6vhhaLZcR2912LzjWY7QKhUJzheCgdzmrVZzXwocHdeMDW7u4cJ1GJxlq7no5
 TVlSmYQKWN4NI5m5xCGkWfCaDzulRwU=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aaa6078 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=jh9rqw0bRQUQ3So_9I0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160116
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1097B40002
X-Rspam-User: 
X-Stat-Signature: 1e35uaxumw5woepr39d1x9ecnt1wkgta
X-HE-Tag: 1789550714-50559
X-HE-Meta: U2FsdGVkX18UWtW8bmSjIiRevNUEz+LyVr8im8wDHK4wiDfVrNLHNg6Um+AV09LLZB9OMDB5WqvYt6MHhWdJ0f6fr8sLHKAic4BafeCCOpyiQ26oT4ZsQzlV4Jf3gj8a+6ZIJXSI7m79BG2EPT4aNomms6Vp/SI0cEUvq/bR1qjdsC3dY51JLEMzRwPZZGhGh4F2jWll9Nao22Kb/s/2II/jckeni73DB5d8SeFpv2/GIRO0VBjOXuaBRDfEkud1LzvTyuzIk9FRD3bSvMrojKcloGmOhSUvZzmP+RYLrStBSbakYrSVHfEGkudAaNwuVpO28Ni0hjwSwK9tIFEygI2HJGsnubtoeDxIUAy7UfwoAVBr0pO8+vHpOVeEMcJapLlRbMEVL4E2BLIdH5u1ZG+7d87Qa85fmGmWG4a1ZHzxYxlZz9qD4d3ogNC77nIfXIXYzDMvRakSryGaLvZ0Kx14vc94a3fgEETOTrLx4kHuJN68kYqDEgM8qWh3ou+FpG6obkRXKUKItKN00e1ahX36X5XhwHyXZfuPeKmKm28NscI7O6KGmm+XSt7mwz3SUPeNnWiSwA+qMyO8cErzCbjFEpg0XQqzu9vdWRSSxlQEkcB19irfNPaJZBey048Sf0wrRLHHoevJ6HGco58+ce07/zbP6diqg9B4W3ZqR8HoFmqZ0198dCCKmTdvehFONBXTr+RMn9PqAxKk3pnpPcUMULtC1SgtNA8EHO0iP0kexUvPvPodYRPB653wR41slvjZiaCodgSbdGvv4XcMBsDUvL+WBjKfeRrVzaHBilCA7dmVBrKcRW2ECtBZznPhdo3mX5HKDC6jniwMipU/C625HELnjnJYXIDo42KWdP7MkTHvJ4qbGtTUwa6S3HM6vv7/b2cxS4ApROUrYGVOFy9s4lCBb4IQBX7yhOTxsE9vIRvi6kGYnIBqO1H+4d5RiZFBFpXAOntqzDJocgv
 Vw+70eDI
 wMlAWuyDAgtsL2yqgKk4ApF2QqSj062YWXlgWVky5Ae1fsUCzUSNVDnPm00LNCtOo6wX/HQtjYpUAPts9jNrGa9OiV3g5wJFLnn9AX2R57YJZ56dseprB0pwRtdqcpXUaXitd15B+IIw4ZgIj6yS6GPNCY0BN8jcSufHwj7Y2dHTd03ZazNuvL46cdNUQhfh0UbqiPGGYN4kDs10IyM0vPB1wBgcgzSwRV1yC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 09:37:51PM +0300, Mike Rapoport wrote:
> On Mon, Sep 14, 2026 at 07:59:52PM +0200, Heiko Carstens wrote:
> > On Thu, Sep 10, 2026 at 02:00:08PM +0300, Mike Rapoport (Microsoft) wrote:
> > > -		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
> > > +		mem = kmalloc(size, GFP_KERNEL);
> > >  		spin_lock(&cmb_area.lock);
> > >  
> > >  		if (cmb_area.mem) {
> > >  			/* ok, another thread was faster */
> > > -			free_pages((unsigned long)mem, get_order(size));
> > > +			kfree(mem);
> > >  		} else if (!mem) {
> > >  			/* no luck */
> > >  			ret = -ENOMEM;
> > 
> > This is the only patch which made me raise an eyebrow, since the allocated
> > area is smaller. But it looks all good according to the architecture.
> > Since the allocation changed anyway, it might also make sense to switch to
> > kzalloc() and get rid of the subsequent memset() (not in the context of the
> > above diff).
> 
> I suppose separate alloc and memset() are there to save a couple of cycles
> when another thread is the first to allocate, no idea how important this is
> though :)

I don't think this is important. Anyway let's keep this as simple as
possible and just do the conversion without any further changes.

