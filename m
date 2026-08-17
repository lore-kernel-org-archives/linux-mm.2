Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FD3C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A85B6B00DB; Mon, 17 Aug 2026 10:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832D86B00DD; Mon, 17 Aug 2026 10:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7213B6B00DF; Mon, 17 Aug 2026 10:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F36D6B00DB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:02:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C23B31405CC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:02:34 +0000 (UTC)
X-FDA: 85110926628.23.C057413
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15A16140015
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:02:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y0fdQcbf;
	spf=pass (imf26.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975353;
	b=L0nccQpIyehs6vBNksStoNdmGzoBMElXS5mJxlbxm1NDYcay0a1qzWj01RyNEJXMFLNSuJ
	HCzZ1280+RU6PHfOJtRZXBBrzgN5HS/AmMffvzoaJsmYigiRlCrPbXm3kzfCLu1LqaU8mf
	/QBqhhL/TUe0aIOTklvCv32s9h+O4Mo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y0fdQcbf;
	spf=pass (imf26.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bk9cL2KwgbRIb7nFwPdx5v6FOYyA9DjpsbTLZv0L1eQ=;
	b=3b50c9h72nro+gNptaNCHcrmneLj3PU93nMjVRUwYLYExuoiCztcCdDpkkLcTj2FLKV8TB
	PMh+gK9+LSmzbQyaG6PcpRC/18zILHpR22ggFcPT+iF2BVxT3/HLov6jVhB7HDMFIsoJ5K
	2HTAsg8Y1Ziclb5U12KzO4+GYD7A1Xc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 841FF600AE;
	Mon, 17 Aug 2026 14:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71321F00A3A;
	Mon, 17 Aug 2026 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786975352;
	bh=Bk9cL2KwgbRIb7nFwPdx5v6FOYyA9DjpsbTLZv0L1eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y0fdQcbfy5dn/lI+yaPAltT3j6k7+vfjdPcicURAunKJ0n/z6Ts6qaRa2AQVqc6pU
	 jcNPzCElF02SHYK35UcHOuWU1fv7xQIi1GTR+XqF+UryArI+SRmggY3LfKOmEMsSvW
	 dnMYlqHMKtkowxUhDeUanWaXuckc6bP0hnSpkXUCtSC56i6G/pGLedy+v1AL6Oz/EY
	 /dJu2mBJCvKwVIAb6wBVApzGWiOtvkvTeI3m7MlYozvqmCvGOc3KRZHwvO8iz1C6Mx
	 cJxWae18iVMl0VXCkNHaf1dbUTUhQHcwPQ0AJ3rAnD84tCCJmPuhWFT4qS7zk6yZ94
	 xdp8YrNZ+q0LA==
Date: Mon, 17 Aug 2026 16:02:27 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
	vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] sysctl: Disallow partial updates of
 miss-formatted sysctl vectors
Message-ID: <gxiyb2aye6vvu6t7veykvptj4t3hxll67mugievbumjc6krstw@nivusuyqhpbr>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5sktdhveowv3yy7h"
Content-Disposition: inline
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
X-Rspamd-Queue-Id: 15A16140015
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: weyenzcckr55etjd6tzk4ozs8dpsb7dz
X-HE-Tag: 1786975352-455791
X-HE-Meta: U2FsdGVkX1+oCukPXZ4YLhL1qr6TYUT+cIKi9n/FJ/Hg1Yi+ijateRVfjSOjpmqeDnrHyCswygBDaEdjKqDB0l47YJjxVNXRC5H+P7QQsMg3pXhTUJR8eqSJdiyzNU3/uVZhi8aUnqawqL47ti+YAfq2MygYt+zdws9hGpaKRrJ0bg8sSbZgYook0NPE/1+XZ8dK5xlDIShd4/4NWiuXRxnQDFcZgSiAmHNZ7Xbn1MhXwhvc79QkDPFfLkuC3dlnE+fmK3y83fD6LS7RtAiACbqBALXX000TroLTN5PPV5mQ7p8+ENxoInvUkw7fCInTxr6HfScDFnIp0wf5evM/sSHqeygIzigUG+pDp4grNnjHZEabnMz91BE9tChvib3daSMPXWrexQNKEyWi91Je8hfB7YdT9Nsosk8LQe+8MfRImMvSkNSMCpJrSQt+u+oUz7HZXAVK1aKQtNQ/fWHTBDPOYPXLWpzdDMVoOdzkeTH9sf2xk7hNdBVn9gLjWpFWBFA+SFS2DKoDyl6XOmgsWi3D3jK8rktHqLyZLnbENazkebikpzswbQZRPVyi+TA1xk8HU4MddtRnHe0whxoUjTNKIQreO0pTfpIaxvb2hGq5tSmhOqJNhwjF/0vOxPwUSAPNa5RyRBlmAad2RgsjuR5h+62yJ9aFNq0tY8GXEgTEn+PNwbFazbeH8bD8yXjGteFuOSAEvOWJhKS3YmCeml9R0BdWqF3uDsB/PbNjE52ao1vwG62KPdHucumXe5q1wgrm+SiQhIPGhT6NwbkmHQ6il6dj2UDuktrgcdfW3prR5OdySqdNk9slQncvv5wjO0brimSPXMPl5AM5qyMi5jG2pnGkwPA67XXNQDTYD4R8PexVduBJSxuKR2uj+LpYnyc7/b23iWaonJ5RrBZEKajBHqkHt9aP9/Gfovj79RSyizjgv9llf3WxUkFqjsXh9cFag059+YePnGhr+zh
 LFwwnsgS
 kjRqKq40AdaN0aooyz3PIufzPiSoCs14nbGjj5skAsHSuh6b2fTgVc+Zo87N1ghCLFRzoQCdT65t/xdOBUHESqaqHFDjsH/mIIMh7BHCaqb/Qc6Iu6tQJt3Ty5pVyMs5/Ov2lebJEhhsGc8JZyrq5UOYgLegdZm3+fBw7lUbK/1H/OEWoyC8I8iPB+UkT/scsAvXO+8KDthg0MCebo3YpHPYov7fJQCLHYo6+4mJiT7gzJOFpXeaGVdnEtvO/4jp5j10ltDYbSHEKJBcPHA+86/0ZOR+E4vyrX293SU3uLC2R0XZnstbfgsOjL0X25a1TvteZ5xf/O17zK6ygQnzXLt2YaWVcR32OvNY5tWhAv2WCwtH55DhetT4VeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5sktdhveowv3yy7h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 12:41:11PM +0200, Joel Granados wrote:
> What?
> =3D=3D=3D=3D=3D
>=20
> Stage table->data when writing INT & ULONG ctl_tables. Commit staged
> data to kernel variable only when all the conversions have succeeded.
> This is applicable only to variables that represent a vector; paths
> pertaining to scalers are left unchanged. Notice that partial updates
> can still happen if less than the size of the vector are passed and
> correctly formatted.
=2E.. snip ...
>       sysctl: Split data conversion and file position handling
>       sysctl: Reject uint arrays before calling the general proc_vec
>       sysctl: Disallow partial updates for erroneous sysctl vectors
>       sysctl: Add 0013 to test partially updated vectors
>=20
>  kernel/sysctl.c                          | 237 ++++++++++++++++++++-----=
------
>  tools/testing/selftests/sysctl/sysctl.sh |  60 ++++++++
>  2 files changed, 217 insertions(+), 80 deletions(-)
> ---
> base-commit: 4c12287001da60f3c022bb25932aa7a5590fc0b1
> change-id: 20260813-lklm-partial_ctlvec-bd8867b70d5c
>=20
> Best regards,
> --=20
> Joel Granados <joel.granados@kernel.org>
>=20
>=20

I feel the superficial changes mentioned in the review (up until now) do
not merit me sending a V3. The modified tree is here [1].=20

Best

[1] https://git.kernel.org/pub/scm/linux/kernel/git/joel.granados/linux.git=
/log/?h=3Djag/partial_ctlvec


--5sktdhveowv3yy7h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqDFHIACgkQupfNUreW
QU9Wtgv/W/Mxbk0Y5tHUqDrqO0jIgDma4VYCc49F8BOBiB9Y+y1EdV7R1UJ3rIwv
BttI+rtCWKIsKBhJEZBHsCiyX2k83LH93TfXi5Wihrq8n/YN6xMzKvOU1mxSH9uB
2MHNuUAmTFJtAnt+GCXroOizzsivvzcN6Xr3Xf7KseVsvTU0Jzn7YzX2v5gAbwK8
6VhW8uVlbD0oPpedkkZAWA/Il6jKb4SN431WgYOt0hLU5TniChtQs37E7JZQJmkJ
s5D7/H/E+IhhIOs8PZGUyAamcZe3I+DIQzIl2o6rPSFxZfwpqApJ+ZRGvKDdbSOk
6L0fqamT6DeTIhnYvpQ5zte+g69C2sWP9+PU+5bjbeAtcxrtGpo4tYie53GANrc+
o6N/qR4ag9GWVNk0KfEavJCcD7kBZuWEiF8UoZSS8EGMkczn+pnvjMSFoCUfkKSx
kggJHEsI027hD2yZXnTWeGk1YWmFnAlfVx2vbIMrdiH3OqeMA4kHt0otPqaxPy0Q
llqAqVbl
=78b3
-----END PGP SIGNATURE-----

--5sktdhveowv3yy7h--

