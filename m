Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80FBC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9110B6B0088; Mon, 31 Aug 2026 10:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0DC6B0092; Mon, 31 Aug 2026 10:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6B96B0095; Mon, 31 Aug 2026 10:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 601B66B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC299140168
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
X-FDA: 85161789930.17.E94119F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 824DD100003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qn4FJMnw;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WLeUJLJYpDmFjxBILukrXtcofCnOjUGJ9w/aNU3G8fk=;
	b=EfghMQU+RpLyfDRxspG8RxLLmQX2LXyLnN2yEuV1QqIhp6A46n6xrl5h9K+WH2zhsWu4Ny
	9HojAiKJ7cXDpWVZr+T562BCr43Hc1xV93wN4Kv5tDiurtnvQDsCep8+yNNiICje37IHPs
	w80xxL+moobvPc6zgCd0dSBIheTscfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186384;
	b=7XLylwFdjhXCh0fGMu/AxhYyNgDBvQpxNmcfnVa8aggW7kVW2FqlNvN8yNEa1jlaJBLWlo
	qa94YVdAcLcd7qexIKr9KVRilxyIoQm7QaUkDBKHCox8BRThTW91HbcWjqyrtWpXbGFn9k
	h+Z/g0s5w8UI6j8hRI6YI9Igr7y5C+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qn4FJMnw;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 020036013A;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651AE1F00A3D;
	Mon, 31 Aug 2026 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186383;
	bh=WLeUJLJYpDmFjxBILukrXtcofCnOjUGJ9w/aNU3G8fk=;
	h=From:To:Cc:Subject:Date;
	b=Qn4FJMnwqJ1tVWBtnDCKXBEcM0yNf9/lDDInE4uBfFkJtoHOfzF/x8cN4gi+5lg6e
	 2X5xMVdT92vUXbR8ZHf2foXPBSCTKBDejGrOwgitD2HmyQHrULY6PjfdcR09fZuphv
	 HLz3mbAOxGPxqOnnOSqtI8mpn1gcsSzWinxtepUZWTjpXxXZGGn2721cxU+ojV7bGj
	 NiB0KPUz48QSBC6PMa5Ct/3AI5AipabCAkzck9kXQ4m8lcWJGjySeIc8OH8RUePxfU
	 7hMikOIGowHHaIIa7gIY5EhPU4qNIZZRo4nuD+EKa7UE3rndlgphj2+xp2jgHrgoE1
	 eAAa14X4Pg+qg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: misc cleanups
Date: Mon, 31 Aug 2026 07:26:02 -0700
Message-ID: <20260831142611.77572-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 824DD100003
X-Stat-Signature: mfq1a4y3wd5fzdof3iaa39j6xczh1h9h
X-HE-Tag: 1788186384-662946
X-HE-Meta: U2FsdGVkX19TGXMnSJkRHfyW+LnbpX81JuH7iqPO8gAGBLVLDthNGa3rIMHnBDQgKsANz9Xf/h+KkstlLv5ZAZ7K6Tjh33TMKGMzy6zqep0TGIViCgskn0kXJ4nJTAMcVWT6X811nmy9C6sv1j80gLIIvSzaCwzVnxnH+yh+ZQIGepo877Xvc85ZLLFLqIU4xTGb0kiHwKKTlM0AeApNp4zi8xRKSJyXjLGwqAs1fmaCi3z/GE8L1TtNRZ68Skz7YfHhU0yCU/Gxf48MwYBHfcSKpgkFfMCpnVBbzXhSh7RzSRknNCY0iQqnw1IwoWWxVpkuZZfoqNWcGPgC7JWk9iTw/vdl/tPxqUZFQTJcQC+2jn8i7cJ8J31OMSu5fdCd/Q67JYJBgtwhnKFpwL8bmL66vRWQcEt4ECTnTsxREXs/h/QgyHG+Dt3l0zkcrkIxH2paZm/B/tk3limkd3pRCCBX5TgYHtZzo56hCGqzSkgxSV5GQC7gEM3mbZ9Woa5JE6wPnX+keVM1084l/2vAN7j1e1b0ztbLTtiRKxjkOpLKskwqYYwKhIfdvnRAEUgdZ27pme77Qu2f4JzrMXu1T5N9eHGhHtrZS2MvHPYjHePFxM+ZWgUaaCpNlCw1pU5VTf6UTAT6RJwUF9eXpzdagPvwd+9deUMv/3OkuqMTE4cMM1cLC6Mklc3OQ0sZWEeiT20OcjQBMPpTxCB5SjRNevqglFJkFWYXVKtdYzrfa5MDummgWfs6QjWSYdqEkqkzeJWvEOgcfpN9MATx5mgREBTgHVvoTeno+rB0p7z5Bjlb6P1q6LhymZTn15e5K2RVMlj3g+9jIUO7dGeIiyW2BedZyMh4YKwHy3+x7CgRTy0SlGMiNTflYisXfAqj71rPETySAzf45G8MmG8g9XVNO9D67fN5fGKz5B7WXmykTetjcbnlJitQzmG2U5914qCeXN8Qk17M6wKuM6krHtw
 ydN9FuAn
 CCoH8BFNgnqu2QFTKOnW1tpkt00dcl7/QKX+A5fU7BkCjlfGob/b/JfABlnCgzLBoV4MmzXRVuWw95MeEGbtio/rOe1M7FcJXMC6F1BJ9i/5m6yVVgWfSJVlNdsd9ngL8hK7TrwBmJnWhldrACuGylIERCawL8Bgq3PX6L8/Cz+J5gIJ1Qnsa863Jbxm+9wkFQ7HAcFSXSE6Nc+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cleanup the code, tests and samples for clarifications and readability.

The patches are individually sent by the authors.  I'm reposting those
as one series for convenience of handling.  For this reason, changelog
is on each patch's commentary section.

Enze Li (1):
  samples/damon/mtier: add comment for struct region_range

Hari Mishal (1):
  selftests/damon/sysfs.py: clean up sh processes used for
    obsolete_target test

Jaeyeon Lee (1):
  mm/damon/tests: use scoped_guard() for damon_test_ops_registration

Li Youhong (1):
  mm/damon/ops-common: factor out damon_putback_folio_list()

SJ Park (1):
  mm/damon/core: introduce damon_set_target_pid()

Zenghui Yu (Huawei) (1):
  mm/damon/core: remove declaration of __damon_commit_ctx()

zhaozhengzhuo (1):
  selftests/damon: prevent remaining cross-object state pollution

 include/linux/damon.h                         |  1 +
 mm/damon/core.c                               | 14 ++++++-
 mm/damon/ops-common.c                         | 30 +++++++--------
 mm/damon/sysfs.c                              |  6 +--
 mm/damon/tests/core-kunit.h                   | 21 +++++-----
 samples/damon/mtier.c                         |  5 +++
 samples/damon/prcl.c                          |  5 +--
 samples/damon/wsse.c                          |  5 +--
 tools/testing/selftests/damon/_damon_sysfs.py | 38 ++++++++++++++-----
 tools/testing/selftests/damon/sysfs.py        |  4 ++
 10 files changed, 79 insertions(+), 50 deletions(-)


base-commit: 58132fed7967e3401e3f293a0a2cc983161e229e
-- 
2.47.3

