Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D1EC5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 02:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AB76B007B; Thu,  6 Aug 2026 22:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CB76B0088; Thu,  6 Aug 2026 22:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB466B008A; Thu,  6 Aug 2026 22:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDEE16B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:04:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5962E802E6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:04:01 +0000 (UTC)
X-FDA: 85072827882.14.5AE2838
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf31.hostedemail.com (Postfix) with ESMTP id EB07520002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:03:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GJ6cQ2Q7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786068239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRc+g7yreJ6m5qhGtIHjPhu/IwmVP+LPFazu5TXEzJ0=;
	b=ukklGHAK6gLbpZt6FWNDxvQjxrmf7VyyPvisSdlBNFOq45eXkm/yt4waZIMnBYBb1uM+Yx
	rFiIBEAuIJ0YyHcmUbxxcPi4neKgnrsANhvZDopLybb80K9JTJtfGPORiycFWr2XLvJWtR
	uh+hs3ppRCQDln8QzWzPDaGC+MGsoaA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GJ6cQ2Q7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786068239;
	b=FanpO7YcJUqjx2XK82Zx8l/5bmW8UxsTIBHmrxYoalDvSZzO/c9BEZQbM+EzQvgkT5gtkh
	qLrkRPcYEAuRwRdvzfJdmsg3Ph5wGUlDCNVfKXDlab6tAaQlNVE4kSGKbnugP/Hdgjv6Il
	pWUoARV8j1SxDOX82+oLwlyUioboP98=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786068235; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mRc+g7yreJ6m5qhGtIHjPhu/IwmVP+LPFazu5TXEzJ0=;
	b=GJ6cQ2Q7+GuUh+vBTs47q3E6De70ovgPiDi3efn9CWCr9u7bOG+/Amk6nPK0UmJzD+Tjb3eFATT+QBd6cehUc+DklHKnLIpdqEDvntBTkfMcHFMqzvd/LuW2oOE1ggI8QlnA9kBpmzQ+ctgdKjlviFX1bu9pm4lSaHjSxhW7zGM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X8VCyTA_1786068232;
Received: from 30.246.177.19(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8VCyTA_1786068232 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 10:03:53 +0800
Message-ID: <06cd88f2-8e2a-490f-804c-93c200bd294a@linux.alibaba.com>
Date: Fri, 7 Aug 2026 10:03:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB07520002
X-Stat-Signature: 6orcef5wsrtrayyf1pfn9oqrpnrznhd5
X-Rspam-User: 
X-HE-Tag: 1786068237-377480
X-HE-Meta: U2FsdGVkX19ty8C+si+IBvMJ5l/7ERoB5dtF9Il06MO+U0oC/tQGeXklIEoVWw2x9OBrEk5DstBRU0j4rZd1IKXzRf8ZH7NgeXeEpnk3FoYir9qCiClhm6nGr258//hdSkACWnEusAr381SbSR0/umt+XeJyKvqvYUtkUm3LTfg3jGI5XSCf5oZEr7pi0MB7X+G/q1erRx594Ho2wLt5DfD1uKfJdgU9VSvUNsxYYCigFZeKMc8k+KGjFt4dBt/DEYxwtjxXDHL/OiQ1PZDAyc1lt3q2Q1oG5Y+hX4xm0vQ+qB8GmrNNeGq7a/l92V7rvEiAsGwlcas/83hikMKswVnPC2Js3wCMGU7PGwsTg9S5m43uYbTc3zlYgu8Mu+C9EHu5G7lHzr/iiPFWUKmuCRGMBJIp7Vr4eGJM8FQHM07HfNjaXjQyCHCJPgzLg8/zYZfTTRo8lo0t6Pqk8PMUoM6pY4fo53/SizOK/WT9wQ0ldaC62ZxV+NEvW9btD4q/0Wyibj+IL+VXLEzIEXW/T4XnTprM8JLu32oOjjiBmuU6yoUyDsZ0p+YJY9Zm34aoy8ZYa0IHkJYL0L6RYc/Mf4r7BZoYvxggHrDBwXB4/FkFA89hxe7uJOYLY87EaMEbVWwcodBqsdZ4BDCWLTfnDya6NQgIKXIiwePGgC6FD+caJm9XChfnORygkla0VfvHTnrVxxDnCswFMpYZHT90tgfNVHYpKnNKFB5ayyvMTHslySvR2Womb9n/RMRjYZ3gJUsPGqud9Zx5JHeZ1hpPYNrJuRmrjDQhxVgrW4Bumwm5Dv8htmFUMgdMgYlHUpN61UaKFMG6IYkxvZ7JOZcN5dt/uOjy0gm73uMvPn06GVVMEhp9SLjY6OBAS/gvwCgWRhkjgiWYNfqPZ/bgRLePe55T1hSfsh9Sr+7g9DZFcgTvk8+t4ujbewmSYSY2gJBbqdQbKr2v8RTHgGIH8YO
 6+I87XHi
 faUgS3afwMlH9GydWZA99Oc85sGe/82Vky3N/TAIncHyRDM9gX62RpGfhCui109Ca1E9EUWIEIJ4k2CUC2jUVB/Jlv/kJnO5RnOnLxkA8GKQbEyOHGKUkL59ZjkOjPbvMQSGnEu8nCSNVUsvZVpF9Tp1LcV05GV1h1QV/q4ItQozjaZJVUeHNMtdyLIoy5wGPVstQZi4G5NUih6dPcVvyL4FMgnfz8zjEaoCTIHdd54EXAPTowFQW4OzwT7dLLz5x2FSt3WmiwUorzu6IVfXvY65wukgzrN6ePdU2yFyhROxAaYtmNuCdVAc/mjQcxmIdwBOJ5b2VhybVOm+TrPOINZQqcMdq3WkPk3E/69P3nxVKmEHWrjtBCeEFZNKo0jXtTNNqvl9GU7ZlVRFVYcNIYTadiP1TQzQ0Tl/8SbF/QXex+D7yuaUcc0V4Jh0XGbyoOtOfyGIOa168PvJxgNXU3kerNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/30/26 8:23 PM, Xueyuan Chen wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
> 
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
> 
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of the
> folio.
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

