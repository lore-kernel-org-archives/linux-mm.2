Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531C7C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4836B0088; Wed, 23 Sep 2026 05:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EA26B008C; Wed, 23 Sep 2026 05:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126B76B0092; Wed, 23 Sep 2026 05:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE776B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:01:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A178140704
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:01:19 +0000 (UTC)
X-FDA: 85244433078.05.CFF5940
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CFE2420002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:01:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l8tsN/kb";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08CQYKP/CbnBznr138YYtpOglRFSY/4nWR9BP/pvTJE=;
	b=nMpaxX/rOCbD4Q01GHyvGlxGlAAghlAAQdf/a8V2FICS3py/PVvjdKcR5ppqpoyFPlZPbs
	rIPRHg8ENCgnTK27kv6zCiBuwbD74RL+WOd6xHYvFCVAJ2PJyh3i/tvXXbEvoODrGAo1O1
	9zh/A8MSZ1bpvpS5vkEYymiRL5fXPlM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l8tsN/kb";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154077;
	b=EpbllU1bsszWThQ2EOVmlag2txUadOkarZpWKF7sIjBXdKhRo4K00k8PUz/M9Limcs0XcS
	+KSw02sLqrOHXPeOWDpJeZLZRESWB9L4t7SEUroxIWZPllzqule4Ca3/T8VzNOyuQqEWdI
	MrUOt1yOGq7HCNTP7ZzWU9H4LXseDY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20FFC600AA;
	Wed, 23 Sep 2026 09:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E1B1F00898;
	Wed, 23 Sep 2026 09:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154076;
	bh=08CQYKP/CbnBznr138YYtpOglRFSY/4nWR9BP/pvTJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l8tsN/kbVIAp0zwO7NJ8UKHEbsmr8kRgy965DCDazZrwPMWb1HVR3BuMd0/yw0Q2T
	 fxE/bnE5HNOoDu+FbSjEOgtVRrstUJmFtSgXFOJmcSrLoUvYDYQhLMstrxi7qUBn5T
	 jW/J6ZlAxSf+hRCvSl+ViV/fBd9XtyVJbWqkZtHQuxuRtovUqrgnEQZdaQcmsQffJc
	 Aqb76CVo/wBl0PF4wKShO0+ulUmjXKjnymVE8Nrgszj1RpA2CAI+TkOXXWUHXdNh64
	 QpaeRSwcbBD0XGT81/hFdlfZSOkmVdFacBJilbp5yToNPy6KySZKmOJuF0+hD6f4yN
	 QOZ8zpWWYPQ7g==
Date: Wed, 23 Sep 2026 10:00:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
Message-ID: <arOU9k1jEMHHPEtj@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
 <76b2f611-b74c-4d6d-b166-491e1cfcb9a5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76b2f611-b74c-4d6d-b166-491e1cfcb9a5@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFE2420002
X-Stat-Signature: ifrwxr3a6nq46cepn7j3g6yk9xftpkqq
X-Rspam-User: 
X-HE-Tag: 1790154077-281222
X-HE-Meta: U2FsdGVkX19avftOoG2TLV7Bzoqmmiv0VD3lxM644JmuNdf55eoNFetCtkMAuLmybSv3Qw5N7ZDrIHSMfGcpMJYIG9KWZWB48JoY+Ejn9VsRIKAmGqoCQ1jCf6SwGfsg6Yxyfd7uuoedsmnpWYtwRDzBGv07udX19k6rG75fbJrH5MXH2PRIWoOM9c+Ln8JdgK8nIN31nEqudKRinGjF/30FJTZOITQdf/BeMbQOvArcpvaOpsZ96TIwYFetF/bQl2XWNfYr0bJllFiG0LStMPUNXkvlAAaIIjdGBNqmeAeFb79On7qk5Dy3rsSG4LcGWLTUWH4YWADvGX50LHeD4qHsXmbpVzXGlVgaZk8v+w3WW08kkCg+be6st4jPco4vUswPwCEzJg+1gI89WfrCGYbzUxuk3bj0XMN845/sn+wjvTZ4Fak6U/fOMhYme+bJ1sZxrxGMr/IaqKKPiX4B+DkyJzH/LHCJc2tnFk70LUX7yvaITdqkyyA6gJd/EimqZ78SBHb3CA+CROGcvobFC/lS/9jJPxUHdxqNG3yYu2JwTDF3KHo5dAS9C+jQmGck/RJWFeHyLa5OYIEJeM2N9bZsOFZh45ly2pBeSbMUZfu8xNwYLuVldYyAERce0LLLHVcqiHHUMG2VS7XD8Sy+O/6NJ4HUCbOTU4Xbh4uR0xTg6mMCKww7q7TmNsrcGjiH1lSLkgj8tLb3WMLFmgIfp+jFpMD9euamzLQQIFwz3MJx7D8Ein90Qru49TCBTYIO3JOm9nfSEMk+/95PzVrI/0lklc377zp6kSbe37+Xo3YXkhGOD7NPHXoShegVIzYRwPhKCPQnFpcWJ0WFyr7rVmFY44GSsaEptR/JcbEPkjXsTfFA5HxU9Rni/6h1scqLbJTybOaL5K/FECiFrW3rWTMMiZ8HH0eUKlkUPwYDkcklb0cLC24OBsQugywsgvTUwiedvYPV9HNBjBn1Xxp
 p9hV8CFd
 Wm22HaZPCVtdj+2X+TIWY6eYVfRvV3qfqxThjdFJKgqliKpFTHUdBrMSm/pdLozXTFpF7ElldQahABXWJ/1LC5eu4slfrTvT9DFsCdFia8jhjx5vhH9P1exp1mKQFHYzOyFZCC2Wr+qJ9QsRtgHi5yJxlb0Mw1a/3sjhrZERilAdU8RMYJNg0A+IDQUzaT4Jg3xatZvmgW3Sw80JVSbJuMJUX9oQBhPVYgGIh0ixz9YTopskTreuct2ChmJvbKMxXLZtbxYsKjPd2TXcQZxUIRf77hIZG9pnwXGHaOqW0D2UbuEKFVYSEf+uuJbERN3bpE2X7GFUoK0I80qhYPAlx6VZHr5pJBigMIpd6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:54:07AM +0200, David Hildenbrand (Arm) wrote:
> On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
> > collapse_huge_page() deposits a PTE page table on PMD collapse in order
> > that it can be utilised for subsequent split operations, meaning that those
> > operations do not need to perform an allocation (as they are in a context
> > where it might be unwise).
> >
> > However the PTE page table which is deposited is the one which is currently
> > mapped by the PMD entry that is in the process of being collapsed.
> >
> > Once deposited, the PTE page table may be used in a split of any other
> > unrelated PMD entry.
> >
> > This is currently not an issue as this operation is performed with VMA/mmap
> > write lock + anon rmap locks held, so ordinary page table walkers will
> > never accidentally end up walking the wrong thing, and GUP-fast is
> > protected by an IPI via tlb_remove_table_sync_one().
> >
> > However, the series to which this commit belongs implements RCU-safe page
> > table traversal, at which point this becomes problematic.
> >
> > This can be resolved by using pte_offset_map_lock() which gates on a PTE
> > PTL and a pmd_same() check, but lockless walks are unsafe as things stand.
> >
> > Resolve this by simply allocating a new, zeroed, PTE page table to deposit
> > at the point of collapse.
> >
> > This path is already costly and an allocation has already been performed
> > for the huge folio, so this allocation is statistical noise in terms of
> > performance and memory usage at this point.
> >
> > With this PTE page table deposited, RCU-free the existing PTE page table
> > so it is safe for page table walkers to traverse within a grace period.
> >
> > This also brings this deposit case in line with all other page table
> > deposit logic which deposit a fresh page table.
> >
> > Additionally, this was the only place in the kernel that displaced a page
> > table like this, so eliminating it also helps consistency.
>
> ack
>
> >
> > An edge case for deposit exists for powerpc and its hash-based MMU - it
> > stores hash slot data in deposited page tables and zeroes them on withdraw,
> > so a zeroed deposited page table works correctly for it.
>
> I think we would have zeroed out all page table entries either way already right
> now before depositing. See clear_ptes() in
> __collapse_huge_page_copy_succeeded(). So this paragraph might just be dropped.

Yup I know, but it was there just in case people wondered about it.

But sure will drop.

>
> >
> > Since khugepaged runs as a kernel thread, do a little dance in
> > alloc_deposit_pte() to correctly charge the allocation.
> >
> > This is already done for the folio allocation via alloc_charge_folio() but
> > no such wrapper exists for a page table allocation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
> >  1 file changed, 30 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index f49a6710933b..dab421f8233e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> >  	return SCAN_SUCCEED;
> >  }
> >
> > +static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
>
> alloc_deposit_pte_table or alloc_deposit_pgtable
>
> should be clearer.

The inevitable naming nit :)

Yup agreed, I have tried to be consistent in saying 'pte page table' in commit
msg etc. to differentiate an entry so that's fair, will fix up.

>
> > +{
> > +	/*
> > +	 * khugepaged is run from a kernel thread, so need to manually set the
> > +	 * correct memcg so the allocation gets charged correctly.
> > +	 */
> > +	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
> > +	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
> > +	pgtable_t pgtable;
> > +
> > +	pgtable = pte_alloc_one(mm);
> > +> +	set_active_memcg(old_memcg);
>
> I'm no memcg expert but that looks good to me.

Yeah, it mirrors the pattern elsewhere.

>
> > +	mem_cgroup_put(memcg);
> > +	return pgtable;
> > +}
> > +
>
> With the fixup
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

