Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8005606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=N4LTFVx0
Received: by kanga.kvack.org (Postfix)
	id C53826B024E; Wed, 21 Oct 2026 13:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCAF6B0253; Wed, 21 Oct 2026 13:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB3C6B0255; Wed, 21 Oct 2026 13:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799E06B024E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:38:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB9A9805FA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:38:57 +0000 (UTC)
X-FDA: 85347343914.13.AD6D67A
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F33320005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:38:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=N4LTFVx0;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792604335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
	b=GX4nsmkeR9BmRKhMbTqxP7A2kRUm8Nd4tcROQx4heTZ/P3yKmMjj/8kMJWpBtAdju4wppt
	sm06cP/lQgRO2tJVNuAfC6cyVEemYYDWeo0J2P2bL+xfTrZXMWL0nGtOX8N/fWhP8+eaQv
	K31B1BZHyUh7BSgHx+gpoWcD3Bn7e/w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792604335;
	b=qG/HiG5vlXPEGPwa8DUPcnGJ5eK2IyWPCf2O+YcteuB1ErITL2OJwqjFZUvukgrXf/VKBx
	t7a1QwvCBrk9z5N7S5E1IsTbnf2Leu4TNhevyMtmO7gvC9+t8bKprU432t1PrJrWlCyy/F
	p/NmEfJe6HQaXuIArx0/E2slyMBOIsw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=N4LTFVx0;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3ab3dd9681fso9692941fa.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:38:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792604334; cv=none;
        d=google.com; s=arc-20260327;
        b=hPvsGoLGsnpgKnAbWQ8FOMgC6XN7TfzLyl7IV1JC62k8ppZmbxQ71GvCxLlHi9dUJM
         kRoVHjpKT7AIzgTvmj6GKh5VRes7fBbWkANW+DjvWO/pw3vxaOFQoOZLX6UEs8EPgH+O
         SIz+m6YP6qteFKvB45ITC1WKir+vo9vsF34woo577m07GrzBnuOfixy4v5ykPzljpImR
         J6m/9JdXcnnR2TwE7f4AUSG8ri9Aj26HZuu7epjHKCeVU7HC/2U6O/w/FUc/GS7RCNTF
         3GinwwL3a/K9W14Jd0Ri5k3WqXNPzedmnwTZT7sW+xUZqFp5sU2GmYY2PTqKd1X7BzyK
         7+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        fh=bvRp4+rLKslMY7KB/bVvdYyvgnSrKcfCpMfN9vhE3ZE=;
        b=ipFObA4WrskTIXjwInzxSleynJB3Oq0wEX/x0J7V5G7FAXpzY297YgRhG3PXf2Bcas
         1IOpVCXyKqOtcuYylQ+J7JmfJiNJmsdrKGw3BRD8turXyuMwek+OOezNyqElijnIkfrV
         gxrJqXpdUXtFfo4FL+LxT3Jk4Aj5cbbjph+CtKew4RF07VEuu/qB2e/whfJBqjgqnhcw
         wbVJ2rdWqqI5QMdXsOo/Gw5WrXeD3CZaeCp7lnldEpJRzz1xvfi6uq9d4C2exWDaWQ8f
         3j3GEhDnCRv5t/2ds4GVRxdEbLhndqUr1Wtr9f/BWdcZiCElxFMCNT6e+aXVDYtFH2IM
         qbJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792604334; x=1793209134; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        b=N4LTFVx0dorVL2aDwsoPoGWPOFjOBXtiafFDYpCuQPYcDTXEuRQnl9SX+Gn+3J8MPL
         gDWGeJutJoyrdql4/no5sI58Ds7gnlRWuDbvlzmir4AV9co4i/t0uvAkvy1Hzwpn2KfM
         jaQHzHPLev0NhCUCaMi3AtvOam4u2/460IgbwR5pxUfDU/8ZwPAajCkp+wXrC6JzxBOg
         GQhu7o7k2GQmDqqZHb7K5d7JZ8aCskYzloz1xOulP6KNwHvknkteHMtSlEjOYzI8JFyW
         ZZF3EyXAYdfjqmvD++YFgbUSqjSOByyvsSCkBUfJx1ywX6Rhvs49qERn7RfQVSrAhFNU
         RJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604334; x=1793209134;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=csULT7PmXNkTg9HaShgHK/UOyRj2pqW39WBnWQcueFE=;
        b=k7byKy3fqR6CZ0yFwvDMb38Y+xzauyszziz/OC7+oOAkjvrvHqlwAyZXmoFPfOgQf9
         t0B81CFhIDX1GQZ1csEcMelK9wYvmSIGIjdNMOPmgQ1GK+0UoPiIw1oRWBIDpYve/Ci5
         5mBNX3JlDs8pyjxaHTH6sT3cf5cW6rASHJOWJd38Gr2e8glTvmD/AISpMWf+VVAueXrv
         CHwgwc1Nt6AkQOTTCXstk9bXkwHB+O7LRnvGbubE3lT+0VDeSdoGzwF1whWpdoGYbFq9
         ChuPt51jlUbAT0PvCxU4CKNk/fvHIosHGsMDNvAapRVx0BU5Gr0yfIfNzanTZq7lYsrm
         3zHw==
X-Forwarded-Encrypted: i=1; AKwUvBzJw6YH75G3R3EikmzqdVqu/C1UViz7puKABpvws3CyMwgBlSKOh6oDh7h5CxDExifpgkQHdnWlBw==@kvack.org
X-Gm-Message-State: AFq9FYKf/fTUJuH0YCOv7ud3Y73awW1znBRo1yDg0fJ0p8gJMsehfvZU
	QH1xsiLlEyrKXl3hgZiyVZLVtbcI8YqheyaJN2o5GUmOo4/KTfTIfGj1Oq2FkiCd7mEnDKd9Gqh
	X6UIB7YkornoPnnTXV+04fi3Py84geIPCZ9bfB3GLIg==
X-Gm-Gg: AYBFou0f6zKLRgmSLAlFSSglxXQ9T5Lt8Vk4v5cT490TM7eTLZGztMPurI8PEE1HND+
	zCuLSnaIn5mqJyGOlHJA0VzMJfSFU4oGMqSeKhRZesTOPDcAio607RHLLqbE7ps0pvQJSEA3JBW
	W8b8PB6PhUKYt6BOffpoS5AwrwJGMsCLTcKj8A9lKjatnOtSjT5vCTfLNC20vr+yWJ8N0NL9n/G
	Eh45ixtF4AD+uS0WMDKNCxQtCbNmTH5vXd2AgzgS7Sbic5VlPZ0nKHHZB23hI3SxH7X5JTnxikI
	YPhsYh9tQ7DjvXL+ANbY0SnVawUkK8BKa3v0ElYAC2ajFyAy3a/SVwRpYSfHH+aOH9fSWtitX6T
	g46q4HQCMty4gABwvg5B36it59PZ8Zu0J/dsksFKqKnZ+rJJj1tdZsRqqctOydlQKPX8=
X-Received: by 2002:a05:651c:4210:b0:3ab:473f:4340 with SMTP id
 38308e7fff4ca-3ac44229527mr7899791fa.25.1792604334224; Wed, 21 Oct 2026
 10:38:54 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-5-tarunsahu@google.com>
In-Reply-To: <20261021152527.375070-5-tarunsahu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:38:17 -0400
X-Gm-Features: AclHuK9EmTvcDrSPqjt_gHIG_UhFcRBGzP6kEtdhbGsx9XevNkAWoOmg1utImw8
Message-ID: <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F33320005
X-Stat-Signature: nfhm8xojupsdkjjyx4jgynywxwg8wnqk
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792604336-786822
X-HE-Meta: U2FsdGVkX19oSgS+WDFBAhoSYBFoNAUEGbhBBGKRYb/hbte0P6QtWbhRZEeTy9MGuKbPRAX1ctaTdoKc60T7imCvWDBXnRBVzYFjrsvGAY6l6ahzij+Cm5Jqc2oWTxG8ZZGlxyBYQKT+wQbYgSuIpTC/Z7Ip6kBQSL3AyQW5yS/pwKTpF5va5GVAHpecFjix09zpF9VgUUdoOUxRvss8T6xcpgvFblNpogIYTLXXYr0owjmWzrXTQVBWUgHErk2zR8d/nAjCqsfUCmpAmkQm60E32BiWN+rA14fLCQyH+z+C0bOuRpRTudsgF5KAub73ZpEIBmoA3lYcCwom+LT+7Asd66n1QKXZKuJq2g63HjRhcge436FlN+fbLt4D2r3aLUxC/Hp4A5OQLdFoxSrLFgWeC2jmse4dLM6yClbaStVO447JNXjZE6KH4ziBvv1+QFHPuypym6dFaK0uuvnH6OleA7+9NtX9bsPsqrHAdMrDRMWg1QuKXSSvLaCmuRoSVicenXEQI9JtxbFHPxGLvPbrvKyyUireM1Acrm4SKeYmQOoUcfMBn7unV0nAn1N6dy+bWlyJcYuekT7fM8xvgc4lxWTBs/CaWSFzKyQGJXv6exq/LkxopsJ5vtxAMlwQJHCh4TIUNpVkVkgwLyaJX5j1vz4Z1ybfYy3BeuHyZdEY4o/NKcLV8HLfZenRz7umWaN48IQU5ntgzX8gCAgNG543vv5WT4E+cUtDz66q8D+LAj6R6/0knNghKHM/kuazvFYe9s4aZld2DI6jeok9aMtZp/XfBmA31u5pE60y+48LIsZYkmcxQ0uwunfzXMKWuKttAEgl/vfGYvwJ7jrYQzwaY4sEE+1awWTlHI6gRvRdwwNy62qXWsJoprxO8sNLOZdO7Leylfh0ymIySUyPDKN6IQpLhExHKFOzNTPU/oip6KwfTn5LjB5J4cwx5Tw7lwiqulekLr5mHeGxavD
 dv+P4yHH
 cBssMr8aAKAUWwpHIVaXnkNf9Qi+ufcPGs/UIQvmZgmtzShWjQLbgK1O8j2kKlUkrZfn1cq4qmwZYsGh7iYq9K2HrSy/2XCzqaUsoSRYiUhNTssgPlbTcmn8fe1NJwAy3ckG3kiD0KMnMCtQ0hje/Y95bBk+ep8aclCLO6mDTnxZA03csMAbHdRgcxXbv2FLQE/1VyqqOiMbxbLAensNsb10sCTFmLTCKlZ4Dm8dUmBkI+U4IlWhl4JVwwG1xMmUiT3rkils4u3I8fHEzDQzzsYsKSQ6L5t4P6n5pUrrvfKIwFAllWqHXeeNMarhzDBZONOYs7h3uqOAfj6iE28bw79lWZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.com> =
wrote:
>
> Embed the fixed-size 128-byte struct luo_feature_hdr at the start of
> struct memfd_luo_ser and define enum memfd_luo_feature
> (MEMFD_LUO_FEAT_CORE and MEMFD_LUO_FEAT_MAX) for memfd preservation.
>
> All current struct memfd_luo_ser fields (pos, size, seals, flags,
> nr_folios, folios) and MEMFD_LUO_ALL_SEALS belong to
> MEMFD_LUO_FEAT_CORE (LUO_FEAT_REQUIRED in memfd_luo_features). Future
> changes add new entries to enum memfd_luo_feature before
> MEMFD_LUO_FEAT_MAX and append any new fields to the end of struct
> memfd_luo_ser so existing field offsets never shift.
>
> Signed-off-by: Logan Odell <loganodell@google.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/memfd.h | 35 ++++++++++++++++++++++++++++++-----
>  mm/memfd_luo.c                | 14 ++++++++++++++
>  2 files changed, 44 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.=
h
> index 371ffd108a79..f0b5235a408d 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -13,6 +13,7 @@
>
>  #include <linux/types.h>
>  #include <linux/kho/abi/kexec_handover.h>
> +#include <linux/kho/abi/luo.h>
>
>  /**
>   * DOC: memfd Live Update ABI
> @@ -21,11 +22,20 @@
>   * reboot using the LUO.
>   *
>   * The state is serialized into a packed structure `struct memfd_luo_ser=
`
> - * which is handed over to the next kernel via the KHO mechanism.
> + * which is handed over to the target kernel via the KHO mechanism.
>   *
> - * This interface is a contract. Any modification to the structure layou=
t
> - * constitutes a breaking change. Such changes require incrementing the
> - * version number in the MEMFD_LUO_FH_COMPATIBLE string.
> + * This interface is a contract. `struct memfd_luo_ser` starts with a fi=
xed
> + * 128-byte `struct luo_feature_hdr`. The relative order and offsets of
> + * fields must remain unchanged as features are added or retired: new fi=
elds
> + * are appended at the end of `struct memfd_luo_ser` under a new feature
> + * flag in `enum memfd_luo_feature` (before `MEMFD_LUO_FEAT_MAX`), and
> + * retired fields are kept in place so subsequent offsets never shift. I=
n
> + * the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are guaran=
teed
> + * present once `luo_feature_hdr_validate()` succeeds, whereas fields of=
 a
> + * `LUO_FEAT_OPTIONAL` feature should be accessed only after checking
> + * `luo_feature_is_active()`. All current fields (`pos`, `size`, `seals`=
,
> + * `flags`, `nr_folios`, `folios`) and `MEMFD_LUO_ALL_SEALS` belong to
> + * `MEMFD_LUO_FEAT_CORE` (`LUO_FEAT_REQUIRED` in `memfd_luo_features`).
>   */
>
>  /**
> @@ -58,7 +68,7 @@ struct memfd_luo_folio_ser {
>
>  /*
>   * The set of seals this version supports preserving. If support for any=
 new
> - * seals is needed, add it here and bump version.
> + * seals is needed, gate them behind a new feature flag.
>   */
>  #define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
>                              F_SEAL_SHRINK | \
> @@ -67,8 +77,22 @@ struct memfd_luo_folio_ser {
>                              F_SEAL_FUTURE_WRITE | \
>                              F_SEAL_EXEC)
>
> +/**
> + * enum memfd_luo_feature - Feature indices for &struct memfd_luo_ser.
> + * @MEMFD_LUO_FEAT_CORE: Core feature covering `pos`, `size`, `seals`, `=
flags`,
> + *                       `nr_folios`, `folios`, and %MEMFD_LUO_ALL_SEALS=
.
> + * @MEMFD_LUO_FEAT_MAX:  Number of defined &enum memfd_luo_feature featu=
res.
> + */
> +enum memfd_luo_feature {
> +       MEMFD_LUO_FEAT_CORE =3D 0,
> +       MEMFD_LUO_FEAT_MAX,
> +};
> +
> +static_assert((int)MEMFD_LUO_FEAT_MAX <=3D LUO_FEAT_MAX);
> +
>  /**
>   * struct memfd_luo_ser - Main serialization structure for a memfd.
> + * @features:  ABI feature and size header for memfd_luo_ser.
>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
>   * @seals:     The seals present on the memfd. The seals are uABI so it =
is safe
> @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
>   *             struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
> +       struct luo_feature_hdr features;

I have not looked into this yet, but I would prefer to use some kind
of macro constructor for serialized structs. That way, they will
automatically include the header, making it easier to search the code
for what is actually preserved versus what exists only in this kernel.

So, I think something like this:
/* Base serialization header: 4 bytes total size, 4 bytes flags */
struct luo_ser_hdr {
    __u32 total_size;
    __u32 flags;
};

#define LUO_SER_INIT_HDR(obj, _flags) do {           \
    (obj)->hdr.total_size =3D sizeof(*(obj));          \
    (obj)->hdr.flags =3D (_flags);                     \
} while (0)

#define DECLARE_LUO_SER(name, expected_size, members)       \
    struct name {                                           \
        struct luo_ser_hdr hdr;                             \
        members                                             \
    };                                                      \
    static_assert(sizeof(struct name) =3D=3D (expected_size),   \
                  "LUO struct " #name " size mismatch!")

Usage:
/*
 * Header:  8 bytes (hdr: 4 bytes total_size + 4 bytes flags)
 * Payload: 8 (pos) + 8 (size) + 4 (seals) + 4 (_pad) =3D 24 bytes
 * Total:   32 bytes
 */
DECLARE_LUO_SER(memfd_luo_ser, 32,
    __u64 pos;
    __u64 size;
    __u32 seals;
    __u32 _pad;
);

struct memfd_luo_ser *ser;
...
LUO_SER_INIT_HDR(ser, 0);

Thanks,
Pasha

>         u64 pos;
>         u64 size;
>         u32 seals;
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 64f8b8cb75bd..ea1f4c8cd259 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -84,6 +84,10 @@
>
>  #include "internal.h"
>
> +static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] =3D {
> +       [MEMFD_LUO_FEAT_CORE] =3D LUO_FEAT_REQUIRED,
> +};
> +
>  static int memfd_luo_preserve_folios(struct file *file,
>                                      struct kho_vmalloc *kho_vmalloc,
>                                      struct memfd_luo_folio_ser **out_fol=
ios_ser,
> @@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_=
op_args *args)
>                 goto err_free_ser;
>         }
>
> +       luo_feature_hdr_init(&ser->features, sizeof(*ser),
> +                            memfd_luo_features);
>         ser->pos =3D args->file->f_pos;
>         inode_size =3D i_size_read(inode);
>
> @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file=
_op_args *args)
>         if (!ser)
>                 return -EINVAL;
>
> +       err =3D luo_feature_hdr_validate(&ser->features, memfd_luo_featur=
es);
> +       if (err) {
> +               pr_err("memfd_luo_ser feature header validation failed (s=
ize=3D%llu, flags[0]=3D%#llx): %pe\n",
> +                      ser->features.size, ser->features.flags[0],
> +                      ERR_PTR(err));
> +               goto free_ser;
> +       }
> +
>         /* Make sure the file only has seals supported by this version. *=
/
>         if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>                 err =3D -EOPNOTSUPP;
> --
> 2.56.0.212.g129ede20d9-goog
>

