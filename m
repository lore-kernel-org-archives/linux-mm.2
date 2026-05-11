Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F98CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2175B6B00D4; Mon, 11 May 2026 10:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C85D6B00D5; Mon, 11 May 2026 10:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105366B00D7; Mon, 11 May 2026 10:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F318C6B00D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:06:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 899441C0043
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:20 +0000 (UTC)
X-FDA: 84755313720.16.50F44C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E4B3320019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qpwR2/9i";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=946HNQNfXuzzT50sg+6zOZh3cOdkYAiL2RkiOXSaKFw=;
	b=HuiLSn/dGzJh7QJ1CHdSwKcPwYwdkGLyUKU6RVCA24pi/CuCwYFQN4XWts9psTgLmmSb0q
	fVwkIeCTN4uhH0qCRTcJq19WCaCycvMy6C4oe3+bL/MUf8p20vi2Y3ZbRh/m6NVbwZi3qD
	ARZzgl4bOuQGsxtmLwV+vnOhMgn3Ado=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508378; a=rsa-sha256;
	cv=none;
	b=65h9EOgg+7Aan1+SkO5L6K/Hs8lbgmfX4PytEpQhC4FCxSzMJpSUnhrOHp/IvOyQk/vvIf
	MMox6LBPEqRjVuMwLUG9KSUJwMg6wGhvzOI60Yx1MqBmDPV2O/UBWkgw7rMNsH81P9GwRB
	nG0jzE1cIOTPBRFp+qS8wLh2Ghe1Bfo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qpwR2/9i";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7063360141;
	Mon, 11 May 2026 14:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C15C2BCFB;
	Mon, 11 May 2026 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508378;
	bh=9/8M2sHV8SgEK+1FMWV6SnFszJKpiz3SzVlMOl5S/UQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qpwR2/9iNsX4kETinr2qHODBsLGHsPUUZrTsmeM9AESKVpqbk81P30B5Y9V29uk9A
	 tXiVq2FwNHSyozJ2+Ri3cRbL1te3EmQaN+VS+XQYpJYTlcm4xAPX27yYLrh7nmMTrD
	 gA0MD1DSzhX+9wxHm5shlRSunGZB+V2A7zDp7v7yvUne5T/2ZCeEFG/K7hMiMRiRtQ
	 gX4ninWFuT2qb9iDdfMe862XUG6AnojfBtmLDvIdhyWwqMS4Ma3gvo6DH1pHILXIua
	 TT8+gJHZ/sGaRLC2K7SHzvggQ6ftTyvU53+mUI/B+NKg17cQzQP7qfBknfq8GwUGkw
	 60KofuPliv/dg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:36 +0200
Subject: [PATCH 8/8] powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4B3320019
X-Rspam-User: 
X-Stat-Signature: 8fxhnna3g566sbcy1fh8qniqs398bjbx
X-HE-Tag: 1778508378-638816
X-HE-Meta: U2FsdGVkX1/kCGavHEWReWzcQKtqTPh7onKyZNG9CFsLir/3XIZ+ZcnQwT8y4/GpKX8rL6wDNPULjJsHEbHajJECZeRjmMWQ441LS4cphmryhfnxt3IlCuhnB2MQFbSYaWJy++Euz+NfQBgqokeeCVRuSrRHqZW+2dDF90IlAAKqlYvLeuxYafJF1aZu2Xyeqoe4sFKxAYrwdl/RIivval6PBVEvh4vEexkum3aWVFOKStcGDj1PTA0UF0F/5BSjFcjKL7J3DVkpUeXJLcmVJINsGyRxG+n47HvwzeHcBOq5gaGU1VVsPWwCsvCcCyKSxQIY+gsgbEOEv8PAohnzf25XqJ40TJzLh9UtrBCv5NMpWYYsctwoEX1eBO1F9Qsmw0kOVs9040tO/pkoGq6ySleT4070jWnPuhHQrh84n5o18rDLeaC7hTKw8985VWMJXaVeYYtY2N7UF6yFWxJFLUbrUXKAzWJ/0hEBkga5LJTDGR/G39NX/KEE4a21j3hnjZ3gOj+0AUdYbgoGYwClzYQRhaK9t5BjFycbl1HodBvHrSc2O8h46nap1Qv4UnhjRgv+5/DipmPYxtW6xGD9aJWMLC/zhtJ5iFfs4B//iccCLcDYZfBJrwSDsiRYYcP3WW6G+n4djWvVoFnGybfh+i1IjaObvoy5nBVs2GGIuMC7yFbu7lwBu7vM87Zdpo7WNmjpw6P9gbTda72EBLdahdsanVLYBZ9gK4MPpNGuc192+22uFn2jHaLQB+WlOBkpHCnUvwRyWjKWTJU+e1eefATXb9WbtlJynhRAT4thflKtl4fEJpNEqVC3BjSNnCrox2DP2Yp6m0vvqUoOCe3+TJVrpjz4ry3Jtdo12JxCE1mqXMkJ3bokvZy/whvKbApAO3KM46HU/jFJjxJ/W2I0ijewlfwiw5JbiZpxmZ8mXJHxCioCw1cyG3eWi49EwX4d0GOvg61yuNmucn4oF+y
 KIlaR9cw
 w8OEys7TljNp4weKT4QlkZZTsG+Us3U4WwaHN/Ss8ArAliKRam4e7spBVVSJM8RThqSyKRweRpxbZenMCR7Ul8s2fzlRz0KdUipLWNppFwYprRL3FNTXFKza3Xw9b1XHVraS/vTLFGu4vWxASnjcdZ38XezVAx9HzG9T9Ao9YQ1Vrzr4tgyDzg9uGklUG7T6rgi8CDhkzaqJM/SgIZ1c7VsfyIlAlBTWT6I0BKd3wu2XhFMw2CsWn9pzxqYB2Q70iVqH+q85MMbydulqzDWEmreoXo29JtMhiqMlrlDKrsI3iDKW2H8cGgvPZ3Rlal2r86WYN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

register_page_bootmem_info_node() essentially only calls
register_page_bootmem_memmap(). However, on powerpc that function is a
nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
anymore, let's just drop it.

We can stop including bootmem_info.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/powerpc/mm/init_64.c | 8 --------
 mm/Kconfig                | 2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index b6f3ae03ca9e..64f0df5bb5cd 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -41,7 +41,6 @@
 #include <linux/libfdt.h>
 #include <linux/memremap.h>
 #include <linux/memory.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -388,13 +387,6 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
 
 #endif
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long size)
-{
-}
-#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
-
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_PPC_BOOK3S_64
diff --git a/mm/Kconfig b/mm/Kconfig
index e221fa1dc54d..97b079372325 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -537,7 +537,7 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
+	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG
 	select MIGRATION
 

-- 
2.43.0


