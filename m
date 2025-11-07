Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC841CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8DC8E0003; Fri,  7 Nov 2025 10:34:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80D38E0002; Fri,  7 Nov 2025 10:34:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96568E0003; Fri,  7 Nov 2025 10:34:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99BC78E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:34:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F81D13B349
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:34:44 +0000 (UTC)
X-FDA: 84084208488.13.30FCCCE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5453A160009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:34:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DmR+SrlZ;
	spf=pass (imf08.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762529681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmobMJcsCJcwwI8/kU9x3dKjZAgMtB9UEjqodE7qgtQ=;
	b=hrlGXwj0o7tJBeK9wN0ymlLOPJw61U7MD2lt7syzp6WJeHShhKKsvP8hT8+px22YwNVWpd
	I/wCINJ5jz6JLmTNh0j4gu2gcAGfU21FJf1XhdOIL3Pjx3Qy8B8p9oHCRY0xVEvezUeujN
	F4MHODLaTFSoeuQPa635Nl4PoLknnMo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DmR+SrlZ;
	spf=pass (imf08.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762529681; a=rsa-sha256;
	cv=none;
	b=hTvys4cvqgBKSqAKWp+1NsNCBs7HHSl/KDkEor7DCuG4Qjh6C+xEN8ZSQSEeKvL0dVraHY
	ly7OX4FKHw4wJVKPz0mikNqp8iUDpiepMAOTQXak6rSeKvkwFb5lfZf+s9rRLl1z5HktQk
	VbxFzI7nNQ8ZQ2XG4EZewSF3OIrb2iI=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7Esa9i030417;
	Fri, 7 Nov 2025 15:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YmobMJ
	csCJcwwI8/kU9x3dKjZAgMtB9UEjqodE7qgtQ=; b=DmR+SrlZ3fFDk5y5DrqJaT
	3VNAlrbHI3fbIVIIfQuSOUZmaDcmiW5rtMKGQHOzzJ04wFm8YLMkYv1NcL+KQaJE
	lPEDYOcTmjFNF/p0YFfCNvmROk0oQEsMOZDvOooongidOY5M2cHVPPAmuLKcSrtv
	CWF/ZGW/Bi3qlJlf31e6dk8MlfcHFFKuE3yvkdga3zL8u9agbXVY4g9lWbeWVWoN
	lE17cVSDpz2AhE67XGImcDDsLZeFYoFPDxLCzVQiUV0gbyjYPaIgiRb4oywkLLH3
	Bwa2yq0OkfHrCI7XuSZhjvG17bg0R4Ty5vqMtj3CS7S8CVGYSLpXVikWDmd82m6A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9jxmr7v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 15:34:39 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A7FX6mu020594;
	Fri, 7 Nov 2025 15:34:38 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9jxmr7v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 15:34:38 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7CTAXt021482;
	Fri, 7 Nov 2025 15:34:37 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrk37jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 15:34:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A7FYYFb52167018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Nov 2025 15:34:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0097720043;
	Fri,  7 Nov 2025 15:34:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0222A20040;
	Fri,  7 Nov 2025 15:34:33 +0000 (GMT)
Received: from [9.111.68.113] (unknown [9.111.68.113])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Nov 2025 15:34:32 +0000 (GMT)
Message-ID: <72ec25d5-e077-4a84-9eca-ce886e2aaffb@linux.ibm.com>
Date: Fri, 7 Nov 2025 16:33:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] s390/fpu: Fix kmsan in fpu_vstl function
To: Alexander Potapenko <glider@google.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
 <20251106160845.1334274-6-aleksei.nikiforov@linux.ibm.com>
 <CAG_fn=WufanV2DAVusDvGviWqc6woNja-H6WAL5LNgAzeo_uKg@mail.gmail.com>
 <20251107104926.17578C07-hca@linux.ibm.com>
 <CAG_fn=W5TxaPswQzRYO=bJzv6oGNt=_9WVf2nSstsPGd5a5mNw@mail.gmail.com>
Content-Language: en-US
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
In-Reply-To: <CAG_fn=W5TxaPswQzRYO=bJzv6oGNt=_9WVf2nSstsPGd5a5mNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BZvVE7t2 c=1 sm=1 tr=0 ts=690e118f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=ZY0oy1BPkzOObeRiG5MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDEyMiBTYWx0ZWRfX1RZyKuD66vMJ
 eIa01JZb2JMXI/qy3VPM6vE5n8WCXkhlk7uNzUQ3CKuEowwO9zxk+mUQHNTenHEnZ+p6IGqc6XI
 lUSONTvT7bnW9zpujYYljr33v16OeLUdaS47nBkbkEawXqKMz+XDgEPAAfytDy3dTbxtxnDgrJW
 ovTJPyF1HIZj5T6PXTLwZtfN48J6n6gnrTiOCV8S5zcl4D6OLSQG40jW+WsojAHelO+5LE97xNY
 VW4Z6HZst5bBxX/cmR2T36OPbKrYqdy5hBbRAhKslspln/Fq07HojJBxxsdOJzYTmiXz3Rfoeo1
 /p7hLGZymH4A9y/e010XxdUHZrGjT/Book/aNbVF+ojiUDTZ1VdTdQ78J87+EjqUY4wXEmmM/cm
 wq98K0wWihWsN9KYPgB0EC/bfr9+Hg==
X-Proofpoint-GUID: 9qF3Hk4uKD18vkj_pkFjCP3ioH97AV6j
X-Proofpoint-ORIG-GUID: b4Vc7OTegufQwkjfSDN4buqtpdpRwd5v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511070122
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5453A160009
X-Stat-Signature: 6kz6311a9jncraddx5by3tkr34qz8oct
X-Rspam-User: 
X-HE-Tag: 1762529681-921909
X-HE-Meta: U2FsdGVkX18zPSE4CcSGFhWnOB2c/QcR2HkXOKt0xs2ZC6G6YCuHZfKfnMRiIUmHxwOVmBsxyBpVvcytCv02F6PJ97W/wbuj793MCRnU7srWADHY4uQPcFXuXB5bHUY+vFGpf+qct9EPNoVIZll1lwYYID731xnfUsfLG7cEXEqKZqlaiIhoFP34tdjiVewyMpB4uYPOvgPlaOkQU4oKRC/ygw5ohYHJBy5RtcbAE712Hdzco6+BX3gihgavdBRxOboU7KvEeO37i4zpQpLJq4RV8fHAn38kKZAdXvZP7fCCFV9d6/nuLaoMQnUVgpf2K9zLbCKwo1ieMzIt8+S6aV5Ei6m2cVZAVVmcVDKxHYWYKwgZen2meKFDbDFDg7IwOQmBLiXQOpBKiYdweQSsCgNtVTwLw49lxucG3h+RAOQd5jBIcB/TU9/CMhMeL3cO0MLcR9Je1cVRVtPxBvsbZIvNOJHEgSPZr4zWuZkNfpBQzZPfaBD5QN7KrGA2MIH7zMdsOw3tGrkoYStuVvglwMUHXDNAd+C0WPykc7CIs61gNgOwYsNWY2pu9U7q9/pmovE6jpZWhgOOg8bECneZSIgkpkFhBHOvhDy7LZqDXqEy5Yqd3G/43Q+b6DGSXRW/O+SaZgjAF0KAG/JeTl+RANZbTNk1TBeHQwglFU0qjj/NOTK54tdT9ad2tJJ+vxkn/s300DLBvRPJ3AEpowmg9jl9NAfTP0WqGY5c03tqFFYMeCRHEIZOOB0EckxbvY+wKmERmRnRfAfIJbMzBLZEM0kC0Ubdz2jF68wHIi/2nU53Yh/Xf3uSdixYRMvbycHIurkdPOELpgMe3b2+gff3LRb3orzLwUkKMQXGPB5EudFwF99AgB42/6wnpRfAwY2Rgk+XOVAn9LMMG95nsVefPI7VliAr9vje27VB9ZuPiDiQR5b8+e7KMPY6QCXgF+F4UpUZ6cS+goniuSPqKrv
 bJ8x+T0U
 1Dq4YyhYzXtStNoOorrEu82Y6fpIuZCHmPO4PXlMjcBobReY2gIrzq8cs4wrPIWAHrZSDf5k+iG+CN0gM/JVdiAs6GYlsd2CZPCs3UnBMQfwOY8euX/Ui1qzc5sxKVdVaTJI7E6y7uUmOiX8XUgZpvUVrqpAK1/BL7zSQVSmNf7EyQ34rDuz4weQSdt+J+Gy6o8RI9etu0v+MNTyWbkBd8ctyp9n0Fnp+b7D6LjNMDpVr/wvv7jSbY7IIjKnI8zlqbx4Xkc8PF7eVqJMk8v8sHU/aFgmt+KM3pZGkOCKen+aI0Y1G9wsBJD+M+JzBEah8BkIFT1Aijn8tkZ/6R54EZGAt9bWcYlzUtP2liXoOoAzKbxdbsFV/z2dgvtC8unLynw80h2b0BY/XPp/NvSdeDIW+ZYsW/GTxUeNUDIq+sz9ObsP95Dm4FRhKV4fIH6xMgu+a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/7/25 14:32, Alexander Potapenko wrote:
> On Fri, Nov 7, 2025 at 11:49 AM Heiko Carstens <hca@linux.ibm.com> wrote:
>>
>> On Fri, Nov 07, 2025 at 11:26:50AM +0100, Alexander Potapenko wrote:
>>> On Thu, Nov 6, 2025 at 5:09 PM Aleksei Nikiforov
>>> <aleksei.nikiforov@linux.ibm.com> wrote:
>>>> @@ -409,6 +410,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
>>>>                  : [vxr] "=R" (*(u8 *)vxr)
>>>>                  : [index] "d" (index), [v1] "I" (v1)
>>>>                  : "memory", "1");
>>>> +       instrument_write_after(vxr, size);
>>>>   }
>>>
>>> Wouldn't it be easier to just call kmsan_unpoison_memory() here directly?
>>
>> I guess that's your call. Looks like we have already a couple of
>> kmsan_unpoison_memory() behind inline assemblies.
>>
>> So I guess we should either continue using kmsan_unpoison_memory()
>> directly, or convert all of them to such a new helper. Both works of
>> course. What do you prefer?
> 
> Upon reflection, I think adding instrument_write_after() is not the best idea.
> For tools like KASAN and KCSAN, every write has the same semantics,
> and the instrumentation just notifies the tool that the write
> occurred.
> For KMSAN, however, writes may affect metadata differently, requiring
> us to either poison or unpoison the destination.
> In certain special cases, like instrument_get_user() or
> instrument_copy_from_user() the semantics are always fixed, but this
> is not true for arbitrary writes.
> 
> We could make the new annotation's name more verbose, but it will just
> become a synonym of kmsan_unpoison_memory().
> So I suggest sticking with kmsan_unpoison_memory() for now.
> 
> 

I'll rework changes with that suggestion. Thank you.

