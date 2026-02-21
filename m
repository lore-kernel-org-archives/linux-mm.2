Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02816C61DFD
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10D06B0089; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA566B0088; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC00C6B008C; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4E546B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FD2859577
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
X-FDA: 84469470834.16.9D05844
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B0A9580003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKdZa4MV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=39x+N0v2VKttWskIiW3hTvijWP4nWmutglPXF8Nvrw4=;
	b=Cz4xXVArvmLN/akp/cULbx3skz+6EdJkd5p7tKsn30o0RoziDYmqxe8spaJroBsR7r46eM
	diLcpid+s13G2r6591B7qpK2z44T8nNJt77K9fJd8V3+4iRtJ1tJ3TBpB24433VuR6/Ya3
	4J8KZtcSpyFwCo3p4UBLk4C4B89AFCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702595; a=rsa-sha256;
	cv=none;
	b=SX+SC5XUaYxcUH1jttgz8thJP+sk729i//qV/JmlTUQgstI/WWd6L9FPkKtsohplAVsOyk
	RVMAZFR12N87zP5qQqR+a9woJ+FLkdRlMfOo8Z7fpow046M8khS+MnVeg/bLAGfFwftgqP
	PdYd22yRK+MkZHYgTXWN45XYCqqvmIE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKdZa4MV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AD7C6001D;
	Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AB5C4CEF7;
	Sat, 21 Feb 2026 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702594;
	bh=4/cqu6/9bMRWAkiwVUxwwdtCHQE1xsDQhJqSkDquOyM=;
	h=From:To:Cc:Subject:Date:From;
	b=dKdZa4MVbzSBmai1pABwghOZq1xaPwH4Vm34+d4LyPVpyPqgr41f7niT1RSxfFx0A
	 BoL3y1DhuuRcB4NnBTCu+1d4XpmDo/+Y9CO1ohjPsR5Bzxb8k7MNtjKGDgu1F0d+Cm
	 wUickhpNF6LciTPOTcz9M/zAnda92MHgkJQNzXHf90RTofgeLATa/iprkxk+kyWJPV
	 uIQg3Pu0aarI11cyesYSCHnx/lht7H6fwLDItsoUKCiyfgDFLnm7CnwRslQQAdTQvV
	 W8uF1whQ+xynG1k8Owbo25RkEW47AdXsnDwYa+nk/zse4a/C54oV8+BJMLti0BNF8+
	 E3r7/z2lr51Bg==
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
Subject: [RFC PATCH 00/10] mm/damon: add optional debugging-purpose sanity checks
Date: Sat, 21 Feb 2026 11:36:17 -0800
Message-ID: <20260221193629.19332-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0A9580003
X-Stat-Signature: 47m4hijxdaqj4y4ar8kafbdpmdr7rk7y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771702595-508008
X-HE-Meta: U2FsdGVkX18k0QPBde+shvCGvC17o4mdVj7YknKHvbr75xQWpqzT6F2bbwUCzwL2YzzFE1wGjbcgqFTfxSiNfEJjZFuvO5Q8O1ghdooAPU5Xprt2ThEUpXTfWDjlYuIX9ch+2EgBiqsnno/5RiX8HHemiYZMhR//2UhFATG9e7GAlFIgjUi3LhHmvI9kmjKuZpg+Di+uy1fPP5JXbq+4I5ghiwkFSGEiAw7aeSs3CPNM5kKaCCdlG6KWdQOT5p8GmO8IJLA3E6poMKDT1oigMZPScyAFtb3V2H4h9v+6OJMsq5AjpvJsmGKg0PJwNDRTIIdwuAyvJBKxmXKcgKPYbvnmiRUTX8wXL0AsXO1hoy+CzgZSbR+t9rQ6uQGpMjWbBJZ7Gy7J30uMua2I424s9Q3NOCceJ2YiI2e4JIFiYlcBH8BImdxCM8ys10Y1nVrKsYRGzQ3iucC1txShYvTy8ptuwOUTfeJGwWGW0Dd5RKiyiYO0GOQ1+49VBhsEPepivm16o2YFAif9zKQwTkN37NdN62g+3azKstaR/6tRpchTMmf7LWg+DeTMMFT+FNyAN66dM8lCWYOmI0MjBgGVzoGHDLnQoRC0UxzYeHOXTvgR2D2vszCKI4k5xF/naL6vp6UhZjKHAi+1kxxY8wyV4l3WpoCPCGvY/FZCf55DL9xHJjnacvXetxroVTWh89SfhSks7CQsXPplv0bdrh1yeLL6tC1W0VIxISkft2q65Ru+m2ieAuBwM4V38lU95nJgiyDIzjrlydSAeguNJCvNYs/HZXG+JFxzc5ALAj5lnZ13wseZhhLa16WQ1eYYTTqN9JQK0lsQQvlSBXRkjMwvmmmX/gXFuNRpftFilw6HydRyqg718iNusyAXOBFwNPSl+AjXgZ1oQFxN1JN+hzGOaDRkgVdXkx/pj4CQ9HAq1BvtKS44Zvp5pknS/2JuGGPSym/bulPEPrl5NVietgi
 RTclZEDV
 r9SFhO1WAeU39VAvUkZboDWfEImRBRBHnqPr7DdrYxwKgmBlgksfb18b1zpMR5sKbvxNa+lORcA6ZGTxkRT6uKt88tHY25N7YscuEbLi4B/pcv1fgGY3f0SKAOf0BUqEhndRrRmW8CboMSTI1Ik0xtSVBqO2NKzJCrD/ZwX5goADHrguPPyMsw7+WvBTakb8KhC3zQ/TcQoUpp3ZUHWH4Pumcq7nmSPNn+HknFUXpBKwVOdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

[1] https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org

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
  tools/testing/selftests/damon/config: enable DAMON_DEBUG_SANITY

 mm/damon/Kconfig                     |  11 +++
 mm/damon/core.c                      | 139 +++++++++++++++++++++++++++
 mm/damon/tests/.kunitconfig          |   3 +
 tools/testing/selftests/damon/config |   1 +
 4 files changed, 154 insertions(+)


base-commit: e059221c54896e36c8fc320029648e9013b382ea
-- 
2.47.3

