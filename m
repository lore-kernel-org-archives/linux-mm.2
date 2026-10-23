Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8F7606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLyWoM0h
Received: by kanga.kvack.org (Postfix)
	id 078436B0096; Fri, 23 Oct 2026 18:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0217C6B0095; Fri, 23 Oct 2026 18:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E533B6B009B; Fri, 23 Oct 2026 18:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA3836B0095
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:51:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B3161C1FFE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:51:43 +0000 (UTC)
X-FDA: 85355389686.27.571F5C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A16BB140004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:51:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLyWoM0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792795901;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYSp2c5otvQVKlsDqkCmWYdFvd1mbuUyoJ7Y+WxC2N4=;
	b=xNfs5PtkDQDbOaU+ktA/pObNttNSqXfuR6x/rerTOAtsdeP/Q9vbr7jmaHK25mvTuku4mw
	js2FL/eN/qnVHMRuPk3RFPC6r8Hp6aC8LgFJ5qwLqVpB1eDURYpSQYOrgaIdpHnzRCrmYT
	+VSqSSTLjjCTbUu8zepnDbH3RBsYmqw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLyWoM0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792795901;
	b=k66jM/QDahXyEnJAzMcDwrItBug5HBIENcET0h6eNScBtlePov4849E96jJha7bqQtjYei
	DNOJOJll8wJ1NAJPVUtQO5nmyQ9KygG7qRUqaHwNoEcHjlAaW8aISE9m6qos66eHsnP3Ng
	wjCvvdidFAhZSqeXhyUi032LTq8XENc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ECE56022B;
	Fri, 23 Oct 2026 22:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034841F01829;
	Fri, 23 Oct 2026 22:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792795900;
	bh=pYSp2c5otvQVKlsDqkCmWYdFvd1mbuUyoJ7Y+WxC2N4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DLyWoM0hycKXz03W3ktmcZtB/2Qv8F+pJD3BgZOgUuE7HMl3adGV7L4jNniZeZycn
	 tGZrN/dN7JBjneaErv/0SctPf/Q3RW2rZqrzxokpc3yLvdVU3CT6J9HCCSDRHj59U9
	 JuDwuubQprNLM8c7UYK+wgY+4m6T6xRRPkQdsK7izcrNnGcAavG/2KCPy5g2naT6NM
	 HswQj1PWWoq1FjYapWeVJw7d5D+PUqKGmssqYXXQAO8NIEmH6PQQn8z5j42HOAOi53
	 7PVToV3ougoNDe5+gOw6ZMPJDoOrtISLjLjL9vHXwMqEvCnGZJIIkB0OEJxYzuHBSo
	 Cf9N51nA419/Q==
Message-ID: <sashiko-outbox-183328@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/10] mm/shmem_luo: Allow retrieving tmpfs files
 with O_RDONLY
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261022225035.377445-10-dmatlack@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-10-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 22:51:39 +0000
X-Rspamd-Queue-Id: A16BB140004
X-Stat-Signature: p5oq9w4fn1qahiom7wuihu75b1cznuey
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792795901-854758
X-HE-Meta: U2FsdGVkX1+Fmn5BQS1bgSM3EABgiLqX1Ij1BcvYu7atsOxWSHkWCgYCMgUV4oMja2ajXe+GxqcD68JZ5ds77UOQB1YgYO+Stf648e/xAfAXYMFy46dTx54NHJKx5T22d69SDTXG1qnxFjOK9Z3bGk+PkHDVcvDIL/su+WxkLvMdAj1SzwjO1pfFfUYxD9JjQ+lWuvpQ/etyGavBU7Glq2qVf81J6n77+3tpiwikvI23rIrmMjNboeXrL6/k4b5hd8UJJ26eMvLD/OySlfUDjq9eT8T47lcFbCUKS5n7T4wu6Bfcd2dXjgZZA7fwa2cBMbANUL20wWxBtnNTK5PmspfDAzjzy06Hoe2n8XD9SlLgh7ibq37jVjq9I3BMOJuaYj+FuSdc7tluFXaUYVcVhS/EPFSLG6N0JJOTwBKmJTSiTxcrbm2M0nfEc5vnts4NXsVM7+W1WYZ5+eDpE0+NPYSL348EXdifAi7T1FpNif9EvWXjm3Q7zI3p0f3DcxDr+CizvN3LK9L+OtvZkTsRm1wAA2ygDKfxGZS6hQ0RdGuhrXC1CozR+Rhis8RjbbkAi5bPHMaeVHK/9OzPxBnVlHu3DOkrQSt+/N2ZFkdTaNqxauXCzsj1fm6p/f/ZtQia/TklY9egJDM2VXhVrMtO11kbu9BppdzWm42emgEM+7L4P2iVItja01AH1sVlRLMRZphy+NVstfcdcrnTUe4l4/JkoelawqS20pMOfGBhSca0NMzNt60Dpvu9212khQLyFh5K2mByrcyB/9zDPkn7QsGgYMToEleBsGhONhwL5snrhMnpEQRx/pU7ea4zUgHTCGWmzj7WKGyfrRc0/FzUGUW9keEeFZYhhiuE1bM2Tr/OlQQxjLWwGwpBpSnyBb42NdXsVK/XO2vHcT2QeSD3LZcnhQilM2PQzT8KKeqTALDhwfKDjVXHo+TztM2f/X/UKeQupbagfDKlUBlNA2i
 aVGTaIc/
 /cbYoi3k3cuhIpOm1G+b6feNE/ewQezUe0NXaYsDHNcDJHTLebsyJjJWMNsEzu2FNwFNFRgMC8kxXkoj6J84kxf+M3Xt2MgV3sgVkD89RHRst17p7v3huzVwQF2lbqU71eLHjtwYBnzyklu/vF2ZEF+OfXEIctKRQdbEMZU59QCb5OeTJQ9B7c7pQ15CJkMbc1qJEQOkpBh0aL7r2psYvzF9ObMYG7LHJTMy1/oQUYRz0/ATVszqtJYn4tkbPC2H5Ds9Aq8AKNc4hA1v37kOrxcH0QMEFcq42N9czRvY9msInsLBm9+B791oj7RBmoBf4YsFZDGuirVc4+xuhqprvfRMfWJCi0BEJKkU2cmvD/ml5u7Glj6a9Z2fl87rAIW/O9K/jSOfzAhNiQLdMDUxS8ZNknIszNxVzXZV/FUXEm5DEh9KA5sjN0MvI64gWCPpgM54OrRgSLovHIkk4/iUFLiDnrSiXpHPetcPjabeoyirM+ODgthZfhUGAROMUpzpD+U+CrJdSUeWdayfSAM5o1dDlHIR/HghWOylX2bpqC8C3I4MhGZ9Ha6q+DEtNYH8ui5jMoH1PyW74TP/xXjx9+MNN7k2PRq2/givzNK+rso9HgpcAd3gBshS4uZ9lchY5+bo4
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
- [Medium] mm/shmem_luo: unnormalized flags passed to dentry_open() on O_RD=
ONLY reopen
--

commit 18d00c8fbd0dd510d3e12bc0fbf7c761642eaf15
Author: David Matlack <dmatlack@google.com>

mm/shmem_luo: Allow retrieving tmpfs files with O_RDONLY

This commit allows userspace to retrieve preserved tmpfs files read-only by
passing O_RDONLY in struct liveupdate_shmem_retrieve_arg. It creates the
temporary file as writable via file_open_root() and then reopens it read-on=
ly
with dentry_open().

> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index aba2bc1f18c52..0b4a9d6e2968c 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
[ ... ]
> @@ -649,7 +650,9 @@ static struct file *shmem_luo_create_memfd(const stru=
ct liveupdate_shmem_retriev
>  static struct file *shmem_luo_create_tmpfs_file(const struct liveupdate_=
shmem_retrieve_arg *arg,
>  						unsigned int seals)
>  {
> -	struct file *file;
> +	struct file *file, *ro_file;
> +	bool rdonly;
> +	int flags;
>  	int err;
> =20
>  	if (!arg)
> @@ -673,10 +676,16 @@ static struct file *shmem_luo_create_tmpfs_file(con=
st struct liveupdate_shmem_re
> =20
>  	/*
>  	 * Create the file like open(O_TMPFILE) does, so that it gets the same
> -	 * flag checks, permission checks, owner and security labels.
> +	 * flag checks, permission checks, owner and security labels. open()
> +	 * requires write access for O_TMPFILE, so create the file writable and
> +	 * reopen it read-only below if that is what userspace asked for. LUO
> +	 * keeps the file until the session is finished, and a file opened for
> +	 * writing couldn't be executed until then.
>  	 */
> +	flags =3D O_TMPFILE | O_LARGEFILE | arg->flags;
> +	rdonly =3D (flags & O_ACCMODE) =3D=3D O_RDONLY;
>  	file =3D file_open_root(&fd_file(dir)->f_path, ".",
> -			      O_TMPFILE | O_LARGEFILE | arg->flags, arg->mode);
> +			      flags | (rdonly ? O_RDWR : 0), arg->mode);
>  	if (IS_ERR(file))
>  		return file;
> =20
> @@ -694,7 +703,12 @@ static struct file *shmem_luo_create_tmpfs_file(cons=
t struct liveupdate_shmem_re
>  	}
>  	SHMEM_I(file_inode(file))->seals =3D seals;
> =20
> -	return file;
> +	if (!rdonly)
> +		return file;
> +
> +	ro_file =3D dentry_open(&file->f_path, flags, current_cred());
> +	fput(file);
> +	return ro_file;
>  }
> =20
>  static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)

[Severity: Medium]
When userspace retrieves a tmpfs file via LIVEUPDATE_SESSION_RETRIEVE_FD wi=
th
O_RDONLY in arg->flags, does passing the raw flags variable to dentry_open()
in shmem_luo_create_tmpfs_file() in mm/shmem_luo.c bypass the flag
normalization performed by file_open_root() -> build_open_flags()?

In fs/open.c, build_open_flags() strips O_CLOEXEC and ensures O_DSYNC is set
when __O_SYNC is present:

    u64 flags =3D how->flags;
    u64 strip =3D O_CLOEXEC;
    ...
    flags &=3D ~strip;
    ...
    if (flags & __O_SYNC)
        flags |=3D O_DSYNC;

Because dentry_open() -> alloc_empty_file() -> init_file() initializes
ro_file->f_flags directly from the passed flags and do_dentry_open() only
clears:

    f->f_flags &=3D ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | __O_REGULAR);
    f->f_iocb_flags =3D iocb_flags(f);

passing O_RDONLY | O_CLOEXEC in arg->flags leaves O_CLOEXEC in
ro_file->f_flags (visible via fcntl(fd, F_GETFL) and /proc/<pid>/fdinfo/<fd=
>),
and passing O_RDONLY | __O_SYNC without O_DSYNC leaves O_DSYNC and IOCB_DSY=
NC
unset on ro_file.

Should dentry_open() be passed (file->f_flags & ~O_ACCMODE) | O_RDONLY inst=
ead
of flags so that ro_file uses the normalized flags from file?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022225035.3774=
45-1-dmatlack@google.com?part=3D9

