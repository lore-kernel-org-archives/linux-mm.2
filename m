Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B62CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240826B0088; Thu, 30 Apr 2026 07:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217E96B0096; Thu, 30 Apr 2026 07:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106E06B0098; Thu, 30 Apr 2026 07:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2FC76B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:38:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7651140190
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:38:00 +0000 (UTC)
X-FDA: 84715023120.18.477000E
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	by imf16.hostedemail.com (Postfix) with ESMTP id 844DD180007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:37:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=LeTbU8JC;
	spf=pass (imf16.hostedemail.com: domain of adiupina@astralinux.ru designates 37.230.196.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777549078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ydMN5A/n4I9igE4vgr0XLK5M8jGH4aM4tjeuFn/PA3w=;
	b=Ggu1NkD/d7I1Mb7IMw9PrKoyKM9kEsfpX9vB4edfj7CO91SWha43A8eR1ESYIIlK2AXGBJ
	AkAiztvYKjg1aTlJgR3Q/acvcO/voV2MnAnPOvvTUAnzj8tsiyDnQmDrd+1MSjMuvMqrbm
	H+YDysOvmxL3A78ZFdDzZHGK9SUdvwc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=LeTbU8JC;
	spf=pass (imf16.hostedemail.com: domain of adiupina@astralinux.ru designates 37.230.196.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777549078; a=rsa-sha256;
	cv=none;
	b=zER/F5i9S4V1qCjE6WR2SOkl0Qy0Mr1UUZGK9gf/Q5Cmm4Q4BUg1hOCCuhM0ZuhcrrLluf
	OuxttbJn6wNyBbFziyvfxvHdyzL2W0kzcFIdxH4sZ4qZrQVWEsKCbXdTA0M/FjDRJIqa98
	O+6Rpn482B+f8aTj4mcJ1V1k3EuBOO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1777549074;
	bh=NlYMAWsPda2oH5mbxBgRhqukUi7alByGjRCX9I8eZTk=;
	h=From:To:Cc:Subject:Date:From;
	b=LeTbU8JCcVdT0lshwXG1ixC1nKGgv084F5rMcvbSlTtnl1z8HzhWoL27AsJr5DIrv
	 xGHQ1ZIneBXd4zlqD/+RD8MBpkyQ1iuWXuB7DROTpHMyVriWdk9JK8kWT2/4Jet0vR
	 v1YxHAA9b1m8xuNGyvQE46O2YK1DdvTcDgahobp8fApFkTzooIgOfD07Xx3M9rChd6
	 hma3MjkMJN+H0meyVBUldDTTmMeADsglzbYa4cByqV6sVzIzui08tQITo2r969hlaL
	 v0BxXh5VqVnyXIjMKJB041IFM4fw07qVPYho/DN6NOXQvowr7z8auJDVrnBuaSRdgV
	 J4dAA8RPsR1AA==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 48B2B24E7B;
	Thu, 30 Apr 2026 14:37:54 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Thu, 30 Apr 2026 14:37:52 +0300 (MSK)
Received: from rbta-msk-lt-302690.astralinux.ru (rbta-msk-lt-302690.astralinux.ru [10.198.24.65])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4g5sbz2SJLzZcy2;
	Thu, 30 Apr 2026 14:37:51 +0300 (MSK)
From: Alexandra Diupina <adiupina@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
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
Subject: [PATCH 6.12] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Thu, 30 Apr 2026 14:37:31 +0300
Message-Id: <20260430113731.1227-1-adiupina@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/04/30 11:14:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: adiupina@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 104 0.3.104 557b3c2486a74077a103cf2acd83f2ecf4c95118, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;new-mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1;lkml.kernel.org:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 202784 [Apr 30 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/04/30 10:34:00 #28457694
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/04/30 11:15:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 844DD180007
X-Stat-Signature: dnnph7gjfxi984bmgz9daxpyqdj34zan
X-HE-Tag: 1777549077-506791
X-HE-Meta: U2FsdGVkX19Q3zGc4bSkQdPYJSm1a/YcQa63PSYGO6F3qO3A985UYQs+dsUxKX4cRZteIriu7WdC6B23SsKZp4Iwwd8MZyy/E/6Haau/faO3ovZsPPasy1uLrpJF8oPKN69FnqOzNqtxlgtV0YPDprkTatAXs/NsubwnwgPu6Nl5y+Pp52G16nTJXdjTgTSigIl3tyecKZIYIJ0IqquZ90m6uH9caUHepMAe4hjE+q3xVEqLRZ5Yv88aUKVFAzED7s8eQvq4fHZhoKzLLPTljmRZjhQUR9o++QObargilFOVfPn3VNiaXpdf/uKpwW96J+ov3skZYh3R+8VW9jEUKCTx//PGcEnLXPohiaFBBCWuw1qLzMcYLUi8qPPwjkNgnPFUrK7ztig79Y/gg1ADx9TuZH9fYZp9gO7t4HYRwWr9WRTjAsw6d8dlJw442c+2W6Bd942KV4ooop4gL8OIP1LN4QlB20ADOAbtj1aWlBuaGO1BVTBKsTigMsXMNuzgSIR7ZLymm6hTJhpyXaByJMo1lt2OQS7xIYzr+WOnc1GVDDVJ4kHwV3l37BUMKrSKbh1f8+xvXAi6m6HPWqXRuWboWIGylQ9C/IIx67rNHS2XOxSbmMnk91L9r3s0M9INLLS9mWFfp3UslrE1XSPYLWgDPbZNWCmixi47+eVfLQhYBfgHLYBPp2PYwlAz/lnbtvEruHpMLDotoNW/qsIGF5tFJEH2GFldjCnHKDMjhfjx8qQywyxw32KnoD1tocO6zAzWBAr8pD7EzTVpXloWp4/r+ACHNiLeh+feWvuZz9AVG5USDtHp8Zr2JXHVxDK0i1G2CjVGH6Q9lpVY+aqWwo7lfzByy1e+xqZdnXSUIg+6DTb9dyA6J4t71gqvASYA8AOBsUO4/ET8jgrvj7LR4+xkSJhdyo1gvqVlHVsYG5/08W/cawg/xWUqY+4R5lDyFbIIl9wiZc3YrhzTB2k
 q91WXdQt
 nmH28+uIYb/3wniUefmw959wN03M1bk798jFm56TtpI4w+DVaXDl1GtwUrA5+wautpWigzyRI2JZsv1PtwieeqCAiRqyEftWAUCul/ZYQsSfZhgrKL2Z2N7G0JAclkbuisHHOhZHy+OeUF21+orQD+T0sK5gc+D/POFnXoxQ4tWiaQQ3thXJsVSnca+Dl+EKqxtOAYHQnPiF2zGDtMtvyybzUvM8rJnYjcJ10k2ym2h1hvBP9mj1n14r4KLLWrGvhR78NJZNlwBCuCLXU9wx/NSFcQwM9m3Soevsqq5ABV36bio5iDbWxkGxTeBThTMLePQkM3DcW8LoFYT5bcHdd5KQFvIgaGaNSuPDooBH6dV2vXmxHSEIGw6Net+hnsBK0h/Vb+qmymnuwaqKuZTXY7eSOyiFPnd/TAVmCvDgHQ97CmS9Ie9nFXv6IEGPyDmFXj5mlz9kLB3I3DWJxi0rITloPitrH4mmcb//T46V6ZDy5A+zs1REHs1rCMgokISEhMR3iyE0VzfyRcx+gjT6LaQajFAup/8ZJwIBh8/sqS2pQnDzt/9wQF26SXzOiDYzOq3ZsR2M1kjIpvnQSLstChWSL9pUeftYgut3nzrhOmx6MWZkbF/8t4ZpFA4bwh31DVoTP9ELKaD147HazBOPdJxe95ew7AzgrMPKIGm6PsFHVSAXV0eiUCBaSOv0ZQ6P26VBd7qSbJjPXtffkFEG60Vm7npaMJPtnjTDi+chk7fqIzlQQDg/sDNs8FntOtlBWBUt2
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
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
---
 mm/memory_hotplug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0a42e9a8caba..16d788547b9b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1802,8 +1802,14 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
-			if (WARN_ON(folio_test_lru(folio)))
-				folio_isolate_lru(folio);
+			/*
+			 * unmap_poisoned_folio() cannot handle large folios
+			 * in all cases yet.
+			 */
+			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+				goto put_folio;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto put_folio;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				unmap_poisoned_folio(folio, pfn, false);
-- 
2.30.2


