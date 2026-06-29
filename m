Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27C4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34936B0110; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE46B6B0116; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD6E6B0115; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94CD36B0110
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11085120146
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:38 +0000 (UTC)
X-FDA: 84933234036.29.578B3AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8548F180012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NUK0R1dE;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744576;
	b=H6OiSPMbpUMU5LTkAPe29oeQAwwUN6UNNJtuDdF4lvaSJeYk29nfQcv+9O//ga/mGomw6g
	WUX/Th3LLJoAo4NyCzUzqOUgsT4UBcvsX3xjL6V+c/wPY9bDdaRHlhbDmYc6/QmaxotFI/
	lvlzVQNfSGzq9dIXZPz3QlBni6laVjc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zYB54nSNsC1cSvePQMmqCTyhvQRTVTX+nG90R7aX3cM=;
	b=go9uYhpBkfsLNRwhh1vQXkqwpbowTvADO7vlMVKh6B0S3DIDDogS2PwlcemgZqjJvw4rJ+
	9VFzlsFCilI4y+YNXY+c1TrLBuqCBm5FRMPnhEnwQsfAWR09OWxBt7pEfSXTN/HBrozofc
	2nUFDsUQvCsLf/3ct2+io9HZQILrXPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NUK0R1dE;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B735140160;
	Mon, 29 Jun 2026 14:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6434A1F000E9;
	Mon, 29 Jun 2026 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744575;
	bh=zYB54nSNsC1cSvePQMmqCTyhvQRTVTX+nG90R7aX3cM=;
	h=From:To:Cc:Subject:Date;
	b=NUK0R1dEJcu8e5K+/EOxUGDzwIFsmYJ7Y9pvkPMQgkPlafcii5zsPnhsJZ6mn4d9I
	 jgGj0DA3FIN7j+ceIyVFKqrAZOrxU3rAzB8RKswIOOEpzQqKc6gZC/h+vp74Qz7Q7F
	 3D2XcEn9v9jgwMdf7JmLrOPI298bp+xG8yWlbnYDqE9hvljayGzNKvPrGmi8XQGdUr
	 MnLNZlWnO5bcm9D8Mmkrfsha3tayGPlqGFMjR2zKOCcI9LzFuJLbJgVQ1nlf8UdBH8
	 UK0anGAEX9uC3BkyY49RU55YN07nk5fMnrUJ/SgLMpt5fjDIfDg7dRqv42gd7Ml7px
	 fQZ7Nh9YqxdlA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] selftests/damon: test kdamond refresh_ms
Date: Mon, 29 Jun 2026 07:49:24 -0700
Message-ID: <20260629144927.134237-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ds9ibpenjnd3qcchbihkty5e1ywugoyz
X-Rspamd-Queue-Id: 8548F180012
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782744576-905599
X-HE-Meta: U2FsdGVkX1/YDqsHCo3ckm6XwvtIuCiyIaVpmMGftPoWBM4cjuiV21UDfQ/Gw8oApoJ8KrUBN+dGUmi7MURyBKP0s+ciCByBL+sBRlEiWTxxavEnRUhin9KZMloMah14pOOFpn9iGnvWWEeCvUF6QDHpKDEKHgoAJsqYX9Kt+HSRulStAW/U2L/6m07npubJyhKN2tvFdtYTMDHPh+e8PjiTp+I89fjdOFExuRekVqTSkUo8X23gq8ykMAzSek8as1+HlVrir4QJr9GaWvu+5MOpJ7GxqJcsthAXDStAbdplJrgdPcO3Y/G2Hr66lfCA4kG7fHPg0FLjdJ2LbC9ZZVmdcaQJDENxVWjB5s/kqCqr/Lq+WBdta9gDvU4Qint9Tm6J99uE4RKBUrOImqlCORu4QE3KqevYrdHadHLlHa9bk7fSSUoLb1SdOx+FH2d7AZ/rcVg9SjTXBBkIvK0yM0UomUGwztbdHoJE8XhSURq4zRLr8U0rWnPchxTm8VNGN0pnB9pJXQZUvvvq1fOU/nOuOiZQP0gk0PAfAWQPGauqnxt5/cB4OSO4HKRSGtGiZCV/hXVl50hxg4yzZgW1G1y3xSasNWpz3HGgXTy275dDA9USCwmuOvG4/H0GiDgB5XUOvhoP1Wr+TT36FuzQy7/u1emcoEgynOSOtuopiZ8YjoLamYfyfyELuU6Jp+KY16nt9/QOBIVfw0JCBvkv0qKNMTEp0u+bIscqQwI4knkKhPH+ma477Q8X5ARPg/GR7+6BB57eS8dag8K+AeBiRpklhE1smaXJtNo+24m7VueigYCWIexjcokHi/sleL07KFJ8XY+ISck3ARj70EpMQWDMvzZw6t6DzDQlw+fu/5z9a8RtqH46T8XRCX3PI6YOez+4/38mWjojQS9ZVYJT5/eQZDjaImk5yJ0YXz85twaIfiKWRhnjUE36U/G6CBgx8fZjk5miUwETfEM+3Xb
 WVeBAR50
 n4VnL60Cdi91K2oXaX+V0g0/R4AQbKS/Cv8wpoCBPrQrD7AbCm/mlB+2PqEaSr6CUSV7tthyuHYEhkqQ895MMjyOo8gjG9mz85ODKEE5LrD/qhb1/34dWsV7sI3WvhW0Yn1SVUDddBGVJwG3dCF6fEbkg/VkadQKyZ9fHQTImHodT86jkgFAkwrg/ZSzrG0LwWr09big7VVFFLoVVNvLHt4+Hz/e1SEE1SEIP7lEdnGYXD9FEuOJNexZ/nXnYEYRGNYJhqwLjuvkob1uQPjO4w4/OCTblldTpSHTm0vsF9hM3D3i6KDX0dNvVKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kdamond 'refresh_ms' sysfs file makes DAMON periodically update its
read-only sysfs files (DAMOS stats, tuned monitoring intervals and the
kdamond pid) on its own, so users don't have to write update keywords
such as 'update_schemes_stats' to the 'state' file.  It has no selftest
coverage.

The first patch adds refresh_ms support to the _damon_sysfs.py test
control module.  The second adds a test that sets refresh_ms and confirms
a scheme's stats are updated under sysfs without an explicit update
request; the test skips on kernels that predate the refresh_ms file.

Tested on current mainline under a DAMON-enabled kernel: the new test
passes and the existing DAMON selftests show no new failures.

Changes from v1
- v1: https://lore.kernel.org/20260602131217.2210912-1-linuxoid@gmail.com
- Add R-b: from SJ.
- Rebase to latest mm-new.

Ruslan Valiyev (2):
  selftests/damon/_damon_sysfs: support kdamond refresh_ms
  selftests/damon/sysfs_refresh: test kdamond refresh_ms

 tools/testing/selftests/damon/Makefile        |  1 +
 tools/testing/selftests/damon/_damon_sysfs.py |  9 ++-
 .../testing/selftests/damon/sysfs_refresh.py  | 75 +++++++++++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/damon/sysfs_refresh.py


base-commit: f46247bcce72b9e62868c347711c772657b00ce6
-- 
2.47.3

