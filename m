Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7E2606A880
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XiANUSYq
Received: by kanga.kvack.org (Postfix)
	id 3183D6B05B1; Thu, 12 Nov 2026 06:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9416B05B2; Thu, 12 Nov 2026 06:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9166B05B6; Thu, 12 Nov 2026 06:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E778F6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:03:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A6DDA8084
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:03:43 +0000 (UTC)
X-FDA: 85426181526.23.B201BF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D013CC000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:03:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiANUSYq;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NL90eQvmf7oSmDtQxpeoM+o7UAHRN5i93I3Z8Hdt/Y0=;
	b=GvIVSPgP38TiUGyFcyb148CiiOwEztt3MlHTPagViq1Nca420WcndOzIqbzN+94if8ItTT
	mpKZU7c6x70YbkVXeixpohXUPI9DSPKsRZDz4KEGkHb293VwfO/qkc+4zOWT2Kntbv9nei
	HgG93YEuWw81YZRzNZNaPLqJfh5w4g8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481422;
	b=wg6N3V4+JQCa5EeMvO4AxXoMgAAs8JlKg+P/OiYpGYGwWwEIa/JHvCqoqoJgeQIeNUOA03
	SlKaNqJ8ykKz7+o8UaTLjdFL5xKnwR4P2t6GwVvT+KbDZzjhXSnUOiVxo4JMxhSwb7NHZJ
	FBL5B7hH/gwYWAmXUuh31arSkIvbp9o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiANUSYq;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49E11636B8;
	Thu, 12 Nov 2026 11:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5611F00A05;
	Thu, 12 Nov 2026 11:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481421;
	bh=NL90eQvmf7oSmDtQxpeoM+o7UAHRN5i93I3Z8Hdt/Y0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XiANUSYq7HUgR/c8fZWcWOwFWGYAsb6pXFnpXvRjnFQxTRcAUMYmq+6ZWOxb9KxVu
	 A+7besaPWCB77jQ2L0tbcs6iRrubXZDh3+KAtwB0fdzJLNTYRIWApVuaQzspqS/arT
	 ZYJosfzUTYA6dEePxBX0urqKahp6brnwUIP07hkQKRMgyykdPtYzhN06uzcQ+9in0H
	 SE8zMyJqBNEusSrkJzGxbHpgMc6JdtC3fo3vhfODgYPm5fSqvvXu2rKjwsFTB4O93W
	 vkniD/z7ulBy94/T9SEIBdXebyfQLf5PhOf7Wst5nwNowc4bDvyNtsoC6cj1sLVARo
	 o9/pSs42AsN4A==
Date: Thu, 12 Nov 2026 11:03:29 +0000
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
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
Message-ID: <avWW5t1BiD7pbzIZ@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
X-Rspamd-Server: rspam06
X-Stat-Signature: w96b8cc3cws3ypg99trsrxwn7oddod9c
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D013CC000C
X-Rspam-User: 
X-HE-Tag: 1794481421-61475
X-HE-Meta: U2FsdGVkX18Vx/kJ6JOfIq7abpkz+7Fx6IndjmwpdSMWKGXsh+fVdO+xQVK9FZ2Yo6UItYEsj/Kd3krzjoGG5LbeFuAw2vmAim3LvrpDlqfWoLB4pI9vhMJcMvfCv501BCMVy1DZqyeq2i/R+UNyXjep8NEU8lpSFoic+onXO4gx96+LUDPhokZaD8r0JuceYOafSzhou97Vlz34YbV0RXuOGks+74tp1I98/UmT09r6TTnbMQucL175TdMV0vi0OWR3TA5kcPXQNSvosftYhIqcKR42dt6A0kVsM6wCczkLV5cOHOUPX09tXBR9r9qHQ0cnSy+U99yCPjztGEPGYPFEthTVJ6/ayLTBZf7HXVjeZGQZZZuaZSg903SRMPdo3llPSNLNTNruYShlnQOqyiwVwXNWBByK7S10oHhT5l/wrs0bC+jBel4tagQYOUWeLqDWAXFR57bk9rxluS78yUgiefVP6t/FV69VOq3fx97gdRAIiXruTrcLOgx93bbNK9YaN0RuZ8LHnO8sQt92iV7Gf83TXxVNoJGTzG7PKC8SNBrDg91y6Pok5ePEYblfTJxpUYPfu4MIs2/1xLpto84GOss4sTSW1m7ibRCG7TB+sNH3fLjsBF7ERwOEs4mEe44yF7EPcNQ9skIpu3VlXGigi9R3wl6ERtzBbT6Na/NZYl1Vvzv8ugLUOAKcJVO/TwxLbouxyn2hLTPBIOcPgcXCPlXhbSZHZVGxTZGnn//ur7UFTm/PnpIBWAkNKfol52KaOrn8uPdV/eSRzTXW1JAv4o0btiIJAsT+YwAWjdI6pnnPD2oQ2XVLOlVpxVI8j5xii626YFlWNzc++ME5cHXmRSVIOCX6Y6mhl6uzJE7uGfiae4pcTH0LlIkNPAT3EP9/hc17TQH6Pd+7RT3RHaMw9o5n+z+DxkRvS1/scQ/OXBJqeSUTk6AnONE+A+8efiYx7TVtc0Dbv8YMWuA
 CEAmN6KB
 i5s0C9hbrwsvfeIMtp0orjwbily4oV2mdABtSv5QmdwUs7XSHr9cXXFmN/B+B118dMC/iIJi0tSVtrGPXhpyUVQu/SaHex/vzl7+rxcEGeTouwe6616bTp7W7CucLb3pHsXG3b8sgH8Wzbrv0bIR6KiACy5gxkENbUjQMaT4DegEON2lKfjkQh5zhsXuPW3RJ7LsPXsToNS3Mbb4uXyMjsu8tizRmmFmVxzv4Rh18Cu/aE7tKCAzROJFXf7JDf8DXaeJvvYq5Pk2/osQferbTQtihfUbo6nQXKSLP8/ShJLRqVJz44iDMgZEV17PtxGhn8NTC+u7ZYSwuxshmafnnjig8AHlGsYFJ4V1jGz1K1KjgD5gVynhBxGATgUMBOoKdM/otR0L+yr4rFI/iExToyC+6+bTbFE/kk/HHuxYqcS3e/mw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
> MADV_GUARD_INSTALL zaps whatever is mapped in the range before
> installing the guard markers. However, unlike MADV_DONTNEED and
> MADV_REMOVE, madvise_guard_install() does not call userfaultfd_remove(),
> so the userfaultfd manager is not told that the pages are gone.
>
> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
> the pages. Writes and accesses to the range after the guard is removed
> are then not reported, and the manager cannot know that it has to
> protect the range again.
>
> To fix it, send UFFD_EVENT_REMOVE before zapping. Guard install on a VMA
> registered with userfaultfd already takes the mmap lock instead of the
> VMA lock, so we can drop the lock for the event and look the VMA up
> again afterwards.
>
> As with MADV_DONTNEED, the call can now return -ENOMEM if the VMA goes
> away while the lock is dropped, or -EINVAL if it is replaced by a VMA
> that does not support guard regions.
>
> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> Closes: https://lore.kernel.org/linux-mm/3f4b0d1b.bbf84.1a1c55cb666.Coremail.18670333770@163.com/

This report was super-synthetic AI slop

> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Sorry I hate this.

Since this was already silently broken, I think the right solution is to simply
disallow guard region installation for uffd-armed VMAs.

I had the AI go look for users, and it seems nobody is relying on this (glibc,
android, CRIU, etc.), and there's really no sensible world in which somebody's
combining the two. So I think fine to do that.

It was simply an oversight (reflex action is to disable new features for hugetlb
+ uffd)

I'll send a patch separate from this, please drop it from the series.

> ---
>  mm/madvise.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index e8b05dc899f1..6413f0e65381 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1166,6 +1166,29 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
>  		return -EINVAL;
>
> +	/*
> +	 * Installing guards zaps the range, so report it to a userfaultfd
> +	 * manager like MADV_DONTNEED does. The VMA can change while the mmap
> +	 * lock is dropped for the event, so look it up again.
> +	 */
> +	if (!userfaultfd_remove(vma, range->start, range->end)) {
> +		mark_mmap_lock_dropped(madv_behavior);
> +		mmap_read_lock(madv_behavior->mm);
> +		madv_behavior->vma = vma = vma_lookup(madv_behavior->mm,
> +						      range->start);
> +		if (!vma)
> +			return -ENOMEM;
> +		if (!is_valid_guard_vma(vma, /* allow_locked = */false))
> +			return -EINVAL;
> +		/*
> +		 * The VMA may have been split while the lock was dropped.
> +		 * Handle the part in this VMA. The remainder is handled by the
> +		 * next iteration of madvise_walk_vmas().
> +		 */
> +		if (range->end > vma->vm_end)
> +			range->end = vma->vm_end;
> +	}
> +

(separate rant - that we have to a. know to do it and b. write duplicative
open-coded crap like this is a perfect example of why uffd is such an utterly
broken mm feature that should never have been merged...)

>  	/*
>  	 * Set atomically under read lock. All pertinent readers will need to
>  	 * acquire an mmap/VMA write lock to read it. All remaining readers may
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

