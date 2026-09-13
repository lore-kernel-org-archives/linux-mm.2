Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242ECC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB736B00A6; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C7F6B00A7; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682406B00A9; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445AD6B00A6
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFDF31408D5
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
X-FDA: 85209394872.03.4AAFDD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 61CE01C0002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMds8Aov;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3+8k6ainblVJ8ZQoxyR4ldMO4in1kOwavTyrKMtf2jU=;
	b=Xp6qpZUSv/2gy+slwSb0JR5pGhMllMT93SN2NA3N9TKFRC3eUntgTrnzTFeyMuvLiEiG+R
	bsggHvPDonWSi9hO6bm3nERk2nEAjiEGEVjLUVRkZluc8XTiw3LgBZJPenYStoNfyUwOu0
	MkXBrS7xzE5RTxvTfozkLHXfCm3x6dM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMds8Aov;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319835;
	b=eKk89VEIKjXU5W0uF/xv2BYPUgZ3X2wm45BoKaw2rWtPY7jursJolUUwCBrkmnIp9uVto1
	wzvx4b8DE1W39Bq8eIY2WeU7npaNDpNMRy7OSI9WWoQf0r/FA7v6e414L6LVTf3ykrxVKS
	6WAV4oi1mIhOT1a7u7UzKYX1uSZ5NIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDB7760E83;
	Sun, 13 Sep 2026 17:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB1B1F000FF;
	Sun, 13 Sep 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319834;
	bh=3+8k6ainblVJ8ZQoxyR4ldMO4in1kOwavTyrKMtf2jU=;
	h=From:To:Cc:Subject:Date;
	b=gMds8AovhvmAXMi8//pmO+kS6q3uU+kD619aoEYC220mBOHKi4sqsINPF1x8qhsjq
	 7Q26+jswgTXjbcMiw6cPjaidfAZflaDU/Ch65TEel9omyqF1K8LeTTZ9yqZBtYNIyy
	 oO7IlFC56ZqCm7nFVZN60K2CooGs+SuqA4Np9EiCF4ZFIOwrvZDE+QkqCEhsECVF9l
	 8wFKK41WSbjXmHUOplf8chlJxt/DO4aghUm6yeGYY9KzbZhaRZy4WxY3uTHzyIFX7m
	 JmtgFJqr75P6MXGZdtsKr7S/jLsK2DhrWazdm2gA1mBtC3PRVoIh46uhafQLgxULB+
	 Gzau5nf5wsg7w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/8] mm/damon: move damos filter range arguments validation to core
Date: Sun, 13 Sep 2026 10:16:57 -0700
Message-ID: <20260913171706.103052-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61CE01C0002
X-Stat-Signature: kncfcb4f7wdexwqgdk6ddg86h6d7ppo1
X-Rspam-User: 
X-HE-Tag: 1789319835-253136
X-HE-Meta: U2FsdGVkX182cfVgDjTU84bHqXA6mXwydyz+VXJnTOxbVw9KP0639lq/isyNxhRmYtHKOEL2k2A8lZ1bg0put74ro/uF2duHCw+VsR49hjuvei/0gFjT3Z1NBI4iHCOsfI3RPCNBuux+Y6JZWQBfjgrkA4NJGjs9t4iXd89hftp6POu7TO3Y5muzfVyv4Cfp10IyUv9qoh0vFTmoBt33wWDZa0rjptTnFjvk1Ui5Ocj2Ci0FynmZhRWYG519bAj+mOOW42CfKYRZT19Iuws8XR5DTEr9zGCCO1nQvQlmwOBKXSPL0ZkFYMlZxP0iGR4Zy8pvfeYHkKTmagkqzdp2XSKaCMsNyXxssDCcamK2NTHt+Ws5MYBX8YZysOwmIp8rN25WijupyvCj+BZcu7FPsXrRfyPhNEU7pFBPKUviPVIvapLxguBaAi51h0mr1y7kPBPCl5ROdYyqLSFnnlRdFYdOMTh3nns1ORIDrVu6P2BH78bi7Oh9+LBp+vS5d6EOwtV02m9x0aiQOOsxDTIBvr+UL/f9tz/v5jyfBzSqpvlpKiN26183wT1tQGqkcG7YUpfG3YtcTs3i3aGmqw1CpNDhHFMFFF7oTG5PJvBP4U+8STUsCuz1aGoYDYX1BeyUey/qMvj0Wj0UU+vrkXMQV8M1kopB56bAwKAJ7HSNBhkYjG0E+YNakdsU77pXC9zVktdr3KjMmO/fGxnYlye3zZR5chr6fLBphVw98k3EgbKxE8IvMIuCis7Wq7ib5qI2WyEcLMsbDtNwOPxS39NIZ4hqFSQezbUJH0G6PUclff0Qiq8MTRQjWO9vMzyOhNIBwSpU0RSL7sEJTczz5bnMEWJkSvtccok2uQo/Bg3zr76D/qUHQQ+pif1zsF9JAjYu9WNl7f559qkj3C7Ttusk9IBTUR4iDgoZC9h+UnEJAK25ZJucv1hNQJ7wwxuFwL25OInkwXF5YDHRSrs8P+8
 SMpR2oKq
 EULChiTY0FWWgQ7RSRhcpD5E7kP6NX5oTL+6yvxu4+VWS8tkFG/vpfSQ9qzxZElXSezvhHxJ6fDmzx1aZ3Hf6A438ekIiwpIFUowZDbtldwRrAEe5KlyZkDqvLcs2jLhXCV9BR9Kc0/iSggH2q3zbPPTwiMWGzTBDivRK81U9Me50g+mJT8XYSP0HptIHTc7w2qh5p+qb/cqugaEVLVNclH+0U5j4ebyJsgCi0CSUaIlFl9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filter range arguments are being validated in the DAMON sysfs
interface.  Some of those have minor time-of-check to time-of-use
(TOCTOU) bugs.  In future, other callers might have duplicated
validations with similar bugs.

Fix the bugs and further refactor the code to move the validation to the
core layer.  Also add kunit test cases for the validations.

Patches 1 and 2 fix the existing TOCTOU bugs.  Patches 3 and 4 adds the
validation in the core layer.  Patch 5 drops the replicated validation
in DAMON sysfs interface.  Patch 6 further cleanup the code.  Patches 7
and 8 extends kunit tests to test the validation.

Changes from RFC
- RFC: https://lore.kernel.org/20260912191807.138502-1-sj@kernel.org
- Handle error from damos_commit_filter_arg() on all call sites.

SJ Park (8):
  mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
  mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
  mm/damon/core: return an error from damos_commit_filter_arg()
  mm/damon/core: disallow max < min damos filter range arguments commit
  mm/damon/sysfs-schemes: drop centralized filter range arg validations
  mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
  mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
  mm/damon/core-kunit: test invalid damos filter commits

 mm/damon/core.c             | 47 +++++++++++++++++++++++++++----------
 mm/damon/sysfs-schemes.c    | 32 ++++++++++---------------
 mm/damon/tests/core-kunit.h | 38 +++++++++++++++++++++++-------
 3 files changed, 76 insertions(+), 41 deletions(-)


base-commit: 9b2df9f07a4a7a5d9f625d26f9482486859d64aa
-- 
2.47.3

