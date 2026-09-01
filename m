Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8283BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8551A6B01FB; Tue,  1 Sep 2026 10:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8089A6B0252; Tue,  1 Sep 2026 10:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5786B0253; Tue,  1 Sep 2026 10:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 413B56B01FB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:31:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF54216041D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:31:50 +0000 (UTC)
X-FDA: 85165432380.27.C5DB09B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2CD4F4000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:31:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="My/Zkw7E";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273109;
	b=etsE8aITDypWF20K989K7SwztMD4KT2NYAhDua5TklpM8sSSzGtnAv+CyQ7sKKHQjYuxJz
	qj8HkDD0sHEhn13epXFEek1nvV2ilK50qq9Lf+8EbSWvnZ4biESVl7THjoHviokS6Wlfk/
	+ZswyMg2Dm9srQUROOCaQIkQMbREC7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SM87dKxgHKoTgR6BSYO1fL6Rd9rD874uyPlzcJDnuw=;
	b=S9EEYuCn93owV2Uc5AZodfiM6M1NACe8uvy6r/evuRBeFxYANCHsj4XGMtqTe1e4YKKuF6
	C5Vifsf23YG4Z1PNtordWv87mL1NHcpj5to24tqAlGjwT8z4iHlX7Kz4aOQE0yGG3DbGE+
	Bcrs0BQEOrDzoEoqCwlmcp4fkD0+5CM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="My/Zkw7E";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B07AB60267;
	Tue,  1 Sep 2026 14:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5767E1F000E9;
	Tue,  1 Sep 2026 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273108;
	bh=+SM87dKxgHKoTgR6BSYO1fL6Rd9rD874uyPlzcJDnuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=My/Zkw7EkDQLUSB5jkacAppt65djuYrOjFPJWtAE+uuNKaseNbscCeIJiLFL5tjOF
	 zK/l3KkQ2N9S29hI3UzfgzFa0i3rNCpVRYFstyNcwPJV5mzts5D3rGRQPGBcL2r5sl
	 M4LoV6VJ/3D2KAGExFMGP7y9KIyumhdCGZjgQtts1w0HwS2NaKaLtzngF9+7NuNxTq
	 97Ypv59rrpwA8Xfdjav2hWACORC+/7eWDiEOl7fC+2HguCIpqRQRocLFjIYq8tNPwN
	 1Rl+PvXhytTcmeBeZ03XozFMVE7XZhTphKZmP8mF89keRLxkpfMQ1iGRJldtR0luyc
	 IzD2SuW+PoJHA==
Date: Tue, 1 Sep 2026 15:31:26 +0100
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
Subject: Re: [PATCH 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <apbfzUwBQyxe3P9R@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
 <apbUpMDJglS99_yK@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbUpMDJglS99_yK@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CD4F4000A
X-Stat-Signature: pcbj36tpgn4u4q3mrzu7hwrcj8xbyrrt
X-HE-Tag: 1788273109-426860
X-HE-Meta: U2FsdGVkX19x4CW6I4vHuAQHCNzBnD5EHMzvfiBi0d3Ye1ia1WGSyxJObXhZ2lIjDg7qTmAkf6JihPhRaUsRF0Y+x5jE5O3oYKu+XqUjjgWBhxaF85m/D9oV74CrNDqmDJ55IUJO6EL4ZAcZ/tvs/9aLYPp13fvFC9bNJD4QWaRr6kZOJ58FoIsSggcimC5odELok+nZuEpgWsAmWzI3P2noAvF6u8aeXr1aaV7nFPTXelmP9SwEKlC3jmY5FpvLxs1TkHp6jS4IJP2WIPm001/L7pvCmGKz48e29CNJzUMLXZlh91+DyqtIvaUqTehYVWdmpuQZGmaaWW0tOthjzIPM/oUMez/F7A57p3C+EyeOhOg1mGAIEVU1eLyoAMgl1/fYxyMq/9tfBEEZ/N99ftBjl7tDGREAkFc8GUXPQp7+5Exp6u+79/HNOPE5XHcwBNuA7LgFJ+wXEEyFxNFlq+IdgP0bKviEMTa4mell9IJZuCEdOgabWiIsNm0R9c4RWvAhYw5pIdfETnwgU3Lt73p24L2FeiUVaMa8jm+h5I1Cg8t0EBKSCeTnI2sZs96k54DL4iXv4GxWxIg5oaEx8+ng05a3A+2hHmyRH+7vbIPNWS6UNfIwGAv27z/L+S60mCOuwWLCJVTmOtVen95kkuPaQR6Ibz3Rt6eM0Z4kpOuKMtadqzxRaf3duSCIwup30wd0jigaXCDwbuod3urZie1TVnty+yBqJnOtY3YPSPpyNctiBmTNZ8ANE5pMUSnmK4cyhOoSQNtGl4arxy1Rv7nLAWMEfDt/aPCI7Y7MKV7x5IkuGYO8uMJpBpqBDMD5kHDtc3nxDxhgdABgIFioTIVTmcZb00+KhTXnX57spwD4N54dO81mURyxSijNfVQMP7zz/odVpquPszvDatUII+zMHs9911C30+6Bx5gVvxDNYXsHzs9ZvxE330W0C86axlpmtLvnqWaNbeQcP81
 TzsVtMwm
 szKT2WasxzWlelDPOTPmRlP8PZUyVouCSMn4UvaubDuKAe4o7df5HZo+hriW1BuqFJgfUUzk/cvTW33jVRcYQhAaOJlCedJWvWPqf2WlhdD5umvgVZZVXkOMeVso58pE6+DdW1nJUliR6lVQhR3llGFGVhcrUxYhCByRrATcAuoD9/9vA05HrZFGtL/G6yKWxIpik1aJhYjNrK0+sn3zeZVUY2XIxwNxAMLHEW6VTBxLbm8QE39lLjz5OK8S1UJiGyd2lT8v2Uo1i0DWz9LINaNX0EhDUCXg5vDtH1rrDOCd6+a4bbjwBUqZP4Z+ltltO1ajZe/37CN9YtHm0t+x0W5vgUwD5HquR/OA1XX7wp4xAmcCtBDIUT2g+6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:57:13PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 12:01:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > index b91b1a98029c..ff8ff3706485 100644
> > --- a/mm/pgtable-generic.c
> > +++ b/mm/pgtable-generic.c
> > @@ -386,9 +386,21 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
> >   * be read-only/read-write protected.
> >   *
> >   * Note that free_pgtables(), used after unmapping detached vmas, or when
> > - * exiting the whole mm, does not take page table lock before freeing a page
> > - * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
> > - * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
> > + * exiting the whole mm, does not take the page table lock before freeing a
> > + * table.
> > + *
> > + * However, the PMD entry is cleared first, and the table freed only after
> > + * an RCU grace period, so a walker that mapped the table under
> > + * rcu_read_lock() stays safe, and the pmd_same() recheck in
> > + * pte_offset_map_lock() detects the teardown.
> > + *
> > + * Therefore it is safe for "outsiders" like khugepaged to use
> > + * pte_offset_map() and co. for VMAs that might be undergoing page table
> > + * teardown.
>
> Is it strictly true?
>
> free_pte_range() clears the pmd without taking the PTL, so the
> pmd_same() recheck in pte_offset_map_lock() can pass and the pmd gets
> cleared right after.
>
> Readers are fine -- __pte_offset_map() holds rcu_read_lock() until
> pte_unmap(), so the table cannot go away.
>
> khugepaged is an odd example here. collapse_pte_mapped_thp() and
> retract_page_tables() don't rely on this recheck -- they take pmd_lock()
> plus the ptl and do their own pmd_same() under both.
>
> Can we say walks are safe and leave the write rule where it is?

Hmm yeah, ah page tables, what a rabbit hole of horror :)

I guess this is effectively a reflection of the 'write lock on write, RCU load
on read' pattern in RCU itself generally.

So, maybe something like:

 * Note that free_pgtables(), used after unampping detached vmas, or when
 * exiting the whoel mm, does not take a page table lock before freeing a page
 * table.
 *
 * As page table freeing itself is RCU-safe, page table readers can safely run
 * concurrently with page table teardown. However, writers cannot, as without
 * a lock nothing prevents concurrent teardown.
 */

Instead? What do you think?

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

