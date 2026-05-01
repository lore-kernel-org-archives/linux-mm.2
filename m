Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BD1CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0103E6B0088; Fri,  1 May 2026 05:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03736B008A; Fri,  1 May 2026 05:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC106B008C; Fri,  1 May 2026 05:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C648D6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:12:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76F771C042B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:12:33 +0000 (UTC)
X-FDA: 84718285386.15.5CB2161
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf02.hostedemail.com (Postfix) with ESMTP id 55C7980005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:12:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=d6mfZaEz;
	spf=pass (imf02.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777626751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzcV1M+T8FfAi4DN2fJXrFtPXcwkXnprEF+h9z3CYic=;
	b=LUCuEGwjTVMKmx5YNyXE+4n4A6wnANo93jz+lZgCrrB4IYTfpICgmOM1HtabXUj0xeEQTd
	/np9ujj4nxkcROcLl4iMWFg9iKKwW00F788gptYWv48J5VTfvMzAKsAW8+YWGL6Bf0w/n7
	DRPspfL9mASlNCqJfJHImpbMR134gvU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=d6mfZaEz;
	spf=pass (imf02.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777626751; a=rsa-sha256;
	cv=none;
	b=ofURqvrxIlQrwW5InSaMStwVWoX8NZU2/BacKEgqZ0PuycIYD+/z4ig+1iqW0ZzSwfgtd5
	0rt+sXrRHjao9lSZzylYCK22ITD4F37IQjNul+aGVfbtkequdDM2yKz5xnKwbVHdGj++F+
	+vaGwtvlm472jV6vRoEtUuEupQBrNis=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g6QKk5fV9z9tZv;
	Fri,  1 May 2026 11:12:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777626746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzcV1M+T8FfAi4DN2fJXrFtPXcwkXnprEF+h9z3CYic=;
	b=d6mfZaEzzOCM3NS1kzxxqsUjUjR+v4/Hln7mczKvYRdqiHkeUBLQqikdnP51UodlkpYl02
	Fjt+94cV97IR1snj76vWJ3VBrqUimKwe0r89jetTL3NmH9PjEskVCasfFsq9AX+VdW62qj
	5/vn/eTrNj+3ocpIXzkJSVKHSlj1J32Ru6j2bwwUx2eBdZRfK+7FjnMePEqV+k4Cw2jukq
	uviIKZlM3pLETwFsfkWqkTHTC6OiPzDg1081dax4Rxw2Z75pfVK127mJtXu2VoIZ+/9EXi
	uSxnBlKrjHKZgTfc8nrkNZWhri76a7TeJ+TA/QH50fYPGAexBmsSBaSZ5g6Muw==
Message-ID: <755c37fa985eb3112322ac77be661d6e3614ba44.camel@mailbox.org>
Subject: Re: [PATCH v4 1/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
From: Manuel Ebner <manuelebner@mailbox.org>
To: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>,  linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org,  linux-sound@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 01 May 2026 11:12:22 +0200
In-Reply-To: <20260430010013.113971-1-sj@kernel.org>
References: <20260430010013.113971-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-META: ud4ynx1w8xxoao3kkt6yo7rw19de15cu
X-MBO-RS-ID: 634a2d56e1f2b8232cd
X-Stat-Signature: g78q5tmkc1y398kx44k9uqkugwpi6bde
X-Rspamd-Queue-Id: 55C7980005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777626751-921032
X-HE-Meta: U2FsdGVkX1/NwBiKwV+d2OMuOtMLCT1kfyrR6UFbA5JwvIF0bRFagzL/6zo6X9FpmJNKJbztZtfnJ79mkEv0/X5DMMxirnNAuKWsFzwfkFigmGErujcPi8jnZV0w594wnT2ewcq/nYKvj4+oeVpNE4GsMMxSrVOOIBmsBqDPFjlgmnX7vQe1FiQytP/kRZ3B/drt6r62K6nVz2t3G1R2GttIbEu7i38GO15tSbRG9SdncmKGIBEzBiO1BLBZRu8lZnMYP87avWswOIjfVAlBh2+B3FxT3GpbcKPvuIbkZBt/9EkB4RQHqsGEL/g3KTB0PEG+QR67KjB+XWhq/dk1xPYP61dS33D3Gbglg9NnirGnSiKJQfPnFA3CNWW/LHLYeSwEFZ+eWuvRkKFbo1AUXMAMcW/IVLTWLzYojrqFKmfj9dY9Tw+q+OUEeuuY1QQg2i6CcGmz3Ig9xHPhK96/EFnmnIgKdw30pEsZ0j+hQ5moPk9p+v/ticme+NApU3obIQGrnunGIjs82XmCyYC/Wke6cfSspFGhYEDRolw35h1cbu6hd9tim1/ios/OnvuSPdsbrxXhyxSF4PuS/KnKGmV4bLfM0Qlco8JkXXko3nKkPSoqlDXvRPtOtOxgtX/2V3vgK9siBcqPbPq4z36I8NxbSI96P/N+jFBdk5GW9Y8kh5/fhosSuyJpIX4IhynJzwoAAzP/+0eX5ZMl/Cu6hn1TxSY4Lml9Nlo9HQbI0RP+R9toSREXY+2YnFwl5seFUWGLbjk0Dk2M1pMa3qzL01m3Z+5NMVB0ourjsUhexPLrUyZTYbuQriATDzCgtARQ5xZ7Ye4pOljdvWT2AlZQprxd5W/P+B7GikrrJcNkZpptDbecfqSkweFESZWpPhkpU61yXTuWK/4PUPpk/sLvPO0e/SY0I4yNwcp5gkPJ+VQ06jHtTcvkjuGo1DaIa2D0xOL25xQPY+P7SBbbG++
 U4n8YFWd
 EAdOEYZffaAeVhoWAjy8MdcKV6VkTOzjvg+fC5oJw/3qhxEgOD6eXFHBtLXj0FYCAob4d60LonMQT/jB+aiip19eMO2n/y3hwDb6lct7oBMp2qc9iECKfyz3toCgGN9YPHGpasuewbXi7Ou2mdw529Fy70aUSEowbsrq/eUun7FLGL3JaZZHrmUW0Meq9Y/WYoSKHtmDVFX7Ei7HwMLGR2taWj6Z6PFfcgwsxA7l0kbqYWCv4AMmYuLAf74wtcRdz4mFfxGi4zRKN31GnVWGSmwdzkIjOexeKf4yEChtiMPbm9Ex63vz2mKF6xNLzGfJyZVa7JU+MAKUW3KVKQAzlOyh2ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-04-29 at 18:00 -0700, SeongJae Park wrote:
> On Wed, 29 Apr 2026 17:53:36 -0700 SeongJae Park <sj@kernel.org> wrote:
>=20
> > On Wed, 29 Apr 2026 09:14:44 +0200 Manuel Ebner <manuelebner@mailbox.or=
g>
> > wrote:
> >=20
> > > Update the documentation to reflect new type-aware kmalloc-family as
> > > suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> > > and family")
> > >=20
> > > ptr =3D kmalloc(sizeof(*ptr), gfp);
> > > =C2=A0-> ptr =3D kmalloc_obj(*ptr);
> > > ptr =3D kmalloc(sizeof(struct some_obj_name), gfp);
> > > =C2=A0-> ptr =3D kmalloc_obj(*ptr);
> > > ptr =3D kzalloc(sizeof(*ptr), gfp);
> > > =C2=A0-> ptr =3D kzalloc_obj(*ptr);
> > > ptr =3D kmalloc_array(count, sizeof(*ptr), gfp);
> > > =C2=A0-> ptr =3D kmalloc_objs(*ptr, count);
> > > ptr =3D kcalloc(count, sizeof(*ptr), gfp);
> > > =C2=A0-> ptr =3D kzalloc_objs(*ptr, count);
>=20
> Forgot asking this, sorry.=C2=A0 Shouldn't 'gfp' parameters be kept?

Yes, i should have kept it, like so:

eg. ptr =3D kmalloc_obj(*ptr, gfp);
 -> ptr =3D kmalloc_obj(*ptr [, gfp] );

same in [Patch 2/3]

> >=20

> > > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> >=20
> > Acked-by: SeongJae Park <sj@kernel.org>
>=20
> My Acked-by: is still valid regardless of your answer to my trivial quest=
ion.

Thanks
 Manuel

>=20
> Thanks,
> SJ
>=20
> [...]


