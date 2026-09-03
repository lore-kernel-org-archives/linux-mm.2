Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488C2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AEE6B009F; Thu,  3 Sep 2026 06:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C0A6B00A1; Thu,  3 Sep 2026 06:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D106B00A2; Thu,  3 Sep 2026 06:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8CEC6B009F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:01:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 497811A04AB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:01:55 +0000 (UTC)
X-FDA: 85172009790.06.BA033CA
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 43DD9140018
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:01:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wd1wqw1U;
	spf=pass (imf26.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ce8M/7qhkjbYOloNei8s08cubgJ3TDWZ5Dcu7749Xg=;
	b=pz9Yy8468lWsuOk390/YKrUtJm9pKnFWNfqZW9BlCOQjswVLM91oXxf1kYCWOXFani0Rzw
	OeYY46za7TTRJqYci3XuwA25NZZjoBUFtv7YDP/x+httj6bTwZxrb9YHAEiNt+SMArLv/z
	n0q0bDK9K+rg98Cuzw8gKe4/kjmM650=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429713;
	b=qt/VyRfoRv9DLB6KBMJCDgk30nlAxakFZqefg5jLSjmXlbUjwAK74MOPAVSzltESdZ2p50
	UQUUBmQ6e0OVHNVK2S8NCt4QnL+ovolX0PNHwuBZ93gVbQf4LQ1CuMmG7cetJHDVZBC3Du
	3mVeH41lNV6ymnADJ2FGvEJjUSk4GTc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wd1wqw1U;
	spf=pass (imf26.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so2116064a12.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788429712; x=1789034512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ce8M/7qhkjbYOloNei8s08cubgJ3TDWZ5Dcu7749Xg=;
        b=Wd1wqw1UicMOC/qqLyYx9H74M51G65QLpf8rkRNziaDr/bdryP+c6Q5Hbl2U8aZM6U
         79TIhvyR/NwtAQGotIadB2gk3NLhEPA9DOvMoJraH6t/zzYIiV4qN5QNlOgYbGwEo4HY
         CNdTQjiTfVDGA3nSbNlpTPaFNgPMhmN17F9zZXkJ93QHEpk99WFY2b1wmwBx0dr9Ve8S
         kGJiXrD21HPMfF2f0vefBkM0LidqAuHuaFPh9ONqdb7VnY+c5gb99pSGoFOvGeZbIqMJ
         6159YHal2NTsDuAMKXNWiLBczlUe8Bg7/YsenoDk2Cr9RcU1pHbDGHHts4xY5Wcceemh
         boEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788429712; x=1789034512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5ce8M/7qhkjbYOloNei8s08cubgJ3TDWZ5Dcu7749Xg=;
        b=icdPur0ImqKQR2H96Az8aemX/I21aUuWNaKAo7li9Rcj5XLC4E4Z9krWbgxv8pLgB0
         k83acKMAPpKP6cGHR2ZSAx+Q1Ito0g7kL3R77WsHeofD9nX70vjqlIV81SAq9aZgqeWk
         8uwZuiaTLXqGWOgc2ycHeJDSA84Jmmjn9DFg5eUaNjeCx0Qnu/qu86gTzL1s/mzkhRxP
         1wBgGTC6TzYf3+ngK6nahf86iF6o7AxTu2WscmheqLXIvOJlqQ2Q3+G7YdqQL3HC0BzZ
         bSzIFL/c3YQyonKz11WjriZyW7kauYH+Y9SE3G2MrAnFJ1dOelWO4C6Kta/9ei/h3VUm
         RTBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRZaZfkpQUWq+VVHnm70h3AA3K+MFsRFNuRczQjgOqjHeSSAkMADVx0KAgJ/lRCZxUasz6ZTdO6g==@kvack.org
X-Gm-Message-State: AFuF++kim9f7G7OP5+ykmPkBybjkihcktNE9cJyncB/UhD2YOpSWnddd
	U+h+ClO8cICgzUsdL3bJ8wyd7SjmFFkJswxMZiUv/C9919IzsOWX+IRJ
X-Gm-Gg: AYBFou0U2xK/JyHCgQkqSExdfU3rgLp/m7Ta4m3vModZkYIv3rYlZK7O5YQKJnPAsZB
	O2pEpBOUzPg6VJUxlhbKUWhTqssryBh0SyWpu8gkKczoz/ASDWBK6PGd6huZiVabIceTnNw7oCa
	9w4O4yHg+9E23JhLNauA+H/u8FHeF8iZwyN7aHO0wyK+OGWytfEUJ6HYfpsAAd8C82cW6n6LAmL
	5MdZnp4ah8gAolgPW1hIsml8Suyc7NKZQbg1RNFGQwfGF4ryKNw9kQFI7jn9U53urgqOSc6ODzi
	5ksZU1f2IrjtCTFj+w9QqTvG3LG+4SJFtKZhAivoLFkh+3MnhHheFJx0NRS/xXWi9NGVNT//lnA
	/+pdos3ZOdfd4WXXnhsojfR3e1mgRGG3/NXF/lwVbpxCypjyGox9IbGMIrtym/IXdwhyNieTXPh
	aI88WdBjFGCmnjieQROUMAigf5eG8cmDZOVR5DkV2ZK85duvzBNEBOZQAvqUg=
X-Received: by 2002:a17:90b:4c4c:b0:396:4c63:7193 with SMTP id 98e67ed59e1d1-39aedfc9616mr16315183a91.11.1788429711355;
        Thu, 03 Sep 2026 03:01:51 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08766a2dsm4456658a91.15.2026.09.03.03.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 03:01:50 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 4/4] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Thu,  3 Sep 2026 18:01:41 +0800
Message-ID: <20260903100142.106449-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902002725.108635-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 43DD9140018
X-Stat-Signature: wea5wc9i3xajfg769s8ggjtwx5u8tej6
X-HE-Tag: 1788429713-16404
X-HE-Meta: U2FsdGVkX1/k1kKDotzdxRbJ9u7uaXYliXqXsUZ6aWqEoNASu9ApmUujfq1c1VZ5OmUXsS7ebuFqVgrdH6WDIXdVaT/bNJJehs8faE9dFvUDPZQPXNapt16UONhmom1LMihKqkM1yUO+GPBCnaDgNZ9aVhIvg9eT/XNjz5b+zLMFiOZb990uAKNNgnXV50YR9gHah9flnsce4iP1Qen769qP4O6XWgDxvbgQv1sB7HLV1L7wSP9vldcKhB/XojMEWNXEoU0AS0wTHl7IRcw80s0/1xTc0PTApZNDANxtu6oYAJL3LXGBeTWGlJNKVPrepZIlXy0/arrWFizZdpmc1Ys8aZfPRmNuCOXEvrwpi0I5KEUg9faZ0j2zdozPxl/lOS+NCMMv5sB+13qtR0NmDb5IzKWepZ16UhnAN1O2t7OY32Hwe//XhXE9x7DY/UffKAkxAkVCYZFbBIK3DTin1okrGxLBNxmiWbUNiyMRdUI7Li/Uh1ZjfN57k5qpMy4r0ngJHxgo6RiRuPzn3LO4FySaNqpf5Y4if1a6S4HZs3OjvIihLYwQ6TY0ymHmxV2+W54yJ5FNMwM/NyOxPwzvqS4uGPn271HdosSnGejDHPTfhy/pi9M49i4qsoTqjVpolm6UXKt8/i4GLRjBAbFl92TS/3ix6nf8uEjZeaNHx+5RcOnXSsxVV0Bq6yj21i7kNIpgq1tAoDxLjx4LjJNtOmehxXE0rwSLzhG5Qqdzb/iavlHS3QLPIj3YBC1kGZVqkEcGfeyULOw7hINnHlOiPlXSMR4tXl2UFqIup2Tvb//n4keAGaTCGaDP4CYcYlaV5d8KnD3htayv8Hef5vzm2klMo46ku++jou2BC8gCKSj4Eyosp/eKMrJfKuA9Z6zZxGh2zKD9Pe1riXGwTbjXfPfLHzWIDL5uKS8zstXwsOVm4eXaKXpPMXuKdTuRTbToDQ8K6I+on/FcqhY0iJ5
 263F7bxK
 4U1IU27/avZdP1CeBx9LxIc6Y+G94vQGzYn8dVq3Bv8TqiduZbLlXWSyHpsWoxqvaEvpkv0SpswJR5hdxIPeFns6q+WG0GK5xuJCHA7cW22+jaZyF1UYiqfWr3XVbuBsdj3e2RkY/YJz9WHi+BqTxpT4c269lI4bq1aV5nEPwAFaAIqVUsZ/fQpU6A4LnunU9aS8YJPVA5aZ0gSCOhbghhX2mRqBaaR8+TdOSA64t8ZKN6YJeQZsvpUoIugQ5/+9q58j4nmTTHvuMoG594RVAb1QdKothJJPPteJ85lJQYpmbO0dB6wALbWJfPFLMYwhFAuxpOSyKYmtq9mQ1+TFT+XtfXNAZg3HSY0MBdPLzuRC2DkBlUvfe0a5YUFnCjjKp3+GFbqqcHznS8vpv0b3lrJf8x7VAZJCbZrSAHbKIOU6km8fd/4P0h4WZc9EJjjpi4NO4RkW/2tG1P90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:23 -0700 SJ Park <sj@kernel.org> wrote:

> When 'refresh_ms' is set, DAMON sysfs interface periodically updates
> auto-tuned parameters and DAMOS stats.  The timestamp for the next
> refresh is initialized when a DAMON context starts, and updated in its
> damon_call() callback function.  That is, each DAMON context updates it.
> However, the timestamp is a global variable that is shared with all the
> contexts.  When there are multiple DAMON contexts having different
> refresh_ms, the update frequency will be changed, depending on the order
> of the contexts.  When there are multiple kdamonds, it will be even more
> chaotic.  Fix the problem by having the timestamp per each context.
> 
> The user impact is not very critical.  It does not leak, corrupt or
> crash.  The update will not be faster or slower than the lowest and
> largest refresh_ms values of the contexts, respectively.  The user can
> also manually ask the updates on demand using kdamond state commands.
> That said, clearly this is a bug and can easily be reproduced.
> 
> Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 3c81b4c91ac0d..dcb739ce0a729 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1788,6 +1788,7 @@ struct damon_sysfs_kdamond {
>  	struct damon_sysfs_contexts *contexts;
>  	struct damon_ctx *damon_ctx;
>  	unsigned int refresh_ms;
> +	unsigned long next_refresh_jiffies;
>  };
>  
>  static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
> @@ -2213,17 +2214,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
>  	return ctx;
>  }
>  
> -static unsigned long damon_sysfs_next_update_jiffies;
> -
>  static int damon_sysfs_repeat_call_fn(void *data)
>  {
>  	struct damon_sysfs_kdamond *sysfs_kdamond = data;
>  
>  	if (!sysfs_kdamond->refresh_ms)
>  		return 0;
> -	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
> +	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
>  		return 0;
> -	damon_sysfs_next_update_jiffies = jiffies +
> +	sysfs_kdamond->next_refresh_jiffies = jiffies +
>  		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
>  
>  	if (!mutex_trylock(&damon_sysfs_lock))
> @@ -2271,8 +2270,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
>  	}
>  	kdamond->damon_ctx = ctx;
>  
> -	damon_sysfs_next_update_jiffies =
> -		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
> +	kdamond->next_refresh_jiffies = jiffies +
> +		msecs_to_jiffies(kdamond->refresh_ms);

The fix looks correct to me.

Moving next_refresh_jiffies into struct damon_sysfs_kdamond gives 
each kdamond ownership of its refresh schedule, so refresh activity 
from one kdamond can no longer interfere with another.

I also checked the initialization path: the new field is zero-initialized 
by kzalloc_obj(), and damon_sysfs_turn_damon_on() sets it to 
jiffies + refresh_ms before registering the callback via damon_call().

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>  
>  	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
>  	repeat_call_control->data = kdamond;
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

