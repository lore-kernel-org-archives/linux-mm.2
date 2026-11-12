Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF182606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIr79jpn
Received: by kanga.kvack.org (Postfix)
	id C802E6B05B0; Thu, 12 Nov 2026 09:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56C76B05B1; Thu, 12 Nov 2026 09:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93CC6B05B6; Thu, 12 Nov 2026 09:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928B66B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:05:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DB38A81EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:05:12 +0000 (UTC)
X-FDA: 85426638864.27.CBF90EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71A901C0010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:05:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIr79jpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37YEvbzDbI8HZS34CABp2PeUnJCvqDia4gZnLw6YN1A=;
	b=Vb5v+uEPkQL7zoDiQEd3cwDt3eUt7b87w98jGKOqAausQjQDVuQR2p+FqkfIJpMHdhPQLV
	6lfouB0LfTgho2Ti18rsCnVyUVkXf2eUqtuiCx4JB5tIF5odVe6HB8XJF6HLunC3uUFpgn
	5j1rMmwUbu/PJXGsAnI/HO4SSsk5+uI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIr79jpn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492310;
	b=dKF+Vd8PCeFYJqluCwy+W7NYx2LYZzvKQmCR/A4dNt6MKzjFWVdcIzG9qkqikvfsgIsHle
	rau5VU9UDWuJmSuVrxhK3JmM6xJXXn/veAvBeH6kqh/Ei1fZ6aVj3Cvyy1mzV0sMb+CRbj
	njOGVykzssT+CBRdbkXXhofDlOTt2qw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF14E65831;
	Thu, 12 Nov 2026 14:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E729D1F00A0C;
	Thu, 12 Nov 2026 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492309;
	bh=37YEvbzDbI8HZS34CABp2PeUnJCvqDia4gZnLw6YN1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HIr79jpnw0ws0bSX0pUzb70vipKB7+0hKPCAvCiUNZdFHt8F1nneqMdRtaSIMgZ2G
	 l3obU7b7O1FDxVnWZktYE9ko+xgTQG57IJSBuhuq4vl2eGXCNDQVQXYYkWZ1487XLo
	 /yX5Ioj2M5KTboE9c/RvNUy1tFyjcrrkLRIvktH38b+o+KYqNDHIX5+3IogKOTFwPG
	 050cbVaGT19YC4TbgAVnFPPRkBt1PjmFcDoPDhHKjYw9z10GKxIGS/zgx7/3Vh7t7C
	 dorryUCTXftoz7txLg4GxB4tmsXgI3YLKjFLhwQCWuq13ahoRJdcQUc4j2UYAOxLaY
	 0PM2h09NvfoeA==
Message-ID: <sashiko-outbox-211258@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dma-contiguous: support percentage sizes in
 cma_pernuma= and numa_cma=
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexander Graf" <graf@amazon.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Robin Murphy" <robin.murphy@arm.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, nh-open-source@amazon.com, linux-mm@kvack.org, "The
 AWS Nitro Enclaves Team" <aws-nitro-enclaves-devel@amazon.com>
In-Reply-To: <20261111140440.43024-1-graf@amazon.com>
References: <20261111140440.43024-1-graf@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:05:08 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71A901C0010
X-Stat-Signature: 1rn9jem8ho93nptsdgrzsdypkgpht6xa
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794492310-792326
X-HE-Meta: U2FsdGVkX18Wc9r5x4s/wVAdno8+54lPvpM0ZwpGaFpTGKznzvr3heNwwvrGLBiONGh7cUIM+AZv6zTvr2M/zePH4mUt5/eSq6AYD9KGh17aJRhtdr78zpwVFZOltZXjVLbvm2new4yN3ga1QCqF1au3KlPptpR5/PkM5gLBPQxKmpn3teoPyK/mvcNWqrqAuH0+YisDpugoI0QqVnkKjJGj5KFxBEGYtUYAHfIQHBd1+aPjyr04ZEesBiXDJyyv9W2et5Vwg/2UV7+WHYLKyKzN/CrIlEjsKQ6CFTs92G4IQXaCXi5DLWtFznOmWzTAOkkICVAgNFScILYD4f0I5/q/iHS6OUw88qi1vGV0aE9T2Iu3XnPWJ7aMYNAn0tfC1QvIWA4dhVhyGxFVfRvM9O07XCD2dMQuAxyXUYV4uXefB1o+hjnimGBizCfuEKSjOSF5/ONJaaCEeWjsCYUVLimdqdVPrRo1IK8qHV/HWq8BLtSao37RhuLOyAEBOGx7tIl+hcTmBzKaNLiyPqQwZtE6kXcTGYgFviB6z2+AqCdDF5wsoJ1o2vxerNTMBv73ZR1ssZgoQqvOwDpTCCcoWcw3R86i7Y8J3HIczS9STQNWdmPZ9p07RS3Esn7+7UEgrRY77wOep7LzXWSEx0hCTvxxdixyBdjjopKnVKEgVLt06WLeWq+YnPmaGE39MfrY6LWo+7UDeyxlYDKN991zE+7H1+BR/8k2aGWDRrgGZf0L9+YoeexDtFmS0eFBGakm74/CNe+7mmX7AvTQHg+8BHCQcVEpO+3Z/BVikFVV9bKsjUWZxt1Qb2kPcsB6hMY9QeFMtr/0wB/FbPjKKTA9OnWzQsjulesTBlF/weM6CY/eUEZdsWraDaGWCmnL/HMoPAYRslgkXyoMat+IH/It6EzPpd7D1U7iAB7hEALKrSd+BztcdqAaON4ARY4UGP9/yT+m/8uCiTBJA1J+T0Z
 gDxV/MY5
 fiz4e+FLdz7OvNIZBvusSvY8kAKyBxc0YN5OYct5Ym6CLBK29jJVAL6KETzT1RJ84yj/k1zoI3L7sa9TBUh3aA6D0kkApyurnqjt98G+AzX/FRkwAwomyfVd720ukIbw1H5wgbVnf9mUphUqhU8n+KLlhABNwY7vrso0ZYeeJfefve5y/vMRSsn/dK8UGXnfU9l4v11Kv8ufzZIj3mTLiT+kHZZUxrzCHdjGNKmgiYXfh/MDApm2Hkwt9qpYZQiVZYQa6Njhm0LzfwfC0/SK/RfrMkhw7kDUGUvvRhbXxGD+hXF2ADJkFS84exf29V1yTEFFHv5zEc0+pA8MDvXP00OizR2+cjOW6oB+YwjVpXMf69VuCbr5dXSfnbckuqJgoHRafIePJXz9ajX16/zhcwqPF3SqT3y/4ulPAiTxz2dIoVC2ltPMvO+z2d62iTwFdnXjK4x78uc3hSlORhC7H80m3k7ZpqGHdT4+QVyyEERpg+1KcUcK8aNOPmNv1Qyn70Enl44YNgEDoCo3jvbOrpWvcfLTVbMIr8ZfbiLrdIYo+Z+VwLWTAyrLrdWDdXuF8W+KJU4hbzDF3Gwkjumr+hluo1NcH49QVKsgQuBHXmhQm6R+J813LFwACZxL7yh0Encz/DtwfzEilur8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] dma-contiguous: numa_cma_parse() accepts empty string and
  trailing comma
- [Medium] dma-contiguous: zero byte size fails to override percentage
  in dma_numa_cma_reserve()
--

commit 3226f812115ddc4c4b57efe08a3f196e1ea740b7
Author: Alexander Graf <graf@amazon.com>

dma-contiguous: support percentage sizes in cma_pernuma=3D and numa_cma=3D

This commit extends the cma_pernuma=3D and numa_cma=3D boot parameters to
accept percentage-based sizes with an optional byte amount to subtract,
and validates the parameter string before applying it.

> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index 90937dc7c627d..c04d50ee0f7c8 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -135,45 +136,132 @@ EXPORT_SYMBOL_GPL(dev_get_cma_area);
>  static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
>  static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;
>  static phys_addr_t pernuma_size_bytes __initdata;
> +static unsigned int numa_cma_pct[MAX_NUMNODES] __initdata;
> +static unsigned int pernuma_pct __initdata;
> +static phys_addr_t numa_cma_sub[MAX_NUMNODES] __initdata;
> +static phys_addr_t pernuma_sub __initdata;
>  static bool numa_cma_configured __initdata;
> =20
> -static int __init early_numa_cma(char *p)
> +/*
> + * What numa_cma_parse() does with a string it accepts: NUMA_CMA_CHECK l=
eaves
> + * everything outside the function as it is, so a caller can validate the
> + * whole string before NUMA_CMA_APPLY lets any part of it take effect.
> + */
> +enum numa_cma_action {
> +	NUMA_CMA_CHECK,
> +	NUMA_CMA_APPLY,
> +};
> +
> +/*
> + * Parse one numa_cma=3D string: a comma separated list of <node>:<size>=
, where
> + * <size> is a size or <percent>%[-<size>]. Anything else fails the pars=
e.
> + */
> +static int __init numa_cma_parse(char *p, enum numa_cma_action action)
>  {
>  	int nid, count =3D 0;
>  	unsigned long node;
> -	phys_addr_t size;
> -	char *s =3D p;
> +	phys_addr_t size, sub;
> +	char *s =3D p, *start;
> =20
>  	while (*s) {
> -		if (sscanf(s, "%lu%n", &node, &count) !=3D 1)
> -			break;
> -
> -		if (s[count] =3D=3D ':') {
> -			if (node >=3D MAX_NUMNODES)
> -				break;
> -			nid =3D array_index_nospec(node, MAX_NUMNODES);
> -
> -			s +=3D count + 1;
> -			size =3D memparse(s, &s);
> +		if (sscanf(s, "%lu%n", &node, &count) !=3D 1 || s[count] !=3D ':' ||
> +		    node >=3D MAX_NUMNODES)
> +			return -EINVAL;
> +		nid =3D array_index_nospec(node, MAX_NUMNODES);
> +
> +		start =3D s + count + 1;
> +		size =3D memparse(start, &s);
> +		if (s =3D=3D start)
> +			return -EINVAL;
> +
> +		if (*s =3D=3D '%') {
> +			s++;
> +			if (size > 100) {
> +				pr_warn("numa_cma: node %d percentage %llu%% > 100\n",
> +					nid, (unsigned long long)size);
> +				return -EINVAL;
> +			}
> +			sub =3D 0;
> +			if (*s =3D=3D '-') {
> +				start =3D ++s;
> +				sub =3D memparse(start, &s);
> +				if (s =3D=3D start)
> +					return -EINVAL;
> +			}
> +			if (action =3D=3D NUMA_CMA_APPLY) {
> +				numa_cma_pct[nid] =3D size;
> +				numa_cma_sub[nid] =3D sub;
> +			}
> +		} else if (action =3D=3D NUMA_CMA_APPLY) {
>  			numa_cma_size[nid] =3D size;
> +		}
> =20
> -			if (*s =3D=3D ',')
> -				s++;
> -			else
> -				break;
> -		} else
> -			break;
> +		if (*s =3D=3D ',')
> +			s++;
> +		else if (*s)
> +			return -EINVAL;
>  	}
> =20
> -	numa_cma_configured =3D true;
>  	return 0;
>  }

[Severity: Medium]
Does numa_cma_parse() accept an empty string or a trailing comma?

When s is empty initially (numa_cma=3D) or after advancing past a trailing
comma (such as numa_cma=3D0:4G,), while (*s) terminates and returns 0
instead of -EINVAL.  On a trailing comma, the NUMA_CMA_CHECK pass
succeeds and NUMA_CMA_APPLY applies the preceding entries rather than
rejecting the malformed parameter as documented.

[ ... ]

> @@ -214,16 +329,37 @@ static void __init dma_numa_cma_reserve(void)
>  		int ret;
> =20
>  		if (!node_online(nid)) {
> -			if (pernuma_size_bytes || numa_cma_size[nid])
> +			if (pernuma_size_bytes || pernuma_pct ||
> +			    numa_cma_size[nid] || numa_cma_pct[nid])
>  				pr_warn("invalid node %d specified\n", nid);
>  			continue;
>  		}
> =20
>  		/* per-node numa setting has the priority */
> -		size =3D numa_cma_size[nid] ?: pernuma_size_bytes;
> -		if (!size)
> +		if (numa_cma_size[nid])
> +			size =3D numa_cma_size[nid];
> +		else if (numa_cma_pct[nid])
> +			size =3D numa_cma_pct_size(nid, numa_cma_pct[nid],
> +						 numa_cma_sub[nid]);
> +		else if (pernuma_size_bytes)
> +			size =3D pernuma_size_bytes;
> +		else if (pernuma_pct)
> +			size =3D numa_cma_pct_size(nid, pernuma_pct, pernuma_sub);
> +		else
>  			continue;

[Severity: Medium]
What happens when an explicit byte size of 0 is given alongside a
percentage, such as appending cma_pernuma=3D0 to override an earlier
cma_pernuma=3D80%, or passing numa_cma=3D0:50%,0:0?

Parsing an absolute size leaves pernuma_pct or numa_cma_pct[nid] intact,
and dma_numa_cma_reserve() treats pernuma_size_bytes =3D=3D 0 and
numa_cma_size[nid] =3D=3D 0 as unset.  Instead of the absolute 0 taking
priority and disabling the reservation as documented in
kernel-parameters.txt, it falls through to the percentage and still
reserves the CMA area.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111140440.4302=
4-1-graf@amazon.com?part=3D1

