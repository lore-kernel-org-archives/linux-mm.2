Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BA7CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECA88E000F; Tue,  7 Oct 2025 12:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4358E0003; Tue,  7 Oct 2025 12:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA098E000F; Tue,  7 Oct 2025 12:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C80CB8E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:21:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C5381DDD35
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:21:58 +0000 (UTC)
X-FDA: 83971834716.05.383A0ED
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id AF71D40004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:21:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DhmQ+yFx;
	spf=pass (imf04.hostedemail.com: domain of 3Iz7laAkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Iz7laAkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759854116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPke7s3EpbXC6ErmX/FPvC/unGHuc//hg1lOBj1qibA=;
	b=rmV8zqTb10YJKf4fZeoOw2crV9X7lgKSie+ctW1vU4Bjd4cZ0vmEtLcvcz2lJ5Av0U9H/8
	HQOfyN5uC83t6NvXS2x/c5ZVLg58AhROqpfEoOJpBDtCv57XU63LFCLR6S8EiGT6YNRhFd
	lQMq5S5LbYLaJyXVvdsNII2IeyDQVOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759854116; a=rsa-sha256;
	cv=none;
	b=xdxmB/Fa8Ij2VIx8eaF2rTalmLKf9BzUNsehXd90tuODVccnk3fUrAmGHzFKcdn7zD3ZIM
	Z8acc28yjYD6nx+xr+9y0EsaR/w16b0Oup8EM671BxQ2mW7+mFp01GkmrRmcfWtM8ILN2S
	IUyR34acbmsJhovbmIAEnmMH7xiOzjA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DhmQ+yFx;
	spf=pass (imf04.hostedemail.com: domain of 3Iz7laAkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Iz7laAkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f4fbdf144dso3431936f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759854115; x=1760458915; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPke7s3EpbXC6ErmX/FPvC/unGHuc//hg1lOBj1qibA=;
        b=DhmQ+yFxlqAYMQ/3uXMV1q8vE/6gBP+3Uli7IEwUuj3P4aRGRGsaw/m2MvVVyNrNdD
         s7qwbWWS7SutqNJzwJ+2IIUMxZHiUmb0tPW5I7N0dwQTM/YnMiuaTeIv7lkemgN5MAOo
         y8MY+qCNBYc6+lDCBD8jgeR+ZiRctcRYODvzVV45/XqxvdyP4wXSfr1xficRhfmlw8gq
         KqWJGrfn6MPF5AnWyfxUZNCldMXKbZNAZSVx36//CK0EZ+/bBlhL0ot3WW/fOStWNCt2
         x2CzAGb6jZDZSBDfeiGLK12/KZI3IoNxHzWXksy7IA7jDVFMz7EIeN0EqHMUFSK8prit
         CHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759854115; x=1760458915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPke7s3EpbXC6ErmX/FPvC/unGHuc//hg1lOBj1qibA=;
        b=cNPMeJEd3GLKquJbyd2QRfN2MUUPA5bxswQv3mmRD6/nzHIpS51RTqsJAZ9IdkLpYu
         UGcyY5ClUxu2/vb/1qNljIye3Vw6QGCP8vM6Y9IOsD4HDXyeRZC9YE0J6izyKgcIn3be
         2z9M5J96En12Fasvvou/4brpd6BGU3UEjA0bgvwHo0IyU3XXkhFSRNvj6g69mLOwjuhF
         5AJd+I6RawNALneEow6CYdnosPX/nXG+RTabUWevuraWvFjme7lSbcsRyqushaqgNjQM
         +ZOVHQGF1UrxWY1dA961dkBAMa47bpipIw2UsCzaM/kFCrsCqsmxz1QQ4+X0Kpiovon9
         as4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWIRMcGp5qtER+2L/1LREYi2v+7+LuXu92y59jhIf3T2nxkPwujDpMPHpXJNR+5EqqK9kie0wtCpg==@kvack.org
X-Gm-Message-State: AOJu0YzR2uV0veo15somTdDuuo522v+FB6lHm9XAN9S6yOWnyJ0Ls9R2
	NS1bWM8Vx2Zr2edmagEsxaKiQsNd7gHOQnj52dyvYFEUFTuWIFUPuWTMsIRwjhoTFO3WiCUoHya
	rArMMVQePJFknz6HfvQ==
X-Google-Smtp-Source: AGHT+IH9zRUnvVJnJ2rKg3ul1/L1v9CwXrOUbkfQHeRTwHBdeUKC3Y5EGru7TMDFalytr+scT+ACzRCj8l6otsM=
X-Received: from wmri12-n1.prod.google.com ([2002:a05:600c:8a0c:10b0:46e:1110:d730])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1395:b0:46e:27fb:17f0 with SMTP id 5b1f17b1804b1-46fa9aa204cmr1824285e9.9.1759854115350;
 Tue, 07 Oct 2025 09:21:55 -0700 (PDT)
Date: Tue,  7 Oct 2025 16:21:36 +0000
In-Reply-To: <20251002075202.11306-1-acsjakub@amazon.de>
Mime-Version: 1.0
References: <20251002075202.11306-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251007162136.1885546-1-aliceryhl@google.com>
Subject: [PATCH] mm: use enum for vm_flags
From: Alice Ryhl <aliceryhl@google.com>
To: acsjakub@amazon.de
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	chengming.zhou@linux.dev, david@redhat.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com, 
	xu.xin16@zte.com.cn, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: gw985wz1q6dtdpjgscopgoxb16a6wr7w
X-Rspam-User: 
X-Rspamd-Queue-Id: AF71D40004
X-HE-Tag: 1759854116-648380
X-HE-Meta: U2FsdGVkX1+BnnTIrPoxE6a79ECiem9bL992zBh1mtCVkWsyIGpPL/O4o7mNVqZ0o8kPyuAh4lFMCyfm/kOkYHmczChUmSqxvX9omq/B2piT8bOBpT5hhHQCvQ4pGJqEQlJvozVZP0TzmjbNpBzhTj5DrpKVmTQoCaHbtKm8vIEhcX6sFxcspffNsKfwWwqSGSegwmDFcXK8s2346KP8YekM63aLT3lDpQoPWiDE4rX6+ujbSBr9wWw96jjjHpLVuy1te/xC+qOlbW+t9Dd0QU+mRXI6aq93daYk7szHYXs+w5qJmWEC296A7CMTYjWsTERbqR+oGtZdRtApls1CHVqkYoeeM35Z5gLXUrFy+uy52v80L1ni853ZMxFpWmffawotIXcvDzSf6JqX8U2Gyx3SKu0yHhAfvXSeTD9gg7LO+0G1jJorEwIEuNKXMGqGAnLQ+g24NYhUhvK77tnzlj79oU1BsoWU3U0/E9GIK6gk1CYYqYRpQggWCFsRCK8giXhNm7A6UQj/7R1LAiLaIBOm3IJT8usKqFJQ+KNDfyDsCNn0vtatAu8yYpX5B4VNDss1cKlpGOpKH5ox57gi7Gi+Wj8u2gJDSKEbnnXyC3J6vSD+8Pbjox3eMKNKWS9gwUrub77ahUIgv88avQmY2vzzKT0qbkIWWYYl9dqXNJCEV+mS4+5+v88d5UdEwkx7GQ5mRJNkvmxXMb1h/rRXGYP9tDR5C8Jd327e8RIY5IQ23xVk2YxI4nV0YhQBub4OlJPx9FO2je0kB0Rnt38b9FADaH9uZnEHY4Hgo/s7ldINYqLFYVbY2r18QkD9mrMsENq3ozM2MY1E/hzqq8jgyQwbf1vaSC+XurR4h6po16HH4gyaWSIFv93TsdYRSl9IC6BRkFXY/57wT8wRwXelhQ53uW8qf2eeBpxQGdZQqNk5W1BGkRQ/HJFJSQgDD5u/nK3QqFHlCOo78yBSiaG
 GZmdOcI+
 b4gE/wGt1VJV2qC0ngBYagDh6J4neZI9tM10NRHCIZqFcptApw3jlwC6tVvgMdTGprhXokeT2emiJ/aI1noGmPCpHB6J+uEO1mj3aI0tryuvdgmoBdsixFN0+1A2I/WGZfSuzT6lx+SV5xFaKZDvdozR3JjhwdNzoBe0l7lxrJ5FD+KnKkpclm45t/WdlOsX/PRGo0f/hklfCazetfpJCbtGQ0bNAClXBC1xwbZxO0Fp/VlHapO9m1qnCP5ntk9p+4Rgsufz46ASIB0HUcbCRKD5iHSODn3JOav8tvnf6z9sv6DZ/wUmdBdpp1L0TG8Ds2xtLU+8qlP6UuvoJmG0hElda5Ym79DMwIgzvoNbGg3O2xWvi9aFzVdePTc0z/ctRHHztRQ/SauByyWaXTJhyg6Qyhff8WWxPnJN/uiVdnDvgyZ7PVRGfkkRabozEuSLbiyA2Yz4h83RM+ihDH7OjIfdrQ9TR/rGGUAmb66/qsEq5zmivSb0sFh1ykg4tmH//jWw+oh6AKUs1LCOaX4gL0riOsLWftz78yLMLsrNhDHjY3Zk8yBxWi4x7sWd+o6QBUszZ2OODgEBPzliCK8WZt1CPAT9yGQSucIywXSO0OLnn9C8QDlYMDP3wHhre/l9cMK5Qxx+yQV5e6XxRupQ3Z2Tw5vJP0auwWfio5N1s022Uzwlb14XkWJ7po8gmoVIDdEkHDexcs9IiqozW20Jj5xbCbUqZXKX2VLwt5DO4igbmbk6LZE3Ki54OLwbC8QiqFKLqJHpqsJfdWBII4ozif9Mm+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bindgen tool is better able to handle BIT(_) declarations when used
in an enum.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Hi Jakub,

what do you think about modifying the patch like this to use an enum? It
resolves the issues brought up in
	https://lore.kernel.org/all/CAH5fLghTu-Zcm9e3Hy07nNtvB_-hRjojAWDoq-hhBYGE7LPEbQ@mail.gmail.com/

Feel free to squash this patch into your patch.

 include/linux/mm.h              | 90 +++++++++++++++++----------------
 rust/bindings/bindings_helper.h |  1 -
 2 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7916d527f687..69da7ce13e50 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -273,57 +273,58 @@ extern unsigned int kobjsize(const void *objp);
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0
+enum {
+	VM_NONE		= 0,
 
-#define VM_READ		BIT(0)		/* currently active flags */
-#define VM_WRITE	BIT(1)
-#define VM_EXEC		BIT(2)
-#define VM_SHARED	BIT(3)
+	VM_READ		= BIT(0),		/* currently active flags */
+	VM_WRITE	= BIT(1),
+	VM_EXEC		= BIT(2),
+	VM_SHARED	= BIT(3),
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
-#define VM_MAYWRITE	BIT(5)
-#define VM_MAYEXEC	BIT(6)
-#define VM_MAYSHARE	BIT(7)
+	VM_MAYREAD	= BIT(4),		/* limits for mprotect() etc */
+	VM_MAYWRITE	= BIT(5),
+	VM_MAYEXEC	= BIT(6),
+	VM_MAYSHARE	= BIT(7),
 
-#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
+	VM_GROWSDOWN	= BIT(8),		/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
+	VM_UFFD_MISSING	= BIT(9),		/* missing pages tracking */
 #else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	BIT(9)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+	VM_MAYOVERLAY	= BIT(9),		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
-#define VM_PFNMAP	BIT(10)		/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
-
-#define VM_LOCKED	BIT(13)
-#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
-
-					/* Used by sys_madvise() */
-#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
-#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
-
-#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
-#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
-#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
-#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
-#define VM_SYNC		BIT(23)		/* Synchronous page faults */
-#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
-#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
+	VM_PFNMAP	= BIT(10),		/* Page-ranges managed without "struct page", just pure PFN */
+	VM_UFFD_WP	= BIT(12),		/* wrprotect pages tracking */
+
+	VM_LOCKED	= BIT(13),
+	VM_IO           = BIT(14),		/* Memory mapped I/O or similar */
+
+						/* Used by sys_madvise() */
+	VM_SEQ_READ	= BIT(15),		/* App will access data sequentially */
+	VM_RAND_READ	= BIT(16),		/* App will not benefit from clustered reads */
+
+	VM_DONTCOPY	= BIT(17),		/* Do not copy this vma on fork */
+	VM_DONTEXPAND	= BIT(18),		/* Cannot expand with mremap() */
+	VM_LOCKONFAULT	= BIT(19),		/* Lock the pages covered when they are faulted in */
+	VM_ACCOUNT	= BIT(20),		/* Is a VM accounted object */
+	VM_NORESERVE	= BIT(21),		/* should the VM suppress accounting */
+	VM_HUGETLB	= BIT(22),		/* Huge TLB Page VM */
+	VM_SYNC		= BIT(23),		/* Synchronous page faults */
+	VM_ARCH_1	= BIT(24),		/* Architecture-specific flag */
+	VM_WIPEONFORK	= BIT(25),		/* Wipe VMA contents in child. */
+	VM_DONTDUMP	= BIT(26),		/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
+	VM_SOFTDIRTY	= BIT(27),		/* Not soft dirty clean area */
 #else
 # define VM_SOFTDIRTY	0
 #endif
 
-#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
+	VM_MIXEDMAP	= BIT(28),		/* Can contain "struct page" and pure PFN pages */
+	VM_HUGEPAGE	= BIT(29),		/* MADV_HUGEPAGE marked this vma */
+	VM_NOHUGEPAGE	= BIT(30),		/* MADV_NOHUGEPAGE marked this vma */
+	VM_MERGEABLE	= BIT(31),		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
@@ -333,14 +334,15 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
-#define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
-#define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
-#define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
-#define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
-#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
-#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
-#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
+	VM_HIGH_ARCH_0	= BIT(VM_HIGH_ARCH_BIT_0),
+	VM_HIGH_ARCH_1	= BIT(VM_HIGH_ARCH_BIT_1),
+	VM_HIGH_ARCH_2	= BIT(VM_HIGH_ARCH_BIT_2),
+	VM_HIGH_ARCH_3	= BIT(VM_HIGH_ARCH_BIT_3),
+	VM_HIGH_ARCH_4	= BIT(VM_HIGH_ARCH_BIT_4),
+	VM_HIGH_ARCH_5	= BIT(VM_HIGH_ARCH_BIT_5),
+	VM_HIGH_ARCH_6	= BIT(VM_HIGH_ARCH_BIT_6),
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
+};
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 # define VM_PKEY_SHIFT VM_HIGH_ARCH_BIT_0
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2e43c66635a2..04b75d4d01c3 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -108,7 +108,6 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
-const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 
 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
 #include "../../drivers/android/binder/rust_binder.h"
-- 
2.51.0.618.g983fd99d29-goog


