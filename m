Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE695C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCF66B00FB; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268366B00FD; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091446B00FE; Thu,  2 Jul 2026 20:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFFE6B00F9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0951C1928
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:39:35 +0000 (UTC)
X-FDA: 84945607110.24.EACDD1F
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A48F160011
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:39:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a6erBmpD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783039174;
	b=phf479+g6PnqF1Q0Ns/cRpZaOg+rXeprbN6UsLnj0q9ZPMmIZBOtxjxNAIUxD4XF2323zZ
	eTLf1/lCyezxsLpUpjZCMrA2O/LK+HRondGgwGIFGmcGmvCQpUZFQm1sOoKT1JdQzG6G3K
	CisN0t+0OfsxzJ9TDzDGMPajZCgVfjk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783039174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQmnbToj2uNt+38fsrDHgZM8w5YoOu6ycBL01BwfMxY=;
	b=Nd2OzDUPFecWWKfMvHQ3KUlK0H2m7cGjiDUIDEwfrNNAKRNk1uuYzY2FLMURR057uvWdUe
	AUWUsSvcIAdDqSxZsUIXnxv+gOciMHXbx58+UCW/GAYVkdK8oUCv2ckaqb239Cko0soYFo
	tGQFxtIzDUw0LEhkHH1ZCDqyl1OVuqU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a6erBmpD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-664d910cc75so26650d50.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 17:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783039173; x=1783643973; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQmnbToj2uNt+38fsrDHgZM8w5YoOu6ycBL01BwfMxY=;
        b=a6erBmpD1ey+vX4odGUfCHG7wLIilEnRUgDRaquRztC2QORfsnR6FCiibZ9gF+OH1v
         VeS+0P9YJCwi2BTQBveRXqTUwK6on6rSHmDQdMYAyjsVZ5ucwG7CbVTs5CUTKG848ly0
         pPD/X/da0sICavbT1tdxyEQ1X9/bh3TzcTnY+Z94Ee3YJIADZAKSny9jWzylkX1ZEoXS
         iXdpKraCo28d2jYNBwFsj+aQldc74rFsAvtHkuKUvjUCWqIB92b15CxBvKyOIyfgXdIO
         0o07vmmsQPKYm/tA36pqUzBMjVopY8g1dfcPoO0VvQ+4fhNlQaP02bGs22GkT8GhfceR
         U3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783039173; x=1783643973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FQmnbToj2uNt+38fsrDHgZM8w5YoOu6ycBL01BwfMxY=;
        b=Qcl5ow50l1E41dYmVbdg/VULgHolDKarGoOp+JDi0oZqLl0RrQ/X6Qrt5bHB2t23Rb
         Es7G8uhOBjghylvbNttEYzjWXx7R/Ti8G23YCbiqNzcoNtGGxmrXh6zjFnuKXizNtKJO
         CXDEVptIo4Miw2Ejh7RQsqj/6kN56JiG4bi+WirLiQmPg++TJcymVJemrSUbKrRrKwA8
         ytktX+YvEmZ80wzeJue1084hXWThQ4QOwuG8oVfl+WzYpejgWht8NrAJNcykbb96L0oK
         fWtsgrT2pylVhdak+BJzygv4yQ7cW3AxjgAEFQ99kdQugCE57jvs7U3z/F9Zkn2/M/2J
         YVvg==
X-Forwarded-Encrypted: i=1; AHgh+Rp7avKjOhOk3Xzcb7/c3n+H7tQ+jCXWVmGFXTD2Q+n3KSOvS4TaphVW+uNHI2I3MMA+e0s5N4hTgA==@kvack.org
X-Gm-Message-State: AOJu0YxcP7Bu0xNcbeEt46zORzNOMikfB0aOxA7sc8ycbOclwae+uaW1
	5pSfKmbcP+Bf/AWnfd3exJXZRbUd5xIvP+HRSckfajDNXmgTgXS7+sYMk6/O/RJ8
X-Gm-Gg: AfdE7cl0jDgnAyc3gcIwdpmIQs2TjQrb3KuxrVvm375+VL6gMGpvYbX8K2l6eg0tU3J
	MaDc4qlRQnRjv7KOANkaD4VntQbYP+v50f3F4QzreCOu+o0mU9C8TBBWf/UlDoeq+tGkz10BIAX
	v30ko+RST28wC1JEYnUXxno9xQIj/o/qLedQxXoeUT2wwOxJD5MSmreFqCBkRPmAJaOHnp43/PJ
	jor9fG86viHJUGDipfbTCLAk4mtUGOweuCOqQ9t3OaPXGMJ5pJyUKu+5h2Y/2x3U/bAQh1NP1NV
	XE/1DNEkGBAD8m34NKyQ0ymkqK7lF7s2koyps+sCV0/X+M5kKpapHy6cjzHlfm94Eh/Qj+y+KIy
	SEAc9u8hxFH8mt/vicbur1iyd30pNtaw2NqCfPLkwDrVTi20vpjhEKWGNXagXA0GTwo7ZQRBssD
	Mww2cIa8CPM1+VHzenwDrVhFyC9ug=
X-Received: by 2002:a05:6a20:2d23:b0:3b3:1b38:d9d6 with SMTP id adf61e73a8af0-3bff4255e0emr7781388637.39.1783028589316;
        Thu, 02 Jul 2026 14:43:09 -0700 (PDT)
Received: from nyx.tail25a6.ts.net ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb84405sm18270279eec.17.2026.07.02.14.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 14:43:08 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: david.laight.linux@gmail.com
Cc: brauner@kernel.org,
	farid.m.zakaria@gmail.com,
	jack@suse.cz,
	jannh@google.com,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mail@johnericson.me,
	shuah@kernel.org,
	viro@zeniv.linux.org.uk
Subject: [RFC PATCH] fs: introduce pluggable ELF interpreter loader registry
Date: Thu,  2 Jul 2026 14:42:47 -0700
Message-ID: <20260702214247.1253741-1-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260630185916.5a694895@pumpkin>
References: <20260630185916.5a694895@pumpkin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zp94n4jbc8k73ubpjjjsc3qtaead1rex
X-Rspamd-Queue-Id: 2A48F160011
X-HE-Tag: 1783039174-49575
X-HE-Meta: U2FsdGVkX1/MKPFyGG9ZY2M5iQyFTM4BADhkcz6VeFvXzcgt5c+OjPQJMpkeN+BwFQCMImSbjku+GPssnqch9bBWBUwM0DbFTyO5TjEb52P3CoPpr/CLNLhU1QJzDQVjHpbkHlioEioPq0G6fLsFVbl7oqJaXdLXEzRuJt+Sgx0E693lHlVsrtVxUHTgsQD75KBSdbNJKwY5JashtmDkU8LKIik25XSW1iSnPlwPJOqCNsTQ2ujQ6UWqn+P6s5E8XWuHBL1S9ZVng2Pqy6AQwZruhZEa0zkDVVN/lHAKLJG9rvKqJO+JwNn/EBgNQCr8QZmFTkkC0S/+q4D34dgBaHPBEq4kS6jsI5T20SgJ+BDO5Kcxzuz+bLTSaYxFcqPmXNEwzxqLOHE37ZtNGjt+cPwl/xpv65CoSyw4Sv3lHPBMQn4YSFgas29s/vs/uIXNpkJhjhvwSjc/F8BLGOSTs99ByN7uOKyYUZlmi8t2OUHLCEZ6Qa+q3gj6uAZOla870mzRZXfLSa/9L5JVkEcAuBPRfLyVm6Tq0SXqT5U2wq79hJh/jeLFFDIlDXBcbhtamUAhvT21P+BdLLOnprxeHfyEYDsNWP2uaCC0vqjY5V34LsReOkzQxe19ZkNX//zNz0k7neC6mRcM8YgK2VHsVEhLsEz4MXRf8rrqbCyyjT0UQA/Ze7Qd2De8T+swJatOiRi9LQpWn1L+pm8wWJ470frNSzaNfiXU383z4nF6wA2dygBxYGPqTF/UKJN9RIFXBQ/OXqhKAO9FMWrsyz5eUt1yP3yHm9x3FmkOqqlpmfNcSINAeyHzajMIyKY5EcUQAVL4c+RphAYyEPRENZNEAl+TFEcGidCTu1/p7n0cgQCh8E2S+X3/BTnbwo7rxD9O1DczowhaVYXPIuqDscqwc8p/4iZpWeZ5JWWtKiZEZS57s7R8ROLBdgWq8e+YApHHx/aI2eew442ED7agBf2
 eewntKWX
 KH1txW+omV7J9xO1MqWUdBnzUyKa/TAdHycRH1j/xvR6ac8bs7HAh4Q7nFdAWIAAHPYJ9zQPEpPyHIOSIT70MdpufnqfvfGpgEicnf6c8HLoeZ9cuC/cLt1OE8fWY+xEJt4rfL5sjDJjY6t2wBaGTg/U3d05Xva/YOnhvTBtT+mmKo00dNKRUAK629WLyDgRilNT/Yy3ZjOdk5FcKQW1miDSr6xb9fsv7R+hXrHtCNj7Vh2r44l607Bbszjs2GMTuyD9rcNJOpVxKiwLs8bxCBK31IoEOgbVoqbpWcctgx8siNOdpp9CZVTdZME65nB00QC+IR3DIIGgdFIWNKA/HHW67PTQlb9oxGx6IQETfmlkfjHwYvLA5s+J8LvYR3uOFHDrNAbQj6dD24egcfYcc+9lm2LlA/oHcflT2mrbneO/jnDv9mcTjiYYJDCGCY6eMjWF11L8HsoY5IohsiulZAMTiShlAppFET6F9RHSTl7RKmhvy+jOdZB77s8b7uf709opR90ufviO+sRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a pluggable framework for ELF binary loading to allow dynamic
resolution and redirection of program interpreters (PT_INTERP). This is
primarily designed to support hermetic path resolution like NixOS $ORIGIN
relative dynamic linkers without bloating the core ELF loader or compromising
system execution security.

Introduce a new registration interface for kernel modules to register
open_interpreter callbacks. Standard ELF loading queries this registry; if a
plugin resolves a custom segment type (like PT_INTERP_NIX), it returns a file
descriptor for the resolved interpreter. Secure execution environments
(bprm->secureexec) bypass relative resolution for safety.

Assisted-by: Gemini
Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---

Hey Christian,

Here is a rough draft of what I thought something could look like for a pluggable ELF interpreter loader.
I've included the relocatable loader in the patch but this can be out-of-tree if needed; it's also named
"Nix" to distinguish the need for it. 

I chose to read from a distinct segment type (PT_INTERP_NIX) to avoid backwards incompatibility.

The default loader itself could be a plugin similar to binfmt_elf, but for now I wanted the patch
to be small to demonstrate the concept.

 fs/Kconfig.binfmt           |  15 +++++
 fs/Makefile                 |   1 +
 fs/binfmt_elf.c             |  24 ++++++++
 fs/binfmt_elf_nix.c         | 108 ++++++++++++++++++++++++++++++++++++
 fs/exec.c                   |  47 ++++++++++++++++
 include/linux/elf_plugins.h |  39 +++++++++++++
 6 files changed, 234 insertions(+)
 create mode 100644 fs/binfmt_elf_nix.c
 create mode 100644 include/linux/elf_plugins.h

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7..ef4277fd8 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -38,6 +38,21 @@ config BINFMT_ELF_KUNIT_TEST
 	  only needed for debugging. Note that with CONFIG_COMPAT=y, the
 	  compat_binfmt_elf KUnit test is also created.
 
+config BINFMT_ELF_PLUGINS
+	bool "Enable plugin support for ELF interpreter loading"
+	depends on BINFMT_ELF
+	help
+	  This option allows kernel modules to register handlers to dynamically
+	  resolve and override the ELF program interpreter (e.g. supporting relative
+	  interpreter paths with $ORIGIN).
+
+config BINFMT_ELF_NIX
+	tristate "ELF interpreter plugin for NixOS ($ORIGIN support)"
+	depends on BINFMT_ELF_PLUGINS
+	help
+	  This builds the NixOS ELF interpreter plugin. It intercepts PT_INTERP_NIX
+	  headers to resolve relative and $ORIGIN interpreter paths.
+
 config COMPAT_BINFMT_ELF
 	def_bool y
 	depends on COMPAT && BINFMT_ELF
diff --git a/fs/Makefile b/fs/Makefile
index 89a8a9d20..bd81e7ff6 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
 obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
+obj-$(CONFIG_BINFMT_ELF_NIX)	+= binfmt_elf_nix.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3..53fa26815 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -35,6 +35,7 @@
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/elf-randomize.h>
+#include <linux/elf_plugins.h>
 #include <linux/utsname.h>
 #include <linux/coredump.h>
 #include <linux/sched.h>
@@ -870,6 +871,12 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	if (!elf_phdata)
 		goto out;
 
+	interpreter = elf_plugin_open_interpreter(bprm, elf_ex, elf_phdata);
+	if (IS_ERR(interpreter)) {
+		retval = PTR_ERR(interpreter);
+		goto out_free_ph;
+	}
+
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
 		char *elf_interpreter;
@@ -882,6 +889,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (elf_ppnt->p_type != PT_INTERP)
 			continue;
 
+		if (interpreter)
+			continue;
+
 		/*
 		 * This is the program interpreter used for shared libraries -
 		 * for now assume that this is an a.out format binary.
@@ -935,6 +945,20 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_ph;
 	}
 
+	if (interpreter && !interp_elf_ex) {
+		interp_elf_ex = kmalloc_obj(*interp_elf_ex);
+		if (!interp_elf_ex) {
+			retval = -ENOMEM;
+			goto out_free_file;
+		}
+
+		/* Get the exec headers */
+		retval = elf_read(interpreter, interp_elf_ex,
+				  sizeof(*interp_elf_ex), 0);
+		if (retval < 0)
+			goto out_free_dentry;
+	}
+
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
 		switch (elf_ppnt->p_type) {
diff --git a/fs/binfmt_elf_nix.c b/fs/binfmt_elf_nix.c
new file mode 100644
index 000000000..d28b92c30
--- /dev/null
+++ b/fs/binfmt_elf_nix.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/path.h>
+#include <linux/namei.h>
+#include <linux/elf.h>
+#include <linux/elf_plugins.h>
+#include <linux/slab.h>
+
+MODULE_DESCRIPTION("ELF Interpreter plugin for NixOS / $ORIGIN");
+MODULE_AUTHOR("Farid Zakaria");
+MODULE_LICENSE("GPL");
+
+/* Mnemonic value for NixOS-specific program interpreter: 'N', 'I', 'X', 3 */
+#define PT_INTERP_NIX  (PT_LOOS + 0x4e49583)
+
+static struct file *nix_open_interpreter(struct linux_binprm *bprm,
+					 struct elfhdr *elf_ex,
+					 struct elf_phdr *elf_phdata)
+{
+	struct elf_phdr *elf_ppnt;
+	struct file *interpreter = NULL;
+	char *elf_interpreter = NULL;
+	int i, retval;
+
+	/* Find the custom Nix interpreter header */
+	elf_ppnt = elf_phdata;
+	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
+		if (elf_ppnt->p_type == PT_INTERP_NIX)
+			break;
+	}
+
+	if (i == elf_ex->e_phnum)
+		return NULL; /* Segment not present; fall back to others */
+
+	/* Security check: refuse relative interp resolution on secure execution */
+	if (bprm->secureexec) {
+		pr_warn_once("binfmt_elf_nix: secureexec active, refusing custom interpreter lookup\n");
+		return NULL; /* Fallback to standard PT_INTERP */
+	}
+
+	if (elf_ppnt->p_filesz > PATH_MAX || elf_ppnt->p_filesz < 2)
+		return ERR_PTR(-ENOEXEC);
+
+	elf_interpreter = kmalloc(elf_ppnt->p_filesz, GFP_KERNEL);
+	if (!elf_interpreter)
+		return ERR_PTR(-ENOMEM);
+
+	/* Read the interpreter path from the executable file */
+	retval = kernel_read(bprm->file, elf_interpreter, elf_ppnt->p_filesz, &elf_ppnt->p_offset);
+	if (retval != elf_ppnt->p_filesz) {
+		retval = (retval < 0) ? retval : -EIO;
+		goto out_free;
+	}
+
+	if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0') {
+		retval = -ENOEXEC;
+		goto out_free;
+	}
+
+	/* Path Resolution: Absolute vs. $ORIGIN */
+	if (elf_interpreter[0] == '/') {
+		interpreter = open_exec(elf_interpreter);
+	} else if (strncmp(elf_interpreter, "$ORIGIN/", 8) == 0 || strncmp(elf_interpreter, "${ORIGIN}/", 10) == 0) {
+		const char *rel_path = (elf_interpreter[0] == '$') ? (elf_interpreter + 8) : (elf_interpreter + 10);
+		struct path parent_path;
+
+		/* Reference parent directory of the executed file safely */
+		parent_path.mnt = mntget(bprm->file->f_path.mnt);
+		parent_path.dentry = dget_parent(bprm->file->f_path.dentry);
+
+		/* Open relative to parent directory */
+		interpreter = file_open_root(&parent_path, rel_path, O_RDONLY, 0);
+
+		path_put(&parent_path);
+	} else {
+		/* Naked relative paths are rejected for safety */
+		retval = -ENOEXEC;
+		goto out_free;
+	}
+
+	kfree(elf_interpreter);
+	return interpreter;
+
+out_free:
+	kfree(elf_interpreter);
+	return ERR_PTR(retval);
+}
+
+static struct elf_plugin nix_elf_plugin = {
+	.owner = THIS_MODULE,
+	.open_interpreter = nix_open_interpreter,
+};
+
+static int __init binfmt_elf_nix_init(void)
+{
+	return register_elf_plugin(&nix_elf_plugin);
+}
+
+static void __exit binfmt_elf_nix_exit(void)
+{
+	unregister_elf_plugin(&nix_elf_plugin);
+}
+
+module_init(binfmt_elf_nix_init);
+module_exit(binfmt_elf_nix_exit);
diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db1..45813bbce 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -46,6 +46,7 @@
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <linux/elf_plugins.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -108,6 +109,52 @@ void unregister_binfmt(struct linux_binfmt * fmt)
 
 EXPORT_SYMBOL(unregister_binfmt);
 
+#if IS_ENABLED(CONFIG_BINFMT_ELF_PLUGINS)
+static DEFINE_MUTEX(elf_plugins_lock);
+static LIST_HEAD(elf_plugins);
+
+int register_elf_plugin(struct elf_plugin *plugin)
+{
+	mutex_lock(&elf_plugins_lock);
+	list_add_tail(&plugin->list, &elf_plugins);
+	mutex_unlock(&elf_plugins_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_elf_plugin);
+
+void unregister_elf_plugin(struct elf_plugin *plugin)
+{
+	mutex_lock(&elf_plugins_lock);
+	list_del(&plugin->list);
+	mutex_unlock(&elf_plugins_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_elf_plugin);
+
+struct file *elf_plugin_open_interpreter(struct linux_binprm *bprm,
+					 struct elfhdr *elf_ex,
+					 struct elf_phdr *elf_phdata)
+{
+	struct elf_plugin *plugin;
+	struct file *file = NULL;
+
+	mutex_lock(&elf_plugins_lock);
+	list_for_each_entry(plugin, &elf_plugins, list) {
+		if (!try_module_get(plugin->owner))
+			continue;
+		mutex_unlock(&elf_plugins_lock);
+
+		file = plugin->open_interpreter(bprm, elf_ex, elf_phdata);
+
+		mutex_lock(&elf_plugins_lock);
+		module_put(plugin->owner);
+		if (file)
+			break;
+	}
+	mutex_unlock(&elf_plugins_lock);
+	return file;
+}
+#endif
+
 static inline void put_binfmt(struct linux_binfmt * fmt)
 {
 	module_put(fmt->module);
diff --git a/include/linux/elf_plugins.h b/include/linux/elf_plugins.h
new file mode 100644
index 000000000..826a32854
--- /dev/null
+++ b/include/linux/elf_plugins.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_ELF_PLUGINS_H
+#define _LINUX_ELF_PLUGINS_H
+
+#include <linux/binfmts.h>
+#include <linux/elf.h>
+#include <linux/list.h>
+
+struct elf_plugin {
+	struct list_head list;
+	struct module *owner;
+	struct file *(*open_interpreter)(struct linux_binprm *bprm,
+					 struct elfhdr *elf_ex,
+					 struct elf_phdr *elf_phdata);
+};
+
+#if IS_ENABLED(CONFIG_BINFMT_ELF_PLUGINS)
+int register_elf_plugin(struct elf_plugin *plugin);
+void unregister_elf_plugin(struct elf_plugin *plugin);
+struct file *elf_plugin_open_interpreter(struct linux_binprm *bprm,
+					 struct elfhdr *elf_ex,
+					 struct elf_phdr *elf_phdata);
+#else
+static inline int register_elf_plugin(struct elf_plugin *plugin)
+{
+	return 0;
+}
+static inline void unregister_elf_plugin(struct elf_plugin *plugin)
+{
+}
+static inline struct file *elf_plugin_open_interpreter(struct linux_binprm *bprm,
+						       struct elfhdr *elf_ex,
+						       struct elf_phdr *elf_phdata)
+{
+	return NULL;
+}
+#endif
+
+#endif /* _LINUX_ELF_PLUGINS_H */
-- 
2.51.2


