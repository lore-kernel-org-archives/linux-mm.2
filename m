Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B2EC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A336B007B; Fri,  7 Aug 2026 10:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EAFE6B0088; Fri,  7 Aug 2026 10:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327BF6B008A; Fri,  7 Aug 2026 10:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11A876B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:12:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8283BA1CD6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:12:23 +0000 (UTC)
X-FDA: 85074663366.27.ECDE6CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8C111C000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:12:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovbPN7Me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786111941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yPFn7yHkyG0BJL3IlHOeyOih//+Qc5xhI7AQ3jvymc=;
	b=qqjqdqOnMGZeEpKPdxYj/AC+R9N7e9diEOrJ0c0KFAC9Bkx7glXFHaQFORw7w/0anhwU3z
	EuimAowIFDb66d8boa4kwtgK3v+RHADjWODK0Gg0KC6S3RZSUX5dXb43PMn8trn0ILNj/5
	3YWrN1Y9N7Qto7zkmBm1SQspGP1LKO0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ovbPN7Me;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786111941;
	b=bMA1iA9KGPJDg1dH6jh9FJiL0rCQgoFc3OkZdiuJmkDWUcRrQv1K4VFTDvGXwiVCxVh32W
	DfVZAuLah7eWSJClY9u/ULgr9feyIho4F9lJiJkmFSHgWsN6PGTOkIT+hlCIY5bqeFb/yc
	tCfp121STh28nEUcP6hhNnJIZBN868Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 176AF40A23;
	Fri,  7 Aug 2026 14:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10B91F000E9;
	Fri,  7 Aug 2026 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786111941;
	bh=6yPFn7yHkyG0BJL3IlHOeyOih//+Qc5xhI7AQ3jvymc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovbPN7MeUrWXRmoHVwijxRr5kNkr0jDBpWovDeFk5El/Uq9R/fwk/DuQ24LXjuiMk
	 ZaYqjGQDz35SWWIuxQ1LBMKsLr0FYsl0/QGUCa4H7S5OKOp6pcJnmOvSbUCtgcjHQz
	 E+CAXq4rDRN9rVU6YIdnaMB6/qYwOJAarSL4EnSis9d2aUmMzQ9yW9sXu29ntXfJKx
	 LRUH0rvCQary2ZaNedV7qjHLIXkZEaBAOuaYEt5oVMPLP0HyEo3ZcImALOid5dYDvO
	 HadyE3D7PedAhgqQDnR1C0IGNNwtLo78gtOO7utY2lJXmttPDM9CPBfA8awGC5rtdY
	 aZJ9W6Ahs7HNQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/damon: fix nr_snapshots semantics and max_nr_snapshots check coverage
Date: Fri,  7 Aug 2026 07:12:13 -0700
Message-ID: <20260807141214.91390-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807093526.183009-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8C111C000C
X-Stat-Signature: 4exww5yj5pcfr3qk77of3frbq3qyti5h
X-Rspam-User: 
X-HE-Tag: 1786111941-850462
X-HE-Meta: U2FsdGVkX1+6OzQQTfJaooTHsPecWEZ9XuuHLtFBI9EaJ64I6nJB3CWChzE5n61//grA7z+9Njt/LbqkXWyYCLT1g6Q+6xbfUCbv985NZpuTR2KQffFsHOiC7iBk85sab9LXSq9/i5iHMkOWna8604NhVq3/GNJhSfsUkAsGFdJ/Grow0DzxzXtk8zIMjq/YSEiR58IdNA1E4pS2SQ+vUdP9aGe7/ryFt+q4Ssfw/80RKm7uSPr7r9zwR10fOm79n8jKNMgwmqMrfqqp9bjqmq+CKjxI6wkkmCw/ZoPXcMYW2F2PxahOKISIfYR85/pORpHchYvBhAUZl2s36yXiHh6VwAXQn853/4gdAWRg1JlGVZu2Io9c3sairc2ppCTgyzJFKSaq9sB0kN10PtCCGkR9fiQ1xXYZ5sPiDkam5BJjT+zcMTcOo+bjtar/T18Cf1Q7a6BicRaURzw8gPbscYcDSMEiFHNg0c3L1yjL9RhXwCmNfnRKJ8s8t4ShUs4fzKMR3s0EhmERpGnBQuxQ+MxQ5ovbKk+5jBVFmLTWBtYwadfg97vsvf/nJrEh+a6xMNgoAdo2eRhEve+eevlUyi/3v47JoSuSWRPeyF1qkZ+OAhv1M3c4dYJuOMGYCQB1bh4I+YZqpclIFIXJKyaGGU3R+w4etAVeo8KedtlarqvswVr2yVTm5DpYsw8EpmekD0B5qsQJId6p6ufGrCO7QVl69zVC9mXHEQ9feSAJUIzQlxNtwsbQyPreuUbGkvrMWZZqn4jBRFSsZhLzAxpL0euabDBagzOo0uXSHIwAiAqLfxKz8hTb+ZbbFQYv26uEVp9HUaw1ltMi5e+xoJApP4LK6SSLehZuQ3jxYGaBUlj+29xTS/4hylWzGQnt5Q55VZchyoUyxunba3dixre9arkOMMxwZPk+m05YeimAPHl6r0B8vOKodBsHfzyqEoeF7MZvhEHjT3gCrTt4IQK
 wV9AlQlW
 +emsmH3Zksc9CxrXvNVp46Xmkk24JY4djlteBTUQyf6ECNOGT2X2G0AyQfN9HUW8RPqOH2DmvAVP/fppMA8CeBvmTZUUxRvIrn4NNDp10xKW/7fNZwAna9SfrveVoo8sH7hge3mwSgEsEbiwo+vUOneR+1uAVBzZvhArXIGyCVAJCKBoP5U1jHSpCyrhObvoUoIryipfPWg+ArgoIdHgUmI+awVhQDTi5osebL8enmaNpw0i6uHbOBs4Mc2/0UhQK773dF1pJ6+PX9o4Tg/twyeZE3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Fri,  7 Aug 2026 17:35:24 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Both patches address the DAMOS nr_snapshots/max_nr_snapshots
> deactivation mechanism.
> 
> - Patch 1: fixes the nr_snapshots counting semantics.
> - Patch 2: unifies deactivation checks to prevent busy-loop.

Thank you for sharing this patch series.  However, I don't think the patches
are fixing real problems.  Rather, it seems the poor documentation has confused
you.  Sorry for writing the documentation in the confusing way.  I commented to
each patch for details.  If you want, please feel free to send documentation
update patches.  I will also try to find a time to do that if nobody does.


Thanks,
SJ

[...]

