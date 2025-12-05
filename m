Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67069D2CDF2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D11B6B00D0; Thu,  4 Dec 2025 19:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582096B00D6; Thu,  4 Dec 2025 19:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4936B00DA; Thu,  4 Dec 2025 19:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 241BD6B00D0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:58:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E12A916036F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:49 +0000 (UTC)
X-FDA: 84183607578.24.74FA2D3
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4AB59180012
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qNB8MnOx;
	spf=pass (imf16.hostedemail.com: domain of 3Ry4yaQYKCLwcxcikpiqqing.eqonkpwz-oomxcem.qti@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3Ry4yaQYKCLwcxcikpiqqing.eqonkpwz-oomxcem.qti@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
	b=NFxIPJoRFF3rTicUCcnC6ys31De0ZLsBGl26vPcRVs8vZvaaN9wq4SKnEwiFKHc8Bg3w5V
	duKuUfypIYJ8w+9wQDzbjs4/xK7aQjz0Q9c3s7I5LQcoCzCQ2SsBbbRFlUSqLQ0XUbuTM3
	AK+W2FdC6R3V/3abFL537zj+bpPPFuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896328; a=rsa-sha256;
	cv=none;
	b=G5kkAnFlrTOXTJYRhUKSp4XKf1PwoJFskA55q3InKmvu0+vZdapyEnlV2UrKLnDjYipA3k
	OOluVPCtCpb1iCpa4kBcJFB9ysbuz0JDBrR/lgi6zgrVp3e+t8JvYCnS7ePKA02IGdzteu
	XuCqdVJfWeWV9hI2CCvDsol8fkblrPI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qNB8MnOx;
	spf=pass (imf16.hostedemail.com: domain of 3Ry4yaQYKCLwcxcikpiqqing.eqonkpwz-oomxcem.qti@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3Ry4yaQYKCLwcxcikpiqqing.eqonkpwz-oomxcem.qti@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-656c35cd5b4so1023828eaf.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764896327; x=1765501127; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
        b=qNB8MnOxwRJkETPcSgH6uHxh4bEdeCdDj+1vvUyLMLc3kzjwq6ryrnFg5i3TvDqBRu
         HALoQbWa7Sa9+RKt11hlS+woBnXLN5lKKCJjDFn56wHAVKnO4oXlltyaRcf+rJ0BsYpZ
         zjxQD7tlmdZPMh81FOwZugmWPtO31dxfZgZJrm2uysGV67fG0gxBmHZ0QfJWfaUa6uaI
         wXwQZ+SH9/XJBZWUE7AI6LCUsrE0e0fBo0PxAgdckWO62DemvpansmrEnv1gx1TiU3k7
         XMS8pvn7YtOKxlqQFTcBEkTCwqIs4sgzkusUtHCj9H7pe+UEwxu+iR7o4vbd2HSiYPwX
         5yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896327; x=1765501127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
        b=nR3xPFGhK9tfGv1mOowUPdBU9C6UIaPNNDl9qoNyhf0zIUJLePOKGAaODGTbxxZmTB
         adgHoehKcJcdLnp7bQKW/aoBnbvQl3iDDdJiOPFVGV6rb5nCOCQoYaZ7NV0Gc9+F3C3H
         dwlAr8CVsP0cthZe4HTnIxq9tEjcnh/wIn2Z875EQQm2a/QA49u4VSwGDtS4aIAT6sqt
         mPpCgG95+n353XTrhAlHpH8BLiGXvIZy8wangLvZOecRJK7WnfcNQH7RZEgFS9W3G0W2
         OizyR+XbjbFAcPdSgfBHLswIn8wlGlf13SIkC0F5mYOVV9xtxLfUodOew6dAS1AeF+cQ
         7QKA==
X-Forwarded-Encrypted: i=1; AJvYcCXBGyDlQftTPcKc7iK4c2KVIkt2E1KPS5mrjKBKpHtX9oZnx0NA/Pe0q3oNfJZEIph67HsbGhpFNA==@kvack.org
X-Gm-Message-State: AOJu0YxsKQUV7JmTZlwhl0zj4WRKqCte8slUFvWQz3G5C8ow3CHt8tJ8
	wcyslzZrU5CdYDhsE5GPCO81yPC+RRHCMHs1odtvmuCtMxX7sa4HlCZ0jUbLJfMfXRp7WS6Z7gu
	2Pep8vg==
X-Google-Smtp-Source: AGHT+IGmtosd8xmps/oV4TZgOUFGtK1BT8mv/MmkumMBnl/inyl5u1+B5QcUb//XVfD1YOf+RZc7lMo25M0=
X-Received: from iobgp24.prod.google.com ([2002:a05:6602:e18:b0:949:60d:4912])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:1185:b0:44f:e61d:189f
 with SMTP id 5614622812f47-4536e3dcc04mr4462771b6e.13.1764896327255; Thu, 04
 Dec 2025 16:58:47 -0800 (PST)
Date: Fri,  5 Dec 2025 00:58:30 +0000
In-Reply-To: <20251205005841.3942668-1-avagin@google.com>
Mime-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205005841.3942668-3-avagin@google.com>
Subject: [PATCH 1/3] cgroup, binfmt_elf: Add hwcap masks to the misc controller
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AB59180012
X-Stat-Signature: r9k11tp6wo6w1cnzsiwmte9i6r11uo7c
X-HE-Tag: 1764896328-434220
X-HE-Meta: U2FsdGVkX18ewXVnMo+miHpUdqYQhKPpOYxfDFpoIfUoQEK7h87hkcsXycUWBw/AgfE2SGvWG+c9N8i/Mr8bwh2BaIhRjZTvQE6RUJ0s2I++Az6p+ghHFHCQUubqEI9JgOykfrVZbcrUENRRYbETIubixITBSdNMHs0eN5ssOv477WkYNLGKNohAgAgRqQuzXUWPHr+VbIf9IDXyvSz9MF/ZzvIPIQJaa/jDaXOhh9asmZtGbBOXF4i+7tCECfv3vy3Kp06gQ1N8o8STyFgbFZpNXNYWsO3lC0ZuWPDdXm/sQEegPfT3QJfoaPT/4tibM25ejkfb06AUid962cWScPPvFZKR2mSKm2YqaDFddmyb/sh2KYHJZXcxhPcWapdbBV2ewov4Pg5ElzqTDmsRHnuGTLkCXRXqSwwNKzFn58IZMM1NnjD1eO5y6o78M9sZpAvbzNpQLFycNIMr72K00AKYVP7dJeT2MM4DslkA+uqMU8MBMRXePPO1wkG9Pk4Ufo6CrdOSyn9LX9m6XXP8O6JomHln6GaS2Lu3iJJXAjveTd2Cl5xl2YlSJS+zA/uZqv4r1O2FCCE0QMko2CLwDhdnnJi+kE7qMYfe7dy1NXRKAL2RtIOkxpUYvuMAptnELV9yiIWqi/7C3/IzMwIsPh2bXunyaPf0B86sLsmp1DxBruvKxu3I3hYNYIWpZxWUZnaT+3IocowbWbXIVckgLZ3fdVNf1tFseb8/XiwdE2qU70YiAJerlOTosVISRv8fRkG3Ep/GXZlCtcu8tFpmz/pSOy22ardWk2rimHfzTABAgbM1O2ONBNDFTHhYm4wDfZ+YyLbR/q1XwVzyI8sjsDE3Btbatb6inC9EAzRpKkcyVuj0WHDHC7PYU3IR6ukjJMfkJ6v4vhUj3NnVGsmYdpBD5f8e0I5hfK+w5g+SIeH7cuR6QuZLWYjVhSX5Vz6Xaw3sjYST9wzZJX1ZkLQ
 CjTCgcc+
 7xv7m68Swbe7hIcW+petIhhE4Cc6L/3tO7y0HekB6vWTiD/5n/bNa4Q57Ojy7SwulIU38z6FG+3k/BqYA88wVd8Zqw1tS7iqA7UCla8BFPOhdIANhVgZtCVu3qRolYZfhFGMIQgdh59hZRb7HkPsTgqUWXNfs0sgOrd1t4cPTEz84ZAi2msShf+nNm6cmZNiignhsVUDKoAf1bvDo9W8+Uc6TFWF3EJrqPz1jZxKqQnzlbiBuNb6RNWE+BKo43CO3KIOp4SLq+RJawG+nXgDpGkqsSDmbYwsJ5JmWJQHM3X1zHi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an interface to the misc cgroup controller that allows masking out
hardware capabilities (AT_HWCAP) reported to user-space processes. This
provides a mechanism to restrict the features a containerized
application can see.

The new "misc.mask" cgroup file allows users to specify masks for
AT_HWCAP, AT_HWCAP2, AT_HWCAP3, and AT_HWCAP4.

The output of "misc.mask" is extended to display the effective mask,
which is a combination of the masks from the current cgroup and all its
ancestors.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf.c             |  24 +++++--
 include/linux/misc_cgroup.h |  25 +++++++
 kernel/cgroup/misc.c        | 126 ++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3eb734c192e9..59137784e81d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,7 @@
 #include <linux/dax.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/rseq.h>
+#include <linux/misc_cgroup.h>
 #include <asm/param.h>
 #include <asm/page.h>
 
@@ -182,6 +183,21 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	int ei_index;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
+	struct misc_cg *misc_cg;
+	u64 hwcap_mask[4] = {0, 0, 0, 0};
+
+	misc_cg = get_current_misc_cg();
+	misc_cg_get_mask(MISC_CG_MASK_HWCAP, misc_cg, &hwcap_mask[0]);
+#ifdef ELF_HWCAP2
+	misc_cg_get_mask(MISC_CG_MASK_HWCAP2, misc_cg, &hwcap_mask[1]);
+#endif
+#ifdef ELF_HWCAP3
+	misc_cg_get_mask(MISC_CG_MASK_HWCAP3, misc_cg, &hwcap_mask[2]);
+#endif
+#ifdef ELF_HWCAP4
+	misc_cg_get_mask(MISC_CG_MASK_HWCAP4, misc_cg, &hwcap_mask[3]);
+#endif
+	put_misc_cg(misc_cg);
 
 	/*
 	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
@@ -246,7 +262,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	 */
 	ARCH_DLINFO;
 #endif
-	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
+	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP & ~hwcap_mask[0]);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
 	NEW_AUX_ENT(AT_PHDR, phdr_addr);
@@ -264,13 +280,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 #ifdef ELF_HWCAP2
-	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
+	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2 & ~hwcap_mask[1]);
 #endif
 #ifdef ELF_HWCAP3
-	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
+	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3 & ~hwcap_mask[2]);
 #endif
 #ifdef ELF_HWCAP4
-	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
+	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4 & ~hwcap_mask[3]);
 #endif
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 0cb36a3ffc47..cff830c238fb 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -8,6 +8,8 @@
 #ifndef _MISC_CGROUP_H_
 #define _MISC_CGROUP_H_
 
+#include <linux/elf.h>
+
 /**
  * enum misc_res_type - Types of misc cgroup entries supported by the host.
  */
@@ -26,6 +28,20 @@ enum misc_res_type {
 	MISC_CG_RES_TYPES
 };
 
+enum misc_mask_type {
+	MISC_CG_MASK_HWCAP,
+#ifdef ELF_HWCAP2
+	MISC_CG_MASK_HWCAP2,
+#endif
+#ifdef ELF_HWCAP3
+	MISC_CG_MASK_HWCAP3,
+#endif
+#ifdef ELF_HWCAP4
+	MISC_CG_MASK_HWCAP4,
+#endif
+	MISC_CG_MASK_TYPES
+};
+
 struct misc_cg;
 
 #ifdef CONFIG_CGROUP_MISC
@@ -62,12 +78,15 @@ struct misc_cg {
 	struct cgroup_file events_local_file;
 
 	struct misc_res res[MISC_CG_RES_TYPES];
+	u64 mask[MISC_CG_MASK_TYPES];
 };
 
 int misc_cg_set_capacity(enum misc_res_type type, u64 capacity);
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg, u64 amount);
 void misc_cg_uncharge(enum misc_res_type type, struct misc_cg *cg, u64 amount);
 
+int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask);
+
 /**
  * css_misc() - Get misc cgroup from the css.
  * @css: cgroup subsys state object.
@@ -134,5 +153,11 @@ static inline void put_misc_cg(struct misc_cg *cg)
 {
 }
 
+static inline int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask)
+{
+	*pmask = 0;
+	return 0;
+}
+
 #endif /* CONFIG_CGROUP_MISC */
 #endif /* _MISC_CGROUP_H_ */
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 6a01d91ea4cb..d1386d86060f 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -30,6 +30,19 @@ static const char *const misc_res_name[] = {
 #endif
 };
 
+static const char *const misc_mask_name[] = {
+	"AT_HWCAP",
+#ifdef ELF_HWCAP2
+	"AT_HWCAP2",
+#endif
+#ifdef ELF_HWCAP3
+	"AT_HWCAP3",
+#endif
+#ifdef ELF_HWCAP4
+	"AT_HWCAP4",
+#endif
+};
+
 /* Root misc cgroup */
 static struct misc_cg root_cg;
 
@@ -71,6 +84,11 @@ static inline bool valid_type(enum misc_res_type type)
 	return type >= 0 && type < MISC_CG_RES_TYPES;
 }
 
+static inline bool valid_mask_type(enum misc_mask_type type)
+{
+	return type >= 0 && type < MISC_CG_MASK_TYPES;
+}
+
 /**
  * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
  * @type: Type of the misc res.
@@ -391,6 +409,109 @@ static int misc_events_local_show(struct seq_file *sf, void *v)
 	return __misc_events_show(sf, true);
 }
 
+/**
+ * misc_cg_get_mask() - Get the mask of the specified type.
+ * @type: The misc mask type.
+ * @cg: The misc cgroup.
+ * @pmask: Pointer to the resulting mask.
+ *
+ * This function calculates the effective mask for a given cgroup by walking up
+ * the hierarchy and ORing the masks from all parent cgroupfs. The final result
+ * is stored in the location pointed to by @pmask.
+ *
+ * Context: Any context.
+ * Return: 0 on success, -EINVAL if @type is invalid.
+ */
+int misc_cg_get_mask(enum misc_mask_type type, struct misc_cg *cg, u64 *pmask)
+{
+	struct misc_cg *i;
+	u64 mask = 0;
+
+	if (!(valid_mask_type(type)))
+		return -EINVAL;
+
+	for (i = cg; i; i = parent_misc(i))
+		mask |= READ_ONCE(i->mask[type]);
+
+	*pmask = mask;
+	return 0;
+}
+
+/**
+ * misc_cg_mask_show() - Show the misc cgroup masks.
+ * @sf: Interface file
+ * @v: Arguments passed
+ *
+ * Context: Any context.
+ * Return: 0 to denote successful print.
+ */
+static int misc_cg_mask_show(struct seq_file *sf, void *v)
+{
+	struct misc_cg *cg = css_misc(seq_css(sf));
+	int i;
+
+	for (i = 0; i < MISC_CG_MASK_TYPES; i++) {
+		u64 rval, val = READ_ONCE(cg->mask[i]);
+
+		misc_cg_get_mask(i, cg, &rval);
+		seq_printf(sf, "%s\t%#016llx\t%#016llx\n", misc_mask_name[i], val, rval);
+	}
+
+	return 0;
+}
+
+/**
+ * misc_cg_mask_write() - Update the mask of the specified type.
+ * @of: Handler for the file.
+ * @buf: The buffer containing the user's input.
+ * @nbytes: The number of bytes in @buf.
+ * @off: The offset in the file.
+ *
+ * This function parses a user-provided string to update a mask.
+ * The expected format is "<mask_name> <value>", for example:
+ *
+ * echo "AT_HWCAP 0xf00" > misc.mask
+ *
+ * Context: Process context.
+ * Return: The number of bytes processed on success, or a negative error code
+ * on failure.
+ */
+static ssize_t misc_cg_mask_write(struct kernfs_open_file *of, char *buf,
+				 size_t nbytes, loff_t off)
+{
+	struct misc_cg *cg;
+	u64 max;
+	int ret = 0, i;
+	enum misc_mask_type type = MISC_CG_MASK_TYPES;
+	char *token;
+
+	buf = strstrip(buf);
+	token = strsep(&buf, " ");
+
+	if (!token || !buf)
+		return -EINVAL;
+
+	for (i = 0; i < MISC_CG_MASK_TYPES; i++) {
+		if (!strcmp(misc_mask_name[i], token)) {
+			type = i;
+			break;
+		}
+	}
+
+	if (type == MISC_CG_MASK_TYPES)
+		return -EINVAL;
+
+	ret = kstrtou64(buf, 0, &max);
+	if (ret)
+		return ret;
+
+	cg = css_misc(of_css(of));
+
+	WRITE_ONCE(cg->mask[type], max);
+
+	return nbytes;
+}
+
 /* Misc cgroup interface files */
 static struct cftype misc_cg_files[] = {
 	{
@@ -424,6 +545,11 @@ static struct cftype misc_cg_files[] = {
 		.file_offset = offsetof(struct misc_cg, events_local_file),
 		.seq_show = misc_events_local_show,
 	},
+	{
+		.name = "mask",
+		.write = misc_cg_mask_write,
+		.seq_show = misc_cg_mask_show,
+	},
 	{}
 };
 
-- 
2.52.0.223.gf5cc29aaa4-goog


