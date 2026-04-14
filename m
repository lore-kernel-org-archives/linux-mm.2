Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB8AED7B93
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64146B0088; Tue, 14 Apr 2026 06:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B156E6B008A; Tue, 14 Apr 2026 06:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD866B0092; Tue, 14 Apr 2026 06:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A17A6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:10:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F8661A052F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:10:40 +0000 (UTC)
X-FDA: 84656742240.28.22760FC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id A07D2180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:10:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q3vm+scw;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776161437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+vAnf9HO6hX0LxtjPx0c/OXbUSB/M49cLK9fLN2iAE=;
	b=5H/DXQX39Nmr54f0POs2b6U/YCJq74Rer1QwjIcNUK8pHVH5UL2ZD+47R0Xt7gETeysWLx
	BygGhD3SUmDq+vpf6W32JyvfBPk//HnW1pHAWClCd5lL2HEoB8HfFOso9kxdlOlOi6vDvM
	z2kevKALLeVwfO0eJF20vSsUFNCGi54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776161437; a=rsa-sha256;
	cv=none;
	b=uBObmpUc2AtgDrABn+YvekX5nCIWutr7a6q3hcaYfD+1A3r+86aEi80pjpYkF5gsFRUUWa
	nCGmnzirmD7q4kD09RwPANGt8bV8j8olzi+jHw6S8Qw0+C3v3ZFJRSI2X0FPAFJy9Iyjs9
	+qKpYxNbQUm01zUcJ/U99eA8OKK3GAw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q3vm+scw;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLISOU1859895;
	Tue, 14 Apr 2026 10:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=c+vAnf
	9HO6hX0LxtjPx0c/OXbUSB/M49cLK9fLN2iAE=; b=Q3vm+scwhLWKJBszO3MfOh
	KocPdE0lA2LH7Cdh6h/BJnfZ4WWA4f0H7eYDWT7a3pgM+SAVIZ6CuZxlmIh0weFN
	OkiNR3vzYa0d7p7YQWrCXK1LT0L7ikY9ExxOk0ckwJ0CegTO8ILh+2tvpbKHZoIu
	w+tqEt1Tv1ruEESIPAaCRJdDQXJPvYia/iKOynxxWWL4+upukjLY10sn3AC2mVJt
	9A65GVJfzS96LP7Z0BJNWLlOPz90Jbvc7gXQCh2RE/qPmsPcFxf4oj5ibHKkFgLs
	yYGXE7rokmrGH4iaWf+Ro41gjc79fYtiCTeI30EdtqtXoI3KfxwOUMMqZI/KbYgg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89pa22m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:10:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E625QQ025643;
	Tue, 14 Apr 2026 10:10:32 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgs8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 10:10:32 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EAAWPE32899744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 10:10:32 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFB415805A;
	Tue, 14 Apr 2026 10:10:31 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B00A35805D;
	Tue, 14 Apr 2026 10:10:29 +0000 (GMT)
Received: from [9.124.215.107] (unknown [9.124.215.107])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 10:10:29 +0000 (GMT)
Message-ID: <c55c706a-6352-47ff-af80-a293283153bf@linux.ibm.com>
Date: Tue, 14 Apr 2026 15:40:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memblock: fix off-by-one page leak in
 reserve_mem_release_by_name()
To: DaeMyung Kang <charsyam@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260414094439.982853-1-charsyam@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260414094439.982853-1-charsyam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: RGE5jV-OWe7qMixUoFkcLYQcc8FQsf_k
X-Proofpoint-ORIG-GUID: HZAixD2OXk90cm6XCPTCIwmW_Jpk_QPY
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69de1299 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8
 a=A9Q-lSG_ta5snbpTm5QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA5MSBTYWx0ZWRfX8bc6P8Xeb3kD
 MIRCL8cXNj3khyUrB2YBrigT7jzdqDIIyltmBn6YtgqZWZ56UaxlcTTfHRNg0qi3bRAx8BmeiPw
 in1OyO/JcE/RnB1nVSaOn1P67YPZsfIlVFELOvHT94Xkk4R77Yh84EAMKGuXIk9RbJVful0Yp16
 Fc/xWHVvjp0G5UL3WhNcZ7uCKXzVkL8LIXTtPmHN4pOVOz05jB5M3giq3xPLSGlblbCQlhcjsjd
 9hzOm5LlhoBgg5kVvYooaVDeCyWT9ZwsDrvl92veR3gsHJ6dP90KMmKAjPhaFzXjgp2fgK4Sjfv
 /iJOlWP96cy/61hcsB4GnrAo0j1DLefZO2uKYhA0ecyb8zLZXTvUP8Ntx5HoXxyPidnYHeYVcHQ
 BO2hx0VIG7ZszxPLoypghl3lsBJQKMo+5mouLWeop9L07HDV5y3Zxgz47nAJLayQxGu5PKDu1Bi
 5X5Ny1fa7DLPywKeABA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140091
X-Rspamd-Queue-Id: A07D2180007
X-Stat-Signature: goukfnp54cccjbiyeijpjr8aqsg11fzz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776161437-295886
X-HE-Meta: U2FsdGVkX18tmWA28TBwrkSrxzeViaS7D3ygX0suNQTP93YhaHOCPAZeUlgS0Cu5EiRYTqYDbOQILj5TU9wiRPr7cDLGM+45WCHpiojJNS6qBBSugE2uUarZmhmHAGHueaLfQcohWRZZUzFo9UfvT2pd8oV3brjGRZMczNl2Ve/MPEWwpWWtlFlOEdgS0IR5o6G5ajqrzaWYt3h64JELX6lwOWHFmn2TlAcYJqxR7n69Enjw9Ugb+smsAUY3EKNvSNgmLTdGg2KYFYHRw5VB0ZbfEMmPUCMWumN4M/3mlxdnkX97zAQzTAmLQgakvBbMLjHolrtD1U4ppuktuG3u3ledk5zEbUP6U9iFBnTT5FxSdB4bpc6I/XGn+j9uAKpMXgaNlkRb+aoQO4dJhg5IHxg/B7zT2k9ZIiGdtD1NMQtm1taLrYBDfB1KFSIDapkaKqPFgBqz76Ce6r2ccVOfJZAOoulTYjnAjJSTIGWQA1tYkNp6eRhGfaxSwfJfYrbrEv1ZwmqmBdYsten/h4gB/pe7D4NKwKFa7vuVjWScDMsrf6SSMEsLTiqgp4sR5Wdz57oqH56iMsudmDZy5TsZs9QfldImDeRcl11xUI1r6EgMkRmRq/yeqES69owHeY8uppULdSyUIGM5l4mD+Jt8dZsGmlxcWu7iUmSyvOAW0EJ9xcE935UD0az5b0SPYR4eI3Vp7XmH97RyO+u532a+m9Z4k+J9RrNYh2iZdChJVKpz9d0add/0kFshLLOvOWgQOMahGlsGVt+x6m25Xw4lj0OGrC8i10ovbzEgIr6VYLEZoYW5kDZn0mT8416x2wSqooajFAzpinfKulWdUEtvOlxI2J71wHXjGahJJSjDbj7bqO2/xRrj7i6x643y4tCTb6IAgBz1m56dXHRFhLrHGUz2dzSZMgckxavLBtQpvPTe7DX1mhQgNL2Q7dYVOH2UwvB7ytWqw8i9W204f+E
 qbEwDczD
 zE9ztUalBUQhBxDr8Nv5O81YrNlcU/KdejbnU9d2L1MuKz+YLhmQCMoHp55pbQuHZxsamYz8T0qLDIwlUZO0dh+c2nUgFgc+GYGsipTo1cOPYy9d+U1M6Lt04kGoGH6fprYKt5sdgizCYAysSrpf0y62MgQ/nXV8wS1lgzzVhluftMfrY0lTq/Z2NDubAj1gtWhz4L+LAfnYpfTQNbddPMeyEcQ5VYMDR3TqS9/9XxJJBfRis5xm1/4g/qQ7DC7LJVF8AWUOB+ECIQA8TVD3rclETY+scKzCxufl5pKL+txLb4JlzDUREflhnk3aRCcFVNonmEtLQSBzztZG4PmHjc1n5nMFWuyOiYild5P8d9Fpu3QQ2d6lYFiKfjju+nbiLRuQf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/14/26 3:14 PM, DaeMyung Kang wrote:
> free_reserved_area() treats its 'end' argument as exclusive: it aligns
> end down via 'end & PAGE_MASK' and iterates with 'pos < end'.
>
> reserve_mem_release_by_name() instead passes 'start + map->size - 1',
> which causes the last page of a page-aligned reservation to never be
> freed. For a reservation spanning N pages, only N - 1 pages are
> released back to the allocator.
>
> Fix it by passing the exclusive end address, 'start + map->size'.
>
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>


Do we need a fixes tag?

-Donet

> ---
>   mm/memblock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..d4a02f1750e9 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
>   		return 0;
>   
>   	start = phys_to_virt(map->start);
> -	end = start + map->size - 1;
> +	end = start + map->size;
>   	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
>   	free_reserved_area(start, end, 0, buf);
>   	map->size = 0;

