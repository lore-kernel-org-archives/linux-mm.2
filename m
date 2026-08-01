Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00E5C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9686B6B007B; Sat,  1 Aug 2026 10:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2AD6B0088; Sat,  1 Aug 2026 10:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB306B008A; Sat,  1 Aug 2026 10:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F18F16B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:13:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73325A168D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:13:12 +0000 (UTC)
X-FDA: 85052892624.02.B033E26
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF1A9120007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:13:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GR8qNynB;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785593590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBNtXuv05JvF8EzNDyyEZc/1B79zvG0gadCVGtLxbz4=;
	b=As/oOe/8PipwRxVovLFNBd02nv9GoYxpdP5xLD30njMPe1u5NnJLrnkVMBDzJjRrylAfTu
	scEa4t2XDfYuUZM7AZoIVwORuMXd5AeSG1WJH8wTEgAJEaWzXewnOJNvWnbh/j90TnReAh
	yI30RTt0tY/XkE01ydm2NFHYoq+ITFI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GR8qNynB;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785593590;
	b=nwZ+yN5alUtrC88PPNCluo7NwuKTIfBdClZ47wXQc7AC/msw0wrjKCnux5UMJorp+yq83f
	o0Hu2qZdAHO+SwdkqHRjZR83PArH+/K89mPUnj9hXMe7fIMkl8zTuHMbs81qq6vKaF7QZG
	C3a5PH0jVqU8WKi3i9DS+swaUlT3RGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785593585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QBNtXuv05JvF8EzNDyyEZc/1B79zvG0gadCVGtLxbz4=;
	b=GR8qNynBgqn9w1313L6f1le25ZwKgBwEypv3oBjasQiJFX7SVThH/j7rHKhKtFQSVAs2SG
	vaHGSdJArVyihEp4BctuMX8sufRqZ3Chv4Jpx/rPbQxEJ+8vgpluXgyOBsedb8/pn8vDha
	wjBq8eogjybroq6KHwJNQcGTvfLWvOA=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer comparison
Date: Sat,  1 Aug 2026 07:12:57 -0700
Message-ID: <20260801141259.627022-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF1A9120007
X-Stat-Signature: zj56nq4e1xuccsahb1fpumqfkiutcq1q
X-HE-Tag: 1785593588-379014
X-HE-Meta: U2FsdGVkX1+ElryRJQv6JsSW9ULGGG8h8JdeUI2Sz+WRoUwFWEv1i7vSrFEJ89zOCNUUsm6PumVLhpkokDKu8H2hr654EGs4e36v3vZQ6+Z7fIq5OK1kDNjdPoBg6Lp63BVKCGY3zl4m0v7A26m8nUx1T2Qh1PQjbbxLoKlY60mpsxkWpl3C2iMSnYA0fc7X5JvkVxaLjaFLqV7/I6xJp+MFac0iUR3VM+ggIqRRluh16o3nn/ntHTOd/SM98ZupsDQXY0vvAw/8/dUtREW7KcPYFZ7Vz3+wbMz2pj5QZ9jwOTdxsLmz7OqGiYQ76sCQGYder+L/9YkFDqLUHb4sBUMR5XrUyjRNd2U9diojIMkTrFrhb+4LYezCKI639oA9VbE/m0cFzJhjoyHTaxOQ8Q5WgRk1zTh+ndu4s3yy+8SUi8v14ccnNUaihUJ6fYglYlBd5GCb3m4cglEHqArr0AGqIaG/YqemyqJhqP36/0+S/o6wJNzYK0at4hy9i71at/iUbs3yEiY3WQF0kNkvwDTFJdubwl6n7rA9326BuHppuMI1gbdEB5LXLN3nky9Yhbx77VP4pjjoy/0xw95uNjWjPmNuJg+rAGKWimQdV+Yyp63DW2PtettArX+68cUXBgjztx0AkLnq6YFduy8QEsWwt0/vZAnOwSgC2lYc11UVuIqo/ajqFGJ9HUWd8pSU8xdk98XB3bpysSjLAInfwZnS7CWbA0RFTyCv+Deu0yvDjg13Lj5yVAcr5Pt/OcqzUbsue009wNhCAqW5qlYT4yke1Z7V2BtJ5NjIdn5HaLDqdF4y5F34ScuGyfArsjYJMZ8RTf8cw2FcgxaPe4hh63zyL2Nay7A52NV28oUpHiC5BIAUxY01xJ11cutlYlP9tBx80iA4OBwyz9ALG48QlczyXWmpLO5I/XBLKeFFskQl811zkkNdg3Q0ThmLwvz8R/gfs2RkkmygnyLb6p8
 XEzxHCwN
 AthVWS4P3opMu1yYC4IDt5BLJzLvievtCJo8WrFBhnhuUSpiFNZQspsV+1GAYn5RSRLn+wyjjXOg40fxOVGFpPFtsa4ktjNLMQIE5cEGRIcqhdvym1ltx2PpFY8xgIQPzslcH0r5PsnhgQYd1weKsYHbsKt6yWG3KvGa9P3HSEs3UIou3V1je52RlGUELcpZd8yvjfC1tKm1q4HkzfLscjFxKSPB6a8lsrRjD3lY3wsZUA1OxyeCmomwoB87DwEgWoodZJSwbVHt/TsqQb3g9N8fhbX+lytkwIIXhfVGNDZc/FgCtK9w3GlMRTciZK/4UoTke0YId8Dxore0xLB2PFalD9+gUs8o48RCA8HggVLFMLdJup8sEa4cyWDL4tv88lTFhjqzrhuEWdxMSISK3eBAcaHuyBOhJooJDmLltjE+uDYEtgb1FQ1Crrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:24 -0400 Zi Yan <ziy@nvidia.com> wrote:

> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
> Replace it with zpdesc->zspage->first_zpdesc == zpdesc. The check,
> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
> should be negligible.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Minchan Kim <minchan@kernel.org>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/zpdesc.h   |  2 +-
>  mm/zsmalloc.c | 15 +++------------
>  2 files changed, 4 insertions(+), 13 deletions(-)
> 

create_page_chain() sets zpdesc->zspage = zspage before assigning zspage->first_zpdesc,
so LGTM.

I think the assertion in get_first_zpdesc()
should be changed to

VM_BUG_ON_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));

in the current check, we are checking

zspage->first_zpdesc->zspage->first_zpdesc == zspage->first_zpdesc

which is just testing the backpointer.

With the above VM_BUG_ON check change, please feel free to add:

Acked-by: Usama Arif <usama.arif@linux.dev>


> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
> index b8258dc78548d..4fd81c2e80769 100644
> --- a/mm/zpdesc.h
> +++ b/mm/zpdesc.h
> @@ -26,8 +26,8 @@
>   * with memcg_data.
>   *
>   * Page flags used:
> - * * PG_private identifies the first component page.
>   * * PG_locked is used by page migration code.
> + * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
>   */
>  struct zpdesc {
>  	unsigned long flags;
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 8204b76f78308..e8ef227624efa 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -290,11 +290,6 @@ struct zs_pool {
>  	atomic_t compaction_in_progress;
>  };
>  
> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> -{
> -	SetPagePrivate(zpdesc_page(zpdesc));
> -}
> -
>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>  {
>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigned long obj)
>  
>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
>  {
> -	return PagePrivate(zpdesc_page(zpdesc));
> +	return zpdesc->zspage->first_zpdesc == zpdesc;
>  }
>  
>  /* Protected by class->lock */
> @@ -848,9 +843,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
>  
>  static void reset_zpdesc(struct zpdesc *zpdesc)
>  {
> -	struct page *page = zpdesc_page(zpdesc);
> -
> -	ClearPagePrivate(page);
>  	zpdesc->zspage = NULL;
>  	zpdesc->next = NULL;
>  	/* PageZsmalloc is sticky until the page is freed to the buddy. */
> @@ -1001,8 +993,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
>  	 * 1. all pages are linked together using zpdesc->next
>  	 * 2. each sub-page point to zspage using zpdesc->zspage
>  	 *
> -	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
> -	 * has this flag set).
> +	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
> +	 * other zpdesc has this set.
>  	 */
>  	for (i = 0; i < nr_zpdescs; i++) {
>  		zpdesc = zpdescs[i];
> @@ -1010,7 +1002,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
>  		zpdesc->next = NULL;
>  		if (i == 0) {
>  			zspage->first_zpdesc = zpdesc;
> -			zpdesc_set_first(zpdesc);
>  			if (unlikely(class->objs_per_zspage == 1 &&
>  					class->pages_per_zspage == 1))
>  				SetZsHugePage(zspage);
> 
> -- 
> 2.53.0
> 
> 

