Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F680109C022
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2786B008C; Wed, 25 Mar 2026 10:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AE76B0092; Wed, 25 Mar 2026 10:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7D46B0093; Wed, 25 Mar 2026 10:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88C266B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:29:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D59814095E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:29:25 +0000 (UTC)
X-FDA: 84584818290.25.EFF2AD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7529F8000F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:29:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XAi1x6xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448963; a=rsa-sha256;
	cv=none;
	b=gtRxBnd9QYV3cvB1mof0b71EpgUx9ke077g16q/mgo/OhonfLgonWOZ3zxo7+MtrwNX2uc
	V8AC4NgMKl9z2N5+JGpwC9m4svp+SokdWf1yaMeCdIm8bNpCvq5SmKRBck5++8+SslIifW
	DJ9a9jCacRlfZUvtasnJRk5cvy8WmZI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XAi1x6xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWH/TiRcilxWQn5hnM+luG8t6f4F5WJQL/D0lblxV4U=;
	b=wIBlRLkcwV6wTVMuZUm96LfqavUaMImuTs4Wrn1lQK6T1pz0Nc+Dw+wn6m5n9KdWIp9HWN
	cuKHIpQcIzLtTcG8LpdyFVqTEinFiBtQIADPYJIpwHeou7R1FP7vPC3ItpHDWIFGF7QoKc
	HJ7gdum2+N0Z6GEtOWosdUMpYAkeuLE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C61943866;
	Wed, 25 Mar 2026 14:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4551EC4CEF7;
	Wed, 25 Mar 2026 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774448962;
	bh=zkNO+kmO7YyIbGFRyvNSq0hpZ0emcBw0JOFFgh57z4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAi1x6xeD+KtwLZfVNtI59E5LVvL9fks5GhoESNiKYd6b45jJ4dZ8YE3M4SoS8hLZ
	 LLYbVrkgwqrQpgcLAck9wtTc7cot5keSQ0dxzckxwjD3w4MCI9XiSeLl57jhfy/Ntk
	 ZIYq58HVN/LWfIx7YvYA1svz/Zww5NPdO2B/p2UucHNVBXrsU6xd8ZCyzwp2WnkCk/
	 Ew1HB+Ym/LxdvN411rN0KHXL+ZiLpY14tgmMOECIacSfSQoGVUi9nLgiikCw6r/lgb
	 66bYWLM2dsaSfc8+B5VpqEEqqkZDQg0C0FZ/KeGNhWbvVleAMiFSfERW5uzNlX4lKH
	 rgkTT+p9LTpJw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Wed, 25 Mar 2026 07:29:20 -0700
Message-ID: <20260325142920.87299-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325013939.18167-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7529F8000F
X-Stat-Signature: cyjcu8nnbmq7x754qpgz45s5of9wotkk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774448963-369890
X-HE-Meta: U2FsdGVkX1+w5J27oFQ+bYlH8mys7vdJ7gvvffa/0l8ZyQ4vrQkh5tNI2FoT6E27w7LPeMKVQApTfn1qGFJa7hFVdKMvsjdFil03bGxTKTknU8oLT6MJAlfE9PHy9iXuODbCGFlw3Fjv/O/WzuJmE9Lx5MZvZfwrKmXBFHdqlqsJ8AZ48tXMqAG1k4iC8lG1sD0rgA1T02MhdQ/J7D10y4lJMPrZFBGIm2NHH8i690PMp4J+yMS5FstfwNTnfEPVqhJbFWbz3WPQj9PyuA0F3tcp6Mt0uEliny0qcWylI3l/pbNx7FKdp7QwGY5/86x1gzYssASEhGuB9s1qqCmFCcYxSEH8CXmmW07IbzyJUFP6+NztDR4xltpxIzfP0Odv2WhkGTuVVfFJ4noM9SDrIpbUNmhDYLKDP7OkExoL7SYUp58JSbStkaJmewCNmQpbz1KAWlW9pVU9ndaprjB+N9A9SVOgsc48sv+XLbIs3CXg2QXMZGJ4mb8166idIsrD7xc2Q3sYJ13Orlh9719uwUfdS6ES2RDKHCqljTNZsgeRzT5T7CdggjE6iYv0ieB1GAlhUw4vcMd4oJF8G+TJR49SC8+w26qrw1AQhzQyfo0G6DfNphDwcJHJp2C851dknYogUAB2y+mTz6dT38nvDSyiKJmheiUBWPILGF21uAldtEa2kvRAsKt2Z6AGoC5TBEIvpLusEl5WyFvG2ZiGvHs+UiBnHj8ZAh9cUqxVwo2A8cDIXUmIfflE0S2C9MAvRsup1W5B6vAyu8TcP++INUg1HNXmmD8YM8OeAgqxb6YUESYehjtSqqIZ1f3kkbR52bshHLTupdhEtV6q5BEi7gIxfgnj/RSpgcGdCd+oSAKDKqH+aAjMB2PUwlSS2dNflkUH1MJ1d3tc/23NBdCQdKC9PuXxhZGmVUYnpirRfma0fpMhBakeP8ogtSs194sBS3CraJDeh66tivRXR+1
 Ts/QPvTZ
 NbQv+yTDCOMvkYEs7u+2l8d5+5gWt++4BPxWYFKbeFuySZ6zIbsVdh6N8q6avxwoBPwuMI91+ci8YFzv4rs6bAhBU2LbRx7nFbdaZogK9u4P9Dy8sKGHYH1B/6toBdoI9LA8QzyPnoNA13K1TmRZ50OacSCS8athkMCX7djjWvtW7Reo3bnxv5w/zmEDkek8Pd47nm8fIyO7ByInnUJGtU+Dj91hh6OwgL+qEvtAKOrQ5fRp85n48DotizO5ptK1ocMTBvH5DMGRPzszrMLmdNffTFKvADSMK580MZQvU1zzyyh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 09:39:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

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
> Changes from RFC-v4:
> - Rename the 'yes' variable in commit_inputs_store() to the more
>   understandable 'commit_inputs_request'.
> - Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered 
>   while kdamond is not running.
> - Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com
> 
> Changes from RFC-v3:
> - Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
>   pointer dereference during early boot. (Found by Sashiko.dev)
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
> 
> Changes from RFC-v1:
> - Remove question from commit message area.
> - Added synchronous validation for DAMON_RECLAIM.
> - Rename damon_valid_attrs() -> damon_validate_attrs().
> - Exported a new function damon_validate_attrs() and declared it in
>   damon.h.
> - Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com
> 
>  mm/damon/lru_sort.c | 54 +++++++++++++++++++++++++++++++++++++++------
>  mm/damon/reclaim.c  | 54 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 94 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..a2410f648b51 100644
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
> @@ -349,18 +348,59 @@ static int damon_lru_sort_apply_parameters(void)
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
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +		.data = ctx,

You don't really use the data in the callback function.  Why don't you just
unset it?

> +		.repeat = false,
> +	};
>  
> -	if (!commit_inputs)
> +	err = kstrtobool(val, &commit_inputs_request);
> +	if (err)
> +		return err;
> +
> +	if (!commit_inputs_request)
>  		return 0;
>  
> -	err = damon_lru_sort_apply_parameters();
> -	commit_inputs = false;
> -	return err;
> +	/*
> +	 * Skip damon_call() during early boot or when kdamond is
> +	 * not running to avoid NULL pointer dereference.
> +	 */
> +	if (!ctx)
> +		return -EBUSY;
> +
> +	err = damon_call(ctx, &control);
> +	if (err) {
> +		/*
> +		 * If kdamond is not running, damon_call() returns -EINVAL.
> +		 * Remap it to -EBUSY to better reflect that the operation
> +		 * failed due to the current state of the system.
> +		 */
> +		if (err == -EINVAL && !damon_is_running(ctx))
> +			return -EBUSY;

In my opinion, EINVAL is a better return value.  It was failed not because
something is busy but just because DAMON is not running.  Committing something
to DAMON while DAMON is not running seems invalid operation to me.

> +
> +		return err;
> +	}
> +
> +	return control.return_code;
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
> @@ -374,7 +414,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
>  			damon_lru_sort_cold_stat = s->stat;
>  	}
>  
> -	return damon_lru_sort_handle_commit_inputs();
> +	return 0;
>  }
>  
>  static struct damon_call_control call_control = {
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..4cbd67e08d56 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c

Comments for lru_sort.c apply here, too.


Thanks,
SJ

[...]

