Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D2CFC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1926B008C; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662076B0092; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E976B0093; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8EA6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:39:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF1F6A1D53
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:55 +0000 (UTC)
X-FDA: 85044190350.15.5BEEDD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 509FC140002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FR4wtcsf;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MCnIYPHXEtymrst9y69RVa8dORmSOaA8BOJP/O1Ug4Q=;
	b=hxiYoZaLBBigAhJLIfIlI1UeO0p1r6iozRTUy65SF/GD7s4xrTBy8/yuw55vnSSu/Nr6dH
	2d6DD63MG9b2OXmCpFU+vqEis0tLcJK0pGyWjXDOvN1XGEiD6v0tYuj2bCQfv9vfe4ydFt
	fu/H4iGb+2fwFT1mM6uodIYhawijMc4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FR4wtcsf;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386394;
	b=jzYDBeaA12h/4mo6VzKE+Sv21hVZhaxkmC/bEhcqx/1gHQz5yqD8z0e5yboGfIjwImZWMq
	MZnYKTsLgksZnP0JAOITbTIyfNGbszzg2hy66mpVklckGCieaR+RP5bInnm53qJqvx5mIt
	tMb2r9HVVLlVA8wIY8hZzOdr7EOe/GU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE0DC600AA;
	Thu, 30 Jul 2026 04:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4F21F000E9;
	Thu, 30 Jul 2026 04:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386393;
	bh=MCnIYPHXEtymrst9y69RVa8dORmSOaA8BOJP/O1Ug4Q=;
	h=From:To:Cc:Subject:Date;
	b=FR4wtcsfp9dA6J8+G5x9tNShj0PoD1NOFtyiZTJZTa7O6JUEI9XbBhqUf9qOgDpJt
	 Z2tBCQjOvVCjBqXd1w4eZ7l/ugyw4zBWwnxv5dfUVGQIJkAA/xXXOpF9pkfnxOXSdn
	 AU4kqC7qghZKggdMeQZANgWlvAeu7SSNobAFY8fDVfqe/ANpOJ1NQTLqihArR3clMj
	 nPK45o0gHnsFeD+N3rB6hgrJ55MjYz18lhGEu8Xb0jIom+uGU3CsItct1O+0JjVUri
	 DuEwhHpYVfyJg0wZL4FRg23HlZ1U0ZC4m7WWxIamJ+ya8XdZvkGXs9qlkBTKyqt58s
	 ik7CizPG6arMw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/6] mm/damon: add kunit and selftests for probes and probe weights
Date: Wed, 29 Jul 2026 21:39:37 -0700
Message-ID: <20260730043944.146030-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 509FC140002
X-Stat-Signature: bd7wqsyk1yo3oehsozbitxmo53q333gc
X-HE-Tag: 1785386394-116892
X-HE-Meta: U2FsdGVkX18qQothLC/wCKKXi/8jWP7MFR/Hec3BgzKn4SVfJiiBnEgs6o7b7ZNyS5ezhsuvmRK+PYuDLJDXmCGehabBx2EOzOei7UMZu9mGKmw5GHo03/+PUhKw+6G34w+GatBSdJTwrrMzQk0Ou9LhLya5kf3xvtRLgecLigcPTNMdkZhm9Zn/ISwozempBuLBFfKxCH9uJsLd+u8YoXvs7AF3L81Pqy2Z3spQYRWX3CI13LnbgARTsPX08pe0dsVi4uDjAu3NQl4gxwTiNz9/mZUFI9m9ByFHS9AZmB61ajxa6n5CezZ7C1hSl8zuRwL7nM9rw5IVB3+8QAZwppXF3kOHJUakvk2pzMWeyBvxFq+GOHCDaTXdhZeXwqwiI0jUs/urepnXVI82A2gkrhxVJCLqp25rMt8uaCvbnouSpQfgsYhabnkQTrivRWQzG0NLRt/8fqyzEotdnuRv4coKn1KYwCM+oFDF+OnjmntD9L0yHRI+dv9HTfH8+SpxHYgB8ghRWqIPoMWcvL3PhvS7lOdAygKFayhqKTMaGH+NWMPO7s4dcgT4zjLytbD9ywqGnyxXeeyvHgSJ0Trk4wMcvWufHYVjWF7tz8O1Au2KuKw1TICm5FhQzMNaEtELjDHrJ/OYivbAbozYNHwncGbeeg8rvL86TNXFqCxhZwT8Qn52ymG0W6dLAm40/iaoZyxw/Fy0AeOkkIsTYESj6PY4E5E7WBKj2FmDJDkMYxoWpgwqcUFs7m91hB1padaVTaslT8YiTR/2ll8enHmbgXwSFpqTDMGiUqXl79GxiFPxnRxwPracuNcAL6YLI4tJaKsHw7G+WyRb/STRm9uaqh10TibDPcRe+TwrwRPIo3YSb21KhbVC22MFXvH2qOfqD07RrCSzpUd5yErKe2cCvKFq5MFRnomiuPdoSBRhcgQ5zMEMqxcOANK/g9AJNqTGq9gt84xQOl7LYhbAC4J
 VFvYzxkw
 5Ag3Ta3jRyWyR9k8BmqQ1sM60tQDpqmHROk9loqT3ztFLnvzhA2j1SdyPwQ4VyNBYESWlqlUP/weqX1rqJp7EGJIVt6cz2wTROw50WoCIX2yLtv9NMcvOBUwUFvmCKY3po6UbSZ+btJZ3gBnpzxbcoSjky2/uTW1+84BYwWdHyxK0ERwty03YUw9DVVLigkUk9X8QLy83DfKY5fpjiBPd5SqNtTHT/v5T1X0pYFo84IWluto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON recently introduced probes and probe weights.  Add kunit and
selftests for ensuring the parameters for features can be set using the
core API and the sysfs ABI, respectively.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260729144738.90895-1-sj@kernel.org
- Fix a typo, memory leak and NULL dereference in kunit test.
- Fix ignored error in selftest.

SJ Park (6):
  mm/damon/tests/core-kunit: test damon_commit_filter()
  mm/damon/tests/core-kunit: add damon_commit_probes() test
  selftests/damon/_damon_sysfs: implement DamonProbes
  selftests/damon/drgn_dump_damon_status: dump probes
  selftests/damon/sysfs.py: extend commit assertion function for probes
  selftests/damon/sysfs.py: test damon probes

 mm/damon/tests/core-kunit.h                   | 124 +++++++++++++++++
 tools/testing/selftests/damon/_damon_sysfs.py | 125 +++++++++++++++++-
 .../selftests/damon/drgn_dump_damon_status.py |  32 +++++
 tools/testing/selftests/damon/sysfs.py        |  35 ++++-
 4 files changed, 314 insertions(+), 2 deletions(-)


base-commit: 1e413a0c40e2aca4a55f9ba664b2b7ac2a03c9da
-- 
2.47.3

