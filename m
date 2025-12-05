Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924FCD2CDF2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65C46B0010; Thu,  4 Dec 2025 19:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15C16B00D0; Thu,  4 Dec 2025 19:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8406B00D5; Thu,  4 Dec 2025 19:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72E2F6B0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:58:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29A3755A6D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:49 +0000 (UTC)
X-FDA: 84183607578.08.6F91647
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48E5A140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:58:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LLPfqzf0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Ri4yaQYKCLsbwbhjohpphmf.dpnmjovy-nnlwbdl.psh@flex--avagin.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3Ri4yaQYKCLsbwbhjohpphmf.dpnmjovy-nnlwbdl.psh@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896327; a=rsa-sha256;
	cv=none;
	b=3ni+zOpRbNX3cOBiFr8k0nzXT4svgEhjJisG20GHAmfbkkfLvKj2vfu5UWujS3L43U+Rcd
	l+POABI4fLF394enHO7jNgL32a6ZMsNut99ImtKpBo8HHRHrtthSbkWsbOEnvo4UgvmbBe
	WGkFHXb4AtUm+o4ihghups9G79aXTTQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LLPfqzf0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Ri4yaQYKCLsbwbhjohpphmf.dpnmjovy-nnlwbdl.psh@flex--avagin.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3Ri4yaQYKCLsbwbhjohpphmf.dpnmjovy-nnlwbdl.psh@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
	b=BTBOhgKpasCNz7a7admMxPd5WWpJi9+u5ZxpudYnPc3akl2OChmih4zEsx5rbSwtHpYyCa
	Mc92R1hUsyKJeNfGxsQhnAHRlmeHTTn0xkZzl+K+U7AlyDK+1NRAn2H74UqVJM5gLp5lmS
	2yRRGdfu++XPlEOqI9iefkGfN0Sm7V8=
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-3e890e6be00so2717595fac.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764896326; x=1765501126; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
        b=LLPfqzf0zQqKx79bxxQueJ5IxQjo7kNsbWNDipkP+cZyuuxUhuaYNa1PdUjKcMYvGr
         3Y1rGdxqueljRVuB5G38r6zaKPrQJpWMkaOOhGWCNaj9Gk8kiHCjg3LxnhqVbNoU1Dh4
         VEF0lKw7cQEJUs4wjzNZ/C81yrMDrbFCMGCyyTC7xoPUGSwokFZYcXNS122G4lfeiMqb
         7tn3/zsiz5HtujTI5JOFYLFLi+gYZLWJEHN/k90xUdmnwXNdiXpoE/KTh68mYJXkfD99
         jX4b8cDw5UvcJFgxt3i/WTIwlLvyxQ1yPMA/Q7SGyuxVgWzcuorgeGZHCRL+PGcWjgsH
         yG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896326; x=1765501126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1Ka/G7ByT2+kY8UIiF65zUCvkc5PFIL+KWxYDYgrVo=;
        b=MuKeXCaM0fC35MHjJCuMRmswdbNXs3OS/KTagknB+WqLxz2EIvIppAD+lMEg9Mpb54
         OqxiJfu+b3EdeMTAUgz/5RnU5bYSED12HJ74dytqxxJaJzxzvUg11BLeGqURaGWTnLh1
         S9zSUwLblzqNceciE3nH3czx2iTGi8gXDXKgAh6Z54rwdPe3DcZnMDWZgvkQi1bPPszM
         Oshor9r/sO+6qyuXnN0k/+2Wc3j+XmPEwJLEn7IZfJfEto9ohOBFubg7sK/TFJRklawS
         j+zuZrpT0HjlGq6bnoXbe1QnYx6eyyXLpGoib6y66X6H8xX0RsrwJKetHJ7D3NtY8L7M
         qxUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTIusIVhaLYrM9qqgkaVax0RXZ9c/zvIqZCGGhLhaREpmELEiIPRsD2GnXAxbMZumU20bAymzWjg==@kvack.org
X-Gm-Message-State: AOJu0Yxs2821PZF/N17Wk+4DsISIeadcskMnsARxqEQS7P6DjvgDcaVA
	KCaFYa2QY6AledphYPNzdb2mwsTcXhlRqf67sjCkVi59y2hAjPYlIoPZ9Tl1s0Blupy5ob+Fv74
	NTDYaLg==
X-Google-Smtp-Source: AGHT+IEwsKSsZMSp6xx5UIj2r6LD+T7cD7UXVYxQ9IkaQIcbU4lDaPVqZhMj+NwIGSDCYm3tG6SS17DBIEk=
X-Received: from oacnz12.prod.google.com ([2002:a05:6871:758c:b0:3e7:db6c:48b])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:888f:b0:3e8:8e57:a7a1
 with SMTP id 586e51a60fabf-3f5067dfc56mr2969051fac.52.1764896326246; Thu, 04
 Dec 2025 16:58:46 -0800 (PST)
Date: Fri,  5 Dec 2025 00:58:29 +0000
In-Reply-To: <20251205005841.3942668-1-avagin@google.com>
Mime-Version: 1.0
References: <20251205005841.3942668-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205005841.3942668-2-avagin@google.com>
Subject: [PATCH 1/3] cgroup, binfmt_elf: Add hwcap masks to the misc controller
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, criu@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 48E5A140006
X-Stat-Signature: r9k11tp6wo6w1cnzsiwmte9i6r11uo7c
X-Rspam-User: 
X-HE-Tag: 1764896327-6761
X-HE-Meta: U2FsdGVkX1+icMklk/Qo8887DE2Yy/HSYWJjSq/u/r3kmsD3I6kE+kYrsMQiVj8L0XYD2z6uvd557F+JI0hYAoUHWD6TB6H56d0My56pBNHtQK84XILtSazOIo3GrWpd+3fUZXhIr3kwxl/LF5WBtMkAFYB7tSiK4ZhQZn2Ga3DqAn0eeKmeQxyQego84+BS3vag0xO3agrQVzyxJ7PwOPEB1QVrvmL2W0h5tvMSqaeAo8VODhtcC48MGmxCdKkFK5j/4NzS93kopU8j4R5wuz+k67pBTy1u9b5wZTvzkwyER6zkbkALOtBkJ6jcIu7LygELkRmfNI162l26Clb9Vc5B/YQreUoySXoFCv+jSrse3GQF+HggR1Zh0ma4bj8XKQoKYaRmPQ28xjs5IAiJEFdSu7RborbsMc7D12SynU9fuubnUqkWka/76gG0o1RFldNLLhg+IUnT5RfqTKl7GsV75BiDBmsQAkpKJv0O0/l6Ti/Hd8a9idQxd19qWqj3eM/JihZRAyebby/oIrmgREnM1HDd3cUH5BPKBrIX9QJkPaoA9Q1ZgV64rtECUkOek31ooanYIvAV3CD/yNaUS8GZCsV7WhPI5ywAQD/rwAXZdaFIr1BmLSgThdE9yVy0bwsNl3Ja4PAN/IBOKZrj7RFKtD0WYIsUtLFywc/TlAa8ncXqQFnOKpn8SILJo+4eel7LX7fER/NWO3K+2bZcops/9jzQmrvhC9UdZBGZXxZ8r3zRygK+5McGLdRCUlzpUWWVp0hQ//nkgPCR5ZZ0qzGUvl/yM+JMbRaydpL/9EK5MBbWHI+/gZKehHn8HA1D5B3QVWG0NWfT91oNO1+Iz4Gg5pNEqKQJ6s8ZIQ8IiRHEHxNZOflEt8AclL5tvuPDHTceO5Dg80NA/sevoxNpsVBVOEkN8HDUAnNgu64UBjU0o+AO3um41S71YXd+35ZgckQ6X3fzBuT+kc1+GP2
 cwK47610
 XjJbQDGCpoEmG43q7qQOELQlb97x1PFx3JhHibOYB1jQY5dx5vz6CNmPrAxqRZksXQJUE2+l2YvREsvc0uppfOAvT+cMdRFlemJ9xq2ui+C7t9y40L5AEhzdAWWCwCo9P7uFswWPgb0RjEg8MPgHGLf5uBCokFONUInWZYoN9E7sGsL7QLPN8GZpc4NEhMpOXclVA+zSm3uYB7y0syZ1Vvf7TzndloWn/TXPU1kIFdLWBNFXQ39uwnSXCEnVYsjbcMgCdMk6PPQC7Vx9KaP6xk+z17mtC9FcMyvkHUD4NK9Sjki4TZZF3g5bu2N1YXA02bBKp3uLTCG7R76XGl31k935lN6/W4NLHJmeqED2ak6cpn2PKZvb7UVypBG8w084QRgk+k2z3bdBJP16QacyZ9ajSy/u1HPkXlbvYnDIXYdW06/nC/rZLvKHXDyEwdx+TqHj5Oo7qLv7M+JY+pilGsOmDBxU4/zSkilUPJQhCQ63WEAsLS+kp5oXyDyakxOFSlHF8v7+n36nNhq1LSsU6FzhwKDn37nHDtafk2zeHZbESDOoSONaWiN1X0FO44i+d9K6L5FV+yJ/9MRv+7UWrZsYFiA==
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


