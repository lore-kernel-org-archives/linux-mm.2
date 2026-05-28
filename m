Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0CF9CD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662146B009F; Wed, 27 May 2026 20:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5775B6B00A1; Wed, 27 May 2026 20:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3544F6B00A0; Wed, 27 May 2026 20:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5566B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C90451A06A5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:31 +0000 (UTC)
X-FDA: 84814977702.15.3430700
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F7854000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=TVD5iDMu;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj1bXneZ/55tRiLo5BAzxpY6ql7Nf0vxqaPwBTnufbI=;
	b=MTOmYuBmhrlyd0eMTBE7wGBlb+IzO8SO9+4wWpLcFj3KJ8H1JUr9BbmuLa8dYhKIIljfoG
	9XHvM9P78a2jHgncU0/PYwJ25o2PWIoHWiGXe02qCeFqBR9MPQI4sWSKay8SZ7GeA66jC3
	PiNP71TRSx3TbnjOlxxFRzcNcGydhS8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=TVD5iDMu;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928950; a=rsa-sha256;
	cv=none;
	b=pBnVDJrNftzS09eu349vPWr6fBdIAfK0LPqeWOu+rdvLzhbQRmmZBXDHzn38EImbLa6UTa
	J4DjPkpDqZFU3JZmX+zFOuApIb9b4SHOiR+/zh50m+InXLyBBHlsdcUhd2dLnyTzMulMkJ
	pYCL49dDGHYNzVVx7RoEXloyYwwUpsw=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 64DB520B716C; Wed, 27 May 2026 17:42:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 64DB520B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928939;
	bh=Cj1bXneZ/55tRiLo5BAzxpY6ql7Nf0vxqaPwBTnufbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVD5iDMuv1UMsOEX1EG/iFjlf91oQMKN2LoYjUOo5nEjdyljMNqJgNV7wWGJ/8Qo6
	 5jP/DnRsCNWlUzVNF0PNicBBpFHThFLyoOnlrxBrSEzFz7uMGjvNku8H40fMJG2Hjp
	 BTlo58HNqDBNYl99jnK6sq2MEYieIsoPsIEgiGk8=
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
Subject: [RFC PATCH 11/20] kho: return virtual address of mem_map
Date: Wed, 27 May 2026 17:41:53 -0700
Message-ID: <20260528004204.1484584-12-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F7854000D
X-Stat-Signature: rcxnr4kdwj6uw9og8b6te47nbgfbexxk
X-Rspam-User: 
X-HE-Tag: 1779928950-650480
X-HE-Meta: U2FsdGVkX1+oLT/j4QfmA+xVZ1nbLz9KSu9vldjwcTa1a0IMYFlpQzd4hAXGXYUhr62605P24Gul0AyIAlkZeHD6vlkP8FWDSNdP289782geTUKD5j6T+Px72D1MJOaSzvmAQhcrMIUuA0hbtODrxUD8U9rErgxblgjID4M7TIZnoX0UHfDyPRpWvpU4L93l0LD6woz0CrcTlO9X8bEl2Spiaxc1GIPjWOxSIOuHsGOpA79cX4JVgQiusUbvLXyVGY5V4eKsQyXK5LO14EEmi+q8SfdMjRj5lypfWoQJgXx9ZiKLJ4FzvQsdXxF2D4jOBE/CCSqLkWZoEpZeTEv4cQX7LvLGbkomiIQX8uA45lQrVfRSmo06l92tBcooLWdyqvHQ/Gg2RKBOSM/7TWAKRwzTF9rJswBIBSuSXN92aHCP+n5E48B/rmK8BHHaKH7CgVDqcKcKyTrc7RBw8+aabXSvj7PMxxO8MxFVKDWDyCsvOv9xempZRgqFUar/wrGL9ba/1pb4lec5AztOTu5jzPRK8tM/fU1w8o6hwB4KpFoXtN4qhjUYiBjuWSL/w9wytmwVPn6d8xKL0IkxOJtt1I1I3fII/9C3FszxLCvRbnltRjrE5bqQGlKd9KBJnaPxBmiv68s8oJWJBwC14H3LnKt8sM67dfTo9kQv1Y3Q8QPKWNPBuJQGbLENlawbMD9wbtYvBPBdZtrFWmWT5ghOccj+XEdU/MOT37C4LLtnVewhyO82CymPcY1s/0Q4ihwOsQip6NVfHbTt6IixWQ8cXY1uXMU6qzurvkrh1TBXe1ts2djrC+CoGE/4A7vs/4LFS34rtoDuAzmXY5NRLbdMczQh+NZsKE5C2foylwecPuvzDw/QP4fUvKzoMFCW50CUokTeUNgmlE5GSaF4G+GZ0AUimYcVq/l7v6HwuCheXJeMdNpsmTPWeSUkoOiSHCpDCWO1dIdDYPiWVSDBEn9
 4YD7hCH+
 9mbq/LUYxUlmjXAclyVLLkYlrAcPE6yVmVEfl8d8gLBRSny+/6GEyyqtyFWyodr2iDvZ7bIPNQR3e39YhosZsouGz9Yp+a1ISVmd8uCaDYLbR31EKcVu1tqJ57CyExG8Wdakp+OwNZ7RvBQscaYTyejWa2kApX8QHHd1LAXEnDSEHS5c05bWBNjAxmQtEh/NQlVQvZdsAhb0V39Tov+qfMco+UDrbpDn5UDXDIVZHEypO8dOaYzUgkrx/PKxRuMe44aZln01xGUybXEoTXAEkg6duNRxDbHv26bLe8vBnoc3UnGk1a6196exOUClEBhHmsPau
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

There are currently 3 callers of kho_get_mem_map_phys(). Two of them,
kho_mem_retrieve() and kho_extend_scratch() need the virtual address.
The third, kho_populate() doesn't care. Make things simpler by
directly returning the virtual address. Rename kho_get_mem_map_phys() to
kho_get_mem_map() to accurately reflect what it returns.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a006a883ee94..797ec285b698 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -610,10 +610,11 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
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
@@ -622,7 +623,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 		return 0;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -917,15 +922,15 @@ void __init kho_extend_scratch(void)
 		.key = kho_ext_mark_scratch,
 	};
 	struct kho_radix_tree radix;
-	phys_addr_t prev_end = 0, mem_map_phys;
+	phys_addr_t prev_end = 0;
 	int err = 0;
 
 	if (!is_kho_boot())
 		return;
 
 	/* Make sure the KHO radix tree is initialized. */
-	mem_map_phys = kho_get_mem_map_phys(kho_get_fdt());
-	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	err = kho_radix_init_tree(&kho_in.radix_tree,
+				  kho_get_mem_map(kho_get_fdt()));
 	if (err)
 		goto print;
 
@@ -1609,11 +1614,9 @@ static int __init kho_mem_retrieve(const void *fdt)
 	const struct kho_radix_walk_cb cb = {
 		.key = kho_preserved_memory_reserve,
 	};
-	phys_addr_t mem_map_phys;
 	int err;
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
 	if (err)
 		return err;
 
@@ -1838,8 +1841,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
+	void *fdt = NULL, *mem_map;
 	bool populated = false;
 	int err;
 
@@ -1862,8 +1864,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	mem_map = kho_get_mem_map(fdt);
+	if (!mem_map)
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.43.0


