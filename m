Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC72CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208376B0095; Fri,  5 Jun 2026 14:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0246B0096; Fri,  5 Jun 2026 14:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D8B6B0098; Fri,  5 Jun 2026 14:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 051F96B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B69B91A0184
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:24 +0000 (UTC)
X-FDA: 84846711768.10.49CC969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E4D91C000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPgdUrBe;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684523;
	b=js91FRVxFeVEO0ilbc46IZytLRVW0Y6o/jZc3AjkPpG3coP3MXjbabyonFEihbg2wQwL7e
	x//QzszvnwWsV1XmOIkkVqtMYPyAqSlXs1L7PH4MqgDnrgtn/eNNe2L7ijI60R1uAs3HI6
	/neMp6vrHLBWlbtBIgqefJhJJ61pv0w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPgdUrBe;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/RGerRyxm8aTVCl41zoP38L2i7Ee87yOlG4ezqSjQo=;
	b=5ims/fvNjArOU37y7cTE+1CDPxIlrm4KKdXMVFySYOVcN/4BWaMxV7z4pq7yeuraRalaav
	x2U1LEdDQn1UR9XljdlrGBcUI+1HY2IfLbzzeRhlhClLFQfTa+a4CjHXdUJehkiaov4W8U
	7FzuO+Al3I9D6Ut/wf2vvWOyYufy6P8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EBC444277;
	Fri,  5 Jun 2026 18:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E09D1F00893;
	Fri,  5 Jun 2026 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684522;
	bh=v/RGerRyxm8aTVCl41zoP38L2i7Ee87yOlG4ezqSjQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPgdUrBersvdIeiDJvd3LrUzlJMbmXc7u1YjP1PjvngfbnOg1wTMed/fISSH2vkVk
	 eBSrWcyzbcOa0R9swpxLwaqTyUddu6ao3yUL8xKCDAN+N9Gp2VQqeXfynMFPggmv++
	 hMyo7fR3rde1IXG7mxJf3wKg9r9gOR/rJCgkI6xqG6n0sbmCkqc+B0kk/++ipOEwBF
	 F7lKau1V1WtMfkSYGEK6vZYrTjxT5GZtaxWGKT8dPb/DE3jaKX3IuvrYdl1M27/k8F
	 cwBxsx9XgdMuGiqDZMQ6GidAqfuioEjCuFMdGwOI1CaYau8zZ272Azz3K2wTHrBDDH
	 Mjp/oWSKjc6DQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/18] kho: store incoming radix tree in kho_in
Date: Fri,  5 Jun 2026 20:34:37 +0200
Message-ID: <20260605183501.3884950-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E4D91C000D
X-Stat-Signature: tj6d87tyaz4obi1s1bpya44bb44rbe3h
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780684522-344735
X-HE-Meta: U2FsdGVkX1/Ghb+GdJrKDQesyzP8lnDIoWBpghN86oef4uWrrrWENlgGaR80AZa4bn/3ZLSZ6/HFIABbV2NKt0feRIIKl0BAah/pNQ2uZD4nn5H1JcI5X4OBwrq92oPyPhr6hm0NwCpt03pNH5ccR/cyYJxxvrMoSCApJjdK4Fyf7GVGiIBACH+pwQaNTdPBvdcYy88TtrwDUbtfI0jwO4kuYxng2Dl/muW+i2V/5gS+OctyvaoCg8NJINvHvUET8AWcnA/DVXx1UneivbGsRL2JAX8KqdMO7KVKtk2u2cBoLchgIxvE+kBJLo+FMFPgC/843boIz2Rg6WfpSybk0zOWIY0wICkpqcHF41svAdzkY4EbmyGKaTvMpsiqeWqmY3R0L/osn5wU+KydWTMTwrktuQeBroC2VqBLIweau1UnYAnqtlSx4Ph9TGNyLsbRFK0Ihzm8YLYggZgGNnZ9BzWWYlqMCDmRakXq03sUwBN9FWAG0zL2nuaGoNn4gIc41ppCCDZKY+aQ3pwgxwj/0IW3+HeylzbV22hXHvIVUDdElHwHQn1kn/kDGx3vEe7HZ03L2JrBxCfzAC2JZCOqcU9NQmThGPSKBXJEGZ/01rSKdhF4fE5bcCB4YZlSWsb3UIBSn2Z/vQ0cNAlN+lNrI7ulMYqS6tY49DbV01A06cJ+41+XX4+x9V4IotOAVHk2djtsnaC+LTSrB7EtENB9sM51RgIssnXkuI39cnxT1kKGOqdrHkEIruxDQHaW9NO95DnvgUGEY0eNe3S7oOf4NdhpJGeWwsu1OtmpVJWE3pEO588hu2foXedVY9hM/dyIsZfgcSJys5Z+WcrfPce1t/IzfcOdt1fpvcLSuJ4+KNOzum692pNE86EaCq5XPdZSizIZSWImI68owF+F2hgYSLYAsWUGZfAD8wiyBLto2hjTFqN+vYVVC0oyvEPW5OKK1iDVqOF4+gD4e1mABqK
 grQLEj1h
 psxVPztRKT/7kIAQUvAV28twXUJvZixK5Zo4O+CUCULMs866rUsiLeOmBGHIz9XBzjfm703P2xWaMRFnS+hZabZ0WsaigIywhDVAxcWFvvm6CanaSwXwFew+p7kEHt1Tay2y4q0MXQ5F12tASROYTXREJjhaqS8tZn/+pPyrzxqWlxb636EqFMomyfilB4DLhL77g663PZXxd114V6mdBrs4c5j0itHLtxFfj+LYU7xitW709LK1lX4vvLO418b5xfOz9XbdDuFEbHDX1ro+i/2wL9A==
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
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d8dd0ede4f87..61e436f5077e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1334,6 +1334,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1413,24 +1414,15 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
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
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.scratch_phys, which stops memory
+	 * retrieval.
+	 */
+	kho_in.radix_tree.root = kho_get_mem_map(fdt);
+	mutex_init(&kho_in.radix_tree.lock);
+	return kho_radix_walk_tree(&kho_in.radix_tree,
+				   kho_preserved_memory_reserve);
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1637,8 +1629,10 @@ void __init kho_memory_init(void)
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
2.54.0.1032.g2f8565e1d1-goog


