Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E497F34C4B
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06AF6B0089; Mon, 13 Apr 2026 08:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E30D6B008A; Mon, 13 Apr 2026 08:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B1E6B0092; Mon, 13 Apr 2026 08:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9AC6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:05:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F3B6C05E0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:05:06 +0000 (UTC)
X-FDA: 84653401812.17.4EB5749
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 811BA1C0019
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:05:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=at+QCcd8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776081904; a=rsa-sha256;
	cv=none;
	b=aWk1Yw61SWDu7Uz3f4N8WrrMqU3aC7RMz/bnIzP6yXd6kyy6B9j1CKjFEUkfWqYG23O25p
	CRGgfAZsLLc2eJru2QfSRhkWe+3cv0ifBT2b7gQwsmh92NrhX5FuTqlJiwQRVJ6ds9QBFv
	DwZWzfufg947yJVkGKVXvQbnh6s4icM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=at+QCcd8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776081904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH2W+2csUqWt6/5/R4OcEjsSkmHjk2BuSHBIUQjDBks=;
	b=tO7AZ3WpOGz4IntWlG/cMHSDjfD5CZUGVPPRr3tvRl6feq71NQ2sCPCUE0dIXTlK4ldQgU
	X8JZZdt35AG1qrAFC219wLRRe/7ckaRHkCH+uOsHdeDCfyrDViihzVTgBZSv/0RVT8Da4f
	kscR0ySIbaMV3nIrAb4gPDYrSrjmPUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EAF2060180;
	Mon, 13 Apr 2026 12:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EFDC19421;
	Mon, 13 Apr 2026 12:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776081903;
	bh=cSo4sEdsNwlz/Iqs10U18EHsNdWWL3XI+9TPegcabV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=at+QCcd8hldAMXHMewcQlTRTSnPiYtb+AMBMRvJ2S3KRydAkuWOSAT5L5UCYcSoX/
	 ROa9bELImeOFvQzvTvpDpcl4kesvAFWZEWDTyLABjzRsnNsdUqSTmHo8oGoko42yP1
	 ySfzT1F5fS+ieBGBLG+LF/vt9HIB747aetWSZlmf5ZsXJNo8GFsCT2SCUVjsNcF0+D
	 Y6DQqlHoXOTwKiulifQcVyMaqFKxVh70yge0I5RxWAyvSyVsOM3ft5xcsQIebGm+6U
	 4yi40VjDnwrKe0gqOTVZYA/w2Lw0t9gyBbQ8clbAsFDUDIHE47hCCod4Zw1isILUZB
	 tqQdQ9IAZeV3Q==
Date: Mon, 13 Apr 2026 15:04:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
Message-ID: <adzb5o9aWxFWphRK@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
 <ady1LQMN1xhPGcuT@kernel.org>
 <ady40BWw5WgQHf3z@kernel.org>
 <35454ADD-C983-4577-997E-884266C56FB6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35454ADD-C983-4577-997E-884266C56FB6@linux.dev>
X-Rspamd-Queue-Id: 811BA1C0019
X-Stat-Signature: nfge3mcew1imskphrz8oghqjycj54x97
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776081904-11570
X-HE-Meta: U2FsdGVkX1+njro/uMTYHtDZfZ3dcXwxBXQGMMZdQYBYG7CdSRHcEsTUD+dcaAGbtAI/4Kn7dCLlFJH9InoRkxW3sMAtCGR1b4IOkVXy9tma/RxZqFiJ61ZLnEbd87lnAGEA1vWM6puFysP64ce25OV18pZKxqfF1ZwsY4WR7JGvzKrBElUeykweJo068btYDiWO5tgZm5OBH+179ixohBkoW6x0sBNOyPLYwl9REzz0OBuB7UjLgKWV9hBKhllAeHU7ACN4yMyWhYxqM0JqshCJ0rzCVTJzeV/IwA3UKpcTGIGEUmqBaS5XvfQaz+vyAncrTm/mNB91WRAOI5gs9P8qaG5kMB33LqU3UArFLg689Ch75FMSy/0v3NsfN+8Rr3IBob4UaxfrhuKszlqiZjHBguL/X3goKcRLg/G3s0ZtY3FuetxBxR+JjoLgk2DS1w343ip5PNGYMFOxQ9UTMTn3fI4bGit+XvK+VpuizuW9hZFhjgeDg+tIrq+eaye7orU4+kPrTLX+Xp98qCJgvgIgeT8X67C3VOXnXvjaafn0BCbZuH+MsTrfj33ZYIOIVdKcW83JHLuUIo1Eo4knDNA6yDsNwdECIjL10FLuG3LUuLv8VkAu3h5TXF7WDiQG4y8Tqm4wOjJfDR+1XwioFd6pk70ah/Em+M0Z2IYtA7+3V3Wi8hv0qwD66OM8/VyVXFvF9RODx3HZ9a+ITD6jgRsMX8ZJM3H6r3eXd7ZnUUzmRmVT4xC1NLVkisNpBPmp6LRbUt67WX7mN7J09tgY4wqXT4rUNCne95yc1KRjiH7DilD62ef3VpOmbV3SJ3rPLkzuMH4ubj/nKwTT4sXAGDNJIbHKx/jjcFiogwBt50Hn+EuYaZX3CLES1zGxn7zzBL6d/FI69P2uG7oVwmKSWXoQ+JzrsUM7Ld9ytzqVND1nWK4UZuBKOjy9JVo+16cMDpLOBfRDVfYMRSm/Pux
 o7qXsGFH
 BgBuGqDAqWzcfX/YBlG2dl01mUeBJroAF8o8RAbcaIrB/+UB12OjGPFx2GhsQ1pWRyBRzJ0QsNpbNbxUHmIThIbpaRezqMOcChXB760xwnMtisBc5NG+VoD6hXC4wFhi7xfzUxuCe2WXCHXiCO9RbVeusteEkP+M8R79OVgZGkNxiv/2fqymTCDvBDPzgmC90rewUbNnZfBK4ctEthgTorT/gcpnusHJ31YsmqYxBq7uGvlO3G7k6CUPcTTNBTgFRherxbWIZpjAKz67OjM9SBc2YvNDid6gxzDqn+rvg7HgGxkSIuPqmgyYu6DieMOReuU9QnBa8WZ8BHcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:49:17PM +0800, Muchun Song wrote:
> 
> 
> > On Apr 13, 2026, at 17:35, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Mon, Apr 13, 2026 at 12:19:50PM +0300, Mike Rapoport wrote:
> >> On Sun, Apr 05, 2026 at 08:51:52PM +0800, Muchun Song wrote:
> >>> In section_activate(), if populate_section_memmap() fails, the error
> >>> handling path calls section_deactivate() to roll back the state. This
> >>> approach introduces an accounting imbalance.
> >>> 
> >>> Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
> >>> memmap pages are accounted for only after populate_section_memmap()
> >>> succeeds. However, section_deactivate() unconditionally decrements the
> >>> vmemmap account. Consequently, a failure in populate_section_memmap()
> >>> leads to a negative offset (underflow) in the system's vmemmap tracking.
> >>> 
> >>> We can fix this by ensuring that the vmemmap accounting is incremented
> >>> immediately before checking for the success of populate_section_memmap().
> >>> If populate_section_memmap() fails, the subsequent call to
> >>> section_deactivate() will decrement the accounting, perfectly offsetting
> >>> the increment and maintaining balance.
> >>> 
> >>> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> >>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >>> ---
> >>> mm/sparse-vmemmap.c | 2 +-
> >>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>> 
> >>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> >>> index 6eadb9d116e4..ee27d0c0efe2 100644
> >>> --- a/mm/sparse-vmemmap.c
> >>> +++ b/mm/sparse-vmemmap.c
> >>> @@ -822,11 +822,11 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
> >>> return pfn_to_page(pfn);
> >>> 
> >>> memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> >>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> >> 
> >> This logically belongs to success path in populate_section_memmap(). If we
> >> update the counter there, we won't need to temporarily increase it at all.
> > 
> > Not strictly related to this patchset, but it seems, we can have a single
> > memmap_boot_pages_add() in memmap_alloc() rather than to update the counter
> > in memmap_alloc() callers.
> 
> It will indeed become simpler and is a good cleanup direction, but there
> is a slight change in semantics: the page tables used for vmemmap page
> mapping will also be counted in memmap_boot_pages_add(). This might not
> be an issue (after all, the size of the page tables is very small compared
> to struct pages, right?).
> 
> Additionally, I still lean toward making no changes to this patch, because
> this is a pure bugfix patch — of course, it is meant to facilitate backporting
> for those who need it. The cleanup would involve many more changes, so I
> prefer to do that in a separate patch. What do you think?

For this patch and easy backporting I still think that cleaner to have the
counter incremented in populate_section_memmap() rather immediately after
it.
 
> Thanks,
> Muchun.
> 
> > 
> >>> if (!memmap) {
> >>> section_deactivate(pfn, nr_pages, altmap);
> >>> return ERR_PTR(-ENOMEM);
> >>> }
> >>> - memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> >>> 
> >>> return memmap;
> >>> }
> >>> -- 
> >>> 2.20.1
> >>> 
> >> 
> >> -- 
> >> Sincerely yours,
> >> Mike.
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> 
> 
> 

-- 
Sincerely yours,
Mike.

