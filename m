Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62CE606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QpDPTYxN
Received: by kanga.kvack.org (Postfix)
	id ED2E76B05B7; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C566B05B8; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D982F6B05B9; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A771C6B05B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2D8912061A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
X-FDA: 85460824638.26.9C0A77E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 54F811C000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpDPTYxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306258;
	b=KcPpn+h4Fnjb0vet1y1QGXWg8mVXGyJLwN7eohSXEsnDtX0PAe6z8Ds1/g1Qug3M4gM/jc
	lrtvJMzfw4DMYrlVs/eZXrD1afCe0tlFX2xo91wuEjap9tNK2QczL/S1q/XTwZuhbeqabK
	UXwc8jL/hJM4Ms2FusLY0LlIIcg1HJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306258;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbgxOiqmmBi3yewFZr5b+07XHs7HwSgwp25qc8+WQwE=;
	b=qlTwDlnxvfVaZsRd7VpXCr5sle83PVg4uC2eHqGBoM1JrjgRTvsiO+vouWvDuW0FJx+4YU
	HnPdRmdLLYivJdFAkLMNnU3x/6ZqdxBrLDaf9BSPUEKCWMWu9YIcACaDk3PFqHJ7VYRkTv
	snSzuciCMLHQfPsZ8TSELlbTelmmaCE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpDPTYxN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEEF661DF2;
	Sun, 22 Nov 2026 00:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0326C1F000C6;
	Sun, 22 Nov 2026 00:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306257;
	bh=EbgxOiqmmBi3yewFZr5b+07XHs7HwSgwp25qc8+WQwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QpDPTYxNZ0dyL/3bfX9WdEbiawhUbKYzJu4rS35Zu+XQDdfqJAA8ZWLVlNTgXMLic
	 dAoFwzVzgB+nU85nwnqGUjJzzt+bMcqtGmclTeXZAG0iB2X0jP6MgI1fH3sOhdjp5P
	 E4PoLpxAeJMrUg2b4EeGjg1QOBDjtTuJ/jFhqtFwBvneDDcYODTv3CqJ1s73i4rrGM
	 k4aac75BzIshiZN6V7ViWC7oZNg6oatS+/1CoiVfDG0TjyT7DR20UhK88JpKo+l/1b
	 nT1bnDgGVecQYzfvg50xZFFjpuzfMj2f7e8jRpmMcBerZtUjQA6sEHcXO/ETFgs5NM
	 QwidqMAjJDvgQ==
Message-ID: <sashiko-outbox-227542@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 07/25] mount: Support MOVE_MOUNT_CLONE with
 MOVE_MOUNT_T_MNTNS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-8-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-8-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:56 +0000
X-Stat-Signature: 7yukodp8anfqmuzy7o34zpggoy6wyrax
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54F811C000A
X-HE-Tag: 1795306258-669407
X-HE-Meta: U2FsdGVkX1/m+QeAactPNnvDKG9GJqVwpyN/7JNAejzyCBSrOc/KPfAVjG649+EfEc6w1RKHGyMHPA6T54N2xYx5gwWpPSHm5JamlYKmjRGj/L/Jih+of4ckR7pNpK3sN5qSi++wa9mjJbwUGQmysl9/Laomc16HjjJZTPzr2kh3J7KbPAbVuyujYEjrQLgRqw39ykulyAJniWD/3fbyGx/61I0yQY2R9oygStAOQEFEjVNHxBiTsjawVEUCokbSfPWJ/5sqSAPSGqDQMdqKbo57NGLIBxc6cxwGMet1OpXkmh52enZ+pLOBmkwgZJXR5lIlNy5Wa2B7qHLTIaQbVehudHt5UDQlidyKRM/zyN542kQEhMMP0IkcLg57DjetCAGz1MX4yg0nHMktxyc9B2mUklTfaof+dzR2Aqxk8tWLZ0Ck1/buLP4uMXV3OGy8ctSqEe7Su5o92Y36/QG2eyG7Sqor2cqxuQJjq9vnpc+HwJthyRNT4I2JDmFzBd1n4lBiiRUZdLUjAqTH+nQHAnOasV2WWJ4IIGhGvc1Nls8U3UhpGBAisxz1F4Fm6kXZDSDbbRcIiWsQHgLgGAe4PENeC9EZoZxfk8fXZOsybKT91bYhuJBovdZidvc7vz/6fFMfUHJylTPvXsuFFxXak19EGwDC+5Ai4mrpdHD2lZsQbbr5ngFqM7RIKjK3aN2bmSInvQzacB6sZnK65Xd3TpRZyojiVUsCJygo56Ac6oh5dbweDhuA+GDbTtMu58YCcf38lw23fFqQOLHGm05xTz+5UNPj9jKF+uYRJ4rwfI9UpKx6XSyKv9GpcZhalT8u+gDXjNKxMps1T+MszWnskTuakY4l4/KGZYxxqvtqST4+K8JPtD4yO2xJOFK0S43Tgd5DhvZZuXHwzSANmBhW39mGCdWVkE//FPEAmQGEgDMZkahYX0aHCrJ4FNVLDTktd/KrlKl1aaHJMOSLVJL
 k22d6wBr
 L1ODJnIKP1RulPM0YVRITUQ+cawcvY6hSHcWhnc9Im8+WYgW78Ujgfb+7j2ucVKIJMfgmxUy3RARXGO71yLyBMTx/rQDlmCwhjnQW5xj97LQoVui2TpYq72dZ1iDPYZ7E28YCyd4lzPYWu4nepDf1ng7vJhzcWiZaQWlwDyqBTjpyFg9yXKg+TFmDJXX168x0SUwfeqE9boKmDWB9xJP6pQ99Z7GeQF/oqJhOjYTsKCCnLjRjxN39hUayw0xvYtAe/ehaI2r8C4AL47uv9BO/FqqwUEoAw6RYegf1OJOXQdtowantuMRYz0HuSMPiiIaXEalv0blCtpTxFmtHe8dott/gE2ObLd+CPGVJV1RsxQimDskuZNWUeETPRqmZAOPOhn3XYPUPK+jPxEjzXXdIJRsJhesbcMEVJDGFH+2PNbBU6CHrjl1oeDiHIRdlzG2axfpKa1/ddrvVtWG1219yR5NhLrqPe75JBuogmg5cMh2Dn5TATZLJo5JJxn0zwe0icFCp365rg8mXz3hDiB1CuSwaihBUlunR3yFTMRkPehxfnAE2X2mF0KD4k3e0RWPxbcywKIwEexr79c3P2iDCdLZLIeqioeR7iUG528uJbscjPWMBWUD+21H3gHxTEqvGpTb5LPJogy3QGsiM3SSDbygcPZYSSZjFH+OSvTZhrmJ7E0BjFpE8qOAPzSUFMU3WPb69zEeMnaArr91a7+7J4V2G7hoCOUE6RrMLEBm4gEQrMMufY+u421nHnGYMI6G1tQCdt0YSn4R7lfk4TU4MgPr8Fq5ySnnQqd2gDAWq7r+iFitpo9M/YBcibCc6vEttT7UyVNeV474Tglyxw4XmKqcMFJVuyPadasHm9qCLXy5fScU=
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
- [Medium] mount: missing SB_NOUSER check in do_move_mount() for
  MOVE_MOUNT_CLONE
--

commit 0d056169d39e8a161d1951b83a6a28ab91fbc2ea
Author: Jarkko Sakkinen <jarkko@kernel.org>

mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS

This commit adds MOVE_MOUNT_CLONE for use with MOVE_MOUNT_T_MNTNS so
move_mount() can recursively loopback-clone a path from the caller's mount
namespace directly into a target mount namespace file descriptor.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index b65f1fdd92811..1e7d776c09660 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> @@ -3835,6 +3833,35 @@ static int do_move_mount(const struct path *old_pa=
th,
>  			if (m =3D=3D target_mnt_ns->root)
>  				return beneath ? -EINVAL : -EBUSY;
>  		}
> +		if (flags & MNT_TREE_CLONE) {
> +			unsigned int copy_flags;
> +
> +			if (!check_mnt(old) || old->mnt_ns =3D=3D target_mnt_ns)
> +				return -EINVAL;
> +			src_user_ns =3D old->mnt_ns->user_ns;
> +			copy_flags =3D (target_mnt_ns->user_ns !=3D src_user_ns) ?
> +				     (CL_SLAVE | CL_COPY_UNBINDABLE) :
> +				     CL_COPY_MNT_NS_FILE;
> +			cloned =3D __do_loopback(old_path, true, copy_flags);
> +			if (IS_ERR(cloned))
> +				return PTR_ERR(cloned);
> +			old =3D cloned;
> +			if (d_is_symlink(old->mnt.mnt_root)) {
> +				err =3D -EINVAL;
> +				goto out_cloned;
> +			}

[Severity: Medium]
Does this allow cloning and attaching an SB_NOUSER mount such as the
caller's base nullfs mount?

do_loopback() pairs __do_loopback() with graft_tree(), which rejects
SB_NOUSER mounts, and the non-cloning check_mnt(old) branch below rejects
!mnt_has_parent(old).  Here __do_loopback() is followed directly by
attach_recursive_mnt().  If old_path resolves to a mount namespace's base
nullfs mount (for example via an O_PATH fd or a pre-init root) and is
cloned onto "/" of an empty target_mnt_ns, a second nullfs mount is
attached on top of target_mnt_ns->root, causing mnt_ns_get_root() to treat
it as a live root filesystem and permanently blocking subsequent rootfs
installation on target_mnt_ns with -EBUSY.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D7

