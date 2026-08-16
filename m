Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6EFC5DF76
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C3E6B080D; Sun, 16 Aug 2026 07:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CBE6B080F; Sun, 16 Aug 2026 07:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4996B0810; Sun, 16 Aug 2026 07:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE7356B080D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:00:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BD0DC04E7
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:09 +0000 (UTC)
X-FDA: 85106838138.23.D6E7904
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA368C0005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhcayokE;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786878007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy2s2udgAuUOuqiiG581Z7vL2dnOoGEiogGjehxnVAI=;
	b=IwxH+lG26e6KfdmPcKqVQD4wt6gQ/8mUHxoBMcTw+IPLImaENLtHiONe6uW7huvUnktYqh
	HYKKVs2fBhSUy67p+7GHDS9M9ADgE5RH5gpnrIQ3Fy0jFp8q69i+LyYoU2Jhi6F8Mi4jrr
	G0YOPNa47wQMwOUsJIC4X23N3oIbpq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786878007;
	b=OAcqi+vDLhyJFCVyh4Tvmf+7rRrX5UnUW7Ezk0+iQWFQ6GQmSGjPduOLUSLBB57rjnOZ4z
	mCK6bdCe1AXx5180sfWxYjZIJaDI/3agSUeNhfXmclYeboRByZF8Tw1/Alzt4LwgL4fIEI
	uBr1jRBQKjYUiCdz5fdBZyVNAFpgVwg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhcayokE;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99CE3600E2;
	Sun, 16 Aug 2026 11:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DB71F00A3A;
	Sun, 16 Aug 2026 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786878007;
	bh=gy2s2udgAuUOuqiiG581Z7vL2dnOoGEiogGjehxnVAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lhcayokEj43ho0cwYwXSsPkKuYBPIh9x6hGmG7ih3uLsYURAu3S/D5HPbKqADyg3G
	 Pn/qo1s8e+YdNqNPYFYKLnk3uW+Qxcn4pjWu+rILw26T1RvSQ9uzDkgh8ZGk5iaXjp
	 23V5pkiCv2OtGtQldL3UnMXwFTy1HAwZq3MNoDc0AVt84RmjXctY3LEIz5jZ/Nyfz7
	 CisMqAS9gASEjwdc+fUzDeXAsec3VmceqO25xO+htrehQM6I7hJXZYjTU5GAos6kla
	 Bpmwk7AT9oICEYNjyjibk/sz26kXrKCZIv0ddB9GkmW6oMBTDXpZ32LXrEpJqOT6bW
	 vt3YeZwG5M/tg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 16 Aug 2026 13:59:26 +0300
Subject: [PATCH 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260816-execmem-set-vm-perms-v0-2-v1-3-90944a3ad43f@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
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
X-Rspam-User: 
X-Stat-Signature: mr3reznmow8mz5fph6hfyytz4wgse3ag
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA368C0005
X-HE-Tag: 1786878007-769346
X-HE-Meta: U2FsdGVkX18mulu3kkBfkDCfYTQ2tGOqcCFZrk3Z4m6rQB/AhH9yWgGGMssPupstAXVAJPtN0pxXM4yHGdIryfn29fQp0tOeg4kDXK7b8+jajd5xaP+xl9r+o5Zxl/Z6aAyBEVug25wP4n8KFMT2ahjnC/dwPvk55hG3MSRna7I/51CPSJRygC1IuFlO1a8OgVlHkOe3OQtjBN7Jt5CRABda/VQtaoqakb9KVs997zLYzMD528reECs1nwA3SmNWWdd5orkNq3ninO8hhv6zhcD0Ua02HY6+Tjoy3lMK6Vzmnuh8DN/K241LIWXGJZDzyuiGgQdEjiuhdcRoiCMq8XaA6xsCkwOTIb1KfQLXL6oWNa29mzcOd9gM9jdTKL9SwhXek5JSbW+QF9AnTf7s33Nc35cpQRAa2yfQatp1AuvBQH5g4SmabsaflQQZRmC4yWbJU2k16jMluqYSSn3/dvIcHX3Epd9DK8LChlwx1PhzBaeCO9E8gGJZMRYhXFolGlUJxdA/tKb3i1R7bkbSWN6hdkQ0Ce33ngya9QEXv1oq/V5dse86elCqHA+R1+nvW3CpWv/v2dNlusvl32QpGE3F1wmaD1GnzsSbsidMcihcxEZl3DINZc0NqP7pMHIYeRdK+TCPWPjdLIpxWq5nMgYQKZuPfCyvMHTKPL2PUIAQxlcBs99zmn93o2s3bryI9AGG1jr8w1D5lddWE4RS4N8QaTr0pzAtJlW+CstU+h3xpGChZpcMSG/hE0M6Y3EdE1T/aMoIKKquDttiE0qm20pjNvgp1X2Wi9yOcrLAvx/nmpcPg/5trN3lhBsiahdb4NUsaZFMbE9Pp9FxlyG42uUkzYb6CNZldgCzlIAVbqO/+OF4uSwCIUIu7sADkiMst+OdRfs4CW0jwyuYhNDyBfmLFtk+djPdP0IBkO3GK3iXcFXNP/uH54Jk4z8R3oBgjlGcXWgNxXtyXM60vOZ
 EUGSOVbg
 KOYTuQH+X/9gaOL2GDxQTztbjwnHFh2gf1Q2k0JH4YGWl9ecqll7II+0TB+HH24FWH6R9Fk58XMrWiIo3PMbCkWHRcM9bXf+1E8zfy2xGIZ7PZXbFLbC2cXl1TmZQu83wOMr3aby/TgXDZICZYyZCMPCWnF1pQrv8Rrav12ZmDtXl2BrStNlSwH5s731bqR7T7qItbqmSdJXO5Kx0ptPR3K/3n3OjyvwmlogHH9dPCf3GWZaqbhPjfRg8oo08+xxYBTQxsgf/3gHKEWXTlLWTNsc/2aA3jzulMPKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/vmalloc.c | 4 ++--
 mm/vmalloc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6822f0fe9583..fc7993db4152 100644
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


