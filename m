Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DB1D3F079
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFBC6B0005; Wed, 28 Jan 2026 09:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189416B0089; Wed, 28 Jan 2026 09:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E06C6B008A; Wed, 28 Jan 2026 09:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F09246B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:56:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E8CC1B11F9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:56:21 +0000 (UTC)
X-FDA: 84381673362.06.439EC7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7433D100012
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:56:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CDPLXvHn;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769612179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwkgY077B5gDXtXxxl8w9qpzP+9mi6CNyTbxG33Q6mc=;
	b=ukvUE0eailng7ARGtzQYvmYZulswmbC0Hy/7kP0rbiqqRosDCBO0FIYNMX09Bj1hclw5aq
	6A3no84vYS1jDXTD6qn38m7/BtFiT8L9WKJZuPAwIQnHnZf2tMiO+5PRAI3rB9fCm3D91z
	VzBMIdqRqXVAhDF5MDtvyQLwCYlSnGo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CDPLXvHn;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769612179; a=rsa-sha256;
	cv=none;
	b=8SOSsIL36aZiVFIL/gB4PEaXFJs5fzyDHhqCj3pdxojYEIlwDO6bxF0YBqGK3BOPNFN9VH
	nt3D8PtXJ37cRAe9YrNX9FmD1sMCLHQvxtRKc4V4qChE8PztRNvMsgryzOL4KeXvjk/RC2
	CZUHTKWGkV9aYw7is9IbAh1K/UOugsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 564F54091B;
	Wed, 28 Jan 2026 14:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D831C4CEF1;
	Wed, 28 Jan 2026 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769612178;
	bh=4foIpbaquD2DNmCBZ+YWPONHSfl/eID81XsUnlzMr3Q=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CDPLXvHnUGx+/UYB7xNlvsXLMem9+OBaedmxMG6kuGNUd6wHnQRKg/sUUdnzqxgZa
	 FyWl5tcUQ2GVYh/YMRCDGlp60vZBtllJWP2p9L305PpCW8iZZjcouI8mtQfjsC8Hcu
	 DP2OJGHCo6ih1dGBL7/e0tVdn72rV3PkPwx/sb2ZKq+LUFiXbcT/xUMct1eU+0Y5BV
	 22Ww+NP/7/OcIHGE2FwZ/Z/Me/24DqPYMLOssytZgVRTJaHEFb1bUZSPDU1E9u0xYi
	 KNIQMjoLmJI9XIKrYC0lNhn+xE1LJAndVXKP/0r574C9GOga832EBBgoThMhRwTLAS
	 JpeAbp63LC4Pg==
Date: Wed, 28 Jan 2026 14:56:12 +0000
From: Mark Brown <broonie@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <bd2b86ff-aa07-437a-82d0-adf49434a925@sirena.org.uk>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
 <20260121164526.2093265-23-Liam.Howlett@oracle.com>
 <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
 <ce123a4f-c35b-465e-bef1-30a86274316c@sirena.org.uk>
 <znatn4y5bl57cb7fffvcgy6lznnyv5qfmzlnin2q55lxhhagcn@cl5pu256rsna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RtMgSRnls91TShOK"
Content-Disposition: inline
In-Reply-To: <znatn4y5bl57cb7fffvcgy6lznnyv5qfmzlnin2q55lxhhagcn@cl5pu256rsna>
X-Cookie: I brake for chezlogs!
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7433D100012
X-Stat-Signature: fa47rjy1h9yansfz3a9a8enc5qujur4d
X-Rspam-User: 
X-HE-Tag: 1769612179-423995
X-HE-Meta: U2FsdGVkX1/iWgKtKOg/0qZs+B+dFiVi5LEC7HXmtMuxv/ab8R1YWhKblQjm43U1Itk5K+aEdChglYUJayPaqTb8MbSK7SU61AqtqMhKoqJp0BcITPfdM2bHSgoR9vMgWBCyqmWB0qDvEEtnGzUvzler3ZbfNOIj1vgxhmRd1k8c5Yq57/hZ+f0XN4SrV4QniBFDmSwXOr8KSj0fl0JVaI65Tmuz8TYHiSfm5oDGxrKvhYArqq3T5Qry946u8eqT0HyYSn6epPEuRjLDFhcvFq1Bb3pJBQ9EWRSE5iPMh38/+itlbxEN9QpxLPMITldF7g3r4xolY/HHzZ4Poe/P8UN1KiccSEfmM9YgIfJ42MCFeHk7z2A/FXQLVPKbzKtuRcb//qfqIRx/rRqXAj/VNELrgJdNLnlD+hIO/c4QhbSEkdy12wPG/9kIo6L7/YWUYByv3iA3tFgC2Es7xhbLTPbkYM83XAIJO3kx8VhPdRUU/kT4Ys5Zd1CmWSP7PbS68ZlvrJOmkvPwfpNSjQejqQvJSpjq1f9NFXDnRGjfIsqtCAGAnK+QyJaCVdbRL0gRkE7hFZ20ndfukLG0NYhNq2Q88KyCFoL9TwvDrjzCJozatA3FrS8cdQKhkvMm97sy29mJvGi2Pg99mFQXhGvgnld9Gt5HfFh+dTJEQGSPFJ8OKoDdkOz/TRnOSUZuQwKC0qM0WSnzblJjMmvphpi8gTXKLeK4IJAFF3JAsNcYYmEDxoEQci+PZlnLWo8zDpWG/nLEIIJkUovW3IJQUxHEZkYyiWOfiv0niQWquSfkYfJG+oPRIWwYQfRoNz8yv/fH9p7UtQOKCqCdcxhwBB2h74oKn0ppcYpxvCK5AyrajFARw7UR4PY/HqCVafe/HLxrau5sLC2slNtdDJ66S0X6erG8Fowr2TatKbEoM1y4+IvfM68IiKPmlQH8X5fN6e0zGjNh/Tr1/WgWdpxV60Q
 2ODwekKq
 U3cRgYlJRNS8dnIFhWQzopInkZdDImefulGfC+/uk+h04mDinLb3SeLI1Nc6T0NaRuOyzCDtQJNmHwYPHXQP/tV36IzRPQ99coZb/eu+NkRzx8lkCqk7cLxoAWXZC8sW/GbLgLyhNSLSRnkcaxY865Gbj/l7jCRdLVStNLF7a4oCh1yHRB8Yl6xogpe5ECyMruTzG36Jmwu7DnVjVkHtmpIPr3TkMfSC1SPYhCmJdU4/TrDheO05NEwz0k0pOiZlcEhagvNMZkwWq3kRtMQcykaO0HlVGzstMPCFzkdvePAhVYLYJGsv9Egwit21GvxrxFhNZTfZnXgmNaS7bJEDS6PaaaWrv/lfPzCQHvU5AyroVwL0O16/49+JgOlWQJaasAynd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--RtMgSRnls91TShOK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2026 at 09:36:51AM -0500, Liam R. Howlett wrote:
> * Mark Brown <broonie@kernel.org> [260128 05:53]:

> > # first bad commit: [6ad069085c621d39fad4d1835af7e563975dcf7e] maple_tree: use maple copy node for mas_wr_rebalance() operation

> Thanks for bisecting and the test name (linkat02 on arm64) from ltp, I
> really appreciate the details on this.

> I'm working on a fix.  Please let me know if any other platforms or
> tests showed errors and I'll try them here before it's re-added to
> -next.

I've not noticed anything else showing this, but I'm not running LTP on
anything except arm64 and it wouldn't surprise me if the same test were
to fail on other architectures.  No other reports internally either.

--RtMgSRnls91TShOK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml6I4wACgkQJNaLcl1U
h9BKywf/dUXek6d1N5YEow5wU6aAKgEAKcAPTgXaIpgbuPdZYjiFB3SSLskc2vzi
JMnckEB92rVDjexkTcmGw4lLZDVkLfoJ1gYGAaKSApz6503K4MFgDP/8injGSRF3
Bn7B4VbUTmwpfrogeeqMYSsJL8nXtGDXFranX9usiwL4cWbmNCJqtWCSxd+MunXr
+R80j9jy8lzOV8cWFr03KmpUoBtQ4dr9S9pMrpuKwHkjtLMwRUMRzYwOTj+6YkMF
WiWvLNbke8+ZJGaqJs80I1rnx9I4NIwikWXaEVatE8/I6UgsMQXvL+EbUaZniSeC
M8igk1l51nG96wwdB0Rum/uiR6JtMA==
=mHEz
-----END PGP SIGNATURE-----

--RtMgSRnls91TShOK--

