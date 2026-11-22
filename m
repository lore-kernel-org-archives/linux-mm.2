Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE24E606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cF2Bdve8
Received: by kanga.kvack.org (Postfix)
	id 70A656B05BB; Sat, 21 Nov 2026 19:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1FC6B05BC; Sat, 21 Nov 2026 19:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7F26B05BD; Sat, 21 Nov 2026 19:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182FD6B05BB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79CC1805FA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:11:03 +0000 (UTC)
X-FDA: 85460824806.02.3BD83D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E474940008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:11:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cF2Bdve8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306262;
	b=8VjBo7EnBZhxpUeDbEuIKhDeneQGsggyJzrRig1dBP9EUoEb3CSO+NmBIQPCcIfJGVUoeO
	GuTi12GtCplTTxAaG/3EfMZf61tNw7Ve+FJ8RWFE6tqqsF/Ithwg/gFpV8G5ZBRX9bDB32
	mmxlKyXs0Pgq6R1IHtU7wDmzsAbE1Uk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306262;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xl9s4gVpPKCKd7J+OHDCYJawIfMHN2GfmrNwppsbQA=;
	b=zBMNkC6Hg6jj8k1KlgnWz8NYJXow1ycAboBmVjW5h+L0+Z1mJL4BCQ9PzbOwwuIHz+1XGB
	rSrSmAtMGIz4rNOmhG6pNq2ZS5C7c69KbzS0LVQAxFZlS7z5Oz20Ux/wrBIYeZmj1sFj7y
	HBoUje+vbBYAxQ43p3Gy/RQOXmSGoaM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cF2Bdve8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AAE761CE8;
	Sun, 22 Nov 2026 00:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B40A1F000CF;
	Sun, 22 Nov 2026 00:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306261;
	bh=+Xl9s4gVpPKCKd7J+OHDCYJawIfMHN2GfmrNwppsbQA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cF2Bdve8/qznSQsfnd1xYEgiUrcxCrd7V58WAGmCRzQrPkGOc+Dd625R2Ma6n7R+O
	 et24swcuuqW8cHlZg5kHSDaKVHyNZhvhVQe87bKpUk2IWXWmG8W5XfHOdsjnhg7htm
	 1968X1SwcsHOJvx8NNn9GVQ3Bn04m50MMi4vzuDup9JHeEa6LXdZwm/qsunbUWOshZ
	 Lc086RdEgiT5YfVTyEBAbTccD2SKjAbd5hHw6bar7loHKG/cNn2Mf0pCeN09bSe/DM
	 olsiQ6BhOR9pJJRyj3GzLxY3XT7+ME7uyM8Ym4ADyXcRnDE5kgfnfNzd42dbc5PDrr
	 XdF/d7hu2CXnQ==
Message-ID: <sashiko-outbox-227557@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 22/25] arch: Wire up rootns() system call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-23-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-23-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:11:00 +0000
X-Stat-Signature: as8rkus6fqkgw5z9wmbo13btfxouakiu
X-Rspamd-Queue-Id: E474940008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795306261-114100
X-HE-Meta: U2FsdGVkX19QzFxukKCFE7DUBJ22fmKCze8XReB0IwFCCcK5+wdty33k3BIEMh0Dxy+CxH64yoZcW/BoUs4eLIX4o8lC26a6W+RzlITcCZhjz67k3t4GfYNFfE4827doSU526Cc82Uxwm1gp1ttP7LXe2+z9eV5bk0JUWLqjOTWvkFd9qysQGIjcVxGSzdBn4s9/oayT1ZqLOEw8vscpZSLViXlvvO49BesRMwBpV1pxf47Jy2JBsAzZsFSnXQhQMzojFscf/YaUEx9HEXCnhnJdk7K98zarP2os9jdToWlz9khD67IkgJPsZ6nCS7uosTQ8oSQ1phuCVPbVGEk+hvnYIOzgEN4U6LCI1vn465zorVHGx8kyHVgk5VGhI0ziD1ca29Ox4i3Q0G3mx6ZMRiRdbg4ntJOaUDAZEedgTD6mOqJK08QiPY8YC3OV8fPGHkDvPSRkg0qkLFmLiS+Y1qxU0MBNdpOcGl2E1hGWPb8pfeXLfOXW7Pa+ulD97OASoEDSTUpLbYNWN/yJtARthzLt4xzHp4PGaOv/gkPeqhjS4uweeJr4wrgcu+lR9f5x0cPtJwfdKr7RvbrDBa/m5ew+edFcEEAfp/6EEPZord1kg1La9F9KYtNgZGhB8+k+AVsvtgqCWO4wXRDEBm0sgm4sWaE+obUQQlpfkqmuFijwzJFT9dLtbCELRPkwxZmg/TgGPoyWy5UbhYVV7BJUCHuLhOCYFsH21yVFiIU8C9laBeQLc/YS5L3w3xd6BECjseNLM+4SkMzcWkuWBjB77azNu4SGzR0c7moRqIeA6dTx6Cxn85dHK8ZoVuez+jzZDnk10TqlJrLjSfVaH1jV3/+9b2EsmXRmrMudfQHIAvkJ1F6qixerdffG0vd/r8LqpN8DKbVde+m0BB7XDAEco/uHgtHxlJ3ZeLeHdRt8ajwgMIl8ftuk66+HQSpS3S6twOfjhZrZ/l/w4H/tU0k
 EpfVxaDb
 lbZNBB5AZiWSeJgYD5UXBgkFNwTiwGtpp5l6D0J0A+MkEr5rmiKRyeSsAZeu/ysBBYwo6S43nNf54opRR3R4wJVo0oa93aKnG8BrU6Uj2i6DrGMHKgPPZ9Tp9EznsHYh4K2jHBG7rWaALp4O0xa7cUVKzSvkRbjgC1G9KZCMCja1EGnrmBj3iH2za3rnMyv0lkV5Sxy/HK1FFfnAQNQ4GxWjddjV8YPfOKoJA21SLaj1mrhhsNgl3l8nZiJuT3xVJaG7LUK3jsT0AUNqoeB5c7OSmRIrPylzvklmdESttMUSbqqj2UEQtFf93gNzz7NvY3xzL6Fmpz83GsLqv/3tZrtSWn7RISLjgjyKnHfPUwrqwQq6bajhD76rpofSIIohMtGr2+qB1e2CDI4dM+tb5cIfAIdj8u+hKTsdAalKuvZ5POpb+Nnq9wWMNfymgGz74ax/MoA69eQKP1dp6HHm9YHVvFuGkJBqgPr/QbqJ5fES8zvbFsTjvzuPnEBo1KWKuTqpXh7uZRlSJOJUsDIM3BEhjdTmGMd5wxFwp08yyOH2LMy5dYAN68DeiTnGROuXGO3tz9PXrP+rWE3u6Da3n4N2qiFymOJjAeZMqFZhIhRYkqaGhuR0JiJJmC7eBhBiPSPsNp/imPeeSlOHGiEHgv7Z8r3vNEjkVX+bDlUHGWxcLYySVt3l4pKA/CUv4nQsQ9qHfjBeceOWvcnNPspmwewbL7GOA2F60nUrrMZvsuFN74PKjyn1H3I8YoY9j1gzw9bdGrBmi9GsYP0rerWjalzniVQUwVKSf1E3dNVpjXz9SpvQGco3lF0CKrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] arch: syscall tables wire rootns() to non-existent
  sys_sys_rootns symbol
- [High] arch: syscall tables wire userns_set_idmap() to
  sys_sys_userns_set_idmap
--

commit a98066c1928facdce930fb742694c04361f3d11f
Author: Jarkko Sakkinen <jarkko@kernel.org>

arch: Wire up rootns() system call

This commit wires up the rootns() system call across the architecture
system call tables and asm-generic unistd.h.

> diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/s=
yscalls/syscall.tbl
> index 9384d59a44dcd..2087b83d6d2ce 100644
> --- a/arch/alpha/kernel/syscalls/syscall.tbl
> +++ b/arch/alpha/kernel/syscalls/syscall.tbl
> @@ -513,3 +513,4 @@
>  581	common	rseq_slice_yield		sys_rseq_slice_yield
>  582	common	fchroot				sys_fchroot
>  583	common	userns_set_idmap		sys_sys_userns_set_idmap

[Severity: High]
Should the userns_set_idmap entry added by commit "arch: Wire up
userns_set_idmap() system call" in this series use sys_userns_set_idmap
instead of sys_sys_userns_set_idmap here and in the other 16 syscall
tables?

kernel/user_namespace.c defines the entry point with
SYSCALL_DEFINE4(userns_set_idmap, ...), so the doubled sys_ prefix causes
syscall table compilation or linking to fail with an undeclared or
undefined sys_sys_userns_set_idmap symbol.

> +584	common	rootns				sys_sys_rootns

[Severity: High]
Should the rootns entry use sys_rootns instead of sys_sys_rootns here and
in all 16 other syscall.tbl files modified by this patch?

kernel/rootns.c defines the entry point via SYSCALL_DEFINE1(rootns, ...)
and include/uapi/asm-generic/unistd.h maps __NR_rootns to sys_rootns, so
the doubled sys_ prefix causes the build or vmlinux link to fail across
all architectures using syscall.tbl files.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D22

