Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAF2CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985E16B00A1; Fri,  9 Oct 2026 02:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D336B00A2; Fri,  9 Oct 2026 02:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899D56B00A3; Fri,  9 Oct 2026 02:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6195B6B00A1
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:36:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3158C0266
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:17 +0000 (UTC)
X-FDA: 85302128394.21.9B7783D
Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	by imf17.hostedemail.com (Postfix) with ESMTP id 42D6140005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:36:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wUF7oPFp;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwbIZGd5qls122noWJbSBAeZAIWZFmcFvm7JGqAUwiY=;
	b=fqCVLFiqhxZtBQIDYrvNcQFSF3VduQJpj5QN/AMPxOPVwF0djGPl3D7p3PK6cOcFBHYviD
	AqjfiT2yXOiFBZ8BaM6dNh+a+0kaRpzWAXKvH+mCTrgTGsS2DJ2vRcIMEVHHVA60KKN14I
	xDgh+G5MuRp/QjlLeGHlUCKUIza0MF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527774;
	b=yN4WQ+/TMrHswmN/LT1dCcwczyz7Q0hzGLpUqC4hUa7iZnA13AmKt1Fd9Nyk2ZBnw00Wws
	9r+/kDNVOCztbHA4NE1PEcf0mdhBH6YDNM3k7PSNH1lcrXB7hlcEBbqJfi1ffrwud6J//X
	1g/qSbH5Rck3HLab6pLoMw+/cxSbRaw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wUF7oPFp;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.150 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uktr6zhQvbp9EzuGh+m96ZQeOR2JVBFEMc1HzncifB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791527772; v=1; x=1792132572;
 b=wUF7oPFpMxyb4WpP6gRGR2ODKxA4RCeg9jwOTOi6WMPnkH9gp2nR2OHzxf9yxdUUVabYWj8T
 PChLgYuIGSQchfZkTY2JDVX9K9fuaNFisFm791z5P7daE186kchH8FQWO/v5ojfRpcdcXl4knpn
 YqmqF3/ASrow1ab8I4TUVW9A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 540e04d12dbe99da;
	Fri, 09 Oct 2026 06:36:12 +0000
X-Mizu-Trace-ID: 540e04d12dbe99da
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] powerpc: drop redundant unmaps of failed vmap mappings
Date: Fri,  9 Oct 2026 14:36:18 +0800
Message-Id: <20261009063619.112313-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261009063619.112313-1-hao.ge@linux.dev>
References: <20261009063619.112313-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42D6140005
X-Stat-Signature: u5zw9pfyz3skmsa9oc3kw76ykqs9uzsi
X-HE-Tag: 1791527774-304979
X-HE-Meta: U2FsdGVkX1+rJk61VTkmzMX+HuHNuCIVyAcjABSQj3os/3tA1nKjeC1Kl+ry03F2UE+sovpEuqaODScqg/VvIKJLZ3IDXLDptkRuSw04MFqeEBNUqowg06EqyPxu0hbZwEsR4x8q3m4m5FjI2LlpA3DaRiBIWk5iFkgxRf31cXf5MAz3Y43lXE6Mc4WKQfS6IQIle8jf5rKViGjXXNQt9PgVgHlJxIh5aXEwM72JrfwYcYtdOAgMthY2frw0AkxtYw3A7UD6L5AaY6LBdxtpgvXPNuWnjeGKxnYYMQMDDI4Bbvhy18SbJN+RqCMgaERWLGuI/5Zg44h4ah82fFmsIVXuYu4mzQhC7KA204nKB9EDXKYv1h5EUBm8zSmV6zwLXaZeTyor2rIkWwWOrIQ3RmCtW/4g12E4/UpBBo4MgJ6AHCige2wITdy/DeErkMCc326Smv3q/ejlVN3xeRJn8mczSuM+F2MO1sFNuYBAs7xAV60r2u6M2ds67J93QpwMGq/G331NfEXey3ewX5waGJ02+q0foxAZ25Bu3agBJbI//VgNxcwlKXCzGVg1gJZuYYJqhu4f9uspQHS+jhGXxmDqxobQOPPzT0llnyAdRo0ufbEMF2AZL6E3M3hDAxX4GcT81qNphUbwTDpnxtU0u+6Lz/daNvbhflecdB7UpPzisXGBKei5SAG7x7xC4icHnQiQYXGP5gTdg8kjFudUFe2I0tQzTcACyXZ3UEhfZBlAufsZo97QYNGKuvX5/1KplmnhHd3DJJ1xgWrldUV5DFaONMa3MhoBwXm4aQLrAL88s3LMlf7wWV7CaPTvNcmTD/lS7+j+gEBjXNv6Rds2AP+nGL8lxNA1b4LTZ0KX5Y98eq8pM7bacZn8AcFR+Ozx0B8677UjhyKu2G2gLWCP0NYj5PZYuhAhCTlh90FCXK85awcBaO9LXtA2tGxaLhBfz4VFqASbrEeqvXt3IXo
 FlKpy+Sv
 bjNvzcMdI8kHjq6F3UZKExQrjTywCE8F7h1m/4j7iBCPG4a3Sl/XsGCGAs1ezQnGNnNghnva1XOLra/f61aYHhvC/IzfteeDDavc+BH4V0OyER5n192fbMyz+TFCC1NPs2dRqMTr39wayFlDmt51aW3gUVOFRPDA1IEAv6wxvPyZof/U5SCeqoiBo2zVyqzX+QAobvaq09/TZsMHzc9e/xLsz6C2nW83/almN+uJr5Vul+PaPYvnnU4IKawUpGJD3BWlbioyn3fUNvadmk/dLmw8QpuIEPyGm5ORxeQE9mW66J3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap_page_range() and ioremap_page_range() clear the PTEs they
installed when they fail, so the vunmap_range() in remap_isa_base()
and ioremap_phb() has nothing left to remove.

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


