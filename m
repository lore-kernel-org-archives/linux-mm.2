Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B79E74902
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E41E6B008A; Wed, 24 Dec 2025 00:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E0C6B008C; Wed, 24 Dec 2025 00:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786B56B0092; Wed, 24 Dec 2025 00:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 681B06B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:35:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1140BA3E2
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:35:22 +0000 (UTC)
X-FDA: 84253251684.19.2F915EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6BC0C20002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:35:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M07Y6ig2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766554521; a=rsa-sha256;
	cv=none;
	b=EorUcnpJzkAhhRO3SJ5q4Jma1L6z2q/ynZKtuXEDfTS9992ZljIRue5TyFyL4k4JazIwFL
	eABwcHjaOcBryToba/CVcFFJqFQS2bZ8QAPGvnunUdodYFKOUBGWZRIFIsWMvZlmQm1/ZE
	+UvzrpFRPWzVjyoSzQKGpwoZhXyD7Wo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M07Y6ig2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oon12MNM7nXMzdfBhYt6o0i4MAymUkUdMrWTkPu0PGA=;
	b=3nvGj38f79S4+WKk/tV75WpCYple9hNS4KlyEb/RXA6ZmWzQvrCZm7vutP6CgtL6ZyIpwa
	GvlhYAcUwvQsZWQ6oQGcZl4W+yuWqeTYzzOUDSUeOA9pQQb2U+eO5vndKt8ym3W6uumtCt
	+uufjZDJULdu0yREwdkG/yj2yQ5SJKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E694760123;
	Wed, 24 Dec 2025 05:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7742AC4CEFB;
	Wed, 24 Dec 2025 05:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766554520;
	bh=kr2K4L3nDuanEYjfqLQ+AGLazgdSZ4R0ehOzcVzdsMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M07Y6ig2cYKW+kZ0yDXgiFUKnM02zeak/k5F5+URhIx55kQbPqhdqSzEpbwnogyvD
	 z0PMXoa6Itzcg020JgqJeqODDMJ7bjBE73r5ezY2AMKMjitNtX/me4MoJ+tD2R6vnI
	 5GRme92FzDdTi57Yop7gBZGJGuvWvwz+20Ubu51Rv/xrFp7VWyDyVRejYPp5540HkR
	 idNby+cy3k443yDMxuYwElqx7heJQpoJGCg4W6lz8omjbMFps20wsflbQyAp7kQ2J3
	 BklQr4GVlarJi+bKFQvHgQsJQPNWof3CNnSXsvAWk3UrtpUvg2hAMI4j6Y38CAU7QW
	 PHKz8L6gAXmVg==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] mm/damon/tests/core-kunit: remove a redundant test case and add a new test case in damos_test_commit_quota_goal()
Date: Tue, 23 Dec 2025 21:35:12 -0800
Message-ID: <20251224053513.82011-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-6-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6BC0C20002
X-Rspamd-Server: rspam03
X-Stat-Signature: 4yesetfwr6s8y9wawd5zs19rkp3cxyhf
X-Rspam-User: 
X-HE-Tag: 1766554521-331534
X-HE-Meta: U2FsdGVkX1+xvShAjh5hkYxT8oXbI4CTN+EYr+f9MIF8Xl9OMmZdgueGkrM/FsRcv6jKrHfwBj843L4pEK1A8jZ0kTLDcCA4+KVaj5C7HpKKaMWazYq316w0WahXouNsbEkpkanNnjyN+O/39WHw7sHKO6t5/5L0XM09uk7RTLzfZGqJjHXVle/dqTWgWPusofZQu41EYLmAQ47eEo2VEQ7cpnymBQThAEB3cYrg1hUXg1mHWqovInZWEP2CQBafH3+pmxBWi/YoBJfBcH54cukPxii2g9x9+YgqSKDYu63L50PcGYGLEbMd19hqTIWZ5sn8PZCSjvU1rM+Z89jIjGNTW1t+qSYuhQPYxbFc47qkalOr1k+gNUAZ6YpGjGdVuNujN0QTgOUQ9hmBMGLPW1mOCxL5fgSRxM94+TqtRUQ9VeFL8HL+JHLlNwZbBCZUrK33RHZnhOGCI2W1Nl/BaroiRFxPsfbzn9GLjodqdFh/TFfc1ReWyIwCgFaPZop73e5IpvIufrvE7l6b7VSwQff+2l19oyh3YXvxpL+TqWVIsoklgvVrZ7RSVDQprTBlwLTBHyt5cDlt5BzeP/5U4p9VjIk+KbXzcLKRAsZlsSxWaVWpYDfIslFdweot0eeVZwklbNrZdmp4SjUJ+cIBvpOE23ikgmv37YZAlrV2LYeRSIutuJuU+tNEzGMS4AwGD3SFTrL04PQJEizAO+RrkDfMRdmHQAVBFhWBGvkMhWHk07QR4VxasGEqLP60jR3x/ABoWSWEILh8oKlkmSmX7kvsvNenPIsR0cGc0x/EdzVVZrlwui20iBBpRZLweId95iHYQ9Ak8sSQwFIJYgHnUuCwuEK5nNlQZQWxEzD25Hg6wzeo0iEgBkLvCm463BJvCmSB1IWkGhSwjAsz6B2Hhj2S9L3a5e0LkAxxzt1KcL7H1ksU7WqL1bZBeJOt++GPIPebZBvbTTXggPHXelz
 jHZgbw5e
 lYR3+ccEieO+aggJH6g1RuoDO5+k4QS2Gr22nhI382zUfDVFe8oCNoxcs9FWc+tcVce9je3xof+VxHGbi8ME5w7pUswAsJS4xv0OtNwqqpwXN8K8oqD6G5SX9uHEF6hfvMfJFuGaABi8XOJg/WpAcbFPx+8Fgl8zhp86C9UFfzRLB2+HG+VVb+2WEoyOMAMACQhq3SpTZE7v9bp2seM+N2GUX4CG9890clEcj+G3eQWOBh8AZllEysYrtqVfE9z6WT7FO7Dt97pPOcTUGMtHCqWoYu3E4LbshYW49mUu9SRalGGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:22:00 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Remove a redundant test case from damos_test_commit_quota_goal() 
> as it is already covered. Instead, add a new test for 
> DAMOS_QUOTA_SOME_MEM_PSI_US, which was previously not tested.
> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 36622a2c11f1..4bf1d172436b 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -601,9 +601,10 @@ static void damos_test_commit_quota_goal(struct kunit *test)
>  			});
>  	damos_test_commit_quota_goal_for(test, &dst,
>  			&(struct damos_quota_goal) {
> -			.metric = DAMOS_QUOTA_USER_INPUT,
> -			.target_value = 789,
> -			.current_value = 12,
> +			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
> +			.target_value = 234,
> +			.current_value = 345,
> +			.last_psi_total = 567,
>  			});
>  }
>  
> -- 
> 2.43.0

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

