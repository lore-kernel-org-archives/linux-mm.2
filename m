Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC28E60A3836
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oWE9SHeT
Received: by kanga.kvack.org (Postfix)
	id AAFDF6B05C0; Mon,  9 Nov 2026 11:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FE86B05C1; Mon,  9 Nov 2026 11:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927DC6B05C2; Mon,  9 Nov 2026 11:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 637EA6B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6C551C27B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:24 +0000 (UTC)
X-FDA: 85416045288.10.784EBAF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6E0480009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oWE9SHeT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240082;
	b=33xJrq+OaM0i4JtNCRVFxJ3fzmjxTE2uvkiikNzYdJc3Vy7i50hcq4XOweKph6w85ZIJ/s
	6iOnqhgsVndNG/TTme1cPJoG9wgHiLZfZqUAFf2X2fK/WuvIA+Q6tdUbQuzbqC8s1v3osH
	Sw/QhoZEFhOHfo641ZlFaZcnAznM114=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY9xuTSUx+VKL/ce4GOjJF5WW3kIPH+saWseajGc3UE=;
	b=qzhMjUalFzqyi3/CQa7aYOCFfqLA+P/6ell75rdknWU9N5I0n/3YvAbxeUgqnuR1MiQif3
	o2xjLs2hCWJXgfRhW3rG4siQ2oGoueI3YwPv9PnlPn8U4REeHjTeimIdPD58g7AQUSmdgj
	DZSm51Qd0UGWLkGd8Jp7YnPdQ7y9Tik=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oWE9SHeT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C96E51691;
	Mon,  9 Nov 2026 08:01:18 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECB673F632;
	Mon,  9 Nov 2026 08:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240081; bh=Y0zSXQuI73WVYRp+ApaQSKHcTrjkRu31AZuqJ4SX/+Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oWE9SHeTz0Zr4EwuExxrKWPcs0DZPuSD1zxVxPYO66wezmOJmTn+Vxc23FrbAQ70L
	 fXFbPD1rD0uD4dJXodLqZWxzK7X+y6B7JI3Po/gnxNx/lQq4JfEi3WG7xYnoBQ84H3
	 M2CLJMDSagcRY2kSgkjXrMFDzqNUs8cry8oWgozs=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:34 +0000
Subject: [PATCH RFC v10 09/22] arm64: mm: Enable overlays for all EL1
 indirect permissions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-9-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1848;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=Y0zSXQuI73WVYRp+ApaQSKHcTrjkRu31AZuqJ4SX/+Y=;
 b=DrIUmvyOStKkICsbTho2FY0JXL/3bvaGUJYYur70JPOyzgyrSslhzEX+PR7cTWOovxbTg9h/L
 DUVO/Ct8ZdXBsPzaw5R0LMJ9uaOUXPKQQA0Z3TwnP3F27plZAsjgHiW
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: C6E0480009
X-Rspamd-Server: rspam12
X-Stat-Signature: 91e6b9xj91kme4ka4w6bhtrzj9g5o315
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240082-812492
X-HE-Meta: U2FsdGVkX1+r4V6BH0tV2yCoXmIy+nfpLSVFD6zzhK+tGpNCkmut/ZRXARukaSHoRLk9/RTOGWERhpNydBvQe1n5/VTK42hrw/J4lKd+wvAO5T7ImR0U5HpHSzC78ZynvJpnM54sTpbDosRnLvMp6LK2xad8OmcuFKjyPQbDuWbaGJegInB6abTsux40wbTem7Vgn3NNFtNu/twm4uM3AWtC68Xo4inZIdMiE5gBB06TSel2Nkbfhw7BsQQUz6OApCftuISIf97j6idNMDn+3zIHXZKbFMNkw1AoKk9VILRxkQR1jm+h2lhj+1WV5u0wFbUN7HHclXYOEy0yHP8quNa1CAUnHIpVClVWsyPlTQAgTa1jWxyjyu5YF4+N+OYZBUF9k5RHdWeh4GHseBYPohKlw9s2iGnJSHyUi+JQ3gR7aylaRhFopKEitQPybxYdZM9CZe+gbxMHlPC4JHZXXi5qUfblJaysNqLiJE4G98wtuqgQA+/kq4Z1eVK9i7VW7Ll0gjcJWmcT8MOLdWf6gD/Lw6Q6uFwVWZL73GB2Vo/5iTN6a1E22RwNCX2ycWdWa+hSsBWboXNIDUCn4QT8wIu1NXMPf81LNQa5zzsTZa6KSaXHgZY7xLfmikrm3naQhq8tWxkSKfn/iGVROgT118P+NfwUsYtdzi5hwPBk1jRf/0hwWxMjkzkJO5Cu/UrJLJMEq2vUWnMmP70k8qHrVNDqtOBkGWcYf2dLzGvYHYOk/aTDrsyM3T29PDyCIeiO1htgsdmBRSHGo1YFXwpX1WbDTDJn2b38r73cgROrnc3S3vHApI7Z4MrEynngCwy4f3Kbxnt4OdT3KkQ297qmjYowNOhs/kEoNI9XD+eHX8/xOKmLZ92zxHC+1Rabm1qz2V7sv87OKIMcqZwWLCfF3KJfjOk4jpKKrDIq24SRwivtUqTv8niFgVM7Q3TLFSAe2xL69KNT+lDB2jNUrCb
 0Z7oaVCr
 KlZUwJJ75Zx8tmmmnm90tGtdXI4EFBLkPuv5L9Mn4/cF5bGOlHRqKXo8IeM+uHrCfE4/zsAZPZFga8F1DV1kswgg3A62AJKMGjX59W31OvOmNb1pG0yE12iJREoDNDM1wVyVDW+oxmV7tThDhktLH9emxbPxnRCh6mz5DNn886fJirZ1+zioIdZKH6laANN6vShZXb6mSsRWK4giWwEpwlUVkG3B+f90IU+ZGaPieQ7320HH8k7GeSl/I5Ued8+zwjbERftSmsNuBPACg0wHBqhU3mok5y3igvCm1LYx8iZ36cLTU4ikOL9DTNEqfeOWaadsVcqGoZNI6vxv5NBRPUk2CzTsujFyCSdLLTMIiG2QdZj+T5RK+8gl3iucB2y7zWR6LUlQVCUWRG9RgD/x/JEVV3hMwbVYJHPFEF7Si9W/3Og540enF9c2DXcdqPKwdvvnjkYCUnfaye2gPl6O0bCdtMy42Oi89MsIosdAgNAhZ5xpVHR4IhIyMLvsFo2ifNijp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation of using POE inside the kernel, enable "Overlay
applied" for kernel memory types in PIR_EL1. This ensures that the
permissions set in POR_EL1 affect all kernel mappings.

User memory types must be left untouched (overlays not applied)
because any privileged access to user memory (e.g. futex atomic
without FEAT_LSUI) would then be mistakenly checked against POR_EL1.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 590ef4328f12..eb779c0e892d 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
 
 #endif /* __ASM_PGTABLE_PROT_H */

-- 
2.56.0


