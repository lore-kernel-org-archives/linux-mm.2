Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1190FC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 06:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55A16B007B; Mon, 27 Jul 2026 02:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E071B6B0088; Mon, 27 Jul 2026 02:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F406B008A; Mon, 27 Jul 2026 02:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7C486B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:37:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42607A1796
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:37:41 +0000 (UTC)
X-FDA: 85033600722.20.C378C7D
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf30.hostedemail.com (Postfix) with ESMTP id 81CAF80004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:37:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UtmgdCYo;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785134259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o24wMPf0kRDK1xDY68nvHO3rd5V4v/8M7uZkH4mb2os=;
	b=fuwLZJ2VcJ/oRy5yeGxZvAptLaM0OzXzH+b1nVWkRW13L+lkfOwipXFPDC9IAlDYh5+iz2
	MF75ZnM8CxJd/HV2VFJ/L+3bROjwLOBBfftunuzO/GtsTz9UhWFqKXubXnR2awDzN0NZbY
	fHbxEag1lilzTxCk9jc6GgRa3sH/EvY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UtmgdCYo;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785134259;
	b=RwpbCXm/vzd9GL/XFMDHMX8+CE0tmn+/f0TQBUKBSkGY1+eoK1m7kvk1pzBzKaNdep+rvs
	BWA5R3oRftHhpRPQXZSzAmm8SDPxUJIs9KYRzIUmqn84+3sjb+HUbEdUVZl0fm0nZZgZAQ
	/xo7Ryc0vvrFFBZgjR7VDXZA05QaHLM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785134253; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o24wMPf0kRDK1xDY68nvHO3rd5V4v/8M7uZkH4mb2os=;
	b=UtmgdCYosszewSI9J3kjwY+324jlDRdYyiTrnyX2nJCKdmYNeF1lLN/261uO+pNwKAozzKDVslCU87OA3UR0i0Gv7HstGjqLMgOF53gHj59yPxP+OY0HygI/ppGpbB7GShymADvqbPTdT9hIaZjUI+QKOnl9i1MkwlUAzc51Kpw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X7qdXMt_1785134248;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7qdXMt_1785134248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Jul 2026 14:37:29 +0800
Message-ID: <f24c8b79-1cf7-4988-9185-eee37608e0e4@linux.alibaba.com>
Date: Mon, 27 Jul 2026 14:37:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v4 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong <ridong.chen@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-5-ridong.chen@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260724033435.2573323-5-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 81CAF80004
X-Rspamd-Server: rspam01
X-Stat-Signature: rh5uytowcat9o6f14hdrb8ti1meij97b
X-HE-Tag: 1785134258-306748
X-HE-Meta: U2FsdGVkX1+vr6aJps6wDVmMlcIGU6whpLALC5k4KzEeH6TaYiur3d7UElTuporUyO3gzAGeCH+EzqJ8131m78vv35KhqRmIuiMOlEWkgva0X1A+xE10Hd9q/nej0Yq2K2IuFF5R4rHJVab31rtwCmLIK8qsE54TbzcuzP4QwRylrJjiuqtSmN+uxg2QkBFfh28AZ0ey5G/nXv2YouE+yPOIDj2rRsLtRdEatjGw6TxcPpc1a1P3hCCpTO3rTQ6dOmUUSYBq5nkvYdreQr9kmCQ8qCSSixjkQKehARtnQ+B7M6uKxRItO+iWEaLevEWnYUzx6vwTYG7I5qPsSbYBgqTo2WV9n7BCwBP0wRdveQoJbAPErr6vVSaId5EXQ/F+h4LiWPrBcCo68AT2E8rgCmR7x5zLlPX0ay3l/kSzK+LMwV6wTPSyaY9zluBjKh9b1v11cKYutYFH/O2oPz29HD4gd5pQJfTQP5aOP4rtlFXVmi/xRcwYrTRUhqFGYhQ+uQFUXcyuXSEywhWeWZexMYs33X7EF5LiSeea8CHbkpU4L1Vua2eBN24OoKlm9JuoD/SWpCJUGa8Q4o33JLWkNPATogf3gpsV4bGn1dUy8sGHansWebkGt0FjBM49Z9kHgI4g1UsbuyZ7jtEu9/O0wEKkI3MZvoREIgaYFoZrE108pic5Ng11HLeY4a0pVv+5lhdwVBL+/QAOR4BrKwVetRQ4vdS1/H05Bwt2QWsKoTrh6FVWedttOSOJZBWsRrDasK78V6Z3kbxSDUZ6OYlxvsbz7POS9/cCic56ffEsHH8yjK70qYR9sXjnR31Hqc+raG1FhPJoDcR9yfi9jA19yboCos5D0Hagw74qmkrHyzFm+TJb63VfeMId86kKwd29KaJgd97UKd3bSXcrP2y5rnnLKhCT8B0sfU9v2QUDua6ANw0M8zUKIlZ8iP2+sa1F08EKx1vG7IYVzsRrum1
 zBD6HPEs
 Z7JbDLaAIkHr15k6ZIB5Cyx/aVRFVbexvWZEe5x+DXXE7yMJY2k74x8Nxb/k6gW2FvDCxgtR2BcCz7h+Ec5P1r1gomqkgj/oVU4KjitY1OzdCuCVDuYfJ8k9xHxXafiTOUJ3fN/dBssQETWE5S1UauUrmrEEgmPWVAdq3+TD6HQ/DcmdaeBqq85032OWR3NAZ9UI85RKfffs8hJIsqemacA0K8lfW9SLNc6gYHavOrNAcQea4JlGwrQFuWFeNZpMRUqxPmTTG0XO52kNIUOch2diV+eBeO5rSjH9daNErueZM9Vw534IOBzbOMQ6W6xCIIbCQfU/4MpeMjSU1rtj4ZwvvHYyi3IXWqpoXah0UtMqByaewJ8UMTpKPxhhSlpD3C4Li
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/26 11:34 AM, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The previous patch fixed this issue for the traditional LRU. The same
> problem exists in MGLRU [1]: when swappiness=max (SWAPPINESS_ANON_ONLY)
> is set, reclaim is expected to evict anonymous pages exclusively, but
> file pages can still be reclaimed when anonymous pages cannot be
> reclaimed (e.g. no swap and no demotion target).
> 
> Fix it the same way as the traditional LRU: keep returning
> SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
> get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot
> be reclaimed. Since get_nr_to_scan() decides how much MGLRU scans,
> returning 0 skips the scan entirely and avoids the useless scan work
> when there is nothing eligible to reclaim.
> 
> The test result:
> Before fix:
> 
>    # cat /sys/kernel/mm/lru_gen/enabled
>    0x0007
>    # cat memory.stat
>    anon 204800
>    file 67108864
>    ...
>    pgsteal_proactive 0
>    pgscan_proactive 0
> 
>    # echo "64M swappiness=max" > memory.reclaim
>    # cat memory.stat
>    anon 208896
>    file 0
>    ...
>    pgsteal_proactive 16384
>    pgscan_proactive 16384
> 
> After fix:
> 
>    # cat memory.stat
>    anon 188416
>    file 67215360
>    kernel 1970176
>    ...
>    pgsteal_proactive 0
>    pgscan_proactive 0
> 
>    # echo "64M swappiness=max" > memory.reclaim
>    -bash: echo: write error: Resource temporarily unavailable
>    # cat memory.stat
>    anon 204800
>    file 67215360
>    ...
>    pgsteal_proactive 0
>    pgscan_proactive 0
> 
> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@linux.dev
> 
> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

