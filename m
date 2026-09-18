Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2A3C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871A66B00A1; Fri, 18 Sep 2026 09:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8495C6B00A2; Fri, 18 Sep 2026 09:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786DD6B00A3; Fri, 18 Sep 2026 09:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58B156B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:22:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A763E406CA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:22:07 +0000 (UTC)
X-FDA: 85226946294.23.9DD97BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04140C000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:22:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUjS4QLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXII+Q4kZ59ziwT+f57cW04XNzn9YSEFXSVEdQXYv8E=;
	b=q9+5N5In627aDq1M6IPqwp3T15NwVZLMrb7iH9bWyaPF2bN2jlaLEXXetB9ByPq+Z6JOke
	hjSvSL8UBjsGd6aDz6izh9+u7nXg+4B9yYTxZT/qp0VvyHM1ZSDBQ0EIN6Rt6SPbl8Rzbh
	WNKh/NsjSEKooVSFypGJgIa2HlI+Tbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737726;
	b=l3ZjWuSs6hUBkdGG2GQNiv5qhFNZs9Tlq59t6dDuKlEwXPJYtWQjRC1eUv8/yac7JwRo2M
	JSmms8Ly7GhAYhRc9o/v7gJWfrQQ0xZ+7mpRpNKWESnQBEpmdO5JeimLqCLoRBxSd7NkG0
	6kYb/PEa/1X9ZAbNF+8GJPJdjrlFV0A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUjS4QLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20B3A40417;
	Fri, 18 Sep 2026 13:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489711F000FF;
	Fri, 18 Sep 2026 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789737725;
	bh=JXII+Q4kZ59ziwT+f57cW04XNzn9YSEFXSVEdQXYv8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aUjS4QLU04DUHHmNztLdm95g6DWY7n8ihJMtYkMjWMJ/ZRGha9aL3TXwk2bTkp1wM
	 zRr5g/TzqAPfdwIYoJdjC3oCCIvW3L1yV8K3Oa929JgHjUtjMsPVoOt8MR03KDQ3fU
	 mRuhOi1x2NVG0KbnYm11d96z1qPr2j9mo25lKdf7coIXO1V1EBhVlgbwEyl2bu/ePG
	 LpUq6pyVlF+LGbWu+XFNzCtMvQapYhlJrNA0WMlBmUKKRymo+bWMMVn2WPEAwIpSIF
	 OyNdZBs+USGUULCcAyQbb+8My0kPtU//nwYIDQCAcMKH5SCBQS1jVYlfjkZVziVik+
	 hHuZJJ6gvdhNw==
Date: Fri, 18 Sep 2026 14:22:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Constify arguments in default pxdp_get()
Message-ID: <aq067wpXbhL1bRqK@gremlin>
References: <20260918064928.793742-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918064928.793742-1-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04140C000A
X-Stat-Signature: zsqfr95kf8xz1bgg7p8hg1jahzay6p5j
X-HE-Tag: 1789737725-300878
X-HE-Meta: U2FsdGVkX1+FUG5AoTDSeofF4vQaCfZ+SLtsqrKHtOID7+YMVPVHHJrCyuL1E2ckAUtc/Khg50rwuArtrcJzk/G4Jz7PlR/HUCi+ZUIMpXmxAnljU5IQ/trCl+8Ef4AFyqS8q8wgDwgQM3sEob6ZbFU4Gl7h+a0nxadQxqSAFazHXDlsZpara3VmaGigRXKFxg1yHtDWVz0jM6Nz3GPxN2HWc4g27aFctfKwGa2TBgDRQ9P52LJi2QpDAm5wNDp2s9GR5YzJ/46Z4lI00j4NcYMgZm3lMRa2G0KcFDOQD2IAEhc5qImdiHgOwzE2CUVHKPoJj0VePAP5jbiTdcoT9/F+O2tQ244iysMrvynRn7Jqkm5T+Y/vgnxpvypnNR4BKd6ZR84pxcyxCGw+qlZkV9VG1rYpx01i+kd9yn7g2tH3mHpEWdfNERe+WozfweE6dGFmpdH0HOQc/MLg+wnXoSKKlkk6BAz2mHR4qo0Y5Nyhl2PZD17gL8IHFuRg5elKUe0lN6yczbmjMKIugfzUFzKq7NSFw7N62qu9qip6XRqHLiUKLXmwKDj5eUxVcG4MFZCxybmUQOAQs5+qmiZfR3dY1E6XvmLyviqcZPmMIv6QB278Obybvi+yYTXJVkDEQ6o7p4O9z3kjC0VbEoyAO7oX4GDaNF0moqChKUtnZmX2vA4Eld27wqD0kC1JcMmXYPZJkzE4aoBQfak/RnTlAd+9xFu3txdt4P3ea2LCGF4RuxYZo110OZFWJNWPak1V3XN21rnZ39i6AMNl7QwDkw73/rllRKqH1116y9u48NE5j44cXiSs6ZlUmWug1YIFmF2VW+6QbpGWW+Qj12a/P6wMeGmH+R2ImCI0Lzru4uN0UYt5yHpqdJkp2qmv0t9QYATbGEyRjFxtloULhmYBmq5hJJwcruWEeZYN/JAcsSEj1UBTz/3vNyFpLwb16WTzXjowS3IKuhfuoAtGm9M
 OmgsR2sR
 a/o6uGIYCz7oHNgirGw/m/QH9QviUjkPG829AZMRWbT+QJ3C96RB4Sqwx4x4quTB4rsgjIaNhCDrvdwjcMAkEJp3yjl7VIx9Cf+1aKUuZwODTPeffGfPoby7vF0zh73C5pa3otTp++I70AZQWd9rolpEwerL9hRN1Iux5duJOVfzStL8PxB92/nOIDPEbovtl2wCuGyEsC436hDDI8pUhtO9XnT7/LZW8vS+puMYUYprTRSMWpCEoJKyc3BXL7HsiONlSdHrtB8WA2fMCxy/flBoG4UsjFvhcmDIUMNJI7sjOV8peQUeAciEoqLkdC/XAunJllQ1ZGBoUiyk9LFJVIynv8KXoxSJojE/C3KVZYUNhyTpvErQFffhA3Yz8g7sQHbj7AjE08FBBntIzaOAIekpimG9ej6MY8VZ4rt/eHVxRx5XK7P8uzbPIjHGQ5TmkTJAhi2SneJ1tlTMTXnU7IYc+lnz2GT7QAd9S3OKJ/rKqNxHiMO5MVjd1Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:19:28PM +0530, Anshuman Khandual wrote:
> Generic MM default pxdp_get() helpers fetch the values contained in pgtable
> entries via READ_ONCE() without modifying them. Just make their arguments
> explicitly 'const' for some additional protection.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> This patch applies on v7.2-rc3 and builds on many platforms. Some earlier
> discussion could be found here. Platorm implementations for these helpers
> could convert into these "const" format later if required.
>
> https://lore.kernel.org/all/yjqldpl7il6uqfoqrszaopchqthhlffssprmlqjkljvpkbpwkt@zetb5hyvllsl/
>
>  include/linux/pgtable.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 2981e386da7b3..f09a91ff5833b 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -490,35 +490,35 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #endif
>
>  #ifndef ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	return READ_ONCE(*ptep);
>  }
>  #endif
>
>  #ifndef pmdp_get
> -static inline pmd_t pmdp_get(pmd_t *pmdp)
> +static inline pmd_t pmdp_get(const pmd_t *pmdp)
>  {
>  	return READ_ONCE(*pmdp);
>  }
>  #endif
>
>  #ifndef pudp_get
> -static inline pud_t pudp_get(pud_t *pudp)
> +static inline pud_t pudp_get(const pud_t *pudp)
>  {
>  	return READ_ONCE(*pudp);
>  }
>  #endif
>
>  #ifndef p4dp_get
> -static inline p4d_t p4dp_get(p4d_t *p4dp)
> +static inline p4d_t p4dp_get(const p4d_t *p4dp)
>  {
>  	return READ_ONCE(*p4dp);
>  }
>  #endif
>
>  #ifndef pgdp_get
> -static inline pgd_t pgdp_get(pgd_t *pgdp)
> +static inline pgd_t pgdp_get(const pgd_t *pgdp)
>  {
>  	return READ_ONCE(*pgdp);
>  }
> --
> 2.43.0
>

--
Cheers, Lorenzo

