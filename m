Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C202AF55810
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835266B00A6; Mon, 20 Apr 2026 07:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7506B00A7; Mon, 20 Apr 2026 07:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5446B00A8; Mon, 20 Apr 2026 07:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 590F46B00A6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:37:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7B541409E7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:37:05 +0000 (UTC)
X-FDA: 84678732810.04.8BA986A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41AEB100012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:37:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rLiX5nAh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776685023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8fOW2YD2JY70NjQ8mdyH2RvoeYQRNdY/7nhvFwHYhw=;
	b=IDmPMnSaaJfFP/OzEW0bfycM6JFXl652AlXQhqXv9Mw16y2oIJ3mm7+7YmBkTK/wtUfNDd
	9tNoVjd4e3rw6jVxPl7qpNdh+r4gelHfVnNV0ZRJcNiY3Y+r7OC25/oxdR+c8J5DS9qu2B
	AIX75ieFw0EZDGUC5x2BdD0d1SQL5OY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rLiX5nAh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776685023; a=rsa-sha256;
	cv=none;
	b=NxTdhQ/Wi78lcMU3RAbAwvrs490+R+2PBVM/pI/SqLl0P8Ip2DNNsP/bXtoCHRYCAirM38
	q9uk1sOsVhJAQoh3yOcF1WBe27BxFbtE0F+ckUbFniyob/7ufl9FkP0qkIM+TMs4+rSZVh
	wNr6QJLq8dY9hiK8AUYHzy2LjixOazA=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KAHCC92045745;
	Mon, 20 Apr 2026 11:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+8fOW2
	YD2JY70NjQ8mdyH2RvoeYQRNdY/7nhvFwHYhw=; b=rLiX5nAheIJkM/4+XdVAiI
	mf6lNhr1+V3iCLZbspfyTK6bsdbStZeK10BS3PUccXJlAWPvJD0NYnzKzpxU9cCw
	qSGrFYRnly4tjIz57G8oyPm+AXZwMkOi6AL7K3PZB4HObV4I3KB6dBYGm4yWGKu9
	xmlU2NeaAIe9NlSNgYFTBRYvmmpzHJGgn+y854ZBbIarXOlCJGQBPa/MfNPiaxlz
	SxUO6epYHPEPiYBtE5Ua5ayeMZOmMRcmcklmeu0usDjJyGvxpZcIMwp0hcy6n9ce
	IU5ZruVtk7YhDmRiDKZmZDDs6q+/EK/KOGFOtXzjb++8ZZmkOfC10aNzb2vk8ilg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j6fhqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 11:36:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KBZOfP014685;
	Mon, 20 Apr 2026 11:36:58 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmpgg4dgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 11:36:58 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KBawP532703180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 11:36:58 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3A3958053;
	Mon, 20 Apr 2026 11:36:57 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CF2158059;
	Mon, 20 Apr 2026 11:36:54 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Apr 2026 11:36:54 +0000 (GMT)
Message-ID: <4cdb0539-550b-45c1-8c6d-c21451828458@linux.ibm.com>
Date: Mon, 20 Apr 2026 17:06:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: remove unnecessary NULL check before
 allocating mem_section
To: Sang-Heon Jeon <ekffu200098@gmail.com>, akpm@linux-foundation.org,
        david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org
References: <20260419144225.2875654-1-ekffu200098@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260419144225.2875654-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExMCBTYWx0ZWRfX+5wseoZ1F8bn
 QNLj66QD/TjxCOYD3uyXAmfsd8aMxN3/jb4ubRESOqabeLw2nW8/18MjnwJAhKyXW8YO1bGJf7Q
 KhCyklt817Ewk9on2kBEdCva9zPshv51N3iUwK/APx4kUg43sOL1pL8868jy0oX4kq9aeKINE+x
 OePiEsHTmtYU2GUjGFqVHTVrP1CKeBZ7+IKws/N7b+oYf4r4ygCBs1hGORPCn4UTqFtpEPns/D3
 4QDAKaM+uCM/yZ68j4xyz6r//+cyH8Qq06go7DxFxbU+qcGi3H0TM4LAL1lFi86nTF111+tZmHc
 WRgTiF9qehZ4OIY1B2K36Xm+UU2Q+ManCuoFm1h9yNVyubBWwxqq+TvJVQuusEAZTJ7MQ60vKAP
 YacsRnSIseyB7T7LUgwR/5jTtJQq/RawZ82sbdenqZO4cjwNzgTnqsp84Mxhl923Rjtk4cv/a9S
 RglgYQgjBvWCgmuxGxA==
X-Proofpoint-GUID: 7MrMPmNuoN0degy2T3SOvfwEukYvkTgi
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e60fdb cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=NIslptLVQr8rbYoGeSoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: qAmlAQ4nIuYuWS-DpXU3w7hSDqtWMmoV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200110
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41AEB100012
X-Stat-Signature: 3iqehkofhyu5c16jccqmzjn7kr5rb894
X-Rspam-User: 
X-HE-Tag: 1776685023-605609
X-HE-Meta: U2FsdGVkX1/alIN6AQ+DL39TBw0zIB8jRoZOkHdLo/2H8q3fLXiSjJiI0WIh0dmeChY74fSwMDagedeknzC3a6SXGQh6+wS4MSW3IsjiCwt1Cntu07wKzZbiqmz0p6Fs8+zke+HVc6tft9tQqk7pfQzcDWaZDD/RUMElYdrurFEt7hw1AwWnGwB1WZ11tTen3LZutkEhdqO7EzqvRW7YrKusY9Pe7EkS3hlXYO8T0z1XrXutF/Brf5ILwN0cNAvZ9UmgCD0R1WQff2hF1hdvewEZeTLB+8AO4oSCCoDqtnAy8j+uQbeXTKzkfngnqjubBrMO4z4rwdpFtZCYoHcKwJDWiOK+PYB/WXtTBGFl3fYL66dPGZR3f7scZDsoDSMHI8ynoiNDt8ri81QdbKQ3FtJ4DR/cnyJG5Ybt99m8gD+x/NXOdOwGlJX8Gof3KwX1ihstXSGcNxndcr69BqYuVnI2/54+GZvPMr4IrUqrwYyteKJwGcdxAisjgjK/iRrWVO2LluxGNhMO7cawk1/mXhXTGCTK2VQbDT38HQwE9PeOkfjQ2vG3enx349hqB0YT8h8EOFEDvjzPpueYfzOZgD9bNhQdMd+CN6mUspc7ExpJErgdrjImqqONyrBTkFYdLUnA39eIZNkSPBnTg41MRwBPE7qpmcUQzuIK/7wMtSvE08Wh5bLAHZ9bjQw+9qAS33eWXViT8V6BMtom6524gYjNckqyhq3CJyONiKAvPNPR1+YiQ2Q+J+/a+giGfDn1PKvTJ8ErNS/DoB+l1h7Dmb/SjfDXa1CO0RXeI9Lh7qV+/xnpAADZUPqkW1Bk5NFF8P3irZ/xqCPQdF2yOcBLSirYWdxB7ogSH1LdRrbXcveeG0y0hznbc3zTXQOrL1Yt8thGQW9JlfPKBO5OCcIciQq9gu+z7DOoTF38niDjdGPmMnSFO5nj91bKURPZoOewZxqFMcSrSgHqDqCKrQi
 PWSBZcSn
 GbZ91q2iwrnYDIx5Zu6b9Ll7Fgina6B/7TXrXRT3+2I/y5ChfBImq40ojpTRKdS0bOeisP66ilfd1TALvIHxIrcRGdHqut2PeeT9Z2NjzVdxfUEGNEJaGbDNbpJN2lWaJ0Bg2V7Fc4IzkTCNuaOvnmZuS4IvkoXmqxTBWbR0b5rZl+sV9/DqfN6gVHmUs2m2u3EVjVTuJ7/ZhtZvWEVv6Bz9RkgeJ8jti0q8pfprR7E05bVUFlnXY25E1H/rQFdBq8t7R2Djt6lij7sZd+iuaS8YoB0czcJAUVk/9WGdXV7q8Cw2Q1wIsRVKeTtUM7kt/25MiaT5LgN2s9m9+kf9jNxz8kTTVHzTT/8GBLUQ4WjVm6Yp0Hxzf4gBp8GDuRxKpDbeWDCMFunyjuzZzWE9mkxKdsZ0GAbfh0FY/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/19/26 8:12 PM, Sang-Heon Jeon wrote:
> Commit 850ed20539a4 ("mm: move array mem_section init code out
> of memory_present()") moved mem_section allocation logic
> into memblocks_present().
>
> Before that move, memory_present() could be called multiple times, so
> unlikely() matched the common case, where most calls found mem_section
> already allocated.
>
> After that move, memblocks_present() is called exactly once from
> sparse_init(). Under CONFIG_SPARSEMEM_EXTREME, mem_section is always
> NULL when it is called.
>
> So remove unnecessary NULL check before allocating mem_section. No
> functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Hello,
>
> While looking into boot information, I found a minor enhancement point.
> If I misunderstood anything, please feel free to let me know.
>
> Thank you for taking valuable time to review this work.
>
> Best Regards,
> Sang-Heon Jeon
> ---
>   mm/sparse.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index effdac6b0ab1..e13f9f5fa090 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -201,13 +201,11 @@ static void __init memblocks_present(void)
>   	int i, nid;
>   
>   #ifdef CONFIG_SPARSEMEM_EXTREME
> -	if (unlikely(!mem_section)) {


LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

-Donet


> -		unsigned long size, align;
> +	unsigned long size, align;
>   
> -		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> -		align = 1 << (INTERNODE_CACHE_SHIFT);
> -		mem_section = memblock_alloc_or_panic(size, align);
> -	}
> +	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
> +	align = 1 << (INTERNODE_CACHE_SHIFT);
> +	mem_section = memblock_alloc_or_panic(size, align);
>   #endif
>   
>   	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)

