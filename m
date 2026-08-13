Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D557DC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28186B01F2; Thu, 13 Aug 2026 03:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEE76B01F4; Thu, 13 Aug 2026 03:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13D06B01F5; Thu, 13 Aug 2026 03:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0B846B01F2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:25:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B008120537
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:25:16 +0000 (UTC)
X-FDA: 85095410232.06.5F5393B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 77A6340002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:25:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haCcH78Z;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlUq6eMZ9dhHSD88qIfXndTiEbaOt83wBNm0+NgJcyE=;
	b=eK0QCwwnj6o7TlFpWLUe6jrI7PtKjgxB4nISES1tFzRKuR2GAsfAiry/zLRMFNtdyhrXQe
	nW1ox/1QH5iHMwKNaaodYifoVBNUfpPqHxxrbpLGjBZb1zspoRM1vbzW5j0PJ8w3Vf5PmU
	GSlz64x6pEkrmRglZrTMiBPZJu6+85c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haCcH78Z;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605914;
	b=M/1AGlC0O6DqkDkVUVjtXOuw4XncLgXiQHJAsS1cODU8dOowElv2xowdsNe16RQbt2OJP1
	cdh7ZFz/xP1cI2WCdr66FLCAJzTU0zjkp98enI6gAEXwxj9+TCl3OZgZUcyF7pW5GaBFgA
	AeHfilzIzC6QZnusvtEM2Xx5LwdWgoQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB53B4124C;
	Thu, 13 Aug 2026 07:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B411F000E9;
	Thu, 13 Aug 2026 07:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605913;
	bh=wlUq6eMZ9dhHSD88qIfXndTiEbaOt83wBNm0+NgJcyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=haCcH78Zp/m539QhWqu+sd7oXAcejudjaL37QL9yWQGnsiobVQeble+LIE9uHZWdh
	 wkZ3PV/mcdhwo52hfyTMQBO1Ysj6eJjhWkRnZoD5Gj75WtgLRp+3EMSQq7XpzeXB6d
	 rOLVKpUYwo7QHTAYPQSDjffNYj2iGRmc8M8+EV/+cPHBoBlIZ7Lo8xq73w68lD7vbt
	 KIGrqaSxgrlPxmUvFn5B6jkeAlUWlYGXajPb48a4hHaYd176H0OBNV6e+4eZQFFI22
	 NMySX+bOPrd0h2nG01qqgGjtyb5wlJ/moLFtMivrUCLyqJsNyu8f8maiZ8gQJEAEKc
	 fInbwEp5x7fnA==
Message-ID: <3e609c64-a393-4667-be74-6cb2bbdcb717@kernel.org>
Date: Thu, 13 Aug 2026 09:25:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/15] kpageflags: Use is_page_hwpoison() to set
 KPF_HWPOISON
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-7-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-7-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77A6340002
X-Stat-Signature: umqie9bsmmr1ufhweju3g7mu1g1xrhr7
X-Rspam-User: 
X-HE-Tag: 1786605914-339600
X-HE-Meta: U2FsdGVkX19I2bHUgpPw5cCOFuKqtmVauLsjcbqMUQ1Pd5h8+x2XsIlSGtgnkiAK6DJKAibWzdLkAq4TlxPcAN5z1SGhBmrFqj5EttvjHsinwc9Ya10KsqLkpCxvMvr4aCgRl9Ox5Z+MVwIXZAW+e+vP/nQf+Grf1V6WEk0WEI+SHPtqWCLzRQafp8R5JojEglmcnHIcwQw0DQ86Nvr22m6FirpRE0ICyCCEWZuHvWVpUDYwr8S8MiUJJFfm/rLgBaHt0/2RhxULMokvl4dqYW3vI+j7ff6hmfsOQiqjZ3hDVAaP4xuslII1oGrZUu3W07+U98jMMfXmpqOrXevyArZF8L/5e8GaRAFqY6OQOD5h873fBpCexIorVH4LWU9FaN+/KwO/VKoIm1PtDnaD3+Yrcw6vj/lcioaJt0dKDNrpOWhWEqYC21frF2yQpHVeI4S/B2J7/wnLAx6/E1SHsN/2bG7nmfUDBfcR8CjPxPX44B5sTbelKMETupk/Q6+t0R9jzNM034Dy84kTCFzwMI0dFreuCuBhadrO5WA3fxpoy977+EmoNlcflbmi42f0I9jirvPGXtlUGrxwsr9QHY9L05kujZ4FUhXuBqP6e2pEJ0v5+GKBcDTqQlryMP9/A5+RPYXKiTBrZOgq8SDq4MfULsRRL6gSfC56ltB0MyQwHYI5obdY3dPJ9DEuEulkjWUAdPTr1HKoIkxVZJ6QXpvMg4dzwBlkQ3WeNU2qI56gWmg6U8+tZOiomT39zHuB6bwVsWZEiaaYnXj4bS3k3bZbwzjluGlWjb9NZZNqDI7xfk1M3d0VTEP7AmsXx0Dzlo9C+DElJKo7NUavo7iDok2NbmWlMuS8EiPyZt2SBh1N+bUXuTC8MBhOMtLAQIDg6DDoheDfHCjHilFf3gRp+oTIxQ+ahYHEbZxXIDLEPghg6wK576r0SwJCMG5ZyvozWmImUY4G9q8ueGCFywG
 JQSMZtt8
 AjMNqAG0Jh6VYPJKfPOimiqRzHWAhPFsupQZe75n+WUEjdUwHNE7ypFLGCLrkDIf6kvdSF+P4m641c5LYGZCrODHt/xv2LUgt+O6WDIYN0BfaY/HbZs0++xMyNKlA19gGc0JkTWHj7xYmLZ8w2IhGJVaC9YnoJ/JQJMJTH80evl5X8a0steRaYHow6G1EYWsZH0FrrstllrXdtvg9ehrREwuInZrsEkf5lqyTUtIx0Mj2gDyJIZm1QLhrE+fXuDUtX8qyCPnbsrIXuLGku0+x/UnRxsNWr7b0XXHY7kbTaMku59DjxCqV7j9qm148OyPZO5OcU0MfqTG+XHq5ilGD/vmbJZN/+X8etVNv4afzPD1LHE29IyoHoxSxWbEcNQAtOYZFBsIAjbwHvcKMNiEq/Ywy7FQX7vecUXE6f12WvUM6Kut6eyV8WMhu/fTDdFb99K7zL6D9H/ROIcrf8Ymmv2jMSYjgb9+CohFiP0jtn9YwfoS3cpIg7HgwOVFbHQq106PetpUSs7waA/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> Instead of knowing how hugetlb handles hwpoison, just ask
> is_page_hwpoison().  This gives us the flexibility to change how hwpoison
> is handled without updating this function in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  fs/proc/page.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 7d9387143435..323e4c049f69 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
>  	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
>  	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -	if (u & (1 << KPF_HUGE))
> -		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> -	else
> -		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
> -#endif
> +	if (is_page_hwpoison(page))
> +		u |= 1 << KPF_HWPOISON;

snapshot_page() takes a snapshot of the folio and the page. If you look at
"page", you start going to the live version again.

-- 
Cheers,

David

