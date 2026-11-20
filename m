Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C09B606B059
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckKFX1wL
Received: by kanga.kvack.org (Postfix)
	id 4E2A96B00EF; Fri, 20 Nov 2026 12:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BAD16B05B0; Fri, 20 Nov 2026 12:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1236B05B4; Fri, 20 Nov 2026 12:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03CF86B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:42:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78BD140129
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:42:35 +0000 (UTC)
X-FDA: 85456217070.30.0F9319E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E6B920003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:42:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckKFX1wL;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196553;
	b=L5ttYjfvdmeBfiTBj7WaGH+CGhmVFQzUbZNi19LVArhfjc40GOXyUIbyaqzXYp4nCqUJuY
	hNi5dzDsu4PKKZtYA8bSZaCAPX0oOwJp/hWDEr/0HLrCmXgszjGak0O0wbPcKed7kiAUkX
	DRtVaqlmoFXcBl9bOEkPRxX9tBA9gA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bhnyfvy2KqZXAS36AJ1i0JMsTJ0vNWzr4CDn3GrGcfY=;
	b=COK/Jc5SdUO3jHX7BlAcouqNjrFKG8leygpj3hGm4f0DvqpkYJe7gYk1qPseQzmPfMOjcG
	heBq4qojBvxQtdrM/PejKb9fZ7zLkdAezSccXvLAUeltSgLkUKzSMc0fZcpCuhZVjf3tOF
	+zZl0uy66NutnmS/NIi2yO7H41yuwdo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckKFX1wL;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C555C464A4;
	Fri, 20 Nov 2026 17:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862021F01566;
	Fri, 20 Nov 2026 17:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795196552;
	bh=Bhnyfvy2KqZXAS36AJ1i0JMsTJ0vNWzr4CDn3GrGcfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ckKFX1wLJ/UaG1cRBOg1e67ciDfy+pFb7AtJUVNzWr1+51uahBffgq/LgVw00c4A2
	 8EzmdA+Hokb4hBwVcSRdV2LdcaLG/WO5voEGoP7DGBhNbFzH05cjnl74TrOx9eTgwq
	 39VyLXP1H9zVPgcNJJKoI4fH6B5D3MEG8TmVOzI5NXx55ookscVwHlrD+SixrBBxzq
	 3aDUKLw8M1ojXekVybzS6pTCIJpWzc/T6UB41b+dtiFzijQp2uteKAi3neGvaiN+p/
	 ixJU90LraJv7+XIxpul8suA4khR+gmdgyjEJjkaRWeotqxPQZhzw7rZ1KaIswGndPW
	 Pkax1PhSuRFLw==
Message-ID: <525fce64-8260-447a-8362-503655d09c91@kernel.org>
Date: Fri, 20 Nov 2026 18:42:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/vmscan: flush deferred writable TLB entries before
 unlocking the folio
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E6B920003
X-Rspam-User:
X-Stat-Signature: 8cchdhqtb4sb898k735xw6z3eb1j4393
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795196553-889631
X-HE-Meta: U2FsdGVkX19HN4ML0/BlRbc9Exm1OktZnYsxyry95a5nLCENvHQl/C88umPVt3uMCJIb44Z5GkiCfgf28N+Z0Uqk1LKp+TieQ6J+wM0I3JhH3IhseFP3Gqv8Tj/ijTMYMSU0M40K1qvAjHym9YkTXyC1ypQcDEvmNqLdSt7YpSMHfoC/5C9jZmBIA/dMf+Kp8OWTxpnGUd/TS7sV4+BO6pGFziFEol48yqSra+0QWs/Pfvd4g8flbRtDfI/J14EIE+w8yUxFyCRSz+/Qi26A6lIkrz5NqCwPOIbtt6e52DTWTLEe4v8YSAEeqGH+AXrqVNywi1qXEN4svYpdD4LP5cjwZ8q1w16F4dABPXjry0mbpiJ79ze63O2IJtN43gxjG6xh0tpcT1aiJaJ8iBGlvUbNBinOkw4pi7uDDKOs9XmrqB0Y67fI5w120AfB4nGQoYgBYS11rKvj3M1wCYaLOSnwmeYz4K6vjk78I1FKBB0Zlcy60g7jCQeHc1dGrbnX7Xpa8bkah0Xt5OJZPSMvUSARp6cmNsfwXw7JpAfdid5UUpBRn6FXpGQ8IJnL22bubcpTJ5safJvXvXVoltNj8e65L8tXG33r7ohzAoOqJ6agsZKR7DKfX6/V9+nVfo8AiLOMIc+U5hz5D82EGsXga78cTaQO7b18aEchwTc3G3QOIJFnwjN8EZayjfBOTCPTR2ts7qTH4HRWr3Y5DK1jATho4gjHptrXgfp+hsH50FNPcgkqNOhM2CcV+KDUE4o3cWNxrGMh40WIFkhYai9VbaHhRmBz2Hbo8GNzx3ZhKzDVUoFgWxhFeDXe4iAb2NizOWTTRAjwoOMEKgGgjGLSY66sLGS99qhgmd9O2XTViQu4oiBLEm4g3qanNGg8Qe/p4bxmSbKUJMed0B5HRQqtvZtOgi1RQG6aOty8krVXwuVCCCc+clZ0I5GhFWNIaa4ypAM5rlB9uUPKQPbjwk5
 /M5aJU2G
 DwfUO1LTFX3FhYP0Ta7QITSdbyjDjtUdAZx5HjxpqFEJ5ooKbBb5L+ISJ9eqs0n2iDCJcRL0rYMjh8fDNag9SAxLiutzvUoLAslrnbi8utot2SEht0oKXCJl3V+3a54NZhMak0dE6MFvHvmsMbI/Kh1pnAVwpa3gaZlxBgDIe0Ey6TqtmsactEU4amM4wqYa8OYcTikFtAxbs1/NlgGP7CP1t2EzZ6Ym43T7sv3xbO/O9WmzkpxX/f0WDchmorGNZdoKlqylNSc3uP+unXSDE/7xcD3y/F+VaNO7t3KCMnNczcNgMXKEIpL21w+MGgqeUr9sI0aQzDtV3J8RpZqwv3kBXNqdD6mn+rGIXdv2toxnh/5l8lrmz+LSUN1m5x/XkR5IKz/ryiWc/8gop2iq5g6aHIc9Pb2Cz3mZqTUGGtCSb6Qa8CAAgYbL9LYO3AL/EpKs/mhqvnvLkBCjd3n3rXMaovBrhuFJWa+qo3bHs78Itxt8HpbfP6FMpf/f2iQ9dp+nxtvc5Hcr0P5nJdHwI3LSLEVY5Mi6i7JLqqTgy5sYoZfWk5npuLahEk1RmL3emMKYoyzqBgCN/YN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 10:20, David Hildenbrand (Arm) wrote:
> try_to_unmap() with TTU_BATCH_FLUSH transfers the PTE dirty bit to the
> folio and defers the TLB flush.
> 
> Reclaim must flush the TLB before unlocking the folio, otherwise stale
> writable TLB entries might be left behind temporarily: writeback started
> by other mechanisms (e.g., fsync) will not find any mappings in
> folio_mkclean(), so it will neither write-protect nor flush anything.
> 
> A write through a stale TLB entry after the folio was cleaned gets lost
> once the folio is reclaimed.
> 
> However, reclaim currently does not flush the TLB if the now-dirty folio
> does not get written back (e.g., gets activated or kept instead). Fix it
> by flushing right after try_to_unmap() if the folio is dirty, which makes
> the existing flush before pageout() unnecessary.
> 
> For dirty page-cache folios that reclaim activates, we will now flush the
> TLB immediately after unmapping them instead of batching the flush, which
> is the right thing to do. Performance-wise, it shouldn't really matter
> much, because folios with dirty PTEs are usually young and reclaim won't
> even try to unmap them.
> 
> Fixes: d950c9477d51 ("mm: defer flush of writable TLB entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vmscan.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5495d9be90e88..af7831643ecf5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1455,6 +1455,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  				flags |= TTU_SYNC;
>  
>  			try_to_unmap(folio, flags);
> +			/*
> +			 * Flush deferred writable TLB entries before we could
> +			 * drop the folio lock and others could start writeback.
> +			 */
> +			if (folio_test_dirty(folio))
> +				try_to_unmap_flush_dirty();
>  			if (folio_mapped(folio)) {
>  				stat->nr_unmap_fail += nr_pages;
>  				if (!was_swapbacked &&
> @@ -1496,12 +1502,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  			if (!sc->may_writepage)
>  				goto keep_locked;
>  
> -			/*
> -			 * Folio is dirty. Flush the TLB if a writable entry
> -			 * potentially exists to avoid CPU writes after I/O
> -			 * starts and then write it out here.
> -			 */
> -			try_to_unmap_flush_dirty();
>  			switch (pageout(&ctx, mapping, folio, folio_list)) {
>  			case PAGE_KEEP:
>  				goto keep_locked;
> 


