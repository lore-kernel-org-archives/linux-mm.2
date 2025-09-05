Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D840CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6A38E0019; Fri,  5 Sep 2025 13:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEBA8E0001; Fri,  5 Sep 2025 13:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EBFA8E0019; Fri,  5 Sep 2025 13:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB3C8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:44:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 269541A037C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:44:05 +0000 (UTC)
X-FDA: 83855920050.12.69F8EF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EFC280008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:44:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlX8viSt;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNT2gsi3S4yMvtrMU71K0IZFF3RxJBHNjVA1pU4BCY0=;
	b=s2sfL8s0A48POief7b4ioOqYABHnCupE+rcAxawS61GWnSw/Q8+oGnC5u+OlMrJ4MTN0RB
	cI2ScBlSLJd6BapwPcrxxWSk/l6oYpcsZ/HzRz+CgCkM9Id5a1/v1LLA5Vh5IG/SQdaz+h
	8VZd6K2td5S4PV9Nf3VAGu/TmOtocew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlX8viSt;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757094243; a=rsa-sha256;
	cv=none;
	b=z2ShUoJVNcDr+n3TB6gcrtBwvilb7p3v/UDHVXJKisBJ8eJDVttNl45x6q+QQoCE0Xe2xX
	RHrTbfofrrSpJo135S0v9A24FoZBITt+xYLGKxACXaLbSP0AFK+Dtd69JxSPlpPR6U7XDT
	eWPs1AXJWEcsaNy5Gjg/5fY7EJJEAWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C90944C5D;
	Fri,  5 Sep 2025 17:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F5AC4CEF4;
	Fri,  5 Sep 2025 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757094242;
	bh=0R6uBNi0AxfzUpfBexoCE08XIxfXyiwY7sLKg5k0QaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nlX8viStcFxK79FfJuuymzNpbjrTTtyuePmbEcriYprpXNyHMPVynqL6XQhSJCXiW
	 4vhqgm49kw8WKmrk6DdElWfQmQfP7+Or1iQEMwjD0WJUicJccWcmFH4mUnXxjAlLqD
	 gsu66JjFHfS6Du7juXWBtoZ1G5Tq+zQfyT71Kg/oV0EpczIOFG6uL0+r+M/5kur/r9
	 X1eciZId07CH09tPojFm6OMji6KQ4FV8//PSWz+jVcNLPEjNbwbLGvQxBCwk57VDuQ
	 bru1m+TRFmp+EbI4MP1c3j3cR13WPotrZMNKrjvhdRmUeLkKk43RrCkFBh1B9Pt1uu
	 pSwr9Lo+72vIQ==
Date: Fri, 5 Sep 2025 18:43:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
	riel@surriel.com, ziy@nvidia.com, laoar.shao@gmail.com,
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Message-ID: <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wfr62XQcW9Sye/W3"
Content-Disposition: inline
In-Reply-To: <20250815135549.130506-7-usamaarif642@gmail.com>
X-Cookie: Yow!  I threw up on my window!
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EFC280008
X-Stat-Signature: rxtuyx78xrj334u9dag88hnepjcif95z
X-Rspam-User: 
X-HE-Tag: 1757094243-815597
X-HE-Meta: U2FsdGVkX18Bz7403fOJsdbDZqg8VbFQgR0bv/oQZKr6k1FkGqeqBwVulNXF5sEF/MVrgmNN55SKffUHv9WCiULsDV5Nzu3LmKAmEkYajf7xSzynQhhJkXyezu9SXCaJkmZAHrbqLZEhCbfKuq09noOBt0b8I/bGuaOeAECQhYJKrnLs2MBx7nemL3OosCh58140nh0Zlae1wEsYdlHWBxegtcT+wjK9EZ6VYClfIv1BNwcTbbkFDDOFRLEyHd1fQ2/j1WBg7K0hvl3Mchp12RYgcurbZ+drc68g2ZXdau6A3iBS9JnkOPd0igxjRtZ9Oqp4I5hQ1bD0zLLnN83crw3yFRw9UEXS3l7dimzhHf6bVJZKjodawWEqf/NrZGwTlrR35FvHg91BU/WdlvXq8m8OcYwQbxmJw97f7878T+P208UhDvvP6aPzZHLdoaxR7p/iTe93hYU3pdfQMWw4t2cezS3xAMq4miQjyoL6VTsTa9u+ek09QvVrVlqovDEtXo+vggas9SjXPBj2NxSyiVQLslfBT+4qgflKYQIZ0ZyfcjwoKncoo60wXBucfUnFSwSqsQeWqzetxH+m/qZP98ir2ETumG6c4Ya/HnrIhCKMkS/S0fM1AbeeZNvn2rdyu0W4XPa0D+JrvZMRtHDt9oPIHS8o3wUvFspzFfuKReWb5d1bxQIiZOfNkNxSs1b1C7iB8O99wFTekpz1TONk+HLd7ISfkvn5A6BVtzaDm6YduMJ6Cs5i0AvcUaNzTtT4a1Q1cnJ5xOU2vh107sWVlCCvN1PqEElnHI7++Q9BcPIzp3TCxeZXU0nG/ItZBleAnmUVzJhaR0Wje/FMHUOUuySLTkZqXOKn4ztNM+SOVNZrLNyEszl4hCiLvsmUoJy5ujeeXz2EA7ayx5rWcG1p2kPkFJYOnfYfYVp5oc6UjCXoSNUZUlpQASeCmNOcrw9uDmgzcRG4hL7ZQpKSrwI
 owRFlxEX
 Xrtn6+fdXKBMb9uRTA9d8FOQW5XQ8iHzjAnsgXAF8RfSmb7swWyReWrhlWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wfr62XQcW9Sye/W3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 02:54:58PM +0100, Usama Arif wrote:
> The test will set the global system THP setting to never, madvise
> or always depending on the fixture variant and the 2M setting to
> inherit before it starts (and reset to original at teardown).
> The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
> be made to disable all THPs and skip if it fails.

I don't think this is an issue in this patch but with it we're seeing
build failures in -next on arm64 with:

  make KBUILD_BUILD_USER=3DKernelCI FORMAT=3D.xz ARCH=3Darm64 HOSTCC=3Dgcc =
CROSS_COMPILE=3Daarch64-linux-gnu- CROSS_COMPILE_COMPAT=3Darm-linux-gnueabi=
hf- CC=3D"ccache aarch64-linux-gnu-gcc" O=3D/tmp/kci/linux/build -C/tmp/kci=
/linux -j98 kselftest-gen_tar

  ...

    CC       prctl_thp_disable
  prctl_thp_disable.c: In function =E2=80=98test_mmap_thp=E2=80=99:
  prctl_thp_disable.c:64:39: error: =E2=80=98MADV_COLLAPSE=E2=80=99 undecla=
red (first use in this function); did you mean =E2=80=98MADV_COLD=E2=80=99?
     64 |                 madvise(mem, pmdsize, MADV_COLLAPSE);
        |                                       ^~~~~~~~~~~~~
        |                                       MADV_COLD

since the headers_install copy of asm-generic/mman-common.h doesn't
appear to being picked up with the above build invocation (most others
are fine).  I'm not clear why, it looks like an appropriate -isystem
ends up getting passed to the compiler:

  aarch64-linux-gnu-gcc -Wall -O2 -I /linux/tools/testing/selftests/../../.=
=2E  -isystem /tmp/kci/linux/build/usr/include -isystem /linux/tools/testin=
g/selftests/../../../tools/include/uapi -U_FORTIFY_SOURCE -D_GNU_SOURCE=3D =
    prctl_thp_disable.c vm_util.c thp_settings.c -lrt -lpthread -lm -o /tmp=
/kci/linux/build/kselftest/mm/prctl_thp_disable

but the header there is getting ignored AFAICT.  Probably the problem is
fairly obvious and I'm just being slow - I'm not quite 100% at the
minute.

Thanks to Aishwarya for confirming which patch triggered the issue.

--wfr62XQcW9Sye/W3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi7IVgACgkQJNaLcl1U
h9BkKAf+JqqrHvX7cSXvElB+KK5JJPomvr2GjT43I3RCnUxuhhf+HNozf1vZSVsh
8ouaFjM+bdFsoFZGH+lHQrwf1jASur/DGPQf77HWkWGyXoT9DU0TC4/aFBydTyHD
HOhxlD64/GHWMcf4EiYbqAQUVwWItGmpA7A02pWTHKMqP2mRlNfAIBnuGYhX+yng
T5icV/TPDU+vgWkkGTq5gNCWwwsD6aoxTE5mXDPkiGvQwJ5APXoYiAei4h7bj3Ob
aWBr719s4YylshIwSt4XX7WP6FYex3GtCSrOGUCFoV9JA18UBWbWKb/Kemgb/drt
Um6GBJNcKG8OSXdAFAeidRIrg5wqGg==
=7I+y
-----END PGP SIGNATURE-----

--wfr62XQcW9Sye/W3--

