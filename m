Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F31C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC296B00C2; Thu, 16 Jul 2026 10:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6BB96B00C4; Thu, 16 Jul 2026 10:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AC76B00C5; Thu, 16 Jul 2026 10:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463C76B00C2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BB0E80154
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:29:58 +0000 (UTC)
X-FDA: 84994722876.14.49FCA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54E4218000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:29:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzgQwrsv;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784208596;
	b=MqUoBjo7v5t/yyKwJ1CyLXt8sFDW0s4j86b2EfI22oTe1aTqac5wzYGYL3NwuZjk4VfKyI
	7WGn0EEvNlAnZY/Qxup9U+K1mxKX/Kn2xbnyWOuuMYWthuH2jNui5PJWbykFtAWIrds8c/
	1iIkhVHR9ZD0jw5iFvJ6Pvvut/TNl64=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzgQwrsv;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784208596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uli8kho+St3ZUL1DO6L5W7brqtkQjA+CdGhvrx1RaxY=;
	b=4vy4ok4R/+17cTuCLQ3XeTrQDJRkEXHObK+8usvnD1bT9ViyDWeCXleXA+q4nB06LUqKsv
	Wa5DeQv0Oo5MWb6lI7i1k3xIgTndMQuTVty9EqLktKCFrgJP5GtBDvjjiWQJr3Z7vbiTzI
	XA5W2zgpU0GlX6+8hWxX+gDYMcteUxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AA6F41331;
	Thu, 16 Jul 2026 13:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6201F000E9;
	Thu, 16 Jul 2026 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784208595;
	bh=uli8kho+St3ZUL1DO6L5W7brqtkQjA+CdGhvrx1RaxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jzgQwrsv3V/tDXNyLUdumBIOaI+5zsaZdpbH1TEEgiTvTUjS1xpWTti1WSyDULhFc
	 hJ295rAXchnFta6Mg8D7uV7YH5SVfO5a+iueHgHssi0racSeYBmIRBjp7ThZI+FtLr
	 7XPO4AmdVTGji5tve+AryuvbNf6ET1dMOSnuOXByxXUVdBOp/dY0jzjav0Mn/a+oJs
	 l1Ut3b+Q29v+wex5p6/jiaj9QKMDiH/JFPNxSjrNAlUIYNKFWwqvU8uoJ/wIZTuY8x
	 LUH9+cXpct9LlCkOHXR/YtZFDRsD4fQISQOgDLa21EQGtJaZtvhfcOgtUp3MLMNT4P
	 A4cGgcn/WXtkA==
Date: Thu, 16 Jul 2026 14:29:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Toshi Kani <toshi.kani@hpe.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	abarnas@google.com
Subject: Re: [PATCH mm-hotfixes v3 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
Message-ID: <aljb7hoFxL7aUZvG@lucifer>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
 <alemS7vxeRB7NcBO@willie-the-truck>
 <alesCtwXdIqH6bOP@kernel.org>
 <178419641178.59347.17339330762419756196.b4-reply@b4>
 <aljBF-am7dqqG8Gd@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aljBF-am7dqqG8Gd@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54E4218000C
X-Stat-Signature: c81ukkrxggd7abnfg6qwimyko7q1dtc6
X-HE-Tag: 1784208596-660082
X-HE-Meta: U2FsdGVkX18gHddUEL6FKockr5Joz9v//8cAOM97JneYrFK+3fMGLiq0aq6y6SppFAHwy4zLZV19beJfnd3J0YINrjsT3aqHTczvjVHfyTHUX7AzAujzvJ9uwxj4t0yqRZy6HhqrHONNukXT2wut3SMDRQjosX9CCZz59geYITgRbnBJFUPRsBBYp0gHXU6pTdF4OtpJJjAdJUFSibKBQM3Aj5PoHVhU9OMttAQDxETKIKV043nGMeueIchL12CNdrI2eQyrnhQKMpubirgbwI2izG9kzHrUXZFCyJItfZ04aLo4aJYgsrjO3oekE5OxoxIYUEihajOYzd7IgSLnRIMW1SQQiVxahZ1t4Q20djFOY1WHN4BBWcTs82t1v4mvpDaJ3jyus9d7uCbtKwB72nwvhxO18soeK/sNkLgiTPPf69UVn/GAUpARD2Kvuu14EA1Y9qMnu6YRv10egvoamAmqn7drCMZSh5jkTJu9S2uBS0gVZIJnNfV7IWWhQf3dfPWdb6NGsvO1SOovy9oQcX/kpRGeQr7UVjzqTqr5rA4NwatVPf4Y3w8Wll7VOMr9Xn3pUQ5FyJofKY1+mwm7gEEKOFfpr22usxRzIO7LhmFaVXIPwWzKQFU0zJN2GTTLXDqb6EyB2xkxJcfUO22bY6wGLAAKMI1ygRpwgBoxd0VD3w7LpcDxBVWQrF58f9an2JjLwllOyApX0Al5nfA/d+jextlQjtIw1+qUWrFri9366ACZ14E3/I9dnF98Jmv6tchukl7tUi61eYAOogWh5Z3ncBof16K/UxxV/bZPpBDXk16KrQ7/rNDpOMTKU/zw7w+jJmrhBoXWTCa/ntitxsJDAcKx8rrN31NnQOQfdRZ1L+LQsRakl+u1IvkG1MWiVTdOvDWXkVh6g4CIFDfFvWpocOJiyCtOXYmyL1CyLiNLw2+bjton3qMCCYrGtTDIyBctZ9hJxVSaPchiPsG
 mSYpm3hc
 PJ6kXTx9rJVYIAVyz+4+aBiivt4LZLjcHkI2hvoldhm5ATd8UQZ0n5lhUmr5lxQjyrZ3G+n277SDoT3sE5L3qBg0GQxlcUGxr9bA6CkvXgAUReO7Q9t8KAeeSXMJczIcrIzCMjmvRLfKuxhCBty0ZmDaKfEMbI+NnAyXZLnYQllBpVtuoSpGFO20Y5XWNsOvyZRb2Th/NfECz3CGRmnN2EzPEq6zHySZfjgJL6XWBAOEiw4V5or+5cDqu4L7NC18Wxz6fQDAtBPIxWyCPQy7qCga7J+2YiSA2WOS3J/aLLQkfFq1s4lQwxnqmyvGlGqPz9K2IOUDUKdX5e75JxMkOHrKxNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 12:31:35PM +0100, Will Deacon wrote:
> On Thu, Jul 16, 2026 at 11:06:51AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On 2026-07-15 18:49 +0300, Mike Rapoport wrote:
> > > On Wed, Jul 15, 2026 at 04:24:59PM +0100, Will Deacon wrote:
> > > > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > > > index d023a40a1e03..4c4b8244502f 100644
> > > > > --- a/arch/x86/mm/pat/set_memory.c
> > > > > +++ b/arch/x86/mm/pat/set_memory.c
> > > > > @@ -22,6 +22,7 @@
> > > > >  #include <linux/cc_platform.h>
> > > > >  #include <linux/set_memory.h>
> > > > >  #include <linux/memregion.h>
> > > > > +#include <linux/cleanup.h>
> > > > >
> > > > >  #include <asm/e820/api.h>
> > > > >  #include <asm/processor.h>
> > > > > @@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
> > > > >
> > > > >  	flush_tlb_all();
> > > > >
> > > > > -	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > > > -		list_del(&ptdesc->pt_list);
> > > > > -		pagetable_free(ptdesc);
> > > > > +	/*
> > > > > +	 * ptdump might read these page tables, so avoid a use-after-free by
> > > > > +	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
> > > > > +	 * write lock).
> > > > > +	 */
> > > > > +	scoped_guard(mmap_read_lock, &init_mm) {
> > > > > +		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > > > +			list_del(&ptdesc->pt_list);
> > > > > +			pagetable_free(ptdesc);
> > > > > +		}
> > > >
> > > > As I understand it, the argument for taking the read lock is that we're
> > > > operating on a region that we "wholly own" and therefore we can happily
> > > > run concurrently with CPUs walking distinct parts of the page-table.
> > > > However, from what I can tell, the CPA collapse logic will operate on
> > > > regions outside of the address range being manipulated by its caller
> > > > because it rounds up to the PMD size.
> > > >
> > > > As a made-up example, imagine I have a 2MiB aligned region where the
> > > > first 1MiB is read-only and the second 1MiB is in the default r/w state.
> > > > If one CPU calls set_memory_rw() on the first 1MiB while another CPU is
> > > > walking the second 1MiB (via some other API that doesn't take cpa_lock),
> > > > it looks to me like the first CPU can collapse the page-table and free
> > > > the unused pages under the feet of the other CPU. What prevents that
> > > > from happening?
> > >
> > > Nothing, and there's a patch to fix that that synchronizes
> > > cpa_collapse_large_pages() using cpa_lock:
> > >
> > > https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org
>
> Hmm, but that relies on all concurrent walkers taking cpa_lock, no? Surely
> that's not generally the case.
>
> > Thanks Mike!
> >
> > >
> > > This still won't be enough to sync with ptdump though.
> >
> > Yeah, so this patch is still necessary.
> >
> > But that patch conflicts with this one as it holds a spin lock over the page
> > table freeing, which prevents taking an rwsem... :/
> >
> > Anyway I think this one is still fine as it seems there's not a consensus over
> > there as there was discussion about just removing the locking anyway ([0])?
> >
> > So can kick that can down the road and just get these ptdump bugs fixed :)
> >
> > >
> > > > If all concurrent walkers have interrupts disabled, I guess the TLB
> > > > invalidation logic would do it, but it would be good to call this out in
> > > > the commit message because it's not clear to me why the read_lock is
> > > > sufficient for the collapsing case.
> >
> > Yeah, so this patch is _only_ fixing the ptdump case. Any existing bug must be
> > addressed separately.
>
> Up to you folks, but if you took the write lock during collapse wouldn't
> that fix it for all concurrent walkers and we wouldn't need another patch?
>
> I would argue that using the read lock here directly contradicts the
> rationale for why this is safe, because this is an occurence of code
> that operates on a range that it doesn't wholly own. It seems bizarre
> to me to go to the effort of adding locking, but then not adding
> sufficient locking for all concurrent walkers.

Yeah good point, we could avoid the cpa spin lock altogether and guarantee that
we're the only writer by using an mmap write lock instead.

We have to take a write lock in the ptdump reader because of non-VMA ranges for
some architectures + munmap downgrades to a read lock on teardown (having
already removed the VMA ranges hence non-VMA the only ones we are concerned
about).

We take read locks for stabilisation here + in vmap code because that suffices,
but so does a write lock.

I'll post on that thread and do a respin with that then.

>
> Will

Cheers, Lorenzo

