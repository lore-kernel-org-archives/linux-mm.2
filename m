Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4928606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DfDaiG1q
Received: by kanga.kvack.org (Postfix)
	id EBAFE6B05C1; Mon, 16 Nov 2026 02:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E925D6B05C2; Mon, 16 Nov 2026 02:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8CA6B05C3; Mon, 16 Nov 2026 02:14:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFE5F6B05C1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:14:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65C101A02C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:44 +0000 (UTC)
X-FDA: 85440119688.20.A5242D3
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	by imf07.hostedemail.com (Postfix) with ESMTP id 910A740006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:14:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfDaiG1q;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813282;
	b=5cMDpgnOTBHz3JLdl1MVAlIQWEDiYKoDb8OEiKOK9H0R5x3On8MAAU5Xg8MVH7gXZV27yP
	1noPc1LihPijXsG+8Iq7a8EMG6HtzPgZdn86/oRUbsxhD22elRP1nYYcvX7VMfitarLTl4
	ZjWaPUuHP8zqgcZfNKZaOAf75yU7yls=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfDaiG1q;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.64 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8GPmNrrbDyVAn3i8pP3Irq5ZXZX7zbqtdgKc3xpyyA=;
	b=K/JFzEFTquoFm79unU6bi86hXqEzFOkjQwFvlsbrjfCxI5a+2Ovj0ZwSJkZCnAjGnr8hXr
	Kj8jwdICqgycBJz/Ee6dXsiAF18OhN5NgPEOQSHYoE3VebEzQvepLco0RQh9NLK6V/Fmtq
	R72fYMr30nUEhYN7i13KEXXFKXQvY3A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kV3VwCyfCvJMLMAaZdOv60N3vXq9IpfkDxA+THuP2XI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813281; v=1; x=1795418081;
 b=DfDaiG1qMVulpMmALcrcCWJ5j9wSA2DSpO+s2Ir5iKBYn9xCRhKJbdGFXRPC4FL51hLHD6sf
 yBLGtGdEVEWLedCVu9bnWgjBRBv5v46B9V+aClPEIKFCB4xOUb1fPbklONeSBpQt8hCtX9qtIS2
 SUt02hZEPCPRSsF/7l2Tabi4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b12c8b10ff90e4bb;
	Mon, 16 Nov 2026 07:14:40 +0000
X-Mizu-Trace-ID: b12c8b10ff90e4bb
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 10/11] powerpc: drop redundant unmaps of failed vmap mappings
Date: Mon, 16 Nov 2026 15:13:24 +0800
Message-Id: <20261116071325.263682-11-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 910A740006
X-Stat-Signature: a6i173eo77ioxhi753uskxx3n1ekopgo
X-Rspam-User: 
X-HE-Tag: 1794813282-87482
X-HE-Meta: U2FsdGVkX1+JZFyVXJ59+L4GEu/+luWl9jLxedch132y0PABGLWpuXnoxGyDBQje+WqpIsIBnXsmrt4dT4kaVupKI/HNG2617DDSRR00DHWF5XeBGLpR/5epyr3cotraEVMZQR+4Nn04itqEggcoEQmBA3Q14RN1WbpmTqYqEuqVWdAkPkcmPNRk7934Vs+gN10nW7LzgcUUk7kDScCNnocYGQOCYwErb8hvok6zp0tlwm59ckVNPyJPxIBBuYNxHQVmdMpqKH8J4EAN8LIRQprggx9mFcehZyF2I1cvJbw/RXRZcBVKoNxAai6EGq3pVZ7DhmcCMpudp88qQSk5ESl2eVkS8p0JD7gjQbdSJ/ojQwbHbb7Iuux0ZRcXx3Cz2GJ2zxjnF7bJVeUuDmaN9N3189ApcmOUcw9ZGqH95Xlx+380qFSlf7h4Y6L+5LmawIp78UC4VMW9GioPFqBW1aTjkfiUmf7gsvAaHlBef8Wl+2gkN5V1DA2pLo3cqj2FSAABbWlaeLiSDiUeuuXtTk8NCxMtrGcklC3tumbe9hfIwURJvgPUQB5zo663oqjZua/QsuEBIFDOq2c5CNM53QBzMHNH9BAOCzHvDgeRu7ND6aYdAwrPrl9RFV2a/GIA83ldC5B3zVwjuWeuSVkyG1OZRyVnz0BUOgZ3OhGxsmITqQ1sGjaqXgN4IL834qZXYo1ogitjjAs3NVMThbhUMGBksWOPgISzEA1nwNyzFbiowu7MA8kVEuH1P9tb+ywzLGjv62blF1ea0hULhpCfRlXr8yt8/8h22OhxYJ9nz5WlDhuVAJXU4UtWhcxaQJBpCMmi07OS50DOPAOg7wdstCgm6fzSMdvW34Ah/hCAuNsIogN+ruK81JLeMNUMStdncwhqVTqXaBoEIFjCIKZifj1/51B/JHOXmkMpyJUlH497nFYblmYIr1Z3gKa7ewqq2qz8FVIddYUue3stZWp
 tkTVpVqX
 1Y0Tc+/sVRCP7WVYjmx1r3EjIPzVopVucBeSifo0LfGymhrIRvZcSZOhP/lhBx9Erz0Fl1OsNWYNVxp/gl3VakkUNxXgTWLuOsqLME1bW7GDJjL+1QW4CLsoSLRQhCdMT1sKTd5MldXLE/ZaNX5aOqxu8C4qZi/uDIX4YlU9oMb5B00NM8KtlgKcYKtA16v66oSaL9irqtTHb91nQ5grJeGqwoGhiihqVWayVr5qu2iJkLOMtgK4QOT5a8+xA8AqBUyvxlsLLyDjOFlfi6uDhOnoV7UINJzSSPiJzrWZVvtylBTUjMPSoYZxxeMJS06qK7GUdomcS2EXJByKtfa/6Y+Ed6gj6inb2X0q+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_page_range() and ioremap_page_range() clear the PTEs they
installed when they fail, so the vunmap_range() in remap_isa_base()
and ioremap_phb() has nothing left to remove.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 arch/powerpc/kernel/isa-bridge.c | 5 ++---
 arch/powerpc/kernel/pci_64.c     | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
index 5c064485197a..93029d85e6ea 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -46,9 +46,8 @@ static void remap_isa_base(phys_addr_t pa, unsigned long size)
 	WARN_ON_ONCE(size & ~PAGE_MASK);
 
 	if (slab_is_available()) {
-		if (vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
-				    pgprot_noncached(PAGE_KERNEL)))
-			vunmap_range(ISA_IO_BASE, ISA_IO_BASE + size);
+		vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
+				pgprot_noncached(PAGE_KERNEL));
 	} else {
 		early_ioremap_range(ISA_IO_BASE, pa, size,
 				pgprot_noncached(PAGE_KERNEL));
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index e27342ef128b..f74269636d5e 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -139,10 +139,8 @@ void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size)
 
 	addr = (unsigned long)area->addr;
 	if (ioremap_page_range(addr, addr + size, paddr,
-			pgprot_noncached(PAGE_KERNEL))) {
-		vunmap_range(addr, addr + size);
+			pgprot_noncached(PAGE_KERNEL)))
 		return NULL;
-	}
 
 	return (void __iomem *)addr;
 }
-- 
2.25.1


