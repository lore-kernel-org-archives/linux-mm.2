Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4CCCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3119D6B0283; Fri,  8 May 2026 16:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9476B0285; Fri,  8 May 2026 16:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A2E6B0286; Fri,  8 May 2026 16:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0257D6B0283
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:20:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0C7B8BA66
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:46 +0000 (UTC)
X-FDA: 84745370892.20.EC1581D
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	by imf16.hostedemail.com (Postfix) with ESMTP id E6571180011
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=sBSCOT0b;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.240 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271644; a=rsa-sha256;
	cv=none;
	b=HdWTMIJdXhVYHtk/OnmTkDsJ1Wmd9fW7zgNSlwFctMEBGqm3WLflo+OTUw18Me5lRiNVHD
	ZBbDhl0sxaJ3H+iQTqLAMZu/rBxFJn4z2V2bgG3VG2kOXRbYVpD4ZOlQ4zbl4iluFtH1Jh
	4DvLbaLoQtxsJ+DdBGYXpawSIyXFzJQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=sBSCOT0b;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.240 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjGDfOb5t/z0HQUZGodd3GW8KBtkUHKvNElfu8QNbQE=;
	b=wkEpDqI/6SAmC/PFCM+7sPwEEn1fnLJsS62eQFrQYTkjoR3jWT+h7aAB+Pfkl0DHA/B1Vu
	X8cUnxftp8nXpRx89UK3adY5C+4CJO1AV+OqQ8/0vA2O3zj7OZr1FDVm0XGTj7CqJ86hqd
	DuayE0iF1Aj+BuOdk88IZTw/qlMr2zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778271641; bh=PjGDfOb5t/z0HQUZGodd3GW8KBtkUHKvNElfu8QNbQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBSCOT0b/77vwF5HPU7J7ZdQHdzbY6u2kNeJCqAMKENJstNKssiZAyIkrBK/6iegW
	 NVP+1gc8v6oJJAzzCanDNwM+e5b1qubFy6xxn+TGXXZhZ+mrPMawphrfnl4hb9ALa2
	 Rsm75Mm7fr/QNpnNEKujGbbXcofv0dQzwXSwXhVE=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 52124024; Sat, 09 May 2026 04:20:33 +0800
X-QQ-mid: xmsmtpt1778271638tjr8dbo19
Message-ID: <tencent_69E7E93D1E47766E922D48B9EA9FD1140D09@qq.com>
X-QQ-XMAILINFO: Npv5yIQT4nxMH8Drs51QFZOeh0A9puObyTusyC9D93b6utLw564wsyCMzyOtNf
	 kjO75MLkPkbvgBxqdy13laTpj2lboU00WC/pXpBrLBoE4JzEYTyuiUzWNgx3SZvil/V4/mrvUGRT
	 jqnc/9yJH+aB0V0NiPmFLqN0BwnkgjEdLofGZxyJ9zVJ5UDHU1VFrK/4fmqfH9W3dKCwCZutl5bg
	 3LYZPZUYDwAFyn3Ab+Hzp6Dv02pJr0dgkC7JDBjU+iZIaisXq+30kl1xTaGy2PfRHDLa2RDMGWQZ
	 Ul4QxDgnCJPVanhycI0tCuS5hExgjOl3H31OquQT2w2xrxDlj/4FGBUhO6sq1G9c3EBEakUtk6j+
	 Zi9tANtjkEJqYhCza0OzwfE0/SqQbKzRaqrY1EFci5HGCsLJK2vAU9ysanCl/BbYStMhT6MuQWYD
	 L3pEeU5BaU7/PqrBec5I0+dwRM9xpRee5vzhajJhmX2AGhndD4EiB9ru46QjOPBG5/81s/tQJnBx
	 uLVwwMT+byuyZttJkv3V2VRbjMn/dQV88530KjCcsuH0O9Dtwvcad3iJJdeZQ+CWc8cxUFVagVX6
	 0DMo/3O8Nr48i81Pn+bhT6avFi7S3plGed1o3+Wglxa+E9o1EBdTfN/dJrRZD0BG1XldQroSFGDd
	 fCn3M0cOyaL7m1g2ahtq1xVdhUE3ULlVamVxp8n0but+Ryq8uaiQr6aOev2IBYUaP1eHUkgAxN3D
	 Y7bSiK/2jMRmJTpQ0eA56g1JiXj0E97HkZfFiNoMsZ6RsDtDbkeKxA5F1sLlZRcVxfU/lnAwGCL7
	 J654qEecFSdrI532G0RoHU+q8M2sy8Yd4k6jggfT/bSC9uhQko/BblARXd+OWd7+WiaHz50tw0qD
	 j8YEGz5SM3iiDr8xrkdcgKKo3XKbH/56jMg7wc+GJmPPStZVFkEeNf4YB+d2zlX7URzIARh4nfIB
	 jZSODjYY3BicXVdtWJ7+Iw+PKp0RtKSWNlnL+6eStdHy+6BqVB6kg8CHfUsQS7STUBuDmUPWDms/
	 1A8WsshFyYrXxvSmKxk7JTSxqgu3yy5wcCJ/9z3g==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 3/5] mm: zswap: load fully stored large folios
Date: Fri,  8 May 2026 20:20:31 +0000
X-OQ-MSGID: <20260508202033.1834876-3-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sa1n41h7x8oc5yedffgjssq4t1j7qq7s
X-Rspam-User: 
X-Rspamd-Queue-Id: E6571180011
X-Rspamd-Server: rspam07
X-HE-Tag: 1778271643-671467
X-HE-Meta: U2FsdGVkX1/vVjuj+PrtDGcY8rHlp7q877qixg34SVKKA5zwjPjc/SHy9j7le4HvDco6QwQXGMCvWuJWYBpSDLk7cAgqOzPsT+Ycfh2HBnujbECWs+JmTBR18L0yRedWc4blo6tDnLIjfM7ZJxFkoUw2/wzL85mZdn0mtqLqah9XJyqyeU+oMHcuWLvBeFTlHwhb6wibkCZUYLH9Mzr8uC2tvtQCjHL8R4mE4fvos9UM0/3yOv3HkxXXNF82BgqoeXIgNMOxy3Se4NGzjEww6OCeQx5g9Fq13QyaesJla6t15n9dmVJbhkUjfvBayQcloJ+60gH7mQHUHiADn37wvJ2L5PVVKDcZGMjdUPYHONnPpVFelq6X/MIPHa+yvt4AhbaLO6as1x3fGtZ7sVrtt1Li+8NDxQUZRa0GtnC6f24QKULAnBKsh38D/k5y6j1eTGlpOuB5rFJhi3LmWelRTMrYi7dLOEL+s9rgin0zZyDU+9kfD6BeM8BpnnqzPqfFP6d8+bMwShadWggNt6djG6eqoyxAagWCkwXZRN+1UOwb2hub7/l4ZIdM6Gv7qYc7BaG/KbUX3IMA0wv7qGxzID+O0sUjjdEI6Qcut5tKtyw/EwlrfZUZ5oPPnTrfTO/U5sEqUHq8Zt0Ie055XGGwrgn2jMsDQqKIVqbuPR34PIqPQuVbK87DrxoA60W1lgAn0VKCVCVI8tl0hGN7W2C977K/yXm7QQnFiFRQwaA/RG51giAQS/xum7ixJmIMovkoQ1ohBfJyAPKipRVfdzt8l/q8TLpeFtNTEYjr0z7zFQu2jkHgHqZiSaqq9dNGi/JeeuPyHRXrq57bOIrp/lhiEu4UDPGSV+DTO2GpCH938cUEobZYeRWJ92ntflcLb8RIaEtxkYdaY3U1vkFY432vZdT4zDCtYboyNTEVbIbE9h5B/FubSFjAOga5FPOCqh92wv32gtYDC6eZMtiUj97
 OXrfy64C
 SKxMHMPYy0MVi51VDJh0ScAzscVp6O8QYN8DFPbE/uiMU4SXpLWyAL6XrTdoxa/jTVPo5mLs2128+WqJUTWnEYMR8xe5J6zHhwom0DrRwfaDIZ6yi+2NkQllL9OkhZgBDLMBBwI0hDcp0WOZvlRgzQ/aEYqmmwgVzr9IoE8WJgw4XG0oY2/ftYsakENaweb1HSsjtn2tJ0By1HnxdSFfzHhICNlHidp3ibQDj7vYBKmjzKsJ6pfGN/Wl7lBDGEOfLhvdbpvwBkTYmn4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store() already stores every base page of a large folio as a
separate zswap entry and tears the whole folio back down on store
failure. The load side still rejects any large folio, which forces the
swapin path to avoid mTHP swapin once zswap has ever been enabled.

Use zswap_entry_batch() to distinguish three cases: the whole range is
absent from zswap and should fall through to the disk backend, the whole
range is present and can be decompressed one base page at a time, or the
range is mixed and must be treated as an invalid large-folio backend
selection.

After all entries decompress successfully, mark the folio uptodate and
dirty, account the mTHP swpin stat once for the folio, account one ZSWPIN
event per base page, and invalidate each zswap entry because the
swapcache folio becomes authoritative.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  4 +-
 mm/zswap.c                                 | 65 ++++++++++++++--------
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 5fbc3d89bb07..05456906aff6 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -644,8 +644,8 @@ zswpout
 	piece without splitting.
 
 swpin
-	is incremented every time a huge page is swapped in from a non-zswap
-	swap device in one piece.
+	is incremented every time a huge page is swapped in from swap I/O or
+	zswap in one piece.
 
 swpin_fallback
 	is incremented if swapin fails to allocate or charge a huge page
diff --git a/mm/zswap.c b/mm/zswap.c
index 27c14b8edd15..863ca1e896ed 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -28,6 +28,7 @@
 #include <crypto/acompress.h>
 #include <crypto/scatterwalk.h>
 #include <linux/zswap.h>
+#include <linux/huge_mm.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
 #include <linux/swapops.h>
@@ -1614,20 +1615,23 @@ bool zswap_store(struct folio *folio)
  *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
  *  will SIGBUS).
  *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EINVAL: if the folio spans a mix of zswap and non-zswap entries. The
+ *  folio is unlocked, but NOT marked up-to-date, so that an IO error is
+ *  emitted (e.g. do_swap_page() will SIGBUS). Large folio swapin should
+ *  reject such ranges before calling zswap_load().
  *
- *  -ENOENT: if the swapped out content was not in zswap. The folio remains
+ *  -ENOENT: if the swapped out content was not in zswap. For a large folio,
+ *  this means the whole folio range was not in zswap. The folio remains
  *  locked on return.
  */
 int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
+	int nr_pages = folio_nr_pages(folio);
+	bool is_zswap;
+	int index;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1635,30 +1639,36 @@ int zswap_load(struct folio *folio)
 	if (zswap_never_enabled())
 		return -ENOENT;
 
-	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
-	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
+	if (zswap_entry_batch(swp, nr_pages, &is_zswap) != nr_pages) {
+		WARN_ON_ONCE(folio_test_large(folio));
 		folio_unlock(folio);
 		return -EINVAL;
 	}
 
-	entry = xa_load(tree, offset);
-	if (!entry)
+	if (!is_zswap)
 		return -ENOENT;
 
-	if (!zswap_decompress(entry, folio, 0)) {
-		folio_unlock(folio);
-		return -EIO;
+	for (index = 0; index < nr_pages; index++) {
+		swp_entry_t entry_swp = swp_entry(swp_type(swp),
+						  offset + index);
+		struct xarray *tree = swap_zswap_tree(entry_swp);
+
+		entry = xa_load(tree, offset + index);
+		if (WARN_ON_ONCE(!entry)) {
+			folio_unlock(folio);
+			return -EINVAL;
+		}
+
+		if (!zswap_decompress(entry, folio, index)) {
+			folio_unlock(folio);
+			return -EIO;
+		}
 	}
 
 	folio_mark_uptodate(folio);
 
-	count_vm_event(ZSWPIN);
-	if (entry->objcg)
-		count_objcg_events(entry->objcg, ZSWPIN, 1);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
+	count_vm_events(ZSWPIN, nr_pages);
 
 	/*
 	 * We are reading into the swapcache, invalidate zswap entry.
@@ -1668,8 +1678,19 @@ int zswap_load(struct folio *folio)
 	 * compression work.
 	 */
 	folio_mark_dirty(folio);
-	xa_erase(tree, offset);
-	zswap_entry_free(entry);
+
+	for (index = 0; index < nr_pages; index++) {
+		swp_entry_t entry_swp = swp_entry(swp_type(swp),
+						  offset + index);
+		struct xarray *tree = swap_zswap_tree(entry_swp);
+
+		entry = xa_erase(tree, offset + index);
+		if (WARN_ON_ONCE(!entry))
+			continue;
+		if (entry->objcg)
+			count_objcg_events(entry->objcg, ZSWPIN, 1);
+		zswap_entry_free(entry);
+	}
 
 	folio_unlock(folio);
 	return 0;
-- 
2.34.1


