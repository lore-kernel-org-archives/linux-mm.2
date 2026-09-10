Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E82EC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264646B009D; Thu, 10 Sep 2026 07:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AF56B009E; Thu, 10 Sep 2026 07:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BDA6B009F; Thu, 10 Sep 2026 07:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0EEC6B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 757EFA4E03
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:12 +0000 (UTC)
X-FDA: 85197558264.14.A15F4B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B2C2840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+4g5h2N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038010;
	b=hGNCyKYwYErIwcWCD0h6x6ft5IRQXKat/IJnRwPQtrK7xveuBgPVsec+dPt+6y+gaVtOCY
	P1Yj4XoA0/vo/gDsvPNED0rpuYpdP08W5Xfle64RPJ8Ycorz6D1pRRiUl6q8nlQywdsq1L
	2mWwsPr8wXOTkch+CJHkJhdT2B95tvQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+4g5h2N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dFQw63bj1F/kPxxC9sqt+7gLUa5LGEkiBMoIMmY1uR8=;
	b=J8cYQWKeHDxJ508YEZKYSwO9AC1AbALvT7yLJ9DrIoGxa2OzSRt+o6uKPAReBp1ErKWeJm
	MKtNteJw93j9wJE02H6Vl641qHx7SHhy0Qh7bYgxJbjb/TofYwd9PGAZJ86HY+crBwfAnt
	o9NLmxHQmLU6cF6RNNQKbY6rYpcswZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 027FC4087C;
	Thu, 10 Sep 2026 11:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB3C1F00893;
	Thu, 10 Sep 2026 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038009;
	bh=dFQw63bj1F/kPxxC9sqt+7gLUa5LGEkiBMoIMmY1uR8=;
	h=From:Subject:Date:To:Cc;
	b=S+4g5h2NWFTKw9U3EFXYMboABy/RasNDJ7dRe0fdCFq3Rdq7Z+kPzO+SH5PvxFfp2
	 Sk1Wx2pSLwFDQ+c1VjPfmiSbJmbRB7pYRJ/Koa798p2iawxJzSnNkMx9CXg2aa5eU/
	 bGbX7rmjh5OzR7CsTolHe/luzwOvRkyY2TnRqOb2cIyvoNLQgGR3J0narGVHpnl3WU
	 p58nYT8ERhkN/kwT84oiwqwoN9vTQQdlwiBj/nKQKHcC1PTkbEaBth6m0Ossp47d8I
	 UkTdXZw4sAvrFyGJ5fkZ+mk9dh4R0tE4raHtrxgPaw6Qjb/KQ0XWguZIU75eEfej1B
	 +hzX8r7SbFVDQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
Date: Thu, 10 Sep 2026 14:00:02 +0300
Message-Id: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOyw6CMBBFf8V07ZA+CAVX/odhUcoUqoaaKRIJ4
 d9tce3y3Jk5dzYWkTxGdjltjHDx0YcpgTyfmB3NNCD4PjGTXFa84RqiajhYH4DQ9CuIGrVyrq5
 K6Vg6ehE6/zmEt/bH8d3d0c7Zkjc6ExE6MpMdc3SgLhSQFXk8+jgHWo+HFpE1f7sXAQmNdqqpe
 SVVeX0gTfgsAg2s3ff9C6Oc0mreAAAA
X-Change-ID: 20260907-s390-cio-ready-18e73ff8642f
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2C2840003
X-Stat-Signature: skabsheobuhhbn1xr78h9bstjbn4enad
X-HE-Tag: 1789038010-291847
X-HE-Meta: U2FsdGVkX1+ymY7PybNnSnUkiI5qmKM/g2d+SvcQVOldQNSbliSgswebQhkyf1IxlM2RvIX928yzqsJAE50X81DnWfqbOopliJcg2Ay1MsxWNjVZ6bnj+35qCK0bYJQqhL9o2hba0PSF4ltu2sm/iuamLPK/fr8wnIyAflfPLCX+QIMPE9wdrNFMjRnViq4twIsHGA0sxy58OvRqPFRvYCxczQO7xbGiiF9ffLC6/Ud9MGPGvCsc0KrZzzhiErtiv7SSqe3b5z1qD2eXfNyzYQpxtkHp9Qpz1yYTDmbpH5AYcJxwAJDQqW5AH2JbWhkNBghqfYdDcuI1n8shYFjJrb+VL55vspDSa5mWJnWHQhYxdzVT6KMxAlq3UEOoM8IFxuXc6fv3ajz/Uy06BVXPTpi1LKY8IHHbjfAm3jx1QDH+zlWED85LU5kENy34eMmn4p+ZPHW3cORoFGKRcmT316PtNefsl8clOQRhshJDkQSyth9Qg5WUBz1+7Ql4WVTQ5k4FILHv/fIspEgPxPoSF2BoQ20Ge+8mu5c5E2vf43CpeqbASxg5NePSeGxHLHrpJI53jehw3XkA7MdM/2J+IEttrnrpw8jF97rKh3qYPEIWTI8rTJpYXqM/xvvzO4hIhRRFMxOEJg1NgsZZZRZKAz86U2POmrGX1Qet6snmQYbJTeZUi/M1JwmK/kFS2dp2h9HRZAYjyJxpza6uw+/d/Vr4MlyZ9r6GX7J0wiY2uiWQ67Ix7m6yejywu1/8YCRMbaZmCmb2ESduIlJjeB62Y6HDy2MMlH35EBAGNkDiaTz2vRWlTKqTi8Yes+HUhZqTsiMeaXBKGgEHf57zrqwGJEt0nbyH5Bj7aFvMvmxZKlFLl8VOCAmVqslIeEpkZefOEhSbxzFB4xF+EMYA2kAV1r6Yo3uQOIi7+vD55LOokBhGgyjFF31VG1B5TuTibDnPd4Xd5cOUN6JYUwTs6VB
 1odY7PcG
 NuhGbisS+i35+UIzp2oIubx10j5YbcO69JoodNJC/rN5ERMeIwc5smOzAo8w6QwzKF56li+y1gjLYJx3Ht+HRbZ0z9EzqIeJIXGS2HbH+JUomZzcDgWK7EqBk0obQClbudr9OmEzf0fbzIVA/cfTCs5gzy2gFaV7/KzNhghwCOkKAUhglJvhtXjqlNWdl38RkuqEgojrijNWyg9lZZ5GC2NsfEUGaCyyRBxqgT1FodrmD67LWxoPEvZypo3pZOLQV1whZmHRtF2aN2446P/CeM8WfdFKJo0AkUyUBlQP0QhoyhisTiORqlpSuFMjBcAQvsO1S7iUiNzoDYoUny52vSmdVuPQVMQIT0fMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The saga continues :)

This series covers CIO, QDIO, SCM and IDAL buffer allocations.

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

The patches are grouped by buffer usage and ordered by file or
subsystem. Related CHSC work areas and requests are kept together.

While on it, use __free(kfree) for the SCM information buffer and local
buffers in synchronous CHSC ioctl handlers. The CHSC cleanup is kept in
a separate patch.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-cio

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
v2 changes:
Address sashiko comments:
* Allocate the exact CMB area size and reject invalid channel counts.
  Correct the alignment requirement to 32 bytes.
* Tell kmemleak to ignore IDAL data buffers as only DMA addresses are kept.
* Drop the obsolete kmemleak exemption for the QDIO CCW.

v1: https://patch.msgid.link/20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org

---
Mike Rapoport (Microsoft) (13):
      s390/chsc: Use kzalloc() for CUBs
      s390/chsc: Use kzalloc() for the SEI work area
      s390/chsc_sch: Use kzalloc() for CHSC requests
      s390/chsc_sch: Use __free(kfree) for synchronous CHSC requests
      s390/cio: Use kzalloc() for CHSC work areas
      s390/cmf: Use kmalloc() for the CMB area
      s390/idals: Use kmalloc() for IDAL data buffers
      s390/qdio_main: Use kzalloc() for the IRQ structure
      s390/qdio_main: Use kzalloc() for the QDR
      s390/qdio_setup: Use kzalloc() for QDIO buffers
      s390/qdio_setup: Use kzalloc() for the storage list
      s390/qdio_setup: Use kzalloc() for the SSQD request
      s390/scm: Use kmalloc() for SCM information

 arch/s390/include/asm/idals.h   |   9 +-
 drivers/s390/cio/chsc.c         |  20 +--
 drivers/s390/cio/chsc_sch.c     | 300 ++++++++++++++--------------------------
 drivers/s390/cio/cmf.c          |  11 +-
 drivers/s390/cio/qdio.h         |   2 +-
 drivers/s390/cio/qdio_main.c    |  23 ++-
 drivers/s390/cio/qdio_setup.c   |  14 +-
 drivers/s390/cio/qdio_thinint.c |   2 +-
 drivers/s390/cio/scm.c          |   7 +-
 9 files changed, 150 insertions(+), 238 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260907-s390-cio-ready-18e73ff8642f

--
Sincerely yours,
Mike.


