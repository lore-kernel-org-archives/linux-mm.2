Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5818C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BCD6B009D; Tue, 21 Jul 2026 13:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6339C6B00A0; Tue, 21 Jul 2026 13:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570646B00A2; Tue, 21 Jul 2026 13:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 275EB6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:10:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1D811C0223
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:10:22 +0000 (UTC)
X-FDA: 85013422284.14.E82E311
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id D75FB80008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:10:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g+8aOB/a";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784653820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fkn3JmTHyZHrmeo+sPGbWVcJWg9Sa/ZKVruguzBjPig=;
	b=0cI5dAwuTr9t30sU6/hR9GaJZEXcJiASkv2fHuWoGyPsf8y5jtU/+gVApf3F7OxRFjvoJs
	GXpMT+kIuopvIce66oYaTGHQWMvsLozuJkk/ZeQjLzpocO6NgjY4ZS415z6qYFI3Ty2IfL
	UVideRaqBKvMLMvb6mo27aMWzc+4vi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784653820;
	b=kSii82dGeLLU3My5LY7FfZrU4rRK5gXVQQ44FTzbnM4vhqwJOTDtB5CcvKWAQsyZVrVyDn
	Wp4CmlM7jqMgDAV9j+wZGqyFjuf6JttVmbpZudFK3/ipwxk/E7dM9oYBA0a1MTWmdM2/DH
	TEdTPEfuPRbyBnnMTI+XXdYByw9o1S4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="g+8aOB/a";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ccf2360620so76435905ad.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784653820; x=1785258620; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fkn3JmTHyZHrmeo+sPGbWVcJWg9Sa/ZKVruguzBjPig=;
        b=g+8aOB/aHG7KhaXTbcbuheyaRKAWEaPTU7WV1eodsmkqsIRPLj1MTTzGYTLW9rl5wM
         wNrACwu8dyvK3dIrvtU2HkPIe65RuGm0FUhvZF6ImFXsMAjAOjps17NBJ4KYSmDAv46D
         W2QvWe0VJG+2tCLBo1yTA/gZRcHOKMhTreAcWMfFAtdD5TBZyOS/horwNbVyy4kWxFvD
         dl7wq8VFh9MnEWoT5Zs7ExzzW+ZGQtkWHCILqLzRqVgKOz6wy+4eOk1jdk5q8tlw6Xu9
         riT5ZPkl0ixMs5e8UhUCmeT0Kvr5EBbEe+WeKPnEx+cc69MGMZB8emxpfOO8942+3tJj
         bFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784653820; x=1785258620;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fkn3JmTHyZHrmeo+sPGbWVcJWg9Sa/ZKVruguzBjPig=;
        b=kngoAU7WHlbEZ842xPgYFZo//OKuC84OavfOU+JF8qA98TeVy+niVC+BTzMGpseBxB
         XcDquks5L/NoMAS11CIdXfGyyxJDvjSDUHH43YLyEfFRpEOqjHLZk/0BUGoUJ2VCyjeT
         Z9u6WFTxmgpmtIvCv3VDudY/HlhHmbJF5nET2FHd1Ty5ucDQBhLkMynvXsS4+8MAz4fN
         1hnMucoIINNDPrgdc8b/RrTdcCa7UlgbCMSRw8mYkpY/mvG5lnVxWGiJcKsHIO44y/Ay
         yvxrfGWClB3qRa7kyg/u6Z7SoMFV7V5knqEagbJyZ/jaSxAB8qVfE4BjuAf/DoOsuTtE
         eNug==
X-Forwarded-Encrypted: i=1; AHgh+RqkRsMsEiVivjwaNcjl3fi9+zNCMxlWJCpJ3Y9XwSg2/AFU8Fys7pEODv81KxiWXDtvn0jFLb6Hkw==@kvack.org
X-Gm-Message-State: AOJu0YzZllFCxrmnmNFfRJv4tw7efUEf0g83q+TgZy/YTomHMK7Re+Ku
	sNgVEjFwvDMMMkno/hM3208lAKOzHBwht7m1nNyZdx8+zHPjlMvSoea5
X-Gm-Gg: AR+sD11Gn6S2HjQpFAN3vQ9YQX95H7xUm3Ek1b97ANtBRiKB4bNF4j+WoVu2HAvcYsO
	0Q5Ens27EsE4ZD+4K64yIMLiXcAK3uxNd0N5RHbP3BWwALsAOf7Ceo/60lFjK3Zvu7ygdcUGwSN
	ReUQ99OJ2hzzWrH85F++oTdTbnrhDjmqlYc6jqb/mJkfqLxHApBZjRk3B7l9a2fTF+KwbPhgmYG
	+uR3YgxYUJh3uRj+aoGtGHw6Yz5TQSwCeOOKiNT+yQAgSzXGhMiqaKYgXm9eVRcQk/wrBZUyopU
	M+wuHAJoPVa1DwwdI2GWpTMFoFwffOMZKd3QjFXYbvtWOAqImvidUYIRcMA1sQ0cHaY6Fzj4MKZ
	6qV61spgHsNH3Z9JX3mwrZYtwSVSKUKQGuqKlmJAzimJ2237aLrgqt3CZFF9sSlO9bTCAc+G8uT
	VuErh29MABwOyHzoDfhgukoaE5+6+nsEFSzQ==
X-Received: by 2002:a17:902:e541:b0:2ca:b4b9:4586 with SMTP id d9443c01a7336-2cf348b0a43mr211904095ad.19.1784653819673;
        Tue, 21 Jul 2026 10:10:19 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1bc886sm585939eec.26.2026.07.21.10.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:10:18 -0700 (PDT)
Date: Tue, 21 Jul 2026 10:10:16 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kiryl Shutsemau <kas@kernel.org>,
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2] x86/mm/pat: allocate split page tables as kernel page
 tables
Message-ID: <al-n-Eos9mc_7lvd@fedora>
References: <20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D75FB80008
X-Stat-Signature: xhm8ed6qekhsrs5q1tz8m3ancum9hh9c
X-HE-Tag: 1784653820-232431
X-HE-Meta: U2FsdGVkX19QKH7OG0AxIoDW7tg200AqTV/VIiIubf3kc8yb8gdKDBBVQM/SbdKUP01XhMr5evjqFNdovjkPFGTkPxYCa9DdAlgkTpgQNHN5FquX7Fgq1A4xBU453G2sjQ4/zrgQ7Q151jIkQoHQClb3rd+9KxsjEIt1lwRT3O/QTXzUuOZwpMAd2QgM/56OyXdsZar7mK7i34S1La5/zN3OLpVkZd0TT0r9Y7sgDls7Fm1Xsx0eIVXZ/Ffzyv3dhC9lZeVwpiTu+lKx/EM4AElboxXBZfk+O08Zi/VdtPzHHbkxQHDEaU9EFznmAiHbME6iswOTu223N0aH1FUXp4PkTAKqhYG3vUEAoIlgZfyPbZYoFZX7kuMaHLLLtfpuhcZdu0bahF+TcgOCdPvtqrcF78GXATHzbZzqDAnfZhMqPuQabrrLFzGM1da1SfjYxLkBxte4V/4DWNeJE1w2cdhG1duyrfKrBbEN+dRJFuZr1wd2Elhm7VV+1PQHmqiuXd5knxjHYlweFaPByARdoZcjEABIHdhcLXApjY5En93C79qaRmQUyg85zPQQyzb1eXTqU9cTnLNDvlgRjhXgbYc2PNffqbXmvLBgIOkbkFvCXbq0Hsx9ABBnuaBpiLngQ4QfN3jAdb4kikA1iTdZu1SFO8GYRm9TkAIh+hhHfDYrT2bxG0coFDVdzuTTcRSYKkHMJiBUzA4eVXtIYzFp90Y/QyYGIJ75IvZmcUHvDtsBhY6b7UVNbaS1ce9zdorKtC+3d0C+necjpJLlomdHSEB63aZWNe60DAEGlIN4Wdm86W+3JBY8iZAo8oc+1X42Wv9hiiumZgxqfJFaZO//xIVFe4JwiRIf2u7XgqJnfHv5l3LIIYOcqDJ2fhm5zv6kNqVhE2sh0Ohe9pltKG7tA1jXPu31+oIC8t55ixvkIOcJSqOwp3iuzetlL4ga8hj7t73Pde21wcFjQ9+O95y
 OGreurfi
 6M3o1iJ3bI0y8Rm/qkXrDUZCyUc+dpxBD8Y/YF/7yQ69HdXyl6S4UNa8jCqb1LwH3EAXex+FW5MRxuQSiiaZBK7CkxvfBmgiawKLJ2cFszZaUD7jnHDjpBpWlkkuYZaAHnmX/tF3QYV4LKEHu5JGGgYgOShgk/sjVr8849ppmck8Gc+5cyi/5ohDzkypyyCieZ+oyFDRK2dBnvyZOBdb6OIyrQQYc5VRPNM4MCswtmn7v2euQdY1517bzWdufS4lhy8pjJOO7F/5Pd+AF4NnZw4uzjVsz3Rpt6NJD9QQleiWd8luZks8Tksw5k+D/F/60yN5k9UmTA0g43E+Qaa9InsEk+6pzqVs0pDdyJJszIyNHqj2FKtT2eTTBP99a4gYEUzXoH+eKiJ06q/aA3nBtFEHZ65it3D3gAhZVXgVEjos7CtDHvQN3jZAGtpiFN4c0tKtizZ6AfWgO7mtA4KHIPPbuvgFkCCNcqk0pMoBLrUATX6SsPHHdA5W4zURhNgrM6yV32cE9IzgaTms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:14:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> When splitting a large page in CPA in __split_large_page() we allocate a
> PTE directly without going through the standard page table allocation
> routines such as pte_alloc_one_kernel().
> 
> This means the page table constructor is never called nor is the page table
> marked as a kernel page table.
> 
> The former results in the folio associated with the page table not being
> marked as a page table (__pagetable_ctor() is never called thus neither is
> __folio_set_pgtable()) nor are statistics updated to reflect
> it (lruvec_stat_add_folio() is never called).
> 
> The latter issue of failing to mark the page table as a kernel page
> table (ptdesc_set_kernel() is never called) is far more problematic.
> 
> Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> tables") kernel page table freeing has been batched and since the
> subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
> for kernel address space") IOTLB cache entries for kernel page tables have
> been invalidated upon being freed.
> 
> Since split page tables are freed without this invalidation, the IOTLB can
> contain stale entries for them.
> 
> Resolve the issue by using the ordinary PTE allocation API at split time.
> 
> This results in these kernel page tables invoking a page table constructor,
> and thus requires a page table destructor.
> 
> Since we cannot assume one is always present (early allocated direct map
> page tables are not marked as such), we conditionally call
> pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
> otherwise we free the page table via pagetable_free().
> 
> Regardless of which path is taken page tables marked as kernel page tables,
> which now includes split page tables, take the correct route through
> pagetable_free_kernel().
> 
> There is a user-visible side effect in that split page tables will appear
> in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
> allocated after early boot), however this is a positive change.
> 
> This issue started being markedly problematic after commit
> 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
> choose this as the Fixes target.
> 
> Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vishal Moola <vishal.moola@gmail.com>

