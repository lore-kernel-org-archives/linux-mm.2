Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C078EF44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360D66B0089; Fri, 10 Apr 2026 09:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3379D6B0093; Fri, 10 Apr 2026 09:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2755B6B0095; Fri, 10 Apr 2026 09:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2D46B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:57:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD9EB160543
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:57:37 +0000 (UTC)
X-FDA: 84642798954.09.BA73E01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6CCFB80008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:57:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/vxNCfM";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/vxNCfM";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829456; a=rsa-sha256;
	cv=none;
	b=TpJ4W8hkupKS33V9AF0F5k9fgo+Gor/nPmm4sjQ8/52a9yZ3lcfum91cxPPv0MCvg376AL
	RApeeBS76FCHuKALnWiUdnrKngptNRvzvFOYhSw0VMRBIlDhDbv0cElM8pYnVwMan9pvsV
	eSahX9ew5R4mQNoP256DQpwX6i+S0OM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyVwi5EGlehz7IiGyQOLLSMb/aMdJo9DFm5M/7Z7Y4w=;
	b=ZPGweIHrSHoz9BY88WCxTnutSVgWCf/0G9z9poUBaomEpCqDPScdgLncOpf5wbYA1QqZJR
	ptdfv8v0iiMUpRY7N5F1BLHPJHP7xAVfkfXgCs1oWL0J77ZSDT2GnbMxcNQjbsaDYAxAlt
	pYgDXdnNcouHrJBUzusxFGryIOpDlRc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B90276091C;
	Fri, 10 Apr 2026 13:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A279C19421;
	Fri, 10 Apr 2026 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829455;
	bh=2UJna0uTGN4hf6YnN3LfOZVqmiao4JvVlXwhKEIQG+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/vxNCfMeD0nE0Byd8pFfHDHw0yJqz5goeEh+sT5Nbdu5AfWsljC59hFWunu/iz+N
	 GQQqPu7dWX0WXANdZDShzkB/pckMJwt3MJxemYDv8EMy/QpM1sefMjouMolamdcfGm
	 AulfFI/JIkYq8jtR6AaQc1h12Vf6sVo2Sjq9J0hxZv5JQwulTzU8giLmfiVIbPcQyx
	 D+W3N87Z+erFX93ubSBIZp3/9xzZVeIncrlxNOpChNhnI42AfUFCt8MUk3cCur2y2u
	 eULKxjnS5+xfUPhCkqOK4WbB4LuBb4BbFoQaePjXZx6q1dVqv0FiQTvxbuEGrfgCvU
	 RyHi6h+mVWYdA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 06:57:27 -0700
Message-ID: <20260410135728.82274-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410044259.95877-3-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CCFB80008
X-Stat-Signature: 6uxq1u5zaww5788yzgd6rxsjuxtht31y
X-Rspam-User: 
X-HE-Tag: 1775829456-269803
X-HE-Meta: U2FsdGVkX1845c24MoFKikhzItr5V95aPZ6i+0ltMKfXOEcjGT1lxIIou+TZLqkcI7LltMz1pxEgdjwqY9Hk+o0rAG7sCYsbF8vZXd0VvgC6X85MPGh8e+a/2nX//l7ueDJ0uHmEFMjPPdEn6pJI+hI2auN5F1qW7tZwilO02yv7Cl1gkZNFE3mhJHAWIENzL7k2CwzCjVTadvOf4x55l2jS4+hRo36l7GPx9Qi73C6xqtHKaAvrvsktgrBf8XPTlk39Xoc3NAuPjeGTs7LJZazaxTTWRftZHUS1RSa8wDz6Hbl5GEf7NOZP4OW31JnIvbmujhL3IZXFrmGPx1qTFESk4L0eZe4zsMwey4WNmc0AywxF4yHhVIcO7hZGDrW2FlsLIZtDIG55lAh6XSYIZVzuT3diJi0qmUvZxWw4xbZiLvmB2mZQ1Rbwk0Ys8AIYU96V96DcQdWuj6lQ8u3NwogiIpNRyoqbCDDuEAkMs93t2BaudRMpPWpOBm6ZZ6S/ej6sQZp/lkbmhquV5IJtWdvxQ7ZN7VEsn4LG5QlS5s1yLskmVwCCDJw1vJhXFYK05hmYtuErM56HJ4GCNk0SBSRGFe14fc2dGjc9Mb8IL2c3MQJnjO3mVNpaFU2Hi7YMSwT8qN5kqCGpmp5TME/8b4WYn7qDmRa8FqTS1ZMou7ZlH2hXEvwrTpsEmzlfUaHcP9qM4wMLeaJ1ljLn8OGQCQHRwtlmKq3e3jg+oMiI9llZa7pmzMMyKou9JMyLIhx+EOb14PHzErUykp3eQtRuxbHXqdpmW7N5vI0HjgL1H+4GgXQvKKPm0RvZtmwrVs4I2x/45KUMFsd3eJtbJJRi10fbOPjk67t+Ar/LsG24Q2LDkYLnZbxtM1xpVz+an4Dgdqn+NUfLkMSClfHZRI+PLayNsnkQBjn+dOKOLRsTnTLV3Ko0J1zhhkSc7U6A0VDESwGXZVNprGcF8ryNJdv
 vsTI6IFL
 cBjxH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 12:42:59 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via
> DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2
> value. This value eventually reaches damon_commit_ctx(), which does:
> 
>     dst->maybe_corrupted = true;
>     if (!is_power_of_2(src->min_region_sz))
>         return -EINVAL;
> 
> Although -EINVAL is returned, 'maybe_corrupted' is already set. The
> running kdamond observers this flag and terminates unexpectedly.
> 
> "Unexpected termination" here means the kdamond exits without any user
> request (e.g., not by writing 'N' to 'enabled').
> 
> User Impact
> ===========
> Once kdamond terminates this way, it cannot be restarted via sysfs
> because:
> 
> 1. DAMON_RECLAIM is built into the kernel, so it cannot be unloaded and
>    reloaded at runtime.
> 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
>    Writing 'Y' does nothing, as 'enabled' is already Y.
> 
> Reproduction
> ============
> 1. Enable DAMON_RECLAIM
> 2. Set addr_unit=3
> 3. Commit inputs via 'commit_inputs'
> 4. Observe kdamond termination
> 
> Solution
> ========
> Add an early validation in damon_reclaim_apply_parameters() to check
> 'min_region_sz' before any state change occurs. If it is non-power-of-2,
> return -EINVAL immediately, preventing 'maybe_corrupted' from being set.
> 
> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

