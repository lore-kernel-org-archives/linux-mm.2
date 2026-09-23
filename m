Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF75C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD876B0088; Wed, 23 Sep 2026 17:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEAD6B008A; Wed, 23 Sep 2026 17:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C7D6B0099; Wed, 23 Sep 2026 17:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA22F6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:30:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36270140126
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:30:17 +0000 (UTC)
X-FDA: 85246320474.01.0E06ABA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BF20140002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:30:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKAxKVtM;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3tq9N0LJ4r7VJ+9wdwqQQlbn4k6qzBMuLB5kE1baa4=;
	b=IqOp92LT/BJjgklEpCjSalUwB2AD8NqiWDgYQ3ccZ9ZP1k8jKqd5xk33wEmbJY1Rb/hqWV
	5pTrNdh0zHWcW69pwwksJFioPeIuQI8mmqEQ/lEY4Vy2oYgsCjnhMi5eq7pCvs5Nth0Kf/
	zRPM76ci6DsCPxLCOkUmLuR4KyZ+6f0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199014;
	b=dKwVYQcJ1TV2DmNzwujbfjsjCcKWIJozY8IiizI8ijKSfs+kIbjaHUw+mr47y1uxEA9zR3
	CV7y4OQoAz4otk1L8iam92DYN5yQGsCV1Ml4M4fsQts21Pf1XPPbGxJqKbGe819H6rgfGp
	viJAMTt+DflMr9p30Gqs02QQpFg58yU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKAxKVtM;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AE124346B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4536A1F0089D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790199013;
	bh=d3tq9N0LJ4r7VJ+9wdwqQQlbn4k6qzBMuLB5kE1baa4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JKAxKVtMZbF3TD2Yn2zgDD4fLtybBqJ/igLQzq3NUT4r9bDACuqKvXjvgz60TR+JA
	 BIFmfFeaS555lQfbIUJsxtX1zQkAUve6IUQqNm7nLfx6uf7seZiMIvm9RK03R3nD3X
	 yIqwdSH/bmBuXrza+VBpZYbApAWVCksy8bFBjD49DyaS1W6AQq+JhF2QihqME55VXB
	 IJ8+SeI/dKeiSzaW7jniNvqm6j5i8qbdAiZMMHyUhEOvu3CyESGyLW7HUG4hOhAWJf
	 +n7NPspRkMseNo+3GfhH9oIjsO6FjECoNDaxM6ZpMUq4024vg6/mylbECDTlTHtIO7
	 kd3RiEuWZgBSg==
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93910ad2273so151266185a.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:30:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwH6UHMnm6hE9b/uVgLmm2t5z2oPjBNT4x3/FgpUqtplfJx8MuUpFl0o6yRu0YyDlVOygE2bI4Z2A==@kvack.org
X-Gm-Message-State: AFuF++mB9f8QnSYnb7Gob/aKEbB4GbxF1IlmnpCgywbVDbyBzd5CpcB5
	hjbSuCfc7tpEZL6FrUv1fn6jLvojfWzLU9BmB1ov3QCY6PO+Wg/ThVEx5t2erYNpcytYT3QtVCu
	5ACmk/LYTnO2/+u6vOYM5PsihHu7KEYg=
X-Received: by 2002:a05:620a:4707:b0:937:50b6:4a5b with SMTP id
 af79cd13be357-93c345836d2mr78355685a.23.1790199012523; Wed, 23 Sep 2026
 14:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-2-jiangwen6@xiaomi.com>
In-Reply-To: <20260923062832.479455-2-jiangwen6@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 24 Sep 2026 05:30:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xQhmRigaV_2G3pdOgk5mvC6HNzqCyUdRY3RSG8-QNC-Q@mail.gmail.com>
X-Gm-Features: AcwNN1UaTtV0wPc3IJY9Sx6rnYvw9-CPwWOiah8w0K1fH7hCcF4lT-foCe1dQ8M
Message-ID: <CAGsJ_4xQhmRigaV_2G3pdOgk5mvC6HNzqCyUdRY3RSG8-QNC-Q@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BF20140002
X-Stat-Signature: 71yfnbqsu1ft1ws3xqhuhsra7zziq531
X-Rspam-User: 
X-HE-Tag: 1790199014-804109
X-HE-Meta: U2FsdGVkX1/HhW0RMfENoiWs2LTyTkS0OsYgeTGfLpCqM77MA3Z3NJCBvHyeg/I80WIsVgFiKqEwluZE6ngvaWo1tZZbK/1iYOq8UMe0pVLuTZuuwrwbb80Bv7fvv1Zmnbsz96gYhXPTtQOFgy4BSnCtcvho+5qOYku8YrWyln77NUlluYnCuffNsPM8hWU4gS6KFSej66wGKYzTPSWZGxgMi8ST2Z5kz6NTW+7kyv2okL68q4YaXoTghKcvRljT+WDSM0c84kKTYFwBI//u5CD2E6F1dc+71oFr1JPqtfZx1ZU9VXCx9bhop//98PYh5WjYOKrgldvCf+UUR8g6sG8SzMN0Gvm1u9OQR79L25Uzwj18gjNjOzNHQWGPgYp7L88+S720nBKQ/aKLktc2akSwibYtbpBuxnWvW9ZcR4tAPBGvRsu874N8ShgYNyNMQQEqpCYQbYdtImczvOyvO83sabxg1s3F/hKTPiTdNXt2hD/6U26d2eHoGSGFuXIKDzlth5ptDU6fH3d7P+JqAur0JDps948/XyymozTzNpAESDdXUIYg0vL4L7VBoIdAoyA+ry0YAkNF+hggYXWQJi//ccnZ+PIPBfz4kw00Hrhj33zWVI3O4djjqgIUzEVgyZJNYDOTXKJE0IkDH+cKLKUXSpvtf80U9mKN6QRrkPDT8+ZYkb6CeYnzj6TlayDGv47y1u8ZtbDNQDddfAyqH24fzeFravhyR+PNp0lj4jHbXpp/o8xo0GaleBEDnsWGg0zjN36v+RUxPDszOdkwk3t1FCQsm4tgJgfJH96R6ol94/eCLO6lWjEIk8YZYRticms8DV4SELmEE8PKI5iuMLQr+Orc/wI+2zZ9Xu+xTAO4d00FNbIZjUeEmYWJh+POIs30A5cbX8gtShHekqHQhJP79ezf57LxZN4R4Ds380TUmqhE6f1B3dqLk2Yv7R9J884d90V0WIrJ9XVwwkg
 tgaFj+yu
 GY9x3CwyT0ujbN0iY6buUhlECX1qKz2kI2bSEXyn3sG+1E3pO5P6gXhhB8G1GP2YNY3yFInGyW8lowIMPw0PYoedHTUOvkX0UpSaulptAzOooxwLUipwrK3H0+LN9186vl06jc04kQQoiHAllhSs8zAKUOPw86RA5Xn1G19fwAbaGrzj8uaqOLwbhjrRyUVvDK0UOrxlY/HWLSGKtwimf+obgQo8qxguS5iKi111CCs15EUuZaWrejtgaI1E7sXi7eG0sqnjHbsghYxL9VMo+SQfIJVCq060FKPz3cj7B9bunGj6noLPYggBreKMG0vjgVC1djLW75lM10TqP08tioslUFkwpDMsclfkzgnCs9TXT51nMaQpirmxc7rRJ6X92XNt8bs41jPMYkIhm8p/eqfDME5YVbZ/EiMKHafwjm+Hdom8ZfX4cfYYUWnSqZSeIXx8KLaHokmWixuZLPJxcJIm5MloXfjNV4sCV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 2:28=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com=
> wrote:
>
> vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
> set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
> unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c t=
o
> HugeTLB internals it does not otherwise need.
>
> Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
> pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
> __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
> depend on CONFIG_HUGETLB_PAGE.
>
> There is no caller yet: mm/vmalloc.c is converted later in this series,
> once the generic fallbacks are in place.
>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

LGTM. Please see the comment below.

Reviewed-by: Barry Song <baohua@kernel.org>

[...]

> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +                 pgprot_t prot, unsigned long size)
> +{
> +       unsigned long pfn =3D __phys_to_pfn(phys);
> +       pte_t pte =3D pte_mkcont(pfn_pte(pfn, prot));
> +       unsigned int nr =3D size >> PAGE_SHIFT;
> +
> +       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
> +       VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
> +       VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> +
> +       __set_ptes(&init_mm, addr, ptep, pte, nr);

You have patch 4 to revert the `clear_flush()` modification from
06fc959fcff ("arm64/mm: Support huge pte-mapped pages in vmap").

I guess you may still need to guard against the case I mentioned in my
reply to patch 4:
https://lore.kernel.org/linux-mm/CAGsJ_4xiLScr2PrPu7Eem73GvPCtsuYd3J05kW3SC=
4QSs5Q4aQ@mail.gmail.com/

Something like this:
VM_WARN_ON (pte_valid(__ptep_get(ptep)));

Best Regards
Barry

