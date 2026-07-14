Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859FEC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997A86B00D7; Tue, 14 Jul 2026 10:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947BE6B00D8; Tue, 14 Jul 2026 10:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8847E6B00D9; Tue, 14 Jul 2026 10:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6798A6B00D7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01AEF1A0406
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:54 +0000 (UTC)
X-FDA: 84987560910.07.09EA5FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 322A41A0014
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vjhfq5hu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDua9YY87aM7LX6RKGHHq5cosBzReZwnFG+9/6p63CY=;
	b=q1oBl+X85GdsYil33vogGFswuHWiy8cReAbwJ91fzm52pDTcweSQJusaQ2lFgbxfmRTckx
	/HlPpuQezvP+IoL9DMI+Bsk7RgE4YxeXW+nPVV3o5RDqt2UKgmyKiaXMDEyXg17BcYcD34
	b/DWq84FAsS2UDmlYyCiODX1+GsPLwc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vjhfq5hu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038073;
	b=cP8/r4lPqc6/GvPaGL4nVSToKjMjRz3BASXRYr7Xi/i04X5y/MR+jN8OPlLONosdhMP8EX
	TKI7/Ee9gFuqRky/0o/KNH2Zuq5WS6o+vJSpBVumvoOCecT55vjndrgLWaFXc/8mra8NBW
	hVwZA6vMU6YnviS8gxjTBUL0uL6tXTE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DE4E1CE0;
	Tue, 14 Jul 2026 07:07:48 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A8183F7B4;
	Tue, 14 Jul 2026 07:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038072; bh=8oYQ9MXuYWmm90weLSF/t4FrSgRMmgMLSgcdK785vME=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vjhfq5hujZgmkhySuJNw6Ovi0ZDPllrwytdpUl1CFaMMmQ7YlrA+FTdxr6ytaSSAO
	 1u9NsJ08KRRDg8iJcOgusKSxciglroRswKdfyUOkoGu8QXjmncAKV2aqeRer5z/ygB
	 q8OYyTsSmA+9Qr1jQYJQdHlBqhCMBgipf8FFPhm0=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:10 +0100
Subject: [PATCH 21/22] arm: mm: drop ctor call for kernel page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-21-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=861;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=8oYQ9MXuYWmm90weLSF/t4FrSgRMmgMLSgcdK785vME=;
 b=nhPVpPwxc0Tgep45F4r22gVJiYH4IqNiA/Z9S3Ix77hbH+m9X9zzxN6EovZVFIEF1e8oAreuL
 YHrL6dXW1utB0IBYjmbnRvx5pXQ0zPIU5EqMprfu37YqfA5Aaxh0XUC
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 322A41A0014
X-Stat-Signature: 6u7qr5ajes9hqs4aef8xh3ybt5fmgy7n
X-Rspam-User: 
X-HE-Tag: 1784038073-844515
X-HE-Meta: U2FsdGVkX19+Jt33KVsQtEtF3lIhGf6u1VlpCsqu7RTi3hN4uOjSXga7qUdbqdK4yvtIJB4PIB+5/+cYEFgWTaEYe5L0PmEcRxnK3FmuWB6ckrBD6ol9QxF0OxEuyr29UVnv180NjPi2UN3qTtZNrf3lFXDu+NT1flim2/rioF3ZCL7OuQaOq+qj8fo9DQjNDitmQDi+jiIeW2aNAx3sz5e6PMrnqJdNG4At21ziofY+YlSU1cg1n9d/CfayZ/FGA2c98mgRQVFwGePqR0YOc5LVsATQMMESgjWaTI2e8KJV+qpicXDtdB4l+0Ij1ywlbimqGuKuvGeIwkB6xkcaMy+QO/g0hGgeKTdTqTeFGK5uMT7U+8C6NfYO9mzzxzcoGobKIUl5XbSW2DUl5ZbmbWiP+v0UiMp2EzsqPGbNVeByDv5nWBg9c33r613tGZEYFxAZA/sYg0ZP5hyKvDomAcOZe6GFJtx3C4/iTAPRudA/tm7F1Nkm6HLfvNekH5+jIpBbYJAZ3b2E3h3IzrvuvrG4dgaWf48/k5EY4NKsiN+0lKiPS30ito7RVk3EZJV9CizWevnNwV3owSqWnLKSQR+KvIaZnzhCnRDRdZZI6H3cYUik5Dbhm9Uovp5i5Fs59f8LiKq86NlPILjQyQZYSKKxdQaLtFWONdBT4ZHOO3uNlSeorXTAKBgsLQq2dc4P3cdiye9BtIb1kxOWURdyrKaiMD/HOeXzfrQD3VVIpPkhcYiSoMaDvXOPA/CUvxDkwSFINrVYG0w3qkSpa1pzjPONC2HYp1PDhqPfMLu4YR4sXC2ugMBgDdga10arickXcRGVFYpZZsFkZmcf+38i16X0zgL34el1KwfgaT2B6C9/lFD99uEaOJPUo9xqoTUNj7SQthSFi2L7F6O8ML76PPYi94fZe1EpRv/TFG80scoXhinICJSCHpKI/Fu76DeLWJjcbUxH+mdqNb3tFtR
 1jnDiPCd
 wXCAf8YpuISDe8g3YBDJeJp1gAuE4+I77PpsIx2X5LNaevN1HsE2HKDQr2jA6wQ5cVkzxtgNw8tf3YcG66r7sLvHPWExycKk57hgMHhDAQtpWRLc0FrJNt9GlnYF6H0O2HVtTmTzdDG+wBKPZVuWnuKxLXvfim+1vjBe9F9dQcbhfS0Fb1fII1kNnmgeUoEDtU9Z7yJYvvZvKdR6TtG/HfpFhJqjpt4vkkBFsf3oUR0kfN7EQvYQLbFnLrPAmIojHP5FPND2sxeCBuqm4Jf/Geki3xbXD43W+I12qb4fxUKVTuWHJvdh1uyon1nmp+hnhoRWmEEYyVyLSfTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks to recent changes:

* pagetable_pte_ctor() does nothing for kernel page tables.

* efi_mm is also treated like a kernel mm by the page table logic,
  including ctors.

We can therefore drop the ctor call when allocating special kernel
page tables in mmu.c.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm/mm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 23b87b5ef7f1..c8de77a6f01e 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -728,8 +728,7 @@ static void *__init late_alloc(unsigned long sz)
 	void *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM,
 			get_order(sz));
 
-	if (!ptdesc || !pagetable_pte_ctor(NULL, ptdesc))
-		BUG();
+	BUG_ON(!ptdesc);
 	return ptdesc_address(ptdesc);
 }
 

-- 
2.51.2


