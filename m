Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA8FF8A140
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075826B0089; Thu, 16 Apr 2026 04:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41506B008A; Thu, 16 Apr 2026 04:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09636B008C; Thu, 16 Apr 2026 04:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C963F6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41829140457
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:22:22 +0000 (UTC)
X-FDA: 84663726924.25.D5E3721
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id E436BC000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:22:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e2Fj1hLf;
	spf=pass (imf10.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776327740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EghXYYnkmIraQBRylz8V08Xw1Fw8PiFljL3GV4sjMm0=;
	b=VHe8tTk8vmd9PvxCyX5dJ4CZTg0DWp5mPLGQvNJRe3ZU+hNcwXQkIcvcE5B2+7GrLtlVdx
	ZM/KURkLYHF4ZGjuoCexyNTGsObUaf0+qK3aJMavjM0KujuF4XLaAIFedKWettR7xhDJx5
	Xr9G8DAtGJYLV8fd8WkHVLHoSUPoeDs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e2Fj1hLf;
	spf=pass (imf10.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776327740; a=rsa-sha256;
	cv=none;
	b=7VI0VSyIxZnhaymQIZ1jq332VGZamEUsZpqqVfSVeEeeU1S4cCrvS++kadUgs9x1w0fXzb
	/OPSaK1xjpb4d1ehEejaSbUQcAEfwOVlh3YfhaDut1XwdAexRBNOD6dayaNofZwmF9MaB2
	N3petR33Yz1xm+EaC7T+PsPIxzorPh4=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G6Edg91733184;
	Thu, 16 Apr 2026 08:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EghXYY
	nkmIraQBRylz8V08Xw1Fw8PiFljL3GV4sjMm0=; b=e2Fj1hLfI0Z8Po/oWJGVW0
	kG/Su8H3VxOIUcJipozN8A1Nh5d8pn6dKbMb4XGpU8+r3sqys4Un10OW+VGpyloE
	T2L4eq1Kj+ZxvDazOTJXRV1PAjI6D1DvWAMlJTWzE/YnUEzYghxhOZeuGBSmFC8w
	wdS5PjkoG4zUb3IjvVyBBNJWh5J3lni9lg9QlQdNKSMDNpZxJg5tz4Nt40UT8CHr
	R/cG8ESBb9p6eVhIk9AfoVlZApcVSUhmDd8dfkvJwMHqgGophpEU3sy6RxfCSw2C
	fumrNuHk+2nH2AmQ/www7b6lqruiOK1ZBfqZwJN3O/+JhJ4p0dVYx+sJ4n5f3xxw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mbk9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 08:22:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G6FXdP015164;
	Thu, 16 Apr 2026 08:22:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0mst7rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 08:22:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G8MCti27984192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 08:22:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 243C02004D;
	Thu, 16 Apr 2026 08:22:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4A1C20049;
	Thu, 16 Apr 2026 08:22:11 +0000 (GMT)
Received: from [9.52.200.39] (unknown [9.52.200.39])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 08:22:11 +0000 (GMT)
Message-ID: <161ab40c-dad7-42b4-b6ad-917f8249254a@linux.ibm.com>
Date: Thu, 16 Apr 2026 10:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] s390/mm: Allow lazy MMU mode disabling
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <24d843c5568a8b591cbbe16eca092e7f45d18cf5.1776264097.git.agordeev@linux.ibm.com>
 <20260416054405.10407B6c-hca@linux.ibm.com>
 <2a497bff-1773-4245-a63c-784ed8853b11-agordeev@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <2a497bff-1773-4245-a63c-784ed8853b11-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69e09c38 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=bZTvA-38IwGshgt2pOQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cybN27AT70Xlug33CcVsFDGHqa-ZO9sJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA3NyBTYWx0ZWRfX2Uocvty7Sfzg
 3EKlGo+vHAXe/bxw3gU+c95Q5guzP+mOtWdsoQvd1m49GlwN8B4zgT/2IRWbjrCf8Z8Ez6/mhfC
 cl+WXtWMpsbbF+rCwcVMWO1nRPPLVuOPAYWHPJ/gyZHbY53pRHZGfysgBskJH6/sHsPvq614gNR
 NK9IvglftKx10tyLUhewEHJ2IyvDcizzTPZ2eKIZzvF2eB+ivmeMoJoJHYdxaAYslB4Py3SUvV6
 +synpXrscZek6LfanKvVHcCuwdMzjruRvxdXfhqpz95+kEqqzS4HLihEXPYoyOT7+kJEmsk6byM
 dgym7Y0ddR1mmu7cLNdAcUFbaNbtzOnlIJdWWashK4VP/5eNnkMcKTkmA20aOEw0iTsqe3sNm6j
 JOruNSZ63uJCCxs1b+UGCrP+cMo+7+FkZbFZIhLT4CfyuHBXV6aAKfY0Y0m6fQPZapYTIhQh+FP
 qmEiz7gMaXcyn+nZqhQ==
X-Proofpoint-ORIG-GUID: cybN27AT70Xlug33CcVsFDGHqa-ZO9sJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160077
X-Stat-Signature: 8he48yikh3bw3czeznaxura9s7on7agu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E436BC000B
X-HE-Tag: 1776327739-786017
X-HE-Meta: U2FsdGVkX1+pObTyaoJLRjptlIfEi5QzhgL0J03VPQUafpe8RoyRWr9sSr6rgX2yQg5xBpkjuvqErtm70XBtpVWr4uuNkUusD9586e0Dgo7Xp8P5bBEpCwRUuvgmYf6Zzn0aonQz0IL31V12/a6HRGJ8AhrP8kBm/UzPRyxl9JEjdebaopZqYKONuyTuDneLG4d35C9sk/BDorOn2hYdTVE6xvKD0g4QbYFEtYPWUoalXSXRY2f+8PDDcqmNbVu0ilT8pomLMdiOJv2YolwGJ3IgsaFEmTaIOz87F6cqp5iwrjFNZrtl5FstMuG1WSRe52Vhz2sHpAsy6rQAtj46ul0Fv0fvsSh6PvWgE9OUb7m+2/WQn6U4CSp9bvzEUjCzagKfu6LZiBPKC4hIq4R1TVqSsw/sXMZePeyAlE99B3TLOEzqNjSzUyjUzXC+P0Vr+vuuPP5vi4ysfY3LlwUO5NACZxv63PwibfY4gHYOqiO5E69346lQaC13ays0kvazARQD62RrQPWfctzIOu8gV3Nm7tQsd2hT4zmakfyeUZppfh41qiv2RwokpDMp+IE39L8SSnAa/dc55fdlINLIiso2VCUzHjpZ4TJSe7Q9cajDYERd0n31DQvO8n/kgguqjkrsc6muNv8PxIa8uz9mDd8j4KLqyA5RUhWR8vctJ0nUNu9CZykh+NwFyVtGjBtsmBuLK7+7KjAMcD3I4Mmu4aCr37HgPbslMBam9gj6LiATFl8oP6/x6JJ1HVYguB59zKErlMPujybNxL1xRF87Fy9EtYeVhkYR+szajN9IC7HXZkmwfYnDwqEJ9ecMM5qdEXkHF3THR2IjD7MrLmMJAj64Sz3X+gOZV5wXS9L/pj0NE++fWP/fTIPhHql0FjNTUTKmOZRQg/gzFj9LLbxxasCbgDXGdgJKfjfCi+OfqKemGgVr6psl1Ft9Z3QQiV4Ej6AHFTaI3HvEZ4kUT7Z
 kdvIRwOP
 msxr8TCNW5Lef8MYKj0c/beVe23t0accA8TCc83RD6pRQQWjH5XHlgiENKRBZPFaYha2NJ8v9qTEcIdBVXEUPV+C0msEL35/rxIfzV529SlkyePmhm2OrsP+YfrnuzD0mewkrnjIEvKBt6ZDXHbo3b9KzRF/CrjgldhFsYJsmxF7EPznwv+uGFsnZ24dJGGqmi6fYJj/5fP+zp/fx3vphs4mK/fgWLlrfwqq3FD2zM46SLV+HF7Mir2KfeWPBysG0BQrtoohN60frEmbQkXxL9/8Janj+jqcIb5/011B56yxG/EPfNyfR62l2JuT7O3Vz4QKn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 16.04.26 um 09:00 schrieb Alexander Gordeev:
> On Thu, Apr 16, 2026 at 07:44:05AM +0200, Heiko Carstens wrote:
>>> @@ -169,6 +185,8 @@ void arch_enter_lazy_mmu_mode_for_pte_range(struct mm_struct *mm,
>>>   {
>>>   	if (!test_facility(13))
>>>   		return;
>>> +	if (!static_branch_likely(&lazy_mmu))
>>> +		return;
>>
>> Looks like there is an alternative chicken switch available: remove
>> facility bit 13 from the facility list via kernel command line option.
>>
>> Unless I am mistaken: that should be sufficient and avoids adding more
>> code.
> 
> But that would also withdraw multi-IPTE from other unrelated parts of
> the code, e.g. from __kernel_map_pages().

Which is fine. Do not over-optimize for a case that should not be
needed unless we really mess up. This parameter is way too complicated to ever
be set/unset by a customer.

