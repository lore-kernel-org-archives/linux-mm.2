Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B9C606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lTSl3Q4A
Received: by kanga.kvack.org (Postfix)
	id 5FB856B05B4; Fri,  6 Nov 2026 05:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1B56B05B7; Fri,  6 Nov 2026 05:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD3A6B05C5; Fri,  6 Nov 2026 05:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1246B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:13:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EADD11C47FB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:19 +0000 (UTC)
X-FDA: 85404281718.30.6EF8327
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13D8C120004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:13:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lTSl3Q4A;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959998;
	b=sH896jeN8UgH3rDADEbvarDR5uNXeffATRPMSckg87enKrfPYEE7BmirOUV4L2NcDx99df
	NBCs68bd1sFtDHHJqKwkqjlKBinqd7RWuqt9CD4DNIR2VMbnbeGLgYg9YXXwMLATFT0OuU
	X2oy5y+Eg0XVPmpsVc6NZFkMfG/onvs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lTSl3Q4A;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLL3XmqFz5Pf3FaFIovTOe/0d0X3Y15DtdwfOU4Sa2o=;
	b=oIIJpnHuxm0LokNlmSW9Kd/qpPLxv6mHmGZP0iAt+xP0N9khgZy7Y14z4MBqLByEWNW8Bz
	xt2oeDGhw5cZ7JHOdEpJeFiR5/SyIN1jNMA+r7KKsasYM2bmvxqp3QHICqmN4rqCyfM5va
	1mLOO1WZV2HXUHqQiXylJ0AhLcoMJys=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so3728635e9.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 02:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793959997; x=1794564797; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fLL3XmqFz5Pf3FaFIovTOe/0d0X3Y15DtdwfOU4Sa2o=;
        b=lTSl3Q4AMl+jWKyqsZyfxGbEJn+e7el5C+14aC//w9XserE6+VfvYlBjzjAs+9ip29
         1OWD92qR3oxbXFSncT18zUEzN3Jad7NnT02jzXT1/ic51wrA3EuoOGCSsAEZjRltrQS7
         5MsrtLzNOUtgIUFEaZJi1ahfsy6k+B15BNV0LzZDEmV8x4Hj8mu52gpsFCsrIw94hIjN
         2+6LOoPd3268SbICnPlZsibae3Mexjmj90veSkJYScceghsIvL+2hiVe34iugLy/izXs
         Ob73oQMvkaZOk0wnbpmhkzM0U9raDJ1Ns3YaGVplcDE/5xIb9UWc97TJ34SpoxqDuwPo
         ze1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793959997; x=1794564797;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fLL3XmqFz5Pf3FaFIovTOe/0d0X3Y15DtdwfOU4Sa2o=;
        b=xK7v/mMzYnZasTUPQIkeBFPFYEW10cmZyIZ58DvxPshcBUxm534kxLh/WC+LcCYkZU
         KpBa7yIvSYkw359cSVx4sRMitBJRM4NJdIU8JPMPyT4UGMIFByLaruMCRJN3XeEKmUhO
         12Y+koRoPPYCQ/swgsT1do791bqc8Vt1TPfzKmQ3jSL9H5r10rDyMyHtaLJyOST1KQli
         xg7qHb518GbxdL2LK/90siOn6wn56zQUj0hIrHA88pTgfmYa07vjDY6GOorXcfjL7K9x
         elwqO8qX07YHa8997qlUy4ZdbHDfAK7rY31yWDcVzOYlgg9mJHJPVpCUnA6WK225QnLd
         4zwA==
X-Gm-Message-State: APuU4Z9LQlwUaTfUpX8kfelmJTAATP1/9I2h0Ow3yoMMSDAXSVEBYjen
	yJ4s7WpbWmHwScjrj/1SkCC3ixNgMSBhLwFPjjwljNXSqZ52Niw2kIFl
X-Gm-Gg: AYBFou1e327w9ZytZ182ZULexTHNAWQcpfGZRDEI/MVplZNarQA/D1qycnmt0w0VSjQ
	wx919XclAn5b4t4yBrZds+uJan6Fac8a2qHCB0R2KChwAYSr9q/wdNaNzJ+CD/vuG3BlKq7MOzM
	eAkbC0eDT7cB6aWDNXhcnvhLT6ZULHLcP3mVSMYAKpkxkzlohb3btWZijY0/hklTNKCNeHXeyHV
	+uJb3/uw6FqXhbANjV143bEIbiZ4u/4lEUyZZsfheAG+8m51v8x3iE0sCCZsbydDc/qSpP4Z5sO
	uiAvae15+P4G7EaKePvJIvgTKsnc/++tHNKsJq1NWIUgL5dTZUjI9yEEMWer//RQJLqrufJc9jo
	W+qEO7YTplluX8jU9KJvHa3SPG5yelTumLrDG9sO+HvFD36zterurbM6BT9rugTt1b3JNDi/1pC
	gqfXDY39WM+QKdmcRYb12d5jytrQFc6Z48TL0Cx1G6DyX01ulNv9cIdc13cWJR78JTGJgquPDHY
	TTIdNzOyVfASF4McaS6U6iOAoJJqFlvv5o/CHal3OgMYEH0GiaC03Z4/UEJyfnWjvQeFhZ6YqV7
	F36nyfr5h8FeEXFsiKtq1Y0=
X-Received: by 2002:a05:600c:310f:b0:4b6:bb67:bb9 with SMTP id 5b1f17b1804b1-4b6ded4a3b0mr30188925e9.29.1793959996617;
        Fri, 06 Nov 2026 02:13:16 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572bba207sm121341505e9.10.2026.11.06.02.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 02:13:16 -0800 (PST)
Message-ID: <4763a039-60f8-4263-8124-beb0f9ab3366@gmail.com>
Date: Fri, 6 Nov 2026 11:13:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/gup: limit pagecache folio refcount when grabbing
 references
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b9dpw9sd4gs73e3oa67gn3giraynf46s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13D8C120004
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793959997-623768
X-HE-Meta: U2FsdGVkX18K90LqHo8TRFXdPTkJ/QDJJrJBBzBW/Tb9MfMX54Pa8A/xFurqm6QqO+QEmTEA+WwkNjhF0Eji7MaLGIavG63zfV1emRzwdmXM8z5pQC7tynmGf6yfRcZR5euvSDIC+KufcCZN5FSWyM9B4RC2SGCMsSl/Nr/43x4qM5ClfU2KzS8YU56D3VATEL7KFJDDGh4lc9n4Kr2D1Hv07RO0NybAxjpzJPPYfoGxiq1ky6mPkYUB5fqknLtYSiIelAM+dgOExa+aEBtzbxJTz3zeD8OGwjya9GU5RrfHeNsSwMWEThul///dXSOWHZ0QalUSZB6HhTjbbe3TQ4rq3IPlBcnMEMjmdJnNmHtbB0UqsAAzLdO4sS7jM1lhxpD3Kq8PivPdb3tViviz6HTIxEKia4vdq3KHmZMB3xRwHIki5di6nGjF0tlFbpagWnPVPs/Hsr8/a57Y3De2jZhJba01FV+4x1OVaMcnTMjjaIKxrzEC8CoUKf13jxXVthvzDSj7K8FV5IUBW8S1p9uQWiwvqwNOHibSkJ62CqLI/Xw1fezXQFKwPv5t729/+pAUQ08++Gajj+Nt4iE60nx6pTOyxHU4JrX4+nFF9vvh4ftLIwRqGQtV7Y7VzW4hG4f3nLDK689jhxylNCe+Ujrh34/6YKG9owSKBiiUN6jSRKq5DPtCxoT3qpIcCBUGP1G+DRVp+UfitbTvMW7wIcAWiSLNdQAhb7dgXK9DC//fp74YBXTOrABKedUo6OIlSRvamhJBZUtflDeGwjhWXSuTf5AmC6dVh0/xYW0MejIowAjMpNStyG4DVYzABMQ9VHvAogdm0EQjJNc8kbOW5Ae9lnhMtDPPjDr1KTXxkKw4BRh/v1AuckB1CDOLpApHAkEZtpe6R4yl2/rQP34mXFaxaNUj+78HzZWb0pqBNLKCMXkalRgOiCuIVTMJ+hw8LesgT0DO4ltqnM4hO9f
 Ux8NULFh
 0fr5FmXH603ZayHcAn5CWnYpvgsVG9/PK/PwCYznXqYyZ1jgWM+pDr2qSJLMTcvTKm0reM92T6XiYrgIPTEJQHDOFRh3QWfgJwO7xaXPnVTxlbogAQ7h2o8RyxHrALP99hOiD9iYrUi6b+fV6onMDgZLABQ8UdoHC6ESgrqDMiKbLU2mGOfHKQz5tGoS6dnlrITwOJWzZGG6zIykGX5VzrvM9HnJJ0frqKzpaICbMkaJ1idvYFZwq8VK+G2F6wz1DclnftHm/sp1B0EeAGsrkdeEWSzIrgZ9qvVNnHilE28Va+Iv841kVtTW3rRZUqUfJPxhRcwVcAljCXlayw5Nkbs+1DCZFp6gMAIsWmJ37iA/GrAAbX2NJgM8l2DvMRtg+GR4qzatnR570ddwlqXOIz/jAnJKvGlwerRjEShNjRN3T6zhL7ftw3CTGwIS0LPhYlFMD1KfIAM91d/vuoTnbVHAIwyXzRpvVePk+KKzeeIE4HoHJpQe/Xf0E8K/sJ3XR5qDSk7rRaBra1B80Mhpw9Opxq2NnCbivZwDf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
> Let's replace our existing safety check by the new
> folio_ref_count_over_limit() check in fast and slow GUP before acquiring
> additional references or pins.
> 
> Keep it simple and use the check for all folio types.
> 
> Drop the WARN_ON_ONCE(), because apparently these things can currently
> happen with large pagecache folios.
> 
> Keep the zero-refcount rejection if the refcount is 0.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/gup.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 2ab42fc6834e5..db9db6b2a4662 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -77,7 +77,7 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>  
>  retry:
>  	folio = page_folio(page);
> -	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
> +	if (unlikely(folio_ref_count_over_limit(folio)))
>  		return NULL;
>  	if (unlikely(!folio_ref_try_add(folio, refs)))
>  		return NULL;
> @@ -140,7 +140,11 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
>  int __must_check try_grab_folio(struct folio *folio, int refs,
>  				unsigned int flags)
>  {
> -	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> +	if ((flags & (FOLL_GET | FOLL_PIN)) &&
> +	    unlikely(folio_ref_count_over_limit(folio)))
> +		return -ENOMEM;
> +
> +	if (WARN_ON_ONCE(!folio_ref_count(folio)))
>  		return -ENOMEM;
>  
>  	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
> @@ -1482,8 +1486,8 @@ static long __get_user_pages(struct mm_struct *mm,
>  				struct folio *folio = page_folio(page);
>  
>  				/*
> -				 * Since we already hold refcount on the
> -				 * large folio, this should never fail.
> +				 * Grabbing more references can fail once we
> +				 * hit folio refcount limits.
>  				 */
>  				if (try_grab_folio(folio, page_increm - 1,
>  						   gup_flags)) {

this can fail now, so shouldn't the error path below return -ENOMEM like
the first page does, instead of -EFAULT?

-- 
cheers,
jose a. p-a

