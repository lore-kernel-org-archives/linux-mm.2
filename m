Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC0EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43296B00F8; Tue, 30 Jun 2026 05:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EA46B0107; Tue, 30 Jun 2026 05:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58D56B0108; Tue, 30 Jun 2026 05:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B440B6B00F8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:23:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41638403A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:23:32 +0000 (UTC)
X-FDA: 84936041064.13.50C0475
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 958A5A0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:23:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwaG8N67;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811410;
	b=tggQ88Yw/WxffkELsaD7P5AtPMIZ4BIbME06Kn6x1kvb+7dXPj+X6eqh9rn7gcyLYGrZcC
	WhAcveYi2xJDe5hLq3OpdOE8f2SruehymzhZLaBssnbI+2KbC0tqRMImc6p3Uw43J+GK3o
	JlBQZsL7JXtBES2+DJ7hPNfhLhRI5Z8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkkU4CemahsX2lCu5FnMMTHdANSRG2dmn9y8txXDAU8=;
	b=win7ioniO+l7JxzlRST9itCtwXgjNLLLVUO69UkR+uUQCO14uGT44DZa3crO4UE8bA2uCD
	FQIrXD6gB7BgHATtCUh6CGWh7rfXx+fb1qBhWcv80E2tS0lVXn4JjjfGVPeYr7kO/BKytF
	qDHNNB6wrC7z/29dkMVmVnMKNkcp8YM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwaG8N67;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E451341AA4;
	Tue, 30 Jun 2026 09:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39C11F000E9;
	Tue, 30 Jun 2026 09:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782811409;
	bh=MkkU4CemahsX2lCu5FnMMTHdANSRG2dmn9y8txXDAU8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XwaG8N67GSOGZMPrLMrdz+gdj+cqIp4BvOJ5rjk7sPlWs+NI4nojTxxCTuWCG0iud
	 JZj8uIEqbbuSKgk6N47fpod/TyFdT8EvOuADsyO2vR9R6zxbgBbPjSDOp1KOVvu/RQ
	 DJkPX+4Jok8amI/VKGPJWwnjdzhzTbUp/2ZVX1QYqMy6BeiYmOh7l91RzhoK1YflGt
	 HTnW3dGjKh7ZMFvpXiVid5jaiqbYFaw20kWV8x+d005+95+Dl2oGCrzYLBQvchEnua
	 +jONQJtXy/2BYnipwm0ZaXvfsfBcioEpMYQkwlztbUydBgzOeB+kJrhC7uiCmKFE/y
	 B9q7Mvmi71c4Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Zhen Ni <zhen.ni@easystack.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260612031105.3350181-1-zhen.ni@easystack.cn>
References: <20260612031105.3350181-1-zhen.ni@easystack.cn>
Subject: Re: [PATCH] mm/memblock: Remove redundant pageblock_align() in
 free_unused_memmap()
Message-Id: <178281138932.625070.4768611038394499878.b4-ty@b4>
Date: Tue, 30 Jun 2026 12:23:09 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 958A5A0003
X-Stat-Signature: e1unnfg1d5kqs6746bx6qnbwn3esutr4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782811410-433726
X-HE-Meta: U2FsdGVkX18Zpj2QiZfp0zhX2YHveEHkln2v6bUjMpawjbKUC/ef2rlpZ+dfGiVfHni1Phj4qmMpE2n/nxc0QEXmpaSriHKoxxFWE9O13SvRiBZIpLXnvqO9MuRN9IpRxo9WZSRn8sshRdH44HT8igJJW2zHm0HSMtWP8yHq8YLiC2pjHNXpIYLpmJyfwIatyi3FUupLhx7DnPWoc1ZvHY66hZjzwuhV+DcPpQrUBVqIUvQ1l+FqJnWmlEJgRk8Z4FQeYdxE7ZeiOGgujXkMJO2Y77CDJe+vo64AvqYvuxsIGkUm+6hbyfI9axPzpy+lWVWVOefAEH6cdunvZq59oJirirDObkLqcV+QBxxdyqpB2kQGD+4eMSvJZLdlURwU9xDI/gg6YZOeUyUbfhUzm9bvkyO5zvk4rkuK3ZFO9Cd8mahEvquvRMkWkbKoxKt9Z4oeGZ67PSk9onfNMqj3sEvoB6wR6YuMiFu+ko0cMkSfm8Ap+H7/YpCrQsnqQORt5a7IQNGb4IymgkbCG9uhGKwnQzQTOxBUiFt3QkiJfhGV4KFRwlDEKhIkwet/UIx4Qb+KCD2uY73UkRF0j6lhdmGmYZXzoqdrgrdgPIT9W6uy9zfvUZ0axVM2lekj+vzZOsESDXcEt5RWcKQYnjvsI4nrB0kAQc/+X/5F6anAgTE/jajnh3BV17Fbrzfp9I+yeAvSoMJhJ0Coiy+qHtM32hw89IK/DndD+joAilKm23jSDHzAwF9HlvzUaPcFluRjDvkxC/i8hBVo3eCyhNNaJXfc4tBa/uNmldzlM4FK59jBS9DxZ6c/NMjnrcu6obM7ZygMt3H4JFddyBAOARMfaXLMrZxojNj+R5MN80j5jTIxFY2k25c7pgMsGV+YL9QoQGcmcAghPAk1oQRi2wGptSzivcKFXT3tiy5WA4V1/X1mS2f8ePIvaKAlXDRdcCAvCNZUNhVEN5yF7C698wA
 65RRu8O9
 Saur1qSx5XSXU3FI6ltSmgxa2ZrU/cUulthUIEaRKuJTZcovZeDqxVGtZS3r9GUElGxNZsabh4t9/4dCYSTjeDQU9VXPWi0uNa6dZXDeRa4ViEHEjvE5F6acx6OE17h3PKX0FrSv+P9N30QFoJqztb/pFL7fDurvQFqUPk3mxo5cyyFrWQ4VdJ7MlfQbKy4fGcaVdH4MrWAFc6LkAvkCN/O+HMymw8nCds2sD2bSIa8fvYpBuVjzMpXI6ywtfOUWUo6BQXmy2LcfzXFTqVtrLIVsMzhf4zucjwR/W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 11:11:05 +0800, Zhen Ni wrote:
> mm/memblock: Remove redundant pageblock_align() in free_unused_memmap()

Applied to misc branch of memblock.git tree, thanks!

[1/1] mm/memblock: Remove redundant pageblock_align() in free_unused_memmap()
      commit: a5d67c54d414ee707333ce179d4492e99122e5b6

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: misc

--
Sincerely yours,
Mike.



