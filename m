Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F7FC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6164D6B00AC; Mon,  3 Aug 2026 09:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED886B00AD; Mon,  3 Aug 2026 09:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5041F6B00AE; Mon,  3 Aug 2026 09:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3119C6B00AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:22:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 605D64065D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:02 +0000 (UTC)
X-FDA: 85059479484.12.DF6C064
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FEA114000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWQLDfqW;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmTYhKzT9eCB53aTI2koOjOPsk0BfddrSlJB+6MBGwY=;
	b=MrHgv91AttWD6Txquk8bBJ1dSIj4yFP1cU6+sHGPNgfjgwZcmUM1iojZpmR6pE3BHw/yYs
	aeQ7Bo3HbX0YmKul6+n0xcNJ7Ud77fLuoZ/4UhrwIqdiS0HxpIHHRC/7AFD10pBQMPcJkq
	Qtr2locPFILqRDZtZ6INY0uGhx3nnb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750420;
	b=4V9dkGqH6Qt6toxoDz4lGIwINnBPGRQieztpQ1brAr9UKmKe6D8yJ+OwA3MrThfRgkdfgC
	DoghBUo+5UOsv2As53NazmNmZflAGIJOeRNthWGwv2my+iAy/ZqlH5bohHMyds0iC0vXIB
	4awTOUzmhscU/tbbA8nytPtBPNTl3J0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWQLDfqW;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D6B42B39;
	Mon,  3 Aug 2026 09:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE051F00A3A;
	Mon,  3 Aug 2026 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785750419;
	bh=WmTYhKzT9eCB53aTI2koOjOPsk0BfddrSlJB+6MBGwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZWQLDfqWcbka5ukiKfEue5Pje/KLYTUCEL5GxPuZMk668y5yZrrbvVfbFJWP7zA3e
	 oBjiNDQIR20BZMymwsL8s8U4CgxsV2V+oT+C9EgnHDcjtE+SwZEE6vBUCocLBJvZAZ
	 oS+OEr9lXrBDD416GfBtp+MCtpmUD8iIXcgzxEGAY37TuPudeHosUsXFDYJPtxheE2
	 cw42f7Cw+SZy7rm1DqhT7aJnyu7AT/KbfLNaDDrmKc4eFfi2oLMcOLG7Cqu8lnj76k
	 5LXlFPVySlsRPcciVBCN9LU0GKcoCT/+RFL04RwAtqQuRDE062VqX1KBz7K37udTlr
	 LgPcrK9j40tWQ==
Date: Mon, 3 Aug 2026 10:46:35 +0100
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
Subject: Re: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field
 and add helpers
Message-ID: <anBjLV4CvmpBzEiw@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
 <2ac2746f-18b4-4960-8628-82e87c2140ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ac2746f-18b4-4960-8628-82e87c2140ce@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FEA114000B
X-Stat-Signature: w3oehbhwn9di7qmjco4q9ng1st4mngor
X-Rspam-User: 
X-HE-Tag: 1785750420-838092
X-HE-Meta: U2FsdGVkX1/lghd57bVP9asnt33atsgBVsoaoxQdHSGe3Y9l1YG0VvePf/iFHTedMwMJC5SNy2ibcYFlFDsbpG3Sb3aKdCm6PLx3NVzXEDGWlLepj5sxmmt4WBK71q1f9LZ0jHsfeygbkrlecLcdjCe52100DGV5CmxuIqO0hVfCDCmN6KhBu82d8iKN3mc3YbhnvdCyLBRHgqE5l5my3xZoejYOGUd+UvEORI7nUe3n/eIZeY3q6LsboTvCJc7XbRApxvNGYaVxUmxQUh53uLi9FGwjcsCeIW7qu7MsV49W5IEUEhsc9Kxriw5yVak2/SC7Yj+tm9nMHA9x7l+hwWhLTRQv9pZzqwwCjeYANZJ+9MNybUQPQ6FuP3NWbGsci6V8HZLFwVqnbbZ8h4lpLZf1TgPCGhuZEx3Kkz7UhaPqqbhO1QQ+Fk4zKyx8UFjw1OuGSIZgEe6K+ZueQ632U4UTLTq2lXGDS79hPW+rwbykeAmOfio/5nMy8GcsUxPK886UgTngGVwVw/KCBZpQMkX+Cuuank88Dj31AAjmq98K7a+YYYsUNTWPeGXUYO+y7z3BsH8riklbzFxIc8eKUCH/BZRqB3EKoEmLQzBNvlHCrsfsAe/aQ9L/Wvl1H7ZH8bz4Y+sUnenj3sHSLDWTl8GygeJcUD0hEfzPXH6ty8QbFcjadb0Vl2KLpX6a8EnjmuTuk3yZDX4yUOPz8fSrmqW3YQob9tmV5XwzR14iqGlkvP80no5PMqQg04wgrxOMGAh1SFXXsX7zeYBGgovFKS5awhqov4PXc/6tfjv6c92sKUctjx2dC+piGAJNMUBCvQAsUYPhJ+ZfByyi3r+Im0HS3o7cDFwpaaR+Q+nszhp4nfzu++WlmVEJRcwclTxzZogShYobz7x3AyCtrYiyLLWIinYtEI4qCt6S7XA2VRrxGK77IF1V926GD0MMmyPaisXeRFCeah7f6oTiJhi
 Jug9OOuW
 6qz0sziz4cR9nQ2TLgUaeblTu8nPQSJVmpEhFEYhXEMMyj7CkiFX6toL7Abof1RMtiA3Zgvzpd6Viln0+dbG9UxjzO6Nbsps9YX7jSBFLLniZaSC/ci9MZqgAJoBhprxVXvZ+ae6PBNzbymTYfFrJoLKLiV+nL+yrHsxONIG7fgWqzsenaFnSD+AtYHM4Xb5TtRxCENgBjd7ufVRrypl4bxmfR4Wtwf6OSgB/LEOb9Gm/du1/QRaED+L1PkGGW9sOShqQkX6PlgXq8zW3agc5KibH70SRkE368ieU0iLHWWmebUXRbUpgdSi+I7eiM6PYLU1GsNFWDUhe/wZ8PeW3c+9c61tqnDyOUEqw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:28:28AM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > This patch establishes fields within the vm_area_struct type to store the
> > anonymous page offset of VMAs.
>
> Nit: Avoid "This patch". Just say "Establish ..." (I was surprised to find
> that even Documentation/process/submitting-patches.rst document this)

Yeah ever since Boris nagged me I've (possibly reluctantly? :P) found that using
the active voice is a lot clearer and have been using that more so.

Will fix up on respin.

>
> >
> > The anonymous page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
> > if they are unfaulted or were not remapped, otherwise it is equal to this
> > value at the point of first fault.
> >
> > Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> > file-backed VMAs are tracked by their file offset. By adding anonymous
> > offset as a property of VMAs, we can now track them by their anonymous page
> > offset instead.
> >
> > By tracking this, we provide the means by which to eliminate this
> > inconsistency, and more importantly lay the foundations for future work for
> > the scalable CoW anonymous rmap rework.
> >
> > This patch simply adds the fields and some simple helpers. Subsequent
> > patches will update mm code to make use of these fields correctly.
> >
> > The fields chosen are packed in the VMA such that, for 64-bit kernel
> > builds, no additional space is taken up.
> >
> > The first field is present on cacheline 0 containing key VMA fields, and
> > the second on cacheline 3, which contains file-backed reverse mapping
> > fields.
> >
> > Given the relative time spent accessing reverse mapping fields as well as
> > updating them, there shouldn't be any performance impact here from false
> > sharing.
> >
> > Update the VMA userland tests to account for this change.
> >
> > No callsites are updated yet, so no functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> [...]
>
> > +static inline void __vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
> > +{
> > +#ifdef CONFIG_64BIT
> > +	vma->__vm_anon_pgoff_hi = pgoff >> 32;
> > +#endif
> > +	vma->__vm_anon_pgoff_lo = pgoff & GENMASK(31, 0);
> > +}
> > +
> > +static inline void vma_set_anon_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
> > +{
> > +	vma_assert_can_modify(vma);
> > +	__vma_set_anon_pgoff(vma, pgoff);
> > +}
> > +
> >  static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> >  {
> >  	vma_assert_can_modify(vma);
> > diff --git a/mm/vma_init.c b/mm/vma_init.c
> > index 715feee283f0..baa7e82f47e3 100644
> > --- a/mm/vma_init.c
> > +++ b/mm/vma_init.c
> > @@ -51,6 +51,7 @@ static void vm_area_init_from(const struct vm_area_struct *src,
> >  	dest->vm_end = src->vm_end;
> >  	dest->anon_vma = src->anon_vma;
> >  	dest->vm_pgoff = vma_start_pgoff(src);
> > +	__vma_set_anon_pgoff(dest, vma_start_anon_pgoff(src));
>
> It would be cleaner if both interfaces would either contain "start" or not contain it.
>
> The former would be better
>
> 	__vma_set_start_anon_pgoff(dest, vma_start_anon_pgoff(src));

Ack that's fair, will update it.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

