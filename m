Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4BF10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456E36B00AE; Thu, 26 Mar 2026 22:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E976B00B0; Thu, 26 Mar 2026 22:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B3E6B00B1; Thu, 26 Mar 2026 22:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 297926B00AE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:53:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABC418D1DE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:53:03 +0000 (UTC)
X-FDA: 84590321046.16.9C05223
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id D57C9180007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:53:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PXAaFnb8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774579982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kr0LYegzM9SyOdxc/Sv1ojeW/APc6NsbtvDQO8qzz0c=;
	b=x2hBB9o1bkxI/Q/cpYqF9JWk5VsA3Xsnvwz7Q4cD+ho5WtMGJrHfay1yUmCsWS16jiTtmx
	KkYxtgR5sGOqVdT16mKTl1+xJdAjEXUhGE7ndLXpw/wY8Az2Snkgc9MJ9CEipLZYxb1QR2
	ErFb2nOHI9KoLNYo4DsqST/Xr/jDE2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774579982; a=rsa-sha256;
	cv=none;
	b=F7YY5pQU2M/JF87rI6WreEj2DJbDYS7SAJ9JotmO9JVAFMogezQycLfRIf8fMDGXEOV8pe
	hKZmHTmm8mfsFOLIAtJzFjnxDTnZMOwe3lLUAx4edFpXpJ9vnSwtN9DfsxS4NsKCR0qFrz
	PCDZSv84ebA8coOaNnvHvUEp82o2rkg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PXAaFnb8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <707c7017-6a3d-41ab-ab9a-0e8822144774@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774579979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr0LYegzM9SyOdxc/Sv1ojeW/APc6NsbtvDQO8qzz0c=;
	b=PXAaFnb8WU+WXzWFPpVly0Y/C6FaP071ysUAdIdQOlZWK1K0P7YfSv1ObQICA4oTIEKFD9
	6n3SuuW/UaecMos9zqg86YnlNyCO+1ZrKQoHarnY91lIzY+8hpwMKjGM5HtUi5pREtupyW
	WL4NsdLcPwjpzjDt+7beE1kCTM5rI2g=
Date: Fri, 27 Mar 2026 10:52:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260326185629.355476-1-ljs@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D57C9180007
X-Stat-Signature: 7755zq6wdzithbt6ps1cyb8xi5w46qrw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774579981-962906
X-HE-Meta: U2FsdGVkX1+iNIcHarkuIrw7YaN8yUQa2LPVT+0PCq6GFpLFhHk6TWgCkxpDaOc9kVe0SFzPCdm5AIABCpQ6qDiw9D5Wq1CXDwQ14YFnsmfRURlMzuMXzOfuF2ivV55ZqLTMFzNNEy8VXBTxMgLU1NGBR7ImfgMEX7gxAT7y6MDc4zdmZW1OxD17D2dTJohezZzx4jSFbREov5k3fPA6v7E30TXNapqFaLA73VnxGTxqQNBw4LugYeXvZZrlUzEWqk/v+Jo3c6466vptUYexbCLRBRinRsCsR3ruwM1RAupSKgvBzySIUC2ulVAsrnfYtD8rNUFyxFkU49B3TP3jnBG+0HTIBYpmCiMUVafHS9yD1QxOPrA+phrM8fJs9m3CdFvTJLWNz1eo0t8uREdcgoawSpKw8R0h9jsYi54gS5Wf0YwnWAg+kl8pqWqHaygAca7U2mTXH97Leh24bPTCHO0FRVg7EH5DsS7Qmdj4K6gpmTgx1Y/h9ml5ZrlVTkTJB8Q99rd4Ha+MEBb9Msx5NG0jCBTM6xNufBAJ/umDLHUwe4HKRTaqzZx1Ol/YU6G6samDRSKFj4dROIxkoXIPQerV/udMAZhm+oevRvc3AXVGDyP0KnScbteEq5SQoWde6FnbH9y/I/Z4bUWxBj6x9BIdQ7XPgQD2urfE+l97LMs19QhiNc4xrltVg0o6o61cW0FE5SwZ2vvgFVX+zmvQjFo4EDCyG9agWu/NZaBPOolI0PjbNemkY6cElshtUGoZEBkk2cFLsB4PrSph3c87RJiAIdJco1kfqnZ0gMhXy7bXEMUPRb0RO8oVcpNwsnWDL0VINZbGxKslUtwIMTGeftPIf3+hhW7RBv7pnZh96Ut1/SnGrnBF5xuSR4UV3Seit7LMAM+P5xndTvPMaVik9Tm52OyIyx2TOBUdIlMsT2rrpg3LUKdUJloefsKoqIMRNo1JF8hBdNTYnU8xIQ5
 uNxmL3/b
 N5W5cULlIw4qbdhL1aXSb5vEoeLxB1p6lZ0n/G84w/PFlkG2itNiRIBsaSr1U+rCJ210Z5Eb0nmXBAvOmJo20qWuQCW/xeSZM8HzlKPVuL5PNZaC9/YwfZ6vRSOL9rOhk1kpay+x9Ws6j2Hxr3lwHDIPR3FSdhmP3Ke+mBRBPXZylT0IzmUxUh+TIYfNQGcrnbWUrmMVBBrc6zJQytAwklLsaGk7gL314ywPkniEhYq3peO0KpSOt86t7hl3ClBcjSJVQq56FFzjmqQPlVLlF1sE0HKCPsFJ304fSQEu8VurpL5x5Q9rnkNfO9rek7jlL0VE6zpSf9ShJtOwFNJpHN9VsPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 2:56 AM, Lorenzo Stoakes (Oracle) wrote:
> We are moving to a far more proactive model of maintainership within mm and
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
> 
> The MGLRU has not had much activity since being added to the kernel and the
> current maintainers who kindly stepped up have unfortunately not been able
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
> 
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
> 
> At this time nobody is quite exercising the maintainer role in this area of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant work
> or review.
> 
> Therefore add further reviewers, and at this stage - to reflect the reality
> on the ground - we will not have any sub-maintainers listed at all.
> 
> Each of the files listed are shared with other sections in MAINTAINERS, so
> this doesn't reduce sub-maintainer coverage.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> (Apologies sent first version of this without MLs attached :)
> 
>   MAINTAINERS | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76431aa5efbe..16874c32e288 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16757,8 +16757,12 @@ F:	mm/migrate_device.c
> 
>   MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>   M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Axel Rasmussen <axelrasmussen@google.com>
> -M:	Yuanchu Xie <yuanchu@google.com>
> +R:	Kairui Song <kasong@tencent.com>
> +R:	Qi Zheng <qi.zheng@linux.dev>

Thanks a lot for the trust! I'm very glad to work on MGLRU and help with
the review.

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



