Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F28DCD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 04:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D4B6B0005; Tue,  5 May 2026 00:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE7F6B008A; Tue,  5 May 2026 00:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACFF6B008C; Tue,  5 May 2026 00:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85CDE6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:45:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 277E4C1B9B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:45:46 +0000 (UTC)
X-FDA: 84732128292.01.F278F22
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id BF0051C0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:45:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SEEzu8A2;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777956343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+qnMc5mAtsrIcRWZAT9EuxFUu4xRfpER1I2wbz9va8=;
	b=JF9eH+LL4ZQoxFh+h8TO0wA1qaQcv8NBVQO2kYksz51ZhqRtS5R3t/ohJ+5aDKqwWomsOh
	BYEyoFt+AsmAtVfzgcs9ujMWIHGtxkYKlDZBALeo0sAEsoFx7dJcEEQgryShXboe/IK+ol
	9ydJjT8i1KQkDT0htz9pgdqevPhXuTM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SEEzu8A2;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777956343; a=rsa-sha256;
	cv=none;
	b=fFWoR3AQmm/ld0qw69LEv2HoGiJAaDLO+1Ta75EQ7OLn8F50q/bvQC2IfrdVU3MEL4J86F
	0/gdV99PhmuieXD1gkicSTmisWe2zJb0PJPBcNPr+mo1GrpD+BWrhjZPuk9uFS6AV2GUNw
	TyvspbA1HdeLWizGEYuQ1zobZwOGJYA=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644DtB732799040;
	Tue, 5 May 2026 04:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9+qnMc
	5mAtsrIcRWZAT9EuxFUu4xRfpER1I2wbz9va8=; b=SEEzu8A2TVA0Gq3KjIwE3k
	qjLkw65d74A+8AdkwIWe3UKl0u7WhBCpkGjxdMKdlOuvsmBPF/73Li5T/jh91STK
	ycLlchssw5Dit6/9N4IVavEdy5v/aIyuqBffOVNdL4uORz6nMa6ua6a5B5j+Ta51
	E8Sxa37G7HQfDBaC2nThE2B9MPH8nc5sQuT1jamld1ozRVgecEHQQcIbboYXuJeL
	JazRskImDhq3dLk+I700dkFBFADFMR78GQ3VU1vuJJzWXJ1Kuyu3JeensuaWvtP3
	++7lxo8K6Hs/qKg+hdSieO/ss8Z8RrxG9ECSQlnLq6ae4GtawDDSLNTS2uRA2hbA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w69q2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 04:45:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6454dOvZ027093;
	Tue, 5 May 2026 04:45:10 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y7t5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 04:45:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6454jAYG30474918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 04:45:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1373A58059;
	Tue,  5 May 2026 04:45:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DED745805E;
	Tue,  5 May 2026 04:45:00 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 04:45:00 +0000 (GMT)
Message-ID: <4b532a01-674a-4d81-8ccf-312688368c50@linux.ibm.com>
Date: Tue, 5 May 2026 10:14:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/7] mm: sched: move NUMA balancing tiering promotion
 to pghot
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260504060924.344313-1-bharata@amd.com>
 <20260504060924.344313-6-bharata@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260504060924.344313-6-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f975d8 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=n0nZGg35PxI7s4gaVK8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: I-J5-uQzEW2sBUONg2GSFGowJlKVxUNU
X-Proofpoint-GUID: ob5hThByJfZ7lgkTM2AEFnLqAEZNf73W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDAzOSBTYWx0ZWRfX+gGOIO3D9CjX
 I01dLA5ia8LWBhLC08yNnfJ5cGlEILzyTLqw1+LGxhMBXrbDHJBqMPiXVWLBeyst2W3lAdmWH9m
 /BhLtRVdu+uTChcFSPuRl/ePpN+3ZBtjJ2hlOTvO9Wco45PkqXJV47Ga6wtMd9UisCHZRXAEo4P
 44xWdS3HBLN8OS1cnfxbjZ8lRgD6BmI1qrDl6DcMHB/KpKrBdYj2CODMkuU523a9XXn+gLoT0pb
 vEztEjeQn6vJwSPfPA6Xk4vPduULVqVJKKNCG+YD6N0QPGV3TA5jDsSVFSBCVs0kZcOMdYeqY5I
 N07s5gOv65mYKUadBmPTZLTAVGLLsCM1aeaybUPFWcftqHzUHWu3LD9FHYDJJKu1kgUypfsEtAd
 rH8xnqE9S+CZJBhLCfZTZVlP2W5krmej0IYo/pliQo1w/32YoTHhkwIN8vydt+BXcqOaEzWadVv
 iGgcupI+SuRtEoLBxkw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_01,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050039
X-Stat-Signature: xb973ziopjbh7yh1en149zgb6mkcae36
X-Rspamd-Queue-Id: BF0051C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777956343-296901
X-HE-Meta: U2FsdGVkX18N5Pvy9WYB8oCvDJSAh62/jkiigbS3JyDLpmDzdEzSXmdXW6ojYm0x3GYHPSR1t8vSHNCKObduTfr0Cnf5csGIuJA+6JK3Ulcrtp24xOUQQGp8FpyiFxcE5VsJdu6RbnP3VK8++RgE1RZPc+bCopY8ErsMFlGB/QRcQM1o1Pty/mPX43RO9CV9XRkaTVywAIreaKG/qt9YBqjMZFVvn9WSZEfhrbK4JbSWoUpdWZd0m9JXEOPIrranuPU5J9EVu2SfUj55GZx/tTh8CVzqfvKmCkmjLl9wAMwo0WPQd8B4KPbo79Tia0QmGR9+lddADfIdvikko/dWG86PMN0xbLG6Gew1GoVKmMV1YqCzbA/c/AVcyguZNvsAJTtVLIuQ9GAw+ADSqyOzLLF7dQ8OnRQEU6cVuu8RetO7DizEja8Lcbmt4n0/D3o32+ks0zsZHCdVsFXnfBx1lfOVxmb9uBtWUyjvkt2f2XoquDoHEzcdrhlosj7sQiuWbt4n9M25hyFJ7ppmRPJv+k1zwo4Q6wxvrK/oQ7P0ofJlOiYcImkH6Cd86InQMTx0gyPQ+HZzWwzLYGCuOHT7/SzPpFDb1dv5gz24Zl2ElV30QnQMKxwP4vkAkyGWWOU755RRv49spoIa1UhwOjdskcv8UMWz9Mkemi6nMj95/TibGklmqSA1976gNBr8GDN/+cYmngQVcIX2vRnw1f//AhC8xVjMJLVfzLGtCk+3XEBeC7VBeksMAGoyCQcmbvVhnK4P9mRKvagS5kiqod94CBpJfdaQGTcbGOwNGG4Ay8bEPMeh48s25qEZm0pQh0WxPNS7+/wyF4w5WvBlmJDmLY/rOM+fZ5HmFxsoafFq07AYGpA1YCyWfuAz+h3eKA4h0ZJAnFUq+4+g8YCjp/zYox/vwI7JPbWoaa79SDsrByrUun0zdQJozmBULKsl5J2GRrkMeXdlnboAQWQG/Wi
 m+xb8rWy
 Z3DF3SlVZ+w7rtUsnynLmbt6Llb4bh7ZwRfk+jqc1CqE+kJN4IqClvOd8GiLVLGXbhf/Lg0wD5UhxokigYNEBM538JfvMNc1izuAWqutjaKxSx1ba0oT80cFStt8ye2N4feI0ieFSFwemNy1HsykHrTK3+bghbYChVwwuRd6Uunstt+BwUSHHXV1OYjze5M5oCorYV7GS+chq0APLXOZ4FI851HeMr5a+fSY3aD5K2LtgTiArLb1rs2b+Eg4R5P8ilsbWPB/3bfFBHWEKk95I9anu5O//csxnmNMB4dDmTbGTJqgf3JgNSHFdK8ORoiK9NJ5piuSCM8ExwsyGvvGiJDUOBkZ8Q+k0E8Y7l+riM9eTV2UrVCJpPmGVlCz4nfgfJrpptwgphOnmnz3uS6Lj/xgb0MyLaMoJXAFW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bharata

On 5/4/26 11:39 AM, Bharata B Rao wrote:
>   
> +/*
> + * For memory tiering mode, if there are enough free pages (more than
> + * enough watermark defined here) in fast memory node, to take full
> + * advantage of fast memory capacity, all recently accessed slow
> + * memory pages will be migrated to fast memory node without
> + * considering hot threshold.
> + */
> +static bool pgdat_free_space_enough(struct pglist_data *pgdat)
> +{
> +	int z;
> +	unsigned long enough_wmark;
> +
> +	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,

Just a thought—would it be better to use #define for these hardcoded values?

-Donet

> +			   pgdat->node_present_pages >> 4);
> +	for (z = pgdat->nr_zones - 1; z >= 0; z--) {

