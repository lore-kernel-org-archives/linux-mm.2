Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C668CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD0D6B00A9; Wed,  1 Jul 2026 04:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5DF46B00AB; Wed,  1 Jul 2026 04:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DCF6B00AC; Wed,  1 Jul 2026 04:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93A6D6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:09:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 276B2A0294
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:09:03 +0000 (UTC)
X-FDA: 84939482166.27.6E79088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41909180003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:09:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PuviNBw/";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893341;
	b=d5ALFZeQGaOXPGReSTjESPVy2jhjH656MiKN508KSRTqfh4sgJ4QB49ruzL6Gg940bZNlV
	x4f4gVFwE6GBr9C2QK7B6BwJy5obW4QGgRlnC012RmzLKlos23yXPtMsoxK3Om3QjVXtWn
	5OBjT/Yxu0R8J+YAOXdssGDKOd6SmMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PasTiCU3YYSzDJMw/2oW+WrIXsxSxSCS/T4cLHURas4=;
	b=izp0DNfrW0VolWpgy7W39pWF5GvhsWemsft/eQhME1pNJnUTWcOxfkkgkBc12seWt3aYDc
	KfwgYsTLarw9C0bz0WRwFA6iOcHxG1k6w4Hf7O7K+rx1KTSmlkLPkzVynxi/bdHunxc9V0
	85hBBGj/Pu0CC3AfVDM0RjB847wphXY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PuviNBw/";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A73443C6A;
	Wed,  1 Jul 2026 08:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A021F000E9;
	Wed,  1 Jul 2026 08:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782893340;
	bh=PasTiCU3YYSzDJMw/2oW+WrIXsxSxSCS/T4cLHURas4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PuviNBw/zP6qFiEZRgLkSTMXs85DfGhL6LknJ9ziVHJETZBMibiUp2GOe/SF3dJCU
	 vEi12ODGnu7w8E8m1TA1r0ITEEF9KuNZsrFXXIBPiKnh5yBYIsfsFC5m/r+DcyLA+t
	 McIrVNAq620EI1vNaPcGfU9K4az3LbRyko8CS1X15bPC4m4QMSYgleQoST24LNdWMR
	 FqHzicmUT/RV2AeO5dZ5vcCPLn+qW3olpEbkW0Mj7YZWi6ii8pXyRk7HTtoprbIJ61
	 g4aFbJOJA16KAMzNEOcN6UBH7KkJNduMypns1g8M8hPa1NLRjCHO4cIiQvIoOmxb6p
	 b+rMv7iH2z1kQ==
Message-ID: <6e250f1a-70c8-4330-a938-162cd700170e@kernel.org>
Date: Wed, 1 Jul 2026 10:08:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/16] mm: Move __alloc_pages() to mm/page_alloc.h
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-14-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260629-alloc-trylock-v3-14-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41909180003
X-Stat-Signature: pa4ccrcjaor5wzuud8zcum19bqdjnp31
X-HE-Tag: 1782893341-825748
X-HE-Meta: U2FsdGVkX1/XA81nZM77AH6bSATAPxVdXOgrn6mgIgAgWns+7C1vipgxF1sSDp8mpC6V7f5Rkr/XV+gs+IhuORscV8qK8HrSs49VrJ5+YxTEtPpOgnbXCk8afsCfmPpC0z5o148OiixC2zYteHU9kAItUfKm6WTTQ6N2n4+KPv82NP07I6TYHnpVrLDLiLqJbEDw1dio7VHjBQMtzqR7tE9y7TdQoydsP6gfQsMXUibexWsG29kke1v8oErM3KpGzkDhQSd+ifnzohWOqAsvtOn6iJp5xiXcbEAqnxyy2DvNsX75vgBukQIPUwYw3xsp/2wEJD0MNfz/AQESC572dyePUvR4K0LuKn+A+05QS/rvgFYcZ/pyuM8KmcgaFhnhGXpJisQmtyfwuZ1zM8IWCcwawjktY8JSrXcvbB2239TKKchx1gpHem+eLo+MLUyR7m9pjGlozJBf9Jz/a88eiXdzuAvFFNlrbAJWv0ZxtJ6w2qq2M3nIxj1tzDH20TEE0QlWWIlCUHfr6sH6p4mT/1q32LnOoXdyjb/TCwX/NR60tcpnH0X2atz7z2JiY1KcB1pj2RWq85qxN1oMqKt4fXHn21gkPs5T2rHQ7Ynbuy0c6r/K9Ck0iKXLjvg3paYeLqTzY9CGdDQHe0aLEWr9dqN2jbHe2gSXTkNPBBOzDKsQdDY66VDTEdeVIP90TceKreiAhhrU79z5lyaU2joYCQfTIR+BY9yVadFnzZlvg847deqoN5f5hwF+uc2n1WnOYVB38unq7PK0G3Pa4qNil0J8BU1q8gpcJpb/OCUGZ5ZiYwrDh9LCsyKhEU76IFwkAA4mEMtuvH2X6rljEzI+vNnKTSYoyCQbnxX0vLOwAeiWv77vQGWG8NJIZwNjZisA7bquIH7giqCsbOtyqE/7px3GcP5oGCol8mdN8Hq/pe899JRFjytsGzyhoJq6MIWmc3QEr+0fkwOGqYV8h4T
 iSaUQW2I
 aHmea9YToLTxbDvUQ1KNYGSkMSOMuGTsVX8va/ZUbvq88jL8rcWBOyFV1EdFKifCjsrqZ30+Ym8lXDPETts1hs2nvZeWIvAvq3inh1sVLyGft6plHSZeYW1djbDc+4Y3TKNPSs1hGUyI5rFmORkdc2xhHUsoPIC4cO4CmpWHZC47WVy0KBY6DM9axGo7tUNeKZVuZmiS1JW3xFfATqBBHMqp2m2YbvIWM5Out/im5fWcDI8FJTao4btv70DhDlBRbI/FIl5Qhn5VcBPwTdFgyWGwuzd90IsxfXCt44GGJ8Zhv8IqcsbODAUFafliAbQBiRHIRyMfM7pZYmKJCnyU9N3Ue+s7m+9bor72ab4/86NYoll2nbd91uN+B6oyF8ovPs58H0UbUKi5AzEZRv3aER/FoJwigsTbR3DYX+djzF8hSoKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
> It's no longer used outside of mm/.
> 
> Since this means __alloc_pages_noprof() is no longer visible from gfp.h,
> this also means moving the definition of alloc_pages_node_noprof into
> the .c file.
> 
> Also remove references to this API from the documentation tree -
> referring to the specific function name was already questionable but
> now the function is not even public it definitely seems wrong.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Less inline bloat also good.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  Documentation/admin-guide/cgroup-v1/cpusets.rst |  2 +-
>  Documentation/admin-guide/mm/transhuge.rst      |  2 +-
>  include/linux/gfp.h                             | 16 +---------------
>  mm/page_alloc.c                                 | 13 ++++++++++++-
>  mm/page_alloc.h                                 |  4 ++++
>  5 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> index c7909e5ac1361..52a213aff04e5 100644
> --- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> @@ -284,7 +284,7 @@ take action.
>  ==>
>      Unless this feature is enabled by writing "1" to the special file
>      /dev/cpuset/memory_pressure_enabled, the hook in the rebalance
> -    code of __alloc_pages() for this metric reduces to simply noticing
> +    code of the page allocator for this metric reduces to simply noticing
>      that the cpuset_memory_pressure_enabled flag is zero.  So only
>      systems that enable this feature will compute the metric.
>  
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 23f8d13c2629d..16f37135ed80d 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -761,7 +761,7 @@ compact_fail
>  	but failed.
>  
>  It is possible to establish how long the stalls were using the function
> -tracer to record how long was spent in __alloc_pages() and
> +tracer to record how long was spent in the page allocator and
>  using the mm_page_alloc tracepoint to identify which allocations were
>  for huge pages.
>  
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 3bf55a5f9143e..4d57e9c0bf204 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -204,10 +204,6 @@ static inline void arch_free_page(struct page *page, int order) { }
>  static inline void arch_alloc_page(struct page *page, int order) { }
>  #endif
>  
> -struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> -		nodemask_t *nodemask);
> -#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
> -
>  struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
>  		nodemask_t *nodemask);
>  #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
> @@ -272,17 +268,7 @@ struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
>   * prefer the current CPU's closest node. Otherwise node must be valid and
>   * online.
>   */
> -static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
> -						   unsigned int order)
> -{
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();
> -
> -	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> -	warn_if_node_offline(nid, gfp_mask);
> -
> -	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> -}
> +struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order);
>  
>  #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9cb3f1665b41b..026f33f217036 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5427,7 +5427,18 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
>  		set_page_refcounted(page);
>  	return page;
>  }
> -EXPORT_SYMBOL(__alloc_pages_noprof);
> +
> +struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
> +{
> +	if (nid == NUMA_NO_NODE)
> +		nid = numa_mem_id();
> +
> +	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> +	warn_if_node_offline(nid, gfp_mask);
> +
> +	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> +}
> +EXPORT_SYMBOL(alloc_pages_node_noprof);
>  
>  struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
>  		nodemask_t *nodemask)
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index af83764788b96..2058cbdca56e7 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -244,6 +244,10 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  	alloc_hooks(alloc_frozen_pages_nolock_noprof(__VA_ARGS__))
>  void free_frozen_pages_nolock(struct page *page, unsigned int order);
>  
> +struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
> +		nodemask_t *nodemask);
> +#define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
> +
>  extern void zone_pcp_reset(struct zone *zone);
>  extern void zone_pcp_disable(struct zone *zone);
>  extern void zone_pcp_enable(struct zone *zone);
> 


