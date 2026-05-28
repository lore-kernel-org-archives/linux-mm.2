Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2FF3CD6E48
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E3B6B008A; Wed, 27 May 2026 20:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8646B008C; Wed, 27 May 2026 20:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6C46B0092; Wed, 27 May 2026 20:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3906B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0F2A1C1D55
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:23 +0000 (UTC)
X-FDA: 84814977366.01.93A2839
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 41F331C000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=ZN1P3v+l;
	spf=pass (imf20.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKAx22lWxLJue3lv4E7ReRPFqkYia7qQaQqFWyZIB0M=;
	b=TgMS1F7c3pe5Qpg7CaBzRfE7YS9A3PpdCOcQThUxG+DYYXuYbIGgXo6Tspj8QbmLVhAEE+
	rqDKKRifK3vdHT1xacjmYcdR4S/PASHMWHq/5MffMcIK7fTnehMxAMY3IKOJGIdZ6f/M4x
	6M04rCQW4ELeB4OXOys6PH60ZtVlaRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928942; a=rsa-sha256;
	cv=none;
	b=PlX2GhCArN7IGyqovHuwUV465/P2A0eBPR7CGewfRGdWSV4yV4C7zInZcB9vZ0JvToptq2
	v8CN+vyvlO57BMAMr1kH/dRAoxS2Yy5lNB7g8JA7hGDq5yCo+MfjPflwDDqBqPH7uKf+nZ
	9bObdAVuxBbyHavsemNRdZrRI+lK0ZQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=ZN1P3v+l;
	spf=pass (imf20.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id B1F4120B7168; Wed, 27 May 2026 17:42:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B1F4120B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928930;
	bh=LKAx22lWxLJue3lv4E7ReRPFqkYia7qQaQqFWyZIB0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN1P3v+l0l+8H7iUXRv97ioZfzLcRX5n2BYCalc4XdQfTzJzKsHBTrAS0twFrefA8
	 y3xxufxwz7rIT/66eIP31Y9hKq1h/ZzHxFhA8MhuvEc8jD494fnLG7T2/fZ4LRe2Zo
	 aXK3PrcOYS79OZiEXyZiptW3VLQOYjZTY7wCjKnc=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 02/20] kho: store incoming radix tree in kho_in
Date: Wed, 27 May 2026 17:41:44 -0700
Message-ID: <20260528004204.1484584-3-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 41F331C000A
X-Stat-Signature: w93juxzgmayim6jgrtgyr7yruazcp43g
X-Rspamd-Server: rspam06
X-HE-Tag: 1779928942-839942
X-HE-Meta: U2FsdGVkX1/yb4qKhNG5xICIYZQSOZO9HvgyPgzBZSTtwZhI0/gunCfYaXeI12JuLqzWvQ0D7HT8gNF32bn1rPMnNB586aIM4B28yY+AqYWCgb+4baSJ8hMmjdkhmluZ+HX0yUyWK+PgAp9oBHull75w/JR2eODpk6Ta6uldY+IbzlOWfw8bgaZXbo8MxwgWwNBes572yrZdFHNbZSby64U/lCzzmBGRLiVWDQw9U3PCbnriM7p1I42HiuIZTjTIyaLNF3Qs/6UW6BrLAoN5+jsVHW7zDgb4/Ix4ONsuV/Ci4fYw+gkXtgKLDpZ71FLyNU/s+b/BC/PIwcfDFWqr7Q2mEiQFdd7pCaFaNI3ALqUkB1sQsB44gCCDTFuNcwTdhD912+ADxPdV8tM13cr3qFNhdcAggjI8S93SGYAFQLjZaCAe3y5HOIyF1P57czvtpcdCgXRGyk9wJI0AtSmGvcRgGUZLZGhWjgD+rQrbLnHzKgBAMiuHfm0PRW7Qr2Ywpk9ljkjkP663cuZi7iR8fBXsrGK0jv3dmD+yvnmL+fQn1CO65UkkdegmU3Wq6rgnpkpsDQU4xy8Vj175omTmr9UWY28Hqi4E1kg/a8XDoa3IirF97Atxy/9vRhsVCWc8SoE1kdEbBzI/UTeOMk4DHZG5yl25K8Nnvs1ZqPGLNfODIBuf/wbvEJ5B3gmW6qAcH2fi/l8tRrQiM37N8yv29yF09wmwkzO21fpa0y0PcNtjnFEwYGnTiwfiXFPDoZlOwEt8EtYgvgYAeVZRLe36GvT9IPD9mysoTcuPrARDqhhiVwHg7n9G2wdHwKaMEVRGJtmDyxo33LW6jt8SrguIWIAAlZ6B8Y+WwPhzPmDZ7+eYvff40Bh9+xE9cPKQsWxz0LDz8h0SNvDK/fHXSXhlLZVCpfjamsZOXVOQrigxi7VHjfcNo+lOj6+CVmBWzH1acqGZxkwJT+c2jQ5fzL8
 nHdWy8wj
 gBu8PsmtB2bRo6+Ovnw1vIoE03VSMO2aQD/fVlguaIfeeQMajmipO19Jw7NNuRjTmhQ4WPvqVWTdAxPS2dWVXEWVm4kA9EPYC5lZoWgo9OqpsXAFtPaRe6s5KmxNL0UMDVDl0OFCHP3mLsYB53olnlvWUqGcFWAZx5M6fA9i/EEjgHc6a945utBikdOumuJA7VPcenle4147gnd61dfbfuHxYPumIVU0PKy2sfmNgpfvMFSl+4wGu3qcCHEqd++eSgfAulcT3wdjPJK/Dj5gRhwTpCqteCjo+rPgm6l0GOh3gjY8TA1d3dTDF+B8RKN2IrzVp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

This allows other functions to also use the radix tree. While at it,
also use kho_get_mem_map_phys() instead of duplicating the code to get
the radix tree root from the FDT.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 05a6eb56e176..afc986845839 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1316,6 +1316,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1395,24 +1396,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static int __init kho_mem_retrieve(const void *fdt)
 {
-	struct kho_radix_tree tree;
-	const phys_addr_t *mem;
-	int len;
-
-	/* Retrieve the KHO radix tree from passed-in FDT. */
-	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-
-	if (!mem || len != sizeof(*mem)) {
-		pr_err("failed to get preserved KHO memory tree\n");
-		return -ENOENT;
-	}
-
-	if (!*mem)
-		return -EINVAL;
-
-	tree.root = phys_to_virt(*mem);
-	mutex_init(&tree.lock);
-	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
+	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
+	mutex_init(&kho_in.radix_tree.lock);
+	return kho_radix_walk_tree(&kho_in.radix_tree,
+				   kho_preserved_memory_reserve);
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1619,8 +1606,10 @@ void __init kho_memory_init(void)
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 
-		if (kho_mem_retrieve(kho_get_fdt()))
+		if (kho_mem_retrieve(kho_get_fdt())) {
 			kho_in.fdt_phys = 0;
+			kho_in.radix_tree.root = NULL;
+		}
 	} else {
 		kho_reserve_scratch();
 	}
-- 
2.43.0


