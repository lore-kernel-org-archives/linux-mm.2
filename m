Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E938DFD374E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 12:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550F86B0099; Wed, 25 Feb 2026 07:26:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7836B009D; Wed, 25 Feb 2026 07:26:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431E26B009E; Wed, 25 Feb 2026 07:26:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 312036B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:26:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0517160518
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:26:07 +0000 (UTC)
X-FDA: 84482901174.04.4090558
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4956B4000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:26:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUwGJh7p;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772022366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9iS9FT8w2uFjhdjn3Pig2ZduZb90FjR9mfonEGVMNk=;
	b=488eugHNSml8j6imyl1bdS4n6iKOihjQ3ECI763b4qPgVRM5MZDLsn3JPyk2YMl4eE2V2W
	5ZCm/oPIxJwLTVT8y6BZa+GkfttWj+geJ/EHr7kWqd/Y60VcqSbuDqZO1FVEI/8kZU2beP
	J+umHn4ExTxtnsBSm/tVBRwaGlYh9lc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUwGJh7p;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772022366; a=rsa-sha256;
	cv=none;
	b=pTGEJ5fwMYKoXodb084/osFFC7RMMTlrKRmABHVy8oofs2Yop8wyC8JuANTP9jA7l84w10
	4HR/c2d/tMxNF6xywE6ZvCMbO9zEtUlqscy/3MV7SDmzkISx7Dvzd0tdZjJsORQq3kiXap
	FawH0afaIPYNxVK1gC4XmzRZB4rZUOg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DFE34363E;
	Wed, 25 Feb 2026 12:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF66C116D0;
	Wed, 25 Feb 2026 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772022365;
	bh=P0ftlwoh23q0Lh4FmkJJ5DqQfqj0aGSgEZ8NXwd0Ce0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUwGJh7p2NABh//adJYr1tdRwi3VS6AFWHdQ/v9mfgJK/tw02ZzsStPYSSv3JZ3An
	 tQrNm1eMTvB9eKIxxlDc79+hQjymCtRqZzp35qz4Yt8AOgLtDZuXLPK3Ob8LBN/pcL
	 eVQozb5lMwBxPVenYEIB6BBOeKcHLB84p/RhULLf6KlzWhbhpP8FNGCO3NVvnuM3or
	 7JFqu1DwEd0EQ0C+W5p6YIeEmp40sMONSt1eGB2lpz05oddr13f3STXP17pENJq2ZB
	 /FVIpafk3o3/1zXJLjd8xHTdNk1NI44ne6UPyAhWzA4QVviAZ4g1VYXkuGzlI0PZpU
	 LcQGDcFmVmguQ==
Date: Wed, 25 Feb 2026 12:25:59 +0000
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
Subject: Re: [PATCH 1/5] mm: Introduce vm_mmap_shadow_stack() as a helper for
 VM_SHADOW_STACK mappings
Message-ID: <ba0e7ac0-d8b0-4ef9-904a-4ffa848ece7e@sirena.org.uk>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-2-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="clnvz1COm0CppSyu"
Content-Disposition: inline
In-Reply-To: <20260224175800.2500729-2-catalin.marinas@arm.com>
X-Cookie: From concentrate.
X-Rspam-User: 
X-Rspamd-Queue-Id: 4956B4000B
X-Rspamd-Server: rspam02
X-Stat-Signature: c1ka5whwt6oyd71451ddje1kjnpaiq8b
X-HE-Tag: 1772022366-416450
X-HE-Meta: U2FsdGVkX1+cr5ww7FcdcdGsL2WdX6nVdzujQx1PsK1edKxQD8X2vgMCGQgHxyEagoVR9RtpA/45AVi3Bq7Fe21SHGWt3iy0HabZkqa1+DCFW4J9iMUczzQ8wj/huY/ZqstrtTTy+kWXEAZAHZhFZ9iOEaN8gzYwcCrWEBCTWOq4INr9f4LrHBDTK2MdK4+SuSbMAFkbgSAhs6s/1ZUa8JVTalwi7y/0SvX2oIrcU4X7FgAHYVSf7hmY28cW1K3Bv2a7a2t+EzQ1JH/m0k+vAXn6QqTG5y/OuUt/wiLXJq8p0j5huJj1AwLrRKQcBHllZH+8z7bKVeB/SYt9/DuIfMa0hgPLEcqsmKs3h0KHt7qUfKOoA77jb10QmE/I5WniGznJdmba0p/5TpMtm3LZKTyyfebz/FUsOyA7T7iTmKCVQ/C9bh6LP0mV+9JAAEWglpsHZk44hhq5SQE0NTmqAaDg9nCkfjzBkEn0J2drqnHGCS4kobmvMYvIRgoecJMkJA/K0Dt17qCEtmUPZ8uJqu0OJRCSW9ZXdL/tG/QIV8rzucsH2OmSMAa8ReEVTWfIdMb5284UEGIEq6GAafZEA0cKS0uruXWlEvJcADdd1J8iVhggmfghXqconTyhvbL6HgdL3xT+JqJH600kczbaRLtpYblqrX42/10KaScoLYjdZn9ppqBM0IlojiTnUhu13i+5gMldSUhrDPQafLob2FLo+tbFGVw1M6iRizukpSoxNsVXMmX6Ypwl4UHCZpkrR2OU6nU3FKDqLIc4rkql0HLtSDc/PNRnXnWcE+Zh580GvnZKcSl1mdBOzZlg+DjUWop1760UdxurnonpvOfyYRKsMpI61gDEnz6jyLr7OvoH3jNlObQh1mFK8B0oMKCGQbtxYaqeGun8THig7HeRbh/fh7e6EgamU5i/1CFUuufx57g6n+jERn4H/GXiZ0zvAZB1nA7ZFWejHeCVGmv
 2h2EamxO
 phNUtMyZ4Dwumq5BoTEvxm037G1a90y5p++6OevsecvI7S6UxdI2udK6WVXJ4U8E2gkO3nymxUr70jB1hXllq/gnlp7y8WAakMOEJpKpOdLMC1saYzFDW74CHmO4TaAxxvZ9ySRVDIBJZOctWIBXabJ/jqaiUUYQuD1KTGZAd5fhexcResWndjha2Ags4fDEZYO44XeennuvL+PBKFXECDBQnqS0HRafoBOU4btL23rjDHTD3I3/Ne7jaBFDCB7IaghaPFWIOMv7O6FBhfSw8z5PFT8ZQu8SWwaEK6W+ezmLOp3z9d/8VKGF0OOIdU3gqqzEvZZLSBIbGEqn8OxGSCciYIHuqbbeTZcwwCJo/CU4+jaEiEEvxF55XAS2WloRLU0RU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--clnvz1COm0CppSyu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 24, 2026 at 05:57:53PM +0000, Catalin Marinas wrote:
> arm64, riscv and x86 use a similar pattern for mapping the user shadow
> stack (cloned from x86). Extract this into a helper to facilitate code
> reuse.

Thanks for following up on factoring this out.  This looks good to me,
with or without the removal of the ifdefs that Rick suggested:

Reviewed-by: Mark Brown <broonie@kernel.org>

--clnvz1COm0CppSyu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme6lYACgkQJNaLcl1U
h9C4gwf/eFxvG4xPkghLEHqpiQ4wKW3cqYV+F74MYRNm1tU/f1bLF0VsMCM8R5w2
tS3AReZEZKC8Dp5vv0jk4YaZ5AmbqrIHf0vE8Ek7/UwvNtPofCrb0/ORQA43Zl6K
N49WFkNMxs/rmMjWkGIUKbDQfIM8vHdUbBtWaMPHhdX5gaAc3iOIzi2qRoCADfKt
lCO74lt9+bT1X88SaLykSwNL0d8DVC5kbW/9/fEgYCq1asUMh5fX9emJXAHwbqsi
P1qNiMLg0rX4EJN0AVFVDxhjrj5zTGdQGI2Jqhfbekw6nRG+Yp1S0DX8YlCCgu1Q
a2G0TDSF0uz8zqxnhtkgyWhi5apLDg==
=Ev+O
-----END PGP SIGNATURE-----

--clnvz1COm0CppSyu--

