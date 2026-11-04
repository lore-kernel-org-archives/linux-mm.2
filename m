Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14E3606D812
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T7dIWjzH
Received: by kanga.kvack.org (Postfix)
	id 065F76B05B5; Wed,  4 Nov 2026 11:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017BE6B05B7; Wed,  4 Nov 2026 11:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47B46B05B8; Wed,  4 Nov 2026 11:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38C46B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:28:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3391F407BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:28:04 +0000 (UTC)
X-FDA: 85397968488.08.A1329CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D73114000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:28:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7dIWjzH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793809682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2o1xSWH41eRGioUp99pWM6BOJpN9/lkZ30jd8REpeEk=;
	b=KmkJ2LJzLJ5Q2QGoq1twL12JXUF+CP4od4hgCETFjZ8tIhdZpfzwiMnQPIfOm6HY4QZbPi
	ZzO/uOo9V0tZYsnR3sSOBXCLvDKk2y1hZM76xhNmdxuAj5MH2i8aIsx6NyNMZblhRHlxfA
	Lu7iS5mlouYZHkSWgeUkgYLjR5wsX+Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T7dIWjzH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793809682;
	b=nVcOiAN9APDRw7YjwX7dhH2+uyIzlc02zecfwbNAvFhbH3YOIwtr2nttHME9wYswWKXlbE
	HrRV0ze+iaFmcsnAx2X74/tXqoYK0/lPtZoXdxltRh3zgyM400ljRRLT6sHy/0Kfq8QtM/
	B50a3ToFnOGox5hkzctDqnxwG68KmzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 771936021C;
	Wed,  4 Nov 2026 16:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396D21F00A16;
	Wed,  4 Nov 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793809681;
	bh=2o1xSWH41eRGioUp99pWM6BOJpN9/lkZ30jd8REpeEk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=T7dIWjzH420vabRCZt1hlsRWgbeewd+9+Zbxi2QElCIebeMvXiL+RukQgvn6kStuP
	 LVm2xPS7K+eINJa576BgWUeOCfSSpw70cewlGicwh6SF7fMEtQXZXj5DHHTelNQZxJ
	 8+502haEgKz9tDZiV4+LeB0ddsAGm2DsTkp2iocFtTlF7r0rMRiOD6htW3iGAaN6sb
	 12lYdJ7Uqcaeh9iEdtjG6XMsDFhOCAWxLRDrJ/9JCs3FcpJTC8KGB3yYbvGX43ZdCD
	 ADNhwslgMFkMmbq5twfKZKyruo1N+cUkekNOeKu9jBno8KLxi9Dn0aCzqh0o/Uxpb6
	 22UqBwos+w+qA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 07/10] mm/shmem_luo: Retrieve tmpfs files onto a
 tmpfs mount chosen by userspace
In-Reply-To: <20261103010216.3447716-8-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:13 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-8-dmatlack@google.com>
Date: Wed, 04 Nov 2026 17:27:55 +0100
Message-ID: <2vxzecd0k1dg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D73114000D
X-Stat-Signature: mef6a6h4gppwz9i59iu1ra56etmbfpyp
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793809682-7251
X-HE-Meta: U2FsdGVkX1+opNXEYtHtH7l4GmF1Qm+2RfTbG/O2e4Cv6naJdDzF3aT+LTNppNrcBVxhL+JO3LKszxHJFXzkTd/VEANBuEwNfiavx56NW2ygwe/tjY5tYspYiLXx5RXs8mBpqapXiW3rZ5vSrcbxzBPKBGXoxefYDx6h7cnDgP24DCXRkX0NaOGc+U5v3CIT8YzJ1KG1hcx5RUwuRzAqcG+5jvStPZa+biRG0Kk8VJ9SDHM54rxw/v8zlfF3WdTzzaXz5DUcSx7fYF1N8PtcWyi32EnLKzwBaeB6olaGeaNK6saNARac7LJq0EHie1cFATfuQlb4GMdjy5Yhf+2XSairtJZXFZ7oONIkbsi5ckG2xntjoY2d4JM7EBP+5/ahea1J+6PuWpH2frxkhL9qpe2kfyN2zGjAGWcr6ZXnnewX7DCv+qEebwT5eJPD8zy09IAtanCEo1ubRwvtuE0XdQONrn8b4x7wJ/NK3+x9N5CyoAGRnsoJigXKPZtcW0lLnFVmfzNasGhCF4vZVsSfYQf/SO9Gv8vsXi8xCKMIpU2TkdMmudGqIBUJ8/E3MQlMKPZv7xb1vblMYDd/Q6v8QyoFasJXuUC16BvnKprE/4x9eSIJTaAB3IDeF17vjLngCOABD2arSkI8gCzoSiCevYVegtMI8fCLnhxvxkH46RVbouhlTFAWZbQktzm+g0IyZLn75lQm7QoTsJu7hunNnsCAvcgTsbB+6xwgaDa3Fv0Su/JOhdPLd0bbWKdQhYPzKWZ5JdryKc6n52Ku7wkltG5Igo360lDdrL4QC58bUtsrthsegU867t2U+25ihQhL3K2UbrRgTN86C5X6A+0H/SCsPI9z+aqDLvyjSHwE23+W3FqykE6m5FkIZLID6MX3FBWtSDx8aLb4gvWJoDjrX1BU9BcaEhCm+EJ7pxZxvHut+NREklcx9z7NQEY6M+vM0uJt/A1LQOlxfFFkhGC
 ugACY6Wj
 I7+bm3TmLQk0fVP7jtPrFkQYKj/y0tpquYwVWu4+TzpDrCFp2CuQXIA1NOPXtRSEnZINJQPIRoxZEelIA/YFRId+Tv3zC2RHFmMXCQMUtLUFEuFNXHCsoHzG4brw9JW6uZtWHvdYi7aMzg3jT41ybU8Ho43a0VB5ObnErLFPCIyggDxu004rdIzDAGS9zytTpfyT16Qw0HRMTv42UnVMD+LwTbxoC+e66m+QEW33ie1j4phIHUBRHJuIFOccVzp0ornlvF01m8VAun06zmYamFFxtRgBZDpO9weuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Tue, Nov 03 2026, David Matlack wrote:

> Retrieve files that were preserved from a tmpfs mount onto a tmpfs mount
> chosen by userspace, instead of as memfds on the internal tmpfs mount.
> Add struct liveupdate_shmem_retrieve_arg, which userspace passes as the
> retrieve argument of LIVEUPDATE_SESSION_RETRIEVE_FD to choose the mount.
> Record which mount a file was on with a new SHMEM_LUO_FLAG_TMPFS flag in
> struct shmem_luo_ser, based on the superblock of the file.
>
> shmem_luo already accepts unlinked tmpfs files, such as files created
> with O_TMPFILE, and a following commit also accepts linked ones. The

Nit: that's a bug, not a supported feature (well, before this patch at
least).

> mount such a file was on doesn't exist in the new kernel, and userspace
> may want to put the file elsewhere anyway.
>
> Model struct liveupdate_shmem_retrieve_arg on open(): The kernel creates
> a new file as if by openat(dirfd, ".", O_TMPFILE | flags, mode), so the
> file gets the owner, permission checks and security labels of any new
> file in that directory, and is charged to that mount. The kernel then
> fills the file with the preserved contents, size, position and seals
> before returning it, so nothing else can access the file before it is
> complete. Userspace links the file at the path it wants with linkat(),
> or passes O_EXCL to keep it unlinked. Neither the path nor any other
> inode attribute of the file is part of the preserved state, which keeps
> them out of the KHO ABI.
>
> Pass the flags from userspace to file_open_root(), so that the VFS
> checks them like for open(). file_open_root() silently ignores unknown
> flags and mode bits, so reject those like openat2() does. Also reject
> O_PATH, with which file_open_root() would ignore O_TMPFILE and open the
> directory.
>
> Keep the type of the file: memfds can only be retrieved as memfds, and
> files on tmpfs mounts only onto tmpfs mounts, so that e.g. a file
> can't be moved off the mount whose size limit and quotas it was subject

Nit: that's not true. It only can't be moved to the internal mount. All
other tmpfs mounts are fair game. You can take 5 files from a single
mount on preserve, and put them on 5 different mounts on retrieve.
Nothing wrong with that, just that this claim isn't exactly accurate.

> to. Passing the argument when retrieving a memfd, or not passing it when
> retrieving a file from a tmpfs mount, fails with -EINVAL. Unlinked tmpfs
> files were retrieved as memfds until now, but nothing relies on that, as
> the LUO uAPI is not stable yet.

LUO uAPI _is_ stable. We have to keep backwards compatibility. It is
only the preservation ABI that is not stable.

And as I said above, that was a bug and not a supported feature. This
patch happens to fix that bug, and hopefully no user was relying on it.
If a user is relying on it, we'd either have to ask them to move to the
new uAPI or reinstate the old bug (as long as the end result is
reasonable and secure). That's the promise we have to keep with uAPI.

>
> Like the other failures before the folios are restored, problems with
> the argument and with creating the file can be retried.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  Documentation/mm/shmem_preservation.rst |   8 +-
>  include/linux/kho/abi/shmem.h           |  21 ++-
>  include/uapi/linux/liveupdate.h         |  35 +++++
>  kernel/liveupdate/Kconfig               |   6 +-
>  mm/internal.h                           |   1 +
>  mm/shmem.c                              |   9 ++
>  mm/shmem_luo.c                          | 180 ++++++++++++++++++++----
>  7 files changed, 221 insertions(+), 39 deletions(-)
>
> diff --git a/Documentation/mm/shmem_preservation.rst b/Documentation/mm/shmem_preservation.rst
> index e79bf8afaa9e..030a8f18680c 100644
> --- a/Documentation/mm/shmem_preservation.rst
> +++ b/Documentation/mm/shmem_preservation.rst
> @@ -1,11 +1,11 @@
>  .. SPDX-License-Identifier: GPL-2.0-or-later
>  
> -==========================
> -Memfd Preservation via LUO
> -==========================
> +====================================
> +Memfd and Tmpfs Preservation via LUO
> +====================================
>  
>  .. kernel-doc:: mm/shmem_luo.c
> -   :doc: Memfd Preservation via LUO
> +   :doc: Memfd and Tmpfs Preservation via LUO
>  
>  Memfd Preservation ABI
>  ======================
> diff --git a/include/linux/kho/abi/shmem.h b/include/linux/kho/abi/shmem.h
> index b61687e358a2..88ef7d49b5f3 100644
> --- a/include/linux/kho/abi/shmem.h
> +++ b/include/linux/kho/abi/shmem.h
> @@ -18,8 +18,8 @@
>   * DOC: shmem Live Update ABI
>   *
>   * The shmem file handler, which preserves memfds created without
> - * ``MFD_HUGETLB``, uses the ABI defined below for preserving their state across
> - * a kexec reboot using the LUO.
> + * ``MFD_HUGETLB`` and tmpfs files, uses the ABI defined below for preserving
> + * their state across a kexec reboot using the LUO.
>   *
>   * The state is serialized into a packed structure `struct shmem_luo_ser`
>   * which is handed over to the next kernel via the KHO mechanism.
> @@ -69,12 +69,25 @@ struct shmem_luo_folio_ser {
>  			     F_SEAL_EXEC)
>  
>  /**
> - * struct shmem_luo_ser - Main serialization structure for a memfd.
> + * SHMEM_LUO_FLAG_TMPFS - The file was on a tmpfs mount.
> + *
> + * Set for files that were not on the internal shmem mount that memfds are
> + * created on. Such a file is retrieved onto a tmpfs mount chosen by userspace,
> + * instead of as a memfd.
> + */

Nit: perhaps the below is slightly better?

    Set for files on a user-visible tmpfs mount. Such files can only be
    retrieved into a tmpfs mount, and never as a memfd.

> +#define SHMEM_LUO_FLAG_TMPFS		BIT(0)
> +
> +/* The set of flags this version supports. */
> +#define SHMEM_LUO_ALL_FLAGS		SHMEM_LUO_FLAG_TMPFS
> +
> +/**
> + * struct shmem_luo_ser - Main serialization structure for a memfd or tmpfs file.
>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
>   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
>   *             to directly use them in the ABI.
> - * @flags:     Flags for the file. Unused flag bits must be set to 0.
> + * @flags:     Flags for the file (SHMEM_LUO_FLAG_*). Unused flag bits must be
> + *             set to 0.
>   * @nr_folios: Number of folios in the folios array.
>   * @folios:    KHO vmalloc descriptor pointing to the array of
>   *             struct shmem_luo_folio_ser.
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 953ffe0823be..a9dcc4fcc87b 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -247,4 +247,39 @@ struct liveupdate_session_get_name {
>  #define LIVEUPDATE_SESSION_GET_NAME					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
>  
> +/**
> + * struct liveupdate_shmem_retrieve_arg - Argument to retrieve a tmpfs file
> + * @size:  Input; sizeof(struct liveupdate_shmem_retrieve_arg)
> + * @dirfd: Input; A file descriptor for a directory on the tmpfs mount to create
> + *         the file on.
> + * @flags: Input; The flags of the file, like the flags argument of open(),
> + *         except for O_TMPFILE, which is implied, and O_PATH, which is not
> + *         allowed.
> + * @mode:  Input; The mode of the file, like the mode argument of open().
> + *
> + * Passed via &struct liveupdate_session_retrieve_fd.arg to retrieve a file that
> + * was preserved from a tmpfs mount. Such files can only be retrieved with this
> + * argument, and memfds, i.e. files that were preserved from the kernel's
> + * internal shmem mount, can only be retrieved without it. Otherwise, the

Nit: "internal shmem mount" is a kernel internal detail, no point of it
in user facing documentation.

> + * retrieve fails with -EINVAL.
> + *
> + * The kernel creates a new file as if by openat(@dirfd, ".", O_TMPFILE |
> + * @flags, @mode), fills it with the preserved contents, and returns it in
> + * &struct liveupdate_session_retrieve_fd.fd. Like any O_TMPFILE file, the file
> + * is not linked into the filesystem. Userspace can link it with linkat(),
> + * unless @flags contains O_EXCL.
> + *
> + * If @flags contains unknown flags or O_PATH, if @mode contains unknown mode
> + * bits, or if @dirfd is not on a tmpfs mount, the retrieve fails with -EINVAL.
> + * If the file can't be created, the retrieve fails with the same errors as
> + * open(). A retrieve that fails before the preserved contents are restored can
> + * be retried.

How is userspace supposed to tell if preserved contents were restored?

> + */
> +struct liveupdate_shmem_retrieve_arg {
> +	__u32		size;
> +	__s32		dirfd;
> +	__aligned_u64	flags;
> +	__aligned_u64	mode;
> +};
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 9a1c49e2e0c4..61d01f5a336e 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -70,14 +70,14 @@ config LIVEUPDATE
>  	  If unsure, say N.
>  
>  config LIVEUPDATE_SHMEM
> -	bool "Live update support for memfd"
> +	bool "Live update support for memfd and tmpfs files"
>  	depends on LIVEUPDATE
>  	depends on MEMFD_CREATE
>  	depends on SHMEM
>  	default LIVEUPDATE
>  	help
> -	  Enable live update support for memfd regions. This allows preserving
> -	  memfd-backed memory across kernel live updates.
> +	  Enable live update support for memfds and tmpfs files. This allows
> +	  preserving their contents across kernel live updates.
>  
>  	  This can be used to back VM memory with memfds, allowing the guest
>  	  memory to persist, or for other user workloads needing to preserve
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..630ae0297dd5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1436,6 +1436,7 @@ int shmem_add_to_page_cache(struct folio *folio,
>  			    pgoff_t index, void *expected, gfp_t gfp);
>  int shmem_inode_acct_blocks(struct inode *inode, long pages);
>  bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
> +bool shmem_inode_on_internal_mount(const struct inode *inode);
>  
>  #ifdef CONFIG_SHRINKER_DEBUG
>  static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 897fa2b61346..9c67daa35d66 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -468,6 +468,15 @@ bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
>  	return first_swapped;
>  }
>  
> +/*
> + * Whether @inode is on the internal shmem mount, which is used by
> + * shmem_file_setup() and thus by memfd_create().
> + */
> +bool shmem_inode_on_internal_mount(const struct inode *inode)
> +{
> +	return inode->i_sb == shm_mnt->mnt_sb;
> +}
> +
>  bool shmem_charge(struct inode *inode, long pages)
>  {
>  	struct address_space *mapping = inode->i_mapping;
> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index bcac1bbb3db3..ecbeb37d33a8 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
> @@ -9,19 +9,20 @@
>   */
>  
>  /**
> - * DOC: Memfd Preservation via LUO
> + * DOC: Memfd and Tmpfs Preservation via LUO
>   *
>   * Overview
>   * ========
>   *
> - * Memory file descriptors (memfd) can be preserved over a kexec using the Live
> - * Update Orchestrator (LUO) file preservation. This allows userspace to
> - * transfer its memory contents to the next kernel after a kexec.
> + * Memory file descriptors (memfd) and tmpfs files can be preserved over a kexec
> + * using the Live Update Orchestrator (LUO) file preservation. This allows
> + * userspace to transfer its memory contents to the next kernel after a kexec.
>   *
>   * Here, a memfd is a memfd created without ``MFD_HUGETLB``, which is a shmem
> - * file on the kernel's internal shmem mount. Memfds created with
> - * ``MFD_HUGETLB`` are hugetlbfs files, which this file handler doesn't
> - * preserve. Preserving them fails with ``-ENOENT``.
> + * file on the kernel's internal shmem mount, and a tmpfs file is a file on any
> + * other tmpfs mount. Memfds created with ``MFD_HUGETLB`` and other files on
> + * hugetlbfs are not shmem files, and this file handler doesn't preserve them.
> + * Preserving them fails with ``-ENOENT``.
>   *
>   * The preservation is not intended to be transparent. Only select properties of
>   * the file are preserved. All others are reset to default. The preserved
> @@ -29,12 +30,13 @@
>   *
>   * .. note::
>   *    The LUO API is not stabilized yet, so the preserved properties of a memfd
> - *    are also not stable and are subject to backwards incompatible changes.
> + *    or tmpfs file are also not stable and are subject to backwards
> + *    incompatible changes.
>   *
>   * Preserved Properties
>   * ====================
>   *
> - * The following properties of the memfd are preserved across kexec:
> + * The following properties of the file are preserved across kexec:
>   *
>   * File Contents
>   *   All data stored in the file is preserved.
> @@ -49,10 +51,12 @@
>   *
>   * File Status Flags
>   *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
> - *   is maintained.
> + *   is maintained. The file status flags of tmpfs files are not preserved.
> + *   Userspace chooses the flags when retrieving them, as described in
> + *   "Retrieving Tmpfs Files" below.
>   *
>   * Seals
> - *   File seals set on the memfd are preserved and re-applied on restore.
> + *   The seals of the file are preserved and re-applied on restore.
>   *   Only seals known to this LUO version (see ``SHMEM_LUO_ALL_SEALS``) may
>   *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
>   *
> @@ -67,12 +71,50 @@
>   *   A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
>   *   ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set
>   *   again after restore via ``fcntl()``.
> + *
> + * Inode Attributes
> + *   The name, path, owner, mode, timestamps and extended attributes of the
> + *   file are not preserved.
> + *
> + * Retrieving Tmpfs Files
> + * ======================
> + *
> + * A tmpfs file can be retrieved onto any tmpfs mount that userspace chooses.
> + * The mount that the file was on doesn't exist in the new kernel, and userspace
> + * may want to put the file elsewhere anyway.
> + *
> + * To retrieve a tmpfs file, userspace passes a
> + * ``struct liveupdate_shmem_retrieve_arg`` to
> + * ``LIVEUPDATE_SESSION_RETRIEVE_FD``. The argument specifies a directory on the
> + * target mount, and the flags and mode of the new file. The kernel creates the
> + * file as if by ``openat(dirfd, ".", O_TMPFILE | flags, mode)``, so the file
> + * gets the same flags, owner, permission checks and security labels as any
> + * other new file in that directory. The kernel then fills the file with the
> + * preserved contents, size, position and seals before it returns the file, so
> + * nothing else can access the file before it is complete.
> + *
> + * Like any ``O_TMPFILE`` file, the new file is not linked into the filesystem.
> + * Userspace can link it at the path it wants with ``linkat()``, unless it asked
> + * for ``O_EXCL``. Like with ``open()``, the file must be opened for writing.
> + * LUO keeps the file open until the session is finished, so a retrieved binary
> + * can't be executed until then.

Nit: this information seems to be repeated in the uAPI documentation.
Perhaps keep it only there and refer to it from here?

> + *
> + * The blocks of the file are charged to the target mount, so the size limit
> + * and quotas of the mount apply. If the file doesn't fit, the retrieve fails
> + * permanently, since the preserved contents have already been restored at that
> + * point. If the argument is invalid or the file can't be created, the retrieve
> + * fails before the preserved contents are restored, so it can be retried.
> + *
> + * memfds can only be retrieved as memfds, and files on tmpfs mounts can only be
> + * retrieved onto tmpfs mounts. Retrieving a memfd with the argument, or a tmpfs
> + * file without it, fails with ``-EINVAL``.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/bits.h>
>  #include <linux/err.h>
> +#include <linux/fcntl.h>
>  #include <linux/file.h>
>  #include <linux/io.h>
>  #include <linux/kexec_handover.h>
> @@ -81,6 +123,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memfd.h>
> +#include <uapi/linux/magic.h>
>  #include <uapi/linux/memfd.h>
>  
>  #include "internal.h"
> @@ -299,6 +342,8 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
>  
>  	ser->size = inode_size;
>  	ser->seals = seals;
> +	if (!shmem_inode_on_internal_mount(inode))
> +		ser->flags |= SHMEM_LUO_FLAG_TMPFS;
>  
>  	err = shmem_luo_preserve_folios(args->file, &ser->folios,
>  					&folios_ser, &nr_folios);
> @@ -515,6 +560,92 @@ static int shmem_luo_retrieve_folios(struct file *file,
>  	return err;
>  }
>  
> +/* Create the memfd to retrieve a file from the internal shmem mount into. */
> +static struct file *shmem_luo_create_memfd(const struct liveupdate_shmem_retrieve_arg *arg,
> +					   unsigned int seals)
> +{
> +	struct file *file;
> +	int err;
> +
> +	/* memfds are retrieved as memfds, so there is nothing to choose. */

Nit: I can't make any sense of this comment. "memfds are retrieved as
memfds": well I'd hope so. "there is nothing to choose": ... what are we
choosing?

Perhaps something simpler like "no arguments needed with memfds".
Something along these lines.

> +	if (arg)
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * The seals are preserved. Allow sealing here so they can be added
> +	 * later.
> +	 */
> +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
> +	if (IS_ERR(file)) {
> +		pr_err("failed to setup file: %pe\n", file);
> +		return file;
> +	}
> +
> +	err = memfd_add_seals(file, seals);
> +	if (err) {
> +		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
> +		fput(file);
> +		return ERR_PTR(err);
> +	}
> +
> +	return file;
> +}
> +
> +/*
> + * Create the file to retrieve a file from a tmpfs mount into, on the tmpfs
> + * mount chosen by userspace.
> + */
> +static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_shmem_retrieve_arg *arg,
> +						unsigned int seals)
> +{
> +	struct file *file;
> +	int err;
> +
> +	if (!arg)
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * Like openat2(), reject unknown flags and mode bits instead of
> +	 * ignoring them. Also reject O_PATH, which would make file_open_root()
> +	 * ignore O_TMPFILE and open the directory instead of creating a file.
> +	 */
> +	if (arg->flags & ~(u64)VALID_OPEN_FLAGS || arg->flags & O_PATH ||
> +	    arg->mode & ~(u64)S_IALLUGO)
> +		return ERR_PTR(-EINVAL);
> +
> +	CLASS(fd_raw, dir)(arg->dirfd);
> +	if (fd_empty(dir))
> +		return ERR_PTR(-EBADF);
> +
> +	if (fd_file(dir)->f_path.dentry->d_sb->s_magic != TMPFS_MAGIC)
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * Create the file like open(O_TMPFILE) does, so that it gets the same
> +	 * flag checks, permission checks, owner and security labels.
> +	 */
> +	file = file_open_root(&fd_file(dir)->f_path, ".",
> +			      O_TMPFILE | O_LARGEFILE | arg->flags, arg->mode);
> +	if (IS_ERR(file))
> +		return file;
> +
> +	/*
> +	 * Nothing else can access the new file yet, so set the preserved seals
> +	 * directly. memfd_add_seals() refuses to, since files on tmpfs mounts
> +	 * are created with F_SEAL_SEAL.
> +	 */
> +	if (seals & F_SEAL_WRITE) {
> +		err = mapping_deny_writable(file->f_mapping);
> +		if (err) {
> +			fput(file);
> +			return ERR_PTR(err);
> +		}
> +	}
> +	SHMEM_I(file_inode(file))->seals = seals;

No, no, no. If a tmpfs payload has seals other than F_SEAL_SEAL, it is
_invalid_ and must be rejected. Let's not do things on retrieve that
can't be done on a normal file.

> +
> +	return file;
> +}
> +
>  static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  {
>  	struct shmem_luo_folio_ser *folios_ser;
> @@ -533,25 +664,18 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  	 */
>  	args->retryable = true;
>  
> -	/* Make sure the file only has seals supported by this version. */
> -	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
> +	/* Make sure the file only has seals and flags this version supports. */
> +	if ((ser->seals & ~SHMEM_LUO_ALL_SEALS) ||
> +	    (ser->flags & ~SHMEM_LUO_ALL_FLAGS))

As I said above, the set of valid seals depends on memfd or tmpfs, so it
should be checked in their respective functions.

This also isn't backwards compatible, but we haven't solved that problem
yet so it's fine for now.

>  		return -EOPNOTSUPP;
>  
> -	/*
> -	 * The seals are preserved. Allow sealing here so they can be added
> -	 * later.
> -	 */
> -	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
> -	if (IS_ERR(file)) {
> -		pr_err("failed to setup file: %pe\n", file);
> +	/* Retrieve memfds as memfds, and other files onto a tmpfs mount. */

Nit: this comment doesn't add any value.

> +	if (ser->flags & SHMEM_LUO_FLAG_TMPFS)
> +		file = shmem_luo_create_tmpfs_file(args->arg, ser->seals);
> +	else
> +		file = shmem_luo_create_memfd(args->arg, ser->seals);
> +	if (IS_ERR(file))
>  		return PTR_ERR(file);
> -	}
> -
> -	err = memfd_add_seals(file, ser->seals);
> -	if (err) {
> -		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
> -		goto put_file;
> -	}
>  
>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
>  	i_size_write(file_inode(file), ser->size);
> @@ -579,7 +703,6 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  
>  free_ser:
>  	kho_restore_free(ser);
> -put_file:
>  	fput(file);
>  	return err;
>  }
> @@ -605,6 +728,7 @@ static const struct liveupdate_file_ops shmem_luo_file_ops = {
>  	.unpreserve = shmem_luo_unpreserve,
>  	.can_preserve = shmem_luo_can_preserve,
>  	.get_id = shmem_luo_get_id,
> +	.rarg = LIVEUPDATE_ARG(struct liveupdate_shmem_retrieve_arg, mode),
>  	.owner = THIS_MODULE,
>  };

-- 
Regards,
Pratyush Yadav

