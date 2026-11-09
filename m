Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A14D606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=enbruW79
Received: by kanga.kvack.org (Postfix)
	id A88766B05BC; Mon,  9 Nov 2026 05:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BDC6B05BD; Mon,  9 Nov 2026 05:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9FE6B05BE; Mon,  9 Nov 2026 05:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 620686B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:43:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5ECB1A064C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:21 +0000 (UTC)
X-FDA: 85415243802.06.D1F25F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 59E5540006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=enbruW79;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794221000;
	b=Iby5BZnvNfAP9B3lvD01cX3MMnLDjkua7eyAEnBfh4aL372yYbHwBg9IZCqZDVWVCIv5or
	7mVb9blQS+JCQDnAQ4cPU4uaUe/ROWsRvuPSTmo419DrktFqQlPEJaWfc2AojbscM5gvtZ
	F0QH03j0V2/ECd2x+UYc2Kmp6OxtJ/k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=enbruW79;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794221000;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhFAW5PxtSKAtdD/KHcxZtFautau4/xqJ1Of90u6q+g=;
	b=H/ZyPpX18KO0O4dh6LzN0PIFjp7cYeAHk+hS9HcaBvXh44mdGuzDnBAa5arc3DjsFd1SB/
	H+vK4635sMLTx3WtWtkSm4tbvUHjxMwkAdYTO+aDO5XTDhGoQ1IAdH1gJfBnlmS2rCyMeH
	XBnphRuPxDi2yHGTxyWHfmhg7AMvH9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00B3C6186C;
	Mon,  9 Nov 2026 10:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B91F0089F;
	Mon,  9 Nov 2026 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794220999;
	bh=WhFAW5PxtSKAtdD/KHcxZtFautau4/xqJ1Of90u6q+g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=enbruW79YdTm5B87eZEE9EjfYLDAoqOMnY7yg0+4U3zlcsumXWVFYWxsoGdCAYR4o
	 i3inxbdnOk/9VncXz8a8ViJyuqIP8ru8v9WXP+LPbOt3zvSVG/g7E/1/M1uFUjroTL
	 9BFVej0rRnlmPjTPHm3ff5T7h+NrkOECG/a8kyLyiF8Y3QWGOxEkIP+unoculK9i5o
	 3vj0e5pGCCghwCNUdL51Ud2EzkTYGE/UwmO8cX9uSc88Pr6DMe9/48aOHEMELSfIiF
	 S50KJLPyoCaYoybQqH6+RG/AjA01m+vLpKoxkmmhNvcUdpGWxtVhl0y/KXpQBdpPxH
	 I2Q34JYY+A8UA==
Message-ID: <sashiko-outbox-204845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/11] mm/mm_init: move pageblock migratetype init to
 memmap helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "James
 Houghton" <jthoughton@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261109095807.41547-12-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:43:18 +0000
X-Stat-Signature: nt1r6owyfagu8i9sqy7qaj6dshqefc96
X-Rspamd-Queue-Id: 59E5540006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794221000-717588
X-HE-Meta: U2FsdGVkX19XvY46LfXi2EFxQ9SZypSq+5iyBuL5cGfbvdpMpG/DBkCbecujjK5Muj4WxHLl35HODSTGiyiLP4Egl8/pbBqgiYe6CxM8SAhT+BRO47PL4jr62OQLswIUMen7iBF3Zsjt9G6nj/nsUU2jWRBqt6RsHoR3KvUedcyO292LvfClPwDmZL7ix48dYsKlwKEe/SbKj8mb4POztzNAs1ufkkhShWd6G4iNdaP+k1B2IP/Pp9Cyna+dCFq/TyM23hrzOu1FbRI1vTElA5boEsnX6pSoCILbP46gcMY1DLgZ+4Ji6Au8zGQFPz4Rks1k0BVZ466ejt9JNK4WezFKerWUCzrxxbiUSaxKanfRqXGHUf4JpB/Y2q0Q4sPUn/K+OtM1kzyiXVoiw0HiszJUXH9rYJY/OCGJBbr1miAkhbeSw7r0LdMK6Coh+Ej8+WPiIcvsG4KJJJlxECEYVALj1pkRLQAHdmDpyWnuK1BsFQMPMIljDNOVVH/OBoNc5QUwqPe8ZdbQpnSLp63ArLMCPAguSnRpsL+vNR4a+jtKghlMHMO1GLZB3WFFgm9OQ9UvgVuErItXEs85nrvlT6nFGrli+9NaDrU00nBDsWaXrE95ZTvkcH0F/W505k6LiF7ffV6FW3tdkPNnelbVj/KRsnXd/ih2pastKFrzGSxDt5WcOaOQC/rEG1yHloOLCYYrrEpRKOuHBWw+Nxkg1uSpnopsfbKXa6rQ/0JdDgBq3RBFbUa5Qy0fpcVG1qXOBIX7KC+JJ86mZ1RbKbwxzit4kpgBk6DpIFkysjXCWfUDLEgyVEgPhYnhUV4B+0+8IOKzqHbrdU9q4k7sM3fsfEmv22Sad+e5UiVhVZOkeDDadHT/cZ8hOZeBA+tLBGjLVNPuX28KXpZ+wbctEjSPd63EjzoF6Lj4htbUf33/CKsgVg3nFEPc0lAu27EAf27s9cvc3odSTKbwUuQXe8u
 pg06/vDE
 3p5Nr1mIM1Jhlyx5KxBKzA7NiQfMrtW7qfEXT+aPfLEmIbf09k3FKFkzm0ZEy+vgEh9ddtkyAfGyndwnnClarrxHYrCBSiOgRhVeoCUgGEMqSEDnyRVU4CYysUJKJGOVNKBQE2cK/sDV+MpCOlMmMEyD8TclKXcRTNPgvZ8+JWPogdtHIxOnIxbt2DUbFWw7awQ7uMTurB6D6VWNmQ+ED2HTGYWr6fmBE9WBYN3LrM7zvFuNQzo+hFwoNUTPWbWEbx/WFguujZOsfvwkEki6H44BbUBHCXkKtecdhWCTaEIbszruL8R2vwZYj3WnnXe/EPae1QebEayS7fHYmmUcO28VwGk4UgMSkXzY5BAVOFMX6Hvuc2BZL/Pv7sUnVF+cT+v16cpIWumvFIsVmPskHejYPEw8pCYzFRM9k2w7FO6a/fBMi14Qgshqg8JeJ6rs5jFgKdGXsG91NpMXXYHsKXzKknRO1b9SA8G9k4WfOdKQOiB1LVJ0wZ6hHTXTemQtepX9TtHv49ybrskVB4dmM0l0P8Fs3NaSCPzrHqTo+ySP/6jtE7VYNrHaWhNYHTkHa0pOgS0XuwTL/5KMVQLVPkVtTIPnv5m+fd2pK1CtV6H1Incd9W+DXd/zUJWa5b8wyQaUl
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
- [Low] mm/mm_init: commit message cites nonexistent
  memmap_init_page_frozen()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] mm: uninitialized migratetype in
  pageblock_migratetype_init_range() [1]
--

commit e81bf248ba8e6f6857b5a558e23fdf0fa0e68ad6
Author: Muchun Song <muchun.song@linux.dev>

mm/mm_init: move pageblock migratetype init to memmap helpers

This commit moves MIGRATE_MOVABLE pageblock initialization into
memmap_init_compound_page_frozen() and memmap_init_zone_device_basepages(),
and removes hugetlb_bootmem_init_migratetype().

> Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
> initialization helpers instead. This makes memmap_init_page_frozen()
> initialize the pageblock for single pages and
> memmap_init_compound_page_frozen() initialize the whole range for compound
> pages, so the ZONE_DEVICE and hugetlb bootmem paths can share the same
> initialization.

[Severity: Low]
This isn't a bug, but the commit message mentions a nonexistent
memmap_init_page_frozen() helper.  The patch updates
memmap_init_zone_device_basepages() to initialize the pageblock range for
ZONE_DEVICE base pages instead.

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 61a720bb44dce..e05db8abde2fd 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -751,6 +751,9 @@ void __meminit memmap_init_compound_page_frozen(struc=
t page *head,
>  	for (unsigned long i =3D 1; i < nr_pages; i++)
>  		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
>  	prep_compound_head(head, order);
> +
> +	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
> +					 /* isolate */ false, /* atomic */ false);
>  }
> =20
>  struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
> @@ -1110,6 +1113,9 @@ static void memmap_init_zone_device_basepages(unsig=
ned long start, unsigned long
>  		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>  			cond_resched();
>  	}
> +
> +	pageblock_migratetype_init_range(start, end - start, MIGRATE_MOVABLE,
> +					 /* isolate */ false, /* atomic */ false);
>  }

[Severity: Critical]
This problem wasn't introduced by this patch, but can
pageblock_migratetype_init_range() leave the first partial pageblock's
migratetype uninitialized [1] when the starting PFN is not aligned to
a pageblock boundary?

mm/mm_init.c:pageblock_migratetype_init_range() {
    ...
	for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D pageblock_nr_pages)=
 {
		enum migratetype mt =3D kho_bootmem_migratetype(pfn, migratetype);

		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
    ...
}

pageblock_align(pfn) rounds the starting PFN upward to the next pageblock
boundary.  When a caller such as ZONE_DEVICE initialization or memory
hotplug passes a range starting in the middle of a pageblock, the loop
skips that initial partial pageblock, leaving its pageblock flags
uninitialized.

[1] https://sashiko.dev/#/bug/linux-492df7cc-d097-43e5-9701-9954aee1d064

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095807.4154=
7-1-songmuchun@bytedance.com?part=3D11

