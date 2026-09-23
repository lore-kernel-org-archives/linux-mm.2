Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA22C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EB16B0092; Wed, 23 Sep 2026 10:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208176B0096; Wed, 23 Sep 2026 10:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0456B0098; Wed, 23 Sep 2026 10:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6E1E6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:33:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72EA58082D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:33:02 +0000 (UTC)
X-FDA: 85245269004.26.82D051C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0947120003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:32:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Qo88Uxoh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790173980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTLEWXxZ3/GILPnEIAr1GlznsBvHRZfvHZ70H1KLoLk=;
	b=NoVfOcvKSrsHscB+5ZwaMAb+FXWbY34H13FBYTGRAAPBwN1wt72SUajPuSh84pou5EEE4d
	+8EoJjd/Kz9rdpp4LAKaqiKtEoTHabYzKzinVNN/T8pqdrpdrYnu760ZPSepuc8zjwbyMr
	KQCWvxDGrSEKSUMqO9kAdval/qKQ/S8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Qo88Uxoh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790173980;
	b=BojRo/9+3OJDyvDFkltqj3aq0mIQhQx5iLR4Vu7WI9g7eWo625i4p7B4Jan6HWqk1YCvu0
	QR+/a27UTqewDNFgI7QCJzz6WW4kt5Q9r/EeMSsAwcL/XkcX2dhAeVzmpmXlvZd9YSqWci
	urguO5tHujz7Td9OwQUefpUly2AsfLQ=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8Zoov1031364;
	Wed, 23 Sep 2026 14:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dTLEWXxZ3/GILPnEIAr1GlznsBvHRZ
	fvHZ70H1KLoLk=; b=Qo88UxohcNN8SpbSKUBr5cDAuLy9wsUReWb22/yAD3VEna
	iaQcJhiJ3ARz3qC3Bza2bqx5LDMDY3fqjzGg0Y1Yx2giTnCYKV6/Cyu2YcD27Lb8
	7RH7xqSNuxuGmHMviyp3364SThNgSF6jUNmX098C6rfX20Qf3os2ILUO4Vgou2xl
	v7Wr2ATjzrYx1vDks3x+OSDJZPaJUXVM7pndrciNEZxmioJ7ayTFXMhN5SKtw07u
	948FpPzhD5Qot2aHLbq4T9CRmW9/W2c9sVRB2ECc3RENETXjqNal/kUkXqN/kr9d
	9mQLELOmeQ8FjtGJvU0+1CraPYger0G5Sdmm1Zgw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1uv8k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 14:32:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68NCLiiQ008504;
	Wed, 23 Sep 2026 14:32:53 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8jse13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Sep 2026 14:32:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68NEWntm16384288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Sep 2026 14:32:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9913020049;
	Wed, 23 Sep 2026 14:32:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28D3220040;
	Wed, 23 Sep 2026 14:32:49 +0000 (GMT)
Received: from osiris (unknown [9.111.16.152])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 23 Sep 2026 14:32:49 +0000 (GMT)
Date: Wed, 23 Sep 2026 16:32:47 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        Helge Deller <deller@gmx.de>, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] s390/mm: Drop all pxdp_get()
Message-ID: <20260923143247.9636Cf1-hca@linux.ibm.com>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
 <20260923043226.331880-2-anshuman.khandual@arm.com>
 <20260923091629.9636A36-hca@linux.ibm.com>
 <echvqvjj435meeh6gcrqewysdqbtkrsgayvsyfcr3q6h3bh7fn@hsa7xh22l4rj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <echvqvjj435meeh6gcrqewysdqbtkrsgayvsyfcr3q6h3bh7fn@hsa7xh22l4rj>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pB-ITqb9sOi216kpDP6qFr_AkUfA0YiO
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6ab3e316 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=s6_hAop9O4wJoUa2jvYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA1NiBTYWx0ZWRfX22wASEXzLiou
 PfFsvMfHjLR3w9yAsIv0VoV1k3rQ1tg1VGpyHFdoCSG77Z4UvPhFSm4mrr3cFl+H5R/R3beTz47
 rGtl+Y6RwJokrmDgrV2vhG9hrs2x4lI=
X-Proofpoint-GUID: wKSs8eQ0tSZ4i-GNyRYMRcD2K4LE2JQz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA1NiBTYWx0ZWRfXwHPABW50L+fB
 IloTBWxVRpe3zLFf6xTiqsudch9JpP0gjXsS4DmzoU/vzgS4sgktPxavXKEfcdW8kC7+6nhhNo0
 +ry4ndBZtugMek7C7B9frVH+AWPJcbCrAxzGdQl3Jyc5yxA6x2UhotqdvLyFzBr4VACaFOy1I8c
 Lxo46K1swYjr84QTmBRS23JSimQbO3FRlkEQAhanoWdL6LlrPUfg8oLM63o0TwU714EM+D5Y/ZE
 +Sin01SfRk6lvimzFutahVWSPeOECK2DnDfIX0mcx+i7unp47bpzcHK9JuNNcgxVVNq8Z7C+7IA
 Yj7wDw07WYlMCiuH4BDtliirABQ5Nkou11UoHxnH51CyrimCAS+nYS8cTtx7TAhRPeRuCho2tah
 JenhoBlym3Gro7kuMLcmkKAtppeSJ0VRp2PCMG0bXWI+NE03hKMTQdMHRmpGLKw5NialfhVw56n
 Vj0Qi3gQIrmLdBUVP9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230056
X-Rspam-User: 
X-Stat-Signature: mqww1srafkqk46o9beusb8e464hwmis3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0947120003
X-HE-Tag: 1790173979-392457
X-HE-Meta: U2FsdGVkX1+A8k6fGrxKtHVuPLc0Dpo+WF54n1dQ2xKfyGFba4xakXzJDAK4bFTBeLwO2pFlQSivmbVwjkCVRTU2iMYkKRz+EtIZ1a5oNNc1tyzgmxSfIPHTDV4eLYcaXX9BHuCGFPynEHa6myFf6+EyD9hbNDrSGZjelqIhP+FYHr7lfg45kaijVHLYQ1wCoJeMzQP6DaPgl6MrILA0NW/G4TyErxPpFFYZCbzmRhGLSWfwOkRiHePdTPxKTaKrjlnuBKi8Myr/LvI4N9DC7jxMM8Pq+JL58gSBBA0hM5FnGxRJMbdrxXwLx63k9aD62dGrbNRx4/JivsRvQVE2mVArU7KxbTMCczMtD9dLJP1l9JfB3IDmgBapFCfzq+mSCHuIIz9ZlXrVHDJwm/wRS23kpCOJhxCdHPdczRWYinKppkiiPLWBiPFU7q339L30CHlXqSVNge9w683XfUY9PXKjlL3TmDwIX7mKPdrskFSEJ+bSwn9pD7Lh7OvfRTwWvP7ooJxwRUYefzCIZhSPscORVUoz9B9P94Dc95KdYshYursGGINeEF1vuf9Ac7XYoUi+rMf5k+NGFO4JkJe1p3HsMAwhvkhdkpZNAwur3NbNcIEhvmRlVxkUHxhfdVLtHPUQdCvZaYU707DYGXbzWimdDwFgyggMIct5bqqZsAJzxgKzu9IK5yr3zrix48ZZrLyvRj2TCcKRlcZQME3A9G8XMXQlW2NHAksySsST+VmvxVLGzPfnfIZ32WXLrSGO33DGwSJZH15c/CETX1j6O9OqOaSFMTLdxzrmi+S+ojDXz5NGQih1s9UEaVkmvF/Ikxoa2i9cKP7WYnaG3fyRGl1984QzAI8KdRSbpRp6OSvUUqfkPaKQp7c1sjhus1jNibSXnhtwyLmv+x2qZbMRT7UEREL0uRK0/WwcOdQjO90xNwNaHeQvvcy1KlAXOJxQmN+hNBJUktlVL/pOLyb
 GalV1BUn
 7FoeHvbAPpBg3bwGQuLHMWKl3GPQ5JeZTKOXE23+Vm9Yr2naVI1f3quPBEj0lxFnxyPInVQP8eIIrO4IlkHnGDXkjf55VbFF1mEC54eI/r8V/vhX1jW2/Pe7elRH4oXImv167MZKUc69/EjC0y2DAAxuCxoO31xaqUgOhJs8TENQh7A8WQyrjjnN1Luhv/PG6cks8icf9PrkqlfYvk3o+g+tJKmbS7VYZcr9RzYCJOFVNtBhVhSJAIADzi7bEbtrraR1mB6NjhvSbAp5nNIpEhc7VPj+t1Wdvgin+ubEMYXcwoXVIBGG+c57R9gqA7xgBvelKAYcSzPATXByWWpjDgDp6l7i43OE6oyyqdpWLzeW/5oM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:42:00PM +0530, Anshuman Khandual wrote:
> On Wed, Sep 23, 2026 at 11:16:29AM +0200, Heiko Carstens wrote:
> > On Wed, Sep 23, 2026 at 10:02:20AM +0530, Anshuman Khandual wrote:
> > > +static inline pte_t ptep_get(const pte_t *ptep);
> > > +static inline pud_t pudp_get(const pud_t *pudp);
> > > +static inline p4d_t p4dp_get(const p4d_t *p4dp);
> > > +static inline pgd_t pgdp_get(const pgd_t *pgdp);
...
> > > -#define ptep_get ptep_get
> > > -static inline pte_t ptep_get(pte_t *ptep)
> > > -{
> > > -	return READ_ONCE(*ptep);
> > > -}
> > 
> > As reported by Sashiko, this results in a compile error due to conflicting
> > types; but I don't see too much value with this patch if a forward declaration
> > of the common code implementation needs to be added instead. Looks like s390
> > would be the only architecture which would have that.
> 
> We could move pxdp_get() caller functions from this header inside C files
> like other platform changes proposed here. Would that be better instead ?

That would make pud_clear() & friends real functions calls instead of being
inlined. Function calls are more expensive, so I would like to avoid that.

I would prefer to drop this patch.

