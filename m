Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68397606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=V98/qDqw
Received: by kanga.kvack.org (Postfix)
	id 737C56B05B4; Wed, 11 Nov 2026 18:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F026B05B7; Wed, 11 Nov 2026 18:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626386B05B9; Wed, 11 Nov 2026 18:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 364F46B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:01:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBD4B140464
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:01:35 +0000 (UTC)
X-FDA: 85424361750.30.8893882
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6A9E120015
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:01:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="V98/qDqw";
	spf=pass (imf29.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXtmYIrfPivQz7FmakInhnYFI+uktb0W76Paq4YTuo8=;
	b=fz14Cvv8vbtYmxL7N4G/4EpNbhvQVqgUP0R0iLPw5JnbWqTnHgCl00Nl7u1/mN5ql5lJ1Z
	KbOFyiCgzO6ZGUQfrgmVBQtQ1B7s5Eq6DRdAOI0Zy7OeOXaxaoek2iCSf6Pjq6rRCgL8lQ
	FOrrmsm8HebIXKKHwgaGlzwQaiJg72s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438093;
	b=jJAeQjeMpaPPj3IuGmKkieau3Yf2zioFQx4/JTno32xtJm4vbIlLFxSiQR43otGgvWRwdQ
	wnKWBWjc/yGSaAK7+kW/Isgirn70XpfnknK3HDUrrFUxKe1UjH8E2sbuqKQ/MLqHLhsoDl
	FxX80a2wAWNfq9jCbZBAOxl0n9w5DpU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="V98/qDqw";
	spf=pass (imf29.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438092; x=1825974092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GXtmYIrfPivQz7FmakInhnYFI+uktb0W76Paq4YTuo8=;
  b=V98/qDqwmWMQwDSruxJ6X+WxddEpFNwo2CJthRklPp/0IuYIH9Sc891P
   wNCQrM8nXIEmsBNtV/JVO9G1JH0p0iyNQ5gD1Tj4INkeQTBhT4FFeyLqw
   VwB7ZivIvZDCrp1V6O9lw+h5wPqPyiTSwiS4UaFMoh2haGF3Cm6BzCzjg
   cPWJjop+IQDjCw4CwkUVe4eGvSr4jQJxfLjgCTFnXYid/EJZCrmnKV/02
   wFlq7Xkhz9SkfSFQyzRpPco/7bK4QMZsg54ghoOPF5c9wg6ull+tOIWkx
   2tegPELL+5C+UaQcY1c1tBH0dHg2AJnILlvGe1oFitlWsMkDgWVazULPA
   A==;
X-CSE-ConnectionGUID: 9drxTOTsQwyc1weMq2Ey1w==
X-CSE-MsgGUID: n7+vjtjPQvevBFUbDMxJdQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33678373"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:01:31 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:5815]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id a1e45171-b7a8-43b1-a8a4-8be601ccfb00; Wed, 11 Nov 2026 23:01:31 +0000 (UTC)
X-Farcaster-Flow-ID: a1e45171-b7a8-43b1-a8a4-8be601ccfb00
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:01:30 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:01:28 +0000
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
Subject: [PATCH 18/40] nitro_enclaves: Donate memory for the slot pool
Date: Wed, 11 Nov 2026 22:59:22 +0000
Message-ID: <5ad724cf5ed725a38ee73d501ebe2d26d1d40d2c.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jto9zs13a9bj69kummnow713tdq6f1kh
X-Rspamd-Queue-Id: B6A9E120015
X-Rspam-User: 
X-HE-Tag: 1794438092-161697
X-HE-Meta: U2FsdGVkX1/85LYvM3jB89k4s12b0B1/tg1wHvrJZxdzbzWFpUrEeZotXKojQYC9kxSbGuJGUS3ezyBFHxTR3XSR6n7oQC3IKVjv52JZpg4D1SnnprjFn7cbX+r6UFKYHHM4IdxYizCU1owNXpIClrmkZxfAlf+LXNGqR/CUkz2ywX/+GTC4Ka+YhZaqsnHil/LxndZ/+gNc8KukiTq8lNv43povUKjVPchUln1w0yMyKkKB5fGRDbEt/tM6yAxHxl1fbAmRqRN5M7ygzo/d62N/l/8y5a1dH4YNxBbBcoFF+JzhFZVk6ti/yGuJVJXU/owoBuwrLJ52ur61GVh/+SR6iJNU4xm4/zH5vnLbGUrOWroJiSd+l7LvV54+raHflVSxZMpQltwiDh8H07y59KgFS6jNMhLjqG/scOlLhSfuNtNnks54Wy6bT0VVgfimvRvbxxrUo25j5C4QHvQcxMS/S8m8e22We6qQsBjbK79jcYnTD7ZkacdmRwHxlgV8k+BtvFP/eBWhagsom4W7y/Br2rfWy3cdlUg8DX+MEpywHxbqqceIWSv1pt5EyS4SKmKH9RLpSQ2AMUhv8WzvKlrNiWxAdFc5K/B9MN6vWb8aY8+nn5vvBuI3onnjLeDSbqPOx98ZGGcwJbGBZJxaleNkk/Aw79IaHneX0OYTO+5X4a/QSJlBAF9ji5IjqkOHs3Yn5I7LH0COHO4jJa02odOxyRGHR2FZniz4kVWFDpG2doe0Dns2SHvu4R8PQnA6yGtzjca04RFwOQkGzQU8mgdtgTSAtKklB0mkd23xBboGrH79o1Lqk7k/BArmSWwgpgOL/10jW1W8v8ZKVSW0uPF9tp0+RXnk444tAUzn4VXG1ih6bScB5ldZVPedG3zzKQNn5mDLaxeTadEjbbIGXJK0S0mccX0F3pP8ET0yvTj/+pVRitk0LVdSbfzOULhVvwCt8k7432uo8TGmTDs
 xHHgPTdd
 WnsfSIUIZbLc698SE/QEa53MEws9SYYeJWNiRxBS0Fe+CQX2gMZRg6YmxFY6YKfiW9fSNfmCpvGXF8XZ/njg2Wt7+JzzJ1KegfOo1MnQUqB4dxf7tOz+Snsog5lD6m+Djjb1FPXpNn3qqa00EngW7czhpwmbbzGIX/OpfCIAHazVckdmKwJKDDzmN2YHIJgr9vAm2ajtqRzr6Qhu8bJVufPwr++/DDLNBIZWpPqttESOlmQxhHqRKLUxbL8cs/62MMg7npumue6+mByje74UvnRQN/JyjqiO5d9M+KEdkE+9q8KPlLRS2ZqbqqE/ElRHAR/X48Ps+Q7+fVfWtPzVVtCDQv+U+4swsP68zVe7LWZxyIvYTr11YN0xV+bppkc9x44JPTLV5B1s3R1jo444+RhTeqx3hAnim7bVkTGuiACowZG6dLivJW4FIM7BFdb2fdwvjz8i4Mg0lJgf9+7SN1eUYoW+gR76Q42rVXCnPHLnPsqctDsnAYNqoStR8/LrCxzKxg16oWN7/JVkq3bqsYUKx6Xv6CZrPKDW8+guSViO6HaZ17T3sT95nn41oW9uVA5YdGEDLGEEpNwzZs2EorJGUie/uTNrFcvvy1Paxc7yEaFFXSAHhF3F4a2nfnOtBFTohWHuEbcOrbdfPCWV8A33wdScJngCbOUQzmmePTCv5huBLPDqivYFcOKDiO0lo2Y5/FP/nI1cHEsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To launch the first Nitro Sandbox, the parent must donate memory to the
device. So at probe, on a device whose vendor-specific PCI capability
reports a slot pool, donate the base run and one donation of
NE_SLOT_POOL_GRAN_SIZE bytes from ne_alloc_contig().

The device holds a donated page until SLOT_POOL_SHUTDOWN, which it
refuses while a slot is in use. So remove, shutdown and a probe that
fails after donating first run ne_enclave_free_slot() on every enclave
and then take the pool back, before any page goes to the allocator. That
way the device stays usable after an unbind or a kexec with enclaves
running. Like the two free commands, SLOT_POOL_SHUTDOWN waits for
pci_dev_mutex even for a process that is being killed. This teardown
runs on every device, and a slot the device confirms as free lets the
driver release the memory and CPUs of a classic enclave too, once its
file is closed. ENCLAVE_STOP now goes out in any state, because an
enclave that exited may still be scrubbed, and the device answers a stop
for a slot that never started as well.

An enclave whose slot was freed that way gives its CPUs back on close,
so count the enclaves created from the CPU pool and refuse to replace
the pool while the count is not zero. A donation that got no answer
stays recorded as donated, because the device may take it.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |  53 +++-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |   7 +
 drivers/virt/nitro_enclaves/ne_pci_dev.c  | 334 +++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  25 ++
 4 files changed, 401 insertions(+), 18 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 77b15eda8d120..2fae731acb977 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -201,6 +201,11 @@ static const struct kernel_param *ne_cpus_kp;
  *				and leaves when the enclave is freed, in
  *				the same two places that move the core out of
  *				and back into @avail_threads_per_core.
+ * @nr_enclaves:			How many enclaves were created from the pool and
+ *				have not been freed yet, whether or not they are
+ *				on the list of a device. The pool is not replaced
+ *				while any is, so the cores an enclave gives back
+ *				go back to the pool they came from.
  */
 struct ne_cpu_pool {
 	cpumask_var_t	*avail_threads_per_core;
@@ -211,6 +216,7 @@ struct ne_cpu_pool {
 	cpumask_var_t	*node_cpus;
 	struct cpumask	total_cpus;
 	struct cpumask	used_cpus;
+	unsigned int	nr_enclaves;
 };
 
 static struct ne_cpu_pool ne_cpu_pool = {
@@ -931,6 +937,7 @@ static int ne_replace_cpu_pool(const char *val, const struct kernel_param *kp)
 	cpumask_var_t cpu_pool;
 	cpumask_var_t old_pool;
 	struct ne_pci_dev *ne_pci_dev = NULL;
+	unsigned int nr_enclaves = 0;
 	int rc = -EINVAL;
 
 	if (!zalloc_cpumask_var(&cpu_pool, GFP_KERNEL))
@@ -961,7 +968,11 @@ static int ne_replace_cpu_pool(const char *val, const struct kernel_param *kp)
 			goto unlock_devs;
 	}
 
-	if (ne_pci_dev && !list_empty(&ne_pci_dev->enclaves_list)) {
+	mutex_lock(&ne_cpu_pool.mutex);
+	nr_enclaves = ne_cpu_pool.nr_enclaves;
+	mutex_unlock(&ne_cpu_pool.mutex);
+
+	if (nr_enclaves) {
 		pr_err("%s: The CPU pool is used by enclave(s)\n", ne_misc_dev.name);
 
 		rc = -EPERM;
@@ -2293,6 +2304,8 @@ static void ne_enclave_remove_all_vcpu_id_entries(struct ne_enclave *ne_enclave)
 	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)
 		free_cpumask_var(ne_enclave->threads_per_core[i]);
 
+	ne_cpu_pool.nr_enclaves--;
+
 	mutex_unlock(&ne_cpu_pool.mutex);
 
 	kfree(ne_enclave->threads_per_core);
@@ -2337,8 +2350,8 @@ static void ne_pci_dev_remove_enclave_entry(struct ne_enclave *ne_enclave,
  * * 0 once the device has freed the slot.
  * * Negative return value on failure.
  */
-static int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
-				struct ne_enclave *ne_enclave)
+int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
+			 struct ne_enclave *ne_enclave)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	struct enclave_stop_req enclave_stop_request = {};
@@ -2346,17 +2359,20 @@ static int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
 	struct pci_dev *pdev = ne_pci_dev->pdev;
 	int rc;
 
-	if (ne_enclave->state != NE_STATE_INIT && ne_enclave->state != NE_STATE_STOPPED) {
-		enclave_stop_request.slot_uid = ne_enclave->slot_uid;
+	/*
+	 * An enclave that exited may still be scrubbed, so the stop goes out
+	 * whatever the state, and the device answers it once the slot is
+	 * neither running nor being scrubbed.
+	 */
+	enclave_stop_request.slot_uid = ne_enclave->slot_uid;
 
-		rc = ne_do_request(pdev, ENCLAVE_STOP,
-				   &enclave_stop_request, sizeof(enclave_stop_request),
-				   &cmd_reply, sizeof(cmd_reply));
-		if (rc < 0)
-			return rc;
+	rc = ne_do_request(pdev, ENCLAVE_STOP,
+			   &enclave_stop_request, sizeof(enclave_stop_request),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0)
+		return rc;
 
-		memset(&cmd_reply, 0, sizeof(cmd_reply));
-	}
+	memset(&cmd_reply, 0, sizeof(cmd_reply));
 
 	slot_free_req.slot_uid = ne_enclave->slot_uid;
 
@@ -2416,10 +2432,13 @@ static int ne_enclave_release(struct inode *inode, struct file *file)
 	/*
 	 * The device the enclave was created on is gone, and with it the only
 	 * party that can confirm that the slot no longer uses its memory and
-	 * its CPUs, so the enclave keeps both.
+	 * its CPUs, so the enclave keeps both, unless the device freed the
+	 * slot before it went away.
 	 */
 	if (ne_enclave->detached) {
-		rc = -ENODEV;
+		rc = ne_enclave->slot_freed ? 0 : -ENODEV;
+		if (!rc)
+			ne_enclave_free(ne_enclave);
 
 		goto unlock_devs;
 	}
@@ -2525,7 +2544,7 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 	 * capability. One without it takes no launch flags and would allocate a
 	 * slot without the properties they ask for.
 	 */
-	if (flags && !pci_find_capability(ne_pci_dev->pdev, PCI_CAP_ID_VNDR)) {
+	if (flags && !ne_pci_dev->has_vendor_cap) {
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Device takes no launch flags\n");
 
@@ -2630,6 +2649,10 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 
 	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
 
+	mutex_lock(&ne_cpu_pool.mutex);
+	ne_cpu_pool.nr_enclaves++;
+	mutex_unlock(&ne_cpu_pool.mutex);
+
 	if (copy_to_user(slot_uid, &ne_enclave->slot_uid, sizeof(ne_enclave->slot_uid))) {
 		/*
 		 * As we're holding the only reference to 'enclave_file', fput()
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index d0d1973bfbe9d..59374a35c3c7d 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -116,6 +116,9 @@ struct ne_mem_region {
  * @enclave_info_mutex :	Mutex for accessing this internal state.
  * @detached:			The NE PCI device the enclave was created on is
  *				gone. Written with ne_devs.lock held for writing.
+ * @slot_freed:			The device freed the slot of a detached enclave
+ *				before it went away. Written with ne_devs.lock
+ *				held for writing.
  * @contig_regions_list:	List of %NE_ALLOC_MEMORY allocations given to the
  *				enclave with %NE_ADD_MEMORY_REGION.
  * @enclave_list_entry :	Entry in the list of created enclaves.
@@ -157,6 +160,7 @@ struct ne_mem_region {
 struct ne_enclave {
 	struct mutex		enclave_info_mutex;
 	bool			detached;
+	bool			slot_freed;
 	struct list_head	contig_regions_list;
 	struct list_head	enclave_list_entry;
 	wait_queue_head_t	eventq;
@@ -221,6 +225,9 @@ void ne_contig_free_run(struct cma *cma, struct page *page,
 /* Nitro Enclaves (NE) data structure for keeping refs to the NE misc and PCI devices. */
 extern struct ne_devs ne_devs;
 
+int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
+			 struct ne_enclave *ne_enclave);
+
 int ne_cpu_pool_sysfs_init(void);
 void ne_cpu_pool_sysfs_exit(void);
 
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 8ed2349dea878..e42be1742a39c 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -7,14 +7,20 @@
  * DOC: Nitro Enclaves (NE) PCI device driver.
  */
 
+#include <linux/cma.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/iopoll.h>
+#include <linux/jiffies.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/nitro_enclaves.h>
 #include <linux/pci.h>
+#include <linux/sizes.h>
+#include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 
@@ -211,10 +217,11 @@ int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
 	/*
 	 * Use this mutex so that the PCI device handles one command request at
 	 * a time. A slot being freed can hold it for minutes, so let a task
-	 * that waits for it be killed, unless the task frees a slot itself:
-	 * release has to do that for a process that is being killed too.
+	 * that waits for it be killed, unless the task frees a slot or takes
+	 * the slot pool back: release and unbind have to finish those for a
+	 * process that is being killed too.
 	 */
-	if (ne_cmd_frees_slot(cmd_type)) {
+	if (ne_cmd_frees_slot(cmd_type) || cmd_type == SLOT_POOL_SHUTDOWN) {
 		mutex_lock(&ne_pci_dev->pci_dev_mutex);
 	} else {
 		rc = mutex_lock_killable(&ne_pci_dev->pci_dev_mutex);
@@ -609,6 +616,14 @@ static void ne_pci_dev_disable(struct pci_dev *pdev)
  *				  goes away.
  * @ne_pci_dev:	Private data associated with the PCI device.
  *
+ * A device with a slot pool refuses SLOT_POOL_SHUTDOWN while one of its slots
+ * is in use, and the pages it was donated would stay with it. Each enclave is
+ * therefore stopped and its slot freed here, before ne_slot_pool_release()
+ * runs, the same way as on release. An enclave gives its memory and CPUs back
+ * when its file is released, if the device freed its slot here. An enclave
+ * whose file is already gone is one the device did not free on release, and
+ * it keeps both.
+ *
  * Context: Process context. This function is called with ne_devs.lock held
  *	    for writing.
  */
@@ -625,6 +640,7 @@ static void ne_pci_dev_detach_enclaves(struct ne_pci_dev *ne_pci_dev)
 
 		mutex_lock(&ne_enclave->enclave_info_mutex);
 
+		ne_enclave->slot_freed = !ne_enclave_free_slot(ne_pci_dev, ne_enclave);
 		ne_enclave->detached = true;
 		ne_enclave->has_event = true;
 
@@ -636,6 +652,281 @@ static void ne_pci_dev_detach_enclaves(struct ne_pci_dev *ne_pci_dev)
 	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
 }
 
+/**
+ * ne_slot_pool_read_geometry() - Read how much memory the slot pool wants.
+ * @pdev:	PCI device to read the slot pool registers of.
+ *
+ * The slot pool registers only exist on a device that publishes a
+ * vendor-specific capability, so a device without one keeps a zero ceiling and
+ * reads no slot pool register at all. A device that stores its slot
+ * descriptors itself reports a zero ceiling and the driver donates nothing to
+ * it. A device that asks for parent memory is only usable if it asks in units
+ * the driver can allocate, so a granularity other than 2 MiB leaves the
+ * ceiling at zero as well.
+ *
+ * Context: Process context.
+ */
+static void ne_slot_pool_read_geometry(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	u32 size, align;
+
+	if (!ne_pci_dev->has_vendor_cap)
+		return;
+
+	ne_pci_dev->slot_pool_max = ioread16(ne_pci_dev->iomem_base + NE_SLOT_POOL_MAX);
+	if (!ne_pci_dev->slot_pool_max)
+		return;
+
+	size = ioread32(ne_pci_dev->iomem_base + NE_SLOT_POOL_GRAN_SIZE);
+	align = ioread32(ne_pci_dev->iomem_base + NE_SLOT_POOL_GRAN_ALIGN);
+	if (size != SZ_2M || align != SZ_2M) {
+		dev_dbg(&pdev->dev, "Slot pool granularity size=%u align=%u unusable\n",
+			size, align);
+
+		ne_pci_dev->slot_pool_max = 0;
+
+		return;
+	}
+
+	ne_pci_dev->slot_pool_gran = size;
+}
+
+/**
+ * ne_slot_pool_donate_base() - Donate the base run of the slot pool.
+ * @pdev:	PCI device to donate to.
+ *
+ * The device turns down a donation to the slot pool until it has the base
+ * run, so the base run is donated before any other donation. Donating a
+ * second time is a no-op.
+ *
+ * A donation the device never answered was submitted with the run's physical
+ * address in it, so the run is recorded as donated and left to
+ * ne_slot_pool_release() rather than given back.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ * Return:
+ * * 0 on success or if the base run has already been donated.
+ * * Negative return value on failure.
+ * * -ETIMEDOUT, or any other code ne_request_unanswered() names, if the
+ *   request went unanswered, in which case the run stays recorded as donated
+ *   because the driver cannot establish that the device refused it. A device
+ *   that answers such a code itself lands here too and costs one held run.
+ */
+static int ne_slot_pool_donate_base(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct slot_pool_donate_req donate_req = {};
+	struct cma *cma = NULL;
+	unsigned long nr_pages;
+	struct page *page;
+	u32 size;
+	int rc;
+
+	if (ne_pci_dev->slot_pool_base_page)
+		return 0;
+
+	size = ioread32(ne_pci_dev->iomem_base + NE_SLOT_POOL_BASE_SIZE);
+	if (!size || !IS_ALIGNED(size, PAGE_SIZE)) {
+		dev_warn(&pdev->dev, "Slot pool base size=%u unusable\n", size);
+
+		return -EOPNOTSUPP;
+	}
+
+	nr_pages = size >> PAGE_SHIFT;
+
+	page = ne_alloc_contig(nr_pages, numa_node_id(), &cma);
+	if (IS_ERR_OR_NULL(page)) {
+		rc = page ? PTR_ERR(page) : -ENOMEM;
+
+		dev_warn(&pdev->dev,
+			 "Slot pool base size=%u not allocated on node %d [rc=%d]\n",
+			 size, numa_node_id(), rc);
+
+		return rc;
+	}
+
+	donate_req.paddr = page_to_phys(page);
+
+	rc = ne_do_request(pdev, SLOT_POOL_BASE_DONATE,
+			   &donate_req, sizeof(donate_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev, "Error in slot pool base donate [rc=%d]\n",
+				    rc);
+
+		/*
+		 * A request the device never answered was submitted with the
+		 * run's physical address in it, and there is nothing to cancel
+		 * it with, so the device may take the run yet.
+		 * ne_request_unanswered() picks out that case. Record the run as
+		 * donated, so that ne_slot_pool_release() owns it from here the
+		 * way it owns a donation the device accepted. The errors left
+		 * over say the device answered to refuse the donation, or never
+		 * saw it, and the run is the parent's again.
+		 */
+		if (ne_request_unanswered(rc)) {
+			ne_pci_dev->slot_pool_base_page = page;
+			ne_pci_dev->slot_pool_base_cma = cma;
+			ne_pci_dev->slot_pool_base_nr_pages = nr_pages;
+		} else {
+			ne_contig_free_run(cma, page, nr_pages);
+		}
+
+		return rc;
+	}
+
+	ne_pci_dev->slot_pool_base_page = page;
+	ne_pci_dev->slot_pool_base_cma = cma;
+	ne_pci_dev->slot_pool_base_nr_pages = nr_pages;
+
+	return 0;
+}
+
+/**
+ * ne_slot_pool_donate() - Donate one granularity of pages to the slot pool.
+ * @pdev:	PCI device to donate to.
+ *
+ * A donation raises the number of slots the pool has room for, up to the
+ * ceiling the device reports, and a pool that has reached that ceiling takes no
+ * further donation.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ * Return:
+ * * 0 on success.
+ * * -ENOSPC if the pool has reached the ceiling the device reports.
+ * * Negative return value on failure.
+ * * -ETIMEDOUT, or any other code ne_request_unanswered() names, if the
+ *   request went unanswered, in which case the run stays recorded as donated
+ *   because the driver cannot establish that the device refused it. A device
+ *   that answers such a code itself lands here too and costs one held run.
+ */
+static int ne_slot_pool_donate(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct slot_pool_donate_req donate_req = {};
+	struct cma *cma = NULL;
+	unsigned long nr_pages;
+	struct page *page;
+	int rc;
+
+	if (ne_pci_dev->slot_pool_page)
+		return 0;
+
+	if (!ne_pci_dev->slot_pool_gran)
+		return -EOPNOTSUPP;
+
+	if (ioread16(ne_pci_dev->iomem_base + NE_SLOT_POOL_LIMIT) >=
+	    ne_pci_dev->slot_pool_max)
+		return -ENOSPC;
+
+	nr_pages = ne_pci_dev->slot_pool_gran >> PAGE_SHIFT;
+
+	page = ne_alloc_contig(nr_pages, numa_node_id(), &cma);
+	if (IS_ERR_OR_NULL(page)) {
+		rc = page ? PTR_ERR(page) : -ENOMEM;
+
+		dev_warn(&pdev->dev,
+			 "Slot pool granularity size=%u not allocated on node %d [rc=%d]\n",
+			 ne_pci_dev->slot_pool_gran, numa_node_id(), rc);
+
+		return rc;
+	}
+
+	donate_req.paddr = page_to_phys(page);
+
+	rc = ne_do_request(pdev, SLOT_POOL_DONATE,
+			   &donate_req, sizeof(donate_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev, "Error in slot pool donate [rc=%d]\n", rc);
+
+		/*
+		 * Record a run whose donation went unanswered as donated
+		 * instead of giving it back, as ne_slot_pool_donate_base()
+		 * does and for the same reason.
+		 */
+		if (ne_request_unanswered(rc)) {
+			ne_pci_dev->slot_pool_page = page;
+			ne_pci_dev->slot_pool_cma = cma;
+		} else {
+			ne_contig_free_run(cma, page, nr_pages);
+		}
+
+		return rc;
+	}
+
+	ne_pci_dev->slot_pool_page = page;
+	ne_pci_dev->slot_pool_cma = cma;
+
+	return 0;
+}
+
+/**
+ * ne_slot_pool_release() - Take the whole slot pool back from the device.
+ * @pdev:	PCI device to take the pool back from.
+ *
+ * The device keeps a slot's descriptor in a page the parent donated, and
+ * SLOT_POOL_SHUTDOWN names no slot, so a pool taken back while the device still
+ * has a slot is parent memory the device goes on writing after the allocator has
+ * handed it to somebody else. ne_pci_dev_detach_enclaves() frees the slot of
+ * every enclave before this runs, and the device refuses SLOT_POOL_SHUTDOWN
+ * while a slot it would not free is still in use. A SLOT_POOL_SHUTDOWN that
+ * fails leaves the pages with the device whatever the failure was: a refusal
+ * means the device still has the pool, and an answer that never came means it
+ * may still have it.
+ *
+ * A donation that was never answered is recorded as donated, and the pages stay
+ * with the device: ne_do_request() sends no command after one that went
+ * unanswered, so SLOT_POOL_SHUTDOWN fails as well.
+ *
+ * Context: Process context.
+ */
+static void ne_slot_pool_release(struct pci_dev *pdev)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct slot_pool_shutdown_req shutdown_req = {};
+	int rc;
+
+	if (!ne_pci_dev->slot_pool_base_page)
+		return;
+
+	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+	rc = ne_do_request(pdev, SLOT_POOL_SHUTDOWN,
+			   &shutdown_req, sizeof(shutdown_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error in slot pool shutdown [rc=%d]\n", rc);
+
+		goto unlock_mutex;
+	}
+
+	if (ne_pci_dev->slot_pool_page) {
+		ne_contig_free_run(ne_pci_dev->slot_pool_cma,
+				   ne_pci_dev->slot_pool_page,
+				   ne_pci_dev->slot_pool_gran >> PAGE_SHIFT);
+
+		ne_pci_dev->slot_pool_page = NULL;
+		ne_pci_dev->slot_pool_cma = NULL;
+	}
+
+	ne_contig_free_run(ne_pci_dev->slot_pool_base_cma,
+			   ne_pci_dev->slot_pool_base_page,
+			   ne_pci_dev->slot_pool_base_nr_pages);
+
+	ne_pci_dev->slot_pool_base_page = NULL;
+	ne_pci_dev->slot_pool_base_cma = NULL;
+
+unlock_mutex:
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+}
+
 /**
  * ne_pci_probe() - Probe function for the NE PCI device.
  * @pdev:	PCI device to match with the NE PCI driver.
@@ -689,6 +980,15 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&ne_pci_dev->pci_dev_mutex);
 	ne_pci_dev->pdev = pdev;
 
+	/*
+	 * The registers past the command interface only exist on a device that
+	 * publishes a vendor-specific capability, and a read of a register the
+	 * device does not implement has no defined value. The answer holds for
+	 * the life of the device, so look it up once here.
+	 */
+	ne_pci_dev->has_vendor_cap =
+		pci_find_capability(pdev, PCI_CAP_ID_VNDR) != 0;
+
 	rc = ne_setup_msix(pdev);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Error in pci dev msix setup [rc=%d]\n", rc);
@@ -721,6 +1021,29 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ne_devs.ne_pci_dev = ne_pci_dev;
 
+	ne_slot_pool_read_geometry(pdev);
+
+	if (ne_pci_dev->slot_pool_max) {
+		const char *stage;
+
+		mutex_lock(&ne_pci_dev->enclaves_list_mutex);
+
+		rc = ne_slot_pool_donate_base(pdev);
+		if (rc < 0) {
+			stage = "base";
+		} else {
+			rc = ne_slot_pool_donate(pdev);
+			stage = "granularity";
+		}
+
+		mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+		if (rc < 0)
+			dev_warn(&pdev->dev,
+				 "No slot donated to the slot pool [stage=%s rc=%d]\n",
+				 stage, rc);
+	}
+
 	rc = misc_register(ne_devs.ne_misc_dev);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Error in misc dev register [rc=%d]\n", rc);
@@ -745,6 +1068,7 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ne_pci_dev_detach_enclaves(ne_pci_dev);
 	misc_deregister(ne_devs.ne_misc_dev);
 disable_ne_pci_dev:
+	ne_slot_pool_release(pdev);
 	ne_devs.ne_pci_dev = NULL;
 unlock_ne_devs:
 	up_write(&ne_devs.lock);
@@ -782,6 +1106,8 @@ static void ne_pci_remove(struct pci_dev *pdev)
 
 	misc_deregister(ne_devs.ne_misc_dev);
 
+	ne_slot_pool_release(pdev);
+
 	ne_devs.ne_pci_dev = NULL;
 
 	ne_pci_dev_disable(pdev);
@@ -822,6 +1148,8 @@ static void ne_pci_shutdown(struct pci_dev *pdev)
 
 	misc_deregister(ne_devs.ne_misc_dev);
 
+	ne_slot_pool_release(pdev);
+
 	ne_devs.ne_pci_dev = NULL;
 
 	ne_pci_dev_disable(pdev);
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index e651e74ab656e..4e991c4b0e70f 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -433,10 +433,27 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.state) == 64);
  *				triggered by the Nitro Hypervisor which require
  *				enclave state scanning and propagation to the
  *				enclave process.
+ * @has_vendor_cap:		Whether the PCI device publishes a vendor-specific
+ *				capability, and with it the registers past the
+ *				command interface.
  * @iomem_base :		MMIO region of the PCI device.
  * @notify_work:		Work item for every received out-of-band event.
  * @pci_dev_mutex:		Mutex for accessing the PCI device MMIO space.
  * @pdev:			PCI device data structure.
+ * @slot_pool_max:		Highest number of slots the device lets the slot
+ *				pool grow to, zero on a device that takes no
+ *				donation.
+ * @slot_pool_gran:		Size, in bytes, of one donation to the slot pool.
+ *				Written once at probe, before any donation is
+ *				made, so a later reader of it sees the size the
+ *				donation was allocated with.
+ * @slot_pool_base_page:	First page of the base donation, NULL until it
+ *				has been made.
+ * @slot_pool_base_cma:		CMA area the base donation came from.
+ * @slot_pool_base_nr_pages:	Number of pages in the base donation.
+ * @slot_pool_page:		First page of the donation to the slot pool, NULL
+ *				until it has been made.
+ * @slot_pool_cma:		CMA area the donation came from.
  */
 struct ne_pci_dev {
 	atomic_t		cmd_reply_avail;
@@ -445,10 +462,18 @@ struct ne_pci_dev {
 	struct list_head	enclaves_list;
 	struct mutex		enclaves_list_mutex;
 	struct workqueue_struct	*event_wq;
+	bool			has_vendor_cap;
 	void __iomem		*iomem_base;
 	struct work_struct	notify_work;
 	struct mutex		pci_dev_mutex;
 	struct pci_dev		*pdev;
+	u16			slot_pool_max;
+	u32			slot_pool_gran;
+	struct page		*slot_pool_base_page;
+	struct cma		*slot_pool_base_cma;
+	unsigned long		slot_pool_base_nr_pages;
+	struct page		*slot_pool_page;
+	struct cma		*slot_pool_cma;
 };
 
 /* Whether a failure left a submitted request in flight. */
-- 
2.47.1


