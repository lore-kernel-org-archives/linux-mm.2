Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1109C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670EE6B015C; Wed, 29 Jul 2026 10:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648D36B015E; Wed, 29 Jul 2026 10:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538AE6B015F; Wed, 29 Jul 2026 10:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 200BD6B015C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEB051A06C1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:37 +0000 (UTC)
X-FDA: 85042115634.07.E6EDF09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B452C000E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ii4IyRWa;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336996;
	b=QaCSLZ5fcxADO7cZ+F6Q1kuXtX++/qf8AZ++HFwQv8B1s8jnOP2JzYQ4V5g9bSMh+cskmF
	wh7nowTFpjBqx0pZ6w7Ts9H3DUrQgOgL9uzxwEMi48Gc/jKcfiGLy6jA2wkKmbV5iLfFd9
	s14sVz0kA9L2dvP34hOIRhKGBnUPGWc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ii4IyRWa;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTy/SpRQxcylZAnkn90gwM+/FxNJUgUwYPXcYuU5Nao=;
	b=ATcUA2xTPhV93b/r/uaA2/0xMgSQqdCtwNYyxMoB6znyGXjwhIH51oZYMpNVoqDTriFHDC
	KAOpNGMiM165zMmfCreXIqhKW9V0IDnmc0CttpjirM1IxZrtW9ylOsYLzvYctU5mGxvK0g
	3Js6ZY7KCxEzCWx55wNBFmdGIFxB/L8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3256600B1;
	Wed, 29 Jul 2026 14:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D60F1F000E9;
	Wed, 29 Jul 2026 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336995;
	bh=sTy/SpRQxcylZAnkn90gwM+/FxNJUgUwYPXcYuU5Nao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ii4IyRWamnD4g01J74AwqlKxIWkrynFmn2QcQrVimnYszo5BagrZ+L7mELuEY9Czd
	 irDaDWViQz/i/SJE6duuT+9iqZvBovpVPSjxhr4D7nM33E8sRrTjpD3hPkOHJNAwmI
	 E7PcaU6r37Vy8OeBfQc/8K/UyoSl4JXa6oymUsCPdgD7ZP+jtX2IaX/hWoOl8f11m/
	 O25E6yCG3N4cLRKc5LiqCASvm4OeBDIJkIkAXERC7J5NJw3UF1sCC1vtI1Ew5tqAKo
	 7jwx+GyTQDC2snYdndIkRMoMBi+wXAUbrs+jL8p7m7gTuNnN9lW66oqpAL07a/sVRo
	 1ofFWUSw+x9CA==
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
Subject: [PATCH v5 05/22] kho: store incoming radix tree in kho_in
Date: Wed, 29 Jul 2026 16:55:50 +0200
Message-ID: <20260729145610.2827231-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: khtd4qep4jiqth7jjeuor76njm4o6mgy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B452C000E
X-Rspam-User: 
X-HE-Tag: 1785336996-572022
X-HE-Meta: U2FsdGVkX1907wHyscVXTHkd+bKTHwqqYZAGHUbQd9uDuEDnoClxxfByW2lSrPvFTWesxPfmbbW+7gHnb7YTQjexUQsIS9d3qaiYyzSFEjF4gi2Ywhk0g5KVbsAs55Z8aTJkfMM+HHQz1jagjt9Mzk+CQzW1PvD/2dMKEDbV+fHLxtJYz8KMeXPHxDRVMR3zCtMeNQgYtFyA9Jip8Op7Enrp1mIupFASzmvUGOXPIl33U7lD3Lg30LOEkOFCi6s5MpJ4WUJeNYabbNyTJpDzavVUnJnLPiMUByis6Wc/56crOuZzTHyVIXwr8IRHPJMUeFtFqROKxIpWTehfFlHy5B3q8gAAnBZqeNRyS7DdKtmk6HUtQwH4JIgVEaDY74iO/NtMngYie1BlkmAZt8+YSPIeV7EnlyQp7Il9efHf8kKm4qBNJhOJpfXs8wQ93l78lUNr5kayI2gtsEDtSnZfalvcpb1mkr3nok0wagqaM+6/yeafrf9chdPjY/nyfuwfAWKXup4yVw4sp/bWp68SFGnpfGA71AI9taI6h8xqZQbMFcASSnYom+fy/Ff3PYHkdldB0JSZyFHsDHCyn/z2Idk0XQYBcKANc3Td9tr9tNKBeL0E/5+R6b7hTjq3BDajgiZ+RSXWV/79Y6S9QoIIYCZLJvXPHI5tS1ipuBIJoxwbFQt395hKKgXHqplhCzSIo7wDHLBjG5+tAUg18KHgxDOvNgS6WUSdCBTEWjIFkOyvmB1MFg+dCj7GyJCLpfIemNE3nVqlelaYlebuG0J4ayn99sxHAwEXla6jyF8lJGkqMpRt0Z9GzqQLrhuZ0V+Zn1jwghLABoFpYKASwNm3B93n0zeY+77Ct4s7OT0a9KhXAaI/MUwY1toiKGJu6G5x474w7Zi/iNvKyQi51DSzoXV+UdwHqI+HfOTHxWl4zssONuKiZT5sVgVjyVDhSZQO5r9vH1jHYQ9dRacGqB+
 2hHNa95K
 ZR7Th1IFnl4+4nXV+nl4ycScmXUsd8ar3PgU//baTs1qHmtFJ+M9mE/LjAHuejMh0YgKxn0mLlZuezm5dXPIplLGxK7WvZoW3GGUTQWHc1x1LE3actG0ed50vxunzjrfGCg9VXxz8P94+zQYnqUi0LX6qkAgTiWmaQNnPxftTldn4KTkLO7I8tF+KwJSVbpKxqQBMd+VxFp+I7t5tmCFsv/n9CC2yW977tWS8ybhJXJUaolqP2C5UKDh7QYD2zB8wJu9sRvQbMH3Ckrrss61gpWQiEw==
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
index 5c35c11c273b..b53ae68ca087 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1337,6 +1337,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1416,24 +1417,15 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
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
@@ -1640,8 +1632,10 @@ void __init kho_memory_init(void)
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
2.55.0.508.g3f0d502094-goog


