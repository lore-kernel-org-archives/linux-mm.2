Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB48CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7626B0093; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088CC6B0095; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0DD6B0096; Wed, 17 Jun 2026 10:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C58556B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:37:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BEA41C1EAF
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:07 +0000 (UTC)
X-FDA: 84889656894.30.8AD1C0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 926854000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCG6sPUF;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707025;
	b=EqjnbDEYH1lyiVCJGpDNF3BqZrqI4Uhgnd6a1Hg1nq4v/idqy2S1gS08vC9g1LgZTuG0Rk
	nOqGKJSFF5v+FAD1pKbQLwWGgcw46rJbK0jyL7FxFvMXPONINiLF+Uj4hSNE+bkIp+oUVn
	hkkvYy50gbCh4fmMnNikeL8xVMl3iyA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCG6sPUF;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlarZjz9hb/rXsZr46rmLI8X0P0F5x2cPPGw+EkC9ok=;
	b=WmFiR+KNP9igO8NZsvNvEWfw+ZdXHxeJ5ArBKOH7/EzVi+plSUv3uobuHznPMU9INoTBiD
	0xjm5dExNG4aG7AUvimZioB+lhf7D2Sepwh5zLfiWWjQRsIlDMlTe+yEUmDd8gNmJpVNpd
	pb3CBr9ZQuwWzCrmlD8w95ygtflI6GE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EB70407BE;
	Wed, 17 Jun 2026 14:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D231F000E9;
	Wed, 17 Jun 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707024;
	bh=UlarZjz9hb/rXsZr46rmLI8X0P0F5x2cPPGw+EkC9ok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bCG6sPUF2jYcVg9dDrzvJNAZYQUr/vuARhv3RVL/2ysFZlxJRvkaCLKyEKXqyzZmI
	 fKbKuhccmK5+ZPKO+1uZVZB0ofCpLz60PpbOu0FYYXuB6scZApXyb8EeZEN3D9lxLH
	 AJlDoaz4tghoSEaqJFLVQ8jmUST+zsxuml1CxX9VP0CMiZNU6hyRBV523HcslHcwgl
	 PLdBbXuyPHbHHlaW/n8bzvfKQIn2pyvhfZCmufP0Aw0Zy878G8TcRRUJVyhP6XukBT
	 pizbh0YHdGPC+8ZhPXyrH2HKNZ16voiuLOZl/N2PAGcbsc+hVCNSwwahg4+MRBricy
	 SiujHPqM6gAxg==
Message-ID: <918fae64-1323-46ea-a86e-3c847a52f174@kernel.org>
Date: Wed, 17 Jun 2026 23:36:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/15] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0psGISE63oZNEUmTQW1sVnap"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 926854000A
X-Rspam-User: 
X-Stat-Signature: i8tikp6yhgyjibj9xfdaur64y9t4pm6n
X-HE-Tag: 1781707025-787755
X-HE-Meta: U2FsdGVkX18kgLvFPzG8AhG2RCZl6KZAMK6bdeM3lRN67ihBvHxljFw9yW0LJtbydkaWVkDlaU/KNlwmAjrMeQno3VLwCGW0cF75+mQsXfjI9D2wDhSw2kSDP0mH4rE0TRc/z1txhA/i5Mi+DygWyXaYCded4Y/Hy0Bfns1Fa+vW5DkxCJIHHDdPgCExE28a7Xm0ZkYmyau/xS9Oba2KHlRcsTE1aZfGqTxn3nDw3UNJyvzntssvsxDwG9kEva4iriaiIlqAmC7R49/z16Zao/g7LqlbF+0nsNQ8huHYgRsfQGXNUYWyKtFQfmyDDGW8BUVon7smW46OTTk+aYGv2HI9u+ufAjjyDV3AfTDOGl+yH1+AcgXOHPuaLytsUY3YbK+WL8BKXs/eebTsENXKr36NQam4EZURSRlFRPzu1UvCqIXIJ4JkRae1Y1dZYiNHf1TRyWjZAULqkWi91OjoCtnn5ys9zM7T4nziotbcYH7Irsla6htNyZMs6qMBbKy6lxn8nTL0viLFZ7IZuQWrrFkTmsk5CMcxmHrCY1+Zt4MztL+eBtIPAnxDpwUtqq0D4OLE4il0ZQmY3438LRQZJk9LTZ+e/4TnrcBUnoiEHteOpSsKVr/1QlUT8zhzqpC9+1PuCP98k9dYCFNYgAchLlK48POrXDireeT4aa4kRSvOY/JyvxAprX/yRFTvGtdr7M4llInK5wnpcmI0hXqPoktBkiCQh+/q3y9LG23zyCJOgXIJXyYRGT4ZK4L+Hy06V1vOc4JdX+a0O+JA/xwrlBvp2V3uK6XoeXRoam7gvO1ozhDsBVB44MB5w/2Qh/vYBYwyKZyjBX/VDb7HyPVqz8fbpRBTee9yvcKFQZWPfFCHxthr06K9sZaqSlG47uRNPbKGA47FtPbY0rQG3qZJWaagLCK7p1cjCMcvBSfgwooo8tGFiJ/hPHviYBiI1LGxuNAZfruKKDqjNkBiG+c
 3OwDCv8K
 vxXfi9uC/+SAEKsGPrVu0sflqlcTm/kfRPyoe+kVkfzWXFfFlEhKLB8KoDJ3/+LV+lEsGakP2MHFiDT476ph8ev26MkPP1ayfBji9I7X2O+g3X5udtFDfKxs2wfP/VnFnSv0bj2U51IGxmeuYtfhUyMLCdwzipIDJV46axkMBYaJgWFlFWX/wNymmsMDrkiepH8vU2YvEQkhpOxcdDsWm99H3HQROBSfVJbszR7rVjg2xaHXZUo+cTDV0PUVT+0mue18hX3p2OqhjPpMkzm6s0MYAVbh1B/v/K3cnO2T4j3NwCEOxVOsCqrbhmp731iRs4hhPXcGqQmgYrF9rosiJMOSOVsJx+iDu5PnOO0tzyEHvAjTu2S8Tu6iW8QP3dCVpis00UVHJVPbp0lZNfr60Rzli3U/hjTJAmeS4/uaW9UVUMYi1CGyIvkwjf3ycAh4UzLTiEdt1smd5X2XP/Ur7sJsM2pXSwjkwVI7yVVG9gaKCFK8PYrPt37C7SKn2kufc+uBJr6RBMbzVvmIQwiWP6HT4DmFOjWkvILBEsfBNDQ8feJbpu9Pn0pPYavVQZ3Mpaj3k4pVHIq9AT+4h01SjzIgp1dPteLJ5fJI7pCKmt6ikQHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0psGISE63oZNEUmTQW1sVnap
Content-Type: multipart/mixed; boundary="------------TBNAO9MmQOQu2Pmqd1aWCBrf";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <918fae64-1323-46ea-a86e-3c847a52f174@kernel.org>
Subject: Re: [PATCH v3 15/15] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-15-ce1146d140fb@kernel.org>

--------------TBNAO9MmQOQu2Pmqd1aWCBrf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> Finish the switch away from __GFP_NO_OBJ_EXT by replacing it with
> SLAB_ALLOC_NO_RECURSE when allocating empty sheaves. Pass alloc_flags t=
o
> [__]alloc_empty_sheaf(). Callers that can't be part of a recursive
> kmalloc() chain simply pass SLAB_ALLOC_DEFAULT. Use kmalloc_flags()
> instead of kzalloc() for allocating the sheaf.
>=20
> With that we can finalize the removal the __GFP_NO_OBJ_EXT handling fro=
m
> obj_ext allocations as well, leaving only SLAB_ALLOC_NO_RECURSE in
> place.
>=20
> This leaves __GFP_NO_OBJ_EXT with no users in slab, so stop allowing th=
e
> flag in kmalloc_nolock().
>=20
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-16-7190909d=
b118@kernel.org
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------TBNAO9MmQOQu2Pmqd1aWCBrf--

--------------0psGISE63oZNEUmTQW1sVnap
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajKxCgAKCRCGXBN6rc5S
1r87AQCEyvL7xwt5erc8QniuHD39QfJrMf+Jct/CdQ6VCpZwHQD9F2GeRLOW2gH8
BdWpY/PNn1VD0J1HMWM/+M8tRZMkoAw=
=AtOR
-----END PGP SIGNATURE-----

--------------0psGISE63oZNEUmTQW1sVnap--

