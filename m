Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C948606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QSd4A21L
Received: by kanga.kvack.org (Postfix)
	id 2FBEB6B05C8; Thu, 12 Nov 2026 14:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285FC6B05D1; Thu, 12 Nov 2026 14:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E566B05D9; Thu, 12 Nov 2026 14:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6C5C6B05C8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:34:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5555080E56
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:34:55 +0000 (UTC)
X-FDA: 85427469750.04.342FA02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF55CC000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:34:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSd4A21L;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794512093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fzt2dBpdapix7RUmqVUPHjVh/havNMakXElf23OCC/4=;
	b=gKDRDqbd7xOvmPzxYDuYkGbvNIThOXlauDZrIhcv9Ei9DG1md4vet4DFC+HgI1GlWogYVL
	+Xil05rvdryEsxTORNoMRq+kBC4WmOJbvrGmyTw0tGGXBZ0XLKN6rw+iC9c/TIe73ez177
	JAwXlcL2Zwmb4evUU5LLmYPL3iU6ZA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794512093;
	b=oxSor3sERbKxVQDyItjX3dc2ijvNnE4hS8hbBr4LW2proX2AZDwoTe52dG1u1lggjVEdV6
	Y8jeVx+fnSGx5xUpD3QILFKjca87VKTU06BLs08xutK1AtHPrqNcTwO+C90r7gFl4JeHLE
	WbgZ86bsL/u3ZSv4USV9KJB0X67KSxI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QSd4A21L;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BBC8C44DF6;
	Thu, 12 Nov 2026 19:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610C81F000C4;
	Thu, 12 Nov 2026 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794512092;
	bh=Fzt2dBpdapix7RUmqVUPHjVh/havNMakXElf23OCC/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QSd4A21LzwNBycHbPA4kAqRX5meE3MjPkelVRq7bVzJnzVClKcn5Rpr/Dz7z7OsGO
	 oZy+xADrRy820imjvS0gZLtsV+heBChFRdXOemxl34mSppcJtkIO4xVrdAmjE3y6bh
	 X07QO41a3RVk7RmEXR774gpusHa7lhyPnOgyVs3TqlD7vJk0eccf42cmu7SnHo+i2w
	 IIwLP9dysThVv1/5Cx0YVQPODydwdMZweFry0TINNiHYUSbBisC2LYqL1eVOP59B2p
	 nYXkYsy7sFwEG04WUPqYH7nHz3Hnmwb3x2pV7QyGbcTSq5PJuZy3TnoHCuWS0TKWHZ
	 Rvu//kCeePTkA==
Date: Thu, 12 Nov 2026 19:34:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
Message-ID: <avYQteUm963AKJQ7@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
X-Rspamd-Server: rspam06
X-Stat-Signature: 4moczr13zso3e47b8iuwb4i3mem3jiki
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AF55CC000A
X-Rspam-User: 
X-HE-Tag: 1794512093-221580
X-HE-Meta: U2FsdGVkX1+/HZg4o0Thh9OieK/kECG2XXre0Sids0W9VAPz+L1QfS6tKGnP4brnXHPAF6HBkO23rEnSu5zt8q2dtX+zZgVYpB5DsfjeLSO8yqqDfyI/PNdJ/aL1D8BXk7HbkXUzDTImkgfS/DSCTozMeWor1mh62xN8c/zGT3qkOYu1RG5sMo7IuexJp5tSUyvfl8vjXwE5OCpwd4jYHBttKZ4EqMrl+wTxWGHeoIJNECoVH02382bB8cwVnBUTPxVilvhW0ifYMXw3Du9HdadsThOfgbCUOT0O52ehOkpV6SIliazTXGohYDuajSlCO6bCm1bKLSEUjCNjM/xy1VaTLiUiDkcVjm+HWln7P5piUD2RnPSSnSleWzzWIRdz2PJofnm1RNOT40C+sqfP0ig7WhOJUdnbmjmKWstat29ZGnK32u2KPhBn0ANyo1X0lFh5spPulA82iNXRfEdBBbaa0Uh78qhlZcE3DJADNTbgpDMEg0o/8W/rEPAMSVONSeuBAYtRB5XBU+euacgMch0uyHXJxt9uQCgKJUtGs6Y1ltbCcN8i3we25h9Kb8qyn7YGWr/KZT++3VC/1QTt3rKf1idQxeV1zob4hRhQ7JY8NO1wECwwu0yR49YkNAz0oc//nhIBPAXLau3PUZ7XHrWLwju3huLA3VaymZOagUMUcHui+51h/pRsOrNf7B6vaNPvT0avcJ//CJVS4HNJY3m3x7t42CZ8s+CT2mT9oEt7BWI0i9ihquyr/8wcOMh7218WHLisJSE48AGw0hWy7P8FUpOlhPinTNRaQbAq5WSyMBESFHzZxpPFmg642uQWH4AEtpp4FhQlvKOmMqEuRHg9hmJWnutySHPNerua/ZWc9QEe5y/bG3T4R6MLBEz4i9VA5gyczNQ0sqsIgzyDJPTze4eyhW9AYW28CVhI4/FpvaxlvLpfl5bIGfWBVPce0iUY20u6Bt6l72/3OGz
 9t2LPKdy
 RPqH5f3Zc56zRoPMIzUrwjrJHKM2XgcdFg1pcUtGmu2f8/e4poh/WyCkyaJBcRn7i9/IrxmtAutYlJ0hsYrOBXqWEmR6VkshcBzPzMWDSE8IAEikPQRj5AGuyLkmG/uiKLHMP1v4ZOdrU1PQ+2ELN9/R+yC/DqSdqvRu96Qy44PDG5Om6X5pZON+04DRv6WjQnCh+G8RiieTz1m8I56eUKsvsOjiEAj8I8n0J52cWUYJmOFMsR66/5TTKkWr8hlVaYS+ATALHlNnZUvkHfpFci8URs/ns9qxA2OyiQAva6fO89x/XRjuZktndYOtjyCRN/NVRYwvwoB7XFYI7ywbVjiGU1LhvUhZqOm8mTsn4Mf+YMyXsocT+VESIZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:13PM -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
> make_uffd_wp_pmd(), which handles a present THP and a migration entry

It's crazy to me that we write-protect page tables through a procfs interface
like this. But I guess we have to live with it now.

I suppose that answers my q about this on a previous commit...

> but does nothing for a device-private THP. The PMD never gets the uffd
> bit.

Sigh yeah. Device-private feels like another 'just have to happen to know to
update X million open-coded parts of the code'.

We really need to find a way to abstract this stuff.

>
> pagemap_thp_category() reports a non-present PMD without the uffd bit as
> written. A user tracking writes with async uffd-wp therefore sees every
> page of a device-private THP as written on every scan, whether it was
> written to or not. This requires a driver that migrates THPs to device
> memory.
>
> A device-private PMD must be write-protected like any other huge PMD. To
> fix it, pass it to set_uffd_wp_swp_pmd() as well, which downgrades a
> writable entry and sets the uffd bit. When the THP migrates back,
> set_pmd_migration_entry() carries the uffd bit over to the migration
> entry, so the write protection is kept.
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/proc/task_mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 53780a454432..752f1b13d47a 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2524,7 +2524,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
>  		pmd = pmd_mkuffd(old);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
> -	} else if (pmd_is_migration_entry(pmd)) {
> +	} else if (pmd_is_migration_entry(pmd) ||
> +		   pmd_is_device_private_entry(pmd)) {

Could this not just be !pmd_none() + cover all softleaf entries? Or is that not
valid?

It seems completely insane to have to specifically spell out all the
possibilities, open-coded, everywhere.

>  		pmd = set_uffd_wp_swp_pmd(pmd);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>  	}
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

