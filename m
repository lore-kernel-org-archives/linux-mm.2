Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15781C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F766B0093; Mon,  3 Aug 2026 12:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019846B0095; Mon,  3 Aug 2026 12:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71B16B0096; Mon,  3 Aug 2026 12:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD52D6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24A4E1C10DE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:25 +0000 (UTC)
X-FDA: 85060531290.09.402ECDA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28A5D140004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h3I4OPyQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SAzezfRd;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLRKQOwI7WJiEvMshK9BQ7DGGYsinDl7hpt5eENmCoc=;
	b=HvTdkA90vIHq7pqAu2ADcFD3mjSAwV9R6RG00YMpXu8WditMV6j6WpqHGzlnqIzokFmovK
	NXb06zKRpmEFb/l+ggM7tqtNOtEz0BOB6t7YKZR6Rsv/T1N7d8w91ETqG5YaQqxxFxfuf5
	3F8aF07gvPp0yZw5QLK93rNjV5W586k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h3I4OPyQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SAzezfRd;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775463;
	b=07xDujrso2acdimy1tS+JxZavvHJ5L7enn0KNLKssbhHiBAMJ+BFFDp0N1PWSeSOME8DId
	+D7bM6Ge/HNH0D2+mRA/6AY+N1kgNJ3D1t1GBzpj/MzpkhRQhoRMu3nDykhw+io5RLy39f
	KpB4MsnuJaJPYYhn4Wdnb6p2yrwqrMk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1A997F250;
	Mon,  3 Aug 2026 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLRKQOwI7WJiEvMshK9BQ7DGGYsinDl7hpt5eENmCoc=;
	b=h3I4OPyQasor+vcYWgGA36JKeTQmaWQvyAr5sYRA7P9gLxM4zAurUYIs+AIgquFpYzoklb
	7w52Pi76vf/h3NoiLs9/2z2uPBgHGr2tmJx2QV+Uv3ezoavRB/n2pEdnIGynBl2sP/KYGm
	tOV0jboSrLdzHzXuP7Xdb7rWj8G4CNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLRKQOwI7WJiEvMshK9BQ7DGGYsinDl7hpt5eENmCoc=;
	b=SAzezfRdkpajLsYmi0xGypBXWYHyXa1uTXjGpQOCflTceH2UQ97C2SJbGckUCzXlhJvb7+
	q0wWRCx5dys1C8AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05AAD779D3;
	Mon,  3 Aug 2026 16:44:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kJ7TOVnFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:09 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get() and ptep_test_and_clear_young()
Date: Mon,  3 Aug 2026 17:43:56 +0100
Message-ID: <20260803164400.531199-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 28A5D140004
X-Rspam-User: 
X-Stat-Signature: d6ggapebbaiu7bbjj815dfyr3arkxo8m
X-Rspamd-Server: rspam04
X-HE-Tag: 1785775463-529065
X-HE-Meta: U2FsdGVkX1+019JYz38fT7tDDaGF9m9/mIZF94PcuVukgcPpVuKblgflBVM88Mw03wz15r8AyaIKHJDMjz02uMhFuTD+TniWPwMjFd4k5qfR+C8hYi4Z1FdEafobxSlxffAG2GyGbWJG0RQUgf1dXwBxyiahkUv26EMbmSRsqagL3FID28yqEJ21goT/V2kO8CAmllHeBb8dlfJMxpLchzvQ5iwo0hy/IW/hBA8wCcNurAj2NfWDJSi0kXGKmmRtaSGJx4UyfD04vi46UmIrk6GqX503VSQUctiTyUj+Sl/u/cecXSIxeN1wfXs0JY9H7blgQEzyxsT19tk4h7o7pnSNu+gGug84U3F0oG+dxQRDaNqVkxyLFUQZ3g+kzC5Ry97rKruD2SR2Cx5UzDUQQuz55lxJXb3GPl6jNEm+Tes1HaQsKt2Qc8hw2ILUh89BgMvNYBdctoAN4IKwXt4YIxpmNZ24DBFUAg3l0jCsBWwU26aTssD61Q36RYrUgxLLWxVLlxL4+O1SyXGpcou0AEhWi3vWs5jRmjadd3QzWUfWty0vBqv50rpRgiWB4XIvvCP35LtQOrqY6dP/NyVdrCWotoUckUaEUg1b3D/Tc/1uEwXnXc9NMYuNKa60r5w6jk2a3e6if0ZvBpkT+Y/tCz355Uy+Ds6e2adJi61q7ksNhMzEVr2JCaCkXfm1zrPOU0oz928o9/86/9jBjUYqAealcMRKF9YA1GcyFVWXYXw3yOouaxTf7veIYChXOE/KQHjy/x2O/saf/YViJQ2eb9VtixBSdeLbpbID1s0v0xzuglATEmCCN7j9iyNTevTeWYx0z7/+rkkx4wRa7N2qhbYuh7S0w9jC9k8vcKomNAn4+oiJYWCdzj3dLTrCkGYGPNuWHycqXnekuZml3VP1sGQAJaNwZ6n79qKETAWEOAf3ljogcl8Jn3aIc4QlDbelkvV/o46j/hO5zEJ5E0M
 rBc1Quii
 Bjas9bCvGDh+sskRfCDFqL33VqAAeAP/S3KzFEmo+QyRJXGNQoDbAW9IKQqer/GNclSK2MFoUDmKFm+hjB/OkqzgdQfimI7xnPBTDF4xS51GO1XNmvBCs/j9qcT3m/BrRxL6pjHULa8g2V7dAyWt/W/d/j0O7gkzF7Ywo+1QXEIblU38h7Q+HcHusArF+WDD+ORKG/XMfaSWP1rLyR2Ximak69Q1G8F+g0F8WZ25e9LDtvtxXWbPYJ6Sq4b+MPTJ6cm/iKVkYCQKKeX19h53tBKNiDGvfsAfboj1Fj2+/iJvRdbBvXALoGzXIgw+CZSftHE+QeyjzFgHCBIwEEnUsv6oeDYzjy0aowWslcubx7zK668yEpszynVso2CxLZXEcsowcyjM6u/JcEiudvU8yCnVmEx/+q0PP56+1gz/jPVyhzkS/j/comWGoQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Helge Deller <deller@gmx.de>

Switch to the generic implementations, which are identical.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/parisc/include/asm/pgtable.h | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 467b8547ac8b..d92dee9fef3f 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -432,25 +432,6 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#define ptep_get ptep_get
-
-static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	pte_t pte;
-
-	pte = ptep_get(ptep);
-	if (!pte_young(pte)) {
-		return false;
-	}
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
-	return true;
-}
-
 bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 
@@ -491,7 +472,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define __HAVE_ARCH_PTEP_CLEAR_FLUSH
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
-- 
2.55.0


