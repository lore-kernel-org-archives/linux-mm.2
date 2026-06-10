Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5778CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F4E6B00B0; Tue,  9 Jun 2026 21:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7989E6B00B1; Tue,  9 Jun 2026 21:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687426B00B2; Tue,  9 Jun 2026 21:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52BDC6B00B0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:14:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D0FB16509D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
X-FDA: 84862232700.05.14F6954
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2CAEB120009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI9v+5GR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nk5e65x0+gfzE8iKCczyf6SQjc2ncZIrrJUIfyl4290=;
	b=LhBm1WBNJ5VCXsUANw2RtkGJ4iF6zreUy0ah8DTzh/52DJMdtczwU1SZEhdK/z0Ld0kOiF
	wdQzr/K4acQ+HYu8QWEg9bft3zFelM0AeLXhKR0KEMEHJugNelon32NkrWKPLqrdztPEL4
	R2sgCMMvzMbSExwV1Bbv0TbUtXHmx0M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI9v+5GR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054069;
	b=jBGSpcy0t4iNHQOMkSj0w4GTNGKX7aOk164QOfnzPdYNsl6mjyYPU+XnlWv7SAxfLCEzQ5
	YXOLsIOl6oIzWYi7oSf7W7tDEKUcyFatArDVJT/4NQh5N14CZgUB5GRrDiX7MaEUg56D3O
	enydS9g9h60oMU0QWqIjSZOaG+s76hc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A374B602C4;
	Wed, 10 Jun 2026 01:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3711F00893;
	Wed, 10 Jun 2026 01:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781054068;
	bh=nk5e65x0+gfzE8iKCczyf6SQjc2ncZIrrJUIfyl4290=;
	h=From:To:Cc:Subject:Date;
	b=RI9v+5GRjs2r/QxLEZ1S9doOh/Anm/jAi+G9SyO9Z0i4DC1y237xMHA5wVdt3UpMa
	 3Mn+sBs6chHbnhJ9Dz2aud3Bc5xTdGAcVc0SQpMrsy3/yLivVP/Q/hk6cnHeMwUgmk
	 NCIvMQm0j6VryyFUyutC01DlaVzYwbCY9Qg/xgsNwMCzwpZj8swxWp3g88Z122cLMJ
	 9y9vk5f8nbqfVu9RnSKWsYLKv2rAL3bUI5flFiKwKcF/eedMiE0bf55/hJKVl1zJyO
	 rEbDyVYmW/qhknrdS+u8HfmVwMjaeY5Utcx1Yw2fqL+GE5B3zEYaXb/r/vPuPpy7Vz
	 lR7ZWlv1Jw4Nw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 0/4] samples/damon: handle damon_{start,stop}() failures
Date: Tue,  9 Jun 2026 18:14:13 -0700
Message-ID: <20260610011420.3018-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2CAEB120009
X-Stat-Signature: 6f49dyejhbxrig7u4fnn16c7domo85ok
X-Rspam-User: 
X-HE-Tag: 1781054069-758377
X-HE-Meta: U2FsdGVkX1+1zVxvrTUJfTGNVRwL2PdQhggOa39hSFhpmdO1/LEKVTvLMmNqUm9ZRao0VPJPP+SxwfMBsaqo5/KQn22FRyI9pQUIk3hACVQGwx7LRc+zSxeA5e/pRkON7fxEVhxNKq90tL+6oySpoham+asIcup9f4TQeu2orICOy7uZEVnhE7+f8Cx15qw/YWVu2ohfAn1iBkYor+f+rdrADjxF8nHVY7GWcA7/BwFoQyI088AYYfPQVXPZNnXHDEe5lBlyxRuzJUZRlDIn9nYa9HWh5rEXlgDwkQ17VXCMGEnFNo1rzyxYKLnvN7URwwodfMDHcRT5DucHznspsV+vy8z7CDtwmk8o1X56AF+3GvCF4pjCbffm77U8wypV8TsY5t6b3rjhSl2utxDQqsIbPnwgH/c82CanImHi+aqu9rM4oWnj3+zKce4rtY7D0iykk/kgepIocIPdXSEAZrhnZfKWiYxLdvNhEpsbbLgB/nGVLIqiYoPNL4M8bAMm2/GcE5JvubK5fjBG8w3Xl37nwahGou84LU4N4cOGmYSA8soLN2lZGxoO+6naL5So4UEr/hhLE866ZZuRRuYdkUiZL/4blOkIiOm8oajUJyqH1zuWTSRQsNt5K588eYXuZgHCbCNVJWAT9whVmpqWzuixsn0KP6fB3VPlEE3+DRMp7a+8vU4KEk08LqJ0IJzIeMmU2xzxyyUBrXGNgC55tNs4323dc1k0WnxcWgiM6si9w2ATpFPF5Bn36vcutpurtDMdm0iQjVeTy0NsdEGkW1DUBWUgLbxiJXk3EUdNc7nxMC2vMy3KAJkHCSfQOnxXXRE24ZD8eA5vkK4l09c7/w7+wKQ00qeblq2WzWB/72qVI9LlMAIDC8LSOirigftus7c69z7EJJ7/QNh3QlxhiMzj0lwdi/WEXFW2zlUZ0mtFoDJRcNdDkGjZScnb8mE8iUgQPlMCadgnKE1Z4Eq
 nb8KAuxd
 hjZbdS715wHAndWxZimmNBzfUsUar7Bq/FMuStQJFsgIExArQTpqsP1/K/DxstnuOehMdSm1SEO7ih93fZvquYxAVh85+Yrwj6waWQT0VErWfz4qp6Qeqxtdj8yzFhAkn1y4/5zOCvvJT6CuIRPImfnVW3+k/yHTe/rxdfOKTHXRoYFqA5pUctVwSkeWJJnWSFVYUvlCmCc3b724dtv/vyRYCclyzkFXeBz88J2htgD4b5Rf99bQoj9a2KSjiB8+J88sZDuSAtAGAc8RcCZSTNCv2aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All DAMON sample modules are not correctly handling failures from
damon_start().  Among those, mtier also has an additional problem for
handling of damon_stop() failures.  As a result, memory leaks, next
DAMON operation disruptions, and use-after-free can happen.  Fix those.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260609142119.68120-1-sj@kernel.org
- Add damon_start() failure handling fix for wsse and prcl.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260609005443.2122-1-sj@kernel.org
- Add damon_stop() failure handling fix to the series.

SeongJae Park (4):
  samples/damon/wsse: handle damon_start() failure
  samples/damon/prcl: handle damon_start() failure
  samples/damon/mtier: handle damon_start() failure
  samples/damon/mtier: handle damon_stop() failure

 samples/damon/mtier.c | 14 ++++++++++++--
 samples/damon/prcl.c  |  4 +++-
 samples/damon/wsse.c  |  4 +++-
 3 files changed, 18 insertions(+), 4 deletions(-)


base-commit: e38932476396c4da618a9e904ba4e45f1891d910
-- 
2.47.3

