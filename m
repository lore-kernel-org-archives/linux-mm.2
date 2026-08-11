Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4F1C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38F56B007B; Tue, 11 Aug 2026 06:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8696B008A; Tue, 11 Aug 2026 06:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFEDA6B008C; Tue, 11 Aug 2026 06:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B87CA6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:15:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4857C0357
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:15:12 +0000 (UTC)
X-FDA: 85088580864.08.F998685
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF5644000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:15:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V+Vm46x3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786443311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUhvKPduqga02M+B6qbI69V7jLvtygj9qgKWvWm+jw0=;
	b=F6Vkp0+fQAuqDPDYI/KxgjddwqITeXgCw+7fv+r8waKPrKDHo8qJzYqcXhieU70DY5kIyt
	9llX1QzoISZXZAdDrI61oGuBNK934H9Xpd0aHHku3fLC4h8SI0KPA/KC/0d4N7q3XE2hPM
	Plsk8FrRODwVZHhmHvE+EZl73MSdcNQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V+Vm46x3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786443311;
	b=gVQ7jpTIE7xMwY/DgDD4LSGkhNbelSHo1GFyxMbdY5/SxRRx6PjDKneoDU6oO5CA4dFFjE
	DfLTscfowJQsxgj6kfEiyjKQN6L8dIcXXkmPTgDz8UTWP7nF4LL7oAfM1ofDWkeQTzRKks
	xKE/hvJnN/i1NvrsoMH4ee2Uq9QYRwQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBBEA1682;
	Tue, 11 Aug 2026 03:15:05 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0350C3F86F;
	Tue, 11 Aug 2026 03:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786443309; bh=+szcqBCq9eZ2ua7vWX4x/+s1q8ODJlqcpxLyiJuSiwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V+Vm46x3ghCefqeO2I1n6DA88n8dnPA9fKF0KOYZamwYwLaVm1b44z72dYIEIsYC0
	 p/UxibT9bkIS6vm2g/03/53REk/x6Bjd7ZTy6XlUazb0cSaz7+p0GyYbiNAyjJgZGx
	 FyXK8Yk5Rfauuo195Y0NDG5YghHuk7t+gElvU4PU=
Date: Tue, 11 Aug 2026 15:45:06 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	pfalcato@suse.de, agordeev@linux.ibm.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH 2/9] mm: make hw_pte_t visible to generic PTE interfaces
Message-ID: <7xbai2nyu6nuyr6otqv556dnphpgwaqsmvwkqwoqwbh5nvj3ns@ddy5ezgvb7w3>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-3-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806083926.1807279-3-usama.anjum@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CF5644000A
X-Stat-Signature: ocr5yf3bqfcdki63wf1kendgimi9x4ge
X-Rspam-User: 
X-HE-Tag: 1786443310-720441
X-HE-Meta: U2FsdGVkX1/OrrWwDdFQOyEbqWX76/50/0I88oSVSqiO4QRIhMeRVv9zK0PPvL/I7uz+kvmI0bptuJnHvMZhvNpAvimiDRKIhYHij2PIs9DZ0Bxgse+ERjFa0fpr9g86pAVRX/2DOvFB65XXBlXPgYq8Lsfwghq6HMGg4sVjSF+KBZQNiwtR8JGVWbSgYJ4StC8pups7riBc7imbxebesRIvExcIAGa36V35D5wXedbq6bwYASTCdzasQ9QS/b52rvqh1XPrjeVNcyQvIL4NWf3CWUj/wWtG36rcIEm9IvKdputgOc3ADer6Nhlne8N6e6TxoweFPsDrSxK38ubbufFfv1B5/8aeAPLc5syoHWY2AGCEegHWOSdktA/6bwogIGDNybReky5T5jt+MpfPdB94Tnm3eZJ+E/IW1QruThhcC4i8KoHPXDEWyr+ZPuICtanABUPeUUWOUNsQNb/D7RaFj5krHB+LG7rM5kVTaq08ArFtLt0jacI2z69mJIEX2N+hKghC5LU6zQEklixCEZBdSORpHiosaSLQmnw/rYnbgV+xmE+G9MpBjWDK4kzH3Rboqotd28rXTFqDYWISCKd0sFnflt28ZQPgMHaS8kH1a03jx5XrKq1XQ3wdDNY7JR0YZmyhjdzuBOi5DbOUpNh8vs/PiI+ei14Aj52eTciROkis/tOlFi3fmizFId4QxFlTJBwTsDxbL1FWrg1jA+XjC5h0AcXOoOnBMDYndgVxqV6Fm0KT5RWNsm889DH5GIHtbVT+Faxzik0quHDghxd++h8xd0iiLJhUw+RfqeZ6F2OwM9uBzNtBbW3PS4wgrkjv32DrusVOrXx+Gtzr8OhQv9Nk1+oONv8t1NySXGhENuM+DxNNFrzVPL0F4qSL5stIl19UBbY2ryhp5wdpplNpmKQR6//7anZr6t8dqM+Ej3ooOSid65JVWoHyRVZ2EncoR9HMq+49kgCVszO
 uuzmJGfb
 cUs16qZ21Dc6nI0BwJZTNSRlXyu0Eacr/3R86E2WF9i/15kC1Z9ksTIHYF6tEKbnMjzyOgENdYNFJZ1clh/hAcGktKuXlXv18X2gG6mayFeqmr7Lv66qoQpNTvyiutnMGDvu7Sv5Eq5kkYXAtP3NehhxfzEwD9tJfnHwec1kzJvRsmwOPtlEpT2g/AQIZ46fCfrjSdwJ8d6tMeidUpv1XPqB8KFEsWxfJA9BHAZis+DWv61nQ+yhjUJ87FEfqTlzR/Z+bOMCnt1ZO88ZHLWkKFoEukxJ25mOQ9tt6dWDjY0HAWwO1gZhFXvBsCQ7JZYeXiyYlqJ8iDcWv7QFidlv7r3SJ9q7VWgpyqrNEPmRB4X8x4qJ3Ut3m5bPXL4RCYxKbHK2j7pP8mymG2va8TkDCE+CCTIvw6mVI7hpGyETh4cmZ+1QlcLOvsgAhVePuRGYXTU3bf4eKUqlIZTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:38:40AM +0100, Muhammad Usama Anjum wrote:
> Later conversions use hw_pte_t in page-table checking, generic page-table
> helpers, and vmalloc interfaces. Include linux/pgtable_types.h from the
> headers that declare those interfaces before changing their types.
> 
> For vmalloc.h, replace the direct asm/page.h include with
> linux/pgtable_types.h. The latter includes asm/page.h, so pgprot_t remains
> available. It also provides either the default alias or the opted-in
> hw_pte_t wrapper.

Stand-alone header file updates are not ideal. Why cannot these changes be
folded in, where hw_pte_t gets used first time ever in the above mentioned
places.

> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since RFC v1:
> - Clarify that the header provides both generic hw_pte_t definitions.
> ---
>  include/linux/page_table_check.h | 2 ++
>  include/linux/pgtable.h          | 1 +
>  include/linux/vmalloc.h          | 2 +-
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
> index 12268a32e8be1..12ee6d16ad339 100644
> --- a/include/linux/page_table_check.h
> +++ b/include/linux/page_table_check.h
> @@ -7,6 +7,8 @@
>  #ifndef __LINUX_PAGE_TABLE_CHECK_H
>  #define __LINUX_PAGE_TABLE_CHECK_H
>  
> +#include <linux/pgtable_types.h>
> +
>  #ifdef CONFIG_PAGE_TABLE_CHECK
>  #include <linux/jump_label.h>
>  
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a8..cf595608cc4c4 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/pfn.h>
>  #include <asm/pgtable.h>
> +#include <linux/pgtable_types.h>
>  
>  #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
>  #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index aed121d729b01..b068e6ade4207 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -8,7 +8,7 @@
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/llist.h>
> -#include <asm/page.h>		/* pgprot_t */
> +#include <linux/pgtable_types.h>	/* pgprot_t, hw_pte_t */
>  #include <linux/rbtree.h>
>  #include <linux/overflow.h>
>  
> -- 
> 2.47.3
> 

