Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362ABD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9CB6B008C; Mon, 26 Jan 2026 11:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3D76B0092; Mon, 26 Jan 2026 11:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869016B0093; Mon, 26 Jan 2026 11:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 799D76B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:08:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 223FE13BB02
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:08 +0000 (UTC)
X-FDA: 84374596656.07.E8A8904
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 20F952001C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=f87Wmtga
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rELLbr3n1mvaAH8Jb6foKISzoRm/h7jGZezo/WIwGx8=;
	b=QxQr4nXeyLfYqoKx8PpPYx3Nf9atHBvz0Auo7wai9pNqJgr4BG0XQ/mMzB97b5w6ertNFs
	tHlT9DtJM5AMVfzJAP1OA5NeBp3MkEw9sKNNCLHxAwKCXp0COl66GVz8sI1O9/lH/8Eg7F
	8IXpt40KOsAK54XZdFoI5n/mJl1cNpk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=f87Wmtga;
	spf=none (imf03.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769443686; a=rsa-sha256;
	cv=none;
	b=pnf3yZTQHj0PwEZiA3Vh7KqYsY/U5uTJ4PUW52uwHh+E2M9KHSwiLSoenqvatCcxu/Wc7v
	SOR8BpmE8PoNQYyn37zmmh6Z10RQ3vc5a7BoT5HSBFnS4RmvXaHuMiKz5N3mAYNPq6RNE/
	Kul2vps5ufuBiIqBoVk8VNWncVVZf3g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=rELLbr3n1mvaAH8Jb6foKISzoRm/h7jGZezo/WIwGx8=; b=f87WmtgafJ0nCAUDS9JncRQhly
	cVhSmx5ZJ1zv07ks7ALi3SmIkaE7y3Uq+MCrYJBD6irqIiDQsqjQjYCVptBxjcgguaPyY0NF4MSys
	FIoY3zLhGiWWz6kwwakMPw7jGock4KmUjaX2ewEqqxJjPYLQKIp7QAtFw9tUJYkegYuPF67QC4pMf
	L3mahJc/rfFXQRpu0+l8wCrfsFyGfg5lTg7UxoeryoSsaGdaF8nnMhE9q5/dBNyby+ZU045T7k0IS
	ZozTEA0fqau9HTsATYbncc8Y8Qnvt1erqxTOB3YTcGtEfSKGpkrmQIX3/xnoQX+sHB2N1lstskr5r
	fn+T/VJw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkP8D-00GI7Y-0t; Mon, 26 Jan 2026 16:08:01 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 26 Jan 2026 08:07:25 -0800
Subject: [PATCH v5 3/4] kho: kexec-metadata: track previous kernel chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-kho-v5-3-7cd0f69ab204@debian.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
In-Reply-To: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=6745; i=leitao@debian.org;
 h=from:subject:message-id; bh=RkXHBAO2rWRvBZyOTvq+Rsg40/Yaxfq39GNC5H2Vd/4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpd5FNIOtcvaP+mCzRl5ihLA/uECxANnIMeuoIs
 jaAi/aC+dWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXeRTQAKCRA1o5Of/Hh3
 bWkwD/9l0X8jRNd7k1f9D4OM79/4D9vU14dyIwNlQ7/N8I6GGW2nZTR9d6X6XO1yDSoOTsZsGZ9
 TboWX6xqPcIa1VArLdsBJssMemFV0LycOlUnvxGYjA/IkDap1V5hX36tW6A/Ho2VwZ/jgu+Ljl3
 Lfo6MKMMuhSN9XgDFQilN03iQlpJ5cuWULi7G1xiDp7zlah8Lbu40s+Lb2ON5oWyUeZ0DlB2nan
 BAy86Dxz4d6jVuUEdPVc29dJkc2prYctqky680xfm+UviFyUQ+pnixD7NxN2WdhWsr33yOFm8Ls
 kX/itqBS/sk+bcRwvaKt6uT3IIEquKC25y938o39tqxQ6SO6aS54TqZHgx7JNvtfI1quQSGy6z9
 mN8E3bWUwHMhuUndFYp0tUHMf8a6awq9bOv42jfmBpPHQD3wLcY4XRJ5599zwxjED9uBFflRlrs
 i9f0s/ZMbK+DFkWYa17RdBuLs8UOepoptAQfUQq3WKvLPmw+ei53aVQhzNhHsVhHRt7CipfyYMf
 5gW8INgMjkrpGWHaX1SAF43sQuQvue6bAhD0axh/RoRI1YlqpW6ccItEn3RPbWDSQnQ/6N4lr6t
 LSNFL4zGQkI9/I9+t3sZCZg7AGf3g+20W1DnUkUvNDiyhQQy/wbkzyX0SkTjq5Gdl3JTzNgoVan
 9AxGTm/fhR2oxhg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: trmk4dpxhfuwd4mbque8z7e391hmdyxa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20F952001C
X-HE-Tag: 1769443685-800608
X-HE-Meta: U2FsdGVkX18+wnoD+H/7i+eze1DKPK73A/53wYkpHKoIPJHNTbNNZVBS7BIBtOfC3dF1AdhvjKbC3c754YrcXf+lzFDgKQieAf3xs2I8bmZeoBTN3GBFSf3oS0vWYQlx1sm6nqvFklwm23alwEQUNoMf2r+qAx3rUCXQ+QyasBW6QvVv9JA1jo1f+mwRwdtwbURd1b43OmBL9u4k1wGHpdowNFuetMp6JfGXO4fUwoODYbQReKH/yQ4M2q8pJ98hm87N2VibhxaoZHIc2+8YDjqPVJKdrmUZbUh4lx6pksv+RXZ7KCsqooj/fb4HERBzAvl7/M8mtnO07oryQUj1vYCxyNF8JdbnStIk4WlYH5F0eJKrZ/AEM73rIoj4oW5bUtzlrGfgSw+8f1SaSZbXYVqovlqg9igg4hlKDfMsGpR8kVag4wUI2ID8OHnLSVH9FkEdkdj+EFaIFZOxAS2lztECgMLjcs4QO13O3s9UKBL+bq1lkRZCDc1NWTGZZbn2Js29xoJI/nNhbogV21hNw/ShRk71xUEvU3OLYctwsTfLTxzxNZOFFlGMDi/gCGE/WbslLVAZ7k5H4ZCACMrR9E5kDz1nb44t9Wmr2fGitTXj9cw4PJmq0Wf6Nh17uvHDqr7xmLcAbgwzL39mcIIguxsdPEqfGK1641Xsko8j3iPzTA4+5a9Ocj+G6FIqWZF8tkq4CE1cBxbY8yAlLRKoV9KjD/WO4+d0hvb54tkAQtiG+m2GTx8uvyb0omJo8dCDJvCiThAFV5ogdp0/6px7YKKyJxr3GiYtphQM+bZSVURgPg2lJrrzZTHjfX76znFB/ffnfmri8xoEfpfQUVc7eUugHp7QVyP4pnwM1coPgeI7ubObNKplaKHEIst0CYl/gtA9WxyXFWkLln2YAXC1ufGim9S7nqkhNahMNW8EvjZ1GhS2wRMkIUsUg5cAGZAnUraa4FPlsoCQZg6inVC
 JFdDSRqr
 OI5NzGAxppuSnXrTufyL492mlZM+8biZonoCX6tR3cL7OvinHa14V4LtwRwn1RHSCmyE/kDAXlPIDFHKzSFj/jeACS9OiX/NbIi3jDc3Ny0qfMxvnTOb5SgWtO5fmhrHd0LMwvcmm+jruqm/G2spA5Rbg9/sghJ8z3JYmJqYw1snh5mILS8sakHvxbxMTmzByqKk7TsGpJKA0nDiVOKHUuiOZ+g==
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

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
 include/linux/kho/abi/kexec_handover.h | 31 ++++++++++++++
 kernel/liveupdate/kexec_handover.c     | 74 ++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 2201a0d2c159a..1f017756e9991 100644
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
+ * __NEW_UTS_LEN is part of UAPI, so it safe to use it in here.
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
index b1f3222a0052a..8250f318c4f69 100644
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
@@ -1267,6 +1268,8 @@ struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1352,6 +1355,73 @@ static __init int kho_out_fdt_setup(void)
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
@@ -1378,6 +1448,10 @@ static __init int kho_init(void)
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


