Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC5D606A338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l7FoqcmY
Received: by kanga.kvack.org (Postfix)
	id 71A556B05B9; Thu,  5 Nov 2026 10:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F20C6B05BA; Thu,  5 Nov 2026 10:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607E46B05BB; Thu,  5 Nov 2026 10:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 364CB6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:42:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA05F40A76
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:42:48 +0000 (UTC)
X-FDA: 85401483216.12.8B95891
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D46B3A000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:42:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l7FoqcmY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTsd4K4FS1c/0QtVRFQ6L4sBWzBDsskkKVi3HBwNbgQ=;
	b=OxLY3xJjw+PEH+Ufvrkz+4CJ4SMmpbvEeEq8MLjPK/WJm7f1jR8Z8wfXSwckIixct1kZYK
	3JT+qNR8z4v2Ku6mBeurEUpIoMJH4DOd4w7iYUKyGm2FwLitE2CS5+uTDbFiT9TB17orBn
	GZWymG6WB0R9wz5VTdBKEF+Js7EGTJQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l7FoqcmY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893367;
	b=mOKfPDOchjGBXiLMeAzRNIbqMnWAyoz5a9oSlvae+b1XTOw2aWOeNUXrhFjH48pIwXCegS
	JJyMtPy4LO8F1yrqhPw0UGv4yXSszY+mqNZhLeEcpGP0o40sm8Uv+q800S2iHaXLIgZZ8Z
	j0W+hQ1R5taN59eMikrCCmyWQJAyCsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04E9342148;
	Thu,  5 Nov 2026 15:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5BF1F000C1;
	Thu,  5 Nov 2026 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893365;
	bh=CTsd4K4FS1c/0QtVRFQ6L4sBWzBDsskkKVi3HBwNbgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l7FoqcmYX/+njg5zd1k1bA+FOA+lDCfiQNMdQHITGrpFOtDmfodmQeUvlG8+8QdRY
	 dDOSBg47/nnwS77SH1jriKunFI3Cf1YOogrSEPvaokKcDhCBbxJ51evpByksS3uR8Q
	 jAz59rW48V/DSQ7VFwoWcUKs7VhS9lxCpN33OC0L6hW91Z0COzvnr2cl5dHN5C18SK
	 xqs5IN75QQH3MMCyO2H21i49gUXYNT2NULY4YudARb8bmgEuX3EWn+M7+wEvTRWNWI
	 OV/7ivC6SN+MnTQoWZ2WI8WgIXhh1udieUA8CDzRCP1Og1YArIngLLm/7fkA5e7d31
	 SW+g94h6ECq8Q==
Date: Thu, 5 Nov 2026 16:42:38 +0100
From: Christian Brauner <brauner@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 00/10] liveupdate: Preserve tmpfs files across Live
 Update
Message-ID: <20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner>
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D46B3A000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 38bjoygaggbyqdzicbi48pip3u3c3ig5
X-HE-Tag: 1793893366-764388
X-HE-Meta: U2FsdGVkX18dBn62s4Fuak4ruZOoM2YNlZNWwLEFPU0k+y7EuZyaN53a8QQ4wDpPRTVqqIeSd22eK4wO4AD5lI2fwlpD9isEPL7bqKJs7RcXjV4cxao+Q++i+YGFKRkyoRx/AgW36b7HM78/iBIgeoUy0meCcSls+dXWc3OUFXJXbTmJQL/4tjUxLBoLAlFCVo91xD1cwt0NEeVT67rzBOa03JRRRa7qHhwFsoVn0ET7jDh3ZEUME15+4hvsF+5hw1fWKOvCFM08CluaayToMrH5aH7wnyLEj0Rp8UtzChW9VzOr5OG0x9ZbyRTbbo7ePzlVKOLDG6odWFOMA2THRf3uYfzoqfrw90kZh15HIlvR6Bu61+yky+1Pxc/wmEQqSbXzL26Ph8Y0F09tQcYHXufiaSZpYHI76cWBmWaXfPBudwgxGIlyYnyP2+DMAfPx6p0u1a8gHxKtyExeoEmHNhYQm1V1SmjSpP35dWFVhF1YrZaow7NUobkj8rGxccNs2fnUaSK52iFVM3RBy5MrBPaDQJ6nFXaMHusX/BODsPVpH1VI/Z50ckGUhzD8A9jhELDBb1+qCKEn+iOocmJ73sKmr4ZZeVRxcfq/vaqV2dwK7pyNjPWegI1rZyDq9KJU1fdx3RoxLYakNI+/cmBX9JxxLy3wL0gIWgwW7rT9ueWxFQOSp8ANpvUI2LjOjhvwxJvG8aBbhoDUo7H9CkbrUoE3k8WPZP5LNnPeE3H7ZwhCufhSANv3IpzLGdvuOV5QUolEC0K1HhdpY38Dftqu+FFURk97bbvsPPbbEZ1DCtoD+YLQ7gKMRgC8A1Vwt9J6mmV+Sb2lPlq8golxGYF/yuXjsW7q20eTLxYNmpDuz0ye7NTlZj+GXX6meofj+6RrH0mZg0Lwkog0xHBK19VkgUSB0m8VCWJzwRn/0qAPE36wAbcy3A+E32rM2tw2/y8jhfEx+qWqyWJl/AvE3CX
 TQH1EVge
 d5klC1MM7ZcjVvoFGvNGqTbNWhTnC4ExcloUvzQjpj8DQDE5iebcr+LPTHauXK3wDqiyacVFB8mW0vxgpLqWFJp0YziLzTdNqaG5zqYK3tvg427Pses1CJkA/Lkf7HpL1VpZPT1MzI7tb2bJnRphShYUla/sORMMzJYzx4zQBsnQbl73J+/lzvRqBg5ks0TXZpRPBNLkUKZ/OYYdNvd/UbEYkU25uHibQ0ReEdEO+YPam8evrs4ev0Z6Qhgpy6qX/DEc6WQgf4iatfj6cVFinCayr6Ms6evoX0wEZgzToaIjaLArbrZEeoxyDMsYeJxKVQ6gbxqLk/DTedo8P5BsSZGopGsU8a325YtKKsR0k/c/rFkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:02:06AM +0000, David Matlack wrote:
> The kernel preserves the contents, size, file position and seals of each
> file. After the Live Update, userspace retrieves each file onto a tmpfs
> mount of its choice and links it at the path of its choice, so userspace
> decides the directory structure, names, owners and permissions of the
> restored files.

[...]

>   4. Retrieve files that were preserved from a tmpfs mount onto a tmpfs
>      mount chosen by userspace, via the new struct
>      liveupdate_shmem_retrieve_arg. The kernel creates the file as if by
>      openat(dirfd, ".", O_TMPFILE | flags, mode), so the file gets the
>      same flags, owner, permission checks and security labels as any
>      other new file in that directory, and is charged to that mount.
>      The kernel fills the file before returning it, so nothing else can
>      access the file before it is complete, and userspace links it at
>      the path it wants with linkat() (patch 7).

No, sorry. That's not what we discussed at LPC and it's not what the RFC
and v1 did.

There userspace created the file and LUO filled in the contents. That
got turned around in the v1 thread and I think that was a big mistake.

The kernel is now responsible for creating the file and for its
permissions but it preserves none of that? No owner, no mode, no
xattrs, no security labels, nothing.

Instead userspace passes a struct that duplicates the open() argument
list and the kernel runs umask, setgid inheritance, default ACLs and LSM
labeling on it. That makes no sense whatsoever. Either the kernel owns
the metadata as well or it stays out of it completely.

Spoiler, it should stay out of it.

Userspace is responsible for everything but the contents. Take systemd
wanting to preserve a whole tmpfs. We already know how that works and
discussed that at LPC with you.

- We generate a manifest of the filesystem ith every file with its owner,
  mode and xattrs using UAPI.17 manifests (cf. [1]).

  We stash it in a memfd and reassemble the tree in userspace after the
  live update. All it needs from the kernel are the contents. Having the
  kernel recreate any of that is pointlessly complex.

So instead of LUO handing out a file descriptor for a file it invented,
let userspace create the file, O_TMPFILE, O_CREAT, whatever it likes,
with the owner, mode and xattrs it wants, and let LUO put the contents
into it. That's what the RFC did.

The checks on the target are trivial: a writable fd to an empty shmem
file with the inode lock held while you fill it. A tmpfs file can't be
sealed, it only ever has F_SEAL_SEAL, so there's nothing to restore but
contents and size anyway.

Pasha, your argument for creating the file in the kernel was that
nobody can reach it while it's being filled. **That's what O_TMPFILE is
for**: Userspace creates it unlinked, LUO fills it, userspace links it.
If userspace hands a half-filled file to iommufd that's its own problem.

I also really dislike file_open_root() for this. It's an openat()
emulation inside an ioctl which is completely terrible.

It redoes the openat2() validation by hand (reject O_PATH, unknown
flags, stray mode bits), force O_LARGEFILE, and because O_TMPFILE
insists on write access you open the file O_RDWR, copy the normalized
f_flags out of the first struct file, dentry_open() the same path a
second time read-only without any permission check and drop the first
file again.

So an LSM sees an O_RDWR open for what userspace asked to be O_RDONLY.
Whatever path_openat() happens to do for that synthesized flag
combination becomes LUO's behavior. That's brittle as fsck. All of it
goes away when userspace is responsible for that.

Fwiw, the permission model you end up with on retrieve is write and
search permission on the target directory, i.e. vfs_tmpfile()'s
inode_permission(dir, MAY_WRITE | MAY_EXEC) plus mnt_want_write() on
that mount. The new inode is owned by whoever runs the ioctl with
whatever mode they asked for. Nothing about the original file matters.
IOW, the kernel has nothing to contribute here that open() doesn't
already do.

Really, please make the kernel's job stupidly simple: let userspace get
the contents and let it be responsible for the actual complex restore
and the filesystem layout.

A hybrid helps absolutely no one.

>   - Is patch 9 (retrieving tmpfs files with O_RDONLY) worth merging?

No. With userspace creating the file this doesn't exist.

>     are created with mode 0777 (or 0666). Is this the right permission
>     model for preserving files? Should this apply all files or just
>     shmem files?

The preserve side seems fine to me. If you freeze the size of a file
for everyone you better be allowed to write to it.

[1]: https://uapi-group.org/specifications/specs/file_manifest/

