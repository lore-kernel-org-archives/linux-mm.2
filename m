Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A76CCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDD86B00C6; Wed, 13 May 2026 12:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B51E6B00C9; Wed, 13 May 2026 12:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87DAC6B00CC; Wed, 13 May 2026 12:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74ABA6B00C6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:01:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22E828B893
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:01:29 +0000 (UTC)
X-FDA: 84762861498.10.8108960
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6844B4000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:01:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ISurssXt;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=SjpPOMI8;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778688086; a=rsa-sha256;
	cv=none;
	b=NcQ+y2uekAyPebpoqK+Zyd1Z1FA3z6hZasY+nSYLrBcFSdExvlA7TaWNTSxgjmavpHG3wD
	pDLBYwBJvSa70julqDbiXzWTqRXgj/6dQVyFQMGx03h3ug1D50wnwKJ2sHWQEL5U3unyh0
	ddHYR2oc/pEuFqXGuz8TMRc8A87seDc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=ISurssXt;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=SjpPOMI8;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of georgi.djakov@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=georgi.djakov@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778688086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i2GVjQ/hbSIakHx6hShMfu9qm3Hf7l4LQl2CGZ9VTo=;
	b=YeJhw5bcOuRhyf6mzH6DjKVqJLIMCy8v93ow7cn3xFGzJikeNeUcAS7t0hl914dAsn5ZHL
	6KdtvB7cNPpNmkxTECJ4hoPXnVI4iB1+Cf9aWAkZuIMOkZMzRg30wO1Gpo5KooEyJ7ft7J
	dxpTaioUzCzbui7Xs1n5PCKRs5XXeoA=
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DF4qMl2887823
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9i2GVjQ/hbSIakHx6hShMfu9qm3Hf7l4LQl2CGZ9VTo=; b=ISurssXtH9oxiRpe
	98+ATJHGwlVl6mVeCRjEh8mTFXE+AANB9OHkDzuS96rEM/nqO0p61vH9RtvhBcp0
	qJZzQb0nnSw7iO5pOo74spoA7qzFcTb9tNfZgye2WKnW7tQDplGQi1AfBRQaazTM
	PeNgqBNaF5szf5aUnRHeBaw/wi66vZvbSDnm3EQ9Kul5qWbN9lc1zXDGHxmZSn15
	jD88I1DGRcwPcwvXCQIOuC0WNLrMYp62WP/3OMw88dDxhspyXWEFZOp8HANTuCH9
	TqLCv5laR8ke+U1skxBjAkmlKERQzsTTqBoBH+3a3tUszkDhcb93a1B91ILcJKBh
	gKtnwg==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4p4ghqdu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:01:24 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-132d631edaaso20024697c88.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778688084; x=1779292884; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9i2GVjQ/hbSIakHx6hShMfu9qm3Hf7l4LQl2CGZ9VTo=;
        b=SjpPOMI8B9dxQLtQczo8y0r7nBglqwqnQJ25LKKRQbB43cCoL+230RN65/GcIqKIAd
         KDdqYNnu112ytMndCExZ7MMkmes0V/x36FQ53R0SvUK7GOQD7vZEBPj4LP3Zvan+S4Fv
         pKUxIiBVcwpuAvbzErw/j6uLmkjzC/AaobesKnmIVPsc/igS6GiFVDX6encuEa9n2O87
         cvvu/lcnABcnqcKjVGu41r4KvpUQbuRDrkTLJO4S2Y4WgauXbpCftPJubgAO1aumgcCI
         AcPDdyQb94kzmVtyD/uIse8qMWWaVrTT0aYc8XD1epVCKukMkm+Dt6Qkn/csrCXWA6VU
         AFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778688084; x=1779292884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9i2GVjQ/hbSIakHx6hShMfu9qm3Hf7l4LQl2CGZ9VTo=;
        b=o8mGKgz1dcjVvmKln4gCy1v+NNj51cSvXW6tekudNQNLg4Gi5R1ATMNGVonJBTk7/6
         P30Wkzy29yllMsAQaZqOOgWirvTaUaphRm4GR3ugDhJ4tKYsJRiTO8eaKsvloCsW6GqT
         dPDWldCgCajb9Y9Llnvj9fu73gP52XbvzvqVxzJGbkqNYiMDIFuXXW60fhY36QsYrUG2
         8BBCCWQ0RnDPAmRv+iK9nyYKYQEuV+JO+y/EK/LkFh0zvwwCVjPTJ8Ws02uCNCO7xQQi
         AEMECbLIwB7HnrgnyL+mkdNycODJN6dyGqg24tZQgzaE7BSjZj/FMqcqp4PTsIrQ6LFR
         qJqw==
X-Gm-Message-State: AOJu0YwtF1GFPkt+mkEFYNKy6xwDvjbO3031Snu5yvSElNb+KinRSdRQ
	z5GSHv2+QWh1YZovN/nQFKPk2MiWdzIFOXX5xkmntgfFTSAUqIP1ewNdWDzjqjeOqDJhxUKmuTx
	ECoacXpJikURWcspXammEvNh46BLRQkkCMLJd0d5e1Ep2s2DppqG9Cg==
X-Gm-Gg: Acq92OGzrCoA5fpujVfIZeDloh14sMg2Zi2cT2j0UGeMpSO6FUdWRZjEqSZhA0XA7ml
	ivwL1hxdKh0SALSJN7XOyDf0LDd88qnSPbIObagFLTaWdn1WLwUQ+IsGmp8bDQjUlgpWMHlenjo
	fhlP8SJkuyZRv2KBhp9ErJibt84pbxCxhaDxSb2FBL3Q8daV4paYmp9fjNFPEjQOmjpokN+CRCa
	3S6rwMlts1mWVHUpTlzPPKgpV0r/zjta8fknJJuLh7Rtk1LKx10vcFGnGmIY1JZGweXipzoMBrA
	JqUNpSv+pCJVpGzc9MYF+A6iAQ+/NJddHuFOk5bqlSxAx4puQ0d6oUruESPgyJTxGJ74WVGOCNi
	d7y9s7mD5U+0jN3BXiWMQVx+zTRVODnouoVVvX1Ti1C9bzeUZ1TbC
X-Received: by 2002:a05:701b:2513:b0:134:a701:de8 with SMTP id a92af1059eb24-134a7010fd6mr983179c88.5.1778688083938;
        Wed, 13 May 2026 09:01:23 -0700 (PDT)
X-Received: by 2002:a05:701b:2513:b0:134:a701:de8 with SMTP id a92af1059eb24-134a7010fd6mr983081c88.5.1778688081428;
        Wed, 13 May 2026 09:01:21 -0700 (PDT)
Received: from [192.168.0.31] ([212.5.153.243])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134b4e153dbsm2062086c88.12.2026.05.13.09.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 09:01:21 -0700 (PDT)
Message-ID: <fb932d7f-0ba7-415d-ab36-e948d2bbb537@oss.qualcomm.com>
Date: Wed, 13 May 2026 19:01:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: set mem->altmap after successful
 device registration
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
        gregkh@linuxfoundation.org, rafael@kernel.org, djakov@kernel.org
References: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
 <f25f1ef0-5359-4c00-920d-cdfc37cda968@kernel.org>
 <a3eea8f4-d693-41da-b8ab-764e6ce311ad@kernel.org>
Content-Language: en-US
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
In-Reply-To: <a3eea8f4-d693-41da-b8ab-764e6ce311ad@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 0BsklaQETYhmCBp1_5TLYlpJkKIaAvHB
X-Authority-Analysis: v=2.4 cv=DOS/JSNb c=1 sm=1 tr=0 ts=6a04a054 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=douLNevBrtimd63D7eljNA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=h-BE1Ed2neb_JwLtZIQA:9 a=QEXdDO2ut3YA:10 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: 0BsklaQETYhmCBp1_5TLYlpJkKIaAvHB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDE2MyBTYWx0ZWRfX3uEFfNXTdeFq
 dxfaj+5xdVRSAOZWkm8zm0maRHBjs5eElKrXVoC6r55fRE8RJV0qVBwyUdRcyZ7FdioB/fIE5tw
 q1lwN0EgEVN/KLnytPWNsrK+SK+md3s3DlDpl9LfITLrvP6DGeCpEiXtIgUO4bjv+EcMLs2R04t
 EKLPwUPY93PCj/EdkdVK7zyeOsgDkxryYIcOa9a2YwbcqmdKCHgnLTajs821SwJH4JYjyq2pv51
 kSafWHAa9tzIYj2P6m4dFf6d0rsNkgxvUCYjORwFRH9JEJjKnMWJiS8ii5SwEjXAUKvmfYNqkDD
 QTFnFx28GQgmI6/pyPmHsKTeDKBtw/fRfxRsE4XAmPkkcE3sHt7XZRGuQDYrj16HKD1+/5h60Mx
 jIqVNcX8Cb45XxEMzCKfrP2Alu4+hib6oHBVP0QtUWs4IXRaRdfmwRlTiSjR7TUcVwVer4fqu17
 +WBL2J0rdiU2ctTXfgw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605130163
X-Stat-Signature: jubtt167fqdj44epw1reoghxartcrzm9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6844B4000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778688086-135985
X-HE-Meta: U2FsdGVkX18lAO+st3+Bfmgz2O6T+5VXOMA22R/VkzYilXCyBXrNWkzsE+mXE+5pwcHU1DaSNKJHKC8tTYh71f5ofLZ9uGW6vg6oAlJOh4JrpA4g8fIh86AOgE1pF+A4TIZWxHqebOGXJaE0IUG0L1S0AVRFifvMUMUN058niIP1RG81dW9NUZDcvBzx2YzmxO+Y8xEf/x1bW1htyJqS3Q0auMcqXEkxECMdXIUqccu0g4AZy/OLUd/hdVQ5kStDy6Fq2n1sSyEwzhc8UvyJ758RPqgH1GwatrJUMfGh2kdCHO2aii8x4yfXz7N6gE7DbXoLLu6a8Ebiy7/965PJ8EvdKCr41W2A9HAl30SlizhFtZA4QRzbOaLZa6Rrmgq6++fFrx4ozW5Iwlxn17XQTHWsbhjegUakJRL1O2pRBH+8C5QmyW/iXsSMYxk88zdjabzfrq/fHLwr51aLQblJnBvmdm7M0hIVgpPtsovqHS6PgsLiAZ4+KAHRchpoUX1rc5DMAnpDFReVMCmClL63FhrrKwbGa6+YMZnlIN5hR3fHtQ0dcv1u7JxxEa3TQf/6IiJlh1CPYAPT51yOww4q5p3ywwnWdyke+fDRE3l1Wu7iIwjBifI1dRD8BZR4io613OHx6HONRza2oR0yWWbGCJNKWgOC8xF7MTKKpb8x5ZwS/Ubo1DD9XZlCEY1/uszzf6iDHs/VmuKKFF/zxLqe1PSTINlA8m4itSW1QcSMoMImkO3rohsxDD6zvAhQ+eZBnxp3MlpczZuinD3oXeBH/lRtnHyAF1Hz5tfXhwsAG/PZXyqaaUdIPGarh6DPEy9+aqp/MeE5G58N8+GmkMtMY4voXUwIBQI7NBkuDVKigSmMO9SK1y3npT4M5uyekm6gZy2xd3uJjFHTiIXOfY+G38vKJdAkpyX9+S7mdy6mgbb+oX79nRE73zBrZE/VubwAN/Axxzhba8sAa7TO/TJ
 O+7enYQG
 xb0BmBA4i+FHQX3rH9S6jQ87UEM6xfJB7dowP6JwZlH+1BnWG0RNAbtCi+En4lHYbJ0H0vsro1JCZ3yQA69Iutrk3WgbhjTukFyiqP93fHXsC/I+lgFm1+o3wKH0xLw+J++oUtCH7TkjyJPG1bNmhrHI17JABGHQjg8o9W+xyA2xqKTWhhC1kFnaNfWGSaVM+Sesiz386h58GeNRjjCg0LettgQcQV7oFYw4O1Nr7ZLHA2NbUxDgU2NEB/ZUmZgCYow2ORMQ8F35+/B+YiEhmIlLQ8c3aleaHcOX7223a10qDAWFfmXSVo3ao85VZ/9E469hMbiqm7e1KpCQpNptCOj4b913x8lQujwci2H3MhelG8xv9Fw5o7wghjBUFptu8htFxqOezEI7xjKDRp0uguQKbdz174SXY6L8/IhqCWpm1HeJ9fwrqxI9xn9fSwfz7928xjo3fQAXyQIjU8b1zeR1UOQ59OUEmv8JTmC1UCjORPbQJ0YA32JwhxcML/ndVFyx5xVKruXQUri7mf3Tcsg0v8jgYUmi0dwh1Wd7nPQYol+hKxowiIVr+9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 5/13/2026 4:20 PM, David Hildenbrand (Arm) wrote:
> On 5/13/26 15:14, David Hildenbrand (Arm) wrote:
>> On 5/13/26 15:09, Georgi Djakov wrote:
>>> If __add_memory_block() fails at xa_store() (under memory pressure
>>> for example), device_unregister() is called, which eventually
>>> triggers memory_block_release() with mem->altmap still set, causing
>>> a WARN_ON(mem->altmap).
>>>
>>> WARNING: CPU: 1 PID: 76 at drivers/base/memory.c:96 memory_block_release+0x28/0x30
>>> Call trace:
>>>  memory_block_release+0x28/0x30 (P)
>>>  kobject_put+0xc8/0x1bc
>>>  device_unregister+0x2c/0x68
>>>  add_memory_block+0x1b4/0x214
>>>  create_memory_block_devices+0x9c/0xfc
>>>  create_altmaps_and_memory_blocks+0x130/0x1cc
>>>  add_memory_resource+0x10c/0x21c
>>>  add_memory_driver_managed+0xb8/0xe8
>>>  virtio_mem_add_memory+0xa4/0x194 [virtio_mem]
>>>  virtio_mem_sbm_plug_and_add_mb+0xc8/0x16c [virtio_mem]
>>>  virtio_mem_run_wq+0xea8/0x1088 [virtio_mem]
>>>  process_scheduled_works+0x18c/0x300
>>>  worker_thread+0x1dc/0x2b8
>>>  kthread+0x1ac/0x1f4
>>>  ret_from_fork+0x10/0x20
>>>
>>> Fix this by delaying the assignment of mem->altmap until after
>>> __add_memory_block() has succeeded.
>>
>> Something does not add up here. How do you get an altmap with virtio-mem?
> 
> That patch itself makes sense, but the callchain does not make sense.
> 
> virtio_mem does not set MHP_MEMMAP_ON_MEMORY, so it should never reach
> create_altmaps_and_memory_blocks()?

I have some out of tree virtio_mem patches on top that helped to trigger
this. Sorry for not mentioning it. Should i remove the callchain from the
commit text to avoid confusion?

Thanks,
Georgi


