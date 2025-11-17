Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9600ACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 09:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB788E0018; Mon, 17 Nov 2025 04:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC1B8E0002; Mon, 17 Nov 2025 04:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B218E0018; Mon, 17 Nov 2025 04:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB7588E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:48:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3668A1A0C93
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:48:51 +0000 (UTC)
X-FDA: 84119624862.02.1935469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79CFCC0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:48:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXc3AudH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763372929; a=rsa-sha256;
	cv=none;
	b=w2i5xr5qcdYS9iZrvLAd6WUhpLBlqgwixxwlDarIMXaXjegM2fk/VcZreMPSgQlqJpnoGM
	F7CmmOaytEaXX/qTAMdZdZisx8JkiY576Z+NmkxE8bapQQR97IOGBj/MQ3XjMQB/5X+l44
	71U7bog2S/u3MiZNXg4E3sh2rskEjkQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXc3AudH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763372929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQow2kKcCS8Q2y2TaPEd9Ft+/We17L9s3d7Guxx5ZS8=;
	b=polKgNSsLFG+nIgsEwfuxL3b9Xnz8kaPpbwhQB+xzsRxFpJsJ0X2dwu7m+QQxIqpoI/Cq9
	M13ozCDM0rzjjubVlT0jzIhy4U/FjCSXBqT+GrTDdQtXa89LyslfJ93S2C0CgOfaEHmI/4
	LNqgIznT+neU4RmnQ6SzM3SI0UPvGFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71BDA40AD1;
	Mon, 17 Nov 2025 09:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEF7C4CEF5;
	Mon, 17 Nov 2025 09:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763372928;
	bh=lm1w5FuS0DFB8h8yriOEHrATD1xOM/lURkIhKIQpwx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SXc3AudH1OcuTxWg9OhFFVFP1nWirXtdO1p8OrOMzac+67OuDLkRz4ILPP6fVSALp
	 /FbXlUfKN2ZqyIZO3SFzOhbbbqmC2Z86SKwLoD9XyFGPsHtZU+1VwzcobeHdGPdC5m
	 54CJLuAlBSE64se+irsZX2F5e70m/vq92kn/oHf3DGlIeWfbhsCCrasmYoDchg7fRR
	 BY4na8GLM3cbXQevPwcrFoOhVgHiO9zWC/7t8Dh0EgtknybsgJlwU8qjyFgFQP+eV3
	 ZlRWl0ggiJpxxK7ALwoCwBJzw5EWBAi4stEaB7qIPc7tc6pfgp491Hjf3BtbERlnOu
	 LCc5gzOIltBsw==
Date: Mon, 17 Nov 2025 11:48:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 11/20] mm: shmem: use SHMEM_F_* flags instead of VM_*
 flags
Message-ID: <aRrvaHh-cP8jygAF@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-12-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-12-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79CFCC0012
X-Stat-Signature: zmndyma8g7rk7iga1mchkx5eo3rpz6c4
X-HE-Tag: 1763372929-368510
X-HE-Meta: U2FsdGVkX189Dn6CqbPuvBSyblLc0GBWIjl9PaZLOc3dE+6AizT1cw3g7NM9ektf+pZ3sbg4ZswPCDha0C1SOJaJZpJzwxYdz7u3R7MDw+pJB1LsrrJA96xMv7cM8gWFDdngqafb9Up1OMCz1h3NCyLhKf/XqoscYzWGHO8mXeGZ/DPcvl68k7UgHv8Aqj3Ha1rL1QSaMssqaQYCEhNur6PYH7CQuAwnLV/lhB8VWgq2t+zhrID5u6+FNJBbG+YN+Z7Z221b85+h2TVsLHbcHL6FdqotwbJ86LAgcT2vAuP6PmhG7ipksvHZWaZF+KcN/AaUFNdzUT/VR8/wqBsVNLYOtlXdkTXlkzMcaOTrO62iNxPwdlKTY/+7on8HPHstLNLg5V1H/2/0DSv+LmbCLCmSYIKghXnOlc0E1iF3q0gBHKW4iFWNbrU2iMFxDgrBsCTUUPV1Vrv8JmhK//45C2tg+I3NTTiNtHRvoocIeq3r+iVetOdTA/P8r4ONScyRoS6XF/sKwkyMUrLY81qQNi4Yt/hn04kIZg/OAvsA0OOkH/tYrBq9mM6H6ROz/Uk+OkfIC0SkYUnpPv21d+b7MiIQZatPGGgUaNPHiaaO9SvA7yTdiwTJqYBja6YmwMcFB0UNNi6ZaEpwvJs8qlq+aNhJWcB+/phHv5s62n/lVS3ybKepQZAhLmS+V4Pa71JxA8iY6BKqHY2LtNplovYitsO5S7zOpAOokL9XCAeQvYCz4wBkzH8gU4CbQeRSa2Ld+fg5aCGcf1bZ7r2rgeD/t2V31qODxpOGpYAe+UZUNHfgtLi1WNgDw6Sw0N+u+yItEAUn0BplSF98QWc2RVPsEYaReR9fT9jwRwIy9xfMaVS2Nsgdp1KnsZivgPQ2YJGLndiftIrzuGvc87+WGgE79y2QhOUxNoEI7oLjK5nndSBua0vrSQWK5mLz3yxUEQx3/3LnyaTYzOETAuGbwvF
 DU7qT10O
 ML/GvF83jCgFROdgoq12miNaOQ2kElExTIvWzpm9/R+fkg7BStbDT8AQmurmZeEmeMv+NMe8tzJ1xfgX7VsPdJwDxaEj5ZJIA+5iqVmsHIHbmBU77maAF9owHSAf5bP9g0BtQDfEr8EdQHAKNqUob+6NSAU89sOHKG/tj7pvDQkh/fe/rVaY0aIyzQtB9L26LlmT7EBpcAAvk5QKvsObV+YfDkP+hKwP9hGvLd+r1AlQjOt6TSujKi7UMi9ujgSSKzYXEpfpx0TyytB9fA3gzpNM3toC9OZa9EOabOyyF1RVaU9KlNFK+OBSwzN0oHDsShJeo7MujUwd1MfV+I+ewosiKFRCASuUphikCS77qCKG7Rpn+PnVmcTI87TW33i5di1i3BAmOyCW4RJaWCPaiceVL4hwFsyenm4QQ/cbQAtbYjdXUVRPa8cAYTNxOTjBBIWCtHCfZFIh9rl4dZ59YGXoB3p1cRkC1nFjT356fuviVVxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:57PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> shmem_inode_info::flags can have the VM flags VM_NORESERVE and
> VM_LOCKED. These are used to suppress pre-accounting or to lock the
> pages in the inode respectively. Using the VM flags directly makes it
> difficult to add shmem-specific flags that are unrelated to VM behavior
> since one would need to find a VM flag not used by shmem and re-purpose
> it.
> 
> Introduce SHMEM_F_NORESERVE and SHMEM_F_LOCKED which represent the same
> information, but their bits are independent of the VM flags. Callers can
> still pass VM_NORESERVE to shmem_get_inode(), but it gets transformed to
> the shmem-specific flag internally.
> 
> No functional changes intended.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/shmem_fs.h |  6 ++++++
>  mm/shmem.c               | 28 +++++++++++++++-------------
>  2 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 0e47465ef0fd..650874b400b5 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -10,6 +10,7 @@
>  #include <linux/xattr.h>
>  #include <linux/fs_parser.h>
>  #include <linux/userfaultfd_k.h>
> +#include <linux/bits.h>
>  
>  struct swap_iocb;
>  
> @@ -19,6 +20,11 @@ struct swap_iocb;
>  #define SHMEM_MAXQUOTAS 2
>  #endif
>  
> +/* Suppress pre-accounting of the entire object size. */
> +#define SHMEM_F_NORESERVE	BIT(0)
> +/* Disallow swapping. */
> +#define SHMEM_F_LOCKED		BIT(1)
> +
>  struct shmem_inode_info {
>  	spinlock_t		lock;
>  	unsigned int		seals;		/* shmem seals */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 58701d14dd96..1d5036dec08a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -175,20 +175,20 @@ static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>   */
>  static inline int shmem_acct_size(unsigned long flags, loff_t size)
>  {
> -	return (flags & VM_NORESERVE) ?
> +	return (flags & SHMEM_F_NORESERVE) ?
>  		0 : security_vm_enough_memory_mm(current->mm, VM_ACCT(size));
>  }
>  
>  static inline void shmem_unacct_size(unsigned long flags, loff_t size)
>  {
> -	if (!(flags & VM_NORESERVE))
> +	if (!(flags & SHMEM_F_NORESERVE))
>  		vm_unacct_memory(VM_ACCT(size));
>  }
>  
>  static inline int shmem_reacct_size(unsigned long flags,
>  		loff_t oldsize, loff_t newsize)
>  {
> -	if (!(flags & VM_NORESERVE)) {
> +	if (!(flags & SHMEM_F_NORESERVE)) {
>  		if (VM_ACCT(newsize) > VM_ACCT(oldsize))
>  			return security_vm_enough_memory_mm(current->mm,
>  					VM_ACCT(newsize) - VM_ACCT(oldsize));
> @@ -206,7 +206,7 @@ static inline int shmem_reacct_size(unsigned long flags,
>   */
>  static inline int shmem_acct_blocks(unsigned long flags, long pages)
>  {
> -	if (!(flags & VM_NORESERVE))
> +	if (!(flags & SHMEM_F_NORESERVE))
>  		return 0;
>  
>  	return security_vm_enough_memory_mm(current->mm,
> @@ -215,7 +215,7 @@ static inline int shmem_acct_blocks(unsigned long flags, long pages)
>  
>  static inline void shmem_unacct_blocks(unsigned long flags, long pages)
>  {
> -	if (flags & VM_NORESERVE)
> +	if (flags & SHMEM_F_NORESERVE)
>  		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
>  }
>  
> @@ -1551,7 +1551,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>  	int nr_pages;
>  	bool split = false;
>  
> -	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
> +	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
>  		goto redirty;
>  
>  	if (!total_swap_pages)
> @@ -2910,15 +2910,15 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
>  	 * ipc_lock_object() when called from shmctl_do_lock(),
>  	 * no serialization needed when called from shm_destroy().
>  	 */
> -	if (lock && !(info->flags & VM_LOCKED)) {
> +	if (lock && !(info->flags & SHMEM_F_LOCKED)) {
>  		if (!user_shm_lock(inode->i_size, ucounts))
>  			goto out_nomem;
> -		info->flags |= VM_LOCKED;
> +		info->flags |= SHMEM_F_LOCKED;
>  		mapping_set_unevictable(file->f_mapping);
>  	}
> -	if (!lock && (info->flags & VM_LOCKED) && ucounts) {
> +	if (!lock && (info->flags & SHMEM_F_LOCKED) && ucounts) {
>  		user_shm_unlock(inode->i_size, ucounts);
> -		info->flags &= ~VM_LOCKED;
> +		info->flags &= ~SHMEM_F_LOCKED;
>  		mapping_clear_unevictable(file->f_mapping);
>  	}
>  	retval = 0;
> @@ -3062,7 +3062,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  	spin_lock_init(&info->lock);
>  	atomic_set(&info->stop_eviction, 0);
>  	info->seals = F_SEAL_SEAL;
> -	info->flags = flags & VM_NORESERVE;
> +	info->flags = (flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>  	info->i_crtime = inode_get_mtime(inode);
>  	info->fsflags = (dir == NULL) ? 0 :
>  		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
> @@ -5804,8 +5804,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>  /* common code */
>  
>  static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
> -			loff_t size, unsigned long flags, unsigned int i_flags)
> +				       loff_t size, unsigned long vm_flags,
> +				       unsigned int i_flags)
>  {
> +	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>  	struct inode *inode;
>  	struct file *res;
>  
> @@ -5822,7 +5824,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
>  		return ERR_PTR(-ENOMEM);
>  
>  	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
> -				S_IFREG | S_IRWXUGO, 0, flags);
> +				S_IFREG | S_IRWXUGO, 0, vm_flags);
>  	if (IS_ERR(inode)) {
>  		shmem_unacct_size(flags, size);
>  		return ERR_CAST(inode);
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

