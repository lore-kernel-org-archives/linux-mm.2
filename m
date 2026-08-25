Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2934FC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB5C6B009D; Tue, 25 Aug 2026 09:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2F06B009E; Tue, 25 Aug 2026 09:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B436B009F; Tue, 25 Aug 2026 09:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9596B009D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:00:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D84A120438
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:00:23 +0000 (UTC)
X-FDA: 85139800326.06.1F3DC57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DC202120007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:00:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0UvnAEG;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfOKtnng6T1xYEK1VgxhBRbh9ravAjHw+w2ofwHQs5A=;
	b=fhyjzKb8ucO/jlbsM7JhexcWOd0TIqSxN0uyjC2CShuZx9rSICf9eHGNCQLzexpOwhOkd7
	dY+0eJyCgHEixpo7lJFRWySFySbseA1eNPKCWCqEn+AQEm8dG0eVyB+khplI2lU64kGeq3
	WzCUI2X3b+sOU9+jlVH8aM7KOnFcOqw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0UvnAEG;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662822;
	b=2TRLIAPsc6cSIzHJ+nc4KCUMlT2v4UHG6cBCljEI8XHMNuFOYQz19/fhzJe4NxY8eyHils
	1WXE3oyjvKB8LGqp5QPwy7b4p3jIl9+qNvV8umcpJt88HQ9udyQYcdpesJFt4ozEJij26O
	ZlwDON7W6v85sh/r9LGHDbwpjXsJ+p4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14EEE41278;
	Tue, 25 Aug 2026 13:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B46A1F00A3A;
	Tue, 25 Aug 2026 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662821;
	bh=qfOKtnng6T1xYEK1VgxhBRbh9ravAjHw+w2ofwHQs5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l0UvnAEG/Zo8r3CykoUrq6NAVJZam1+zHgtTNyKABeLMTMIn3AIjlQxS8M8WsJ3Dk
	 OSjtXy9nbuudzP9xJ2PWeC3iuoN3WW/WOQmRorbeMBpHg/vRGoNZselhTAkK5a2Xru
	 0wjZvaiuiIp2XOI70jbATNae62Vr6YUBTZiA4fIHh3ftqnj6+vPzfRYnF0aJ1j1kSa
	 iMuGLEinc55lHWlqbfHEMdnNMQ5YlymbIAoid0plZN8erqJxxUnh7lROb2Nt+m2V+c
	 Qe5Z/t9+ljxpA9/shQurYfAeS85rvU/UZg+g36P5gF3TedFNFenR4d/NRIEIcseHfN
	 aw52iDMO8oUGw==
Date: Tue, 25 Aug 2026 14:00:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <ao2Qk87AKnMKuNvg@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <aoxm4jUrmL1eQlCJ@gremlin>
 <ao1waln1lklfk8th@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao1waln1lklfk8th@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC202120007
X-Stat-Signature: suhwttubud1r5aut4a9gg8cismxgzn8b
X-Rspam-User: 
X-HE-Tag: 1787662821-720388
X-HE-Meta: U2FsdGVkX19CKIZq+v/i3TwJxgh9z0aEndwkzAblBvfIUk0GCH9I6XmPzlmTRDSjWKxQGCpfdfY+gvS+ZiKrMveJmHQTb+dTGiW2o4NVJlG+nmGo0eCxbHhBxHA2EW25QRJ0yVr273J13n4N0c1NS4k1EwgLrmt2kzoxJVjoeg9fJeJUE8B9r+b5Xt82/ICIrUdQZlST7B9y4LIL1q/rClrc5HBuU4YxsfdrpjghOL6kK4u8oc01GusC0H4248eLcJAJ7n2YKNzGqYD+Bw0UTbh1ZYbn13m0VUhXwg0Eo89Go6GlShAzdNMIAVsIXKgsU4ySLhHFZdOcf6R2bxZvI2qMIxg7i8op6fbduyLN0dPe52hXAiF8bMmOrPKXtfEjmlNJYhjCYvI6fwKtWhM/W911jrQPg8iteLWDOsNCZXLjtIpCLq/Sp3c620KfQKe6/J/jeIqsAtgoKRRLW27H5dmbwI50HThi82OiynwCEwIv0L6nkWPDcjocgz+MeJ04UQsYyf8mUOmm+qwJPWmnyAS8P+ncwndauVBC+yZSHJmGJSa3zwVIabc12WgRnBwmrs+GHWlXzr/nNU5jazpk0VedD96kQr2Lr7VMMFDHyZsW7H3jwZuoFUKBMJ4G6ehx2SqQdSlRnQ0a0Ngd+eJSGVwxSUzbkdlHP7xXumKUcTaiFqtawpIpZAk9cRFCeWiS+9rZQR5poeHyCoJGgSW89zw1RvbE4nNAcWsKFS4w4elWjIp/IzTTJLTAqULWsHYkoF67mURr22WbousaSmCc3B3+3TWLQ1X218HmctMh9/7bqdSvx24B9+yQ9cJbcU8ldM57Jo2k7JA7wmZ2IivUITwvJt4OY81q0b9jgicYYkGrI7YokhDld6/ziO/JJSflkdTzyFOcIKu0pHO8TH9SEEqBymw/edx8ozt0vjI0fJ93N+RU4AHahOGXsg4YFG2n9Ky+/P8YcGx23cxKlJv
 pfDhdI6w
 grgYTjwXp4MDU7DBgz8ePIZ9TAYntXfv5fhTgvH/trtW+wMj8MgGen39eeNnqYgH7UyKb/3B1zu/yxfV4G83i0y8zZDhmjrD54vYPjmHgKruYPhN3UarzWsUnyeYtgI9Nn3KITvkAqA00H5y7XZ5I8TIKeGZbzstcPXEhZJqW3i+Q4B+am6gwwYG0gFcv9k0+VN47EiGSUweqwwDKSU/HtRHV07CWXAVKQpVt7Cs4Lz+sldvOzqxdl3cwu6qlGOG10DPAspSO7FYah8ISd6NxrjuVIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:37:30PM +0300, Mike Rapoport wrote:
> On Mon, Aug 24, 2026 at 05:28:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sun, Aug 23, 2026 at 03:17:42PM +0300, Mike Rapoport (Microsoft) wrote:
> > > Introduce enum uffd_reason to define reasons for user faults rather than
> > > overload VM_UFFD_* VMA flags for that.
> > >
> > > Using a dedicated enum makes the code clearer and decoupling the fault
> > > reason from VMA flags clears the way for moving the uffd mode bits out
> > > of VMA namespace.
> > >
> > > No functional change.
> > >
> > > Assisted-by: copilot:claude-opus-4.6
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
> > >  include/uapi/linux/userfaultfd.h |  6 +++---
> > >  mm/huge_memory.c                 |  6 +++---
> > >  mm/hugetlb.c                     | 10 +++++-----
> > >  mm/memory.c                      | 10 +++++-----
> > >  mm/shmem.c                       |  4 ++--
> > >  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
> > >  7 files changed, 47 insertions(+), 35 deletions(-)
> > >
> > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > index 45355bdb4ec7..f401623f315d 100644
> > > --- a/include/linux/userfaultfd_k.h
> > > +++ b/include/linux/userfaultfd_k.h
> > > @@ -9,6 +9,18 @@
> > >  #ifndef _LINUX_USERFAULTFD_K_H
> > >  #define _LINUX_USERFAULTFD_K_H
> > >
> > > +#include <linux/bits.h>
> > > +
> > > +/* Fault reason #PF handler passes to handle_userfault() */
> > > +enum uf_reason {
> > > +	USERFAULT_MISSING	= BIT(0),
> > > +	USERFAULT_MINOR		= BIT(1),
> > > +	USERFAULT_RWP		= BIT(2),
> > > +	USERFAULT_WP		= BIT(3),
> > > +};
> >
> > Hmm your commit message says uffd_reason, uf_reason makes me think of the
> > character Ulf from House of the Dragon. But not uffd. So as per David let's
> > rename it :)
> >
> > I'm also not sure if an enum is the right thing for flag values?
>
> I'll ask LLM why it chose it :)

I mean you then introduce the same flags again seemingly with different
names as #define's in the next patch... having several sets of flags with
subtly different names seems unwise.

It seems there is a 'mode' and a 'reason', maybe I missed something but
that just seems overly complicated.


But in general I think the objection to using an enum for flags is because
the compiler will treat a switch() {} of the enums as the only independent
values and possibly in other places too.

That's super theoretical but it is an odd thing to do potentially. I got
(annoying) push-back on using an enum for flags on a series in the past, so
I guess here I am paying it forwards ;)

>
> > Anything that is parameterised by enum uffd_reason that combines flags will
> > break any switch statement in there and yada yada.
> >
> > I wonder if better just as #define's + unsigned long or something?
> >
> > Or you could do (and this leads to nicer stuff later):
> >
> > 	enum uffd_reason {
> > 	     USERFAULT_MISSING_BIT = 0,
> > 	     USERFAULT_MINOR_BIT = 1,
> > 	     USERFAULT_RWP_BIT = 2,
> > 	     USERFAULT_WP_BIT = 3,
> > 	};
> >
> > 	#define USERFAULT_MISSING BIT(USERFAULT_MISSING_BIT)
> > etc.
>
> Looks over-engineered to me tbh, if we drop an enum, I'd just
>
> #define FLAG (1 << SHIFT)
>
> and call it a day.
>
> Also see below about aligning with uABI flags.

See review on 6/6, I'm confused actually why we have several sets of these
flags...

But in general it seems like these flags (in one form or another) are being
repeatedly referenced, so it's not really over-engineering I don't think to
abstract some of that.

Maybe can be in wrappers that make it nicer. But really the issue is the
duplication in modes/reasons/flags...

>
> > > @@ -168,9 +168,9 @@ struct uffd_msg {
> > >
> > >  /* flags for UFFD_EVENT_PAGEFAULT */
> > >  #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
> > > -#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
> > > -#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
> > > -#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is VM_UFFD_RWP */
> > > +#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is uffd-wp */
> > > +#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is uffd-minor */
> > > +#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is uffd-rwp */
> >
> > Is it worth retaining the same bit indexes as the reasons?
> >
> > Reasons:
> >
> > 	Bit number
> > MINOR	0
> > RWP	1
> > WP	2
> >
> > Page fault flags:
> >
> > 	Bit number
> > MINOR	2
> > RWP	3
> > WP	1
>
> If we go this way, than it must be
>
> #define USERFAULT_MINOR UFFD_PAGEFAULT_FLAG_MINOR
>
> so we won't need to keep them in sync explicitly.
>
> With a caveat of USERFAULT_MISSING that is expressed as "no flags in
> uffd_msg" :)

Ugh.

>
> > > @@ -2607,7 +2607,7 @@ static inline void msg_init(struct uffd_msg *msg)
> > >  static inline struct uffd_msg userfault_msg(unsigned long address,
> > >  					    unsigned long real_address,
> > >  					    unsigned int flags,
> > > -					    unsigned long reason,
> > > +					    enum uf_reason reason,
> > >  					    unsigned int features)
> > >  {
> > >  	struct uffd_msg msg;
> > > @@ -2629,11 +2629,11 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
> > >  	 */
> > >  	if (flags & FAULT_FLAG_WRITE)
> > >  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
> > > -	if (reason & VM_UFFD_WP)
> > > +	if (reason & USERFAULT_WP)
> > >  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
> > > -	if (reason & VM_UFFD_RWP)
> > > +	if (reason & USERFAULT_RWP)
> > >  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
> > > -	if (reason & VM_UFFD_MINOR)
> > > +	if (reason & USERFAULT_MINOR)
> > >  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
> >
> > With matching flags and unsigned long you could do
> >
> > 	msg.arg.pagefault.flags |= reason;
> >
> > I think?
>
> Almost:
>
> 	msg.arg.pagefault.flags |= (reason & ~USERFAULT_MISSING);
>
> And define USERFAULT_MISSING as (1 << 0) with a comment why it's fine.
>
> I don't feel strongly about it, but my preference is to define reason flags
> independently of UFFD_PAGEFAULT_FLAGs and keep the ifs here.

And also modes... Again I think fixing that mess somehow is the better way forward.

>
> > > @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
> > >  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
> > >  	 * resolve the fault.
> > >  	 */
> > > -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> > > +	if (!pte_write(ptent) && (reason & USERFAULT_WP))
> >
> > I wonder if you could actually
> >
> > You do this quite a lot and they read a bit horribly with the && and & on the
> > same sight-line. With the changes to the enum proposed above you could do:
> >
> > 	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))
>
> I find && and & perfectly readable and adding _BIT defines looks really
> excessive to me.

Discussed in sub-thread. We'll agree to disagree I suppose.

>
> > > @@ -2835,7 +2835,7 @@ static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
> > >   * fatal_signal_pending()s, and the mmap_lock must be released before
> > >   * returning it.
> > >   */
> > > -vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > > +vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason)
> >
> > Hmm what was the 'reason' here before? The flags? Maybe more reason (no pun
> > intended) to keep the values the same?
>
> The 'reason' before was a VM_UFFD_SOMETHING, we really can't keep the
> values the same, but we surely can keep it unsigned long.

I notice the 'mode' which is not the same as the 'reason' is an unsigned
int in 6/6...

>
> > --
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

