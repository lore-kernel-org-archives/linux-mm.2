Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F0CCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0868A6B008C; Wed, 24 Jun 2026 10:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037596B0092; Wed, 24 Jun 2026 10:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E699D6B0098; Wed, 24 Jun 2026 10:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB7BD6B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:23:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5929B1A032E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:23:16 +0000 (UTC)
X-FDA: 84915023592.07.CD85DEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BD1618000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:23:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9lupM8B;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310994;
	b=Rfa9UANJjYLPtvDHOsqMCSXIOqMtkQpFHJ8beTRSMyfRXfCSW+Cj/Qjjek8/h5Kgs0z2jA
	RdE9MrqLF9yoSrCQi8rMmu1i649jv0q9v1NqQS5FJlEGvURbh9VK6iitaS2h8meG3SPJ82
	QOZQZmsim5tMN6ok0Rx35cKQPrhfIb0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLMupxBZwRCVLTY4WQy1mEXLNBRM5yd9s6atKbpiNdA=;
	b=Uow0u0+CgfYnMRyZBGwv/oSrkr4vAwVpbrMRa7hFDb110ATGZR7je4BycZ0+P6aE4MSclY
	Z+d5VcsYx632vgB4WS+JQvgejgDnwUooSeVc7CT95YVz9ZK5Wd9dzMho8tsHtm1xVJQEzO
	mZM+8q6M0Q2U5kxWaBJEai2aqXSk1p0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9lupM8B;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06CA560018;
	Wed, 24 Jun 2026 14:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2FD1F000E9;
	Wed, 24 Jun 2026 14:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310993;
	bh=WLMupxBZwRCVLTY4WQy1mEXLNBRM5yd9s6atKbpiNdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R9lupM8BqHwWQQJwtSAxanv9TtiBCcbXoNuIy9jKW6PLooFAcWnTLJpMoUqpY5266
	 gtW4PlqhNPp0r5p84RQtOAminT1CAE13dfKyhoRLTgOhjny7oRuNsHxlOgcVb37veZ
	 r2bWDAyp6hvbq6l2OShzKnEnxTfVtDFzB7JilMpyUADoN7G94kO4S6W/yuUmV2fuTe
	 0IeRxhHbpqCi5ciw4lC2MU8WOjXoPN7XGuV1/EziPbXkY0XDo+y+KnR1Iy21QZywgF
	 r/wlqH3IOnsY6weKIp+63FTaDlZ0yLHwDCKO1wQ/KjNG1W1Kp0EeYPSlN4pbrjmftO
	 kJZJW/l5P8Ecw==
Date: Wed, 24 Jun 2026 15:23:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: fix data-race in folio_batch_count()
Message-ID: <ajvkK-vcVzgll2Tm@lucifer>
References: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7BD1618000B
X-Stat-Signature: 5ratkpum7sttwp9ek1cohd7by537y4jx
X-HE-Tag: 1782310994-88755
X-HE-Meta: U2FsdGVkX18W9XOtvtKkdIban7EvjabvEahBcryYoDakDh83XQgAuKM1r4NtiyAAZTUf2jRj4XRbndCRa0LFdKaHVwfxXtRGOnwjDzJqojP0RZdGrWGlPWjvRA/fvZQSM8AhvAdwcfSZozGOss9k1+GQx18H28XeXqOKQterwX3vfvA5SmtkW2dxyutBlpaGtTiG3ZU+5amx66dNJCsicyGs7P07o/VWLRjzYUp5ZFlE/mwLNRvdTHGH5OCPTvZkkt5iHr+TMuMFHtzq4MKDiuGA/XMnVPNrtC8hkOfmq0AahkMUAIxaXV9acN0jX+cetVDqWBztj/XiZ+5NbQWQnbYCAGNqCX2I6H8OoayNS+DgqUOg5jf+QC6RIXOQSGGuObkVKFP8PAEk4Lezjmrr5maDmSMzhRLKMO+RKyNwMMBSIQ+keN58z5D+Vz1ZraIZ41+UfCnJoqNWi+XkTgF9PIEGohj16BDAz6+dqWMOKsweiK8D7bVZwK0JqO2QqfTHvPSa2/Oiz2tqJaTLtdPsqO59eQEHFnKbfdfWegThAjsEzPzUhSCi/Hgb8hkHOCOgc1KB8DdaRySPAUHo3PLN/frHPaBOuaeo2e24V2v0cuM+3dCl54MgBuaoDkbCu30CLchLGzpUsleiY3H6Je8GTYkUDcFkDmzXkuzcj0PUkjyADuFWj6zfuYFj6Mdwwmd/BxqsZ/yaSDXE1CdiRuxbTn/3+c7fp7vX0ZR7hGzWD8KruQ7ZIPVOAsA4K2ryAbzk81zi+f+04mbFEWNFYD1b8S/9kOr3Uh6bub0foFD9qc3JeQ4FzxLkIOn/HbfUON40b0XOMSN4KfnlsfHIm/YIpayHBf2DxZDsuDlKNy69ujl/0MmohUFUH9ENbLV1Fp+H9CboIHPeK5oRf+AxljtGYEIVv2Y4jEaVM4fMVCjIh9+8vZYHbKs04uT6ZJqe09u7FEui2wA0ZUVmDDK7Jjp
 izwDBrai
 pPYJ37w+ZOT8FczsA3htpHqVn3RWtDRowzOT9vEikv+ua912L3J1CC/SB7Glfk8a+4X8/CKOfbOP2/rUPm2s23VZY1ktND5Cwl9G39RZ/UVLN/ZarWXj9VVKlFJkkO1nAq2xLqBei2glAXr0m1QL2/Mgmq0DQ1Ys3BR+VAdYCL69RYiLucVMOux28tjFvQO/lB/1fkpaxMsPc4yWW21mbotBYMwRNqjTKQD/femyCgiSpIbmd9Og48ExaGtzQf6mM3+NovxdWq3AICfc7aN1BFAKnLHQpkv06PM3oWamcV10upCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 05:26:06PM +0800, Xuewen Wang wrote:
> KCSAN reports:
>
> BUG: KCSAN: data-race in __lru_add_drain_all / folio_batch_add_and_move

Where? A syzbot report? A local run? Please specify.

>
> write to 0xffff98fe74c015f8 of 1 bytes by task 45153 on cpu 2:
>   folio_batch_add+0x30/0xe0
>
> read to 0xffff98fe74c015f8 of 1 bytes by task 45175 on cpu 0:
>   folio_batch_count+0x0/0x10
>   cpu_needs_drain+0x253/0x430
>
> The write side is a per-cpu local operation (folio_batch_add on the
> CPU that owns the per-cpu batch), while cpu_needs_drain() reads
> another CPU's per-cpu batch without locking. Reading a slightly stale
> value is harmless -- it only determines whether to schedule a drain,

Then why are we adding a READ_ONCE() in such a core helper?

> and a subsequent check will catch it.

Where? Which check? Be specific.

>
> Use READ_ONCE() to annotate the read and prevent load tearing, which
> also suppresses the KCSAN warning.

Tearing on a single byte? Which architecture tears a single byte?

I think you're actually more concerned about the value being optimised out on
assumption of it not being updated elsewhere right?

But acutally you're not, because everybody else uses a stack variable or _their
own_ per-CPU value?

Only cpu_needs_drain() is the odd one out right?

>
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
>  include/linux/folio_batch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
> index b45946adc50b..1e31e058e19d 100644
> --- a/include/linux/folio_batch.h
> +++ b/include/linux/folio_batch.h
> @@ -53,7 +53,7 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
>
>  static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
>  {
> -	return fbatch->nr;
> +	return READ_ONCE(fbatch->nr);

This isn't free, you're breaking optimisations here by doing that...

It feels like the wrong level of abstraction, but actually I think every other
case is either stack or per-CPU _on its own CPU_ (please check), in which case
we _can_ suppress the check here but I think best done with data_race().

And see the kernel bug bot report, you need to add:

#include <linux/compiler.h>

Too for that.

>  }
>
>  static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
> --
> 2.25.1
>

Thanks, Lorenzo

