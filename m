Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E000CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D408E6B0435; Mon,  1 Jun 2026 11:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9CA6B0437; Mon,  1 Jun 2026 11:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8A16B0438; Mon,  1 Jun 2026 11:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62376B0435
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:46:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 718FDA066E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:46:10 +0000 (UTC)
X-FDA: 84831770100.12.C39E1A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A74D4180011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:46:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoqPuJnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrlHsS4KRfDsGdr749kmn/DhUCPw/KOCalL8i8LYz1c=;
	b=dzcobfzpsgF7LNgc1hdmGvUXd79yMcbFdL1fQRc3XKLNpe7S81aFoVBTzz0kp7u2KNLINP
	Mmf7tgSDublcYqnUPLR0PEpKJXqfL0kQMsQWMGXyWr+BN6qJblNzIllUBTiDic2JsmuH3f
	KwECnnF7F+sKT/kTOc9y4sBqRFt9Sx4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoqPuJnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328768;
	b=F8bnBnYlWlDozKZlnK1JcHm01xO/cUAF1VclvOlvftxSjqvvBr954cNB9Out5LK/BRXKpK
	NKunuNAlh+VAyN/6hL1WSJSGu+3PNNcP6JNsYG6NlK0mj5gez/MB2kE9HG10JnvHXIt/yW
	NnX8rl6+04gSKhQYoB5sFLaN1OvLk0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C84B04182E;
	Mon,  1 Jun 2026 15:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58051F00893;
	Mon,  1 Jun 2026 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328767;
	bh=wrlHsS4KRfDsGdr749kmn/DhUCPw/KOCalL8i8LYz1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hoqPuJnq8gdBJUlYahWPLphzL2cdaRnmCaJJDfN6Np/bczfyC7ctpgnkj++HhD7/k
	 Q6nf1As5sN2YFhs0WU9+DZ2JgOu3gWLtpJBZzsIf+03K8vYL5E8dntJs/CDglFb4sj
	 Xaeio0WzbGqheiV7NylPwAUy+W8wQ+7C4SftFqvbv1wkD8HnaUO4RbtigDxGuZQWWK
	 T8kKxeFQFh5ULjrWBt/luGuXTmAwedxY1p49K4OfjD78IfmbG/MM7e9iZvnJBV2d3X
	 UUNKVpyycNPGyuo5L8AcuswU2aM8PIDvwzasjWWKitcgmkjAeuCkeGymyv5N/CHI5P
	 +oOmpCtRMPuoQ==
Date: Mon, 1 Jun 2026 16:46:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_filter
Message-ID: <ah2oasz6oz4TgEiD@lucifer>
References: <cover.1779462249.git.ljs@kernel.org>
 <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
 <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h5ecgx87qe7wu13rft4y95fo4b3hhoj8
X-Rspamd-Queue-Id: A74D4180011
X-HE-Tag: 1780328768-721183
X-HE-Meta: U2FsdGVkX1+x3J7quriTuT5sRoVZH+Id8z58u+ZS6BmicNKk6pkgjhR7JR4MkcE0gTREg3qQW+eHZryQw4NQJv4hs8ABg2xzHka+23wkIpe9upiminLmWLdm+ro7u8X0AffUh68XESgCwdm6NrVWm9IABoTREAI1fSVSSlT72B4DdqVXFfuBkyoJZK02l3mXQae2g8BCzee3zA+YXd+JD7iq6A1bC50xGO/5OSnq1Qk1aW5Rp8LwwPNi48TeSVWBK03J6p/Mwc+6T1MUuL/4yAvxfX0t8UOWZNgYd7Cv+nGVP/GBUDDH+qltzulYBBlHiiqPYgpPCFNRf8RElNpWbtv6nst0QcEE+Z5lxeV1344/QOX9yMwKhTLzQ6IM0shimZpM7OAmBKBjUhfAyuIe0kGonrw4SONmyMLSlx0+mk0aP4XJ6y3cNARuomKLAVZ7hjFvAcwC8bpiO7Nxo7nCp+rmWInFOmCmWezZD9+f5R9NitAq9sTihgcjGyaVSQfRRmhcE2ElDnAcqB+WbimV6RgQeyF6Uy8WRTvAdxZMhiVOsnrgQaX6+8kLzzfiPsa0czkhUfYpeBfN7gkaUm/SeOifeBGYqrrWBXDtf/6zwddCjHriuzXc7M7BmMNkDg1PQSUKA3xu1UpslcuTRlA/ZMX+dL5jdoNp63e4AIkGYtWduIWnoQ743ScDBHzIzTDYULks3D2gJk9ErZAPVgAS9JvcyStGCBpLz83izWEw7eaGogaHStPMF1xgXZKIJ/5KfqNvcjoH0ET/ZVVmdDeA1GV7EViqgdngVjujvKzC+om6iejxNJtybGIAloz9O/vP1xTvZJvrCAMeZ0r8+sFkrQ5s59nk4SF1BU7DVyEyMmHS9pfYevDTGJRCJ7G9tQVqfCadDP2B56bhS5oxEugDaXVWYaDjV4Q5I3mQN+pBZssQoZktdYxLzVpZpXR4OWt5iHUXt0oipRI7Y+9AbTf
 AV1Bb+QT
 jmAb6YrzdgjxdyECM5pDdW8f+ICOZR5Nvqmx4XV4JggZjFt9r8ZP4VCTxUSRKUyUnqB6l4Y7jWFIW0AUOO3CARj1YevPFohU5DYnJEZEWrTZmzAHgEZEaV1L2fICEedZAXKwWY3AfLqzz2GYl2lDVH5xiM2gJanYMNmzqartLqjpnprSp+odU4/1SuJDt++1Xf+v8hm6OWQdO4/qjMqEVovztK3UxlYZdS0LA8aZdEwD978JEszbCraV3tAgw85ywcVyFLKYxHMhDeW5zjLExbnMry1QhCGLFcup6J7i32hOr3kl51ECaKCmPOJnGH10fge+y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:25:46PM +0200, David Hildenbrand (Arm) wrote:
> On 5/22/26 18:00, Lorenzo Stoakes wrote:
> > Rather than providing a hook, simplify things by providing the ability to
> > filter errors. This allows us to more carefully validate the value provided
> > and thus ensure only a valid error code is specified, and simplifies the
> > interface.
> >
> > This way, we eliminate all hooks but mmap_prepare and allow only mmap
> > actions to be specified (which core mm controls).
> >
> > This significantly improves robustness and eliminates any unnecessary code
> > duplication in driver mmap hooks.
> >
> > We also update the /dev/mem logic (the only user) to use
> > mmap_action->error_filter instead.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  drivers/char/mem.c              |  8 +-------
> >  include/linux/mm_types.h        |  9 +++------
> >  mm/util.c                       | 29 +++++++++++++++++++++--------
> >  tools/testing/vma/include/dup.h |  9 +++------
> >  4 files changed, 28 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index a4297eb39887..11639d988e47 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -322,11 +322,6 @@ static const struct vm_operations_struct mmap_mem_ops = {
> >  #endif
> >  };
> >
> > -static int mmap_filter_error(int err)
> > -{
> > -	return -EAGAIN;
> > -}
> > -
> >  static int mmap_mem_prepare(struct vm_area_desc *desc)
> >  {
> >  	struct file *file = desc->file;
> > @@ -362,8 +357,7 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
> >
> >  	/* Remap-pfn-range will mark the range with the I/O flag. */
> >  	mmap_action_remap_full(desc, desc->pgoff);
> > -	/* We filter remap errors to -EAGAIN. */
> > -	desc->action.error_hook = mmap_filter_error;
> > +	desc->action.error_filter = -EAGAIN;
> >
> >  	return 0;
> >  }
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 945c0a5386d6..8d1fb85e7684 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -844,13 +844,10 @@ struct mmap_action {
> >  	enum mmap_action_type type;
> >
> >  	/*
> > -	 * If specified, this hook is invoked when an error occurred when
> > -	 * attempting the selected action.
> > -	 *
> > -	 * The hook can return an error code in order to filter the error, but
> > -	 * it is not valid to clear the error here.
> > +	 * If non-zero, filter errors that arise from mmap actions such that we
> > +	 * return error_filter instead. Only valid error codes may be specified.
>
> Is that really a filter or rather an "error conversion" / "error override".
>
> "Filter" to my German brain implies that we would ... filter selected error
> codes, not convert them to something else?

I thik it's what people tend to call this, it's what I've seen it called anyway!
I mean your German brain is being logical :) but by convention going with this
terminology.

>
> >  	 */
> > -	int (*error_hook)(int err);
> > +	int error_filter;
> >
> >  	/*
> >  	 * This should be set in rare instances where the operation required
> > diff --git a/mm/util.c b/mm/util.c
> > index 4e172990afcd..9b4e5432d45a 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1414,16 +1414,22 @@ static int mmap_action_finish(struct vm_area_struct *vma,
> >  	 */
> >  	len = vma_pages(vma) << PAGE_SHIFT;
> >  	do_munmap(current->mm, vma->vm_start, len, NULL);
> > -	if (action->error_hook) {
> > -		/* We may want to filter the error. */
> > -		err = action->error_hook(err);
> > -		/* The caller should not clear the error. */
> > -		VM_WARN_ON_ONCE(!err);
> > -	}
> > -	return err;
> > +
> > +	return action->error_filter ?: err;
> >  }
>
> Out of interest, why does dev/mem require this monstrosity?

I'm not sure if it's really necessary, but I don't want to break userspace here
by suddenly changing something that very plausible userspace might treat
differently from other error codes (-EAGAIN).

>
> If it's really a dev/mem specialty, you could just make it less generic and call
> the property
>
> "bool eagain_on_error;"
>
> because surely, we don't want any more such monstrosity?

I'd rather not, because I suspect there might be some other cases of this, and
it makes this option kinda horrible, as if it were a sane idea to convert errors
to -EAGAIN :P

Later on, once I've done more conversions, can obviously figure out a better way
or whether we can just remove it.

For now I want to eliminate these two horrible success/error hook hacks so we
can move ahead more sanely (and I can in particular figure out a less horrible
way of making the hugetlb 'vma lock' horror show work with mmap_prepare :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

