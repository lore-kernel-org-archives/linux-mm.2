Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCE9C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5146B008A; Thu, 17 Sep 2026 23:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395B66B008C; Thu, 17 Sep 2026 23:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287F26B0092; Thu, 17 Sep 2026 23:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBDB36B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34BE416056B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:55 +0000 (UTC)
X-FDA: 85225527030.21.90783BA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E8D140005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lGVJ72dm;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zkqG9smh8H5imeZNBgFh/jJ/RCi3j0R67/bWorlgxUE=;
	b=KKNXCSkPQHh0+3AxvW7nE+JIHm3rB77kTjJ5zsB+gTD/VMAGZ8vNF5qQ5mUB5m8TaUiOVo
	jvu5rv2x8n3Fy43m9sTcFlrE3HlSbR5XLeUJSy4Ydr49bEKqsfBoGuKLYDYCCBM+x3Sx56
	wleZfqkD06TngP4Irpq4XSn/d8kBLZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703933;
	b=JKCYsSw9cQaYMRIJgl97B3VG6wlPADkm+NFrl/vx+0Y1vlRhDcD6l1pMnnVsCQnHZex/H2
	aS5gwK2Wbtjf9NVP6hAEj07jrRDv91qaOPuiqt9b79oGs+ckG+mskxuKkPlQbX7Jb9VaPY
	GaeqZGOe8qoF3FEUarCf1quwjXbe+Qk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lGVJ72dm;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703928; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zkqG9smh8H5imeZNBgFh/jJ/RCi3j0R67/bWorlgxUE=;
	b=lGVJ72dmeJm0V8j/cd+zIDSy8NaVSwxnjzw4c9LQCrVI/RfkeaozV8JODUWPNXPfWOugKrKl3XKsPEBwgFa6IzeDIaiGOwLFHI462HYMHveD++hRi5qbhBE928mKakPw7mAMfvH2RG1TMsax4efTtpEp3Wuw09CEwVhgvMklVhs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9o3a2_1789703927;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9o3a2_1789703927 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:47 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] add shmem mTHP collapse support
Date: Fri, 18 Sep 2026 11:58:31 +0800
Message-ID: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: h54f6mh4snc5fgajkuf3sw9iikwn6636
X-Rspamd-Queue-Id: 0E8D140005
X-HE-Tag: 1789703931-858033
X-HE-Meta: U2FsdGVkX1+apnXWcOpL82akwmwCvMOf1SOMrVM2M33RxqSNspnDK/dhb17z8DvNJOsIX4IlVvrisher2rY3XQIwiCrtY7+CGU8QC534lpDeBiUAo8Bg2hd/KnZIJEyOoP5f/9VJ7CK3FXE6BlUAwVa9LSSj2/dqWmV9tGqGuDDusvjFmDBcqzTGLwgQRfd3zcUeP2jnVNgYNyRi2w6O4ygAJfyYfROCkWVG8g9Ev7nuI6iss4L1PP9Pe4ITBgMgztL7y+K0E+oGZxl+TwVuylhp4O8rnwVkCn+/yVlMn9rj4DUcNZZcjzGD8NgdquxzkGR/DffkisvoM96M63B6qjfhtOBspTI8MgvfKOktb1LWhlI6LS31y2Rokql6DaEWkezHqezVLTm7P/G/phE2bqtCTezxAgs1vMg29SXgs5MEMDFxMFf+4iduNy+r8Qec3185h8hiaFV3Qo9UDbaf4+xhVtjlytuvNSXbOaqLjRlhDOvxTsLgGe2XlkrFnfqcGBgDzQNBTv9Al9glmP6QsgRv1eRQ/okwzSmWTeqBMHp0TWj4oTqB21fq/SXvShAdQNg2XnG0LxBcT8JbwD9YZREnFDZZaDhqweHxwXylHv8YY6EwR++CcR+NpD/k3AbfCGr/iZ884JnssCp81CgBEhEr0hJ6GFMNP1ffl0p1sGg3D8+FeQmFNJIq44MohXnbgKYRdB19tYCHGUabEEzhu0zFe2pOTLgPeQb7U3K81KZWawx/MUVi3iRw2sEGfiUr9zYdgo3Jx/BA0DEGCyz+LlrEQJV/PGc0qngm6izs+j1/Y7QgeTTVltiHDjgfwC7Xt9/8sxUnITlHhZebfgyu629wpjlMCSZd/QEuA89gHtSNK+Vx0IkHcE7vm9VHumwcR6884XkJGKL+wPAJpq87QBIDzhXMS6mImVlzx7QMnyyORI/BXJ2Rn2GMaA8RkaNuUBLN+aIo5FXEFpKgooB
 S5ESMfZ8
 SxYLbUoupZ8fOGFtm0DCmeFI6tcmtOx7o+cG49nxOKe/I1r2ZXOuCQQLGGOSWekNZSGF+Zh09kuMbA4t18q/PCL0LHQLxnWLeB/WH2xoMq3Dt1oZrxSncVu7ghoPlHRSr+6D0rUW9sTFrwH+hcezTZDGpmWwIEjfmqzJQ4Hi1eZlGG7IBF0pUR812iLl612xF/CvghJN/HIWw/Iy5/2sCWSYuS1ZR3pvq3vIXSe5aEpD+iW7K7hDqlhDZYSm7M/o7uYNjEZsKuKeNdKGIYZSnwUC52k/dvsAuakPzImYkOLYv46M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm-unstable branch.

This patchset is split from the previous shmem mTHP collapse patchset [1],
as the anon mTHP collapse selftests [2] have already been merged.

This is a follow-up patchset for mTHP collapse to support shmem mTHP collapse,
which is based on Nico's patchset[3].

The shmem mTHP collapse strategy follows the anonymous mTHP collapse approach:
track present pages via a bitmap while scanning PMD ranges for collapse candidates,
then use the bitmap after the scan completes to determine the most efficient
mTHP order to collapse to. Built on the basic framework added for anonymous
mTHP collapse, the shmem mTHP collapse implementation is straightforward
(Thanks for Nico's work).

Note: I have not yet enabled large order collapse for file folios (file folios
currently only support PMD-sized large folio collapse). Although file large order
collapse would be more straightforward to implement after shmem mTHP collapse
support is added (requiring some changes to file_thp_enabled()), I think this
still need some discussion on whether it is necessary to support other large
orders collapse for file folios.

Patch 1-4: some cleanups.
Patch 5-8: preparation patches.
Patch 9-11: shmem mTHP collapse support.
Patch 12: add selftests.

Comments are welcome. Thanks.

Changes from RFC v2:
 - Rebase on the new mm-unstable branch.
 - Add some cleanup patches.
 - Drop anon mTHP collapse selftests patches as they have been merged.
 - Record swap entries when calling mthp_collapse() for shmem (per Lance).
 - Return SCAN_PTE_MAPPED_HUGEPAGE if page cache already holds a PMD-sized folio (per Lance).
 - Allow collapse order 1 folios for shmem (per Lance).

Changes from RFC v1:
https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibaba.com/
 - Rebase on the new code, and update to use the new functions.
 - Add more test cases.

[1] https://lore.kernel.org/all/cover.1781083630.git.baolin.wang@linux.alibaba.com/
[2] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alibaba.com/
[3] https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/

Baolin Wang (12):
  mm: khugepaged: remove outdated comments and check for shmem
  mm: khugepaged: drop the hugepage_madvise()
  mm: shmem: don't expose 'deny' and 'force' via the kernel command line
  mm: khugepaged: move cc->scan_file and cc->scan_pgoff assignment into
    collapse_scan_file()
  mm: khugepaged: add max_ptes_none check in collapse_file()
  mm: khugepaged: generalize collapse_file() for shmem mTHP support
  mm: khugepaged: add an order check for PMD-sized THP statistics
  mm: khugepaged: add a helper to get the minimal collapse order
  mm: khugepaged: add shmem mTHP collapse support
  mm: shmem: run khugepaged for all shmem mTHP orders
  mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
  selftests: mm: add shmem mTHP collapse test cases

 Documentation/admin-guide/mm/transhuge.rst |   4 +-
 include/linux/huge_mm.h                    |   8 -
 include/linux/shmem_fs.h                   |   4 +-
 mm/collapse.h                              |   3 +-
 mm/khugepaged.c                            | 220 +++++++++++++--------
 mm/madvise.c                               |   8 +-
 mm/shmem.c                                 |  22 +--
 tools/testing/selftests/mm/khugepaged.c    |   7 +-
 tools/testing/selftests/mm/run_vmtests.sh  |   2 +
 9 files changed, 168 insertions(+), 110 deletions(-)

-- 
2.47.3


