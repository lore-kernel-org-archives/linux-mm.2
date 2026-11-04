Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEA9606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IvMQyH0f
Received: by kanga.kvack.org (Postfix)
	id 149F26B00EF; Wed,  4 Nov 2026 11:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FACA6B05B3; Wed,  4 Nov 2026 11:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011506B05B9; Wed,  4 Nov 2026 11:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4D7A6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:46:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76B56A07BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:46:00 +0000 (UTC)
X-FDA: 85398013680.04.F43C82F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D74764000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:45:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvMQyH0f;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMRlEbt6cHro/1IG77teEVtLiLDMtq9tpaJD/wmZeq8=;
	b=Xz2Cz8wSb6IRiV8xuHhE8Umd2Zgr39EHKNBqYRR8rmue+T4mdODp19yJLE7AUCVEv4eUML
	be5cHA5sdlpzEOogv1pX8hFxYjhDC5kiZsPnln9xvKmrzuSxRqSl74tf76oOfCaL/InmRl
	hhHmWYQ7V+2SfjudialtHhnW+l9AGyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810758;
	b=PG5ehu6fPeQsrSI57AcfKZfPSlhz3PO9ac86oKFMYCjaP6GEd3ZN2FQ72lWit0aHPQB54p
	toRy/h5kE08aAo9GjkQiiWtyBKnja02i+CThcimaH3cEKMTr5QrQKmUGwzIOobfi8miu34
	a3Xh4taJmfApuVPrbYl0E5OtCQVbHME=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvMQyH0f;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FAE760A6B;
	Wed,  4 Nov 2026 16:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6296E1F00A16;
	Wed,  4 Nov 2026 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810758;
	bh=dMRlEbt6cHro/1IG77teEVtLiLDMtq9tpaJD/wmZeq8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IvMQyH0fvGLwwH3rDmeWMLfCLYAGdIbnCG7AOu8FUrXpcI70IKaVwu29p1G8lxanC
	 qUOeAK2OnjpXBnv2US7vgM90DOjtp52wtMBTd3//9mHUWaamJQGkqBwlP2RBMYmki6
	 jf1VFR4XDyT+sYFzB9eEt1mMGb/7sXTdpPJoeALrFdo6tMxCoSpD0MGcMLBSF5Oskg
	 12jrVbegBjbo1u0Xoaa66/zOFOLBdGhyc6qv8S7xo6wIhvUCnvw91utT46e4QcgkAE
	 sDhLQVOM9U5RvpQ1scMUIV3w11TSDzscUg76rCdIH+1RbNg98eZkKIso3/Sw7tl5Nb
	 kLzFUfNWcGCug==
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
Subject: Re: [PATCH v3 08/10] mm/shmem_luo: Allow preserving tmpfs files
 that are still linked
In-Reply-To: <20261103010216.3447716-9-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:14 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-9-dmatlack@google.com>
Date: Wed, 04 Nov 2026 17:45:53 +0100
Message-ID: <2vxza4nok0ji.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: 7gp1nskakm46hzkiaqn5qos6dsye5u1y
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: D74764000D
X-Rspam-User: 
X-HE-Tag: 1793810758-932473
X-HE-Meta: U2FsdGVkX1+rvddmxpxGik9wLMwdh9n+zVWDRTCYrbg0Rtaf0PYbahhEUS5Rpjxm69r0WndjdXFsa87kYLO4iy7OxPtGh64BBiUheOM1uC5kERV6tFlJtdG1VbxDZGi8qHw8i6jkkV/qjhc1YZ8E9hUcrENpaf48svVM9fMsQJhxNCfRX9U8UqY748NhdJuA/MUl2aqh3Xi6ZTkGQodKKufzKdKXChgBjl1CXHgXeylQwa8LXpLPc0x/OMM1L7uJ4QGNuZf0I3YPtuac3Gg/3JnH+2n2XMW15RUwspVTRsolY1OMbgBb35MjNpnmOa3sNxRFxq/uQMeFgxuth1Imv9yRLomkXPGk83splljPKfssWRh07O0E7wU3RO3OWERwdXcbjLotjqQLD6wAv28GJfP4r5ApoPyutbIKJsMrq/UaKuINch5ykKHMihFMoAKc7JH1P2b5t9Xd8A5xydutTRd9wQ0yLKk8RwUZ/0FtgycH3LEWikckLKKn4Eh26WqMmqiNZgwXvsdUH81ZIM4qs1mSSGjL0Vdyq5gDrHoWc9EZ7+aTfxIZAjaF1+Hn3p0sa+VRj+uyMuXaAvmsUa7tenMxnXtlPhqk4u/hangITXnwD3+IIviJfJPQMCtuBHCRROz0jXinHp2Llp5rRKCEC8K550BznKkSJe3izL6iZHbX/9+cRolAQ/ImgNmGmtwwHRhtJcx/iKgwOaUl3aBPGqJi3vt28nYi2iPhUe8bY8Vlp+ElCd/DQj6VvnhZ7sYm0mpSx/mqnq1TDnoQDeAQX9COB3G57qDt4JojX/CJ+1irODBBlRr8DgzFBoLvlWlT0zP4ukUr8xk7WnOa41oQqY2eiIt7+mUycsuQXlZx4WW3aOckabhCs68M/TTffrxT8vESgLqek4OznEnb6E8dhEa24fk1aQ8aMIOYty/efewzUkPe5TcK0aaUOflUwb44+XIMNbs546QKYyUzsHG
 mc3gAkkP
 Xv0/JJEqUzNSI6QcpLhrucSJ1r8ToiHoarAlkHOPY4paV+fDvwFmrB16GP2VdJNGGO8ig4ytpdvHf5eDkDSYhf6/LOi7oJz4kYA4gsbxfBClcdr+fyhy7SYidUtahLKPSvt1Jy8n88BeEjpKWl9xjoX0q+2nHb4HBEWJJBMVyKzkLybQQpNPtCNfTm9YSFlyhlQQBnLn/NkvVD6NWj/gp7A+tBOe+KqbjO0+W4uqNMCg0y3re8bNRGqOUFwKiRXHBjKx3p4X7LkmnNMyzPE+8Xv3yvVoZCkXgCsjM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Tue, Nov 03 2026, David Matlack wrote:

> Allow preserving tmpfs files that are still linked. To preserve any
> file, require permission to write to it and the file to be opened for
> reading, and reject append-only files.
>
> shmem_luo already accepts any shmem file without links, which includes
> unlinked tmpfs files and files created with O_TMPFILE. Accepting linked
> files means that userspace doesn't have to unlink files to preserve them
> and can keep using them by path until the live update.

No, no. As I wrote in the previous patch too, this is a *bug*, and not
"supported". Please don't treat it as such. Tell your LLM to also not
treat it as such ;-)

This patch doesn't do "Allow preserving tmpfs files that are still
linked", it does "Allow preserving tmpfs files".

>
> The path of the file isn't preserved. Like other files from tmpfs
> mounts, a linked file is retrieved onto a tmpfs mount chosen by
> userspace, which can then link it at the path it wants.
>
> While a file is preserved, its size is frozen, so truncating it,
> fallocate() and writes past its end fail with -EPERM. For a linked file,
> this affects everyone who opens the file by its path, so a caller that
> can only read the file, e.g. a world-readable file in /dev/shm, could
> use it to break the owner of the file. So require permission to write to
> the file to preserve it, for all files. Like FS_IOC_ENABLE_VERITY, don't

That makes sense, but can you do it for memfd as well please, as a
preparatory patch?

> require a file opened for writing, so that binaries that are being
> executed can still be preserved through read-only fds. Also don't
> require a writable mount, since preserving a file doesn't write to the
> filesystem. If the size of the file can't change anyway, because it is
> immutable or on a read-only superblock, also let its owner preserve it.
> Don't let others do that, since the size could change again once the
> file is made writable. Like FS_IOC_ENABLE_VERITY, reject append-only
> files, since their writers can only append to them, and freezing their
> size would stop all appends.
>
> Also like FS_IOC_ENABLE_VERITY, require the file to be opened for
> reading. The retrieved file can be read, so otherwise a caller that can
> only write to a file could preserve it to read its contents.

I've stopped reading it by this point. Sounds too LLM-ey. Please try
to make this easier to read for humans.

For example, why are we even talking about FS_IOC_ENABLE_VERITY? I
reckon you have it in your chat as an example to draw design from, but
then LLMs have a tendency to leak those information in patch logs. I
usually spawn a subagent with clean context and a high level description
of the goal to review the changes and changelogs, to clean up these
things, and then of course review everything manually.

Same thing in your comments.

Please clean them up.

>
> Preserving a file also fills its holes, but don't require any permission
> for that. Anyone who can read a tmpfs file can already fill its holes by
> faulting them in through a read-only mapping, also on read-only mounts
> and for immutable files.
>
> Document the frozen size and the permission requirements.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  mm/shmem_luo.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 64 insertions(+), 3 deletions(-)
>
> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index ecbeb37d33a8..0c012f242fc5 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
> @@ -28,6 +28,24 @@
>   * the file are preserved. All others are reset to default. The preserved
>   * properties are described below.
>   *
> + * A tmpfs file can be preserved even if it is linked, but its path is not
> + * preserved. Userspace chooses where to put the file when retrieving it, as
> + * described in "Retrieving Tmpfs Files" below.
> + *
> + * Preserving a file requires it to be opened for reading, since the retrieved
> + * file can be read. It also requires permission to write to the file, since
> + * preserving it affects all of its users, as described below. But the file
> + * doesn't need to be opened for writing. For example, a binary that is being
> + * executed can be preserved through a read-only file descriptor. The owner of

Why are you talking about preserving binaries being executed? Seems
oddly specific. I didn't know that was a use case we cared about.

> + * a file whose size can't change anyway, because it is immutable or on a
> + * read-only superblock, may also preserve it. The file can be preserved
> + * through a read-only mount. Append-only files can't be preserved.
> + *
> + * While a file is preserved, its size can't change and no holes can be punched
> + * into it. Truncating the file, ``fallocate()`` and writes past the end of the
> + * file fail with ``-EPERM``. This applies to all users of the file, including
> + * users that open it by its path.
> + *
>   * .. note::
>   *    The LUO API is not stabilized yet, so the preserved properties of a memfd
>   *    or tmpfs file are also not stable and are subject to backwards
> @@ -298,6 +316,45 @@ static void shmem_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>  	vfree(folios_ser);
>  }
>  
> +/*
> + * Check whether the caller may preserve @file. The retrieved file can be read,
> + * so require @file to be opened for reading, like FS_IOC_ENABLE_VERITY does.
> + *
> + * Preserving the file freezes its size until it is unpreserved, for all users
> + * of the file, so require permission to write to the file. Like
> + * FS_IOC_ENABLE_VERITY, don't require a file opened for writing, so that e.g.
> + * a binary that is being executed can be preserved. Also don't require a
> + * writable mount, since preserving the file doesn't write to the filesystem.
> + * If the size of the file can't change anyway, because it is on a read-only
> + * superblock or immutable, its owner may also preserve it. The size could only
> + * change again after the file is made writable, which is up to the owner or
> + * root. Reject append-only files: Their writers can only append to them, and
> + * freezing the size would stop all appends.
> + *
> + * Preserving the file also fills its holes, but that doesn't need any more
> + * permission: Anyone who can read the file can fill its holes by faulting
> + * them in through a read-only mapping.

Please rework this whole block, it's unreadable.

> + */
> +static int shmem_luo_may_preserve(struct file *file)
> +{
> +	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	struct inode *inode = file_inode(file);
> +	int err;
> +
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> +	if (IS_APPEND(inode))
> +		return -EPERM;
> +
> +	err = inode_permission(idmap, inode, MAY_WRITE);
> +	if (err && (sb_rdonly(inode->i_sb) || IS_IMMUTABLE(inode)) &&
> +	    inode_owner_or_capable(idmap, inode))

Nit: can you move these conditions up, and directly return 0 there? Much
more readable.

> +		return 0;
> +
> +	return err;
> +}
> +
>  static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
>  {
>  	struct inode *inode = file_inode(args->file);
> @@ -307,6 +364,11 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
>  	int err = 0, seals;
>  
>  	inode_lock(inode);
> +
> +	err = shmem_luo_may_preserve(args->file);
> +	if (err)
> +		goto err_unlock_inode;
> +
>  	shmem_freeze(inode, true);
>  
>  	/* Allocate the main serialization structure in preserved memory */
> @@ -362,6 +424,7 @@ static int shmem_luo_preserve(struct liveupdate_file_op_args *args)
>  	kho_unpreserve_free(ser);
>  err_unlock:
>  	shmem_freeze(inode, false);
> +err_unlock_inode:
>  	inode_unlock(inode);
>  	return err;
>  }
> @@ -710,9 +773,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
>  				   struct file *file)
>  {
> -	struct inode *inode = file_inode(file);
> -
> -	return shmem_file(file) && !inode->i_nlink;
> +	return shmem_file(file);
>  }
>  
>  static unsigned long shmem_luo_get_id(struct file *file)

-- 
Regards,
Pratyush Yadav

