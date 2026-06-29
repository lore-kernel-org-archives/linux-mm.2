Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF1EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2330F6B011D; Mon, 29 Jun 2026 13:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB296B0124; Mon, 29 Jun 2026 13:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBC56B0126; Mon, 29 Jun 2026 13:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE6256B011D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:13:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EE2312020A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:13:13 +0000 (UTC)
X-FDA: 84933595866.27.A65D254
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55315C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:13:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="XcDJD/Nm";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782753191;
	b=l+GFzROVCNi18bN6DBVdSGVTHXuNYMNixFt2YNmbYKtNBsBWKIv+q02b2/7xiHd1VMHnrM
	c6kHnMVRNbUwkNo4eSnlPh5vSzOC5lSGhlG1Ru/82hlZS5FJsC+CCfbOCWljXCWk+5pbXh
	AyMgs+Cg7B36BKdEwkzwQ5vpzjwd2rw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782753191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjxPOQH9dsYrwnC5fAn29W6IVwdnwj/ha1x1VZNjddo=;
	b=EUhBjTtmGaox4E0Hm7m7ET2sEXLUWcUa5ztm0e0MxD06gQL+74N6v/P6U4cZ7nnbbXMGMU
	HZLA2lqidiEuFyLcORH/4dRYGjYishgGyn1lnlKboL0vqHxfM5dOp4UzBBvY65wvkTnSd6
	LoKbQ2vzob443+K9dZhp0U2zYjiGjAs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="XcDJD/Nm";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-471eeac43bfso2076467f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782753190; x=1783357990; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IjxPOQH9dsYrwnC5fAn29W6IVwdnwj/ha1x1VZNjddo=;
        b=XcDJD/NmawKSxrpMvs7u5v/KTKWzLhhFH6xWPRws1dd5kAIRfeefb9bZYoLF0RPWYq
         TuwH1jUoPwgUdUY49lWBbuuOST8y/RA9M311X87i+uvU6bNp5mOd1if6S9Hw7PxhbeMk
         svqPufYZFDrnwmw1IQxlcq6A2ICZmmzKNfetab4GPb4EEOPGs1+7MxsWb8ZXGpd579PJ
         TAnUlnmJu1wZcdBr8n+1pJDLz0gqvK5uDSXX3Zzd5/d+kXT7yJ+wSbO+BYfTJj1AiMH6
         J2T442aO28BqCjYvfKl4bfKvDX1kK/z6YGfDSQePNBviBbk7DynT2muuzyS0F9ioQpou
         7odQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782753190; x=1783357990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjxPOQH9dsYrwnC5fAn29W6IVwdnwj/ha1x1VZNjddo=;
        b=NjTBueS7fgX1v675esXUUTfT7S84EeIuhAFQsmOQGoGLMwmIPYg0zUQD7nDmMTQ10M
         2ngg0ThJZJ3eGmvHEcCfyp9ckOWKRkjS8potclIJ+yYa2OZF38c11KPRmdR3zVIUw7Bj
         r8KIK+XZdB73Cee8q7EYQtJSefom9sC2OrdawUEmEYyFiMEnNkFd2SD8Mbl2NC1XRsJB
         pNGXsuqtk8KT+ySqF0RByjzW+y4QsZdY2/XioDAooAHDTAHY/bfmQqLeQ6oiKn/F50ml
         Ys1j8smpDJMCKG8q6pil5dThQsmTduaQoDeDViIehFf9SAzDEp0jjmYdl8P5JhyQHGKW
         OWoA==
X-Forwarded-Encrypted: i=1; AHgh+Rptx/pFciWoc8HNL6rsfOppOGvkDNL/QgqK+3+Uzmstt6qLewx+LgxwKWnCKEPblwEiTmRx+YD+MQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2UY6h5vgrHvdyPdWaqnPbb7G83yMV/NvZwLwZ2o1pucTQrXh5
	wDrziYSf4MrK8QuUfRy4QT+DaljH8cD5mfMXu1HBHvjG/nZX4Kp+Bf0qLrtP/MQkmhU=
X-Gm-Gg: AfdE7cmIcTShL6EWhNv8Ky0ucVEQA0EQNQIZgYpvMwsFRM9KH/KE6zqMBu+5TkzNMLy
	xQJh6pbXHA/sxc7CK2R9IfrIWJfs1epLnjtZN3KwXmyZSO0+UCti2vGpFe8kntRkF1v8uN1kCJm
	jV6O+SK0cVyilkAZLaZMpJ1CryAXCzMY+amfeZTRL6aBdmho258gX+4b/90KbVqksXKF0/11BT1
	ROmCxdCzxkj5HRV3D2lfeRSxSjN6Jq7X8sFxQ2azLCMkjsPAaj767vk4Y0Xg13As6ZB4fZGn++W
	5awfiSnf9ijy/WQEWsPETr6Mzn7YmP9tOHhK2XGaNe8c1ZOkXE36eurVU+HoZ0XBPTzLny9EaWK
	p9W95ZerqkjFgQvspDHbhT4JHqW7rag3PJs9mRnaljCxDqCTcS34shlX9R63sl8bbWhOg9+2rnT
	tfc+/hGUESNN4fqpv+8g==
X-Received: by 2002:a05:6000:2dca:b0:474:6a5b:85f4 with SMTP id ffacd0b85a97d-4755021c1e7mr128422f8f.5.1782753189725;
        Mon, 29 Jun 2026 10:13:09 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-472c7bec9c2sm16484408f8f.12.2026.06.29.10.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 10:13:09 -0700 (PDT)
Date: Mon, 29 Jun 2026 19:13:07 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akKnaWhg5z7fI5CC@localhost.localdomain>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akJzXU52XJ9-F2IB@localhost.localdomain>
 <fb000c9a-add2-4c31-afe1-b6ec416c9058@linux.dev>
 <akJ-It8m_xm1WVLY@localhost.localdomain>
 <fb9af391-b991-41fc-a105-7a3008860c07@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rrapqpygxnpxs7uy"
Content-Disposition: inline
In-Reply-To: <fb9af391-b991-41fc-a105-7a3008860c07@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55315C0005
X-Stat-Signature: jpndbkh5jr6x15bhzruud9sj5f4kdxkg
X-HE-Tag: 1782753191-858996
X-HE-Meta: U2FsdGVkX19SgTWUXKEspDtHic7Yn0kXTDcW9TOPOFa0cQt2fTz7KMH3mxSknPgsCud8fDs7LRCUWzZCVa3UM1FF5d1Bbuo6gk7iQ1R3tyZnSSTi1SV7QuzqG4VTkJUVMKlYo4M7eyUJXU0wgDsPcESTwDEPNvjC5spxXczgvd9sqEb4IygOwfneagAGvh946CrYQLVsvPGJ/Xrw3+1QE2KVTwiyC6iOR3XzyThbosU6TN7hE7ySEPRRkcKAEIkNwwhvUVkGlgPsTfE/WzpoYrS/4VI6rpRSaBGTERQBrMFHqvgGCT5owr/XM5bVP4GO84Z3svdK8nMfXuxhX75+C8RLsZ14EdlrxP3Z2Md/8hGSjVTYochX3oCJ5h9AtdjkzgRadlSP+MmOfCgjbvCD5mGZODpHxk0JfOGWnXU/4z4ksGYREFCsm2+y4WnlglVY7PYV/1Gw6he0qH4EaLqSDgMo8507jpDoYUBb5h+SciBk8RbWGUXJtsZu3RcbpBqesuEuN6EQcHwtyXOKoF7Yg4DiuhPU0OdwTRPboMZcSKMzCwr/BYKc/Nccphs6QfkI5DBX4irKDVcLm14esF3Br+FYNvNIWOnyjPsJvqKIKsGYYPqR1cSEyOABBV7pAEBq7KLtY8l/wlh8sw/OmwSApTV7XrBB60Ia9Rbor5RHbaOS6cQGBdOoQ83DJq30uE+gEQywSDtmJUyYi1YsvkicM7D2eLastVG41VlEUffWA/MrJnvY96COUs+9MxuVU0UASd5qNUZPP/DMtMrcuD/bxFLlB/6No1YEDRBUI+sEacYUyi1ag0ZRC62fg7UpFadzXZwxYJlhGQQ9u6bjp4nqVmVWW0KzEos8/8gJ2U1wuuLu+ja6wcCRoRwZQ43dp/YVxeOcUK/RiEtWKFmk5LImnEDdg+Zvsl1hI1xzjS+LKGxFY9K7e46rP0i+2ey9bUGMAp1+PFrreHcpZAnuGiN
 /utAPR6a
 l54Va5qmWsWTjNpXyibs2jkeTj1OGEDDmfcdVtwTDSqhYvkUUnmVmEygXiBcLShJUEHIhux8f8ff4iWhov1btLOtk4oaf4UZutG9sFJh3f2XS+UGBoq2UaRFw8Dfcy+Vt76PMQKX/nkqH9H6tgZcdKDKW9aPPsK/P4KPsne0LYEllHObZi0o14qKDBB+ZT4rFk1LalKGZVTRN/LYcf8n3mexIEn4i9gT2xDZa3M4TZYaLnpoLenYAo/uGDKp/3/8GjmXzwUFJGGhZ4W2UnN4m53eU+5KnSQ/7UduH4I6K1MXsGUcY81iOc3wJCmJ3k+l5mBUkyUI+27baWc5K0yNHX0aMNsn5gLhzwHK1JMAiQk/mS0HGduLAQ3QmkiubI/uX8tkEly2xJbhRWZ/1vwW3/CPg2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rrapqpygxnpxs7uy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
MIME-Version: 1.0

On Mon, Jun 29, 2026 at 04:20:10PM +0100, Usama Arif <usama.arif@linux.dev>=
 wrote:
> So what I mean is that I want to keep the effect of the patch that splits
> off v1 code as just that and not have the optimization of not running
> vmpressure for tree =3D true + cgroup v2.
>=20
> vmpressure_v1_account_tree() compiles to an empty function in the split
> patch for cgroup v2, so if we make the splitting out v1 code as the first
> patch, the commit is not just going to split v1 code but also do the
> optimization of not running tree =3D true cgroup v2.
>=20
> I hope it makes sense?

All clear now, it's clicked for me what is the optimization and what the
cleanup.

Thanks,
Michal

--rrapqpygxnpxs7uy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCakKnnxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiZQQEA5shOMA9XtHVDFhsoKo/B
JPSMJJHtfx2fo+NMfFAW3tQA/RAOtjmt0xMeCCHJoSUYM3GkkY5Ip9r8qkNYfC8l
LPkH
=Sthp
-----END PGP SIGNATURE-----

--rrapqpygxnpxs7uy--

