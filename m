Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F73606D809
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnMyYoU3
Received: by kanga.kvack.org (Postfix)
	id AA55E6B05B0; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56B36B05B1; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91EF76B05B2; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634CA6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:16:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCDF48013C
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:25 +0000 (UTC)
X-FDA: 85412907930.02.6E41164
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 50A901C0009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:16:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnMyYoU3;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165384;
	b=FqCe5Gf0D6ctfZGqOZKr+6W8uV4tZnYfKdPHdN3osp8BcnbvIOqBbIifSfQWpfqkNleUfQ
	VOwDxPr8WapBKmqrZ39IKR//eKVcYxi/88eYNpPKbysRmorNy/2yOF78jpKduq+99ef7tq
	KsaIxAM1Dlq1/5OksVEHP+q0PAsYfDk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnMyYoU3;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y4WeU3u33cGe+s7G0SsXEEKF8+yYSzclx+9C+kGPhlM=;
	b=3foO6d5vQeXPFF6JoDUXmTixvzZtHC3xeQC4O1AoSVmETb2Jzv3i1yIksr+lv1zZhmfGmF
	tMqrMV6CSu5qTubzVcehtZhvL2qV1nWOtET+HUPed21mczP4X33Bxp8bUVg4aCtT2LrHvx
	SEktGu7BekOjdnsAt3HZ+hzYQUpp3gk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9451161180;
	Sun,  8 Nov 2026 19:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30B41F0089F;
	Sun,  8 Nov 2026 19:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165383;
	bh=Y4WeU3u33cGe+s7G0SsXEEKF8+yYSzclx+9C+kGPhlM=;
	h=From:To:Cc:Subject:Date;
	b=fnMyYoU38fjQNgOxD8Z/0S/MN/PHEPKvBrcNhfLKoqbM3PjR366nEGNqwsUnBsxvo
	 SbL9KvYiw/kEr/QGOroqzLmdwTwXL2mywZqJLc5qv6PGvEb2IJb8a4h7sadJmeoNLx
	 tNdU+yfpVulrx5cJzidQiyhJRdgjclF/8MOIaqrE1Ydd7aCWAhfOG/BEo/Y3yrw02K
	 F4vEK7mrH6uFpg16tiFsc6DduNZd2ZVA3sR7RWXC2tslSTY0XBjZuFZGmhgzcwSMGR
	 Q/M4g9FqMmRyl6sB5HHnezjPW9RbM6fSUZ5qNA0uBEJJjuEQLXXhS3MheRd8XA0MzR
	 LGRmrlR7Y63kQ==
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
Subject: [RFC PATCH 0/4] mm/damon: add lru-active probe filter type
Date: Sun,  8 Nov 2026 11:16:10 -0800
Message-ID: <20261108191615.113362-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 50A901C0009
X-Stat-Signature: huk4tcmsonmcnys4kiy7idqtp9kquog8
X-Rspam-User: 
X-HE-Tag: 1794165384-51508
X-HE-Meta: U2FsdGVkX1+P3OQSOnGfzDYht7reT77z7JVy1KkFUvLj7l/BchaCVqL5MLEJYoSH9KlYZ684gddfAmj1B2Kfc8dSveMTZVZprEfCJaFbYUcuHiY/XBBYYc6DDnZ3c9G9EviaugX+M1fLTKwiu4seF4aB3WK14w9Gmu4Y53avzDfeW3npl2+QjFDEvep2fdQ3p6fvPBiCc5pZkxqMWekOVbz/2BZgty0dC2rvzn2KXUWXzhOL4gwbz5yM7gW5CJ7XH2xDZ7dWrB1swxXBVaLEPMPhHtgIseRP9GhRiYiYPzdka7vh+0wKbZMOBJJULIVsSQn/3NARERLR2kral4s7D1RdWOVe/GadKcILWmIhrSHZuScR06L/kRKe4kMxOCiuZF44mJRhe/5A/t7FE440JwsyfL7HKkfwxxTcTQMSpElRAISo+qRenG/agjd6gXlFNMrH0mptBArdJGcOe9YiTDMfrd/YW7X3kE74EAYVjAFmhrzr0elahvEI1toTaDtx6sqUrB19g17GtBAT2uPbIS/zvk9qENQsqlXkwyjzpbZYRpVGPhkkRRHHoBj+wKyO0eG2enRTwhZOM+4xor6zSYwaJD/7JtjKsx4QWjNADtEpM/mFvDFiXZEoKNJyo9g/rsKLPd3yzBYOk17Iwr/ntXoRMXT2idDM+7UA8o+TCjB0mlc/s/7z7+R3Qai/90L2oZKD8rOTPRAq8DZTR8ENIwOya/IWYJ3LdySaAIh9d9BYMp7AGBzsbLkqSppt2tMx1n5TYcW7xYiwOSlBRFDrPypv0bLJWNv2lmXLuhMYUOPFx+qoqNQe0XwW3W0n7MGcmNYMPqM2PBUmDyNlp49PxLVLaK4F2m6KsWrU7N6rPmT9R3wWKJkttfxNiPW+w51+8ZpjEyuL6rH8gsPXSQ0dZrLWrts3/QLBjF2UqH1w/d4WDTyU8yzPH5yFVrwRnhoX90XIgKUZylMNIUWIWDe
 DMQuig3K
 fysRLedckHcPmgl2kjMFVz7Gx88Kfig0oeE/I7+4cR7yrqvWC8et8VekhABCYCj318/2heSwQ0S3ArxIkLOwoALE4RM+LLvSS0Sc1qgEqBlgqWBEIM5y73X7uyN3zWSbkyhVutuDtsF6qPCz/kwi8dnD6wCScazySE2LH7GijYTDi/SldJUQoAB7Fa83t/DpoG4nx57zc9SVp54g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The LRU-activeness of folios is useful information for understanding and
optimizing the system.  DAMOS ops filter therefore supports filtering
memory based on the information.  Using it, the information can be
extracted in the folio granularity.  It is precise but expensive.  DAMON
probe filter is the complementary way for getting the information in
region granularity with much cheaper cost.  DAMON filter does not
support LRU-activeness based filtering, though.  Add the support.

Define new DAMON filter type, DAMON_FILTER_TYPE_ACTIVE, on core API
(patch 1).  Add support for it on both vaddr and paddr operation set
(patch 2).  Extend DAMON filter sysfs ABI to let users configure DAMON
filters of the type using a new keyword, "active" (patch 3).  Finally,
update the DAMON design document to explain the new type (patch 4).

SJ Park (4):
  mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
  mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
  mm/damon/sysfs: support LRU-activeness based DAMON filter setup
  Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE

 Documentation/mm/damon/design.rst | 1 +
 include/linux/damon.h             | 2 ++
 mm/damon/ops-common.c             | 7 +++++++
 mm/damon/sysfs.c                  | 4 ++++
 4 files changed, 14 insertions(+)


base-commit: 50061821991431146db6bd16b571742c06146d30
-- 
2.47.3

