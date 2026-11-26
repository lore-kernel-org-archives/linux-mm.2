Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A392606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYpj+ngS
Received: by kanga.kvack.org (Postfix)
	id 789C26B05CB; Thu, 26 Nov 2026 06:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7390A6B05CC; Thu, 26 Nov 2026 06:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629076B05CD; Thu, 26 Nov 2026 06:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFE36B05CB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:16:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C38BE80606
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:40 +0000 (UTC)
X-FDA: 85477017360.23.2AC86A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07D5C4000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYpj+ngS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691799;
	b=zFrShUqm/BYcew4nDefZ92erBRnRAI0XLTa6+hrdaSgQ/oCMzrvzUFzGYwKlVAL1KxF0bl
	Bhfi4cxQL2SBEmvbAsAD8Ed1emmmUxSV16ih+p6AI8OzAR646GHY08N5rlCfmE3RyHXy7b
	JZkPJJxKcP05gMW7L7QDyE9kZmTpUt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWC/vBALKCjgB3Vp7e+Dp/3jppLyPAzKiZgZB+giSqk=;
	b=AdFS/lmp8RiJ5LURcOxLoQD8X14Sefbbl7If+Wd3/onEE0hNNEG8VFUK4F4ctqR17Tg7AO
	4IDqwwxg7NGOLmywHjJvM1Eqx67Dku81BTQIJLSpgcQi1ypJi8grRcrgtjupSlljH6lBJc
	icpJ7FFq2dViYS2KrWW9DBFB0G89J7I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYpj+ngS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BFA643B55;
	Thu, 26 Nov 2026 11:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733D71F000C4;
	Thu, 26 Nov 2026 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691797;
	bh=JWC/vBALKCjgB3Vp7e+Dp/3jppLyPAzKiZgZB+giSqk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aYpj+ngSiVFqOgPwkjKWlL43cMwZ+c5qm9pyvtLBv6pRVxFQz/EnGMvT3cqG60CKV
	 gp17gvtMKi2AUU8TijAS5yNkCTOTjH2Hcpzo5zl5CqJX4AX6FkoKmRtDnCuSFqV1Me
	 F5l2AWld4jnr12BgoJ/0hRgE9SX3p1+lkLsNAfVFhqEKgJ6rZL/qR7qp6M7cgLZYkA
	 cajyHtUCZrnpDkX20HptjbPShYFK0PskDHvCpXjIeQQYNmZuANQV5dGi67AmHknFT9
	 b0dh9ehw25xnd7VAFSRbYHeAn3Icdmn02VTQRbc8OoQpSYOJECww1+H2cR7XMAw8q2
	 JUPAaB2anngGA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:26 +0200
Subject: [PATCH RFC v2 13/54] x86/mm/pat: make the direct map counters
 atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-13-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07D5C4000C
X-Stat-Signature: zdtn7b896t6t1u7g61rtkcna9deqzeh8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691798-305498
X-HE-Meta: U2FsdGVkX1+9DyimujKY0Hep2Fsi1VCrFwS+m4IBE2XHNBpDqb0oB9N0hIA+SBFIU6FKQhr6WfgCVT4ctICA5X5oBBOyDMXz9xq49Lv4GpoIVB5Yc96XoAOe6Sx1cbBxW+bupjkStHB8/H5FlzLFewTZ8T+/Q6dTII1YooaJUrkPaGnkvgEE022SBr3ODNE2yuTV7hzZFJGmNClkmp+tNQtgXoupP5bnVGJHgsnHa66joD7h3XaYXssq+ReDXPtqD9ZGohJ7SXHUAbbor0uL9yPplDEwWQ1PqUTANr5udtfFDqMH9dwoaOB8RjpOiXps43WAVRQPrIM0RlVGWvgsQNOfUK1lO6jwr6EkKOdhTMqNzya0/utfe+N7rsRuGzLExdbut4BLDVsS25CKl0V0QeZVERks+fku0rFfm/BZeggMW0opwfHX3AX5lmOhuATxPQgQNF1a/iAaUdIECWcyC0XlP18rQaP9JvejmA2sEb2tg+MhMGBhDJpUiqrDTpxrR/aVEnQiCCFIU0eRpTvYMnFGa/yHtQXopOdFiN0LlPxNao2CkctUNpmfGgnOpvlB++ZLFBdrMzdDqxb8OBBzfkIiDfS1fXWTpe+Hrqv0YMIKWc3WeQV0BiPFBhUMlh5/AaoVZ5EpHCJoNjsvXCSHeg5UNM0fb97V1Vv4GvWk71HZjvMx7zUzE56JG/sGsVBYmYpP0Xuu4vpSEMbqs47ok/SEdY8bZPbL2XkxJOTfc0x4Nk5rWY8vhulmxRxVTPoMP0y2Ydo/93kBH+wKib37v79DiX5+j9FzwYmX6xk9n6gP42t5XZXB/hoYsB3+EO1TMGQUa3ZITdbXIbSRYmc8svxm5D1YxwxySAtPPsgZ2/hJUJ9VMvUoYyINpvEV4OERX2qynyIXDmh4EJRaeqLBLQF68Z72WITr4xcgArvwZYxPzgMQjpuJehaf6iynKm4FJi9Slw38yEkYETLSkqw
 9KNO0LM4
 eWR6zI496IPYGDnQKPGBUVDaufQF5ujk60WvHWTE4bYfnhO9VCvJl/Y4tyCiF7Dlv88x22fxEslPxZyIdS36sACoG+tZBBQ978nTq0hqZTWg9tzSbBjbkdrEs6gawumZwZiqLmIHt3vWEam/kfXGhbY/W3iQt3JDkopYqgrQX33Ircq8enApoQo3XTA02xom3/7gO+cAnmo/W1WjuZBH4N59MSwobs01A4sg5xdHfxiWjchxVDQeFTvrIpcgg3N3CD5vOCZCK79umF9oRYr7oLustFV90VCwvc481jUuWjKABWIKeGeZic1S2+dzgf/+cnU5xcDHg5oVh/jJ7V3d82UDlyyT3t3cqiNuRDb1KumfIUm5Qf/DmAsEQax+ZtmSaxBPLuiScycj8tjic9O8Rkt4WdJgXQvnQ23EJK+k/SnYjuWzyQ97P767jigzg+78/YR1MUkByFm6quTX+4tS/2KYn8FKGo8ejVhMD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In update_page_count() pgd_lock protects only the direct map counters. The
splits and collapses in CPA update the counters under pgd_lock that they
hold for other reasons.

Make the counters atomic_long_t, like s390 and powerpc do, so that updating
them does not need pgd_lock.

A split checks that the counter of the large pages is not zero before it
decrements it. Use atomic_long_dec_if_positive() so that a concurrent
update cannot drive the counter below zero between the two.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 5e3c1152d202..8076d29a2931 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -84,56 +84,58 @@ static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 }
 
 #ifdef CONFIG_PROC_FS
-static unsigned long direct_pages_count[PG_LEVEL_NUM];
+static atomic_long_t direct_pages_count[PG_LEVEL_NUM];
 
 void update_page_count(int level, unsigned long pages)
 {
-	/* Protect against CPA */
-	guard(spinlock)(&pgd_lock);
-	direct_pages_count[level] += pages;
+	atomic_long_add(pages, &direct_pages_count[level]);
 }
 
 static void split_page_count(int level)
 {
-	if (direct_pages_count[level] == 0)
+	if (atomic_long_dec_if_positive(&direct_pages_count[level]) < 0)
 		return;
 
-	direct_pages_count[level]--;
 	if (system_state == SYSTEM_RUNNING) {
 		if (level == PG_LEVEL_2M)
 			count_vm_event(DIRECT_MAP_LEVEL2_SPLIT);
 		else if (level == PG_LEVEL_1G)
 			count_vm_event(DIRECT_MAP_LEVEL3_SPLIT);
 	}
-	direct_pages_count[level - 1] += PTRS_PER_PTE;
+	atomic_long_add(PTRS_PER_PTE, &direct_pages_count[level - 1]);
 }
 
 static void collapse_page_count(int level)
 {
-	direct_pages_count[level]++;
+	atomic_long_inc(&direct_pages_count[level]);
 	if (system_state == SYSTEM_RUNNING) {
 		if (level == PG_LEVEL_2M)
 			count_vm_event(DIRECT_MAP_LEVEL2_COLLAPSE);
 		else if (level == PG_LEVEL_1G)
 			count_vm_event(DIRECT_MAP_LEVEL3_COLLAPSE);
 	}
-	direct_pages_count[level - 1] -= PTRS_PER_PTE;
+	atomic_long_sub(PTRS_PER_PTE, &direct_pages_count[level - 1]);
+}
+
+static unsigned long direct_pages(int level)
+{
+	return atomic_long_read(&direct_pages_count[level]);
 }
 
 void arch_report_meminfo(struct seq_file *m)
 {
 	seq_printf(m, "DirectMap4k:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_4K] << 2);
+		   direct_pages(PG_LEVEL_4K) << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 	seq_printf(m, "DirectMap2M:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_2M] << 11);
+		   direct_pages(PG_LEVEL_2M) << 11);
 #else
 	seq_printf(m, "DirectMap4M:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_2M] << 12);
+		   direct_pages(PG_LEVEL_2M) << 12);
 #endif
 	if (direct_gbpages)
 		seq_printf(m, "DirectMap1G:    %8lu kB\n",
-			direct_pages_count[PG_LEVEL_1G] << 20);
+			   direct_pages(PG_LEVEL_1G) << 20);
 }
 #else
 static inline void split_page_count(int level) { }

-- 
2.53.0


