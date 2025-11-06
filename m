Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C4ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664E68E0003; Thu,  6 Nov 2025 16:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615598E0002; Thu,  6 Nov 2025 16:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B588E0003; Thu,  6 Nov 2025 16:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42BB38E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6B37B7A54
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:22 +0000 (UTC)
X-FDA: 84081473364.03.D52EC38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A7CD40012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EB4I/SS2";
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bfwhX0idL+jcT4fehCnbdNH5+2W0J91n2IFBGm3eZ6c=;
	b=KY+nb/qD4VWFNC9K13N96bD0HNX7HEJamZFtACtPfDJXtbuVgqaCOk3ICpP6OYrB18pvtC
	MBVKvgJXIj12nIEePYpqTjZZQSNiTZSkdSA1uOFaA4F8U8sAX50v/pbQu5D2qzXvxkuRHA
	6kpFBP0K2v74r0WcFz9rjfV+y9rt9A8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="EB4I/SS2";
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464561; a=rsa-sha256;
	cv=none;
	b=pIc82pbBVVG5SG7Sy2odrsoMWcVW7MChIIgoV9bihT8PtWKWFsLd2ZHheLPAMMnG5ixysN
	dcinrWydmAeDrZQzfMg3E5Eyl9LnNtyWipY+/5TafJ2/DJPwrCXe0GztyPpvW8ujhRyEQX
	w1u31QBBJETwgMqgoblZJ4NxiqJh8v4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bfwhX0idL+jcT4fehCnbdNH5+2W0J91n2IFBGm3eZ6c=;
	b=EB4I/SS2HQOHNlA6VzIfesqrhMk7WHiqMgi/daeESRsG1Imi+/iCFIivoQMoKj03OkG8+w
	oAgLSrOnes430o2/5KeD75Z9l+7Y+pj+wBc8ABSA7oyJHbjEPZHSxvfNtrGO0uoV2WyHm2
	Rf/F6iUyoc3+tOn60CHp+KIAdok79jM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-iBqmsrqeMyW0bHI0o7um3Q-1; Thu,
 06 Nov 2025 16:29:16 -0500
X-MC-Unique: iBqmsrqeMyW0bHI0o7um3Q-1
X-Mimecast-MFC-AGG-ID: iBqmsrqeMyW0bHI0o7um3Q_1762464555
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4A801956063;
	Thu,  6 Nov 2025 21:29:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F25819560A7;
	Thu,  6 Nov 2025 21:29:13 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 00/10] mm: thp: always enable mTHP support
Date: Thu,  6 Nov 2025 16:28:47 -0500
Message-ID: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A7CD40012
X-Stat-Signature: oiw7w64bn9ypqzui4b75xtzredwbe7eh
X-Rspam-User: 
X-HE-Tag: 1762464560-334036
X-HE-Meta: U2FsdGVkX1/whO0Lk+iYG9lzOK90a9f849gkhqeqAON0WiJpInu/cHlcORxLr5+HgzefYj22ELutqJUoqHfAzUbn9zGn9fWOhALzSuMqc2YMNRo2ZrP67NfgCAZI0YhDxza0JUQ+F+UsJaIoUec3sNyfMGFD1Fl34KLPZTESsb8WaAFu3i7BjhprBWKLkJaxuAp2EaLFtKxYqp8T9yyFan4Vrs3dAKlATKPvz37jtftYMlVUmM28TZSNN7smX4iplvhJ3L0Gynd4KrnZECszdHstqRcZPcInS1SXCKyET7fPNoSfqkqHee2+L+8keAzSexbi1M4Ws5AFtnE3PtAKTEM1eDawAxgWPgT5hVjjVykpu3l+YN93mHSROWzlXWk7h0F3SCEsSFwiIPlnPBjUJNFna9/iCQbTqos5KhT9AfW3588wgiXWrRgioklHwAEw3UnKA+4cqF1n0uefFsePH6V7SkpmLJ3fDfXh2quS0HIxzjI/rcBbp3JPSru6Vk5rFt9TJ4M2yajFpCnlUWIjsG5GdBrjdrEZZjmxXRzNOPpxT3THHfwFh2xRT5GG7FaWLqvlthHwAZlflqIJ/3P8ouaTeIA7QG9DR8UymDdiVwMRzu31wkFwiGaPsuPQyHDMAG3+2DlnKPSKevo0C+mKiXgxmrAHQZgrCyUayD8woJS9QehhtOzmtQsgo8sgy4TiOMaggKSg59evRc5KrOVTa9wRgMC3bHuDzpeKa8oqLkXqploX3fCa9X/H9r6h1CZ4TCpUinxbc1BSX/IIE3GSM2skzJa6nZXdyf25WmPSdBuZea1LwBaKRC8D5DtV4YV40dByVjzn07NuNfTtaBgHH4OVCNwdevilduUY8u8oPoq4sb7lkDXLlXoKi573rReTVzxFepS+XgW2ziD7Frp6wYBEZ/z0mwmLdDlry2GQoj/C8yLd18Vf7cCPlzW1pTMM/gn3QYZE1bSUyvVEoG1
 XqwcW0v8
 yhpaOWPn0sC2stdoPyEpXSySdMah2MGMJ8Vx7xOllttCOBnj4a8zPOamY34/2N91LhmL0W+8jr+tOPJ/IiCV8rASKdI0BipPxBIU4H9kEGdhn02O4ChUUZtz8xWGKm40vLqrUSgCN4cUE0n7DJBRF++uwCB+0uVHzUmSQmi96ssRchAXr4ubjp+IOj5FRbCjeq0rY6pYtBoKvX09Awo8hMUwcjdmI9RpUoRZKD9EfO6jjPNKM5lYjEjfuNsxj/KdVSXS+iRFFNtrMKEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, if an architecture implements has_transparent_hugepage() and the CPU
lacks support for PMD-sized pages, the THP code disables all THP, including
mTHP support. In addition, the kernel lacks a well defined API to check for
PMD-sized page support. It currently relies on has_transparent_hugepage()
and thp_disabled_by_hw(), but they are not well defined and are tied to
THP support.

This series addresses both issues by introducing a new well defined API
to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
new helper, we ensure that mTHP remains enabled even when the
architecture or CPU doesn't support PMD-sized pages.

An important detail is that we need to do the same refactoring for
has_transparent_pud_hugepage(). I actually have patches for this one
too, I'm not including them here because I want to get some initial
feedback on the general approach first (and maybe it's better to
do that in a separate series).

Thanks to David Hildenbrand for suggesting this improvement and for
providing guidance (all bugs and misconcentpions are mine).

Luiz Capitulino (10):
  docs: tmpfs: remove implementation detail reference
  mm: introduce pgtable_has_pmd_leaves()
  drivers: dax: use pgtable_has_pmd_leaves()
  drivers: i915 selftest: use pgtable_has_pmd_leaves()
  drivers: nvdimm: use pgtable_has_pmd_leaves()
  mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
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
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  2 +-
 drivers/nvdimm/pfn_devs.c                     |  4 ++--
 include/linux/huge_mm.h                       |  7 -------
 include/linux/pgtable.h                       | 14 +++++++++++--
 mm/debug_vm_pgtable.c                         | 20 +++++++++----------
 mm/huge_memory.c                              | 13 ++++++------
 mm/memory.c                                   | 12 ++++++++++-
 mm/shmem.c                                    |  8 ++++----
 20 files changed, 72 insertions(+), 59 deletions(-)

-- 
2.51.1


