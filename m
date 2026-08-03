Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7CAC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC496B00B5; Mon,  3 Aug 2026 09:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83D66B00BB; Mon,  3 Aug 2026 09:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99E56B00BF; Mon,  3 Aug 2026 09:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87C996B00B5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:52:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31DE81A06D2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:25:03 +0000 (UTC)
X-FDA: 85059726486.18.6DE584A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B59FEA0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:25:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmBKYRqN;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lesqJaE1Qf80CwnHT9u+4fD+Y0+6W9ZltFdX8Makcts=;
	b=Sj+TAAqfEWVSEbAXtCJ7kBs5AzbmHxVJ7HnOhLgNqfsg1Bb7pHpRPwLczKvcwM/2W8l7PD
	ut9/Y8AR3sTF8JHuo9vBja+ZxcIwFkaniJU/7YCsW3TD7wmsBWED231IlDrxUvY83Ubbm5
	9MzUQPTvPyZYvVOt43a4VyTBa36Cjr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756301;
	b=UW01JcM4OxAzl5RmO5YoPaEbo2zKTe520vEjtxrG6tgUbq3UZPiJA246IcpjHKdAbi6sSQ
	sq7ZNvcrH1EH3/f0IuI6mL3LvoA8f3k917RvBqsbdxI9CcAINTR3YYVlv1Iogc5Jr2hdU1
	7/Ep681ZdIDdoU29AlwrxPHnKTV7SBo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmBKYRqN;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D762E60A78;
	Mon,  3 Aug 2026 11:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AB21F00A3A;
	Mon,  3 Aug 2026 11:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756299;
	bh=lesqJaE1Qf80CwnHT9u+4fD+Y0+6W9ZltFdX8Makcts=;
	h=From:To:Cc:Subject:Date;
	b=cmBKYRqNSM3hd3dBPltzjB0ReIsYt0+FdeJYZxTSGcyzv5fh1GR5xcF9T65vXIVqu
	 7T5uE45uNiCsN2oFBL6RPS8X+HHOwcruv8jz2kwCHOSRF2ADVyIsmVRaGGI0v81kJV
	 2D9l48r9JFQtFSQvQpQcQONRcO/jmTjEafbbWE55JFmNWc6p/+EPNPromVsyFy2drP
	 5l+5gb3gtqRI7vAu5YSyFIev9u2WjJ3e5PVAzkgsCna6CUMaGAaqQJJu5H6QLZIxwW
	 R9z+n67EjE0OS5Mj/11FnTgYRhyvOJ9RMqycF8gPbIty998sXtcNb5pt5gD+9C1Ihr
	 uM/x6KsU3iCEw==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Michal Clapinski <mclapinski@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] liveupdate: a fix for v7.2-rc7
Date: Mon,  3 Aug 2026 14:24:51 +0300
Message-ID: <20260803112452.1793120-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x71rupga54etn6z1bqogwpo3zeos4erg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B59FEA0007
X-HE-Tag: 1785756301-72109
X-HE-Meta: U2FsdGVkX19svIxYf4AbcVFJRSgcZA/VsXmnTcCvtrTAstAjdSHSdEjP49bWXGKwTaGo7JqjC8B9AkK7qft9v2ovEXIPJTXGVtV4oVralnlqaj81r7+gMmh5dafx6yG8kMwDbSCY9tu2/zsG+NPNblXfs+YwnGS8sY+pK6Qxr5VwHtZARupDwFK4nKIGwCBk8MSYHWSNNenBTOQ2r4cFRzOK9f0MarOoqtb/DwcGhH7Fkt/lZQCSCdmBJ8gQ5bqQkI3Sv0s1jPP43rlpC2j8FM8UPGDuRsmgfpezNniAIu78KnGpbBsJrqyOl/CaMiPPnb4AuVuwJCAi6JzYHKjKxgJTtl3aJ6NM4R341TkyPOqjbOzL5iUez5wHePuWDiK4mOrc2cy8qiadgocxbCuUAOBcM3d5nNzX5vpPxYowhg0kXbBjU+Y1UBnXMsnIFDZTOnNmysauSH5Ss5qNhZrVixg7R0MAe9rSA0J9Gsp/PdUxgYHXMqRAJD98G5O+2MqyvkwXqewU59baM/E0q0EXQG3rBvEjsoRlJ1naJ7swQrTfRYrkKxmTrpFeerR9yUtOUJTc8iDdCabHB9tREwlHHJnMDgJA5mNV5YfwCBoWIX54+BBBdC6wWZsgm/IcvkZgnHCbSkqkJMwc0+NsK1TKAA+NsrIK0Ta4iWLrmJabLP/OjupGsfalEMBg2l2Mbk1tXkRpefvvMYdJwj+J4Jyvyt7n+jr04tjaq2/z3zsdaUkhwv8T5NuJZj2igkdwkqmrWyUfiWJHPvFRVqZiU4UV1FtFKB6tI0bN+Dhtp84SUuL0m22UUnJrijbnisxB+h3OsbbuQS+Qg1SnSH8AccnBqrgQXOK/I6Nn+o+E/wVHS58HYm27CZXuEyq53iWTuLmSmvQmGDVa4UAnZITBkoPJv5rUgTS4U1NyvfLULTjeTtPAL5leQBo9GcjpudnzHhVcCiqYyRvnBU/hj67d9/T
 AM0k/Ivi
 h+NYMylDFGW0vcXmyzaNBnUP5+uMYRmlGvMqMI+1sM0JRwBxvT4OnxngRdLjZvMlyA5a1lbGSV1fMJL5FJ3g9tCOqoWYOU43q9sG+U8x8HoCvBARG4FJJ2VO7c+O7WZVnV09lzR4+dCy+Y1xZZAi0lRd6cFpCsenAjzTkQyy2U4Ryh/fp9xmU1SjgPv6mUSE32wlLvTIeQYB2XBFlm5sMd5Qk9ZcyL05iXUqOeaPuaDezJpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 4416f8a9ed5f49256dc69c664f1386b496ca16a1:

  liveupdate: fix GET_NAME ioctl argument validation (2026-07-16 09:25:30 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-08-03

for you to fetch changes up to 797fe91e50d6927f90f0c3b4444277c2c7c8b42b:

  kho: align kho_scratch to MAX_ORDER_NR_PAGES pages (2026-07-25 15:26:30 +0300)

----------------------------------------------------------------
liveupdate: a fix for v7.2-rc7

* fix a regression caused by allowing coexistence of KHO with deferred
  initialization of the memory map.

----------------------------------------------------------------
Michal Clapinski (1):
      kho: align kho_scratch to MAX_ORDER_NR_PAGES pages

 kernel/liveupdate/kexec_handover.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

