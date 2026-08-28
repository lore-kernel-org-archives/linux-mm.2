Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F920C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E8C6B0096; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617826B0099; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7616B0096; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29D196B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A753B12051F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:00 +0000 (UTC)
X-FDA: 85151535000.22.3304B76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 218FC10000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:36:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ak/3Q/dG";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942219;
	b=onEMNkZQ5j4RmZe8HIZS9bxFDQh5xWsY/OUDLmvt6vGpw9WFSwb584rapLj9EPreB+0U5M
	j1/En9DdIgtaxZv8untB/e4uIz2i9L+rXIpRAbLXEMXfvmrFRdl19xYeu0QyWBccl5bnZa
	XTYaozVIFZ+Hl6RYFJ8leeGRkpOhuiI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ak/3Q/dG";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wZbtF0IHVGj7VJcq8IonnL74GjdUD1ZBdNt3Ged28Xw=;
	b=PS/owdIGbj5uMin+24+TK8zwdUfztm7hHv8kF1bBbHtrVUArX7jC8bblZ1bmMwMO+xa7Sg
	HrV/bj85GrHGjYoRJSnhi29SzenihpCrJMvuktr/zIQHjeXrp50QcVkZ/ZUxuDzvCQfIt9
	HE5jxLsojFr3wqDvV8TdcaAWB82Ykh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A0B043DEC;
	Fri, 28 Aug 2026 18:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49D81F000E9;
	Fri, 28 Aug 2026 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942218;
	bh=wZbtF0IHVGj7VJcq8IonnL74GjdUD1ZBdNt3Ged28Xw=;
	h=From:To:Cc:Subject:Date;
	b=ak/3Q/dGAKBDmSkWap5l35SOzKFLEL7ad8KlNOV8/qus+ORbN0o3Eaw794B3/ZXA4
	 9uxzrXajXpH/gcawEQ9zXo4uSa6VjDstLLamoq5Xjmp7rDpYkbWmq5hBouwJPPjrlQ
	 wMedPyS0sMLTn1Rct6RBb1thKvxCXtRosu08txyl6bZLuAzCoHv7m6sVf1yPFCgXXW
	 nqD2xXgfD6By09eH4rpsEgWH2YC8o+EwRHoYiHi2xeiMo4WfPR5P8y08FuhoJeuyu/
	 yuM8N3Sd99qM4pXHSykE9B61Og3/16vd3a7iCJ+/On2ruBHffA2O3hlkRnMtCZck+r
	 cMLJng3C+UxuQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Fri, 28 Aug 2026 11:36:44 -0700
Message-ID: <20260828183649.71192-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 218FC10000A
X-Stat-Signature: utwxusnkh3xs7qr34qaom17icc4ktztj
X-HE-Tag: 1787942218-459923
X-HE-Meta: U2FsdGVkX19tgG219ws0u8X22LJ1u//4FU7cFcY5N66gKW5fbGjU3fSG3JadLBcRCQT06GT/jB4fgbX72J0UgXgY87XpLXQ9x9r5grfRMw31afC3C1wxJjNcL5JhhhXAG0Yy1bO0kJambtLpYqLuuVHeurOAX4tCj1LX2qNcgIOdZWz8WhkBw6HVB0UQICdgeYK45hBAgbQE6Gq0eLI/7NFjmH1LOda4rc7+i2sdyV0rjI0AQ7ULnTUnWsRgW5fVYTqp0VZUdz2qAIj7RaySMCEq8P/95FnhvLavbdTIdxzgL8DkQZM+D9tS4iXgsoQ8MUH8wvaSrh/ocxbfRh4NqVewiZiBDpy6VZRRTDdhTWtS4Aabthe3M4/Bm3EncU6OIzV4rjY2jhh48GirsK5dn996YY5WoMmH2l1z79kN5ntOCP5cElFOZyElMMIUjSJgHzLKH4an+ia+knoue1t0FCrwN62dOQI1O6Y6vlnNoavtOh9D0J/6CmEJb2DyYcFDaHeDWB9gkTQ2CTNvrscd9qHvUJ4m33o3yCCE0nxVqtkp/BU8nrDuAiKz5bKxMOYEwZQMB1aFp8dwJqK/xGWsp6KsJJLSBuGQg1uGglmdXCbGQyBMvie12OReoqX7nVVUlJ3zcteXiJskpfYMqH8DFaXRRboBnyAWzokeFwuPe/YKHOp8f5IZrp5NTTfegugTahrvkrS5TVZ3+k56+5Niny/yxoxdh/a8nt0tF7DrIfb0EVKplf5CanmPmztBhzC3llfoMSGyUDz1YPstGyoHzjolTzc2uGHdaOGzLdJT6XhrdYu9Qyi7QCPauXQiiBY6laZcVYKos3E2hrj0KesY/d7RR6FIksGsd/yEzI/yNTp7xfEa/AAb+C5K4VdDdGdim+u08Ou5XboUoPgferEt5JwaYIUP/XqbhaAx6+Nkp5PdeV7Esq/hnqDnc0tMZY5usRs5lhct7bzTGhL9CRw
 Ksrmr/gS
 4Y85r1L64/AeDcprCxUvy7rRvZ/PNUKTnHm1U+U8hHEg3SL46nlF5rPn6lylnS8+bbY12rze+7860uyatgJ/rGAwSJD30Q6gy1gKAFd/EGcfzNOARpEaKxV8acw2BjVYprdh7lnc/hgK9bjadSP9iyYmsr+HINB3oSBxly/w5mH9IALyXN+y2zAr13X3omVuBGBiWtKOoY98P2+4e57tH4d+VEY/626Lr7repJkG9snOST9K2jsCr87tO0jSi6eYQ5RZJ1vrKLBt2uOsp7dSWSfMaZYIvkdwXycxJeQbLssVCvV8woWeseogO9wakhR09RH2CJreuXNFSXBMhCE8LBeJQyD8nR+FVS7KlnL8KyZ+kEOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota goals commit unit test is mistakenly not testing a test case
that was designed to test.  DAMOS quota goals and DAMON sysfs refresh_ms
file have bugs that can produce non critical but still unexpected
behaviors.  Fix the bugs.

Patch 1 fixes the DAMOS quota goals commit unit test to cover a
mistakenly uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI
goal initialization and eligible_mem_bp online commit, respectively.
Patch 4 fixes the bug in DAMON sysfs refresh_ms file handling.

Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260828014659.121058-1-sj@kernel.org
- Fix last_psi_total underflow.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260827134429.123023-1-sj@kernel.org
- Fix quota goals commit unit test that was mistakenly missing a test case.
- Initialize last_psi_total as uninitialized at the beginning.
- Correct kunit test for changed last_psi_total initialization behavior.
Changes from RFC
- RFC: https://lore.kernel.org/20260827042920.93580-1-sj@kernel.org
  (Mistakenly missed RFC tag)
- Fix build error.
- Add eligible_mem_bp nid commit fix.

SJ Park (4):
  mm/damon/tests/core-kunit: test committing psi goal to psi goal
  mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
  mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
  mm/damon/sysfs: set next refresh jiffies per sysfs context

 mm/damon/core.c             | 16 ++++++++++++++--
 mm/damon/sysfs.c            | 11 +++++------
 mm/damon/tests/core-kunit.h | 16 ++++++++++------
 3 files changed, 29 insertions(+), 14 deletions(-)


base-commit: f508ed0a3bc67ac2a17ba4eaa7f219a95f6b3954
-- 
2.47.3

