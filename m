Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E4760A562C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAUsdV0u
Received: by kanga.kvack.org (Postfix)
	id 45AD46B05D6; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432846B05D7; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348336B05D8; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACD36B05D6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57E071C1D0B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
X-FDA: 85390509414.12.D895994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC24D20008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAUsdV0u;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JxyoskBqgIU4C3S6z00PA0qtXiqTefs4N3Gqd+UIqZ4=;
	b=5bMbd4IVU5EXQRberfYiOhABB+LePLKbLHxmG+UnP2SkPFum0jQ7yUNPWGVhHwCM0H+UG7
	0Aly2HHPU9tIMK0DONlORQce8f5W7K6AotDN+7Q8pZgBUXGCvrsRu+k98n6lB5eBz9JQVp
	vClAZk4NSZYJw0H4zOdMp+UAG8vaudg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632085;
	b=3s5Ra/K0L71LhxYZAbM0QsU4uco7Wt9iBZdgJgChQ1AxrDVZssh4MbKDgpc2UJ8SVdH4KG
	ZDOybGBSVupowqyyd0jluNgUz1C9aEm34gSY7LvN5ZSm2Xu6Sd2D/z+KO1VrzPg8+JvYJ+
	pNOK2WzvdtOUQTrWpny/XUdQ1sIfsQ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAUsdV0u;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 595B3600DB;
	Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C891F00A18;
	Mon,  2 Nov 2026 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632085;
	bh=JxyoskBqgIU4C3S6z00PA0qtXiqTefs4N3Gqd+UIqZ4=;
	h=From:To:Cc:Subject:Date;
	b=TAUsdV0u8seyh7pjWBeSAGDE1Vm8Nqk+X9ngcNdoD9CfEsvVHZ7JUezduD/Bx88pS
	 k20QjJvr6/KpsmeuGJpGAFNBolv7BpKFlRtMFBCwid5JC94EcEsWln3rx8aaMaivps
	 LT3L8Of7wYnzm6aPQned5HfDRWfykNffIhGCLzRc+hWortfdU5JhWSbmiMrGhqTD9b
	 Zfen4voSxdmhJ5lzbK9VinNXFDWxvHVgg3EEZB2OY6zcYy13BsuTptGax/xGgwh0hY
	 OPyk79aQGQDhVSv1ofaliAGj8bof3DDN687KgAwFoxm8Jyji2KAXRIAhyx6z9/spxE
	 kvpT04/k9s/ZQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Fernand Sieber <sieberf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Leonard Foerster <foersleo@amazon.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shubhang Kaushik <sh@gentwo.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/9] mm/damon: various fixes and cleanup of code, test, and docs
Date: Mon,  2 Nov 2026 07:07:47 -0800
Message-ID: <20261102150757.93058-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC24D20008
X-Stat-Signature: asm1izzaeicypk1gzpm4do7ukugyuq1g
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793632085-563195
X-HE-Meta: U2FsdGVkX18Q4yosM0Z51UPzJdKw7OkD8UHCM4Znh9X6ZJgYcgqXtjig7sm/yaMJo5wArtJUIW/p78bgu+faxWWBm1hEpnzXBRc23kqBlJi+9PsArO6yXdatomSxjSsF0bjkNNyaVIBXmM4hbdnXeewvBfeJDBIDLudNN/vKrt1ymI/uU/DE5eQIDK8hu6Mx09I2ssiP9ZiLnmDRMkrStmx0/QLVRZEjF7BQpSkq0DEibR6mrQV0gwwmj4pqLjjs2QKgKtrYvzAwyf+gfnFQWrahvpguA3kFDzDiY3WfVksDFjkQ7QaenSpdnGbmT8l/7Rm6NZe6VUwwabvXxwqp5+cJCNugF7AZ2G3B6qgpM+41KAeCopBwHIVJVxltl1yu/qCOBbYsTW1MEhf18WzKJ9gLlQ1Ck8EGu/+FfWa1FW4oYEyOcqlgC3t6tpsh+++tUsSJX1t6Kpqs4jk0fIKIlzZOJyipnXIOGOY4933e+YOLUW32G1GNNOWTBvzyi6awi7fVrqsgM3Zd3OwGOfDpwtRinvzBaRDE3eoljxzdlQOczYrMQDi+bIeQOZmOyTxAcLu5ledxI46/RBs9nikkRJ2ydtAwv0E3HOYXohBIjGS0yR0WPNyBq8w1K5M4O0qJ48Nfh78JnajzOCxjr0Ou5+OniJ8i0MsTFYhdhUNrkI1QU4fI/o01pjumGzYSGRqMl2Lxs9lLWdGfF0Dz8mdWiC2SSXAsPng6tis+UVJu9YoQU4okz8WqnKphM6VP/pBQAeB7CG7oXmR7eBFdij+SFHyDFGprRevapToTmg7wNj66Vy4h6A5qeBk+OMotFugbPiLFJUepr0GgQTBCgkOnKW4JyR8zzAxF8meWJCKRbjs9/0jjF1LKyePlirj1wuJQyoWHKyPxwLIEdHVGArxUmU2+2pJAYw8N6qEcqwi0ohpS/iWbL03zALYenP6Hd8CpxLWpd+ZJ35okrrGgsxH
 f/GgTL1X
 la+GjrrLigvMhoNU7Oxjephlba1D4rgdUwngJ5d7rBNM1qzIdQeaG1482xgWN+j+zfYDIE1P+Rvfmx3Llp/KRTb3p2MKNAUvY9as53Ci9MDAWeyKLAQHUx5rFZb9IPHR1ByVwCsXD5YrkajMXk9I9HcGqif7CnJdq5qtiwf7XkBvCdk1s3HBgc7Aq7I9fG60sqSeee5Xq7f9nH3uXCC8cMZ7NHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix and cleanup various parts of DAMON including its code, test, and
documentation.

Optimize the efficiency and monitoring accuracy of DAMON code with the
first five patches.  Remove unnecessary initializations in
damon_new_ctx() with patch 1 from Adrian Huang (Lenovo).  Align MMU
notifier ranges when clearing PTE/PMD young bits with patches 2 and 3
from Shubhang Kaushik (Ampere) and Aveline Noir.  Avoid DAMON_STAT idle
time percentile overflow on 32-bit architectures, and optimize out
unnecessary folio LRU isolation from DAMOS_MIGRATE action, with
patches 4 and 5 from Aveline Noir, respectively.

Fix and cleanup tests and documents with remaining four patches.  Let
sysfs.py test does not hang when it is executed under interactive
terminal with patch 6 from Jaeyeong Lee.  Fix typos, grammatical errors
and styles in DAMON_RECLAIM comments and DAMON_LRU_SORT user documents
with patches 7 and 8 from Manuel.  Finally, document how to disable
watermarks of DAMON_RECLAIM with patch 9 from Jinjie Ruan.

Reviewer notes.  This is a collection of DAMON patches that are posted
by individual contributors and resposted as an mm.git merge request.
Each patch has its own changelog.

Adrian Huang (Lenovo) (1):
  mm/damon/core: remove unnecessary zero-initialization in
    damon_new_ctx()

Aveline Noir (3):
  mm/damon/ops-common: align MMU notifier range when clearing PMD young
    bit
  mm/damon/stat: avoid 32-bit overflow in idle percentiles
  mm/damon/{p,v}addr: skip folios already on the migration target node

Jaeyeon Lee (1):
  selftests/damon/sysfs.py: stop obsolete_target shells hanging the test

Jinjie Ruan (1):
  Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks

Manuel Ebner (2):
  mm/damon/reclaim: fix typo and grammar
  Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye

Shubhang Kaushik (Ampere) (1):
  mm/damon/ops-common: align MMU notifier range when clearing PTE young
    bit

 .../admin-guide/mm/damon/lru_sort.rst         | 61 +++++++++----------
 .../admin-guide/mm/damon/reclaim.rst          |  4 ++
 mm/damon/core.c                               |  5 --
 mm/damon/ops-common.c                         |  7 ++-
 mm/damon/paddr.c                              |  2 +
 mm/damon/reclaim.c                            | 14 ++---
 mm/damon/stat.c                               |  5 +-
 mm/damon/vaddr.c                              | 18 +++---
 tools/testing/selftests/damon/sysfs.py        | 12 ++--
 9 files changed, 67 insertions(+), 61 deletions(-)


base-commit: 18e5bc25101d458c94de6ccb0f7df5d8ec000fb7
-- 
2.47.3

