Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F13C79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651866B0147; Mon,  5 Jan 2026 07:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628FA6B0148; Mon,  5 Jan 2026 07:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C8D6B0149; Mon,  5 Jan 2026 07:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6FA6B0147
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:46:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BC3116194A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:46:11 +0000 (UTC)
X-FDA: 84297882942.16.4D5206A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F27E120009
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:46:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hk1GyY8p;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767617169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ar03mS5x6zUGnTrvGUaSaCLNf04tKd+zHscC0ASsXDI=;
	b=5cTBFeDv7ITAUiStbAJy9PAf57znHCkV+M1793ZBOqaqpLKAEjnG8hp6IL6huFrIdPK9pE
	FkvurcCLnHYObPIRNRdx9l4GejmcxpsFEjTaDfPHcSPo4J/tgCm36N2cZCwYgYWEdkb3FT
	MhrkFjYufniUVmplgiFN4J/5HGvy9eU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hk1GyY8p;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767617169; a=rsa-sha256;
	cv=none;
	b=BjzZqzzDCoAIQXN3Aw1TXd0+ACOH4UR0w1NArL7UJ9JAGiIpAnw0rA4gsTHQFkYidzVBLi
	PmspqCoHHXlLBX/DixPsdiAc9lMBVpAkZQT9YCVFHwOLBFDB3FjVwhdvc5vOrcKQCGnwCH
	q1RMWxl1zcLq4YDeeWVA434PddbqurI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9AB96011E;
	Mon,  5 Jan 2026 12:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A40C116D0;
	Mon,  5 Jan 2026 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767617168;
	bh=ql8wdMN032MrP8xavsv4jPuanq1kV6VysEAcsIRbjMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hk1GyY8poIzMwUg1Iu63Ub8SWVmdLS4TEm6OBkbOuil30njeic/+PyYniw19FvcfQ
	 akkAIC2dCBZpjG7mL+5tlswp55YzpRjO/r2CQ2P2icCNfqjFIC/Axp/X+aI/Gzqy4t
	 7DYXjBx4oQ4EWotSOuDKT6K/tdQ9CrmP4u6yeWgATKXWwyeKV/6HP+XIQFZP3kR2VX
	 NoBcM97/reHliukWwJASK0Ivj7chaFY7MJki7jZWxQDQRiZY4fna4e4eISENd0VNRE
	 ekfQvWw42zotZy6AniyKMrvCJuYsZOv9Hips04+ePO1QHQaYiSpIQx9Ygjpu4qQ03n
	 XuW6wtoAVoZdg==
Date: Mon, 5 Jan 2026 12:46:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
Message-ID: <2bc4e09a-045a-4d33-8857-1bdfe3281da2@sirena.org.uk>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
 <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
 <682f64d0-353c-47bb-808b-eacc2d4d6c00@sirena.org.uk>
 <9c97ac9c-b0df-42e7-84fc-7e0d986c7324@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ee3kU50VQDofGf6W"
Content-Disposition: inline
In-Reply-To: <9c97ac9c-b0df-42e7-84fc-7e0d986c7324@arm.com>
X-Cookie: So many women
X-Rspamd-Server: rspam02
X-Stat-Signature: ooufwjm55or6dmwojtip1ib9o59wnbxw
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F27E120009
X-HE-Tag: 1767617169-372593
X-HE-Meta: U2FsdGVkX18OYp6W+KI/G+aJL7+/N1vvYhGBX5wcFahULU/uyNLU/xVjLdkMS+G0jEA38S6wlUkws/dYRSTtw6Zw6/+9jvu6wBS2abKu/RsJN10xLQaoLc5GEz9ckqKA0k8/YqdrEZ5XwHUvv87bTfTkj7fCfj6vNGVzhBe3m505EGDBEXJEMRLYQScG4WV9UZQtOMQ5maPlOlBAf4NcqRNdjnc8rCkdF50WRvd1cpyZJwyWK/oZg/z39eyCHqF8jRIVTkwwq4VOHPP4DlKp+bjVq7S7C2dfPr2EFgMCUkTBLJqUjaDA/oaQQIDVM31xmu8LKiZJ5H2An+4EP+rHY/DlWyHSujv0k5uqlIxWg58rO1SAEVOZq8xnYbEIAqrJy2FRTXI2BNxHtXxppmnj0QEhSZ96MvfdpJvBjGeJETTGOdMPEN/srOfmV083JF1Y0vojfESCbTNmol4AfNdsfq+q/p09p9bRuWKC86zsSlEA0N9RYf73taBZ+BDHUehWPfLbPmfD/ziHAlAf+vjRYNhBCrltbnaD+6IMSKkYjU1bDjDzMEYdo33Fd/skGhhl/2nLE07jYk/pItGrAnXNPfKVdr/x+gN9VRL6VBtowDE5UlRHsrcPGu4YJaR9BWUB2yD0YH0LJgLFsWXxvq74WsNLL7Vd05ZggphxkFUG9OvlOA2ZQRkKlIhbljSIAkhv6S5r/apQMmI8tf03t3W+scpElOZa/48BA5K1vdmZ6oHd9R9w5mlFoVyAb6m2EcCEBI3+6UGVexZOUnOpjXA5qUvhXE5Vi1OMlmkft9ntJOuTJMTDhJOoBxy41d74WFRYKEmP0nW6OrILuID5QFo51DZMcdjKd12IjMAyB0G+F4DsCcKIgfXIs5OkGcg0zDvGFOtlB/LHX0vAsdfiFhh8s51bgv4q77V+NYxsZZqkikZibFu1hnb73OKwS6CRG37mv0CjVUZDKavVNBDXle0
 gCMcTzLK
 6XZRtR93Q6l7iLzaal1Zl+eHa3ks9rSMh9JBSHCl+djmBeH7jFdTYok2hDTNl9rd+wwj9ica08skrtv4KBZqxkkT4YM2ULRVvnCU7baYoBYrYUlbZHIUTfR6RCTc6sOPl4ZGAMjvb6OmSItWOKkMhvEJVZMngDgDIf28HlkGKngy4Fb85Gfs1wC63hj/sIqxVDRA7PAfTOhjUsjByT4bAukAjVME5xMgRRLkH8WpY2hj43x9fv5AYPCuaU+/lrEajVQmaIA1qZjXEsHthwzDhCK3KEEyoBcyFUtATotwxigImtK+QyP2SUCzILg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ee3kU50VQDofGf6W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2025 at 04:40:26PM +0100, Kevin Brodsky wrote:
> On 18/12/2025 15:25, Mark Brown wrote:

> > Well, there's also the selection of KDIR which for some reason defaults
> > to the installed kernel so we get:

> Overall the kselftests tend to assume that we're building on the same
> machine we'll run them, so at least that feels consistent. The same
> default is used for most other out-of-tree kselftests modules
> (livepatch, net/bench).

That's really not the expected usage pattern, I'd be surprised if a
non-trivial propoprtion of kselftest builds were intended to be run on
the system they're built on - a lot of people test interactively in VMs,
or on some other target hardware, and automated systems are going to be
building separately.  The two you've identified look like special
snowflakes TBH (livepatch in particular has a bunch of other issues due
to what it's trying to do).

> Maybe the documentation should be updated to recommend setting KDIR
> explicitly? Or maybe it could default to KDIR=$PWD or $(abspath
> $(KBUILD_OUTPUT)) when cross-compiling?

I think defaulting to something related to the current kernel build is
more sensible here.

--ee3kU50VQDofGf6W
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlbsooACgkQJNaLcl1U
h9AHxQf/Z8Nc97ZwGUewBQVLOCUmYjLOtU4B6nWHPdZgpoANTtvhZOi/lqyJS7gV
WLscnoEUA266crkqIWb3oIoWkNERtD19h+s5H+IXm4Nz1V22lG6R5PDblt8YegSJ
lFYuGvGeeBKESvTsg7PQDpjmLaV75LorK6X3t8GSjrEXtPKTJKIBxXfefrDHfDWh
ZWCTb/j1DMDdBZ/hRcRYPtiti8f0mcsIDB0KfJ2RYP/9VpcaVMgnGSVA+8lYjOZZ
flWs7KSCcOoMG8qZcqKmICyAewMgEvgjq4JTQkwJ8nnTHysXHnK558HZ01lydGFK
lrN4yLX5KhvW7HkLN1/hjP0ihXbSkA==
=jLkm
-----END PGP SIGNATURE-----

--ee3kU50VQDofGf6W--

