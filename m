Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A950F54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C8D6B0096; Tue, 24 Mar 2026 11:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCE76B0098; Tue, 24 Mar 2026 11:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBC66B0099; Tue, 24 Mar 2026 11:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8BEF6B0096
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:47:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D093E023C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:47:36 +0000 (UTC)
X-FDA: 84581386512.18.B73DC66
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D25E8000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:47:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nIeCWc6R;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR9MIXG5cbSNnabzc/Wmq/ZEfcuykgTeKIrZ+2D7JWc=;
	b=WkeIiLJd8xqYnfhXXo6p1fFteMBC4tqUbXc0vPEucComnsvkvlqNHQ2GSPLJ3rUjvAIawn
	yNLeoltMcCIcRjEW+Ah+z0nKj1pp1EhW9Mrt1zQgXOkl12DJaX7n25BDj5pBJv2gCflfs8
	IRxkZgPGW2T2FKWpfCD5HdBAJQSVRjs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367253; a=rsa-sha256;
	cv=none;
	b=8oZnmJkd2TcvEotqtop9fxSzRHwzO3mEmWzu27eR6w/0rm1/WEjK9mJjsc3wB26iG+jm2Q
	5tN6nf+oOCW2AtYLiDfUifCIB9TmT0XtrK7ocPfKgXEHBldLOPiG0TAeye3WUvNr5Lva3f
	XyUz7V3c9/tUctRUy9IHcnn/WgeQ5BE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nIeCWc6R;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O5TmJ0556595;
	Tue, 24 Mar 2026 15:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nR9MIX
	G5cbSNnabzc/Wmq/ZEfcuykgTeKIrZ+2D7JWc=; b=nIeCWc6R3MwyeJCONqz0ET
	v1g1hlulkdHkxmzgrreYFO4GCNkMfSnMj7wv28bOFXhxjW84wEv0aZSGhsyATnob
	xUywx1MxRkgtQ9kzOT2DdhLFIDp5YiYZLqe2spiijHoPxjlrGt2I3hBH5/W1wXF8
	bubF702lCFNckMyi6YfABFTtyW7Lx9v0fBS62/O8GtVO4PP9ck6DaEnLm9EIPly3
	nvAVR0e3K+TG1wGEykfWjF1HfS+1rc84ng+KwbhtELCPiT6972gIGGHRr/4v44Bs
	gA8pQZA4RUAxZZYXtnicZ6vQOglA6ejVBGsal1jVYDHRda4A48B/WyS45HnGHSYA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqcbkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 15:47:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62OFJ7mB031687;
	Tue, 24 Mar 2026 15:47:07 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d25nstq4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 15:47:06 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62OFl6wO22414060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 15:47:06 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 885C758056;
	Tue, 24 Mar 2026 15:47:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A5965803F;
	Tue, 24 Mar 2026 15:47:01 +0000 (GMT)
Received: from [9.39.25.178] (unknown [9.39.25.178])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Mar 2026 15:47:00 +0000 (GMT)
Message-ID: <5bf5a4f2-0505-44ef-9cea-df6ec25d9603@linux.ibm.com>
Date: Tue, 24 Mar 2026 21:16:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
To: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
 <20260223223830.586018-7-joshua.hahnjy@gmail.com>
 <90749965-ebc8-43b2-92e3-baec5f6e3de0@linux.ibm.com>
 <acKsb06lnywch8DV@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <acKsb06lnywch8DV@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: LVdurRN2EDTT67M7-3BJiK4bPS0nldWJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDExOSBTYWx0ZWRfX1s3/DoQnR89W
 4OyHHua3rqv4GFjhuCfmRD+wRHyX9XpxaUnWFV0CjxWxY0+qaGst+wECvYnFNnS+P1R2KSqWsmy
 hF4WEydo5virXXt1dSZuQjbQRTFL7y/deW0iHb6zb7lw7UrKZyhgwzO6jn6GaMwRc6hShSUnHpU
 351n0cZgj2fEY1jC0dFDy66jrgwZS/lw2F1uwYYWynlpy8vmYJJnPhbv3TYd3wGPFS7n3lwWrOR
 /BHtI2xJiY9+yrhU3mr25Q0irzNJL92D+PeX9sChTnAVDnyBoRk8MZtgZvbnn8Wx2HzikRkOJ/t
 EdQ1tMNsslsL7N6g5SohPrK6zddkVGCIyhzBsC31BUhnH8sorqp0XoIE99oC1vQI6WkYjyVWsKm
 D8ZU5HsUDQ2rII9G4sbSgg0TjmEHpLKzIrva4HV4Eh6b835F8OWON4m2VPi9Hd/NCzK3er7f1Z2
 eWwRupQX2Pgw93AT88A==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c2b1fc cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=0D6tOVm0XesP3UCEPNQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: BF40lhA_4j4DGEWWyDFDVxmTk2uqOXny
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_03,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603240119
X-Rspamd-Queue-Id: 9D25E8000E
X-Stat-Signature: z4nedcgme8greski1c56w1er1t3t8kdr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774367253-142709
X-HE-Meta: U2FsdGVkX1/orrTvu3zTsaKnOBGbsYau+84L6AjrvL3y4/jqSFnXYjKNuIX8dACXH1lzoUMEKjDqctXRY93jYxCagCy/MI5bqIHiiJuurYvQwhlUOXFU80HPVoUlxDfXppt0RA+8P5JiAkSnv2++rwIqajbYMXq+7xe2HiY2W+AqJn2TIT0wSyOm5MtvpXtJLj0EMRMmzR9vZ0Qp6Zds5Ne281nO3QDmXS7+vkhb6TfQ+VU2dJOiaXiS2x4ireuVYTdm/Ty5mguSqKLUHX2HkUyDla9McHIAutRqYj9ex+wiVze7KY92gnk5g0EdqNl4gD7A6m6ftD3xThVzt5rcdzKBkJaaBR3O1m87RKUHUNwppFfkjaz6rA7a43gAGDBkCoVsLMTQoOK88KqvjG+fm0nhq4jYbP31uomlc6394SzOoCPEPO61FGrff3hJNer2VpttaWxA6UuDowcB23hsFVF+RqPLYf4ZLFyyerHClHOWggnUhb01M42sVn/E58mFDYBhqcCKv0TlyaZRvXYRl4ik7nRNnmr/gbLg5amO5BCHZAXR5940CMHSfVdHQl/zKAp/Wrsl3rdifJmkzxpbXVTW6LJRYtJwFu1PdQlSm93dqqsvB3AU5IQxdJqf1YLeixXyoBw61uuaAk1AuOEh6osm53GWtkalDoHWw/p5ANZ+GfW02AHhrbEWGTTSo+9SO0Cs5FzQ7Kl4t12etMT0JaR8ZsSpmBbWrJFxvfagFMAxKsf+qJXSDZI9uK6WkPk/CseRNXQYaRnFNmkAPFB9lW5pExxbKg3rJnUMkf5cKg0GVCjax3juXB75OSSfIETZL7P89MI895+IOiv8nI7MNiFgT3XxnSW/sDDnA8fVQEPSO15nwIlpjHrwLQLrupw/yXyw89Wpv1v/WVIk8vEOLDWdy91z9UuS2TcQTzGrfT5renPqfxh/pLmfSpKK85Lmhj7ouESTuFAdiS0ZV6m
 Hts0oZ/X
 4U+ZiACp7vE9mVztCS0mT7deNFGHrKJtm0SZw5e1X9fL4+tHWFT8QwmrTNQVsrYmstvTWa0S32O/EdHFvUSBFH0g/9KiGjxvShRGHj6RGx+4wSuo70gsrCWCrtjcuTh1q4ehsSRPkbbYLEUT/YLJLomu45Po/x1jn7oUg/KT0F/TKEhGUSsXUOvfLO3iKLinpTe1t/RsJcXZLAmBheUPk8o7hrkf5s6nSxmXAH8d5kcVBhPXJmYerKHbxCbs9JTlHpfGFqwo2ymswDs6APuOjp7AYOMka25EpQDwN5sWnRjs/5LnLn39nD2TfmgXinhVz/KkTtmR03mDVnWmlonGLmJHia4A4ppoqNXSRxGdGnLbswavVtkNtTMHQlNzZ3qtmJ63L5jao+GP0R5HjDXlQmX0eFbnso3AmReSP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/24/26 8:53 PM, Gregory Price wrote:
> On Tue, Mar 24, 2026 at 04:21:06PM +0530, Donet Tom wrote:
>> IIUC The intent of this patch is to partition cgroup memory such that
>> 0 → toptier_high is backed by higher-tier memory, and
>> toptier_high → max is backed by lower-tier memory.
>>
>> Based on this:
>>
>> 1.If top-tier usage exceeds toptier_high, pages should be
>>    demoted to the lower tier.
>>
>> 2. If lower-tier usage exceeds (max - toptier_high), pages
>>    should be swapped out.
>>
> This is not accurate and an incorrect heuristic.
>
> Transiently, lower-tier usage may exceed (max - toptier_high) for any
> number of reasons which should not be used as signal for pushing swap.
>
> driving swap usage is a function of (usage > memory.high) without regard
> for toptier / lowtier.
>
>> 3. If total memory usage exceeds max, demotion should be
>>    avoided and reclaim should directly swap out pages.
>>
> This is also incorrect, as it would drive agingin inversions.
> Demotion is a natural extension of the LRU infrastructure:
>
> toptier active -> toptier inactive -> lowtier inactive -> swap
>
> if you do (toptier inactive -> swap) you have inverted the LRU.


Thanks, Gregory, for the clarification.

One remaining concern is that under cgroup memory pressure,
demotion to the lower tier can still happen. Since demotion
does not uncharge the memcg, this could still trigger OOM.

Is this an issue we should address?


>
> As far as I know, from testing, we retain all the existing behavior - we
> are just managing a limited resource (top tier memory) to manage the
> noisy-neighbor issue.  So...
>
>
>> Should we also handle cases (2) and (3) in this patch?
> No, I don't think we should
>
> ~Gregory
>

