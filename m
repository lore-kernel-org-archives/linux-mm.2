Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39570C5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 11:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF20E6B00B4; Sat,  8 Aug 2026 07:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3926B00B5; Sat,  8 Aug 2026 07:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90FE6B00B6; Sat,  8 Aug 2026 07:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF1726B00B4
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 07:11:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19C6440329
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 11:11:11 +0000 (UTC)
X-FDA: 85077835542.08.CB5B084
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2E30F20006
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 11:11:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QuRt5K12;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786187469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NmdFAeTsQg4CtPClUPsiHvGEtBOt9fIz2/ykVtgMMg=;
	b=PJDiYgKejLSccWYq+sNqsB81lVBpizZYf2kvsoXfF26ugV1WSfvGz5+0PKLODqt9FVDNLI
	pU4Kl0PAMI+9pBQbTtNwTP6JikthUy6r4lsvrsyrnsPZS4ivOARFm17Kgiai8ieerTde2p
	b3F1Hkspk06xGqTyCIleKmJ0ZuUbXkQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QuRt5K12;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786187469;
	b=6ODn5GziOnik3Cdh/Upu3ANfSPtBDZbJQy9E3IKxVZs65WKLWe8TdRnprqZ3adkKI3cKbZ
	DwCACHwS98UphwA1HvUdYtyTZuacJMmzE6CsQRA601eN72R7TBiH/tRB/ZvjE3IwSfgM90
	28LHPLlDffv83qauFX8QGd4kEJJ8Q5s=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2055573c8cso37433366b.3
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 04:11:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786187468; cv=none;
        d=google.com; s=arc-20260327;
        b=S7PgdK9nvEkXsQzJZ45vNP+Yik229zajx4Yn2O2LIWyNnBvz60gIeT2zoo4BviFhua
         qqI44PHAEJUb8d1dMVjqvSL0YtfKCnVKoDd1RSc6zTf9F+iNV1JREVk4QsFGZcj414sz
         LvAIut500YltcRO28VOADNYSU3PUQFryh5lOPTDuu7/7kDR6M8ZqipVC0sI+XDAkuXFh
         xoO96A/zyQPoxR/JmuDUecCJlDsikdhJGzOSs2g+/YwAUWp+V/e3FyDIuStImbrudNxg
         4/TJbeA920Bwy+t151qYc+RNNXBnfiI//S3J0JITB3XquG5+FWP2nCruXGoCXvP5BFrF
         mgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9NmdFAeTsQg4CtPClUPsiHvGEtBOt9fIz2/ykVtgMMg=;
        fh=KPvv4AXUX+yulIU1HuYn+THvAw1KrUVPZrTw5MLE+C8=;
        b=GZM3nkSbAEuC2G1+tMK/u5MQ2TnQCdd+o8wF6rGNKusBGN6Q8NaV7iZK+DuUuqFTnH
         3hVN3zpvnmLibebjd2hjUGiAnyVLoj9MYCsOkPS3XDjggg3Ddifm/eRhrLCeUOouEA37
         tC2BwJDe3GBQbyimL+H4nkwgYOvNUC1J2DWTJLEjKQWhotf83M67Imn+4/nkzSKd0LTA
         zzCuMBDd/sNj58G+vfKM4BM2Pr0VzKgx1zeSybjdj6PKMbt5fJhYNKyHZvx9D0LNmhdP
         Af+mO11FhXXEDmEW/RVfaNJVRRZEOmCSpeAsad7WybN51cWWhNLWcWBXxfPStfrSxo2+
         csJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786187468; x=1786792268; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9NmdFAeTsQg4CtPClUPsiHvGEtBOt9fIz2/ykVtgMMg=;
        b=QuRt5K12erIyBFI9s5NOSne2WMCAUURv7hgk016/i7xY0C04r/I7QCtili1y5nS8bp
         mw+naLg7ItndPz2xb++yEDVSWRmwr8swiEwxuiF+98m7XCFs82c2+whUHZ6pkZ2GzrIa
         AbWJMJ8LcxMMSlps18LDVW0o16Rn13gGHt9BppvBXuatXC5rXleCG1l1UopfjfSYTOSj
         7/6VQnVl9r0KiKSaA7igsAdR+dDwOtoX/P9xulaOgILjL1Gc57r8FUnY0eGYoOFRfSsG
         IamwgEETFvuIBpLuvs7geejnWqOrtafvxeylUcI8s0o93lHv+ABKYnNX8k7dhO9PU9M4
         pk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786187468; x=1786792268;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9NmdFAeTsQg4CtPClUPsiHvGEtBOt9fIz2/ykVtgMMg=;
        b=f3jjAXeugWAQ73bv4jlEdSEDu3YrJIuoMB0eyy1i/ACu2NTuu8NIgSfgpnJkFDWUVA
         c7ZtMA3zofFf8Hdtcf59Wpzw5iX4A6QNL9yd/ezTO5iGiIXexYv4WG2Aq9VYmIu2WeLp
         Syk3ce0z7SpbQ3wbeqhGSYSKXnPa3R841gXuqsEa7EYLTwIVMUECnb52uj3bZSV70RiC
         0AlZv7+5N4MUpYdxnWnHtobHkNQaHj+A2TdkWM0mVQRpbyKH3EldCs79XSyz5cpD4R+f
         maKNftLUQB3y1tCvsoERsZK7jY4n0/QpIbwahKZxqFf/4bRkTSUtWunLXMQPSJwLyfha
         LqcA==
X-Forwarded-Encrypted: i=1; AHgh+RqxdzEiTVVla7bxDcaxGP0wf6fylDiHlVAFvSZKwCwyfD+NHj9NlcRUKvnIdvBEEpeLqopa7TZTvg==@kvack.org
X-Gm-Message-State: AOJu0YzLClOhJrQUZ+iuOByTXWD+XMCSG7JzTpD73npw+bQ9d8QJ9QV7
	d426M4c4IE1qZM/8rD6HOlQaLbLisSIC/GyAC4//ip20qqBRMCc7oPSyyTaMBX/RozLpJsZ6AiT
	Nf9L98gdrZLmYZayBaoFXfUkNsT0w018=
X-Gm-Gg: AR+sD11sHCVCP3H7fjJ4b1DFcZ8ffzotGd3XiDv6yGXLvJ5KTpMbGhcU5/+vOAbA9Y9
	kEDKMxMJ1yUPc58VH9ciV4Mo33ob1EwS/2J+06NlTb8mn54lBVOV4Y9Kt9zFPzttayoJlhZQY5J
	o3i0PAaYapO/kfHaIXG33y7RxigsFaY1kM3CCG9/SVbIWmO0sYR3rVbaq+7j/U9CqxzH7nWcJG4
	XbdZwocPT4CX0AiS6LPmfaEaGlGDCzpUjVWXAnCdclPZHtsS3AlAOP+b778kyzE0IDl647jOCYK
	FeJfqhxSpzM13FhIyhIae2ZDt/oY4bwHfw8uP2qZoy5dWOGjx8QJQujn1KtaM451mWeoArrWUFl
	o3Q==
X-Received: by 2002:a17:907:6b07:b0:c1c:5aa1:de57 with SMTP id
 a640c23a62f3a-c2039b7e997mr1550154966b.13.1786187467198; Sat, 08 Aug 2026
 04:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in> <20260805-b4-mappingless-swapcache-v1-2-b1d78ba257ca@zohomail.in>
In-Reply-To: <20260805-b4-mappingless-swapcache-v1-2-b1d78ba257ca@zohomail.in>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 8 Aug 2026 19:10:30 +0800
X-Gm-Features: AUfX_myclkXQm0J9pgU-SRUEwwOPsam-5qTNU3TDb54eeVu4YhzblVp-LJ_uYWA
Message-ID: <CAMgjq7BW_n3HpM=mCGn=q90=4+oXcBLWwZewxvEcwqfzjuewOw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: add KUnit coverage for mappingless swapcache folios
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2E30F20006
X-Stat-Signature: detqrepptidu3kyw8ka11zbcmgwycuq8
X-Rspam-User: 
X-HE-Tag: 1786187469-339216
X-HE-Meta: U2FsdGVkX193sEpUflLUPMBNHpvZImd2V+LvH3lSWr7y4RRFNwOekztmQLr8K/egVGrARkCyA+Rqe/oyThl0oVvSDOWpm8T/fbAD10DB+1sVL0Qs4e9RtmClwyZ3PtPrOv/tFCmU54cpsbcfDxEfLIuqXFlgispAglpPfoooETx2fL+lmdb8S1D3bax0vHHAoFNzqyGorh055ulWuk/9LtiRmyPS/2y8jVOHfsBhUvzkWdWk/0T8AzPZfQUwo7Ej1A1jTnGmRRR+48Tu1KQd+v1MImUY+4XsKL1IOAQaAKZKfFOrSk6u20Jy4NJ23jKkozWAqatB3VF+F/DPCAfFkDLrzRMIdQEEpMKF8f97iCFgK26WrTq9MKjPdF0o/ZGelrhFEpN7Pod3+V9ObXjyW5nrTcAjjik6MRrGxo8m5xturAJhkUcaZmW3wF4Iw5iyrLDmAfK238SruG+/FlZ3R8p+W5Jmjo7OLuWz/QW4OiNJQsdKA4TA6j4k9A5SrDCXGFdkHBFcyuHJRdGzri5q6Dl77O5ScsdZ+e4Ew9PTL/wJvlQU1paSTsT68KVbGG3KLPOT8qUrdB8rF1ioDmCR+2vfOnzdL5F4rSEax3iEHd43O2GYHRcDT2k035G/ddYLw0wtJJKmatgciqiL8Sd7LyIKzMVC7aVqNbFjWI58qJy1Q1anbi3Gwj2Lfa1pJsDLFt7+B7PegCkGG+1ugVZsgpG0ZER3KmQcBQovcbneP52XcUYLHifCqn6PCtoBZKhmU0sdjTA7HKmpYZIZqoAEKUwOXK+8Gm5z6vr2QhsyxjYFEWdvwxZmDg9qXB2gqFMseKAhiujYQ6uZA9GwU+H3/BYH1bxIjC0nwbsffOiWKO3zVtbLQmwksDO//aNysYfaxQ/U0D6r2XAfDljzy4kjBFrSRM0tOoD2IbQXvnrjK3/bGjGitFWWL+KcB5wqH+WdWARV17KsBH2iuTQGrEq
 d2ZZrHTS
 fW3yEjRASKCt6ItRItgoVg09WpjXLplkO+Pt7l4FXfkyEIqTKCp8f948PYrahFA7Q1ejN7WEohePTNNKyEoQxiCr6pcXGK85qBEnpC8oPr1oRKp9Awz408jtklpCia7b1feq2LrRZ5j4jjyWN/w8pA7FHxDrBjBv3RMmqIpY8Kzj7Ara+NNvcVDn+OG50bNVpOjg3O4TVqBbc26cgj3ZALJYeN/G+4Nksoqm+4KVX+UNhj8+UnWICFi+oZlcpKCA5HdOOLpxvOAASrqgbc7n7Geb43oaciRtsmsQpfNZcXAztLo9q3yGqyOmbzF0F1syUGlZ7akJYGhy8voP0bm7urT1YqX7/nJa4XvaHicH9jsckvX93i5RFqZ8Te07khx7jz22j0fHyAeZK7nGYDdPpXj9p38Ylet5vu6TxB5cBDKVwO86RGefplTrMSkoAo4Sbg6W4Xb43aS8lo27QuBaMOfhmcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 7:24=E2=80=AFPM Shivam Kalra via B4 Relay
<devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>
> From: Shivam Kalra <shivamkalra98@zohomail.in>
>
> Add focused coverage for the folio_check_splittable() eligibility checks.
> Verify that an ordinary mappingless folio is rejected, a mappingless
> swapcache folio is accepted, and unsupported target orders and split type=
s
> remain rejected.
>
> Build the test only when KUnit is built in because
> folio_check_splittable() is intentionally not exported.
>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

Hello, thanks for the patch. A few concerns on this...

> ---
>  mm/Kconfig                   | 14 ++++++++++++
>  mm/Makefile                  |  1 +
>  mm/tests/folio_split_kunit.c | 52 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 67 insertions(+)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 331daf7fcfab..164dc1438900 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1503,6 +1503,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
>
>           If unsure, say N.
>
> +config FOLIO_SPLIT_KUNIT_TEST
> +       bool "KUnit tests for folio splitting" if !KUNIT_ALL_TESTS
> +       depends on KUNIT=3Dy
> +       depends on TRANSPARENT_HUGEPAGE
> +       depends on SWAP

Just BTW, we already have a tools/testing/selftests/mm/split_huge_page_test=
.c.

> +       help
> +         Enable this option to test folio split eligibility checks. The =
tests
> +         verify support for mappingless folios in the swap cache and ens=
ure

FOLIO_SPLIT_KUNIT_TEST seems a generic test and not limited to SWAP,
but it relys on SWAP, looks a bit strange to me.

...

> +static void folio_check_splittable_mappingless_swapcache(struct kunit *t=
est)
> +{
> +       struct folio *folio;
> +       int ret;
> +
> +       folio =3D folio_alloc(GFP_KERNEL, 2);
> +       KUNIT_ASSERT_NOT_NULL(test, folio);
> +       folio_lock(folio);
> +
> +       KUNIT_EXPECT_PTR_EQ(test, folio->mapping, NULL);
> +       ret =3D folio_check_splittable(folio, 0, SPLIT_TYPE_UNIFORM);
> +       KUNIT_EXPECT_EQ(test, ret, -EBUSY);
> +
> +       /* Only the eligibility check is exercised here. */
> +       folio_set_swapbacked(folio);
> +       folio_set_swapcache(folio);

Faking a swapcache with folio->swap =3D=3D 0 looks hacky, could go very
wrong if you do any actual work on it.

> +
> +       ret =3D folio_check_splittable(folio, 0, SPLIT_TYPE_UNIFORM);
> +       KUNIT_EXPECT_EQ(test, ret, 0);
> +       ret =3D folio_check_splittable(folio, 1, SPLIT_TYPE_UNIFORM);
> +       KUNIT_EXPECT_EQ(test, ret, -EINVAL);
> +       ret =3D folio_check_splittable(folio, 0, SPLIT_TYPE_NON_UNIFORM);
> +       KUNIT_EXPECT_EQ(test, ret, -EINVAL);

Hmm... you are just testing the gating, not the actual split, that
makes the test not very meaningful I think. And we should not block
non-uniform or high order split for swap cache after sorting things
out, then this test will be doing nothing :)

