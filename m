Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABEBCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D006B0096; Wed, 17 Jun 2026 08:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FDAA6B0098; Wed, 17 Jun 2026 08:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB746B0099; Wed, 17 Jun 2026 08:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D09046B0096
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:26:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57AE6166162
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:23 +0000 (UTC)
X-FDA: 84889327446.07.A6E99A0
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D9D1140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AZvroIyo;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iim+7rfRj3+oRPn4MTff3Qg6MkJBVhCqBNuI2UP5kD8=;
	b=YZ41Wqu/VjvIZdRnug9jkjObVyVnGL/LkYV+95+vFD9koMZhBaetho0qULHPyqJSCKTlpb
	edNVGCFXFuTwCbszJbVyRY2SOfSHy1EW3vsOHBOvynza6ZMR6a2Y3egt7NuZUR8oGN4UA+
	B+Yq6aw2KKDjRYtSQjpoW75H33+LOyQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AZvroIyo;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699181;
	b=oWirVoNF7r2q7tfWw1X/rnrYez2/crWf4oqSygk4Zm+NExfw33I2IQGmb663aGsQQ6axb0
	qrKY8Gih9vbXZwz+gCpbjs/YfPotsxEO+d0cdfwa9bH6sJQNdPCzB1h/NvWnpONCZpfkbo
	mx+IkXC/njd4x1nlqJUvijqNwAAtCYw=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45fe59255beso3223046f8f.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699180; x=1782303980; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iim+7rfRj3+oRPn4MTff3Qg6MkJBVhCqBNuI2UP5kD8=;
        b=AZvroIyoNqSHAGEkhwfcnQoGPkU8XcEWP8P2BmIaOKb/05kfMPy9qtft63sDD4dgWg
         6gwz2bbpMPH2vREoIJAyh/1m7tqo1cY4HK3KoeZduEmeUtTdGJBgo+iiPoAnDCW4CVcg
         zrYQW6MD/nDfEOnXOMWMUR4xsiskWCj8Clk4KntLc9Di5wURsHZR8NsH1g3i6I8bAR5d
         WdlNgMgZIzGIZ8P9gZNBsNXsIdh+i9vqv72BVxZW7OxFe1z+Cxdzl9pfwMgktyQbR8xi
         GI3b8hiHBtiroWf60FxuOU8RI8VmeQ9ZonjGcBnXcqD8a0vhRF4k+mB9fdKyuijzBX5k
         vziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699180; x=1782303980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iim+7rfRj3+oRPn4MTff3Qg6MkJBVhCqBNuI2UP5kD8=;
        b=d9CwPOzm+jEI1SQWwcyta4rPFtdvsc4frbolb/TOVDO4a4hSfcxu9c7RgLjzQrRGYh
         0rL/AZ1aE8lNPeFbykEd+qbUvBkBsmRkWzcN3i7Ge/fJk9xWnQPOQfPWV5nnGeW553M+
         g3yJLRDafPiCJxhmeb4canRuM8fuwx6p4pEQOfsjeYuZ2LcMbKDBSp6VVnb9J9DfKx4k
         LeONI9wxohtW9RaGp/Fk2yFgNpwis1/1dSF6W0gtqXGtsRdXoz8hh6g0XOR3cMucArRD
         3gzMHbiKEcBnDyJe6hLFTpIDjEF1ISvPHWru2ueOsSla1xHouIbGjaMBoKJUQohE8ULz
         fV7A==
X-Forwarded-Encrypted: i=1; AFNElJ9EhHWtEaGBYPq6025f2GnWOPrXUvI3ihL8nB2m79sLG1ky2OxnqVnMowLVJUiYb/IAmciMJZ/pSg==@kvack.org
X-Gm-Message-State: AOJu0YzqfvhfxXDd+Ni4Huy2h1QX89cW0fO/Yo1Lv8GIinVbXYsNQmNy
	7fKrzw1nfGrlK2QL1FnwG2gdqiRDpUznwZxPFa9P/zUj4duB/5qF3mviywAY+T4B2ok=
X-Gm-Gg: AfdE7ckz/KUw1O9aqkaBvev5hkswSZmt1LOyYZ6BS8IuJVeu9kdOjpgaVOefiQPDDSN
	RrmWcXa2VZRv7mJYgtGG6Phr3M09uS0Je5U5v8jY7daslBqDiq305RMurCnyVmQOFrnuliLp/lw
	zUDCfEgTiKdjdfEvMnpd4jkzKvPJW6obJ9Y77nlbkDxRnnWJF9MNmbUu3u5VyKPHqJwcmCAStT+
	dwDr+zYBVh7agK6F4ZIHdmzZ/VudH1ph50RuCEBEsFE33BKXczDRfHY6X5+29btumu48RFIOpPX
	h6kXRCX4wU2s1AUv6SUSLO8EfAT3WoOHDy2OT3w/Rn4e4xbDayI0lRJJPY1iUZTCVbCcYwUyylc
	3j1hYOVxF0CWA1FOCV5BmZ8q9E9uV2aLbg7DqiYieqZkwmXJS5xLcU3i1WUm22r5iFNA7r1MCAG
	7zhO254F6mgdvPR/rYdw==
X-Received: by 2002:a05:6000:46da:b0:461:a5a3:692e with SMTP id ffacd0b85a97d-4623f2e7e00mr4513543f8f.5.1781699179970;
        Wed, 17 Jun 2026 05:26:19 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c10sm53060827f8f.21.2026.06.17.05.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:26:19 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:26:17 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v7 7/8] selftest/cgroup: fix zswap attempt_writeback() on
 64K pagesize system
Message-ID: <ajKKABt0ZKO9UJTI@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-8-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t4tngv5chqbx2jyz"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-8-li.wang@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D9D1140002
X-Stat-Signature: hda3fny7t91o4ey3tp7m1j8c3g3jqis9
X-Rspam-User: 
X-HE-Tag: 1781699181-167064
X-HE-Meta: U2FsdGVkX18ivYQNTMzry1BGzOGsEDgjd2ZKukcEe2mPIdlirctw9NRFD8QOyKptlKU1deyf+ZLCCUBBIZ5S4BQ7MNuFEi55NfLUfHEX4b7Xfxl2c1IZ+ESufW+h4bHtdDYfPlnWvHghMFozFcBQ44qyoetamOMkqMryHuGzcPwTUcoQ2DVYlgayDWJShBd3TrP7duyHCxnGacsbzvFLdj4hT+rB8ygqf87Fl0nk2YQD9fwjRF0CFGd/sxuULw28e2B7wkF5gG/GHAVRggfNXA8yt1iPzjhcMfV+ot5jtJiya6eovr4UCbSmv8HIKMtLzMQEhVelxkQjbbu3qeiaPBkaaLasBJqwtgiWOZo/9vQa9YMoUHHm5lXECEx99gqQEyhIDOImpahMRKB2d67gIf8x+6Hr40+aMDt0oRL9X93cNWnMKW3eCs1jhpvLYTmm1RHrv2weIkoLL+E1tnFdREVVen/4gHD3naAyWdaY6eF+wUikYPUm8FNwY8O73G/vq94CdPdnRq4oI8E9tsp97/F/d5aZnijYwe2aB/2YhwGknkyRAkBcfrsVPSrtKJLcVqKfowDwXUFT1zSpf7wNM79TcR7TbPpr78jLoeSNinX3Sn9Z/WLqzOUTy4Zr6kCSX/1XaiYdRRJJN30laL26Q249j85JF+VKPCPldVQvmlVlmED+QS3mPe9CDazTHlsRkJYKAHj306u63kdCuOEoeJrG4pb0Atz1CoTOSZdHd8dKGQzvU0hOUgs+mnTEVt7Lv/millo8pNmqwBwkSMxhAJaHI2NvDfDcP55jA0hi0eONoqiBgFAlKwzFyAUsCJNyKQKKhM5pUQmF1Qd7EImislaoG70RASX35tT0AxToDeVJZYFiwN2r7uAoxZ/VxvUtHOj1akq8CAVI/iBVROGXjxo00vh0LscPBjD/t0B5IA8U5WC4b9/LK5D4Rgn7SqRo+wZ8ZwsrBMBg93f1B3l
 kv9NM9UI
 e+oKExyux3Oyza/3SvjFn2u8drpHGZ4dClsDGxpG/ahOdYOrQAA2Bi+YL5r9avwtO/mG5XPtQSuToRJTe69fiFD8vhzi2LmVAxXhuXatc3axmTB0D12gz/zyG/MXcYJzkcJ5vMcMRDBB9zQXXh+T7bdz3+ZosAZasoApbOCKKbrkbF8qGdhtqRS1WdlGwT/In7sBfu7dLlLY7mY4hOi9iHYPReyJzGdYvQtO4mnRlTd+Hq4W/F4S6UZ3CZ8bzLGLu3DIv6BNVqPGpUKw9mC3o06Jvp7tJO+W9cvSv/8WgWu3Dc4DnF6H765iBnsgqNTWu16QqIR3ygOqSmCKAuTMgJuIp/ORE6a8XTTo8UtXt7JH/PnDTRa5uz+F+1yMst1tR3qAD2B5Z9Ut2Z32DjUZTi9b/SDYVhrBT3K6JRHXPQ/0ukG5DvwSZq4JWn6EfUA8MkYalgURAU7Hzjo6gEr/UqF4rxzP1pC+XF2beP186t9wHClideZ7medDp5C29DZdUG8IEmZ/TnUR4UuGw7GcOK9k9o7NmuYMw10f7TfhzWu9u0xQh5rFkRpNqfpMT+oSO/jW5f7ogruzZkSvSuH596vJkJw7Ldnp4+Y+Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--t4tngv5chqbx2jyz
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 7/8] selftest/cgroup: fix zswap attempt_writeback() on
 64K pagesize system
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:58PM +0800, Li Wang <li.wang@linux.dev> wrote:
> In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
> page size systems. When memory.reclaim is called, the kernel prefers
> reclaiming clean file pages (binary, libc, linker, etc.) over swapping
> anonymous pages. With only 64 pages of anonymous memory, the reclaim
> target can be largely or entirely satisfied by dropping file pages,
> resulting in very few or zero anonymous pages being pushed into zswap.
>=20
> This causes zswap_usage to be extremely small or zero, making
> zswap_usage/4 insufficient to create meaningful writeback pressure.
> The test then fails because no writeback is triggered.
>=20
> On 4K page size systems this is not an issue because 4M covers 1024
> pages, and file pages are a small fraction of the reclaim target.
>=20
> Fix this by:
> - Always allocating 1024 pages regardless of page size. This ensures
>   enough anonymous pages to reliably populate zswap and trigger
>   writeback, while keeping the original 4M allocation on 4K systems.
> - Setting zswap.max to zswap_usage/4 instead of zswap_usage/2 to
>   create stronger writeback pressure, ensuring reclaim reliably
>   triggers writeback even on large page size systems.
>=20
> =3D=3D=3D Error Log =3D=3D=3D
>   # uname -rm
>   6.12.0-211.el10.ppc64le ppc64le
>=20
>   # getconf PAGESIZE
>   65536
>=20
>   # ./test_zswap
>   TAP version 13
>   1..7
>   ok 1 test_zswap_usage
>   ok 2 test_swapin_nozswap
>   ok 3 test_zswapin
>   not ok 4 test_zswap_writeback_enabled
>   ...
>=20
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=FD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--t4tngv5chqbx2jyz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSZRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Aho+AD/XAL/DakRMJXz9yk1Zazg
v5ZtizO1OMSuDPj/gKs2+1sA/iTg96YzL1efNS85Rz0XMUIW3UE34U/bKW2+nSp8
/SII
=BiG6
-----END PGP SIGNATURE-----

--t4tngv5chqbx2jyz--

