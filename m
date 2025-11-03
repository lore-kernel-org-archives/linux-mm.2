Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0546CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC2E8E0082; Mon,  3 Nov 2025 09:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3B68E005A; Mon,  3 Nov 2025 09:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1106A8E0082; Mon,  3 Nov 2025 09:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F369E8E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:30:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 677FF16013E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:30:19 +0000 (UTC)
X-FDA: 84069530958.25.3996DB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90C074000F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:30:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762180217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kOqyI9S+KGv31QsqnF4bpJn1/yga6iCb83NHjSfOK7w=;
	b=EGTS4ED0yybjggsCbQKngST2/UygDNs8DBMI6TleNqF+NoxlgHzVPXXFGw9JFq1wtuIe3W
	woTQEXydjYRJMl+Md+AcRjb5ildupZs1fw8NyggaoJLGeAnOGisN3mtfdIC2mZ7yBBngNb
	c+NnvQ1ICs3Yam1/H9ObJG/1WrNMFlE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762180217; a=rsa-sha256;
	cv=none;
	b=WvSf3lpiSaXPri6eRiH8C6qSWzEEvei3sLATvlLVQxhRrr8aNxIbftNj4c6cYd6J5s2mvW
	tKOMvmpSUuy5u6L5BBhFfs0+B6umx7z0nBU4TePkF0Y8giGNhE/cRdgp5UBr0L3fRxECRw
	WfLyjCmiFBs92effi8e/9OvPiyKpRgU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5F5560191;
	Mon,  3 Nov 2025 14:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA09CC4CEFD;
	Mon,  3 Nov 2025 14:30:14 +0000 (UTC)
Date: Mon, 3 Nov 2025 14:30:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
Message-ID: <aQi8dA_QpXM8XqrE@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
X-Stat-Signature: symau4ozs3rdhpmrwfepw5sjyhjiioum
X-Rspam-User: 
X-Rspamd-Queue-Id: 90C074000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762180217-238234
X-HE-Meta: U2FsdGVkX1/VYaGg1pDJQgZQp2BQvvUIWQpnsMTB0xgV/1Aiq/N3vP9i5AmRpjo5yiLzutQmKiH1AbHG84P5U58SlU+tYhrIqKpWwPAZI6K21Go1O2aM+UykrEJjhhjG9wjTb/OY8PIeW5F6l69e3fOIW8dnzfijmgP1KCrDblDK9lnFAOxi8uVN3XxF8sOp9ImzHkwZTqM18ZddQ3EmzGmy4qHQ3kiK/0i27wa9Av8bz3uurjodR+/FFH5Cp+N0IuI7WKr+5Vnkkf3LI8aLc1x89Xs2MAbEavZrAYeIOsdjuvfPDQ+c3Lv7vOjE3kgC9GY7hguf/gSdQzF1/2eBI4FONwnwI5eBPvEcrZb16zQgJops9wfDg4TjGyB57Y/I/4NqAZGyRpKxnLiq44OxZDoKWcTUSXaK/4v6XKwY6i081PNwA1++CskaOVoDD3COcFc7cu7mZalrtMreVdYq+J/vlM5H6W9CicqwBNAwv9vNfY1Hr2sbNlwmqWeTQqddYAffamTHtDNVbwbdPgmqVtfwylG9uZjH7bc3yfUTecnXlJmA/K7zY1Difv96RUr5jYOko+OS3G0nUFaSZbuw0qghpfWRgMt4xLd/Sv8mTzT+zZniVxczrpoI8ogAC+OIUMN33ua+w+5rIzgxflYwQjUflPyonEHIgehggZ5rjC/2I4qDZhTtJAgaUqfiuBZ0dGjakvDfzqeBFKGuzEkZaqnkuIyiqdlaHP+LP2I2Ut6TQTA1mTlaNetdPBHC4dDb+U4Zpkb/GdKvpjkY+okRKjGTMjsBlZ2D2tD3HZ1BAEQhu2VAmETNLczGYXViDXGeQhVv0GrcTbhHMWnRkyMY7+tLVBPK1wREoBUYRXOmNAVhntiURr3HdDdY9nJwJ9LjDy3sBE/ymfhBZ4ZkOCh5XfnfmWRP0HRfhpwIVb8YtGEP5jbaagYoE8A27x5bWsQ+RZJrWT9droM5uhFpiJ9
 2fWDTcvh
 AJ1cWPmAazQFeQMc+1GCKvX2tEXQQ/G2YtejVnyY817pPt49zbioMiUCdp+AXDLHrwkZN3DbzIcsOEmqigNXC/8Gj7Gx2whscXmItcsvAU5oWG/3hXTJd9R9ltOKbcoJsFHQjcAK+p2x2moPmqA+DHXfD3ZW8i3gjxetTPcCQC9vwD299I3yZ9wzyIv6hJWzGRUXxk1jfZ/9iq4t0MBfF4+LG7P2XqgDpXPlFwYosel+evsZNx9QQvV7/q8rVPnrzUVvxcOppg0NTtcrSluPc3vT95C5YnrEFk4taBkX7UFOeulvNmcAWHn1LclhmX2HK/Wb9Z6zA9aGl1X0KMSBSDLD9WwekbFKjdIS1A4QjVHhc3pT3wY25CqewI8ljGddugQapbIHvWDcwLqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:32:42PM +0000, Mark Brown wrote:
> On Fri, Oct 31, 2025 at 04:57:50PM +0000, Catalin Marinas wrote:
> 
> > On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
> > user space will need to have its allocation tags initialised. This is
> > normally done in the arm64 set_pte_at() after checking the memory
> > attributes. Such page is also marked with the PG_mte_tagged flag to
> > avoid subsequent clearing. Since this relies on having a struct page,
> > pte_special() mappings are ignored.
> 
> We are seeing breakage in userspace on a range of arm64 platforms which
> bisects to this commit in -next.  We see traces like:
> 
> [   59.746701] Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
> 
> ...
> 
> [   59.819007] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   59.826055] pc : mte_zero_clear_page_tags+0x1c/0x40
> [   59.830980] lr : tag_clear_highpage+0x68/0x118
> 
> ...
> 
> [   59.911874] Call trace:
> [   59.914333]  mte_zero_clear_page_tags+0x1c/0x40 (P)
> [   59.919278]  get_page_from_freelist+0x1a60/0x1c80
> [   59.924042]  __alloc_frozen_pages_noprof+0x178/0xd20
> [   59.929068]  alloc_pages_mpol+0xb4/0x1a4
> [   59.933022]  alloc_frozen_pages_noprof+0x48/0xc0
> [   59.937683]  folio_alloc_noprof+0x14/0x68
> [   59.941718]  mm_get_huge_zero_folio+0xf4/0x30c
> [   59.946200]  do_huge_pmd_anonymous_page+0x278/0x6a0
> [   59.951119]  __handle_mm_fault+0x700/0x1834
> [   59.955332]  handle_mm_fault+0x8c/0x2a0
> [   59.959190]  do_page_fault+0x108/0x75c
> [   59.962964]  do_translation_fault+0x5c/0x6c
> [   59.967181]  do_mem_abort+0x40/0x90

Thanks for the report. I missed the fact that the arch
mte_zero_clear_page_tags() arch code issues MTE instructions
irrespective of whether the hardware supports it. We got away with this
so far since we check the VM_MTE flag and that's only set if the
hardware supports MTE.

> Looking at the codes:
> 
> > -       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
> > +       zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> > +                                ~__GFP_MOVABLE,
> >                         HPAGE_PMD_ORDER);
> 
> This adds an unonditional __GFP_ZEROTAGS - from a quick scan it looks
> like this was previously only enabled by vma_alloc_zeroed_movable_folio()
> when the VMA has VM_MTE, I think we need a similar test here.

We can't do this for the huge zero page since this will be shared by
other vmas and not all would have VM_MTE set. I'll fix it in the arch
code:

-----------8<---------------------------------------------
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d816ff44faff..125dfa6c613b 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 
 void tag_clear_highpage(struct page *page)
 {
+	/*
+	 * Check if MTE is supported and fall back to clear_highpage().
+	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
+	 * post_alloc_hook() will invoke tag_clear_highpage().
+	 */
+	if (!system_supports_mte()) {
+		clear_highpage(page);
+		return;
+	}
+
 	/* Newly allocated page, shouldn't have been tagged yet */
 	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
------------------8<------------------------------------------

Testing now.

-- 
Catalin

