Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F7CF433E9
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646A66B008A; Thu, 16 Apr 2026 01:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E326B008C; Thu, 16 Apr 2026 01:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533CD6B0092; Thu, 16 Apr 2026 01:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43E336B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:48:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7A62C26A7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:48:32 +0000 (UTC)
X-FDA: 84663339264.12.55FA7DA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CE564000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:48:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nF0tRz8V;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNmKGvf/cG2P4irGqKpHPxDNy/cUO64RiHXW3PpT3uo=;
	b=Nfin+yNARRpTJB5zJ6aqPWMF6PMPHfWuNjIDV9KPMjKjBZ9qB9Ksntt27J/yvLDVd4cfiU
	Ame36Kv3jwJdSPgyPPEqKq/uNKk/xSPN7zZrV6paAcjk7uRpv47tF/mXfFJrVkfkPmDRFf
	OhFmjvMLv82U+VNLdNvUHojEX/Fx9CQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318510; a=rsa-sha256;
	cv=none;
	b=TpxUT6tZV4MdBoIF8WHBPdNFi5iOSSgWMjmVcsb3iM1U6vi+vJjy0be53ys/nsFr8CCllQ
	7LXRhAHE+oSfQ93ZJtl4xFPDAontA5iz8wm4VIY5xe198+WnGI1aKPf++BqF8c48ttt4HD
	aTDuggXK4EbRdZ6RZe6dGgnivBn9xro=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nF0tRz8V;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FGf3PU1859965;
	Thu, 16 Apr 2026 05:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rNmKGvf/cG2P4irGqKpHPxDNy/cUO6
	4RiHXW3PpT3uo=; b=nF0tRz8V4piC8/APaT6mc3dxsnXyqmARSEjvPwpnsDmTDD
	lwVSU7MZmAgmpxOZjd0U23VzotEOLrQz89Vgfmd8Ji2tRidfw+NObo+VxgckdEJc
	TaXuKDsQ8/H54N50aoyjMIa0YEJ0xFiRV4wb461i4zLryQHdQY/NdQzOfEzQRpvt
	ItKFqYRdkI3cS+RXMxhOhlq3PVB2m/LF1On4HY3DvRyiY6cfNG67VDLBScDyZgLW
	8SL3CRFGD+tkai2VDRQv6FZZO2s4Ax0yetMgOD7oM3G3EF+Kgnqh5UVDFqY8t+h5
	hTQb6SqrJEtTJMmUKihpiEh/Ox6DcIGzCtJmmjkg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89pk2ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:48:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G2iYeK003379;
	Thu, 16 Apr 2026 05:48:28 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh9351n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:48:28 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G5mRor328324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 05:48:27 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62D2B58059;
	Thu, 16 Apr 2026 05:48:27 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 212F758043;
	Thu, 16 Apr 2026 05:48:25 +0000 (GMT)
Received: from [9.39.27.85] (unknown [9.39.27.85])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 05:48:24 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------TqYLRhhbYakLHkXDqAYCtMKN"
Message-ID: <900daae4-654f-4e90-898e-e13020e7753e@linux.ibm.com>
Date: Thu, 16 Apr 2026 11:18:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix spaces used for indentation instead
 of tabs
To: Xiang Gao <gxxa03070307@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, donet.tom@gmail.com,
        Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
 <20260416052752.713821-1-gxxa03070307@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260416052752.713821-1-gxxa03070307@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: urfcnrQG_j6kSTMOy90Rul44vWdBlnpa
X-Proofpoint-ORIG-GUID: SMjTpN0WXtQCOQBTTv41PjQDXHbJ8r9B
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69e0782d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=r77TgQKjGQsHNAKrUKIA:9 a=IeNN-m2dAAAA:8
 a=VnNF1IyMAAAA:8 a=1azo6HzM0BMiu3SuvnMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=pGLkceISAAAA:8 a=DKeexwF8E6IeKyfSCL0A:9 a=uUuOom5mEzdUIZR-:21
 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA1MiBTYWx0ZWRfX/Gat6PAEESbt
 SmaipP80EI8dk79jMfNHcQ1jOud9khXobac1FiJnICm5HWNZSAoQzMyu8CqqUvFSRoGUzvNERi0
 9wqmmCjZYCduaCqxo/7KpjM/gQJN9Qel+j11F3FDBMEoJAAEyYoa07sXKieFy5XUQE+QXQ9ZGuU
 N4xm7XVlvz8VQjZBkWdBXS8alruEhJpdcHj6ZxRbYSlQxbM/CVET5sum5JexUdySWodrXrhs/+Z
 ardhyMLVOiTuvsgpoBr/eg+7hqjjvh6NazsqClJwlplkVCj84qUBNUOW/037CPpTSkx1OfjnfOT
 ImiCiFN6UCSMZbD3YXhlv39YfriDVgHdChXAB/xjJn0FcTbUt31sNZGenrqOKWH7mcKcEJ6mlH9
 uKw7oYPjg2WhZpgvB5LLqHUUPeP/YvuI0XUMqvcJtAl0XBJnpLL9wipsKyLd2gdJEx6vbu/W9la
 ggr7tBA1nDPRK1Q2FmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160052
X-Rspamd-Queue-Id: 9CE564000D
X-Rspamd-Server: rspam07
X-Stat-Signature: xkzhzkkjn68oquacqnrn1kmjegegg169
X-Rspam-User: 
X-HE-Tag: 1776318510-712559
X-HE-Meta: U2FsdGVkX18ihInvcs+ySJ4E2U350M5wYDl6QIW+fy2apZc2oLiMKt7LLlvogixxZrBA6I57lJs2ihzECQZYhRsFUS6uEkMLjkk5FduBmWoQaM544XVz3hONIym2vCNnawiQjVmlHWUMmBvOpyrMWlT3q9HCPS1Efi+XbVK7WUOqGMRNMM+/Gza311YxhelVAAYN7kEBIt4vays+edA3M8+U/XzuySr+egfoWQ48IiQnI0pB3J2Yf8UN/i6trMwYiaF3GoAGPJABCbofCyRu4lP9xAuQW3UoO5vqQkuwwj7vLSirCDPKE36QsFprgOzWYAjvQGfjX5pApGwUFxdWzb2tcvPgPo0NKMd/g0CW0oVxdHz1ChUy6gE1KBeKCYh0NVySkMqaLSKe1jw/2PK5bJnvSv+WKdTYPvgqOMXNrvb+eMG4qsxVpT3ys9VqDIvO53BIysUwZfVLMZ5omcwL7z2ioddINCHnwJHhSOSa7HgVB5Zy88+EnyREjDgugiVWTaVvU53fe6St91ayN2KFgTXZuhwdnfbBmHCZt7VE0I7cxw1MQRYlvO9eLeY1U5U/d8WyiAcQnZGqW7NWWSJ26aXOzkMAZx6HaXoxQCvTDswUVJCbKXbiTkZUP2Pf5oZpsBe4UCvPDHpVbqWr9T1eEuKIWjZN5yTQlM9Idj2nGQy8akSdHQWliezPwO0hqZ3kHqMShxnzfwfCObyienvXbJ5YoMEzsogjQogROStiV0AuwBlefY0C6nsGp4l5v6IpDnNzSWj7P0MXeCyF1NLcvtS4LeyOKhOASxYyQG2etiSg135Q29mprQXn52Yf74Bp8jE+BrkXJUzNznvYUA7VglI4kOyUI6NhgwYbhU9t/Fxov7l8cxFowSy7JNey2s6JQRosn5OvSU1cP2R5D79cLCQcqgwAKdEylWGlLHEvO89jXWXq1CyALeUvNI4gunp6BJyvUzXsszdCMmlaFfN
 ajuyp2Eg
 0xGToceaQCxhOL+oDElvUUhjpI5fbUDM9Ka2U9qYl9CvGhsyekq3JlRpXqfynyTy4+/3jDYAjhAvZmCbEO7IH12R7ZdlAmKIcgmzwIHviQtdJraIFhb98Hn8exl4Q2LRRv2hPc3aGJ2z4uX1EzD1ERGQp3SimidsHSfpKxilMi2f2kiY4UmayJdD+29PzPQrJ2VabxOn0aEzjQ+31yd4lL4RNdieUs5dUbA2/VaAQl0tq7C5N+gdkPj22R1GE5osU3PZ0fV2LcmB5PR6e1Lb13TsbVckFatJvD/5py4wqthLgRZJACl3LQgYKKF49/kw0aayBE4vi0OmLUbg7oCMKQPCSMx6dHFmMndwrrpMulgGMBbDNDrEJM0Fq/0vnhhq+bF5ZlS/KMgAmgGV4HUBF1hX87LudCmzZmwuqM3YQ3MdY5bb+r6O3KP+nwRPFIO+dVFzwwMMHd4Sr32lBNufVJOqi/wXRYSpd1Wn0b4qso1yh3QeaW4F708fhAiKK6Em9EwNBlmicryZz5A92Ee13XaVQb9gWo1JSaD7wwtx3SbXyqE1HHtO+ciwnBiImrClCEKuweaNA00lWyCBjQpUCVQBIHd+nS2RSKcVtueuSy+jSSeX+8J7YC9WX2teHVl3cyvUr6u0tnkv+JH2Vj15UmXX3pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------TqYLRhhbYakLHkXDqAYCtMKN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

On 4/16/26 10:57 AM, Xiang Gao wrote:
> From: Xiang Gao<gaoxiang17@xiaomi.com>
>
> checkpatch.pl reports two indentation errors in page_alloc.c where
> spaces are used instead of tabs:
>
>    ERROR: code indent should use tabs where possible
>    #887: FILE: mm/page_alloc.c:887:
>    +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$
>
>    ERROR: code indent should use tabs where possible
>    #6626: FILE: mm/page_alloc.c:6626:
>    +						         sysctl_min_unmapped_ratio) / 100;$
>
> In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
> spaces for indentation instead of a tab. The identical VM_WARN_ONCE
> calls in __add_to_free_list() and move_to_free_list() both correctly
> use a tab.
>
> In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
> tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
> + 1 space to correctly align with the opening parenthesis on the
> previous line.
>
> Signed-off-by: Xiang Gao<gaoxiang17@xiaomi.com>


It might be better to send v2 as a new series next time —just a suggestion.

LGTM Reviewed by: Donet Tom <donettom@linux.ibm.com> -Donet

> ---
>   mm/page_alloc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..752673a9b43c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>   {
>   	int nr_pages = 1 << order;
>   
> -        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
> +	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
>   		     "page type is %d, passed migratetype is %d (nr=%d)\n",
>   		     get_pageblock_migratetype(page), migratetype, nr_pages);
>   
> @@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
>   
>   	for_each_zone(zone)
>   		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
> -						         sysctl_min_unmapped_ratio) / 100;
> +						 sysctl_min_unmapped_ratio) / 100;
>   }
>   
>   
--------------TqYLRhhbYakLHkXDqAYCtMKN
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi </font></p>
    <div class="moz-cite-prefix">On 4/16/26 10:57 AM, Xiang Gao wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260416052752.713821-1-gxxa03070307@gmail.com">
      <pre wrap="" class="moz-quote-pre">From: Xiang Gao <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>

checkpatch.pl reports two indentation errors in page_alloc.c where
spaces are used instead of tabs:

  ERROR: code indent should use tabs where possible
  #887: FILE: mm/page_alloc.c:887:
  +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$

  ERROR: code indent should use tabs where possible
  #6626: FILE: mm/page_alloc.c:6626:
  +						         sysctl_min_unmapped_ratio) / 100;$

In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
spaces for indentation instead of a tab. The identical VM_WARN_ONCE
calls in __add_to_free_list() and move_to_free_list() both correctly
use a tab.

In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
+ 1 space to correctly align with the opening parenthesis on the
previous line.

Signed-off-by: Xiang Gao <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a></pre>
    </blockquote>
    <p><font face="monospace"><br>
      </font></p>
    <p><font face="monospace">It might be better to send v2 as a new
        series next time —just a suggestion.<br>
      </font> <font face="monospace"><br>
      </font> </p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">LGTM

Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E"
    href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>

-Donet</p>
    <blockquote type="cite"
      cite="mid:20260416052752.713821-1-gxxa03070307@gmail.com">
      <pre wrap="" class="moz-quote-pre">
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..752673a9b43c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 &lt;&lt; order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
 
 	for_each_zone(zone)
 		zone-&gt;zone_pgdat-&gt;min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
+						 sysctl_min_unmapped_ratio) / 100;
 }
 
 
</pre>
    </blockquote>
  </body>
</html>

--------------TqYLRhhbYakLHkXDqAYCtMKN--


