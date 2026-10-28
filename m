Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C529606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EIRs14Ak
Received: by kanga.kvack.org (Postfix)
	id 97BF36B05BB; Wed, 28 Oct 2026 11:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9525A6B05BC; Wed, 28 Oct 2026 11:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FC66B05BD; Wed, 28 Oct 2026 11:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56F4C6B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDDE280110
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:41 +0000 (UTC)
X-FDA: 85372356762.26.9C8F2A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31D7316000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIRs14Ak;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199880;
	b=kTpu5mtUxm7hvFtcoyLCUNM0RWBR2opmj5aGNixlFtXMYR+NFXghkr3AzDAVj4OKHpkABz
	ukR1Me5fkdl8RheR6ZIQPp6/o0OIF+gwp2YKdQbSLf8Sn6fHFzV3xfACABTvJ3OJoHHu3z
	c2smZfPvcEqucibRQJvLvBVsj/pLFNc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIRs14Ak;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199880;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TKqOP98FHIDcaJNoj3/GWwGDtZsh2WFMN9gl9UcQOs=;
	b=u06nc5E6Mdv/Pc/j5qK/bbtF638yT4b+ZBqsd5y595WclwYHpFyD9PSVdzcMBpHZu+AnZY
	UneuvlAyueltHpUhC2zbSK6gFF0WD8EKnY8+FFozO9qVB9lm3+cwVIVnvuxHIFO7cSfT/c
	kT0sxvqfbHSdg3NTrhASY8/2gERIJn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55BFD40938;
	Wed, 28 Oct 2026 15:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB0F1F01825;
	Wed, 28 Oct 2026 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199879;
	bh=1TKqOP98FHIDcaJNoj3/GWwGDtZsh2WFMN9gl9UcQOs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EIRs14AkkJNqV4FP2ztjO7metvge3koWsF8rvc9H1eOkLYX/cgC+Pq+XLh/h7oAnj
	 MNEGn9M/5cbtIepg3E5EECqqap8BFEljXDT05wKvMgl+Apv61iiIqUYexNfJTjfmPs
	 AoRvFUnbC3JIf3GjxOS+wc+ep8hcuNWLd1w3y7jCZ6hnohvFWH1x2A80texn/ET9Kq
	 yEq4MfQLIx5q38dPZ7eq1EDKuY5cCnLKRotbFLGUKXR/tzKM6v7AlFttlp5sh19hjJ
	 UBMh1XXQFRZUVF7n1jMrjSfKEDoADfSjdgZdcB6KfU5RvH6Y0q7CasX9j84wOnfCZY
	 3UAJSV4V6VVAA==
Message-ID: <sashiko-outbox-188031@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/8] selinux: Restrict dma-buf direct cgroup charging
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-6-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-6-78d2c4cb8647@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:04:37 +0000
X-Stat-Signature: r84y6rr1oa845e87s3zb7cr8qtoeni3s
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 31D7316000B
X-Rspam-User: 
X-HE-Tag: 1793199880-921984
X-HE-Meta: U2FsdGVkX1+JQi9b59XghLFXQN4/mEO1rhZgtY97IGeu8dAza3sujfF9YTcjXyeD1rKvttPZP47hODK0IcFmYZcwikkipG5U4Nepsdj+NjTWqQwvWW/iEsGvRVJlsYBDEYqotqVAK0Rdw7XM3XViaCEbnUW27m+U98TFyuK9tP/sIxZzJpdFodXzAr5Hsa/UQOPnhFKV+F/MtuwsZOCybjA5R1h6JCqbaZVbwORoha6e+YFGvgxSuEqwVi/joO+DHOJpDGK+pYuI31wYhuczCTHWZwxKoFfP2wpQWhzH3ZwHI6z6x2YoRpNJjc8AHT9nVaNQiIkSd8BIyzi6q6oleQp+/6CaY8r6mzpMoGB3jW9aIP1g+OfA9LsRn3gF96obQLTLPL6xlUbu2ud1GwyWWHtOiFEvnfY2dHLVLyfq6pODZyJuqsi78lJSiclJS0uDIJP+voTj04c2zzflMPaURtfe9TcGC0LhwNCeho5efupXv35lzBVoWJ+45fcbeQ67B0AOMB3IeTOU37dD3HSXoLNsfq2w4G47tFYH32ihXqde8Hpwzz9A0T4wg4DDDvg4c80IqxaxQlWdJyfl20su0YcLEb4XJs9OLBSxt3lY0dDUfFLTBY+RA4+j0iWhsCETc5A0cJfYKE8/1JKaUyqECRHL992kchA8MLVQUUsoFnPm23dRQXG3lgIUyxWcHi7DJ/LyhqkQ94Fg/aGPfUj27vElfMXQTvbVLrJ/OA+bCbc3Bs7RQH+RKoSW2PQQX4J9WlEpw5e01TqdJu5enM1zFYZPReZFPy5ajvrfL5dpWSPD4NcprJvnf+p9PQGbBljS7bb1Oyy0eW8qR2p/OoIEMAPpWJHAm62I+WLqYb8vlbEfxBKnJRJm5pSBWtpJqK+xkCngDiTlWZO2bh5STzlkvXB26WUPwx2SGnNmuZJsICNaCBBth23tqJHTJTpwNOuptVzsd1kNx0eKm/J5Kuy
 KYby36lQ
 oW2Xi3F6XlGBp+HY4ZNURXljD3NdkJy/BBziMVSd0ZyL/N5A307qM5wXjBCb1IezP+7tP6Ui11HKvwLKCEMiKmPvRrgLnkiZgPlY36Qd6z+L4/BXdstOkNTYSbWntDwdc0Ia5Kb5giPg9gatFT8g3DcUI+GpRu6/7yTWVmu1XMnVntJM9ldXJQueqgWj23sExfkFNlUhYV1B+IZqHUwbjTEtI5WypB5AiLAI+wOz6DvnUy/Kx74bAA3lhD+8rt+t3fJVRabSgmJcmpecQ0DAPQC0MxJ5zioXKXpa+MAqFPhHjfcThOQI0AbalkHABSvAXvb9WpSEPtVuJEn3Ujt+qNEp4BnzGNWnUZruNFqfx4LQOwr7/3Vd2X1A1KT0Ol3DihXYi/h5k6af9OkIpBmYbgEwX413IqxfUbRPoqj9Jx6235fEpVxFWA4caO8JstfjboWfJgby81eDqEIszpCh/W/uA67oEKxe+/w03bEeb+uY43zcNkKzuoh5oykvGFV9NGm7wjNIGGubS9dqaEbh1aRxIqEIQt7Rg2JI3+rg79bujEVgj8tq+CAWDJ6ReG2MiCUU46BBxWjiFO6QQAlYxa0rKpux0Raj0fY8cQkDPN5R+NKrUYzROSN9+jxbFjFEA/aaP26YdCrBwwC3/w/eqs9nO4Y5TRFusCXSP
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
- [High] selinux: selinux_dma_buf_charge_cgroup() bypasses check on genfsco=
n cgroups
--

commit 6b412783b17727c382f1a67078326c58c39264e7
Author: Albert Esteve <aesteve@redhat.com>

selinux: Restrict dma-buf direct cgroup charging

This commit implements the selinux_dma_buf_charge_cgroup() LSM hook and adds
the charge_cgroup permission to the dma_buf security class to control which
processes may charge dma-buf memory to a cgroup. It reads the target securi=
ty
context from the cgroup kernfs node's security.selinux extended attribute a=
nd
checks permission via avc_has_perm().

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
Does returning 0 on -ENODATA here bypass the permission check for all cgrou=
ps
that carry their default genfscon label (such as cgroup_t)?

In selinux_set_mnt_opts(), cgroup and cgroup2 filesystems are configured wi=
th
SE_SBGENFS | SE_SBGENFS_XATTR. When a cgroup VFS inode is initialized in
inode_doinit_with_dentry(), SELinux obtains the default SID from policy via
selinux_genfs_get_sid() and then checks for an optional xattr override via
inode_doinit_use_xattr():

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
inode_doinit_use_xattr() sees -ENODATA from the underlying kernfs node and
falls back to def_sid in memory without writing a security.selinux xattr to
cgrp->kn:

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

Likewise, selinux_kernfs_init_security() sees -ENODATA on the parent kernfs
node and returns 0 without storing an xattr on newly created child cgroups.

As a result, unless a cgroup directory has been explicitly relabeled with
setxattr(), kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0) will
return -ENODATA even though the cgroup is labeled cgroup_t via genfscon.
When userspace passes a cgroup fd via DMA_HEAP_IOCTL_ALLOC or
DMA_BUF_IOCTL_XFER_CHARGE, mem_cgroup_get_from_fd() invokes
security_dma_buf_charge_cgroup() -> selinux_dma_buf_charge_cgroup(), which
will return 0 without calling avc_has_perm(), leaving default-labeled
cgroup_t cgroups unrestricted?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-v2_2023012=
3_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com?part=3D6

