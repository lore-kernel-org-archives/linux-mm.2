Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39CCFD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBC26B008A; Wed, 25 Feb 2026 17:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73086B008C; Wed, 25 Feb 2026 17:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957C96B0092; Wed, 25 Feb 2026 17:39:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9296B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:39:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F78013B9D7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:07 +0000 (UTC)
X-FDA: 84484445934.13.5F3C604
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6AC4240006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eRx90f5O;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lZvVwm+F04xN8ZkK9KLgYq8/GMMqb6l7a/In49g+nU=;
	b=Yb/DZZrrPknqFZ4cZtq7CK7C64vp5SuYsavTNqTLuBoUHqeBDjLkHLxzlhEauz1MzwojZ3
	nFu6gPaewyAE8I6IpXVO4BFKiLRgN+Plw4xE95lFEtrMu++THJGf1gWdK0niioByRKtDBO
	qHUbHjbAjJFb9mikUhubv5Bldvw3t2Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eRx90f5O;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059145; a=rsa-sha256;
	cv=none;
	b=lvqGga/+Nlf/AkPkILum64vNSO+mtDqbXHl7DnCt7bI3VA/V+GteFtiSGB5ru94y1kgeKs
	1UgniZhn0jhNJMr9NRYhXSdECelYOMHEvFX1pT46rvzqHmCRBwynifZcXZt2Y7Sk/OfXFW
	VfrI5/5wwj4w2IDEaJ2roJ0KQCvn/Rs=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7986c7b8076so1627877b3.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1772059144; x=1772663944; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4lZvVwm+F04xN8ZkK9KLgYq8/GMMqb6l7a/In49g+nU=;
        b=eRx90f5OMEzZjJMYccR8ivIQQ9K0o6YopZ+LUCPAIoJv7itiLjYWvHl+o216FwmtxC
         gDNARvohRwa0KtMyvpNr3Q3hyZw1R/2u7ajZ6hlJBnGn5GIDvgJ2ss9RQC0oPu4E/+9N
         ULQtmDRL9CZN5KxbCtx0JBsTmGg+NkL7Cs8ZrHuD6r6szmj6g1qdK6Nn/PhLOLnvVcWY
         DiOXgV2D6AsXdhPOjCpk0WtT3O7m6cmtUjoqiD/FZI8HPqPq7F/exvW1lG+1UYAGqAZE
         58jl8Ezx4buUxgRVWQjPhyWlQoA6GEJTnN2fmr/7QmfSYY47PF6K+vpr5Zw/PkvpDroX
         Iclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059144; x=1772663944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4lZvVwm+F04xN8ZkK9KLgYq8/GMMqb6l7a/In49g+nU=;
        b=LKwtdKQij4OMGZd93yxGlD/6DG8Q9+gf3+7Gj1/YqYzIlVFKuje5t6ZWhm+np3s4Yi
         HmI1/UfSsYOhsxetKqiCaeHMUfxsnTplF5Sh5SscdAIiQqIKdo38hibfCYaQyXhyYgl+
         TIrPR7oYyXDHMTky8KVTLmIn7USGA7FA8qKjHdkdPj2ge556eVv7pZZQYW9ns9TUlAFp
         CzT/fVX8IX06+xEDzHQ62PjNJVu50wrK5ypXYTYbqeWyxOBh1MrjG4lsaoXI1OcARQ4J
         jnPw6V31sXps8eL3olV1wiVOM8ODBXMAypLqTUI2XLd0V39FFkKMj0LmUeYU9W/ZYUnJ
         uF0A==
X-Forwarded-Encrypted: i=1; AJvYcCXQZ9cm4CwkoqCVjPzN5Tp9GpvxgW1l9TX3PqaC8ZeC0MfMJ6/K8Aih0sWU3mMSnPV2VacTbCAq8A==@kvack.org
X-Gm-Message-State: AOJu0Ywzwy5ysziKANWETYAI3Bga9oVEpsaGGOeIyxgpOdNzGTrgPvEg
	e/tzHE8elFwPTb2cmU5j69IKtbfSuJYtc/EVaAVcdpYbPY9uuyBTJtHq6YFiAeMWbLk=
X-Gm-Gg: ATEYQzyw7VYk9qd33TnwZV72a5k1EO5Bzf2gXCJgsA4qtI/t2gacQ6cb6ZxGu3QYPH9
	yOm8jA6wSWxNjWOn65QA2wBJbUDttKy4weVgoNlSbz6ni9ZTsDLmoI5GTair3d4LjK+Gmh7vdUN
	Clp7/szLxcPI+hl7aqF6h+zJOXCTVW7KKcl8OQPUL8CeGtgVKiMEGpOnD7m3Non5v8/ywyK07Iy
	LL16HuqFaeeKquzru07FCdvrWHSx5a7/Jnd9Bpq1to2io8pIgzFGTp3E7UFFoF9hEw8EwP93DLw
	1etPG/Y9EzcZFnbIA0SqaTw1yDCovnVnyZJ+EC6lSeYRWmKozscRQJ87OyF58msgiTbm5K4TPjm
	WcevGLGS/rmvKylGjBb5LMIbjQg7MS9MT0XsoTfP+uGdu2cM1AEsHx7XEhDXOC1/ccW80VZFeH3
	upMlPxF8hMuIE4nQMN8MBbCEnDJcAIjXLXgElQGQxe+UT5mP9WnvizVqG7lC3kwv1hjWuJLXBhY
	ftOSbyOfz9Mr2X6s7xBe4tzfsmGZurcB8mZMjVoP8xYaITpyQ==
X-Received: by 2002:a05:690c:3513:b0:797:ef49:a487 with SMTP id 00721157ae682-79876e3fc70mr1675837b3.62.1772059144413;
        Wed, 25 Feb 2026 14:39:04 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876c992b9sm918297b3.50.2026.02.25.14.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:39:04 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	urezki@gmail.com
Subject: [PATCH v1 2/2] kho: fix KASAN support for restored vmalloc regions
Date: Wed, 25 Feb 2026 17:38:57 -0500
Message-ID: <20260225223857.1714801-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
References: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4gosouphzbpz1xkztrr1sgrqaze54fy3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AC4240006
X-Rspamd-Server: rspam01
X-HE-Tag: 1772059145-116199
X-HE-Meta: U2FsdGVkX1/LTO/WZNRvJ3RYoygn4km0esiksqKEZ70Z+0bESG89lcKFOt7BgftHTIb1VwO6TcISxQA5gx8h9NIw1vTYW6SQBh8To8sR3MH+yqKETrH2t62+zfD4cUh0jZI/MOON3WtrzNI7aDgrN1J0ho/OlWM3v+Z6x4VGigZ6NNXVQ0uJurV9blw+rJH1hoHNGTfoab4LrQ8MVZVUv/YAT3n3e8ZGOXgTImnoL+cfZzkmhqx4u0O9UvCFDqC7Omnr5xtHieaEMv+HyQbVywDZpMLvHmB8V13ve6YEAewiPmxXLZuaIWpzcgrnOKE74JhsPPqVeSeok5Rvrj22b9LfD8I9X7vIWQRrpfokm4/fSAyiB7Oip4hnw7Q9oQO26ml4jcUn/vYPHy50qNZDcsH77GtwRarjPuRXxL4OeGQvmmRzi0XNEMITix0k5Cx6gABZw1a2mVf7HsMchnfgD3/eJ2lwe4W2AXJvJytZcJJQvSrK4t553JW39pGTzR/Ei0YFxQa6ttKZasODLEAkqt7u7FRTVAYfgfsFYSGNMT08Epe058p89IB/gb5IOMPGi1VExzjKYqHRJcsO+p9EKwo/5/qjcrQo7g7MZPer4ywxo+31fUHIrM15J/F4kEdw1mlShqnoDVIZ5UboMHoQf9B9PO2cxag8sVVDgIwbZ36nFbCyRfY2CLrm+LV/HyKSaqK4Hb3BZvT1ubf1glAK426tFCqt9S7NoRXtp6fD7c00SfMg9hVRRP/MDGXKvLBTxw4MgV2UFhSozBR3rVkXEa8ivSfBEHM+n8moiow69DkDPCXUBFzvlPG047yGGalVelOaBsbcKXnnu5rtnztuIXtXoTdVxxchfG4OvoXBjf3ShGlbY9X355mBHXA+ihmFRc2CJvUIPHaDJIqr2bxO5VXHTR1Upjwo2BG+k/YMJr7ZIjm8t2xksSlXXWr02SFgXuyZ/8VQMQHRL6rKLay
 4L7sN5O/
 E3yRWJgkKzi4byjVeoYQADEfmAI8JOTTHKPdODaoHg6GPUmONoGFQy720Q+LVS0NozT7UufQIpdF0845pmpC8G4Qn+Y5fr4I1tos/NIuZgArnsXaZcFaohGs+rEDuFesNMd3yiHEmnjN+eslwe2YOYCkSLgUVqCXgPEXUMyZRe+xpFXJRJpUAb+MGF27L0Hw662H6Q29gkFofgybSaPvx4RTXIrDYBhHSqxrSxrM9FxNTACSDkjZsn1K885uzrQBSYY+ALyUmrC+rmRtZ87/ncOqvjdmV12kWs9ww3dCfLoY9Q4wrdrvKwrG9CjxdmXFAjZEvAyNuHuNXROr793sBwxTBJbdSMEgDG6ZmHMMt/T8egpOfYMup4i7rlQ0gXQ5hPlML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restored vmalloc regions are currently not properly marked for KASAN,
causing KASAN to treat accesses to these regions as out-of-bounds.

Fix this by properly unpoisoning the restored vmalloc area using
kasan_unpoison_vmalloc(). This requires setting the VM_UNINITIALIZED
flag during the initial area allocation and clearing it after the pages
have been mapped and unpoisoned, using the clear_vm_uninitialized_flag()
helper.

Reported-by: Pratyush Yadav <pratyush@kernel.org>
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 410098bae0bf..747a35107c84 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -14,6 +14,7 @@
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho_radix_tree.h>
@@ -1077,6 +1078,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 {
 	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
 	unsigned int align, order, shift, vm_flags;
 	unsigned long total_pages, contig_pages;
 	unsigned long addr, size;
@@ -1128,7 +1130,8 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 		goto err_free_pages_array;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
-				  vm_flags, VMALLOC_START, VMALLOC_END,
+				  vm_flags | VM_UNINITIALIZED,
+				  VMALLOC_START, VMALLOC_END,
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
@@ -1143,6 +1146,13 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	area->nr_pages = total_pages;
 	area->pages = pages;
 
+	if (vm_flags & VM_ALLOC)
+		kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
+
+	area->addr = kasan_unpoison_vmalloc(area->addr, total_pages * PAGE_SIZE,
+					    kasan_flags);
+	clear_vm_uninitialized_flag(area);
+
 	return area->addr;
 
 err_free_vm_area:
-- 
2.53.0.414.gf7e9f6c205-goog


