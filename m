Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB50E6E803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5C66B0005; Tue,  3 Feb 2026 05:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CDF6B0089; Tue,  3 Feb 2026 05:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CF66B0092; Tue,  3 Feb 2026 05:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 159EB6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:54:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C12D81B1CD4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:54:47 +0000 (UTC)
X-FDA: 84402837414.27.F95BBBF
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA47520009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:54:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DAVHg2Ty;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770116085; a=rsa-sha256;
	cv=none;
	b=ZpRRwW4TH9ZiMGtyrjTUqlg7HPJuCzwRShTABti7IgO+juiO7pMcvq1/hgFUW3tQu/mmXu
	tNpGluvq5t3YPcdz540HgkoUOvUmQqhDbLweC1xEIQr8fDTnOfGdre1Tg1L1P22ZhMqZSf
	VAK7dKlZM7FtkOiQp0ZLT8omUtoH6E4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DAVHg2Ty;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770116085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPTAiMYWoGy4HuCPIOvAkAKBt9pkuD1N5ue77Vcr1hk=;
	b=X4i2a775NhW8zd9KFfR+8UWT6+lcafQN4LDxvHiQP0mbxGyevhfnA+zJ2vnwOqmqove/PM
	n5ve2EW5jUwNpC7YdR+Spokp5q7Cab2u4oI7SYuFnjv67MSGneFuMu/+35xTGeaoYW2foz
	TvIqsH3KsF8w4Td/Buwny3MuEg9OmJ0=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4359108fd24so3336966f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 02:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770116084; x=1770720884; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPTAiMYWoGy4HuCPIOvAkAKBt9pkuD1N5ue77Vcr1hk=;
        b=DAVHg2Tyvis0pAXIZKJEzC+Ve1B5E5xGElDCWUnt4GZwCytkQLFTxgHZwy26yOSnP7
         PUqhTejqU9ZkypoSOe/6VJjoxEF8y05nawvPJ8jjtM1Bwy3hEGVG4FFxsbFEoZbc/Eo0
         cVcnq7P6MCOGjgwYHi1mB6toug59B91HnUfeZ71lv6r5JQyzbyCKV4+VwLkcWlhBCXgp
         nJvgiOOhJOkT9o6OGFgZOKIcOHoUPxoW0OAoSd3vzEf3L8RwH9bacW0otOAZOoGYP7Zc
         SBoWfr1++U5oMxsj4293FcaAL8ORFLhFMe+bNI13/ONaIz5ctGiOak2ZYCZnEsBSVM8v
         +jdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770116084; x=1770720884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPTAiMYWoGy4HuCPIOvAkAKBt9pkuD1N5ue77Vcr1hk=;
        b=GOKcImjHsX/y+0dAV3U7uhYa7cgaINiGR4KJlyQpX8bsPqvNq2UX5jwAb7zhAGbb0a
         XpzowXDriP4qS4PBz2ZpIHIFKV3mF1UQ628aN/AztUbLGbisL50yoFr0lTVPk3N1STcg
         MZGGK6AJIUnHO760Xvi7Fbp5hOu1+viaEcXfoHGApJQa8xLcgt5of59UQF36VjWnE7x/
         N5nkheI931iCdQg9mrFbwdDsVqgDhjVetd7SmvX1xVC7d311DxlppqDwFvCI7E3jlzHk
         FtPMYnVv6dgjCd+p014ImxwZedJwFIn69VvRIi2Y4HbwitWudHANj7ZSYjxi0DwwM+4N
         hD4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXlexv4in4RDRObekVh58V/DhSRYHpA9+GWFK9y64DJ2Cf2ABmq3BS+fkm820/C9128mke14w7ZvQ==@kvack.org
X-Gm-Message-State: AOJu0YxiVQKExFWoGvNNXbpIPF4Nr+ltF/ZkB5pCdcwLqGy/GQ/tEA8W
	6VM9XjxCOHFXs8GCckRqyj07J/GQRr3sf5MajEcQnMjuc+9sZqwRwrJIFLGFEvWABxQ=
X-Gm-Gg: AZuq6aJdDKoj4SaNdENVTMHRIhQXfbnzddf5kD8gKI94jwbduV2VKtRkBUXpmfOWSgv
	mcO/50X9onGoK6Ia9kq52D6gqVEBxJg1mweDcmPoqyITbetca+AuunjErcr131fffmLja8bam6b
	C/jwQDIKV5UkmNQcj6qs7nT5QvkcxwlxY834eyTcl1JQT0S+HyABq7i2Vvq2n0+5BCTja/bUevX
	SPbKvZmGcwRFJQ05xTu0bdMhvlE0dBmT2CFvyWEi2Noy5N3mwqW0lpKYTDPtZyRESzpkrRw2jIn
	0XuIxfudutLPbPvEqaE2mRoCVobr/OuRTR2JR0ODt1ddDiGfbZsXY/0ikhbf6nDpZJQ/YTCRwh4
	aMplKxtWNtc5GlgY1rD3Sh0HEwV+GBBWfpViDgCGsfVoEbKMRgsMEnm6loOSWXua5LHrCrJ4Nb/
	Cl1cKQTUdAn1b0BePSv+n/MB5U3uXpQw4=
X-Received: by 2002:a05:6000:26ca:b0:435:e3c6:554d with SMTP id ffacd0b85a97d-435f3abb4e6mr23160424f8f.52.1770116083908;
        Tue, 03 Feb 2026 02:54:43 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e132303fsm51485014f8f.36.2026.02.03.02.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 02:54:43 -0800 (PST)
Date: Tue, 3 Feb 2026 11:54:41 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com
Subject: Re: [RFC PATCH v3 3/5] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ixlef27mi6vm5pek775kyddai7rkzls6mjo434rvwwp5gulcp5@n3uzy35ta7me>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
 <20260131125454.3187546-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u2lpn6qjy63iilmq"
Content-Disposition: inline
In-Reply-To: <20260131125454.3187546-4-youngjun.park@lge.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AA47520009
X-Stat-Signature: u9h49zui6e4awuc9su3ixwzge4o3q15y
X-HE-Tag: 1770116085-871169
X-HE-Meta: U2FsdGVkX1+3n7fwLpvVaVvIX+X/Lq7O2c6mOKrPkb1kSIhn8Ev+BECPJNFk7x0FXbp06mtKhLv1L6cm9p7mYpf6YBU/4L1DiscgUa9GLLrKpEDUe+YIkxz2DR9O924xN4JmyGL5lMVNOSRinV2wwrVsS5ep6X9euICjTdVLsxOOFJwj9MBAR1eyZVymw6bbHtNNfmM9qoSbdQAs58yiQt+PU3B73t8oQKhbUXo5IAOcdJvOrWMMfBWBMpsPJqB6H9cNgcHt40j1omUhErPgr0pDMI8YSfaWYtUsBQ8sNcPZtgqNaTiUA/3slo52LHbFq6y1OsFMeMMVU7IpbMvIifSN7i34rsUqJ3vH5MPJMpzaUTLR3+61ScuBv8uiwkF7XOqxyfOG8FWb6d1oi+DYuQ/Mnux2ZOs6mpO4MFEkUo6uZHWjR/pOeVvFSdv4sA43kyLz5ewqfGsi6+t4rnZWJcEqMYF2rfBxj5vJbNqUzWe737Jx3hUBMgpaQtWKdV+igxdeYsLsQAKW56HslAMUyyM11KFo8hPrR8F+5oZo+IlrVvOdPkMYmNug3KNst0+CgIyl2UGVdyulp/WitMK5Uz7DONOpogbuRd7BKRZrqDtjeG8EQeqscPuD1W2DAvM0bjiLVD0VNd7VS4A5tCWY82LjAVtHlfsZk+XW8snXZRVTGEay24iibdYu8PNV9skzYKWv+llqOiwhjQ23WYV/grqSv01RrrJd/v0FbPprRJhNfyxLXNogjDIS5nw4ZNL6CseH+O+DdB960CcWQa66N9bQjJ1NgPgzOr+Xs8EdLi4Md4HiPL46AfLDnMWxkXihlAV8P0rvQievmcFzWuwcGEcRWW9RkQwApwYrDjosVfUltby1q7GGlTNIIHMAWoU2Icf95pKykAI1m0N6l3g0mZXVhLJhtOvJBcIriR4w7FLizm2N+3Od8X8Cl6UeduxbpEMrzse8RXRxqLgJV/5
 LXtJdLG1
 GUSeuPKHSzloGRFaQALciom67haubAeSBcoB1AJlV72wffAMEzWUuCm3iFABBC6F/8R4Me2lFy1mYG4UYmuTb7qh/0vzz8+H5knXYO/Ic0OFVlHgvCN+kACDbBvuIZQW9GCAqjo0ed26P9ZNrscH996wmr4sbw1XAPHaZbvYCZZso+akHafKpo+oB1MPJIbrb8nGbeEUZO6bdXyLme8iuklNow+8XupEZr+xYlvUK1JBMw/VO9eniqcelgGojWZBS0YWEPDGbNVeJt9dFRNOc5oSXWKIctqsZJT9CdtjhNaLARwAd/mfFPDOxYuuAGLl9LXOOBjuLFjSjBTjqJuHMaSlq/Q1+y/PLKz13I3qC/57nJeEwW2XVo1dv5VPgXfe8bVR+hGAn/E9CP9ese8TfCm5be9HHH8nwEDO454oTU2UMhibBCF4yt+9bcJ2ljbFXgaD6rUNnRC2yGfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--u2lpn6qjy63iilmq
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v3 3/5] mm: memcontrol: add interface for swap tier
 selection
MIME-Version: 1.0

Hi.

This is merely the API feedback.

(Feedback to the propsed form, I'm not sure whether/how this should
interact with memory.swap.max (formally cf io.weight).)

On Sat, Jan 31, 2026 at 09:54:52PM +0900, Youngjun Park <youngjun.park@lge.=
com> wrote:
> This patch integrates the swap tier infrastructure with cgroup,
> enabling the selection of specific swap devices per cgroup by
> configuring allowed swap tiers.
>=20
> The new `memory.swap.tiers` interface controls allowed swap tiers via a m=
ask.
> By default, the mask is set to include all tiers, allowing specific tiers=
 to
> be excluded or restored. Note that effective tiers are calculated separat=
ely
> using a dedicated mask to respect the cgroup hierarchy. Consequently,
> configured tiers may differ from effective ones, as they must be a subset
> of the parent's.
>=20
> Note that cgroups do not pin swap tiers. This is similar to the
> `cpuset` controller, which does not prevent CPU hotplug. This
> approach ensures flexibility by allowing tier configuration changes
> regardless of cgroup usage.
>=20
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 27 ++++++++
>  include/linux/memcontrol.h              |  3 +-
>  mm/memcontrol.c                         | 85 +++++++++++++++++++++++
>  mm/swap_state.c                         |  6 +-
>  mm/swap_tier.c                          | 89 ++++++++++++++++++++++++-
>  mm/swap_tier.h                          | 39 ++++++++++-
>  mm/swapfile.c                           |  4 ++
>  7 files changed, 246 insertions(+), 7 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 7f5b59d95fce..776a908ce1b9 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1848,6 +1848,33 @@ The following nested keys are defined.
>  	Swap usage hard limit.  If a cgroup's swap usage reaches this
>  	limit, anonymous memory of the cgroup will not be swapped out.
> =20
> +  memory.swap.tiers
> +        A read-write nested-keyed file which exists on non-root

"nested-keyed" format is something else in this document's lingo, see
e.g. io.stat.

I think you wanted to make this resemble cgroup.subtree_control (which
is fine).

> +        cgroups. The default is to enable all tiers.
> +
> +        This interface allows selecting which swap tiers a cgroup can
> +        use for swapping out memory.
> +
> +        The effective tiers are inherited from the parent. Only tiers
> +        effective in the parent can be effective in the child. However,
> +        the child can explicitly disable tiers allowed by the parent.
> +
> +        When read, the file shows two lines:
> +          - The first line shows the operation string that was
> +            written to this file.
> +          - The second line shows the effective operation after
> +            merging with parent settings.

The convention (in cpuset) is to split it in two files like
memory.swap.tiers and memory.swap.tiers.effective.

> +
> +        When writing, the format is:
> +          (+/-)(TIER_NAME) (+/-)(TIER_NAME) ...
> +
> +        Valid tier names are those configured in
> +        /sys/kernel/mm/swap/tiers.
> +
> +        Each tier can be prefixed with:
> +          +    Enable this tier
> +          -    Disable this tier
> +

I believe these are only superficial adjustments not affecting the
implementation.

Thanks,
Michal

--u2lpn6qjy63iilmq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaYHT7RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiOUgEArOxA7KvQUyKrjkyrhpBw
jndtkluc5AzqznoK265PLMcBAPJIbhRuoYV4anAZsx5HC88458Xzsij7tu2+xXO5
sf4L
=PfDt
-----END PGP SIGNATURE-----

--u2lpn6qjy63iilmq--

