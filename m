Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50559606A327
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BAF3VZkc
Received: by kanga.kvack.org (Postfix)
	id F212D6B05C0; Fri, 30 Oct 2026 12:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E846B6B05C1; Fri, 30 Oct 2026 12:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71A16B05C2; Fri, 30 Oct 2026 12:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4536B05C0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E55407DB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:05 +0000 (UTC)
X-FDA: 85379779170.27.E7C6950
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 714C1140004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAF3VZkc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376604;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6Q73W+VdmnakUy7Y5elmMaCWEDdB23SrYHzIAMDn7g=;
	b=v+IoP8Q+ERu1/ZEZWCy9Lc2eY82dyB7T7C5PrS7W1Er5hdh6I1e6IPLjMuoNR2EFnTDCVA
	+Zg+d7NLhqsGSFeHfHAgWUoMu7VK/glZxhAGGEAteKwq9dLRnu/e7ftUeS4n6grlY7qX78
	H3ypiL+VhaTH091J33j8pBiv2v0LdVw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAF3VZkc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376604;
	b=vjl7wXako9fm4tCBfOkXZM771tAAkGty+UIQctvSu8OgeDSNz77i4Jwidi4g8FoETd78h8
	LbNqNSDu0zFs1h9Ef/n6Fkq3wA0k4CD012cUCKZsKnKv7ABVGSsce410Y237yTdf4ybM94
	A0kyRZOPHtolRzdaMtbb31bSx4pfj1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F23F8605C6;
	Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1431F0093A;
	Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376603;
	bh=v6Q73W+VdmnakUy7Y5elmMaCWEDdB23SrYHzIAMDn7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BAF3VZkcESPBHNBLVO+30EPHzGf30kWo2ewHfgcMcy0jZo/r31QELbi3CpNQSemRk
	 3jFK0IS0u1K8btB8A4IZtH4bxRpuOgmyD/v0pMe1RDMYYMgCeikbG9p5MfYBp+aFIy
	 q5o2RcOwBTAlx0TKCDeLbm1S1Esxvcy7VxkzcSTuhRDKa2/OWC5ieOSS1A/RNedgjc
	 lv00s+NpcaSsuscaiBChDBuC3qDMvI+l7HDCHsaqNeum48k/ObujKmh1wZeDbFJ+4a
	 yiUQ9ThrQ9Ownz28NCXdyTMWXDUd7uT6q8giDsM/ukhvIcLJoyAzUrxqWXsNHtWgkF
	 vWVomann4IZOA==
Message-ID: <sashiko-outbox-191236@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:02 +0000
X-Rspamd-Queue-Id: 714C1140004
X-Stat-Signature: eonxftnm9ce8h68dseus7fhyx5ebktqs
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793376604-469341
X-HE-Meta: U2FsdGVkX1/cvhqKH9lqiV7OkwOZjF4oUCvEjzaZFUZYCtWvNFAN4uP4UMjhlhJsUdJusnncGzU1on8u67iExQgDani1BQD9O2hHkF4r/JKMCjMPDJY5PQt5oDrPYWaivG1XRUaGY7V5B6iGgpoxZOHmoAeymln+fnHpRLZfJ9fPkTVldQ3yfVm7vvAqTYbwX7ED8pu439nzMJFpax9thxZlniyKipyIcVJydY0QQvLfgaOzmBeurWPpKBcz1H+zx2PCS34k9ZiAHC8ljs4NWU3kJYrxwT7+82v7v1Y3BO3+s3vypNXWhCAjUiDjlUBpl2NGgNZoGDdOx/RX3QZ5rQmpxQJuuxDPCXJauteyYCFcZOcerFnwLR6R4nZI8i5B3XG2yBTkGoMUJvG7xBnMcv0TmKJ/nT/hynxupEtcKO9g9PlqYv6Z/Y2QukEWvkfz3amimfjqWibXQFxLwUy5CUWpaaENcljgIKoD8fjK09McQJ4PzV1Zwtzj7MwNceRLXkCHJzXLLbBCnpBEe4IHZgtnFixobBq2eoBCHFZ834rdjVwAjtX+wMJHPy3rOHeQDFVzQ4rxOlWx6Tz1QyDyBIpnUNCe8xxlD+xvqgOHQQAp+HVrGhslGliTCGUHKDf3QIATAQL9I3etoPOmSVfhfsQ4Au53N/VMfQ+XTRpjVwWQUnIeR295LMkjw6kITOHACecPjYfr5X+4arb5BF3fzELNMLOjZiUEXD27prtKm1mX0YJ2Pp7ovSRLrCD2oQ9FqMXIUqE2ZpBvOSRc4PqLS9pwSVNoZWP1u+OHfdqNCUkD+H6kkahZic3khrFF0IxSFK7UM+4RJh1ykY2Tv5pUhegpHb5BItYyRFzs21VAo0T2lw4KVwATePytggHWLElwm7Yu8US4/gFiGgtwgvMYxXdLnT3sgae3qhsTTe3AkCbMjmL0UBIkzlM0aamjmKZa+rMxmlTanBExkYV6zWR
 VmntM2l9
 1ddB4T4JuahatVYwhYmSvTXUQ2WT3zc/HOY4ihHA1jYqMQYZbLJtFuSG2hZ4C2yxHfsKmwIZfF6Kf+fcafeAqdLCC7wlKvAthhp4fqGKa5MhNIbjgprxpNJn9PXBdLr7hsixHboBAS+XygljF23XpEotOlOgqLwvZ5E0ponFpEc42xzj0AA54FJLAkFlRdXp7gG8O41g1P0g/+GjFtk4gyf6n2SsWMx1Q+0AwYSIvVu0YRVXd697c+ErGNHbZ3tatji200Fmkb8uw5TI4Lm7R1qblWUr8iFUwywWARhpRRcrIFSsbXULnD+HmvjJn+5L5mYyboHhYrgpS8kiLX3Q0RQlGVVEJ//ykKcn3J6bG1TYoaLU8bDkm+oZflh54w1HuuS+r8uRA2FgYHkFnXkzDmwQEImUnQ2+nZRFjMrAU3hVQYXOFCNxnZqGJv1aqgHdYR83xtiqCd/5IYYa+TrcfpubNkZ1X+eztV3YeLBNn30CG3kNOihgDijdqcbir4ZGJc1bdZ5VZL0vfMalc2lIgRWLJVyCttZN7nZ1zqsgcbQFsg3iXnxBYJ0FfH+6TBEcrzTETUBOTOAyx34BunJlIWDNpA9RH3dPZEF4a/h9VdGOHhSJeLnZE1NQy+L2ZbzyVcC+1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] ntfs: missing ntfs_emergency_state() check in ntfs_drop_big_inod=
e()
- [Medium] ntfs: ntfs_trim_prealloc() mutates MFT records in emergency RO s=
tate
--

commit f2f6f70fa52c8d2d01384c57dde6822ea706a5e3
Author: Christian Brauner <brauner@kernel.org>

ntfs: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on filesystem errors when mounted wi=
th
errors=3Dremount-ro with a new NV_EmergencyRO volume flag and an
ntfs_emergency_state() helper so that freezing and thawing the superblock
does not leave s_writers locked. It also adds an error_work work item to
persist the dirty volume flag and updates write paths to check
ntfs_emergency_state().

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index b2f5882d9990d..fbfbd94c60924 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -55,9 +55,14 @@
>  int ntfs_file_open(struct inode *vi, struct file *filp)
>  {
>  	struct ntfs_inode *ni =3D NTFS_I(vi);
> +	int err;
> =20
> -	if (NVolShutdown(ni->vol))
> -		return -EIO;
> +	if (filp->f_mode & FMODE_WRITE)
> +		err =3D ntfs_emergency_state(ni->vol);
> +	else
> +		err =3D NVolShutdown(ni->vol) ? -EIO : 0;
> +	if (err)
> +		return err;

[Severity: Medium]
Should ntfs_trim_prealloc() (called from ntfs_file_release() and
ntfs_stream_file_release()) also check ntfs_emergency_state(vol) before
rolling back preallocated blocks?

When small writes in ntfs_file_write_iter() -> ntfs_expand_for_write() leave
ni->allocated_size larger than ni->data_size using trailing LCN_HOLE runlist
entries, and the volume subsequently enters NV_EmergencyRO or NV_Shutdown,
closing the open file descriptor invokes:

  ntfs_file_release()
    ntfs_trim_prealloc()
      ntfs_rl_truncate_nolock()
      ntfs_attr_update_mapping_pairs_locked()

Because neither function checks ntfs_emergency_state(vol), closing the file
mutates the runlist and MFT record mapping pairs and dirties the MFT record
and VFS inode even though __ntfs_write_inode() and ntfs_mft_writepages() now
refuse writeback with -EROFS or -EIO.

If the trailing hole run spanned an extent MFT record,
__ntfs_attr_update_mapping_pairs() -> ntfs_attr_record_rm() removes the
attribute and $ATTRIBUTE_LIST entry and then calls ntfs_mft_record_free(),
which now fails with -EROFS due to the new ntfs_emergency_state(vol) check,
leaving the extent partially removed and triggering secondary ntfs_error()
messages.

[ ... ]

> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index 206db4e99ef13..6219aed945dfc 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -2434,7 +2434,11 @@ void ntfs_evict_big_inode(struct inode *vi)
> =20
>  	truncate_inode_pages_final(&vi->i_data);
> =20
> -	if (!vi->i_nlink) {
> +	/*
> +	 * After an error the freed mft record would go out right away while
> +	 * the rest of the deletion can't, leave the inode to chkdsk.
> +	 */
> +	if (!vi->i_nlink && !ntfs_emergency_state(ni->vol)) {
>  		if (!NInoAttr(ni)) {
>  			/* Never called with extent inodes */
>  			WARN_ON(ni->nr_extents =3D=3D -1);

[Severity: Medium]
Does ntfs_drop_big_inode() need the same !ntfs_emergency_state(ni->vol) gua=
rd
when truncating unlinked inodes with I_SYNC set?

In fs/ntfs/inode.c:ntfs_drop_big_inode():

	if (!inode_unhashed(inode) && inode_state_read_once(inode) & I_SYNC) {
		if (ni->type =3D=3D AT_DATA || ni->type =3D=3D AT_INDEX_ALLOCATION) {
			if (!inode->i_nlink) {
				...
				truncate_setsize(VFS_I(ni), 0);
				ntfs_truncate_vfs(VFS_I(ni), 0, 1);

If an unlinked inode is undergoing writeback with I_SYNC set in
ntfs_writepages() or __ntfs_write_inode() when an error triggers
ntfs_handle_error() and sets NV_EmergencyRO (or in commit "ntfs: use the
generic emergency read-only state", SB_STATE_EMERGENCY_RO), dropping the la=
st
inode reference via iput() while I_SYNC is still held enters
ntfs_drop_big_inode().

Without checking !ntfs_emergency_state(ni->vol), ntfs_drop_big_inode() still
calls ntfs_truncate_vfs() -> __ntfs_attr_truncate_vfs() ->
ntfs_non_resident_attr_shrink() -> ntfs_cluster_free(), which frees clusters
in $Bitmap, fails partway through extent removal when ntfs_mft_record_free()
returns -EROFS, and on mounts with NVolDiscard issues blkdev_issue_discard()
on the file's clusters even though the on-disk MFT record and bitmap updates
cannot be written back for chkdsk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D17

