Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70143C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 14:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9146B007B; Sat,  1 Aug 2026 10:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFDD6B0088; Sat,  1 Aug 2026 10:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F696B008A; Sat,  1 Aug 2026 10:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3226B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 10:42:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D88B12032F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:42:36 +0000 (UTC)
X-FDA: 85052966712.07.E20C78E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65FFD4000E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:42:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NEVhQSZZ;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785595354;
	b=pJWDySNcIUQ8KK9ILKoBs/prU5TKG1KOOMSd/hyVYoaQG//c7+cnqhTUNKzrkR46Ft7jD4
	LKXnlKrDHBn3YWNYZvYWT3P7XSGs7cFMrBrBYWCn6kMyLmj77G3P3FG0y6SLwXJjXFCNXb
	ZlF/IWA8u4egVqQOXuv0KxvWXJDaG+M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NEVhQSZZ;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785595354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bAGXb0quOYyJBifFj3CMsobl7Wj528s8Q4pbvQG4r8=;
	b=XADjV2Izlmzw2CuecmbdSEOyUvNHzhOMh+ercKZ7whnB765ek2oFnFWkhJeXlQ5tUpLgEy
	Sbvy6gZHd/nF930duL7mAg4VuwyEOJf8jhivJWF97m3VOMJ6SCJY3Qqcg8VDsEKqrpaX2l
	iLchaaGQ8YE3pRs+F7UEK8kixivKf6Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785595351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9bAGXb0quOYyJBifFj3CMsobl7Wj528s8Q4pbvQG4r8=;
	b=NEVhQSZZKi4DShjfGxrZuPRqNtphOqe5pi5nbT5xk6bKbRruhnX8733czhr713IWW5JtNX
	lBIXPePnqdQ4ryvX+Ui/oO5FEIW8RXuUpYzDAhh8N6HVjtmRQGHRB2ii5QDX7Pypq+cifn
	JH9gGi4r4HorTfPR/8XI8D8vS+iUZ30=
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
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH RFC 03/14] xen/grant-table: stop setting PG_private on pages for grant mapping
Date: Sat,  1 Aug 2026 07:42:19 -0700
Message-ID: <20260801144223.1599317-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-3-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 65FFD4000E
X-Stat-Signature: 8ta837mtwy6mc5ozt3pp3wg8nnyptbnm
X-Rspam-User: 
X-HE-Tag: 1785595354-12082
X-HE-Meta: U2FsdGVkX1+P/qSoO2W7DdBDw7wIC+u7odxcXPXl6FSCA4SNY/jOgCz7NoXZvM1Hp1mkTwId7ANumhtreUdqbpa73Ehh6Q4UtNOLNhN54dXzbLSfw3aZMIBHN8l4PhMnf2FkW5xcbewjFpwwMDuh0+tSWcHvozupaeF8MJ+2E92uaXLPMl25fNnulm+ww92lk/41dN5f7YlmHFQrRIuA+9GJr5o0AHFMFhP0C8UMgbrXS0N6ZGpbMNKQ54A2owJ2ay916FFlJD8pvEKq9q9rneIWshbEd/6SnJm9Vy7BnMMMCxEpenfUkyq1xxXrQFRWeNd7H8nGEDiMdxwOsQZX6Jln4hCxQ/wTGskTA2zhbMTkyamp+9XC4522LyjiOsEHJQ7zZp3Sp7dXtWrnXn/X2rv+CI1i+X1WCEEUcyAKC3PXQc9slH2K7U742h8ENczjOWeYfZxSxghHc4XhuwJL2a2kExPW34eNW08zdlQ0+xIoICorbLbWqOvkHZrcfywTmOKL2DDvY4Pa1wrunObDkXD/H+0hSLWU3ZIazj4m1xYtvJ/tcpa7agtUkaTme+H4r5R+tUda6TNIztxnuzMvXHb4OSoEd5mREoHhCUwh62IKQcu6cqlc2aPhGLCXkP5R5XkAUji6EYODv1QtrDva9kGvKh5yvLJVCulinOSBM8O294wfs8lVIZuyH7QxBPV0DKvZ5czKJyf0crgKkzkIeuJckG/PkRIPDqcRrXD1iZ6w7vcIWRMo6lu65LQZjkaxHdaaFaex9CBYVCi8d7lu0GC0P1FjMMslIG0hreXDtXWECVg0gNuAvqQnyJdo5Y0uMaj4Wotc9NWhoVE67ZRxGKEB80Bz3euQHEQo/boRYqP3Fcwo7yoa6TW0BgJTkJ3ArLBFEfamOA1IFZMiIxZ3Nz41SRdzMwOmRBoAwRHHlXwSCJtKzz9dOCKVcIRLgczzQcFT6Kprcw8SKipetzE
 Mu7xkeJ+
 4NX/v+cALjeEOadlq9F+eaSM7tVUYZvz7RHVUdDtKY06SPSLaCO4wRBpWAlwFPTZ/7gOBR2lvJFn/pWq3KkcYWNd3FCt5YYZlWyIgXpZjI+TCpDnTFNxJh4uTDxJV2nxDVCMuEv2XZXZBUqaVBwtjgonch8c8oNeAgZ83/5yqxAtOclYPB601jIUc80Bo8etRUb/CFRBfllO6yn9IfGmsWgASAI+1h+9M64M9ojC+BeWu6ecCnJYP7bju1DpwHzRABpm47a1cAUYjLiMxV8gRNBwBKXVnYjPDVKqyC6LMbXHVxUn7jq+JZYfyBXTZTgfREHcdJsdicGtiZ2PxvxR/TWxJ3Bn1dEGEnDN7QmLY82zoFuWD3lVLIo8jPWEPjV+v83gun2CtQ0ATlcW0nw2AwFLdPCAvSP8OiPSVCIkkxWyPKkaDr+gJs6GVLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:26 -0400 Zi Yan <ziy@nvidia.com> wrote:

> gnttab_alloc_pages() stores xen_page_foreign in allocated page->private.

in allocated page->private "for 32-bit only".

> On 32-bit, a pointer to xen_page_foreign is stored; on 64-bit,
> xen_page_foreign is stored inline. Checking page->private != NULL is enough
> to tell whether a xen_page_foreign needs to be freed on 32-bit and
> page->private is zeroed unconditionally on 64-bit.
> 
> It prepares for a future commit that remove PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Juergen Gross <jgross@suse.com>
> To: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/xen/balloon.c     | 5 +++++
>  drivers/xen/grant-table.c | 7 +++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index e7f1d4ca6d753..7f47b0ad05607 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_lowmem)
>  
>  	__ClearPageOffline(page);
>  	dec_node_page_state(page, NR_BALLOON_PAGES);
> +	/*
> +	 * clear page->private before giving it out, since it might be used to
> +	 * store xen_page_foreign info.
> +	 */
> +	set_page_private(page, 0);
>  
>  	return page;
>  }
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 35f879dc5dfb8..cc348ba2e0786 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -875,7 +875,7 @@ int gnttab_pages_set_private(int nr_pages, struct page **pages)
>  
>  		set_page_private(pages[i], (unsigned long)foreign);
>  #endif
> -		SetPagePrivate(pages[i]);
> +		/* Data is stored in page->private on 64-bit */

On 64-bit arch you just iterate an empty for loop. Cleaner to put the
whole for loop in ifdef?

>  	}
>  
>  	return 0;
> @@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_pages, struct page **pages)
>  	int i;
>  
>  	for (i = 0; i < nr_pages; i++) {
> -		if (PagePrivate(pages[i])) {
>  #if BITS_PER_LONG < 64
> +		if (page_private(pages[i]))
>  			kfree((void *)page_private(pages[i]));
>  #endif
> -			ClearPagePrivate(pages[i]);
> -		}
> +		set_page_private(pages[i], 0);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
> 
> -- 
> 2.53.0
> 
> 

