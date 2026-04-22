Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 099F1F94CC3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 04:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D7D6B0088; Wed, 22 Apr 2026 00:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF1C6B008A; Wed, 22 Apr 2026 00:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD246B008C; Wed, 22 Apr 2026 00:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA046B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:05:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2A821B9921
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:05:07 +0000 (UTC)
X-FDA: 84684851454.01.9576CBF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A38F1C0002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:05:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ltlTTdAT;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776830705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFJGvIC/Os9vevDmHB7AyvpdwBlXcko/i1oy825phig=;
	b=n9VFL8jwjKKl+CuxrzfFVc9zPwBX/qpZ8oQ6bitzZH0UPDWeiA+quMOaK6X5cs8+z3f9lD
	ad3hCaxto7tdMB1dLifV0JurrOwVAZMKtmlGeNKnbFqA0YnFXHh3DN5KUWAmRT4OAyYLBG
	El/ir2ukPq6TZXoXX6102DfHZjQItgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ltlTTdAT;
	spf=pass (imf21.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776830705; a=rsa-sha256;
	cv=none;
	b=DP6C54kf+eZKK+IbcqZomey3/LATAkcTm/hKbcGk58iaKbehReXeG13qyH6iF2y1QJUx2i
	UMHcGoWnPG3rK8AA9ohit6Wb6gCYJmR1VyAXLtnTAIRkYNebUrtefZnhSxbYBzkS1erMck
	bHSis8RBWf1l7jElHi3X45yjTQEX0OM=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIlreo970411;
	Wed, 22 Apr 2026 04:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VFJGvI
	C/Os9vevDmHB7AyvpdwBlXcko/i1oy825phig=; b=ltlTTdATIkYclko2m1m3Mf
	PSkzuiFJ6Nr0zrTOlRWZXfMdqW10TyeUisbEVgGBZ5BadRyybYOpzcUsKF25vHtH
	geJkfODbfdcJtE635z+SpqLuwS4u5vQVKNVBkm9y0zmpxcTl70f3wGpMByy80Adg
	sgB9I5lH6XBO//BOXjBx/y9XWk9w/BChoaWsacyt5gCnbc2VX43zIn+8dvJba3LW
	IZydkpPfYEYNcFWaYwOSpI1XlTWziFcWE+P54XN9yYKkck+LQuddZbUrVYlbnk97
	lzDoBuSoF1a+zxHEXn3nd4YA8UZgMh/dZ2PWnxgvMRtL6wTTIEhvRk9C6D4ZZiFA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu3he2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 04:04:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63M3oVmW020275;
	Wed, 22 Apr 2026 04:04:40 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxrpx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 04:04:40 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63M44DcC47579506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 04:04:13 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 437405805D;
	Wed, 22 Apr 2026 04:04:39 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8596258058;
	Wed, 22 Apr 2026 04:04:29 +0000 (GMT)
Received: from [9.124.218.94] (unknown [9.124.218.94])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 04:04:29 +0000 (GMT)
Message-ID: <45b93560-acdb-4552-bac5-bd085d778085@linux.ibm.com>
Date: Wed, 22 Apr 2026 09:34:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
To: Gregory Price <gourry@gourry.net>, Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
 <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
 <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
 <bed91b49-4053-4d9a-a6cf-6d3a4654fbc3@amd.com>
 <aehCjOtPtt_wrQlv@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <aehCjOtPtt_wrQlv@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Rl6q9ucgDa0d5Gak78s0l1-YoJd854dU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAzNiBTYWx0ZWRfX6qFXJ9T0cms8
 Z6pv6Zw6F7gsqkwXIEFx18ZjtihXvxvKqjwGd4tO67jqg7KyIV45dKhYDk35dYEdp3m4QHCwVk/
 QcBi2Qw7TPvzV1UFH22DIF8ddZJGZ8FI77LUGwFSMfSSGoAxnxj2S8OsJ9nF1hr+dPeTevc4ryQ
 9zzd5VaTSqq/Q60alOF2SRp9Yc/ltRDk2yLGW0t75COJ3YsfX0/5OVGoaw2rjv0xgqbdjO9da4Q
 rw58ieb9BHo6X6WBj2wv8n7OovJ9JxzyfNmp0XSJMSu9e4nctpPaOWZSDb+k4Hcl2HQP+GZzLR9
 EegF/FPbV8ob3l4M7i4hTsjkPWXBEErv0wqirrIwdaC85FPBFBkYUvKn8QIDRtaZoja6HuTCKo4
 n9f/33+wCuGerLQj6ND1AmPOSlXu/Ca02ytbDsndzmOULmoFePVZf8EcY+ZxH8opO0deQHWdDEh
 W9/3eY9trIkxRv8yVfw==
X-Authority-Analysis: v=2.4 cv=a6kAM0SF c=1 sm=1 tr=0 ts=69e848d9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=v6K55fGTm8UQkk20tRYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: TU3Ad5bqm1kLedrdzCL7UQFw3rpQfocV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604220036
X-Stat-Signature: pa9sqx6ce7zpicrjohgfnhtyu6rhgqiy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A38F1C0002
X-HE-Tag: 1776830704-393376
X-HE-Meta: U2FsdGVkX1+JvI+UZuJB3BlgaHASa5YdXFNdST0p8Xflem1Ky/t4mSn8eLp1tLOdSJejcbNxPHgJmwHjVfnLz1AgeSiguABci8TNZ4VFxiKPalAfzAh7hCyMNEuYeSQ+MlJ8KGXbOx4ENVpTDyTWmpZxDSh/fWaHMXrbsl0/Eh7RajS2w0z9fTXKaESbFLgyF9V8eLYbTYTjGnH1ACG6BcL295WrFT26HCsC+thGYpGDDzOsIofsRFQ0vCVbsskS20bQmwLQ7W465uJsXtDRnrMypWGRX5d3LlNX07VRMCg7boeUDOV24k8VvPfuXRUxTMBcLuMt+UTw3F7iIxlEFjpd2KC7o1J5neWzOmpNe/VsQyufRvcez6w8X/eAbcELQYdFriA3/cJZb0you/+SH0QiiiuQGuVE+4+Sx/VHpYIvN/oz5p+4+i8ALV7CkXvmu7yBDqQOeTqwEbP0EYM/dvEKkiuRCWLXWVt7lDHm4oguVQPOziW2s44dj69h8x+pCyxXsTur78wbFAYXcZdRWKKnuTErKU9mTDRvAFMFKAdKZL0pKEaE3Vnpvt8fFK5XRTmvmb0gfTedbgbCsRIyoh5tjOh/vSdyTt3xoFTJST99jb33Jwq21FAnNBGQM4d192L252boizTLIl4/3zMMeQTX3NnPyFAnjmQ5vrFK5T+71acwG11Y6TUzn4KOPf0lL0IW6AOe/nXShz2B46YfbG5oWkNOjVy4BPxsReSBoVRuktmkpoHU62MINaVa/iFAytuE3zEH5WT/55NwWO50+q/GnciCsQxGMg7b3s98IEJi5/n3Gwl+G/fB93gaEMk88T3DdcbpL6BYEdrmeTomjkL8dRH+doUrH8xUALQPV5LmJ3Lpq4/y+OdFJzK6M+k7BzE2H2VIQlkA4A+WkXcNxKDvcGWf4Ze5t+c1jnQdggxhtq/WkDHFg4tsbOfqrASEaYbryFQN0iAeW0IFr0V
 Hs7FeSB7
 HdHp5cu4i4Sj/eFVqYXmBBgzyZBYsszx3/EN1us4v5mdZuLmvVt/M259nGCQOx1B8oerLYbMgsXFxmrUMtsfmiEEL4IIfUtL+/suTJ+Yq5QVLq4s0Y+0mwYMXF4u7hZP91sLvDPMjw81bLBoaapcVIuYfnHmarwLImB+IfJR2lokZgQWc7eD4TZUEgs2stPQclOI74YbA1aSWt8gk/CinCwyQ/vuF15rVpwA6zM7qB1D/hX4tlExr+/g5BVPSUnYzzK2jko2jMxKnLTq6wD1k4cokRHC8I1008u75aOXwdnQHahSFo2P0AJ+zbklqZZHiAwC8MnqHUVnRa9W2cgvLyTugR9KIQBdqXvMPwyOmo3DhQ9NZLN8ix332sHwm3aabh6KAVrfKOJlkm3kUbYpR98eaE30cOe3TV1lwz1O8z3LxwsUI9Osrf0ciYciLmBMN4fcpi2qRYira/szIV3Z4/w4zaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory

On 4/22/26 9:07 AM, Gregory Price wrote:
> On Wed, Apr 22, 2026 at 08:56:59AM +0530, Bharata B Rao wrote:
>> On 21-Apr-26 9:35 PM, Gregory Price wrote:
>>> On Tue, Apr 21, 2026 at 08:55:02PM +0530, Donet Tom wrote:
>>>>> +/**
>>>>> + * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
>>>>> + * Attempts to migrate a folio list to the specified destination.
>>>>> + * @folio_list: Isolated list of folios to be batch-migrated.
>>>>> + * @node: The NUMA node ID to where the folios should be migrated.
>>>>> + *
>>>>> + * Caller is expected to have isolated the folios by calling
>>>>> + * migrate_misplaced_folio_prepare(), which will result in an
>>>>> + * elevated reference count on the folio. All the isolated folios
>>>>> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
>>>>> + * stat can be attributed correctly to the memcg.
>> ^ This is the expectation from the caller. pghot caller ensures this.
>> I could add a debug check in this routine to verify if that is indeed so.
>>
> Wondering if the interface name should somehow reflect this as well, to
> make it a bit clearer.

I agree—this would make the interface clearer.

-Donet

>
> ~Gregory

