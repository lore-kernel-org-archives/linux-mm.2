Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5360606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pI4QIHgJ
Received: by kanga.kvack.org (Postfix)
	id 09EF06B05C4; Tue, 10 Nov 2026 06:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077946B05C5; Tue, 10 Nov 2026 06:25:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6116B05C6; Tue, 10 Nov 2026 06:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF0926B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3F30C0294
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:39 +0000 (UTC)
X-FDA: 85418979198.02.604F385
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id EAB188000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI4QIHgJ;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309938;
	b=LW/SUUwR4puzI1G+KVydIosuPoPZtl7JR9lMVSMlUCAs2DVzrbm+1HOy9rCS/TmXnOXdu2
	k/LMwHm3m6b1dKSMVuwfBInWVABodlcGyh9a5Hqf6BxCf4ivcDuUP+akrakoVaP3XabRZf
	oi9Tl2/5thZ9YFkzKzfbt1lHyozvxIE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI4QIHgJ;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8GPmNrrbDyVAn3i8pP3Irq5ZXZX7zbqtdgKc3xpyyA=;
	b=v5KG6OOjsei0YxXLsEYnfRFZMc7keMTCRdxBWFR5K/yuv8IHjPTIaWvpWJgYxKX3l4QhB8
	gHmv17Cw/6fTEHOVrIV0d0bbBT1RUhbcz/U7YwXU6VMhhLXNyxEbhuJNWEx/DlPov5ULNV
	bFEZwGhsiAFwZSMOZroSjpbWgx6ykGs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kV3VwCyfCvJMLMAaZdOv60N3vXq9IpfkDxA+THuP2XI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309936; v=1; x=1794914736;
 b=pI4QIHgJGwxnjJP3o0HQmw5pAgkfNU8FiwiH3qW2hhwxMpTIORcGwj50izRaZmz+qLyKG3+T
 X4uV2cABlcSdXNxyD0V3s9wXSjBqKcoSujF18Flja2dDuNZX6ocyPdXsE5WyMF6PpB8hAg8QJXu
 sXN3TcUQV1PTPqJmTwRNN1/g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1ad4c6caf1eb501e;
	Tue, 10 Nov 2026 11:25:31 +0000
X-Mizu-Trace-ID: 1ad4c6caf1eb501e
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
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
Subject: [PATCH v4 8/9] powerpc: drop redundant unmaps of failed vmap mappings
Date: Tue, 10 Nov 2026 19:25:45 +0800
Message-Id: <20261110112546.261415-9-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a3zo1ro8a5c1aswm8cnp649w15bwrdum
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAB188000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309937-365452
X-HE-Meta: U2FsdGVkX1/dRQ3LPOxsbAWQEaNzaf4eWC2AtCrqhGqBNnMlpeCsD9gfaV2+Nu8pHWKfGB3Wh9jSwIJebmwpb4h9a/r47NlOhpC88QscdtDuhYkV3rseU6WHCfJm/gcW1I341siKosxqEK1Rjr6/cQUP/t82ZDdyYvliEB6mLeIkncortuSRcNdkQtfxh3Ya8aSUYzKxZTMBCWU4mlVng84BpX0JrI/n7O8/lLrZfnsxWwubaMFllEr9amczxkInQ1vXASlEE/MmPjUJ0DB4W3GLqQ6hqG6jkBKREFe+26KFcrvONdutV4nZUURySLFOTMX8lzuwdXkUB/QeUONi2QM73CXHYD10Ww6p7cYcieEcD7qbtGhHGFf56B2Tfu0xinMwMmwzc+4UZTp38ZHFLY8QELIINBu4jmUNPPA2hcTZUG6t2Ywpn7h2xuUtg1B1nYKBzatr7P8GPvume13tFxipreSp3LDR/qmzNilMR9FwIzmmQA8nF8WGgcucyABwfPGSsVN6sDirhpslFr9HIj+Xh1CM50t4JvQi2eVDX9ZV6vk+zI6tyhyhlSXQQX56gmcKAPgDQJPQljNQISfcoSMhtpJvKteD8EVfomBdvVgyYRSRK/LG1MdnuGEh0jidbsEVPH/4De3mrNBFJLJoZKSK0X1fwc/IUpmbr3BWXqmOTHfEb2XH6vg6UiNtw7h+cOVEZdzg5T2u2W31xW7CAxVnMBsfmzUFJXub9fJa3rp5eIBChxSiMGMpObig4T6zddtXNAxK1Ld0evkl57pFjOEUcI9YTvBWtKIUp5/tkkLgTARHUob8kS3etMJ/7XGcz3+cNri+8velCFeqvvdNOVXAvlTJZpkjNbesCq8IDKhWYynlI8F7Rehvnq6H+k6wY+ohQMWT2xjkC4eQHa3ZzNY3nQIA7Z/aUVxwN+TvPjPy3jOKvMyHOgecexyDJx4nfoF2ayta/9k8ElI6c0p
 vyCkzsJv
 lKjAmxZOrSzLpPvUXHB1lCG4SKsw3bkOjEebhc3czweYHEH8fgVYKsKyPPMJcOSU5FwmvlDaZZuS8mIC4LvCCefhBioBF7J7y+Gg+BIkF+gEMJXrGOMM9+UgEXWUClQr044SPBpURC/8k1UUpOxvIpUN5Vu9ncn4uZRDYyxft0ZmDz2/gD1PkipD++BezJTeZBuDfgEwH/lUU6DqHIU7UDrtzJU2mOFx+3Ky6mITDf9sfBhnO67wn1uF1cdDYb7GJZp0Rpe53P7C5JfFl3U4875ZB3RdrqoepE6iiDfOrpErOvJJy7cVfTgqMjLCu6L0yWNmB+7N7chZMRgxCKKISSboATiLaEk9Tnavd
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


