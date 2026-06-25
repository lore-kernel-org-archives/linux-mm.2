Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E6BCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5976F6B0092; Thu, 25 Jun 2026 01:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5480F6B0093; Thu, 25 Jun 2026 01:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410316B0095; Thu, 25 Jun 2026 01:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3436B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B167C23B2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:07 +0000 (UTC)
X-FDA: 84917253414.29.9CA4C60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2A76C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h97HS0bX;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364085;
	b=ffQckTBrYn82dxOpInbnb+sEY5lrEpbBBiiL/eUfpjIl85C4ME0711nMe5NkBQKUGVqFgK
	rK0fYwB4PceF1zOJqZ5gjQbcMx0Vel3VX+NQSy+mYBvAvdcS1RhDvcYp7LfWfFfpW2y56U
	JsWzReXe3RvSWnoONsorTXVR6W8CkSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BmpagdOaIAQomBWNFhud4TOCk8WnRyUMTV0ERkN5fWI=;
	b=G4AMG5xNUdc6oab7qyZQPXVFv512bb/yUXQ6qMkaEOXxd1PjfChKdHFaoMHbSvKU4A7bql
	ts17bkLxpWuXFsdo6bMPvkz9ygGuGujiFRPU7bTRhpiNrnsjDk/X/2edJJlLtY8NtKAGKa
	Jr9hfPKIl7pXp61v0x7a0iibZj+rqGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h97HS0bX;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 577C360018;
	Thu, 25 Jun 2026 05:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CF21F000E9;
	Thu, 25 Jun 2026 05:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364084;
	bh=BmpagdOaIAQomBWNFhud4TOCk8WnRyUMTV0ERkN5fWI=;
	h=From:To:Cc:Subject:Date;
	b=h97HS0bX2lgKH7mBsHMi5Ge2jdMoiskR/xFX6HOnHrvZj0Fdl2bY/FsHYpyhGu+du
	 nw278SEcuJZgtp0qM9ES6PIsgbDl81jg9qXwwFbaEUbcAZPkXw/Xr6CncxwWpmRxm4
	 gszK//V7J2ilwJDxsY04ADvw+yAdGcltWnX55zb4+NnEyMJDJGLjCoSABqiz6WzSW0
	 +MciHIobFcZU9rqTBmpVKOXhsTYhY1asV0BzjV7030F1RFj3Evl1RsT6zDmur0rMvo
	 CBUqNKJPwK9mugZPTwvoKgSrgTLJ2LaEjE/kJrEvgVMvuK6txkIdW3xpV3Aml36Qvs
	 kdkeNQ/pxrIiA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v1.1 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Wed, 24 Jun 2026 22:07:43 -0700
Message-ID: <20260625050756.91115-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: aidh6fix5tc98yg9f9h3uk1b1bhogjio
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2A76C0005
X-HE-Tag: 1782364085-459450
X-HE-Meta: U2FsdGVkX1/D1+c8AToasisoucszbgpnf/d+ZGaUlbpJXz8kPKpVjgCp1GPFe/yqI6pMjJg6puXWzrFjoLVCKo7SLHDFqf2gPBZKRTagbVc83Iy8XfgQJ9NwRjyGdt6v8WXNou0w9Boi6nFlViHFbpIB81UQM5JW/gcx/RBmIeUhBRV2sv6Msy7IFAdnDqYeLSFNM+cXWz3V88H8kvAm2Y4O+DvG0gmj73rHTmcfP85H97CKcqNKnXtZ1DadqZ71MoR1jqphn9tG2/5rozMxswibYrDH2UpOaM4pPtcN5nEMIbUNLmKTHBfAunDI+v8QtBJEDMYnXXA/qWiMiisEDM0fe4sbZBrl5VYXah/vcp7OWPGKXm8Vbr+5NUjBm5u/wdWFeiiINgqslb2LLpfsAALmMexwtneQend0fxTDaaHaIW7qB8fkcscbZkGdqWBs4H1FMbMsp6ayczkB0LYIRP1exV9G31tR4jYCcveQqZSsxroYiqAAyTgWMhAwLjUtSo8qUmn6njzH6WMqSiINsyC+knkrQ7cMyMfyfWJfzFgQ4GUrcb03B3CDf+I4101eu9/l0LWWBNajpBdyfls9/fIiuEI6N04HtY6tyOcgtL6CQvxGY5MPgbRy775OvemV8oAf3FTyaisS67vWywAORp4CxfxHd10olJLN2rcau/iAdtZnHjd4dnC3ltPScQ2DVvToGCFsTrjq1dxW5WkOvnM7X1rq6FIPn84Hkt+axKjwhk895BYpezpst0xZ6Zy+C3ErMVa8Ls6dPDA3hqauoXSygWyN0K12n/49pqD2s9qm+141k0FVVrwwsMZj9OAygBGkTpgsKVZdgT1aOklSCX6BM6XcowxtvhW39JaW5qAsB3gVkwBuBKAOCphT2AxNOLSIXOuPju2/g+8Bfcq2XJ46Qm/C9ahZedvt8SArX6ANJgVx8S0lXSE7DShbmhuHNUr8oPeK34cuJM12phS
 Oli7qWrG
 uVYmg+w/Aqnpen4ooquVOewgPrciE91AmDjJhVZ1q1+cEnJZkNa715LGoQGsh8TxQUqIFf/0NHFbNV5BTu48KoDNfEEXNcPTFHH5tMdiYX0N0Hys3NyGQ6G1vFX3uVvcifrBIx4mmgQ9Xstzb24UCJMk9UDg1tW1zL82cueO3gzP0GxJibHSfW2YF9gK9fLI+sNyBPAMJpzUQ+DEzcQDwWFqyNA8ym8nkRbDTaAoabwyFvks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patches 1 and 2 update the design and ABI documents for recently added
DAMON features.  Patches 3-7 add or update more unit and self tests for
DAMON to cover recently changed or added functions and sysfs files.
Patch 8 optimizes damon_commit_target_regions() to skip unnecessary
adjacent ranges setup.  Patches 9-11 clean and fix up recently added
DAMON sysfs interface code for readability.

Changes from RFC
- RFC: https://lore.kernel.org/20260624142008.87180-1-sj@kernel.org
- Rebase directly to latest mm-new.

SeongJae Park (11):
  Docs/mm/damon/design: update for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
  Docs/ABI/damon: document probe files
  mm/damon/tests/core-kunit: test damon_rand()
  selftests/damon/sysfs.sh: test multiple probe dirs creation
  selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
  selftests/damon/sysfs.sh: test dests dir
  selftests/damon/sysfs.sh: test all files in quota goal dir
  mm/damon/core: reduce range setup in damon_commit_target_regions()
  mm/damon/sysfs: split probe setup function out
  mm/damon/sysfs: split out filters setup function
  mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/

 .../ABI/testing/sysfs-kernel-mm-damon         |  40 +++++++
 Documentation/mm/damon/design.rst             |   2 +
 mm/damon/core.c                               |  22 +++-
 mm/damon/sysfs.c                              | 102 ++++++++++--------
 mm/damon/tests/core-kunit.h                   |  21 ++++
 tools/testing/selftests/damon/sysfs.sh        |  70 +++++++++++-
 6 files changed, 206 insertions(+), 51 deletions(-)


base-commit: 09ff70563340c38d31012044b9c6c18f225f4fbf
-- 
2.47.3

