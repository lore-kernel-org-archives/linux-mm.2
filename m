Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047ACCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA878E000B; Tue, 16 Sep 2025 01:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5999B8E0001; Tue, 16 Sep 2025 01:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF0D8E000B; Tue, 16 Sep 2025 01:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38DC08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:55:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF484140852
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:55:03 +0000 (UTC)
X-FDA: 83894050086.17.736239D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A23140014
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:55:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X65Ls3C+;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758002102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npE8NwlYm7oGiYwu/TvzvBqLyuZK9+6yoZoqX4R0iPM=;
	b=4CePAVAGB9PmcaGla9dZj8QXKevKLhXGb/7I8ELzT7aILFXBv6g9wFTBsPE+ziAckTln5b
	4awsabiQS76m09amEFa/Q9b3VK+C1EVdXghnGEihlkBDJdNSWVduQgXAos8P6Zgdj0Sm3h
	2wWa6jtIsrgaQuH1y/d1JyZDdi02RpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758002102; a=rsa-sha256;
	cv=none;
	b=HoSHX7h/7N59chf3QxAYf/04E5kCw2D4zkHt7UOLJc0T/emoe+tfwzWjiDgmyKt1P9WHUj
	riz51uCSynTcrs3f36sFciT7Jw0jWpGV8iykhfI293Q/Bi2vsg39OKX6Mm47F3E6RWSAj1
	ooRPLBlz/dZZEZdhNhOh+/3b4yEjvqU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X65Ls3C+;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A961060054;
	Tue, 16 Sep 2025 05:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321B9C4CEEB;
	Tue, 16 Sep 2025 05:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758002101;
	bh=G1s+w5/epe5dweVcgrOSpM0OcqT3aFt3572hnVdOnOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X65Ls3C+eQ/thh83WoE9yI3nadq4ds7VGgb6X+0TnQ1j4cm2jIWFXYSuyHhjta0zw
	 JA9nyuqVKM7o/g5oJes8OMPiUHmD4x4NPSmqHklfErth3+ggkiKUz/MrG+WDA8FI2o
	 maXklA1mRL3PSO4HBPfpH1FQ/kqkdcNr5W39VkCCgSo+4CvRoZzal2gzjVjK2jiiHr
	 zMqdZwGMQ7DLt0AQIBk3g1lF2EMbhpXvZITWx5oIqXS7V4wFyFcXhi8FKX/3ar022y
	 UHLkNt2Vj0I8FaK8Q8+UwCXaH5wIC/1PE6+rG4DlYwErkfan0bWJagg+wFH1zZwIIT
	 4jlxL+oWvqTfg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: define and use DAMON initialization check function
Date: Mon, 15 Sep 2025 22:54:57 -0700
Message-Id: <20250916055458.118498-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915213312.12892156442f3a795a0a01f5@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kmy88j8yke9tbojm63nhbqh3uac7759i
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A23140014
X-Rspamd-Server: rspam10
X-HE-Tag: 1758002102-424772
X-HE-Meta: U2FsdGVkX1/PHlfsiw4uv64LYfyX44VXhW9XEnSJVjh01LVO3yX6TWgFh5VC6l2kQcW4KCf/Caok4uGutpwa+Rd48dakZj4CNbkGU/Jjolfs24qHJUbjrRKylmoYjNQMBEplul1Fy79JfYu5KYwAnCEproqcDfWWKmf/lI4xNh7Mb5dgEXQlGSCWPfEzhE5ztoZACDaq/EIv4WRRz+FZVCGQHN7zpx4i3hItAkxSsbKQ2tbAUK537DZt6vGo5RNEJ4WC074qIvaZEvNAVDfxo9gdQnZs4Ssewb64oKfW5HFwSZysQIq8Mu7DO4D05i73m9ZWcO2hmvRxzvCjHQXLHiXukVv7oUdNdwOnBpIEFi6wK/T+rzSXP8ywGhv7dA4PUkHvTu7Oy1uWwq8jWCrRLctypYn+/FfOFzq/Z+XHifKe1N7y9hMM8XrHJ+9yNx7ohgeFCRDcNYKTJ5A9iwmftMXYenmEqn+dTmjHN0sSrUo/6KePGtYDCbSxbA+Pj85DGX0urNS+diEWrZ7p8b7WHp8zCW88QkjcbyiXsF122kFtlO/gCU1Zk7+Ap6Jd323LUC20DSbhIFMTR2p7lhYK4CYDaEB3kAd6SdmGFruqghCaqjsawOyLUXGgftpXnn8+ad3m0Rb87TqTE1E3DXFtcYRrGI66uJTCnYBlndhQVRkv9WW4P8W81ahgYkAvQzbg+3vCN4II5SLiOucnkBZ4pcs3Ptga4PbTgWIA03cu5OMb6ybYWFFajuqlE6rRxIDOPhYVYuqVfHF8yz3XKwIjiYeG8kQuJIJSODJzY9Qud2GoxcMKQCuDWaz5813de+XgyFPngNDgofCHbrf5UBR9pdLhidyUl4mwdVUDc28M+/KDStM0twHCC4Fj/vRMCQztRFDsshyYJUaEc6tXV1PGWn/xyNpDHCeUeAI0KOHNfl09AJwxPjAeZohjs6uviIW0zLB0LWWvVwFc1kCOQ5K
 UjReO5/O
 aKnboO85e9pvP1Oxn7EzbSMLhrzK3MVOJHtWEdO5mQ/b97zs2eqzE4RmUKtjY3TJbhl9sHSg46aFkRCrBJhObgoBHear5DsqPCTs/JSJ/b85GE2OE8JMo3Nikbjy2YSB0LeEmWTnF98F0vK2Z99+uluSmX+1n6I9JaZocQRB72kzKCmYnflTYQFT6+VPuSXkQODDLUU4uA2iCpC/ndK7BWXam2WENuuieLb8lltPFh1b73sosqriXxVBMivq5w2iS5Y9c5wzADM6Zzojd825bDkp1fSiTy9TmW0rU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 21:33:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 15 Sep 2025 20:35:04 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > If DAMON is tried to be used by its API callers when it is not yet
> > successfully initialized, the callers could be crashed.  Such issues
> > actually happened and were fixed [1].  DAMON API callers are therefore
> > having their own hacks for seeing if it is safe to use DAMON or not.
> > Those built on an untreliable assumption that DAMON should be ready to
> > be used on module init time.  DAMON initialization could fail if
> > KMEM_CACHE() fails, though.
> 
> Wait.  Is there any realistic expectation that KMEM_CACHE() will fail
> when DAMON uses it?

Not really.  The commit message is saying just a theoretical and unlikely
possibility.

> We do have the convention of assuming that
> __init-time allocations do not fail.  If they do, an oops or panic is
> an acceptable response.
> 
> Are these problems actually real-world demonstrable things, or has
> someone been playing with fault injection or, ...?

I don't have a way to demonstrate it.  The commit message was only for
discussing a theoretical and unlikely case.  Maybe it was better to just not
mention.

> 
> > Also those are basically duplications that
> > make their maintenance difficult.
> 
> Unclear.  This means that the client hacks are no longer necessary after
> these changes?

You're correct.

Sorry for the poor cover letter message.  If I have to post a new version of
this patch series, I would update the cover letter message as below.  Does it
look better?  If so, could you please update the cover letter part of the
commit on the mm tree?

"""
DAMON is initialized in subsystem initialization time, by damon_init().  If
DAMON API functions are called before the initialization, the system could
crash.  Actually such issues happened and were fixed [1] in the past.  For the
fix, DAMON API callers have updated to check if DAMON is initialized or not,
using their own hacks.  The hacks are unnecessarily duplicated on every DAMON
API callers and therefore it would be difficult to reliably maintain in the
long term.

Make it reliable and easy to maintain.  For this, implement a new DAMON core
layer API function that returns if DAMON is successfully initialized.  If it
returns true, it means DAMON API functions are safe to be used.  After the
introduction of the new API, update DAMON API callers to use the new function
instead of their own hacks.

[1] https://lore.kernel.org/20250909022238.2989-1-sj@kernel.org
"""

As always, please let me know if there is anything I can help.


Thanks,
SJ

