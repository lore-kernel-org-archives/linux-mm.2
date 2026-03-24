Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C38F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00456B008A; Mon, 23 Mar 2026 21:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7206B008C; Mon, 23 Mar 2026 21:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14556B0092; Mon, 23 Mar 2026 21:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D12616B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:28:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D0A18D843
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:06 +0000 (UTC)
X-FDA: 84579220572.10.D98BC4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 739D3C0006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3PTBLJ0;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3PTBLJ0;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774315684; a=rsa-sha256;
	cv=none;
	b=H7QD6m8+Lt6nmJigoAcEYNU00l7f/HG7Hq+ZGyiukbUbw11EwS2uSXgRDb0acM6YKLZwN4
	cG/YCyJ+1TxnIW2JHEBE1Xhj899QZXfY64zShH4vkZ6ThMK6/rY7GuUqZjbae0kiuivN6G
	wXfd9P6Mf34FeLOXo65z0OlQaxrD/Ig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774315684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9W6C2wndGxrXgeZnxvLYkvGJqC0NdVEBx/IrMDn4bPA=;
	b=bK+5iyAsPeGOEbIsSU/imqx+8oyRa+C6/wlL9itIlrYVcn8ZOtx6k3RWWd4BNRO8CntMJ9
	SqpGmyesu6Gn+XsQB3kci0KY9+sND4bKyCR8o5DlEFzV8EyPatdNZk9K9/3Shqh0MpLc/t
	pRxObSvd9G7xDMQPOAVl3FtJ7m4B2No=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C81C40DDA;
	Tue, 24 Mar 2026 01:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630F9C4CEF7;
	Tue, 24 Mar 2026 01:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774315683;
	bh=eqylb9ckWMaPu/WMDobYdxMaubmdEZF8Q47h4e0euw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3PTBLJ0tr/5dYtdejvyq6qK8nICiwmTZHdSARl+o1UpwOhCC+s7mKbJO1Yt97vKz
	 Nq1n5RhECGqijkU7Rk3VMoPbTvOL8cird4Uf3HkW89QCtkf2q9A7hC+pzPlfmHcqW2
	 r3FRk7Vvy72XfrgsK5TO/O+HnDhPSvsrdSrL54agk2kSGVuDxl6QUKRJDu7Hv082Zp
	 SxX3Moa+TmVkHUs69d88pXfyeB5qnAgQJ8aFTWRI6bUOpxZ6G/ajOXnezhaLY8hftM
	 45fdm5Vn1WrUAsBHm4++i1fCK5gzg3fL7RL9Y4wEW6VIUf3QERH8XhCdziJ/p1O92s
	 WlL61576BGggw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Mon, 23 Mar 2026 18:28:00 -0700
Message-ID: <20260324012801.42930-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 739D3C0006
X-Stat-Signature: dawiino1mitbhrqzs5iu4yxy7xzzg9z3
X-Rspam-User: 
X-HE-Tag: 1774315684-34061
X-HE-Meta: U2FsdGVkX18rAzbZZljbQoz2zUpO/xb62i+W1+uCTambXcW395a7USqr8NXndrlffhHPPf6CQfoa7gCAbCg9WjqUUal7U79hGzwEWz8TDK8H/E7L36qQ/FVguiTcjoApBBfquwmgyHO/jAx/NNpGx8NTNYKp2sTkn5AG4XOL3EPLMNCo66RArbGKC8/nWPRNoJsDQ/nVd6qVKiScb1owSW2dAb/Awr83OJAyTb+AsTNwbbc60jgLhja6n8gMy+37TEPgcdrFwPty2TvX6czp0+u4EUA4VRF3qA/kjlEEWuVmzOJHQw3MSk4ElcqDvLGudLWYL4mtVN7iDt4I4XPCur/tQvHzacyKZQx7w4hIw1NM+WjzH/HeTv9Uw9Myv09NcAS6gozbiZTP9d9tZyRJPmJrvLCRdyhVH5iTXrA3Dcup6eTk8F+82xitKhZOjAfu4WkvxGXROoKQvwgr9kOR7buARvh3Nn5CMyJ136AyaqvVcbOsYfJjftzwAyvj3VOIXBoqBFWkwAoctE1BbETSpH8EEbOrz75FhFfUB9kOCIFT4E3+tPYf/q5C2IGMNLoahTlFCkZE2lE9my1NjqZ7QtDcstLplm6HeEkSqgEXwW60pN57U88tL6PIS4F2E+sE3pNi4nFoc6B92nqi6eWBuGtt+dPri2JvTqXfaqXE1vtfoZ6XWQYkIio3+YbbOAnRtMsVTRlW5UE2KGDU1rTb2rs9tGCL2JP/oGlU/dMHa6Ks//gtM4xLXJy2xMAxtowJl/9W01BixdXCpa4vQ941v47IP/qFk1Iy6GMBEvcmn57swaoIjYyy3MqfWIJ4/UqSFddgtikRPFVCJaJjlvjHgLV5SKuW7Ms7FSbeyf9SmQB4/H9CUey9UcYRE73BSVGU1s90UW9B4pB5FO0QuE0fiBrZ6pD7s5Hw9UFggPENv4IwYNL8Luecxp+1KKgdc76+sjLtpapWLnMInnzYDT0
 /9Bstm3j
 Qsixi+T7xKzh5ewVFVncjzVxwtZtPHj0VO4C0FUxFKcSCu8dQ5WgrfYh1MNniLWeeXbP37B0kKK1E5HoyJlUpm5Ha8RiU8+/59povjH0k4czL5rafl7lv9rXJb24GvOrpGaQKJ/eczxtCVIlbv+7U3kTlHO0BxzWTT79YeKHcfqBuKlDFpEUaqFlanwDpnIgl31oTYT5rlL0XDhTixcEZlMwWrW0bOitGkxmhtphx0Ve4GpOR4mv/iFaKaiCTvCygVHSk8MCX6BLEa/lZqJyv/lqBTFlIlibTpqWC9/5NcGU9reL+mqXPIbQz941+czR4c+L7MPCXZHSvGZ1VRPydA7FAUSEEBwa3lu4LpF6/bIFehio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260323231538.84452-2-sj@kernel.org
# start of sashiko.dev inline review
commit 011f7b451b6e4a657677ee09eada15a7980e8480
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: introduce damon_ctx->paused

This commit introduces a pause parameter to the DAMON context, allowing
the kdamond main loop to be paused and resumed without losing its
self-trained internal data.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..0ab2cfa848e6 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[ ... ]
> @@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
>  		kdamond_call(ctx, false);
>  		if (ctx->maybe_corrupted)
>  			break;
> +		while (ctx->pause) {
> +			damos_walk_cancel(ctx);
> +			kdamond_usleep(ctx->attrs.sample_interval);
> +			/* allow caller unset pause via damon_call() */
> +			kdamond_call(ctx, false);
> +			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
> +				goto done;
> +		}

Since this loop is located after ops.prepare_access_checks(), kdamond_usleep(),
and ops.check_accesses(), does this unconditionally perform a full monitoring
cycle before honoring the paused state?

If a context is started with pause set to true, or if pause is enabled while
waiting in kdamond_wait_activation(), it appears it will still execute one
complete active sampling cycle. Could this cause unexpected disruption, such
as clearing PTE accessed bits, when the context is explicitly configured to
be paused?

Additionally, when the context is paused, kdamond_fn remains in this sleep
loop and skips calling damos_adjust_quota(), which means quota->charged_from
is frozen.

If the pause lasts for more than LONG_MAX jiffies (e.g., about 24.8 days on
a 32-bit system with HZ=1000), will system jiffies wrap past the half-range
limit of the unsigned long type relative to the frozen timestamp?

If this wraparound occurs, time_after_eq(jiffies, quota->charged_from +
interval) would evaluate to false when unpaused. Would this cause the quota
window to not reset for another 24.8 days, accumulating charged_sz and
blocking the scheme from being applied?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260323231538.84452-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260323231538.84452-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

