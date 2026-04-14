Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943F6F9D0CD
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F7D6B0088; Tue, 14 Apr 2026 09:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFCC6B008A; Tue, 14 Apr 2026 09:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFD36B0092; Tue, 14 Apr 2026 09:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBFD6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:04:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DE391B7E93
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:04:12 +0000 (UTC)
X-FDA: 84657179544.23.A48E050
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9AF0A140012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:04:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PmzQphmd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776171850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkOkAYK7gq1LO+D5/7TtSm6e4EzH942k3LK3140UMXM=;
	b=Z/A9MzZ/IHsMhdmWTJ4OLv9ap5hPQunT+UVo0m21ThDD1IUwBaK2O9zXDjmpdlCSEQmWOV
	ArzVWhzvK8ox/YwX/yyVal/69Br6KLPzD4ZhZ+goTk+ZOR7MWfl1VBXpqs5JYjx9Rb4AFD
	52VRK5HqhokiM27hpq3rDWNlIZ4yosw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776171850; a=rsa-sha256;
	cv=pass;
	b=Azcge6emjb+Z/j80RmlpmgnktDh9IRQ809LIWNnn8MmQfKjn+mJj9EnteF38t7kZY33CvN
	sb+NfhmREXVev3KCwC5A/LHKCq0c92APl3m4NH3ywA0zvHWFidUiJw2/xmRhhtFr1etE4n
	g/m/4Pdgvvnb0Z/myk5S0X9PMu3VJ1Y=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PmzQphmd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso7450492a12.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:04:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776171848; cv=none;
        d=google.com; s=arc-20240605;
        b=XRRDi68rxP5l2MAhUcwtS0gUeYqsq75MS2Qbko4P1M4x1OeHgOKPe3CnqGPJBdzWu8
         8Jcd8T/hS/NiXGnXKlvBnkaA6mkFDCJM9mesRKWQFwzUp/kaJ7PD9au51+fIG4Jxcfwu
         A6iR3vp/x28/ntuTcdOllvB03VXXv2/pV/c8kTxYqEet83zpRc1EBl3AH86vKhjlMdyz
         T7psAa7walS74BfdXWpGSMZ1nkXgjnLUKWDaRjWmYAIxt9p8YhsuruxZhycx1SVTHTj2
         jggTGYVkGb/8wJ24kd99aKIo9UQ6OYr6y1iyo2WJdfWJXu6zBsIhwpGLR7rGKAnNdf08
         G6XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zkOkAYK7gq1LO+D5/7TtSm6e4EzH942k3LK3140UMXM=;
        fh=bB9Kuv6iMt/TahQosX7jEhoAa3OBctgRaiHSGobx01o=;
        b=BCF4WLvs4GI9vmh2DESxfnjIs4lBNd606mEjC1R5PNDOjyr0mo7meL9OtwYFtKIsgV
         RaA42cbqViaopUDc3N5cKireWI8k/YjJHbIEP8wmgfVCTs+Rx7fuPAWm9bG3iJjuDo8i
         6kbxOwSyBi3XDlJa/9x/ci/gChkynRSZMaQx+KnnFXVQnRFmWUL+jfEyLjgpg8QyQpqV
         8wv9RbX5iLqTo9sUmxcvPXhsaCUSwglcuU+kpyv9fjW3Yb0T1rHQ/ONHNwdkJgcdRdmH
         irBXSDWR1Yn7BZoEBTSEJpGjsrhbh9Q/iUPd8eTY3iL9YmC58ukKjfHcoFI3YUZS4o7K
         ofuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776171848; x=1776776648; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zkOkAYK7gq1LO+D5/7TtSm6e4EzH942k3LK3140UMXM=;
        b=PmzQphmdP9qg+dOCbVJcMLiXwWHN5eW2NnkOIjPyI+WzydpAs7vCBnzvB3499lw/FN
         WfsU0pVwUJb9T+ilyTx2ocyeHBz4GMG+A3DD+zpXaZw/HXjxcTTwAfpJQf2Zgf5vl2Xi
         Bhmt7rBub0ik3K0FJ7WgRZGXRgVhZf4qIU5JbMj6Jm6rsSRYR6aOPF+IFpUwaoEfc8RI
         z2w8zmqZqWocAAPLc2SEq9VvTX9OhmdahL6oZ8kqfWD+nCZ36qgOcm8KtYCOg17JyYRI
         cyXXyozsuEvgbh7HFMGEFbOtAiQPO+RcRnkASNoc7RPPqTXtU6M9yP7PnS1gWwd6OJHD
         gRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776171848; x=1776776648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zkOkAYK7gq1LO+D5/7TtSm6e4EzH942k3LK3140UMXM=;
        b=O3LQd9QoCdgJteuNUEDZ/vTe8HZtKh0rGIZ1qTcoMt0JqystpJ/x35IJWl2he8G4S0
         DEeRxda2nIzWq/ns9druzZlMRH0f+racnDlF4lxi2asvQEAEtWvD7JtGeaKYlBibIfRO
         Ub+1L4c9M0wmymy5syEaaiBXiH/rt/A1kiH/b+hLVVSTezixDgUorRLtjPsj5sjoFttd
         4cIGdRTZ4ADcG736KB+CcvAzYQWTOhWS2gDiwwoMZn8yFPuuYjhUt+QKoUtugeTTb0TW
         xn7giC/o+obsm6i4UcD1AXGEx9zkT9L/E8bdDgLj26JU/x8M52XFco27cPxl4SPfytn4
         NKhA==
X-Forwarded-Encrypted: i=1; AFNElJ/uCM4wIJ+ocugfHUTsR2LxIJ3siEISy4zt+xb3ACAvVwFYN0lbA3ntcQ9M6lZtwg9MoN0EcEaJew==@kvack.org
X-Gm-Message-State: AOJu0YzI3JburmCetJx4iC7B3ywPFiXvU02eiZeH2SqPi+Hd6eFrDkQd
	PerRFXAXlTmF8AG3Ok6q7rh23iipDq842xx/aEM8Mg6Xc3uOGb05AZ9yWJAMBtNkV5bYCdynkXp
	L595LHiULPBe1JTYL+f6bO1JACPi3MNrImYGj8KHf+w==
X-Gm-Gg: AeBDieu0aRcYsKdJLQYBt9QiU7eAYoXuJi6cd6+TzhRZYCkH7Zg9usjo7D8u/fl0Hlu
	bAk7MSLGU0t/2+ZqO5F44omCnpxRePPQKh5wMpAh1QziTuCWzbM6rbkMysYDXJzJCuqfb3jijZD
	A74ti3E20F/KZPYkdf/nUB0XFz3IQ96KyRqqZ8rxJImPBHqBX+optTWvUxFP344JjA6M6/i7I30
	Dp2jp1IUnJ7wKNarX2zx0lSoBijepgSg1bfmMs5GPhkdOfToAzdnCkvDLvMnCsEMOeEMg0lAHL/
	aGPvCQgdnR7wT43H4N6/qZBA/1WjXeYK6HqgmQ==
X-Received: by 2002:a05:6402:2c1:b0:670:8b38:5717 with SMTP id
 4fb4d7f45d1cf-6708b3857c7mr4839756a12.24.1776171846855; Tue, 14 Apr 2026
 06:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260414121752.1912847-1-pratyush@kernel.org> <20260414121752.1912847-2-pratyush@kernel.org>
In-Reply-To: <20260414121752.1912847-2-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 14 Apr 2026 09:03:29 -0400
X-Gm-Features: AQROBzB2bM2at0OaKzNEBGSOyKgK53SL0x6pBDEFAv3Or8zLZ3D54mcFt45gF8Y
Message-ID: <CA+CK2bDtA7fQp1mnQ5utnqFH_V5uKcjBiSXS46kwpr=byFxMBw@mail.gmail.com>
Subject: Re: [PATCH 1/3] MAINTAINERS: update KHO and LIVE UPDATE maintainers
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9AF0A140012
X-Stat-Signature: 6jnpx9qbfdj1ochxz6ibhcuiaqrxky3m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776171849-237440
X-HE-Meta: U2FsdGVkX1+23hWf7xHF9BN4z41YUpHNBX3pA1X/0iJgUog/SQZmY8LRsnn8aaoozfeE5xdruitXtViVD4+3BBXO2M/PLUdmvT2TeUljOniplL09KchOXo8d4mjUpSpjgZCPXWApa0iMkEkxOySEmwOboht8ZD/i5Z4xRedZLWBMuOUDlD5LdzrQkMnKef2uEgpoQPJqkmuYmma+Yn/TZLFp4j7jb0jmUpzvsMxOzUus3b1oJpAKad6/3cOp5oP8adyRGdgcFuJheOiD1momtFOetS8jyZH6xHYxAsNdkZPPcpMIPt8WqQOdE0oeNKrMEy49zdeikHmgSheKnC+cpXx8cpXs8996JulG1OSFw1+oUth2PLnCpFqeg4YJ15Pzhg6t57fCqWYS73knc4WACDOAogKeQhSAhEg+Yt5l9zIhRgyzMSntOIW0uhyUYhrnfYTKTh9QmexlErahwh39FfoFWkWNByhoqcb5pUirwiUajs+8Zca2eWw1H1bsLdfgaiYCwZGx5sPiHSY3g5SYfFApyeRi+CQ5psS0PY7CGka/S61HvX8uYaasoZ8FF10NEquN/U4r2+NYK2/z5T6+quszBOZ3hGzqSREJhuyaXSlkZhtToMMspUIm/oh86XYETnJAX2U6FflYsCw/nT62v5EndtWkJuLvymZyBL0eC+ikCnxtfJ0QsD7u3bz2bKSAeI3njwXyvEydilTHQ2N7F6caK5ZNs2X3vd68uGwpNAoytLWSqafXbj/T8sD1fbJud8cTKqbkbUWa0AmQ/h/Q7ss6jMXBow4hgZlnqKZC60zGtAM0IOGQa3AiQRJSHaoqNhIFBoIoIx9oEa9kWoZIEngJG4VhCgtRwlm1xSLrZFgHwffnuceOnWwAVtG8kaTKI6++iaCO784he36mhimf1S+YndHaT7941bGlH0ZCt46XO2OfRo0JMRSMQ7ZesGiVSlWC8keb97XVZQ27qQn
 1OP1vUS8
 pcB864Tc1kTKd6KC7L+lsbad0Bx9afImEeM13aAE4aLf5j1fEZ+pv/4dkoCnUzvMDc9GRdhzZ8dJG3Z+uKUZSG8hKKqUxl3evDQDpoRpRRb0dzi8nhxQXrsWMfS5+iH8Dbwl6raS3S41iYGoxjl5fDjHC2kqafPk97oCMIAPIxKqKTDiYjzwpMT/TfW7HiUg1wfVrJgXb85m8ywjVcA7JURT2b+DU6qDoumcpJO7v/B1eygOyWRfxJRmrlaPNvPc7ijD0LJg0eNJYcqutelVmsxypSI2d8H2jsMnr7xLfaT/YqiTpUTTgOUoD0nY4GbJNzf0p0C0tN3Ot8K30hM4Df3g+xkivWHA5JAQCTS1GHdxHrt2K/qca7EvIX4mNplJiKl+Qzlke1F/4bf2KYjrLh2iK/7hi9F5Z+8H8zlyviASS4Hj3M263gA+GOUsXmOq8hfi1uwF4qH0lSZ2vconZSqIUntWdSkWdafnzVTObtK0K9Hbgx2PZXJUtc798R62+yrLctKAediv4DZVWjQpAJ77njOCXtUpBdV39vlw+L84oeM3iryOxbamx+HG31h84uCvW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 8:18=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> I have been helping out with reviewing and developing KHO. I would also
> like to help maintain it. Change my entry from R to M for KHO and live
> update. Alex has been inactive for a while, so to avoid over-crowding
> the KHO entry and to keep the information up-to-date, move his entry
> from M to R.
>
> We also now have a tree for KHO and live update at liveupdate/linux.git
> where we plan to start maintaining those subsystems and start queuing
> the patches. List that in the entries as well.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  CREDITS     | 4 ++++
>  MAINTAINERS | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/CREDITS b/CREDITS
> index 9091bac3d2da..9173508b4e03 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1456,6 +1456,10 @@ N: Andy Gospodarek
>  E: andy@greyhouse.net
>  D: Maintenance and contributions to the network interface bonding driver=
.
>
> +N: Alexander Graf
> +E: graf@amazon.com
> +D: Kexec Handover (KHO)
> +
>  N: Wolfgang Grandegger
>  E: wg@grandegger.com
>  D: Controller Area Network (device drivers)
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 915f074c3577..97820188a600 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14109,13 +14109,14 @@ F:    include/uapi/linux/kexec.h
>  F:     kernel/kexec*
>
>  KEXEC HANDOVER (KHO)
> -M:     Alexander Graf <graf@amazon.com>
>  M:     Mike Rapoport <rppt@kernel.org>
>  M:     Pasha Tatashin <pasha.tatashin@soleen.com>
> -R:     Pratyush Yadav <pratyush@kernel.org>
> +M:     Pratyush Yadav <pratyush@kernel.org>
> +R:     Alexander Graf <graf@amazon.com>
>  L:     kexec@lists.infradead.org
>  L:     linux-mm@kvack.org
>  S:     Maintained
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linu=
x.git
>  F:     Documentation/admin-guide/mm/kho.rst
>  F:     Documentation/core-api/kho/*
>  F:     include/linux/kexec_handover.h
> @@ -14802,9 +14803,10 @@ F:     tools/testing/selftests/livepatch/
>  LIVE UPDATE
>  M:     Pasha Tatashin <pasha.tatashin@soleen.com>
>  M:     Mike Rapoport <rppt@kernel.org>
> -R:     Pratyush Yadav <pratyush@kernel.org>
> +M:     Pratyush Yadav <pratyush@kernel.org>
>  L:     linux-kernel@vger.kernel.org
>  S:     Maintained
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linu=
x.git
>  F:     Documentation/core-api/liveupdate.rst
>  F:     Documentation/mm/memfd_preservation.rst
>  F:     Documentation/userspace-api/liveupdate.rst
> --
> 2.54.0.rc0.605.g598a273b03-goog

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

