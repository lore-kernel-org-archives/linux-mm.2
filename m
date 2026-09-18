Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F96DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A376B0092; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11DD6B0093; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E5A6B0095; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8306E6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 476EC1606B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
X-FDA: 85227113916.21.892F259
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABB36140015
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmtGpu+M;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741716;
	b=kuHEl6whR2B/oN2e3AlPXA//6TplqEQxHo1Awq6FG/dm2lwtxyci4/Q1ju3TA2YrLOpysx
	iKgVtPY1HxPTknmZFvKqefILVWkM8p9Sipitoxi56Rv61/gcewfJqCvhoaM4zltTfEpUPw
	1D09H9ycstLQmkszSiYEYGKwA99ILUg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmtGpu+M;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T4fRJKzlEvMyOgw/sRPLjVTFvQlAdW9RAG1NCaNsEPU=;
	b=irTn9UUIyfOAwFlHp70B/PvQQaPzJIklIznvYSrZluWrikUdCN4fxKKN45Zxr2qwamDLsW
	hJpBXa3twZisL0NPeXA9shOLztE+tuHIcv746atbjPe0ctnHf1NCxAXcS6giY24MX+x9eS
	1mTonQF9u6mcH8jApwxhqmXGd/Z/l50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C156340847;
	Fri, 18 Sep 2026 14:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4E41F000FF;
	Fri, 18 Sep 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741715;
	bh=T4fRJKzlEvMyOgw/sRPLjVTFvQlAdW9RAG1NCaNsEPU=;
	h=From:To:Cc:Subject:Date;
	b=AmtGpu+M9Zs9zqLx3ByetdhiTO7KivZkq6OFoQzyDg8VjdNX8/f1aiMvg8urPJiYD
	 pjfUXW5Njt5aHPjQetTenUOQFzf8cSYMm7d30fgs8fKVH3K+z7uHGP7+P7Z2qw6NEz
	 PhmU+zmKMMYCZ3o1HXFCq67rrBUiPy2KJI1ct/czdyhEiZz/EBWrlWul1unuaKaAg0
	 IT6a8WP2JWQGsrzyLXvjGl+i/DjW2CjPwtabq1i9ymLN+vYtzUD27z3SwF6K3rKp04
	 Qk+8RZA0Vg3QyKrP4NZ45e4083OqJCaiI7shMTK8dajjlpydIsh1Ruii3H1+5Tnfsj
	 bHvzbgwqSWGgg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/7] mm/damon: introduce damos quota goal target metric complement flag
Date: Fri, 18 Sep 2026 07:28:19 -0700
Message-ID: <20260918142827.85303-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABB36140015
X-Stat-Signature: ft7nm6dpyegf7zof1rm1kuqs1cphd57c
X-Rspam-User: 
X-HE-Tag: 1789741716-244356
X-HE-Meta: U2FsdGVkX1+AbL9hyV1v8zAT4PVeeVID3l91hJY8zaTeCqQm66AMaGl7MxDy3IYoyHrEBDOTFzraMI4oq4ktc9o1PjEG5MFDQrMg32XjGnAGGmnqkbrJmmZ8FzQ6w2cvRx0dkRckA3tRSlasMsnl6WvD/Ckx+tXOpXSNJ9P1kgaDGEXSGjwbezaHJe2gRwGN+yWT9/rsoQuaUN2P+8mSsz1ZhlZZxJuxPvh8c5VK06euOtHfc9omrVNv0Py8lc5NQe4Bequ6m7uj/+1lnPHkXQaXk6KJtpVYSHGh/VxqL4NYKQ27NCWWTvLBk7MQJQ+BtXuZBFiyGiXm7izzzAnd+eI0TNvZ85MOdkVGyEXocAIn/J1ovnDnkuFwCSn7M8/l7aAeCqs6fX9hK8I/IZbZdEYnk8D3StTEJX6lyDhlkzEBDYgcK3u2Kz3JXPQb+UAG/MTXiDRzhIkmMy0c+JFW6BaT0+NU9jdvoKvjgeHCCkqu8mknxdly644CeNPwBQc+02vXdzglhrvy2EJ4y/FrGba026z0Kqa6E4bP9J+rmnKN1Y6O/VmjQI+gqvxU3RKd5/teQ89OGslt7Ks2TIB3OqSnPHnBdI96fLeyXRry97vP4Mr8YqvbjY6ot5RDrXPnwdP9yz5WaDBgPo9Q8haU2E8oHHodOS7PqBDqKuDR1k1HQw/hJbLQkztugY0SQvoUO9ba1Gic12O3SwC6/2j8PwWts1ZtBQXvpu2iX4x86NTbUERpg31cGUBKwU6xQvNVYzBXZMeP8jMNN06DlLDX7k3rqDzaTGNq57uBMOHW/uaPdinwuHSDLAro0BIxl8o1UPlUtmfbzOLk+3KL61M4em0GMFVp7X3+nFvYdqfhRRh6q1pKENb0HtMLGegV3rNXaW8tbsHcROBMGNHWSdNGHtvzz6KY0bIgwigiz/7fCV2KohIDPskPJu+mrgojh9bgI69VitBzP5IQ5tdR5PV
 D0u8kHk1
 BmO6JipLc0wRa496TD4xQdHF1ZsKSDP1Q+mkPjpZmd+nzohgbCmWas8BG4/I2Sp6tWZE962gaKqstB2btdeyLAypMZ2rovSlxPixE9xTwe3PY9hOfK0okxnRi63FY/tbCKepKko0YPiK2rR9y7m1ZYJuzCNuTk5i7XnxQwn+6MUeKU4oU4Qu/7jmvQArdPO0SzKhtOmpqAjzrQo7lCQR7jGYorg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional.
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper
tier utilization.  One common idea for that (TPP) is utilizing two
schemes, one for promotion and the other one for demotion.  The
promotion scheme migrates hot pages from lower tier to upper tier,
aiming for high utilization of the upper tier.  The demotion scheme
migrates cold pages from upper tier to lower tier, aiming for head room
free memory of the upper tier.  Both schemes and their goals are in
direct proportion.  However, for this kind of use case, we need to
implement two different goal metrics (per-node memory utilization and
free memory ratio) while essentially the free memory ratio is just a
complemented value of the utilization.

To avoid adding too many new metrics, we are adding metrics that turn
out to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have
their complemented value version.  But it is not really difficult to
expect use cases that their complemented version can be useful.  For
example, hugepage_mem_bp use case may need a way to reduce the hugepage
ratio.  That would require a complemented version of hugepage_mem_bp.
Adding a new metric for each of such use cases could make the number of
metrics unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal
setup without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.

SJ Park (7):
  mm/damon/core: introduce damos_quota_goal->complement
  mm/damon: add complement argument to damos_new_quota_goal()
  mm/damon/sysfs-schemes: support quota goal complement flag
  mm/damon/tests/core-kunit: test quota_goal->complement commit
  Docs/mm/damon/design: document damos quota goal complement flag
  Docs/admin-guide/mm/damon/usage: update for quota goal complement file
  Docs/ABI/damon: update for quota goal metric complement sysfs file

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++++
 Documentation/admin-guide/mm/damon/usage.rst  | 13 ++++----
 Documentation/mm/damon/design.rst             | 13 +++++---
 include/linux/damon.h                         |  4 ++-
 mm/damon/core.c                               | 21 +++++++++++--
 mm/damon/lru_sort.c                           |  5 ++--
 mm/damon/reclaim.c                            |  5 ++--
 mm/damon/sysfs-schemes.c                      | 30 +++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 ++-
 samples/damon/mtier.c                         |  2 +-
 10 files changed, 83 insertions(+), 20 deletions(-)


base-commit: 93d2baf86ca2a321306c5ea2f07e3d936cc4e6fa
-- 
2.47.3

