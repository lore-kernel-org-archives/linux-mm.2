Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACCFD2F036
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00F96B008C; Tue, 27 Jan 2026 09:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A086B0092; Tue, 27 Jan 2026 09:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A3B6B0093; Tue, 27 Jan 2026 09:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B91A26B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 218D41A01D6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:43 +0000 (UTC)
X-FDA: 84378000126.21.F88DA99
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35369C0019
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Kv+FXLSZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCDrOXcJNIUfA28QBY/Owm5GFq3or2BPQOrG06isADg=;
	b=xtCG5UJBBkESyCYUCQU54d9dd1euuJJa/IKqiEApM1UP8BOYbKNoSTXHwikJUG2j2j7lXP
	fbI+XhmbOCg2KRRzFUMWBQ2pNMXn9Bax0F6ydkNDINcl2NMvWgZYLBDrUmGVWHemHwXeL6
	OdeRfXcE6a7xU/+YuPKHHTlYpxPf7ds=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Kv+FXLSZ;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524721; a=rsa-sha256;
	cv=none;
	b=YgXVR/i2rGoVmHRqj2bd+1oxXuGADICTAlxzgl8PBGiT0V5rz4Ko1D3smX/JON1oa/RMpk
	/BkuLb/swoWdq063OZBULwmKghtOJB+62BLpj2/io2IbczbRNZnuiMOtEUU+s0ADLftYb2
	VFefWiaOWJp0/5o4DqFDUnHn2HiyUPw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=WCDrOXcJNIUfA28QBY/Owm5GFq3or2BPQOrG06isADg=; b=Kv+FXLSZi0fznOq91r7SJpnC5c
	ud13k5oJi/1nOUb8YSMYnd86laupStHGGBWS4EYmg6meRbjpY7YhkQoz7wA6Ur7iQ1tMtMdJGVdM9
	3RM8L1xtUWLOWg0CILu8IyWK63Sz5kMmDAzpP9weRKdTC+C8pXQ7waT1avt7PKHfQc5pJNs/3zonU
	oS/NFBU/8JxjT1ncriO6gAxE4wiw6QrJoQdB59FMJv0ZmaIMRM0y5cDzS40NaMWIUMKdc1jQYJ4KU
	87JwD7htbMwuvWQP452GNwC2XVvSe++iueARbQ3IKkIyclklthvyLudhpEUW4j6xpymNIDM+Tmqpe
	+xUKxz7A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkkDC-00H3bU-LB; Tue, 27 Jan 2026 14:38:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 27 Jan 2026 06:37:38 -0800
Subject: [PATCH v6 3/4] kho: kexec-metadata: track previous kernel chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260127-kho-v6-3-56f9396681c2@debian.org>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
In-Reply-To: <20260127-kho-v6-0-56f9396681c2@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=6803; i=leitao@debian.org;
 h=from:subject:message-id; bh=nQ2uJqVyCqxIH+d/C38pFSbZu9SALipnEqB+BOtpe4I=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpeM3XMQqiaQEGS46c/oC8zoYAv/xv47rnqZFNg
 X/ScosTcJOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXjN1wAKCRA1o5Of/Hh3
 bTs+D/9upN5s5as9HokxaKKzABdgEi0BVl36KQlDVYbTry9AaBO5IfnFzDtiztekRFW+uK3sNRD
 LMTrUDvj6o7fCuG4ZA2N+NltXwNLNfq8woQ1zbNFUxetg9lVY4W/6y5/OGjc0aEMOxVu1X/eWzk
 yqyXsV4ZBLLeuMGw3rnkHPgTHnOoOIBYbxkaeuPiSPBJbRm2r/QuGhKMh6BC9OO63Do8l3IvLLy
 7KNdLFQ9SAL5/V9zNJaOk99wsVKcIY5vt+8MYVKCikq+y2KtsOOlbNLeP4Ep7u6kZ7PC84syEs7
 35Rsmk20CTJYIq2DrfNBedP7x6uMWVF9I0nSyhpGRl5kbidUExDkUNJfJsaFeP65JdcF95/iC15
 WAl5nwCUM97HZUgv+WDC9QQ0JTG6h7o3DrELZh7kQqOr4VvEEt/fXCzGLvCV5jgEwV7Cq3qIe1L
 hBy2q0BxXjWH7J4oH/7bjwBTTFU+9rnNSCClFgUMU33BnHBZIV1siAUDm8yXYkOY2BCUJphvJYZ
 wnUTwk7mL2387r0IVeDaHNK1YSQ45shWjsgim8AU+IRxjqCbdIwMevJaKNFlh/BpypJkyQSclgM
 lGWxYpQ0fhtKOziuRV9TPMtj//gvplPLfkWJYzd6FaYjzl79/6yPB8HOE+EtJAPd6ZWmcD4Eqsr
 Mz/KAmOC6JKNdFw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 35369C0019
X-Rspamd-Server: rspam07
X-Stat-Signature: 87r7q9ckkptephqfrkbb6h455fpgss1h
X-HE-Tag: 1769524720-394473
X-HE-Meta: U2FsdGVkX1/jSKlYfvwPEOegdd9Rp5weiwVAKGt5oUoBzy1xcJxg9+I6ShNIPBnaFAhcmcnM09Igb2cw9svHXIAMWs6DHcGuoqXbWvvYV9TyhMyUXvMcQEhtbJltoTzOTPRnTwBr2ojP91GWCYeYFjoB1v1C9gPR2DV/y8lnF3S5BHwebTZLkAdeIEK+1vDe7PktX9zLyubDZ7KtFH9eHuB1odVr7mttIr4XeR/5hadhNe+kFUT1GvzjCbME/w3Q7z1kUAqldafDKQRcMJ383xf/s5YrQnwgwS41QK/UOzQTN/3BDucBxEMAMdI4mXSmZ7PODRHidklYVcT6VjzfPrKVSgRtX2Wr5Vqq187pnajmjWcmXQNXROCYoVbg5PkRHUCfH7xgtdZm/UVjhb0MVhcCz5QD/3WPlRCx1g/4YJAmAbqP2HcTc5p45Hy5HU1tJPpzs9zskthV7EeMY/ErTT/3m+5LYqV1QeQuToePmhPkpxGuABXmQp7JuNvWudXLg4Ox96Ze0fenXkeW4wK3mxtUoLQlSQyPImbFJjAuu4bvYr+yQAa/1HUZoHGpt4ozsyd4HooX2q+EOfQGRlFvGlxC1ogVVvxurrSMb+cTiU/fxoxJt5NnjX2xSNO2j/8o3IKZFp+vqpGjan0z7RyP4H3p10VtQ4/8ZnwxVnKgJpeL7CME/15Pfgglui00mRJQXeWgAxx8c8VYzQ8Oz5wQ7S4jv3aq1Gh22JaUFs+PAeEjoI2vHqJwm2cZNXDZ4iOq2UQ3r2bIGiwV3Wd3Cy8+/p538tplI3qehrYEsYIoX81YCJMbJ4YyJOpPNi1gc9EJDh7BnWVX2L7kqIbbAptltbH/amBJYuVzfKMT4MST0d36nn+/pQW6nWH0Q2vXPuiGHWkHLpxabG2j8FQ4BCYmJ+PWR/vnCrrMYPoVZRfwm5JTI+3nNsZrn8fAyrhsd1IeT4qa0xIiCN0FuaEzpO0
 azR8w5DF
 ArVQ1qmODPzeNrN/5XsttfUYd05JD4u848v4YIPLhco/bpiyVwuRRmF088Qh9NK/UJOsi6ljX/JnwIIQZfi+J6EcgSsk8q0jomJdOnNJoKadComHDRT0DNbjTz5S5h0qbJkX8i2HliNBuMNMTtWi9iCJWlxWxz9wSp3n26Hb7VQDl0EDxXz50HtEOIjVsvvSh8LzRGIGZ9hVYHPGvvdboXHF9XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 kernel/liveupdate/kexec_handover.c     | 74 ++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 2201a0d2c159a..f41576eed7cbd 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -11,6 +11,7 @@
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
 #include <linux/types.h>
+#include <linux/utsname.h>
 
 /**
  * DOC: Kexec Handover ABI
@@ -84,6 +85,36 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
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
index e87f77e43acef..ae31380936b09 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -1268,6 +1269,8 @@ struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1353,6 +1356,73 @@ static __init int kho_out_fdt_setup(void)
 	return err;
 }
 
+static void __init kho_in_kexec_metadata(void)
+{
+	struct kho_kexec_metadata *metadata;
+	phys_addr_t metadata_phys;
+	int err;
+
+	err = kho_retrieve_subtree(KHO_METADATA_NODE_NAME, &metadata_phys);
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
 	const void *fdt = kho_get_fdt();
@@ -1379,6 +1449,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;

-- 
2.47.3


