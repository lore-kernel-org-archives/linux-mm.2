Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56079606B3B3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=S6G8eANt
Received: by kanga.kvack.org (Postfix)
	id 797DB6B05CA; Mon,  2 Nov 2026 06:23:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FCC6B05CB; Mon,  2 Nov 2026 06:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F7D6B05CC; Mon,  2 Nov 2026 06:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2CB6B05CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD9261A0CB7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:07 +0000 (UTC)
X-FDA: 85389942414.12.9DC7FC5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 037CA100008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S6G8eANt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb9H+uxRvArRVVJKhsUr+93SDYJ1x6sKU3xCIma4RUU=;
	b=A2ogKjP0Lab7in7SymxuBFUPw4vqu49uNvkLnNBoOCBeHWWUL8zIrW2SNMQdASewG91eVR
	H7GALZe1abAJDS5ObzFdyav1WGXMBN2AJNBym5dbn2kq9JXq3sbO8VbyyvG8EKP71nkzDd
	kkTODLsEHx8KcRw0LkDZIFpQWNy3kcE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S6G8eANt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618586;
	b=IvdTx/GFr7hha2rt1tXScZazGgx7VYTAWNl0Djzraz1WTzhSzxizzSHREKGvZO2U3H6j9z
	/8pDlUQDXlffoxnECxQ3/LSQjgW3VkZ/qymFzX6jNcW25ruDa1V0XA1BA15pyyGj0CZ9oH
	QzSTA/RndlQBpCnd4A9G23UX9Kg/rQM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EBDA1691;
	Mon,  2 Nov 2026 03:23:02 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 254863F632;
	Mon,  2 Nov 2026 03:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618585; bh=zghhBXP63HUkMVsnVTW1BBI8m5GQHzJyarBmwmrVkLw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=S6G8eANtslFyveBpwPLZwAJIlHGPtPzLOZkPNUbQZrbf/e83nfgLtEhyRdEl+CKWq
	 qbwPr2yNqC5ubwdh6TO7JSUkTYZQmq68VurvEE5YHy1zupilBrGF0jDnFDGjxNIWLR
	 ZIyYkP1apZziEAVLn/pciEqxsStbIpEa7Hh9LprE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:27 +0000
Subject: [PATCH RESEND v2 14/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-14-78840b2ec73c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2497; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=zghhBXP63HUkMVsnVTW1BBI8m5GQHzJyarBmwmrVkLw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI1tf/eYu583XiESkJqcFh0Ln97GwifsA4yJ
 5hjudYl5LCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNQAKCRBt1cPRWsUx
 M7CXC/9fvtgv/f2rLKFCQe85Z/Wsksb1TC8gpZAQmESeMsNOLwhQJwTmCgEHPluLgWZmholGaYO
 PnqbceUGyr1pcmOkepbh9WeQhL4X2VSfrEtz0/h20WYKiCUi6DjQ3COgz2a7ktLMFI97hvziCdm
 bvP/6V7nAGdhgaX5vVjhY3R9ZwFtaoK1vBgC48ycNo9pXyZAfuFvBcRGqEYuq6LOBAI/hFZIZcH
 xqCDdDYjQPSZH2av9CiYtQwZF5ykGASC3RunuGlgf5r27ykbJeWBfHvdzeoW2F3QkYqyH2l0vU0
 Z0S7et8IybfbSLMVGkurx+pcnIm7053a78ucdXh1zT6HrolfrzEBXSYNJluRMeCZjjAIH2AV5sC
 t8UzGaK5BaQLzP07023I0MrQcTZipUNmqyxr6TiuRmJaiSFAezEea6wC8bi5Jlni2CUujgPL+pY
 1hdZrIDSt+PFoWQZaFdmoxibu5GmrsqgFCoMZphc2Vn0XSC70lJ+vtovtimon2aZhoE9g=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 037CA100008
X-Rspam-User: 
X-Stat-Signature: 9aaw7kpacjhownf6ycesioirygyzsxq8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793618585-942158
X-HE-Meta: U2FsdGVkX18h8HY29gF/4ef1C71xLGpMhsmh4Vc+yBYno2Lz+1n8crHlAnFl33mGgnyb7IeD/zfyvXeZhD2zCj38m7mZ5UWLFNQTSST8hjoCLUvePdS6FWWaAss0RNJP2uFWPVXS0kbNtspJC6P6D78k3VYXCY4N7m8G08LjxUOZF3glRb3PNqL6XyGvlAF1gUxOewNSCRVfZeTamjDzMUdHHMT3hycwFB2NwkbcnGbX8Dllu8aBicc0gQL1y+HXfTS17Hy4D+6e+Jse91HNifApugLZKn+Q/iqkpk2ofJp1lOc8npolcsamz9DA/E+tY4ILvuAemtXcne9JY9XRyXfHP9e3wrXxekM75fZ06tCboB4ij6wV4fCBgyAjODsSn1eonult2Uq6dr3UXyv+zufQA2Cxgx5JNlrPvGNg1J+ZFGXzO5l5KMuiXoB9E+LCKv86zu5AD2UAWzqP2jDR4C9g8edvW6ZsYKOXR2RLenw4YdTWUZbUtNi4uFyQFS5Tv1El6JJaWwstOoe16wGTLVucew/GmFcSktd4N9z/0hdgWFBcpZVAPDJwBFFPfa7uEFzd8OyEFgGfaaTZnqHIIJOCth8z3Z5HiwR1CMdsNYREJYLikPrwONMHGYcr46x71hfe+XqwriNfxa/MN6ICg1ncanUB3Fc1dFHRT1pGNPl6aL6zu1C3v3mFLKra2m7fITDpNCWBmuzmUXSUu5dJVSNgJTEQYhkRDiup4CaF+2J5vzgVtqSfkicAb1fESYhpjWcc47wb+DxNwXP6QQguzFf4/fN8J3Php1I7oc9e7xZIxT+TKLxKCoSSFtuDNfYzGV0h1gS/MNlOaasAZsM3bZG+aGork2w1FMg5KQGrctZ4dXByuzIp5pN5vdbQQX1u7nL+/YY8DYGwaOF7xo3iBIEe6e+V8LJPitO7MqpxPbLCNJi07G89ul+vaJhQhewEPjhl3fVkwFLHC0sQ9AI
 wECPeBg7
 MX94TWnKc96MbY7TN1oE4CtPZ1KNDbDrC03MRvXGGyz4EtfjvA71M5qxPTApxPmDZbYh9feu2an8zCTyWtVmyVoRsi4iHsUc9oiigS5qXzvZYzZdOjnYmLcpAS6hCcarjeJsT9MWdNClN1QR6v5/iNU+rId1RS7wiGrbHL9h5E3i4w/asajPxpa381gbapsvxx17mP5HLWRXwKlI+v8HKU1lZtemT57MostjiJxw8aXtF0pQ9FNXpEXqI23ODZmMFC0aFoQHsvm0M0757XxwR1QDz3S5uvRwjFoXmWDWaYWVZpQtJArirXkxv9hP4J/s97oMoY4BY85t/YfYyiMEz7d3UdqOP9eWbCZMT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Instead of using hard-coded integers in effective_prot_pXd(), use the
page-table level enum so that architecture code does not need to know
the numeric value of each page-table level, while also providing type
safety.

This also prepares for using generic MM helpers, mm_first_pgtable_level()
which use symbolic names for page-table levels rather than integers.

There should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e9..a18a61e732c3d 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -248,13 +248,13 @@ static void note_wx(struct pg_state *st, unsigned long addr)
 		  (void *)st->start_address);
 }
 
-static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
+static void effective_prot(struct ptdump_state *pt_st, enum pgtable_level level, u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
 
-	if (level > 0) {
+	if (level > PGTABLE_LEVEL_PGD) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -268,27 +268,27 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 
 static void effective_prot_pte(struct ptdump_state *st, pte_t pte)
 {
-	effective_prot(st, 4, pte_val(pte));
+	effective_prot(st, PGTABLE_LEVEL_PTE, pte_val(pte));
 }
 
 static void effective_prot_pmd(struct ptdump_state *st, pmd_t pmd)
 {
-	effective_prot(st, 3, pmd_val(pmd));
+	effective_prot(st, PGTABLE_LEVEL_PMD, pmd_val(pmd));
 }
 
 static void effective_prot_pud(struct ptdump_state *st, pud_t pud)
 {
-	effective_prot(st, 2, pud_val(pud));
+	effective_prot(st, PGTABLE_LEVEL_PUD, pud_val(pud));
 }
 
 static void effective_prot_p4d(struct ptdump_state *st, p4d_t p4d)
 {
-	effective_prot(st, 1, p4d_val(p4d));
+	effective_prot(st, PGTABLE_LEVEL_P4D, p4d_val(p4d));
 }
 
 static void effective_prot_pgd(struct ptdump_state *st, pgd_t pgd)
 {
-	effective_prot(st, 0, pgd_val(pgd));
+	effective_prot(st, PGTABLE_LEVEL_PGD, pgd_val(pgd));
 }
 
 

-- 
2.43.0


