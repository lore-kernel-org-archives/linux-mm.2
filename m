Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A5DEB7ED0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40676B0088; Wed,  4 Mar 2026 06:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E6A6B0089; Wed,  4 Mar 2026 06:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFC36B008A; Wed,  4 Mar 2026 06:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAFD6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:10:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 094868BE76
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:10:34 +0000 (UTC)
X-FDA: 84508112388.01.7A1687E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 325F640008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:10:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtxESzLT;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772622632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqNfQqjBGfmbAJo/aZtHMPo7003kq0HNHUa3oLLM9rE=;
	b=z0hoJJbuKfo3OX2DxUvzp55wKAGxuoPcSxXj6ZwrAg+rtJsTHVV/Jxui0mYZwpq775rOW2
	632jzKM6yyUdqE/3+gqImbABd9mcJZu5zKJN0hTDzEo8Iz0iQeEoyQy6d1K2SQeWeu9xZo
	JJdo9Td13vgM+PedlDLRioQ1JWml3G0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtxESzLT;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772622632; a=rsa-sha256;
	cv=none;
	b=hGm5Hc06RSUtCVm3IbVF8z/Gg+yLZKVqwea4lK1X92rJeCxuuc048O/W2BCBE0MJrtaQQT
	6t9QLjQG5CmmWWmDe0VcGCcoytdRIgVLEKABIa6zgPkgj29bdihR5UW++3rYXegbHPaAN0
	ALes2XbEyw+ulLsKswU8WO/IQg8DQOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C485643B18;
	Wed,  4 Mar 2026 11:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64839C19423;
	Wed,  4 Mar 2026 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772622630;
	bh=NqNfQqjBGfmbAJo/aZtHMPo7003kq0HNHUa3oLLM9rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KtxESzLTRevMkC0RMT3EArDVMk2FhTkCghz7l84S/Sl/uRFMKbvYjBO6WKTPLXZG2
	 hDd+jtXTkQDCPlsNqrRNNBIS69FSEG3kyCqhhWldcKaA7lgmXmclpmibkTkxFDGx05
	 L1mWc9QOtddQl0a6TEhhiss3l8edtqg3iz0dJiofY0wVH+4yeCbYY1MzoD2oPWrjdR
	 EnDw2NjEjLAGM8p4Zym2vHqMmJuBYJNQQtn7Ix1yH9YiSler1bu8kJQI/BP/hsAWKP
	 HCA4EbtIlLqW3pzKVaXGzu0CeEXA+pozdgRHL7CTE7jTeamnzsicmpnlaw5LC2gU+C
	 eQD2mqeeLI41g==
Date: Wed, 4 Mar 2026 11:10:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Anna Schumaker <anna@kernel.org>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>, Carlos Maiolino <cem@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Yu <chao@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>, Jens Axboe <axboe@kernel.dk>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Simona Vetter <simona@ffwll.ch>, Takashi Iwai <tiwai@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	dm-devel@lists.linux.dev, netdev@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	v9fs@lists.linux.dev, virtualization@lists.linux.dev,
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 5/8] spi: use rest_of_page() macro where appropriate
Message-ID: <e731e101-bf06-44d7-ac91-0756c5b8bbc8@sirena.org.uk>
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260304012717.201797-6-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MuL6cN1k4g/DbVd2"
Content-Disposition: inline
In-Reply-To: <20260304012717.201797-6-ynorov@nvidia.com>
X-Cookie: Take it easy, we're in a hurry.
X-Rspam-User: 
X-Rspamd-Queue-Id: 325F640008
X-Rspamd-Server: rspam08
X-Stat-Signature: g5dimy189eftksmcxbcpexrbe779aafq
X-HE-Tag: 1772622631-922305
X-HE-Meta: U2FsdGVkX19TF1M8ftEuSPwTVTBVMHZpKOo09zSZR+rg07fl695oSPQQD+mlXkxJil2Vpk/ar93yU6PugF2hH0BlGlBKoryZ6S3pLTA2BctSK2MCwZckhgJTOOJsQA9qOVadW9qaaMslcflMnlOMVUiPKzzL/tnsCZwV7HGuskay+mYbdkal7WyTq5vpIjnROE0Ce5h3JvNlBnGUaEogxeoMpotes9gLtfs1FhMAi7OOdsAbfwj8t+e2dT/uu1g11quMcsPoKp46+nZczyfFhzHv6n2m0ZMqx5pSPe4cgjkTX3gpLndXH+t9H96t1/H06p9h/k30Ab9M0MoO6eM7b4qx4dt/P+qqG9yJOD+ikhBzZDP6mgdSt6j6MF8G9KrHco4Vb5gqncfZSfhY+EjD3wO/H7RVO74e2wFZCYmfeNBBB34UohsurQxKvp8WvKBU89w42Rbq4ePklTkMBcg2WaBHemf8xfKMFCQafLVbx4bM1I1aMysx6OdIKlaHHSvBvjMBfeZA+XVnZ85DBcRzPEXHwnmHE2/rbC0ee841JA0c6eeHzIpfpQ7XkaOwfrr896juNVea0ZrakyFKIqPacTcYceZrtbC2YbylWAQMWBC6shLWqGairMx0rTqovqX5T4ljuBuOhvtuHCMihGp8Uy+DizFkbHHj8SHty4Di4U9s6ZF4D373hw5qVzxv4Q2FRc1iqcbtK5DDy2A4mfEaAdkcp9cAwRZs4+QfUwohBDsWDJJgm+4XFU3G9f70I3fj0hVZQbCWUhLf2eLGO/CyY45kLY3jytAN5XMv/yDDxyseQmKP7AehJAGdxEiAhQ02NqY0v2CqXFBjBn/nfrG1s9ZamQpAqH94Xx52jjGsWh9EBoJh5hEIFczAEFZ3WLuK+mOoqzmTRYHV+kYMjQyxdCXAG8Rz3aJzKcwKy5/K8cAzIOxZAbLM5zjwwX2aIos2AYJ3LT8YlZzVj6q6au3
 oZHXEc1L
 bQztPFE+nDszrj+nQBPgwd9B6RuR50UqGgJ43tuigYJ1uClfAjU+fSTRdGEsOCKs/L5U43sYy5ABAIwxSOtpRZ8a+3/PIeg8nOePaLyIndpywwpvXOA08mp7Q/XwDGqbREX+KK3y4c/ox+mjqE+yidi38Jin3XOcauj+OSz24BGQY1remNBomiw/t+ngQH7m5uqvHwkkbHhuXYRxrWQE67cUrZ5msHEiavf8RbwDOlQPsPW0Tj2lZRrAI6HwGEHnKse2QGTQOXUfPYamJMP7D0AbENw9JOZir7MulMruiv8pkeAjUIf73psROpJMQyyiHxQbpx/hv+0f7vBKB/p8FCVobdEOCL62PAxTHfO+efdrIsYJKozSZioheKhRPxDt99Vh+32xCGsM2tllNT5/9q1pK0Cwjs2hYwxla4vC2fmuY/RNicNXmWYYUwGFUaVKrRlg9TadC35t5w3anQGQOaqfKrRkG/8PgmloIRok2AF2pvLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--MuL6cN1k4g/DbVd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 03, 2026 at 08:27:13PM -0500, Yury Norov wrote:
> Switch SPI code to using the macro. No functional changes intended.
>=20

Acked-by: Mark Brown <broonie@kernel.org>

--MuL6cN1k4g/DbVd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmoExQACgkQJNaLcl1U
h9CfwQf+I/XcN+BTYZLFcHPKTZ6Gt21+q3GLOzdkgChqzxOybf6b2qD+OHDN55Te
HvnosWIFzWzrD0ZP4eNe1TE0j1djIs+y2hdX6fElOOuJijsn21UWvVZXuuGdENdA
tPZDWrSzxJ8sU12FFYyBJDxsnWysekc1llPy00e37sfeetOZOLaYg/1jnttOl6oU
a3i0DGlMSVCN0pIYah+1R5Vbe35l4DlrcyOoswdwqqqEAzPLr0ysycWbbVmelm0M
U/y3gvpx6ZZBlMMio/3WWZfu3pM/Kwc8nzHkdzsstdqSIsRHEWru1MF5W4E+IcwO
Id51vK66wgwDVauWcfBpUUDez8/oEA==
=1DSJ
-----END PGP SIGNATURE-----

--MuL6cN1k4g/DbVd2--

