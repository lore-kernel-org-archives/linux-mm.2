Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01709D46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA676B0088; Wed, 28 Jan 2026 22:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8736B0089; Wed, 28 Jan 2026 22:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA996B008A; Wed, 28 Jan 2026 22:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB2B6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:00:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EE571401EA
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:00:54 +0000 (UTC)
X-FDA: 84383499228.23.A289809
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF6A440010
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:00:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGqKVANv;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769655653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLgsJJ2DJ+t6b/hazprnCVEL54/CGelmOLPvH7wJObs=;
	b=hYh7U81hDpgDsBKJBIKHe8iEFycq1ir670qinv/y8sNURRcOKI2F4gmgTafA0nQAljLI97
	F9nkIoR7gF/u0NAxyxv2WDH58WspB4h20+KQcz6a+F0/zc2t2cL4tkSgiKcP0VyipyDvq/
	FrSjd4qOX9wr2KOouKJs1VVRDsLu1/M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGqKVANv;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769655653; a=rsa-sha256;
	cv=none;
	b=4pi8q45Ug+IHwBoSRex5+8+030n3gnD0XWajHLctu3EuP/L24a71TOp8uVan7g98ihLWkT
	t6byJaYlHvsp9u6zWETToMag+bC8rlupx2r90Lt2oojjNImSgaEIx6NQPpVsoOj3SRvREP
	xtqCiqPqQaHUzQuQglZhiG5WJpwNPJo=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769655650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLgsJJ2DJ+t6b/hazprnCVEL54/CGelmOLPvH7wJObs=;
	b=kGqKVANvKr8PZg++xZhG7iMds+BlyQUvRkODZXgyoNViIuAV23ppanBy4xDGgWkoto+6Ia
	qN+ffnsYEqzRetMcVO4Mcvf+Vsqa2mdwGQBVnS2PiSH7oAYdUwxJwOV58otZFJelHA6tG2
	KKoBUdiQdqErcwgsiLlY8mNzRmPEOC0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv5 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260128135500.22121-10-kas@kernel.org>
Date: Thu, 29 Jan 2026 11:00:07 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B4674CF0-7534-462B-A761-D9124234BFE4@linux.dev>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-10-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DF6A440010
X-Rspamd-Server: rspam07
X-Stat-Signature: e81bmitxznojdmi3xh57pfr94jjtzu3t
X-HE-Tag: 1769655652-498835
X-HE-Meta: U2FsdGVkX18ycT8RbkANJjFa8U+u4i6i1k1pM37JCXSTUt/l35mAIgJ5g/nRCFy5LwYS3fhV0u9m3O/kvsvYMdAJnFPE8YJJ7bKpv8AOTr4Jk7Y197pyWOvi9X8NsNt5Mu/1r1jow7NNbp1z3tP3rZGSdkfFpzSyJ+UbufPZ6OyYGTB1iggiGKd5K+JFJ0dZzRAKkmSohJyyjdSMCfSYYEDbQhlCwcLPUeQpX26fnouyYQvaGE3RQ7/J1dic60Ss/AN8KbXkDp4rZQfSYV44+lUi6g7LV9jrhYVFsEPVgxoFkyN2/lm88qXQMuCpKYTm4JXyALV6kxegQXBsZ9cfU/eCBY1DA8QA/BGA3B3Isi/5+c9gVYykOERQaHhaawdsYprBSvebwITJ5pxtYt1b2qkPuzMQkEneKJLQbWp1bFxe0aHJgbkh7yOZ2HSXsn63w+d8ORysJe6VXiiw+eY2y61oynIx6piZWTaR3xt7pwK6hpiIedXJ4oj0xYeQXr0LATuWDkIcrspf6S9+CYNJgXEadFBTWCvjsYwEC/iYKDS7uOPYmyMJv2Sw6YTdBxYndciOLS4rb+EeeYQutNoWYmLQ/td9D4gIUqmAxHn0K3N8yUz2lpIar1NQthv0xtTUz9BJ6Ayvli6jiGCAj6pPv4cJZEb/rWh3OeuEVaOpEkEGzPJqkoKU8U0lsm9Rf5e+mSDaUMfS+BKtbL1D84AAln4mO3D1VPb/F/T4jySdYzCOANqEQVylPUUhWlD4z518TZzgnp39bVRRGFx48k4D0SmnoDVQoNL6+Dcfw8+6m9J+r6p3dlAo1AnCSSL9mMm8iu6seLRKqA2y4pvA1Dm8Vv51VqfOYEghHOGtvsU559y/xfHrCyB27oS7gzsCHk6bx6sJZ8sBh++R1GG6Dlj6tusnNnWf5gWoLFBXsEq/B0xbGyMpyaJvR0LUx2b4yXg7K/NscuFm6Ebe9JDoYEH
 w/F7cuUY
 CcWKI1rJiEGtFzfwBgMfT7Hgnh5b0xsZtTSMR077A+8ihNq83yzwuuKbBQusSeBAVb5MJTXMFiZsxsHQ7wNCMJj21Iyv3cAeHgLOfcY+W4qp7Ub9NL3XsLcWBGHIaBMaPCD1efV2QUnhyCAhhUgkiJQUZNaZ1Kg0iUdBLuL9gQQ2fuy2Qf1Mz2SXGJouAhtQHXt6Q3GvBcXEbOPtqkBzvuVpJRA2z4TwXpq9qBYdJ9RWMifMNqWCKb5BLb14cYwChxLwOhn2v9m1mvv+5czD6EuJg96NXCRAweUWWFubpvatjo7RTbpm4h7efxKeU4X3s7CKM5P1ArljjX2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 28, 2026, at 21:54, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> If page->compound_info encodes a mask, it is expected that vmemmap to =
be
> naturally aligned to the maximum folio size.
>=20
> Trigger a BUG() for CONFIG_DEBUG_VM=3Dy or WARN() otherwise.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
> mm/sparse.c | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
>=20
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b5b2b6f7041b..9c0f4015778c 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,19 @@ void __init sparse_init(void)
> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> 	memblocks_present();
>=20
> + 	if (compound_info_has_mask()) {
> + 		unsigned long alignment;
> + 		bool aligned;
> +
> + 		alignment =3D MAX_FOLIO_NR_PAGES * sizeof(struct page);
> + 		aligned =3D IS_ALIGNED((unsigned long) pfn_to_page(0), =
alignment);
> +
> + 		if (IS_ENABLED(CONFIG_DEBUG_VM))
> + 			BUG_ON(!aligned);
> + 		else
> + 			WARN_ON(!aligned);

Since you=E2=80=99ve fixed all the problematic architectures, I don=E2=80=99=
t believe
we=E2=80=99ll ever hit the WARN or BUG here anymore.

I think we can now simplify the code further and just use VM_BUG_ON:
if any architecture changes in the future, the misalignment will be
caught during testing, so we won=E2=80=99t need to worry about it at =
run-time.

> + 	}
> +
> 	pnum_begin =3D first_present_section_nr();
> 	nid_begin =3D sparse_early_nid(__nr_to_section(pnum_begin));
>=20
> --=20
> 2.51.2
>=20


