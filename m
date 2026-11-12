Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72326606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yfmx3/iC
Received: by kanga.kvack.org (Postfix)
	id 7758D6B05C3; Thu, 12 Nov 2026 05:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CF26B05C4; Thu, 12 Nov 2026 05:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662736B05C5; Thu, 12 Nov 2026 05:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A25B6B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:13:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE7A7A8064
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:12:59 +0000 (UTC)
X-FDA: 85426053678.05.56CD60F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A7D612000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:12:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yfmx3/iC";
	spf=pass (imf29.hostedemail.com: domain of alx+linux-hardening@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx+linux-hardening@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794478378;
	b=MZMAGTU+iLMZU7pq+ydYssa+D0xio36N+5YwnkF6tZ7x7pDanlH1LqcyqEEt4IAm3bd4uK
	yWp1S06X2/QF3l0X3E3PROeAqXnZEtOMR1qb/88nSySvO4xPqorfMNDmFHcAan9AiUqeC4
	edgnzdB8Yyy74wfrRJB0u0AWyN3b0T0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yfmx3/iC";
	spf=pass (imf29.hostedemail.com: domain of alx+linux-hardening@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx+linux-hardening@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794478378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4Hiwgo7R+HZm4bqUhmJ5Y10eCIYQ+s+J5vOxQfUPYk=;
	b=SYJZT3yDRdNiWmCAO+PXKDFPwqPGTrHRrGpfD+tTR8x/8/Dbxj8g3Tywc1MVnrDjsLsmMg
	63Yx/XnSeIkmbzyR3NNxl/yvjEzxCvxToNHkv2n9Anv6y7DW+O+apkEKbz9HTClhjGP8Ip
	8dESBkEa/n24ohSgCHZ0DZPCP/KZy5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4291365659;
	Thu, 12 Nov 2026 10:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B837E1F00A05;
	Thu, 12 Nov 2026 10:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794478377;
	bh=a4Hiwgo7R+HZm4bqUhmJ5Y10eCIYQ+s+J5vOxQfUPYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yfmx3/iC/7XtkB87cVZUt+yQ4qrcZxoz5n2K/zeQh5PybM8KDx7GSTbpdn0CBfUat
	 8fhbQHgcRoBqhQdIY5LSKJ9+pKm7SpKTtQhY1cR7ZzbGRRSc6zPu4tohQzA7pOwQL3
	 sjOiqNKz8zc03lqdij4x1Bp6X9jNWSwLxR/0SuiepQPmPeN//gYR8VIPrimvfe0Dc/
	 6sLopGM8zQ+51e1IU6qLm1vjenouGD3zZMEiBCxvxCu4absUCiMSeSUhb/4KgW5dFH
	 k6XRaz5uyrKziJ1ClqBRisgmdsRmVEFgVEJk/s/O0hnb4vKKjerHwGNfwAaaoo+rhf
	 C7SVOe9aZdsvQ==
Date: Thu, 12 Nov 2026 11:12:48 +0100
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <avWNCC3_Ff0knO6J@devuan>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="l52whvkkcz7sedlr"
Content-Disposition: inline
In-Reply-To: <20261112004039.GA523044@killaraus.ideasonboard.com>
X-Stat-Signature: brae8memyigeuedxuwqmzrk3w9emhrsp
X-Rspamd-Queue-Id: 2A7D612000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794478378-820101
X-HE-Meta: U2FsdGVkX1/w5m7wfVg6KlzRtwIv7E2Eh1GUa6QLu52xlWDk8HW/EVBgaRjoIdl4hN6EUeFKA5N3WiaFfBWoWG8ij5NfvD1w1oa4dZhL7Ux5xzs9I7RiNYsSHB9vXEfJ+HHIk2MIEzSVjwZqe409c5tvCZvaBd4WzqIclBjSi5foYkUbjJAvfyBeHAUvdDzV8sREcxfqKeEmFeSDB1938ZpcJXBt8/Hr/KcX3jKCsB7bMlgoqr0i0pqUjyRqMs/1zGVZLR3o1RHFqRq3t3Syb+xXyVqbjKNafnlcAyuxHDuOKW6OI09maMV9k9wAniv8AnINtixQkxyvjmim0v40EJwxwjlO5JTKAJKDQSlK/tC0QqhWPl375qXM3yG7Kn0ti0W4hT3dVwM8dTr3tF9cMoNRVoFY96QDLVifCC84YtkW4j96fiHau118LWbFv0EMj/ZEh/sZti367mMXSnxXwcfp/EtpujRdq8sHPVsB3bfP+MFDcDg/g+JmXkl3vzzRc6XXEQiyxYYvlXI3wMkFwU5UQkdu1YEdI3RZqIjNpZRtRwzqqHs6ay1aNYtnmRuqamMOT2rktDOsCCho0y79MsVPs5xsg9WRdXlCtV3rCN943d6g4tOBMyiL5P+WJiQzPPXXWcQ+AFWIFqQLvSHXeNSgbKYRX8QgSZJAyD+ZsatHINQ5bKJSfHPyhIgzN50Rg3thoAiEZXDwGaf62J9t9Pkgs4iSXUTmW/K5/isxW7SIKCqOJ8hslwW1WR6fFp9LIen7cfyATrLPJofOejvkCzrfiJUBOFuYCwmku6ccF6hO5gYT4HcGDJxAWwMvJwrl23pbBsnyuV4vqtEv6DL67rcLu9V/Lu3tQ8nshOUHyAmeD9DYJpb2RUg9FfoQ/2AmN5d04ilp5iwXvmcG/lcA8gJjyFzp59kk283bARJ1rCWgAC0O1K3SqY+krWqOVc95nxIrp9xIYDuvEMERU9f
 2MGwtoh0
 dgMDZ9mThfO1y8wWja83FUXsMz8aQ8IrGBne+1wo73JiBulVYr+1TWi9z6qxpcl1D0hXeUTpdZXrlxBs0gvMw9cOJAH4ecRptmHHM7pZcAdqH7xbaINN4qlHjGj+aR0PVQW06auRjQ2H3n/gCpfOdA4qY910LDMNxZANhdF+G753RasRSgR16jh4Ebyve4J77GVa2CCUZwYcwFYMMhUiyWnUHYVoWw5ZywrwxAfM/wBrrW6mG1lM/5voj3Y2geTLCRtQT/jUANacIHm+0h8bZSfZp5D8KJrkVpHqpbX8rdGl0F6J6B+AkF12IYs3fXu88XbIb4WxInAGkFu0qT1WGH4sVPNgNgUGE7ljZr/uou9rQOAfSqAE15LjdU+Qydy0753eX7RMUqRuu/Une+12aSvltjeFFKN4LQFux78+UekTu8SuUb1jV7rN9IQiTcexdcZ1ptadu6fHPjMgeEKuVWz3QNplwQxpfH5Ek0xrbvesLotJH7TPqxd/NFw5ZUODddqjn030Eu44TcypecRbwKtCubJo2Nb4Q16+yWkRra/ald28YsD6tnhnhbF8DV1G3+ESjHCoyURMsEISMNmpF7juwsa7Mj7tpIWRQFljnC2vEgBdAi8r6mOSWt04CZAqonlWrHZJq5FSsJ4pi7rS7KZwUuoHSHRuVMN6wmVU6ZhS6xhCC8Nr4Skd18Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--l52whvkkcz7sedlr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <avWNCC3_Ff0knO6J@devuan>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com>
MIME-Version: 1.0
In-Reply-To: <20261112004039.GA523044@killaraus.ideasonboard.com>

[CC +=3D Linus]

Hi Laurent, Linus,

> Date: 2026-11-12 02:40:39+0200
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Hi Kees,
>=20
> On Mon, Sep 14, 2026 at 03:32:17PM -0700, Kees Cook wrote:
> > Mirroring the type-based allocation now in use for the kmalloc family of
> > APIs, provide the same for the devm_kmalloc family of APIs. This will
> > allow for future plumbing of type information (e.g. alignment) into the
> > underlying allocations. This immediately gains type check on return
> > values (instead of the prior "void *" return type).
> >=20
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Cc: Danilo Krummrich <dakr@kernel.org>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: <driver-core@lists.linux.dev>
> > Cc: <linux-hardening@vger.kernel.org>
> > ---
> >  include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 102 insertions(+)
> >=20
[...]
> > +#define devm_kmalloc_flex(DEV, VAR_OR_TYPE, FAM, COUNT, ...) \
> > +	__devm_alloc_flex(devm_kmalloc, DEV, default_gfp(__VA_ARGS__), \
> > +			  typeof(VAR_OR_TYPE), FAM, COUNT)
> > +
> > +/* All devm_kzalloc aliases for devm_kmalloc_(obj|objs|flex). */
> > +#define devm_kzalloc_obj(DEV, P, ...) \
> > +	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), typeof=
(P), 1)
> > +#define devm_kzalloc_objs(DEV, P, COUNT, ...) \
> > +	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
> > +			  typeof(P), COUNT)
>=20
> I was recently made aware by Geert of an unfortunate side effect of the
> default GPF_KERNEL argument. I've fixed a memory leak in the imx8-isi
> driver by using devm_kzalloc_objs() as follows:
>=20
> diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c b/driver=
s/media/platform/nxp/imx8-isi/imx8-isi-core.c
> index 0ae5f35e017c..9373a5256224 100644
> --- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
> +++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
> @@ -488,7 +488,8 @@ static int mxc_isi_probe(struct platform_device *pdev)
>=20
>  	isi->pdata =3D of_device_get_match_data(dev);
>=20
> -	isi->pipes =3D kzalloc_objs(isi->pipes[0], isi->pdata->num_channels);
> +	isi->pipes =3D devm_kzalloc_objs(dev, isi->pipes[0],
> +				       isi->pdata->num_channels);
>  	if (!isi->pipes)
>  		return -ENOMEM;
>=20
> So far, so good. However, the following code also compiles:
>=20
> 	isi->pipes =3D devm_kzalloc_obj(dev, isi->pipes[0],
> 				      isi->pdata->num_channels);
>=20
> (note the *obj* instead of *objs*) because the third argument is
> interpreted as gfp flags. It's clearly a bug, but one that the compiler
> doesn't catch. The typo is easy to make.
>=20
> Sparse catches the issue:
>=20
> drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22: warning: inco=
rrect type in argument 3 (different base types)
> drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22:    expected r=
estricted gfp_t [usertype] gfp
> drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c:491:22:    got unsign=
ed int const num_channels
>=20
> I'm however not sure if build bots report sparse warnings or only
> errors.
>=20
> Is this an issue you're aware of, and do you think it should be
> addressed ?

Indeed, this is a known problem of these macros.  I reported it in March:
<https://lore.kernel.org/lkml/abhGS0n_RsUG97Ni@devuan/>

The link contains a detailed report of the issue, and why it happens.

There is not a single cause of this bug, but rather a combination of
several of them.

I suggest removing kmalloc_obj() entirely, and using kmalloc_objs()
always, with a second argument of 1 when we want a single object.  This
would remove the risk of that typo.  That is, instead of:

    int *p =3D kmalloc_objs(int, 42);
    int *q =3D kmalloc_obj(int);

we should do

    int *p =3D kmalloc_objs(int, 42);
    int *q =3D kmalloc_objs(int, 1);

I also suggest having default arguments without variadic macros.  The
way to do that is using empty arguments.  Linus complained that it hurts
his eyes, but it really makes these macros much safer.

That is, instead of

	int *p =3D kmalloc_objs(int, 42);

we should do

	int *p =3D kmalloc_objs(int, 42,);

By having an explicitly empty third parameter, we'd be asking explicitly
for the default value, which the compiler can verify, compared to having
to guess whether we asked for it or we just forgot about its existence.

Any of these two changes would already reduce the chances of this bug
significantly, but if we apply both, it's almost impossible to have it.

Another issue with that macro is accepting an expression instead of a
type name.  Consider the following mistake:

    p =3D kmalloc_objs(42, *p);

The compiler can't catch that we swapped the order of arguments
accidentally, and will allocate a wrong number of objects (whatever
happens to be in *p, if already initialized, else we might be lucky and
get an uninitialized diagnostic).  If we require that the first
parameter is a type name, it will preclude that problem.

Please let me know if any of these changes is wanted, and I can prepare
some patches.


Have a lovely day!
Alex

>=20
> > +#define devm_kzalloc_flex(DEV, P, FAM, COUNT, ...) \
> > +	__devm_alloc_flex(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
> > +			  typeof(P), FAM, COUNT)
> > +
> >  static inline __realloc_size(3, 4) void * __must_check
> >  devm_krealloc_array(struct device *dev, void *p, size_t new_n, size_t =
new_size, gfp_t flags)
> >  {
>=20
> --=20
> Regards,
>=20
> Laurent Pinchart
>=20

--=20
<https://www.alejandro-colomar.es>

--l52whvkkcz7sedlr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmr1kRoACgkQ64mZXMKQ
wqnFkw//auHnN2vErNki0HxNo/v/DxKacndGhaD1gjlvZ17kHd7QrS7rh03uK44/
3JD96vW7Z7g1/Hm0cu+j4jx0A8Sw6FbuqUTNU8MxTBYjgtTCNUoqHBJvS+ltbuJn
zFCpENgoctzObQiPLgL7KeEz2a0kUN1tTxTY9WeldL+Zq9CPOChtWVYLdJToke5n
Ho2/sRndWnGTPTNLKbgaB2YaBbHHBkcNgYeO7J4H3gzkpaFzqU8WlBFX/snbki7n
he/JQP7kSIenbsUhcV1PzMfMaH3xP0E+qXK1Gla/J4y8qqwpe+bPWTEnHbgwrx0E
dsgC1DoCLwXwMTJw3efjsut5zFh0YtMtH5CX+8S7Fto1u6y3nVvYD45ie7xTlFc8
IYDxLb2JEoSBhtPXIIg5HK7yIVIhwDBcaTOvrm9aJP+um556Nm0GRu5hxRHl7pOK
+cenvuXCc0DRsYgwTxH/bnSDh3aBva2op42VGmdgDEh1xm/4HC4y3X5Z6EYLGiSV
JXLfqoUh/FrmlVMRp1OcMvUrAn4QkDQbumWcHTNDtaIfezP4PbNerwK9M/FsflFG
SD1JTaSOAOXlEHn8HgnqgvpBYco6DAV9HYG6i+kP9fvPWQkUr3xC1fUp2qylhk1C
pspEDaquGj62LlF+VSz0h4VktU968CI3/vzOr4A7tV00Rd67qCI=
=0siK
-----END PGP SIGNATURE-----

--l52whvkkcz7sedlr--

