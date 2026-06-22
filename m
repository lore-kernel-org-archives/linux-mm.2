Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1B7CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A026B008C; Mon, 22 Jun 2026 00:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471126B0092; Mon, 22 Jun 2026 00:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FB56B0093; Mon, 22 Jun 2026 00:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 108366B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:39:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A12E140548
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:50 +0000 (UTC)
X-FDA: 84906295740.18.5E9E22E
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id A565D140002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QolEDOZ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782103188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2URiiwAmBLau2vT0+5EPFKTJxMl3ImoKXAHWV/E4x4=;
	b=igKOSq8O0PvmjxfojD65RKNjIPmLGWHSFqFHTZ/upXSs74cNszXb5HsO4RzELZ5mTqlwqG
	5v0BfOeYeIFQzYvgP1eAQAYFFcaO91BvhuYSEMwlbgfuG5gb2So+mgEKyDj9PSfJTzA9tz
	XhH3cc+AQjrFKPKK1ZE180mj0/qzapo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782103188;
	b=6C9j7V5pcdntYTxNISJWSBAfm3IeidL3o6N3ybl6Vk0yZkbYqlmuWyZQomRsdFrwKqnmh5
	Cf5/nkf4MEo71Y+h6QT7sXvaeSkeFZ8Xx7RwrcozIHTZjeTqG95qhGOKI416HtNmlGY/LN
	pZ7axmGPsn9TnKfFNsKr4bOnMkKYQQg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QolEDOZ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4863ee8474eso2127340b6e.2
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782103187; x=1782707987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2URiiwAmBLau2vT0+5EPFKTJxMl3ImoKXAHWV/E4x4=;
        b=QolEDOZ3H9zKjHmMe8gYo0QnCx2HYz/Ez6WE9OsyrMNttF70Og9TzlAVnbED1glmU4
         dRQd5eBFV6VshkmbvEMlRUhYc8LLJiFvtPRI4Mb3/PtSBg1O5sx01gm84J6ZGoodlX1T
         X5z6watKiDYcr/Zm4pxTeitoMttxI6A+LOwLx9oW5DbE1O0tE1ieIC1utdTa2KYExHkj
         6/JWQZOJNtBThRsW+EWLN6LGeEOCrD+I2Tm3HmOKzh5eh4D/Q1p95GjkDxqRKJ9+GFU6
         T2F+rsFwVwSa0yv/j5sKFF+HYfY7hEqWtA40TWwOEXxAND/kn2uCkPps14METHe3AIvD
         gxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782103187; x=1782707987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2URiiwAmBLau2vT0+5EPFKTJxMl3ImoKXAHWV/E4x4=;
        b=q88a+3O+Cl0x+I79Xtvz9oE6Q5t7mzPZQ3hm8wpe7qJHG7+i33kahhUgL/SBAHzxrj
         EWnH/ZdCDqt4bA3dN4flPkNfFdhpVbjlS+LFEtlYFPCNs3C3lzaRQBR/GSdFA3xyCqoH
         pLRVeE7floWTVArU7y8D9G7Q17FeRyfj4aDBj/Ic18AsTVPlQsFpp3hKToV9CiDZL4Zr
         t3q2YQlvOaTGSfMrYdBbSWLBoEXpu3FJKfdJVr8tT61zmltEaRRP+brfG/3IFwdw3THO
         wNZ5V4AJdQi7/tAO7MGQJt9plWXg5KF05n/RGuVqeEVaoOiKxyX6+rv2T1x+Mu6cjtV/
         Dy1w==
X-Forwarded-Encrypted: i=1; AFNElJ82qlvXUlLk+CEelXZx96usUk0b8V79j1h9IkqeqFjPHwRz36EtKDxBMZ0thIpzB0nnzmrzVLrR2g==@kvack.org
X-Gm-Message-State: AOJu0Yyd+OTBJyrX0R0SAOitEQsMQ4qRWTQLHZnkE83PooATl3DjUjLT
	+hzAsdvKefmLtMinZQnXKZpn2J7B4bDcDzQo5VN7ySd3BSUOQNLBqKwV
X-Gm-Gg: AfdE7cnNBOtxGV14fTqwute34HT2eOFvTdNnenLvTqB6VkfsVa9213XWA/1uEqwoxPB
	uknpDi1yQ1rS6imUkyXekNRBwme/9iU1O3rkrzS3AEzjGZKfIRqVXUPn8QKe+IyL1YIvMhebeFJ
	OzNJfJluiVtsocCoi8U2w5D6vtOQ6UC27DMzefuVkl6LuoaLdc2bvbWgzlu7Jxq40Lbtd/T2As2
	d2NxFjvdtRa4oz7NRkX66RzijRLNcD29l30LdiprE7W40dGxieQ80xXb0GfCK0Tfx6SmWiMZqJ6
	/nqw8oNUPi2qhuqqpTzFNNjk/3UahdR3pigGkaQn0qM8ScEfS3G64PKkBqRQ5KJ1DQy9FAhe34F
	soOBksoXytRKla+J/BlTXhA9UZaaORTwKI+jplHSdqgWUaM4SPzNFSTYsQqFbGiqFPyAJKyGv6B
	B+o3+/Mnq1sTKaiGb3QJeRr/PsaZ2Tjom9qQ==
X-Received: by 2002:a05:6808:5290:b0:485:507:ee5d with SMTP id 5614622812f47-4896aa2ce16mr12307300b6e.10.1782103187573;
        Sun, 21 Jun 2026 21:39:47 -0700 (PDT)
Received: from nyx.tail25a6.ts.net ([2605:59c8:74db:6e0c:3a80:a3f:f9f0:1b3c])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9442ea144sm5428453a34.27.2026.06.21.21.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 21:39:47 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: kees@kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk
Cc: jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH 1/2] fs: support $ORIGIN in ELF interpreter paths
Date: Sun, 21 Jun 2026 21:39:33 -0700
Message-ID: <20260622043934.179879-2-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A565D140002
X-Rspam-User: 
X-Stat-Signature: 55eq8w4gkyuiotueqk6m6oye4tocdhgp
X-HE-Tag: 1782103188-957180
X-HE-Meta: U2FsdGVkX19kldvoVcxStayt5IyEGvfPvOSpuP28GzKN/b0qwVsfmGr/18BMPgvFr8G9wGO8S8GgDqKz7pSI0JDcFhp/4Eu4VEYq0pnKhDze6P/n6NCm3gPK2PvJqzynPBMnmBLKznzQd/rhUVx34BybKwfmUpIFLQOHe4HAjqpqFI8flX5mxVmleV69CC4q3RnbLy73yAwKeqgmWz2f0MT5I297X54NQDUsDTeOKuwYa7fS8UpBjz16beEcspt/B0gK7UOU3VgyDwkTZBv28zuiGCtOBdbqsTANUa+1Ri6OhxsYdXJ7fPx0YHdEMuifXeLnZ8Ykm4/TTnZJ5RIHwmuHZC0fQRMKD7GPE6zSURLRvcemb4oqy8h/tn7+2oImGouHHjqmnA/VkYVFie8mXvSbLn/1T5V1crSMO7I5rT5YGNZcLT/ND+mBoaHqBTHTASGDmNyHOppoxae2LFEtrCfs/2AjCh4eAu8p0u/HDcFXFSpcNT4TpLrhoHkh/u1kwD6BTYHOSGB32zA6j/+YxHBew0ualvTnhj8Na6RUSqQvIoC2qG/CoGozVf6mH6L1OMIddCXEzC/tSuYWg+Czdjc5nUGOMlTVCbi1a/q2duzdY2ktN6hdW6RMf3bUGf0LRbeNKRQs3zPgg7sm+ngAxg+1fatfEqzo8BmH7G4P6Od3DNWHwLOQ6pFCfOChVM8EQ/e6OQfZRtavFdKb9GR3LcyAdVIEdUFb8u3do1JPhZbysfTSCfKDiuaSS4g3haJy54IkO44cZqcWoN4qj0GTCxuBlAMGFeV7sYPDfdHQj3e5Z0sWmnxQQvKD9UN5xZ2C7LGFzSuMomIAOzSv/fQR/JQdJaL7zICx8mV5BAOgZBz4yHICy7aKwFMGZGPE9uL9LanWWNQW6iqOtjm+pV6hJH3ZMDGukl+wufWKVlY8WRZy9KRlR2uRZES55oV2BeX4//61Q1gy/69V5qoVJ0T
 SlmTaH/7
 HHMDg49+2CFbmqoMr/INTUHuF7XswVTcU7IP/GhvJdq6ejkP/nhtdEggc7L2BNrWcpacrPQVhGQXBIt0PQNlPlCnhfLgOiHWujjoxNVOWXPRu2Bfn5qtb0G6WssOUkwvn8BVocMSqauLI8ThGN9IDwwnQ6GwaaSLV0v83c+hvVNgDt/YLXkZUZ9lVVJbmPt1ETyqacfRi4XWEh4k2bOg9RvBGVdmKo+oQnMckBZjh9vEPJ5mtya2KfNXFNveaSMT2sRL64Q6po7qr0nPUNW86hFVxnJvIDnVYiU7IPTmTvi2iXb6DA6Ey5VVsfvXD8tjRVUErwCEgKjJLmyXV4cC0ajwxrbJ81ZtBBK+PgGVJeRXwJedKw6oPI1K0jjDavZwzarZtXQRbhBkfWQkeyIuIcgLCK+M4XJPihtrOB4yQNujufRdNR1NEfMa48ykT6MkquRvI5yFU6PmkKEOAH8UwzinXq7uyvo49TucH8VJMVxS2C1zxBuvbSTMqu5WZXz4EtiyJtzvobFi8MAgB8+uichCWt5Tv9AzthdQLa7dzG7D7bpLwIX7uJQYFtAnEhVYNf1k86YmNsAYtb3SSs20qRl7OVf8NuW2MPZcW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, standard ELF and ELF FDPIC loaders expect a fixed path to the
dynamic linker/interpreter (PT_INTERP). However, for systems utilizing
relocatable dynamic interpreters (such as Nix/store-based environments),
hardcoding this path is inflexible and breaks binary portability.

Introduce support for resolving the $ORIGIN placeholder in the ELF
interpreter path. This maps the dynamic linker relative to the path
of the binary being executed, matching user-space origin resolution.

To avoid code duplication, implement a shared 'resolve_elf_interpreter()'
helper in the VFS exec layer. For safety, limit detection strictly to
the prefix string "$ORIGIN" to prevent complex parsing exploits.

Assisted-by: Antigravity:Gemini-Pro
Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---
 fs/binfmt_elf.c         | 11 +++++++++--
 fs/binfmt_elf_fdpic.c   | 15 +++++++++++++--
 fs/exec.c               | 42 +++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h |  2 ++
 4 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3..af11f96ae 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -872,7 +872,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
-		char *elf_interpreter;
+		char *elf_interpreter, *resolved_interp;
 
 		if (elf_ppnt->p_type == PT_GNU_PROPERTY) {
 			elf_property_phdata = elf_ppnt;
@@ -904,8 +904,15 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 			goto out_free_interp;
 
-		interpreter = open_exec(elf_interpreter);
+		resolved_interp = resolve_elf_interpreter(bprm, elf_interpreter);
 		kfree(elf_interpreter);
+		if (IS_ERR(resolved_interp)) {
+			retval = PTR_ERR(resolved_interp);
+			goto out_free_ph;
+		}
+
+		interpreter = open_exec(resolved_interp);
+		kfree(resolved_interp);
 		retval = PTR_ERR(interpreter);
 		if (IS_ERR(interpreter))
 			goto out_free_ph;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7e3108489..e85727d71 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -230,7 +230,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 
 	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
 		switch (phdr->p_type) {
-		case PT_INTERP:
+		case PT_INTERP: {
+			char *resolved_interp;
+
 			retval = -ENOMEM;
 			if (phdr->p_filesz > PATH_MAX)
 				goto error;
@@ -259,7 +261,15 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 			kdebug("Using ELF interpreter %s", interpreter_name);
 
 			/* replace the program with the interpreter */
-			interpreter = open_exec(interpreter_name);
+			resolved_interp = resolve_elf_interpreter(bprm, interpreter_name);
+			kfree(interpreter_name);
+			if (IS_ERR(resolved_interp)) {
+				retval = PTR_ERR(resolved_interp);
+				goto error;
+			}
+
+			interpreter = open_exec(resolved_interp);
+			kfree(resolved_interp);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter)) {
 				interpreter = NULL;
@@ -284,6 +294,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 
 			interp_params.hdr = *((struct elfhdr *) bprm->buf);
 			break;
+		}
 
 		case PT_LOAD:
 #ifdef CONFIG_MMU
diff --git a/fs/exec.c b/fs/exec.c
index b92fe7db1..0978ae613 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2024,6 +2024,48 @@ static int __init init_fs_exec_sysctls(void)
 fs_initcall(init_fs_exec_sysctls);
 #endif /* CONFIG_SYSCTL */
 
+char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *elf_interpreter)
+{
+	char *pathbuf, *path, *slash, *resolved;
+
+	if (strncmp(elf_interpreter, "$ORIGIN", 7) != 0) {
+		char *ret = kstrdup(elf_interpreter, GFP_KERNEL);
+
+		return ret ? ret : ERR_PTR(-ENOMEM);
+	}
+
+	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!pathbuf)
+		return ERR_PTR(-ENOMEM);
+
+	path = file_path(bprm->file, pathbuf, PATH_MAX);
+	if (IS_ERR(path)) {
+		kfree(pathbuf);
+		return (char *)path;
+	}
+
+	slash = strrchr(path, '/');
+	if (slash) {
+		if (slash == path)
+			*(slash + 1) = '\0';
+		else
+			*slash = '\0';
+	} else {
+		kfree(pathbuf);
+		char *ret = kstrdup(elf_interpreter, GFP_KERNEL);
+
+		return ret ? ret : ERR_PTR(-ENOMEM);
+	}
+
+	resolved = kasprintf(GFP_KERNEL, "%s%s", path, elf_interpreter + 7);
+	kfree(pathbuf);
+	if (!resolved)
+		return ERR_PTR(-ENOMEM);
+
+	return resolved;
+}
+EXPORT_SYMBOL(resolve_elf_interpreter);
+
 #ifdef CONFIG_EXEC_KUNIT_TEST
 #include "tests/exec_kunit.c"
 #endif
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 2c77e383e..17419cd3d 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -150,4 +150,6 @@ extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
 int kernel_execve(const char *filename,
 		  const char *const *argv, const char *const *envp);
 
+char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *elf_interpreter);
+
 #endif /* _LINUX_BINFMTS_H */
-- 
2.51.2


