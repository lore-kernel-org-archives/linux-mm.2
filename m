Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CEDAFC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8546B0092; Sun, 22 Mar 2026 13:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A323A6B00A0; Sun, 22 Mar 2026 13:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920566B00A3; Sun, 22 Mar 2026 13:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D75E6B0092
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:07:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09E9F8C61C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:07:11 +0000 (UTC)
X-FDA: 84574329462.17.BF9424F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AFBD1C0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:07:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qjBOEJQs;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774199229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZVR0fsD//XKLy2blc64ZpK4uTlshC+lbLyZAocZReA=;
	b=sDf2s+Bcpb32RfpW58pL6LcphAR7TCm4hbNdqT9SUnrtlGTESL2eJQ37Ob2nJkCj2MMtMf
	PWpJ93xwMrKvRguQGvwTwjpQX1IpB6ENjaScdN/CWycB81Tq+hhb7Vz4uWzFGoGZwUMQ2L
	YyI0MBUNWYwyc0WyTUWDQhuvb0k0wtA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qjBOEJQs;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774199229; a=rsa-sha256;
	cv=none;
	b=BakrijSbALeS9IPOx953nUOj8AbfdshVVUgMCYbJb4IkWm7eJ45qdWk3rZ7K9/Q+WQBG5P
	KYgk6Fw9+SWZdvtNo5pQfVA7DPRb+uxmvEh1D0CLiIe0oHspoRaThETu+btXMik8d1xmGy
	pM8F4qF5S50lw6+a1mBh111E2w4aD4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF8D460103;
	Sun, 22 Mar 2026 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BAAC19424;
	Sun, 22 Mar 2026 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774199228;
	bh=Ss5BI9ZraEpcbTh44hxtWEqyuu3rnCobU89l18kEuAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjBOEJQsea7kiJPdwi4VppT0vsqbwLIf8zzl0dh2dZPd+7AoKsvWIjyP3+dak/tTQ
	 X1gS+SWAp7toHMWxQ9X5hKUGKsRdrYJDZiz3hTaDSbX5dv6Wwzsv/oOqgSwv3/50tN
	 FQE14urHdHLjjDdTyJ1xUF7w19eIJyXLAAvrQECxoONZRowUMf5QopYSQA7asnCHLM
	 iBTuiTQ3tMLcqf1FliMCSK1yQA5mI6q9o25SbH0ef5Om7wV2W+5G/Sk8ukUwNKgXDy
	 nML0MwN/tDJICImBdDc9RGe8i60y++2r0HC9e2NFilTwW8zxhzqTcmR8mLmOI1c0Ve
	 /1r9pYrfU55TA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun, 22 Mar 2026 10:06:59 -0700
Message-ID: <20260322170700.83123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AFBD1C0002
X-Stat-Signature: fmdp9f9h3jhejtutgjq96m5eii45d6qx
X-Rspam-User: 
X-HE-Tag: 1774199229-228810
X-HE-Meta: U2FsdGVkX1+Iadwe8cbHkBfXe9Ys3swK4oBjiV4WfZ2J3DhprNg5S6OxhIzsiPVMmoy9T6u5tJUzx5uX0JNl1gxdV9HfGohezx0t6Icrr3bSOFkaE1gf7SfvjPvHf5bbJSSC58GI60lr06ep/7EEGgo0EXC3gaeI7+hIRoRT4yyYpQkZP2hVwP6D5stbfYRIro9k6Yl5Pg1tQSMkPlk8bdhtxN12k8IGDfNY3dIjGfQXJm85YXpZL+WLZXDX1xl04FQlvlWGM5BqqEgcrIjNm3oMMKsoI4xJd3R7u6Z/HwwqVNuNZ3nStEpaC/MZBLzQuuwTZq0sxNOxqlmXCmq8aRt5WfLIDKC8+okB6qVL5b3YYF2j6WckpNxRMP0e/6hyTsXj92PmNd4ahBdy6n7Wo1xDIDCPFGZLnzKSIad/nEh8EiskLmJD/8U7OHH/PigxaA1+Bw7caZZXL7TrWw3Pc9jdpDxBjHscuQkn08+MGaqTfc6WMsP5k6i8OVIGEH4ffnSt4cIB0WudUUiKTm6xRq1Rw0oG455ygycrNAEt9veXQPpUqy5w+1xs2h8thJUxvLPZQD41HwlUr9RauM7ImWWtsVYecuWZ3BxyZ45jgfnmzp0Mvdfx7skGGZSUJarTR22zMV8cu+1aHotFi/OpgWj3Ck9IsDomlqsQtlm61/gcFJnOifYJTYf2TIz1NoDuujfp0EW2a0NFXoophR4eC8Ro3Q3O7hj//EBaoeDEOvT6OBBgp2/2fhXOO0tRQs3UsJZbeB4eg9MlBOjae/P0aLZuWZ2GNbmSe0B3Zs8lc2g2cf+/vqrLoRE7vXIZS6jDLIjHzs8k2JHQxHQd2wuEZgsL4johqJqAKYWhY7REfX2tSoPFXIH+nkEbL5Y1TI44NNJfM0FDGixrjFkqc4+cDmCykwbjqihiVmBSHgN2om9MTQ8Qb+Iqng8aO2qQocrjB3GVVjIz1nxBV3S714M
 2BIkr+JS
 UyE1Qc94ORpZTRjv1i5y6f2b6bpqmVhr+NOS4KxFWxPwgZxc1qLxN4ZVtqf7LiEIQdPplx6bDypUaYPiq0kVATPbUSZEmtD47GBPUasc45QKIZYOiCzMiMTuw7NfWs+R2ajNPKUINKzaPQ1w2FfwRSBrVnwPdWjsnNzhBg/Vo02kU/aM+y6sD9n9rVBa9Jmu3HeAikU7UdLK5Tu4W9y4VbI1sUDsaFYrF6Q4v4v3qJg/wpkMLhJhMFWOABFfEDYorvVGyIbxYs10cyVx3DhbHqauZoU4mm9Lm7eJ0hmvcfdcbPtuoUAhQhVnJroHgTQnpySW5vFpOn4WHllWv1JLArK7cDzo0DBkfSdW5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260322155728.81434-2-sj@kernel.org
# start of sashiko.dev inline review
commit 2a3be2c8b6c327ef72163cd54e6121ef72b9c932
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: introduce damon_ctx->paused

DAMON supports only start and stop of the execution. When it is
stopped, its internal data that it self-trained goes away. It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

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

Is it safe to repeatedly call damos_walk_cancel() here?

In damos_walk(), the walk_control_lock is dropped after setting
ctx->walk_control to check damon_is_running(), which opens a race window.

Concurrently, kdamond_fn() calls damos_walk_cancel(), which reads
ctx->walk_control, drops the lock, and completes the old request.

If a new caller invokes damos_walk() and successfully registers a new
walk_control, could damos_walk_cancel() resume, reacquire the lock,
and unconditionally set ctx->walk_control = NULL, dropping the new
request?

This might leave the new caller permanently deadlocked in
wait_for_completion().

> +			kdamond_usleep(ctx->attrs.sample_interval);

Could this result in a busy loop if sample_interval is 0?

The DAMON API allows attrs.sample_interval to be 0 (for example, when
tuning is disabled via goal.aggrs == 0).

If sample_interval is 0, this invokes usleep_range_idle(0, 1), which
sleeps for at most 1 microsecond using an hrtimer.

Since the normally expensive monitoring operations are bypassed while
paused, would this cause the thread to loop almost instantly and create
an interrupt storm?

> +			/* allow caller unset pause via damon_call() */
> +			kdamond_call(ctx, false);
> +			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
> +				goto done;
> +		}
>  		if (!list_empty(&ctx->schemes))
>  			kdamond_apply_schemes(ctx);
>  		else


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260322155728.81434-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260322155728.81434-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

