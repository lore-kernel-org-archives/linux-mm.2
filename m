Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3FCCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D526E6B0088; Thu,  1 Oct 2026 05:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D037B6B008A; Thu,  1 Oct 2026 05:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1A76B0093; Thu,  1 Oct 2026 05:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 891246B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:20:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E782DC0378
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:20:29 +0000 (UTC)
X-FDA: 85273511778.27.2B7DB62
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 86C2240006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:20:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gdJINpHS;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790846427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/U7PAdAYYE1tCfg1LWT8pYORgWUBC3Qp6JlrsNLO14Q=;
	b=axBPpJgWeKax2xNJlmGyDh/26RKKSO2m/MQT0RdZKDShK80doMrcmaoPN4pRWm1+hArlSI
	2/9qsBqvGBsJ5op7g7wjuZoNc6DVXQLh+FjS7IqI+adjBpuzDMXbEH2F+w3i8Q2/KPhLx1
	J10qPEAsNmHW8BQx5TDthFBlLCkaGlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790846427;
	b=G66gz2VhyTO15C2qb4f8jraD9g5xKgUAxYJ+kG5atme5fcjmqRhVhmeA/vSXuyS2lgtQpy
	W1bL2nAy4HJ3JxPYITlXxVQ1dEj4J6pEgm2Y0KK6JfFqr6DmrK+nXp/tm0DO1xocH/C9rU
	fMeu42UIW7geTkuBRYJ9dQOdqC4Au98=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gdJINpHS;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69175Nqh1085937;
	Thu, 1 Oct 2026 09:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/U7PAdAYYE1tCfg1LWT8pYORgWUBC3
	Qp6JlrsNLO14Q=; b=gdJINpHSnQ6Vod5hUJRs/vR56qTx/JZZgxqnfVMFkzRS3R
	r8alf1/A0UvQQBIn5f3nWQ/Llh3W50gxTAz8AKzeLEUy748BKfXA/Gtz76RRozQI
	/9ejpUyB8ZUKzg2ISsVisnHlaXxRARVwgCR+47Ofej+TXcnj0H2PMU09uwckNC/E
	PZ/ktBYUYV8Id4bcIYBMSR6Rfw50gPle39Y5LcYUUIka53+b3LrxO9hqmU4/b9SD
	JXs+cmWHd43xB0e9kkiH6c1QnoFyFOI71tC2SaQuyDvD/MDbSei10h6INlxRbvKO
	eHdQrIAfU2ozQ46GH7LXKDJgL8mQzEMozqocM/LA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5s5j986-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 09:20:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6917HqFF545802;
	Thu, 1 Oct 2026 09:20:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcsd801-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 09:20:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6919KJnJ45023600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 09:20:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 666AE2004D;
	Thu,  1 Oct 2026 09:20:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0488C20065;
	Thu,  1 Oct 2026 09:20:19 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.54.207])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Oct 2026 09:20:18 +0000 (GMT)
Date: Thu, 1 Oct 2026 11:20:17 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <15c64970-d54e-4b8f-96f6-50c021079a94-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <b66a61a4-a532-44ba-a1c6-26f02193fb05-agordeev@linux.ibm.com>
 <20261001082143.23106A21-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001082143.23106A21-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNiBTYWx0ZWRfXyXw3T5h0GlUw
 mQv54xvwV2kNS4Bglyn0SaRfbANUc+FQUcfWVGeW/1h5tBDQ3pBgzN33vqcceE/EBsJNPMctyab
 y7xoxADYS/kTks5aIDFit8DqoZd6iZw=
X-Authority-Analysis: v=2.4 cv=HJ5WhYtv c=1 sm=1 tr=0 ts=6abe25d9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=c9BTM6wM6yW0X3cp0v8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: uwGReYwd5a8785TSxr4_gRawb7bMaKQz
X-Proofpoint-ORIG-GUID: ow73LtbKnqceLk8VG9Es6Mkw14u5-y5L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNiBTYWx0ZWRfX+WBvBRTaxLOF
 uLiBPaOdGS7YJmDITVp65n048VbpZHAQpzqV8vqOyQNr9wzoPccYK5E1bQ1TZXuaKTcr7GRXZXe
 /OLan6+DOMcBAlKeW3hYBs1GqjP+UtLpqYoeC1JJY14mqcwEuFJSLKvuEMKxZVzUgxGbGegrKS6
 JhFwPiJfpYQolXHcZiPOyz6qK3DghdKb1gmsosWG6QtNAiJVuAld0ma+5ivEGtino7NhhY1u2sL
 TuHB8SNYOcXC9az9duOfAfan6MMqAvn8pe90vPmLPVEfjLQbvpmBLwD0pL35otQnwO46syL3b1y
 bFLbD5lJmq1uHUpu4OgkZJm1Hnp9W7J7oQi1wMX9tS7QXvvdpkBhtQF0RJvVW6sdOhn1GPPPJVy
 FbUwJ41is0jLM4G7LgdeAF5hXVm9S/eGpdW/25vori50P8LZBN3Rq4h1ajnNg2YTKbDtZ9+w37x
 AkDRsv7bsACmb2xxMcA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010036
X-Rspam-User: 
X-Stat-Signature: n5g76jdwdz83qbmuxpy616ocnt35cu6s
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86C2240006
X-HE-Tag: 1790846427-230987
X-HE-Meta: U2FsdGVkX1+eumssgNOElB/iO0c9nK5Lh9Dhh2qe68WdSwVLsENe3cp3JkFIKoEvJVjEt1R7X5w7CaqSXJwCNutfpawnCNtB1HryxY2WVj6sK10v0/UCIJlJUVZRz312aHDR+laUQU5lWoIlxKKdFLmKiyCg89pjelEevte4Wo6r3rvNK3qZ7ygpcwtR/36PDOKq+T9CXkUIynBk/jApTOxJ/iiksiPdWVtp6m+uNDGufftcRs+cexRRo3eWhUUQgvcDNia8xxOemV2Ey7VnRYYmC6crvxfN0eFwvOHwZ57b+MviHON3SM8UL9khpa+0AEVyrM+51f10F/jtDPMs2Qul+f4fLE+/0RbZwxDp6mZkbEosczZTEKneOiOGWEpAdWGkYfZFIeuB9fqmUfxzZS/jnScj9hpNZrPldKe+I5geYKsl5D0ntbt28e7ClfwoxF/Cuv0hvPgJm5iLqvbnr6dSHJG5nt+Twg0vta0sAXqh2spzpUTE5M+sNQ8mfkh4AIMsnHndz6RjC4w9rKCPlLA3uM9He8ExHKEBYoLhBSKbwS4mvIDZJnY2L3/lNGdPEUJZvJZ1VLPYuhgm4BJcxTc2hrmcBuMXwxCKOUuE+fb5PP/GJT9+hwaBvjUMPv65YyVQlh3VS385kTANMRi1UZtnMQOcPhmm5jaujhmM625xI5XxRIljawEv4vFCiXkuTVYHk+BXE2SQMCBsAOznwuy6guBJIlLrznCcov0RCUH0nt9qdCC2s4Fwd+U30IsDN8CArdL2JhRC3Vv0gVX/Q5eVZOhTskmSPs1/CUm/jWUtC8fILnAmGEFLj/+g6BdHo4ENSS7upj/VXRoaYV05Qy8wrB3J83BL9R+oXZvzKtWZZI4DTPo2jgPki1eRicuPsgbVXtZ7TMwV+VyRBSmaleIl5BTPHZ3CZEmZlTptpth50WY+TlYUA+xnvH35g3jY7azleWec/Iqt7jI0hPD
 fJylTE+C
 Xl5K9IrfMKVWTKe/FWCXLAT1JS0//wN6UmCHs6UrenO/CjnVBEy1Z/0VhhJA2hdU3OCLojHAMaHXeIsrMx+ND7a+/L2cdMut8zD8k+1nGFFo1pgK2GqMoZnI2nfh0zBk8J9Xrf2D8QunWt9lwVaZJiLMk68eKkkSY+TyLEaLRBGJcagvkpSnQmk5VRCiKis/+qvCWYZOjIHLC08GKrm5l6tThCpA+s35BaVkJvBui7TV/lU6DTvPf7meAphiX2Ugy2iIPva2YiTvy+rlOY+1hnt7O8KYBx1ARGE0NIQj6UEa8n20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 10:21:43AM +0200, Heiko Carstens wrote:
> On Thu, Oct 01, 2026 at 10:00:55AM +0200, Alexander Gordeev wrote:
> > On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> > > > +static __always_inline bool is_lazy_mmu_active(void)
> > > > +{
> > > > +	if (__is_defined(__DECOMPRESSOR))
> > > > +		return false;
> > > > +	if (!get_lowcore()->lazy_mmu_count)
> > > > +		return false;
> > > 
> > > I guess there is opportunity to generate better code here using an
> > > alternative and using a flag output constraint too.
> > 
> > It is only CY and LT instructions that make sense for me.
> > Here is what I came up with:
> 
> ...
> 
> > As result instead of gcc code:
> > 
> > 	lghi	%r8,0
> > 	lt	%r1,1032(%r8)
> > 	je	...
> > 
> > We get more or less the same:
> > 
> > 	lhi	%r1,0
> > 	cy	%r1,1032
> > 	jne	...
> > 
> > The only benefit is [zero] "d" (0) could sometimes avoid LHI if a
> > zeroed register is already around. But also the KASAN coverage is
> > not generated.
> > 
> > Does it make sense to go ahead whith the alternative?
> 
> Not really. But why is lazy_mmu_count 32 bit? Do you expect a nesting
> level of 2^32? :) If you would reduce that to one byte you could use
> tmy or cliy.

Good point. But still, do you think it worth dropping the KASAN check?

