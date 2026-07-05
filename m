Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E05C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F786B00A0; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD566B00A2; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBC86B00A3; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38B5E6B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4345C046E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
X-FDA: 84955174374.06.4253BBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1AE52C0007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lK1lUyQx;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z0FgOcbsNl+qod/tJInaJVHYuToBTld+YcWL2EDZP90=;
	b=KFoCrtm+bdjcXUP/+IW9G8+bluP2n2i2zfqPaThP9zNmCxd33Iz5qojk556lkGDrkfIshh
	/Sud9bMsH/EuyBJRH+ChNaZ4gIAgBLcy3Ph50P4psAxAic7DL2QnVbQri1YFdqAq+4ojho
	UyMmBSE6eZ5Xow3K9gr8aGkeho/+f00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266966;
	b=xMr4RY/kPxCAD28rHNRYfG2s7Z2wppwbHBNge1CUuasUehYRhn8MPwtNT1WBm58oon3oCr
	fsckJ1WvslDfZNcEkbjnPJ0pyAQd08sx3gdoUyRJAR7TyOYU6RocDpvZPS44a2sE+uoyl8
	8+l4FdYikQ885AxkLID/3og3q+TQBC4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lK1lUyQx;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F26B04176F;
	Sun,  5 Jul 2026 15:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FCF1F000E9;
	Sun,  5 Jul 2026 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266964;
	bh=z0FgOcbsNl+qod/tJInaJVHYuToBTld+YcWL2EDZP90=;
	h=From:To:Cc:Subject:Date;
	b=lK1lUyQx03Ve9UkwubyRdPOib0we/KfvFojeM09S1aGZs6KeJfeB82/joGkGcioMU
	 Zaanvu6oiPAAu/AnO2QCFnvfoSfvuj70PTVdNr+1B+VTc42cVP73QjxdgZC72WmJjC
	 CLfPWjn8wUJcwGcBg5+8RdfuXqwMIe4vJ42o7//tDfZchVr+9ZbFoy1ProiPQce8hp
	 Yd2yvBb5aOSvMcuHRklD7nG30Y3Amj4yy71F2vypwgh+M+hAlhiX9BE10TrYpyZMoo
	 aa4+G5rnqbwJDCBW93lHDOsb4SnAYKVYdZT3mbd/2dWoZcYImbz9wXgGTsKTL2DNRj
	 5E538Rx88IcxQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] mm/damon: validate all parameters in the core
Date: Sun,  5 Jul 2026 08:55:51 -0700
Message-ID: <20260705155600.96555-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AE52C0007
X-Stat-Signature: 5ki1arccccsn1r1mcerstmcuw3diar18
X-HE-Tag: 1783266965-422688
X-HE-Meta: U2FsdGVkX1844kaTBwkt7gUzMbOdhdPKRKbqWFz+nvftdashW/zyZTsrSDAx04AeWLuCJiyjKymnFX2TuN740XM6Z3u9BzsKeo3GxloG7Jic/5Yz/LZJqE9ies9SQ5pNjX+pyfiNvX6Gj6mER2wZhzv2gGmXBUmaH2dbEKoOzK6b7xALINQPTb6mHANhP/ruVxEbW/bedEgGHnUU0PpI2YaFdivuor8Aqb8LYSi3mEeT8k7TdQFvtxjgMPyal90ZW7sXFLDGhyJQGkQD5DYNqoulfKsfPYOql3+Ojg3VKKQe4tspGf+IHS2aK65gR433Eo6Z7rRnKKzD66W1Dvcb4J/KbC2X4gASF038rFKeZpPcB2AT8l4R+hDr+P1kajW34wvrlPzxZYFfR6BBvwGbVtYtlgw7d03Lo2Q3PXfZirF1HH5v6nLaEAL8W7K9qP3sc2XxXOFvyLVi6gzQ+Q/sZBZn3jDjRuwBOodWRlEn6iJ6Dw9OazunJ9BL2LwFB1baTikwtYMdchUHNLEn4AHItsKdH5BfO8o/8GZ4pWhBfVBUyEjuOm4pKi63fmaxPh09D6xZeHDnZb8IJXKdlwBBzszbqVFCPtgCEMR8L19L1R/H1HZF8A7wSm+cMofe7Jm7863zlJjvV98cdRc+4UAm8INZc0Xkn6WmhPuo0tbbkIMLeDPGtpIhlx16qej7/SlEhxejT6a55vhJvQJMswnv5/NcaXlMpiKq7OwYp72f427TzhND9qoniJnezQJ9XmuulBDyd1VnxgZXI+3m/AUlinxKDPULxnPIBZCbxRmutzGZPkfg2wWvfSZByWKUrBTW+9ErigYY+i2CZe1XEte/z5Rc9qSPwvX4DF5TbHvlD8P+052qZ9xQpf7gO1Dp0m8sYJbklQ77YbScupvHMBsZTPLmbi/3EDI7ypeTgQ7yFcS8LsKZd5NPgnVgzRjecPqupx35eXLYi0o7K/71MvF
 B3TDEPt4
 bWUqS3QkEBEmyca5gznewCPCFdNFpqOlAMcnCYPFLy7Jf1jQyaF4PzWKti2841dCv12wF+p2JTYigpxhmr/gc9JRZww+8WFI6Se+lICeIlcuDnncOL9FMasYIyNd8+1tbr8A/sn1G5HiVTKkjhBcnFtQWA7koF0KE4u6LL3zQHATKCHdnbcdEmOoJ1+0wpZVv58AxMG733J7fKYSOi8rHfzoyp2tv6pSYke2qaZGEn6tWwOI=
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260702210551.95167-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
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


base-commit: 372482a3e74023a5c23b427ef5c6e7a057b46e6d
-- 
2.47.3

