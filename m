Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3805CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACFE8E0013; Thu, 21 Aug 2025 12:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E1E8E0001; Thu, 21 Aug 2025 12:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173D78E0013; Thu, 21 Aug 2025 12:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 045578E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:59:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2B9B1A0493
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:59:15 +0000 (UTC)
X-FDA: 83801375070.26.F75A689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 320D7160013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:59:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlj+MY03;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755795554; a=rsa-sha256;
	cv=none;
	b=W6tlbZ6qgqt/z/mG0D3R1ciXSWLYGghuf3ywE2NGe8Ad3BAGtqPWcNR2cuOkZiiAuqE8By
	qjrUa/35+fj6ShEBX5v1hFhhkUknzFvroA4teo8SbhlrNx0SpydZ5/+pveyAJsCnW5x7pG
	VhuwPOJZGAM7AfiF0yRsH4NjBucjsKY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlj+MY03;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQ/cDFfjWJP4WPajez2z+JpjI3arDhlyuHRUj3zMXgc=;
	b=FjWcyvturvAtUq6qsDoS04sw+xyKy/JYtSBvtN4kS+pbcFmF+0q1BQu+CHTLNKHMm4ZjIk
	voo86LDIHcHFk2F1oqJBbK5RyoaAcXTjK2IJLb3rXTTcn7+dzG7aQFJjyVyNLfPUh0I/QY
	tQiGHEbKUbq3ngazfIz28hzOWGF+zDA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95618601F8;
	Thu, 21 Aug 2025 16:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278FBC4CEEB;
	Thu, 21 Aug 2025 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755795553;
	bh=lluNge2cWGquXLKIKjAjPmT4YYpm8dK1DV0H182H8zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlj+MY03Ri0+qCpt6vlRjDsttq+/Tpvtz0u7ivy1P1So/s98IONLh5iE18yM/xUnn
	 zVGoSQ1Th6Apgif30FDi42/4ue2M/7HZwJBB7yGFnlBLi4ct6gxRyhCnJB7Q2dvnnR
	 lscIiFco7yEwKKRbM636Zs4vXI+y9EyDnFwO3WVKrMsrO0VB2pdpVh8TPO5OyUa9rI
	 UuyMk1jiP1syw0EIma0xOUy7atHBezZ1lH2R3/5CBZ6pfvWm79OMYFeFFAvT2qhb0p
	 OrWrLsUxZ5ovod1iYxqeY8VdQZoe43RNSWO3lucjmmzvWaxq8H8hhlnwRl7LYhX2td
	 eno4p/QFg7o+Q==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	apanyaki@amazon.com
Subject: Re: [PATCH] mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()
Date: Thu, 21 Aug 2025 09:59:11 -0700
Message-Id: <20250821165911.79204-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821125555.3020951-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 320D7160013
X-Stat-Signature: 189jfspy7gpz3k7w41bg9rd6tyggcfqk
X-Rspam-User: 
X-HE-Tag: 1755795554-932164
X-HE-Meta: U2FsdGVkX191iRidoK08eNRvZuBT4a39rHpM+5zFbu83Q7caqneKajxn31Xx+7ZCLhabG8CnVB+o+KDC46oKv99PaWu73U5ibLj5kFUq6b0eLnkvGrhhNKZYKkPvM19lYm4Ar7JqrCBbtyrECmke60obaKBWccdmwRo/fiB3bhcMB3v2Ar1ij2EHZw/z6pOaKmFsBna72aleFZEPo8eYC0jsRBWkV81373le3L97VhS9UE6DLFQ+xtmBNNnD9dutMwRTVu4Dt7BwgibYJZX59vEQX2wd2+WQr/lqFm6xDWOQ0Ydg+9aOqAN4SgnO92wCvgb9rDAuLYJEHiQi504i3PVTUhGFCAlJWzJMunpdufcrBsimVVYWLprqVZLya5VhQ6nsyAM2XTq6DmEYV0dXsCQrZ1x6aFgjUoXVuMU2ABUGP9MUh85Ol7i/Y4oCkND7d88rQ4HenhcpyLXe5sIUh2acRlmTe7xgJuYKUK6uae1kzlcuvnJDr2YR675sAPHC0SpgdWZq8ElBALpe7GTGk3bdUSB8OB9S78N+Kt1VavkapY9LWkDrvyw4+RJq1CB50R8R7VKOMWxkrqCO+HlKfEM656vJQWn1E0hg2JPaybi05WIATi2p/PTE2JnIdpgG//QiFcDWmGBVTYjzepCnw95Hwp2tsyaJ/0Ro7blfwcgNwIb6lDsoXUfJP8It3sCGOxFXmWYGOQKRcM2H9nFCi56mBhSU76LeqrKihWx7xYnqb7m44E0N5PH0MP9LclgA87RyP5sux5bGps0JYZSJG3sQcoO/bVDzOExCNkE1So956K+TmiBAlDYTq1Cfj8PZPVqUqZo2s1m4JDbOb2KF1y2uiq+w2jjUM6/j+FpMMB6xWLdEEE0RwSlM+xaIY868ysfbRSTu2h7RwCPlC4+EgEHbSkTbl+B8xgtPMtjxCEFL59DxQnrPmi7xWK0cITaD3jcU+fP8btyi3ERITp1
 IjSOagNx
 ZXl2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 20:55:55 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> On 32-bit systems, the throughput calculation in function
> damos_set_effective_quota() is prone to unnecessary multiplication
> overflow. Using mult_frac() to fix it.
> 
> Andrew Paniakin also recently found and privately reported this
> issue, on 64 bit systems. This can also happen on 64-bit systems,
> once the charged size exceeds ~17 TiB. On systems running for long
> time in production, this issue can actually happen.
> 
> More specifically, when a DAMOS scheme having the time quota run
> for longtime, throughput calculation can overflow and set esz too
> small. As a result, speed of the scheme get unexpectedly slow.
> 
> Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
> Cc: <stable@vger.kernel.org> # 5.16.x
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> Reported-by: Andrew Paniakin <apanyaki@amazon.com>
> Closes: N/A # privately reported

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

