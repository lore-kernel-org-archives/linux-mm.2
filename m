Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F4CAC5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181436B00A1; Sun, 23 Aug 2026 07:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1343C6B00A2; Sun, 23 Aug 2026 07:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022DE6B00A3; Sun, 23 Aug 2026 07:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D525B6B00A1
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:46:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59152402EE
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:57 +0000 (UTC)
X-FDA: 85132357674.07.C099741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB7D120003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSIuPgnv;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQaLLlpkKxkLjqvn1plws6iiMsPgyQSLJFR/D8i9QGU=;
	b=g5N+ZsgAhg1SIcpp2kRhwHAmJvDbjvsNUoLBBA3iG7mTrVenfa7Zstsc6eoK4526bQkQ4A
	Shsgo3MJSYfVplXqBgb7V3RjNPBWaBzLCDFS+g3+I2Qw/fZbewk3viIZMqJGnAH25Rusq5
	zbGcGS0pY93Jy0kz3gv/S0WhLjZ9MYg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSIuPgnv;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485615;
	b=c4GincTzrtKOVhkC2c3xqblhicONchu+63PammM9BX1I4VenA4iO2Lz5bz0EJkZjIUDmMj
	JcbLITLu8k5EuuUP6xzRNpDrIquS8KQhP1/chgzbQI8EcUCw2AjVI31BEmqnJckS0DDeUl
	YD4BFMBD637js1dcXvYIVR69Gl29fFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53D1760052;
	Sun, 23 Aug 2026 11:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A024F1F00A3A;
	Sun, 23 Aug 2026 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485615;
	bh=YQaLLlpkKxkLjqvn1plws6iiMsPgyQSLJFR/D8i9QGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GSIuPgnvgzZ4CFYoUAhrhANp3tu/pbO210YpfuQqjqQ/tBAryQK1c2a0SOosec/eA
	 yWDoIEDNqNG+cvENXJU7C9WjN8EQuViGIhZdcEPKwUMERxTu+HAWX2a9waaB9H4/gW
	 7bHXcGDM4P8IOZ5WxvuPci3wjljTVN5k1JtDbJ+dasGW9geZ20pv+wzaQCccEm3cdH
	 prEcGCQ01vF7YLanTsmCAl6yxR3TU0uFvhqMK/QEbdV0Clr7S0eLTT7ed5ALhsfcXz
	 A4ALG9Zpo5vv3ruvhaY1JOhPwDhHjH4NaIaxsk+ine8OMUU2x1ov3volVFb6jbj73q
	 hUa0ANwFrdJpA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:14 +0300
Subject: [PATCH v2 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-3-b013a37d84b3@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
In-Reply-To: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB7D120003
X-Stat-Signature: mw4dnms7a6eywo3xe8axc9rix8erxtdk
X-Rspam-User: 
X-HE-Tag: 1787485615-280891
X-HE-Meta: U2FsdGVkX1+zLuHn2sLkBmG9ekeOtg9BOC2I46s1bRQfge7DeFCbScjNQt4GGZbO544ZtmrUXE7nrBwtiSnUnJ0PIa/PpQ0GLoo8/0fDZhZn0884Jfg/ceO5LoDPMOXwTAwiR30mgsnDR02wwWD4miwga1Gd67Dhqo3Bygf/pBAxmR+BHYxAFlh5w6e47aUvq7p0RHGnDl4d0q6sgZNafq5ilclTaDY9/g/G4qRsFpB82Zd1HIKEWjedbF36IqCkYrxco9HvmlOcKq9kYIgzWCHUTrLXk2PFsz7xCzhNRU3JZnT4xjpD6YaNO6m2IKrL3QFp+oPBmLGa+73eaytFo9i3JPdQsiyATzhLEeI6aJaA0oUyqaCRr261GD696uV+P2Ag0A3OenJCBjAPAIrfFxLrkJCfkJNB83Wp8y0J52FMjKSMZQ3AyuVQvEDL7IMmgjAvld2uj+s4BMbIWe30GAlhXP0Uh/0Db9P2gJVQ8hI3H2TbkkE6eFeSeyKFQluo6onTo6etWT7AzZBWa7IOHZyEh5fhNTyuxYSFalTfMe/QQJWV0j9pvUC249pNy2iaBWSFjHEGJs7a0r+axZyJdG837lVD2NXHCDl8I6KnZpt2J1MuYtzd+OWlPaE1qHr0GfwHnS/lIPmKbCnrzZk6HoCihH2nKnTdVTtycPedgAVyhLrts08kg9d+filgG0uJjnTaQmmDOZxJi3Q587e75Ra2/FsnmBDX2CimOn1fBI6rFg7TMeVThkhTWCtqzs5tzWIUiCmO0tJGOhEB8ZkToYakX1qJ4SPdr7BxliKpaKPrh/MxIxh+nB/9gbg+luSJws4dWki9Y9mwI76HuG0bhzoQHiqtlyUPfmRoAjgBohHYqypoK7sDZ76hRIcbnkKQ0iwzC6YTnknDJmN9dbE4bXD3RtE5B2O5zbeuju6XXFq7RKiAcoczkdzBP9vCpAZxNdn8gqghRYLRaQ3S2V4
 mYPr924v
 QNx3zmeUXnG8ShpebsRE96rBKAUepzdGHsQqfuGZdBMYo22tCucHm6hyzpBmMJuSLd5sf0ZnpP2a1sAalSDVPV7Lf9ieIrxuZI/YgRVMjEHKixptoTTsTXqpudEnn8fUCIrs8CsR6LMiGthw9ngz9VWJtJ1tKWaB19hbbneY0rFnSTAKealtCKDK+HBiI0JFq9P8iVwu4ATb3GFl1s9Q3o05+nCOX6GFETIo1QGiuXGAcVYiwRobLDd9zDRL16kp09xp0Nkm1UqPv1OYs/LZyL4v64bC7OPC25vWTCLK9mYy2gxj79mFfrEGxUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 4 ++--
 mm/vmalloc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9bd94e2f2895..a3e2e4244c0f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3124,7 +3124,7 @@ EXPORT_SYMBOL(vm_map_ram);
 
 static struct vm_struct *vmlist __initdata;
 
-static inline unsigned int vm_area_page_order(struct vm_struct *vm)
+static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
 {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	return vm->page_order;
@@ -3133,7 +3133,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
 #endif
 }
 
-unsigned int get_vm_area_page_order(struct vm_struct *vm)
+unsigned int get_vm_area_page_order(const struct vm_struct *vm)
 {
 	return vm_area_page_order(vm);
 }
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index 8866ddcff668..211869f36509 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -12,7 +12,7 @@ void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages,
 		unsigned int page_shift, gfp_t gfp_mask);
-unsigned int get_vm_area_page_order(struct vm_struct *vm);
+unsigned int get_vm_area_page_order(const struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void) {}
 

-- 
2.53.0


