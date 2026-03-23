Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D0AEC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A856B0005; Mon, 23 Mar 2026 04:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1D26B0088; Mon, 23 Mar 2026 04:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208BA6B0089; Mon, 23 Mar 2026 04:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08F8B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:56:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90F611B8F96
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:56:40 +0000 (UTC)
X-FDA: 84576722160.17.4C131AE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4042C10000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:56:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NZcI0pJK;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5Y/fERwhKhoqxvdE3p5IKv/NOKxkrVNr6hVFfnSRlk=;
	b=puoRrmkkUL0rymlJGVsMSGQkmhrLKSTfFi7ibZmaR2WckOvnY151kPjMttSVxFRDyOthW+
	y4dvAsNrQ19xoG4LoX+0HZ6DDMXKlklHUhbfM+6uGsspbmixUnER+t0Dq4Y4tpFCcWo5lU
	GxQ4opZ+s+k6H4MWxPPz+eeyJFODkVs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NZcI0pJK;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256198; a=rsa-sha256;
	cv=none;
	b=6J2JV7YDhUOmDh14uZLWWIihChJlpfmFya/BjzGrrwmiInHQvyWfqkM5a3iXzyxuKX1zeo
	vABmTBeGcQ9tFPNQRtMboSSqSn0Tho5B/7u7pA4C1veKAvjuRMEekhCfOQFRiSBj34Dohn
	aN43+Xi7c4PDMOtMHO8Z46U1pScLZNE=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MHLUqA4165707;
	Mon, 23 Mar 2026 08:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M5Y/fE
	RwhKhoqxvdE3p5IKv/NOKxkrVNr6hVFfnSRlk=; b=NZcI0pJKZIUYwuoRFL2Q3t
	XdI4dlGInWbdNY2bNfERUfnfJKcPpExgmkPPK5JDY2kWghLGXdd8EkVFrq/7oPlb
	YacuXBuO9Fj0AVeGr1Lu62r7uP4yHFsADQA9YsU/g7Y72Yb7ONkX3TpJCl0TuEiH
	JuYBAe3dfGvcVM9X47C+RNYbAfqJYuPsybScR1AB9t2acJ2izzPVmQKYs04th2aG
	3zr5TR5CSzEw3oHr97+pEr0xhNkXIau1w0Pm3lLirlpVAjz4TjORsimCmeeLhGrh
	kzCEvqoxzhe2ooZUR5f+A68dKjb7knIXmh/PcDJZLnT1c1n25HFGJ+Tqsc6N/IYw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktunts7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 08:56:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62N7El5g009143;
	Mon, 23 Mar 2026 08:56:32 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nncp8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 08:56:32 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62N8uVoR24576618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 08:56:31 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01C745805A;
	Mon, 23 Mar 2026 08:56:31 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18E665805D;
	Mon, 23 Mar 2026 08:56:26 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Mar 2026 08:56:25 +0000 (GMT)
Message-ID: <a691d42b-f4a2-4f4a-8284-4dc537c04285@linux.ibm.com>
Date: Mon, 23 Mar 2026 14:26:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: fix stale reference to
 memory_block_add_nid()
To: Kexin Sun <kexinsun@smail.nju.edu.cn>, david@kernel.org, osalvador@suse.de,
        gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
        linux-mm@kvack.org, linux-cxl@vger.kernel.org,
        driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg,
        ratnadiraw@smu.edu.sg
References: <20260321105704.6093-1-kexinsun@smail.nju.edu.cn>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260321105704.6093-1-kexinsun@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5NZKWs9zDTObDkwDn80J4vezwIYz0Cye
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c10040 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=w5w-BL6sGUiLeuYIlr0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA2NyBTYWx0ZWRfXxBT29/4Br3da
 ikMUdn8q0h2P873ZZ5X7nR0oFz7zBLO0loA31tXiF7Fz7eBYCOFdKkwgJDoz/HiSa9rmv1Y+GQE
 klXC6lotyNNDXDefKpTQsLWUVrlK0KtbG1mICty1R03UADSg+0lFanB32iLlmlXFIs46k/Mptfu
 hkb/YH0LYLcvpuGONx3PTFuEuE5HMGNYUUERfzaQbCGfhRECQIEUEnPSbDkiG3qI+rxrJwJth3O
 Ldr/8QVvhzfmw7f5pi1mAkISSxv8ItCObXxI76e5h21uYoSgwZkzlDuj39ycbqO1XAWHPd8giHB
 PBYKnRSLhZ2utytpK7oVE4PRQUc8mmaas3/1s/mUWFz8ChhUzEXsPf44fB2ql9PKhoTf5yzM5mC
 Iqu574NDQTz7Ow7TNKjEFdY8fCuqnfKfeZ2l4t38+YBj0RtlaLKxb4Ipd2Ct0GGmG9SlUGmKPEh
 lCstrIdyaA46ct1U6Eg==
X-Proofpoint-GUID: 5NZKWs9zDTObDkwDn80J4vezwIYz0Cye
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230067
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4042C10000B
X-Stat-Signature: 1544ga697sbck1zkwds69dehmoa6y8in
X-Rspam-User: 
X-HE-Tag: 1774256198-960510
X-HE-Meta: U2FsdGVkX1+oBEs+Ih5n2wdikoppgfiZFHumsZdoWKfyBKsz3zl0QeCCuDT4ma9X5og8w3hDmleRyqJXKTHwU+zMyBr/j31ZjROIQOVcq5W9e4Z6C+8GB84oMSeFBe4ew+DBVRItPo0peLJfdAC7KdqoH8zIl7QbiQLbnblE2m13luIj7Y0cpdq5XuWJerGPxkEzA4SzkLrJFBnbV3T7hOATXwKuxxbvuAx/X6Jfi5UGwVJvi5BPo/mO/bMO6S5kNWJXZPkJTifq/K7rogb//eNVATUjuu3in4N5d6TJPpa41541hbJvDPvFYZ14+NWldjNb6So3gbCcQ9dfZv3qPGpq0FWEpckdVndLgs6CSe5otSfuo5r1HNPUHszs7vmx8YWMfz6DwxmRH1cg9i+85VxB7mFsqT02H38hmTdT2GTzuu/vgQCiWRtGM4rtjqwbB1DygYIFwSSwuIjlulrjVMQ1CCNGIHsCxu47ovp45gs0g+3AoejCnUunPBsiqtWDup7ZITOFQEP+grasY+DJpk98MLnfYCkdmggEdEDWfenuWidMgIDyhfrDbOC4wF28gdcyJtz1U5DzpvY7K6kWufp0StA8R1r4ywAk5Tz/+UUQoXhqEFhCCrUCRK5b37ksywFMiJ5vGaJDgcEli9pSn/cUzz1SVcGCThfHkKabAIjxJDeoeHNg5TLHA9gsIwaYA/vf5bNmoiG8QuoasHoRkn016F3Gj7GDEyypUejte3OMov0/4muGAIupWccs/Nu3VbL/iQA8hkPENIb4mUaxH1lWigETrJWYPwsr5tBzRYZ4filwfvxo3ZV49DXj0nylegzP5r/xyoa0n5k4HlsOk6HqJYs3xFtuUEaiB4MujSTXE5yqvN11WBBY35kDtviN962ca2gtchUGp8Qb2DWl6/u8O4dc3Mf87jZqJDRgVxAkLGKPWHkHQbzPGsxqE7aLSKZYQMFW9RnL+FYnegW
 1FWRYuXL
 BnEKQnBqIFvLOFU3qHICqp+tbo9Ce2xcLXvd2bo88tZQ4oSQmETtrmooZmLjT4pjHYeebaMztb6PYAoMSTUJDf7FXri1jluCsbj3e2m45LEB7J6Lw+JHLogmGCX9Z7aQ7uRjnUhSIlT4nc9DuVvCQT2xziMorl9o1YDZqFzBelGGz/1ojqwYL5wcJETM0RjaavmJdpqIBtj00U+1oP7xDJiKZtM/HBYd4ekZgUZXyHxEE7aR5XlKLmjfCR6XOGeLQbkRiEjkHSilejlhoibS3KOgTdNbDP6ixsJqE/aaHHa9IXufnnZuoELy5WQD+YGDNkXM7r1E1YJV7kas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/21/26 4:27 PM, Kexin Sun wrote:
> The function memory_block_add_nid() was renamed to
> memory_block_add_nid_early() by commit 0a947c14e48c
> ("drivers/base: move memory_block_add_nid() into the
> caller").  Update the stale reference in add_memory_block().
>
> Assisted-by: unnamed:deepseek-v3.2 coccinelle
> Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
> ---
>   drivers/base/memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index a3091924918b..0d6ccc7cdf05 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -815,7 +815,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>   		/*
>   		 * MEM_ONLINE at this point implies early memory. With NUMA,
>   		 * we'll determine the zone when setting the node id via
> -		 * memory_block_add_nid(). Memory hotplug updated the zone
> +		 * memory_block_add_nid_early(). Memory hotplug updated the zone
>   		 * manually when memory onlining/offlining succeeds.
>   		 */
>   		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>



