Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A857C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DC26B00BC; Thu,  2 Jul 2026 20:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21966B00BF; Thu,  2 Jul 2026 20:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E9B6B00C0; Thu,  2 Jul 2026 20:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B02786B00BC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:45:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1103A1C6FF5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
X-FDA: 84945069510.27.766EA76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 84ED114000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/vD0Zgf";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026373;
	b=lp5iwgqxtSQc66PNnn/Yn6PcZFobRcVYTwiCSzaBGXY0MSGMHtN2gR7vogA4A5rnE7YnCs
	QsAY1DoMO9V7png9XZ9BySf1SYS6b75sRFq/7Ujk6hiyPwtezAD2eykp7JOo4ev9msGHjb
	rHu/NbEu+6D00sqE73Iz7TmnelE1cPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DqLQ2Ua3Wk29R4FwSGEqfPPas6Fe/mAiDzCtNiVA+UY=;
	b=B6eM3CmXL3h641T4Mek7yDX6VVA7uUNLID9/CXrwRdBeUky48V1plB+SD1taOuLoAUlM4k
	0ScyGZFOTWGJgqlFjG10Pm/UhYfn420hwOjU1QoGI6Vipy0A4dKBevr9mFjYC7i3DhN4yX
	TWpILftG8a+E0ke4xG5qi+BUUZjYAxU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F/vD0Zgf";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A9CE601CB;
	Thu,  2 Jul 2026 21:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A944B1F000E9;
	Thu,  2 Jul 2026 21:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026366;
	bh=DqLQ2Ua3Wk29R4FwSGEqfPPas6Fe/mAiDzCtNiVA+UY=;
	h=From:To:Cc:Subject:Date;
	b=F/vD0ZgfzmVCpFkfB+8/7yt05fuMwCflIdkiLhodxA1mlu6wSm6mvbhCimfFkcR6K
	 TcVvisooQAuTdNa4ZAQv4WAcHRasgRS/s6uKf/8FmzkN5q9UeDqLhA1vsCIclhF4hj
	 V0uVv/hEkJ+3sUS6P3wumlJ7zhJZ3VH99aoszpayU/GhdiUsV6KrHHusV0CFgnPDvS
	 P9/ftgKsA/tJ120k6SJ+uqeEqRhZ3r9tQtScRNGdApUDQhW/A6ZAFqv/gOuCk6kn9a
	 Ykv9ioMymjmzy/THrEUDUuSSbY+4xf8iyVIii5G6aH3QITRK2l4TJfDr//ywYMwLVe
	 L6aOzTWylTVwA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/8] mm/damon: validate all parameters in the core
Date: Thu,  2 Jul 2026 14:05:42 -0700
Message-ID: <20260702210551.95167-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t5fntye9wbk8azx34n8un9u9hs8bxnub
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 84ED114000C
X-HE-Tag: 1783026373-117010
X-HE-Meta: U2FsdGVkX19COYRyQA2YNlMuPBK8pPsg7XcZf9604SOHKR+PYWpBMtpfw5cJN7dD4hoA0LZmJU55kcUGegHJIn0LOvcguZrf7Hsufh77R/yUTAzd0OaDsew2ypITT6DSvFh2U9XqSUDUJhh/ITjCyLBLitTc2nmGsYgx7We0FySOyUqOsBX3fLf462ICvS3R8RmzAQxKCt4EMA7t8g2HR/KvauCokqLr1P2w8NIrW+1L7PyAZCYxK5JNVtMedidyQFjKIJ/3DVBgG8F+zu+cuGqNOHMUVswbWutaC0er8Gf0mD+HJsZ9BNdm8MvdOQlCxRcvUdN+olthmSDwUib6hRzCQkgOs72pub/ZCA9hOEJLg/5kj5XQBtgNImH7mF3YMfTTzcEhZ1/XdJIsG0+bKc4ALF3w4rLp0B0x3Jxm+wkyotfAXjsO1GmYq6LCWH6J/6v/s2GCt/27Y3+AfsvPaabUopkf78Wf3LeQML111gs+3XD39y1XmncaNHUl2VLY2nmwzy1+Hgh5xTYcIEYfKgxLT+RrPYkdoL9UitErmhDzFs0rtNfGjgtf+ztugrZu4DmI0mJv1A7xPRSI5lvZ7XvA40LmCN5l7XhkVJwrcBqUfB0rIpHuBW2x1pgfj7lpDGxIMGhzKvWBqAYVLy8dvGdQ1pnviQDDUn8yJP+8Iaz3Hmtn5Xddac+ir0vEPJvK1Ed+g/AjzpoIbHNKImT4OYhGuJ0pRsANXeKASpNglsORcjih+UZYI/QqmBKL02v4tg6eCOmAMs+VIHKpmO4Ym+RhU/bzzQEN8Z/ZlyhFEw/NXHLJwOWvmHf02on1RoH5OFsIE6WjhidXzG6yWlf8jkCPqJccpZKLS0xcomLQqY6eJ3GIMp7XkAZitbVcl9UmNqPP2YjOpt09EC/JlVqDJoTVUaGzmqGcZ2Sjeivsy8yLM6FrwpLq01wmOoJ9w9aQuKdGQw875A7Hl3Oly2j
 hrMdFgr+
 GyxxNeFWV91S2Etuh5NzbxxE2HApzxcrR+PrGs7KfNGG/bAWVG+BWEn8TiHX6+hcWQyjNIgKiGfhWUseHuPGrRyORuPziiYRTwqAEBs+8OlIottPPbDFxZhxVyFsgL5Zl3g351xf29Vl+umQFQCbwASPPFGnnE2cu3/hvY1srgEUx9s17xtr4/hekJyDCezjslr20mBo0qyo+793gVBX2d6i3SR3ffJNLLNFbfowmmsv//LE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON has a number of parameters.  Some of the parameters are validated
by DAMON, while some are validated by DAMON API callers.  Each caller
has their own set of parameters that are exposed to users.  Hence each
caller has their own ways to do the validation.  There is no clear lines
for the responsibilities.  It is confusing and easy to make mistakes at
validations.  Actually we found a few bugs in the class.

Define DAMON core as the place to do all the validations and implement
those.  damon_set_regions(), damon_start() and damon_commit_ctx() are
the three main DAMON core API functions for setup of DAMON parameters.
Make the three functions to do safe and holistic parameter checks.  The
first one is already providing the validation, so changes are only for
the last two functions.

This might add unnecessary validations for some use cases.  The overhead
should be negligible as parameters update is expected to only rarely
happen.  It reduces the number of places to check and fix for bugs of
the class from all callers to the single component.  The maintenance
efficiency gain is obvious.

Further cleanup documents and caller code.  Make the lines of validation
duties clearer.  Remove validations that are no more needed owing to the
core validations.

Patches Sequence
================

Patch 1 implements the core holistic parameters validation for
damon_commit_ctx().  Patch 2 extends the validation to damon_start().
Patch 3 removes the duplicated holistic parameters validation in DAMON
sysfs interface, which is now embedded into the core layer.  Patches 4
and 5 remove duplicated min_region_sz validation in DAMON modules.
Patches 6 updates kernel doc to clarify damon_set_regions() is doing the
range validation.  Patches 7 and 8 remove monitoring target range
validations that doesn't necessary thanks to the validation in
damon_set_regions().

Note that the patch for providing the validation from
damon_set_regions() is separately posted as a hotfix [1] but not yet
picked into mm.git as of this writing.

[1] https://lore.kernel.org/20260630035221.146458-1-sj@kernel.org

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260701144815.113325-1-sj@kernel.org
- Fix wrong dst testing of damon_commit_ctx().
- Use fresh test_ctx for each ctx in damon_start().

SJ Park (8):
  mm/damon/core: safely validate src on damon_commit_ctx()
  mm/damon/core: do parameter testing commit on damon_start()
  mm/damon/sysfs: remove duplicated commit input validity check
  mm/damon/reclaim: remove duplicated min_region_sz power of 2 check
  mm/damon/lru_sort: remove duplicated min_region_sz power_of_2() check
  mm/damon: document region size validation in damon_set_regions()
  mm/damon/core: remove start, end check in
    damon_set_region_system_rams()
  mm/damon/sysfs: remove region size validation

 include/linux/damon.h |  3 +-
 mm/damon/core.c       | 78 ++++++++++++++++++++++++++++++++-----------
 mm/damon/lru_sort.c   |  5 ---
 mm/damon/reclaim.c    |  5 ---
 mm/damon/sysfs.c      | 35 +------------------
 5 files changed, 62 insertions(+), 64 deletions(-)


base-commit: 77d522544edf9183183689ea38f01d6c03098200
-- 
2.47.3

