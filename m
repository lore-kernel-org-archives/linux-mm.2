Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2DA606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUgK+nYJ
Received: by kanga.kvack.org (Postfix)
	id C09116B05B6; Thu, 12 Nov 2026 12:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE09B6B05B7; Thu, 12 Nov 2026 12:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CD46B05B8; Thu, 12 Nov 2026 12:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864F96B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:57:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 054541C3FBE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:21 +0000 (UTC)
X-FDA: 85427223882.29.31E5C67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5955E20002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUgK+nYJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506239;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2a9WIqOCFMJ6gfTuc21dbZqO3KuVbV4z0lSwEj0KFPY=;
	b=kdDOSYPxUwYsO/x2fNYD5Z/dO5R0B3XqIuQ3H2GBSn2oa0uBde4EUkdDhvKEvzf9n04r14
	PK6G9gjLb76VSUIPDt8jslg3unZV/sMIFrdVoRvADtwbfRsoEsEdl7nQjM6MZnTA2YCrL9
	xG+acBZWtaN1z1c4UPebdgBfSpbqd+Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUgK+nYJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506239;
	b=C34JaJ+7FPyAZsJ8SGhgduA+rI5Kkfvfgupj5IT9nNtaJfLTfbCjIbRMagwim5JExrfrHD
	e57vZMoVd826oS+2cU+ZvSJsqVGld78djc6aIOQqxxJXLetbbwnE3nBKLZ3hwHHEKS+SxJ
	+KQmM97iXmVFUfQgOE/tw9Q57yr32OI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EC1641129;
	Thu, 12 Nov 2026 17:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8741F000C6;
	Thu, 12 Nov 2026 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506238;
	bh=2a9WIqOCFMJ6gfTuc21dbZqO3KuVbV4z0lSwEj0KFPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WUgK+nYJQRaMB/HLBM9qeqsaT6ZAq2acOQRcugY5W3CtWMCyI1CjqfbtFXe9NPLUg
	 4ZLZLHo7DgmRonRGEdbjI1tkDcW38UKV6AJDF+AOPuuMWVNR0TBlo8PVwVBcCH8OQo
	 XuIBkZW9Z4Tcm4/CPH9muUh3ddoe8qFoqoZwVWDhLc84HjfUOO4MszkkXdOITJdnY0
	 cY5FLUH2stUGiNWEK341yeLTzukewSjef9UtURTOPIK53XzzPiUJ7SutrcOQABhLtC
	 ZM6UodCgaKn59EAxUhonyxtrARGE37WhsdV0YJrDJra12WPbbSy8ZeXkLT6ij0Izhh
	 8YuUXmGaSE1ig==
Message-ID: <sashiko-outbox-211648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/12] mm/huge_memory: build the moved huge zero PMD
 from the destination VMA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Peter Xu" <peterx@redhat.com>, "James
 Houghton" <jthoughton@google.com>, "Andrea Arcangeli" <aarcange@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Balbir Singh" <balbirs@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, "Andrei
 Vagin" <avagin@gmail.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muhammad Usama Anjum" <usama.anjum@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Chris
 Down" <chris@chrisdown.name>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, =?utf-8?b?TWlrb8WCYWogTGVuY3pld3NraQ==?= <miko.lenczewski@arm.com>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Kravetz" <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:57:03 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5955E20002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 67emi4aiyzpeax333o57qayk3t3znphz
X-HE-Tag: 1794506239-676002
X-HE-Meta: U2FsdGVkX1+bXvzqv3OkMDBt2SwkUOcyXKgN6H/FmO/g/r/PL/V+I5Lh+iiGUN4BdAoVDF2Z2CxA2Ecug4Nhzdc5tebO7NW4WR207KRRx40Dbm6n2MX71jRsRb5x2+ZhpNufDUfHyPZR0ET2thgLuwg5+argIz2EO9Lh1flGsj4xim9g9+56Ezs8RU/LiT1T9yuG9OcUGQo+G3M4Jy+Bq0IPU9IT4VjzVFlEclwja+daGRipndDPmZm24Kt0Vrnerf6tFL4XG7E+KpqnFOmwHwKNp0FEePpvHyKN+oqaxwXjCTPRHesncN9L8sacE4nEJHQ0N3e2WBqjZsayvSiLUlznqURL8DNCyM/YS2YRZN9vrpZWMcllPIB2JxiRFuxX1WLb7nKIzJQvIeGZvGkBtjPe0YyI+EiL0YE6atC9rm0QM/Hm+fv8+e9gCsQz42HPnVfMNwiXQGAHCMUVizr6kCI2do3y8SRhypYxFAr1tpayyKiHkpKIaVykTmkp/D16fGZS1Vo/FNd0aLAWBDEx3T8QuSFkpbtWl4JUtnpR0NdY+hMqZMSlZZk/QJCcSD1WmdFlK6zb3iiPCkACiukIVYwqKv2mun7MXA+Q9o/GMO77o45xxDGImagTybA0TvWSmr9lMN6WHvhGUMO3un3g+787oiPql041v7wL41bsW3d3383f1LWeo6xCsH9IJYQRHU5/nWsC+nryrn0O5Sy79t4lGdZ8kWApimNjTQ7UIjPM9Ij36nkguUvlxhzaDtEcbnZfduGE9ifpcerXbbBvC/Iv5KNE1j1aPT1SJUdOaS1QBtYu1F8+o6dMadFWXteDNxCsdopKopLGOc7Sphg12ndX8VO85a7obRoMT1XEdjm04My9ua6G9U7GO55eubSH36vYrSF3ptZF9tUECJQPjWZzyjNsUkrfqsYZEAr9LDfJlWB4VUzYdfG5OJQaJuptSIWoekOzN3tZahJ0hvK
 JHCWsKPn
 t44Sk6hihUIY5nKGrnnlqUWEvL/OBcxJiHDl58mC1daeO8yQLLxJq1nRu/VuqjWrWQUpJ8frkPpBaRMcL4UXz2IDQnvhF2uyiQo+MkWRTwD4EXgM1qPzuhDok0fkwwi2HTWPsyGP1s1K+IXAuJT7wtaHdVav2yFP/L/cWweJQIfwZi+xcIJMLmOxg8GJMGP7F9+XQDA/ZgapISn4xCAOUVeuUAjtXpPZgeAsu5WtN5rJ3n35UYA5k0OAeRaIB0I8Gka8+3fjufv7MO39qYWdImvwmwIkzIpQ/ypmeaoiw1zAkQgyRN+a5Ya/no7nG8nIzyQJ8nAhF1lIDLlZO2tvhFMIen9ninMcH/7wCJnhTPiaL/cadeN0Fh9wumyxHQ5Z0w2LM5qZNQyEoEsHFdPn+lAvFj7/a3VXN7k0TCXr6kxRAohclSkZn+hVLfuPMyzNiLeE7XSzi6dekqBLg+OgBug/vaQ8Uern7KSsZL94fPM32S1oALsBCTzo+aq+WpNNaTCfYh+pJ7wtUPqXBhu34zkDyivabl1QXwPxJp6dnkcLebmE0PHbMoK0Mt0Qas77A+xZrUHllofKyxhp4mO9HB5kUCZ7HDocN+fER6Ievv3PcLTFUu4Hgy9utk63FmCdNZq+58aDzXTuLEsg2tnMXzD2SHvVjP4qUtPBv0UI189Ggxoamil3beTwACw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm: clean+writable PTEs and UFFD_WP bypass in
  move_present_ptes() [1]
--

commit a31e8bf5652b13454bb968641961e319c67afcd0
Author: Tal Zussman <tz2294@columbia.edu>

mm/huge_memory: build the moved huge zero PMD from the destination VMA

This commit builds the destination PMD for a moved huge zero page from
dst_vma->vm_page_prot instead of copying the source PMD.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0d589be136d21..09176b290f768 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2981,9 +2981,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t=
 *dst_pmd, pmd_t *src_pmd, pm
>  		/* Follow mremap() behavior and treat the entry dirty after the move */
>  		_dst_pmd =3D pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
> -		src_pmdval =3D pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd =3D move_soft_dirty_pmd(src_pmdval);
> -		_dst_pmd =3D clear_uffd_wp_pmd(_dst_pmd);
> +		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> +		_dst_pmd =3D folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
> +		_dst_pmd =3D move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));
>  	}

[Severity: Critical]
This problem wasn't introduced by this patch, but in the src_folio branch
above and in move_present_ptes() [1], doesn't unconditionally calling
pmd_mkwrite() and pte_mkwrite() on the destination entry bypass userfaultfd
write-protection and create clean-but-writable page table entries?

mm/userfaultfd.c:move_present_ptes() {
	...
		orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot);
		/* Set soft dirty bit so userspace can notice the pte was moved */
		if (pgtable_supports_soft_dirty())
			orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
		if (pte_dirty(orig_src_pte))
			orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
		orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
	...
}

Both functions drop userfaultfd write-protection from the source entry and
make the destination entry writable, allowing userspace to bypass
write-protection tracking by moving protected pages. In addition, when
move_present_ptes() moves a clean page, calling pte_mkwrite() without
pte_mkdirty() leaves orig_dst_pte clean and writable, so later writes can go
untracked and be lost on reclaim.

[1] https://sashiko.dev/#/bug/linux-6a04b397-aeb2-44a3-b8f5-9f235e068739

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-uffd-state=
-fixes-v1-0-00713d368976@columbia.edu?part=3D6

