Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ECFC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A286E6B00A6; Tue, 15 Sep 2026 11:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFB26B00A7; Tue, 15 Sep 2026 11:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917236B00A9; Tue, 15 Sep 2026 11:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A486B00A6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C128A140407
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:42 +0000 (UTC)
X-FDA: 85216341084.06.12A89B8
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47FB820004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=IDiyfSyR;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485221;
	b=gXRs6y0lpzW/Z4CgcD0f9Xwu6QtSssSdqc9sAj0kGoM7ZxgU9RfF3j9NnZCKOMnqwvryIA
	G9KpYDfZn/Rsfw7VvqXOdlK7ncu6+cj1p9XVri4SOaRwUlALcvAUV9qJloT35kb575SvEZ
	VNFONn/+ejCyNAYG/eaESKTlMBGSTz4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=IDiyfSyR;
	spf=pass (imf13.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pKhdrGOsRLW5YejjfAbK4XLy5VFPVA6axSXQtqSTR/k=;
	b=mSgFFPVoyRy9p5+hckGlvhbK1l4PmmuuWDx5StTZXRVTJi+8Xn445LEYJACRwZRq9Rsvt9
	JY+Mob+ButcBmq3gDGG4MopdgFfIYBXlpW3m6R0uw9muc+LSmixyAPrubPHtoVSYkpCzDy
	e0VCNwrCti7makjGNMbW+NjgpzJ/NjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pK
	hdrGOsRLW5YejjfAbK4XLy5VFPVA6axSXQtqSTR/k=; b=IDiyfSyRk9vwkqNify
	4HzPOFiipod/lcjuHkZLpYqF/cox/JWqGYcDGsDXrl6Xv6Jn8FnE4FGqQRgIh4O3
	fsFalgGRCNi1A59wQFPvLEh4yleOiTcetucaHSxSu9XVW0i87VULM+O4A+SPM/0l
	edkukMivE0W+Si4wtryefq+uA=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S2;
	Tue, 15 Sep 2026 23:13:19 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] mm/ksm: merge-path cleanups and folio conversion
Date: Tue, 15 Sep 2026 23:12:14 +0800
Message-ID: <20260915151236.5200-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFW3Kr1xJF1xGw1fZw43ZFb_yoW8tr17pa
	43K3sIyr1kGFWSqw1fJr4jyw1YyrWfJr4UtF13G3yfu3Z093yjgFW8C3W8urWjg3y8Wa1F
	qF4jyF1qgFs8taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joGQDUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+A9AOWqpYI9VzAAA37
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47FB820004
X-Rspam-User: 
X-Stat-Signature: dzcp98w9ukhdudbg91wkzqd6a8zmi6xp
X-HE-Tag: 1789485219-222683
X-HE-Meta: U2FsdGVkX18rze0MhnEd3mew/1ih/eORq6VTxG6XqTvmOWnCvz1hAT+p3KqjNic3AcBg+RYncgXBcjfwRMi8uSl7rTvij+6itNNiU2pD/vfvDnv9xjhMCV4RFsIkdqws+oJT5wliXCwIKs6fwpno8sT2Usun0kmyudmb0L1xh09pHL2EZi9migELk9kBiStFJTXeeDMNMPyZxCaP5W3IfOqfC5GODaM0P1x04T2fBe7TRLIaHU/YMG0oCwOJL7eo4Mfl5bEvLrtz5w+3GwiMKKTEzHcziDQMTxH+aiceZWbHa7m5w0BlLOzdDZOXj84V21t0QYqsgfHjL0Kx9mg1RPtcBetm746IwCdMJfyKYXraf/ATg6g9hcNe6DFYA42slN+LBeItNH/2nYqW1Cq4D/O5cLdGfbM7dvDlO/vFktiWvXLTmJxAx3BZ02YyjzBbwlv5gLv9ES/LZDJwfxq6+liqCl6nEEiMzPqgGbTdldomrY3wz5LqvlLFWH90dGpgYIPzUp+Xt2po0yznFl4lYAmWCepcg/Mfe9O//xB7HAmNM5WPJwAUX2lqhs7jH9Bg/IgY5GgAwqT2446qpLSX4SDYx7J1SfCfUTq5X5M0lTiCjfRyHevmQxD274byba4r7KeKdnJsxftHiOk94cGauBR32XWrs5f3pzRE7pEjjW+IijokEYMyFUYBCO1b2K3UzYLFGkNEN81O3GM3D82ExR19KmlkfF3vRlxrVaUUZvRV7PFUzNfY1akAoWnauyT31bSMLVi7InQraaxHinzkylDp8yOYWPTLZ3WJmpyJ/Wv1+n7YlispmSpqG92hEcYXZRrvyZonuXPbwLNG4TMya194RZe0ip5VU9ytaqLP9guXXpj4Y6qsfCQeMPMhlfbtY8BLDvu0sd8n6NfAj52d31wPKDn/O2nSM0dGpOOP0aWkNA3Dv62xRmDixvpd727TxEt1SYJPbkjUAFy0Bmb
 XLDklD3U
 qL5/oms1cj6g+ga1Xit38JCIBOIqXA8ygc3TMbtVuLpMnVX9a0INS5O0j/QFCXXjScekckIbPjVVB4tzE35x7pQaB/AkxjTYD0pippbJPG49T4briHc8Mr0/03KWGaxVqap/a9pPLkd0WdhGOni25BSY8Wvd4YJiMREkVekDStulWDMMTY3fcZmeP33aoJb58fObO3TeTOoy/mchha0A1F2K4IvoQTjp3NiVXfsCajw3IMhuOBOSkAdmzRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Clean up KSM's scan helpers, advisor naming and sysfs formatting, then
pass folios through the merge path and update the related comments.

Patches 11-13 convert the merge targets of the merge path to folios,
continuing the earlier conversion of write_protect_page(),
stable_tree_insert() and the ksm_get_folio() helpers.

Before this series the merge path talked to the stable tree in folios
but to the merge helpers in pages, so the same ksm folio was wrapped
and unwrapped at every level:

  stable_tree_search() returns a folio
        |
        v
      try_to_merge_with_ksm_page(..., &kfolio->page)   <- unwrap
        |
        v
  try_to_merge_one_page(..., kpage)                    <- page all the way
        |
        v
  replace_page(vma, page, kpage, ...)
        |
        v
  kfolio = page_folio(kpage)                           <- re-wrap
  folio  = page_folio(page)                            <- re-wrap

With patches 11-13 every function in the chain takes the ksm folio
directly:

  stable_tree_search() returns a folio
        |
        v
      try_to_merge_with_ksm_folio(..., kfolio)
        |
        v
  try_to_merge_one_page(..., kfolio)
        |
        v
  replace_page(vma, folio, kfolio, ...)
        |
        v
  folio_page(folio, 0) only where a 4K page is needed (pte and rmap)

No functional change intended.

This series is based on next-20260914 (1a1de54f7369).

Longlong Xia (14):
  mm/ksm: constify ksm_next_page_ops
  mm/ksm: rename advisor_ctx to ksm_advisor_ctx
  mm/ksm: use the correct format specifier for max_page_sharing
  mm/ksm: add advance_scan_mm_slot() helper
  mm/ksm: make remove_stable_node_chain() return bool
  mm/ksm: clear all slab cache pointers in ksm_slab_free()
  mm/ksm: reuse the zero page pointer for merge tracing
  mm/ksm: document the two remove_rmap_item_from_tree() calls
  mm/ksm: move the no_vmas label out of the if block
  mm/ksm: extract ksm_begin_full_scan() from scan_get_next_rmap_item()
  mm/ksm: pass folios to replace_page()
  mm/ksm: take the ksm folio in try_to_merge_one_page()
  mm/ksm: take the ksm folio in try_to_merge_with_ksm_page()
  mm/ksm: update merge helper comments for folios

 mm/ksm.c | 270 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 152 insertions(+), 118 deletions(-)

-- 
2.43.0


