Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD333606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 10:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4lbR8N0
Received: by kanga.kvack.org (Postfix)
	id 5426D6B00D0; Sat, 24 Oct 2026 06:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4C96B0A47; Sat, 24 Oct 2026 06:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B256B0A9C; Sat, 24 Oct 2026 06:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC81F6B00D0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 06:10:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C6751402FE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:10:14 +0000 (UTC)
X-FDA: 85357099548.24.4797904
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EE39120004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:10:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4lbR8N0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792836612;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qgehlm3V4UJV7cOXKEXEiEGSmVT8fEVlyR9MaWXfYxw=;
	b=KFOKWDFrN2W6/bEY4WrePrv40VyJvbDx3WALag9x/tRPHSU0KICTNWUaVAwtrlqsjELDpi
	wTcznrbgZMdruxOdCplWHlMO5cXALooK60CPZD/Futa+8pliov3kz30Vd7dXUqW/xIW4dy
	2Z/e8oBKManaIqUUYIVu54vSsC8Bqdk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4lbR8N0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792836612;
	b=lyr9FPUPUqrLMojdSOTMi96ZTIeYMD6Hxb/SoLumvmquzIjslVFQ0tvId9SeQsXtqrujSI
	6SnmFDpSAD8Rl8IWnKppy+FQkSDEyLKw8ryneFyKuML3SXppmQsYRtBiXvSUUInuumfBQg
	TnULEnxW/FPRm6e49z0KSH2WfsOLpng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8501243B0A;
	Sat, 24 Oct 2026 10:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091E51F01825;
	Sat, 24 Oct 2026 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792836611;
	bh=Qgehlm3V4UJV7cOXKEXEiEGSmVT8fEVlyR9MaWXfYxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4lbR8N0Vozwo4KgcMPHzxa1MYef0s39IEelwjHi3lhvjVM9Mt2Bs4VSFNSODTKtP
	 w6J8hWGbUa6PDUqIohPbuvWLVw6P9gIep5jDt2WPkyzn5gB/6+ca62eywagGJnzSAs
	 Lf8ncemPi8u227xOQCPgn3io7+9vtizOqv/IFxg80v0mmfWHGjAC/K8m0GvC7b+8/J
	 eVrKz6tWgIQNrTl4U47ZMcglqykqSnhxqJBSldV2mG4qQ801jSXibuIK0CYlc1jAoC
	 BUtf6PMEn9Mt4558EL7dqtEzEYi49L4ZcK+ccivVpGUb4/7Ue4ybEsUSI8aPYfsr0d
	 wbCv6MI7YWQxQ==
Message-ID: <sashiko-outbox-183640@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] docs: hugetlbpage.rst: clarify HugePages_Total in
 hugetlbpage.rst
Reply-To: sashiko-reviews@lists.linux.dev
To: "Enze Li" <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, corbet@lwn.net
Cc: linux-mm@kvack.org
In-Reply-To: <20261023100859.70744-1-lienze@kylinos.cn>
References: <20261023100859.70744-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 10:10:10 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9EE39120004
X-Stat-Signature: gzdq8wtey1tch7dcy6hzp7r54qkshqet
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792836612-441897
X-HE-Meta: U2FsdGVkX192zZw/jKdKP0RKaZhmPNX2J7P3z8yK7PpmsPyQoPwXbxPT1cLvtIOwQW4tQI+D6j6pt8mGggq6b3ifQAxw72l+wV3MYMlZNGDbyiNfVrxSfeK5xjpFhi2ZwnFFPtn/dp0Z9WodROmZ3hFGNmQSGH5raJNWq0OPxKmktwFBiLUcXsSQOIoWsiHWdxOHQaTsKIFIKGdvHadIluh9HYObFL1Z3kDYkQtV9Jxkg9VW7wY9pX8v0sUZs6hLCjY9nwU76M+4fjtJkrS9bdwt2XXqaGoSeyN/dSPYhOIaGB/wS9hnA/wG7plRD+UvR+pMF59oxn2lDjLP1rzfKxB8NdyP44dsEc+rpqfriEq12JN7x43EeXCFBoNLu1LiNCdmFy7AlgWz4qWkxHedMXZC9O5I2Bwi4DI0BdiX15pgrtJVnLKrBKA2utwLd1CDxTS8Ubfn8Iz9OsK8GCEGkkUGk/n6Nj9Yz7imSijyHrEQMDt12e9eBOzCxZkeMNig0KmbF7uVtKM12XHANYTKPoP1vGEdUhGbpEIi4fLA67UqY0X5lAm19zz+gDgRkPA6gKO2+XQcGdc37c0CvXlIGfhVr0no9ZzS41J2g093P/J+cOCaLh7j0jqsnU/3yocIBB7/ZA2EeYdLjIC3Y42/IqIaiEwiRlXAAPD8DkiSSo6N6otmS3TJikAJ/40cJycVgq26Ns9xaoUuVa0TApDT1t4Bm4F7u7alptnQlsOWLHHjNKegW23pvPp/wjPgQCWMd2xHuESo41kYmgE4mu1ozrpdNMzDauMgXy+JvRwLBwFMPaGmSH2FixxNrlU4RJcQubfEjT+YVjTkS0N1wz/wcAP7sCVJca+mRu0NaQZlBMv3j790Y8AJd+C82HaHb7kfsOr7t0jUgjWHo1iEK02Bd8aL4xpiVC2YqKl6e8yISaNJcFU5TcKrWraYyk5HUa/1Hco4nMy4LosgjQAmez2
 WKwbtBbi
 L/1m2T4XHNmePvgBEmKTu8wOdTA6mp/mW/IxO+VbbRBxgy1lOFUYYnXt1QxEJPbQhCWdS8J2bBYOS1NAOPx3aczGRfItFyT56Owj2F+0G1L7KvffGxBsZDSVx1jCgQc1qvyi7PTUGKcOlCj91Y12FtYABj0qilJ4h/QEap5X4WBUE5WD4dH9l85ItF1j2ihCW2LtmP2H53MP4uHYYLtEfK5dxoToPMBoETXoSUkSO8zIhb+jO3kGzEvyeqzCJkzmlfwWr417oHA3AOGdBEDAvpROcm3rWEyfjcneGQsBHANdCv1Es3WwLVZHFaYeoXf2KdfMy3YohyblgVgHevc9FVhk6GNICXtw7NzMZHK1es8MclFGCbm9lCWNdJ3qJUlH/m0H3TZd28LMIj7Z+Cy9lsXOZ5l3RacGap4/lqwhAelzwV+/U2KbB9QMWjkHsfiIaLVVoDd3rIC9Ecpoa86MoUoTEw99+DNxSyNIh/1izFv4XWMyEAufjdTUxBs+kHSk4JUFtsyh9R05iQeSs6R2aHqk5vbTRQ86wf0O/tS+ChM9rWWT8E30CFZcaL6mqOelL898vOFydDHq/PLcDmT+LzrWRR+Ax/1LG9SkGIHWSV5hmEnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] docs: hugetlb: HugePages_Total falsely documented as persistent pag=
e count
--

commit 7d6d3b965cd5f08c4d5dcbd9da32baf62e0f76e3
Author: Enze Li <lienze@kylinos.cn>

docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst

This commit updates the description of HugePages_Total in
Documentation/admin-guide/mm/hugetlbpage.rst to clarify that it reports a
page count for the default huge page size and points readers to
/sys/kernel/mm/hugepages for other huge page sizes.

> diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation=
/admin-guide/mm/hugetlbpage.rst
> index 2075f1f14a421..01fa9f61c9a92 100644
> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
> @@ -43,7 +43,9 @@ The output of ``cat /proc/meminfo`` will include lines =
like::
>  where:
> =20
>  HugePages_Total
> -	is the size of the pool of huge pages.
> +	is the number of persistent huge pages of the default size
> +	in the pool.  Pools of other huge page sizes are not shown
> +	here; see ``/sys/kernel/mm/hugepages`` described below.

[Severity: Low]
Is it accurate to describe HugePages_Total as the number of persistent huge
pages?

In mm/hugetlb.c, hugetlb_report_meminfo() prints h->nr_huge_pages for
default_hstate:

	for_each_hstate(h) {
		unsigned long count =3D h->nr_huge_pages;

		total +=3D huge_page_size(h) * count;

		if (h =3D=3D &default_hstate)
			seq_printf(m,
				   "HugePages_Total:   %5lu\n"
				   "HugePages_Free:    %5lu\n"
				   "HugePages_Rsvd:    %5lu\n"
				   "HugePages_Surp:    %5lu\n"
				   "Hugepagesize:   %8lu kB\n",
				   count,
				   h->free_huge_pages,
				   h->resv_huge_pages,
				   h->surplus_huge_pages,
				   huge_page_size(h) / SZ_1K);
	}

However, h->nr_huge_pages includes both persistent and surplus huge pages, =
as
shown by persistent_huge_pages() and alloc_surplus_hugetlb_folio() in
mm/hugetlb.c:

	#define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)

	alloc_surplus_hugetlb_folio()
	  account_new_hugetlb_folio(h, folio)
	    h->nr_huge_pages++;
	  h->surplus_huge_pages++;

Should this say "is the number of huge pages of the default size in the poo=
l"
(or note that it includes both persistent and surplus huge pages) rather th=
an
restricting it to persistent huge pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023100859.7074=
4-1-lienze@kylinos.cn?part=3D1

