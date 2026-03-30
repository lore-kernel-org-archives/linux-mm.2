Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649B910D14AA
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61D46B0092; Mon, 30 Mar 2026 08:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38996B0095; Mon, 30 Mar 2026 08:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75F06B0096; Mon, 30 Mar 2026 08:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9992B6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:31:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32E2313BBB6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:31:03 +0000 (UTC)
X-FDA: 84602664006.20.00DFAD3
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 376B880017
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:31:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=an7m4W1v;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774873861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHeubX3+pOYegU1tnp4ax8+OXv2EqUmQq1HgXTpbPNE=;
	b=7ch8WafRg3OTpnl4HySlJzOZNS3kxLWh7KuOuwsUADbcNfaDkXRJHdQllOM1PWLgR4BE6J
	/mcOHCuJoo1HXTHilZjVod8ydYcrOwo0Ptu8pxCCDr14MOrATnIeVBV2pjchFaenmb5sQ7
	sDryZbhoVOtGlLEF8I9LG0NscggeSqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774873861; a=rsa-sha256;
	cv=none;
	b=6QnAb/iCkZT1IwJrdEWqPgTTUFd4/CnG2679bIpfYZ76KRczEjcYZVyJZq8063tYuSFtS+
	7O+rO36oyIwH0AImu8LBhKAEau6yC/xNsWfeVGQIOaVynLQWRNM3CAbqWktrumro8miNqJ
	B/Wrm+FyHu2NTi6ZPfotpkCBswL1dHg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=an7m4W1v;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38b13652c87so37234171fa.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774873860; x=1775478660; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tHeubX3+pOYegU1tnp4ax8+OXv2EqUmQq1HgXTpbPNE=;
        b=an7m4W1vjA1vwZ5LfG/7Z/YVH3uViZgeewrUgzA36mXyrmh1Exo64DcGPxn/pNt073
         Eyp/ct0NdviZ9X7huha3BZCQUOkeI7ctaIRwPeSw66zFnwDKYXipbvGjUo3vRjmRyISV
         jPy5dpgYuDrJ1WiPLU8MPv6Lqs6z13PzMIqbCzuiQeCPlx2jYCmiqjhShoaZGEFgkyaR
         ltg+x1m91sXzFNJXUsh/lvb0YtJsraCbVTlYvKHXt+ckygOEa75T6iLeVeHUPLSofRGD
         KggWQRqjmsA/U7U99PrGf8YMXeCFCRkRiYs/JpELG7SlUsTYGXTk1sYq9R3KCpJW+h4D
         6GjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774873860; x=1775478660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHeubX3+pOYegU1tnp4ax8+OXv2EqUmQq1HgXTpbPNE=;
        b=sTUTKj+rokSCj9tIJ/7QkfoYiz2zSHJOWzROOw+h+bakqRoWJeYvIibeLdwiYGTrdA
         ta6JFKpMseRluOb42URv3N9z3V48IzHfz5j9oNH1reQGnBLg+4yRnH6bOO/963hf+ouu
         KxmzOqigWMZtjMnjTlVwEjkgCGN7UJqgF2AB+SesyK3bwn9kB1jRDY/MznYz80FAT3lS
         xT73m9NT0GdlkrY2Q+IgenZXeNrJYgz6VW+W8xpA1nfGnPUXltW5I7Ma2iHqwfE3hyxf
         Vm+Fl7CxYuelDfRFmEsk4xYtF2HErNfqciWZb4ceOA3VXbWREuhJKsF/C20jqvvtKYRj
         l/xg==
X-Forwarded-Encrypted: i=1; AJvYcCWV2eZ9MNmTTvpX8qnZwSikbUeFwE9XC5mhD2DlzFUE0vBs195kgI9PUQwFk4s8advkB+yzUDeAqA==@kvack.org
X-Gm-Message-State: AOJu0Yw7D6NGxJZrEeHLGE0TFjqQ5hSZSqRqPrA/ol/Wtq0E8tfFGPi+
	3f36W1yqug2LpgbODNFDwRJbeWquzQ6sREhCqtHPbCH1PV+TFAASChTM
X-Gm-Gg: ATEYQzy+YKTX56SmqNOpm0ZpU04X5PFk91OLmIUxIEBmfktWA1FpbhYfLo8Zo5bdk0f
	9yuztVu1RIaVTdkk6cVek4ny5cbkc7A5XNF4bx1ZqZIoHUM9nVyDFtWdP8sabgjA8+ojiQcUDoC
	tAykERHsC4f/RajKj4yoXcDRQEOvDjcDofznPLnbkcKvnSYOD1479ry8iKKwVy+3AOCJhh+k2DF
	VdxD1ff35FtVAhYecRfe5c6OQw66JBcJZm3hCzg46LzmYl8xoQhoV22oewT1pY+Y60LyhTXNDpw
	YLSakxYuuVCj3KCL696XMYQqY7i7QzoYLUc07WajIDfpOizqGAd8A5hUoXWkL+8YnH6Aky3+gYW
	F6rds2o0GObmUNgiDjCbjy5Hk0rDTBHAMY/RTbvXwMQDsU9Dv2wXgBPSxNxBdfE61
X-Received: by 2002:a05:6512:2308:b0:5a2:afba:65ee with SMTP id 2adb3069b0e04-5a2afba67abmr3252197e87.42.1774873859116;
        Mon, 30 Mar 2026 05:30:59 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c836d3f31sm16408931fa.3.2026.03.30.05.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 05:30:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 30 Mar 2026 14:30:56 +0200
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
Message-ID: <acptAMZrCKz3Y7O3@milan>
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327125720.2270651-3-usama.anjum@arm.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 5s6xsho74hg5xyr5jrqwb3p9jnr51bzi
X-Rspamd-Queue-Id: 376B880017
X-Rspam-User: 
X-HE-Tag: 1774873860-643225
X-HE-Meta: U2FsdGVkX1+VFR+Qr1cAS9yFojcTH2WY+RKwucngZNSp4Bf6ALvb01voeZ7HmTRXyYcRwQolJ9wUavca8ONBOamvHcEamR4AW6tGpD/0iT2MmKCyfYm54RwhmU+YKqe2zQKhaJRo0yUc/nK36tE4xOe4lXnhkteO10dwZTNrdKQrOZiWEJ/PH1CtJNWA5diy1CVuyPiD50/5XYvq8Y/N+ZYqzzwEfh8moDlf0Ss2VWm5jbLIAdEloYAEcN7lyxf82Gas7mWIoAu4VfNva5xuwDYycUd+1giChephvJHAoqb8IXM869cVZefhfwZNIbF8q1lTLMdz4S8yMOT76Zrv6d7XuFE7gghOfRv69Rbti/LeC0NIPMmVqyOOGprE/QL0lKhPkU/psMDKvjtkzEvael7kl1/46OyE/axg/bGI7kXnhooprSmaSmDmQr5LnrBv0EflemEYJYxVIDZis2zkF467e9FNbmIwvc59Fl/ZAKv8gWR1CWkaAstIWW+ERxYyE9zlT8HvZdBQcUmJ7VCb0Aj03m6uXzkpCHwU5rqKPT5uWSVbbkXycw4oJBI0kNA8tNN3aGCc1nZ8BbifynrEm5DRKfL0rUKec1W53st4/drbfQTvq/47FAckzyji40Dc860EeUvIgWtOnpDwU1N2GsXIIoyIGsLEtzE52ZR4v4sp/0io8i+tQqlq3IQOY47MyIKd6R9xYK4IUhHt4+9EzNF5MhkweSgJmIhksZThWhk+P6YzMS1A6xIhKbVwDgKDUsOdfmHDwCVgQQ+z0BJPmf4Na2XLpblX5WDM9n3uEZgGbSNxEr+BFnJ7EQ4+dCnQdjA0PiiAK5c+RdJ0l10E5nD/DWPAcp1QK2PUpJmy4CrQs9oxDakCWpYndMfFgtEtV8VfqlPZ45/fjVypxEPKbUZoZWHOJlYkT1WF5MBjfyCy0KySEM52m51g7t46Lt8Jya5IitfeMoJ81Vhetio
 Rf88vzj0
 7SRIy1pM67wcSk+AlLrSEu6ES4sFgDnLQ8w8ewhUy3pyUTFMpV9YALXpQVMttvRAR7eR8nnaH9i842bU7wmzfO1BeWxpuVs9u6NrBBzTgb3dvf2EfksuQE5pl3QhwtL2fuBKsEPUqf9oz0bg7wg0NThvxy8lHoB014zaFfgHEuHcAE19kWz792qJTWL7B4agkm1JCsAuawv33ylWUKCd35Kb52Lip5BSYsQnycBEu9TmZFJ3OnhKnZEsqAxToQgqI15UoKUFwwZTaP2UO8WMWtDFVadezzGPktmoS0UZ5ddjtIf3AxBKb9PfpOf2tuNlD4L2uFjVMz5Of/1wJNv7AvZpFmqLvhqhohFPfYGUuE3JSzG4OKY0kJ9xNIwFQIk0adOcSSApvZ/HJX7Ho7l+vPm4iZcbh8a0dZbgzLF076hMuNenKUvo5gYYM+Y9VG1AN5o+LLQrbP1V/Pkf4fm3uxshbqgH9j8ALGhKyPSIWr5YiQSORYaqYxHZACcstsRKSN9pkxafNjmZ9By+1ZJ3bzJBWcI22h91n85nKwxqG24y4IDWdPDwFRJ4fcRfp+90ANQ+gqH3dD3J6clUfHlLyLvaSeMPNvnF1wHXn0J1CJ0oK+E+1NlcK881j8v3AaoLLa1H7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:57:14PM +0000, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; update stats separately first as coalescing is
> hard to do correctly without complexity. Use free_pages_bulk() which uses
> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
> This not only removes the regression, but significantly improves
> performance of vfree beyond the baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v3:
> - Add kerneldoc comment and update description
> - Add tag
> 
> Changes since v2:
> - Remove BUG_ON in favour of simple implementation as this has never
>   been seen to output any bug in the past as well
> - Move the free loop to separate function, free_pages_bulk()
> - Update stats, lruvec_stat in separate loop
> 
> Changes since v1:
> - Rebase on mm-new
> - Rerun benchmarks
> ---
>  include/linux/gfp.h |  2 ++
>  mm/page_alloc.c     | 38 ++++++++++++++++++++++++++++++++++++++
>  mm/vmalloc.c        | 16 +++++-----------
>  3 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 7c1f9da7c8e56..71f9097ab99a0 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  				struct page **page_array);
>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>  
> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
> +
>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  				unsigned long nr_pages,
>  				struct page **page_array);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 18a96b51aa0be..64be8a9019dca 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5175,6 +5175,44 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>  
> +/*
> + * free_pages_bulk - Free an array of order-0 pages
> + * @page_array: Array of pages to free
> + * @nr_pages: The number of pages in the array
> + *
> + * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
> + * run are released with a single __free_contig_range() call.
> + *
> + * This assumes page_array is sorted in ascending PFN order. Without that,
> + * the function still frees all pages, but contiguous runs may not be
> + * detected and the freeing pattern can degrade to freeing one page at a
> + * time.
> + *
> + * Context: Sleepable process context only; calls cond_resched()
> + */
> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> +{
> +	unsigned long start_pfn = 0, pfn;
> +	unsigned long i, nr_contig = 0;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		pfn = page_to_pfn(page_array[i]);
> +		if (!nr_contig) {
> +			start_pfn = pfn;
> +			nr_contig = 1;
> +		} else if (start_pfn + nr_contig != pfn) {
> +			__free_contig_range(start_pfn, nr_contig);
> +			start_pfn = pfn;
> +			nr_contig = 1;
> +			cond_resched();
> +		} else {
> +			nr_contig++;
> +		}
> +	}
> +	if (nr_contig)
> +		__free_contig_range(start_pfn, nr_contig);
> +}
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..e9b3d6451e48b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
>  
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> +		for (i = 0; i < vm->nr_pages; i++)
> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>  	}
> +	free_pages_bulk(vm->pages, vm->nr_pages);
> +
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> -- 
> 2.47.3
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

