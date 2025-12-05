Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117D4D374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F1C6B031B; Fri,  5 Dec 2025 18:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100A16B031D; Fri,  5 Dec 2025 18:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2D96B031E; Fri,  5 Dec 2025 18:18:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D878A6B031B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:18:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E2EEC036D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:11 +0000 (UTC)
X-FDA: 84186982782.06.1E9C88A
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id C78AE18000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cKtcg3xR;
	spf=pass (imf06.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LFA2Xr7fMcablqz8itIRhQ151XIAZCDEKGvR05eMEs=;
	b=GDAueq6jzV8VSIQGyW6oc5Un9CIM30LjCWs3+YhufWT8XwpxtEobLexVbkuA7yRZ/f6Lqr
	ITQA4qIF/H1y4tUHN6RosiVU/uI40BSIAAQc1hSUH/ETJEL9oka8chcKCP6HgZbJ7OLhI/
	VwH5MbFJ8p3t0qAvPGhQCTeRjDcLDKI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cKtcg3xR;
	spf=pass (imf06.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976689; a=rsa-sha256;
	cv=none;
	b=dU4KMmx1SKm/xqjGjEm8pRSZijaTy0EQDCQ7DRLf/t/poYXIfJpLY1zYykXIbWNgDCYzyt
	D1q/IH0Pb3GdtqcJ1ArjLokqp0QpQG0yPZkoTlAE2D82YhX5E98HpOGkzzTJA8ADRUjxNU
	JMeNlTc9ceGfm2u0qIFFBVJum6kK9aE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4LFA2Xr7fMcablqz8itIRhQ151XIAZCDEKGvR05eMEs=; b=cKtcg3xRejri+aQdtkKyLd9t9N
	2gbD13UjzVb/eq7Dtaj0Si9lRXYUo5xPQwNVwXqTgcUcggvPnCTIsnVcP/lJHgFyrw9e+j2YG8ijd
	fdUede/irfHVXPxKwpO8qmXNopCdGDhhiizfr7su/joYk5dGBCPYJzTPgbFjGeLoCGUN1qETxKJMK
	9a1/N5DKH03U7NWAYPZVn7vpglikIhkilY2CcYz2L6AtV0WSAQLFHbjINi6zP3fmLaLDW7KtEMDCM
	D03yXQFO/AOInHDW8ZFGNBq8WPumFqLckFm1DxRG45xKgeU7RmzlbHNvNRYrM06qarIyCKUGIj78i
	rkKkzxUA==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3r-009H1j-8q; Sat, 06 Dec 2025 00:18:03 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 9/9] mm: call page_owner swap hooks from generic swap hooks
Date: Fri,  5 Dec 2025 20:17:21 -0300
Message-ID: <20251205231721.104505-10-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cnzxdht4qyai39bd34cm6ojfyffht7y6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C78AE18000E
X-HE-Tag: 1764976689-853270
X-HE-Meta: U2FsdGVkX1+rW234kVB54UMXYJe8Tvba71Xi1/jsGSkuo06utQTkIW5Vi3DXm+anU+Gx7lQ5v3b4qivRGq2bZ6aa+DAZAE6wW7ipEueD9HO/zB/DFIILGRH32avc5pSfaAKTThDl/h+b1s+wKcaJwNlnSA1/l3R+9ZrfLd/jBiLltNWS4u2JhDiyxYF5kUG+Uqu3E8WEtzD84X+2lrJRfMn+7eHo+VX/p/JD6AvPslf1ATd+lhMi7pHUoupX3iyQhbXjXp9iYzlO9nPQ50Awc0Sl889ROhTM933/ikKGV3DQcacF3YBLu7UivSBszAFE0Wv619OJ+mHvHjqMqcQLqaG5ESMzo8M//duC3BnM00+1RvyOM4wtGkONIIF68ZEnyk1aTIyQ0XcA0Y+Z2kdYCt5QKuWEA6M3R6zDTf75hx+Eby3GdskSqwZ7y6C3KUyQ0nPR50Z41TzHqCWukrxETnSEbGANB7X/G62FAUDZ274CkuxWUDWBsp0VgI3WXT72tpr2RsgWVP/dSc39cR5+WXX26vqDfTkm0IeD27UOKhBtTmfhUuiaDEBKQlp8wvVMQkIOgSXeflx5yPikVCBNu9XbxFNIZlYX+nF5J22VnuAnUYWQuspQK9pZgvFsKyRewTE/3YTxFmhc2ymdAFHEVyO0NG4+9z9gS3qMStsVej44qKirl2EygLneooBOiWRSU7gcLCSYQWFskw8ROV2VaHT18upZbdeddJiAH1dxiXY6PKz/NtANUD1Y0qtZtWzH3sSaeUjtIcpNGMwyaFpxN8cARE+fBoXBkzi7ontW4WMLHdEi8oRyj/CuF8ec1zNkMos2f3sMy8jMyutOl/fxEZtaIcfLfWXDdyGKkzPHqUI2ZYDt6pULUdzVDpcgfljjaDHfvdd/eGhkHyPXLUTnjyihx1u4Zpha08m+llg8VHzRrGEhyNC1fMY8PLFcdUqxvQtLYZp83lbRc1QC4dH
 YCD8cbu/
 tLAbzhm4ZByGkTLWkopckyTzPKma9a2XOANq/AVp9fYuEhqe0X3NlyZSgjzRPHMSJl+epUluEG57i6Pfd/uyeT7DFd9I/BYxyYJSYlXlT2MS+fodL/dzBUORYoR+FzOgxEm9XBSmDFdAg2Ozsv5a/tZdSWQ/vTlqtga34hK4+v7oLBuC3btEp9sPgeg98PfaBsJ1sjtu4HzdDxOO7MQl58JX6cVFek+H4zDm2AgpwfpW3eUr/YG4tYWsF4TiG1Pn1HrfdqZauH/A6C6wD+X99jw/PEBb7KVu4xHBR/w3B7hqSVDpXKN+0tcOkP4SqxjuNs45AIobBJ8a22B8VkoVyTnTGH7ao2BqICWo/ulHyEfz2V7pghGfEKi49DzC0x65/Z8pogr+TpvRvuchz11QSvbLGxC5sAkArYra2lL14BjAESyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Finally, call the page_owner swap hooks from the generic swap hooks.
This plugs the new functionality into the kernel.

Add a missing include in 'page_owner.h' to fix build errors in files
that include 'pgtable.h' (thus now 'page_owner.h') without an earlier
include that provides 'pg_data_t':

    In file included from .../include/linux/pgtable.h:19,
                     from .../arch/x86/boot/startup/map_kernel.c:7:
    .../include/linux/page_owner.h:20:41: error: unknown type name ‘pg_data_t’

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 include/linux/page_owner.h |  1 +
 include/linux/pgtable.h    | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index cd95aacceba7..d7029d1e41de 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -3,6 +3,7 @@
 #define __LINUX_PAGE_OWNER_H
 
 #include <linux/jump_label.h>
+#include <linux/mmzone.h>
 
 #ifdef CONFIG_PAGE_OWNER
 extern struct static_key_false page_owner_inited;
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 23d30afe439e..ae397f5884d5 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <asm-generic/pgtable_uffd.h>
 #include <linux/page_table_check.h>
+#include <linux/page_owner.h>
 
 #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
 	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
@@ -1222,22 +1223,31 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 
 static inline int hook_prepare_to_swap(struct folio *folio)
 {
-	return arch_prepare_to_swap(folio);
+	int ret;
+
+	ret = arch_prepare_to_swap(folio);
+	if (ret)
+		return ret;
+
+	return page_owner_prepare_to_swap(folio);
 }
 
 static inline void hook_swap_invalidate_page(int type, pgoff_t offset)
 {
 	arch_swap_invalidate_page(type, offset);
+	page_owner_swap_invalidate_page(type, offset);
 }
 
 static inline void hook_swap_invalidate_area(int type)
 {
 	arch_swap_invalidate_area(type);
+	page_owner_swap_invalidate_area(type);
 }
 
 static inline void hook_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	arch_swap_restore(entry, folio);
+	page_owner_swap_restore(entry, folio);
 }
 
 #ifndef __HAVE_ARCH_MOVE_PTE
-- 
2.51.0


