Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3A5606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Lj2DYBKe
Received: by kanga.kvack.org (Postfix)
	id 9791D6B064D; Wed, 21 Oct 2026 03:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9299F6B064E; Wed, 21 Oct 2026 03:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840596B064F; Wed, 21 Oct 2026 03:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 668916B064D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:23:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB0734013E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:23:40 +0000 (UTC)
X-FDA: 85345793400.05.0FC0452
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id 85084180003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:23:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lj2DYBKe;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792567419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+x0xV+m3eowwe+TjUl+RzSOGyPXS0tHlwPVyxSEpj4=;
	b=PS3Wb+AsMo8ggKd3xBYt5w9quJN0oSRoTvQlxCaVs5E5QS7Kpq85Lw9fuLh6PLRk45cYnc
	dr0QRMjO3XLVQvLQGImWgs26AkyqBCgXONLUhz5wvWJ9Zcm1BOVf6LQBXimmOp7dmgZbFI
	Bz8s5oY+VswW9+hyJRizAG5ydRYn/4k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lj2DYBKe;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792567419;
	b=BBK6K79x58axTLFZJgFin9U+0j76n2CWwrvPdm+p1gygjt1YrxYthHYamHkHfqiM0KqbeE
	JZRidYw9NMrIqy48437KkMVrPtfQAQFJoHtf3zWQuPzqXof3ifgyLC7t5KpfawVvKWiH11
	8p+BHAtONfVrrRSHVlYOWSIo+vXTCDI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vAkhRjN3hG8UHJdcYxjaq6dYwJWiOCLtDD81+R6ZVdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792567417; v=1; x=1793172217;
 b=Lj2DYBKeJyv78YA0nUAfyMAyq6BhoEmEXM7kL9E1aR28fZRrxwdW01t57y9jueLMZzerX6Qs
 8ffQNFoXVSiG+U4UgvLJNPsjQZoIr4D7ZGCre4FYfl+1cgM/tVdfqzd/NZWD9KaCjKNZeKeN+Js
 PH5cLkWeyP/ZLght0dTP3EbE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 281913562dc98e21;
	Wed, 21 Oct 2026 07:23:36 +0000
X-Mizu-Trace-ID: 281913562dc98e21
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [RFC PATCH] LoongArch: mm: avoid backing vmemmap beyond max_pfn
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021062115.116922-1-guanwentao@uniontech.com>
Date: Wed, 21 Oct 2026 15:23:21 +0800
Cc: chenhuacai@kernel.org,
 kernel@xen0n.name,
 loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 akpm@linux-foundation.org,
 rppt@kernel.org,
 david@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EB4B2A6B-147E-4E7A-BAD7-A7C4699AF46E@linux.dev>
References: <20261021062115.116922-1-guanwentao@uniontech.com>
To: Wentao Guan <guanwentao@uniontech.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85084180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a3rf3h8u4k6rzkq3rg9q7k9r17r96d6m
X-HE-Tag: 1792567418-70333
X-HE-Meta: U2FsdGVkX18C3TBW4Wosl1V/XXTrjhpa6ltWdoNjLo3MQd961RfhmWNIQ7O/2ChWWeOQC3RhGylIHLLsk4YpkQOP7h2GzPm0B20E5YMKWEsrk5JGzjUTt18aqSA1Iq0+Iw1QGQpM53wW4pU/vhsmL4+EPB8ACNLp83+9jVK8tt0VuPquTkDxxaqY927kCzs1mKJNtTzYaPCBUTNE0iMHMYky/ny5BAGDPEzOevXznDHfE+cxBERB0kpXa17ztFXNNhseuK1VSQk5kgmdDu32pOV/2pWveOI8Gkr2EnKU4bjQd3538iW7ZqR8j/0qIPnHOm7sOryhaIIrXWgaThEbWpGOPV9rhAy/2MtNl9pz2sFOBwuvfXOhGziSvox8Fc0H/j8ZdUmtv4dYoG1KuydyUe7rGisAFWQPg7YLpnBNYerD2EgzQbJ0wuUZvk/RgURYRzafc2uoTEpp09o0bZ1T1EZR2rWpxhaGEbLI/4cjltS4OP+zDZbSc0Cm/X6JpmpEOIasg9kSBJHcQlhaOVLWWeoDVDSLH/uElAtwThit0Jj5L/tF7PId/k0qpxnNlfUfabhQ3UFhUXXz0a9E6oV+XcAbVAuhD5Nc3YtCl3HJf1goyWeqKRCC0+jYuI9dWQulXpzi3brqLZOBsKt/mymt9HRk4UIhUt4UlAc/7fKsno7vGKQW9q8+Imyn7fUK89PnZkMYLuJKni940e3QE1i+Z9Os+QPW54tRH3mcY+/V+U4jr1eAQ8kAJDUhQh1cbNX4vB3CfwHqQqPtALYdIYTHzoWFi6ROhAH0SrjyyNs9D4muSrRxobkrG4GDljb8i7EmgMAZNV5TmV10PjWQqPQF/SbTbLuZDJJGTtXtN2rKpuuKYaxyqlwTRufsnzThSg+r7u9e98pgNQJuVlBJi7wnEPlBwVyt/ECd2R1xFZwds4VXjSpAgHq51LwsqIhWDzyH8bjlXmssGtaJiuuJuDn
 Divu5xHw
 HKqUFnadveDPJlFQlW9KFrVV0ChZkk+mfJ4qkRPRW6/ZLFky1sle93yenX3Q3oOqJ98yQBknlNFtIZHj1c/3n4P2EiFI6rfzoUrUF7bwhA65HzV15iS+HbX5NdDuaKpW4WfPmISINngtsVeIX2JdLbNFHVkXRMPPduJUn+SeSeSrTrN8KBw6hrT1YB+yPlhvs8XJwn9bcPp68wKmj2h4BFgr3kW8JYAOFYhA+oJx/XMAQv0QZnQU6Kr3NVSAuCxTkvjoTjqilrGeXxMT8bxYubdR6uPqwdVMhAdcx+Iyomstc5/ebRn7lqN5IzpJQS683kHmOJJ2FnzGhhzLBlJQF2rk4gKdzzFZN9Kr4KpVXl+FiY4b2ACSdftFH/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 21, 2026, at 14:21, Wentao Guan <guanwentao@uniontech.com> =
wrote:
>=20
> A PMD maps 32MiB of vmemmap on LoongArch with 16KiB base pages, while =
a
> 512MiB section only needs 2MiB.  vmemmap_populate() is called for each
> section and vmemmap_populate_hugepages() installs a PMD mapping for =
the
> whole PMD, so the last PMD also backs struct pages for PFNs beyond
> max_pfn.
>=20
> On a 34GiB system 160MiB of vmemmap is mapped although 136MiB is
> needed.  The extra 24MiB describes PFNs that do not exist.

Your commit messages are very detailed, but I don't really understand =
the
problem you're trying to solve. What issue did you run into, and what =
was
the resulting impact?

Thanks,
Muchun

>=20
> Other architectures handle this differently.  On x86, arm64 with 4KiB
> pages, and riscv, the PMD covers exactly one section's vmemmap, so the
> huge page path never maps beyond the populated range; x86 tracks
> partially used PMDs with PAGE_UNUSED for memory hotremove.  arm64 uses
> base pages for 16KiB and 64KiB kernels.  s390 deliberately keeps using
> 1MiB frames even for partially used PMDs because vmemmap_populate() is
> called per section and falling back would add page tables.  powerpc
> radix falls back to base pages only when the altmap cannot back a full
> PMD or the allocation fails, and powerpc hash maps the vmemmap with =
the
> linear mapping page size, which can exceed a section as well.
>=20
> With 16KiB pages the LoongArch PMD is 16 times the vmemmap of one
> section.  Moving the whole vmemmap to base pages, as arm64 does for
> 16KiB and 64KiB, would also remove the tail, but it would give up PMD
> mappings for the 128MiB that is fully populated.  Use base pages only
> for the PMD that extends beyond pfn_to_page(max_pfn) and keep huge
> mappings for the rest.
>=20
> The altmap case is left alone because max_pfn does not describe it.
>=20
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> ---
> arch/loongarch/mm/init.c | 5 +++++
> 1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> index 4b46c5d30708d..bb7a17bdb0e51 100644
> --- a/arch/loongarch/mm/init.c
> +++ b/arch/loongarch/mm/init.c
> @@ -146,6 +146,11 @@ int __meminit vmemmap_populate(unsigned long =
start, unsigned long end,
> #if CONFIG_PGTABLE_LEVELS =3D=3D 2
> 	return vmemmap_populate_basepages(start, end, node, NULL);
> #else
> + 	unsigned long vmemmap_end =3D (unsigned =
long)pfn_to_page(max_pfn);
> +
> + 	if (!altmap && (start & PMD_MASK) + PMD_SIZE > vmemmap_end)
> + 		return vmemmap_populate_basepages(start, end, node, =
NULL);
> +
> 	return vmemmap_populate_hugepages(start, end, node, NULL);
> #endif
> }
> --=20
> 2.39.5
>=20


