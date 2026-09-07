Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D5FC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEFC6B009E; Mon,  7 Sep 2026 06:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F426B009F; Mon,  7 Sep 2026 06:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DFE6B00A0; Mon,  7 Sep 2026 06:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A979C6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A795C06D1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:23:55 +0000 (UTC)
X-FDA: 85186580430.18.38E18AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7FDA61C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:23:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W3K/wLkW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QBl4EA0xu6TPR7bo/qzVGPSEuODGi+VrBZaLJjj3jl8=;
	b=ONMDlZLkkW+rttUYPJqpIkHpIUTCIO/5OIi3S5Y0+OafFLE80kDhYVku3Owcr/qQU8b4RK
	pluwoHnrlw0IRNfFqsAXJbl1+6iN3umwF+k4oD17MleIK6+Zspe8G83Vm/pK6dDHQZOZBG
	j8t1Tocch6pbhd+zdpSQnAT0tvLcq3o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W3K/wLkW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776633;
	b=QFggfDuRH+pqrrD4NA1t9sEJtpqd/o+kdFSDo1rqHn8ow+CPlAMcpCVQJX7O8vzMX3fD8C
	UeND0AeSeapTIuXllEqgo5I3rGzoy31R+51vsP7f5xrPjoFomsHDvnJFjy9dO+ibfG3dAd
	H8bglTBAGtAXd7PMgpvWVAA5vm5L1kI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5D49436F6;
	Mon,  7 Sep 2026 10:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8631F00A3E;
	Mon,  7 Sep 2026 10:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776632;
	bh=QBl4EA0xu6TPR7bo/qzVGPSEuODGi+VrBZaLJjj3jl8=;
	h=From:Subject:Date:To:Cc;
	b=W3K/wLkWX6CuLvlwKhn0U4ZI+2bfSag8owmRUSS2l3C9lstfTM1Sfn0T2ncJCgU6J
	 S0EkLOlgCjZQBUiu3f+Lek67z0vBdvPdze/Xni/fOUSI72mlaW1NQyiuPg2/qJocav
	 EWWl6qkc01U3JcOk8fowht2ZHXeZSgXZEmqoXYfGtTui6FIs8Zwcs8DFh8sdgHo+It
	 1Wo9Q3wbcU99rGLPdrWqL/9QEx0FqTuk6yNTKuFuoEBW7Q7zq9ubdPnDdxVmutDYBT
	 i3COGAB7YhhUwquaROAmQWRS3C0/o0Rtf+EAFOE17+/s0ogpHf72iK2IXEysqtlQeS
	 wrvNlk1e3LGkQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
Date: Mon, 07 Sep 2026 13:23:41 +0300
Message-Id: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSw7CMAwE0KtUXmOUD2paroJYJKlDwyJFNiBQ1
 buTlOUbzcwKQpxJ4NytwPTOkpdSoQ8dxNmXG2GeqsEo06tRORQ7Kox5QSY/fVEP5GxKQ38yCer
 owZTyZz+8XP+WV7hTfLaX1gheCAP7EucW7XRHixw1bNsP2whiIZEAAAA=
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uck869adnngu9dypcguh1hmqbgjhkpj4
X-Rspamd-Queue-Id: 7FDA61C0003
X-HE-Tag: 1788776633-649029
X-HE-Meta: U2FsdGVkX1944CqJsR5/LmDaW2ped6X6VNGZ7CscVahn55cHqJlVGIGBUPtg44V7tvzYiMYcTP0niUKZ0taTHNSM31asDLSF9dBHOqAe3b0RmxeyP3/hk0moFooeDV6Ya31c7ozci00//W9e4weFagBZaShpX1IUtkgouVcueuTPiihRYh6j+X13j2mYf0tnS/3wHduvkiakXv0VSwCjGWn7quvyYC2IQG/HPlFUa0QWs0werm5LPMChTJUYIS14PVYpJ76EyFoaj5Hjwqv1udoETOBR1vUzAoQTXAgksqxKF/OSdPRPC233pznc1cvwFqIUFlrsBigFcoa/rBjaeY5WW5T9d8WlGfWiQPd5yK7TWhw6vdWavanaGc0tYuMgAeSZQ7ZZGSMGjWP1m7Iv5CB5wle6wYYH/qeceeW4OAStz68dFMcivQ+eINOTqCT9GOGHNmH9D47dVbBHUJ+l56WrKW7Noao239tzxHdFYk2iy1cnndH0Uo2LnxdF56bj8GqKLU5EHLKufj6ZK/3X+WSRlW2GY4CI7MYztCFKCbHVGSitnqMQaBWcsOgfSz1RiPB2q2d/fG/z4Xs2TiIaI4hafpYtwX8qNF0TG7xyzvPrAxl0E78F7cqnslL1J09EbtZb+ek2zbAG4y/D2TmI5jMQ7u0I6Q+nmhgOTctFHT+y8Z+kKM4tFOi9wzxyawEnU4rlFg3XzoO/eyZUxqo96sL+ugjQn78jCNFK6VcfEPaCz4Y8M2Ko7t7Nf36B2v2SiX2uXDWGgEmMa3yMy6bEeb/odPnaKQQ/FOxFuIfzHA4GklrzFuiGvHYXx7q9it+TPovvkrTmLykaQU8T1mvm8iq3VW4mnXdBRS+ljkmt2z54ZNjG73ArumtDGjHABlye7kqDo/2ZZSrinnbUZ6OAQuuMwOC+LNRzrzPRGwFX802bXWgPJOOmV9ctcjUCgxdioWpOgJNZekQFDYTePM3
 xCjpvgD3
 r55WRB3qT/1+biVYh+VVsmZ3cUG5Tyxj/ikOHGQCI0rFaTNikT71vDnJggmUJRC2KFypNPahk50EFxhLhOBFfvuGi3JkHQ/3I4hulec71xCEnCBvUv04K3g+MPQymGnMMKPNGrRpuCHwvK9RmC4rG2UuKYf6/obYNzmMMXimeHzj6N5L/BMI6NbI5kkwcokYshLJWu7OW5IRNBVVRiyo6cdYinRkqBoU7/KCDshxyafM/46T72+GgaKfZG/OoJtq3SUxoIwENwoQ2axo=
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

 arch/s390/include/asm/idals.h   |   6 +-
 drivers/s390/cio/chsc.c         |  20 +--
 drivers/s390/cio/chsc_sch.c     | 300 ++++++++++++++--------------------------
 drivers/s390/cio/cmf.c          |   8 +-
 drivers/s390/cio/qdio.h         |   2 +-
 drivers/s390/cio/qdio_main.c    |  19 +--
 drivers/s390/cio/qdio_setup.c   |  14 +-
 drivers/s390/cio/qdio_thinint.c |   2 +-
 drivers/s390/cio/scm.c          |   7 +-
 9 files changed, 144 insertions(+), 234 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260907-s390-cio-ready-18e73ff8642f

--
Sincerely yours,
Mike.


