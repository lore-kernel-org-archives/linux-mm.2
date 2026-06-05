Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0FECD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FD26B009D; Fri,  5 Jun 2026 13:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30566B009F; Fri,  5 Jun 2026 13:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F1B6B00A0; Fri,  5 Jun 2026 13:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA526B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:26:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 256471A01CA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:26:35 +0000 (UTC)
X-FDA: 84846538350.13.0062924
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2C941A0004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:26:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=QioEPdcf;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	spf=pass (imf19.hostedemail.com: domain of adiupina@astralinux.ru designates 93.188.205.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780680392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=03StQ3YYfAUQKT9V5RSLovWaHyp6Zx/w5Ez5DaFKM/k=;
	b=eIHAiI2oX5VjvIRJEmUUGJunzdwhI4gxgb63tdKQ9talMl/6oxdOaVRbJ4pDZ2fRNas2If
	swtQSM2pNehfUhDzmR27haU19yOYY+V6xwfaODcXLsMamPyxdIQ3BsMnbu//rry+j7xBJ2
	TGXwdYqS3DkMUsjRu77tr74VfAUPf/U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=astralinux.ru header.s=mail header.b=QioEPdcf;
	dmarc=pass (policy=quarantine) header.from=astralinux.ru;
	spf=pass (imf19.hostedemail.com: domain of adiupina@astralinux.ru designates 93.188.205.243 as permitted sender) smtp.mailfrom=adiupina@astralinux.ru
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780680393;
	b=xpoHwcUuzsR4XWaFLgkRbcuMekDhbfdt+FMPg5xZwmtWYPH8AlvnblfMVLjSZf4+m5TxsL
	c+4tlhI/+Bp9wkRwzVKVsC0NbOOlKCfLvJ+E+PyboE2zBHABhDdyS/sjlmbaCulKq5cbY+
	L2jCbug2oWZ187n34dx5f+EJ6YX49OQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1780680389;
	bh=I1udSyvjJtZNsTU1DKRRMlaA3SuRLgeegsMwVMcxdTI=;
	h=From:To:Cc:Subject:Date:From;
	b=QioEPdcf+nmDVP4XK23s0EgFOosVQ9Q6bpPnchrXclYBC+KkXCNYEco6QNvPYuO7x
	 xsbVeyqecQcv5d5PNfKnexqxPKoMFp+7ToItF/8nRlI8SQWXAcIM6Xq1BbB7WIz2cb
	 oUSJGlYz508QTwgDl9+PfMYHbD1IJXQkI6WaHlhYulLRObwDXT7Rb0Xw2QPj1hWbka
	 IppiKzq7dcwFoPBpbRAKEIn8aE6prSpDbB0PyT0TDz7a7Ra1lnxU7gUSJA7r/4adEo
	 BEV2vZacUiu0k/7GcweZgQy5TQ2IArr5+IGV2VTLrAgJ0nuWrb6yMOmzqXIR0/ASof
	 Xa/zS1BIoe/PQ==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id F39331F9BF;
	Fri,  5 Jun 2026 20:26:28 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri,  5 Jun 2026 20:26:22 +0300 (MSK)
Received: from rbta-msk-lt-302690.astralinux.ru (unknown [10.198.53.178])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gX7dT3xl6zJpKL;
	Fri, 05 Jun 2026 20:26:21 +0300 (MSK)
From: Alexandra Diupina <adiupina@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandra Diupina <adiupina@astralinux.ru>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
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
Subject: [PATCH 6.1] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Fri,  5 Jun 2026 20:26:04 +0300
Message-Id: <20260605172604.16034-1-adiupina@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/06/05 16:47:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: adiupina@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 107 0.3.107 575e75fe8e3b9d45c142d144823c5de38605099e, {date_rfc_vio_soft_silent}, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;new-mail.astralinux.ru:7.1.1;lkml.kernel.org:7.1.1;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 203696 [Jun 05 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/06/05 16:27:00 #28217824
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/06/05 16:47:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2C941A0004
X-Stat-Signature: czid1njjrjq6rw7aij888wdkomjgu4ou
X-Rspam-User: 
X-HE-Tag: 1780680391-612559
X-HE-Meta: U2FsdGVkX19Abupt/D2AjFuOiov8QaBO/HnnDYX5Gv/uVKrSaG7tNXiEht6ecS8NaDm4R6GZ1Pp8j4gUqAPv05RLxy9Z4lxiSWXHjV4zA9wRGwEyx3ZZ4SXdOL2YG8lRWIqT4D822JceASCWdcwWIm5LbJfS3AeoxdnAIVVGB+3wDnbhx5myN/hg+Vu3Tz1p2f3GaUgjGzrfmQIBQgsikR1f50woF66kYJCWJe6z7pqqFvBtutPZeWXAjxAoTAnCZv+/82EbpPeykLE54TKeONWo8/H6ThLMiPN4qjcY2OYAJubAy0Zdv9c6y1kQApRS3PbnnkuZlxJFyRlx+iQAh/6j2IipSPlNNhtqz2CcqCs6JFGmuwySYHNI19z1AKLXeT+vwujyGwI/gEOi9rhPiPxV42GdVjA5N0pdNuZJdDgHcrya9smNA5T5XwybRk42A+PUSzTb1JAkMPXLO2pJ6sBif1SSw0w8jLgNzpWszYtJfI8TWN2qhvkhHXboPbh0G3hZpSMjtmHWnjPLeF0ac8+bkQwAK3FAQS+PHd/AySFPBtuAIYhsjjNzzf8mgzK1WQz7waRGS8y46OZ/8GRfExrJ2JPIzeB2B75kqEWjoJ6xsLY9I6ZtjlrBW7BNXMtU/u4GQASa+HzJhZ/0SGCaph1tZ0N/tm19m+XpHfUocq2wnCNlmdFrlWPSISymXlXa2QqgaoYFhQq2Ta6C3ZCG2qqokpPW5nfb6sXoK2oij2G6E0vq2ArP5OVDUscR72nbl7HNHfbcRVJ5eJGD8huOc1kTwq19z9ZRRfC/n6qy6H9ThshTwKnzKwek8cNDn8T4r7ZhpB1cjwRFrAFNtdhzpxWz6MqHY32NzQxtAEnycod9g3pZ+J3FuV2v/VL8yBg+oqIrFdu1gigSRb1QChc5neKC4w3CFNNCU2v2vwG+ih3RkPg3gTUS6NETL1aieD1QQYxMrb1QiFOpVCuEr8E
 PPfaLlD5
 rlm2cBoSKkf6/8W/gQ5SzX5AxUi5CwQrWRf+b1+LVE7rkxZJyocoV6+oPyCPCFV+1++ZXAfDkAHnsmxdYFqJXQfDIObQg1UwA+uHWb4QIXEkS5mzgSx83w4mZeWLXmfq3A0JDMI4rg6KQabBOB4noYqpjmwqnPXGklIPP59oFwNBx7DX1gP9HSwgaTjwnfvA0zVmn6SEuO3IIj+is9BHKC9h3fjoWOXxB2SimIr3HVceorT5YdN1rS8vg/+gsG66WKbiP2BNMK1CWbiNbcOi2ztd99wjwXWSbGPpsZA0D1QCPSqyIPBRaERm/qTTDJEC1tamYri16SvXz9hU8d0nd7/qAB8jFdxeHHxh0ayYPd8aV0x3icJenXykf/kWVB9SyFISzOf8UxVs+hd6MCr2v4Bsabf2KAu+zQ8HNa1RU3CTfnm5yVaF2CIy4BiY+FtPWMXSPwVIvdzyEMKrpQTONptqRUmN3dhL+WJKLhBSI2i2ANaReDhQIPK0g4iY2vX1awdLXiQT11a3vBC+xLMCtIwpA/Tymx6zLcU3k7juh73JwvMgFsvx4DMxXkrkk1O5vvW/ovsFWaVWEppW/lbiZFx58bcwUdTl4HM7XShn/O/LEgSJgT5gtStEH8EvrpCV17mTSr/z507Eou6uu+TcTPjGiFd7H7dM7Ebo3rjc78jeTu23S0z4xt5KV3Q==
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
[ Alexandra: replace continue with put_folio label ]
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
---
 mm/memory_hotplug.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c8cc2f63c3ea..013db41f6ce2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1654,15 +1654,21 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
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
+				goto put_folio;
+			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
+				goto put_folio;
 			if (folio_mapped(folio)) {
 				folio_lock(folio);
 				try_to_unmap(folio, TTU_IGNORE_MLOCK);
 				folio_unlock(folio);
 			}
 
-			continue;
+			goto put_folio;
 		}
 
 		if (!get_page_unless_zero(page))
@@ -1687,6 +1693,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 				dump_page(page, "isolation failed");
 			}
 		}
+put_folio:
 		put_page(page);
 	}
 	if (!list_empty(&source)) {
-- 
2.30.2


