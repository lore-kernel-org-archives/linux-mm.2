Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62613CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844F56B0093; Fri, 22 May 2026 03:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5786B0095; Fri, 22 May 2026 03:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710F16B0096; Fri, 22 May 2026 03:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF376B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:15:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 054AAC2F84
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:15:16 +0000 (UTC)
X-FDA: 84794194632.09.0A5666C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E129D40006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:15:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BhjWQb5h;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779434114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulBbriUb5Qa+s82ZfAnphDICDBrOSk/EMlWPn3QSP7Y=;
	b=L0eEguLaKb+RxT2CtEzEhMJK+H3VWfGfim0UBM8WC58lVVn9qphT4ID598765I3bN4p9qe
	WHHNA86CQ2KjkwVM0KeHZH0qguHJd6NXlErAOd9TfREhuA/nq8ugP9GnPz7QMPeJnQMZrg
	E5Pxypuq8n+30aRUAQjcHihRrm0duME=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BhjWQb5h;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779434114; a=rsa-sha256;
	cv=none;
	b=XgCv7942xJM0Cvy6sq/j9BK9cHpZHPYFp4FokWvlZK8WUVGADMQm4Jufr/4cP8P4ZBiIbB
	36EXivOmc6uzCVvOCeefcMe6w+GvMsI0daMGDUCq38PbsF7MecZc2a766T5EMriwx+vWIz
	2WLc5ZdcBaDrJaczzweqzgEWUiI1AH8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 527B94A92;
	Fri, 22 May 2026 00:15:07 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48AC93F7B4;
	Fri, 22 May 2026 00:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779434112; bh=sxkqiabCo2k72yVa+eyY8IbkpWPy8a6prfz7sHqkQ6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhjWQb5hw/wbqsSAir1eL+5L46+NeXRW3tS40bUfAX7q6JagmMsOkMLU3ep7w6UJF
	 XdrXdzUZ626I7QZdHMplHAwyHaboMYra+7Eh2CIdV5iXzRlIZDvplr4IrfM+Ee7XBl
	 0y8z0sFmeoU/gP6cJGzj2R/6UlEmIAr+7vQ8K5M8=
Date: Fri, 22 May 2026 08:15:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, will@kernel.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ahACfQ6kCfONqz5h@arm.com>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
X-Stat-Signature: rea4h4bjcmn5x3ouqtc45mop6pdsu6mg
X-Rspamd-Queue-Id: E129D40006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779434113-306370
X-HE-Meta: U2FsdGVkX1+WREPDCz35UIJUb2pW3w8FyfNtTz9hRzBJr28lNPeJZFDXV5Xe/NGXj1xj8vtlnGvKMmclVFkZQRvcFqFKJWj0mRU5yd0af2dWpaY11oXDPzvQLasKi/Aebu3qin+stIeNmoc65PiIJkK/RlETn5ci8udGHa56/7DUP1KurfCbHk2u9qqg2/CWGREJihKymjy4Zz/qKu1e7JFfPIXP1GDZNgXa7Ll/G5H1xwvxlSGg8R47bm+M7lekNfFqegqh3l8aB8cxhf9z9eX41AuYnNSu5FLiLvFUPwEl5QTvZpIfkbigb6JwSvrCdWlpnsWdJR6YhpdDvI4odIN4aYCXCzpclENcb+3yiv0ayysJ2UCkYfISl7Yl4SfO+9Wr9yFpMriRDNIjzTg3jKI6QGEUI73YDEI5H81Cc0YvCwOuI/5k3QpZj+rXMaSCKnmUW6sFNJRGvjVZq7p4AH0BMUUnvTAYyTG67nPaGMju+i1zOFixZS0czEoixgNf0QFC7o5V4gTYjXUQYvmMibdy0Du2GNKCO9B3tBtD76bSXofLNfobOLN1B71QZ17FMtx93aR+wYgqO83wv1AQlgtT8gGTFFB8NlTAa/nMzU4d6Je7e72A4FqVRmJBQqoTsQlP4IGnpft89AXOAnhj2zNjR6L511c6g1bTyFWcHnbp7xgdl7eOfysf7zZE+x37iovdjE2fpFgIQt8w4U0PF22mW8nZCdB4AG2wQ2TlmSbUrao+E2nC1j1RHf782kxHZztWYOKPpAr8dO1pQQc3Jx9es/iTSZWHCSbBXYKVrFvjhF1M2NMy9/N0kikEtWVnbFRzy8XjnY236qZWGXZLNwxEM9hAtOsb4k9kJFyvjljHP6GRc4ymqY0X5Wl9kiICl9HmI2Sbte5lZ3lfu0gLvui7WDmHO5dIfdLyIazdy1wGFQyCSUz3y1KYrIlR052LiMs1+lAQug2Bl39SnaX
 a3W54CSj
 +PHnDSVTjjIE+X/ntsGz9dLLrZdOdNml+jkx5uNMp0LHD65kBZJcw85MGriPy3dG9z3MaHHLj86xiB1peU9LFfNXCCQtSYGvi9oCWy6jRXO20s1ZXD9q17tqEpF6LVpBKQV+783Nx+5JvUErsmtag71bcupZgWTNs9P9lrS/CCfZgLwsdfVWxUtm08oz7ztqyMsCT+1Xw/4Gqfn+WadLAu5mu8uVK4x5uWS7K1YcbLlviZcuz/67NvgrNicKq3QIa1JBFsHXnlymal6+kDPRN4iijAOPLkxt+mFT41l8Lgu0aL814W8nXMvICVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 03:31:30PM -0700, Andrew Morton wrote:
> On Thu, 21 May 2026 13:27:30 +1000 Alistair Popple <apopple@nvidia.com> wrote:
> > Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
> > __create_pgd_mapping()") page-table allocation on ARM64 always
> > calls pagetable_{pte,pmd,pud,p4d}_ctor(). This sets the page_type
> > to PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.
> > However the matching pagetable_dtor() calls were never added.
> > 
> > With DEBUG_VM enabled on kernel versions prior to v6.17 without
> > 2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page
> > type") this leads to the following warning when freeing these pages due
> > to page->page_type sharing page->_mapcount:
> > 
> >   BUG: Bad page state in process ... pfn:284fbb
> >   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
> >   flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
> >   page_type: f2(table)
> >   page dumped because: nonzero mapcount
> >   Call trace:
> >    bad_page+0x13c/0x160
> >    __free_frozen_pages+0x6cc/0x860
> >    ___free_pages+0xf4/0x180
> >    free_pages+0x54/0x80
> >    free_hotplug_page_range.part.0+0x58/0x90
> >    free_empty_tables+0x438/0x500
> >    __remove_pgd_mapping.constprop.0+0x60/0xa8
> >    arch_remove_memory+0x48/0x80
> >    try_remove_memory+0x158/0x1d8
> >    offline_and_remove_memory+0x138/0x180
> > 
> > It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS
> > is defined and incorrect NR_PAGETABLE stats. Fix this by calling
> > pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the
> > page to undo the effects of calling pagetable_*_ctor().
> > 
> > Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
> 
> 6.16+, so I assume we want cc:stable here.
> 
> >  arch/arm64/mm/mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 8e1d80a7033e..0c24fe650e95 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >  
> >  static void free_hotplug_pgtable_page(struct page *page)
> >  {
> > +	pagetable_dtor(page_ptdesc(page));
> >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >  }
> 
> I'd of course prefer that arm maintainers handle this.  But
> 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> fix it.

That's fine but Sashiko has some points:

https://sashiko.dev/#/patchset/20260521032730.2104017-1-apopple@nvidia.com

The __remove_pgd_mapping() path is fine but we also have the
vmemmap_free() path where the constructor was never called.

We could pass around a bool dtor argument but I wonder whether we could
just check it's a pgtable page:

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4c8959153ac4..9d42cbddce27 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
+	if (folio_test_pgtable(page_folio(page)))
+		pagetable_dtor(page_ptdesc(page));
+
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 

-- 
Catalin

