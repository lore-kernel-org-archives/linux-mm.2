Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6AF1073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B491A6B0089; Wed,  8 Apr 2026 10:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9C56B0092; Wed,  8 Apr 2026 10:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37526B0093; Wed,  8 Apr 2026 10:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 931BF6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:07:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C6155634D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:07:20 +0000 (UTC)
X-FDA: 84635565840.24.CC3A1BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA13CC0015
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:07:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g5/+NWsz";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g5/+NWsz";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775657237; a=rsa-sha256;
	cv=none;
	b=6sdxwSqyKf9BmhThJvsCy/fy7QD6RE1Gyz95MEmI6/v38f3YFCAcOEmSVX1ovY4yNFX9Ry
	CjE9uA+LjCR82qWVND9om3GvCJQg9UBd+Epy9p3h5u08sk8f5p+Sas0Muiumw1q/4BCmiL
	EC429+si7Ar2zsOtzxmvJ2Dayehoo2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775657236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBVBg/+sf0tR5BD/urIvEfbHbLpMBmyIIgSXtA+9GIE=;
	b=DFc3p8fpGLsNH1w4nbf1WriPTbTjHYVon/QPeaK8VNzIRk+GvM6CsJuk3j1uehtxM7LAoY
	1CVh3UxgR8+XxfxtdVCvThayAjerTDZoQcJKFPNnUeSwoapRUozFmwMAl93EJpyVJcHccL
	VOpilxm+gAzuSrBcWYGs4L4/ddEFD6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DE62600AD;
	Wed,  8 Apr 2026 14:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B02C19424;
	Wed,  8 Apr 2026 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775657235;
	bh=G7UsI035wI5orPhSU3xE/Y5v0SdHInqMR58UEOUbkME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5/+NWszb6/Ie8fH6WTzo+0siwhQ9wok1hskRkrt94a7cxEovLBjErhQ1R6t5SWS+
	 j7eLZae3eNlVAqHWLPgCjfjRCw/ZKIg8a/IWQco8czjSj9xwZWRieU+CdVLQL9i6Nr
	 VnlbNsFFwwX9hHvSfthGAI8CcnWA0jHtQTlYz2AIa+2JrBwKDjkW+Voq08Qu+XLshY
	 KYkdmRuGqqVifSAxFbPy2GYpZnoB/hRJNtElaX3u6NsXWyI7ZYM6PI89GT3IE+N2dr
	 k3o3w2Q5pf5X106mtG8nc+Drsze473grNO4yB3ixfzc2tzjvK8v6IxFJuk0LgMkrnm
	 9GinOU+jUTyrQ==
From: SeongJae Park <sj@kernel.org>
To: Lin Ruifeng <linruifeng4@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	chenjun102@huawei.com,
	tongtiangen@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: support freeze kdamond
Date: Wed,  8 Apr 2026 07:07:07 -0700
Message-ID: <20260408140708.89729-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260408080652.1745410-1-linruifeng4@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA13CC0015
X-Stat-Signature: fyi33uhptrbwhzetpm5oxh474hi64n7b
X-Rspam-User: 
X-HE-Tag: 1775657236-171174
X-HE-Meta: U2FsdGVkX1/iANUDz1JrlO8VFPH+N7yhD4Hw4vq64DRd4Xg+ITkF18LJDbcLZjXZr1+TUFNCgT/vb6QyXmKnVkjPxpgtpeOz2abeWJaLAnD6sXDRdUvQDf90Xt91TtlHCG//IsJwm9d2PpLO7YhdTpzxG5/8wIkipPZ9t/eNqLfJ1Mt1mRKivoH6rGi2k4G6I82V8sZj6Fvhr9EirPH0Zu0TlksemJj2BX7cHY5voClrPkyeNoQ5rMExv6C/1URGZzNgL+t5PuiS7utnDHtnQ8+kqtYxEeKJ7Ssr69sfgvD3XI+z4LXDxrMuuHnnwfCBxfQi5RUae9L3dxenyGMgKs7bYmUkCdEWLL5nk7qssLA/KR0RYt7ve48uVteZ1D6oZIcFonBvRGgufoLAUVWs6sOZrnwt7n++U9rzDlZmXxOTX2OwfI44Bk1V7Lnu46CWQbVNWsCSn8gf3zVn5hf3Qt/aFqoInovvCYgkFvl581581QWDaIxMVhAYe7ch2GtgF5ClaULbxsxfjry8vAGUj1EqwWtgofD3Uabgp42M8o6g1lVURirSvahwGWBL8ce6sYYApp34vl9A0LTe2kPRuC9tlIvffI3L1sD2KhtOBLywydR3gcucxoFevENsjoSQlf4q58pJbNifVJNIWr3C/Syn0lt5Ar9XAZINNV2q/InERvS7iRMVNZYMPmSDDFfb3QGn+qEMLkqLAv7YYunVJsRVSGvlglc6f/EHpj5bV/Gkb6v1Zlk3QtuCYqcYSpfO3DINCI9YrMhRwqfvY0lRGe19kqkgkp+/KzWY+geva/ygBr7lpATlO8HtX7Byubo2J/Ow+UZ68vY/aRFT7H2L4NlrSmsTawzRE7U7t6hhQOrNoWgwDJzJNP/0lEOWSBBOQAeOYPW2GKBi8ngpdGe1UXJ80ftbpMwX44OhPoPIc1vEkwMof/XxkKJFLhoPgDXsqPHDJh0iKzVCSeQFeJl
 rUVwNN85
 /XXhw9AZdsYIKX1MsuEKCcD8SeY4gpDBR9Ff7mt4pMyRUvLff/2jFEEmel+wTPB0mbrNgwrGyjR+K0AvjVYDiMp/hJDlnUAl+p8KO3IMh4iHGB0yvRyFYELqKHHrjNMWdEmFhi0qjgE4qADM5Na3jv0hKmiirEUm/r61GRm+pPKM4P+pCOkXIJUrgb4MBbmkSGejRLbWsYYuPxYfU7CzGv3oXBuiV1ldfYN0GLZU0aARXc05KYtvMJhXSsmZ+hXTiYI32XT6sQpbDY2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Lin,


Thank you for sharing this patch.

On Wed, 8 Apr 2026 16:06:52 +0800 Lin Ruifeng <linruifeng4@huawei.com> wrote:

> During suspend and resume, the data monitored by kdamond is
> no longer meaningful. Meanwhile, since kdamond may involve
> I/O operations, it is necessary to freeze it.

I'm not used to PM freezer, and maybe because of that, I'm not fully
understanding the motivation of this patch.  Could you please elaborate the
existing problem and how this patch is fixing or improving it?


Thanks,
SJ

> 
> Signed-off-by: Lin Ruifeng <linruifeng4@huawei.com>
> ---
>  mm/damon/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3e1890d64d06..5cd1f0aed66b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/string_choices.h>
> +#include <linux/freezer.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/damon.h>
> @@ -2753,6 +2754,7 @@ static int kdamond_fn(void *data)
>  
>  	complete(&ctx->kdamond_started);
>  	kdamond_init_ctx(ctx);
> +	set_freezable();
>  
>  	if (ctx->ops.init)
>  		ctx->ops.init(ctx);
> @@ -2774,6 +2776,8 @@ static int kdamond_fn(void *data)
>  		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
>  		unsigned long sample_interval = ctx->attrs.sample_interval;
>  
> +		try_to_freeze();
> +
>  		if (kdamond_wait_activation(ctx))
>  			break;
>  
> -- 
> 2.43.0

