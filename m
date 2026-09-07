Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A52C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D936B0098; Mon,  7 Sep 2026 10:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9748B6B009B; Mon,  7 Sep 2026 10:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8661A6B009D; Mon,  7 Sep 2026 10:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D576B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:41:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5E091401BC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:41:49 +0000 (UTC)
X-FDA: 85187230338.11.23AAC83
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7222040008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:41:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KNPVEj8x;
	spf=pass (imf17.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788792107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGsHkXEOK7Chg2L24+h/RQE0HtCGs5tTeMDf88fmFNQ=;
	b=4lEEwSWkQgXOxfiBbAc7N0FbZrElsmbG4w1wFlraG19Hdqa9HT3IQ7dOy/M9Am9wO+/Q8C
	c3XVhtRBFVymoJ1LjcPyPOFgok21rFpzvF3fmXOmEUQAshQj11LyFQVbB3hq0ue9duZ2hN
	f+PcNDj+Ey4uwMpSBvnX899+TREgHW4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KNPVEj8x;
	spf=pass (imf17.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788792107;
	b=qcCV46BCVy3LcV5tgSM4YM2V1tpcxvLJkEewOTzd3BMidOWiQyrXC+t/6T3y9ER6zH7B2g
	kspHrL4FIcj0b2OIpgvKM4/SvVIgTXQ8yk8Xze3/aJVkjkIFQYpT9cW9N5WXt19AMUzsjv
	ah4Cmp51T80Z6hyNIeUtmP5bkCyDrKU=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687E1jDf1006586;
	Mon, 7 Sep 2026 14:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hGsHkX
	EOK7Chg2L24+h/RQE0HtCGs5tTeMDf88fmFNQ=; b=KNPVEj8x0epjNZ++4RcDYY
	0RBhPVxdmsOeppEK0BeV42XTJ6dAHcaSyXB4Sf5FMk/QnuCbXu/2zbtrDhgIuTGh
	a6jbgiwiQrwxd5NO3PeYFi9yat5lew+6zk95i/a8pTQJkgmt3bDLANMOAvA0CrMc
	qkTrJ+bZ2C8we8P++nn/ACZN+HZ7gUtVTDLQZkuoUo4c6v3cHY4xKSz5gsXgEMF+
	oO+MdtsPSgzUG5l7KvdYxn6W+u4NkM5unQBAGADxJakb3Gu13x5T4zy0qO+CKfZR
	/LEYY0jrNLRVLb4pEsJhq9HbIob93w1D0ibXvTlpg4Bk2jah+IXftjA6Optdqyuw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrh5dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 14:41:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 687EfOjQ024324;
	Mon, 7 Sep 2026 14:41:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdq6m72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 14:41:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 687EfeIP51904850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 14:41:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4060B20043;
	Mon,  7 Sep 2026 14:41:40 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E37A820040;
	Mon,  7 Sep 2026 14:41:39 +0000 (GMT)
Received: from [9.87.132.113] (unknown [9.87.132.113])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 14:41:39 +0000 (GMT)
Message-ID: <024f8c94-dfda-42bf-8cc4-dff9bcc5409f@linux.ibm.com>
Date: Mon, 7 Sep 2026 16:41:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: s390: Replace get_zeroed_page() with
 kzalloc() for the GIB
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
 <20260906-s390-kvm-v2-3-2cf6434e6646@kernel.org>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20260906-s390-kvm-v2-3-2cf6434e6646@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6a9ecd28 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=kt7I_EveaTZZBW9BUTwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE2MSBTYWx0ZWRfXz3r027/vzAqj
 xIUjI54D3O1Cknw8PUlH4P4FDxxrvu3IR7l5AyHItlZFBtICn3A9dP1vnYWP57xwfENMSPn8pK8
 evPb1eAx2jERgecResEoR0B7dUSRcFE=
X-Proofpoint-ORIG-GUID: ZW8NeN9Lg4-BKQR4xWv-6TaRcdvI2BDD
X-Proofpoint-GUID: ZW8NeN9Lg4-BKQR4xWv-6TaRcdvI2BDD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE2MSBTYWx0ZWRfX3c5qpdGK0nJA
 lXQYlobzKnh/8GUVvVM8hYI7ERrJILg8GlyzeC54/yA+z2DJWyC1ZciISJi1MyNQ9/CgVOXwBE9
 pjaAQaBp4LjODkJcJK/oqoy6t6Dxiytk8XF2vvzHf98R0zxMe7HAoW+T5kN2+w8MAw+bNgDvnbe
 fuBljPso4X3i+fYodInIvKNtMCw0xtKUduqtBsXxoK8gFBVz8OJo3cbqOB9YIfj1JftuIfbqlTS
 ey75WqDLecbCABS3cMnGMXp3OiOyC9l1orT6oPSKPgYUwhWRgpGOZagJPhOu2hA7H0u6IESGMai
 x9+OpvLV6a51IKQxl4NxkEGEfwy0mxwDhPQFhaz5dWLYSvEalSm3cYBv1TnYkA9CxzU8zulmZ2e
 f0r3ti33iaKBvis4glwjl9ISkkuXt/H4efRejDPDpg28gFfsXbSSnaAAu1itixQ3+IrY7D5mPGc
 XPgHPLSr9f3qje8om9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_04,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070161
X-Stat-Signature: ah9di7wnisdatbcop6metbuiwk8fynfs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7222040008
X-Rspam-User: 
X-HE-Tag: 1788792107-527202
X-HE-Meta: U2FsdGVkX1/Bl2PLRq1/B1eHSezsgkm/IUGhtLT5icMjOo0jlsPgh828GcTiOdUFv1JaTL8Zu0ox6Vm7ojCepgjefUB3L/eb+9Dw6eqjZdPqsj1R6l7tQ2fahyVU85riS2AoKRMkY6CTBd3AWG1PW7S4yEHB9LQQULt6g6CgrTyQGKayc5xIV+K0XEaR1JsN+1f9QbD77di9cTZYUu+d9sVK2dDCrXq2JdXd1jnynTAMyz00G2/AMGrO9ULDR/eKRwB2UTeohP01TgrW5YE7I+tuB2B7QoD2mlIC4IPDkmzTgMWyec+d34Kgs+VbmprRMXBlDJltbVVR4EgNnsOlYb3PgAIEcbOl0pAI5OoDrF/I8lQ+adnbZZyUMaCaUxpWfFuJrkQ2ikwSNzRI1PrXkKoAnKWPMcNezTdVdOjoDJ4s+3BiTf8sORr/TvyXuHFPcmfSZ9YGYnDALbzrHKQ5v2sR4OkpBu/nHtanLHg1bqeGywb8E6Z2DY54pdk1H/Ew9EOTnBgFg35FAiwwjmrwZgpu0S+47tGrbUysAlqN36/6ZmkfgaXmEHmxwcs0338FajJOf8lU4Twm2ndHZtILK4FpndVpzo+brk7ycf4YdVgWV98BUBHdJ5vLMRt13As9yPLLcxQ/8QuFA8ZJPGY73wTDifs4WXkZ8Lofe6SNDbV3xRudzWqeJdEjCjeFXUUWaMFLevp7GiiOGSE/SQ43QD4RoaFxzCMrGgalg7Gg6v11EeP9MD0f09dgSQvgPh+Gco4kwze0MJ9Y+H2h7sn6FdUSU+B9uiVLKOAEYKh5IDbaM+aD+Dp6D9MyYQUwGW/JKJb1tusE5BdUF+5Dggvbo6Y6lV8kiZTXv++ucxIxsKHoV3FR0scBtKnQ05Ge8ictDY3KToszL2S5/IAqmPCuaZ7nWlZgNyTbOXff6XbT3M14VwWWkr8GzAwD/gZvaZJ27/nm9lZoOrbAH72ZVde
 TkWBiWU1
 HqASO+5wfcMw5YbhTBzYOTkX6J1FN65RqrEqkoNXaFkUilkkcBBvztM8cfmVrza3VRUHHguvHVSipd7Mr/xLUglvxZoqnY04y+1azIWZdmDMiWHVWWBNTbOArc/Y4kHUpewi49ILROWP2DvoaLjflIc+1CjMXhFWBWysLw80UA+3Fa6fKTfIYAI5Z1ad3vFuvKXIfl/C+ygLSci7oSB9sn8JPprblx7Yqs5cxFPUD6338AI6f6rllKh5w5lJXu6rGDRE278R9JHiILAYwguBIK60SAX8KzPTwtOQL03I//0tR2c8G2JWZYz0DUR6kFDIYZQpfcMCpRfvAiZvAQMuvUc7vvCpSpCd8o94XM7ehoJDOwrict+WUkUD9cFRQyjBJhVtkOk/uoDTcp30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/6/26 10:27 AM, Mike Rapoport (Microsoft) wrote:
> kvm_s390_gib_init() allocates the guest information block (GIB). The GIB
> is passed to the hardware as a physical address and must be page aligned.
> 
> kmalloc() guarantees that a power of two sized allocation is aligned to
> its size, so a PAGE_SIZE allocation is page aligned as well.
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
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

