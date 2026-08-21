Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6E8C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397F26B009B; Fri, 21 Aug 2026 05:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3490C6B009D; Fri, 21 Aug 2026 05:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239516B00A2; Fri, 21 Aug 2026 05:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E35196B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:58:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CB361C17BF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:58:54 +0000 (UTC)
X-FDA: 85124827788.11.7734919
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFA8640008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:58:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHF2KKX3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306332;
	b=BRbe8kZYcXe2C6zMVhMnYM1VIOBmprJfacJhSRBChWK5RefZtelHdaetFTU+XgTTDZGvi0
	i9LPUJ55t7uXF7MKeGCqWIAq/wD1y8GoMMRKhvyRmgZZX67LfXbaxpJM2ewV0JChxZTKwl
	hnYkprZPBYaVt75ilYwxBR2nQuXzBWg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHF2KKX3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOBFFN3DogCz6H5/khZbeZaJY/DvAhpaGbrZVIDS07E=;
	b=SqHjf+TUq/xwZrNzB8mY5jGLM9ix5RKYq8i101eQSBG/DRPCMViCdRsF+11hTS987IYdKg
	QJVuDQqMAxL5L22p9z43ahQMpXckXoqN7y3jrP4rgiJj/b3nB51BF73r1e5+3P2lu5xeuJ
	n2p6hs2XqIGv1VCNCEXMO4B+U11RGfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00AAD60DB6;
	Fri, 21 Aug 2026 09:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8851F000E9;
	Fri, 21 Aug 2026 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787306331;
	bh=vOBFFN3DogCz6H5/khZbeZaJY/DvAhpaGbrZVIDS07E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cHF2KKX3gX0wJna0xdHDX/lXXUaFtDwFPYOdtTYGJ/dTz06ZcMf0qutw0drcSZfkz
	 UO1heuB6gInCl8NFG5BCE8TEcBPM69yEaQWqPZtVNVA5R6VGkQ83KHLoSXBBvwz5Cu
	 xpN1OpNUTo107yf8ioy6M386UyIbwZDU327W66ktwVdY/2PdNo0q6fabHJ7aG6vR2l
	 EIPhBcthZVVwatmeJh/S/p51d21jt+5pR1o97t/ZulFIS5/i+1IFvfyDjD7sYlIPgz
	 ytOIfLtxBztkuT7tlN1T4+0+B5sSWbS+dvsTYBOa0aPIn96Pklbjr7kk+2c0goi3QE
	 kgF0k9SFII+gA==
Message-ID: <c6e1ffd9-def5-448b-ad2d-52dfca9685ef@kernel.org>
Date: Fri, 21 Aug 2026 11:58:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/zswap: preserve the workingset shadow across
 writeback
To: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260821093606.2231216-1-alex@ghiti.fr>
 <20260821093606.2231216-4-alex@ghiti.fr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821093606.2231216-4-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFA8640008
X-Rspam-User: 
X-Stat-Signature: 4ygidzaz8u5a6d59wba5geka6usdjey4
X-Rspamd-Server: rspam06
X-HE-Tag: 1787306332-106787
X-HE-Meta: U2FsdGVkX19kPcFOJxEApzgiKjP6nSoiWbayHi5b7IN2fAKikJjl6/anLv8oe/ulCWDAhboFvTCD2TQjSP7l407Xkv9wimM0YE6qWZVnB7jmSCk5ZykQYv9D/M6mZ3KlIXXepkhB6g2Dc1MYXuH72KSy3rqKElGEt5183Bt/eXZVZCYwiZeotzrDRDNQ12jJFssP9L8tRdD20aayIBis6ajAiatn321Rij224FCbq/UhYmto8WlJ0+GD+2Gz/pfVEwUtVN0dBYLealf5EfAy5Y6FqqxRebdBSgWSXrGk1d8mLseDhhjpiEvjQGqKt+WBbLi00XsuO8H+GwDuuf+VIFp9IziHUeKdV4TXsBl0IIBczNQ3XaItXVMfoq0MBkq612GPr2vIkA7kj3AGaIm/BderLhNN+9o607fD3erLUC0obfjUNithhfTDxYaxTDP8tQGJv4WTzhy711YzoOOroUZRzLOWPv9nmiddiddcfUnqhuW4StmZSr658ECLqdwfogzO1rLV0z9veNpQNrCP7tanRwfaxv8PdWXbyH5QNLnu7Ga6sCsKowDJGE/QLgc+xymyh012oIkCsMnbgdchiljK4InXGPNBK7NxnxpCRl4ugj+v9t5TyH6ZgRQswOCOcvToQdDU640aiT8aQYZZ4jKJ+Oqs5A4L6Gvsqe4+tLJD91t1wEOP7x7DuTz/aB5pjYmwmv7X/hlCaRWOmIpFBS4VaomBOpXEMhVIzRGTdRM0b7yOtLnRXv98Nr9c3XSokoCELea88dFwwyNwVpAm9bBq8thYWDIeuO3YGRodRhX4Fl1cRVVI2CH1C6AyrT2dIH57d6ausuAqTUXS2p5To+T9QVDsH/sztn46c9e+ZDkeW2Pisocf3eYjau4FPYHvv8776dfohsI+IxbZU8Y+C+3VDPH/xjfQv/je9/c/VL1j3unNFz33jDk2WZiupwP5IFIHNdN6GOYHg9ENUkk
 QnmiPeFi
 wF+T8sFkWXBUrHhAGAMTqTPqDe8MYh/rhb8zYq8fVXriefJk7XZAQfQwlwoNJucCD5G+osDeLVGfWIWs3gAnb3lDFvaTHZ6gYKYKrp/WB1mMA1DAwl0ptSpvbTVQm2CuwAcW8FN2AC7B/r1OrAoD2KSQ9vDT5XJleNuQTsJIXT6RZoU919sbndOvnhud4gN3ihotPhyh95vIy6QCoSG/DMNo+8UNhxOw0rVGcwEIkU+I8ax6FK1/c58iytcfaWuEkAwcchktQYS+Vn0ahvmjEaxzU2kbxsMqpKPlE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 11:35, Alexandre Ghiti wrote:
> When zswap writes an entry back, allocating the buffer folio in the swap
> cache overwrites the swap slot's workingset shadow. It is lost and later
> re-minted inaccurately, which corrupts anon refault/workingset accounting
> for the written-back data.
> 
> Preserve it within zswap itself: at writeback, park the shadow in the
> zswap tree in place of the freed entry, so it outlives the writeback
> buffer folio. The buffer then meets one of three fates, and the parked
> shadow is handled at whichever happens first:
> 
>  - swap-in: do_swap_page()/shmem_swapin_folio() find the buffer in the swap
>    cache, take the shadow and feed it to workingset_refault() to account
>    the refault of the now-resident folio, then drop it.
>  - reclaim: __remove_mapping() skips minting a fresh shadow for the buffer
>    (minting would double-count the eviction) and
>    __swap_cache_do_del_folio() restores the parked shadow into the slot, so
>    a later disk swap-in still refaults against the original eviction.
>  - slot free (e.g. process exit): the shadow is not needed and is cleared.
> 
> The last two both go through __swap_cache_do_del_folio(), the single point
> every swap-cache removal passes through, which is why the shadow is read
> and cleared there.
> 
> Fixes: aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/swap.h  |  2 +-
>  include/linux/zswap.h | 12 ++++++
>  mm/filemap.c          |  2 +-
>  mm/memory.c           |  5 +++
>  mm/shmem.c            |  5 +++
>  mm/swap_state.c       | 14 ++++++-
>  mm/vmscan.c           |  4 +-
>  mm/workingset.c       | 16 ++++++--
>  mm/zswap.c            | 91 ++++++++++++++++++++++++++++++++++++++++++-
>  9 files changed, 142 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 6d72778e6cc3..ef9b1612ac12 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -298,7 +298,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>  				bool flush);
>  void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages);
>  void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg);
> -void workingset_refault(struct folio *folio, void *shadow);
> +void workingset_refault(struct folio *folio, void *shadow, bool lru_managed);

Passing booleans makes calling code hard to read. It's preferable to either use

(a) Dedicated flags; only makes sense if there are really more flags expected

(b) Having helpfer functions that spell it out for calling code

workingset_refault_lru_managed
workingset_refault

workingset_refault_lru
workingset_refault_nonlru

Or something like that, which makes calling code easier to get.

-- 
Cheers,

David

