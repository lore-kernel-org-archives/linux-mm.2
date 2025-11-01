Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145EDCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 08:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1E38E0078; Sat,  1 Nov 2025 04:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54098E0068; Sat,  1 Nov 2025 04:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68AB8E0078; Sat,  1 Nov 2025 04:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A06DD8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 04:59:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 518A74A67E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:59:46 +0000 (UTC)
X-FDA: 84061440372.10.202F5A7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72CC540005
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:59:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BjvbZ4nK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761987584; a=rsa-sha256;
	cv=none;
	b=2ZRziUTIWefROp2oHMAHovOafF2ZHfP52kKtSK+3NYD7ylwRZ86dE9Jwd9lztQ/UTa9/dK
	ZDKtBfGVS76C0RPKSjjXwyYt22jzYdcfnL1ZfkilUQYmUyX6jiHDUQLO6yMzSB9ym+ZVC/
	xigT4fxctty4FeR8Vi60nAr2Lg3nPEI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BjvbZ4nK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761987584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pR8Ekz6erdqjHJx6BchTSxJ/OmeWD1sA0olQ5hB+/A=;
	b=wT3Mv7/1K4F8FLu8BiNBFHMtITFBxXFLrgIYsRKLRgjs2ensxNwyJMFCoVEW6gQH+1TkDt
	n87aOHCqwK792WKiun3L1OerMxuvxY8GcOOHeWwwewj05WQhmavSansn7SI0mEqkdvWHgI
	ztK0Q6OEkxfdLJGZmM57BYmYtRxPwIQ=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64034284521so5166603a12.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 01:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761987583; x=1762592383; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pR8Ekz6erdqjHJx6BchTSxJ/OmeWD1sA0olQ5hB+/A=;
        b=BjvbZ4nKO+Vpe06+uKAouLNJOo7e4pNlUGs2Um4dve8ZCuXO3T4x1NwXG0P5sg1Kmp
         oE/0D59p9ABR3j6mbBSyXC0gDHn52I93zBkKUTdWAMVHulktsvCd0Ihfp8P6iIJnDYWK
         o4EcD+HlxUjx1NmkJ34tOCyKZ1E+vsFv07xY8u52YwHNkufn/ORNJZDEb2ZkES+jVgjC
         mgzMew4JMV6JyFC6Eqm3Dxu75aglqe3pRVZ0GAIAdNFYYudZeigExXh1gzX4Pj5ULizO
         hjisLZXB49cE3nS1tBQ6R/J3164Ie2Oi2V2N7/2ZR8QSYETZusHxCcUMkLFjHLtwTAaR
         qolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761987583; x=1762592383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pR8Ekz6erdqjHJx6BchTSxJ/OmeWD1sA0olQ5hB+/A=;
        b=CazpI733rM/DJpKtFkBJDA1Dtn1Ka5S9mH95ew1tiGBQsbjMiFdhrJyH+QUx1FfiNi
         7/AomsLJq7yL4ob97McoKLPSsXNuIagq3an5XBfoP3qYIYlHSS38ClO+TeJ8iWHjEfPx
         R6uNA8hHNlFe5wLCIek4OzYxOFW5DP8TdxsXFYA3Sz3tqRCRXvz88cVedL3KPz0dNkRe
         pluZ9G4hTetgsv9Cg8fdmFzeAbT0Z7eQMDkYMptlAlRWkhtF4eIQ1xXLxOZjpM0Axqz5
         PGJqnmRSvRZed33XM81lQkxIjENU7sQaYywtDRMryZ8Rm0zkJuXLoUoeiq1heyGbIPxx
         dFwQ==
X-Gm-Message-State: AOJu0Yy2Z0Ho04ClDbvVrcr/bRyvvKSBd5awp6MOcjnrWG26FDQp6Im9
	PS4+FoLIBANVHvZkLaV6wNy/yDUKs+G34+qrWa+CXwNMk3TN8s/Y4ldcNqCVHHLcBc6Jc6aOtus
	HfHIhtw1+uAUyTAJmJPPLfvHVqbtSXmw=
X-Gm-Gg: ASbGncu1lLHihgXNIXJdWXS0jd/KmuhSXOgIsxnUMMr+1RxnPuW7M1jsyYvC2UfBv7L
	TqHD/t3dEFnkS5emeiX4Te5Baw8eUIrjQZMi44pVLF8dvr5kC8q0BaJOJClTAzUvfeTFfqU6wjF
	Ls3bdY8YYQZ7diwsQwlsrw7mG9wzVXrX77vGbPE+VuUt7zOaUB8oF6NjM9EdLoaq7klemvNmZat
	hf7h5osO6gmDNDdFLs6r+sGM504sTuk+LOFUvJh0Qf6K16dNHwWP1/WRKli
X-Google-Smtp-Source: AGHT+IE31nMuSrKicWOYIZlFDzMUvDlYlzlW9D6irYkq3pMBpvPm1LUOFv2OM9SELcI/pEdEGJLs2UXmY+rsOiWN9mQ=
X-Received: by 2002:a05:6402:35cb:b0:640:80cc:f0f4 with SMTP id
 4fb4d7f45d1cf-64080ccfb90mr3634783a12.29.1761987582568; Sat, 01 Nov 2025
 01:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com> <aQWR3fK/GtTkx0kX@yjaykim-PowerEdge-T330>
In-Reply-To: <aQWR3fK/GtTkx0kX@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 1 Nov 2025 16:59:05 +0800
X-Gm-Features: AWmQ_bm4zbd4WMYvcZZe-6woFHP9CTVY8mskA0CTMQ0lCP368NaFqz6cpzv47FA
Message-ID: <CAMgjq7DtP4j4kQp-bM+jrVSkCh26+8U-TkENxUmPkmEJyZg9YA@mail.gmail.com>
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pfkn19ad969x4mti1g9w5q9iinc8j3dr
X-Rspamd-Queue-Id: 72CC540005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761987584-997128
X-HE-Meta: U2FsdGVkX1++WrvKiJD8YLX0HwYJlzD0l1sUNhbfcBH5Yq3hrtgVlIe6rN/lQkYlSFkSzm2yagaFST4qU4OE+tR3tEjHBl09bR0GdfTgqgKZkUNFVjnSQVDaOuSGghgF9imTbpLgEiVa1qYLbnqVOYbo562AHl1y4Kz7M/TLE449nOIcitlhbWILiz8JpMTbs3pBXAuggG/HnoLwjICs3fqs3XBSXgWWNCO2L9oTZZe8pgycsUqYTsaHKXroRrdxXekxwyLKAcRXdTHpRYO11mZhX8ROi1ooYf9ZwsZjYXxn1b35jbwRc1raZavtHK4dXDws8jAkFAvPJe95LbIxUaHg7qiK1gpiehzhsTGFVPKBFkecNGFHTg//suSYguy5097Qc3EX7EwJx1hEWuCTzInnawgZ7zVEid6TtbjoSb0/wmWRlWSZ+CtzZvxdqixpiiUiTNhhwYvfBdfQdnHa3k0fsKXWQZBBfWQiNwIEwheM6mPErsDmtfI6b+MFmRScuFUZ3HjVZ+cm7MV3bexKRVJOlPNZUswNTqG1uRWAQykWbg5gWYGwMmDJN+hRKi1editO4qWS/SmwG9k087RUH5r/wc+Jksz0ZgupmiAtALaMASiArUL7KJhLQCxlwiYM11advpd/dZeIip+HGdnGhD5fUlIbQAqNAEIbi3E7kxNDqxPFTRn34wJcun9lXBPUjGm5XREoJrLa/Cxh8EeHGQz+H0+2WWMDiVslVPX94LElTXVW4qMB5C0CLVDF47996kOOFuXMfII61QoZzaiIQDWKdTZDvFLwQ4K3sOafxeH4+1S19bDDHXFiG6S+i8xejaeULkKRCzKtB6q/27I/ZaSnlyl/YbyzOqjgx0a5qy+W2VHFIzQFNvmmLysv07YuzmfZD5kiQqjGK7E8dMkJbAgmx0gL+6P2uTQTiijVaDaF4Spo/nmWvP+M7TrTbtC79F2+lP147mqwe1mdvFs
 ZXGWaopr
 WVttl0MnzEvrv9OOHea+T8drwsKwkQm2k9pSJU9EZsMHFQPFvEhvNX/GkB4wGKjxI3HTiDkft4MHLyCS6RI52Df9p1YGaIIy9XTcfvd6VOf2h/aqW9MDaqxHAIKvSEYMaCqQmOklmemMgYUYIFuGRaIdnqRhIyVVbjZqiZ+IW75RuSqjf50StRW0e2JGN2kDlTB24Kh/WhS5+GfQCseiKZK5Uej643zZToF6aWuDTR9hEDubJxBtHqNKfhIe7hsy+jg+k+QYFqsqwaoqOFNOUueV+9Q/D2ZHYGU6x47GR3IMtPSFM722AIHLZW1R8Qg3oZENM5gfq8gBksszNOWVpAogunX7k8Y0idb3nTRLIDv1Oie9vak7L2HleZ/zkUQZvVyx01AeRh9EVPFC/P6mjcM+iKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 1, 2025 at 12:51=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Oct 29, 2025 at 11:58:40PM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
>
> Hello Kairui!
>
> > The current swap entry allocation/freeing workflow has never had a clea=
r
> > definition. This makes it hard to debug or add new optimizations.
> >
> > This commit introduces a proper definition of how swap entries would be
> > allocated and freed. Now, most operations are folio based, so they will
> > never exceed one swap cluster, and we now have a cleaner border between
> > swap and the rest of mm, making it much easier to follow and debug,
> > especially with new added sanity checks. Also making more optimization
> > possible.
> >
> > Swap entry will be mostly allocated and free with a folio bound.
> > The folio lock will be useful for resolving many swap ralated races.
> >
> > Now swap allocation (except hibernation) always starts with a folio in
> > the swap cache, and gets duped/freed protected by the folio lock:
> >
> > - folio_alloc_swap() - The only allocation entry point now.
> >   Context: The folio must be locked.
> >   This allocates one or a set of continuous swap slots for a folio and
> >   binds them to the folio by adding the folio to the swap cache. The
> >   swap slots' swap count start with zero value.
> >
> > - folio_dup_swap() - Increase the swap count of one or more entries.
> >   Context: The folio must be locked and in the swap cache. For now, the
> >   caller still has to lock the new swap entry owner (e.g., PTL).
> >   This increases the ref count of swap entries allocated to a folio.
> >   Newly allocated swap slots' count has to be increased by this helper
> >   as the folio got unmapped (and swap entries got installed).
> >
> > - folio_put_swap() - Decrease the swap count of one or more entries.
> >   Context: The folio must be locked and in the swap cache. For now, the
> >   caller still has to lock the new swap entry owner (e.g., PTL).
> >   This decreases the ref count of swap entries allocated to a folio.
> >   Typically, swapin will decrease the swap count as the folio got
> >   installed back and the swap entry got uninstalled
> >
> >   This won't remove the folio from the swap cache and free the
> >   slot. Lazy freeing of swap cache is helpful for reducing IO.
> >   There is already a folio_free_swap() for immediate cache reclaim.
> >   This part could be further optimized later.
> >
> > The above locking constraints could be further relaxed when the swap
> > table if fully implemented. Currently dup still needs the caller
> > to lock the swap entry container (e.g. PTL), or a concurrent zap
> > may underflow the swap count.
> >
> > Some swap users need to interact with swap count without involving foli=
o
> > (e.g. forking/zapping the page table or mapping truncate without swapin=
).
> > In such cases, the caller has to ensure there is no race condition on
> > whatever owns the swap count and use the below helpers:
> >
> > - swap_put_entries_direct() - Decrease the swap count directly.
> >   Context: The caller must lock whatever is referencing the slots to
> >   avoid a race.
> >
> >   Typically the page table zapping or shmem mapping truncate will need
> >   to free swap slots directly. If a slot is cached (has a folio bound),
> >   this will also try to release the swap cache.
> >
> > - swap_dup_entry_direct() - Increase the swap count directly.
> >   Context: The caller must lock whatever is referencing the entries to
> >   avoid race, and the entries must already have a swap count > 1.
> >
> >   Typically, forking will need to copy the page table and hence needs t=
o
> >   increase the swap count of the entries in the table. The page table i=
s
> >   locked while referencing the swap entries, so the entries all have a
> >   swap count > 1 and can't be freed.
> >
> > Hibernation subsystem is a bit different, so two special wrappers are h=
ere:
> >
> > - swap_alloc_hibernation_slot() - Allocate one entry from one device.
> > - swap_free_hibernation_slot() - Free one entry allocated by the above
> > helper.
>
> During the code review, I found something to be verified.
> It is not directly releavant your patch,
> I send the email for checking it right and possible fix on this patch.
>
> on the swap_alloc_hibernation_slot function
> nr_swap_pages is decreased. but as I think it is decreased on swap_range_=
alloc.
>
> The nr_swap_pages are decremented as the callflow as like the below.
>
> cluster_alloc_swap_entry -> alloc_swap_scan_cluster
> -> closter_alloc_range -> swap_range_alloc
>
> Introduced on
> 4f78252da887ee7e9d1875dd6e07d9baa936c04f
> mm: swap: move nr_swap_pages counter decrement  from folio_alloc_swap() t=
o swap_range_alloc()
>

Yeah, you are right, that's a bug introduced by 4f78252da887, will you
send a patch to fix that ? Or I can send one, just remove the
atomic_long_dec(&nr_swap_pages) in get_swap_page_of_type then we are
fine.

