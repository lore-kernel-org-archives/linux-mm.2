Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61873CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593816B00A0; Wed, 24 Jun 2026 11:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543DD6B00A1; Wed, 24 Jun 2026 11:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BF36B00BA; Wed, 24 Jun 2026 11:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3176B00A0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:02:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9ADD403AB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:02:21 +0000 (UTC)
X-FDA: 84915122082.26.17C2ACF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E131AC0016
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:02:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nf8cEsUY;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313339;
	b=DcImQ8sMRj41LQkyNZgoi2uERykUoL4jbzlRYOODap2s3vSxdNYT7j0mBwQ6xz3Uv4oElP
	JGKjcqkNSwrndUgoVf97DKqelTgLyZVrt8IShc6iLfp6Aqsf7ydBtMWg9U+0bTQ54U8bGi
	OKIHBBLTl7QRuJLR/wWbOVNO0b4M+zQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yNq2vBkCmiLK8SAIQ+jzcwpnXFjNgI+aL8xlQvqyg8=;
	b=XFGokx+bbVmjJdk7ixpbnFI+NgPWqmaaCJhKoP1rN9jQZZMkL0RbgS0z7Z3e9L+hiQ/VE2
	9MtbjpDQunGV6AyUKWd+8ebMcbD1HBJXKyDug8JWRMBuxzixwqsIfwTPIpw4dfu/s9MV8J
	z2OCURSY3dHYA52nvrP/ZpPvYGhS5lM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nf8cEsUY;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64AF260018;
	Wed, 24 Jun 2026 15:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11901F000E9;
	Wed, 24 Jun 2026 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313339;
	bh=7yNq2vBkCmiLK8SAIQ+jzcwpnXFjNgI+aL8xlQvqyg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nf8cEsUY6l4N1GQ18fTWQsQFh0KEOFmRVygqi7Pd/aVo0tbVvp0RYxAOg6RNvQFqE
	 NcoZhf0FgoeX+tO/jdkIWGfVWuGDor7dxXcXZmU8Td0EPFZqASTVMPotp9BszbNKd6
	 uno05vQuD3bB34Eb/w/gD/BfWAIg9pK0z5KTxHSm6MxIYG4ACzoIzmP8cjwcTXIYvP
	 LU6b2IYUssfZXnBVJvGv/q7JnzcNaaBh7PesdBPITJsvgHV0jR5bB4nFU6hd7b40ah
	 ThWJhjJ4sf+QhGyNF4n7QFmbFMOkakaQDfZjdbJrYe1YSisNlt0fHTgtlB7tbtekjJ
	 UUmMGxu2nnvDg==
Message-ID: <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
Date: Wed, 24 Jun 2026 17:02:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-2-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623231635.43086-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dyp6h9opc3ojps4dsxyq6esjuhc6uxy4
X-Rspamd-Queue-Id: E131AC0016
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782313339-446871
X-HE-Meta: U2FsdGVkX1/DEzq8yFaF99TS8BrmY9OmjW8ReavnZpyvUX66JJNiQxJlBCgQPWfS4NI+F4aGUV4s9UM7QiXcBMuEAt1GK8EbeZSiWSuRcKi252N0iI2qbX09pEo6T00v7CZmFygUiFLZF8vrVFjwotgeC8MpFZtEIDuisrvuDlJ6Kxiiz+AUf14fqIXInzp1g1GKPagi79Fb4s6SE8e5Xk18at8hRQh37B230VxGI1AsxGKx/yzb+SqMdtFkkjB7DjtnwppHkLzynCWzMZV39DJ70pl2undXjTU+lS7DcNRc/I5gSyHJRqLTAdnmjKjKwd2XJs0vsHr5TAPEEx7vTTErUYv2MJMkhEbwf39sNrime8HSmKa/eQAF3uTxZ7BIsDW02R8gQRgm1tW8qfkEmeArHzSD5lvdzJixqR3GBnb0GqUM/fd7O+PElBLRmoPGoERSkMMiBFM4wkyVL3ASoVA/FB2zdaq68BVVypgDlgE4lbirlrQSX1A6l3Ikpy9SiXaKH60mhVRYChiUB1pgDdM83PSQTw1TJeWNFLQStk3zoYXpFXi8LJlaw3cgNZk4EBZAQwLXykTLVtkSsmwEYG0/XENpgbATBNUblkJ8N9r8wh87NpjgKAUPYYHTITVDl5GJD6RBSk6KNknOzjG66YYjwxOybvpuAUtZC6D5mnL5EPuMGN46Pc6jfosWG0oa2yVdrtCt0n3EYb3f3w0qU4BDdFEJfjjr5BHbCLHdZ5Uy/JgTAM0uw1a55N66KVkruyPQ0gXAlW8tH76msV2Gwk3HFVTIjS9HTs66PteRCV7eqjbA3lK4AeT0BNWOabd2C7//K5XEszz1KrBWd3/Fkb1PUNyxTm+5mvArbluQmv5gjjlplEjO+Vuq7EJUb33ATGdNFDbIY53qI/7pSnbe5ZyDAMK1uaJTQb79PtcGc/fUjy6iD9NO7Xe9pTRUwMDqhB80eObN7rhPgzhr1qJ
 eqOFiuB/
 RxDj0nbbTy7qo9KKECD/cNaVq2W0BRXDxzDjY8cfbN1qLVtzgO2zxBDgULLM9oL+vDE/2CQZNgnIzCE9HPX5jlwWY4iT7MgNLzXf8UuvaBUm5gTarxeX9oItsqXLwiTO1sdevgJ5bbwOKx2HnkcOP/D0B5a35AivOLB9U9ucZaXHb+fw5a4iFx++9I/PK2d6/TqIpkGTMjEd1aL7vl+kNjh9JMyul7xsccckZaECUYzuNU3WrLHj1IZJu8kjeRUMuUdN69DKIP5258HNFQqp1vdAGorI/CqGVgb6l/3E3t2UAqWhmJcClbxZQUKIMV0ESG+6RlE5gF2UplOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> We always unconditionally drain the LRU before retrying anon folio
> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> drains.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..f6848f4234a6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
>  	 */
>  	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
>  		return false;
> -	if (!folio_test_lru(folio))
> +	if (!folio_test_lru(folio)) {
> +		/*
> +		 * Assume folio is on lru_cache and holds a cache reference.
> +		 */
> +		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> +			return false;

I'm not keen on making this function even uglier, so no, not like that.

We have the earlier "folio_ref_count(folio) > 3" check.

In which scenarios can you trigger this such that we would care?

If the answer is "I don't know" there is no reason for a change.

-- 
Cheers,

David

