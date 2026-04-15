Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF77FA0C2D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E4B6B0093; Wed, 15 Apr 2026 01:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7D66B0095; Wed, 15 Apr 2026 01:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7973B6B0096; Wed, 15 Apr 2026 01:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683BA6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:44:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0329DC080A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:44:32 +0000 (UTC)
X-FDA: 84659700426.10.95B6A26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5120C140005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:44:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OK21Xv7f;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776231871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmlORgX2iPDACOY/tAGFdoR2u4OpFKOKRN4Zdm1mxp8=;
	b=oZsFQHC0VKULBF1Bom0IWGytnr4NqOq+0CtZ++nDYom68C73cxzuAgQ0K5J0Jdbd65P72g
	yBTeS4EscgaNpAiWMTLPCDdFlKVxX2OQZSUclYEXoT9qPl4jWX8QtOAvtejsd7Hq49V7Gu
	n0VkB01gyxNV+rXWohzA5CqnMZ0x9r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776231871; a=rsa-sha256;
	cv=none;
	b=vBiaYOTecnZbXV9QM7VabZp8KXXv1bAKT8vm9mlIQIrni4gckoVFpXckPHPedxxu6IucH8
	T8tAavnvKrn8Y0mR7wzL6T0QX75s9vEgoeK3egGtgy1R91IE2Pfwcw5rZCd1eJpnXXdtRb
	VQs6OjH1Q+AUReInj7OCLLZ8oH2LJ+4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OK21Xv7f;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BE806012A;
	Wed, 15 Apr 2026 05:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D201AC2BCB0;
	Wed, 15 Apr 2026 05:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776231870;
	bh=ULEdZKOlyHUFAHTvKEpw6ZXT98VHr7FG4P/ABfzjD5U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OK21Xv7fgD18lW8YMItHZM5UiVgKPJ8r66Ohfg321bvYzgZHvjqvQSxNpDtzUwTkX
	 jo1owznB7qT7j668xhhQ6UBAdR2PcKQ0sfqmvB1s0Ik4998BzvI3yJ9MLMFPXzCld1
	 PrWud/iFUoL+ds6JxwJXiX02KVDDhQ96eZ+Nd0js=
Date: Tue, 14 Apr 2026 22:44:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, Muchun
 Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn
 walkers
Message-Id: <20260414224421.c030868f5960ad0115ac1668@linux-foundation.org>
In-Reply-To: <20260415022326.53218-1-songmuchun@bytedance.com>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5120C140005
X-Stat-Signature: qcwomab8hdbbej4r4bkquc9e6tkc69yh
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776231871-282324
X-HE-Meta: U2FsdGVkX1+lFRD7PVFMRD9pSscUiubJ9sgUwiDG6IKVwI0t/+3Lycuw1K2K5GIQ64Qcz2AEABhAka7xMc+w6pVvBlafdRwfSrVX5unxy1w2R4QgGfAB1nYyuUi5+24oB5W47U2ZUda+V3B5Mv4uigPbUxRYfSounyOyi9HlLppMk2o8XQJTfQB5f5Lc2QBvISViKb80LJchorjoWsYiwiatKDfTXSDJdgYHWrisD8SNLy2BtRGHi9WDo45El+fQb/fOsMG+Z5u8dHiAjjb6Lh/wT5bRy+zZFgl+cQlsgQrxjMWeZgl/GDoYX1mqz7Q8hlSanSbHOFn0/9laH9hq9dWY7g4Yw2o3UjfxfRg8Wk80OUhC3Ui/lQaehpx1VaXlwd3Be0MmVI9+F8311mdAB5svFPPOvR99k9hgquYaDfmArmEcF0+VyO9A1wyc/6zYOdipEpQNi1D+dtkyZdmSmQJ4G1xcTH8XVsxZuYATxgCa58FrcH7onlL54l+0rv+4LFF2UFDOBzvmLgZCzRmSjOuS6XXZPSLaQMCN50NuvJh+bXStGnad6yygzofoVShFTXeytARc6fT8HFGlgUOcNZeyMN94sN2KclrlJ691VSiBrCAqZM5UC0uiKkK/EZdfiJueQZrcenG3hMIONBW+qJVFL1w6DRhOD1qJnQNu/1+Kt7mwY7U/603pCqP4lTRNKrnWS6R+kNdmqO1xz6PvZmXUIR+wGQqGEaYYsvm0oZ4FfHBRwD1v8Eck0lkUf0Vf4qvRs+DcKSoOh2Dn9TuE4ykJyzHihXdpTSk1ZnTXgcr1mjqheATApsygOZt4PVHzK7y7TVXHH0Ueo1UidREUOZ1vzt2o+IB33qReUP3vyBqllRVjgKaySohHMjetC2fs3RQ9HU50pQ0yCrTXETymDmVTHClRWulYwcAS0quZCzDLx3iC7/6nr+ZSXMvNLZ45GnpVQB65yZcOPa8pyL/
 e4B7Jdtn
 ZLl86W5wwTkTz/QT8ZxvOONWBma0wg71CGpNk1OALHywlpiaidEKlYOvrdexG/KDyNmxjaDcKJqpntlhyJ7N3bcZ1ZKdxIBVbABdPjp31aZh0sz4JLBozeNLnUBVhrJ+8oFLNC7T/n72BmAZjHo5HbOyh+6YPrtiNQV9Q2hY2wwwG5V9/ie3k5CqxXCmmAQJ9D3LL25YUiAa7e7Ul5xbuQ22nW2piKiwyxeVZe0YuSpVL4tTh/D1qSOu5SLBWlaI4JG5n1OaVeR2B43URSywwGiNUH/fjaxfnAAKIn2+A5jgjdFEK1BwlZg8fA27iyzpBZjOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 10:23:26 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> When memory is hot-removed, section_deactivate() can tear down
> mem_section->usage while concurrent pfn walkers still inspect the
> subsection map via pfn_section_valid() or pfn_section_first_valid().
> 
> After commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
> memory_section->usage") converted the teardown to an RCU-based
> scheme, the code still relies on SECTION_HAS_MEM_MAP becoming visible
> to readers before ms->usage is cleared and queued for freeing.
> 
> That ordering is not guaranteed. section_deactivate() can clear
> ms->usage and queue kfree_rcu() before another CPU observes the
> SECTION_HAS_MEM_MAP clear. A concurrent pfn walker can therefore see
> valid_section() return true, enter its sched-RCU read-side critical
> section after kfree_rcu() has already been queued, and then dereference
> a stale ms->usage pointer.

Then what happens?  Can it oops?

> And pfn_to_online_page() can call pfn_section_valid() without its
> own sched-RCU read-side critical section, which has similar problem.
> 
> The race looks like this:
> 
>   compact_zone()                    memunmap_pages
>   ==============                    ==============
>                                     __remove_pages()->
>                                       sparse_remove_section()->
>                                         section_deactivate():
>                                           a) [ Clear SECTION_HAS_MEM_MAP
>                                                is reordered to b) ]
>                                           kfree_rcu(ms->usage)
>       __pageblock_pfn_to_page
>          ......
>           pfn_valid():
>             rcu_read_lock_sched()
>             valid_section() // return true
>             pfn_section_valid()
>               [Access ms->usage which is UAF]
>                                           WRITE_ONCE(ms->usage, NULL)
>             rcu_read_unlock_sched()       b) Clear SECTION_HAS_MEM_MAP
> 
> Fix this by using rcu_replace_pointer() when clearing ms->usage in
> section_deactivate(), then it does not rely on the order of clearing
> of SECTION_HAS_MEM_MAP.
> 
> Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")

December 2023.

> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> This patch is focused on the ms->usage lifetime race only.
> 
> ...
>
> I am not fully sure whether that reasoning is correct, or whether current
> callers are expected to rely on additional hotplug serialization instead.
> Comments on whether this is a real issue, and how the vmemmap lifetime is
> expected to be handled here, would be very helpful.

Thanks.  Quite a bit for consideration.

> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -601,8 +601,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  		 * was allocated during boot.
>  		 */
>  		if (!PageReserved(virt_to_page(ms->usage))) {
> -			kfree_rcu(ms->usage, rcu);
> -			WRITE_ONCE(ms->usage, NULL);
> +			struct mem_section_usage *usage;
> +
> +			usage = rcu_replace_pointer(ms->usage, NULL, true);
> +			kfree_rcu(usage, rcu);
>  		}
>  		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
>  	}

This part isn't applicable to 7.0 - it depends on material I've sent to
Linus for 7.1-rc1.

So for now I'll drop this into mm-unstable to get it some runtime
testing.  If people like this patch and we decide to proceed with it
then I can make it a hotfix for 7.1-rcX.  But the -stable people will
be wanting a backportable version of it, if we decide to backport,


