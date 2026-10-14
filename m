Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472DECC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AD66B0088; Wed, 14 Oct 2026 19:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB966B008A; Wed, 14 Oct 2026 19:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802456B008C; Wed, 14 Oct 2026 19:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E426B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:32:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C57FB1A084B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:32:19 +0000 (UTC)
X-FDA: 85322832798.15.46462C3
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B19D1C000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:32:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L7y4yACV;
	spf=pass (imf21.hostedemail.com: domain of 3ABHQagMKCL8ws0lttlqj.htrqnsz2-rrp0fhp.twl@flex--rnv.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3ABHQagMKCL8ws0lttlqj.htrqnsz2-rrp0fhp.twl@flex--rnv.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792020738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1vyxJK5dhp3E9yMYQ+C02WBZZsNXKqmgC5RjWaB1Qsw=;
	b=i6JJBj3QtoKwZrTNFc5IROI3eEfXkn87zEeLBq21Et/5fJd/aH9ilMC3SC42vQpSbHtpOE
	7HYG1OzKo7wYkfg5UOHWuChh5YPUt3lX1lL3jRZLS0PsvThA+Gkt9K/UIazY/xpu+Pz8jp
	lm8rfXknP5Ko6n7F7EMOaBFY55CZa5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792020738;
	b=bo03FFiAQNcZXhODyrg5piUleu2BHb8rUfSx34dUb+LaEmzkl8CkO4OaWZoApMi57wf0TR
	oDFXEclxdbMpllLlA5tzO6dBeGTT16ZdYQ79X7do0fA6h+uv0VSZpwzsoMishLwREwsJ+z
	8OgaT1cPVKhQSjBg3aTpdqQOD72MZlA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L7y4yACV;
	spf=pass (imf21.hostedemail.com: domain of 3ABHQagMKCL8ws0lttlqj.htrqnsz2-rrp0fhp.twl@flex--rnv.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3ABHQagMKCL8ws0lttlqj.htrqnsz2-rrp0fhp.twl@flex--rnv.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso9877178eec.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792020737; x=1792625537; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1vyxJK5dhp3E9yMYQ+C02WBZZsNXKqmgC5RjWaB1Qsw=;
        b=L7y4yACVO9IZIyPff0r/NcZzcAekQTo8pxutUx/e7TY+jC+z12vl98hcXDttmn6eFB
         zfXap9Vw00g3jsA0S4q4nG4EkZ1UJWKvLl2QmtVC6sQfYMfgK+Ji3L+SXXQJXCd6ccYt
         RcBEHWNA7DCJTvqnMQJGSAi1VlR9RXhRa96PYCJjuRVjV9d9ImEOfT6XKyjDblPJlUEK
         ORHk14uzu3QXkzOlFi7L14TNRKveAu3uZu3Xg3N1OBIjiea32k8i7ZuCf//m5oRTGg96
         Gz6X1miFpurylFn1o+C5RECsXNs1grR8vpQ2XXsZ6FKoHRa5LV0tX3h/fTUsFUj5NscE
         vYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792020737; x=1792625537;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1vyxJK5dhp3E9yMYQ+C02WBZZsNXKqmgC5RjWaB1Qsw=;
        b=tx+O/qRNQQKg/Ann7oXb1kIBMD0bOvFJyF6vNKWLXbeQOa1PxH5a84N8fQ5RTM+3qa
         Ix7PigHFmMO94K1is5rQ4qtVzzHraSlJ7/v9oC7j7Jil1NSScKDcpcInLLPMfioFTBRH
         dzDQO7xCZZAn8MSlGBX66EVwfwXYFOeNYI4Ay4Loc7EmtIHP1+mKvYsrc1KTpkKAhdIY
         Siz3gnqLVdbLbF4y2/3sSr/5ncnGPuRGOLQLy+o9R2FVQYVMysjozHcXwPn7p0Nr9Cl/
         Igc0pAsYK2vEYWekSNE5sDkWqoMDd4BdqYsxk1Y7KXDCaKjNMPxme+JMit6ZS6ogIM9f
         AArw==
X-Forwarded-Encrypted: i=1; AKwUvBybN6z8xVWS2vFYs1IYVHMqQeO3DGKEeiBflbaJIg4en4oxdG+7A209/XioXAq3fT3KRG4CUD2fyw==@kvack.org
X-Gm-Message-State: AFq9FYJ7WdZzD7iOuoM9vkvaJ+LhqTIdOj9sUP7HFs7O/22sco2WeiUU
	vVCZ54dMOgm33sQYN3DOSTKsQ+IlxURPFrWMMenrjBtBv8XldWzg5k0SzqMMLFLuX7OdrA==
X-Received: from dybgo34.prod.google.com ([2002:a05:7301:25a2:b0:35a:12b0:9f72])
 (user=rnv job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:fc0a:b0:351:7ec1:a92c
 with SMTP id 5a478bee46e88-3537e11c9c5mr24624253eec.28.1792020736275; Wed, 14
 Oct 2026 16:32:16 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:30:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261014233058.1410692-1-rnv@google.com>
Subject: [PATCH] mm/execmem: only free ROX cache vm_struct when fully unused
From: Arnav Kansal <rnv@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Arnav Kansal <rnv@google.com>, stable@vger.kernel.org, Rohan Kumar <rohakum@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B19D1C000A
X-Rspam-User: 
X-Stat-Signature: m7a9tkfar4mieu7q3bo7umqu89336z3e
X-HE-Tag: 1792020738-538761
X-HE-Meta: U2FsdGVkX1+UHpc848yYunUoL/1niMdAMN/+nixi7HHJHSCbgww2QZEL/YK4qSQPdLYxZGoA+4LPMd8Ai8mwOeis0zrnZpLgvLGkoqCwwvkUW6RA4EZtmnLOXauVeAd0foCoR6GCntmqwlJUelTJ3JMADOIb8LrHmLYxaoG9x8hOLvD2wZ6Th8cep6KD8EuFIEQA4VMP4M412gNsh32GxTcy7VivSkD2e43hmUOvmB+zP1jyc1vs1ue5YLeiAc1qzfYoctB4dXXHHz38utQgs9R0oOnMkoyE4aOV/QPc+OyzTY4ZQudt+6KB5NpdX7ivLe9oEc9cWsg+v8f6br5F4l9n02vIv/x1XKYOpeznss1I0u8dQ5j0No+bYB46GuK2NDDTW4P/Y5fAolatEYO01LBIdgQA7bZSt7eSlFwGphlSe0OteyT6N8IW7ojYBldgtC9gyqAg8vUvL9VpyVtrI1E87T3WmrJZu/Q/q2L3TkFR50VDsPvFqIAm2Ip9iYFhwT86U3Bc04BMTM0aLiBmBg8WDQTvS67z8cHV+8j3SzbKeYCOnFORhSGbZJmEt8+fsqLZAj4P9km38+IFo7GH7tyM+FYvjR3ptwDq/cSgF7WUzpGrvJ1rlsj+tkPSpPCwmUIKTo1edpOrmDrETmFmOgq9XLbq+TENLIIjo0MJ7pbAQQyQ2N6HcpXHMAkPRLvx0BVLgOYGTMWVSu1IN86IO5E4WdbApq7FxxW693t6MiQupi7adWA2SS1DX8St2RwhT1PjmoyFpWYyIF6r7AYgcaJJUWs5x+nh9STVPNRb8VIv18ODwAj2SC2CG+sK2aR/HZJHGjj71q0eeL9zGaPnLVmjYErpShJzxyS2K+inY/5PvJRmKIRvlCpdRzpkHrZTzXrce9J4cVHvl1neEqLg/muXvWJvLbUAiCcVhZIOWwIsILekddTEPedey4kYjThgyiObIzuZxNZm0HzizLj
 DHqDd3d0
 Wb0KkaCBIrDFlWzWy+gKEQqUvoenlgCxj+SmBQOLE1ncyGaTMMRb79FMI3xpWlBzSH365AqR4qnI3msddQMxrR7PZHPzLDd/Nm2+lX97H2+wHsH/sc844DJulQmoX61N7L24jdtiS4AXPn7EVQIYEZ9eNrjZvWVaPAUrEgwkiNIcfzSZVTnx6uIZQwLzqVDkyq6zEV7/0p8b/ziby6tQt+eB0AuVIS13eLC6vLw0pNMqsi1y0lgKKSYk3RmqCW9OtbKJp/Kc7O/grc6FrS9N/9+UazAhq9fFEMFHVpp/ie/vogYwXYzl0eTfrV0ryGZPeMz7rY0dPLgOrd5NQaGj+N6u5ogVm3htm6glC1db602+WOHd7iQK8Uhor21itQy9gZEcr4/ooZjlpuMETTrnd+VAzHCro69ScGqdDT3bX/+09WFWy9ZbokiFlDw+naYBoLIcQEZKteHgrC9kaEH1lXxnuKj/16GLXiXUBUfHB5kHjh0//hLHXOF54r7oyNglIbX+/GUPJlYVcZ7PkL5mHcGHs3k058I5Ub534D0Y5sNEHGO4de3IQPQ9zXGu/tun9T3WfJ1+kA+cd9Tp0zdinlaPlLIH+K+6L/kDZCc2ZENHoRh9arIpT0XGWaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

execmem_cache_clean() currently uses:

    IS_ALIGNED(size, PMD_SIZE) && IS_ALIGNED(mas.index, PMD_SIZE)

as a proxy to determine whether a free range in execmem_cache.free_areas
spans an entire unused vm_struct that can be returned to vmalloc.

This heuristic is broken in both directions:

1. Premature vfree() of multi-PMD vm_structs (Use-After-Free):
   When execmem_cache_populate_alloc() services a request larger than
   PMD_SIZE (for example, a module with > 6 MiB of .text),
   alloc_size = round_up(size, PMD_SIZE) creates a single multi-PMD
   vm_struct (e.g., 8 MiB) whose remaining tail space is handed out to
   subsequent module allocations (e.g., kvm.ko). When a module inside
   that vm_struct unloads and leaves a PMD_SIZE-aligned free sub-range
   (such as a 2 MiB or 4 MiB chunk at the start of the 8 MiB vm_struct),
   execmem_cache_clean() passes the IS_ALIGNED() check and calls
   vfree(area), which unmaps and frees the entire enclosing multi-PMD
   vm_struct while sibling modules are still live:

     BUG: unable to handle page fault for address: ffffffffc07dc030
     #PF: supervisor instruction fetch in kernel mode
     #PF: error_code(0x0010) - not-present page
     PGD 2c33067 P4D 2c33067 PUD 2c35067 PMD 0
     Oops: Oops: 0010 [#1] SMP NOPTI
     RIP: 0010:dummy_exit+0x0/0xfd0 [tailm]

2. Failure to reclaim fallback vm_structs:
   After commit 3bd4e0ac61b2 ("execmem: add fallback for failures in
   vmalloc(VM_ALLOW_HUGE_VMAP)") and commit 4afb85f5e359 ("mm: remove
   PMD alignment constraint in execmem_vmalloc()"), ROX cache vm_structs
   allocated via the base-page or exact-size fallback paths are only
   PAGE_SIZE-aligned in address and/or size, so they never satisfy the
   PMD_SIZE alignment check even when completely unused.

Because vmalloc allocations include a trailing guard page, separate
vm_struct allocations can never coalesce into a single contiguous entry
in execmem_cache.free_areas. Replace the PMD_SIZE alignment check with
an explicit check that the free range starts at vm->addr and spans the
entire get_vm_area_size(vm).

Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Rohan Kumar <rohakum@google.com>
Signed-off-by: Rohan Kumar <rohakum@google.com>
Signed-off-by: Arnav Kansal <rnv@google.com>
---
 mm/execmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 74a178a87e75..3a1da0498fe2 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -166,11 +166,9 @@ static void execmem_cache_clean(struct work_struct *work)
 	mutex_lock(mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
 		size_t size = mas_range_len(&mas);
+		struct vm_struct *vm = find_vm_area(area);
 
-		if (IS_ALIGNED(size, PMD_SIZE) &&
-		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
-
+		if (vm->addr == area && get_vm_area_size(vm) == size) {
 			execmem_set_direct_map_valid(vm, true);
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
-- 
2.47.0

