Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEDC606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Prysm9Or
Received: by kanga.kvack.org (Postfix)
	id 50DC26B0981; Thu, 22 Oct 2026 11:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE8F6B0984; Thu, 22 Oct 2026 11:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402A56B0981; Thu, 22 Oct 2026 11:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE6DA6B0981
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FFDC1C1DA1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:25 +0000 (UTC)
X-FDA: 85350684090.12.973A273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B08DF18000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Prysm9Or;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683863;
	b=gkCQBEUczr5nnDNPLEDB9EQbnuZL0/lV4dSQ5plEU5ie9JgYay9nBiQW4V0cyHjhdEsyPs
	1b/c9hwBmkTSRsiLzB0QkwOR4TJlC4VzZkbNcbYabRrJUfr9TL+U6gMWU/AnLHrIRP8aL2
	RQE0rcFaD6kmwYCpZjvSVmLCuMzXW2c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Prysm9Or;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozJPu6PuFiBw8wNtJS3YSSh7biusWXg0zaL2eC86BNE=;
	b=K9oWbiOJWIyg/cZwGXEm7L3fx7VI6ZJ3u9ig7AUHw6QVuWYo2nBdD/7m3bn0jOppEK8fL5
	hAwftBvXfGOXNaxpCIDCpuyo23+TnMmicfR5zTEBEWMzyyoV1WEQYmRtK1Qij+Q7yuqxnn
	jr1ltbeTGw66Fd97M7C6FbdNaCXpZkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E10F340582;
	Thu, 22 Oct 2026 15:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023BF1F031E2;
	Thu, 22 Oct 2026 15:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683862;
	bh=ozJPu6PuFiBw8wNtJS3YSSh7biusWXg0zaL2eC86BNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Prysm9OrP1mDl89rTMgWgqvYlKXUNbl8HxNyfyNvKsdAYw0He6eps4UGF9HklFCwa
	 YQd3uOhGW4bteX46E1QOZqIybMUImGs6yAe/DwhxZ2evZn/bP/o37xFaagIYLLptyZ
	 t01buezxrVDq/lB5krh+ba7qgOwjnk5oORWlrAWhGNWENKXrcw3MYpe+F83WehuoCG
	 ftSbG1ygt5e5eibG/Xzh96+sc9E8UGe6vJm7GDpqzOQW+4AV58QtENhFuBB4rxttN4
	 o8UT79YwVgADfq265as1Y/VwJ5Nql8+JVHtgupszuOZS+h9GUtmDGrbNN3u/ZCGZV+
	 JP8yCFkELIitw==
Message-ID: <sashiko-outbox-181722@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 6/8] selinux: Restrict dma-buf direct cgroup
 charging
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
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-6-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-6-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:20 +0000
X-Stat-Signature: x6mor6noeoo73nipe79gz5oqakt5bni6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B08DF18000B
X-Rspam-User: 
X-HE-Tag: 1792683863-510705
X-HE-Meta: U2FsdGVkX1/zTbtGuMJVcEPaINIRi+8XXAoAaRG47jk281nIwOT7vygEufCKOXrfrPaVlqM+RzgFFZo88SHVGkPkYA9dx+DxaEHyBM2TEST/z0bRFCrkOWsib+H8/Dn66mNnZMDUMGj2jQcn8m5LEXOTvzc3QbU87oE1yGFidCPxuNlBoZogjk/U7Iqjy9R0HTQm5Iq/sMIus4rAhlNEmFbwE+OxCBElW891B6V1CE2zt1c9H8AAQNW24OG/ipvIzRExjTFCxRC6WQcIUagNuhtE8vzkO4ZWtRD6OIeB04Qh5ghsZiopa2uGl/ONJIMcN8LhpKs3XnurnoDRgG1vALGFdiacM5YhsFS13lmeKmLkcpRdi2fFyEjzNQhWk5/ifRZ5F44kFKrhv+rtDnpS+JMYW8ySi+FltQAhlomWd2AJm9O1z/P8t0mKcYboOcBmajvpcxZKoXR2QBdYZHWI7HYn9Z7/UV/j+U6p2dhi70o6tbUdZ1mPucJW65yKC6/rdnBYmisv+ga9F8PF4sNlz/66cUi/5o+zvEHrsRxxIytjEamxbCwD/uu0AXVYre1BTc86BnO1eiOtV2iOMvGJnCi6N5nmQo2Nj6chB/OWCMaR9s3X9k8mH5uMf/fmC38hSigv/Y5dsrSU4wIpJcdP+lBTU26lYuPaPQKVteSXaLbBSI7c6q87L7cv7ZdP36GJOeaABEVJ+EhBpTnlq8xNwyjS3nJnXHIS8/WiqN//kFAVP+WYS3nqeKI8YEFfHx7v41ltU9CwaUtg+fIfJMyEj7EpVLG/K1qXhyi2qMeKCDGZmk7gd6beTKSwM7QdsXcAiMALNpw7prWWM0Mz2zLStbr5fLqUAFdbsYWJkrNj5W0xJt16sSvLHlIPMv9Qsm76U7J7M9pNtPoPBrLGHw5PUbHy1uM3tPRjtdlqSD6JypZzt97sBGAm8t/s2RShRgadveajvZUd++Eym5bDAdt
 L80fdydS
 5l0PxR2QYX/Bwe39zmeg3Oghd0ujpI3xtp9ocgDX65fbOwPKZkG/k/zaMFXWam1PeYNVXlLtIWz6bLzq+XIIGM0ALKKjE6zrNnUBe7vq6UaJDoi0jlot4ilw/rRHr7hsNRMIXXQRDzfCV2cSoAD+FKVrnFPBcwViCJ+znzxupP/gF2vn3PXdjgFUoWxkfS3jmSe4x1m/8cLiolbfyNYCn32GwR7zqFHCkHTu7FizQBRi1llfo7aWmFeFpwmiCB8H+bGP2+v8SKA6pydeqIVbXUrBy6nP03OePS6X5PKd9aTziOFIfsBnC8r9GdtEpQBjMiEmyjfkwgQ8PVCAtJ/rPpHZh3ANLtwrHV2TAJk5HfcQZpMPbiIE1tZR0UNcdekUhEhJzrvXrzfG/+aTWybdydyWD4UJAzCyT5KOH6LGl9ijzsEQ6xcB4WIjlGCByRDiR//Ed42cLEmH1eTU8UpC6yXVkDaVuRZbFA+MlKgmCTHqNMZmY+XX4Wu4nBCdv8azfeGqkZJ4py++A/ve4enyQ1v8AW+FC3Hnmk/5be/+hUT7mSQwM4LvLmeJ125stNrgg5eNBsNXBlvnbXrVcJua26GNuhO+HHIbzVF54LLfAClX+/vnBhicPKQHcxJd6LPXR44kfxiaYQgw3vymUUS/jJ5wGouyppWnqr5HA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] selinux: selinux_dma_buf_charge_cgroup() bypasses check for genfsc=
on cgroups
- [Medium] selinux: stale xattr length in selinux_dma_buf_charge_cgroup() o=
n race
- [Low] selinux: build failure in selinux_dma_buf_charge_cgroup() if !CONFI=
G_CGROUPS
--

commit 8979483cce99c621c0be48bae510af01c958c235
Author: Albert Esteve <aesteve@redhat.com>

selinux: Restrict dma-buf direct cgroup charging

This commit implements the selinux_dma_buf_charge_cgroup() hook and adds the
charge_cgroup permission to the dma_buf security class to control cross-cgr=
oup
dma-buf charging. It derives the target security identifier from the
security.selinux extended attribute on the cgroup kernfs node and checks
access via avc_has_perm().

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 8f39d91eabc97..8de5e16951dec 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2210,6 +2210,38 @@ static int selinux_dma_buf_charge_task(const struc=
t cred *from, const struct cre
>  			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
>  }
> =20
> +static int selinux_dma_buf_charge_cgroup(const struct cred *cred, struct=
 cgroup *cgrp)
> +{
> +	u32 cgrp_sid, clen;
> +	int rc;
> +	char *context;
> +
> +	rc =3D kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0);

[Severity: Low]
Will this fail to build when CONFIG_SECURITY_SELINUX is enabled and
CONFIG_CGROUPS is disabled?

In security/selinux/hooks.c, selinux_dma_buf_charge_cgroup() is compiled
unconditionally and dereferences cgrp->kn. However, the full definition of
struct cgroup in include/linux/cgroup-defs.h is guarded by CONFIG_CGROUPS:

include/linux/cgroup-defs.h:
#ifdef CONFIG_CGROUPS

struct cgroup;

When CONFIG_CGROUPS is disabled, include/linux/cgroup.h only forward-declar=
es
struct cgroup as an incomplete type:

include/linux/cgroup.h:
#else /* !CONFIG_CGROUPS */

struct cgroup_subsys_state;
struct cgroup;

Since CONFIG_SECURITY_SELINUX does not depend on CONFIG_CGROUPS, dereferenc=
ing
cgrp->kn without a CONFIG_CGROUPS guard will reference an incomplete type.

> +	if (rc =3D=3D -ENODATA)
> +		return 0;

[Severity: High]
Does returning 0 on -ENODATA in selinux_dma_buf_charge_cgroup() bypass the
permission check for all cgroups that use default genfscon labeling (such as
cgroup_t)?

When a process calls dma_heap_ioctl_allocate() or dma_buf_xfer_charge() ->
security_dma_buf_charge_cgroup() -> selinux_dma_buf_charge_cgroup(), this c=
ode
queries XATTR_NAME_SELINUX directly on cgrp->kn.

However, cgroup and cgroup2 filesystems are configured with SE_SBGENFS |
SE_SBGENFS_XATTR. When a cgroup inode is initialized in
security/selinux/hooks.c:inode_doinit_with_dentry(), its default label from
genfscon (for example, cgroup_t) is resolved via selinux_genfs_get_sid() and
passed as def_sid to inode_doinit_use_xattr():

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

In security/selinux/hooks.c:inode_doinit_use_xattr(), when no explicit
security.selinux xattr has been set on the kernfs node, getxattr returns
-ENODATA and the inode falls back to def_sid in memory without writing
XATTR_NAME_SELINUX to cgrp->kn:

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

Similarly, selinux_kernfs_init_security() sees -ENODATA on the parent node =
and
returns 0 without setting XATTR_NAME_SELINUX on child cgroup nodes so that
they also fall back to genfscon.

As a result, unless a cgroup directory has been explicitly relabeled via
setxattr(), kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0) returns
-ENODATA and selinux_dma_buf_charge_cgroup() returns 0 without calling
avc_has_perm(), leaving default-labeled cgroup_t cgroups unrestricted.

> +	else if (rc < 0)
> +		return rc;
> +
> +	clen =3D (u32)rc;
> +	context =3D kmalloc(clen, GFP_KERNEL);
> +	if (!context)
> +		return -ENOMEM;
> +
> +	rc =3D kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, context, clen);
> +	if (rc < 0) {
> +		kfree(context);
> +		return rc;
> +	}
> +
> +	rc =3D security_context_to_sid(context, clen, &cgrp_sid, GFP_KERNEL);

[Severity: Medium]
Could passing clen instead of rc to security_context_to_sid() read
uninitialized heap memory if the security.selinux xattr is concurrently
shortened via setxattr()?

In selinux_dma_buf_charge_cgroup(), context is allocated with
kmalloc(clen, GFP_KERNEL) using the length from the first kernfs_xattr_get()
call. In fs/xattr.c:simple_xattr_get(), the lookup is only protected by a
local rcu read lock per call:

fs/xattr.c:simple_xattr_get() {
    ...
	guard(rcu)();
	xattr =3D rhashtable_lookup(ht, &key, simple_xattr_params);
	if (xattr) {
		ret =3D xattr->size;
		if (buffer) {
			if (size < xattr->size)
				ret =3D -ERANGE;
			else
				memcpy(buffer, xattr->value, xattr->size);
		}
	}
	return ret;
}

If a concurrent setxattr() replaces security.selinux on the cgroup with a
shorter, non-nul-terminated context string between the two kernfs_xattr_get=
()
calls, the second kernfs_xattr_get() copies only the new rc bytes into cont=
ext
and returns rc < clen, leaving context[rc .. clen - 1] uninitialized.

Passing the stale clen to security_context_to_sid() then causes
security/selinux/ss/services.c:security_context_to_sid_core() to copy all c=
len
bytes and place the terminator at index clen:

security/selinux/ss/services.c:security_context_to_sid_core() {
    ...
	/* Copy the string to allow changes and ensure a NUL terminator */
	scontext2 =3D kmemdup_nul(scontext, scontext_len, gfp_flags);
	if (!scontext2)
		return -ENOMEM;
    ...
}

Should security_context_to_sid() be passed rc from the second
kernfs_xattr_get() call instead of clen?

> +	kfree(context);
> +	if (rc)
> +		return rc;
> +
> +	return avc_has_perm(cred_sid(cred), cgrp_sid,
> +			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_CGROUP, NULL);
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D6

