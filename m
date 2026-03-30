Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5621061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8656B008C; Mon, 30 Mar 2026 14:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AFE76B0095; Mon, 30 Mar 2026 14:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECFF6B0096; Mon, 30 Mar 2026 14:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4253F6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:53:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A44F1A085B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:53:53 +0000 (UTC)
X-FDA: 84603628746.15.4FF1827
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2DF7820003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:53:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOylZcjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774896831; a=rsa-sha256;
	cv=none;
	b=lQOz4LGohiHq1uXZ9o5pJGNOQ7FjjAAth2c3rwP5Jbtc25tWbGQ4u8V6UcgLbDqbzNKePt
	mtCYQ9wAFS3yu+dxArKszb1bOR9YX7+Ajdb0ySSaIRM/9ZJRf5lfebFi7wjV5n79BDbIL8
	JTg9WO+L5JGyDcst8tLewp94MZnLQc4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOylZcjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774896831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOPmx7D4lJnGv8mhfy1r+7P3JieUvPPQgAmz2i26ZRY=;
	b=gUk5e1/O4r5KrcG16BcNoeOQeePkmhHxWF6U2wzWoL38kbJ7PKnG2OoWSiVtkO5TyOOhGy
	D15e0yi0iqWoGX87WBIw5vsgDxhJb1dyT9hwj7d+nEgTceI16d6F3U5MAAiWiLUILp6YQw
	AGTpLymZlwvTj6jKVINHK2fsO3CAZvk=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c742882d2a4so2031090a12.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774896830; x=1775501630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOPmx7D4lJnGv8mhfy1r+7P3JieUvPPQgAmz2i26ZRY=;
        b=HOylZcjcE9b0pcmnx3LCfN33TIvgDEIp+n0bdn1u4V3vHbX8W6pIbp0UDJMlHJGofG
         jDZ1i+7cusaxiKLV0Ds0w/Az+YBpraFrK82b6MidcT1DqB6B5qQ3s8Q8zIJ1z4JOhCtR
         TD7rvNDwUjl0CTlPPAkjMOx90TUNyNfOJkVwHpWt2VOYUX3LSpip3E5LXHJO0+9F/yZ4
         xqwYW9FWxMc86Mh6cFKZaBFUp8fhGHz4lws27b3sPFGOyFNjK+GgKd/DSVqn70hE/Nnt
         Wc+veYOrXtf8wqJ1w4CWQxHmalHLrJSNOgjEIezjzT9XDbGqKkahxkSGVb/uNrQjGuJm
         gSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774896830; x=1775501630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gOPmx7D4lJnGv8mhfy1r+7P3JieUvPPQgAmz2i26ZRY=;
        b=KWmZDqrwtZGsNr0O66GmYvh5r2er8/+ibWxulpOfNjbbGr7bXZxQVp6TDEfxlMYKXx
         ZkE1GAp0yTO8WIZwcRxFifPciXQzBQwcPKfkWBMR08ikoWvlKFxtdnN3sG9qUGNMA/aF
         yZOL2vf2eUVH8sjvvolUXvw1UhuXCF4XRGC+H8fs5+8DJ+nVaVOzQHJ5RJKVLRrUJAl8
         5C+020h2fKvDb0Jeu2LJoFIFWuGyZ+tZsY/zECXtzOa4+aIdQaFJWb06LKQCql83QL/2
         AmtzhtILOo3R1mTSQKeXroRIS/s484rleY0zqjbzX+bkUmt5gISsam6Rfbu0PkqiVPu5
         2XPA==
X-Forwarded-Encrypted: i=1; AJvYcCXrP6fLeSp5D9yVtzKegaTWBey4rQVbo+9Djp6CqAfZWjYalbIJD3SNCndz/KYrutGbeBOtR3/BfA==@kvack.org
X-Gm-Message-State: AOJu0YwMcx9MJ4ogpQ2In/Evhm9MNqcaStPnwP6sTcA1Q5BYl41ap01h
	xy5076SeH5+9CTdUnoct2SlmBxbmkwOIQVXIVo4BRhuxk0y6fdQ/SZUq
X-Gm-Gg: ATEYQzw+l3UtNlrUkFa940zd26rLy5390WTz9sfjsJ5dIlygdhdYK5fsm3s6Yh5IY5e
	7kJRCUEj6bmPORF0I8q30cXSk3J3v1WsKJuUElofOPEhc6f8ZS3suOZoeKjeA46W/xk71vAH2/i
	n9MXrkuvvXhr2z5bHOAfdZCHU2DzFAaTK0wjN27qy9atTILtC5GA2umX1BRzfsfATK2h50Zf2mK
	d64B9nSBR2GDtWUuyuNXJ0NX8O1qKfsioaNmood4jYXZZuqzh1cSyB8Ktx8vl7jIid+zRPi4WMa
	fW5ndsDoU2c+KkcX+ZsgW6p4+FPlXZTMM56xCWWlRFRCf9wLLMOS/ZJI/JGNp9e7EP3H5Mf/K7j
	Pr8e0U1uZ6k+QPi8KhbUMN6ue75uf9KGTJn7vw6Jm7I1cWWhzQRWOphLjIj0kskznUXJh1YJaa3
	TraDoc+YiLWec2jd+DOkOHY6px4S5gx66+YS0JkBaiDGpOhv4XEJw=
X-Received: by 2002:a05:6a20:938c:b0:389:8f3f:50ce with SMTP id adf61e73a8af0-39c87b5fb6fmr14525878637.56.1774896829730;
        Mon, 30 Mar 2026 11:53:49 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916baa6asm6708324a12.4.2026.03.30.11.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 11:53:49 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 02:53:47 +0800
Message-ID: <20260330185347.45872-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330164347.12772-1-aethernet65535@gmail.com>
References: <20260330164347.12772-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3xe3daq7dapfogeq9utfyjmnh11ka46
X-Rspamd-Queue-Id: 2DF7820003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774896830-458524
X-HE-Meta: U2FsdGVkX1/L3b2c7vTRR1W6cvg7fmFeIHaQXxOiX+cCjkJIftDstr/wxaNwSo7DeLTnK9r6SKliwG5mX6OshCTIP/oxrC2AyFsKOuyFjJJivYY+PL54yqrWPjRmGlVw2NqZQ8B81r/CNNIKlYC337u6OTqW9YHW6gaQL2aZPaebbeaM8PlvB8Mt++AwFoCIxa4K6BEpguantMlcPcP9DlhbbbNz/XWFeLbo4I6O5AnerZlLOUiIAPfoU2Tcu4J04fDQ2hRX708Ww5w+asOAUvmHojlh13ym5qKftoyAfhOX6GVU+lMHNaaW8WdF4IfePRAj0vvE5rxb+BQ4j0AqkxWsmYjSQVQ9oZeTEmyHu8ffBi04KoOuD2kIZTif8HiDnML205ETO7ImIH5unmwogDvCrbrFKMIYx0mfQ9qAEf+mrKgwu0saC9OK6+QIhbRllI38jUMLvMYE5ocxmhxOq0WeyfJdIW2hn3YyrbU01yCsEwK+B0cYMA823ZT2BYYMVHEhhCn7yN45Kk7VP+TG8j4igPiTL10t7n6+C93WV7E8NAvkTIOWABorumkUHtn9CUiXmouABNokvX7xSxF+MVjzkaQp1KEtYO31DCkhRbHSnD0W8j0osL46tVfpToDNQK3ANejFxb+RkdwQYo7iSY/EGrwXsD2jtw8Tq9iudGaPhJHE7xrAE/FeaPiGWkZK9h75R6Rc8DjCWIzhvOzYORPh+jdDjogQSUY/w5QLVsOeeU0Lwcfeuv/jJJhkvGPRjzNXVNZEf6PLoyQJTEIqoLzLb/YQDuRJ6lGhF9mFTEnxlb2PY/3SrR39VfvJKHEAGvFva15xfDcUiHk4YDte8h0GXJaN8ASuXUwhLtZ1JHtiV4wKG/Wa0fcYN8YkYRbtD+THSiggr6LVMIW4XU+LX8g4z0UMhGn0J/n2XPQmvDbhSUj6x5g0EgT3/ZYIe2F8xvPAGjCY2xzYQpnE0tQ
 ZJnYghDQ
 Jdy09DV6h4zTtJNO2jXZ/x2knEB0n3QdQ0esaR+rx0w78Nc++f4PF1uSRkQBw8A+Z/Qv7DQZ/xViZivbrSosZDLfl8j0aSQJk77EqMyJTOnTbi3lrQYIY3bQFI9r2yOZgYlnM6BqI7Qae1YueSDVXxCwFvDHrOIRDnhF3YqsBYDjOmAZk7aGaIcym3ITV3hd3cGJz/ZCIr2zBLjqAF9IDTM0SAqFC6KtQP7MRl+e21oYjJtFG4DtxDVazbyxni6Qym8DYS9kZ+dXRZFXabb+4lOd3Jj7Hgw8xk6Um30cZvDNVoxirc+J5/0JV3RhiBJqiAp7QK4vKfZREK9wFH3ooH8qxl4GHx8VA88QgXDZef9Aoe+aOfCr8czBMvCmfznAcDgbk71f1+XW4msb1cbKNZfybQ8U59OzH1NO4rx2i9rQ2yhqq8pEDgrULfKdGtQC87WE4nEuSsMVnqAv1l8WMw97XNVN5xfDstD5sM7hL8cnw5CylNiREPl1IaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260330164347.12772-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 636b179cc5df5a638d7988bd9de56ce4d8602f4a
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon: reset thread status parameters upon kdamond termination

This commit introduces a thread status structure in the DAMON context to
link the kdamond state with module parameters. It updates these parameters
when the kdamond thread finishes to reflect its actual state.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..6c71203beec5 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -2941,6 +2944,14 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
>  	}
>  }
>  
> +static void damon_update_thread_status(struct damon_ctx *ctx)
> +{
> +	if (ctx->thread_status.kdamond_pid)
> +		*ctx->thread_status.kdamond_pid = -1;
> +	if (ctx->thread_status.enabled)
> +		*ctx->thread_status.enabled = false;

Can this write race with the user enabling the module? If a user writes 'Y'
to 'enabled', the store function spawns kdamond and prepares to set 'enabled'
to true. If kdamond exits immediately (e.g., due to invalid targets), could
this line asynchronously set 'enabled' to false before the store function
overwrites it with true?

If so, the system would be left in a state where the thread is dead but
'enabled' is true. Subsequent attempts to write 'N' to 'enabled' would fail
on damon_stop(), leaving the module permanently locked.

> +}
> +
>  /*
>   * The monitoring daemon that runs as a kernel thread
>   */

[ ... ]

> @@ -3065,17 +3076,23 @@ static int kdamond_fn(void *data)
>  	kdamond_call(ctx, true);
>  	damos_walk_cancel(ctx);
>  
> -	pr_debug("kdamond (%d) finishes\n", current->pid);
>  	mutex_lock(&ctx->kdamond_lock);
>  	ctx->kdamond = NULL;
>  	mutex_unlock(&ctx->kdamond_lock);
>  
> +	if (ctx->thread_status.enabled && *ctx->thread_status.enabled)

Can this access freed memory? If the kdamond_lock is dropped and
ctx->kdamond is NULL, damon_is_running(ctx) becomes false. If a concurrent
sysfs operation removes the context, could ctx be freed by damon_destroy_ctx()
before these lines execute, causing a use-after-free and memory corruption in
damon_update_thread_status(ctx)?

> +		pr_debug("kdamond (%d) crashed\n", current->pid);

Does this log normal user-requested shutdowns as crashes? When a user stops
the module by writing 'N' to 'enabled', the parameter store blocks on
damon_stop(). Since the global 'enabled' variable is still true at this
point, won't this incorrectly print a crash message instead of finishing
normally?

> +	else
> +		pr_debug("kdamond (%d) finishes\n", current->pid);
> +
>  	mutex_lock(&damon_lock);
>  	nr_running_ctxs--;
>  	if (!nr_running_ctxs && running_exclusive_ctxs)
>  		running_exclusive_ctxs = false;
>  	mutex_unlock(&damon_lock);
>  
> +	damon_update_thread_status(ctx);
> +
>  	return 0;
>  }

# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260330164347.12772-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260330164347.12772-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

