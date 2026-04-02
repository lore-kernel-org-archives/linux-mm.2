Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C04D3940E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 10:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DCD6B008A; Thu,  2 Apr 2026 06:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556026B008C; Thu,  2 Apr 2026 06:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BB56B0092; Thu,  2 Apr 2026 06:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35F266B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:33:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05D1D140649
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:33:32 +0000 (UTC)
X-FDA: 84613254264.14.9DC4B52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47E0340002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:33:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ8fJQl8;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775126010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voA2RPl4ACqY5D71csxo9rSb1EEWd8VJ4dwxQvxCMBM=;
	b=Zrkd6W8j+BD3VD7fTMFY28C4CKjq6mU5tM90Oo+P59KiBVJN1Y4wDYIMEQyi3seGJ2aG0y
	j4F1AUcrLKh0i22Wtb+GO0MjopjTxfYS2OZeUltRcCBjGS85T7achFlfsnjZCjg/MsTi07
	kE2f1HgVrSSS4abgRonSn6mPwRDpphg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775126010; a=rsa-sha256;
	cv=none;
	b=rvLIFjXpVaLRZm59WIf3fp5AHltGnYDcP8+LTdrfEQi/61H0dxa0qn1goZVBhWfTRJfZHr
	BPGXyFzzsRmmXhQCwGJs2usiwfhuxZ6BTorHs2Ow2rrP2rPEDQ2VvDd8qGVHi0Z2ehURYW
	w0fIpvStkEDCZ/r9s3jo63cuksCwxQg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ8fJQl8;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BDF86012B;
	Thu,  2 Apr 2026 10:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B6DC116C6;
	Thu,  2 Apr 2026 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775126009;
	bh=11qgtPGLwVASO1RXj7Dpucv+msw2zwj+vSe9j1rvdlE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UJ8fJQl8n4Pd8K3AaUXqGdyXtNvdexXPyW4PaHzM4fY7VzdrgJRAy47fOM1wWrdid
	 tWgHgMOs1vZt8xg3uV4lS5WOmKYJIhEERwZMTfE3KK54c+Q+KNqqNniYNFtc+cMj8M
	 NsHj6pQ+fKcL+Sv3nRUlc6mprAXBd2aUBF/65dXBgyyOmQEp9IMXASWnctZgpenCfM
	 u4I2vXn/oo/d+/ynfi/wASHXzi9SVHoIKR61JETJlOnqiF6S9EHBbZzldZdX5zB/hh
	 3tAY/z3bJHaecdfw4XQUKDjb5ReSX0pJcSe0IxJCQn1ijU0hf1wkIIaGPEBHUQmdEw
	 97RJ6aBE9HXRw==
Message-ID: <ef9eaaf5-ff2c-4919-8e50-eb0e3c7d126a@kernel.org>
Date: Thu, 2 Apr 2026 12:33:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/sparse: fix comment for section map alignment
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260402102320.3617578-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260402102320.3617578-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47E0340002
X-Stat-Signature: hkpfxub5a3on6gypzkatid8npj4fgsij
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775126010-677199
X-HE-Meta: U2FsdGVkX18C4JelHdTiwr/VCROapb35TuDMhAT17r6xuRT7RPDb3G8wMS/dyRpASISHiyHErqCcQnTCD8PSbjc0gY1OG6wiGiZ9W8OiSJ5Yv+8HTXy07P7AzC5k+Tp1BbsqgMVCOEzM0Qo6+S5AgFn8cDxI4LH2VJrW1Kb+qeEJuhNAzMXMMLk3zzcSV7aWLrYHPvZh/ScBCs4Py0GkCdI4stII5/+3Z2J83sKA7i+Q1P5oUVNqF0RjoKncIwwdKMTetG5SMr7BX2CrWM/YylGyS7uorn8UAIvA2DBwprVpr9fZ/Tk3XVkBwfgaXJbpRSk+QUEQR6O1ZboZOfkd9b3/iS1eteiqRKw7d22e4NS3aJFe2OAvufyHTfnWbgfe79e6NfyA/Yx1uz28slStuu/iAd1BaEU56pJRx9JJszEEdm7stqxFzhxbnfXZtWvqeCUHj1ycmRQBdOFOfrBNUuYjmOfiHDRDK7pWEc/80Tg/5jYO+nmWVXGuBSTvYxemyUOXT/RUtbM7RrijnXvs6/SIoP1vpv/h+qnXrAORDwmge/41FOGb/TVPYUdKPYIryIGJBjMseXEcVj3jcKLyOvtm/g8PAy6aBHl5KCEvSoKSYUjPNP+zvChrnKev844qsw50/lIFoYTrNJIIEUuOpjWJtjWAShTbl1wWQMQuxFL3w4IEp4OJ0O/L2VjLVttOzjaMUkVwC9dH0G4wQAAA41kW59XB8dcab52sNtTHMYG1AdQYp2a4K/FR26ptGvFbrB38Hxzw7fDdt3Fe7Tl606UVkcWraQ43m6KqOwVcVlwF/QIBBFXYKtLF9BRaoodWzUBQUJns6ejGcmxWLAuX+w+XbYbUHqh92KvmO1MbdZYrHnprNnZXPfzPdnd0iZPOPOgRboyKc1Bgk5awpqYOHsKOtkgjFY2smJ73PGmkpxFpUvzmSm2TGQG2jekDgEGWHFWJYIMv+EuOh+hjZ+v
 6slxq4H7
 62t4bFsjLEahl2nistT5S8TxbtY1mCRHXIdXyepod+90q1BWYr1UoHyReef5BMd0Fe49qbSouHEqxnNaDXr2Zk3eV8pWQ6JxxM8aDfO/UNNmOU3KrssYGQCNWVDgiYBoai6JLleug/882zmook8RVdZdxZnkMHGgZpQ8MiecHifpf0bw9zABzxMlftsXoY6thFpGYk7p3ArhOsawsm9S/yM3FN2FAmkU6rq0jCt3KZJgTsHpv4bpGuNWAK/DrA27hrD4OQtift6ApYMV17NjQT/nlnNQUCCXwtj8Sg4Z+bPaxv6Uh+N+7Nc9ioA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 12:23, Muchun Song wrote:
> The comment in mmzone.h currently details exhaustive per-architecture
> bit-width lists and explains alignment using min(PAGE_SHIFT,
> PFN_SECTION_SHIFT). Such details risk falling out of date over time
> and may inadvertently be left un-updated.
> 
> We always expect a single section to cover full pages. Therefore,
> we can safely assume that PFN_SECTION_SHIFT is large enough to
> accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
> 
> Update the comment to accurately reflect this consensus, making it
> clear that we rely on a single section covering full pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v1 -> v2:
>  - Drop the actual BUILD_BUG_ON logic modification (keeping the simple
>    comparison) and only simplify/clarify the mmzone.h comment.
>  - Add explanation explicitly noting that a single section is always
>    expected to cover full pages, per discussions with David Hildenbrand
>    and Andrew Morton.
> ---
>  include/linux/mmzone.h | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7de42be81d4b..a071f1a0e242 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2056,21 +2056,16 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
>  extern size_t mem_section_usage_size(void);
>  
>  /*
> - * We use the lower bits of the mem_map pointer to store
> - * a little bit of information.  The pointer is calculated
> - * as mem_map - section_nr_to_pfn(pnum).  The result is
> - * aligned to the minimum alignment of the two values:
> - *   1. All mem_map arrays are page-aligned.
> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
> - *      worst combination is powerpc with 256k pages,
> - *      which results in PFN_SECTION_SHIFT equal 6.
> - * To sum it up, at least 6 bits are available on all architectures.
> - * However, we can exceed 6 bits on some other architectures except
> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
> - * with the worst case of 64K pages on arm64) if we make sure the
> - * exceeded bit is not applicable to powerpc.
> + * We use the lower bits of the mem_map pointer to store a little bit of
> + * information. The pointer is calculated as mem_map - section_nr_to_pfn().
> + * The result is aligned to the minimum alignment of the two values:
> + *
> + * 1. All mem_map arrays are page-aligned.
> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits.
> + *
> + * We always expect a single section to cover full pages. Therefore,
> + * we can safely assume that PFN_SECTION_SHIFT is large enough to
> + * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
>   */
>  enum {
>  	SECTION_MARKED_PRESENT_BIT,

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

