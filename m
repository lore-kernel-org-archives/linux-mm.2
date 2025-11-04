Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49613CCF9F8
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36C58E00DD; Mon,  3 Nov 2025 21:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EB68E00DC; Mon,  3 Nov 2025 21:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BB28E00DD; Mon,  3 Nov 2025 21:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82F6C8E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:42:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40B2713AA37
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:42:04 +0000 (UTC)
X-FDA: 84071374968.28.A73CD2E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 93FD3A0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:42:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KouVxNdP;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762224122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrRYu9HPjwo6Pe33SVmq+ZaNoNPIIc4e6Jwj2agDzxE=;
	b=EFrXPdbEafe1jJQUC4gnejbgogz3eJDL/oPwSfUvh8uunQiITbvhmvDPm431icRURVl4L9
	e+1E/ueIuYY9wuHJhtmPSYOGosxDpMf7xks5SbRyo5l3e6UoeEZti2p7ixoykW8042OZR0
	BKP0A0PdagZ7rIVh93bkEYVd0+nAlFo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KouVxNdP;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762224122; a=rsa-sha256;
	cv=none;
	b=shHa0fJvM/YLXGPsAQwXCnkwH3Avv53uu/JekAU3P9fGn7lNb7A+jTQYlYFx0VdMHRi1mI
	Jn+CGjC4c0GaJUCD3ApnEG2Vd9Evldbz7qnpytFRLIdLxeQDxO4rBnhfbSgI6rEFYGEb+5
	Be0BvkXxAdKKtsl3GCKd/t0xDIx7jWU=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762224121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jrRYu9HPjwo6Pe33SVmq+ZaNoNPIIc4e6Jwj2agDzxE=;
	b=KouVxNdPurpBVOxWme6zPBHls/q68AeQA5Y8ySWoarm4fl2KTt2rbydNlOk2fMPwySzsmB
	T0hdEeyr2+oEF51OJhMCfpQj+ZbUnqwxtZ2bWte6VKcMTgZ9mDHVVkVKkChb3Ok7JydrKR
	2NZ0Kzytx7WBvwUQZvKSPDmW4G7RG9o=
Date: Tue, 04 Nov 2025 02:41:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <1ecbb7b6b6c1cc85e9a52d32d968a2ad987a1922@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/2] mm/hugetlb: extract sysfs into hugetlb_sysfs.c
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>, "David Hildenbrand"
 <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Geliang Tang" <geliang@kernel.org>, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <cbee126b-5a3b-4f03-a049-2d8b86b4e5f9@kernel.org>
References: <cover.1762156954.git.zhuhui@kylinos.cn>
 <fa0fee2b8c2e54cb2437db44579475492c19e94d.1762156954.git.zhuhui@kylinos.cn>
 <cbee126b-5a3b-4f03-a049-2d8b86b4e5f9@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 93FD3A0002
X-Stat-Signature: s6f9695z8a3wpzj4zfdpmbq8w4x1397y
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762224122-301379
X-HE-Meta: U2FsdGVkX19gQZObo67WcZKO5/qiqk6oPDgZ7eQWu7MEGcOPUhw9b+H8yJwxpIY9MsSE5+mHUh/o00A4b2pd/SWlCIJUFAwWUBGOYg8nVtUQPZ+GfMy5HzhhcPB/V1PlUam2PKCXZ/i/7f0oyMTgLy6Cb1qN/7E20XbRuiXpRXlu+V8OFIIFvxrOXDYoAyBj1jAW3dJSjwxdWZD7pwkntbLIAf8XAvAe1Ik5isfCP6DncGx9AgjEmueLPHz00fIdsnnHCGKw804QkQetwvysC+4PKaw4eAft7gcZM5EjGX1H78U/K4KMn9NrEAAnbJNrT3L3D37vyxE2bnliHGqF4OWi4CaW15v4xS1FsUPEjUNBdnh2ZXkj5NOJGeSeb1oeuHqm6aLieIizQryLojVGF5c75wXMqiMeX836Jt4jl+INOTDGaZ55yZDMOZn+GjGw93/owKLwmJpSYWDoyUc9pbkLk8RHbFPi0Z+IdED9QH6W5CoKixqN8f+c+fdVUUaYxIvik0cGnNYnmvPMP+u1WZ8qXOjyBFndvGfdv1obGXRZk2j9RiRtNYwt+PRopYlMeIWGUT1liT5H2cIPNSXb1OqG1qukQNyR5Du5JG934NUqXELL1Ss/xwUqYp1L3MtqxkEenX0jqVasoBo8yLr5hz+btBOI1LQw9JTwZwDXv1eS0Nh1xYIR6MByq0BZhLcy+g+p/vdNGphpqgyD/94rBcdMx8n1ZwInTr253+17BFUySyofIRlCCSu2XWASRHNBYgTBqkjJGoIeKc4VraObe9pXfkNiuwBFqCjJC/5det5YWDCUtj+t5zZJuq5Bc4H1cJR+bzEnZ+v7AdkzrFxclpm5YeW/yd1opBmelvZ14BnPSLg1+QtBOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B411=E6=9C=884=E6=97=A5 00:28, "David Hildenbrand (Red Hat)" <=
david@kernel.org mailto:david@kernel.org?to=3D%22David%20Hildenbrand%20(R=
ed%20Hat)%22%20%3Cdavid%40kernel.org%3E > =E5=86=99=E5=88=B0:


>=20
>=20On 03.11.25 09:22, Hui Zhu wrote:
>=20
>=20>=20
>=20> From: Geliang Tang <geliang@kernel.org>
> >  Currently, hugetlb.c contains both core management logic and sysfs
> >  interface implementations, making it difficult to maintain. This pat=
ch
> >  extracts the sysfs-related code into a dedicated file to improve cod=
e
> >  organization.
> >  The following components are moved to mm/hugetlb_sysfs.c:
> >  - hugetlb page demote functions (demote_free_hugetlb_folios,
> >  demote_pool_huge_page)
> >  - sysfs attribute definitions and handlers
> >  - sysfs kobject management functions
> >  - NUMA per-node hstate attribute registration
> >  Several inline helper functions and macros are moved to
> >  mm/hugetlb_internal.h:
> >  - hstate_is_gigantic_no_runtime()
> >  - next_node_allowed()
> >  - get_valid_node_allowed()
> >  - hstate_next_node_to_alloc()
> >  - hstate_next_node_to_free()
> >  - for_each_node_mask_to_alloc/to_free macros
> >  To support code sharing, these functions are changed from static to
> >  exported symbols:
> >  - remove_hugetlb_folio()
> >  - add_hugetlb_folio()
> >  - init_new_hugetlb_folio()
> >  - prep_and_add_allocated_folios()
> >  - __nr_hugepages_store_common()
> >  The Makefile is updated to compile hugetlb_sysfs.o when
> >  CONFIG_HUGETLBFS is enabled. This maintains all existing functionali=
ty
> >  while improving maintainability by separating concerns.
> >  Signed-off-by: Geliang Tang <geliang@kernel.org>
> >  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >  ---
> >=20
>=20[...]
>=20
>=20>=20
>=20> index 000000000000..63ab13cfb072
> >  --- /dev/null
> >  +++ b/mm/hugetlb_internal.h
> >  @@ -0,0 +1,110 @@
> >  +// SPDX-License-Identifier: GPL-2.0-only
> >  +/*
> >  + * Internal HugeTLB definitions.
> >  + *
> >  + * Copyright (C) 2025 KylinSoft Corporation.
> >  + * Author: Geliang Tang <geliang@kernel.org>
> >  + */
> >=20
>=20So, you move some code and suddenly have copyright and authored that =
code.
>=20
>=20Especially given the cove letter says "The code is moved
> as-is, with only minor formatting adjustments for code style
> consistency."
>=20
>=20?

Thanks for your remind.
Remove the wrong copyright according to your comments.

Best,
Hui

>=20
>=20-- Cheers
>=20
>=20David
>

