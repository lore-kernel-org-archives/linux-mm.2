Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A859CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A13D6B00B9; Fri, 15 Aug 2025 06:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950966B0282; Fri, 15 Aug 2025 06:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819256B0283; Fri, 15 Aug 2025 06:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629A26B00B9
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:06:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBE8F138AB9
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:06:02 +0000 (UTC)
X-FDA: 83778560964.02.4866645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03EC520007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:06:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sy2rO7FD;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaOYs1LkXInlSdXillJ45JnNkqickz4it7i6z020Dsk=;
	b=AJxI6Ww9EZ2ZctwgdvJaNc56WFyyVNa47FsQuCRUyjYK3IvZN3wMgRuoShlk7ysym6oSaU
	fzKnS5M/n11DPkU46TPSCOdzHvsSJV4mKvlevwPRbKZSAlR2MPVSLdt6dEB1m0BttxaiQ0
	Zwvn7YAQD/XnMLtjgz/q3e4GzjEvqKM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sy2rO7FD;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755252361; a=rsa-sha256;
	cv=none;
	b=0s5j06UZHy5QEdgtq1rka9MHmwU+uRn2/w2XYknwdMKm3Lbbu0hLbKidaXHae06G577xSe
	fcdlBTK2v4jciP7i3MJbi7+GOLGIQJvr6PAPWazN9bfgGifHB8KxC0v1mqUVyvT3NMRmXE
	SHSli/NdStmE+Viwy4/Kxw12InP2lT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C48B243B23;
	Fri, 15 Aug 2025 10:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87455C4CEEB;
	Fri, 15 Aug 2025 10:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755252359;
	bh=4kAPBiqBZAxCxAWIqIT+vr/yijIk5oAl7mKqqrCIIPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sy2rO7FDDu4llpFz5072JU6C/cgszHciODCkbRki++0+gQXvb6MFUExZ/dQrs6ag6
	 xS0K9396Iwmi7UJDbF0JBapKbPwhSlDQUapEhgjpef6asPhzyGrWw0USjgTARyRYON
	 vnzB1oHb337Dakjv27VeTywsm25dbCNT2sRFR9jZaYCWc1bSTXz+lwMCxhc8RzQEmt
	 jVcjMQL0BTwBbTR1AB9Ny/WC615OibK5ZGrPYvLs6sGjvLRIYova+z3PDX3EhStElz
	 1r06W6OcXZPHBd7FtEwivxo4bqd0OKhRLvSI3JLsWqO50k6sKHunnbSQZhUlBDtHLg
	 RnOu/SY4MRCCA==
Date: Fri, 15 Aug 2025 12:05:54 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 1/3] man/man2/mremap.2: explicitly document the simple
 move operation
Message-ID: <hxbuhtkuorfe5d5lr7wi5cny7vx6bt3kc2xaoknfz4h6vk6djv@kpgaur7636rl>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <0a5d0d6e9f75e8e2de05506f73c41b069d77de36.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="74b6lswjh7fvdbms"
Content-Disposition: inline
In-Reply-To: <0a5d0d6e9f75e8e2de05506f73c41b069d77de36.1754924278.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03EC520007
X-Stat-Signature: zyuxyqoo7dp3pj81wzqnbuksai8j6fxo
X-Rspam-User: 
X-HE-Tag: 1755252360-732770
X-HE-Meta: U2FsdGVkX19Iurgo0sVw88xHg68HQH/vIvmdk10wDlPGc/1CLloBNtOxa2IIgw9lXgcLum9vNm1DirFAnUnm48rqsLJGioJW75uVorVwaym6f4spmls5YRLEWtfz4U+Fxc7pV7QoBEnaJmFj+SSl/+5bGQ8kuJFCb6j0eM8at6I7ld7YFP1chcUYyVpeEFZ59PqmVji0vjXzDO+sTskyVjiyE9yQgDXrQUTLSuwa1cmK+DBmAkli01QV4J94G1Je7riI620RhDo/k03yZCZuyqe8yom5M+BB/figLIDJlp+MFxlwRT0TSC4f3lOk8EFBf9sz0N8PkMOBQIhtAUEyXxYFb5uS9r8JGeAsfm3w6I5Hrfu/SBNcecTqZsucIo8ipwcerPRgfPeX/Vrj6J5YDmxhPeCvMxD+lWldGaXHPMec3xWp0a+8iOgPrkv6ELcL5bv/pU4hNz5V+lPEW8Xce0e67/Fpkk5/3Adxn0p+uR2DaTFLK965Abfj/jpyDjT+hzfAXmZiUyscoqsLsANfi1mgo4V7U4JNbtHElgizayDCY8zUerCH4ltflTTobagALCEG7y70XqwGuEGuefMcPgyi4sJfxF+jcXaupymGC6C0fo0xqX4rXTh8p17jtk8+nrSMPrNVwMTsFz/IjnmS2XdQfLkxUSEnJYpdACt9wa93+m0LxnQG5Zhhz0yYHHR/dvvOjuSoPsFn5inawFhKQOa4zv4UkqNQDvqZQA6le0lA3z4lkEi3RklPM3Tc+XS+uTA4awsOOFsSTZrWvA6ZtTA0qENKpuQTlJfqBJOd4DasBce09JCzeLnqHBBWLSoAyGrJRv6WTf7RL1staNasL6qsQkTU4vtXMQOCjzH32obn0v2x9tvF4qcViesXkEt4bF/ABCXCp6E5/XqwErSHbbr9f+ZodOxbHD137oTj+BDm0gu9RNfq51PCr9wHq0SAJ74sXuje4ASxJfS3R7j
 Pu74Dsoq
 mb5Cahm8D9R4u4ZqKaJXR1musknDkovLZtImfPLXMsd8+mve6d8Q1n0CrncvoY+uljrkztATHpC0+/vtAg7OnJ4hXT0SqufjwbxmEoQZO+q4+QqidLJmlA/vlZsRJpFjlarPN3zBdYWx6wI4c0Es6d0w96m5GBCnPkr3THbXGZtahazwn/F8aOLjzI1XzWsgKGirkuNuOGCtkizigqz+6AEBaBLu4dWDFzZKTxpZBSTIFIZ6aMAVG9muyIlPARIxr0tUYNbhYHfd5cD0AwMVAeLjSS7/OsU/7j8Iel65CH8xz3tGxsL1B9GuhOjiLMZUf2sY5yW6i+VY8kR7HS26mYzbQk2vQLnU6fDgx2zbgwJnhX64RORjHlpK/CuK9ft1/8NaY8DPQNCZq6e1QyYVeL9+wHQRbT0FtDDiXAOrD9hQCJzPj8dYwQrJbxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--74b6lswjh7fvdbms
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 1/3] man/man2/mremap.2: explicitly document the simple
 move operation
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <0a5d0d6e9f75e8e2de05506f73c41b069d77de36.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <0a5d0d6e9f75e8e2de05506f73c41b069d77de36.1754924278.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Mon, Aug 11, 2025 at 03:59:37PM +0100, Lorenzo Stoakes wrote:
> In preparation for discussing newly introduced mremap() behaviour to perm=
it
> the move of multiple mappings at once, add a section to the mremap.2 man
> page to describe these operations in general.
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!  I've applied this patch.
<https://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git/com=
mit/?h=3Dcontrib&id=3D6ba37b9e14f6565d0cccecb634100d7fe11d22fb>


Have a lovely day!
Alex

> ---
>  man/man2/mremap.2 | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..4e3c8e54e 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,6 +25,20 @@ moving it at the same time (controlled by the
>  argument and
>  the available virtual address space).
>  .P
> +Mappings can also simply be moved
> +(without any resizing)
> +by specifying equal
> +.I old_size
> +and
> +.I new_size
> +and using the
> +.B MREMAP_FIXED
> +flag
> +(see below).
> +The
> +.B MREMAP_DONTUNMAP
> +flag may also be specified.
> +.P
>  .I old_address
>  is the old address of the virtual memory block that you
>  want to expand (or shrink).
> --=20
> 2.50.1
>=20

--=20
<https://www.alejandro-colomar.es/>

--74b6lswjh7fvdbms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmifBoEACgkQ64mZXMKQ
wqk7Dw//WsFue4bgugB0w/7GXyXlaPczRfrhaf0n+tv2SeXMcBgc86x8YoLB4O5g
6WGu+m2Eei9AjViA6W0UlnBIXGsWnUQHgv+8tqA1vfEcHDSfnh26kh0gMTlMPKuq
wPC+o3X6F6srlbiY2/l6YbvpgNn/V1/23h6LaiA4jBcilL5nB5lcHOInkcc4y7W3
BFnXclPsmRQGFnWrRqNJoE07RH1g0muQvpexqVi+rcaxwtW6nO7agU0BF6whMpzy
wP2dVSETSUWMBBa1pKpcsnPdE+6R84TKNFFYj6xIICN/fTWwnuVst9SOdiqUKN6+
NhPp7Vo47d73nH8levpw0VrkNY6+8kLq2Fm6bOnyqf5Xff0w7FoHJx0D3QlSqWPN
efKViQY+D2uu8tvT2PF3/goFNUH/08EE/TUjxIUbqTFzi2H314yyEWX0YNIqpZJw
/7EBDvp/yoH+GPbzol7Onz7Y/G537Z2RG+MEbazZsV7IUOVcXkrFvcVq7KR4/TlN
NgipluT+5TEClK6gyp58v4RbJm4SFeSRl3tlx6vXfK4cS3WF8QpsT6K8arwTEFnF
sLx3IpEP8cbUrxISi+hGt8VyxqkL6kFatKsWfF8pRsD2Njwe7yNBzYuG8+9SJ8dD
PZtV69UE04m/D2yfesaNy+eYsIYEtV5mlNOHMMIUZy68hv68XTQ=
=hIne
-----END PGP SIGNATURE-----

--74b6lswjh7fvdbms--

