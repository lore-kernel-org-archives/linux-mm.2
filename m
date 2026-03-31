Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6ABFF60ED
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EB16B00A1; Tue, 31 Mar 2026 04:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B359A6B00A3; Tue, 31 Mar 2026 04:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C786B00A2; Tue, 31 Mar 2026 04:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9262A6B0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:51:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34BBBC33A9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:51:21 +0000 (UTC)
X-FDA: 84605739162.08.69DF7AC
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf02.hostedemail.com (Postfix) with ESMTP id E10818000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:51:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ctRWEiLD;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774947079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYjN9h4+3bUDxNpc5oVatfPrm0gSPRSAp2rbE5CgWJs=;
	b=oDu8f/OeVK+dRbTwUyqJZd4XvMxCr67BUM/fB6Ci7PRwOPE0GwEIRkShBcEFcaRJ8Xi2c4
	dYMLdTcMCn2BeIDYripfUXasbe5dN/qgK1aCMqfBuxBruxjSr6AkjsobaXop+lQY+KYiD1
	iZG6e4Wb2Q6izOFEvY3gKj3UN2EZ0yg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ctRWEiLD;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774947079; a=rsa-sha256;
	cv=none;
	b=H/5JCiCs37IYYU1uhzK7EWlf+RdyjDJ4grl1QzuUALmQIV9Sq+GqiccQTj/W8R9/zHLxIz
	ijczmdpu0jB35N3Ui4iusa3Y7GV1KUUiV3Tm5Y8Iic6Z7fslfxWc4llr0w5pE4JP/0tdqM
	knXDp/rVKFTajWf9wnPFVgDEsh838Kg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774947076; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=eYjN9h4+3bUDxNpc5oVatfPrm0gSPRSAp2rbE5CgWJs=;
	b=ctRWEiLD97QyyBpB2/ayTACBCnQ9SoT/GWlgqsjoxvYRrQ41LKuZo2hSuH2jLD0ELkEFE0demihKZunvTeEOQJGTD8Pr7m+zecNZcieJj2fFBJU4sXq4fgjGpkDuQVKx9oI750abS3DTOHaGUV1Zl9yTJ7iSpBsRCckSGZF0g9U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03pBFp_1774947073;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03pBFp_1774947073 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:51:14 +0800
Message-ID: <65c5bf4b-3d1a-4b3d-92b5-a7f8894d750e@linux.alibaba.com>
Date: Tue, 31 Mar 2026 16:51:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/12] mm/vmscan: remove sc->unqueued_dirty
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-11-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-11-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E10818000E
X-Stat-Signature: sqj1hr44zcj8h5truhd4rqhiikxi7kr1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774947078-727997
X-HE-Meta: U2FsdGVkX1+xuklOO8fIqOs7+20Qwtn1EFWOZmCU1v8KrlbOELaaCXhlXgQTjAsN3SH9gLgUcsnS/RN2CbqzLoTKzdNjiO6jmhOQAfe9tlP2nTF5oP5Qov/bsY9UlSBd9zIPN8wiUXFM4nl2RRUol3aMxi+tpQEmAopWLUgIyZ36K5jSgjsUQ77UQzKyr/87ugMMEqXKivbYK7Ssj8umaAC6mMTHdUVfNNahlUQwYXkWlZJMMoMjqG19zxnxQ7G9nAPO3rm0ftGGiI939D4H8Dfsf2GgwR644i3QOgX87ZQNOTEEo0uqrxB7ONjleGrQ4dpQVhQIzt3T3Df///8PU4rFM1wnzDTSng8U2KPpq0+zbYbFM5I33wX5qjvUYP8EjXPvBV1lO3cKaenC+BgpZThawUS092S3AbMr7VvQDD1olmPce+tOwe/eEaqRtg4JaWyJwrRQ8ZibaDlzJhVjDAimUo31QkD3XeGilN6ivxCl3b+8n5ABI4GvSpwrvIf5gR9I5JgIanW8kCNI7dMTnp0VD7vHjVHTUlheJxURYnfOAk5qhzbQEa0lrKk0RE+Ao7/bCYtYcG4+FSJXleOKTZvmP+aMMstO5csDZTsKtDHKdQOCHEp4K2NQf5iPLmS/6lGgq3sLpHBr1int7+G75owNf2IYFErGKBd9WPMHqaW1HYYpxctRhxfTi8pFYpF8WyNxNPGInswgoeE85HAU/mAUSejmzclMA1yrkCrgdDk4HoQh4QT99LwU5J8srs2latTMfhIkTbjONSt98uXvxNpHV0grAEUFqBRjrAtIaevuo7RlPs/nlj3GvHyeyaPi1ipOWTrvRkXrO3QkaYt+DQ0Xsf2hCwXCt1AEXdA56ojjxSnmT9wLUbkMIftYWdcVoOqJ6ytN9LyAcGZr2oH+pmvaoOLUgWbm+DiOIjPh0Ohqt13g5YY9R7SKJ18xrxk9T35MkoXJLHBDr4yBgiS
 WWMuF/DL
 jkmTib3CS+VYNIDWQh5HTRdRxwm2yAIFAChwbxJnNXmTws8dd7Ysxf531pR8VNvGJUMyDpr1lhsABD4B8eBSN/DRWgapVXX/MqCICaip4eC/qzOBtzJICFWTLoLLtF2vRa+lQaQg+wEETXNyff7wqXKnFVRfPzUFQxZGzsE1YYWW5K4wr5MBfAv+2W4+nZva7b0l4evjMGKKUWELkaoNcj4PBJORMZ153ROpBf7cJ02Ko5mmfAYRtmM/t3wPDSE8TFXF7tYeJmywYRR6240ky8JlAla1d5WV3XDXFXiiuWpB6Fe5pDrkPEUM9bVBZjFqV+otWmPm0HIIeszHcDqu5Dv3kxxve6KEqUDTXMbFY++WvNNZSKF4cESj+svEwwZ3FmIm1xRczzxlO1MQIeBh3mbNYwEbVZQlpPItlRmRufQS9Q1/MzSiR0dVQHV2aWCjZN8GGPDsa3dTpbq93Syf0NuvOSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No one is using it now, just remove it.
> 
> Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

