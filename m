Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D34B606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lZj6wVhW
Received: by kanga.kvack.org (Postfix)
	id 464806B0600; Tue, 27 Oct 2026 16:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C8E6B08E3; Tue, 27 Oct 2026 16:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351AB6B08E5; Tue, 27 Oct 2026 16:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148616B0600
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:56:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F76DA82C4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:56:12 +0000 (UTC)
X-FDA: 85369613784.03.DA125EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE13A180005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:56:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZj6wVhW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793134571;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2I/Cz4c0h3f05oU2Q88wcZme8Hf1HGyDMK3PPMKwZoc=;
	b=ghlzrTWTL0/M2VWccvXHTn9jAUEWt3dyuMZrAW4OFy5RnLZ023QjJbWSXNLxUxK7tMF6rW
	ySBf7cpvTunA+EAIfhzIUb0Cb4IvSPIKSyGbAMmg3T69XULZvNr8lgmSMTIg4Mmsoi0yT2
	pBPie5XcMRkXbyd1SwY7U6yWTNXSYNw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZj6wVhW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793134571;
	b=P6u06Ve7HeKa/edzH2Bznb5p8Zw2G1uSc3rmzJREV9A8+hrlZhyeXbn5z8+755M2rvMeJ1
	efS48maGmSG4pmZR9/5kCBnVirJ3UbjBBmtxQ4MoDSVW2XVHLnMk5iRU5sBOcK2cOkxxjq
	+eXttLVrIMVPw9HoOE15rorj4vk2jAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31C7F41AE1;
	Tue, 27 Oct 2026 20:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939171F01825;
	Tue, 27 Oct 2026 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793134570;
	bh=2I/Cz4c0h3f05oU2Q88wcZme8Hf1HGyDMK3PPMKwZoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lZj6wVhWhP5E6SNnM3ftru2tCg9u/MjJRM3lVypc8QyWb/ZjJY0eSsULHJGe9DqNf
	 DiMvml5jA8gMJPMw9qLNbL5ENcN9lJvw5z7QvN7Os1IDMyROXIoJ4qJRf2TK+H8tZC
	 0E3o6STdvEwBEdyhh3YDhf4wyLDYQvZxwgTfeQLCM/s89wziSTvkWigBz9lI7FQrxG
	 3SSgn8/rNsAr5Ca1S6J9v8W/O464M2eJKxeO9AnahIbDEL1M1svmwyRisn85uVF/vp
	 PrJ+9zCUHU6t0PgdRyavj0gOcdm06nCgoZwZ/XPMrvdXPTA3pSok8srBCDJrY8uA48
	 CZGAYOvWCuNlw==
Message-ID: <sashiko-outbox-187105@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] hugetlbfs: enforce F_SEAL_EXEC on chmod
Reply-To: sashiko-reviews@lists.linux.dev
To: "Samiullah Khawaja" <skhawaja@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>
Cc: "David Hildenbrand" <david@kernel.org>, "Jeff Xu" <jeffxu@google.com>, "Daniel
 Verkamp" <dverkamp@chromium.org>, "David Matlack" <dmatlack@google.com>, "Pasha
 Tatashin" <tatashin@google.com>, linux-mm@kvack.org
In-Reply-To: <20261026205555.2918396-1-skhawaja@google.com>
References: <20261026205555.2918396-1-skhawaja@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 20:56:09 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE13A180005
X-Stat-Signature: hw6kaawpp143mj3ag4s4tjbq11n7cqy6
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793134570-732778
X-HE-Meta: U2FsdGVkX19g+2UMdNnQot/6vF0tt+pdKvi/YIucqw7+nmTbKOA/PR77zg1qqbzzChMLNxyJNkW9ZomL5ORpOcMaPsnUI9vVKGow9Is9L+pcnBj6ZsugLAdpAI4WZw/URXigZx2dESVay0Yhn+YoC5uRuORdMDzTGBiT2Bjo4/TyO/NMFzYcIE9kOSRqFnsLlHd69SHNGReZMd9BJwmS/BRA4pIV81ml/7PIpr0dTqReYoWHZGXdvruPaL0SnkUPAXXCzAoAJa8QsLSITs07hpnYg7vFKHc5lq94tWs9RaXQR/0maQBPhoIdZWLGRAWe5PKMkgUjhS6Ag2+VjZftE03H3OWb8B1yUwlWak5SeY+8mx2RK7s+B096PSv+qjh4r4dRN99Z2L37ohpI6Rxk9p/HX8zNTaKVY7Z0/xKfqsOwG8agJyGxk3P2MNg/EMWnw9XdKW2yrme+gWERu/RN0V31G5GgPjNPpM5vkriQxeZVxVkN8/9jHRYASw4qfah0A2BprOAejlBBXQ3jJQSjRCSRdclx741jCRLs6ACf5KuJkc4o3cMDDFYYSjs1WfbYkYGDTglLGhrsnIG7qbrFM1+00/DMw9h/gFevqfxZMEnETyvMHJQD/lXnaO7gJKXJtSkngM2IMv21iGszDHaEVJTEefaop4qX6i5TBAWJO3jWRS6gf2L6CdA7k3D6RMK1cJ+nV64e/9KLKJkcaY7I7kwM7nEOChzODhMQ33QcOSbJjPvkM7Lr9aNC00gXBl9/Z2/W03bN87PikThAGVPquJNHZ+DCw4+RfXmSd6Hofrh4LwSYBjjpeNvQhC3BmuMTCfeorBwO4zkqYuF8rWoDud4yphU85zlrlHXSnXhMYynb+Xz8oPqo+rb6vn9XxaIpS9fKVDy3GLsDl43qBOyIS8aHIkKVHczPWYtL3/Yd6GUYH7pfiwBjB5EQ9EZqVF8MMj44aiv7IoTP5V6MPeM
 E5z3zvwN
 qX/dNOGBnVVeLPB4p73j5745II6QnN7BuA4blPHD/Tagp3nrf3zXX7dGG8Ba/h94vYCrw3QtbbQx2gWf6jFb3B/+t4Ttx3HXTTg/bM1T0EMYHfhCxmmb5c9QqFRhySNl1uYCVvWNIpFOSX5py7M+DkzZ1i71S2yd7OwSIfmW3MohQO++92fPKK3NyJlPW/8Ohngiv2DPUGluOu08Zg/rY6i//R+Wma8YaeX+mEEFz2M3/TVhSE06kBTcDYpZvgiWpxQ/oMYPxk7oQopJXl80s5QiaFRpsUjDKBd2BkFVWWGPOpC9zqMjasatArmLTmNV9WsfV1gxrYkdkj37SsVL9f+vQLxB01ID5J8m88+khoCuwgP4ta9CNmTj6/ucqVjL8B2p6mhsaYnxK4MAv0EHS62USFfC4Qw7Bbz1cMLVzUXRXWIBmA5Fh77pX2kuGcOQ3YKOlgQQQkumOBdJ8RuEuc2isoAOFM5yZzQwQzPJib2lRs1SGnnL6vtAia/2Kegzy95E0da+zSfMLX9Hew01yinSISqcVg4G4Qtz+GGNbD6YT00zH9IcvUm2OVC1+PPulxjN4J0yjOB86is4l6wr3QCatFohMTMriTCGDUryE7sI20Rf9CWCPhMVPb6BwhCFkosBd
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
- [High] hugetlbfs: uninitialized info->seals read in hugetlbfs_setattr() o=
n root dir
--

commit 42d3d553628462e4f19c0be00708f922ba1aa705
Author: Samiullah Khawaja <skhawaja@google.com>

hugetlbfs: enforce F_SEAL_EXEC on chmod

This commit adds a check for F_SEAL_EXEC to hugetlbfs_setattr() so that mode
changes modifying execute bits on sealed hugetlbfs memfds fail with -EPERM.

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe0..56e0588d295d9 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -842,6 +842,10 @@ static int hugetlbfs_setattr(const struct mnt_idmap =
*idmap,
> =20
>  	trace_hugetlbfs_setattr(inode, dentry, attr);
> =20
> +	if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE) &&
> +	    ((inode->i_mode ^ attr->ia_mode) & 0111))
> +		return -EPERM;

[Severity: High]
Could this read uninitialized memory from info->seals when setattr is called
on a hugetlbfs mount root directory?

hugetlbfs_setattr() is also used as the .setattr callback in
hugetlbfs_dir_inode_operations. While inodes created via
hugetlbfs_get_inode() initialize info->seals to F_SEAL_SEAL, the root
directory inode allocated in hugetlbfs_get_root() does not initialize seals:

fs/hugetlbfs/inode.c:hugetlbfs_get_root() {
	inode =3D new_inode(sb);
	if (inode) {
		inode->i_ino =3D get_next_ino();
		inode->i_mode =3D S_IFDIR | ctx->mode;
		inode->i_uid =3D ctx->uid;
		inode->i_gid =3D ctx->gid;
		simple_inode_init_ts(inode);
		inode->i_op =3D &hugetlbfs_dir_inode_operations;
		inode->i_fop =3D &simple_dir_operations;
		HUGETLBFS_I(inode)->resv_map =3D NULL;
...
}

Because new_inode() -> hugetlbfs_alloc_inode() allocates from
hugetlbfs_inode_cachep without __GFP_ZERO, and the slab constructor
init_once() only calls inode_init_once(&ei->vfs_inode), HUGETLBFS_I(inode)-=
>seals
is left uninitialized on fresh slab allocations and retains stale values wh=
en
a slab object is recycled from a previously closed hugetlbfs memfd.

Previously, hugetlbfs_setattr() only checked info->seals inside the
ATTR_SIZE block, which was unreachable for directories. With this check pla=
ced
outside ATTR_SIZE, any chmod, chown, or utimensat on the root directory of a
hugetlbfs mount reads uninitialized or stale info->seals, and chmod changing
any 0111 bit on the root directory can spuriously fail with -EPERM if the
slab object previously belonged to a memfd with F_SEAL_EXEC set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026205555.2918=
396-1-skhawaja@google.com?part=3D1

