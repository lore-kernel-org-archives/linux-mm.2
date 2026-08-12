Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A28C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5116B0283; Wed, 12 Aug 2026 09:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DC96B0285; Wed, 12 Aug 2026 09:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054AB6B0286; Wed, 12 Aug 2026 09:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7106B0283
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:37:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6510014037A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:47 +0000 (UTC)
X-FDA: 85092720174.25.6C49877
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8120B2000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:37:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OjnmA5H5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2/eW8js8WPIEzN4muuCXfZ23ENIccFKrP1Pa44pPgE=;
	b=nPIQpXlV4QOCyYo5kbBpSP46nc2qSClcd4H4aL2ul/RFRYbHWFUbVwIX79bbZIggOHeCYd
	hHxl5X5+EQQbb8MlXVHLODbmw2hqUdwFRnU47fGgTblBqE17V9/otYmfXFrROSWCzDelnr
	8OIq1p1v/uhHW3v6jfEIN0FTyTkr6b4=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OjnmA5H5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786541865;
	b=SfI89eiPLHRfRTm2ipJLGXTRlYZjjS3sMIYyglvBUhCmyfZKAHGPOi7UPmlw865PgViiDq
	4YRtuEdr1/rqWVh0ig0rs45W1+hlWxD2cZwfjdg7PX88QiQdPhXoImyknMEu+KZZt3pyPR
	xazGiT/h9p37BL9VPrUQ9Pt8TCKTq40=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c15a5b265so229781cf.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786541865; cv=none;
        d=google.com; s=arc-20260327;
        b=TxAFH6XvWYwf4j35Mwz1VISrNPaa8eW3RhdoIdQ62SbYGgevgTMGgpU0CBk7xw3Qr+
         dt6+KRoBWPQkFHXLEXVmVORbwBX6a9rHj0R9oix22/XUboobXJJUlgsfjy1zkS1MUvw2
         YTUjS63CUHM7gS4FTTzZGgrGzM+PjRspxUGWpJLJmSZjMqdQfJrYr06bsRWQupT/NyWv
         X5B43GPIMHFoV2kuEk3GpF27dmDLTzATUQ6DhDE0ukTBjfAYFv1j+1FYSbxUblOariBv
         qxCLDLV+IPN1VNRII5cx+bEEeP6RsWjmcVyU+14HIL7SJGBbsUn+c1orycGkdNsbYSzQ
         Y2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S2/eW8js8WPIEzN4muuCXfZ23ENIccFKrP1Pa44pPgE=;
        fh=H7pS24WbiMrWVsQinxYKCDUucTDBa9sEHyZ2tACAKB4=;
        b=iUDvjmPpQRFHaxbTiF3RA5lI7eCEiMRZUe08k9F/t0hVN+GkpHd0bXjc8CsLc3B31u
         Yv7RketkznWncGwp0rIhTsaTwOi5TJ/modrHo705W91K6CCDd+qbAHvyBu7DsbA5nfAe
         ghzt7R/kwP1xtYRd5vq2XunZN4FpnjFXPEAxmHTiuRR9I2RTjNjQ77ppuxE+g/wky7Vw
         iUhnC9bTMP60UqZBT1MLCBX0kbTEOKkarOaAdv4efYwQ16D4lK1MWQGzvopV6X66Gp/9
         SqgnHKmmjtw0lrUZaUkqbIlhjjWpcv5Zqa/SpoAQX5YK4vL83zWpf7cyzkaE+bGCMLvf
         OvvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786541865; x=1787146665; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2/eW8js8WPIEzN4muuCXfZ23ENIccFKrP1Pa44pPgE=;
        b=OjnmA5H5qEzUDJxsp63/yz9EsjgYEd3W1WbVif2Rcmifc2rDGHxyEMpgXWMwPjwLll
         Y/zFeChqU1k+j77dG+YghUV1gGRoCTn44Rw1LJNi3Yfe/H4o4pcvo7e8UVgxt6ORC9On
         bLlsMinMFJKbHqG2/ncaol/uZyBCTnwN2GkOhozsiw8mx6wZ58jGjB3SkTl1oFrLMRJO
         fS3B/tzYH/Qyls5CZ6VVHfYArNwbrL/yDff3rwKs5N4PpcdkANGCLvgbfsyYSXaRgr+3
         93JVIZ5SxSUnJRJwP6lDCvpj3WTlj+jMIS5SRPiFaH7E03T8logkJFZWGzEl2YQM+FVR
         XVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541865; x=1787146665;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S2/eW8js8WPIEzN4muuCXfZ23ENIccFKrP1Pa44pPgE=;
        b=aQgNGmdSzBfPwj7Z+lyT+yG0H6fAWVhzzKiiWhm7cNWS90SQyLULJyqEqGERPsFOsL
         uQwp/PGFP5Y7HwC1p6NTjldecG9pUsg+Wdl2iUJLljbAKB6+pPjjzdgFW0VqG6O/DJQ/
         Et4oGbcEikgZ6Yw8bl+1bFoVJMFlaxg/ED9ueroNXOTsLBkT19amjWOtAx6tGZC8b3JY
         FFew+vrWbl8+ZBvqIoYSkQ0EaIZRifg2MjZQbqULvA/izpsrq3aRMzeJnwMu3pOFshT9
         I8bXEFRcsFvy5Uft+mVQVM6n2Ps8TY9Q952HqE+OchPPYK0Q+ty3/CIGpUf652D1DXSQ
         9arw==
X-Forwarded-Encrypted: i=1; AHgh+RqOX4ouUEJ4EFF1MhgEAgFGrX26qmMdsqlQfu5GwM52ilvfAJnbtRNPhA/iQ/pycol0poXtWDCNkQ==@kvack.org
X-Gm-Message-State: AOJu0YxEHK0Sl9QADzKGoyP5bVFQsnA70r92DhM6fnUnBBiB1+HoLIRt
	7Mwbq3R9i3vKgd5Lr9+LXqRGkuPx+qXaS+w5W8CnG7VjwzBj6/svqerwjXr0QtYdPjoa3+mPA00
	MIWmSnsYFTiBw1/AyqsJAlEdKGlEm+v2Dhq+h8tpL
X-Gm-Gg: AR+sD11d/WuPg3T/Bq8Vpi8hih/YW/kPxB03y1qhOZzofmFarkwHahXXs7w7dUpBchh
	D3ByanCnBcRmg7ZGKXdTD/sQZBV0F0p7dIXHfbr7Y6i+bMDPsVoXbAwfApCrZhfDUVug3fE7kNj
	yxTdgjUQUB4N3eAlFwug+zjUol+xMKy/swttKMsOCxYeCBpYFuZ9gExVBTuYnOc3C6uKQbGQP7K
	rhJewQamI1EFymzg5jaRh08GC73jsO00+JC5F69Xie2jKm1BpRsZyoo8KRNctVtp2YK5WBi83rw
	fiS7EC6cnBwmJ2rcR3nrk7MHDyi1T2M5tOKuIHZfl9HDLg==
X-Received: by 2002:ac8:5716:0:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-52d61f7a0e7mr18935971cf.12.1786541863881; Wed, 12 Aug 2026
 06:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com> <20260807-gmem-inplace-conversion-v10-14-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-14-2fc18ee6d3ba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Aug 2026 15:37:06 +0200
X-Gm-Features: AUfX_mzUD6PeEtmKkDfteoyWkYyMiizOHZtVOuf49kBLBevxhRMZd8gNAqxz5ac
Message-ID: <CA+EHjTy83rq0m5=QyPKmxPfFkc+kHzzuY4mV9nThdguW41Ws6A@mail.gmail.com>
Subject: Re: [PATCH v10 14/41] mm/gup: factor out LRU cache draining for folio
 into lru_cache_drain_for_folio()
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8120B2000A
X-Stat-Signature: ji46xedfc5nzyfg43n48a9bo6ddb1tyb
X-Rspam-User: 
X-HE-Tag: 1786541865-243160
X-HE-Meta: U2FsdGVkX19WJHytcDfNtq1nOztQ806yFYuumO8MXThbcW4mq7numUWJQMH842wRt+u3JedUVuhXxIa7m3M/mycPGHBAUZyVVU+RJJd+MtJdPMJf8KTQ0OdyJOOvwNMZUE3rhmCnLUM0Cx+KW6xH5uDgGvVWabF5j+7tIoNQXvGk3JeYoRBOkeuv3lr5XY1YX9xr49lxSdKBPF4xHAaSxN21hru0+0OUXFTmbgeZXRnICLVS9l6YWy/5ifBBAHJfusQ9eL4qJRklhcDiqr4JHK0btaieYd/ps65qyxCQQRQQrnMwnMh8mQhT8mXvhuIgMcPgJvIT6xleqZjPMDAfCbYFYlo7iyZJmgqQoNTNndZysl0+qHajjaG6mteWwIXFPLVBvTt/fRBa3k+galYnLoE57VDdFKucxxYrABDs+xdTC2nN3Y3+SKBTFRFdc6Z8VNIXKfquuDuGJF6zBfJTQIYMkrDqSiBeGzCmgdcBw7/uMyGzNNuFSZlHk4wEWHDk6dKKI/Gj3lqj7qyJf8WDWNjNcr2AZIKke+YKaerT7uEcNJ90KraPBbh75EGBCrJcZOy+pTk/fWe2yaOeudh/N/yNr9Lve64cCo8Jng2zhi9tE9YGCxWY5FwQvxhmtyrVey2NPwkETT102DHCJDZm/N+nbzvJDZ0/NPaDGTjPnCic8WDGOIUXl5NoKlg2kfC8CBAzBnWXVhq4/206FHu84IAnFLdnN05tom/SOfUbpPUZkliGd/HtINWhKivfCd5youx7h5PztS5DO8KR8dhY7wB+n2OLNx70LnuVb1rL3hthxqydButlKMnkwAAgxZP0nUAAbKJWws1bLD/xwMPNDB5d530D7Xxc9YQ0AtC5awOZXCNYMw0z3kGmZltg+zrg3Qv4N/iYvpm7F5kk1U1IW/m6/w43lk+zFLE851eYvqsT0bcuHRVsGmdM3W+nI9epEFl5yil3nBXio+++8Ym
 KUHbcdia
 e1b1MaIG1+2tfEj4gux31KzX6srGFFQTS1X3dBgQ3b1IIwdQasGXp6NeGRjZ5Gc/uEN49OqL1U6zU1XJRnviH4/nd4p0/ghwXM4+pshiNfHW37R89NGDC7x7RfNIAm0CGk1LsymtsEpK/O4tJI3OuK4gguwP4pR2KIMZa2mccNCqnMPNwYy8Cw5blPuQtyX9fcILJdKUAXdaCfoysogw7U/ktF0M0Rx1sJeyZZokJvDozWAmvOXUvgRNi1Wfc/crq/ndhh1+IRV5pyXKYdNi7AiGnsQOmw/EfzGAN7jaNoV67aDw3bYvttGTHUZ2hITAr7f/HENir77ZIeXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 at 23:52, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: "David Hildenbrand (Arm)" <david@kernel.org>
>
> KVM with guest_memfd wants to remove any folio references due to LRU
> caches, as it really must only allow to convert folios from shared to
> private when there are no unexpected folio references (e.g., from GUP
> references).
>
> So, to drive the refcount down, it needs a way to flush the LRU caches.
> Let's factor out what we have in lru_cache_drain_for_folio(). Document
> it, and also mention that concurrent folio (un)mapping might, in theory,
> miss detecting LRU cache references. Keep obtaining the expected refcount
> twice to minimize the possibility. For the current and future user that
> should work, and we don't really have a better alternative: we could
> detect if the mapcount changed, but it would still be racy and add more
> complexity with questionable benefit.
>
> Maybe there is a chance to avoid the draining entirely in the future,
> by avoiding extra references from the LRU cache: Hugh thinks there might
> be a way. But for the time being, this handling is unfortunately
> required.
>
> Make folio_may_be_lru_cached() accept a const pointer so
> lru_cache_drain_for_folio() can accept a const pointer as well.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  include/linux/swap.h | 11 ++++++++++-
>  mm/gup.c             | 15 ++-------------
>  mm/swap.c            | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8f0f68e245baa..e625d64c9e13d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -317,7 +317,7 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
>  void mark_page_accessed(struct page *);
>  void folio_mark_accessed(struct folio *);
>
> -static inline bool folio_may_be_lru_cached(struct folio *folio)
> +static inline bool folio_may_be_lru_cached(const struct folio *folio)
>  {
>         /*
>          * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
> @@ -344,6 +344,15 @@ extern void lru_add_drain(void);
>  extern void lru_add_drain_cpu(int cpu);
>  extern void lru_add_drain_cpu_zone(struct zone *zone);
>  extern void lru_add_drain_all(void);
> +
> +enum lru_cache_drained {
> +       LRU_CACHE_NOT_DRAINED,
> +       LRU_CACHE_DRAINED,
> +       LRU_CACHE_DRAINED_ALL,
> +};
> +void lru_cache_drain_for_folio(const struct folio *folio,
> +               unsigned int extra_refs, enum lru_cache_drained *drained);
> +
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
>  extern void swap_setup(void);
> diff --git a/mm/gup.c b/mm/gup.c
> index bde05664fe9a9..1bd8915517196 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_unpinnable_folios(
>                 struct list_head *movable_folio_list,
>                 struct pages_or_folios *pofs)
>  {
> +       enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>         unsigned long collected = 0;
>         struct folio *folio;
> -       int drained = 0;
>         long i = 0;
>
>         for (folio = pofs_get_folio(pofs, i); folio;
> @@ -2293,18 +2293,7 @@ static unsigned long collect_longterm_unpinnable_folios(
>                  * but also to remove any other folio references from LRU
>                  * caches.
>                  */
> -               if (drained == 0 && folio_may_be_lru_cached(folio) &&
> -                               folio_ref_count(folio) !=
> -                               folio_expected_ref_count(folio) + pin_refs) {
> -                       lru_add_drain();
> -                       drained = 1;
> -               }
> -               if (drained == 1 && folio_may_be_lru_cached(folio) &&
> -                               folio_ref_count(folio) !=
> -                               folio_expected_ref_count(folio) + pin_refs) {
> -                       lru_add_drain_all();
> -                       drained = 2;
> -               }
> +               lru_cache_drain_for_folio(folio, pin_refs, &drained);
>
>                 if (!folio_isolate_lru(folio))
>                         continue;
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8c..8e965c8ce9aa9 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -950,6 +950,52 @@ void lru_add_drain_all(void)
>  }
>  #endif /* CONFIG_SMP */
>
> +/**
> + * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
> + *                              folio references
> + * @folio: The folio.
> + * @extra_refs: Extra folio references held by the caller.
> + * @drained: Drain status for batch folio processing.
> + *
> + * Drain LRU caches if the caches might hold folio references. Start
> + * with a local LRU cache drain, to then drain LRU caches on all CPUs if
> + * local draining was insufficient.
> + *
> + * This function detects LRU cache references by comparing the folio refcount
> + * with the sum of the expected folio refcount + extra references held by the
> + * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
> + * cache references, and there are rare scenarios (concurrent folio (un)mapping)
> + * where this function might miss detecting LRU cache references.
> + *
> + * If @drained is not NULL, the function will avoid re-draining LRU caches
> + * when processing multiple folios in a row. In that case, the variable
> + * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
> + * the first invocation by the caller.
> + */
> +void lru_cache_drain_for_folio(const struct folio *folio,
> +               unsigned int extra_refs, enum lru_cache_drained *drained)
> +{
> +       if (!folio_may_be_lru_cached(folio))
> +               return;
> +
> +       if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
> +               if (folio_ref_count(folio) ==
> +                   folio_expected_ref_count(folio) + extra_refs)
> +                       return;
> +               lru_add_drain();
> +               if (drained)
> +                       *drained = LRU_CACHE_DRAINED;
> +       }
> +       if (!drained || *drained == LRU_CACHE_DRAINED) {
> +               if (folio_ref_count(folio) ==
> +                   folio_expected_ref_count(folio) + extra_refs)
> +                       return;
> +               lru_add_drain_all();
> +               if (drained)
> +                       *drained = LRU_CACHE_DRAINED_ALL;
> +       }
> +}
> +
>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>
>  /*
>
> --
> 2.55.0.654.g21b8a5bc05-goog
>
>

