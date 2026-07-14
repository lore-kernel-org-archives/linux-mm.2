Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FF4C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9171D6B00BE; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE106B00C6; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E0A6B00CA; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E67D6B00BE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9178803A5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
X-FDA: 84987631554.17.66319B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3629F18000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eE6LKRDT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BL9Gxm8Mv/zd9x7MZsEklN154y2t4/YkAY5BKQKrvgM=;
	b=f81CLrlGS25gDofThZb0SdHd5bEoQkjRfuaOPnEubz72k6yZggS+ZK2GgmigRbXnQRc3ox
	XvLVP1veZP7tCG32+6jOgAoQ+cjWkmhMzr3A97+ZPM97iYGy4tI0d1V4cKmaX4pddKe20e
	C1+HyoHMC5EnumYV8pycwy3f2B6cWi0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eE6LKRDT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039756;
	b=jX6iy/TOeidRP2iFRJCzCR/Q223+EuU++3yX09FSnLuBY4o76k8ltNG/xDGKzyX8/DQajK
	yq79VmVe01BLHoNjY1z9XnfwgnwyPEH7kK8lkA1B+TI2BiBy7qyPtDoPY7Z0PIubrFsR3n
	nFuoozbXmZ0kcX26VNlF9rjV2XtLmkI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77A8960103;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DF31F000E9;
	Tue, 14 Jul 2026 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039755;
	bh=BL9Gxm8Mv/zd9x7MZsEklN154y2t4/YkAY5BKQKrvgM=;
	h=From:To:Cc:Subject:Date;
	b=eE6LKRDTtiHq1wR48G6wWZe/4+45GdqWe+7vNBA7shEax/GB77NATk2vFuS9iQsQS
	 rR6fqCtv0inb9K7uuL92T2QrFqBOlY85AjGERbZfLEbPYACw90/4jlV7bVIBIBTFW+
	 iYmksHeTst3/IWysTwFmOGSeKIa8aR1TY+Tn8K3P9zo66GhaYgys6osSF8x+DWs5IR
	 4LiHCIUeEV2LzhY+997Ii+bmz+TgUKkvjzWuCFMmPWfTOL9CMM96SPChhGA4taTPbt
	 mb+T6ehY1zr40/5hv4FLHaBLlpuhMq4cZlbQlRQ/T1H8rJEwk3HUCzOLgvFQ5ngtOo
	 TnDjtR3+Bh/Dw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/10] mm/damon/core: hide core-private struct fields
Date: Tue, 14 Jul 2026 07:35:33 -0700
Message-ID: <20260714143544.101305-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rto9znsg5zsb7xaagiy4pmeze65nksph
X-Rspamd-Queue-Id: 3629F18000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784039756-557270
X-HE-Meta: U2FsdGVkX1/YqjHMai1v8Xp10qDQzVU3fDwlrp8VTmNmHjZ/WW5/aVTj4hNZGMYfzrAClyyT1jIkDDaerdtRtV9g8DwjUA/rFdQEFM1SvhZDY7N89CaCAzmWLevG4jeTFJ5sncSoN+bbKGP8MexDeXtVquxWGxugc53K2JSttsLj2yhwQN+yoaomTzDGt6slW02LXmU732xpJMRkRdt7em0WNclLk+pTGlecGulqqdaXZ1ygglceeOF1WAbD4iiQqsAfAtrcO20htMrLjm1ekjk+EvR8aiXzHwv8GD+U0PcGQuRuA3ULyaHswPV/xAa4+CsqBAG85aa2vkK70FOX6SS5Qd3Fn2hXEDIPDKW8887rktBcodDRBnLp/IPL+omNVfMc9tCxhXnFCXgtk0/2/L94taCNztMCzyzK16KAT7YqYqsD/my0taLLQpSgKRi5atqZnsTA/aEdoEPvrgqivYJMXrMh/DLSmRJVHXCg9K2Lxmo7PLEhXP+DOA4kUgEz1lj+Rw2YAwGnQg87YfYPrZLc9D6XO6qAckf4j/O+gLO7RSb5hjwhLh4LRp6kBvmwpijflp9nFSBPnoEIqKw4y96BmAUFj9ZjEOwfBxj2Pw0EN7OKRiywKaXCeYZcbjmf+CIUwS18mjdMmvkjyX9fK/hiqP7QnY4fUB79jvRV3Fx/APk9c339mLsQQMjqSP5JomShBPSO2/oWRj2+rMqbyAwrl8LnvmHxBV6xQo4pI1fI3JnLuoNHgvPbt+dpN9rYgFbm+9P1uTgzrN2ZHlS4xxVaCKmBzHThr3YP0OcHteplvzTH/3zcpRMkc/nNZRz8SUvWv9y9egI6iKjrxKIug9/Q/Db0MICQ1VuXQtXqUmWCGAeKvEJayoX1cmYONCPn6CF4IE9jeYZR7g7IgUoEC1RQbrTtD87YJvTkrnwdI6idQ1CGb6LrILoRahG3oGpKjd3BEQ2EEj0P7Rc+pSV
 s2WgikQm
 S1AOntv2/4ATh0jAlkiNyvyAgXap/xPzgqvYx1fGZ30JJsqtcK3VxlGfK27mk2W2Bzd2TRjsckyxpiUAqhFVYsGHbu67BYvhDbgvSQqyGaT2WvPXBp+ZzJ1agbP9+VsWuUHFBNO/RMnCYlIkYN9NASN/P3/rrculMenyNyNZLDSvhS/iAoPbjN3ioaxpOzY8C9iLbJhAtWH0FcieTxG5vcpvuuS+T3UAj8Lh5/TkghhNTga0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core structs hide core-private fields using 'private:' comment
tags.  It is incomplete and inconsistent.  The linked list heads in a
few structs, for example, are intended to be hidden, and always be used
using the wrapper macros like damon_for_each_region().  But those were
mistakenly marked as non-private.  A few core layer-only fields were
also mistakenly added as non-private.

This only encourages callers to directly use the private fields.  It is
easy to make mistakes, and difficult to control.  Mark all such DAMON
core struct fields as private.

Patches 1-8 mark the private fields for damon_region, damon_target,
damos_quota_goal, damos_quota, damos_filter, damos, damon_filter and
damon_probe, respectively.  Patch 9 removes DAMON_SYSFS's direct access
to core-private field, damon_ctx->ops.  Finally patch 10 mark the
private fields for damon_ctx.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260714043437.95811-1-sj@kernel.org
- Drop RFC tag.

SJ Park (10):
  mm/damon/core: hide private damon_region fields
  mm/damon/core: hide private damon_target fields
  mm/damon/core: hide private damos_quota_goal fields
  mm/damon/core: hide private damos_quota fields
  mm/damon/core: hide private damos_filter fields
  mm/damon/core: hide private damos fields
  mm/damon/core: hide private damon_filter fields
  mm/damon/core: hide private damon_probe fields
  mm/damon/sysfs: do not directly access damon_ctx->ops
  mm/damon/core: hide core-private damon_ctx fields

 include/linux/damon.h | 110 +++++++++++++++++++++++-------------------
 mm/damon/sysfs.c      |   2 +-
 2 files changed, 62 insertions(+), 50 deletions(-)


base-commit: 4c0f8c26ecc149f268b6c488e6cbde2a4e58160a
-- 
2.47.3

