Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45A7CC6B33
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 09:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1000E6B008A; Thu,  2 Apr 2026 05:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0F06B008C; Thu,  2 Apr 2026 05:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1846B0092; Thu,  2 Apr 2026 05:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAA7A6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:04:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74138BA13E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:04:16 +0000 (UTC)
X-FDA: 84613029312.18.7D0D675
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A4EEC0010
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:04:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MLRrh/he";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775120654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljCLK1n3LaFmfszoZ16bgND1HFfZ1L3Yb7sqg/Z63d4=;
	b=s0ARLEt95FjBUfluvUmmfiaozylybg01YEzw/QC2nkNo5eojrbIjMvZrb4pkwTZYYe6G3H
	f4i6dSXpkY5RJfdE856wu5GTkUEsiiDcn4iorS4UAtgNFGarpj7Zy2CrXJnMlME+l37i4Y
	3ZxK+nYDCQ7wAWbqYVBJwAq9j4l+THc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775120654; a=rsa-sha256;
	cv=none;
	b=6HkvQNvu9i0xsqnChlO54fO30zCpPqv8wcLglStLnzyAPhaWNlyjufhs7+hBc1THcQnZ1Z
	spnnRgo3YnmAvTmPxm80ccwRhl8mDalUWlzaCA3H+PjLMhQ5d6nqFPCgiXAvSyG65QlZwL
	y1FN8UinKvIKgrS89w7tu0aviV3PD74=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MLRrh/he";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631Gu6YP2411380;
	Thu, 2 Apr 2026 09:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ljCLK1n3LaFmfszoZ16bgND1HFfZ1L
	3Yb7sqg/Z63d4=; b=MLRrh/heog20pFLyd9IEpnPBgWpCDdNZbMmXF5ycXIA47+
	IMf4hBbE59qK3VWW3623ugaHqrrxjjoJicXCwMJ0Y0rjsdZe2kAxEx1HrdaJ78nj
	v4jOWfne8qLi44uI1lMdeZdbUX0I27RBBXLTaPPBB5I22deI2Lu0lgZZgiJrg7Ic
	CLlNhDkRlAAeCIhD8XrsUWwg3IZY+uwC0pLC4h5bXwcwdDJMl7vXxyII4JMqCx0j
	14ktX5a3GD89jdn8MOUHv1BgSkljqljoC6O7iwGtm9fzh6K2vETbgWrUYsKQ0Rbc
	1d/7EDbZxaqZVh4yYQUQK7nkuun9qAp5hzM+nfkQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d64dgubqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 09:04:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63271ZwB031034;
	Thu, 2 Apr 2026 09:04:11 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhk173w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 09:04:11 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63294AAj26346164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 09:04:10 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F337258052;
	Thu,  2 Apr 2026 09:04:09 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52F9D5805A;
	Thu,  2 Apr 2026 09:04:08 +0000 (GMT)
Received: from [9.124.211.155] (unknown [9.124.211.155])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Apr 2026 09:04:08 +0000 (GMT)
Content-Type: multipart/alternative;
 boundary="------------84Vf1evSfAI0RhKT98wnVP5b"
Message-ID: <3c402987-a222-450f-bff2-d76a51e7067e@linux.ibm.com>
Date: Thu, 2 Apr 2026 14:34:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mempolicy: fix memory leaks in
 weighted_interleave_auto_store()
To: Jackie Liu <liu.yun@linux.dev>, joshua.hahnjy@gmail.com
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org
References: <20260401005702.7096-1-liu.yun@linux.dev>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260401005702.7096-1-liu.yun@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDA3MyBTYWx0ZWRfXx0oCwogWHvcW
 idPAzrmR+1JfgDKKw6cBwjiZJ8JerbUwzOFt0NVtb+hpRts/h2x3jMPoY88LelRyRvR83MXRakk
 BwDF7SxeO1ohEtpy7v59t/kZ/ZvZ2EkNRHOMYrycwlYoDp8EE/dMpiAvP0ujduRtUuwCqcxKLY0
 pvq1xsgDpuncPYggClAYPzYskM5IXV2uDvHRBNuxS7ORYW868CLvOHJzhbbPQ/DvFNW5UzPEkPL
 CFEIUW7LlXha4xXiXNV1pWZHtiP3datkzJkyP5xp3rP5pktgMB8q5Ps6mBXuFj0dWOkr9b9RDy9
 ECqDhfrs4miIdm0HLXYhpqkkuWsSeklS7dv2m4E7+LkvJlhSdDUSPfK3xq8WStzX4+8Kw1NcgEG
 b7b3Q8/cjxir7yqWlQpvkF10l0Pj4HZmh8JeylSeh7A8xituA9clqK/GY0wsjvr/IXxoYsoKH1R
 fJBCvXSJE7J7wZ68LIQ==
X-Authority-Analysis: v=2.4 cv=QKZlhwLL c=1 sm=1 tr=0 ts=69ce310c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=r77TgQKjGQsHNAKrUKIA:9 a=c92rfblmAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=GQcx1SM-jIvEHJ7Fg4QA:9 a=QEXdDO2ut3YA:10
 a=U-TS657aZtpQBjwn5IQA:9 a=pSCpfNTBJinxRP1e:21 a=_W_S_7VecoQA:10
 a=lqcHg5cX4UMA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: _PqZXvNoDnETpYKAIRDp3IAcIl8EtU1d
X-Proofpoint-ORIG-GUID: xr3FLwWgkM4Y1gNYRtHD9bmQGP729GJ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020073
X-Rspamd-Queue-Id: 1A4EEC0010
X-Stat-Signature: obanp63bkzyh8ek4tqtput1r1a5m3h7r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775120653-454191
X-HE-Meta: U2FsdGVkX1+X+m0nZqmXpQbeKCrJ/ir+PNnf/aid2w/jbZWTZysg+W8QDTlRH3R6uVd55W+H83o0AbdRaOgUahnMrrOAbuqWwHE1F8bINZEVpNrP4v3j6dnzi9SbVZJCfu75ZBn+rbi8cn5RWPDy5QQ2RIEbnXWTC9XfBqxdCCjI+SZj6ekikLNqGAsCdRCxml12cDggm0cm9EANIL6gbZ9Mk5YqBx0H4euuBMd0/0MNtAxHx0OohrR2TSz9dufnSjSl/CNUHSI18ug9iv6JXe1topJGwvGYEYUrli+zM1CaRWypam6RN/kuA/0KyCSlJ4OWcFfan8BLIyT4apcinYZYKypzi3St1JUd4YZh5Rp7OWwot1RKsO3Y+EaH/zeDVTZDPymzbTIkM1ODQhwMxyLbfvyXKRlX+WE90xMUA1cEvk9CTcNSBmTzt3Bbzd6dYeqh/ElbJ03UMKI+ULTZhIrfGAOmvRyzO3/8cZSYiqSwy1Gru3OhXnYyMqBFoYeCsSeeVX9/xQZnqCpZGEAlmLaIq+GinFNhNNpvHLmAx5WrciVYKbOgWj316UzQWu7W7MKcTD5jJqIXerOUZabFXEheNCl4hmKullLNMF7t3+NvwQRRggYKaY5TsDNqhEC8eBw5TVjV6DKMfzL3uJD4TmIYsroJCkbq+7W9Z5N6iuIWvlEFuQC1UwDdb9q4SjXvJDlKAb6llTOpdkniVlXcQ41zUYqwsFt15Hgb4TBzTVKWOdcetfkqHYCrYZrDYxlQZXsUDLr0Ak7pnqapOH34G1PPRQuuLOltAF/DKLhbSw4VmAtmEXIjNBurPPFaQvrXuev+HQUhrLgsZSiaEd0D1BUd+Hd6dNpnCf6BC+T/oUck+ogpf/RtnPjxqkgl3LWlPS/gvf5t2co417Dq3PZ6VK6ODwPqvRpQ2e9bEOqt2mNW97CdSSsJizsbkrkEsa+21BEiMB30Nf6f4Ochnma
 tCZd6Sxb
 bQTFNAEzm+FI5IOURpw9r8co4wk98MKhlTkQKhZwLCycuv5WM3cRNl7QrlEfcAK4TcaNgBnYkHk3WXQExp7vyow4I3zQUTOsGs+x4SCbKAD2u+3AjsuS028zfYGTrv/4BWiXYdg8Q9QiMRl53kyeiUBOBlDiu8Zr28Th+4DtyZiksOCNzCSw8/oQVXlmUpOkxT/uIv/+/XiWQct5OMql6QYuBhXakNRb+VdlJW8d8Fa6NO3Vhe9nGP3k7U6oVcY7W85xVcGYNi9z//03ruEcurKif3dl88Q9CQLQT9u7SSMMUBFstgx422S0q4ubqPOBJYzwcUZJIVARaumI2S+uB+NaoV8UxdE/jCI7jxj6ymy+4Kx1XtgkK5vL43w1OsmU/xGgH/GoKJGHQXRVwz6hzL4nW26G++NZpG8s5wSAvmTKTgOVs1B4PvoLdv09n7hHzYXpjP5KXB75smaqH1C00TFohW2FThkXEIuUy7jLUs7D4Nvun82kKwVzk9mK1LWHJ9EaAUNBZAEdikZeztuxAPxM+t1z4jlOXXrvfn3OwIaa6DgM2zm63vs3bCqhyggfbkOX9lnOM58G+Q2r31c9cTCChxeS9ZZpfZW7cBxl0yibqfQ/y60s39sFwdYbjZj4gEtWZgjjvxluwbX3baAvLA0GmzxLVcBPKFCYo4ze0UXEhbO1x9zkCs9eyLP0BVq5GFS7IL/LF4UkbNlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------84Vf1evSfAI0RhKT98wnVP5b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/1/26 6:27 AM, Jackie Liu wrote:
> From: Jackie Liu<liuyun01@kylinos.cn>
>
> weighted_interleave_auto_store() fetches old_wi_state inside the
> if (!input) block only. This causes two memory leaks:
>
> 1. When a user writes "false" and the current mode is already manual,
>     the function returns early without freeing the freshly allocated
>     new_wi_state.
>
> 2. When a user writes "true", old_wi_state stays NULL because the
>     fetch is skipped entirely. The old state is then overwritten by
>     rcu_assign_pointer() but never freed, since the cleanup path is
>     gated on old_wi_state being non-NULL. A user can trigger this
>     repeatedly by writing "1" in a loop.
>
> Fix both leaks by moving the old_wi_state fetch before the input
> check, making it unconditional. This also allows a unified early
> return for both "true" and "false" when the requested mode matches the current mode. Cc: 
> stable@vger.kernel.org # v6.16+ Link: 
> https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev 
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu<liuyun01@kylinos.cn>
> ---
> Changes in v2:
> - Move old_wi_state fetch unconditionally before the input check,
>    instead of just adding kfree() to the early return path
> - Also fix an additional memory leak when writing "true" where the
>    previous wi_state was never freed (Sashiko)
>
>   mm/mempolicy.c | 23 ++++++++++++-----------
>   1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cf92bd6a8226..ebe4bc8220b1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3706,18 +3706,19 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
>   		new_wi_state->iw_table[i] = 1;
>   
>   	mutex_lock(&wi_state_lock);
> -	if (!input) {
> -		old_wi_state = rcu_dereference_protected(wi_state,
> -					lockdep_is_held(&wi_state_lock));
> -		if (!old_wi_state)
> -			goto update_wi_state;
> -		if (input == old_wi_state->mode_auto) {
> -			mutex_unlock(&wi_state_lock);
> -			return count;
> -		}
> +	old_wi_state = rcu_dereference_protected(wi_state,
> +				lockdep_is_held(&wi_state_lock));
>   
> -		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
> -					       nr_node_ids * sizeof(u8));
> +	if (old_wi_state && input == old_wi_state->mode_auto) {
> +		mutex_unlock(&wi_state_lock);
> +		kfree(new_wi_state);
> +		return count;
> +	}
> +
> +	if (!input) {
> +		if (old_wi_state)
> +			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
> +						       nr_node_ids * sizeof(u8));

Yes, these are valid issues. This looks good to me.

Reviewed by: Donet Tom <donettom@linux.ibm.com>



>   		goto update_wi_state;
>   	}
>   
--------------84Vf1evSfAI0RhKT98wnVP5b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 4/1/26 6:27 AM, Jackie Liu wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260401005702.7096-1-liu.yun@linux.dev">
      <pre wrap="" class="moz-quote-pre">From: Jackie Liu <a class="moz-txt-link-rfc2396E" href="mailto:liuyun01@kylinos.cn">&lt;liuyun01@kylinos.cn&gt;</a>

weighted_interleave_auto_store() fetches old_wi_state inside the
if (!input) block only. This causes two memory leaks:

1. When a user writes "false" and the current mode is already manual,
   the function returns early without freeing the freshly allocated
   new_wi_state.

2. When a user writes "true", old_wi_state stays NULL because the
   fetch is skipped entirely. The old state is then overwritten by
   rcu_assign_pointer() but never freed, since the cleanup path is
   gated on old_wi_state being non-NULL. A user can trigger this
   repeatedly by writing "1" in a loop.

Fix both leaks by moving the old_wi_state fetch before the input
check, making it unconditional. This also allows a unified early
return for both "true" and "false<a class="moz-txt-link-rfc2396E" href="mailto:whentherequestedmodematchesthecurrentmode.Cc:stable@vger.kernel.org#v6.16+Link:https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.devFixes:e341f9c3c841(">" when the requested mode matches
the current mode.

Cc: stable@vger.kernel.org # v6.16+
Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("</a>mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <a class="moz-txt-link-rfc2396E" href="mailto:liuyun01@kylinos.cn">&lt;liuyun01@kylinos.cn&gt;</a>
---
Changes in v2:
- Move old_wi_state fetch unconditionally before the input check,
  instead of just adding kfree() to the early return path
- Also fix an additional memory leak when writing "true" where the
  previous wi_state was never freed (Sashiko)

 mm/mempolicy.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cf92bd6a8226..ebe4bc8220b1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3706,18 +3706,19 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 		new_wi_state-&gt;iw_table[i] = 1;
 
 	mutex_lock(&amp;wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&amp;wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state-&gt;mode_auto) {
-			mutex_unlock(&amp;wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&amp;wi_state_lock));
 
-		memcpy(new_wi_state-&gt;iw_table, old_wi_state-&gt;iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (old_wi_state &amp;&amp; input == old_wi_state-&gt;mode_auto) {
+		mutex_unlock(&amp;wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
+
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state-&gt;iw_table, old_wi_state-&gt;iw_table,
+						       nr_node_ids * sizeof(u8));</pre>
    </blockquote>
    <p><font face="monospace">Yes, these are valid issues. This looks
        good to me.<br>
        <br>
      </font></p>
    <p id="b"
style="overflow-wrap: anywhere; font-size: 13px; font-family: monospace; background: rgb(255, 255, 255); color: rgb(0, 0, 51); white-space: pre-wrap; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">Reviewed by: Donet Tom <a
    class="moz-txt-link-rfc2396E" href="mailto:donettom@linux.ibm.com">&lt;donettom@linux.ibm.com&gt;</a></p>
    <p><br>
    </p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260401005702.7096-1-liu.yun@linux.dev">
      <pre wrap="" class="moz-quote-pre">
 		goto update_wi_state;
 	}
 
</pre>
    </blockquote>
  </body>
</html>

--------------84Vf1evSfAI0RhKT98wnVP5b--


