Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA39F60A381C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UzgLpTAs
Received: by kanga.kvack.org (Postfix)
	id E6B206B05B4; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C0E6B05B5; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58496B05B6; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABFA96B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31CAAA0121
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:38 +0000 (UTC)
X-FDA: 85390455276.07.706E6D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AFF941C000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzgLpTAs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+CbOy/w4oZmoVyUdrE5PFeUUqcG8Qy13cgKPirYGonw=;
	b=q1F7tiTRKVRvOwXRPIPMfdFAY/lRZFyMWEZRZgys0ec7Nfi6RDLHzulrjl09DksUsTqO0l
	ZVdFGgKt4rWTBQ9ATVGqGlaWqRVA3gOk10BQZ2o4kp3n7xe4qWoT54knmhXAYnJL/PFiFV
	JL2jhwtTLVgEJsXcM1eoSoRYmudpw14=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UzgLpTAs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630796;
	b=lqPZTh9Zg6f8YBeHIDO5h4ycgI+dw6G2ZKicW30pz+DKlA0Uno6TP0vxRTy1yJKa3SZ7oW
	Aay03IqG0RlzgZWJY0CMMF7vgNKLUDX8xRfDHHXl7qdxDSX6TZ7G9lLPacJBt/wpDwxMhV
	1qtahIgHCuxf0cSxaTQjIv61OsKNW3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CBFA6020C;
	Mon,  2 Nov 2026 14:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735601F00A18;
	Mon,  2 Nov 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630795;
	bh=+CbOy/w4oZmoVyUdrE5PFeUUqcG8Qy13cgKPirYGonw=;
	h=From:To:Cc:Subject:Date;
	b=UzgLpTAsh/8b2lAuCsP4MmQBFlTwq27nXfldudYpUFO9wJWmkv9UIHFAXDDexAlif
	 iO1Q0+qe6cHXAUlIT+U3r4HyjZYBl4HukMhSEITaTw4So/C+I1yS3Syg7C5sIxDZPG
	 5S0ZNudLwPF0WmqBgUtsD6evmUSs8XzPvMYhh9Bl1eVwPb+BqphU2ASIGP7YiG/TJe
	 ZGwuEjboJWhAA6PG6w3PUOPbiFKqwfO9qGu2VmKADh+w6P2mhbFyIdU7jmBJpgBnal
	 IG0ZgOE6r9qhpaa0kScLQ3/QfF4TUP+ddUJtSY/QX/sgQfDsbHDsuF3Ku34F0iemg5
	 EEcdLIA1YJTXQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 0/3] mm/damon: fix watermark state, kunit pid leak and selftest fake pass
Date: Mon,  2 Nov 2026 06:46:23 -0800
Message-ID: <20261102144627.88843-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFF941C000F
X-Stat-Signature: 4r5qio1wjqtmpu6eumdkt4eo9q66qg9w
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793630796-233549
X-HE-Meta: U2FsdGVkX18O/O7/8malPacql1nvVuMJyohHX+LX3BLyMdvnvk9IleAj0ghmFTiAxx3/RQO9Ww1YQtN9xB91Y/BaHRlPQESovHyFETsICj7lfKMVTZPvtZEJm7nVkPLEvu28e6j1DSoyGDeOLmNJZF/VBo2zGi8xgZIFbEshJbsU1kIE8qvDuTvSIcz7NuGaKWxp6lejVvf9e8LWj7QB6bbc8ujk2+rtxk+bpl7IiAp4/GiEZJ4LzT9iB531VpxtiSQYg12rnn0ENSqRk8v5iQHlmSe/fKyszKZ5DcKevX2V8j5Axli11KOxakTAFZV3gWdzhr5Um7w0lbEGA7wAAAsKqbqsMj3xRDn3l5y/49nVlRwunU9tgK2lWVDnWAkrOJB/WORKeAmk3++htgmUJ5CZnicEMcZJ25qIJHjy0Kh4jL//tzPacmEEl1rfd4pEfcQr20kkyytzQgHA4BiX/d1bOw+qlUaf/uSkcj3Qzz6yrx2P4P+a2zaJd1CI8OUxp3fyu+XDnXG8Rripvw2+6gaDFq4QFJFepXeH/NY75Zxl+G2hbzlVtTPmWDREI+mga8SYl92tHbOomMDQi+Xlbt84cSVxlperqh6JEiig+ZRAVUHvilatfw6KU6TXzguULgrxB82aGILFp2/R8NUkLzgCEbdaBWb/yIxqLjcVUclSwGepEDr73m6w01URo25TUzSaCEpsbVAQ+rgpChqjTUqCe402R+DXCRLGWlty3uEkFP0Yu1aTrvREwlxFk/JDYjLYPQ0JTXcH/eGOGjNVD3+Q39yufvA/5N5vBm43zIVEHeXA+rcCUVgtRagDNDoRjOd0kzoSW3Ug8ioDkaSJaFLcfmYU18i+NzAqZJDQn4hmvTffAbibBYNtQ5b+slPM3O/SaHo3DQtt3jY9PxtiWCVYBNcvdgrZ0yXmGqfeYUkoyoem23tHZ0Eu+7U3VUqh0AQr3A4afNzUHYabVD9
 6y6Ht3sH
 sXt16URKV/p9vlkVNydpk7IBHK+IFwAdGXVcTfpjbbITC0L9EbovcJ+Vb/AdNHQYSlC0kDuMrf8ajLwvwVTxE4dD9sy4b9rHHJi9KaVW+0PFrNxUmfoMfKjGh3L8v8N3EoVSz56pbSzjOtYyuqvcT8JSQvABgyJpY0paPmWqb0oTWw5FnXqMErEdxG6hMgdFH5Rqu2Grd00Fwlvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Three hotfixes for core, kunit and selftest.  Fix kdamond deactivation
from missed watermark reset with patch 1.  Fix pid leak in kunit test
with patch 2.  Fix a selftest wrongly passing when it should skip, with
patch 3.

Note for reviewers.  This series is a collection of fixes that were
initially developed by different people.  Changelog is in each patch.

Aveline Noir (1):
  mm/damon/core: reset watermark wait state on each iteration

SJ Park (1):
  selftests/damon/sysfs_memcg_path_leak: define ksft_skip

Wang Xiaolei (1):
  mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets
    test

 mm/damon/core.c                                        | 5 +++--
 mm/damon/tests/sysfs-kunit.h                           | 9 +++++++++
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh | 3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)


base-commit: 395206c0e287bdd981918e033a2b1621ea6a3b9a
-- 
2.47.3

