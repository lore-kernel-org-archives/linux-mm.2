Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB72FCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B35A8E002E; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B6C8E0013; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C82A8E002E; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDDA8E0013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:27:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 097861DB521
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:48 +0000 (UTC)
X-FDA: 83800539816.12.F5F39CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36D4880010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:27:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xreu90YK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755775666;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l7aqhOmp62sLlI2kYg3DXs6kWD5ie+nXApiSAqGAJ+8=;
	b=NlK+Ad9ZgbLm8Lpsr9Rk6KwG/3U/F2ccEJ562+szb+Ba/sRWdFKfcFKJDdIfn8CQI0mSA5
	Gf9hHbYBWUBHkYySZ7e4WYRZoFEfertdsBDxLRfYHi4Ri7FKXLfwc0+nTU7NNqSfNWyCly
	mqVGuG0m8TG8aQOqZaUSW9k+wKTYXgY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xreu90YK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755775666; a=rsa-sha256;
	cv=none;
	b=nGreUDXjj7RQOnprQ9Y1n7koLKwZMB99pGbtNXI72czyy7U5oxDBetrT645mAAqcg/G3DH
	xaDkBUp7Pz1O8Spha7OfM90Kl+h5gM2zOe/83+w2hl8nSjKeDC3glRcHU/aSDaZVoA+gsJ
	zH7TchHMYwN5X2Jl+CG3WQJkgYoYGOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6548F60200;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11C27C4CEEB;
	Thu, 21 Aug 2025 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755775665;
	bh=3jlVObemI8wNIqbrx4GvyEPDpvdLGZ3e4VpPlUqrZvQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Xreu90YKRQkLt1GO00XLRQQzdbuLIWkk65EQ5x8E2usICSaQzGLr3rUvLMlI61Tm6
	 aiBsHyhQBqAHVqio3Upg/jGa9zuH/uhNM1iJPc1bJBRtJ7OqOHEXcUBxhxS+s8W+Qn
	 scFoT6OqjMgbaZCuUyrihQhdZfNI9/7PxKjV2CbNFOmr7RuvwHiNBOyxqJRPw6m4wJ
	 mQpH3HGADdDY3UarIDl33cXw27pa1p/ln9xaIYrVUFQv07mA3wIXLMOHtFC21vsHQq
	 2uvCYKY7hbNu6dZEL4IZ9HapzJbNuHxpArLOzFm+aj8ODjBQleJuOuiqG+j6VwnamX
	 TOJ+WSssFboww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB60FCA0EEB;
	Thu, 21 Aug 2025 11:27:44 +0000 (UTC)
From: Simon Schuster via B4 Relay <devnull+schuster.simon.siemens-energy.com@kernel.org>
Subject: [PATCH 0/2] nios2: Add architecture support for clone3
Date: Thu, 21 Aug 2025 13:27:36 +0200
Message-Id: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKgCp2gC/x3MwQpAQBCA4VfRnE2tETavIgfWYIpZ7UpK3t3m+
 B3+/4HIQThCmz0Q+JIoXhOKPAO3DrowypQMZKgytrCo4iOh7MfGO+uJbvPKJTYzVeTI2NqMkOI
 j8Cz3P+769/0A89WUVmgAAAA=
X-Change-ID: 20250818-nios2-implement-clone3-7f252c20860b
To: Dinh Nguyen <dinguyen@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Simon Schuster <schuster.simon@siemens-energy.com>
X-Mailer: b4 0.14.3-dev-2ce6c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755775663; l=1662;
 i=schuster.simon@siemens-energy.com; s=20250818;
 h=from:subject:message-id;
 bh=3jlVObemI8wNIqbrx4GvyEPDpvdLGZ3e4VpPlUqrZvQ=;
 b=EvDLXxPY5S6pbpEC5hc9qqVLOseYDpRYpX2Y6TYKHHZX+LeSi4Q1+g0YK6AAKayY4Ep67AapT
 z5MIMrak0rXAMAqA/7z5o+qoiazxY9e5SyLNyqkwcBCJL6n99MlLudo
X-Developer-Key: i=schuster.simon@siemens-energy.com; a=ed25519;
 pk=PUhOMiSp43aSeRE1H41KApxYOluamBFFiMfKlBjocvo=
X-Endpoint-Received: by B4 Relay for
 schuster.simon@siemens-energy.com/20250818 with auth_id=495
X-Original-From: Simon Schuster <schuster.simon@siemens-energy.com>
Reply-To: schuster.simon@siemens-energy.com
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 36D4880010
X-Stat-Signature: t8pox7xmrq9zacrme5uikeuwnujp46ej
X-Rspam-User: 
X-HE-Tag: 1755775666-32746
X-HE-Meta: U2FsdGVkX1+K3G6jG+ukfPzCcWJsWyd4Q/ZZq1BbNcjeroptM7oCFGf4pjrfMqjEW06VvcWfT8rPvmv8SScMI3F/VBQIiM1fYBkgqnDVirK0kTajpWxdC8d5LZcmc6mtGHprf/KzNB2ynPm8WLlNgEYiaqeIj/GcQZ+CxYKBOcpqQCqgJKV/qtuO37noQbVydJm8TTk5eWvgmZcCvmVbrt0NVZn009f5F862VrWsV8i0cvGJdRe11bmWlPjTCjJyk0Fv+D8h3lYLxgMT38avmGSvLzBrGOW5EafOgr8h1Y2Cb/nDnA4xfz0rcDFF/PcENKrndrEwiBL9V7nWrHI6gerrEkD99sb+bJLzFk4zJ138IfRg66Tl+5iGw9FgfstOnHDqDLoGl5c0FuRogmFCwBFxGXOoVyVEbqWfzAIdSdVvfGxlXyZchwbTlA4A1y7CLgV2uKUV0arAH432mPeSrJFxFVpixoX23SyetwEd8YYVm7l+FjzB2MvAwTppr8Xt8duA/neNB/HwdcEzHHQTdIRjpMhRH5WUqCVwzGJDbN8ORcldwwp3WluazApr1AFpnIt2PP7MaX6Z/tNJ329Y30LdVavdmOFRbbmOVpPObCeHWzv43uCBWLCn3uqsI/EtFVMA70R5MizgIm1nvj9PhJ2DIciZA/htJFuVeUItR/EtfBjD8fGeSZnU/0sMABEOYU0cLtvETj4m06MzHfr9GoM9vh9OPabhs/tAC2A8YwSogcsbNUbqdFaPw/t9HN56w1gKeKTe3u6OaGHD9y6i2R+Dzun67JMRPy0OyVQ1hrITe/sTM2kzqgVAktl9EUbTIR1vI/6r20wf/3m/RcNUFwmmOoDB7b1fA6fErja1xiHFxmZggA9gVwYKBu64zLNAOfm8IaoxmxGRo/whe/3KMFyEmLNpGJF9CmLHAzHCbP1r/X8pBk4ew0V0/FeE3LV07GMMXy5Dh1hmTRId09f
 q+F9EsDb
 ijfSKd/1Arla/lx6avONn7LQy4piSOwck6Plx4Exm1aw17uXRcRSY+6PpQWRsuueCEEdda+OWBdVfbc4y3xg68FqyXO/wKTYZGtbE2AA+Qsv/haQBOGGaB30196AdPv3otIK7/B5mkSXiZb7MlrilDpvdsBqyA6+oFjMehWaG8NG2eGhLNDprMcaYybV9A1zV6y2CNB/eif0B2tqpveIV2CX04fHZ305KYgsdlqJn0S/+qiUlnDz47/JExxbNJLBs0UuORQcv3g8watZ3Q64WpGGXzHbIlfN//uka9yz1MzY5ApeM5nhXOsadaQ2hD+yWXC+SDs3PIUhbd2hr3BnSYRwKI6mripSyEweTvYWCcO6/CqIwa42Pk5zcAbdTP6Abjc0CLKlKHwUEI/wYFpiByh9E6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for the clone3 system call to the nios2
architecture. This addresses the build-time warning "warning: clone3()
entry point is missing, please fix" introduced in 505d66d1abfb9
("clone3: drop __ARCH_WANT_SYS_CLONE3 macro"). The implementation passes
the relevant clone3 tests of kselftest when applied on top of
next-20250815:

	./run_kselftest.sh
	TAP version 13
	1..4
	# selftests: clone3: clone3
	ok 1 selftests: clone3: clone3
	# selftests: clone3: clone3_clear_sighand
	ok 2 selftests: clone3: clone3_clear_sighand
	# selftests: clone3: clone3_set_tid
	ok 3 selftests: clone3: clone3_set_tid
	# selftests: clone3: clone3_cap_checkpoint_restore
	ok 4 selftests: clone3: clone3_cap_checkpoint_restore

The series also includes a small patch to kernel/fork.c that ensures
that clone_flags are passed correctly on architectures where unsigned
long is insufficient to store the u64 clone_flags.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
---
Simon Schuster (2):
      copy_process: Handle architectures where sizeof(unsigned long) < sizeof(u64)
      nios2: implement architecture-specific portion of sys_clone3

 arch/nios2/include/asm/syscalls.h |  1 +
 arch/nios2/include/asm/unistd.h   |  2 --
 arch/nios2/kernel/entry.S         |  6 ++++++
 arch/nios2/kernel/syscall_table.c |  1 +
 kernel/fork.c                     | 10 +++++-----
 5 files changed, 13 insertions(+), 7 deletions(-)
---
base-commit: 1357b2649c026b51353c84ddd32bc963e8999603
change-id: 20250818-nios2-implement-clone3-7f252c20860b

Best regards,
-- 
Simon Schuster <schuster.simon@siemens-energy.com>



