Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57B7606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yl1GHIOW
Received: by kanga.kvack.org (Postfix)
	id 092136B05B9; Thu, 12 Nov 2026 13:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A1D6B05BB; Thu, 12 Nov 2026 13:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B0B6B05BC; Thu, 12 Nov 2026 13:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A63766B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A23680743
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:34 +0000 (UTC)
X-FDA: 85427272308.10.3C4C534
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B7941C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl1GHIOW;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H21tliDUOW3f1yqFxDbTvtdPvAj6Xwykl1rRgDgC8pc=;
	b=5lfxVu/8IB738YZOxZizfufIwQV5fnA85/2Zl+5VsYKp2w8enZFwxjjLSx2O2HSZ3qImiW
	QGC78nWVRtUZYXc2ju8rxoS0aUdlgpk6PQX/0fp/5Y54seVDqCdq8e2j1F6NOs/gBdnKA5
	5nymGucVHuU11i6YtVdFz74cPE1C9wA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507392;
	b=6pXWEXC5eYUFi19VdNc7oQD4g0r4Q55shb/UjHoVoBIZWIne8IokgAaFy7+KkZTwPwmjTu
	bH8ksDbQhJUGsMm8hoK9iHoSBEZOaeCK7RgMLC1rvVHqNjyjfdug77FVF/Te3vbDaDeZu6
	MeYxKIhkJV3T7VUJ7Q4qQpi0G0lEBdU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl1GHIOW;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A28E623B7;
	Thu, 12 Nov 2026 18:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620081F000C5;
	Thu, 12 Nov 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507391;
	bh=H21tliDUOW3f1yqFxDbTvtdPvAj6Xwykl1rRgDgC8pc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yl1GHIOWROwumnCabnU4g+a6AanpFZ/GWz8eo/y2wzlbBlJBppJAUOwFp2qmUTWk+
	 4JWopkH6ngcCwDc33oSeUsu/jArbB1LAwpGv1DN/feBM8xg/omT8OYBdPnTMxq2ceA
	 Yv/EUU57ayrEh7GyiUe6jPgIfmDCo+gJ8ZDaqwI3ppFv0dS46vaZ7nbqmd3PnWITqH
	 +rLLujNeIkcbwzfSYAMQO++BuLVUUP1JTXj1hOyRLC/aFgLkgKuR/7QaSvW6Zls8Rz
	 6V5nIsBxmpzj3mwZ43gSZp5iw1iF2PhSg4l3UvHlz6LJ15l3v9zMjSGpEaMpIqlQJW
	 Tj9ZOPjbiJYpQ==
Message-ID: <sashiko-outbox-211680@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "David
 Rientjes" <rientjes@google.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Balbir Singh" <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu-cheng
 Yu" <yu-cheng.yu@intel.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Peng
 Fan" <peng.fan@nxp.com>, "Josef Bacik" <jbacik@fb.com>, "Chris Mason" <mason@kernel.org>
Cc: linux-mm@kvack.org, =?utf-8?b?Qm9yaXNsYXYgUGV0a292IChBTUQp?= <bp@alien8.de>, "Mark
 Brown" <broonie@kernel.org>, =?utf-8?b?RGVubmlzIFpob3UgKEZhY2Vib29rKQ==?= <dennisszhou@gmail.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 18:16:30 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B7941C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8uxmwhuwsguyw5ugrfdaodm3p3rmaxfx
X-Rspam-User: 
X-HE-Tag: 1794507392-157293
X-HE-Meta: U2FsdGVkX19RvelLgI/aAl4jDgmFBPgxj5b/D8Er5NJyOHcZ6MD3Nu+jXlovXXzJbgfRUhqLKsAiAaqENT77A4JnSZgyoBwxTnNSr1kxtThvLfy3Ip8LTfzblxkJJg19oLp+iX2oobsVESkaV+n2K8TtKoMewRWIbBYazaqS3UWyhVC/tdLfUKj9bfqi4y7MiyrKVnR5KqZYGOGdWhDTOpIQQjV3jZ6fEEjrUVqbsQXrZ8VCJqWiwUTbb56gj+5HWDJkf7ZdWdohZIvWAHLzhT3rntrOs8EJjs39m/2xHVxS49XE0E6RKhQmeDUX/3Sm2PA/lhkCwVi1HiFbykj5wKflg9H14HIpwGQoRKRyJ/6H+cAc7jWdqdlAiCHq078rVYEUt1JKrusykypBlYY70oFzevTektufqe8qKtt4fBUt8/WuPS5eU/tAtZ45+kl13FhAtV/FKuM1l8dXkHgdwZR2UtZfnNsjKQUdLQ7ztJM7tBPUrdZU0cP3cAWsU9SWFDcIGayJqn3SMo2qq7VKG8l2b1aAYOt/o+ZY+Uo4v9dlNtoZOP0IUBh3OARfnZMtZGqkMyGLEHedi0V8CMo66bOiwEWoP6peP1xsHGSUA/AdY0WwTeny8xlC8y6PlAkyeIQKB0vyNcjyxB+lXgcI581TYeiqVqH2ntXNPIE41We8Nj4M+Qzmo3vfyL9EldGrw9oE2PO5AwYTeH0d5zKJ8dXfTAz/Ss6i09CX2SejHs/06dwAN6uD8YyH7kL6Ie4hm502oiZroRhPJSLHlWopXEkaEJr/Lb1UOlLFEw8MK1abrm7S9+WpnA2kx89a6yXZ8GLovzLc31RNNtmXeJ+hgY8qCTCrjh8VFN0fu5D34ay0juqORfWnMFW4RWBqoMT021CG0Jk2mbkkNgW28BUp+sQeWguUlfPLN6qYOTT0HSY6KvvqLIhuwXIEjbNAHvGlQDPwcpTAp78UBIfnzbd
 QuvkfObr
 DsK6Gl2RfU9TJT6eh2MckEKiRm/pqSDaW3z3/6aIt+KNqdcd56AELPJi0fN4dbiuM81VgQ3vqFeC4rSfNT5ZLwQqrlOprGkneJklBNotFhTAVxWAgdOgKYiqenUBCQ7m7qzlCCl0gu0/x+zrgfZW6uQY/Tr4IRu+SttcDJIL4/nyUqGBn9RRU+wKOfYvizr1H2bTHRvPPBuGq1sZ4BAeAbwv0knD+qpWpdWeNHgu33MWuLRCQXGXn15nJS7+IfWYP8qNDD0VHZ26xtqYnMQxus+Q+uHgSwT8sJUA5axDa74hJ3n+5Z7YTXr/kyHgKrbLYrC8H8b0F3cJZ9EfJnm0uEWxno36irnD5FnGL7Pvd9OfdKKyRokjK/IqeT6dNutUjDKYLijfMybdTgMOZ524VImHVnt4qvLtKMx3AhoOyQgNF9Yc2ddMnrOrNpqoWOxoTJ+RZ+wON4qHwVYWoeHfZzr1HKq64eCy/KP2HIHNZXIq3CMsSdk3pvMRiTe5aoAnUPrQXK4HYXXz7mxm1SdJ/T2M3DFv2mAq3fbwJKMwyd9WFjtjwvquzFGXxp3HziqJSuB2D/uj5uRxfKTW8bo1D/R5DOn95aGrug941wvXP3NDUHNdWWTq8n9PAw6Q3Snw0sqgYyW9MFDMolxetB+4btKRbh1r444OtcH6MLSQNn+Q1EOsvpw69509rAfYgBmchhbj4yBNlnaEfBJyPdcxm7Yr2oIvR+ZMEYVDiyK1Xs/x+ghUzpEpHZy5L7Q==
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
- [Critical] mm/migrate_device: mismatched folio unlock in
  migrate_device_range() [1]
--

commit 2aa24c588f51ec060d531e2046a8a14459e84b99
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/migrate_device: fix use-after-free of the anon rmap

This commit fixes a use-after-free of the anonymous rmap during concurrent
device memory migration and munmap() by pinning the folio's anon_vma
before replacing PTEs and unpinning it after migration PTEs are removed.

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index f5fb7f2d616a1..0f2a2832e0bd1 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
[ ... ]
> @@ -1391,6 +1414,7 @@ EXPORT_SYMBOL(migrate_vma_finalize);
> =20
>  static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>  {
> +	unsigned long src_pfn =3D migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  	struct folio *folio;
> =20
>  	folio =3D folio_get_nontail_page(pfn_to_page(pfn));
> @@ -1402,7 +1426,13 @@ static unsigned long migrate_device_pfn_lock(unsig=
ned long pfn)
>  		return 0;
>  	}
> =20
> -	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
> +	if (!pin_anon_rmap(folio, &src_pfn)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	return src_pfn;
>  }
> =20
>  /**
> @@ -1438,6 +1468,7 @@ int migrate_device_range(unsigned long *src_pfns, u=
nsigned long start,
>  		nr =3D folio_nr_pages(folio);
>  		if (nr > npages - i) {
>  			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> +				unpin_anon_rmap(folio, src_pfns[i]);
>  				folio_unlock(folio);
>  				folio_put(folio);
>  			}

[Severity: Critical]
This problem wasn't introduced by this patch, but can migrate_device_range()
(and migrate_device_pfns() below) unlock and put a stale folio pointer
[1] if the folio splits before migrate_device_pfn_lock() locks it?

Both loops read folio =3D page_folio(page) before acquiring a reference or
lock:

mm/migrate_device.c:migrate_device_range() {
	for (pfn =3D start, i =3D 0; i < npages; pfn++, i++) {
		struct page *page =3D pfn_to_page(pfn);
		struct folio *folio =3D page_folio(page);
		unsigned int nr =3D 1;

		src_pfns[i] =3D migrate_device_pfn_lock(pfn);
		nr =3D folio_nr_pages(folio);
}

If the compound page is split between page_folio(page) and
migrate_device_pfn_lock(), migrate_device_pfn_lock() locks and pins the
newly split folio, while the local folio variable still points to the old
compound head.  When nr > npages - i then triggers, unpin_anon_rmap(),
folio_unlock() and folio_put() operate on that unowned folio=E2=80=94trigge=
ring
VM_BUG_ON_FOLIO(!folio_test_locked(folio)) or use-after-free=E2=80=94while =
leaking
the lock, reference and anon_vma pin on the folio that
migrate_device_pfn_lock() actually locked.

[1] https://sashiko.dev/#/bug/linux-3f86966c-016e-475f-8285-11a7bf55a821

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-mason-migr=
ate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=3D9

