Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F89DC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2224F6B009D; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2D56B009E; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4E06B009F; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6F036B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:57:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 666A3160139
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:34 +0000 (UTC)
X-FDA: 85161868428.11.2F25FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE77220005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwR0NH6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c25Ptc9ckXin0oblrJfGpYc+PV+yh0CUWMaqPrslzaE=;
	b=AtTfdWx0u38O/XVIUUT+bGO+DORI3BhRBMidz9Nd83WP5orTq49h2SWOaavSEMsTZwQbK6
	e6rHJtBpk3qC+kwJX8DFalNl11mRedSZqrSujteWZ4vLwlE1/2+MzNR0H7SZtoxk19VxkJ
	EE9FoR7xyHqV5vKlr3vcB+Eo67vy5v4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwR0NH6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188252;
	b=XAKGV3HNqZQi28FLaZg7AvRg+QKIIREP2wSbZCXMk0InEPphD5yik8zXEWQWwMt+IDwP3s
	A3pxOPx6tDMXgLpkTz2pehgqlHcr1p+nPVhx3BB2lZV/C9AVUa0SnYRnTDPIeO0q4P6hRY
	mqhebq4WhM5YRF9BYi6XAeBaNrxxopM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F639402CE;
	Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB351F000E9;
	Mon, 31 Aug 2026 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188251;
	bh=c25Ptc9ckXin0oblrJfGpYc+PV+yh0CUWMaqPrslzaE=;
	h=From:To:Cc:Subject:Date;
	b=TwR0NH6KYI12HY57U9iYL42ABQBy7UbPoG4jcsH6rgf3SR4jv9kX0PFKpDN7rsVbZ
	 ZQQAkF3ZFFOtUOzHQ/gwtRK2ADS5Fk8koKRUkt9/qQA1JEdhmXhXvZmnI7X7rpmz9e
	 9F590hmW7B/ccQM3iMoXRTPgzCT4kxbbZXErjggJ3n2STZbpTZYvo6udAYpijSRgrx
	 RbfdtPX8Q5LjeScoF53+HRbvStoqa7fFELKWNXZPLuiCA0REkbZovV858DIbmX1OVw
	 xh1GZtrXPQhtJdb7ikRusYES/t7PbisV64z3/hKLqHSmBqIvqL+Ai4xT/Kvvs1Ojbs
	 g8Bxf2xwrtXDg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] mm/damon/core: remove unused helper functions
Date: Mon, 31 Aug 2026 07:57:20 -0700
Message-ID: <20260831145724.82387-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yayt7bn8wnb5md5mnmm1wsn1z711x3a4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE77220005
X-Rspam-User: 
X-HE-Tag: 1788188252-259131
X-HE-Meta: U2FsdGVkX18t9YXl4S/HikfYKJNjhInxi6oMYv7F7/QBqSLx4WgeuGLoK56LeCn9iPILftqqis6RxCdAG2IxdQkBHB9J2K8zXGgMa1USzQ59mugef/9VuzIBWCBV9fYM8pBpKwJA0VVN2SSaaHmZ8fyEq7aEHoynFtPHUli8VO4i0kp0cW4Sxf4WB5mBDVSoALnah5GilvkiDBOLZu1vxF7UfChPOyfSSe6TWvbTpb3Vz2prO2jaY89gR+8/1AqzExI5qvES0mOX5gg5T8+NWjQ7qVg8PWgp9o6lfRMRo6MavWZqQHFrSRxm1O8RCg+CHiiA8cQP4AbREkNmKROiMnkNKaK79gHhuFJAYp7if6YDgKRMqBWfoalAvqO/340+4vwwKLdBjZwSOwLj9XbVQaK04MeuzUhnAhI85Mirjq8e6JQaWJ7f9j3Bgvk9lRGPqBBmN1nxQQ9SszpHnlwYBlyk8fTf6+pHaczSQRvzgBfxFO94VO9/dfL5pLfPBO3UBF5MBCL0SfKwSAoHnu3qJxCEa2KHFvIS7V3s00iBGSCOaMe+4dCugZkqPCpaVO0XbBexiVbuT1f6JkIZzzLGPI9DC8JjCl6kbX7U/6/muZd4P2qG6/y8fmRtCAGbuZD4BP/SYWzxKHGkJdNwTJDjpCID9FeIAQcqcK16Ps9qhXw2zuCrIv3pLS9jrJpNJjhV8TKQBFPjTfHsru406cOX7sl9TQn4O44+K4ZS37TGghZ7p3gjx5OOLwFIkengwch0HJbc0Bzawu0TCUiVms3wAWjB859+KaBKHeSmG0Ord9vqQPzNMEtwCCmREg93KkuARvZnOfz4fa7N1rYZ5NFluMYdCnQSfaJd5gxi5DtskJEBmjKxw0bFIgzWo88JHN51QhysWfogx/HQD2id2YvdGRqvxf26X5dl6FZhLmQrl/CGMbSnlEUg1uT/LdCE+YnYJhvfb5HVj/oNcG2HsRK
 sUmSMF0x
 JFJOYL1D7chYj9R0aMaVRz++zuHD+PQvYZTTzUsYORWpkAVPWA4RoXCoTV5Sdzbrsghu1H9+hgeB7xlCI82gyRK25RiAZOCyDJ9pZlBOdmrgxHhpKxkqRseFZ2sN3PPD87oVN1tguPE2AI/o7+n0oS40yA94pDKPWfZiOQv6pKkjvlCCUyloBRPmXJO4OuRq3BBJSeedbh24e4nxVYB/+uF/j+/MG0qN8Rdmwas9+vYpncZOl3P2rPxQaXBBC/E6fY47I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both damon_targets_empty() and damon_nr_running_ctxs() have had no
in-tree users since commit 5ec4333b1967 ("mm/damon: remove DAMON
debugfs interface") removed their remaining callers.

Remove the unused declarations and definitions.

Tested with:
  make O=../linux-build-mm W=1 mm/damon

Changes from v1
- v1: https://lore.kernel.org/20260722113338.302603-1-hank20010209@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

Cheng-Han Wu (1):
  mm/damon/core: remove unused damon_nr_running_ctxs()

SJ Park (1):
  mm/damon/core: remove unused damon_targets_empty()

 include/linux/damon.h |  2 --
 mm/damon/core.c       | 19 -------------------
 2 files changed, 21 deletions(-)


base-commit: 1faa74d984626dfc33182c71145f2ccda03179e8
-- 
2.47.3

