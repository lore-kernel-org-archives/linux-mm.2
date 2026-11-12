Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F28606A8B7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UIE+jqZK
Received: by kanga.kvack.org (Postfix)
	id C4E016B05CC; Thu, 12 Nov 2026 04:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24E66B05CD; Thu, 12 Nov 2026 04:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3ABC6B05CE; Thu, 12 Nov 2026 04:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8649E6B05CC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:08:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F5421604DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:08:36 +0000 (UTC)
X-FDA: 85425891432.26.EA57933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 33914120006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:08:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIE+jqZK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0TW5g+5gf+ItcPdOWLfpHX4VmIPTaVn9u8r31nhF/E=;
	b=yXogDi/cVRlxy4LuOPfIKQHELADlPXuGIZDvYFT17bFvsHdB9uowS7X6mv3/x3bqVDraDk
	Ph1Y7NgdPqYGDlGOkB09PDYi5A0NPLuAgLmK9i2yPHZ9pLAYOgZSzsvzEdewbZDjHIn8Vw
	MPfyOuDaXMSGUzJx8KZ1jhMktx5GxMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474514;
	b=I2ZjhRTFgaZBv6nkmuNjjg0ISY1ArO1ec4CULoBjr52Yltybms+hCnqIzl62tpM0vlA6gS
	dMcvb8/s8PU4+W6nMW82EfF20qGn0u5AYg0OiCrm62uIrhl3vDJs4BLJHCmTwUjPSqmSMd
	6bbE138Fa3DVZ3Qiv34hY5mSjS8OQ6w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIE+jqZK;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABB4B6565D;
	Thu, 12 Nov 2026 09:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01011F00A0A;
	Thu, 12 Nov 2026 09:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474513;
	bh=d0TW5g+5gf+ItcPdOWLfpHX4VmIPTaVn9u8r31nhF/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UIE+jqZKYrrfRzCUJkrZMjAZk2iT+4AzaK39M6M3D3/SLhCgj65MkGDvs6u/InuwL
	 p+SYWAtprInI/uTpnJZV/liEHwPI7EbU3xx7gP0pXYpGErDjbACmssL2pTRG91pJ7X
	 DL/d4ADFb+TDAmC8EFy05ixD1V2CzAsINhjWcHRTbRlZfbkkGlnv924ADJldjo9P2l
	 tz9iY/ErTV1OUvZVIiDUK972hNZ3t3Y5WLpgX9L00ZyuWOjaHfY0XaR8qLObnYnnFq
	 0590rXJS85TJ9/5fIc2IPUjFjNC7pDzMgUJrIGSVMYlu/dZ+D9a0E+n+sl/xG1rVt9
	 bdYucvLcBMoSA==
Message-ID: <094479b1-a982-48f7-ac70-75260edc505f@kernel.org>
Date: Thu, 12 Nov 2026 10:08:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/5] mm/page_alloc: Keep pre-online poison out of the
 buddy allocator
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
 Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Richard Cheng <icheng@nvidia.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
 Harry Yoo <harry@kernel.org>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-5-shaikhkamal2012@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261010162017.62506-5-shaikhkamal2012@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rt98ztrwny6mxdgwo9egk1po8qd4o77o
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 33914120006
X-Rspam-User: 
X-HE-Tag: 1794474514-598685
X-HE-Meta: U2FsdGVkX1/f56WddW5PclFHeoJtY11udUBLmUtmipORL7oTfsS8YIeHz/xzIy7ERzq9ylW8SmnJwl2/n6MVcQ6rY/ZEwNpZPnC3a1UQ5eZ7mwsMHiUQt4LxqlsmvmGsUTbU0YKcosNUaxobS6uHnRiW6AlAAkE1G4ByUxDliuUHkbQZYL3I7Ls+IkgKfRGKRw8eJyJdw63ene2hr+jOgaEG2H3kLlTR1deCjvHIMfpVv9iXOauS25xSWXUeZ2WPlVtTuyUKN1IST/sf8QMNeN8qmwcDg54cWTLAe903vANqKonWdHaT01KhWpsbigY21n6pYukVFjMu9QldWT6Ok9GjNiXtEfxF75+3+EVeGQlaGAwyVlx2E+9JPFEg7p0zxFTmBse1lLac93y6xyrDP+C61S/nbu7AWd+ijz2z51dJuRhW1VPjefH7yjc5hfBFwMLJ8D8NyL/JgsV7Ee0z3pX+JmDWPcvvowFGzyipIZnu1eWYwhEshWDTb+xo6IiYPoq/WGBl5T20zGKPPzNhcMZhyONK6p5IhoC/+HK1YlVjLMTEPp3cDo3/sExcAUYhA8ja0+PabJIBJhAZmkoHpllYalw7yVG8lVlABDmCJJq4pIFeOEr1HYC67thNTuBP1uKnuRqa3M354B4x2GQovATanyG41OkIVT+KUxMKuFDgUpwP7O2wSnQc4F+kahFg6Jk6Vgb3MEYwLEvVOyN/NOzTfLcE3G3WjJCvyOZCvF5kicv08KDlS2K493DqA8XvPFODNnpoPMwukXqlre7kAw4MPKlZjb2qPDm/t6Gy3LG7eCS/66gOYKLUTl2OaSTgasGQdkoYJN+SSJyQHu5dwBlPmtOJmxRCHSVEbjK7Ik9SLF6fEgAiV+c8dTSl4ciCHL4FXQ6RCUI7Y7fVa68E9poThcbamJAen5BC1E0EG8blh+i9+HYR14WlKlg2FmfUAcCwzUH9zREsILIOIR/
 ic3DGWes
 tJOpFSveZoxBqQ2OKB+5KPG4cB/LA0RtGzC2eyvakkTkFym3ShKFvgzRceISs5zlDNgidKsg+GKEyZaICQtJepstzHCzMX/xiy/iyhyFWRMQqV+XPbQQGxXEvjFPhBePi5mkbFvCoqNZqdvVht4dozAnof5iznvloW6c4CUOR3jV6G2UzIbyf+HpI4li+F5t26VCAtwZA4fr42MmQGg2FN/B02qzw/Tjov5dKZ7ag1KgF/7cOcsNkqAYZu+bUyAtcaklIkice2PF6LqnfhXm00OdK1BsDzcF+SmMkSkevg2Ik0CV5lG2B2X2HJ89cKLNJatmtj9o0HyQiNt1Ef0CpHVr+uheLtWA4X8/kbBAVreMyF74KuUOYX8CWjkFbsUMXUWvMHH3FQ6gD99ylbuoJFEnn2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/10/26 18:20, Shaikh Kamaluddin wrote:
> The inherited-poison path checks initialized blocks before releasing
> them to the buddy allocator. CXL device poison discovered before
> hot-added memory is onlined is recorded separately in the pre-online
> poison registry.
> 
> Extend __free_pages_core() to send a block to free_poisoned_block() when
> it intersects either poison source. In free_poisoned_block(), withhold a
> page when its PFN is registered as pre-online poison or its physical
> address is present in the inherited-poison table.
> 
> Pages identified by either source continue through
> hwpoison_boot_page(), while clean pages are released through
> accept_and_free_block().
> 
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
>  mm/page_alloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cca67a2702a4..57843df01b2a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -33,6 +33,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/folio_batch.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/memory-failure.h>
>  #include <linux/nodemask.h>
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
> @@ -1601,12 +1602,14 @@ static void __meminit free_poisoned_block(struct page *page, unsigned int order,
>  					  enum meminit_context context)
>  {
>  	unsigned long i, nr_pages = 1UL << order;
> +	unsigned long pfn = page_to_pfn(page);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		struct page *p = page + i;
>  		phys_addr_t phys = page_to_phys(p);
>  
> -		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> +		if (range_contains_poisoned_memory(phys, PAGE_SIZE) ||
> +		    preonline_hwpoison_contains(pfn + i)) {
>  			hwpoison_boot_page(p, context);
>  			continue;
>  		}
> @@ -1652,7 +1655,8 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
>  
>  	/* First: a block parked by __free_unaccepted() never returns here. */
>  	if (range_contains_poisoned_memory(page_to_phys(page),
> -					   PAGE_SIZE << order)) {
> +					   PAGE_SIZE << order) ||
> +	    preonline_hwpoison_intersects(page_to_pfn(page), nr_pages)) {

That looks rather hacky as well.

I really don't want us to have various source of poison information that the
page allocator + core-mm has to mess with. It's just very bad design.

I made that clear in the last kexec attempt to do something similar.

This likely belongs into memory onlining, which could online only the relevant,
un-poisoned pageblocks.

Not sure how it would best retrieve that information, but we should definitely
not add more shaky hwpoison sources to random pieces of core kernel code.

-- 
Cheers,

David

