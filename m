Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C36F606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SyumF8Du
Received: by kanga.kvack.org (Postfix)
	id 9F0B56B05B1; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1916B05B3; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F7F6B05B7; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 622946B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B44C1A035B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:45 +0000 (UTC)
X-FDA: 85399824930.18.F1A9337
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0B6D140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyumF8Du;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853884;
	b=mkEXkToMG0JPoZ1DpKWa/fzCEHypA9o8sZCasxXllkCF8NxxT87Wilkc/sLrrI+Wwa6obH
	6tnRbsR6Txdj6M0dVfGuoNOWr0vFZzsucBjAtpWv85tKye4FnbTCbQmJOjwx9D4wecG/gY
	BG/nFqN0jn4lHyuZd/m6fEHF2jIudKs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyumF8Du;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3wzoM/i5blqpVa0PHI6iBHhA/UaoyUK0u2TZ2889m7Q=;
	b=Qiz+HCHmUB7tqqIQmLEpf4Qm1eQpdtRgculYCeYy2Etlu90aGEWop7dm6CICbRqWhU+m8L
	qpuJ5b/JXVz//MhAB5AxYI/q3owkRbVyD1QYMVgL99qD8u5W0FDryJYtnwOOIO50NRZMZ9
	S/SOKxFl4hZ8PhKEtSMRMyrjJ7Hvn/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39BBF602C3;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5421F000C1;
	Thu,  5 Nov 2026 04:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853882;
	bh=3wzoM/i5blqpVa0PHI6iBHhA/UaoyUK0u2TZ2889m7Q=;
	h=From:To:Cc:Subject:Date;
	b=SyumF8DuwB1mhQ7DKcJKoThrAl/2XnlZWVntfbW+1Iam7h5p6/p8wDzO4vsnUamxr
	 f2vjQ9gyDJp0aOk6/I1pCgZ+otIdVxM9sGHXCpzjqAP2d7Yf7Vll+84mgj6WjItQYB
	 rgjG2nmh77sMq1poDCRz0Bk5HDTzWeZxn2aqQvlMEN/VoR3YoD8IgXhGX+7Q8Qrx5Q
	 4R+llb5pKV1EUHx9ml9sQVDOa+TD4jOYwWDtnNAqSKGF802SOh3SFGq36KYCIKRmld
	 doT8uF+6VPVW84ueqyanMl7HH1x97rs49DbAXNVoEm0mtgTTWxfx4mJ+vdLFycf6d5
	 QWpSIc2gYi7rQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/4] mm/damon: introduce age_ms damos core filter type
Date: Wed,  4 Nov 2026 20:44:20 -0800
Message-ID: <20261105044425.87142-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B6D140003
X-Stat-Signature: a6ur4u8pfx34erfp19gh7czk33qdzax8
X-Rspam-User: 
X-HE-Tag: 1793853883-613875
X-HE-Meta: U2FsdGVkX1/g3cNTaXAn3wsoDpra70kRiw8+vAbuzCjjIIgi1jYpLmOOJC/J9TMQTn6BxCG0A93eCqtmBt1GT8ZX8MV5Q6kAnqu9zyh0FRlLIvqNfGj8SetvhjueWi9wdp7WCnkMVLoNfW10zJIa8ms+wp0BtKBzY5huZAi7ocFdRpqGDYImks66LUG4llO5MrEdMx35hMRZ5FdLeTmnju5+xw9X+ok2uk/LuSBq7cIP/eP4dQA1cmAyrl+7rNC/QHi3ubCrdmZ7AV/hIq++QcWMqwE8Je3poKYTvIzSR5nHL0Cv3qYxnVvSInFFhmVDQYYUSrvYiQvl68lE4L+F1FzBYeanP1hEFEmtDp0rpu7KQkH8FahPNbZScAnaDUiIdtdGo7FgYOslRtriIJTR9CZB3Sb+/A6f2/UajH7woeMs0alY/qibmsstMmoDBs2Lpsm2rhWElejmHMZuBdEkwLi9qS7SXJ1RmgiiL6cAWfRkZpAlOnAQDM3KX3LnzqpBpPjHIrGTmGOJPQOm1FNJ+ry/H2JVGdP7y47Fr/9JelPUqvFYnK8eRW/QYqw5ukcyqtUrM/fo06C7Z1kmwzA3YakL/OqZPWEzww/AkRnYVaxm5Y6ruIgI7PcUIu8IfGTZkLYL/VZIB3em0fRT2eUPghDCivToekJPzt6zOa+hqpAdVSSD4uQ6HoRCchLWIhWuKyqk+SWrO0WLmlWB/IUJeGoAmPesLQUHvR9U5aGzKBlvm3xLY0lOydPUUl2Uv+xdV/q0R60PZQPS7n7OZG7qECQ+QgpSO/4jAAdhi4BmoPkpjZIs0nTrNuPW7uOo/6IasCeVs6EPvu4SP+0GfYHUI9hNtWg0PLpPm5gJGnFIftBczTBg1yFeM3aEBcE4Y009RddqkfL2Ue186XJThvLr9TTTtt2ZfnWudZaHBGDDZjlCEfM+8Bst8X9Xeqkx7IwZTFkEzyMp3DTEFMzYgaa
 qXDM5rnD
 Gvjn3H0Jq8+M/iPP1V2EzSMCeYfSY+haF3akfHzhSD8X3MV+oHESGMb/2QpZld+1EfTxoEP/09qKO09NOZatR7ZKcjxpYWv3idr+RbJjt3x7Vn90J8wzlsq67PxcVfhhJnhob2E0tlkDdjme9tU4SY1SzAf3zuCQ/NhSTzmlM9LNZjK8tTkMumF1FrXEOrtCXtEp6nBA79dRng/snN4uH3zWmfC3DLH5mHk6XSOFvmKpDZHRWdNm3ZtzJqPsh7mMSDZLmruTw4DZpFSJQFqYfCw26Xg==
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

Changes from RFC
- RFC: https://lore.kernel.org/20261104153645.82945-1-sj@kernel.org
- Use div_u64() to avoid 32 bit overflow of age_ms in core.

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


base-commit: b8894fdd591f7e789182cabd6b6a2aefd3d35c3d
-- 
2.47.3

