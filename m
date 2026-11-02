Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B10660A6F45
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bDcPyALH
Received: by kanga.kvack.org (Postfix)
	id A084F6B05D4; Mon,  2 Nov 2026 06:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8F86B05D5; Mon,  2 Nov 2026 06:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A77E6B05D6; Mon,  2 Nov 2026 06:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644106B05D4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:23:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0234DA0BF9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:45 +0000 (UTC)
X-FDA: 85389944052.23.9922991
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 348FA8000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:23:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bDcPyALH;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618624;
	b=lgyJLUtcdrNrxzkLrRAb2g6+CpF4PhWe64SHv1xuT+VZv+xVhz1PwYaYtDwOZONXJO9FoB
	5l4VXL0HQTKDmIjMRAu/WCElOKLKuDfnmFAbUw09k48DuYO4jxRcfq4srb0hRXcifmlhVM
	QzCGD0MKGmFDuuhjMNBvffiaTGNLuqI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bDcPyALH;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5o7BRqvZemOy4I3F9webe1p/ouSg2QH1C9yt6t24z0o=;
	b=huQ+1p9LNC4HVpudV5XIOv73jHWiKcT1I1MmE+Hj1zMHU9TE1Zfidhb94HECFnANHQCMJo
	bFXqdc+2vP0HYAkoTVicWG1gahXMrO+BgQCK6mG/xvkoa+cvkUia0Rbu6Sx5zgjiECGryN
	yyNZHsljnVMzATkOjcKXDHyVTNvWeQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D0C8293B;
	Mon,  2 Nov 2026 03:23:40 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 416693F632;
	Mon,  2 Nov 2026 03:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618623; bh=Q9JupG6Ga9Yd5poWoXsf1ojyKybY/JhVHRMS9+yuENk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bDcPyALHdw5Zl0D9VGE+COP0dcVYHFDY2m/TeiDjc0+A/crtNk6K62TNrxMawJglR
	 HuCzRFMzqJY4ZnK2C33oRnpK5HA2DV8dNNYXhI0MkQR1+TfDVeXdgdR+7I8KKSura8
	 tZryB4Pg0pjWfsU/XJyJ2Yyb7THMgfg7MzKeUjL4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:33 +0000
Subject: [PATCH RESEND v2 20/21] mm/pgtable: disallow calling folded
 set_pgd/set_p4d/set_pud with dummy
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-20-78840b2ec73c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3423; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wn+xbNqkdezctD1uOfR77s9+bFTC1HhX6zz+en43LNA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI41HYqR/DY60asrivvc260RG+DlN2TcOsBc
 2SoszCYpCyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyOAAKCRBt1cPRWsUx
 M9KeDADPFy2VaPWEZBujNb0vh7LKkIz7kEE4LevE/m07H9r7Pw9DXwNx3SYKLS8IC154sHLt7rf
 YgyNrbwDUdEpJob+IGYoqz/5K3DHBrZLHS/3qsWBl1KXeR/Dv8K3FWIQ5Ys+rf0g5d/FvdXApJs
 Pii/zng3OoTnqcPyWZZX72ce3RGzjrAoyq5+wljz3V7Ci0FAfKTvreFJtDbCbOWYIZWDV+zOHRs
 v5dDyQFCkAaYDieYiHCztilTWH3UVEa42+JNdhGNV355CTuH0tI408DW6YRmFoV5WNpB63Sydsz
 wYGjMGPqbMriOGW/oWyYBWkDKuO6zxjmC2XJDP8XYYy0BJ+JLQfrf7w5VWYbujb062ucuwx0S+6
 gvVUxMm0oWu7GbkWcJd8uZDyi5+OLF+PWF0CrSfaWEmNttOz782RwBi8oGpmDpCr4jJoGyBxUcC
 zVyZOVxtFTUtOUH6Huj5xtItNrX8U1FTI7uYkQ73fxPepT+046JpjWvUSeJNm1nPmqego=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: 348FA8000C
X-Stat-Signature: 51yygii3mpwr31a3mqpxm5cs7hxh9tk7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618624-931258
X-HE-Meta: U2FsdGVkX1/LHN80tLF8+yG9yoqxoiyNEbuBRYm6qGjYA+D1Pm2vkWWSW9D1GYh9EbBeRrunwq66+Ju0Ut0R9UlRlcE7cCeeEW+Ce+9yBEuzL6Vgj4ngqhSnvtLrWBwETlYYRdpbOc7HOA4JOYyOy15Lt+45Xlw1uRZC+ZsJUXMrP5IZH8VLNdFtJsHBBN7GWSc5trIGB2T7Ov8kjXxImK/Cvv8liseH2TZwxN8tMDL5bJpG8j884bORpwhJMErXEHuWfpWyrkW5rsCne74RK1uC6h+NaP9M/T2R5gjgOxWBtzqItdcVIbX/+dRSVmQcVvSSl8soDOnA0n59Py4R3ZhwB4ORRysy6dvLj1JomCWsNRb0SbCf0KdDScT7B5In1B5z1L59QD+dXiodXO60o2dLZN3SY3mPHdpzfJh5OkDZjqBSZhI6VBMhQA0abtJ2W6pOoEAKw7+8Mwcbo7ss7A/w9VlMsz6Yq20Fpz2OUP7Vtf/yYkC4srUm8gyT5EkM7tx37X2D1/C7nGG5lHyjSyOdPQ9R0kC6G/CgHv72MedxUwksCUQQbSeVm+kPgd9AK8uvNzfV9zoVbKuObpRunh7U4H2Mdc6WEzjn2/bQvSK7Fp3Uh1BIyRRGm2iV4lGa8NudX69L4JoKE+KjYGD7xx+oEqUxy6ClpXTOOnoJdZI8xamASpTYPuedxxlKL/rRNGCDY2aJptAGn7gpIQwAG3D6hJAZjNC0Y/GF7ALMUKuZUHvZbscbzvashT1yMtuWvOgtcIqLjhpaa9gj/EEBpjLuXhD8In0rYCbZnzd9AQP1+6ynr3SEW61dnpDsa56nEUqAhq32mQeNzhwRGwKK6dkzPfxD4VAXMttqC2yEEI3Scr7RGzH15nGXDsgs22YkP+/2lFKPtvJCOS6hMNxhfoSZES6/+tq6XMxudQ6QRCzIh7BRTMp+0uN9MzdZCPKbd/4aK8yEYYeHJgENb/Y
 wNnANK/i
 wWqX9MCQkmqfYyF8Qff5fDNfKZKPfGZek/DVYjb6h/v0O7ZwWJDuKQvjVjcrfVhBjnveff578z1uhytNip5CwUCHhWwSRk7SP6mFKbwKfxXLsX6Gborw0JcvUqwaiHKBNUW8f6r7c/5Lsb8nfC1gAD5cGCH2OTtUzrKmH6mLY8x36NaBzGtnreiS7MFuHDVg9g1svx67qKUS0BSWB289k5V+MmunGfalgwSHCzoWo2pupqZu2cFgm8+tF9unq9X9jYnnFkTLoC8ERUlX6vMNyhr8QE5ennyklaf5Iu893aE5pzDnfs/wxcnTd3uR5qcRPNkh9cAKgJsSFZHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

pXdp_get() could return a dummy value for a page-table level folded at
compile time. Passing this value to set_pXd() could cause unexpected
behavior.

Prevent this at compile time by ensuring that all calls to
set_pgd()/set_p4d()/set_pud() are compiled out for folded page-table
levels. Make the compiler complain if these helpers are called with
dummy values.

Since there are places where set_pXd() is called even when
the corresponding page-table level is folded at compile time,
drop the incorrect comments for set_pXd().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/asm-generic/pgtable-nop4d.h | 11 ++++++-----
 include/asm-generic/pgtable-nopmd.h | 10 +++++-----
 include/asm-generic/pgtable-nopud.h | 12 +++++++-----
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index d2dccf7542da5..12b01768134b5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -28,11 +28,12 @@ static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
-/*
- * (p4ds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval })
+
+#define set_pgd(pgdptr, pgdval)						\
+({									\
+	pgd_check_dummy(pgdval);					\
+	set_p4d((p4d_t *)(pgdptr), (p4d_t) { pgdval });			\
+})
 
 static __always_inline pgd_t pgdp_get(pgd_t *pgdp)
 {
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 2afbf2d8659dc..11b04c1071295 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -37,11 +37,11 @@ static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
 
-/*
- * (pmds are folded into puds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
+#define set_pud(pudptr, pudval)						\
+({									\
+	pud_check_dummy(pudval);					\
+	set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval });			\
+})
 
 static __always_inline pud_t pudp_get(pud_t *pudp)
 {
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 3264673c0c386..5ee8f1852cd8c 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -35,11 +35,13 @@ static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)
-/*
- * (puds are folded into p4ds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_p4d(p4dptr, p4dval)	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval })
+
+#define set_p4d(p4dptr, p4dval)						\
+({									\
+	p4d_check_dummy(p4dval);					\
+	set_pud((pud_t *)(p4dptr), (pud_t) { p4dval });			\
+})
+
 
 static __always_inline p4d_t p4dp_get(p4d_t *p4dp)
 {

-- 
2.43.0


