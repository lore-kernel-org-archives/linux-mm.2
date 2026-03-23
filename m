Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECD0F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD1C6B009B; Mon, 23 Mar 2026 14:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD476B009F; Mon, 23 Mar 2026 14:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3B46B00A0; Mon, 23 Mar 2026 14:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 475CF6B009B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:21:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C1441EED7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:21:34 +0000 (UTC)
X-FDA: 84578145708.28.34D03DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 03C2A4000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:21:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774290092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nCHX+tDcrCGiwi0oGeFHT7dM1ri9COBAZZl3YVv8VM=;
	b=4c40uk0OqDe5JYy4+KXQAhhcPdkfpUtA/aA+2g8mP9k494cjUsJO0BxEqQ+S3uWbcI5pEs
	6ztbeMpgR1H1dLw9zKTvvd/N4SYPks6wy5m3HCeu/HHMPDPzzKw4smCnskt+LIqGWGxz12
	RkJ2jLQF3m2M4ipXkl8gbL2/XfsihV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774290092; a=rsa-sha256;
	cv=none;
	b=3UT0Vd4rmg+3yEXrp2VQJVZnGmzZQ/fS5VGQ3/3Z0xs2JVfWQeqR52EVgb5oCtNy9T9+h2
	8o66ahKCg41vt7+cTlNSPRoapt0SXEU0hSVzXButHB9ADI7tXAO58xugARbcvk650pn7Kd
	CkxGpyeQ95QfSoXLXzVQ+oHopscZtyM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFC2A1477;
	Mon, 23 Mar 2026 11:21:24 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EEAE3F73B;
	Mon, 23 Mar 2026 11:21:27 -0700 (PDT)
Date: Mon, 23 Mar 2026 18:21:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
Message-ID: <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com>
References: <20260323175340.3361311-1-avagin@google.com>
 <20260323175340.3361311-2-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323175340.3361311-2-avagin@google.com>
X-Rspamd-Queue-Id: 03C2A4000A
X-Stat-Signature: bxpr4swaawenpsypcp9ga18jpzugz5e9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774290091-200823
X-HE-Meta: U2FsdGVkX188HgG4/1kPYcmBvlCPOz1uCMjYjq0Fc2v1mX9i97OvSXuzY+KT+ZtOj2qmofO128SSwwcexgfIpcYuLY6QRLOwAkJ422zsLmxFEJnNxB0SG0PvayabpvG9jIt2+aG76cLctxiYlu62oPz5ewEAwfCy2ifa8yIedtlptLCCq9Wnt1Bo3JT1YstgBapT8N2cj7EGe9fqIM/cMgC9hf1K2NGSrC6eRWcLaeUP+BJNMeClcNJWBoWRqP4beLrB/5T4zIn2pkiU03QgPSFzoZTRRw5t0VDhtvGE12G+E83wK18zIA9TQBAxnpKom3wKdgsXeitfg5CqTNn+aOLXDdn0d+DXH41Km9VKeH0hOhGP73MGpsp+8tQPlc7TrmWK81MHZyG7D7sO0lChKuuUg5HxHls7A1z8McAGxCtWlJ/MpZ1gN4hebFyQOmDtooBKzzJs7E+MW4bipkLkut9NNPE8Pni12PQuaLVuhu1kVfJLir5iF4ccBe+COoxhkcIjPmYMdN7UNCIUsIim3q4wRbU+WGE2PUCLpC2JltLHU2EwLp4/gBsu29DUrmjfkxmnUse6ekvk7Rx0djD/Tsmp8XAFmJuDtHKjk3UEiJ+2U8Idzon8BU6iCg/IjhZ0C7U2jbYHEnE3TvlaGZWlU0+bONbJeLDstK3mKMSFNysz1vi8LlmLUPKpR33jlqSH5iKfbxJDBXfhsNiEXdR7ROQvfy0llvoJspWMFsJ7bfuRNAVDKBD56JrNb0ZMQbfsfLwuPAO4AknGu6/t80Sgxg2FUpVbEYhxvjCGfuI+cIzyFacG1jxS0XyV6c6elIeUhp7TcpQvbkyH82DprZwN9YRQ6tMFL4/AdEYtJXmMMVHSh6gMCDCIhA63v88p7sYWlotNTA3Eb7oak5WtZ+DthQqf/1hSf+q5JVFDxQS0ghxOTjZiUJpNI9nlj0KuXmJqrx17XkCqjxFgnDje/es
 F95zS1vv
 jHNLAaeSvC4bu5yEEijbE3yKXmfmZLPEeZ21QtR6jDlH5JUZdT+C6pQu2R49l8GGhn5WtCnhosAiUI9X2+JiL8dATkp5PiVL68Jru8oZn51COPL3HopzKQLhVLr6KLTshUT3duiYwMOXPiwcPnCSraGCIwZFGlOuUDEAgoNM0zkg40xa7Qfag2HTHdhYuBIfIIn8ouZ+wqH+0uvN+L+Y7hWREFxe3mTwUcpfAQ63eJeIwbw9ZamSpDuvVhUopKmMSx0pQegox+mMAuFRC1hIq7xaAuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> AT_HWCAP2, etc.) from a parent process when they have been modified via
> prctl.
> 
> To support C/R operations (snapshots, live migration) in heterogeneous
> clusters, we must ensure that processes utilize CPU features available
> on all potential target nodes. To solve this, we need to advertise a
> common feature set across the cluster.
> 
> This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
> execve() is called, if the current process has MMF_USER_HWCAP set, the
> HWCAP values are extracted from the current auxiliary vector and stored
> in the linux_binprm structure. These values are then used to populate
> the auxiliary vector of the new process, effectively inheriting the
> hardware capabilities.
> 
> The inherited HWCAPs are masked with the hardware capabilities supported
> by the current kernel to ensure that we don't report more features than
> actually supported. This is important to avoid unexpected behavior,
> especially for processes with additional privileges.

At a high level, I don't think that's going to be sufficient:

* On an architecture with other userspace accessible feature
  identification mechanism registers (e.g. ID registers), userspace
  might read those. So you might need to hide stuff there too, and
  that's going to require architecture-specific interfaces to manage.

  It's possible that some code checks HWCAPs and others check ID
  registers, and mismatch between the two could be problematic.

* If the HWCAPs can be inherited by a more privileged task, then a
  malicious user could use this to hide security features (e.g. shadow
  stack or pointer authentication on arm64), and make it easier to
  attack that task. While not a direct attack, it would undermine those
  features.

Mark.

> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf.c          | 13 ++++++---
>  fs/binfmt_elf_fdpic.c    | 13 ++++++---
>  fs/exec.c                | 62 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/binfmts.h  | 11 +++++++
>  include/linux/mm_types.h |  2 ++
>  kernel/fork.c            |  3 ++
>  kernel/sys.c             |  5 +++-
>  7 files changed, 100 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index fb857faaf0d6..d99db73c76f0 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -183,6 +183,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	int ei_index;
>  	const struct cred *cred = current_cred();
>  	struct vm_area_struct *vma;
> +	bool user_hwcap = mm_flags_test(MMF_USER_HWCAP, mm);
>  
>  	/*
>  	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
> @@ -247,7 +248,8 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	 */
>  	ARCH_DLINFO;
>  #endif
> -	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP, user_hwcap ?
> +			      (bprm->hwcap & ELF_HWCAP) : ELF_HWCAP);
>  	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>  	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
>  	NEW_AUX_ENT(AT_PHDR, phdr_addr);
> @@ -265,13 +267,16 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
>  	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
>  #ifdef ELF_HWCAP2
> -	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> +	NEW_AUX_ENT(AT_HWCAP2, user_hwcap ?
> +			       (bprm->hwcap2 & ELF_HWCAP2) : ELF_HWCAP2);
>  #endif
>  #ifdef ELF_HWCAP3
> -	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
> +	NEW_AUX_ENT(AT_HWCAP3, user_hwcap ?
> +			       (bprm->hwcap3 & ELF_HWCAP3) : ELF_HWCAP3);
>  #endif
>  #ifdef ELF_HWCAP4
> -	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
> +	NEW_AUX_ENT(AT_HWCAP4, user_hwcap ?
> +			       (bprm->hwcap4 & ELF_HWCAP4) : ELF_HWCAP4);
>  #endif
>  	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
>  	if (k_platform) {
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 95b65aab7daa..92c88471455a 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -508,6 +508,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  	unsigned long flags = 0;
>  	int ei_index;
>  	elf_addr_t *elf_info;
> +	bool user_hwcap = mm_flags_test(MMF_USER_HWCAP, mm);
>  
>  #ifdef CONFIG_MMU
>  	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
> @@ -629,15 +630,19 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  	 */
>  	ARCH_DLINFO;
>  #endif
> -	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP,	user_hwcap ?
> +				(bprm->hwcap & ELF_HWCAP) : ELF_HWCAP);
>  #ifdef ELF_HWCAP2
> -	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
> +	NEW_AUX_ENT(AT_HWCAP2,	user_hwcap ?
> +				(bprm->hwcap2 & ELF_HWCAP2) : ELF_HWCAP2);
>  #endif
>  #ifdef ELF_HWCAP3
> -	NEW_AUX_ENT(AT_HWCAP3,	ELF_HWCAP3);
> +	NEW_AUX_ENT(AT_HWCAP3,	user_hwcap ?
> +				(bprm->hwcap3 & ELF_HWCAP3) : ELF_HWCAP3);
>  #endif
>  #ifdef ELF_HWCAP4
> -	NEW_AUX_ENT(AT_HWCAP4,	ELF_HWCAP4);
> +	NEW_AUX_ENT(AT_HWCAP4,	user_hwcap ?
> +				(bprm->hwcap4 & ELF_HWCAP4) : ELF_HWCAP4);
>  #endif
>  	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
>  	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
> diff --git a/fs/exec.c b/fs/exec.c
> index 9ea3a775d51e..1cd7d87a0e79 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1775,6 +1775,65 @@ static int bprm_execve(struct linux_binprm *bprm)
>  	return retval;
>  }
>  
> +static void inherit_hwcap(struct linux_binprm *bprm)
> +{
> +	struct mm_struct *mm = current->mm;
> +	bool compat = in_compat_syscall();
> +	int i, n;
> +
> +#ifdef ELF_HWCAP4
> +	n = 4;
> +#elif defined(ELF_HWCAP3)
> +	n = 3;
> +#elif defined(ELF_HWCAP2)
> +	n = 2;
> +#else
> +	n = 1;
> +#endif
> +
> +	for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
> +		unsigned long type, val;
> +
> +		if (!compat) {
> +			type = mm->saved_auxv[i];
> +			val = mm->saved_auxv[i + 1];
> +		} else {
> +			compat_uptr_t *auxv = (compat_uptr_t *)mm->saved_auxv;
> +
> +			type = auxv[i];
> +			val = auxv[i + 1];
> +		}
> +
> +		switch (type) {
> +		case AT_NULL:
> +			goto done;
> +		case AT_HWCAP:
> +			bprm->hwcap = val;
> +			break;
> +#ifdef ELF_HWCAP2
> +		case AT_HWCAP2:
> +			bprm->hwcap2 = val;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP3
> +		case AT_HWCAP3:
> +			bprm->hwcap3 = val;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP4
> +		case AT_HWCAP4:
> +			bprm->hwcap4 = val;
> +			break;
> +#endif
> +		default:
> +			continue;
> +		}
> +		n--;
> +	}
> +done:
> +	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
> +}
> +
>  static int do_execveat_common(int fd, struct filename *filename,
>  			      struct user_arg_ptr argv,
>  			      struct user_arg_ptr envp,
> @@ -1843,6 +1902,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>  			     current->comm, bprm->filename);
>  	}
>  
> +	if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +		inherit_hwcap(bprm);
> +
>  	return bprm_execve(bprm);
>  }
>  
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 65abd5ab8836..94a3dcf9b1d2 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_BINFMTS_H
>  #define _LINUX_BINFMTS_H
>  
> +#include <linux/elf.h>
>  #include <linux/sched.h>
>  #include <linux/unistd.h>
>  #include <asm/exec.h>
> @@ -67,6 +68,16 @@ struct linux_binprm {
>  	unsigned long exec;
>  
>  	struct rlimit rlim_stack; /* Saved RLIMIT_STACK used during exec. */
> +	unsigned long hwcap;
> +#ifdef ELF_HWCAP2
> +	unsigned long hwcap2;
> +#endif
> +#ifdef ELF_HWCAP3
> +	unsigned long hwcap3;
> +#endif
> +#ifdef ELF_HWCAP4
> +	unsigned long hwcap4;
> +#endif
>  
>  	char buf[BINPRM_BUF_SIZE];
>  } __randomize_layout;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3cc8ae722886..62dde645f469 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1919,6 +1919,8 @@ enum {
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
>  
> +#define MMF_USER_HWCAP		32	/* user-defined HWCAPs */
> +
>  #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>  				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bc2bf58b93b6..2ac277aa078c 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1105,6 +1105,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  
>  		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
>  		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
> +
> +		if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +			mm_flags_set(MMF_USER_HWCAP, mm);
>  	} else {
>  		__mm_flags_overwrite_word(mm, default_dump_filter);
>  		mm->def_flags = 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index cdbf8513caf6..e4b0fa2f6845 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2157,8 +2157,10 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
>  	 * not introduce additional locks here making the kernel
>  	 * more complex.
>  	 */
> -	if (prctl_map.auxv_size)
> +	if (prctl_map.auxv_size) {
>  		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> +		mm_flags_set(MMF_USER_HWCAP, mm);
> +	}
>  
>  	mmap_read_unlock(mm);
>  	return 0;
> @@ -2190,6 +2192,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
>  
>  	task_lock(current);
>  	memcpy(mm->saved_auxv, user_auxv, len);
> +	mm_flags_set(MMF_USER_HWCAP, mm);
>  	task_unlock(current);
>  
>  	return 0;
> -- 
> 2.53.0.983.g0bb29b3bc5-goog
> 
> 

