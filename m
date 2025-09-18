Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76F9CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB788E0146; Thu, 18 Sep 2025 18:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF1F8E013E; Thu, 18 Sep 2025 18:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDCA8E0146; Thu, 18 Sep 2025 18:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 858488E013E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43D59C0526
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:34 +0000 (UTC)
X-FDA: 83903806308.16.7E156E2
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5DC5F160009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fiHTEKbN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234392; a=rsa-sha256;
	cv=none;
	b=b97MaMXmDkPMNylzGsr533vHDZmDjhmuobFj3iVqmi5Kpakw1A+w4UcEJzR1Ixa+8Zx+oX
	hhJoTSmXhwOfz11bR2jl/TejCnCJ3WTk8WElvCo/XRwUvFv9Y49xxWXzcVdWtdiSYqUXbK
	UAKZ6BftqFJ4gzOmV+LpPUYjbf/dVk0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fiHTEKbN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmD63BbCvLw1+b6tWETrdoM1eyA9FzYJ5sTU3sUEEu0=;
	b=kxu0FsHnZJhPDb6vwkh7wF3+Ldp5vzWKDHX+fNQno5VL1Yp1I7LqAtKqgobZG7eepPtvO6
	U2THeh6w0BbLVXKT+EAcsNY0Z4OLK4ZJM7GBjZJ6aHzS5FPRCqJT+rWkm3Pp+QVbU+/3e3
	camSuYdeQyoR2EzzbkyQXpBguT7r9VE=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7761b83fd01so1540479b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234391; x=1758839191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmD63BbCvLw1+b6tWETrdoM1eyA9FzYJ5sTU3sUEEu0=;
        b=fiHTEKbNxHNt9b8UnkUwpOGK9k9qmGJ8Y7eQZwf/LCPq3g8UHfXJWOMqiChxrooRhb
         l8yGaoVZB0GSxhoJec8wfMkRYyFVjapjWx6QZ04yiKSTsNPXzWnuvLJG7Mi9zRs6I/eO
         Y+xUMi1JozZ45PFdqvxNshJSGv6eIRsryiBTKMTTl4ktVfhGRaTe8TzrqRuqJDhigAO4
         D7Nz/+g9Y62dt9ivHC6Jn9gJ/JWNVr/3ceGBsWG/OnKyCPHIJjp7CXCQ6Gk5YASYJtW4
         7k4i75Lf9ocaIcz5TuebdgQf1E5mIuCk5aSPDj3ErGrYlIonRq/6e0AYmh1T30UTyw1q
         OAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234391; x=1758839191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmD63BbCvLw1+b6tWETrdoM1eyA9FzYJ5sTU3sUEEu0=;
        b=XYojm5dWW5QhjXcZjkqSzKuYr0j9CntZUDQ/Q678bv3puzqxShDXQj/mfKKw0pQ252
         FjkBUzmNT4KutpRWRLNhgeZ2YSaLN2jpBmdJ13qUTxCTgTh2rRKFgmH+NwbuneTtk1WD
         qApCYMgbXEs0GGUQXOe1/T4+s+nmNBPgyIzqlbLiPUF1RVI5w2Qr8PbYaXbsQ+76LDfg
         JZRnpUodJDIA/uIX+rruI8yuRD0m6K2gcOYyQpn21Sv412rQB7S5Z0BcLeEnNcvwx1KK
         4hl/Y9BYlHvbS+hwUeogeNvhrzuv/zMtiVB4CskR26VWTIXMvwb8+KL8Op1+rBCccQut
         I7tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKdXJzizNDT+KQeks6a1SXWMl07b3FMZkQ/3Fpw0q2L5rl2AGEbs/MHrfjyuXv+fSqTLqmKfYDmw==@kvack.org
X-Gm-Message-State: AOJu0YwZcmRoGIz+Bu5eeH7K2ZEI376u4qcOHfn/GTBybsEVf3ZYAp+o
	b9x+vhfkskyMc4gL+nDK/NPAvOx12gUW53R34n7SW8MZqcm6tvkkt7xx
X-Gm-Gg: ASbGncsY64+atG1hsR4CzHLus6TzgI4TtnxsElbUPpXiQr4AP2m1Vmr8orCAf85no+q
	CbQSpQT5toEXC3esyTjId4qNJuY0NO6q5/AYqTw6/R7+ZZurfsBUCAQOEsL+UZutVYBONxUtCh8
	2DqEXJsTYsAfzkKticW1ZpJ87o3lELKEw6a6RmCrYNHxHdUcGJBtcAgmqNTkTYszxS0VqG5xMTU
	op20ANGGSSNpradC7+xgihScrD7xQIaShRspKal86ZcBTgr7pQAME3Z+zYG8PdlQjnIYKrJYeI1
	AWXuTcJHUO/xFVVj/UMSCTR5SkukDf2vcBo3QL6pDt7eJRVqJpKnyaSMAczKghJNjdBkdrkwgu/
	tIJYzVARtp7HMwBm45H5r1Mr9i7+Zqg4wyF58x5P4afJ5NNcKVwpxLYLwnw==
X-Google-Smtp-Source: AGHT+IHHwLBA5GlUoOvD4xD7+nuj+LIGVESRzM/UopIIETfrLPNF1NwNONMXXiHPjNBi/2zForUYOw==
X-Received: by 2002:a05:6a20:3c8e:b0:262:c083:bb47 with SMTP id adf61e73a8af0-2925c552ae1mr1736118637.14.1758234391195;
        Thu, 18 Sep 2025 15:26:31 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:30 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 6/7] kexec: Implement dynamic kimage tracking
Date: Thu, 18 Sep 2025 15:26:05 -0700
Message-Id: <20250918222607.186488-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DC5F160009
X-Stat-Signature: te1989a5tejdbp1bnk5an3nrdcms4rm6
X-Rspam-User: 
X-HE-Tag: 1758234392-111883
X-HE-Meta: U2FsdGVkX19ioI4O6xThT4c+AeHEeclR+qwjlwTY3j5xMplA8TfHxmZh+IHTd1J1zbaLTcKguexeftTwrOnsbGQYtbbGSBl0e376ARpcbuEsqdRQhmVpGfZ+OVfXqmeKhjclhEFg/TR2Y2PRUUdikpSYADnZeKUq0entK8goen5YkpeBxUCtQ+2z19YlmHC5mZNuogm51thVJ0i3lxNt4j52fQ6wehQTEv6VXxoyx3mCYn591HmBwlN0+EMEMOy91GUkGB4ed5qBFyasWwyvkn8gbMAgYfHspPfL00xTpIICcm1+OedAzYJRMDN/juy6am+PXy1ZmOTJC9g5utABNupV8zOtY/Nt+hGxfDglyyraefRy27wWaovJ1msFTw53V3SPfxAb8ny27OKDUt18jvUgeXndHg1xbEQ5huNYXOEZgowdkI0s0UWxD9DXrxYKn8vIAZxNLSTE9o4faQzfj0km/A46KwgnhE+CWIhfrmNX9mKoiivWNLpbo62DjZU5zsw+QSDLYPe1lR0Hi28AaJ8uZTTEgQ5oYJV/QDhicdtZrf50uDq7x/3vzs7WEbtpG3wm71XIinWk5vhZUvW4cz3UjOu01j3PwxFhFT2/qtTw9oq9B7FpGbCwtuHIUf4x/sZLm8lM/dirnLQBk8STnRwZwaZeS+doTwXZIeMq2LfsCB0a+AV3JxuKhJG5AALNJrBgEcl/a9/ddazjCj7aKhWFHH3wyzKv0trdlNZaf2lyDYL4voS6O7pwS1aQGQPoe89OUguqK4lRGDXu5BhgcJiGA0U3BieAmKmwE+EcqeLZrK6RqkEa5VipUT6mmw6j38ztljhaU337IdE9tguuNPjwiSTTjP8MZ4pFXt12KrmTLW66I7ZDcz9WuWsOarIlsk/lo8rLCJNnpDOSw+vfWnN/nE1tRYfJOe5CQSjGCLFeSBjdioEP2/mju4PJIyLh6kh+qq8dkH+jM8vANUK
 t04KFS10
 TESOQQm0LdldeziQj0ltz7Eo/kDtFYeszlOrIS/2pLknNjWpDo4Y+g7ug+lKEPhfmmSS4uX2hBIXeXQwQm8zEwx9HO+2o9oq6ENCfmPYdtgVYrbSxENwBEOXh43897z9RpsLvx3fruSPcowN6aBJwRg8roz+Zdn8uTfTjgUgi6eTHytSiy+90PiWyq3GLf2gpOQDprArbHWpt+t5dDzLPfBBlGogublqpju9fgbLTZdECPUFzykDuDamCl7K0tnFZzsAHX4wD+rDmbuwyJRPVlkvszaT6P67pQmWJZEDof1h4lNPdcm1tWpFFaM/txE5p0Vf7JFokS8ORUL//sSR30xJtiCLdQ5kxSvzvR/KHfAC4VmNKA2wBznHE2T35+JB7NOtF1vmyw4XfvnlKKZDS78gpD6kWOtEeF7FqDf4TfIhtXG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Replace static kexec_image and kexec_crash_image globals with a dynamic
linked list infrastructure to support multiple kernel images. This change
enables multikernel functionality while maintaining backward compatibility.

Key changes:
- Add list_head member to kimage structure for chaining
- Implement thread-safe linked list management with global mutex
- Update kexec load/unload logic to use list-based APIs for multikernel
- Add helper functions for finding and managing multiple kimages
- Preserve existing kexec_image/kexec_crash_image pointers for compatibility
- Update architecture-specific crash handling to use new APIs

The multikernel case now properly uses list-based management instead of
overwriting compatibility pointers, allowing multiple multikernel images
to coexist in the system.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/powerpc/kexec/crash.c |   8 +-
 arch/x86/kernel/crash.c    |   4 +-
 include/linux/kexec.h      |  16 ++++
 kernel/kexec.c             |  62 +++++++++++++-
 kernel/kexec_core.c        | 165 ++++++++++++++++++++++++++++++++++++-
 kernel/kexec_file.c        |  33 +++++++-
 6 files changed, 274 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index a325c1c02f96..af190fad4f22 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -477,13 +477,13 @@ static void update_crash_elfcorehdr(struct kimage *image, struct memory_notify *
 	ptr = __va(mem);
 	if (ptr) {
 		/* Temporarily invalidate the crash image while it is replaced */
-		xchg(&kexec_crash_image, NULL);
+		kimage_update_compat_pointers(NULL, KEXEC_TYPE_CRASH);
 
 		/* Replace the old elfcorehdr with newly prepared elfcorehdr */
 		memcpy((void *)ptr, elfbuf, elfsz);
 
 		/* The crash image is now valid once again */
-		xchg(&kexec_crash_image, image);
+		kimage_update_compat_pointers(image, KEXEC_TYPE_CRASH);
 	}
 out:
 	kvfree(cmem);
@@ -537,14 +537,14 @@ static void update_crash_fdt(struct kimage *image)
 	fdt = __va((void *)image->segment[fdt_index].mem);
 
 	/* Temporarily invalidate the crash image while it is replaced */
-	xchg(&kexec_crash_image, NULL);
+	kimage_update_compat_pointers(NULL, KEXEC_TYPE_CRASH);
 
 	/* update FDT to reflect changes in CPU resources */
 	if (update_cpus_node(fdt))
 		pr_err("Failed to update crash FDT");
 
 	/* The crash image is now valid once again */
-	xchg(&kexec_crash_image, image);
+	kimage_update_compat_pointers(image, KEXEC_TYPE_CRASH);
 }
 
 int arch_crash_hotplug_support(struct kimage *image, unsigned long kexec_flags)
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index c6b12bed173d..fc561d5e058e 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -546,9 +546,9 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Temporarily invalidate the crash image while the
 	 * elfcorehdr is updated.
 	 */
-	xchg(&kexec_crash_image, NULL);
+	kimage_update_compat_pointers(NULL, KEXEC_TYPE_CRASH);
 	memcpy_flushcache(old_elfcorehdr, elfbuf, elfsz);
-	xchg(&kexec_crash_image, image);
+	kimage_update_compat_pointers(image, KEXEC_TYPE_CRASH);
 	kunmap_local(old_elfcorehdr);
 	pr_debug("updated elfcorehdr\n");
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index a3ae3e561109..3bcbbacc0108 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -428,6 +428,9 @@ struct kimage {
 	/* dm crypt keys buffer */
 	unsigned long dm_crypt_keys_addr;
 	unsigned long dm_crypt_keys_sz;
+
+	/* For multikernel support: linked list node */
+	struct list_head list;
 };
 
 /* kexec interface functions */
@@ -531,6 +534,19 @@ extern bool kexec_file_dbg_print;
 
 extern void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size);
 extern void kimage_unmap_segment(void *buffer);
+
+/* Multikernel support functions */
+extern struct kimage *kimage_find_by_type(int type);
+extern void kimage_add_to_list(struct kimage *image);
+extern void kimage_remove_from_list(struct kimage *image);
+extern void kimage_update_compat_pointers(struct kimage *new_image, int type);
+extern int kimage_get_all_by_type(int type, struct kimage **images, int max_count);
+extern void kimage_list_lock(void);
+extern void kimage_list_unlock(void);
+extern struct kimage *kimage_find_multikernel_by_entry(unsigned long entry);
+extern struct kimage *kimage_get_multikernel_by_index(int index);
+extern int multikernel_kexec_by_entry(int cpu, unsigned long entry);
+extern void kimage_list_multikernel_images(void);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 49e62f804674..3d37925ee15a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -147,7 +147,31 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	if (nr_segments == 0) {
 		/* Uninstall image */
-		kimage_free(xchg(dest_image, NULL));
+		if (flags & KEXEC_ON_CRASH) {
+			struct kimage *old_image = xchg(&kexec_crash_image, NULL);
+			if (old_image) {
+				kimage_remove_from_list(old_image);
+				kimage_free(old_image);
+			}
+		} else if (flags & KEXEC_MULTIKERNEL) {
+			/* For multikernel unload, we need to specify which image to remove */
+			/* For now, remove all multikernel images - this could be enhanced */
+			struct kimage *images[10];
+			int count, i;
+
+			count = kimage_get_all_by_type(KEXEC_TYPE_MULTIKERNEL, images, 10);
+			for (i = 0; i < count; i++) {
+				kimage_remove_from_list(images[i]);
+				kimage_free(images[i]);
+			}
+			pr_info("Unloaded %d multikernel images\n", count);
+		} else {
+			struct kimage *old_image = xchg(&kexec_image, NULL);
+			if (old_image) {
+				kimage_remove_from_list(old_image);
+				kimage_free(old_image);
+			}
+		}
 		ret = 0;
 		goto out_unlock;
 	}
@@ -157,7 +181,11 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 		 * crashes.  Free any current crash dump kernel before
 		 * we corrupt it.
 		 */
-		kimage_free(xchg(&kexec_crash_image, NULL));
+		struct kimage *old_crash_image = xchg(&kexec_crash_image, NULL);
+		if (old_crash_image) {
+			kimage_remove_from_list(old_crash_image);
+			kimage_free(old_crash_image);
+		}
 	}
 
 	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
@@ -199,7 +227,35 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 		goto out;
 
 	/* Install the new kernel and uninstall the old */
-	image = xchg(dest_image, image);
+	if (flags & KEXEC_ON_CRASH) {
+		struct kimage *old_image = xchg(&kexec_crash_image, image);
+		if (old_image) {
+			kimage_remove_from_list(old_image);
+			kimage_free(old_image);
+		}
+		if (image) {
+			kimage_add_to_list(image);
+			kimage_update_compat_pointers(image, KEXEC_TYPE_CRASH);
+		}
+		image = NULL; /* Don't free the new image */
+	} else if (flags & KEXEC_MULTIKERNEL) {
+		if (image) {
+			kimage_add_to_list(image);
+			pr_info("Added multikernel image to list (entry: 0x%lx)\n", image->start);
+		}
+		image = NULL; /* Don't free the new image */
+	} else {
+		struct kimage *old_image = xchg(&kexec_image, image);
+		if (old_image) {
+			kimage_remove_from_list(old_image);
+			kimage_free(old_image);
+		}
+		if (image) {
+			kimage_add_to_list(image);
+			kimage_update_compat_pointers(image, KEXEC_TYPE_DEFAULT);
+		}
+		image = NULL; /* Don't free the new image */
+	}
 
 out:
 #ifdef CONFIG_CRASH_DUMP
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 35a66c8dd78b..4e489a7031e6 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -56,6 +56,10 @@ bool kexec_in_progress = false;
 
 bool kexec_file_dbg_print;
 
+/* Linked list of dynamically allocated kimages */
+static LIST_HEAD(kexec_image_list);
+static DEFINE_MUTEX(kexec_image_mutex);
+
 /*
  * When kexec transitions to the new kernel there is a one-to-one
  * mapping between physical and virtual addresses.  On processors
@@ -275,6 +279,9 @@ struct kimage *do_kimage_alloc_init(void)
 	/* Initialize the list of unusable pages */
 	INIT_LIST_HEAD(&image->unusable_pages);
 
+	/* Initialize the list node for multikernel support */
+	INIT_LIST_HEAD(&image->list);
+
 #ifdef CONFIG_CRASH_HOTPLUG
 	image->hp_action = KEXEC_CRASH_HP_NONE;
 	image->elfcorehdr_index = -1;
@@ -607,6 +614,13 @@ void kimage_free(struct kimage *image)
 	if (!image)
 		return;
 
+	/* Remove from linked list and update compatibility pointers */
+	kimage_remove_from_list(image);
+	if (image == kexec_image)
+		kimage_update_compat_pointers(NULL, KEXEC_TYPE_DEFAULT);
+	else if (image == kexec_crash_image)
+		kimage_update_compat_pointers(NULL, KEXEC_TYPE_CRASH);
+
 #ifdef CONFIG_CRASH_DUMP
 	if (image->vmcoreinfo_data_copy) {
 		crash_update_vmcoreinfo_safecopy(NULL);
@@ -1123,6 +1137,72 @@ void kimage_unmap_segment(void *segment_buffer)
 	vunmap(segment_buffer);
 }
 
+void kimage_add_to_list(struct kimage *image)
+{
+	mutex_lock(&kexec_image_mutex);
+	list_add_tail(&image->list, &kexec_image_list);
+	mutex_unlock(&kexec_image_mutex);
+}
+
+void kimage_remove_from_list(struct kimage *image)
+{
+	mutex_lock(&kexec_image_mutex);
+	if (!list_empty(&image->list))
+		list_del_init(&image->list);
+	mutex_unlock(&kexec_image_mutex);
+}
+
+struct kimage *kimage_find_by_type(int type)
+{
+	struct kimage *image;
+
+	mutex_lock(&kexec_image_mutex);
+	list_for_each_entry(image, &kexec_image_list, list) {
+		if (image->type == type) {
+			mutex_unlock(&kexec_image_mutex);
+			return image;
+		}
+	}
+	mutex_unlock(&kexec_image_mutex);
+	return NULL;
+}
+
+void kimage_update_compat_pointers(struct kimage *new_image, int type)
+{
+	mutex_lock(&kexec_image_mutex);
+	if (type == KEXEC_TYPE_CRASH) {
+		kexec_crash_image = new_image;
+	} else if (type == KEXEC_TYPE_DEFAULT) {
+		kexec_image = new_image;
+	}
+	mutex_unlock(&kexec_image_mutex);
+}
+
+int kimage_get_all_by_type(int type, struct kimage **images, int max_count)
+{
+	struct kimage *image;
+	int count = 0;
+
+	mutex_lock(&kexec_image_mutex);
+	list_for_each_entry(image, &kexec_image_list, list) {
+		if (image->type == type && count < max_count) {
+			images[count++] = image;
+		}
+	}
+	mutex_unlock(&kexec_image_mutex);
+	return count;
+}
+
+void kimage_list_lock(void)
+{
+	mutex_lock(&kexec_image_mutex);
+}
+
+void kimage_list_unlock(void)
+{
+	mutex_unlock(&kexec_image_mutex);
+}
+
 struct kexec_load_limit {
 	/* Mutex protects the limit count. */
 	struct mutex mutex;
@@ -1139,6 +1219,7 @@ static struct kexec_load_limit load_limit_panic = {
 	.limit = -1,
 };
 
+/* Compatibility: maintain pointers to current default and crash images */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
 static int kexec_load_disabled;
@@ -1339,8 +1420,49 @@ int kernel_kexec(void)
 	return error;
 }
 
+/*
+ * Find a multikernel image by entry point
+ */
+struct kimage *kimage_find_multikernel_by_entry(unsigned long entry)
+{
+	struct kimage *image;
+
+	kimage_list_lock();
+	list_for_each_entry(image, &kexec_image_list, list) {
+		if (image->type == KEXEC_TYPE_MULTIKERNEL && image->start == entry) {
+			kimage_list_unlock();
+			return image;
+		}
+	}
+	kimage_list_unlock();
+	return NULL;
+}
+
+/*
+ * Get multikernel image by index (0-based)
+ */
+struct kimage *kimage_get_multikernel_by_index(int index)
+{
+	struct kimage *image;
+	int count = 0;
+
+	kimage_list_lock();
+	list_for_each_entry(image, &kexec_image_list, list) {
+		if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+			if (count == index) {
+				kimage_list_unlock();
+				return image;
+			}
+			count++;
+		}
+	}
+	kimage_list_unlock();
+	return NULL;
+}
+
 int multikernel_kexec(int cpu)
 {
+	struct kimage *mk_image;
 	int rc;
 
 	pr_info("multikernel kexec: cpu %d\n", cpu);
@@ -1352,13 +1474,52 @@ int multikernel_kexec(int cpu)
 
 	if (!kexec_trylock())
 		return -EBUSY;
-	if (!kexec_image) {
+
+	mk_image = kimage_find_by_type(KEXEC_TYPE_MULTIKERNEL);
+	if (!mk_image) {
+		pr_err("No multikernel image loaded\n");
 		rc = -EINVAL;
 		goto unlock;
 	}
 
+	pr_info("Found multikernel image with entry point: 0x%lx\n", mk_image->start);
+
+	cpus_read_lock();
+	rc = multikernel_kick_ap(cpu, mk_image->start);
+	cpus_read_unlock();
+
+unlock:
+	kexec_unlock();
+	return rc;
+}
+
+int multikernel_kexec_by_entry(int cpu, unsigned long entry)
+{
+	struct kimage *mk_image;
+	int rc;
+
+	pr_info("multikernel kexec: cpu %d, entry 0x%lx\n", cpu, entry);
+
+	if (cpu_online(cpu)) {
+		pr_err("The CPU is currently running with this kernel instance.");
+		return -EBUSY;
+	}
+
+	if (!kexec_trylock())
+		return -EBUSY;
+
+	/* Find the specific multikernel image by entry point */
+	mk_image = kimage_find_multikernel_by_entry(entry);
+	if (!mk_image) {
+		pr_err("No multikernel image found with entry point 0x%lx\n", entry);
+		rc = -EINVAL;
+		goto unlock;
+	}
+
+	pr_info("Using multikernel image with entry point: 0x%lx\n", mk_image->start);
+
 	cpus_read_lock();
-	rc = multikernel_kick_ap(cpu, kexec_image->start);
+	rc = multikernel_kick_ap(cpu, mk_image->start);
 	cpus_read_unlock();
 
 unlock:
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 91d46502a817..d4b8831eb59c 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -399,8 +399,13 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	 * same memory where old crash kernel might be loaded. Free any
 	 * current crash dump kernel before we corrupt it.
 	 */
-	if (flags & KEXEC_FILE_ON_CRASH)
-		kimage_free(xchg(&kexec_crash_image, NULL));
+	if (flags & KEXEC_FILE_ON_CRASH) {
+		struct kimage *old_crash_image = xchg(&kexec_crash_image, NULL);
+		if (old_crash_image) {
+			kimage_remove_from_list(old_crash_image);
+			kimage_free(old_crash_image);
+		}
+	}
 
 	ret = kimage_file_alloc_init(&image, kernel_fd, initrd_fd, cmdline_ptr,
 				     cmdline_len, flags);
@@ -456,7 +461,29 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	 */
 	kimage_file_post_load_cleanup(image);
 exchange:
-	image = xchg(dest_image, image);
+	if (image_type == KEXEC_TYPE_CRASH) {
+		struct kimage *old_image = xchg(&kexec_crash_image, image);
+		if (old_image) {
+			kimage_remove_from_list(old_image);
+			kimage_free(old_image);
+		}
+		if (image) {
+			kimage_add_to_list(image);
+			kimage_update_compat_pointers(image, KEXEC_TYPE_CRASH);
+		}
+		image = NULL; /* Don't free the new image */
+	} else {
+		struct kimage *old_image = xchg(&kexec_image, image);
+		if (old_image) {
+			kimage_remove_from_list(old_image);
+			kimage_free(old_image);
+		}
+		if (image) {
+			kimage_add_to_list(image);
+			kimage_update_compat_pointers(image, KEXEC_TYPE_DEFAULT);
+		}
+		image = NULL; /* Don't free the new image */
+	}
 out:
 #ifdef CONFIG_CRASH_DUMP
 	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
-- 
2.34.1


