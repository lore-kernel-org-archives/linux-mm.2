Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE82D3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688E96B0088; Thu,  2 Apr 2026 08:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660806B0089; Thu,  2 Apr 2026 08:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FAD6B008A; Thu,  2 Apr 2026 08:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446F66B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:12:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F0F213B5C8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:12:30 +0000 (UTC)
X-FDA: 84613503660.01.CBEE06F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70B7C100009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:12:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ay4kZiix;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775131947; a=rsa-sha256;
	cv=none;
	b=f/NRA0hDaVWWj5LNSQomUMILAZWs4OkI4NfNoLKb5Y2XvSKAMvZaLR+7iE4nneq9aub1Rq
	70er2Nww2hE6Q8d6WH8B+lQFiAXAZvhoo5ypDbxic6k5vHDYA07l+BEM5ykhHkpBpREzJk
	8/6H7wAuRbqhttRmY2gx614bexW8vFc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ay4kZiix;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775131947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQQGi4Oghaq3qX0wo2ocl1wj6f6xW2xR48DVYw5ifDg=;
	b=1jAFkJYhaqLWGL1Z9NbUHLzQJ3yinzARoGRVHk5DA11RalhohDrKGI6Yp+5GyUo8JWSsU/
	sZA7gUvDrnxJE6ANlUM0BvCmWbdLX00ADXBtbAl2fbaoXUUnA2fk2KL8fIsgc/QY9VdHTV
	1E0GF76uqiCdwUMUuNO6CClK+Kjpms4=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631L489m568757;
	Thu, 2 Apr 2026 12:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LQQGi4
	Oghaq3qX0wo2ocl1wj6f6xW2xR48DVYw5ifDg=; b=Ay4kZiixXjYNnF6LuuCuRZ
	qR4YvvVx1aILT+bcm0zLfHaaIygkpTZqEDwY28/AZ6QrmyXOCrMDvcBNmpz2XsGF
	hyPZYg6rnaEzONE+94VEEsqIGlg5Mu7fok4Eu9T3vS+cEVFCZ7nlRRpvncMGS+8N
	NKCgvjKnye8366dlAVoU0ymvh/jjOufvoToFzXJkcC0I92nab5R7pX/XXt3jZIaN
	jxrVH5CzEYr04rRZ+4XOKJ+rfzQcfyjfnNKevu34aTW2a0aAz3/SKCp5RHuZdaaU
	yDR5+aiXH0hsoq8Z/m4To3alhlJtk+KQUYTkA72GJU1kq+yu1Uzzf7WM13RPKf5A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66g24qkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 12:12:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 632AP7iX021722;
	Thu, 2 Apr 2026 12:12:12 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6sast3fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 12:12:12 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 632CCC5S28705472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 12:12:12 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 430B558045;
	Thu,  2 Apr 2026 12:12:12 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2DDD58052;
	Thu,  2 Apr 2026 12:12:07 +0000 (GMT)
Received: from [9.39.18.17] (unknown [9.39.18.17])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Apr 2026 12:12:07 +0000 (GMT)
Message-ID: <6e0878d5-878d-4f8f-a980-8e21564c681b@linux.ibm.com>
Date: Thu, 2 Apr 2026 17:42:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
 <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
 <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
 <3ab0e5dd-cd3d-4f78-a7ee-01051f200b36@linux.ibm.com>
 <877d3988-57f3-4f87-8836-85aad5454879@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <877d3988-57f3-4f87-8836-85aad5454879@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Fdo6BZ+6 c=1 sm=1 tr=0 ts=69ce5d1e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=6ZReSu3Cd-7Xrk7Zi6IA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iACiDCSOiDC-uueVeMYONtY9kaR5_I07
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDEwNiBTYWx0ZWRfX1maWR8aeei07
 0FjVprD2oNKWJAXqytQADe6pQ/Ng4xKzYiX+mx87s6p2qZoz3Oz7SLFBabW1Ww5yKOWdYMVsHGN
 LR2So2YFB/3cwGKhu+h099A0Orqy/hxHzmy9vQuu7CxdQonGSJIa6ENpj1yAzP0/75SlW9UuYFb
 rjisW+++c0kPJzinMluoe0gdcdUAomepQv0oOTocQ+nC11IlvatWug+cw0/72x5leO/fWt+kueZ
 6JIaV/mY/YynM8HJSk+6HgQKA9xjDpVazh0cKZAmd+fdNru/iLvQ/P4wmCucFaIR4MM0/u0t0uv
 zmavFUVz12oTPmNy9Lb9IkOkjthZ26rODYEVkkOwxSAiViqYcWz+rvJlxbFbV/24/aARjQaJCzz
 j8//h1onbqvMW4+OP2Dhf2lpXfF2bauVBjlt1Ms3NN5VMkpIZbFnqpxHe2qroGN1hdCeeBXcJpv
 vrTujrPj804LvxeyEew==
X-Proofpoint-GUID: SnRke1UDQq_oxRThhDZTJI4cx9auW6Vz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020106
X-Stat-Signature: bknsjmw1hsqwf7apn8yxkxwjw8anpey1
X-Rspamd-Queue-Id: 70B7C100009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775131947-143224
X-HE-Meta: U2FsdGVkX1/jQC4lClajpcHlovQ7VlAhfaHda5tiKNbIPLWBFGQQImp9Xq4Rj1dO+yzvpQStwV5ADkguiD6Ymzt719Xh21ACG3uZr0iuh35WBkcF893Rj/B+l9iLHd4lHBEZ/xg5Yt0Uvl+lDOpOZWjQDWzxtoNRs8pzPXYfXYf4h1L5Rw8bWvTF2Z+nV3+cF3jyMXLpPM6ihCtmRXMvDxAd7Rr/xrsmS8EVOCrNkldo6udQMYcw3Hyj+6spWWbv60bKzlixsZrF7NGRP6e0fhgzGDAehkSrNkhJOLka1/msIeU++S7hXPQrl9qwzyg3JuFr6DZwUOIZXuujdCL/gisKDgWuJ+atTkjNkY5jCq1PdTRbozdHH99MTnzgQ2hxCOQkWff5406TMOmfqok0wJyvQJkoFCnaxOjnBgTvb0yvmmcBI4gzgl0zLZWininBmpC7RhlIjOWt51U5fnNVkghr3ZchFosFt0OzPrJMuyguob1SCVmzpXKUWKOcBC18n+cwWpQNYdK8bPwhiD9wpwfYvjJPx8qnzDPtsZpYqYGY2WJJQOo4myPQPSjd1ouoTB2Z75L+NCpxthvRoqreORBSM8hYFihLbSZ9CLcVRtg2UEvhcYD5xs3/HKehpBXSYPJ0DT90sbgC/xAsFeUCFmo7/TDwysfnvRQdDLzUSVirNxVtExfiqPIVrGtXKHV3ouJrYYjeKcFq01D0gB6kFrCh/WfIl8uhc8Lvjflcd0uW1m7ckexUd7v7NxxuOAJms19L/gadFTWdG42kp8A9k9ESAtLGcotKlADEzCcqF+gAs8JfE4I6P3wFHdnGzRFAk4vXuCb4PuhENziCoAIXfBfRP6zB5nHZIDsmzDrEx2KIoNd9ZcXk7aSjiRZj8h2Qq/JhgJ5TKC5rqA2iTz799TTEDciAWo+kkvWSQblfm6+iJ6cBi9lw8YholpOz82cSGYvzDbewZE+eqnhF8/0
 Gm0OYbeJ
 4oSUf2fPyPAOXfEDB8XpzgPXrEHEDBtX/q8+U4/zoMLfEY8coXeM3qnhwU2mWw1PjGJsoXuiLD+n4ZC1RdUlPUWbj2ZWiwVb/9S/I+9u0w7ksnvIAuulEFo8hgh1Rffy7JnuDM8x0bGpGnc+Dof03dYrpWNWWbWP2psxE408jNAZHQFagoH1MvyX3f2gxht25k1LG7HBMiI+Qz+MUkOALg+ntKIp++mIbZZzqiRYbna0gvq5B6SQ6Wk1RBp+dkMluIlpLMmHeQvgXuBdgFCDQAYQAgKRa93jcgGsGUC4cyOvyk479XP5A9WMbCdB4cnIuEP2VSWf01heogdAgWvolTK9C/9Le376x67P0mcHWPZeWarFJ+47AInHRqKA0shd44SDMNaEFA+yiT2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/2/26 1:26 PM, David Hildenbrand (Arm) wrote:
> On 4/2/26 09:37, Donet Tom wrote:
>> On 4/1/26 12:55 PM, David Hildenbrand (Arm) wrote:
>>> On 4/1/26 04:41, Muchun Song wrote:
>>>> Thanks.
>>>>
>>>> It's truly a coincidence — I also have a piece of code locally
>>>> that does something similar. Since allocation failure would also
>>>> affect subsequent startup processes, I simply made it panic when
>>>> allocation fails.
>>> Don't use BUG_ON, use actual panic(). :)
>>
>> Apologies if I’m missing something, but would it make sense to check the
>> section validity in memmap_init() instead of panicking? Is there a
>> reason this is avoided?
> Not sure I understand your question, but trying to handle memmap
> allocations during early boot should be removed. If that ever happens
> something is fundamentally flawed.


Thank you for the clarification—I understand now.

-Donet

>

