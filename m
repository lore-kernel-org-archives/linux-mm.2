Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E86F433DF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 04:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAEF6B0005; Thu, 16 Apr 2026 00:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B026B0089; Thu, 16 Apr 2026 00:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A286B008A; Thu, 16 Apr 2026 00:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 432B36B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:03:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9902113B698
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:03:11 +0000 (UTC)
X-FDA: 84663073782.17.D3861FB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC5B0100010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:03:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k7fHV5T7;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776312189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dwed2aXFQszB3uHI7OrIswBI2f0xgXk3K6+b51li0I=;
	b=2SfNEUl28MU6wINMb2yvhxWlJbgpg4osvjLzMV9vrCs9VGC2c8bxdP9O+P8++nb1XK/HUc
	tjjHh3APbkEBRhPw7kx/reQg2f5FQeGl2Tvo6PDxPk8uJu2dKJ32J03ieDESqbSrc3uXSz
	c0aAggmZd0BnR57o06PLcdoFi69OX1U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k7fHV5T7;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776312189; a=rsa-sha256;
	cv=none;
	b=E7M10zpVRI3JMSU6nvMJLH/s2Y4RlRl0vnNpiiXFlB0CL97SX5C1zWK+IJtJ0j+832XUO4
	fgVegv3Cb/ucyTNedDEWvbIHg/n390cFDSr6+TrqX+yalI00C/koh5LN0eLXybqj9XgnON
	ClFo1+0gBJ+MVRGW7hGYDAH/CEKw+jU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FI2oc91804412;
	Thu, 16 Apr 2026 04:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+dwed2aXFQszB3uHI7OrIswBI2f0xg
	Xk3K6+b51li0I=; b=k7fHV5T7eDt9+auiUxj8jepkO8ambf0clBGfiiYxNW/RkU
	r8/uxKRuhVcZ3kMauAsvxyY/JOVdebnzjxGirhKTlor0gw0G1eeo1hA89hwZSDQs
	Wz1mx/qJAletUQCUOpz0mRh5r7hwPJHTAX+1c5ZSBnkmlnuwv8jvAdtPRoM0iLB1
	LDoU492dQ+EgzvVUsAn2zB7y2eMCDsnKeRGvjTaSQqmHb8wx2EnRg5I5KkrVOMdo
	f7MoFNzOJL8pfCakZPeRnzFqwCiRNF/PfS+dVyesmEkVLqM2JTbP67X6WWx8K1cd
	2Qqz9zUGUpEf0p9CrmOehm0BOdN2h2o9OgMEGhCQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89kat88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:02:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G2iYMc003379;
	Thu, 16 Apr 2026 04:02:55 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh92v45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:02:55 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G42Srt17302072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 04:02:28 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22F4158059;
	Thu, 16 Apr 2026 04:02:54 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 946B258043;
	Thu, 16 Apr 2026 04:02:49 +0000 (GMT)
Received: from [9.39.27.85] (unknown [9.39.27.85])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 04:02:49 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------D4E2qFNEOnF24vwDiuxWxL0F"
Message-ID: <94e0826b-63ee-4d5c-ab26-af2a82e62acf@linux.ibm.com>
Date: Thu, 16 Apr 2026 09:32:46 +0530
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
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: qZHIWKv2bVwbvuRdgXiXhfeqHVCdEzHA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzMyBTYWx0ZWRfXyjAFhll1YAJX
 nVNFnCXVuJvG6o+GUSBUX2HsjkztZIPGzROAugs4Py+A3L6/nOrh0oaGocobzVR5g2kbS6evhDa
 hhTulX4hV8VlySZghngZ6Qt6txkUK4bfxxp3aSjMs+EvbIojKXSDhdmitz53qpNnCi2Dyos2pUX
 9sFw/icHW3wEOt1Gn+16RSV+Rugz5+WXg8RJhtvHKfi5CLrraJ2XNXiRu1lgrWP9dxCNag8MSjM
 zZMbS6/M1W0aqpGVx+qq61ctdZqw1lUtUHDXmU919UaM2A0+PAMvAOe2mIaLWFNWTUABzdkBOH7
 g5ZleKVIVDL/uOKBrccjoToU6EnNur6JLk/zpMmZNJ58U7FQBOEB3fMYhvciVI37L4zOoTsqexf
 IHGD8RrSq5DZPBzb61ph1u5RZPR+cSGUiXHNg8UVJ1J5+sYBSuHiPCWHjmelxxdeIioAfJrtmw9
 8UB+qVNX7PFkOAP6lWQ==
X-Proofpoint-ORIG-GUID: Lt4HNAz52Wd-32-ZT6e74xJO8-xTTWjU
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69e05f70 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=IeNN-m2dAAAA:8
 a=VnNF1IyMAAAA:8 a=_wI8R4fzyhrNWMmDEasA:9 a=QEXdDO2ut3YA:10 a=pGLkceISAAAA:8
 a=MB1NNGHsvMvcsiHnFPoA:9 a=XYchgGUCA_luG99g:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160033
X-Stat-Signature: wtszqph357kyrt99h3ax317nbfaditr4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC5B0100010
X-HE-Tag: 1776312188-885773
X-HE-Meta: U2FsdGVkX19H6phSG50Y7nGRLaGvpPDYMwZUCrnFA0m1Q8Y5i8YUM82Rxh2+H6JRq8qNOmJ5ef8+Fkf2olwMUTQTngeUHieSiOlPSiqzXxwMxaQQNTh6iXNefRmfLiynOwDjdQSCuhL55dhkpKc+Nx2bgkHdyUiKzZjv3se3S+LUdav+dFH4IEzVSUndrtYFD/eeG5hfEZprFhMCfH+Q7x9N274MJgIeB9w4Db2ebevtOC9G3/WSRYGlSfbmrNRNDrtPkmS0LY8ZP67rklI3huQxtgOCkVDe1zrsmzjSKth7Z32ETofjiwDmL8RCLcYFh/Xt92xE8sNRx4o+teNf1cP8nyAhTdWkeqhgtP0ht2KJuJYAw15C/XAsvcrRpzB7KnPqM7P0cIKhzpGeWpZFmdcy4oheGK39UknnaNVQrXhGSKDNKvBl+8/ZNek9tWIpObMVvOjOG+nd89eZrvdhxm17gj8FPK6UF7Lgv9RMseRbACi3X0b9cCdPsHyu98dX86FsRmx2AFqNHiMChMjUdWc5TCCp4pCJ0G81Y8mEcb+4NSLqH3G8ttuxbRy1SfgwXN+regS86apzI11s3sfJkYmUCQvSbplW0iwycTiZc3+MsK/xiRHdwDhfvCn2SPw3J1lWquEd9yN/boBu9Ezl5sVNfjX02j72IxE73dWTqbMHWwrSThvUQeIBvFcM+Iv51SNgWdomogED/FKAY6B3x/WJ8gqIOAcuZ4loZ9lp/koHnNu0QEo840b4oKUdP8NZQjBdAAnaHnkt9F3nxB6YZ0UEEV3U6/OFkHxV8ms01y/8gj/jBSwQpLO9POGwU5HTd49/seYG+MkO+MsDXQoSns1JyOPQvzQu5Ayh9iXYpJgBqF0vWQ2zWhLwSpZE5CuiWAX6wWcBKgvEGKXTHcQ+83HPnTKpImXh7Scnt2mOn2XRdFfMbF/GB6mGnWMjWmFu0J55/h8uqWishTPeF13
 NkS0ocdr
 LWKkTjnWv7ciAovlFtU965I8ZD1xHgT+sEJqskYvDR6CFS055sZ0U12ERKqdifUsFatilJ81lXUkvN6GACUbjrbhKzR8JR0bmj55a/NLAOV9skqU5ws0G+cgzgVYhrOn9bPLh5ovJGv65fDUAydxKOiVA2hfg2kzMa39JNntaKir5Zhh03u9//L4x2umuUKmVw+WIPS7ssNJCKvD7iZV8oJwehVMVLQ0Aan8rIDrGmfkbJ3gEepGkOCW7h8W8pdE+Vz8lOdoG670jRTaxG7wRUfyJAc0BgFEAWMOKFrbDLV0Ef7ySUBkxj1a5QsF/WAvxjRySx/0TZ4SBOQBGBbZIzTsF6RbkcHh9lMpCdCG9rPb9Tvh7pM1OclUCvECnI2Ya1hO5Zq2g9GNnW9hXWxJtnYqJBWWiRlZ+9TwFUdWvepm/z/azxJ0jI4c+4Gmym1nU6rkOyQeuSN1j89wTm1fPMYsGTi/MP9a4cbfTB9KD2A/RFIkmKsSkLIYZEqSTesxo0gNryS9qB8j9gMgltluWNzBlVzEXD6FdW0feezDB9XFPLhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------D4E2qFNEOnF24vwDiuxWxL0F
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

On 4/16/26 8:12 AM, Xiang Gao wrote:
> From: Xiang Gao<gaoxiang17@xiaomi.com>
>
> Fix three typos in comments:
>
> - Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
> - Line 6208: "prioities" -> "priorities"
> - Line 7067: "that that high" -> "that the high" (duplicated word)
>
> Signed-off-by: gaoxiang17<gaoxiang17@xiaomi.com>
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


LGTM

Reviewed by: Donet Tom<donettom@linux.ibm.com>

-Donet


--------------D4E2qFNEOnF24vwDiuxWxL0F
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi</font></p>
    <div class="moz-cite-prefix">On 4/16/26 8:12 AM, Xiang Gao wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260416024248.687943-1-gxxa03070307@gmail.com">
      <pre wrap="" class="moz-quote-pre">From: Xiang Gao <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -&gt; "zone_reclaim_mode"
- Line 6208: "prioities" -&gt; "priorities"
- Line 7067: "that that high" -&gt; "that the high" (duplicated word)

Signed-off-by: gaoxiang17 <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..710fbe1ee151 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -109,7 +109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
 
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6205,7 +6205,7 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc-&gt;priority == 1 &amp;&amp; !sc-&gt;nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7064,7 +7064,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &amp;sc))
</pre>
    </blockquote>
    <p><br>
    </p>
    <pre id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">LGTM

Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>

-Donet</pre>
    <p><br>
    </p>
  </body>
</html>

--------------D4E2qFNEOnF24vwDiuxWxL0F--


