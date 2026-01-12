Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F2FC9EC80
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A4A6B008A; Mon, 12 Jan 2026 07:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318036B008C; Mon, 12 Jan 2026 07:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2169C6B0092; Mon, 12 Jan 2026 07:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D25F6B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:46:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB621BD7D4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:46:49 +0000 (UTC)
X-FDA: 84323286138.27.AA70D31
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id CDA64A0012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:46:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ceotpdgL;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768222008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJfksYBMf04F9YsRSch9TVJyappZDo9nWWGjONWbc7U=;
	b=X+7nGe2WnK+uTpcv2oDBifLZXDDrXBPcUxq9K7DxDmpbAiDd1sDW1yn1ghzYlwmH9tGiTT
	CcjbA9Mt2qc84+QMfDjF0UA4qzQaMnYrjKC6dIGxQO/QlKmPyi+0VITmYO74GCWe30gjkL
	VJ+IU+SflHclmK2t6H4HYZyagYNuKj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768222008; a=rsa-sha256;
	cv=none;
	b=JW/G7M//JtCDaEX89uA08eLRLv89E3M50ammti7aG/K9oNX/3cbrzZ8PmhGW8m7Y7voIDD
	cPw3n9g71PaVh2Yg64gJ6py/K4rNMz+ZHwy4C3g6KemhuqE4QPG8EAeMGI9ZQj+bnyFWQZ
	DefDT2irE0hbEBAVW5BaEWeL9m/io9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ceotpdgL;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-432da746749so1471001f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768222006; x=1768826806; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bJfksYBMf04F9YsRSch9TVJyappZDo9nWWGjONWbc7U=;
        b=ceotpdgLld0wEuWw4052zNb03hFYZcTunb+dJMdS+ZJmLU5oeaaVLdrhA6vWpi3Zaa
         JfzonXxChn2RGezXTuQVw6bWN2QzQrczkKF83QisSZ7UgGvvQwT9V8ZT4HL1d9HBrGrZ
         JFasOKT9mpg9nqvZHuRFxhmwCqkhbog997nAbeKtYUTiLQ6y+6ZpH3rP2kbrC3dh+06t
         Rd56Wmpc55VTsoOuu8quuVju+f71KBF7vx7dE1vBDdj2ZuPK5UUToPcAZ2PD6WJid1m5
         gRO8ThUzInzTfAV0Yi+/6mCAeClF4i2u45Se3nmMOakguA9fd9CMmPZu4jNbSp1CC/lU
         j9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768222006; x=1768826806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bJfksYBMf04F9YsRSch9TVJyappZDo9nWWGjONWbc7U=;
        b=pPw27LzbEMmWYcHKfxGx6+sjQ5zN307sXvI7aYqkVav/HxmuBNTN/IT3zghH2/i5C5
         z38kQlzY7wTdO0VrIT+foSmWTploAmZv7Q71nty6AX1/Dgp39IDnHmAcmVGYq1jsIXVz
         Jn+e3wlipWQaO6MdVCFAOsHRoUt1Xi2t2YxgvCDU6+zHfCXUUXWk7WnHm75e3yXaxQnb
         eHFkDntLxjl7XRLXN+QJn81KCDwFdyL1HvfiKBN6uwVFZzrLzIGlXePy7LOCxeeIBpr+
         0DQZ5E8UKtljs0R0gV33M4itmA8FD87O60J/rE6S+vcczJLauwSzyLmhUPrZHsjglodh
         LG9A==
X-Forwarded-Encrypted: i=1; AJvYcCXAltwM6uAkYd6VrhLjojHtp5uWj8y+5O949ShiKBht7jzU0M+RINYm63yX6FRMGjH76DUnHOuKxg==@kvack.org
X-Gm-Message-State: AOJu0YzVdBNGyLiAfqQS9M3vCeoRgxG6gc0/cmYW8jSYOqumky2mAFDC
	8hwc69B9XyrPboG0nf2ZG/LhnxaIjwr6/mDOSkC3DvsotkK+mxTyL+qg7MnLBIXYHqg=
X-Gm-Gg: AY/fxX6ExNw+qHt7V4OO64V+SOpE5ONF9Y3c4eS1dwjjD8ns3cOcFMLdjjs1eK7l0/g
	5pCT3C2cf63MXdcgEKcwrOvKr1tqGGbQcSZ6dVR+WuXdY3L4NjN6h5z4efpihwZqPyiPiW1Sgu+
	GWFGK4esOAWs8e6SOXEMv3t+P4C2V4kXKpT1PlY5cjH/KsasVSoIvYfWAfXr3isdIrD2w3oNVTC
	hbcLeD9TFWtq4h5cyKN/O8TOTUecGP4I/Xz1e7QLmafqgbhGsSRUR80EFgH3I2/lbD3Mlsoj1ST
	CmG2eb7P2u0ZsEIicQTSZhynT+g7MpIUWonQmLv/t5dyFBu9maNjewG9DKO+qgFeW32DQNaGY/9
	hPWROBYMzcWLSy1q65h3PwJXncWgZSP6pLt3KsJmJaJ6TNpafSRhPELQKtJJ5T2GdV6cLYr0lo9
	QeNNFani2HkY28Q97Zlwf8MLpD+Zn0thY=
X-Google-Smtp-Source: AGHT+IH2IebLAKFKxY8Uvt4jUIFFT+Ij8Y6D7r7fSKRO8YCnnaSQ8GLFJdjyy1UaUIlKGcgUiTElog==
X-Received: by 2002:a05:6000:26c4:b0:430:96bd:411b with SMTP id ffacd0b85a97d-432c3775a8cmr21299946f8f.58.1768222006097;
        Mon, 12 Jan 2026 04:46:46 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacd1sm37877453f8f.4.2026.01.12.04.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 04:46:45 -0800 (PST)
Date: Mon, 12 Jan 2026 13:46:44 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
Message-ID: <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
References: <20260108050748.520792-1-avagin@google.com>
 <20260108050748.520792-3-avagin@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o7rqwh4s3kscjtie"
Content-Disposition: inline
In-Reply-To: <20260108050748.520792-3-avagin@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDA64A0012
X-Rspam-User: 
X-Stat-Signature: tjqc4skkjc5g6igraecf4wmgwmno795x
X-HE-Tag: 1768222007-56843
X-HE-Meta: U2FsdGVkX1/NtFEkwlIXE5MRLd0iP0GaS446h2i8CUn2RYb7/0KWJtu7dbI93gSaV4kb1fM3ajm8AWUuJo60oHQ7vFd23RZirS1U9kB0sxLJcyti0fPLPzhbJOMioS+1Z46YMxkHFQvSJecPnRM8tA/FNRC52pry6tngalhINTmmE8Cyf0ygw59ld7e0cKQ4gD7KbT7xDcpJ1UplySq9yt7pIhz3XrLmecx4vNJL0slo0++D4M8yFxQzbRTgsdyFEY1HpoNo6qtwzfCJLu+m1PHyA9tc3er2pMWcavSlwa6bfJeEx712wvSaG8aKyPhDwHJcpCrnq+A8TbuNCygiOKx6NFXu2SJmUecj1GhQaI7gr+XprrQ9Fa3WSzIqNW4kQhCgDLYc9XdOP8vfspRhu+IRp3ZDa8J3/mFWNEo4bTiUhjvnIwNFPX+w9Yj7ID0XOKXjKBAPGKKoF/Ah1nbKqj5K76VKW5IdA3zv/E+dZ9zv2x/NP0v9ZW3H9X5OnTxrOaoYP+S6Nuv+cTf6jnzW9DhYta8qAZ2OLxuM867zjjuqA/bMaTpgv1MQDs+/fWGYF14pWygMwos5GMoBREieIkbLM2+jwExJhvQ9oeP+iOMzTen/C0fLEnxJ2TEO5gpDUW73l7hf5GtGMshRw3oK+bUWPwpGlxEvgSKwJrCzNm0pwEmchWazvXeaG88YPLhkST5c4abkJycgN0sDNV5q4qrT1Dl9tFdfqAU7QdogvaJN6v6yYYaPNKiIc0ZMTeMWRXiyA34YisaGp+n4cQIcjY8xHLU1jKGRJ7Z5PloENXI5T1KwShmCf0/YnzoW8X8bTOCxceF7Ul1fwf75FXmBaQVuqaitZenP5o+QYRikNXfIo+DbWQjEcksJWRgcZ+I29uvHfpZT3VyNKFyKvQbBZF2cvGlyTe1Bc3585j8pJUf5FUwejoRRX1UcTckIqPA+dYsnkQHIx04o1Ok4R6L
 RVcCsXiY
 cCtYsCn1wxZLIWtMb15olOkIWCSDrWnPycHzgzbfU+ZlG6jThmVmHt7ablSyMG5FNMQmKuCIzFNcTQ4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--o7rqwh4s3kscjtie
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
MIME-Version: 1.0

On Thu, Jan 08, 2026 at 05:07:47AM +0000, Andrei Vagin <avagin@google.com> =
wrote:
> @@ -1780,6 +1791,50 @@ static int bprm_execve(struct linux_binprm *bprm)
>  	return retval;
>  }
> =20
> +static void inherit_hwcap(struct linux_binprm *bprm)
> +{
> +	int i, n;
> +
> +#ifdef ELF_HWCAP4
> +	n =3D 4;
> +#elif defined(ELF_HWCAP3)
> +	n =3D 3;
> +#elif defined(ELF_HWCAP2)
> +	n =3D 2;
> +#else
> +	n =3D 1;
> +#endif

Is it guaranteed that HWCAP n+1 exists only when n does?
(To make this work.)

> +
> +	for (i =3D 0; n && i < AT_VECTOR_SIZE; i +=3D 2) {
> +		long val =3D current->mm->saved_auxv[i + 1];
> +
> +		switch (current->mm->saved_auxv[i]) {
> +		case AT_HWCAP:
> +			bprm->hwcap =3D val & ELF_HWCAP;
> +			break;
> +#ifdef ELF_HWCAP2
> +		case AT_HWCAP2:
> +			bprm->hwcap2 =3D val & ELF_HWCAP2;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP3
> +		case AT_HWCAP3:
> +			bprm->hwcap3 =3D val & ELF_HWCAP3;
> +			break;
> +#endif
> +#ifdef ELF_HWCAP4
> +		case AT_HWCAP4:
> +			bprm->hwcap4 =3D val & ELF_HWCAP4;
> +			break;
> +#endif
> +		default:
> +			continue;
> +		}
> +		n--;
> +	}
> +	mm_flags_set(MMF_USER_HWCAP, bprm->mm);

Will this work when mm->saved_auxv isn't set by the prctl (it is
zeroes?)?

Thanks,
Michal

--o7rqwh4s3kscjtie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWTtMRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AisSAEA3jOw1q2q7fyDcfOoeTcd
ydeYIa3MJ59Bw5P1NbVJP0YA/0e1/9IiJ/h7y8JbPASpknLbuJY7oLSlA/zl9MUy
MJQF
=Iqi6
-----END PGP SIGNATURE-----

--o7rqwh4s3kscjtie--

