Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3050A60A263F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=PsZ/xV55
Received: by kanga.kvack.org (Postfix)
	id 5E7546B05BE; Mon,  2 Nov 2026 06:22:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597086B05BF; Mon,  2 Nov 2026 06:22:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4866B6B05C0; Mon,  2 Nov 2026 06:22:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26C896B05BE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA09C1C4712
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:22 +0000 (UTC)
X-FDA: 85389940524.28.08BF1D3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0604B20009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PsZ/xV55";
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618541;
	b=qqE7Q9bBs02xY4WkSOeCUXk2FUeiGXCsWI+xF78IqJ/k+sG6xNPYvXX3ZjnSIrfxZxuvp1
	CQkIsK/IOtNBIA4YjF/oJWhGHMSVKBSQDiS1Wy/uzMD2CGUrHNjPokU/qMxYbEtrnNIcBE
	JKXrJDuSAoP1j7r0bCPbahmGsNkgyVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhZPH2Id1V3UJZ0PUDk/Q6jSjnsEPYgfRRz51ht6Rp4=;
	b=Pcs6gYsvripHoDcPxCB2tdmAkxOgvfE8uXg8geeisd7SgmB4wKZGEnWdJPwJQSM+LduiLF
	a+91dtHwhjn2gq/9PQaRCgTuQQ9ua+97mAY0e7N20rC55I+J42NrhLO75MPv5P+k2ct2W8
	EW6mfNRgbB+fp076S5mr3+Jg1UQUwvo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PsZ/xV55";
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E6232972;
	Mon,  2 Nov 2026 03:22:17 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DD373F632;
	Mon,  2 Nov 2026 03:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618540; bh=iAKWhkLBUL8Dbje3w+lN/zrtNjFP/+2E4XMbJAzkSwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PsZ/xV55JWI15/OuGGIzIxarKfdNw1USnk6yd5/qGxAT2iQNKUyjmZiknVsIG9EAM
	 FHVIK/r0dSwZlieqJ6i4Ub47uuLajcoviLMk9DLJUT8YpfdyuFurfnAbmwFqi15Qes
	 azpHEA/ThKpZh5kfXCYp/IH1C3ruHlJgAZacMHks=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:20 +0000
Subject: [PATCH RESEND v2 07/21] mm/pgtable: define
 (pgd|p4d|pud)_offset_lockless() for folded page tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-7-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4366; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=u76iVQJbWCdkEbiJ5jZQxWZGCtfm9Pp2msKkXET/qwE=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIypEb9aXVoCMG7pxsrAGeq/LTHoW1uWXEBM
 pIwPB40LByJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMgAKCRBt1cPRWsUx
 MzzkDADQPtRN+DQ0QdZ/E5ulISLF3JkAQe33ZVd/+S87WO+Sy3zOmf/s77mek/A86gwCB52rGz6
 NsFtjGs+ALYco+k3aCZaOJ+4OI+GsRLUJBA8kK1l/X00CILC9t0qmJGYamB8dsPxPMO+M21DwVI
 /rk19ar+YAisNFKK7f0r5JRGn1r6rtA/zTelmesjg8qXXW2d3R/orYzgSRJNRVGfHplzMvW5WF7
 2SV4kMDEQq/4kLJUcVebxdFAS9HJCf3XrJTRtiDgy0aEVXoT+q2DWd2LJKPSA+QL6zMvxFgIt8D
 t6P+wsuF+ihqujWnCZw/I+PE5C+Jd11Rk9vGE3JKnMrNmMnR1Sp2jL30ZQcG/HwQ7coqXiYVVSk
 vhNQdA4aQ9WI4ceztWVvVzhXt1frhLl1HR8P0NGGqLVFaAJL3L+M+HjZBrU9dMhkbtwMTx/1+S9
 SzYhL7QXCQWSjEax1AfhVDQ8sPZIqGPWAtZQ/BR8IPZRp8AoNMk/iHqhsX16+teiHOk3Y=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: nkfmcjd7nh1fuyarm83su5mftpfbudjo
X-Rspamd-Queue-Id: 0604B20009
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618541-731377
X-HE-Meta: U2FsdGVkX1+OtfwYI+ZjxGjfAR9Z6yqF3Pc2XvEOV9icJLglsvZfDckEbTRKT3I6cnnFij+yuPi/JB/BX5BpH4HJaiokHshngu3U1G9Rd9YZs5MojEJ3pqhKzDRmKwZ9hC6JeGCrfdB5a2941BsXqOursi7dTRhRIb3zcFE58syZkmqn1oo9rJYKNnKMffjWiy1wLlT+XLz4NBoc4+Tq5KWVbQkrJbO0ykNdXECNFlDx028hT2wb4Brms0TGwrbsb5VSneeuDFDpOgclDEuOWQW1re9tRUcwB1FQM/W9Wf9GSC+8HBDTdamkAU00hSLLoxeyfSN2iQHAyu6QXEG0qw+XkJ+4Gcn8EvohKLwqOk4nIOm3XosFKpgiEJNrb15uxWyXnqMM0GIhCSEBGSWQ85uWgMNXqWmAPoLX84jqH94W9YYRNWZ+bGIHDwm4MIaH/4iwY1jGumgJ8ZMh4maGGx3aGWm1W8jp1zDekMVFGa3Yl9cjuQ5MiNct8ynIiaLcdAKveUOsBimEjrBA36PwfM/ZL1cS8GoCOQX9fQJbp6FpC2+PKsMvgdA45RHnTJFRqeuEi/6OQO2EJGnL4CA61b9Q6Xw5SAtnEcJTCpoUfP+rXZpD4VQs7R35fbWXw4ePHQzTc62hn6QSLSXW+v/5ZFMTIFUuHLA1f2U6Iv5epIQHHvWkhHYDZWn5PcZW60tt7dlsteNDoDX1RlISYFxkGrIuwp/v52YuzrOg9E7PFaWHkDZabhrg6RgmNmxQdQiJj6DugjS9hvJxaLMksgY5lnysW0IA7aUUbRBpWHEhpP5UfTdHkXNGS6HMz5Oio4SJJDx6MH858Fgn0tU7xb/qFyXbfYqr5Jbo26jy4hDK80Dl6/upfvjcCaBydw9iQDXg4wO0AiucE/7iBtbU9Hi2cf0U0Ye6057EbNDNsRhswYwMw7svV6YAMu2MwRilBM7Geac/1uASjJp5RoYqClE
 NE8+cxfj
 xRuW/9LI2AKOqPzSQRZoW8+vaAeDIiCIaTsDtyrhBxUUGDf9OXxcxCqfExlLzIlWZzKUlzM50avKn5jjXXSy2cQX9eCwSYte07dlXhDLGIOiQHPuP2aW6jKjsjsugrXB7mNYRSefh7HLuP8V8yPdXfyQxpBLksuUNxhTkEgyUTCX3Dq8DUD2/2Abp7qzn0PoNjffy1kgGmV+li2TnpOua2QF8VtDDCNTQ5rKsYOI1lxOq2nuJIHoemPPhpA61TLNE3RvMk1Vm909aiuxeBTuE7Jb/9dqUfd+tiGLnqtkmpoHVNKs89VqZNw33ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

The default helpers fallback to pud_offset(), passing a pointer to the
stack value.

Let's provide variants that do exactly what (pgd|p4d|pud)_offset() do,
but ignore the passed pgd_t/p4d_t/pud_t, consequently not working on a
pointer to the stack value like the default handlers would.

With this patch, Drop the arm64 custom variant that did that. As it documents:

	Note: reusing the original pointer means that it may be
	dereferenced the same (live) page-table entry multiple times.
	This is safe because it is still only loaded once in the
	context of each level and the CPU guarantees same-address
	read-after-read ordering.

Do not document this, as the double read will be removed in the next patch.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h    | 23 -----------------------
 include/asm-generic/pgtable-nop4d.h |  7 +++++++
 include/asm-generic/pgtable-nopmd.h |  7 +++++++
 include/asm-generic/pgtable-nopud.h |  7 +++++++
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 763c5a411d64e..b391f325670f8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1141,29 +1141,6 @@ static inline bool pgtable_l5_enabled(void) { return false; }
 #define p4d_clear_fixmap()
 
 #define p4d_offset_kimg(dir,addr)	((p4d_t *)dir)
-
-static inline
-p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
-{
-	/*
-	 * With runtime folding of the pud, pud_offset_lockless() passes
-	 * the 'pgd_t *' we return here to p4d_to_folded_pud(), which
-	 * will offset the pointer assuming that it points into
-	 * a page-table page. However, the fast GUP path passes us a
-	 * pgd_t allocated on the stack and so we must use the original
-	 * pointer in 'pgdp' to construct the p4d pointer instead of
-	 * using the generic p4d_offset_lockless() implementation.
-	 *
-	 * Note: reusing the original pointer means that we may
-	 * dereference the same (live) page-table entry multiple times.
-	 * This is safe because it is still only loaded once in the
-	 * context of each level and the CPU guarantees same-address
-	 * read-after-read ordering.
-	 */
-	return p4d_offset(pgdp, addr);
-}
-#define p4d_offset_lockless p4d_offset_lockless_folded
-
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index c6a5a43899b50..019c3f074b771 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -39,6 +39,13 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
 	return (p4d_t *)pgd;
 }
 
+static inline p4d_t *p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
+		unsigned long address)
+{
+	return (p4d_t *)pgdp;
+}
+#define p4d_offset_lockless p4d_offset_lockless
+
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 4e5aaf253b6a5..1dd5b165234be 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -49,6 +49,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
 }
 #define pmd_offset pmd_offset
 
+static inline pmd_t *pmd_offset_lockless(pud_t *pudp, pud_t pud,
+		unsigned long address)
+{
+	return (pmd_t *)pudp;
+}
+#define pmd_offset_lockless pmd_offset_lockless
+
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 6c9bca78047c4..5a2b0a81ae197 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -47,6 +47,13 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 }
 #define pud_offset pud_offset
 
+static inline pud_t *pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
+		unsigned long address)
+{
+	return (pud_t *)p4dp;
+}
+#define pud_offset_lockless pud_offset_lockless
+
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 

-- 
2.43.0


