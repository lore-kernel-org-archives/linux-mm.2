Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD4DC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 14:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FD46B009E; Sat,  9 Aug 2025 10:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07746B009F; Sat,  9 Aug 2025 10:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43ED6B00A1; Sat,  9 Aug 2025 10:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A232D6B009E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 10:33:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DA77B7A41
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:33:24 +0000 (UTC)
X-FDA: 83757461928.24.8377230
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55095A0002
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:33:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qtPq82xb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754750002; a=rsa-sha256;
	cv=none;
	b=MBJKr5Wrd5kMbilme7Bys6AZR0KlUDkx6p0eeyjZpL2tXi3z/eTLVMUIMgGQKBFJNAaMoG
	5kJGkZXlLqHXxZMczaOJnB2t32z+YR1lNhk/qJrCksouCz8pn538zhutYyO1A4zkAHaW1C
	mZoFxSTG44+Ra8FSAEzoJAz63x3+9XY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qtPq82xb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754750002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsFWNVaE6ffxoK1ZXuEHtb5qszhbnJFL1sNcUiw4Bnw=;
	b=oStBpT2ogqzCpExv+6vyaxzTI+UTe7caF9U1c8nFCfO6jnnL8MMIBQAg9JdoYcrzqWk4xQ
	HP/L9wHYvCdnS7pYxYEzZXj90ZwdhoO9NZKI9o7lH66GRvyk4wN24NscXGygiTDRddk7+q
	2OULc567VuTzDnwXtDCTGhEAQQ7xt1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 654075C547E;
	Sat,  9 Aug 2025 14:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0613C4CEE7;
	Sat,  9 Aug 2025 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754750001;
	bh=yxUe45wSeV1/d5Z1NivZkyntB8zfOPdyKAKqdYx4Urg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qtPq82xbmmWMVaE9JNo73+i7g+5l4ZqaB82Piz/xpwHC/5wGCQi4gy1Dq0woHh9b2
	 pu6vPwS0qgJjjyzoOtvU5IshuHToi3//HzTtPR9fp3gqGaNyRCMDx8Hd4n0SjFqv5W
	 0uKGIFTKsPdHpbPomIZkHnG2wzEY9/LTOyN5aLjXuqk9pWPDZ2oRcTXSrp6PRAoRG7
	 4RgsvqlFg/ENi/3ZxYV7UiIhIryh/hPD9//D9AOge8ftYvweKpLyp5CDz8oCKQXF54
	 YDiksSn+1bNX0NWAmEMd7AEZ/Zr+At/rzLZFiMm2PCfcwz2IQ3xwTeNCBrX7KRuwQF
	 w40v+2ExNkrpA==
Date: Sat, 9 Aug 2025 16:33:12 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/2] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
Message-ID: <iolucvrp6is43yjulbluchhw5wy6urq2gtwmcelg5atwuv63se@ovzuthfrup26>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yb7p3rwhyim56fmd"
Content-Disposition: inline
In-Reply-To: <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: aiq1e7hosw5e6n3k7qrs6rewihzxfmoz
X-Rspam-User: 
X-Rspamd-Queue-Id: 55095A0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754750002-839435
X-HE-Meta: U2FsdGVkX19nzhwLcr7zwLEyjHeVSahsvJWY9JwdaDtrQxBvl0Ql74Jo+7usEyyqt5wXwILLai7iLpRAYhebhJCq0BQzQKwjzQBOmBRBTkdbP8uJ9MOvPSOPe0OCXfrknF+YzKIDGWxx/yBcDH2HjG063inR03cLAfBL28PGwrfvrLTJWTiWXyrHA/TKTCNHiD6WSxcPN+6E+IIFlOKtswiH384x/vU0+2d03H9os5WRW33KWAt6IjgDZ2YjJmHTn1NW+9Unpw09ZLg/bjaHVeHtJKZ6eSMyBsJl7PVJsy4s2VmN7ja4eRsZrqrxzFW3sPlOLZKWqPNaGlDh7FtEXV2L21AwxTuOEwrpIDD4xTjLAmK2vV5q8H0CRzeeBLu9+AtQu+MOy953s7wGH85PlYBzUlHDgmeps5aW5+H7mG52w9ukuh69ZWevdpWXQ+11WFLyd/FfGKBnbuxzBtp2EHdDFLNL6oWjWNJ/1m5M7AmgnULXV8TPryursLT9QHyCHH9dY9GjVMHhDIO/8BVgJ7vcoZxaK9pUcVqdSfAZB3HZpY87GlPO9Sm/69VAne5DE8zELYeMAbDtGcSniBmHfj48M09f8bqUJJVt1gQVKxYk/j6xDfWxP/icMRHbg9eF98yY5B347L5mFlFS5exiJvQYn8H1VsD+42tsBk0fOwccse4tXU771nY2I1zxmLzD/ECRWdhybnY5OzYV02gkb5xMTYkdoTRt2skKns7E9mL/UkBLzuT74ekVc3jCJFcA27NKr7UIpkre8uFSRtudqaGbfM4hYuh3nKqFvPhTjSDzagJM8/0KhyBrA/69d/IkiAocY6pOuX8piA+PSiujamU5gyp7Obe8F7BmaKhQ1xZJ0jngFGVBcfnfonyj3qthWaeti1ED+bNbopHltjUiIihVYYIFcqWiNdjuVUXuFxX681jx1j/MdUytsZwDRdEAXodS3xDLgtxGG4IMuxR
 LPdPKRX0
 3Rw1R4+8EHtOGF1T/DQZOZxYxna3hHVx8bmFQBAmdALczhmLkNY3glwJUKeVeT+rdRaBh7ERk8nsv+NvrKScTkzrXV/yN/kjPHedGQGuaG098WsXuW9ylEYUcc0jMFKKyn39ZlDNOuoOVHh3UWT1KsqpVsBoXMogJbSn7Vp9W0oLrWbXFdjyH0h+xY3KQUy/aTST+NU24x1PGov1qSSCwQF6ivRbzIE5UZPWobiv7zI3cK9gd6yiSuDJyk4QSlCb6VtGXjvB4mIooTCAcG2Da6cXBpojjR9Xw1iNv6glQrcfVvnpoueJtLoKN7tPJGwbr7miz63dUc0yNDhaZCOmlmJpo7iDAD0xx0agaEPCfpuRKrV+ftn7aT3ng7ngJLCZLsBD84RR9QVi0UbiufeYy5JKHPYNAEB7u9263njse3LQz2ENVblr9a8Jmjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yb7p3rwhyim56fmd
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
Subject: Re: [PATCH v4 2/2] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <c7ba8ba09b1c0b015134c54824788ef4aa47fd46.1754414738.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Tue, Aug 05, 2025 at 06:31:56PM +0100, Lorenzo Stoakes wrote:
> There is pre-existing logic that appears to be undocumented for an mremap=
()
> shrink operation, where it turns out that the usual 'input range must span
> a single mapping' requirement no longer applies.
>=20
> In fact, it turns out that the input range specified by [old_address,
> old_address + old_size) may span any number of mappings.
>=20
> If shrinking in-place (that is, neither the MREMAP_FIXED nor
> MREMAP_DONTUNMAP flags are specified), then the new span may also span any
> number of VMAs - [old_address, old_address + new_size).
>=20
> If shrinking and moving, the range specified by [old_address, old_address=
 +
> new_size) must span a single VMA.
>=20
> There must be at least one VMA contained within the [old_address,
> old_address + old_size) range, and old_address must be within the range of
> a VMA.
>=20
> Explicitly document this.
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Since this is documenting old behavior, could we have this patch before
the patch documenting new behavior?  Or do you prefer it in this order?


Cheers,
Alex

> ---
>  man/man2/mremap.2 | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 6ba51310c..631c835b8 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -48,8 +48,35 @@ The
>  .B MREMAP_DONTUNMAP
>  flag may be specified.
>  .P
> -If the operation is not
> -simply moving mappings,
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
> +If this shrink is performed
> +in-place,
> +that is,
> +neither
> +.BR MREMAP_FIXED ,
> +nor
> +.B MREMAP_DONTUNMAP
> +are specified,
> +.I new_size
> +may also span multiple VMAs.
> +However, if the range is moved,
> +then
> +.I new_size
> +must span only a single mapping.
> +.P
> +If the operation is neither a
> +.B MREMAP_FIXED
> +move
> +nor a shrink,
>  then
>  .I old_size
>  must span only a single mapping.
> --=20
> 2.50.1
>=20

--=20
<https://www.alejandro-colomar.es/>

--yb7p3rwhyim56fmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiXXCgACgkQ64mZXMKQ
wqnwUg//Zbci7enPjyN3lLEYaDN/+ol7gyRscha0V1VRpTj9tJMgsD1tqcoLTIO3
gU0Zg9yvwAiJEEYHPLeK25iP2ck1PV4kDShUZa7PkFwc7gatNYdDm3n2rry48YS3
DP11MHUlCvM/hEgGAl/FPLSKqIsZgcgvx8cFQu1dRFfQSn9tSht/9dkZZk9LLKxv
drKGY9tdoUWlZn29GSkPnVPfQT4ZnvgxHebPBsm2x/ROZlGpUD6EjgxiXsqSyK6r
OneW3vfmujiQK2fXCp6GmlaM1jQswtgOFBPkYsjpV3vaxR2yhha49u7uWAb2tkDD
cN5sKZhOdC+9gupdXuqBYik38SLPTBoi4eJAFw7Z8HqEe+OhKsWWqs6k6ARReVPC
QteP+jP8bOwTjeVi/F03buaa5skPAaq/DAd639WI6285yIk7jpzpGahgpScuW4d7
lRaekYBGNEX+ixWoRsJJdmOfmne47uscG/AnRvyWECNg/Asy8KiQ6dSsqmoSro0D
EIfjCzTmggQmhepkftKTOZnH8U5KsBtJmYAnnrGGVuwxLXH7rO+uCxu22oa9OLPf
eNhuQh5PaWN1YZkPPg83v84iDj/s3i3NNFH/iYesgMRAYXQqpoxohEkYjmxt9GGK
dAWrdWPj2cpimiU04ghm6HXsYKJaPZNT7tTv62s0zKa2lekBxiU=
=p3CN
-----END PGP SIGNATURE-----

--yb7p3rwhyim56fmd--

