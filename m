Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646F01094498
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7016B00DD; Sat, 21 Mar 2026 16:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97286B00E2; Sat, 21 Mar 2026 16:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD9F6B00F5; Sat, 21 Mar 2026 16:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A997F6B00DD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:12:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 597DD1E23C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:12:14 +0000 (UTC)
X-FDA: 84571166988.01.96D5FFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B48DF4000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:12:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPACzhOw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6oXLQpnb5AArLahHQBOHt+yOgs49bjSv9fwJmPkApk=;
	b=O+4SUSQh1N+Jr4vxUDizHLv++6QNjUB4qULFthosZNv4eA5gtpMpGiGHVHAcOpSkRwS1yU
	HJlqMLiWIHh78ovX/O9aa5QjK0gOMpRXX8+ahaf6tQiXAYwcevLXXuHjGHQKC/xhLIZZcT
	JgNfK7MLZIfdolnTskfsJEKEO0VqZqI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPACzhOw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123932; a=rsa-sha256;
	cv=none;
	b=ub7cUSHjoIHQYtL2adgwgdkkh9jdneeeED0Vu9MYOs1sppdpe3eC8i3N0V8Kovm6Tc+z+5
	z1BDbwqChIqKTF1tV2QmWB7KBi6ZFK9BM+beKV1VNxd/tDRSeeuOrhuOFuEeZX9xoMn4g/
	Q5aW+iK+iL57+iY6gNWLokYQdSLEMpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA9C143955;
	Sat, 21 Mar 2026 20:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EDBC2BC87;
	Sat, 21 Mar 2026 20:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123931;
	bh=cl5skSWeXYfzEvV3BWZZ553P3t0zldUQcyJLsloSk8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPACzhOwayGfROGLOQrnGcwVSK9GpewHA+L6cnyAh05hz3fKM5XJ+I/Y30u9zt8oG
	 4SK6ghNvVsilMP/PhK48C9v7N4iKlyPx9JsSKpE5+erUzMjXP5VWeSf3HdC4tzBYLd
	 XkD9ewcg+BZXYRoBvfeYEvi6JpS83adxzjT486L2uGJ0+q+EE1jnnDg/6cLuQJhHAe
	 iclYoJt9oiQoaMjfBDMbXkGcnn4NWMXEQMcBBx5JLcTaeW3gcGrw4vf2i5UbZZ15aJ
	 8PzluNJ+zRQO0prCzhMxGc6IvvIqsPxKQdnV0n7+3x3Nz54MpS64DUkvtx0XGp8q2i
	 Sc03nhbJU8jpA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko) [PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sat, 21 Mar 2026 13:12:04 -0700
Message-ID: <20260321201205.95756-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B48DF4000A
X-Stat-Signature: s5iwm9edxoztbsu3oc6szbpa9go1eqma
X-Rspam-User: 
X-HE-Tag: 1774123932-494331
X-HE-Meta: U2FsdGVkX191AS3/oOwIeWZxKjAi8g/U5aRBNkjLRj1zXkMDDxDHYuFh5gjhuEnX6C3DdqLv3EM3JBsoAToN3xe+OIyoodQAeOAikQ8Bcp0UoIz1ISHJzVFbcVgyUMckLxILhfD7+NEjs1Ws9KhRb9qJ2RH74Sg/DZWyWPQ8wwjz4EM+3JL1LY4snQmXG5OtgHPAIQmbubxgUQ7ZsTAQGka95/OXH0+ZDOm14hNLAJdRp+a8EBiqFfBMu3aj7b+ddzcihtk9QCwaMwiP9USkWXPFsai1w6YzpAL3jpWbFCgATnIn40Gg3dZ5Ge41OHj0WhmKCHQOAdN1PkhkTLvgZq4DLS/vZMysB1bmRr92Cfa69Kfs+RJ4KJSMKEWuBuCIwnqx6Ecrv1LvUGU75hLJCBMNsRqG6R72zJmBC5TDI09vY2qqMNQL+/8hnKlmWOLH9xezg13x4zDtXFWQASZGHw19D22Q54XP1utskkPZLCG0W+1KL1adupg8Zm5cc4VTXS6PCnNvhYIT5XRwgXgG+0V0x+xjWC9ObgYODGxqrDRlZOOPYwxxB/CsBWl5I7psgr+fmEpEUMlnqKTHtMFlidpPpHrXRFLycy61PIFkIATClS+Zlxt9ngi4HVSyeoUsd7eQDrWrDUWikQbSCYldIvRb+cl1TlEM7lb03ee4AHVh5Ew0wDbzYrvrmWwRWjJ7/sTKxuGhoRH7CptjqBwVfrnyL7kevqttiRtFzBSTM5HbRITD716EQfJJwsU641ix5KGyEkhIYPmun/r651UNC+XSvFQ8GjCe7rnnWFyw9KymiloSlygcP1QN6XEzODjXrKMu9XCHoh8ksWntmR/EoYCzmaCMudiiCuLskoomJADV5ds49luzW8CsXo6GlhByyrvlOAyEAFE2oywTvaLyej1IbvF0npmuIDjxCG3X9tucw3ZeIhBmWxYqzWGNsUL3uO4/JRs3umvXiKaAkl7
 RJ/0hW5r
 Rpwk0dyBezlqXfMPp0Xm9Q1Ah2bsNwKIPVxb2hCcpcZ2T50j7ROWqL+AbdVjMT7pI9GLy8La2OXZ8sFLFGk5Z/ejeoQU3xqUPPoJro/OVwbQHvJlHpeNFRNN1VmxfTZJfLFw4tFWFdlHgclVxKZc0/eLJnT+s9uv0P6GQra6DlF4DeOMO+NZgPcHP23Ucs0BzAF3sbZxUC9n+xA35UB+39rT+fUij13AvThZ/G+jlEtDEtZG4oD1P7UTf1c2blY4NnRRrpxTrARvJk5uqqtCfRMCv6ULi4QW1QcROUhVpgVw2Zhbif+/NmLr3S/FoTSxmtVKTiI8URu2TNi/U1+8VLxpRtKuavL3qhm+9YYxcalZD8Z4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260321181343.93971-2-sj@kernel.org
# start of sashiko.dev inline review
commit b56d17c42c1dc6d883f3a75d785a05ba53b5c35b
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: introduce damon_ctx->paused

This commit introduces a paused parameter to the DAMON context API.
It allows users to pause and resume kdamond execution while preserving
self-trained data. The main loop is updated to perform limited work
and sleep when the context is paused.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..ce010009ca13 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
>  		kdamond_call(ctx, false);
>  		if (ctx->maybe_corrupted)
>  			break;
> +		while (ctx->pause) {
> +			if (kdamond_need_stop(ctx))
> +				goto done;
> +			kdamond_usleep(ctx->attrs.sample_interval);

This isn't a bug, but polling with kdamond_usleep() using the sample
interval could cause many wakeups per second even while the context is
paused. Would it be more efficient to use a waitqueue here to consume
near-zero CPU until the thread is explicitly woken?

> +			/* allow caller unset pause via damon_call() */
> +			kdamond_call(ctx, false);

If a parameter update fails during kdamond_call() and sets
ctx->maybe_corrupted to true, the loop will continue to run or exit the
pause loop and proceed to kdamond_apply_schemes() with corrupted
structures.

Is it possible to bypass the corruption safeguard here? Should we check
ctx->maybe_corrupted inside this loop to safely terminate the thread?

> +			damos_walk_cancel(ctx);

If kdamond_call() processes a request that unpauses the context, this
will immediately cancel any pending or concurrent damos_walk() requests
before the loop condition is re-evaluated.

Could this cause spurious cancellations of walk requests when unpausing
the context?

> +		}
>  		if (!list_empty(&ctx->schemes))
>  			kdamond_apply_schemes(ctx);
>  		else


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260321181343.93971-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260321181343.93971-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

