Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957DC103A9A0
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A736B0005; Tue, 24 Mar 2026 22:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51686B008C; Tue, 24 Mar 2026 22:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E7B6B0092; Tue, 24 Mar 2026 22:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C75D76B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:53:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B1E51B8610
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:53:28 +0000 (UTC)
X-FDA: 84583064496.13.5C16A2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BCB3B180003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:53:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmYINUJv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774407206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HfCox+wTQvgAMwQKckRC0O3FhSeeUwGDehB01eZMKc=;
	b=Apb0Akxtimb3upbTJsikWWi+SxU2ya7dwEzQYDBuG8VQjLVPqJSjatOXrcUki+wzCvfU1e
	i64ykCVss4MpnAIfI59pF3+72OZHWI5nLqh+sHbofV57C7Gjrw2/XOQWOFFVGIMTKL/NWI
	qqlqahxYheT/bA1RzZ0axJpR+GV9AYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774407206; a=rsa-sha256;
	cv=none;
	b=KhPTajzNjXFPYWO6JAJ+W7JetdHX87Rq1oObws+ZMzqoT/EOTEQw8nkiSL/P6aCsZukXZD
	cWZvLZvp0s41509tHChsrcKh5zbyuk+4AnUCFHnb8UJfBi00inWqfKa/VddeN6lbcgL5XH
	lN4UuIoaEJ1SAEh8VX6/RCpQatbfPe4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmYINUJv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDD7542D78;
	Wed, 25 Mar 2026 02:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7765AC19424;
	Wed, 25 Mar 2026 02:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774407205;
	bh=9WOf1K1dbf9+9pgjiz2eJYCj8xI0zOxa68b/VvHN8pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmYINUJveBPg4slR9ROjzQYgRJRo99Y/c7i2+uUXgMjwyOZ0mvozj/EVQcelfzYN3
	 LTySjyzYVF3e7oibxnjJGzQhoREJMYKEvJ/cpQWYSUbF5HyFWCJR6GqMqMoc28muE9
	 LG1MlvNcUYUJ7irscjqOWsaTkxQMradBgDrHDM1sgKHTwFUNntBT/MIO3/MKVN3GtH
	 kEw6Cd/2smwKJHbZ6F7NOz3lURDuniXWiXSHYGTo92vcWwKjSzFHrkdbeUMTf1B+2B
	 o2q3KJGT8gVa0DindVL2RnBQT9zRIXlZebvE+22n8k+Lf8NwLUU+AFt8VSGS/ZabIZ
	 MAmh6Gl8QlSNQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Tue, 24 Mar 2026 19:53:16 -0700
Message-ID: <20260325025317.86571-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325013939.18167-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCB3B180003
X-Stat-Signature: eqs8gaajijdk8877hiduyeux19xqxmmh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774407206-902324
X-HE-Meta: U2FsdGVkX19AYlczl3m57jlTERup9DPIVFER5MxQd8TjyLFmw1zwk4e0u03ERuCr19PY4lClFv6CqjG7dl5KB/G5i+0uKFsFlsV1HaKEaeh7bvF8XvKtnEUiVd0LJgKJNvz+WoeMNxopibVLQFsXm0GT9A+pWfJ585cBSF7/kzn3cSD4J6hn/4nZGy/oo+0afAiTkBtjT/2+/xXtpbsTtL3/N6BIQ+VLduSR5hUzRJ8LI5mfUSfocHYgm1QawOTi4Khu5mWzzqxvJESjXxJ7T+vHrZp9a7ioMM0q3rn+d51xHwoe4Y8qICoT5vKq+iJ3+LscXH7oyV+FKJpjrkDif2+givstLzcvE3ZvDG2WJRZM2NfadhuceuiNoTFTUzH0S3ILnOkMm7X4hpxs7iPkh9Ihy749WOmrN2mGPgizZlSjwG8dBdDjvsykk2K/CPy5n6yshhTXX519QL9q7xDgYEqjhBvt2D1cIi4ZPf/8D6DbIoktxD1pAWiF8XivyC3W1Uox8c32noIbAbPCJ2Q9TDDKVNXEKLpEoWeuqKzHqWEOM6N3w1nqpyhivumHTfsVZsf2sqXh6nsOJi65Z7W9woL/UGQpzYoF/nXHrBK03MGF7pSpGkUbViFepJ9QxYE7JzlMmgNDOByMhQPCAc8jALOjwIFu0zBueKCRwwDT7uA0SbtqIVuTImvb/W0R2Dy9xUvQuOaXosEkrtI5ELpxy/7+dt2A24hwc2yYptz3v4KeyKEMRJSd7SIvI5OgeeVdvEUPD4QrtnTQyyO2pWzJAyTvCxLe3XeLCFYGJNEy+d8Gkp9RJ56qFmEeGENV3yQdT/tToX/I5iQiYxufbuUKe1W2fEPJKNtzXJel3071yS9dyOiuvZygvkyUWDrsoyBQ6xsNBET+IXaqHwyHcPRmigm/h34KxKE8JOXOT2JkA/1/AKMUod2jqUefPqKhXrMnPsIKTlxYnv+ueHRRrwq
 rg06xgcv
 vEYjoaQpJs8UAfs4TkWpyQEmKk9uvfa6XUj4Np9a7HiQ4wu6JtxlF8HTKIa2fCyHwowuhDoYq4Nl7L2/MZzP3XHe3GabeJOGdnRUD/6REl1olclqPqhwIJM3aDrnNa8jm7v+7yWtQJrUBNVEZHXJZhf6HxZp2qysCx694V5/8ym5MtTo3obrlA+2AEmedIauAoDyGJanPCPEUeQTcwkEwgv0RRoWmopOt3a3zsCEC1ku9AX5ibRmwO3b1hAohfvV18dQm3qsPdH0pi6XIBy2epeQbLudEi0aVHR32ZjyZcy/X9KK+jq5VHqbSBNZu6MemIMIDryHbn7iD5i0SmkIvRuFgFUBJZREQIM9h8Cp8bCG24FElvNnGy0+NdqD1U8geIYdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 60ccea4154b0c58741fae2323454a5a9496b67fa
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon: add synchronous commit for commit_inputs

Writing invalid parameters to sysfs followed by commit_inputs=Y previously
failed silently. This patch uses damon_call() to synchronously commit
parameters in the kdamond thread's safe context, returning validation errors
immediately to userspace.

Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..a2410f648b51 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c

[ ... ]

> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +		.data = ctx,
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

Can this sequence lead to a system-wide deadlock on kernel_param_lock?

Because damon_lru_sort_commit_inputs_store() is a sysfs .set callback, it
executes with the global kernel_param_lock held.

If kdamond_fn terminates (e.g., due to an invalid parameter like addr_unit=3
causing a non-power-of-2 min_region_sz), it processes its exit sequence by
calling kdamond_call(ctx, true) to flush pending requests. After flushing, it
eventually sets ctx->kdamond = NULL at the very end of the thread.

If a user writes to commit_inputs exactly in the window after
kdamond_call() finishes but before ctx->kdamond = NULL is set:

Thread 1 (kdamond_fn):
    kdamond_call(ctx, true);

Thread 2 (sysfs write):
    damon_call(ctx, &control);
        if (damon_is_running(ctx))
            wait_for_completion(&control.completion);

Thread 1 (kdamond_fn):
    ctx->kdamond = NULL;

Thread 2 will sleep indefinitely in wait_for_completion(). Because Thread 2
holds the global kernel_param_lock, this permanently freezes all module
parameter sysfs interfaces system-wide.

> +	if (err) {
> +		/*
> +		 * If kdamond is not running, damon_call() returns -EINVAL.
> +		 * Remap it to -EBUSY to better reflect that the operation
> +		 * failed due to the current state of the system.
> +		 */
> +		if (err == -EINVAL && !damon_is_running(ctx))
> +			return -EBUSY;
> +
> +		return err;
> +	}
> +
> +	return control.return_code;
>  }

> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..4cbd67e08d56 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c

[ ... ]

> +	/*
> +	 * Skip damon_call() during early boot or when kdamond is
> +	 * not running to avoid NULL pointer dereference.
> +	 */
> +	if (!ctx)
> +		return -EBUSY;
> +
> +	err = damon_call(ctx, &control);

Does this code share the same kernel_param_lock deadlock potential as
damon_lru_sort_commit_inputs_store() described above?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260325013939.18167-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

