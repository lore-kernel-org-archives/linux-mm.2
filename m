Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D993606A335
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f69SiW3T
Received: by kanga.kvack.org (Postfix)
	id B607D6B05BB; Sat, 14 Nov 2026 07:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAC36B05BC; Sat, 14 Nov 2026 07:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D0A6B05BD; Sat, 14 Nov 2026 07:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6060E6B05BB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA3A71403D8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:42 +0000 (UTC)
X-FDA: 85433590284.23.5E76D61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1941E40008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f69SiW3T;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657821;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/KYa3UJ+vAFbs7NcbhfOHJmaPLTvaBxJddS/GfOWco=;
	b=CBeBY0XstBOCPl0aw14y3yhP6gmSVxXGGzWzIXeLV8WMv1VTbrYsJhZAwBN1qE95LRZtbi
	Ot21qVkFOqrO4RhYQqlwnFjIv/DL7xHtbNDRiDvkGuiVcn06iJ1WGkfglY+/if0fQjUoUA
	T6WdBMGMl1Lovu1ivfF6MNpQmIQv9fE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657821;
	b=HocKft/8q/Vxibf8ETkdX7ThObcKhECsX/9+wZDNrcNMlZfWieneom55E788MUaAmjTx9v
	JndaCcCh80zARjVAttP2bmnuwlICkallNnm6M1dboNkalB4qRsNyKjVyEqfnDvHOnY3Olg
	5wpcQ4bi614G9LHRm4K3JPfVRGBlorA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f69SiW3T;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9FA761E34;
	Sat, 14 Nov 2026 12:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAFA1F000C5;
	Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657820;
	bh=i/KYa3UJ+vAFbs7NcbhfOHJmaPLTvaBxJddS/GfOWco=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f69SiW3T4Q7A6/VsOz19IJcDTbc2284jaDxgfyilDNG1Mci6VQQ0XsUIBzmCI2qyW
	 jBaCIXM0+pGMbZU6+HsTbwcuLPsb2hzKKEbMRuKK4DOQw/dU5Ns9uMCz52Jnzj9tF5
	 AXH/9yDypM1F5LtJdPmEAkLH4UA7aJwzK9MLeRyuesvkSJjk6XuJlznUHMW2Vc4Awm
	 BtcYalXD+cdcCtN0E28SgqskmS21t/xSbEIhlpoLv2451rm/ZPCa/BhesuHFKDJLNb
	 sT27WrI12rYRWzsaabg7n85XlDTqlHu6y6vW8o/+iQEOAYtkvM/L4JnWcrRwRiTkYU
	 9J1nIjwgbU3lA==
Message-ID: <sashiko-outbox-214470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/33] ntfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Hyunchul
 Lee" <hyc.lee@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-19-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-19-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:39 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: d39yots3acuzesz4h3bsam1q6mmawnw1
X-Rspamd-Queue-Id: 1941E40008
X-Rspam-User: 
X-HE-Tag: 1794657820-443761
X-HE-Meta: U2FsdGVkX18K3udy0dQSBHCWx1TfykbK6euNqBMJcDiWTlFBiqXv66y1+oNmGjw8PT5ANRlpeWQVWlp7KcpCNaOO+3QefGS2i6corN8DVnCup86o69T9/LrsDb9cbGWxhgTU6O7jfi10TeV+Z+16tGZeVz/7/z27NT59mkLnK3hhkD/BNGh39HKoGUd0cIqcHh/aHaoKAhTVLwepFBI2rxbhcSyRf/xLs9Xxw+zjFyUiSvNz9gFOWN0nJUweUV6y2LaM3UTpzWf3ymp7pqVH73ZxnAO8qJr39Z71YLNVC2IDM9QbP680wvi1co5sYaSG/81zGNLT1Vhu1ohlEiVyeyCHTCEQhv7kkYXPv4V2w39QbgUaLMYmAOzuwmpRFjFACZoGdxHR5p/043N/hAnUHJdrz23x3C9MFvDJpjcHSp8W9+0ERsCbkb6VqxAI/VncbGi5Vlv2p48+Qe40bCK6qAE1AK3JE0UyTGo3mrEfpYP8CIQJaonVEFHj3hxOizO/dgARuZdIuUoIDWp/BdsNQQbEZOGstEdRa0K2aOO5uJU/va+PXX5rXgCT+ySlLRLhklGWSiW4BpD8d4iEU5T2CfDPOeIHxWwxW9RMOM5Q/dDc4y8E+qjdzYiuK6FSLIoNzKCbgZT0JyelWMqqShgeWiGpxAc/GLhSW+aIwm2bEnKUiuQQhffq7ZEDck43B9cDPoh9CUzJq8cPe1qNjvd6NaYPTNAO7ri2ArJdqLTBhTTtMeU/wXbCYnMJ7F3ZeE0uwmjp+ge2QYCEX0uBrZN4U91Od7WE4mjzBL71+8qWg/s4O9w8b3zZPiJsuswuNNGyy6otEtVhdyHNcWOv8kdKLfIVviRspXXFdGSXsmcmmqP6F2WzgkPVHwBuqlqQ0cYDL90LMjHot6tNBI+3y8wcIt7G5YTPAZSRtAk4zXC87faL+FNU1YtA0YXhO8MURcseYOeqeNn8BAPQMJnLJDK
 9y0AZIrP
 1h+ilAdt76LlvMerxerAFdakHvPJYq64Tnbel0SG6ERbBHxcjxxHwVRjV4cQpl7n4XPxzMi7Wi+LqrHN5hIJRnL8Fx5aEO27tgSUtxUg2j9zr3ZjXO5rlXz/NvpCJ1vJfI2n/6I45YzE1bCZiPbTLacs36B1JUu3lQg3ylsb+jhzgy9Shz9AVFkW0gS9m/zPxr59D2UbCV9ZE2pj48jk0n9KCRkebz5jWiykOEOmk+d2f1MZiacMhHjIgskyx1I4iK9u1Q2GCjZkeESldvMNOG6xXjF/HLiXpTFTsNLD2F3rtnEi3T6OB/UU/TqQa/IJ0/SpahEp2wXd/xq7Bg20RmRflEn64uboPpQFykitVrKUlHGte0VYEpPcdHalWmQGBnY2AqpYQcVCWnoFUoczWJon8bA5wwf/kmIajU93C7b8RkU8fk6Z5yMtb4p1O3qd+jmjwigA7U+JiIOmTJWIxQ31PvEWWMb4sQbC9il+BCvCmVnxKofro7h7vQog3gUJw5Jzby2//Xv77W5oY+DrBP+mYfPsRYBkc8WzX6duRMxyYr4XLbx3KIYIrtU95hcMlWYAVvrSUvX5xT93BbcA+SDynI+sqLtQcW7cSzbnxLVzl+qUZPIlQUlcJm2Abb/1ieJeC3foXhWlFQ/6DLrmIg+4/lSpwL11+mdcOtPCShRaqTCyyt26E49FGnL8r1JH+usOjSea7GT4utkU4rwpffAYy+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ntfs: unlocked sb->s_flags RMW in ntfs_handle_error() via
  precalc_work
--

commit 41f5366b5799dc9babb537d585f77ff9063831e1
Author: Christian Brauner <brauner@kernel.org>

ntfs: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on runtime filesystem errors under
errors=3Dremount-ro with an NV_EmergencyRO volume flag and an asynchronous
work item to persist the volume dirty bit.

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 71f0aea46bf8f..91290688d2898 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
[ ... ]
> @@ -434,7 +436,21 @@ void ntfs_handle_error(struct super_block *sb)
>  		return;
> =20
>  	if (vol->on_errors =3D=3D ON_ERRORS_REMOUNT_RO) {
> -		sb->s_flags |=3D SB_RDONLY;
> +		if (!(sb->s_flags & SB_BORN)) {
> +			/* Before SB_BORN the mounter holds s_umount. */
> +			sb->s_flags |=3D SB_RDONLY;
> +		} else {

[Severity: Medium]
Can precalc_free_clusters() reach this branch on a kworker thread before
SB_BORN is set, racing on sb->s_flags without holding s_umount?

ntfs_fill_super() queues vol->precalc_work before returning to
get_tree_bdev_flags() and vfs_get_tree():

CPU0 (mounter)                    CPU1 (kworker)
vfs_get_tree()
  get_tree_bdev_flags()
    ntfs_fill_super()
      queue_work(..., &vol->precalc_work)
                                  precalc_free_clusters()
                                    get_nr_free_clusters()
                                      ...
                                        ntfs_error()
                                          ntfs_handle_error()
                                            /* !(sb->s_flags & SB_BORN) */
  super_wake(sb, SB_BORN)                   sb->s_flags |=3D SB_RDONLY;
    smp_store_release(&sb->s_flags,           <-- unlocked RMW race
                      sb->s_flags | SB_BORN);

During mount, load_system_files() does not populate the runlist for
$Bitmap, so get_nr_free_clusters() decompresses $Bitmap's mapping pairs on
the workqueue and calls ntfs_error() if reading or decompressing fails.

Because neither side updates sb->s_flags atomically and the kworker does
not hold s_umount, the RMW in ntfs_handle_error() can overwrite SB_BORN
(leaving later super_lock() callers hung waiting for SB_BORN) or lose
SB_RDONLY.  Taking the !SB_BORN branch from the workqueue also skips
NVolSetErrors(vol) and NV_EmergencyRO, allowing a subsequent remount,rw in
ntfs_reconfigure() to succeed despite the error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D19

