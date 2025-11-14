Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BF8CE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1598F8E0013; Fri, 14 Nov 2025 14:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1F58E0006; Fri, 14 Nov 2025 14:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F135D8E0013; Fri, 14 Nov 2025 14:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB10F8E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9667C591DF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:15 +0000 (UTC)
X-FDA: 84110127990.25.FA1A999
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BAC52000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fFuPNEqT;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2RJjwQybqCNudNEQM/yW3I9X0XoWZDL8m1h5Nt8Pcs=;
	b=u0sbNkPVETHWLr1WNQtFDkD6llFVfCqBD1WsuM2ua7ploLH3FByGld4kmQbozW4cAArnPI
	VBiOQAIRtZM7EV49U07Mz48YnttClbAO1FV9aLBIkd9U+PIEL68KDS2w1J2oo3N9CwKkCZ
	gm9bAPZXOaUeV1sKzF9nK8OnNQEk0zA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fFuPNEqT;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146813; a=rsa-sha256;
	cv=none;
	b=NxhjDuvuGzscdVgNaJpF6he/SlGjil6N/li3pIDUFMeq/fcr89WmdO1bbQjVgawyFz2aj9
	bUeuHN5AixsUOXsdHCP4kQpoQFUZEW76nRK1GcWhGDeUkrz/ZlOTS5RvYfS44hfR6D9IF/
	7FJW7q6qbMSGUarxGnTGXVv9WtXSWq4=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-640c9c85255so2494770d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146813; x=1763751613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2RJjwQybqCNudNEQM/yW3I9X0XoWZDL8m1h5Nt8Pcs=;
        b=fFuPNEqTLZGUVvp/5t157bztXzGmHEfIQsNtrACSz1wuxL+FPoFNOxA69N8claqZU5
         7zuGEUp0LWDCgV4RGM3jTaR8TfO2fjOW5u5QwUFkWwUeWgji5V1vOdsK8h5p0ZH0uPJ3
         OelOdvV/2HLQdbB9FlgIcz3EBCqo5lsGdR9XHLy71+5b3e6JE2lmffi1Aw9p4hqhqv4V
         sOMpWUzJhcI6Yd8pIGfccr9AGoCgm8L/QXtnZyNBBYgzEpRma0nvyl7Wq0jz5LDHxCsp
         oMBRtDikJqbS8M2JXYPEgUtziPCMyVFqQYxjqDzHXFXSau5nhUBoxZ2IAB1Tjrle0ZdI
         5Nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146813; x=1763751613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l2RJjwQybqCNudNEQM/yW3I9X0XoWZDL8m1h5Nt8Pcs=;
        b=gkbsz6Ym/Rtfc4QoQevgPMny1gvisGY4i6P1qsL7+EEfxmrml8K1iaAmxQEMrPDjbX
         h6+8Ut6wllkZn5SBp29r+exWsk7rZR51+Fjjp8PiggV8dCm/Ov79G6RulU+zQE7hFxbw
         Dpe38/l+N5/QuCyIB0EYqrf97HN1nfNydymAyTf2Vxlb5scG8VfWSZZyfZ0S1Z8c11zX
         odGJGaRG7vJ9cF9rfamXDlEybTPiS1z/JlJ0UVwFHCfR5BrALbuNPqU7ZESfvWF3eckV
         wajnhm/YcZVj+M+q8K28V5AaRbBgaSXj9Ky4WqwHwGzHBGyAc0Oz4eLYOeAcV/rFihSe
         L0bA==
X-Forwarded-Encrypted: i=1; AJvYcCVxsEklSPDJdz5NrRn3gzXw3lehXHqSvpwvhNvBxafpSKRWTscIxs+t2YyX2Jrvkeb/bZDOuM+SVA==@kvack.org
X-Gm-Message-State: AOJu0YzbwhE7n93M3H2DeqThU58oO7ETS9kaoYxcvPAS/zVUe80Ur1AQ
	MiZNzQhp5nuOPrSXwtaN9Hmwf+aXdSkDP5xEr2z3IcMBDSdQwLrV+D7/P6y+k2/Y5aE=
X-Gm-Gg: ASbGncsFQ+SvfUQC9gxTX9K9jPC3U7EmgqQ821St+g0vA97HRM7muMkntkCLwG3jbWz
	6FlN6JcgJO4rtI0RUt+ku4dWJdFsGcQ3tHRgxtbqwsB/Tircddq0HqC9KtgBJ1p0Y8RRvz/WOKb
	rbH6mPbaWUwbRst/aWO3gOiL8l9h6j+ovp26VrTj4vmiX74c5zizOU59SvK0LCsHzKT7sygjI/P
	OwB/MNfw85MmZ+Oihbr/DUHt87mC65nPRtlpU448g7Tbilu4o2LuuPMQpZVerBgt6c8qhDtq0Dz
	6o0A0tRvS3SoTsm1RhTqciuBh1CrNtZCJNYrPYpgv10oVB68PB9xr3oLXEWLo17ZqlemfYFPY00
	3ipCyPopsd4AjVOgp04pEdEkm45ZvzUT22F0qCMkEJ9eBCSJnUPgiO5wKA+6CpXwayb52ivzVzr
	Fj6xLG2XIj31BF7T7MpaVT+LDMdt5Fjows2pP6GP41arfsD98XV1QkmkTgjUQOAx5pzc/l
X-Google-Smtp-Source: AGHT+IELgQoKzNLiqxIk7OfyWTZZMKRkFfp9XFZAkA8ePupq0CHZkUurfOFSw9PuZ2noGq0xfhQIkw==
X-Received: by 2002:a05:690e:42cf:b0:63e:1e80:99cb with SMTP id 956f58d0204a3-641e764225dmr2603590d50.34.1763146812573;
        Fri, 14 Nov 2025 11:00:12 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:12 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 05/13] kho: Verify deserialization status and fix FDT alignment access
Date: Fri, 14 Nov 2025 13:59:54 -0500
Message-ID: <20251114190002.3311679-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9BAC52000D
X-Stat-Signature: dd55hmurpndg4p1o8ajieb83s36caidp
X-Rspam-User: 
X-HE-Tag: 1763146813-466457
X-HE-Meta: U2FsdGVkX1/CaTVvqa1zYIDl8HG4y3NXz5n+eHWzBIMjLq+9B3LvBFDvEL0nnieedbV2bilBaIpbT7WhKJtNLKn2E8V64MdoBuTF/M9SmZsS01jLFsv2qEqrKIMje4NVn7gKm5WvdJoNNhGkwgJWvBEBGZNGmpZbPygQ4+UaKZr+dGnKzQY/zRR+6oLKOZxB3Qdeeditx7fRI5u6/fEsoi5DDefAozKkFQq9jDvZ+b4ubsRo5QUeLPDhXmVyd8hkYKj3TQBR+hhmBkzN5ixbyn3UScW7SblCvW7o+jwtTS+c9MXLpO1p+pFQfG5RZUUGlwSvM9iDXNnVxvm1don9oHPkUJyZg8yahqkGhbm36m/Vb8/brATYbV829vrgeLggeYp4wk05hpYGVMwZN4F+tsk8mBfJpNS0987mrfC3nmDkRESeQzsrKK6C2X/KM3hjJPiqCjORe+8cRp4zxDp0LlUjxttJX7tge9suJfT3ba4aXKDZXLy3XV5E9B9YYXw+ZpD3pQakLMF8RdgsKZhO1zwByouUcMX1ilajzItEVJu4hCdpgBR+euhbcC0ahwH4QTxCMvl2k1JlA4kfTLvvVgLLBetbo7xZpF49VkV+t4j3wZg2Ta1hnLFSGeSLlQl1zZh4m0YlYTv9LNR0mnzqh0OGEi7U5c8+MalMVDfhI7wi+NKHXZFGgwLdN1L2I8vBqGwknUnImBmXRMx+CA8SQTi4FJum+Q+UcoWATjRkCYHxNxIeWyVQgcsOqtvTcA0VBTxUBdNTSP9NuNKbfDSJslLu35DYiXhXcpU/P0x5agxvL4wr6+9b4ITMcwzZU1o+qrQSkSJ9OVbvHhmB9hMqdt2c/ZZmTs+fUs4ibwzxeJjt8ijOu3V9iVZ1+BVY1hWmZfDKg8P4Lmjrr0QNXAEO4hwQfBzu3O7CgKbTErx6yF7k3305nSthobu/Px9RonblFP7TWldz9miX6dTfX0p
 eer/e5Hb
 dedyCG6gTRt7qjVqb8CPMWoJ/EC+0j6J4hGrUZ8q5cuzWsXe3eIay+a33Dq5IpuqpE6mQhgwnnpf8/TvdFODfNV99xPFbj2DZxygl1Y6xn/KCWQcoB49hh5sq9o4JzHchgX6t+dnOZT7SS56+CdXKXN4rn+ONlYbQwJ11Iixttruyn1y32Lium6opyvg3HG1STZ2BLzW1us/pAvvfag+0BMLWcjaqWyWPETbQDVr2XH7GZDxqM7brTS6IT/eBFOMaBQsmOvSQhIpRrburnkLcOu3ekx7uP3Ja6OwQ+Y0s7iivSyRCxXEOPoKUmr1rgWf9rIpqn15snRzEkEvJA/jij3lbz3jushmtCs6mGLT0qK14x3VIbTDtjO3FovoC3GPocXVWC4gftGKABLdvrBR1bk+qlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot, kho_restore_folio() relies on the memory map having been
successfully deserialized. If deserialization fails or no map is
present, attempting to restore the FDT folio is unsafe.

Update kho_mem_deserialize() to return a boolean indicating success. Use
this return value in kho_memory_init() to disable KHO if deserialization
fails. Also, the incoming FDT folio is never used, there is no reason to
restore it.

Additionally, use get_unaligned() to retrieve the memory map pointer
from the FDT. FDT properties are not guaranteed to be naturally aligned,
and accessing a 64-bit value via a pointer that is only 32-bit aligned
can cause faults.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 704e91418214..bed611bae1df 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/unaligned.h>
 #include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
@@ -451,20 +452,27 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-static void __init kho_mem_deserialize(const void *fdt)
+/* Return true if memory was deserizlied */
+static bool __init kho_mem_deserialize(const void *fdt)
 {
 	struct khoser_mem_chunk *chunk;
-	const phys_addr_t *mem;
+	const void *mem_ptr;
+	u64 mem;
 	int len;
 
-	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
-
-	if (!mem || len != sizeof(*mem)) {
+	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return;
+		return false;
 	}
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
+	mem = get_unaligned((const u64 *)mem_ptr);
+	chunk = mem ? phys_to_virt(mem) : NULL;
+
+	/* No preserved physical pages were passed, no deserialization */
+	if (!chunk)
+		return false;
+
 	while (chunk) {
 		unsigned int i;
 
@@ -473,6 +481,8 @@ static void __init kho_mem_deserialize(const void *fdt)
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
+
+	return true;
 }
 
 /*
@@ -1458,16 +1468,12 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	struct folio *folio;
-
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
 
-		kho_mem_deserialize(kho_get_fdt());
-		folio = kho_restore_folio(kho_in.fdt_phys);
-		if (!folio)
-			pr_warn("failed to restore folio for KHO fdt\n");
+		if (!kho_mem_deserialize(kho_get_fdt()))
+			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog


