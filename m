Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62784F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9EEB6B0096; Fri,  6 Mar 2026 07:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F6B6B0098; Fri,  6 Mar 2026 07:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CCF6B0099; Fri,  6 Mar 2026 07:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7DF26B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:40:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74EE41B8125
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:07 +0000 (UTC)
X-FDA: 84515595654.06.45C5E2C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 887B1120004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pie+yQXJ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwwNaqrGZTaZUSJESBV+OjOZVYMTyVZCT2p3mgx1kQ4=;
	b=seDG+j0Yec+mHMFqtSNk0vIv/kKVwPJ1fkSVY2ZmKw3YBSgH1UGLYyr2ePm5QjQp+Jlsvh
	qrhnhGe9+vqUCVJvtSnfX+foQlULR+NVryA3y6RcG6PfZ5fDzN+HayKX8b/DRxmNZ5MG4r
	yXrMUT5XPsU5xSqgPMRroDaVhTI2GE0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=pie+yQXJ;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800805; a=rsa-sha256;
	cv=none;
	b=sB4nUsRtR/amJkZqInisUUkQBN7a6/avvfkFvFeMLqv9YOPZ+09USq/zdTea6zjYdmWCA1
	tp9Ck94A6mP4WIzzVVV2UrbwMoYdVaI/qZ6BMXfu9JX5qyZGvONqRgJfXZU5o0kh2nW6kS
	7q0wFDgXa05W0hfaMYh0BOoQM7VOj0M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=GwwNaqrGZTaZUSJESBV+OjOZVYMTyVZCT2p3mgx1kQ4=; b=pie+yQXJ4i7JiF+mtw4xNTlwLv
	tPfZLfMy1F2bjIlAbovXJawutSkZ5394R6mY4shJ5GIVMSdDGsirIVxQyqIvRD8kSGOq3THEsa0TN
	eud8Dk2TU2nxjLZEE593SNgP+PcwVjXteepLF3RKMdwJryb66EBb3qZXt0FDGTdCauIpMECeRbGZ9
	7mcJq4G37cG5/aZZWX065RAlxzcgQ6CMjESHhQs3d8xa+tYjpdEuc2Dx1sC/gXZvoKbs9kKt5n1WQ
	tyZtaoX6kYZBEjy4pwAcLDWwXYsYaV7xqcE3wFOHLxOq3BYiF7r6X5sAZalR2qC4dX+jn4oQtrrWc
	2xBC30MA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUTI-00HVRa-5v; Fri, 06 Mar 2026 12:40:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:24 -0800
Subject: [PATCH v7 5/6] kho: kexec-metadata: track previous kernel chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-5-404d14c188bb@debian.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
In-Reply-To: <20260306-kho-v7-0-404d14c188bb@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=6982; i=leitao@debian.org;
 h=from:subject:message-id; bh=K3p6Gosnlu/2JipzJi3Hi1uRbDEte28JJd8WF+OBUak=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssG1ehn7jF8aO5NgvyxPuT/6Fd8GCYAWYTvy
 LxwPvxp40yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bdfXD/0cTpXmbLuBH+gMxCkZYZ5dTEZaefYgCFtsxgb3WxPQ3D4bKkMBGcwGIzk+fR0M22BKEx5
 B5DK8nZvTY3igR4Op657Mzpk8IOnYGYrHKQ8EtYCrF24nCqZUQ4IHSyrKvtb1Q28vHb6HRAU+S3
 IVFSicl0eeUUIE4oOP1nKH8Nf4ui7lbAdCbyhv+xf6I2z3PxNUKI2h9ZF1HwjgzbdkBZd5m3Hqv
 tq8ZHwyaFxf3zS5jx2qpqyZNBegriBgrbRUrHpMph71Cit4XkYLuVJVyMuABNj/m70IOudl4uSG
 InoJB1+uRlS7XzQB80q57OiGLhBnSe89C6bcVRoT5legkE0ZMGXC2kb9Qkf7tWNjcZa9aQ5Y3F3
 OrvRZHt5ZmiCe+1bH2Gxqo8IkXLrh7hq7IQvHSHYINEg8KMu+WU/iMHluPPaksrGmcyCZ30AzvS
 BmIh080u6zizno8UWRWTWsegRM93513l1zeN86GoVJkDa+tod6Y/HnjdiMPdbwH/gfNUBN96DmK
 Jri3l27lN7fooiKLQPehU2/f4LoGfXSC7eT+ENDhzR33nRLCzLEd5aKZ9p5gF8IKjEXyyrdBNba
 LOfksk6LtTab+X3FhH5E5P+NQzn4lS8uU+wSJHgfvKE9xPmCIMCjulpiKzPCbpgR2tjMZ3Wz/PJ
 INJx4Kli1bx1+LQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 887B1120004
X-Rspamd-Server: rspam07
X-Stat-Signature: nheo8144o9y6e9hy1w31abozywra3cno
X-Rspam-User: 
X-HE-Tag: 1772800805-996396
X-HE-Meta: U2FsdGVkX19x2DXq76Fu+80c6WFc8G9Cy3L7ZfDVFiNjkXSojeaHGW0aZDTLc0bb+EM0ABJUysq4SldRPRQ4fBGGESrHiXKiOGee4eqYH57HJEEHA9cM9CWrqNOdr/oi7PRtvz5MxXLfuB05iqnzGUdxlfA+7vLV/Wu8cgl9awTlUag7U0LNVq6eixo9Vuul93qEdyT7Q13WHvOJU2bg6BVfQYSIx/utaT4hEM/HQ2qLTA2k0YqJ9UPi+a6DS1eOhZmQu1EnbUBDN8ksJK8tASC1rqB+ZP86U64iIJB7urzKP7CgNQewruQphjpKmf1G8J4SIzZsWPBUE+1GlLOBrhtMUMshILU1VH10mmvRAaFiMUisCDlFk6gRxM/HiIig6QLcD6v16AWlUuZ6ssrNZ9+ONfZOwkcmUveTFLzxmni2ln45akQ6dtGCO6o6Ln/rXrmfYeZMLknIPfnhQDJU/YmjgoEYrLhaYFTdv07TDtTjrRE2i3G+WjqRKCXDUK8MzfhvMvq159a95JwNKQA/O7KsK1q8GB/2kWr+Tgm+7AAkrGVgBxrifJc+qFXSOV5iiSM5ud9eKhFMWfsyfeB1fWBfdVrceMGtAVYw/Jufxgu0RTmhBN2SURqdzJhOAbIay4HhHw1TIBl2mxa0J+9Y8EuRO7brly00+1q0d52bXJZCpQ2GDrPUVce+5wz3rfdxGRhqFvskYBRk1RZ0obb0GAuScfzJNx5O0aEu2LE/jjY5R/YsH5yHdMukXkzB38P87ZMft8I9AiY8xOjBwmTYqHzibLRcGV1R5xxbOCENIvvJvfoAVkqHyhMBRFcAKfd9AQVao/WDmyvRrVgVFdZ3Ssj21VxkIDPBigRVX4hJvAn6l5SSy/iEAaK12CPR8Si9bHqJ3A2y57QJ2EGx/in15l0RNWRQ+7qRxiNx1XIcViwNS1OVD1yAy14Y+H+ZjTf/WUj+Xjvryzc26vn7tlK
 BCVKdwy5
 dqCDDGf2RzdIMYXlRKGtP7Sow+BtGz5EUNgMB/sBK07jUL2Kja00WcywtNxCxxUHV2IYhOH3dnF/CqC8agnExUZkMlNTtS8GSyG7r1dNIglzNxcLwtkgtMLmshvtu5LU02jLU6CZJT+gWU32eAmhy8+e1YuCkBRS5IXorAEwuXq9bMC66pk6c95skVo5OwYkQPvXmroF4tLK+csFNAlZlMwA0Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Kexec Handover (KHO) to pass the previous kernel's version string
and the number of kexec reboots since the last cold boot to the next
kernel, and print it at boot time.

Example output:
    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include the following commits:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently. At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only
occur in specific transition scenarios.

Implementation
==============

The kexec metadata is stored as a plain C struct (struct kho_kexec_metadata)
rather than FDT format, for simplicity and direct field access. It is
registered via kho_add_subtree() as a separate subtree, keeping it
independent from the core KHO ABI. This design choice:

 - Keeps the core KHO ABI minimal and stable
 - Allows the metadata format to evolve independently
 - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
   when the metadata format changes

The struct kho_metadata contains two fields:
 - previous_release: The kernel version that initiated the kexec
 - kexec_count: Number of kexec boots since last cold boot

On cold boot, kexec_count starts at 0 and increments with each kexec.
The count helps identify issues that only manifest after multiple
consecutive kexec reboots.

Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kho/abi/kexec_handover.h | 31 ++++++++++++++
 kernel/liveupdate/kexec_handover.c     | 75 ++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 15bf7a5be8cf1..16212f3659198 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -14,6 +14,7 @@
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/types.h>
+#include <linux/utsname.h>
 
 #include <asm/page.h>
 
@@ -101,6 +102,36 @@
 /* The FDT property for the size of preserved data blobs. */
 #define KHO_FDT_SUB_TREE_SIZE_PROP_NAME "blob-size"
 
+/**
+ * DOC: Kexec Metadata ABI
+ *
+ * The "kexec-metadata" subtree stores optional metadata about the kexec chain.
+ * It is registered via kho_add_subtree(), keeping it independent from the core
+ * KHO ABI. This allows the metadata format to evolve without affecting other
+ * KHO consumers.
+ *
+ * The metadata is stored as a plain C struct rather than FDT format for
+ * simplicity and direct field access.
+ */
+
+/**
+ * struct kho_kexec_metadata - Kexec metadata passed between kernels
+ * @previous_release: Kernel version string that initiated the kexec
+ * @kexec_count: Number of kexec boots since last cold boot
+ *
+ * This structure is preserved across kexec and allows the new kernel to
+ * identify which kernel it was booted from and how many kexec reboots
+ * have occurred.
+ *
+ * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
+ */
+struct kho_kexec_metadata {
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
+} __packed;
+
+#define KHO_METADATA_NODE_NAME "kexec-metadata"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e52615fdd5e4b..912199df3675f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
+#include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -1285,6 +1286,8 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1408,6 +1411,74 @@ static __init int kho_out_fdt_setup(void)
 	return err;
 }
 
+static void __init kho_in_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	phys_addr_t metadata_phys;
+	int err;
+
+	err = kho_retrieve_subtree(KHO_METADATA_NODE_NAME, &metadata_phys,
+				   NULL);
+	if (err)
+		/* This is fine, previous kernel didn't export metadata */
+		return;
+	metadata = phys_to_virt(metadata_phys);
+
+	/*
+	 * Copy data to the kernel structure that will persist during
+	 * kernel lifetime.
+	 */
+	kho_in.kexec_count = metadata->kexec_count;
+	strscpy(kho_in.previous_release, metadata->previous_release,
+		sizeof(kho_in.previous_release));
+
+	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
+					      kho_in.kexec_count);
+}
+
+/*
+ * Create kexec metadata to pass kernel version and boot count to the
+ * next kernel. This keeps the core KHO ABI minimal and allows the
+ * metadata format to evolve independently.
+ */
+static __init int kho_out_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	int err;
+
+	metadata = kho_alloc_preserve(sizeof(*metadata));
+	if (IS_ERR(metadata))
+		return PTR_ERR(metadata);
+
+	strscpy(metadata->previous_release, init_uts_ns.name.release,
+		sizeof(metadata->previous_release));
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	metadata->kexec_count = kho_in.kexec_count + 1;
+
+	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata,
+			      sizeof(*metadata));
+	if (err)
+		kho_unpreserve_free(metadata);
+
+	return err;
+}
+
+static int __init kho_kexec_metadata_init(const void *fdt)
+{
+	int err;
+
+	if (fdt)
+		kho_in_kexec_metadata();
+
+	/* Populate kexec metadata for the possible next kexec */
+	err = kho_out_kexec_metadata();
+	if (err)
+		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
+			err);
+
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	struct kho_radix_tree *tree = &kho_out.radix_tree;
@@ -1441,6 +1512,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;

-- 
2.47.3


