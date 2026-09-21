Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55511C982FA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7126B00AB; Mon, 21 Sep 2026 06:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8906B0103; Mon, 21 Sep 2026 06:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EDF6B0104; Mon, 21 Sep 2026 06:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D13DE6B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C816A1C0184
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:54 +0000 (UTC)
X-FDA: 85237471788.16.C255E24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0BFCFC000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BThdboLw;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r03SVNisaJd6Dqlau4jEcL3AHt7KSVLlnibo546VQzE=;
	b=ZVcw8t/Rj+ANGzABd/llKPLxhtRSmZKvkD6k5Q1JlpDqEPUN1OZC1vd0H1okaYG9/+gMPR
	4tqAhydAqwrnNRAuqxRG3AKJObPEcpwaXs6+jEOfJVk1c4FMK4dYbqEj1cS/1UP8Cwr8be
	F9V9vLWHzeWNeaM3lYsRsgzGFArj0kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988333;
	b=DYp6QagPGRlT3nwK9Sk3vN1CXkl750Tg09g20266E6e005DyBigDQfKgLwppoX59GKVLrl
	Ec+523XBtv7lczh3oIYa7DP4CBlTVUIE9Sj4w6teMH/fo9LMjSXWcvipTqjXSM+koZUaL2
	KU7E7B1eBv8VbjYl/wiTc2hkJxzMr/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BThdboLw;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C57631CE0;
	Mon, 21 Sep 2026 03:58:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12E133F86C;
	Mon, 21 Sep 2026 03:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988332; bh=dSuJLJ9ohCs7txtQHt7hy5Mg9PfzhT9ZTRhsbp3QTUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BThdboLwJgWaXYoH9hZWEZBjiZRv2Fu3SH7AMV949zk04FGwQM/S7e44T41HHFqBc
	 ig0U/2EjLwcRsv+kn9RsCmeVGvHrzU+JMOsKwYzE5TaT0Ma5zFoMq0vE69LvCBaH9/
	 4ET22UaBocVm3SCd1ar8dSE+dmzg+C2+T55N2vcs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:41 +0100
Subject: [PATCH 19/21] mm/pgtable: disallow calling (pgd|p4d|pud)_page,
 pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-19-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3268; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=VRD/vI2+dr2wFISWOiD6XpoJffv8Fhm2BOtCv803wXw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1Tk7kRq4iKLtEgxpTwxLYomoYS7bs7Di2hM
 iOcaArqGTSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUwAKCRBt1cPRWsUx
 M0sKC/9fNwlXps/S5pQLQVmMhjhsVPzMbJGpnIoLHcK+XvcblaBizi3oEaugKCqA4IADURZxi7N
 zeU9amkUNdxMyAtLqtqsPRdxMSu+j3HYk690xsRuu/io3DcfvB5D0j/q9hCj04SJ9Bh6IUiV17O
 gNPS5GYZCwInYoilXG5e+HDU5w+XUwHoO+31YrveczOJESkUQ629XwSLUYzTZszK4UTHSe8eHN7
 WpArw7F0ghyhriT0dILPWFsphGS9NifdWOc2+ZQ/1vOfre04d8kJHQb36FIwB6SFR7yI/luwSuw
 5RS5NpbJ58nx0AUey7RNro8jvW+HJmYnG9NO6ooeCMeXaKWbwC0g4p0lpKTUN6ZFzwon0SGwno3
 YUiLEt32U5HAd7gBIVuvVL/IZo0r+8jfF97cQKOV05fH01cS47H2K1DIwwEQt7PMkVszvEnPgEU
 pitE91INdVgJpvsLhPH3gte8+ox1sUn6LlA7pzFKeTV7DYzVwjulFjYbnWcQM6VW58Nd8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BFCFC000B
X-Stat-Signature: mxbqzcbqi9hyy6yt9aogfio6xq8tnfxy
X-Rspam-User: 
X-HE-Tag: 1789988332-875878
X-HE-Meta: U2FsdGVkX193FtBDkyqh2NtHygl3hu/bcUjXSxCpX37v6KXyYFpmXAjo/2dW/9ylWX2BGt/simR9ZPmJusTsYBgcKQyt0s+6KNdXbjXhDSnjneNzSDAs9EuRbOazUHagC9v/IHxYwORdUr92Ypsl+8K8h/OedgWBJ7/Y58GDHieRv0OHo14gg7/0mNJ89TTp9KUqUcCj+ls6P69x2KkACmnnSQ3HVkHAih83dw+cw68mMmNNPZ52uWJtRHqi6ZBFHd8qxeSFMQjj35kcgWebiPoaOYriEd95agHAU9b4DaCH3NZjI2HM3X4jl64/5llqemK7zeO9ZoQHXIRO3sM7xi07y5Om4yaQyFsgcjSFYFEN3JA8erXrkbvR4htwD9GZ3eBY8dI6eWJlMpfrLKQj7zxE3FS2BTuHuVc8VC676YIG7zI1QCDCBZOOLTxz6BX1kmjN6h/GszMFwgeKq/VIAxCP85od1fgKpgRQmUIojka4cTW1itVZ0yWwm0uTU5TYHalL/1zpSklZ0odNEjDsn8+3GNisq8/4bnMbwyXRu1N8CWZVBl5XdYa7JaxsW0lXDW/Y52kMG6XhCIJ8l+N1NiHTgwvt8WoVuTcSnAZeZUjrSa9aS2hrzqZilsWgSnEGMZ0xS5kx5mwe/IO2ffQCEibK4BigELoizvg2h/2LNDKIQ3t0G6N9uQQU2m4PPjdz6pekLRVPW14g3GwIXttadhcqVYYDZfHcQ/f2HpYZCmeIz1vimINjVQNSBUhdWirLdgxrOX4fkdNf0N335VgqEITdN7AFe5X4EP2zroKhXB6sVKDurJL6LJBu1yPRLcyQUxI32Lmb43tZ0iD9/nwVyYXtujgjbpXDl6fj6rLu6bK1Yos6hXIiancyXbb1/NDfAnuhvt67zI+nS8WoEn4OMDEgwYOMVQlHgB/WdqKMVFNodySJOj2v5vISOqSqiOgsMqR0nDCzGRZ9e+kK5Ul
 6nZEz9Sw
 HA9yAzwY1Au9WUkOTnLRf9rea09XToP6CVSyg8/ViM/BrH+z3MGTNcL1x6KZzwFh1Q5mDGCyymHfOfCjB3D9IcEcT/ZtZgdxYt4PvmMsoJ12AK75RKUs0pCnoHYdUe8jqn4m3Rz1+fnhLQ2wFI2hlI9S/HfUV3Tv94/QJF5ckx0583nyG2+vgS3ezxU/dlPHG4hVNmFKua8iSs5HMQgwLNaCLn8e55cP3Ms+eNLOBHtQ+phHhT1Pv8wFRdvt4jcERdFq5y7OMGtsnnUW6Z83tC4/5CBdXLycJ5k0tHO4UfwDOMcp5V6Gu3s4jBWKEBlcR0eoB0WGATXqpZIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


