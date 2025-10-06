Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9A7CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 01:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57FF28E0003; Sun,  5 Oct 2025 21:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530E68E0002; Sun,  5 Oct 2025 21:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446728E0003; Sun,  5 Oct 2025 21:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 326448E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:39:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3F981A0405
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:39:56 +0000 (UTC)
X-FDA: 83965983192.17.576EC79
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	by imf09.hostedemail.com (Postfix) with ESMTP id 364E2140006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:39:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf09.hostedemail.com: domain of wangfushuai@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759714795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4lQlM65BSIysXlfuvtZNenZVO0NhnzEyonAcFbpKiR4=;
	b=Js23xZNldQ5vCwPbkMgCUEIZe3CRZ4ubf62yRZoIuicp3Zqe982+5/Tp5J6BM4xy7N3PNM
	SwTGetAhhlfWpdSJQpvgEmqOieRzsDmWPcqYjYgdBrGY6yZ1JTEfLVdFKTL2ed2IJRckMP
	fcj+mLZN8zVBZkzQD+ZQl1e1s+4p+ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759714795; a=rsa-sha256;
	cv=none;
	b=ipatK3yVDKBbARHrBVznRnsRYn0/zkuxlaTLjMtyXlFVV+BEZpBEJ1rWKPLmQTa+K0Dm5f
	GyQ48nu8EtPALsa2YGuI8yAnsDeNh2j/jfxgDhsPcWpsQ+ElCX6IPmzvPvdVi5ZINtywb1
	HlPURHkBbY/K6UHowGv0uqZTX15uPA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf09.hostedemail.com: domain of wangfushuai@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <axelrasmussen@google.com>,
	<david@redhat.com>, <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <mhocko@kernel.org>,
	<shakeel.butt@linux.dev>, <wangfushuai@baidu.com>, <weixugc@google.com>,
	<yuanchu@google.com>, <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] mm/vmscan: Remove redundant __GFP_NOWARN
Date: Mon, 6 Oct 2025 09:39:11 +0800
Message-ID: <20251006013911.43917-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <aOLfOUgoEskd8jyE@casper.infradead.org>
References: <aOLfOUgoEskd8jyE@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.72.11]
X-ClientProxiedBy: bjhj-exc2.internal.baidu.com (172.31.3.12) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Stat-Signature: 1p6dkso5cjtod78n1in71s7ndmgnba8y
X-Rspam-User: 
X-Rspamd-Queue-Id: 364E2140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759714793-593881
X-HE-Meta: U2FsdGVkX18ge/tNM41117UrHO1F9H80XTSjOt/fjxPBG9C97XCuNQfP0WJnFQRLGUZdjxKzRkCg1kEnDJs7xzmj9qyLBVWT+TM3kZmQicdGM8FVVbNHVRg0RIgzuvIq4vvd5pqHihCqGIdWjQ1KUvJ7XDxCEQB8ZO3774Wo4iF/q8ed2p0jWiTeL4FDDXyFMrMbnoDgzCjTv4HbC4UwS/thh7yGtRaPwpidqWy7H8biW90VDAw+SVAmnst770nOZsYwD6/akzOvKsUEHXP358p9x7856n4ZjEjFf765/5lnhNizZxhjjOmDFtIG/MIG5p/ar7I4zay2H/IS5II1j+cmpkwZuqbXx8JiUok28/sc48XU7mAYLmIAG3ql72gJ6zMf8cWUhtXHlUdUlIPE/hUfR26q6gwqyAH4wsRX7stxE4vWpwUtqDEZc3IAQs49V70N1mAqZAc5e/wVClMOnr4Ou8SDz+UpQNp+2y+gZC7IE/Tl6XL8GBy7e0QvZkuv2Zdks/bE7u+sy4MdPyYv72L0d3sjvU0Eh63hvxJvb6UScyTXHgufPgFjBw+vmqp90CPrL91y9Yt189Ky+Q9/DsS+cR3GWKFwuCfPRWHrdW7CGcaqcdtkcqTpI3H+mF9GI/U7DWrTVOv/ueg1qin0wgF+nqiF/snkU5vu2Yf1cuVbmV2S8ptlB1jp5LA9elyzUbrmHQICPcYuPVcnwk04RQbZZEUAbcoHuS4YotoP0sN8s7epJ93+e0ern8Mb4WV49ejDnWHU/zIW4JljzrtD4p6A9vZYic7Ibk2f86GqYC7PSx3BoE7ePZFznhAhDTuVPQe9K2aEhcOj0g6BX0xpi98EJbi9pUETWLjOe5GCh2ZGuvRW9HSu5g9UZ9frZnsSaUG/TOuFlV+bkLyOOyhMk04XCpUzJsdcOzChCd0wUo/9mPXlFKUtY8P0yiIo1LebIbL/312dT0epSrOhRti
 +09mLiB2
 8HWdt1XhZHTK8Wq4V+nS3Mmu3JIwV9GI7q5+8KnylwYbKg9EiQqAJ7KdcY/64b46WNB/VRUBfJUa4C5WhmnLp1Eg7vNRs8PWx5xkf+Ax8KaG8J1Yj27JB7PSTK/Pigl1x27uSZB1yDnTxNKgIrQtlk+WMRtriAgLZBCzc1QKvaef3E2E2BrHrNiH/+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> -		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
>> -			__GFP_NOMEMALLOC | GFP_NOWAIT,
>> +		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOMEMALLOC |
>> +			GFP_NOWAIT,
>
> Please just remove the NOWARN.  There's no need to reflow the other
> flags and break the 80 column limit.

OK, I will send a v2 shortly.

Regards,
Wang.

