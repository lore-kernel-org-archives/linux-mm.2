Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD228FD0058
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 16:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3246B008A; Sun,  1 Mar 2026 11:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0A36B008C; Sun,  1 Mar 2026 11:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A93C6B0092; Sun,  1 Mar 2026 11:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE20A6B008A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 11:33:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5A1B1606FF
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:33:49 +0000 (UTC)
X-FDA: 84498040578.18.4A80CE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24A621C0008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:33:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoEMPbGX;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772382828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoDo1yvl5BAbm67XDDGHUfQgPrpTabbtFgOPTgsqXcc=;
	b=X1UBibDJdttQDCBba7Xpg5Ys4XudRLLnxB5+Gtpmf/pUlAjlkTJyTE4xiulDZh+fWfvT+p
	mBD2fLsygH7PHcFML346yw413ouNYi6SF4vWx+pay5xHmnw8U39BsqqbKkGzgvp5wqRbPt
	G+6oAfOEp8NpHXFQ0SkHKDfV5v5iVzg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoEMPbGX;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772382828; a=rsa-sha256;
	cv=none;
	b=UEBAYGyFLVhrAyHFNjyLvnNE0Glvn0aBkMVGahUmfHt8H38uZvtvtApOx+wbVoS5ObFdpB
	6Fy0J3jvmiUh/uSB27ixY2vgNzQj4mi8nBjFwrO+iEbHYnraJIHW9PQamKOOWovJIlFydH
	1GVDqMo/539vULOugSZ2cPGKAiTZktQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEB5543DB1;
	Sun,  1 Mar 2026 16:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997E5C116C6;
	Sun,  1 Mar 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772382826;
	bh=mSj6jEZ06Ohm/vWYhM3VYr9y1jAdM9wKNerjpfHg+c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoEMPbGXEoKrvcD3G+BXlmmxRvenZp48x1mkjangqOwx1mx0QpYwv6Putkn81vFvv
	 2HQHsAL+YyxQDbR+dOrl0Gori1yGuVLoOelDno0SNrHGsTQi3lIwTTf+ZsZXa/l11i
	 esMLqHcS7FuqOXrvCEGPoVxyXqHwXnbCMzZTR1v0LfERXfMBKcZMm6Dc52rFMvD/G7
	 24she6UB40n0SRA0ZP32mjHQQ4Ci0Z4lHBHQfNUV0Ykpw359QtghnwyhVNgIRb2Rlo
	 hnGwZzXXOKtEsr3T9trA35r3RhSw6vslv6F3LAtsFULITsC8fOLNAbupM8oI2tkp1e
	 x0UvmXB3p0WDQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Sun,  1 Mar 2026 08:33:36 -0800
Message-ID: <20260301163337.92637-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24A621C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 6ytk36u9n8zw1gf5eoi6k8spkstobche
X-Rspam-User: 
X-HE-Tag: 1772382827-876418
X-HE-Meta: U2FsdGVkX18vMWbCqG7FY74ZBqBXc9YxNHUSDUy5jvEut2KJHDAtQMP/nZM/whoVvsW9J/G6vx3bl6vNEpl6qvLn3axkQHC4151/e2WEl8farzLfiSieNFIjGnxTJPh+X0lfh2dRfz7g2NRI453X/b1UizamTtbc7fwoM3gyysC6gL+eLBq874D7IYaib3ZBphKOxy23PlyTuIAKk3FLzvZbTyeX79qMn9JtZ5wPjyNQjQJkad+qrNeVtfRg74R2MaTOGoD2S3tk56q2tCiEZ49IM7azkIlm7IX3IluiGph3YLT3AHIgf7x0jFcihseygKfoWSwbrlBz7rpx0JpXYKBM+Z9OMQAsvEW3Fy20gRMCcWYjNqYumCwM1gY5n7pTc+ryeVTaXljE6FtzJHU286i/X47sowU0Y3EN+0ZkguDXoT7w3iXiL+8dD91kW6yHtk0dh16RQUaYZ2E1A3TkSS7ian369wCW3dHBBquj6Iv+FFuCTe57USA/d9Kk/vfXzR+L+L+ykNBQXAqeX0TBOnqPQSNHOoFohTFdedy9NMczV3WlW8TAepmy1rOMKW2mCFH5epwPuNpbWqX64yD62cefyk/SZOaGy5WYwbzQoF2Yuvxp7chJFS7OgorR7N7jx9r77ZJa0I6RMMV6d9UYjy8eEiwbx5zDmo9Qb8Qegu6rHh226qyyEJL84s8eBE3LYE6AHSVBgAsriMqDApw+U19uE+cOEc+D5z7ZOdDNJEGibJqYcrrq74t9GRWDrRhNRIoaJ/h/RKB/Vp7SIL8W4W8JJJa5hPZW+XEmjJ9i+YZB6pG2yxD4e0dWv9we6SRcZLw0goRcNNQ+VOIAOZp0KfAFx95xTOlwEMw7qneoOHMotbQtI4aqlrIkjG/m6PL+Myjkib1gldtr3rgMJE/cunJuDuyxJuinoqoPi8Ei2SJFbOrmbO6rD33UQWcN7nCzZAXIytdegS+XKBAR69I
 gmL1lHtG
 OvaQBfCnskR4aWyll3ljIa8IFx428+zV1oESO1Y0TVA7TzbJI1zxsP+W6ytZ4EJQi+ULvB41VaTkABOtFibFdqY5dae4H1owPWxfIbs0m4JATSos9mZ9AWB0XBqxK3ROGoRLju9X9oMa/uQWagZNfmydI/4QPP42vBHWNIRWcP/WItQuDvScqCZSdTdx6qnS3Z/Kjjra1GUN9ZeyXRUPQsmAawjEvTATFj1fLd0gYlPABP+Oqr40f4IVnc7X0BJaOmBUzQv8jCScsW9Z0bIJ9nkjf5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Feb 2026 11:36:19 -0800 SeongJae Park <sj@kernel.org> wrote:

> damon_new_region() is supposed to be called with only valid address
> range arguments.  Do the check under DAMON_DEBUG_SANITY.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 602b85ef23597..a7f5748c1fe17 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -109,6 +109,22 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
>  	return err;
>  }
>  
> +#ifdef CONFIG_DAMON_DEBUG_SANITY
> +static void damon_verify_new_region(unsigned long start, unsigned long end)
> +{
> +

I'll remove the above unnecessary new line in the next spin.

> +	if (start < end)
> +		return;
> +	pr_err("damon_new_region() s called with start %lu >= end %lu!\n",
> +			start, end);
> +	WARN_ONCE();
> +}
> +#else
> +static void damon_verify_new_region(unsigned long start, unsigned long end)
> +{
> +}
> +#endif
> +
>  /*
>   * Construct a damon_region struct
>   *
> @@ -122,6 +138,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
>  	if (!region)
>  		return NULL;
>  
> +	damon_verify_new_region(start, end);
> +

The verification may better to be made before the above region allocation.
I'll move it to the beginning of this function in the next spin.

>  	region->ar.start = start;
>  	region->ar.end = end;
>  	region->nr_accesses = 0;
> -- 
> 2.47.3


Thanks,
SJ

