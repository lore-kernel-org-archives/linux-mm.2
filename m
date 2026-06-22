Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4579CCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7D46B0088; Mon, 22 Jun 2026 05:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88B36B0092; Mon, 22 Jun 2026 05:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D0B6B0095; Mon, 22 Jun 2026 05:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBD36B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:53:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6190405B2
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:53:10 +0000 (UTC)
X-FDA: 84907085340.01.447F18B
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.168])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A9EF140006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:53:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=pA7DnmgH;
	spf=pass (imf26.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782121988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYB+eqZtyTPDHDqFA/TVCR7NlWihAxG6DNjwFRFTBik=;
	b=APPNVXkvHsK/KyJInkzR2BHyUlXQqg8jpDo9cAeAvSq0SD6DgMmxXncWC5IJb33A1ejWoh
	4YlukqNdNcOHDS2dPtGjf4sxOnnCPjlN8frsTJy5tt7E9tM0nZKGj1ADoTPbvpxmYOIema
	ibGQAiIwHWw3ZxuGi4zWPjPxPOFzjvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782121988;
	b=5RJXDTj6WnV8fDnKsqipDRSobsxy4c/OX7a3HL7GeJ1ayW1n50GMeG2yvfK/ndOMk5OdmP
	AP3pvj/uaOFs+Nff/9TFxInMNDROweSYaJH9JvgZ8/ZVC4TXzX+uhueSw36DzoXCQdY+j/
	Tr0QtzuXSTqzeVMKGf8dKjts41jXJ9M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=pA7DnmgH;
	spf=pass (imf26.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: 2adeddfa-6e20-11f1-861a-005056aba152
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 2adeddfa-6e20-11f1-861a-005056aba152;
	Mon, 22 Jun 2026 11:53:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=WYB+eqZtyTPDHDqFA/TVCR7NlWihAxG6DNjwFRFTBik=;
	b=pA7DnmgH6rlhfUQCpXYlI79jxsfH4rimPjNAm+HZgGflODLNdTkaX4xurSyY7FZUd2CZSvlA/3qYW
	 VGHME4+tuQ4ybG9E2W8pUC2QQScYL5igOxw9uUq0uYsZ+6OWKYGJ46ApOk5j/H7/BV3EPWAJQAEL6n
	 QiZ9DQr7F5xDg2nMlo81D7JLEjcUqTLnuAEJVj9p+5aoS9m9gIhrABljmG1dj38h89zUS0Qc4ZbWXF
	 Q3J/A5HGgZntfdXdrMZx4Qn638DNnd0bVMOMF0fOJfT8/Int4tt5xCrlQS9zxtxEWpS1BSBCGG0d6y
	 d7UaoDTawtYAZ6BNhOn3/1y1owRkGhw==
X-KPN-MID: 33|s6Wv9LN1ctw9HwwAkq60iXR8T4RFFzsoMvf18EvtivVebnxoErdXWyg+mBfQNzt
 JcB8gBRLVydk7A7QQppsb/kKHvLRMPEAu/QaKHmnyFOs=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|o3S6nZtqmTOz249rQvIuKjiBhadAu4toWXmgwvxawbt1t7IkATPkQ3/os34uKRa
 X/uqlDigkjeOjG0/uek/mvQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 2a610af9-6e20-11f1-a997-005056abf0db;
	Mon, 22 Jun 2026 11:53:06 +0200 (CEST)
Date: Mon, 22 Jun 2026 11:53:04 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: kees@kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, shuah@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <ajkEA0yqLhRjlJT_@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, kees@kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, shuah@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <20260622043934.179879-2-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622043934.179879-2-farid.m.zakaria@gmail.com>
X-Stat-Signature: q8zuaks69deu7maun9ku63gqq7ano7ab
X-Rspamd-Queue-Id: 7A9EF140006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782121988-480067
X-HE-Meta: U2FsdGVkX1+UuM1f6Vm4/4bkKeAZeXYycAa8yaB4K8dA6/G+Qh44fAGK8BgMdr7l2myecFWoVKLo48FjSiW6D81XZJV+VY3Au1pJXEcVwa2WAzvad1c07fqmlspVr7AtnH0+GXtmLncx3+HfsNF9RMV/9UHAjzJp6ON98xV918ZHLn+40RhVHU37mHc++cQEaIYjXN1a2Dbiqe3Q29UWysbESKi9kdEPTmtZkSVPS4i6uCUy6//XfoAss+hjpXs/U/XxZE19yMj0HPUAQBd2SY0dUdeIoPVadIII5OAxX3iDijHzYj3J8ycKnbJNL+hHds2kZtBpwJ6JTbQD/ilAx1qpF9QRJ5JcWJMsnUCfHtMt/tKx2L2shv1JnwgrJ8UM9Y09vcfhVPFLNa/kzVG/TgloQY2sakHJ2DSWjCHzkldfBgNNoN0Aa9njEYGEXXNkE1MDV661UqtRmR/zw8f3dh6/mJum9+nVLCQRXZDKS2C5gP6WdxfQPfTCy1exxarQwA5FTG/cqkUDrmYxnk8wSVu391c0ND/Nn45zptlxI79z9R0dhlh/dGuqwNfuwDWJXrVhuXooO0p5SfSXguYx0tOW1XyxbpOTWmUThtB9dfVpVsFf6N+zaLlxa3weESIZ5ih/yR9LaJQAvxVQcs67zVdHzPNkyH/reJn6VyHQMxU7ucDljDT/hL9xWucZwW35zYmJYKLSdSTy3H2hjfLkJxJ8PRSMNjYd5YbTgdnvX/tbrHgsgtHgeHy9RoYkKFnVKiQg3CI2eLsGiZ2FwPhegeD7udRyUnj762WBSMxHltpqVXqo7eEZhvlO+whP9adF9+t1mlg3QxbOPm4cgE2XeicNAvhLAHDyrWJnjSfJW1TjiBflrpu/7XNnxKejjmi/Ii6FpSxaA5ncFuabykqWWRxK1TDqZzd3M6LWirv8FMPXo3z7VyzbGrEvmLLSKn+8D7MO6nIQRqhK+9FngJW
 +iGS9YCY
 s926KKlwY/A0yuupdsuI0V2QWs02KqU/Q0FuCVzb5FzYaYvxqIFqC328gDv3ZWi4v6HqwM57Ie3yHVF31ptLAOCXaKVccWkkB3fbvGaTZ4TJyCMrmRV205e+of/BFVk5Eur2BCqYi1ssSNd7VpoSHg/yX0zi9g3LnxdugJRjcfy1wC0ehXKRxPz9/IUWpTp2LNNcqBuJsy6fe0L8yKOi/vBQii2JMhTWOk+fHNRZ11Iuxs2jvN631VLwmH5DPspFrsmQDVdbSg7WNMjs2g3+gScbre7KvNoTHucMqNo9rJbVNLJM4vyeCPA7rPDHv/Yh7usOcSb7PUjpkP5oh0KUQHSUedHMrl3WUM6X4LwLit7rgwdPPkkSywDof5Rc45gXzy+vWq2kuEEnxKaHcjgQaIuW6VlRlZwhejWpqo3xW3OnBb9cs4/a+7D4t09AR3VLH7W4b//4X9z/Z+h4kKdW8YHTChPqR2MYuX66k6eD/gEcOPKMcyBlKdvw6FwhnMjYSUPFf5N26EJZHcgX3w3YdoxWtRRxENKUNJniJastV0/XAPtZMza2mbK2Wtp3jpzuGqwC+CJOgRN7GbuTm5EHzfkD3VmQxV5YO3zkywlFu+ITLjUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Farid,

On Sun, Jun 21, 2026 at 09:39:33PM -0700, Farid Zakaria wrote:
> Currently, standard ELF and ELF FDPIC loaders expect a fixed path to the
> dynamic linker/interpreter (PT_INTERP). However, for systems utilizing
> relocatable dynamic interpreters (such as Nix/store-based environments),
> hardcoding this path is inflexible and breaks binary portability.
> 
> Introduce support for resolving the $ORIGIN placeholder in the ELF
> interpreter path. This maps the dynamic linker relative to the path
> of the binary being executed, matching user-space origin resolution.
> 
> To avoid code duplication, implement a shared 'resolve_elf_interpreter()'
> helper in the VFS exec layer. For safety, limit detection strictly to
> the prefix string "$ORIGIN" to prevent complex parsing exploits.
> 
> Assisted-by: Antigravity:Gemini-Pro

This isn't a requirement from the community or anything, but I always
find it useful if I see an Assisted-by tag to know what assistence was
actually delivered by an LLM. Otherwise we might as well add
assisted-by tags for any editor.

Talking about LLMs, your patch has some issues flagged by Sashiko[1].
Please take a look.


> Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
> ---
>  fs/binfmt_elf.c         | 11 +++++++++--
>  fs/binfmt_elf_fdpic.c   | 15 +++++++++++++--
>  fs/exec.c               | 42 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/binfmts.h |  2 ++
>  4 files changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 16a56b6b3..af11f96ae 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -872,7 +872,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  
>  	elf_ppnt = elf_phdata;
>  	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
> -		char *elf_interpreter;
> +		char *elf_interpreter, *resolved_interp;
>  
>  		if (elf_ppnt->p_type == PT_GNU_PROPERTY) {
>  			elf_property_phdata = elf_ppnt;
> @@ -904,8 +904,15 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
>  			goto out_free_interp;
>  
> -		interpreter = open_exec(elf_interpreter);
> +		resolved_interp = resolve_elf_interpreter(bprm, elf_interpreter);
>  		kfree(elf_interpreter);
> +		if (IS_ERR(resolved_interp)) {
> +			retval = PTR_ERR(resolved_interp);
> +			goto out_free_ph;
> +		}
> +
> +		interpreter = open_exec(resolved_interp);
> +		kfree(resolved_interp);
>  		retval = PTR_ERR(interpreter);
>  		if (IS_ERR(interpreter))
>  			goto out_free_ph;
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 7e3108489..e85727d71 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -230,7 +230,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>  
>  	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
>  		switch (phdr->p_type) {
> -		case PT_INTERP:
> +		case PT_INTERP: {
> +			char *resolved_interp;
> +
>  			retval = -ENOMEM;
>  			if (phdr->p_filesz > PATH_MAX)
>  				goto error;
> @@ -259,7 +261,15 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>  			kdebug("Using ELF interpreter %s", interpreter_name);
>  
>  			/* replace the program with the interpreter */
> -			interpreter = open_exec(interpreter_name);
> +			resolved_interp = resolve_elf_interpreter(bprm, interpreter_name);
> +			kfree(interpreter_name);
> +			if (IS_ERR(resolved_interp)) {
> +				retval = PTR_ERR(resolved_interp);
> +				goto error;
> +			}
> +
> +			interpreter = open_exec(resolved_interp);
> +			kfree(resolved_interp);
>  			retval = PTR_ERR(interpreter);
>  			if (IS_ERR(interpreter)) {
>  				interpreter = NULL;
> @@ -284,6 +294,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>  
>  			interp_params.hdr = *((struct elfhdr *) bprm->buf);
>  			break;
> +		}
>  
>  		case PT_LOAD:
>  #ifdef CONFIG_MMU
> diff --git a/fs/exec.c b/fs/exec.c
> index b92fe7db1..0978ae613 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2024,6 +2024,48 @@ static int __init init_fs_exec_sysctls(void)
>  fs_initcall(init_fs_exec_sysctls);
>  #endif /* CONFIG_SYSCTL */
>  
> +char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *elf_interpreter)
> +{
> +	char *pathbuf, *path, *slash, *resolved;
> +
> +	if (strncmp(elf_interpreter, "$ORIGIN", 7) != 0) {
> +		char *ret = kstrdup(elf_interpreter, GFP_KERNEL);
> +
> +		return ret ? ret : ERR_PTR(-ENOMEM);
> +	}
> +
> +	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!pathbuf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	path = file_path(bprm->file, pathbuf, PATH_MAX);
> +	if (IS_ERR(path)) {
> +		kfree(pathbuf);
> +		return (char *)path;
> +	}
> +
> +	slash = strrchr(path, '/');
> +	if (slash) {
> +		if (slash == path)
> +			*(slash + 1) = '\0';
> +		else
> +			*slash = '\0';
> +	} else {
> +		kfree(pathbuf);
> +		char *ret = kstrdup(elf_interpreter, GFP_KERNEL);
> +
> +		return ret ? ret : ERR_PTR(-ENOMEM);
> +	}
> +
> +	resolved = kasprintf(GFP_KERNEL, "%s%s", path, elf_interpreter + 7);
> +	kfree(pathbuf);
> +	if (!resolved)
> +		return ERR_PTR(-ENOMEM);
> +
> +	return resolved;
> +}
> +EXPORT_SYMBOL(resolve_elf_interpreter);
> +
>  #ifdef CONFIG_EXEC_KUNIT_TEST
>  #include "tests/exec_kunit.c"
>  #endif
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 2c77e383e..17419cd3d 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -150,4 +150,6 @@ extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
>  int kernel_execve(const char *filename,
>  		  const char *const *argv, const char *const *envp);
>  
> +char *resolve_elf_interpreter(struct linux_binprm *bprm, const char *elf_interpreter);
> +
>  #endif /* _LINUX_BINFMTS_H */
> -- 
> 2.51.2
> 

Thanks,
Jori.

[1]: https://sashiko.dev/#/patchset/20260622043934.179879-1-farid.m.zakaria%40gmail.com

