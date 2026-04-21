Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE779F327C2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7056B0088; Tue, 21 Apr 2026 04:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178226B0089; Tue, 21 Apr 2026 04:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DD96B008A; Tue, 21 Apr 2026 04:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC6BF6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:55:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8399ABDA9D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:26 +0000 (UTC)
X-FDA: 84681954252.27.3CA60FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4DBE40004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=caj96Jq3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776761724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXduyNrJ3varn8E8HT4AlWZI5Nzf3mRezs/q/jCCsN8=;
	b=GHelmH4hNRcko0M4kp+KwfSIh/IPWm4XZdp0pTPQ+BSzkcd4Y7woEoPxXvmnSaojrXi58K
	S92RqOchQ2/l8E74rVT18WzyNU3uthhomkkqVnQeuAhLjMYSrkUyafPPd0ApNxYsZJyd+Q
	6nZIep3bXBW1tQ6y9X0/WraX6NTVVQI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=caj96Jq3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776761724; a=rsa-sha256;
	cv=none;
	b=UXfZW8ALYXZz1qgNaXM1u9XtzPlHl/lTSerNph8HO9LFone6n84d2oem+6l0SacgdhRpFC
	LNhMg/oDplHjVtYZB6sJEX4BmFR+JILJ2RvAB3M2D7OtkvJV4tH5jNXGOXi9aY2XKTSKYO
	PLConZWRK8RPBdvghNTkaZQzvXOQ0mc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB4C843FBF;
	Tue, 21 Apr 2026 08:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A742BC2BCB5;
	Tue, 21 Apr 2026 08:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776761723;
	bh=MbGHGAUZtPobdHB5+R/2WAvW/vSfdXeJK/09XVNsJvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=caj96Jq3tixEPXQiTuBCIJBcoZPlevATza9ys2V6wdv+Ih40LQeRpmFX2v/Uux6Sw
	 O9YwDqIW7CutMQUeQvIH6lYEcDAEarOrs9lz1f8o2LpAg72cmOO77lgMdpAMGKsdOh
	 XXHklKVF9y06MYdJhfclQa6Ke9+Xlvi83geMJjECKsqnnpUFEwVBsUrs/CKwoi/78k
	 akkrKK1CaBeGVT3sKceFmv3ahNhiaB22YmMMF2Tg52AOjvEB5oz6Jz6Zu5oTE2Oqsu
	 mqnSTClNEKPFuEwcodOO/quWhTSperWMjWqffYDgX6b636+4vnzmUK9wjEt2xJrLvr
	 v5aIk45OavkkQ==
Message-ID: <2f4a1999-fbd2-4cbb-8062-5574d3c1e7ce@kernel.org>
Date: Tue, 21 Apr 2026 10:55:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: handle potential NULL return from
 anon_vma_name_reuse()
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260421085056.26033-1-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421085056.26033-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4DBE40004
X-Stat-Signature: 89ez8ecux7ume6zp5erzh97tciw1k69z
X-Rspam-User: 
X-HE-Tag: 1776761724-285894
X-HE-Meta: U2FsdGVkX1+vNgq3qJej0zMXXpjShpPqgcy1i3/itsug/dTFPNlg5DBEauwVNrE2PDa98aGGZgrQQz+lLYuOPHm82c+js/M+YwJh3bjKbLVobJwgyyJdI2nsn0rbrSa0/s+H9cwYjKc2H18ZURtuHsOJJg1fWrw2ndw5AecdgC6PESqqAf4MH8IM0LTtveCwyawyUHBpjkTMY425TRWX7hKbb7muhCObym0JVWyntC3dQ6R5HH3Ef9WtQnwo+mZfnmh/oNVXpFcE+O8W+H2dMbMbye4JiCqkh6r3HYHYTvyIdDEk+VVj2mKv9Fl7CoitTiMt4aJs5YAScwYjRS/xYo9ahcIdJK6IylXSTWBGqbKnNl7Uj6mxcUBaOlZcXWUbGf4bFT6Xptqasu6Ga4LWh5VqlACLx1KcihX+dVlXvJEsB6JWuayWnpJPPolfKjnXLSBRBk2wI/ohFMcsPLPi9hq4dD2JSgkr9M7sisLyh8ikkinFBhC//qlMZTrsZavgk7aAb+l897chCqI7y01nMzp2oVWH7OwghN/Vp4O/mcaJ5qB7oZ/wm9FLCdxpqPQkvrZ6QvyFNMWQaNP3PtopnhzVG2bgdQfWmUDuQJIENj5Wp5ywhz6p6kP3aCEu5WLTzYcjZSqMximGPf7Ealb+sOYCC93ugW8ZSCEv8yrn/3J4njCkv02Qimn9UQdT5jn7VU3wHtTRpGIlcL/JMB3lAS+EjNAXAyXsQVcaeUn/o5VMzhOSWKOgIRnaLc5kv4otnPMrIV2uXMU+OKbk/0dP4Z5nKDR2NMVojvfqF1I3vLvjv66iOw30FojFqmYoHsmSuGgBCg32i7J4NeHDbLP09P9Ia4slw3DqpzZlJq+9o8I6bQ7x88RJBoH0XkbqXMrFrVkBg9eaQ+EV/01qDT7HES/qMHwEYEUWyJ7nBExInBbr6cln9JTCrDH9PYXRjd9Ssy1DCbbQFAs1OhETg7P
 CmCv7kie
 W7E8UafffYgXJX+QCUFoWNv+Xm+ynaXhXNGI3RqoaVdAqvRYpWyI9I4S7kA1hZuLdZ5yxSVl2jzK8KupaSWXY62fWVYgTpN26ep+1ffhJ/FDbX1Km6Jap2ZkBNF4jL+LFpP2yWmrJuijsOhQd8pcjrvB8gx/NV5GGvTJTaXgFEo5ePA6dhfYgbv6mwEME6L2QLsS7ovCSYEzliK6+XeS3JpS1/nDrJWvtvCFzTO9JeLEU2sanz5mkg3CrI29ogjDW47+DbBYgqXOuGlKcVBEup0A9tfns3wQC6xjHQ4/ol2DBOs+vMLVuX6SC5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 10:50, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The anon_vma_name_reuse() function may return NULL if memory allocation
> fails in anon_vma_name_alloc(). Currently, callers dup_anon_vma_name()
> and replace_anon_vma_name() do not check the return value, which could
> lead to NULL pointer dereferences.

When, where?

If we set vma->anon_name = NULL, it just looks like there is no anon
VMA, or what am I missing?

> 
> This patch adds proper error handling:
> - In dup_anon_vma_name(), if anon_vma_name_reuse() returns NULL, emit a
>   warning via WARN_ON_ONCE(1) since this is an unexpected condition.
> - In replace_anon_vma_name(), return -ENOMEM to propagate the allocation
>   failure to the caller.
> 
> These changes improve robustness against memory allocation failures.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  include/linux/mm_inline.h | 12 +++++++++---
>  mm/madvise.c              |  7 ++++++-
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a171070e15f0..9bbaf8287806 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -421,9 +421,15 @@ static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
>  				     struct vm_area_struct *new_vma)
>  {
>  	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
> -
> -	if (anon_name)
> -		new_vma->anon_name = anon_vma_name_reuse(anon_name);
> +	struct anon_vma_name *new_name;
> +
> +	if (anon_name) {
> +		new_name = anon_vma_name_reuse(anon_name);
> +		if (new_name)
> +			new_vma->anon_name = new_name;
> +		else
> +			WARN_ON_ONCE(1);

Triggering a warning when an allocation fails? Certainly not.

-- 
Cheers,

David

