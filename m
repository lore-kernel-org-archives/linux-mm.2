Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26469CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A474E900253; Fri, 15 Aug 2025 11:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F79F90024B; Fri, 15 Aug 2025 11:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFA9900253; Fri, 15 Aug 2025 11:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7599A90024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:19:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DC4380A01
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:19:50 +0000 (UTC)
X-FDA: 83779351740.29.CBB57C9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id A85BE16000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:19:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bqq8GAN9;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755271188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSep6zmtwALbD46jfMFGC+OGbR+UGocVZFCron39bn0=;
	b=gDjFv8bkN+wrAxAv5gPmOY0XA0XA9j2GdY+ySqI0epwBG16Ud7SFFwmZDh6u7N2kgBjLDW
	95L2cisVmycSIIxCugRcRkrJBYIP3WSugWURoJsSmt3Dvooh4IgDJcz9GoqGO4AeLYTMdf
	anHX4VJtJzzhlPl0ST66VM851m43lXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755271188; a=rsa-sha256;
	cv=none;
	b=jII9L1QEsc3PnRycNo4+BsFqZpOXhnkiMbYGEooaoiox6GUILv4+8FLghlVjmhKMvzArQG
	6gnwfutWUXU0R4+HSpO9gk/FsdSyQsXroRcWa8WEHf2Bl1mLUXF69MYAn8Yz7MEnXR6SfQ
	GShdW8YrrpvlxWzBY+bygA0AMtmguHo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bqq8GAN9;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8A7795C5888;
	Fri, 15 Aug 2025 15:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D69C4CEEB;
	Fri, 15 Aug 2025 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755271187;
	bh=xDnCXqymPe6XawbE7vv9tHehC+/gzfDYMIARcGkDAAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bqq8GAN9Y/kxLS5TW+ZCtcC+CDj4biQhDkwDJB/wIm/DALeIBmxGt5+U2R24kURuH
	 1pbM+MlmmxD7Zq7BmJGPR0e7CjcGc1c9nAGmV5rmX/boPfYJ0iMlbj5a7JhtOi3mt6
	 uT8OPTQo3rhBH1XjExRhVJHAdwxayVTPIpaIo4pQ23S5KWJ9OkoO4Ex4dMW3rcag0S
	 xkr6OhIVlzxmUooisFAzpnfxLlwD9LVmD5qwlUhYvdp3Xpd9RIjDQxmY3CXw58EUBv
	 CUTXPbcWAuGZoCllrhuKSUyOyr8yjbg+paU7Ccbk66nTpDC/7Gci5KHsw2IBgA0Q41
	 sY045cqt0OjsQ==
Date: Fri, 15 Aug 2025 17:19:41 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 2/3] man/man2/mremap.2: describe multiple mapping move
Message-ID: <uta6tdchqf5ljwb7spu3zwpwsnxxuo3ogioi7hsitb6wx6k7ce@f6onj7arhqyv>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <4e0c992a6374e417367475e3b3bbbc9d43380f4c.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ife6itejd5vtcigp"
Content-Disposition: inline
In-Reply-To: <4e0c992a6374e417367475e3b3bbbc9d43380f4c.1754924278.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A85BE16000C
X-Stat-Signature: sbaoqkhuunchar3q5fow99zzhuj43jqa
X-Rspam-User: 
X-HE-Tag: 1755271188-561911
X-HE-Meta: U2FsdGVkX1/GcW/6rEljVxnjra/HYF+CM6Jy468F4WIcDvOjvWrBTwA+LxXni0osMqkvUiCX3vEYu01N6z/yr7slXeKuAjLFva6hx7sv/b7vmXs5KDmI9c6520ZZzS6Biu+lKF49dt69bs17ReG8KNSuKOjOBgoFKxyBZnslLL977HcHHgsjwsl61S1NA+gCO+N0Otoge9x6g0y99BWVeB+ch9BQ8xqg3Eqx4Hm7+/aawUKT+vlgmoxiydtxcvy43BSycyhJaLGHxdc1gsdsDQWiH9WzUkV3uZfB03ljlYE0+hqDM6qoKKs8YzJPaIYFIiyNbQo3IODfCLs8QWg6KI066cVT21PqYvjdOhiL+wP9iUav7XZPsNxgstWZO62h8RG53m8vIOmAFeBNYMlkCWHfFCInlERvxy1uibcD7lnyO5p5fTxjarPIS8d3NHLE8tKbbXHY5vhJ1Ke3qWE5ghCJTdHoj2PvIsbbih6fCitbrtDbTHfnifW3R4SKPI3jIfiii4Ahq5AjbI0DClZpV+yUN6Pf1hJkiZ5Z4hnic8aJ9NrOaPaqSHbuVS6pZjY/L6+Q+ZMg2DEHXRpK+dNmv2neaG+7EALIalMjoaLUrs42po1Hcr9OJZX0NzrGTjAg2Xktefgp+6f9QJQ1itgeK4Pj9NBcLIVAV9rA/X5gI3iNK9B3QUxrVwF2DG4ekSQvqqmqOhD+hjgoGnKl6ebImnlExoS3+yG+vmyXgSF93RYg3gdPnqU/wvqU/0kmVgwxPdGJZbwQDeuwEtG9pPlcVYD6YnBskpTDxOrI5urJKWsUX6lKSQpzkB+0Hl2T1IFfYwDzGJ99vPcsupRTjIBCWnhe9tLRt5MwSDYi3vVBJzSk0/88ddzpsdTo7dAVjOYINqUXHl61lHQoxc38rzgU+P6+Wb8xhqBH1fqz+X4m2iE3srBgVTGUu8BjxpBaZh9Yqlhq8EoDrru0SeUR7Xv
 17urb/mS
 isaUcFqoeMvHYzZvu4tDaKH31yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ife6itejd5vtcigp
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
Subject: Re: [PATCH v5 2/3] man/man2/mremap.2: describe multiple mapping move
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <4e0c992a6374e417367475e3b3bbbc9d43380f4c.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <4e0c992a6374e417367475e3b3bbbc9d43380f4c.1754924278.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Mon, Aug 11, 2025 at 03:59:38PM +0100, Lorenzo Stoakes wrote:
> Document the new behaviour introduced in Linux 6.17 whereby it is now
> possible to move multiple mappings in a single operation, as long as the
> operation is purely a move, that is old_size is equal to new_size and
> MREMAP_FIXED is specified.
>=20
> This change also explains the limitations of of this method and the
> possibility of partial failure.
>=20
> Finally, we pluralise language where it makes sense to so the documentati=
on
> does not contradict either this new capability nor the pre-existing edge
> case.
>=20
> Example code is enclosed below demonstrating the behaviour which is now
> possible:
>=20
> int main(void)
> {
> 	unsigned long page_size =3D sysconf(_SC_PAGESIZE);
> 	void *ptr =3D mmap(NULL, 10 * page_size, PROT_READ | PROT_WRITE,
> 			 MAP_ANON | MAP_PRIVATE, -1, 0);
> 	void *tgt_ptr =3D mmap(NULL, 10 * page_size, PROT_NONE,
> 			     MAP_ANON | MAP_PRIVATE, -1, 0);
> 	int i;
>=20
> 	if (ptr =3D=3D MAP_FAILED || tgt_ptr =3D=3D MAP_FAILED) {
> 		perror("mmap");
> 		return EXIT_FAILURE;
> 	}
>=20
> 	/* Unmap every other page. */
> 	for (i =3D 1; i < 10; i +=3D 2)
> 		munmap(ptr + i * page_size, page_size);
>=20
> 	/* Now move all 5 distinct mappings to tgt_ptr. */
> 	ptr =3D mremap(ptr, 10 * page_size, 10 * page_size,
> 		     MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
> 	if (ptr =3D=3D MAP_FAILED) {
> 		perror("mremap");
> 		return EXIT_FAILURE;
> 	}
>=20
> 	return EXIT_SUCCESS;
> }

I've applied some editorial changes to the program.

>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!  I've applied the patch, with a small amendment (see below).

<https://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git/com=
mit/?h=3Dcontrib&id=3Dd99a3495372a69b48309f2a1a4e2067af2bfbe69>


Have a lovely day!
Alex

> ---
>  man/man2/mremap.2 | 68 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 57 insertions(+), 11 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 4e3c8e54e..6d14bf627 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -35,22 +35,36 @@ and using the
>  .B MREMAP_FIXED
>  flag
>  (see below).
> +Since Linux 6.17,
> +while
> +.I old_address
> +must be mapped,
> +.I old_size
> +may span multiple mappings
> +including unmapped areas between
> +them when performing a move like this.

And I've reworded this last line.  Repetitive consistent language helps
understanding documentation, so it's better to repeat "a simple move"
here again.

	diff --git i/man/man2/mremap.2 w/man/man2/mremap.2
	index 6d14bf627..65b4d5f58 100644
	--- i/man/man2/mremap.2
	+++ w/man/man2/mremap.2
	@@ -42,7 +42,7 @@ .SH DESCRIPTION
	 .I old_size
	 may span multiple mappings
	 including unmapped areas between
	-them when performing a move like this.
	+them when performing a simple move.
	 The
	 .B MREMAP_DONTUNMAP
	 flag may also be specified.

>  The
>  .B MREMAP_DONTUNMAP
>  flag may also be specified.
>  .P
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
> @@ -119,13 +133,42 @@ If
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
> @@ -163,13 +206,13 @@ mapped.
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
> @@ -202,7 +245,10 @@ virtual memory address for this process.
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

--=20
<https://www.alejandro-colomar.es/>

--ife6itejd5vtcigp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmifUA0ACgkQ64mZXMKQ
wqn1XQ/8D9nxkEsDr+AmpwnH6QIB7/L5yD4hUcFmeNHJzWd7VKYFxGRNNagZA4YE
ZjB6KfkJTdDofRX7mpBcJLXgP5fEZLOdgILY7fxizVv7FLd8iVgzrScqray76cPW
P+IPwsfzvz21JsY932ioPTDaYTKxdyPrxd/Gj6bQWWyDaJrGwLYuHiHwYaBcBY/W
4NHk3Pfy0Uaietf4JBrJgT37FyqHGFnv2r/vFlrOjTTth2GVIOCxlqfiwemsprrp
oOx0uhrBh+yJXTfibx7aIgs37HQjIO4aWABGKXbvC0VkRdeKDSgnzQag0mFftxWI
NKJzU675Rt9d4WXQVocWttzcZUQxfrVurO/GiJnuSVrmyio4Yu8iz+cIb4n+glPB
1Q41K+gVb7YZaV9wsrsht6v1sYuD/qshOfbEMpTqfHZafOcDRnEcqATTvzMcLI4P
R6gUh352h5HvS0AjaNa9VDZE6ADfsgM2N4L0fl6NeF2W9qyrWACZH6h5kyPZQKkW
Lco5H9E9f6LKultowaTjfDVbDseEqmHwIP9bwPU2JLPaf163N29+rbDCIKGBU0r5
ENor8v9XycJQN/Y0RSm/MTo8BbjXuE+36rusNR+n3kATeUIFc6v2v1ibUPUU3YvM
G+YGdWbUCOEt1GbKsV9UnDO5nW/m7GYF7LJH1NiPX9q6IQBpmCY=
=2t4K
-----END PGP SIGNATURE-----

--ife6itejd5vtcigp--

