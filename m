Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BD0C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98A26B00B4; Mon,  3 Aug 2026 09:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48706B00B5; Mon,  3 Aug 2026 09:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E826B00BB; Mon,  3 Aug 2026 09:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69F666B00B4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:51:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2BD016070E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:51:52 +0000 (UTC)
X-FDA: 85060096464.13.70C8244
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64D804000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:51:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUXQqDSw;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785765111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYWtREcCitn9VzwK20Ul7JwMvS/AiBKt/jNqS56Ugik=;
	b=BZ5jLIR1UB/+VlBYq5HP5h6r/dDoGNbthSqP4ntscjvB4IzxrFSUjUE9rT8+bd0uQW9A4e
	RBP79KxNc+Yydo8CzipAOdjH+wOKMjUeL3vxFAsZiskb/CV6roWlsFw4SjGuwnalckB3D9
	5gBhdG7ppoLHfAiCadpMNBWZMNZ2uG8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785765111;
	b=VwCM1Y0qYPZmnf9GtxNXSL0pA4oTvm0U0RjFYN/u0TUmaElXgksoeQr08f2e1i9qJFGQkj
	xPhzIoSCDM3qnf5R6koXl+HLqKjNp2aJS21LVOMEEDeX4hb+7wipIBd6DEnSBcbybEPL66
	iPCYoImIL4sWbHLKNlzCT2vOYXZmFPM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUXQqDSw;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 005FB60A78;
	Mon,  3 Aug 2026 13:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC91F000E9;
	Mon,  3 Aug 2026 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785765110;
	bh=wYWtREcCitn9VzwK20Ul7JwMvS/AiBKt/jNqS56Ugik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fUXQqDSwQRNCmkLD5cemnbTUAjHE/irGyvzgbHLxPc0i1jBlBQTukK5HA+aSIvnBC
	 R0SzlslWfUByqQyQLjFv2VKbBHYAmHOj9EWiRF3DvEyZodM3CLzCGvNK/M5dInlK4+
	 U9wzqk6EU/OphCdVnGMO3Czmba3DqbykfibI9bvc3yGFgXNsUJ38xhXuRdsYEfwVdZ
	 7o4p/kjve+UU+zLDVez4Qe7mmlF1YZMvbdm3762IvRErJDJH70Sft4ErX88/PAtZYd
	 cDhgsG0sy69Q3FQZ1KH8SAU/9DRtAzOgrkS2ASxz1hjVS6rI4+uMaAJcrhu06pFGXk
	 q/JRoSBb92K3w==
Date: Mon, 3 Aug 2026 14:51:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 07/15] mm/rmap: track whether the page VMA mapped
 pgoff is anonymous
Message-ID: <anCcMvnsux22LaWU@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
 <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org>
X-Stat-Signature: jpc891pfxdicdmoa719txt6zg8emoqgx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64D804000A
X-HE-Tag: 1785765111-711595
X-HE-Meta: U2FsdGVkX1+NJLxBRU0/OPc3F7J9Z4QxxX85Hw8yVpx/2cfWw0yBFlcX4kz7KOW6b+KjxwbqdzCw/3WrQVKd12AAPMONSgJxL2kZmkRwMsaA4KqvByeEYo1FLXCXbaes5b/UwoM+Vxd0fAhWxu5mMo28Ti+aanoubzXiWoqsHsImtfNxpc4aLrpY3k9MJk11zQoV+PqJVj/uYjzNTNSpUEA97vGY84PmcWZfqj+KAPkhEp4HB+2BROiRHq0hiUWyzU+q4V+7hrpHC3MK6YD3ZvGweZOKcGEXAUc33PY8+g9PDvlu3Lvn/5bQeHE773xBeC4pK+oLXsjatUEijRQohrT/b2VOz9iyMlypYJXMpQkj4ZSo/StOJyPIYLfx1Z+RmWlVa7GvlfrqvUDogmB3PXPvSQ2FHTWUAWeCKhIFEXPzBoUuqD92zTz1QJM2ouXAMZdTIasXRE1G+aB620+2h6iZ+z82/EOAw3+Lm/GYGN1qi+ZYHow+EWjU8TfDBOYeiNDnjo1gXPi2nuP5Xq/65uhxOkLZf/rWN6fiV5s8k0e2UOfO0ZbN5iyhjlt42HR2ILYtTNdKeKSeZfgGrOm9YV8xSUf3ZFR/0Y1C/q9SZKuERfCHuwsqVtz8pnNwdVl7QLQ/HEfyBtUZVVOxXccUG4u9qBIDZwS6/N5E3A0GNj2Nq4Pcq2qVaNX22CRRYKRTxYyfpxdyOT47bKrprR7E9WM/gGT5HFvKZnBZLLIOkYPYGIi4guAXLHdOKwPeo3z9LDs78xQpjSEvX+FMnEtLES3xO/L2D3GNwVp2Xs1/yQRztn23IWz5MTYTWD7KyOEELeKZh0on/ISkZ41Kcc35+CkpU/3mx28xEXpV7qrSy52MVCRpPRN07LghE/yb2UHVy2zpp4LFQJ43tfCBI1BkOm0boYMbgHBAESMzCmDHlEW/9InEPmaxnAZWwwaL/9dKZCz2vtNAKQsmLkNRl2C
 9EyO06CX
 O9R66p0O9c3gZoylQ67rsxyr3hfn4VO7b8XKWijwZajeHnZRsI1KOgeJ9pFgjQqer84lXYZap+d0KZK1Q8cLpOrKrg97oxcOvPtuonQ6ROENzCzvYJyXU2fgw9k+B8XStbW4W/vdhCNAnTmSUgekQSV9cD8txU6BaeRBpA/lqWnlLpV5Ak0AiWwhHt2amKNAHMH4QnKCTd98eN4dNk4su4c/VZlJUbZPIm6BYg42iI22UxepisATZDvV7+uMZTBBsmGmzw4tB1nJiJt3u5ilE0QoqKvVYf2Ak0YtIno+qWbUIO4DjtEnjhd0ezMD7jkMMyr293Z6gBQ8Plqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 12:57:44PM +0200, David Hildenbrand (Arm) wrote:
> >  /*
> > - * Then at what user virtual address will none of the range be found in vma?
> > + * At what user virtual address will none of the range be found in vma?
> >   * Assumes that vma_address() already returned a good starting address.
> >   */
> >  static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
> >  {
> > -	struct vm_area_struct *vma = pvmw->vma;
> > -	pgoff_t pgoff;
> > +	const struct vm_area_struct *vma = pvmw->vma;
> > +	const pgoff_t pgoff = pvmw->pgoff;
> > +	pgoff_t pgoff_vma_start;
> >  	unsigned long address;
> > +	pgoff_t pgoff_end;
> >
> >  	/* Common case, plus ->pgoff is invalid for KSM */
> >  	if (pvmw->nr_pages == 1)
> >  		return pvmw->address + PAGE_SIZE;
> >
> > -	pgoff = pvmw->pgoff + pvmw->nr_pages;
> > +	pgoff_vma_start = vma_start_pgoff(vma);
> > +	pgoff_end = pgoff + pvmw->nr_pages;
> >  	address = vma->vm_start +
> > -		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
> > +		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
> >  	/* Check for address beyond vma (or wrapped through 0?) */
> >  	if (address < vma->vm_start || address > vma->vm_end)
> >  		address = vma->vm_end;
>
> Am I wrong or are all all changes here completely irrelevant for this patch?
>
> You mention
>
> "This is necessary in order to determine the correct VMA page
> offset in vma_address_end() when pvmw->nr_pages > 1."
>
> But I don't spot an effective change here.

As per commit message:

	This is laying the groundwork for eventually using anonymous page offsets
	as the index for all anonymous folios.

	No functional change intended.

I cannot enable an effective change here, because if I did I'd break the kernel
and introduce a bisection hazard.

The point is to have a reasonably broken out series that lays the foundations so
the actual patch that enables this functionality is as small as possible for
debuggability, reviewability, etc.

The tracking introduced here is critical for the actual change.

The trivial layout changes in vma_address_end() are done here so there's less
delta in the 'switch on' patch. I can add something to the commit message saying
that if you like?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

