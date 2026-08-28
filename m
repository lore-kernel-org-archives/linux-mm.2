Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA57EC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF5C6B0095; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FB46B0096; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7EA76B0098; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885D96B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59147160247
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:10 +0000 (UTC)
X-FDA: 85148990220.19.F54FF45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1110160006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFM1RiFj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jwAE0OKmOfKjtRIOtQSeb+A90V4Qlobxr/nJmHJ07Bs=;
	b=IJNMsU6C5pFAwtKcf+2qbJ9DYc1jiAWJUAwJyYCFSUzCnx8xL1bN4zy5g7zFdlk9zr4FKt
	32l105MWWEmkoJU8JkUhuyJO9mlOsGotD77RGuIDUXj6NTZswd6Q79Fie7COH0a1/+R0Ru
	hroBGrga9k0z0IcvCOKfBosQfY/RXkg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFM1RiFj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881628;
	b=QoqrewVhOAokZnLQl4Y985PkKdMStBm1aSa9OxrjAsP7+iepkoBej06Be8GqMDU5XQcNnT
	DjqVO5biYM+QmaSFQhzwqwFUx8dowFmeHzM9HqhxbQ/s6Hqu3YBD9bqfF6OoaeBKR9Hq3L
	C4+rPtHIuqfDjiooHwFyqKzyM3NKpAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88864437A3;
	Fri, 28 Aug 2026 01:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1FD1F000E9;
	Fri, 28 Aug 2026 01:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787881627;
	bh=jwAE0OKmOfKjtRIOtQSeb+A90V4Qlobxr/nJmHJ07Bs=;
	h=From:To:Cc:Subject:Date;
	b=DFM1RiFjlPKAiVHZKRyNpMjRnMZaU+0bhHwt8VgyM3ahTgyRwY86zfxDIC+qDlW0N
	 00plNta7loMbT82IqQpuFmLlXIba1+sdGnJjPp8Uyc0lgJ9BFR6jPbBYZNpgW/5e0d
	 gETy9US/QVDEA2/d2DSTU46c1TQrUQy/TtUBomkEwbF/T/xKc1+XmECIMSwkEqvhin
	 ZAUJaYnRKGTeW9EeuAJUOTtnD916AIKRGAfmxwrjHh05tkPVuOsaou9k9v536vVnBY
	 f/64bKivZ+k5SJSMQMrfF3EOChSx6UYF5CyYqqZIMoW5UnD1m1HBnprIVFpCx3B25C
	 GXlYBq7PJNS+A==
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
Subject: [RFC PATCH v1.2 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Thu, 27 Aug 2026 18:46:54 -0700
Message-ID: <20260828014659.121058-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1110160006
X-Stat-Signature: giheomoshce1au4sn949y6k3epgdo9na
X-Rspam-User: 
X-HE-Tag: 1787881628-8582
X-HE-Meta: U2FsdGVkX1/qOo0y/5t2OLUuHqpFHFyRIhCFWhhtjmDKK7ZMJJpDnfLcFOGzQzhs82hwMAPJPAaHuc7mmCA6DG46xs8ZpVcQcXtvuldm0xHXdKry7VFf5EIiC5VugC7rUQ8kHqOOubLyFqSsYzraSFOUqCpxIVJWcQVsnMvJvIys2+KPeQdODCqjpshYjquPHwpTpvaTs+Ns8L4ciR0hKDkPBEz3YDpE205oTrKhNKZgpP7Pk+u5Y7+3YYbhr8cy/hhZa/COYVHf5TlmCZd67t0dnoO27QGdPV0K75076V85qMdQcLPfQ6ANTqp6GzWr5ujM7i5K1WrOBQxdUt4C1uNX3/Ad58O/961IoTif/6TyInO0c2b1l02+G2UosIaDiwyPthDV6NpzDEcf9TAuczDivNhaj7bDm+k67v9/rP2Y6X/8kPAqs+nzjTx1jGnY+4kgRDGaRodCfAazJ9J+xecgKR36EOOWTe4EU0si07ejmXSZSWhRfq/Y/2MGCzaXtkjrN9ZeQk/Csg7SZOaoQkrUQqj1s9qoLr/qXAz0+RVNk//YHO75oi69Oj5CMkTmFMYoh96t2Tlt8RmTjzXx3TLkTapHc++uaABeThX9Q60oyuty8CL0nrSqPG8cAFiK8k8osm/JPXMQYTCbi+SJDyw5HRuTr9Y2xPqjKxjsiawGN3ZvVGgHgNIMIgg38W5wbn5ZVImi6aStAwk2hZYL5YA4jOifzRpuvZZbiO6H3tA1Ofa5BOyrTlBrOzCRRAGHz9/nHVOlFNMxmTeHY1Q9AvjzXy/aPkivlRrw/EYKVn+sPHND/VFbmrsdQlxG3S6XmsGOAH0uqyQ6RX3GGSTcts6/JHv3AzayQtKinJj1vsUN/PjRPsb2nwnUUwJj2/n9ElFveCtq1r1iGsGFh3XHbtuxBFbzaaKx7+0fGbiMC2tbYZADDbpOSjeCySxGs2BUH6cM2UX0efMDQA8o9/m
 A4n+iKo1
 JjS+PDD8O5MSMgjngLFvU99NDFrIoaY8NMY3RkFtwzz2znN48+J2rNDi21WZRIM2RP6MkuEES0NjTXIWAxzF5fTXDn2R3JYl+C4l8bM6PKZwTpKeimgOs2jzAPygV2F2gOy8NwgSSHYgMUPNOnFYfrljuBYN8oBGW5lhf5ke0EdcRTH8hMPJU7/GPX501qCpGwEfQJQRXTCMOPhY+ThNG/ts/ItYuzCEv+FZPDrrap0afXsNsplA1sj7rTNoGyTUiVlBDRlpt2nKM6pzD06w4BLaJGpTMCXqBnp3HWVGXkA1e37fALyxoormPOPf6hSsTJrpVIwcCDaaWJ2iDTR+rqPPOQ9+F0ZT5qlK/OZZi6DnzLas=
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

 mm/damon/core.c             | 13 ++++++++++++-
 mm/damon/sysfs.c            | 11 +++++------
 mm/damon/tests/core-kunit.h | 16 ++++++++++------
 3 files changed, 27 insertions(+), 13 deletions(-)


base-commit: 90e1725f175e19e191adc6e1b0f0317feeddd268
-- 
2.47.3

