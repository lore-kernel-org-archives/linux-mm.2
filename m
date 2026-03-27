Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0749210A62E8
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0916B00BB; Thu, 26 Mar 2026 22:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691916B00BD; Thu, 26 Mar 2026 22:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE526B00BE; Thu, 26 Mar 2026 22:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46E206B00BB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09CC613C39A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:50 +0000 (UTC)
X-FDA: 84590227260.26.A84BC81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70022C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2jC1u1g;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2jC1u1g;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577748; a=rsa-sha256;
	cv=none;
	b=CjWIo9hvSQyUinie09lJbpo9dis/Lat+0ClBHULzW61w/8nKncxhE85yIIbTQ3tKDZQDqH
	nUpTTHmeI2lXxGJrtJZ4Br6HiHC2A4d6lcbYAYXVOL96Yg5rO5GtIpzyoRi1hd1U6pzXbH
	IxYY6ZRkY+mdrw16ymaXI2G155vFKnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR8HLkDpI+j7hG/wJXYTbe4/7zGDmOtGplDS3kItqpE=;
	b=BEdmMIbJPr8/LMV7S/74l+GV6IDnbCMRLgAQhHaxTsDVZAXJ5m8LC8fIKmr+Ld6I8SLvEy
	owkKfrb+3y17fN4PPsmfIfHzd+KMMN4V0WLL0S8VzdGMmiNDOV9/r68GAzoINRevBxdi8g
	1UnvCUPemNzI7zxnDWfoBAhmZGOE768=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB46060128;
	Fri, 27 Mar 2026 02:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BB9C116C6;
	Fri, 27 Mar 2026 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774577747;
	bh=iAZCC0jak100OlBn9OLxcx6Eaf+7FiXRyV9AXruRfRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2jC1u1gck+ljBf4h40oqMRwlJbkMC3F2h5tVxzpwEXS5jZAFJQgA+UGIJVNXtypI
	 zlW8ybs1wyrvlxpOy5wr3MrQFnM6p0sbYKaU7zHnPXec8gE9UKYl205ZAja6damTJ7
	 R8IEsbvfxWtaD246K/qJy1tu5LECQ2bqSvd5p49/8Nm8haauxGPGs3rvI0ATRwYzm4
	 76xmH965FsCTSUkxS+h+oN5fTPtoOr+WMIICC0in8KbbTbfNA693PREkRlY//2FH8K
	 5nuDBdz246QMecQ+5ZSQz7ET69Cm5pk4gWk19ZwwU4yLiqTBHUSE8BLdkzuZTuTrPF
	 De6M2TNVWVlfg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 19:15:45 -0700
Message-ID: <20260327021546.66441-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327004952.58266-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 70022C0004
X-Stat-Signature: a4h6s5g1f9cmaz39thtaofyayopykswb
X-Rspam-User: 
X-HE-Tag: 1774577748-235036
X-HE-Meta: U2FsdGVkX19fdkoWUAXDmJjuRk3a9J4PfkuXDHSPrljaNh9ndUPUX6TxKeN9TmTNbGFcT29ZhDrJ2jt7Ll1xGyIWdXaNrN02kaDOykiHCgTjwabIXaV7LKAjt19j/5UNEYD+/7HA8mA5HkzkL/9xmAB4qIyKq4hOy8HC7yoFfz5Sg4DwcShejddzjsiGn0UjbaG8aEeqbfYbp2Qn2KSgMv2BfVm0Jb7qaFPxywxL5Gs9ZRrREzSfDr6Xtm8l5Wgl/o+H2FjmGe9irBn/YJ6QQE7E1akMeHNtwI/aFdxpXCSH9pZ1Ydo0MlKG44qQ+y0L0BQfX4K5fyi0ZzmgkZgduyUzS53xN44c8p4uNAdw3kvJ/chuqJenA8UH6WRQgbJNFydkC3yea3pST7scuVsbk1Lxz+8U6tEbyTpRpbt1yzQLAeDIKC3CpRKwhSro0feFbs1RbBujckjDcSBj0YPLEceeResv/TQ3Vx7exFZhN3hOAYF5T/YdT0USDJ2XxX3G2TqAykge2k2KspZuFyI0h4ax6bFN3qy/lk1u1kvsHAzcslU5lXRvsw3cn1Sv9cT0lX4ePNmua8nd7oRBwsSUSoD2ry9kGcU38Hu7B3EcPXYm/MAc0zuMJRNS8c6QK4qGASgo6NAyTCDbOQf4m+EHt/Juy+zkZcdhyVuFYDl53oiY6dzMUSO84jVfN7NnvlLWhaPDsedzAQ31Vk5b8C8Cc7FHFgaCAi4k0XRJNR/mo/j98eoiG6ZOwmX1HGfIHwdYIFPglYp0YjRHZYjy/3GB7Fqp8EymIFvmhQIJKyvGkl6eMhBwYhizvNzjvkwrdmWb25O2xtxhvPWeq17u9QzDUOd7B3XleF/MA2zT+CVHFlKzXnJoNETYm6M9jieRu+2Fp3gcNBA7RMhGidHz+bO5u4X36d++UL/2p+24HDpakejTEZ+A6vykdKvOYliENMqYOAQXW6jz4VfMp1bxmdb
 dPq1lUhO
 NjThA4cQFaMkfvLGWEPdtFZFKyKlxOjnEtLNoYxTM5h5luCGHRM6fSVbDW6KgWr3pg+TyoaIB6OeA/UL8B89EuFW4U3dN448kiQ58wLcyRwlo984E7xI0hWw3SISBpusbm+PI1E2zi+T840lzrCW8BERMsF8oNuT39f+c4QtZAlbJ6Kr4kaNL2GYPJnRhmgM+qWIHmbJFA2hg6lX5uhkFtv2mWkgH5YGxAYbaY8LLabB3nKSNNrvv+cRyKxEV/ll3VpjmyQz5LhUn3qa1tTkY/GwnoiA/O7HRjNmma8SIQnLLL3zHoxC4pqd8IMKFdeMlJ2a8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260327004952.58266-1-sj@kernel.org
# start of sashiko.dev inline review
commit 36b78ee39968830aca3d375219a2cfce73d0d1d0
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock

This commit fixes a race condition between damon_call and the
kdamond_fn exit path that could result in a deadlock. It introduces a
call_controls_obsolete flag to prevent damon_call from waiting
indefinitely for a terminating thread.

Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -3062,6 +3042,9 @@ static int kdamond_fn(void *data)
>  	damon_destroy_targets(ctx);
>  
>  	kfree(ctx->regions_score_histogram);
> +	mutex_lock(&ctx->call_controls_lock);
> +	ctx->call_controls_obsolete = true;
> +	mutex_unlock(&ctx->call_controls_lock);
>  	kdamond_call(ctx, true);
>  	damos_walk_cancel(ctx);

Does damos_walk suffer from the same exit race regression that this patch
fixes for damon_call?

In kdamond_fn, the thread termination sequence executes damos_walk_cancel
and only later sets ctx->kdamond = NULL under the kdamond_lock.

damos_walk appears to use the same pattern as the old damon_call where it
registers ctx->walk_control, checks damon_is_running (which verifies
ctx->kdamond != NULL), and then unconditionally blocks on wait_for_completion.

If a user triggers a DAMOS walk in the exact window after damos_walk_cancel
has finished but before ctx->kdamond = NULL is executed, wouldn't damos_walk
successfully register its control and pass the damon_is_running check?

If so, it would then block indefinitely on wait_for_completion because the
cancellation phase has already passed and the thread is exiting.

Because damos_walk is invoked via state_store with the global
damon_sysfs_lock held, could this infinite wait block the entire DAMON sysfs
interface for all users on the system?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260327004952.58266-1-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260327004952.58266-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

