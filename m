Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8593CF433C7
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 04:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550696B0005; Thu, 16 Apr 2026 00:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501426B0089; Thu, 16 Apr 2026 00:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0736B008A; Thu, 16 Apr 2026 00:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8056B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2FC859AAC
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:24 +0000 (UTC)
X-FDA: 84663122208.02.98083EB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7840CA0008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bksPd80P;
	spf=pass (imf15.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776313342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbjDTFCafDYMJbsKLc4sKLOMaexnyfa/MqYdYKYXm3M=;
	b=DE7g+CgkzVcQWnWjS9pZDKAUplDcGZgnnjqeQjcSKMASd1OQ/J+rUlFKNR1+2wd9l9alvS
	aXiSGkcCysvhDIOr/6t9ELxFndejHwNbJ5X/x3V5Dfh+aNQ1qp597U4T1D4ZkyKM6H+l39
	faIMaWCQ3kmNfVhN1noPeV4XBmGv/LQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bksPd80P;
	spf=pass (imf15.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776313342; a=rsa-sha256;
	cv=none;
	b=C9fjI3hlyFplXAewtYVJBbgRq6z8/aFetsAFhMiF1cKwQYeQd2DE6xnQKcVBW3WlgIKKdl
	gkOmSoQuPl63sm/D/VwRmAt1SqVQSy1N/w8ulZTAQTScQEaSxlFLIdK7af1uxgmuj2F/6E
	hUXGKDDEwAvnirRBzKgt/SSNakbbfnY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FK8m872487108;
	Thu, 16 Apr 2026 04:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UbjDTF
	CafDYMJbsKLc4sKLOMaexnyfa/MqYdYKYXm3M=; b=bksPd80P8cmHnJ6vMl2Tsr
	GZ1fG3a3lwOXp7N+7XIy9P73erVl2BSYWKBsBoURE78ozAZGecpM7ODMq0fCNjtA
	+XnrJH6XCiUOx2auafbgsylyGlRuqPokHr7ITXwIy/3nAX2ySkCHBBpujzl91fyY
	sdSm5ehRP3uwTLL36GdajmczUkF99ITen+CU7f8iLMqn+C+iVKHE96UiHtJN30zM
	3g+qE2mxHqZe1UJ8wSRzoQS2Jh6LTFgqZ0kWe1XBXyQJrtCaLOGyfJD3ed1iC451
	GSYY3scRgh3UXueAmekeTt0j1PlJZcne1DLeLaWWXPTf3eAATojoTGRKZQrhb+mQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mauhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:22:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G0aHo4015164;
	Thu, 16 Apr 2026 04:22:17 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0mssgcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 04:22:17 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G4MGjU33620538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 04:22:16 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7B7458055;
	Thu, 16 Apr 2026 04:22:16 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C9D058043;
	Thu, 16 Apr 2026 04:22:13 +0000 (GMT)
Received: from [9.39.27.85] (unknown [9.39.27.85])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Apr 2026 04:22:12 +0000 (GMT)
Message-ID: <54b0f31f-6720-4e39-a182-ba11948cb024@linux.ibm.com>
Date: Thu, 16 Apr 2026 09:52:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix spaces used for indentation instead of
 tabs
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
        vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260416021945.682234-1-gxxa03070307@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69e063fa cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=IeNN-m2dAAAA:8
 a=1azo6HzM0BMiu3SuvnMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: epCRGs4vnWPIgG8-ZtT0ohZs1Bx2acYi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzOCBTYWx0ZWRfX0Xg/xp8qXUAM
 nF9H3XYipk1IawCIwlh8eIXLbBem/XetLBGlnEHtR5J0s1bcddD5CRZY4r+m6bpE9uqMyLj0wIk
 nishbjouVaQycm6FIKu0IiEGIn0vpoj7d6dEWGg9zAYzLIzdgO7x+P5BFAFjBR9r+nvmm/PKUCE
 EIOfVvhBekF5Et60bppYz+spc2hrdmNw6iDkOO6hWZYW0WgDXUX5monD/Kzecf3nLHRQoOHpIXB
 oErUPa9s78JFf2sdXu3Ly4frCZVpGAy+Jks53DXq4wXnGwBjzE9/qzvggJyw9fRs9ZvhRhwoWRB
 uJq7VMyKRsQeGX49cDCh/VbLqDynA/0iDajzYKW3xaH9sVbEGge3+lFlYKZSUuyVeJJTjwRyNAs
 3auiv/EhB657daxKZS8PA45v5f76515v2gtxGeYxhTy0TFabfCLBp/mezN5LLh8ABCA5dR3pfNw
 YZzX7Ov6AmUIpx/qTwQ==
X-Proofpoint-ORIG-GUID: M9nBvpOhQkEOfsEYgUM1n95gPL1rsio-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160038
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7840CA0008
X-Stat-Signature: e457o4r77x8xm6xb7ubfrozbeyjw73ad
X-Rspam-User: 
X-HE-Tag: 1776313342-3198
X-HE-Meta: U2FsdGVkX19AUH+5OdfqcbPbk7RZdpoueXwa/u91P+JldVoJSczbKGd5yDXTmh+RXUXI5SMAdscgJntBMMBJSknxf4n96pkD/1l29Hi0hEsODscF18YsPPUSsAVZUKLogli95jflzGQJfOiPCiBBwxKKUuqnlrZGNUREtaj0rUGBBgA43pE/UFn6Li26C9+5NSsVodFBUBcdA4LRAE/AyV8ymMtaubShHz8ftkf9xMKdLlwnl0hMMfuSwk6tX83hW7rhJMYR74vX7pA9mQddc8Hs9Z1E4a/ThvloCtUXCzKJzTQpPuJB5UbKP8nK5jXqiWrt1zk0ohouHdGoan8zgHuGg2UdZOk/QV9FpqDRjS9UGXHnbPWcAnDg5zlUOOw6qKW66dgGgvCFS+3f9tro+il2tGq3iiUyzBvY2Oj8zhK0XXLS9ZUWKyf2sp1xA/MzmiiaO50kQfWAmh8fns3wJkXik0YgONV2XXj5iYhVOzkJ+apmNRF0WwrQTtdFHpsGZD5xzSKr9NMVvAkJxdJHhjkE1KeURSJupzPEIi6KJ2/P1q4uhUVEI8WNv+AJluHohoqwX4Sbsp2VVd8Gi3UWkij4kfc0uEiMLH0Q51oJIkSF9Pjj6vmnLFYFVP6t71E6EC5xB4ycletmCKqY5Rtl+syxTNNAN9pcB7OPgfzVz5AzTeOAgIEz9KMv0kzR9R5/GEGYAtQsMW0PrTS2t+oEs9qmt9TFFuOaBMVIhXE6s9bQqA/NlyxbmiaP+syRqt7nybzFWi/a8lDtIshj8FQ9ZsBoyoLJTZTK3Em0OCNZbWU1R+F3t/XegNyfnurCFFoZ801ZEDdiGufnaJytrhb21GLBR5bUDUTIzqsd7K7naT3HulWcmdhmtBypbuDgGHnpI7VtDwJMbyYxJt9tguusKcCPLatZqe5mGkaC7gHqUwh8dKcTS83a8j0PAaUumjlDd9BvLgOt9S20KqhVx+O
 YqMM9wMX
 17DSg4Z9SzvSITbkz9jA9bHtcWC0DynZ73UoQFcUCyW01tcEhzaV3NW+szArz+1vM9/b2aoWmmWlKBLPI1D0YuGq6N78yQyHeCGaSKmSpYDOWO2i97f9iF5JLxzDsXQiMPAt9vbRedDZFFIhMHeB6QwrKlKAqk5Aid8lArUZ3UfE8beqJEoKw1VnyoGCaYELP8jxzsNu9TErzSN8GHs41GYL5bU2xAlTCKsfCo8ilUZbdjy7rQkRmQudDLjO9D1Wav8XHUcR7dr7a2LTmRKjVy5fiKuyJ5s82/rY+PS33dqUR9ZZL82xCyrC9Zp7tLz4oWtVY/etWO8f20gP+fhgqCMLB/1ap4VIkxlQo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/16/26 7:49 AM, Xiang Gao wrote:
> From: Xiang Gao <gaoxiang17@xiaomi.com>
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
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
>
I am seeing below issue with checkpatch.pl

./scripts/checkpatch.pl --strict 
0001-mm-page_alloc-fix-spaces-used-for-indentation-instea.patch
WARNING: From:/Signed-off-by: email name mismatch: 'From: Xiang Gao 
<gaoxiang17@xiaomi.com>' != 'Signed-off-by: gaoxiang17 
<gaoxiang17@xiaomi.com>'

-Donet

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

