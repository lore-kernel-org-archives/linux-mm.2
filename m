Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D982C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6149E6B008A; Wed,  9 Sep 2026 08:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6196B008C; Wed,  9 Sep 2026 08:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502586B0093; Wed,  9 Sep 2026 08:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 317836B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:54:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF6241201CC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:53:58 +0000 (UTC)
X-FDA: 85194216156.18.1C92860
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2681A180004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:53:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5KnmFHIB;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zA/uvS+1bISn3KdOd6ALIL3rCXFqboQ+r31zsr//9I=;
	b=0AZtt2xkYf74KSoGJ1WvvCEg6OYqIoxlCEGzWsAfJPUYOrKjX+SN5esycbViYhYyyabq0G
	+h4JhEvyorw8nbkT9NBFupE6b4P8J044BA/SKiStJda1oKjNJCZ3mheD6ABxabKcOElLS/
	X3LTQnbj5CkBTW+Ifhh0JLjlJI1kBr8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5KnmFHIB;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958437;
	b=jvqDKinWeQJI9hvbhEjDCXQa9lVpoMN2GjdI59FYH5CxIgbjNMiq8zLlwi+9d6/w0kzF7I
	a6bWQ+jUy3aaBWrfCsyfrxK7MalbdPn4cwLxNyxXfUEW16pWe5oXQI0q4SJuRNDllNLoe7
	MFB4dkuDoYlvvW1++ktbcPgNr0fRDtY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8zA/uvS+1bISn3KdOd6ALIL3rCXFqboQ+r31zsr//9I=;
	b=5KnmFHIBmxlIxFNixOrEJndcF0glx1wdKduYlLxdq9WQnMgGLS7W5j0+XJi4i78joVt+4xHDG
	+yTztquy5fmVwKjR1CSwG87rzsDvmMzzwpoKUe0FULPp4axLuCStnu+jziubJQWHsHUkdlHhX/G
	QHdPKO5yGgQ1d6Z7vKgkK5U=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hg0nR5bH7z1T4Fq;
	Wed,  9 Sep 2026 20:42:19 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 7ED2C203B8;
	Wed,  9 Sep 2026 20:53:51 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 9 Sep 2026 20:53:50 +0800
Message-ID: <8861d061-a54d-4773-9cb6-23ae1d8c777e@huawei.com>
Date: Wed, 9 Sep 2026 20:53:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: zswap: avoid unnecessary xarray lookup in
 zswap_store()
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>
References: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260909123548.296955-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2681A180004
X-Stat-Signature: rdinh6iamc4tqypbxwmzijqbik5hsiz5
X-Rspam-User: 
X-HE-Tag: 1788958436-251408
X-HE-Meta: U2FsdGVkX19J7ZX8Vqr3yq+u1ikE8l+MG5pTtHY+pmRAKISladaQ+fjbdVKJB3gIQJ/QjWAHsY7Ua9ThO2QMxPr+tRi3igQOlBKOneX0QerpHDfnE0gB+IugVyJHi68b6nhKJaYMpvnskVf42ieqVd93FWl+2bWGV1FArb6dxVMyh+dR2U8rKNLYy91gI8/+pRiMEUgaU+1rmV9jrUk1SEvxr2ayV6im5/JukT5FTP3xkHkhpzbyybqcwffRlhFHg9OnNICfWSip5kfrbtO1KKeomlJuDga1ygecmA6dKy1ugM1sYcwuoN0F3BWtAG6Ahb51ma3sGQ6HGb86U34ypuXbLEvXak8G64oh9Ej/Jh25UM8itdXvFtMs93FfkPdbGy3KKmWmkFbxSURj0Ec26GhFleyinB71IyN51Dm4OoqxNkCK+adG2B8u234wLD4B/I7uyXrLc0fl1LkH02u5EzXYf/L6wDFBloEDUcylDlFOc6e/ggtYtVtxpk1cL84yxaeKcYHiLqHAy/bg9LDBkPj38B0u8bHUjAAexxybvHvgYnZbptTrCSSBpggiHkGQHqnMJps/G5qLD19yb2/0AVBTaCCazpPBoRxGByDjekR99UqtavcmknE7qj5GuPgNtVz13F1EQTOjd7nZy0Z4nN14uUXVdeNBgPlskVIEu+htMdqqZcVzPLTIPSXrE8d3Iyakg+HBPGJSqaNxifatL+zy1lPraSBMP5VSi9258H8Bo/a2EYpxo9UFpnOPAuKVXKOYjvJuezgHdyo5CjN5s6BhWWoynupnGCKr+9Lwj1LEHxnt6zqlVO+r3S96qaC386MjIueTKSvwaVh+Th0dOCCkV8lSD2MTIK/DqVc9qm3Stmv0CEg3Yd5CbtjXhT1ZRhJ+WS35rFBqTwisgKhhNY+zrFTpLulUo3n3Dyv1wRTS9j2sL6LR/9/XK+iQkVyFdWAtwvOZlt0Ns6K1tA7
 dGl9MFEr
 MC/eEhS7ePdrheQjTRRzFO+McLXxWwtPUlu7d0WYthplhfEXxMYanEQSyQ7vmGwdpfqchcCATgcZ+zITCgN76OpsSJGaE07qQW1LuC7PRLxKWdJhqYJev19rxP0lmreImQknvOwSh/nqStnVlg16EoWQBf3V5TA/7eIHIv0sPMDVQn9JEq4WirVuUH5w8/TMKwGj9rX6ck0xrRJ5kwVC0Q3PRIm3+PsfjnMsUiO79sCHLyVDVWkqF3OstdBiYNAX85OSz95bnIAYqpHO8Dnd4/aj5RweBCu6QfBQ58SPXP9CBAs6TX3KDagHwvxAbpdDBk+NSvSw3DV7M5GnptxuSVr21ze2bb1pJ36BhOTNAbVp3F9ADhOa4/eP23mi77NgJPTQl5ZT1XHAIQDLrAuI6eh2Wzo1+zcnc2Wm0Y2W/Kfeh/BfrFRhciFg1JkrGtWLJb8Hf8HhVRPQVNxOQjBuHbPd8TSLE4y5YTfWdk92t8DX+eErUZkeHcxV5P4gNlGDSRRK5oG7m7XVL6nySJ5p8NQd7yidOdXyljCc8Xc7KPeuKxBHNsVKZQNLbRp6tesKCsdzY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 8:35 PM, Kefeng Wang wrote:
> zswap_store() falls through to check_old and walks the swap xarray
> even when zswap is disabled. Add a zswap_never_enabled() early return
> matching zswap_load(), and reuse zswap_invalidate() whose xa_empty()
> check skips empty per-area trees to avoid unnecessary xarry lockup.

Sorry for the typo, should be "xarray lookup".

> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>   mm/zswap.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0d8bd72193..fc6c5e0db5e4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1488,6 +1488,9 @@ bool zswap_store(struct folio *folio)
>   	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>   	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>   
> +	if (zswap_never_enabled())
> +		return false;
> +
>   	if (!zswap_enabled)
>   		goto check_old;
>   
> @@ -1545,15 +1548,10 @@ bool zswap_store(struct folio *folio)
>   	if (!ret) {
>   		unsigned type = swp_type(swp);
>   		pgoff_t offset = swp_offset(swp);
> -		struct zswap_entry *entry;
> -		struct xarray *tree;
> -
> -		for (index = 0; index < nr_pages; ++index) {
> -			tree = swap_zswap_tree(swp_entry(type, offset + index));
> -			entry = xa_erase(tree, offset + index);
> -			if (entry)
> -				zswap_entry_free(entry);
> -		}
> +
> +		for (index = 0; index < nr_pages; ++index)
> +			zswap_invalidate(swp_entry(type, offset + index));
> +
>   	}
>   
>   	return ret;


