Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D446F606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=uju8lLv0
Received: by kanga.kvack.org (Postfix)
	id 07C1C6B05B9; Tue,  3 Nov 2026 13:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CD66B05BA; Tue,  3 Nov 2026 13:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E861B6B05BB; Tue,  3 Nov 2026 13:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C58656B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:27:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B9B61604B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:27:55 +0000 (UTC)
X-FDA: 85394641710.14.6B5C03A
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5AD4E180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:27:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uju8lLv0;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730473;
	b=BGN1UFWTBjxNa9TObc81qDENtW/7L4wZ+ZHSrhfu3KutTIqdSIlfe9wgNQ+VN1nVff6kYB
	fohXa8/Ct0nWvniVSBCSK3Er5sJ9H2LizY1jRN+h5AlMzlYsGXE7aLF7SzlD1XFD+7MkCQ
	GDhCagGcLy3fmQPVuxDydVYvYo4gYNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mcfvA7HTlPKCM+/9sf/LvHh4ZPDiuqX0+xFv1eaGJc=;
	b=iQIS2jcsCrKLaADGhvvtRWybthcWhl/KFPIc7cq+Iq2vGpCrGhY6o0qro80w70yanwVvym
	JEsqoJ+5tdEBv6VhT9kVb9XhStKJOPKedVQNPD85phMvi1eSWjefhN+2GmMlUhzhz63cZ8
	FEtahY5xhAztsxopXzHZdHwDwEnujV4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uju8lLv0;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0db268bd8so29827327b3.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793730472; x=1794335272; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2mcfvA7HTlPKCM+/9sf/LvHh4ZPDiuqX0+xFv1eaGJc=;
        b=uju8lLv044KAuOxtL6NCMUgRd4B7KUznxCFsz4CZSFpFvccwfeJGTTyRzu22sZWB2/
         E4w2Kn79kJv/d+opj9n21Ji9n0bHywKjPUw1LMVR57Nj8/AFkUEgjNnmZqeBv4j2N/ub
         O5vL17LmVbI7zS98hMzJzoAyjrnzpMooaPo9cUwP+Jl58LaVsf83TWEmtWNW8Hi9uenq
         QYJJwUy6G6O4aUVPLSi6Fkrx+Z47TN92LjTImBsMZwKif4rYIGksO6wKLO2EC81feAcT
         pbcdNSG30IqiONAPW+dsf/K9/jqEvyFlG5W9oEWVbAnAxmTpnclZ7+Hz+SRH8s9ouRyN
         bG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793730472; x=1794335272;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2mcfvA7HTlPKCM+/9sf/LvHh4ZPDiuqX0+xFv1eaGJc=;
        b=XKQOEv26pG7D2tHYRPEeKqikq2ZiJFsxGwZzMu5afdnWxW/lzSTEdB11F0cQQBrfLY
         lczTL+h5rJWuXIui18zyajOa1KG/gwtVNhnz9Lw+xTMINtnHPis6d42WMjYLj1Wp9SDt
         EJG0ubmzyJDxdWe/MU3asOZtinffxwJcp2+zcabb+qA3BoN2pShla0wb434D+48y1EYQ
         DUM3gNZ7fIkWdAP+8oiqaYaGzYeVLEwY6iY9zq3ySooZ8G5cYZSf3MH8xz9ExSxqJrjR
         dVCWG2UobL8FVZIVEOAZeBO+lYZJPY11DcthYrPNLnuZ5uts8MrbNw7oGsJi1VBT3l+c
         3Kfw==
X-Forwarded-Encrypted: i=1; AKwUvBwPFIs4hloxOnI3ylQwbgW3wNpN68D5HwvXqHVO6WTZR6ORefCPyMlRaSCVsZ65l0xA6KQd2tdMbQ==@kvack.org
X-Gm-Message-State: APuU4Z/D0lK7alLzAKjK2qCF0LmylBuBxihBhLbke0XTUoY5fYZwuP8n
	zoNXs4sGFkPdQzREA/+hA8jytnmkS9Y+JrICcczANUg58UYRhGaROirRIm6UkDHJUmY=
X-Gm-Gg: AYBFou2CPdb3dzlGVtgO+Yf7Ztt2CHcMsMq0v9xNYa4bLRQEFyHtdapbeLKKAmZ0rOQ
	2uHIbq+4THJcXhsMP7TpCjp8McSSc7HvqUk9FRbdskNmK9/Me0+U6R9wJ6glRv8HEoRL3jDR046
	RfA9BUppEKZSE8rzAGvB/IxbDPDSE6p9ETEHq8j2NP2EEng7bfn/UQ8w51c6EseqQU8zDLjI+j9
	1GZgceZuRqu22e9hRuOfJ31YIx6uMiLgPUnZm1XkzgWK8FWaVF2JwgLbEN8jy2/rELL8nZQarfc
	5RmfAeS6b2tm+lEIAkkLchYTIQ0FtlsG5dSzj8LYiiuOtns0rQzI+j3+aRxHeFeGVqucnXplVIA
	mnJ2KzSBZYI9+qFZix8R8TIM+DMHdYdteHOrb+8brAM3OjL5936eRIjZsQUs4uyOvrxiab9A0+Y
	4ItMnH2NMtW2GfsKWBMx1wEtyUjGQQ1+AzPwbhnbnDP3VFE6+T2Rlpm9/ZRQcdiN3mIESFq2tl6
	jieYZ9e3P4W/kXkFKWPISIESxD/Ou5Dnrwbuw+NU0WXuVvuKhIqDNP8I7S2x1wcKvLF+wc/1Ql9
	3ZL9845XfVWwmJNCstqJ+a9Nbho=
X-Received: by 2002:a05:690c:dd4:b0:8b0:a37a:b1d with SMTP id 00721157ae682-8b2b66fb17amr85926767b3.24.1793730472207;
        Tue, 03 Nov 2026 10:27:52 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3097117b3sm2529557b3.1.2026.11.03.10.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 10:27:50 -0800 (PST)
Date: Tue, 3 Nov 2026 13:27:48 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/page_alloc: clear ->private of deferred free
 pages
Message-ID: <auonpJVJancOit_c@cmpxchg.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
 <20261103-pgalloc-ai-hotfixes-v2-1-e0d2890ab74f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-1-e0d2890ab74f@kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: fo3bux9hs1cyydsazwests1a8perwfch
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5AD4E180003
X-HE-Tag: 1793730473-37386
X-HE-Meta: U2FsdGVkX1/V7tzqbZ9AIAHZVfl5Nv/c3WpyS8zUsEMpEPEdOVkJvfxSR+cH5dl3MNTLylNnF01yaHKWogTdqkar13uvzgnBzkdxrvRzya5OBXluwwk0lvbJwOEtVMdLSOPmrgOBDaDZ2GuCmx0bq3HZGachKUpuuslJdj5tlRAu4VGr8bVztlWuQMiV7Ty1Y15wiQHZlkXLKnOIP6Efxrye8VP+eYEr3CtZpAZL/25mXLp5kLMFu/aA1jxpWJTlLgJSt6d5zlqPXB2H+vETv5ZPI6FnQ7bNvYB/i9LqOBTy3R4+OoGxwMnPFVZU2hx5mOb44JSC0sBvpKUZaeK049sAkeJq3LWfVx5vNloxOBQ52gTHIgU78853ySUN5gMGnnf+NDK8+7FJDns2gSoS1gNvKTEPZ6fdCzLeUbtkWW9rtTFZD4jVmajua26sVzXqsw5a7kSfTHdUHClyy2PRfE2F8wOOi7g+5HFJ5jzmfw9wco9d4nLHGSUpcWqKOoOPhp0q0L1uRrCwWGVDDclMIhDvTrTaIrUSKBJ5YgYzpeCBcwQ9SPAtvC2SWla299y7KdVNDfP/qtoiuDbE1t/N0b9ybdURGE4gbjGO10PU8Dr7h11aWUuJ7dGiwKC2bAtxjsGjbH4cuwwzPlMIeCV34hc7IGJ9Oxlw77nZTnyBaCplVXkhwy0Ig2NHKikVgqsk2ONN/J6SOvzaOiTCO41AeKcOrHj66uHbKJEgaQq9zDgERoC9Ef/25MTeGVdrjPM8XoHYvKBiOGTRD3FxcMSynI9GEZUv2iRSQLG8h3pFWO9ErCO4mP2LD0xvd2g5g4M9DlnyNagw+HL7nWdsPeL/XGP6GrcmaJB+MK58o0sROXLOGKVpCm62MNUkJ40niVV3sDb7hZEo1tKlnr7eSxxkhuY0oP9Zl8Wj8xCJaIiGAHf/89IXPp73JmMadktHb9ZlrncqyZT2lRifnJaD87Q
 OonXvSLL
 5LUS/SFq1Get7hWW7WS7p8scAtIWRXt84EBPUC9GrSLIzZPrLRWhC1IFabccJ9lBlvLoXaEQuQJuzQULtl4HDZpFJfR9hDqDXL/KbFJgiD+W85VBbYiKmuSchJDZDUFIzCbk5aWkJTjnpH00tXSvgFQG9vGFstl0+3a7dPRnWXGGLWFsqiGAD/hEBxVCifuz/TctFcMdree8vb0NUQbx8OUrLMdeBa1IpNOxoh0ORs0t/PxO0BBULEdEEUHHS2t/KPcU+NKl0DjHNpykX9BIwse8Skjb1YPcWBDiG2Oc/nbOr/CT8cn68BHd/Pp5ErVuhnfXtdF5KayEKTFCX0EZLsW04dg/IWH1vgRGsZf63yNQJ4udyGbikbmoPNfpPSip4C1AsaLRRmIUxC9WnO355uYWKhQOG5ryXo9yLmY/BQ4VJBjUTnydaOVgt3CPCqp2caAcBlEPhg0tJ5h2IIK/0XaH/jiw5j6ghxsgeWUXVzylX+WVKXdhOSSpArM0ydoPiDk88B4vPkKdGe9kLqhEhvYBGwAEjDMOxPJBH5fQVDxe1s6RwfrJmSZzpeb6yHNWmlIRms/9K44oHCO8gyVf0yAJuekkb8YSnCdGrqOGn+Uz0k8rCFtuU8p08SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 05:16:47PM +0100, Vlastimil Babka (SUSE) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> free_pages_nolock() and free_frozen_pages_nolock() put the page on
> zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
> add_page_to_zone_llist() keeps the order of the page in page->private.
> The next free_one_page() which does get zone->lock passes these pages to
> split_large_buddy() with ->private still set.
> 
> __free_one_page() writes ->private of the head of the resulting free page
> only. If the deferred page is merged with its lower buddy, it becomes a
> tail of that free page and keeps the order in ->private.
> 
> All other free pages which are not the head of a buddy have a ->private
> of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
> set_page_private() in prep_compound_tail()") the allocator relies on it.
> When the stale page is allocated again as a tail of a larger page:
> 
>  - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
>  - with the page checks enabled, __free_pages_prepare() reports
>    "BUG: Bad page state", "nonzero private", and leaks the whole page;
>  - without them the value is seen by whoever uses that page next, e.g. as
>    folio->private of a folio which is split off a large folio.
> 
> Only pages of an order above zero are affected. Those can be freed
> through _nolock() by the stack depot (order 2) and by SLUB (a new slab
> which cannot be added to the partial list by kmalloc_nolock()).
> 
> Clear ->private when the page is taken off the list.
> 
> Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

