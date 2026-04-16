Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA21F433C7
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 04:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CC66B0005; Thu, 16 Apr 2026 00:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A750F6B0089; Thu, 16 Apr 2026 00:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A1C6B008A; Thu, 16 Apr 2026 00:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86EA26B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:40:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25454160449
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:40:35 +0000 (UTC)
X-FDA: 84663168030.04.5DFAEB2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id BC9D6140008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:40:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o/a1t3og";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776314432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocBwvM8LLinmE6lLgYosYUJ9poUW6iu7VmYJ9PnLyF0=;
	b=i7CDD7HIhjHWmC9MPUfzWrktlEoiPEJV6UWNtxQJKKx808F6DEpQz70LTTinXs/BzlmEuG
	6PSU34jnEE+9EpIgcoG6/+KJiMgD+jDicD6T3ba1anJYXUYuX4H2aZ9+dGxJR9lYDXrntx
	2IMUdcANrDxuFsRtYco2hI9qge5ne5k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o/a1t3og";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776314432; a=rsa-sha256;
	cv=none;
	b=esDcBAUcZzo5W3fqqnbeToX/gK4pePEnmR5/8aJv2iKq7C87BaZmmpiIH1W3cAY2h3tsew
	0/vpqAGfQjvcQLwugisGbkq1Sk+AoTKTHX/F2ZCxhpV2+g0YpR6Vj7Y8RWtPxtElj/Ma5Q
	thrlArjXkBe3oJLEvcvM9sKt2ocYJ6M=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FHbvaK1734499;
	Thu, 16 Apr 2026 04:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ocBwvM
	8LLinmE6lLgYosYUJ9poUW6iu7VmYJ9PnLyF0=; b=o/a1t3ogRSmaXXnuGOuQPo
	X9pXVZeastYgPhSiv0KCxEO8zt8IE1F0KB7yX41nOR+EZIp0aRzz0t/LTpTV/Pfi
	1lJrVaMo6h5Pn4CDPRSFwSPUgL0pd1wa2y97iRehXVQLsi4DUDmT6QDLbjZpVZjU
	AWMllPtH/M+aRwquR9gQNf9ieCNisogPuVE5W4cNssYehpFH9P0IiULh71iN9xb9
	m+3PFnolGGAURCg9RioImgwElmMU7Eon5kyhE2SCYzm7Fgx8iI2JSIc/bkTGrHfa
	brWdYxDVQutcwwjgoTBke+7lFU0sVkgCmDoTN5JphPlIex24lzPiu+YdaV2pIaqg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mavx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:40:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G3co9i026284;
	Thu, 16 Apr 2026 04:40:19 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujs5ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:40:19 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G4eJPU29688492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 04:40:19 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14CB658043;
	Thu, 16 Apr 2026 04:40:19 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A357258059;
	Thu, 16 Apr 2026 04:40:14 +0000 (GMT)
Received: from [9.39.27.85] (unknown [9.39.27.85])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 04:40:14 +0000 (GMT)
Message-ID: <87167cf2-5851-46a5-99bf-deb5894ff214@linux.ibm.com>
Date: Thu, 16 Apr 2026 10:10:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmscan: fix typos in comments
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, hannes@cmpxchg.org
Cc: weixugc@google.com, david@kernel.org, mhocko@kernel.org,
        zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, ljs@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260416024248.687943-1-gxxa03070307@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69e06834 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=IeNN-m2dAAAA:8
 a=3-Y1g2vecON_pCC63V0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: oUjvAYfSWxYFSRLcQxJYPgR0nupqMfnw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzOCBTYWx0ZWRfXyanoReN7nQOI
 3n3IVlsalCVYow7vMp7EDS8S0O09D8ba7i35CWYMD7uTiWMjdj/8I6LRNGaSq2X1BfCTqDgfuaV
 jMNfGC4vIGClfD9nx9G5+45dct0B2+AqJwPWreDtJRqy/vt8TqFTtP/j70KGLsDyXeyNdeXGenS
 xJ1GGgkd8wGgyif7QInsJAp2QU+dRgX8al2MXHV6cbpauuQqMaAEs4eCOQG6h/IEPbLrF///GJF
 Y945gIsC14wj2BeNe58z/vkB3jHorraw1DtyK5WyQh/ip+xYFGEaoXdbEAT4+eyJSlrb025kqAB
 +3qy4T/s4OWMeRRDeQakxotFvW58j4XXGw1cPUKvXonaCAmcwmwOA5oA4LJq3Jysal+To1kwanw
 TctXYUkaYvA2Kmp+d5eBj0UPDju2kaRl6qiVuLOxuav83WQP1GB9fll3JtbUPvb4ggYuaLT51OZ
 ZP6YPmstS60VVWTRf2A==
X-Proofpoint-ORIG-GUID: LMKESwVRZsC_0MN9WIaMqYBkNGFQ_rEw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160038
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC9D6140008
X-Stat-Signature: xxphzi7qmunwz5158gd4ft5b7ofyq1xg
X-Rspam-User: 
X-HE-Tag: 1776314432-436873
X-HE-Meta: U2FsdGVkX19cKzq0ubsFJ1LsqAZvSOebFfXWzjdVPU0CitCxN7vNgrGXDmaIgY2FvlHuPl3LNNA7myJp/yWY8Ulu3/gSGqF8QWQYgUy2V6fJPbhY6USktcZavWzyVl8HNxA2CS8vIRNqFuIe8nz1qemDD0Z2nZiLwojgh/PwlIID1iFOVLp0xtFeWO23M0hQEPKdTwH3fnnQXMeuSrCHFeGkdAv3TeS/Tg4CFMMuykVUcMdGshKW1ErhfIEvV6wseq1ZmF1C3wIy+Taxg+8PqU+esx9IkkXXeCA1kV04d0MQwTxoTI8H/6wcnIW6iw/JTJXp0BUoY2g5MS5MgdbIq8HOEOtBthY/3ExMAkHCTkZUX/IrV6tpmabu3fh5G4TPyd+12Mv3wgVbvqTd0DauHgyeO323ajZim+kaL64Nl3ljVEbj9QY+BGH7nIETjF1lPUzGC84Ain8NkhMIfHbPjdKgbKTIVLoSPkyKiJ1GmLzshJcy7GovXbsMwVc6ydbbkSqx5Qt5Dv/REnT7DHLSeZb9F0fnKPBLF+GK7cZo7HPPzslfFJMdJAGv58k91HZigp2vzAjvSy7uxLg+SvYQFEAf3mLxv/QPt1pDHmEiYhYEgXMv7Gk1245Yjm/6F8bAPhIbhi31MwPZZrhhmRwORkf8P9W/et43ojqoAM5SlVYLAuqYOadpONGgEVuUpC/WjzOpoEPGhn0ZoXzdJnVx/p1GISSXfnIV7ooQ6xqY4WLrPVzrK38sa0Ncnl0CXFhX2Do2uYEXXQBuR7HKB0mMH/cl1u9Xji6P1xJTDKc14JpVG5sNPCGfDb+XKSz80O84+Wv50C5fFovfNcEkFo2fqHTcutU8oOPijJVSLul++PPNjQBz1RxTAqF/7GujnGEAHEkVac0mdH/v0+tYT4XQ0t2PwaVxQzx17DgPjB1NH6hFHhCRgOrtD7mAXlIv7MJtUxsEPJRCVw0zVdFLTka
 OwhXwxEZ
 aQnQRaTbOjo7RUhnZIls1BCmyDzCz3NQZSaW8/+ZOAN5edp/K8f7Y29qYrLYFzq/wqqUlxNkUNOv9k70ox/ERAjQo3EXguxgNjDupohDbFcBVfB6SEmXo1kD3XdgLptiM1zdPICkgKQGSJughlindSdjOOyizJRRA/NK2JdFSa9k0YXqV6ft0NWeVRZ3ayAtjgQWJhG5LXXdyokUenzHX9DRxcHvYx95apOIR1Ytc9mM8CQyT//Hk3PKxN7+pnLXcUFvI5lROH3YZlPLV0F29vvPL4wBKbd3KrsCFRGuOKhmoH1u3fLvBQlaz2DufM7yjBZacKuELBCy5UM7k8Uhc4DXH4mHVs8/eUlj1TNSbus1WEuU0S7Icd4OfIjODXHkgh37G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/16/26 8:12 AM, Xiang Gao wrote:
> From: Xiang Gao <gaoxiang17@xiaomi.com>
>
> Fix three typos in comments:
>
> - Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
> - Line 6208: "prioities" -> "priorities"
> - Line 7067: "that that high" -> "that the high" (duplicated word)
>
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>


I am seeing below issue with checkpatch.pl

./scripts/checkpatch.pl --strict 0001-mm-vmscan-fix-typos-in-comments.patch
WARNING: From:/Signed-off-by: email name mismatch: 'From: Xiang Gao 
<gaoxiang17@xiaomi.com>' != 'Signed-off-by: gaoxiang17 
<gaoxiang17@xiaomi.com>'

total: 0 errors, 1 warnings, 0 checks, 24 lines checked

> ---
>   mm/vmscan.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..710fbe1ee151 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -109,7 +109,7 @@ struct scan_control {
>   	/* zone_reclaim_mode */
>   	unsigned int may_unmap:1;
>   
> -	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
> +	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
>   	unsigned int may_swap:1;
>   
>   	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
> @@ -6205,7 +6205,7 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
>   	if (current_is_kswapd() || cgroup_reclaim(sc))
>   		return;
>   
> -	/* Throttle if making no progress at high prioities. */
> +	/* Throttle if making no progress at high priorities. */
>   	if (sc->priority == 1 && !sc->nr_reclaimed)
>   		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
>   }
> @@ -7064,7 +7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>   
>   		/*
>   		 * There should be no need to raise the scanning priority if
> -		 * enough pages are already being scanned that that high
> +		 * enough pages are already being scanned that the high
>   		 * watermark would be met at 100% efficiency.
>   		 */
>   		if (kswapd_shrink_node(pgdat, &sc))

