Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32376EC01C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEC96B0088; Mon, 23 Mar 2026 06:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5BC6B0089; Mon, 23 Mar 2026 06:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6127F6B008C; Mon, 23 Mar 2026 06:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49A706B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:30:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCEB75BF4E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:30:09 +0000 (UTC)
X-FDA: 84576957738.27.D7AFBEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35545120013;
	Mon, 23 Mar 2026 10:30:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lPJK7q/R";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774261807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiUWSUMnAXcYqKTXNK/U0M7JipSvZMfSumUScdsrJ6Y=;
	b=UnNFsMrTw/WIWLXoWUBeX8WST7lULorQka2612/l5d4lp4uHVmHyYncy/IP4PtolZAeu2D
	YtoNGAerKBq/Cd2SbSOGm6FCfmH7Up+28E9VmZ0II12xE77fktegpJeHIUKgA/9TrBRQvc
	0XHQtTerQ5fzg63xefrhpE9XAHrKglM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774261807; a=rsa-sha256;
	cv=none;
	b=IVQ2flKwfPbfxefJucByodL6dncUzy9DaW0qO5/w/G0u0MdY+SIxLxyrMZ7aHem/XfOOY8
	Y1XuiUqYFAkKNKbZMzZflIGzG0De4fKD4zzYkliLexK+SkgS8WN780o2Y71eV92AhkatLz
	dU0q7Ncj+x3asPYEM16f8CfXBJIVzJI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lPJK7q/R";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDEE7404A8;
	Mon, 23 Mar 2026 10:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD25C4CEF7;
	Mon, 23 Mar 2026 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774261805;
	bh=CYVaduY/P84e+sSr1daS5pYdiCCw81Cl8IHz5x0n3/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPJK7q/Rchuq2wnqhTigey0tTOv0A4muIVq83a5xBa9JmKpmJKAll/yCjBDEDF1RT
	 CYzcr3xqrZvPYVy2qZ7CSi3s2RbkROJMBC1nzsvzYco/8OhMvl3C86Z5Ye70oQ2IMM
	 /2Qt/Lki1JRW8EM+RB02cf0HnCkvgUlqxr3gWOU8V9XSfrt+YyybRAHrNOeLx60eE2
	 lxhhyuBv9FqFlM8kfyTfm7khdp6JuWhJm+zFZ4hTKyh/9yT1VT2XeWzL43RZlEcXvl
	 IMRPa94L9FGpQoCov3RoWm/OPjgiIOhSQjVeBeOJ/F6LDkUKBlVGZm++RROb7HPWwt
	 GcfDz9/8xI3tQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-block@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH v2 0/41] fs: Move metadata bh tracking from address_space
Date: Mon, 23 Mar 2026 11:20:03 +0100
Message-ID: <20260323-dickicht-turnt-8353124f0f5d@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=6550; i=brauner@kernel.org; h=from:subject:message-id; bh=CYVaduY/P84e+sSr1daS5pYdiCCw81Cl8IHz5x0n3/E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQeFFNpbFa80yHleljrV5G1AIOk9C3lHXvKwu761UxkO xv/X8Wlo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJTBBn++9yYU9ES6lJk67FC 60Pwu/o+wU9WjdMjOycfe6B7ZamFMsM/hTXX3N66SqQ6/bHeudtnUtAbk96s7oNpCz7dvFEWWhP HBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q1e1189gphawzcahp5hdrkcbgh45xkuk
X-Rspamd-Queue-Id: 35545120013
X-Rspamd-Server: rspam03
X-HE-Tag: 1774261807-949426
X-HE-Meta: U2FsdGVkX1/DlGBevKipTQl2CsIx4j8zEZSftImmMXBmEWB8HgHA558CTcTm4aXFL9hiWNfA5icPgOmpCHyNKssI/JEaI6FARmXkt8dl2V5sGC8qu1sbwHfLX6ZqlCCc4rt9dZGIvZ4ToSBWGVf/L8GhQEnboKOwO4ff22T0GCwZyktg9uOhHvko2ZvCC22sHqWchCUs27cPGs/pE7gT6vVlJnw64+dCasmMFOuWwwSbYJ43MnWYNmMGw9LyW9/VHLyGsCtP3V2EqcBaw+qCAtmoy5fwGWhZXj5/EO04epvstlEoIV1efo/I/cVk5SM8LONxF9BPYAh8Txb1hKbDil+3J3UCLWlBep4Bo7930hNDLSn/YNKkqF/hedr95GRYrgrDvXN3Q7ku4aXJeJCEd7R6khf10Fofx15PbAWnjADwlZr+dmAy976+0kS0UVle1NxInX0I7BZZlUnk8414HwOidFfj1SDb9cKth2AOE99cY75EA7gLdlMyEiSZZhotXwL26r+rly+gyQNnl2ZeSOpOuz9VY1omhP+H9+kbrZiCXfsjgD70uZGGr8WJ+Ce0hBYjEF7c980cba3Xe7S0Li+VNMmljJ5hh0Nd1/W585Oeagz9Ttb+9pvwVtwZ+ae0QU4Ggqd+ikALBTvJgEmtd0nOunZETvgW1rMmoFgA7pEboFMJoWIkecDxfaNWj2VrTPDWEeDwdtB3MMZbzsC3Yi/GiIsQjulkE8XeKFOs9fW04M3tBznjaqYYtoUhoOuJQh5PakiuyNx27K5ETtpSC1POdk/E3Yir4qIXOJLizN5Cf8Ap6FqcdTT+boccqYuUvTggva4o47KKs8RCkPudF2lzxIDuOBl1INgcmdmMl4fFEG7So+Y2rOrldvKx1GTkDC3B6tBevHihKmkKzJw3Sja5gAf/UEugNlAbGGingjGvKDYI+9F5uJ5ZpV5xbvUBidEZeYxbfxNr4V5pzlw
 5P7prdMe
 HXw2yUDJ48WEFcNsRFziEVtxuJ4bsrGUI9trcN70trGayaXb8MMLzgJ0X+M2GkJNlVkGOiyift7gyBysWFGVf4BqfZNkqIttKhR267J4nUppCWfEJozFqO+2+OqqB+fB8uWCmndVCSosloYuTKVApLadYSjpvFRWbvflt194XCg//Jq2mK8RGunUQ6sU1nusp8LEPnC9A87w5SmiHbam5nkZAUW8Kos4fzRHO1RtpH7SiA5/IO2D+K72q+8WCNMFlXzWxkOIhhXfLnW5l0peiHYyJBzmHFnHbc43UMaVBJwLR6Ezl5vrJlV14pPRgYdxGc6L/dx/6Lufr9g5G4hspM2uboZRMiR8NY47/3uJ1sH42Jifq2i9Wf56tezsqTQGAXvc+eXzE56k2u/+gRZYnRLGXmYCJvNeezacz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 14:40:55 +0100, Jan Kara wrote:
> here is a next revision of the patchset cleaning up buffer head metadata
> tracking and use of address_space's private_list and private_lock.  The patches
> have survived some testing with fstests and ltp however I didn't test AFFS and
> KVM guest_memfd changes so a help with testing those would be very welcome.
> Thanks.
> 
> Changes since v1:
> * Fixed hugetlbfs handling of root directory
> * Reworked mapping_metadata_bhs handling functions to get the tracking
>   structure as an argument so we now don't need iops method to fetch the struct
>   from the inode
> * Reordered patches into more sensible order
> * Added patch to merge two mostly duplicate generic fsync implementations
> * Added Reviewed-by tags
> * Couple more minor changes that were requested during review
> 
> [...]

x86_64 (gcc, debian, ovl-fstests)  pass
x86_64 (gcc, debian, selftests)    pass
x86_64 (gcc, debian, xfstests)     pass
x86_64 (gcc, fedora, ovl-fstests)  pass
x86_64 (gcc, fedora, selftests)    pass
x86_64 (gcc, fedora, xfstests)     pass

---

Applied to the vfs-7.1.bh.metadata branch of the vfs/vfs.git tree.
Patches in the vfs-7.1.bh.metadata branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.1.bh.metadata

[01/41] ext4: Use inode_has_buffers()
        https://git.kernel.org/vfs/vfs/c/2caab145b54f
[02/41] gfs2: Don't zero i_private_data
        https://git.kernel.org/vfs/vfs/c/8395055f2455
[03/41] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
        https://git.kernel.org/vfs/vfs/c/bed1ecade645
[04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
        https://git.kernel.org/vfs/vfs/c/c40f470d21ae
[05/41] bdev: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/4e001046c8a6
[06/41] ufs: Drop pointless invalidate_mapping_buffers() call
        https://git.kernel.org/vfs/vfs/c/26d88dcdb54b
[07/41] exfat: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/8dbad3a0e39a
[08/41] udf: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/0892d39092b3
[09/41] minix: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/387a7a22307e
[10/41] bfs: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/a59c3be58777
[11/41] fat: Switch to generic_buffers_fsync_noflush()
        https://git.kernel.org/vfs/vfs/c/e118e65dba18
[12/41] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
        https://git.kernel.org/vfs/vfs/c/0bdc542b3faa
[13/41] fat: Sync and invalidate metadata buffers from fat_evict_inode()
        https://git.kernel.org/vfs/vfs/c/f2145333cd91
[14/41] udf: Sync and invalidate metadata buffers from udf_evict_inode()
        https://git.kernel.org/vfs/vfs/c/525acf32a4ad
[15/41] minix: Sync and invalidate metadata buffers from minix_evict_inode()
        https://git.kernel.org/vfs/vfs/c/60ef3750f238
[16/41] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
        https://git.kernel.org/vfs/vfs/c/52e995b1474d
[17/41] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
        https://git.kernel.org/vfs/vfs/c/36dc7f23446b
[18/41] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/aa2caecd2b38
[19/41] affs: Sync and invalidate metadata buffers from affs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/2779c362a490
[20/41] fs: Ignore inode metadata buffers in inode_lru_isolate()
        https://git.kernel.org/vfs/vfs/c/95c6bfdb5d3e
[21/41] fs: Stop using i_private_data for metadata bh tracking
        https://git.kernel.org/vfs/vfs/c/89f2eea7f6c3
[22/41] hugetlbfs: Stop using i_private_data
        https://git.kernel.org/vfs/vfs/c/8f3bf5b0ce4e
[23/41] aio: Stop using i_private_data and i_private_lock
        https://git.kernel.org/vfs/vfs/c/8514c0d15c45
[24/41] fs: Remove i_private_data
        https://git.kernel.org/vfs/vfs/c/aa7c3819d2db
[25/41] kvm: Use private inode list instead of i_private_list
        https://git.kernel.org/vfs/vfs/c/1e0cbe5bac95
[26/41] fs: Drop osync_buffers_list()
        https://git.kernel.org/vfs/vfs/c/f07ad1722cda
[27/41] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
        https://git.kernel.org/vfs/vfs/c/e7cd907f2326
[28/41] fs: Move metadata bhs tracking to a separate struct
        https://git.kernel.org/vfs/vfs/c/a3b0a90f1e93
[29/41] fs: Make bhs point to mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/d8b6d9ff9552
[30/41] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/9e5f33d8201e
[31/41] fs: Provide functions for handling mapping_metadata_bhs directly
        https://git.kernel.org/vfs/vfs/c/a13a480c81b1
[32/41] ext2: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/107b7505d866
[33/41] affs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/592eacdd5928
[34/41] bfs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/c6661db8efc0
[35/41] fat: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/b5d84862f99d
[36/41] udf: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/7d37ac2bba4c
[37/41] minix: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/37da66baf00c
[38/41] ext4: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/ebcf10f6f905
[39/41] fs: Drop mapping_metadata_bhs from address space
        https://git.kernel.org/vfs/vfs/c/ecfcd39c0ab0
[40/41] fs: Drop i_private_list from address_space
        https://git.kernel.org/vfs/vfs/c/b39f532b7a2e
[41/41] fs: Unify generic_file_fsync() with mmb methods
        https://git.kernel.org/vfs/vfs/c/24b45fa837a4

