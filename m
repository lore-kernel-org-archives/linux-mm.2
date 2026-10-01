Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8E5CA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24956B0088; Wed, 30 Sep 2026 20:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5616B008A; Wed, 30 Sep 2026 20:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3BE6B008C; Wed, 30 Sep 2026 20:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9BF6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8D25A6555
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:43 +0000 (UTC)
X-FDA: 85272244806.17.50E621A
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BD72140003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=frKyz7j5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3BLC9aggKCLcpheXtXgXdlldib.Zljifkru-jjhsXZh.lod@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3BLC9aggKCLcpheXtXgXdlldib.Zljifkru-jjhsXZh.lod@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TW/ACrzYYeMrBy3s3tjiEB934xbUSaPMMU4ABKPrx40=;
	b=4I9CkAJkieVjUWQPoLxB7f99xbBf7Kn64g1BN/8jv4dJJtIjplpaz55pd0BEN7UiTRS6K2
	xIFIreXOGdeca2mn4wDPgf2fKXpRNrVAk5hka78Hbo7130Y6Jw4xFxSJdVf0hKI/w1T/Hl
	JNkfUJT3Cm4vODoyjOBCPK89jKH4Tl8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=frKyz7j5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3BLC9aggKCLcpheXtXgXdlldib.Zljifkru-jjhsXZh.lod@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3BLC9aggKCLcpheXtXgXdlldib.Zljifkru-jjhsXZh.lod@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816262;
	b=5ZdKY5DRAQ5lDQZImSOsVnW7xwq/kzAHcdE9j0EaRMyC/RK59zTdn6nPnMHHpA5HlXwph8
	cpv64jrhdAcpIvANdzT5+HacSpH5Cmi9Xidtyzru+fV5r0sQCYYNZJ1FK5l5Ubwd/KPhbv
	2Oq0asf2JoZiriprPyq8H6oYy4JOSPQ=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2dc7337e2a7so57942385ad.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816261; x=1791421061; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TW/ACrzYYeMrBy3s3tjiEB934xbUSaPMMU4ABKPrx40=;
        b=frKyz7j5WbbaipPKCO1qz6y59C3NT4gOerBmV636X1vAC+yt0pVEmRnkLvtjPG0sik
         TyAX2UmIiAhtBM0x5susN+ooUfNkwX+HcoECCpWih4MTFqE/9GI+VFX1N/pwMGwywes1
         0CPynUUeKOeYj4ofB7G3dVsVDlZVCe+a8spqIVjBB3ByDLLwhT+MiPNZsQz38VWn6qmW
         4ih6qg1jp+iiCLdDZzpHH85tsaVWwmgvetQ+NvDbmXwZyZiH2HRgaJ3G4YQp+1qf4Xti
         72bEzesHxobbNfgUt7QSjQJAlZkbm8TL8yThn+ZBV0MkcfGZZfMvw/Z81W2MmoJ+lwhG
         9GNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816261; x=1791421061;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TW/ACrzYYeMrBy3s3tjiEB934xbUSaPMMU4ABKPrx40=;
        b=N1G7Is+JKPNEpD1EGFSFPrljZ/dMCC329a+WgHTPfi0yIZfM3xGLVyO/xep8qZrj+C
         ixkFgzWNfctJ/A8mrXE+tICPCODS2IGBrz1q+fDHriR0iZbla3GQc7fyAiEo9ge36ZDY
         9Kq4/khMJrsoZJcbFuhaowQ8H+tLEcW60aSiUhxv+tOrUEFC/vowEHHjD0ETR6+c8ILQ
         qaK/jTe5fgCkH3ORf8kZ8hnvwBJcl36LlbV1b+pjTPJT+HVoloz0Vu7bOB9TxP/eR2hS
         33V33X3vAy9bfMH9jnYKWzVmUZVaDZcA3FR6FEiLc/Vz+0+Po1s4cABMQfHzWZZdsRSO
         NUoQ==
X-Forwarded-Encrypted: i=1; AKwUvBy47TES+1fsdPEdQSPL65+CoMHeMRypDeSIurPGyYGHVqzNeokEt8f/VgdmsdpxLuwEIYwoDLCJ0A==@kvack.org
X-Gm-Message-State: AFq9FYIZQcRvamidy8/l/zxYBp3HNkXqD/nBiUKNPD5DYDcCjm/XvQNU
	I2dmeI4Tt8BupO6D4SKiDylsUpeWpDT/OJMKHvcOMmcjaxbau3OLFQRU+c4KYLl2M3M03c8vBro
	spEwA8Dqn/Gqu+g==
X-Received: from plao6.prod.google.com ([2002:a17:903:3006:b0:2e2:c7fc:344f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2c8b:b0:2df:81d0:7c40 with SMTP id d9443c01a7336-2e2e4b97af6mr19847055ad.55.1790816260459;
 Wed, 30 Sep 2026 17:57:40 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-1-skhawaja@google.com>
Subject: [RFC PATCH 0/6] Introduce file handler dependency level
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0BD72140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qjm6prrq6ysr6oimaw8xzm8wy9xmuzsu
X-HE-Tag: 1790816261-167916
X-HE-Meta: U2FsdGVkX1/IIdYkzhY/lG4qEEYoFfqnNI3alR7SjYSgQuaWlvPcXzYPUWhzGf+WY1U77rj+JNmchqt4zcpWErtZPQ5qYvYwp4Qu5aFLX0vabrNS+eU1Z1NeqyGI09O/xzvWRbg0BsL/jKbEnlonP1I/ksQL+OoOGHud+nQE1J46FvNprKPSOJ/Cmye7II8LdaefViM6McOiWMwfHq63ubgIvTJLegucPeU3sGGJs+T0mfd1+4AVKmQMRrI4HrzTSGpW2zeAGKCslYvJg0WyPMr3AeAq1/EU9NOdRCWFrqcKZab16hcYqD906kSAaktU3RaibbEhrKRKIMqMocF4bMkjFzSN0jj4IcWaZh2i0HkQRUKs1MHdwe0Bd5RqTxk+yuLhsQZldgyRFWV9GcWwuCyd3fVRQvfP0rRgkby5hXn4fLDEX1iBF8fZEvxuWtiZ8iwqG4K2Jm9wXAWOn3x+gX2cGO9DgTwc2tWUtKqy4Q0F4qa142n2XRAK26U3YOqVEQB6FtCtHSIFd3icsITte0hjkif/H/BIQ9jasHr2ZhZiSKdrDQEFh/uskh0rqHNadnlZWf+QnQBPQkmmhDf7q0o3j3+9NzBVMa6RTvoBgOJ78C3wwM4X9Atg6IZhQaw9hFrHynmauyxgGGrvgrj0p3j7MoD4XcWsYLv4yeIkwoI+oxtSHNwzsN37O64zkyzdYtzosZ21rJMX4OJyB9aHzMQnuLP6fioMo0mScE3L83XRrJwoXnZn05QQvMXoXcnGjtuPiCF68rpUdJKIFffztduaNYiOB/W/cEF+8g2MrPkpWzE5EZBe+rjztfRW4BV8JZVQhyltOMD96AqKODF0K0lFbxVDo7YLWkegyIlqQSE39+4fznTsFSDcmUwbN3f9Ol3PV32oWmQM39ZgrWa1sXcYRjovczN2JIv9odS99HeadaAqHxgDotfUNhEBYjamAmRgtl8rg7DnpYwnrif
 Da0uTlvM
 cVjOSYyY1oI2bXxUn5FjvgqtVBo3emm9yWq0umdaCrcHvwLSz4+ZaE2pyd2EDNHUtRthnDdM7duJdp3KWNYLkrTXAGV6BF2dXpp060Pdbzjpb58JqLTariOD82wXFWehbQojXb/Wis6FuJV4fDka2jmv8gSLdS7uFLt06zEm080MM0ECGtn5miRga7WabjyF7NvCLGWma5dExmMHJs7JqUZ0GTvR1Uve+mnIhPJOjdxN+E+VWH4kAVI6ftaCExqenRsCmLF7ok+tKRkj00hwthCAzT97n4qHfsIJO5bFm0EdsOm+TvtDELFjxv4VYuZSieRgLnIyio4P3MSKWnsDKyR8mBVDDC5DFJ8ABDlCesTfAnrld3qm5c5RHmNP6E2d6R7rfzl6xtcrnfWFBkEX/mgYrWlvwIMj02xg7fdJaO7K+w9iHDmLJKOZSCBDPTJfTNrC1oaa9oGPDQMpJfnK3XaMmEEMpDwW2uUDXsWAgYwvobrn/jFzjrNbyY/RCI4IrrR3DIvNBa+rADiXyXk7zpsTPVEzuB1drv0PrEb12bMO314F7exrMzgrABI7IiuyKxBCYPXgH9edHBL8R6F16vp+17UZWMSypocnPO8lS3ohN1pJ5K/ts23+Ii7YfExUk7xk/cYDjMk062RI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LUO allows preservation of FDs into sessions. An FD can depend on other
FDs, and for some FDs this can mean the dependency must be preserved
before it due to various reasons including immutability and performance.
See discussion on FD dependency patch series [1] and documentation [2]
for details. Also see the Liveupdate IOMMU [3] and guest_memfd
preservation [4] patch series for examples. These dependencies are
enforced by the file handlers, and userspace is responsible for
preserving the FDs in the correct order.

This RFC proposes a mechanism that allows userspace to preserve the FDs
as a batch, and the kernel preserves them in the required order. This
allows the VMM to preserve a bag of FDs without worrying about the
order. A new ioctl is added that allows userspace to provide an array of
FDs and tokens for preservation. This gives the kernel the token and the
intent to preserve every FD in the batch up front.

This RFC introduces the concept of file handler levels. Each file
handler offers a certain type of resource or functionality that relates
to other file handlers. These can be represented by levels. This RFC
adds the following levels and more can be added later:

 - Default (no level set)
 - Memory Providers
 - Memory Mappers (or users)
 - Devices

The levels are optional static configurations of how the file handlers
relate to each other. Each level represents a class of file handler,
which fixes the order of preservation between them.

The levels are spaced out to allow addition of new levels. LUO can use
these levels to deduce the order of preservation of a batch of FDs.

The batch is atomic: either all FDs are preserved or none are, and on
failure the index of the failing FD is returned to userspace. The
existing LIVEUPDATE_SESSION_PRESERVE_FD ioctl is unchanged and behaves
as a batch of one. Note that this does not break compatibility and
userspace can still attempt to preserve FDs individually using the
existing preservation ioctl.

The patch series builds on top of the Liveupdate IOMMU series [3] to
demonstrate the FD dependency. The full tree, including the
dependencies, is available at:
https://github.com/samikhawaja/linux/tree/luo/fd-dependency-rfc

I will present this at the Live Update MC at LPC 2026. I will also talk
about alternative solutions I considered.

Future work:

 - Allow file handlers to be preserved at multiple levels to allow
   resolving circular dependencies.

Looking forward to your feedback on this.

[1] https://lore.kernel.org/all/alrDpAMknlYN9jL9@google.com/#t
[2] https://lore.kernel.org/all/20260910173659.1945246-2-skhawaja@google.com/
[3] https://lore.kernel.org/all/20260921004834.2601285-1-skhawaja@google.com/
[4] https://lore.kernel.org/all/20260728121138.1103610-9-tarunsahu@google.com/

Samiullah Khawaja (6):
  liveupdate: Introduce file handler dependency level
  mm/memfd_luo: Set Liveupdate level of a memfd file handler
  iommufd: Set liveupdate file handler level
  vfio/pci: Set live update file handler level
  selftests/liveupdate: Add API to preserve a batch of FDs
  iommufd/selftests: Preserve all the FDs in a batch

 drivers/iommu/iommufd/liveupdate.c            |   1 +
 drivers/vfio/pci/vfio_pci_liveupdate.c        |   1 +
 include/linux/liveupdate.h                    |  24 ++
 include/uapi/linux/liveupdate.h               |  39 +++
 kernel/liveupdate/luo_file.c                  | 316 ++++++++++++------
 kernel/liveupdate/luo_internal.h              |   2 +
 kernel/liveupdate/luo_session.c               |  45 +++
 mm/memfd_luo.c                                |   1 +
 .../iommu/iommufd_liveupdate_kexec_test.c     |  27 +-
 .../liveupdate/lib/include/libliveupdate.h    |   2 +
 .../selftests/liveupdate/lib/lu_utils.c       |  20 ++
 11 files changed, 379 insertions(+), 99 deletions(-)


base-commit: 945d61765894dda2f0344de50cb1ade2e51b66fd
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


