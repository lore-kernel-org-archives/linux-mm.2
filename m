Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E77C44516
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A4A6B00F7; Fri, 17 Jul 2026 20:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1C26B00FA; Fri, 17 Jul 2026 20:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EED6B00FB; Fri, 17 Jul 2026 20:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B67EC6B00F7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 349A01602F9
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
X-FDA: 84999976614.09.5F900A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A95B52000A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYGnmLe4;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C59WxJAx9LrXUNDaNGJL5jVA+tsD6SkqhBTrog+cChA=;
	b=FQvmmcycKEx75gl33+EuVUZROMIbdC3X48OAhROCnIOs35uek2wLCGiNAsciWx7PTQ7Qzy
	2HZZPFVTBc/KO36HD9McYWYLLgcaBwQTI+VrRYoZwbKCbxPfqS8qyepih5QL/uxXbSPU2H
	ffL28StSN9m9aTs6+P4E5fqDmNhmOcE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYGnmLe4;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333685;
	b=x+VxBnXe/GwnyZOEV6B27YDrTw5vzyzK6Q1OHqpTlZR64pnCT9GcBNO0n1fMSe2NL26ER8
	8wWFiSV0CsATTwlatZy/sF6F41JA+r7ddEOisJL081AI/tFVFsttlWUGi/YxxGzNV3U0ed
	b7QJaWyur2kD0Q5Bkdse2VqdvMR9Tjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98BC1408F9;
	Sat, 18 Jul 2026 00:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209751F000E9;
	Sat, 18 Jul 2026 00:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333684;
	bh=C59WxJAx9LrXUNDaNGJL5jVA+tsD6SkqhBTrog+cChA=;
	h=From:To:Cc:Subject:Date;
	b=aYGnmLe4GTa1XTkI3KjkuzAlDHG2WXvP/qtcnwrbqJHj5X8E5ODcXjEZh1HOmN02b
	 wHawkjJwEa7LwqPithsVfBy6DG/TxZkgtOwHjHcofj841fcp50GRRHcV698lkdzv/q
	 rQqG/HOOztBgMbHkzZEb/NOLst5V7yFarDCkJxkFYUZ1OGoMrTvUEbuPsdLadhMkHd
	 s7CGmR7xuZKbldqLrRe3VZoH0/ZVv2vL7cajP60L3asB78KNocXYQeBuBDVukm8aol
	 uiKSYYYn0QIIixb1+GAuULmHtnUycSo/Sih5xfXeY3TowhyAD7YRvQVdtrcGyqaUsZ
	 33hONYUS3r3SQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: fix uninitialized DAMOS field and kunit exec expectation bugs
Date: Fri, 17 Jul 2026 17:14:34 -0700
Message-ID: <20260718001442.87129-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A95B52000A
X-Stat-Signature: i5jb8yanau64tc3tuxdt4phnhwut5mow
X-HE-Tag: 1784333685-53967
X-HE-Meta: U2FsdGVkX18XoyQDjkJ8aoiAQYBeUGjRNSlCT7OvVYe52nNV71vyt41i8iXsIieqBh68dU8tTy7sFngOcJ865/xsEzt4N/ocH/iZXnzhP9fTKxbBrBVMa96EVm2IhW2PMKIyrJ435/CngHyXhPUZiUaaFwRB9TyG8XXIQkrMHGrAvZxa7u+7pdZyjUSaWWKMGjZI92Jcz+UHRy9q4PqgPlYTAFpQ66qlT6dXYLgIwa/9oOA4ZsI7nr5A7R0uHT1ypUdCRO95O34JNfy7XEHhOkaX0LWIlqy8EHqaIk/e5Z/seapC2tb9zam/3mrof+rFCuMuJcbO5F+V1S0vzpaosSM3DO46VgN1TqTACEN4oE9WYQRxdLHbi2A17cpW/RWX9xOq/h2l2Wfl+62VW+EGkYw4KZrdn6EsTNu3+17Oiz+OkdJ4kNERGMsl53bi7E4eMWnhyoUn69YvqxzSWTtVPk1k1kHXoM7kae0tPU5rt0enbYaUHWOWuekaS0BIOBXUFfctMLsk2+WcXLtDgDDNLZZEQPs30PRjOOB318XKwjWAKfkxKVjE0+lOkVW4lkD9L9vSRs55belY88BvVduKLHYgS8kh/S2VxhKYoNWaSexIesq4XD7kNvaKLwIWP72QqB0rr8BQ8Z0T8MoHcvBnKKNMHq3uQKmMlf9vQz34Eo+HFco7OMu7ERgE4ULuUn4woCJQW7B67xHOhl+KXOxUGkdqUjDnTJVaJZh2kCyAu1RXSY5LJrAaOXrjjH79EtzftDpg/0jD9why/xicPxlBcXBENNRUYCnOWRw7fcf9F9/C+fT7gj4PVno8zsmnhKECUZBE2buXTcQtajOOTPNzyaxJJos9/BtCWXdC1KYqJWOp6P3qN3ZFz+QDBymhbAEtaa6eZVWpqLl79LzrfoYWhBnPYlKokIDE1FgPNkCvwjRsJ4nAWNv9rOa3NPUT/XwrO4rYRZDT9qGtiXc3yje
 ORCHDnQ8
 Cm8lRYlC31gEgNqRP+AvifJIUPE4aDX+xOhco0ZyzGjglHFLrTUHZmjlpPUfK9EZ8gSDXmro0RigJ6LcFFdj6cqKvcY7er681Iqwm4S4DmHBsQvnPxojpONQRPOGVbNncpKO7jF6kHXZwuT5CeTtGFfVf20jTUqeWsN360V6L9zBx4GIvJN819/6iySA1JvQzbc+IQ/fcMyb3HtTzYqPN3bpd5n9oIgGupuvlGerza5NmUpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of
uninitialized damos->last_applied field.  Patches 2-7 fix DAMON kunit
tests that do invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@
kernel.  That said, the fixes are arguably not urgent.  Patch 1 only
introduces negligible DAMOS efficiency degradation in occasional
cases.  Kunit fixes could introduce quite bad consequences but those
are test code that affect only test run setups.

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260717143445.91207-1-sj@kernel.org
- Drop RFC.
Changes from RFC
- RFC: https://lore.kernel.org/20260717003022.119437-1-sj@kernel.org
  (Was not having RFC tag on the subject by a mistake)
- Add missed region split failure check in filter_out() test.
- Rebase to latest mm-new.

SJ Park (7):
  mm/damon/core: initialize damos->last_applied
  mm/damon/core-kunit: check region count before testing in split_at()
  mm/damon/vaddr-kunit: check region count in three_regions test
  mm/damon/core-kunit: handle region split failure in filter_out()
  mm/damon/core-kunit: skip wrong dest walk in commit_dests_for()
  mm/damon/core-kunit: skip wrong quota goal walk in
    commit_quota_goals()
  mm/damon/core-kunit: skip wrong region walk in commit_target_regions()

 mm/damon/core.c              |  1 +
 mm/damon/tests/core-kunit.h  | 30 ++++++++++++++++++++++++++++--
 mm/damon/tests/vaddr-kunit.h |  5 +++++
 3 files changed, 34 insertions(+), 2 deletions(-)


base-commit: 6bb81496f18939ccbc5f16840d5b2cf1af6c995e
-- 
2.47.3

