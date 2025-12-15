Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79504D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4346B0088; Mon, 15 Dec 2025 16:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61AE6B0089; Mon, 15 Dec 2025 16:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AF66B008A; Mon, 15 Dec 2025 16:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1C136B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B4701358CC
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:12 +0000 (UTC)
X-FDA: 84222965904.05.2B967BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 126EA2000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QfFhGGsz;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833430; a=rsa-sha256;
	cv=none;
	b=ClAJMljExMOZyVRfM9/BVH0Fhu1dGg6tEWW2tL8rViUok6cCNuphweeP3zl4FWES8IRpzr
	jQr5LjtbiSruQUnibEcb7jgTU/CU39FBG6ozF1GuigqDZw2H3rf+432+5hv6P3coQt8daO
	Ux7bsTVXbgRE8Lri9yPFNhPd/uN8lcA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QfFhGGsz;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0ADnfSiMIGzMB/wdMCwvS96AWdDKTF7dBext/rGAqaI=;
	b=FiDKO3Wit4CbnNAbcQj2bQKAhacfP9fYZBY6fjhX4F7OV9FnBmHIs3kJZTP9cg/jPn6AQc
	f+wlKesq9wnTfmjvx0UvP2xCmPgakeRNq9fsdEbqaYcRMFTX9SaYU9gCbEvD6VxCGZvkav
	vV6AqVNwExGfbs3dbo/fhicTA6VDLO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0ADnfSiMIGzMB/wdMCwvS96AWdDKTF7dBext/rGAqaI=;
	b=QfFhGGszXjUPCutaHrUM7+75pfmu82XisetV3UiDUg94A4HlkXNO/+qI/LyFry7trL+ePm
	50b+hCC/vL34yahEeM1dZGxJuG0al3F84gKUxTzMvnpPtZjAs0lWq0Fg/p/PcaYuX4692B
	yZKjS8n/1m5PXChDmsgGwhFWOB3hmQ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-ZwfahJxwOhWpNe79uy8s6Q-1; Mon,
 15 Dec 2025 16:17:07 -0500
X-MC-Unique: ZwfahJxwOhWpNe79uy8s6Q-1
X-Mimecast-MFC-AGG-ID: ZwfahJxwOhWpNe79uy8s6Q_1765833425
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D46B1956053;
	Mon, 15 Dec 2025 21:17:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CBB21955F21;
	Mon, 15 Dec 2025 21:17:03 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 00/11] mm: thp: always enable mTHP support
Date: Mon, 15 Dec 2025 16:16:42 -0500
Message-ID: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Queue-Id: 126EA2000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 6zfbwxsp4qabc8zekbjnuj98n8s9pkuy
X-HE-Tag: 1765833428-424986
X-HE-Meta: U2FsdGVkX1/WC9NdaECbukRf5Lt5UagBn1rd92nXi6ld8v3CMYywYEGt8Kg0igpHPrhVBhGOte98C4TeKQhFXZqT654G0lyEt+bv9R4vkI4bt9WM/C38yuvf1u8PQTojQZiz12vbDjgw+xfxpodNaSflrQQiMiq7Iyn0ZK+gak3JAhMbkoSu9GpvViALZhzrcB8+341Jpy5giI9mLMnM9aVdpazn47T0NRpHva37usnbICs+nd+wZ/D4dx6kPUD+8hEcYzNzpu4X9VEkO2kV1vyb3CoFatzpDBfZnftBDjz0XphGShnjB1FyK6JLjaWt5I2oWe98nCcudAxBi/T73lvxnVcJ2HFe1fa/IcPax7yl6tj9iosIADIMW6Px0kUzxjcXp3E4J/xZjT4fbnT2fdJqjJfTx1wyYvDCRBk+VAjDxlmO5l69zJ08oqUcBNxT8zevuwO2SLJzPj0FeIPP2qMh8dknpXLtACZ8bpO2oZ40Q5qlH75X+ITI1k+Je85/FuuklEQHxSoL+wfeo+qlMO+AaC1s/9BiwZTYw+dp0zczvJZu38Xn2fvnnHdRjY2r3o9fydrdK/bhOv79Wgc+zrmUILgAut8q2MVImN/6/7qnxfAzf+jcew9imBt9IhP9YCNi5Xcjo+sQJ9aayvAFtRC9YBBIXjCsx4hEyjMogsDPpTKcvQD0svWbwhQsZL9nhABiSOoggJJ6vgGR1bmipY0w7sYVtfX5LlqMcDXgk1hBOFMp8E2nXI/XujxUhfXPHBX7kPOhyiQxB2uodtMMiiUBAKYvj/4o9rMAIZuWt+zqK7nfm1P5ZAyFeWTZbIkYXQY75bXGePDCgrQgmDEwcoPyrSn7zc7crRv+NqPrKefaprCqHvez/U2LT0JCkpFD2Ca8wPwvrU56XbwKmGoHyBonoi0h203Zwe8BYbQjgcGt1PkjFG2JMN7FL4mLxwYpBaMFeBmvKcpSqDz4EbA
 3EGc42zx
 73zyagTu+SDhxJuSJqGhQNhE0T9+IvYDrxYEvNd4U0MqRBqW3BYTr+BOoKo2Vcpy/1GEgZVgCTf20GqFEJRw3HEzSChpy5AwkBFWYAuSo2LaBzZe02ARh9gLIPzybUEBEuGaoqpTZXEfClpyDbLu928fNEyWjVWEFEuHqKVNAxb4WKuKKNkJhYCjrBp/v0BZctl9VTaScMoO3AFzEpHIJn1rYzcsWKPnjA1WvENNLwUS6US+baw6vb0z6RfuNe0LzNoAxXdOD5nUFD4w=
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

Please, note that we need to do the same refactoring for
has_transparent_pud_hugepage(). I actually have patches for this one too,
I'm planning to post it as a follow up to this series in the near future.

Thanks to David Hildenbrand for suggesting this improvement and for
providing guidance (all bugs and misconcentpions are mine).

This is on top of latest mm-new branch commit d0a24447990a ("mm/hugetlb:
fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather").

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
  mm: shmem: use pgtable_has_pmd_leaves()
  treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
  mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
  mm/thp: always enable mTHP support
  mm/thp: x86: cleanup PSE feature bit usage

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
 mm/shmem.c                                    |  9 +++++----
 21 files changed, 73 insertions(+), 59 deletions(-)

-- 
2.52.0


