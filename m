Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837EAC53200
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062776B0096; Sat, 25 Jul 2026 13:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F070A6B0098; Sat, 25 Jul 2026 13:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6776B0099; Sat, 25 Jul 2026 13:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B88A46B0096
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:21:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 334791C0943
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:58 +0000 (UTC)
X-FDA: 85027966716.26.D4F5B20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A315B10000A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:21:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gUjvw3Nw;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcJ0nQ8kdM2z71n3oAQxiS9jOdJPtLpFn1GyFRLutr8=;
	b=LYnGFDBzq9De6I8sJ7ZE2/Z/QmsLIp3QMfxBIrjForTzq42SL7hV3FyuNg0lFUtiROaYkc
	Xsm/1tIZEIEPqV8yPnhQX5Z+zYWEmzlXYPAW0IRANEwf0V8Tviy6Be01wcngDBwa2UO5Lz
	Q4Kq8lwC6CwllFxZ2azvVVZiDyaHpe0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gUjvw3Nw;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000116;
	b=QhTr4o9vPa6fWWKflkBHktUSYenO5JM18lWjzuPg0Kbw1PG3hOX46sizwsQu/RJj7yJrfh
	Fm2lOGIxWvw9dj5adAoboC4SGEiGr6fweuRzyKJsUMlls8fjIh4iBogD1CM0j2UmQRuUzM
	HKjzBpj5s7tjSUPYdxGxygV3q6tbJX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 510C360AA2;
	Sat, 25 Jul 2026 17:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D41F00A3F;
	Sat, 25 Jul 2026 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785000116;
	bh=RcJ0nQ8kdM2z71n3oAQxiS9jOdJPtLpFn1GyFRLutr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUjvw3NwOs4cPA8Ku5wlCO5nfCTS/tc/dOMfEN2LRy5Q7uAZNzI7+sM6X+g/YxdUL
	 o3fSnfECVorR5ydPD6NhHE0C88TXCnADNJQAh8MenEa9Lx3vd93/zE5JIRmZWiFd73
	 J8wQoFEB4Udj8s5SPZAxNxM4YWWKDPHCR3nLYNQqCEyWMijL4XBmHEVv/I4YhiSlux
	 W0JttGR/ltUF0EH8VztYA59ytBHUqOPJpuPJ9gxa17XkET3uZshEUx+8FgBJ/TLerh
	 6KFtAge/+ItzYblCFX2I2RljTiD63fBhy/qdGas3IZLS29k8tNO1cC+a8Xwso5RKOk
	 EP6HJNLUYiLEg==
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
Subject: [PATCH v4 04/21] kho: return virtual address of mem_map from kho_get_mem_map()
Date: Sat, 25 Jul 2026 19:21:04 +0200
Message-ID: <20260725172133.4018491-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
In-Reply-To: <20260725172133.4018491-1-pratyush@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A315B10000A
X-Rspam-User: 
X-Stat-Signature: e9z4na9hy418fc7x5jqyeugc66hr71pi
X-Rspamd-Server: rspam04
X-HE-Tag: 1785000116-746356
X-HE-Meta: U2FsdGVkX1/lX9dnI80Co3iaWNjp/N4SbZHylBrdFFZlLvcb+zLEIhSmz4QXEJ2x+zs7wjBXKCacnIPHFbpeMc09mBvn/50pLkt5QPB0/5Ldrz6/8DMCQBCEfWBQVOfV6VtAs1qZXr/lE//12DxsbstvCAi+SKdF5oh1j82SzRuEMW9PU4RLQNBA/OrtdnFWZ3qPA2YnUAW4qCyTWr/CnoGmQ4RGsTtZn1WiBXUNlXNkss2UtzXd8116NXPbq1Mak+KxXvpy6IfFYeMY8HYLZqAlvtxtMF2Ls3zwh7Kkflq6HjzbkCpsdTeEjYcgIbdGaTqWDCk2ubKDTM9ugwoiNAIJoRTygUH8a15DRm+VFVcFQ6YO2Y5O7NpuR4pFJgkFl/yzeIR86/cgNKgCpR3LPIHbMNoduY6hpGWAzsVWt3No25A5dH5JVHpo0nQF1wGQyS6a5WR5i70NGT1Gou9MzL6n5AUFy85Ia6YuxqVP/JTTvjfysLeCOhdqbhWaYYeSEGu1ENJQksQygi6LxSRJQrECs/KLsM3tdMzhtA6rYlg25A6da3A5tJDeqCTjiDPlAyCTeMxNrh8N953Dbv7Ga20WvRq13J1Pjp27SFSw6WOxCPGJSKk2Bi4oM6tke1DwLT4YW0IIbdqSq1odTxpaYHc01jfvK2zAE6or3WxOVhBDEIH+T0WCmcikWZu/tIeqtSCnfm6RuKZWQCWBAKbwLxTFMdRzSLzGMTaDrdyfNrIbQBRc0IrRXkCbmmIVpANsKAfBNTXmtLwEQC249Tb6eWv8f9X82cEBPiAfJuCKG4puHquuanGh6cEU8WGNYMiHeBxu6BN2s6KwlIK+UVRW6ihjjzi6qX95hpWWIxl6a9vnxqJHYqIoYq0huF653D4sYW5mM4pI05xS2aLTL0Zl3zCostbMY3lZDV5CwmcrG9w/PJ4c3iCId99E9X7lvknojexDZRrzClW4/9Zrje9
 kvqap+aO
 aWK9vJDGP3IAbZjN5nt6bYLuRe2KsV5VU/l7oJOF0ZB74ywtS5faQ2aFxsdDTAsK8j8s/33/Al9PAbZ+IBs3LLU3cmVvDeL1seeHgLXN6DOhQFeiwRkjZ/Y4JXGiYI9pHQZYMZ8emQyo5HoMqBWmMA4b0tpaQD1r5eEjgfS3TkXHV7DPJSa0cTuGz8OuN6vtbR83tYZrCiLhFGO98LS85FDkSsp7Is+3tmSUVkfDihkG1Zss67cdMbK4lghqFxyVZlXLs5zfoBWntPNbG5lFMg77UmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory map address is returned by
kho_get_mem_map_phys(). It is only used by kho_populate().
kho_populate() doesn't use the actual value. It only cares that the
address exists and is valid.

In coming patches, more callers will be added, all of which will need
the virtual address of the preserved memory map. Since kho_populate()
doesn't care about the actual value and only cares about validity, it
can also use the virtual address returned by kho_get_mem_map(). It only
needs to make sure the returned value is not NULL.

Rename kho_get_mem_map_phys() to kho_get_mem_map() and return the
virtual address of the preserved memory map.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e7451743b87e..5c35c11c273b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -512,19 +512,24 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory map\n");
-		return 0;
+		return NULL;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -1647,9 +1652,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
 	bool populated = false;
+	void *fdt = NULL;
 	int err;
 
 	/* Validate the input FDT */
@@ -1671,8 +1675,13 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	/*
+	 * At this point phys_to_virt() doesn't work properly and so
+	 * kho_get_mem_map() can return a pre-KASLR virtual address. But here we
+	 * only want to make sure the mem_map is valid so the actual value
+	 * doesn't matter as long as it isn't NULL.
+	 */
+	if (!kho_get_mem_map(fdt))
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.55.0.229.g6434b31f56-goog


