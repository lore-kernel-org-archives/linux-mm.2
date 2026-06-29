Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E39C43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6166B00E3; Mon, 29 Jun 2026 09:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D8E6B00E7; Mon, 29 Jun 2026 09:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A38E6B00E9; Mon, 29 Jun 2026 09:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD056B00E3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:50:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA0EB1C44EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:13 +0000 (UTC)
X-FDA: 84933084306.15.EE7AE62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47909A0007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WV42/Xmb";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741012;
	b=anSSgmPV8jdTeWPuqowlhvX6dTBdWi93ZaotCMwCCtzVidjy6SFWhmOguwZ/VYdK+fI1W9
	x2oEaYn25sirNrM0y95eecHRxQKoQZ0z201A96xc599cBP+TSJUmvT9ypV2ZGjb8RSqpfl
	qdndTPkgBWCCJL6+bGJp8SKA18JgjcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZaedSRrpHFjNO1R6B1tpmcbF1xO81AFjh3EFzP2Lb4=;
	b=5yJq9aMjx0Wp/VN9xC6ZTF2iGxE71JGB5ciUJ3RrqJ4O1KVhvtdShBS9pi0NirZmDhq6uq
	kpT10n4jr9RZnnktLdTu2iCqt9OROE13XRoH1LP+ob7f80wS0hco+jY1pW0cO4AHJKHox9
	zWIzjE9WM1wDvEmkpB+xsUxgnNHp5i4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WV42/Xmb";
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEFC9600B0;
	Mon, 29 Jun 2026 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308341F00A3A;
	Mon, 29 Jun 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741011;
	bh=4ZaedSRrpHFjNO1R6B1tpmcbF1xO81AFjh3EFzP2Lb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WV42/Xmb2BlEiMmiPWNnXK8Fgacum43ZD0Hm5gcBIC5Kg+fPFyV2rY+Etw6L9vNaG
	 hbsDujI6YqNVhiZ05IjDH9QNBbfIYBSys+H1Jc6/6JixPc1pcScqLC9/Lz/f3OFhba
	 ToJMpgcfq7IMopXmQSa7WR95qtjXK1d982owIbX+E4uItMKNXU/f1U+3p1RWGA0tp+
	 IWpzHnJHp0a7MmduZ2zwWOqzgTofNPExqgVIrmHWcMPm1zZ17OoBQRTqNsG53BiBE5
	 UHFk5UFAsib6y4fLK2h3k7rOr8pQMRwr4h9zhmliBWVWkSROnF7nfp5KiFeuFYBaC4
	 ee/T+lUIrl7uQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 29 Jun 2026 15:49:47 +0200
Subject: [PATCH v2 1/3] sparc/mm: drop custom pte_clear_not_present_full()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-clear_not_present_full_ptes-v2-1-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: ukz855aeewq49ixpebeiqk3iz9z8yu9p
X-Rspam-User: 
X-Rspamd-Queue-Id: 47909A0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782741012-189783
X-HE-Meta: U2FsdGVkX1/uQzQvh1ukRzywu1Bo565A+YgCAbl7y1g076KSf4c6zj+f5iH50t3GNs8N9QIoo4j9eRTm1TaaOghLCXIx30S7jAsRepigVFzshIHgIOU2HDgYZC2ikX6arq0jq+4ACZcNBi5bc6fmbtcz7NYKrZgxZLUHk0tCg/ICOf0PXXB/azp66z9nfvsIsE23FV65JEZ0eCzopId0rBcgJgVvQYYmsKvDOmP2shkjUlyS4yuMzr/LA+tWiSyE5949l5RPKQ01998wcLXfm11+ovWgsNXc5+qM05vIQh68rI0x7+ssbFx9IVZ7sroKSTL70MQiv9JGHlYMguqZbJbUDLC8ybW8SyXti1NMg8PznFTDrIX7/uaDnubKyKFJYyNK7bd0snaOC1Xpmxm7SqYLZtOPlQshbjyXpUkSzgf3s6A5q+FWTARvstZKFt/hp38PMayq+so4B9i96/uKucGzjYgSXICBDIY+9PlWEG4oSz7rLOTlUGV3hD5Pms1zTDDXPdV4UvhaJgi1M3jjABiE8HtUMfgX727oBxNEXkUdTNp6Ttd32HLr7K+2+ybGuS9j9Bxam1AFGy5tlZvxsGqDCt9FmqBPdHGDnKc1oEg13v4+y2pYLCwI+WxPBy5fsXjp0e0YC38olMR+Y6ymclp6qevs9KTU7BMirqFiKl+H5geMid1TSX03mSbXjbUjG8HaYn5PSLHPlkTV+1qbB/xHfJNpANicAaqn7YqONpdj+3QK2N8aO3VIDThH1BoznvndpezcIyMHb7cIByfbftzmRrWdAetP2eLoepiLUTch7pITstW9MvXgsxGFWniNOKxgZxBIG8ePq3LlqXfDXAJCh17lo1sXvhUnlxllSk+3sKcl1QMgTUp+kUfISGG0VjmVULUlMa433fbhXlivHKoKsiCUFNuL/E4X0IfYBBlq/WDjUplkf6yasDCCYBNEktA3yl8kKRsCmkSk4dx
 6pGvCQfd
 1VLRf1U0JG7JXlMs4gNkODM+Rnq04EBUF2CkvzJ9Gcy0SI+1shZZ4PMXqpmpXLArudZG2898siShj42TVzgQYnQqS6kWBdPdgsh4lIBg7bZmvy6iMthz7CXtL/ju9nmqy6JxPXuUxXD9EHZw8YQmHDSgLaW+SNTcXT6y9QeTUtWQw+BtL2oQF60tpjw7gfjJhCYu72Oa3mOZGdIbIVLyjc6OJqmvP/tp8pDji5pp9b45hHJGLHZUYoy/L/T7bi0vc55ZOMwpZ6p1IlriKlZrpyLXYqQKZJmU+hUtldoIfUNUcVrK2zRig8o+5dfsWrquOQXEs5F52s6zHyHryUvQzJKh3biaLb7sPo/9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On sparc64, pte_clear_not_present_full() nowadays does a simple
__set_pte_at(). In __set_pte_at() -> maybe_tlb_batch_add(), we check
pte_accessible() to see whether to call tlb_batch_add().

However, non-present PTEs are surely not accessible, so tlb_batch_add()
is never called and the "full" parameter is irrelevant.

Let's drop the helper and just let common code do a pte_clear().

pte_clear() on sparc64 maps to set_pte_at()->set_ptes()->__set_pte_at()
... so it ends up calling the same function, just with "full=0".

Given that "full" is irrelevant, there is no change.

We added pte_clear_not_present_full() for sparc64 in commit 90f08e399d05
("sparc: mmu_gather rework"), and I suspect that it was already not
required back then.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/sparc/include/asm/pgtable_64.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb325..0837ebbc5dce6 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -945,10 +945,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#define __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-#define pte_clear_not_present_full(mm,addr,ptep,fullmm)	\
-	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))
-
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)				\

-- 
2.43.0


