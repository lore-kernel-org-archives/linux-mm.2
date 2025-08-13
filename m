Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101B9CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 16:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5959000B0; Wed, 13 Aug 2025 12:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875D8900088; Wed, 13 Aug 2025 12:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BC09000B0; Wed, 13 Aug 2025 12:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6720A900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:49:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13B15C035F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:49:14 +0000 (UTC)
X-FDA: 83772319428.05.5195133
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2B7BC0014
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:49:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UK1WJO+x;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755103752; a=rsa-sha256;
	cv=none;
	b=L+E8gnKK9FzJReauO/46x8hj1kFL4Ve4lcC5Nw3xBkIeuuvP85CgEYE0UV5oMfInO0+omB
	McgQ0YeR7yAxSydhpVS0D5FaORFyNJSo9uCmhYaabKsDFdWYcWN9HLAwo2hVSuhlaktD3b
	ie2jYDUTRalbtDnbytlgT6O5qWXthzA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UK1WJO+x;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755103752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GG5ONhXMZCzfaiuz+2YZsiiJGKwtZjHiKabjdvSHbsk=;
	b=GMsbDTJbEUeJto1vvcx/2FWXk3auVV7/kntZ4zZ4yidV9SEMYvemE2PvYzeJ0oFII/P9L7
	Ebge6jP6gj31qOB2BfDWa5b3/ICGPOK75XaTDAiAOUejd7EiXNoL/jKcCiGAnZ67wOPgxh
	PZs53+c195am18vs0R+IUAZwj0PM5uc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 941B25C6A1B;
	Wed, 13 Aug 2025 16:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16452C4CEEF;
	Wed, 13 Aug 2025 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755103751;
	bh=CSFaSozMOw3PaXtP/V3KWHY28EmmlL/o1GQ0agoqXDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK1WJO+x86Xc9PmtfdbEVJHuMZOa/tpxzVdWXSB+H8OpvyNUYzl/9EUmEqQUGy6WI
	 OO+/Kma3G6O4zOfWkPLIZxMyi4l9HsxxmtqLjFdzUcsWjaNpNZEZd3TZIJDlGsfFM0
	 bzjHt7SAMVmhX5u6y7O+KeEa2HqxycRLJLpC0DpkXCpVa7cY92EOOoUyZsezSVr7p0
	 LjayP5I9fN2JKiVuMMkzzGE+m7+7EEFNvVuZA6xEIjatd2fBOxKSYTsXLugNCAhTG3
	 BIoTsI+9BJhOcHzxD7cFysUSe2skX6y/qyQe7NGcmhauOGbNgMzO4vHOUcMh+RL8dw
	 74RkYcechA7ZA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 12/16] mm/damon: add damon_ctx->min_region and damon_target->min_region
Date: Wed, 13 Aug 2025 09:49:07 -0700
Message-Id: <20250813164907.5885-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-13-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2B7BC0014
X-Stat-Signature: bsg9ubdntj4j7wbkopubgb77uq9666e9
X-Rspam-User: 
X-HE-Tag: 1755103752-6304
X-HE-Meta: U2FsdGVkX1/uIAo3Z8BJiZXH/aKI0HnDEDLQZ/Vbwr97RRbRcgNc4MseK8264w0eFTwz9tB7ojf/sefp5Lg6C4iFTk49YPUAoK5g9S3rQ6EiQ2wCT9E08TTkJGYDfU/ThF9iw2ti79aCSEGVGln0flk+FzNUx7G1sIh121evTCUz8UE6hPLJm7VBrMjcQUeqQ8niGEPmPRiV+L3VuGmQ7j1ZZ/h52KiLitdWefU94hzeRd40oAacn55ptJSDvLn87lkwmgzIPuuO7QZnROnRETCEJrFPVmLIcws/Kf6WTP6ziwlC4J4WiFci3up4HUPUakwzXvhhGxtwo7L6SwrV2i0LZbH1cRd9H1oQsXV9gX4T4OpzJmrgATLwLil7gfDdiH5mDYLv9T6Sx9kyrQhiXkOta6qKm3ynWgAD6cLnm1gcP58DMkV19r66TV35c+UH0ihmAOnE3P14z9ANqyeY2wDqt78JczTVhjAIwWGF6AmM4mKDGbqXCfAcZI7JAed6yXjI1WxFo65o01DvmmLJsdIIYLnguuoC3UPcTnphiDHg0lEI+BwTl/ItDQ9Od5DYlWeLaDnUX7hgxTumZ4LLg5eR2inWNTuHG/CJwRtRY5H2kxZYN/2GDEBY9Zq/azNBfXk6naJH1itH3DxuK3F5zimZH7peKfP2ch9NtuxNTrRCU9Q92QRPfKun9MPzcH9Yf0RPZRFIM/ce8O0jV+VeigXSNq+0dFGdK1HqmzMCECW5hFSOtXNXV4lF0MuFABW7VPVt8oY98br+O+wJ+4GxEdduOgoFcymVfRdNGr7scQAodFRpwq9FismaL8NMQ8D37fJpaaj+ShVVvIwKV0cG4ffTo/tKm0jCdOEP8/RdVIzwPXUR/38FPhL3Wv1CNjqkZssrq+KNrP/4VZQNzuOWsy+geliViSxo4d5qRbLtmbkFqaGGUaJ7FTKhUr8tiCICTUtAKwJV16Oz3UbLqKu
 R+YIljEU
 s878n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:02 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> bytes and cause data alignment issues[1].
> 
> Add damon_ctx->min_region to change DAMON_MIN_REGION from a global
> macro value to per-context variable,

Nice!

> let target inherit the min_region
> from its associated ctx to avoid excessive passing of ctx.

To me, keeping the synchronization seems more complicated than just passing the
addr_unit value to relevant functions.  I'd prefer passing the addr_unit to
relevant functions.  It could require more changes and might make code uglier,
but I think that's easier to maintain, and we can cleanup/refactor the code
later.

Could you please do so in the next version?


Thanks,
SJ

[...]

