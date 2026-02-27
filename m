Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029D0FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BBF6B00BD; Fri, 27 Feb 2026 12:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602F66B00BF; Fri, 27 Feb 2026 12:57:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536416B00C0; Fri, 27 Feb 2026 12:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 374126B00BD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDCA35B704
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:28 +0000 (UTC)
X-FDA: 84490993776.06.9B39D4C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88E7180010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uiv++dFAlObl1HHsG/K5OpEIqspmKksjUq9fFh1jeeo=;
	b=qWQsc3JsnZ13UOKOzQ4mgnohxp3gCRw20F8Q4NcZp0hm3QqQlqJG75dn29VJvDdtv4g5zu
	0dWeNVqyiQFd7OdvQ6uoVLfSYhc9jFr3lp6hugAeAD/y1R47xady6JV8N1gWEfaJ2OPk/5
	Db9t9c6mkYZE5YT6GlpsSVbL1XmOLSY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215047; a=rsa-sha256;
	cv=none;
	b=HwNOkCwK4xXH0cxH2rrZWWODDijQefuNF3+Wv+eVZMDsQVSdiQrfQUCuUVo6CLr2vKtUDe
	UtwT49UirhzPVHjnqe9KWTA4LVcuQQPbg/SNCWOsNYe2LcDVSWaR905JW28PCWFsKDt8+m
	U8EzyKMr2dqvWbAjpohT9RMT8KQk3js=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 737F419F0;
	Fri, 27 Feb 2026 09:57:20 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D8A63F73B;
	Fri, 27 Feb 2026 09:57:22 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 22/30] arm64: kpkeys: Support KPKEYS_LVL_PGTABLES
Date: Fri, 27 Feb 2026 17:55:10 +0000
Message-ID: <20260227175518.3728055-23-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88E7180010
X-Stat-Signature: bhxym6oc5bjg3tayxkp17xk957nsf1c4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772215047-325404
X-HE-Meta: U2FsdGVkX19KnX93exUOJT5V5CoufMmdV4miE18luN5nFf5CZl1HvmInhGTAstD7lwrUHXXDxFNtyq1lQv0D58qswGdh6gmWygCwCLAACETs2JkwgnBZUzN6kDBmRIh6rTodPkiQsHAXZmBYjNS8OJcJoEbvgqKwGTgATpzBrixcnzJhK7s2a5/tnCa6pmaxiEG4V9VfwFfkLt+zr12TjFPjAsHxCnu9vKuCEh3s5FrDfNR2ZnWC2qoW46hDZKHoS4+GqWJ2pDUu3sOnfHZjrzxR+t5Z5d5Qc1JjgL0NYYUqvsHY9pj6gk523R0uf4GQQQYHrzs96vBT3kN40dNnQw+/YqKgEC+8XJGCrA03k8nHr+OL97j3xC1SpbrJBjs3i63Q5E77JDd2lQrV0U72bnMrd5/Zvf5S8Olqh+uKksOmlMwFUGyeU7q9AXB6nqSuf44u2SRXF8C7Bsht8uLzMNYalRRgJD50N1ZGVozLrIS6PQ2Jhdbp9I8GjDYrXqsIqCxEQ69+eHk/Qsn7bG0q77K/5toWAc6F2WzxC1bIZj+AO2i1EFckmEJ2S5uD5+MYYGPHMIc1L8g6rGB49Ip7RlVjmApJNwztTUDhM38LRhkmbwAIHcQwUVVGSwAx9BDV7350XPWq5JWa94/h5NBcVPC7/B0qheOZUYphHlduqnlnoRs1j76FbZug+akGfUnDaZPWLaiUKUjkedi1dcIjj5ONBf1UrRNfyePVYAhnvA1WTTiC/WJCbgqXHbxRGTKJOR1vA6QvOjYMWdbgCaucDLKYfoYT8xMZvPrSDIqucDfN2DHEyHX8jl+e+wP7SKl6uDdLJi4FNLDfhBryaMp7J0KdFps2WCFSzcPrkh56tIcDsNf4IAtAU7h/LB1D2LbTdo5pikGVkE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_LVL_PGTABLES, otherwise only grant RO
access.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 79ae33388088..64d6e22740ec 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_level(0, KPKEYS_LVL_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -26,6 +27,8 @@ static inline bool arch_kpkeys_enabled(void)
 static inline u64 por_set_kpkeys_level(u64 por, int level)
 {
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     level == KPKEYS_LVL_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }
-- 
2.51.2


