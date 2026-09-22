Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA9CC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498FA6B0088; Tue, 22 Sep 2026 19:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471346B008A; Tue, 22 Sep 2026 19:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386C76B008C; Tue, 22 Sep 2026 19:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 113916B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E23EE160694
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:35 +0000 (UTC)
X-FDA: 85243065390.01.06FE706
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf21.hostedemail.com (Postfix) with ESMTP id 35BD41C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OuSyCl2d;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nk8Ic94Nq3xGjQr2vhar5wxqZxzYYAyHKDFKnt3gS0U=;
	b=BzgJrOOJeCT7zQIxesLAxlivpJGsDt3ytjdXilAY3dpXj/h0FPJ+ScCbC1AwMNvyrcJat0
	AhbjfbnRz6ndrToCbw2N1S4vBCHmy5aqgZMGBiEtJcgTugMX5ogHkS1U6Wq62dU9kM3wP6
	mwmmW+y4EGmrhp79kuTXxeb/sUvcsIA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OuSyCl2d;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121514;
	b=s+n48KB+uUeE2iuWGWweMC+9IqDDe+rhfcjbizBdRNO5MWzuQkEtC9HF5jA4scPUcTKpNQ
	E9NTGRWzfIDdElYQJneP9esBQj8PuNmVjrCmTWdAZN2iKaOfh0SUnVUGfVXlJMYAIGz0zP
	3GAuABVSeYJX8Ohg/dtWG3fxCR4wSIE=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb769ca17so3676601cf.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121513; x=1790726313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nk8Ic94Nq3xGjQr2vhar5wxqZxzYYAyHKDFKnt3gS0U=;
        b=OuSyCl2dsdr+3CZRbH+daNf1oeVIzRHbY/qRMFwgzYv+s9hXDmzc2Mlhf/KTNk9VgF
         zEHWMvgoOcTZfWXVQatlCGvDb7Osw6fnj9L/wbhm4mdrdmPsl8wKdXOvcR1f1tB294YN
         bkPESsd6KEHIRC9THkpKwr1MbgYMuEdT5i2blEM1bCCZpVKN6XM1XxUysHJT8UQlJF0N
         Db2Abxn+OdsF+SVS/MKFtAnIzsIikA3LVRS4XaTwWcUUxkARxAHhoP66+lgrNNUVTMY4
         U+tvnIuS2Qn8ZP8B0nogF/Hqiy9RXNDNgd4m6UQ0dUwOgXTpbG0CW6BvI07XWx/mZGCJ
         6LAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121513; x=1790726313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nk8Ic94Nq3xGjQr2vhar5wxqZxzYYAyHKDFKnt3gS0U=;
        b=bG/OL5gjEbq+VktPGKAwhKw1FYGFp8WvZRM4QaB/q5fByIfQxfqeDFrkhzUoPF84Yp
         52PKL/UhAUU2gaVJbA3p15SnrvcPF+KeHVhAVELGDk2fP/NQvYo4xwHvvE2vhc9/nGTF
         2jKy0ssCObAq5Cv+wHMOvFERyWssVXVYivG9jMVGRm0kNyl7p3Y2IBH4/UnS9xC5L/t9
         TnfKtZM2CVe7Ch7PCGN545P3z4advYxCU8Jp3NmQbRltCwcjYZvk1MZdHOhrIH9O0wNv
         X2XENyz+ZhTXOpEZORBInJyyXsbQRgLUkEIwEU+m4Bk2kYODcwtvtqn/P1Y0paqpY7M/
         zcxg==
X-Gm-Message-State: AFuF++nZmxXGlN7pPrrOp6WqO5lDe4VykI9874d6Ef6ObTYOOtXj1dMa
	sGa++OC496HPlII2A+yhQ9XTP+7+ULBfMXIRQdln3eHCxjLMnrLqo06rCAbEz36+V1csTykXRQ5
	Jv+101KQ=
X-Gm-Gg: AYBFou3Bh8G3E4DGaaCApEzWd67q7ESJFoSYeDhPC5aU4gI29PreocP5rwaCRQZXfUD
	2IhjbATCrvFhK/6/fleLCaSxTR3ZVFj7taySwJ/dflYGD032pigTb8+lyoxxF8U2HU3gqgVWj8Y
	osBezAjL3OOqiXcWxBw0ZetNo9zOjdF2HW/efzdLbE5wD+zqSYavtKAKeVsBuHrPok0mV0G7yK8
	ZnOz4zuS9RUgtXlov2zicBWq2kUkn4Akt4Ntw86F+CIpHnsdafOQ+NXtGCi77skZs5Ca4iJq23O
	fGWZRUsW4+TVkVFkFjoqSfPz08+yqWHkPJ7RyDcKqFs7nJ7vmMTra4ZstkeMrq4X/LSHgwBhDHY
	5CfBk0CWj9zkzwnVXzQmFsd1kJAf+uZwTMNHFp/s1IpdnZUhmnGdB3uPt1cIPra24qV7D4dIzyM
	t51Ahw//gwiMqWVZOVp5KTV6PhKKUQg9eLRS9DoomMHpjhu6MM/2LdQYPyum8jrt9+1hSEDiDDu
	1OW/E1SAUcMMcsSskXkEmS5rxt8Zeate8Bnk10H0LFjdjz2Fh9DkzvxE231
X-Received: by 2002:a05:622a:4d85:b0:532:dd80:70e0 with SMTP id d75a77b69052e-532eac9d4ffmr20101671cf.19.1790121513206;
        Tue, 22 Sep 2026 16:58:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 00/10] mm/madvise: refactor cold and pageout page table walks
Date: Tue, 22 Sep 2026 19:58:20 -0400
Message-ID: <20260922235830.2350770-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35BD41C0006
X-Stat-Signature: t93isaixz33gg3a8pgrkx5nc93r6yf9q
X-Rspam-User: 
X-HE-Tag: 1790121514-267088
X-HE-Meta: U2FsdGVkX18hR8UQVgTOLPoibkLLCrysrXdDvDEc2rOHtbopgRjIkKqCBTdyAZEy213P1C6zduMIcyIHyNAksZKddLbdD38eG/c6Z82VzdOLld1XmZnzB9lDrbT2w6pTLF+gxmP71bFnW2LGsQQLYDU9N1++/ACZttaYN2VPaoW+iSJu/Z6lcWVoaNS651r0f1Y34FAvUrUsYy/mEgBaw56fopbF0h3tMenqipAwn9n6Rc5UmEWTCfBHbF+3EJyFwce8cK+jLkIlRCJx8EATjxydUh03pxFKY8PaaFSdm68CNoyVPNtNH/Vk/XoyD/teBfJf9G6koTFIaMLWWRjrU09/U0QaEvv1BBUC74jJduV6zTXSxp/+Hcvl2O84FMplhtiKrx+NQ0rftW8SBAvobmR/5IRXgXyoA+YrO1VVftvh6hDuLzRKQDQOJCOQVQCMmWM2PCld2RAJyOHCC8NMfo1xgdtvCNHuC2B/i6ZdaeUiGNnqCFZQWsTpPUg9hjBO8BFjQZDYW6Ar4CvM+37Y8yOdeiw2VyYzzLVhrLpyLCfET1ofhyiNu4J2hWGePGDKSU1C4Lj9ogsdXMnhD70f4cX0c+aliO219C5K/XeyqhRUhEPZpBh1OOykZtA0XlG+GmBEPEWxydKi6qJ2Rj4AQ3PparIw1sgcnZJ6KSYTeuc//GtL4httuZbivY0KkLmD+KIc3t37XW1F0TmGRS6/tcS9em/Bc/4JSAAHLxYvauPpeKoWDn4eem+5PSet0OIo1tPFds7V9FfACB+JyPM8LrAwvnlcqZBD1B71vtN7ea/gDp6lZXOaVmvR26s+c1FoIH5aY1cLH6YcalV5ymKVdtPpLeNJdcsR9fpybpQZT6O4ZsUFpXw6tiHgKZRIUBGOb40WCdCLuZlXOqKJKylxU+8xs+Z9vQ48bBIunD0if/EccIovBcKGv69OEHzDmlnmC8CV1Qq0dog5ogUs/YO
 fmL8q1W2
 tSoLb/766w26XN6NQv7Qo6VbnEr8WSGF6P9lUcd3UKMg6KnHAu9BxlMBgOQf5zdvVzxq76kW0WjoGFffMwPiaWqLzPFV0Okpa3WU4H8tfGL20qF4IUzcgXiXq3D8/BubIt8azxG72x1euOy0FfMYs30YPkyhU0kF6fzE/kDVgSs4ctt+pmizQMdi4FAeJeezzGKruUqiTGAVAaU+dKPfUoU5+cafMZWhUyOVXQG6YFHiOKqFsDIvTmCe9HPssaNENNRNNUQheIqIJXeVSuDeRa9rSzgrmkWexW80BDMqyfOTgNl/z3fooQgC+Ps5ig0ujcded/HErp3+Q01w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code makes Lorenzo and Andrew sad every time I fix a bug in it,
and there's been [1,2,3,4] bugs of various severety in a single
userland reachable function in a single month.

Unfortunately this code is an unreviewable nest of... nesting.

Lets fix that.

The self tests are not intended to be merged en-masse, they are to
ensure the implementation details have not changed during the
refactor so that we may tear the refactored code apart for even
more nasty stuff.

The self tests originated as 28 individual commits, but it's been
truncated to a single commit for the first go around to reduce
noise / pressure on folks inboxes.

Some of the tests may even surprise and confuse!
Good! The code is confusing!

[1] https://lore.kernel.org/linux-mm/20260912110832.3203902-1-gourry@gourry.net/
[2] https://lore.kernel.org/linux-mm/20260912110540.3203010-1-gourry@gourry.net/
[3] https://lore.kernel.org/linux-mm/20260912034833.2952750-3-gourry@gourry.net/
[4] https://lore.kernel.org/linux-mm/20260817220810.1175596-3-gourry@gourry.net/

===
actual cover letter
===

MADV_COLD and MADV_PAGEOUT share a page-table walker that handles huge
PMDs, PTE-mapped large folios, ordinary PTEs, folio splitting and
deferred PAGEOUT reclaim in one function. The resulting control flow
makes page-table lock ownership and split retries difficult to audit.

This series adds 28 focused selftests before changing the implementation.
They cover full and partial advice at PMD and PTE granularity, shared and
pinned folios, active and unevictable folios, zero pages, swap entries, PTE
holes, file-page permissions, concurrent split attempts and NUMA migration.

The implementation separates huge-PMD handling, PTE batching, PTE-lock
ownership and shared walk setup. The existing periodic scheduling point is
preserved through the outer lock-ownership loop. Helpers shared only by
MADV_COLD and MADV_PAGEOUT use the madvise_lru prefix.

Some test data:

All 28 selftests passed before and after the refactor.  Some of the race
conditions are flakey due to being race conditions.

LTP madvise01 passed all 20 cases and process_madvise01 passed on both
implementations.

GCov data of ktests before and after refactor:
                         executable lines   branch edges taken
  before rewrite          179/181 (98.9%)    106/120 (88.3%)
  after rewrite           168/168 (100%)     112/118 (94.9%)

The last 6 branch edges remain untaken:
  - a large anonymous COW folio in an unauthorized private-file VMA
  - ZONE_DEVICE folios at PTE and PMD level
    (note that PMD zone_device is unreachable)
  - the warning edge for an invalid PMD softleaf
  - a pending fatal signal.

Gregory Price (10):
  selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
  mm/madvise: name the shared LRU PMD callback
  mm/madvise: factor shared LRU folio handling
  mm/madvise: use the PMD softleaf validity helper
  mm/madvise: factor huge-PMD folio processing
  mm/madvise: separate huge PMDs from the PTE walk
  mm/madvise: separate PTE-batch folio processing
  mm/madvise: separate the PTL-held PTE scan
  mm/madvise: make cold and pageout PTE lock ownership explicit
  mm/madvise: share cold and pageout walk setup

 mm/madvise.c                               |  462 +++---
 tools/testing/selftests/mm/Makefile        |    2 +
 tools/testing/selftests/mm/ksft_madvise.sh |    4 +
 tools/testing/selftests/mm/madvise.c       | 1673 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |    5 +
 tools/testing/selftests/mm/vm_util.c       |    4 +-
 tools/testing/selftests/mm/vm_util.h       |    6 +
 7 files changed, 1934 insertions(+), 222 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_madvise.sh
 create mode 100644 tools/testing/selftests/mm/madvise.c

-- 
2.53.0-Meta

base-commit: 854157fc9d011b8dd5a1a86a237447e28d681eb9

