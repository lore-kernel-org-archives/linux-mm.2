Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903E9CD98C8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 04:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE926B0088; Wed, 10 Jun 2026 00:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE876B008A; Wed, 10 Jun 2026 00:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC49A6B008C; Wed, 10 Jun 2026 00:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9774D6B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:36:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F2EAA0832
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:08 +0000 (UTC)
X-FDA: 84862740816.26.1A3FC48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6702640011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B0+i+p9L;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781066166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLLF9A9CNmy+kyIzh9t15YmlWtVH7Uc5iX5cPxkKpYA=;
	b=GJQP7pQsgbyDeMUPOal1yTjEPFxTtrC1fbmojxX/qV35XpCeLrfJRTRST66Xumta4pGy+a
	FByvFt6oL2KzbAhouL2Irezp1QGZ9WRpeMV3XloVeb1kTqs5CBJkTygTDDYLZ8aPbs+4N3
	3mrsrzM0ryBZyLFIK2JqE4edLVvVKrc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B0+i+p9L;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781066166;
	b=8WL1urB4vcYjhO8xJfUG6P4HgNtSLD/XHZPPWhwicfb0bB1Bc2vdLJV56cwP2s4ZaeNyI0
	tq3hHpd8DAlO/b8jQXYBYhkzUHg/9CzMQzPSgxIDjwfuzgUt29s+jEQn/uUAn92XLYj4DZ
	oF1yoFmaovMrdM9fqe13rHFFkVwHz6s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75E904593;
	Tue,  9 Jun 2026 21:36:00 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C8D8A3FD88;
	Tue,  9 Jun 2026 21:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781066165; bh=OEb8s8uIWUkzmmIYC/yFpsUxXtXVEWIhB0oWagSx5ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0+i+p9L4YG+tmGIPZTd2fOVybIZ3ZnBqOTW3ea6KWDuo4bNuKKqSNmXb4uuhPRbB
	 r+iGoR7xm1QpMKiHj6KctxPoBIjGeevTyE2dBEPuMzV0+O91dXWyyXDLrAImwS7A+Q
	 1ayt01l8Hjo8DW600V2mzqvdcMDDVTAc1ltsPKU4=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andy Whitcroft <apw@canonical.com>
Subject: [RFC V2 1/3] lib/vsprintf: Add support for pgtable entries
Date: Wed, 10 Jun 2026 05:35:43 +0100
Message-Id: <20260610043545.3725735-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260610043545.3725735-1-anshuman.khandual@arm.com>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6702640011
X-Stat-Signature: 165hs9nx8bpe4dpgkozf4ndk3icdcgbo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781066166-772695
X-HE-Meta: U2FsdGVkX185PSiRZTjxhdMRpQpocJoHAK2X6/1ZTmFkYNk8NneDt3XMuMkvWcrtu3gNHvnqOfEYD+2a9zT+SzcPxryK164B5rSMwgFY3lG0WoiDI7FVGWpkq/kcgkBc4HhCoJYpDgKxcPGG7Cee7K2uSoyYNkcqCHtxsfGQ1Wf0j43lvRBwWlJbadcSEahSLxhulm++rZxc0pUTYYBxfu2kG768v68V0lmDeMvoUQckfJ3Ri6TuIWBS9HwoqTe6WCXXt3SkzdBdP2ZtVic8w9FvHFETgAVGI58l/LOrT/VQPKMMgI3Em3QEfI23rugYEvDeuNj4qpsSb6pszij5i8ilclQ1z1AMamAn32OAvMIqJTVz00ZGmNq5fZDJuQjrvi/N9XbNSv+YpuAJxKO2vyCfjob5ymntLXaVkkajDMX3sXA1ED7pK97xRlzHEscyiUDrspO0CaHMr8LZmXbsQ26Mz0q9M6fIeP7liRnsXkM4me17MW0Hmuh09V9CsD96rPdL8D73W75qXvwfTiZTdz01FeFw2wSsKAQ2Gg+vs+vXTgiAAtc47tejMiWsk1rq4A/bAmYdWbISx4rryEEFa08zhHvUFKtv5XenMpuVGKTl83kgE6b7rKjabP0+62we1/l9b9PbzKYuqd4LyhCewOboytXQWHPkjf/aGIfJ5x3PlDWUAwvqs+eGJ4+qETu/XOR3iHerouXgAsLEAvrUz8CiN92AcMvhCisFlDJJkxwSTVLnLYAidFrAWkgJfyfYA32MPv8NjSaAsCi1cjbXC84h+xApuNzulguakJpv1RqaklTuM13q9Q6VMllfIviyws5ZIr0m7vmABLAF1eMdI+wKPJPeoD/djKRvZGqEsatYFATeWNH7vDtiER5erqgw1YMPM8PBKjufg9ymn2YY/k/qlInrFH/YsXPBw3Fw0tAt1EvUJLfQUC4RRip0LI5OHtYVxsiPEfR8V/RvsW7
 xXRMAsB2
 fohEuY3Jk2ObJ3Fg8yMz/hPgZ4R3J95HQu2G7AFYk/6GSwei9G2crN1wKMAmb9FBZDyzP3p3xX7hka/eENl66eDBxl1vPxoYh22ThgvdnmjK+5KbkNSnyZbZ/JoF6ZszKoJqbf61H7TzXk6PaVnSXIAoyjON6kWdE7cPvy9TR6nGddgrDh/EMoXMFDjDDiIa56OxM/mADUTU6vDcH5wf9sKt6ThVlarteoJJKX5pShSo5IUunGCQGqJE60xveQGLllNBpwPOMaULLYMdEOwmEDElH3/C6ZNO0wAIf0UigVVRE3vqzeL9A+gym33Ns5+B8Z4PGPFMWeWEUUnBWr0S/3xR2kQGi/4mnhfArls2rqgxzLtXjJ38oLt60G37yq4XqV4X3toy4wE/pbLsQ7zfND0Pf0Fd3NC2EFNMgfF3pg/n3gJU/enO9bQn/0i6Oh8PTDPx4T7dzznlSHEe8cU3SwYL/DMLuRDVakMH3MNR2phTXbF+Mdy6H9E0QzwFS30aNyqUFepqZ9xYoZcaoK4lNyPEv41nkglO7teZp2zEv2yuYxoWhqCgTMvD/YwZp8u4KGKAcw+oyZbn8q3NktxfGVD48FXxBwijgNW7VLWFER1fDENQHHKPE7jdoMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some print formats for pgtable entries at any pgtable level. These new
formats are %pp[g|4|u|m|t][d|e] i.e %ppgd, %pp4d, %ppud, %ppmd, and %ppte.
These currently support both 32 bit and 64 bit pgtable entries that can be
extended up to 128 bit when required.

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org

 Documentation/core-api/printk-formats.rst | 19 ++++++++
 lib/vsprintf.c                            | 58 +++++++++++++++++++++++
 scripts/checkpatch.pl                     |  2 +-
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index c0b1b6089307..e69f91a9dd9d 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -696,6 +696,25 @@ Rust
 Only intended to be used from Rust code to format ``core::fmt::Arguments``.
 Do *not* use it from C.
 
+Page Table Entry
+----------------
+
+::
+
+        %p[pgd|p4dp|pud|pmd|pte]
+
+Print page table entry at any level.
+
+Passed by reference.
+
+Examples for a 64 bit page table entry, given &(u64)0xc0ffee::
+
+        %ppte   0x0000000000c0ffee
+        %ppmd   0x0000000000c0ffee
+        %ppud   0x0000000000c0ffee
+        %pp4d   0x0000000000c0ffee
+        %ppgd   0x0000000000c0ffee
+
 Thanks
 ======
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 9f359b31c8d1..d4ad3048a4db 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -856,6 +856,59 @@ static char *default_pointer(char *buf, char *end, const void *ptr,
 	return ptr_to_id(buf, end, ptr, spec);
 }
 
+static char *pxd_pointer(char *buf, char *end, const void *ptr,
+			 struct printf_spec spec, const char *fmt)
+{
+	if (check_pointer(&buf, end, ptr, spec))
+		return buf;
+
+	if (fmt[1] == 't' && fmt[2] == 'e') {
+		pte_t *pte = (pte_t *)ptr;
+
+		static_assert(sizeof(pte_t) == 4 ||
+			      sizeof(pte_t) == 8,
+			      "pte_t size must be 4 or 8 bytes");
+		return special_hex_number(buf, end, pte_val(ptep_get(pte)), sizeof(pte_t));
+	}
+
+	if (fmt[1] == 'm' && fmt[2] == 'd') {
+		pmd_t *pmd = (pmd_t *)ptr;
+
+		static_assert(sizeof(pmd_t) == 4 ||
+			      sizeof(pmd_t) == 8,
+			      "pmd_t size must be 4 or 8 bytes");
+		return special_hex_number(buf, end, pmd_val(pmdp_get(pmd)), sizeof(pmd_t));
+	}
+
+	if (fmt[1] == 'u' && fmt[2] == 'd') {
+		pud_t *pud = (pud_t *)ptr;
+
+		static_assert(sizeof(pud_t) == 4 ||
+			      sizeof(pud_t) == 8,
+			      "pud_t size must be 4 or 8 bytes");
+		return special_hex_number(buf, end, pud_val(pudp_get(pud)), sizeof(pud_t));
+	}
+
+	if (fmt[1] == '4' && fmt[2] == 'd') {
+		p4d_t *p4d = (p4d_t *)ptr;
+
+		static_assert(sizeof(p4d_t) == 4 ||
+			      sizeof(p4d_t) == 8,
+			      "p4d_t size must be 4 or 8 bytes");
+		return special_hex_number(buf, end, p4d_val(p4dp_get(p4d)), sizeof(p4d_t));
+	}
+
+	if (fmt[1] == 'g' && fmt[2] == 'd') {
+		pgd_t *pgd = (pgd_t *)ptr;
+
+		static_assert(sizeof(pgd_t) == 4 ||
+			      sizeof(pgd_t) == 8,
+			      "pgd_t size must be 4 or 8 bytes");
+		return special_hex_number(buf, end, pgd_val(pgdp_get(pgd)), sizeof(pgd_t));
+	}
+	return default_pointer(buf, end, ptr, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 static noinline_for_stack
@@ -2506,6 +2559,9 @@ early_param("no_hash_pointers", no_hash_pointers_enable);
  *		Without an option prints the full name of the node
  *		f full name
  *		P node name, including a possible unit address
+ * - 'p[g|4|u|m|t|][d|e]' For a page table entry, this prints its
+ *			  contents in a hexadecimal format
+ *
  * - 'x' For printing the address unmodified. Equivalent to "%lx".
  *       Please read the documentation (path below) before using!
  * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
@@ -2615,6 +2671,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		default:
 			return error_string(buf, end, "(einval)", spec);
 		}
+	case 'p':
+		return pxd_pointer(buf, end, ptr, spec, fmt);
 	default:
 		return default_pointer(buf, end, ptr, spec);
 	}
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0492d6afc9a1..f68955858e29 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6975,7 +6975,7 @@ sub process {
 				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
 				$fmt =~ s/%%//g;
 
-				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*))/g) {
+				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*)(pte|pmd|pud|p4d|pgd))/g) {
 					$specifier = $1;
 					$extension = $2;
 					$qualifier = $3;
-- 
2.30.2


