Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C03C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EC16B0095; Tue,  1 Sep 2026 13:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67726B0099; Tue,  1 Sep 2026 13:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DF06B009B; Tue,  1 Sep 2026 13:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968106B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F932C04B8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:25:46 +0000 (UTC)
X-FDA: 85165870692.28.BC6A9F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95D2314000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:25:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yi2t1tkD;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788283544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU/XHZsQrPB/KjzCrGwIunh3KbYqDQIpxjG/zB2SrYU=;
	b=ljDdA13gtquzoML39F1tGHHnQNextDf4wq+UWAl+N7oYGzZIY6ZpfQDq0eYOWYWLtceUGd
	3qGPytTPasO8cy3A0JvgwruaDDVKyD7pkKli40JSZ3sRxc7HNB09lt/dzKszSj0qp4qvH+
	KB82bWXfmnO23j4iYm5rmDraehUxiRY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788283544;
	b=yd2NBpgfRAAES3zR8hNfrQljgUnw2cOQP4pU9pDYReL1mZwjUkmlZS8+VviMFpDtqy8xOg
	dGcRj8PoIG4mj2i63yrbbWFrZAulwKBWj0SgYKfGAOvHB08gQBPbtWUZ1IgsiZPcQ5Mqpx
	n4ETRD+ZSygekH49kSjMk0Y7xmK/hX8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yi2t1tkD;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F5C86020D;
	Tue,  1 Sep 2026 17:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F38E1F000E9;
	Tue,  1 Sep 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788283543;
	bh=RU/XHZsQrPB/KjzCrGwIunh3KbYqDQIpxjG/zB2SrYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yi2t1tkD7CbVI2GlNVLMPxmx2y6uQ0N17KQVN6tfdVVmsc8e3U70HKz60pHNwlQs3
	 1uaubu11GEhlMNqEwwCAnmGwy18sQmPBDQlkl4HFerFnkf9qqSXhXZRQB4AbUCIy65
	 +F5eg8cH3mV8+ZyrzWtQ7QlVH0tfsCC88xh+SXAYBAqn1Leh14VC/K7s9GATAG+x4E
	 KI4pAxyEdR503wQD7kpPC4DxKOGSs/zzQQ249JbOJTrJb8Tg6ICIFvJvGHbD91pyny
	 gkZbMWCaIAhY75HIF/43FdM8kRnN6lg6QLV7LnJhpcpnHrbOS/0Iht1oAeMIckn9b0
	 Sr0NCrNgxEH6Q==
Date: Tue, 1 Sep 2026 18:25:26 +0100
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
Message-ID: <apcJhtvnd45EkjJI@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
 <apbUpMDJglS99_yK@thinkstation>
 <apbfzUwBQyxe3P9R@gremlin>
 <apcH74QsR5I-DIbL@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcH74QsR5I-DIbL@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95D2314000A
X-Stat-Signature: bs1bqs7qmafnnzxafkj5s6zkrad69htg
X-HE-Tag: 1788283544-303694
X-HE-Meta: U2FsdGVkX189wio4ZB3g8+eMlm5hJWgI7h4ma/mv8pP9hpKfWFg01jYmdiFedYLn07RG1IIE9hJE0Pqt7tKy8wMkMe5v+k/Po8hYZ17BTKm60ae34L2oOglETjwiuHljdqpq353tQ+rTGibDKv259KpgniTSolD9Sr7rQDm01aOCQKJic2iQeexXXKKai1Z4siJeS7x6bczqAvlpn7oZVsggGFbef8EGb6eGC6Nb/cjKETzO8vH9/Y+RdH28VO3iZtpaqLdtiM9q5F6Nhzsk8Bz9sfVPW/92qeRo3PqK7rq8q43xe6TtXf3tnlUqn6C0qwBiY+eqQVgbU+lGr/ux6FcPM0GeakY9By3GrsW99X5T69MyS2ma8XBMk5fXZqzADRATkZuNFi7Y1Svm+dhWMT85XxP0Jvj7ypj4dUc6XSOcX1yl3fIHJqti7adsbDS+b+2zp4hO9ODxlU9WCvsEU0VAC8QhMniwsZ1pD2w0VtUbSUHcKO4pbjenEVTEV7fYIQCjUkjXFrT5OSReU0R47Thwsvy2kEGdvCdF9H1ddInr640ajYBpAwKBZ3RMXIQvF6OSGSFmxO4bMHuweVsfJYaVzYfgaPtQIyoCrBrIqITPZ4nutTHRFattnwxg8oAou1IphBVABkI8XzlHx1uC9AWf81ER/H8bg6w2ujGFqm4Lx0YSekKxytdvZk0FrsKjBTaUGJe/bckxACVromHG1pKKSnoMm3qc4S89BXs1mrw0TAgDboDa09Ais4k6wub4nU0a83ScogrhtQ5EQqJqLALrtGbciouSTFMwvFZbG2+83FJLOGlUIX7p41vAKYZmt6RbzvjEGiIJfcs8SNoWv1xor5/N6DGBgyw4gsWxJQuI3arWX7gIy7kDO5M882z7cSfLCeDPDqvuquibJiEFsx19y30dn5BkzSgVM2caTu5lGEg2EkziMHNOAeUMpI+tVqjvQ4HjSBOQHtQMKmQ
 FDpuWnxM
 nSSm7EcrjoOOIPZKLyFpV6qnjIdrHGefebBxjF+8+VVBywbWPeMCs2JH6GTF7TYrVKoekUBI2kNOAkk4U6K26zXobQsBx1hNZvlnI3/g6sN4azSERM3s11OdHRZUT5ACEbSjR+by9yXt0D/DDvHmzNCcpzzWwEmOrt83+n1kxfGBXN8P6So4rIZyYwWeChgbyNba3+MeAzMtsfRh41fRnTe8q00wemK7olPCStIX69zCdojokqN8h2wwsuXWefYbZv2ue0i45gfmuG0000iXrpqPLpkbMZmreJn7zkpL/qqE2RERmghBqZ03u9VOiDuhv2ORdc8ZU+kUTb4LAce+2MhKXCJNPJ7IBI/ZPeQPOnB5f+bcn52DWZ9YEoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 06:15:17PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 03:31:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 01, 2026 at 02:57:13PM +0100, Kiryl Shutsemau wrote:
> > > On Tue, Sep 01, 2026 at 12:01:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > > > index b91b1a98029c..ff8ff3706485 100644
> > > > --- a/mm/pgtable-generic.c
> > > > +++ b/mm/pgtable-generic.c
> > > > @@ -386,9 +386,21 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
> > > >   * be read-only/read-write protected.
> > > >   *
> > > >   * Note that free_pgtables(), used after unmapping detached vmas, or when
> > > > - * exiting the whole mm, does not take page table lock before freeing a page
> > > > - * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
> > > > - * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
> > > > + * exiting the whole mm, does not take the page table lock before freeing a
> > > > + * table.
> > > > + *
> > > > + * However, the PMD entry is cleared first, and the table freed only after
> > > > + * an RCU grace period, so a walker that mapped the table under
> > > > + * rcu_read_lock() stays safe, and the pmd_same() recheck in
> > > > + * pte_offset_map_lock() detects the teardown.
> > > > + *
> > > > + * Therefore it is safe for "outsiders" like khugepaged to use
> > > > + * pte_offset_map() and co. for VMAs that might be undergoing page table
> > > > + * teardown.
> > >
> > > Is it strictly true?
> > >
> > > free_pte_range() clears the pmd without taking the PTL, so the
> > > pmd_same() recheck in pte_offset_map_lock() can pass and the pmd gets
> > > cleared right after.
> > >
> > > Readers are fine -- __pte_offset_map() holds rcu_read_lock() until
> > > pte_unmap(), so the table cannot go away.
> > >
> > > khugepaged is an odd example here. collapse_pte_mapped_thp() and
> > > retract_page_tables() don't rely on this recheck -- they take pmd_lock()
> > > plus the ptl and do their own pmd_same() under both.
> > >
> > > Can we say walks are safe and leave the write rule where it is?
> >
> > Hmm yeah, ah page tables, what a rabbit hole of horror :)
> >
> > I guess this is effectively a reflection of the 'write lock on write, RCU load
> > on read' pattern in RCU itself generally.
> >
> > So, maybe something like:
> >
> >  * Note that free_pgtables(), used after unampping detached vmas, or when
> >  * exiting the whoel mm, does not take a page table lock before freeing a page
> >  * table.
> >  *
> >  * As page table freeing itself is RCU-safe, page table readers can safely run
> >  * concurrently with page table teardown. However, writers cannot, as without
> >  * a lock nothing prevents concurrent teardown.
> >  */
> >
> > Instead? What do you think?
>
> s/whoel/whole/

Haha yup the inevitable typo...

>
> Otherwise, LGTM.

Thanks! :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

