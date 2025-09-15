Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A0FCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603588E0008; Mon, 15 Sep 2025 13:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B38E8E0001; Mon, 15 Sep 2025 13:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9E58E0008; Mon, 15 Sep 2025 13:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39F998E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:04:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE50A1DF529
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:04:03 +0000 (UTC)
X-FDA: 83892107166.02.CADDA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16DAE120003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:04:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ECx+Kj5w;
	spf=pass (imf29.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LFeAe1ArwBGBNsi4MTIvvnMDyOJFlsOMyTtwxc5Pfk=;
	b=XINd0E5U5EXzYKOfKlc0b1N+K9s/qmtvEF/4ILj5ssmVRTWZ7MLb0MSznoooZ2dFI5tI+h
	uANZLguqDd3O0la57Ga//xmBbsudwOv+QWpGnJFjDVQ+qZzDJbrZN8h5WSipBCAzFpJRAu
	onl0/ZHR2ZXUsxHTKUlJUetFL/dtxag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757955842; a=rsa-sha256;
	cv=none;
	b=Fx6FwMJFmtJTeV8ACUmjNWoiuTkSVc7Ff2Mi8C67ATpxEfEUWxgL+643cY29vMeL7DzFw2
	4kbyFSIZaxF7lIpr9eqKE6nNnqRyrwF3Du8evBwd4u4SZrDdOxTxtDvQYOCv1bjlBny6hK
	inpJEmQRsZWwVXtFPDJLv2+KJUB3JqA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ECx+Kj5w;
	spf=pass (imf29.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D95D344D94;
	Mon, 15 Sep 2025 17:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA0DC4CEF1;
	Mon, 15 Sep 2025 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757955840;
	bh=181A4EhfptUEgvkmfyOG1EPOfLyDWETtVkYBcXrHa9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ECx+Kj5wt0FqonvHZaoVS7UFjqUwTm7Wn3cnoSf4DK1LNun8/l9DlZJwILZFIXfh+
	 3w72zJ+PJ69uWw4UjqiTh9EKRbyxq5hsK7Bdt47WA44OnfB2oakBECDKiAwoncE5DU
	 zUdEPIWGxdbwhHJzZHnmfApdsTz/VQ9TEm4BOwNSBTYt3eBmxO9aB0O1oHHNocczZ/
	 /7ayJCAboiKBVT9Sv59fgnd+DxCUl+K/8YfrDkrtA/9Q3CFfiuuplm88pDf5IpQZMD
	 BrTFlYLhObQ7aqM8UhzUPBsjj4CYlrh/EsdjQHZuQleXs83Y+22NrNXZYGFuAF0Pgt
	 +BBkvp8qVwh6g==
Date: Mon, 15 Sep 2025 18:03:53 +0100
From: Conor Dooley <conor@kernel.org>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V12 3/5] riscv: Add RISC-V Svrsw60t59b extension support
Message-ID: <20250915-landowner-parsnip-d6778ee7208f@spud>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-4-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W4tzl3gVaVkMEf2q"
Content-Disposition: inline
In-Reply-To: <20250915101343.1449546-4-zhangchunyan@iscas.ac.cn>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16DAE120003
X-Stat-Signature: 3fzuueun6hpopj43ion98y6xhkmhs5za
X-Rspam-User: 
X-HE-Tag: 1757955841-57979
X-HE-Meta: U2FsdGVkX19+L0n/YepuhEPGRCwUbHGf7wdAxi+WFGkn6RTWRHt69T3M56UusSmFjB9WbwXrI6+jDMg3pebOoeqnLEmwhQSuSxn1eQM1Ne88Iucnt4dhH9+zldRVQasz9tqmJ7f+cN8KEmLhslY6P2ASr46Z3AHMjyepGtM9TfDH0lzv1NZn1rjNR+9D9ZJ4mWcwI1vDg9ki1aHRP/Wl5jzpdq7W/r8kOPNwXDFAfn6t6usvhLC+rQJad55NUOrQHkXpfBuTxr6Pz3G7H/oA1PdtF3gjxO4a2ZLoL/qvUxgONpL2Y6yZM5Prw80+hg45yYWRpxU4vHBnY0iaVFPzdhN+ocuHmGwD+I+mkQ3J+VbnpG0AJBLgZEpGVbW8DEgu6HalKk2C2fKLBCXGKIJmDGmDZGXk2/ZZYcGYLK24+DzTayWD+uBrk+KyJXNFHsHXUa4xuHJH/7bXxxjXL/TbQxWZunxDQ935M4Bn+57gjaSqXyZv6FJhAxJm8Eb40AL3v84T6pWlIgg5Lxt9qHotW9bGkvLxkI7ma1CcnwZkLVVLjJRto09GU4fPK45o0UaFKTk5GSYCBxtJxLMeBcYOH+e+bNCW7mH0rlXFedU8yUiw8JWIszd2w8I0McrZK4uN4yvQ9a9XSRDFk8xqdSpZuw/KY1IJVK3XssyXPQrx1Ch5mM+qSyiAy2T9OTolCTlUZVq6N7FVsttND7fFRuDQGze4/+UAJLRArcwkeJWyJvhlIavktB7GpkzerRkYhAkNOrIbIvXWlQxDnFwe//+mxrd5qY4hTfnbOJnEqo8Kzcwt2ojj99ugkCKAQy5abdlZZeTTc3CFVcA8FwhuXf8EC9To/cA/VlEAQSuSISda49LveviOvkwyj4SSTye08+Qe+vvEOkcnRr3y30PndlHXhGd3OrrA1/o44yRywGf8bXHGrIS1phGR/WCZjbOvvfSjEXDvKgHgSdg+Kuxfu/j
 DfXmqWt6
 ekjMT0pWXtCjkk3n7vaWyA706zFtHKBGDRP6eWUEdkF6JIBu3CFF5b9AN6ejARSh6q2Rd0adkU6vb/y2ggPrhxn0neTcr/CS67xXRG0JUvDcvBmqr463u39XTUOMH7bWJlAXodUNdWxNZmCp0u15mPeSdU6AwIs5Xs4NyhR0uBgh3a8/YA9yK/k9szjkdNnAzOCHv4hdmKBN1lW+mjNA+JpZ9ZZIoGawgghVnAYUJgXC0xBGZb7kH0cGHJidE+yVu+6L6UhRCFfVX8nD4NqzYXfVKm9SRNmcTSLyVZqqLS7O/ebPdmQHeDKg1IAgWQmoqjxp1T4GfepvVYGv76YnaelMs3zOWU5oWGlDM9HYfm+TdRLewiH+Ue6hQeXNOtXigE7/kuKPXklVAulzF82RQ4aw80ZAo3/ZydxgnMsW6xmnnZh1UHvJjVGaGw/M3SFHJI0um2FMjzNSzuf4TlNBEZnjaMY1y/kYtazmZC+mSRMDz0GO0IWHOR3M1Z3HaYJWCSAq91x2DnGLzBc64CV8qDni5MmHql6rf14ve9QHM3kkdGXGMEUnYkMezxiQMgnxey9fx4bZ2bAjVDDQlPRmYO3nDBpmuvlxZlQ9v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--W4tzl3gVaVkMEf2q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 06:13:41PM +0800, Chunyan Zhang wrote:
> The Svrsw60t59b extension allows to free the PTE reserved bits 60
> and 59 for software to use.
>=20
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  arch/riscv/Kconfig             | 14 ++++++++++++++
>  arch/riscv/include/asm/hwcap.h |  1 +
>  arch/riscv/kernel/cpufeature.c |  1 +
>  3 files changed, 16 insertions(+)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 51dcd8eaa243..e1b6a95952c4 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -862,6 +862,20 @@ config RISCV_ISA_ZICBOP
> =20
>  	  If you don't know what to do here, say Y.
> =20
> +config RISCV_ISA_SVRSW60T59B
> +	bool "Svrsw60t59b extension support for using PTE bits 60 and 59"
> +	depends on MMU && 64BIT
> +	depends on RISCV_ALTERNATIVE
> +	default y
> +	help
> +	  Adds support to dynamically detect the presence of the Svrsw60t59b
> +	  extension and enable its usage.
> +
> +	  The Svrsw60t59b extension allows to free the PTE reserved bits 60
> +	  and 59 for software to use.
> +
> +	  If you don't know what to do here, say Y.
> +
>  config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
>  	def_bool y
>  	# https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommit;h=3Daed44=
286efa8ae8717a77d94b51ac3614e2ca6dc
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index affd63e11b0a..f98fcb5c17d5 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -106,6 +106,7 @@
>  #define RISCV_ISA_EXT_ZAAMO		97
>  #define RISCV_ISA_EXT_ZALRSC		98
>  #define RISCV_ISA_EXT_ZICBOP		99
> +#define RISCV_ISA_EXT_SVRSW60T59B	100
> =20
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
> =20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 743d53415572..2ba71d2d3fa3 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -539,6 +539,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D {
>  	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>  	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> +	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),
>  	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),

If this is not ACPI only, than you need to document this in the
extensions dt-binding.

--W4tzl3gVaVkMEf2q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaMhG+QAKCRB4tDGHoIJi
0owvAP9m+kVfXRCCjk7NRGmDZkEWZQj0HAJD4FE/4xEk8z9WfAEAkX7zbB5CNqiz
ha+ygzCsG/SA9BdVUSZUo2x+PGGLIgo=
=YrBp
-----END PGP SIGNATURE-----

--W4tzl3gVaVkMEf2q--

