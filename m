Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB84CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEC76B0005; Fri, 15 May 2026 18:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48CE6B008A; Fri, 15 May 2026 18:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FC76B008C; Fri, 15 May 2026 18:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5026B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:38:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 498921C09DE
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:38:00 +0000 (UTC)
X-FDA: 84771118320.27.8CCC939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 50B4014000E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:37:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6SQPUHb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778884678; a=rsa-sha256;
	cv=none;
	b=w+GJwibGCK3HTuh5DraRrPlPHQYK9wEvS3bioQR0IuPXg73RAqw3wy67fNoCY25JO/ozrN
	m9Z3VWZjaE3zwTZOI4tHTS3ff4qS/jfG1H0xL8RR35Jy7/1I8iUNh2rgrFEp71/jw5/+j8
	KVul/N/2BscNlYfbpklwEqw8AKx4KS0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6SQPUHb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778884678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2jCAN1uGGBFod+dAEVc9V87Hx8HKAYcRyCM/+scJWs=;
	b=vLJkrlzcInGTKnl9ZoFvbqej0BxDk8+VaEJk5WlMqMHq7RuOH3CmoC2WEnJWDC7R9xRVEC
	PiNca0g9uAA0thg7jKkGPWxJmjEGb3v39zbSBFUR90A2oPrJsLZEMWpYdbBuWC2ZyVq3CU
	k3VSWzOZi1+TRvU6NWjF8GZgfCc99TU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35FD7445C6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140A1C2BCF7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778884677;
	bh=J22XAuCby1Nk4FIP13WT2u/GUxKM6wuoH7hrzV1Eqf0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J6SQPUHbeQl+M/9tFaMbK8dZygMG4wF3FeDwXrfnAGoeuZ9v43RFXPi3i6PlUEyiY
	 qBY2PB9tpcgkHiNjKM3nu+tcCujL6QueIqUkX9tN/dTiWw6og/+ClebItMZvq3cMkT
	 vgZnaxUDZ5ZpKpPGSQXREQbo72kuouuzw8BV7etUgGve0Sj0gy7Gf3dVbWhB4ui+SJ
	 8aVZ/MPSUGgiJiIlGr/mzCEQp6NXdNvts0FxgtV7VTfgZICdUvENCJTtEbhFIHPwLu
	 wKsygrKzRHlvxrF3qEqfDaUVvViuaPg4sRY8c8vqUrBVwcjH1EGTh3YzoMz3G9HpWQ
	 RKL1x7I9KsoDw==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c1ba7eeb6so670279d50.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:37:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9sYA4MqoIyt8zeimkcd+hGhtQqbWWAZOb9nE+3dCUGPZHnhpBJEnhzCxv3sMwSO46zUZxjBjDr8Q==@kvack.org
X-Gm-Message-State: AOJu0YxRx9k5WYEMpgvsM3Bck4ArOpHy005pm/Kb6WkgFyoldKUJ2Ozc
	EIWFbZeW0QfZmakM+8fNRlx7VsFGzX0eJazUfHAQ2UpDbPD7bMDizeVBWO7Zf/ObbjsVvvUNr0V
	e2wxw3+r+tWNz9FCIU1Q58/MyPxLnxhfvwuyWIYNfzQ==
X-Received: by 2002:a05:690e:1482:b0:651:b13e:f9ef with SMTP id
 956f58d0204a3-65e226d2c42mr6465616d50.14.1778884676176; Fri, 15 May 2026
 15:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-2-hch@lst.de>
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:37:44 -0700
X-Gmail-Original-Message-ID: <CACePvbWdxJfCgZzbfFoSOFLKnizDJE62oHKj=mA5jkBGo0dHkw@mail.gmail.com>
X-Gm-Features: AVHnY4KhYBpZIvUDwx68vRewVOsNKOXtAJOmYrhmxnQGCpjvviSHXcfEap0R7tY
Message-ID: <CACePvbWdxJfCgZzbfFoSOFLKnizDJE62oHKj=mA5jkBGo0dHkw@mail.gmail.com>
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j3sayyoyz5ys5itkguwj4c1ypismjykz
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B4014000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778884678-356174
X-HE-Meta: U2FsdGVkX18BFnQH7+m5kqpLDiWI43GjYMy9/FiQslQoOk7pIj3FwpgjJ918lsoFlo82N13T5l6XgkylcR0ubQecu69jO7i2uQqj/rxyeUS7BQ3h0u8EUJjOjm36xyCBPPO6TMkkEsL3+xddFc3dpAKnH2/9aIkBJLXOo7ZvJdoyXttczn9q6U2iBb9QCwXRu5szGSOAdVRcOPhdzeba+7VslFivnmgSucOTLHXVfMAmU+FAJ1KKqJh6uqzRTU4M/acJvNXjB1TE5uTwwBiRR7AGh3eGos1luzHa/rrYX4tegmY3WHltOPWAZ4QHrXmALO55kQRwPXqWxxx6sk51zguRNHjT78JIGqfHnhDHuj9yYlXQUjcPKxiUyIvSYBjEDBRhYyPlroHjGo449fxSYRT4YzMIN6aeBXrWgsT81kOjhv617x8m768dy50nOpZ3Rdtfz26UZM08yJOkUeOjDikN/eNHW6par+YmaaNjk40iqtC3qZ1+RVzuJZcCxeE7z0y+P2NLEYU9B81HPoMpskdlfZZAuH4Kt2pXMqGkclcMWapvo/Q7vtbMLQ4xmW3+uF7XvnBH9qUyfY0CPMt5a6wKOKMWfvqWnBNc0LI6OJZ+ibTIqZfXjkAB8uIyS7q2iS3vuHrE8+MY4np1J1j7+LOW4KYeNJR7su9tlKE1Lhtutx/Oqi7H1iANH1PI6RPH40zWhRXKf1x1uVnGjdNWMZvwjK3TBxe/bFbfRSX0etsUYXMRYpsODmpruoHuoaJAU3EiXusuu0Il9WQ4Fbh8PA5SOUv3tDo8SUtrtTvc4TEJCk7pZVIILRj7O5wS8AE6PCQJnuqnSoquFF5g9fhXK7GNut+L5BJRvs5hb4MDLkmWkyJ67jQHEsCGJlvpOpRB903NXcInqG8t9Sk/unJ0DMfobaunNRmFrZbwDYY5+XLUlCONSkkPpk46BNNCu6yOcYNToF6Lif4voKrkYQW
 coBUZN6h
 IRWS+5gBAR2rVE2WVKvww+4vWLgiUkHyIKi5rtmVqI/LbvVTgaCNEweEs38JZIpapIMWPYNSiz8HnvSienHruf90I5HGri2X2q4+zdLBydtKAsIiNSQcaoZolLFDpTNKYDPaQ/7ckVQtfSWJLG28uLx7V2mKSzRk0N0UVeAOj6KYqX776spqfRDNKr6A5vKWXPSIW+hlSwqCUlkNfSZsPO73/r6ZKbTB+KKTQdD3vnyz24Gge5swemhAspkkWxedCUKF3Y/mhxePkOFqb6wtwLvcit5j0VFXCGGqXtW1rOCTSBbUX+zk4lAdT1fcVyzMHqjq3zawGwncsJBcTm3k6bjnFLPvoTkbXEbTSofDysBm1Nr7iYsk4jjkF6QDlElnyrMWkG1zM3rSiMmuYJldcmpXvhP4QF0qQURzUuGE467fRJko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:36=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Always use si->max which is updated setup_swap_extents instead of copying
> into and out of maxpages.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..f7ebd97e28a3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3350,10 +3350,9 @@ static unsigned long read_swap_header(struct swap_=
info_struct *si,
>  }
>
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
> -                                   union swap_header *swap_header,
> -                                   unsigned long maxpages)
> +                                   union swap_header *swap_header)
>  {
> -       unsigned long nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLU=
STER);
> +       unsigned long nr_clusters =3D DIV_ROUND_UP(si->max, SWAPFILE_CLUS=
TER);
>         struct swap_cluster_info *cluster_info;
>         int err =3D -ENOMEM;
>         unsigned long i;
> @@ -3395,7 +3394,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                 if (err)
>                         goto err;
>         }
> -       for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
> +       for (i =3D si->max; i < round_up(si->max, SWAPFILE_CLUSTER); i++)=
 {
>                 err =3D swap_cluster_setup_bad_slot(si, cluster_info, i, =
true);

Nitpick: I couldn't hlep but notice the si->max does not change
between setup bad slots, so in theory you can cache the si->max value
to a local variable for the loop. In real life, it will make no
difference, so feel free to keep it as is.

Chris

