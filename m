Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B12EFB7FD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA2E6B009F; Tue, 24 Feb 2026 00:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AC56B00A0; Tue, 24 Feb 2026 00:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A236B00A1; Tue, 24 Feb 2026 00:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534816B009F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:54:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA00C1602D8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:54:55 +0000 (UTC)
X-FDA: 84478286550.30.7E691D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67EB8180006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:54:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qvhkAx8o;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771912494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=am/HGGT+WUkqmdMinFF+99Gu2UvL/aGORn6WXP9N/8I=;
	b=YWpgTuMW3dF5wBCuJMJtXcRKDcKlgTRZhP5QEI2BberUy3GOOXVAMpVXOBiCZNltXc1bcm
	Pk2hM8vDCiifE3Yc3QelkGFZfTBYVIFix3p/HaZbRtLWGqot3tWekpjBxp4FNksIIFTln2
	6Oz+Qe5MADpCJzahUM0QvDGucd7BGyk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qvhkAx8o;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771912494; a=rsa-sha256;
	cv=none;
	b=Sb3WzPrB5hNlxOpmMwbRBYZ6kEVPxCCtTHHAiZuft1An18+IIkV5HlfqGzgwRcUHNDcmqP
	uRxhhY9fQfo9otRwlEr41rrPkaXLdxNgiZxh84krLhogqs92j76BiTY1EX0JWjA89dGd4U
	tTHke/Nssw/UAk++x1ICfvQHBHcBd+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABC45600AE;
	Tue, 24 Feb 2026 05:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CA8C116D0;
	Tue, 24 Feb 2026 05:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771912493;
	bh=A971HzHUjZoXdUvGH9DGwBSAmjxDqW/p+VKNITvjlNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvhkAx8ocOQznuXujhwJUQMmfHgdoCMJR/7N75VR42dvyn68v8tpEsAQvt7WoUkIk
	 Wn53BLn6+Up+ZNLlNn8GN4r5YsWeMgbhTBNgRutwYtixXnkui4xACL4B4WZ+xCDo4A
	 Y2kk0fOSNNHMIwss3Y9tsIdARPOnW5NbzjqLVsd7+BtbGu6FrXgJoDIFWJngYKChp8
	 HV3/qGvKs1ZtJYzg369yYOCPK4qrtJlhNjMJpOFBA4IbYhG4vkeOk/iEajNCe/ujGq
	 4DgAyDFmwTdec4a9+rsCCMc3MgZYghhAEP6EApUGQgl91jOHS0BuVWLducMC5FLASb
	 aUiifcISYu/dA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 4/4] mm/damon: add PA-mode cache for eligible memory detection lag
Date: Mon, 23 Feb 2026 21:54:50 -0800
Message-ID: <20260224055451.58713-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223123232.12851-5-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67EB8180006
X-Stat-Signature: cuqx6miikbqzdpffe7zs3jy53asdwc4k
X-Rspam-User: 
X-HE-Tag: 1771912494-35964
X-HE-Meta: U2FsdGVkX19EYgKkOP9n2w0aOxNjEbIfmOGxmaEGuvq9r1+xj0JmPYmCZeVh0Bp1V8k86VIMtEgTUCO7tECSBlr8v7QslXI0Rn7KxkRks2S1ANjCJO3/qZNO8YxyxbjN3zNAMI6hQDJjXy7nLs5UTGz8ezcvvnsFylLqJfIcr0GRIO1ogJ6hbK8kpU1PQnzWgTtxLWf2FTCz7z+OqOfS73/rLLbfXVtemu6h6v4tQlIVStCp9zjNM2iG20mrs+kK8lOhjEYlvjo0GLKbVI4g2CvejjY2ZcWjiYjIcm77NOAmiUeQBQErAw1ORTq9qCmFQgC1M/HP+F0BVYFy5dF7/vnWyxUL7onVI32KKDqExHeJ7w/ne6e6kqApquXcRSLF0XVnEaBun2FauU0zoKdLtSdMkJdgf9ftwdrBI76qytMDqnmMjos3dv15ElsEOOXfSvacG6OSWWmbO7G9ZLgMe+7srP0QbjFUEQCFl6G63h67vIwZtcQb4EQo/ysRjy6kaeD/71uFX+rpzsR/H5XZZoDyFaI87i1uzvm06hL9ZH7IzTu7wCDrjw+q+Ly+JXu97XL9i/x/pBGyefO27zmZWXmD0PYplhqWboj5H05EoCamRXTz7DR+GIiBMmJ2rYfFr2uJdSwQ+WnQ23G7ndUO4QAtVChp3b18lb7pEQCQntCBn9S6jOQ9VWMqFpNp2/VuW51nykYf/Eo+F1FGIqrlmLXBd7CIRP67wyj80loh9Su17rlgodQOXhkTuBVBV83F/ozjZg+rWJ6qXoyRoQ0YC1jZWagA30wtMFTjEcziMFqHZSIDrrhACS1l0MLh5UbXFbD38JKTyidtd7m6QdqM/uu5G33WWu/BZH1hWujzb42w+CvSmLsHwXH+eLNHMZ7V7DM/gP/rAhbGfMJDYgINwsYYC4ykaicEFmCzjOmukMoCnjcmxsVfog9X7gq3jJgGhOoVZzL4DxE7QJ4yMyU
 V8MkRdQF
 atnl8g7EmhjuQzO2qU9AI/oiWHKz9uUmh6t/mN0lWGNhTB056C0PdYb+j7+vELKLcZY2nuDNmPX3v8UvlrsysenoG+3N29wyyHOGhK/DaElKHpy54+lAYGTnDufpb4PoAanf3MbBKqDpZwri/P7y+U4AZqmVIqDTNSO7qIw8/FLQhGBzN8is80biPwsm1DxNgH6+K6zhtq0cBrGYsW3urcFuXg8yN7ztbSoq+eKcayNyYnzrCSQBsXxaFSJZTUmV45SFxNeow6d0qY/jo8u0bOGBRsfZ7PMnLvNSYgIJkuPsYi3ucZoRmMdaQAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 12:32:32 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> In PA-mode, DAMON needs time to re-detect hot memory at new physical
> addresses after migration. This causes the goal metrics to temporarily
> show incorrect values until detection catches up.

I agree this can happen, and could be problematic on some setup.

> 
> Add an eligible cache mechanism to compensate for this detection lag:
> 
> - Track migration deltas per node using a rolling window that
>   automatically expires old data
> - Use direction-aware adjustment: for target nodes (receiving memory),
>   use max(detected, predicted) to ensure migrated memory is counted
>   even before detection catches up; for source nodes (losing memory),
>   use predicted values when detection shows unreliable low values
> - Maintain the zero-sum property across nodes to preserve total
>   eligible memory
> - Include cooldown mechanism to keep cache active while detection
>   stabilizes after migration stops
> - Add time-based expiry to clear stale cache data when no migration
>   occurs for a configured period
> 
> The cache uses max_eligible tracking to handle detection oscillation,
> prioritizing peak observed values over potentially stale snapshots.
> A threshold check prevents quota oscillation when detection swings
> between zero and small values.

But, I feel this might be too overfit solution for a specific setup.

> 
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h    |  45 +++++
>  mm/damon/core.c          | 421 +++++++++++++++++++++++++++++++++++----
>  mm/damon/sysfs-schemes.c |  30 +++
>  3 files changed, 460 insertions(+), 36 deletions(-)

The size of the change is quite big.  I'm now curious if the problem is
significant enough for this size of change, and if this solution is only the
single and the best one.

First of all, I'm curious if the problem is that significant.  I assume you may
seen the issue from your test setup that you shared with the cover letter.
From my understanding of the cover letter of this patch series, however, you
are testing this on a setup having two complementary schemes.  And you use
TEMPORAL tuner.  The motivation of TEMPORAL tuner was for setup that not having
a factor to move the quota goal value without additional intervention.  In
complementary schemes setup, the schemes becomes such factors for each other.
In the case, TEMPORAL tuner might be worse in terms of the size of temporal
oscillations.  I don't know details of your test setup, but I suspect the use
of TEMPORAL tuner might made the issue bigger than real.

I also assume the real world people may use DAMON with auto-tuning mostly
because they don't know the access pattern of the system and assume it will be
dynamic.  In the case, even if we perfectly solve the issue, some of
oscillation will happen.  So, I think the issue in the real world might be
smaller than that we can find on some specific test setups.

Meanwhile, the node_[in]eligible_mem_bp concept makes sense to me.  I'm worried
if this patch is unnecessarily delaying the progress of the main change.

So, unless we have clear evidence of the significance of this issue, I'd prefer
dropping this for now.  After that, if the issue turns out to be significant or
this solution is proven to be significantly beneficial, from your next more
realistic test setup, or from real world usage after upstreaming of the main
change, we can revisit.  What do you think?


Thanks,
SJ

[...]

