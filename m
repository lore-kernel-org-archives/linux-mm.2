Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C3BCDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2626B0092; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844236B0098; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670C06B0096; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6BB6B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A94BF120285
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:46 +0000 (UTC)
X-FDA: 84919477692.03.3AD8C80
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C1EAC0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Em7Ve6Ui;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417045;
	b=ExwnvmFc7JoHecfMmBFaDT1nj1R7l52o+B7JxeIhAO1tq4kNepKt3jo1hUZcwhwQEgTu6I
	akc1pA0S8VkdHyt591udxsR/2hp520pd+RadzzfvhD4pEn1+LDqvmBG3syTwW47JcX0x9l
	V6Pue0C11zFUAZPCPbbpv2TmEX1ty0U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CsgYxCyG0u4oN4II/H54RJBLRLj2ocC61lpUYcyfB0s=;
	b=qamiytuTnnLHh5kVVw8hX323S4GbGhft3stU/0D4D1huW++FyqRWLL6SFItxAjlHT5ynsz
	Q3Wg6uVofXkhFWem6vzVT4nTkgJOxL9SG3Vr+zVpmj3moA4yFbo2b3wWVe+Lsj62no6Uyn
	HjFcEH5Ti9G31GuxfWs0MesYZTo33NQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Em7Ve6Ui;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CsgYxCyG0u4oN4II/H54RJBLRLj2ocC61lpUYcyfB0s=; b=Em7Ve6UipjyTdIxC6XaUuOzX8i
	tZ3SHAoOyy3SYpzrdcywkn4ZuvzvS7Yua1UFqQPyiO9JjqmBiJtbBTbrDYPEyjDHKvUUaL0z/G9Ee
	kEl3pxbc7lXTQHgHjSWF/9DXCH0Co0QRJj3OH4xrm4tZjVFCPge6GiffpY60wTqt13RFOwPAawQTa
	DsRCLWW4d81xmhK1uBhL2yyaGHryrrSNyC93dBqi89S4LZHykn4cr6NYTZl1HHvr1046pHMWlYcT4
	w5ixchXv7xDNy5Ynf4GCfRhQ+l2c7J9gZ45PYmliZyS66m0HKhTHKRD7zCHAPYPzVw6JYP4XgW2aD
	2VaNr1dA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5y-0000000AWXk-1724;
	Thu, 25 Jun 2026 19:50:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 00/11] Simplify filemap faults
Date: Thu, 25 Jun 2026 20:50:26 +0100
Message-ID: <20260625195040.2508362-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nj1udgojy36tdtyixdy46nk85weky9r7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C1EAC0009
X-HE-Tag: 1782417043-904135
X-HE-Meta: U2FsdGVkX1+BIUU3egQN4gq0TmtTn4VJOL3Pg6rh00krHoU0aFgVkBdmv996BmIrwQGDzJz5uk9JLTyrq9P1+y0ujIRR4RGKD5VEou2CdHwV9+XiDy9g7z0G0p5i14pWsmdw6yWPT/zHxg8rkPqVcAGDaT+wOeZFu/WkpwLKnZW/p5dkWtjBEQq9hvzW85bKZVBoS1pX4Rd1j4fZKbyVfvQTWv93L79HBTNO+gYC0kGwZUJTNtb9wJGZRP1xEQyYWKlHwwGDs5XofyInQ22S1myQp1ISedoiqm1OIbTbgxgQFjH7NQWz5sE2MkYgmuvD2G1oXxdm21UqzbvDP5SqP9xR32al+FxCdsZMpqotCf0xH7aEN60s+5/wmiFfRlz+cxqpNnL5t0XnKZqK3TfDthw89IYLkuGVnYengZEVPcL7/ZuHDRt+YC94m0C92OzHQPJ5KskZk/W/xMm+vEX2y7ePTUuylsVV+OlvJ3z//hrPPaLFwiG0Mz8uRQTNldEDfsl0lHgOE9mu+8Wq6d5Brb3bYQxe5hRsciII05jX5rtkXeSnwuW3vJ4wVN3rlMrhTCwJTtRxSWMd75XOV/+S04id3ZIwnNB0GPgBgmuuWdgbptNJ9T6ORH7yglWt7987Fb0Gr6KumThZaze30+DFdavvs+sWUmCEm1IutKSym0ACP2clm7XR6HmSb37rP+Xvtr+cp/Z8u0g73Hl/7VULZl/IjxMQEZohkTaFa1QS1cM+n68ir8Bl2mURsl4hAm1FkZS4ZUuKT6fcUG3JdPJPkRZqaWjs67qbFULLP19ADSnoo5eb2YLYvVrKBL0ArAYyao37WPrxCPwdBHauaHGtxRQDFfYHn4xk1uRhB3rDxO3rP7KQZNUAqjwTdrpYPn+XffoNnuKvBcC6XVyuR5Oh+UyyPo/obxBN8yhyLnAC4eWzhUrqKqbr/dEzPNZvAAzLIPW/Zkdy4B+jqtVlAG8
 b+x5CHMX
 rzZqxbapyLc9M5afLzn7w+lOSCiG3b20ihtHfS6Mal7NpRsbg8Q3CR5E/M/ptbeqSqfaYSGRojO2HV1oYdrOZh3Qa4c3PyFGEMYBcDQLEtzRCubYCrmrPgnAl2anSW3++1AruSb1k01tIYJENOZnEn5gy8+MMokmNJ/Sw6vFlOx25AtCSOLcBs/i/LOYZTBZ7g9F4XUa2uWknAE8L4wIQ1o41iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a fairly bold and opinionated patchset.

First, I think all calls to filemap_get_folio() (and its variants) all
check for errors.  That being the case, it's fine to stop trying to lock
a folio if there's a fatal signal.  I just didn't want to introduce a
FGP_KILLABLE flag ...

Second, I'm taking the position that all faults should be interruptible by
fatal signals, and therefore we don't need FAULT_FLAG_KILLABLE any more.
There were still places which didn't specify FAULT_FLAG_KILLABLE, but
they all handle errors being returned by handle_mm_fault(), and I think
they're all fine.

Third, we don't need to drop the fault lock in order to wait on reads
any more now we have VMA locking for faults.

Patch 8 actually fixes a bug ... I should probably move it up to the
front, but I've run out of time for today.

The diffstat is pretty pleasing, as is the reduction in complexity.
It's not as reduced as I'd like it to be, but it's a few steps in the
right direction.

Let's see what the various bots think of this.  My xfstests run didn't
show anything abnormal. but I'm not convinced it tests many of the
corner cases.

Matthew Wilcox (Oracle) (11):
  filemap: Lock folios killably in __filemap_get_folio_mpol()
  mm: Make all page faults killable
  filemap: Do sync readahead under the fault lock
  filemap: Do async readahead under the fault lock
  filemap: Do not pin the file when locking the folio
  filemap: Do synchronous reads under the fault lock
  mm: Remove fpin argument from maybe_unlock_mmap_for_io()
  filemap: Honour FAULT_FLAG_RETRY_NOWAIT when creating a folio
  filemap: Handle folio locking in __filemap_get_folio()
  mm: Do not release fault lock while handling write fault
  mm: Remove VM_FAULT_COMPLETED

 arch/alpha/mm/fault.c         |   4 -
 arch/arc/mm/fault.c           |   4 -
 arch/arm/mm/fault.c           |   6 +-
 arch/arm64/mm/fault.c         |   6 +-
 arch/csky/mm/fault.c          |   4 -
 arch/hexagon/mm/vm_fault.c    |   4 -
 arch/loongarch/mm/fault.c     |   6 +-
 arch/m68k/mm/fault.c          |   4 -
 arch/microblaze/mm/fault.c    |   4 -
 arch/mips/mm/fault.c          |   4 -
 arch/nios2/mm/fault.c         |   4 -
 arch/openrisc/mm/fault.c      |   4 -
 arch/parisc/mm/fault.c        |   4 -
 arch/powerpc/mm/copro_fault.c |   5 -
 arch/powerpc/mm/fault.c       |   7 +-
 arch/riscv/mm/fault.c         |   6 +-
 arch/s390/mm/fault.c          |   6 +-
 arch/sh/mm/fault.c            |   4 -
 arch/sparc/mm/fault_32.c      |   4 -
 arch/sparc/mm/fault_64.c      |   5 -
 arch/um/kernel/trap.c         |   4 -
 arch/x86/mm/fault.c           |  18 ++--
 arch/xtensa/mm/fault.c        |   4 -
 include/linux/mm.h            |   2 -
 include/linux/mm_types.h      |  21 ++--
 include/linux/pagemap.h       |   8 +-
 mm/filemap.c                  | 174 ++++++++++------------------------
 mm/gup.c                      |  41 +-------
 mm/internal.h                 |   7 +-
 mm/memory.c                   |  25 ++---
 mm/shmem.c                    |   2 +-
 mm/userfaultfd.c              |  20 ++--
 32 files changed, 90 insertions(+), 331 deletions(-)

-- 
2.47.3


