Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625FAC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3F66B008A; Fri, 11 Sep 2026 06:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84AE6B008C; Fri, 11 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74166B0092; Fri, 11 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8A476B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:04:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78EB3160189
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:04:38 +0000 (UTC)
X-FDA: 85201047036.11.2226817
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id AABAB8000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:04:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROFJGWxB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789121076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGxseeOS2BtWoFf00OyiAKmDRr1RXqvuTr0ihtThX8U=;
	b=PabCRsUzvlRVxNdSXTNe9E1WB9VllXoCQoiX7D6mHw7jycbq67X/hIKeo+nFUdk8z9R2Xf
	ofRX5Dga2I6bMi9zT2tTFXBZc/acHXrt3uOHZo5DAdDqnju+CVZJRI4i0DjTZ4ur3f80el
	LyS7umv7qqY1dQ/whuyarxKZFZyHsog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789121076;
	b=FlCZAVBcdEZzNJWUkjkVxQgif1RPPBUxMWzDtFJdaOwwlNyV2JmQ4sgMdZ6nuJP49O36gh
	N+ryTpDFdgAPmmn75VYh8lxLX4BgeSKoSx2JitW4/+IJW7ETDyg4m1LlTexg061/d0tyXE
	f9jUZn0Vz9svLpRE3PTb7NanxnM5sFI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROFJGWxB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-398e9698a70so771548a91.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789121075; x=1789725875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eGxseeOS2BtWoFf00OyiAKmDRr1RXqvuTr0ihtThX8U=;
        b=ROFJGWxBHln8BsLTYLA8AdqqaliDC4iLx9nt/DrvDXv+ZuyTaYWLgIPTUu5csjFA7L
         wJ0TSNK3pNpeNz10ch92iL/xUuBcN/labJm5YG5uKe0zuSEqZw0ee9Xg48mObgb0bBKh
         0XmiMcCY9vc7+gpdxnyDQEpU9UUigNNEFQXN7Chd5O4fu3uj69oHfblLLfN+686YLG1+
         rD8fZmtkNZgpKhLl/ym3pKR2iXJ3+z7flwhm7Y1sJsDbMovqz4L5T+seuQVLvhVRFGb/
         ste1nbtQ4sKfGSUQIDCzeEL5EC1IJg5KKUm5nnfxygSyz9ekhjEO/gPFrvwEwtvdt7Lz
         GWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789121075; x=1789725875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eGxseeOS2BtWoFf00OyiAKmDRr1RXqvuTr0ihtThX8U=;
        b=cuCtoz6cc/wjcA50eKCuFb8zopYtDwewx8lsfT/9D+dsLmk1xLzEDjjSk3dXztnrqF
         W50oHYjpK6uBFoDi8v59JylCEOvkPBrHArVlWpiM3XT/ga08XbXkhUitLBk0yIIoVxkj
         uIzLDjod8d8cI/+29Zsmlk6HUdnpFypwLWirpvwc0Bp7ure2O9fFH5uMANlyWmUZssVK
         LIS8XdAQM0UBb+FRC/ZToKYUPwgxSKxHOFG/sr4APqbAaYrZbLXTTRbdQX/MZSgntZX3
         vIo29pW7Z3tYia2/1uC8sUBFXgyp2F7yKqqOanASOqMJ+TRTnBBoVr54++DjjHDvIhYm
         bOGw==
X-Forwarded-Encrypted: i=1; AKwUvBztJtfWsvg8J/FYNng9gnx8At4Vb3G1+skYmwVHhFkVZbu3uYLf4ovNs7D/sqOOMNlmGq5KmBL+TQ==@kvack.org
X-Gm-Message-State: AFuF++lyxDJGDzN3MoWJNDLevtYMRDvHbG8lmZoPyuTYu2TaqKBjD1h0
	3Keci9IaaD5mBM3cFqZJjNBKCAbm19PhtpmhhqI11BUQratjuCAAdBy6
X-Gm-Gg: AYBFou3vUD2iONUYNlD3IxD5YcEU7PT68XKcbPPQKAGrV41zCoUSUlNdbifmKK7L4SD
	o1AQzDMuv/FEvuQMSuvkhcISyVj/qNynVkbgmqQJmXW7B2TSogArgGWIylmNJ5HqhymQwQcSJ/8
	fD4fjV4275D8qM9xHCYCrf055UvGwW6bTCq5ZCchfDKZtlquFLTc2qODw/6yfzCKJNWE1lk9GtU
	CdRsFIA0IobH1l/y+JKSi9+SeoB45b50y5lxF1cqFZPNhSIqq5P5QJRLfh42+RqoOFqQ6beQzQE
	Kktcf2Qzrc5pepAehDuTc8HZk7hIMtTD1YDQNEHgMsFcOWlZSQrUstwVDZRQ46VRgMiSBgJ/2fD
	m8iv6wXcoslVJlE0LUm5dZoNdRjzBfXs2KmTYzP5YPNvz3gjRTnDUqyfuEcS2aBLmXx2BKQgGhh
	cQfA7Xbtj8u3Me+ZBCyV0CdbCe2op8IkHBpVkrTIz8EEynec5UBVbuvlFS+DbMU2at/5zMQg==
X-Received: by 2002:a17:90b:3885:b0:398:c794:ca26 with SMTP id 98e67ed59e1d1-39d9c3944aamr5330624a91.25.1789121074583;
        Fri, 11 Sep 2026 03:04:34 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95864b85sm4681860a91.14.2026.09.11.03.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 03:04:34 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Fri, 11 Sep 2026 18:04:26 +0800
Message-ID: <20260911100427.2804601-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909140408.104699-6-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AABAB8000F
X-Stat-Signature: z4wg8tjpyw3h9k4iu3e4ehwjbxt9rdmx
X-HE-Tag: 1789121076-952015
X-HE-Meta: U2FsdGVkX1/hQYMgQcm0dC4N0KNORsl/5uFhHkvV3DH3wo6NY6dq/vSUyonuSZeqcky7Pi1Fr4FF+MksaKWn7eqgVnrlT38h96tMIOkz5gxsC9Btq407MPjB6EyEgcEX7vl+vUCDudt8b3I3TaGl5vIM521AyQT/dAvil8gdnUnFVDJs7JQhZHUUB1V+n07xoHF2lMsRy3cai1xG0u6vx33jTwLC/Xw3EC6E6SJP+NV7M2GckvFG2Rozt756EhZQLhJLRjEfVyl5dD36gCSobz7y9ng5EYsw7CZ01OJNuhOPjulSE2OUNTabdzNTOP3ZXjAqJhS3VpE8mEIvS3AJjHU0Ftz0ykQndsL0gBtMwNejZiLH2jn836BAjOshwrOHDhZrFysrRI0VtigQs2J6T7ruLvwB1CNM1hL8bQ1V2h8s3Z1ybefsTzvEml/8UTuCZ6J1u8D0z5Nycw9VVCV25AzJAvJnsugkfVnzFlTRfQx6yk2XzWJ+bVv0xU7JSiJBMrgI+01rG80u/lefJ8lO+Y88BdidHCfbdLTObE0E+xkDor1WIWlIJsAb9vzSqPcHNKyRhbJl/ef7uZH4na9n3hZjhZquv7r+WB+JN1XtTmJnmvL7A2htlNG0syWJBNKwg4lVe0HWBRVcoP3QzcGuzNgDNuhdfD5sVkVizXQJ51MJDtwTqRYdSMA1j59VKcAz1nygiErsxLsMxA9/GQLDIRAQZ3GCSACsMQdNs5hiQjzziIgBPa4oAlqheDulHnQn53hy/25a4GiLJz6PbTlKvaOFAYGECo/kSYlhEDU/L4I0w0L++9s9YPKK8b9+8XW5/dVuD3DVHbGGMai35vWV89kQzBpkNOE7fZYzpT9JMxaHOvuWqvNPSvbnymRMw+nAk7j5ZDEJRojG0XoWCJZ4ye0DVWBFZNDKY1bMnBg5Im97jSbjcLKzC2bPa9b5VmR0wpsrg8YhQ5OVIikzFhE
 aGricjD3
 uA2dn5gJkLc2xr6XFyaN+41vjU/A3X4YScxCNsG8sPw8gxc6ciMPW893rf3YaAoPZiSIz8BUfP7N1dW7h4Uytj7/u/mVu/W1fw8B58oCTqHhpVzggy2SbaJJ7pFpntET2zrvaBWM3r99GlB/7ncZcevZUT9wSRXVD5o0G2Dq6Yk71fG9Lvb1veDU7oEiNnLzOKMLXtMw0vP1yv96QSJnTtyAp5lBmGJ5TA+unu97kz62G3BrgOm+rtyVQ7t3L3bMWlBNHApK6hYYcoAZt+OB62uvbWsSNNfTttI2ZzJ5QkErVhtxE6M63/pNJK2v8iEp0BvCgFzSsXYzgJBI5qofG49n2bjoe9qoibBTFX51dW4hVQfO1LkUixUK3ix8vuarOsRqba3cop8maRr2GiIpcgiG6PD9l6BGy3bf6EpbFGWJP9ox/q0tWyWyYb+tCfzIxrS3y8PZbkiFLg5M/NJMza197SN63FetllhJROwL10iS/Y6e9iiz4ovtBwQEk0ng7qIMHnV8rccokvrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 07:04:07 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON virtual address space operation set (vaddr) does not support
> pgidle_unset probe filter type.  Add the support.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/vaddr.c | 55 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 45239f05e113b..9a38dc89a156e 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -522,13 +522,49 @@ static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
>  	}
>  }
>  
> -static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
> +static bool damon_va_young_addr(struct folio *folio, pte_t *pte, pmd_t *pmd,
> +		struct mm_struct *mm, unsigned long addr)
> +{
> +	bool young = false;
> +
> +	if (pte)
> +		young = pte_young(*pte);
> +	else if (pmd)
> +		young = pmd_young(*pmd);

Hi SJ,
I see that all callers already check pte_present() / pmd_present()
before calling this helper, so I don't see a correctness issue here.

However, the other DAMON young/accessed helpers, such as
damon_pte_young(), damon_hugetlb_young(), and the PMD path in
damon_folio_young_one(), keep the present check together with the
young check.

Would it make sense to keep the same check here for consistency?

Thanks,
Kunwu

> +	young = young || !folio_test_idle(folio) ||
> +		mmu_notifier_test_young(mm, addr);
> +	return young;
> +}
> +
> +static bool damon_va_filter_match(struct damon_filter *filter,
> +		struct folio *folio, pte_t *pte, pmd_t *pmd,
> +		struct mm_struct *mm, unsigned long addr)
> +{
> +	bool matched = false;
> +
> +	switch (filter->type) {
> +	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
> +		if (!folio)
> +			matched = false;
> +		else
> +			matched = damon_va_young_addr(folio, pte, pmd, mm,
> +					addr);
> +		break;
> +	default:
> +		return damon_ops_filter_match(filter, folio);
> +	}
> +	return matched == filter->matching;
> +}
> +
> +static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p,
> +		pte_t *pte, pmd_t *pmd, struct mm_struct *mm,
> +		unsigned long addr)
>  {
>  	struct damon_filter *f;
>  	bool pass = true;
>  
>  	damon_for_each_filter(f, p) {
> -		if (damon_ops_filter_match(f, folio)) {
> +		if (damon_va_filter_match(f, folio, pte, pmd, mm, addr)) {
>  			pass = f->allow;
>  			break;
>  		}
> @@ -543,13 +579,15 @@ struct damon_va_probe_walk_private {
>  };
>  
>  static void damon_va_probe_folio(struct damon_ctx *ctx,
> -		struct damon_region *r, struct folio *folio)
> +		struct damon_region *r, struct folio *folio,
> +		pte_t *pte, pmd_t *pmd, struct mm_struct *mm)
>  {
>  	struct damon_probe *probe;
>  	int i = 0;
>  
>  	damon_for_each_probe(probe, ctx) {
> -		if (damon_va_filter_pass(folio, probe))
> +		if (damon_va_filter_pass(folio, probe, pte, pmd, mm,
> +					r->sampling_addr))
>  			r->probe_hits[i]++;
>  		i++;
>  	}
> @@ -574,7 +612,8 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
>  		if (!folio)
>  			goto huge_out;
> -		damon_va_probe_folio(priv->ctx, priv->r, folio);
> +		damon_va_probe_folio(priv->ctx, priv->r, folio, NULL, &pmde,
> +				walk->vma->vm_mm);
>  
>  huge_out:
>  		spin_unlock(ptl);
> @@ -591,7 +630,8 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	folio = vm_normal_folio(walk->vma, addr, ptent);
>  	if (!folio)
>  		goto out;
> -	damon_va_probe_folio(priv->ctx, priv->r, folio);
> +	damon_va_probe_folio(priv->ctx, priv->r, folio, &ptent, NULL,
> +			walk->vma->vm_mm);
>  
>  out:
>  	pte_unmap_unlock(pte, ptl);
> @@ -615,7 +655,8 @@ static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
>  
>  	folio = pfn_folio(pte_pfn(entry));
>  	folio_get(folio);
> -	damon_va_probe_folio(priv->ctx, priv->r, folio);
> +	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
> +			walk->vma->vm_mm);
>  	folio_put(folio);
>  
>  out:
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

