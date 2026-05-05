Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC73CD343B
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D076B00DD; Tue,  5 May 2026 12:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCEB6B00DE; Tue,  5 May 2026 12:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C48B6B00DF; Tue,  5 May 2026 12:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 782B86B00DD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D8D71C0FC1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:23 +0000 (UTC)
X-FDA: 84733848486.30.0FFCAA3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 765FD20007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bE7gISU0;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA5Jwu2TbO2wIihoVRGPmFSfloMwBAJFimdo4qXoLBQ=;
	b=PRnuUTRzc+oIyer1/gQhhBATZoOsInzJJANVSGK1epQQHv/mhNen7sXx5hwdYQgVcB+miI
	pT/lBA14Xk6u6gd/tgKENIaRqg9J7tbnYgbV0o6s77cmHsPs3tmBgVL8f1l5LK+gzaWvLD
	UKhhrGTct7Gz8Vs9RlKGI3YNwwGrlB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997301; a=rsa-sha256;
	cv=none;
	b=c61V5YIDFkl+Hq/5K7FMUzWI0+DL/mkv+kxSIBMmvplKjjD2Z96AzFLbcz99eCxd05oX9S
	bQq6inyOMN4WWJ859lDYKuIjiRPQPlY6SPNyzqoErL+3ZACuOsp6wkUvcLiensTND4NVcy
	h/zEICc+whq0qaMzD5KsnwupTWzEKuw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bE7gISU0;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4394A14BF;
	Tue,  5 May 2026 09:08:15 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C7253F763;
	Tue,  5 May 2026 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997300; bh=omwCAkmx3thEkpkTqNX8z5wj8c3+qOTHKO6WhZwka58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bE7gISU03gq0h755odYFsgUzOaw6UDvswOcJVrHQb7PQhhWyk6yiq+HnvJuqZPmdb
	 Fic9XDvc4cYQn3o6sKXeRw5zTwg5dq3jBAXKilBxXBvI+EicgvKmE9G8KFeMYsisYy
	 npvWbqceXO+gbqx/NjShjbqNXvzlyo8KLckaSZGI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:06 +0100
Subject: [PATCH RFC v7 17/24] arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-17-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1216;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=omwCAkmx3thEkpkTqNX8z5wj8c3+qOTHKO6WhZwka58=;
 b=zfUg7xwypSzq4NEGLAX1n6Kb71opGk8Ba4Dk+wrRWrE1XDWMw4FDZX+FCmdcwhWvH8K1snn4m
 v9noznHVB+MDzDbG8bhnCVOUWISyMPU0c1iJDQMs1vX4UbE0Q2tHNto
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 765FD20007
X-Stat-Signature: orkqcm5nqjq593kzdms76zmi8qtkbjzt
X-Rspam-User: 
X-HE-Tag: 1777997301-294013
X-HE-Meta: U2FsdGVkX1/P2f7ZY3PyLQ9KeuSEnSfaKxOPThZNb3a+8YaCaGX9yct4Y8tNIFJTIbUs6GPd+P1jFKQUcck560SaZwgcz6qWwcjpdU2imnpXW2RZa5DK5OInqggCsQOmZmKH7VsUsZ9/GDPWjejB2J+HQnMsQSVSHmE4G4ksbbGlAwPufX29odspCRfO6s9Z4RSMgxgBhCb9kDaSbsNxoPevU5CFFuuo7mC4aQtnEpu9sOrJc9xeMDtJ6mHHGKXlmzPBgYvF3ZB7w533rpCE3k4B7xDIK2uVwoHZXLaNSuu2CyxMY42XECmBV2CliRlWC7+I00tR9P5Xzk7nhPwyIJ8YwXA3OvB3ei80wqEd7sN61k9czOxhiU/pub2lRnKYOoISdI9+xNK83uIb+TDFMhzp7e1SByNbRtvPGX2HmbZvmQE9QaLD+vhku/V0UIB/qdiiXEA+HNB48aq2OtYYfGipXzlmjsI1pPBMFI0+unRya4+5pKBsq0RAG/0fLWa8VzFUasVbpyA/DkrJmng3ZA+R7H2WWi+dx3RXbYXTLM1LhA62o69ILvV+Rcfy2cy/WvhvcZ3RpYnoIA7pCMQGrGKoT28NzWI+yEHXwsBITE6psVHIR/dCXAb0gX4soYD3OX9bDjZldhMVs09TdVX6UulGWF0t/nGrvfb6HV9TLwAdYmfUPI+o9ToB9stoQ61YDqYVYTmcrUwr+tgl1EH4Zuyf/XDNyqBEhiVU9oD+JsJr/QoxZqv4TRYsIi54rqy1T8QuQdTG9QDW9TSqtJLBf4pbbSTfgBtEijV3cOFH5x+08djo9bnnYLozk/grequzyY1pjWrKUIpUqx6e4T25jcXkQcmJdIKMDY/7TslOw0XfiXkQAy6b66Gc+ORnoaNuOwXIthtEKWuhFkBezNsuiFYnbsN6XWHFHK6ioJLa1zbHUgryl323tYh2vdy23XnV3JQqgdvIzvrOWYatezr
 YTI5Y6JO
 jXtRXstcZfWl7i8ViwDevPh+P+Mh3oVmAHYGBKwqpu+vhya/BN+TomKvqHCGa5XFtR1mkBmz0bBcoND0xnQYBK/aisEqIbql7ATCa2p9ldpsd8L9t8zoVIHsFm5XbCvfYXitSFv9BnHFqpV/cZBY4dzo+6DDM5EcYDTKLWWRUgPywYv9I/ItKgYlLQahtW7RQ/ey1G7lB50WeTuR0cc60eVxwlSJRwlJfPZzsB2fqdglEGqBXApkLfUkgA6QhQeCxPvmuG3enbL6LMx5Tg5KSfJTc0MCI1I2z8aFm6BtmW2+Q53M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_CTX_PGTABLES, otherwise only grant RO
access.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index ea915f78936b..0c155b970582 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -33,6 +34,8 @@ static inline bool arch_supports_kpkeys_early(void)
 static inline u64 por_set_kpkeys_context(u64 por, int ctx)
 {
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     ctx == KPKEYS_CTX_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }

-- 
2.51.2


