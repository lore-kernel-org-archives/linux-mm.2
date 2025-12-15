Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14F8D5B84D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 16:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03216B0005; Mon, 15 Dec 2025 11:28:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB30B6B0006; Mon, 15 Dec 2025 11:28:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1976B0007; Mon, 15 Dec 2025 11:28:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C45246B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:28:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75686884FB
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:28:26 +0000 (UTC)
X-FDA: 84222238212.28.7D7809A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 717D04000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:28:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EEcYs733;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765816104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VZxtE7Htd0xG0D9835NYXF1K/HCgvvqAiOScoqB/3Q=;
	b=h3rs3DKbYHL1oMrtxCs/WKv/zhUgqnIszcDYtEdw2bQJgzeJtQWJqHgqWSMo9SgTpdECKZ
	JajlGs6ecVyacrLkTQS6u38AvApDSFVuE++SIqJPF+gJD1XOQq1xLFilPDRAkFeHQLWZxe
	YOlsyuseEOrqIFzG3I8x/7ennnBBfNQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EEcYs733;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765816104; a=rsa-sha256;
	cv=none;
	b=5zB/za8OAk3xwkY02LMBq+nWulS90z+iozjuVYCLgnebYkpZ6I+nXa4+f0upX+bYQ2n6tZ
	V1YrR4BORm2St1Bl+IanyH3dm9MhNfy4RR1jDk7NC0R2uqEU49BcvdfpxI5qZN0b9ea7gM
	zGKIppOM70P0rQABni/0gXGoKjneFfc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477aa218f20so24202295e9.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765816103; x=1766420903; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2VZxtE7Htd0xG0D9835NYXF1K/HCgvvqAiOScoqB/3Q=;
        b=EEcYs733wwBkXxoKKxggg7taToK4xrJDVFL5xeMrLf90yyZ4D2GzdYiroYBnpS2BN3
         rZztLS4+sVPVYORzSBwx3H5xFCMDNRzo9vPJ1ubF1laQlUVU/KOvPd9Y6SDTR7WYi3Jv
         Wh8N18gmR2chxuioE0lQp+db/j4IeAprL9EFh4ikrouN0y0jXzas3WuwJPrSApfKAITt
         GU7+L0PWoouAGJZ+0lfZBeUrvUBn95dxj+ebx2EM+hFjfWkgTVohm6p0cVBinfpc26yq
         izBMdyMjKt5KieW8FcjzjsVhW21kNFQZRUOUH1YEauQXt+0j8C19uPK5ouFXzRlUzGcQ
         Ud/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816103; x=1766420903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VZxtE7Htd0xG0D9835NYXF1K/HCgvvqAiOScoqB/3Q=;
        b=jd2IDnud6RJCewyP2810Q37UlnwquGBmfJSHJFgTsGnroiCnOjOXGxWCdSlvfyucW9
         sdXaKF92XPVdWPN7h0OH1Y1CDjTpMEi5SMJ0uYmkYqEABg4yxFDmP/pi/xAIeQc2M84b
         HQrnKwszuUbg212yPxqMwnHYoqV+oE0BUq7BjAfG9tTj8uEwcB5P1VLc3V04olPS2wJj
         VgnLxMLDGSgvi3rXeINyNIbtU1GGwsW7e9ufynK6hTbFigwJ815tSm5ECtzwwOMpEjMl
         Oc3B/w3MngPU60PMz2dAoPKXk8apCpbNWhfVgnNHnlSkak2d6mKkfKQlYLtyQR79xEZr
         QKsA==
X-Forwarded-Encrypted: i=1; AJvYcCWBJhJzVnZ1C4SJTXu3IRf7pjt7tzfynHFcgoOFNrv0z2i6Y4WcQZkAjKJtGzVIOvfA20Lx+iGCFA==@kvack.org
X-Gm-Message-State: AOJu0Yz9VedpVVKMOJiB+tm+/4dqtGNs163uZDDu7zjpL7aMWXtDARNb
	oXU8XrxKLkL63Mg43JS/hMQseY7t2VgZMokIS+xH0gEXc5D+LVH+x5aMnLY/hwJBrDQ=
X-Gm-Gg: AY/fxX5IvQTzbG9qKmRxlqQJmTaMUb49J9fY5/KqpWXtzdT6G40jXdm0RYpCI11xsqT
	/CbRSNTJXyljXKdxciXGnm3R1Xf6azVyzaV+sOSUO4e6WNs0HWjo1BMMC7lNthjgCmgUtm9Izzg
	pE5iJB4O0A+RCesRJ1vxF1xujGIh8zS30yFSwmtYi8D/1x0aXElF7y1vbGcYup+m1Ai0R+t+N0T
	gBEBMyAKReM0ruz47PVX7JUT49KlrqpG4zeFgzPSWzQd3yriXsFsRsNuEZNk+fhQ5wC0rrkaSgY
	G/SrHQ0pTMizQIK6XJUcqH17YlO5Jx/4dC0eng/ohVGGdH+HQyhqz1rAI+zTITuzxiiT+4AwLiJ
	BIm97D8yHvsjs7hJNGrNQg8zHPJtV7pj/IGN1r3Kz2vvncA2r4xQc4dxfpIxcs4kIghB5UoinNE
	e9XsIliJ98u+ToLRug0B+HHPkOlyrbC+j5NHlL32NXsw==
X-Google-Smtp-Source: AGHT+IH+vEtmKMOaFGcV/3hvyaO/eJLWmQIOS8AvWE84qSFAfqhronuuYlLf4lGjWK+MYs+zJqABGA==
X-Received: by 2002:a05:600c:3ba7:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-47bd3d41de0mr10847475e9.11.1765816102873;
        Mon, 15 Dec 2025 08:28:22 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f38a4b7sm197204695e9.3.2025.12.15.08.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:28:22 -0800 (PST)
Date: Mon, 15 Dec 2025 17:28:20 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Message-ID: <o3hmzratjkcxms3ylnjiuashclllf7mvz6ttkfrz4lybdiwhhp@yeo5my374trx>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6lc2v3gcqh4z4ltd"
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-3-chenridong@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 717D04000B
X-Stat-Signature: 8by4i6r76rmf9imwine9y476s3rx84mt
X-HE-Tag: 1765816104-941561
X-HE-Meta: U2FsdGVkX1940wjH6HsbvylgNtZuUg620sILFRJMOSJNRNtrmBVRc/5Iq0iLLwEPHyvkg6aLqSSdkIKnocJdk645SBiBSna0GjI8DUYHMbK4fsglp5Onb+NKn7d4r/yfjWsqepI3Vw+F1037E0556P9uZjFt+wolRbgzQL9DpFun7TewZOCJmYvKQtsutpiDh2tnF6IuMHUa/kCE+06hJrcmIl221fn59v6nX0eNoGckt0IiwZCaac+bEq1x/ZjAsbFUu1WJnh+JYkGBwE19YSTQoPtjipu8F3XzF5AlRLPdScN99BxpEyfV8hJ/rJevLXV0ZU+nS8sET2NFufqCuPL/5//YF4M3eLt8ZRS2R0N+XYLwIPni7lyY6E0Qpj0iueYuK5GLCEb+vZScY3iVTqFum/8V5743/48Uqmia9pQlXKjW7lkgwRZacOAWQ7fZSBkQAccPPDHuutqvz7g+kPoT0qJxY2DPQVz1fG1onnBeomWDRh6IXVaPYK1rryUFOVcGBI6p+YrL1yBfxUOQee+WTtjriAesiEdHfLIZ+Cvqd1ArAAj0TqVuHqssnaQjhHLsy6OVAI9nGW6feKhujbPXfPzoUObyVC9Y/xTqByzkpMYs2F98O0paBkK0kHqs34/k7vm8/xLd4md3anvheblSYagbjMxBQG97Babmm+ymYEY9QVk6XSbjR54jJEzKqmBHu0MWL61OgK/QqKqf34EJ+Kxvuas6oehxfaUTVfWmdG1t8W64+b8vJVh2HU8zLBDSBVbqSlIcGvT+IlhVSHPNCRzhMH7SPj1tD/ruohIuz/WTSS9rInaaMPi3e6i/8KG/D67A37oTpWCdtYKc5nCfjNcFhBOvOqSiFr315p22Ncheh93E84gBV+eKMNqDGMDvCRu+J3u8I+qm9/spytLMsNdslLYPQIUwh9DQuG3muO1kOAo+5BtwKe/ppGpmywDddkcasz17LfbTgN6
 CCQlZXvq
 mks1ksKEVjdbhulQXNbmX/dtGdiwNxjuX6/vuNOi1lHRva7xp7t6EC/gS2cKNmP2AjAFJ2kHQ+Et7CHtTyQ7uCIkxhhtue2oEdVyodjBFNNXNSp38rDqVKeobohch+L5toEQQ1rhmpNHu1AiAZw6y3VH4/mb/1oBxw78/PFGucXKmu5x2ADabK8UxgHRg4IT9zZez4MzsQxeVvpp/DU3FL8y0Wi/8rTRtIrT1qbzQ2vWHzlVyG2ymXVqcHB2lK+vcl8DSraZglxHY7jAKs/BhFOleOf0GW00r9NTp98Bi9eTN6JaqZ9izELzj18U4p2yGAnEjoyvC/gEVOwLyFgxNEgm6t5efj8VTGBx/0jLc2bapenwgzL2YEKZuu73/t1j6XnTeQ5X2Go1Ve2SxC5aqGKsJruLl2sJG+VCilyh7CwGo22nfymlbfdS57jQpYNIdnoHubmlGWRGvVyhTzc/lUhKxCMhvbMV670oUbwWYt1qyGTLzRAJNTqrjL7ixNd8c8I6yE+yj1gQK9LhW+CtMgPYgYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--6lc2v3gcqh4z4ltd
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
MIME-Version: 1.0

Hi Ridong.

On Thu, Dec 11, 2025 at 01:30:19AM +0000, Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> From: Chen Ridong <chenridong@huawei.com>
>=20
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
>=20
> Remove this helper and get its usage via mem_cgroup_protection for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
>=20
> No functional changes intended.
>=20
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Why does mem_cgroup_calculate_protection "calculate" usage for its
callers? Couldn't you just the change source in
apply_proportional_protection()?

Thanks,
Michal

> @@ -2485,7 +2485,6 @@ static unsigned long apply_proportional_protection(=
struct mem_cgroup *memcg,
>  		 * again by how much of the total memory used is under
>  		 * hard protection.
>  		 */
> -		unsigned long cgroup_size =3D mem_cgroup_size(memcg);
+		unsigned long cgroup_size =3D page_counter_read(memcg);

>  		unsigned long protection;
> =20
>  		/* memory.low scaling, make sure we retry before OOM */
> @@ -2497,9 +2496,9 @@ static unsigned long apply_proportional_protection(=
struct mem_cgroup *memcg,
>  		}
> =20
>  		/* Avoid TOCTOU with earlier protection check */
> -		cgroup_size =3D max(cgroup_size, protection);
> +		usage =3D max(usage, protection);
> =20
> -		scan -=3D scan * protection / (cgroup_size + 1);
> +		scan -=3D scan * protection / (usage + 1);
> =20
>  		/*
>  		 * Minimally target SWAP_CLUSTER_MAX pages to keep

--6lc2v3gcqh4z4ltd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaUA3IhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AhHDAEA3ePRl1oqqoJs1d3McZRX
xevo8ebBHTd4DUJSJvbhJhwA/19a+3X/nxewd71A03xJ+bHGn1w01e1sr6huB0U7
URQP
=OXfw
-----END PGP SIGNATURE-----

--6lc2v3gcqh4z4ltd--

