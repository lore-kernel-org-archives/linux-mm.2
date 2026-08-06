Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD1EC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E626B0088; Thu,  6 Aug 2026 09:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F746B0092; Thu,  6 Aug 2026 09:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D70F6B0093; Thu,  6 Aug 2026 09:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF27C6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:58:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86A994077E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:58:41 +0000 (UTC)
X-FDA: 85071000042.09.0F65825
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B576810000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:58:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfWtjqYf;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024719;
	b=a6orvzNGJ9OlvBmypqCbzuUm13id8j3VB1vqw+giU1wHQh194+k7ywJQ9XWuhmSnaYkVqE
	t8Rvv/UIjCQ561Xbup+IjNSZwyy17mnt9dEG4TvpAFvtHGlKjIa7z7+mIK/QFqDUQZXzWb
	RD78H9Qb6WwOpUpuqH8LZ2UJkuitr8M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfWtjqYf;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wRO74CcRIalo/k8pD9p1nvIQvOuxyVB7Ax6J3p+LFk=;
	b=Ae1zyxVWVdzKd6xiozaUIN/QHXc6Uy436vXi4RWpHp5ZXDcQ2xKOn8GK1qLqVNLrVgCuae
	QWMLwqiVZpyYr0IrGJKZstuiWafC2VRiI37m9ucldixaNgIKMljrpNnQ+ZnXI0oZFdJDcj
	lqKA0TWKrxdK/ZGvx9yIf79zJidkM0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F39A540F0A;
	Thu,  6 Aug 2026 13:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44221F000E9;
	Thu,  6 Aug 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024718;
	bh=9wRO74CcRIalo/k8pD9p1nvIQvOuxyVB7Ax6J3p+LFk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cfWtjqYfxsKZVa95uwGYkFOkF4656sllygFEOdMkS+9F6TRD9d2AZvKUYCyl8qOfV
	 RPHyAblmhkJUXr6M22cEm35E1ew9IQJKJWGaVEcVai7iuZM6+FYmS8/jo59S2Q85mD
	 /qMNFhb0QSFM32zF6zBR1Q1N7i8LtbX3YTq2iDRXAXfMy8BNUP9iRgMYDK2aJaTKwR
	 nRAPTyvvG/8lhjbL7SgkSF1+DdKiI8CZUdizWC0vfWBXIDmUQ9JCwtROMOBC36lAQw
	 N6gn/DCSR/u2P5N11sKhZS9nInHhUhymPJVEXPWV7WPUdxYc/dZebKkGn6BtCtRi7N
	 VTgpKbGJJm/hg==
Message-ID: <ee89226e-64b3-48e6-9be2-4934c23b729f@kernel.org>
Date: Thu, 6 Aug 2026 15:58:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, baolin.wang@linux.alibaba.com, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B576810000F
X-Stat-Signature: xbjrg7bgj47ynsqfqp54ufu77eaesou6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786024719-770769
X-HE-Meta: U2FsdGVkX1/7ZkzqP2K065mfQdefUojRG2TGJLeTV7H1lPXakxtCywehdzKQyjuJu4zrqsVAZVIITwqVe44gPyYalDKP+e4zo0Rzoh95xP3FK+UxJpa4Rj6e00TAhMzTH0s9CJbKfAGdXD59AJfagNrFl7+pwdZ8Q2o77ILAsjR35LS5LEVrD2sVdLDh+sN2UZP5FqW93v2AFapDpxGWIeJwE4M0Hfkbwwx0wUxPH7ZSrKwgAauKJbANOTR1SGPhWq119YdZR4cP5aQdhW64ImN3hlQjO31pwPekVh9TD+xuI5rDrxEUs63ZJyATmn/cgyhR8j891aj4g2FOqM9AVtUCihRrwf/ep9x2X3vWlcrSLlW7NnwiHkBhNLnDSb2mQ7laUaKx42Zj6GPoW5DMzAtG+T3WKwMkG3Hw+7e6I5HpF8jmMTvuVaczGafcQ7qgoo7kTVEW87xlIgD97mT8eYit28x2WifUlRYsAUXy3x73is5W1NA2E0lmuQbHahvDdEHtcW6fsQCUwbiGZMD9klJOjzIceni6hh/mF+xuC/Bwn05QEv4l54Pj9N1U7094VvUI6SkmdgPcKkjsuAh1vJkY1IKe8icjUYRqOm7qiwi/JvE0tnkVjEo5lxzJX99Z/La/fM6wY+zkOeO00W1AK1hphnDUfQifc6wfa/WRpXO8Buj/n9S4QhTjcmShMpmqI+ZjT8wIiiwB+tooyaK6MC9cJE/tCJJYj4mqLdbBkQhTRUkuApY7pK6quAB5eyksbkrLksJG/4sAI0rjSzE71xKyfpaLIi6vUqqLh6FxqR7U3Ws++6bvV8ZpEdQXVBNgSYIXh8eQtETK4KbnV1TQQ7iE44df7X/yEBJIuvaHyi10uEwHzKlECmBCXoEEq11T7HHYBPULy7DZ90Z2TiJNQ/S6vOK4L3cw02GXS6S1dXaZ9vu470JKhixKwIbM85ENHqIFxfrvkjOb3AmNobu
 6EMJHWGw
 WrYGQMZ260VhQ20dcyJOh8zCtsvQ9gmfZIslYid2pKqVWFv3EKMoGozmT2bM36G0uNz1NyevUBUEzTiSGBIDObdKuDtmO+6dnQFGJ+71bMnQE2NaJ+X2LnpgGHBG6RK/uopH4GXIeAVHg68qwff3ceJygqiBXc2s2wn+bTY7krqhcS28D7cFCZlvlEB0tmdZtN8iDLRDhyiJ5u5SKaWMxQDEfldM4Sla2ah3C9MH4kFjwaZDMe2ya0OoLjW1e/nWiJZCH6w4ITP1o1Vss2qLqccGbm/+NS5XKs8HzBgwLICq5xUX9iKEfh4D5cppQfFc2G7Znq69I7Ir5wX+gmWccsbqYGucmCvGnENg7QqBgnmvt8zqYE+m5qEvO01gZW3lWxXWrSZlKUeY0uC3+ok2S+nbS5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 14:23, Xueyuan Chen wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
> 
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
> 
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of the
> folio.
> 
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>

Do you have a link to the report?

I assume this is not Fixes-worthy.

> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 26df81e773ff..457049e130df 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  		 */
>  		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>  				!folio_test_swapcache(folio)) {
> +			int ret;
> +
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
>  			if (folio_maybe_dma_pinned(folio))
> @@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  				    split_folio_to_list(folio, folio_list))
>  					goto activate_locked;
>  			}
> -			if (folio_alloc_swap(folio)) {
> +			ret = folio_alloc_swap(folio);
> +			if (ret) {
>  				int __maybe_unused order = folio_order(folio);
>  
>  				if (!folio_test_large(folio))
>  					goto activate_locked_split;
> +				if (ret != -E2BIG)
> +					goto activate_locked;
>  				/* Fallback to swap normal pages */
>  				if (split_folio_to_list(folio, folio_list))
>  					goto activate_locked;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

