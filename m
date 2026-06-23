Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7130FCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC376B0088; Tue, 23 Jun 2026 16:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3D96B008A; Tue, 23 Jun 2026 16:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FE96B008C; Tue, 23 Jun 2026 16:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 297C76B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:14:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1FB51C0599
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:14:44 +0000 (UTC)
X-FDA: 84912280488.24.43396CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DFFD4001C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:14:35 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782245675;
	b=4S/BYSJqFTP1iwlguVHHf3bKcxSDuw4qNH9WyeynJCktvTK12Dlb8gPZYY1rYeLx4RSuK/
	RYSjlm8U/JQpwWDq+Hy/L1CMvphEtq5kcgw6ypS0Lk4DGn7U9NCw6lib72UKIO18VI4/z1
	wFNpCHMaWk6G0eypaZ0xcLjbYJip6Zw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra1bLWv4R1sxRHDql8Lrgj/OtpZzKuZ/JFVnOfvRwes=;
	b=wPkLigHqWhxOnirDlYv+dd3/+URfV5+GdY2h4XG+BrT9q39rXrYkyhPAN//eIceTthEKlu
	a1G0dF0JgIA8ooV8RFpxAmZp6N7yQfa4f1cZbbhsJVwQFZKc4F/HHJ9kXnn0KKvU+fz4Xp
	GLtGjurzWSAY7TSDjutTwrlXuKZlcs4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJAZRpdB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C0AA4431E;
	Tue, 23 Jun 2026 20:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB461F00A3A;
	Tue, 23 Jun 2026 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245674;
	bh=Ra1bLWv4R1sxRHDql8Lrgj/OtpZzKuZ/JFVnOfvRwes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZJAZRpdBwWufrpjPgspdDTMpomP3SINRtHl8ZOxMtF3PzVz1QwLXUZTwQeAf+uol9
	 1eIpnqZcQyu2eA9WuB6vdOXm9HrjZdTgIPf+GrfrgLo8/1h8rMn/j5yDRNaQWYcg1z
	 SoHVXI9jcgMMPfJkeYwgC4Aatt17v9Hrbt5Q4aTLYVl0YHTUn9K219XN/LW5EzZI0y
	 B0d5t1wmHvNPJk9v6TNFwFUo5f4iAyISIUYJYHJhlyOkJaw1/mmdsfWGo5L315qei/
	 YFO0TfeLjSI4hSuiUWmQa08cUvaJ9yIlXFnzTK6RlmVc+HJmDya/kd/485ShKYpsJz
	 AZUK1DyLQaYzA==
Date: Tue, 23 Jun 2026 13:14:34 -0700
From: Kees Cook <kees@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <202606231236.325C882A78@keescook>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <20260622043934.179879-2-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622043934.179879-2-farid.m.zakaria@gmail.com>
X-HE-Tag: 1782245675-20963
X-HE-Meta: U2FsdGVkX18lGy4T423lIXxOoRBharMqF7dchLcdOG32AzmRewiAOOcB5pq/62dYEir2ARpgyC3TDiqjSsEk6pcTtOGlMA9LwwT8ffamqvWMuI47zn2mn0w49a3I9Z5IHcaeCEOdBMG/pd3x3X/50ccWLo87a23pGxiSJZuharIbJMSwG7zAkSM5FOnRmRTFqWV+8XwFErfwdmdUFTahj7QlfcgcEXIRsr+WH/4UEHoVVoh0uGrhaqHM+0LDx2240HTuRqYfYKODuNMD7HJbp6qRZnSucg++qaZNqgkIThUaiGoG3t3TmnCt6dKAm2tFXN6uVJsikCEE0xARp2wnZyHgtw0fSgvHJ3EjI07trJpMYcKKf0bEEqZTe8kULI2qTybk6W4VpdmB4pqry10YpZk7cbc1NxGbVmlI1S5aIbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Does any other OS that implements ELF support also support $ORIGIN in
the loader? $ORIGIN isn't even part of the ELF spec at all and is a
glibc extension, IIUC.

I'm not excited about path-based string manipulations as they end up
being racy, and mucking with loader path seems like we're inviting
trouble (since the _binary_ specifies setuid-ness), and we've seen
issues with $ORIGIN before, even strictly outside of the kernel:
https://seclists.org/fulldisclosure/2010/Oct/257

> [...]
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

But even if we did take this, I really don't want to incur a universal
penalty on exec for it. This is doing a kmalloc+dup (and later kfree)
for all non-$ORIGIN execs. So even if this gets added, it needs to be
handled differently.

I would probably say this helper should return a struct file * instead
and have a fast-path for the common case. I think a check for leading
'$' (if strncmp doesn't get inlined) would be okay here as far as
"incurring common performance cost"; that string is almost certainly
cache-hot.

> +	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
> +	if (!pathbuf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	path = file_path(bprm->file, pathbuf, PATH_MAX);
> +	if (IS_ERR(path)) {
> +		kfree(pathbuf);
> +		return (char *)path;
> +	}

This still just _feels_ like an info leak or a race condition to me. I
can't give a credible example, though. But it creeps me out. :)
(I note the blog post also says "and the shabang" and I get even more
creeped out about seeing that patch.)

> +
> +	slash = strrchr(path, '/');
> +	if (slash) {
> +		if (slash == path)
> +			*(slash + 1) = '\0';

This is not idiomatic string manipulation.

> +		else
> +			*slash = '\0';

More readable, IMO, as:

	if (slash)
		slash[1] = '\0';
	else
		path = "";

But does this match the glibc resolution logic? i.e. should it be:

	if (strncmp(elf_interpreter, "$ORIGIN/", 8) != 0)
	...
	if (!slash)
		slash = path;
	*slash = '\0';
	...
	resolved = kasprintf(GFP_KERNEL, "%s/%s", path, elf_interpreter + 8);

(requires the trailing /)

> +	} else {
> +		kfree(pathbuf);
> +		char *ret = kstrdup(elf_interpreter, GFP_KERNEL);
> +
> +		return ret ? ret : ERR_PTR(-ENOMEM);

This is the same as the logic top of the function. This repetition smells
of the LLM. :)

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

So, I guess, I'd like more convincing, but I'm very happy to see a KUnit
test included!

-Kees

-- 
Kees Cook

