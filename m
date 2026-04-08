Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC8110F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919BD6B0096; Wed,  8 Apr 2026 16:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA466B009B; Wed,  8 Apr 2026 16:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0346B009D; Wed,  8 Apr 2026 16:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFF46B0096
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:33:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 359EB8A9D6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:33:20 +0000 (UTC)
X-FDA: 84636538560.17.3812327
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8AC18180003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:33:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GB7CmgQx;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775680398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hq35SUBjwxqd9KLJl2OrltCPEV7I2pvAcKQjuEe3wRk=;
	b=3bAuV67SZ97PSmzhUTWuoABHKP7M33Rs60fm8r9QJ//N5RKLozQKaY3l7EAes42e7ZQqQB
	NlGN/FciNfownLaFDztZWTfdh/HPqwACqo4ur0Gnd5/Dtg/AcgyfriHRXdypag8Kb+nL8N
	HVkD+MEVc+hdiEbSQpOYE/TXtf1gibY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GB7CmgQx;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775680398; a=rsa-sha256;
	cv=none;
	b=aXQdwsuI1+KdG6odke9nEpux89fy+/3nix8Fj3IabsnFXJlaLRtlz37jBjgupk5yJ4JQSL
	FglSrCUI5YPt78sHTnr7stwwkhPZgQHbYQT5AFVNapOR/F0qFRYVMDuVuax0mvM4cc8D0e
	8vr/01M0BawKF86byuTo531dNSj38Dc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775680397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Hq35SUBjwxqd9KLJl2OrltCPEV7I2pvAcKQjuEe3wRk=;
	b=GB7CmgQxsXpzcfXv68l79YsfU+LbLs+J3U/JCLqZid5US7HCf2OCIR2vawFoZuZMULpfp/
	wUHlmI9kF2jskR4mj75piqILc15Txkbrgk41IAtdzXOLuD1SKL4ExGu79mmIfPprWeY45K
	bZr9JBFg1zFHv6XPwCCC+SNeT1Ru9no=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-pPCBymwrMiOTTKtZJl09dA-1; Wed,
 08 Apr 2026 16:23:18 -0400
X-MC-Unique: pPCBymwrMiOTTKtZJl09dA-1
X-Mimecast-MFC-AGG-ID: pPCBymwrMiOTTKtZJl09dA_1775679795
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F34D1800617;
	Wed,  8 Apr 2026 20:23:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6DDF71800671;
	Wed,  8 Apr 2026 20:23:13 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 00/10] mm: thp: always enable mTHP support
Date: Wed,  8 Apr 2026 16:22:55 -0400
Message-ID: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: t4rRXenHUJ9nyYl2-EHsPFlXe4EVPHO8OTZxzu7ieGU_1775679795
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 8AC18180003
X-Stat-Signature: y7w8pqgcihiyca4z36dabu6af6osrge1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775680398-536074
X-HE-Meta: U2FsdGVkX19L9IUWTJBo2XuuQcIaEeBXQhgbxXmEUTjxpClD+frDWk+W/PzhF9xcJYuhGIr4iXv+ueAGnoGbXiKp8FxA13cuWTgnnlMmYahawLrWSmmxp8RqNjpUrV3ysFU7onYk4COMY+jfhxp6hRNKbx8KjhfGgCMuUL1j4AxExNSjYAQE3CG6f8W5HYvt+btpxfm+cg4XV4tIS3VuoipM2ljxMLMmb7xUhIzMJ3C0FWZe7s5lKTIisCW+m35HjmngBo75JqXWEeQfjpIOtNhxuGbnenAh7g0xBirxqOgTBFXQgsNSDfzt853lZI2yQcOoBavJgfUZ75Q7QUSXismHwS3SwV5O41O73ghThjG3ib5rIUaev4vggIgFikaDJS0sl0UhLgts7U6l0eoG7RsZvBMhahkFIhVTe1ggtB98jfyoXfjszL7pi80+Q5EcCd/6cf47IjHS64oqwPT+n/3Wt7AaRzthSpphxdXh8zJbJbRqkT683csZQUN/hDg4MLVw6dFrQ4PxtQUcf7XnnPF6/LFI31+nU6YnuShpd7Fv2izVJ4b8HCTf+TXWyIv/6cW31/ke+staR9jEXE9iNVS8hJnOIv/y+uYK6/3mTLD/AtBEN6vdjlIHU0dAFHQtqFCxJhh4xq7PHH61hNywPdBqZIXR9EGkXHrbUY31E+iWb2/W8aF9UJ4eH9OjGAhDHgxYfuXIesPkjEBw2aCX2BzZ/rM1rtNvsU1+n6llXZzuaq37YhwokPy5fhMnVKYzwtgmquncO+51OXYG7SZAbcdKRW8BeGPLh2RzqsgKJ00FZYxai/cor0II2BI1pxzecDfY27c7LvHXXp4ybu33d90Dz73qMRLRgxEzjN8MyVoQ8g8X54yjeTAJZnsWYVi9SOHzb/HTrKlpz1sG+BJa4j/D/Kz0eqWuYImOIAJb53/8tT5y4APonaBwfKpMmsIFVE319RG60kyb3CuGCoo
 DMM2wQb8
 H0OvFPq2c6jdNiDM=
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

This applies to Linus tree bfe62a454542 ("Merge tag 'soc-fixes-7.0-2'
of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc").

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

Luiz Capitulino (10):
  docs: tmpfs: remove implementation detail reference
  mm: introduce pgtable_has_pmd_leaves()
  drivers: dax: use pgtable_has_pmd_leaves()
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
 drivers/nvdimm/pfn_devs.c                     |  6 ++++--
 include/linux/huge_mm.h                       |  7 -------
 include/linux/pgtable.h                       | 19 ++++++++++++++++--
 init/main.c                                   |  1 +
 mm/debug_vm_pgtable.c                         | 20 +++++++++----------
 mm/huge_memory.c                              | 15 +++++++-------
 mm/memory.c                                   | 10 +++++++++-
 mm/shmem.c                                    | 11 +++++-----
 20 files changed, 80 insertions(+), 60 deletions(-)

-- 
2.53.0


