Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 105B7C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28676B00D3; Wed, 22 Jul 2026 11:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFE96B00D5; Wed, 22 Jul 2026 11:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14396B00D6; Wed, 22 Jul 2026 11:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934CF6B00D3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D7CD80201
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:16 +0000 (UTC)
X-FDA: 85016803872.02.39F0E15
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5078D1C000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qRUJLFHg;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1rz4U388dYk2TWJBdEdzUA6wKvmT2TCvPaExWIsgTg=;
	b=P644h2FssgWUL/fXuRJFfORjfBCBPkisjH0upe+9fO6qVwPXoyY/jJNMTRMzqD1VNQZmnj
	ZhNPuO3FEO4XX5wm0XvSlLpQ/pNasVZYeQT7/w9Lw2SnKCZ3PxKqL3t4du+TxB3uuKVKL0
	SCTbRC1roTz+18RTRF8qJdUCPIPPx0k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qRUJLFHg;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734334;
	b=nKa3BbuMSI1TnrtUacNDuHmmElBWMdXYLbgzQ8BUMvGg6JpebYTLUCItluFVsAs68Kj06b
	3tL3q3gcC5QsLVEZYFe4bemDwq7QPS9o2LYgXMYTnAJNyjQEyWMWTjb9pVqmkJyd8MMAjg
	/tng88991aB5Syp0GOESHvYMQNjU9a4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EC20168F;
	Wed, 22 Jul 2026 08:32:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA6373F66F;
	Wed, 22 Jul 2026 08:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734333; bh=yIEI9TusozWN8JuTGtczFutPYB9cl2kOS5ZHqTwGcQ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qRUJLFHgOJjrfi+0gOnSAAWEwPfJRGMmZiCR/0lSgWgMyzUOCyvBmFc1wrXlZGTug
	 +NmZavPY1FkNb5X9TeGnbtZD83EoZCYeskRRy4frc1M8Vh74wbAQwbXrcchc7SzpPG
	 EpZUSMLdn/NzjDMJMU42Do1Z9A6kSfv4QS/Zu/sk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:21 +0100
Subject: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2785; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=JZD/Lbfbj4HSmqdnx7eUuD3cSDyNIRyRTYfHOiVHoYI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIVinW6xJ66J0AtgWmoOBZtJI2fJu39cT+lG
 lmMvjqN7dmJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFQAKCRBt1cPRWsUx
 MyCyDACle63B8F6HDqrCyaIvfxal1+c5g69sl4AqthRg5hNwvh6sb1rxEXQB/52AWeOXNH9P8sR
 aDlnR0TLzPJEldaqF746pWxMSKMrSydQ6xEWF3RWwa7WRkAZidtkw5heNBQGEHKzfWiwRW8gjAu
 k2gZi06lUIxph0Ng9HnPaoOHTQ8mVePaIzcmaQRlTrI4fjoHxddyfgzqqVtef+CYsvIFerrUzCY
 +TKNNtfkN3EqkPCNpDmA80f6fj4thl2/gTRaqCVex8in/rEy1PCid4f7edIoKlXUW7Ov7/vmN6s
 oSgu1pyEnnf+gjJZ2ZXc3YmrzRhoody2r0uJy76JCg3hjD2VTb6hw/uSFrO/spCd6Zyo2+Dl805
 ztdWGgHUEEuWsQn2ZOG9CNHwgwPSo0WuEfwGHlnD9Z2VEZ9n6XsBJEqTCnUnSCBO4O2DaefO8Ki
 jwe3YWiyFr3Zzq7G3qqDmUmmBm94H+C+l4mENG+3rFbDzXHuFtK+NWkNmEwmd/4ezLd50=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5078D1C000E
X-Stat-Signature: hprk1rn3e4np3qc5q5rd9o36x561498o
X-HE-Tag: 1784734334-816332
X-HE-Meta: U2FsdGVkX1+48dsO3Q9GDJHwlPiv2IB4NSgEDLrfPXeqqCUupg5FWoeirU0SuLEyYJeLUDoYfBa5wh+h5t/xVWwOs4FaLE9RMDl0aTk2jUKyIaC4gCPT210QNIi2ral06ygYGu6zVEQgYXmhGDopcF1hZnyYB/vQ12u6uXTznHXBzX7i0veLFwA1z2KXxnIFMCgIfh+JhrzrMAG9KmaOinmGbv9HvV2TTh/7vFiA/QLE0LGmX6ed4j1IRqU0RLppLmjvAA3c+SCGfSc14YexvKh1uVDp2FtsmwVjMpmKiHeWJOFXqh8rZWzFMk3PWFSlUceCv8/oHiugXzM4T5fx/yBqVoTk9VU5EkVZAu/JElsEhYA+nZ+HcusN6KdOslX/Kx1MtGrzGQyJ5bOrfCRNPzZ924xtbfaLkBt4/d3aW/NCsabl7Yn72QmYAR0IFFHmsj/z55pz8yEee27B9jpIMW+lXQobdD2XdznQt9+UPFUXWXjiAc73nBGSafH/TTh1j5Gqhw+4kQJiFL7nTILMsa3B1baLijUCUHra0PXdFQKfYAQhm74bYo3o8CnR6CHpEBv0EKPIYF4WPBWDf/UnZcRhnvmdZN2BzrR514kwX5qJframkPg0acPgjNL8gtFztAwGYYL+ub5DwOHVFpYlM5ZflI8vMEb5ODi6jCVeK0k3My9GFqFjFh0miczFLtEpO7yggYh3P8vM+BFfJeEHUtsZeitUikLaHBIfewv8xsHPhjSNrFIxGjXnrCK/HpiKNOLWO3trjg7Hhr8PyxHuKWWBvAzr5MWYsc0uRsdccFbsxp9Xmp5mC4tLYmDFn4OI1zQk1EEqYHWZDbZW70ba15nxnDwCoYbkOSHuZ6kZpU0ky7CT/eqBdu2R8Db9npdUj3h4/FRJsGaLoOeOGYCYdA0B8Pydbj2vrzLXWR/W24peYL/XOXF8gcQNWed+QhUiYenZu6ARDe1kx1vdAuT
 PZx7ATKj
 2SMeD0Ih5G6/V0INZx8mY9HZSQYEkZu1raixZQiuPS8YNCe2bhSEFxvs04em/ruzZ5niSl+Hy/NXGFpGrwx/rBHrmKJJnl4VZlCecDbV802rmXeNowsMh76bhZ70zMS8ODigPwFlFtDRwbA9BeBsNn+jUUp3a0KusIgS2GkEMgFQayFLz/3kPQeLg8G5rxzTLLDH5EaindKf1IqLU5K8VZtBxM6jCyZJjeKHrrIntpVyew90soXEVuH4aDCrN4dCe3AENjC4XfrRf2WsoAN5BvIHLaPvSZoQy1QlBy8QhdkQh8Vvw2HXhQyp9DcevsGJVH7bA45aMNBD0xgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, rework effective_prot() to ignore any
folded page tables entries, as it will unconditionally get called by
ptdump core with pXd_val(pXdp_get()), and we really should be ignoring
that value for folded entries.

For this, introduce ptdump_pt_level_first() to identify the first real
page-table level and update effective_prot with higher_prot only
when the current entry is not folded nor the first level.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c |  5 ++++-
 include/linux/ptdump.h        |  1 +
 mm/ptdump.c                   | 11 +++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e..4e545988953a 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -27,6 +27,7 @@
  */
 struct pg_state {
 	struct ptdump_state ptdump;
+	int first_level;
 	int level;
 	pgprotval_t current_prot;
 	pgprotval_t effective_prot;
@@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
 
-	if (level > 0) {
+	if (level > st->first_level) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -455,6 +456,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
 		.seq		= m
 	};
 
+	st.first_level = ptdump_pt_level_first(mm);
+
 	ptdump_walk_pgd(&st.ptdump, mm, pgd);
 
 	if (!checkwx)
diff --git a/include/linux/ptdump.h b/include/linux/ptdump.h
index 240bd3bff18d..26fa624eac44 100644
--- a/include/linux/ptdump.h
+++ b/include/linux/ptdump.h
@@ -29,6 +29,7 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
 				struct mm_struct *mm, pgd_t *pgd,
 				bool checkwx, bool dmesg);
 void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
+int ptdump_pt_level_first(struct mm_struct *mm);
 bool ptdump_check_wx(void);
 
 static inline void debug_checkwx(void)
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 5851096e6f65..96676c90430f 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -197,6 +197,17 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 	st->note_page_flush(st);
 }
 
+int ptdump_pt_level_first(struct mm_struct *mm)
+{
+	if (mm_pmd_folded(mm))
+		return 3;
+	if (mm_pud_folded(mm))
+		return 2;
+	if (mm_p4d_folded(mm))
+		return 1;
+	return 0;
+}
+
 static int check_wx_show(struct seq_file *m, void *v)
 {
 	if (ptdump_check_wx())

-- 
2.43.0


