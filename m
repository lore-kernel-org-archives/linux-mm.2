Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A25606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IfekWsu3
Received: by kanga.kvack.org (Postfix)
	id 02CF36B05B9; Thu, 12 Nov 2026 13:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0042A6B05BA; Thu, 12 Nov 2026 13:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F666B05BB; Thu, 12 Nov 2026 13:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE3246B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:44:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54542160681
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:44:33 +0000 (UTC)
X-FDA: 85427342826.27.B2F4FFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD0441C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:44:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfekWsu3;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794509071;
	b=jsaj5lna+ay0VbviSr0QwJ31S2fUfUGpC2e11vTwE6k55bzbepw62IZKrjNK/9qirZ4Z79
	f44Zu/mo3F51aSD4XJgluEVUVYAx0xYJynrGlgS77LtGEXUtNZP22xG31xiYET70D6Ka/U
	Aur4pF34i7i9qjWxftEROpZeos+um74=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IfekWsu3;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794509071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVyxm9yaGZWP8LbX6unRU3C9T3kyos1eNHeAHWcUH10=;
	b=1bSNhsoEbcFJ6gwaw7EaqyUKumj2TudTwWOOBmIYIhbIziOiHSG3z8WRCnDQ5qmaQ4LNqV
	bj/SWwbfxZMO9d3VugJWC0rtoUAILO8jl7PmLxZpglGByOjmpepJjTzA1x/ae4OKCgzqVs
	z7EvKvtcdEtn6gqkxb/NPn0PnTkEmlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98043401BE;
	Thu, 12 Nov 2026 18:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290661F000C4;
	Thu, 12 Nov 2026 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794509070;
	bh=RVyxm9yaGZWP8LbX6unRU3C9T3kyos1eNHeAHWcUH10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IfekWsu39i1JQlysaLelamEDce3mX/T7a+MM6jLQ23+ntbG4nbY0G5S/Lv4HVkhb8
	 hANWWpY4XTjPFEj3opi/JbeRPS5SEAFmg8zTDptkYUJq7aeaOULxWSvaTxhnsRlm90
	 CMO4SkFhguxwYJTQvhELQzwZHqcDrOpHeBHrkfNaeNu2KlfTNfW5VbPkUPn9tovxzp
	 it55e/HuR5X/w88jMgBdYZjxKr2A16hdeczwJeF+FGxBsmewlBwKwhwpP8JzCTzWuo
	 MVVy99BtjxSiUbQyAdl0bEID+QtaMXFY55LZHLd30/BnwjGy+QubFLS5yOIjpH7RI7
	 eHg0AiNXWaZUg==
Date: Thu, 12 Nov 2026 18:44:18 +0000
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
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
Message-ID: <avYG7CtQ52v3I8tF@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
X-Stat-Signature: b4ecdwisrizoipnwxpju6e4m79qdhx93
X-Rspamd-Queue-Id: AD0441C0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794509071-712984
X-HE-Meta: U2FsdGVkX1+FjGoNt0g8EQeyUJH0y18BA9xFP8Vunl5gvisC+qK24+26m3BZGiSsm6ZHx7TyOoLsBYQlV4wK3uHs5LOT6eMzCOkY2pTmPqEuYiM2He07NeKSrYKC1ZEivKw2PD2za2JgBM+f6LIWro/OZ3e5WIXlfZuulFbYSgjaBC36ajFzJFul5c/RJy5K3Geb7A2Oxv1zCp8HU7oPM+cCb28dcaXKbue2jizZsVxpIpJnwBgOi19c82FA0C8cBjh6d89omRPOpYP7ZjdaxPG6xpVIjWwcKNGXm7WtwWQtQgC78FQGG5pUBYu0Jy2sLNEdWH37yYMTHkQYL0Fk9xaDqbQzUbAHcY4f32qGZ9J5ekaCmhiWJM/rFUno9idtrtGHtfBgpqbiGouxvN/KstJQ1q1GpCNEjHlhBEHN4RCcDN/uCBZzEBy3oBdciN+usDeK14nJ3yT8ciBgsrIwQgXWMABm2AMaMQ6xSSMJZH82k0PsANnz8jWMgN9eegQFRzUhlD/8ozahPNBaNwSnLgoKC+ahKSVXcdJYjlGlxxK0K3gNw3rCfL6EBou3iFnzTD9qy8zzLOKfAEAFEOBH5TYt2ysiP9b9hBst4k+i3GciGCPAmkIoqY4NGhf5Sylj1LGsljOiHlUOlBBlrodVfS+F45R47nvRFSgANr87u7cQp7MBUpTVhZfw/CEV6MB2CZZ2qH/TLE0x5n96aBpVlq0/jNBivg1/tFPv6Nn2ErQeEYbDrvONbJ8mtkbaXMgvRK9wgrLmUHzkrAMlPb7ZyT9clZZwUvzsK1LvIFtaSdQABS4K10QwpzF6rq2oeemdHbQLB8ExBZJwgLrzlms05Zp4QxFrypKIECXVMbaJKtTV2zuuLmuLlBCjoEdoeIcCyBAPXXN69JgG5NPZQpcRHbEM0V+wOc1kUXGH0iD+3b0Wtr2KZ5S+g2p160MhewoJmJ/5BCuFy3WBYUdCcsu
 bxJE9i+8
 eoPxVdL9nT89V34e5pGQNWisns+oKN7mCGgnGiiRz0LFfp5SXJbBgN6ZP5U0h6656Zep9+JCVZF7r1By+jI3exx1FbYQTJFmOO+1f9bANov30DcEGsN5x8v7ZCZgVUfTp+lOslVk5BP0FtseV+tGLxEyclJMMz7hxQykinRZI4nt3iMeQLYYPdfBX8OH5x5VjJQKegfxX/ankvGg6xa0tgR5orVNGiSsYH27R78pjGseU0eoG0x6FxdzQeuSKnJ7y5hTrzneNa54sEUi7eD8w6dX66bPcTvZD0Hdu7GPNyYxIRJBxu/CLFg9tj4t/5npx3dHC73bykq64UwgVLhaGRDBDDwmSRqR6XCUp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:12PM -0500, Tal Zussman wrote:
> remove_migration_pte() makes the restored PTE writable for a writable
> migration entry, and only looks at the uffd bit of the entry otherwise.
> A writable migration entry that has the uffd bit set is therefore
> restored as a writable PTE without the uffd bit, and the page is no
> longer write-protected.

The UFFD WP bit is such a terrible, invasive, broken piece
of... engineering :)

Notice, again, the hallmark of an utterly broken abstraction - every user
just has to happen to know to handle each of your weird edge cases every
single time they happen to interact with anything that touches it.

I do hope we never merge something as bad as this again.

>
> An entry with the uffd bit set must be restored write-protected, whether
> the entry is writable or not. remove_migration_pmd() gets this right: it

Sigh :)

> makes the PMD writable and sets the uffd bit as two independent steps,
> and pmd_mkuffd() write-protects the result. To fix it, do the same at
> the PTE level, where pte_mkuffd() write-protects the PTE as well.
>
> The only known path that created such entries is PAGEMAP_SCAN. Now that

Wait what? :)

How does a read-only scan of entries create softleaf entries?

I think this should be explained in the commit message :)

> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
> longer see them, so this change alone should not be visible to
> userspace. If another path ever creates a writable migration entry with
> the uffd bit set, the page now stays write-protected instead of losing
> the uffd bit.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")

This seems like a super-weird fixes target.

BTW I've noticed you've not been cc'ing stable, is that on purpose? No
autosel in mm so we do need to do that on stuff intended to get backported.
:)

> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

The change itself seems reasonable, as cursed as the reason for it is, so
with the fixes target confirmed + commit message updated:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 28a8d7734735..d200f64b5f98 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
>
>  		if (softleaf_is_migration_write(entry))
>  			pte = pte_mkwrite(pte, vma);
> -		else if (pte_swp_uffd(old_pte))
> +		if (pte_swp_uffd(old_pte))
>  			pte = pte_mkuffd(pte);
>
>  		/* See do_swap_page(): restore PAGE_NONE for RWP */
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

