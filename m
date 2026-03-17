Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3677AFB5EAF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DF36B0005; Tue, 17 Mar 2026 00:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665DD6B0088; Tue, 17 Mar 2026 00:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B016B0089; Tue, 17 Mar 2026 00:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44CC76B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:20:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFA531B7F5E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:20:21 +0000 (UTC)
X-FDA: 84554253042.13.1ED4C55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49ACE4000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:20:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYJS9k5b;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773721220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vibg1mILB84EaaE020JVJNzNjuM/FRUWwRt9SM7SUzs=;
	b=JYrj+3RFLBjEVd1BzVPYY2B99GOUqYGx4IEM9uwzjv6ftRIyyTv4bEi07qfRDx5qoIn1X8
	pjRn4+K8zG13XbVi4xz4+zIiih8j9FpNEI2sb3rmCTDh/Eq5eD5SortBxq/0l4J1YV4EKb
	7bLkXFl5vof7MqEiz4bN494L/nAInbE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OYJS9k5b;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773721220; a=rsa-sha256;
	cv=none;
	b=bZdKwYgoRrK94PnYK613APQ2fcxnU7XvXNKKWKR1gIXfd2GtEzYWeMhusRV4dh8i9n74q6
	oawMuWf6N51vsCsxhLzXSMs/ncAgcKyY295k2Kc2HI5NkuwpXx0s3Vqd2T/TweqAqCzdu+
	unTqSeqLcD5+EAOPz73aeSnplm9POhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCBE9405F9;
	Tue, 17 Mar 2026 04:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D12C4CEF7;
	Tue, 17 Mar 2026 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773721218;
	bh=23xGg58bJG78ilar/UOp6dw7ygNrFd4ZTJiNrpATcpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYJS9k5brCcJ7gX0JQ064uktnvzfvajkunSH1JmktVAjJsDRv6pGacksFDukIwFg2
	 bGz1h5FrCaBBZsPKKCat45sMF6fzoQIzplEoYohR5ZJ2y/qY/fjUlrpS14TLIVCthY
	 jlVMC8a0PgztYDTuYbAQIk5ymOICAkHoQ8s7o25IyJS1YgbAIDlJX0WSJCPOA/t1F6
	 vKL2BxZtp+C+VkUEbvlEAr4L65uuKrGQCB2hqDRaU4dcg0KWQAzBfnBxSoAiW/LMb0
	 Cj5tdZ1q81FG1ADI5wEXfH+8s+A+/00aoV8nE55f5iXH0ANEjCVKc3zju1bMbH1O3v
	 GjCOSRjtdkcRg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Mon, 16 Mar 2026 21:20:16 -0700
Message-ID: <20260317042017.781-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49ACE4000D
X-Stat-Signature: gsuc9hb5f565whoy53ocf4atkq4jmi5g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773721220-851766
X-HE-Meta: U2FsdGVkX1/HkOsXwauYcqzERF0JoSbeO7i+RVM6GgE9VvUCdK55gZMKbgB8Pu9pnGbXyN/NTSRlWey4TYH/cS09M+1eI3h9dCetCWPIfRL8Opw0YChDkVJrifg2ZQMlWcZ19OhasiHPTXQKU9/olstefGcNY1URCCCEg1akzZHJTJeOCo6djsoEvPjOuA3s5mLsbi33KI5F2PW4rEsPvhfc94EVNvU3IfVWMxm/Ei29vcpNfLbV8rp2ihpO9p64kSBhRlG0aEwqxWva3+unkzQn45SbXlYlcMmGNdWfqKXXIj6l8drV20Mg1dg+8O/rsx4Ta0u4By+nGT5muhMQe+cl0KY46GpTjjW7csnNoFqbqoKm9aaJ/nIf5tjQw/SgzdKysYaJKj+L/H5GLhkrzY90quoYJejBqad2MazW3Ualm9cmNN+Wk8VNTxg4YQgF8CUuYK9qEIR7Csm1hMPbWUWD200bzA6UNkPiD+FeGLsALvx4fdeP6hEi/QzLhwMoCUsjlSy1x0L6wwwCXWOBFBlCGVujIY4g+uwHQAB6Llr+WAsFLjJ83Aw2b+BUsoqNL/yB9U2G1A5GJYJyZ8+S9Y0JBIo/gIFisjvfzUwNUaCR2NAR3JeqE+IHXXx+eiQnhE4MVSYLMVMU4rjvi5G5R5sKT6ecyUA42Elk3xWBuOllXOvF4bp4htnti+oTBCE8+I0ZyAGjLds/6zk3OLMwNea/LNduOTBMSPTBGUQaH1qoe5phBZ7fC9dhmU+ZMkxNACQF6cc1mlpLfX1j/P+5irusBaF7d7TH/Cdb/hojgWgu28dp+VvR4rGXiR5fVqnHdW/Zit5fwAPU0QjLii5MGNleJ8VN/8sYWuJHSA7lyo3jN2J0k7aYYeINeGQwrkTDRP1DYBqF+4Fxb9wT3gb7y3N+CBPIsY/IoUrW8C0likYubD8qka2X4dWySF/KO6Khjt1dwLaZUzGq8ho2ubc
 GsD0L4Eb
 NXYVl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 14:00:00 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON supports only start and stop of the execution.  When it is
> stopped, its internal data that it self-trained goes away.  It will be
> useful if the execution can be paused and resumed with the previous
> self-trained data.
> 
> Introduce per-context API parameter, 'paused', for the purpose.  The
> parameter can be set and unset while DAMON is running and paused, using
> the online parameters commit helper functions (damon_commit_ctx() and
> damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
> only limited works with sampling interval sleep during the works.  The
> limited works include the handling of the online parameters update, so
> that users can unset the 'pause' and resume the execution when they
> want.  It also keep checking DAMON stop conditions and handling of it,
> so that DAMON can be stopped while paused if needed.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 2 ++
>  mm/damon/core.c       | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3a441fbca170d..421e51eff3bd2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -811,6 +811,8 @@ struct damon_ctx {
>  	 * intervals tuning
>  	 */
>  	unsigned long next_intervals_tune_sis;
> +	/* pause kdamond main loop */
> +	bool pause;
>  	/* for waiting until the execution of the kdamond_fn is started */
>  	struct completion kdamond_started;
>  	/* for scheme quotas prioritization */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f9854aedc42d1..1e9f6aa569fd2 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1331,6 +1331,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  		if (err)
>  			return err;
>  	}
> +	dst->pause = src->pause;
>  	dst->ops = src->ops;
>  	dst->addr_unit = src->addr_unit;
>  	dst->min_region_sz = src->min_region_sz;
> @@ -2978,6 +2979,13 @@ static int kdamond_fn(void *data)
>  		 * kdamond_merge_regions() if possible, to reduce overhead
>  		 */
>  		kdamond_call(ctx, false);
> +		while (ctx->pause) {
> +			if (kdamond_need_stop(ctx))
> +				goto done;
> +			kdamond_usleep(ctx->attrs.sample_interval);
> +			/* allow caller unset pause via damon_call() */
> +			kdamond_call(ctx, false);
> +		}

sashiko.dev comments [1] below.  Let me reply in line.

: Could this cause a deadlock if a walk request is initiated while DAMON is
: paused?
: 
: Looking at kdamond_fn(), when ctx->pause is true, the thread stays in the
: while (ctx->pause) loop and skips kdamond_apply_schemes(). If a user
: triggers a sysfs command that initiates a walk (like writing
: update_schemes_tried_regions), the sysfs thread calls damos_walk() and waits
: for walk_control->completion.
: 
: Since the kdamond thread is paused, the completion is never signaled, and the
: blocked sysfs writer will hold the global damon_sysfs_lock permanently. This
: prevents further interactions with the DAMON sysfs interface, making it
: impossible to even unpause the context.

Correct.  I was able to trigger the deadlock on my tet setup.

: 
: Should we call damos_walk_cancel(ctx) inside the pause loop to abort pending
: walk requests, similar to what is done in kdamond_wait_activation()?

Good suggestion.  I will add below attaching fixup change on the next spin.  I
confirmed the deadlock cannot be triggered after applying the fixup.

[1] https://sashiko.dev/#/patchset/20260315210012.94846-2-sj@kernel.org


Thanks,
SJ

[...]
=== >8 ===

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3405,6 +3405,7 @@ static int kdamond_fn(void *data)
                        kdamond_usleep(ctx->attrs.sample_interval);
                        /* allow caller unset pause via damon_call() */
                        kdamond_call(ctx, false);
+                       damos_walk_cancel(ctx);
                }
                if (!list_empty(&ctx->schemes))
                        kdamond_apply_schemes(ctx);

