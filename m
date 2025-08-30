Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A17CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BCF6B0006; Sat, 30 Aug 2025 00:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153856B000C; Sat, 30 Aug 2025 00:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090936B0012; Sat, 30 Aug 2025 00:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB0776B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:45:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D4A7C0AC5
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:45:50 +0000 (UTC)
X-FDA: 83832186060.02.2F2AB95
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by imf03.hostedemail.com (Postfix) with ESMTP id E270F20002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:45:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=nI9sURvm;
	spf=pass (imf03.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au;
	dmarc=pass (policy=none) header.from=canb.auug.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756529148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pt3u/3dhlv3xp9vGi7l7QuBrLsn5dvfeg+GgVr0aTXI=;
	b=WRSzWXtfck7NT1cZyOPK+vm8KG7wAvZxjtt2oU22hnpUltbuq6xGWwNUkVGnNHoqYYNrut
	fRu1X4IV73oov/ygSXE35sYvGk+YZMR8gsvApsknAfzFGBhZH6kzLf7K1gWXKwti5jzt+i
	pI9pRcDW7u93DTf4RLzJf8Lz2mPerSo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=nI9sURvm;
	spf=pass (imf03.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au;
	dmarc=pass (policy=none) header.from=canb.auug.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756529148; a=rsa-sha256;
	cv=none;
	b=UfZgrQZrAoLv+5R30RHKTWCNCdJCLD/B5MA8ioe+131bv5CA6tBkbcFksbKLXBV99x8YZV
	dunMcI39T7fAZ012w5IpSJ3/QuQ3kj8RmEWlG2q/ac971wpLpFneXApUJ3QOTI5WTFO++b
	PZHCBxpOTD/deXGEsoqtpvWOTAWDu50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1756529144;
	bh=pt3u/3dhlv3xp9vGi7l7QuBrLsn5dvfeg+GgVr0aTXI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nI9sURvmPiBdyeT59pgCA4MQNUS93LYOQ/HVFYC26qyeyL2UX4B4GL3V6PNc5t86x
	 NgxLgK3fLChvRbEQwxirv4wuomxruaelO8l8UwumVA42VQGf4QsqqfeAuJn5wC37UO
	 z8SlawpKnMogSGqKMJZEWnc/Ikv/+1BOnFRgWcjgsSTqIJrEzSX2H6JdLcT8GYeTdE
	 DTs0D1dN848t2+HCYr/BTAkGcr38hDt/lnb73sKkOvpPu7FK1EO0FibhUBqFwjD920
	 gRCxBihmv8xz5Vxh2y5cqK1Kg3UD9HuaaLOjGjGTNqImA9ozmfnJZVnw8cLwNUF9WM
	 G6T16XnUTFzDw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4cDMyc0RkSz4wbY;
	Sat, 30 Aug 2025 14:45:43 +1000 (AEST)
Date: Sat, 30 Aug 2025 14:45:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
 Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Donet Tom <donettom@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [RFC 8/8] powerpc/book3s64/slb: Add slb faults to vmstat
Message-ID: <20250830144542.6ba0e774@canb.auug.org.au>
In-Reply-To: <e05ac86618d8a52feccf5bac99da44b11871382c.1756522067.git.ritesh.list@gmail.com>
References: <cover.1756522067.git.ritesh.list@gmail.com>
	<e05ac86618d8a52feccf5bac99da44b11871382c.1756522067.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//+ny8ES+6FQIgltakmfkGeI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Rspamd-Queue-Id: E270F20002
X-Rspam-User: 
X-Stat-Signature: nkh1ws9ykt1bsmcgxsger6kemhhgkrfh
X-Rspamd-Server: rspam09
X-HE-Tag: 1756529147-840637
X-HE-Meta: U2FsdGVkX19jcXVzuUFC6Jwxf3PtlzOSwC7+pK1YJWUFbGFKfN2EGia5BGCH+5WUhdo1h3wOQJp/B5nY1lMdk3mdk5qDqBM13kPF9RJgkkciJ/Ybm/6H4uOIkquxnD6Ge1hDLvptAY7xMFG/gfXm5jMR1goCBzm+7uESluygxgJOKzBosr5Y0FZsuStAJpN67wRF/7oFKDjcK+T6av//v4lfWCGMdqqyYKdGcRXWnY3eLpJ/SY8uapQ0dOOKQou49X89zhkpVhAH2nRhgI4iGexn1idoeld285JUGsXzBWqzfkdqM9ap4Mmnj+wBva0s0fiPI1ik3RhStgEoPyHzvKZOURKwlKM7y8lO22PXiKSxjRvALlqh/wpj92gtM68y4+2VRs77jD/+w2BQXI1eOrLmy6NpJAtLdSEdJaW8XncEkqrcCrtqCMQOtVAjtpl95LA4/f0QuIATDzVHd6Nv8kFl1ptICDfmB6lMi0dImEmyCXL24zG/Q3P/SevWH9Uyf9Pv6mtigJGlmBy9Cmx3JXC5JZGL9o/VQc/cb6HABFW0WRHeQX8EygILJt9wFdlbXNczIF98tFKZ3QBFZCfzMdaHYc2+AQwPK/5u4cQrypNsfMnMtSwEmjfpYmX6mHh/CoSCUBWQ0spw94fH6Hv6EiEdJibGJay+o42MLNmF6pd19ASx4nkfkn/eraY+JJY8BcGtzgBft8TFHUPktoXjkbAZ3q8IVmbBr5Fnf3We34Y3P4IzbSwn3ISa3B1OfvVWDv1hORqHPLPGYoIvHRfAAYYRfp9oVjf0cKaRBXnafllEOKaM13GiBJaarrNuYchu9qQ+vGEZvJ6lX3tlO39B732AnwjpETM2skVo2JVkBxlBdALxAPKwmkfrh8iCKitloRKSQckN0CCSN82mPFs699rlIh//d08Rf0RioJDKzw8k7OKCMKns2eFpKLz/HBflRpTM6pG/cFKlUsEgXsZ
 +woHG+g7
 wmO21iGrw1zbxP+kEUGVQqGwayvL35I+vdC+8+f00WiI0GpYPolpw83UZzL7zKeXpLUbM8Fr/Dl4hbHuFWUyQ5qNgRjj9tw2uq30qgVHC2jWmSDHTcuLcHf4C1/FO99Cu+YSJE/tOAXjI6tgN04uwcb0Z+yHq29ogbWgKVIyAqtqhj8B3wE9r6uW6mhqQIdANSgxq6TOXylxP4ggFHZeOyMt0zg+Da/+zNG6abguH0D02uJ7CQVylHPzq+qL3/sj6X2McUL15Ve9EDQrM/aJ91ECWc15YCrateMIDgAfNj5YZAYy9aEUjOSr+DncxLVy2dslJls7jesEPmT6BiZyssOszcCY7WEc1TwWv2SPfkjvCkPCHRR2imi8+USqn7NxiDsPysxP6ewBPce9npfVvRyS46NRZ1pNm163r/K9MUV1+oTnK/v4dn/u/OG4vzWrSUNTowUBT0j4iacCbM7oZoPbCtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_//+ny8ES+6FQIgltakmfkGeI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ritesh,

On Sat, 30 Aug 2025 09:21:47 +0530 "Ritesh Harjani (IBM)" <ritesh.list@gmai=
l.com> wrote:
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 71cd1ceba191..8cd17a5fc72b 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1464,6 +1464,11 @@ const char * const vmstat_text[] =3D {
>  	[I(DIRECT_MAP_LEVEL2_COLLAPSE)]		=3D "direct_map_level2_collapses",
>  	[I(DIRECT_MAP_LEVEL3_COLLAPSE)]		=3D "direct_map_level3_collapses",
>  #endif
> +#ifdef CONFIG_PPC_BOOK3S_64
> +	"slb_kernel_faults",
> +	"slb_user_faults",
> +#endif
> +
>  #ifdef CONFIG_PER_VMA_LOCK_STATS
>  	[I(VMA_LOCK_SUCCESS)]			=3D "vma_lock_success",
>  	[I(VMA_LOCK_ABORT)]			=3D "vma_lock_abort",

Should you be using explicit indexes and the I() macro?

--=20
Cheers,
Stephen Rothwell

--Sig_//+ny8ES+6FQIgltakmfkGeI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmiygfYACgkQAVBC80lX
0Gw49Af/UHUgpgla969YKk5hog5zPrUt/pqZeUpeCBxUuq7MPlxJcsYXGimAWpRt
0t3emvmvxMn44bEq8pWIIMC/I0zQs5ot02U2idYBNrms/QOyZUPtMOqh8GoqC12R
ZaLygol/LLHTQNnSPKQvTby9VIi+x65d89xiAaaP011YM3Ely6npbON2M/GSAp2e
QxGPXnTyweD8LuTfg5WO42gfR0tZT4kmiYXenIKitwq+etMK2a1aRW363/qDl8JB
hDdJ5MsslmTyrgEIWGZf+oU7KQaW3tDpyVi2G47z3jC4yvoFAM3Zb5aRvaT5Z5/P
ruWRI29KJGH69tamurCkQo92a+Bo8w==
=fKMP
-----END PGP SIGNATURE-----

--Sig_//+ny8ES+6FQIgltakmfkGeI--

