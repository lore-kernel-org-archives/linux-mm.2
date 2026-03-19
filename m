Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA3D1091927
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3103D6B04F0; Thu, 19 Mar 2026 17:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0116B04F5; Thu, 19 Mar 2026 17:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5ED6B04F7; Thu, 19 Mar 2026 17:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0336B04F0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:43:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0DB28C32B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:43:43 +0000 (UTC)
X-FDA: 84564139926.30.C507A1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9EA6E4000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:43:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ET/D3WYu";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ub/SdKvuQK1F+4dbMUdokt+1BWeE+so5IQ+Xm1zNtQ4=;
	b=nB2vRFCOhtDZTqiNa9g9bnFfAAvYjX30LfwrzKfEc/KIGonHMwiwfjQs3+Ff28BdTIHAom
	QLY60iXIh8yAVawAg1RWPrAk3FM5vFzhuad4FlVp9d16e07KWMUXjiuB/2AsN4HZ6ku7cA
	G9Pvy7/wyKsU9HoZIR2d0vWERpRbizY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ET/D3WYu";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956621; a=rsa-sha256;
	cv=none;
	b=UiKCvJjmdq65WhAxXxxVvBaro6RryaVybvbmMyxNORBgPdt7xoJU5PqA5FMDwRRIszd+Q/
	vD9cSW/NMB2bua/xzPPY4QLJOOOmb8+yXqw0BxKxAcmkgGo+yt+Lkx1DwqWEOkQ/Oyg+BC
	oJCKgyeTUAxiwokh96Jen5ucM65+e7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE32660133;
	Thu, 19 Mar 2026 21:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8915AC19424;
	Thu, 19 Mar 2026 21:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773956620;
	bh=uAw2YurztQA5Fty2B9eeqKXwLRmhsRGPv/axX4+YBZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ET/D3WYuq275gZdLtGn6TIcVwK6gXG16ZSoxJ4xptljWXdGw9DpgJ5miOx1lqH2s/
	 D7jiowfnKdUOQkEKt8UVFgclc7VQoeE3crhFZe0us/f6P2rC82r4Jvsh+hwZt57WUU
	 C0JRG109UYUaMggfN+AlBtLv5wB/VlsfInuBjT168rnNpFV4znDNNlXjpQi6AICbVI
	 Yn3Vfyx2FXraKVaIRwDw4yIaMaoYqF7ijhcnYsvuuqjYhthIx8Yj+FJ9uFxBOEZYYr
	 29v3bzAvD95qPs+PYMuoNG85Oywcfz64n/nWo5HwMlDzevyih8XkiERKtMHQZptehU
	 HQTDKZhlGusOg==
Message-ID: <7cd1e50a-f5a1-42b6-9d04-4e329d338f41@kernel.org>
Date: Thu, 19 Mar 2026 22:43:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/mprotect: special-case small folios when applying
 write permissions
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-5-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319183108.1105090-5-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9EA6E4000C
X-Stat-Signature: cf4pzqkrfb3ocm7f9ecnmggntyb8ux79
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773956621-581652
X-HE-Meta: U2FsdGVkX1/iRmIEekAUkxFHbSbKKIRrXTF8fzVSIWkglhGiiJaEcHiQAPkKoix6jR5sTnI/EoKyxu6zPIK7gON96ya24TIKzxHtJAH55ypnoMpdQOAqi+hE65TM+5Q0iugFO50VbkH8gWo1rDoiYh3MdkLxFfjQ8rrB3XpvsMmswd9/03VEcIX3Pkn6uohq0PiohZD917D3hcdGHzQcqfZGyyNXILvcbZmoCJzHm0DRd2CbZPQP36pkfqxpHoW2CFczcZ+aWW5ibDT0oVlHgE3/bsZSHV8B3PMmEi38SPz/Pn/R8K78KTtle+DwTzbxKet2dQ9s/Re7icdQQRArGhmvpg0Noia6p5gz9KPzf4rZ3J4GdsILurGzFkHWRDBIzRNF1c/6ZM96XkAyrarhxJBfeMC5KfiwvF9HjqDkuwdgvYyDTeviJprA7JMEuADzlgWpsm7XpcK/guilmMXGpQ8aPXRlbnBjkNN97ncsLyhdSA5bfWnLGiKMzfIfF0uK8nAoN5uN49Woj25lY1HqTcGuAhK7oYX4GIUPfHWrdmhLFPzFGb6zPRsAoF0DVQjpPPK/jA8TMKzenruNjZn+R/fRbIGgLhEs/Lz9SOhzvU5NYuAj6VBzChYHi6flLxTKiTlQCmAiIxpZY7I6/0UfJgY8IDDQaBTmsCx4WusCr51p3MDhzCqNGEgg10QLUUi13tj1g142JkKIMPWdGviQxvaUNOaeUVmKKIm9zI4Z8e/KsqHk4cFnU1kuTp12idj+rXGAoBH65ZsB2yvjwQXyEl3eJRaCw/1+Cj8GlBaaz6c9Lqs+mC09x58wKgwuk4a38IVEmLOmSunprIafL2bmDiZjFHyMQAZsu4s82mqSuPZlMg8mjrLcqYBfRvxmBQSGkVXWFlVPycysRHExrTSYYsA8blZu4VP0M9znfOm1hIb0FvPNk3qVhn1NnaNpPuqGh5QQp+FIZIqV+ZA5rI8
 J8098nVw
 6D7BccZSgfsCxHCXaBZSl3FTpcBjp8H3L97iACLKuR0LVzy9jEKqcDUyofhTMN1tQEv47zfkFcDyy3JtahEu0l3EjSb3v81ilrsPotX1Cn8CrLPmP0b07cN85tqE5mgdJy9AGMKDRBggQ1bwyu3nMUUKd4cGZVukzLqdLhQ8PRwUmlgLFaQlOT2Z9r06aE5fVSuBCF/sfGrJUXAXKe4iFRqMnfBrM439ImVZlveekUZWsEjgVuIqf+Kdxkb0VG7a3z/Yq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:31, Pedro Falcato wrote:
> The common order-0 case is important enough to want its own branch, and
> avoids the hairy, large loop logic that the CPU does not seem to handle
> particularly well.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index aa845f5bf14d..23a741f9a4c8 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -170,6 +170,13 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  	int sub_batch_idx = 0;
>  	int len;
>  
> +	/* Optimize for the common order-0 case. */
> +	if (likely(nr_ptes == 1)) {
> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
> +				       0, PageAnonExclusive(first_page), tlb);
> +		return;
> +	}
> +
>  	while (nr_ptes) {
>  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
>  		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,

That should likely be squashed into patch #1, because only then the
inline makes more sense.

-- 
Cheers,

David

