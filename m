Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F7ECA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699008E0027; Mon, 18 Aug 2025 05:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671358E001E; Mon, 18 Aug 2025 05:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD7D8E0027; Mon, 18 Aug 2025 05:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4772F8E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:35:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8245139096
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:35:35 +0000 (UTC)
X-FDA: 83789370630.17.345DAAC
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id B5C56180005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:35:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf24.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755509734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=c8Omu33Kehv6UO5QnpWFWfqxuWjvz4FW2cUq9TsWXWQ=;
	b=eueIHdO1zhwC2FrP2XiNBtfSqEdVpB46hXvS+tiV/tU5kOr9uMEkf8kKmrxpW9j3UWMjvP
	Kr02BZU0poFYq7CVopAoO9mdXGxIfyudWzhjCHWG39Vz425V7D9A+lsXvuXRaGHm8qHV9S
	eNitkxKsTqMvU+wtkaHM4KYmQHOFwsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755509734; a=rsa-sha256;
	cv=none;
	b=GX5u6d6xatjMHH+g+snpbXdW/pDZRAk/x9hG/BvYnsrc6tekgkIduVPgLL8JtxQb9JaHao
	plb+A9gLAqWQykso+nwe1W+C8sku2ZDUnNQx4IUcQ3f5lNJo0A0W6G2I31o1IT4WV9+QDN
	EP0Cfj0SuZCXCX9/CsxNGgZ104n8el0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf24.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c56yW6MFjz9sRs;
	Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S4lQMV8lRn9d; Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c56yW5CjDz9sRk;
	Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 9EFE08B764;
	Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id A_F0l_xYSBua; Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6855F8B763;
	Mon, 18 Aug 2025 11:35:31 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Arnd Bergmann <arnd@arndb.de>,
	linux-arch@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Peter Xu <peterx@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2] asm-generic: Remove pud_user() from pgtable-nopmd.h
Date: Mon, 18 Aug 2025 11:35:29 +0200
Message-ID: <c2c9fc69871a7caaa205e237ff73557f19f5e176.1755509286.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755509730; l=2790; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=LTBJbGAaZnZ9xdSyMCrWcKItZ2m45x3r8zAe1HyRjkA=; b=8qUOHdMYJYyqO833zMLZ/GYzKalR9OMtGfcspZDpf14JjHMbxR02lStqhYZM25fsAVWilTr0q wzzsorRSqjLBdi9uE2wvgfjKDvqiPoLqP1ZmxaRS+NLBOlTSuLY3Wry
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5C56180005
X-Stat-Signature: 4i463cb784m8qofrb9m95jxnehitsi8w
X-Rspam-User: 
X-HE-Tag: 1755509733-546368
X-HE-Meta: U2FsdGVkX1/9YMJnwITnMigLvNgDiW/zJCMTx04GrV9j/UzNlZC3Q6s9O7fQJbC1uNznUgMDODszdxYdtSsI1LEFJvf00yz/zkrxcZUxiwzuACfo26Uc/NHw1f4WS6xOGnBd874olTFzpCRh4r0vSU+71IO40MJTXud5VYx3Sb4jNBwLfgrFmYNl2m0UXBZCedlfJvuffFyt0Dqxdf5OcLfD8S3JqQOkWt7FjJdRHAZjNfTQrsBIizk1+L/9GRWEXgBu71ETlVq3rYmIpKaIB81qY6N8GknK+9qv44MfY9jwZqffxwhOVX1IwIX0z5KZD1lDx8gbrBIj7U5Sr/d9hL+AUEle+zl6bt+AENgaw83FyLzteex69CSGLt2nsjgOEUf8Dr/WfRYEaOJTEos4CHLpBNxmIen8mtoZWx6ziorW1kHCjUQEZ+3maXA6VVLUMaOHunYRlyp+COAYi3RiWgd+LrhPF1q8QHQyiCXvxGVIy5sdSRumVW5i3t+83oQR4ovd/Gvu1AbiG5haAEZHoNd5xoWFCnlWsSCbKEl7QeAqOPs+dkiegrz32CwgZ0ZUNFbSsEeQyk1TBDkSlO4zZyadDFh8nTQ5Ed2ffA9tLZzho1y4/0s0fhFH5+h17jNyp7DcwbApnfFlnbzeO9JQNIm+lLz/EiQzZtv525PTrsDYtRbmkbJCatDwgfhsjMaJ1nD2x9goPhwZqoaJ0cVfRKSGfU/5AMKr/36L2O5jE0u/4sRw0sW5Z+Q/N31yZzeNmKjXx5LH8t9pOZSyxbFVhv9fl4qDD9KB2cPfuPFt2ZD7tMGZJ2qBvWGYYk4occG++U2iiBYTtxzvD5BExe5jo90bMbL7juyAe2j+Qvwv4FTfop+n7VNOsJRKyW8xj3mBEeyX1iBEA6BE0YJkXp07tV1vyO1ZkEeV9zaiHqF1FCCD9xKlStSZCfjnXeVCEWqa45CnTnyNhTUDzH+lS/9
 gXAa+Jlz
 gkpzZhvlUEiImajWPaF+rI1KjqLHcqAhmVosSy9LZuHxxRXqwgktje/0hoAquNXQBhU0YO8W9aLEi+np6Tk9T13wKOcE1N3BgyNnZGKzsqbXXby1t0VR240D3XJCe92osAcWyeT2ZhkopgYx7LNemGX0wAHAKfOQxqKwO+FyxBcVMnZxFiCw7KaJ0z9fKA9F5ihvo9jyHeNhlhQirhqUUCRRALY1SAvB9IQPRazMmQcALP4ci6pyNUPQlUIHpfiYjoV7B3Wj3xkoUXI40HChDTLKVDEqhFsL+8cMgE7Qnuv8S0vlHd9BSgeXcpnB2R8rtFZGYXxkNu2LnO5GafVTczdekMDqJfYJmlNfkgoshlpqe8E8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2c8a81dc0cc5 ("riscv/mm: fix two page table check related
issues") added pud_user() in include/asm-generic/pgtable-nopmd.h

But pud_user() only exists on ARM64 and RISCV and is not expected
by any part of MM.

Add the missing definition in arch/riscv/include/asm/pgtable-32.h
and remove it from asm-generic/pgtable-nopmd.h

A stub pud_user() is also required for ARM64 after
commit ed928a3402d8 ("arm64/mm: fix page table check compile
error for CONFIG_PGTABLE_LEVELS=2")

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
Not sure whether this goes via asm-generic or mm as it touches the earth of mm allthough the files are in asm-generic

v2: Change ARM64 pud_user macro to pud_user(pud)
---
 arch/arm64/include/asm/pgtable.h    | 1 +
 arch/riscv/include/asm/pgtable-32.h | 5 +++++
 include/asm-generic/pgtable-nopmd.h | 1 -
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..d812ed1c96b4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -955,6 +955,7 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 
 #define pud_valid(pud)		false
 #define pud_page_paddr(pud)	({ BUILD_BUG(); 0; })
+#define pud_user(pud)		false /* Always 0 with folding */
 #define pud_user_exec(pud)	pud_user(pud) /* Always 0 with folding */
 
 /* Match pmd_offset folding in <asm/generic/pgtable-nopmd.h> */
diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 00f3369570a8..37878ef37466 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -36,4 +36,9 @@
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
+static inline int pud_user(pud_t pud)
+{
+	return 0;
+}
+
 #endif /* _ASM_RISCV_PGTABLE_32_H */
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 8ffd64e7a24c..b01349a312fa 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -30,7 +30,6 @@ typedef struct { pud_t pud; } pmd_t;
 static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
-static inline int pud_user(pud_t pud)		{ return 0; }
 static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
-- 
2.49.0


