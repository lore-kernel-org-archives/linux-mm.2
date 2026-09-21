Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0452C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047B66B00FA; Mon, 21 Sep 2026 06:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AE86B00FB; Mon, 21 Sep 2026 06:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E023D6B00FC; Mon, 21 Sep 2026 06:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4426B00FA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F52980139
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:17 +0000 (UTC)
X-FDA: 85237470234.25.21CDE92
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92FFD180007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="MorCeI/0";
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb9H+uxRvArRVVJKhsUr+93SDYJ1x6sKU3xCIma4RUU=;
	b=dSW+t6nAy5ChAqKatxlGNqdLaflwMUD96ZkMIbwxhUmn2G/40LTP44ZoxeZq8w9dQ7gqaI
	Kvtzga6Nam4uNUYeYtyxPfbgJojgdHG1fiTlKZiU8lhcUKrmH1kevftDxOdJF+LQEsYrny
	Bc44BVmK7h05DkgGxVyhbIZLXLyQrgk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="MorCeI/0";
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988295;
	b=OJb03mcjtVEHMxrPwspbAhW3bB+eX7Tz3ijLM3T+QBdAdyzT3VkM4ApqaQmNbPHPmb3KN1
	wwRP+6m99yTNuMcDWD/XZB58W9B2EqGfBqYVgS0j6/UALYtPHL0OTkvzMb0Jv1wou/XWfM
	4Fj893yLgS5iaKDZTn0fxEOxZ98toJs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40BDB1570;
	Mon, 21 Sep 2026 03:58:11 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 825133F86C;
	Mon, 21 Sep 2026 03:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988294; bh=zghhBXP63HUkMVsnVTW1BBI8m5GQHzJyarBmwmrVkLw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MorCeI/0C/ThGp2D4ZEh7K7qiGRxxQCGAsOHcPHI8GDUa1xn7PAojRccrrdxW6og8
	 7gC8n59mRHcXPujdGPAn1COCNTSdHIzjz22YYHLWyrX2pcSMdp+njUrasxT+e7EdHJ
	 XyalCkCDo/UbMgMots6tY7qOdO97VEdNuudBqO4c=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:36 +0100
Subject: [PATCH 14/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-14-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
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
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1RutA9R6RYKg0XGt206R+FZYSBvFY5A7m64
 WCknKwpoKOJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUQAKCRBt1cPRWsUx
 M1QqC/48OSPJozKEnLVOpX6otIW9FV5BhnqTBmb/jwyRutaZTgzJxzVOUro/bD5JHER9PhjqHfC
 eNHCzQ1aUnfnS7hLDorqqVWwzassmuk8DAzqYuKYx91zEvDYa7JHkMxtVu+yZwGD4suG0HUTQf+
 dBbV/wqn4/Ti6iKvRok/awM2egxq3wOCeRisJK0d/rzhD4FGVvxR1DillMtTLyoQbZfBChN9JQP
 NS9xULrwDo4o0EjfcCUWv39K5oJhzQyWbtp9oqdCn/su/PFFe/MqZkv7neLUboJQqVqggUuY8T9
 0m+0FAwi7HeXPlZGKY54LikTFhGv8+Q1tjO3XDJqbLRmZjXxuoSNMR53I02cOkTtEfur207dk5u
 PqU8kFQ9uSI+wNPOym96FPcqi5SPQomkOAkxT1DTaDPdy9LP/KsdH6btJ2oVPH4ATfgpa/1ZL5h
 FjqEaVjHTPbvc7Tq5zEvipHN2jBSw3foGfVlRqGbIDxVSrv3u88KbKb0TC3yEmyALLVEY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92FFD180007
X-Stat-Signature: 1x4yyr5f46wp8gwtkn918ookhoe8hf9i
X-Rspam-User: 
X-HE-Tag: 1789988295-928645
X-HE-Meta: U2FsdGVkX1/dxqVxNRDKYs00CEfYhnjfRCKDBut/erB0Q7LphH0SiYjg3vV36bDdvGs/BkJrIX8AATNI+/OHAikoYthYF+5TEPqZMxJvxKUPznaG9Ozl0NT4LckbTpxHAcOLyPt+LMPa5CWwscS9LvJgRUntOSZeK5Vs+aAGjG6V24slG9VCUd6DuHWCdimeZ6Zj1Op1tJZ3DPy2NR6BKOqM/dfmcsr4AaFkZbVB+Ho82AWWCB1yLGWIdNeur5BQ3Vnd732TvUL0vG2yRZrTqFAkjvwAGbRao4wOcTEYOd+LQvy3eAYnxhP39v2gNngLAfg/wQB8AfUH0bDtCdI3gAinDmlqtzDYXjVy0mCyUgPJ3wWpGQcySqq9WYq6tNwK1H4W6zSA+quCBxoxLGC4ls2jweHsVa72ZLfFSHKN1NJhWxR7GdgiL/wie75vuW+lyJFYjnM1J41MJEPDBkdijCUAtRqeEP7pX/zBypImomRiuBoOJlxtOiV4d1mjL48rB0lGgh0OGF+U6EJ0Zvz78Qd9Uj2H/KV6XTcfgMZV60SMahavgh7t01xQWE0ce00gi2y+yo+oIPTXnAZ8w7O1c8xcUdqtKsjYkyqpxQH90HmeroDlbEiWvKD03REjXSEkIZx7a0cTATnpdZKjm4nsdYa+ddNtD9iyA+kF0VCl/xdJOiSD/1ze8m7cHYPyT3KMmjfLTOUHZ3d1bXoiGN6ogQ1SSx8PVu0NPKu62xmcOTBoZLE2RRdx0rnyBc0HYDpwBRT9wc2IqseCy7siKWQYs8Yx4yQZR+I8eHVSWR68lf/dR/EESri7IUdQ49w8JF6Ckqm2dDGAAEepbNN6WeoRDskkKH9NcQ21hvZmnvvp6jS5Xm728zSRr9E+vU8+lIQAzHBSRk61XzqWzYz1dXfErmYSfNdz6ICPLBvvDgWB57xHJkEVz5keTuXFjQb0faFE/cgRCXNAtR7AAaHr+Ui
 kmeyBB8h
 XJmqQofVMOTbHxK90VbBVCMTi9E+kzeKzXDA7clXEtOT98agRgRzK7oVNn92TCJrbAD6zNnCtlasfmG8TLDNeeAg4DQ4Wq+NT1dd9hIukn5x4MfLwk0vBjMBnSLpzL+UqRrh+5JAoXgAvRJlhkWZc5D+PQ9Xo6RkpajvPBDCXt8P4tF3fwQQeKs6H1xtfVuHQcBD8fduJbddTTIN8cd7FHTOsvXmTjhgdKrWBKAHSVTD1p3fszs9FEqCFUJsSvCW4tvd5glRkigwolA217sAUqMeY6xg2DyYUBM9JlCPVAnV9r438g2ctVzjy2l0g8qfSmjlSwUPxPTtarKHh6b9BdjVqxPQprk88tq3i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


