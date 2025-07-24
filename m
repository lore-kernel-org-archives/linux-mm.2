Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53952C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 03:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EBC6B01A1; Wed, 23 Jul 2025 23:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776056B01A2; Wed, 23 Jul 2025 23:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B33F6B01A3; Wed, 23 Jul 2025 23:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57FA76B01A1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:29:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6C42C0279
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:29:29 +0000 (UTC)
X-FDA: 83697728058.08.43F401F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58D011C000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:29:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=DTJ+MLBW;
	spf=pass (imf18.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753327767; a=rsa-sha256;
	cv=none;
	b=kBleKm9gybQUTxiXMX+TRo+PDYrtnhGm/rgQOvVRN6GHHmesZIShFt51OiUHG6+W7K22o0
	iSonYtNBYmh2TKJuBL1MWDEtxC4w9535tOUIPAd7NMv/054d0kQcZrOO4wAmyjFXC/sGzl
	d7yQwfE1jPrPCr1sOda6qbcawF8X+5Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=DTJ+MLBW;
	spf=pass (imf18.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753327767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnJDM/0zfvI8HbrY8ldAg1aTC2VsVALZRc/Q4DEWBBw=;
	b=Cove8XFuGlyEP+cVX2g/el1QrVfT5zWlrUqsQ0N4I/WbJT1kPaWW4g783jWW9Af+J6ls6r
	FVuGJjr6O+dBMU3ojQO0Oya+vZM2AjKj49CMLCYL/oItC9rNrjQ/9hsYjsGq/WYe4nQCTX
	yl34cWBi2JxCxW3Go43BCfLwC5QUe6I=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NMXZWx016006;
	Thu, 24 Jul 2025 03:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mnJDM/0zfvI8HbrY8ldAg1aTC2VsVALZRc/Q4DEWBBw=; b=DTJ+MLBWzzXAUvyr
	2FEJk5JEfdLWDbCDfO0Ys4xhZ2VXlPGf0cO0ndK2tBmW5a7C2w0ArXabWvbLpgpH
	yrSyrM4yvMOlPouY8pKsSn1Sa6AMGC52W3TUjA8gxPH4m4QiW07xoYz+Cmp6VFol
	IZr3TfmG62xU4hXtd9hb/KhCkGitWwy8lO53o7YHm1ZXo8uNrgNgU/+0r+alo5RV
	d6AsAYPOtFPuWj74y7XBgBXvqqa6u7ScHsP+131mK5/3aaoBauHof7tVmREwoPUd
	vNRWpDsy1TEKp8xAbXp2Kr4w90gYt4xZIWf944qi9xWmSDZlZGIsuvghaEyyMpNK
	pzyS2g==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 483379sdau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jul 2025 03:29:23 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 56O3TN7Z011817
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jul 2025 03:29:23 GMT
Received: from [10.239.132.245] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Wed, 23 Jul
 2025 20:29:18 -0700
Message-ID: <91e59f27-27a8-4504-bacb-3e96ef1e6bbd@quicinc.com>
Date: Thu, 24 Jul 2025 11:29:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: slub: Introduce one knob to control the track of
 slub object
To: Kent Overstreet <kent.overstreet@linux.dev>,
        Harry Yoo
	<harry.yoo@oracle.com>
CC: <rientjes@google.com>, <vbabka@suse.cz>, <cl@gentwo.org>,
        <roman.gushchin@linux.dev>, <surenb@google.com>,
        <pasha.tatashin@soleen.com>, <akpm@linux-foundation.org>,
        <corbet@lwn.net>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <quic_tingweiz@quicinc.com>
References: <20250723080328.4012263-1-quic_zhenhuah@quicinc.com>
 <aICpMWKNvhveAzth@hyeyoo>
 <aqscos5ivap537qljhqa2pntrxfimfkfuflji62rl2picpvaiv@sams7xovbtn6>
Content-Language: en-US
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
In-Reply-To: <aqscos5ivap537qljhqa2pntrxfimfkfuflji62rl2picpvaiv@sams7xovbtn6>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 4xXG-fDMPLxWGgB-1UeLjz1aPROUE_yA
X-Authority-Analysis: v=2.4 cv=btxMBFai c=1 sm=1 tr=0 ts=6881a893 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10
 a=_DfhJVbmsquJgjLii_kA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAxOCBTYWx0ZWRfXx6hatoW5yu3x
 cbraOFVYkOvIPC49/IczoTvBlz3W9LNcClvgfKaDv5Ymos2TB4Ct0MDqSAFhfNF5ZaQc6xh2NyU
 3bIjmd7jzdNhMoapwuXBf/FbvGmMGmrxyHIER0HLottvsbBledePbp3Wzc9UK7Pm3VccMU8NZjE
 dTRfmCSM2svUUeMsP25eqRNl5jenxht+8O8VcwIAYsbB++RHTTf35H6b+It9OMrMIXjvM5HxVvv
 Cq2fKWGk7ugEZNHjx3B4MU+1z4OZ54dJ07Atr3uoU9IBWx3ifTwJY5FQupqTspQcj4rTk5JqeSS
 hDnGmrDhg1JHFiiE1s045LWGCzTUjma2FtWZzSHNxV3mahmIbcl0Ppb2jTSS9G47tVJ7x/RfEiY
 zpv4oCiDHGTSswtffzs8R+Z+CcmWCuXPvzFZpHjMIH6LYPo1DHHpyaaDIfi8VEGNey4GqEvm
X-Proofpoint-ORIG-GUID: 4xXG-fDMPLxWGgB-1UeLjz1aPROUE_yA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507240018
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58D011C000F
X-Stat-Signature: ujdohu3uu9meop3oy63cfds5ihxojccy
X-HE-Tag: 1753327767-800670
X-HE-Meta: U2FsdGVkX1/XEGmQHO1UCsUyuHEhhNivmWYsbOOcmleKUXwAVXoV6TAtxHv2DG8tSV0LoqwBJGxGNteMEFcQ7C30sg4a2q6vSglCytdAN82FXUiSKnn/7GKF4o+BRkqKBxNO+x0+fqnjrJrCvMS/DMwKW3+cJM9cYgozsdwIhXEeLf5W9DtlrB3LITkWy4TyNFO824FJJUb9JfO+acgGO2G7u7S74hXeQi1wKaGZe6NgECFBAUCuRrxFtld7q6zXSL884iJZ63QX65E40hzbLB/yyfXUk3r0IwdInhJDv4R0lkHcYFdSvNbkfy+4VjyX6zfFua5DN+1zzcdWLGBczAJW5H7pePzF+hRsxMLQVckXaf3+Jr4zdwGxfyKYv1T+bTvJVio4jwU7FSbXpWx1D3GcTABkfhjyfFdoTlRGTGz9pUBl0PIomx+5KypnBOie2n7fPjjaQErg7yGIlT8y6y8RvLtfWvM6IzbWhNCYTnrruEebvi+gXgCz/0F21INXWywzOjlnrj+dQZJCcvFe/ApF//gTK0Z6TCOakcs6bxxutWRPtrBp1IFjCdggA4Ae53nNtB+SYitadPYDjpjynwZSwTjWfXor/JVzgsmKn85YUu/xhuBW78cqQGJeV+U9L25iBPHVHlA4L/6G6DMie6KXNooSRK24vAQx00dIaLrimUuGFoIA08SWqQhVqHJShPHRCSoCzAEYvKmmi/rOX+gO7oO1szRHUoJ8kf3hhx2/1MbG0xuk0TUjRjIxCRsjgLCaeTswLEqjqrJZGy5RYkQ+5qy7cUiAoI6Ts79l6eOSv5Td2LmWhOG55Ui69RFO4fcLv2bSA77R9iyTpjJkrHucnRYx0BhHJjk35Yc4yQ2Sp5hs8DcgJ/6snlz46xFB7pHAQRDuzLAucqeLypD9peeMtxC0Tb+5mIiabZ+sb93yjcBXkQMyaEIxXZwVhDDjLWwijDPQqioc9A1u1+Q
 WcoKirl2
 GdRtwNeL6mx7qzXIXObpxOV1QR07tYR+248dJUhd5tZY9PVLTA8snwZkNeXbvwO22eN8hhaSxP0ZuYjZ+B5Uvx0knIj7Zt0CihlTycxChDsc0fCz1d4GFN81PHsvaxr5yB2TFeZLhXlx8n5ZnN4olwBgIkYbk54mFZUg2DfiyjNr11UNMeAVbaHU2MguIpfP+3ptauAtd6esRU7d56K2yWQt0UxnnzKZzoOhhrouxUmLNIkCnJSciyVsmEaWQ6nUrBJ5+oHX8GeNU9mfQMI4LChZTtAryMZuaug0CqMRKkZo0jwTxotXrb/5bASRpea9j5VFPWUJ80JWdd3Xopcx7E4WGZF/UNVg3oxYsirPRKE+EpJpu1h6SpbOjMRNAFr3EihhY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/23 19:38, Kent Overstreet wrote:
> On Wed, Jul 23, 2025 at 06:19:45PM +0900, Harry Yoo wrote:
>> The subject is a bit misleading. I think it should be something like
>> "alloc_tag: add an option to disable slab object accounting".
>>
>> On Wed, Jul 23, 2025 at 04:03:28PM +0800, Zhenhua Huang wrote:
>>> Mem profiling feature tracks both "alloc_slab_page"(page level) and slub
>>> object level allocations. To track object level allocations,
>>> slabobj_ext consumes 16 bytes per object for profiling slub object if
>>> CONFIG_MEMCG is set.
>>> Based on the data I've collected, this overhead accounts for approximately
>>> 5.7% of slub memory usage — a considerable cost.
>>> w/ noslub  slub_debug=-
>>> Slab:              87520 kB
>>> w/o noslub slub_debug=-
>>> Slab:              92812 kB
>>
>> Yes, the cost is not small and I hate that we have to pay 16 bytes of
>> memory overhead for each slab object when both memcg and memory profiling
>> are enabled.
> 
> I believe we did something about this for page_obj_ext; the exact
> pointer compression scheme we went with escapes me at the moment.
> 

Hi Kent,

I recall that it used page flags for compression — not actual pointers, 
but rather *idx*. Since every page has a corresponding struct page, that 
makes this approach feasible. However, it seems this assumption doesn't 
hold for slab objects.

> We did it for page and not slab because page_obj_ext is a large fixed
> size overhead and the page allocator is slower anyways, but it's
> conceivable we could do the same for slub if the memory overhead vs. cpu
> overhead tradeoff is worth it.
> 
> And - pointer compression is a valuable technique in general; coming up
> with some fast general purpose code (perhaps involving virtual mappings,
> we're not so limited on virtual address space as we used to be) might be
> worth someone's time exploring.
> 


