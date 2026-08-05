Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E117C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53766B0096; Wed,  5 Aug 2026 12:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04BA6B0098; Wed,  5 Aug 2026 12:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BFF6B0099; Wed,  5 Aug 2026 12:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBB06B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:27:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05BA4A2045
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:27:59 +0000 (UTC)
X-FDA: 85067747478.30.3D4A5B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 49D3C40009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:27:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFdanjjY;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcjdpcvuSBVyPfDvA9h6SvDPo3TBbgRAWLcSklwC0PA=;
	b=KMMJeDaIaydwOB214FQTuoqmKn/SVmeS5DQDH482dLQxgpjm8Y9wX+FZTnF1aGmf+nw0EX
	tNE3bPUrxKJAQoxaWh1x9LyRqtVjcueKo/KzR22+KHlUUh9eScmf6dAZJqlpCD/+OVmHtX
	Lu9x5n/WSXnIU0te7nHdMFYhBq+kecc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947277;
	b=apPL7aJGD+YRceIKESmcmxMVEPBmhQ7r7VulHVmr1GJ5wVa4RYGvTIzRGAbh4Z+yz8Kc2K
	/qEr4ZiDB5yKl2hK2VposVV65VtA5CxpyaX2rildn2XByFcUlsR5/hbyPmDDl2OMGgmYE9
	jYMJVWqoiv2opL5E2at8uNsLj31fvCE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFdanjjY;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0CD860A5A;
	Wed,  5 Aug 2026 16:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098BB1F000E9;
	Wed,  5 Aug 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785947276;
	bh=gcjdpcvuSBVyPfDvA9h6SvDPo3TBbgRAWLcSklwC0PA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mFdanjjY4+L1b6Jc7V+v5oQLMPvGxoVZrzBXVHFQb56qYB1IZ/PYRlcpRY3InWwJl
	 gkat7L75KKcyABsb1WmyAKTHmsybzsEBuVPR9LLszpSRn0udYicjjlihmMfSxGxKKF
	 jhsZ7fjGGcCjC3sZGfZGF7TUzmhghfeS8eGGFkvNkYdH0JtwiBrumJH32qVwWNwO2Q
	 rht3aBzwR07eweIxhVtxbTz95/bsn6SJSEIypLpL/4bZwRfc+E/2NlkK9eK7WAvICS
	 rCj8DtyKgZMtqqcfZ2ay96x6Hff+W8rv/F4feec7IcDwXo7tB4DUPTXAJfB1Dzldxc
	 UfpzCGCnE4N1g==
Date: Wed, 5 Aug 2026 17:27:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/ksm: validate KSM rmap items before hwpoison kill
Message-ID: <anNkZix4l2DlmjEd@lucifer>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <72f017f2-89c5-4e4a-9ce3-ab79f70b04a0@kernel.org>
 <a27c1872-c4bd-4f3f-b2b8-d34e2f055411@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a27c1872-c4bd-4f3f-b2b8-d34e2f055411@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49D3C40009
X-Rspam-User: 
X-Stat-Signature: qk1hphpebtywf7iuexpxffjz4ubcj8p3
X-HE-Tag: 1785947277-923089
X-HE-Meta: U2FsdGVkX1/TpkD4LeSqGpdmhOuR+gro9cJxBuNMZRDoNwcTOTWjvtbt4E/Li7vgBZ1B/0Aija7DeIkw3AMC1aABHNXoDwbudAvmIGxPBTpDD5cs2iyf574P75tf689HXDDfjDpweZXWfnohNXXYObvMXWQanbUqVxOoUP1m2IXaoEJr0l6DfN0ilj4jXlR1unRggIGiEUqt2Xgb/06wPgsVhxJYuC5rpAdKnMaeaXQGN0ykaeZDc141CHcTXfddnmzj8G6AY3SGikFntDYPfJog2swIhSZ+s2DgfSAF0nMvHWlAZApeJohg2I7hGrUEeqQEs/O1ACtwr44hszMEvRkP5BTxxrERw07ydiUrfAav7cd4Fy4mue7k7w+OOQbeTij2PfSn1LRyI+D2zZCYAOQW3gxiPfabESRpHvrss5+1Ym86Yqsx+K5vCIv12b2ahoOJ6hz73PplJidYz13BU+MgGRZ7mH81MlvOCzWWskUvISZex28JvIT372VeJN8/KwlrD0TB8rtCxtKAmRZdR+FE7+rgktG7H+pCJOMKwRMhrBfDZ0J9UmgvxqFXYXrGIxEsQuyACXRtXdjBKVI8rUYkrc/Tuc2bu1YZqedjC7AOqaYgDRG7evRkAilgiSFkUBgMC5YUbxvFbrzPIgPy9Sj4KzkJF9/aWyw8iD4QRNzaNV4kd+EHs8rDtmxA92oyJ/TUp61jd6iD77HkMLTrevC92P50uO4Fa+H5xx22c8hntNyi8OvzNMXSREFbm5TfnQrnvtSykbOcauT8K/fBVShdXtQVnZxommcU+TJZWYSyn9x7G8d1EyWtQZ2bXBWYP03I1wJxQQ2f4MVOEco7zVAaV0Jsdx7LAUNfqviXZLPVdUTPdvW1Wz9O3tFWETaK+oKGs/8rgRvb5ANlvztho3g/9zeFyCD7fNwEg8sYa7ESK256IpeIlyNkpiQeuj3Y3wYRBFxJPuS9URzXMDy
 O0LYA6zq
 XvIt3nIIYnddEfdyD2JV27m+yaDZ1SUUztUWgVLLWUob/T6DRREnW6A5vFaR8IbUqJrTjyaMp2ivZOeBj6ibRtvXqK88nrnDJaU6UMFHoLWMIouZZy+Yj7DjWhKjpCYtlnPPqnf3NtX0eVycGVi24Jc8y3+odEcWN85kWG62OS/wAA940nw3wSJUHUee25SxMsCmyGsv3FJOQctR+xlyiqgeTBtDG8JDGkMXX9fL1uQZJOcyMCmOHpobgS3VJ5ts1XcgnqK2ckHKMuWvkxaXZwW5tzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 12:21:24AM +0800, Longlong Xia wrote:
>   Hi David,
>
>   Thanks for the review and for suggesting this approach.
>
>   I will send v2 shortly with your Suggested-by tag.

Hang on :) I wanted to look at this (always better to wait at least a day before
respins in general).

>
>   Thanks,
>   Longlong
>
> 在 2026/8/5 20:19, David Hildenbrand (Arm) 写道:
> > On 8/3/26 17:11, Longlong Xia wrote:
> > > From: Longlong Xia <xialonglong@kylinos.cn>
> > >
> > > collect_procs_ksm() walks the stable-node rmap list and queues an
> > > early kill for every task whose mm appears on the anon_vma chain.
> > >
> > > That rmap item can be stale by the time memory failure handles the
> > > poisoned KSM page.  A VMA may have been split, unmapped or remapped
> > > after the rmap item was recorded, so matching only vma->vm_mm can send
> > > SIGBUS with an address that no longer maps the poisoned page.
> > >
> > > Check that the saved address still belongs to the VMA and that
> > > page_vma_mapped_walk() still finds the poisoned page there before
> > > adding the task to the kill list.
> > >
> > > Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
> > > Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> > > ---
> > >   mm/ksm.c | 27 +++++++++++++++++++++++++--
> > >   1 file changed, 25 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index 7d5b76478f0b..bc4b2dd894d8 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -3222,6 +3222,27 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> > >   }
> > >   #ifdef CONFIG_MEMORY_FAILURE
> > > +static bool ksm_rmap_item_mapped(const struct page *page,
> > > +				 struct vm_area_struct *vma,
> > > +				 unsigned long addr)
> > Two tab indent on second parameter line
> >
> > 	struct vm_area_struct *vma, unsigned long addr)
> >
> > > +{
> > > +	struct page_vma_mapped_walk pvmw = {
> > > +		.pfn = page_to_pfn(page),
> > > +		.nr_pages = 1,
> > > +		.vma = vma,
> > > +		.address = addr,
> > > +		.flags = PVMW_SYNC,
> > > +	};
> > > +
> > > +	if (addr < vma->vm_start || addr >= vma->vm_end)
> > > +		return false;
> > > +	if (!page_vma_mapped_walk(&pvmw))
> > > +		return false;
> > > +	page_vma_mapped_walk_done(&pvmw);
> > > +
> > We have page_mapped_in_vma(). So I wonder whether we can find a way to
> >
> > 1) Modify to just work with KSM (CCing Lorenzo)
> >
> > Maybe it already does. I'm confused as so often.
> >
> > Looking at the existing caller collect_procs_anon(), it's really only called
> > on anon folios. Could it already be called on KSM folios? What would happen
> > in that case? (does it just work because folio->index is still what we expect)
> >
> > 2) Do the following
> >
> > diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> > index d7670ba4147bf..7eeb3c336cfe9 100644
> > --- a/mm/page_vma_mapped.c
> > +++ b/mm/page_vma_mapped.c
> > @@ -342,6 +342,27 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >   }
> >   #ifdef CONFIG_MEMORY_FAILURE
> > +static unsigned long page_mapped_in_vma_at_address(const struct page *page,
> > +               struct vm_area_struct *vma, unsigned long addr)
> > +{
> > +       const struct folio *folio = page_folio(page);
> > +       struct page_vma_mapped_walk pvmw = {
> > +               .pfn = page_to_pfn(page),
> > +               .nr_pages = 1,
> > +               .vma = vma,
> > +               .address = addr,
> > +               .flags = PVMW_SYNC,
> > +       };
> > +
> > +       if (addr < vma->vm_start || addr >= vma->vm_end)
> > +               return -EFAULT;
> > +       if (!page_vma_mapped_walk(&pvmw))
> > +               return -EFAULT;
> > +       page_vma_mapped_walk_done(&pvmw);
> > +out:
> > +       return pvmw.address;
> > +}
> > +
> >   /**
> >    * page_mapped_in_vma - check whether a page is really mapped in a VMA
> >    * @page: the page to test
> > @@ -355,21 +376,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >   unsigned long page_mapped_in_vma(const struct page *page,
> >                  struct vm_area_struct *vma)
> >   {
> > -       const struct folio *folio = page_folio(page);
> > -       struct page_vma_mapped_walk pvmw = {
> > -               .pfn = page_to_pfn(page),
> > -               .nr_pages = 1,
> > -               .vma = vma,
> > -               .flags = PVMW_SYNC,
> > -       };
> > +       const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
> > -       pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
> > -       if (pvmw.address == -EFAULT)
> > -               goto out;
> > -       if (!page_vma_mapped_walk(&pvmw))
> > +       if (addr == -EFAULT)
> >                  return -EFAULT;
> > -       page_vma_mapped_walk_done(&pvmw);
> > -out:
> > -       return pvmw.address;
> > +       return page_mapped_in_vma_at_address(page, vma, addr);
> >   }
> >   #endif
> >
> >
> > > +	return true;
> > > +}
> > > +
> > >   /*
> > >    * Collect processes when the error hit an ksm page.
> > >    */
> > > @@ -3237,13 +3258,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
> > >   	if (!stable_node)
> > >   		return;
> > >   	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> > > +		unsigned long addr = rmap_item->address & PAGE_MASK;
> > Can be const.
> >
> > >   		struct anon_vma *av = rmap_item->anon_vma;
> > >   		anon_vma_lock_read(av);
> > >   		rcu_read_lock();
> > >   		for_each_process(tsk) {
> > >   			struct anon_vma_chain *vmac;
> > > -			unsigned long addr;
> > >   			struct task_struct *t =
> > >   				task_early_kill(tsk, force_early);
> > >   			if (!t)
> > > @@ -3253,7 +3274,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
> > >   			{
> > >   				vma = vmac->vma;
> > >   				if (vma->vm_mm == t->mm) {
> > > -					addr = rmap_item->address & PAGE_MASK;
> > > +					if (!ksm_rmap_item_mapped(page, vma,
> > > +								  addr))
> > jut put that onto a single line, please: easier to read.
> >
> > > +						continue;
> > >   					add_to_kill_ksm(t, page, vma, to_kill,
> > >   							addr);
> > >   				}
> >
>

--
Cheers, Lorenzo

