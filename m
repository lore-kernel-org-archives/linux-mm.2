Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D520CD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF886B0092; Wed,  3 Jun 2026 08:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7006B0095; Wed,  3 Jun 2026 08:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF40D6B0096; Wed,  3 Jun 2026 08:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3D846B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:08:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 977ECA0368
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:08:58 +0000 (UTC)
X-FDA: 84838480356.20.8CCE6F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0CF1100011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:08:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIQ101iR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcPvlsJ3ZlZ9MeuQiLG4OrJyUMRTqYg7H9gJIZrjyk0=;
	b=T5VZxJ9lO+m2od5bC/g52No8/ISOoINka5++95vQv89PpX5tnXYIespv8ZCjbCre2Yh+qo
	CYrEb7Ms/8VfxQi1uX6miHcAQcL52SkHnH2O3ueyXXEwFlcKxPfBa9dh03Gn+bhmxiOnFL
	rFbXyieK2yVZJCSpyLEGNhvftwvQG/Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIQ101iR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488537;
	b=y9hs6XBWa/yhpUAKXqngU69v3gvudBqUanVrYG4LxojC9imuIK+b3VBi52h/+w9LpMjiPd
	pY+wx4XUPDa4o/crfakEAlwj6LjEzCXv75VeqrI3DWlgoIBvm7H4flvfT8rza7iRm95aRC
	dbGnXn+aBmhtxodqJ/57MpaA1l6yDzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DEB644286;
	Wed,  3 Jun 2026 12:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223971F00893;
	Wed,  3 Jun 2026 12:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488536;
	bh=bcPvlsJ3ZlZ9MeuQiLG4OrJyUMRTqYg7H9gJIZrjyk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eIQ101iRBsPA6N5XS3Ycvye4F2+hH/77n6vCQfOfAefxiXa+Ak4zxKokck3yet1Jv
	 OVAglGKBVhX6K4ozK5sODUtWd64ydP3XayR+Wyw/nlJkyJPeakio6DcZbUcV/ypnWZ
	 9hwnbf6vZFuzOf6zBhZnjEtyzX2QNWg0zLP0A+aNbKqKP99o7SvedRM9NQrZY0z/hM
	 c6V3C3bLoEpYrL1zOk7nl16NnR9kzDIueuzRlmNhuShqG0KcGCzRO+Rz42uUVUxX8t
	 n8WoRwNBA2QzAqlUdGFFbSiIg/ghe3J9wqPBba7kyz4Yg6gR3cfdOEsD/WaWUwNUnx
	 Tcvz+fafqolZg==
Date: Wed, 3 Jun 2026 13:08:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	pfalcato@suse.de, vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
Message-ID: <aiAY9FiHthu_CwIC@lucifer>
References: <20260602172247.279421-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602172247.279421-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bbpm9xmi9sganh4kmccrytdkkd6nftgj
X-Rspamd-Queue-Id: F0CF1100011
X-HE-Tag: 1780488536-387527
X-HE-Meta: U2FsdGVkX19bjSptce2jCM1SJDkfFzFZl82BRmo0LnmnpNRnAFenGzU3/UZRgUC1b1uS972KoGm9oze8sLsg7czGm25a2zGoNphfYOv3UjkLJ0kq90VI7FXjwF0ygppVPswI+vx02pKUDxLVFrHAcR62gr+dlsKvrfG448tASj90G/I1aD+KDz1feeRRdW4aF9BYL4CcRoKnmkqbeVPWb5nS91Qp4PFu65/EXmv8amzJOsbDH0QV698bIDXj7j1C97TMejN/eILyEox5i+baNNpifKb0N40FhW8vhX3weu9UlvGnIEPWm/jgDjVRnf98gQEQmkfn6CZ4dEzTGIycfvzRtbi53pQAsu9CrOP33+LXtgrMbnn3j2JEEQztJ8w3ECc+kEJLtLY82Qz5nt5+9HbJxfWccTRSDyy5w7IYI2nNx7EOyfK8uMrwO1XvAGlCn2rbIz+kTRV8ybLmO529IFfgQG4Rbo4sT6II9o2w9IsL4KDuOeOSaN/3Irf/9BjTg+g3NsImNtblqsNDh3twN+pMYf8ZZdG+AxLgphvk4P+WOc9rGZBv+ueyVJiKV0+7FLNTyndKYPJ+4zX3LkPFllEjf1IVqwFCN5Nqifdk3202CbPdxD491mhWBHWu4cVKt+QuxtYbxoG1VH6d+capaBsRX+54eFMyDqRbfg4LByng/avwdbnSe2fkXoPEP+5Cu0g+9bvG3yd32Vw+wEDCF8qz0wB0NwGxgROFQ0m9UKG3WTYYTRoZLMomx3OHPJ99Mx72Fd4WVjUcVDk/4ZwFpIIEUAzK9h4lQJJBZ1kmlB/CefIpFnzkRpsadGZfSERzu5pLW7KoNrHK+WZGs+BXYFGVEytSFFiI6RFOs3b84jX6NIOXrs//aJAu7qV6ywqi4qQOgJ3+TokerOpP49mLYJzKo1UsvLhWb0I8OT7927xiQhK++OlyunxCr/nHlvCz97FV2uH7jNmkoU49t7c
 rVvuYGFF
 0yk2OFLpykBzxHU4P1xP26ICPiUl+ZfcLxMKHYYqrkuO8hc8qipoFI+kPM87d+nc+sgCgvVYhEgvwsdrdxn3ZOX3l2W0IzLBH4LNbL+M6qQPoja+zzOo15roniSKPU7qtEMhPQv7vj88mhPOIe1O2ckL0DTQtL8STu9iCmbe811Dk6D5/BhuKU5AXypHbWkVQW+gQsaIBfTDcsQKDTi3ibXXyU4f9H+9u5h50g2hGVA3adjPMc4ru+RcD5tBCb2Fi+F/phoadYzsxotAqWgdnQ6iyzePzAZhsgWMkyY4EduXEtqTAOyESFSVPmJSNqe8Rw4jiv4U/AyNfYue7hVTNs37qLZ2jWC1jmAZa4sGcgNr6cOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
> mincore_swap() also fields migration/hwpoison entries (and shmem
> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> return, so mincore_pte_range() can spuriously WARN and report these
> pages nonresident on !CONFIG_SWAP kernels.
>
> Move the guard below the non-swap-entry check so only true swap
> entries trip the WARN, and migration/hwpoison entries take the
> existing "uptodate / non-shmem" path.
>
> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Logic LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Small note below but I think not a problem.

Thanks, Lorenzo

> ---
> This was discovered when working on PMD swap entry series
> (https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/)
> ---
>  mm/mincore.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index e5d13eea9234..296f2e3922b5 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -64,11 +64,6 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>  	struct folio *folio = NULL;
>  	unsigned char present = 0;
>
> -	if (!IS_ENABLED(CONFIG_SWAP)) {
> -		WARN_ON(1);
> -		return 0;
> -	}
> -
>  	/*
>  	 * Shmem mapping may contain swapin error entries, which are
>  	 * absent. Page table may contain migration or hwpoison
> @@ -77,6 +72,11 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>  	if (!softleaf_is_swap(entry))
>  		return !shmem;
>

I guess fine to do this after software_is_swap() because for !CONFIG_SWAP this
will always evaluate false?

Not a big deal therefore I think.

> +	if (!IS_ENABLED(CONFIG_SWAP)) {
> +		WARN_ON(1);
> +		return 0;
> +	}
> +
>  	/*
>  	 * Shmem mapping lookup is lockless, so we need to grab the swap
>  	 * device. mincore page table walk locks the PTL, and the swap
> --
> 2.52.0
>

