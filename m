Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F60606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 08:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T9kjE2z3
Received: by kanga.kvack.org (Postfix)
	id 8450D6B05B1; Sat, 14 Nov 2026 03:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5F56B05B2; Sat, 14 Nov 2026 03:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CB26B05B3; Sat, 14 Nov 2026 03:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED986B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:52:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66D831A036D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:52:15 +0000 (UTC)
X-FDA: 85433107830.09.28A80E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD84E140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9kjE2z3;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794646333;
	b=pHPrUK2cNdySYH46jzsFEDXo8LC/ZFM7VK2AwnMoAPBfvYXOZNH70lM8HguEweY0igMX93
	12KqYpPqnFxwwJNye+JzTOnH68heSscPDgJIE7P45sg9XsyuS1nKGyIoWIzOXfOOjPO1WU
	0jN/9cqyPU6XmOi8HURh/MX7YdOuEt0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9kjE2z3;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794646333;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n801CWK50YYUQgpOSBupYxzrf81B+wbefMwYPdevCSg=;
	b=m0ey5pSyO9Uv8KRebgIqceVPmdThHqRz0xPmASfWjzn9co8A+dAOCCNusGWpx6vSEA3ik7
	REJ7ltZk0daiaPdCk7vagrzQ9lHfN7tMtX7NMBFVZdrEEAq6dNLtbqlmVi/5/guDDl3AyW
	p6v1pESOQVo1sCUC0tboD5jPmlVHxXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEB6360018;
	Sat, 14 Nov 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D751F000C4;
	Sat, 14 Nov 2026 08:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794646332;
	bh=n801CWK50YYUQgpOSBupYxzrf81B+wbefMwYPdevCSg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T9kjE2z3T+hwGZ6az+GpRGeCt1mPkQ87WlPxm5X88RB2irZeGcshvb3BXsJU8kkTq
	 UDefcpW3ZPrUkfq+kYo6f4rMWQqDtmDiYdijdJXtwo87M5JVcrAp0d1IXpYv43RWqf
	 iUqvTvZaMpuyqYHaF1kwEscMxhPcN/kYOv02BG31miHlW89h6tP2rKIY9TnQa4txTv
	 +6ltxO/XpaG+KyzIOLdFjO0oA4UY9Hkb+b5AM2i93B1kcQX5TasevvMNLAOZmlvA7P
	 uyfastz3DypNZXSWlCdIKvJZGSYselarRu/pJ7ZCstKNTacLCV1XUH76IsGFsQlkMj
	 sTnF6PUDSPCGw==
Message-ID: <sashiko-outbox-214306@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Kees
 Cook" <kees@kernel.org>, "Marco Elver" <elver@google.com>, "GONG Ruiqi" <gongruiqi@huaweicloud.com>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <843f0f05bbe3ff36efd22d490e83b0260f8d2f81.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
 <843f0f05bbe3ff36efd22d490e83b0260f8d2f81.1794506262.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 08:52:11 +0000
X-Stat-Signature: f3ia3wrsthrrux8ipjduoq1nwc6g15w8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD84E140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794646333-614401
X-HE-Meta: U2FsdGVkX19WB3LS52xrAlVesd/l7u2Dau9qG+xk16i5hVcdFa2q10Seyo9XyW0gQ4PC6Ptdp/A3bhjctvi7dyP4ji5j9fJX0GRiMVtzrc6ZPe0MAp6Kv4VVbzqjQxlIKxagySGeNc3jze3dj1DLpy2NdkJBBw56OoGN2NxK7/0Ono7cZtMLT3QKmXF+2Tv8Iyl8YEltghtXEdA2TjZGhoXHCz8/1DekAE9rPmougD+yTw9GWkeMlz49ixfhJKE7B7LzwK0chaMNShtDZftHIyT4g+yvd5tt543PKcEFSB3gdAWh0amQcfDPX+LJdELhgraDHTvmhxcPlt6dOld1nxgIwtDPZVrYyttJqcjHOWwCK02gdV9dbVSlfvD82eNJS8r9Hqm6JJQ/5PTh1uL36MTZlothdIipcVWQGRgQRBGv08hF0qe2pDMEeAgigdsBynSW2pB7Zq5loGp60EsGf536UTb80pzl96iRhT/50G/IPaVYUJaQcf6KbRCYH9NGWJxQ9DgqAI+p/1J7mRJsAaD27mOZtjwcH2VcUOt1q2JFyf5V2wotgS9w1iBLtJJq79QZfb8dp85w7iCoflkm8HJQyN5mZflRiZspxY9mlZ8UDK3z4HG//+B4UlwO7FC8czG11AstBQST+TM37f/3g1Nfk9CBVVN7OtXSSEfcFkOHCk348gFYBX+cFclqBLF1DLMMGB93A7zARGt489rMXuZSWKmmSjX6JyJlPx6g8MGzP3h0/iwIAiRxkSK+z1QAuRVxEk5zPXKQXsvIM8BxgTlPZW0ysv6FUEyRYneC1eN4ozAxk6pjBHkkEoLF9rsBZWX80BC3YvKp4bwkjCaXEn249gQoCn/4zn8OI7aVjXgv5ajAxt4hQ/VI0UrubDNeAwT8M9uSyfEhbqL8xeO2ZS8kdxGbJKqZWaIsBhI+VDwjyD/XLeSdodLwZVHZRBMK5DErMinL9w4BLcP/rBI
 jjY+/jDT
 6Vvp84omEwuGWLrOQuthHbG2I0tQKUwv2HYdtgB0nBwhV1YPBLpL0aMtvD0r9KjDwuUPax8pj0p0pZcGprcWjrpktVCpLlfaAm3lyB/JELZ/4QjfMKnO4NhrosihPueb8Et7sLYE1wULFKjvyiliuqw3Y+WCWmj+8K5VbNuEYX3AvqbdnoojeZVlDy5X63s+nBBpZX3fKaD6DMHu92tKoKz8qg8sYNQg5GjciJQ1CsfaXC6RBZrXBdYK6WZu2ZTvp2lW36pTaTzUsQxIMSVh8QaysaPUTuFgXXmMT/HWtamQa7epbwSk5LTluDroVU3mYvPIcxGYFpgR3OvY5utQnt5PT0hww5MxenJ0Ir03u8XLX9sEKCV2ak5q1wXOSLUpV1eX3ZVpDXwBLFfHuuBUiEgqAQTKfmB9tFNiLKQDNb/7sTYvcVAnEg40/gXjCsDspOxq07V3O/Vafrm/WZpZWkQCuOgdaXl5oICrz2MHtI1k+F7nkYhGteRdXvvEccHjfg0XSwQQwhvjMK1KCG9cUkRABpUA9UK80HpPh2XatFQvyS3uZI2AU/X3SK12g+kWX2TcKL4S4R69xENOCjF6ZYE28fq0Zz+BRZxNIQ4f/uAdu0R4b7Z3QR0Su3ZNQLXM/Kx4K
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
- [Low] mm/slab: setup_slab_buckets() adds per-feature knob instead of
  slab_hardening
--

commit d1769f1af5f0bdc819b4474cbb49e0bbed23c8ff
Author: Chris Down <chris@chrisdown.name>

mm/slab: Support disabling SLAB_BUCKETS at boot

This commit adds a slab_buckets=3D early boot parameter to allow disabling
separate kmalloc buckets on kernels built with CONFIG_SLAB_BUCKETS=3Dy.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7f..272d22f411c2c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -410,6 +410,16 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
> =20
>  static struct kmem_cache *kmem_buckets_cache __ro_after_init;
> =20
> +static bool slab_buckets_enabled __ro_after_init =3D IS_ENABLED(CONFIG_S=
LAB_BUCKETS);
> +
> +static int __init setup_slab_buckets(char *str)
> +{
> +	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
> +		return 0;
> +	return kstrtobool(str, &slab_buckets_enabled);
> +}
> +early_param("slab_buckets", setup_slab_buckets);

[Severity: Low]
As reported by Harry Yoo on v1 [1], should boot-time slab hardening controls
use a single coarse-grained parameter such as slab_hardening=3D rather than
introducing separate per-feature knobs like slab_buckets=3D here and
kmalloc_partition=3D in commit "mm/slab: Support disabling
KMALLOC_PARTITION_CACHES at boot"?

[1] https://lore.kernel.org/r/auIN44CnAyzvR_Ll@thinkstation

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794506262.gi=
t.chris@chrisdown.name?part=3D3

