Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F4F6082BF6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CEIDyS2d
Received: by kanga.kvack.org (Postfix)
	id 487F06B05B7; Thu,  5 Nov 2026 05:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E776B05B8; Thu,  5 Nov 2026 05:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3281D6B05B9; Thu,  5 Nov 2026 05:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1182D6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:07:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96F9C1208E9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:07:51 +0000 (UTC)
X-FDA: 85400639142.17.07F63CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB636180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:07:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEIDyS2d;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzdAvB2/oHNqGKeRfI1OIOpKJXPB5hmLnx90lxaP2zA=;
	b=nFlTRpRB86sbL8C+xSjdJJtoXi/9y3k9nJfMeTZue0/mvitRtTmLRvX+5i5gnGtpPtCrMx
	6Br4bWkLFkVehP/bGoYRyQvY+lVsKgVhgsPft6tZ3ofqZFmjAzh6ZZKVYn9IPdbrsjEsFg
	IiYAUYT2uAG3TkDjBiaCNPsyc79QNDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873269;
	b=d3E6F5zTNrakDfldcSlH5wVxi7H7UqX6Az/vCajwFU1w1Y7Oav4xaUgCxjMwiPHNuko3p3
	a8hhmlTcfG+BgKw5WHCo2s45FCajtFw4YdRYTpW4oXH/Y19Q954V3EZw3JQQYy+6Gk1AUa
	KJNRkKtP1i2q9ZyitOjVeLFs1jfRbi0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CEIDyS2d;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03F0C40E85;
	Thu,  5 Nov 2026 10:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F1D1F00A17;
	Thu,  5 Nov 2026 10:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873268;
	bh=GzdAvB2/oHNqGKeRfI1OIOpKJXPB5hmLnx90lxaP2zA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CEIDyS2djknf3O5c/eBT+dmxNXdN/G/oUW1+HL7y7blsCddi9eA80g/V5XSEFEC5O
	 GWzeYpQW/88FuFjd3od24xYlzw1Y8NFhRT9CRAKfOxPxHoEVcWcuhbBFbnYJe5uJ3x
	 7znzB02zi5HOAp15fi78ez0zS7Xj27yJ7kQw7ICRyVUz6rAYf/2YbkbPXYFvZUG8WV
	 LWvF2aht/cNIhoVT90q3Y2joyaxE/0lsIxm3UEWmJFmwQuHxu7g3uFWJfcB8187xQc
	 XUdN+wa8na43x1Uw/a/neuqh2m6zrpJVGHLRYmer9FcDzhG671aBEzU5eMqcXSG2cb
	 uBUJ5qlFBvWig==
Message-ID: <c5210774-8c19-4110-8fb5-6273861b019c@kernel.org>
Date: Thu, 5 Nov 2026 11:07:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Krystian Kaniewski <krystianmkaniewski@gmail.com>, stable@vger.kernel.org
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1teqnt3ec3c4smugkbuoftty4ey1ireo
X-Rspamd-Queue-Id: CB636180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793873269-520475
X-HE-Meta: U2FsdGVkX18OqiNbRTO/vuSJeUgNnoNrZw1kxIewjCB23Jxi/C8xeKFWXAP4X3Dby47ct0u3mFjJ5/6tB+IV44EefbywVGPHwJc0Bg8XzMl6YiDyUtSeXnadcm0klSnXze8TJ46jwLakwdKnG3FF2qAxpexQQOz7OluvxbuEchBxHiPuZiONeulqDAYgIgepc28DUTLpXZD3G+MzP5UznMfPsL5RAkaibjxP7X1ONqJO5sL1gCO0atv1f+SiVo4CAppg2NFHKuRGCHBwnT9q4aUhNJ3UGMEccCYYjrSFvP8i7E9HJ+9oy3Z2iHYMgd8bHnmNGbMmNtOansY1mjOjnmNwdyDK/mXxHJyiZnKOf+xt9X+ChYUw813KgFdgyHFNByAfUAhN/a8rHGQcxyqOqftIDj/BSjpdZKyPzOWX2gmPdtOF0myICndSpzA6ezTc+vcWde7ETxPKKavkBwiicJXqj/pPm09NR5uL4DGuTAMHOpstayXH94HjLugefMEnMhxpyE+wovnUQ6i7zKumG2SFKHqsGBNHW42TvGXtGVJ430Qjwec+rwnVEV7hWH4NBrixJYMh/UqxeqonFZNzcrsjLSLRnUdonXBxTEpZ7iw3Om/86tyG2O9cW6HUs0RFcfnAjOfQaDu57Ozu+Krng+yIw0wPy24O6d3gtng2VzhmdmftSJbPRni3SdIaL8vziMUQB297pDSPgLj026F8yG7fH8paYjnOD5V/wBG5vipzc44AzsAKZqOT4F0Jam9nltGnXIwEtX5egq1ItQl6h7vZVBhgxsVqKdDm21Rw23TT0PYsQDRkJlG6m4XFZfZW3i1ZLH4CNcGCgQJqT15nq8n2tO1F3dtV/5CMssB9gI7mzNJAVBQ+T6VHpdBZx7oeiQzF1ojxYsc8TTbeSAeb7NM2SVUr+u1f2JDhN3ZWHf2bST4d8VmqeoEM84oOxz2HLALsRoksK6skCZPdvNa
 cTL5GeHd
 HRwQMuMTeUMPNk2KGBhuJHSchA7UE06sRQr6913qanshIkx0vGiiYvRu8yQncLGCbMT/y6LNTEBuEEUJyb/8KTvIqSD9kRZTunX7yQPtyf89VDE1QcgZTDCK0rQRN9jSIOTDTaE1fzZ0fR7Dfis3g0r4YKuUeC/nGQpEAy5TcAsDGc8XiU2II+iFkFSAQXkPlihNR/i17lk8zHkIpgwGRjx9nNvTqow/BPNABAuZe379THva5fGSwchW4ZubgvXdSJTV6QDxm9hznD/ygECc8cmHYbjDp2SilAOQr/KcxcU3z5Vxk3Iui/TCAAxh94GCTJhcVd4g0cv0tttw2WRgKhhTwilpFjarZvzhQV52jAhDeGIgO9noBjGq/IufYRljLqdVq1i2JkO8Dfms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 05:33, Jose Fernandez (Anthropic) wrote:
> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1]. The
> same path can also write out of bounds. When the stray entry reads as
> none, the fault-around loop maps a page there with set_pte_range().
> 
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
> 
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.
> 
> Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> ---
> Changes in v2:
> - Add Fixes: and Cc: stable tags, and say in the message that the loop
>   can also write out of bounds (David Hildenbrand).
>   https://patch.msgid.link/0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org
> - Link to v1: https://patch.msgid.link/20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev
> ---
>  mm/filemap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..1df776907140 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		unsigned long end;
>  		vm_fault_t map_ret;
>  
> +		/* A lower index could move vmf->pte out of its page table. */
> +		if (unlikely(xas.xa_index < last_pgoff)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			break;
> +		}
> +
>  		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
>  		vmf->pte += xas.xa_index - last_pgoff;
>  		last_pgoff = xas.xa_index;
> 
> ---
> base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
> change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9
> 
> Best regards,
> --  
> Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> 

I'm trusting on Andrew to pick this up :)

-- 
Cheers,

David

