Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A39060A3817
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGIIRE7y
Received: by kanga.kvack.org (Postfix)
	id 7A01C6B00EF; Tue, 17 Nov 2026 09:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751926B05B0; Tue, 17 Nov 2026 09:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D906B05B1; Tue, 17 Nov 2026 09:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F826B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:40:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF2AB4043F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:40:22 +0000 (UTC)
X-FDA: 85444871484.11.91D8E79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D17C180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:40:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGIIRE7y;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794926421;
	b=cMgdf+Br/yL9BfbLq5RTpgIuPvr6qK4mC2OsXdKLUHJTX4H3PPH0rjskS+nLeddW+mLvR+
	HDaVnEM5SG/kV3kRvLsYkwBGrfT3t0KuBgi4bLrkM8udNiKGx5TuI4Sxl90etQTLJ0Od5b
	K0zS3wGSXWfm9n+wLCbp8hbVtoTvaEw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGIIRE7y;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794926421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Is3YZDsuf4kkEHdqcvbool8F9PgEbG1uxT0GybnHP8U=;
	b=IHBctTeMYpRA8jm/Jda3h5bRbfoGWESInkW01x/A4SN72qRTv9ERFploL7FznDS4vEqBTx
	wQoKEJQ4hJOaOIaTP/xQzvYBmMh9Zn1LB+8QHKc5iPskgpUmNcSY35TLGfbMubYPcagW22
	/4rHYu7sO3O9boTnPIShPnc/kpBy00Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71728469BA;
	Tue, 17 Nov 2026 14:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BE61F000D0;
	Tue, 17 Nov 2026 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794926420;
	bh=Is3YZDsuf4kkEHdqcvbool8F9PgEbG1uxT0GybnHP8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGIIRE7yfPORHZlp7Lj3Bag4dvQuRrC62XSY1s6WDTNwavLC1O5g6mPe7yWCoHU3e
	 3lEfcY99mbdwW+mnBqYQSsmlvkVMxihpUSe0nnnqdhHjz5PunFqtuPY9ErjUAg2xVH
	 7w8V7WwU1lHBrFBefjZxu++osEVkRbISir5i0SwSQFxhRTwJV5fMFvRnORd1/ajyV+
	 iWzJH+wRMnP+rbZ3UF8ffi6FtwgL2yPFkfAq0sWebH+jMNJ3vevr0bFvTdnzk3TG8J
	 yuOEfVjkgJXF9EpoKL0KQ3HYTYwuj8/WKuB586Z9/OGkOmk0kaKm2m+mpRU3L4owa8
	 uAiL/0CdbhMrA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon/damos_quota: skip the last sample when counting exceeds
Date: Tue, 17 Nov 2026 06:40:12 -0800
Message-ID: <20261117144013.121872-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-fix-damon-quota-selftest-20261117-v1-1-c65d687d3def@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1hj9r1p1h3dqyn4xptqy5qmycdwkzeth
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D17C180007
X-HE-Tag: 1794926421-265821
X-HE-Meta: U2FsdGVkX1/SjfrLNalIgdLupqArTtCoGotFJpEUtJnbsien0DZvgUVnlsQ9n2tE6UBT1Xkb7WNlUnuurVigw1WBwRSg9byz9Ht2856BKcUXpvHPQWUTmUmC8QVxYgZUvEUK9P2TfqgpnfKLpNgEjbBcPlmhg3Mj2fUFIKqPeI5S7gpcWW4HeZ7VhxWGlPBpo+pIYvjof3CSftd5/31W0RUsCvIOU43gVRcs7IIRRf/Evhx6YTAHESNuW1L2mhgGMEAYm6Khy6ahaypkOTaMQhY1IC2I8jjOvlEiQwV9QsKHorDzJkATQZIsaX6JGbLIvzaQ5py0aQ1PYKGPE9uitGxwtgJw+CPd0ulOL/JqYQLtDscR92WxBZIeADYovLMv3IQXbIDUNKdWVCgV5zNCiBnj+jdJYfik5rIqn+D+qhvpBk4H9I4yQxyNm75X0ESA3Xdz/yd9y8ALyYn5e33mVZsSOgOCcevCHvsOsHmK/q3QHqN1VGE9dqMYp06B03DP3uYd+peTs6Pk9+Wc0kh/wuVicg65aQZP183fH2NOXl+u+mrDG9Nfl436eyAwK0mks9psOZJF24XgXl7nfIfbCM4Qo49WenenvIwe+7kn33x2HPmwjjlZzJZ9YqA3IUwnKiRA6AAxYui7+tRxoaQ7okbxselsOlzV+ygqYbU3Dto0PldxpXcsAiqHU7NLU093lo44BCDCOoHAaaqf+XPm23PHgduBRuqAKX7dPetA5nv3JGTrWqJKziif8pvJCdCMN8vjNIlTF3vo+VlBtKVqEVdqX60/LndSnR8nufn5LyfC42H6B9ww3JqyC52Ndel3mGidkLnDaS+OpRL7Q2Cd/Mq44A9OJHJcgZgTDLLu8xna/nCXVKRMIef0jgrUMC/Tubo6RHJ3TZ4s90bH6bY4nK54slTyYZNj3DsK+P0jH8fG7COt6Zu2QprvNPmQ9M+kKwc0g0J7V9dJh3k4I6r
 JNgikmhZ
 XxJ2NN4dEt2uWnKMpg4po336e7gUrrPgoTyaInPR8Lci5A7FscYKSdfZ831wbVbxYdxEa3XwEjM/5E+tZDGhXwxhWzzZsRe0kKOeCjxDLhgOD0bOgS3NJvd5iblycmy7LvZoZH1CIV3Ifr0huG/HHCIN8ISayBtohIMTr5+DXPwcPOG33tBz7VR6SUnGYVOSkHI2pzqnqJoA/7p0A/0W36/dPBmg2rLK7mnhAoC2XsyKGBA3+0JyY4jEDjRN/XW41bVLowOkU9g9DD5Vr2HAUG1Q6myWxin4qY7z+81KQ9vt1NviO4DYrwzcDTDuPtZ0b1L6hd8ZpvsjsgfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Aveline,

On Tue, 17 Nov 2026 17:25:36 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> damos_quota.py expects qt_exceeds to be increased for every sample whose
> tried_bytes equals the quota.  The kernel increases it only when the next
> quota window starts, so the last full window may still be pending when
> the workload exits.  The test then fails with an expected count one
> higher than the actual one, e.g., 15 < 16.
> 
> Do not count the last sample.  Also drop the sorting of the samples, so
> that the last one is the latest.

Looks good to me, thank you for this patch.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

