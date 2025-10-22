Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD33CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5788E0005; Wed, 22 Oct 2025 10:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CF48E0002; Wed, 22 Oct 2025 10:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA008E0005; Wed, 22 Oct 2025 10:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB7288E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:34:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50B671608A7
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:34:18 +0000 (UTC)
X-FDA: 84025995396.22.E784975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B558540019
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:34:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cP9wbkEh;
	spf=pass (imf27.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761143656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpBfRTO33XtypxhWUjwr2ejpXaMgdddmGsbGr8vv50E=;
	b=llCIoHSf/LpOLwzbJEWVBWM+A3h/MlKTWtHSwzQrULAkdV23wFv3E4wsozNQT1jQb1cX2M
	2w6SoZr9ki2bgU0F6ecyDZshXOttaQXdpn+HdUWe7/sDBR1IyLHyp7BsWcJc8pMKiuupQu
	v64lz/asGzqUAssbGfon2CEvMl25tBs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cP9wbkEh;
	spf=pass (imf27.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761143656; a=rsa-sha256;
	cv=none;
	b=d3qFTv1mw+4KsxRRzv6oP4gIMQODfEv1fqA4jr7br5xF6hZF3Kbbhhl2rkp+AU4NPRGjLv
	/VG4rEtLAZVoXQurmBB78JXn6UhEbXB5aiM6S4mlSHRU9GA39YvS55RpuwvykxsWjsmNcn
	+LIXGVoGYEOO8cMpfsOh+mhK6xEefDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79A3140309;
	Wed, 22 Oct 2025 14:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96649C4CEE7;
	Wed, 22 Oct 2025 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761143655;
	bh=PE0w9weBA06UY1ADMvuQ7RDRF1VFjwoEQh225hRpYZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cP9wbkEhPM5LIDakVffo66AHNLBN+38mt7kw0Nz1jjGM2DTXe/G7XuJ/6OFlVBDOR
	 13ysGZEgl7Yl6Kk7OLgtMXAGd+Rc/TAHxOWT5ohaXNSYIWzV1lGviaTtyV/yQXdjhq
	 kh6G0Dujl3w7LOIfgQW/e/jH/m9lfkPmqFaif4OrMHSPse4klWA1BdT76iUoBIHvKL
	 qkzYWKIk6slN1bfOqe+4G2oUCFmRrjagLn1fpxjjhAFqCvjDzlIZd/Jpt7HIfH+a/D
	 XkxNnpKeeolCDTKG2t0QQK573TSGGgDAGoOHy62RkvYg1tvs9a4RfHZbeRybsew7qp
	 NBpmfpZajkRGA==
Date: Wed, 22 Oct 2025 15:34:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v8] hugetlbfs: move lock assertions after early returns
 in huge_pmd_unshare()
Message-ID: <080b64d6-7bc3-4ba6-ab76-e1fe728bff88@sirena.org.uk>
References: <20251014113344.21194-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A/QWAtEIee2YEtfF"
Content-Disposition: inline
In-Reply-To: <20251014113344.21194-1-kartikey406@gmail.com>
X-Cookie: Thank God I'm an atheist.
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B558540019
X-Stat-Signature: 1dzf9rxcwju73euion9q13s1kmqs949x
X-Rspam-User: 
X-HE-Tag: 1761143656-223421
X-HE-Meta: U2FsdGVkX19LyiYMEqxDsZU+3Ti3D5yGz1BIpo58B6gvv60D8vGTjQ/QjxfUlQ7w3b7R1xNuMS49O5emYW4HN1QuSeQ4xuHLkb0wA5CQG69ADbZT9JtN39aoknetNUWs5YPBbQs+6Le3eFU1vRerP/WYnZUJZIeCBYlJ1yaZRMkpO7+oao8w4cy0rnYYsEltKZfgkMecNu51JewljLXH9TypBQT4zDkmptYJo0odCil8BfDNwWJiY3LCV/7yhf6zBgWdBr1Syalr2aAIbILLXwKQaiPqgnBAdZ2PhyOI+B1/pXEcAXr5j+KCiJYvDUqjNQ6scByOFdr1QeWLQEytHe4gBNnTqdDZA7VnUsJVntR5EoCFGGeei4Z0QptjCbnd+70EMXPpuquxUrayaWU5A0aQ7H/QTRuB48nWtPe1iX/3FyM5FZSfYf5Ah7CEPeNd2rilb48UXiqlZW0opbYVD6SHyQpL17JJJFcMZFyX30ratpb0RYH4cX1/jZKRqc2FlIy+1uAyrGt3h4bUUh9ASRRcTg9q2BMDSgcsyqZE2W0lDhHtEdbv4ygjoWiiB6z2E5xrbZyLjcflQGUO/eG/9l4soWSPnHdFrvHI1EHKajd48PgGTxD+mRhQAXW5AGSCAei4PS4hcB24gzeFYhvh8oDe82RNxO652nHGPKrTQ/IUFydPHwJiFCZkZwwePdjv5IvH8Sw14zK18noeRPax9OABCDr93LECgstRpZP8R0cM6a8vGwI+sOXt6B1CkBFbMlv2WOgpDkuufolfkOnjtspcxr0eByOJjiaVgd8YxAlpmMaMMnmxcicrejLwS8LPRpwc7v+vhbYMKal1RfsQdOizUi43XAwK51eDvex2FsMROBwEWWuOYtSH84qcHNxq05/x1QaStvc57aLIg8ePxaryVpaV9X050oVPB/GjMa1hmW0fLUrvF8dicAmQ+rdF8k9ALlrzWFfB4ItDBI6
 Y7/+9QuY
 r6eY8JnsP2EtEZlR6CsEgiJsHm3BDZ9QD8NU6oh5Um3R/Wa+jKCvAAqABFXU+9SSVGZsI3EXHq1t9mDyXYwKWC7CKJHjQ7ijt3Nft0evuu+pOeOXcC3mARv/5r2Wko//KwyHJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--A/QWAtEIee2YEtfF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 14, 2025 at 05:03:44PM +0530, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() processes VMAs during truncate operations,
> it may encounter VMAs where huge_pmd_unshare() is called without the
> required shareable lock. This triggers an assertion failure in
> hugetlb_vma_assert_locked().

On current mainline this translates the test from a fail to a skip on
the Raspberry Pi 4:

# # -------------------------
# # running ./hugetlb-madvise
# # -------------------------
# # [SKIP]
# ok 6 hugetlb-madvise # SKIP
# # hugepages not supported

due to:

[    0.000000] Kernel command line: console=ttyS1,115200n8 root=/dev/nfs rw nfsroot=172.16.0.2:/var/lib/lava/dispatcher/tmp/1991635/extract-nfsrootfs-9ik0m73w,tcp,hard secretmem.enable hugepagesz=32M hugepages=0:4 default_hugepagesz=2M hugepages=0:128 hugepagesz=64K hugepages=0:4 kpti=off ip=dhcp
[    0.000000] Unknown kernel command line parameters "hugepagesz=64K hugepages=0:4 default_hugepagesz=2M", will be passed to user space.

which used to DTRT but I doubt is due to this specific patch...

--A/QWAtEIee2YEtfF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj462EACgkQJNaLcl1U
h9C5YQf8DzoRtaemjFkXnj0s/9uWQGFbpRQHBXfRESoB/flbWhlkLXd4iI9D82Nc
Aaeg06+b4foXvsPsacRLjZTnd65mH73P5gFN35MInqU2RvSb1RCNP8/8eJJyieeu
s+r+EaPtFciPovmHxXaHkA4xvBVUz0q5Fty7Ndz2perwfPSWryAXyonZyw1cqJFk
e7gtvXR7FwlZs2KyRl7XPq6RJBpN+jTHUJPMtlNsdlYgaV9n/8LyKAqL6YBHL3QT
w9wYuSt1ijYYYCcH/xhMbUk02MD+ntabLMMTFs/4kefCvvFCDVZB9u2ucfJ0pE9e
9oLnPQ3QJ2uo91+tvTbJWhsAEWHsfQ==
=5pOg
-----END PGP SIGNATURE-----

--A/QWAtEIee2YEtfF--

