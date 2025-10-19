Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE6BCCD1AF
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB0C8E000E; Sun, 19 Oct 2025 02:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7568E0002; Sun, 19 Oct 2025 02:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169E58E000E; Sun, 19 Oct 2025 02:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F20E68E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3E5D1A0573
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:06 +0000 (UTC)
X-FDA: 84013856052.11.6C808E3
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id C723A140002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJH7VsoK;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLqqJGV/L+ji7bkggNzrd9CKo82o255TTwQERVGyCig=;
	b=sGV4kx22IQbNKIiBZi8Sf3BUTVCa+Ol10mGZ3Hrg3LXeGNQOlXPA7se7Ikr8A0MTI7lAZG
	IQ62U3Zgy9ZUh1hcGt9iYvwNjPyC+ZtVYExnbWmH0u722u3eqyZKJDGghsrjyq4EolY4U9
	jJm2rH52MSbTlRuIefiak3/Usx9F2RY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJH7VsoK;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854624; a=rsa-sha256;
	cv=none;
	b=kOsTmu/2wzVgcTUuujp6P2heNILQDpNuBRh4xMS13oQ1u4gu6WtGi5ChNgk6rEgcEbBfLb
	yDgYHOtdtXlTZCumStVPawfUUTYH0V6YqnwthyIUUeUVwv5kWzpye5WnJ3e5BUdOUJj7HW
	ugyi77HODmtvMrUCxLYccDq1GROfr2I=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-78118e163e5so3676037b3a.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854624; x=1761459424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLqqJGV/L+ji7bkggNzrd9CKo82o255TTwQERVGyCig=;
        b=MJH7VsoKnhcmQke9UqjJBHqcrv8kwNLF7bJBWAWqFq0DkMDZX8uRly9FO+iBCFNThf
         AqXKQ7Mhe9peWB4/YDVOaGbGFe6TvmdbW1wxcY5L6xIM0fKM9dbP/b3zrsWccrcuvC3M
         DiiLPhkzxp15Cs/CV9/FsrpbTmcw5HmTlgAa8s0HP1Jvg8GUW4ItuvhjglfcOyAMzQwA
         1yWjE7+cyOcamYBH50YosfbMKfEkQOj3Y4J20OTXuG2yoGN6D6hbM2hVajvXQkhR7sbN
         vbdkU/AKdvrykhCx1aXy8NVPgYmQgHbMqdYSiPL+WpDrC1W+ZRsf9LVgS2bi9Mu0WzC5
         KF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854624; x=1761459424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLqqJGV/L+ji7bkggNzrd9CKo82o255TTwQERVGyCig=;
        b=ow/IU7EQ29148TknqhvzSvl/JKnWoXiM8Si8NNlUDq4EMyFFdyHPC42ANFz0ewZAQz
         cBQ7x/Y334v7gqek1aWF2p7FXTXL3UxFZNgMC7K8MSnxdp0DJuMHovZ96/jV8SGn7Pr0
         OgJ1VMXP4YEBF5ielJj6IgEyhsnr5ocW+ypU6t2KXoDuPy/Srm3F64bklTt1fIdqlY2D
         fzrIvsTp8Lkb4754C90YqzSiuyoa3v+y+a8nbJiv4Ie/+iDet0Yc1opkqBzDSS0X5nO0
         ARwnkY/AGkyQgTwnlSTA+uhCvI0djS2fXz7vQTfUC4VTRIlmks0mvjVr9E4YzIESKbSB
         MmCw==
X-Forwarded-Encrypted: i=1; AJvYcCWumpQPf/47i+FHjUD0wZTd+jQbBtv7bjBbh0K4fVqbvqO8ARDLsnYHnXp/6pAgXQ8vwIMhqAdvfA==@kvack.org
X-Gm-Message-State: AOJu0Yw0RlyBabX6O7d8IYtiLUrQi7i8FDJjb12BY8Q1CCz2IeAW4fuW
	RxT491xL1a0jmV+gv/luOdjwzPPBnFR790LVSh9QYjJEl768G0H6rFpF
X-Gm-Gg: ASbGncvKK3Of2HT4iE2KKbdKuuqXIVzgTVAhFS0rpDxmT88BqnWIWZ5JJlBcloHEnj/
	GSMd4LhMKjthoEXPu3Fiq5fHxpxGy6BlhtVQ25Tf40otwRJvN0dwwmbQ+ChMJMqmeovISlEI8Bn
	twUkkY1mbNMj4vNKoIiUcTSgH77zBIZG1Dccl6Qd3t5UjGWJcgKg+Wv88jfUCKdqaoPlrNLEGzk
	vS9sfo0qBvQpznoIujNNAonWKOtNkT5Lqx64xgiuHNtESNVRK4SSDx1xQRUTwbEm17l4Ov5logb
	jsuJ6cwKcoHEI5mfCDFrx+74XRlJwmKlVR5kNCMSUUObFjWwi/zndI+86KP6WMcSNRrwWApxoxQ
	u1+r4BtdOKZcjFiDrb/oSx0doTkL7IPmM5QND7JMICz1Q9rCa2r41hWinZzaYXeiJDdX7LlWtG6
	Gs0Ix4EcpxVsRn8yU=
X-Google-Smtp-Source: AGHT+IHnfm9cDhxkKo6634pD1Qrn3qveTjwFz5affIoqxA2b6S+MUJtfZj8poS0j4agHQFerUWJNwQ==
X-Received: by 2002:a05:6a20:3d84:b0:278:bc13:d83e with SMTP id adf61e73a8af0-334a787d9c2mr12210119637.11.1760854623674;
        Sat, 18 Oct 2025 23:17:03 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:03 -0700 (PDT)
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
Subject: [RFC Patch v2 07/16] kexec: Implement dynamic kimage tracking
Date: Sat, 18 Oct 2025 23:16:21 -0700
Message-Id: <20251019061631.2235405-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ds753dppww6wpnfwdaypsyyn4n4grot
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C723A140002
X-HE-Tag: 1760854624-814897
X-HE-Meta: U2FsdGVkX19oAL82kx3FcmFpnCa3M/GxWNGI9dKhoaqXyQSc9XDaA3AC7p7rTJcN6wAdTgYxbsHSfXaH1YSMrurX+mD9yWpUvaNVfY9eZCCmGz/MrZY6RjBsxjI3LsuuTp47qeWrv9csQR0nGfBRlqceQUGH/nwI08DYjVxwzBXm/TOk6sDDHcpiFQRiUghVtBvMQfkAWb+VRgHC4WFjPN79rxuOEbZG1rP4YUtkzOd+DToElh1OOfPXnwc9QdLHRH1gw2NtphWIaecU/NKC1I+Clqgs10ClmmTuPwOL2ELcBynsNdfIBrTINhAi5IDuK4TIFFTbhjLPjsGU6WE938Y+4W7iCseWhX6s0GLiNsVcwcPJH+mtEhNK2yc1KP0x1onNvHHOh50dzd7e7UEVDCXtjkR9EpsSXhbAVPc7rVWdeQbwb1LO/Hzq3Z2czaT1OBVJLC4MNh4gjfyNtlde2qQIOOfx8yT7ZF3cH9zA5T3iooA/SyU+9dIJgvCiMVRYM5wRrzWRJ4A/iX/issPtsQ39hICKsLrsc6mjLAPOiCDZ8vc7U6/ZaMy5WVgogXx0+Sj5Z1w3joK+EwLjmXTZzZIBUgEqPp3VZdf7dVbOG3vjf5fRbZTzv+lVNXmU3ekbfD0PI8vMSI9lyYfhRV8pDSWpRrt5LdFz/RVmhNFytjhEtOKGr3FwLH54oGejFHV6Uo7DQ4qcg1fxv7YhoGH8ESL/x6I7Pt8Pm4IDvHuHpGjWbPGKfGZ84vCO/ok8+e9WExkD4rLhPpxxdKv5EqYg7kiQs9o/HBIltd5GOG6zpNKB+L/eiJcJRbNZNLWUdF1pT/MWMknH3rNKucT5zl7zZYOZ+2TTJaR4suhJaRho32TTae3x2cnhBro/zdBM459boIhAo2XVEVs4MbjuHAK5Bi1OAmFt9aQdsncf+9Dj6tk9Ct67oz1/cpUC3zCyCZDh2d0mBqZ7YKpapoEmemO
 Xy69+Dtw
 lBr/AlZ5HGdC4ww2D8ARWT26mZ2D+YIcPOt/3qG/SA9+74BAE+9sslF3LYH+GTnWgXkDmorDsXj/NYn8isO2+r6x7AkpZ682Y2C1idQ+M5DgF6NQ8ewtBAsPPVIl8eCSAmMTdIZ4+IXBLmIu8tFksVNbyVhXblHUgpoyfWjOaJlOg8Eflo3qypbSA1aw0PfhifYit/9W4dv8Y0vPD4squIOJXhvAoz1H4dCXAAknVyl75qV3grdVWNaT2DGKn6ZHaQrsWc/DM2u4I3wQ8acXw//L323JoxKt3hsCvx5M5zv/KWOFGFMHi9qUMaq4OTVf5mYngIyWPr0SvQK0YqlIeNA04ImErUsRpQtt5ZHFnlhaH/NHVHGpTH62rVimf/Bq/L2JiAy/4g2V97mugrfdi2gE9ttZUEHROSgCM/xzAE0YeCfB9SBXQMMPYjA==
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
 arch/powerpc/kexec/crash.c |  8 ++--
 arch/x86/kernel/crash.c    |  4 +-
 include/linux/kexec.h      | 13 ++++++
 kernel/kexec.c             | 60 ++++++++++++++++++++++++++--
 kernel/kexec_core.c        | 81 ++++++++++++++++++++++++++++++++++++++
 kernel/kexec_file.c        | 33 ++++++++++++++--
 6 files changed, 187 insertions(+), 12 deletions(-)

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
index 335fd2ee9766..a81f91d4352d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -559,9 +559,9 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
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
index edf64bc98ed5..69877db5360b 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -431,6 +431,9 @@ struct kimage {
 	/* dm crypt keys buffer */
 	unsigned long dm_crypt_keys_addr;
 	unsigned long dm_crypt_keys_sz;
+
+	/* For multikernel support: linked list node */
+	struct list_head list;
 };
 
 /* kexec interface functions */
@@ -534,6 +537,16 @@ extern bool kexec_file_dbg_print;
 
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
+extern void kimage_list_multikernel_images(void);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 28008e3d462e..74b8df4670e0 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -114,7 +114,31 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
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
@@ -124,7 +148,11 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
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
@@ -164,7 +192,33 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
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
+		if (image)
+			kimage_add_to_list(image);
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
index 7d89d00e2cde..449096060fe8 100644
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
@@ -248,6 +252,9 @@ struct kimage *do_kimage_alloc_init(void)
 	/* Initialize the list of unusable pages */
 	INIT_LIST_HEAD(&image->unusable_pages);
 
+	/* Initialize the list node for multikernel support */
+	INIT_LIST_HEAD(&image->list);
+
 #ifdef CONFIG_CRASH_HOTPLUG
 	image->hp_action = KEXEC_CRASH_HP_NONE;
 	image->elfcorehdr_index = -1;
@@ -580,6 +587,13 @@ void kimage_free(struct kimage *image)
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
@@ -1096,6 +1110,72 @@ void kimage_unmap_segment(void *segment_buffer)
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
@@ -1112,6 +1192,7 @@ static struct kexec_load_limit load_limit_panic = {
 	.limit = -1,
 };
 
+/* Compatibility: maintain pointers to current default and crash images */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
 static int kexec_load_disabled;
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index eb62a9794242..2d9d5626c8da 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -400,8 +400,13 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
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
@@ -457,7 +462,29 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
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


