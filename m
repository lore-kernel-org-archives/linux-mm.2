Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7650606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajVI3Ww/
Received: by kanga.kvack.org (Postfix)
	id 85DB16B0602; Thu, 26 Nov 2026 06:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835136B061E; Thu, 26 Nov 2026 06:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771DF6B061F; Thu, 26 Nov 2026 06:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50B4A6B061E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:24:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5ACDA80CDE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:24:15 +0000 (UTC)
X-FDA: 85477036470.08.519CA42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B057C14000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:24:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ajVI3Ww/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692253;
	b=NpJuPCRHV22g1wS3IZBqsuYqbX20zHGVggyzQtLe2K4wr+ei1qVCG1Dcw7UC51grt/WQjq
	dTZezW5yIJ9DOC40cwqbXK0++6sWqlgxIfzHCxFSTO3frZn21seYWtKhuYpYRYS4lqsa1I
	l0f2xJfhLiPo5f1Kkf9Cmev5ul1gPE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PQzyrJId5iFWaXv2F4psoT+ZCMTu5VTBd79sMj6dkA=;
	b=XyjhybNy+Q0G1dUhnVPNcVibcB2d7BmQCW0GUwmL6dMjGFAuGvGjjsYuwvnCxhgS+duS8v
	luZiZ7K+wfrPBILS3O78Chw7Yv8o7zSHrU5t4J+f2Vg78KJZ1BAA6w94BgkuC9JU1Fl8nW
	kA0jCfVEFp3BQHUImqWkXBVbZ+038qk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ajVI3Ww/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF5541857;
	Thu, 26 Nov 2026 11:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739E01F000EF;
	Thu, 26 Nov 2026 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692252;
	bh=4PQzyrJId5iFWaXv2F4psoT+ZCMTu5VTBd79sMj6dkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ajVI3Ww/N7PAJe7092To6cY8rWgzFqrcrs6UXSAuTJNH1HZJQnIOpj+FrFFHIqzFF
	 OsPMXZb4DtkvzY5DRK/o8hLmPC6ix/7525XrdynXpw4N1d/gIyj2/vrcItCMloczHb
	 /mw9oGdx77u4Uxfn+Q1rTm/EV51uV6CXfySfBpV995msTiufAwssHI4QKlQctfGBMm
	 r2/uGUXMCu5aklbrYAMeUlBvM9iuNm5UZ7nBfOKP77AeY3Krvn0US5muR16rMAARC9
	 Yz9ql3slzAuZHgncHWOeq9glUjBjg48mkBHmQUU8f7Ds4LUC3ocTshwKkUe1lnoIgr
	 Pta62UY9BZ18g==
Date: Thu, 26 Nov 2026 12:24:08 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not modify cont sysfs store buffers
Message-ID: <awgV_Ngg8HLMUcsS@devuan>
References: <20261126014518.1318583-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dgsjs2ke7evooars"
Content-Disposition: inline
In-Reply-To: <20261126014518.1318583-1-senozhatsky@chromium.org>
X-Rspam-User:
X-Stat-Signature: 4n5hqw1khjh9zzryrmrjpxfm7xdjsbyr
X-Rspamd-Queue-Id: B057C14000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795692253-134829
X-HE-Meta: U2FsdGVkX1/UoxCafHfVI3yIlJb4ame/bDxUCFnCKc/od6tqSOmff5KIE5xrz7PA7Mhzj+gbt45zykN9H4bLotb2QQnxXTCmmxVliBIrb6V7kyRzd/avM325M1ehHAa9KnMdgc+mha6/M1AkFQZLjdbqB4kptetIeVQYdiN3qUJTgD3huVaE8bGgqfpsH3MJdpRvsdqQ5nZoxdGu7qB+WEAOs2ixJWwZSpWukRfIZ7uTM7NJ9CXEBW9hbw3QcyjRd/fR2ymg3uRmH+gDtR/rY7aD9VMobTw8qGkWUgQWwUrU2Z0NGG5uhAA9xtOcBjoYyIbprwQZLs8qM9bXbvTUpujmY/5CcmT291XIJphaWZq2xdDMDkd/mK6/fsqgPVY3e/lGiH+zubtZhNV8sZJAShjDJeEMeJR1kvL1G9LBLy9tr4+2RUhnjStu7c1177/dneVz9IlPlxxB+lyFjn3OKpsG0yjFaGN1W67WSJGEobHHl2yFzrNuwuetOrJHgEZqy3JuG6jlNke4nul1bB952mBzzDtwY6ivvbeoqzsaEHUW/pmNn78lYNtPrktiDOFnpNzE3eBEZ9/SzLfOG0DL/TQ6h94WpScwqM8lY7S2TIVg3sOzLUoGIJmzSh7wxpA/kwq8+8YGBWG5OO/alssb/6MnrlyKnK8dmCu3v4cbB81TpmxgSmEeOP0RIuvuLQFncoDzYS0Rg8RqauYz0nyVuthXk9DUeT1adNBvk/e9i4SB6lzcoDOs6mP2W+tEmayf2eYPkiChCfnT4sQe5Qw03fkw+B0GLPaVoa9mulP8DJFH5ULD26pQ7cqsKn5lEm17mCMV0fVnJiuStH++GS6Byd+bHqUpF1+rM4KqOmlmzXwyf8AIySug7BxglyknHGhbNJBQYF0ppEP20S8Pauf6GPTZt2OrgbCcPB+B9JjRFbbnwmbPcdmtkk/OsAfAKc/f30V2TqYVwq+rnKhT5bE
 VEc+uaHj
 69Q50MFNNLeFtdMIVpCmV+Jykm74Mt3+KpAnFbpU8EQ4+4GCW9by5UU4f/1h8Wdk8utYBuwcKHHP98wlrTg3DjFNhfzJZ1dEVxdJ67y7I8mHmxu5y7sNUAbWu98IQyVpkugpfjytyDMqHbBt5NP/33qzFsfS0Sy8gCOaq0Y6GXMg2mrGshanHbLhN5DCSwjjD+on9L8luL7QBIpZK69aHTajjciyALU9cIkKZJhW7jVKW5HtsSKBLdEPCSKoZEO7xtxZgZHdvcpiH6+OBsDRWytVoALox25a2ezx3mCwXcq2FgLlsDj9/jHypGYEfQlhxvSrYEy5GsUFODBi87bo09TDrLKZcQWvyYv1QGWYrIg6FF0LNRgi4tJ9+imE3OEkOol8pMabGVHrD7r+QqmiUCht22z3iKKQ0B6MDfmNSs7OWcNQRPnoT1mKCkJETXZ4/6GnPNTTpG9eAXyONxBBCr+/BpM9FnLYUvutFpAIl9bd6jG1r9xNsnHEO7t9vLNK1delHRt3AUxAXcfl1IZDZejhkIfx2NK6TxTaOgSD6IGPOwMaYkeAFfmGNZyawaVlB4W9FJVc6wZ6Q8CGQQDlyMbKuL2yiX1kBtGPjYHA4OIdMZx41LitMoJESgiKDtbZ7qGd/pVqE3o3R7m0stNY3wayxnTD9IF2tWZhnvXKFY0k9vt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--dgsjs2ke7evooars
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not modify cont sysfs store buffers
Message-ID: <awgV_Ngg8HLMUcsS@devuan>
References: <20261126014518.1318583-1-senozhatsky@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20261126014518.1318583-1-senozhatsky@chromium.org>

Hi Sergey,

> Date: 2026-11-26 10:45:07+0900
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
>
> zram sysfs handlers that accept key=3Dvalue arguments (e.g.
> algorithm_params_store(), etc.) pass their const char *buf
> parameter through skip_spaces(), discarding const, and then
> mutate it in-place via next_arg().  This is not dangerous
> per se because kernfs_fop_write_iter() passes a temp copy
> of user string to zram, however it is still probably worth
> fixing, just for the sake of correctness.
>=20
> Allocate a temp non-const buffer for args tokenisation.
>=20
> Link: https://lore.kernel.org/all/awcpkJD6K1xtx_Pe@devuan/
> Reported-by: Alejandro Colomar <alx@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 96b135e3f727..ca12c1918aec 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1279,10 +1279,15 @@ static ssize_t writeback_store(struct device *dev,
>  	unsigned long lo =3D 0, hi;
>  	struct zram_pp_ctl *pp_ctl =3D NULL;
>  	struct zram_wb_ctl *wb_ctl =3D NULL;
> +	char *kbuf __free(kfree) =3D NULL;
>  	char *args, *param, *val;
>  	ssize_t ret =3D len;
>  	int err, mode =3D 0;
> =20
> +	kbuf =3D kstrndup(buf, len, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +

Thanks!  The fix sounds good to me.  While this could be a breaking,
since we're changing (or rather, not changing anymore) the string held
by the caller, I assume the caller didn't want it changed (since it was
const-qualified).  Thus,

Reviewed-by: Alejandro Colomar <alx@kernel.org>


Have a lovely day!
Alex

>  	guard(rwsem_write)(&zram->dev_lock);
>  	if (!init_done(zram))
>  		return -EINVAL;
> @@ -1303,7 +1308,7 @@ static ssize_t writeback_store(struct device *dev,
>  		goto out;
>  	}
> =20
> -	args =3D skip_spaces(buf);
> +	args =3D skip_spaces(kbuf);
>  	while (*args) {
>  		args =3D next_arg(args, &param, &val);
> =20
> @@ -1779,12 +1784,17 @@ static ssize_t algorithm_params_store(struct devi=
ce *dev,
>  	char *args, *param, *val, *algo =3D NULL, *dict_path =3D NULL;
>  	struct deflate_params deflate_params;
>  	struct zram *zram =3D dev_to_zram(dev);
> +	char *kbuf __free(kfree) =3D NULL;
>  	bool prio_param =3D false;
>  	int ret;
> =20
>  	deflate_params.winbits =3D ZCOMP_PARAM_NOT_SET;
> =20
> -	args =3D skip_spaces(buf);
> +	kbuf =3D kstrndup(buf, len, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	args =3D skip_spaces(kbuf);
>  	while (*args) {
>  		args =3D next_arg(args, &param, &val);
> =20
> @@ -1899,12 +1909,17 @@ static ssize_t recomp_algorithm_store(struct devi=
ce *dev,
>  				      size_t len)
>  {
>  	struct zram *zram =3D dev_to_zram(dev);
> +	char *kbuf __free(kfree) =3D NULL;
>  	int prio =3D ZRAM_SECONDARY_COMP;
>  	char *args, *param, *val;
>  	char *alg =3D NULL;
>  	int ret;
> =20
> -	args =3D skip_spaces(buf);
> +	kbuf =3D kstrndup(buf, len, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	args =3D skip_spaces(kbuf);
>  	while (*args) {
>  		args =3D next_arg(args, &param, &val);
> =20
> @@ -2578,6 +2593,7 @@ static ssize_t recompress_store(struct device *dev,
>  	struct zram *zram =3D dev_to_zram(dev);
>  	char *args, *param, *val, *algo =3D NULL;
>  	u64 num_recomp_pages =3D ULLONG_MAX;
> +	char *kbuf __free(kfree) =3D NULL;
>  	struct zram_pp_ctl *ctl =3D NULL;
>  	s32 prio =3D ZRAM_SECONDARY_COMP;
>  	u32 mode =3D 0, threshold =3D 0;
> @@ -2586,7 +2602,11 @@ static ssize_t recompress_store(struct device *dev,
>  	bool prio_param =3D false;
>  	ssize_t ret;
> =20
> -	args =3D skip_spaces(buf);
> +	kbuf =3D kstrndup(buf, len, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	args =3D skip_spaces(kbuf);
>  	while (*args) {
>  		args =3D next_arg(args, &param, &val);
> =20
> --=20
> 2.56.1.839.g22a8290db9-goog
>=20

--=20
<https://www.alejandro-colomar.es>

--dgsjs2ke7evooars
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmsIFtIACgkQ64mZXMKQ
wqmnnw/+IhueUt4H5bq+DHR3fv4lOq4IBzTRkEugCwDpfAR3Ckp7cjPP4SnHl3ty
PzPlpWL2ljrwnILODZ51c+1MT6cazfEzFSTzYPLwHxT94wRz+RbD0hSwsNEYrRnJ
YJJ1Lh6V86Gj5qv9hwwYhelbzRrESW8GNVvVh0XJ/GEoSjkhoXCP2VZ45iNk3f9K
qzseQFCcni91uW5szgY+SpeJVBxQCEFvVNsOKmcfnemeGJIVRwHTOLrng2zy8J8q
h4o0XjhGG2olNbK3GuuhfDgHq7XPop0WPflv1Q+rcNIKEXQS95OMwqW8u0Mqh3ow
2MnAAM20bAHRgZ1i8utJ6IOwJbD59Hi+9bSh3+NluYdDyLYKTFxAE/BcXhG1eCDC
kLsdGzy4VvlQjpyqiCItPHkZ7l81gDePUoq4Aoxe87272AZDTYdVmRX3tA0wF6KH
8hX4aLrP6i/NE/pJ3xk2JfctH0XS903LZc0E9B5X7rw9zbb3j4f0f3BO/L5DBroJ
ev51US0NJHz5sWsS6S5qLTvf8QP5168cD8OPUJkx7R3OWFecwSZyZeZ/8IJqjjFT
VrKG3eFbgEtMmoizFmDa221jtl2qfyDRezW5eUHmKYuN07fBfA8hyGKX1ut4LtKs
X1fK5yrOO5wOZMmfu/HFO9NFNCx1WHg5ILnXIbx2wM9nwCDUICA=
=q8RM
-----END PGP SIGNATURE-----

--dgsjs2ke7evooars--

