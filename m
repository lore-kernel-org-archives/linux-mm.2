Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C774FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539D49000B2; Wed, 13 Aug 2025 13:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAB5900088; Wed, 13 Aug 2025 13:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4006F9000B2; Wed, 13 Aug 2025 13:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B18F900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:02:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1013160413
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:02:29 +0000 (UTC)
X-FDA: 83772352818.13.00EF966
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1379440011
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:02:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ek1oiK1X;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755104548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1STLOIUzATcLzQmAxdOBESRA2CBBQzTWpehrVZGSII=;
	b=78xMgQeCsdEIvTT7gEqVyLDYoXjufZBNXLFxt4Xnot2KbGXhFfOc948i7hgzhdMGwICJGp
	aJ8VVKdIZehpzS3wegMDUBPWxjBbCvljCh+Dm28ZoNviARrafmbQOu7793N/rnsT5JRkwR
	sVeWwN97Crs8KATmee2j7ZGb08XIA9g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ek1oiK1X;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755104548; a=rsa-sha256;
	cv=none;
	b=s6LKzFdhXojD4Q7EGjbOSHiCNT6KN9d9n5G2JNAwOg7zTzAoORcKfvQgeqkh9NzLJaBG6R
	JXOVg1N7F4/42PDEzi7qp12vwCsRsDXzGddJBn4S25t1rDeAGY1fEZCcmjKm4StWLttrxT
	M6F3BM1GKJ9vEVSJcAzGohZ/uMK5bK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 17B635C6E1B;
	Wed, 13 Aug 2025 17:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17D2C4CEF8;
	Wed, 13 Aug 2025 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755104546;
	bh=pxPFIqlcVAMG5sLiG3JCncN+PKieiRwzMe/d3NJAQGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek1oiK1XjXTi0SESN0AUPvtcaMoHxYRtyyZaq295L01XSarSLm92n3YPf5vxwipsw
	 KGqabxNl58laYyM/23faOZSmlQluwCUO5e/WArOUQgverIDf10+X0FpW3M2FCWhaJG
	 i5OazMp25tk4QUOzpzvlwS1cHO/JP/DUEAPjdl5Zck0wPnvFYZL5B67T66uEkrRSDN
	 FTv9BU3mOnVhEhbUvwwOg6L7f8kLZhkrd4OkaIQfoavKlcq10q/xPm8jtE+Jo66HQG
	 BVOaYz2N9jsxARJZQX373m4zG5Q7YKcyFQYLPe0s7az+NAe8cIda9dT+k0WOFNV82/
	 VjnbRziy0istg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 13/16] mm/damon/sysfs: ensure valid addr_unit setting in damon_sysfs_apply_inputs()
Date: Wed, 13 Aug 2025 10:02:24 -0700
Message-Id: <20250813170224.6128-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-14-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1379440011
X-Stat-Signature: ozghkmr9cqrw3zcar4uw1jd7qpy4djaw
X-Rspam-User: 
X-HE-Tag: 1755104547-239326
X-HE-Meta: U2FsdGVkX1/zGXf45SVbf4/5cEBTebDjoj5ElhSlmhWphbedjbpyPc92wvV/TAQBTvWYybh27CFt1l1f8hCpaTATFYgH1LvT4mYWhNthNr9cZRsfEdsqkJACQNC6QlezC3gGZHIeefANMm21rhZlQ1CbX4sp65qmnYp84S3fNDgHI7ucQheI32JsntQJfhRIJUPtYg41C/c+OQO6gH8kWcV0aikJ//3WdITEdyvu+6QeYau3aPnowxaXqpCBbM1j6oA1AYU9+HfY0FptA+ZoPWqB0B9KvbnPyt5JhUO/Zqq92ocmPpiaz61pgIarSFQBwam3+1wOxiGCg6/yd5iCL51xMOc5ixsa9BHQi+xk+B/ERGvcubXvVwP1RO8FpLNRCPTXVRnI7EA9CSC/1iINOL1QYeAkggolOKHluxWWys+JBbVJJYTgyIQJT1tZUSBIjP3N0buh92JtLLnP+SP2RkyRvd+Q/ZVk7L/IGxxp6JrcIT7+KG2K+5kivbUOuVNmhX3ImXL7VEmTCy8qHgGk6MHIkIINWs+8H6ZsnhHVWQ/6GslkGRqpjefo6J+dMMD0xDh5fcf0DSMmVkX332SUTG9kls7qLFzKEfnAj277Zb2v306ENnBZUqzp0q6jEKkiCAwmZcrPDhy1FA53tSIr1+MDOmblRg5n0e8OHfuRTQwf690LtM2iXRXAA8N46UbM8YkIX8iKMbsc8aKm8shV7Fm7Ynj/a8rIi9OfyopIQdrGL3wL2QBrILzNo7JHW8YmRMQduJIkwBCsG+wfz0B3oooJ7Aj6HwoFVaZyatYh9cFVJezTHdLlQTYJkSW60R8YJG++bPkkU6SKDPwDHp7jXLhFCLe+dCWFiSYKtyBxNEqNqFUDIHbWen6QcFWRs7tok62I9WWGQoJsMTABcWj1SZU4eyJwRHSFUR/3akBbStTIhFDMxfW5HtYvZ+lHumaszB3LWv8TvOl2uLG6mwq
 6U1tG8ur
 DknLroxPn1iKF+S5c8jk+NyrQpIdaJ/TbH+aCNr1M9up0boZRFZIj6q46cKXy/vF3OKzZ+wjw7ff37Ue7cO5qMgrLg3ns07KFoZk7EApI1mvsJeR0k6s70EnqQYuB/0LCFHMzwB7X4jUsQASDGzaxAlwatCT5M9XpUEGSxczBxhradP8RT9UwqcioTADfyY6lLYBm6spooWYjTdHI0oHaw74XSyXiOZDeYIYFVd7UvN1GTBBOnf21LqFW6iyDN5nWTwIB+ndsmCZNIKH+q7DXXIeD5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:03 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> By calling damon_sysfs_turn_damon_on(), the execution of damon_commit_ctx()
> can be bypassed. Therefore, it is necessary to prevent ctx->addr_unit from
> being set to 0 in damon_sysfs_apply_inputs() and update min_region to avoid
> potential issues.

Nice catch!

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  mm/damon/sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index bea782b0a711..122824776c1d 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1422,7 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
>  	err = damon_select_ops(ctx, sys_ctx->ops_id);
>  	if (err)
>  		return err;
> -	ctx->addr_unit = sys_ctx->addr_unit;
> +	ctx->addr_unit = sys_ctx->addr_unit ? : 1;

So this is fixing a bug of the seventh patch ("mm/damon/sysfs: implement
addr_unit file under context dir") of this series, right?  It is better to not
add a broken patch, and then fixing it in the same series.  Let's squash the
fix of the problem into the patch.  Don't forget adding your Signed-off-by on
the patch.

Also, since sys_ctx->addr_unit is initialized as 1, the value being zero is
user's wrong input.  Let's return -EINVAL instead of making it silently
success.

> +	ctx->min_region = max(DAMON_MIN_REGION / ctx->addr_unit, 1);

Seems this is a fix of an issue in the 12th patch ("mm/damon: add
damon_ctx->min_region and damon_target->min_region") of this series?  Let's fix
it on the patch.

>  	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
>  	if (err)
>  		return err;
> -- 
> 2.34.1


Thanks,
SJ

