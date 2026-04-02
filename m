Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2047CC6B1A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365D46B0088; Thu,  2 Apr 2026 03:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316DB6B0089; Thu,  2 Apr 2026 03:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204E26B008A; Thu,  2 Apr 2026 03:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 104FA6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:37:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C212E0F05
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:37:49 +0000 (UTC)
X-FDA: 84612811458.13.3B14722
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 32DDA2000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:37:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U9da5meo;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=U9da5meo;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775115467; a=rsa-sha256;
	cv=none;
	b=7nD5/E2Iyr3GlyreysYYV7HwSMv9+pYJUQCrxz2wKuTdx7klui7aIUU1JJK8qA3P7NqfbB
	BkXEK1ar3hWInM1kKoIhoNY68jiHCWnareL8FUVBHv3Nvys3COIlYcfWkXLoREmvxO+6cQ
	TPTBtAUvhn5MPEmJHJc+HtlH3qK6AO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775115467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phJ01w2m6VFY3xoBmiLavGXCKH3byF8C6J8VTpkH1eI=;
	b=q3MaUEQV941pSN9cHnr0JMpAu3ZcWx7viYtpMypuPKFb7f/47noT34QIgS4/okTR6rpHPJ
	1JZJ6IkRK270xJi2gKqkD/Xrs4/KRCzCuHH4L5dsXt3oCPYoY4xBC1BCyUwABtj6Y1LF7A
	kRi+Aw9jLnUltbBcB4rSpwpVihX9fts=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6320NBqH314183;
	Thu, 2 Apr 2026 07:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=phJ01w
	2m6VFY3xoBmiLavGXCKH3byF8C6J8VTpkH1eI=; b=U9da5meobGMO2MgtRrZ+fr
	yOExv4ksO+a2ib8xR1tp7Uqbtb99JTItCCS0ISQOxDT/3Ixx7z9c3U9mbJmvSsbi
	y1OhxXtUjjCic6vFNweP7dWkzE83Yu4OG6ipmjmzoLzmT+dPmLShefleRXwOvTYA
	TZ0DgP4QuPxQcfAWm9aEL3PEh29AOHChtPjK6PZezDDQyndqRIj1NOR3gZN8eAPB
	17Pu5SHQJUBzOTSdQbaw4+KXdHVbm1CUCbhuTJMaY7Fw3K/VYDCRka1rPEMgqbDq
	V3H1saB/ULTFmtDOOxw3ws3dZnSEsUiVlla9WOUvX/dhm6yNLuvMR0t/4Vark58g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d64dgu3be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 07:37:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6321iuXG008698;
	Thu, 2 Apr 2026 07:37:34 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6v11rwn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 07:37:34 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6327bXAT6226632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 07:37:34 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E181D58058;
	Thu,  2 Apr 2026 07:37:33 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5029958057;
	Thu,  2 Apr 2026 07:37:29 +0000 (GMT)
Received: from [9.39.16.6] (unknown [9.39.16.6])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Apr 2026 07:37:29 +0000 (GMT)
Message-ID: <3ab0e5dd-cd3d-4f78-a7ee-01051f200b36@linux.ibm.com>
Date: Thu, 2 Apr 2026 13:07:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
 <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
 <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDA2MyBTYWx0ZWRfXyNHigohVT/NE
 jvydsk/Q2BNTNFCoiMJdue/G6An4WhO/mRYZVMdEtXHnrIILchW0gh5L8QbZwEeI63RACYM6vS8
 B4OyKwEB7IqmTqaW5XBvcB1OKDubtJLsCVRORESdlJZIVX1LvJUF3IuhwAkON3GUv/HTHMNey+H
 6ofyBr7SysXPQ2uTuJStZsHIe5AsQSL5LbXD8uKyy7l1zoVYhrtmev0JVXfEX506KxCy8/zhA3U
 6jsmClxzdlGP0lZDk5geCKLmxs3JVsa3u7Hs4XOYXNHKTzC6zYtntLjXFNcjU3IRXiHexf6BNYn
 qpVDziy/plfyIoy3aJ9ILIhw1rcUVwpzOBqC69z0uxS/v6VSFiNsUTlvXVRrCFqImz1rEz8zoPF
 71lorC25ZXmSSjOveujox1Rq94YE90vn15Sx5yri+hWRRS5QwGxsKXetflzYqBY22SZq5A+6KfP
 8m6tGAAy9Z3G3AxI/cA==
X-Authority-Analysis: v=2.4 cv=QKZlhwLL c=1 sm=1 tr=0 ts=69ce1cbf cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=968KyxNXAAAA:8 a=LABA4A6g8ucfnDsEYEMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: m9KsDZjHJTwdLY4j3iWQAvKm7OWMyiRv
X-Proofpoint-ORIG-GUID: m5QEaLQA9cH8fdoYAzD5PlSY6_fDZ894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020063
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 32DDA2000B
X-Stat-Signature: fwh86ma6pjucpdi1esiaonygszqceayi
X-Rspam-User: 
X-HE-Tag: 1775115467-602513
X-HE-Meta: U2FsdGVkX18/Tz63HeXjiFX6l8Rg6FjDRR94IpTPt1weds/Hi7Ax5c6dooPfHc+Yjczd4DSvEfPwD8p01gg/wtWO2RrgPkr8ylZ0x5BGLZSqC6lfiec1VzTBl2O3IRQ1aX+2zTYbQMz2YuHBpr4f43QAiGi0EAiNfjpndkncfzw1DNBPe2+PDzSvBt5fs1PJDRlKwrJeOygYkZTyZsqNQHwsopElTNYHSHJcLOodg9zmsyPEJ76zGa6+2OXpJJ9qqQNu9LwvZiyGkymafiR/3EdluLGx+uh1UIOqZayf4BYQHKMVw6/s6ivdZD/qd91GTWVx/cf0GwD0uC8GKVKarh2yJYCfXGi2hBrO+EIFpPkOMYfcCHd88Ago1K5rfhL1zrRzK1UmBIirOmxnrFsitANqNIuFS6CO5LyCX1Y5ZaGvJ15ySNRmSdgSHjOOW7hAdqXChrZvtNQDe25ssALCp/v8xDhTK4VNemOh2TFG4+OeqluN8x9Ap/03bVMkwL0adB72uA4bMBKOw/146ow1+9P+9me/TwpFy+yPrwDjyeFfW0/GJ/voOSTRaYWEJ8y8Fg69p5e6HAu17Z/QC7GSEmmYoC7IQsKJQgoBpXQeU2u/8zeJYMDJfoHz/h7xrwNaASzHWKI41rWbV2BaX7SJTaihoK6Sintpr1EmIQTWehirimsKN6e7wxxUvVKnElxthiaGoiqsuKydBASWOxhZXMkGqUYhtyAAgjVzLjKtqrdZ+DocZOzZTO7oeb1uiW+a87Cxf6V9uQ0hC+yoEZeARO2uNBHd4T0+gQG8xgRgjP99qxlhxyXKoOiDwVhKhva2uuVhkVZH/Pdmi5cOnaQ8GgBUf2LMq9432f0zIr3dtKPUmBFMzf7FFXlMoE7ybGxlPVq4QFHR1Id1wrtWJxHNrhMXQE749PKRtOcx7t+Mk3L98B82Qr07Sq8Zmo/nezC/FtPoE61vgRwGghxMIBA
 bdtp0zOC
 onMR1IXI0EKMQgJLlgVG8T35gaHZIs0CaADrp0grbflBlrdz36ty3hCHYu0Xo5ulBeMqll8lqBBkt1hF3FTivIEp2fca+lhPmzJ0Am1Ii04O9ypYhukqJtZRYo8isRmEgO4pfs2nB6z/u9Y2nXCVz6Q/ImzqwcROm0Q7f/YF8FM050AR7f07whHjmwQ+BROMDNEAC+A7mk8q5zBVdVSp7v33SYLgEOwgl3uE/5VXmCdwlugZxK84f97+J4Tw9b3jAkbJwCov3b9/3s5thgqYJvv47KpilwGc07Y2mJ5th/WXn2s1xDJK39pSNNLvLLSdXY8ENWQj0SklW9fZ3XJm3K0EhIaAYbSeuTCvUDTV8ozTpmQYdvG6tN2K8ESw7G9uG8pj0L61FQbKpPXGAHxi+LH9NaSs2X6HA0xwAZxxojYwodWSZyPTo6Syo+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/1/26 12:55 PM, David Hildenbrand (Arm) wrote:
> On 4/1/26 04:41, Muchun Song wrote:
>>
>>> On Apr 1, 2026, at 04:42, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>>> On 3/31/26 13:37, Muchun Song wrote:
>>>> sparse_init_nid() is careful to leave alone every section whose vmemmap
>>>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>>>> clears section_mem_map for the rest:
>>>>
>>>>         if (!preinited_vmemmap_section(ms))
>>>>                 ms->section_mem_map = 0;
>>>>
>>>> A leftover line after that conditional block
>>>>
>>>>         ms->section_mem_map = 0;
>>>>
>>>> was supposed to be deleted but was missed in the failure path, causing the
>>>> field to be overwritten for all sections when memory allocation fails,
>>>> effectively destroying the pre-initialization check.
>>>>
>>>> Drop the stray assignment so that preinited sections retain their
>>>> already valid state.
>>>>
>>>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> ---
>>>> mm/sparse.c | 1 -
>>>> 1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index c2eb36bfb86d..3a14b733bf71 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>>>> ms = __nr_to_section(pnum);
>>>> if (!preinited_vmemmap_section(ms))
>>>> ms->section_mem_map = 0;
>>>> - ms->section_mem_map = 0;
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Thanks.
>>
>>> I have some cleanup patches lying around that cleanup that code heavily.
>>> I think I get rid of this questionable "failed to allocate" case entirely.
>> It's truly a coincidence — I also have a piece of code locally
>> that does something similar. Since allocation failure would also
>> affect subsequent startup processes, I simply made it panic when
>> allocation fails.
> Don't use BUG_ON, use actual panic(). :)


Apologies if I’m missing something, but would it make sense to check the 
section validity in memmap_init() instead of panicking? Is there a 
reason this is avoided?

-Donet


>
> And yes, we should rip out that handling.
>

