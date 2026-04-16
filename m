Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B99BF433E5
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A386B0005; Thu, 16 Apr 2026 01:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA406B008A; Thu, 16 Apr 2026 01:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9866B008C; Thu, 16 Apr 2026 01:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEF46B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:47:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B42F016075A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:47:52 +0000 (UTC)
X-FDA: 84663337584.24.BD94449
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63C9720005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:47:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RZKTjDnd;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1SS5euW3lkSwLlwrMkC+nhPAcpNhCl3mSRe5dlCDbk=;
	b=iMjddj/r0l0p/b5rvEkT+PjQW+Wlxv+BczVL11xAvhaCP4gT65D1OKVPYZstb3o+lAQBqL
	ixyiEHy+JURReuMdwCKfwDR6JdRQXgwL73nYShOwoLgZZAfh92eu6fcQJrz7O/IFIdsqcC
	E3y5ynsuoIeyWP2CMLRQyrw+mr001SA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RZKTjDnd;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318470; a=rsa-sha256;
	cv=none;
	b=sU4wCH48bScA1F0bPudhCGDq41Ww7OlYuLISHtq8ybPdtIBoxGArUBQ6oBRJ11qvNYCDN9
	q5jvH6dV48/zL9b7dbsoltF2ANdfwOkaarcfO8wCjPBkaR95LIiRTW+CNPAkrToxCjRKv/
	LSn5MD3n2nOw/w2zKXO7T6/4h0qB2Gk=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G2h2rI1804464;
	Thu, 16 Apr 2026 05:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=h1SS5euW3lkSwLlwrMkC+nhPAcpNhC
	l3mSRe5dlCDbk=; b=RZKTjDndInBg48LqhM+HoR6AbGqLCMCVhuu9eHua17NosF
	YRP33R6xZ/zrjLR5yonl1RG1aRuKxk0mqaKivtRylg3bRLjdxHH6kbV/+KKTO09l
	1uZemMQWHNdhrul87h5VAOqScXo0QWSAcqD8KnqfzJGZaf8yDgfkC340rDZb+M2V
	JsdLmQhxaa/r6vHNeYhtxjzLPFEDmtg6B2M8P1HMCkZoq+Fkum2K0OtlpX49BV8D
	xWeJ5yjCc4rLHl2LbRyfjWzhwhUgHOl6eqmg23N77JrJXnJ5xe1HteOfvZqOnXmz
	RJmM3RIptyPAlJAspOYp/y93lYyuWzz2m3TNJvDw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89kb2tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:47:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G2fCmN003299;
	Thu, 16 Apr 2026 05:47:36 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh934y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:47:36 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G5la0N33686176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 05:47:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E97DF58059;
	Thu, 16 Apr 2026 05:47:35 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E545F5805D;
	Thu, 16 Apr 2026 05:47:30 +0000 (GMT)
Received: from [9.39.27.85] (unknown [9.39.27.85])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 05:47:30 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------KHdESec1QHaDGOsHe7Bst5Uk"
Message-ID: <3d445fdf-6bbf-4d67-8a4f-eac7b5138ada@linux.ibm.com>
Date: Thu, 16 Apr 2026 11:17:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmscan: fix typos in comments
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
        axelrasmussen@google.com, yuanchu@google.com, hannes@cmpxchg.org
Cc: weixugc@google.com, david@kernel.org, mhocko@kernel.org,
        zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, ljs@kernel.org,
        baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416024248.687943-1-gxxa03070307@gmail.com>
 <20260416051533.708909-1-gxxa03070307@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260416051533.708909-1-gxxa03070307@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Yx_mAzinu5h1lyRJlx1669f9Ttrb4Ibn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA1MiBTYWx0ZWRfXyZbIZJGruXWI
 V19EpmFETaeI9TpiLrL4Wta4MiObpqd5YfUONbDddcC9TvKW5ggRAf0d3eQA7Bn/z2wwil/p0m7
 zRf/QlQDKAAeAeyDubcUCIgFW9xXArgHrEi7XkRnoSwpy6Gl77d0Jedpxh0PWpszNpUX4ei5B7E
 6pwYU6RI6FIt5QALA7/AzuLW7/NR8XwWgQBl8utt0qbXTGFHyFDbqL17s3boTMq4yGN8HgA8dKy
 yzWpPzgzQ4/dl09fYanaMYMgvWB2hWComE7mon+7KEylx2ztT1EUWnU9SlP+vr5AfQK3lV8SeC1
 wqEPUh2QiL+mpATGns+G9J10BgBP1CwT49jZmN4UbSVr8fQJJtp8Kcl/CDmaRxJ8YF7mH6IDTam
 YUhAYjYbXLBVqUmbz6lWF/MRXU7/oEzTR0VrondW4O3B7XYFcKTgQLH9md5+DhEtsDgdiMEPI5S
 czpI4+5ae4VnSbUIy8Q==
X-Proofpoint-ORIG-GUID: 5c6cjGC96qqYs-mRryEQX1hYQbEzFNtG
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69e077fa cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=r77TgQKjGQsHNAKrUKIA:9 a=IeNN-m2dAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=_wI8R4fzyhrNWMmDEasA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=pGLkceISAAAA:8 a=MB1NNGHsvMvcsiHnFPoA:9
 a=HDzV8RA41Qv4Fy6G:21 a=_W_S_7VecoQA:10 a=lqcHg5cX4UMA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160052
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63C9720005
X-Stat-Signature: tenj8xd8o4fouufunb8qcdjz69q48mtb
X-Rspam-User: 
X-HE-Tag: 1776318470-518273
X-HE-Meta: U2FsdGVkX1/H6zb0pe+7Fkx0e242+UhEQRAWm6ye0r39dja2gj6nUzWRCS1UYnbyK/lUwg8gL0mduYYFE1EG9atXe+l6s9HmA0Dy9gbFjnuTEtrBUWkmLHe69Yp3sWL/+OxoQholETBW00w/0C1P91lhwLj/gXWB47qjFpjQhAQr2YWBnuCfRE5Wf+W5uq8HsnwBqLpGAAIRlSSzkH/+47Bp9NlPlO+1yy+hUOzMhw6n8dAGoG1/JEDCOSGAnOXIr+DJuO+pHYEOUxPulZxqwghqqycgp8kBNHgcg4Oh8TNrpJMBz8thRlEPLUmEmfHmh1I18yuJdP5fFFVUdkNdDJ9/5z+zV7am1RyZOeqhnUJ0ZRklz5z3T2QDUabWQDanlW5VRyzGTqS9HXY18fJY8T7/pjvazQNxGnIYvs+epwKCxJ71dK/7okZwpnxrQHVfMhOJjFSCdc0UPkLTXlw9FSkv/QwsN2xIvmm2PTDl6qhrOJkwu3vuyY0ku9FY9bnGQgrOWj69h/XFKKzygC51cDMclQVIABQkhDhoe9DZKG2EqvQR5gyvVAbQmKVoHN1uzjtYtAWXgP41/u2CQuGdeZhvz/PgM6afvYVm+tdJ3G5Ee+TjJWnHT5OjlGOAgoUwEspnXhMQdWGzKI6nJrd6USOvaWalzpnofR6A990ADxGyVs6X1juRWjagFD5q6kgdhd4Pt4E+53HtZH0Lh4IueWEw1Ey4dS5Q2psqd/n6bYnCM/PhN1KgPCja42KT1i6wrBMPyy0mb2dvi2nhgqjUQqnxBtbWeroTIOGwE2e98wAFffPElT38mN0F8VuHX8fC9YPwgEVTY+P53gMS9uK2Aw/Q0yuTuRJVEQMouuWX51nMoGgsK7Aikn0wHeK0NuGR1DsklUrpCwBIE8SakykwjHjWkmE5da79/7Z+Y7OGjWUIas4JFss6M/LfO9w6TbuoMdwJ4mVR23DVMWXj0Qx
 d3fSbjvC
 RJUV6iwgtneUCsBKIzQ8rfi+u2yw50tdocOsEouJCWHnjkGJNL0Afj4EuEgL++pJnIB1YvOlfYaOPnw/Cp0w9Yx5i2bAt8+PVTzwHn8eD6NzgmqEMzjkXQe1nd44ZV+3/fSlC17jSeMzIh6rdOvwpAEmFqAwPD0uPmXKBWcCSmCbxlMt91mvfGaZ+cX4h+W47L+FQeJKgFtByDoYC7HDyjlkwbyfv3YlgA6JrPZYXMDiZInhWikMwSq1013V7N68Y9Z6bnHwWqibEv5Xy68qHCj9me5loSpsBGE7LbEnTczZaZWnrvzC8XmC9OHYo9EfNyESprtOaD5cAIQvTI3E1DIy5OwDXydeHXtqCpaAlmaCkvFJO/kaC+eOCYQnRVmPWqgcMWJm73eR0oRhCFO3i2MOh8g6kPG4PMkNoeAn6rusEkBTck7YoRQFZl7xq87fp4C9l7sl6i6pwzgJyLF4u/rEoyZpghxcVtZmiQ7ywEgFp8T6eZ94osf+rUaVqsH4mZ3IbDfOdwS/WtxT5a6S5Y0CBDZwMT5C5g5gAai2BQW2umMPumLrqZjSXtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------KHdESec1QHaDGOsHe7Bst5Uk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

On 4/16/26 10:45 AM, Xiang Gao wrote:
> From: Xiang Gao<gaoxiang17@xiaomi.com>
>
> Fix three typos in comments:
>
> - Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
> - Line 6208: "prioities" -> "priorities"
> - Line 7067: "that that high" -> "that the high" (duplicated word)
>
> Signed-off-by: Xiang Gao<gaoxiang17@xiaomi.com>
> Reviewed-by: Barry Song<baohua@kernel.org>
>
>

It might be better to send v2 as a new series next time —just a suggestion.

LGTM Reviewed by: Donet Tom <donettom@linux.ibm.com> -Donet


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
--------------KHdESec1QHaDGOsHe7Bst5Uk
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><font face="monospace">Hi</font></p>
    <div class="moz-cite-prefix">On 4/16/26 10:45 AM, Xiang Gao wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260416051533.708909-1-gxxa03070307@gmail.com">
      <pre wrap="" class="moz-quote-pre">From: Xiang Gao <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -&gt; "zone_reclaim_mode"
- Line 6208: "prioities" -&gt; "priorities"
- Line 7067: "that that high" -&gt; "that the high" (duplicated word)

Signed-off-by: Xiang Gao <a class="moz-txt-link-rfc2396E" href="mailto:gaoxiang17@xiaomi.com">&lt;gaoxiang17@xiaomi.com&gt;</a>
Reviewed-by: Barry Song <a class="moz-txt-link-rfc2396E" href="mailto:baohua@kernel.org">&lt;baohua@kernel.org&gt;</a>
</pre>
      <p><br>
      </p>
      <pre wrap="" class="moz-quote-pre"></pre>
    </blockquote>
    <p><font face="monospace"><br>
        It might be better to send v2 as a new series next time —just a
        suggestion.<br>
        <br>
      </font></p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">LGTM

Reviewed by: Donet Tom <a class="moz-txt-link-rfc2396E"
    href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a>

-Donet</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260416051533.708909-1-gxxa03070307@gmail.com">
      <pre wrap="" class="moz-quote-pre">
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
  </body>
</html>

--------------KHdESec1QHaDGOsHe7Bst5Uk--


