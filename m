Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08601CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0A86B008A; Fri,  9 Oct 2026 02:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82216B008C; Fri,  9 Oct 2026 02:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D983C6B0092; Fri,  9 Oct 2026 02:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B165E6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:09:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4E41140263
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:09:37 +0000 (UTC)
X-FDA: 85302061194.09.5D66465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4165020004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:09:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWkN5Krl;
	spf=pass (imf03.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791526176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaXEEt+6oUYTgk3yLziOOP26vbiRye4IPhhc+D5Un/s=;
	b=roqEGAyo+sY9tYP8F4I/175qG9pPhveqOLkZy/Cxli79mEjJAJ3l7CtlrDMU1d74X8oTOq
	n9OieP1scRQfGg9jycmzoT9Fn5liIYvdrMkh3pDAnblIyCnAVdCFu0BamwPTMxryogniMD
	0OgCh9QtvP6ON+UgRHWx4/oS0Nhc+jg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HWkN5Krl;
	spf=pass (imf03.hostedemail.com: domain of bjorn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bjorn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791526176;
	b=WrGlZ5OfAcA4+lY5LZvgL7lRmMBhqkFVqRhikY2mGsZDace2be7nQSqFq4w7AIFAp6tWNi
	OIjH38PEq6MSWyEDGpk2L1hSnF/S8r9NjwnvV/sgxGH2s+lc93HVTE18jkJhmVFy7TYkLU
	1wmXjdP+ZImKg6Lqpu/G3LA9IG289cQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 879AA602C3;
	Fri,  9 Oct 2026 06:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7FE1F000FF;
	Fri,  9 Oct 2026 06:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526175;
	bh=HaXEEt+6oUYTgk3yLziOOP26vbiRye4IPhhc+D5Un/s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HWkN5KrlKIk6OWt38SO9fMGwArGXNLm8Sc0PCX7ZgeMYOylWuJpHNU8t2FYDltQLn
	 2hKVTP6VzNHCqHXVINEqZTs/LUesNwkJVsuSfNVRWiSG6EM+asdu7XUYpBPEPDbhyg
	 xxL2L457nAJjsnW9ul382bkmFZlkcJ0BfutYNMatFDZqAAKt4pPj7uICuTiy4ojVEP
	 ugz5q4KFQCUm7kDaKATbRD/9S7WIDuKfPfrxc0hLnTMVOL+lI7sBSP7t1MeAxfaysa
	 lqZ9eoh+QQZamGuMRiYovi7Gku403d6K2cuOnrn5lClA+St/Yv/3lziXSu4nT82KA4
	 ZsIxQ2m9QprXw==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, david@kernel.org,
 osalvador@suse.de, dave.hansen@linux.intel.com, luto@kernel.org,
 peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH 2/4] riscv/mm: fix hotplug page-table destructor handling
In-Reply-To: <20261008073021.2512665-3-songmuchun@bytedance.com>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-3-songmuchun@bytedance.com>
Date: Fri, 09 Oct 2026 08:09:31 +0200
Message-ID: <87jynrs8v8.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4165020004
X-Rspam-User: 
X-Stat-Signature: ukmpcfqmwmeysoumbxesx84idwu7dmrn
X-HE-Tag: 1791526176-964676
X-HE-Meta: U2FsdGVkX1+MV93XrgD7w8Cs6NU5t7J3tf/NTMrzZcIs/xx4n9Ih36a4JmXVNhnCGDIit8gbgntbpT1p7BLbywaOaOsU4Ux6IT6V6FF6jWIq8NMf0aCQwCE8zkm/rjoWnxAX+IQo5+n8wid4WenNWcEuQLcnOjpST9Sj75KqxBGcZzRZLztlkyK1eGKqLD1yxbPqirw6sgZsDW/Q586Rx7xXPwXWWEyF2Fi1Q0ORDlTxVpRlMlgG3SrkncnMwJ/Hz+aB1VgJ2LNWYFfFI5camzjGtFwu0ePhCJgtbOyTfpn6cE3Cd5gPPjQnao1MWPveEvaVNH8TsCaMeBG+l0Ew/p1et9CxoFKzOKwqnHDqk7x9a6EefhvxAPgXzg6UeDmXSm6bBPTyJaltyoOWtAvwMoPVaPOYOhJt9zT8Xk5r1GjAQgccQ6Kpu5nUaLASxh+oJQMity7Q+i7UNhCp12pEFPEXxGvI6+Q/sRfoKvgq/yWhaYRs0iH7OLTCY+HY+W1oXaysFvosRj5quVAM5x3JKi59TujieZIbbKHCNBKUdLH2ZOId8D9iM8w6d+aV1YJ0rieB3tIm4IX6c8PAipvfjtSiH+lOoCLfxXFXCSz36tC5SG+lu/5G3QzvW7+Myr4NPd5vKGI4AHBQZLweI922baRbW8f1CQLUv4eeUMg4nVgRGQdmgOrGnApuAHRDEdWG/T4cA0c4IXcftFaYL9S54fpJZM25vIZKMH/0wY7fyA35rOLEZPGOxyB2cTYXu/Mj2I4HRzouT8o7Fgs6IIeY3u8bQOjhhkwPJdvpPnMrmd1MhJkXTHxBTk7JoN2mKtLRbGhA78XAOL+1wVw8O8SSDTvr/YBFyP4/JyC9l2Zz7XSqzOpWH7TQF/bpJe1py/YDIfjSlZ72xpBS3f+H20gEU6qioKv7XKNbTsZCz6HOBnSA+EjxHNs15cz18TZsIq8J9BCazW7oJz5a0dSnhUU
 Jd5lhJv5
 CQpOn2tK3et15J2M1sSqEIefehS/4tzW/3jG+qBpOGW9A2PVwkK326XC0J+LHLzp4IpxxKYtHFwXfhNOCEi2m7HvOUvx5yVFNuWrwUDXdgx54/n2yxxH1aaI5y5fHGjkN0pmD3pbCz73yDn8Jy3uT20/SXJm7FpKKi1d3kd8aNZaHwoJYomKb5WA5zvZM0RBGSYuMVaGoMeN0EAtkK2C4u846Ivlh+YSX2EtGp9SDAIfaeBNf+kMJTKTtJRCMRTrHCq5QYk0w7C9UuIA+dn27lZBKts0efvCoLfBZGcQ247Gn/kHCxwQUK+BrG9L6OWiKtvayHtrRwld6XLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> RISC-V uses the same memory-hotplug teardown code for the linear map and
> vmemmap, although their page-table pages are not always allocated in the
> same way. Late linear-map allocations run page-table constructors, while
> vmemmap and early allocations may provide constructor-free pages.
>
> The PTE path unconditionally runs the destructor, which is wrong for
> constructor-free vmemmap tables. The PMD path avoids that problem by
> using is_vmemmap as a proxy for constructor state, but that assumption
> will no longer hold once runtime vmemmap allocations use the normal
> pgalloc helpers.
>
> Page-table constructors record their state in PG_table. Centralize
> page-table freeing and use PageTable() to decide whether the destructor
> is required. Keep reserved and constructor-free pages on their existing
> freeing paths.
>
> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/riscv/mm/init.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 857f9a55039c..429a0b015ec1 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1486,10 +1486,19 @@ struct execmem_info __init *execmem_arch_setup(vo=
id)
>  #endif /* CONFIG_EXECMEM */
>=20=20
>  #ifdef CONFIG_MEMORY_HOTPLUG
> +static void __meminit free_pagetable(struct page *page)
> +{
> +	if (PageReserved(page))
> +		free_reserved_page(page);
> +	else if (PageTable(page))
> +		pagetable_dtor_free(page_ptdesc(page));
> +	else
> +		pagetable_free(page_ptdesc(page));
> +}

Is PageReserved() enought to determine if there's no dtor to run? On
rv64 your code is correct, but maybe for robustness?

  | if (PageTable(page))
  |         pagetable_dtor(page_ptdesc(page));
  |=20
  | if (PageReserved(page))
  |         free_reserved_page(page);
  | else
  |         pagetable_free(page_ptdesc(page));


Bj=C3=B6rn

