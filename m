Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D56CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DA16B0005; Fri,  1 May 2026 15:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8557E6B008A; Fri,  1 May 2026 15:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792FE6B008C; Fri,  1 May 2026 15:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677C46B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 202D98938A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:08 +0000 (UTC)
X-FDA: 84719816496.27.01F20FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26C3F1A0015
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J46kyCBr;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cY6LaFmqcqx3jjavRgihKIw3vSF+bJhM7Jxo3NBkAY0=;
	b=SalCGwnTLmZrRyUnqhQdon4iK+9cAmjqkgOnwjHx2CrDxNA6HZO8fbjp3YeGVnBSgKpwis
	4ZklmM3N9QDL+eAdOULlhcp9g0Ju7xErKU7fi3q5fmttw8a8ro2MIBkkNedXS/gNObduN5
	TOZZmvjzgMPCm4uMBEapLYOTK2uvtLA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J46kyCBr;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663206; a=rsa-sha256;
	cv=none;
	b=P9ooFfdauehoRyrIoz07zcSCSBWdhZ7YD/knwHAqP6Sk1LY3G7FlTf09VSGsO+hD4Ss3KL
	2zgJCxqF0h6RpxvpJ2IyuwIMX+dYkGT9bB+m5KI82WIk2if1G+v7vjk0Ih0GxUnrQJxtww
	dzOIzvTgnmknOW3sOyE8j/zw7FEFcA8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cY6LaFmqcqx3jjavRgihKIw3vSF+bJhM7Jxo3NBkAY0=;
	b=J46kyCBrOqZPITQ1+c14uB5NmdfJSQqzrblZ2pDENX5rr/TPlNtjzVN5ML1PF2a5c/YG0u
	Wu9oUi2zhWVCXkqZRBQ4VLh8PHP4hZXnOMNZhSAhWnMdww96bz0Te8YKgusjt7eH+hdWkW
	lgVzDDvICGee3H9wnF3KVnxgW6y0iAg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-gWRvNscCP3GXc_lH56B9Qg-1; Fri,
 01 May 2026 15:19:59 -0400
X-MC-Unique: gWRvNscCP3GXc_lH56B9Qg-1
X-Mimecast-MFC-AGG-ID: gWRvNscCP3GXc_lH56B9Qg_1777663197
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 164D119560B7;
	Fri,  1 May 2026 19:19:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A64C1801481;
	Fri,  1 May 2026 19:19:51 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 0/9] mm: thp: always enable mTHP support
Date: Fri,  1 May 2026 15:18:42 -0400
Message-ID: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: DYFvueZNCXTI6eQsRSE-FkBNp_Hud0ChYph_QqgXAhU_1777663197
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26C3F1A0015
X-Stat-Signature: xzd9xcxsst5axk1jsyk3yctsx1grgibe
X-HE-Tag: 1777663205-881585
X-HE-Meta: U2FsdGVkX19WmBIEX8Ior0WPMFi9WZrHFMqHJK5n5B0EHI+QgYvC0unhVPTj7tGAXA8TZ8ahrO23SvXNh6pw1rgrgV893gDKr8CnvgGcvPN5NO7/EQXV9EpckmvzoeB1094JDFbIKHm6jrSOVaceu+EJrQRh/q1UXwPCE5ltj7SCFVSwUU7o+SgXtL82L5g3Kl5Gl3H0xXm20xMtWh7o97UtUPReSE0k6aRJkMsvglNfI+VSmNXta4bTfNBZwn2nOXe3I9omrzTRC3ui+Ge/GN/lTqA9bZjM4AEgJizTR8u3ih+w4/l1Nw7p1X58YCf8KhA5G/77ihViEoO6U/9qu7Ogb4k04wCGPtlA7WUAl5Vr+fu4UV0rFlN7Nm2QriY6WPLRJOfRk/9kdhcTxklHx5nSmh7fjQey7hojN+kSc5MQ+jS+jRYFVc61Ju5jl04QNut2Wkev6Wl47K3YAGIlXdA/M+KphjzQ6omuJxyGj6DlTON1VofMJ9pzthi4ONWr6iHCUifhzElz+OUq4INwqOfkIozgjlEJXj/rLUMF4vHpMDHfRIRdMd0K9C9VSHWwgbxDipeKoy0NKlMI/MFeuuX0aZrP4NooSIft533+0vjrfJSi77vmVz6H7DcfzjLjSF1ED1ugZm1SDXgBz0a/lW5ZoLnt3kxLeVHPa7dIYdLhonzy+tjqrm5V/xLOl3mmk/wDUuhGOk7hSm7uxB7H+oBhKwU28krR60HfZb66o6Icw8Rs3uO5wazx20kITTE41EUijniq4DkmO7aInQYRG1/tnROImhuMqlIL3EHdleh23GRfcX+H2HiFBQFNKtXmiPJJ8ZugCIOJsOJbVZ5u4in7gCJuTjYS5tHhocVAAvwgWQDxxbDyNnPrrdI3HcCnUUbZ0Hfz48LAZ51VMTDCmNSJB9GNZ/454hxlZdrKhcJMq6D/tVHuGDFDGNI6v9vu8I8EsqXuPtUPbyN1U4Q
 udhaxk+Z
 H/YYX86VJBEl0ZmCprJGrIZ1Ya1l+6I73Rc8bh5fLS4f0YznVd/2BuaiMvaaMXALS5nP3F9aSdqqZyatvaKHqhNbh2Q5nrJWNl1lwpqmZRphzEpDnBUc5pbxVemLPS4MEhUoV+0HyUwYy/8/WTk0iu9hOKT+pXxAOndOCEwHFq0Gwu3AKVytglmIDJ7hw1dVO+natp26ERExSoVWQQVoslAM5lq3HK6PB0kRY6Pn26HHA9YJmUrfFn2Wl62bmDKEqC3XzIqdNu0HEXvU/CO+7LEajzMRtOAqKcLZ3XqdcOSHymiYEw06ySr+hyAx4ruMdr5fw5Cwc/umdhY1BHnF1BN+GvKP4MZAKTX+i4hDB81cxMrs=
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

This applies to Linus tree 08d0d3466664 ("Merge tag 'net-7.1-rc2'
of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

NOTE: I used Claude Code Opus 4.6 to *review* the series before
posting. It did find one issue where a pgtable_has_pmd_leaves()
check was missing when assining huge_shmem_orders_inherit in
shmem_init().

v4
--
- Use static key for pgtable_has_pmd_leaves() API (Lance)
- Moved shmem pgtable_has_pmd_leaves() check to
  shmem_allowable_huge_orders() (Baolin)
- Default pgtable_has_pmd_leaves() implementation to
  IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
- Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)

v3
--
- Rebased on top of latest Linus tree
- Removed i915 patch as driver dropped has_transparent_hugepage() usage
- Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
  with early_param handlers clearing CPU feature flags
- Fixed build error with CONFIG_MMU=n (kernel test robot)
- Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
- Small commit changelog improvements

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

Luiz Capitulino (9):
  docs: tmpfs: remove implementation detail reference
  mm: introduce pgtable_has_pmd_leaves()
  drivers: dax: use pgtable_has_pmd_leaves()
  drivers: nvdimm: use pgtable_has_pmd_leaves()
  mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
  mm: shmem: drop has_transparent_hugepage() usage
  treewide: introduce arch_has_pmd_leaves()
  mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
  mm: thp: always enable mTHP support

 Documentation/filesystems/tmpfs.rst           |  5 ++--
 arch/mips/include/asm/pgtable.h               |  4 +--
 arch/mips/mm/tlb-r4k.c                        |  4 +--
 arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 ++++----
 arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 +--
 arch/s390/include/asm/pgtable.h               |  4 +--
 arch/x86/include/asm/pgtable.h                |  4 +--
 drivers/dax/dax-private.h                     |  2 +-
 drivers/nvdimm/pfn_devs.c                     |  6 +++--
 include/linux/huge_mm.h                       |  7 ------
 include/linux/pgtable.h                       | 19 ++++++++++++--
 init/main.c                                   |  1 +
 mm/debug_vm_pgtable.c                         | 20 +++++++--------
 mm/huge_memory.c                              | 25 +++++++++++++------
 mm/memory.c                                   | 11 +++++++-
 mm/shmem.c                                    | 21 +++++++++-------
 19 files changed, 93 insertions(+), 60 deletions(-)

-- 
2.53.0


