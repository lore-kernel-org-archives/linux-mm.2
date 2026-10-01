Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDD4CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719036B0088; Thu,  1 Oct 2026 11:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA196B0096; Thu,  1 Oct 2026 11:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B90B6B0098; Thu,  1 Oct 2026 11:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 368486B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:41:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D09014044C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:41:27 +0000 (UTC)
X-FDA: 85274471814.16.7DACC3E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54232C000E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:41:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="J/XJVuvs";
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGX5xiylu6dHWYVxafA3947xnzl0U+ZYQmbR8NulFzY=;
	b=JCtpHqE7PP46/Pe2NFQA5As/D6be0TobhlA2mXp4jpUniMKXT53Cn8jERvFW5FriK7AX7P
	LOX58cEaDBXr6rb9jaAnkt3FeoK4d4P14nH0nn+urftzb2aPsvv0IWZw0QpVAVr+5xE8R4
	wVKcoHjsAE+HIeUxBHX5f5X5iiX7foI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="J/XJVuvs";
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869285;
	b=fe8nX+jNyyDmtGQ1Y0waefi2XUPYpjbU/TFLg6EPtMoEuW5mUV7X+liKAmuB/+lFPa2Xu0
	A2hFC1j6ofryGjTnizGag/ZFo3I+deb6PP4nkdey5l0IMf+IWM2CPcen6QJ2Bm9HQb9YvY
	Uu2ipdhPOcb/4LG/rTgFVRbpp6L9U7M=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691Datlx651160;
	Thu, 1 Oct 2026 15:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=MGX5xiylu6dHWYVxafA3947xnzl0U+
	ZYQmbR8NulFzY=; b=J/XJVuvs6yL+Xf7XHPkbRrdcKkQiBdjNi1j7E//qkYY5im
	oVEEb/92jfIhgbgIqSlgNos0gGN3hBysB6a9WXlNofhC/ns2Jk/mMz9td1rOIpPo
	rWCii99jn4liKOaGp7xejeusjB9LG3wO1RS9OYqHADZlYnEw5u1cpVTlm6rg7rTZ
	jO9FDaujPKN+SUKsQ28YJe8g6V9t/0pnsyndxLtlZ4nmhHpAwGbWNpU0t/zZfSrr
	HHU98zra3Gy3xxpzhrBPliZ8fkGOz+x1kQTErxKwxE7u0OJ8lwYBV1I9tCjnr8t9
	z3064GVyIaKkS66Nv84PCEO9z4H2R2KRUKxrGisg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fejybd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 15:41:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 691E2hDg1000240;
	Thu, 1 Oct 2026 15:41:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcsem3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 15:41:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 691FfI9D12321128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 15:41:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C51782004E;
	Thu,  1 Oct 2026 15:41:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 627B72004D;
	Thu,  1 Oct 2026 15:41:18 +0000 (GMT)
Received: from osiris (unknown [9.111.57.16])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Oct 2026 15:41:18 +0000 (GMT)
Date: Thu, 1 Oct 2026 17:41:17 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20261001154117.23106Da3-hca@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <b66a61a4-a532-44ba-a1c6-26f02193fb05-agordeev@linux.ibm.com>
 <20261001082143.23106A21-hca@linux.ibm.com>
 <15c64970-d54e-4b8f-96f6-50c021079a94-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15c64970-d54e-4b8f-96f6-50c021079a94-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6abe7f23 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=RQ3G99v50yCnU2VXwHMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA2MiBTYWx0ZWRfX2z+LpBAEyxRt
 Kx/W8UWE7w2jOo30Q+6cHpEdD8uZAmx0VaxLB+mtqsnFJyO2ezeEbXoKplI2RbU/Ptc0LLSOnPe
 /WSGK4CzGEe0dS+Cl+hxbRUsl8VVTvQ=
X-Proofpoint-ORIG-GUID: Z6UFw9oTZ0wEx_TlcRHvUidj7D5SDPbL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA2MiBTYWx0ZWRfXx7MDApKeGV58
 0BP7hn3rjnPlt/0FlyxvAXksOL8xH31JqwCL3UWGp/IIYm5vva+6MvbqZMUgt5hj9hmvqbTam6o
 PRhMR7Em+qwReoUjsf9DsqvO52ouGFG8whQMJR60fDxX3ZQO5FLwX9H5Dpe6sR3QFF/aDzjJFt0
 drkfpq4Jgek9aeOz9h8iqP1H2TspssKiGVk0ngl+j+npyqu19IFHPiNHC/BPS+8Q6Ty7WcNTo3N
 tJz3yIkWyy8fcKr720w1fcygPPv5LyZa1xEHAnK+MZhdxQDpFvZm85cRdE216NtmapkrM7bDFqH
 LvK8INARMyax5cbwHzESfRzjtSBWJr95nCCH4OF8cLFPWKvH5zFlFBH9bUf99NjMLyYOswZUERg
 jB1Mi63JIhadfEXZFq6PxbAYU4L3NYvuEw/vE8KE5a38u7YftU4+3PJcHKNCx4mG+PjsL7ikWkr
 5p6UhgIOBc64wtu3Stg==
X-Proofpoint-GUID: _qdtfAZ6gAzJ0RjX8Ic6qXL6aF2Zt8nE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010062
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54232C000E
X-Rspam-User: 
X-Stat-Signature: tk6sm4hrbtachb4djhtrqwz9ngiacabx
X-HE-Tag: 1790869285-697406
X-HE-Meta: U2FsdGVkX19JWB9DS6sX6b0p9mFVxKC3k32absBLaSyB0QdRJ8adtYkYfITNUzOQbiCYbYCcHr4ag8UQxsZYq2cohWMVh6YL/+J65cxQUFzON3EAhyscGYDoaHt4Nw6R2krYHKf/ZRzmO7Jmp4EFqR+TJlndrsFsOTqk0GBkjatfQzBgLd8JorSuE9jo9bpG4mt7oAQWtlFeqmAc5+GtuoqkFUqpoLnMaEQsB2BjqiDmAJTod+ThZBYV0fkXrSt3Rj/ndAYqj5VjTrriF05y/Hl9b8IvADNPZAH9dllpMhwUsiNm+jnhjCmiAyGZooEgAFrFD4XZqGRLLl/YRIdvMB65yI7gnBegqyAa98oMWqiNKh/U8Lu0X2z/TH4Sy1815FECMneGb9mukdVrZViBhboxc5q/OMiTCVKQXfMtxTNoDMBkqyp73YtLeSWnrjh9z0ASU0f94K0L1JX6Y8ptjJGHKSA8bBJ+1gFGi47OBuOj0RWqo8HS/njmKy0GXvX6VHC2DhLDDy6k7VQuxSsDGaYhvRyBk+/t1RaFCy8e1Ss4I+z46xjvZjtjzTXG4skbrLDq4pWXasM5FUTZvOkrDo8u18WjQoaxdtUVgbzmhLrEaAv6T9ZDrTXd3SpcEaJG6Fbrj122nOTdx49f9qRrKZxSepo+Gnj5z21AUJxDa3J4d3rnJioIumwXbHhuJ/9BNZz45mt51EtiynEjfNNtaIQHfRF/MQaTycMsauBMrG24boJkAlxlhHjrG5+oQYZEiI/xyJHGQJtHdbHw1dHEu614ZzTX7KDTDQMKI5XrNmZw1pmWM4RURLSao+GPipPFgKN3c61G7wCZ1kUTvGLi7l3b4Q51qfR5Yqv/imjX+HlF/LP0aLnw4VBEeqEycBDzM6MlC9dcQSo8+/l6Hz+EGlhan6j8NYVqBZwx2pF60BoLfrQTrsGBvgcqq1Z+58ygKeGocIcCCUJXzggDcBk
 taYj2ZSA
 AMkM8f1dt4nYku0zi1pNuMHWaj5ssZIl6wVj1sA9aVA0zE358VcYvebKMxIOMb3JrBgRXyhumI+rYPbLdObBpHipfq9bp7gdoBEUJ7BCtsR1LspH1+Hk31Dd5HbW5OLeSo5rc5rJN/YaNTnb1F0i6cJj1OGmng+S5s+tpWp3rHpL1HH+cEwq7evzqK2QDcruDiQvWZ3vp8cdN935I6LO2jgGN6cpv7Eo0AQuvaE2m+C9F9i+oMwf4NFGZbv2X2ChtotlF2Ye9MebpEKy0T6vvvkoYGqVU6aQ9kcrnTei50+tmwJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:20:17AM +0200, Alexander Gordeev wrote:
> On Thu, Oct 01, 2026 at 10:21:43AM +0200, Heiko Carstens wrote:
> > On Thu, Oct 01, 2026 at 10:00:55AM +0200, Alexander Gordeev wrote:
> > > On Mon, Aug 24, 2026 at 12:40:48PM +0200, Heiko Carstens wrote:
> > Not really. But why is lazy_mmu_count 32 bit? Do you expect a nesting
> > level of 2^32? :) If you would reduce that to one byte you could use
> > tmy or cliy.
> 
> Good point. But still, do you think it worth dropping the KASAN check?

KASAN check for lowcore? I don't think we care - this is initialized to zero
anyway, so what could go wrong? Also given how frequently these operations are
used, yes, please drop KASAN checks.

