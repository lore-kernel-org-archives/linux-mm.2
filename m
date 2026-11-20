Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B4A606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RDg9vl3D
Received: by kanga.kvack.org (Postfix)
	id 69A856B05B3; Fri, 20 Nov 2026 08:52:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673446B05B4; Fri, 20 Nov 2026 08:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE726B05BD; Fri, 20 Nov 2026 08:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3205F6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:52:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0096A0F13
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:51:59 +0000 (UTC)
X-FDA: 85455635958.18.BE9C5BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1218318000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:51:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RDg9vl3D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182718;
	b=yk4cCZrXpU4pJHVGHdLrLXiPAo1hw3NwP4zfnVQixAuPHmZIuD8/I6keyDUQRGFlOCbOb7
	sDWnsRSSnFMKbuSJtQzjbBwa66oQSb4KqrmwsyHgC9LbPffAOEPyjwKvb0pif3IuBrRDGz
	vOp26IiUhOyKUx1R57ZKd89blXi5jZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhtzTxT7Xmxzpq9ra1ZfnNJHdc7bWI31MU+RT/7wItY=;
	b=tjc1pSMn/IXeWCBbeHDRyBgbanAeJG2nveuVUst85qDHOecSCWWKukuIUqb1Bq+W3p3auT
	0qX1IDkcqm5JbhZExgks1q53sQKOZ5q1HqbYJd691hlXE4tgAzyXvyX7VgHFcKuKoe6Qhs
	JUJ+BbYmQn5TgmovhDp599hBTkOFikc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RDg9vl3D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9762A4436C;
	Fri, 20 Nov 2026 13:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA871F000C6;
	Fri, 20 Nov 2026 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182716;
	bh=HhtzTxT7Xmxzpq9ra1ZfnNJHdc7bWI31MU+RT/7wItY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RDg9vl3Dhj7ib++zLccr4Z8NcH2Mh0BTDHYXvQ3RBjIBNr+/Cm7k72IMJBIpoLISg
	 zJgGt+jxnnif1sgb7ZvoUMfsyqSp0NW5tBDkpZIXz4alSBrRxfOqmgMdSSEJizmvup
	 OGmb6tvG7GKtoq8rDAyueMu1pSRViSwVNM/ujo/+3WdWF/qifOxUbW+Iag9N3kuFfO
	 xFcw6J2l7/DoZzaPPirTlinjd1hmwAUbKLUXO0Br5ZfL489RDi9mrvek9JsvEHu4eo
	 dKEKMVs9G8Coyh1xwG4z54t/Dnn3ZK5dvkReV0+nIBJl1eoHdwh8zOM61yENULGOfE
	 ZZ7U5LMp6AHLQ==
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
Subject: Re: [PATCH v4 12/19] mm/shmem_luo: Retrieve tmpfs files into a file
 created by userspace
In-Reply-To: <20261111002358.1842967-13-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:50 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-13-dmatlack@google.com>
Date: Fri, 20 Nov 2026 13:51:50 +0000
Message-ID: <2vxzpkvz1uh5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1218318000A
X-Stat-Signature: uz873iugea9cira4tgbkokzbbzsfnf77
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795182717-536717
X-HE-Meta: U2FsdGVkX1/Q/OK5DLV6uql7C0yG6aSmN5yBvEqCsMGpcqy7q899P8VCmkL08TkE++RSFgjxz8EHWRHzxEDd7ccVduRYpm9wgZk6TcaZrikuLF9PfdvM+R03yH5+lvimR0Xw+++fJE8qUQr8fyIZND3vx8yiYc8PsjaT9zgrwOzzujHRY6US4YwOrahCkS0AwixfPV+VmX3BshpdmR2fUUjHakhPCGL/pYlC/aSHFEfUxjS91HVbVAp+7FzMNtLFQYPvyaZGxdsbQMHI0WuWusuhJh4KrXcQ8Ysz6lIOlAg010ULhRZ1GA7HHC0xwaS38HG8Qc3enK5/GBIh6IVAY59MoaOKs1XxD5mYcfZsWm+0Qt1WuMkMiQ4vFEYLFopNpjPnThSu9tPTMWTTt8pB+WoPKUmnyLFyi1EB4OCZsiAFD/4oEvzgNWjmD9XZ+3nVwEfVwpzaey4IsICUHQNuMeU7OYnApvllAWFCLXcVAt7axMPHJkxfHHVkSSA5FPEs6c65wXMPRlRnnt+6QrkfYTfz7nI9ule26a8p7K18U33q2uqb0eV+1SwVHx3rcApB88QMKl52T6j0mWidRkLEyIhu3sp+w1QHNNgecRlbbnzTeGNk1UAmqBxYwYdccrMK76BcqOIXOweYKaRqwJL2UHOhWHATm90g7/YlEe+pIUS7l8AM/+eTc5lVECKrHQs0EmDvVnUJCBHEU/u4s458n4lLMUEHP/p4CQgldx5kgUcN1UnhVFuQItNtqqMgYjpivCLcfq/+lNqzjW9b0z/k/iuojPtGL1QNjpKb55bIVNJYostrsnCo8CzirmF4raZytmzvUHS1sG5wWo2hq8ALB/j4k6ArjGNtyg3OzjMSHJMd/vJPEH1R8LxDy/5PVRkyB3bR1RikTb82TMHHMfExbNEM55+PQZUrLid5Bc2Zycso/NXLXOqL27j7EoCRk4b6ywepmBuUXZ31X+1GP4R
 a/a2NCou
 8A+HaF+tV2prXaeQ/kIZC1UtGd/Wlor8954HZv9ggxNgl9caAK3OGQ5Ukq/sz+DIZlwfyoaAkJt5Diwmix4rje/nZ1LWxOW7k7z6+8oucHh24/1VsXUGWzoIav1V8kQnVS32WwP+PTvC5wUYGDfDqbqEEhCWXVqzQkLjjrHSjBk/MM7wpTdPo+X+Si7sncZG7/wHi2JJo+TDKGhyCEAL6wWanx42zeZv1LJfujz88gYjv/SGAouGdUOodgG9pth2gR4agZuzR0XwoTd+AelC1JNnMpbaJKCAU8WGGdU41C0pGxNymyp2UQmhBlqD32pN1RtX78cGwEDTVM1fRH3OCXLROAPF5cNtIFfrcyOrtBnWlHQDnxqiUjHwDuq2uBhAX8pi2l7IQuvbXE9pCZDGns447ppp/QB9K6BE8w6kgz89V/hrDK8oECPcNM9/9tmV6f2PKZxQJG4h2k6yKAOdr3IArcCZ23npTuBp6bllxcUZ1gv0n0770PQWKVPfKROsEj39fg6ymAa3hylDTexzY36A5Rpsazmzg8lpsFWwK8nwW/OdmR6VXttEIQjTc70F9rtbmOOW1oJsY29BHTqfa139hvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Add support for retrieving files that were preserved from a tmpfs mount
> by restoring them into a file that userspace created on a tmpfs mount.
> Add struct liveupdate_shmem_retrieve_arg, which userspace passes as the
> retrieve argument of LIVEUPDATE_SESSION_RETRIEVE_FD with a file
> descriptor for that file, and record which files were on a tmpfs mount
> with a new SHMEM_LUO_FLAG_TMPFS flag in struct shmem_luo_ser. The next
> commit allows preserving tmpfs files.
>
> The mount a tmpfs file was on doesn't exist in the new kernel, and the
> path, owner, mode, extended attributes and other metadata of the file
> are not preserved. Userspace knows what they should be, so let it create
> the file, e.g. with O_TMPFILE, and only restore the contents and size of
> the preserved file into it. Userspace can then link the file at the path
> it wants. LIVEUPDATE_SESSION_RETRIEVE_FD returns the file descriptor of
> the file instead of a new one.
>
> This also fixes a bug: shmem_luo_can_preserve() is meant to only accept
> memfds, but it only checks that the file has no links, so it accepts
> unlinked tmpfs files by mistake. They are then retrieved as memfds,
> which moves them off their mount and out from under the size limit and
> quotas of the mount. Retrieving such a file without an argument now
> fails with -EINVAL if it was preserved by a kernel with this commit. The
> new flag uses an existing field that is zero otherwise, so a kernel
> without this commit ignores it, and still retrieves tmpfs files as
> memfds.
>
> The target must be an empty regular file on a tmpfs mount, opened for
> writing. Like the preserved file, it must be on a tmpfs mount, so that
> memfds stay memfds and tmpfs files stay tmpfs files. Files on tmpfs
> mounts always have exactly F_SEAL_SEAL, so there are no seals to
> restore. The file position isn't restored either, since the open file
> belongs to userspace.
>
> A preserved file with unknown flags or seals, or a tmpfs file with
> seals other than F_SEAL_SEAL, can't be restored, so fail its retrieve
> permanently.
>
> Fill the target like a write does: with write access to the superblock
> and the inode lock held, calling file_modified() before and
> fsnotify_modify() after. Add the folios while i_size is still 0, and set
> i_size last. Reads, page faults and memfd_pin_folios() don't look past
> i_size, so nothing sees the folios until the file is complete, and if
> adding them fails, they can be removed again to leave the target empty.
>
> Claim the target with liveupdate_claim_file() before modifying it, so
> that a file that LUO already manages is rejected, e.g. a file that is
> preserved in an outgoing session and whose size is frozen.
>
> Like the other failures before the folios are restored, problems with
> the argument and the target can be retried.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  Documentation/mm/shmem_preservation.rst |  12 +-
>  include/linux/kho/abi/shmem.h           |  22 +++-
>  include/uapi/linux/liveupdate.h         |  37 ++++++
>  kernel/liveupdate/Kconfig               |   6 +-
>  mm/internal.h                           |   1 +
>  mm/shmem.c                              |   9 ++
>  mm/shmem_luo.c                          | 152 +++++++++++++++++++++---
>  7 files changed, 210 insertions(+), 29 deletions(-)
>
> diff --git a/Documentation/mm/shmem_preservation.rst b/Documentation/mm/shmem_preservation.rst
> index e79bf8afaa9e..193c044ca637 100644
> --- a/Documentation/mm/shmem_preservation.rst
> +++ b/Documentation/mm/shmem_preservation.rst
> @@ -1,14 +1,14 @@
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
> -Memfd Preservation ABI
> -======================
> +Memfd and Tmpfs Preservation ABI
> +================================
>  
>  .. kernel-doc:: include/linux/kho/abi/shmem.h
>     :doc: shmem Live Update ABI
> diff --git a/include/linux/kho/abi/shmem.h b/include/linux/kho/abi/shmem.h
> index b61687e358a2..ec4f7594a7b6 100644
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
> @@ -69,12 +69,24 @@ struct shmem_luo_folio_ser {
>  			     F_SEAL_EXEC)
>  
>  /**
> - * struct shmem_luo_ser - Main serialization structure for a memfd.
> + * SHMEM_LUO_FLAG_TMPFS - The file was on a tmpfs mount.
> + *
> + * Set for files on a user-visible tmpfs mount. Such files can only be retrieved
> + * into a file on a tmpfs mount, and never as a memfd.
> + */
> +#define SHMEM_LUO_FLAG_TMPFS		BIT(0)
> +
> +/* The set of flags this version supports. */
> +#define SHMEM_LUO_ALL_FLAGS		SHMEM_LUO_FLAG_TMPFS
> +
> +/**
> + * struct shmem_luo_ser - Serialized state of a memfd or tmpfs file.

Nit: "Serialized state of a shmem file"?

>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
> - * @seals:     The seals present on the memfd. The seals are uABI so it is safe
> + * @seals:     The seals of the file. The seals are uABI so it is safe
>   *             to directly use them in the ABI.
> - * @flags:     Flags for the file. Unused flag bits must be set to 0.
> + * @flags:     Flags for the file (SHMEM_LUO_FLAG_*). Unused flag bits must be
> + *             set to 0.
>   * @nr_folios: Number of folios in the folios array.
>   * @folios:    KHO vmalloc descriptor pointing to the array of
>   *             struct shmem_luo_folio_ser.
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 4ebbd578d2d5..8e86891d5a62 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -250,4 +250,41 @@ struct liveupdate_session_get_name {
>  #define LIVEUPDATE_SESSION_GET_NAME					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
>  
> +/**
> + * struct liveupdate_shmem_retrieve_arg - Argument to retrieve a tmpfs file
> + * @size: Input; sizeof(struct liveupdate_shmem_retrieve_arg)
> + * @fd:   Input; The file to restore the preserved file into.
> + *
> + * Passed via &struct liveupdate_session_retrieve_fd.arg to retrieve a file that
> + * was preserved from a tmpfs mount. Such files can only be retrieved with this
> + * argument, and memfds can only be retrieved without it. Otherwise, the
> + * retrieve fails with -EINVAL.
> + *
> + * The kernel restores the contents and size of the preserved file into @fd,
> + * which must be an empty regular file on a tmpfs mount, opened for writing,
> + * and returns @fd in &struct liveupdate_session_retrieve_fd.fd, instead of a
> + * new file descriptor. Everything else about the file, e.g. its path, owner,
> + * mode and file status flags, is up to userspace, which creates the file. To

Nit: perhaps "... and file status flags are left unchanged" is slightly better?

> + * keep anyone from accessing the file before it is complete, userspace can
> + * create it with O_TMPFILE and link it with linkat() after the retrieve. The
> + * blocks of the file are charged to the mount of @fd.
> + *
> + * LUO keeps a reference to the file until the session is finished. Since the
> + * file is open for writing, it can't be executed until then (execve() fails
> + * with -ETXTBSY).
> + *
> + * If @fd is not a file descriptor opened for writing, the retrieve fails with
> + * -EBADF. If it isn't an empty regular file on a tmpfs mount, the retrieve
> + * fails with -EINVAL, and if it is immutable, with -EPERM. If LUO already
> + * manages @fd, e.g. because it is preserved in an outgoing session, the
> + * retrieve fails with -EBUSY. These errors can be retried with another file.
> + * Errors while restoring the contents, e.g. -ENOMEM, or -ENOSPC if the
> + * contents don't fit on the mount, are permanent, and retrieving the token
> + * again returns the same error. @fd is left empty in that case.

Nit: This is kinda hard to parse. I reckon a list would be easier to
read. Perhaps the below?

 * The following errors are retriable:
 *
 * - EBADF: @fd is not a file descriptor opened for writing.
 * - EINVAL: @fd is not an empty regular file on a tmpfs mount.
 * - EPERM: @fd is immutable.
 * - EBUSY: LUO already manages @fd, e.g. because it is preserved in an
 *   outgoing session.
 *
 * The following errors happen while restoring the contents. They are
 * permanent. Retrieving the token again returns the same error.
 *
 * - ENOMEM: Out of memory.
 * - ENOSPC: The contents don't fit on the mount of @fd.
 */

> + */
> +struct liveupdate_shmem_retrieve_arg {
> +	__u32	size;
> +	__s32	fd;
> +};
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 79fbf4aa4842..98373af5fcd8 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -76,9 +76,9 @@ config LIVEUPDATE_SHMEM
>  	depends on SHMEM
>  	default LIVEUPDATE
>  	help
> -	  Enable live update support for shmem files, i.e. memfds created
> -	  without MFD_HUGETLB. This allows preserving memfd-backed memory
> -	  across kernel live updates.
> +	  Enable live update support for shmem files: memfds created without
> +	  MFD_HUGETLB and files on tmpfs mounts. This allows preserving their
> +	  contents across kernel live updates.
>  
>  	  This can be used to back VM memory with memfds, allowing the guest
>  	  memory to persist, or for other user workloads needing to preserve
> diff --git a/mm/internal.h b/mm/internal.h
> index 566cbd2dce48..6cacbf1f5c7d 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1432,6 +1432,7 @@ int shmem_add_to_page_cache(struct folio *folio,
>  			    pgoff_t index, void *expected, gfp_t gfp);
>  int shmem_inode_acct_blocks(struct inode *inode, long pages);
>  bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
> +bool shmem_inode_on_internal_mount(const struct inode *inode);
>  
>  #ifdef CONFIG_SHRINKER_DEBUG
>  static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
> diff --git a/mm/shmem.c b/mm/shmem.c
> index af21a89abb0f..ad6beb328553 100644
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

Nit: perhaps shmem_inode_internal()? Bit less wordy.

> +{
> +	return inode->i_sb == shm_mnt->mnt_sb;
> +}
> +
>  bool shmem_charge(struct inode *inode, long pages)
>  {
>  	struct address_space *mapping = inode->i_mapping;
> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index bdf90aac5820..7242664ee4ae 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
[...]
> @@ -577,6 +603,86 @@ static int shmem_luo_restore_folios(struct file *file,
>  	return err;
>  }
>  
> +/*
> + * Restore a preserved tmpfs file into the file that userspace passed in the
> + * retrieve argument.
> + */
> +static int shmem_luo_retrieve_into(struct liveupdate_file_op_args *args,
> +				   struct shmem_luo_ser *ser)
> +{
> +	const struct liveupdate_shmem_retrieve_arg *arg = args->arg;
> +	struct inode *inode;
> +	struct file *file;
> +	int err;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	CLASS(fd, target)(arg->fd);
> +	if (fd_empty(target))
> +		return -EBADF;
> +
> +	file = fd_file(target);
> +	inode = file_inode(file);
> +
> +	/* Like the preserved file, the file must be on a tmpfs mount. */
> +	if (!shmem_file(file) || shmem_inode_on_internal_mount(inode))
> +		return -EINVAL;
> +
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EBADF;
> +
> +	/* Fill the file like a write, which also takes these locks. */
> +	file_start_write(file);
> +	inode_lock(inode);
> +
> +	err = -EPERM;
> +	if (IS_IMMUTABLE(inode))
> +		goto unlock;
> +
> +	err = -EINVAL;
> +	if (i_size_read(inode) || !mapping_empty(inode->i_mapping))
> +		goto unlock;
> +
> +	err = liveupdate_claim_file(args, file);
> +	if (err)
> +		goto unlock;
> +
> +	err = file_modified(file);
> +	if (err)
> +		goto unclaim;
> +
> +	/* The preserved state is consumed from here on. */
> +	args->retryable = false;
> +
> +	/*
> +	 * The folios are past the end of the file until i_size is set below,
> +	 * so reads, page faults and memfd_pin_folios() don't see them, and
> +	 * they can be removed again if adding one fails.
> +	 */
> +	err = shmem_luo_restore_folios(file, ser);
> +	if (err) {
> +		shmem_truncate_range(inode, 0, (uoff_t)-1);

Nit: would be more uniform if you add a label called "truncate", and do
a goto truncate here.

Since I only have small nitpicks, feel free to add once fixed

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

> +		goto unclaim;
> +	}
> +
> +	i_size_write(inode, ser->size);
> +	inode_unlock(inode);
> +	file_end_write(file);
> +	fsnotify_modify(file);
> +
> +	args->file = get_file(file);
> +	args->fd = arg->fd;
> +	return 0;
> +
> +unclaim:
> +	liveupdate_unclaim_file(args, file);
> +unlock:
> +	inode_unlock(inode);
> +	file_end_write(file);
> +	return err;
> +}
> +
[...]

-- 
Regards,
Pratyush Yadav

