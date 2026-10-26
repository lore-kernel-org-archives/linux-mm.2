Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D20606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qyKRnBCP
Received: by kanga.kvack.org (Postfix)
	id CBCD26B05BC; Mon, 26 Oct 2026 04:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94646B05BD; Mon, 26 Oct 2026 04:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA7E6B05BE; Mon, 26 Oct 2026 04:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97F756B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E652A8274
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:24 +0000 (UTC)
X-FDA: 85364037528.11.B9EB547
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8FF6DC0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qyKRnBCP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8GPmNrrbDyVAn3i8pP3Irq5ZXZX7zbqtdgKc3xpyyA=;
	b=GY3m17LiTj0J3fsl3s8VvaeJfoyddgh6QucyKytxZCFu4QhwX+DGPiFEZeOwcfXeddg/aH
	qmwyKgK2FiCAHsCzvphMgYM0L4ego8a278Lu7ahn5TpwEq4/dCiR724okAMlyKBY5ljhyu
	uEpcAcbjauZyI4Ybn9tcqFNitbu9e+k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qyKRnBCP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001802;
	b=6HTW9ijlbmPXFDOmHCp/i86C776FWOhPy/smrm6grJo5DgczH3t+m4aIO7hPwkoFbOcIXC
	pHfB0sC7tBw/mH/d/ZS+TmR0tLaRnWjpphtnAK/0wjmG27VtB7lzcjHPcyTOViMy5qWPlV
	RAHgQSNYyEf8dc5/cjz7wYWFLi8PnNo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kV3VwCyfCvJMLMAaZdOv60N3vXq9IpfkDxA+THuP2XI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001801; v=1; x=1793606601;
 b=qyKRnBCP1/DLY20sFPHkrBgt3kqGJqxE0y7pbr0EUIROplVrVVmK5rVEIEMqbcpGe41+DnHG
 T+LWts4J4Nqu3uAu2LIfKzgOaS5yG3alaLSiD5yDC38vAKELVMSkUwyJBV+/UMtpmEQFPlpTnZh
 KerYyvOR1Wyu7C1/y7YSPQMs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 16a4ca664e40d64c;
	Mon, 26 Oct 2026 08:03:21 +0000
X-Mizu-Trace-ID: 16a4ca664e40d64c
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
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
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v3 09/10] powerpc: drop redundant unmaps of failed vmap mappings
Date: Mon, 26 Oct 2026 16:03:28 +0800
Message-Id: <20261026080329.140244-10-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8FF6DC0002
X-Stat-Signature: fwfa9mbkcf3gsqayahsb13j67jkbeddq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793001802-223459
X-HE-Meta: U2FsdGVkX18olJIQmiQlKjYf8ZK0W7Bn7LxSrZGyfugGJyW5Izsvq5mfJzpDcmMmM15m7Y0Gkctdf7mJAY0gTvV2uJ6rAF0rewnlHkqOGrUaQ9rR6Q4yli9Fw5LcS0AvKsLZCePcJsaSd1p9qLhUnsZcDSxDuRMmjmoAsSFt7TNm1iDDL/WoIRgBvGE25be8URmZgqAQWciDFR/jU6v8ZNuZJXIurspAZZpDsIQYKeKOUdBGeV4wc+Gs7BakJNjywqyoERBscLs1g8efZSUQgHggyJXJr8kQ212Gul8Tqgcrgfc/ns6kR1N24IT3EuDQTZedP4/I/Jwctm5L9hHNDRnHm41zrd2ifVkIG2Bol0vtKV86iL/a7RnGHLDLQLen0J5ILkqfQptGlYYAnVqaj8ZGNd0lpqdr6auQbWc2NXmsTeCoooxTnB0UGC/jwJk9jYScpb40LE89VmxVry4JhrE70+QQ3lABDh3hyjHpt7adOMTtgg3Cnl67ylq0kK1e7SehJfRWoSnBNoBm3kRDcWljRR0vWRDiOYQF0RPvTikwkPHZB1jtBPrS7zyZc4SX/cizYHdqPVo6//HPEISHHpgTb6bFsflKIMunJiAKoqoTKl+OdZdVLzlclv2kt5zbguMNLb+UXfIDFljG6U7tSLfqqkcRqMZy7DiE0FzG6qpMVw0oyNl+fksafwoDdyJbxNzjOrRVmmXuCw/MRhqonBfyqBIALEdPPh8rigeErVTNIFZFo0AsLDwzc658yQk7bevAR7akNViBw9/i/UGaG9jM+DM8bMCeC10kscWXLfw/158AMAuwc2/t2yBJmjzv2QQJuTJpNxqPKdm/ZYLBkQzOiwpAMSReNzxS174w5Hsp92VtuPkXMvpZ85g7UrjS3VTYIzdt9hFzsbDT7mi5RAHcosUB3JlRu2KpWUQUjyc36ifdxXhBE3/AphoRbkoua2zSQMxLAD7WMbWM8uz
 ZBOTrR2g
 GsYiAGdZLY1uBTAQBv7luOij/hn1wdCpEOR0qzKAFdE+++OPIF4DcSls9fJfi2tYfTylykLEVh9pp7y5BhVAmDnwXyZJ/5eLayWLzcELqmgfQ55Qgncw6xVYfX5esKp9Q/nx/i8KZrXWVxqJeHpSx2pIWAdPYlhkFt47CfivhEaVyVrHBZ+Stp+DzvjbRejV88oVBAxHc36AGUZsD3iJhezcUZvaG299g91H6nM1lHM1GGPwTFJw0OLNXc5E6hdONzaxXzhYaulDGJ3W4IR6+rUPt3jt2Mn/Dqf8y/hSDWLk35v/svwcDvrO8/JS/azRhpB3ZvhPbAngZHBeGgkCxLWqxuCzXYLEwu5aV
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


