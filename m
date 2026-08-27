Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D221C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD486B0088; Thu, 27 Aug 2026 03:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AECD6B008A; Thu, 27 Aug 2026 03:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DE56B0092; Thu, 27 Aug 2026 03:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10CFE6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:42:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 803AE1A0347
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:42:33 +0000 (UTC)
X-FDA: 85146256986.07.5B8ECCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFBC716000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:42:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IciJiPKu;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816552;
	b=vpfWal8s46E5uOTsYIfvXNaQQCAuFFxcdzRm71sgcRNgTmdCJ9WmU1OJRfbjAHU0rsaVFh
	6NCxXywhFHpja4gHqPcCQbQv6hO9eRAWX4AbWiy7BjI6NbHgzGAA0Y4OgOsAvENhjQK7Oj
	CpFjtAzTz32Dy1HEwtxcr+GKIxZ1Z0A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IciJiPKu;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnnHLjDW6uYuCq4a/mmPBKPVQrHkZ/YBkrjUKtCWwE4=;
	b=YgZGAIJChy9H/mT8nVm1c8kUJFzhWtQB6aJP7JMTRBpZT8XU2av+Fr+vf0c6fcNup+BE1b
	Uq8Td9b9PVoTn8Tz9fHa+vekPBNEt/3CKpqeYETL5AkwByTG6xJ4/jVLFseDHbfCX4MkGA
	Y3fzRsui23Zt2yUagzfDGqjJXaZp11k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70660600D0;
	Thu, 27 Aug 2026 07:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C451F000E9;
	Thu, 27 Aug 2026 07:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787816551;
	bh=XnnHLjDW6uYuCq4a/mmPBKPVQrHkZ/YBkrjUKtCWwE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IciJiPKuO+y+klx0Lo62QcCmDKVTR1bs9q/7Azajl4Vm9oFV488RF2ROEwq1ZA4mJ
	 2bSjH7a1HdQ9+yAmEw4vS2L10H/My09Z2VtsWqNW6XhjgLiSmfzd1nq5UfyToZbBHw
	 u2gUv7ZriSaTaJasLImbj5+Yb9R1U6aZHCw31EQdWFJQOekVgfX4JYDJh7bW1rpnFl
	 KWw1jH3j2zbzFvZG7tKkA6Og/JaVg9DPCdITA7ePQyMombPZ7fzqv/PPa+bsdiqq1r
	 i9bRw/2DcFEQjddEy8H1b2k1dy7mPYsbaPg+RTLAQJ+1MgdfkPElaqcZDOFk50nqXo
	 sN4R0hmMsP3xw==
Date: Thu, 27 Aug 2026 10:42:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <ao_qWEcoaIcm1WhE@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
 <aoxm4jUrmL1eQlCJ@gremlin>
 <ao1waln1lklfk8th@kernel.org>
 <ao2Qk87AKnMKuNvg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao2Qk87AKnMKuNvg@gremlin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFBC716000D
X-Stat-Signature: 56zk9hpnfdcrrt6eae85oz8n3tktfgn4
X-Rspam-User: 
X-HE-Tag: 1787816551-763277
X-HE-Meta: U2FsdGVkX190XUY4p+05v3WHHvsp07oADOxNz+P0DeFt1FxncEil0Pcto6wy9xFEbm8uuMzvc1ifikdtZye7nYlWou4wW18m61OJEQqygCFtofnJnhvtfceG56iN563wWzoNi9b5UsZcxTxg0VekKKggKCZJgj8LitZ0xkI8CEBHkaNwkXIqaD4R3tr1IFNzZfNrvoVH0vZ41328M7DRFbJ0zKlYTwlBM8ZpnSEph2qu/hk+HoxcdRgcnbIdHLdMXO6hoEbLmu3c0wown6Xho1KPWTmiNFY0fRYGN5hDSt58BpLjUJuw6cOenPGuZUJNPfcS3h2nRGnAd7tmeLzuiFM7Ct6/9oXC4nifTueBNjW8VRj7HupQsvKh8npLid1NTH1TY2C8N7cciHRo+NQok+06TiBdIW8/LqxLdsaTKz8ljLbIlMDLTH6IAw8OJt2HOTGpht3wI5EoGqX8gmfH0XinJaIlm+FJtEn/2Wk+k5hX4IV7WpKdz2rEX7Dg7ZzhrTHoFwg3irV1hjDDEMWMR7w8NQMdFW0wn37hoY1d6MCvE+NQBAAP1ZWe3RGtEz64AxPsxAyfOoTkxScgO7t9C41i+KgywGV2i9Rl1LBNY9oeEgheHuT5CQXflrC9ijzmxE2G/kvIC5b20tevUM/W2U9htIY5x4m9HLhiMyN8FgkHVa8ye7euTgP4DE1CsIwHh1aV3TrTw1n9OfXsZOY+jx9FTHwi8+CMNoT/2UqAM4MdbHMpaS2MNyZJENy94yVA0C7GX9/GT8xu+hoxVRMUBXkP6bVXU4rTmQLCjZtkzBMvN4FGv8NBr08s8uXGfcAD/EXUQ3Lbwjw7StgN2oECGd1cFdwbHtRAocvGaFgL5f4aDW35sH/r/1m1eIFxeksV5OAUCWOVZlTJNgNyYs1zrInXZIWsFQDCDwANJLlVM2IZhbvHsVBve+bvZ40mUbUmv508wOP5H2q6cngtRAK
 +z9brNHX
 7EyqvCdqm21kYdxlX489seK/7r7NJV459bpQu/iQbar/9RmQtJGw0U+21ioJYCmcuQW3DGGDE4X6d6H8pxDdh6/cHUkHLpZashzm54XK7dOybhD/+b03gmfTCif9jSTwR4FF6y5QcR6g7GtgdpUBMpkPgu33Gx81w/e+XgeL/4viUarXB4QlBDLI6R0+s4kfPipW+HsxTF6sRnTJeH8G49p9i3tkid+sTICSkIUeJqQr9huZT+Qg7N6KPK+P+dbCR5RsGO4wVk2MqfrassyZqICJ8Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 02:00:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 25, 2026 at 01:37:30PM +0300, Mike Rapoport wrote:
> > On Mon, Aug 24, 2026 at 05:28:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Sun, Aug 23, 2026 at 03:17:42PM +0300, Mike Rapoport (Microsoft) wrote:
> > > > Introduce enum uffd_reason to define reasons for user faults rather than
> > > > overload VM_UFFD_* VMA flags for that.
> > > >
> > > > Using a dedicated enum makes the code clearer and decoupling the fault
> > > > reason from VMA flags clears the way for moving the uffd mode bits out
> > > > of VMA namespace.
> > > >
> > > > No functional change.
> > > >
> > > > Assisted-by: copilot:claude-opus-4.6
> > > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > > ---
> > > >  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
> > > >  include/uapi/linux/userfaultfd.h |  6 +++---
> > > >  mm/huge_memory.c                 |  6 +++---
> > > >  mm/hugetlb.c                     | 10 +++++-----
> > > >  mm/memory.c                      | 10 +++++-----
> > > >  mm/shmem.c                       |  4 ++--
> > > >  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
> > > >  7 files changed, 47 insertions(+), 35 deletions(-)
> > > >
> > > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > > index 45355bdb4ec7..f401623f315d 100644
> > > > --- a/include/linux/userfaultfd_k.h
> > > > +++ b/include/linux/userfaultfd_k.h
> > > > @@ -9,6 +9,18 @@
> > > >  #ifndef _LINUX_USERFAULTFD_K_H
> > > >  #define _LINUX_USERFAULTFD_K_H
> > > >
> > > > +#include <linux/bits.h>
> > > > +
> > > > +/* Fault reason #PF handler passes to handle_userfault() */
> > > > +enum uf_reason {
> > > > +	USERFAULT_MISSING	= BIT(0),
> > > > +	USERFAULT_MINOR		= BIT(1),
> > > > +	USERFAULT_RWP		= BIT(2),
> > > > +	USERFAULT_WP		= BIT(3),
> > > > +};
> > >
> > > Hmm your commit message says uffd_reason, uf_reason makes me think of the
> > > character Ulf from House of the Dragon. But not uffd. So as per David let's
> > > rename it :)
> > >
> > > I'm also not sure if an enum is the right thing for flag values?
> >
> > I'll ask LLM why it chose it :)
> 
> I mean you then introduce the same flags again seemingly with different
> names as #define's in the next patch... having several sets of flags with
> subtly different names seems unwise.

The names are important, the values are not. 

There are two cases that currently use the same VMA_UFFD_* flags:
* the way VMA is registered with uffd, i.e. the 'mode' part
* the type of the user fault that the generic #PF handler passes to
  handle_userfault()

They are related, a fault in a VMA that was registered as MISSING will
never pass MINOR to handle_userfault(), but I think it'll be actually
clearer to separate them semantically, so that when you read a call site of
handle_userfault() it is clear what type of the fault it is and when you
parse userfaultfd code you see what modes user wanted for a VMA.
 
> > > Anything that is parameterised by enum uffd_reason that combines flags will
> > > break any switch statement in there and yada yada.
> > >
> > > I wonder if better just as #define's + unsigned long or something?
> > >
> > > Or you could do (and this leads to nicer stuff later):
> > >
> > > 	enum uffd_reason {
> > > 	     USERFAULT_MISSING_BIT = 0,
> > > 	     USERFAULT_MINOR_BIT = 1,
> > > 	     USERFAULT_RWP_BIT = 2,
> > > 	     USERFAULT_WP_BIT = 3,
> > > 	};
> > >
> > > 	#define USERFAULT_MISSING BIT(USERFAULT_MISSING_BIT)
> > > etc.
> >
> > Looks over-engineered to me tbh, if we drop an enum, I'd just
> >
> > #define FLAG (1 << SHIFT)
> >
> > and call it a day.
> >
> > Also see below about aligning with uABI flags.
> 
> See review on 6/6, I'm confused actually why we have several sets of these
> flags...

I can see that ;-)
 
> But in general it seems like these flags (in one form or another) are being
> repeatedly referenced, so it's not really over-engineering I don't think to
> abstract some of that.

Again, the bit numbers do not matter, they are the same because it's easy
to count from 0. I can make one of those count backwards if it helps :)
 
> Maybe can be in wrappers that make it nicer. But really the issue is the
> duplication in modes/reasons/flags...
> 
> >
> > > > @@ -168,9 +168,9 @@ struct uffd_msg {
> > > >
> > > >  /* flags for UFFD_EVENT_PAGEFAULT */
> > > >  #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
> > > > -#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
> > > > -#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
> > > > -#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is VM_UFFD_RWP */
> > > > +#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is uffd-wp */
> > > > +#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is uffd-minor */
> > > > +#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is uffd-rwp */
> > >
> > > Is it worth retaining the same bit indexes as the reasons?
> > >
> > > Reasons:
> > >
> > > 	Bit number
> > > MINOR	0
> > > RWP	1
> > > WP	2
> > >
> > > Page fault flags:
> > >
> > > 	Bit number
> > > MINOR	2
> > > RWP	3
> > > WP	1
> >
> > If we go this way, than it must be
> >
> > #define USERFAULT_MINOR UFFD_PAGEFAULT_FLAG_MINOR
> >
> > so we won't need to keep them in sync explicitly.
> >
> > With a caveat of USERFAULT_MISSING that is expressed as "no flags in
> > uffd_msg" :)
> 
> Ugh.

Yeah, and the PAGEFAULT_FLAG numbers are set in stone because it's uABI.
 
> > >
> > > With matching flags and unsigned long you could do
> > >
> > > 	msg.arg.pagefault.flags |= reason;
> > >
> > > I think?
> >
> > Almost:
> >
> > 	msg.arg.pagefault.flags |= (reason & ~USERFAULT_MISSING);
> >
> > And define USERFAULT_MISSING as (1 << 0) with a comment why it's fine.
> >
> > I don't feel strongly about it, but my preference is to define reason flags
> > independently of UFFD_PAGEFAULT_FLAGs and keep the ifs here.
> 
> And also modes... Again I think fixing that mess somehow is the better way forward.

Can you elaborate?

> > > > @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
> > > >  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
> > > >  	 * resolve the fault.
> > > >  	 */
> > > > -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> > > > +	if (!pte_write(ptent) && (reason & USERFAULT_WP))
> > >
> > > I wonder if you could actually
> > >
> > > You do this quite a lot and they read a bit horribly with the && and & on the
> > > same sight-line. With the changes to the enum proposed above you could do:
> > >
> > > 	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))
> >
> > I find && and & perfectly readable and adding _BIT defines looks really
> > excessive to me.
> 
> Discussed in sub-thread. We'll agree to disagree I suppose.
 
Yes, we will :)

> > > > @@ -2835,7 +2835,7 @@ static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
> > > >   * fatal_signal_pending()s, and the mmap_lock must be released before
> > > >   * returning it.
> > > >   */
> > > > -vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > > > +vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason)
> > >
> > > Hmm what was the 'reason' here before? The flags? Maybe more reason (no pun
> > > intended) to keep the values the same?
> >
> > The 'reason' before was a VM_UFFD_SOMETHING, we really can't keep the
> > values the same, but we surely can keep it unsigned long.
> 
> I notice the 'mode' which is not the same as the 'reason' is an unsigned
> int in 6/6...

Didn't you suggest to make 'reason' an unsigned int as well?

'mode' in 6/6 is an unsigned int because if it were an enum it'd require
#include <linux/userfaultfd_k.h> in mm_types.h, see the commit message
there.

> --
> Cheers, Lorenzo
> 

-- 
Sincerely yours,
Mike.

