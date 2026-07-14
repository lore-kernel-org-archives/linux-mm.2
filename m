Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CD6C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7706F6B00B9; Tue, 14 Jul 2026 10:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747A56B00BB; Tue, 14 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CD96B00BC; Tue, 14 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1FE6B00B9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5230EA025D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:59 +0000 (UTC)
X-FDA: 84987556038.28.1BDB610
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 82E6780008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GBHbIxSv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dz69MptF58JspLJ2rtF7ybUAV2FIyyNhQ9HifHNaDpQ=;
	b=JK3LIxT28h2aZPCjU2XQsaq74/pBviyXuq8GYGhBKwzPhBdXQ8Xgu4PXgRRWQ46otKv4qM
	q2rzzHgZXMfT5vBxQ6AStrKY76K3pOxNdiXbhBizZnXjpWK+G6CbQyuRgchHtduNSry/6E
	tn/rdpnurgHAHlEusmc5zrWCJIMBRnw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GBHbIxSv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037957;
	b=hHXXg3MjpMjokqqJ6mzqJtZR+4hYBZtmWNScAPX4kH8RWmrNhjDmvwbbgbm9OgbjbH+at3
	P44BkRCm+3Hx2IZWDKuUtGjP6t4TPEiTGfFqan1DP2BxHbB0wov2yCpOehHh6T8ioOkrBh
	xSium5kITdjXzThN5EknMHWqV0YOnAg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46E591570;
	Tue, 14 Jul 2026 07:05:52 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21DE63F7B4;
	Tue, 14 Jul 2026 07:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037956; bh=VE+lHAHWK4dpsc9V3W/UPtkE4aBmXym2FNHO+k6axB4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GBHbIxSv6yx6lpCATNlxlwrGWzZkjE50qqNWmTtSfC55Qij6ibNwZaI+5R9T7uiWd
	 i/VIOmdvMtutA0FQwIru3Tr0+8ZG+pxZmXfmR5SvbAQB1BQh7BgutmvfbwIFq0TwaI
	 MOql+/rIhlaU8c8MGd+SNjdFNyN/NAYTkzmX9Pu0=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:55 +0100
Subject: [PATCH 06/22] loongarch: mm: use mm_is_kernel() in
 switch_mm_irqs_off()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-6-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1057;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=VE+lHAHWK4dpsc9V3W/UPtkE4aBmXym2FNHO+k6axB4=;
 b=vNqbzx2iMvV1fGidU2iKtjDvRxNSiS8E7MvYIjkLSIIndPb41plWi7UyNf7PU14qsGJzzjbPF
 x7c/ZLWX2B8DhFd7ct6QVQiE/yCdMoFkL2mbSBPv7/C7wV2jkBlaVC2
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: 6wuianorqh5j66jgn4741smc9x7oo3tg
X-Rspamd-Queue-Id: 82E6780008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784037957-821630
X-HE-Meta: U2FsdGVkX1/kSYc9FZGOTvNS+5n/7447vaxtGtmSLypJGzFn4YzPqWPlVT7an8nFrssEq5mwSD8EBmU08NDvorx32IRsHnlzd+n/IcJhSAU3qB2I5dZX2ewqQ/M897u60FcFJl6ETnJj6xCr09FIbCKuoD1sDtmqocAjHI3Yl0hPqNaB4Vsws3H8GJUcwTdDbNLr98bjBXMincaJxiHCd7QD19HghOvKMuJSaOoC4AXwjpj0rfFd1v4nVfP4rQpoJICR4vxHFL2vE0EL0RmmUiLP08Jd5U/FojDzQ35U2RFwf41RXz1bmmdtzpsyiNBBcFKnC3BLZyyRkut4iYe7++vI09etf+kXxqBlkxE6mKwDFyrOE6V/CYOPF4adOHKjSphfInxDNTkWk6yrCz/Yw9iLxp4SoWv2ibnQu8QXY/Qvx6JignZ9UkxD2B4mM4AIl/+FDKUim34GvpvbKL58f2diKQCRJSVPBRU0R1VdFDiJBHE4IKJ9s6Sv/0WPTeAP9r8vZlKKBf8lWaaHFtf3ZXszhCv05uRbq4EC+ea8ov7IV8L7Qdf5ZWF0y39xiE9boyJflyUlsBGAxSYY/VE/AxcM7qzkzyX0KowRmAgeIv4hy5pak/ptj4l/C4ynGj4tK+z3nMbH74c2dk0Qwm/CtpYlEkBUB+FJKyev0+0YwPocbzUhcM4V+9q3INyjFb9H5pH/lJ79ng5PRGQvH7XLFT32qb+6rynleEeRno/ScqK/q4ElVw7ysQbY17qmEB2vuF0S9p9g7P+NBfa/rL8C3eDcLH2tSqDGakj7dJzS7TXNmUFsakf+cU+/0Aco78FaimKda390WnwdAbtsLY30+3JjRxbL3GToTAaKaoO7sakLkvrMhQlAA9QwpcbiQ1pHnJGirIMw8bG1HoVcO7WlOHbdAtZVgW5yOP+oyD10Cm5CV0s7y+tBDt6fsuopnRRnkL7LZ4SJmG39g6qaaLR
 oy9H+b7k
 /HUE6p+C3b+Xin/5micc3qN7quAZJWyJ8AZnI06NpjSQfToWvdWI+0WmahmIpEEyfyCLAoAKdUEHhYTYgboWzagLk0rJswnz007n6roH9hYa2uHSz8wrzX1JgqgJ7NXLfrIesxZ7fYHHnS6ozAN6xgaAxxM8bqv0Q4PR7FaOIaoUHI/qHdgXCsRUYeW5hg685b6DWEMF80WJs/MeCzVN5fsIh1I/RuNUcxCdTV8aUhMYKp7Lp8tJJ12zVB7EHIWNK+8VvfqDEel0+VLDFl7QCZFftvzKBlACe1MaDdalPi9ahwVjfcIeuS77S7ivn7wiQa31UIfXR87cja9b1ULeh35XopfPwFAjGv2nOq/xLygDoxJ5B0Ll9myic1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/loongarch/include/asm/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/mmu_context.h b/arch/loongarch/include/asm/mmu_context.h
index 304363bd3935..6d51f11427b4 100644
--- a/arch/loongarch/include/asm/mmu_context.h
+++ b/arch/loongarch/include/asm/mmu_context.h
@@ -95,7 +95,7 @@ static inline void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *
 	if (!asid_valid(next, cpu))
 		get_new_mmu_context(next, cpu, &need_flush);
 
-	if (next != &init_mm)
+	if (!mm_is_kernel(next))
 		atomic_update_pgd_asid(cpu_asid(cpu, next), (unsigned long)next->pgd);
 	else
 		atomic_update_pgd_asid(cpu_asid(cpu, next), (unsigned long)invalid_pg_dir);

-- 
2.51.2


