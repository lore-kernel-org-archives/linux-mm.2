Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E769A10A62DC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F2E6B0089; Thu, 26 Mar 2026 10:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582596B0092; Thu, 26 Mar 2026 10:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423BC6B008C; Thu, 26 Mar 2026 10:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 301FC6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:07:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B9B3160E08
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:07:22 +0000 (UTC)
X-FDA: 84588391524.06.193B507
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 64FA7140012;
	Thu, 26 Mar 2026 14:07:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gf/EJZ+s";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774534040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FbCjjwLBCdyNeKJ2nIi/y/sA26mDX3D982HAjRjSrA=;
	b=Bzf6jE5WoB8MJ+46TxvbUQN1xGyFPQPYMMvUSM7GTpaq6Xec2QEOzvcnR0GWIUsd+KPQkh
	yBNbnSpF2NzdJ9hpN7+8mqO7hvnhh0dmx5LiQkyWpzcA9URQCYU8lWcpoFeHqmLyk9I4jY
	58362gO6KLW532wgvGsrmQ/bDvInngY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gf/EJZ+s";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774534040; a=rsa-sha256;
	cv=none;
	b=ivt6mOdLLj1vzLCnD8h6OQ29MwNstkPTWkoArMne/u4vgsXCGVrVmY/nPkxNnyycagmoPK
	63oJxMLFYnLgGLRFu03t45QL0XUghiuY62Tixp9MReJWvtYXV97l9ER6UEQqC+WTW4tM4n
	nKWGn0LV/XvabxO4MaHKsajf18fgMaI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62E6C40E54;
	Thu, 26 Mar 2026 14:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F9CC116C6;
	Thu, 26 Mar 2026 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534038;
	bh=nAMqc3HhiEGW5PQEX6C6n3tkO/8TUO5fRKgbFNWd/Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gf/EJZ+sZSc6B0Si328/7/oiwuUxy/Nte51P6k4nQ6b2VbtDp7CxAajNzpj8iR5Wp
	 JFZKLfEQzYUBPXPD2DvtgNqECZ3l+ptF2tfg5PDstV3hHTt4c25cim9XjuF5MGUFWV
	 n3QVjtzMJBGeoHFeDUeR5jwV2hT6Vt0P7he4b+ffuwyK2PayWDW6eZqVBnbOAgqN1L
	 HyLadVsnGIxixFfKI0ZolFV7io0Tc534F1IAfqY6KCpHv+d1eX9Tku3/CDw0XXY1L8
	 AT74Sms0ViYyOwLE+WNRtfCPN2U6mRA20wt4AqeEoHBSM8ndHiAFK1UWtfdfV9Q5xf
	 40pG/V/mnPOAw==
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
Subject: Re: [PATCH v3 0/42] fs: Move metadata bh tracking from address_space
Date: Thu, 26 Mar 2026 15:06:47 +0100
Message-ID: <20260326-obstgarten-ausrechnen-34d66c2df7a7@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=6163; i=brauner@kernel.org; h=from:subject:message-id; bh=nAMqc3HhiEGW5PQEX6C6n3tkO/8TUO5fRKgbFNWd/Qw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQete0zZn9/bY2enadhMb/Dn7XlFjJqeUUdXrs3zr9/+ 13oFEuWjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImoLmP4Z77hJOOhA27uv264 fWzKCvh/U3it+8LXimqXgpom5n1zYGVkeLNwbqT/LXbG8KYDh9b4hxwUr+Tsu/m2fY+OA+9S8Sp 2dgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 64FA7140012
X-Stat-Signature: 93atesu7doef8azjdf83cw3ke6jy4k4e
X-Rspamd-Server: rspam06
X-HE-Tag: 1774534039-635892
X-HE-Meta: U2FsdGVkX1/52lYRDVZVd7yZqip1gff9UG/xDYTgRU+Ock2Z+2Ym5ag2M6KObSteC56l+u8pWEc0s6wy1cZC0istF3Qvh16oVW0Wu8ZcrJxLk9pqvt3km0laoWJ85QEMpqjderrzUMKaScPl4kAl2F2MlhQLeGXXzqPhdlHjFlOh/UEb/AOfY+yt5vtSn6alubKawUHrOoxC/Wyc+bkYhGIhy8nCRmGXqawAZLydUWtaP6kPrex1QSahaRM5wVs9unsQrCpXK9DamBn7nUIZhWAYJv3HUXDZex84IE2urrGgRkHdKLJ3pTPtuYBqrZ+FRSUPcEBkHwSN1PkqOkBLUNsIYiMcAsdHIift+ff9cKHKsDakrXntwLIgnVJjvhcBPmGOzHhQSetLZ5NWUGAfq9Jabq3wZ9hQ+GPb17scaIk4MAd2Xpr3xoV8QbyGE47FHZkehhyATOtbescVexqRSjbiKO4HtKDkLWWRN99mwcFGLVAtaVEomIgiMZ0QfcysEMhlOOnOzGKUItebxvPwFqsMI3AxaoIrpjG3C8d8Tx6xWkRDJ4jo6irgC2+IlOEEsCpBBrmFpmVuJmUyjvlnhmKVzZHHbm+NuBNxtjO3m7tG7a91uWFUZdDcvQWnsUlCDuocsElXal3arhfT5q1sttfkwyPqPBgpxlfMWzBlCYVXlorkwUYpYDEuqzGyFoKH6pkmX7Os0FDQ6Z/yNyU3hVt8EF/DpxC88+ESXcHFYxI9msg4JA5d8xMreJaSCD00I0nDS0Mo7YcZ1M7I93o0eIW7ijpHu4TiPPSe74xw9NEnATV3irjvHbMXhjBRGT7uKrGvu8+I4Ija04ALf7ailr+/dR/8sUvv9P8DDjTqQO7pDEu1rDQPtLiDpuOIBoNfaPRePsECsQowWwv+rQOeZzEF4H7Q+RXEudXpkX8o9sDE7IN0n1xzcXLWqiuoIRMv+r3W6/vQlNJeFvUSFCL
 lKyAMKIZ
 KzkX5302JMGgSsLhVEKZjCG4Wgk5fKDCQfjR2YB/B0ZToKjW/2e7X6LUc9x9wBuqHXUAvITw45rL5szJJZcK+Ix/5K2YzCCLYWVjSl8eVl1lxwIB/coCNG0I4gEbXIVpCxflSP6ueGDW6J5FkExGz/RlIvyECuwpjihmEpkHMVMIcykp+OfmRo7B2MhPIUFeo58/j2ikYhsa2UqSicWZ1yw00Y4DNV6TP9bs5VwxI2AuOyKsLEV9BJNLXsWgqMYkilSkNGIsjAjc7n8oJ+umTCJ1/IrjR5zwh2nbKtC/R/LMkKhMF7KanNt/BEnCqrhPlhYR2hDgdDuyBGHkK9z9r+TrxUcuxar5HLsL8LRokQChmJSJNHmnzQDnImBqSK0A8MucheWdzzgnmFzdv4swqwiXxs36s2ehIXg+K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 10:53:54 +0100, Jan Kara wrote:
> here is a next revision of the patchset cleaning up buffer head metadata
> tracking and use of address_space's private_list and private_lock. Functionally
> this should be identical to v2, most of the changes were in improving
> changelogs, patch ordering, function names, etc. The patches have survived some
> testing with fstests and ltp however I didn't test AFFS and KVM guest_memfd
> changes so a help with testing those would be very welcome.  Thanks.
> 
> [...]

Fwiw, a fixup series on top would have sufficed this late in the cycle. :)

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

[01/42] ext4: Use inode_has_buffers()
        https://git.kernel.org/vfs/vfs/c/ab856368582b
[02/42] gfs2: Don't zero i_private_data
        https://git.kernel.org/vfs/vfs/c/7e5ccdd88c5a
[03/42] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
        https://git.kernel.org/vfs/vfs/c/ddd6761f8777
[04/42] ocfs2: Drop pointless sync_mapping_buffers() calls
        https://git.kernel.org/vfs/vfs/c/70450fcfd28a
[05/42] bdev: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/f9480ecf939d
[06/42] ufs: Drop pointless invalidate_mapping_buffers() call
        https://git.kernel.org/vfs/vfs/c/09a23f3a0401
[07/42] exfat: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/2cbfeb4c8a43
[08/42] fs: Remove inode lock from __generic_file_fsync()
        https://git.kernel.org/vfs/vfs/c/ba31a330b4c1
[09/42] udf: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/f3216337d96e
[10/42] minix: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/f3873f90b4c8
[11/42] bfs: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/235cddee8590
[12/42] fat: Switch to generic_buffers_fsync_noflush()
        https://git.kernel.org/vfs/vfs/c/635aa2f67817
[13/42] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
        https://git.kernel.org/vfs/vfs/c/aec4fe7cce0c
[14/42] fs: Rename generic_file_fsync() to simple_fsync()
        https://git.kernel.org/vfs/vfs/c/5f36c9ca3333
[15/42] fat: Sync and invalidate metadata buffers from fat_evict_inode()
        https://git.kernel.org/vfs/vfs/c/63f1f4b6c9c8
[16/42] udf: Sync and invalidate metadata buffers from udf_evict_inode()
        https://git.kernel.org/vfs/vfs/c/153e5960450a
[17/42] minix: Sync and invalidate metadata buffers from minix_evict_inode()
        https://git.kernel.org/vfs/vfs/c/61aa62ddfb5d
[18/42] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
        https://git.kernel.org/vfs/vfs/c/4211dc89c31c
[19/42] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
        https://git.kernel.org/vfs/vfs/c/77ff1ff2f3c5
[20/42] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/4a7fd1823efc
[21/42] affs: Sync and invalidate metadata buffers from affs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/23dae9e189de
[22/42] fs: Ignore inode metadata buffers in inode_lru_isolate()
        https://git.kernel.org/vfs/vfs/c/972b9dd4e418
[23/42] fs: Stop using i_private_data for metadata bh tracking
        https://git.kernel.org/vfs/vfs/c/0f46a9e2743c
[24/42] hugetlbfs: Stop using i_private_data
        https://git.kernel.org/vfs/vfs/c/2811f2a82faf
[25/42] aio: Stop using i_private_data and i_private_lock
        https://git.kernel.org/vfs/vfs/c/3833d335d7be
[26/42] fs: Remove i_private_data
        https://git.kernel.org/vfs/vfs/c/cd336f2e275d
[27/42] kvm: Use private inode list instead of i_private_list
        https://git.kernel.org/vfs/vfs/c/d15c987d1226
[28/42] fs: Drop osync_buffers_list()
        https://git.kernel.org/vfs/vfs/c/cae6b7a03c7e
[29/42] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
        https://git.kernel.org/vfs/vfs/c/8fed8176312b
[30/42] fs: Move metadata bhs tracking to a separate struct
        https://git.kernel.org/vfs/vfs/c/521bea7cec8a
[31/42] fs: Make bhs point to mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/c86f5d25514c
[32/42] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/025c9af1a20c
[33/42] fs: Provide functions for handling mapping_metadata_bhs directly
        https://git.kernel.org/vfs/vfs/c/a8c8122a3dac
[34/42] ext2: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/b0439bbc29f0
[35/42] affs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/6874973e720f
[36/42] bfs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/b0806ac078e2
[37/42] fat: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/439959848b40
[38/42] udf: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/d0874a580a4b
[39/42] minix: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/caaa184b4243
[40/42] ext4: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/41189b49bcf1
[41/42] fs: Drop mapping_metadata_bhs from address space
        https://git.kernel.org/vfs/vfs/c/cb6d109b9ccc
[42/42] fs: Drop i_private_list from address_space
        https://git.kernel.org/vfs/vfs/c/f219798ce294

