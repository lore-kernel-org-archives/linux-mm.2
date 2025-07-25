Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F04C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 20:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722586B007B; Fri, 25 Jul 2025 16:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3596B0089; Fri, 25 Jul 2025 16:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1A16B008A; Fri, 25 Jul 2025 16:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 478406B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:45:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2A11133EC7
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:45:07 +0000 (UTC)
X-FDA: 83703966654.29.5D955DE
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BB3E10000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:45:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkW6DJXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753476306; a=rsa-sha256;
	cv=none;
	b=SGqGpyLP7FcIrNTALO3WImdFhhKGvQIz4VYJHI/UI+uN8QmIucBxc9fclxxYYeHXjwrPYm
	JCrQn3KKLTRKV2W/AxxWT2Y9cLvnDezhg44TRpltoCLXthYV6RlpE0v70KRfsFgdmM6e9W
	CFR7LwUlFyZIzvY6dv4/6cgGl1s8ZGU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkW6DJXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753476306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1OTk3ETtBybJPXtHQKjE6xAYFGNAjoneJo5BpcQLrM=;
	b=51bqUsREe+H5f1Qh2KGMEAtehCrx5zVTH85MXfQWHPGAxzaDkSCsW7a4I222z6pTUyasET
	Q5QQHT2ECa/3OgYucxF6CMZ90/p2XoPa0pdHNwQhEw/xxuX/NemJPXwXXTpBUbW76w1bsl
	bGM7YXlQyZrECHqBoIBJOEcJS8FkWHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id A5C15A5672B;
	Fri, 25 Jul 2025 20:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B2CC4CEE7;
	Fri, 25 Jul 2025 20:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753476305;
	bh=TSv9glcM2lIp/pJtvRRP9I3bMN+OB/xZq/jx8F38Ks0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tkW6DJXAKDLsx1l+RBedjJ0vpWFngIwAedKAK5fwco8NppOqSVQER76cRMKSHubT6
	 pri7WPQFezqRSuk8Xj9YBSXIDpmDRiXnwfEQZ3VA8HUUYrSp0p0llwR1i8dkuKGRSJ
	 XzSL49Zt4mTQvBluYsTyXiBKMQ0g70mAU3p6935HKrQaVDtYqXEspUGalAsbb2zr9K
	 4O/DU6bMBbE9CjlBTj0EgM73Vhz5sq3NHIR61+xWFIgjrLf8B9ppQEqpqfOattaSwV
	 PZE6uz0Wuv4kongxFFalADK0pbsUCMNBcLrQjwfiARgox0XF6SugndVdew6rbYCVG3
	 hFbwUd/bCnEoQ==
Date: Fri, 25 Jul 2025 22:44:59 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] man/man2/mremap.2: describe multiple mapping move, shrink
Message-ID: <siwe6k4ks44mvdzy7rmir2pmf7547gqxknuoppcn54pkh4lwdb@lko3ecfdjtda>
References: <20250723174634.75054-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q2kjujlkwk6vx2gp"
Content-Disposition: inline
In-Reply-To: <20250723174634.75054-1-lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BB3E10000C
X-Stat-Signature: rcx1nerw7ab3sncarrjug17mffpipndx
X-HE-Tag: 1753476306-32233
X-HE-Meta: U2FsdGVkX18c94nFCTZo5swnkFoBLhgw5hCm2K45e6kkTnouyKUBa2FWiX+8pbfhH0fW7CWRfgZlfiscNFdzFECQbpY72S8/COsN9XL7Qs12aTn7YymAoS5Q5ds2WiPVFvgS4SENy0RfWybbfc2BEpMSznReNteVoYJvOhhy8iCGTTM8JMAft42I2NsduyrdviGEOj5PZzbPhr1mr4wWClqGGKSEz+0uOyDelAkHDIDFeIC+pEYxG1pfcRP5L8eET/gdMEO0IjLislTt4FdNjfvshWPMntnz//ND0reF9wN30v5T0XgYNiLtIl22iuWIJJ28Smal8K2+hTkMPhLr2c7Y+ueQwoxmavA2w9C7fHQm+pfNj6HVf1Jmd1vHLmlpfgIeGxi2SZuJr/BAnfZbR9bAEEj5Vtczw6jcLDXwq3joP+/AxUpOmim8FijW2JP/hCQRaYYAY/0Bf9D5la+BKLnxjuHolF9uDGxObqvcnQwwuxBP7ejC5bpzTcGvyoZL8jjn3gSJI053ziHwqenz/LttbQzn+9JsqWMIw083HCORntCoR1TNWttRYmWCKu0LV02+rNCe8tBMfnzFjlGxdK5C2AjtNADVTkMEP1RyPmtaKPjjkPsxG8h1qeiSY5Wu/oVO1K5v3E/7sMpE1zQ/o1G1PgwLHiTro5l2KuxcPsWRjA5qi+19Fr8QvroUYwDvS3WsVJ+GXzRbIiOgpsuaE0KX1v4G6i2cYGuyu5kYbZWIUX7B7FGE9Mi+JtMFQ/GuVOP2z22HTyC2GZCy63VxaORh2xu43k4FZ49dFF9SEeHB1xEz0smKQ44nrc7EJHViSRuPa4rw+2N41hW5uFD4ShuvAPy16x2qjria22UNAiBOXus1+QWqHP68R3Ln4/b7ZYHl7PjxE8HnTRq+8t9Goh6B77rwyXUsuTgAyMQgwxyLrX19QO3etbU4FuCqV0viJY+4E4mVij71c0/YuN0
 LRJPenmx
 G6VlLj6l0Q4RJE+AuL1OoObcT/XcuKfE/EnKh0/4p/eXXxiaV1WYx90NmoO8F4uN1T37UcEu7H3ZKuVEa2E0Jj6GvPWtJ0mHqjY5u+YjOtRQAhjD+buoxDwscpniiwrXI1y0skZ4mNsiQQaMpU9uFG4lMvvIOcBGo/odBGUYCAwVn2tD2I2NwJWLPdNaNPnVBzST6abtuIoLon0FJrLSkefvlHKWY/WAnuVV6ev2kiiglEUzK0N7kHjuUZxUP1ld1I+oR8gTtzOn6a10ribFbsahoG4KsQjXpGHC0lL3fAzlMEvvsma5xy/8a1gY+x1TR3dykW933xS2Z34i8oH/q0Ko6518WR/CdsycIf3kTZNRTB0uD871z9iuntuWPfMuNRUG8LDao4PAgFzrVB2YodP4veWmI9h6h9n+fgb8iewvG3zJmdBbiNKsqkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--q2kjujlkwk6vx2gp
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
Subject: Re: [PATCH] man/man2/mremap.2: describe multiple mapping move, shrink
References: <20250723174634.75054-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20250723174634.75054-1-lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Wed, Jul 23, 2025 at 06:46:34PM +0100, Lorenzo Stoakes wrote:
> There is pre-existing logic that appears to be undocumented for an mremap=
()
> shrink operation, where it turns out that the usual 'input range must span
> a single mapping' requirement no longer applies.
>=20
> In fact, it turns out that the input range specified by [old_address,
> old_size) may span any number of mappings, as long old_address resides at
> or within a mapping and [old_address, new_size) spans only a single
> mapping.
>=20
> Explicitly document this.
>=20
> In addition, document the new behaviour introduced in Linux 6.17 whereby =
it
> is now possible to move multiple mappings in a single operation, as long =
as
> the operation is purely a move, that is old_size is equal to new_size and
> MREMAP_FIXED is specified.

Please separate the new behavior into a separate patch.  Each patch
should change one thing only.


Have a lovely night!
Alex

>=20
> To make things clearer, also describe this 'pure move' operation, before
> expanding upon it to describe the newly introduced behaviour.
>=20
> This change also explains the limitations of of this method and the
> possibility of partial failure.
>=20
> Finally, we pluralise language where it makes sense to so the documentati=
on
> does not contradict either this new capability nor the pre-existing edge
> case.
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  man/man2/mremap.2 | 93 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 82 insertions(+), 11 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..c1a9e7397 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,18 +25,56 @@ moving it at the same time (controlled by the
>  argument and
>  the available virtual address space).
>  .P
> +Mappings can simply be moved by specifying equal
> +.I old_size
> +and
> +.I new_size
> +and specifying
> +.IR new_address ,
> +see the description of
> +.B MREMAP_FIXED
> +below.
> +Since Linux 6.17,
> +while
>  .I old_address
> -is the old address of the virtual memory block that you
> -want to expand (or shrink).
> +must reside within a mapping,
> +.I old_size
> +may span multiple mappings
> +which do not have to be
> +adjacent to one another.
> +.P
> +Equally, if the operation performs a shrink,
> +that is if
> +.I old_size
> +is greater than
> +.IR new_size ,
> +then
> +.I old_size
> +may also span multiple mappings
> +which do not have to be
> +adjacent to one another.
> +However in this case,
> +.I new_size
> +must span only a single mapping.
> +.P
> +If the operation is neither a simple move
> +nor a shrink,
> +then
> +.I old_size
> +must span only a single mapping.
> +.P
> +.I old_address
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
> @@ -105,13 +143,43 @@ If
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
> @@ -149,13 +217,13 @@ mapped.
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
> @@ -188,7 +256,10 @@ virtual memory address for this process.
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
> --=20
> 2.50.1
>=20
>=20

--=20
<https://www.alejandro-colomar.es/>

--q2kjujlkwk6vx2gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiD7MsACgkQ64mZXMKQ
wqmHXA/8DAG8114OPhYz3ll89YdJ+SrCt45AJseHz/iZJXbsN8/SKPG5D3kIjRkd
fh9AkafnjJB6W7CVCdIggNBh/elaL9rS6tKHckRE1LPGHfnT39Qt4nMovwXFTfhr
IfGKpuRo6pC2icAWYw/2D1TRG3kWHwueO5IXQY8aRS/KYtBFjj3+k8MSVmiP/BK7
ZsTKGcd8G1UMpa2u8pmMmI3GJy1PFaog1WJV30pkW3TybTalzaLjQ5Csr4NZO1fD
7U8KgE2KZrCc+/qoZPC733NH6sMn3TWeiQnn9R4a5dQ4lJeSWsr7FI5094AN/eVI
0V2Lh9jUIEJXWCFdiS3f+gfg0MWvVGdqh9HQOFQJi8fNNQJy6/BUrrlofc1k90IM
cCMNeqrzGPuDrkBEC7hL6+WYu7ag9ONTinAWUs6R0Zi68ovJbFg/EVlvbt3EPOtd
8Bd4yXhp/5iG83Nlov7KKQjoq/5OVoaWpRBqgQ/Xr72DHkfVeeiK7UdV92tZW4mv
e+avwcX6F74xeIWCKsB6+1pXMKzmBhh5pAa6cJF2VuCC9EJcCQ03wSQqzJyoBO1s
Qf8koa58XPykw/mPFK1AlEfuCF0RNjCO9mbvWLjjTcsDhJPPI77+WR2S8gutiU5r
Q5AflQJCJnxjx2SCRkX9y6+exnODS8anHnKi7o3gYp8n93cFAiw=
=AP9b
-----END PGP SIGNATURE-----

--q2kjujlkwk6vx2gp--

