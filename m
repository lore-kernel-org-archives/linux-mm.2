Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCF4C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E9A6B009D; Fri, 21 Aug 2026 15:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFDA6B009F; Fri, 21 Aug 2026 15:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C496B00A0; Fri, 21 Aug 2026 15:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF226B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01ADF1A0268
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:43 +0000 (UTC)
X-FDA: 85126258728.24.FDD1053
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 920DA1C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=h5gDY0LS;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340402;
	b=YXmwdp7aH08gzz/KXQ8qTRCBsbQMRmKJCjdfDyQzNTU5JyEuMSL8nbvg4z7aBmNFmMolmp
	hhlSOhcgIFpjZ0ttjz967fu+yc8Jb1Ees/bonH5fyvxuqr1+trqp2rXWfW+dpgp30jkuOe
	at3c7cTTWQBXgHCNdUBlDka7ODbVW1w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=h5gDY0LS;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UzzXCRkZBIFLuWMJrKxsdtQj0pfVNINGow9N0iGvU9s=;
	b=o90mV55lFhyTP6bH6VI4Ef1rkQmozTWANE+JqJSqAsMFSKGtJJm0QJPgb49MZ49W/mXTHP
	jEdMkC2gEx9p8CTLNUhfkK30K16KCwkaNCH8m4r3pjB5X7NAYqhviEeZXeDYNQKSKTWD44
	KP0oYTwjKGtA7X30/xrKwMRqEziyoCM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UzzXCRkZBIFLuWMJrKxsdtQj0pfVNINGow9N0iGvU9s=; b=h5gDY0LSX/yuB9FLkhffQzlohK
	mKDTy/V1MvdKQR4Y1kpZmaDUOZ8qRysQOHC3yDJl9WNllzfW7HILppuMGyAxM8zgLjutEhShNOGIN
	WaY//ZkX477E9YGIMoKKpRJZ4YcQ4VgW78K+Tj5HOAErLGtcXgdNnafBxgWPEZdTVwswLD5MGuw3b
	0ZHCTj38dFUjG/yb33/ltgEqU1YQsn26SbiP8Xb4VRVzpylOJz/hytf3MengKi9JwmAwdYRBF7x06
	bch71K8vWg86qeyerXTHeI01kVR3u65U37rJqv85tU15HTF9aE5JouxnF9t6V9YYJtvJ/dVG+8vzb
	1mCdK5Ew==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUsx-0000000E0gT-1sBQ;
	Fri, 21 Aug 2026 19:26:39 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 00/19] maple_tree: lock checking and clean ups
Date: Fri, 21 Aug 2026 15:26:08 -0400
Message-ID: <20260821192627.4085470-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 920DA1C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3wxkb6znt3oe1kque54f7s8ujcy9amtb
X-HE-Tag: 1787340401-981613
X-HE-Meta: U2FsdGVkX18esbFZBF8KgYEIAWx9XsM9ACkiqkfnlWF41Kt0KCHlCvxD0ZDWiR6WJoD4k8knaN5AwZRpm14Y+u1R5a++zDr2nPqIxQHdaAZHkTb+0iwzsT2f/ZHzRWY9y6unTmYob3YSayg7M7JbZbK73Izd0Q4zqi69yf6AYi0hgr8ShzsO7jGKEkB14/GnwFfH69N481tzJbDICDtoXJrb027/GxdBo3Y14oZgFNyWS8YwWnaUzWKF6pMErlLfQV07oGQjH/RNamIdBvt+/6XEmeoxAZsu2FYDFNoV9x4gLaXdcNfh3+U01xXxMIJvjBsYt8HYyjGHiTEVg28TRUiZk7pIdORz/0b3Ow8tKKjiZoeZzjME0g+CLVI1DKRXXt6Wsr5mYWOx/AhwVPRsKKaFYpyH1C5e549WciJuUhcP8E2fM8ePv9sANqLFmBgeqGiHhD8Ph4XZsxZms/3asDL93bzJmHG1lcc0UCkdp4QEySTz3vQi89QTU15Z02tRsl7vQtyCvjow5Kfc9jPZa9emdcbD6oloS+a1H26IV7q7D5Gk2zEUUxC+2mFTV7pSOp0zdmBEDmd2LI821ck/PwcVB+tOk1Z9Ii7+hoDPDtYY2Zt2F7TyoIvs5EahlzlzVkwnliRlzcsEjMq3nZ7st4okjWz+xMZpqMXLtu+/UGBc+jQp7IFI37PLEwNen7d8nS5lZeWqYQ6KhNKdeZCQn4iSMz9raCotyczN5SdAIcWKbSB2D0wCQXJVVL1Zj7ChuBHKBRcylEKBILVr88tms1Xpwk4MgUQvNZhV2L9i90BhMlS06HGapnu0BH+o6KVkVkA/8UPWkL6rRUKFH8l4ljFuLaFvsVI6knjI9ylabntTMxFcEXZBXgyJ6viF2O8FkndcRaOATiBUnPmFIOcFzFzzRPF4A4YM5dcNf+uwf2+dQVYJcr+5ogyjsHZpglRNP0FNqhaTx62sQTyKudE
 1lyYbs7w
 LhSKMMKgDdweE0Wu0I6wPWfX0vJrL+1QwpvrroyqOZ3sAqyNXKwyCZCOAoGwevYAHmZsBzN/CcwDNKAK2P1E9NTRayDT/kGF8pQexwcy/SGuA+AcLeV5err5pnQSM23Gs3dIBmJfMX7Our6VNsMK4sPIy08MzFTV9E69Pabbn2gTYmNh/uI5J4AO9LvivXsIZNZ6STEKBa6Ddo5FoErD3aZ9ogNsCpJ4b3Buscl+nAbGwZOk72QwPNgK4NDY++zlRvRxOVszcmIvQGGQXtJvYyFWnZ1pzXmC/EJ/xjduzv7itFNH99CDG60f719JRL7inav6if+bnvKVxdP3JMC9YVYL7mY2WEbowURURyF7Vh7syeOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In this series:
1. Try to detect lock issues
  A number of syzbot reports are incorrectly pointing to the mm exit as
  a source of the locking error.  The first three patches attempt to
  help users detect errors in their locking - but they still have to use
  LOCKDEP.  I guess it's still down to hope and prayers.

2. Documentation fixes
  The documentation was lacking clarity, there are updates to try and
  help the users, especially around the erase() cases.

3. Two benign issues
  The cyclic allocator may have a race, although no in-kernel user can
  hit it.
  The erase functions may cause allocation issues if used with the
  incorrect locking type, but none are present in-tree.

4. The erase gfp uses
  mas_erase() and mtree_erase() do not take a gfp argument.  To improve
  reliability of the erase, the first attempt to allocate will be
  GFP_NOWAIT, followed by a retry (if necessary of GFP_KERNEL |
  GFP_NOFAIL.  This will ensure the data is gone.  I've updated the
  documentation to make it more clear as well.  mas_store() is not
  addressed in the same way, but may need to be updated at a later date,
  but that may require changing callers so it is out of scope here.

Beyond these goals there are some test fixes, some general speed-up
patches targeting extra work and cycles, and dropping dead code.

v2: https://lore.kernel.org/all/20260630190843.3563858-1-liam@infradead.org/
v1: https://lore.kernel.org/all/20260629144145.1572283-1-liam@infradead.org/

Changes since v2:
 - Added a mas_nomem_nofail() function for mas_erase() - Thanks Jason,
   Vlastimil, and Pedro.
 - Dropped the WARN_ON() that was triggered by syzbot and questioned by
   Andrew - Thanks Andrew (and the syzbot)

Liam R. Howlett (Oracle) (19):
  maple_tree: Add rcu locking check when LOCKDEP is enabled
  locking/lockdep: Add sequence counter to held_lock
  maple_tree: Add write lock checking with lockdep sequence numbers
  maple_tree: Documentation fix
  maple_tree: Drop dead code from mas_extend_spanning_null()
  maple_tree: Drop MAPLE_ALLOC_SLOTS
  maple_tree: Clarify comments on mas_nomem()
  maple_tree: Use prefetched value in mas_wr_store_type()
  maple_tree: Optimise mas_wr_node_store() when not in rcu mode
  maple_tree: micro optimisation of mas_wr_store_type()
  maple_tree: Add bulk parent set helper
  maple_tree: Catch race in mas_alloc_cyclic()
  maple_tree: Document that erase may use GFP_KERNEL for allocations
  maple_tree: Avoid mas_erase() and mtree_erase() failures
  maple_tree: Document erase and allocations better
  maple_tree: Change two GFP flags in tests
  maple_tree: Fix argument name in header
  maple_tree: Avoid extra gap calculation
  maple_tree: Add helper mas_make_walkable()

 Documentation/core-api/maple_tree.rst |  23 +-
 include/linux/lockdep.h               |   3 +
 include/linux/lockdep_types.h         |   3 +-
 include/linux/maple_tree.h            |  12 +-
 include/linux/sched.h                 |   1 +
 kernel/locking/lockdep.c              |  58 +++-
 lib/maple_tree.c                      | 394 ++++++++++++++++++--------
 tools/testing/radix-tree/maple.c      |   4 +-
 8 files changed, 366 insertions(+), 132 deletions(-)

-- 
2.47.3


