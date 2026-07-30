Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CEEAC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953BD6B0088; Thu, 30 Jul 2026 02:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904C66B008A; Thu, 30 Jul 2026 02:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3776B008C; Thu, 30 Jul 2026 02:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6A96B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AB711408D0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:06:18 +0000 (UTC)
X-FDA: 85044408036.30.64386C6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2726160004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:06:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=s8Uk9W8u;
	spf=pass (imf08.hostedemail.com: domain of meted@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=meted@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785391576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSKpK5beRJSFXxCftlJ/6i2fmlt/3JwNSqzLkzUOYIs=;
	b=z/dI6+w8iQJNV4I37ByKipBJ9yoINoMHhVovYBQPV3ntAsknmMsSue/WAz+3tPwaH0Lkw/
	KLTupUh9g1FYmnPhve7Tf3MpXw4F+d8TRVj0wSqzq9N12UxHOrS6haUmtXdUIEgEENGk2+
	KKMZeBY4tZjGcOeiVasIg+kT6WmHt5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785391576;
	b=aKgwciFkaxLRUWTGIJpnT94YmFpuHbVoje1xgRie5/1WYvV9G3j8g5F133YpuPta3VBhQm
	mctVvfoqETsmMErA/nVFmKPB6Ov8XsQ8n/JPh0fIEIIF91rgd4n/1Pq9kb3TCN84cDs2cz
	TnpiG4n3tVszL4ZPaQShBVgkEA3E688=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=s8Uk9W8u;
	spf=pass (imf08.hostedemail.com: domain of meted@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=meted@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3laV01933585;
	Thu, 30 Jul 2026 06:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fSKpK5
	beRJSFXxCftlJ/6i2fmlt/3JwNSqzLkzUOYIs=; b=s8Uk9W8uV5FJtCx0SbDAh3
	YNFN3+TeiruYlev0C/0DU/tf0DzMuHjMq2kOxnLx25pno10CX8HUptcMWsBfSXAo
	9tGkKt4kAU1tLWoylL4JMu3jq4U56hndhVIvTTmgvsnoYKMCHBynzf5rPGZGstd7
	PMq4lQ3Ljb6dO6MfSPWdRWifD3OLBdi+Ya9gvTKa12VvpunyiOM34qx4EGZn7hMX
	yT0yaRhJT0MepDDBWdLJP+yeVUQBmZxRHYcg5upYbwWoJXTxo71Wd4CmMcEmQjXe
	nyR3Mx5aqdqxMJHDnndbe6jAjKRaLrDO4slY+ECe/WNM+g5ssIaAcse3Q7Dkqibg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0xxa3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 06:06:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U5uHWh012301;
	Thu, 30 Jul 2026 06:06:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqj6wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 06:06:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U663Rc35127580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 06:06:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72E832004D;
	Thu, 30 Jul 2026 06:06:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10DBC20043;
	Thu, 30 Jul 2026 06:06:03 +0000 (GMT)
Received: from [9.224.76.67] (unknown [9.224.76.67])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 06:06:02 +0000 (GMT)
Message-ID: <18ca706f-ef45-4207-a55d-025f90133978@linux.ibm.com>
Date: Thu, 30 Jul 2026 08:06:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)~
To: Yang Shi <yang@os.amperecomputing.com>,
        Ryan Roberts <ryan.roberts@arm.com>, cl@gentwo.org, dennis@kernel.org,
        tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
        will@kernel.org, david@kernel.org, akpm@linux-foundation.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
Content-Language: en-US
From: Mete Durlu <meted@linux.ibm.com>
In-Reply-To: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: r-zTKHDUsTXOcFmf_-9wS5lhnkg_qTkD
X-Proofpoint-ORIG-GUID: SOP_yvGrI1a3-1kuGNqQ95swD9gDixMk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAzOCBTYWx0ZWRfX3sdFvOaD+SK5
 BwqMslyT06eKdSQz0oVVw1k7nVE1QnWBDNlUtJeG8OzEZn1Qwoo9TgP2LDtITB8K11bp8UHn33n
 Yi+SYqS182tCyPn3xWE9dgJhNNaRla0=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6ae9d0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=cpGfkXA4JyvoFA7YCHUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAzOCBTYWx0ZWRfX5gMfbafa3aqX
 NNjDEl9HOtJXNn4YfJJOTBdNIIC8zGhagzyCNDyk/MKfMb5upZKxisfIr4F7NvBQg1xaBcPQyNv
 46vDVGcFHsZvz6oM5aox1Wu2jAQXWZi+7ZoV/5dAmfE8cDa93FDH0Re4fTtIXlnHqkmNTojKxIp
 MSMINRnnbCBPy0EJhnBzP4XQTVgxjMsqIuUhdnJ3diktuFy/wt7Wwp40O9F68IUluEiQXO5/7S9
 eDQ9I+v86YpB6F5FwzVztmvgQV8nENbYPPyZKklzu2b+ZE9cVLNVyQ2aTkkurLiDMtUElHm0yqB
 55gNYq4GxIJcsYjXQ7QUnEBwxHurFePOj6BlQTekavxxKGzzBdtYKaTJ+4C6Eza0rl68n5cy+fC
 ZLiVYWsF9IKSiD+qYRqfxKebYddG+4YKGZ9v8/KonRkZJYHycXOJAcJShzHh5i86D3exEA42k9e
 0rkzXrDM4oGWfaDZuaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300038
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D2726160004
X-Stat-Signature: 5h3n1mfrfdktukiy5tmr8xj5h84ybam4
X-Rspam-User: 
X-HE-Tag: 1785391575-473512
X-HE-Meta: U2FsdGVkX18TNG8QKeJCvhp4WvrS+pQO3Dm5J1b28IvzXsz70UjPnesmFBBRdV/7KdrZR4Vr/W5QIY/8J6DDwemg8NJFdrTak1g3ey8uAAqwtsZRxWFq2g0vZ9g7t0zDN+FA8Bb9EGLhnCh4GW79x4TgGQIE+5QLWb9xzH+6hDNawD5Mkh9wVvz+eT+RA+RjCywLVLCInecdGajMcp8soDWYKivdsVZwBN1NO3yRZsj+RRtIlqaBvM4/q3v7BjddX9xezi8yG9sv27/b7KWP3GRxhq/hjzP2B0VSvp/2Pif79BwusbqVuCVQHLY5yFyjnEloZqEe48NtDlkBIL/pTNgcHT8DKLqogEmZO5laE6EEeAAH2BG/ZrtIKGDeL0rp0C+vcvj3c4AOHbhVT1BlhvUAtKGt3M+m82lOu5XOPtMs51EoXCpxrQBKQghLwAbgrz+UFVjyPVIodk92dlsWGUUNQueY0FQnGNj7UdBJN0fObI4WXtWC1A3m22Jc4mCFI5hpLxOU8/Bw+QwexUeUf0aSzyhiaXhy6/hgSuFb4ZIF8vyh3ofdTle8keCUbOQOVqGZL46/rZl3HvPePhzn9//8vA/32WYiI2RwR+Zmsvk6Wu83KEid9JcM4eSIL/5Dv8vkFlZpEae08vPhekbHQ7LrAbvQVjd024OrML380+xNssX+euf3sVwwebQc8vlMugu3dWo7ceADKRweToqbfPI+LMWIpt0PW5V1sIE4K7IS8LQZIi8mjQIxtYgLs/UZnyJossSRGneDsY3dX5jrM9vwxwpNa3S0H95JxAZQ0lH4wjHQdktBd3Zg3r1JZgTW/C27ydJkg2FfT5VazCBkehDd4gp38HZy5JtU2zhZ0xoaXhEIbyEYAnHDfD6wXeEarWrtBdWfqI0qOE9hQ5qTFWH7vlB17vGHwcbvwUvxVq++0dcLK3Gk2DWTmhvPTlP34y08QRlTu7A8NCMaByM
 8c0KsnOI
 WQNat/XAjKzjYHR9HBHGaHyJugyiYtMrKjQ/m25hfpckwS0OI/Z5aSOkMmgfBNTQPkfffNqchc2AciYz3LrdH4+VTR5K589oT0BuHNooBDhXtDmizd0HG0L7HQcaHDKFtTAxBaKyOUZPfCJqeHAyDGWit0C2AtCkpT63EWMhXeMmYSJe5JUAi95gsrC27s6w/S1pe/WVPJb1IJm3EkePNvnT+6sh2C/Yn0cyhifomnH8CojagUmFH007jfxPsBjEtcICiA1isz67AMHlNLdIORItr/8XsrVOPUFOC+cwMAKA3UkxYNIFUeQMMJ129FSbuCUn2K06CEjb9KEvI4HRalqgEGzQZH7VERj7VSYSouUy48WoBhRM/5yc2gmpCPyllUOa4fNsI/Ck4XJ4eTJrGk6dH+jMOs0oCzb5I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/07/2026 01:20, Yang Shi wrote:
> 
> S390 implemented restart sequence. Heiko didn't share too much benchmark 
> data, just confirmed there is no regression and I had a lengthy 
> discussion with him (https://lore.kernel.org/ 
> lkml/20260520092243.264847-1-hca@linux.ibm.com/).

Hi,

regarding performance numbers from s390 and Heiko's implementation.
It is safe to say we see noticeable improvements on micro benchmarks
but nothing really pops out on regular workloads.

on 24 Cores - 48 CPUs

1. Kernel Build
---------------------------------------------------------------------
time make -j $(nproc)
~0-2% improvement - within noise ratio

2. stress-ng vm ops
---------------------------------------------------------------------
stress-ng --vm $(nproc) --vm-bytes 128M --vm-ops 100000000
~16% improvement on bogo/ops

3. stress-ng vm ops + fork
---------------------------------------------------------------------
stress-ng -M --mmapfork $(nproc) --mmapfork-bytes 128M --mmapfork-ops 10000
~6% improvement on bogo/ops

4. fork test
---------------------------------------------------------------------
stress-ng -M --fork $(nproc) --fork-ops 10000000
~13% improvement on bogo/ops

Basecommit: a2b94afeb516 ("s390/zcrypt: Replace get_zeroed_page() with 
kzalloc()")

Thanks,
-Mete Durlu

