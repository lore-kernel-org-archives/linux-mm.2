Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473AA60A2604
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Ut9q7IKz
Received: by kanga.kvack.org (Postfix)
	id 0B5056B05B4; Sun, 25 Oct 2026 13:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F896B05B6; Sun, 25 Oct 2026 13:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA846B05B7; Sun, 25 Oct 2026 13:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A51DD6B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CA16A05BE
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:27 +0000 (UTC)
X-FDA: 85361862894.30.7900F63
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5484A40006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ut9q7IKz;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6x1S3ZqdbkxHt3USof+znmMvAt7VbtHwbOPxHgeUp/E=;
	b=d7lw6hbNLc+MlYBmb0uDBZgoxs3r0VLZXkhWw/Sqv0slXoblDKnI7SFt8f6UCweHv+DHz2
	dBRC5W9Wjix5KXRbhvc6CUgihp9t8LCWXHz8w/VXLI/X2kma+39dfknIvQtmKYlbHOU+Uq
	OPQsui9cEaOz5OlUFstnvaoE+xG3hXg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ut9q7IKz;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950025;
	b=lTiHFSVs3C1Uo0dAA4o/x45ZppwQHc9IkjN9SFVbbRP8vh3o5tp5/108pq4xyeFpadfdXj
	8Wc5cE9G6sh+EutMT21dC24sFogig76iQBlzy1EKINTIGPRVFiyRReq8/jjcej71rvU2LA
	jJ+ss+fZz76zxQCCBXkxMNLEfEGrMuk=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5eafb65e169so1728468e0c.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950024; x=1793554824; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6x1S3ZqdbkxHt3USof+znmMvAt7VbtHwbOPxHgeUp/E=;
        b=Ut9q7IKzbi6TC1O8bwaCl/wXsfGL3i44Dl42talju0509YIe8er4oyBjGlJRgDd0/1
         eOlN9Tj1YZn59qNcgBxX4szwmx3wfsHER48Ik+nOie+eEz704LgqZUA/F0WBI8QzakD+
         gP8TjV7ugZ46L8dtu/OlhFQpt7syKH/BmVionKAZF41GAXgDWTOgufb97gXomxP58E1I
         dkpS4yFIQt6Nk3/HsONjsHjvyL2RiAaxNYRzbGJcCMQM23RICqrCB5YrXurKosKRzwT1
         SMW1BIx7bop3sle2rpp1gJ8pQ11CPFIZenzVxSKa2tsJGlnWKLn0Qdp0XGGx9fv/nSFX
         fxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950024; x=1793554824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6x1S3ZqdbkxHt3USof+znmMvAt7VbtHwbOPxHgeUp/E=;
        b=ssBZs8/wZ7R/1VKRMpkt56jTTHR3FWFc2lu6t0nbbTJlIROb9T61JMV7jWy9XaOsmO
         hv60l9jcPD/3Q1HsLHCxtrxSPCIJaLITo9dEiRTlK48fVRUNLOp9LTLf58fJZMXULdft
         inB6ZlpyxzQcJXCUCp+B5BhIkBFec8d6aC5bFQU9qV58q2RZCB/dsKfOoQZbG0rSflyz
         40DWgOxTqf2GdxGVqZhGsixqktPVK6s3eByDoaWEm7NLaNkzHgEVVSO9yTzVajtJjGVR
         FnA0SIN85jIERtnFgnh1coW+4KGFbdnh8j6slIcX01+si1KkWnNr9y/SjTTrbMdg4Mwe
         DD8g==
X-Forwarded-Encrypted: i=1; AKwUvBz+ZtXrcRccUsL85RSHre3yPLt9ow642BvT+DtRXwXrM5PONQvSCkolXMGYMWwpxMpLsia/Bq+c5Q==@kvack.org
X-Gm-Message-State: AFq9FYJyqCucE6UpyDpI/phR5SJbiXaRkfU50yihz0YITIShtceFyMJN
	A+4nbFPc98xjQSHVj9cfZkw/W9FygwpMjEj6Qjf6nLwTS+Zvccxk5QURdiZWVZxNms4=
X-Gm-Gg: AYBFou0ijpLJmRHAz4eVMbIQYdQ2LrWA6MWXP7aP3w3g/hcf42+swC9WuupVxJNCAgd
	9FSaZxSZOkRS+vsQbN/lFcFZyOI94HQEy/H05C/05p5q1swj6WPcuI7snr4X+G7f7RiT6yzp1BF
	TqqExqItB1ugJ/IpuuwPcvv/jQKk3+9ApvF5okLGAW+H3FNg7EvP+PdXnXYMm3uJIb90UeVGfWC
	5JvyARo0ml5q3ouHxoTeo0n2RbN+fEgiMg/pRk3YH0HELxizbNnC6uv9cjn+863FtlFtoTJYtlI
	FR63Nzt5nTo9fhU+zc4pWDGFyorsjNWGKYMEKqyn04Qudovjm1YehNayzD9J2JcKY4wuu84w2AW
	f2FyH1ql3lRptT7bbsMu3nLaGV/7aT5jz60KNERJxuijOkoYIkc0GAfCpACSwhhT8yOnBEdeDC9
	vRMBbLxF3pGK8gkxI/wKy3x+ru/HfL3FGzC4aR0EaubcS4Hla5lhFnGEXy4PQOsUZzo+hAYkGjD
	gc9UjkrY+oAlp5z2BZhhF+w93YwpY7KokUEhMN+XJTMAegUIUqn5u2fSOSdVy5Zd3i9JDd8puvx
	/aMqjEZzclbBRUlSTcAeC12ENOb14v0S9T7Cbk8nZ/6va830pvBitsyDAJT4kUP2m2iuXPvZrCa
	sZ+FF0FAAlISMvGmm5mpfDkQ=
X-Received: by 2002:a05:6122:21a9:b0:5ea:d5ff:3bc5 with SMTP id 71dfb90a1353d-5ec2309e769mr1605074e0c.2.1792950024405;
        Sun, 25 Oct 2026 10:40:24 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:24 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 3/9] kho: validate preservation metadata in kho_restore_vmalloc()
Date: Sun, 25 Oct 2026 13:40:10 -0400
Message-ID: <20261025174017.3870481-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5484A40006
X-Stat-Signature: zk3gw1q64op9o8f3nsoshi6oisuxy47b
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792950025-541596
X-HE-Meta: U2FsdGVkX19CyAGgWIB2tSpvDtQ9X6IUwEFfsfJzmSgcSo8jjG2Co50e5LPLH1zz9zwy5Klsm/PNsHGbBp17LJPY5S591PnjIMS7JFSnPeHXyiEBak2pyoNkqmUWB/PmkgmoDK/ceHlHxrGEgZZbSyr+0zEHzzh8LJ6JBW2s4rql/+a5WdJPg3rxJyELD9LShgB6NYtL8GSw5DitzYNLh1AnFOx8sIu7FHBDP+J8VMSffRAVhUGXHUg0E9r1p7nlGvXYE7A3zQSWSKG77jk4bdA8+NesjeKj+bgm200rGDeLO/ZCZULVsBOZilnNVfjjT9ECuA8iuaPPURJigD/ca8vRzkKnV2rLbVh1s5dlZ440hJeuQdF5q7FFZiKN6fI4MXEIHkdtB4OufqITDecnHb9QdsZv3Jq2f1Hb9TfkT2V9acWgFnrlRXzE9W/izz/BDMsXx6HZJ/hcL1goRmPNjK9zNnaYqkG3RbWyTWXnzyLlLSIGa5hiVv3bVL6gBFD0N5EZpWRn07l1YoeSjpLxQD9WJJwXxHU6uX2b+SlGBKMy0I+hc5cUI1zQ0VKhsDa4gFrvusxzyzFt+8+ITde9XsHvvdT8mGJUAzoLy0Vc7LENZ2xmBrrQPB7hEMtOT9B5UDgqwpFh57Zqn//pR9RI1jyOSjqt8Pmd0kpa+cFfNG0MXEUfBcYOfXIyDSHAGvJ6egkpQptv9fk866668JBC30SEdbJ5jk2VAL77vNajERhIX6phjRVQ2qYkI9QwBFzlDL15DsrA881H7+xD+9QzZgqCo5xrXY0/r4YIxcfTxUeSC4+Dn1jc4eLGvorwUwIzf2nDsc09QH2Nh0td0kW0SY5bHZq/yL+59SrgpQziJ8xm6n+qWSrqUA8C0q97noskX6LJRdAxG1Py/EM+BzSFlIoZnSmVvfCl82SJUSKwljknmb1m8ZCSIyLIZ0Ee5OLF1t/p8LVvCt3YTBsbyV0
 agLGzBIi
 CUtp4XQo0yy4kKiGoQjnVfrVhdvz3w2nsEpAtoo++//IQoQQ+VRXDAlQEUkTQmeUsLhzow1PJEcEQNqJm7kNap2ZQVQnF0hovt2Q2CiPgLoFe8/bTHu3lLYiHbbyaHSPfXybpIIJATzSDDi7aTFToVgoo5euK5rGYSnytwioV8AVWYdEDbMpfc9b+Uxe+SaelrFhhic+C7bMXIwVIbQw3y9ketrYGWL+Y6ft/s5clqsNKQG6Zlc9r7j9fvA56igs0+duigalzSkgUKNWUmZ9t7W2+gt/rekbKGsht0a0dFX+8GpHCMKf8lcw0m6HlXrJItTcCMThf3NWwbZ8eugkFtHU26FWbcIARPq+q8OMk5/Ve8TqkFfP6ERx5pajcYbQVgGX0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho_restore_vmalloc() currently dereferences preservation before
checking for NULL, does not reject unknown KHO vmalloc flags, and does
not validate preservation->first.phys, preservation->total_pages, or
preservation->order before allocating the pages array and shifting by
order.

Move kho_flags_to_vmalloc() to kexec_handover_common.c and introduce
kho_vmalloc_validate() and kho_vmalloc_walk() so both regular KHO and
the upcoming read-only KHO mode can share vmalloc header validation and
chunk-list traversal. Converting kho_restore_vmalloc() to
kho_vmalloc_walk() also restores each chunk page before reading its
contents and rejects non-terminal chunks that are not completely full.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c          | 99 ++++++++++-----------
 kernel/liveupdate/kexec_handover_common.c   | 87 ++++++++++++++++++
 kernel/liveupdate/kexec_handover_internal.h | 14 +++
 3 files changed, 150 insertions(+), 50 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index c24f25bfc96a..67efbdd39439 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1204,10 +1204,6 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 /* vmalloc flags KHO supports */
 #define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
 
-/* KHO internal flags for vmalloc preservations */
-#define KHO_VMALLOC_ALLOC	0x0001
-#define KHO_VMALLOC_HUGE_VMAP	0x0002
-
 static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
 {
 	unsigned short kho_flags = 0;
@@ -1220,18 +1216,6 @@ static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
 	return kho_flags;
 }
 
-static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
-{
-	unsigned int vm_flags = 0;
-
-	if (kho_flags & KHO_VMALLOC_ALLOC)
-		vm_flags |= VM_ALLOC;
-	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
-		vm_flags |= VM_ALLOW_HUGE_VMAP;
-
-	return vm_flags;
-}
-
 static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
 {
 	struct kho_vmalloc_chunk *chunk;
@@ -1357,6 +1341,45 @@ void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
 
+struct kho_vmalloc_restore_ctx {
+	struct page **pages;
+	unsigned long contig_pages;
+	unsigned long idx;
+};
+
+static const struct kho_vmalloc_chunk *kho_get_chunk(phys_addr_t pa)
+{
+	struct page *page = kho_restore_pages(pa, 1);
+
+	return page ? page_to_virt(page) : NULL;
+}
+
+static void kho_put_chunk(const struct kho_vmalloc_chunk *chunk)
+{
+	free_page((unsigned long)chunk);
+}
+
+static int kho_vmalloc_restore_entry(phys_addr_t pa, void *priv)
+{
+	struct kho_vmalloc_restore_ctx *ctx = priv;
+	struct page *page;
+
+	page = kho_restore_pages(pa, ctx->contig_pages);
+	if (!page)
+		return -EINVAL;
+
+	for (unsigned long j = 0; j < ctx->contig_pages; j++)
+		ctx->pages[ctx->idx++] = page + j;
+
+	return 0;
+}
+
+static const struct kho_vmalloc_walk_ops kho_vmalloc_restore_ops = {
+	.get_chunk = kho_get_chunk,
+	.put_chunk = kho_put_chunk,
+	.entry = kho_vmalloc_restore_entry,
+};
+
 /**
  * kho_restore_vmalloc - recreates and populates an area in vmalloc address
  * space from the preserved memory.
@@ -1369,18 +1392,16 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
  */
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 {
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
-	unsigned int align, order, shift, vm_flags;
-	unsigned long total_pages, contig_pages;
+	struct kho_vmalloc_restore_ctx ctx;
+	unsigned long total_pages, align;
+	unsigned int order, shift, vm_flags;
 	unsigned long addr, size;
 	struct vm_struct *area;
 	struct page **pages;
-	unsigned int idx = 0;
 	int err;
 
-	vm_flags = kho_flags_to_vmalloc(preservation->flags);
-	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+	if (!kho_vmalloc_validate(preservation, &vm_flags))
 		return NULL;
 
 	total_pages = preservation->total_pages;
@@ -1388,37 +1409,15 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	if (!pages)
 		return NULL;
 	order = preservation->order;
-	contig_pages = (1 << order);
 	shift = PAGE_SHIFT + order;
-	align = 1 << shift;
-
-	while (chunk) {
-		struct page *page;
+	align = 1UL << shift;
 
-		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
-			phys_addr_t phys = chunk->phys[i];
-
-			if (idx + contig_pages > total_pages)
-				goto err_free_pages_array;
-
-			page = kho_restore_pages(phys, contig_pages);
-			if (!page)
-				goto err_free_pages_array;
-
-			for (int j = 0; j < contig_pages; j++)
-				pages[idx++] = page + j;
-
-			phys += contig_pages * PAGE_SIZE;
-		}
-
-		page = kho_restore_pages(virt_to_phys(chunk), 1);
-		if (!page)
-			goto err_free_pages_array;
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		__free_page(page);
-	}
+	ctx = (struct kho_vmalloc_restore_ctx){
+		.pages = pages,
+		.contig_pages = 1UL << order,
+	};
 
-	if (idx != total_pages)
+	if (kho_vmalloc_walk(preservation, &kho_vmalloc_restore_ops, &ctx))
 		goto err_free_pages_array;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
diff --git a/kernel/liveupdate/kexec_handover_common.c b/kernel/liveupdate/kexec_handover_common.c
index f2784f5c523c..dc25cb4c08af 100644
--- a/kernel/liveupdate/kexec_handover_common.c
+++ b/kernel/liveupdate/kexec_handover_common.c
@@ -19,9 +19,96 @@
 #include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/unaligned.h>
+#include <linux/vmalloc.h>
 
 #include "kexec_handover_internal.h"
 
+static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
+{
+	unsigned int vm_flags = 0;
+
+	if (kho_flags & KHO_VMALLOC_ALLOC)
+		vm_flags |= VM_ALLOC;
+	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
+	return vm_flags;
+}
+
+bool kho_vmalloc_validate(const struct kho_vmalloc *preservation,
+			  unsigned int *vm_flags)
+{
+	if (!preservation || !preservation->first.phys ||
+	    !PAGE_ALIGNED(preservation->first.phys) ||
+	    !preservation->total_pages)
+		return false;
+
+	if (preservation->order >= BITS_PER_LONG - PAGE_SHIFT ||
+	    (1UL << preservation->order) > preservation->total_pages ||
+	    !IS_ALIGNED(preservation->total_pages, 1UL << preservation->order))
+		return false;
+
+	if (preservation->flags & ~(KHO_VMALLOC_ALLOC | KHO_VMALLOC_HUGE_VMAP))
+		return false;
+
+	*vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	return true;
+}
+
+/**
+ * kho_vmalloc_walk - Walk the chunk list of a preserved vmalloc region.
+ * @preservation: Validated KHO vmalloc preservation metadata.
+ * @ops:          Callbacks to acquire/release chunks and process each entry.
+ * @priv:         Caller context passed to @ops->entry.
+ *
+ * Traverses the linked list of struct kho_vmalloc_chunk pages starting from
+ * @preservation->first.phys, invoking @ops->entry for each contiguous physical
+ * range and verifying that non-terminal chunks are full and that the total
+ * number of pages matches @preservation->total_pages.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int kho_vmalloc_walk(const struct kho_vmalloc *preservation,
+		     const struct kho_vmalloc_walk_ops *ops, void *priv)
+{
+	unsigned long contig_pages = 1UL << preservation->order;
+	unsigned long total_pages = preservation->total_pages;
+	unsigned long nr_pages = 0;
+	phys_addr_t chunk_pa;
+
+	for (chunk_pa = preservation->first.phys; chunk_pa; ) {
+		const struct kho_vmalloc_chunk *chunk;
+		phys_addr_t next_pa;
+		unsigned int i;
+
+		chunk = ops->get_chunk(chunk_pa);
+		if (!chunk)
+			return -EINVAL;
+
+		for (i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
+			if (nr_pages + contig_pages > total_pages ||
+			    ops->entry(chunk->phys[i], priv))
+				goto err_put_chunk;
+
+			nr_pages += contig_pages;
+		}
+
+		next_pa = chunk->hdr.next.phys;
+		if (next_pa && i < ARRAY_SIZE(chunk->phys))
+			goto err_put_chunk;
+
+		ops->put_chunk(chunk);
+		chunk_pa = next_pa;
+		continue;
+
+err_put_chunk:
+		ops->put_chunk(chunk);
+		return -EINVAL;
+	}
+
+	return nr_pages == total_pages ? 0 : -EINVAL;
+}
+
 /**
  * kho_encode_radix_key - Encodes a physical address and order into a radix key.
  * @phys: The physical address of the page.
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index e73a2e310917..dd79e5006562 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -8,7 +8,21 @@
 #include <linux/list.h>
 #include <linux/types.h>
 
+/* KHO internal flags for vmalloc preservations */
+#define KHO_VMALLOC_ALLOC	0x0001
+#define KHO_VMALLOC_HUGE_VMAP	0x0002
+
+struct kho_vmalloc_walk_ops {
+	const struct kho_vmalloc_chunk *(*get_chunk)(phys_addr_t pa);
+	void (*put_chunk)(const struct kho_vmalloc_chunk *chunk);
+	int (*entry)(phys_addr_t pa, void *priv);
+};
+
 const void *kho_get_fdt(void);
+bool kho_vmalloc_validate(const struct kho_vmalloc *preservation,
+			  unsigned int *vm_flags);
+int kho_vmalloc_walk(const struct kho_vmalloc *preservation,
+		     const struct kho_vmalloc_walk_ops *ops, void *priv);
 unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order);
 phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order);
 unsigned long kho_radix_get_bitmap_index(unsigned long key);
-- 
2.56.0.307.g5fe7bd680c-goog


