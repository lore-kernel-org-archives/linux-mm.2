Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21714606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QprEbjuf
Received: by kanga.kvack.org (Postfix)
	id 448986B05B9; Thu, 12 Nov 2026 07:01:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FDA6B05BD; Thu, 12 Nov 2026 07:01:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D1A6B05BE; Thu, 12 Nov 2026 07:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11D346B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:01:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1D7B14055F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:01:43 +0000 (UTC)
X-FDA: 85426327686.20.E47009B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C27C210000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:01:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QprEbjuf;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484901;
	b=hhGOvVg+oWe7/yzC5WTqqAIeKVI0DbxQHGmupPtOS/3J+ZDWTvMI+/z/g2wfEYHtsD2wYv
	hsOcaMphsmGu3nVA5kIu60q7pBqmkL72/AzcjGd85HIYEkSqNGvzseRKz0re7siMz5AxbN
	q73ewx1jwjbLolfnClf96nXXN/eGt2o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QprEbjuf;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54I5bKtP4WSw79RGADSyevDuBquelpIbRaI3K1RVgo8=;
	b=OviOkt594fR9Sfg9ZV/NoSb4jrsAUjvKlCxx+Y26wmiFIhSefRlR8k/SHViFlYXMCo9fWC
	0sxx+yh0pAZFa7X95OcpOJ+BReWmKRBU4ZT9lP+L2O15vbmkgTr0sZL6/rvMf4pArA4+IP
	lpEJWP7xzK7E8U+3qG9e0jjqRGMO62w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00B2547325;
	Thu, 12 Nov 2026 12:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA7E1F00A06;
	Thu, 12 Nov 2026 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484900;
	bh=54I5bKtP4WSw79RGADSyevDuBquelpIbRaI3K1RVgo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QprEbjufNb+tvrOa7rBrGmxplqbmNy39Rmf2KUfr+AHg8IrdqKnppWAi/6c1jQ5lw
	 1qQwMsR8fpHwFmAmOjHt6xx/GSD6lfIfUEbOqwxFxYqpUqqxaGguK/FgeQ9b4yse7n
	 X5Gu+V8HvIKolxJnQl0GAY0dMopIoY1Zswfa1hVJnxH54H1V2CcTIR0C3XNIO1kYQQ
	 jb08MOlodWLAKvfmxQBVrfP5uY0qBjF050j5MxuY9KrdgN1iuTLU+0ziIbWc5XAA1N
	 31t4iwXyBD3El+zm85fqmePh/BsB9Y9+wkUwIt81ymt+t2A7BgUdE1+/gxOp3PTE+D
	 sGRcdsQZ5uAtA==
Date: Thu, 12 Nov 2026 13:01:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
X-Stat-Signature: 73u68bqotumun74azfcej8e6xq1npuia
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C27C210000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794484901-432249
X-HE-Meta: U2FsdGVkX19PEON+Wa1sRNlwxquGsSvTvwq0CxtEe6P3deyX8E+0LhlM29P64KOCnCIgVIEGUynFugCHhxoXIkpVuXvt2qq0GKOmJ53oTq8/Pc8uJpMoFvU6aYMSfYjc5aVMJ1dWSZJdftA2xkkfFg5cWHmEHQIZgWpmd9h2+Ta0MLjenA8S/TlKvuAo07Lw+nJlbNc/jEzBkF9K+b2lps6B4w1non7CQku2CJbljXLJAeu9M9J/kzDdXvB4PY7dtruju4fp/qlyetz6xpT0LfsUDqIG6wiNUNXfALnnwPrz3Rafsk19eBjhVNwSxu0T5rb2nOP9pJj2rbYpkKuNMgyTb0Twy6GToDc8GwdHiq4Wq/ZA+/nmKx+6AS+HgNtLCHOvvePbg2uKN2KTx2G5S9TENMDWmpX+Ge9mNb6fU4XLC7FQ3naJdNXVLgj5gRlyk6wXi2inmSiCXmndIIz6hQcdby7TH1FP0fdtQ24EQxnpSGOVoIwjJuLeMeNsj5TtjKX3XwzOATe/l2KatFAhw3VI3Xxls/uVN66dKhHlbjLyWLfTjkImMTin1ybA5vPHH2p9HMUbc+phPJrT13TDVKZv5a8JqJWlF08fd7TmmHvlmtP1yFaYKxW6eSLpjKPy9CSM/hez+MC9CNAvzMQZRjlP8cWyHshdbajQETF0zP6mC77cAtVS9UdmSHlMIpg6yNeUHZVU/tm10k+pmjQfrKZQ/GNEusZvfD9IfLgKPDU/WG+4HFS/7MimFRsRGZ/uxsz5buTMAd1PzhEI+gg0Ut9iNsmbhN+LIKRxycvoRsDxV8O7APC3/cWy9jVrpHlRD7fe9thQH4Rn4aukeoqU1za8PyoDIJPKuvms+zVHUvVFbD5mmj91U351cocPkUwHsTePJammhWjKSNT/OAHV6PVyP2Px5fLwQ4paEZdIdgBQ3puWWN5XAanLrIEzp+Agd+1ej7yr2dw6qHQNB5J
 KqWtplaI
 bIv/HL2PlXl/AO8SDL42f/SZLK9TJBHpRfAuLVTVUnc3Jnx2Kq2kC1pBG+tssz3s27nRSqCJDDjTEs5/5OG/un/qRp8a2L7W8C++ricW4/lCMybKhvCpqdnqWTLSRRsTs1SzDdeAHXV+dwt2OBadOLZJRPBnsNkPX8H/EsAdG0wHxtMQYnIUmVgX6xmK6Rvqwo62VWnrJatQyT1Adkea7vK6gQ+CkHRa8Zi63X1qn83eEBKrugMJHnUBejiDXFkhDOdvv3vIKysjwMVuENzuTMhGOCB+Yk2T67/y1f/xliBrrRYIuzSFricLmUzfBajQhMoH9GGEd0qfne/avBnwuH8oF+vgkjR0yXG86gsQluIdc7zEw8VqvEXIn34856gAWDE6Xp67HyG3iGQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:15:11PM +0100, Jan Kara wrote:
> OK, so instead of BUGing in jfs_evict_inode(), shouldn't JFS just do
> something like:
>
> -	BUG_ON(!list_empty(&ji->anon_inode_list));
> +	if (!list_empty(&ji->anon_inode_list)) {
> +		WARN_ON_ONCE(!sb_emergency_ro(inode->i_sb));
> +		/* This needs helper in fs/jfs/jfs_txnmgr.c */
> +		TXN_LOCK();
> +		list_del_init(&ji->anon_inode_list);
> +		TXN_UNLOCK();
> +	}

Fwiw, this leaks the inode's anonymous tlocks. They're from TxLock which
is shared by all jfs mounts. txLock() also sets mp->lid and pinned the
metapages with metapage_nohomeok().

So the helper would have to tear all of that down like txAbort() does
and drop the pins. Doable, I guess not sure if this belongs into the
series.

> So that JFS doesn't block everybody else? Because conceptually, once sb is
> marked as emergency read-only, we really want to stop writeback so letting
> sync_inodes() run seems moot.

Meh, but a check in sync_filesystem() doesn't stop writeback? The
flusher doesn't know about the emergency state and keeps calling
->writepages() and ->write_inode().

And kill_block_super() calls sync_blockdev() after
generic_shutdown_super() so everything in the bdev mapping
(FAT, bitmaps, inode table blocks) gets writeback anyway. All the check
does is make syncfs() return without writing anything and make unmount
drop whatever the flusher hasn't gotten to yet. Which might be the goal
you're after?

> Argh, also NFS I assume. OK, that won't be easy to get rid of AFAICT (we
> generally don't have mount available there).

So nfsd_setxattr() takes write access to the export's mount via
fh_want_write(). So this would get EROFS from the VFS. Afaict it's
ecryptfs and IMA? ima_fix_xattr() only checks IS_RDONLY().

-- 

