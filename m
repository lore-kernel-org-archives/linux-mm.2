Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC40D2FEFA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4AB6B0005; Tue, 27 Jan 2026 18:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C726E6B0089; Tue, 27 Jan 2026 18:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B545E6B008A; Tue, 27 Jan 2026 18:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5A326B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:05:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ACD51A02C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:05:57 +0000 (UTC)
X-FDA: 84379278354.17.4E7C445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DC991C0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:05:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nGE7l3qY;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769555155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJ3is6mgWGK4kXak5oUg+68xbPi7fZ6qOv0IXaHf0/0=;
	b=vxcH2rBZC3awJnVYmAUKbi/CYfzpMCeZlk0JCgzG1QXc3rWIvUn972Jw8O/ypz7eDzKnuF
	tVjiho6yQFPsGnaicw/5sA1gAxbbFJxW0UvYsl6Myg3ebs9NIjCwhngQlCHDG7qh/5KU7V
	veQZUWf09JQx+orKQ3hV/ht0M2Quqmc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nGE7l3qY;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769555155; a=rsa-sha256;
	cv=none;
	b=wh4QANHLBQq58EqRxrOF1CC8EM2RaRHPaD0RbvzTQZBTbhJhsljPBJZJa107ATyRWAwKBo
	Tyeq8mfS6XRHCBv9QAMsLNx623Ct7RMWRZdDmujxE5EuDF6dMFEHBdvDkbQdPHmom2slSG
	SZhzYwVUlkO8jaISM0YAoghHmyupHtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD47B60007;
	Tue, 27 Jan 2026 23:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676BCC116C6;
	Tue, 27 Jan 2026 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769555154;
	bh=8HE9ck1rMupu0yFyzoFwAZwML557gOYr9BIByUseff0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nGE7l3qYK2KJQW0bHK3UT/9rHgv8YTaqXMmRp/LEFU7u41IhlFc+GfdBUtH/UszYO
	 rjj3iubZXDnJr04n5qPx2GXHlXHI9dGnMBghyGDF3eVIMhOLTztyGhHatT/fJ0vCEn
	 CqiOk8XfWlcaox9Q2q1lHMaGKkjKHokSfJ5pdtlrpGjcrIEex5FGRot6b5KZuhKWwD
	 1yVk0TNBP5UOEZ41922Vn74RTDXugH/bz7km091u9hLP3df3+276sU/IuzyQ7B4nLQ
	 rPxzSuYdGorBQhGIF1jW3jSxxEyvemopb8kxaCD2sclhTCnI2PdlKCNYPCw+ueVrwb
	 7HX61WaaW8wAw==
Date: Tue, 27 Jan 2026 23:05:48 +0000
From: Mark Brown <broonie@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-ID: <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
 <20260121164526.2093265-23-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NN5iOyM+vcCcTCTW"
Content-Disposition: inline
In-Reply-To: <20260121164526.2093265-23-Liam.Howlett@oracle.com>
X-Cookie: Nothing is but what is not.
X-Stat-Signature: 7y7sowpckpn5ssg8nggj6nenrzjpbz6x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DC991C0003
X-HE-Tag: 1769555155-797733
X-HE-Meta: U2FsdGVkX19JJJL87GyjGFIZNr5L6q3ykmooLd9Cb78i3NK1OqQ1rrL16U9IGrW39CjtdbCaPYG2kEdPAb3zNU2P1MhpDbUUlDiIdu7SGcsUtPiQLk+AGHgsQPfzcTg+diiro7hjjtRQ8C2ZalIZur3IIqA7bFwMXViEAlMti52Latat0sbGjZO5ykNv9JVE2Lrc2OYiUaVrXKPH9FLrXv0ZDB9OoDbGVNu6PjtaQVAq4Z9W0lCDxJic/HGsXArTfKDkWmIGCSSvLOJdE2JmSThFkMNwlhcZ51cweYSbGprrmSiZrY41I5y6w9vmkIgOm8FNMGAdKusQKZxLom6ddURtqLFYqsFFy+Luiz2i3kxveXqUmCyOQkVfHwjJGrxhBCKXYPfhZK1y3Kq805g+kjsel87VK4M/C5LXC87ehTfMHZC8bvF9THy/bEaVBlMjdwqEoSjTv2JkRRnjzYb11x8pYfdOOdC24ARV35OP8+BkJ5MnKq3Z/t5xSNniCSVz9uZaWxyTfGFGoXbdiPuaJtsbimW7hqLPdefaEdarexo5koJWMNtnG71iFnvwLDDZvratc/oSDJLnt3ndpkLvLZRbtUxjqGEfKFPd2KWyqD+ruihKQrj5bxEh2SMXyJYpKW3cAojjstHGZoW2ZYZ5CMSP6FNLEAiNhEGEONgYeT0p649a0zDYU1R0373xysPzuqDc0zh+CNAlZFdK/YnPiLz+Sl4UC4wBYakv3ormpo+POL19WHCCDiItbnMw6l9hHZ9lFJuGgWNl60lotwR1S2HGRC2Dqy3SZKX6u6b+D2FxakOCZJgtNslAdRESyzaA/tmFCgP7kser5FERGS3+jlkeetjL+blVDK5Q6EhKAdJRRabRFjnXAP1o+FwvoVMhWO1A8jkMII5KR/mV99WBP5F3Zi0kGCOJkmb06w9d38DOh4SomfPJsqSd/nCJq2qiNwcxWr9tcyxUCZUaUJn
 yYfJNEXB
 k6hvjWGLhbhi0TluQhhm/uHv6paeZjX82r+58spcCPhGj1ggdAl//Lcqhyd895E/X87NV+dMX8apoBmeC/8WymPjAKWUwHBK8KcHTKR5mv9A8emtzBzMfg21i9yeY6G++XPpQumplsuS7/Iz+Fq+gPBzOCM9byJ9x/0hXkc8hQjxim2URxhiYcAzfh312/B8jObvZDYK+iF+H3fKYDuIXTLKtoWXbnEzgDCxGXXiMAbgiczoF61Yonw/TMogkzJJv/5jT2a/2vkIUmw41vMH6P6Ct3n97kyX88rXdQ7n2454m66T5644nS4C933AlCtThzVVGMWcrJSHZOdz+UWrviiM0JoO0m39YjXb3Lg1vK8uvS4vMhNNpkAF6jMPkeXwKxwFDbflZoGauUEI6pAGlkb8KKwC9xpFo6FjgclYocq0fDDFun9Fvoz3mso4gFzWbO3vwU4ygEZoImJJH+ZKogTt29tWKcrn5m9G7pYWTC+J3w91ybTfRku3ICXHq7loKo+IlFbqEccuE5w3v5LJhqX1D3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--NN5iOyM+vcCcTCTW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:
> Stop using the maple big node for rebalance operations by changing to
> more align with spanning store.  The rebalance operation needs its own
> data calculation in rebalance_data().
>=20
> In the event of too much data, the rebalance tries to push the data
> using push_data_sib().  If there is insufficient data, the rebalance
> operation will rebalance against a sibling (found with rebalance_sib()).

I'm seeing a test failure in the LTP linkat02 test on arm64 which we're
also seeing on a range of platforms in the Arm lab.  A NULL pointer
deference is generated handling the syscall in the updated code (log for
the actual next-20260126 commit):

[  361.882849] /opt/kirk/kirk[432]: linkat02: start (command: linkat02)

=2E...

[  362.680362] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000000

=2E..

[  362.917911]  __pi_memset_generic (arch/arm64/lib/memset.S:198) (P)
[  362.922582]  mas_wr_rebalance (lib/maple_tree.c:3497)
[  362.926723]  mas_wr_store_entry (lib/maple_tree.c:3534)
[  362.930953]  mas_erase (lib/maple_tree.c:1125 lib/maple_tree.c:4981 lib/=
maple_tree.c:5590)
[  362.934390]  mtree_erase (lib/maple_tree.c:5916)
[  362.937827]  simple_offset_remove (fs/libfs.c:260 fs/libfs.c:335)
[  362.942057]  shmem_unlink (mm/shmem.c:3999)
[  362.945583]  vfs_unlink (fs/namei.c:5470)
[  362.949020]  filename_unlinkat (fs/namei.c:5540 (discriminator 1))
[  362.953162]  __arm64_sys_unlinkat (fs/namei.c:5569 (discriminator 1) fs/=
namei.c:5561 (discriminator 1) fs/namei.c:5561 (discriminator 1))
[  362.957391]  invoke_syscall (arch/arm64/include/asm/current.h:19 arch/ar=
m64/kernel/syscall.c:54)

Full log:

   https://lava.sirena.org.uk/scheduler/job/2407192#L3795

These appear to bisect to this commit, there were some issues with the
setup of the bisect which fortunately don't seem to have confused things
and some timeouts stopped the last couple of jobs completing but we've
got adjacent commits showing passes and fails and of the two candidates
the other is a refactoring that doesn't look at all plausible.  I'm
rerunning a clean bisect but expect it to confirm this result.

# good: [50814c5ce8d8f6751fd49c818abeb8853f8be2df] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git

=2E..

# bad: [a85cfbd09f2d2f3bfab8fbe8246d0ae43a0c1628] Merge branch 'master' of =
https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
git bisect bad a85cfbd09f2d2f3bfab8fbe8246d0ae43a0c1628
# test job: [75fe66db9e85a2fd9743f7598a2aaea9eb5fbfd7] https://lava.sirena.=
org.uk/scheduler/job/2407316
# bad: [75fe66db9e85a2fd9743f7598a2aaea9eb5fbfd7] Merge branch 'xtensa-for-=
next' of https://github.com/jcmvbkbc/linux-xtensa.git
git bisect bad 75fe66db9e85a2fd9743f7598a2aaea9eb5fbfd7
# test job: [0578997f52fb9a1b9adfc5fe5a95ceab4bb331d2] https://lava.sirena.=
org.uk/scheduler/job/2407382
# bad: [0578997f52fb9a1b9adfc5fe5a95ceab4bb331d2] Merge branch 'soc_fsl' of=
 https://git.kernel.org/pub/scm/linux/kernel/git/chleroy/linux.git
git bisect bad 0578997f52fb9a1b9adfc5fe5a95ceab4bb331d2
# test job: [a85886367078a64dcffefe0ccd9054f6237b791a] https://lava.sirena.=
org.uk/scheduler/job/2407432
# bad: [a85886367078a64dcffefe0ccd9054f6237b791a] Merge branch 'mm-unstable=
' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad a85886367078a64dcffefe0ccd9054f6237b791a
# test job: [3b545d6116fcf6d257bf2d50e7607351fdc81b76] https://lava.sirena.=
org.uk/scheduler/job/2407463
# good: [3b545d6116fcf6d257bf2d50e7607351fdc81b76] mm/memory: add tree limi=
t to free_pgtables()
git bisect good 3b545d6116fcf6d257bf2d50e7607351fdc81b76
# test job: [8d2b3ef6f7d7b0a531c4c733224583af946a424b] https://lava.sirena.=
org.uk/scheduler/job/2407522
# good: [8d2b3ef6f7d7b0a531c4c733224583af946a424b] maple_tree: inline mas_w=
r_spanning_rebalance()
git bisect good 8d2b3ef6f7d7b0a531c4c733224583af946a424b
# test job: [b75bed193d677f6ae26df8851f4d5546fb7d3599] https://lava.sirena.=
org.uk/scheduler/job/2407554
# good: [b75bed193d677f6ae26df8851f4d5546fb7d3599] tsacct: skip all kernel =
threads
git bisect good b75bed193d677f6ae26df8851f4d5546fb7d3599
# test job: [4aededd81f86a8090ea8c294071425aa12116ef8] https://lava.sirena.=
org.uk/scheduler/job/2407597
# good: [4aededd81f86a8090ea8c294071425aa12116ef8] Merge branch 'pin-init-n=
ext' of https://github.com/Rust-for-Linux/linux.git
git bisect good 4aededd81f86a8090ea8c294071425aa12116ef8
# test job: [201b27d852d1aecf3abce28721c6004ec2690b8d] https://lava.sirena.=
org.uk/scheduler/job/2407634
# good: [201b27d852d1aecf3abce28721c6004ec2690b8d] Merge branch 'mm-nonmm-s=
table' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect good 201b27d852d1aecf3abce28721c6004ec2690b8d
# test job: [7bc25a7aa0443b3beb3610e505d3147eece02766] https://lava.sirena.=
org.uk/scheduler/job/2407673
# bad: [7bc25a7aa0443b3beb3610e505d3147eece02766] maple_tree: add cp_conver=
ged() helper
git bisect bad 7bc25a7aa0443b3beb3610e505d3147eece02766
# test job: [a2c17a4f4db66772701547fc30f66d1df2fceafb] https://lava.sirena.=
org.uk/scheduler/job/2407724
# good: [a2c17a4f4db66772701547fc30f66d1df2fceafb] maple_tree: add cp_is_ne=
w_root() helper
git bisect good a2c17a4f4db66772701547fc30f66d1df2fceafb
# test job: [525e5511c009c0d6725e534134ec31eeba148da0] https://lava.sirena.=
org.uk/scheduler/job/2407765
# bad: [525e5511c009c0d6725e534134ec31eeba148da0] maple_tree: add copy_tree=
_location() helper
git bisect bad 525e5511c009c0d6725e534134ec31eeba148da0
# test job: [6ad069085c621d39fad4d1835af7e563975dcf7e] https://lava.sirena.=
org.uk/scheduler/job/2407822
# skip: [6ad069085c621d39fad4d1835af7e563975dcf7e] maple_tree: use maple co=
py node for mas_wr_rebalance() operation
git bisect skip 6ad069085c621d39fad4d1835af7e563975dcf7e
# only skipped commits left to test
# possible first bad commit: [525e5511c009c0d6725e534134ec31eeba148da0] map=
le_tree: add copy_tree_location() helper
# possible first bad commit: [6ad069085c621d39fad4d1835af7e563975dcf7e] map=
le_tree: use maple copy node for mas_wr_rebalance() operation

--NN5iOyM+vcCcTCTW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml5RMsACgkQJNaLcl1U
h9Aoqwf/b/A73xKoY5WnIDdh6X8UBmES6YP3sTkPMgfdtVi0igL8IWf1B5/UKtLM
xRU/++CPgIGr9BuTeTdwpInsyv9ec71pqWkpJwcQXYBXOkYZkpazbVEowsWu5DMt
0Vtj380JKL0Mex1KObF8XPivBetTQeYQvimprDgd1vHeZYpuaY25RXdxgiqi1azB
9CgLz2izmpG6J9cF/nkRyUS/q6/h5o0fOzO1YQbFBUjFn08S2yUkCFz/NwPoZ5Yl
Jvv/ztcsQEl0/Yu1cIJr9hB0WIk9glsNvpPsJ55lmgc0b7o5OwQNG+5+EaUvsHfZ
D4gHkn48MmppcoGtGA5nMvI3w52aFg==
=pKb2
-----END PGP SIGNATURE-----

--NN5iOyM+vcCcTCTW--

