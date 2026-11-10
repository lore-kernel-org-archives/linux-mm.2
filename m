Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82570606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBOPaY/5
Received: by kanga.kvack.org (Postfix)
	id 9ABF36B05B9; Tue, 10 Nov 2026 07:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982CD6B05BA; Tue, 10 Nov 2026 07:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0566B05BB; Tue, 10 Nov 2026 07:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8FC6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:33:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ABF01406FE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:33:17 +0000 (UTC)
X-FDA: 85419149634.03.70FE9A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F51E40004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:33:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fBOPaY/5";
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313995;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjeCekHYebNn6LES8DOWNcBDejrpvpKExYEI9cdLC+c=;
	b=MxXUEd101EDv5logOjg8FDVzwF5DqYZI6vtMn4oF/3th678+xyaCWZwxgZ/J5GuqZT4FzE
	Xe09RqnNkqnXtuphXDD3oJGgTXh1DjkI1VU+B7VfPdkXzOj+sOqOI3cSKQu/e5hX6IWpnb
	yMTh36q4HLTmhxCo76f8gpEQjwaoPQI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fBOPaY/5";
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313995;
	b=4vATD8c6nge2QOOmtKvzYGycvTMUl6+XesqRyqjC5YkTKaxAFbRkFhj4l6Aj+TCDvNn9GX
	pGNrKZizClfhKibNJBxmtJQEG45uXheZ0pXnucMvcFoXpCEkY2ofuOuC5Fsh03fm1NclEi
	ml/8+fQKIjwxbL5gwqhFf2kXvtZwYXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4F6D43474;
	Tue, 10 Nov 2026 12:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89CA1F0089F;
	Tue, 10 Nov 2026 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313994;
	bh=YjeCekHYebNn6LES8DOWNcBDejrpvpKExYEI9cdLC+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fBOPaY/5IaZAiq7mLM6ed67fXtTcW0v7ouEyTGQ1PsCySIectesD3OdIY8kdK0mJc
	 /O/BJmxpbFRxNPzy6PV2lo9mc72rh939CPVw44PvcQedq81j2CTTpYWKffChwQH/wg
	 a9/vBi1555lQZtw0er+0C3TXsJ51BUXjn3EdsiJ2ElhmBDj2nSY1NFFtHLdJkStHO9
	 qzTQT0WCcJP2WcIq6NTQzCvgvAcn2ElisPsF0Z3XOf2ZagCMIMLRc9bPo3LfotvmUd
	 NXyluTxtaLEULnOh3IPcuH2FUMD3fwgfwUPFtCnnNn/LsPNv6uJejn+8YiAwJaT5xY
	 YWj+9soDtbSQg==
Message-ID: <sashiko-outbox-207030@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org
Cc: "Jason Gunthorpe" <jgg@ziepe.ca>, "John Hubbard" <jhubbard@nvidia.com>, "Peter
 Xu" <peterx@redhat.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Rik van Riel" <riel@surriel.com>, "Yuan-Hao
 Hsu" <aa9736195201@gmail.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-2-2aaef02df0e1@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:33:13 +0000
X-Stat-Signature: ytgzq4j67a1giapo6qqdphmkezehxpgk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F51E40004
X-HE-Tag: 1794313995-337425
X-HE-Meta: U2FsdGVkX1+Ghm2XcqzJ+4b0K8547odug8PEUREILQ58ElF9QgWZh8d17LOS9enb2P9kpSByn2A5YhHeS3Tf3626bDa/E7+EpqIrFIt9MjsCvYZLEhPMDcdJin1CsatxJlAylyDMNAkXoGWE7WNU6GxEMQJWJDGGe2QDfZPaqz3ZBPMAYhlFXmA4QCnGAQqljfk2Bt65FlwLuaGTYoyuJDjnUZ4NI/uA0QibRtmfcaaQdXoO9nOwgp7+a495OHmaB3mh/3hhWgp1CrMWRI0niugyeCbV9Rz1h6VmojeNR3mkaYkjEreRyRDNaoWM3H2QEjzmCtMSe2VnE4xxjLe5fRsNyXAlfctxXODjcmr5A4tOgJz7WFczqWxh8LIFpdF0LntLYJnkloOg4AFyS3O54Nb4cslC0IPzygsoP0p9SG7ALZs2AMWmOzS7keGhQEiZCXEVE3mwbS24YcjdUTIOf5/J18eghk0IuCCp/4cW2iBZIBWArSJx6uNmT8S3I0XELW7enmJSm7qc1e2Jo51sYH+0xqvW3UXCG5HbP7gaMKykcNNWH/ffIJxkL88ln6Z2QINZm76IsPTiza+LFL/JREmKmxduoGezSJsqet2EADKxJGZM0GX9byUluCotSxDsxHNxOLk8xhxBLDRDq+PZeFg7euJ084v+cDxXGM7lGTOplRZ13F7WSfV0RhQJhhUznqZ0g3WTSX7VaaY9beNuM7vIJLIFWEvhhqGlgsE3hUEbBIn/CmO3oY9MAccQmf51TI4a6ho3C4/2bLvvfGKw1kpg75wWIFPvGh+qGyB2T5mz6e/N418nGCENDaee6lBPwmcFRuugURq1Huo4yWgn/6Jhea0t8p6Uqu58M8B+Cnl3bAwh4/RF2CV4eQGP2gRd5JTO4WzmrUa+3VABUqasn6HZ7fWxFIi4X01cuAsmxLHj/5ePJfbG1u6hsc7P+0IOP+JkEaDRRXn19F/3tWW
 w7IWUuTV
 1u2mykKSF27s7xjAc9Z3pOI/bkqlzClvvg4whodcQH/C9r3GhccYgVMPDfnu50HKotr8EqRY8uoDEyNFnO3JzqkhUF0ehhSx9+TmbZBsKrI5ahqbXBDOZpCc8uXZZLLSAf3h2v/6yLH1jwI0GRgSOP5pLBaJsZOvugZ+96tGQpszBz3TKWvJESPUduV7xeE611DsH0e1+0L3hvbYsND75J3+aW+0WumKCaBC5Ei50QwENTR9eG8Ar4o+b8h/bZ3aFSc8Qgt5DNpKjllH1dPkkCV7kyQ/pm7HlGlAKuk6UuHxBeireyxQQrL43qFaKSDASNq9lwNTPO0DM7EmKWvfIQrJyT9L/LFcOis8dJO7JAw7iDQeKPupeCmE0IFOWcIKmsuz8M+KSBjmq+TBw48Lpu7Orqi+r8WNt0aA+6hu5m1MI6Yq/AlGfGCLvgGN7ptbULVPIvsWjMT1Nwo464FkTSqmH1dVbCkaoa6vUIz+TomkOlCLBIc+sBWHQgdHBBDbQFWr1V4QFzsjpS1Y+Rg1GVdrQZ8bBWHjU+sytjujFWOQH7JsKhECoMl2Y3U9bxBAmmAn/k56BiuZwGHH6C8kXzkSNffZmuEaSarksvQmlfhfA/vQFLD0V3mVyfCEbWBZboF4ySmroetFqjOXHqBpiCnBb2i8ZUScAooGgw+Qay5ZfPS8=
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
- [Low] mm: gup: duplicate comment with typos in gup_fast_pte_range()
--

commit a105945d4180d981c8509ad500ce443d7fbb662c
Author: Yeoreum Yun <yeoreum.yun@arm.com>

mm: gup: clarify a reason to check pte/pmd in gup_fast_pte_range()

This commit adds an inline comment in gup_fast_pte_range() explaining why
the PMD and PTE are rechecked after grabbing the folio.

> diff --git a/mm/gup.c b/mm/gup.c
> index 7d43ce717b246..7f9348c633d58 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2881,6 +2881,14 @@ static unsigned long gup_fast_pte_range(pmd_t pmd,=
 pmd_t *pmdp,
>  		if (!folio)
>  			goto pte_unmap;
> =20
> +		/*
> +		 * Recheck the PTE after grabbing the folio to detect concurrent
> +		 * unmapping or protection changes such as by KSM.
> +		 *
> +		 * Also, recheck the PMD: THP collpase can detach the PTE table
> +		 * while its entries remain unchaged. Checking the PTE alone
> +		 * would not dtect that we are walking a detached page table.
> +		 */
>  		if (unlikely(pmd_val(pmd) !=3D pmd_val(pmdp_get_lockless(pmdp))) ||
>  		    unlikely(pte_val(pte) !=3D pte_val(ptep_get_lockless(ptep)))) {
>  			gup_put_folio(folio, 1, flags);

[Severity: Low]
This isn't a bug, but does this comment duplicate the existing block
comment directly above gup_fast_pte_range()?

mm/gup.c:gup_fast_pte_range() {
/*
 * GUP-fast relies on pte change detection to avoid concurrent pgtable
 * operations.
 *
 * To pin the page, GUP-fast needs to do below in order:
 * (1) pin the page (by prefetching pte), then (2) check pte not changed.
 ...
 * For THP collapse, it's a bit more complicated because GUP-fast may be
 * walking a pgtable page that is being freed (pte is still valid but pmd
 * can be cleared already).  To avoid race in such condition, we need to
 * also check pmd here to make sure pmd doesn't change (corresponds to
 * pmdp_collapse_flush() in the THP collapse code path).
 */
}

The commit message also repeats the subject line verbatim without
explaining what is missing from the existing function comment.  If the
new comment is kept or merged into the existing one, note that it has
three typos: "collpase" (collapse), "unchaged" (unchanged), and "dtect"
(detect).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-refactor_g=
up_fast-v3-0-2aaef02df0e1@arm.com?part=3D2

