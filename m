Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A24160A3E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CwVB6rMt
Received: by kanga.kvack.org (Postfix)
	id 749476B05D1; Mon,  2 Nov 2026 06:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2C66B05D2; Mon,  2 Nov 2026 06:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1706B05D3; Mon,  2 Nov 2026 06:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECB66B05D1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE2F180721
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:39 +0000 (UTC)
X-FDA: 85389943758.23.FDA1249
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D92D4C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CwVB6rMt;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618618;
	b=EEZnrSUxsGOLbmAb2bbqECNEhZqy+uMBjuJ4jlqSOmAymkk/u0t9NFhPOUAshhEd0H6ZlP
	SIY20SYaWFi/exwOynOMCqnNdY+KshuU8QqaTobJVom3rEjzrxV4aHwvhC61awZ0N/2+m/
	6ZISC7T9zik0F2MXwKJ2xS78TprrvQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r03SVNisaJd6Dqlau4jEcL3AHt7KSVLlnibo546VQzE=;
	b=cFUDcehS9eBjGhgUzqM2XXSx4i6fGCH2VhbYD7cpkXjZIe06A8DtXqg11RvF6wC06dsnrP
	Sq2Q8xX6hfUqrWjKv1qWdn57mum/2aR6Q4x2Z1ccPY5hpVo1TE8pROmaVJbeetJj/csyUi
	xm5KU4IpyDCqYE54EUOLKdEWOBLr5Zo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CwVB6rMt;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9E922972;
	Mon,  2 Nov 2026 03:23:33 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1D9D3F632;
	Mon,  2 Nov 2026 03:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618616; bh=dSuJLJ9ohCs7txtQHt7hy5Mg9PfzhT9ZTRhsbp3QTUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CwVB6rMtqNmeYtlR1b5rAD+CAIj3PVpzx0TNgbS2AaT+wfXypUwT+nr1RgaU6prdn
	 wx4ZJ1+P1Z8sgtto7zgnVVCGSAO8z5+AsUmYsLGA7Kqq+a/3e/x2vbXgYudKhQUhQe
	 xL4k/FXvf0s66pNjWZaBxEuK7WqFmVa+wKQzwSMk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:32 +0000
Subject: [PATCH RESEND v2 19/21] mm/pgtable: disallow calling
 (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-19-78840b2ec73c@arm.com>
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
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3268; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=VRD/vI2+dr2wFISWOiD6XpoJffv8Fhm2BOtCv803wXw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI4L8kv/rf2UKz5TAtyDoaFDZOJqCmrvBcnK
 CELM1gmsnqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyOAAKCRBt1cPRWsUx
 M8DMC/9r3/0o/7ps/8n84d+IlLJLH4xeS8PCLDRucy3Gl/HwXz9m4hNon0sr2opEa7GLxc8/Xd6
 lu2bhmjWEtNjPAuwRQrn7FukyWajBKqHxpnX9+5qRzo6RvT0BiWe5Am7M0higB9P/Zp8MV8buCG
 hcJyBrJJdosfOfcCiCbHQzma2OvD0vo50RF8MqSVBrCTg6nAL1L+o1jzMOVuCAoZwuhpp01kEwo
 QwhxO6qbkCBvGotbr1kqvT5Wv+azNDF5d+LJYIxv2XPpMosFNzqd7GRl90tJmUHOOm/HMjzwoPy
 40p2WwzfGv3BMTPz63vusUm69j9Kc+8pWxCWc3V9ws1ch6wSdb3Xcx7wYuBtaPaZsr2u44OBdQL
 CoMUSFbcqH0C+fhJ8ElXCjrOmegadJe+eDzLZy12gsz5y4KyyBDlzmcPpapzk+xCI6f1x68sbE6
 eUa2ZCWtJTGxSjrChh3GXnLvZ9I1j9cw7wUPNlgAZQg7bqYuJ9moJVh2af0tDVYZlzNq8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 879aih44hco3yz6z9sg6k4i8k7gyq9jb
X-Rspamd-Queue-Id: D92D4C0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618617-653279
X-HE-Meta: U2FsdGVkX19XicVfHJMucSmbeiQI+EGemEmLZ/fxIUrDKxnIezjga4OYZyZC2Q3JpEa38lAXuttviIoF9jzQKzeVLL8OU0Ngiez6l2E9xYlOn9XwCiBJVwlahcxeQLVoL9N6THDwyvIrom+L4HTIek7IzSMahO4IXsqhLy2Rdfj+MDgT1v4tQCEvsj7cLpLmtTh1+shMpJtbf3pCPZT2dXc6bnmXjln50fWnGjuQTj9loRITfkkdOvTDXAvjMtef2Rk2Sa4HwnDi1OGUxklbNK3xulhdOggZ7VR7e3LI0ICicOmIRVGYQLWF2UNx1Ipe1zmvvJUf0OyHwLNZgXLd+xu7xgIa8l1DNlvPo3X2+hm6Ax9UH7gaze1SKiLn3351IVJWtl3jgcOWcJYK0wqLSFJBYQjY9sq2+e/rFx4k/C9ZqVoaJp7J2C2G4qs6AfB4nDxdhzbcVVbpZzaoF9VHlL9QzRZtEaglEbOIvso3X6WVcTOdWm7Vad4HiMK1VGYpYs74kXHW9GhvdjNeHMaQ+WcfuGp+2Di4welUYAkTe3genBINaZVZD+RkGr3vkNOWhsS5/GF/Qv2cLh9OEz1ykLcj2E4kr6bt2uO8GjbuG2h0xAXZ6fT8L8T6intzlPmmlnpOfRqKX9ZTk8AN5E/gzufg6e9jlvoJDSNAY4XI/NVBfCZnSAEbRiwtXtQrlE8yJ0Ifn7eDBHEZ64HppHGJwBcRtjeYl2PFnIyWdzKT6+Hrdnq2NZcT924QX49ZTgzBWEhw+scrI4DV8Cg4SFzD1ZdjCiCxa+uD/1SGnBfLAoEIc4pyAjKd/hBr1Np0NKsSqvPaD1dVQy6tlpVoun9qA68pWSYI5Jhfpyw334w6HPC0gbMez5n011nSxoZmfVfQq1hikaIuuq8X9q7yIFQod7A6jCMgziIYenG3YuOCVdUHX2TIUZ1dUk8BxqACGNbIL4RIM0qYTPSyndlxGko
 tv2wsM6q
 ZlYtXXhQ1In/jqW5FsOMHXOsMKSCL3ZGIXhhUg7zliXCncWzt/d0ckYmf7+VDkdqYiKnG6Cde+NlGS4EhtKM8f02hwIyGzc85dQP5jz+RB2suyjzXWwB0VqMw6C1Ca7sOQdskw7mvL/z8rkz83U3vEX5fmEXrbjHVqLB6YmQz2foDaF3qIIVILlOpsRzITdm8Z6wmq+pdQGjk9MiA0LsOumHzmNA3wrESxmMvWMcG1zV+1DT007RF9/Wf57Nm2h1dockax+GmhZIY7O2a9mEixyUe2hSthxJDEGqg6QzqL+gcNLMCLPY8+48VLWnT9x1dt4EWBIAoBWGMKx6mE8tYx/LueT6q1p22AlrhaQ9RGv1q054TOAMmYC89Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

These helpers silently fallback to the folded helpers. With e.g., pdgp_get()
returning dummy values, pgd_page_vaddr(pgdp_get(pgdp)) will now behave
differently than pgd_page_vaddr(*pgdp).

Disallow calling (pgd|p4d|pud)_page() entirely, and catch when passing a
dummy value to pgd_page_vaddr() and (p4d|pud)_pgtable.
This will catch most abuse of dummy pXdp value at compile time --
so far there were none, and it better stay that way.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 8 ++++++--
 include/asm-generic/pgtable-nopmd.h | 8 ++++++--
 include/asm-generic/pgtable-nopud.h | 8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 2d86325235da5..d2dccf7542da5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -70,8 +70,12 @@ static __always_inline p4d_t *__p4d_offset_lockless(pgd_t *pgdp, pgd_t pgd,
 #define p4d_val(x)				(pgd_val((x).pgd))
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
-#define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
+#define pgd_page(pgd)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pgd_page_vaddr(pgd)						\
+({ 									\
+	pgd_check_dummy(pgd);						\
+	(unsigned long)p4d_pgtable((p4d_t) { pgd });			\
+})
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index bd40d3a5743ff..2afbf2d8659dc 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -79,8 +79,12 @@ static __always_inline pmd_t *__pmd_offset_lockless(pud_t *pudp, pud_t pud,
 #define pmd_val(x)				(pud_val((x).pud))
 #define __pmd(x)				((pmd_t) { __pud(x) } )
 
-#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
-#define pud_pgtable(pud)			((pmd_t *)(pmd_page_vaddr((pmd_t){ pud })))
+#define pud_page(pud)				({ BUILD_BUG(); (struct page *)NULL; })
+#define pud_pgtable(pud)						\
+({									\
+	pud_check_dummy(pud);						\
+	((pmd_t *)(pmd_page_vaddr((pmd_t) { pud })));			\
+})
 
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 7475d0bd0f2e0..3264673c0c386 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -77,8 +77,12 @@ static __always_inline pud_t *__pud_offset_lockless(p4d_t *p4dp, p4d_t p4d,
 #define pud_val(x)				(p4d_val((x).p4d))
 #define __pud(x)				((pud_t) { __p4d(x) })
 
-#define p4d_page(p4d)				(pud_page((pud_t){ p4d }))
-#define p4d_pgtable(p4d)			((pud_t *)(pud_pgtable((pud_t){ p4d })))
+#define p4d_page(p4d)				({ BUILD_BUG(); (struct page *)NULL; })
+#define p4d_pgtable(p4d)						\
+({									\
+	p4d_check_dummy(p4d);						\
+	((pud_t *)(pud_pgtable((pud_t) { p4d })));			\
+})
 
 /*
  * allocating and freeing a pud is trivial: the 1-entry pud is

-- 
2.43.0


