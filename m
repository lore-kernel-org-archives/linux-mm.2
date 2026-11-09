Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7EF606A337
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OQ0L8REn
Received: by kanga.kvack.org (Postfix)
	id D6F226B05CD; Mon,  9 Nov 2026 11:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8AE6B05CE; Mon,  9 Nov 2026 11:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0976B05CF; Mon,  9 Nov 2026 11:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99EB26B05CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E4E740710
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:01 +0000 (UTC)
X-FDA: 85416046842.26.DFEF128
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E86140006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OQ0L8REn;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+XtcHjlveo6Rt1z/HHzt1Q4WWTxizmEkz/Ti/n8JwQ=;
	b=GezGxRZkQPiUClnvuucxclHEnXwvWrWABOhnDc/qA1p653D9iCjvInrDbH13Ue7CF+tn40
	FsBnFZgZMg3arAhuPdfbSr5KOVeOjIF8MpD27AhR+bfnj5OHRCIsMjbV3QvIMjL51dAy8k
	+wISn8PQQEo+xi27NNePEKj/GrLqHlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240119;
	b=bT+rSiH1aULZFGzdp4luimJc1tFfMhPmCF+zIV1IOFB3EXfLPJ9EIcVW/9PYlHD/PwoEYC
	Pe9QsxptBBv8NpASp7hfnFEGOpG827XJP/vByZbYtMQiblwHa+w+teMddjbDFTGYR+fT4R
	+R4ww3DBuZrMQG4zQeOBSVdBeHUOiag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OQ0L8REn;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47B902F;
	Mon,  9 Nov 2026 08:01:55 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BCE23F632;
	Mon,  9 Nov 2026 08:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240118; bh=0JuT+uildmhaEgn52zC1lunzUYu7ZIusFUBCe2xiZdw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OQ0L8REnTHidFM5WIxAuRaOX8lI9jHDoPNsgAWQY0L6rdsqvGaNTupVYA9RPVplio
	 T3F6kLb8WJULkHTF1GMu/FxhXXoINGvTkSTZ0tFdGgL0KBbeGPDN3ADLHM9p06YZbb
	 uT79RWGna60K/cuVtj0vXs46ya8uuyMv7kHuVp6c=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:41 +0000
Subject: [PATCH RFC v10 16/22] arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-16-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1222;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=0JuT+uildmhaEgn52zC1lunzUYu7ZIusFUBCe2xiZdw=;
 b=X75PO42OizELIjHMA+pg9ABYfNK2RBjNkvixe0qpHeh6AeI5trotCclhD2ML1Ni/zKshehgvQ
 erzJBrYq6p6DNE9At7ub+oahLytHUeXMooZPd2GoK489VN1B/az7QpE
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E86140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rjcwj361uboo4jbfh6guogcwemrdzfsf
X-Rspam-User: 
X-HE-Tag: 1794240118-346619
X-HE-Meta: U2FsdGVkX19IUJYW3IiUmb07gfdwgQACz1Si+F585btRRvx8JdhBVJqka7wKq0kjULoslcK5J+B6kCMiSg3zbIKUuexeDqY4RkeoRTuAAwKZFW2Kj0EEiQhqqf1e3UuNA44PMNumdIuF5Dt1527Inm5fCpMIuQELeqa5Vd5Zw8MPQtpA/k4bhxHJBsX2VmVs8OI13OFiZ2s9ZJcy8CftsHCjCMFxa0QyHARYUM5zVgXTumcnOdZIHG7lcmYo/SpMj/CVMfnFYZo3V/RYUFb0BUhO10Yc7QgWzue0z8uTj+wHEbmiKGlIFmuVLj3iG+enrSzZiOG7QuyAH0nw9dF4tshkQ+2h2qy/dR/rD9q7mv8UDTCvhkYkGpOza2lDePvARsPIPYnp9ZrxXlMDqZC1qeAeW/5fbJYe0fr+L+dJaYYevK1kdIMDB5lCmZ/5zwu0bDJbDT32z4kv/45AC1u9cX+yZA1ptUGghUvjUA9Z9QwyyhMRJdcwiFQ3vyjaOP09kzvd5fNbE04Os4wr1PXatKP230CHw8cgLwKBzyJrEEZLgbGdqUfgcKcrvGaTMJgciddnRJeo9vBRdoXQQHZgTsXToVDg5vH0PlmwObgGykrLy0IzkYpbzTPwlyezLrKfF0Kk6EGv3f2atocTA+Zw/NOWJaJVoYV4fRSde52DjlZ1HDyd+vwiSTznDl/DzD3DyJZwlcol5PNtV8rqanwg0zw+qf2Dj2rRxoc66F05bXGsTF/UJUHkNVvzooXBWkYllBICv5mv2KheP0UvoxX7lE+c0Ce1fFONttIyqz/JQG9XkTET6ddKEno7dK3dkAA0Kr/6dp0CkdxFIg+JMbqKdxE63G2c3UBgXd+4Fe8wNDBYbfncZDkqV7EhlGQVT64ng0Qe+lVvPJyOyEW4+rdNQua/jC9gmRGZPu+HbuutJCEbHmpsA/ZuzMFbVgtuypyB9PUWTkTjW5TjdLI7Bb3
 X4hSoCnE
 3gkoYEvhulIDS25AlF3RYJ4LIQ0EFnOM9lVw4ennPoFijsaWlgQ7V6Qo99WYyjdtB5KxUfbM27yHYXuReu2h5IQJVl0E2r2cAO4oDZKMMBVB+90tDCbWkwkS6F4Cd80+KxgCo66ixVjkdl6vHBt+1hE5hzoYGRtkJjaKf2qhPp0lMXDmT8iCYKZM1Q/lHzMFU/JVSyJeO+dpfk9m6XX8gHu6Q/R/zI+fSWXaeZJYhvgGn/pM831GRP8rT7eTKGWspJMQLVqXcyqHbZnm4CmhEojjKHFadNg+bcNgbWeZQC+I9u5OM5U7HZVkL8OojZnmUcytWHrpiN943avI8Fbk2XtlzxxlQcTfj827abFQXL7rpkEP8ihCwlgs5O4Dw0n63LCnlcV0qLOLyssREldKumCvp3jdxRA88/lCo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_CTX_PGTABLES, otherwise only grant RO
access.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 70d85b0d69d6..6f6022b6cdcc 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(0, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -33,6 +34,8 @@ static inline bool arch_supports_kpkeys_early(void)
 static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
 {
 	por = por_elx_set_pkey_perms(por, 0, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     ctx == KPKEYS_CTX_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }

-- 
2.56.0


