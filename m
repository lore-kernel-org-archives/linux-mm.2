Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0ABC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CA86B0088; Wed, 16 Sep 2026 04:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153B56B0095; Wed, 16 Sep 2026 04:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090A56B0096; Wed, 16 Sep 2026 04:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE5CC6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:46:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EC4880642
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:46:23 +0000 (UTC)
X-FDA: 85218993846.06.8D7F968
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0ED38A0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:46:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JUUdEWfW;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789548381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVDGxY7b9X8J5O6v3/wXzGtnmgPSWcVewApf2YI2SYM=;
	b=iIdHHBEUT8N/kZ2MJDjNn32Hz3eO3fNfmM4/GUM4BP9/R0zbqIXx8L+33/MhodPIxteQl+
	QcuUmvR8PyPDBJlDL1lsh/aelavuyhcP34UFc9xcQ9NOGf4LLjZvha0o7TUG3CnB9NvY+a
	jkjoO7ptFj+dRIX3kr11Eu8hQEaNKZ8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JUUdEWfW;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789548381;
	b=QRaXa71XzmjyPhWndR743vDdVAZXStfaydyGpFXvLYL9caajE5oDCe4z2uvPQiiQizyg6z
	n0IGpUTvq2yB9lV5WyWQ9Aytl4M3M8pX+pW/TFdEXdkG2PJxMaWMhtsSrOjDef7mUN7p2J
	pQkJkopMKse+7wWbcw0XyX9RZa+jivs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TVDGxY7b9X8J5O6v3/wXzGtnmgPSWcVewApf2YI2SYM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548379; v=1; x=1790153179;
 b=JUUdEWfW23EfHdz2R4C8Vu1w2tDUhNtLR+9LqMGFnEsF0CIiHffYdaljdrABaOleFVIGhBtY
 OKEQQlkcerBLNxOkLcY9KtOsT9mw8g0pHGcIEGdvZ9VL7uRowQRWRVi0K901UX9lwJzWkpugtmO
 Gf8lLeC8D4inkpO8CnjiVj8w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 93c2e6536672d7bf;
	Wed, 16 Sep 2026 08:46:19 +0000
X-Mizu-Trace-ID: 93c2e6536672d7bf
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] fixup! mm/sparse-vmemmap: introduce
 CONFIG_VMEMMAP_OPTIMIZATION
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260916083627.2145779-1-songmuchun@bytedance.com>
Date: Wed, 16 Sep 2026 16:45:57 +0800
Cc: David Hildenbrand <david@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A2BDF6D-96D2-4771-AB3F-7E702B01FFF2@linux.dev>
References: <20260916064341.1825793-2-songmuchun@bytedance.com>
 <20260916083627.2145779-1-songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: bo44x1i7mtcjgz7ao55h6arjjpsyfeod
X-Rspamd-Queue-Id: 0ED38A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789548380-514793
X-HE-Meta: U2FsdGVkX1+0mdqrG1J2ahoK0jX2XF1nIBBdAPdgzOXFsPHDunrw65TYFs4nMdytjnz/jAVw8+M315evmO5O15vn4p8yiMAYaeVwf/3CQE/l74w2Ib6ask6y0xb7lXJ/0KwAoEbpSDocKPD4stXpAEj1YT2ZAjbjkH5veuVI4cp8MJb4Xczm6bd2q6k1P7oj0oElGf5E2lx6c7V6moiE9xE4L4FOjJtJMIEqTNBopYnzb5Bo5koNxUuPjdJ8dq/tew97sOEx7gLm9BYXOqF7NuYByPun1tgJozdLHBRBPO7PhUZIKsht3fkVWvyLV0Uj0FeUaysUPuyB+fJ2WpUKS8XGYzwe9JzHpfTJ1i58wcorwmjhh/cTkkXu7n2a0pshyvLQ1isfrxtPTPRnBpNjQmHN7RGpyoJkwz+MDUYCLFUiDirNAe3OY3FkP3HsHVKsLTERfn2uFaajix0MWWWTd3uvUQlQWKc6cOaVWS+YlXu14iFs+waLA1Op8FF2tfVmuBOAB/K75136Higwnbm3l68irhP3dVayR6kdHwOEze54bn6UxFeT+1pFWm6dLfyCVSaIfXuzvGFlgQyWohkbsZnWn+VBqrUqBWt2mQIgCqO1+41qxL/gJWmbEjRMo3eTarXiqY+h3bVdLaIbit+75gtabt1INMQwI9cRhNACrL5SYrcNUaqwJ1WXaODE6LweWwICCL8fPvM9DVUjoPlFQboydXvY5o9vDzjBqSi24z/8tDeBFdZbsR3kFw5LlSasleHh1scoIKAs1B7DEY/qChhq3fVv1/KXxNz80I8vpzbxSNIJ1eFKc2513z3K2VF+aGsVS7BvpZXGI03jJR6qrLFIOsEr8bzCWWtxeCCrUHcO0mXjAUzNfqd0SmZ6MjELxChljX0bdtLaPFzwlXizw4p8dWNXyEaJCIwciFMimDlOBFTb3Tg2MFRRDz7y7OSgjYa1QL555KgbJjBYWnj
 zYzDRjTc
 wNS7t/hanitOtGRm53PEI7RdAJ3hqJvIRltFfxSBhb1Z/l9hd79OVBWC7fcDQOL44+OwaiXaK/gdkpwmWkJgXN9P3GQEvJSZUFmKowZbJnvZ+v7yz5AGMfkh4RLEl33UcUFTy6ZWCRhaFPrmkzo+Ay3KVI4li0+Xnsxi+bLKFOCfTbP0FhKFTVRE3xpwOYJAKYxYV1EZpLcr27UQUR4+ylRgzaCPxdR3oJCaGWZvpFmpZ7BjhLHu+sJ0rrLjJ+2aehwHDi+KXwTqIN2DU8TeOY+yO0nM9HxTKLoRZzBrydaK6NK46PsmQWzMwBGQ7hG/cFhexoeW3yRPrOq1K90psvjlsZm03iQc2KOpBWFebkCWbRxVURlQUMlX+YcaZiEScN+DoaU8x308BmN1oDMAxneThETyplQ8sSy9hvwMOyn78n7iONCdw5g0xiwFJ0IAdyWUVagw6OoIe0nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 16:36, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> The section-based vmemmap optimization infrastructure is guarded by
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
> ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
> CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
> infrastructure.
>=20
> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
> ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
> and use it to guard the generic sparse-vmemmap state and helpers.
>=20
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> Note: When folding this fix into
> "mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION",
> please use this commit message for the resulting patch.

Hi Andrew,

Sashiko found a configuration issue in patch 1 [1].

MSHV_VTL sets a non-zero dev_pagemap::vmemmap_shift for VTL0
memory. However, VMEMMAP_OPTIMIZATION is currently selected only by
DEV_DAX or HUGETLB_PAGE_OPTIMIZE_VMEMMAP.

With ZONE_DEVICE=3Dy and MSHV_VTL=3Dy, but DEV_DAX=3Dn and
HUGETLB_PAGE=3Dn, VMEMMAP_OPTIMIZATION is therefore disabled.
__vmemmap_can_optimize() always returns false in this configuration,
so VTL0 memory uses an unoptimized vmemmap despite its non-zero
vmemmap_shift. On common x86-64 configurations, this can consume up
to about 1.5% of the mapped VTL0 memory for vmemmap metadata.

The report is correct. The fixup in the parent message moves the
conditional selection of VMEMMAP_OPTIMIZATION from DEV_DAX to
ZONE_DEVICE. This covers every ZONE_DEVICE user that sets
dev_pagemap::vmemmap_shift while retaining the architecture opt-in
through ARCH_WANT_OPTIMIZE_DAX_VMEMMAP.

It also removes the DEV_DAX dependency on ZONE_DEVICE that patch 1
added solely to satisfy the Kconfig dependency of
VMEMMAP_OPTIMIZATION.

Andrew, could you please fold this fixup into patch 1,

"mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION"?

[1] =
https://sashiko.dev/#/patchset/20260916064341.1825793-1-songmuchun%40byted=
ance.com

Thanks,
Muchun=

