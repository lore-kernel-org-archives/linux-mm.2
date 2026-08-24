Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C53AC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188096B00A1; Mon, 24 Aug 2026 13:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160B76B00A2; Mon, 24 Aug 2026 13:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C866B00A3; Mon, 24 Aug 2026 13:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C595A6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5000EC0205
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:35 +0000 (UTC)
X-FDA: 85136781870.04.C354A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9672C2000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:02:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjp281es;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590953;
	b=d+IBhyQqI0Vi4iDC1gzTwfH8PeQ/v9jEWqnQ05uam4gvJ3DmSeRKMeGbt0EAOnOk47Jcqv
	yi2VqoOQ2akz7oDChZ2x+B6I4g43frSVyXOmsieqixtnxZJlVwyuIXsb9pWnsQ/3oVQJhL
	tzDS0j3Da/rrlkQAAqfyGR3ZZKR24yg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hjp281es;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sb19YqNCvHDPnmH6ryJdd+X4+F9dTKDQQXONQh6LBq8=;
	b=ri9vRHnktgCc4DlXmJaEg3w84AlIEqJuRAxEF08oC3FkhYntCcqc7ICl01gn0D7OL7k5gx
	y7btBd2Ws2l6B0Z2rBFxpgi5mVlY1h2RubTE3cjNs3AGpcp32m7IhNqz5jGeRy3yyi5FBa
	oIeMZSkSBh8kT+x0ZsVzT8KU6C5FRC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB1DA44057;
	Mon, 24 Aug 2026 17:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478681F00A3D;
	Mon, 24 Aug 2026 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590952;
	bh=sb19YqNCvHDPnmH6ryJdd+X4+F9dTKDQQXONQh6LBq8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hjp281esMOQl/VRkVAZ229TpQYamujcYyyzJ2Qu0HNzTx4zzP4v6yYeDeJQIYHb3o
	 CNoiWqbewm2buRJB71JwX79xm4JQhoBMFedpJ4YfhQyJuLD3pOlSC0kzWtPUuiQp6H
	 i7rfx7Yw9thOVTWCiW3Cde9jpp/q05EW7JJv22v5HC5IC8S0GVzeg5IxNDj6gNTx+I
	 fbYl2Azo0+kqG2PqVIfMrx7JRPNk1nms/URo8pZHfAHXVIoTXRTUdsP0t+RCTWeGJd
	 WhQXOcZafmYkrCnUsHcJPkSB0uFxfofpUMmJyveqh5liQR4vwcifSjGvbQRuz2EwqX
	 WI4dLXAYt2LKQ==
Content-Type: multipart/mixed; boundary="===============4419128066865244280=="
MIME-Version: 1.0
Message-Id: <4c2bee332eb4173076cebaff6988f2d2ee283d7c6fe43993e957335cdc319a6f@mail.kernel.org>
In-Reply-To: <20260824160523.3907021-2-usama.anjum@arm.com>
References: <20260824160523.3907021-2-usama.anjum@arm.com>
Subject: Re: [PATCH 1/7] arm64: uaccess: Add batched kernel nofault accessors
From: bot+bpf-ci@kernel.org
To: usama.anjum@arm.com,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,linux-arm-kernel@lists.infradead.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org
Cc: usama.anjum@arm.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 24 Aug 2026 17:02:32 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9672C2000A
X-Stat-Signature: rss5bjy4twbzkme41ay1hm7crxft5ycn
X-HE-Tag: 1787590953-175600
X-HE-Meta: U2FsdGVkX1+jq+y0QkedlJiCKvekJl3zxknorr2qF4AYZ8Ezy5zV6gPPPQmA7NcZZuOaWFntpH79GunFqUMaTGuXQCj7E7XhLoKQqaVeCDwBe0Q0KgzM/I0/lZzYmqcjvaOSewVB0Bv6fQYJUnlXvx0ZUhENKkti3PnBvGvK1sLUcqAwhBMkEvKraeUycluL6pH/nlup3DzH/VJ/L60KkmrqGo3AUIJfsDIIVvRQewymMDUS0NX4lxX9gQ2nWDEXZcBiQZnr+6xQyIrlvREUnODF1eRs4m3dnQGcczVtWDiKlmdU16R2ef/jZrTAjlk1xyeb6z/IqyThpddVAAlB03HAI1QdbJavSxPgJC3RdKpc92Pc9ZBqWuYKuP96OgYOYzw4H4jcDTfebIng8qxA7hXB1DGP4sjOrizX0Gdl1PZcOKk32G9RqipjtWYHrSzf/HvlLpIYTmNVsJkteVxCumf8gnmQDsmjPjpA071eh/G4SVFNlaZ62AC3SH4x2QJCxmh/2+0wyf8/SsEpoIvF4nNcbjdD2Vjy60boND5+Hax8liK61DzisWv3f4dz403o3dzffdhEbu9qzQ2z1uPO5fefIXxmrKnfs8HOdcG0Cu2LbVGqBlcZRYZveviKgkLHKVvV6YDTE4gB/FvF7ibSm3RKXcL3NziKmawTxzxxn2d82W7J8VLrx+Wwo9DZrnsngFfY7HkEN4GP/ZAmZzMNQnEM0pPPozdfCMTvHIC4gBwWpVuo/qvVTpWkdXqHzYKein94g+ysTVfdu7UHpreLxSMBRbL1xaWgCrmOov90PJojcdc6Auc+utTbEOVK+9MSSMHr9Xj/iur8baA6wVCEWYLTHucVGrE8jVDPHtjgD+WVEjEoggiJPgREqFEF8k8zyNW37Tut6nYd8Es2Z2rW653CjKJ0jqHQVK14mDpGudPEC+FyJmrxnQlKlfE1RTqZOan7An4lpkZfofruKxK
 04yOaJ60
 MQdhW86tbexqBoK3MVJLuPRzW+73wYmbGulI03Oi8FG67+w6z0ubvs2oEjk1McSMU8n4Nue3SwIkpscHHkc3xh6O+Vm+FA5Bln5XTatoKizcvJdJiPLczAvEtvM6AVRgeDTJyujocLvSmrbb2D93J61woiP2WHJqTF5NU1cXAz6yfC4MeefhV/qJ9CssVteVtEXMSsG/3WGSLmbeKakrEs23qDctXxFJS+nlmBv+K6dWGGe6o94L8UrRzqoNg4OEKue9Jh4HGhENlITR/TWZbkie9PdFndUquaRdHOyhLbsWeK+hAdS0dgWfd/u9Q1PjC/+W6WAh9xbuQEjFoI4Qi5GBKfG/RTMjPwY/IdBPnR1AC7oYL7lo9xVqdkpjkj1yVtWyy1F3V5l31FluxE/Stc4u4/zoYwyXbAqmJp14ySPGM3/N2dZzDUi0mLvua/qrjkFbeG9/MjYVXUxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4419128066865244280==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index 9f5bd9c69c24..1a14eb2a51dc 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -270,28 +270,43 @@ do {									\
>  #define get_user	__get_user
>
>  /*
> - * We must not call into the scheduler between __mte_enable_tco_async() and
> - * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
> - * functions, we must evaluate these outside of the critical section.
> + * Nofault load without TCO management for use inside a
> + * __begin/__end_kernel_nofault_bare() region.
>   */
> -#define __get_kernel_nofault(dst, src, type, err_label)			\
> +#define __get_kernel_nofault_bare(dst, src, type, err_label)		\
>  do {									\
>  	__typeof__(dst) __gkn_dst = (dst);				\
>  	__typeof__(src) __gkn_src = (src);				\
>  	do { 								\
>  		__label__ __gkn_label;					\
> -									\
> -		__mte_enable_tco_async();				\
>  		__raw_get_mem("ldr", *((type *)(__gkn_dst)),		\
>  		      (__force type *)(__gkn_src), __gkn_label, K);	\
> -		__mte_disable_tco_async();				\
>  		break;							\
>  	__gkn_label:							\
> -		__mte_disable_tco_async();				\
>  		goto err_label;						\
>  	} while (0);							\
>  } while (0)
>
>  /*
> + * We must not call into the scheduler between __mte_enable_tco_async() and
> + * __mte_disable_tco_async(). As dst and src may contain blocking functions,
> + * evaluate them before overriding TCO.
> + */
> +#define __get_kernel_nofault(dst, src, type, err_label)			\
> +do {									\
> +	__label__ __gkn_tco_err;					\
> +	__typeof__(dst) __gkn_tco_dst = (dst);				\
> +	__typeof__(src) __gkn_tco_src = (src);				\
> +	__mte_enable_tco_async();					\
> +	__get_kernel_nofault_bare(__gkn_tco_dst, __gkn_tco_src, type,	\
> +				     __gkn_tco_err);			\
> +	__mte_disable_tco_async();					\
> +	break;								\
> +__gkn_tco_err:								\
> +	__mte_disable_tco_async();					\
> +	goto err_label;							\
> +} while (0)

This isn't a bug, but the get and put variants now carry the same rule
in two different wordings - would it read better to keep the two
comments identical, or to have the put side just point at the get side?

The comment above __get_kernel_nofault says "As dst and src may contain
blocking functions, evaluate them before overriding TCO," while the
comment above __put_kernel_nofault keeps the original "As `dst` and
`src` may contain blocking functions, we must evaluate these outside of
the critical section" - including the backticks that the get variant
dropped.

Also, should the wrapped argument line up under the open paren here
(four tabs plus two spaces rather than five)?

> +	__get_kernel_nofault_bare(__gkn_tco_dst, __gkn_tco_src, type,	\
> +				     __gkn_tco_err);			\

The continuation line sits at column 37, while the open parenthesis of
__get_kernel_nofault_bare( sits at column 34. The same three-column
offset appears in __put_kernel_nofault at line 412.

[ ... ]

> @@ -366,28 +381,48 @@ do {									\
>
>  #define put_user	__put_user
>
> -/*
> - * We must not call into the scheduler between __mte_enable_tco_async() and
> - * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
> - * functions, we must evaluate these outside of the critical section.
> - */
> -#define __put_kernel_nofault(dst, src, type, err_label)			\
> +/* Nofault store without TCO management; see __get_kernel_nofault_bare. */
> +#define __put_kernel_nofault_bare(dst, src, type, err_label)		\
>  do {									\
>  	__typeof__(dst) __pkn_dst = (dst);				\
>  	__typeof__(src) __pkn_src = (src);				\
>  									\
>  	do {								\
>  		__label__ __pkn_err;					\
> -		__mte_enable_tco_async();				\
>  		__raw_put_mem("str", *((type *)(__pkn_src)),		\
>  			      (__force type *)(__pkn_dst), __pkn_err, K);	\
> -		__mte_disable_tco_async();				\
>  		break;							\
>  	__pkn_err:							\
> -		__mte_disable_tco_async();				\
>  		goto err_label;						\
>  	} while (0);							\
> -} while(0)
> +} while (0)
> +
> +/*
> + * We must not call into the scheduler between __mte_enable_tco_async() and
> + * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
> + * functions, we must evaluate these outside of the critical section.
> + */

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32751368606
--===============4419128066865244280==--

