Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AC26C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8D26B00AF; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259C16B00B0; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1705A6B00B2; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECDC96B00AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 796DD16021D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
X-FDA: 85168990200.07.C0CE036
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BAB14140011
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsqQvQ8H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JPsgTQPkQ0G2HH8q6SAx35JPDkb7YxAfcT2O6alXh78=;
	b=r9sunnMyXr937IHg5xdaV1HhAVlMFYTZyhq4Y4DYr9VUWZ2rUMy0v/k8eAsY9ULP92D5cE
	BdQXc4ZuscpKzwhmh0mBeDZRWg/vzpTfEikHkSN9i6HYETRTWRTZRIGU1C80WSuNRMgDjk
	/q6KRl0kYId4o3LhivmV3bNqC7bmpt8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsqQvQ8H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357818;
	b=gdgaoOUhg7rD9wRsNechC+upvsPzSS5UcYYPPhcOweauF2RmN5hvwIY78d/8vr6A/ezeG9
	65gAbmEs+A34Wx6I+Wo49uJWhxrXSwcQ8vJaJNCAv3/sA/IAWzxm9SV7UCKLCm9pdynWrf
	mSyiMJXzF+6dnQZ+cF5BW3PhfHc/QWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBFD740816;
	Wed,  2 Sep 2026 14:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF981F000E9;
	Wed,  2 Sep 2026 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357817;
	bh=JPsgTQPkQ0G2HH8q6SAx35JPDkb7YxAfcT2O6alXh78=;
	h=From:To:Cc:Subject:Date;
	b=UsqQvQ8HDnmGWzvCGjsPBonrrTKK5dy3EzkcWm/uNs5Dr3z+DM+6hAlaFp5N6tjoK
	 ub0tZMjAe8zSq76jtep+Olrvh6lZs2MlJgVxxZpCTqcgxt03o7z7qLjDNEvbofjfLc
	 SaC8xneiRD3fL+N11m+4GnxDBYwWwQIMfhi8WqkwkGD71IgfIc/MHktzwTC9/XklML
	 rrxJYF64M5CHFZP15R3APJK6EEtQbJLPHpgTIQ+OvmUR3HPwDMTYSCxb8MnPTH1Kg7
	 hcGFN+/LxNbRPMiHNA38TPwVwlOVIHCIKC9msHiyO/B8I4lYbJhS2+4qMidhqYOyHF
	 S1daC8YZY0LfQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] mm/damon: add kunit and selftests for probes and probe weights
Date: Wed,  2 Sep 2026 07:03:06 -0700
Message-ID: <20260902140313.85983-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3iurn8jxf6pu7su6hdmfkhxauiosiiea
X-Rspamd-Queue-Id: BAB14140011
X-HE-Tag: 1788357818-323078
X-HE-Meta: U2FsdGVkX185d9UKi6EpHzmiE4TqijGqAE4iB/qqNOjKN6IDM2K2Q8qiXgYmOYP6WL9+N6p/jA939QoADryQJhHDewE5pTyh+NYTkJYIvjGlVMGi4kwyCHXzJrtPQeNPkKL7kFTGO21FqcMtloW/ytIrxGhd8xbKgX+6n6UGvytFAy17zFv6ApxTIdMCMsXgSMAVPgiJQ3x0foKyk8Ip/6RU/UiiCSallYI7N9PWcQKLz08w6rkEQeIVwXNUSNDdoJdt74WcfWK3rteetXE6mA01GOZdgolnrQjo5eem46p+iU7cvaEf5x5hPrZpdPB03bESaGO0WedIMmbkp0MQcDc4UGrFP8C7IgnLPKtDiOMW3kZDKcB37F2OrBo1cXR5uE7eI1enNXS1QeSZJemolx0E7tYiA6L6NGOERUQ/qAYLWHTx2RKFWSkUIOW0CiPkiInlTHmpvo5ZO2UntG4y4yqXlO1XCilQYZynEjxl5Bk9mezBYqRdfxCVPnn0A7ffBzImEzVOXtZwDJB3kvwQZAF68Sjn3zrjwGObCA2SjdAZsSGSHi1UKcNHTWLV0cyCqVcMoXxou6xV2nfxqvPQgOqZRLPpAgREmUOy2XlH+uwbpz1ejx048x17nuZqgPJKMZp2yxYetLwSe7xyhPCdIfWPH6jH/yhDHs3QQXB74I523Zh0Dj8I1cM9Ksv0SaP8qqQu57gCJmW1lLWlEqPXlhRKOFPI05QAzoPzcRE/g/gNMD8Corx2NF5tQUGuL8Bw4Wok2L4L6Nwf4HszX5GXhHkIhY3jehfw5Lsk6I/3h4H+iw+CnLOYxayUdu0sulspObNVSlfq5TCfDiAUy5KkLUya7FMqZvECqZE6ldZEgMd8ZJFIFcCgJd12AV3jqJwoxevXJTFQwoLceeddndSh0HqVNX8+h6XD+YxBByR6jOPvQMT+7ZMjP+hS560VWJwnNasQRnY2H5Com2EEUL5
 9WWPGrT7
 KYnS1PqOWY8educZeRNK5FzSLHjvZJ/F31DvAXWLCyoNl1A2Z1OiY4lYW7jygzVSk+ggkFAY0qgiRyDys/VBh/wGVWkFvLC07cOTjmMCGUMy0ROl0XsWkqgCFaLH+3ZkxlOF3aoCB/Khd9cnSxPi6VlUN5MS7ryuVBVWZktaJ/Tp15CJfTA4RaSV3oy5dI4TXNhWx2SvhNh008KH26pBvBJM03CQH5m6z50TNMDQqFYnaEm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON recently introduced probes and probe weights.  Add kunit and
selftests for ensuring the parameters for features can be set using the
core API and the sysfs ABI, respectively.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260730043944.146030-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
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


base-commit: 7b23d7e8fa8464c92cf577d01b1ccc2f9a991cba
-- 
2.47.3

