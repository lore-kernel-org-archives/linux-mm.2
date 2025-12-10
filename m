Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E77D3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 09:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A176B0007; Wed, 10 Dec 2025 04:15:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B676B0008; Wed, 10 Dec 2025 04:15:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968356B000A; Wed, 10 Dec 2025 04:15:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 875C56B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:15:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 303711603D6
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:15:08 +0000 (UTC)
X-FDA: 84203002296.19.687E037
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 952BC120006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:15:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=plrM2pE3;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765358106; a=rsa-sha256;
	cv=none;
	b=4esxZnPPoUWLXAXpFSa35dN6xHwSjItazjmlS8Ctv0DXVQXQtImH8Zxf7L4acUaoYGP27K
	x7c5PnV0NdUr6+YGup6ER+4nv4qyNaCGGfnfbeMYovpia10Vr/WPhl9M97NQQRG4+WES8i
	GrHqgSSzXXLrKNpf2IYRyDWOgp1YIrA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765358106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6TUrSS722vjgHZsOHVXUUhP99f3RVreN6wv4OkjP9M=;
	b=akU5nmWrP1DHZDA86aHoXuMo06sigop9xHCOnnTnsDLpo/pEQXfaAcmqCmqflezz3v/XT1
	U2uWvCCBozGuRRpoQUvNIAoeXcLe6XWknRhqQjm2n0AogxEaX3xxvaY0eRKPGCqvfVVeOw
	xCZ/ZOixcQBIuWNfIqruOG5i3i5mUqE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=plrM2pE3;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DDA86015E;
	Wed, 10 Dec 2025 09:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594CC4CEF1;
	Wed, 10 Dec 2025 09:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765358105;
	bh=S42l+IFg4lVCAaNGZ+4P62KXbqFkfaIiQw3CI15+7Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plrM2pE3U3Vag97KDesGNar970xndDRJj+JiE8XGe7L4liZ+BT8BKsqKhdvjipJGv
	 4wB1lFfFKPyDehP0wxoANWPzk6DIYi8boK/5DsUbHiMRqAMl1fQOf9OcWML+M0FW1l
	 TIEo6BD+hVL4PHMe4KPcOWYiHHZcdgVJAZeyfveQJDvGBlcAcEPOsw3CDEHRkvO0Y7
	 qg0/kSls5yt8X7Je2pDoaAEWI0J/7rBZdjoWS6WTpB2Vb70u4UMPRRiuXDV7DsMxE/
	 l0MGtf2hS+K5bPiZkaQO/bMsxp2be/ygYZah5wprJChAUcH+EJyg1NQxuW/zZYqPCp
	 AqbtrKgWJTAKQ==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
Date: Wed, 10 Dec 2025 01:15:00 -0800
Message-ID: <20251210091501.55277-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210052508.264433-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 952BC120006
X-Stat-Signature: xosnf43m8nb4n6fifw5umaco169dxqp7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765358106-35097
X-HE-Meta: U2FsdGVkX1/7ux39Ib1mp8xqMJgmxhRrSq72VJhS2v/QpW2q8+rUtdy4JGG1RLS9finiCGZ/coi3bdAX4jqQSZ/dGi12LB5/4IDuuzXiyCYaKUaVdjfTFGx1NTpcSknhNOe2yv+i5Bz4JEzvVxq+3aKYUyY7al3FKpOjqUV6eKN+JHwPowjqwkQUNhUoXLcfpqKCSY4RyhpbTA5yZ0jptTLVHDdPGjGxo5aNGDUGDBLN/plNIP9bIWvAM1MiEwMGVeMb/T980BHbIq3oMy2R0zm4Cn2uv8HaXVb34LavORKHIl0kQaPtIIc6nTA4OXE23QTyotMt6cmFVsud4Kxg2elEbKPQmNEkzK/1MxWcSKsFj7QwmWkO9RS5Sqb6DA3YHGS/wHUx92Q2YeIIwid6wHZ87YGDhcdEekHmDOwOzS1CklggmqYSMZLyjLLcarfkEN+Nz/UeCGyRNuXAKdLiWQ9N7R0E+TwhZvexRAojekANtO4qqYh9ciFrUWIaZk25vB/da/DogModLd2ag39dtuHq42xGLQ/EOADGoDCSKNkbyEX9TLVutZO0r8zE9uf72iBN87boovhkXXSHyNvLU4ad+ltkIrsB/Y4KTmQbm8iGGuLcGZPP8RlHUBGxXyObJdBde2JhUtKp8hrl7Gw1uRzpmN+i2UJd5PbFtuLBmTQ0/k29tmNfQdFl/L0hVssZXdb3WA2ueYIKcRwMf52Sn3tH+50FA9PFj9b3VX5Wg2uOz6zfas84xlkmclPvj4+EG3YCpMuGx4uTaQEKi8NC6/yKBFX02WXQSoFeg3LAOymUOwZRHR58+M6+CTjb866FJGpD8WbUet4VvEFbaEfrSc6/bb5LEn3/Z0PvdpqUGYUkmxjfeqPaiMAYpVjEKJwOWc2IHG6V0oaQp1cs9tVZSY3xoAmn3LY/gMZreUh9b7Oal6SP9WQOGXEj6ENOG/UQuN1JXJyf74hsoQ332Dy
 XeDDz1i4
 sQVNA1Qxc5gIL+3S5LmhgErVMA36Gt8rYMqVqM0gp9GI8+KBu0gQX00HmtXSFy9A2r1JjP16VpqaFsn2jzBkeqFZaPY11JCa/l7NMRiLW8ruQ7CeDqIEf2Y3TWnI5KlR2qmY+La4RNsUX90JkkrmRVAxME+6ir6ovgrkFvlL+k5nL3egp/tcjkwEe7mod2T6JPQm8MFfFEAwsu8YCSIdo5644BpL0n9MxpDwu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Dec 2025 13:25:08 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Currently, DAMON does not proactively clean up invalid monitoring
> targets during its runtime.  When some monitored processes exit, DAMON
> continues to make the following unnecessary function calls,
> 
>   --damon_for_each_target--
>   --damon_for_each_region--
>       damon_do_apply_schemes
>         damos_apply_scheme
>           damon_va_apply_scheme
>             damos_madvise
>               damon_get_mm
> 
> it is only in the damon_get_mm() function that it may finally discover
> the target no longer exists, which wastes CPU resources. A simple idea
> is to check for the existence of monitoring targets within the
> kdamond_need_stop() function and promptly clean up non-existent targets.
> 
> However, SJ pointed out that this approach is problematic because the
> online commit logic incorrectly uses list indices to update the
> monitoring state.  This can lead to data loss if the target list is
> changed concurrently.  Meanwhile, SJ suggests checking for target
> existence at the damon_for_each_target level, and if a target does not
> exist, simply skip it and proceed to the next one.

Thank you for making this patch, Enze!

> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

