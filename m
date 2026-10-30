Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE97606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QmZfN2jP
Received: by kanga.kvack.org (Postfix)
	id B86FA6B05B4; Thu, 29 Oct 2026 22:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E7C6B05B5; Thu, 29 Oct 2026 22:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A1C6B05B6; Thu, 29 Oct 2026 22:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEF36B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:22:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E525E140583
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:22:10 +0000 (UTC)
X-FDA: 85377692820.28.6A97532
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8471A0008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:22:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QmZfN2jP;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuCXOFg/eaPoMDDOQ3AZlcKE9moyp2CTPmKEIesl8bI=;
	b=iv0mmK0EU+r6/OKU2PhIz8lMOg+LrR9sxuWc54BIVJxLCCb7UCLDqJZm3YuPkyXSiJ0ERY
	QoEENI0wAFX/6qmNU9L4eVslFZ0pfHNtQxAZgT31QoWAjE7cVuty4IpnUkIVc75Q4qahTy
	9PlxBMJHcZaMR0mVl4X2alTU7KTV7aU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QmZfN2jP;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793326929;
	b=peWqcJtRF5j7L3vgR/6wgeZpx0Fndvbj9Q5IfnWTn4W6Rcuf3AdsFMEWqBUHsdF9SRh+su
	rGJ37o4n10aoIlZ4gSe8v9UGfxHrUjpMEJGUYk5BOngKmfCitLYK4kxsTyh2ubjWp4FqD9
	CPk9LHC/UdajJrj7Kn8JKzR5PtjTrwI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3W7i1+QOf/eQW3A33+hQoH7jzxTnHmjxgFZBOXgW78U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793326927; v=1; x=1793931727;
 b=QmZfN2jP4dUxZiSnaSdskWPARHinFT7ZQjige5i32RhnTdt4N/azDq2U0wo/Qo+edWEqH/dr
 wTcZ9xnxq0+TcBW1ZiGbvdN0hfQwM6QskzlG829WFPm+f6byXk7j16RBEoGB9JMu9iSQCdQdntl
 jbux+ZLv64nT6pKsqXoD95M4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bb3320411df55916;
	Fri, 30 Oct 2026 02:22:07 +0000
X-Mizu-Trace-ID: bb3320411df55916
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCHv2] mm/huge_memory: set the mmu_gather page size in
 zap_huge_pud()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
Date: Fri, 30 Oct 2026 10:21:49 +0800
Cc: linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Pavithra <pavrampu@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4012569A-93C1-4662-B6A3-3521B97B8C57@linux.dev>
References: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8471A0008
X-Stat-Signature: gd69phep87znd7t4a5ym9aspbtoy6rgz
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793326928-808017
X-HE-Meta: U2FsdGVkX1/O915FnjYqI/MhTMkaqIsI0HA9/P8zF6Et9egF1udBHt9H7+9R4Ow/1nC/rErvy1ONmojj71wRnSq7cX8I+3oVw5+OOeJdHa5hShbdY7p9HylSN1Ob3flpu0O/UeEJobVlcXPZ8XXoGruvpJDe0O+LXsxd8/meJTOi5Suthl4Hi/GwVi6NdK9rulpsdZY2iiWZ5Rlx+LWuR4n0CWoxLG35YDln3EZJnvjBroK8Ju6GaJVn2iYwzNOJ6C7dgc65m37lbHABy+L8yrEf17O9UxlvIaE1oRl6vU1JI8t8f2Ee59S6T8EqhXts20vnCCEtAzDJmai9+Vcvx++LeSFbtSKTjmvubjLb32FxKjyu7FTRNspynrg+5wwKhPC1tzcqcb8wkQ+4r5oSsRbIu/Db44JjP41o0nlXY0VeLLsPA4t89m+d4TOV4lCsmkxfU6kdaYm+E8nPSbWx0ys9tR4PaFlHjyJ6+cIYXzSDo0zBz+102MsIyduo4hSbRaVibGW/74uC8ID7AtvuUw05yGlKWpzq7YVx+xco6jZikSPpFFtsxf8yOTh0vdhYfSg/eSLn9fKI5+Yq5m/Pyo3fs9SOpFjz4cUmRi2Ha5mcBv5Lmy75XoaYyKmlUvpaDxWigO+QvNm2q9EdvbpXRN7gja7Hgy77dPyrkCsEO7vuu4HqwrUkQv/7HHZuPpAOIetjIDGB4fQghOwck6dFJ70WnKQKuzOllp8G/8/6BplJ/TPAKiE/01rxEk/4ai6QyhKSZlJe7WAwLIIqyvLcUnqjB3yZuSp7jB+tH+6+Xi4RQ760qypU8o52y8ixk//V0wQ7n/Ze+4lZc1BqBO9rYxQVv3/Hh/AECASOrBcJkbmAn/8ZLXlC+8Qr/4CrSTfiDTxSBgrlS55lfm6dc/mgTdm1U5woA82M8MwS77bbkh9rsxkUthq3YP55PyqV4XNC+W8i+VaXBNMmPqxm+sn
 syeHvBMg
 qGw2BqCEwmfCABEHMLB/mGsE9EKSgbuZFjmWn55nNX7V1V5N4oQw4l+FPD9bakFiAf2+k6EA/IVDb/v2/uW6vEy1ravoTVNsVqbW+qvvBQ0ddVPBBZzaKptQLZTKi3S9uohYs96ugCKvxztk66jvUemKi0+2J63p8NjvrpaoYihjk2JGH/FcyP4gp9jIRRIK8sAVfTT9/IYAn5BVyNQ490qyfMLKMs9ynn1SQjFnx9OYBWfLzSmcRv3thc0+TcYVbTBiGG6jGSZSymM+GkDP1l7StMI/zoh/QKaxL2arO5s1E52P46JzlY2sCfLbl1hO2aFfrNziyeb2j8ZWQbAAbb+48WdfPgVWOgW+SEotFH0Gt8ByEE4/ho0aHCNgDzpqORmdH+qhKQ0Y0R9VTcSQN1/B12cvLvHSCUJ0qIIzrqaIzNiLsxmC7SG00GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 30, 2026, at 08:07, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Unmapping a device-dax mapping with 1G alignment on powerpc radix =
kernel
> built with CONFIG_DEBUG_VM triggers this warning on every munmap:
>=20
>    WARNING: mm/mmu_gather.c:176 at =
__tlb_remove_folio_pages_size+0x38/0x230
>    NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
>    LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
>    Call Trace:
>     zap_huge_pud+0x170/0x2d0 (unreliable)
>     __zap_vma_range+0x1604/0x1e20
>     unmap_vmas+0xa0/0x1f0
>     unmap_region+0xb0/0x130
>     vms_complete_munmap_vmas+0x120/0x310
>     do_vmi_align_munmap+0x1ec/0x240
>     __vm_munmap+0x148/0x220
>     sys_munmap+0x28/0x40
>=20
> To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
> byte so that the whole 1G is mapped by a single PUD and then munmap()
> it.
>=20
> PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
> the page size for which tlb flush is needed. zap_huge_pmd(),
> zap_pte_range(), change_huge_pud() etc all do this already. However,
> since commit:
>  dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
>=20
> a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
> tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
> tlb->page_size is still whatever the previous user left behind, which =
is
> 0 for the fresh gather set up by munmap() and so the check fires.
>=20
> Fix this in the same way like how other similar paths do.
>=20
> Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


