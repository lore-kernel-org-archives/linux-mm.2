Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D866ACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10EC36B0202; Sun, 31 May 2026 23:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF946B0203; Sun, 31 May 2026 23:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F186D6B0204; Sun, 31 May 2026 23:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD3166B0202
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:16:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C2BEA04F3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:16:53 +0000 (UTC)
X-FDA: 84829881906.18.E0F8C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C62972000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:16:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2KjTEXz;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780283811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nanJnpIe+Hu/ywCaBRWOqFVIIOP5mGOP2PQvp3iZE+Q=;
	b=u3AaKoE7Boc8MdTDukpxA9i4yKlps1SWjlXPslJ8dQO3JWX0KI7D5vAle2R2cw2OyMRQvI
	J9DkD5sk1tkwrjk0yTiEMPmXSNlCq1malMQxBzJ6UMLL2/nt0AE5ON0ouAY2c//lz51hsC
	ACZ97UwYspWrPVstCk8mS/KbP6ef6BA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780283811; a=rsa-sha256;
	cv=none;
	b=tNA57mA6pUC4cQS/kyictD1toMlzmvVuqOS008nWJ05dUqVn9AtY+4SpUOkllAT0SSMaRH
	YJKQGhdZV/EWBDCo1qPNYO6mu4uyC+Lom4N8s6sdnlW1Jc89ovNcJbe2jHAeFLdxfKxMIF
	RnXaSoYIIoulT5be0AtD8ucMqz5ghjE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2KjTEXz;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B58FC42D94;
	Mon,  1 Jun 2026 03:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4721F00893;
	Mon,  1 Jun 2026 03:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780283810;
	bh=nanJnpIe+Hu/ywCaBRWOqFVIIOP5mGOP2PQvp3iZE+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L2KjTEXz9ohjWFwydN+6GUMdnl+Vk/rhhIxeaaIOrb7+NH9r0RzdPI2UnZZ/SSb2+
	 Ci74VFRmAjpKRH7JDHMHws0ceAGqgC7FlXNfjXVWrZyTojW5xFYRigU8VZ2AC3fmKj
	 WwfNLoC2aM4C4I6F0iHhR1AAS1YHLu3U8JsOkUZcpS1pjQ95JLayA5RWw1BsPSZs5u
	 AMp+pZKgZGfkZtMurs5eCR8OmCWf1HATbfdYQACbABxU07Mlv1tG1VFVkOLo6J2IlS
	 82lg8LO5BbwhIZdHnjBWQ0oGp2eWL6Kvz7i8t1ZMASlVgV7ofsYNbQXkZCUUQqjUVj
	 ZQnpz5zPw51bQ==
Message-ID: <d0bb04f0-a735-4b80-8c08-2d1b9135b517@kernel.org>
Date: Mon, 1 Jun 2026 12:16:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/slub: use empty sheaf helpers for oversized sheaves
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wvSHft0BOYReDcApDrNx573m"
X-Rspam-User: 
X-Rspamd-Queue-Id: C62972000C
X-Stat-Signature: f8jizpyqmzctymu6qqups31j73n5gd4w
X-Rspamd-Server: rspam06
X-HE-Tag: 1780283811-64238
X-HE-Meta: U2FsdGVkX1+InciNHu0w5E//+1XZ/SzGVt5dBNN3Dqw6SItA22gSLH6PNv/O4QjVXE9kjdadhxJ6byZBt4up50yfBk+5uQlc3lD7tJkhWXK+XsF848pla+RzpHV2bAgvkxNOTLxk9RRNK6vfYiPhTZ3lgi4Me+wWnMKBdDNni9+Yw/BefGPt1KtyAF/ftlUyZLHyFdGVteXfSfoKNBiVDKpER5xE+9b0/GHQ0Un4ezWeeLcm7DGcQxSQOd0ZONHNXGGDbbieo1/Ll1VB2yY9kl3804L4grXQLbcfqsUeHtl4raIsMBrKtKSbXxV3XQHxy8BFj9030D7hpTNkKIEfcIutr2FhF+iO/EimvxH/KEap5QrVqIMCw+Oetmi4Fbc4gFA3OFbKW9i2t1Y0eux3iBEWcUHAj9/8IBDhR383/gY/XryG9/6G5Uy10i9ocUtN7VGzER59BKuFXdEyrMTnHiCoOFiNOND2o0DcFW/tIzFLdT0d0PbsGGyBMoldmBXvDEEfP8/PdYyQtI+QgQHFUjda44zoMPFouxVLX47cu1+Qf50AxqSfBm/rQV25qnTm6hTivSC4554RwlRsbvo9SXrwzLTLUwynYblcxBWkttoTAzC6nCNgvV3HSYLK9ykLEk291rZUL0yI57D0spLlIM1AT1fJgpjT/lDmuOML+nCTtO2ig9P7n/kn8fWrDhrqqa2pHxAGpilTHhAajoEG6UdZ5WU0o+ykPOsy8OOCFXR38wkYqm2IsuT/GgjHuvJSRkp9cJFvNyTSH6EUZQwyBkyC2errNlPwKacKZGStEuQmTas4kXNoOzH3R4OLVYi8LMNNQ3PcRU2QS7Nzc9/RvuHgzXmPqo7joBWxz5u2jhoszgcVg1B9hG50Unxfgi+uHt8rNwUtQjN7N2Q3P9uvT0yQMW89MYaBgDungQ2CU1XrKW39TvTWdYE9haEjBtSs6kHbam/WbTmzn/gK5XC
 Af7KkrMo
 ZT65FAqZD7LrqMPvMZyBcQG3b65rZljRVyOkaWDiI7rVr9+crC3OoWdZlZnIBfYKIRKCA2i6vZjpKHGs+ZS/NduzoZGq7/56xRwOD72xXaJwCR3Ivxe/NQA1vj81E1fVCrAKMdUcfZKLjCi5drGAL7QjysBfuvN7ea43X1LFtqSGRf1Tb24AigFbl2urEhaPBQNvXI0TzkJ8u/AXTllQ/HEiMVucDm3Dc2xai28uJpljSDCPZKpBQO3YwmBjNJDo27Z1tm3KH45SaOJSsYwq211Ko+24Ra9QmBL5QZo5WY7Ze7pH/aCE7ForYXUVlfbsy4jjTBhzU+66OAUG2VGahVP1mEFLz02BI5oVDM90JsW+BY8IPneyjE0ISw4mIvXSfnKLWVLTHUM7qBSs7kRx6NhXeGJuu8z3lNSo1kJJHEb3peAjwh3l8qq7yYy3yOBJCWXjIDYy1S5MR20mOSFZxm8Gx5YRlDqWzhGOygsB4bxa8b7DtjIIHcGyP3bhEyzxARJ0D6kfmw7V78Kr6Fwu1plEnWfmFDgPVeuk4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wvSHft0BOYReDcApDrNx573m
Content-Type: multipart/mixed; boundary="------------hCJQ0q6epRJOdVh0NFh51kNn";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <d0bb04f0-a735-4b80-8c08-2d1b9135b517@kernel.org>
Subject: Re: [PATCH v5] mm/slub: use empty sheaf helpers for oversized sheaves
References: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>
In-Reply-To: <20260528193537623nAo-xYBNYBysGKSBjREuO@zte.com.cn>

--------------hCJQ0q6epRJOdVh0NFh51kNn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 5/28/26 8:35 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> Oversized prefilled sheaves are allocated separately because their
> capacity can be larger than the cache's regular sheaf capacity. After
> they are flushed, however, they are empty sheaves as well, and should b=
e
> released through the same empty-sheaf helper.
>=20
> Allocate oversized prefilled sheaves with __alloc_empty_sheaf() and fre=
e
> them with free_empty_sheaf() after a failed prefill or after they are
> returned and flushed. This keeps the oversized and pfmemalloc return pa=
ths
> consistent, including the SLAB_KMALLOC-specific __GFP_NO_OBJ_EXT and
> mark_obj_codetag_empty() handling.
>=20
> Keep the caller-GFP filtering in alloc_empty_sheaf() instead of
> __alloc_empty_sheaf(). In particular, do not clear OBJCGS_CLEAR_MASK in=

> the raw helper, so the oversized prefill path does not unexpectedly dro=
p
> caller-provided flags such as __GFP_NOFAIL. The SLAB_KMALLOC-specific
> addition of __GFP_NO_OBJ_EXT remains in __alloc_empty_sheaf(), matching=

> the free_empty_sheaf() assumption.
>=20
> Since oversized sheaves are now allocated and freed through the empty
> sheaf helpers, SHEAF_ALLOC and SHEAF_FREE also account for oversized
> sheaves. Update the stat comments accordingly.
>=20
> Keep the capacity initialization in the oversized prefill path, since
> capacity is currently only used for prefilled sheaves
>=20
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon


--------------hCJQ0q6epRJOdVh0NFh51kNn--

--------------wvSHft0BOYReDcApDrNx573m
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahz5mgAKCRCGXBN6rc5S
1jORAQCGOr1TjpksEe8OoFxteeY6Lhd2pwtjIoqbKEIsaGxV/QEAj3/k3IhDOsfD
k7sm+l6niLNAxxWRQXpmGtcCvVeIngA=
=qI3X
-----END PGP SIGNATURE-----

--------------wvSHft0BOYReDcApDrNx573m--

