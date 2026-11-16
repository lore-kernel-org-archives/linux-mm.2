Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B616D606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRBPdCnL
Received: by kanga.kvack.org (Postfix)
	id B8A616B05B0; Mon, 16 Nov 2026 15:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62366B05B6; Mon, 16 Nov 2026 15:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78276B05B7; Mon, 16 Nov 2026 15:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 786266B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:26:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10739120204
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:26:58 +0000 (UTC)
X-FDA: 85442116116.20.9AED874
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3FEEC18000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:26:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRBPdCnL;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860816;
	b=rWnRIUD3U8oxQJmvTUXCSUjWLOlG+007l3yMcHKJ+eAodRMpxsQpz8KBzXl6xIZF9IvX7n
	JSUt8pSVVUWIKm7ddsNNGesVwU3YuapXoobDiDPhWD5deLGsGofj+w678cqnzDVCklJJgH
	sqSVQ1xkJN/CjIrKYymp2Jz+3cE1TyQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRBPdCnL;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaaaDQoV729o0ScmVfuhaqpe8ALtcszXY40XnBdAgAE=;
	b=TyyJ5yOQWQM1ax378hThb9wR5i7lm+LEMGtfH3O1O3kanDVdUFK3iS62X8bpl3Y84pOine
	ErY5M2vjrfuFWk5VVIO93BH77CTg9i1kXD64d6HREvSanOC7hV42u7hdcoxg2vqe1Bdo6F
	rLKgsAc7jQJZ1wtkmFnkHb0iv1+zHbI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69F6A41130;
	Mon, 16 Nov 2026 20:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFA81F000C4;
	Mon, 16 Nov 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860815;
	bh=YaaaDQoV729o0ScmVfuhaqpe8ALtcszXY40XnBdAgAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jRBPdCnLB9B4oaQmNToTM9trKEppy0Ykfstc+ndfbgJE2FE8fx5W94InNfmEu5m4w
	 6KJDMR1c/mJJBhGjPGvwoPZUn2FOlyI+m4WCZO5pFRChioiE+bfQvyGNY/c/sMk2IX
	 Ty+YuY+KbDmAbv5bA787phrN9bix9+gw6HnDKh4icOIs+G719mbSyCaGwMRcPzE8jP
	 LEyo/bmkWLOnATNxjGyibKcZlj4tYfiC7ZMlBNRIVF+yMZ2/ImCNRZD9fZ9PsHnwLj
	 eS25I4spV4kbxofFIMBqG/ZYKR51HCQd8apSGoapmDnF4gyI2Z4t67XtOgiuz9lrhR
	 vQVe1Z4uy+Y7g==
Message-ID: <38750bd8-6bb3-40f9-901c-44cef40a9de7@kernel.org>
Date: Mon, 16 Nov 2026 21:26:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-5-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-5-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FEEC18000D
X-Stat-Signature: pdoqepxbqaaqqak4xogiamco1d6ibyag
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794860816-154431
X-HE-Meta: U2FsdGVkX19iuMtXR4gHY0T5JYf+52W7+C39ZmLksw3AfgeAifdqgxBI1iM3R73JaANHt+OBfSens1NLIQ4CsVv0eA2SC97sgTWyAgZNb0JpO5WDG7vP7bOBpkRSWgCTYdk6Jhe98JUlNavVVgFkte4cJwRfntDD2PKemHe/dF9m3BD/2dn03d7gIxJpw5DeZBCmlHmkHmA2P1xfoyqyCkmTk2yZcUvymvQG62S3RgKiNCQxG3elu2G/HRJ/nyjyMc8GLHdwp+iUWbAvaNFHkuQAxQZl5q8ONnIfjnNQpz7Gc5dk63g9ZwZ8OF3C2kxYsOeuOaB439AEBG7QzzjzP3ohnCMPG57nIepzTsH+glZDsaXUog47g3wKJutv7pHv67s0z3ZYo0wbAbIC5tWD2gYQbHLd/yV3dWDk3hZ/YGs/v/6YJtwB7rSTqxmO7B//wwAdyBfQm4D/qwW2H3r2SYXO0NcQYGFGK7GxP4e7TyR5mfQqQuuP1JhzmHnYf7rg1L9KrvHKuPUxG/B6/CNSRr/I6WjMuoN2VTFzUs4/L1iwTxyiz98q4TbhDYWD1Ggw4O/Iryy/mmIN6GRjsI21R5Im0+6n6E7RA5rYNhu5PsFqfvPX5y/EjC01EmDL5zcpa/cNdQ3QkfCC/d/HJ9UmTrs79nQ0SzUo8JRo9TfrjaPldterPAVxRQtN/Y6d8o13EeToQoIiKPvKHdQc4LormFOgEn9vbRnYWx+d+sypoUx8ftTdmgMMT6yd1Z26gP3aAeliV2XayV7LXr3NdJv5v5edg02kHTyYGMl4D0GinL4z+6TYW4yYukjix/lKTJXOeDGZfTYwIgvUp0dDw0c/tgaXWfjPisCb3xRgHdIPmJU8x2D5JijXUAjlrLclib2jlet+vJT0eJ2GWPzZSNeCcCOzP/4yvMTRmD9sBUwDniB1BrWaxnDDudwm1D1Nrs4x1hsTARPL0UjOQ0tDYC0
 xlXScFQL
 /b1xAOxUSDL74ZFg4aI5bmLMxjPTScI6FZhAqBGI65g2YT9Bzt5JxN4PRD77koK91WPlz5wLOTI7FZTrKXCnhv2xzp9EokwDl/HM5Xv6OCqUViu3cJSrc4V73R5LyLSIzb83XYm3P/WZtY9qpcEQK3kyjBofEJI6H1Lw1yUsX6WBD5AR28rnZTT5GcAEO/7oBJNJ5G5CgBAZfKUCD8pX/251J4bSJe6V26+bQHQ+AlQ7/bHa40BQG63T72+zvJDO3DTJTRBHwwz13k9kC/M+IFRs6pkP8DOw8t4F9tt4KoAox9d4z6ax7gOemzLds7r2yaD8xGpYmgwkOmz6A56vaDS43Xq4dH6LT450dDGi140bTUTBkErwzS9SlSzF9L82gnmxSzKBuCAu0q/M1ygUTHNvmabl/nc+kLxRKT2UZCd2z9tHl4sgLcHGFjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
> make_uffd_wp_pmd(), which handles a present THP and a migration entry
> but does nothing for a device-private THP. The PMD never gets the uffd
> bit.
> 
> pagemap_thp_category() reports a non-present PMD without the uffd bit as
> written. A user tracking writes with async uffd-wp therefore sees every
> page of a device-private THP as written on every scan, whether it was
> written to or not. This requires a driver that migrates THPs to device
> memory.
> 
> A device-private PMD must be write-protected like any other huge PMD. To
> fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
> not only a migration entry. It downgrades a writable entry and sets the
> uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
> the uffd bit over to the migration entry, so the write protection is
> kept.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/proc/task_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index ee7f509d376e..013eeea7d1a3 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2520,7 +2520,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
>  		pmd = pmd_mkuffd(old);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
> -	} else if (pmd_is_migration_entry(pmd)) {
> +	} else if (pmd_is_valid_softleaf(pmd)) {
>  		pmd = set_uffd_wp_softleaf_pmd(pmd);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>  	}
> 

This really should be squashed int #3 I think. Or what's the reason for keeping
this separate?

-- 
Cheers,

David

