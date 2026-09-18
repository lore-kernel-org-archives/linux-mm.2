Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED57AC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199926B009F; Fri, 18 Sep 2026 12:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B056B00A0; Fri, 18 Sep 2026 12:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088176B00A1; Fri, 18 Sep 2026 12:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D44AC6B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:35:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21CC31C2F78
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:35:11 +0000 (UTC)
X-FDA: 85227432822.29.8F9FE3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8A39C20004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:35:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UNsi5FW/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UNsi5FW/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749309;
	b=apioCuPffujTl0FUjmrlzCIu+ug5rl77eTRpdy8U5dT+qouMkxQLwhGAfdAKxxa/wCm6zV
	EXe2JA4OrMQtmKngLYKkguYHPdjEYLstp3zJWRKBD8KC6UyZq4L7EcEdZ/wwJT0wBkjgU+
	E8XapaZe0v/Ud1OVHlG0wGBH1yMXMRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZGqO5tWPMSBZG1lXUTnY1c8FiuuLCzJcsIMwbTz0KQ=;
	b=dqGeh4HvRGOu8jWORXq53cA3XAKQ+1iqvht8czl4QFDc3P6fjS0GG8fM04C5Xjim/EVO/w
	Igh1S638TnAHCkhhHUiLAX5rrV4DzxJbk7LlMeFqv/v0oyeVPGBO9+o8NKi0EKmu1DGKg9
	FVBmrtrSVdPv9dy3czQv+P/3TEwTuTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FADD602CC;
	Fri, 18 Sep 2026 16:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FEE1F00898;
	Fri, 18 Sep 2026 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749308;
	bh=SZGqO5tWPMSBZG1lXUTnY1c8FiuuLCzJcsIMwbTz0KQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UNsi5FW/17pn89Ref9walQd57L7IG7TkWC5AX+0goE2gCbGP1tWDRSNJ0Q7k+V8We
	 w49ArJP/vRRnyl2nWJIbNkHCS/1KbD6jEb+FpAfiGcgKM3eXrJEnxhJVoBHxErgKn/
	 LQe32Sjp8vO6Lmi94U7ATodVBcfM76gQaAyrYAXyGIGkmtLEuq4DTOc9Xer9c74ZhL
	 plJEDtO0zQjIoM+7zaUxvu7n8Np+Cjm4w81KvqD9aThLmfPq+a+B/7E4wjmqJQs95f
	 jji3GfvUjk6mcx/spnHlA3kE+qqwGXGMjSEk9IrCyk5hSGSx9yVTaeATLaLiQSJPvG
	 +uCb/j9wLdiVw==
Date: Fri, 18 Sep 2026 17:35:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <aq1noAdz9U3tXH_Y@gremlin>
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A39C20004
X-Stat-Signature: 7jbrf84ccpjtcbdmjxr87916e5o67b6x
X-Rspamd-Server: rspam01
X-HE-Tag: 1789749309-89675
X-HE-Meta: U2FsdGVkX18QDbG2GwYJ1AmILgwqn5Xv1cIyI0ItkL213zqDon7Opf4vTUHiyPAdUCDlig6kYRbZufNQ0gP60ZNg8O9hi6/nAQRwxAZNbcVQ8NopdkAtoUKpnGdPJyk0DIy9Ejn5W1P07h+upNmLJ8kvPBxjRMHN9XNLE/aqJgtC1FG/Cob1ok+akKKnKp4N/Gj3vd+QUMJJRL7xTrM6gbS9n2fVaRC4aP2phyFNRpS2fQTOE5m8Hpznc/Ync98U24rXePEQDKmdr5E4ucAvwJDpitsTU5ypIJrCeLidosJbQuYeNbXhKIsZjnx9Onz0GctSiLSscmb/48FTAXS60wxoaqvic1EfYJ3O4YOdrrRyp3YXOkxRFn9R2tUV9uqlZx1ujw+Ug1y3BeUjrTcGNSKNbZccteOMnijxXWjdphM/043RT/3h+F97wDOEPFgz4IekokF0iF6arvwonCNlsTEC4di0MfW+vQYP54ENpvCoqr9pjUFklr6d16JUYcaKZ13pgvACXuWe+f7Iv2OtDHyq7bLTlM6euDdYWvSYY5b7FRa9HWSst07yVbJoyddacwVqwof5WsDsL9FQWgSzedonkYzkgH97F43XC7ujU8SVZr7korcqHTVGCq9t8XsH8yWcIQee0vXEQcRBI26oS+wlFl9PAAP6IzaE6TuaYcPGl7wwSTl8rs2pM14bs0t4anoKtAQHrP25p282vyTe/80Aeerl1Be7hKy7llkcUmNRwjJ1X6tShf7fwOEeeOCMHHAu5xR1MjpTCRg/Xm+8rNAULktIby5Dux4G8dWRh66nfiGPx2vvPt1YBwq64k59fKEHR9EiiXRX6og1asWiuBRHF44QhB9HCcRfVsJPp4YPzA9UC8CdO1iHmqIAncIzSS+qBV2JOHkRP0KqBIJ/qy39ZAGhpdNsBlzrCXvPzOaAp8b7wEhVfW11OUr5C956Bjl5UrKTWmW5X30z3GN
 iz9sZdpl
 hqa9hVcib15q/aRhHKiPevngUdluKx+sLN6yseMgpp7l6iCd7Y2+1ggxx3Cm472nSaUG6RhaeYQozNDavYTc9jo1+Fu3GCCvtVMT70sDh3MuAhIr07++gTlxnJoqQfdWBwbSLYLNIBxd/6G6nR20Ov/+EZX0RUY6WSQAcMhc+O8JOdvBYsqLjPaRK6y9D5eaC/J4tQ3bQKTxgKeLVeRSxIeWpfBNs1ZOYAn83j84bddoagqMNJUvtumUREMpe6mdR4FREc6xJltQToPWZwfLj38Jj/sHNvforRCtfudvSWg7dXnD7JHOJzpZ2Ktpb+4vuDJxMBV5K7PF5f/QtTLeh8vChQP7mGs5E/enElXNtSG0rmh4Ux3ZKKBuQs/VudPkNDiSy3Nvq5sKtrUteePB3GBKTacu5fIDz5eOFDf+iqOjG41RmwU1h8Q1P8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looping in Ulad who is best placed to respond on this.

Ulad could you look at the below? Thanks! :)

On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> Hi Suren、David、Lorenzo
>
> On 2026/9/17 09:12, Hao Ge wrote:
> > Hi Suren
> >
> > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> >> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >>>
> >>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
> >>>>
> >>>> Hi Suren
> >>>>
> >>>> Thanks for you review.
> >>>>
> >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> >>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
> >>>>>>
> >>>>>> The reservation is already stored in the maple tree when
> >>>>>> vm_module_tags_populate() fails. A failed load never unloads the
> >>>>>> module, so nothing releases the entry. Release it and roll
> >>>>>> module_tags.size back. Without the rollback a concurrent load that
> >>>>>> already passed needs_section_mem() can reuse the freed gap, skip
> >>>>>> vm_module_tags_populate() and write to unmapped memory.
> >>>>>>
> >>>>>> vmap_pages_range() may have installed some PTEs before failing. A
> >>>>>> retry to populate the same range would BUG on them, so undo them,
> >>>>>> but only if vmap actually ran.
> >>>>>>
> >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> >>>>>
> >>>>> If a patch fixes two other patches, it likely needs to be split so
> >>>>> that each part fixes one patch only. But read on please. I'm not sure
> >>>>> if one of the fixes is correct.
> >>>>>
> >>>>
> >>>> Kept them in one patch because they only make sense together.
> >>>>
> >>>> After a failed populate the reservation is released and the
> >>>> size rolled back, so the next load takes the same gap and calls
> >>>> vm_module_tags_populate() again, and that retry would trip over
> >>>> the PTEs the failed vmap left behind.
> >>>>
> >>>> Without the rollback a load that already passed needs_section_mem()
> >>>> just reuses the gap, skips populate and writes to unmapped memory.
> >>>> So splitting them leaves each half broken.
> >>>
> >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> >>> completely separate patch with vmap_pages_range() doing cleanup
> >>> itself.
> >>>
> >
> > I think I get where you're coming from now.
> > Thanks for taking the time to explain.
> >
> >>>>
> >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>>>>> ---
> >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> >>>>>>  1 file changed, 10 insertions(+)
> >>>>>>
> >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> >>>>>> --- a/mm/alloc_tag.c
> >>>>>> +++ b/mm/alloc_tag.c
> >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> >>>>>>                                      next_page, PAGE_SHIFT) < 0) {
> >>>>>>                         release_pages_arg arg = { .pages = next_page };
> >>>>>>
> >>>>>> +                       /*
> >>>>>> +                        * vmap_pages_range() only runs once all pages were
> >>>>>> +                        * allocated, and it may have installed some mappings
> >>>>>> +                        * before failing. Undo them.
> >>>>>
> >>>>> If vmap_pages_range() failed to map the range, why should we need to
> >>>>> undo it? If it indeed leaves some partial mapping when failing then I
> >>>>> would argue that vmap_pages_range() should be undoing these partial
> >>>>> mappings itself before returning the error.
> >>>>>
> >>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
> >>>
> >>> Hmm. I wonder if this behavior is intentional or requires a fix. The
> >>> only possible reason I can think of is performance but I can't imagine
> >>> a failure to map is a performance-critical case.
> >>>
> >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> >>
> >> Huh, my gmail thinks you are still at your previous companies :)
> >>
> >
> > I manually fixed it on the mailing list for this thread.
> >
> >>> guys think? Shouldn't vmap_pages_range() undo its possible partial
> >>> mapping when it fails?
> >>>
> >>>
> >>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
> >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> >>>> so I did the same here.
> >>>>
> >>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
> >>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
> >>>> the current behaviour for now.
> >>>
> >>> Yeah, I understand it would require a deeper cut but if that's the
> >>> right way to handle this we might as well do that. Let's see what MM
> >>> folks think.
> >>>
> >
> > Sounds good to me. Let's wait and hear what the MM folks say.
> >
>
> I just looked into the call sites for __vmap_pages_range.
> And I found there's a bug in one vmalloc caller [1].
> When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> __vmap_pages_range. If there are leftover PTE mappings,
> this can trigger a BUG(); [2]
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [1]
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [2]

I think best person to look at this is Ulad as vmalloc is his baby :)

Ulad, what do you think?

Thread is at
https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/ for
context.

>
> > Thanks
> > Best Regards
> > Hao
> >
> >>>>
> >>>> Thanks
> >>>> Best Regards
> >>>> Hao
> >>>>
> >>>>>> +                        */
> >>>>>> +                       if (nr == more_pages)
> >>>>>> +                               vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
> >>>>>>                         /* Clean up and error out */
> >>>>>>                         release_pages(arg, nr);
> >>>>>>                         return -ENOMEM;
> >>>>>> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
> >>>>>>                 return ret;
> >>>>>>
> >>>>>>         if (module_tags.size < offset + size) {
> >>>>>> +               unsigned long prev_size = module_tags.size;
> >>>>>>                 int grow_res;
> >>>>>>
> >>>>>>                 module_tags.size = offset + size;
> >>>>>> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
> >>>>>>                         shutdown_mem_profiling(true);
> >>>>>>                         pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
> >>>>>>                                mod->name);
> >>>>>> +                       release_module_tags(mod, false);
> >>>>>> +                       module_tags.size = prev_size;
> >>>>>
> >>>>> Yes, this one is a valid fix. It fixes 0f9b685626da commit.
> >>>>>
> >>>>>>                         return ERR_PTR(grow_res);
> >>>>>>                 }
> >>>>>>         }
> >>>>>> --
> >>>>>> 2.25.1
> >>>>>>

--
Cheers, Lorenzo

