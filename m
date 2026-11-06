Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9680606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YViRP3+J
Received: by kanga.kvack.org (Postfix)
	id 90B436B05B1; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FF16B05B7; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710406B05B5; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9A76B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C90AEC0C58
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:09 +0000 (UTC)
X-FDA: 85403054058.08.D7B8999
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D8DC40006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YViRP3+J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+jfAcZvSxO4g28unhuivWT88AZU4hI/BOX/Z4s4PPy0=;
	b=qa02MH0EgIV47N6y9kKvIP5i4YznUOz/R131zi9VT6fO2Xf/F0COnFOPOeDqX2wguIOJoK
	hbP8hqe0L4WsxkjaF8LR5GNlDAuyBks3/VukrvckqW6srZGZI/xZ2lVxtxJm5bYQNQl7hf
	aj5nkFsmU0e8XVA0Haty824gY7jGlHU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YViRP3+J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930768;
	b=Ih4f9Tl8wX3+mjPqX5BXYkW/Z90owTofhV85fDWiiBGUsPQgIh0tzkq7IdwjaWOn3qG3f2
	zNrGPwxbf6GPq23FcFmSdg6xR1Q6BDUPTtfe3PWUMrlqvm25CBh84yjGDiC40zKL5Kz0Rw
	NheaAJG7qrUERooMA/zmlIURJ5Snmxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A095601E3;
	Fri,  6 Nov 2026 02:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0191F0089F;
	Fri,  6 Nov 2026 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793930766;
	bh=+jfAcZvSxO4g28unhuivWT88AZU4hI/BOX/Z4s4PPy0=;
	h=From:To:Cc:Subject:Date;
	b=YViRP3+JBx0U/NyWH9/JaYvOBxsvdJHuPWnx/znRaVcUJG5Br2bSxRVILsrtyploB
	 I2N9qQ0q4+5BpquvAzUvhS+dNU075TUW9mQUdJIHNP5Z5nZ/5KSXANCVGml5axjAc5
	 yYPDc1H+vczREA3nKWnImiQ+7dm2OWIPy9AXfWF+thanS9C7wmYd5cRC36us/N6M5W
	 nBCyyE+sBwC7AmGQargd7SZ1zZwjKSw+vH+9jJRlpz0mCOpM2UfGshveKWq4oU/L9g
	 1RSG6L1f21Cc8+ENpo04tG0Fl6ccLVTtKAin6eTfAMMWSuaK8h4de/vFIouv/BZfZr
	 xNGAxY3mpYULg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: introduce age_ms damos core filter type
Date: Thu,  5 Nov 2026 18:05:54 -0800
Message-ID: <20261106020559.98352-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D8DC40006
X-Stat-Signature: dg16sth8wzmxcshk8mm7zc1py8atcqwk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793930768-634727
X-HE-Meta: U2FsdGVkX1/JtCemRzSlsYFw92fwSG31XShGodfXeyGkNTQsCdHK7mQ9PHKdL4JlEe8OzJpj7hRktxs1mP4LT8KngKAQ+s2iorXqQjU3M44P+SshGJiqqI0QrX0PCRyIGEz1cK6jCIM33yckkgmFesBlDGquSP7q90HMyKOAWpzxErdkUSjWBICcP4DDtkhOdk5spaQV56OONE0QUS4ssoWJ4jvn7jJUj6Qtc5m0oVERYsgrQixLDc/CWEkfdKc18Iycg5iPkbRwRXA+NcwThJjzQpvud4ybs0ynWM3Y2OuPLUIjr8/eC+fAKN6DVce2jFCvfNbeRPkHcZzobH2u7AGi+L7lWh1UyYCjT/NZDFsIRSj5NdGh2Dbh6qLHMFXb6zBiDjUfIuJAvDR/V2sozKO0XZb71Z09XcrL0b8p8cOSUvdutPtbHGO0sYoyIdr92PWMD2Jstfn/Bh3fI93e7FiZrHxiWNB5aFyyVNAgC8FPbFkcj5ObW9UmXt73a7y5Fo1+xaIgjYXYRezQcEHmSsvFfy+SlB1yUEUGP6CSCN+W8d3qdK7GT+UkrYaKd3/cF/0LjU+aWpDJYT5zEzhktaOsL4S4CcbXSSlB+jf3GUprRSAvFhRmWpU999o/S+uOQ/Z7//SH+LnoEPYvrS4C1pqrJldKnKecxIxZcvm7kEYIX4tZwgO5Mu/zGaF7mu7zitQ+Glb+NCJrqUvfh5Rj46G+1WHJlN6JJhxoLoP0KdgsJAjN/wVGl9sFPjxNt4SjUQ8xx/l/8+T2lG6j4yTo6pYKTuU5gNXnKivVFuKAIdTFQyks2WGIMoJtY/fnb8EKzPPXx/NgxBJw+UjR8QxCiu9Lduu+dXO9/gagVoMDNe9f3w5sCozYu9UcGRXTvIRpW0UZtqlO3z6rVcLGmHI581D9p9zM22JN6NUmsMnAgDBoCvtjeiKRULsXh/3UeixgWIv2S1Vzu1obFJoslZE
 pNNtJ+IV
 YCsQUGnX0g74hM5Q3Y6/5VvC6uqKEmNXt9OfUhUG9IxySw8/WG3AQU+zSUvX+NvG0TVNYWQ/Ov/UueUhoQasxv8+SsU7LWQmh+k5mg+oKCL9+3sAiiBd74ItOVBwTeQrA9FxKFy89qT+DOqzPsyM3yUHgkI5XFS3f4fttJ95V0jgDhz8NBGnibn3KxFfcDYwiwE4xcS/US+RHDrWWpOZdGgs825laQzdGd5xK0LLHkJ+l2zrkzHkuDffiXOLcg5aIfic8yfm3935egbJG4/pEXXtFqLjLgvqwx4uhD3FwneUCllU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS access pattern supports selecting regions to apply a given
operation to, based on their age (access frequency stability).  The age
is specified in the aggregation intervals unit.  The aggregation
interval can be changed by users or intervals auto-tuning features.  If
the intention is to specify the age in a deterministic way (e.g., 2
minutes), it should be updated for each aggregation interval update.
Doing so is cumbersome and challenging, particularly in the interval
auto-tuning case.

One straightforward solution is extending the DAMOS access pattern for
specific deterministic time based age specification.  However, DAMOS
core filter is a better option.  It is playing a similar role in a more
flexible way.  It can be used for both accepting and rejecting regions
based on if they matched or unmatched to a given criteria.  Multiple
filters can also be combined for more flexible and detailed rules.

Extend DAMOS core filter to support milliseconds unit based age
criteria.

Implement a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS, in
core layer and expose to DAMON API, via patch 1.  Add the support of the
feature on DAMON sysfs ABI with patch 2.  Update the design and usage
documents to explain the new features with patches 3 and 4,
respectively.

Reviewer notes (no need to be in git history).

Test
====

Confirmed the age_ms filter is working using masim [1] and DAMON
user-space tool [2]'s DAMOS filter-based snapshot feature, like below.

Start masim.

    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg \
            --quiet --repeat 10 &

Start DAMON for access monitoring.

    $ sudo ./damo start --probe \
            --probe_prep set_pgidle --probe_filter allow pgidle_unset

Monitoring results without an age_ms filter shows regions of any age.

    $ sudo ./damo report attrs --style idle-time-percentiles
    # total recency percentiles
    <percentile> <idle time>
      0     0 ns  |                    |
      1     0 ns  |                    |
     25   100 ms  |                    |
     50  3.300 s  |****************    |
     75      4 s  |******************* |
     99  4.100 s  |********************|
    100  4.100 s  |********************|
    memory bw estimate: 66.628 GiB per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

With an age_ms DAMOS filter applied for snapshotting, shows regions of
given age range.

For [0, 2s range]

    $ sudo ./damo report attrs --style idle-time-percentiles \
            --snapshot_damos_filter allow age_ms 0 2s
    # total recency percentiles
    <percentile> <idle time>
      0     0 ns  |                    |
      1     0 ns  |                    |
     25     0 ns  |                    |
     50     0 ns  |                    |
     75   100 ms  |*                   |
     99   200 ms  |**                  |
    100  1.600 s  |********************|
    memory bw estimate: 100.311 GiB per second  df-passed: 0 B per second
    total size: 7.797 GiB  df-passed 0 B
    scheme stats
    tried 0 times (0 B)
    applied 0 times (0 B)
    0 B passed filters
    quota exceeded 0 times
    0 B
    tried 0 snapshots (max 0)
    record DAMON intervals: sample 5 ms, aggr 100 ms

[1] https://github.com/sjp38/masim
[2] https://github.com/damonitor/damo

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20261105044425.87142-1-sj@kernel.org
- Rebase to the latet mm-new.
- Collect R-b: from Aveline.
- Add test results to the cover letter.
Changes from RFC
- RFC: https://lore.kernel.org/20261104153645.82945-1-sj@kernel.org
- Use div_u64() to avoid 32 bit overflow of age_ms in core.
- Rebase to the latest mm-new.

SJ Park (4):
  mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
  mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
  Docs/mm/damon/design: update for age_ms damos core filter type
  Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter

 Documentation/admin-guide/mm/damon/usage.rst |  3 +++
 Documentation/mm/damon/design.rst            |  3 +++
 include/linux/damon.h                        | 16 ++++++++++------
 mm/damon/core.c                              | 10 +++++++++-
 mm/damon/sysfs-schemes.c                     |  5 +++++
 5 files changed, 30 insertions(+), 7 deletions(-)


base-commit: f10c161fdac5b0b3fac99877805e64e682c56281
-- 
2.47.3

