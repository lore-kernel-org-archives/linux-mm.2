Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A9FC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 05:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FDD6B007B; Mon, 27 Jul 2026 01:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9436B0088; Mon, 27 Jul 2026 01:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AE26B008A; Mon, 27 Jul 2026 01:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC436B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:27:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CBFB1A0646
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:27:16 +0000 (UTC)
X-FDA: 85033423272.30.FAE2060
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C76B8C0003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:27:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWqTKUIx;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785130034;
	b=chgFTHXeRWqfO3a3M3KDjHsguRqWKJJxWpqMqA3ZJhSWN0SjWKuT+Cc3I4eUj9baVTMmC3
	sFCN71Z2lhw0WJRW3zZHMPWWqxfwY3Vb9AItKmrDq7A3Q4RsGfrZ8JHUVbbKgykzq7hzQX
	7O5cfy1LWvNszz5nhhC3HX++REAbqYM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWqTKUIx;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785130034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVA/NNYdsuPgHCUDwB9PEhO4cYzv4F7N19ZTGXmYZDg=;
	b=PMz7BMBFzWdl7Zh0KdBKCivgWQZ08ifOrTMeL9jkUqbz6in35MAS8SjJ4hIlUvG9uzkq9H
	2+mF9hBoWG1tZmxrK439KfyiKFJjGo0c/nuJvOI0sye1eybdb8PLyFW5VZYzFgfFUXHZo8
	gL7kELe9vVu/zLBRyI57Ahhv7Xqll04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35D96600D8;
	Mon, 27 Jul 2026 05:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9005C1F000E9;
	Mon, 27 Jul 2026 05:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785130033;
	bh=oVA/NNYdsuPgHCUDwB9PEhO4cYzv4F7N19ZTGXmYZDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FWqTKUIx7fvkaNfJuxwYLaviXUAmc+0i4pYIzhvSiJjaQUsKoYI+QBeLf7vapRZj4
	 DdHWipu701yPe8otwDl3q5AICGZO1pGqOWj1DJt4HNUp1roAo4TeXDJMY5xruJM3aR
	 6XGLywmHswX5ObDOq4iS0VpMY8t6fJulSeqxuStpH7+w5ZgIfq5D0eTPjuQo2Afem8
	 fdoTB96QYhD/Lo8xrpap3iU+zZf8RruF64tLwPNZYyOEQL0HNhO9oestVosd3aU9UL
	 bvgGUd2dFm3NA3SGoxaLTM7kS0t+xCMwmcAgUubopycXD7Mxsba+cpNjMpSHluEYCX
	 9B3Jwogvql1Cw==
Message-ID: <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
Date: Mon, 27 Jul 2026 14:27:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
To: Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9mozqhDtuIztOvktzuegbXKT"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C76B8C0003
X-Stat-Signature: zm4xqygm3g5pbtwpj6jyz9pxfbyhiu63
X-Rspam-User: 
X-HE-Tag: 1785130034-796932
X-HE-Meta: U2FsdGVkX1+fTuVrn355YxZhTxK96zNkfALtDjuuTZ6po6M/JettuEY0QFCId7sgD9FKsGLgL4OAF3OmAQE+Fbt2zBzx3MJCyeH/9VGVA2fsMeCu3a87bxnPSAuViIYM/60Hq3lr4V/sjyrGC4BHrV3ypt1t/QXniTG/I4L1GKEunlwQ9fYY+umAbvvwulQs4FDfjNxFRpY4pYa3Xk2v+M9Pp7r2qMPZ9Tvju+eM9+Tt8n7uEzY+jgNi1FeVjWQsOsN1WYKffn/tVx3vwO3Lf2N4e9S8ForcictXL+7utcG/qzx9avC5JL6PrA5SA7I4rM2OXW55ogAIco2sN0osMfKbynOgtUZjbiy72oqiidBdunpEyljbrwkMf+WP/pp9K4T2ou+swaI6fJ/wYKtmirq4zZVtU+Ro2wttPJIyTRulD3ra9RwYMGxzEEYQDqUz/+e38TdQ/De5LFU37osUYZk3xUOCMF/BBpqZPF09eMeKXvMFId8YH0787+4jIxvfR+VN6VZUvLf2fBG+DnUaaAR9/a7TZ+zWj9am7WsKqP2VhC6r5SOgjuIfG9gDk4+o6krFFGszqVPt1fsFK2moHH7ea2RkWym7KgkzD9ZbvQt/HrzN+Y0YWfFnmTTMZHErJPF3C/4o1Znrl2F503Fdwdr4e0i0iEyVrwSxBAFxN8F0JjEKKOLW3QlnwcSOqzIuTNNwumWssHShHZ3dCNt5aUCVXGPT13T8qHyS96Gb46L0FG+KcHHOehrRspAv9U6qavyt9zrXosB4B1V38r4GfNQcM/EKvUuxY4QXhpByWXF/bpR5dc1Wvm7W9DDzNrI5Ae0R8FwGcVxSi+Qwz0pNvqlY+P4x1rOGEnmjs1MMUJrbdQdxhtCdSJiWz8n4JksSft9ie3zCRUaEqbqmx0kxd+dOQX54MYH9lLuE6NGGKnCIG4i2akxaUmdkzHPkl7QlpnCWy3QM2QX/f1JZTn0
 faT9i3Pd
 3u472S3LiV/9RVLqAgDAn+xAyJhV6GlhTcsQ9OTZaUfaWiMP3n2jNu3U4PPRONYdnfhgTAnoB+V66dEhPJFIeFJtigIvAgyFGBb0f1H9w8/4BKll6bR8eN2TCBqqJlc/b/QDEN/pGC35GCohjmB3ws3VIDsixG1WhqCHWimyA1ZlbRoEJz3SLrRKG/2YM/Ag9Mwm/N64EMyhQdvQVLkaQGcpqtFRyO+96YyDrF0segG2hvKjxjO1slH3cVzwhS0iSU1DHYM5JR98N600kFsaj4Q/AagN3rVbRkl+GsbJT88Kze6zdaQIaeOSNDLjdeAgORc+7wpLPfLK43gg3ck/+CHTbcWWgCRuBHLxhY/qo8Y/gn/B3BDFwWpaBWQa74CX32qyXtd3TyBwed1IIOtddHC8nov58JJlNgTEBkw/h1xQCO3xdJx8IwTjS31/5FcyOwNF1bFqJnPBh2wTCsHbdQhjG8cMoI6C5M5aF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9mozqhDtuIztOvktzuegbXKT
Content-Type: multipart/mixed; boundary="------------0RF9p6X1VzAAEHtVB3a2VyTS";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Message-ID: <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
In-Reply-To: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>

--------------0RF9p6X1VzAAEHtVB3a2VyTS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
> Sysfs "ctor" file prints offset/length of the cache's ctor function
>=20
> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
> 	init_once+0x0/0x10
>=20
> This is not useful:
>=20
> Offset will always be 0 because ctor is a function.
>=20
> I'm not sure what ctor function size is doing here, it should be in
> /proc/kallsyms
>=20
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---

I'm not convinced that changing this (without strong justification)
after exposing it to sysfs for 10+ years is worth the trouble.

>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, ch=
ar *buf)
>  {
>  	if (!s->ctor)
>  		return 0;
> -	return sysfs_emit(buf, "%pS\n", s->ctor);
> +	return sysfs_emit(buf, "%ps\n", s->ctor);
>  }
>  SLAB_ATTR_RO(ctor);
> =20

--=20
Cheers,
Harry / Hyeonggon


--------------0RF9p6X1VzAAEHtVB3a2VyTS--

--------------9mozqhDtuIztOvktzuegbXKT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCambsKwAKCRCGXBN6rc5S
1keOAP0ZTE44GEL6TYup/N/dpog6IGK3XM79r1A7avfK/lciywD/aynKyrIByiuJ
JVQ9vgakiQWXj7eIyWk/omYg4kejowE=
=msGf
-----END PGP SIGNATURE-----

--------------9mozqhDtuIztOvktzuegbXKT--

