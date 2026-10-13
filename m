Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F16FCA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136316B0088; Mon, 12 Oct 2026 20:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9086B008C; Mon, 12 Oct 2026 20:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2456B0092; Mon, 12 Oct 2026 20:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8EA06B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:27:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EF61C0A37
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:09 +0000 (UTC)
X-FDA: 85315713378.22.CC6EA45
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF2A240003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791851227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=aeEPTF3SCZ04Ut143b3Xo/e8TM73bUBsS+PGp7LGkGE=;
	b=jkBo0qj9ooOII97zBNJngEm14utTrC4yySWUZXf1T0pd3Lfk+OQcHRf62AePmNjqRz1Mbv
	9fnpFJXF25DES+3JivdBhfvruuJMQLCl1LqMGvhK0+Kcl5A/X2gBdt7OzhQM2eX2f1YzQE
	Rl/oux7pew10JytaXcRn3QQYNxZYYT4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791851227;
	b=mneklmnfvEan+wsVbwHUXJgaN2vjfrDl7VeHmh11CT/gTbjYSLQLzEuDbnJWddxer9La1U
	otiYr/wBklvILs3tV47b7hXkV5+kCsPcSDdvXFqmjWOEe/qRj8NbioLb3Vxbz0sFfyBZjj
	Lx+Js6BF27j2aJyGGcckO0u4aypQksY=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGQMC-00GgqH-3E;
	Mon, 12 Oct 2026 20:27:04 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 0/3] ida: fix the allocation failure paths of ida_alloc_range()
Date: Mon, 12 Oct 2026 20:27:00 -0400
Message-ID: <20261013002703.773923-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF2A240003
X-Rspam-User: 
X-Stat-Signature: pu9rkdybktnoyyqor1e5qbx315w7pm44
X-HE-Tag: 1791851227-619440
X-HE-Meta: U2FsdGVkX19epIZWmUC5bX86IGjrjyh9XqoK9tJdBk2Z0MyChaY1lxWGril0TqwHAEccASPHHM9mtI4K4fBIXsdC+Mg71nAeO8Vn9HW8OZHVlaWliUqFFiFcERZDzgOwnJZus4blf31SgeSWA70FcZXU4HkPE33H4/gwdpACPtzttpPUN0/abPgCEKbJieMQl6eUYhPGDJRVvXCHZX3TE9hzP2CgXYwTy7jNhrJit2b8I+LM9FlAx3XRJrdpUpe4v41p+ckt9xDlt8bxwv+b54im0DN49bcTKbNhyGCm6v9G/dkhH4JgrNywPh0fE2CMSoHCEMdC6aTjjEF9iOVx9nXcjky/Z/P1o1R+5NUOoZcFPmr0xgXhyFpPOA7f7vcW6Me1K6UKMCBX6NhBoo6gODXQw3UHOZMFWxQ9La+ayTFQ/5SsCeDkLg7qm6W27HB0FT3KRYtEmwynjhaT8yAgAhD/3AbmEU780IzH24F8FDiypGIz3/rPjD/eECeZLmB83xWdg8OCFenBWQvxb8tUMZoQHJqwDmu33vpkfcUxhLdhAeK8LF4R6H7rlxioYBprPRqnpZhb77VVkJ8aKpPoSL0d/Ykl3hKLPp4rxRejXX6Bf0KoeZz6CpOHtn8GcSYYHsz0ZNrEDRecjxK1w+EAQ6lFrvKbAF/vZN6LLwylAbuwejWiL1W3McZKu21vN+FEnjKybH5JPK1wGB8lnIa8Kx6m4s+Qt4tYCk4wNr3CBpgiY6tQHEL9EdKjVvJZS5V3gYdf6wARdTDs+W4JWzxla//xFhov1debyjJ+qC8zBAr86EpBO8aCpPsdPLYVwbm231nFHyz3vq9cgp0pkPrfI6IIOVeonrLsjqtQ/wesBBuQtR6MU8ugrtgB5o1fo7TOth6EvNGlwylXYkaid0p8e4SUDrw7HBasjg/7BQM97w1cyzbW5h7jv54GACfpVk63OoClrUL/obPijfhb68n
 RqvB6/Ey
 IalRkYqU9NPZMBdCfKCmCbx8bmSomm+8xVbNzOt/z6U45/El785FKN3K9Z2JNwy770cl1EFHZrunhE9INDrTim2O1dVI0wY4vVaWRwV172IbJV3Z6l1YWvVs1mDelTG1ElI+b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These three patches fix what ida_alloc_range() does when its xas_store()
fails for want of a node, found while formally verifying the function
against the kernel binary, where its resource accounting could not be
established against the code as it is.

Patch 1: the bit set in a new bitmap before the failed store is not
cleared again, so a retry can store an ID that nobody owns (exact-ID
callers then get -ENOSPC for a free ID, and the chunk's bitmap can never
be freed).  Patch 2: the bitmap of the failed store is leaked, on the
-ENOMEM return and on a successful retry.  Patch 3: the node
preallocated by xas_nomem() is leaked on the "nospc:" exit and on the
-ENOMEM return at "alloc:".  These need an allocation failure under
memory pressure and, for two of them, a concurrent allocation on the
same IDA; they affect every ida_alloc_*() user, so they are tagged for
stable.

Patches 1 and 3 add tests to tools/testing/radix-tree/idr-test.c which
use the node cache callback of the user-space harness to run a second
allocation in the window where xas_nomem() has dropped the lock; they
fail without their fix.  The leaks of patch 2 cannot be reached in the
harness (it cannot fail a GFP_KERNEL node allocation or let a
GFP_NOWAIT kmalloc() succeed) and were reproduced with a user-space
copy of the function with fault injection at its four allocation sites.
The complete lib/test_ida.c suite and idr-test pass at XA_CHUNK_SHIFT 3
and 6, and in x86_64 and RISC-V defconfig kernels with CONFIG_TEST_IDA=y
booted under QEMU; lib/idr.o builds without warnings with W=1 and C=1
(sparse) on both architectures.

Nickolai Zeldovich (3):
  ida: clear the bit of a bitmap that ida_alloc_range() failed to store
  ida: free the bitmaps that ida_alloc_range() fails to store
  ida: free the preallocated node on the ida_alloc_range() failure paths

 lib/idr.c                           | 16 ++++--
 tools/testing/radix-tree/idr-test.c | 77 +++++++++++++++++++++++++++++
 tools/testing/radix-tree/test.h     |  4 ++
 3 files changed, 94 insertions(+), 3 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


