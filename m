Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A435FC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C926B0093; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD996B0095; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3B76B0098; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E90C6B0093
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDA601C0E07
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
X-FDA: 85056857844.04.677E98D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 548A31C000A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpGRnd5w;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IGCINO/SWEhcdDZT6Rs7xP4paJCTjootNamfovWsNx8=;
	b=LPn+i2kmxCMfa6eqXDxFYJWcJMowcYj4IH/4zMqr1yLlw3BugBDnkBM8QIc1ER/pRlPEcw
	7R69JsJF/j1iDVBsGPUXp2Flk4lKMOKKbkexIqjggzii+WiwAiWAIGPQ1NUsPmk6GAg0sh
	r0XCWPHl28ILopThrqaEyvw9+p1gwxY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688001;
	b=DqeAuW6Y46LbOe1JHHK0yh2himLamiE+JLLJ1WomtAIzrXS37CkrCUiTm+CM/TFCPZtijg
	wjD9DrWH56eyUmgilwDuiizXC2wEFeF89s86ghmKouDrdBqSTEx1MGJyYWe/swKRy51NsH
	AOcoxlLcCGgLfalWrKX9/rI2FlX18yI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpGRnd5w;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA1F41880;
	Sun,  2 Aug 2026 16:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E31F000E9;
	Sun,  2 Aug 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688000;
	bh=IGCINO/SWEhcdDZT6Rs7xP4paJCTjootNamfovWsNx8=;
	h=From:To:Cc:Subject:Date;
	b=VpGRnd5wb1TGHH2yVTvKKt7gt559B5Fsyf+0aoryOVBfpVQvbkRRyZloEG7+VC3/t
	 gvOfMvKTT++vfALmsuCfaxj27NDqS80KSi8Bbj9AXQ1RTFr9PqhOpEg2eIkoiQkG/R
	 uGZWNVmawo7KX28etI8LpzJQ2PATd+HrtUkoooKsMY7qxO4tlj8KeiSennLvVbnBE5
	 Nx+sGkyybIdweDudkhozsWjsibmtI8WOVbvt6lD/rtAjp9Iv8XCmZU9eDmkkE5Bjks
	 +XSgL9k5DyciHPhusNV98s/J+Yl6ohfXbOF/IghMuW9SEIQ/hg1FBwPxjTqWLmWlIA
	 QHQu7OnFJXXAw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/9] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Sun,  2 Aug 2026 09:26:21 -0700
Message-ID: <20260802162631.90304-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 548A31C000A
X-Stat-Signature: ak6ft6p3gdd34n1e6gonx6fcswyih7ei
X-HE-Tag: 1785688001-456705
X-HE-Meta: U2FsdGVkX1+JdDmchs0BD8P9hepzaXAI9zWoPCdahcExQOLoi11j4hkB7Nu+AMVQHBzh0pxOQNQ2ijdAueArM91UeVqkFC8fvYUYeYgoLCFkVzJOnPlwgWjyW1sQP0Dzc8nhdAQHXAcZBj0YR8MZjEMvOVxCdO43zIB4dn1HYvxecuCdv+0DTI0vJEwifYSRnHrqfLxkNYcZ37sTNCT8R4d6YTP4Ld7y69Lqu6RWyjtko59AOxd8n+68l+bj8YE03lTg4x9pyD3jJdF7cweVUjaB/pSJPepFntgceixb3dNeQlnFa39gRD8Mv7k/N63ls41QpUZ/otr67uPmc/SZq7ewO2bNOzN1S3VMzQi0SDmo2ZqCc9lC8CgbZdkMIYffdkDY/XiMfz0IDMAZRcrW7fn/qdLZd+GI+RAo89QFGe4W1tpxquK8hCF26mlKBqshvOhaPf3Fdelwwc+Htl0F0FqWtICy3vp53cS20EPgNdOKTs6nDSwCES7UjtHUX0DjR7Yn+C5g15SZKdGdFSfKLuBBuWW0TZKjoHnngTBJTZsYoT834r65TpGqJ8KXgShMdLT0k89/E8EXbAouOc1BJ4dgiQvfgT8k1IVsskOXwc4QN/F1+issZn18jvRZOLCTZYi16KX0bcMZ2xp+ZC0S/pmn1RpkWq+yqcYG5WDL80iTTpnCLAFnoxbQeCLUmSs2DjcHgQ+drtH+C+ybNSpYMm7frgs9XiqeVaPEabeUJT72xjKS4U2LQFUqCA82NeswKAuIYctUQCdCvh2XQGcAGcSKP5q8+cwf52Xin7dPjnJIHHYfI5MLPKTAHPpZs8yRVvGqXZup634kFcHpWuxvg1aDQk9jPt3k6rtqUlLwzkb4j0ztsbBKDGwVhSr7mjZh8mZWo3R+bjQkzYVBT6OTWasCTvyrdPfH2frgTc3KFDv62hdVsJ9RuD9B+egO0jAIpHCpxM0Og6eJgX/0gjX
 JFH1+3H7
 vxAMBRM82WlLT5HmZ0GzaX3gobkRhnCKDyKtMSIVC0x9t3+BF7XdrYe2ToszqHLTmZQ/0udfZ1SdBwLSrZ23Kk5QlYHLGHgiuxuMFTiK3bAx2EXZMIjF00BxYnZSb4ZOZPFskL6Smz6PKWD6+aWN5p6x4pFULQdjCSDvPqU+GOCrdE4HJxr18r6ZuAKmANBECM9KMH7JfypEqK081DJWPUBtrmqDjvKXkY43zDHBWtYGvuUgVjkIaTqK90mQXY/HOpnbUSo066+LcWaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix misc bugs of DAMOS.  Patch 1 make DAMOS less stress memory allocator
under extreme situation.  Patch 2 fixes wrong DAMOS quota auto-tuning
feedback loop start point for PSI goal.  Patches 3 and 4 fix wrong
folios walking in DAMON_PADDR.  Patches 5 and 6 fix wrong folios walking
in DAMON_VADDR.  Patches 7-9 handle extreme and unlikely memory
situations that can cause divide by zero and underflow.

All bugs are discovered by Sashiko.

The bugs are not very critical, but better to be merged sooner than
later.  Since mm.git is closed for urgent changes, I aim for 7.3-rcX.  I
will drop the RFC tag after 7.3-rc1.

Changes from RFC
- RFC: https://lore.kernel.org/20260801173554.94710-1-sj@kernel.org
- Use cached pte content (patch 5 and 6).
- Handle totalram < freeram case (patch 7).
- Fix wrong function name in commit message (patch 9).

SJ Park (9):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: initialize damos_quota_goal->last_psi_total
  mm/damon/paddr: respect folio end for DAMOS_STAT
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/vaddr: respect folio end for DAMOS_STAT
  mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
  mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
  mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
  mm/damon/core: handle extreme memory state in get_in_active_mem_bp()

 mm/damon/core.c  | 37 +++++++++++++++++++++++++++++++------
 mm/damon/paddr.c |  8 ++++----
 mm/damon/vaddr.c | 10 ++++++++--
 3 files changed, 43 insertions(+), 12 deletions(-)


base-commit: 481be0db7cfd092f0aea64e65ab0a9cacff88453
-- 
2.47.3

