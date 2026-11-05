Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01273606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAbXpW5G
Received: by kanga.kvack.org (Postfix)
	id B8F4B6B05BA; Thu,  5 Nov 2026 06:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B668B6B05BB; Thu,  5 Nov 2026 06:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D4A6B05BC; Thu,  5 Nov 2026 06:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C636B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09CB31409AF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:08 +0000 (UTC)
X-FDA: 85400801136.02.3E7CED6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C0AAC0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAbXpW5G;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877126;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6Btm3+v+dnXqWTR2GX+hsLiVMvVrLHj5mxZiRv+uQA=;
	b=Rs5ylRS4qhLxJjgOzaA5AFBAltcOm+ig2bHaAEZOCWX1e3iCoOQZrrIXvxXllZNa8iGHZb
	j9CIDm7NSvcHaAufvE/UaGn39XU816MrGTOeNvOl8zodpEUdl00XAvypCMupmEoR4tRbX9
	co56ajbtSmOrve7rj4DZS6qrKIdbQrM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAbXpW5G;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877126;
	b=viRcXMtOUaId8yVLdJUEoE+m0rHS61DOvh7PhOfIbqk9+cMOkkaFELzu00A08puiX9atyV
	BoLmIWPjHbEWIG9/n/UReelHoa/h8FNJ5/s87YsP0STKZzSBWfxItY73aWZw7z/KEHLPY+
	1h0h6FJU4QDKCsfdOZwCgOf1IoTjwsA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F51D41FFD;
	Thu,  5 Nov 2026 11:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B671F000C1;
	Thu,  5 Nov 2026 11:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877125;
	bh=A6Btm3+v+dnXqWTR2GX+hsLiVMvVrLHj5mxZiRv+uQA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WAbXpW5G+J81zpga2YkofDFAJr37p7VW0gGXFRU1+QCgzM/A2pZgHgznNZ2nCalqE
	 Ia3JyUZPh6L8Rg/y+uDgpDdpHVkNXyzDJVU61C50bKdJpxk3QmFsmifPi+WacjV/XA
	 QcdaQ2JwYWDZM/S9fBxO98d3uu84tMP2L3LX4JZ6BhPLw+JPH/18HgMzAJJzcMfDF3
	 tw4HNNjQMzFdjFhehxPRAgVYMCdqVn+EzZzkd0u3g2A/L89+VMUZrPX21d6cbm+Hxu
	 OFZ2xzICDiinoYKDYRJ6cNwQKSRtQb9bUblJfArFReo7oJfCXLWSKUy3cXW4MihmdO
	 KKFQUwanA6LGA==
Message-ID: <sashiko-outbox-198922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/8] selinux: Restrict dma-buf direct cgroup charging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, "Jens Wiklander" <jenswi@kernel.org>, "Sumit
 Garg" <sumit.garg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-7-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-7-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:12:03 +0000
X-Stat-Signature: hzkghj666gpytupd41hg95ggtr7qpwbs
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5C0AAC0005
X-HE-Tag: 1793877126-61700
X-HE-Meta: U2FsdGVkX19Nsjl4gSYMYoEHsZeuM2eg0RQJMuR4j3YwP9airuUkL1nyU6D2dsHPKEBoxmQ/3/JJsgCbKee9lWx/7ayxNa6PBatqStXEMM9CEhCLqqGvmtT5OwUkYOlpRGtmV80rCofsIqD/fJ6vyxluBbIg/7jp+CZQF+rWI3OX19Y7aEXKd6Alx2Jn4s6J4diCYDz5MLnj1QGyTdGviqmyARpYxP7N4AjrZisb5F6kAHpjuYgGsNsspVgSYk/m9bmj30sk1S05uYJGfoi3lx65wbTrlUH4yXzp+x/dP2YEddRvenetI8rfZUcWN53YfoaUReZs+yG2FBhNFGkP7dF9DRv58S67b+BBkyx5iedBQa5v6uo7dUOFvU00PFiNaZLzM2sYW6ZYUhFFxZDfz+IZYvJj7HNAkWwHI/TQ1H0ntvBwf3D8HCFTcK3BB4LiSnXbUrAtbzbTZxsN4qreQRKB1+5oTucHFh46BDsPk5zFm04MQeJuE6M7UZMC8kBqrjSZR5I1UAKMEzdAusiVVTBE6GWAs76nRutgqjd7QUr2GXJdmgJH/D0/bBq/KrPIsrTP10a5ryeESw/5VXa4pLndcEtFG5UJeAM6IqxPoFRAh/j2uzHgwE5D+7xRNiR3r3wBNQLWn84+PARz9Y/nzoDix5KmBtwI0KT+MhhFqQ3LVvX5EmLw8LscW4zlc8xZ0E1DknFjylJZo21Tl9jlxKHzqemVBFvoUQL2lQ10E9W1Sk+5L2RMdZdMDs309NFKOvQJwIx5RxTsT2XH3/GpPBfeqX2siodLwtX4JaChSjRqlPzjrdJsW9VHqhnPT/BdlUbJNkhiQLolnqPota2F1brHzh9fWAJootI17g4Ik+9t9D6PWYxVV/KY1kbkQjd7P9jpvz7+48nfGIR15cnMRFSgPerGSye8mNd1L6/dk6wccQhXbvipwuy4Dj4G8iNAQX0Skkhxtnh5EBhPQUw
 Imq/q0II
 PRpFpIzHO60htHb5w5xNpGX1srLvUVbspPgcP+W6vqYSdzjELcUnhe3/dyaQMkeSiXO3/OZjJkBDXGp7W01chfw/w2qItW3ipGe986Rc0LVN8Pqla/F67jxzSaPgE8OxGluNRjw1/xmaHC6Ap6kfzEXooWJdP2sncJBr3/XbZJETNW7jNMTKHMVOuboZKpYJNko87BvipZPoOp7DR4SmsbNM8dgsWS+p7KdGFsuUeNfHHY+wiDzYMhqw/GKIgaaEBu0HgjfbvqE3TGsL4ttY4+fe57SW+I4DoNw9RWL7o0BDfldD9SHJ1/AuET5q2kIucDj9+u6UTEQOFLClBnTa2wFp23wnEoCvys/m5+z47dSAuqKgvCbxyk8Yrq6UVBVlXb7FjanPncsvhabFI6jGHvmGqfgMAyotPOn97kUwJKwBwB4TQmeE4ZtW/4cmLgmc8zJXLk59bc+2kIBcXc4JpTcSDWsodeMlSDTjkoIuXEcLuTvfa39P7X94CZqoZiuiDNQFzjuBl+aITSMMlbzzKBRSelCmhIfSzdFKjTrV9UHQBAOIitETbrfk1N+l0KlmWGvtTKPnU7dWNWqQ2hqNJoiO/0h2aTWs3b7BWmagz5iZZ6jixlVwOgzxe2toqjjDXjMEIsYadq3mUfFonCY2CFlI9qMZGC86/SOVWylXL0JNEMQNJJqGBc7nnRGOr9IBHslIuhCfnD9duvuf+0s4WghyiuD0wl88GrJR81TlNaV3f+AcHwe9hzS+agw==
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
- [High] selinux: selinux_dma_buf_charge_cgroup() bypasses check on genfsco=
n cgroups
- [Medium] selinux: one-off dma_buf charge_cgroup lacks broader cgroup cont=
rol design
--

commit d0dd0ed1dd84ec5c8f4de9a298a749d83668b53e
Author: Albert Esteve <aesteve@redhat.com>

selinux: Restrict dma-buf direct cgroup charging

This commit implements the selinux_dma_buf_charge_cgroup() hook and adds the
charge_cgroup permission to the dma_buf security class to restrict which
processes can charge dma-buf memory to a target cgroup.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 8f39d91eabc97..2f99eaa910af4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2210,6 +2210,40 @@ static int selinux_dma_buf_charge_task(const struc=
t cred *from, const struct cre
>  			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
>  }
> =20
> +#ifdef CONFIG_CGROUPS
> +static int selinux_dma_buf_charge_cgroup(const struct cred *cred, struct=
 cgroup *cgrp)
> +{
> +	u32 cgrp_sid, clen;
> +	int rc;
> +	char *context;
> +
> +	rc =3D kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0);
> +	if (rc =3D=3D -ENODATA)
> +		return 0;

[Severity: High]
As reported by Sashiko on v3 [1], in security/selinux/hooks.c, does returni=
ng
0 in selinux_dma_buf_charge_cgroup() when kernfs_xattr_get() returns -ENODA=
TA
bypass the permission check for all default-labeled cgroups?

When a process calls ioctl(DMA_HEAP_IOCTL_ALLOC) or
ioctl(DMA_BUF_IOCTL_XFER_CHARGE) with a charge_fd referencing a cgroup
directory, mem_cgroup_get_from_fd() invokes security_dma_buf_charge_cgroup()
-> selinux_dma_buf_charge_cgroup().

In SELinux, cgroup and cgroup2 filesystems are configured with
SE_SBGENFS | SE_SBGENFS_XATTR in selinux_set_mnt_opts() and obtain their
default label (such as cgroup_t) from policy genfscon rules. When a cgroupfs
VFS inode is initialized in inode_doinit_with_dentry(), SELinux computes the
default SID via selinux_genfs_get_sid() and only uses kernfs xattrs as an
optional override:

security/selinux/hooks.c:inode_doinit_with_dentry() {
    ...
			rc =3D selinux_genfs_get_sid(dentry, sclass,
						   sbsec->flags, &sid);
			if (rc) {
				dput(dentry);
				goto out;
			}

			if ((sbsec->flags & SE_SBGENFS_XATTR) &&
			    (inode->i_opflags & IOP_XATTR)) {
				rc =3D inode_doinit_use_xattr(inode, dentry,
							    sid, &sid);
    ...
}

When no explicit setxattr() has been performed on the cgroup directory,
inode_doinit_use_xattr() gets -ENODATA and falls back to def_sid in memory
without writing any security.selinux xattr to cgrp->kn:

security/selinux/hooks.c:inode_doinit_use_xattr() {
    ...
	if (rc < 0) {
		kfree(context);
		if (rc !=3D -ENODATA) {
			pr_warn("SELinux: %s:  getxattr returned %d for dev=3D%s ino=3D%llu\n",
				__func__, -rc, inode->i_sb->s_id, inode->i_ino);
			return rc;
		}
		*sid =3D def_sid;
		return 0;
	}
    ...
}

Similarly, selinux_kernfs_init_security() sees -ENODATA on the parent node
and returns 0 without setting an xattr on child cgroup nodes, and if the
cgroup_seclabel policy capability is not enabled, security.selinux xattrs
cannot be set on cgroup directories at all.

Because kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0) returns
-ENODATA for every cgroup that has not been manually relabeled via
setxattr(), won't selinux_dma_buf_charge_cgroup() skip avc_has_perm() for a=
ll
default-labeled cgroup_t cgroups and render policy rules like
"allow allocator_app_t cgroup_t:dma_buf charge_cgroup;" ineffective?

[ ... ]

> diff --git a/security/selinux/include/classmap.h b/security/selinux/inclu=
de/classmap.h
> index b4ebedc6e4240..90d1e04c3d27c 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -181,7 +181,7 @@ const struct security_class_mapping secclass_map[] =
=3D {
>  	{ "user_namespace", { "create", NULL } },
>  	{ "memfd_file",
>  	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
> -	{ "dma_buf", { "charge_task", NULL } },
> +	{ "dma_buf", { "charge_task", "charge_cgroup", NULL } },

[Severity: Medium]
As reported by Paul Moore on RFC [2], in security/selinux/include/classmap.h
(secclass_map) and security/selinux/hooks.c (selinux_dma_buf_charge_cgroup(=
)),
this adds a narrow dma_buf class permission for cgroup charging invoked from
DMA_HEAP_IOCTL_ALLOC and DMA_BUF_IOCTL_XFER_CHARGE via
mem_cgroup_get_from_fd() -> security_dma_buf_charge_cgroup().

Rather than introducing a one-off dma_buf cgroup charging permission, should
this be part of a broader SELinux access control design covering existing
cgroup control points so that the object class and permission model is
consistent across cgroup operations?

[1] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
6-78d2c4cb8647@redhat.com
[2] https://lore.kernel.org/r/16093a0278a6d7d1a0a8bc055c228bed@paul-moore.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D7

