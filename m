Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82717CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6806B009B; Fri, 29 May 2026 08:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304446B009D; Fri, 29 May 2026 08:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DF66B009E; Fri, 29 May 2026 08:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 019366B009B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B85FF120108
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:42 +0000 (UTC)
X-FDA: 84820363404.26.683E8E6
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf27.hostedemail.com (Postfix) with ESMTP id 23AB84000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=BzvFiQIv;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6upOtVdcSMEiWQj/LoAhI+cSqrQul/bXobDwKNZi3uE=;
	b=1erpc52cGJop3TRASXSQz7lTFTa+jXHwftk4QEqznkunCQEMYOHTkU1+5GYwbFRHTXbWhC
	td5b5z5pGJ7rkIUGPvbKRMLbKMUHASj83etvbzZ1oo/tgv1v7lg04wDeAInuuC54mESo9l
	I2n0MWuwJcNhqOD6TBJJ1DJeuGERw9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=BzvFiQIv;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057179; a=rsa-sha256;
	cv=none;
	b=WKrg4QlijNOzmJ4s9MFmqmUCDiRViovqNAT813UN0BqwWAEynj1/cK3dkLgGTxv3LXxgwq
	ZStmZY1tHB0czcFYz64eO5E6jjYh0oZ52GbSjEqMDoPnPhmALaoHVFQwjjG261hEoJFVOm
	dtVCWQDRNmhhHXWNtHYtozHm4XDavyo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057173; bh=6upOtVdcSMEiWQj/LoAhI+cSqrQul/bXobDwKNZi3uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzvFiQIvEF5lRfApXuRIxXloyfW601cGekF8ReFj0UlHXWD9RHUFiEFDrLk7GXs1J
	 7at9eI/Y2ppncPSORnYgaR+zy2U5HhUJ6SEq4ztojqt0LsG3nv10NrU73s7W6HLBiQ
	 UPA5LeF5x9NJmz9dXdOA+uSBXx+lGhzGX1PXPY9c=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057170tklm0azzd
Message-ID: <tencent_930D3FD72B2ECF2379248F7CDE48587C700A@qq.com>
X-QQ-XMAILINFO: OOyEews/EdUgGrC4kGz6V3LDdcHDMeu94hgH5yaIgtByJKumzwq6uB/LtnUX5R
	 NhmcZbGtYlmURp2oM1N69k54MXOemCKwW531GwD9CHAQzgSkdUfQ+G51ao2t9n0h/ek1cueUGZjv
	 oGf/2fN8/9HbK/4I7fQiyEx8TguKH2lXJAqD5ocJy0zjJndYW1p3bgE+aGbYgGe0+2e8w8vW48PQ
	 rRQZVsbVSa0bCZbTax1zSG7ZZchB0vywtSbJ6tG/A3/vYjfJDm+89dV+PmTkiLLqaUDv07/yeUmn
	 0/5BKilNIWIrY5caenuAr1qohxZjapyNZ4QcShN7K/ILv8ed0HZFwNMDh1YQBBg3TlI7sbOk39yX
	 J9rrE97T7IMgYlE7UFzBAjsHGUH2opi9VGznwyWyG/nI4Ju+6CrOJwt71y+wlKAaCB2noNv+cdfC
	 BL/Yw0pSDCNLsShxYtCEZXadUKNPMjD//CTiHS8I17KAZdhrCno6NX8i+3NWo3pe5vYwGWsRzEvr
	 aAK4L3zS9JQiEVCcbzT+z0QcWKEcmYP1e7vuaWrWKg6Y+Glkam4raxVypRdI9qQJ6CV1VWRa0+ir
	 wxbY1ByjmCzt5I2poqyT13EiBvgoSUcFuLKlTmvfVai43SZ8MDefdUrtZGTI8qme/WsA5xHIyMYC
	 zYIUFPT0vCMiZp2sPWJHdDAq9r0sPFCp4bnfd98UkPA1m2MiGpokbzj1oxVrz4f4YR59fn3VAccP
	 VYzyHyoORAeyGMnUahdrRLTbiZfyC3vlXlOMFzPrKTJ6qL3qS70aHdxHzO3sJE7TQrwcNTOAZLzy
	 Inbj/ucF6w9UcFL3ZN2YqZbCsnkMRIJe5GiBw1SVfjxF+Jizz1UDAJ2NW2mEeBbat2GprN4ATd2P
	 MHAV1jsF1QK1QVY92ZzgvKj8vKvqjDuFl8NjIcw+y9b+yxM0gxI1/N7lXLPHXZUuVJmjOGH7wEge
	 VcobaFqn0REtwLVTc/GIFIHaW3Jni9Q9p4irGdaGOerWpqZJDNEnPhVaDf47gaxpibaSO/frPnma
	 Aoj/hz08eLwq61sqEVp+hh2pCt0nkXSjZ93AvWh1h+CN5Dd7Dw
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 2/9] mm: let swap_read_folio() report retryable zswap races
Date: Fri, 29 May 2026 12:19:21 +0000
X-OQ-MSGID: <20260529121928.4115683-2-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iszyayhgg5hjmafbwbng4s5h7fm4qq5d
X-Rspamd-Queue-Id: 23AB84000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780057178-2097
X-HE-Meta: U2FsdGVkX1+Tujz/tuoTm5jQjm6/lCSDkwCAT/4eqF5isqPzeVT7/Gu76hlC58gOJyoDkb26QZ6Gu1folybbKotvrTyHbPvtXlKn4Gzf4luJqBRAUXovN7sH6sMsQB8FFfQ9NvHJ39PDmYRttC4l/hbd3oZkdZWm1AceD9iX5yM5BLwV2x0QYiPKWUv0MpdRU6bmB49K6Al69W4z9SFgzFDjHoiO1B1GIU90sCbIWW2lv0znd6N+vvC6/o5z16+B8Fx9hcShHzZ6g9OIuBz+Kv88LRx3DBpDlPU3KbOuXriZ+h4UrfZpEMceQg/DqP3yO6Qf0PkfGX1QlPay4xLgi7TBwTgw8dWHnIocaqMyKx5UHjmLKHoyvd6e9yMy9sQSDi3O6w6tis6u9DpRHGOWlxn8OR1x+UCuEXax6sCzU+sd6cTiUWeaPzrNRJ7CK907zvNW2ZMoZugjLC1b9bw9EtEygO6S3qnxJmz5sWYGO4CHIj/QaE1ON4XzVd2nli+yeKlCWeN677PBZC9NHC1/pU5JJFm7vu0EmTbPoU48ZtK4Dt6L1yRVD5TG+5YeXklvQo+mMQxNN6b8boipx6lJPtSA3CAYzSckhs30V5IkhxuIG25lDHSbquCIYqgiRgQCjRETNqRKVKEb8UTWHciwJMsX8Zr+Ar+lElU3Kt1Hr9GMhey1yV7vt5NjQWzqH5tU8GB9o6qmSKqhLtEPTR8D98Kmb3qRl6UYJCmMKELsyua7kvVUE2hxYGF/FS0o3l/in1369gnEEBJNoWroFkU+PCoIksmD1v3n/V0HAymrW1SgSL5/CNoqk6WLtfYZ6jGzrSVXrW633WVowSnCS6/Kx6OXoo2e5z72lZgjtkMFQUSqwNIlri+CD0QinbmWt4s3lawDqpB8GWeaONzb4q2qdM+D2O/ZnSxAdelpDR524iG5n8C57SGr2ieODsXVNGEmcCjto7dlH2RHwXZRMkI
 yeQ1Hfsh
 oPZGUa0IIbvup6FwyX7cVBPNisB+uu5jj/d/zP4sV5iRfu9immw6K1qsIQ9ladF4LXymr171A5GV0dpGStXUuO80YNppLuChTOSfC4Do+RG0r8otUtD/7aJ8Ns+a1qwt/RticMZzAEcifqU1HEzVWANAmuCzuX3ryTPcBbfHJr4KeSPS9hH+oVcFOF3yh9VMIPV/ZKo4vBhPc8ZozgScGplVAVFZOPP4w0IGWb3pROTklTxhQvHsYMTz53Y8mAk2tHunQ1T+Tkt667I0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large zswap loads need a way to ask the caller to drop a speculative large
swapcache folio and retry order-0. A void swap_read_folio() cannot express
that without turning a backend race into an IO failure.

Return int from swap_read_folio() and reserve -EAGAIN for retryable large
zswap races. Existing order-0 paths keep treating the read as before; the
synchronous swapin path only warns for now. A later patch will consume
-EAGAIN and retry order-0.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/page_io.c    | 19 +++++++++++++++++--
 mm/swap.h       |  5 +++--
 mm/swap_state.c | 13 +++++++++++--
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index f2d8fe7fd057..16724bdfb400 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -653,13 +653,21 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+/*
+ * Return -EAGAIN only when a locked large swapcache folio hit a retryable
+ * zswap backend race. The caller owns that still-locked folio and must drop or
+ * retry it. Other zswap errors are still reported through the usual folio
+ * state: the folio is unlocked without PG_uptodate and the fault path will
+ * turn that into an I/O error.
+ */
+int swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
+	int ret = 0;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -681,8 +689,14 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 		goto finish;
 	}
 
-	if (zswap_load(folio) != -ENOENT)
+	ret = zswap_load(folio);
+	if (ret == -EAGAIN) {
+		VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 		goto finish;
+	}
+	if (ret != -ENOENT)
+		goto finish;
+	ret = 0;
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
@@ -701,6 +715,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 		psi_memstall_leave(&pflags);
 	}
 	delayacct_swapin_end();
+	return ret;
 }
 
 void __swap_read_unplug(struct swap_iocb *sio)
diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..ea7e1f3c4410 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -241,7 +241,7 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
-void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
+int swap_read_folio(struct folio *folio, struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
@@ -381,8 +381,9 @@ static inline void folio_put_swap(struct folio *folio, struct page *page)
 {
 }
 
-static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
+static inline int swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
+	return 0;
 }
 
 static inline void swap_write_unplug(struct swap_iocb *sio)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 04f5ce992401..d37097913b30 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -628,6 +628,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct swap_iocb **plug, bool readahead)
 {
 	struct folio *folio;
+	int ret;
 
 	do {
 		folio = swap_cache_get_folio(entry);
@@ -639,7 +640,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
-	swap_read_folio(folio, plug);
+	ret = swap_read_folio(folio, plug);
+	/*
+	 * Swap readahead allocates order-0 folios. -EAGAIN is reserved for
+	 * retryable large zswap backend races and must be handled by the
+	 * synchronous common swapin path.
+	 */
+	VM_WARN_ON_ONCE(ret == -EAGAIN);
 	if (readahead) {
 		folio_set_readahead(folio);
 		count_vm_event(SWAP_RA);
@@ -668,6 +675,7 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 			   struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
+	int ret;
 
 	do {
 		folio = swap_cache_get_folio(entry);
@@ -679,7 +687,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 	if (IS_ERR(folio))
 		return folio;
 
-	swap_read_folio(folio, NULL);
+	ret = swap_read_folio(folio, NULL);
+	VM_WARN_ON_ONCE(ret == -EAGAIN);
 	return folio;
 }
 
-- 
2.34.1


