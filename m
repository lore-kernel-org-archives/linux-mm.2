Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA20CD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5BA6B00C1; Mon, 11 May 2026 10:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C3A6B00C5; Mon, 11 May 2026 10:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B076B00C6; Mon, 11 May 2026 10:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A91356B00C1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:05:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56F7D1A0156
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:46 +0000 (UTC)
X-FDA: 84755312292.02.982363E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B180D1C0015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZVqW/8uB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRHNmf93uQX2kBlaHb/fY571d6FVsWsidkKskPPh+yI=;
	b=oMXIFAbQb+qUAVHjZr1YP/GlG5tazSVOyTbYCOU4TlilCNgKuI/y5AGNZyWqJkoARcf7WU
	h7XCUtnkszTOfMFZBDgbAfAv6dP3iOwT1o2c5+8WnS1kv3KcI81hRvQ6agCAah2U4vZD/Q
	pz6qQeVXHEqT2Am2vtU2wBaprqZstFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508344; a=rsa-sha256;
	cv=none;
	b=TdEwW6t1vlXzNFX0eKdt//1F5uU2WKmCE+0hFRRJWwBaef7w3hPohdMzxah9lovYSks8B1
	lnCQm39okE2paEmNHauV+TzMqr+2L5YqfHP2wnk969vXNQFZ258reZHFsZJwbA5W+Xees/
	KojCF6N5PJPx/1cGSw3vRpN1JD3euww=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZVqW/8uB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 147BC600CB;
	Mon, 11 May 2026 14:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD66C2BCB0;
	Mon, 11 May 2026 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508343;
	bh=zGEwXeQeeaa/yetEDRVp5+lm1X5UYQ4s449U39c7KOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZVqW/8uBvCQNuH1FvNzPpfFfOV3fXvq9+aGIjhZjuuGqpF1t7+7+jnJnz2fGIA+/D
	 yxYGeANt8K3XRNU9rBN3mNKFQ+2z65C4F0WaEymY9eIT42HUwFGIU35Eb4InQAFnZw
	 9tKd3WH7g8BdkcFMxeaxQoBX4UoNqEc/YvxkV3cx1VktE0HUZwsiTxNo4b95L8Va7o
	 QEBPTERhjBauEwb1ned73L8nMQCwv2VkyNbRrjtncsuhg7G7zOIjCHkibLXIpKONG4
	 1JdBvkGT+0r4+PiZFrgPk/5vVPlDICWGR2QQJJ3jB2zi39CRKDKza7z1iF9RCoh54s
	 M1DoU+naPhh3Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:29 +0200
Subject: [PATCH 1/8] sparc/mm: remove register_page_bootmem_info()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: B180D1C0015
X-Rspamd-Server: rspam04
X-Stat-Signature: b9sg7113q4pqoh6rk98etjzfu6ezswab
X-HE-Tag: 1778508344-920554
X-HE-Meta: U2FsdGVkX19vO7uawDcMM0YAuGPaVdvxGEh9b15ZjAc3RKWCISeHFz602JJGJL689LTo6Yxxh56nvVSAK8SPl6tV00rywAFZeB01t+JXbyJmzEYzphGINj5JNKPVheY1s3fJRktEVlK2kBXXAWyb7i5xyePP3ixjIfrIaS8R7yTM5Icf8xQeh/55n9WJSrF8eHXZFvsotV5sHYeQ1yDtnlZNgHNqpwGh5gAwGmVY6nw7zaz1Gvzg3FggQex27+87TdquFTM1ag5jE2GjJI5F2k4fL5IMvgQEihG9JEERJUJIkUTLd/tbFFQjQGEL47WkLiGltlO6iGUnj0XP8xmhdhXSl1DeBu4QNn0DrVpN2Lb0vPV8RumWTb5nnmDh09zxYkXcnO5pFTzwoRP9iVamtjbyj0jvM+agUKZOKnLhLXF6LAoCY/AhyzrhEs3TQEU44Cw3+1ZzovN8Bk4WW5Z+w5656+KjK5PZQ9H8c+CMv6hupv51kfvOaG7K26QGEwQBuqkuC7hCraacg41hiD0VGzcvpkdhLE6FNN+vYBdX+hdyzbCnXkOxUAifset+Vm1fFkvH9oIJBfGkjnKQdTPsxC+hBXBb1lCJ/tewa1tvDfIYxARL6WIexa+cpk4vvaMfWzlQKSmXf9keg5KZv7ngCzAnc2sN2QzEopL+FoLEhrx3Z1OB9bVoUCmZiYoShy/R403th8buai8I5EsPhHn2WgE6tAxhycNfwqSgcVRZkF8PmXX1yfkOMOuEHQymeSzIPaTBR+RZtYY3Pmdtohlfgs4KF7OuY75yuyi7Wcyr971lBueCpww+67+bIkzBIvfnR1gc/kieWZHSFTHesYoBxJAQKzkQW9gFWHAzDUSKz0dq31cHu7ceqzmaf+aAsd1E+G8soFY6K9KKq4p2O+Orwm/BX88+gCmMilgYUNZCsUxdtP6dyeOvHqDqADVtqzOZFR3ZcgdvR5uIbKeOzvv
 eA9CTWFN
 hP/+Zrpe59YUrK0yYVkewyL6zCrn+ksI5ibUyWukWUCMh55iyoGo9JuF9913z255xpno3T3stTsegklZOGwCw5G2pFeoacFv4UiZEV6XMeaQKlPx3h4+pVxeKczOKIdP/PVixx9KW4CYEQ31cPjj7ywmd7Pv1BC3+uxPmIOFXZjpg2wOUSDAC+pjQ+Mk1v1I0Ar3qUOUgJcNEAWKH3o32t8EOR9IZF0YUFyT61cCWy5/PDiP3r5VJQXMDFkuCsQEKDt0hkW6DDY4+GoBL7INjs7WYvYATa83hEBuMb8C1fSStTAeLbAnMqchfc1832zGlHeRAAdYh3GZLcWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparc does not select CONFIG_HAVE_BOOTMEM_INFO_NODE, therefore,
register_page_bootmem_info_node() is a nop.

Let's just get rid of register_page_bootmem_info().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/sparc/mm/init_64.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 367c269305e5..3b679b1d1d72 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -27,7 +27,6 @@
 #include <linux/percpu.h>
 #include <linux/mmzone.h>
 #include <linux/gfp.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/head.h>
 #include <asm/page.h>
@@ -2477,17 +2476,6 @@ int page_in_phys_avail(unsigned long paddr)
 	return 0;
 }
 
-static void __init register_page_bootmem_info(void)
-{
-#ifdef CONFIG_NUMA
-	int i;
-
-	for_each_online_node(i)
-		if (NODE_DATA(i)->node_spanned_pages)
-			register_page_bootmem_info_node(NODE_DATA(i));
-#endif
-}
-
 void __init arch_setup_zero_pages(void)
 {
 	phys_addr_t zero_page_pa = kern_base +
@@ -2498,14 +2486,6 @@ void __init arch_setup_zero_pages(void)
 
 void __init mem_init(void)
 {
-	/*
-	 * Must be done after boot memory is put on freelist, because here we
-	 * might set fields in deferred struct pages that have not yet been
-	 * initialized, and memblock_free_all() initializes all the reserved
-	 * deferred pages for us.
-	 */
-	register_page_bootmem_info();
-
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
 }

-- 
2.43.0


