Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B4D606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QK/OdnK3
Received: by kanga.kvack.org (Postfix)
	id EAD016B05B4; Wed, 11 Nov 2026 17:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84C96B05B5; Wed, 11 Nov 2026 17:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1966B05B6; Wed, 11 Nov 2026 17:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA3976B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:15:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 476CEA042E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:15:06 +0000 (UTC)
X-FDA: 85424244612.08.B900040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8B901C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:15:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QK/OdnK3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794435304;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rWa3fKy9Arj7VDl0kL/ONlqwlXF/miTng45hXgpW1w=;
	b=bh/7FrDsBXO7ym4FEeQaUL8DDh/mtOT6/dzsjPxPjZGwWh5V2D44zHSzcnA23e4ciDsRxy
	qiQx8IzC5h6O2tnTk2m3vnHLyNkD4ChZWnWtp1OPCxcuDe8jD9/wOMf3skMzmCLjbtIFuX
	omP/t/XQpF3PZHYJZfQX9Skda30V97o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QK/OdnK3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794435304;
	b=s0sgTNOYlQyIq+RLEa0hZP1Q9B3IpSVAUsUxZ2FpK3+hoz4FM63uzWuUSr9lfYuSA5HXcg
	euhNOdI4z9oTMSJhk7wrBgP0NORQv/AJZEuat8MZBa6VKxpQCnawqEZa1kJFzBeccFEdIc
	eOkveYANfNkvyIX+KVqNzbE+0yucg8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B248141AB9;
	Wed, 11 Nov 2026 22:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EAF1F00A05;
	Wed, 11 Nov 2026 22:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794435303;
	bh=+rWa3fKy9Arj7VDl0kL/ONlqwlXF/miTng45hXgpW1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QK/OdnK3HeXslVYKT0LdfX3ipfDdh7aBE3rXsIuOuyLXzCd/u09thXLxrouVnx3QY
	 uTGPiZtndJLonHc8baoIFFXy0BphdAvjqJJ17wYLSDXR9G4zzgA7pa9lExhpC6EHZ4
	 hCwb/8R34KvjMjECsTam8vSSgj0wEbJDA66kT8+ve2Ewry23zo7746dkEc3lkzRTFj
	 SQFw2ZOSgHRTAfiobcjqKuxGdJ7N+orCcD3olMQ1VmOCT45jCbnMgz3C3WV6C/GLBa
	 GFaSPjcR915Q05nZSZI0/YvJ9X47IHrqLcvRj1E0vUKsOZyL8OXq6C4OAIATLFyv2S
	 +u/v7eyn5rECA==
Message-ID: <sashiko-outbox-209775@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/cma: simplify cma_declare_contiguous_multi()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Frank van der Linden" <fvdl@google.com>, "Ivy Lopez" <skunkolee@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, linux-mm@kvack.org
In-Reply-To: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
References: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:15:02 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8B901C000C
X-Stat-Signature: udpwdany3nndikbnrw17ntjzrpkz36ch
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794435304-689147
X-HE-Meta: U2FsdGVkX1/rTekz7EyQR3zzDTUyyeLwNzxKBlhvFdnXwSuMbWPg/nMaO9Sbp+Og4TiR+xbSvipcQ+P33zakXXBG3S+4tj79Nd5X56RCXsIfngfE3Ig0of58fm/SvgcJHpvDZclsLaUWgPUwhNUTe49/etf5ThCMd3wtpzC69AkYwfs0MIZKRpz3djR6NHY8orc2vqFUKTRZpFkeRSzZhlHU809MnLiQG2aADFyTm+9UR4/aeos7aUQMY90Vt+020/wIcLEzj8RI4dGiDaQ65WlUN80QTeXzyVV6B9jRTDepEq3lXPJ3BJtXp81lDtpXnF3AXqRgZnjvO4Dm4VjU7sMt9SZeU6PgQ6fTrzkI4l3UahIlilQ+4WtSM/3z2DXSPlhPaRPwPOmL0lw8UeCHllPHaM2w8TWYB214mEFFHVAo6k0HsNbPEh6hImWc+IPUgDR1y5XOJmRMfm2krdb6d5V57WspeUUFSD+Qh+vbnjM/o/tSDspS69OITrXaTtWtcOJssrlyoJaVOPSuRslJlOdPNyR4zVDj7Hog0lDCFxLnMKI1fFYosOrG4ArjjFKaSF+qdndowY2TVsLvkSECuj8E19N6aicBPGp74V7fQleafO9vBg3MwL2F1ElJz6ccUCw14oqazxSmWbZCOryh8x2XaZaxx+NVqQ+3mW4m8uETS+KA71kNDBakqmxopHD47WuSYdLxlv1flBADPbVKbBi/TiUhtf2K6FUj7tDhZfnz88njl3EdAkfoghMh6irb4FyqYcPcbmz6jujSEZJ4dFfYVQ0DIHt+X0/zIZjkKhcOUrNpOamxG5PQFgBSltFjmMzoHRiZTx5bCQL8gigA66viIiSTk4LK0aKh66E0BIqcd7/BXeHPu69/+VCzKPjOIfuxAhk19xzQFPDvUrTBmwOTTkRG0hWVdoZnz55E6/kz3jadh3SrB/Ct83f99zf5if3qJWaE/NJ/m8xBE6h
 m4ru+Cob
 Y0zInFDx3ZkkSZ/cNW+g9MyxG4nDVXTFHLk/VuCJ6SS0UTsLx6wNeo//lI3tZiImhnJUMqaRPaCgyfzemiXqjMmtk+dwO9TlEOKHCgoDsqE6DCofDJ+zv7uM8GylBHMVxb1AkDkEus6ou1sjD3WbbZ5xVvqIRx8DwLvLBEGW8dQrz7QQhP0L2E+elOurzbze+745AvKfTR9zerVzfjU5e4V4FnrOn9uM8hHLz99AsbfOUKrU7S/Lqbn/vRx2Ral6lc7FS4bogassBBy16cDNh1zgGzJZ9H/Hp0vLSDn/vILO3MGdvUwdTI7Ro6CYowQn5767aX7Ytb4uLYOSkmYC+PWGtyXAs8YfrjXmxejBaqWml2wnDLusI7KLA4YTd0/YDw1rtKybnNvUBQsZ1Yolus+kyNPemc8vTPgdsHsEFbJ8oswlmv50AnEPq6gNkWOhemIfIOLdkFL9rIZg3Hn31VawfPSNdT3VO6gTGs9e3TuDe2rjZ6eXRG5Jq7nrUjK1dpEi4mpxPSPPXSEzTMLR+fXnkT7/eFUbDspFkIPXGcYn0hmGS7NSo4ITyFF1KhHpjy/YwPwzQpE6m3Q95NiFXmK+gTmhELCsfTnyp9a9Ci5rEQav5O1tHuobfLUUsLJ8STpBgU2f57elE99XQlf6R692meuuRgoFbqy1938M669LmCMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/cma: unguarded 64-bit SZ_4G comparison in
  cma_find_free_range() on 32-bit
--

commit c3ad286c7568d10ee09caebdcdc606cff727c93b
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

mm/cma: simplify cma_declare_contiguous_multi()

This commit replaces the linked-list range collection in
cma_declare_contiguous_multi() with a loop that repeatedly reserves the
largest free memblock range above 4G and then sorts the resulting ranges.

> diff --git a/mm/cma.c b/mm/cma.c
> index f61d52796f4ef..f01850d13799f 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c

[ ... ]

> @@ -524,37 +474,71 @@ static int __init __cma_declare_contiguous_nid(phys=
_addr_t *basep,
>  	return 0;
>  }
> =20
> +/*
> + * Find the largest free range above 4G that can hold a part of a multi-=
range
> + * CMA area.
> + */
> +static phys_addr_t __init cma_find_free_range(phys_addr_t align,
> +		phys_addr_t size_align, int nid, phys_addr_t *basep)
> +{
> +	phys_addr_t start, end, size;
> +	phys_addr_t max =3D 0;
> +	u64 i;
> +
> +	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
> +		if (start < SZ_4G)
> +			continue;

[Severity: Low]
Does comparing start against SZ_4G trigger a
-Wtautological-constant-out-of-range-compare warning on 32-bit Clang W=3D1
builds when CONFIG_PHYS_ADDR_T_64BIT is disabled?

When CONFIG_PHYS_ADDR_T_64BIT is not set, phys_addr_t is u32 while SZ_4G
is 0x100000000ULL.  The previous code checked upper_32_bits(start) =3D=3D 0,
and cma_alloc_mem() in the same file guards its SZ_4G check with #ifdef
CONFIG_PHYS_ADDR_T_64BIT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-cma-multi-=
v2-1-4e2dddb2a2d8@kernel.org?part=3D1

