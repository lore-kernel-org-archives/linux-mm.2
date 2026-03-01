Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B80FD006E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F9F6B00A0; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC87D6B0093; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03E66B00A1; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE4316B009F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DF081B8803
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.22.7A77AED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A80ED140004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HMQeBh/5";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sElFkaRIpVdrMjTMNkTCnx1sWbP1AlZTmGDO9EQEwe4=;
	b=J/tfF9uedWqC+A0n9cKwoDzxWv3ZUeRZavPlLMkhwdM6qgA6BHFtRkxvuU79Uf5QPJDOuG
	8Uoket67vVAEli5d/z4Pw8ooBIvkRGveoMF+4EmMgAxpooVuIv4XOImEB+Yi882Qo3mmKe
	aM4kHfHOM5ZWbSu/k/WeWpq78KFEhXA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HMQeBh/5";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387012; a=rsa-sha256;
	cv=none;
	b=ODJgpOR1+ZP4Khbe2dO6i6BxO9j3getzeeiWFeLszi82Fx0LQckuvz/OPq5wiq/RyExwVm
	9hRW1Lxt4Ff8wBqlk+3SZm6pQzs+injzUxi4eyZg8oK6ZY7AXPUC/itmSffHM8JpWXWxYB
	oNWJ6xBU9nES9IkvFENgC5dvj0DZtv0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E5BD432D4;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F4AC116C6;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387011;
	bh=+CwkXbOh/Fg6OBVe8JUapRvY8ZYQMp73JI7BMgt63xE=;
	h=From:To:Cc:Subject:Date:From;
	b=HMQeBh/5DjKrwDG2HtHsTqzr3oTuh45Xn+J8cyc9lI0TmzjP/N1s9r/nywlh347yi
	 h4lgUeq8iGAUN8KILGk3q8JeiFVMJvw3CoLHKwLh3M67Ozwhites3cKQRJhuqbciyR
	 oz8VJ+LY0XSpTl+9LoxSPCjOS6Hk6a+/aaGiNqk4d760PDAI0fBOnm2ta4hcYLCW8S
	 sK6Wmcsv5kXDzGefzFlR+tl5H61dsAna9Cv76OjegaRMdTCJnSGTcqK6Pc8QYApWSJ
	 vsBGFlnwDmGFpy02IyztVzOK47cx5aTJgA34hARbxROOvjMzf61urrTP2WCHvhwOV/
	 5pAlC4YTWud2A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 00/10] mm/damon: add optional debugging-purpose sanity checks
Date: Sun,  1 Mar 2026 09:43:15 -0800
Message-ID: <20260301174327.76849-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A80ED140004
X-Stat-Signature: rw7yao5wf1jh9ofky19aq8961ai9ft9k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772387012-366899
X-HE-Meta: U2FsdGVkX1/YJFesWqQHUA3gjuO2gi3iCc3YVgpWV/YqMGPiEzXfr5JZaYIm6s9t6X86C/+9P5dk52l3NjxaFmc/rp40S8bud43BbkyKQte6DThhSe1S6+YBcgbhT9nrvUBx+qf1GDKi/FVLOj6Wr/dpBYfxoZMVXTxPI/jWxTga8AZ0pSUsZxfydUD4E+K9aMPNZR0LoieiXHkgl0B9lJEoiRfSM1SpeRHShsLyApAOTYpLxwLK3fo0bwwBpCROeELnnBnX4MTQCNZn3dnwQbQiPc4y7tD+wxYV6oAjUYPJL5litfz345XAE7PldptLd7tX8wqHfpL1iw8JXmpUe5UUBq8IQMbNfRQ7UdUYlsfh2npr+6PicVd3KIxmWdoWK8cK2AOJ9ce0aIkrRB4y+n5f8DPk95FEg4uGLv2RuvDTOPA/maqz8HQOuBeredV55AzsxmeYlQWvRcfQoBpxezfQkCO1+Ui4UoygFysF/l/E5RgT3xxMb1y68DREXS/Q/gy5/Sxq5PIkq1UXszhOSLL69qLScYyW7sedDJyV8L4+ajs70JavM12uTqCKxyuu07FesOD6XKXs+erI9MmtxM7cBayQhrbdyLjFHsKX4EcUfg0BhHQ+U2Pn0C06xkYkSnwtZVeb0oJRweZ6S9tZ7LtuqqywYNihMCQm5WFU6r9GE/BDDy7+Zcv2ULDHvFYAprwmMx2/KREXpoLlJfrE/PK36jSwFPIZxWJ2Ev9uaRMpZQL4i3Vm+fb469HW+LoIK1ZkRLcSnGKlmotwY/zyhZCEfJnO9jQLkUxzU5NbBiBLh3treKxzbqVC227NcGRfQMlGN/BQ0rNxAfjNU7nCrFHTCBzuX9mCgKz+BUTjTcVmtEcZhemz7uxhP3d8yS5ZlqSUquE3yNwXv02xablwY7Y8oj2B74JNwVcOGZ7LCfhfjTlqr5dGdI1wISS8cpjK6xqHev5mPK2fPWSqQYw
 nG3J+Ops
 iGg0o4CQ1QcEKpYp1iGSsvQReEkTtN+eqNeVONlg8giidETNDAm+42PLrLsM5WRspkLoHxS5Rme1qSS6RYMUOyLp+Xlc+FECk+RNDMhkYrp0Zuj5uVWdXptvc4g+WphTel/B87zswF+d4ZLlxGJZlYQIYJLW87UmLhLuU273mGsNNHd0sOdXys4iv/D5qjV6zhTAEkAIsnOrsbinM0zoWEb8fnCDoE3x/Jv2AeZbXnevLSjsHCGelKmWCl6s7akvSdgOYRmllO3LXlgieQv7NZSWYwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON code has a few assumptions that can be critical if violated.
Validating the assumptions in code can be useful at finding such
critical bugs.  I was actually adding some such additional sanity checks
in my personal tree, and those were useful at finding bugs that I made
during the development of new patches.  We also found [1] sometimes the
assumptions are misunderstood.  The validation can work as good
documentation for such cases.

Add some of such debugging purpose sanity checks.  Because those
additional checks can impose more overhead, make those only optional via
new config, CONFIG_DAMON_DEBUG_SANITY, that is recommended for only
development and test setups.  And as recommended, enable it for DAMON
kunit tests and selftests.

Note that the verification only WARN_ON() for each of the insanity.  The
developer or tester may better to set panic_on_oops together, like
damon-tests/corr did [2].

[1] https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org
[2] https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff

Changes from RFC v1
(https://lore.kernel.org/20260221193629.19332-1-sj@kernel.org)
- Fix WARN_ON() failure on kunit UML build
- Fix Wformat-zero-length issue
  (https://lore.kernel.org/oe-kbuild-all/202602221352.odZW8x1R-lkp@intel.com/)
- Rebase to latest mm-new
- Make warning message less verbose
- Use WARN_ONCE() condition
- Do the verification asap
- Minor cleanups

SeongJae Park (10):
  mm/damon: add CONFIG_DAMON_DEBUG_SANITY
  mm/damon/core: add damon_new_region() debug_sanity check
  mm/damon/core: add damon_del_region() debug_sanity check
  mm/damon/core: add damon_nr_regions() debug_sanity check
  mm/damon/core: add damon_merge_two_regions() debug_sanity check
  mm/damon/core: add damon_merge_regions_of() debug_sanity check
  mm/damon/core: add damon_split_region_at() debug_sanity check
  mm/damon/core: add damon_reset_aggregated() debug_sanity check
  mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
  selftests/damon/config: enable DAMON_DEBUG_SANITY

 mm/damon/Kconfig                     |  11 +++
 mm/damon/core.c                      | 109 +++++++++++++++++++++++++++
 mm/damon/tests/.kunitconfig          |   3 +
 tools/testing/selftests/damon/config |   1 +
 4 files changed, 124 insertions(+)


base-commit: b511f483f5fc7e85ad60679181503f16937feb6e
-- 
2.47.3

