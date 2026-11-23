Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DB8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9tKdHo1
Received: by kanga.kvack.org (Postfix)
	id 7B6236B05B3; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737926B05B4; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6019A6B05B5; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411856B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3CCE1C3D28
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:47 +0000 (UTC)
X-FDA: 85465052694.04.1CE7EEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33BBBC0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9tKdHo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406926;
	b=2pVuDghsO78C4xY8Hmh9TisoKP71CXL7AnFc2R4Uh7tFmYHwNo4ACo0Ejcl/VPH4OrBh/k
	POR1Nj4CtCgkvIQOLEluGHQNnZXLLbhGWiQfI9c2qFklVU/Y5xNh1xHIV7Ji/wCAs/+zkT
	cndSRrpKPLveI1/UX0uzcZakU8e81Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406926;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXZgiao497vjuQEWO66dlbufdTEtnO1vM80+2ppxcsk=;
	b=tzkNumYlIMZ7NXena+zJECY2u+YjuAswSlrIpGHTA7vKCWvtFiDUXaYF/gulL/eZrvSItq
	xDmBjQaNp5cr1LJjSdI40cbJf8qlQlBLCqO8+Sfgh5eKc3ksJcsD5DfV+oA/GhtZBSB08A
	ZvpVNI7DE92PaN0k9PKcaAnIah8FW6s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9tKdHo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C246360D5F;
	Mon, 23 Nov 2026 04:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCB71F000C0;
	Mon, 23 Nov 2026 04:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406925;
	bh=GXZgiao497vjuQEWO66dlbufdTEtnO1vM80+2ppxcsk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E9tKdHo1jsJVazYQHH8dgT4LgnFRYApg6WfM6nRHNwXuruJKJcpREWfOy/sdEQ0+z
	 AHMnnN6By3ihifyJ4WUt4XC80GeZkfosWwW2V/8y7mZxane3asTSZ2VMp/gxndXkch
	 JdURfPpQpORIK2yxU5SRF63IZOvrJQh4kVELvxnfZ9dFn12QDv4M0DtMfyESRHsJTT
	 wWlidAlcogObFMqoZxG4nsLGSStu1H1lz9GATFlDecIk7ftxvzbwTP64by/py427wN
	 Zww11HX17PKFTsR29koFlXg+KwNwnkca8brBX4STLAHXw0gLj0ZuzlbNnrzGxl2/Vz
	 SEehTRrolUfuw==
Message-ID: <sashiko-outbox-228635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not
 pre-HVOed
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-7-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:44 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 33BBBC0005
X-Stat-Signature: xma4h7rfh1psr6k8jbuesupibc1af9sz
X-HE-Tag: 1795406926-287249
X-HE-Meta: U2FsdGVkX1/HAV1l5a6aNgwncJpzaMztNkVP1nQipQY3wg14xsxxbxDp7Zj1DqqqcpLZh0SlVIvcBzZn6Mdy3GHPD0czxYNFH3Aofxtui1VXsJTgIm1JKp6/Qm6kKbSG2miLQi6IcDFGw025ggc12V/SKoc7h0PLez8Smpz63KshRKlP4BpcnGKhrnIcX/CEB5wEsR2oDfQdNX89vanbEnLZ31Xu9cZWKyueLeNheCEMvkueeT9OaakBSbUOVMs9JKLW47qlEzR/zkpf9fpP1hOZyaLxT1UJczP7AUmBTnTN+BGdfeUIPek64ATwBUxkScLpl/kXfrDvNMBK+Rwjqx2uGLIRbW/VVVCKKNxO9A8P2oVW/DJ6mcMThvZ+t9gU+m8z1a2QAfpraVayxSvmhp27ePnmAV5o8dTSdZgcMW3UuSa+sLJtyp3QKCodvlyg7cZcIU3/We4c8C3z4jPzBKzSQF86VPgU4/qLhoUCWM6gD4nM6HEMqoNtZojBauprhn9nfMWUIuX7FZyNdJavT/+/oNntCNKvXMq1ExKdefUW9YyAonVBEPCjDLFpOfcShd+W1CjvFFkSiX7IvV6VxNlzGxPEMMeTLaFGDG2SQ/JwzUK08YoEJQL57IBWEGhwBgpwOmQEywtaLMvn24jhw94S1GOCuX+kMt3KQERawL/TiSPavMAtVejpFbZAv+KV9Dpj6GERRHWxny+cXiKWXSyaeV4wS/XaS9OrF88+gyUd0z4m6E5TsKjeyg/C0iwt3f15XjYklboGyCOz28awMlEW8IIFZBui5P0/q8JTop53RMadzBiFR2qSmk9XSueq3O5BZxuJ7ZR6GcKE/clmYZd5bD8E62wXlpnuTzahj3hmCG90wImNtf5U8veSgT3YiuJzPQkuyhxTdiXPrx7j+V5wVzxEUSncfq9cIeBob1nzqPaNlpIQVefYFj0l5Im74h8qIquDgsUx/LqzOm/
 uM92WVFn
 Y/n6u+3QTCXHlui4ZGta8imF4egsn09D40yeESVhLEMAloCJpHGLL6sz1Q9OuqxXoD6MLhCb+ERJj/Y42v5Zv2A3CUbRQlFLO0Nh2xOjiRZCgpI09UoThSIryAsxtvtA4RNiVNJsWdMkyq+2NhZMitXWE8BYqo6IIFDSe32h6AEPiTtd6jkQmtcaGMJZUq1gRHrr4nYRjdKwclJVAcG+/mPfGZilMuEyzJ/dU74jeAFiTAallYTzKgVlE1oVI2Sjunkb5BiqUzux9GyWmGmWf6zSFPQlJFXVh6VJb5rxoThmxO47R2XT8cjULWvGSCUXDaHgiMATbsuTZo/7Rb8lNTWCV+ZxtyYRx0k2LIvaYflpWSXxkgWN3D2a+n4ve1fax8MGuhky7I5Wwd2XTxQ25o4bgvyhGxvqfjrWN4J8srD1Jk+v49bJzbbVHYK+f3WLj9yhegSa1ocQwoW3SUrK2l1U9nawr/TWGcszOYY8kQtac60AqkMkZ00F//CGayNy1/uGt8sMZ2FOz/yqoD9Sg9o4z4YHWY6uYAYoyuTQAUltpJLNURFVM0qMuOosgSut36uq6Qs4SwOJOH5x/1xy3GHeIH6Tb3/BUrZQ/5gCCR70XIMNpkgMwOg6iYN0WhJRp7VtHYtR3/ebw6JGVU4GOOwGbqUz7vzwQGJsqm8qpSbV0vXV7oKJFMNhQOHecVbuswbYUwsou41gPtnlHSLTjiRIrrXbqM48grMtaerp6CV2n99fIuP6HiUNrQ+OoePf8EHlx+GvtYXxeibxfeBAWEfOSG1Q2bvrIIBdO9+JWtOpGUBG/sb4LF0G9ug==
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
- [Medium] mm/hugetlb: avoidable TLB flushes in
  hugetlb_vmemmap_optimize_folios()
--

commit 5763c0ece0fd843280e0e8e1b6561cb66598d64b
Author: James Houghton <jthoughton@google.com>

hugetlb: Optimize bootmem folios that were not pre-HVOed

This commit restores calling hugetlb_vmemmap_optimize_folios() in
prep_and_add_bootmem_folios() so that architectures disabling
section-based vmemmap optimization can still optimize bootmem folios
once HVO support is determined.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 72839e98f998e..8756c0206922a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3325,6 +3325,17 @@ static void __init prep_and_add_bootmem_folios(str=
uct hstate *h,
>  	unsigned long flags;
>  	struct folio *folio, *tmp_f;
> =20
> +	/*
> +	 * Bootmem folios are normally pre-HVOed through the section-based
> +	 * vmemmap optimization. However, an architecture that can only
> +	 * determine whether it supports HVO after bootmem allocation disables
> +	 * the section-based optimization (see
> +	 * section_vmemmap_optimization_disable()), in which case the folios
> +	 * were not pre-HVOed and must be optimized now. Pre-HVOed folios are
> +	 * skipped.
> +	 */
> +	hugetlb_vmemmap_optimize_folios(h, folio_list);
> +
>  	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
>  		/* Subdivide locks to achieve better parallel performance */
>  		spin_lock_irqsave(&hugetlb_lock, flags);

[Severity: Medium]
Does calling hugetlb_vmemmap_optimize_folios() here cause avoidable
vmemmap_remap_rwsem contention and two global flush_tlb_all() broadcasts
per NUMA node when all folios on folio_list were already pre-HVOed (or
when HVO is disabled)?

When 629d87ed65ef ("mm/hugetlb: drop boot-time HVO handling for gigantic
folios") removed the call from prep_and_add_bootmem_folios(), it also
removed the nr_to_optimize tracking and early return from
hugetlb_vmemmap_optimize_folios().  On architectures where
gather_bootmem_prealloc_node() already marks every bootmem folio with
folio_set_hugetlb_vmemmap_optimized(), each node worker in
hugetlb_bootmem_struct_page_init() now serializes on
down_write(&vmemmap_remap_rwsem), walks folio_list twice, and runs two
unconditional flush_tlb_all() shootdowns without modifying any page
tables.

Restoring the early return in hugetlb_vmemmap_optimize_folios() when no
folios on folio_list satisfy vmemmap_should_optimize_folio() would avoid
the extra walk and TLB flushes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D6

