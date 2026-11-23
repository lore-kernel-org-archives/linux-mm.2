Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C9F606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dyEuKLag
Received: by kanga.kvack.org (Postfix)
	id 57A526B05B8; Mon, 23 Nov 2026 06:14:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5245C6B05B9; Mon, 23 Nov 2026 06:14:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412696B05BA; Mon, 23 Nov 2026 06:14:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15F146B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:14:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2C1540886
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:14:09 +0000 (UTC)
X-FDA: 85466124618.22.86AA7C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC1E1C0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:14:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyEuKLag;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795432447;
	b=7osFBz9E4o+YqxRTcFZHTUN+7DSd32rkh9zhh4ZTE6qT1Cg6qS2shsENK78RIw0sttGOZ1
	VBRGiegqSeglU/eSUa3n5C/yzT7OF+hCM9Va4hJ1OsS/DKPmlqj52c9WQqDxAsjR406MkB
	y8mwb/S9cJ/9kUFmlEEDE8pnEI2m6N4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795432447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Z/EdrARj8Rd8fEzRvh1S3d0UV0AZLpCdBc43fW6xRI=;
	b=0pYh/BXJhlmOMoANw5nqynvhX4HayOFAgm3Ix4WTsCr2d3tZp93zD8eL7H8N14PUAMJ1j2
	AHqV5kjMKon3vmxlV4Xkq2kCyJ0Cz70c8w1IK2shZ89juqdym5lxUM/5oiuMnewNfqa3HZ
	OTKoDIAeaXDrL6mjjOQ6x2Tj7MkxwLo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyEuKLag;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECEC244438;
	Mon, 23 Nov 2026 11:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BB51F000D3;
	Mon, 23 Nov 2026 11:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432446;
	bh=/Z/EdrARj8Rd8fEzRvh1S3d0UV0AZLpCdBc43fW6xRI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dyEuKLagWHdTe2lNdDfG/pW19V2v7BdnkfQX6t4XiFZLE235LzwHGuZKbpTT/pY/c
	 lxVLIsa+G2lt22qnmF69ah+3UpYuKCQiUSU9yjMSqtjjzKB3O62XCJ94lMiSj6a+Oj
	 hTkBx/U9mtkv3Lbi2L+eQvxnV4RSnfjZiO8UiuwjWzaHvBmOzBhbQzdMpR9WI3c1xV
	 j/x2CLDLE4DDc9rvo5cniGIp64Hqh4LjtsFp47jItyEfLIEKCFsDOY12YXdfgT46Tk
	 b1rZTd8LYSVaN1lj7yFxT1twoVhB9pYbSzNy54zCV2eNRB799rhawu+xG6t3D5lH4s
	 g0Sv2ppf1mj4w==
Message-ID: <8c929a95-92d5-4a81-9e1b-a3ac3f67cb90@kernel.org>
Date: Mon, 23 Nov 2026 12:14:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_owner: fix double decrement of stack count on
 unpoison
Content-Language: en-US
To: Nilay Vaish <nilayvaish@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@kernel.org>
Cc: "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119234804.1740734-1-nilayvaish@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261119234804.1740734-1-nilayvaish@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC1E1C0007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: b31xrbixkstaxapn6txttm6qto4b8aoo
X-Rspam-User:
X-HE-Tag: 1795432447-554067
X-HE-Meta: U2FsdGVkX1/wqLTfzt7ZT32dEbuMe9nb/EPiKbl1U324PiwhRMjfjUljndntqwqLH7Gw7t1knKkA1qloszO4b0+2FI5nHEwPFS2QkezpDNs7FgqSvhL92h8DTliLkUu7efDQ46+yOI8r/7d7H/4VvBv31E4YH0Bqli5JUGLfE5h3+5acvY2ATF5ThNLGA8rmYOcx/JScIyu2x7aRfQ7905KoGm7HUj9RIwBlYgMn3sNGcfcJl4ozR4EttNdAqjmkzTG+kT0W+Jf27sDuXWSIndcrX6BTEg8CKNbp96WCmbiWYfV6Zn6iN8DvQ9gGa78y0TNpOfzOv8K5YgWqSCHprGuiJg4JB3HAyHtaUQSXp3rM5Txh2g+ciFg5Mr97gM5VvZsr5Xx66PgcOe9O/FS7IA7xMoGp7oGiJfaFoVPZeolr/8i+JVV1RrB/S8XrccPRq0vftg6Gc/y3QdiEQv6pITAEoNNvgAarWvyMi0DWdrUBNTEWxGJJrTa4Yg0EREIPXQxu5GDZetPHT5DHWJYvLJ7oiNgJY8+tGqqTC45mHpxYYlVuZAHiCRXUO1bRUgjj18u242IUCm9bmgEfop/UZIeATpCzRAVhBklAMGQMrGOzFcnQXXnCIsCD8TuZ6DGnFi3jg4YFgRniFyGXeCCZRyYclrPj/GIwpYoI0wklzGU0JMnH3Ltkz394cvqLchxNHJbNQW5WsLveO/q6PQTLxeHKw60TY5nBn2NL+WT/+jd3/hBRFa5cWjVyOHlsrAn7wjHMM/J0CU0dOibjsBVF1kL2bASmdU8783dQzmtz2nrCbMt+GdIJBxrHh5e1NuV3ucscpB8ZyX5Jc7Ze1RczjcQxE+/Cfe3BrsgeR/KGCwcCMujh9NPzepT5wLgyZlrXNlMIgBLpUNtylZVqCMPfxzGIJL+LGSl8S72fn0I/QhcI3u4ViqPhfuc6JaBSUMkUke9DY5fOheTwbyPXDTY
 Til+zmFN
 s0rNfjvZwmjoxzHmAXi5Ia0GxxB6+Fhdhpd3SaGRuFeWsTqb28yphwixD8SnDeiH9QZqo4dT64JGfmVzH8pZb7C/IsEoqO7L8WfiTjsJSpk+9DYiLGl4YTHmjGk5CLncZQSHW/C5cM6rtAkafnMhz6X7u9JFauXlDVxQkefdeN9z0IpoI5UFROl9M8Uthv+IdNSMTuPvakyBanen20imb3PdOzzoGZtxktNT3v3BAAVeAodYyd+vcXBVFvNK1S02nStSk8FqujUE5ULVaT/hIoBuhh/UfWnTsMkyeJWbvFDl0hv5qLvP4yv+VE7fKeD6aGiGv4y3+WdJKdd6z156+1/ZyPec2Jn539vKrhOD449p2fzx5D7E8dcYe8TOG4TNOEdjWh2PhNCRBE9tyQol82Md5tzcJcOdxzDQwShHhXpaNG36mu55EZGfBnhYQC0mQHtEmzV+pg4dkQItHJUQKKuyZYGqUS0qSyRS5kjBkG7OHUA2o0PhuuuV3TeFoNNuOaZRnL0KQOxxT5tp75VShVrtrWLuVpCCrvrWXZ3qMaMzj6foHXL+SUv1PUhasAqWZzBPngd3B2VKsnEDuruk2R3ZOJWpjDehPOBvuSi5suVlIjKo1b1IUFJwGDfqfVSsQ4421oV7RsSA7jxElRAlzmR89m/z+oP8aLWqtx2Bq9kTsQOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 00:48, Nilay Vaish wrote:
> page_owner counts, for each allocation stack, how many pages allocated
> from that stack are still in use. The count is incremented when a page
> is allocated and decremented in __reset_page_owner() when it is freed.
> 
> A page that is hwpoisoned while in use and later unpoisoned passes
> through free_pages_prepare() twice:
> 
>   1. On poisoning, the last reference is dropped. free_pages_prepare()
>      calls reset_page_owner() but, because the page is PageHWPoison(),
>      keeps it off the free lists.
> 
>   2. On unpoisoning, unpoison_memory() drops the poison reference and
>      free_pages_prepare() calls reset_page_owner() again, this time
>      really freeing the page.
> 
> __reset_page_owner() decrements the stack count both times, although
> the page was allocated only once. The first call clears
> PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.
> 
> If this drives the count to zero while the stack is still in use,
> stackdepot treats the record as freed and warns on every later
> allocation or free that uses the same stack:
> 
>   dec_stack_record_count: refcount went to 0 for 92274844 handle
>   WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
>   Call Trace:
>    __set_page_owner+0x110/0x290
>    get_page_from_freelist+0x1225/0x1440
>    __alloc_frozen_pages_noprof+0x1fc/0x1b00
>    __folio_alloc_noprof+0x12/0xa0
>    alloc_migration_target+0x81/0x1e0
>    migrate_pages_batch+0x1f2/0x14c0
>    migrate_pages+0x9c3/0xca0
>    soft_offline_page+0x189/0x570
> 
> A single soft offline followed by an unpoison is enough to trigger it,
> because the migration-target stack that the offlined page is accounted
> to usually has very few pages.
> 
> Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
> was still set, i.e. only the first time the page is freed.
> 
> To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
> offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
> each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch
> the first cycle prints the message above and 2200 cycles produce 6597
> warnings. With it, the same run is clean and all stack counts return
> to their initial values.
> 
> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

Applied to page_alloc/for-next, thanks!
It will reach stable eventually, doesn't seem urgent enough for a rc fix.

> ---
> v2:
> - Expand the comment in __reset_page_owner() to explain the allocated
>   check (Oscar)
> - Collect Reviewed-by tags from Jose and Oscar
> 
> v1: https://lore.kernel.org/linux-mm/20261118212819.403059-1-nilayvaish@google.com/
> 
>  mm/page_owner.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 02bb304b53cf..09a3c2958079 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -320,11 +320,13 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  	depot_stack_handle_t alloc_handle;
>  	struct page_owner *page_owner;
>  	u64 free_ts_nsec = local_clock();
> +	bool allocated;
>  
>  	page_ext = page_ext_get(page);
>  	if (unlikely(!page_ext))
>  		return;
>  
> +	allocated = test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
>  	page_owner = get_page_owner(page_ext);
>  	alloc_handle = page_owner->handle;
>  	page_ext_put(page_ext);
> @@ -339,8 +341,15 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  	__update_page_owner_free_handle(page, handle, order, current->pid,
>  					current->tgid, free_ts_nsec);
>  
> -	if (alloc_handle != early_handle)
> +	if (allocated && alloc_handle != early_handle) {
>  		/*
> +		 * Not every page that gets here is still accounted as
> +		 * allocated: a hwpoisoned page that is later unpoisoned is
> +		 * freed twice, and the first free already cleared
> +		 * PAGE_EXT_OWNER_ALLOCATED and dropped the count. Only
> +		 * decrement the allocation stack's count if the page was
> +		 * still marked as allocated.
> +		 *
>  		 * early_handle is being set as a handle for all those
>  		 * early allocated pages. See init_pages_in_zone().
>  		 * Since their refcount is not being incremented because
> @@ -348,6 +357,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  		 * their refcount either.
>  		 */
>  		dec_stack_record_count(alloc_handle, 1 << order);
> +	}
>  }
>  
>  noinline void __set_page_owner(struct page *page, unsigned short order,


