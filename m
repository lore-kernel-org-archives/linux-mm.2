Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FCD3606A889
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBqU4DgI
Received: by kanga.kvack.org (Postfix)
	id 8C8966B05B1; Sat, 14 Nov 2026 07:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852916B05B2; Sat, 14 Nov 2026 07:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B1C6B05B3; Sat, 14 Nov 2026 07:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446306B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59801A7EFD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:24 +0000 (UTC)
X-FDA: 85433589528.01.E544079
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3B798000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBqU4DgI;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657802;
	b=xHsGZbNiOU/dfdoj+Ec9wcPfWKk+N+K6LI67dj87wXs4n7m4lhb+FyWiuxb108mXE1ns0d
	8kuCPv9EYk2F36Z3wG4NSm6BRZWh9YDN3Au2/saH3+NV2oHOuFbgd0e0MVhIr2MW1yR8yy
	vYwjL56NiZAEsp8lPCanNDpFYqd0y94=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBqU4DgI;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657802;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtvIFXoOKLAsH+V2h5HHt5wrTO8bTwuJgaiMNtvW4Sw=;
	b=vXpKWCEfn9tl9ARurOPaADFgm6X1veIPEbABMDtU4tXSGln7/rKPIpP/niqHHZhbzT34Gx
	Gf2cWnpkCWB2J2kE0FgKOtjbSpv1o1QLYs2YQ8ReoHESZPGjn7jxNJhS24tKfqlAm22tTS
	du28IG90jGJv6idri3L+CR/LILcsv3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ACB9602D3;
	Sat, 14 Nov 2026 12:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBAB1F000C4;
	Sat, 14 Nov 2026 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657801;
	bh=ZtvIFXoOKLAsH+V2h5HHt5wrTO8bTwuJgaiMNtvW4Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZBqU4DgIsVF4fBQNr4bYIKhPWkjeKQvvtPUUd9Cz31YPzLVJOtMSWjDuH7EGA/h7n
	 P2EPM9PNC3jDOgl7kqQR3OcR5SuiZnwdbTz/URj/thGHq6pavdyM9GR1V7q5+9Nr9L
	 ogQpeDGM/vpkwHN2a+d6KH5p1Dq1y5+epVPBRSkaCZhhXeQqYtWZ7nOpi4phoiJOFa
	 QW2WytooNIT+NaZ1bOtDLE6flFWVJJCUO+3bxaKOxlU9uNVzGHsSLlk/mD2Ae18ZH1
	 y1aN0XFGCVxI9RZanX5gvGBBfw/tKxhyoRW6iX00wFbvNon9+aBAYwguwpQmTyJmz/
	 sjdBN32e0lXhA==
Message-ID: <sashiko-outbox-214452@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/33] jfs: free uncommitted anonymous tlocks when
 evicting an inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:20 +0000
X-Stat-Signature: 5ri7d8z1eyizdbiexyi8ohs1x56zx7wx
X-Rspamd-Queue-Id: B3B798000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657802-603435
X-HE-Meta: U2FsdGVkX1/ZasGIJVZyxZ9dJsx5w2zv52NSZA9ZzxbMkemq5k934B5vl4XQ4PvAA/kchujy+Rx07R3nN95hne6yiktLt43fKlvALbG7BBVPNqMeXW/Cw0IrnPPMRZ55Finuw/0MPf6vKUg9cZm6YrEjdrpLrClNv2kDuHAgxaqwOGBm21Goaz8NVTM665YPc/ajtbsKixgstBrTfOfH6cuaYIOFrafdjCKP9X4j38RKAs1Vmplm+xfkXTj35QRkgU3S+iG42dx8mqINmTlfoRpBslM55DYCzmvKjgr5tbYSAUTOYFk/8ZD2zQrKI7iAEFSBhltxS+yOefTEEel4W3eYNTqJJHfdYWNbRTKO8BoMJ1+QctVjn0r7HwA5KQh8JM1PPZXNrgaZNnr6nQa/eIdYTpSASKRg5stARTSDU/903eWuvHtPE0c4nnZ8K2qkicY0WYS3daWwR2rbwf/g63Msx3BfHAeALdvEAAPQR+b+SHdigCnCEnW8bDcmHec85+7gZ5kuCvl3qA2Tm/4fzqsgh5NuNQtgW/kkKLFx4B1vfOBwAFlxsTuT2qqoudSzQH8xWdZy5lx+s3E0v544DOnFmE3W0ea62RmyV07KveWrKrxTVPi7PKpkIv1bev6dMhj9prUnWN4yOGolZ7cDyDx1SoV5cY3AUUVe0Y1ukTuMwsxW6Wlvm8LODrUwGnSIWtmlmMgy3rt934CQRIhgzPR6YcAH5E2wHnvFSc0Bun7NClAiJlye6YRCQSs4jf73VdEacgHWk8zinY2hkTccuUypvm2pZLi2unjnYiCmbKnz341PjcN2jj8MBm/VF3DHNfI3QKcG11UB/hUHE1L1w/nmZnyXxrNkuVppw2l4UUNrpdA7oax2pQqsh5BV9ItNXZdkiPLtsLKxvoFZZk/f/4upOFFkkVbplyxJf//dF+/Z7d7r9x1/uyOU9K+hksfhZUbJziJ7c5SVL6yI2xP
 sekslBUM
 mlrT2sOu2n6Og0/KbxnynLmnMecx5da6usdGpQcryVyNeKkRUudPILQeqPU5gz6Crdth4smSTifIRmBrvhGTm/NU3JFX1rpVudxP0qWCjgdtNevU9hEvF9HJih5aPoojL78IOM5E6ATaFX0t/bmaAbKVkyZFByFCqt9i7tgSSrpAIc9ngNKreSIhJ9wRDJHQ+qsk6d1nbCAxKiPQ0Xdk3UU0qgXi6hJ/o7w8ecJjCr2JlB9teofyRe74Sqhl5NyvSDnsVEYAoojw/e2ix8Upnw1uqA9vegqrO3ju+04o4UOtfD9EviISqAsDqAdvPf++6V4IElJM0QdWay3ucPIvjE91ZD98IcHnnzjmFPuee+2emeMgqZjWE8RmZ1I+hgnRZqrEaTonNzRqTQsQtWAM+hEEPk8L0fpWcdrgCV6vKSr2+3kIIGXSCuMqXPGueXawHosNHjOpUT9QjYgoKeREqmmlDS6yEBzXye2DmYTTB9BMZbIi1TqvaEG30T8cxNJyj3ACy9VKleFFAJURJfo3kMq2AykkI/hwmaajXul/N8Xq+fBLD89mT4S+gsv1EoBvfC5cXfJEAOH52aLCB6WQ4OwwD8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] jfs: false WARN_ON_ONCE() in jfs_evict_inode() on read-write
  mounts
- [Medium] jfs: txAbortAnon() after jfs_free_zero_link() leaks metapages
  and tlocks
- [Medium] jfs: race between jfs_evict_inode(), txAbortAnon(), and
  txQuiesce()
--

commit a15655dff32c48b09c331d3e03e198e2173008c1
Author: Christian Brauner <brauner@kernel.org>

jfs: free uncommitted anonymous tlocks when evicting an inode

This commit adds txAbortAnon() and calls it from jfs_evict_inode() to
release uncommitted anonymous transaction locks and metapage pins when an
inode is evicted before writeback commits them.

> diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
> index c7914dbc91ed9..6390d915c7f11 100644
> --- a/fs/jfs/inode.c
> +++ b/fs/jfs/inode.c
> @@ -172,6 +172,15 @@ void jfs_evict_inode(struct inode *inode)
>  	clear_inode(inode);
>  	dquot_drop(inode);
> =20
> +	/*
> +	 * Writeback commits the anonymous transactions of allocations. If the
> +	 * filesystem went read-only without a sync, e.g. after an error,
> +	 * nothing did.
> +	 */
> +	if (ji->atlhead) {
> +		WARN_ON_ONCE(!sb_rdonly(inode->i_sb));

[Severity: Medium]
Can WARN_ON_ONCE(!sb_rdonly(inode->i_sb)) fire on a read-write mount when
ji->atlhead is left populated without setting COMMIT_Dirty?

In extAlloc(), xtExtend() and xtInsert() acquire anonymous tlocks on
non-root xtree metapages via txLock() before splitting pages in
xtSplitUp().  When xtSplitUp() fails with -ENOSPC or -EDQUOT, extAlloc()
frees the data blocks and returns before calling mark_inode_dirty(ip):

fs/jfs/jfs_extent.c:extAlloc() {
	...
	if (xaddr && xaddr =3D=3D nxaddr)
		rc =3D xtExtend(0, ip, xoff, (int) nxlen, 0);
	else
		rc =3D xtInsert(0, ip, xflag, xoff, (int) nxlen, &nxaddr, 0);

	/* if the extend or insert failed,
	 * free the newly allocated blocks and return the error.
	 */
	if (rc) {
		dbFree(ip, nxaddr, nxlen);
		dquot_free_block(ip, nxlen);
		mutex_unlock(&JFS_IP(ip)->commit_mutex);
		return (rc);
	}
	...
	mark_inode_dirty(ip);
}

Because COMMIT_Dirty is never set on the inode, jfs_write_inode() does not
commit the anonymous tlocks, and evicting the inode triggers the warning on
a read-write filesystem.  The warning also triggers after a filesystem
error when mounted with errors=3Dcontinue, where jfs_handle_error() marks t=
he
superblock dirty without setting SB_RDONLY, or via extRecord() ->
xtUpdate(), which is fixed in a later patch in this series (commit "jfs:
don't set SB_RDONLY after filesystem errors").

> +		txAbortAnon(inode);
> +	}

[Severity: Medium]
Does calling txAbortAnon() after jfs_free_zero_link() leak metapages and
linelocks when an unlinked inode with COMMIT_Freewmap is evicted after an
error?

Earlier in jfs_evict_inode(), an unlinked inode with COMMIT_Freewmap calls
jfs_free_zero_link() -> xtTruncate(..., COMMIT_WMAP).  For each non-root
xtree metapage, xtTruncate() marks mp->lid with tlckFREELOCK, calls
discard_metapage(mp), and finishes with txFreelock(ip):

fs/jfs/jfs_txnmgr.c:txFreelock() {
	...
	while ((lid =3D xtlck->next) !=3D 0) {
		tlck =3D lid_to_tlock(lid);
		if (tlck->flag & tlckFREELOCK) {
			xtlck->next =3D tlck->next;
			txLockFree(lid);
		} else {
	...
}

If the transaction in jfs_unlink() or jfs_rename() aborted after
commitZeroLink() set COMMIT_Freewmap, ji->atlhead still holds anonymous
tlckPAGELOCK tlocks when jfs_evict_inode() runs.  txFreelock() unlinks
those tlocks from ji->atlhead and frees lid before txAbortAnon() runs,
without dropping mp->nohomeok, clearing mp->lid, or freeing chained
linelocks.  Calling txAbortAnon() before jfs_free_zero_link() would release
the metapage pins and linelocks before xtTruncate() discards the pages.

> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index 083dbbb0c3268..85192dd4461a4 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -2581,6 +2581,74 @@ void txFreelock(struct inode *ip)
>  	TXN_UNLOCK();
>  }
> =20
> +/*
> + *	txAbortAnon()
> + *
> + * function:	free the anonymous tlocks of an inode that is evicted
> + *		before writeback committed them, e.g. because an error made
> + *		the filesystem read-only.
> + *
> + * A page that carries nothing but uncommitted changes isn't written hom=
e.
> + * A page that is also waiting to go home with committed changes (mp->ls=
n)
> + * goes home with both, after an error the superblock is marked dirty.
> + */
> +void txAbortAnon(struct inode *ip)
> +{
> +	struct jfs_inode_info *jfs_ip =3D JFS_IP(ip);
> +	struct linelock *linelock;
> +	struct metapage *mp;
> +	struct tlock *tlck;
> +	lid_t lid, next, llid, k;
> +
> +	/* txQuiesce() and jfs_sync() commit under the commit_mutex */
> +	mutex_lock(&jfs_ip->commit_mutex);
> +
> +	TXN_LOCK();
> +	lid =3D jfs_ip->atlhead;
> +	jfs_ip->atlhead =3D jfs_ip->atltail =3D 0;
> +	list_del_init(&jfs_ip->anon_inode_list);
> +	TXN_UNLOCK();

[Severity: Medium]
Can jfs_evict_inode() and txAbortAnon() race with txQuiesce() walking the
global TxAnchor.anon_list?

txQuiesce() walks TxAnchor.anon_list (shared across all JFS mounts) under
TXN_LOCK() and drops TXN_LOCK() without pinning the inode before taking
commit_mutex:

CPU0                              CPU1
txQuiesce()                       jfs_evict_inode()
  TXN_LOCK()                        txAbortAnon()
  jfs_ip =3D list_entry(...)            mutex_lock(&jfs_ip->commit_mutex)
  TXN_UNLOCK()                        TXN_LOCK()
                                      list_del_init(&jfs_ip->anon_inode_lis=
t)
                                      TXN_UNLOCK()
                                      ...
                                      mutex_unlock(&jfs_ip->commit_mutex)
                                    ...
                                  destroy_inode(ip)
  txBegin(ip->i_sb, ...)
  mutex_lock(&jfs_ip->commit_mutex)  <-- use-after-free

In the opposite interleaving, txCommit() called from txQuiesce() clears
jfs_ip->atlhead =3D 0 before taking TXN_LOCK() to remove
jfs_ip->anon_inode_list.  Because jfs_evict_inode() checks if (ji->atlhead)
without commit_mutex or TXN_LOCK(), it can see ji->atlhead =3D=3D 0, skip
txAbortAnon(), and hit BUG_ON(!list_empty(&ji->anon_inode_list)) or free
the inode while txCommit() is still running.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D1

