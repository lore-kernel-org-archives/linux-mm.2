Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45C8C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F256B020B; Thu, 13 Aug 2026 04:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8D16B020D; Thu, 13 Aug 2026 04:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70AA6B020E; Thu, 13 Aug 2026 04:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79D926B020B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:33:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7F74405EB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:33:13 +0000 (UTC)
X-FDA: 85095581466.07.BB83CB8
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7F85C40004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:33:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=h2XNmB6e;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5SXwN8z4wJfjren0Th1ktpv7Vbq6Vy95XZXPb5aTWM=;
	b=u0/zqGNQeSELEhcJAxXGaccOdQdTRGwX4A85A+TBe/HT4z6jTAQAnUXmdkdaz3aLMUQZJd
	vGn9FPChEgQWjQEk/MPr4OwlRkE/f/1jnI6LL+dG5HTcT8Jt7V7YCe5uLT9Bt0fRhUNUbt
	+SsMF0n0a8zhXasEHOMLtZUW0KdTb88=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=h2XNmB6e;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609990;
	b=jfsJGUBSledJNJ5bB7w95n0HCMM0eqj8/po1VJqxDJZEZBPhPybmaRBSW/kqGXGBKOhfSs
	u20kF2qU6qx3dSUpjCHo5VaEcdASHfklukNCmAkcxqlYQggtMqPe5j9lFh3KkunjMlIMD+
	cQarU+8/parb/d8oTWye8GVVFmnq6RY=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=v5SXwN8z4wJfjren0Th1ktpv7Vbq6Vy95XZXPb5aTWM=;
	b=h2XNmB6ez+mJE4tHecLxLbI2QLj9IQVV7GxkpNC3b63p+jVJBly3ALeziIaWQLF2IiOsh8fL/
	jFbMKJVizf+RLFVGQdqyyHIy8ltt3no8YmthIcJJ63qV6RaybjTNhSTPd3dwm6FXpatZO3GBzeg
	JGmiMPnAPjYP0tO3XftqSzI=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hLJX761SlzHnGch;
	Thu, 13 Aug 2026 16:32:55 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 434DA40575;
	Thu, 13 Aug 2026 16:33:03 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 11:33:02 +0300
Message-ID: <ed32d112-2873-4e29-9d4b-d5bc72b70f52@huawei-partners.com>
Date: Thu, 13 Aug 2026 11:33:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm/damon/core: handle NULL ctx parameter in
 damon_call()
To: SJ Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260813035001.97364-1-sj@kernel.org>
 <20260813035001.97364-2-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260813035001.97364-2-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: jt8acwou6q3s5oe3xoeh4ixbcs8uur69
X-Rspamd-Queue-Id: 7F85C40004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786609989-72144
X-HE-Meta: U2FsdGVkX1/NO3a8gCjthINFQY/D3SzFYKSdXgX779b4mfrEjlOUxeXPvXQtRB3fCobAMeVgk7dWsk04WVEzJhHuISU9KqMJCjRAOg4eV1tYm2RiE/EmSILtKqBZlH1jZERYcuaSfHPrz7sF/fURv1kWN9tOL3bkbb+LLak4wYmf23EybkG61wkOGGigmSXmcRy4B48dop8hWuhIIixyx+eZhDNuf32WFxqEYW2usydFmdYvvqJb/dMQ2Gl04TnczmbSxFN48/2eC5utXd1mcpOsObCuIWWtxopa8HkE7Zohxz/a+IrKqqTpEzfXtkCmiYmkoceNX9in+z7YbyRQpBxFavDumGHEf6noaR/PBG172kgJN4AieLDk1i2y3kBEyRzfdPeUXoPcoH5HyqfAqMt9c54J9mmMLAhmXQcpaixcGUDu+sEGDlPhFzIdRmmoo5z/NGcLBiluFk1cXf137iEN3gpejoObLuEvZaEgsvk25yuz9U6RreAR61uqap1/EQ1K4xreJBrS9rlfy+2o7/xAKrdu4zNRiH4WrHPIz38ChsyzDI0TCyNJv9CV5FRjYTsI12gPhChua+dA/SveJ+jk/P6u7znPpszbV6Mh8zO9F4zDY16fETwJslXKdnTv29lkWv7g/tlUovQfIChrb/y1mN/13QYLxa0PUquq4lmFQcxnz3QmEezUU3AZWHTXjLqr3GDsrDJnecWm1RceIGFFQ7TVM22Spo5Bs6L3URUYUV3DhVwo2g0PXfVhv6d0/9tuHMLP35qTUXKXykG8VXV5ErLSJFstW2kKyd5wWc+CbAme37O60x36tZIxo5QehClNw7icjNx8jMDkcdsye67EcQRctgQU/mlTP7jkOyHrwLk4HiBaJ8QkwnSwWddTzwTVV3pedYvhSjYHO5jCEHotqpWNUiA/fI0Bua7CG3OYpJqghKqxWJ1O7DByFNswgE+bmlbvIRi54OQXO2t
 aR93+Dmk
 dQCNDAkkAZhW7r55yJZQOIrkpYbnI+51L8JMdPRAbNZQKOIOTsLNKcgpt4+Nsjv2d7Dmi8dT6OA4bowU1Fp+5kRFUphnJ2KiideKyolMT5PSZL8zBctl9JYg3uUC3qbA+dPMC3HbAw7wCu8sSlHC836PRTUsVdG4K6B2cW7jhDhN21u4CQmeytVVqsbPWed4sEcWjaSO8SfUMx9Dwb9O92ov/Z798W2w4LUfOsxn3P2r6jmICJcT1MRMZjCq++dFQ6O/cLduQBB/I0SCR2vRdwlpfdJREYZNXOX+a/gMnPd3zUQCMnzBP36I+5GIzD1Oh5RFX3FlDbMlafTbhTdtZTGFGMlS2T0e3bloIbwvYM/Hf6lJ4Fx/gnlpp3VpmTsJH/tr5V3cfmvWrxAztKUapJr/9RB2uGF7Qq7gp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 8/13/2026 6:49 AM, SJ Park wrote:
> When NULL damon_ctx pointer parameter is passed, damon_call() could do
> NULL dereference.  The caller is responsible to avoid that.  It is easy
> to forget, and there are many damon_call() callers.  Meanwhile,
> damon_call() is never meant to be performance critical.  It uses mutex
> and completion.  Add the NULL pointer check inside damon_call() so that
> callers can pass the parameter without NULL checks.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 92631a36d7b51..5882f9c94c47f 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2188,6 +2188,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
>   */
>  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>  {
> +	if (!ctx)
> +		return -EINVAL;
>  	if (!control->repeat)
>  		init_completion(&control->completion);
>  	control->canceled = false;

I know that this is a minor optimization, but how about moving INIT_LIST_HEAD(&control->list)
to right before list_add_tail?

It doesn't make sense to initialize the list before checking call_controls_obsolete.

Maybe this suggestion should go in a different patch.

-- 
Asier Gutierrez
Huawei


