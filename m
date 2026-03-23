Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B590F4613A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9D96B0005; Mon, 23 Mar 2026 11:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91B06B0088; Mon, 23 Mar 2026 11:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE656B0089; Mon, 23 Mar 2026 11:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD03D6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:05:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6358613C0E4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:05:55 +0000 (UTC)
X-FDA: 84577652670.10.4CA80F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9E99980015
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:05:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4zgnloD;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774278353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHkcBkkL3vTWhLoTpn+3ORouW70uscAXl9OVSfrcL9k=;
	b=q4symtEgGlfFtlSaBu03ms5tTubXiXbwfFZmMrshWKNNLqYqzJN1efspsLXEeFI7MlbnB6
	l282GwPLY0c0fbe/UD1UQNuyo8zh4V/NtZeZ9CO1/O5LJwpdMqM/DLSnD9yGi5N8xIYoly
	1h+XB64MtMrkkH92/5zq/rJWG/xRBnI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4zgnloD;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774278353; a=rsa-sha256;
	cv=none;
	b=bSo0ZXaeFioC3blNjgK7XActZVG2xAj6nvpKGxy6A1oGED5k31b6WsUQBR1c7TOatDPz48
	/YIU0WKs8cMsiUaKpsfrSBQphgpjO7sfcUm/f475FzT+bSkyN5qEHugpk6p3sJW8vxCKTK
	OnceTwaA3dLpItGzCFKA7wNz3Xi7OO0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FE5540DA3;
	Mon, 23 Mar 2026 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9D1C2BCB5;
	Mon, 23 Mar 2026 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774278352;
	bh=Dw+7MMaMQYVgrLVNbToYkgZbnN09PQLsaBBhAF1dW7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4zgnloD5Ld9sxjTmn1ZucqqjF073qyBWmlVhmGnQNrp+pkN2vbGr8wQRGsnfRsfr
	 5Ph7dKosRX92Y10jcxpl86kUSET6Flb6skBME6HgpusGLi17Z0azIVraApT8exZ64r
	 eqlbHtwE0Qvh5Pj7xQswycB2rwMK7wSqr1McPPtoB6Wtxx3ImOKLT4LTzx3u02QjSm
	 JHYhKY4xD/W/uUnnQKmTJX2LDLuVIl5QoPd2/CUGygzHfCNWJovxR+OMo11RI4gVAk
	 g5BuGNZA8mgeUJMBw8T/mz41V0/cMEpx54N2ri2WIRLxWxNoVN4vuKqwBaB5QyN99b
	 oqbMl5YDnZATg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 08:05:43 -0700
Message-ID: <20260323150544.81042-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323021648.6590-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E99980015
X-Stat-Signature: au48wymxzwf4bz58hb3kp9ymd98rki8r
X-Rspam-User: 
X-HE-Tag: 1774278353-462100
X-HE-Meta: U2FsdGVkX1851QY2DZLG3GJMc2Kgwtr2d/7px/WE63GX/1SXHnhHGgDX+XaCBVjmHZJfMoZkchchE4s0EMftDxe62UvBgVFo3F2lDorWQVaJS8RwMHAMHlsXWUPe08A9/rp77wxRAcAr1xXumVUy/pvGTF6t6i9pGVTDr5QSyrwCL1EXeJlUQYDH9+Q2e4fE9XYyzlGPSGmR7LT21pLhesneSTzqFcW3jr5nR5Yzi9lRRYa/AX3RhVPWw6if36MSSpjM3UYrZwnJr3qVlQdWkpBcJMoHU2f5S49YhrwkKqQE7ZQiF+I6loUeG6WR6iVfQ/C21G2RWHWSX0Bs/5rPPW5yWGjbO3uqUTKEd9DfanQsENZ7kuvBk+bLgFlyJGikgyET+oJcgvHFA15lxb6Uy4QYp1KgP1bCh/UVxOMog5azmT1YNj1Hq/EA4eXzI7BTmXE43AcSWkYMAx1xurDn3uytC/UJmWURwYQNTrlAGQEQpeHApX9oxgupZsSmC7c6hHwnm5XXdiiShFBBNBhPflVZDXb0DJTrN8y8Bg+WWbobA2f4bAq48UE/Ib9ejiPLdyYXvIpu0CVpfQMubBIAEy97TWJh0KJWnrCs0ywRb/rs6k936tD258xbp8ShZc4rFgnQaBrt7o/OtvVF3HvjOTqZB5iRWedypCuLHHNrLyeuXXp5AQOsgsAHnzC0bav7S5rIBHGliamMsW1pgmiRF/vWibNbSSzhERiJqqgGx9JxX6Ku9625GCf2CiyLdWAx2rYWayA1solbACbndNPvtx+X5iQZRLHy9Chk6mbAMUOWoOAzgRmcTf5c3V6vHzgaWl2N3eGXtwqCpEiT7Cow5vyU0BUCSQPRLM06qi6QRKmva9u9/EhxHschzmCGMiO4OrluVtixIPfB9EOymXvjHeaf+Dv/LFOkx4zLkAg6nabDdbEh3kuE8/sSHUVU5Jl0/WTQNX06b9Kq0KjjtCg
 i3YTrH0Y
 8lEGVDb7mPwlHZO19dRl4rY2C+K+Fi0O5UjHuNFK1929IqcXh7Uiy6XrGZN5g7DiS81V/bBj8It4RhIIyVZ6gt8VldpS7MTqYZWk/hJKjAypNSBwiKRbpxTgDSRJBxM24w1KEamHg0g4OUvVzTabuYLhFTKX5rHtYqGfqVT9LUY2KyLO/wR6ayT4QjZ5mNnblJDYxDbK6HiGKBBaT28gdrEr/wlAq1iXSW5IJR/jIAj/ysNrA/kfW226SGSfoMhrx3a+Ph3PXgcJT3diU1oWuSpJzeMko7bKduNk9xBxjtQ/frnj7Og/CigUJ4w/7qYVkiLSj2IveajRbB8/H2CdHEeYEWSNHF4qnKyLkxY8xNbAnjN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 10:16:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
> silently (no error returned to shell), because the validation happens
> asynchronously in the kdamond.
> 
> Solution
> ========
> To fix this, the commit_inputs_store() callback now uses damon_call() to
> synchronously commit parameters in the kdamond thread's safe context.
> This ensures that validation errors are returned immediately to
> userspace, following the pattern used by DAMON_SYSFS.
> 
> Changes
> =======
> 1. Added commit_inputs_store() and commit_inputs_fn() to commit
>    synchronously.
> 2. Removed handle_commit_inputs().
> 
> This change is motivated from another discussion [1].
> 
> [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> Changes from RFC-v3:
> - Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
>   pointer dereference during early boot. (Found by Sashiko.dev)

I'd prefer archiving sashiko question on the mailing list so that others can
also read it without have to visit the web site.  Please consider doing so.

FYI, because such sharing is not very comfortable for now, I developed new hkml
features [1] for helping such sashiko review sharing, and I'm using the
feature.  Please fee free to use it if you think it can help you, too.

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#sashikodev

> - Removed handle_commit_inputs() and its associated polling logic as
>   they have become dead code after moving to the synchronous damon_call()
>   approach.
> - Ensure the 'commit_inputs' is properly updated.
> Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com
> 
> Changes from RFC-v2:
> - Removed damon_validate_attrs(), now using damon_commit_ctx() for
>   synchronous validation in the kdamond context.
> - Following DAMON_SYSFS pattern for synchronous commit via damon_call().
> - Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com

Thank you for adding the detailed revision changes.

But, please consider waiting about one day before posting a new version, so
that we have enough time to discuss on the previous version.  If you find
something you want to change on the next version, you can comment that to the
current version of the patch and give time for others to comment about the next
revision plan if they have any opinion.

> 
> Changes from RFC-v1:
> - Remove question from commit message area.
> - Added synchronous validation for DAMON_RECLAIM.
> - Rename damon_valid_attrs() -> damon_validate_attrs().
> - Exported a new function damon_validate_attrs() and declared it in
>   damon.h.
> - Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
> 
>  mm/damon/lru_sort.c | 49 +++++++++++++++++++++++++++++++++++++++------
>  mm/damon/reclaim.c  | 49 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 86 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..37b3c897e822 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -39,7 +39,6 @@ static bool enabled __read_mostly;
>   * the re-reading, DAMON_LRU_SORT will be disabled.
>   */
>  static bool commit_inputs __read_mostly;
> -module_param(commit_inputs, bool, 0600);
>  
>  /*
>   * Desired active to [in]active memory ratio in bp (1/10,000).
> @@ -349,18 +348,56 @@ static int damon_lru_sort_apply_parameters(void)
>  	return err;
>  }
>  
> -static int damon_lru_sort_handle_commit_inputs(void)
> +static int damon_lru_sort_commit_inputs_fn(void *arg)
>  {
> +	return damon_lru_sort_apply_parameters();
> +}
> +
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	bool yes;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +		.data = ctx,
> +		.repeat = false,
> +	};
>  
> -	if (!commit_inputs)
> +	err = kstrtobool(val, &yes);
> +	if (err)
> +		return err;

I was not very sure what 'yes' means.  How about renaming it, say,
'commit_inputs_request' ?

> +
> +	if (commit_inputs == yes)
>  		return 0;
>  
> -	err = damon_lru_sort_apply_parameters();
> +	if (!yes) {
> +		commit_inputs = false;
> +		return 0;
> +	}

I'd prefer doing !yes check before 'commit_inputs == yes' check.  That
eliminates false request case earlier, make my brain cleaner.

> +
> +	commit_inputs = yes;

We will anyway set this 'false' after damon_call().  Before returning this
function, users cannot read commit_inputs parameter since this callback is
protected by param_lock.  I think we don't need to change commit_inputs value
at all?

> +
> +	/*
> +	 * Skip damon_call() during early boot or when kdamond is idle
> +	 * to avoid NULL pointer dereference or unexpected -EINVAL.
> +	 */
> +	if (!ctx || !damon_is_running(ctx))
> +		return 0;

damon_call() handles !damon_is_running() case.  So I think you should check
only !ctx.

Also, this exposes commit_inputs true.  Next 'Y' write to commit_inputs will
make no effect?  Again, it seems we shouldn't change commit_inputs at all.

> +
> +	err = damon_call(ctx, &control);
>  	commit_inputs = false;

Again, seems this is not really necessary.

> -	return err;
> +
> +	return err ? err : control.return_code;
>  }
>  
> +static const struct kernel_param_ops commit_inputs_param_ops = {
> +	.set = damon_lru_sort_commit_inputs_store,
> +	.get = param_get_bool,
> +};
> +
> +module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
> +
>  static int damon_lru_sort_damon_call_fn(void *arg)
>  {
>  	struct damon_ctx *c = arg;
> @@ -374,7 +411,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
>  			damon_lru_sort_cold_stat = s->stat;
>  	}
>  
> -	return damon_lru_sort_handle_commit_inputs();
> +	return 0;
>  }
>  
>  static struct damon_call_control call_control = {
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..441d5d9f9eab 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c

Similar comments should be applied to DAMON_RECLAIM part changes, too.


Thanks,
SJ

[...]

