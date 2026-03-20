Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37881109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985A66B042D; Thu, 19 Mar 2026 22:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9368E6B042F; Thu, 19 Mar 2026 22:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CB26B0431; Thu, 19 Mar 2026 22:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3186B042D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:01:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F6D45B3CB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:01:02 +0000 (UTC)
X-FDA: 84564788364.20.58312FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D01F18000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:01:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAuVR5In;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+uU1DbdeviTeq31zOdMQnz29iYskonK2Y4BSqeM31k=;
	b=fkgHDlFaDzvl6G2ZZan7ROXuq9/3d/7hvjtIc9yLQ9oMlrpN/hi+e2ExROtN3gLjw3gCyc
	HnsjvY7rkzelA06XWX0nMZRTA7DKJCfTFktQZ3v9t/OkLX5ALD4/KCPM8Iswc0ip+Stjtf
	J7iaYYEorl5RZWTGOH9y5BDnQJfowf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773972060; a=rsa-sha256;
	cv=none;
	b=vniIOUpootahDoYYQZMu8Mg4mSH40kT16SSZsSnxuz5nNkcuzM8kt6aU6zGFcDa8BguIhz
	+EX9OdzkIs8tp8EDWgekuBP+23qWCGbpTmTNwM+Fr+Ca/PRjaKB/5yVYS1bR+XpSO3fZZT
	IzvYxrw9a1XcEhxNVr5UaaJt8MKx2gQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAuVR5In;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A0E3E60130;
	Fri, 20 Mar 2026 02:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F723C19424;
	Fri, 20 Mar 2026 02:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773972059;
	bh=OradEm4zShh8J5nFxSUtOySkpjsYIi4uei72JjD05AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAuVR5InUxHN1otPcHeOXsOMHzuamEHIiJZkY/FvUupDRiBoo9IY9XfbQK143C0T2
	 uU8nDMLM4vY2I4DlmHg4/oWD/jpf2LVcQmsBXamZY94qnBAjh3b6P9KblRrinwiUqo
	 DVtweS3pUPq9SA0GPMiG/CYS8XzGuoiDeiGv9MaFul0VamsWNkzsk9KcNkD4y2rtTx
	 ZKEU565XnYd86fNlfl6n2ejBfkNthFTDS/OdrXWEY4RG5lu8h/3/j1Hgp2uBC5iE1V
	 zyl494t/yqlNpYVBFGxxaFOumtlLzckIS0+ckFA+UJaMq7flSaI/XrsKQ4dK56ovB0
	 9im6sXoDxxyyA==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Thu, 19 Mar 2026 19:00:54 -0700
Message-ID: <20260320020056.835-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319155742.186627-2-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D01F18000E
X-Stat-Signature: zhp64wu36k94jwnydwkc98dotas8etzd
X-Rspam-User: 
X-HE-Tag: 1773972060-275644
X-HE-Meta: U2FsdGVkX1/wNOSqy2BoA+AtZ3pVSx02sKGyralO0Jh7Rltd9d/V2OyBqpRWYoWjRYL+qqlh5e5OVk7aLqlmHufx23ZzFfzCNOqrFmb2okIiI1rZrCLeAppdHKGajNIILUhJc/P1uKfRAGrLlnZv2LRIXhPpmdc0im92qHalAx7z2PdObDv2bWdceB+Aow+R7c0qDZLoJZpl+gCRAs/FmoJsjEkVGdxHZLxFGtLEz/rh596D4YJwHuCNC48bLRRFP3n9edNyjQKsfyFR53Kob0aRQgaahhX4YfJO0sjA71yr/4soxAGn5tqUyvLjZtKIeizolv1MwNZmvFqAyASYyMmI1ykclsnNuO3y7T+MHb5w+JPZvF80pXjvNuzj3RaFJdrc9JEO9uJ1iGdjpR5CwVT+L1otX0ExCLGhYrQDUJcVSYcw8jQdL26m9Do2G6KJir+7jFK46dUqu4DoJh1hcOqNPCS/sn5T6XNasvZjPtbJyzDxmk20ZAf9AWCoW23nBczHmLx4ieM9sSwKoUBGzR4MaYTEeUCuxafsaK5DKXdphBhMBYI/brAaqBGuMLjKiZ7vOYWP7rHevxOfITl4dHJ7KETDPmL9ZuDkWX2B7oiL0J2kzhdzLos3ZYZ9U0FiSrjLIjJHOOZZ8Y1PeKkSAYfrjVHnDaMbX+olmTRLv9OtZsTUYpgwXQRt8HMcBKL2/ax8cUPXkJmjbiEfnaeVWhkORZLGCJHKH1I1nFDn0phvMPiIUUwXNDWV96fHqmiYVKEOH+zi/yBhoU70EcSnJHoyNVukO9dD5GzXA36X72cP8ghJs0b127FDZ2jMD2DxNoGcXXXPNd0HRL/gdzxbOxOlw35W3SOOwtWVS1eWXFOJRT2UPGCHsiPJT3viN8oddv13HzD2pUPNViSHeXmJizjB6KvKBynZJKIYHYfxN13mS62uK1urPc5dCXny5NJpaTyfzRdxQ+GhuHauVf6
 0Zjifq3Z
 OniofPPVHo30Yf0EffOOr7aap0mC3UukAapEaLgQ1MDuUw46YhgLPDQTVhmuVEnYnl0L93C0fKWb7XBQlMpUTiVHKOHXWrQT8oOKrK9lxYqGWvIvXlHtwi8uu+7t6Tp3Coy5ukdx5c9xab9Pnqi/f4toj19ynUMO1ccIASXFdxkts6bWubGdAKJm+nyCEZQfyTfmK3CAtqXTtLnXseKlTUcHzue8B7N6HRJ6YPrlmwg2Mi7Ya1whTOBSVJAjMAvbj3pxVbefXsvCjaQ2toPiS1CXPkm9gGrQ99FD4gcoXT8S84hxvavq9HFkMrEU9amMrIO2QD+HJvK7yhXWHQCupapfc4O2iJxVW4kCXPSnop1OZNeOVSNgSOMpdRQ+loUyrq4VJ0+E/PsKw3xE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 15:57:39 +0000 Josh Law <objecting@objecting.org> wrote:

> When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
> param_ctx is leaked because the early return skips the cleanup at the
> out label. Destroy param_ctx before returning.

Nice catch, thank you!

The problematic failure can happen only when the arguably too small to fail
allocations fail.  So, the user impact may be not big.  But, still the
consequence is bad.  I think it is better to add Fixes: and Cc stable@, as
below.

Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Cc: <stable@vger.kernel.org> # 6.18.x

> 
> Signed-off-by: Josh Law <objecting@objecting.org>

Other than the above,

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/sysfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 576d1ddd736b..b573b9d60784 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void *data)
>  	if (IS_ERR(param_ctx))
>  		return PTR_ERR(param_ctx);
>  	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
> -	if (!test_ctx)
> +	if (!test_ctx) {
> +		damon_destroy_ctx(param_ctx);
>  		return -ENOMEM;
> +	}
>  	err = damon_commit_ctx(test_ctx, param_ctx);
>  	if (err)
>  		goto out;

Sashiko added below comment.  But that's orthogonal to this patch, so never a
blocker of this patch.

: If damon_commit_ctx() fails midway through damon_commit_targets(), could
: struct pid references be leaked?
: 
: When transitioning a DAMON context from DAMON_OPS_PADDR to DAMON_OPS_VADDR,
: param_ctx is built with VADDR ops, while test_ctx inherits PADDR ops from
: the running context.
: 
: Inside damon_commit_targets(), it iterates over targets and calls get_pid()
: for each target since param_ctx has VADDR ops, adding them to test_ctx.
: 
: If a subsequent target fails to allocate memory (like -ENOMEM in
: damon_commit_target_regions()), damon_commit_ctx() returns early and skips
: the dst->ops = src->ops assignment.
: 
: This leaves test_ctx->ops as PADDR, which lacks a cleanup_target callback.
: 
: When the error path jumps to the out label and calls
: damon_destroy_ctx(test_ctx), put_pid() is skipped for the partially
: committed targets because the context still has PADDR ops, permanently
: leaking the struct pid references.
: 
: Is there a way to ensure test_ctx is cleaned up with the correct ops
: if damon_commit_ctx() fails?

# review url: https://sashiko.dev/#/patchset/20260319155742.186627-2-objecting@objecting.org

Sounds like correct.  But defninitely orthogonal to this patch, so no blocker
for this patch.  I will work on this later.


Thanks,
SJ

[...]

