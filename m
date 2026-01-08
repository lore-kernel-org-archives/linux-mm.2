Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7452D185EC
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 12:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571FE6B0089; Thu,  8 Jan 2026 07:44:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5492D6B0092; Thu,  8 Jan 2026 07:44:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455236B0093; Thu,  8 Jan 2026 07:44:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32B526B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:44:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD491140742
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:44:26 +0000 (UTC)
X-FDA: 84308764932.09.2C9CE83
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49DF620005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:44:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=szXkVgaJ;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767876264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO9RhkJfRrBy0KFDCPKSWz7gbxvz8W6rw1U5xypFvT8=;
	b=syj1xt8puPS4Mf29volf5UAptqtw+BFTlQoFK+jkFxGENLpj2LzOG3Ix5j8qgDdGLzZBX6
	KIZjKXpZovRln4kLx9mEeWrJlFfzTnrMjISo93O+OzWi5XL5Xe+xHpsIT4RmfrkJFxsS6X
	7rkSRvoeCsJiC/vbZJFfmzGMIJKtYsE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=szXkVgaJ;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767876264; a=rsa-sha256;
	cv=none;
	b=yEELiMOIz7xhERxa1OyH7b6xFpYP6cEmdGliV0RkPiBwzePl034ZC8hof9KjAwlQ9X6Eco
	HJ4wIMNZW9Sm9PvqLU9ubFAns61v7P3mz9w9+xh57kHeEnahg0okmbXdLLNBxhCXt+YZLT
	p+P6V9e986f80YAIG7DSrBnCim938pY=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608BD9H7025924;
	Thu, 8 Jan 2026 12:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DO9Rhk
	JfRrBy0KFDCPKSWz7gbxvz8W6rw1U5xypFvT8=; b=szXkVgaJehrVHgPnN8quZ4
	zU67/1q3WpMjr5sOqXtH6EFMK24bIGr3W6PZpbjjmwgm+bBblyo/Ys7fsNpItKXi
	9Snjr1eqlRb1bpucXwZGQqjqpJftadWpr8Mp3DIeeKqIKA8tak6V2OF5UpPtXr7G
	YOnIKDCnERVoHXnaXbk4ivLcosEHrLgBEbSWYFqGFRtcJ1PmliyQ3tyX0vUu70na
	XgJKPiXQ3njfj2ZSSpN/Ut4B6fdbVDW6cZDyDzX8inhITWofLokWt91bBiyIHxFp
	FEl0WqDZEH2F53wt/jQ0MDs+CqqsnwIGz28mBD5xftevJwBglWtcCxEauiejjfQg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtvu4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 12:44:10 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608CdjBW025054;
	Thu, 8 Jan 2026 12:44:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betrtvu4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 12:44:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6089bmqu005274;
	Thu, 8 Jan 2026 12:44:09 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bfexkeqva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 12:44:09 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 608Chp2Q25625136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jan 2026 12:43:51 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6CCB5804E;
	Thu,  8 Jan 2026 12:44:08 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CC895803F;
	Thu,  8 Jan 2026 12:44:04 +0000 (GMT)
Received: from [9.109.215.183] (unknown [9.109.215.183])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Jan 2026 12:44:04 +0000 (GMT)
Message-ID: <761533a9-b188-43b1-a24a-1893622ce18c@linux.ibm.com>
Date: Thu, 8 Jan 2026 18:14:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm/vmscan: balance demotion allocation in
 alloc_demote_folio()
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-kernel@vger.kernel.org
References: <20260107072814.2324646-1-bingjiao@google.com>
 <20260107072814.2324646-2-bingjiao@google.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260107072814.2324646-2-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=695fa69a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=v-T96_DwwMI9amIM06cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xjSF7wFzemsYW_pJWt3jf6tgzydO6FyK
X-Proofpoint-ORIG-GUID: sK7K_aeIovO-FLNa-iEq--RxA-2_fUg0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA4NiBTYWx0ZWRfXzTf7oQqyQ8FO
 MB09Wm9rWWKkCZNc32GBj2c5ZMQfRHBsStLjez8+XPtPzR4OCkYSuDb7U21NALK7Rr3mLWbhMTI
 cW/aWG/BJ8s9zSdoxNPqg/e5I0Z+z0HuMm05B1Z4G9DG7jMS0dI8I5iJcZxN9yQbb5+LKf+MtsD
 hK01yGGIXqZW1aPduhMZ2tn4jszikv5KpWtbWdLXcicHe1TLC8W4mgZUEmwQY6Dz5oVXPM9XDc8
 MqD6qmRzD0+tX2ND59w1qPf0k/vEEWdkd+i5dEMwEv2obPmvTEzvhPttVnNjodAvYNkTa8yeNdK
 CwgTe1MwrSe4OYpuWdyBe5qjaPOFLwEjj3LEC3bA+dchMiK5Bh/v05OfW1poVjsYKU3nmV7vUG0
 Kba5KfxMSG50iRk3vorqytD8rxSMTpP5bc0PJqm3B35ymtFw/wEbovDTSLJbvZ71+VaDKeiSTfr
 Do2osz88pXb/VE/jI3w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_02,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601080086
X-Rspamd-Server: rspam02
X-Stat-Signature: hhr81n7fey4nupj77b6trdwefk4srbxb
X-Rspam-User: 
X-Rspamd-Queue-Id: 49DF620005
X-HE-Tag: 1767876264-627326
X-HE-Meta: U2FsdGVkX1+vPT5djnEgu8m+R1dS+seSMT1+eDyV9RwjN63Iu/he0GrZEdSE+H8VgWYSozBc32VnjEPtSQcvYeMhSEfhczTxFPbgIgzmdWUUF8z+5yasTRvEwt7PxDFKkyGD38GTeGb+H5KEBS0ym2+0cezghwpg8PkICiKF8S9kA5z61KYkOr8Dclg7e5fsozRV8Q2vqhPHcagsV50I4d1xRjAH2r8MyOlgmKRkGk1K29TvinS6Q4G1SsFet6twVYcUD3aydvs5Dv0nhYB5UO9Q7aTIAtaIDv2IaDFJQDmLMc/xBv8X9e9zfV6/HnSirz5Y8HbsouqdFo/JpfHLFojnMHxQ0K5/vFi3QRheNOs+GxT4rn9S572Q/ZH1OqX/dUcMST5hv9WPeLbpZOov0mf+siy1FkcCVkHzwKY7hp9JisnWxpHzHuQ4K2GOYQqSgFNprd0JskUs3j5krLx/N1VvxSvWSusCyvcU1CSSkSAKKhKKoCQyWtyrlseXWeozzpb80MRfuKQmuyEYzSeRjR3ZEGVOzekh5DpU5g+wHb4lt6qFjpfKGvIYwz4HULusN+WX8d7FVmaQqLrKpgo4aAL5iJtxqrCIoyjnAX2XVnhj11qb0Z4JyNDgZYfGMpjfDAKx7mN3QhmcESeJT2mbeSgFUEO3NG1vgqnT7rjqxgDZMgfikA7qbmqyHUG2q+mitENol3BJyLGTAl4Zt/td5Ito78Acy0wrfDmMGK4ePliN6F0h4tGURf7n7lInBp10edWJdk3VymaCrSNnnH+e9IOyNEyskq0yF+RZsHwx1KopjcHbD8o/bo3C+/JpaBR5Z83RU5v+D1XNCVF4yT70dNKTGKdjVY9ooFB2Ovi9C8ZHWwRVCAH4pY16MJXTE5BQ6vBYWqa/KvwfFRMrh6iUXesmXpYtTBoCkt3PAlBgWQJZPGdERTDfJAKujxbIZE7+sRxyc7fNVr080/6ESJZ
 RyObBayf
 KZ6UN6wvNGJlio+P9rjMREfBWHImdXTCXKbcfHy8XB3hXI2dAMCgs/6fDzvguMBZxHsAfJImYZ/M6GbkR8qhVXqZaIoKji4crzEE09G4icuSh85K6MahopMMjslgNnviweVnYSiyCOArQzOlVal5ogA4BPaskJ+zMNVPF1ER0oLeLRNKOsUJFWaOs3JcG2Fu3gAOGs7zUhZWsiFRRo+Scg/+Z2D1aRts6LRR1SulYaqyg7nbQRDDKAf5VoEpLrcPJvMt53QYu0g/4KFOosFiDLLjiR62Ki6uk3hQbYaYrdUlHa9U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/7/26 12:58 PM, Bing Jiao wrote:
> When the preferred demotion node does not have enough free space,
> alloc_demote_folio() attempts to allocate from fallback nodes.
> Currently, it lacks a mechanism to distribute these fallback allocations,
> which can lead to unbalanced memory pressure across fallback nodes.
>
> Balance the allocation by randomly selecting a new preferred node from
> the fallback nodes if the initial allocation from the old preferred
> node fails.
>
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>   mm/vmscan.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 81828fa625ed..db2413c4bd26 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1009,6 +1009,11 @@ static struct folio *alloc_demote_folio(struct folio *src,
>   	if (dst)
>   		return dst;
>
> +	/* Randomly select a node from fallback nodes for balanced allocation */
> +	if (allowed_mask) {
> +		mtc->nid = node_random(allowed_mask);


This random selection can cause allocations to fall back to distant 
memory even when the nearer demotion target has sufficient free memory, 
correct? Could this also lead to increased promotion latency?


> +		node_clear(mtc->nid, *allowed_mask);
> +	}
>   	mtc->gfp_mask &= ~__GFP_THISNODE;
>   	mtc->nmask = allowed_mask;
>
> --
> 2.52.0.358.g0dd7633a29-goog
>
>

