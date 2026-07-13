Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F11EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6AF6B00DF; Mon, 13 Jul 2026 12:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DE06B00E1; Mon, 13 Jul 2026 12:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965446B00E3; Mon, 13 Jul 2026 12:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB6A6B00E1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98E6914015C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:55:03 +0000 (UTC)
X-FDA: 84983899686.15.2409648
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEC6A180005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:55:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9w9rBXO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783950901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzRBgncFk7244VmHF9tKjOq5GKtMKBEExPzmIhMTCIU=;
	b=DJ5chamXyzxtn+cLfrItkTNJXMTOvHSuyo/yBIs8ke6va2lfjVOuRpXvz8wOqsf+5/fY8g
	6Mzla2OdkPUcB4EOKEk+E0EEaqi8iNKwbeYdwFJGoBVvdK8mKeW27UUQYbTX/KwLnvEcuW
	RqvR/NYn2H2Kc78+QO5uFU/7B6jx05s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9w9rBXO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783950901;
	b=WVcY4h9uFj/ZLhfOIpTn0W6yWEz0F7OD3B9KNF0B56dKuWTTznW3tZ7u/zLuiU3BGWBsAI
	2xBke7hJ2eih0u02AHyqS4HOq6J+X0KwTyF1aKS/hhUh/IBitdqKm3dzwYqEtGumodtQEH
	yquMIt7j+zyBb1yPzVQetFwAHxlpJhE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B5E760120;
	Mon, 13 Jul 2026 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18831F000E9;
	Mon, 13 Jul 2026 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783950901;
	bh=xzRBgncFk7244VmHF9tKjOq5GKtMKBEExPzmIhMTCIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j9w9rBXOsZ+0dL0dqPx1BbdBzQYaSRiA68YSdY3vmi05moH1Nx2oLkXi9Y//k9Dku
	 a30n3oyKZPFpFSWrp/jzRuBm9AWERDzTtAreSu54sy/RxnaSqHdbxGmo5iH4wQ15gl
	 mw95toW6/uDvwivt4nVQ8RtDyL0BCkHRT6opUrixHNyjgl+zj6EM3TZSUTCbygh+1Z
	 V708X5v7pPu9YOf/3oZCxqLNsqzabEz6SMehmobPeBB0ndhI5sbjmbGLqnA5Spizt3
	 CyOQEMy4pU75d3EYowTRqBvnHwXTkDfHxIeCUfTzcE9yLxkbZqWdzIoblJYmm/S/jb
	 wn4U5ynZVQFzg==
Message-ID: <1b1d0523-6eda-4fd8-9e22-a4a14c869bb0@kernel.org>
Date: Mon, 13 Jul 2026 15:54:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
Content-Language: en-US
To: Hongling Zeng <zenghongling@kylinos.cn>, harry@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
References: <20260713070024.153552-1-zenghongling@kylinos.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260713070024.153552-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DEC6A180005
X-Stat-Signature: zpxgmpqwprifshq5zmk6nw35x3f6khxj
X-Rspam-User: 
X-HE-Tag: 1783950901-830154
X-HE-Meta: U2FsdGVkX1+sgVijVv5aUShVweA38kFqVA1MThJ4ceaL+/JSpziegsPHQcy/81VVNVMMxpauVTo859hNdu0sEi1SJf8d5IfHMtFAo9/P1A9bhaJnF0Jerq4eaRnfqiMv3IgK+akTPEFa7jK8z1asVLjQ6Y8n88pBhffk/qO3kkb1lUZgS2tK2amHoDM29BI8ChIV6L+CF0ewsJ4E2D7oGgzxA6zsKC5chL18Oe0kw1l71Cm4bRxLHdpxTQJe1Uvrlr41R2ozQwUJ6eRgNBRVZAJL6xXFZ0ltirH/UkG8RHozDqYY4kro3elmaVmtnSLOowCz0+Qz5ukkRxY6L/gfRMbOj7AOCj4tX+GAB0BFK1WBWX21jHVD1Jk6IbHbHGykhoeE0SPLmyZaY7CRdtPCR17jdimwDvxxIueN9ZirtFa2aaAWgrnF1L4TWb5G8xyH4EWQwxDvQg7d7lBily/vh+rtICUGN1LAImzEW6DiiKuUUEOvPLGYeAfeHfSg1Fyb/u3ht1FlQeW/Fgj6xVoNwwLk8GwM03BYNTFg28OGg3aU6hRM+AHMKZzClZqPepuwfHTK8sUGAypGy3dG0+h4u3SLe98eZC0EzE3j6tdOMrKDbfA/88M5//arauuzbi6RKvNgLJgYqJHu5hNJMisx0XBcdwrQ8wjX0DYLPRvV9oyGZ7Ot4RGoPfzI8c64ttATHNUijacSJ8ps5LKMsahMZDuY33vFaQs/VVVempBgxb9iQBzgw5F/rqJ0VzXJrf4Qm1kQK92KHCO+ADBUH9LCLvhwlu2BOhcMAND15MQ5gnR19vwXemuzjqeCnsPdEqEhB3mbj51Qwk9Am7cSSGPM7RWthofZnwf8zmF1f5iJP/HhuyjRoIkbZCgGB/mzVwQMnBwocdvjjaGZhpfLk+WEZV9L1O/NO832waZ0gJRC8dCqgN8bDnmMb+IowQ4ig20krKoFwKr/XuHxKwKwrDm
 c/Y0Vd8t
 O9Rh1VMiMHKYVLNRJE372TQ/m5etDS5q/7ThUnWKgFZbAA9Wcc/Z/Angipxxlz5SpPfFnEjS2U4MUSwLKNuUMAjt8M7V5I/llCip52Z42ikVtEx60KllbgDV37hZc/XBxskWQUG+tR2m5wcI3HTQZkw7QtYXVh9fitD5SQI8hxrDhZPkp5+qd0Y0yDgMh/n5y7OFuzMEV/tlP6ZcwJwkoZv3obICwRel1Yed1yomaJn7L0Xsbh0Xbl8Vgb+5YP3sHIKhwicyi4lV+72zom6ZgzB39A9E+z/kCEy/W2bdtloyUmImcoJNUUatvM/nrr2hXtLPiBhnqIFLCRBnQJmwdNT0JhTvZJrOSUYb1a3vQMrLQch9ccVx9hkh6bDCIDQsnA4t4Z0KZRNJMCDx1iIPdSxht8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 09:00, Hongling Zeng wrote:
> Add a comment to clarify why we don't call kobject_put() when
> kobject_init_and_add() fails in sysfs_slab_add().
> 
> Per commit 2420baa8e046 ("mm/slab: Allow cache creation to proceed
> even if sysfs registration fails"), sysfs failures are treated as
> non-fatal and the cache continues to be used. Calling kobject_put()
> would trigger slab_kmem_cache_release() which frees the entire
> cache structure, so we intentionally skip it.
> 
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Thanks, added to slab/for-next

> ---
>  Change in v1:
>  -Correct the email
> ---
>  mm/slub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 9ec774dc7009..edc822d7d9ea 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9690,6 +9690,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
>  
>  	s->kobj.kset = kset;
>  	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
> +	/*
> +	 * Intentionally skip kobject_put(). See commit 2420baa8e046
> +	 * ("mm/slab: Allow cache creation to proceed even if sysfs
> +	 * registration fails")
> +	 */
>  	if (err)
>  		goto out;
>  


