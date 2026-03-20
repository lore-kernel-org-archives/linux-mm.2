Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1E3109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 04:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3186B040D; Fri, 20 Mar 2026 00:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA0A6B040F; Fri, 20 Mar 2026 00:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07906B0410; Fri, 20 Mar 2026 00:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A15556B040D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:08:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 336091A07D2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:08:59 +0000 (UTC)
X-FDA: 84565110798.21.E094A9F
Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F123180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:08:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=bPScg7LE;
	spf=pass (imf24.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.50 as permitted sender) smtp.mailfrom=yukuai@fnnas.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773979737;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBMtnOv4DRn8rDgmtSHryk/8Qxx1GHEuCpgpp2GSR0o=;
	b=61m0K7FSe11w6FCkN05KekR+2z4AiKV6XwHmvBwQZ96RjhbnBjartn0Eq0+cb+hynrkulP
	BTRanHmlEhsxVjd/woMbE9XkVkj7sqQbWFfJ2CeWR9E/ZNXROtp1JtrJClYGU3hAeOFy3R
	NBr0cPHOzKW1pbjUOexkhJrCznMdl5k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=bPScg7LE;
	spf=pass (imf24.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.50 as permitted sender) smtp.mailfrom=yukuai@fnnas.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773979737; a=rsa-sha256;
	cv=none;
	b=m/y0xwmeQcLiTVus41RHAciApkL7fHgOtgIoJNNASxW8yJDV2IGqycB6kJj7Vk1yIeeFOg
	895TSML/qrF/o84XTwqucWsuQz+EFqX7ZFSUUexAvTy0A/nSRI41Br7nXaK72LYgbn+tkX
	4j4MyOA3BE1pvi9AtZUUk3qyTh0ujPo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773979727;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=sBMtnOv4DRn8rDgmtSHryk/8Qxx1GHEuCpgpp2GSR0o=;
 b=bPScg7LExrd5eeaimik/7FZC/a8Amb1st3TZ7pN8DA5mCsaTWD+c6tWZQmD5JtGaGUK+6m
 HEBHRxHN8/h6XxbKSOuXCpsJaGxD+csNTdZYi4/8Gi4Z1HaZ1dhxTSJ+odIfBl5GnWwlmq
 a8xhU6ISeIBPnElOt5MSonKwtfuR1qGhzdlWnTcLgI9wW3NQkdxPerHDmuK6t0rt2aVK+i
 Ff94rbBkK/k5Q4yjaH17+AjrT+48s4mby9ql95/pnSJ2gF9YTQnSolYIULUdzvRbadp6ly
 nOqKr48VRqSWeHyG6FiIz2Dgc55BaCgmuM74XfXK3AX4e8tUsz27PlFyYqbZTg==
References: <69adaba8.a00a0220.b130.0005.GAE@google.com> <20260308234202.3118119-1-gourry@gourry.net>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, 
	<syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Fri, 20 Mar 2026 12:08:44 +0800
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+269bcc84d+88da36+kvack.org+yukuai@fnnas.com>
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
Reply-To: yukuai@fnnas.com
To: "Gregory Price" <gourry@gourry.net>, <song@kernel.org>, 
	<linan122@huawei.com>, <yukuai@fnnas.com>
Mime-Version: 1.0
Date: Fri, 20 Mar 2026 12:08:41 +0800
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <d15b9cf0-94cc-4fd1-a702-e3e34f967f6b@fnnas.com>
Content-Language: en-US
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F123180002
X-Stat-Signature: s14m7ooquyaxr35bguaza54jnychkjzk
X-Rspam-User: 
X-HE-Tag: 1773979736-397373
X-HE-Meta: U2FsdGVkX1/+lnli81DbK+Xuufo154vrWwpwj656JROXaLZkKU7caL7RKHMMisEP4tnisDiOfZm/iynQA1t51UnXe1MOoBkXADMF3XNUgXMo/6f7XrN9J97HgOwqONBBE8+r5TR28ay6s/QLzLbjuaHGJQSJ3wmrW80ghlpipubjuaCzlczhCi9v2vUnPnB9Q9SuyiAtzwR6S3EWU72gZHgbA3F+lE76oNUJC9dg/71lW0mvdwRZbC8kA6IuFALFJs7Vk2d+95mcbdSdg62jQl89IRNLNuQPDOEgGRWYV06+JmIrK5tfQAe1CZIz1Nnost/kqi7ppmQsqMPV1iO+1eN778lpbu6fRHY8a0z+LbPqndBbQro1H3DPHeMRqCsT9f/YzL7wZ3Yb3DBBJCGfyAx57NreW7f3kCvib26AH9z73NPtSF9tp3W8zXqSeqpjov3vPHMDNqlqZD8gy2GTUP53LCA8J+Jd9rVr1M9Oj29mY8twVfpFqU54iggBneQRp0MEGdTiVIgfeBrJZLz42dOMRZ58xNtJnF3bHzHBMzrgUF1C3fQUS2rarQ8P68ipITd5XsAIsjurgfy+b4fajaAHCv44/25DbUqjoX6EDWl84NlDYJvnTGd45+pOb7nQrDByXNJcy9AqXmHqNr2TxY4qr361IgFk0fAxl5pA3bb+4XDjhwTAy8P/1cE6ZyA+T0Y2ZbRuk5FH/IjFnM6cmOI/RxCD7zLukAdfRVlFUxVIWhzM10/iTNU54oMUufNHeDWzqo6CKt1drAObRnBSoWyoBuxfzNZgPA5B1UG4KAWiln7GHwW8poOF0cm2h2r6nsXNt2mb3hi+mqT1mIphsJ2vucIkZ/1i+FeDYZNIJixAQFiWeuWWijfLeT+vcduSM9au5KtmLgQfTCXy+EyQzR7iuanJHMvhpWgKkYI61ogvLse4MneE3ivFpBWLTpvZgIgYVz9YdHf0qVl/bl9
 Gk2kjKt2
 CIRVwIzNZxCbVeYmyL3M1ZZVlZRrGYyuVzMVUxB2NCB1nkRyFLwbLpeCG6yi/NBP6oADkXdltLJGtOq+yaJ3gvseapzPrjbLTXtzTFKgwDhNAbkxyY3rK+JOtADDy2Zezas7dQ+AXbpyRvx0r6ZGyt55aSZuFRA320sGqG+k3jtMbLoDL93nunTpvhqKkyOxZ8lTYm3hGIFqjyEKXrqcOAKuSoJh+bQno+LeKkjL15uy3nJcgWoIjdnCHBTifmnHfW4daoDqDQJaWDwqiUVMfhQRYz+jhcX23LxvMPdZLoFA/0YM2NwEbIb+Pn9+ftqtqVfwMIIJKx7bLcmXSLI0AGTLjMPmeXwJ1C/IxColRxYjsVh3z7AUekxIC1Sq+wacP74GuCGztE3S+WGvDmdcdtZtunIL00cIA+12flTRtMbHr9Wtdw68QoYgPs3/wacuogbTAcwSZT94C0iBgyAOzehg7dkrLfNg3OAwcPdr2qgFX3etDkaOX1Ox+bJLjIv6lm6uClsuRUnAC2Rt0DbEfotA0CXJyunR3NXK7nUchUWuKAfI3ZB2O1RRIgarw/saiyCc7QzVKkMko5HrulAc74L9W9IkN5f4WZ+lBp6A0CO2iLwHFcbaKYtvULomUu/tGdBUl3Iq3KnVf6rd1/jsMud4kD08sdPCJOaJAJSJ+xQ0RYDPimyTdDF+4zoWUwtDknrDTcaL5baCUDDBwNxSAOjxM9neb1wtjrJoHO2cYQljVbY4OD5IyQbW0W4najc9xycDWqL7Tte3ZWVT/lUQ2MyVjAjkULdAHq3Vaj4mP7T9/Sv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E5=9C=A8 2026/3/9 7:42, Gregory Price =E5=86=99=E9=81=93:

> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof(=
)
> triggered by create_strip_zones() in the RAID0 driver.
>
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
>
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs =
to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
>
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physicall=
y
> contiguous memory.
>
> Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> Signed-off-by: Gregory Price<gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai

