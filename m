Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41FD1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D88C6B00AC; Wed, 16 Sep 2026 08:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580566B00AD; Wed, 16 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470356B00AE; Wed, 16 Sep 2026 08:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2408F6B00AC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE5FE16069C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:19 +0000 (UTC)
X-FDA: 85219490118.04.4802EEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93DD418000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ND/rEklH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560197;
	b=RUdu+/pmg/QgsIW9wIFvvALxJ3DbnnkqNIXKBnfY514tOGHaJiJqBmo1knKDC048haeXgy
	sVem/tEo510pI7uQxYdtaeudUeK4gisYbd0IjVWFtMr05Rp0BzFzMx4VAjzY81BoEKQeV+
	j/lf8uQ6sSCBIE4Omfb91veM9/Z55L0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ND/rEklH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KToEPbjMi+xk01qHZe/FhjtSbHLsQ7HONCzklzsUNhs=;
	b=gWvqJyRcclf11FzPbRrnajsKw9pZff5enU6XAYt07aeFPCvdlaFoj17fRC4d0eCoWqxfN4
	DuR2aG8OX4c2J86ZMAykcgfKv/I5wBsnv+s8+Awrsa090f2da4TL24N2fOwMuu7sxnt1pd
	ohAVGWOxY2BYOyBhUERAhhUeiiEFH1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83AE416FB;
	Wed, 16 Sep 2026 12:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026951F00893;
	Wed, 16 Sep 2026 12:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560196;
	bh=KToEPbjMi+xk01qHZe/FhjtSbHLsQ7HONCzklzsUNhs=;
	h=From:Subject:Date:To:Cc;
	b=ND/rEklHl2Y5KZ1IzgzAaYP9CIAexTLWJqNxHuLKje6diN13GeXjL3D/EiGn0xpYE
	 TOQDJISGHjbkKU9tU5PK4+J8F9KV3X8VO1h6GBR/Z1gGyqptjCurxWiwJCcTmTYUDH
	 h2jsKHqpIlERYkM/5+HKRgy4qQ0FhFn3mV4VBn3n8PB8jCVvVzzvUP8p9SzdxOZLGE
	 qAFGjyJ5k9RQnbsSrLDTU8qXUdVhsWWkmJSs86jQaHnSuCr2odrRmlb/oGZs2BEoFH
	 iKfkSN18Xe8d4AdZZJ2IiTR05cX0OEA6JwJD6zAihW3AwRRyGDXpNaWd9e8EMYo1ms
	 056t6ykcqot+g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
Date: Wed, 16 Sep 2026 15:03:07 +0300
Message-Id: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WOyw6CMBBFf8V0bUkfpBRX/odxUcoUqoaaKRIJ4
 d9tcaMxLs/MnHtnIRHQQySH3UIQJh99GBLI/Y7Y3gwdUN8mJoIJxWpW0ShrRq0PFMG0M+UaKum
 cVqVwJEl3BOefW+Dp/Ob4aC5gx5ySLxoTgTZoBtvn0YZVISlante9j2PAeXto4jnmb/fEaUJTO
 VlrpoQsj1fAAW5FwI7k8kl8+Jz9+CL5UEvOtHJtC/zLX9f1Bem3PJseAQAA
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
X-Rspamd-Queue-Id: 93DD418000E
X-Stat-Signature: pizapew4j1pwxwowdxqkf45koi4c7zju
X-HE-Tag: 1789560197-359691
X-HE-Meta: U2FsdGVkX1/IatLcTj7CTSr5NIdL6DXNiXXUi0detw860SZa40nQIjoQ5HCMGCFbIIsxeujK1cddLTv5Zy8i0CwS878236KKaHZAfcq90aQYnoCU64LPV/4usXqu/WZEqrYHELOfH7qwlNwY0LOpy4n6VtvZ+NUM0L96VRxLrEQQ/HinPm0pFkDZNo3QFlKYK94dwu4ezlYe8B+e6EnYUv4gsyLu/c3cYXR88LoBojj2YFwGSqg2TEC80FxhL8L74zrmA/TYSGyvkGOjM9bS9tw7LM2mabLW7yrivSULiRO1Y3+e/kRsJiZRlV3jKF5GpbqZ9SY9ex7/MBMTo6gbi4wpLxIXMO9fTjoDNLliPj494w1+gyklZVtfj2tIgnGDOXFLolrjsJJyFcz0NvgGkGbgyRk0BSDuxFQEGSAIWZUW7hzcV7XFbdAIGIAaQPWoxis8G+sBybr6rdqiU39tiQ2A2dXPmu5ONjxCzAHvSe92675xau/v61rs11DJMv2MVigZzAoVt/kmw8atZtq2T+GfaX22jf5ZNUHJd1BGgbX9ZDMO6hxW4NlGwkTgJ9eFK80ZoPcSQeJSR3WMN9W0GFQlKc0Q+590zGA28gO74D5aNHZGo6JbG0LPsKNeGzdq1Mu5ZWtPNbRQYpIJ90Xk0F2fqkhNmpZoq1kQ1w6JL84tisDkXGqWkdybFoQDj7E9V7JfieCZ/1PR4hIKSEtkAyFAvzGGuL8ob4BXKbV5jUsGrxj/QOhSHPPwvLsKVPUT9TS0ptBoEuW5Wy1T/07BeqPLBMWAQN3h8Rysncd9tv8F9LIbbYqstKPU0uYds3bd/3C57Pb5cPX/o7OFK7/HegBkY+ZmAyzXwl2PejWKQkPN5PQEgBWEbVdOhEVpLTFSwvfjPXojkcPkJmNJkDcRCdthdGArRRPW/Crd1LlIMMs8iRxxEXb/rwF/3rpPIS6TbMgn5A2yCLWF3EmNmEt
 FkV4r5n/
 v8ZHgT9oacYOGMGuAnpMPrBjtwo0DQ5S+dbwXIBS+WQl9cJ9hrLxeY/2aR8EL/YU/DVOpzdUB1ujRXzEhTF1j7xkCGXlljSUEVyksBGzRaLfYExKgLhBpiUiM09Qirdzvjh3wHEB/WigJc+u83Qhib8OOIssTXxWRiBQaEbgOb30j8rNacmXq2xEJ2qg2b+xSmoWtZ9kEnHwVF5A48AIIFd4YChGKXAmVw7g80KuSUWx1TgY4eozouN4K1A86VYx93P/8kOYjx7W9EaU2UIgHpnOLL5yBKepEsCJAefbvCdFy0ddSSOgf5hnlMFdQ3unjb1oWIvtqZ95UeclSt/rvOm0KTwd2kUCEyfar
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
v3 changes:
* fix accidental flips from non-zeroing allocations to zeroing ones.

v2: https://patch.msgid.link/20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org
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
      s390/qdio_setup: Use kmalloc() for the storage list
      s390/qdio_setup: Use kmalloc() for the SSQD request
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


