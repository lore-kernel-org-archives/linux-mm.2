Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7F5C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5098E0003; Wed, 23 Jul 2025 06:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5950A8E0001; Wed, 23 Jul 2025 06:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484418E0003; Wed, 23 Jul 2025 06:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 372008E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:22:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A50E1605F3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:22:22 +0000 (UTC)
X-FDA: 83695139724.24.64BE550
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2586C0008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:22:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=VGmSnu+l;
	spf=pass (imf28.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753266140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNxrS9IK4cL7Ss6mUg+ikQpJdvmZ/XTUdkMXpeueyWk=;
	b=ELf5qOs5H6nfQgmuLY+bO4kSOMMMen+ylz/lKBMDCaR269P09KbwKJYo6XjtDUIteAB/7U
	R4egQlxBHfJNe4uc4kdG44meVmopaArE6Fto5UuMH7i36EZMs5oHQVM2ZFBE1IqiX+E7qX
	4MpaMoMP+gQTY9OdESsJqQCHnVVaUwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753266140; a=rsa-sha256;
	cv=none;
	b=4D8XqcLwnpO6ip5w6hebLmJXox3mRZAxUFzPRYDrNBw1TkqWJbkcGQGpwNbqYWO37FBmqb
	BNzp/VarexcdHetTcrY3ZBP/xbvtZJp5nnzVVYmixvvIxoios6G1IbgIE0NU+7WX2g8kvW
	PsLHth0SQlw8XH9xjzVMOyQwzhVmavQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=VGmSnu+l;
	spf=pass (imf28.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N9QQhw011723;
	Wed, 23 Jul 2025 10:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yNxrS9IK4cL7Ss6mUg+ikQpJdvmZ/XTUdkMXpeueyWk=; b=VGmSnu+l7QnHeMTa
	FqbwaIsAoMlOhDEcuDKCVrDZBfJtd1bn603Gs/x+yn/wgtFxQUzy61fzt02jxEz4
	rfSMJcw/c+EsnYdIx6JgfPSH6mTeHu7uVNa5LZNAh48P06ys/b3xwYQ40QHsiJfb
	bgYrMsrkJyjlVYGCGS9c7mpQroFGodazrWM6HbDuXsTeZq5BACBbuXPt0XJHWj7+
	QuXDyj2x+bxVg00P7Hz6FSZ0iwxYnQLzXv7wj8x9zHeawcWlsnB9jIw6HxA3U3/P
	YQcF0nf+lw6kQtOiBFrNH8ETRTVSlpBJJbVtUDGlFDFw2nnp8DXP9rauIuqimcY1
	tmeF+A==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48047qcs69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 10:22:16 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 56NAMFSU019603
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 10:22:15 GMT
Received: from [10.239.132.245] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Wed, 23 Jul
 2025 03:22:08 -0700
Message-ID: <8b27bcf4-a404-4585-aeff-8627b5a857d1@quicinc.com>
Date: Wed, 23 Jul 2025 18:21:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: slub: Introduce one knob to control the track of
 slub object
To: Harry Yoo <harry.yoo@oracle.com>
CC: <kent.overstreet@linux.dev>, <rientjes@google.com>, <vbabka@suse.cz>,
        <cl@gentwo.org>, <roman.gushchin@linux.dev>, <surenb@google.com>,
        <pasha.tatashin@soleen.com>, <akpm@linux-foundation.org>,
        <corbet@lwn.net>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <quic_tingweiz@quicinc.com>
References: <20250723080328.4012263-1-quic_zhenhuah@quicinc.com>
 <aICpMWKNvhveAzth@hyeyoo>
Content-Language: en-US
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
In-Reply-To: <aICpMWKNvhveAzth@hyeyoo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA4NyBTYWx0ZWRfX3RWxdp1wRZeo
 /Syi+Ukv/yzctBfhOmWsEm/txu1epiFE2VrTxbeHzuwz2bbRpdb1//3nhjUmHVKlfkjUzH93Uku
 hpA6UX5pOekg08AXflt0kCarevxXDGS7YuvFMM71pq5zsHJFgGHaeKw8MJKDIT5ID+pHYadXo2r
 G+wHl9AcFWxxb+8WHlMv8b7MKJnCP7p5EyffVO3iLyuTpninrC+Qxr74JR2Z5CdAfF3OCJscdnt
 N453X6a3lZtBKQMzj8HmawKPj6HM8mA9wHwaj778X2yYbdsfqrxVNUW85gK8NroiEXN1fW0ZdEb
 2W3ntewV3AInjVCpnI0CMXQDKmZeQygJh4OLTxehG/rcHt9TCsuVCf0M7gdujfqUKy1T0XuHdhi
 ApBnioBvQIVqMboJkgJjLCsczumf2VFF8XxU8P3FyHRoepjjIUejdQVOOGMWGyBWlkAaZDO6
X-Proofpoint-ORIG-GUID: W989XS8cwhmKOPK8S0xnJadsfrbQBgag
X-Proofpoint-GUID: W989XS8cwhmKOPK8S0xnJadsfrbQBgag
X-Authority-Analysis: v=2.4 cv=IrMecK/g c=1 sm=1 tr=0 ts=6880b7d8 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=COk6AnOGAAAA:8
 a=YiAHnlY7IjyBXpNbUysA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507230087
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2586C0008
X-Stat-Signature: c9453hiu8ayoh1d9isor35arf78niaem
X-Rspam-User: 
X-HE-Tag: 1753266139-119777
X-HE-Meta: U2FsdGVkX1+lUojoIM5aQ2ZfIUJI7MNeIVz2SoNNKN1tvMjwDTIqKQnWjovBjYkBky++JKHqzNR+Huq6wKR/vRHSTdSBPyRi7Oru0V0WA94Be72pWh/8hwkuGaNxWF66kf8vv+01XG4qSEbHKrYoaa39CpBpTAbEVngkva+aAMveNoISVEQLzbH342Bf2LmNZaauUS0IWjFLGKFVD7fUYRM04ZZ7f3lMVlgQoiX1gwDs1gDa3UL1FBtvaXu+AjbsJGxTwlBECHx4lmffTwXfahufkGsFI+6qvQSC2wUBdIqFojLm8Pxv/CpdZTGL13ETqp2eLqLWTqvjTjgEXliKl1gYQRnFw9BH5U99rnM0Kht0n3ZqcqWYeUd/leLV7+sQemWBxWYIMmUq/9xjSE7CcbxDqdkMhjCBRcjgDAAozPJGUc+1nseTiN1XNK/wAKdqfH7OwEUwHsikHZ4XyoXJEdYj2Ds+mK1XAgR8RgVP3gvrpDlK50B/nCI5iAmauY2ioieqSBrJdpE7M4Q+xw8viyQZr0d8WBcFve+zHWZzxceuMNG6mojYZKK8a0vv8mSd4x/Y4ab50xeKoMVg+IB2WQYrpouZf2FnEJXmZxzUS9Sga7mmk1hMRsYvO7EzqiRCyp+z9DH8KR8o3WzbNyluQgvF5+bEDUN0cmQrsOpwC4FbCXCwgGKt9hspXIFyEHwP8fe+gNRJmO7zu+uL29NhYNpZLAczAFpmJK4uwgwDl73zbnenTukTvaY5oiDPhl+W1m293liUHJeNrNbXG9VOIneXur1yD00lUjEBcgoBxAHQwYDkrh4Bf2qXLKSOOhPMvgXl/f4kyzZpIUWNWUiprmQc07rXKbJwL1oRIQ7s6vkGVLSJko00ClTLgl09i7Fk9Rdbx4q5T8DlK1BQ/RQskpVOOlczvv6ERn/c7sPVCCUGOMsnpuS/GMRGi56OgW9WH8H+tWqqVHMAbag0fMn
 c5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Harry for your quick comments.

On 2025/7/23 17:19, Harry Yoo wrote:
> The subject is a bit misleading. I think it should be something like
> "alloc_tag: add an option to disable slab object accounting".

Oh, Yeah, it's an alloc_tag change. Thanks and will update.

> 
> On Wed, Jul 23, 2025 at 04:03:28PM +0800, Zhenhua Huang wrote:
>> Mem profiling feature tracks both "alloc_slab_page"(page level) and slub
>> object level allocations. To track object level allocations,
>> slabobj_ext consumes 16 bytes per object for profiling slub object if
>> CONFIG_MEMCG is set.
>> Based on the data I've collected, this overhead accounts for approximately
>> 5.7% of slub memory usage — a considerable cost.
>> w/ noslub  slub_debug=-
>> Slab:              87520 kB
>> w/o noslub slub_debug=-
>> Slab:              92812 kB
> 
> Yes, the cost is not small and I hate that we have to pay 16 bytes of
> memory overhead for each slab object when both memcg and memory profiling
> are enabled.
> 
>> While In some scenarios, we may choose not to delve into SLUB allocation
>> details if initial triage indicates that SLUB memory usage is within
>> acceptable limits. To support this, a control knob is introduced to enable
>> or disable SLUB object tracking.
> 
> But what if slab memory usage is not within acceptable limit,
> reboot without noslub and profile it again?

Yes. The idea is similar with: when we are willing to see slab 
allocation stacks we add "slab_debug=U". Basically if we enable page 
owner only, we can't see slab allocation stacks as well.

> 
> You should expect to sacrifice some performance and memory by enabling
> memory allocation profiling. I'm not sure if it's worth optimizing it
> at the cost of disabling slab accounting entirely.

Actually, we can still track the total slab usage through 
alloc_slab_page; in my opinion, what's being disabled here is the 
accounting at the slab object level.

> 
> Anyway, that's my opinion - the memory allocation profiling
> maintainers might say something different.

This, as I understand it, is the core concern addressed by the patch. 
The background is that some OEMs have raised concerns about the memory 
overhead introduced by this debug feature when used in production 
builds. While page-level tracking can now be compressed into page flags, 
I haven't seen a similar solution for slab object-level tracking yet.
In a real Android platform, we see 24MB memory are cost from 
alloc_slab_obj_exts :)

> 
>> The "noslub" knob disables SLUB tracking, preventing further allocation of
>> slabobj_ext structures.
> 
> nit: "noslub" is not a good name because slub is an implementation
> of slab allocator. For the same reason "slub_debug" is deprecated and
> "slab_debug" is recommended instead. Maybe "noslab"?

Thanks for pointing out, will update.

> 
>> Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
>> ---
>>   Documentation/mm/allocation-profiling.rst |  7 +++++-
>>   include/linux/alloc_tag.h                 |  8 +++++++
>>   lib/alloc_tag.c                           | 26 +++++++++++++++++------
>>   mm/slub.c                                 | 10 ++++-----
>>   4 files changed, 38 insertions(+), 13 deletions(-)
>>
>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>> index 316311240e6a..9ecae74e0365 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -18,7 +18,7 @@ kconfig options:
>>     missing annotation
>>   
>>   Boot parameter:
>> -  sysctl.vm.mem_profiling={0|1|never}[,compressed]
>> +  sysctl.vm.mem_profiling={0|1|never}[,compressed][,noslub]
>>   
>>     When set to "never", memory allocation profiling overhead is minimized and it
>>     cannot be enabled at runtime (sysctl becomes read-only).
>> @@ -30,6 +30,11 @@ Boot parameter:
>>     If compression fails, a warning is issued and memory allocation profiling gets
>>     disabled.
>>   
>> +  The optional noslub parameter disables tracking of individual SLUB objects. This
>> +  approach, similar to how page owner tracking works, relies on slub_debug for SLUB
>> +  object insights instead. While this reduces memory overhead, it also limits the
>> +  ability to observe detailed SLUB allocation behavior.
> 
> I think you don't really want to use slab_debug to account slab memory
> if you care about performance & memory overhead.

I should update my wording:) What I meant is that this case is similar 
to how we handle page owner versus slab_debug: typically, we enable page 
owner firstly, and only turn on slab_debug when we need detailed slab 
object tracking. Both are optional and left to the end user to decide 
whether to enable them.

> 
>>   sysctl:
>>     /proc/sys/vm/mem_profiling
>>   
> 


