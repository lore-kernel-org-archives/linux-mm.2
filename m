Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1902DC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 03:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC4B6B01A4; Wed, 23 Jul 2025 23:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CB06B01A5; Wed, 23 Jul 2025 23:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B506B01A6; Wed, 23 Jul 2025 23:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1046B01A4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:57:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1291F130429
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:57:52 +0000 (UTC)
X-FDA: 83697799584.02.0202AB8
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9CF3016000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:57:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=nMnycV4+;
	spf=pass (imf08.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753329469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsLQ1Xw+NK/R4axx21pMYKpruTy3n65vh1zbPLYMc4A=;
	b=Ae0dt8+cHiaskGuFYRU8EZ3m8U6TnX362RhCgTDS3l8qdOGohQHCeYMgw9Zsqd5CNks0XG
	3mhIeoYXCaINQEg4/D889+ai1kLBg+JvZvwgo4bM3ytqEpU1e9VGwxex0GJs/EkQDV1s/5
	RZcIb+v7K+077veDloSqNT2k2pU5uo4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=nMnycV4+;
	spf=pass (imf08.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753329469; a=rsa-sha256;
	cv=none;
	b=V9HdHEGdHjq5/JWn27S3IrdyGzw+H4piR/NqEV6gxOaE3YEBc+yEIt5zqhKjcZ2ws7ogDS
	ba1EUxBArtAWAA3N1WnKDY6Gco13GjqEhbqAM3DhONTFR8uIOGBFlCBPII5D9Go4Ewjl8D
	ndqB7oCRAFGQfgZ3U/AwxPFQxEECnBA=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NMXHNC023401;
	Thu, 24 Jul 2025 03:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qsLQ1Xw+NK/R4axx21pMYKpruTy3n65vh1zbPLYMc4A=; b=nMnycV4+VYvcVd7x
	B3HY8Fe7c5Vo2heYWTCdBdH0qA8AX30VvV0+l2tuc8q9K7VM+kW7BVrmCBfjGZvv
	YqKNwlFY51gaCVSkthKwFJ7eFRYMiOkYrll0x+LrDu4K3VpVvJLU/tGaubcOj6e4
	HbsrJRl7SYxn/gAsXsxTUYi1iSGrIyKPnGfwdMhOc68DamU0//ypOCpFgoxxBNr1
	kyAtANE3y2FECAXKMyv2xXVl7vDl8SF3FaBAps1WIWia164aJufaKhNzYxpCQbY9
	2SAvTSN04EalkwMry0PHC1pahBdEms5n6XMjoa+ok+DZMG6dvgj0R6UuVs/qt3PK
	2wYvog==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4804na5sjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jul 2025 03:57:46 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 56O3vjUX025125
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Jul 2025 03:57:45 GMT
Received: from [10.239.132.245] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Wed, 23 Jul
 2025 20:57:41 -0700
Message-ID: <95f2a23d-5ef0-473b-b3f0-c6d828cf8636@quicinc.com>
Date: Thu, 24 Jul 2025 11:57:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: slub: Introduce one knob to control the track of
 slub object
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <rientjes@google.com>, <vbabka@suse.cz>, <cl@gentwo.org>,
        <roman.gushchin@linux.dev>, <harry.yoo@oracle.com>,
        <surenb@google.com>, <pasha.tatashin@soleen.com>,
        <akpm@linux-foundation.org>, <corbet@lwn.net>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <quic_tingweiz@quicinc.com>
References: <20250723080328.4012263-1-quic_zhenhuah@quicinc.com>
 <mw52yqm7wfe5afb5ybvfkpdgo4pm4wobmzv3um2cov3amekzmi@ye5drijf7njj>
Content-Language: en-US
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
In-Reply-To: <mw52yqm7wfe5afb5ybvfkpdgo4pm4wobmzv3um2cov3amekzmi@ye5drijf7njj>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ibrhzoPwiDxgwEc-hjYGwQ0bQQYAhE_F
X-Proofpoint-ORIG-GUID: ibrhzoPwiDxgwEc-hjYGwQ0bQQYAhE_F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDAyMSBTYWx0ZWRfXxSLH4MHihbTY
 6nxONS2JvJDaPQTVC/aS3NPXAmjMeB05zphsyVwpJjdaeIf0OtsuMebfhj8Z64RxoRCuKtmQLc0
 YrUEnVkP5loaTI76B1kO9EprU8fW1/JggaWAfGX7phKujUj3joo4aoaFgu5mpmA2X/6hVgfFtS7
 xgPzlUfJCN8BRRdXK+UdsqRtgDfF1iNWrxjIqZ1URlHwYhFiA3lvyg2ZVVTlGwsnTpx3OIoJs0J
 mdVrxLvYeTG5NBKw9WfWXl6PybbAtQGc8e3x0bvjj5czMiunHweeixNAyfgjOOBM22YwODE9xot
 GHsCBQ4ovDpiuGBGjEAfEgHRypi5mCSrSX8ERx0jAoszKiPtANmSO7EryzsU7JPDxF39Cr9x0Is
 SxgYh26mcNP+lunzXsoQbvY6RYN3PYp3WRxZiDtoU7XMofAB1FRZZdgum6q3qFB9LhRC+Hcc
X-Authority-Analysis: v=2.4 cv=DoFW+H/+ c=1 sm=1 tr=0 ts=6881af3a cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10
 a=EcI5w910fGlJdbpBZL0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507240021
X-Stat-Signature: 896i4zr1nztdybzgsxssgew7yeu611gz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CF3016000B
X-Rspam-User: 
X-HE-Tag: 1753329469-902635
X-HE-Meta: U2FsdGVkX191BNXC0Us3QVt1s4sCg+Th4RGboTIh2h4wajk/6su9MSSJLrvn12hAgCRElybbwKZn72AQr2ZvHs2xF3dPM3T1hL1Lof9f+cDFQdWiOwLK70zx9R91HtXq47UMfJKRGHJ7BSNRkLEzkwOmRGJLJ2rdQLLdTyp3qELXWdQJZtz6zBf800mkD/kIXWizx4opDU6MAViOrBCTnIKWeeRvBy+Y0BAv9hGFutVCEwhdGZxal6ePzjBekJmLQDX6aq7/5N5TgesA4smceBwUMciO+jyQQnhatP7Et6AqlmerOj81VWzHLNxtp819l+M46Nuea7/4iTmyUHup5Mbgu1qbGDv889rKpKdR9Lcx+SqB02zA0lDBn8xP8mVUAAfIWcZ1EpCeOrVJuWOWlWS7SD0O66Sx2P4OgiC9mXlbIgh2K8vhzzjVEITpRo0DZA7c+Cl+WIf/aqqry+lYMWzT0Me/1D0VnecIveqpMelrZ6UXr/BGjLmp1aYAdKL0LbGnNWkFHY6CbYS2k38bOEf3u0GziKre7YqoO2l5zgBmUm81iB+vKy/nhtZdc18eWI4q5oqxeaJC7ZFd4SPPHBDlOG4BD+08HNiKfXZEQe8oLEUOoW1+Q/rPm/M996xyPMsTbRxuUzPGt000jQZIh9jiGs+BAyioGYWrH7dpIGhxBhAtNFP99StBfFUzgBoMSskuFNUqawWrTxnmNCudOfnMkEZM63VozJrsmYRnQJ4LXfMH8UA4eiaZeP1cuKG+Bf2nQMnHVgBdZZx05bXqp3vDs63MvxAmjVdWLGVE/Qeddt3OYU1ycuVqq8LiyB8rvzy+OIULFHNGpW9vVFVHi1kBt2GBY4fUDGvfsqzE6vSJHyXyGF0syyGFSkXUTJw77+yKamc5pE3jcatNV8CLMZ+4bDwcWEEUj0VL4bN77eFzgNiXhINJKLGEaF7oqzE6KZU9R00Sk/lJJWW6wME
 15hQDSzE
 BLCpFxKdplezuUrsOPQq/IH7+WNL9e9OtwEuAxjqjyBshpkZVIHEvFjatYHMiVJrFiST8wxgH+zwNB+7esA2kcerBRZCzXv8lZadE8nITdDVM3srNdzcVvN1o/78USmgQph3LD9Y8TdnItbvUPAahfNAyndCHB8uZWWjuGy71ln2ZhxIOWYNCeg4aMnpHAWJwaAEjh/SAP8fZgvffEX+7uJ24RuKlllTVgNN52oBUAku86Y+zdYH6ke8TwDk/XxpTqTeYfHqDQ9Pi8AhSh9GETwEr+dp1IjbtDLovdBtMyUQxKGwFZZhV+aOj32TDGokNxUSxHoT9UH/GHpg7IJ4bXazFP9XyJlUVe9B3uDAmtNd0EpMbFm2ZKbHdoGZhLG4grgvn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/23 19:31, Kent Overstreet wrote:
>> While In some scenarios, we may choose not to delve into SLUB allocation
>> details if initial triage indicates that SLUB memory usage is within
>> acceptable limits. To support this, a control knob is introduced to enable
>> or disable SLUB object tracking.
>> The "noslub" knob disables SLUB tracking, preventing further allocation of
>> slabobj_ext structures.
> ...Have there been actual scenarios where this would be useful?
> 
> We've already got a knob for memory allocation profiling as a whole;
> most allocations are slub allocations, so if you're looking at memory
> allocation profiling you probably want slub.

Hi Kent,

Let me elaborate a bit on the work we're doing. Some OEMs are interested 
in enabling this lightweight debug feature to help identify potential 
memory leaks on their devices. In the past, we depended on mechanisms 
such as page owner for tracking, but due to their overhead, they were 
not suitable for deployment on production devices. In response, our team 
is developing a post-processing script(may need to parse source code as 
well)—to classify memory usage accordingly.

One output example FYI:
version: 1.0
MemInfo                        :    Size_KB    Size_MB
slab                           :     440088     429.77
vmalloc                        :      71416      69.74
pgd                            :        888       0.87
pte                            :     104492     102.04
pmd                            :      12732      12.43
pageowner                      :     437760     427.50
module                         :          0       0.00
kernelStack                    :      54346      53.07
shmem                          :      18284      17.86
KDA                            :     188516     184.10
anon                           :     867120     846.80
ion                            :     420576     410.72
kgsl                           :      70328      68.68
CMA                            :     130992     127.92
file                           :    2037140    1989.39
zram                           :     156532     152.86
binder                         :          0       0.00
migrate                        :          0       0.00
Couldn't Parse                 :         17       0.02
slab_alone                     :     478939     467.71

In this case, we may not need to dive into slab-level details. Instead, 
our initial focus should be on checking KDA(that is, pages that are 
allocated but not tracked by any statistics). In other words, for a 
quick snapshot, it's unnecessary to analyze slab internals. If we need 
to debug specific slab leaks, we can even afford to enable slab_debug=U.

The key requirement is to make this feature suitable for deployment in 
production devices, as requested by OEMs. The 16-byte per-object 
overhead represents the highest cost in its current form, and we are 
exploring options to optimize it.


