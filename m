Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6EDC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0AE6B00BB; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590526B00BC; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4802E6B00BD; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2806B00BB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA9E31C0F4E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
X-FDA: 85041980730.28.F92BDF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F94DC0021
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1EQ8Y4A;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m8Jn+I9aOAcyBtSiJa/m93YpxBXIBEC49bNd46v3ohM=;
	b=b4W9DxsHjLLh8fizWPRpG+ZhcqAT1cP5HJUgdLoSWwcGmHBNXCrd+l1xiOoNpehVjP1zn/
	3ngfWPhBp489XzbLee31Sz1QJYV5LAVccgCN3u2MnNscCuyEUnzJvmFVyGeEKkcKU/UAdS
	yF9hK5hYBM+IlNDLCLp1yThbO6CQMwA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1EQ8Y4A;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333784;
	b=Bm+H1RMDd04XOVOfmiRiKUX8ADGLLfqNEUe8WidzgHgWQIwSeoVG4nf9toBdCEydB7KHKD
	F6beqKKnkTyY85GMMd1TbwnO6xC1sCOoye/lLVKojP/HlNI1M9aHLY1V6/6ABdPgrUXqDJ
	K277G4thyoxWJnz7X03td+6BeFoFPrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CD026001D;
	Wed, 29 Jul 2026 14:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EF81F00A3A;
	Wed, 29 Jul 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333783;
	bh=m8Jn+I9aOAcyBtSiJa/m93YpxBXIBEC49bNd46v3ohM=;
	h=From:To:Cc:Subject:Date;
	b=K1EQ8Y4ACyg4nu/bytNozyrCTHzJ610qB2Un6xKxTzUUK1DcDQ46YZfR+Rhy11SCC
	 T8SyPdXIYW+XQwGNNMg3oVWZ/QSZuSO0YkSsUc0gmm93fR7FX4YUBnen3MHp839Rq/
	 fe1CYE+Jd9iIMFP6Qg89sbjqK/v4uZuy0mKyBtLhCzHXjEyWuW0HT+dCDFLbPNLVTg
	 X7/PdCTXW+OZKaV4fG4vge7VdZGPQRbCtgHnUXS8ZdmrJjiH3uTEyZPpFjM4IESk4Q
	 SHvBz2ZruhnrXanjrHWE3Fy7aPUH0wYJ8WhBvgnLhnHqZk9o3TpsZwxUR8cFqFA5ue
	 xHl1XlXj2YcHw==
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 00/12] mm/damon: cleanup code, add test cases, and update guidances in docs
Date: Wed, 29 Jul 2026 07:02:40 -0700
Message-ID: <20260729140253.87753-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F94DC0021
X-Rspam-User: 
X-Stat-Signature: oudw4z9p74nwpm8dipxhhea4ahcdedqf
X-Rspamd-Server: rspam04
X-HE-Tag: 1785333783-640136
X-HE-Meta: U2FsdGVkX1+nA7YCPPoNeMFD3Hy7DbQT//UkW6PPXwHEqC00ZLdol0QJDGi+MA0BJ7zNdbHZltI/+tcuW4tEEvjgf+SYITd1j7Gd5mZ0rcxjc/6pw268REHEi9KB5DBQiPEj9C0ATgod3zZaym0jd4BrWB2ml6C+fuvpE6whiEZD9HcRpAtD0rJwd3/v+aanxPOGfD9uOefD6vdaA6uuKV6m7op235qPGujHYixGqgZy+6TbAq/OqqBIGP/O0U9TwBq5o6OEZ58VaILZDLq2TAj/OOPXsnXW+ltI/R7ynnVa1jZc5TUGBOiqe9xZ1yox2DJLmWMboL0Q0ZCWN/W8dc2uIXRQQikLy2kYm/7NzTGoEswaOWPQI6Lt3YYzLzaQz0I0vWzgrjzlL2fmuAKHKrmigsWMnfZcLfXH2p3FTEmav5WXFq2H+pAm9G6hL7ekWUkE+h5PTShtq6zwk66XOnsoYEipxnZQAHA4mL3AvvwccTwwuezTPqOHjZDBo2YO/GXobdNvrxXQx1oY2RwlcZSBjwQyobICRYpx4yd/iNYYfD4NQyv2lOsu4YZz3/D+EvqNyhlKyq1G3EnkvutmMx90/2g235dClnUF0y8yxO4lzevDU6WJIkeXl8KccIxck00MCaCjDc5ycP2VgD1O7lgxIDHNS9mukn47ZcgZmR/MS6ykPbaWlEbRvPK6u1lBaANMq2Wqu0Ndq0Zlp8Bw7zT574BzoEQ3GnpQOCMmD40AMgTJWzm8R45nzolEFmCQuzz5jX4v8yKlmM3GGjtFqb3E3vifQdOidoijl76pi+D7EoZDqq1OKjrmNB8IGt3SAIwdlK4kGUmyL19gZIBDpAWJ4P345R8VCQ4HRxDbOoozriipu975vBmCuzE5gmlVOf5+4quyza2pzBAXOSNJpm/kowd3h3w6FgjMMV1i/TjVMf9qS5jQvA3Gew1l+tGGwWH1Vc1rwsgeXR7LIgC
 SmwtY0BX
 YatIMBK+gwi31s2tRHkHvVfwEy4Yqc5KkFXqAkaJGBBEvpSk1zENyuzahZqiQ7zdSoiBNZqUYQrRh+XbKJN10CABm8LqPAVlynyzA+EqJ18XJ9BIWRc91rc8xKPejuCuafrdezPv1pmTg+0ZKLPiN6GBLBt9wjzC/oLxWk9vaCyut4TGoSedQIhH76xn7uNzgd0psjjKBuPTHyinzJ01FKxZco85u+49N6mCibgXz55MzIw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc cleanup, improvements and updates of code, test, and documents.

Patches 1-5 cleanup DAMON code.  Patches 6-10 adds kunit and selftest
test cases for recently fixed bugs and a new feature.  Patches 11 and 12
update guidelines for AI review and what document to read, on DAMON
documents.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260729033751.131213-1-sj@kernel.org
- Fix a typo: s/alingment/alignment/.
- Add damon probes parameter validation cleanup (patches 4 and 5).
Changes from RFC
- RFC: https://lore.kernel.org/20260728052811.192712-1-sj@kernel.org
- Remove ctx parameter of __damon_va_init_regions().
- Fix damon_nr_samples_per_aggr() overflow kunit test.
- Rebase to the latest mm-new.

SJ Park (12):
  mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
  mm/damon/core: remove debug messages
  mm/damon/vaddr: remove a debug message
  mm/damon/core: validate number of probes in valid_probe_params()
  mm/damon/sysfs: remove probes number validation
  mm/damon/tests/core-kunit: extend set_regions() test for error case
  mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
  mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
  mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
  selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
  Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
  Docs/ABI/damon: recommend subsystem doc instead of admin-guide

 .../ABI/testing/sysfs-kernel-mm-damon         |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 19 ++----
 mm/damon/core.c                               | 19 +++---
 mm/damon/sysfs.c                              |  2 +-
 mm/damon/tests/core-kunit.h                   | 65 ++++++++++++++++---
 mm/damon/vaddr.c                              | 16 +----
 tools/testing/selftests/damon/sysfs.sh        |  1 +
 7 files changed, 76 insertions(+), 48 deletions(-)


base-commit: a8aa6f3b608c8c9119a7978f5f4eb083c53ea56b
-- 
2.47.3

