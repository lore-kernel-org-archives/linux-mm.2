Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBAAFDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 22:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558ED6B0088; Thu, 23 Apr 2026 18:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A486B008A; Thu, 23 Apr 2026 18:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8C86B008C; Thu, 23 Apr 2026 18:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 325026B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:11:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6AB740595
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:11:27 +0000 (UTC)
X-FDA: 84691217814.06.870561A
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9981D180007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:11:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aQtMf6J+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776982285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LE8KttVtGM+9CpiUlwllHY6AYyzUrNOnEbtRD51iDc=;
	b=gGESq31hpxBHq81bh9KIsrS3opXhjL3Av9znglDpskAUa+KUbyUWnZzrwnG2VpfzwZewO+
	aOTfMkwhUnrA5T+UQVYUCqJtGVqyAxzbWtQrh1SyqAUeC+qyhEhkbOzv9p4v8bJz9ispsv
	PJP5IslpcvNDjaWhobcXvnP3E6rXsHs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776982285; a=rsa-sha256;
	cv=pass;
	b=beExh0yystK4gjFsJm2FGfI/wJXNy3iKXpn39KqVd3EfzSddSUjNWFTuOWmkzZDYwQLGlE
	TFes4s7EZQkdM4LXE+8S16vAIK7fJqhl8uQk/tFK21PYsnlef5XAnbXqdhFL8w6yYsbfHG
	6TPD6Goa0XxT0ZrQKe9iI89h32CvoZg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aQtMf6J+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38e7d983f79so55518621fa.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:11:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776982284; cv=none;
        d=google.com; s=arc-20240605;
        b=NFIM9gf0cIybge50yfkNH98UacDi2M5DugR+YaJNm1VKYQNsB08ni5z3pry6CcGlVt
         iNOl+UpsdOBES2beYV1zso/iuzA46kxEMhXJ1InKCntiXmjPY6HPpf5+gP2n3jCsq6Ll
         s2ANzrcmnvswhpKNJniUfDRpkJ7P1eMooDDIPV+sHNYY143QHbgucPeVzJwc7//cptyR
         vdmTkk98ffBdD/v/kads9HuVG6MsqynqF6rLqX/1lxCvLqZ33cwrlGb146+qdQMrSr6h
         SzPLiRWG01vPn+r04CJJhRVoW2ys2yUCB/X8i+pqPFjGRYL44+e7oldEg0wQg6m52aRJ
         vzaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1LE8KttVtGM+9CpiUlwllHY6AYyzUrNOnEbtRD51iDc=;
        fh=xQts4mIMIBvf+AMSd0THbNwxNX5SYDzkxHA+vw4GIRY=;
        b=bILozSaglXCX5WJk7cCUovzGJ35EGsk08UOQngUcDJWl016D+FbOJz7mlx83eRQc7e
         8zTsf6QTrcY2g4h9RobQH1sgK2wKHmkoWKye59cYVKZGJI3BsmCkOsPw2plE0uHaYYRi
         aE6q5MhVbx7Hu+fQWUzOvDPXsC1YemhFK79ilN6UJbZiB8tk2Xi/q7pVdkxedrodUC3j
         0pdVIgpcLxs0a/nyzvw4LuvuX/nl3DQmwxy8zk8bPQm2TZMVwDOHSez1hKMZ4e7hfKYJ
         6jntQKi2dbK+A2hw1B0Nhi1+ewm31UhU/pPTKfQm6tIfWIqbzonFmKtgVEQPwxsCOC41
         HOXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776982284; x=1777587084; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1LE8KttVtGM+9CpiUlwllHY6AYyzUrNOnEbtRD51iDc=;
        b=aQtMf6J+c4ReZ5q9gvB9DJbfbgmklfM9JjN4mbVOwhSi34G4aszdYanw2fJpvJsCmp
         ymob5tryMvRJQNINtEih0+sSwU23oXnqAtuo/jots91YDP4ygQxabVovWh4Uj2RLK0AX
         LU0NgzOIXxoREdiB1XqLqDcR+hqqmrKpYJiE3CinpMavj6qGosxtlXs+DpsgSVdlWiaq
         avRKr7eRxPL2U45fZRdr5Ejlb9Hqo4LLxPayDo66lh7MI9xyWoppz7IfF5KD1t8wuash
         0zqYEuNjLG2gQsy+WRsTldU2ht7UuGiHEeNwtj+BLetqkkgKIaOkRk1l72e9d9ZLR2kO
         RUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776982284; x=1777587084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1LE8KttVtGM+9CpiUlwllHY6AYyzUrNOnEbtRD51iDc=;
        b=lJxtgeakwZuKWlPbGs+Q1ZR5dF+xTrk8BxbAgugsTLWOn+YCf5TILHt75yp8oFLeAD
         +tN2/8G38omJ6LKt7YE9XoviJa8iBk6YzR/lCDjykcikmpBlSZQHKmxzCVHiqk/WEwxh
         GWX4bel71pnvubiGuxs3mtlfdMxXnUJUMjaeG/VcUla0tHkwFlG3+EKGq8A7zUAK6aSh
         dEpbVYvUxsrgHlQzXDcOhOe82f8Xcfp2zSZhVpzOCzA9nenaL6JEKG1aw5BRHDNGntkL
         CVF9JGIvtbx3Twx084caGwDSoRZDEKzKEPylYFsoUecxFt0RK1YdfSu+Ce0G91bMeovg
         ilfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8eJBQJKbzOElAWVJCx39+0aWlMFHWcD5wHOlh9PNmBRgGbJq+Be999qB3o2ydFScT29y5jF9fEmg==@kvack.org
X-Gm-Message-State: AOJu0Yx1FMPkrZh3qrICk3PPQgpE/yN9CkM51acyLc8mPLmr/Dtj1D51
	MeYMtC9bivAId9RhgP2+tpV1ptF2c6NPOjDhgQU9SS+ZVYjqu6RcVGMCEli+MXJiBoBqvmNNLme
	VDKhmm/VT8j/rIHz3NNDVMcea213VmLm5402AOhtq
X-Gm-Gg: AeBDievIL2KvA+KbOeKYRfviJOY74jq+7e0+xxBl3FeofXGmDD85/arKFl+0LI8CROu
	KlpwrP0kziJSXXHBPQesVHIuB9vcl2SvA2/ss5+0YqzQwTo52CoqlRlEI6JBe3xRbePpuxMnL9U
	hP3c3/+qZ3VL5GoXolaf1DT7AxfP9hgCdPHpSKChXebFARe/Z/SJNSnpu0fI+G57C3E9gOMtm8x
	LcC969vEj51nAB+eOAez3FGlu9x9b0xv+XVJuyD34vaFY6fZ50KUwEdvbFh9aa16RyD4vSgXRN4
	GnzOio5m16euD/MORln3vbTFCVOyVw==
X-Received: by 2002:a2e:bc83:0:b0:38c:6b7:ad39 with SMTP id
 38308e7fff4ca-38ec7818193mr99821181fa.13.1776982283419; Thu, 23 Apr 2026
 15:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-9-dmatlack@google.com>
In-Reply-To: <20260423212316.3431746-9-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 23 Apr 2026 15:10:55 -0700
X-Gm-Features: AQROBzCzQHNRAyujF9tGZltx4kVtGjkMoj2uVw4QUXf8lLhcB6v0kyr5BiRYiDc
Message-ID: <CALzav=dGpHEnEjyp8qc50iZrGeKJ47vjLvwtvkLCyNzOMJhozw@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9981D180007
X-Rspamd-Server: rspam07
X-Stat-Signature: f5qdn3gg8bakke7xujtozy5fkso9yjpd
X-Rspam-User: 
X-HE-Tag: 1776982285-122570
X-HE-Meta: U2FsdGVkX18QVRMQfGNo6hhZ0Ig75QrkXkFWDeB8kLQBYgHwfQAGXkBfKQGktCmiMSLg6z7Ez6TxAyR6Jd7GRSPnAERel+f3qyFep1lIY6a8/og0l96fMWIqkkHKAGlV2cn0LWsgqLUmnQQ3MER3vYeIEQSugkpBQS7pjcm5sRPkhzzyPX5dEULo43JFqdpUwureWLj6FBtwx2j/OCLAymfyRI4mJJB7ZHALAAf0cXKI8PxvZat1apF7ZICZF4qiZH9k6u2y7fSUf16LHdhBKamHMK1IP1naUXPhooLp7VvPcjulgUFndkJXJery0QmGVKTog3h4wNs0mEWz5x96q/iu7c12t1n6aaL8ne37/PFwARllWdTLWSnno+JmpeBdVSmXKob/T/hJLJ1DHZhLzcBvg/Zv5qiAGGcgCAJ28/siKFx3jB6UGPlaD0rmLvCaDxICgiqaTa8ggHvVIqUZpbYqOL7ZDGD2RR/y3nXcRT5v63NTX5VXBC3rZlOKhj3Xevix6rJgjSYhi+cxDXmc/uCi9ohP87POSOuUQfwKz5YoCvf0soA8nQ6FeqOsXtHnwOSwQPpUVfHmWkAxFFNWYmx6FzKemM9ma6AomoagiKRUEYlpNPyU4CD4LR54AHywVuc6lIQT2fNxb1NTLKfd1ddlr66tmAZp0uZiXwmqrNstBCHxRGjO8noaD5jYkNwOyml1CGiUW6vA4bq+dnyWqeNaY7gAQJY00yBlH51qmDTESovbJwH32QVinH3xZ1vRGAjoj5Sgb8kpJXW+CmaYCmGDhJybKmOpX0c6vNpogKKcnFm4Jn9TTQfqapaM/nBIDD12cH0xEeFWO3lEDtuYxFVjOrF+imKAiAT33l306UkHX05HiCdhBL0pqmgpfrWlWM6/KVtrhTvoTSUd+uCVy8klGoM5Mf7NsnsdM1CmWRoX9pIXDH/irB3nviarfcm/wPcOIO5dy4CC0p2+z6N
 fXRBu3Gx
 nglXQ+by8IhLcVtuxgAIKBmOBG9rKOqfLt2Q/VY0Or/cjJ09BiaW4tS8brUlMGXQcaLO/PPQnSCRpGlmCK7QIcz2tnWU7TtiSji86pL9F0vPhdcqTtjiO+n8ipNhzpIDpndHoUq9ncGtj0PyC5mF49MruimwwE4E2XYSX3iTZd8yGHn2Tr5Q8cOWdq3nIOJmNSXIvfR5HicktwhPakYFuxIF4FLJqq0Or887IQWS5vctS2TKpTXos1jsTnaaP1YMJLXsNxM1SzEv8deI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 2:23=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> Restrict support for preserving PCI devices across Live Update to
> devices in immutable singleton IOMMU groups. A device's group is
> considered immutable if all bridges upstream from the device up to the
> root port have the required ACS features enabled.
>
> Since ACS flags are inherited across a Live Update for preserved devices
> and all the way up to the root port, the preserved device should be in a
> singleton IOMMU group after kexec in the new kernel.
>
> This change should still permit all the current use-cases for PCI device
> preservation across Live Update, since it is intended to be used in
> Cloud enviroments which should have the required ACS features enabled
> for virtualization purposes.
>
> If a device is part of a multi-device IOMMU group, preserving it will
> now fail with an error. This restriction may be lifted in the future if
> support for preserving multi-device groups is desired.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Jason, do you think requiring singleton iommu groups is still
necessary/useful now that this series preserves ACS flags on preserved
devices and upstream bridges?

