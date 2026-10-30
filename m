Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6369E606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QI6bw7Wp
Received: by kanga.kvack.org (Postfix)
	id 5F8506B05BA; Fri, 30 Oct 2026 12:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582C46B05BB; Fri, 30 Oct 2026 12:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423506B05BC; Fri, 30 Oct 2026 12:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16C746B05BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:09:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 957CA120785
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:58 +0000 (UTC)
X-FDA: 85379778876.21.AE2755D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E23991C0009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QI6bw7Wp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fcm+hIfEyXj/1FIUdG0rmsM/tGutxaQ6UYWcc0TMcU8=;
	b=mckVeYuo/mLFnwOiU8Ye2EfQZqzlbYwrZD3f5cNvWIh9OLe8JW/IxrW8T9pCCHUsO69T4C
	rDcy7lRnvmmKihHZmELoeWbyCtuUXArFytbYdFhD61vPLO/qPUbvK6yhGD5Ois1VQXWJap
	2+NjHMeimY0FRhHfbFSdfoqZzvaAQrY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QI6bw7Wp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376597;
	b=DtN7asWqY/Obj/zkHQt9xJWgCUk54oSPs6DhMDdCaXYMmo3LIsdXTg4L/0GLwU5z3StjTr
	USZz2jIbM8eciOs/zKsZm+Kmn27b66+VMy02Z4kOcjd1xeg6gX2E+seToZg7wcvkMxusW+
	vA23vD+BgXFjc/lrjApQzsVqyqhDAUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39FDA43EAE;
	Fri, 30 Oct 2026 16:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF091F00A17;
	Fri, 30 Oct 2026 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376596;
	bh=Fcm+hIfEyXj/1FIUdG0rmsM/tGutxaQ6UYWcc0TMcU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QI6bw7Wpe0jvnRPZ/15BzNWtxNle/TBdjDueozdSB/u2+/+fN4EKSixohfH5HY8vF
	 hPc/925bZQTYTslO+O7V3sjaQP8Q4jnS47UWxyoQhVd3NuruyQmqu5PyHSYDWcmfVF
	 2r6pd4ob3QSIt8N/S0Ra/BZ8+RRVJk2wFTjqxvITxBIchJXK6FE66lWDShwdQqP0CN
	 lUBtcpSOBG+XvEynjhP6CpHYGeTlxDVG3rz9pVGpRy/D8t6rMhUhVLrDhyseFKXrbY
	 b0W63QZ0rPxzdHARLQo2Yxq7pucvv7/7vOOY68ITxchgMhLfPg+AWOiAcUjYzSEkWH
	 Rw2ljddrjlsEg==
Message-ID: <sashiko-outbox-191228@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/34] exfat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-9-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:55 +0000
X-Rspamd-Queue-Id: E23991C0009
X-Stat-Signature: bpdm53k81x7g8hbhq4odi6w91wrc665d
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793376596-398304
X-HE-Meta: U2FsdGVkX18lNu9U8Z1JleffXVJb7cSL6h06/+r9bwCi4sNGG4nBtWvSHVGRWJILr/y09dhieWLYsJy9diAugFKCLdk7GL23O2cIjmo54E2c5xHj9U2/U6X2j5IsDDRGPkPNS/58rhaFWl2zqg2EGMqIQws0Y+GHboUzEAk7IURxvi6yT2Ww8XPlYCla2gt5yd0C7IiabU9w12lsmIeVMJvBtpt+vMmE5DpIRIvMvn2vduTYV7nlxQebohxJIlXwYCxpu7F1oQk/iwMCOWndb9iP9IDeqRU1+aNeZtV6tZcK64NhnjiIuHESJYCni83QGycSwkZpGY3Da280p3gAh9KErnmQzvdP7qmhV7fFK6FwF10HNeiynFu+RhfjDZKpnfveW1PxtvpXc/725wNN5/aJQybXEIaY6yUCbmXPZ7xpYNN2Fh3UI/oxzC6gPswzDGfLQ7WzbwtUvcGjcjzFD3fdjbZw1UeAwayM437dLplJu9W6B15k8Xw1WjxiyCdqCTyEDi5z8Xzpb74jg5VWcN1L3GFUc+C+fVgLXPCfbb14PJScfXb7rYplcGk5x4f1oajcIYcZBkRMneAbHczbhfpwCBfsMRELnzvt6wPAHACaz1oLpsDr8oPM9UV3BbfZIeak3n1IZhRo59MdAVG0+OPpQTaqPZG7h2Crmj35HdiiufjCbCMVG4so/VFZWBUTvxm1uupXSKbaoSKl4hvbBzjpz7LVcPP7wY1Vc50XTehvLeUQGVRJ2JvmVACTtclO0UOKHbu+7VpXrUgqMK55FtsPyfvzgIcv3pLOi+T/Z68XspJF46s8sVUquBwr1VLxeV7P4G5ocJfa+nKDryARoD7sc2aEX/sQFm1TyBz2O4gnrr2CRv9tk+y2v6vt5vMlJ7iCc+jX42Gyzn3RFapCNEAC/+yvGADl9kMlJRBQ72JLVpFJGRjXPJ5Ux8CdPQf3vBaWbdxpe8CAC/MG5Y2
 PwKmWfnd
 kPjFDb0VdOwgn47PIBqs8+KQvhReWLfE8a6ExKWDKTbPzBtvGgNHzzcTnTNelvdqTkmPiyJMCfPeKNnBIPP1I0LP6j6jl+erp8kmMqVaJVKywUfYR4OtqGfuJp+7ym5KnlBIf5VnIS6XH28LUfj1TUc9ZuW4xgBAxhZdf+tlMFZ62i+dkVBI2/p1FUBSxC36xcrmei5P5H9SoTJNB/VgjuvCV8JsJKHsxga6G5EgVZR1c2nd+ZUpPeTTm6hFTBb2RsHF9A9pld1t8n2s+B6RjY0Bl4cudcolhXYU7TJwzkYjQpWfz+swFMRI8MRad0Qagdg6jeORrkJj05ySrhkzI6GhH/hEd2GxqaIJ0nb/6yb8Eq0ZQbiYZqisfDga4c+xhUWk3M0ruAFpZA1gMIyYsk/a4XR9ahOABzFxhMv1EOUqaHnoAr/4fWyzgudURimHDlduvyHoeLW79tz1Co+yQKz9h8JKxC2B45m3j7zuS+9plrBNbqCJj3MMeH/yBpn3Wb6VJJ27pI1e2gV88E+LI5YEC9qhorO417QgwTCN8XUUacVCE82+Q8db1DhRJR+2QchGrJF8IvPbehzSbALqpR06Fs3/KtaC8tRkTNtQvXqNWS9Zhd0d2BUfUuzI0OBv/lXZkTJGRovk8Iv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] exfat: __exfat_truncate() and exfat_evict_inode() modify fs in eme=
rgency RO
--

commit 17c10ac04b3dad50bb870e977d92e72ea9d3bcfd
Author: Christian Brauner <brauner@kernel.org>

exfat: don't set SB_RDONLY after filesystem errors

This commit introduces EXFAT_FLAGS_EMERGENCY_RO and exfat_emergency_state()=
 so
that filesystem errors after mount mark the filesystem emergency read-only
rather than setting SB_RDONLY without holding s_umount.

> diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
> index 5129df1e79b44..3f24e5bd3eb11 100644
> --- a/fs/exfat/inode.c
> +++ b/fs/exfat/inode.c
> @@ -114,8 +114,9 @@ int exfat_write_inode(struct inode *inode, struct wri=
teback_control *wbc)
>  {
>  	int ret;
> =20
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	ret =3D exfat_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> =20
>  	mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
>  	ret =3D __exfat_write_inode(inode, wbc->sync_mode =3D=3D WB_SYNC_ALL);

[Severity: High]
Should __exfat_truncate() or exfat_evict_inode() also check
exfat_emergency_state()?

When an unlinked file is closed (or during unmount) after a filesystem error
sets EXFAT_FLAGS_EMERGENCY_RO (or SB_STATE_EMERGENCY_RO in the follow-up
commit "exfat: use the generic emergency read-only state"),
exfat_evict_inode() calls __exfat_truncate():

fs/exfat/inode.c:exfat_evict_inode() {
	truncate_inode_pages_final(&inode->i_data);

	if (!inode->i_nlink) {
		i_size_write(inode, 0);
		mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
		__exfat_truncate(inode);
		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
	}
    ...
}

Similarly, if a write in exfat_file_write_iter() encounters a corrupted FAT
chain or cluster error that sets EXFAT_FLAGS_EMERGENCY_RO via
exfat_fs_error(), the error unwind in exfat_extend_valid_size() or
exfat_write_failed() calls exfat_truncate() -> __exfat_truncate().

Because __exfat_truncate() in fs/exfat/file.c calls __exfat_write_inode()
directly rather than exfat_write_inode(), it bypasses the
exfat_emergency_state() check above:

fs/exfat/file.c:__exfat_truncate() {
    ...
	if (__exfat_write_inode(inode, inode_needs_sync(inode)))
		return -EIO;

	/* cut off from the FAT chain */
	if (ei->flags =3D=3D ALLOC_FAT_CHAIN && last_clu !=3D EXFAT_FREE_CLUSTER &&
			last_clu !=3D EXFAT_EOF_CLUSTER) {
		if (exfat_ent_set(sb, last_clu, EXFAT_EOF_CLUSTER))
			return -EIO;
	}
    ...
	/* free the clusters */
	if (exfat_free_cluster(inode, &clu))
		return -EIO;
    ...
}

This modifies directory entries, FAT entries, and allocation bitmap buffers=
 via
exfat_free_cluster() -> __exfat_free_cluster() -> exfat_clear_bitmap() (whi=
ch
also writes synchronously when IS_DIRSYNC(inode) is set), and if mounted wi=
th
discard (which __exfat_fs_error() does not clear, unlike
exfat_force_shutdown()), issues block device discard requests via
exfat_discard_cluster() while walking a potentially corrupted cluster chain.
Furthermore, because SB_RDONLY is no longer set on error, sync_filesystem()=
 no
longer returns early at sb_rdonly(sb) and flushes those dirtied metadata
buffers to disk.

Can __exfat_truncate() and/or exfat_evict_inode() check
exfat_emergency_state() to prevent metadata modifications and discards after
the filesystem enters emergency read-only state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D9

