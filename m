Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9586FEBFD22
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BB26B0089; Mon, 13 Apr 2026 05:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C3B6B008A; Mon, 13 Apr 2026 05:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D8D6B0092; Mon, 13 Apr 2026 05:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF81E6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:19:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80975160CB3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:19:52 +0000 (UTC)
X-FDA: 84652985424.15.04DBB93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE978100010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:19:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bNCjDuM+;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKxSA0n9kVvCKpIgcv8zNS+kU9VEMRkmxLm1MYSpV4Q=;
	b=3bscHPT72e4xluS1/YHItjm3hzzv1+xOo0Jemk2VEkqJKfqx+h8MPti8HoNZEb0EWIWyz3
	GTjnuhYqOkaXLDb0+rcrjkPI6JI0gtELvBRS6B8o/Xsiej+fItV8DHIGCimmI48ipc2/oQ
	CR0rir6AKSUTsLreeXMDi5st+EPUNqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071990; a=rsa-sha256;
	cv=none;
	b=EDPtGhvJM8qHDHG3gFH2Nl/OQ+hWnJxTgHoQx1k8C+ERh8RC56phUok4CNuraCSyjtw5fT
	TS6otyNqsxdb4AFQXBIobYILW90HJFngfmGJRvqIaBO86lCIxKLnTYRc09EPLHYw2zXQBP
	BGhuFDjfrfz1F+Y9HEQewtyjHH0Cfrs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bNCjDuM+;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47B2C60180;
	Mon, 13 Apr 2026 09:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A895C2BCAF;
	Mon, 13 Apr 2026 09:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776071990;
	bh=2kr+EhMgMQkHVA7iNdaf14YX9cd4ab4OO+SsmIGEbRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bNCjDuM+e/DnQ3gdIUmaMsSzHbtpAX1fNz8FDMsrhCBz/Zx234Yd2VLPGUFxItza8
	 AGkMDnomVyAINuiid0nMJwgViqv6xnF0ti5KODcY4pyAGB0gvsbzVtAdAUc5GmMZbE
	 4k1neV8aNrD6Lpn60QOG7yrpG4PiWQyK1Ti9YnbZoMEYnDCKAVSCXhsDBQqsR3+UWr
	 pxPdV/KIztvfBFdZiRSYDKR4uD8+uS7NbfzM3NXA+lJTQGp1iZtA8VqoX2Of8xzSq1
	 Mtx68qhJuw2Bg363XiG/wIQEmy4oZ5Zp99fI74eCFh4iiBcHG3vA+W8vlfZZ4hwfwX
	 yQuDf3Qdn3Rwg==
Date: Mon, 13 Apr 2026 12:19:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
Message-ID: <ady1LQMN1xhPGcuT@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-2-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: DE978100010
X-Stat-Signature: yh9dhtt83yipcba48pweg7faokqsgd5e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776071990-966633
X-HE-Meta: U2FsdGVkX1/h2FVxcT/OjEkvyKzrFQ/FjSYZ14sURCFN0ZiRowiy4t5n4/kqoRcRkhZxg88+YOD+f/RNyez1+OdQonqECh6CmhzVIi5TpL0v4wUq/qHDBaiu19MuILXTKxoZT1KAIQlHH7IUC+64/yL3MpDvUXvd8cfodbHHV2ZYYrRKH/HlcIPevSwkIUztrnupqxqYh3aNPnbcDyNuqkSdAd9xuxEi9IjtF2efh49o1oeZeRrqqX2Dg5Bwd97wctuRnqz9Ae5QVBtJVqNw94KM5fLgZhFpBeRv6wDaF34ke0cDpZlzi0F1UH99+xFs6pNWBqGbZaYSq/zTKb32ieasi+g34U7vYEmMRT1QgjrmNDjQCanF1eZ3Xz5GC+kVthPoaer0QmF6HOthf6L/UtS7xMH3MgjEF5yQV8Ek+z/ujw2YMChxVzxcQJKpSohj9ZJHCvTHz7t0r0+4bgqOlUYm6pzcDbzlHGKeyoYfBOaXebaDhCtPD8eE05ix2KjAw0LD9JeqoEa4W8r6h32aDuQ5hGwC+n+5+to6uPYKWLbreP2D0KD+SX5CDu9a8Sqm8Sf8+7FIHdmS+TvH2u1MWtOAcK9XE/OvX4qR6Z+uqvV0n2c8JGHMqX3smMWcyFRlz9ITRUhbuVES+nzXj28YmSCezZUH+ZCjKW0E74kySIiMidd0ugdafyJaXp8OgVTY4cDDBUHYLfzHPcFeY4KnW/WytpQlupiov5zor21qzlHykB4IjCyt4QWp3XMW73dMWDWcip7aoBQaaoieUCGSK/d0LvGnE2n+8Cd5yQOh9c1YT0RUjF5PUWBaJiF2v6sis99WH+l0HPdAmCWqiZ8cQLH73fLyybAFmqbXcXzbnG9ZaZuEkzruCOO7jTOPJKia0iB4rUDh6P1DEQHnv4yUC/D3ssTACMJGlFiJyOdhsM94TdwLnXDEmok4gGsqHmhCn0WXQRB7BsiB76If4vx
 UNo+63LQ
 MmYEibTCTHhpZFcbPx3EW9qs837gU6753Ntg/J0pVmTOjjsoX0eWe2kGc2jdhttNz7b8/mhYS+lYa/AMRIJoanSMVaKxrV4PC0APGQhTGlqAqZxK5bxP72hhq3VoPYgCKLYJh8zTh32fXShETKudbik248ZpTNPj1PS0hdeVMSQTHgga5PeDaDLqwQQklch7PixAtc/7OOeCeDw6mxb0CScQq+wZ0sT9BLJOQKDjkzeqMewxcBKchXAbCbG78EH0Cf5jv4nnX6b3G/R01f7oi9T5svg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:51:52PM +0800, Muchun Song wrote:
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> approach introduces an accounting imbalance.
> 
> Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, section_deactivate() unconditionally decrements the
> vmemmap account. Consequently, a failure in populate_section_memmap()
> leads to a negative offset (underflow) in the system's vmemmap tracking.
> 
> We can fix this by ensuring that the vmemmap accounting is incremented
> immediately before checking for the success of populate_section_memmap().
> If populate_section_memmap() fails, the subsequent call to
> section_deactivate() will decrement the accounting, perfectly offsetting
> the increment and maintaining balance.
> 
> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/sparse-vmemmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 6eadb9d116e4..ee27d0c0efe2 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -822,11 +822,11 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>  		return pfn_to_page(pfn);
>  
>  	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> +	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));

This logically belongs to success path in populate_section_memmap(). If we
update the counter there, we won't need to temporarily increase it at all.

>  	if (!memmap) {
>  		section_deactivate(pfn, nr_pages, altmap);
>  		return ERR_PTR(-ENOMEM);
>  	}
> -	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
>  
>  	return memmap;
>  }
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

