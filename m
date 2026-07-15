Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86202C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B757B6B0005; Tue, 14 Jul 2026 23:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CD06B0088; Tue, 14 Jul 2026 23:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6DCF6B008C; Tue, 14 Jul 2026 23:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 511F26B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 814A91A05AF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:14 +0000 (UTC)
X-FDA: 84989532348.09.3C71FC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 099D71A0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N74Od/Ek";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zX5F+4lmbeae1CeGb/wxT1HGr47P+pAaJ2W/OiCCHm8=;
	b=vTmlUIwy54yMvYN3C1aUwqMNFAVle8nfJIgDgfUpS9jdrMd2UVXhK465xCD7WApnAGDSzF
	IGtOnfME+Kq+TdjgAjKsa9kKDOweYPGvTcMdtaeI3v+2+kgk5O9rpOAzL81W8V+7k/O60X
	gjrdw0kJaAZGDhZHppWvXX9EieXUMRo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N74Od/Ek";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085013;
	b=zOYJNcF/j7ArhucJl09zOHhlUq4ZHJBS9UQ2SK7tR/ABgbbho06WI9CZ3XuAI86/0eoz2H
	JyPycopSsNoTvCJ5gTvd+tsTSxxkmeDxP5SSkIkj16D6kPvCZlnu2PLIzGmH/B2uuHdK/4
	twhhmHkakqAweKAc1KJXGCxPusrxoRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 493E2600BB;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2FC1F000E9;
	Wed, 15 Jul 2026 03:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085012;
	bh=zX5F+4lmbeae1CeGb/wxT1HGr47P+pAaJ2W/OiCCHm8=;
	h=From:To:Cc:Subject:Date;
	b=N74Od/EkYRy+y+m8B+GCPqq9csaIQ4tdN+b70jJHtcQ6Ip5IN6BCNhhd8eM9oGIYR
	 2z7A7HDv7NksiEeb6yv5knT0aVbUNdvOJ4NusC7po080ymGjZRsNZ7Gd5baBh6F6nV
	 V1e6zzjHjGlhki4F8gLUEWX9NgbwNQjgKHRBmyuRJ5ajc7qjHdBhtJQg6y33Lw+2pJ
	 iWq0bIsk2Qu21W40SJX579OPlGhA8UfhYjaC10DcD6HOhGRgDBG2Zp+mpVR9aM3gb5
	 PZQIxBLd3cSMaXJauJC/xj6HWwS5jG9/oz/3UYd69n+/zlOIx7sIQVQ8JAINn6Qfos
	 OsjEzZF2G0xIQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 0/6] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Tue, 14 Jul 2026 20:09:55 -0700
Message-ID: <20260715031002.108504-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x3htcbbm3y6hdzknnfuja98km1fhtke5
X-Rspamd-Queue-Id: 099D71A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784085012-972221
X-HE-Meta: U2FsdGVkX1+rH/2YWBu2qDNBwUZVcdwMXPhrZjfUpASV8N/lH9nSEPNiMrQ3EU7XuflwqrqfkcGojWhHpCR0s5p9PUED94Dhl623JkU0YHFxTIgsn8oaIAnXx/BqRmLtpwX0F5Rm9bzmyuzQ0b5YxlvK4xLoh7y8VmmCnMCh0msngTvb4Woc4uPymArK5toKyZRhC9xAdmIsonIgGdqO3YAFlXRfosXlmOCHromtI9fklbvjj/rghH0KLi6HzFknD2dZiZpliikfrdslCMofBQratlIO5PjcTTk1vjrB7+36tweK/SRB8xMLBo+rNL9hDTgIt+tI5bll3nwUuADEShM2UBoj2stkhiNqVAfGyMHKmXAr27pJLsIW7BU548jrtHHUwf1Ktg8CGF8drJi/ceocUE6qYj8GGZTjTfWasQy4JlqicgNTqJCmnulX23DTKnjpi56D3vp7RM2bv1ekjkI4q0HxntiCuBp49hzJlpJ/zT4+PJSvlTsJK+GHZH68f0axPOoBaMr1RHTK8orzs1fpoSgGxXgAiGuj+3YhHWcq5aCSeoIVP62RjmIqv8qGq9ZAO1BKxhSfwAl43Cvrjeo/x3dvbyh0uX4rg78yda/L7UlKrAVYuTWTNp9EPXOz0maedtOEH3aW/gDbcBaolWeXekkTFwT21nNVRG6UEWY9DD6Y0ljiJccIPxz5448y3mxwwG3lexARsx/OL9nhQmstZ96D4gYM6xBP5braGaBjsDvJkF6QyK2DRbUPtC75Uiz1diPLKe9OD74IEGPqN3wMi6tf0FOXT0X7ygRDK0FHhAexUomiU22ya3dpN5CNEYQojdS7hdiivnwcRFKMoqFubJMpG/rCchzUdR9bq7m5kgpHOabK81JlK+UB2EaUzdfHPIb18duU4zDY17Hj1rxJgPoNp6PYtUkdgectFwBQQuiI0Kx0yYzpE1iO36OnKsc5YEp2z0OVL01yJRw
 gQBwbKvE
 di2w74jheiTRSJ+sZ6fu1gV6IAMGJE9RV0iANvSvbupX1vrKn0Ta2DzCUcMjdXmprfkdOLoXMmvCnnaKiPZkLeZaqlTMC0qra2mVR2e4THzn8nDL+Kbz/uaPo3iB8BBCADAGOYrOusR1UE1qKzfT5FmgwWQVTAjuyr16WUmPixv0eFSF9CsoC1Mp1C6ybWosYikL8NhtJ1/hNjTJ35g9MullkbbDcKcamgvPCHje+Kpd06pQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup.
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible. Fix those.

Changes from v1
- v1: https://lore.kernel.org/20260714135236.92699-1-sj@kernel.org
- Add addr_unit race fix.
- Add Fixes: tags to the race fixes.
- Wordsmith subjects.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260713135838.32730-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260712170328.91144-1-sj@kernel.org
- Remove same_target param from __damon_va_check_access().
Changes from RFC
- RFC: https://lore.kernel.org/20260711180409.82093-1-sj@kernel.org
- Rebase to mm-new.

SJ Park (6):
  mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
  mm/damon/tests/core-kunit: catch test failure in
    test_merge_regions_of()
  mm/damon/vaddr: drop last same folio access check optimization
  mm/damon/paddr: drop last same folio access check reuse optimization
  mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
  mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()

 mm/damon/core.c             | 13 +++++++++----
 mm/damon/paddr.c            | 20 ++++----------------
 mm/damon/sysfs.c            | 10 ++++++----
 mm/damon/tests/core-kunit.h |  3 +++
 mm/damon/vaddr.c            | 33 ++++++---------------------------
 5 files changed, 28 insertions(+), 51 deletions(-)


base-commit: 52d335d2c1de60b6184b9de5ecec634892a3e136
-- 
2.47.3

