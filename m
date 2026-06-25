Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F908CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866226B0098; Thu, 25 Jun 2026 05:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816D26B0099; Thu, 25 Jun 2026 05:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D716B009B; Thu, 25 Jun 2026 05:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46CF76B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:01:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D81161C5EEA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:00:59 +0000 (UTC)
X-FDA: 84917840238.20.E0FA52C
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id E33D44000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:00:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M02xqOSe;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378058;
	b=hThP6sP4/pfVPhlYjR1y5S4CznrF+HOZ9+lKqssw4FZ30kseasgyLD0/cVcBl3+kt5gL2v
	IPSj1uMnVqYCuCvISfX0iH+KJz9SXX2uiLWn1bE63i1JztEPVOoy1wfJemzXFhpgsizqC6
	ZLPNXJYsXrVOCSQVwQSZLGDQEaAv6QM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfoZGVTsV5t4p+3rbcX8T0LDvzopvkAnF0ng3yDh508=;
	b=UBUr1r7kBVlu9iAKtgLNT9+6sM83gopPCxxUviMTar471T03FpwWPzjyV9aLJzazjx435c
	w5S6rJ8WW7QoaOH8NnvsEXobIfWam/hhBGs/JuYB6e6cIJsuZcHITQtz0fETFzvpkoRSUm
	4bMcKhyTAYnNMzzMFoDg7J+gAGFIO1Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M02xqOSe;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so14127035e9.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782378056; x=1782982856; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WfoZGVTsV5t4p+3rbcX8T0LDvzopvkAnF0ng3yDh508=;
        b=M02xqOSebDLkSbwd6Xq0c4NvNRhaYCEl3fESBtFnsYDXw0bNtcAPNXsnKJKIPu/QXO
         BkLJDmrUrhx98VhvH9BAO9rJyUCjgCKU2V9KM9Y/64N9Z72gvacJ+B61BzoTrt2YxvH5
         ZBGSA+C3lu62gtdX7KGw55e75yt/yqczZTo9snnCkQIxHfHYxaUipw5V94J5sRPNKMat
         wsfeESQUyIkV88MbElTKw4SXcCJAtn5LYH3jjAXFNXqWvcRTH0CsKSo+S7EcYgaUBz/l
         +hXOLE6AvoTflQYKN0lLj7ZsUIGLwyhfkX5JG9q/VTqobiWmBTmWVLt5Jx0d3cms9iAZ
         lnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378056; x=1782982856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfoZGVTsV5t4p+3rbcX8T0LDvzopvkAnF0ng3yDh508=;
        b=lV13HWz21n2DA7Bu3JwSO5UTTti76bNK9GeJPkW5k4vQRVvzxVW63EwniMkD3aVhVB
         8HEB1SjSlpvdav8DH+AfjE1f/VspqkYHhtreeDIJw70nQLzJEDBBIiQkqJg/6mTOQs7u
         8t5tE87bmHcUxCo9eRCWz97rifDqsT+bUBnmhKWVNKyxBi5tD8t4C2W6kzCf5vbxfaoj
         v0BCqQfByBAAEK+jVeWBKwNYR4neWfJchmuny+d2nvRU7sq3zhkBRGdaxCBWz+bsmyew
         oBUKqc1r3r7BQgr5Tx2HVWNLF+Pyg8okIjijYZGMsjT6X7vCQkYFMeAC1tBdVLBTVoxu
         C2Ug==
X-Forwarded-Encrypted: i=1; AFNElJ+QdRtRpqdll61gDcPkW4hQMGCT2ckrbXzTUXlNZo+MewiWelV9YJUwBcSnH8nGBxScX+1/Ua4QwA==@kvack.org
X-Gm-Message-State: AOJu0Yzohia193nPDwGiSvKqoPk9DYanzGp0lWtk8qMnLNfZU80k9i5q
	bhs43VlS5WKcm1fgMQTQIrQ0nuYRZkGo9gyKI2wk6cP+iqK43NKHT9TSkGmNMxg2RJU=
X-Gm-Gg: AfdE7ck0WmwQRy0OVqJU4LlJ1S6TpLLU8z8dmYCeYCEzg24cHx2spsF7HvP+A/KA0dG
	SNYm3z+BzqEbv31qN6fC0TfZRkKZyy6Zx8QjBxZPN/EldBruRzoU+hsXhOAcTD9fJqPyQzXWH5M
	4xFvtbbXm06kEyNUfCc5cCGUPYWgJ36tn4OcafsEAM0j8Kwd0trZZ68vlZpll2Y7BoewKukjj+B
	qeFSOwcJMawOveWrjB5MyPqLca6YuEuBGhcHL7ngrp3yJXaR5L1m0wkP0w8rUTWb3p+kdG12Sxd
	kfgmovTDhm/SzOcmRU5W7n/3RlFSpv2gnZ6J7P93SyCIx/iI6XDQgVlyqizWUXda3hpu+smB+Wa
	e+PU1AZP4do/AnaGtJON9BYd4AtztcWHPb4ov/1gGdouIp9cVXz4jmzSFy5DYxC95y5kalf4SY/
	L0I/guISstZqQpT3THIw==
X-Received: by 2002:a05:600c:1392:b0:492:488c:f630 with SMTP id 5b1f17b1804b1-492668b6847mr21727405e9.34.1782378054669;
        Thu, 25 Jun 2026 02:00:54 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49263f9c59fsm108017195e9.0.2026.06.25.02.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:00:54 -0700 (PDT)
Date: Thu, 25 Jun 2026 11:00:52 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm/vmpressure: split v1 userspace eventfd code into
 vmpressure-v1.c
Message-ID: <ajzsE9WMl84MeBOr@localhost.localdomain>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <20260606114158.3126210-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mbkwnm3cz7yyfzkf"
Content-Disposition: inline
In-Reply-To: <20260606114158.3126210-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Stat-Signature: czq1aydem3x9kbh3gq1p19ogzj93uk9n
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E33D44000D
X-HE-Tag: 1782378057-99663
X-HE-Meta: U2FsdGVkX1/6IsRWVWa7vgHvu5JBw+nyhqiqLmLTxDaeEMPTrxsArlJMxexV7V36xaThWYul3dLQ288Ut28D2KuTnZ1D2D+Uv0OZub3mFNSRXJDSXGkGJvwHI5vdH2/PtdOvY6lqLdy14rl9m44LvlyAwQ4sub1Ad+Zhzmokeh89bYfC+AvxMA/FToQDZcPvhIqunf0GKn+oL+kKnafPRK5k9qeccrdxbRom1posbd+/GUXJpJhPOTFpAZzDXyK3D9doiJYrYnVnODXnMk4Dd3keZHjvrFAVhu6Xwu38wwBuOCWngUENXSFs1r7NTE3cmakOFyoNlOZg5VpAIFAlg6t/rGqrXcRRAFWI8U3D00byDmRTc/2DyAxMmHQAVw06ZhNVFuVxfmJ+TNJUnCQ2x0frQvwOuRO1mw5+HpnsUzXzenVQnlJROZev2M9XkI4c6afL2ItFGZAyuz2kh15wPcm8WZwGjOwCM66j6sdZumTpkC+UNYN4uE5t5DnBYnI+qcOiVjFFOmNHW9HYIPz+l1jvoGOuXoFN0MNG9EETw8BQy0FBlEYiPT7PAqCLLeibtJXWEz1Wxyk/ajm9cS9Xb23KTFL5o7RJJ5mEa4EpNUA+ZEi6Fp6LL3CyqOsF4SaqFix53MsCFRPvj0ssJKpsIDg5kGTf1zNIjeQJ17jbcPAh7Ylz4hUmW8ju+FynQQ0FlsbYdC7JeyJoX9K8QLQg6gpce3p6E9/Es7+SMgteLDJUuvKinylLMXS8oKFeciUm+IlM8IKgAlYQSccV3o3UC3AjnjZI/pYXr6afnKGZrZc4HpuvvJ45a/uutLmqKpouwOW/4BOe3KOIQG8RAUCUeflHN75VAyOGanB8XFsoFO9eCZcFijQISBJb6AWVJJVDdNFikGfxDG/vPvOeZSJbGkj6eRiWfRAUYX1+b5uZEeHz7vsluFsj44h34vMK3SHtIgPXaJGo6Ol56lEEuJa
 JsEA5jL+
 dkNw0LCCx3hLyjLzYVZFK7QO81mb8Rn3V2hsgQGFokUrcwJQb9ukYhIfoU43V5W+noP4YGvt3z7MX8CSyolpvk2HDiiqWzk46O6OZ2qi0oxOkNltGUqYRdVUrsmHIxhZQnytfjnySU7Nvd9i4yc7uqTvPiD71Xjvg0H8s8f4hmD/lAw0eO5dCnSCbMlRmRp5qD70SVhgFWnNXr6j1S5F0hnS/R0L+rra9WTKwaTtjOaGHqqwxE1+Yd+ZGGdERlAgDMj/EwnzKulxRA2DFiprs+TgwfJJmc/vw0ia9mGiMo51fQseGm6cpJpoUYqSTnMJtAMmOEJMe0dhxZ6DObz9ymk7zTmmD77NxvsWpc2J435zczhLwFD6ZIJ9gqBDn640TGZg4ojXxvS+A5KO4Q0ocpHsxAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--mbkwnm3cz7yyfzkf
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2] mm/vmpressure: split v1 userspace eventfd code into
 vmpressure-v1.c
MIME-Version: 1.0

On Sat, Jun 06, 2026 at 04:41:34AM -0700, Usama Arif <usama.arif@linux.dev>=
 wrote:
> Clean up mm/vmpressure.c by separating the cgroup v1 userspace eventfd
> interface from the shared and v2 in-kernel code.
>=20
> Currently, almost half of mm/vmpressure.c exists to serve tree=3Dtrue:
> struct vmpressure_event, the events list and its mutex, the work_struct
> and vmpressure_work_fn that drains tree_scanned/tree_reclaimed, the
> parent walk, vmpressure_event(), vmpressure_register_event(),
> vmpressure_unregister_event(), and vmpressure_prio() (which always
> calls vmpressure() with tree=3Dtrue).
>=20
> Move it all into a new mm/vmpressure-v1.c built only when
> CONFIG_MEMCG_V1=3Dy (following the existing memcontrol-v1.o pattern).

Thanks for this dissection.

> @@ -283,14 +152,8 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgr=
oup *memcg, bool tree,
>  		return;
> =20
>  	if (tree) {
> -		spin_lock(&vmpr->sr_lock);
> -		scanned =3D vmpr->tree_scanned +=3D scanned;
> -		vmpr->tree_reclaimed +=3D reclaimed;
> -		spin_unlock(&vmpr->sr_lock);
> -
> -		if (scanned < vmpressure_win)
> -			return;
> -		schedule_work(&vmpr->work);
> +		vmpressure_v1_account_tree(vmpr, scanned, reclaimed);
> +		return;
>  	} else {
>  		enum vmpressure_levels level;
> =20

This return; looks weird, I'd either
a) drop it or=20
b) keep it + de-indent the rest of the vmpressure().

--mbkwnm3cz7yyfzkf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajzuPxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjOzwD8CPiAls60D/6NjUECmaox
xluxdlgyvBk9WbfRajccL3kBAKTgCpg7umM8qKzTqkSgvxvDl7NuPRftLAYNe9Bn
9vIN
=Tc+Y
-----END PGP SIGNATURE-----

--mbkwnm3cz7yyfzkf--

