Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63384C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578066B00D4; Tue, 14 Jul 2026 10:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FA86B00D5; Tue, 14 Jul 2026 10:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C866B00D6; Tue, 14 Jul 2026 10:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23F426B00D4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB31880371
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:39 +0000 (UTC)
X-FDA: 84987560238.19.6866D3B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D564B18000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X2EPALpi;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoCRR95PLYnVxjBQ0+K98Mlg61rzeKsyaOHBI9FlQ+0=;
	b=nUgJxf3XdcQWboF2q/J3DDtv2OU2ajPn8mcvowWCXOm8eLBjdGQvgCcp9006L8m0qIWnDB
	nRaI/buDUlon9RErYEyMKKQ4YMrsYo35EsYIFsiUNJ1FuDW6RsbtCECf3uyHRpx8UdHiGk
	wK8Z0PqpfZVRq0qRuqe4bOLMz+/KlHg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X2EPALpi;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038058;
	b=XBUwl9/KrXoNbV7HO+pSjcvOVrVtROCq6CGMelQwgy8Lsz1fOfjGsUfEeOeCzAl84uGYTG
	ByLUOmhzumDILvmV/Xcb0kA7d74MYqiXt/2oi4zXHSuEchKPGzTdjQCJ/ZSli+kaLhk8Mo
	VKJI9C0sPr1Y0CyNAE/nlyYXKQcu3Ig=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B74CB1D14;
	Tue, 14 Jul 2026 07:07:32 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FA7E3F7B4;
	Tue, 14 Jul 2026 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038057; bh=VrWlMtHqgM/vx22jiN3vYsU+W1Lh9jxCM8/DJ3H1HHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X2EPALpiGXj7jZ//umW0i2ZiscPs5c3b9FVhjQsTjSc/roIUOCw5ccwKbAM8AZVT0
	 R190qpIisEqdGcWQOaI8LP3WSMdBvOg2L0DaCq9z+740FCzemmIORnkMA6TGphJBf+
	 c9VjfZElkzX4N0E1s95w/Vtd50JJkhxZY+d0MtYw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:08 +0100
Subject: [PATCH 19/22] x86/tboot: mark tboot_mm as a kernel mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-19-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1553;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=VrWlMtHqgM/vx22jiN3vYsU+W1Lh9jxCM8/DJ3H1HHw=;
 b=m8zZWjxysI7gu08ZC5WjroF8ppS2XmCi+NSg9AchPnK6c6wz3EcnLIwt4UrkZ1Tknhd8Uq+lO
 humwu8pswzNB3IZSFZsQqWeKm+RG8SsPRg6CN1eLU7ZKufXomLaUKal
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D564B18000E
X-Stat-Signature: squmazf8f3iwisnx5ig8733iec34hjkm
X-HE-Tag: 1784038057-152977
X-HE-Meta: U2FsdGVkX1/hVGlSR080E031FltQzCz8H+FefLFr9K5T0eJXbMWjJC9Z6pPw8PkVIEf59XiYmWJ72etOB5wJ03g1tO67vl6qxu5TqzVg7YxHUbLtFsNDKj7N3QRXEFddaX1o0ApHdCFocmCAMXT16Yw+rVfp1Q8pPW+be54eaEebx3I5CfXjCKIIks2YZSEvK0X092vRkg65Jp/J7nj0DPonCaRL0J0rBvFBGkFwQDqHOxz8C9OiDM9WLVjSbzC761UAaeJy3OCkUxrzjb6UEtrY/O+Y4M6PGkyuKo3qdyfzJ7R0iXM7498anGykpyuLIyO4Nsah8Hm6S/9rY7IJ8OiJrNWpndHp2P7njN7Uf2CTBWSrS+eDhVImoszFkdnZcA/dzwmk9ynfvacRAOOfp4veCweYiEVEsJYv2B1ozO2fukvvg8BvPwHMHAGsi5O/ZVoVXH5VOi9LTFzqsT8lcum73OQIwJ9ypH7GqRaiA3qVbBNASncHQXBPyvEOu4mTY+qOKadRuJIn4uym44AJz0w9e29sZ418mGB9towS1WmSxxQ0tiDzj1FZ45ZdGWVw2CNUNWziWFWT7IkwKJMMxTzUq/SFzE5AGqYKdPjwbo0+h0LvQNMKb1JeLE/U5w85r4kXc3z2Zze+gj/dML3fQ2vQoxq7OD8CWfaaBiw7KucxBWSvitEL17/Y5T0Fk3oInImsdYa/SigrN08+fMV03CeVdJGGKrdZLURiNaJcgrjxST+c0gezlYSK+ovVI/BDv+hCt0+GAWw8ZSJV5TsMTdvr1owEMcZu5MzSPjTm1hdjyOwqymVLYJzL/Ztf91CYZ8HljOMy6cK5BhEFCCEIpxgJi6jJFaAawEbpXA7Vf//kljTt7v0LpAyyNpWD5BwpY4Ub/Py2TVvgd6AO6wHax6Fw18HMncsHWHcOqw2JPIXm3FG63qLPVIL485Qt8Rw25DI2y/gt9DdhJkKW00m
 uxO49gTl
 +qGFGRxqOh0b+g+kbrioU2Us6Y2aSUN3MzQY3ON+eCiApcCpeuLpBHgN0aqx6sfu9nyoG9WlvHIqwsBdUxDaN74qbuDHlA3uxT/PxGsgC6cMYxP9OBrzD7o3rDrrBgLO4pfQOCYphIjviYq9ySwEIxXOgo/Da7zYBQSYNp/vQ1/PnP46nKNsmhCNSyHQa3dkBP142mAuk8CWS0PErDIMWmm2QyZTiaDT0Pr6np6TPdu2rlJsHG0AA9hMXeK6O30e0PvlgkmxhRCvW3zlSXZ4uu3ww/Rixu6e/7+53J64FUfKyJLpfgf+eiDsFvE7m2yP+O33wgH4yY+4UuDW0QK2/6b4zjE6MAq5Ky3JhaCRq5E+d3r+mtnegG3TeBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tboot_mm is a kernel-owned address space used to build the
identity map for tboot shutdown. Mark it with MMF_KERNEL so
page table allocation and initialisation code treats its page tables
as kernel page tables.

Having marked tboot_mm as a kernel mm, we also need to convert
pte_alloc_map() (user PTE) to pte_alloc_kernel() (kernel PTE), and
drop the matching pte_unmap().

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/kernel/tboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 46b8f1f16676..08c899f88e41 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -99,6 +99,7 @@ static struct mm_struct tboot_mm = {
 	.pgd            = swapper_pg_dir,
 	.mm_users       = ATOMIC_INIT(2),
 	.mm_count       = ATOMIC_INIT(1),
+	.flags          = MM_FLAGS_INIT(MMF_KERNEL_MASK),
 	.write_protect_seq = SEQCNT_ZERO(tboot_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
@@ -129,11 +130,10 @@ static int map_tboot_page(unsigned long vaddr, unsigned long pfn,
 	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
 	if (!pmd)
 		return -1;
-	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
+	pte = pte_alloc_kernel(pmd, vaddr);
 	if (!pte)
 		return -1;
 	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
-	pte_unmap(pte);
 
 	/*
 	 * PTI poisons low addresses in the kernel page tables in the

-- 
2.51.2


