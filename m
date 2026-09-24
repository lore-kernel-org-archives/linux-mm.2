Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288F0C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466096B00AE; Thu, 24 Sep 2026 06:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D556B00AF; Thu, 24 Sep 2026 06:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353466B00B0; Thu, 24 Sep 2026 06:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 092276B00AE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:09:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A36351C1F9C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:48 +0000 (UTC)
X-FDA: 85248234456.17.A3D1D5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E03A180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:09:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hn9hv8eW;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwj3iE+AENM1wdyeAW0ucsrV1xoTqhkmjLwoH3q3QAw=;
	b=Uh2ZKerkmQXJ9WA+o88hj9cTxebu8PRl3igfkVDq1zuNATlUZczlSWcsCbIajawJlwzyKp
	DpKhyq5dQc5eMS9GXAtT/aw+6ASuwwQq0zTz5YyL4oN/dYsJBKcreK4LPBwQR8fsWzFDS1
	LHAV7UXZHsCdDklwrQXtvWYwfs6qS3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244587;
	b=NR/Cm7qMnDvrw22HJtcvVNtsB+g2l681xwT6oyZ+p53odyZuVxQtZSTZrAZpsP3GSs6WwC
	awP+/zKOG9aQ7EZKtdp8n1GVHjH978n1rBBpXIUpTON7Rebky9V+AJlhzkwy/AJxvA2TIu
	pIEzvb4jh4m6DamhbhqJHElOVOpBQPg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hn9hv8eW;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A47CF6022C;
	Thu, 24 Sep 2026 10:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EA21F00893;
	Thu, 24 Sep 2026 10:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244586;
	bh=dwj3iE+AENM1wdyeAW0ucsrV1xoTqhkmjLwoH3q3QAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn9hv8eWpaJ0p+isry01mjUR+t12CaIbyEhnYYrvyrYgoLrjQYYfgPDJQdaSjfaPh
	 50aE3RW/t7UTODmesgPWy0ykAx61CbS4D8dbfsypnco6ojqRMUwF5OtdYDnTstc9Iz
	 8k6nZlY00DBlv3G/7lbhrvb9n8+bCjYSXakBrGqK4DtvHWl2lG8/1uIwzhqKepwQqd
	 DHbK/opblE1OlSJEblhsQ8zPACxiJ3fuzRt6fdYGbBz++jf6Za8pckAUtcXcqECLqB
	 AVrLitP9+Im6vOn8+550xQCIMvJHFC3d7TSv1eybV24j9U20ScblwOD7FdGj1Kf6sc
	 NRGOq4IPnJXrQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
Date: Thu, 24 Sep 2026 15:35:29 +0530
Message-ID: <20260924100529.1398790-15-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E03A180007
X-Stat-Signature: gxd9cxujqs47orxmmiz1w6ewjzo4wpxn
X-HE-Tag: 1790244586-606570
X-HE-Meta: U2FsdGVkX19Kz0UhFzcC7GLImLC/8yPYVxsD1NeLQGJLr5TBUG8MVhdx5jR6vDzRWOmagAx3RuJRa9SD/ecnJlNOtgMBGV58lwC6s8XuwUQ9V8XjBanoFKlm5zdNSlr0pdrFM3v1HM8aViPG1jL3mSqxMPMoFFmBMxw3X44NjHAqEuHvHVEorZHuxScHrH3AiHNkQDNCdUr4a4DYb2QJjyQLR5WyKSZYIU4MSJNMxFHGH3oUgVju3Ut8MuxaFrfnx9kwI5PtA9hXT790W6IpaSes6+aMTAdJlsJW0eAaBaWChmyFcY54uLMY2hIqYGHqJb+f8O65mM1fhNvM/eROZU1/F1j0siZAgdoGAQurIGeqg9tvrypLPyteV5eSFl2vWxhUTwCCDzgbNpdat8dh7uq9v4+AhT9Lx3MJmavG5xQg5194g+5dHBw6vhQ4ZFkQTMvCd5uQt1kxZW+KfLXSjL3HRWFVShU1olvEDUC+9geu1C8F3/UCCUOaG1ANG2Fxye44CrINAr/Fu8lcj6cPwKSSl+xQqMZHGuLKYnLt4Uc7O8UIXiMyakD5uo4Say29ag06fW/pbSfIz5HPgYezveAzb+1DagVhD2A0JwkZ10eVZL6ql7HNrfWrnxEfyXhBjQAxNL45FS5cw/ARH0IYjmLSTUrAuKMxXoWzGycFzcWMx0xDfk7gFtHiEq51BpSE/ZU7wj6FbYPJjGvUV1Oe9QMV6/1sZywFLABNdcK+bBsBOuWO19swf3kcTtYc7cRIuEsJ7zkV3o2pLICkIGrZgO4y59Z+ScWvuN2ocZypQX1YfXeCTneLVBbt7GZLaxPFUacqPwTxpydRS+IecOqIVpf/et/dbyAYfGotjVTpKmA2HQFr/sK9Pw6nze9mMmRWhPCHh/iXJF1N0IysVCSrpmfo4I8BFo5e2GmDEJLPQzl0GH6YHKn+mcemFL9qCpPG5MLw7bGPy6T/+dEAWKo
 AIAn56km
 suE7ua30hecCl/jHOIub2uk9h2K99oLi4JbfFqD2rI7CQ8WtImg7c+jWEwAhhAAlX1yWOIHM9ukRRxKJX9/XaDcjc7geIqASRRWyFdy/NXmCbuaVDr082nOsBDn0ES/s4RskCGAnR8dEezY+KYgoOdZmKGQlpwh6/E6T6Hg0bHRi6uYjQsipYbPCguYv6wyALOdZm/1mPce80ULp0MV9PzjL+6ykvb3irx5EH2HhfYYwMJ92TSHL92zKDsLaeZqdSUZTTrbrwoytHb7ziaeRvmPNwME2EnBjfL3/6uP9r6ASCRUc8jU7iRnz/wu9TdnBSRIoFPeH6cSq79VnU7yyYq+72SxFIy0NGXr/Uo3T4qIocsGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
not allowed.  Remove the page allocation from this atomic path.

Use a blocking allocation for the boot CPU and record the resulting table
order.  Allocate a page of that order from the sleepable CPU hotplug prepare
stage for each secondary CPU.  Consume the preallocated page only when the CPU
cannot inherit an existing redistributor or ITS table.

Reclaim unused preallocations after the CPU reaches the online state, and from
the prepare-state teardown when CPU bring-up aborts.

Assisted-by: Codex:gpt-5
Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 110 +++++++++++++++++++++++++++--
 drivers/irqchip/irq-gic-v3.c       |   4 +-
 include/linux/irqchip/arm-gic-v3.h |   3 +-
 3 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4814161df02e..a8f37fb97845 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -195,6 +195,7 @@ static DEFINE_PER_CPU(struct cpu_lpi_count, cpu_lpi_count);
 static LIST_HEAD(its_nodes);
 static DEFINE_RAW_SPINLOCK(its_lock);
 static struct rdists *gic_rdists;
+static unsigned int vpe_l1_prealloc_order = UINT_MAX;
 static struct irq_domain *its_parent;
 
 static unsigned long its_list_map;
@@ -2884,12 +2885,35 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 	return true;
 }
 
-static int allocate_vpe_l1_table(void)
+static unsigned int vpe_l1_table_order(u64 val)
+{
+	unsigned int psz;
+	u64 npg;
+
+	switch (FIELD_GET(GICR_VPROPBASER_4_1_PAGE_SIZE, val)) {
+	default:
+	case GIC_PAGE_SIZE_4K:
+		psz = SZ_4K;
+		break;
+	case GIC_PAGE_SIZE_16K:
+		psz = SZ_16K;
+		break;
+	case GIC_PAGE_SIZE_64K:
+		psz = SZ_64K;
+		break;
+	}
+
+	npg = FIELD_GET(GICR_VPROPBASER_4_1_SIZE, val) + 1;
+	return get_order(npg * psz);
+}
+
+static int allocate_vpe_l1_table(bool use_prealloc)
 {
 	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
 	u64 val, gpsz, npg, pa;
 	unsigned int psz = SZ_64K;
 	unsigned int np, epp, esz;
+	unsigned int order;
 	struct page *page;
 
 	if (!gic_rdists->has_rvpeid)
@@ -2982,7 +3006,16 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = its_alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	order = get_order(np * PAGE_SIZE);
+	if (use_prealloc) {
+		if (WARN_ON_ONCE(order != vpe_l1_prealloc_order))
+			return -EINVAL;
+
+		page = gic_data_rdist()->vpe_l1_prealloc;
+		gic_data_rdist()->vpe_l1_prealloc = NULL;
+	} else {
+		page = its_alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	}
 	if (!page)
 		return -ENOMEM;
 
@@ -2999,6 +3032,9 @@ static int allocate_vpe_l1_table(void)
 	val |= GICR_VPROPBASER_4_1_VALID;
 
 out:
+	if (!use_prealloc)
+		vpe_l1_prealloc_order = vpe_l1_table_order(val);
+
 	gicr_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
 	cpumask_set_cpu(smp_processor_id(), gic_data_rdist()->vpe_table_mask);
 
@@ -3138,7 +3174,7 @@ static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
 	return val;
 }
 
-static void its_cpu_init_lpis(void)
+static void its_cpu_init_lpis(bool use_prealloc)
 {
 	void __iomem *rbase = gic_data_rdist_rd_base();
 	struct page *pend_page;
@@ -3251,7 +3287,7 @@ static void its_cpu_init_lpis(void)
 		val = its_clear_vpend_valid(vlpi_base, 0, 0);
 	}
 
-	if (allocate_vpe_l1_table()) {
+	if (allocate_vpe_l1_table(use_prealloc)) {
 		/*
 		 * If the allocation has failed, we're in massive trouble.
 		 * Disable direct injection, and pray that no VM was
@@ -5422,7 +5458,7 @@ static int redist_disable_lpis(void)
 	return 0;
 }
 
-int its_cpu_init(void)
+int its_cpu_init(bool use_prealloc)
 {
 	if (!list_empty(&its_nodes)) {
 		int ret;
@@ -5431,13 +5467,66 @@ int its_cpu_init(void)
 		if (ret)
 			return ret;
 
-		its_cpu_init_lpis();
+		its_cpu_init_lpis(use_prealloc);
 		its_cpu_init_collections();
 	}
 
 	return 0;
 }
 
+static int its_vpe_l1_prepare(unsigned int cpu)
+{
+	struct page **prealloc;
+
+	if (!gic_rdists->has_rvpeid ||
+	    vpe_l1_prealloc_order == UINT_MAX ||
+	    (gic_data_rdist_cpu(cpu)->flags & RD_LOCAL_LPI_ENABLED))
+		return 0;
+
+	prealloc = &gic_data_rdist_cpu(cpu)->vpe_l1_prealloc;
+	if (*prealloc)
+		return 0;
+
+	*prealloc = its_alloc_pages_node(cpu_to_node(cpu),
+					 GFP_KERNEL | __GFP_ZERO,
+					 vpe_l1_prealloc_order);
+	return *prealloc ? 0 : -ENOMEM;
+}
+
+static int its_vpe_l1_cleanup(unsigned int cpu)
+{
+	struct page *page;
+
+	page = xchg(&gic_data_rdist_cpu(cpu)->vpe_l1_prealloc, NULL);
+	if (page)
+		its_free_pages(page_address(page), vpe_l1_prealloc_order);
+
+	return 0;
+}
+
+static int __init its_vpe_l1_cpuhp_init(void)
+{
+	int prepare_state, state;
+
+	state = cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
+					  "irqchip/arm/gicv3-vpe:prepare",
+					  its_vpe_l1_prepare,
+					  its_vpe_l1_cleanup);
+	if (state < 0)
+		return state;
+	prepare_state = state;
+
+	state = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					  "irqchip/arm/gicv3-vpe:online",
+					  its_vpe_l1_cleanup, NULL);
+	if (state < 0) {
+		cpuhp_remove_state_nocalls(prepare_state);
+		return state;
+	}
+
+	return 0;
+}
+
 static void rdist_memreserve_cpuhp_cleanup_workfn(struct work_struct *work)
 {
 	cpuhp_remove_state_nocalls(gic_rdists->cpuhp_memreserve_state);
@@ -5862,6 +5951,15 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	if (WARN_ON(!has_v4_1 && rdists->has_rvpeid))
 		rdists->has_rvpeid = false;
 
+	if (rdists->has_rvpeid) {
+		err = its_vpe_l1_cpuhp_init();
+		if (err) {
+			rdists->has_rvpeid = false;
+			rdists->has_vlpis = false;
+			pr_err("ITS: Failed to prepare VPE tables, disabling GICv4 support\n");
+		}
+	}
+
 	if (has_v4 & rdists->has_vlpis) {
 		const struct irq_domain_ops *sgi_ops;
 
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6e1fa5b247fc..e2e00372dcfb 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1320,7 +1320,7 @@ static int gic_starting_cpu(unsigned int cpu)
 	gic_cpu_init();
 
 	if (gic_dist_supports_lpis())
-		its_cpu_init();
+		its_cpu_init(true);
 
 	return 0;
 }
@@ -2053,7 +2053,7 @@ static int __init gic_init_bases(phys_addr_t dist_phys_base,
 
 	if (gic_dist_supports_lpis()) {
 		its_init(handle, &gic_data.rdists, gic_data.domain, dist_prio_irq);
-		its_cpu_init();
+		its_cpu_init(false);
 		its_lpi_memreserve_init();
 	} else {
 		if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ea5fd2374ebe..a5565a745100 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -621,6 +621,7 @@ struct rdists {
 		u64             flags;
 		cpumask_t	*vpe_table_mask;
 		void		*vpe_l1_base;
+		struct page	*vpe_l1_prealloc;
 	} __percpu		*rdist;
 	phys_addr_t		prop_table_pa;
 	void			*prop_table_va;
@@ -637,7 +638,7 @@ struct rdists {
 struct irq_domain;
 struct fwnode_handle;
 int __init its_lpi_memreserve_init(void);
-int its_cpu_init(void);
+int its_cpu_init(bool use_prealloc);
 int its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	     struct irq_domain *domain, u8 irq_prio);
 int mbi_init(struct fwnode_handle *fwnode, struct irq_domain *parent);
-- 
2.43.0


