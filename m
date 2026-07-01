Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F570C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F4B6B00B7; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F13B6B00B8; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7067F6B00B9; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51EAA6B00B7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCE274027E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
X-FDA: 84940488612.01.7F222CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 58765C000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLSV1hrS;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917305;
	b=v0tmT4+QeO/MNApnQyrNcj7ThuAWyIWTgXrZ+T1y1UDz4NdY4sI+SUFSnD/0ibmrLqUKKR
	9JfBwmFoOzL6lKKl2BrymG+sU4kTUVCwABndnF9olHsrS0Jc8aeg1uIRPmvDtdnjYO1AuP
	Ee3KcLU/+ljEk51fzoxFesG4Tu4UY00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u9li3f2mdhI97UWZZHyi3UM2e3i9g+HccBwSNR9mxb0=;
	b=OxsZPXHtdoBiRHcuID9I/HO5tNI3rgFuHi2hBR7OnktxHqH/w1TyqorTxkJpmSqnkvCZjV
	31T0ZGkvg7J0JIwlWNTxeKdJ2VgjMhHtbyl7niN40fCH5IK9y2Mc0LzMViTG6h38Y1qPWr
	bZPDfowjyYcatd13mhkzjaJjtt09cc0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLSV1hrS;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3F7B601DD;
	Wed,  1 Jul 2026 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401101F000E9;
	Wed,  1 Jul 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917304;
	bh=u9li3f2mdhI97UWZZHyi3UM2e3i9g+HccBwSNR9mxb0=;
	h=From:To:Cc:Subject:Date;
	b=SLSV1hrSc0rRE1UYdFWJa1n9HxXt/0lHObGgfp8wE/j77sJfNfZnD6aU9QKm9Qvtj
	 aYXSLwJw/Dn+9iIhC1o5yabwZHDKdkJEPog4CGsFLfeKsXAdEM82AzYuFQFNTNITEf
	 eVlrKpCpYgPa1Tffz0V6fi58PYgz6xUYyUW/3HeqoLpuKwWsXBm2oQ7oFQ9Btpv1AZ
	 Pfri6KvTRRxm1DVyUrFYXKkPkc8LYZuD4Dn2H9435TSdZzEiPW/x0QtYV7lC6nuiZ/
	 hdb80YrZQRMNhljoS5hLSaz5a6OcnVckIpa+Z6v515VV0WKI3bTa7zURhYv4qRliZ+
	 5IyBLuan/4/AQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/8] mm/damon: validate all parameters in the core
Date: Wed,  1 Jul 2026 07:48:02 -0700
Message-ID: <20260701144815.113325-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58765C000E
X-Stat-Signature: nhrch3bpsunu1udhmdenjxr3ehs3fhz9
X-HE-Tag: 1782917305-787043
X-HE-Meta: U2FsdGVkX18jf8G8lR1s4MDJ7X4S51oGxQCL+QiSbImwEnTKmuD9LiXblUhHSAGkJG0c05abQ2STWAgwL6iFGq3Q+3Ifpss/Rjp1SXSRLq/bv6e1hBJbDtcsEkYNYHvi6GQtyVz8I2wVsuGrm2XY9VWMnQRdWK8heSaG5hPfomvs65w1nbjGLVnTSxaN3orXieoCsc7Un6eef+/fj9lc1tKeH4QCpXrzjion8YK7naprZP08/caFm4fizI9j+a+hMG4ZtjWb+gu9lAZrZc7y8oXBsF8OsuzAuQsqKshHsR6UANoFg5Ex5tYodWy5gXW7zmo4Fdsq0D1OGZ9juZDh8PKJjiL3B/xCobqpaE7hdnZBfHUUS/zbs13qRFOH8Et9bNJw4pRVviD4DVbbYO1CpNDEwOEI0DrEaT9K63iILKNq+Ynvd5tCPAmlfblvcPBs/RVY43QhcB3Rx2r62WztjS4U3pQzVBvDO+ng7kS9QPMMIaDtyGyejNGo3f5UNoI67qMvFtavrY0iRboIY5cN8jAEb+CWRHoe3D8QbgAKQ05pHpbxntcn/9D0rUhGUsAsXllJapJXQc6mPrda07QzH3sgj11Dkgt0qLQdCE2epE28JHbrRt6x0OTmfVXsKrBAddZxZJTK7QLW26+MPzkduTYiXNHQhGvQ6hS/+ubFN833fueIlhV/ZP6/Iz3BNOyT7eZEMlr/N4bcH1eoT2kIjMPrd6K33dqBjwUsPjo/DCGbiD71x5khSXDz7twmgiABC2z96H8XuGnZWlQK7/hg7C3QeUhsPEB4NRcPpSFaliwJrYvI/OfZoinC/4p45OY8t7I/6DyU2nob9AnWoGQFSXqP7tI6PJsAaMAZkePfiaBohhmdixJHkWN7oVAm2gg8OTQUhdjAPdqQlmTKnSREABwIA+H73Gc/19hn6iosqoN4pD7dM3WNUzjoP3Hegu6A40K2CwFlbm57snwrqAQ
 RZahlf2C
 +5srICRCwOEWTfLdOT2cbY6YISJKAgwHxQxR2bdl05LULEfMRIues8PW8beVCnn137SImEVvrAp5q9TIn04UquI2k5IfoJ5MpXDb/yRSgzs+Up384yMhaL3PrsgmBlLn1L8+JJSyBc6p5TGvUnO24BVLXCcHYgI74n0V6bGeTIPp6rbIj9SWSdROU1qlkJaEyGP7xxj2WYxXAMv9ddMDzbhri5UEmvUX1KEhl8PRo+vpaogk=
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
 mm/damon/core.c       | 79 ++++++++++++++++++++++++++++++++-----------
 mm/damon/lru_sort.c   |  5 ---
 mm/damon/reclaim.c    |  5 ---
 mm/damon/sysfs.c      | 35 +------------------
 5 files changed, 63 insertions(+), 64 deletions(-)


base-commit: fe39036ef6a25f1ce6674c04188fd67fc53402e7
-- 
2.47.3

