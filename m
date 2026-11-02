Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691C5606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dppISlYB
Received: by kanga.kvack.org (Postfix)
	id 7B5AE6B00EF; Mon,  2 Nov 2026 08:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A676B05B8; Mon,  2 Nov 2026 08:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C846B05B9; Mon,  2 Nov 2026 08:45:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E66D6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:45:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1FABC0B72
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:45:27 +0000 (UTC)
X-FDA: 85390301094.05.B9A418B
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf31.hostedemail.com (Postfix) with ESMTP id 20F4220005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:45:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dppISlYB;
	spf=pass (imf31.hostedemail.com: domain of alitariq45892@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alitariq45892@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627126;
	b=nO2kwyLh44Q8TtXUbsx0B4xtr/ThCsc8/TidlLo6gOBgmu00m2Rx+4gRX0wWnqfgJE+MDA
	IPHCxxoOk94al4BcxaoAcylK8FnaBksIchXSVBwgprY+sCeKT6fVhIVhPlL0itHxXGVISv
	DaHDgdfaIOlwA9RIrzmCqjqg7XnElt4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dppISlYB;
	spf=pass (imf31.hostedemail.com: domain of alitariq45892@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alitariq45892@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UUcrbJLOOZAs9Qd9MyHCkEc9mio81RdYYZ8wU36Zvg8=;
	b=XR8/CVwxoeGXGS+CP0aTNEvcck52UTMRyZExyDYnYUp1JoA1MKiLU1APHLcnvii/DJFbOk
	67rHmNvFixX+phcKqk70c/9NffaJPaSr0EgNfpx276ELkdytqXYd9wh4Cq13W5Ar/qXqcA
	Lg6lFi4RmKDdjkjFgQU0VEZfZOr7L9Q=
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4a16dfb8fa6so16971825e9.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 05:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793627124; x=1794231924; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UUcrbJLOOZAs9Qd9MyHCkEc9mio81RdYYZ8wU36Zvg8=;
        b=dppISlYBDLhd10vRkXMicJ+lTRUTbE3cZ6zeaEvznvUEvWHvt9GoLQGsh2Obeqb1Kp
         TjrRz/bXrYUPTksOnU6K2KY9oP965nCjKcIh57a5BXUBh2UAfCP0589cLg991tGQ2iNQ
         jYHPQv+aMSk3ksufzKPAGusiVG/uazaWzp4PDJpYqA2hp3oMHSfXNL71yW+DU4tVIRNb
         G358RQCIHqAd9tizQfWkv8zSC0o5o/AJVKW0TuByTEsX3NBkcricALbJ9p87Zh8op2jD
         91lohkJb4gFF1YLj0oSPoVkeCcGv+NezdlvlMG+Z+damJIzvoriHoHSrWsac89cEX/Tb
         pKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793627124; x=1794231924;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UUcrbJLOOZAs9Qd9MyHCkEc9mio81RdYYZ8wU36Zvg8=;
        b=Qno0wBDIZPKlH7jc3pAwOB9FwE7oNMALpGJd3TO9lVhAomhs4+GI/Y8r5c8heiq97l
         7FWqS1XMi6LDUEPZZx7YJnVin+y1S39+Pvjyit87ijpsE/2ivoE0ErZEhGRBB71YXU03
         J2pAdeOXKJPvMTJlqu6oKVJcvG+jsdlUxqsM1E7YgDdgcC3PcgTHmqJumsLaQ1iY5rL9
         8FWjI6D97wIMPmr5R6qSGloX2eFboaMAs8xA2q8IquQMyGhKX9+NwR2rSVbvVZhtRD+g
         mtTbelASt5Bltax5tZJG+reL93vPUbEgWrLoVjd8ayfi3vSKNJj9CLVuF35n6Xh7ODot
         asoQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJ25kPx8SkU6xB2E+PteoHWxbACCsCmZedMSJlcIklAxfzhyXk/i+/ZiF29Bt6tdvP+6Qm6Ak3og==@kvack.org
X-Gm-Message-State: AFq9FYJzLbpp3Vu+RgxwbPCO5jqjzyXSZWlfojFUyigSuse59mNyGZ/L
	X8RIyoAlWjD/5xQCebC7iFIv3jPm+sO4iORnK/HwCwaqvoKLZ9tpOuIp
X-Gm-Gg: AYBFou1/t5Kx2I8Q3boeToFJhnTe5s2ilSPhnvv/lpsAEQmHhKJ1LrhiQK3CuW8kfIU
	Fbz3x90bkLT6VlxJWQaZHeveMA2m57FIitkaBOZMHemNMXHYC+NQ6AAhQ5EraqDsK9zJzMOB/r1
	Gy5nhpDHk31K0U7L69q94u3JTSpEXYr/bRlWUcp4A6QNlVex6mSz5etIcECU3HJpbwL1CeucELS
	ljPJmjfpKRNFGy/6579gB6VmL4AYN1RRV6y0WXkTNrx2IR6MdL2zOMSMkx07C64ObVUBbBsvFGd
	Onroobl3VfPGmf7LNL2eTx6O0w/mEyVLGKePBiWfiNdAvkDmnP8hTPSSeHtZl0uUHdGPDg3N0Me
	ZzidybbVaJX80Zr/L5kEAkIZia/SrIfjpwb7Uy5J/p61fzxY45AGYh6zs6ZX2shOR//7J7d00dp
	0bAtykH6cbY3jEZ8z+UMa8npCiErGty+6n9uZa9q2rHQitK1mGVt3+nC/gaU5lEOMror/pvIuna
	So1jyKXQ07+evh6RM8aCCxHKMgS7RYusMx4v+vUKgP3qmEvL4jYK9ZwMA1IYk0EIB03Whb+2zw8
	MNUjITt9RydJtk8aXIcFKqPmKhXPv2qgAZpJSRXYhkn98CldTvFzVvs=
X-Received: by 2002:a05:600c:1f87:b0:4a1:f68a:9736 with SMTP id 5b1f17b1804b1-4ac17b2be08mr233027865e9.26.1793627124284;
        Mon, 02 Nov 2026 05:45:24 -0800 (PST)
Received: from workstation.. ([110.93.227.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab61d8b9f4sm319164755e9.12.2026.11.02.05.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:45:23 -0800 (PST)
From: Ali Tariq <alitariq45892@gmail.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ali Tariq <alitariq45892@gmail.com>
Subject: [PATCH] riscv: mm: Add KASAN shadow mapping to flush_cache_vmap()
Date: Mon,  2 Nov 2026 18:44:21 +0500
Message-Id: <20261102134422.610837-1-alitariq45892@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 20F4220005
X-Stat-Signature: rfx4j6ak7fbeqew3nintxfkbudcyksgy
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793627126-643124
X-HE-Meta: U2FsdGVkX1/jA6i9mhO28JAZRLvgY2xsGqAujDWd4yK5/8F8uJRnmch/+1apfP88iwALd/A+QXsUUJL1J01pkBCnOShRD21vBmCbIJJGQlQlNB/clOrbECK05cirb6+lFLCqMXEaHfeRyWxfwvM75C/iOTZTHqH/1Gd9vE37lP3IkN4KxNU1AQVxMi1QmcFnjFAl0BSNuAr7iZtt1kNUsA9swS0mdi2Yvej7nHJWw8iFd3Hr+CZF6z7SvsIRkZCM9S5R/a3GmkwQYHekCXFAXnIM60izlaYwt46KGP7hYScTzLS3acMf24waYRb7onRz2q5NvLn4Eqz6VlMlNZsb+EaBx7VdeThjdHy+IPTdDUY8KD6ZMGh2Xf7DrWVsialuxw4PC183/jHHdZv+CmZHAVAADgSq+eBaSDz0CmNdmjKvkVxke8L799RPu9FHYPZdh+R/hH7FOS+1Vj79u+Z1rD5lmzUNPEXiHQlPHFWhjZYGEhyl9vOZanL9B4hYzRn8ixKhJIhEMeyHLVKFpj03DBCQJqs/evs3dN+3pWUepeiORw5079CT9kdh5eaYULoFXBX1Y6hymfdNAVfPhsfS0bOQtiwsQ+r3GRwxYciARPl4qCp30pr55a1TWsCdfCm/Ya3qBZnMSs0hbK4zAJOvt6/dYPqdI4EMZzL7dqbJfCisSFsFePPKYCczTMbLsdj3Jqe0vSjoyBx/s1dhWV9LpX/GGDVjcw7VD65HV7VY0JtRLJZheYk/v1uHbG09U+rArcurMU7/JuuMLxUxAvKBdLPWTL0d6P04lel8m62Oa7acHR7TZpzcmAJbooihfGhOfN9+dtKNyYqUzv2b0mOJN+oLbxwRCJOM2VyKa/6ZH/ADpkKPjEA0ATBDa+nrVz6l56evGQSzeCRFM/u5Ljdesumd+VgydwtsPyDD4w5WOT3YV1LWOtsSCx++rBNEmCc3xYnKffOaqarOQxY9gEg
 uh5VGMnM
 You5rrA8/rsYJPlzQ+vhva/FJEWV3v8ADo8Z0Ppkc6Yj8otVZhJcKv3J0pTVY812ShZq8xICKAmfalx+28CVUXfQicnw14CAH/H3JZsJCtrFopsZoQiAy+naOsCfJ0Z49wLQJgVmIKChCOZnsHPSsb2erzwciEeWmIp+4sTPfrwgRSNCB/IVUhoxt18MgAE3bOuqBWxeM1hCQIs3fJx3fH9GHNFAlnhBp9ThmlWm7eTD1lezKs46/mc5nuiuUhEo/av2XSkLf1JPVy3TV3k8Haa7flUpo3HsppTwRzRJmper4125bFgJ0FJqBZmxlVNru6XrUqbUNc7YWC8VS0EN2OnYCCQdMAU9Giswn1QkDLdE8m/hHlsYa4M0Mah6K2tYHIT3TACpWS3N367xIEZIqmrxcnSq/Ql2wih6GquM/oYAHcsVnEZaOE6U4pztpvTkCkQURQERv6p8z+T2AU4k9qmWfp08HpeN5PK5Bm0nah9VMR8eJmGtQPmrepZ+SQtqFsjmchqx+tckfcvpfKrYb6BY8RIhhwmLcrlLLS1kPHYNX3a3qDoQ3Ujtc1dIiUxVbkKnIDhPpwk/+63A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

flush_cache_vmap() sets a per-CPU flag, and a kernel page fault
that finds the flag set gets an sfence.vma and a retry.
flush_cache_vmap() only sets the flag for vmalloc, module and vmemmap
ranges. kasan_populate_vmalloc() maps new shadow pages and calls
flush_cache_vmap() on the shadow range, so no flag gets set.
For vmap()-style areas, kasan_unpoison_vmalloc() writes
the new shadow right away. If the CPU hasn’t seen the new entry yet,
the store faults, and since there is no flag set, the kernel crashes.

[    0.675216] Unable to handle kernel paging request at virtual address fffffff7c009a000
Current swapper/0 pgtable: 4K pagesize, 39-bit VAs, pgdp=0x0000000004504000
[fffffff7c009a000] pgd=000000009ff6e001, p4d=000000009ff6e001, pud=000000009ff6e001, pmd=00000000400e7401, pte=00000000403cb0e7
status: 0000000200000120 badaddr: fffffff7c009a000 cause: 000000000000000f
__memset+0x60/0xfe
kasan_unpoison+0x26/0x4e
__kasan_unpoison_vmalloc+0x20/0x2e
__get_vm_area_node+0x1c6/0x276
get_vm_area_caller+0x52/0x84
vmap+0xf0/0x264
dma_common_contiguous_remap+0xa0/0xd0
atomic_pool_expand+0xb6/0x310
__dma_atomic_pool_init.isra.0+0xf6/0x1c0
dma_atomic_pool_init+0xf6/0x1aa
do_one_initcall+0x134/0x928
kernel_init_freeable+0x532/0x60a
kernel_init+0x28/0x162
ret_from_fork_kernel+0x82/0x94c
ret_from_fork_kernel_asm+0x16/0x18

The PTE is valid, so the mapping was in place when the CPU faulted.

Tested on Orange Pi RV2: without this patch 2 of 30 boots crashed,
with it 50 of 50 booted.

Add the KASAN shadow region to the ranges for which flush_cache_vmap()
calls mark_new_valid_map(), as commit 4edd70ee6a7d ("mm/sparse-vmemmap:
flush_cache_vmap() after hotplugging vmemmap") did for vmemmap.

Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
---
Crash Log: https://kernelci.cloud-v.co/scheduler/job/541
---
 arch/riscv/include/asm/cacheflush.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index c2b0a2928f06..c95b2f6007fd 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -8,6 +8,8 @@
 
 #include <linux/mm.h>
 
+#include <asm/kasan.h>
+
 static inline void local_flush_icache_all(void)
 {
 	asm volatile ("fence.i" ::: "memory");
@@ -57,7 +59,9 @@ static inline void mark_new_valid_map(void)
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 {
 	if (is_vmalloc_or_module_addr((void *)start) ||
-	    (start >= VMEMMAP_START && end <= VMEMMAP_END))
+	    (start >= VMEMMAP_START && end <= VMEMMAP_END) ||
+	    (IS_ENABLED(CONFIG_KASAN) &&
+	     start >= KASAN_SHADOW_START && end <= KASAN_SHADOW_END))
 		mark_new_valid_map();
 }
 #define flush_cache_vmap_early(start, end)	local_flush_tlb_kernel_range(start, end)
-- 
2.34.1


