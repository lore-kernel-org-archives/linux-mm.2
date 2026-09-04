Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5E6C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550626B0088; Thu,  3 Sep 2026 22:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500E46B008A; Thu,  3 Sep 2026 22:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4189C6B008C; Thu,  3 Sep 2026 22:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4AF6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:38:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80F221206B5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:38:21 +0000 (UTC)
X-FDA: 85174520802.10.5E3E983
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C974180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:38:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uz+Kevqd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788489499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iDbS/2opdWj5daik4HnLoHkAw0htao1fAwdVPxrQ6Q=;
	b=jbBQ4Kh00ISaZSGDL9iWnuzagwATiLFRGjpiYcxtj5rcZLtMdoIWpVpmHtiFc6brtxun9F
	/cCN6//tBamFWEsEMoqeE3ENskYDcUfUreh8P+7C3ZtJ51w/HxZBuDmFPRe7Si086xWFTF
	WRWLmx+5GDVQS4tvMwDUc4jodbeHZX0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uz+Kevqd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788489499;
	b=Wk5MmgcGVQS50tK1ZvkVjNvHOIIWr6nJ2D1uEIr8w51TE+/q1mFg6Kt53j22oCm7rhu4tx
	zQgxwKIsEsOIgkBdaWyNW6vBbCht6tq+i8BI4equZv570m4zgMGi2BcYiJvPXn803ukjEN
	8bOWBeQYKTQUQU63Ki/ia77+FYYAyNk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788489495; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1iDbS/2opdWj5daik4HnLoHkAw0htao1fAwdVPxrQ6Q=;
	b=Uz+KevqdAUuF37x9ERUnBJ2W6aiGQ88MZRyi2+c0Bb46J/kBAUtIVsoK93ntAAkaB7Sk9eX1VLJ54FREVZo3KWGur6WcS5KdgXr1TNu8sLzwNEAHY2lHA50ubdMFjsOe/4U2GP32JLV6r2qasXPC0ycSTuLtoHYwW1wubBmqfko=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAHJ71n_1788489491;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAHJ71n_1788489491 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 10:38:12 +0800
Message-ID: <9d4b2f36-5fd1-47e4-9f35-a3fef2913bb1@linux.alibaba.com>
Date: Fri, 4 Sep 2026 10:38:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm/mglru: batch move folios to the second-oldest
 gen's LRU
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-8-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-8-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 15xqob96geu9tgga6ydng63hcoufd8w4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C974180003
X-Rspam-User: 
X-HE-Tag: 1788489497-920472
X-HE-Meta: U2FsdGVkX1+gnCd1RaORck2PGQRK/cekBrW+nMvFyYcBiJvP+oMkl7dF+ixLsJ64s3CMY98ke2REA0Pq3LRrJJG6htLC7jTZT+ORNtAEJriZVnyPYv7YdqgOVmzAqJM7Q4/9Mxa+MNqwIoQ0Ds3rJ7WsYowTt1MKGEIRpjCFUge5AAFF3L6UcNWczTb2Jrypcr1fm0M2KPy3gU477L/t3m8vAvxZxPy6qk6TBIsO31dIPfrYvTY9ZjLuX0qF5uvjhOZRAlQzjfYLY6jWPhfx+0OF2TXKB9zRQPgWZtWPkppBPgLYk7bQVcJijXjL7q6rvX2QTG51UecZU5RwUk9832msPEy/Jbz3xBWU5dhLYYqhZz2jusPgIlSscaZWFCdW4qVWL373Z+sbBelw2wxqdBMS8RfoOJPcHm2VCHKm3fcqOUsdChOY+MrnAeSd2iR9yvMAYWPOgJjEgLULgytPQszwdRuzmqdrVC2XTkJZWEi+SJZ/UWFZfYyhji9j0p841r01F8q/1vv4l66VInO69sZAatIWPjQaOo51kIrkcB1EZBVhPHz3GYfoa8n8xqzk6KtzdJocsrU04xmQZ4lvaUAd6C4FGjS0CGrC7CLO1zo4EkQjcLMKmSfWzBmx8iM/feQK6BPXI/2KzrlFvWIdx2HqDBc1f7SLUdwTbSouiC7rbJVuNRsxNSI3R8IAaqGWeYbuMg/3NoNiqJwDwm1xNRjAu03LqWoV5a/f6iBSzAZkIy4naS4r677yIr/ahU5DPOZKR7qLg9EXa4Cuu2i/9xxXWnbFcogr636fd/bV+6idEZfiDxPiQDmV5dWVZ+srJEIxVt93VZ6bFeRr7QhKD2C10qCtbPx+WcW1A04NH5s8/GJLEYwkc4F97Bs7WrK/n9Hm0UacEZa0ddBgLSovjXelf4XyMY781EhO25/NLSdHyIaGQS/C2F0aMS9vZcDujaQUW5Q4ORqiSgjVCXR
 KuXtNQPh
 V6/cfV+eUxNclzFNJXkRXulxibEiNSvSQH67WBij0cfAZlWRltmqcEEdNFA/sLM3JZNrwWACfSv6xRaOIluwk9RPQGt+o+kGQy+iPT34cJYjuwUslWK2t1fN1beOLE5RLgvjnX2sitn1+m3K8rBSiCNDRvaHDtDn3IPmV9rlCk7uxsc4pDdVc1fkevx3cLZE3za1XH1wnNiUmzWlm4mBTVb3JlEminnZduqHUH35StVgcF1+3FHnDxdlq8YAbpcCQs9z0kogI3aJcGs2xE+M6oJkEYROvsR4K4W/j+V/W2NB97Ip69/Fy4QJS/vO/p4ey3LOTuWZiQPlhoq+OamrbvXNIhw/+7lQbBB98OwuqhkR4vAkTSd7VwW64ALkjf9LV3K2bTLbJwjW9HQVDMjUhX7Cs274AMceF6ukeh71yN5Rcz7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> Detect folios that need to move from the oldest generation to
> the second-oldest generation, and batch-move them together.
> This can significantly reduce the sys time of inc_min_seq(),
> especially when the other type is significantly behind the
> preferred type.
> 
> Assisted-by: gemini:gemini-3.6-flash
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> ---

I have the same taste as Baoquan[1]. :) Anyway, it's up to you.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

[1] https://lore.kernel.org/linux-mm/ao6zFSzx6mOl874A@fedora/#t

