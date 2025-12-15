Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36B3D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 03:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD1E6B0006; Sun, 14 Dec 2025 22:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA48D6B0007; Sun, 14 Dec 2025 22:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1A46B0008; Sun, 14 Dec 2025 22:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD69E6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 22:57:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 591C55D5E8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:57:53 +0000 (UTC)
X-FDA: 84220346826.17.D33CFEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6876EC0002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:57:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B46PDd2Y;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765771071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vP69h/tudeYRvb+VTJJItOX2+7RkyUHJiC5JDYMONtA=;
	b=khPwhajlxUB0EI/vCZMYvQP+DcbdUrXlARJ0n/eLOYS7FX1VYyMv8zNT9MovBZqEeQSTFf
	DfcbOBmOQuk4R2ddSf5frVE5fqF5HBKaNZfwr26y11YxVGc9YAmoixrDrPIu9J5PghDhYh
	yKmggk+QmtDNUIJi+VTrvdGZn1KUDUI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B46PDd2Y;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765771071; a=rsa-sha256;
	cv=none;
	b=0FC51i+umc2PYFtCyTrZIX1h0horo9P+jE4In0irl0mn/EL5Pf5DzCuQEhUJtdx07PFxxk
	dOwsZw4qPSTsUwkVN4wVShydqmCFJOXHgORCcnJEZ/HolVzljGZEQy2Iw5wBKuo6QmACy+
	6Pu4oqVnfIxphQCIh7dAmwoRoxYgsgo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765771070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vP69h/tudeYRvb+VTJJItOX2+7RkyUHJiC5JDYMONtA=;
	b=B46PDd2YyxM7LSdFZjjHDuynz44Sx/o5aE6w1urfK4fx/oBxGKsRFsKtH1PCl+eIh4NHey
	BbDKBriXEJI5AnGyjt9Fyb0Ot+kUDkNVnCRGi3rrDqWNYOjptTse01KJZVbjK9fRrpsVKb
	6sn3WgXTMl5sSsvX6f5/lqPvdKeEJJY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-_gwCH_5MOje5wl9DGQUINg-1; Sun,
 14 Dec 2025 22:57:44 -0500
X-MC-Unique: _gwCH_5MOje5wl9DGQUINg-1
X-Mimecast-MFC-AGG-ID: _gwCH_5MOje5wl9DGQUINg_1765771062
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F6131800451;
	Mon, 15 Dec 2025 03:57:41 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E0B230001A2;
	Mon, 15 Dec 2025 03:57:37 +0000 (UTC)
Date: Mon, 15 Dec 2025 11:57:33 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 09/19] mm, swap: swap entry of a bad slot should not
 be considered as swapped out
Message-ID: <aT+HLZJRgmvca7K2@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-9-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-9-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam02
X-Stat-Signature: fahkrhzddp5z5fk3jymb7zraap9b6sk4
X-Rspam-User: 
X-Rspamd-Queue-Id: 6876EC0002
X-HE-Tag: 1765771071-927437
X-HE-Meta: U2FsdGVkX19NcM+ycgUocDFRb67517s2fuDElFuvBbPTooa7E+MuS29JLBG5TskbcMa5JJEVW/z7dmF6/QfJiqNzK2yhMIsBILzTEfJPzTon9utr+8OZdqvr+0vfDmAEQ5rZk9nIzXVHeCz4pc9+oEYXyWjweNltPBg/a4EY6lqaU/VsHTrl6qTJNvo2sRB2W6+LTqrL/VWF8Xa/H/PQSZOYf3VPdPMCuljF8RRG+qWsO1ccGaj4v85kCmD0Y+UqXjqO/iaTvEiqbp26eEjr+0nE/X01xjsYSBoEHVccTJViv4DKNKF8LNFPX/nU5YuvZuWOQFHCuaLZ0kQb9PXiDJJuJzCIp7EU3oszSBcN/n+1Vg85U3Eeb28K4RaN9kWbGn8O6kRP2XTMc49w98sfOPrwa48QooHmFTKfI1foLVsKmvqBC1IbYB11AkhMmBc0LmmhRMz8gNmZHT7jKTyaYEO4LFJfhbxRDJ5XgbjyycYpaOGQw7Uyhhh3y2fK8wr2qjXuLkryqVAWHjmZiQcw6Z87Fb/xh5Dp0g5WXPgFeKA/y39RUEL48fq9IzxCNrxCbIOFQ4b6QW/Vjnxka0Y+g7wI/sUNmHdo7v5Jz1BqQux0sfAGfUPimrDxBgWan554rWK2E73rEPae4YEiiBN/5j7VacTUSQ9astThYKr4XtDcbHLybduO2lSKuTP3mJ6Bv1B+5ZiTY3B+mrG2slBSMcfz3BCH8WWWT0uyBcgn0p79VAQL6ywRBihb9bbMgFZ/mmBDwl2CgXoOuyuiU3EPohVSuViCe2j7pLmV0UR8AXkf4/5Bt9i9xqO4IipyfD98CLuh7Afz2l7od30ZU8DpBoADiHv0Asx2M3MAIVjzBAgUsevAlO6ME3WHyd030gEVTgnSwMfYVkr44KD3esb/jbvPVwWKiLqKQ2LTrBuYa8Tg/k8LGeenganVqjct9yTDBhoy7mRKLZYvk7uxqTC
 MyOgKYMw
 iRvxZbc07nGrCArjgpn0yC1FPAo7x/nCK5bMdXz2VlF2Fj8msHxKlhM2siJADq0WgWIceQfjnW00nJUg1wUJezb3+Zqc5cq5StUdlnWBSQKJqto0ASUjGn8u12ovydgjNPf++CP7Cn1AijUBr6TBIWVt5/DFvI+E4+GWP+9jmOpgEa6C/uAKv6orx0C2NXiCodUm9xvR6LcWA+0ZFpK8YUxZFoejfNDZ+3Ophsry3k8MYML6xMSxcyx/3LbSWyqz5ADBq96MRWS7XBL3EE6G2pLumZ2v7p6R9PetquPo3WWQPBJZbyPNfe9r3ZALR84pTsD0BmoR+izdUd/gCdln/jVq7fSI5wxOQbuWZHqJpDjCyBL54ExxmWSTSVumEpUovcHmesFD5DonisgE0gd5hoi7IpgVjSQWmArRoznZGZcUU7ZtdD1zn+ueHkbKVXa/VPCnbiKCjN1pr5SM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> When checking if a swap entry is swapped out, we simply check if the
> bitwise result of the count value is larger than 0. But SWAP_MAP_BAD
> will also be considered as a swao count value larger than 0.
> 
> SWAP_MAP_BAD being considered as a count value larger than 0 is useful
> for the swap allocator: they will be seen as a used slot, so the
> allocator will skip them. But for the swapped out check, this
> isn't correct.
> 
> There is currently no observable issue. The swapped out check is only
> useful for readahead and folio swapped-out status check. For readahead,
> the swap cache layer will abort upon checking and updating the swap map.
> For the folio swapped out status check, the swap allocator will never
> allocate an entry of bad slots to folio, so that part is fine too. The
> worst that could happen now is redundant allocation/freeing of folios
> and waste CPU time.
> 
> This also makes it easier to get rid of swap map checking and update
> during folio insertion in the swap cache layer.

Will swap_entry_swapped() be called in other places in phase 3 of swap
table?

I checked the code of the current phase 2, in all three places you
convert it with swp_offset(entry), is it necessary? Why don't you keep
the swap_entry_swapped(si, entry)? Surely, this is trivial.

mm/swap_state.c <<swap_cache_alloc_folio>>
if (!swap_entry_swapped(si, swp_offset(entry)))
mm/swapfile.c <<folio_swapped>>
return swap_entry_swapped(si, swp_offset(entry));
mm/swapfile.c <<swap_free_hibernation_slot>>
             WARN_ON(swap_entry_swapped(si, offset));

> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h |  6 ++++--
>  mm/swap_state.c      |  4 ++--
>  mm/swapfile.c        | 22 +++++++++++-----------
>  3 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index bf72b548a96d..936fa8f9e5f3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -466,7 +466,8 @@ int find_first_swap(dev_t *device);
>  extern unsigned int count_swap_pages(int, int);
>  extern sector_t swapdev_block(int, pgoff_t);
>  extern int __swap_count(swp_entry_t entry);
> -extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
> +extern bool swap_entry_swapped(struct swap_info_struct *si,
> +			       unsigned long offset);
>  extern int swp_swapcount(swp_entry_t entry);
>  struct backing_dev_info;
>  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
> @@ -535,7 +536,8 @@ static inline int __swap_count(swp_entry_t entry)
>  	return 0;
>  }
>  
> -static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
> +static inline bool swap_entry_swapped(struct swap_info_struct *si,
> +				      unsigned long offset)
>  {
>  	return false;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 8c429dc33ca9..0c5aad537716 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -527,8 +527,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
>  	if (folio)
>  		return folio;
>  
> -	/* Skip allocation for unused swap slot for readahead path. */
> -	if (!swap_entry_swapped(si, entry))
> +	/* Skip allocation for unused and bad swap slot for readahead. */
> +	if (!swap_entry_swapped(si, swp_offset(entry)))
>  		return NULL;
>  
>  	/* Allocate a new folio to be added into the swap cache. */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index e23287c06f1c..5a766d4fcaa5 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1766,21 +1766,21 @@ int __swap_count(swp_entry_t entry)
>  	return swap_count(si->swap_map[offset]);
>  }
>  
> -/*
> - * How many references to @entry are currently swapped out?
> - * This does not give an exact answer when swap count is continued,
> - * but does include the high COUNT_CONTINUED flag to allow for that.
> +/**
> + * swap_entry_swapped - Check if the swap entry at @offset is swapped.
> + * @si: the swap device.
> + * @offset: offset of the swap entry.
>   */
> -bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
> +bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
>  {
> -	pgoff_t offset = swp_offset(entry);
>  	struct swap_cluster_info *ci;
>  	int count;
>  
>  	ci = swap_cluster_lock(si, offset);
>  	count = swap_count(si->swap_map[offset]);
>  	swap_cluster_unlock(ci);
> -	return !!count;
> +
> +	return count && count != SWAP_MAP_BAD;
>  }
>  
>  /*
> @@ -1866,7 +1866,7 @@ static bool folio_swapped(struct folio *folio)
>  		return false;
>  
>  	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
> -		return swap_entry_swapped(si, entry);
> +		return swap_entry_swapped(si, swp_offset(entry));
>  
>  	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
>  }
> @@ -3677,10 +3677,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
>  		count = si->swap_map[offset + i];
>  
>  		/*
> -		 * swapin_readahead() doesn't check if a swap entry is valid, so the
> -		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
> +		 * Allocator never allocates bad slots, and readahead is guarded
> +		 * by swap_entry_swapped.
>  		 */
> -		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
> +		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
>  			err = -ENOENT;
>  			goto unlock_out;
>  		}
> 
> -- 
> 2.52.0
> 


