Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FFECD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B576B00F3; Tue, 16 Jun 2026 17:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CED6B00F4; Tue, 16 Jun 2026 17:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9147D6B00F5; Tue, 16 Jun 2026 17:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9A56B00F3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:18:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9696612012C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:12:11 +0000 (UTC)
X-FDA: 84885965262.19.A4EAC16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB17A10000D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:12:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwuOZshk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781619129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6i8dz50BNoOT8Wy1e3/vt/xX8qre9gECxkE7/azKNQ=;
	b=mXC/nyeA8rsnwm5HtaeKcbRidoEAeI1Dts8yH1mWvME2g3BqqMRKwG6yHxFeZj9LkDqluD
	wikwK6v1Q9dctjz1aDKRHLeQcFJI7gYZJ+OAFkiRYE/z1xtwHHKOcl325+CJNNVTVSWcWt
	0zor9BsxH3upSeKmQI299u3kwhS1wdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KwuOZshk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781619129;
	b=z6NDgmglC9AWEjJWRl5YeEMvEwCBqK6eW4alBJPI9O1tDRPS/1X89p/MMj02gq+/ebwL60
	ISJw265RtVso7o3GFPkgpNkZL3jrLcpGhJYku33fYKxvH8BX19ZUI8KZccMWKhNWmp74au
	bSUPX7g3Hozo15Poml26PRdietljNYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68897600AB;
	Tue, 16 Jun 2026 14:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63471F00A3A;
	Tue, 16 Jun 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781619127;
	bh=f6i8dz50BNoOT8Wy1e3/vt/xX8qre9gECxkE7/azKNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KwuOZshk14wbGLQeZBwux+UrJ2I6gGBUCgcTzA4Fj76RB7oIcDchk/aK3j34nh+3i
	 QkM5vPWF6tcmCiS/ht28G1weA7EtXjVle0KFGINIYBg5wpEHnUxUymZprCEl6KEXef
	 wRL4S4ImCAIeAJgMk4c5LvcfGyywVDlJIs5vsLedzciT+3YcS4r0UxRpQ5nemM8Gr2
	 Eugt6xZIhSRnxdeI3DSt1M4rJOb6rCEmOgzA3/PCDHtP2wBxI0hYLIMpnCG08FT9Lx
	 M9PJIKrondo7qwVaF8zlXVEwpHb+4+FpO11XXXKEbz3HurZpM60abB+9XsgkyGFTOU
	 faJ1CNpCchF7g==
Message-ID: <bce8698c-ae4d-4e87-ab6b-5f4059617a69@kernel.org>
Date: Tue, 16 Jun 2026 16:12:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] mm/mprotect: drop 'sub' from
 page_anon_exclusive_sub_batch
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-12-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-12-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 873gbdhhogca6mbp9o65j1h5totwjw79
X-Rspamd-Queue-Id: DB17A10000D
X-HE-Tag: 1781619129-510735
X-HE-Meta: U2FsdGVkX18MmLFf4Su0/dwvrhnIeUIFID5dv+ZuOKx/uPzLzxoYOlJByRH7oWOgQJYu3rpdj3uf3oM/VGeEiaBIkUBGT2Sd9rx7Tj85IF4z/nhS0jWcJmVfqhg9kBELXs6+wY7FEmjR0cMOt4lfTi9IVEOZPINy88/+kPNK4fmZFCLCg+4Zd4WtpY4vj5+EroNr2iaGzfDwdOq5kUp/Nf9yCz11LQFIYMnPcucP3GAZPWZN17yNRiEil6x0G20pSLJXvxsfB9ut933FVXqaEDGKONHB4Fg0Wm69spyHyn+4gpEE7gTrM7MVPeyO09l16+nBbbAAO6SaHxhS4Ov6W9CzjCYdJORyz5WPEaZc9+wMNsGd+dvQ/ihLOsGRKww18EFGVTIpp/5H5ZWlLGMg7jrgsEgbnXFlQjr5tKCw39z7mAYIgrkENIK/DDu2VBbmSZYhAB/Rc24K0AUvf62XTMB34yiczNSbnaoOLNsJUUUW4s9U03UzbU75uoUAT5YjhLjujhBDzJc51cqBxD5RojhH5e6u6beR0sp5G4zTV+e+w3PtcAYTY/PwnCoyxPaqQ+nvRTU0sbTHT87nhSXQ97rdGkA78/GBrg/mCT7T+V+emn99a8sQzf7qaBaACWHA/Z8NSPcgYc0Cj6bpZT7hFPsnenK16rY7g7D6tCj6aZtur88KCSKiDp8hUQsYgnJnJeeFPACcIY2sBkeINWXgAyE++IlRFtWw/ZbJATVt1a8dJsmdE5RawJzNq8yZ0bu9YVTiPZYD+tSe4Hnimu526N0F8JFpokiX467cy8exPuaKwCuMWifdX2bYBa3Juil2pt56R5T/YRaKcIXiOhW/B1QHDm8KH+3aTWN++Sw3AD3jRRH3vXjw+NKmjxHbphQLsRd034sLhnu5efEXpUcoOvaIS7QDqOBuczZUrtRuRk6Gs1EPVjFTZ42683rMnjxwF/G7rlCK6P8KPd+Xp/+
 Zo5F1xzO
 qiuXVhE04Ay1nzNTXkoaZ11YhK20l6ebthkPZH0FD2vitbayvo3ToPznN5P8uGleIEp9Ru+miHa39SdeX+3qTXBlOqyh12O/k9GQQHAlTtgnUe/IMzASzu0T2AF8glI3vSQxCuzjm0TygbVBzye8PkZoEzywrgVP2lKpphb+AsFw1l1EPmnUwl3cETBZNgzlSFX8IC2CNd/QVpihrThoHKcf33sYFIP/nt7ZZYAVVPHmUf85K8wEuYGGhgS23ACFkJZWcK+Cew8tPNQB/OfwYeI/gCFeRV/SR1mgBwF8ddck/jIhpaUxtkkA1D6b6LNHYvHlI4LP/xT/YagqPSjOGReMA4aCPqpolWVh9MN6uaKYwHWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Shorten the function name by dropping the "sub-batch" context - the
> function itself doesn't need this context.

What about "sub_batch_idx" ?

This function is rather independent of the rest, so best to send that as a
cleanup separately.

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028cf..3357058672016 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -143,7 +143,7 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>   * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
>   * that the ptes point to consecutive pages of the same anon large folio.
>   */
> -static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
> +static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
>  		struct page *first_page, bool expected_anon_exclusive)
>  {
>  	int idx;
> @@ -179,7 +179,7 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  
>  	while (nr_ptes) {
>  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
> -		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
> +		len = page_anon_exclusive_batch(sub_batch_idx, nr_ptes,
>  					first_page, expected_anon_exclusive);
>  		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
>  				       sub_batch_idx, expected_anon_exclusive, tlb);


-- 
Cheers,

David

