Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F78FD3758
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416226B0005; Wed, 25 Feb 2026 08:02:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A456B0088; Wed, 25 Feb 2026 08:02:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB806B008A; Wed, 25 Feb 2026 08:02:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18C8C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:02:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4D1F59837
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:02:45 +0000 (UTC)
X-FDA: 84482993490.25.7573A63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFA40140013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:02:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE8sVtK8;
	spf=pass (imf26.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772024564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bG6lGKiO/AQSqFZF8zcYKPFnP3iI8eQTbAgyFLNKPn4=;
	b=muN26wrZvbjbR0NJY3OYQH3L14Yvzoz/RI2Jao0E2a7t/1vbHDZZ0eIVhT1jUVQIWNkbtC
	BD6WP4wOo8R+XNWylcaV8jN7l2mojrrYTJyZ1LK8cbqDnVyQg6Mz3toe9bRc+Cyn6zWAZQ
	uqpzgRRZzeutXtdEgqnijHgLtdCHie8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772024564; a=rsa-sha256;
	cv=none;
	b=ibed/n+EGO/js1A9Q+JkQIlcHbQRAKxS7s/xrIIM1VGDic2XGyQtw7RdqnPwQwwOEL6OJ+
	caVUsFhEur0F3bYnkvsEwrbZ0Xxzwbw8F7E3Oft62QqCHy2KcUdWgeF2VoN6ODJPVulze6
	BdN4aj1YsLSXQfFw6E7Q7xWJp2y+mDY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE8sVtK8;
	spf=pass (imf26.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7A514330B;
	Wed, 25 Feb 2026 13:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C0AC19421;
	Wed, 25 Feb 2026 13:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772024562;
	bh=bG6lGKiO/AQSqFZF8zcYKPFnP3iI8eQTbAgyFLNKPn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SE8sVtK83K2QC+fszgE6mdJqlWX4NOw4VxSEr/x/zobnV9TuTZGvyfRCcnl4q5/la
	 PQiRd/1FLIOKG4HsfPqTGTflSF3IKNNMLvc+v2sUjGs2+k1XXsVIs6QQN8dqqNtSgo
	 x9WV4Ez6VyRXwBjAgRbc6iJkdG7d4ZSrMpcXR6UV+pJkBMeCqNBf2L7nHVtqPi/QnK
	 ZBiQiDprzbU4Ca2VbsVg9FOKpraWdix34QjN4zwYwSyQup0xNv4MuWDk+MaqG2lLoa
	 uUMeVvk9qCmHaFMWS/FUKzmpaa2ZfalKOUKr4ROzTdpaN7qhbz59/wsT0w46uuCa4R
	 uNxJbFgKgMAnw==
Date: Wed, 25 Feb 2026 13:02:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm: Do not map the shadow stack as THP
Message-ID: <5570c06d-fbc1-42c9-9b27-26211e8b033c@sirena.org.uk>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-6-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cXmct3hgznYcvsc+"
Content-Disposition: inline
In-Reply-To: <20260224175800.2500729-6-catalin.marinas@arm.com>
X-Cookie: From concentrate.
X-Rspamd-Queue-Id: DFA40140013
X-Stat-Signature: 3cgptmr6irba6dsb5xzmo9epfrj9aef3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772024563-124679
X-HE-Meta: U2FsdGVkX1/arqTZdTYRMh5xTEk7nyNA5ayusKIzspUxY9liRQ68/tFHBi0tSlJlggs7HKIEXBa/2Q6mc82GmrPp4plBPqwp0YM2/ohKOINB+zScQKpr3qGkAB07xraPO5uA4KAIwYCLIjpKT8BsNa2KkXCmBrBO2AXuGMiQcCq4nvqAKL2VeY9EYAiWIG6sokWOYTxvTcI5yTpZFP/SOch7bUzPxhP2sByjYfn/H/+DhUfk92AIABB283lAzP7Fjj3HP/Ciy8rD2C8Ug+sTKsIGFkaNUaY4PABuXeeBH1i5VxcvWtBDoMZrHCR3Qj6yz0zpkUnZQCTsp08H1CgRL2gc6VLs7VbPsAzgsegS3UiEovV/Q626i2yKqgLOEEXvPsYFiVMpn2bxJGmGUpA6RMax3Vt0lbiv+pUr1o6Un4qXCgAX8BqIEyAqGtnZbfIxk9O7tpNAzdujvNrG3h8YB2VtLzTjMcjMVBrmqhAw1AV7eQBdxPapN94sUuUiLtkbWF/AzyIriAirPooG7E095/l7JI3V/Q+tGnXTjJKm15hdFNYcYB9r1dGmtWlTiHyorvcGFTHhK2dXN5Fo1eqlobDEM8wnDnQ15zuc7h8lUdlatprxurZ+eceDFSljv/oJ4qBSObqrKUiy1JG3JtzthevLIpV8NtMs9fIJQo9cldaho868j7eSX583+HdIotsXjB9rcBVUnqlh/AUK/06vzCpajBDIZyvWGZTqtWFeGsougKgUHs3iGwei2aW7r+Ql877Npy8Qd2h83U9Y/biyPv4f4OkG2UJtL9fi0fbRsFP8HT5bzVSgOdTwZ2ei9Mx8+vdN6bDBfX+o4NNj7UXPojEr4XwLdZTMchIOQbN4fm2GY9HwLgAu+6ETVGLBG+DsBVVS0r6E5epz2c60Y/BW/3zrI5u5jsVFU87uf33dxRHN+0EPQVXjY8qOJVKW2kyU9KdDyMEUhpI6oFllrhh
 yqs3E3wQ
 2yktiaBw9lUjOtRFY9VhOufuxCbWSsN7kLIfa86eu3TzT4kdSBsZxXSFKlcKF5r4btnXPjSnQrna2ESQHH+TmXwR71GDppIzHKoQlulW0aahFPaBBNGkXmARcVGto/8IqJdZtXqs/VptP2Ki9pGfIv9lRlnp2C3MtjhPr4TPKZp2SSF4w1IVp9ZRNkDIqRwbdCbcgD5arBtF7aLHm+gktTzw4OqxcoVb0hKMze5BlFye89WAz184LzK3GI2WWAEeCZEiEjLJ9VH+Hb4/FbT7po0Qc/FOXahu/PDaHon5WCHJJDEAsIVE6c/mIdBW12IG2jlb6boa6GmV60hF+bxK6hnYGfjRXJGY5UwWxMnONc3C6ffY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cXmct3hgznYcvsc+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 24, 2026 at 05:57:57PM +0000, Catalin Marinas wrote:
> The default shadow stack size allocated on first prctl() for the main
> thread or subsequently on clone() is either half of RLIMIT_STACK or half
> of a thread's stack size (for arm64). Both of these are likely to be
> suitable for a THP allocation and the kernel is more aggressive in
> creating such mappings. However, it does not make much sense to use a
> huge page. It didn't make sense for the normal stacks either, see commit
> c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").

Reviewed-by: Mark Brown <broonie@kernel.org>

The create THP and immediately splitting it pattern is very clear when
checking the mm behaviour on new GCSs, this should help performance.

--cXmct3hgznYcvsc+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme8usACgkQJNaLcl1U
h9CDqwf6An6emWNltb5SR1AZIjifc5oF4Kkplg3VEBjz2qejH6O1DHtpUEPr90d1
/Np0MHYou2I8q7SWp4mdaNs1ovD2UT5Gr1SMFxZZBviJ0r9/Eob3BrpxVrC3QT9J
qybG0P8RYytpWk5rc2TJllnyTlY7gcVhjDT7BqCec6wWQOmLFeLinB845irNXV16
fFjtAtMZw+1Gye+rZY1EeEKfdRZLlnkMneBaoKF0KSr4h5n8PvtcGAHHvzCral8n
LS1poo8sjbOv0XtR6ZqTSEN0R7jQQ9w2QlZhaatEcZczugZRFs4jZDe7Q7HAZK1E
yiaDOtnMo5LnFk3zQouQJMNjqU37lg==
=SFPj
-----END PGP SIGNATURE-----

--cXmct3hgznYcvsc+--

