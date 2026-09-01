Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E40C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBEA6B019C; Tue,  1 Sep 2026 09:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3D56B019E; Tue,  1 Sep 2026 09:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9856B019F; Tue,  1 Sep 2026 09:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C176B019C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:20:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A5B81C2113
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:20:04 +0000 (UTC)
X-FDA: 85165251528.16.74FC9EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09B228000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:20:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LztPPiMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4K0ioKV5pbE4Ef4e+GKU9dV30pSsLWe3AR7B9Tx4qSs=;
	b=ckswyCALlJyfw6V0JBKJ6/q7J7ZLtnIZjsf2PZx7f1Rp/MHHdd5egQMrwl7Naop6ZdKASQ
	3VGBddFo0va4KV2uhDRWWg2vrFg57g0qJPWLVpPI4ekcGXF6qbe5cvXIkEgePqaoWmWaik
	zqjUc5zZILldXX8FLl1wjva1rTzJ/gs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LztPPiMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268802;
	b=CvK5Ux2rxtXK2XWFswIKOBjV+9Z2B+mp0Tnhm4M0BziHQApwqDKfaaX4pP6PpU1kTwzsG3
	DsOY3yTuFBHWNLTXkfYibghLr/IboG03H/q2RlM8s6qUUNumoCH0uXLwzJH1MqeXNA99Bb
	i9VY7R6MdSH/JZ5UMpDIgCu6F5/Zxwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37DAF40B91;
	Tue,  1 Sep 2026 13:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531F01F00ACA;
	Tue,  1 Sep 2026 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268801;
	bh=4K0ioKV5pbE4Ef4e+GKU9dV30pSsLWe3AR7B9Tx4qSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LztPPiMV0JqOpNGcM41RcGzmbo2W1gJcf9SI62leim+lngFeaunkaW+2nY2NDVI1m
	 ULsGIJWi3F4NrXyL/AqwzQQiFjHV5Yx1hxefG7V4xPPGDn1pMAwntNN7JIu/Rix+9Z
	 7ZSlk1HEz2LWrV8N9Fu/mC7Kq55lUG/A/Jv+D6SD6i66T2Kyg57qnFA+Duqze1ZSnY
	 YIXrZoxooTwzySNTMwxqPLe5CV6rfaKw3uBfTa9eNKWB0Kt+VtTqKKXruYHd2qsjYA
	 iphxkHzHGvAM6eAxohN/0yj4STTgQskoh0AiVqyhuCVt8DYTqViwQa/mrRPa8fkGUY
	 5UprRaTjqGrKQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2F80A1980077;
	Tue,  1 Sep 2026 09:19:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 01 Sep 2026 09:19:54 -0400
X-ME-Sender: <xms:69CWaij5CIKvTS9JuyLleD9s3d7G5S5Cj7oKCUXn13hGseHouuUSag>
    <xme:69CWalGYd0dc4bcEB3etN9RaYjD7HYzO3v8zVyh93Vx39I_dw7XkZfKP4mbB2pf7a
    yCC0ABYtDzS2RhTTaZ8dfYsqjhrn_rW7zK2cNPqftkFgUuGuUM2EbU>
X-ME-Received: <xmr:69CWakpbzJqHJeJRbHpsk7ongNC4txO1ZIIt3gTXSf5VUVWH2Pd6FvJ1H9I>
X-ME-Proxy-Cause: dmFkZTED3aWKojbGUYTqgDI4X4V0F1d+uDC9XUKSeGM5bAtqyf5WoNCcWI8qt7irq+Ycdg
    bP5uMN9J8wue1zj+h4Z5VdmIt5CyC8BtMot40mK2bNoOWP05XNwub7F63HzCejIFCNIwU/
    RwHR/oPnELuI/pgmRue+HPnpkTdxXI2tXXPwQ2XhlfjvZIyZNXMaGXgwL56LFN8ekEPBpX
    QHxLvpjiYjeppSsNC9jkLgljlvJ1f2Rzug/Wzpp30FOzo3biGRK3SJKG4JlcSiSKZV9ApN
    zrblGjeaDfaFoFocDCMSOSTBkwTuSjYQbyrO3U+OcC3IfSEQwCfo2jZutbaEZD8ORHkhOE
    WPvmJHx9cOwRkRzLLHMzt61/y2dH4FBScykL+eQjNlgsUwsdGo8YayjIDE2cNUryQs77Zd
    37yui7ur2Ub4PTGWPTH9vPA/z72KJMVvxVCmJnutZO95zEQmQXdIrYDwRwD/10g1bSXWZv
    5p+rN+4d/l5/jwP9h6pMcwNHnHfrSrfKBvZnNqJN04rROPvVro5LWQHKMqJWCKH7KIqXhO
    kz5cBC197p3oqrUj3bWQUgF9WsFamkEjWJi6OvK/8e1HSfRwBSOXnE0kOoNrxeox4eX16r
    l1yAPWeATBw9u3K+ZxIBaBaFYwt+eQJwZRgzLVYgXvtgrAI3wFtXeAw7uu+A
X-ME-Proxy: <xmx:69CWajFHifz_SIwkxD4BIVpzvuUpvQr-YiTHagPH4og2FD21YdNJgQ>
    <xmx:69CWaoqTHEsNOtjshNsJ3CUngn2ZISAQFdZ45ashJ5fK9S2FYQS66w>
    <xmx:69CWagU-DnjgEXTEnpw6CxzSrHONzOkLH3mSJLYWP1eBStWX0ICgLw>
    <xmx:69CWaoLp9cwfEDd-J-UDdiyYEdkf-I-D6oSdqcqGEGBYulbHTZ9FeA>
    <xmx:69CWap2dwNlx9UBv3N5Z9oAH2VG7dOj0tP6mz8BbcIQFsrC4b0Y4wIoG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 09:19:37 -0400 (EDT)
Date: Tue, 1 Sep 2026 14:19:36 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, 	Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, 	Usama Arif <usama.arif@linux.dev>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 	Geert Uytterhoeven <geert@linux-m68k.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 	Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 	Yoshinori Sato <ysato@users.sourceforge.jp>,
 Rich Felker <dalias@libc.org>,
 	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, 	Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, 	Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, 	Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, 	Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 	Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 	Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 	Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>,
 Richard Weinberger <richard@nod.at>,
 	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, 	Arnd Bergmann <arnd@arndb.de>,
 Vlastimil Babka <vbabka@kernel.org>, 	Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, 	John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, 	linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, 	linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, 	linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apbOlyF77yDCV4cF@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
X-Stat-Signature: 9mt8xjrmqib89mnombs3uagbyo1rqzbx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09B228000E
X-Rspam-User: 
X-HE-Tag: 1788268801-81849
X-HE-Meta: U2FsdGVkX19cTKZQrgNZ5tbOyEj36/QJPPdLb52LYzMZYUEOCs+Q/BlAjab5kYILSkkfn3VJ7JlDVtKAVhCTyLwTBPRf6pQiv1SRKKWXj1z3p35mFsgz4LYKRxpYARHZn8Bw7mjjTpLJdU5yMw7XhmymZ2OH1rjFbWqvVVg4TNqICDzQFI6ZmzVjJOpKvLsSpjbthlb28zsIPgwCXexgOTpaOLPzdtcM/xFMaMY2UB0VxIGzg2M7rgOSk/jAuft574XYiqc1SsJCVyDHkkMO7wf79YfyiRuztf+Am2FNutCQSdjBBaw8q+Ca5HreoOOWoOfqK+T5Kc3C4q7HrFXjncL+IU25Ect5y8fQVxbrRXMIENRwnO+qjjS5w0r4dhk5Lme4yJsyV7v0SwFIrC4Swkiyk6X11ydToa1A+loKUgXvr1g+ijpU5DlQeumys+wX7QkrsRoumxChHl9f8AHyFn9pxiJwJmk0//PmaLZFnuov4GwGLt9KcZ0tfzszplvShzRcMFUYC6N9RZRHMQMbKAfMVGKeY+uKW5laWZGk2UZbv255GDpPvcIW210uhMpy9nyyzeV73nfBd+lRssOXWYNDZ134Exxiq1Pyj7xnGSMk2IkI4OVX+Ow9NcRmn78gxHm5RoWbwqdOkgHxpHNfg3vdsTts+zDvChyab4YzLxJNyZSxgZzBiwBEl+86L8/uYg5a917ntPvNAZnZ1P7Cqjrq1cmZ1RAKjMRcRWl3fRh9i6mcsJP1KYzWSVvanGyYyqkNUDLbeMdRPUENNmJj4EeJsuOcKZBt0/90HTmEofcgfaf8ED5B4gMab3PZYlYexsv1wsrBPGmVwgqhrUMz8QeGHnxfE84sigNG5UTCGIyFTvUK99KD9ts/LpTNl0DYRns1/9yXyJNRv4/UUN8ufZa8ZdkNnO8LJ8Fc9vFDFX2MKsmEcQTazli3ka45UQGMvv5ZeyOZT9iYCPUd9Tg
 qAK6rTy5
 eoN4Fvhmc/kuoDpLrN/YYxdSB/Vvwj3dWEKcagKn2Oe8bF9uiADVuGX8sb2qugW1WXtuGx94LIXcVnHVMz+7eve86Wb+FMu4WugbanPUNKatMPqFzjeQj51pzmRFWyZXB8ukESbLSii+4Km0NEZEJXafjy9yWQRG9BKsKXkgHHZSPA1EPrLZhIFCCrkBQ8GRAhEi6OIGnw+xEcbgyVmzlRMH6t787s13rGQNXb6QRW3Kx3UnnQyAQ12y0S7dm0QqIwDnkdf+JPI6Pd+HmlmsSbcV7YsCphnSvLZUm80XN2BpR7IA/PycewsTo2aZgVP5bhJwtkhUmDm/Xu0EMn/mddP0pL+cp/smmBFd8PBp4Ep8CG8XaF0YB01QYOSy8iXFGBw5UFdk2jiWimYeG10hETaOW4JrK44j467DrUNGXPi8t3f0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 12:01:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> When an anonymous mapping is collapsed for THP, a PTE page table is
> 'deposited' with the installed PMD entry.
> 
> This is done in order that a split can be performed without needing to
> allocate additional memory.
> 
> The freeing occurs in zap_deposited_table() and is done directly without
> any delay via pte_free().
> 
> This is currently not a problem as existing page table walks are protected
> by the mmap or anon rmap lock.
> 
> However this becomes problematic in a future where RCU-only page table
> walkers exist, as there is nothing to prevent a page table walker that
> started the walk prior to collapse having its PTE table freed underneath
> it.
> 
> Commit 13cf577e6b66 ("mm/pgtable: add pte_free_defer() for pgtable as
> page") already provides us the mechanism by which to solve this -
> pte_free_defer().
> 
> Therefore, as a prerequisite to a future commit which will permit fully RCU
> page table walks, update zap_deposited_table() to use pte_free_defer()
> rather than pte_free().
> 
> Note that the IPI sync in collapse_huge_page() is still required to ensure
> refcount correctness against a GUP-fast operation.
> 
> This is because GUP-fast might increment refcount, but
> __collapse_huge_page_isolate() determines whether it is safe to proceed by
> checking folio_ref_count() against folio_expected_ref_count(), so the two
> must be mutually excluded.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 54494c3fa983..505f7b62ff28 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2476,7 +2476,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>  	pgtable_t pgtable;
>  
>  	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> -	pte_free(mm, pgtable);
> +	pte_free_defer(mm, pgtable);

Hm. So it is call_rcu() on each PMD. It might be costly, especially for
zap_huge_pmd() path: 512 call_rcu() per-GB of unmapped THPs.

Do we want leverage mmu_gather if caller has it?

>  	mm_dec_nr_ptes(mm);
>  }
>  
> 
> -- 
> 2.55.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

