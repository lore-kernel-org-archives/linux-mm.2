Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7543C6070F15
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfSfqxDU
Received: by kanga.kvack.org (Postfix)
	id 6FDBB6B00EF; Thu, 12 Nov 2026 12:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5A46B05B0; Thu, 12 Nov 2026 12:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613156B05B6; Thu, 12 Nov 2026 12:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB676B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:57:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D739CA06D5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:05 +0000 (UTC)
X-FDA: 85427223210.25.D072A26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F87E120008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfSfqxDU;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506224;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nB6hPprS+llYkXWb/U1zj7NmcL89zt3qqGbMMNVXtJE=;
	b=mgFd+9ZNSdYsuH6E/gHxrlkKtsxLT4mZXmftSlPhljOYWqMaTi3io8qhWqZ8CNQIHoNgWK
	ycninLb3uVLrlkf3zO2B4uy7tH4M9dvSMkVp9XLcSHwrVh/FAc0CbmggW9x9fEsh0AkIke
	Npm+Ixx5zmYGqIeF7H2tTQcY/hf6Wq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506224;
	b=3bopCi/YScQdsHSXEo7reg5g0pdq2qDfhXiKSsiYod0eyKPPexGZKshrgnJVc+FVY0ZaJa
	CCP0YUDqzQFIr7GgYbq0mwf+HCV+epaf6ckYAIZ8ppFW+qKnNrEd0QgzP9QrpY3kvBji4F
	N4/vGfN4nSfNJ6MyijCDi0PcsRbAFCE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfSfqxDU;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FE70623BD;
	Thu, 12 Nov 2026 17:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867951F000C9;
	Thu, 12 Nov 2026 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506223;
	bh=nB6hPprS+llYkXWb/U1zj7NmcL89zt3qqGbMMNVXtJE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OfSfqxDUSvFb8JdopGOuDBFPNtiV4IM2rad5pKAEUqZ2Ts8xfKaCC9dUS+bYbevIi
	 Lh8O7pSt69Ul/HYeuTRTmLPZWwbLvG/jS08TQitRFbAcqB877jA/aUu4WqfPI3WqVn
	 T3NMKHU2agWFIuJ/UKfuSNQXgtamF/XKY9sJf/3Z0dvdwboP77V7jQji4xQA6XeWBW
	 SQlUcablB7osoZwqUIgobwtEfT/GD35J88ei3r8IulZWQcYHhGcKpaziB97TY87dhD
	 2E9Hf31mG9STZjs8q2Hzu8lA+1/Nqsr2culXUkihjWIjXb3Ymbfm3HsCLp1WDCZV4d
	 gDGz9xZ7KpgaQ==
Message-ID: <sashiko-outbox-211644@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/12] userfaultfd: refuse UFFDIO_MOVE into a
 non-present huge destination PMD
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
In-Reply-To: <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:56:58 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 8mx668mikrg9sri7xkjgs9ps1yi397ct
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3F87E120008
X-Rspam-User: 
X-HE-Tag: 1794506224-287539
X-HE-Meta: U2FsdGVkX194y6CJwto7zD9igMnoqBJkoKSDlxWXNyUNhpmNuUygTK8sUHJKylGhkvbN1keV/+Kew6idAcWOSqxb3XsXr51W4KNNZg92vPX6QpDZDqmtbvyv6DN/38UogqEmfAH4Q/LaZ2AKRBOIXZ9UGmaPw6bivJKkEazY8Kpnkt50jdMnQ1FKzvlNVnz/dYKaCx1GGRWyIbLVYtm+npCsvdchpmfIlMTbrkBf0gBIziJUpESckfUWr4mwuUW80oQwEpabx33RUH3yJacnH2cOB4gEduLj34vGghpuYW5faq5bVVxsgMdBB0e9NlrfWRIS+egDuO0viwIBxbNrPSeUgcjX8lWWxEp5ogA8UOCSa0H1PIGiaZ/iWOhGHEVYGKU8oIas7eHVMOUiEDGB+Rg9uflEPjwNMz2gm1C7l30PyBzgkigC7Gdy7dvPOEfS+4/BbzpwrhxMLj+i70V5hxCsChObGX1JyJ8+r0uWzdywVUBhelsIYucM1mODTyuFnxv5jS2mMP3cr8NX33D2PRLCParp5Tki+B6RMXxA3dP7MqW+eoeJjwbkZoC6HZZ3PQH1uUx0OkW9sFKW24LFsBTTFmISOea67bMLOJuYnUdRXRWt+jvWLmwkKhHB1F/YC24XgkVSQINwXVpFcnOW1HtsuUjOodHICzNj1a/HmhlPpxRFOz4A6eCXtVLauqHskW8IoJkYBiG/nL0o7aRLgTu82WtEBjOE4JBSU1MPdJrBH/gWYb8maamDDKWqRp1a4hY4LcsZXXQ8R0m70sJRF7kE4WVmy5qGkKM8Ug1jXNewjm4utro6ZJjJmecPClbNv/2w02kPlc7+VAotNi1/RWHfwoUkXbC5ZvjGxhv6zzk2ACZcprpBUUJmZHOMHFZrbwmtpYNMZOvDnc11cKqxKSsXaR09u9daNrks3s5+d1adUHtyL/2giFk9O4+9dw4YPH/p1/ZbkxwVWRdN1FG
 akniIJ+2
 XmkMTCskWQA+M56T7x80OSdTcoIyhPazdVhZubsW19NRa/Mubmhk+LUg9Ra6K/Fw/SsZv+uqd/XH2n8KnJV7+s0CAiWlb9/CK8iRP/Y4CdreDZjHyr/kIornhlqHL4vCk72nJ0W7eFUH0Dc9+Tas0vBRUvZhY9MgnyFZidqs7THAU876mP862k5lyLuEoFNptVLd7pbOz0jBRXK40I7rJQm57HuiyseYTK1dCNS1DLn0iJYU9RPNs3MJuTyn/3SMGnQ8+gCULAVDbNBn79zrdfYceMYRGgpiPvQuS51GxUR6EfmfiJcyg73BL2j/d4fO07UHYorUsiSx9JN+rSPyjj4FABUm4lQE5AcCDhEeHlnFXE0XwiyDLNAndSnG3aQ5+oHkS6i4sa8GJdwVI80KgX1kcQcWMsGRfMjYBZA3CkJafIbghD/AJyvRoVp8oc7shwBxwoIlu/ZiOPkfrxDDAikZeIJXTLwXWtWCQtlA+6iWw1wuY1GFyq05Uobymp717EDOjcAvjHSE2ffIW/zbGWs0k+BF4mr1IQT5KSFTFTefEqkxsWSDecKOoHxVtdvYz1WV+PPZiRD4CNyjPK5mTOPsuAXYDzmBms8Szjv6zjLvO4lZ+kOROkEeOntIE8Z94IqsoI1AUeziY8I5TF11shPmvHPdS/2oUoZN+QXuNofoJwK6poMqOqHakgA==
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
- [Medium] userfaultfd: spurious -EFAULT for WP markers in
  move_pages_ptes() [1]
--

commit cae4a6b3bdb227f2a82bf72d15644fbdf0a7b4b5
Author: Tal Zussman <tz2294@columbia.edu>

userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD

This commit changes move_pages() to check the destination PMD with
pmd_is_huge() instead of pmd_trans_huge() so that UFFDIO_MOVE returns -EEXI=
ST
for non-present huge PMD leaves such as device-private THPs or THPs under
migration.

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 61a712e1f9f53..ad9d243dc64b0 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2021,12 +2021,13 @@ static ssize_t move_pages(struct userfaultfd_ctx =
*ctx, unsigned long dst_start,
> =20
>  		dst_pmdval =3D pmdp_get_lockless(dst_pmd);
>  		/*
> -		 * If the dst_pmd is mapped as THP don't override it and just
> -		 * be strict. If dst_pmd changes into TPH after this check, the
> -		 * move_pages_huge_pmd() will detect the change and retry
> -		 * while move_pages_pte() will detect the change and fail.
> +		 * If the dst_pmd is a huge leaf, present or not, don't
> +		 * override it and just be strict. If dst_pmd changes into a
> +		 * leaf after this check, move_pages_huge_pmd() will detect the
> +		 * change and retry while move_pages_ptes() will fail to map
> +		 * the PTE table and the next iteration will see the leaf.
>  		 */
> -		if (unlikely(pmd_trans_huge(dst_pmdval))) {
> +		if (unlikely(pmd_is_huge(dst_pmdval))) {
>  			err =3D -EEXIST;
>  			break;
>  		}

[Severity: Medium]
This problem wasn't introduced by this patch, but does move_pages_ptes()
return a spurious -EFAULT [1] when UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES
encounters an unpopulated PTE carrying a UFFD write-protect marker?

mm/userfaultfd.c:move_pages_ptes() {
	...
	if (pte_none(orig_src_pte)) {
		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
			ret =3D -ENOENT;
		else /* nothing to do to move a hole */
			ret =3D PAGE_SIZE;
		goto out;
	}
	...
	if (pte_present(orig_src_pte)) {
		...
	} else { /* !pte_present() */
		struct folio *folio =3D NULL;
		const softleaf_t entry =3D softleaf_from_pte(orig_src_pte);

		if (softleaf_is_migration(entry)) {
			...
		} else if (!softleaf_is_swap(entry)) {
			ret =3D -EFAULT;
			goto out;
		}
	...
}

Because a UFFD WP marker is a non-zero PTE entry, pte_none(orig_src_pte) is
false and execution falls through to the non-present branch.  PTE markers a=
re
not swap entries, so softleaf_is_swap(entry) is also false and
move_pages_ptes() aborts the move with -EFAULT instead of handling the
write-protected hole.

[1] https://sashiko.dev/#/bug/linux-5f33b673-0c7c-4b59-b85e-71d45e428896

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-uffd-state=
-fixes-v1-0-00713d368976@columbia.edu?part=3D2

