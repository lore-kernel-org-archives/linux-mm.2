Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9D1C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 05:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B793C6B0088; Tue, 15 Sep 2026 01:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A356B008C; Tue, 15 Sep 2026 01:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F646B0092; Tue, 15 Sep 2026 01:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDE16B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:20:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D04EA4B08
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:20:00 +0000 (UTC)
X-FDA: 85214844960.22.3904D4B
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 377B040006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:19:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QGEiFFTo;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789449598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEsdiGwvz+hN4Uya5W3W3ek2drBfy1jE28a344uCWRE=;
	b=UG9oqevlJpdT8fTObGS0q8F6WTFyU6YHq+hwBTLxJIOUSA3BN4l/L9h2zWWqrLBR07Mqkc
	OGAMJE8geYb0cvVBBTaxng+EShQ6t9IEww83gzjraSv311SXiaPOYolO0nU7Wei7Plm/FA
	PndE8lEu6de4N9WWGfQ2m3DawdmkCtM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QGEiFFTo;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789449598;
	b=eMc3HEjGn3mXHKFD4yerH5EdpwjyxrvSiG4cvnHFypCImnIZwZX5PKJCHUNQAhTgXEf6i+
	aYSoNrJH9Q3B3P6sQLit6QfjBTc7Lmxw/bvPs02D6u5h4LrbCyLcP+Iyr9NFpmfkagvKI8
	ov+7Xz4bZwUcYOVmPdV/boE2RMUsbYI=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93a0bf264a4so253395685a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789449597; x=1790054397; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lEsdiGwvz+hN4Uya5W3W3ek2drBfy1jE28a344uCWRE=;
        b=QGEiFFToL5nbjw6O3GuSqMsfjrbIvhXgj4dTH8nhNPJs1lVjZkYtFfdoSv0vIEgiQD
         zOSUT/z2GYT4eGjYsB+lTlNl/8fF8S9Qn9j3Jt33bnLlMyPIYM4EzBWCT1Yyq4yN9bvp
         lkqnbG/yNs98mjw5zHtups3WMhPCEPcvt/AZrhrtZjEO1k5fRm4HRWBxKekM2GgPk/M5
         D+DERE3d50DxUHewqjtfwJ1cDGw6VGkUclrCbVi8qDSFK4JjOrRhgy6NwnH/FZNDUpxo
         ANEdYyPfwFpZpadcayMuKdPuOrRBh1qPo2ukpqsdl4ZEkZvpowGk13/ECrKD1oMg46n2
         SxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789449597; x=1790054397;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lEsdiGwvz+hN4Uya5W3W3ek2drBfy1jE28a344uCWRE=;
        b=K8iK0PtySGQ7jbjzYFFUHvO7guYBGmvzubljMa4foOp1llbFTOQ7fnlGjWLy2HO1iC
         Y/aAE1WupHX+bYZ6wn5pkvbdMtSAiqnoI/gSyKKiVDG81DUWeXfjYptVEzQlDCTh2rYn
         ss8y8ZI6tIDLZDskDEDy/PjuXoLtomm6x2LHH5090I4vWeUUsYmBR7PdeQ7EMdbdMIFa
         XwkZWKrcXa9YB5yPObhr3Ax38Wmv3eE2IIutL54oYoH7y+QW44xMbelLj3iEXfwsbQ1n
         c4bAyoLjzMOGd827Zytd2qShj6+D6EWD3oY2sF8ajVoKQa5Vb6KcuYmPYhZZ8nw5AxbW
         Gl7w==
X-Gm-Message-State: AFuF++kR3sB9ffiAd/WuJfM4bzHCdBcvqC7xRVqcyjbslf6vqi0MyCem
	O1rp2Rg59dmlak/CG1/lYJKTGhcfYZCcR53B3d6deC1tbGhq71ZwDFd/sHb8aJIzC1w=
X-Gm-Gg: AYBFou1T3RHCYuNKzRg8i/k0f88cJwDiVNiOqAuqfx4l9d6tIOZQTrtXqd+cPUtQAb0
	n30RZZZKVJY+uWGpLWf9wXoenq3NF0odY/VS55mQK7gdywIqEvadUIq5AOqLrTkqHcYXgIGsf2R
	pijDFWbLe+Xtyyw9iHjqbM7g/D3jaZtPucgxBo0OAqTS4pHnBGLaY30hzodvyKq3g5EtWX5c8hG
	RRvohTUknaoJQ1HDTyb/t2nEUOlhLuWRQ1Mizk2xIVSb4fKGb2rldKpirWcM3zg16aQ2oK5PWmY
	Iu6y11Mt+rUqGloPee2hG7OAPMqal2VMGfWuvj24Ru+P+IoxdKYkwCSZgFjdQcUfbp9cf5c+Nm4
	y4luK+HEublQX664VgmmIAFpzYhYHLAtKUBRvlM2cwYnpHmIb1taXRdMdoHBEDxnKkmv8wm00tp
	3yJAkqPWzrlGjmm2XaQYCYvUt4f/ESMBsqHu1qC0WRaQbGbAB3MEDb+WgLfbpwXnn+Cs05Hgbu0
	PfLGDx2YfliNNRxlJibeZX4RxdU4R4Rf3NcnnuJQo7+KrR5QPH23CM=
X-Received: by 2002:a05:620a:45a9:b0:936:576e:227b with SMTP id af79cd13be357-93a29939976mr829769385a.24.1789449592537;
        Mon, 14 Sep 2026 22:19:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e811b572sm1191802485a.47.2026.09.14.22.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 22:19:52 -0700 (PDT)
Date: Tue, 15 Sep 2026 01:19:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, peterx@redhat.com, 
	jgg@ziepe.ca, david@kernel.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] proc/task_mmu: handle special PMDs in clear_refs and
 pagemap
Message-ID: <aqjS0xWes7fhhI9A@gourry-fedora-PF4VCD3F>
References: <20260912122822.3348978-1-gourry@gourry.net>
 <20260914214910.a22cfcdc250bfbb6b14edaf8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914214910.a22cfcdc250bfbb6b14edaf8@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 377B040006
X-Stat-Signature: 1iemwchb85769szhj6yossigc51yibza
X-Rspam-User: 
X-HE-Tag: 1789449598-292694
X-HE-Meta: U2FsdGVkX1/7JtizNCvCuYTeNnvItxsArOgkALIalXWC2fxyBqXswwFR+9W7PvLvViYo/xE90Q3Z3w8zF1noJ6KNnnsgG7jUzEbfpFPr3GI6apIxG9b6OLD5iEkO88zvIu4xTPYEjeILtGBNa/hv5U85GUo6JmhvsJ596AaFLaqhlFaYZABjc0H/Xu7Zt1gx1f/k85Wkd1C6oq+btqfBMpscEcnprrKa7oWpvr7+enrqJehl8Xl2+jIknT+HvyUgNpj3tkxBaRS1LSY0eH5pYSPiNIw+IBUrsIKriBolfkFm42L3D1Dv5n0lpAi89lVvk+ieIta+XbEsbaD5e+ytlsM/Pr7V7ki7ZY7MLQBV4NgDETvZqIuDP1A/55IqEKTiM87ShU3A/1UoMLuKJmpKwG6NMGM1z6fyvkzLWAj2dcgYBMQ5CXm+dNpJvbSySNRqGD92QerVL523Cc5KYFk6Iut5CIDGs2CJE9mNSgTX1IXtzZOkN3/EPSjD4sxGlefpuNaC/aUkQUhtG9iaCoLsOPX4QvPbX5jqBw7XFFVen+NTBje7jN4hU/FWayd/Xv0q9e1miOLPSLz7WOtwajSUM6Zka6P89JRY6WP+2gKFwZA6gG16uAU5ouW00zU183FdvUk0I/k7KjD8NUjJXFKJECNmcquBgmiO6i5I1KPHKLlsXuf/4E7GwQaJvCGO0w4jQLOg8uQn0lBC/WLDjah+nDeqE4ErA1uHbo0JagR1/scrnwMotOC+WIkWT6yhBQl5Xv8ZhqeA+z+QiSowWniL/vDR/Fwr7jswtU5GNso6lFlaEaatcCaD08sjv/dfoFSzBGF2RG/v5L0q78rxNPcsaqY+vVxZ3X5epLg/YNAjrtbK1Dl9cDvEop36q54LXlLl22LdS3rECx+HuYgqTFGMoaPZlRnm+YhILZLqTJmSzw8yGIkp+iEpJl94qSuZrUJkakwDI5R7XpTgKR65xTL
 1+KVpfYu
 2zUGlZ6T0PHn0Trnmdj9UyjztKkpksGtpoWN3elpqnMq9EFFNW4tdsRAtzK0AicQLi9te0a2+ksMz48zN96YQ2j0jethyEhlDlCW79eca6eCJUiNCQ3rHEUvVrqtvayImnjuAd1n+lE5mzQH94kxbq6tcroF386H4k9CSM9BlXUVgVcjNpbSV+DH/S4Hb+E/uR49QBUyCn55rOh9r5bhLTPziDdnGAedJ9reFCvYqM7ewYrpr4DWiI4POmbLM2OqKCksmw3tdbWLorB98ttM8nGxem+2C93Ca3BCYrBQ42Wssd4V7H8qpqjfBVh4U/VfoNEh7ZcFBFUXZrW4aFEZH/bDTI0kq7fDHWtRVp8kjIs5fzhaFKmEvk946vvQXra/9O2E0jrUrWq4FIhun/0/iIHgnjeV9YfpmQvjoyQPCqWZOS8GnAFywNJTX9+fgJavpqrwpKf2ZEpvI7vA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 09:49:10PM -0700, Andrew Morton wrote:
> On Sat, 12 Sep 2026 08:28:22 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > mshv_vtl_low can install a special PMD from a PFN supplied in the mmap file
> > offset.  That PFN need not have a memmap entry.  Reading /proc/PID/pagemap
> > or writing /proc/PID/clear_refs for such a mapping oopses the kernel.
> > 
> > With a test driver mapping the PFN at the 1 TiB mark:
> > 
> >   echo 1 > /proc/self/clear_refs
> > 
> >   BUG: unable to handle page fault for address: fffffb5b80000008
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   RIP: 0010:clear_refs_pte_range+0xb1/0x1e0
> >   Call Trace:
> >    walk_pgd_range+0x50a/0xad0
> >    __walk_page_range+0x6a/0x1d0
> >    walk_page_range_mm_unsafe+0x193/0x230
> >    clear_refs_write+0x18e/0x3f0
> > 
> >   pread(pagemap_fd, buf, 512 * 8, addr / PAGE_SIZE * 8)
> > 
> >   BUG: unable to handle page fault for address: fffff57840000008
> >   RIP: 0010:pagemap_pmd_range+0x3cf/0x6b0
> >   Call Trace:
> >    walk_pgd_range+0x50a/0xad0
> >    __walk_page_range+0x6a/0x1d0
> >    walk_page_range_mm_unsafe+0x193/0x230
> >    pagemap_read+0x1dc/0x350
> > 
> > clear_refs_pte_range() passes the PMD to pmd_folio(), while
> > pagemap_pmd_range_thp() uses pmd_page() followed by page_folio().
> > 
> > Both paths assume the PFN has a struct page and dereference bad address.
> > 
> > Use vm_normal_folio_pmd() and vm_normal_page_pmd() so clear_refs skips
> > folio operations and pagemap skips folio-derived flags for special PMDs.
> > This matches the PTE paths, which already use vm_normal_folio() and
> > vm_normal_page().
> > 
> > Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> > Cc: <stable@vger.kernel.org> # v6.19+
> 
> Why cc:stable?  Is a crafted test driver the only way of hitting this?
> 

Technically reachable via mshv_vtl_low, so i tagged it stable.

It's hard to make a judgment call on some of these - so I err on the
side of backporting.  Feel free to drop stable if you think it's not
worth it.

~Gregory

