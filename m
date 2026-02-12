Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D0CEEA86E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 23:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B016B0005; Thu, 12 Feb 2026 18:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D311C6B0089; Thu, 12 Feb 2026 18:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E0E6B008A; Thu, 12 Feb 2026 18:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B43926B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:49:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28C8B13A878
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:49:36 +0000 (UTC)
X-FDA: 84437449152.04.9150163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B4B780002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:49:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/YdLykm";
	spf=pass (imf02.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770940174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lj+pRfOVX/cKq4rFR7NGKHi9MnkrpkoK7LfIyB86Nzo=;
	b=DbPAsj7pByL+BXk17VWSLk99nUpkWxCanio5lyuMWdGxtcpjN63RWIwDyliztkc57Qnvn2
	wA/wYE/dX5huoStadDSSCM/YcEkKdfmcOA1fuBDPmH03InCKERR3ZSoye2UAnssayxnPyY
	FK9wW+VXhuwyoCzamp81cAPdjy2WwU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/YdLykm";
	spf=pass (imf02.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770940174; a=rsa-sha256;
	cv=none;
	b=tx86ST0OqMBZIiAvpPF8pHzU2Yw6lLhxMO/Aj6xUSxK3z1p3sDlp33C3UbiXqEQpGrR+mf
	lrRUR85cexSJhIJZ0ZAr4ExD0kXC+tba3/fMnPOOm+gw6ixWy9svlQghObS/rdJVLFnh0c
	Rybed/iDjSGx7Gw2/pwSWW+KY973rP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D952E60018;
	Thu, 12 Feb 2026 23:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8829AC4CEF7;
	Thu, 12 Feb 2026 23:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770940173;
	bh=BUnKZvCHoKZldYxIZ6f4S7349lRTK9sq5vQGPDLZwVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q/YdLykmY2ZtXJhal8y2HPLVIlLFlec5+DIp9N7tGLqTcBNVtvo67QGoSvqSVcR9B
	 5DZCNbN0BwGrV49Tu9Re6Sbt6ipN348Xbs6vE0RtHG6lbYoxou4DHUNTEkJRCC28U9
	 AYocDimeGIJr6JwNTVjMoFF9oDmYy7rt+lJbZkxxbQW0Ml8HgSK2D7kIv8Ojk89/Gp
	 5UOB5ZMs7t0Qc2nLOGhr3qREp3yAgOYrTX6uBBx5kiy9XPbDtpp62eqjZ3ytgIj85g
	 txKdeabi/yZl8TAW9q2NlayY+LZXDjGvU0PJCHdv5KxBWMmg3fcf/nsBH1+32kREp/
	 x8zHcSSjIoP3Q==
Date: Thu, 12 Feb 2026 15:49:33 -0800
From: Kees Cook <kees@kernel.org>
To: Andrei Vagin <avagin@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>
Subject: Re: [PATCH 2/4] exec: inherit HWCAPs from the parent process
Message-ID: <202602121537.8F87466@keescook>
References: <20260209190605.1564597-1-avagin@google.com>
 <20260209190605.1564597-3-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209190605.1564597-3-avagin@google.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: ri35twsrmame1i1a4bsuguwsjgkpxmdd
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B4B780002
X-HE-Tag: 1770940174-281169
X-HE-Meta: U2FsdGVkX1/+jvkxAjAR7fnitsbfbH1VoUO7mg6g0mOVAK6SKKWIvcWaEvZ6/u7JDGA+LJCgEudqpc11oCBkalNXyPA9ZSx2fIU4aFgn9RG+eWG81hSiuzzk2bPAntfvioNEcGf8AefLp3MQ0vKktzAsOty/Ju/q6CNJCI039lyqirfLMPCfk3ANPEhaT7b8PqJ00KadxtofeXbjUPrKKX8SFu/4We4rZl8FI/zYd5g3SlObBlx60mcBdN7f81sJ+rXnuvuFlwdR+4oF6cC5JTo9PIhP8X7CDAJxxoHufkE9OiOEtgag8T2pTza+EAwgixIICqHdiGFcOfPMhgsxF5U1YZ3VDSxm0cAB6oGxQj8Y8BTjAWjBvCnl0nCMPRCJkSQHPJw2JExIyXLEIEamv3WIZPEysj+bo9kbta/CwwP13X2hRPCgMy/SxaN5ziCfGusycn4dI+YQ5bRr7MCHQquKjz+3Rz9zSEBI9tISn+f3HUlvUKUU1AiGzOjORZr9B1EUOIiLN95RFY6QP2sbLtdbRoiJOmt9QK3GJjsejw8RjM/PPU/92kVfyHEKMLCXFQFF466shrZ49PqqJeQD4vSDBEX4iKFMjgb0C/CUIcxN9UqvvQQCjhFe9PASv95h2BTYMha9oEQvP3zef+uDqXyOiQE7F/bGMv0jfjvwTmeZJdLTT+P9/S3VEiVuTksArnBk+W0OlqLSQrAbT0bhqOC37N74lYbBLvOiBrVre7zap0Mj0wKa5oF/OVFEkEB7sbVNgengRMhv7IqiZx8O54SpMfFG2Z5h80ZCDxJV5tN4LBM4V7VFXERp0e/+VO9Qf6K5EggB8JdHJIA8/pynwnN4Aytc0s3emLGbCB3gAEnJrOH2CQwN0rnzH5x3VUFPSo00i8XmhbJmKVfOI5mZRXo3GqtcYUEV3LopFE8g6rzTGPCMv6F4VxuBMplykq63psWyuHOOwHP8VBtzj7V
 eYjERFVG
 mkFcUEnLaAdTmdWihl36RK11SgFG6Ieg4mT21DlE5mYRzaNglXofIqlggX2qlhtYlwdxZoqut1OcoLDSKQtyoJ+pUJJglLfDrWPLhybMu5KOgZ47rDvjl1mXe6GeaOok9DeD7FSgJFuAn9D5WIe/9ZEcH/eYnZKhKK13ES+o3ulFL1uv+DSEnC12zVPUiClrZA5SyTPpxbgb+room2zurzyr10Lnmy06+anq27BTtHGP9QY+OZBxdd51x93f6/Pn/viV2UUfYvxD7b9q1+XRcP6pk2nMuD1xO2wKF1rn+L1NinKluNZXsePDfskBVIJik3fzIXoeccx75ZuJGrTj7rSdbFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 07:06:03PM +0000, Andrei Vagin wrote:
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
> 
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf.c          |  8 +++---
>  fs/binfmt_elf_fdpic.c    |  8 +++---
>  fs/exec.c                | 61 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/binfmts.h  | 11 ++++++++
>  include/linux/mm_types.h |  2 ++
>  kernel/fork.c            |  3 ++
>  kernel/sys.c             |  5 +++-
>  7 files changed, 89 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3eb734c192e9..aec129e33f0b 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -246,7 +246,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	 */
>  	ARCH_DLINFO;
>  #endif
> -	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP, bprm->hwcap);
>  	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>  	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
>  	NEW_AUX_ENT(AT_PHDR, phdr_addr);
> @@ -264,13 +264,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
>  	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
>  #ifdef ELF_HWCAP2
> -	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> +	NEW_AUX_ENT(AT_HWCAP2, bprm->hwcap2);
>  #endif
>  #ifdef ELF_HWCAP3
> -	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
> +	NEW_AUX_ENT(AT_HWCAP3, bprm->hwcap3);
>  #endif
>  #ifdef ELF_HWCAP4
> -	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
> +	NEW_AUX_ENT(AT_HWCAP4, bprm->hwcap4);
>  #endif
>  	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
>  	if (k_platform) {
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index a3d4e6973b29..55b482f03c82 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -629,15 +629,15 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  	 */
>  	ARCH_DLINFO;
>  #endif
> -	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP,	bprm->hwcap);
>  #ifdef ELF_HWCAP2
> -	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
> +	NEW_AUX_ENT(AT_HWCAP2,	bprm->hwcap2);
>  #endif
>  #ifdef ELF_HWCAP3
> -	NEW_AUX_ENT(AT_HWCAP3,	ELF_HWCAP3);
> +	NEW_AUX_ENT(AT_HWCAP3,	bprm->hwcap3);
>  #endif
>  #ifdef ELF_HWCAP4
> -	NEW_AUX_ENT(AT_HWCAP4,	ELF_HWCAP4);
> +	NEW_AUX_ENT(AT_HWCAP4,	bprm->hwcap4);
>  #endif
>  	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
>  	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
> diff --git a/fs/exec.c b/fs/exec.c
> index 9d5ebc9d15b0..7401efbe4ba0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1462,6 +1462,17 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
>  	 */
>  	bprm->is_check = !!(flags & AT_EXECVE_CHECK);
>  
> +	bprm->hwcap = ELF_HWCAP;
> +#ifdef ELF_HWCAP2
> +	bprm->hwcap2 = ELF_HWCAP2;
> +#endif
> +#ifdef ELF_HWCAP3
> +	bprm->hwcap3 = ELF_HWCAP3;
> +#endif
> +#ifdef ELF_HWCAP4
> +	bprm->hwcap4 = ELF_HWCAP4;
> +#endif
> +
>  	retval = bprm_mm_init(bprm);
>  	if (!retval)
>  		return bprm;
> @@ -1780,6 +1791,53 @@ static int bprm_execve(struct linux_binprm *bprm)
>  	return retval;
>  }
>  
> +static void inherit_hwcap(struct linux_binprm *bprm)
> +{
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
> +		long val = current->mm->saved_auxv[i + 1];

Nit: saved_auxv[] are unsigned long, as are all the bprm->hwcap* vars.

> +
> +		switch (current->mm->saved_auxv[i]) {
> +		case AT_NULL:
> +			goto done;
> +		case AT_HWCAP:
> +			bprm->hwcap = val & ELF_HWCAP;
> +			break;
> +#ifdef ELF_HWCAP2
> +		case AT_HWCAP2:
> +			bprm->hwcap2 = val & ELF_HWCAP2;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP3
> +		case AT_HWCAP3:
> +			bprm->hwcap3 = val & ELF_HWCAP3;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP4
> +		case AT_HWCAP4:
> +			bprm->hwcap4 = val & ELF_HWCAP4;
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
> @@ -1856,6 +1914,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>  			     current->comm, bprm->filename);
>  	}
>  
> +	if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +		inherit_hwcap(bprm);
> +
>  	retval = bprm_execve(bprm);
>  out_free:
>  	free_bprm(bprm);
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
> index 78950eb8926d..68c9131dceee 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1871,6 +1871,8 @@ enum {
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
>  
> +#define MMF_USER_HWCAP		32	/* user-defined HWCAPs */

NUM_MM_FLAG_BITS is already 64, but this seems to be the first user of
the next u32 in the bitmap. It _should_ be safe, but we'll need to look
for unexpected weird bugs. :)

> +
>  #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>  				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8e..0091315643de 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1103,6 +1103,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
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
> index 8d199cf457ae..6fbd7be21a5f 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2157,8 +2157,10 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
>  	 * not introduce additional locks here making the kernel
>  	 * more complex.
>  	 */
> -	if (prctl_map.auxv_size)
> +	if (prctl_map.auxv_size) {
>  		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> +		mm_flags_set(MMF_USER_HWCAP, current->mm);
> +	}
>  
>  	mmap_read_unlock(mm);
>  	return 0;
> @@ -2190,6 +2192,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
>  
>  	task_lock(current);
>  	memcpy(mm->saved_auxv, user_auxv, len);
> +	mm_flags_set(MMF_USER_HWCAP, current->mm);
>  	task_unlock(current);
>  
>  	return 0;
> -- 
> 2.53.0.239.g8d8fc8a987-goog
> 

-- 
Kees Cook

