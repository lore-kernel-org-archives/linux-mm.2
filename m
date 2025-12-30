Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9FEE94107
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 01:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0926B0088; Mon, 29 Dec 2025 20:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E096B0089; Mon, 29 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A056B008A; Mon, 29 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76BB56B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:45:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B49C5140DA8
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 01:45:37 +0000 (UTC)
X-FDA: 84274445514.04.8778218
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F0601A000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 01:45:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrcAOMth;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767059136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UM2kIL899zpIuToziKBLwuzSYrb2GB5qLfeTZsZo3Jc=;
	b=a1uMwZ8QWv/NYnjqLtsdtW3Zi26I4udgubfAOdT6xpYfv/01NoDtIHdQvcGH3eMFUNVs3W
	PC9AbZ4CXHq9icRfH0VdWG6lHPa+j3zVsAbDWebNnujkWdIbw9ouYrTrZJzHKoj6PnTE5m
	yfe6ITHBMe+DxbAFEqFenDUVpfLjRSw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrcAOMth;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767059136; a=rsa-sha256;
	cv=none;
	b=ZySAI6sFHhmKOdWYSqmS3qnqAGJhDq8tTvq7fuK+4Ij/QKJKeJUGfjelgFr6QH9Eq1wpfe
	KKpZdRdk70JUL7BKDF2LxuZ7sIr8gx6GYPw8aa+WBZe7NsJr7Vjggp4BdAURtjgJW93/3b
	Bu3Dz4DvCO5ft2TlKU0i6yiVOVv7RX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 842B96000A;
	Tue, 30 Dec 2025 01:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B473C4CEF7;
	Tue, 30 Dec 2025 01:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767059135;
	bh=dgbl44C0PU5sbee4M7wiZvZkqAumLV8IX2o+wM/DCN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrcAOMthTzj7jpQMvgeNsXg09EQIks9ddYp6VLMb7v28764q3kB0M7k/4LF/WZPd6
	 KPBaMJ6CzRC4/I7hlEf/jRdyVWBc9ik1QqHSdaDAGKdDWIp6d2a5clKxV7odqaxP76
	 8tYDT7lhKl5dseiT+eJA716/xHC+0ZyY9X9cxWoC30GPfHReTZ3DCwrN/iCd25rIwe
	 Ym5JhTK2xDchiLk6ZR0GeuNY7NrJmZ8psLALIFhdr8HYfkJ0zUbBkUCmmi79l4nsJb
	 q1l95a3dVM/p7IqMScvMUHP+hEi+CyovX4VZkNSEOn/wi49NN+Yc3lhscRh+x0M3rG
	 9lyFO5XIOhYZw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Mon, 29 Dec 2025 17:45:30 -0800
Message-ID: <20251230014532.47563-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251228183105.289441-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: orga7zzaxek75ztax36ricte15srepyr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2F0601A000A
X-HE-Tag: 1767059136-947728
X-HE-Meta: U2FsdGVkX1/QUh48nOzShvkzHyyW57VyBBk4WmIFZeU/7gqVNXbbG9LBgaxlPiyxCy41Ug+SgUzvTvCmHYGhECMrPhGYaDPG2LE47qygzbLaqdLzEpIKFxMBP11esmVYGTMALdewqdnLShBvuptAoGYX73Sj/ceK2GiDD8N/+35u7P2tnmUGPRZWLTUc9c8Dxg1BgZnXyjsKaWlwGn40BxNsLYke/UPYudPJl0WFuYRgsoCgX/yEqF9bpQOe6OUO7jrrCiM3N12aAYKW2RHEBM57wENY9gHwvixiqDc8o9QMpXONdl+LE2bWoSZgyn0P+b1XnfRpuXBhQdeLVEFz8HBQM+ZKSJPDlnwnyQp7qrzVdxIRE7Ef3OtsoI4+gdIWZnfYx3P/Nwnl5uvdGVvr6FaKdjQubxyUH7/6tGIP4j8l2pIOhcgfMeU+j995pHWbJRLhuZPVXYLW2xArPzmpehWOE7sTaC8cz6qRKvZ/abYSvi+ZQo7XDYN0ZFl9TMLwEkpUjNfpo/fvwfSHkJvTu+PzSbHlOj6+vNx4JOH+0d1edzJDByN1hklOosBnNAhW+F1+YChQtfSTYKMF3zQvZMUjft/3nrrRqYvba6X/uviMlew/vlf3N5/1Zt5g12FRFPrRrfhCQNRKgEY3ZAei3/eUUeMatoB43rZo8jQ7NSUAvsZDR5h3eHqQFyQ+U6onF4J2zEu9Gf3JfSMmXpx0khBDIy7PI3vW8PkvVLx957FrpEHYwCaS1kgOCY3+5q5doYdIjZ8DA4xyFQRL09augixMMb5J+Q4e9o9+89pCLfYOmPkEWFbxOCxs2l1Jb4ygccrbLYagP2ib6TzLU+0M3CaKNn/j3vtJ88pYNp8PX1rH5amLKA75YtmB1+j2VAlJM67QGy8Mx6YmIMXMU+43kemcmIgxhDt+K/sV1+u9+FFeQTweuvqtOSbAyRvN4+MuPMkPrSMn9Cu0S3TDP7Q
 oUhUm+1W
 UoAirmAHpSvQFMVIUqZifWUz07AgDGrFQ0y2eDaJ3P6SqIptY2jVb8sqk+6+YS3TQxOO0/53cWNg5M+qWJ4IRZSmmguEWuLDKH4Ypt6rwMS8+2LLaz7wWS5WWsIR46zUQv/J905NrJYU4QXC9/NtU3Q0GfOV4uz0qzCoeWgT5OXsqHuhz0H2tN/+o25IsGlfGfEt3M4ucGcIvuYPozXyqUYNmpzZV45nTRTsf/EIBVbmxX9MAWNq4P3xDX9OpMSZ6RnwK2SfsH7Bnl+LyQMqoG9NupyNu5wqfmyMWlhHGPsR6Sbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:

> If damon_call() is executed against a DAMON context that is not running,
> the function returns error while keeping the damon_call_control object
> linked to the context's call_controls list.  Let's suppose the object is
> deallocated after the damon_call(), and yet another damon_call() is
> executed against the same context.  The function tries to add the new
> damon_call_control object to the call_controls list, which still has the
> pointer to the previous damon_call_control object, which is deallocated.
> As a result, use-after-free happens.
> 
> This can actually be triggered using the DAMON sysfs interface.  It is
> not easily exploitable since it requires the sysfs write permission and
> making a definitely weird file writes, though.  Please refer to the
> report for more details about the issue reproduction steps.
> 
> Fix the issue by making damon_call() to cleanup the damon_call_control
> object before returning the error.
> 
> Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
> Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
> Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
> Cc: <stable@vger.kernel.org> # 6.14.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 2d3e8006db50..65482a0ce20b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1442,6 +1442,35 @@ bool damon_is_running(struct damon_ctx *ctx)
>  	return running;
>  }
>  
> +/*
> + * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
> + *				      an inactive context.
> + * @ctx:	The inactive DAMON context.
> + * @control:	Control variable of the call request.
> + *
> + * This function is called in a case that @control is added to @ctx but @ctx is
> + * not running (inactive).  See if @ctx handled @control or not, and cleanup
> + * @control if it was not handled.
> + *
> + * Returns 0 if @control was handled by @ctx, negative error code otherwise.
> + */
> +static int damon_call_handle_inactive_ctx(
> +		struct damon_ctx *ctx, struct damon_call_control *control)
> +{
> +	struct damon_call_control *c;
> +
> +	mutex_lock(&ctx->call_controls_lock);
> +	list_for_each_entry(c, &ctx->call_controls, list) {
> +		if (c == control) {
> +			list_del(&control->list);
> +			mutex_unlock(&ctx->call_controls_lock);
> +			return -EINVAL;
> +		}
> +	}
> +	mutex_unlock(&ctx->call_controls_lock);
> +	return 0;
> +}
> +
>  /**
>   * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
>   * @ctx:	DAMON context to call the function for.
> @@ -1472,7 +1501,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>  	list_add_tail(&control->list, &ctx->call_controls);
>  	mutex_unlock(&ctx->call_controls_lock);
>  	if (!damon_is_running(ctx))
> -		return -EINVAL;
> +		return damon_call_handle_inactive_ctx(ctx, control);
>  	if (control->repeat)
>  		return 0;
>  	wait_for_completion(&control->completion);

TL; DR: This patch introduces another UAF bug under a race condition.  I will
send a new version of the fix that solves the another issue.  Andrew, could you
please remove this from mm tree for now?

kdamond_fn() resets ->kdamond, which is read by damon_is_running(), and then
make the final kdamond_call() for cancelling any remaining damon_call()
requests.  Hence, if the above damon_is_running() was invoked between the
->kdamond reset and the final kdamond_call() invocation,
damon_call_handle_inactive_ctx() and the final kdamond_call() could
concurrently run.

kdamond_call() safely get a pointer to a damon_call_control object in
ctx->call_controls, and then access it without a lock.  Only after that, it
removes the object from the list while holding the lock.  The intermediate
lock-less access is safe because kdamond_call() is the only code that removes
items from ctx->call_controls.  But this patch makes it no more safe, because
this patch is introducing another ctx->call_controls item removing code, namely
damon_call_handle_inactive_ctx().

To see this in details, let's suppose kdamond_call() got the pointer, and
released the call_controls_lock.  After that, damon_call_handle_inactive_ctx()
shows the object is still in the ctx->call_controls, and removes it from the
list.  The damon_call() caller further deallocates the object.  Then, continued
execution of kdamond_call() accesses the already deallocated object.

I will send a new version of this fix soon.


Thanks,
SJ

[...]

