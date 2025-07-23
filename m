Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF86AC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 06:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7336B0093; Wed, 23 Jul 2025 02:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F9E6B0095; Wed, 23 Jul 2025 02:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C9F6B0096; Wed, 23 Jul 2025 02:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD35C6B0093
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:50:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CC571A05B8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:50:25 +0000 (UTC)
X-FDA: 83694605610.27.264B4B8
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 391D140003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:50:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=H0X7b5lP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf04.hostedemail.com: domain of baochen.qiang@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=baochen.qiang@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753253423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIOnuFzxTaTZ2kZliUHt8+E+wNhpF1ajP7gxvaOKN9M=;
	b=0gchH9fe1iE66cl/EmOKkzoOzbi8NPCuZxC7wGS+52/R491u9wkA6x45E8NMEI6I7IKteO
	jP5SgCQdSfL7pBgGCfYjsZuREALm2QbwUnx72mqgxtYtBDHBIer+6fks5S1Jpoe4EP1J9Q
	SojJiRnNLHlIfAzAcOmPVhmdJ16m/W4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753253423; a=rsa-sha256;
	cv=none;
	b=IjKzdoffvq7bKsLTCVPCj43lYQKJN2/9A9f1a9AIDP+Eh3a6Z9IdKG1jv79bJ3OcYvMEsb
	Djjs0NJJAjrmIOjjD4TWcd5E2hcluOuM67NUYsipyiz8P9DEH+0LlRsL7WJMMH1CgI9moY
	fU+mGx8houR6tMD24LU8uZHq/pEcXU0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=H0X7b5lP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf04.hostedemail.com: domain of baochen.qiang@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=baochen.qiang@oss.qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMOBcJ008190
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vIOnuFzxTaTZ2kZliUHt8+E+wNhpF1ajP7gxvaOKN9M=; b=H0X7b5lPIbttHQUa
	/nd3/wGmu1spel9ls30pCGoB6/MjAMVzvOBeEgRkJmgucsYZ9KmcB7RrjkoescBO
	ZuUPSdHP0NnPiJqHcsgZ3soWUmVVlIzbDn52ovyGOpxO9DO8BpXjbb2YAsQS0qnx
	O2vmupjs+ym+CInPbVTWrnOKsEGmNlEuiDK+IDc5weDIcvl/TMlaVg01D2HvE3uU
	FBJgr3++dgCMBrT1MZ6taDI2BtMVbQDyeMcvMcR8osiFywF8LcWGZ0dpoVPKeqxh
	5RvAWkl7VVUMRwaU7zPRtZo5uyZ75yRxFLCoMU82r5F7xe9mrUcWbgBmrNUfT2ix
	HtbAUA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 482d3ht5fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:50:21 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-235e1d70d67so61674975ad.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753253421; x=1753858221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIOnuFzxTaTZ2kZliUHt8+E+wNhpF1ajP7gxvaOKN9M=;
        b=XfwmE+E20VzTzd4UFanA7co9rzq98W759WrFYnBZyP/L1HCaMbuMa+xP+9sG3MWp76
         zvIrTdGnKiPdY8Q6jXRFjSNZpOBQ9p0/8WNkIKzqrEyPzsvi3qxWEflrn15jqScegeSB
         MT0U2aA+0mBvLt4707B8MKUiWAUMscdf/YQhGqfUXIIcx7JWZG8TdwxQyeHdr1PsOU2+
         aBZ6uCTNntw0sKMQTrQFaJYZLDCitp87SWxS2imH8phZJqHh1igscOeJ/hf2ddE4jfTe
         270dBWEXkUxwmP1PSIZ3vBkPt9iD4/CpNSWtNuJ4ZINjTzQ8Zov837cGw9eeIAWnaCqM
         20ng==
X-Forwarded-Encrypted: i=1; AJvYcCVjtepdBxToN6tMMIiK7BYmyh9CuF1waH3l7i7JVjkRX8tgECyN1CacdamOPHTrkO6YbvxlylXMVw==@kvack.org
X-Gm-Message-State: AOJu0YxdDZylMW/jUG0Wt1w1jUhYFoduvNRQ0GUzvm+Ci9g8mw2zkoW7
	HeVvxmU+7Kwa8zmaAxoPMzFoSeBukgo3F/fuCen1ssyTOf3UI6rfKtHOWGfHWl2cs2Rakn6OvNA
	DtjDFjnDiw/K7Eczh3Z7GSKOGNuGDZkesE9EGYlsHq+R1gWXzQB5U9w==
X-Gm-Gg: ASbGncvIbg3V2sEKa9NZ3T3qSlFbO9wFN61pI6i3YR/Nqbol1lL25Se7NzKSndIrffV
	bcGtJOd37rpiw8mxJrID4fuBbMYDBpsth9tO/JbDUjyHcqvRKPTiLNJc4QBycFK2VEsk+sLnBlX
	6drjaRho/D2EmsejKXsgQxfeo5ehbZtQ0U5k6DROAaVdYsFnnuHj+WeyK5MyxboT8tQHiE5vlHW
	efXgIkEWcCnT94A5zPiDQLgUqQACzgXm/eRDM5BFE66ktdC6ifLSCE/hL87lhNajHLcrWn96ORG
	xp+l7T+qEC+64BGHRXAfAviaVzoFVD9mXwH93b60cpTiTeQTgmdKVDRV4yxjTJzqu8jKjhf5ciE
	NmdZco3FVfiEfwGbnJ6r5ewTR86/YFRc=
X-Received: by 2002:a17:902:d501:b0:235:e71e:a37b with SMTP id d9443c01a7336-23f981aed8emr25652335ad.34.1753253420626;
        Tue, 22 Jul 2025 23:50:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHhrXo7D9/2ndR2uk0h1bpQY6uhlrFldB+Iw+IrNA9vaeHEV+mcRPFxDAlq8umwq1DbFFtE3g==
X-Received: by 2002:a17:902:d501:b0:235:e71e:a37b with SMTP id d9443c01a7336-23f981aed8emr25651875ad.34.1753253420102;
        Tue, 22 Jul 2025 23:50:20 -0700 (PDT)
Received: from [10.133.33.45] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31e519b1494sm891203a91.4.2025.07.22.23.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 23:50:19 -0700 (PDT)
Message-ID: <12a66199-3fe2-49d1-994a-84e4e1d2eba9@oss.qualcomm.com>
Date: Wed, 23 Jul 2025 14:50:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Excessive page cache occupies DMA32 memory
To: Robin Murphy <robin.murphy@arm.com>, Greg KH
 <gregkh@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        kernel@collabora.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
 <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
 <2025072234-cork-unadvised-24d3@gregkh>
 <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
Content-Language: en-US
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <c93b34ca-1abf-4db0-90f9-3802ac02c25a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=G8UcE8k5 c=1 sm=1 tr=0 ts=6880862d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=RbrrYmC37znnBZKoEx0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA1NiBTYWx0ZWRfX4MrMwmVQmB42
 enAi0fEpNEx6dymGGWzLu73/rM4B2k/BMhTLR01w63PCdqUVPP9vBXu50vE2nbtlpSNz1Udjfu4
 puA2vKiZwkoNbre7yJD34QBwAy8unpOvrNY74M8xQwYCOKei08YbrSzbffUaUjOpEi2HwO+g7Ec
 WiHxr6XuGFmZl/pRyZSizmz2zjTDZFSMx5YnqUEXm0K5nbIjm0fW7uel9ISzL0GNY5x16sy7Xy7
 nXEM/L3BHUdqqaYKPkZswI4Jzn64jAfJshian+Qb5T1psq3lQVHmWvdPO9EYZVcAKwAorEIkpTI
 uwNrqGe166fGTD0xuDvkKJIqyKE7hWhBAIZv5OrF/l/NUpThhgEGGkiFDITc6eOYpf7RpnvcaB6
 crKqEkqP1L4uYRwF8pDvRhXHLtHKOK1aYlHCVwmHis988oBr/dM4DkMOE08tTiQjULfovVPB
X-Proofpoint-GUID: zHlR6RKSxoUmM45R6a05BVMbul6e7wLK
X-Proofpoint-ORIG-GUID: zHlR6RKSxoUmM45R6a05BVMbul6e7wLK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507230056
X-Rspamd-Queue-Id: 391D140003
X-Stat-Signature: 3tu4tih88erekbc495ni8ir3ro91fp76
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753253423-885441
X-HE-Meta: U2FsdGVkX18DEPHn1S7kmQRn6oFvaD0jSl7ob5K5LHOi/O3p7kfJ6XpD3zZ6yeIAQjm9TsIOApaRIEgbKgzw17lnxhwJhKaPfYzngHJUZxOQUX/7LYGart+wxVW+ADPAl8mKrqbl9fHRDcTGdQalIMgX2s5/uBQJs8KjbSsdQUykSbf/iqrr1K9PVS+8LfSuF6dYmxI36LNJMT/zpdyQzbKrjMilIIQ8jSC0RopXiyyDttPennTun50VYW4SgreyNbAUkDdxLD0cNOIgr27Ao6y7EZIf/gNtvl+eWl5ogx+NUbel5Vp95Q1Qsz+xqhKiQQr2ILCk/hm7U1jLJ0+MaQpL5iIrWUgijnYyw9XBFuY7ixXc0HiME+K7jK76MuRr6BCEnU9V2aLXCp5aLv3FtPlV4TVcmg2Apugba7qu9SpQjTVM6FQV1gksrRAizFVgZeJZ+CqoUDvHCFvk3g1Bv+o64amkArQobfEQFKgdn5eh26jhboemCEvvv8DJp472ZXL3xsbpQEReV00GZTRTha6/4/xClzZfWJzJF24gayJrPG7QjtTk7jUVSOVzXQm5tQGDAQ8jpqxTWfVal5PUkmnSdlNfpU/SkFWzh3EWmlyjjgBf5KNBoqy/+j4PLOa2fLCOGy+wOE3gF6WyWdKm+evRtqhOpi6nI5MCqDis/eRjgIzESPlC1yIfWS13nA8NSdwmylMgoOzaT0K8LG9CjRGJ80A509l1wPRHPKAudKuP5w0qGwP+aPCij8cFmJOVUjqSQ3NCq3c0pcZA0Dhd+peeBinYPnSRfuRSAuUahi3BW7Umh6soET+jYbGFvYfBmTcgVTMJz206ejkae+ta/6oHYBepBFDhXhYCBnJhGUpIdVpyF/jVUFdOYZ3VWrhn9lz6BkYDAqWJje8PL54jl/JyBjapdowj+La8AFl85avBt1OAJ88yn7HPqkRqCTi/n8XszARP3i1n0W7Jjsp
 TkPgHFF8
 Iw7IsWN4NQpYwMU/Nc+I5mH2R0LMt7glm4q9X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/2025 6:03 PM, Robin Murphy wrote:
> On 2025-07-22 8:24 am, Greg KH wrote:
>> On Tue, Jul 22, 2025 at 11:05:11AM +0500, Muhammad Usama Anjum wrote:
>>> Adding ath/mhi and dma API developers to the discussion.
>>>
>>> On 7/22/25 10:32 AM, Greg KH wrote:
>>>> On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
>>>>> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
>>>>>> Hello,
>>>>>>
>>>>>> When 10-12GB our of total 16GB RAM is being used as page cache
>>>>>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
>>>>>> dma memory at resume as dma memory is either occupied by the page cache or
>>>>>> fragmented. Example:
>>>>>>
>>>>>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32),
>>>>>> nodemask=(null),cpuset=/,mems_allowed=0
>>>>>
>>>>> Just to be clear, this is not a page cache problem.  The driver is asking
>>>>> us to do a 512kB allocation without doing I/O!  This is a ridiculous
>>>>> request that should be expected to fail.
>>>>>
>>>>> The solution, whatever it may be, is not related to the page cache.
>>>>> I reject your diagnosis.  Almost all of the page cache is clean and
>>>>> could be dropped (as far as I can tell from the output below).
>>>>>
>>>>> Now, I'm not too familiar with how the page allocator chooses to fail
>>>>> this request.  Maybe it should be trying harder to drop bits of the page
>>>>> cache.  Maybe it should be doing some compaction.
>>> That's very thoughtful. I'll look at the page allocator why isn't it dropping
>>> cache or doing compaction.
>>>
>>>>> I am not inclined to
>>>>> go digging on your behalf, because frankly I'm offended by the suggestion
>>>>> that the page cache is at fault.
>>> I apologize—that wasn't my intention.
>>>
>>>>>
>>>>> Perhaps somebody else will help you, or you can dig into this yourself.
>>>>
>>>> I'm with Matthew, this really looks like a driver bug somehow.  If there
>>>> is page cache memory that is "clean", the driver should be able to
>>>> access it just fine if really required.
>>>>
>>>> What exact driver(s) is having this problem?  What is the exact error,
>>>> and on what lines of code?
>>> The issue occurs on both ath11k and mhi drivers during resume, when
>>> dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
>>> been observed at multiple points in these drivers.
>>>
>>> For example, in the mhi driver, the failure is triggered when the
>>> MHI's st_worker gets scheduled-in at resume.
>>>
>>> mhi_pm_st_worker()
>>> -> mhi_fw_load_handler()
>>>     -> mhi_load_image_bhi()
>>>        -> mhi_alloc_bhi_buffer()
>>>           -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM
>>
>> And what is the exact size you are asking for here?
>> What is the dma ops set to for your system?  Are you sure that is
>> working properly for your platform?  What platform is this exactly?
>>
>> The driver isn't asking for DMA32 here, so that shouldn't be the issue,
>> so why do you feel it is?  Have you tried using the tracing stuff for
>> dma allocations to see exactly what is going on for this failure?
> 
> I'm guessing the device has a 32-bit DMA mask, and the allocation ends up in

Yeah, the device is capable of 32 bit coherent DMA only.

> __dma_direct_alloc_pages() such that that adds GFP_DMA32 in order to try to satisfy the
> mask via regular page allocation. How GFP_KERNEL turns into GFP_NOIO, though, given that
> the DMA layer certainly isn't (knowingly) messing with __GFP_IO or __GFP_FS, is more of a
> mystery... I suppose "during resume" is the red flag there - is this worker perhaps trying
> to run too early in some restricted context before the rest of the system has fully woken up?

the worker is running at __resume_early stage.

> 
> Thanks,
> Robin.
> 
>>
>> I think you need to do a bit more debugging :)
>>
>> thanks,
>>
>> greg k-h
> 


