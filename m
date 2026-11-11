Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19766606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=hYLYssA0
Received: by kanga.kvack.org (Postfix)
	id 1388E6B05B3; Wed, 11 Nov 2026 18:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E17B6B05B8; Wed, 11 Nov 2026 18:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBD96B05BD; Wed, 11 Nov 2026 18:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B60946B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:12:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E93AC02C8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:12:24 +0000 (UTC)
X-FDA: 85424389008.13.9B74418
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFFA54000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:12:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hYLYssA0;
	spf=pass (imf17.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438742;
	b=tz6NIl/RIme3Rm42SJrAOWKqiIiwyPQko/oJKotkj+YGfRhdh1+yJ2pM3kSCU5TloyGOp6
	WYpWDHUld/nxgBHtqveaOCOwbV+bR+6WnJrTsufRTYWidqiJy/CJuUGYhDhTgLJRRPAkVJ
	ULAF+sNzleA/Vs2nc6B35c+A4/Of6Fk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hYLYssA0;
	spf=pass (imf17.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNIEPDuhqStN4HF4N7LcMFdEdY9vqc1YFIz5yG1MSFs=;
	b=vb+HDCjDI6p+CTD1gdxNZL6QHyVQdzl7l9LFNxt3aMII+HKKlFRZjD/WP7k+4YL8pQ0FS8
	Lm5WwPitqXk6jvGtkm4yyOu8xIaZPo7ZXQCQfovzPOFiGxnkGcMkXFN8lOyxeR3uNzrfA7
	Db76I2S7a/qG9/U5ZAKIhVIUR3ViFmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438741; x=1825974741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VNIEPDuhqStN4HF4N7LcMFdEdY9vqc1YFIz5yG1MSFs=;
  b=hYLYssA00lJ7VXEDBBXMOozTSQWtF0xb9Iz9B78cI0z0a6pohnmdGJOK
   cu05lr8Voz5H8V1MosdzgsJyEmNjx0Fgr1dI1NuHgyKYJyxzJuOm/8UqP
   EuMXrNx6oj+SPtlBDm5u3dqsXD5RPCbn7Hs1ttkxZug6A/I4ZKQd524V2
   QxShIVhuBWjxAsN1QnRJVdA7LfDnlaGFRazBKWspZa3D/qVuGiHQiByS0
   egzGik7N9c4TeIrB/NgpRsRtNWAJYZwU5eHOYCzgoFfyXXRlPYYnWMkXN
   /FaJu36rtU0XTM6GDCjp+0DHTEow28N1g5/what646NWbpokUgfam+rbU
   A==;
X-CSE-ConnectionGUID: kvBWXK+hTsOPZuf+0vvGNw==
X-CSE-MsgGUID: 5eZIbGlDTzm7wjOwWzmaKw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33573918"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:12:20 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:17378]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id 1e72a3cb-0649-4a32-9a1c-1b640a0756a6; Wed, 11 Nov 2026 23:12:20 +0000 (UTC)
X-Farcaster-Flow-ID: 1e72a3cb-0649-4a32-9a1c-1b640a0756a6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:12:19 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:12:16 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 37/40] nitro_enclaves: Add NE_ENCLAVE_CPU_OVERCOMMIT_MODE
Date: Wed, 11 Nov 2026 22:59:41 +0000
Message-ID: <58469275b84367e8a49ae9975df231abc26234ea.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: rdtmdkpf8ds36jem4r8zyenidm3jq7pf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFFA54000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438741-736200
X-HE-Meta: U2FsdGVkX1/MRtKqevhoslfzT0t6YCrRFKFHLnneUWhG80CSJJAY5MQtZwoMK6lD4Dj4PyCQH4iB0R1GLA9rQ+PJHpMx6gXj5USc54kUV+l4b8c2CWUrOekl/ZaGqSF8I0qFAmdnEOjxD+ER2cS/dATegr7y/pJXDm2pvQeCQSgxzMRet6XPztpUyPfPHstHFdr9tfrLmvb1xAarxbyNwmPAaVHBayOb7QNeD3tc+pc9kiokE5fLfMhr8XVektJLWYOwQmgRueZps2LJa3zKEgMF/o3udVw2hE6aafruioe5hSm9W+7Cb3Why4bpZJXm/uYYjlcaSHnPxUgaqU+YPuzotvklT9SZ3YS21+XDf7AfXHWYhS/wsERtUaZEjGdB9cGO587ZZgGecHOF/38CtHPWzCyoAvWcnFW3l8UpGFTROcLrYs+D1mmFfWpDdt2xfrY4FvEv1yoChwXqvd61UEAx0gBWPtiADmNZIr6MpKh44K+Lf9zCTh74lo7eR/IaEz5I9bqh3rJYFeOvL9nXB1Cs+TzLnUVDC3RCZQ1EvEfUHYPbC0lDvyMJ5fgiv1+cuyRm0HPgN8V1Ry14T4mGILR/A+Hatv2fUHKvx4p1dH7qp5w4ocJ0OTohmi2mYEnHcbCXg7wTD3KQAeSO0r0uanBlGWGw4bZ7vbvJmTjdLz+BUV37DvbI9etIGVyu9McBGanvETEwWSQSr17nYsEta9+OaS1teAn71w2tEi+ffCDy3sBzuh1y2jFukEOdj82UYsivZjKXU1BRexqJjZZ1VF9v+RPkclweHl9+LaemBMK8UBicX9u4x8Sa/dFpkq6DZkRPH9L+lPtCHuwvalX1pybg8ugm4w119BzggVEi+gjetQP+MlT4APuuU3Kn75Mc1V59IT8xqVcv/B37z+HJFhtLmsmRzA6P5b/0JnNjMJAl98x/GcY8gkpMqO8p5ivAhy+pu5Xvat+B/nGCwNT
 EkMVgYo7
 K30wf2g9pMKWfe25jPw2fqfMD0EvpYpT6Xg27pvctQbmMIhToP2idWL+niVkF71bSMi+s3C9gYd+1rhwjluLO+Yn8zC6+mMpFyxYCLglGhEW7gKnsk/K7jPqH93SCr9awgzory5RA/T93O7BAu2mFWq5J5jYhe1y7CJfypCQ8I4KZAC8wIao5d4NRgEAB0SwgUaaXua2VMFmtLE29VaJBGmezJRQgjjfsJ7bXqMvpnMR3r7kwDVJTA4xe5X9X3Idhhe3JzsOL8847X+EoUTgHo+9lfytFeu4MTPBqT4SzgTBrasbDWdzUcg2CS6Uh7O8Zw0oHu0ix2D5yo92WIV0VpubyaS3WoUfWnLJdDmXjUZddvROxMFoOzZ4h5Mg/9HR1jfQDeeK3L6HIX1PArfcglpQYSDufISYIQBCjlIoiuApOeZ1ZzTv65ckO1dWfknK/CCoNhUooWg2RPeIDDnB64OBsbyX2YblW7NXchne9ibczFrZGZL9alwaGELwr+vzil123Zcprcp2015dg5J9xgDTZRsi9Krxyn4ufY3dK5n4bE54Hr/qe2wgWq4zLAkhCLmuD0gzziJXGhoYdRemhSw3letUiC8L4q+i0znOcLt9gEiUiEXopVc6pk8FaWCifo8Q7Jt+SjI8+ysm5/x81Z+oLdEHDstrwSzaPr/fYZdKauUcblK9gk14Ru2cEmVwkeXFgde4PZ7jlDPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes relax the dedicated-vCPU requirement and allow a sandbox
to opt-in to CPU overcommitment. When active, the hypervisor performs
vCPU scheduling of sandbox vCPUs (vCores really) on top of the parent's
vCPUs.

Add the NE_ENCLAVE_CPU_OVERCOMMIT_MODE flag and relax the dedicated CPU
validation and pooling logic when the mode is active.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst        |  15 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 249 ++++++++++++++++++++--
 drivers/virt/nitro_enclaves/ne_misc_dev.h |   1 +
 include/uapi/linux/nitro_enclaves.h       |  45 +++-
 4 files changed, 283 insertions(+), 27 deletions(-)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 5984fd32ec07a..3aa33d3f06cf2 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -113,10 +113,23 @@ each node in turn, and sets numa_node to NE_NUMA_ANY when it does not
 care. Both start from a free thread of a core the enclave already holds,
 and only take a new core once there is none.
 
+A slot allocated with NE_ENCLAVE_CPU_OVERCOMMIT_MODE has its vCPUs
+scheduled by the host alongside the parent's own and takes no core out of
+the pool, so the pool is not consulted for it. Both NE_ADD_VCPU and
+NE_ADD_ANY_VCPU choose an id the enclave does not hold yet, and the host
+schedules the vCPU alongside the parent CPU that id names, so the node
+NE_ADD_ANY_VCPU takes still places it, and a node with no free id left
+fails the request. Both prefer a free id whose SMT sibling the enclave
+already holds, so its vCPUs share cores as they do with a pool, and
+otherwise take the lowest free id. A parent that never set a pool up runs
+such an enclave.
+
 The node says where cores come from. NE_ALLOC_MEMORY takes its own node;
 see `Memory pool`_. An enclave built out of a pool that spans
 nodes has no node of its own, so the rule that its memory be on that node
-does not apply to it and its memory can come from any node.
+does not apply to it and its memory can come from any node. A slot
+allocated with NE_ENCLAVE_CPU_OVERCOMMIT_MODE holds no core at all, so it
+has no node of its own either.
 
 The pool occupancy is readable under
 /sys/devices/virtual/misc/nitro_enclaves/cpu_pool/, and per node under
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 870b3a6368cf9..e79740eac6f29 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -267,6 +267,12 @@ static const struct kernel_param *ne_cpus_kp;
  *				ne_setup_cpu_pool() offlines them, because
  *				cpu_to_node() is not documented to answer for an
  *				offline CPU.
+ * @core_cpus:			The threads of each core slot, indexed the same
+ *				way as @avail_threads_per_core. Unlike that
+ *				array it does not change while the pool is set
+ *				up, so it names the SMT siblings of a pool CPU
+ *				while the CPU is offline and
+ *				topology_sibling_cpumask() no longer names them.
  * @node_cpus:			The threads of the pool on each NUMA node, indexed
  *				by node id and sized by nr_node_ids. It partitions
  *				@total_cpus: a thread sits in the entry of the node
@@ -292,6 +298,7 @@ struct ne_cpu_pool {
 	unsigned int	nr_parent_vm_cores;
 	int		numa_node;
 	int		*core_nid;
+	cpumask_var_t	*core_cpus;
 	cpumask_var_t	*node_cpus;
 	struct cpumask	total_cpus;
 	struct cpumask	used_cpus;
@@ -656,6 +663,14 @@ static void ne_free_core_slots(void)
 	kfree(ne_cpu_pool.core_nid);
 	ne_cpu_pool.core_nid = NULL;
 
+	if (ne_cpu_pool.core_cpus) {
+		for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+			free_cpumask_var(ne_cpu_pool.core_cpus[i]);
+
+		kfree(ne_cpu_pool.core_cpus);
+		ne_cpu_pool.core_cpus = NULL;
+	}
+
 	if (ne_cpu_pool.node_cpus) {
 		for (nid = 0; nid < nr_node_ids; nid++)
 			free_cpumask_var(ne_cpu_pool.node_cpus[nid]);
@@ -719,6 +734,10 @@ static int ne_build_core_slots(const struct cpumask *cpu_pool)
 	if (!ne_cpu_pool.core_nid)
 		goto free_slots;
 
+	ne_cpu_pool.core_cpus = kzalloc_objs(*ne_cpu_pool.core_cpus, nr_cores);
+	if (!ne_cpu_pool.core_cpus)
+		goto free_slots;
+
 	ne_cpu_pool.node_cpus = kzalloc_objs(*ne_cpu_pool.node_cpus, nr_node_ids);
 	if (!ne_cpu_pool.node_cpus)
 		goto free_slots;
@@ -728,7 +747,8 @@ static int ne_build_core_slots(const struct cpumask *cpu_pool)
 			goto free_slots;
 
 	for (i = 0; i < nr_cores; i++)
-		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_threads_per_core[i], GFP_KERNEL))
+		if (!zalloc_cpumask_var(&ne_cpu_pool.avail_threads_per_core[i], GFP_KERNEL) ||
+		    !zalloc_cpumask_var(&ne_cpu_pool.core_cpus[i], GFP_KERNEL))
 			goto free_slots;
 
 	cpumask_clear(processed);
@@ -746,6 +766,9 @@ static int ne_build_core_slots(const struct cpumask *cpu_pool)
 			cpumask_set_cpu(cpu_sibling, processed);
 		}
 
+		cpumask_copy(ne_cpu_pool.core_cpus[next_core_idx],
+			     ne_cpu_pool.avail_threads_per_core[next_core_idx]);
+
 		core_nid = cpu_to_node(cpu);
 
 		ne_cpu_pool.core_nid[next_core_idx] = core_nid;
@@ -1166,6 +1189,118 @@ static bool ne_donated_cpu(struct ne_enclave *ne_enclave, unsigned int cpu)
 	return false;
 }
 
+/**
+ * ne_cpu_pool_core() - Find the core slot of a CPU in the NE CPU pool.
+ * @cpu:	CPU to look up.
+ *
+ * Context: Process context. This function is called with the ne_cpu_pool mutex
+ *	    held.
+ * Return:
+ * * Index of the core slot that holds @cpu.
+ * * -1 if @cpu is not in the pool.
+ */
+static int ne_cpu_pool_core(unsigned int cpu)
+{
+	unsigned int i = 0;
+
+	if (!cpumask_test_cpu(cpu, &ne_cpu_pool.total_cpus))
+		return -1;
+
+	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+		if (cpumask_test_cpu(cpu, ne_cpu_pool.core_cpus[i]))
+			return i;
+
+	return -1;
+}
+
+/**
+ * ne_get_floating_vcpu_id() - Choose a vCPU id for a slot whose vCPUs the host
+ *				schedules.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @vcpu_id:		The chosen vCPU id, set on success.
+ * @lowest_id:		The lowest id the caller allows to be chosen.
+ * @nid:		The NUMA node the vCPU should land on, or NUMA_NO_NODE
+ *			for no preference.
+ *
+ * The host schedules such a vCPU wherever it schedules the parent's own
+ * threads, so no core is taken and there is no pool to take one out of. It
+ * reads the id as the parent CPU to schedule the vCPU alongside, so
+ * cpu_to_node() on the id says which node the vCPU lands on, and only a free
+ * id on @nid is chosen. A node with no free id fails instead of yielding an
+ * id on another node. Without NE_ENCLAVE_PCIE_NUMA_MODE the hypervisor
+ * refuses a slot whose vCPUs straddle nodes, and the caller would only learn
+ * that when it starts the enclave.
+ *
+ * A free id whose SMT sibling already holds one of the enclave's vCPUs comes
+ * first, so the vCPUs fill whole cores the way they do for a slot that takes
+ * its cores from the pool. Otherwise the lowest free id is chosen. The siblings
+ * and the node of a CPU in the NE CPU pool come from what the pool recorded
+ * while the CPU was online, because the pool may have taken it offline since.
+ * An id that is not a possible CPU names no host CPU and is only chosen when
+ * @nid is NUMA_NO_NODE.
+ *
+ * @lowest_id is 1 where the caller hands the id back in the same word it
+ * read the request from, since zero is the request there.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_get_floating_vcpu_id(struct ne_enclave *ne_enclave, u32 *vcpu_id,
+				   unsigned int lowest_id, int nid)
+{
+	const struct cpumask *siblings;
+	unsigned int first = nr_cpu_ids;
+	unsigned int cpu;
+	int core;
+
+	mutex_lock(&ne_cpu_pool.mutex);
+
+	for (cpu = lowest_id; cpu < nr_cpu_ids; cpu++) {
+		if (cpumask_test_cpu(cpu, ne_enclave->vcpu_ids))
+			continue;
+
+		if (!cpu_possible(cpu)) {
+			if (nid != NUMA_NO_NODE)
+				continue;
+
+			if (first == nr_cpu_ids)
+				first = cpu;
+
+			continue;
+		}
+
+		core = ne_cpu_pool_core(cpu);
+		if (core >= 0)
+			siblings = ne_cpu_pool.core_cpus[core];
+		else
+			siblings = topology_sibling_cpumask(cpu);
+
+		if (nid != NUMA_NO_NODE &&
+		    (core >= 0 ? ne_cpu_pool.core_nid[core] : cpu_to_node(cpu)) != nid)
+			continue;
+
+		if (first == nr_cpu_ids)
+			first = cpu;
+
+		if (cpumask_intersects(ne_enclave->vcpu_ids, siblings))
+			break;
+	}
+
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	if (cpu >= nr_cpu_ids)
+		cpu = first;
+
+	if (cpu >= nr_cpu_ids)
+		return -NE_ERR_INVALID_VCPU;
+
+	*vcpu_id = cpu;
+
+	return 0;
+}
+
 /**
  * ne_get_unused_core_from_cpu_pool() - Get the id of a full core from the
  *					NE CPU pool.
@@ -2578,7 +2713,37 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 			return -NE_ERR_INVALID_VCPU;
 		}
 
-		if (!vcpu_id) {
+		if (ne_enclave->launch_flags & NE_ENCLAVE_CPU_OVERCOMMIT_MODE) {
+			/*
+			 * The pool hands out the parent VM cores a slot runs
+			 * its vCPUs on, and a slot the host schedules the vCPUs
+			 * of takes none, so the pool is not consulted for it.
+			 * An id of zero asks this kernel to choose, as it does
+			 * for any other slot; an enclave still cannot be given
+			 * the same id twice.
+			 */
+			if (!vcpu_id) {
+				rc = ne_get_floating_vcpu_id(ne_enclave, &vcpu_id,
+							     1, NUMA_NO_NODE);
+				if (rc < 0) {
+					dev_err_ratelimited(ne_misc_dev.this_device,
+							    "Error in choosing a vCPU id [rc=%d]\n",
+							    rc);
+
+					mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+					return rc;
+				}
+			} else if (ne_donated_cpu(ne_enclave, vcpu_id)) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "CPU %d already used\n",
+						    vcpu_id);
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return -NE_ERR_VCPU_ALREADY_USED;
+			}
+		} else if (!vcpu_id) {
 			/* Use the CPU pool for choosing a CPU for the enclave. */
 			rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id,
 						      NUMA_NO_NODE);
@@ -2823,15 +2988,38 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 			return -NE_ERR_NOT_IN_INIT_STATE;
 		}
 
-		rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id, args.numa_node);
-		if (rc < 0) {
-			dev_err_ratelimited(ne_misc_dev.this_device,
-					    "Error in get CPU from pool [rc=%d node=%d]\n",
-					    rc, args.numa_node);
+		if (ne_enclave->launch_flags & NE_ENCLAVE_CPU_OVERCOMMIT_MODE) {
+			/*
+			 * The host schedules the vCPUs of such a slot wherever
+			 * it schedules the parent's own threads, so the slot
+			 * takes no core out of the pool and the pool is not
+			 * consulted for it. It reads the id as the parent CPU
+			 * to schedule the vCPU alongside, so @numa_node still
+			 * says which node the vCPU lands on and the id is
+			 * chosen to match it.
+			 */
+			rc = ne_get_floating_vcpu_id(ne_enclave, &vcpu_id, 0,
+						     args.numa_node);
+			if (rc < 0) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in choosing a vCPU id [rc=%d]\n",
+						    rc);
 
-			mutex_unlock(&ne_enclave->enclave_info_mutex);
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
 
-			return rc;
+				return rc;
+			}
+		} else {
+			rc = ne_get_cpu_from_cpu_pool(ne_enclave, &vcpu_id, args.numa_node);
+			if (rc < 0) {
+				dev_err_ratelimited(ne_misc_dev.this_device,
+						    "Error in get CPU from pool [rc=%d node=%d]\n",
+						    rc, args.numa_node);
+
+				mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+				return rc;
+			}
 		}
 
 		rc = ne_add_vcpu_ioctl(ne_enclave, vcpu_id);
@@ -3433,22 +3621,31 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 		slot_alloc_req.flags = flags;
 	}
 
-	mutex_lock(&ne_cpu_pool.mutex);
+	/*
+	 * The pool hands out the cores a slot runs its vCPUs on, and it has
+	 * none left once every core in it has had its threads taken, which is
+	 * also where a parent that never set one up starts. A slot the host
+	 * schedules the vCPUs of takes no core out of the pool, so what the
+	 * pool has left says nothing about it.
+	 */
+	if (!(flags & NE_ENCLAVE_CPU_OVERCOMMIT_MODE)) {
+		mutex_lock(&ne_cpu_pool.mutex);
 
-	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
-		if (!cpumask_empty(ne_cpu_pool.avail_threads_per_core[i]))
-			break;
+		for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
+			if (!cpumask_empty(ne_cpu_pool.avail_threads_per_core[i]))
+				break;
 
-	if (i == ne_cpu_pool.nr_parent_vm_cores) {
-		dev_err_ratelimited(ne_misc_dev.this_device,
-				    "No CPUs available in CPU pool\n");
+		if (i == ne_cpu_pool.nr_parent_vm_cores) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "No CPUs available in CPU pool\n");
 
-		mutex_unlock(&ne_cpu_pool.mutex);
+			mutex_unlock(&ne_cpu_pool.mutex);
 
-		return -NE_ERR_NO_CPUS_AVAIL_IN_POOL;
-	}
+			return -NE_ERR_NO_CPUS_AVAIL_IN_POOL;
+		}
 
-	mutex_unlock(&ne_cpu_pool.mutex);
+		mutex_unlock(&ne_cpu_pool.mutex);
+	}
 
 	ne_enclave = kzalloc_obj(*ne_enclave);
 	if (!ne_enclave)
@@ -3459,7 +3656,17 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	mutex_lock(&ne_cpu_pool.mutex);
 
 	ne_enclave->nr_parent_vm_cores = ne_cpu_pool.nr_parent_vm_cores;
-	ne_enclave->numa_node = ne_cpu_pool.numa_node;
+
+	/*
+	 * The node an enclave takes its memory from is the node its cores
+	 * are on. A slot the host schedules the vCPUs of holds no core, so
+	 * it has no node of its own and its memory can come from any of
+	 * them.
+	 */
+	if (flags & NE_ENCLAVE_CPU_OVERCOMMIT_MODE)
+		ne_enclave->numa_node = NUMA_NO_NODE;
+	else
+		ne_enclave->numa_node = ne_cpu_pool.numa_node;
 
 	mutex_unlock(&ne_cpu_pool.mutex);
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index ed1b29997e1bb..f18b57a225325 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -27,6 +27,7 @@
 					 NE_ENCLAVE_PCIE_VSOCK_MODE | \
 					 NE_ENCLAVE_PCIE_VIRTIO_MODE | \
 					 NE_ENCLAVE_PCIE_HOTPLUG_MODE | \
+					 NE_ENCLAVE_CPU_OVERCOMMIT_MODE | \
 					 NE_ENCLAVE_PCIE_NUMA_MODE)
 
 struct cma;
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index f204d0f6e7efd..bfe1ca5ef7f7f 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -96,6 +96,21 @@
  */
 #define NE_ENCLAVE_PCIE_HOTPLUG_MODE	(1u << 8)
 
+/**
+ * NE_ENCLAVE_CPU_OVERCOMMIT_MODE - Allocate a slot whose vCPUs the host
+ *				    schedules alongside the parent's own,
+ *				    instead of running them on cores taken out
+ *				    of the NE CPU pool. The pool is not consulted
+ *				    for such a slot: %NE_ADD_VCPU and
+ *				    %NE_ADD_ANY_VCPU both choose an id the enclave
+ *				    does not hold yet, and the host schedules the
+ *				    vCPU alongside the parent CPU that id names.
+ *				    Requires
+ *				    NE_ENCLAVE_PCIE_MODE and
+ *				    NE_ENCLAVE_PCIE_VIRTIO_MODE.
+ */
+#define NE_ENCLAVE_CPU_OVERCOMMIT_MODE	(1u << 11)
+
 /**
  * NE_ENCLAVE_PCIE_NUMA_MODE - Allocate a slot whose memory and vCPUs may come
  *			       from more than one host NUMA node. Without it the
@@ -162,7 +177,9 @@ struct ne_create_vm_args {
  * * ENOMEM				- Memory allocation failure for internal
  *					  bookkeeping variables.
  * * NE_ERR_NO_CPUS_AVAIL_IN_POOL	- No NE CPU pool set / no CPUs available
- *					  in the pool.
+ *					  in the pool, for a slot allocated
+ *					  without
+ *					  %NE_ENCLAVE_CPU_OVERCOMMIT_MODE.
  * * Error codes from get_unused_fd_flags() and anon_inode_getfile().
  * * Error codes from the NE PCI device request.
  */
@@ -177,7 +194,12 @@ struct ne_create_vm_args {
  *		 one enclave can be from different nodes.
  *		 The vCPU id is an input / output parameter. If its value is 0,
  *		 then a CPU is chosen from the enclave CPU pool and returned via
- *		 this parameter.
+ *		 this parameter. A slot allocated with
+ *		 %NE_ENCLAVE_CPU_OVERCOMMIT_MODE takes no CPU out of the pool,
+ *		 so the pool is not consulted for it: an id of 0 asks this
+ *		 kernel for one the enclave does not hold yet, preferring an
+ *		 id whose SMT sibling the enclave already holds, and the id
+ *		 it chooses is never 0.
  *		 The ioctl can be invoked on the enclave fd, before an enclave
  *		 is started.
  *
@@ -200,7 +222,9 @@ struct ne_create_vm_args {
  * * NE_ERR_NOT_IN_INIT_STATE		- The enclave is not in init state
  *					  (init = before being started).
  * * NE_ERR_INVALID_VCPU		- The provided vCPU is not in the available
- *					  CPUs range.
+ *					  CPUs range, or the slot was allocated
+ *					  with %NE_ENCLAVE_CPU_OVERCOMMIT_MODE and
+ *					  every id is taken.
  * * Error codes from the NE PCI device request.
  */
 #define NE_ADD_VCPU			_IOWR(0xAE, 0x21, __u32)
@@ -208,7 +232,9 @@ struct ne_create_vm_args {
 /**
  * struct ne_add_any_vcpu_args - Argument for %NE_ADD_ANY_VCPU.
  * @numa_node:	The NUMA node the vCPU has to come from, or %NE_NUMA_ANY for
- *		any node.
+ *		any node. For a slot allocated with
+ *		%NE_ENCLAVE_CPU_OVERCOMMIT_MODE it is the node the host
+ *		should schedule the vCPU on.
  * @vcpu_id:	The vCPU id the kernel chose, set on success. Ignored on
  *		input.
  */
@@ -231,7 +257,13 @@ struct ne_add_any_vcpu_args {
  *		     for each node in turn and stops when a node runs out.
  *		     @vcpu_id carries back the vCPU id the kernel chose, so
  *		     a caller collects the enclave's vCPU set as it builds
- *		     it.
+ *		     it. For a slot allocated with
+ *		     %NE_ENCLAVE_CPU_OVERCOMMIT_MODE the host schedules the
+ *		     vCPU rather than a core out of the pool running it, so
+ *		     the pool is not consulted and the chosen id is the
+ *		     parent CPU the host schedules it alongside. The kernel
+ *		     prefers an id whose SMT sibling the enclave already
+ *		     holds.
  *		     The ioctl can be invoked on the enclave fd, before an
  *		     enclave is started.
  *
@@ -251,6 +283,9 @@ struct ne_add_any_vcpu_args {
  *				  about and the excess is not all zero.
  * * NE_ERR_NOT_IN_INIT_STATE	- The enclave is not in init state (init =
  *				  before being started).
+ * * NE_ERR_INVALID_VCPU	- The slot was allocated with
+ *				  %NE_ENCLAVE_CPU_OVERCOMMIT_MODE and every id
+ *				  on @numa_node is taken.
  * * NE_ERR_NO_CPUS_AVAIL_IN_POOL - No CPUs available in the NE CPU pool on
  *				  @numa_node.
  * * NE_ERR_VCPU_INVALID_CPU_CORE - The core the pool handed back is outside
-- 
2.47.1


