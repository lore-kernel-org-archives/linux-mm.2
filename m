Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F6ACD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FB36B014E; Sun, 31 May 2026 12:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400AC6B0150; Sun, 31 May 2026 12:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316F86B0151; Sun, 31 May 2026 12:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD886B014E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:30:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B73140495
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:30:55 +0000 (UTC)
X-FDA: 84828254070.15.83567BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28F738000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:30:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=et2lfG5Q;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780245054; a=rsa-sha256;
	cv=none;
	b=Ti0MDCLFqz0N/ehD9G26k6YlZ7mQ1EGCZh5oY/mbrabvKSRtYBGqlWDGnpqOeJbkunyl1z
	t7wqOt6vklsY/5hGVsAufp7Ct82yIcBBMbQ0VwQvT/Uy7+YbpkTMLQX83WnK2lQ3+ztnoj
	aSSrhthKtK3HNIhBaE6g/ljtxRRNVAc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=et2lfG5Q;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780245054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooHLjrYde68IF9paeXUdfTOnJaxqfaEudXi3V/Gpzfw=;
	b=5wc5YLPojYrxkL5gTtvjlouvjHdOPuUCgv6wq26eWethC7y3tHpAbF9pUwwepLeD2CPcur
	wACXb0E1PUqGzU6tSad+8PfWCwI43e6eEVMAfvaUH6erdPlOU8IvNt2Od4lSzJ0FhkPdaM
	0WAHpbVHm0+cicpgzfsXrVGUnKWsWGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A233403F2;
	Sun, 31 May 2026 16:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12421F00893;
	Sun, 31 May 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780245053;
	bh=ooHLjrYde68IF9paeXUdfTOnJaxqfaEudXi3V/Gpzfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=et2lfG5QLbYIoA3FgGbare5SGurLAvM5KBRLjqiOh9RUqierVbKf9wzyH3wgiGycU
	 tVJhavGlm8ky4grJeEbtbgCylyY0hbuqLt/+qECeq3e6+idodR2N/iiCmbGpLWd15W
	 X4ouvEPx3w9juaWoxSGHtEad0nv8FsGaOGB0uWm1BWZYzQ8T5JNx3h0qPdWxxLyq1b
	 4wsEqQx1Ntt+GA/1nNhWfSyn2kEqOItpBH8H+15iwZdJhyVjEv2afMgIjHwC8bI3Al
	 dC2P3qG+Kw8nNQ8BeF4js2pbcn4dQKerZ3462G/HkGjQvXkGJs7YKEG6NtOFx4Q3Cl
	 qzWAJvrxehV3A==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH 1/5] selftests/damon: prevent cross-context state pollution in DamonCtx
Date: Sun, 31 May 2026 09:30:49 -0700
Message-ID: <20260531163050.98908-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531091724.84381-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28F738000A
X-Stat-Signature: 3s1oi3s7sqk3i5ug9trkiic9n5zjfudf
X-HE-Tag: 1780245054-814708
X-HE-Meta: U2FsdGVkX1/OTenL98Rj4oot76XrrY9XwJBcapyfmCjiliEiuQe8UEMVXEG8QivR6DPx944ytOGPWxFm3c3/MCJSx33I8NgsPqtPOOIG1fQLheBTFBTyUHFLGnn4IYAPGTqWjCV+mngug5ELP0RzKQmDa5MC7kz5z5GrS4iqTUwvJ1zwEswlMw9GgEZdDsMwD/X9ZY1GysDrSbhbHsmtx22vqjPyqWkgqW3j1iWiHIX3HVpXaPlhXmsi5J4ZFXMUsrO3ORM1KFL5db30tA0jLhkZELCR+EJ0BOZEd8k9rSF0Fu6q7El0RiFTyWK4Z46zRcxbNegjhjJqG5fRyYiaJg64i9cBCa6NBzjlpos+yL+CaGTQaItJWTJZk+9mjNMyiRyCwqqwBlNkGkI0sz9rMHaZm3lo+iNvb6N8aOknVBUqn+nNXra6rGOGD/FVwCzf3FnyvzF3qbObBBHFWTqp/nbDDHkMBytQ3n9DopolFtl5NP3Vd9zWsdYH1dymfJIwirQwCRac0Rr8Cd0u06rrd7Gj3TVWlYzgldH3jIhMVodzvWsBk6XLD4ddNrc3Qn2Pi0OO+2LFWVlDeZITTo/qFMepKqtLIaiaCNKFZV7effmqTgKgVu9VpInHpufW9C/p6CRD4lNUJ9K1rR0p+ngN342ifB0iDS3TrwjSMwttFm7YhtMNbiJsrPj9BR/zS5ttcdcbW7LyId+8jf36n/MHwp+TbzecFWiYNorJQ+y6MGOEWCVhg61F6fJYBXYS3MDNjnWBLEouzetEhNdEK3oQKjiAd8YlJZI+Lwd7t/JInYzbXwm1HNXeMa43ki7Sp1NGLqRBE6FVasyoJjJjZe3b4ZAAmk2Em2sJ+aS2UMiFbAIHYdGQWTUVQX7WBaUZ4ELWCSQYW/cKG6U1CgIgwO4IdrqaRCVV8lqE0+iTufb/qLjyLMnotsTE+CEtlgf7WYCKtljaKCnivaE500AYi+e
 cq+czN7A
 5zjtBZRDIc0iIwWHBP+i0e0CjjMNKFnwlQvFGNMC10ETPve47s/RhsVp+XpcWtCBXadMlchfrPEtCVbOZqJZAwOaAkDyMSuaG8ZoOPcp3fffqENy54rqtjFZ/NjgAd0620BK4IqOkCmFxRm+13aIqGGy2ib9cUhe9GTUh9TyHPrTRqfIeAZnkQqu3niIzrF727jBIoOUdzAh9KIX0TD2BFHbjwXUz474dP0wWbVc6Z8nvtNB6bPWN7WJxzxBmG/m9zkWfvcJv844QIBjJVzt0AOvM/VlZNB58lWV7m0j17ApRKBTkn4tYoNBoaA5yz/jfbFGbJg8lYzZ3Ch/VtWN8KL+c1A0Klz8vMM4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 17:17:20 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> DamonCtx.__init__() uses mutable default values for
> monitoring_attrs, targets, and schemes.  In Python these are
> evaluated once at function definition time, so multiple
> DamonCtx instances can unintentionally share the same lists
> and DamonAttrs instance.
> 
> Replace the mutable defaults with None sentinels and
> initialize the objects when needed.

Nice change, thank you!

> 
> Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>

checkpatch.pl complains as below:

WARNING: From:/Signed-off-by: email address mismatch: 'From: Kunwu Chan <kunwu.chan@gmail.com>' != 'Signed-off-by: Kunwu Chan <chentao@kylinos.cn>'

Other than that,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

