Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E77360A3836
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uwUjXnsf
Received: by kanga.kvack.org (Postfix)
	id 34FF06B05BB; Mon, 26 Oct 2026 22:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328C56B05BC; Mon, 26 Oct 2026 22:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217466B05BD; Mon, 26 Oct 2026 22:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E22176B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 678FE4091F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:51 +0000 (UTC)
X-FDA: 85366893822.22.F829D11
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFD9D160005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uwUjXnsf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 38BLgag0KCPMfZqdigjpbcgdibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kevinloughlin.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=38BLgag0KCPMfZqdigjpbcgdibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
	b=6t5GuH0NEZvpk/iqU/D5O2kn46khsk2W55wdni4G99HHYfjvUOwk97V0dSO5rRa3xzV07a
	EbU13MKA1w1HuOw45iH9GAE9qAughDeWcw2NZ2LygwZPc+mVtW4u5rGo6mOf9OrAa8sQ1Z
	PWJ24tUH1/R8jVYgtTKdpCZDW0bvDhc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uwUjXnsf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 38BLgag0KCPMfZqdigjpbcgdibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kevinloughlin.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=38BLgag0KCPMfZqdigjpbcgdibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069809;
	b=FUYbMqJpY7rnaFRzPRWosK30IU+M2D4aWtCgNuaCmt4DhPGQGbt528pUz/YYX/eMZ5I9/N
	Kui2/Wx7bLEyQKFB0prnD6v8l9Cvl6WS3ms52qYcQjPkqlHu/s4xARpDDlSV4sTv1kpnOA
	WFQ91XBOJZQ80aFzDVMfKhOYiCVDTOQ=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-82322894f5aso855113a34.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069809; x=1793674609; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
        b=uwUjXnsfax0j8Z0JC6XUhbAW7ZGEagF4DILwGxqikdcZ5k6OCf+yHysV+e7hUupeGF
         1S8z4OpomHsL4egAxKc6uPf7/RgBpUW18EttsE3SN15tAxW0//2rFQiKzspgMqaDKqiY
         P1ktO1bMFB3HsPYRY6sAduhqYhQ7ajbcFsVevQsJ6WnSkh8WxhiJBJ1CGgIilKJNOCo/
         5fCPtWvrQQzzZvKsuN9OjtfrXT7GA9h6rfmBBXRDc81v/DlrgpMrI1TDF7uwNnYz3JLI
         nFh/j4ojB4sTzD2+umaV13/7QM+NP29mXgTI9uaCpZHiOQzCrH+/lyK3CtAHlmfE0euQ
         6jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069809; x=1793674609;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i2TVROB2tkypKL2JwuC8PelARTqsfICvFAyjnT/ZhdE=;
        b=Mmft1hCbdaQID8eY2WjV7QJDzzLgU4qIW4dQ4HTjRXqeAnVmVBk7TgyeHHMtwQkoYq
         NkOcw6AR8ivK0PTvUnDFfJpdmrsxYCpQp15ahnPxDcT0tW+soa5TyYHvRqU7BtgfURQw
         htOraY7AtipriD1dfRTdaE6nQ0LHfXa5df1IYzVSxYm22Fpin2DCoVmPSqb6+cPd0TGt
         thJi26/Qj7eBKCnuPyrnFiteIvIZSuMVwugQkHsKT45O1Fk6COZwJ5akYNCzM29PtBB3
         OVofwxiLzJU7R3rvSqiEMebGEtem/5csuzkZMcNb2ncrDYXBbcGs6z1LsUweylgHz+QU
         kpTQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3WhilKxJVNifNrviVOzaZZ8AKxWs4Hweo/q4tPcV/HIFBIaqsCVYJzC6D2Ck1KboNnhU1iVBPIQ==@kvack.org
X-Gm-Message-State: AFq9FYJvBYKviRljSaHIwOMhus10ayWfToU5NmW//eEip1p4fuwPRtfJ
	26FtatH4UN0oG+xnM46+NJu7K9aXVv3HP+9Qwed3TbnnTVqO0k8njAqK/zKKAm3V5xxhN/MhF0o
	qMx8TV+lO0ndEhlT7Jsqre194gNspTYLTJg==
X-Received: from ioyd21.prod.google.com ([2002:a05:6602:2bf5:b0:9c4:de2b:c40f])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1ca4:b0:702:c1a4:7563 with SMTP id 006d021491bc7-7126910deb4mr1003099eaf.8.1793069808399;
 Mon, 26 Oct 2026 19:56:48 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:08 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-6-kevinloughlin@google.com>
Subject: [PATCH 05/13] efi/libstub: start unaccepted bitmap at address 0
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFD9D160005
X-Stat-Signature: f5h59tbugnims8hbmpdut6zou8xbz73b
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069809-616031
X-HE-Meta: U2FsdGVkX18+0M/rD2VyAGsFTVpd5QBM4pRlrrM5Vf9JPEsYxRTeYx2/gdaVOSJQGf8f1TidOrFMF5r7Y6cQAMdTw4JqfskZB1cJCinobDAWqvQLm2MxyWSw5lg+szIBL8NDei3XJqq8GszIoPO7yyT4nl2VaA44IcJk/F4IvoEQK+lqfYoZls/X1ivVKmXybmTLnfKoell+tP6GwYV4yD0HxQYUMp8lZmKZ114eBe9Ra4+sZckv4kbr78rQOsIIGrjNJ/z2Kndc+9FxgFT+3UX/eGdrgD//qw1QwAiZHAitlgX8HOqD3HTOlOrUD3Z9QnmLAmhfq45pOtbw/oClf3PEmjhdeHBgatSkdB+nB6drqvBWakmZ4XxQu5PY4HnPmMDQfZ4ULdccRNI4bL4/PusgaP9ZaslejQhTEpC5Fep0Rg8ACtW5piDcCfUkorg5MVSvIQNEu0XtlJZFIAbYNaTOihYET34znctaD3SET7hD47m9nPmLIdj2pIrN8JySZD32Jqytp3Al3kXRdFGS3SNq2vuAv329a1YP2do5TBoa86V7SrIOgoZWyL2WsCqD/TBQojZbMRMOG3dk+dF8EoGBb14yABpeWz73aXDD2JBCBXFEAypCNx/Hp4H8Lm5oR77hxTdygjAVIWnSiowcuNSJgnXjgmVR/McytvpU3UG2BzRZL2I9trI8DDrM69cBkT6Dx1XixPZdHF0evrnS/OEUQIR6YgZI3guziOIrAOOowtn4XMHPQXDw+9vNBSSjC4+1co6jeY50HTnR3ShtkJXww3LRIjnQtRawpDct7NuspLsR27v0GLvri/zjM0qz1KkGmd+0+LH5oGX1XeSWMTA3xb55a8fAB0ibgMtS1bEM8pRSh6Nn5aiyvPqcsZg49lRkJ0eWnzgblzg2czBCl7voTEKkU9IySxV7DzBqFA2CQ0RwSTa80ZuCtCWsKj7g9G8iT61jObKy0ohsFZj
 YRdK1H0s
 wfSj27+Dkt9BuELZ3r+jd7qhM9cKjjbSOeZqGfLaeWZAsxjPxlsP5epOREo+vBhCI+iY4pgruWBzihTViiVJ5+trNquuW7WcnqmVaTyWr/thGZAtZvS/aChhYz36TIPPrKLivAT1jdQkA/XeImHEnpJDbVTC9RlaLzC1WE+XsOjpQ6B1e9JVzyeysI5mAn1tuFQ35jId5ZPywIykXvFRylqL5v+9c8jJjljGp5NguqAA8a6HSdXjHSJkiiSm1JtBBsWPPOeEBqw2NcXCaV2W6P839RTL9KgFLhVaPIdB+5izOLtdk/bdpu20yAG7d3VS6bWapQpeYzmPwsKRvfVAy4PtZpMJYhaGGEf/acCDfQNuP5RPjdlBBb9cnujLGc+wucCIzzXNYzPx03zvUBGNOeFFJPlDRii+ztqyDPITV9g1xHJuenWwokd2lqAkOr7tNvTMxab/dKxgWFrL2Vbb7VatuKs+/KYidpHL8Y7W0gCHv+b64ZKu0q54Bvz9P6phHYC2RzNXLBbXBvfKNdq/79d9oTd7QB+C52kfB447kjVmw9wjDN58OXO6lWGwZeZvkLMhzOK9NOLuAwYeMO3OATWSEPYQFIs48cxaW6ZDsOTBgv/VRglmtjgwWW/8B1Nkjt3wr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When EFI_UNACCEPTED_MEMORY is present in the EFI memory map or the
platform supports dynamic memory unacceptance (such as AMD SEV-SNP),
start the EFI unaccepted memory bitmap at physical address 0
(phys_base = 0) instead of the lowest initial unaccepted address.

This ensures that pre-accepted low memory below the initial unaccepted
region is addressable in the bitmap so it can be dynamically marked
unaccepted and re-accepted later via virtio-balloon or free page
reporting. Non-confidential guests without EFI_UNACCEPTED_MEMORY
continue to skip allocating the table.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 .../firmware/efi/libstub/unaccepted_memory.c  | 45 ++++++++++++++-----
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
index 757dbe734a47..fcb622ac0564 100644
--- a/drivers/firmware/efi/libstub/unaccepted_memory.c
+++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
@@ -2,15 +2,28 @@
 
 #include <linux/efi.h>
 #include <asm/efi.h>
+#if defined(CONFIG_X86) && defined(CONFIG_AMD_MEM_ENCRYPT)
+#include <asm/sev.h>
+#endif
 #include "efistub.h"
 
 struct efi_unaccepted_memory *unaccepted_table;
 
+static bool efi_stub_has_dynamic_unaccepted_memory(void)
+{
+#if defined(CONFIG_X86) && defined(CONFIG_AMD_MEM_ENCRYPT)
+	return sev_get_status() & MSR_AMD64_SEV_SNP_ENABLED;
+#else
+	return false;
+#endif
+}
+
 efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 					struct efi_boot_memmap *map)
 {
 	efi_guid_t unaccepted_table_guid = LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID;
-	u64 unaccepted_start = ULLONG_MAX, unaccepted_end = 0, bitmap_size;
+	bool has_unaccepted = efi_stub_has_dynamic_unaccepted_memory();
+	u64 unaccepted_end = 0, bitmap_size;
 	efi_status_t status;
 	int i;
 
@@ -30,19 +43,27 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 		unsigned long m = (unsigned long)map->map;
 
 		d = efi_memdesc_ptr(m, map->desc_size, i);
-		if (d->type != EFI_UNACCEPTED_MEMORY)
-			continue;
-
-		unaccepted_start = min(unaccepted_start, d->phys_addr);
-		unaccepted_end = max(unaccepted_end,
-				     d->phys_addr + d->num_pages * PAGE_SIZE);
+		switch (d->type) {
+		case EFI_UNACCEPTED_MEMORY:
+			has_unaccepted = true;
+			fallthrough;
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			unaccepted_end = max(unaccepted_end,
+					     d->phys_addr +
+					     d->num_pages * EFI_PAGE_SIZE);
+			break;
+		default:
+			break;
+		}
 	}
 
-	if (unaccepted_start == ULLONG_MAX)
+	if (!has_unaccepted || unaccepted_end == 0)
 		return EFI_SUCCESS;
 
-	unaccepted_start = round_down(unaccepted_start,
-				      EFI_UNACCEPTED_UNIT_SIZE);
 	unaccepted_end = round_up(unaccepted_end, EFI_UNACCEPTED_UNIT_SIZE);
 
 	/*
@@ -59,7 +80,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 	 * The bitmap will be populated in setup_e820() according to the memory
 	 * map after efi_exit_boot_services().
 	 */
-	bitmap_size = DIV_ROUND_UP(unaccepted_end - unaccepted_start,
+	bitmap_size = DIV_ROUND_UP(unaccepted_end,
 				   EFI_UNACCEPTED_UNIT_SIZE * BITS_PER_BYTE);
 
 	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
@@ -72,7 +93,7 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 
 	unaccepted_table->version = 1;
 	unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
-	unaccepted_table->phys_base = unaccepted_start;
+	unaccepted_table->phys_base = 0;
 	unaccepted_table->size = bitmap_size;
 	memset(unaccepted_table->bitmap, 0, bitmap_size);
 
-- 
2.56.0.307.g5fe7bd680c-goog


