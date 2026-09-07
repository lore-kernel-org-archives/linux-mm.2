Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632ACC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDF76B009F; Mon,  7 Sep 2026 09:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F316B00A0; Mon,  7 Sep 2026 09:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4886E6B00A2; Mon,  7 Sep 2026 09:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1736B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:51:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA419C018F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:51:27 +0000 (UTC)
X-FDA: 85187103414.08.5D2EAF5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id 361FEC0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:51:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dbBKbIwZ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrctOc7+0ilqyZJzn0TSyruuoBDDl/zEMcp3J+ITiSY=;
	b=c3+V8CYelWkRgxUE/h5JfY41pGuwVwJOh4AbtubD/Jw9mpzgK0uT/aaBPhAcTOAfN5KW5b
	rRCf2eILvrNaWpMpOHApObK6Y3hhFKkY6MqN8ypj9Fz394V/WPGXkZlWiAcR/kOwWc7AiJ
	qIbcIb38YzFrzECWoyF9LHzsn9qzd3o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dbBKbIwZ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789085;
	b=sE8vCza9ZPl0RphIvjehAynZasaAIjZ3IqItibXI9F5QrRdQ3PdhNEQpdMQxHCFDwcGdxt
	KuYo90jgTZmmoBC8QvQdB4BK2Y1wLSP8uBYWuhWbZX4Dd815p9yCnqgeKRmmuEI5BlYU7E
	K8BbX4M2BaEYjTHemf4RcfbAJ03t4Kk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687B1aFZ1784880;
	Mon, 7 Sep 2026 13:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BrctOc
	7+0ilqyZJzn0TSyruuoBDDl/zEMcp3J+ITiSY=; b=dbBKbIwZ9oOMAvGKkqzu/5
	FKT+9v8bJnP7/nTIBM2GYUHkMca+CDHJffJlLQKMJYwkq58HTowGlIOJYxmy9uwi
	uZT6KcIQo1LLO9DDJFj/J11WlvE/LrORpE+5Rcqh3JOkbFO7fI3OFOEK+fYEg1MO
	7RBP51zJ4Zy57aLNKq1O0cJvgtWbn52rtsy/ThBmG11vDByZftmN/HvsBJoF5oCc
	/br2nYiiK3Cjn/bOy2iMU+23IcLiXTcuY9XeWkV8f2CZI4zR9vXQPGhkmyZzriCY
	mL9K+z3ZFbN6VyZw2QUDNWmTVSvWuzv5waw8FUMGryBXdUxwiiu3bq3Dx4XiAD4w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbf3s2q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 13:51:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 687DfheT022568;
	Mon, 7 Sep 2026 13:51:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03y61nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 13:51:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 687DpIef51183992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 13:51:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE9AF2004B;
	Mon,  7 Sep 2026 13:51:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8436920040;
	Mon,  7 Sep 2026 13:51:17 +0000 (GMT)
Received: from [9.87.132.113] (unknown [9.87.132.113])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 13:51:17 +0000 (GMT)
Message-ID: <56795c4f-150c-4a3f-abcf-b3ebed57db33@linux.ibm.com>
Date: Mon, 7 Sep 2026 15:51:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: s390: Replace get_zeroed_page() with
 kzalloc() for the STSI buffer
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
 <20260906-s390-kvm-v2-2-2cf6434e6646@kernel.org>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20260906-s390-kvm-v2-2-2cf6434e6646@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZDWVVP6yHtSLSEWBsTZ3gEZPeowrzNea
X-Proofpoint-GUID: ZDWVVP6yHtSLSEWBsTZ3gEZPeowrzNea
X-Authority-Analysis: v=2.4 cv=DbEnbPtW c=1 sm=1 tr=0 ts=6a9ec15a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=kt7I_EveaTZZBW9BUTwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE1MCBTYWx0ZWRfX646L0GIIOxn5
 HOOKjmtg+QPcdfls8oZ8j1cPhzXy4LrcVTdDBeke9cVenMqhoY0x+LIlxmTvufAwDBDsQq7sCS7
 PEdWqmy0KUgU4HuIOzGdR/k9KOCNPu+GzN8jiLjtwLcAtWkLc/CZu5fRubnwTmBQOILuEeLmLuh
 suifWLvYh2g0zj818Klpv0j77XB144j714ZNlpQzojWZQCcVFkovbkMpCF1KTTAvotsNT+eIU6R
 sXAHivL1BDUmGEXhOx6qhFQTqToHquXFO5FvNBRHfaUqiUMFZMKv6wJc74kT+oCiWgUAsc6uNRs
 6ug3LS1EvBIr2yA+6/drAKXAk4bqm1WsW8IUNvuAMVD2lLH0zj89QZkBM630JpQjhZ++567YHPs
 u/mP2Na468nNMZjSddHiqI6sda9m7VaK+OV6BHoMXj8PgpWs/IzJAfNQXvqzayvqfqPsd1AaeVX
 60AY/PXn5cl98Yz3hMQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE1MCBTYWx0ZWRfX5O5TpneUjsv5
 ktf6C9fVax/BRL/ymZn63RVFN1XUFiCxF5QEyvpJvpmSlusVCsRcV3aTIcfwSDgLY/CYREOcu9T
 pwTZuKPJrpCopaqRCi5DM9JyBfJxazg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070150
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 361FEC0004
X-Stat-Signature: td8agpkibmxoc1b56icfdz9o3dd78qhe
X-Rspam-User: 
X-HE-Tag: 1788789084-631008
X-HE-Meta: U2FsdGVkX19hPp1433svoCdgrpKRJKH+TysqaUtvlPXm0jxaWAoZv8jFPMVkbaVH4A50vGcCKMKMZ2N0zn9as5wub5Wn3UT2kRLqpz474lqnuXN6/5xhZtdm6aCPHLqpqyA7SZ1Bil4+u5HDDLd96fEyqTdRDB0SvZ6ot+P2Dn7Lei32Wl0nYCPd1Z1/lykMFeMIKyrwALYPnjqYDvt7FcWSYPyA9nVddJnus78rcR8j4DCMs9KeafpGdJIoF1Pt9y8KmYrBmcPfI0k7ouuQYh7oRbMv+8zMjOpGcMdzNe7orWm4vSLgG21bVVrRnwg0oeweH2qIGFncRpby47L/hnRBl21Ny3TjUJQzq7h3lcIZXTq8fuj98V64TorwY1o+PavRcglK42blJUM/Mlq3AkcGZ3GlrWrIeQ+/aidSk2Fm79RCLvd9UtR4n5GsrMBwJtAMzcH5smYIu26OyAgzBHnelAxTNwFpVs4EcfAgWpj8gp+ip4Q9sw/hz+X/B8N+gN97xrwYMM4/J/lBspOBTOAdXtNqYMiDJ0WQBh1sHn5EdS2J3WYnWaeD42ySkw8mEl0hDLh7sOw6bejGIK1C0Jc1nRmZDbCI2tkYfU+hmvaoxr7O//UUMnw1lA5lbU3ZpudSeNsqFUnn2z9IbmMKU5Tzq4ILBdMuoDT8dDtODuaewL1Bwxbz0G+u1r2wb6pU8vA8689gbeMDCduhQiqaJNR9/1hNq4c33H6+mIqYOjkqukurkN3v2CQLOGDgiMsUp0X7FO2lO1BClkxv1muBCqAE4/F4LnUYeiElSkuV+YsiDA4I9i+dlhMYC6wYgq7zYBE1BMCGT28d0Tbwd5ffxq/B8TD7ZfgjwbavlpeVQdlFlRXjJWiu4wCdnzei+U6gHAtNqaEts1F7fiQGLc1k6i1kYq5y+k4PGDFafTDH0F9CLeFgdXInuU6lAz4nbd3XsiKBnMleWVTmCqjIGlr
 XsnqNYi0
 lTcF6O4wPdndEXkcHdDKY73uLkg/qNnghcj65MFGd+QI703R9myhDj4OfrdU1uD3Tet/ZGVK3vLIqzRHQCmZNvfrBpqlXOIftxhSna19bdrUP7pAvAOD+0nN27aEra6Si5PICsIWhAyY7tCALYiZc4ouc/EEQAaHjV0p5PWwIdJU3E4tA1dBoyJOi2TQDHb8ORyg7f+33EzqO/ij/bDZXmlpQzx0WSfPNdeyQRBszRIxnm2V7MoueUX1gOWVzwtphL5y74HdRnM2wMP6SVEqV4mhYYSEBRcklc6S6Bd4pWA9FDhLx4HOeW0D8SsNyo8glUMwLqsDgc7qLBfDH2QJ/GTNyisdgefHA3Fxvuh28mcgQj/zAan/2SblxVIkYQOLznDArRwFtZyqjh2B1z8khbpp3FTLogqt7fAB966+BfgUPej5ufdPoPj0oMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/6/26 10:27 AM, Mike Rapoport (Microsoft) wrote:
> handle_stsi() allocates the buffer that receives the STSI response block
> before it is copied to the guest.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
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
> While on it, make the buffer a void pointer to get rid of the casts.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Assisted-by: copilot:claude-opus
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

