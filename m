Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE616C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A186B009B; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBB16B009D; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29206B009E; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91FC26B009B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E40B71A0284
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:14 +0000 (UTC)
X-FDA: 85052076228.09.16C413E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B7914000C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ6SlBYF;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylwjoGycr5DOOXcbvTs4+kccx6KiZv9FJ+G3COdHNzQ=;
	b=Ue1wEEfDFlvbLBlRIhwD/ypaO6/1brKbaICcD/fuGYss1q/TBSaXCng2vXCsX654R11cA6
	4kD5NWHQGreoPfWKMKaaEpS97yuCm3v15Tiya3PEDejwY7cjrO5Sr2KvUpDDG26GeCH4Lj
	SjG8lDGciY9P6HgLNxcoj5UwnWcAnj4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574153;
	b=s8AdMDxw9ZbKidiIHNvWx+4FJmz1oj1bqvCq0ol7TTH68lTR8RRarKaVvOr2GlTT8HT0iY
	MjAWGAFRrOiShkC0WoxRdHl6rDFBL837LCPPssRx7XMwyd29DtBeFDa65L5M6m58V6Wa3Q
	+9DQPv5JDgqcdMAV8kw4TKK3WOCAyyo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AQ6SlBYF;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA0BE45273;
	Sat,  1 Aug 2026 08:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8891F00ADE;
	Sat,  1 Aug 2026 08:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574142;
	bh=ylwjoGycr5DOOXcbvTs4+kccx6KiZv9FJ+G3COdHNzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQ6SlBYFF0/S4H0nu6bTyPYJXJYPsBiRrSgqLt/DIn8TnDT/Z3VanXDvsrwCqgAFl
	 OSwvaok0Ge6ip+CQlXKNSf/fabsPtDQVUVWQiQhZayxVaeaekjUk6i6WPs0USyt2Em
	 cr52JYw7EsMbMWZfkmycb1HRU49SdALeosTOlvJ6fKFHzFkRo/ImCveewKI+MKYF2W
	 V1++B5+NF9aqIQ8WXZyiH78UhUFctWDIe6Kw3VVQi5JDsY2UHCGtZRwM1W9nNq2ziP
	 M+H1i/lCyhZIIt8ijzfZ+mslL7GXh94k5XgTjKQudUu4W6AvmOJ4gzUn4hBwL45rkP
	 EXdwjEMx+sj1Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/22] kho: return virtual address of mem_map from kho_get_mem_map()
Date: Sat,  1 Aug 2026 10:48:13 +0200
Message-ID: <20260801084833.1897543-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7keihzce6t8yr7uzyf1uh1mkg9tkebyn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B7914000C
X-HE-Tag: 1785574153-829288
X-HE-Meta: U2FsdGVkX1+egbSYjfFeftylibZ3eTWhVrbVZSpfyaJN18Lve09D3WZhfrC3JtN782aklpbGZuzK2RTBOMbp/9wCRN1xMC7PJE+28Qyns0qO9dJGfXaXMxvm5hWVYi2BVeGccJfd0u5Ov8MthahAkh18dMThXb38zDnliTqK2z3LMXzKwx50eXCTWJ5/whhSmifJ0bY1usbrkVHrSy1pWk4STpMN2o63nRaO1kSsYNbCFJr+pKhAs5g3miDVTHyfLpLsUhllDPTns/6QUosM9t+2iYg8XzsvllRfHd2DWYuLL6lA3/aA8tgiSnzOjFWUNC0rkfTMGpRL1qmzvxbRYkHM4vKVPyvmPZL08UaEwU0xl9Z+9mYcMrBg55n04932N/bdVAeCc8ykwkvjwufaDEg0nffj/Rzbybua5WWjoEeZLK6xZ7TBVRRY0l1mDFubAGvlvNQH+LREahHDt+zPtF6z/ybwAGTxPeEkO1Wthog68TGvSgHbpG3bh49TQ6OOQPEORwYIRUrlNzP62tA2CSgQ9GZZMoYLRlM4E+owewzPTRHzLMvVZ4T2rvHiGhBDZkJnKQ0dlRd7AoZPQKyd1GRtegvF07ldlJHqjzxCjoKNzi0cWDndE8zPFVsWM9DEr0c6HJZ/BkjPlc0LEDLWwSY7MJXjR2rTm+L1wqMQZh4+a7oY/0rsbHTCcL1zEKxGDva+CLWfH+TxYSd3fnZ4B0IGBofqZJvQVtdcRYZT0jLKrPOrHQ4UKTqja4J3k2n0St94/nRuHS3kOv2UuSRUnfDPBMMIFzWYtfF3IFtPoQmI7XoODaPvxlInxjmvVx5OOEFohphIP9rxfwrZVwM+kad9ZpZpl2K6dJI9Ei7ZzAP4Gh30e2+uLib1UVPe/KjLC4iGDPE8gdkN0yFCqoMCHotD3jbW2Rx9tKM6wMhWYMFcooozyrU4hSRsfdasih3BkgWLoaDlJEsmNdiBCIp
 8tLZEAux
 PbfijOhM0JVG2UIi7S1IT7CO+gT13xl6pel7h4bnsgpimX3UERsZNwadTrD8QSpjPM16rs7rx5wtTQJ3ZC6KOX0rWLZyQORaxv2dfyU4zsIaqbx3zxrZ9TZNrYU8splei9ccdAx+dzlCVkv2AieucG6S3wY8yPQU8qPmqI6d5ibCyorXwpnB0oRlGhYUqzpLPXda2dYHySY0LIW98m3i16atGRCj/00q5y1F6uez57NmU+jCKjjzekEX9mwcrW1GQr5eenbjjFhLPasxQBaJWiPJs3mOudvVtiYyz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory map address is returned by
kho_get_mem_map_phys(). It is only used by kho_populate().
kho_populate() doesn't use the actual value. It only cares that the
address exists and is valid.

In coming patches, more callers will be added, all of which will need
the virtual address of the preserved memory map. Since kho_populate()
doesn't care about the actual value and only cares about validity, it
can also use the virtual address returned by kho_get_mem_map(). It only
needs to make sure the returned value is not NULL.

Rename kho_get_mem_map_phys() to kho_get_mem_map() and return the
virtual address of the preserved memory map.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e7451743b87e..5c35c11c273b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -512,19 +512,24 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory map\n");
-		return 0;
+		return NULL;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -1647,9 +1652,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
 	bool populated = false;
+	void *fdt = NULL;
 	int err;
 
 	/* Validate the input FDT */
@@ -1671,8 +1675,13 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	/*
+	 * At this point phys_to_virt() doesn't work properly and so
+	 * kho_get_mem_map() can return a pre-KASLR virtual address. But here we
+	 * only want to make sure the mem_map is valid so the actual value
+	 * doesn't matter as long as it isn't NULL.
+	 */
+	if (!kho_get_mem_map(fdt))
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.55.0.571.g244d577d93-goog


