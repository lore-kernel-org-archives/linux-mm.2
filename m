Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9785DC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10A76B0095; Mon,  3 Aug 2026 10:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1F76B0096; Mon,  3 Aug 2026 10:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7FA6B0098; Mon,  3 Aug 2026 10:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4DC6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:33:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF2D3A20EB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:33:21 +0000 (UTC)
X-FDA: 85060201002.02.E9107A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4790A1A000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:33:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MbmNiW3/";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785767600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mphLP5S8b/9n/v2PFE9M1KkdjdKyrA/jY3VZr3lL4rI=;
	b=H3cJHOM/hdBdbsGOGM+apc2nZo02rVhjzC404yS3rSfBq9xTPPSUjmLMwDP2kRVu5+okpM
	97QuHNH81b1CSUCmmbgW4JKQbCFwpJDDDRRYeyYakdpODkn5h8auqJjvA3hiorZ7WXcyTY
	Xt994Ek44AkHSiIRvK9t+7URlpVOmHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785767600;
	b=tiBhlZDesVDF0TmI99NkZYj7Ss2XGP56nsvD8twH4C3Y1tDdJEkQ9/L/jJrigEpsSPKo33
	gkhTDfRKKVzasfPYNQGgrVRz6HpkibMNrGYDfQjyn9jZ/yYR2SsFBRTTPXHbiZMCiXDUnE
	pk8dL+YbQTgRqYaAyWVEemsgFPlSHgM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MbmNiW3/";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 566CA41175;
	Mon,  3 Aug 2026 14:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F94F1F000E9;
	Mon,  3 Aug 2026 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785767599;
	bh=mphLP5S8b/9n/v2PFE9M1KkdjdKyrA/jY3VZr3lL4rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MbmNiW3/tIvlutcDN45W36ceGJ2hcM79xennooUYVZBeIVDH0aG/tT9HWNKOWm+xh
	 G/r0e2vBuWTrZI/VUsJYQZ8SANxl6iIw5Y1jmVW5+dj0izkc6EuYTcrRwfVaAVg3vS
	 64SK04ven+xr+o9Exw3nTVdXa9avymUeBspH8jnoyFDrT38dgW08ABefRcxDFSxY0V
	 wDe+RsJeUwV/j3WaWqNtiqWDpd6x8tSwtufta7hgLv07MfpBDMjSleZyrdlVugbui3
	 UGj2iD5YIX/WvXdNTGOPqq1oxyntG6uGXvQFZSqtWFzAH23kAwJgpfihRlffNDWoKq
	 r2L2Sgc5AEvOA==
Date: Mon, 3 Aug 2026 15:32:57 +0100
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
Message-ID: <anCmQdKzZFRMqcxs@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
 <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org>
 <anCcMvnsux22LaWU@lucifer>
 <007258ed-3fd7-4d90-b909-6fdda15e0485@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007258ed-3fd7-4d90-b909-6fdda15e0485@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4790A1A000C
X-Stat-Signature: qft6z9ssr3qzsat73yx5jbftghmohtud
X-Rspam-User: 
X-HE-Tag: 1785767600-794379
X-HE-Meta: U2FsdGVkX19IHrppOI7GvFXaG9uwptczG/wL1cBvl5OunTsYTTByhdHqyxGYpTLi6tJG2mZZZ98/6kvdAMYOJyQJBYmv8XFPOUuD79XEdyGTUeynHUROtRSoBsHBqsyr0baPNPZJInbmxf/ftC581JWMLKxBhbdAnw1+GX8xCY7MwzN3VGVLSjEm7o67RmGEV/f/pEe1+csAy3cgpNRoFHWdAjOcJ+6jAWTmkhJmHxxC1yA9jZnTU3ZvMcP22jUmptk7hxyYmLmW783ny7hw/7lvvx828jxIYrtmYr2hFo9YVz3n4AlFSf2PUaCWwIRi861kI6DjVvVGAc8ZYkXACWtxRgC+TR9+rRnSjH202C48hzYIy+6wCzfOF87k4WCGP5U0F5xvvUyJRIuD9hYZvn6xPHK5qPQju49JMTVXmh1ig9S7bALJbMxN44aulj9aUX29qwyWufE6KdNrzB71D9ZDvLF/vWG+UEaLMxCsEBTvCGC3ohQKYJJAEWXtEfY9ofh1tUssVRTK+ZWMz7a+WJ93aD4AvcfcVjJElPDtAwjF3LS8AULKpfTya05ODDS29abDhoCAYUZWQo9u6e+AXIlzYg5ahHlRKefAvBnk0VVIfVb+upaXn9ihELNIepDE+F0ojAjuGmjp+V3zYk6jT6dqWbEO6U+H5j5SMs/wmbt+638ltN37P7VjoyNvG7mLSna3ELd0JanGL2MWT8dBR5qgCi7YdwmZexHEYvcOEMq6zmJHrEi/uIl5PcJRpQhZNuehYFU5LBFXelwOT+W4Vs5AbqgKokPjx8R6aAVgUSHbzWIqsri9+RHWoBgRcE/TMB3hMhX3JyT4SDht7Ei+Jxfgu9FUhPzagXqU6BKmSdFipAqOZn/CwQNX+m0h+E5B6WViFTzQ3yVAHKyJvtJK25cEVCUG1y50U+xttEoCBDTJ8z/pJPuQfgDMz9NvTjdfbKdRhDxPXG5Tx37HX4D
 l1AyefaP
 h9H8eV9iF2UavcmZVw/M5A9fkjsTU/WZVivssivmxF/AHIZbi0z1m2mLpMQBzJaYGSS013kta0UvwfmwO1eXsMK5sB0AvGwuNmHd/6yfvGGvEz4jB5XQZOaUI+blKFRVC4Xn5HQVRpst6l7oAEaiXkF6xlMX9cFgjjbqeDsrsAmplUmDUEth264DasDeQScA+H74tj/cOn2frlA53WcRy2VaLoMwG+VYEsd5pobd1B4/8N80P1ymn4IInyOSyd8IVVW5E0fqiqpMWBwW8gmn94lGmq/LKrrrPB6b9k8+pDCgm8pBCu3T8bDXyqzHcBkJaEegLDWWONLwwdhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 04:02:45PM +0200, David Hildenbrand (Arm) wrote:
> On 8/3/26 15:51, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 12:57:44PM +0200, David Hildenbrand (Arm) wrote:
> >>>  /*
> >>> - * Then at what user virtual address will none of the range be found in vma?
> >>> + * At what user virtual address will none of the range be found in vma?
> >>>   * Assumes that vma_address() already returned a good starting address.
> >>>   */
> >>>  static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
> >>>  {
> >>> -	struct vm_area_struct *vma = pvmw->vma;
> >>> -	pgoff_t pgoff;
> >>> +	const struct vm_area_struct *vma = pvmw->vma;
> >>> +	const pgoff_t pgoff = pvmw->pgoff;
> >>> +	pgoff_t pgoff_vma_start;
> >>>  	unsigned long address;
> >>> +	pgoff_t pgoff_end;
> >>>
> >>>  	/* Common case, plus ->pgoff is invalid for KSM */
> >>>  	if (pvmw->nr_pages == 1)
> >>>  		return pvmw->address + PAGE_SIZE;
> >>>
> >>> -	pgoff = pvmw->pgoff + pvmw->nr_pages;
> >>> +	pgoff_vma_start = vma_start_pgoff(vma);
> >>> +	pgoff_end = pgoff + pvmw->nr_pages;
> >>>  	address = vma->vm_start +
> >>> -		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
> >>> +		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
> >>>  	/* Check for address beyond vma (or wrapped through 0?) */
> >>>  	if (address < vma->vm_start || address > vma->vm_end)
> >>>  		address = vma->vm_end;
> >>
> >> Am I wrong or are all all changes here completely irrelevant for this patch?
> >>
> >> You mention
> >>
> >> "This is necessary in order to determine the correct VMA page
> >> offset in vma_address_end() when pvmw->nr_pages > 1."
> >>
> >> But I don't spot an effective change here.
> >
> > As per commit message:
> >
> > 	This is laying the groundwork for eventually using anonymous page offsets
> > 	as the index for all anonymous folios.
> >
> > 	No functional change intended.
> >
> > I cannot enable an effective change here, because if I did I'd break the kernel
> > and introduce a bisection hazard.
>
> You can just throw in a patch that cleans that up and avoids messing with confusing pgoff?

You mean do a separate patch for this change?

The existing code is already very confusing :) it becomes worse with the
anon stuff added, hence the change.

I will separate it out assuming this is what you mean?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

