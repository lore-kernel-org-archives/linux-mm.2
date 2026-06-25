Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE97CCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A096B00A5; Thu, 25 Jun 2026 03:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50AC6B00A7; Thu, 25 Jun 2026 03:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66FB6B00AA; Thu, 25 Jun 2026 03:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80B0F6B00A5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:28:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F15CA1405A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:28:20 +0000 (UTC)
X-FDA: 84917606760.10.A92C381
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 149CC40002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:28:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InHGXEXT;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782372499;
	b=rHJo+PoyikykmR1A7mkn+CgGFhWKc992e7erowb4iQJrPFUVm9ZEo00kx7FAZKjXcaeb97
	hhAnFC5d2GOWXKrUQ/QIZjdiBrqYDSnoSnJ+2kCeZvrxB/0Gf2O3ceTwh/LRLwa+4lY8gY
	iZ/HP3DhtnaYU64CHE7GSfH+CsO25hM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782372499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P04TvlBD9QP71s0/lKtJ4I0j+WyUYhmTovuk4tkqFWA=;
	b=UN6i+tJhp5suoIVP8MtMh9HakKffnGHNfE/iI6SbRkNY/gm89eDGlc2u2dRkDRaqApfubK
	vEyrDVs0mwEF7p73fMA/oxqAqRZEl6jw1Go9KtEWdreHtIjQ7zke6LCGPlOk96g2PivwUV
	shhZvhV4HRazCVhKBRtOMWtK7F1s9rI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InHGXEXT;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4419940777;
	Thu, 25 Jun 2026 07:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D931F000E9;
	Thu, 25 Jun 2026 07:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782372498;
	bh=P04TvlBD9QP71s0/lKtJ4I0j+WyUYhmTovuk4tkqFWA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=InHGXEXTihcGMuKNaPsHaM/LKQ4QTJEp9gpyWN1aWSAUjqO4NCJZ7yWbdOVmQ8BYo
	 Z+Q9SESV1VaxGFoLzdczzyupSF0jHeX7kF8516iFMSEv+AtvhwZWKkkSZK7JktCmqz
	 UBtgE5QHw12ahyF1xVtpUMlA2iv1KuVFLHsAIiJh0cR/g9Y/KVlMGHuoMTnRDYVYBw
	 8TlCpIfHt9mSWSanPTptt461iTYvWohzy7ivkIhc8eupl9cbgx2M5nETPZHZcs68lX
	 3i44FElRM6DKTKqU2oL/YhypExW7GN4iW1IVHBwLRyuAanuhS8vVLdTuCwrIxGiVVb
	 ztCa/vOtx6D7Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
From: Christian Brauner <brauner@kernel.org>
To: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, brauner@kernel.org, mjguzik@gmail.com, 
 pfalcato@suse.de, ebiederm@xmission.com, viro@zeniv.linux.org.uk, 
 jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com, 
 alex.aring@gmail.com, arnd@arndb.de, keescook@chromium.org, 
 mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, Xin Zhao <jackzxcui1989@163.com>, 
 linux-mm@kvack.org
In-Reply-To: <20260624145552.70143-1-jackzxcui1989@163.com>
References: <20260624145552.70143-1-jackzxcui1989@163.com>
Date: Thu, 25 Jun 2026 09:28:08 +0200
Message-Id: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=13305; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KUo4NekPNXgv90VG8qkIbf6JzzGOminOB0cX6JdfmA4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZ3OhZodjWND3vVla0xtVsvve8slcnlNyQ0xfinPxvr
 anRkjq/jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlsuMLI8OyGxt5JIVcXhgfL
 WWWFL61ylt5ybYZG+kllu4NWV1aXXWL4p8zZcvlA+jVHhdBvLSzcDvqtOfEfr4i58tydeT6qYZ8
 NCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: 16b65a1pwgpsn7wdp5j46q51ymfkycss
X-Rspamd-Queue-Id: 149CC40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782372498-593133
X-HE-Meta: U2FsdGVkX1/Im2SM0PVjfeJQs9lFaK/9+EJWtFX9lUtp1DLEQgpmVUr3cK7QWG1jOGrAHhoDPKg5xJyhJRncQXya1bpPwJx35jqOdvo6xpr9AkVytjRsV3q997ZIjeD/Rzya05vwITX0/5AkI0svch9aSMMyJ0EEnLyYD0j77C3aQrtSr6otoWuDsLvlNRWlfaNu9M9vUHUdL0+nix8IDJUol7VSgR2ZDHAsvtOD12evqGJFeMO3mKTE+ZYL1GHwUCvqe/0Z/OGAxbvyPtoVxaqkw7k/2HcTVaBIjISBVu07UzrSNluNGLWrQqLeF/RimXd17jxTjBzVD/738GT0JVJ2HZqRvR6ObswtgK022d3kALI9J/w8SWO7SlimllwWubbHVl6vbdn/zVZUFivjVmJUh5hJb4maXLsvmnaQ0Gv3lLcYHyUgcZ6YCbCA/IjmsWDi/VfxB9oc8sfy+8MGDujm6HAVej3JKZtRI8pdP/TNDVVl7POIqxmUx8RhzK0rstRLukk8UlqZrJqpdwMJsovbAXDVB5MNZV+5w2LI6NibXSvoTSDMXE+/SGTtDl+gkXrCgyH5/FLdMDX1eI238iVFbsJJOTkD6vyOTtK+t3PLr5I6n1T5ca496jKM/p4qAhq9uF3MmWtHcSAZkCEW6vjrVlppKePWszLUtsqggAO6s32dMj3XoSM+VyAAuWeBizHint95L7wfizzzvRXAqrIwMhTgp4IXT75jzZW0+hOMo0Wb50vYM28374v4TLrsb21MVC0NnlgaVB5CUoNZpZZNiFHmoRaQXVbFOS1yo2qRgnJOgs9JiGdecHJn5zINeo6K6bd+/TMe+rgIWm1amFhvXNI8sjT8PECSWwuUzkDnR1gfgAlNbC9HdK52jDcNqSZYXi8wWoOqZBetQ1rS3Z5GpGsX2i5jc2paEb5DkGUzjAYzgLf0I03mntaQQDSQGzdldhVGzPuyRb8TzEi
 WV0PQ4t9
 B45QMDiOwbovxMCU0w+qZem+ntFvAGBmxSRPrtaXwnxXXW/0lGYPA1PQeBRU9hVeats5/aa7pvOOA1o5i0OVI7AFowcPI85SCNiH+to9igSATrVrcQ8ZrZMSTaFejZH6spYUndh2d1qtCwO8shc2DtPmnN7MWAQBdRC+VV6hMzn+JVubp78XW1QJXcX755oXM05h9pIyLlv4MfNd8tEoJ+3WrFIO461SjMj979C3JBOSKuwgauXgWmNupwhBM45PFRtGp/+305DNuSur5qIS8J9EoYKtKcwt7s7aHLKHkGBhOFX9ChH/ubDZlE5OEMdOyZCU1YB9zaGHQG1zz0EJtT3XfSVGUSIvABoltpt0vNLCeumBm7nxINKTh0CjhG8CbI6pHesxEoNxW1JUZZ5yd/8ZV2jM1KXV0O77PeGK5bH6po+bAkQ0mzTDW8DDYhPhJpnatcUOwk/meRCLZ3RIpghSRnwODHjHm0EexkSR6wWyzYIg8qJCthxgFpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> A coredump typically takes some time to complete. If we happen to hold a
> write lock with flock just before triggering the coredump, that write lock
> will not be released during the entire coredump process. As a result,
> other processes attempting to acquire the same write lock may experience
> significant delays. Another typical scenario is that shared memory, such
> as dma-buf, remains occupied and is not released for a long time due to
> core dumps.
> 
> To address this, add /proc/<pid>/coredump_pre_exit node so that people can
> specify which resources they want to release before dumping core. This
> patch implements the early release of two types of resources: flock files
> and file-backed shared memory. Default settings are NOT pre-exit anything.
> 
> A temporary bit, O_TMPCLOS, is added to mark vma->vm_file->f_flags during
> the execution of the newly introduced exit_mmap_mapped_shared() function.
> In this way, the subsequent exit_files_pre_exit() function does not need
> to find the corresponding vma through the file to check for the VM_SHARED
> attribute, thereby reducing the traversal cost.
> 
> Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f575d450861e..bc6d3859f874 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1024,6 +1024,11 @@ Kernel parameters
>  			/proc/<pid>/coredump_filter.
>  			See also Documentation/filesystems/proc.rst.
>  
> +	coredump_pre_exit=
> +			[KNL] Change the default value for
> +			/proc/<pid>/coredump_pre_exit.
> +			See also Documentation/filesystems/proc.rst.

Nah, we're not doing a separate file for this. That makes no sense
whatsoever. I've already explained this in the first mail. There are
effectively three modes:

(1) dump to a file
(2) spawn super-privileged usermode helper process connect coredumping
    process and said helper via pipe
(3) coredumping process connects to AF_UNIX socket

Parameterize (1) and (2) via a command line arguments. I strongly
suspect you're using some AI tooling so it should be able to figure out
how this was done in the past.

(3) can be extended by just introducing a new flag value for struct
    coredump_req. That is also illustrated by previous work.

We're not spreading procfs files. It's terrible api design especially
for security sensitive changes.

> +static void coredump_pre_exit(void)
> +{
> +	struct task_struct *tsk = current;
> +	unsigned long flags = __mm_flags_get_dumpable(tsk->mm);
> +
> +	if (!likely(flags & MMF_DUMP_PRE_EXIT_MASK))
> +		return;
> +
> +	/*
> +	 * Set O_TMPCLOS of file f_flags if file needs to be closed.
> +	 */
> +	if (test_bit(MMF_DUMP_PRE_EXIT_FILE_BACKED_SHARED, &flags) &&
> +	    !test_bit(MMF_DUMP_MAPPED_SHARED, &flags))
> +		exit_mmap_mapped_shared(tsk->mm);
> +
> +	/*
> +	 * Check O_TMPCLOS of file f_flags to close file and clear it.
> +	 */
> +	exit_files_pre_exit(tsk, mm_flags_test(MMF_DUMP_PRE_EXIT_FLOCK, tsk->mm));
> +}
> +
>  static int coredump_wait(int exit_code, struct core_state *core_state)
>  {
>  	struct task_struct *tsk = current;
> @@ -1100,6 +1121,8 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
>  		return;
>  	}
>  
> +	coredump_pre_exit();
> +
>  	switch (cn->core_type) {
>  	case COREDUMP_FILE:
>  		if (!coredump_file(cn, cprm, binfmt))
> diff --git a/fs/file.c b/fs/file.c
> index 2c81c0b162d0..a58ffffcc31d 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -23,6 +23,7 @@
>  #include <linux/file_ref.h>
>  #include <net/sock.h>
>  #include <linux/init_task.h>
> +#include <linux/filelock.h>
>  
>  #include "internal.h"
>  
> @@ -527,6 +528,51 @@ void exit_files(struct task_struct *tsk)
>  	}
>  }
>  
> +void exit_files_pre_exit(struct task_struct *tsk, bool checkflock)
> +{
> +	struct files_struct *files = tsk->files;
> +	struct fdtable *fdt;
> +	struct file *file;
> +	unsigned int i, j = 0;
> +
> +	if (!files)
> +		return;
> +
> +	fdt = rcu_dereference_raw(files->fdt);
> +	for (;;) {
> +		unsigned long set;
> +
> +		i = j * BITS_PER_LONG;
> +		if (i >= fdt->max_fds)
> +			break;
> +		set = fdt->open_fds[j++];
> +		while (set) {
> +			if (!(set & 1))
> +				goto next_fd;
> +			file = fdt->fd[i];
> +			if (!file)
> +				goto next_fd;
> +			if (file->f_flags & O_TMPCLOS) {
> +				file->f_flags &= ~O_TMPCLOS;
> +				goto close_fd;
> +			}
> +			if (!checkflock)
> +				goto next_fd;
> +			if (!vfs_inode_has_locks(file_inode(file)))
> +				goto next_fd;
> +
> +close_fd:
> +			fdt->fd[i] = NULL;
> +			filp_close(file, files);
> +			cond_resched();
> +
> +next_fd:
> +			i++;
> +			set >>= 1;
> +		}
> +	}
> +}
> +
>  struct files_struct init_files = {
>  	.count		= ATOMIC_INIT(1),
>  	.fdt		= &init_files.fdtab,
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index d9acfa89c894..99b5f219f7fa 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3026,6 +3026,83 @@ static const struct file_operations proc_coredump_filter_operations = {
>  	.write		= proc_coredump_filter_write,
>  	.llseek		= generic_file_llseek,
>  };
> +
> +static ssize_t proc_coredump_pre_exit_read(struct file *file, char __user *buf,
> +					   size_t count, loff_t *ppos)
> +{
> +	struct task_struct *task = get_proc_task(file_inode(file));
> +	struct mm_struct *mm;
> +	char buffer[PROC_NUMBUF];
> +	size_t len;
> +	int ret;
> +
> +	if (!task)
> +		return -ESRCH;
> +
> +	ret = 0;
> +	mm = get_task_mm(task);
> +	if (mm) {
> +		unsigned long flags = __mm_flags_get_dumpable(mm);
> +
> +		len = snprintf(buffer, sizeof(buffer), "%08lx\n",
> +			       ((flags & MMF_DUMP_PRE_EXIT_MASK) >>
> +				MMF_DUMP_PRE_EXIT_SHIFT));
> +		mmput(mm);
> +		ret = simple_read_from_buffer(buf, count, ppos, buffer, len);
> +	}
> +
> +	put_task_struct(task);
> +
> +	return ret;
> +}
> +
> +static ssize_t proc_coredump_pre_exit_write(struct file *file,
> +					    const char __user *buf,
> +					    size_t count,
> +					    loff_t *ppos)
> +{
> +	struct task_struct *task;
> +	struct mm_struct *mm;
> +	unsigned int val;
> +	int ret;
> +	int i;
> +	unsigned long mask;
> +
> +	ret = kstrtouint_from_user(buf, count, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = -ESRCH;
> +	task = get_proc_task(file_inode(file));
> +	if (!task)
> +		goto out_no_task;
> +
> +	mm = get_task_mm(task);
> +	if (!mm)
> +		goto out_no_mm;
> +	ret = 0;
> +
> +	for (i = 0, mask = 1; i < MMF_DUMP_PRE_EXIT_BITS; i++, mask <<= 1) {
> +		if (val & mask)
> +			mm_flags_set(i + MMF_DUMP_PRE_EXIT_SHIFT, mm);
> +		else
> +			mm_flags_clear(i + MMF_DUMP_PRE_EXIT_SHIFT, mm);
> +	}
> +
> +	mmput(mm);
> + out_no_mm:
> +	put_task_struct(task);
> + out_no_task:
> +	if (ret < 0)
> +		return ret;
> +	return count;
> +}
> +
> +static const struct file_operations proc_coredump_pre_exit_operations = {
> +	.read		= proc_coredump_pre_exit_read,
> +	.write		= proc_coredump_pre_exit_write,
> +	.llseek		= generic_file_llseek,
> +};
>  #endif
>  
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> @@ -3391,6 +3468,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #endif
>  #ifdef CONFIG_ELF_CORE
>  	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
> +	REG("coredump_pre_exit", S_IRUGO|S_IWUSR, proc_coredump_pre_exit_operations),
>  #endif
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
>  	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index af23453e9dbd..dfd4717c7e3e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4066,6 +4066,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
>  extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
>  extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
>  extern void exit_mmap(struct mm_struct *);
> +extern void exit_mmap_mapped_shared(struct mm_struct *mm);
>  bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
>  				 unsigned long addr, bool write);
>  
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index c7db35be6a30..0555aaf50001 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1963,6 +1963,15 @@ enum {
>  	(BIT(MMF_DUMP_ANON_PRIVATE) | BIT(MMF_DUMP_ANON_SHARED) | \
>  	 BIT(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
>  
> +/* coredump pre-exit bits */
> +#define MMF_DUMP_PRE_EXIT_FLOCK	11
> +#define MMF_DUMP_PRE_EXIT_FILE_BACKED_SHARED 12
> +
> +#define MMF_DUMP_PRE_EXIT_SHIFT	(MMF_DUMPABLE_BITS + MMF_DUMP_FILTER_BITS)
> +#define MMF_DUMP_PRE_EXIT_BITS	2
> +#define MMF_DUMP_PRE_EXIT_MASK	\
> +	(((1 << MMF_DUMP_PRE_EXIT_BITS) - 1) << MMF_DUMP_PRE_EXIT_SHIFT)
> +
>  #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
>  # define MMF_DUMP_MASK_DEFAULT_ELF	BIT(MMF_DUMP_ELF_HEADERS)
>  #else
> diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
> index 41ed884cffc9..b4becbf6c0eb 100644
> --- a/include/linux/sched/task.h
> +++ b/include/linux/sched/task.h
> @@ -93,6 +93,7 @@ static inline void exit_thread(struct task_struct *tsk)
>  extern __noreturn void do_group_exit(int);
>  
>  extern void exit_files(struct task_struct *);
> +extern void exit_files_pre_exit(struct task_struct *, bool);
>  extern void exit_itimers(struct task_struct *);
>  
>  extern pid_t kernel_clone(struct kernel_clone_args *kargs);
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> index 613475285643..360604d653b4 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -95,6 +95,10 @@
>  #define O_NDELAY	O_NONBLOCK
>  #endif
>  
> +#ifndef O_TMPCLOS
> +#define O_TMPCLOS	0x80000000	/* tag need close, temporarily used */
> +#endif

Sorry, not going to happen. This doesn't not justify the addition of a
new uapi value at all.

I'm also including various Sashkio comments:

sashiko.dev <sashiko@sashiko.dev>:

[Severity: Medium]
Is it safe to expose an internal, temporary kernel flag in a UAPI header?
Userspace applications could intentionally or accidentally pass O_TMPCLOS to
open(), which might permanently pollute the userspace ABI and trigger
unexpected behavior during a coredump.

via: https://sashiko.dev/#/message/20260624145552.70143-1-jackzxcui1989@163.com

> +
>  #define F_DUPFD		0	/* dup */
>  #define F_GETFD		1	/* get close_on_exec */
>  #define F_SETFD		2	/* set/clear close_on_exec */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a679b2448234..84f1ee7f32cf 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1030,6 +1030,18 @@ static int __init coredump_filter_setup(char *s)
>  
>  __setup("coredump_filter=", coredump_filter_setup);
>  
> +static unsigned long default_dump_pre_exit;
> +
> +static int __init coredump_pre_exit_setup(char *s)
> +{
> +	default_dump_pre_exit =
> +		(simple_strtoul(s, NULL, 0) << MMF_DUMP_PRE_EXIT_SHIFT) &
> +		MMF_DUMP_PRE_EXIT_MASK;
> +	return 1;
> +}
> +
> +__setup("coredump_pre_exit=", coredump_pre_exit_setup);

This makes no sense. I think you really need to sit down and think about
a design for this that doesn't introduce state machinery for boot, mm,
and the VFS in one shot to solve a fringe problem...





sashiko.dev <sashiko@sashiko.dev>:

[Severity: High]
Does modifying the VMA maple tree via do_munmap() during the for_each_vma()
iteration invalidate the outer iterator? The loop traverses the maple tree
using the iterator vmi. However, do_munmap() creates its own internal
VMA_ITERATOR and removes the VMA from the tree. Because the outer vmi
iterator is not updated to reflect these structural changes, its cached
state becomes stale, which can lead to a use-after-free when vma_next()
is subsequently called.

via: https://sashiko.dev/#/message/20260624145552.70143-1-jackzxcui1989@163.com


sashiko.dev <sashiko@sashiko.dev>:

[Severity: High]
Is it safe to iterate the file descriptor table without holding
rcu_read_lock()? Because coredump_pre_exit() is called before zap_threads()
kills other threads, concurrent threads can still trigger expand_files(),
which replaces the fdt and frees the old one after an RCU grace period.

via: https://sashiko.dev/#/message/20260624145552.70143-1-jackzxcui1989@163.com


sashiko.dev <sashiko@sashiko.dev>:

[Severity: Medium]
Similar to the issue in exit_mmap_mapped_shared(), this non-atomic update
of file->f_flags risks losing concurrent fcntl() updates since it doesn't
hold file->f_lock.

Also, if a file has duplicated file descriptors (e.g., via dup()), will
clearing O_TMPCLOS here prematurely skip the closure of the remaining
descriptors? When encountering the duplicated descriptor later, the flag
will already be cleared, leaving the shared file actively referenced.

via: https://sashiko.dev/#/message/20260624145552.70143-1-jackzxcui1989@163.com

-- 
Christian Brauner <brauner@kernel.org>

