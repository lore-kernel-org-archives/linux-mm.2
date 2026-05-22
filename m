Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A049CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4496B00A2; Thu, 21 May 2026 21:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B7B6B00A3; Thu, 21 May 2026 21:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0AFC6B00A4; Thu, 21 May 2026 21:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E09A86B00A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:22:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CE62A0797
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:22:05 +0000 (UTC)
X-FDA: 84793304610.18.646B73F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC38BC0003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:22:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVeGbjFN;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779412923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxMygZ9hcsa3Mh208HkljC86oSSIEIIHQro19e3RuAk=;
	b=fdLH5V5kcB8ysQM2brVdOXxQoKZ8LOnKmTBtlSeUHa4fHloe3eUgAPxp4fdLMiY1XdPVH5
	TLNE4V66pWcW+0WFxI16uuY9lhNZMg56TJHvTrHBPuHQ8YXb4+Caek/cD7XanpKdy02v40
	gL32+xgnmlEa6tUlB1CELuFK165D+Vc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVeGbjFN;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779412923; a=rsa-sha256;
	cv=none;
	b=gLPxxGzwyaf7Ki/ItdzDu/vVguIJ7XmcIPR26DcDXouRGJgO5RKnRlRop8vx0DShNPgXmw
	+8HqhD2Gud9Z++KSAaDtqwuNK/ED9ADa7l1EgrAtg6r96sfp84oXqXBADsegsOX2yl3xat
	7QYUwNYW36fOO/YrM+yyxA2FgsFKU+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D114340BD3;
	Fri, 22 May 2026 01:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60611F000E9;
	Fri, 22 May 2026 01:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779412922;
	bh=HxMygZ9hcsa3Mh208HkljC86oSSIEIIHQro19e3RuAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VVeGbjFNPUPkrJABT5J1Fj9u/TOEEbIbtzWok+zXc8j1EcT4OY2LS30abX2IF1EYQ
	 VbIPg0Bxnd3l2HlpwvjLMvFtua46E/dX/hqjUrfDwvJ0LQCLWpOIn0PrC6CLE6pZ2b
	 sm1Aoqny6pCkP2i34Z+6qOiE1sxtpvpVEBjacr7i+GLI1gl7Cjylo9spe/o9SHRCfS
	 v43sv/qcTYodJoIXELyW7j/5pwN4IfU1rYjzorR67F6koNCjuww29MF9+Se9dUPBbW
	 Ybld5vypp66mo0HAdeb0I+GcUf/He4hXyschxSfpM6mQ41lm/ka1SQUpH59Y00fc4a
	 2qaVCaKlFEGZw==
Message-ID: <13fd910b-e897-4a9d-847a-545267209bf8@kernel.org>
Date: Fri, 22 May 2026 10:21:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: free returned pfmemalloc sheaves via
 free_empty_sheaf()
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: odncjxu9sgsxd8s9ptz95xygps8egck4
X-Rspamd-Queue-Id: BC38BC0003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779412923-131952
X-HE-Meta: U2FsdGVkX1/L9fyKQZe2W58HggbWbB4w0ZGMl0TsTIN/ZMu5U8+qIUnuqyzYA1Wi0EcXJFzMYF7WWi4cWfmOq+WVALRWVAfELU7dHGGhX7+QzlJR5p2Ufn2Czp7k033bYHiQzl8kDIyoLc2nUAcPNCT1jKexOxb5skNb+jGZvbPlQl+W7nCguiPmyfFllaWT4ky2sHEb3vjvQSfibpYPpT4O3iZAzBL1oDL7CzqPbWtsYko1Zs640FN3z+lRLofvlhnh+wYfjlll7e8WXHl27TGY5TTE2oPHTjavti/zgsFgG3nNsh0dbswbFOBb9bTgAeMEt7fqk534EzAPdotH2cQMgZNVwqbz98JTjOH/z9Eym5YtivLqY1GVq8HeGPkRDN4HEe8k2HiFlxxGEEblTNyKzgrUj90i3WPSDCBwTdHZovryUCmAyQv8QB6PmjbNuNKV9aYXP0vsglxqvB8tQSBSoaESYpZsgRoCIvR45n50Nr7REeOqAnsbW/0IE05EWqFTpdV/i8sTTS0oDa5VkbwLDv10jWd0DfyHBxEOFwrJKBokZg7JKaKatgtbH+0yQLFS1yW7967FL28K0esNZa27Oa6sRH+3BSqzz0WvUJeNYZmHh79pner+MJ+7HszCoWVpljESau1GLleItuNTU/tfwntH9u3RllwdzO9JcuQAPw7IVdOQuClCd2sDoxawlTFvoYSzsvLNUd/EcK+QSPc3rEfoYrbaqJa2mh2PZkBACBZMFGcFPTGuwzrNsli/PpznMpzOJrw/EnOo8Mkz8Y092xP8wvtDO7B/ZOYMf61Oj4GU3joL/Eqjm8RNvNZ+25QOEMZ9v8Zy0LAuq6t6Rj3HqrfjTOUFju3wXiRKVaXYbaMsTmo2y2hEgkJZZODtw1b3QTARKoS9u4hK/EyLH3bEK+105SpAyU+co0JB1o9+IqaO9KCjQjdm3XhpWLLoe3dvCdCHZgRY+p4UbJk
 5B1PtZ4H
 Ein1jpkkeILnIrXNsYSjGqcgyZHE3TG+oypXhcHZQWbQ5CKeqc+4YdMiGMyPxxFcaJ66Mh+c+t8Bxs19WO9xiajO4jR73lyt2Qy6wjuZui8Ggm9Kc4FnQqWvNhb9nwp485kG6yp/bdY0oEW61SwlRKyuiY197lQMqScL9tbb8rg277WV4qaRY7bePGNRZdQVMolLaOYgPbXF3TVF2nuCU+4hRFEPIhF5iPxf398afX1Y8hhHN77eLEox9OYBbHBlVcP83FMdLjM8rVVRfG6WtlXACT6/W4alUc2WiQl3sD0GghMcFa71L/0NRW1pgTgoX0Ft5sNtP9ExCLToRaVX6GMRdJI7voPq1jzydySNV3DTRT98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Shengming,

On 5/21/26 8:50 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Regular sized sheaves are allocated through alloc_empty_sheaf(), which
> sets __GFP_NO_OBJ_EXT. free_empty_sheaf() is the matching free helper
> for such sheaves. It marks kmalloc sheaves with an empty codetag before
> kfree(), avoiding the alloc_tag_sub() warning for intentionally missing
> object extensions.
 >
> kmem_cache_return_sheaf() currently handles returned pfmemalloc sheaves
> in the same branch as oversize sheaves and uses kfree(). That is right
> for oversize sheaves, which are allocated directly with kzalloc_flex(),
> but it misses the matching free path for regular sized pfmemalloc sheaves
> that came from alloc_empty_sheaf().

I think it'd be better (in terms of readability) to teach 
alloc_empty_sheaf() how to allocate and initialize an oversized empty 
sheaf, and always free empty sheaves with free_empty_sheaf().

> Split the two cases. Keep plain kfree() for capacity-mismatched oversize
> sheaves, and use free_empty_sheaf() after flushing returned pfmemalloc
> regular sheaves.
> 
> Fixes: <1ce20c2> ("slab: handle pfmemalloc slabs properly with sheaves")

When referring to a commit, the commit id should contain at least 12 
characters to avoid collisions (per the process document).

...but probably Fixes: is not needed at all, because currently no user 
uses kmalloc caches to allocate prefilled sheaves.

> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
>   mm/slub.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 04692a6f9128..a6b720fa79ad 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5094,13 +5094,18 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>   	struct slub_percpu_sheaves *pcs;
>   	struct node_barn *barn;
> 
> -	if (unlikely((sheaf->capacity != s->sheaf_capacity)
> -		     || sheaf->pfmemalloc)) {
> +	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
>   		sheaf_flush_unused(s, sheaf);
>   		kfree(sheaf);
>   		return;
>   	}
> 
> +	if (unlikely(sheaf->pfmemalloc)) {
> +		sheaf_flush_unused(s, sheaf);
> +		free_empty_sheaf(s, sheaf);
> +		return;
> +	}
> +
>   	local_lock(&s->cpu_sheaves->lock);
>   	pcs = this_cpu_ptr(s->cpu_sheaves);
>   	barn = get_barn(s);

-- 
Cheers,
Harry / Hyeonggon


