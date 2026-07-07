Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7703C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA816B009D; Tue,  7 Jul 2026 00:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B206B009E; Tue,  7 Jul 2026 00:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2460B6B009F; Tue,  7 Jul 2026 00:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2D4F6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:10:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E2C01C7DE2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:10:20 +0000 (UTC)
X-FDA: 84960653400.03.2B8FED8
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BFD9C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:10:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783397418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=6VnKTEvv8e6hieMD39zqyYIYs3ocKmE599Khsg5Tf/0=;
	b=Q4KZWkiKYEVS93xUPNLDgYYEqkxQwEi1rnqwLxOl0WGETjC275/c0NdWFH3DPQDFUzdG46
	1Pw/wItC5cznb9NR9F2OGpMn2GjTKi1NB1Xe4sJYtWEmkvxtzzvx8vlAjtAoGVaYx5vigm
	hgVhz53JETDFF9BUbMOSj0Cas0+5UaU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.25 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783397418;
	b=0pkz7xQmHM+rkbQ7bcVRzFDTX6CX2Rkz7HegrpUlNkZAJvljSY9oXLOCP8i9hYDWqHEWxl
	xdO5cj/EnkdIVOluroxxP+iCPxeoXChgoBB62kbZZIw4BInmRkgsCnBd7H2DxwLnx8kb01
	/Bl+OQXDMov29z/8EvtE/lp9nYikDDo=
Received: from [127.0.0.2] (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHk8YdfExq_cVRFw--.40495S2;
	Tue, 07 Jul 2026 12:10:05 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Tue, 07 Jul 2026 12:10:05 +0800
Subject: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after hotplugging
 vmemmap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
X-B4-Tracking: v=1; b=H4sIABx8TGoC/43Oy04DIRgF4FdpWEvDvdCV72G6+IF/LOpcAlNS0
 8y7y9SFNZrq8iQn3zkXUjAnLGS/uZCMNZU0Di3ohw0JRxiekabYMhFMGKaFpj3kVwrdjJnWHvs
 eJjqN0+kNZqTG+rhzzEoXHGnClLFL56v+dPjM5eRfMMwruTaOqcxjfr/OV772/rdUOeUUjbPRa
 ueBm8dUApQthG0YyLpVxZdmmLqvCcooeAO7yKRXUv3U5K32xzfZvkGrMQ7BCfOLpm40ye5rqmk
 deh+4jsCE/a4ty/IB5XVbMMQBAAA=
X-Change-ID: 20260525-mark-after-vmemmap-populate-68bd790839c9
To: Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, Muchun Song <muchun.song@linux.dev>, 
 Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:zQCowABHk8YdfExq_cVRFw--.40495S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWfJr15Kw4rtFykCr13CFg_yoW5tF4xpF
	Zruwn5trZ8Wr1xWr47Zw1I9r4xJwnIga4xK3WFkry5Zws8XFyUWr95Kay8WryDJFZ5Zayx
	Ca1Yk34rWFyUZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUJWrAUUUUU=
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Stat-Signature: h97b16ta8wbxzzmbc6qi993h6yugz8sr
X-Rspamd-Queue-Id: 6BFD9C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783397416-950512
X-HE-Meta: U2FsdGVkX1/pvHXIGmODjbei3sRHSQ47NdItUZZAtC/OzIS3hiaYbQaGL8haQslvrfqe2yatlPa4/ph4XaRhnKQM22ni89DmKLAHiKcuCuYLK3hacoOc9cQYfhodc1PypWuNgeeTA17Bjw8pkLvjLviEsMXo0Klnsy6d99HNwDZamBGJu9x3KwyS7YoaId6P0iHy5JwEq+9trzYA58UHkIAX77uvQQlT4bjCbw0j3pWwi9V1qGRYb4+0Ol6ahJ4EjYph7lIHsvMd0zV8MpYbwSNA5QIaEq0ZnZyg5I3UigUnjo9TgzQgciG7hECVHqdR0oausmZyzmOX0NL1kKNJIedWc7IskY2xVUkpajfXUfCV7P7O7Q5rg1NeIZbKkdVRdksr9iGnTxY5DdexJHrTzZT4teIgqIBZ08lY4jm55WDPQl/sEpDuKcSNIQxCux3SE81fyenNzUQYXmhM7t0EHLzbiaONbfmWH3GvuEZG4eYuoM2ixrUYOGqZNIkVMsR/d2B/9q9gEOkmks6WqpmBVgYwmSsKdP8Jvg8/edOO/X1qVX/m83Dy8QmgxEiRnG6qZsCPboubHI8vLYTJMMAIi+XbIABGXzjFMbqQAwKiNONTNjkukx8EGY6jh1vaA3cBem6TqNR1arnY6Mn4aCEC6rkNnJWxGWJhCUvxLOU/rBbeZy1F8a/ZsE8HxMFmQoeWtVglJpWGsj/wVynup5IB5k/kcufg8SmW7fIuDWuHZ8jhGFxbs7K9AsUAqLnCktw6heK0ddV42JOc6Pm3HPTfe71fzMvTZ0zkCnKSIsEnzlXGpaX1h9l12DjDDN/FX8vurNslMwINW8VUc9chypGOkMCDm28Kj7Ct5d+oJBDZupmMTb6L90ILiuXPJnhbOv0GMAQBZWIjTMllvTb6ciVf4dkNLChRqRHRZtoo3bxeQCcMhV06Q1Ou28f8y11vQJ65delX9ZyPQrIKmhNto6D
 7qDgdfr/
 KQVNni02ASnSJZVb2HxGUgKvAaUAfJJculrUFZFlvn7hJWI2Qyshh0IiOYUt++Uy0BSZbkgoX74C4392XF7UfPinDeySGgrzex8dmFtR+ejXpWB8X3gXGvMJPpPjocpzYNi2NjyAriqnVjCXZ5CpD9GXv+8i5VcXmfZYogo3TFHBk5xev60k+QgO0cOCutnLv3IedIhipPxHuqPSwjigkZEMTMujo3euwxDKaMbRXOz1fhfT23AjWYiAq0ASantdYQbA9gfizYBjjR8I1P2abM8hl5bGkPnCcdkRTqb4cwpIqsFOSSluZpSa91UTT0KliUTUm9QHlQ1UfYvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_activate() does not flush TLB after populating new vmemmap
pages. On most architectures, this is okay. However it is a problem on
RISC-V since there the TLB caching non-present entries is permitted,
which causes spurious faults on some hardwares.

This seems to be most easily reproduced with DEBUG_VM=y and
PAGE_POISONING=y, which causes these newly mapped struct pages to be
poisoned i.e. written to immediately after mapping.

Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
and call it after hotplugging vmemmap, which gets the possible spurious
fault handled in the exception handler.

At least for now, the only other architecture with both
SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
problem with newly valid PTEs. But there flush_cache_vmap() is just a
ptesync. So it should be safe to do this for generic code while having
minimal performance impact.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
Changes in v5:
- Remove hook, use existing flush_cache_vmap() (Muchun)
- Link to v4: https://patch.msgid.link/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn

Changes in v4:
- Rebase on v7.2-rc1, drop dependencies
- (No code changes otherwise)
- (A concurrency fix for mark_new_valid_map was sent independently)
  https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
- Link to v3: https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn

(See v3 link for older changes)
---
 arch/riscv/include/asm/cacheflush.h | 3 ++-
 arch/riscv/mm/init.c                | 1 +
 mm/sparse-vmemmap.c                 | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 8cfe59483a8f..e935db27f09f 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -56,7 +56,8 @@ static inline void mark_new_valid_map(void)
 #define flush_cache_vmap flush_cache_vmap
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 {
-	if (is_vmalloc_or_module_addr((void *)start))
+	if (is_vmalloc_or_module_addr((void *)start) ||
+	    (start >= VMEMMAP_START && end <= VMEMMAP_END))
 		mark_new_valid_map();
 }
 #define flush_cache_vmap_early(start, end)	local_flush_tlb_kernel_range(start, end)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..1b4f16704133 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -24,6 +24,7 @@
 #include <linux/execmem.h>
 
 #include <asm/alternative.h>
+#include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/io.h>
 #include <asm/kasan.h>
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 99e2be39671b..ebd3ac997f64 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -564,6 +564,8 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 	if (r < 0)
 		return NULL;
 
+	flush_cache_vmap(start, end);
+
 	return pfn_to_page(pfn);
 }
 

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9

Best regards,
--  
Vivian "dramforever" Wang


