Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4638C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D346B0099; Tue, 14 Jul 2026 10:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE6A6B009E; Tue, 14 Jul 2026 10:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4636B009F; Tue, 14 Jul 2026 10:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 656506B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:05:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C63CCC03BB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:20 +0000 (UTC)
X-FDA: 84987554400.07.FE82459
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id E052F40006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:05:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZNaRsCzA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037919;
	b=4wtD+f/lFlMjhBBG516dAtw+2UFvfs6DakwVlKNd1YO6aTQzHaprd6o+7EDK/1eezMEYpg
	YEVigielt/o4pLtbzQJ6e1cQD2uttwQuqsPsyulRYnCi/NJ2rhZPjJUPRxdvm4slJVGXT3
	4Cr7LwABTpBGqutI7JMWCTmH2YtHzTw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZNaRsCzA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phHpo+Wmxx36MHxPj4C/6kUHr4sSD0fM0/8i7RvNHM8=;
	b=WQ6sjidlyZQhx7PXvGpY+iBQTIlMH+Q9MuAgK5VTw9MdFvZgvve6QyrTTiYLthygYZ1wAu
	QxrRncWVy1/TVh4twJsiBgJNClJiRDlTrgK96cbvFuLGJ2dkUmh8tH9i48AJ1ESh3THV6D
	gXr+MBzqhrC/eGbFrX7zc5vSGUQg+Hw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2F2C2F;
	Tue, 14 Jul 2026 07:05:13 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DEFC3F7B4;
	Tue, 14 Jul 2026 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037917; bh=w+klhTdFU9VL3dvxDzm8zfdFs5zqm0APSZWeudQBGNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZNaRsCzAt1MnFAcOqfXFWvT4T4lPSEzMCEGtQrD8PcOucfEtWoppc1fCEKGc9cJXK
	 6RWZuY1RJvPlk32rxkdaZDZjs4oIrAl0+EdZq5ACM4/oIU1EOINAjEPtOBYdtmnjAy
	 gQq/h8AoBHc7SVStww7Gu1VeAurSqfnl+VdiDEVc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:50 +0100
Subject: [PATCH 01/22] mm: drop unused __mm_flags_set_mask_bits_word()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-1-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1348;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=w+klhTdFU9VL3dvxDzm8zfdFs5zqm0APSZWeudQBGNo=;
 b=Ifi0NsVAxXOM3X00d29l/TBqH4M9i/euaIMaezX4RjYeZIsEEEbWOkkWnSKDmLxeFJ4OWFsJu
 hMlhl3GESzgCyZw7KMYDONi2E6s1qECPsAJEDuKo4qx+p6nf5J2ydG5
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: E052F40006
X-Rspam-User: 
X-Stat-Signature: fdcf4qm6dekudzwsiu54uof8iqw69tkj
X-Rspamd-Server: rspam03
X-HE-Tag: 1784037918-77953
X-HE-Meta: U2FsdGVkX18ZTPl7E8zbz7oeDb6/uxxwB6+hNN95KuVaXDDzZfKZw+5Rra7kFd6CRP38gQj8DJCP0y4ImZK6l2CpBIvmTyujEWxrWWvICI0l61FtxftSGIbq5Xvo9ceTVlO/zRCeYPZrmsKoES9sdLHA30EwGwvm+23tGgRIIjzpvbU+o/qItI/G2CMJYgzckUSN105VZg3IOtyaIX322E9shccpSJr0gvb4BtmGekDUSaZUmXRF5TmSoji3aCArG/IiMn16Tsn3rq4ccP6Lyv9mOaYUnQz3qEW39WBRKFBH9n/9YZMT0qBZH2pOyz+IIPLiBnz6ZfiF4K0xfFFQiIvBEjiP57eas/RMkyLL1vCOWWFzdD9gWbhnuOgJsb0sRyDRUU+h1g+NJKmDvJQvnWm8dYS70LjOkKpFwh1STNixIXIUOwGwwxdI6W6LO1ciegcv/+6r6ljQDxEjLjPl4U8Eb+G4LA9ovC07uUgGFMCeENCDg4E22F1a9ypokv5MCTXCZEvECFQ55D0pLhKHKDAhrPcGbNk8LPZ7yec5HSPdQwcF+LYi/X8LHjT1ZB6VMiXsaW1hDHXe4Jhxtby0gJfDplNub7lXVgZXqdEzbQ80EiFFsm9QyrI9T9iW+MP0kuuSSnwUouA7k95DO/m6OXNnFnwKf7UElUy42q6Nbt8sIELDPlTG7q4ZN81UrmUFA9n2Lzcc6LozF0jyOezkHQvYoUBhDOrqT3/QycJ0BLdUcPgd+7NuAqfhGZlN4rgXCnihy8lH/Xj6S1hcnG/IB6FK/fMGLNC2RyOJMVRttxVPZKqg60xeOViAmapKa/4xBfSqRkUnAeFHMs8nvOsgsbk9/QKmyTXo/rYb93/LWDKw09c/N0ql+xq/CTpmBLZui4xybukpGuw9ER5LkPpqmOgrgY+gb1a7anCq+jADiwpC9WGXi+zKaspNoK+YMf+VcyJYi26h41RvR6PQ73R
 beaWs9/h
 CodzJZjBoqXnWkjcPTX3Dy2q2Ly8SrUM8AI3S9Y+dMqNrkKswTA2VJerxLnvG0WQpQyCUPEZAQ389nEXgkStD3nS+r86xkFBEyqId/PNBwRUOEwJBUQ/LMAW11/OzyUUBUTjCmhSu1bxpKWB1MbZ2rwzHJF7f9Iig5Ovt5OczRF5ezwdZ8xdTU+e31L2R++bcCLBicW7nKOGaAl4tS5Lu528EZ7KYrNMLGllkoIActfA0n+8WW2Zp1BUvmGhxXltvYhWvcKP9qkdIdHqar2wOWGKpygu60JOOdENiU4R0r9kCAcIe3ZazPvK8NiQ1hhQnmUOnfLtV5jjAoI8x2QOcyzYTdKaRgiyIKsrqjdQXV/OEeKXcAiGNWlc0Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 39f8049cd49f ("mm: update coredump logic to correctly
use bitmap mm flags") added coredump-specific helpers for the
remaining masked mm-flags update users.

That left __mm_flags_set_mask_bits_word() without any callers.
This is a special-purpose helper that is unlikely to be useful for
other purposes; best to remove it.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm_types.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ae9bca4eda5c..b4129beb9c4a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1432,18 +1432,6 @@ static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
 	return *__mm_flags_get_bitmap(mm);
 }
 
-/*
- * Update the first system word of mm flags ONLY, applying the specified mask to
- * it, then setting all flags specified by bits.
- */
-static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
-		unsigned long mask, unsigned long bits)
-{
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
-
-	set_mask_bits(bitmap, mask, bits);
-}
-
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;

-- 
2.51.2


