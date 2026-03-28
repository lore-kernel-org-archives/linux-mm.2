Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC0110F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F66E6B0096; Sat, 28 Mar 2026 13:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A71D6B0098; Sat, 28 Mar 2026 13:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26B46B0099; Sat, 28 Mar 2026 13:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62CC6B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:49:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B042951C18
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:49:08 +0000 (UTC)
X-FDA: 84596207976.01.C1F885E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36FFE180005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:49:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ppWh2Uei;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ppWh2Uei;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774720147; a=rsa-sha256;
	cv=none;
	b=5OD6TLFDUOzLtR4g6U/mS45XZU3mTEQTdzvv2x7MmfFICGhVi06L87WcIEQaAbvkd53xIc
	XHlO7GU9VXMg1w+e+YArqgLQGrJnJJL1A1MTOXEccxW165ZqzcJ32WoCWnvf5FBJyPzQBJ
	BvolpuxicO6T5RKJh1MIR7Y1nFh5MLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774720147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gH+CZhydwkHrBUeNYNdkBvZqMrEoIqCrf4Hoqu1hTa4=;
	b=2el2bL5YGvCvnBtdVhPiqfO16RReTIf4fOhBRiDTTZOUjtGsgFgGcTqXpTzHIGe3h3tOQO
	YJY4msyt+xu4nrR2Q2XlzMgQr8GWwv+IlEU4BndP6JVYGalYLFEYSwZa6xs1CtVvR3u5Rk
	DmzKMVEIJV0LAsE0aUqqKaSoL19Sp8M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B39ED60018;
	Sat, 28 Mar 2026 17:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436BDC4CEF7;
	Sat, 28 Mar 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774720146;
	bh=dKl5Ev2JkKCfZFM2QBz1yv5YQSqYGiO+Zq8rSPe3O4c=;
	h=Date:From:To:Cc:Subject:From;
	b=ppWh2UeinNAOpe+n4gw2MNeAHyLbU0436KkQlytVr7GrSXPRj61PmcJOUKx3kj7U0
	 XI21P4TWD+ABXgMw88cs95u9Pl5O/WugdAF3GlWIyneu5sU7K4Kwzzz6/HNFy2AsM5
	 poUGF2PSco6qn94+Uhu+vjJRr5weXVQil01MHywE=
Date: Sat, 28 Mar 2026 10:49:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] Additional hotfixes for 7.0-rc6
Message-Id: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36FFE180005
X-Stat-Signature: muj54p9763rizijke6yxysdzekehx1xc
X-Rspam-User: 
X-HE-Tag: 1774720147-412083
X-HE-Meta: U2FsdGVkX19HLLchszxUzgTtCW7zP4+bbE4St49KmZ1VkfNsYOqU/NimoSZOjppLOhc7gybg2QzenuS+37U9yeW3GWPv/nE1pcj5ctVYutxKg1HNE0KFyeCFr3i17eX/8VoTv5IIKAzjSMM/ynhDg2X0Zw1+3toyvdghPmvrjrHy/ADo50w2FqrCc/6dqTOZrsshTfeKlwHybcWydW3YYYql+5x1of97GyMuAJD2ruS5IQkurWvMJnXafFJjIWOlk4H1lOj8rw15UNWa9x7g/7Ns/NcLnkYCYdOcEwY6f6TRRMJGpDV57Gb/cxFzY9XEAvazML69r9AU/MYxOEbm1i5iHBHWUsjuQpBTVGtYqGVNTN2bni0bh4ATfJs8El67NTqJh8pMyifKhCYz52i+TRsD6izJbF4H4/CfMTgZ/WgwbFO8uJ8FgfHN67J8djJo1ofHdeKtRyfrAL0FHUGkdSBMHF11wT4TXFPlF9ttqidXGTe43pb/LAi6IbH/bErPX8qd/GiW0kDZ3K4cDaR577EOg+1z/ESpsZ2GCLEfAdb8CE5PRlHP91t6hxce11jGJoUayn6/juNvHhfkbP/nJ6+52puymvkjKCssz3hHffi7GvnhC9kSiRmbzyVNUH07O8yRKiUSplP0mVUlW5haKCA395zWJqgwEm5NxMiEhtyonJuPEpTy2S9M6BVzodK+aZfgx/aH6TgU0oxUCFldQYfmJOPt8YbOFzsS7dYzJurHa6oml9iHlrMR804ZoQgkI6FICy4X8uHVt1Df1iYOu646qJ8z4M1IKZGFtCAWNVN7vxu0mII7FrsaLmCINOvJk28KVJyrr9LZraeTWwF7Oj/vA6XWNNKyMAnQAXj8ytNsRD621fD3JUpSYpVQu3+a9EcyDJjBCjRh/ZGbiHk4S1P1sLudH7qnBVskdKoJ4EBnsC+pqSVRHifHIq0tQ0sQ3Cz/mzqLCTPV5koSeS6
 7fzmVXWN
 sUPBLeNGug68WGucUa3nSUVUs8RCPI3Jy6Ws20U3WG5MCX680GqVj7trXmnfpFEuePljUSDN3gmccreCfvKSseScelTeWUggmtcxthQrZD45tXxUenBIJKZRZRreEXGOBQGhh4eJJZLD4lNhOUJIFm8yDqzZAnCJsmKVkM50JiL1ARBgxPJyJSF84AfmF7InUwQBrhLKcSwkbiUBJT516ot5PnXEUGNLbrN5AeOPKtiwga79kKnr3ru9Rv9y/jQux0a85jU7TQC4kyKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 24f9515de8778410e4b84c85b196c9850d2c1e18:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2026-03-24 13:11:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45

for you to fetch changes up to 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc:

  mm/mseal: update VMA end correctly on merge (2026-03-27 20:48:38 -0700)

----------------------------------------------------------------
10 hotfixes.  8 are cc:stable.  9 are for MM.

There's a 3-patch series of DAMON fixes from Josh Law and SeongJae Park.
The rest are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm/swap: fix swap cache memcg accounting

Arnd Bergmann (1):
      bug: avoid format attribute warning for clang as well

David Hildenbrand (Arm) (1):
      mm/memory: fix PMD/PUD checks in follow_pfnmap_start()

Harry Yoo (Oracle) (1):
      MAINTAINERS, mailmap: update email address for Harry Yoo

Jinjiang Tu (1):
      mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Josh Law (3):
      mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
      mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
      mm/damon/sysfs: check contexts->nr in repeat_call_fn

Lorenzo Stoakes (Oracle) (1):
      mm/mseal: update VMA end correctly on merge

Max Boone (1):
      mm/pagewalk: fix race between concurrent split and refault

 .mailmap                |  1 +
 MAINTAINERS             |  4 ++--
 include/linux/leafops.h | 32 +++++++++++++++++++++-----------
 lib/bug.c               |  7 ++-----
 mm/damon/sysfs.c        | 10 +++++++++-
 mm/memory.c             | 18 +++++++++++++++---
 mm/mseal.c              |  3 +--
 mm/pagewalk.c           | 25 ++++++++++++++++++++++---
 mm/swap_state.c         |  9 ++++-----
 9 files changed, 77 insertions(+), 32 deletions(-)


