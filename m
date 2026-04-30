Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C66FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120146B009F; Thu, 30 Apr 2026 00:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F70D6B00A1; Thu, 30 Apr 2026 00:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C486B00A2; Thu, 30 Apr 2026 00:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E44386B009F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:05:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 910731B850E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:11 +0000 (UTC)
X-FDA: 84713882022.29.AA1D507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F10ED1A0011
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVHmp1Z+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91miQC+6ESWqee34eo4YVmoqoVtggz6DZAL6gngZUZw=;
	b=hJ1jhCDADx74xBOcXJ94onoq5NhC2tG3jahB8Sf7TV+XL0G2k5hHi3YXtSxzostxRerCda
	hnZe/yitrySx+pvfizbGAaKt4Ste6HDlI/iI0BgKsT/9teHxK5eR71IMVK7QU3CHKZkj2X
	HXzs3jDRmqO3DKbEjeBaTMA99jD0Soo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521910; a=rsa-sha256;
	cv=none;
	b=3kGTEN7u6Fl2+Z0FQTgafciPYoTFFZdv2qKcsTPlzpp/nwIwAcWnE101jGyVM4CEV1fl43
	X7ykdhaxfNfe4tyeif/GW7XoRMwxvDYmas4I5TmZRk73i0iQ8TDeSXGxRhTIzLpSv+jWah
	W30KgbniCz+Y2Hdo/kuvYWa2uTpb13Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVHmp1Z+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85F7B61141;
	Thu, 30 Apr 2026 04:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA2C2BCB8;
	Thu, 30 Apr 2026 04:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521909;
	bh=IOVfryRIB//G7TP35s/rdTIpoHZE33+XU/HgNFu89vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVHmp1Z+siadLb4Q4UHbDBBFXRgvKznPzVZgfJaZuDYbe4T7jnjjPpsDtJInwZIeE
	 4+I5FPsV3n+vKdFvmZlaVSvEPy/79jVItKW9FKiSkpofZcGT8gtPXTdJbnuWCRBQ7C
	 IotyNjhp+vK1JXwZXT1524wwOq3YNWA8MbefdUygDl892tC+sKqCeBWIognUzoFWBz
	 1ZfPBOz5ggtDlvNtoxkZ97/ykVcs4f1SLEbGN/iXyxKX9lzWM6c+fEG+I0aotBh4/p
	 pL2UOnf780mijkJBKnrAw7yfy8qSdrHqgtuQ3Q+6qcVgHDWif223rrlC6SFHrfHNEh
	 uuxK+cvO1oYsg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 3/5] mm: Move folio_lock_or_retry() and drop __folio_lock_or_retry()
Date: Thu, 30 Apr 2026 12:04:25 +0800
Message-Id: <20260430040427.4672-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F10ED1A0011
X-Stat-Signature: zezzec9mwb5upt19x355ecxatttehue6
X-Rspam-User: 
X-HE-Tag: 1777521909-329689
X-HE-Meta: U2FsdGVkX1+aS8wlmdOXZ3scDm+t6u7/CVSB+ixeWijQtORqd69zIC8cb6zVjBotbicWemlavx+fo/Ciim7AqEwOo/VJqfwG5KLln08cLnLXjIFrUWZc7qiRRfyh6ym/chw9nFStnDDmHZrWH7ttxSPrlTOJMhVrNH4LaHRfut3Hkit+0m/wIW5wkknxSKx1R5CUAl8ivHkkyMqJlvRr+JHWGn3e9ie3WO5svSLU1OqzLxH52xWTbdKOc1K/7RArXoVXlEOs9aS7uymeXVMLmzge4z4He4pH0ZJWm4+MbXwqHf926lcRyj2+70HV/EO/JWs6PlwzoAcuEwTwAL8m87wy5Szt+fhSvJ5IkbGiFy0z99i7XppSyS8sJncPgZoLOxyJiuIp0tGtkvO+cGl8d8vk+nqoA8jF0AkOjx9acMn8uT/K0UdeAEafwazAhtB1awDsVvRHf+BAuOL2Kb+xzFbL4Kt8xf/YUZR2OGWpj2esvliRScLJtAyPYPC5QB3ABuUHpUFsIVnQxFMuzKxm6+NjQfQh6ghz66cminw5ZAbnf03WKOlwR8AVDFVOfb0oQvB+KxSdyNXVYtLdsbKT0mF60N2MMiCgae7QDiAL/DZ8bQArrPed8/De+/FF+OBrrA4kJBhslg5rStr1jVBfrxpFbim7rnzg/vyxVM2n97JZvPAxbzvN4AoejYw2F0fYT2NbiJMnKUM7eBuskSsMcET1PvNZeRLYTi9Kgt0vVQeJE3DzGOKl5cPhQ+VlCqxDOWoXqjtBHmMejcyx2awjylXF/RZdw5N58BZ/c54UkjZWkOrMcIVE/bTXCT1L2O7ZKnrTjMjcMyECxPgqvBSZq8EPP3T/IeNxgjCuJvCeDMWsRjyQRUFoXwL6zTbSYBCU8iJRNb/r7R23pUImmggDw4AmnXj5xa8WtIW3mBv8blZnkpUNNf4aYCbfIPmB5/RY+3iZ44EsdoW2MxTpVgd
 fZGX7Y1n
 XPT+YfGPURy7QbGL7IdN6+WSg72aMgtsn+t2qy4l/9j0ChDSplTFDkLyLx0txY7wJ3z7aveEx4/1HSnsK2Bo4Mq2AuUe7nKLpaTkh/DYKQCXxB82Fo7OMITnhg7uFm2VQ+jjl27kuxRVZo+uHLyxBB7aNPMOw95D3gL3lR0eHxZoY3LpT6XdDrhjEYUT0RVJpBPpEgtfno4DnfH1VAA6DSJV41ETTaodDSV7nsNIUtuwpFXSVYToqKv08Ak8WoewpOxWAyj8sOX9k2RRu1n2JJbXNfHlEr5Mb8I3DzLAD7hVOTS5vdVK863iWJXzPsHeikPJr8HqRbPnTTpAOIp30/Dh6+0ktoghCEUYPlmBaybsjjYzolLanzTerAf/fiDlW5UB5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_lock_or_retry() is effectively only used in mm/memory.c,
not in the filemap code. Move it there and make it static.

The helper __folio_lock_or_retry() can be folded into
folio_lock_or_retry(), allowing it to be removed.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/pagemap.h | 17 -------------
 mm/filemap.c            | 45 ----------------------------------
 mm/memory.c             | 53 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 62 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1f50991b43e3..500ab783bf70 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1101,7 +1101,6 @@ static inline bool wake_page_match(struct wait_page_queue *wait_page,
 
 void __folio_lock(struct folio *folio);
 int __folio_lock_killable(struct folio *folio);
-vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
 void unlock_page(struct page *page);
 void folio_unlock(struct folio *folio);
 
@@ -1198,22 +1197,6 @@ static inline int folio_lock_killable(struct folio *folio)
 	return 0;
 }
 
-/*
- * folio_lock_or_retry - Lock the folio, unless this would block and the
- * caller indicated that it can handle a retry.
- *
- * Return value and mmap_lock implications depend on flags; see
- * __folio_lock_or_retry().
- */
-static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
-					     struct vm_fault *vmf)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		return __folio_lock_or_retry(folio, vmf);
-	return 0;
-}
-
 /*
  * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
  * and should not be used directly.
diff --git a/mm/filemap.c b/mm/filemap.c
index a045b771e8de..b532d6cbafc8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1740,51 +1740,6 @@ static int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
 	return ret;
 }
 
-/*
- * Return values:
- * 0 - folio is locked.
- * non-zero - folio is not locked.
- *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
- *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
- *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
- *
- * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
- * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
- */
-vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
-{
-	unsigned int flags = vmf->flags;
-
-	if (fault_flag_allow_retry_first(flags)) {
-		/*
-		 * CAUTION! In this case, mmap_lock/per-VMA lock is not
-		 * released even though returning VM_FAULT_RETRY.
-		 */
-		if (flags & FAULT_FLAG_RETRY_NOWAIT)
-			return VM_FAULT_RETRY;
-
-		release_fault_lock(vmf);
-		if (flags & FAULT_FLAG_KILLABLE)
-			folio_wait_locked_killable(folio);
-		else
-			folio_wait_locked(folio);
-		return VM_FAULT_RETRY;
-	}
-	if (flags & FAULT_FLAG_KILLABLE) {
-		bool ret;
-
-		ret = __folio_lock_killable(folio);
-		if (ret) {
-			release_fault_lock(vmf);
-			return VM_FAULT_RETRY;
-		}
-	} else {
-		__folio_lock(folio);
-	}
-
-	return 0;
-}
-
 /**
  * page_cache_next_miss() - Find the next gap in the page cache.
  * @mapping: Mapping.
diff --git a/mm/memory.c b/mm/memory.c
index 00ee1599d637..0c740ca363cc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4442,6 +4442,59 @@ void unmap_mapping_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
+/*
+ * folio_lock_or_retry - Lock the folio, unless this would block and the
+ * caller indicated that it can handle a retry.
+ *
+ * Return values:
+ * 0 - folio is locked.
+ * non-zero - folio is not locked.
+ *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
+ *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
+ *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
+ *
+ * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
+ * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
+ */
+static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
+					     struct vm_fault *vmf)
+{
+	unsigned int flags = vmf->flags;
+
+	might_sleep();
+	if (folio_trylock(folio))
+		return 0;
+
+	if (fault_flag_allow_retry_first(flags)) {
+		/*
+		 * CAUTION! In this case, mmap_lock/per-VMA lock is not
+		 * released even though returning VM_FAULT_RETRY.
+		 */
+		if (flags & FAULT_FLAG_RETRY_NOWAIT)
+			return VM_FAULT_RETRY;
+
+		release_fault_lock(vmf);
+		if (flags & FAULT_FLAG_KILLABLE)
+			folio_wait_locked_killable(folio);
+		else
+			folio_wait_locked(folio);
+		return VM_FAULT_RETRY;
+	}
+	if (flags & FAULT_FLAG_KILLABLE) {
+		bool ret;
+
+		ret = __folio_lock_killable(folio);
+		if (ret) {
+			release_fault_lock(vmf);
+			return VM_FAULT_RETRY;
+		}
+	} else {
+		__folio_lock(folio);
+	}
+
+	return 0;
+}
+
 /*
  * Restore a potential device exclusive pte to a working pte entry
  */
-- 
2.39.3 (Apple Git-146)


