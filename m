Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECEC3C98338
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 14:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4836B0088; Sat, 26 Sep 2026 10:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4EC6B008A; Sat, 26 Sep 2026 10:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393F06B008C; Sat, 26 Sep 2026 10:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9186B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:46:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 203581208EF
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:46:53 +0000 (UTC)
X-FDA: 85256190306.04.B2F68F8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8FDA040004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:46:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UKYHqpcy;
	spf=pass (imf01.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790434010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuVElNNHPxhTvXMJfRPaqVwIwab/ZdlWhq0acISD99k=;
	b=h41ZgPg8uOXgoiYYZDs5t4Gyn8zq0uvE5HwpCciiTLH1CeutY+R7BdwfVBrntJUeBnOviN
	+ZZB8Yk7VNIgXNRaNjA9snI8Qe0GCLiQkulKQRx9ulfCKzQRutlRqfZe9HQNWkxXMPTHwJ
	z9XvY2BqmKdV9PJt9twmB6pPSzZQ4iE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UKYHqpcy;
	spf=pass (imf01.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790434010;
	b=lIet+5QCncPIh1cquWMueWqkX87z4X5aAYSISH8OYpIkew9UMrUH29R1EC12/3f1yVudd8
	O/Ns7UB2KMO37ku2MuQVbWD4+NIGRyOf0sg9KXoBvTj/Evpkdg1O71bYTe+nZ367u7XUCK
	ASxxadslqJuC7dZM65Iw0GUQXG1UQio=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68QE5lkQ2255700;
	Sat, 26 Sep 2026 14:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GuVElN
	NHPxhTvXMJfRPaqVwIwab/ZdlWhq0acISD99k=; b=UKYHqpcyGxl7bkFErh8PYH
	tEtydmGYRqkiLgud8OZ2Jnt3pMyoKSbHSO/U5NjzC4rwlZeoZEQOU5GVbgnuKQTR
	JBR0dBz3HgrQhx4xLHCmXklG/Y52AdQ54BMnPWaQVdSOtgGxtzHsIwZzYva0Hzks
	8qo2aaJzuzMJQHIcJb8kSx34oy6Mno1ehUQALc1f1Hb5U0TISz3VE+7aUpIly37b
	9ylfkCUpAYERpRw9hxBKZMG86SyL8g2ApESnMXX75I0VGODFzmmyp2VMS2otIZ9m
	nawCoKShBXQKqBqMDcrtoIF0grVAupc4koPczjQx5d6qMP/bknczlJ16eIoL9i7w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qqspug-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 26 Sep 2026 14:46:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68QDlXeb1378649;
	Sat, 26 Sep 2026 14:46:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gwy27asra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Sep 2026 14:46:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68QEkbN526673740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Sep 2026 14:46:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2C8B20043;
	Sat, 26 Sep 2026 14:46:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 811B420040;
	Sat, 26 Sep 2026 14:46:34 +0000 (GMT)
Received: from [9.43.82.149] (unknown [9.43.82.149])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 26 Sep 2026 14:46:34 +0000 (GMT)
Message-ID: <e265fdc8-e224-4815-b94e-9c974210f099@linux.ibm.com>
Date: Sat, 26 Sep 2026 20:16:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kho: fix global scratch size calculation
To: Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, Alexander Graf <graf@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Guo
 <guodongtai@kylinos.cn>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
 <areLMLTC-bO1zcXP@kernel.org>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <areLMLTC-bO1zcXP@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI2MDA1OCBTYWx0ZWRfXxvSfSzlMnSzp
 4z9xWrA4kTaGa2K1o6Bnlro/QntTS7aro4k2KZlX0qiBEVHMVJyUBTBaidGMVZuiWXkvZlwB0jx
 gq8LmIZf3qS0WNnXYMxo4ZcCeCnL+pUr9p4HumGdQvNNQB+dVVw0pOizn60xVX62X1iw/K3e2bF
 7QHUahmDgVwJcUOCnFUnyDB+gAL/rpiMHZJ58M67bqfTTxn/W2BPAteDgonG2FMgk8ulG5/9vxK
 7NoqvkBlP2HW/Z7CSv/jO2sVsCoZo/TjamKX7R8iNiZhI0pcJCflWVwbr2E5+pDI3kTEvhte0az
 KYcP/ICHovVco+HTNlEWcSuV3qaOIlQF5FPc6Avje7qD7XtTSHIYVwGX/JX2C8A0n/xcN5p8j4x
 Y1RzFVGnPHliM3xMXcFDJZjQfYtECzBPlj9GbqEzBUUldVXjpk8hf2B9r0an6PKvX7aIa1EcUwo
 vRo7QPdOeMOn924dUbg==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6ab7dad0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=vggBfdFIAAAA:8
 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=7ipKWUHlAAAA:8 a=pGLkceISAAAA:8
 a=37rDS-QxAAAA:8 a=VnNF1IyMAAAA:8 a=bNo-Hw79ofwCn3g4lxgA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=gpc5p9EgBqZVLdJeV_V1:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-ORIG-GUID: kzbMAnA0xg_o3d0chYonMeVx77MsnSDA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI2MDA1OCBTYWx0ZWRfX1BJ+9hxWRDhF
 Y0HoeQqKTA9R4NDekMNrioz7bEDZbtzVBlL4vmkbuRkNMM1N8aSznXAhDeb/XvgqvVFpveJfOHR
 tiuaYFq5NEBnQC0lBcWltAqQFm7q/f8=
X-Proofpoint-GUID: BDbcgbsLYGFIuH4mxew6Px8aHk3t3IPu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609260058
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8FDA040004
X-Stat-Signature: msdz3aot1mjhocwbdf6o6bgjq4ugefxx
X-HE-Tag: 1790434010-236683
X-HE-Meta: U2FsdGVkX1+JsdYYS5GPNUEg56ukan5jN/Lr2vUXu19FJBHtn5ZTG292wkNu1LRDlP3EWylLJd3CVMW5yY/ArKR7W0cyMp2y/xx/GjSplR3BVmmU5UtMS1SUxcb3c7muXWZJyIGKRcQS5IrTZX6a0earfk0QhK0za4/qBNT3uy44FO4fPabXb0/KKervQr+W5yT3k+Om1O/lZ2qi586L5vb13JTFPBZftFFT8R9CjJSnjio0vvcmyKL/DlTwuymkgSGHExSNHAg7j5IdjvcV6Voq+D1hJmUR5gxwZw4OAyeZp+HT0Bd/kwjDkXoavJDVdEFHLRfxWpTgAw9FGQUAQKlC5PsPY/s1+RshTTecXhzGX8QlYmmJKQRr1GnxqVBSHkfycCxSgMU7QKF174jPq08PZkD7OAkbfuLZutPIVwThnX+n2OmbOoSUA9n8LRnphgV87TkaL4+DPLx2r177K9kqv55v8JpCkG+hNbMM01TCMl+2Tn8q3fEZQeNS85fSLPkgBa90O1ChGytD5Ez70eGKpHPw+3UlgkN3ZMI9+8XR4mv+T8YGk73dyMErwDjH39q+EFPjV617peDKynBReg5lLsvUKUr57JOotTBnBSZgw9oTZNzCbpTkKxLub2q1G0TbprJFy0p7mkowX+iPlOXCreT4dr2H5c32tDX+OpUMJZNjODp5tpFsZMWVJw57+0iCWYFfNCgPQ/OUEswPhUYsXemyodii+jJmiZZ5RAwxXm67N8Nlctr96KqP7oyBZ5+kfvDtLO8gm/doYpmsGwCS0onBAAmO5ncZzUOONNBNpNWeg5zsrECpqZLEJctq7Ys5mZek547VxXzt3uO8293Vr6L9uNqn93QFKaHJ922ThcwlZelCR52OTzeYBxvaM/G0HtcWpd+ew40K+ejyC8w2X5TwN/gY+yXxfcsNi4o5BCu7rj7wOO5B41xNQ2PkB91CUgwOYnmNltDETAa
 YJIB6tGs
 E1e8+fYONsUUupgUimQKY8XhTHrQRADnoQa8A0ziwef54Y3vF1WXLdfsSHkQtxDO3p8TXIKIFG1lD4J6+QhpyA+0vQ5wGXprn6ShE6oqx8M0eRd1xagxAZzQZDrkaB72FyiT2R3nrP74tWV5pbjQvx572NbtRXaq1YsNBNGJWuIGWeMnl+04BGXR7nkP9x2UGlyRfK//6RYei6h7NOUzp0l3dy20a49MaEWSAHlgBNKx2vTBAhNMWctxnGcO2bDRZAI9k8kuw0WUS1iXOnLWKFJ/APvkSEf1EZsbpTQBJIlKldg4BkDHCLVTl29X19n84z29uCxOEGVe5ICcV9AgPQ4R/7NWBz4EJlNhqGid2R183GC4geA/M2qmBdVQQjpASNKJrljRPnDOaKcoU4YcrXK08NSFZuwwKJyeAuWOJF1r1x33VpqYkgFEw18B/QkM6ECVmL/S3EzjT86DsDiNOmKNftQxVV+6qvu4iVAoMaFc3TC3450dWWojAAeydquW7A87SQRqTWkLBZGgvPVmTqKn4y/5oEgRjau7l5FACYukXTPTYS0XLEMNM2c/YsqlFNxNAmKR+Xwwq3JWu9sVsgbdtXiVxJVSHU6WYeoiR/V/XRsDaqQrA5w6GK9OGcXmxzqGUL6/3OYFuZRcmri4th7V9WHYqy6z/3WvD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike,

On 26/09/26 14:36, Mike Rapoport wrote:
> Hi Sourabh,
>
> On Tue, Sep 22, 2026 at 06:42:16PM +0530, Sourabh Jain wrote:
>> KHO calculates the global scratch size based on memblock-reserved kernel
>> memory. It passes NUMA_NO_NODE to memblock_reserved_kern_size() for
>> this calculation.
>>
>> When memblock_reserved_kern_size() is called with NUMA_NO_NODE, it
>> counts both:
>>
>> - memory reserved for a specific NUMA node
>> - memory reserved with NUMA_NO_NODE
>>
>> KHO needs to distinguish between these two types of reservations.
>> When calculating the size of global scratch memory, KHO only needs to
>> account for reservations made with NUMA_NO_NODE. Reservations made for
>> a specific NUMA node must not be included in the global scratch size.
>>
>> Add memblock_reserved_size_nid() to calculate reserved memory for a
>> given reservation type and NUMA node. When NUMA_NO_NODE is passed, it
>> counts only memory reserved with NUMA_NO_NODE.
>>
>> Use the new API for lowmem, global, and per-node KHO scratch size
>> calculations. For lowmem and global scratch, count only memory
>> reservations that were made with NUMA_NO_NODE. For per-node scratch,
>> count only memory reservations that were made with the corresponding
>> NUMA node ID.
>>
>> Remove memblock_reserved_hugetlb_size() since it has the same
>> implementation as the new API and differs only in the memblock
>> reservation flag being checked. The new API handles both kernel and
>> HugeTLB reservations through its reservation type argument.
>>
>> Define the new helper as a static function in the KHO implementation,
>> since it is only used by KHO and has no users outside
>> kernel/liveupdate/kexec_handover.c.
>>
>> On powerpc, the difference can be seen in the scratch_len values
>> reported by:
>>
>> cat /sys/kernel/debug/kho/out/scratch_len
>>
>> Before this change, the global scratch allocation was 0x12000000
>> (288 MB):
>>
>> 0x1000000   (16 MB)
>> 0x12000000  (288 MB)  <- global allocation
>> 0x5000000   (80 MB)
>>
>> After this change, the global scratch allocation is 0xd000000
>> (208 MB):
>>
>> 0x1000000   (16 MB)
>> 0xd000000   (208 MB)  <- global allocation
>> 0x5000000   (80 MB)
>>
>> The 80 MB difference is the per-node reservation that was previously
>> being included in the global allocation.
>>
>> The same issue also affects lowmem scratch memory, but its impact is
>> limited because the lowmem scratch memory calculation is restricted to
>> the first 4G of memory. The changes also cover the lowmem scratch
>> memory case.
>>
>> Cc: Alexander Graf <graf@amazon.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: George Guo <guodongtai@kylinos.cn>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Cc: Pratyush Yadav <pratyush@kernel.org>
>> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
>> ---
>>   include/linux/memblock.h           |  1 -
>>   kernel/liveupdate/kexec_handover.c | 49 ++++++++++++++++++++++--------
>>   mm/memblock.c                      | 22 --------------
>>   3 files changed, 37 insertions(+), 35 deletions(-)
>>
>> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
>> index d62db9e776cf..678fe466529a 100644
>> --- a/include/linux/memblock.h
>> +++ b/include/linux/memblock.h
>> @@ -487,7 +487,6 @@ static inline __init_memblock bool memblock_bottom_up(void)
>>   phys_addr_t memblock_phys_mem_size(void);
>>   phys_addr_t memblock_reserved_size(void);
>>   phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
>> -phys_addr_t memblock_reserved_hugetlb_size(phys_addr_t limit, int nid);
>>   unsigned long memblock_estimated_nr_free_pages(void);
>>   phys_addr_t memblock_start_of_DRAM(void);
>>   phys_addr_t memblock_end_of_DRAM(void);
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 7c4d86daf86d..dc809e1e768c 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -752,6 +752,31 @@ static int __init kho_parse_scratch_size(char *p)
>>   }
>>   early_param("kho_scratch", kho_parse_scratch_size);
>>   
>> +static phys_addr_t __init_memblock memblock_reserved_size_nid(phys_addr_t limit, int nid,
>> +							      enum memblock_flags region_type)
>> +{
> Why is this in kexec_handover.c and not in memblock.c?

I kept it here because KHO is the only user of this. However, I'm happy 
to move it to
memblock.c if you think that would be more appropriate.

>> +	struct memblock_region *r;
>> +	phys_addr_t total = 0;
>> +
>> +	for_each_reserved_mem_region(r) {
>> +		phys_addr_t size = r->size;
>> +
>> +		if (r->base > limit)
>> +			break;
>> +
>> +		if (r->base + r->size > limit)
>> +			size = limit - r->base;
>> +
>> +#ifdef CONFIG_NUMA
>> +		if (nid == memblock_get_region_node(r))
>> +#endif
> Do we really need the #ifdef here?

Yes, otherwise, if CONFIG_NUMA is not set, the lowmem and global sizes 
would be 0.


- Sourabh Jain

>
>> +			if (r->flags & region_type)
>> +				total += size;
>> +	}
>> +
>> +	return total;
>> +}
>> +
>>   static void __init scratch_size_update(void)
>>   {
>>   	/*


