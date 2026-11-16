Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EED9606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVmSrkjP
Received: by kanga.kvack.org (Postfix)
	id 51C7F6B05B1; Mon, 16 Nov 2026 09:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4026B05B2; Mon, 16 Nov 2026 09:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433706B05B3; Mon, 16 Nov 2026 09:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 200D76B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:50:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 870AB1C04C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:50:35 +0000 (UTC)
X-FDA: 85441268430.14.97DBB8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D54DE10000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:50:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVmSrkjP;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840634;
	b=lrwbW6wO1ItcIE+ECyl2egvAyVg7aaTWbEY2Pqq7JENUX7yv48mvvNi1X0PD//FgsgnLcP
	T2W9T38mOc/3ju/u6XaDFA8aCkLJKTdMaI/FSVZMnou20LjKNKjvPtlOni47uTh2B0AbBv
	vBGasy7HaFDAqUyp7CHo9XUEug83scM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVmSrkjP;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nESxvsGwuM07nY0gJtiknNvC5SRahIhddedMqxw1kZQ=;
	b=ulDvghUu5kcDxDIvIPlk1D2CyIVvSK5I4phujka4+HJqX1gCUH6eibqM1EVaIedydDQ1/Q
	L7NuBvlSuCFSMudFi8DVwLc+CZaWrSmE8pNP5glv4zb0ASmUB3PbfpXbPNPYJ3/Vv3/fyL
	PzUSqnZVygOvb76+MW1f9VzCbkex4x0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0583245F90;
	Mon, 16 Nov 2026 14:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11BB1F000C4;
	Mon, 16 Nov 2026 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840632;
	bh=nESxvsGwuM07nY0gJtiknNvC5SRahIhddedMqxw1kZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XVmSrkjP+tZBIejf9BoWO0O44niMRaaaCPoGxtSO0r2kmzA2fVeJRTvbLkshCygzd
	 0LIoDCdA8bRIfQQ2UpcgH7yZxn63vEBJQ6JemMLQrrn2e8qNRHVPlTQXBEziTjvg+o
	 MQzn7PWO6NecUrvhDHeL6823sm8FvzbCQIodtHxBaWmax8EaKlv4edUttHyP5U8ore
	 fsLtU+pS2tbAcvcup1BYpQtYOUEfdovQLbIcWmRCaLE5c233SmWj/5qsU3FQPAueKI
	 hSGoV9Rf5AXtGXjWcg93yexuIIZZslnQZoc1gx3b5Ty9aFvUS2ZAxg0Z1cad+j5BA3
	 QqiBPywTCnvGA==
Date: Mon, 16 Nov 2026 14:50:21 +0000
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
Message-ID: <avsXRXKh5Lj967FH@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
 <avYQteUm963AKJQ7@gremlin>
 <e4b60f0b-ccb4-4a7e-83e0-81fa1fd0c88d@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b60f0b-ccb4-4a7e-83e0-81fa1fd0c88d@columbia.edu>
X-Stat-Signature: egk9f8axge68nuf8cxmwt7jm5wsqoq3o
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D54DE10000B
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794840633-146061
X-HE-Meta: U2FsdGVkX19WK/RRKSZ07Btk94vrOz5Nq2wobjxpISMoNuWOK58DICKLn8fWwxHOAfiWm4mpQiMzQJKI7y1W2Eohrd9bGotCRictbmQ53YjQqIk7hgbVN0LGFo5aUuIKQ41LYuG8e9fbVW+lCW1MofyD2XrpO1+JjZMpVp/VbUKjwSC/27LUzv9zV7oifrVElqttwz+acWc3SFAyrGaqB8uQd4YetJLIrkzRmhWZYt1ULleW7WMxrbxrwHDI4Ql3oJPSUA7RWzm7c7Q7HUHRwubO89O9UQcKMw25/LKBPYCPG8o0A9EkYee5rxct4XA77tblQYFP3pCZNoWNxwe7oAMpHolvMyYfCTnKVYknkOHqvzqXrhdhDueobTfVoHWL8/3Qh5sQasBPF3a2qZVw4A7BMaw6sX7cipLSj1eKAlXeezoo3Jmb1QdF2MYZrC1KCRc0wxEjhvofs1bK9I8/TOLTEEZwjAzHT8U4B+N/VoOeaJddVoO4791afFOp8GA3YrAc/TaB3RuHeFmjfjoGfX9FcUTmukCNMNhH2iL1aZwLHnS8HPBJ0F0AQu/GOgcjaKo3fkR6uOfR0zfIh8/4Y5pCsKJjLn8QfsqLnHpmAeNqEGkUuD05Kw+/SNl0Bm5InDfuxa6wTMPtfhMPnhQ36lKUZj1Z8TjdKrghj/PEl2xO9+/rIY5/6oHmFULt7RfHtn4Fw/GoulSRl4A7j0Xf1XVG8GBZ43Obvlsa5rNwo5G7zBp5ZN3GLbpnnyAsehxRs6heimNHOqyTba/DlGSE6/sCoumxgHiB/nPDh1hZ25YhOXAcna4u7B+HMKTTvzn4OGsqbndDNQGUN5enAsQYhm8vFgKXMUVrJRosykoVLSMirYshc7lLbe5xqCRNpzjaBqLOYbKbuQv3GBUgfkrbZaHiz70gS/VK/IOGkuT9hmMGGtlx9m/JWb2QJ5j230RcP5ZNUuxua15m/gJZhAF
 AmVFQF7D
 N1O4XYkwBrEQftli6cSz4wT95k+dWbMYVyaZjRUNO54Hm1z2dYk7ibzYpW9oOFglTkz88yYcD5KvTqT7vmPm474fMcfEWh9iKT8ZyI6cS64isGyy8dfIwCVAOwe0KxKcT4fnMNPrPB03Orgn624GW/XNg5AHDnbb5TGL/mTknGv/NSPxfMhfbc6YhP2tiEOFOOBHiRmQXWPD2pZRGeWVM7sN3Mc7xff+GypwmCUIcUmtsE9Niv4vxNGZbyYYQawF6my4fVoWHKiTXxucJccn40NTATeDJ9y8QQd52TdK0eK8IuTvFWO1N1TuDkTV7c6gjpbgUec+PkwZd6CnTNRi+ZsY1J/Ya76Qou0GoApWuJgVjxUheaXSfFJMHXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 05:16:32PM -0500, Tal Zussman wrote:
> On 11/12/26 2:34 PM, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Nov 11, 2026 at 12:55:13PM -0500, Tal Zussman wrote:
> >> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
> >> make_uffd_wp_pmd(), which handles a present THP and a migration entry
> >
> > It's crazy to me that we write-protect page tables through a procfs interface
> > like this. But I guess we have to live with it now.
> >
> > I suppose that answers my q about this on a previous commit...
> >
> >> but does nothing for a device-private THP. The PMD never gets the uffd
> >> bit.
> >
> > Sigh yeah. Device-private feels like another 'just have to happen to know to
> > update X million open-coded parts of the code'.
> >
> > We really need to find a way to abstract this stuff.
> >
> >>
> >> pagemap_thp_category() reports a non-present PMD without the uffd bit as
> >> written. A user tracking writes with async uffd-wp therefore sees every
> >> page of a device-private THP as written on every scan, whether it was
> >> written to or not. This requires a driver that migrates THPs to device
> >> memory.
> >>
> >> A device-private PMD must be write-protected like any other huge PMD. To
> >> fix it, pass it to set_uffd_wp_swp_pmd() as well, which downgrades a
> >> writable entry and sets the uffd bit. When the THP migrates back,
> >> set_pmd_migration_entry() carries the uffd bit over to the migration
> >> entry, so the write protection is kept.
> >>
> >> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >> ---
> >>  fs/proc/task_mmu.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >> index 53780a454432..752f1b13d47a 100644
> >> --- a/fs/proc/task_mmu.c
> >> +++ b/fs/proc/task_mmu.c
> >> @@ -2524,7 +2524,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
> >>  		old = pmdp_invalidate_ad(vma, addr, pmdp);
> >>  		pmd = pmd_mkuffd(old);
> >>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
> >> -	} else if (pmd_is_migration_entry(pmd)) {
> >> +	} else if (pmd_is_migration_entry(pmd) ||
> >> +		   pmd_is_device_private_entry(pmd)) {
> >
> > Could this not just be !pmd_none() + cover all softleaf entries? Or is that not
> > valid?
> >
> > It seems completely insane to have to specifically spell out all the
> > possibilities, open-coded, everywhere.
> >
>
> So we actually have a helper for exactly this that I didn't notice before...
> pmd_is_valid_softleaf() is equivalent. !pmd_none() should work but I think
> the existing helper is better.

Hmm yeah that could work actually!

>
> >>  		pmd = set_uffd_wp_swp_pmd(pmd);
> >>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
> >>  	}
> >>
> >> --
> >> 2.39.5
> >>
> >
> > --
> > Cheers, Lorenzo
> >
>

--
Cheers, Lorenzo

