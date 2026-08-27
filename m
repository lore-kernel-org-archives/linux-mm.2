Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFD8C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2883D6B0088; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2392D6B008A; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1760A6B008C; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED0FB6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:29:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 655D4402FB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:31 +0000 (UTC)
X-FDA: 85145770542.23.923E6EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E21FD40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0EV73fE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787804969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5sVxBkMVIpMIF72iutGGV8B5DQ7okKTomLo3LhF86uw=;
	b=btySqqvB2gkLBBtr10nNEaRv/U6bY/h9fBhYjKNInNErL7D1tdJyEJN3dJkrdoGX75FfZk
	ZCMY/j2wEuBL+cRdFCmpD/XEZf/d8ArMhBcWddzBZ1Gp2o/GXj9u0j9+Qw1edZjnSPjk3s
	KjMDDyC8A5JUDDGBR8zfBAV9SIv/FtI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0EV73fE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787804969;
	b=ROXjg3ymlMTx20YlS/k91CPmbxoODKeBmG2XcSwTrZ58H4YDc9sW7kvQyoAMaHottd0Icy
	x5gohsCrcmbheMXrbhbj8f1RAD1FPISrDxku9fR2nGvqHJLMOi7qHvZXwwF50LOZ9YsFct
	xqZS9qujsBsz26c+TLvPrX7oj59OPoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D9F0600D1;
	Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD51F000E9;
	Thu, 27 Aug 2026 04:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787804969;
	bh=5sVxBkMVIpMIF72iutGGV8B5DQ7okKTomLo3LhF86uw=;
	h=From:To:Cc:Subject:Date;
	b=m0EV73fE31t1JvuzLgUuLNfLTlA9hNctvUqQIXSlKjlhTm31fRTbUfEyWbqEAYC0v
	 1Ofduja4pfM6GjDfkfuUJhn0n7xglmmsn7ijtCIO/usQ4V8QuLG6yj5U8w0Zieiohy
	 zZTKQPtah1fCu0CxK80DZnInL2JiwHyDf/ayoQWHex7Wcin4EoWYpUaBhyGMA6rspF
	 pUKLzM4yh0vav4t8v8P+tvUA2+c93ymTvYLPM0sH3CYeGiZtVOgoGxqIj1YDolALbg
	 CIrmlpZXXwSm4DgL/VOwMDK8Gp4lcY8OloDq0RB+a/arcQ81XxBsD1zU9jG7AJ3UVb
	 8Kcurl1awPcvQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: fix wrong behaviors in DAMOS PSI goal and sysfs refresh_ms
Date: Wed, 26 Aug 2026 21:29:17 -0700
Message-ID: <20260827042920.93580-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 73u4uxhatnepyzi19a6h9ji1ummuyabc
X-Rspamd-Queue-Id: E21FD40003
X-HE-Tag: 1787804969-516908
X-HE-Meta: U2FsdGVkX1++x3EIAVi1C1Ts6UgmEneOFKOAT95/Shg5RxJjXBMHQRa+2CHYFWu9gApTlI9+4WP2trrSY473AiKUkljlsI9+7uqu5hjKDZI7gkumL2ynXDlqzICQloDX2Wb4qvUFDCtJUjA9ie8NiqmmmoLJ5R3G90LHuZGplls50IOMHX1zMJykjLPjflN4OWa70XIVzezb7I+57lSblApQT/dBNFi05fqMexmuGffYbR6Kk4poF2E0GLlCsrVTRYW0aXUis4vuOS5bjNDGkgq+yx/1vXILb3jzqZwPhVXwWklMJmmheDuLQ82ZofHau1oJnhBAS2CM1kw1GB4KvwcB2xE6lNiFhVKL1m2NbnlLwwXwOXxobQ2G1EpnlnbmWSXDQzDuVzXeIcfZ96xpuvU+Mu5GwDjIfcsWqCdfbXc4Ur3EN6JpJ9m06D6sZrmefU/jGGHVIBN/DpBJbKMum7i2ALl731XQssnE9eHekk8YFlaUg4ZgHMYDh/RZX7xPeSrhH693kwto4SN7veal1ZQXsgAxUc0hOFKjemGNutSx7hudYCfqhdqon79h0cVHwpqhPOJX+rJgmpV3ewPBSQ3s8IKQuLvqJrPuW8zIn34yh/YckNU68qhVj2s3V4TXaWOT4BgYu7EmLbe+QXdaTw6t43ncR7gZuVRWGKMwIo+aLsfqvUtWZOXehlwLjHGyAeIphdQYeBVWLymZ/k7gaSbbJdnJzQ9hZHD/QvIG2QXwH0dmkJ+YO3yU7vWNl2wtwLcRSe6p75nOPvn8t7+nmyQoY2XBYcQK/9HlsynWJuxd4AMxbKJyMrKdJuyxwpGICYMgQ6pDLv8lGWYst4R711LLkM6JQ6MzoBo+ACieYtVPZ5Gq/YS6+3UwAuVT13FvlZ2COrM8xGqPXE2uA3ttPFxr+ciiB3lHJeLy2CPNhB6a24jnoMNpd/DHUtM98mrefZvq4o0HiR5EawGN25q
 MrM0Uoso
 IeQB66/QJupv3dsDSSYqcOHOlZfeUpdt3Qba3TUkflsnKwZ62gxo48bJehu30wRkTYUirZEWUcstrpLsstELrEUccbRfPRWUcHkQwne4Cw4iB044Tfg9pyY1wQkzD+BQGWa2VCxV1RppIsvaLQrYzYxVEnrwOOQk+RYm+MGw+GyPoNrbgBljByx2Fw7WJI3f3c1tjOssKNewlHt/izlxVN2Lbm8ppXl2Xs/it60nUCVEjEcuHpFtsgH4QChJ7/ymZlenW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PSI based DAMOS auto-tuning and DAMON sysfs refresh_ms file have bugs
that can produce non critical but still unexpected behaviors.  Fix the
two bugs.

SJ Park (2):
  mm/damon/core: initialize damos_quota_goal->last_psi_total
  mm/damon/sysfs: set next refresh jiffies per sysfs context

 mm/damon/core.c  | 16 +++++++++++++++-
 mm/damon/sysfs.c | 11 +++++------
 2 files changed, 20 insertions(+), 7 deletions(-)


base-commit: 3b3eb2976e2dadfd8624db7ba32ed28addb7e416
-- 
2.47.3

