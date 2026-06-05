Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5259ECD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 19:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0CC6B00A4; Fri,  5 Jun 2026 15:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8F06B00A5; Fri,  5 Jun 2026 15:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F55B6B00A6; Fri,  5 Jun 2026 15:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60F106B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:08:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A8AE16140B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:08:31 +0000 (UTC)
X-FDA: 84846795222.11.AC1F378
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E01040011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:08:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=idS7o299;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	spf=pass (imf01.hostedemail.com: domain of adiupina@astralinux.ru designates 93.188.205.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780686508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aDsH5PgRT//gx+tbE4waaqI4H2qVo3eTM+CW8hvx83Y=;
	b=uNYgX8HlDiMdyKzWCNw6QwbLNCgiKt+E18uxr0QQsdd7tl9JyRUVuBdEwD/V6CSPefEIal
	B1Dv3m235DWpEk60wtRSQGCtXJ14cnx8yUi+hFHgdo/gcaIbb+xRHiLpQ0EVqvi/ncCIme
	pArh+AOaMXeZKD0ptTXFFpQV3f/eZJw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=idS7o299;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	spf=pass (imf01.hostedemail.com: domain of adiupina@astralinux.ru designates 93.188.205.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780686508;
	b=sFosUghWP5kA5uItWJZgdwp4rKz87dIqnCHQfIha6jw6oaeBMP/Pt5fPGyEozkE9JyWxVF
	Kmwi/aeSosa8k1+sUJo2SM/TB4dV+a9fD5OtuBpZ1X5aPArA5vc99gmQtOs4uHXNutmx8k
	KHG+GjVz5uNruMKzgX3naqlnvZIkdm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1780686504;
	bh=YQv0m4J0f+nkZavHDMtyMxlsXgnfy3KLlxPVELpPPnk=;
	h=From:To:Cc:Subject:Date:From;
	b=idS7o299A6cmvVYrxkfwitzCLfLvw4qHKi12eigdI6k5HpckT8j4hhsvQ9fJzyrV1
	 ofD98NS8Zhqh2HLxpN2SqSkegEc5+NL5dRNuTvEQEbMyHhYpt/K4Usu6QYYd3916i7
	 cl6oK/u3HQ8xXspOTpJXoI7dAKewMRqAcYwN2myqcLIuA8ZHEsbADjq+FxEXPa8mU4
	 WcQwud40yjMjh1ZZfA/ufgmHopx891OMqUax7jldcz2+39amZiqHjsPBg6fVZGGduO
	 klWPQ8DW8RkKFW439tKIGecKTkAx5eDlIbv4NVuGDJyv/0A8EWM2ebdx/Cjdl8Fus+
	 8hWg5ODi1ARFQ==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 9A3661FA58;
	Fri,  5 Jun 2026 22:08:24 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri,  5 Jun 2026 22:08:20 +0300 (MSK)
Received: from rbta-msk-lt-302690.astralinux.ru (unknown [10.198.53.178])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gX9v72p91z2y19;
	Fri, 05 Jun 2026 22:08:19 +0300 (MSK)
From: Alexandra Diupina <adiupina@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Pankaj Raghav <kernel@pankajraghav.com>
Subject: [PATCH v2 6.1] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Fri,  5 Jun 2026 22:07:56 +0300
Message-Id: <20260605190756.20413-1-adiupina@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/06/05 18:44:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: adiupina@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 107 0.3.107 575e75fe8e3b9d45c142d144823c5de38605099e, {date_rfc_vio_soft_silent}, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;lkml.kernel.org:7.1.1;new-mail.astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 203696 [Jun 05 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/06/05 16:27:00 #28217824
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/06/05 18:44:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E01040011
X-Stat-Signature: pxys63gm4qs79hk85pe5e86dth4omw86
X-HE-Tag: 1780686507-482244
X-HE-Meta: U2FsdGVkX1+OIAXPPzMjmr3OrtCfAcpqYt5oqjEmtkr3+hFhtq2L/2VDK4kwNsLQjQ7pnaxGnqKBvAv4OSIQNI0ntsVZx+P0Qz3HokuK4JtBgafV9Zg3D/Wa4CxeGHKSZUhYAJjnWfxhKo33f/PgXqHJCUKW0HHGQ5kVct8k45WiuuZluaQyyRU8MEyHBpTQhNccrG0//jsbK/aRptPZXqjIcnWA2fw3lqJNaaxsgW0p1W220D6rtGyeDhAFvzocuefpNLzZko/euwYpO6W3IDaAdmlgdH7fmBlCemZQLzGZ14atlDMXhC8bpnb95FHpKr5hdcy9Z9GsXEwo1LIJ7Pp0GXbCiQ6w9vZfO8CxmBP72SfDciLCRKjpdXus2ZOdEnr8vDydqYellOmY5xQFdHCOIRI08DwRvlNJR63sc4Qnh1HKZlLq3huw5YRzARb80YQn9JuYE7y6Hv+wYYioMlFEy7YIQFvL+hpay+khDsyz3Lw42tydRFOZcTeKDrth6gLJT34IBOwYv2b6bhNXf1gWipF/vksZZVKD1D/hMPXIfARbn7C5YFrqFvELVr3J8wqVCaR0i2k4yS7FlnE8Clk9Xa+l+niNr9QHuIxIDpoyPmocnjQeFb2W03DCjHeKdcARbrabpsrRuuvkkfiB2oBP78f9isHb10vvbYDirDQs4Ie5P1M1IkbNrtBK5pM3FA0UunFmXTR4BEimyud1+v8b/R+mGX1yBqXsPttD14/H4rXjWsafbYoq1IjMurcQ16dEBOtyLgPv5rqwkuo81twtLUTQQexf7RMiVQ7hR8SBAjV48mdmPbpc8ZODPpx8te7bVRH2zH9xmzsjU7HkNKiSfpW5jJHgSA274ODKMMZxRErgGcRJbq5qyCP8Ftjn+TgASkA00XjAsurokfImBLe67Zjbd38WW5DD7FYmYqL5xQiowdYbVT2vTYud/RaxZKeyM7lI+neY+PNfXa/
 fC4pD1Pd
 vpLaxeQiwA3mtA/7iZgTlUez3aeTP8pafjJft3onTxrleMJ/DIuSK9V7LZXDFQk2mQezxHPW2YkC9QMsivW9FvEUFjvg7hTRey9bT1IlKmnB9GtAR9r4Kd0a+RsXP0ktzhF+PhPZrEZ9lERKQUhXo1K2jK34v/r7li/LLJluBjgxxlsBkJ5sl4dqy0s6xrDMsCAWHBiCUEv1T0EgFjqtUWoLdXB8jMMwAluPTnACCwiSuI9vlWISD4QXTKOkRvPTHkbIl1MUiloGr88Kn2cfrofJVRmV8qT53p1T6iUiXBsWXz4P89DrbjCpM+e3AJE3GgCb+zR5SQGuqiSFT5Kgy7TP4s1PCZi4yHuwb4RaOUafY6nhZ1u5CUM8dYfNmDFDAzkMEugiSr3hQBwDs+HPlcDir+zewzKPOQa/aZ0xFUYOgHt5PhB6PGoC5MYK9dWvdNNtlnzwt41oyBz8PUg3IMwtrH61lqL4BVY3zaRqd5dRU8PpRRi2FE4G9uxB+s0qDJhMGmJgUTCba3zhwa1a5txveYJCG2FLL7u0cDSggD4sFo/wArbJtxUxSXoJU4GRtcmOlVtdAGWIYf1w8jygrGVMJU3jfcpYibIPWWU2ADMgsaVhn8TNNeMbim4hk+25vsd1j/wOVhMv0GoCNBXtAPTeEs4Rc7KuBjZzcKdvSMiPWi83VmhZBV6TEvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 397f6d14f9c370e4910e6885294c340f39dedbf5 upstream.

In do_migrate_range(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().

I can reproduce this issue in qemu after adding delay in memory_failure()

BUG: kernel NULL pointer dereference, address: 0000000000000000
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
RIP: 0010:try_to_unmap_one+0x16a/0xfc0
  <TASK>
  rmap_walk_anon+0xda/0x1f0
  try_to_unmap+0x78/0x80
  ? __pfx_try_to_unmap_one+0x10/0x10
  ? __pfx_folio_not_mapped+0x10/0x10
  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
  unmap_poisoned_folio+0x60/0x140
  do_migrate_range+0x4d1/0x600
  ? slab_memory_callback+0x6a/0x190
  ? notifier_call_chain+0x56/0xb0
  offline_pages+0x3e6/0x460
  memory_subsys_offline+0x130/0x1f0
  device_offline+0xba/0x110
  acpi_bus_offline+0xb7/0x130
  acpi_scan_hot_remove+0x77/0x290
  acpi_device_hotplug+0x1e0/0x240
  acpi_hotplug_work_fn+0x1a/0x30
  process_one_work+0x186/0x340

Besides, do_migrate_range() may be called between memory_failure set
hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In other
places, unmap_poisoned_folio() is called when the folio is isolated, obey
it in do_migrate_range() too.

[david@redhat.com: don't abort offlining, fixed typo, add comment]
Link: https://lkml.kernel.org/r/3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com
Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to be offlined")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Alexandra: replace "goto put_folio" with "continue" ]
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
---
v2: replace "goto put_folio" in the original patch with "continue"
 mm/memory_hotplug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c8cc2f63c3ea..536478e688a0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1654,8 +1654,14 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		 * the unmap as the catch all safety net).
 		 */
 		if (PageHWPoison(page)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			/*
+			 * unmap_poisoned_folio() cannot handle large folios
+			 * in all cases yet.
+			 */
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				continue;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				continue;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				try_to_unmap(folio, TTU_IGNORE_MLOCK);
-- 
2.30.2


