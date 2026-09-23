Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60A6C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A646B0088; Wed, 23 Sep 2026 19:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B606B008A; Wed, 23 Sep 2026 19:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60886B008C; Wed, 23 Sep 2026 19:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42D36B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:01:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42B1416019D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:01:56 +0000 (UTC)
X-FDA: 85246551432.12.0224C23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id ACDDD40014
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:01:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLUEIV05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204514;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAVq8riAYpkFQqE3vtYLztepdMXLNV8rYLOj0yWRQXo=;
	b=UFZ1KfsNKisKEqM1PSsvu+H8UIbGv0BocoMOYnXoVxfij1tUQjezz+z+dVXD7bslAMkMlF
	Fs49k7q9bSpmxB6OHZK7wJD+jPUM6mFMXUUFaK/ib3cdzsikN25U1nRqa+zEdsLt9o83vL
	0ocugReuYF2S+Xb6MjRezeLDtpzvrv0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLUEIV05;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204514;
	b=cmVP2HPLqjpTPsqcihaZkQaeaOOo8XjUhuCUcc45MJIGSVRhyaZEuFdNM8gcCgjNTYFOVp
	ZcnmcfXlkjCI15afU/zzZssCOPlmzLN2K+toJjUx2xoVkPBBsL1gMt7qA4sdjyVkLM9UI3
	AP1c71dD7fbPL8xXQHLjBzsM5ozJB1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8672060008;
	Wed, 23 Sep 2026 23:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8160E1F000FF;
	Wed, 23 Sep 2026 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790204513;
	bh=mAVq8riAYpkFQqE3vtYLztepdMXLNV8rYLOj0yWRQXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NLUEIV05TiKc0C/byycgiDauYslTGWVbc+nJ1MUD9VUnqU25rGdqejVNIqBf3pKFJ
	 5vpamPJuuFs302pY7sKIbWnzJH32VnHKvul5fJk3jKvVr7Tc+RFWXj9/iGc6IbDVjl
	 jCkFhVX+S5jF61sHSBBZOd0TuT3bqST8wCP0BMs9ud2VQgDsc4+ALG3BZb2tvRbwc8
	 rD9T9C5cZmKTsNXBA80mNGwvnvY3UmL55JJqvuEJmNzO1rvzvBkuoryvD8WVHSieJo
	 2LInadbEVFU7SMGahlhm0imyS859rWt1Y/OvYWDYXJH3pd+0RiHs+LPs5X/QFonpeZ
	 Ws1Um62uUwtBg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/6] fs/namespace: Add vfs_open_detached_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Alexander
 Graf" <graf@amazon.com>, "Mike Rapoport" <rppt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Hugh Dickins" <hughd@google.com>, "David
 Matlack" <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923224408.3745689-4-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-4-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 23:01:52 +0000
Message-Id: <20260923230152.8160E1F000FF@smtp.kernel.org>
X-Rspamd-Queue-Id: ACDDD40014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: s9831u7ujoy8murcjx4arhj1qonixkd5
X-HE-Tag: 1790204514-853424
X-HE-Meta: U2FsdGVkX1/kQTxoG4VQrsPR/kRI2lYiOC9shkmNImzA3n3G2tp5lLlNsZYJpyk/PYkrgMv3VeyLRTE50UaNZ9UlIsK/O8P+TH+jU08OrI/qaSVWIRA/tD4LmdwdJRqIVdeKy3VqZ+ZE9RWsTZ5mzD5tu/8GMAZWQ5y/WD97vyNZiK5sQuVm3K79wBVuPwxlXHmWsZrjj8bW8PgA07ax+kp1cLD+vi8Kx1KHa8h1jgRv4P8LOxP3Q2190p77Qp1s8pBo+HjalvI1hPZ1Q/VaAZmk8mqx4K43NxiahU+Lczj6UV7tFqBdl/SnWfGPxozSGaOeFqDXO7nB1UvrspPYUqYxMmhCSVSs6WrlsKy7DROq6eFrBXJI3LJZJy+hngXjqwQPnufYDY+pe+WeozrZXKXDXm/2tkjqyUgCuGrspcqQfkT/KUMEhLI53w5yoVfKe1bAE1fml+DNC8ix8h2XL9DaqouWBQ1FtVY6e+xXbFQO7ixXJYzccrE/ZGGOHM9C+E6Ti9oez2arwsrE6FGBQ2GTjW5yFY1rVCyxavZDgRFee/YPes0Q+ic8LrzARvlTDsiRSKS0BAwoBBvwdKYJkyN5tU7pHWJSVppPnQLodvQ4oZkePf2oVbm4Lx5iOBg9NQce6icbZl5rFRetDaXu1TDKgT50n0YdqwYxDSE7Ffp3ZTKINULldfEV4qHiVDF5qkl4l+G2NM0qAWaRjvKp4TR7pG6+GGzq6SEIhHgN5Z+tvVWlKiHpSVu0FUd0JJCMKvv3WtKSYzzis4z6h/UQXRycGguEo3RsIa4mimuOlWa0I2cV3P4AK3m8AH/vCWvcZAEHKkr0QPKtyd5LxWpyV01vBYa+VFBG5dluaFV/Em+Q4Ns8Go/sP0oj1COzjZgfZhfcv+XBIEMzXkLmIqSly97A/qsXyg1u+iw9G/MGi15aTxnF2BHLYWYzHMjM4/b6+KVVdBgLTqRIlXAtE6E
 iULF0vz0
 nSqAkF8ns1NEalFNv27YRcitvoIYLFgDryq0Vmuo6+QsbD0XF3FNZk7H78QuRY6nUAmWV/tnCjBzaU/1jBM74ZvKk2h0GPP2yWErwIPZY5n+MkReFrR0Rjax6WZuQMSJyd2qvJNeJL1l4+8ms3wX8/aWXtVIhnOlMeRs+wKpqBgT5eu2qPZJiAV+SsEH6fDJktO+MLUEwWdRbeGRD5JDG/zbRTj/fbMzL0XfSZAyvOCM/jJZTwftA1FZTZiC4mwmfXBl4dihGf3Xb85zCB7D3cwoXzaAuMi3w5lgq6OowIMzs71clb3rP4omNmlbWefRkXnvnFGSzC3KuGaGRHJW3NN/xpjaFNCgqV2BydCJXAMhroHT/uEO37HuH/iMsQ2quwaCNkkrlacultJd2TmUQLuwHcv45OqkxLAOrYcRBQPxVEr9DMKe1vOiWE0M6fj4duCC1kt4H5J0AFXDpuj77cKM3pNtZJg7Cka0tDAh5SsafGrVuHxJxdxDj0sjDHByucUM/+bkNYAWjRu7IchQXVFWJHBTgFepmug1hZiBYR5md5xU7ETiQlsyX2pickRpr8ZDb39hY10gQEJ6AQMSQ97qVKDEoES0MV22onCwfkRHgQm3xh2qzc7ung1UrViKASmo24r2XGHU6keM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] fs: mount reference leak in vfs_open_detached_mount() error path
--

commit 7bbd41a97d183f30490f0856f394037fd1846a6f
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

fs/namespace: Add vfs_open_detached_mount()

This commit factors out the creation of an anonymous mount namespace and an
O_PATH file for a detached mount into a new helper, vfs_open_detached_mount.
This allows in-kernel mount creators to hand a detached mount file to
userspace, similar to what fsmount does.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1ecd96c918b33..5e7ba2b61dd9a 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> +/**
> + * vfs_open_detached_mount - Publish a new mount as a detached mount fil=
e.
> + * @mnt: The mount to publish. Must not be attached to a mount namespace=
. The
> + *       caller's reference is consumed on success.
[ ... ]
> + * Return: the new file, or an ERR_PTR. On failure the caller's referenc=
e to
> + *         @mnt is dropped, as the mount cannot be published.
> + */
> +struct file *vfs_open_detached_mount(struct vfsmount *mnt)
> +{
> +	struct path path __free(path_put) =3D {};
> +	struct mnt_namespace *ns;
> +	struct file *file;
> +
> +	if (WARN_ON_ONCE(real_mount(mnt)->mnt_ns))
> +		return ERR_PTR(-EINVAL);

[Severity: Medium]
Does this error path leak the vfsmount reference?

The function documentation explicitly guarantees that on failure, the
caller's reference to mnt is dropped. If a caller inadvertently passes a
mount already attached to a mount namespace, this WARN_ON_ONCE condition
evaluates to true and the function returns an error without dropping the
reference.

For comparison, the error path immediately below for alloc_mnt_ns
failure correctly calls mntput(mnt) before returning.

> +
> +	ns =3D alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
> +	if (IS_ERR(ns)) {
> +		mntput(mnt);
> +		return ERR_CAST(ns);
> +	}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D3

