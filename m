Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F858606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jdzme6jD
Received: by kanga.kvack.org (Postfix)
	id A8D176B05B5; Sat, 21 Nov 2026 19:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64A36B05B6; Sat, 21 Nov 2026 19:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BED6B05B7; Sat, 21 Nov 2026 19:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43AC06B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:10:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC64EA067C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:56 +0000 (UTC)
X-FDA: 85460824512.10.5D03AC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5414780005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jdzme6jD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306255;
	b=TjuvOwIyq0ask/dBKkNpUJjp8y6Cr0oCe4OL1xNkMbr0wtIyrHEwhoTov/toB0zgfBj67r
	2lBdyi0FqH/mDDyTugPsQMghyFWMO1VurPA8i8nh+VVPLkUSVCZMmoh9YAm2exzGkPgqQg
	chUG9SWuBRcitp9biU9fDpAsOm4OlTA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306255;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iqb1sxGXVs+ZBL2YO1Gxpd58VvwV2+dlg9RG8sovwRk=;
	b=8IsVUKEhg37R9zReMDmHHgBqiMZkOqgGq0wdn5FxEsYT/9QT5hGfUuiEJRj8j3bY2HEAq6
	hPuRGutSf9Ju381jaadF/OHa7pyrQQo0S3gCKP4VW+nfFTx8Y+f+3hvsatd1G7N1WyubdH
	LAHMJP+lkoks2kS6IpsbBPdLHm3bPso=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jdzme6jD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6106F60F01;
	Sun, 22 Nov 2026 00:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A91F000C0;
	Sun, 22 Nov 2026 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306254;
	bh=Iqb1sxGXVs+ZBL2YO1Gxpd58VvwV2+dlg9RG8sovwRk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jdzme6jDlPEH9sXHNBaFkNO/jgmbvC1G2RSo97+cJNY67STD7lrt2j1TZm/bun4Qv
	 sCVAI5JtJ9kPPD2C4c6IOFkgIOSrQplvNb7vhkTwXldlDssVbaY4UImqvq8ysBamCH
	 oHxbnqxB49eL8sokvPPJlRl9qX2nk38biae/yynw9WPyOM+nBS2ii/J4RQqZjxVzji
	 wjPHBlUdt46uLlvpf+ruGWd0e8/3iXMuv6dXr6ENWr+PmA+QBPtZ96Z5r7pkdnj93s
	 ovP0x7nnHWgP+LSUqxzr+iej73HAjJEpro00U2O1yyU+LaV052sRgZrW9CBbC99t59
	 QqfW2Jv5S1/4g==
Message-ID: <sashiko-outbox-227537@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-3-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:52 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5414780005
X-Stat-Signature: j6yz6d4o1o9np69omiy1ticaery619be
X-HE-Tag: 1795306255-547013
X-HE-Meta: U2FsdGVkX19dMNatGaXnb8J1rfQFzF+VVB4D+SM5lTRuI8wAaGCzdwfpunr+h/aPqZlLjxJhoQ3gUJt6kNT5RYcN/2VmfaepOA4hfYRj3ErmKOeFUckLQ1WOY3+YfKmkKJ6nTT4541zFxklVG9UbWE/jDx+TlM/WbQROWudTjzXn0MjsDyTGKVOZbDwDRePUCDGN5c717zQbX3TtkImHxsHCmuFhE/Z/uw7sei0bWiH+wMVvpbgfhEUt/RcZxwO9dj8C7EuIaZ6BN+U7eY3IGAm6OILer4Rjk0AvgMxcdZenqaNtwWWJgbkiZndqGwr70r7J9eCnjM9ijSwPjZIATXS+w343HF5FMGQBjxqFFKO6tAmTjJGXxKwXs0Mgx/ME//Pq2GofVF0eJwNExjyJErRfnD60nHGgMofR+sTEHpjXbEaXAhJ5gKZm6yr952LNdZOCZ7QbR0hG1LXolI4zVQ/KDxMaUgP+bxaNxU5ht/YEGQVKclWKDpTzPinkj1Njh1NPcoNfKk7RLwr0p45EFUt74f/MlhszuciVpOVAm6weR1lGQKaxZ476tmZwyduDF9+o8lEdjIfYQGftxFPrrWtJF3Zvub98LLg32rgxmtoXulQFvdy/7mfmtqAKPFOt/MFm/VV2jzgdKf1ERPXmBzPhveWORUsFf7DBTSPUbwWHTlwRVefrV/j1JUR3GbqjiXheWbY8DnEyUgFUyf8/ceGUMchfWV8tSL+i67xGNsF7oCCI57H+aL59lHiC2r14zHgheWeDwXZwNVJdTn+ijnc0rnqHJf3XSwYTTPOToqTyXOYsMCnVwJckbrJdrlHatvg0+sCq/COH4IVKJm1amWtiQrXrLHhWh8rwXmDLosHdCR65xz9c+RI5xWEnqb63ezgDxnaXKuIfggFtVU9CvgQTVugtMV/yKjkN6jtpGoQARxNgV/fRbzfYlEyBrtrFxlkbl8a34J/wXYfJTZH
 4u8Zw08O
 kfbzv1BhmfYwbVZDOnUsM57X6qxPEk6roH3iG/Tb9pRomQ+NRFG5HhfyQ9WFNonr9Rnf3tvSUBOKERB3wgAFSIk0xBTHL189bmXy6jYJxIBqmxJN4FDv9CjGlXBTAzqPIPIrrorCknGh5jV4Vx/eASY52m0iv0k+rTN9B4btvf4HtuI3lYGX3bXzvV477bBA77YlZescxnz/2BZTINvlRVzSdw+2Khlo2E5lZa+ATnBvkaBmL71SdV6c5LSkSeAAyKSi+Uf3/t49HFBjbE3dgkx6xPir+OisMLDtQbRuTw21EliPkcM8pOkNEU8c9krGL/990jciCc8KTbISOzJ4HmhZE+pZieqbbWD9lzaS/DpqJP7h1r4XYRKqgBVWeI16PL3O/Bvue73xL1SOqYfo7A9BRZH7rESDNPG0+JPsxw4RToLvClpBTX7FztfVCWvgwGBVhv7ba4BWTpzbnpOSMaFud2o+79uPZQFsfZEh22knAVbbTe/d/wpH0IetqOJBF2BcWsvlyAv6UYw0ok1JfsHi572YspoHkqFnv7jPN9ulcdH+QPb4fdTW9HM2wwgSO0Yj33YsACTGwy/AtGyo+FwllxozUToMbyQ5vt9nVqKf2iKWpUod/Zy9LpfrTwSB02w9GzFczIhjiSqvGvdt6xuxz7XhfebkN/05bfQmH2ppL+cI7y6B1k5pbB2h1SoKWfSZDI3J1fpyvdrTibpOYtKutSzSHXUnxhqATxgy5PE0aP4s0GRgHcYJEnIauUoChpott7kYPOvgsGvZxjkn2EcxllwLhpWjbrMdh8LhZ7RoQ1Bc0Vh/Tczag88TgX+6zZNHCUjr9ZJoXWBZ1D3ksKF3Y4nzVNbm2+UrRQ+N3xLngfo0=
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
- [High] userns: missing target CAP_SYS_ADMIN and caller checks in
  sys_userns_set_idmap()
- [Medium] userns: unbounded size passed to copy_struct_from_user() in
  sys_userns_set_idmap()
- [Medium] userns: transient ns->flags mutation in
  sys_userns_set_idmap() before validation
--

commit cd58304550496b7580b53ae3de9d67b848eccae2
Author: Jarkko Sakkinen <jarkko@kernel.org>

userns: Add userns_set_idmap() system call

This commit introduces the userns_set_idmap() system call to atomically
configure setgroups policy and UID, GID, and project ID mappings directly
on a user namespace file descriptor.

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 6b9673dcdc670..d7f2cad388c8c 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> +static bool caller_idmap_permitted(struct user_namespace *ns, int cap_se=
tid,
> +				   const struct uid_gid_map *new_map)
> +{
> +	const struct cred *cred =3D current_cred();
> +
> +	if (cap_setid =3D=3D CAP_SETUID && idmap_maps_root(new_map)) {
> +		if (cred->user_ns =3D=3D ns) {
> +			if (!ns->parent_could_setfcap)
> +				return false;
> +		} else {
> +			if (!ns_capable(ns->parent, CAP_SETFCAP))
> +				return false;
> +		}
> +	}
> +
> +	if (new_map->nr_extents =3D=3D 1 && new_map->extent[0].count =3D=3D 1 &&
> +	    uid_eq(ns->owner, cred->euid)) {
> +		u32 id =3D new_map->extent[0].lower_first;
> +
> +		if (cap_setid =3D=3D CAP_SETUID) {
> +			kuid_t uid =3D make_kuid(ns->parent, id);
> +
> +			if (uid_eq(uid, cred->euid))
> +				return true;
> +		} else if (cap_setid =3D=3D CAP_SETGID) {
> +			kgid_t gid =3D make_kgid(ns->parent, id);
> +
> +			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
> +			    gid_eq(gid, cred->egid))
> +				return true;
> +		}
> +	}
> +
> +	if (!cap_valid(cap_setid))
> +		return true;
> +
> +	return ns_capable(ns->parent, cap_setid);
> +}

[ ... ]

> +SYSCALL_DEFINE4(userns_set_idmap, int, fd,
> +		const struct userns_idmap __user *, map,
> +		size_t, size, unsigned int, flags)
> +{

[ ... ]

> +	if (!map || size < USERNS_IDMAP_SIZE_VER0)
> +		return -EINVAL;
> +
> +	ret =3D copy_struct_from_user(&req, sizeof(req), map, size);
> +	if (ret)
> +		return ret;

[Severity: Medium]
Should sys_userns_set_idmap() reject size > PAGE_SIZE with -E2BIG before
calling copy_struct_from_user()?  When size exceeds sizeof(req),
copy_struct_from_user() calls check_zeroed_user() on the trailing bytes,
which scans the user range word-by-word inside user_read_access_begin()
without rescheduling or checking for pending signals.  An unprivileged
caller can pass a multi-gigabyte zero-filled mapping and stall a CPU in
the kernel.

> +
> +	if (!req.flags || (req.flags & ~USERNS_IDMAP_ALL_FLAGS))
> +		return -EINVAL;
> +	if (!(req.flags & USERNS_IDMAP_UID) &&
> +	    (req.nr_uid_extents || req.uid_extents))
> +		return -EINVAL;
> +	if (!(req.flags & USERNS_IDMAP_GID) &&
> +	    (req.nr_gid_extents || req.gid_extents))
> +		return -EINVAL;
> +	if (!(req.flags & USERNS_IDMAP_PROJID) &&
> +	    (req.nr_projid_extents || req.projid_extents))
> +		return -EINVAL;
> +
> +	if (!ns->parent)
> +		return -EPERM;
> +	if (current_user_ns() !=3D ns && current_user_ns() !=3D ns->parent)
> +		return -EPERM;
> +
> +	if (req.flags & (USERNS_IDMAP_UID | USERNS_IDMAP_GID |
> +			 USERNS_SETGROUPS_DENY)) {
> +		bool file_ok =3D (filp->f_cred->user_ns =3D=3D ns ||
> +				filp->f_cred->user_ns =3D=3D ns->parent) &&
> +			       file_ns_capable(filp, ns, CAP_SYS_ADMIN);
> +
> +		if (!ns_capable(ns, CAP_SYS_ADMIN) && !file_ok)
> +			return -EPERM;
> +	}

[Severity: High]
Does omitting USERNS_IDMAP_PROJID from this CAP_SYS_ADMIN check allow any
unprivileged process holding a read-only userns fd to write ns->projid_map?

For /proc/<pid>/projid_map, writing requires opening the procfs file
(mode 0644, owned by the target task) for write, so VFS permission checks
block unrelated users in ns->parent and unprivileged non-owner tasks inside
ns.  By contrast, nsfs files have mode 0444 and are always opened O_RDONLY,
and caller_idmap_permitted() returns true unconditionally when cap_setid is
-1.  As a result, an unprivileged task inside ns that dropped capabilities,
or an unrelated user in ns->parent that obtained an nsfs fd (for example via
NS_GET_USERNS), can call userns_set_idmap() with USERNS_IDMAP_PROJID and
lock in the write-once projid_map.

In addition, when file_ok is true on a delegated nsfs fd and the caller
lacks ns_capable(ns, CAP_SYS_ADMIN), neither USERNS_SETGROUPS_DENY nor
USERNS_IDMAP_PROJID verifies any privilege on current_cred() in ns->parent,
allowing an unprivileged recipient of a read-only userns fd to disable
setgroups(2) or configure projid_map on ns.

[ ... ]

> +	if (req.flags & USERNS_SETGROUPS_DENY)
> +		ns->flags &=3D ~USERNS_SETGROUPS_ALLOWED;
> +
> +	if (req.flags & USERNS_IDMAP_UID) {
> +		ret =3D prepare_caller_idmap(ns, CAP_SETUID, &new_uid,
> +					   &ns->parent->uid_map);
> +		if (ret < 0)
> +			goto out_restore;
> +	}
> +	if (req.flags & USERNS_IDMAP_GID) {
> +		ret =3D prepare_caller_idmap(ns, CAP_SETGID, &new_gid,
> +					   &ns->parent->gid_map);
> +		if (ret < 0)
> +			goto out_restore;
> +	}
> +	if (req.flags & USERNS_IDMAP_PROJID) {
> +		ret =3D prepare_caller_idmap(ns, -1, &new_projid,
> +					   &ns->parent->projid_map);
> +		if (ret < 0)
> +			goto out_restore;
> +	}
> +
> +	if (req.flags & USERNS_IDMAP_UID)
> +		commit_new_idmap(&ns->uid_map, &new_uid);
> +	if (req.flags & USERNS_IDMAP_GID)
> +		commit_new_idmap(&ns->gid_map, &new_gid);
> +	if (req.flags & USERNS_IDMAP_PROJID)
> +		commit_new_idmap(&ns->projid_map, &new_projid);
> +
> +	mutex_unlock(&userns_state_mutex);
> +	return 0;
> +
> +out_restore:
> +	ns->flags =3D old_flags;

[Severity: Medium]
Can clearing USERNS_SETGROUPS_ALLOWED in ns->flags before
prepare_caller_idmap() expose a transient "deny" state to concurrent
readers if preparation fails?

proc_setgroups_show() reads READ_ONCE(ns->flags) without holding
userns_state_mutex:

kernel/user_namespace.c:proc_setgroups_show() {
	struct user_namespace *ns =3D seq->private;
	unsigned long userns_flags =3D READ_ONCE(ns->flags);

	seq_printf(seq, "%s\n",
		   (userns_flags & USERNS_SETGROUPS_ALLOWED) ?
		   "allow" : "deny");
	return 0;
}

While prepare_caller_idmap() needs USERNS_SETGROUPS_ALLOWED cleared when
checking an unprivileged caller's GID mapping, mutating ns->flags in place
and restoring old_flags on failure lets a concurrent reader of
/proc/<pid>/setgroups observe "deny" before it reverts to "allow". Could
caller_idmap_permitted() check the effective flags value and leave the
update to ns->flags until the commit phase after all prepare_caller_idmap()
calls succeed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D2

