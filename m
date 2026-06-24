Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848ADCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C1C6B00B0; Wed, 24 Jun 2026 11:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613C76B00B3; Wed, 24 Jun 2026 11:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502E36B00BB; Wed, 24 Jun 2026 11:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1724C6B00B0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:08:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97F8F1403CE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:08:05 +0000 (UTC)
X-FDA: 84915136530.28.C480DF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B291440016
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:08:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=En82ZQYA;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313683;
	b=rqumvQ7hjR7Gg3MA4FY2qnfxfmmS1NpCoztjIc5AcBe1OKqb2DcOtzglzyID8KlleWj6ak
	kol4VSp/mlbR0Szuz9rPwPMF0hwaH6tt/iSeLQx9fG7V+TrscnzaLdW/Bntvb5UK0hazYh
	BYC1HAt8BET5oUgqvy6Byuz+KG3qt8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ro9Th4ger4jLTg/pNKqSDgmBrLRcJCG1vxIVqovmC+c=;
	b=smoCXZUlz7HftGEkQEV3zQHbhASJjnhsoRRL1uvMBP6zTRQT7/gljUz6ih6fK5rPodKo04
	HTfwlQX2NkAmKcV/Tx7SpwhyDKgeV7RApmUznTOM7mwftd7w0I814ya6tOtzeVMJiNPeKj
	QZcqbHWwuXU1W95P8fOMgxXZZvSIk5M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=En82ZQYA;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A71C240684;
	Wed, 24 Jun 2026 15:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AB91F000E9;
	Wed, 24 Jun 2026 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313682;
	bh=Ro9Th4ger4jLTg/pNKqSDgmBrLRcJCG1vxIVqovmC+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=En82ZQYAA3LUKTp7MwQkYWxetxRa/R/ktEzh0fKi1H9RfNcAjlr9unbq2gY8r7rZh
	 632LF7U8TfdolAn5JCO/VyAP0f6IHK2+3FLjC0WXIjpdbBCHuo0N6LaImCCEaBRqRw
	 q+GOKMChF2SgifEBYZ1ryhXY+6pP3Acse7QJn6pTk18aGO1CyoZsLFnK5qKb2dv1p1
	 XLEJbGBxMe/AOUpBaWDmpQYW7RYyTKL9bEWmMgdg7QBxr5URyZafCC3IUclmm9Lcf6
	 e2a4G5g9/7vhx/6ed8vXLtpCN7CY9GYxqB/nCqW/ZSVlLlQeleUAxzwP1gWIc7k/B9
	 jYKVvRWOkPAsw==
Message-ID: <24ca671b-074b-4d1c-ab50-1143279480ce@kernel.org>
Date: Wed, 24 Jun 2026 17:07:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-3-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623231635.43086-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B291440016
X-Rspam-User: 
X-Stat-Signature: cymnde4z4ac5s3tjib8np9mhomobtmd3
X-HE-Tag: 1782313683-173445
X-HE-Meta: U2FsdGVkX1+xasjcQWwoE9ij27uKk++TAvKkxTjaPUEtWyfZdZ5HYUd+9xQCY/J0meoALbZ1Hfs02ohuMnQRM6JUrfZEq5f4t82zkrNjnI5scOHyhMN9cHfpyn0b54TwZnPCUw5tkExMb6onksRnTFM/DvP3BTmhPFYhSdyGrYTEGA6giF8s7402Yxd50M3GGbAeKcW4MJfuhW3bjtyv2U6qnEoTxuUzVs3DYv69+i7qwzE/e5M1LW0cGH07AjfXf8WEk01SPKi2zasdAI7ZCe73vep0Ash0Mz2qVubWEfK8TuPpZCf/DLTGr2r39/tit5Y0fbzXgc8oK5BpiKYycC6nDBHXgs4tTydRUt/VtT0tB+4SV47D2MWsQaTycIOtDebx0inoX5LbOb6wxpsJGZyGjNKZuB2RrvlCZep4DCUwqAkdIgmeu4vp7P7B1atlx5vdpwO4wN1FgCCnoioA3vtfmHSWnQawBks6C7JT0ap/diiAgNMxFa3mW3wv9ubzZr12rXo2ssb93cJ3iZyHpmmNDCymJrzPb2K8XynjNBMl4eeALuaJVnOcVYsObhrwCvXVd7p+VLOu1LLb1RTLNiNixC4DDwaQwX9JyKIt5yZTg9j/rId3BtNS4fM/EDt4ZVkQteP+aMSutgDLecCAi/2UlMKCcIFJsW6Ajm2GioQdBWLvCa7D2MWutcZwMaGBxe/TNAyvsINav839vIEWNEpuTtGEK5rUS1oxz+S7RQGlm+83YieaIJWwtIOP8Naqk2JLQfa30+RJPfcA15UBLmgQl3vVqoecBGIlPTN6WiQQmSp7qdWlml9ndiBQoJR6+qizgLb+9WkBBhNUmicV6fgXN0x5mg2A9A/RjW+a9SF7ixw7OXUBlSGOWnQJl2EWl297aBoqkM8wFnb09xaK9pW/9t1Uhw+7ybhH20JS20ituG434uq3LTEhU91rIwhEIga1e54kskXXyh6UV59
 6GiiJr/F
 qCibeQpw/hnls/giZ5LU3MLXMwE0TD4bCY9hVuVLyLsd/ocrgLk7Iu9dwCGejFX92y/9ZRgPeDth8kvxGr5H7TNP5FQmkM3sria3a4ek2DDiQB7GJvG0Bfyw9TvybYTeXbpCY8uhZi01CC/BFaSSM5Pohin6lxzJqH92AdJc1ZcZHo/JnKMmYaI4fu8NWD1bhtTHYbjqwSutbon7vPNAYct5JkKJZzqDq+yoCDagFUPLKNNYCAGmfsoo/p5QHdgrHJEbZX0UlV25MQzf+JPYuVc6wbT6xq2uGlxaXBasNnMB83WwoPsuVZ/bCEWN1eSiPhefr3ycMN6Kg2hVQMTKQIM7vFOc/ZlhVsn8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> The "we just allocated them without exposing them to the swapcache"
> case no longer exists, as Kairui has routed synchronous I/O through
> the swapcache as well in his series "unify swapin use swap cache and
> cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> in this path, since at least two references are held (base ref plus
> swapcache). Remove the folio_ref_count()==1 check and update the
> comment accordingly.
> 
> [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index f6848f4234a6..abd0adcf65f0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  
>  	/*
>  	 * Same logic as in do_wp_page(); however, optimize for pages that are

s/Same/Similar/ ?

> -	 * certainly not shared either because we just allocated them without
> -	 * exposing them to the swapcache or because the swap entry indicates
> -	 * exclusivity.
> +	 * certainly not because the swap entry indicates exclusivity.
>  	 */
> -	if (!folio_test_ksm(folio) &&
> -	    (exclusive || folio_ref_count(folio) == 1)) {
> +	if (!folio_test_ksm(folio) && exclusive) {

Hmm, but KSM folios should never have "exclusive" set. So I think you can drop
that as well (was only relevant with folio_ref_count==1 check IIRC).

-- 
Cheers,

David

