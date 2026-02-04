Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FEDE8B396
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 03:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06586B0005; Tue,  3 Feb 2026 22:55:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE62B6B0088; Tue,  3 Feb 2026 22:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39AF6B0089; Tue,  3 Feb 2026 22:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEBF56B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 22:55:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 364651A067F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:55:39 +0000 (UTC)
X-FDA: 84405409998.26.4589167
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6DF9CA0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:55:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GeDEaDBT;
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770177337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJR6qpSx0NUWeXNgn7pZnOB3axabsxs7/jtZomwLBEY=;
	b=3hy14n8uwH6HI69iHJ2/9DaUxlRUjHuXq5eMK/j9LWRTBLZJGgkwswiiwHPGckNnfl+Lg+
	Yh3W//Ppbbk65UDuy81Om4vnHzeQyPS7DhdBg6gGp/ZIwssOeGLJcXr4EvnsAy84vJSA/G
	L23UNQalqT4eGM4fora5gp/aSB8rXHc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GeDEaDBT;
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770177337; a=rsa-sha256;
	cv=none;
	b=MBQ/D0IithI6gilDt0F1ROrALwVo/zTlbetiQoLktSSOCJw51BW/Ux13iIHSCcLpxOM+aa
	QHm0j6WvqOeiZzFOMVX33ggy+hd/GMKw0UPn93D4Xm8sYy1Xz7UFhktU9R49O5SGzzHsGI
	+c2zVs+VKy7o9t/9K91zyI2vHalko6M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1770177324; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YJR6qpSx0NUWeXNgn7pZnOB3axabsxs7/jtZomwLBEY=;
 b=GeDEaDBT2h9uzZXjLrlqTXhAy3Lk7As2cp8CeQABcqXbHy7703mhHbeFP+7YHQX6CncTXx
 npYYlgQ069AIiJEhqRiDDQHU3gtweddOwUJGGFgpuiVgyMaI/f6fwH3DxXw1oSwjBZF+Yq
 DZm1CZf1Xj3vJQD0o097XPJJeji2h4I/0dmAdCiB8QulTQHhbD83c0Emd2N8U6FAFwV+q1
 FVgmhO457PZhYSItFe8D28dK5mguU6lzImdrzMDFtqYTN+wr6fy889ZHLnXNW3yFYKoqGn
 A1xB9fhvIMag72vGdvgX7XD9kA1of4q5OtxBWn0rL5DYNnmCn3Wa41tASi0BDQ==
Cc: <roman.gushchin@linux.dev>, <muchun.song@linux.dev>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<david@fromorbit.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <881336a6-fc6b-4f29-b5ae-eede42e9dc18@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26982c32a+e4aa90+kvack.org+zhengqi.arch@bytedance.com>
To: "Altan Hacigumus" <ahacigu.linux@gmail.com>, <akpm@linux-foundation.org>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
Date: Wed, 4 Feb 2026 11:55:09 +0800
References: <20260203073757.135088-1-ahacigu.linux@gmail.com> <20260204033553.50039-1-ahacigu.linux@gmail.com>
In-Reply-To: <20260204033553.50039-1-ahacigu.linux@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6DF9CA0008
X-Stat-Signature: 8qiqifjeqzx1cnez7py18p7341owcx9o
X-Rspam-User: 
X-HE-Tag: 1770177336-933747
X-HE-Meta: U2FsdGVkX19doupeq32WArlGdGYAzcpum0jsYUNKzOzdnI7lgLu9xt0QujNXQbVc9K7qyJu8dyazSi2YcdDdMlLRNrn1injlJ/q4hMEJF/U8SjV6IhJo16GgEJZLIY016a4yz72OZyyzLq5v0bJjzmis7fg2rMxM80AzNCRTf2oH1I3gtGheJaqf1Qb8vcd9Rm8GjBjjVVW4/y566Cc6xROxjtU3pAdcLGXk9JkYIFM+MrkblJX2mKXTHAqv4vBnoC+1pp4/cgPWN6G24NyagaIK/RITblIi7lkDE3nSr5NFOUyUcGU+dSyyi0YDwJlLiOqKLWDw//SVvnblQZQ3kUs3Y6/7j9rTRwgQkaSNp+gALN/smA6M9jdu9HfK+fDLtnWi+wlROsitvHAJ9R3gy/HYvol4rlLNe5aFWTBt4ilr3HOtNXEsIE1T6Xtb7GMo2YxnYntbOM5fYftqRYgP6zmR992Rmv6nRGL67udzCvnHKNSarWvuQWK+I91PkL998ea/Mg8VOJc22AkXbnxlQ8n4km2r1Y6buriJmlqyKlToq4zfDPpw0UorxpO4b6wmMqRQ+PrypuKqqyq9+uk51dPtVuxYzcPxNLiTm/jTynLl530ikD93oCrqpiXz1AvZDiIo1ABd4CtNcydGjSf2JksPCWXxTwoHrugr5U16STdlIxpskkR3RPgH7Hw4A+LoedBaMwD6AKOGPVqNYxf/um31v932KtrCUgdScrROEj0RR4uwo18bWquAblUIrY7as2o31I4Q2mmk2qrFKK9s8KIEBytsIwq67odUwALvvNlNecsGqLvWCG4gh03t6oK9o3sA1hmS8+JnVOEV2hX9T1DNCz7oStw+is9wfAWf6JDikiEvMt+gGxyf0dajlfJR1s0Vh1MowXwdG3veb1zXlPzQ40fDdgjFf9TDSBHIq6R8U5j2MlK/V6wj/sMNVAf1WCGnMVKx6rVYG85loMd
 mLcP3H3V
 JkBgVFEwbaBFEC+0HkIAA87w9vAO80ciNsVttBjsJkHqgA5kcDI3dF3WbUUXRuVGhFzEbZYW5ywxT7QA5dZUPDmiXPes2mwPpmVhhkiJXvmmxwfVShvMDAxJrGkHHN0Ec7vxGl7g9OWIMQqYiqoPsMO3hojwyYmWt9IgFa8DYsU5xb4QsR4F/cqqIQhf/MmjpjtJIWURPkwyOMcu61jSKo5mWf9Rq6ymAfLo1RWwvNOw/J5bpyrUragjjVdxLs9WVlaXRuHRqthBX0MYcinVIdzeHPqD80ctvI8phdSzFFChm8grVMIO0TFKPad03n8tkFJ7J07gMHcRrvha1hlPfOLF1UyO/EIDYzh0kAUyCe+7120QNNKdJ2zQEtHqtJMD2X7+wf3aC8RZ+LmCv37x6xVMLsp3IfYVSun5eOrzg382JvgV+1bEpQZsm4k3G2bJTGE20HqJA1zE8444=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 11:35 AM, Altan Hacigumus wrote:
> When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> However, shrink_slab_memcg() doesn't drop the reference acquired via
> shrinker_try_get() before continuing.
> 
> Add the missing shrinker_put().
> 
> Also, since memcg_kmem_online() and shrinker flags cannot change
> dynamically, remove the shrinker from the bitmap to avoid unnecessary
> future scans.
> 
> Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
> Suggested-by: Qi Zheng <zhengqi.arch@bytedance.com>

You identified and fixed this issue independently, not based on my
suggestion, so this tag is unnecessary. ;)

(I guess Andrew can help remove this tag)

Thanks,
Qi

> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Link: https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@gmail.com
> Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> ---
> Changes in v2:
> - Use clear_bit() to remove shrinker from bitmap instead of just skipping
> ---
>   mm/shrinker.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4a93fd433689..68dc7b4242f2 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -544,8 +544,11 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>   
>   			/* Call non-slab shrinkers even though kmem is disabled */
>   			if (!memcg_kmem_online() &&
> -			    !(shrinker->flags & SHRINKER_NONSLAB))
> +			    !(shrinker->flags & SHRINKER_NONSLAB)) {
> +				clear_bit(offset, unit->map);
> +				shrinker_put(shrinker);
>   				continue;
> +			}
>   
>   			ret = do_shrink_slab(&sc, shrinker, priority);
>   			if (ret == SHRINK_EMPTY) {

