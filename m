Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9E2606A339
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=MFsIMa2p
Received: by kanga.kvack.org (Postfix)
	id DC8FB6B05B2; Fri,  6 Nov 2026 12:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA04F6B05B5; Fri,  6 Nov 2026 12:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB71A6B05B8; Fri,  6 Nov 2026 12:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83126B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:58:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3849E140191
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:58:52 +0000 (UTC)
X-FDA: 85405454904.20.41E2A14
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46A17140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:58:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=MFsIMa2p;
	spf=pass (imf26.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoOh0KgSmAnOjKaKpi/0YYF58G7PTa1KHqz+Z6PRDOg=;
	b=WuA5zYHEUe+UPhqD8vs/4h/FfqxmAYfSi6/suVWfbQQigkSqbse1pMhpPYMurWoHv+GRtW
	P/5jGJDzdYj27uNGmOG0vwv91tpKYEt+DWwDa/zfT7XhDQ9qD4aQ/bq/qO8uchVslCd5ge
	9q+i/0nM3E2M3iuZ/Tp6PMNTfFJte3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987930;
	b=se1e+yvOOsJ4M58GCrL3d10j9PHirMosVbd6nUEf/7L7Ekbz/PqC4SYjbNaaZVdeQCYo3G
	i15fXVPwafKvVGhPeHlg6GXOhLAUce+C0rXhNQw3iHd8mf6Qp/BsdSGqOFuwsSYMXEn89U
	DJjbv90Amw2+3oXUoFSWKEJnbDM9JVk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=MFsIMa2p;
	spf=pass (imf26.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53c4b82919fso1124211cf.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793987929; x=1794592729; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KoOh0KgSmAnOjKaKpi/0YYF58G7PTa1KHqz+Z6PRDOg=;
        b=MFsIMa2poOg5H9x9+ci8nLRsyS8x5ihaKvqygGlY/+GuUA/6fxxXo3bSHBJfBQmNWe
         LYbh3VzZ439+fBAaVF+PwEJd9y3/byYhXkhrxP0FiccwwcpWIKuClAXbCyTuYerqC9Tu
         gJPMSoXvN8j1Jcw4wWh0YhTrtCf296Xpg9BDttAINnFxn5u2Cm0mwDmK4VHUV0TYdxQj
         n81DqqpzeBqzIUT7Q47HXJQCkZjAFYNCtCsnaCfKPc64QmAh+tAnG8I++V+ELJ5+Ds0S
         b/M/MiBDCVosYKdue5qkJtZWmKz2zuS8S+v1AfEQtm8zMhwEXM7bpFdCc4sETX4LmXZt
         5W6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987929; x=1794592729;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KoOh0KgSmAnOjKaKpi/0YYF58G7PTa1KHqz+Z6PRDOg=;
        b=LTQcBAqf+1chA6ZK6ySvrXR2ibHvrYZuAl7To9JoEndSh6knPxyCaIzMpKoxEK9rFc
         z/DBE3o3lktH3s/LMKXN6loflgEQhEW89xT4r5/Ya8ACCFqO7OwH5KSSKeKozjAO5G3f
         S5rY9FFH0EeaarRQYs/tZuD+DChkdmyPSAm4gXt8dqUezoA4gmNGDfLUQ93La2c6Ym++
         sG1rsAFAB8T27QP6FgnY0KJeWuAM1xtFht4QWjf+kehIpRhlyJI3E66Q3hdl6+NKoiSA
         bemh7OhFzgIU8mRaAqwhil+2KgO+KS/gtAhQLMqbjtFTFIabHP6qFA/cUJsCwQ3X4qPW
         hJYg==
X-Forwarded-Encrypted: i=1; AKwUvByGpohBE6RimlqvQil9FHqEWsN1OMdTqkoO6bYalwT/CttCJ9+755FeOZrrogC3rHtSSE7hwWLYiQ==@kvack.org
X-Gm-Message-State: APuU4Z95xCwBDs0qpmMOVtvLcgzsSVfwVuhWU62zdgKgFOiorfKvCKH2
	RxJVYpDnpCtpWcTWxu3lbiMRi30NiBVcK48WZaV1k7YSALzrf6kFHoD5aizQqsmB8SE=
X-Gm-Gg: AYBFou1UXsRJiHovTUJ+6T6XoTvFFRH+ZgxZnbf9wdmjQ0UR6+W38t36aRcVujfJgL8
	d9q48fWcZqeBw3AdXMGmtIF7i4ly36jOOtE051cddpISXNhy49sXNl+VNTbECbSwR272Z6bX6+0
	PVNlFhrvvdIb0luTPCKKnANFI1PR08X0SyrIIkUHdsIQjbZPsZ7G+ruIvT37pt/cUT3p1GDVw43
	Vuuan5r7WBKP3NBoVRByfKm3GNLFbcFYKnbdBkRsoh31bQd0bJsHo66esn+riGDoCDoLsyewoFw
	8MszQRx2i/aToiJGJnX02VGCDhHlmAppc/36sg34L+gsxK7CUPQhX38chusxxnzWH3sK9HVktmW
	L/Ze5S5hHOjn4lnewtth6czDsSwMcfnBGWhUugr1JdidHmq02R2prDQWoWmR05k91jmJEGqTDam
	YeZNexmeE15QAb+LIVYheFtrXccsVITujEwOjcoAuZjH4poEdUcC8G9FV3o+tkoqImtV5LCjl/G
	TyU5YDz8Ksu56hER3MNr6Z2ms8Cdcq6RfxwKoj+CkUjicJEI0HFM9KAA1VWp2Pf05WyxfNrRUuE
	Ls+MGrH+s1vgeycQHYx4NoNPF4zVozYBtOW9dHiScAMm
X-Received: by 2002:ac8:5d08:0:b0:536:699d:9a22 with SMTP id d75a77b69052e-54e157646f3mr53331201cf.57.1793987929323;
        Fri, 06 Nov 2026 09:58:49 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e27013e83sm25509581cf.24.2026.11.06.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:58:48 -0800 (PST)
Date: Fri, 6 Nov 2026 17:58:36 +0000
From: Josef Bacik <josef@toxicpanda.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, iommu@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
Message-ID: <n3l2cnx6d25jovloqyoxiz566mh62janclmiewjvumtmqfezo7@zmsmco5vvssn>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 46A17140003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: szmtgehuyfiff71ktujxg4zzndypm5sw
X-Rspam-User: 
X-HE-Tag: 1793987930-980305
X-HE-Meta: U2FsdGVkX18lG5WrCS5BwOZr8XHh3SQvn5BqHD9O/tPkIlgRWgFMTka+W+ybv/37ueuDqwHrGtMjYyvipimrAGoJ/gfVzMhdauXYbLUbd0BBWIyVoPGEd4x3vANNLyP8GKSu5K0PMyIAxUmYouCsU3V17E40Bapq8rmWsZZ9cRyHp2UYfHzU4kzL1UYeddwrN7AKbBWQZT+I51Fdf6/ugux8QXHZ6bes6e43gW91jwInJuYWA2hAKfkHMeHrib7j8EqJa4S9rBmcIz50QdO2ot2pv2dlsCMC2xQbKyxlXC1wOCY0POHlLXEsqycTRAu+2UrbV79lu+P8GUqoy1EDsvydp+RypyrcWoxv823c+0ksitzTXX7mbJumPQdBkiswb5pdw+B8OqwrmS6BBBOWaMb5n9bUUCnliRJwX1HjJQRuCyaRWVClIiw/GBnyMvcfkSS9rYzVxjWLYJxRi6iPJ7fcIhNky1ZgYDjlP0hNBXgGMEJTSZyX0Uk5Cvfujowx18k+mn/7aVaAUJ6xYQXY8OpaZoH3y+JL8gcP+rw50WGidk+e9QBagaqIu51DgjNmdrXkcjG2IPRLO7bFAXY2G1ycO/zJ2uIJPutkZqzoTShJU2HTVPaGaN2pKt/TuXZLtQF3EDLBFEifhh73P2Aqb0QIlaJsbAftgxBRb5efTCkVhT1aU774gxPr5XCKeHzoZAEnaJ/fOt1JbYIKRqOPVCxZlPKvK90koZyAr0u+JWmo/dpMWA20lf63Ngh3TWmzFV776g83Ca6iUv0ABtkTJe1vb1LKg4MQxHBpw2yoAb7oCPIpOniNSHZCpPWiiG3lBf33zapc1h9eii/LiqJGPFYxszfgolDFlVZGWTbXQum42XlovZ5MmaBPBcT93eWVyAQzFaLj6TH6DIq/V0o6AeFerXRgqxBpj22U8xl+5S97b06pyCDJTQ4B66mvDe9Rt7Ait9iCE4P0fm5vJxV
 qiYWmB49
 LAGPMw4r7etvZL2q5dPV17DZyT/j8NiVHv8UGTVzsP7fb3GWiazvMJJBGZ5RGydXx9U1i+UXM85IxRjeamB5K8KZ1UCM0gDYpetVomRshPIdP+EobkZo6Xclyf4IzhCb/XjPl51FkGE/iGlMrImiQpb0AMWWX1nlHzM0w1y4APF6tA/GS4ziyZ50vBHxRAQkJAOBzaeOEtZo7yQ/GTNpZ0ej5MAJ/dYVnRgC6U+oKtHbJ8CA+l0SY375Qa+1jC7Ns9jjmOSn68ASRg6twx+cg68u+hd944iSnLWlNIuehi654DM4tiM1Gl0m0qw2iBon5rtZ0P9FVXAVIwtbTKmmTtzX+zA0CemR5uEGaZSjxmoCLF3m9B8JTVIvhC21qqsYv0nreyawzdsaSjoeIxKZ72QL6Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:10:11PM +0100, David Hildenbrand (Arm) wrote:
> Similar to mapping pagecache folios into page tables, let's reject splicing
> folios into a pipe if the refcount is at it's limit, similar to how we
> handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Let's keep it simple and check in the two callers of
> splice_folio_into_pipe().
> 
> Also check in try_get_page() to cover pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h | 9 ++++++---
>  mm/filemap.c       | 4 ++++
>  mm/shmem.c         | 4 ++++
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 79ae8fc0d6bb4..a82cfbce18215 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2287,10 +2287,13 @@ static inline void get_page(struct page *page)
>  
>  static inline __must_check bool try_get_page(struct page *page)
>  {
> -	page = compound_head(page);
> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> +	struct folio *folio = page_folio(page);
> +
> +	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))

Since you're here anyway can you change this to something other than
WARN_ON_ONCE, since that results in an OOPS with panic_on_warn set?
Thanks,

Josef

