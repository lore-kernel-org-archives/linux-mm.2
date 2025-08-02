Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30634C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 16:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA616B0088; Sat,  2 Aug 2025 12:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5899F6B0089; Sat,  2 Aug 2025 12:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F3E6B008A; Sat,  2 Aug 2025 12:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 393146B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:14:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADCA51603C5
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:14:43 +0000 (UTC)
X-FDA: 83732315646.10.D11FBBA
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A39540008
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:14:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qirtRJzu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754151282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQi0fWk3YfJmTZmKB8Bc3+B0LEM33jmc0tPLhuawPcg=;
	b=6S1EYy01TuwJ7thTjXoX0d1+VVFd33ynhwCxkBnmQ4Mpe2bfNKOH22/R4Zf/9bSPlwyily
	ZVtHIabuA0JN6HPDiM1DsJ/+AZVg18gK12nPc16VB23Ss1eUXToOCYpLukI+xKDp0568e+
	OMbQS6oirS8hz5eXFUF4IdbEIudJgRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754151282; a=rsa-sha256;
	cv=none;
	b=joBPRszoTRiA1ky/hB7OP6ED+tttlpNRxcS3tCUCyEvyPvsI2qLIbJUQ8QhUEBefJwaakm
	589Paoh7IuByI/bjQz2Ev43iNzehREHfS2//4kjJqZrnDgEpR3UnCVDBe5/h3bqJe12vnx
	1oypEvNnbWUm0UCDR9peJoEBL08UJoY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qirtRJzu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 08FF85C5AD2;
	Sat,  2 Aug 2025 16:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7305C4CEEF;
	Sat,  2 Aug 2025 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754151280;
	bh=cfIzk7b2hMmb2yuGteNfAWnIPFAYZAQL4GuFIxDTKr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qirtRJzuaVFN2hHIijBX4dukz0mPUAzNI1OLrpc1c9nHnf6mDbOfaNLwDoLVd1zPo
	 GBN05msXr9H0XyK9K2d4bZDQIP07hydBo3IoZDK4eitc4Xl49SfdqRzSud8QvkV8UA
	 x+Ek4F8h6I9lgK9NpzmCCydIEtnTmeuuYCY+RODgDyp6ceP7fvJYXp0mvm3JBaCoPd
	 4yf2uOYgQhT6WvJBd4dy3tqpZ9hgMP4Ihi2iIUpsj9u6f7y3P3aRYW5Sh2byEto3NE
	 +ZEPnPdv2HJynBYtvTkMiHpGfe8a9RMtyFyMgoDEXDFiiKiBDUKUbgCCGQSLZ0hxd6
	 Xi8xRi01QdA1Q==
Date: Sat, 2 Aug 2025 18:14:32 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jan Kara <jack@suse.cz>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <c7aoiolzxs2yiq7gocjhsaxg4nsjej7bqcy2cfkfynkwwiwd7l@dfz5sq7hylgi>
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mfr5qafpnm3rr7ah"
Content-Disposition: inline
In-Reply-To: <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: hpu6yresaxjxr9zgmwzjgtx37fn1p6qn
X-Rspamd-Queue-Id: 2A39540008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754151281-40687
X-HE-Meta: U2FsdGVkX1/txKlQ7plTZ/i8VVSoZCHeWyBsjGY97RTbpFSqAltzEBVcTQbb3HFXVl2AGHkma99RohIQoThSUSN7zgY7EszjZ3y5BlkuEA1uvN+0wFMS3VXjUR79Uw4J9aqQS+CqWroUPiVEqdxAUiJZ2HDq2sq9u59gjAI/fYBML5lkWaYQzFdUZH1jXP8V2VdFjsIsfZEXkbya0IBtleneUvQ9oAYldKVecCaABO0VEkZYljXQ7UCPA1PzGFClsU2za5kG39thHbkocmPLLzL2BmzTwEUAB/K/i4fdWEFOt1RGgoRqCM7co4gGtqvpwVZMLOy7Ls1QXPVehAn+pjLofH0SfG1L6X2zeploFC0TntzpshiUN5+giA0JMtUV81rvgUGRT65Rey0Dr/gGy3dwIb8AQu5JFp0COBl+6wQhPC/HXP6uhekffq98NtZ4RBnIGKldf9EEGvxm9/n1l8tnTMHt5ow1mRKxV7WF7kF9qT3ahIkh1J8M8R/UnBPCzfcpraAy3a3mjbZar/DhUkAYmdYHUo8QDKLp0NWkuFMlk0kbJWDbewyt7Qg9dxL3P0Xmw49i9y+lvpegnPcZEcvoYgo7ctr0sUr0fQ0VBD7hCGxGQi8q/TYnuAfHSG4LifIVLwGGshkKdeJ7lFMuae+eeUTvRPul1gFftXTotn8d8lE0UnN5X+op/2JqLDRr6TNb8A5EnM5M1D5jt+qGscjDgrtCVmn3SktRf46iVLHax99cgavcRht1N7lgcSLQbVm5/8pPBoYF4/dbWKAbtCstbqV8y3GTjv83yWORFqK3utXYNc2AHmh33O29Qfszd3Pz7Pq6eRKJScUk7B5qQIhYqHwZjp0xmiEDyGhtClTioj03jfkphSasrI2i/PUWuQ6m9x5jnxv1g7noifJzR9VWDYaPCPQWHuczWqVx3Gc+MhUriJ+MUBHpXd8aaffQlNHwHRSMQ1VGfnaYeAo
 w1xbBS7n
 ZXXFkkb1WKN2sppKQCiZxDDK1lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--mfr5qafpnm3rr7ah
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jan Kara <jack@suse.cz>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo, Jann,

On Tue, Jul 29, 2025 at 02:47:35PM +0100, Lorenzo Stoakes wrote:
> Document the new behaviour introduced in Linux 6.17 whereby it is now
> possible to move multiple mappings in a single operation, as long as the
> operation is simply an MREMAP_FIXED move - that is old_size is equal to
> new_size and MREMAP_FIXED is specified.
>=20
> To make things clearer, also describe this kind of move operation, before
> expanding upon it to describe the newly introduced behaviour.
>=20
> This change also explains the limitations of of this method and the
> possibility of partial failure.
>=20
> Finally, we pluralise language where it makes sense to do so such that the
> documentation does not contradict either this new capability nor the
> pre-existing edge case.
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

I see some very minor formatting or punctuation issues, but I'll fix
them while applying.  Jann, do you plan to review this?


Have a lovely day!
Alex

> ---
>  man/man2/mremap.2 | 84 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 11 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..6ba51310c 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,18 +25,47 @@ moving it at the same time (controlled by the
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
> +Since Linux 6.17,
> +while
> +.I old_address
> +must reside within a mapping,
> +.I old_size
> +may span multiple mappings
> +which do not have to be
> +adjacent to one another when
> +performing a move like this.
> +The
> +.B MREMAP_DONTUNMAP
> +flag may be specified.
> +.P
> +If the operation is not
> +simply moving mappings,
> +then
> +.I old_size
> +must span only a single mapping.
> +.P
>  .I old_address
> -is the old address of the virtual memory block that you
> -want to expand (or shrink).
> +is the old address of the first virtual memory block that you
> +want to expand, shrink, and/or move.
>  Note that
>  .I old_address
>  has to be page aligned.
>  .I old_size
> -is the old size of the
> -virtual memory block.
> +is the size of the range containing
> +virtual memory blocks to be manipulated.
>  .I new_size
>  is the requested size of the
> -virtual memory block after the resize.
> +virtual memory blocks after the resize.
>  An optional fifth argument,
>  .IR new_address ,
>  may be provided; see the description of
> @@ -105,13 +134,43 @@ If
>  is specified, then
>  .B MREMAP_MAYMOVE
>  must also be specified.
> +.IP
> +Since Linux 6.17,
> +if
> +.I old_size
> +is equal to
> +.I new_size
> +and
> +.B MREMAP_FIXED
> +is specified, then
> +.I old_size
> +may span beyond the mapping in which
> +.I old_address
> +resides.
> +In this case,
> +gaps between mappings in the original range
> +are maintained in the new range.
> +The whole operation is performed atomically
> +unless an error arises,
> +in which case the operation may be partially
> +completed,
> +that is,
> +some mappings may be moved and others not.
> +.IP
> +
> +Moving multiple mappings is not permitted if
> +any of those mappings have either
> +been registered with
> +.BR userfaultfd (2) ,
> +or map drivers that
> +specify their own custom address mapping logic.
>  .TP
>  .BR MREMAP_DONTUNMAP " (since Linux 5.7)"
>  .\" commit e346b3813067d4b17383f975f197a9aa28a3b077
>  This flag, which must be used in conjunction with
>  .BR MREMAP_MAYMOVE ,
> -remaps a mapping to a new address but does not unmap the mapping at
> -.IR old_address .
> +remaps mappings to a new address but does not unmap them
> +from their original address.
>  .IP
>  The
>  .B MREMAP_DONTUNMAP
> @@ -149,13 +208,13 @@ mapped.
>  See NOTES for some possible applications of
>  .BR MREMAP_DONTUNMAP .
>  .P
> -If the memory segment specified by
> +If the memory segments specified by
>  .I old_address
>  and
>  .I old_size
> -is locked (using
> +are locked (using
>  .BR mlock (2)
> -or similar), then this lock is maintained when the segment is
> +or similar), then this lock is maintained when the segments are
>  resized and/or relocated.
>  As a consequence, the amount of memory locked by the process may change.
>  .SH RETURN VALUE
> @@ -188,7 +247,10 @@ virtual memory address for this process.
>  You can also get
>  .B EFAULT
>  even if there exist mappings that cover the
> -whole address space requested, but those mappings are of different types.
> +whole address space requested, but those mappings are of different types,
> +and the
> +.BR mremap ()
> +operation being performed does not support this.
>  .TP
>  .B EINVAL
>  An invalid argument was given.
> --
> 2.50.1

--=20
<https://www.alejandro-colomar.es/>

--mfr5qafpnm3rr7ah
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiOOWcACgkQ64mZXMKQ
wqkkKQ//UZnrcUQhjHzoPuHujQSIONo7V3EXvdkY+B88iP2nWGGtJ0hv+yOClegO
KmQtES8Tw3JB41eFh09zq9G5/xdmZeBHkAiVRoWkog/lnn4O5jd2mWHPMVSX6nbI
SaeJ8tjAg/XF7+97bT8qMcZ/MdYX3FCAbPl469IR5eri9+P6gDn3f3vfYm4lRykt
mpGybr3T2f+iEBba318dN04UImNcuvJr+IaS60Xh2KJOmSE/fofhNQIVgDwNgwkB
U0qvYwvtXx24/Lj1s24tXCYX1PyaeFJn5Wrd3cmdN1m5sAIat5VgHNA/ifq74oiA
C8iqNZasJJluJInuoviDF0M32hgZH6CDToCZobl41m0nygXMctFOQW3+I2JjWdSu
Bn5cGwZyc8opWTO/9uzBUpuj/gM2WI4jXIxIafug8VnF63D1baku5r1sxfW7W+9L
uu8e0SB2BjOhpmcicDa5pKZ7HYnl3m4TfnsVIiVlcTwcWMSHMbY3zHEgXj8icXWx
rtli7Ar4aEnUzRr5uvjeoo6RMWhZVvtb0gXfiKKYI/FUIEb5vilBmuRxz7NL7XyH
v2pJiybdbJA43n7WXZcNXnJd/munjHcdq8eiUz7FSFtAGSOV4BpCSddTPyG+rlY5
JQS92f/jTdzrDp7HFsc8/1xfD7joH9GHvxOoZTltGFrvBoCnbqs=
=c3Kf
-----END PGP SIGNATURE-----

--mfr5qafpnm3rr7ah--

