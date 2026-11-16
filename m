Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6913D606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=fGLJmdhL
Received: by kanga.kvack.org (Postfix)
	id 8D3B66B05B4; Mon, 16 Nov 2026 08:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8842F6B05B5; Mon, 16 Nov 2026 08:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772516B05B7; Mon, 16 Nov 2026 08:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54F976B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E33701602F4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:14:36 +0000 (UTC)
X-FDA: 85441026552.03.13F1959
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9A0CA1C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:14:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fGLJmdhL;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwIQSjAgmrohgv46z/uvziUsW9H4Stxc5qYNQgZcgNk=;
	b=LKtLWsslUSDkbOqpo+6SMxIlqFjf91mDLCNk7u2vKDSl3IdMHj9CmpvTReghE4hyrtBHCk
	75oJY1lcq5+NTHYfETbWsrgmgCsEpBwn8rR7qLMXHg07kNDxJOYevowvn7f1ral3Uvj9/m
	1ub/LsqRilFZNWfeinQXNmzab5uGojo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834874;
	b=gP56jDQpUnmiTPCwFkqQxQpaR4Xb3U6i4bdH4u9hOtUNCCgxDNKs4D8Vqmb8cemvidMsl0
	BwB4AlgysIcB9Bi28eFPkc8WQ5pEo6VAf54Ys+dyeV3HV4jF35t7VR21uVvxMbULXw7Os/
	+dEKuOpUN3/fqj6rqkFKx7n4URVi14k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fGLJmdhL;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGCQfFg3275085;
	Mon, 16 Nov 2026 13:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gwIQSjAgmrohgv46z/uvziUsW9H4St
	xc5qYNQgZcgNk=; b=fGLJmdhLILhwAIv4j8i51rvXGG8/eNzt9gb93j6mBTEBbK
	dr9zZwCv97T24dtHfM94xREcX3+aKPtP9wSwXF/RYEST0kL9alvROR9BqBppnl2Y
	Py6UWAzCCe5zgTmACEfSlOuFom0WVAq0fL2J+2zoDhUx4iXRrz7Dzi8PimlS+Svh
	gHVNxQgX+q3r/BIU3cHCylHp/XuPky7P0WrxmMnbd+jUbUb1JZOe3bVzAsNbNdb5
	Dyyl5/rvqQilCiW9rcTmmI51JcDDV9ZnKPJ9qoFDrlAyABySxPGxSLQd6x+ldlq1
	HxQWGbI+qVQp/wefAgW7nIJgXo3XryHybMDuJgBQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxfc4wug8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:14:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGD54Wj3095317;
	Mon, 16 Nov 2026 13:14:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j02df81mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 13:14:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGDEEMA49152358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 13:14:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E00912004D;
	Mon, 16 Nov 2026 13:14:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DB6E20040;
	Mon, 16 Nov 2026 13:14:14 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 13:14:14 +0000 (GMT)
Date: Mon, 16 Nov 2026 14:14:13 +0100
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
Subject: Re: [PATCH 3/5] s390/vmlogrdr: Replace get_zeroed_page() with
 kzalloc()
Message-ID: <20261116131413.125125Dde-hca@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-3-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-char-ready-v1-3-3db507722530@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX/fdih8WgGQhG
 jOfi1MqUMuov2gWwbK6kHEo1VECgIxQr/XcfWHx7F+iYkp/ZcD6+qo+/K+f4hduQxMveDwFO/Od
 pd4SN3RQsxuQAWykn98iUX6Y0VKF3O0=
X-Authority-Analysis: v=2.4 cv=Fu6QbGrq c=1 sm=1 tr=0 ts=6afb01b6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=ZkP2uM1e78bCdjAPzXEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA1MSBTYWx0ZWRfX5VTGSNFez0bq
 CqFE6XiJsS626wCkBj54n+CH4i1Wn/jwkptv34rleICn9aU6pJ6z6KG4JDAXe1i9en4tcoH0kZi
 N9t20LnzVMlWFtgBkqEjzgdNPU0JZC25wlp215SB6r3C+zWAOBoO0xOSbIiP9bxsWXOE5yVh9dL
 Cz9ks/z3qGUOL3uQn/lHIDzgLJq+cUjqhgxPIfhkMkM5YWHI9j9V+JWRNXXvDp6Mep24zZ1aWLT
 1waDNoRaLEHXv3mFaaMJKxM71UezXWpymL9Q+KCW5DHtHXQ32IJcnLcHvWQm7gW3J/lovL85fo9
 IXr1Q57zK45cIH5TNvKrv48C8b76aucMxBptmsynfz7Ad9AE/1YAuzyFFFAnuE6bXDTvShySVt2
 yr+9+7nkvXT2wZK5zTh/h8w2g2SUQK5pMJx1GWMVb1/++UM5eXEuWLntJud/8p6SXBqoRwRv5u5
 BLQAhSldzw00Kx3DMGw==
X-Proofpoint-GUID: -Drmaw-J5hcCDtW7D2vEHl2U39VrLlau
X-Proofpoint-ORIG-GUID: -Drmaw-J5hcCDtW7D2vEHl2U39VrLlau
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160051
X-Stat-Signature: 7xdu3x3cjwfzx9b87ayyn3banof1r5a9
X-Rspamd-Queue-Id: 9A0CA1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794834874-544580
X-HE-Meta: U2FsdGVkX1+X1blXTxU/sOPYxDA6Ku9324hGIpnqMNETOssgrwXeVg7a3xaLPpFQNvUxOiJ9q8jDDe+IsCr11GqEaIzZOJY/s2eiCq7e70kU9LBId22JQ5L3ztm4mTssfk/iyGtfcU14WRXuVgWlDfmH9UTDnt44umaqbH9VfZ5FkpGzFkMdb19X85QDWpD/rCTAUDkpq32M0XR7HK5TQbx+3VL4B4+f1ZSXMKl0sTmgF94YB36+nNe1ZLKfWQsDn0zxKrrddaHGPKs2+B4aI+IEAJWvS8rPndbWbxCfJKND40aoWXboTj6GTyGKXagiObYHBQjmMZAfFAp5qTnGDexpUpMBI3zmS/ekO1SXLkPSaPRQMW8ZcR19FytmJMmD5p43k4WEV04J9rFXUzIZE0FPKEbeeu2b66Ymv08NY+kUKbZ34n8eukGNlz0nCtD0tlMvkeo5aYzV2Uq6qx9ADtBUTt7391BIj+bnZC4R7ecMSFw77XHeqF1xKHw2W0BZKLORPPbR+byPIbhbyawCmvDIAZ4pQW+v3ePnMd8eqk+tuqEF4W3W61og5JOgeJd33trUVY9E/5JVgo44LWmxOelP5My9DzRWQCRkVhcGIT0Fk20kjCvVnSMPQb+sbTfALbv6LtVfjKasE27pS++f56QPJTwsNhGOp03cLYbUOBRxtXcEdgwCt8IMunbuMsN1KE77byrjqxfCHBZs1i42ikUUr1s4AcgvQdrKsp4MITp43Lu3xrRAkz4v6ayKNbtd+rkYpAyJtKG/e0Zp9rXXZ7MFJD/QIVnT10QqlOtEbbWK/+FGZeKeqrmORZq902aJeyLjhn5zZnylLzRcy4N+/+nbAeWySNxDtw2QzgMmhvss8l8yZ9IGG7UjZxWzHmAcLyWbk1Nmqj3OzrKY+twQn/RmkYUl2E6XxjLCxufD7ZV1Mr/CNWobn7nopm4Hv3GKDYGK32XphMFcdIYfxab
 8GoUL1Lw
 gYnfyDPflCg2ILroF5ixooyNSaV0qmKgQ7l2/brpAs+hMYcRdbhexSHbq9toRuxEBItuoC53RdHrLKWPoLKxOvc4NjjSTGgVFXBPFeIA9sCpfWMBmfNvvdBIjlDtEPiUiwJ6UE2zZiOQGZCM9/H/k1EjnO5ZsRm9amW6e5lp/xsUcit0RKfQZDl0rsRM/S1Wrblypv7/mMgTeCG3mVW1bNQQfBsFuD20jOhKeqb8EJma1d/zN6cxzfEMhmEArmQwrcd4tTL8PK13CAXX9kY0ImP8CF42bgiUuhfopACkyUBdYVhthu2j9wfTJrjmJPHxOV9HZ3uXgd7iJcCPflMPQeZ3NSYwvY2XR8Vyz0s+Qnbs7hE3YGMAe/bJy/TG062trPvEMKprckjdrKxLmoNl0sh0pP+D///T/Hj4vvRZpbWn4weT4b9/MPG6uzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:49:00AM +0200, Mike Rapoport (Microsoft) wrote:
> vmlogrdr_init() allocates the buffers used to receive z/VM system
> service records via IUCV.
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
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/s390/char/vmlogrdr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

