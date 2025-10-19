Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3761FCCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7408E0016; Sun, 19 Oct 2025 02:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67A08E0002; Sun, 19 Oct 2025 02:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2598E0016; Sun, 19 Oct 2025 02:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7800F8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4573F11A6D4
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:25 +0000 (UTC)
X-FDA: 84013856850.09.7B34FBD
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62D59140007
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eEttBAnY;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHtfDmtNu58qaeT00d02kMdjaM8J6l+T+7ap5Uqy+yE=;
	b=tL6VlYvL5oUOHASHbLv4qvEEzdLtW2+sRC4xrYk3vOgWeHc1/vrppmIwbL7uwZemljMVa2
	qfFmYuXHyDJuk8z40PZfNCOUVZewxMptpPI30URF5w04JuaF0hojrC44eh7/erP1uadE0S
	Z14XaJNShpJj4Bua5ChGtsxoTlk9XBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854643; a=rsa-sha256;
	cv=none;
	b=yHJyzXk78GHo2xFcEjJIkfGIMNQlSo7hEbZ8H2I63pZnXMxIyGtvxsqJDROXkQ38osNFzb
	hXFtRLjnLRWbo4vTBD2VKx3e1zKjB4c1S/yo+YZOHM8soulM2QuaA4q4h91dxepyfN7u5T
	oEjrpuI+7Lh0zKshINyubSqHSd7YGBA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eEttBAnY;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a226a0798cso1549059b3a.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854642; x=1761459442; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHtfDmtNu58qaeT00d02kMdjaM8J6l+T+7ap5Uqy+yE=;
        b=eEttBAnYbohNWBoPQhLnqv1U37DWoOuMoLgdAxXKmBjqSUaRHXrZfs4wnlEO2mWKnp
         LvYbZbPcWK5q0oREkzA7+ANicrYT4dUB8vyc796x7iBi/67t4zs+0k/bDAXCZOW5fUdB
         OmEbajhLOeaF3QCSV5e4mbybXbMRtlwVLP6Ei5CF+4YoUAc5wrq/8g9ss1yUwBJhpEGI
         FznjbJ0MFQrMs0yngIIWOjBe5QoRHllpCabd6/b3zHfg1QeN/5dxDAD9v03ZUGRqALvF
         LCpzolFs8C/1JSwjy3fnbKnR356FwxLQmleTgcrgkLo7uAiodfEyf0oQ5onxw2ePkNBa
         oXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854642; x=1761459442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHtfDmtNu58qaeT00d02kMdjaM8J6l+T+7ap5Uqy+yE=;
        b=uqNhJpktMV5jIqkyuAqPFCL53oML6UbJvj0Pf4goqJnlyXH3v8vn88AXNo/zkwCaNa
         P/kFddatqKrS7Pt3SNTiTJXstq0kY9MGT1yRHowcrdd3AMiYKwzhqUtIIya6EheJvP5i
         f+KJlrZeixGeIY9Od2+0D9pt4JmrE4R0MN0N1tKmI1V8vADgUZ5/bU/to2U3PXk0qsgo
         3sl7R9CrAj59Qe0VZZTWOJA9kn1OJOi8GLcp6ScjPauzBlNeW7Y3AoRJra40nCStMwJQ
         Gd3pA053kLOscB53qpiOU5OIS6G96L8VMc/fPrDrueEXmYvaBBRSpZKMk5vciK1YbZuI
         1vhA==
X-Forwarded-Encrypted: i=1; AJvYcCWmj1iT+ZThcFLl6upSLeNx7fpVeZngvmeulR977zHJRPNpy/YA/hEh+a7BKPuKV4sGgy6OX10WUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/bfNVAAaRZ/q3FPTdqJZc0j1khvwW4gvYZRE4irnKvzDFGJxS
	Qs5S8GqextOwQ0x8Bj5hkG6YJVrzy5LwDupxaRgRkRmY7KeClMoUmuap
X-Gm-Gg: ASbGncu6e+nX+VzNiBnVBXSO3yafxnNYNHX265ZqRUc3Gtg8QvriJIQlgXGwjT4RmRB
	NoHJEet2fdEbaNnqfOoA7y/snUny78hy0RizhAWKXM6LRl5E5K59Zp3UKpFm2tLPLEdd8mGU8ng
	gX7pMr8KbRpkEkXroCuy9MoT5jzfC7+2etRGCNv4SPBjEamPit7EbY7Ejup0AKuPXnOM3n627Zx
	7GFXnQfYvHeEA3ohUy7bP00QgeR/bl34C+Xj2A831slYoJOfXIFYdqZPF5M0gxNSjiqhBtnyl94
	RYKwMjmek3k+MaOqXoLd9C0+nZA5BdX0el41ZK5PMcrrTNk0vjMICcuEGWhro7eS5W2vunr3fPD
	U5u0wW2s222/TlxjUZ0TTmBDS90NAvxrMeWszA2n2vVpByMiN8DIsZMleYxKNuVT/cFOSSMlYx9
	WkqkHqHyCuEmpQUO3S1VS0hSafAQ==
X-Google-Smtp-Source: AGHT+IF+l7vrEZFb1JvgrlXqJojLzFTrJb7A2HoVWh6qL7YExVTjo54P1fLRx45jmPuBVut01m7GGw==
X-Received: by 2002:a05:6a20:3945:b0:334:a15f:8d2d with SMTP id adf61e73a8af0-334a8629db6mr11280818637.44.1760854642239;
        Sat, 18 Oct 2025 23:17:22 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:21 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 15/16] kexec: Integrate multikernel support with kexec_file_load()
Date: Sat, 18 Oct 2025 23:16:29 -0700
Message-Id: <20251019061631.2235405-16-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: jmn9y7yt3dbcufzscef8se6fjonbpuek
X-Rspam-User: 
X-Rspamd-Queue-Id: 62D59140007
X-HE-Tag: 1760854643-64472
X-HE-Meta: U2FsdGVkX1+X76HV2Mx6ZBsF/z+blI5HQuPfVzZhj1BB4Iq1mEULa0DwzhEwFlyw6sEMpPYIuyo/V+oGyEdbkrLmxU3YpehIvgSiWkBHFbAj9b+Mwtw2Krrs0ZQvU9E2wZQzFO/0H7izfeY71cxJWX8wJjNy6bS4yjl9IJolCZPa20Fzv40yYYYQ90XBQt1OYMOZzIW7Rtx43mPgQbD71Vtq1IBDsnWMV1soQA3n9Lwpq78KHuk1+ZqBh0hrDWF3HeUZje9x/CCB50eRV6vYXuEpAYE2GuZvBDQHJak3HyUoGNoULAIrWkgMNMceOdyckYT2UobQ+vM/A6HCrYlQxkPKp1wSsvv6NIIQ8POj/VaOvJkVqeo9WW5lEABnwcPFmU5aZUwmDjIb3dBxKk8lPNUhRhZVZj2HLzGoSaJ0CvKI81dDE07ZyCLCLdbXvbGcP/FCZw/cAwL+oDBP98eUte31LfNxA8cDgYl1/EOGBdHUy+ddz3shq1XyHlhJJh7TVcO29ymS71PfQIhgQuJ7VrJH87U+seH+IZvfvoXP1s/wN7vKyiCA01L4xiJxtbj4vuusDzXnrN+qK8+yg7FG/PLXzyBst0bbV9ElLX4xbt3FhDclrI5tQsTnsE/qII9uTJdDpSUWdwnvBeM5+3DuDwytzm548mjcLKf9xG/FxDgQlqIkoM9AxPJ+CsO+Cx887nPetUDDHFDt23bxsZvqZpMV6Ma+s6OLPL63A14yrjQM+rTvlATA4ag5yWg2Rhym9s5DorZEQwQ+tJl/UNu/H5EOSXVPVfJRNsVWcC2mEWrJAzbgY4ktGs3FwKP9BlimaOCXSecuGgukctw79MYPBGRYYUt1umowdMVMdIYzoVJ7Z6N8Q0E7IMR91lHx/rc/srMAfsiKzeybfy7kpjzt0zujhckPYtpJvxogoacijJZ5M0jhc7Mh95rXzL8IO4WD7ynKDA1Qb67jspjmuHe
 pf+jQ5Ky
 5BsMZSebVww4BOhe3z8j3tTiatmt0qOA75fTgW62sqs3v//OXTX7gNozTRKrBuY0+3Ec8Tx1/UVZ1L8eTqgTIQLTJMY/gxjNeKRdMOOaIfqmBDfFkKB4LL9nglD5dBinVf4k1eNQ80SyNT0eb46aNWzcVY+wNRJ84uQ6IwjK56gcC60noRi3G2/bsjLtxrY5HFyAggM0Ico7Z9pBgYQFSNATsxGXLHSaSyB/dvctKM05tqpbueSyp48qmZyCrcsEaXlj5S0LrsfFcb2NJr8Tkk0lZSRMbmnVGXq6PvPOZwQRxubOmyLJzzyR8M6ICCKGjHPNgE47v5GqNqfhKKNy34xsAFW3c8IPR61WFRhXhaWAnPX6sO/fne/qTZjWpulIF7TuXGeo8AuTpwtXhvFeB3Xr7691F7Zf1/kuikAIBbCr9xr3nvNnZrikTD7wLao5Pek0R2AWwP1RzzwxVkb6K2AptbkotyntHjckqL5+CqOsYn4UEzKEOkPtB72/vzWLHjHP6LGwliqqOehQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This commit introduces:

* Multikernel flag support in kexec_file_load by adding KEXEC_MULTIKERNEL
  to KEXEC_FILE_FLAGS, enabling user-space to specify multikernel
  operations through the file-based kexec interface with proper flag
  validation and ID extraction.

* Instance-based memory allocation for multikernel images through
  kexec_alloc_multikernel() that allocates kernel segments from
  instance-specific memory pools rather than system memory, ensuring
  compliance with device tree resource specifications.

* Multikernel control page allocation via kimage_alloc_multikernel_control_pages()
  that provides page-aligned control structures from instance pools
  with proper alignment validation and conflict detection against
  existing segments.

* Enhanced kimage_file_alloc_init() with multikernel instance association
  that extracts multikernel IDs from kexec flags, validates instance
  availability, establishes bidirectional cross-references, and updates
  instance states to LOADING during the load process.

* Integrated memory hole location in kexec_locate_mem_hole() that
  prioritizes multikernel instance pool allocation over system memory
  allocation, ensuring multikernel segments respect reserved memory
  boundaries and resource isolation.

The integration maintains compatibility with existing kexec_file_load()
use cases, such as crash kernel, while extending it for multikernel case.
Standard kexec operations continue to use system memory allocation, while
multikernel operations automatically use instance-specific pools when
the KEXEC_MULTIKERNEL flag is specified.

This enables user-space tools to load multikernel images using the
more secure and flexible kexec_file_load interface rather than the
legacy kexec_load syscall, providing better integration with modern
security frameworks and signed kernel verification.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/kexec.h |   3 +-
 kernel/kexec_core.c   |  61 ++++++++++++++++++++++
 kernel/kexec_file.c   | 116 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 177 insertions(+), 3 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 5e9e9ad1dfeb..b907b7a92fd2 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -477,7 +477,8 @@ bool kexec_load_permitted(int kexec_image_type);
 /* List of defined/legal kexec file flags */
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
 				 KEXEC_FILE_NO_INITRAMFS | KEXEC_FILE_DEBUG | \
-				 KEXEC_FILE_NO_CMA | KEXEC_FILE_FORCE_DTB)
+				 KEXEC_FILE_NO_CMA | KEXEC_FILE_FORCE_DTB | \
+				 KEXEC_MULTIKERNEL)
 
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 7db755e64dd6..61ad01acd034 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -476,6 +476,64 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 }
 #endif
 
+static struct page *kimage_alloc_multikernel_control_pages(struct kimage *image,
+							   unsigned int order)
+{
+	/* Control pages for multikernel must be allocated from the instance's
+	 * memory pool to ensure they stay within the reserved memory regions
+	 * specified in the device tree configuration.
+	 *
+	 * We use mk_kimage_alloc() to get memory from the instance pool,
+	 * then convert it to page structures.
+	 */
+	void *virt_addr;
+	phys_addr_t phys_addr;
+	struct page *pages;
+	unsigned long size;
+	unsigned int count;
+
+	if (!image->mk_instance) {
+		pr_err("Multikernel image has no associated instance\n");
+		return NULL;
+	}
+
+	count = 1 << order;
+	size = count << PAGE_SHIFT;
+
+	/* Allocate from the multikernel instance pool (page aligned) */
+	virt_addr = mk_kimage_alloc(image, size, PAGE_SIZE);
+	if (!virt_addr) {
+		pr_debug("Failed to allocate %lu bytes for multikernel control pages\n", size);
+		return NULL;
+	}
+
+	/* Convert virtual address to physical */
+	phys_addr = virt_to_phys(virt_addr);
+
+	/* Check alignment requirements - control pages need page alignment */
+	if (!IS_ALIGNED(phys_addr, PAGE_SIZE)) {
+		pr_err("Multikernel control page allocation not page-aligned: phys=0x%llx\n",
+		       (unsigned long long)phys_addr);
+		mk_kimage_free(image, virt_addr, size);
+		return NULL;
+	}
+
+	/* Get the page structure */
+	pages = virt_to_page(virt_addr);
+
+	/* Check for conflicts with existing segments */
+	if (kimage_is_destination_range(image, phys_addr, phys_addr + size - 1)) {
+		pr_debug("Multikernel control pages conflict with existing segments: 0x%llx+0x%lx\n",
+			 (unsigned long long)phys_addr, size);
+		mk_kimage_free(image, virt_addr, size);
+		return NULL;
+	}
+
+	pr_debug("Allocated multikernel control pages: order=%u, phys=0x%llx, virt=%px\n",
+		 order, (unsigned long long)phys_addr, virt_addr);
+
+	return pages;
+}
 
 struct page *kimage_alloc_control_pages(struct kimage *image,
 					 unsigned int order)
@@ -491,6 +549,9 @@ struct page *kimage_alloc_control_pages(struct kimage *image,
 		pages = kimage_alloc_crash_control_pages(image, order);
 		break;
 #endif
+	case KEXEC_TYPE_MULTIKERNEL:
+		pages = kimage_alloc_multikernel_control_pages(image, order);
+		break;
 	}
 
 	return pages;
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 2d9d5626c8da..f9979c1d9f9e 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -27,6 +27,7 @@
 #include <linux/syscalls.h>
 #include <linux/vmalloc.h>
 #include <linux/dma-map-ops.h>
+#include <linux/multikernel.h>
 #include "kexec_internal.h"
 
 #ifdef CONFIG_KEXEC_SIG
@@ -309,6 +310,7 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 	int ret;
 	struct kimage *image;
 	bool kexec_on_panic = flags & KEXEC_FILE_ON_CRASH;
+	bool multikernel_load = flags & KEXEC_MULTIKERNEL;
 
 	image = do_kimage_alloc_init();
 	if (!image)
@@ -322,8 +324,50 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 		/* Enable special crash kernel control page alloc policy. */
 		image->control_page = crashk_res.start;
 		image->type = KEXEC_TYPE_CRASH;
-	}
+	} else
 #endif
+	if (multikernel_load) {
+		struct mk_instance *instance;
+		int mk_id = KEXEC_GET_MK_ID(flags);
+
+		/* Set multikernel image type for proper memory allocation */
+		image->type = KEXEC_TYPE_MULTIKERNEL;
+
+		pr_info("kexec_file_load: multikernel load - flags=0x%lx, extracted mk_id=%d\n",
+			flags, mk_id);
+
+		if (mk_id <= 0) {
+			pr_err("Invalid multikernel ID %d in flags\n", mk_id);
+			ret = -EINVAL;
+			goto out_free_image;
+		}
+
+		/* Find the existing mk_instance */
+		instance = mk_instance_find(mk_id);
+		if (!instance) {
+			pr_err("No multikernel instance found with ID %d\n", mk_id);
+			ret = -ENOENT;
+			goto out_free_image;
+		}
+
+		/* Check if instance is already associated with a kimage */
+		if (instance->kimage) {
+			pr_err("Multikernel instance %d already has an associated kimage\n", mk_id);
+			mk_instance_put(instance);
+			ret = -EBUSY;
+			goto out_free_image;
+		}
+
+		/* Establish cross-references */
+		image->mk_instance = instance; /* Transfer reference from find */
+		image->mk_id = mk_id;
+		instance->kimage = image;
+
+		/* Update instance state */
+		mk_instance_set_state(instance, MK_STATE_LOADING);
+
+		pr_info("Associated kimage with multikernel instance %d\n", mk_id);
+	}
 
 	ret = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
 					   cmdline_ptr, cmdline_len, flags);
@@ -731,6 +775,61 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
 	return 0;
 }
 
+static int kexec_alloc_multikernel(struct kexec_buf *kbuf)
+{
+	void *virt_addr;
+	phys_addr_t phys_addr;
+
+	pr_info("kexec_alloc_multikernel: called for segment size=0x%lx, buf_min=0x%lx, buf_max=0x%lx, align=0x%lx\n",
+		kbuf->memsz, kbuf->buf_min, kbuf->buf_max, kbuf->buf_align);
+
+	/* Check if this is a multikernel image with an associated instance */
+	if (!kbuf->image->mk_instance || kbuf->image->type != KEXEC_TYPE_MULTIKERNEL) {
+		pr_info("kexec_alloc_multikernel: not a multikernel image (mk_instance=%p, type=%d)\n",
+			kbuf->image->mk_instance, kbuf->image->type);
+		return -EPERM;
+	}
+
+	/* Allocate from the multikernel instance pool using the proper API */
+	virt_addr = mk_kimage_alloc(kbuf->image, kbuf->memsz, kbuf->buf_align);
+	if (!virt_addr) {
+		pr_info("Failed to allocate %lu bytes from multikernel instance pool (align=0x%lx)\n",
+			kbuf->memsz, kbuf->buf_align);
+		return -ENOMEM;
+	}
+
+	/* Convert virtual address to physical */
+	phys_addr = virt_to_phys(virt_addr);
+
+	if (!IS_ALIGNED(phys_addr, kbuf->buf_align)) {
+		pr_info("Multikernel allocation not aligned: phys=0x%llx, required=0x%lx\n",
+			 (unsigned long long)phys_addr, kbuf->buf_align);
+		mk_kimage_free(kbuf->image, virt_addr, kbuf->memsz);
+		return -ENOMEM;
+	}
+
+	if (phys_addr < kbuf->buf_min || (phys_addr + kbuf->memsz - 1) > kbuf->buf_max) {
+		pr_info("Multikernel allocation out of bounds: phys=0x%llx, min=0x%lx, max=0x%lx\n",
+			 (unsigned long long)phys_addr, kbuf->buf_min, kbuf->buf_max);
+		mk_kimage_free(kbuf->image, virt_addr, kbuf->memsz);
+		return -ENOMEM;
+	}
+
+	if (kimage_is_destination_range(kbuf->image, phys_addr, phys_addr + kbuf->memsz - 1)) {
+		pr_info("Multikernel allocation conflicts with existing segments: 0x%llx+0x%lx\n",
+			 (unsigned long long)phys_addr, kbuf->memsz);
+		mk_kimage_free(kbuf->image, virt_addr, kbuf->memsz);
+		return -EBUSY;
+	}
+
+	kbuf->mem = phys_addr;
+
+	pr_info("Allocated %lu bytes from multikernel pool at 0x%llx (virt=%px)\n",
+		 kbuf->memsz, (unsigned long long)phys_addr, virt_addr);
+
+	return 0;
+}
+
 /**
  * kexec_locate_mem_hole - find free memory for the purgatory or the next kernel
  * @kbuf:	Parameters for the memory search.
@@ -743,8 +842,21 @@ int kexec_locate_mem_hole(struct kexec_buf *kbuf)
 {
 	int ret;
 
+	pr_info("kexec_locate_mem_hole: called for segment size=0x%lx, mem=0x%lx, image_type=%d\n",
+		kbuf->memsz, kbuf->mem, kbuf->image->type);
+
 	/* Arch knows where to place */
-	if (kbuf->mem != KEXEC_BUF_MEM_UNKNOWN)
+	if (kbuf->mem != KEXEC_BUF_MEM_UNKNOWN) {
+		pr_info("kexec_locate_mem_hole: memory already specified (0x%lx), skipping allocation\n", kbuf->mem);
+		return 0;
+	}
+
+	/*
+	 * If this is a multikernel image, try to allocate from the instance's
+	 * memory pool first. This ensures multikernel segments use pre-reserved
+	 * memory from the device tree configuration and respects the pool management.
+	 */
+	if (!kexec_alloc_multikernel(kbuf))
 		return 0;
 
 	/*
-- 
2.34.1


