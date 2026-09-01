Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CEEC624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B0E6B01F3; Tue,  1 Sep 2026 10:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3586B01F9; Tue,  1 Sep 2026 10:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3466B01FB; Tue,  1 Sep 2026 10:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5902E6B01F3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:13:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE29F400FE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:13:10 +0000 (UTC)
X-FDA: 85165385340.04.D001E25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 52A6218000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:13:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojh3C4HD;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIFNccvs+atFhWftoJEJD5wmod58xIW+qFgefX0BOCg=;
	b=zeObTtaE/WY2P8idOe3lh8tSSRtjaK396FjcH3vNtwZUBBx0nWK0QR9CdR8n1vLQ8LyL5c
	X72oTu3wUmnqc4iFJ3NDU+XFDR/7r7y00AXk6l2YCyflEqlhWoAZJ+yKYJgdw0tmXUeJka
	/B4eGOg+Li7qToN1pym+Iq51biqLxNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271989;
	b=nAawXSSMklozRZ+ScmMhxEwQYHAVtkFJ0KfKVvOobtfaxKY8Xc5aduWhMsGo5WgDI16Edw
	5ra9x8X9KnTjoZGM3hDLMuypnH9ZW+2FcmPy0kQjNn8KpYnlV18nl1GAMKqhIERuZjZFvJ
	BqHnNQ784UE6Bku4bDqgXCziU+MkT3g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojh3C4HD;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6350043228;
	Tue,  1 Sep 2026 14:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C071F00A3E;
	Tue,  1 Sep 2026 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271988;
	bh=zIFNccvs+atFhWftoJEJD5wmod58xIW+qFgefX0BOCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ojh3C4HDmqZjOi1pkhDSDGdV7SfRfNfWGZdomRJtqMccy2x0v2yndUbLTlFfoma31
	 dXPCD/3iuiFmrOyTzvDFsi3JMSQci44mXNjMW5aZrX1wksJI6YrjjSO9AmUv57cBYV
	 9z8GlCwH5Lcq8HdHGJ0PhyaJV91X1hhmLlTYoLDJyqV5tpAA3OmuNtzuupyJ9NgXA9
	 UJ1DFYAPUuZI2d/93NYxQqW7uJLFNFyZWGMt5ve018yg00i9qrJwXbMtHXQVNemoe6
	 vmWZlNLESArFUgZ4rroUvf022k6zvA9BUurkwbyrW+S7uSnPMqBoCZlDQJvO6b3uMa
	 s/wAJaE9PbDug==
Date: Tue, 1 Sep 2026 15:12:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apbcoMTVlL42G5tg@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbOlyF77yDCV4cF@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52A6218000D
X-Stat-Signature: hc197ht4a9izyd11tjckofgyk1nkiu3h
X-HE-Tag: 1788271989-231249
X-HE-Meta: U2FsdGVkX1/7UzY1BSY4RyE+egrBiBWZy8ThmUEUjurvP6dlgRtYeMUfO6/urCWDGUy98ZMbswSd/gbdU/5o3z5PIcNxsMm2uVScr4OY4zO3TWciSjyoh+brN+M7elbZagWRWT+YRcQw3qRswJmtHE3ux4DHxj2qZT3f2fML8Y5IUL41CfYwcYnzqRIzDLsesvi0i0miH+nPVcffJW56fLNeNTmXTLiRovHtMeymyNbgkbFWwrHwc14pEKnaIy6/HkLzToiK5ChjoKA56xAlHGOMlzsm+Bb9UQWlp8FnhwaetkytMCdpOYQxbcH3ClUog3qJBLVxG0eLtLYuK32DSbqThqekPeBKPyuKUVYhwafpeOCwPiRbNBv0kEhGE1wvoeEwJqFToy9dl913G8CcSsHQgd1NTESV0Ui93rjNZh75CJ/11uDprErXW3sifxPIxg6ZJlufaIa5KbST3HAUUkJcWGHwKtLCsmYYIDsacNQOY5pwlM3RkiYoRBpQ2M3eHAOEmVPk8bRRe5luBnQUqxAoVVJ0DYkEUyoOj2wY5FflI6xX9feD322IcMbpP37/BbEGX+iEgeJelWY/SEY1bmtpHRy/ga8ccbJijWNcvByVDKIeU5UkQdyvT4HewTvuwek3fbGA8vRU6Xm8tjrC95Bior/Rn2QygxH47WEBuiR1gym426vkmvL9HnhjCw0vmO26MShnfHOXDfzmyqM6ejYRukADTnvLMkSsF5lu6bS4xk/NQLRVoA8gbiqLynvxrfbjD4Ftnnn2VRi7nO2jn2ViMR87xBe8j9MZ/wAdpru0iT533yVuoNf8nNOTUd0yg6tU4kM0BqVKJjuP/0cgd/4vhzEk/wQ9c0Yp6Cyeui+HUyB6vUnVTOBpY3xmu8NdytvXb95u7rkW4jgi8fE1/ADxtQoZeYNrIWyswhUqNf6GvdTu+A6nFuqJk4QzxENLFT0qKfolD9BPzfRPXBn
 35X4ssw4
 QWHo+WLAIIYTWo4ib8skZRgfyvgaGcJSkQuZPcUopGP7xzAY+yz3Gg/KNfwG+l5JxjyxjO/iyijHrEKvgMQG1h2jX4P7OXKgJmhC7d9QVjzp7t5jBxzd5/sYA/P1Q7Hw130TIHlEgz7s6Tc17g7y9Sjqr8U25t1XdbwkLgjmycB8RiGtCid9zX4ruP/1fntP4NX089mUtAjAtqZQqRteDaDbxa5giDw6JWCaSagiMODaxRAmjnEw7F9cRH0+JPMS9WK9rPKasWZJrn7kkFlPOXv+2WksEUMXi0v6GLUNH5E5eK6z9fRu8kJ70RSj1ska2wP0hxDUuWGwSrgsnpcDLhi4UPWqE/6nZ7CBFvq1Apji7SOHWDC1nIi7Vi82IoqHtmLG2i4ontns14SQULJA3ETvRiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:19:36PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 12:01:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > When an anonymous mapping is collapsed for THP, a PTE page table is
> > 'deposited' with the installed PMD entry.
> >
> > This is done in order that a split can be performed without needing to
> > allocate additional memory.
> >
> > The freeing occurs in zap_deposited_table() and is done directly without
> > any delay via pte_free().
> >
> > This is currently not a problem as existing page table walks are protected
> > by the mmap or anon rmap lock.
> >
> > However this becomes problematic in a future where RCU-only page table
> > walkers exist, as there is nothing to prevent a page table walker that
> > started the walk prior to collapse having its PTE table freed underneath
> > it.
> >
> > Commit 13cf577e6b66 ("mm/pgtable: add pte_free_defer() for pgtable as
> > page") already provides us the mechanism by which to solve this -
> > pte_free_defer().
> >
> > Therefore, as a prerequisite to a future commit which will permit fully RCU
> > page table walks, update zap_deposited_table() to use pte_free_defer()
> > rather than pte_free().
> >
> > Note that the IPI sync in collapse_huge_page() is still required to ensure
> > refcount correctness against a GUP-fast operation.
> >
> > This is because GUP-fast might increment refcount, but
> > __collapse_huge_page_isolate() determines whether it is safe to proceed by
> > checking folio_ref_count() against folio_expected_ref_count(), so the two
> > must be mutually excluded.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 54494c3fa983..505f7b62ff28 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2476,7 +2476,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
> >  	pgtable_t pgtable;
> >
> >  	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> > -	pte_free(mm, pgtable);
> > +	pte_free_defer(mm, pgtable);
>
> Hm. So it is call_rcu() on each PMD. It might be costly, especially for
> zap_huge_pmd() path: 512 call_rcu() per-GB of unmapped THPs.
>
> Do we want leverage mmu_gather if caller has it?

I mean, I'm not sure in which respect that'd be costly, 512 is not a big number
to a computer, and repeated call_rcu() invocations should just queue more
operations no?

It won't be costly at the time of the calls obviously as its deferred. Maybe
increase some time spent in softirq but again is 512x that big of a deal?

I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
either really, certainly not without it becoming extremely messy.

But yeah I'd want to see hard data on that before I really believe that's a
problem :)

>
> >  	mm_dec_nr_ptes(mm);
> >  }
> >
> >
> > --
> > 2.55.0
> >
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

