Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 341FDCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671B88E0092; Fri, 22 Aug 2025 05:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623628E008C; Fri, 22 Aug 2025 05:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB278E0092; Fri, 22 Aug 2025 05:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 375E08E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB9C51183C3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:11 +0000 (UTC)
X-FDA: 83803942782.10.4E911F5
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 915231C0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=FcS1WAEyrERG/l/cB7IXboLAElQpLk48UPtyl1AZjVc=;
	b=UqPiRkeXIV8dZNhhxn3dbN7uV9LuG77HO1eJLUv1wNg2Ln+8odMh4aR8s37ZgF4x2ipjV3
	c5Wco/ImidHLBMlcNiZ6fmFJQi/choIkuc4fV/B0t+NHvDV2CzQr9F6qLQ6Yv6iSTzHdLa
	YirAcPdL4xzTeUYJqzgpEMjVL1xXkU0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856689; a=rsa-sha256;
	cv=none;
	b=CWHB4PlJbRVKAOiI4eVCOSeWsp43JjV1ZthPQOb9/e83lnG53CjXtWAVcWFogLEdWaqT+w
	NkpfFSbIw2DTM8gyc5xcfqMwd5Us1uyznSZLXqQclrOWTjmQulHL+H5uv+fluBwM9dWFyZ
	xMWtmzTWcn+FtEZOmPz8BdV4I+K8RrM=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGk5BLBz9sS8;
	Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IWDZVwqsS1ox; Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGk4BThz9sRs;
	Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7BEF38B781;
	Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id eIHQVHg49t7f; Fri, 22 Aug 2025 11:58:06 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6BEC98B775;
	Fri, 22 Aug 2025 11:58:05 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 00/10] powerpc: Implement masked user access
Date: Fri, 22 Aug 2025 11:57:56 +0200
Message-ID: <cover.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856678; l=3745; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=/phN/AgtMsLAd6ka2rRe1+fTTKRpm5UtXySxy3tBMG8=; b=1V9AFEKpjDyk6FnUrGnkLYoDWwBrkQcqv5fCGwg429FpoGvEzmMQhX1fRZY0SIQqSAI16OrRi R6sNAdKx0x1A+t4how5qZX/b5neGHfNC9U+6+4eTmM1L60Bhm6fz49y
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 915231C0006
X-Stat-Signature: zi36tfmryozwbgukzj39gsimhu7so5s3
X-Rspam-User: 
X-HE-Tag: 1755856689-311999
X-HE-Meta: U2FsdGVkX181eKSB6C8ayrtyWirv5+TDZs2I/oKJ5qQ2h+vBO68fJ+cOFtdIpQYsJi6o9O9a+LQL5RgUG0ptMrzZWGXhPjYHM6SG+pc9z2WzynS/euVwRRfYFl9s0Ym21rEmDj1NyL7c6T13En1Fs9gt+MTR3wrilV7z1aBxODhd45cKUs16xIxMQbLtJAasQXNblRMYpDSTWlQ9j8xQWwT6bKf4zC2weLp1zvNzppamiW1fXQRDgS2DzPf2Tkts/pruE3m/oMd3OjfKgOOuIbXHOB0DlV8Z6L+8UNUaqxKH8/urzfzuQwtpjx9e4lWD+nCqAlOY02ZeNplRYOjCxGYdSHhQNRZlDpoOog8lVvTCTnRBINiIQ64InOYrPIdFSGXQ6uf/JqKcD4bZHm7e1yidY4IJf/esLPZ0dW4eCWTiWP/9wG5I2AKydzwtSFiVLkWMeWZk4+LDijmGp76mSLi27HJD3uep/Lg74s07tEdQvN58oc+dq2IHOvjbSkLwOMlUQVNELwhxOj8q8iScJWimrOAJgcJSqHlCAI7joFxvbwE9sW5kglJUGCPxZt+jfhD56xwSAzfzCsT67eIc4X1llJ5cXPG+8MXnG8QgL//mt8gF2s2gv9KyUv9rc9I+Xws41kruAi9NvWMNwRsg4lBWTS+tX9C4afiGUEKPqBI3JdR+WqGoKkuqFmri/maKMV7RqDx3cN2eg31Z/noAaiKG02rJYmGhqq91NrKS9dye473pbz9DWI/0asE7joETPS9BfgnOgaNy+dVghmCoK4luxRRTALQb6GoG7tForPgg4/7S4Ur60ZmoQmd7e0Rqu0hwrBH+tLRilmlbwgWeDmr95VkxQ6Z9Acqz0J6jakHBjbL41GMi8bNhCCWB75Wz5TK675z/3NlT+HV1apZSfRKqlSPY2mgaHrY5POxEXCl5zrkouWNW57xOZz7h1CT8ODhO8uQGtG5md6QzYw8
 6mAqz0hw
 uocjv+QglNCBe6pgBdB/fnkrq0gQdAbsgVDi5bSwiKJcFC6vsrGEg/a15YjgbOi2TYfbJERD8s53EV4JvHrRs3vEtYyxKAuIugFie+6c577payr1JXMWcQz6xA+oZEr1IdRCf9o+evaoz/16G21His0LOtKOTw95DitVMloe8XXwQpDvpnSmXu0RPUgaDt5oWvSnqknh0Xlv/Hi2T0DVYuoQc4KHU32JvMYuk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Masked user access avoids the address/size verification by access_ok().
Allthough its main purpose is to skip the speculation in the
verification of user address and size hence avoid the need of spec
mitigation, it also has the advantage to reduce the amount of
instructions needed so it also benefits to platforms that don't
need speculation mitigation, especially when the size of the copy is
not know at build time.

Patches 1,2,4 are cleaning up some redundant barrier_nospec()
introduced by commit 74e19ef0ff80 ("uaccess: Add speculation barrier
to copy_from_user()"). To do that, a speculation barrier is added to
copy_from_user_iter() so that the barrier in powerpc raw_copy_from_user()
which is redundant with the one in copy_from_user() can be removed. To
avoid impacting x86, copy_from_user_iter() is first converted to using
masked user access.

Patch 3 adds masked_user_read_access_begin() and
masked_user_write_access_begin() to match with user_read_access_end()
and user_write_access_end().

Patches 5,6,7 are cleaning up powerpc uaccess functions.

Patches 8 and 9 prepare powerpc/32 for the necessary gap at the top
of userspace.

Last patch implements masked user access.

Changes in v2:
- Converted copy_from_user_iter() to using masked user access.
- Cleaned up powerpc uaccess function to minimise code duplication
when adding masked user access
- Automated TASK_SIZE calculation to minimise use of BUILD_BUG_ON()
- Tried to make some commit messages more clean based on feedback from
version 1 of the series.

Christophe Leroy (10):
  iter: Avoid barrier_nospec() in copy_from_user_iter()
  uaccess: Add speculation barrier to copy_from_user_iter()
  uaccess: Add masked_user_{read/write}_access_begin
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()
  powerpc/uaccess: Remove unused size and from parameters from
    allow_access_user()
  powerpc/uaccess: Remove
    {allow/prevent}_{read/write/read_write}_{from/to/}_user()
  powerpc/uaccess: Refactor user_{read/write/}_access_begin()
  powerpc/32s: Fix segments setup when TASK_SIZE is not a multiple of
    256M
  powerpc/32: Automatically adapt TASK_SIZE based on constraints
  powerpc/uaccess: Implement masked user access

 arch/powerpc/Kconfig                          |   3 +-
 arch/powerpc/include/asm/barrier.h            |   2 +-
 arch/powerpc/include/asm/book3s/32/kup.h      |   3 +-
 arch/powerpc/include/asm/book3s/32/mmu-hash.h |   5 +-
 arch/powerpc/include/asm/book3s/32/pgtable.h  |   4 -
 arch/powerpc/include/asm/book3s/64/kup.h      |   6 +-
 arch/powerpc/include/asm/kup.h                |  52 +------
 arch/powerpc/include/asm/nohash/32/kup-8xx.h  |   3 +-
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h  |   4 -
 arch/powerpc/include/asm/nohash/kup-booke.h   |   3 +-
 arch/powerpc/include/asm/task_size_32.h       |  28 +++-
 arch/powerpc/include/asm/uaccess.h            | 134 +++++++++++++-----
 arch/powerpc/kernel/asm-offsets.c             |   2 +-
 arch/powerpc/kernel/head_book3s_32.S          |   6 +-
 arch/powerpc/mm/book3s32/mmu.c                |   4 +-
 arch/powerpc/mm/mem.c                         |   2 -
 arch/powerpc/mm/nohash/8xx.c                  |   2 -
 arch/powerpc/mm/ptdump/segment_regs.c         |   2 +-
 fs/select.c                                   |   2 +-
 include/linux/uaccess.h                       |   7 +
 kernel/futex/futex.h                          |   4 +-
 lib/iov_iter.c                                |  22 ++-
 lib/strncpy_from_user.c                       |   2 +-
 lib/strnlen_user.c                            |   2 +-
 24 files changed, 172 insertions(+), 132 deletions(-)

-- 
2.49.0


