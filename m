Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C274C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1796B008C; Thu, 10 Sep 2026 12:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162536B0092; Thu, 10 Sep 2026 12:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029BF6B0093; Thu, 10 Sep 2026 12:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C336B6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:43:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F05721A0526
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:42:59 +0000 (UTC)
X-FDA: 85198422078.02.5F85542
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EBBCB2000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:42:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM4Rexpe;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058578;
	b=5fq1jHHsoZJwsg1Kard6IJgtJm+Ffa9VLphdIzCfPmHa/03A/ec4FYPqVoUDnVmaScz7dZ
	xltkXts+guc8mMYYXn68T4F+eIcdVlttBTaOjWUbMCWvUHaMqS5B5OEZUeojorta2lmE1o
	3oVppUfaF4b1TDQJY1DPhnjyzDz+Mns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM4Rexpe;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+08F42gZ1mjtG948ilU+qH+waoqzEUJrlsSmxp12pg=;
	b=qkKIC8ufoncY08k1kRAsGzihtVdKDaW/F538jFMcP1A9+IbT0ZnIBeKGgttrQV3U9EBYkr
	oofZHgnVtfwPufqY5QVm5fJjU5gCtxxinpY4TZhGaBozT/ysLgSU5x+2blzG/yOnXcbhB+
	m87pZ+mugyeQeSR23cinnq3CnumGUGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2EA543434;
	Thu, 10 Sep 2026 16:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71221F00898;
	Thu, 10 Sep 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789058576;
	bh=u+08F42gZ1mjtG948ilU+qH+waoqzEUJrlsSmxp12pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MM4Rexpet1EC3bp1YtYeZzC56tuaJtGRAuZ8/GIyYZ2Xir+yKXmGtSbnNqXF+47nw
	 TOS6zdwW7sf02DREaOPyqmA46p92iuIMYrO/Y2IO2yp9LvPHW8b0/CpXbcFhzGSl8Q
	 YMAqVk0oT2a4yKaKVWR+ynAwEM5deGouJ4KgMAHM+ikgPT+XcTpEgmA9rn1u5GJO+Y
	 tFsapkTRrM05PTdHPoxqofuzqF2sa3esnAPdtxa3pty7HxbrOslL/LSXrEVnUK7jp+
	 h5gvOjY48XE1wXOGRm58X9nGJjIZpBvhZm+Mvzjo/YEIVOc21rD40RJdDDLVXvMLfH
	 YhJFxvmeOQkLw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5C10C198003A;
	Thu, 10 Sep 2026 12:42:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 12:42:53 -0400
X-ME-Sender: <xms:Bd6iagPViEKcMUR9L2vFUVYNdprlzxw9XOLW44LJ6W1KhqtQxQnhvA>
    <xme:Bd6iattXOdK7DFkC0F0nDe7b7nzqRN_1slYG7pnn2eTjabVH1i1lJVoXBOTnkDcYD
    yQHBBQge5ZmMFR65IoCw_QeLeGdvdGeOn7HeFsJIZo_eBj7htu3DsCO>
X-ME-Received: <xmr:Bd6ialInbQnB2AqOShml-Iu32fBNfjpfNiHw8KMCpB9T_FsL6DAUsXfgPRE>
X-ME-Proxy-Cause: dmFkZTE6jQ7+ezdJvg0JCOHdeYm98uh8QoD3ppKlDCRkHPBf90NB4jh+ryx62TK4xbeazW
    OjmkN5eot9viRbZ00CYgDBHT2oH+RH5aQCFDDcusEjlg36Fb5ctpKOdLx985wH/FQip39p
    T7ct56TymSBRJpKxvgkeX9MwBtQkzBLcy1It/iWo2GFSKP14EPKpuBcDC6NZBPjPGuOYSt
    gDaf9qR90/vzX/n4LPNTXJAoXyXdh9FPu33aE25/XhViK2AK9AjkA9McfHxKUYwZZ4cNQy
    L9J1ZGy+68s9a/50qhSiH99Xat/XVOrftxEw7V9RkHk0x0GqdIBAFNnw6YCfe96nIenPCV
    unI4se8nbIGD4Kq9IYLNhYyv87qSPRhN+Krgj6j273FqV5FEWJwwMlgm5Sz+45zLTVppmx
    gHvNV0/P+4vzXnfFkqMihWIDJuG3ZV6EBEqsa8ZNbqO6blwIo2VGujQcKnZ0KB8O1A4cZh
    9aVyRAJDPIwz5b4tC125/MeGSy186XR8QU31P4geQmSY4nJzZjY/iH6DhjfNoFwbPWMawa
    e5jKQkqOdLGPlpHmn82M4fAZGG4IXR1RdfGZek9O9ES1ZEMAINtyHU1UsXLyrbltnxGrWV
    KMFv8bBZJLT//oUQTE/4JmHaZi+S9YjPBcCpBWE6Rkuxj00ZtgLEzvfdjpDQ
X-ME-Proxy: <xmx:Bd6iajt_a78yf2WByZxPGLwSXjlyfvmDfqklZ3D-bRcriVOd6tjAiw>
    <xmx:Bd6iak311tPhcHMu11wJQRGm-Fk6zSP8hp2lUqWvrnseo5WM6kic7Q>
    <xmx:Bd6iaupl1jqCNcNt6L9n9QuK98czBLyQ7VsDoSscYztatIFYfsUShA>
    <xmx:Bd6iav6AfsE1iY-2vTfH3cPqIiNOLEowj4RO_MWGwntIFX9Y4OIZvA>
    <xmx:Bd6iap0WK4EpvFtPf4iclLgLtn-EIP7kOOwcSnxor8OGyZNXXiZYHcGf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 12:42:44 -0400 (EDT)
Date: Thu, 10 Sep 2026 17:42:43 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 	Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 	Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>,
 	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 	Christoph Lameter <cl@gentwo.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 	David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, 	Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, 	Kairui Song <ryncsn@gmail.com>,
 Lance Yang <lance.yang@linux.dev>, 	Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, 	Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 	Mel Gorman <mgorman@techsingularity.net>,
 Miaohe Lin <linmiaohe@huawei.com>, 	Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>, 	Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, 	Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
Message-ID: <aqLaa4QvXMbQaIWG@thinkstation>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBBCB2000E
X-Stat-Signature: 3onte4t7psdo1j8htggoq1izuy8e4js6
X-HE-Tag: 1789058577-677225
X-HE-Meta: U2FsdGVkX18mhIrc4DuATV95qTFkKMmfNBuWvxgs57h9Y7vrfIkfvdK8d8MOjuF+mLN35U5bI5La2UEEUBF0EixrfSuWye60xvcgcGh34SypibdtdKxyI71VZyT6arFdu5NliGUQDsLqYnm7WCUjDG1F6froCZvf1Pg+M7THauXcDq6mOB41yq1lnSdzdsVtNm7eyol+OB9CI+ULc+S7mSJR2EBkqnxdd8+oZkh7Ze+2D5LugWEUuEyKFfaLpJo7j5A2jHqJRP1FjQu/H74U+BviM3S/ENthoy4h2L8mR9J8IXmcX4xz7V8UXAs7PGJAZ58lKCeXMIDLaWGxktCYTjJ7t+ddWAbRhAsXtmbWhF2H4+RjnCcbprrUs+u+PKRJPFkkB0hfJuwLgMpUJL2Ky1g5Li80yhCz4PklHCpNi0NgXo7StUtXCpDmROq0R4FiRmMi/MD+yeooRw+SfxUug1phtlEoKmWzmsd8uqJLa49Smhzm1/kMtl6Lx5Agd1Z8x4qzXLgJ9JzW1RU+q5k6fbF5Hu9LaOmPvaXq4mAru34nNmsfZExyvcF6KXi4wMPvYg3V3qMt+Be3jQpqXLi1NZPktQpcBcrysuWtd1He8kRwSSZYBHIVUNYIzw9GZm7gPovhCBDYQC3jToJRGqhvf/m9YgDp8+EFph5exEWKkQ8Ihb55r4gjesRtZ+TzoYPIryGZptbGNSAItdb7i39v+aEjgImrfFHWeDRm4o2x6UR+gJ2Nkz8HsBqtTuOgvahJ1lRbuHlfSG61tlAh4oHxYDfuFakUpcmOIdcQW2u+MaSp2ZzkO+ZCYsfWYW7mN+1NzhoBgA9w7sd9teAcYykwH2BIUZx5T8X5ohZcCigZqk5t2ONXuj3tOcx4cQcjtxubwYPvVg1OzsOsKGUIbMGoke9BeGixcowQesz7PrVL6Wz8f/pxsF+Jqfti3VB/LI/1MtLaf62b7stHcnZIoxM
 L2LhH1p8
 YaiPyF05p7d2MDI8aGDt8lmNWSNxs6fh5NuCHYn4N/kubQBEGR+Ypm/MgRklhJtk68KH9Yjf28P88N0VuqXUr786/JjbKU80958Y8xLAMWdtFai2M4aobt4wDHGj6QR30TNYetLFYbWs2BgVHT2y8LkJ6llm1/UWqVCOyclLK60SEfVcKGkW3UCk0sDhL8tXY/F8SKHjrnzLsz+1MkVS4zBNYpPAKPw0e5Q/cegg1uhfwAS18PtUq7jd9NIOdT6mWupkU/Tkesz8D1jmpMgMcq6/XmbohBS/OTN2/qpFfVqNygyI1nJ/JNAfEXeyCMABxZE4QxrjK5rQhI72iajjVLIOQtCakj21W9nX+7McReceG6NyPZKQGmLzYblGtRpK9+jGC3FfsANySLeHBV/6ktTf39ID6xy+D9HzPffL7wOIZDbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 02:55:41AM -0700, Hugh Dickins wrote:
> Implement an equivalent to the old __lru_cache_activate_folio()
> optimization, to activate a folio recently put in the lru_add fbatch,
> without having to put it through the lru_activate fbatch too. Neither
> lruvec lock nor lru bit can guard this safely and efficiently, so resort
> to try_cmpxchg() on a further, LRU_NEXT_ACTIVATE bit in folio->lru_next.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  include/linux/mm_inline.h |  4 ++++
>  mm/folio.c                | 23 ++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 8420b1276535..8f5efadf9c7c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
>  enum {
>  	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
>  	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> +	LRU_NEXT_ACTIVATE,
>  	NR_LRU_NEXT_FLAGS
>  };
>  
> @@ -358,6 +359,9 @@ bool lru_add_del_folio(struct folio *folio)
>  	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
>  		return false;
>  
> +	if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> +		folio_set_active(folio);
> +
>  	WRITE_ONCE(folio->lru.next, LIST_POISON1);
>  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
>  
> diff --git a/mm/folio.c b/mm/folio.c
> index a18d8ef6afd5..0b75c3b69d5a 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -256,15 +256,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
>  
>  void folio_activate(struct folio *folio)
>  {
> +	unsigned long lru_next;
> +
>  	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
>  	    !folio_test_lru(folio))
>  		return;
>  
>  	/*
> -	 * XXX: It is curiously difficult to recreate safely the old
> -	 * __lru_cache_activate_folio() optimization (folio_set_active()
> -	 * directly if it's on the local lru_add fbatch): revisit later.
> +	 * This optimization is intended for the common case of folio
> +	 * having been recently added to this CPU's lru_add fbatch.
> +	 * But since other CPUs can now take it at any instant (after
> +	 * a folio_test_clear_lru()), and we may be migrated to another
> +	 * CPU, it is simplest just to extend the optimization to all CPUs.
> +	 *
> +	 * folio_set_active() would be unsafe without the lruvec lock, and
> +	 * a folio_test_clear_lru() here might cause a racing drain of the
> +	 * lru_add fbatch to skip its lru_add(): so use try_cmpxchg().
>  	 */
> +	lru_next = READ_ONCE(folio->lru_next);
> +	while (lru_next & BIT(LRU_NEXT_BATCHED)) {
> +		if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> +			return;
> +		if (try_cmpxchg(&folio->lru_next, &lru_next,
> +				lru_next | BIT(LRU_NEXT_ACTIVATE)))
> +			return;

Hm. What prevents the folio from becoming unevictable under us here?
I don't see anything.

__folio_add_lru() wouldn't like it:

	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
			folio_test_unevictable(folio), folio);

folio_lru_list() has the VM_BUG() too.

I am not sure what the right fix is.

Maybe lru_add_del_folio() should only call folio_set_active() on
!folio_test_unevictable() folios?

Or should we allow occasional active+unevictable so if they are
munlocked, they will go directly to active list?

> +	}
> +
>  	folio_batch_add_and_move(folio, lru_activate);
>  }
>  
> -- 
> 2.51.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

