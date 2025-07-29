Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172FBC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A982D6B0093; Tue, 29 Jul 2025 10:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FD06B0095; Tue, 29 Jul 2025 10:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EFA6B0096; Tue, 29 Jul 2025 10:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 876826B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:11:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37E3816010F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:11:41 +0000 (UTC)
X-FDA: 83717490402.18.5E3AE12
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A972810000E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:11:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmU3SvO5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753798298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1ElpNfWetAncubBW4nULK43vxREFUQ5PC14/2hrshU=;
	b=lq9WL3JcWL/qF2mfkzrDMaRcxmlrYq52N5nRjpRUzTgD+MWpHx8fBBCjIFoplqGlA+QeXh
	cWhAGGPlYuTx8A4voUXVaCNTo+mZ+XqKU85hcQ33vHnZdd2mh+HVjmUInm8Mqz6BBU0OeH
	67JifMICTbeO56cUlqwF7XxFb0knaRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753798298; a=rsa-sha256;
	cv=none;
	b=TUSNlSMB8a3hF8dKCvQQ7hm45cdxaRhUPIVnw3mtWGWKRWz+qRUbUmEr4of/nz7dVQHAmX
	UNd7ijZMr/LevuacMDUxBGDs1C6g7rtaL7YQ6FsqfS/w5FPmnfycbAEA/SeucxcvVGFpe9
	RKsRZ0mXv3pbEfz5pgCw9NDhELMSBq4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmU3SvO5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753798298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1ElpNfWetAncubBW4nULK43vxREFUQ5PC14/2hrshU=;
	b=JmU3SvO5DjLynfw6Dj/otMlYlkwV2EjggTnJf9BrykN+auDet0WHpTgmpVusymNvS115z+
	gmTWqvPsb2mBONQBI5vxPEOEdatzU2jWizH/mDFJLd1iwB+EJvUetVNtV9A6ZofjzcoFTR
	kdc5e7LqaGrkmabZ8Fgi4EL+dKgJVoQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-AB_hfwbAPXeh7ZorCyYL8w-1; Tue, 29 Jul 2025 10:11:36 -0400
X-MC-Unique: AB_hfwbAPXeh7ZorCyYL8w-1
X-Mimecast-MFC-AGG-ID: AB_hfwbAPXeh7ZorCyYL8w_1753798295
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7865dc367so1634314f8f.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753798295; x=1754403095;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S1ElpNfWetAncubBW4nULK43vxREFUQ5PC14/2hrshU=;
        b=CUXv39wHCFEJ8PvNztVfBQ4RM/AFiYz33Z9PKi/Z0/aaIjyp8eCfii64W2tuAkoL88
         0bHyoSV1Curp/duY2OH02Kh4r5XKY7FrP/vaHnRWB5oMCkCztaI5w0kzocMMXcf+KfQ5
         vj2qflTWNbVBxzGdt/vBqwzltepK7wO/cyxemk+Y8V2fsW+7+r9OBVOT76fq55x9nxLH
         05AP25TIlvWF/O4urYHP2G2NRoUM+dw3EuoVz23C35b+1g1qxUSI5cfPdKV65tg74pTh
         WraIy4oZohRfqohi0yOHfrBYfU1NoNdKH0LecLFrEkHw8pdv04skmlS95tU6I1bAO4Fz
         oaXw==
X-Forwarded-Encrypted: i=1; AJvYcCVaXYNPPFW2KBvaKFmLz7/xyipgRwSgC8Umcc1+d1YTL6B6BK7D7TFSujR9jVZAiOu3nptvqMFweg==@kvack.org
X-Gm-Message-State: AOJu0Yyh4FHD2T1tkxlYhC3ZrYDESce2sEWFF12Srrt+ryTPjzrnAeM6
	hZRjvwpqDdsYSXhBqgtmGLndGY9S8IWsVwS4nSjk4EklL8L2+Dxkb+zNxXR+pEVplKhob7WeeNL
	GpMzvlT+c9N5m3/25liGflRDERx085WDhXmDpU+wsOrUp+SMOJjht
X-Gm-Gg: ASbGncukVh7EWiDqD4cjn+d2IAuL7xc/NfHLStbSYnkzVCX2WK5csEZtguayWagdhyr
	VHOMoL8FRAwgbD9aHsPWwqfPBIvjHi4PxC7nTF5J2WttSRm5cSqJKGf1ZhO+TMGgobkLjWuIi1J
	JGMor0VWB+rmoei3Xjlwo89eC6y3xwpLNfZpQvQHKM9K2N6acAzoxZxaioVxyo455FJxLNXk5We
	XpPbiAu1eLhW4V9EyuUEYqmM6ynay1kNgtfdARXNa7ehQGF2xnN+Vefgkx1GAUqRnlLWBCQBZd5
	yrSa6eJzZBG47PMjACSciHjUhpIDswM1QxPf8niSnt96adOFmKv55wvUkOgS+e1LZy/Omw0U
X-Received: by 2002:a5d:64c3:0:b0:3a5:298a:3207 with SMTP id ffacd0b85a97d-3b77678d462mr11705407f8f.48.1753798295088;
        Tue, 29 Jul 2025 07:11:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErQBVNkKK40UX2bTpHjNrd42cFNcADA06bXXRBd040/9oIvyVblwFNee5lBXdHixIuozTVFg==
X-Received: by 2002:a5d:64c3:0:b0:3a5:298a:3207 with SMTP id ffacd0b85a97d-3b77678d462mr11705387f8f.48.1753798294683;
        Tue, 29 Jul 2025 07:11:34 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778f0c866sm12128869f8f.55.2025.07.29.07.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 07:11:33 -0700 (PDT)
Message-ID: <0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com>
Date: Tue, 29 Jul 2025 16:11:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/damon: Add damos_stat support for vaddr
To: Yueyang Pan <pyyjason@gmail.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1753794408.git.pyyjason@gmail.com>
 <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <44a30f700fdcf4470318ef5cd248ba98c59b77a2.1753794408.git.pyyjason@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AVWMl5y4zIH3bmc0i065X6aTOpZQV_md7YQDugsysw8_1753798295
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A972810000E
X-Stat-Signature: wuxuqdrf16xeignpnaao3roqr1jeb56r
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753798298-728764
X-HE-Meta: U2FsdGVkX1/Yl0Zu3JJKeFoOMEMPUjN+qD230iyka3a0Ob1Pi6koB8lxJLep/6nixoYNE4cRlShhTXH+VPinJltcgqIMLCoKcJtLDhBibwgJOaXJlk9dCnkq6BfvO12zg19PdHvmvaQDnamyjjspQg44JnbLFt2/Cc87tciZc+7fnU0QFGA+Af87gBizGbiOWud58X/dn/DAerBS6S+MMrhlV6xyI5KgPHoGymRVNsBjJcK7M6IXRhUA2azIwB8I3S7NL/yyhocy+8IbJzgipOjlEZAs01zoS479k4btmtsi6yOd6AfSwALRMuZu7rxKqwVmeVSXIxqBLsYINiN0OsximVs1AjirxO7/d+zRKLBgaI8RGQx1ArDzb5LqLviiWDo554FrEwLEMD0Ar4WXcE5lbLrVruD9rFww1zYmQAWpun2wiw6+JDANkRvD7Ks9VtFB+refv+6HGkEGut6vjQm0g6u1Cn6d3aWVAc5JdJ6scGnFP2N6qrT57eMqFg4f7b5VImFmUasjaARwBxECqa+b5mkoe0WQmt9xbEMLNY1hBPVTbxoRlyqIyXJveb6YS3muBjte35iVIu/ph+r8dg5h2dpLSzKHDJX7jIomE378yf5FrsBpAE1pvzxxUrDSpEivIR5zIrLGSXXbfVWA/qIHAdCVGL94d/Y3+1Omexi9gRGHXXc7rI6xMlDQaf1cvNgQhdSEPFyV0mPgDxObCQKCMbYGQri6nU1RGgWA6NZ0X2CV9F0iTqooLhHHfrMxqugUcX8PU/w6gjZc+3rryhHZWv+W5mLQjgK6myCbDKsvfa3v8S5WjDdV6DBPexrfopJ9MKsaFbbPPHacLwKCJd1m25TKRofyX5Dj+h1KEQcgAoFXHIAACbIePuqhA+fQJdyr+9OoTBcn4lrXz9Sz3iE+fu7k7wRmWhcwrZ26MhGuM8OTBZ+sFhgsnJwxaysHyXvewJkOElrPEGlIHv2
 wgWqWiOD
 BNVoFvckKSuotxvErX0Kl2oohmSfgvay8Q1ueZXdifxY7J2rhqrCtx2Pu+gUhNK6pWccYB9iRlmlG2fisNlQHVtYkdtRhj9q8RoL9mniSYXYHvS/b0jKaPwt2rG0DPDtY35dwX8sz9OO62G6vTPVdKHJor82uuaiuajeErKUraEWp789C2LaW0hSFdpCDfJEcW8YpzwTzS5DhGaPA/89F7epl83dtu+BjwcUWaMx8gydHCCg3EO1vNX2MRklJqFtfDWSTWwViY/hQVaEFyliJJXqhZeExgyyNVciQFy/lvZQj/H9O3ECtdPk5R3EPf9b8f0latXGMYGyR6Uy9T1C3iZsXhNIrJ+7o35QE/ZIVExhohSt/d0FBYNMadFcmYr0PNzPVrJovJ+zNT6cPcrcwt/X/w6j3OUvm8NZxKdT+VpXA+imZQ+1BFv2/vUtlvCBN9RrWWxYDlmmYvGeiwVWdqOaC8rzuSD+6WPDmWPXLPDES1uKNcN7T7I5pUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.07.25 15:53, Yueyang Pan wrote:
> From: PanJason <pyyjason@gmail.com>
> 
> This patch adds support for damos_stat in virtual address space.
> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.
> ---
>   mm/damon/vaddr.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 87e825349bdf..3e319b51cfd4 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -890,6 +890,117 @@ static unsigned long damos_va_migrate(struct damon_target *target,
>   	return applied * PAGE_SIZE;
>   }
>   
> +struct damos_va_stat_private {
> +	struct damos *scheme;
> +	unsigned long *sz_filter_passed;
> +};
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long next, struct mm_walk *walk)
> +{
> +	struct damos_va_stat_private *priv = walk->private;
> +	struct damos *s = priv->scheme;
> +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> +	struct folio *folio;
> +	spinlock_t *ptl;
> +	pmd_t pmde;
> +
> +	ptl = pmd_lock(walk->mm, pmd);
> +	pmde = pmdp_get(pmd);
> +
> +	if (!pmd_present(pmde) || !pmd_trans_huge(pmde))
> +		goto unlock;
> +
> +	/* Tell page walk code to not split the PMD */
> +	walk->action = ACTION_CONTINUE;
> +
> +	folio = damon_get_folio(pmd_pfn(pmde));
> +	if (!folio)
> +		goto unlock;
> +
> +	if (damon_invalid_damos_folio(folio, s))
> +		goto update_last_applied;
> +
> +	if (!damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd)){
> +		*sz_filter_passed += folio_size(folio);

See my comment below regarding vm_normal_page and folio references.

But this split into two handlers is fairly odd. Usually we only have a 
pmd_entry callback (see madvise_cold_or_pageout_pte_range as an 
example), and handle !CONFIG_TRANSPARENT_HUGEPAGE in there.

Then, there is also no need to mess with ACTION_CONTINUE

> +	}
> +
> +	folio_put(folio);
> +update_last_applied:
> +	s->last_applied = folio;
> +unlock:
> +	spin_unlock(ptl);
> +	return 0;
> +}
> +#else
> +#define damon_va_stat_pmd_entry NULL
> +#endif
> +
> +static int damos_va_stat_pte_entry(pte_t *pte, unsigned long addr,
> +		unsigned long next, struct mm_walk *walk)
> +{
> +	struct damos_va_stat_private *priv = walk->private;
> +	struct damos *s = priv->scheme;
> +	unsigned long *sz_filter_passed = priv->sz_filter_passed;
> +	struct folio *folio;
> +	pte_t ptent;
> +
> +	ptent = ptep_get(pte);
> +	if (pte_none(ptent) || !pte_present(ptent))
> +		return 0;
> +
> +	folio = damon_get_folio(pte_pfn(ptent));
> +	if (!folio)
> +		return 0;

We have vm_normal_folio() and friends for a reason -- so you don't have 
to do pte_pfn() manually.

... and now I am confused. We are holding the PTL, so why would you have 
to grab+put a folio reference here *at all*.

-- 
Cheers,

David / dhildenb


