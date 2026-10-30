Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF48606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Exq5Sp7z
Received: by kanga.kvack.org (Postfix)
	id 799F06B05B3; Fri, 30 Oct 2026 04:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744E86B05B4; Fri, 30 Oct 2026 04:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633936B05B6; Fri, 30 Oct 2026 04:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8F76B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:58:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2B551A0658
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:58:14 +0000 (UTC)
X-FDA: 85378690908.25.7F1E8E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E9C2BA0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:58:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Exq5Sp7z;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793350692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r280hiRf1n6xtUd8PrDvA2MR0wI6dZTEfLDR+8JhqFg=;
	b=YjvslROMFI9oZl3q45gxYgaa1YpoHpmCw087aAQaEk8npwPKHCvsKQH7cQ7mH3Z1OR9i5S
	fNhuuB5eUAmyz5OrrUCtqtmZfhwfiilfdYEwX3CrnecCrh5+LHKZTcfthYfAS9AHkXAlph
	dbmG1PV+pbiVc3LQZaRruaNpsNu1JMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793350692;
	b=Q0LfX1qZU/1s4ZzqQ5DdPIx3/gLRgXS1f36h+FOlX2vC/M25+Xt7TF8GKb7ee60ZKPiM9c
	AFL4EXZ8afLWE2IdLbLLaig4totQRJs+2/xo0F/rABzrRmUe4H+ZejFXRce+lTk3PTL8iC
	kmyBjObTnApPVQ6xsz9Y+V598Mqm8/Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Exq5Sp7z;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 776B86062C;
	Fri, 30 Oct 2026 08:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AABA1F00A1B;
	Fri, 30 Oct 2026 08:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793350692;
	bh=r280hiRf1n6xtUd8PrDvA2MR0wI6dZTEfLDR+8JhqFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Exq5Sp7zAbqNuqGv6NplKuvdr/nF4Y3VmHgtgpTLaZbU9Jx+zMmy9hxCvaaN31rRH
	 OXAH49p1efwmh9zrCzsYf1pFWirOHcKauQ7DZ6dnzldnZcaI9rAnWgsVclPTmFxOIu
	 wqwyFVvJv6NJhGAUPUhuQGODdeljpPlxdAz0GS6+RF7DFvAR8XjS0lo7BevGFn6/wJ
	 mz7quZWteNXZVRLTrgNo935jT8qWHudzcdV+n3P8+A+zxNy3fWJsf+evbdLNaUs2HL
	 QSaYI8xsJc88Guj1G+FbrjZM0Ugyi4eqJFZMlH5Wi31jHqemR78BtdXpdRcXqF0es3
	 ai1bGZuOgGUDg==
Message-ID: <6086c386-3903-476f-ba55-bd6c21072f72@kernel.org>
Date: Fri, 30 Oct 2026 09:58:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with
 multiple ranges
To: Tim Chen <tim.c.chen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Frank van der Linden <fvdl@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Mohini Narkhede <mohini.narkhede@intel.com>,
 Pooja Jain <pooja.jain@intel.com>, Doug Nelson <doug.nelson@intel.com>
References: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9C2BA0003
X-Stat-Signature: mo5kbed5ysqhzt9yc5sxxqkuq95kbsqx
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793350692-123161
X-HE-Meta: U2FsdGVkX1/87XbKq1ymYiyvcRrm3SLuZA5pHAqaUNLc8P6hsZOlV8JGAdN1Tg60UMDT+fMbXxk2h62ql6seS8DoIui/DP+NNjin3FLm6I2JzgtrYHJm4UBJ73nz0tFNgg75t3/4apUdm2d/Kv5XukUhD7zb16Jkd1bA+pnkXTmOoHYJ5Gyek76VI0PVTmtAceHD0smOaYrYz68OPsbNJ2G3fQlzwYdqSfARgu7lIXp7Nu4cAaqhNKyLa9uN8yJK/wf+IiVPhTJofzt1jqPPIlBqRlNHFmJNv2ayFEYl9sY7LbyWQSauoQKzRwFbuvYQtGjpYa7+IPBzNSTDGax+p9VevSqhL1ZLcsJHjTiSv5rRDNgEmZN+Jmm7UTGzrFt1tE0IjD1asHjlOMdTbAvtzqiyKBxzgA0IfAOm0ObyKw3xaeiFqrMBj/hG04yhPp1cwlKtta0fsTkcna8pmfDFd1eNO32dLHrSPCxW9dBs9j7ZQYiBriv1Z2k3vwszxNws9pI0Pjuo7xq4pbskkMv+lut4nw3BVnaZthpPKomvu5sg8wkojZgLxLIeCuoAbM39wAieEb9YeRd+FKOeGnRLlWowdC7ELqu+2VeK7NgeoM3jpFLZuQ0Xn+B+LMW5G9t+T6lc4JceHzCUq1hsAQ941Edc64ba8sB2naBuvaMON7bBwKNVD5c8LoT9s8joao4ajXkOYYcSt2zbOHagzk9eiAnEEycBycX4ELc2KwR3+CuYsWBjFjMWv1ArPFWsrIQtZQCUs6KAQ52UjDk5ShB8TwhchF1jSJZEYOiftnJfX3fsYvVWHZJUbDexE9e7j4ehCImzZCmznR0YY9dvJNgwHs2+bqVh6RSy2/RegkYx9CjeVGPFY/Rqum26Yi0IxuYFGI6628sjpkbe71XUCaPZBv9seS1dddSYQk9NQDaL7dxcv7FyUK387niVCT9Q8nujh3stZTHKeByn3JHDGj3
 VcS53V7I
 9faHZLhYlmynVYKTy/nL5CBBN5BQgxhwiNvsGTJQKYUATrNvUWXPAJluaRnlgh1JqFFTJzPJa+ft0a3MVIMo/CaKqT2kSKSVG4pZWGItGtyNfYT96X1DtIEMGlZLOgKYhvEfeN7izkjXltsX5J16aRr8UyY3cWVnXj8tdsRdiCbC9KoA6t1JfKpMb3+wKACqOlUtngMqNOqgFHiBfJQ3NIiHoKKIo4UJ93XX2/BH6byDI6PcHEk++tnqATVWHh4PE6tSfmYjusMP/EyrUZa2rqZLQ6I0lMnlP5dQVMAXQziOx7guuVQydcT7APChfl7id+S0lBedgWFcHEzeBZlOKo34dVjcCXJ8myy8V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 22:21, Tim Chen wrote:
> sparse_init_nid() allocates one usemap slot (struct mem_section_usage)
> per present section in [pnum_begin, pnum_end), and
> sparse_init_early_section() hands them out in order, with a BUG_ON() when
> they run out. hugetlb_vmemmap_init_early(nid) however initializes the
> sections of every bootmem gigantic page on the node, including pages
> outside the range being initialized. If a node's memory is split into
> more than one range, sparse_init() calls sparse_init_nid() once per range,
> and this takes more slots than were allocated. The same happens if a
> gigantic page straddles a node boundary.
> 
> For example, with this SRAT layout every node has a small range below 4G
> and a large range above 4G:
> 
>   Node 0 PXM 0 [mem 0x00000000-0x2fffffff]          768 MB  (low)
>   Node 0 PXM 0 [mem 0x100000000-0x80cfffffff]               (high)
>   Node 1 PXM 1 [mem 0x30000000-0x5fffffff]          768 MB  (low)
>   ...
> 
> In 128 MB memory sections (x86_64 SECTION_SIZE_BITS = 27), node 0's low
> range is sections 0x00-0x05 (6 present sections) and its high range is
> sections 0x20-0x1019. The low ranges of the other nodes are 4 or 6
> sections, all smaller than the 8 sections of a 1G page.
> 
> Node 0's first range has 6 sections, so 6 slots. With "hugepagesz=1G
> hugepages=400", hugetlb_vmemmap_init_early(0) then initializes node 0's
> 1G page at 0x67c0000000 (sections 0xcf8-0xcff, in its high range), and
> the 7th section hits the BUG_ON() (seen on v7.2.6):
> 
>   kernel BUG at mm/sparse.c:268!
>   RIP: 0010:sparse_init_early_section+0x9f/0xb0
>   RAX: 0000000000200000 RBX: 0000000000000cfe RCX: 0000000000000020
>   RDX: 0000000000000cfe RSI: ffd7e1d09fc00000 RDI: ff252cb28ffb3f50
>   R10: ff252cb28ffb3d40 R13: 0000000000000d00
>   Call Trace:
>    hugetlb_vmemmap_init_early+0xe1/0x140
>    sparse_init_nid+0x56/0x370
>    sparse_init+0x192/0x2b0
>    free_area_init+0x7f/0x690
>    start_kernel+0x64/0x540
> 
> Here RDX is the section number, and R10/RDI are 6 slots apart: the start
> of the usemap buffer and its current position, which is the end.
> 
> Pass the section range to hugetlb_vmemmap_init_early() and only pre-HVO a
> page whose sections are all present and within it. Ranges are disjoint,
> so each page is handled once, in its own range.
> 
> Skipped pages are not marked HUGE_BOOTMEM_HVO. Their sections get a
> regular memmap from sparse_init_nid(), and the pages are optimized later
> by hugetlb_vmemmap_optimize_bootmem_folios().
> 
> Fixes: b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated pages")
> Cc: stable@vger.kernel.org
> Reported-by: Mohini Narkhede <mohini.narkhede@intel.com>
> Tested-by: Pooja Jain <pooja.jain@intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  include/linux/mmzone.h |  9 ++++++---
>  mm/hugetlb_vmemmap.c   | 38 ++++++++++++++++++++++++++++++++++----
>  mm/hugetlb_vmemmap.h   |  7 +++++--
>  mm/sparse-vmemmap.c    | 16 +++++++++-------
>  mm/sparse.c            |  2 +-
>  5 files changed, 55 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff54160..da17dae8b057b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2167,13 +2167,16 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
>  		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
>  }
>  
> -void sparse_vmemmap_init_nid_early(int nid);
> +void sparse_vmemmap_init_nid_early(int nid, unsigned long pnum_begin,
> +				   unsigned long pnum_end);
>  #else
>  static inline int preinited_vmemmap_section(const struct mem_section *section)
>  {
>  	return 0;
>  }
> -static inline void sparse_vmemmap_init_nid_early(int nid)
> +static inline void sparse_vmemmap_init_nid_early(int nid,
> +						 unsigned long pnum_begin,
> +						 unsigned long pnum_end)

Two tab indent please in all cases here that you are touching, thanks.


-- 
Cheers,

David

