Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F54E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94156B0088; Mon,  9 Feb 2026 17:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41C56B0089; Mon,  9 Feb 2026 17:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E246B008A; Mon,  9 Feb 2026 17:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFB0D6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67D471A02F8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:50 +0000 (UTC)
X-FDA: 84426323940.10.A2454BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5545E14000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6uSZsIF;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NfzhOy6xg1VuRqICbaMNurwJEWL8Ja4JqB6dHNFVjfc=;
	b=f6YWJIzsPyajOhRU0C9RqwVTkSv8p8rzJ126Iae3TOj1RZim5+ThGUHqKaiMF5rdJzageV
	xCM6RZYlcgX1mGOAl81+tBMSUHhG3o6Mh+QZ3lR+DlFcYlJd/S/AZjULy1jpYtKBoe/s+w
	+0OoXNlTx9ITRdPdlKgUibajDsTW+vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675288; a=rsa-sha256;
	cv=none;
	b=dF8m4gQJJ4RPo3pL43uyxHeE0mQcmJJdqdhB91y2s9JmtWl9Aj1Ss7bnBHkaC6wEZDj9+1
	tP/y9knXP1f8D6O3mbzhqts9UoBALwCkyvogTlSg14UJV8UPGVWwEFDYbJzZtw82lwNmBT
	G38Rzwmi4998k0RBRBbn2U01+WA1mIU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6uSZsIF;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NfzhOy6xg1VuRqICbaMNurwJEWL8Ja4JqB6dHNFVjfc=;
	b=C6uSZsIFVm1PZrHQ0X15nbMsMjvdDO8Hrv2bTUDfcR33Fvve6qUZVbCEebgbU3esVdgIkP
	hiXMTI4yVnsaaRRKqy4Y7wwgqs1qtnlzsGt82Ny1G8lbiP9yAi/lKhAcYynmfDhrVksEHF
	w1sUPp9EW3w4OKDSBrQtk1VLG702Hkc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-so6k0CXbN9qiupln15RHPw-1; Mon,
 09 Feb 2026 17:14:46 -0500
X-MC-Unique: so6k0CXbN9qiupln15RHPw-1
X-Mimecast-MFC-AGG-ID: so6k0CXbN9qiupln15RHPw_1770675285
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A28A61800282;
	Mon,  9 Feb 2026 22:14:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 430AB1800464;
	Mon,  9 Feb 2026 22:14:43 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 00/11] mm: thp: always enable mTHP support
Date: Mon,  9 Feb 2026 17:14:22 -0500
Message-ID: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 60PQRyZ5sk3aSxfxGj0weCt-h7uAoxyZENmNmYas9qY_1770675285
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 5545E14000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 61yfzwfu5d8gjkfcsymzm1shu9wcz3yh
X-HE-Tag: 1770675288-251873
X-HE-Meta: U2FsdGVkX1+jXFFos1zWg13i8hJLpqeprLABKXZpl80VI8CtDBL0ToTRwheIuB0cgItOMngFpOrqPMW/go3BQuegDiATge6GPXavVWBT0jWwgC+qTiH0LpZg1JJ6y7psQSoUsOswrndrIjlCmCJKYq5FjLcQ3YOwlHgxSJSJK6XGcLtUH9buhVpaKQ1Hd4LSAYDavSkjXm49839cL58sibni1sHMSR2JP0v646RdyqSpVGUEgNkjwPMxoZPBL8eLH+bbXmj+SkgDLjeUPilsN2id/w1bzMpYYtxo7iDQZGC0XvjzW1F/zjNqajVrQDtMZFMEo19yBOLnp9YEC6wb0ms1lcRnV7NPlMLUIAc4tp3mjNDdZBVQ82y7KRVq3zZXBcG5XmanPO5air+Ep8XF7rJJext5b0GpfVmZKC9QkCZzHNWK1GWC0kG9Kbxs3XZ/RF8gMZGwKF8WZs2P/15DZ0Ql7wkEgIcrjZ9B85m2MGwYKywqreZZnJa95GqFpHea8VJVfokGS/a6eDtOZo22//ZfQ8bs/IaEZimP9n9143lJl5LnHbIzel1Xzwh84IBgN6mHQqfrTp0LsSV56I0G4mgvO2J/m/EE1bkcguz0jGbjkktc0ustto8x4VoBy3ywdLH/KuJtW8tjKpLBJd4o1W/qSvhl/4fBmCK97CFtoLkZ87pvrdYYwFhM7QFizxs9mx26K0kpiTpQ4+zSm3pfXWSS16MI2mK9ijdj7TaPPH9Fx4yxaV63Ms/xde7vszK7e0C7y+vKYlBSnmR+ULeSiGu9HfKIIhrOdRpNqk3DR7Vp1w8Rz6qvE94NrlzB+rqT/hnLJXosmVomcrwwt03x7tjZRiT04bO+WAAIxwTie4XPFuFXkcK7BECoUXUxQJEpVED/bREUv5B/sKXPCuORUdpd7EV/BTvzzCaBCHtkrCTc17bdy2dF0hOzIHE9vpmQGqXAjeWfmcqTkvoyNhK
 czUAfNJS
 tEJRHXAPdem9CA+ZXi2wCTubAB9Em3+PiTf7vYpxwQ0J9a0IAQwr7hngcnwWpNk4Z7DlXDxV3BxjHr1UcXVcGN5tap4pgrLmi/ZL75eIb+USA5YBQj+4KK86xzw3CmJ6PaRHThhRQvNp1m9FsvlJF9Za7b175YGuQIkdIamjh0kBfrAgDoVlRn7bowuqR1z0UN5SUQxUkPMf0Hm/dTXCWmkac7HmLaL+N+OhWTfYkGIFFTh2ilRUGw4uNfQoz1F/MQYTYbJ/C0NCEtjcBLuWVhD4Zmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, if an architecture implements has_transparent_hugepage() and the CPU
lacks support for PMD-sized pages, the THP code disables all THP, including
mTHP. In addition, the kernel lacks a well defined API to check for
PMD-sized page support. It currently relies on has_transparent_hugepage()
and thp_disabled_by_hw(), but they are not well defined and are tied to
THP support.

This series addresses both issues by introducing a new well defined API
to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
new helper, we ensure that mTHP remains enabled even when the
architecture or CPU doesn't support PMD-sized pages.

Thanks to David Hildenbrand for suggesting this improvement and for
providing guidance (all bugs and misconceptions are mine).

This applies to v6.19, but I tested it on v6.19-rc8+.

v2
--
- Added support for always enabling mTHPs for shmem (Baolin)
- Improved commits changelog & added reviewed-by

v1
--
- Call init_arch_has_pmd_leaves() from start_kernel()
- Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
- Clear PUD_ORDER when clearing PMD_ORDER (David)
- Small changelog improvements (David)
- Rebased on top of latest mm-new

Luiz Capitulino (11):
  docs: tmpfs: remove implementation detail reference
  mm: introduce pgtable_has_pmd_leaves()
  drivers: dax: use pgtable_has_pmd_leaves()
  drivers: i915 selftest: use pgtable_has_pmd_leaves()
  drivers: nvdimm: use pgtable_has_pmd_leaves()
  mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
  mm: shmem: drop has_transparent_hugepage() usage
  treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
  mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
  mm: thp: always enable mTHP support
  mm: thp: x86: cleanup PSE feature bit usage

 Documentation/filesystems/tmpfs.rst           |  5 ++---
 arch/mips/include/asm/pgtable.h               |  4 ++--
 arch/mips/mm/tlb-r4k.c                        |  4 ++--
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
 arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
 arch/s390/include/asm/pgtable.h               |  4 ++--
 arch/x86/include/asm/pgtable.h                |  6 ------
 arch/x86/include/asm/pgtable_32.h             |  6 ++++++
 drivers/dax/dax-private.h                     |  2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  4 +++-
 drivers/nvdimm/pfn_devs.c                     |  6 ++++--
 include/linux/huge_mm.h                       |  7 -------
 include/linux/pgtable.h                       | 11 ++++++++--
 init/main.c                                   |  1 +
 mm/debug_vm_pgtable.c                         | 20 +++++++++----------
 mm/huge_memory.c                              | 13 ++++++------
 mm/memory.c                                   | 10 +++++++++-
 mm/shmem.c                                    | 11 +++++-----
 21 files changed, 74 insertions(+), 60 deletions(-)

-- 
2.53.0


