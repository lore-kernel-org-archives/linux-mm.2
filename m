Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79014C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B516B008C; Mon, 31 Aug 2026 01:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528016B0092; Mon, 31 Aug 2026 01:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EED86B0095; Mon, 31 Aug 2026 01:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00BED6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73F0F1C0E6D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:41 +0000 (UTC)
X-FDA: 85160472642.14.BFD18CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0DBF140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CnW75J3D;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155019;
	b=Evydme3elMKxnq4Yu4lOLb/cPI3yIns/0TCDUvggg67bJbdY7dChl239KKGI7guFnVQ3yC
	Iz4BDXGyQy2HIsd82b2NeQwJ8xbZYacT2gbxSToi0G075BCvpGtpdVo0cXDH0pVnuIv2FN
	/BiijnsHkxsuWcH2vv1dD40EKb81P+c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CnW75J3D;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX2UJHkvYtIE8Iv3IhpwI5DtNIWDsoCmIUsixatil5Y=;
	b=a3fsrdjxF8dJmUd9jBkzJ97skrduIg6lCcYlVP12MbwlNSvVRu/TXpAF8Kp0RIcODI5+HG
	+Mke66+6Xj1G+UQ8wneU/WlU17huS5uM+feFQtgUDvxqZX5si1/yWAVjDB/5Vsbm/WXVfl
	hnMmXvVMKZ919N6mrwY1DE96wEPQ0Pk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3F871692;
	Sun, 30 Aug 2026 22:43:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E96B63F85F;
	Sun, 30 Aug 2026 22:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155018; bh=GGK9AC8Tv1PQeecS48AIrQ55e9LqtRQAIQ7FmY+hs+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnW75J3DRkRMOvrNTUSCnYFQNOIbOUOnmVJQMtfF42eAuoH7YKNUi6ESpSwqTyfrG
	 vG0N5mSEM+8VmDd50f9PcBmxjBOkfiS4wh7Lhpjo2rW0nQBSjOK1m4mUYkK3mw+zi4
	 N5OIrqAwr66EWBpqjhoDF/YwciJOKv9ClphMWYs0=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] mm: Make ptval_to_str() generally available
Date: Mon, 31 Aug 2026 11:13:23 +0530
Message-ID: <20260831054331.625505-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0DBF140008
X-Stat-Signature: 9zxn3myubsdnt6p8jekuo5sbbk9wkoxp
X-Rspam-User: 
X-HE-Tag: 1788155019-822651
X-HE-Meta: U2FsdGVkX185aV1EXqmUuPAs5BhwfK/vIAMD+N6Zc9J+0RhNPGQXzIdEIHXXcesHSB631YentFpQXF9kTkOyZJ+sQy58sbCehidKn26M4MJgEy6GNekAf9nfhM/IE4uRdv5cUYfu54LSw6zFDqbLMZJ3j+fLyJg+MC0SjW2OpkthwP3/nG3DMgHQVZXeZIUYdjGJvWErq2NwDqRCM4U0SAPl4fpALxz0W/c6Fxwn/WeZI+yDVj0YnR+jBCNUw6hVl+UmniAx28/FWHdk/NXQniIdSVUoLStztzrAX8KWDBt7HdtistsnUlDjtoAWdKmsXbgkoh22Kig0Q7K4GB3A3Evy7ObvS+cmdFcxbF4SBgsgkBx5tFqwfqGZCfGL7hwEmRHl4Or5Mk4lSrDqV+meeCFA8o6SBlK3I7vFQrThLKWE6gLo/nVdw4hEBCjkvSF6X8NWaIlnni0EcYkygBw6meHKXBF64H8iXe0jofLI/O/BoFf9Rwsg1gtZzHiJIDkS1xwnlGeiAGUVYLEKYez94EsBAZPOCWJvXpM8o3LiV0jwIuxDSAON2mbO2K4Q9lM7jZu5CqXQAJ18k+SIzCnJ4z2BAK4rmYZgQXiLuDeU6Y6jwZ8QLG78zhr89yKPFg0KEm7/5JURhju73K3+ySjU7x+NAqQ9nxhOjBoqHT37X615+fywb59hikhPejysSlA4iEHfUNh7Ib2TV0nAmPxRlm0tWIQdLbUlISE4mK2erYpCY5CQKysukEZ4nW/D0Z8+SPFfGzs2keZ/C48wLzZzjzwc2uHyzlEN0Q1QXG4eAf7cnfdHqcnxX/1jqMPJeJVMlKA16lDDZwyupHoZenFWMK8yFiJnRMhSbzLBPPemb5qKzaI4BBbp1otmndvSPbQjNAJcyYESEAiCg3M3Ilt/BQnamqS+s0Q2PuQhkAxpLSd46e8Z3jBzmHoEx7bimS9LuMkxzptL3vTBp30Jb6f
 xWBsK8oi
 s+VWr0PyJmwBnQuqhj22osRp4Ie/vH+58UpS8xnzRfrVwurm3dlvRlhlX1tCVVdMDPfTY12XksB7Psd8/zYDQq7VJaddsRXwrDycrJbdIsOa3ZCuISm7wCsyFacn8e2S0jFqxrNlZq+bBBAg3pwF+kgpxM92a+XYE8J/Q+aeO+ygNMWU10w8M70kS6oTsjhYQ8kCw/Oiw1aSGAC4H5NBbW/d5NxfPqr8yKevNoxdVwe4WB5UbLTHymh2wW+PBHTC6CU2v6SuXNah5ySqfjNkhETQDylB6OOij5PR5VxGAmz4ii/B8ZeAGq+1SDYVySm9CZ1bRNfz8voouEOQ29MqMXTYJBeXvQxR+LkmFUZ+9KEq+wikBxJ33BcAoZrPPhy/kW0uZYBsGmGpyI03C0OzPwfAI5PobORPwbybFI2N6XI7nwMjEH4y9kcqsKVU0QtD0V91EA4SZI+mQX4HMkK9FUvUbyV1E8ADPszFbGf+p3CEYIDaSH0bjdlHArQI7QTH36WFaWMx+3LGIb0hZ/YuAzUwKuNdztDulT1iKXyTm2nS2XmWt9QxbIrw/Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move ptval_to_str() inside a header thus making the helper more generally
available for new users which are being added later. While here, also move
another related string size macro PTVAL_STR_MAX inside the header as well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V1:

- Moved ptval_to_str() and adjcent declarations inside <include/linux/pgtable.h>
- Fixed type s/ptrval_to_str/ptval_to_str in [PATCH 1/8]

 include/linux/pgtable.h | 14 ++++++++++++++
 mm/memory.c             | 15 +--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..e3c8ab96941c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2313,6 +2313,20 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		auto __val = (val);							\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
+#if defined(__SIZEOF_INT128__)
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+#else
+#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
+#endif
 #endif /* !__ASSEMBLER__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..aa6b2fc770fc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,7 +519,7 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
-static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
 	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
 		snprintf(buf, buf_size, "overflow");
@@ -546,19 +546,6 @@ static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry
 	}
 }
 
-#define ptval_to_str(buf, val)								\
-	do {										\
-		auto __val = (val);							\
-											\
-		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
-	} while (0)
-
-#if defined(__SIZEOF_INT128__)
-#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
-#else
-#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
-#endif
-
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
 	char pgd_str[PTVAL_STR_MAX];
-- 
2.43.0


