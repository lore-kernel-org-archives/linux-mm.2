Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBFFC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5496B0099; Wed,  9 Sep 2026 12:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD3C6B009B; Wed,  9 Sep 2026 12:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE59C6B009D; Wed,  9 Sep 2026 12:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8F286B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:43:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F166120288
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:43:14 +0000 (UTC)
X-FDA: 85194793908.01.316FE46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C8FAA0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:43:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIPVuofi;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788972192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bb9T4qzNzmlycp9ThZUfYsXOaxsYgWc9M6tavwahvE=;
	b=KxUtjWaTGjOVMKSvpXDnv0tRAK2BBEyS2ay4Czia77KGWq52J1TrQOJEWpdd9brqmIqDYv
	Y7Go1IaB7uAYtGkN3G8wQA8jwwT8zKNQbJbG1Wrxwedsco8aJe73SdjYDfbkCAAW/wFByr
	1BrsY2fHKHpSfx1884/itP9kU+/KI/I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIPVuofi;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788972192;
	b=2S05Yi2iPvnUD709jBpJ+WglZKETgAZpASxYctF+VGRCVTHsqA3hgDlOVT1fsAGrYdlJ2y
	x17SF59MT+1kFON8dxM68TjQU6yOHjoHWR7mJXt5KOoEKfHfR9Ip3fTq+1z/NeG1tLhiq9
	JxAus270zyNhJDY6Rf09naF55Wb7NpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 822CC439C2;
	Wed,  9 Sep 2026 16:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4721F000FF;
	Wed,  9 Sep 2026 16:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788972191;
	bh=+bb9T4qzNzmlycp9ThZUfYsXOaxsYgWc9M6tavwahvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gIPVuofiiuXzwRKr3oimigWerGVK3163gi1cAcgzOdWIHvv7vHRHaOOm70oBmvuof
	 gM+DrCV50r5q2fX37AG+T2Z9/95C3wKDpEICIKuj714cWc9kpK2a643U857hnxKrt6
	 F+VhD/Iigk9dREUeU4ysQJtISisTduJzSnmSk21qc6hooSphBl5H9CJ0/x7dZKu/Q6
	 u+L9ir5TwzY1RhFgoDiNZuSP0ijZXhIOTL8sytWHlzA6zcGHNHpORsIUOjNpgYzeac
	 YkdgjhwiwM1Yl/vDXjEBIxQFkvn0uBOf3YaFLZFvbyOIKYs37Ib6WZ5TYOCA3N7iFE
	 8WN0ksIUU49KQ==
Date: Wed, 9 Sep 2026 17:42:45 +0100
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
Subject: Re: [PATCH v2 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <aqGMefM9TIqUvZrp@gremlin>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
 <20260908-rcu-pagetable-freeing-v2-12-1f60b64e878e@kernel.org>
 <aqEkfKww9XDq15ZF@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqEkfKww9XDq15ZF@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C8FAA0004
X-Stat-Signature: ywg3x787h8g8jez3b4j9ruftgjibyofk
X-Rspam-User: 
X-HE-Tag: 1788972192-635001
X-HE-Meta: U2FsdGVkX18tM0oros+out3yHs7epelIRJMrAIEgdi2jMNnmNozBxmXOdHiRm1f0fmm4DFrMNWYP1U7SNjJFPSQcB2jrh2WHtefe7bFSDIWbvowCNjT/qIscx1VGkmWbppjN5Pt3pbYu/uGJN1u1Bs6Kg5BY1KIGEHIqpAv/0T7EI3Y++lcyan7sdAHXpA+I2DPAk0hyDTR+nNyMTTG2ID6kS+8I4//dhDDtoNMNFIy2Ao3xherTOhYNDhJpQsNhGvGCg/vHKI3kmoWQexL/1ywp4mQcQvAOgn690k9IDCa3R+/xu4TXqCSvr7wpjoSmBID86eTIPybeOk+BUZ+cBPpAZXPsyKnSsQSjrXHEJAorTqOh8jOlNs0v/paE9aqCJyBjMnqMmHJI3yrmz98UUp3uWdvU6JUfIkY45wxYSaZUaulD8gm7BcDjFIfFrd99FVwZHLJFpX82AESLQ6iuNYanJcOXwXDPy5UAk4pKAN5pimWOxbcF73sJocUmCeiX3QC3gMsAv9sKm1Ne1IHIuemnmi2h/Zxncx8BaUy5Md4tZqdNfeFvmYOX76gEpNrdSkWav7NLnA4B17jXqNGHReHR42KL/hmP0eXIqtXFRB2p7IHveLifeXR5Xl1aG3Ra8X9JANc+soL0lLFZW4GqY4wUY4sIZlUN9RF+fmZm8YVmX398ixEVosho4nxOWbQzIBpRnRhGbA8OIVEbmwhzdadhqTqkK5xd647Eh3jJ9FXhOJAAXXIUC3Vm4CziaQIZMIluVfQy5hWfNEJN2eQWDKyf96uUgiMyC4W3xYU7s86J//jTub5BVL1IkzLrZ8cff9Y8DlaM6F/DQkcFnWGGmlCSuRJ9ze0MmPzpsShBnddwIvCk6Yu/HzUBKVDLHXgF0GIP7b/HRQ/XBR5VZtRNOJ92FELAMcJWgmeNbNQNasEEnvDR4NrOwlof132ZtWAn5/b9gBQDWJyNM8mY7di
 rHD2JlrE
 RV1hDaKau7aukq79xrsfW6N8lYW6rJaVgkgMVyr1YoNaOgUW7tgQTUlu7S1LmuWs+BXcMCc6Z89H+dAuILP/4df9PIJb7WzCghWbp0SpB71xO1NxWbh/QwhOic+UloKpgJ5cuzH/KXtnU/zH0CF4xTOlxORfvU9Bum1EfMtA3AHVJnmEAJ3BzJVS9z0jLEnn4g45BXU3efwvpLruYQhZEqLkL4puqpmgIchc9xQlPsIMCoRmTWOzKnLE4OSFETNpuSM2SJdkkAjD8cYMNbiED3yo3iujKjpWlluJ7uALeYUOB/k1wbLbZUG+2n8ssD2Tbb/ygKRC8bWrjS3wgMWxhTZtKJQXkpwDJHtJdMClckbgiHSI1aXtaxsyOR94/WXCE9j1L8DhiRgFYTdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:24:21AM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 08, 2026 at 01:32:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Now that page tables are freed after an RCU grace period, it is safe for
> > read-only page table walkers to walk page table ranges that are being
> > concurrently torn down, provided the mm is kept alive via mmgrab().
> >
> > It is however unsafe for writers to do so, as they must obtain an
> > appropriate lock to do so safely.
> >
> > Update the pte_offset_map_lock()'s comment block to reflect this.
> >
> > Similarly update the process addresses documentation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Documentation/mm/process_addrs.rst |  6 ++++++
> >  mm/pgtable-generic.c               | 15 +++++++++++----
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> > index a7296f251799..1e65b139f355 100644
> > --- a/Documentation/mm/process_addrs.rst
> > +++ b/Documentation/mm/process_addrs.rst
> > @@ -537,6 +537,12 @@ We establish basic locking rules when interacting with page tables:
> >  * When changing a page table entry the page table lock for that page table
> >    **must** be held, except if you can safely assume nobody can access the page
> >    tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
> > +* Page tables may be *walked* under RCU alone, as page tables are freed only
> > +  after an RCU grace period has elapsed. However, any entry found must be
> > +  revalidated after the page table lock is taken (such as the
> > +  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
> > +  before it is acted upon. Changing an entry always requires the page table
> > +  lock.
>
> This says the PTL plus a recheck is enough to act on the entry. It is
> not: free_pte_range() clears the PMD without the PTL, so pmd_same() can
> pass and the table is torn down right after. That is the case we settled
> on for the pte_offset_map_lock() comment, and the two now disagree.
>
> Something like "Changing an entry requires the page table lock and one
> of the locks that excludes teardown (mmap or VMA lock)" would match the
> comment.

Ack will change!

--
Cheers, Lorenzo

