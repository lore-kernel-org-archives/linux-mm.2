Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E01A606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2jtjq41
Received: by kanga.kvack.org (Postfix)
	id 3AC7E6B05B0; Sat, 28 Nov 2026 07:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D476B05B1; Sat, 28 Nov 2026 07:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272F06B05B2; Sat, 28 Nov 2026 07:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013246B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:26:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8C2180662
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:26:40 +0000 (UTC)
X-FDA: 85484451360.04.6947530
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 424C61C0004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 12:26:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2jtjq41;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795868799;
	b=SsowVw7UqFOSkPkn3F3FlHP+L85+L4mHR2tjGP9gd0z7hFLpyjvKIk+ys3fgZxhSdnzmGY
	tlc6uhuthJ0N4pYI+3X5Cth3H1r4t5xfdf790o10fzrIyo7yLhuGGid+DfZrgYWjQiTdHU
	Zeq3Aseh6fhGtq9NeD9izCAxyreFvf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795868799;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P07NYggygzE3fwpHc2SRwsiITr8AGaV5Klw6Eg5mBoo=;
	b=rvLbfcTkO8EtOR15KzkJpNBsnt4WZxhd4LSB5Ypv1mO6ZMO27eZUB8kPKdBQ2pjDM98lPg
	5ahY7AYNLJh3AyPb8U+kPyw5HjMLdjsq1ydBl1irT6r3RbhaAqR3plRiTBp20S0FuTPK4n
	hBQIpmQiyefStbOqgNMax1ebmleK/5M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B2jtjq41;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A552B43BEF;
	Sat, 28 Nov 2026 12:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ACA1F00923;
	Sat, 28 Nov 2026 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795868797;
	bh=P07NYggygzE3fwpHc2SRwsiITr8AGaV5Klw6Eg5mBoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B2jtjq41oBH/GEDc66gvlfEwE9LwsffXvoOfW966WeVWxRWdgOds9Pq7TkjilGPNG
	 2dsXcUqE5fDgrApZ9cr9mv6045Y30o5g3HKoJbgcF1x1xQwIQGrXpg8RAr2pwQvUhk
	 B9dvOg4L7gp8s+ETmLsPF4E5gpD7i2b7nD1i92qycUxrSJUEbNQKhxi6zag8TcLOSi
	 oD15b1REK3PudqwJjmh6CzFSKlMHCSQmsrgawEel7R1sTOaNcaSRF57Y/RwjIgysNG
	 OwPb7ZxyEY7dsx+XGPnq1gu5vEfGPzOWdOeXep+0DaJ7XtItrGrfhHcEV55EW5LxnI
	 FLks1/5v8vc9g==
Message-ID: <sashiko-outbox-238690@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] kho: don't reference subtree blobs as FDTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Alexander Graf" <graf@amazon.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "David Matlack" <dmatlack@google.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
In-Reply-To: <20261127122536.3708770-7-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
 <20261127122536.3708770-7-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 12:26:36 +0000
X-Rspamd-Queue-Id: 424C61C0004
X-Stat-Signature: cicy47yohwfp9mz8tdc46q1u3mjhymjx
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795868799-930818
X-HE-Meta: U2FsdGVkX18DiI8naxKpXKZU/lwp6LRBORjrKkHtKKnIhQeVhKnIAtgsnY65O+cZqAcaVbXBBwvH9ArDE8TtuAeftOynp8jWWMm7A4UuSpsgyECWgcDxE1rF1QbuWMWhkoqHz1MaryRGzC+DHm1erdkg93vF3Ksc5UstJTheLoOB6jHjYXIXMAC6i6Z+XW266vJYWPhx1PLKUpg2hhw6kLcsB4mQuvbNtCWaRQOuzNkzEfgrqx/314gv2R7NrrR16wkUGxZHtdwAV7ZW5awVdtUbzSGWsz4cq28qL37/uQPC+PTeFgpQbTvv4ARuvL0KGwW2iy9DMxIdMl0b+/JQ9VSDZI0KQY3hmN4Pco8VwzJqfxKxfhDr99HMeqZDnU+i5N0iQ0ZP/i7TmOjQSeoIjWeyLzsza76lzx74ZzCJEnf+Wx8hfseZAbV3E07OzASFH+DLAxKAzyAgvQCc1raswaXCYSgyUABlC97UVFffhH9fYFCWQcFt3HJ52hV3A42Xb4ss+IdG3pRdgaLd15sbR2P2G0+X2e4oAgTLvpMGwee38Acifh0S8/1pDOQr7abN+ZWkXr53J5eBBdNylVLvFijcMtukL4Q+VwHciz+euk30ZM0a18UCWUCkb5JqUKKG7vS0LSv6BCAwA/RvNReXPVO+if0TnkkQ/toqof/+azqTTryQRJtfDOThWh8eVQDr4dLvATgvHEvMUz8z1fS6+lFRf9cwLH/okWASrDRv5c3IfBOE9Vtuqlkmx/+TZ2WjFK3y0/lJe4Uk+E89NtUTfdNyoNHAkx4xUxlYqCQXOQfSdZOn5PgkyilZ8sYbKcj3peqJw6KidHE+MtsBrRsCyLzAaplNttKMC6rf/kPhRr9VddBImJn1ktGMuTZRzeUVbUQMmJ2dvhpmNsQqSoetOX0CoFvMDBj9ovJqoBA/XYV4PKs+1RREIKRhF/bH3k8AwM48LhVM3FchtdZsQ5o
 StdDphec
 Fvl6zn/wBBdoQUL1uvEbjKPxT+7OJb6LcwI/KZ10yOEQG/nRpmSeBiEOQfjZ+POVAf9DMFvoq0mvW+EhUrZPrFxwbQkOdqCH3Gj/qnn2M3Od8izVSFJDexXuv9TWZ6dVwlGqknaJMOfXeyIs6wGCxY4dkkoDBv5fym0xnc99IGuPWJrQP5sW670eOoSAXD+TZ4cLfS828iKVU5604pIQtpYGKDpk9YvRQNXhx+FU7UwNMcE769bxN7Ef8YNXolQ+NjM94l3irOHg2j+lf2wjya5YOEBKRWASGiSA/Zyo+3Lwm8QOLQiBTqDWLgtArKQpT5Xitc/mEYY3c8Q0B4HakZc10DnnDa3pd4qrNtEtXfsotNN8WO08ffLLipsIgeAhlY2J6VXQat40il3OPWrJAy88pQo66aReDf8W9bFSsL1veZ4/GLRXzRgYJTO5xwWEyALKYvEzIjBAuLTZB8tGjnN7NpmnyiW3hpqtUJQFzekTsv94JeKnNqiY+DoQa+8WKcJqPnkXbc+MtTrNjt3k8FODp0we0Hp1DnOyA/16p9TmrAD1ljvPgYly//GQzlxAPvYyAdwGTukMhLK3vGreU9rKfJE7hxOtUzYWgcEekNh71wjnLfnppVnmXCVIzi0BimV5wWalP/Tg9Q2gjybTUnvuAgsjOlELmObUwRsUkTgbf6AxQbi4PVmK29YI0K3sH/ejQVpP0PpDq8++bxsbCeegNr18E+oUVQdeQE5u+U1DR3eDjrbpem0EyC08Di+O/uMpjBGl3gFbgU+2p8QLZ/D8KAbSV+ntraU9fukbFV3gG/peOlUK01guIRfsy3vvDha5/
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
- [Low] kho: stale sub_fdts debugfs path in kho_add_subtree() kernel-doc
  and kho.rst
--

commit 4fb09c13a16f68cfb66608af6d8973645ca988e6
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

kho: don't reference subtree blobs as FDTs

This commit renames KHO debugfs subtree tracking structures, fields, and
the debugfs directory from "sub_fdts" / "fdt" to "sub_blobs" / "blob".

> diff --git a/kernel/liveupdate/kho_debugfs.c b/kernel/liveupdate/kho_debu=
gfs.c
> index 8d04368c19789..1580e1a27566e 100644
> --- a/kernel/liveupdate/kho_debugfs.c
> +++ b/kernel/liveupdate/kho_debugfs.c

[ ... ]

> @@ -131,16 +131,16 @@ __init void kho_in_debugfs_init(struct kho_debugfs =
*dbg, const void *fdt)
> =20
>  __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
>  {
> -	struct dentry *dir, *f, *sub_fdt_dir;
> +	struct dentry *dir, *f, *sub_blob_dir;
> =20
> -	INIT_LIST_HEAD(&dbg->fdt_list);
> +	INIT_LIST_HEAD(&dbg->blob_list);
> =20
>  	dir =3D debugfs_create_dir("out", debugfs_root);
>  	if (IS_ERR(dir))
>  		return -ENOMEM;
> =20
> -	sub_fdt_dir =3D debugfs_create_dir("sub_fdts", dir);
> -	if (IS_ERR(sub_fdt_dir))
> +	sub_blob_dir =3D debugfs_create_dir("sub_blobs", dir);
> +	if (IS_ERR(sub_blob_dir))
>  		goto err_rmdir;

[Severity: Low]
Should the kernel-doc comment for kho_add_subtree() in
kernel/liveupdate/kho_core.c and the debugfs path in
Documentation/admin-guide/mm/kho.rst also be updated from
/sys/kernel/debug/kho/out/sub_fdts/ to
/sys/kernel/debug/kho/out/sub_blobs/?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127122536.3708=
770-1-pratyush@kernel.org?part=3D6

