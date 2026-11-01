Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9932C606A338
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCdRHVbT
Received: by kanga.kvack.org (Postfix)
	id 753E46B05B1; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704986B05B2; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AF66B05B3; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 401326B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA227120A1A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
X-FDA: 85387204560.17.9330C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39660C0008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCdRHVbT;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553399;
	b=v0Pee1Vzq1nbnkSz1dusgNrv4fO4ektW1I0dKwhCl7CzCYAcIEZM96S6WLjvq6+bmNq2JO
	j0jTwKg0iOHTm5Cu9U1b+GcOqowfERkM6GQRYKwfRGYSDv73R0gldzZPlon/yGfUZ4MgNE
	w52pcLZTsxdQFA5QObNMggHf8jokpQA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9FIAjLQl49vWGxEAT5mry9z/qprr2ACY4K70jv59AGk=;
	b=iIeVSB/DNU13BCiAZoBHE7BbI+RtrlNxc+vFppjGCUSqjF3iaz4DcIkugF6fnGLmlmfbRa
	x/9YmtUjzqfYS8eAKqMziHRCeGUBq6n/qfRkw2htN3QhruOfp3YN/3v/LEFpNtZTRg/cOF
	M18zvF4y7YJ22PrdYZHSynllAOsbPtU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCdRHVbT;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A99442E31;
	Sun,  1 Nov 2026 17:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183001F00A16;
	Sun,  1 Nov 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553398;
	bh=9FIAjLQl49vWGxEAT5mry9z/qprr2ACY4K70jv59AGk=;
	h=From:To:Cc:Subject:Date;
	b=fCdRHVbTv7LssVGIaJeoJS4MdHHPVs9+iHHW6hyzu5w1w5Y6o/UDhYyRW/dIRklP9
	 yloZkzUlKQldmVHFvh4o+n7mfWqaz62e9lKgkuexu1b9ipH+ZqMRB6rqXgRC5x7yAe
	 vA3CNOrQ2yJK06fJl5IqTJCn2RvN+cRDMKFTtCU7ZhDQQfDH0C4ajQ3pbjnr+ImD5R
	 qZ5Zug2sS3UiFx76sr4iyehCTX/8KgHXuWNED2zVWRsyhX1aB6dI7oRiqNNLFMkJBG
	 +fOxNd4LC0QPoGfYKDnnKwAT1tAvtgJKUNVDYSYY2EoWU8vUvV3YoOVLizt4+qB/gf
	 YLJxAyXuWkD5g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/6] mm/damon: misc improvements/cleanups for core, vaddr, sysfs and tests
Date: Sun,  1 Nov 2026 09:16:23 -0800
Message-ID: <20261101171630.81477-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1borjfrj6wziweorfmucrs484ytc8yp
X-Rspamd-Queue-Id: 39660C0008
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553399-624831
X-HE-Meta: U2FsdGVkX1+M7RVymgwTQ4ACODhaxUmrCiD+86S2szzSKLwG6mWb1p5ILc9VpAXMazcr5aZ4hWLunvVY1E3hfTVkKBZCsAWPKZe4UcBuMWIVv/Pb79Oc5tGAWO9csGs6DCwV8NMJfwiIZc1DaN6n4PaIuStKkXmYFfQcMxQOuXeGZs94OMSUfEyzNYQKF6n9Apysx0aBIdfQlAVjFJaYcnPQzcjqAFLDCBPXKRrKkwbFE7OC/rIQCbf3ro7dQ8yqtcP30mEEkt2lMLzosFhbojs3M6t7ehvFJrveB9hLtyE2h91ovMb6K8Fj51WwGi2CTFIubCfB/qTW/O5yQbTmmevnYSDkwwgjF1HPOVnppkUZgyL5EO+KS3K2CJgz/vqofoHT8dCl+RQm6HrkJCxdKiemOUSSSJK3Rre1+At2LWKKxfPIqNKVFAdHq+evTCsXTtlEjZ0Ml9JS1Pxw9KKaO/7LbbF63Z59nSyeilhF9J2hqPYDoH5YnkwQBq6YKbBPKFa/PGFgsqRAkrcUdUu8HiW6mkhfUnc8hwZCr8GHG0hdE99Q1RVyZDlzXTOOJidT489WRUJtVQJvKPwsDaSEnuc9Po9xBea3ST8Ssq9579tvzPqpa4IXChWEJ0Ac19/tgft7I59e5Ww6jWURFY7gTpoKBU+u8y3ZQeqmfRsPd0ZPVZvK1HwMDitBsP6dDjbsUyACwR1OM6L1TGyDEKW0ZbZn3twtS+DucncXqVl6Sy57a267QRZYZ9ATYTUMgbUUvXyqEFW5f7DC84dOHYiFwj9LgH8ijR2eiu+cl7zw8l3Sa3kTHmU4+4dtGJNcrbbJKDRk8Blo/I618NTYp5SdEVPZipXVAZGhjZSTrle5AUN3Cdr4BqN8nKBZIEmtRhmeq90MX7K0Z2jbGS+g7kfPloS8AP5MuS9Q1X73dDkeJq5StNCzUMipdvlhoYMvxVqoSB+KqVoMYuDfrNyPvD3
 LbU/psap
 DarBp+o2daxSLPivDJA5DGs+F9+iRDgCMeq39E93X0rW3hxIf/97YbBUcqwn8h00wTIGEzubgv46cyRNp62P9JANADlEA6Xuzl/RLqBWRyNB/LU//LJNfQtm7rL9cvgqjefd0tiHa+zLJHLFXDXvMPHTEt1rNUZmdQWJDFPceHn8omOfiIrG6/NO5o9hp40xrUfF9hBsalB9Ybd05VAw9tmkYwvufiXg0BftNJsUAjLK+F33GjoVqinQPyF4YDd9wh6TQPYuvB3q1rXqqBb74hLIgDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor code, optimize code speed, and add missing feature supports on
various areas of DAMON.

Optimize the efficiency of vaddr damos_migrate action under filter
failures with patch 1.  Use damos->last_applied on damos_migrate action
in vaddr and support sz_filter_passed for damos_migrate action in vaddr,
respectively with patch 2 and 3.  Drop a redundant and racy quota goal
target value validation in sysfs, in favor of that in the core layer,
with patch 4.  Drop unused variables and imports from selftests with
patch 5 and 6.

Changes from RFC
- RFC: https://lore.kernel.org/20261031202614.96036-1-sj@kernel.org
- Drop charge_target_from fixup consolidation.
- Add a patch for using last_applied on vaddr migrate action.
- Add missed damos_va_migrate_private->sz_filter_passed setup.
- Fix wrong commit message for unused imports removal.

SJ Park (6):
  mm/damon/vaddr: advance migration attempt in folio level for filter
    out
  mm/damon/vaddr: use damos->last_applied for migrate action
  mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold}
    action
  mm/damon/sysfs-schemes: drop redundant and racy zero target_value
    check
  selftests/damon/damos_apply_interval: remove unused variables
  selftests/damon: remove unused imports of os and sys modules

 mm/damon/sysfs-schemes.c                      |  3 --
 mm/damon/vaddr.c                              | 28 +++++++++++--------
 .../selftests/damon/damos_apply_interval.py   |  2 --
 .../damon/sysfs_no_op_commit_break.py         |  1 -
 ...sysfs_update_schemes_tried_regions_hang.py |  1 -
 5 files changed, 17 insertions(+), 18 deletions(-)


base-commit: 807c0ce92f8424fbb7eb13e7ea48746f68b24dca
-- 
2.47.3

