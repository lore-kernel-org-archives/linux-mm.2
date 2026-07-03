Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E5EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406856B00B6; Fri,  3 Jul 2026 05:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE876B00B9; Fri,  3 Jul 2026 05:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BE56B00BA; Fri,  3 Jul 2026 05:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032586B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:22:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A9C21A04B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:22:15 +0000 (UTC)
X-FDA: 84946924230.11.479BD8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A1BB116000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:22:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TfVKb9g/";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070533;
	b=mrccnptZJtmJxRGCSpe0khl7zFrbhOxW87c0V7ytK48aZvxZBxLqnqR+krKmmz/uGAf2Bx
	k/WBDpA+zrMnxM40BvUk/sXVakfVJwehtClWxXI/FP3U9yjLq/B+E2hvI1FduPmETYCS1e
	7GSrTpQeX7jkyziKve/KhQuGPvYLG7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5MVo4uh7FPL2i29WjKWktvZLA+Qe7ZwlDr/cqGze4Q=;
	b=u8jrEuMaVTb/ayVPNngreH5HIq2O8FminUOa6SFqcMTJHivpBylB9CQat/FIspGcYrvqiE
	IQ/K8/h1kmmCIWrg63pH07tHqUxdiDmjBA6pkz798wvImoOvS7Vp2iC+c/dmHrdRfPnlz2
	Pc5tVFLtnjE+bCe5yERHMmcj+bpCDSU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TfVKb9g/";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D9924057E;
	Fri,  3 Jul 2026 09:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A629C1F000E9;
	Fri,  3 Jul 2026 09:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783070532;
	bh=q5MVo4uh7FPL2i29WjKWktvZLA+Qe7ZwlDr/cqGze4Q=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=TfVKb9g/9iSnY4ExisoSc3gmKIAxDrLdMhNEN1FI68OMG1K0/W6AW7hrjGAL8TPez
	 /zc1oNoppTZ/xxtLm7TUlanJbhvPShr3cL+RouxgY/6mhJurBJprc4wuc0nZcRKydh
	 y9VJs17ovtCLRXLJSxfDGC8tTovOYdbzJ6iStxAyhYjNeGTF+gvPREr9AyHIkPjaKo
	 XFHuypf6SArTxkxbTAcx1n78PRqlAkmfhby2HBX/GWzQLgKs21Eqf9E+cK37K3DWbD
	 Y6U+9b2Kk5YOvfhUS3AFQIbddASGvs4N2gEcZh4/3KqFBjSQJ9RiAn6Xjnq0VjgWks
	 j1WVnxRSKGVlw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: introduce pluggable ELF interpreter loader
 registry
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: david.laight.linux@gmail.com, brauner@kernel.org, jack@suse.cz, 
 jannh@google.com, kees@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, mail@johnericson.me, shuah@kernel.org, 
 viro@zeniv.linux.org.uk
In-Reply-To: <20260702214247.1253741-1-farid.m.zakaria@gmail.com>
References: <20260630185916.5a694895@pumpkin>
 <20260702214247.1253741-1-farid.m.zakaria@gmail.com>
Date: Fri, 03 Jul 2026 11:22:05 +0200
Message-Id: <20260703-meditation-ratsuchende-moratorium-9ecdf1f3f8bb@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=10072; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N5io/5HBiIe2UPJQ4gFbkOpsH0fAzouzCXnXdl9zj1A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS51zuylLzeX6ZTf2apsa1UT+JFXX2jHZ9UfGabXjyre
 0Z4S82ZjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl8CGBkuNu9tmpbnchyabHT
 M09fkOa7ziW2+Nix2mPmtUsW6BfW6TD8M97pJOXwZJ/n5Io969o+fHrF0d740iNd4+L5d6aPJIP
 nMAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1BB116000A
X-Stat-Signature: fn34gj84g4j8opxo9tg5wa1iipbe37e9
X-Rspam-User: 
X-HE-Tag: 1783070533-415953
X-HE-Meta: U2FsdGVkX1+vFWxuEk32B0KPEtnjFoRGZFvQ/dxCLeLmTLy8d0EKJDkcG0P1q3hA9RfhIHFBZ5sjyUguBK8Osuiw80jbUN5zDXjWrBBCd17BSJRhXDTkMhy0Rw6gcqmgenDBw4dXn41m2ciVXU+1RdplXqE3n5ZpupwlhbgSOTz5helIwcxt+zs8Yreh1osFjlmSY5iH1Bl710yMJ/uBKNSec6NmNG5jUzfDFzb8L1GeomTqi6lKSv9JQ+a5cNg+UoWt8YAElF+yxYVBnFYsbuDm7fAdq7l3iMKY3BReKT6KFDcwVG3hwK4SjEe5gRP7Mu/mjp6suR8QX/MkPP55ttjKoHXAnobI5wuexk+epfv3VTSK45fzCUlpAhIMxyrE7ugF3Xmby5Galncp/+TDpgfF1nzN2P0uVvEqmtlD0U0xDbFuj1bbLfTz1zHoeStVWeKJjIbgSIrZnNzD9IqTtFJxpI9spxaIH5Q3/z8YBKB3vkZowLgED4JioLvZSzfDS9ne2PgrNtNrCsJOF9huR0rKiznTg3s8g4xdSgOqfyP++WuiXpNHnVPhr2Zdih6Ot1p3OFssjYpcS/7OueEHAmPyEghXcj4FNvUd+KO94u5vCeFLz5MO9DdPPAPUTwvQGBV2WDTWc+HVEO9xc/FSeQIVrzwRaFDtPNIxwLQ88V3PUIGWdyDEh3+Hkxww/EVkMGst3bdLbke5ZQn1DG2dPibB0RnU/Ed1Vzn0HewdFxd+BgaAOc9C3Y/8hOFfPvmvSIHb50f25ZAdbWG57SbM58o5P2VhvMOK+rRw7/+fxqX7YewC7kOwTeq/CM+7ieFoHgN4TSmUoYaW/tNWoBp8MSkSpEfxVjYmBzfZy2SANWs+2sFWBzRTBIfxXq+c9c5L0OwsKPKDNs+87iGF+HS2M46okWrSDYGyhdSKs2eSeVZNGNorJ8ATqEpKClSB4jPSK+F7arccoqrVu9X/RK7
 LKEWI9FV
 L/bC43kpbrRnQLXA1WDIS5hMmgmImS6/AeCQm9xtZAAZUB+i6UMMAmvRlREBPNhdow3dpZMIYcqRmSoR6p+E8/HE3zq44uIXjPtaxnLyZ3yNuhi8ry7P7CUXNv4YQGLVXsbT/iDIaJIjANywczTLQGJo3KEHM+1PEEoWIqU+N71YrTHshDpOaA/65ujPoz2YtmFGotySmQUnqw5Bgd0VJaGzJ5DVKl7WSS0cR431AnFgjJ/gXuO2EAY2sLzDMH4xqtrBJ0W3WtPapQjXX3bfV6vicr8ZdoAAKM0yUyZ4aCZ8Fv8GNOCyUfOt6LcBOerH5es7d4PEbtcBkQDfUPvTKeyTQmSOCKwJXq4t5b0QakDZ36TgqtMVl0dW/Nnl/EOQj9RR5YSEBn2S76HoaDzctxm82fv7b45J3xRqn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Introduce a pluggable framework for ELF binary loading to allow dynamic
> resolution and redirection of program interpreters (PT_INTERP). This is
> primarily designed to support hermetic path resolution like NixOS $ORIGIN
> relative dynamic linkers without bloating the core ELF loader or compromising
> system execution security.
> 
> Introduce a new registration interface for kernel modules to register
> open_interpreter callbacks. Standard ELF loading queries this registry; if a
> plugin resolves a custom segment type (like PT_INTERP_NIX), it returns a file
> descriptor for the resolved interpreter. Secure execution environments
> (bprm->secureexec) bypass relative resolution for safety.
> 
> Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
>
> diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> index 1949e25c7741..ef4277fd8050 100644
> --- a/fs/Kconfig.binfmt
> +++ b/fs/Kconfig.binfmt
> @@ -38,6 +38,21 @@ config BINFMT_ELF_KUNIT_TEST
>  	  only needed for debugging. Note that with CONFIG_COMPAT=y, the
>  	  compat_binfmt_elf KUnit test is also created.
>  
> +config BINFMT_ELF_PLUGINS
> +	bool "Enable plugin support for ELF interpreter loading"
> +	depends on BINFMT_ELF
> +	help
> +	  This option allows kernel modules to register handlers to dynamically
> +	  resolve and override the ELF program interpreter (e.g. supporting relative
> +	  interpreter paths with $ORIGIN).
> +
> +config BINFMT_ELF_NIX
> +	tristate "ELF interpreter plugin for NixOS ($ORIGIN support)"
> +	depends on BINFMT_ELF_PLUGINS
> +	help
> +	  This builds the NixOS ELF interpreter plugin. It intercepts PT_INTERP_NIX
> +	  headers to resolve relative and $ORIGIN interpreter paths.
> +
>  config COMPAT_BINFMT_ELF
>  	def_bool y
>  	depends on COMPAT && BINFMT_ELF
> diff --git a/fs/Makefile b/fs/Makefile
> index 89a8a9d207d1..bd81e7ff64f3 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -35,6 +35,7 @@ obj-$(CONFIG_FILE_LOCKING)      += locks.o
>  obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
>  obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
>  obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
> +obj-$(CONFIG_BINFMT_ELF_NIX)	+= binfmt_elf_nix.o
>  obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
>  obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
>  obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 16a56b6b3f6c..53fa2681555a 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -35,6 +35,7 @@
>  #include <linux/random.h>
>  #include <linux/elf.h>
>  #include <linux/elf-randomize.h>
> +#include <linux/elf_plugins.h>
>  #include <linux/utsname.h>
>  #include <linux/coredump.h>
>  #include <linux/sched.h>
> @@ -870,6 +871,12 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  	if (!elf_phdata)
>  		goto out;
>  
> +	interpreter = elf_plugin_open_interpreter(bprm, elf_ex, elf_phdata);
> +	if (IS_ERR(interpreter)) {
> +		retval = PTR_ERR(interpreter);
> +		goto out_free_ph;
> +	}
> +
>  	elf_ppnt = elf_phdata;
>  	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
>  		char *elf_interpreter;
> @@ -882,6 +889,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		if (elf_ppnt->p_type != PT_INTERP)
>  			continue;
>  
> +		if (interpreter)
> +			continue;
> +


>  		/*
>  		 * This is the program interpreter used for shared libraries -
>  		 * for now assume that this is an a.out format binary.
> @@ -935,6 +945,20 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		goto out_free_ph;
>  	}
>  
> +	if (interpreter && !interp_elf_ex) {
> +		interp_elf_ex = kmalloc_obj(*interp_elf_ex);
> +		if (!interp_elf_ex) {
> +			retval = -ENOMEM;
> +			goto out_free_file;
> +		}
> +
> +		/* Get the exec headers */
> +		retval = elf_read(interpreter, interp_elf_ex,
> +				  sizeof(*interp_elf_ex), 0);
> +		if (retval < 0)
> +			goto out_free_dentry;
> +	}
> +
>  	elf_ppnt = elf_phdata;
>  	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
>  		switch (elf_ppnt->p_type) {
> diff --git a/fs/binfmt_elf_nix.c b/fs/binfmt_elf_nix.c
> new file mode 100644
> index 000000000000..d28b92c30939
> --- /dev/null
> +++ b/fs/binfmt_elf_nix.c
> @@ -0,0 +1,108 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/path.h>
> +#include <linux/namei.h>
> +#include <linux/elf.h>
> +#include <linux/elf_plugins.h>
> +#include <linux/slab.h>
> +
> +MODULE_DESCRIPTION("ELF Interpreter plugin for NixOS / $ORIGIN");
> +MODULE_AUTHOR("Farid Zakaria");
> +MODULE_LICENSE("GPL");
> +
> +/* Mnemonic value for NixOS-specific program interpreter: 'N', 'I', 'X', 3 */
> +#define PT_INTERP_NIX  (PT_LOOS + 0x4e49583)
> +
> +static struct file *nix_open_interpreter(struct linux_binprm *bprm,
> +					 struct elfhdr *elf_ex,
> +					 struct elf_phdr *elf_phdata)
> +{
> +	struct elf_phdr *elf_ppnt;
> +	struct file *interpreter = NULL;
> +	char *elf_interpreter = NULL;
> +	int i, retval;
> +
> +	/* Find the custom Nix interpreter header */
> +	elf_ppnt = elf_phdata;
> +	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
> +		if (elf_ppnt->p_type == PT_INTERP_NIX)
> +			break;
> +	}


> +
> +	if (i == elf_ex->e_phnum)
> +		return NULL; /* Segment not present; fall back to others */
> +
> +	/* Security check: refuse relative interp resolution on secure execution */
> +	if (bprm->secureexec) {
> +		pr_warn_once("binfmt_elf_nix: secureexec active, refusing custom interpreter lookup\n");
> +		return NULL; /* Fallback to standard PT_INTERP */
> +	}
> +
> +	if (elf_ppnt->p_filesz > PATH_MAX || elf_ppnt->p_filesz < 2)
> +		return ERR_PTR(-ENOEXEC);
> +
> +	elf_interpreter = kmalloc(elf_ppnt->p_filesz, GFP_KERNEL);
> +	if (!elf_interpreter)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Read the interpreter path from the executable file */
> +	retval = kernel_read(bprm->file, elf_interpreter, elf_ppnt->p_filesz, &elf_ppnt->p_offset);


> +	if (retval != elf_ppnt->p_filesz) {
> +		retval = (retval < 0) ? retval : -EIO;
> +		goto out_free;
> +	}
> +
> +	if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0') {
> +		retval = -ENOEXEC;
> +		goto out_free;
> +	}
> +
> +	/* Path Resolution: Absolute vs. $ORIGIN */
> +	if (elf_interpreter[0] == '/') {
> +		interpreter = open_exec(elf_interpreter);
> +	} else if (strncmp(elf_interpreter, "$ORIGIN/", 8) == 0 || strncmp(elf_interpreter, "${ORIGIN}/", 10) == 0) {
> +		const char *rel_path = (elf_interpreter[0] == '$') ? (elf_interpreter + 8) : (elf_interpreter + 10);


> +		struct path parent_path;
> +
> +		/* Reference parent directory of the executed file safely */
> +		parent_path.mnt = mntget(bprm->file->f_path.mnt);
> +		parent_path.dentry = dget_parent(bprm->file->f_path.dentry);
> +
> +		/* Open relative to parent directory */
> +		interpreter = file_open_root(&parent_path, rel_path, O_RDONLY, 0);


> +
> +		path_put(&parent_path);
> +	} else {
> +		/* Naked relative paths are rejected for safety */
> +		retval = -ENOEXEC;
> +		goto out_free;
> +	}
> +
> +	kfree(elf_interpreter);
> +	return interpreter;
> +
> +out_free:
> +	kfree(elf_interpreter);
> +	return ERR_PTR(retval);
> +}
> +
> +static struct elf_plugin nix_elf_plugin = {
> +	.owner = THIS_MODULE,
> +	.open_interpreter = nix_open_interpreter,
> +};
> +
> +static int __init binfmt_elf_nix_init(void)
> +{
> +	return register_elf_plugin(&nix_elf_plugin);
> +}
> +
> +static void __exit binfmt_elf_nix_exit(void)
> +{
> +	unregister_elf_plugin(&nix_elf_plugin);
> +}
> +
> +module_init(binfmt_elf_nix_init);
> +module_exit(binfmt_elf_nix_exit);
> diff --git a/fs/exec.c b/fs/exec.c
> index b92fe7db176c..45813bbce833 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -46,6 +46,7 @@
>  #include <linux/key.h>
>  #include <linux/personality.h>
>  #include <linux/binfmts.h>
> +#include <linux/elf_plugins.h>
>  #include <linux/utsname.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/module.h>
> @@ -108,6 +109,52 @@ void unregister_binfmt(struct linux_binfmt * fmt)
>  
>  EXPORT_SYMBOL(unregister_binfmt);
>  
> +#if IS_ENABLED(CONFIG_BINFMT_ELF_PLUGINS)
> +static DEFINE_MUTEX(elf_plugins_lock);
> +static LIST_HEAD(elf_plugins);
> +
> +int register_elf_plugin(struct elf_plugin *plugin)
> +{
> +	mutex_lock(&elf_plugins_lock);
> +	list_add_tail(&plugin->list, &elf_plugins);
> +	mutex_unlock(&elf_plugins_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_elf_plugin);
> +
> +void unregister_elf_plugin(struct elf_plugin *plugin)
> +{
> +	mutex_lock(&elf_plugins_lock);
> +	list_del(&plugin->list);
> +	mutex_unlock(&elf_plugins_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_elf_plugin);
> +
> +struct file *elf_plugin_open_interpreter(struct linux_binprm *bprm,
> +					 struct elfhdr *elf_ex,
> +					 struct elf_phdr *elf_phdata)
> +{
> +	struct elf_plugin *plugin;
> +	struct file *file = NULL;
> +
> +	mutex_lock(&elf_plugins_lock);
> +	list_for_each_entry(plugin, &elf_plugins, list) {
> +		if (!try_module_get(plugin->owner))
> +			continue;
> +		mutex_unlock(&elf_plugins_lock);
> +
> +		file = plugin->open_interpreter(bprm, elf_ex, elf_phdata);

I have to say I do not like this at all because it also means you need
actual kernel modules for custom binaries. Yeech.

I think you should extend binfmt_misc for that, combining it with bpf.
When binfmt_misc selects the interpreter a bpf program is run. That bpf
program is passed the necessary information to make a decision. It can
check whether it's in the right sandbox. Then checks if the interpreter
starts with the magic ORIGIN string or whatever. Once it has determined
that a binfmt_misc entry applies things progress as usual. Then you can
point binfmt_misc at a static binary that finds the right loader to use.

-- 
Christian Brauner <brauner@kernel.org>

