Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08348606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KYo3xU3f
Received: by kanga.kvack.org (Postfix)
	id 2C4176B00EF; Thu, 12 Nov 2026 07:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275336B05B0; Thu, 12 Nov 2026 07:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164CC6B05B1; Thu, 12 Nov 2026 07:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1BAE6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:44:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EBE1C0582
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:44:02 +0000 (UTC)
X-FDA: 85426434324.28.3E56715
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 76EFC1C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:44:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KYo3xU3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794487440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+6w6EnLhLOmcis6niKVFV2lDAfq98fIm4HzWD5a3o4=;
	b=WOjods4t2MmLpmV1jv5qOEmx5cl1V5BzW4iN33jGlh9y/XONf9TzbYgaUyRlUUuwePjWUP
	Gl0OGK06QW9+BJLspQgQxPwQ5tRXqTTRe0vvUWRxU+OyzAnGkQj0ELM0TSLVqFJ80BKpkf
	f8WHE5kgVTmEjkGy7g/RCX7FUbt2YF4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794487440;
	b=mstOQaC4gJ6+PmZMGKZYLPd8Yo4oboD2/ObWkgwZE45FXV5l7oqg7Os4iOPu6dirhmG3fe
	1VhUQ5oBm/uljc470CkqfFs4JNxd/XTQCVfA+2RZ7o8k8F6JTBer/DbmpQvZw34M1FIue6
	tzmJHjwtuPzj99cApXp7XgbEgLpafpI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KYo3xU3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso44706205e9.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794487439; x=1795092239; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+6w6EnLhLOmcis6niKVFV2lDAfq98fIm4HzWD5a3o4=;
        b=KYo3xU3flgcY1ODT50Wfva6tEDCz5X8QxnLa4IgIyyFuTPaWBr+WIHsbasHQW9RdJI
         Rx+U05chblxzqdr/OojbtEnE0+bM2RnOcjwdu7pZivQOXKu0p+01oXEzQQUsFxuToBOF
         QzDjw/h2fH6SiNUx0N6Oa46xV2Drzy8+cnzZtQaUv9URq0gwkdjsbo4MIfS+/PV3Q3Nw
         vs8/AaM3vG7sW8mrnLiXtttVyY03gd4USPblJwUQOPRxv2Td2/t96Z7HhWr9l+20xRNz
         duejR+A+LHxdajo4g5z2GdsqbxFMTmpB2DJcj9B/yD6fjlQYWkw6Kdp2oyGo23o5GZNy
         feoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487439; x=1795092239;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X+6w6EnLhLOmcis6niKVFV2lDAfq98fIm4HzWD5a3o4=;
        b=iMKnrYub/JU/ZF0y+xUGoe3BVdBFLZ1iw2Oh6inLhEzjyMwE4OJsNZibeU1qzs8RfD
         VfkO7rZ0ecUrydnZ5Jfh2Tqbarq5HpnRD4mKNr5SwtsgRLHydRyHu5jCkaKS+kYrf/qo
         zv/lK9ImSAIxyoLpC/B++SRaIcZU9CQCfmtJy2oRh4wy4+mbOYPK2DuOBBu4gHNkkwN9
         Xu0fdXRLASjA29hgrC2xF9q4AXXtO8N7NbT4Tun0VoEgqBwiZSAgIZdff6zJqre//urc
         sxWTuPr3Nw2zQeDod8fNP7LW3QC8at0coAL2U3/3vY7Ba9UlQWISIHaxACdgPNTgU7qA
         JIEw==
X-Forwarded-Encrypted: i=1; AL+hErGRRQlhvPE1MoqbUzG1WFycNfBSfheelRMmFVUSPFmtYQ35bfOYHq26NK2aYC3xqAL4mFPIj+1A8g==@kvack.org
X-Gm-Message-State: APuU4Z+xJFq729bUgicg33E2JLcc0GfcPh5x9e4bUW9oPB6zCGEzDF9j
	4Z/ZYg1FbsAa2qN/Fn/mr8lqjum1g4JDCfY2Vn3GuKSqgHKeybJ16pRN
X-Gm-Gg: AYBFou0en4LK4tLi311u2q2ko80rxBnnJ0tVVNB7+YJO4JJzYe4HJRFE+j6L1wluYKl
	h/9wuEAXRvTwJpuAxY01oFjP281yDL4dWymDGMWqgAOBRKxPs0pXgI3X7pUKWEtP+o4TZljof3i
	UmacP+I7RSPpK4hlOYfJpSucN6I6XMz3Slrkf3miqZte6xz/EFj3jJ4FXLGMxNTKq6wUnPT+BGn
	caXCMu1ke3JAgSgO9OWKchkIs+vlCZGsku5NKhiyQgkkfQJ5LIRGF3aXGur/wzbNT6bmlSnCZdX
	ZKdj56wmYvP8KTjIqpMUtv1LscB1ygma0Ne1Id4tnNCPzr0CWz1UGr6+jnmAoKQyaMMAgRu98Fi
	LFd3E9dU29V+e9gLO4B5WA07paZcnORzjk/IsicFzPxfJDJcicNR46Wp0kXceoDwR7xPN7Fwjl+
	hYl14hVlCeY4u908FbTNsP2vjADv4mMBVcHDLHzH0m43v8na8e5LmSceBPIYHMppmQUCf5IDe9Z
	MSNYVrSNb7jI6oSNMcRsxr/OJ1aRZYECGDYj5k8Nnw1uzWgzM6bJ1tCGTzR6Vhfr+bLX4bilaJ9
	d0RpGEyPHya6/7KDGZcWexmB
X-Received: by 2002:a05:600c:3f16:b0:4b6:bb67:bb9 with SMTP id 5b1f17b1804b1-4ba093c8e2fmr93646065e9.29.1794487438821;
        Thu, 12 Nov 2026 04:43:58 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e27a8b0sm69126995e9.15.2026.11.12.04.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 04:43:58 -0800 (PST)
Message-ID: <dee35546-3f5d-4fd3-83cb-dd135e726e09@gmail.com>
Date: Thu, 12 Nov 2026 13:43:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm/huge_memory: detect partially mapped shared
 folios without per-page mapcounts
To: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, Joanne Koong <joannelkoong@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
 <20261111113535.330078-3-azpijr@gmail.com> <sashiko-outbox-211031@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <sashiko-outbox-211031@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a3fde4p63xqmsx8pecahosrb7qzwwpj3
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76EFC1C0009
X-HE-Tag: 1794487440-859968
X-HE-Meta: U2FsdGVkX1+PX2EXzb+iUsa2/6yh9yNckC22CL/Q3ovHVDHo+G1Df6SnYUT0UT4g6tmzyTfOdGXJy4zZzUzybPJAUVgpeYspKcpDG4GIukGuR4H9bOUFcErZJNqEwU6M/XR6NtoFI1Wl1TJx/4BdQQKEo8Oo6IzHlNNdd8Bmyn4CVacaaPktA+PymzvhbWeuA1xN4z6GecdFuGdTzrQVvCILZnRuXahzTEh3lC0yuYF3sB9lyxQOJP64gFgIGU0e3CnrybmjaiQNj4wDuc2ezeBTnoPtezDCKQ622NmgXs1QDK63Ybli0uJuOg2yJLES7Rg95xEtHZ1xIWlPbheALBQPJ/4glv5y3HV7a5XUPZIfvHTSDmrwlvIZfaBpgM/dkVB4T7gnzcH9rsPmGmQkFbmO3mp/G4A6wQaE+YR1RNcqM/QP2yiRkjK4K5qYN0wo34d7j6P1WdwAX64mfhC+T4Y09jyBA4iT4HW6jYnGteT4FCy/M8Wm3c6QkkKsrB1QHYeJYmrp0ePkJj/P3No25KhmDNS1aBvibYVpiWItNpjSK2F6XqvcFwmWM9MM89hHq7wfQ+bI0URVVR5uQ8eJkHOEZCQJp5oqteIA9i1vl7DOxKmwX3bzmY5PUCwgE5JUh2lFhmUBQ+Zhz99kqdIQM9yhUMBMK42kP26xn4c/YSpnMnRovy6Fs04mFEMTpIZOeHgk1SU0WDF0wq5OXORewdXZT2FXHQdo69kgLH895nhXlOqtIOT5nYoqBlVAk3StHPzvD4bwhA77v2Kjcrpm8QlMqq2vBRoF7QRgYq/XtZb8AYHpd2lI0QDHn2AtKS+0Ny9AJHTolkAvFW+kFyiJGVApmF57nFUEKMrkgZylwegGkr6w01X6zvpzmiLfgjw+P9/wePn0RtJJ2V9atTbFiIDpAQz2goL6FjnBwCcKk16Df1UCmmSDdfgRec6LW+Y3UZMwK/v9x7n1MHFQ/ej
 cUbIIADZ
 O+WyRcYlhwNPK/UO6wEwqvYlh+QP2GkYNN2OiklQm3h8xA62iuocvfxNTdSCwMhvfWVZJVsVVjesN4RX5BpMQcUZhzLHYJFPb8yk3/k7XdzfBf/gq8FA324hJ+SLRTaCYOw+OOVAyHt8SmOtrhaZ/Z1IAbWxXYrzsyjPtE0NC5BWRZsQOuboJZjLMdvDxxsEE59782hmzSGViAxb52oCKylnN2fttUJmDLx03iQFF1VvL+H5F1hPEk3a+V6cRCLTfV0bGLvOR7jlE9H3CNc5w1cKp5lJTxg+Ln4TexlyV4zk0JzAWoCDft0hDAUkHcpAf11mRohDEPMSlVMr9ooVuyjXMNcc9DW1AL4DbVAuRXJ6sUrhTipjF6Zh5ymmspb0qQGZzqXgCh8kIPa9rbqjm3x3Gtc6WO0RFr0V1kcoDF2M/q9OKHcFCiiXSYclnJpWBAgAABiiPr7amP/6j3OgoMv1IVPAztO9AeNk0nNaQenhy+LX5+/WcGQb+W8CLlwrHwGomRX0q65tHMIVhGlTdPpNy9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 12:36 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/huge_memory: deferred_split_scan() runs PMD
>   thp_underused() on mTHPs
> --
> 
> commit 2f9d38ddfb170d3656f9925bef1e82e9b94ecc37
> Author: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> 
> mm/huge_memory: detect partially mapped shared folios without per-page mapcounts
> 
> This commit queues shared anonymous folios onto the deferred split list
> without setting PG_partially_mapped when CONFIG_NO_PAGE_MAPCOUNT cannot tell
> at unmap time whether all subpages remain mapped, and walks the rmap in
> deferred_split_scan() to check them.
> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 8c4a69c797edd..f80fa028dd340 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
> 
> [ ... ]
> 
>> @@ -4744,6 +4811,15 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>  		list_lru_unlock_irq(lru);
>>  		rcu_read_unlock();
>>  
>> +		if (!folio_test_partially_mapped(folio) &&
>> +		    folio_needs_mapped_check(folio)) {
>> +			if (!folio_trylock(folio))
>> +				goto requeue;
>> +			/* Sets PG_partially_mapped and puts it back on the queue. */
>> +			if (folio_mapped_shared_partially(folio))
>> +				deferred_split_folio(folio, true);
>> +			folio_unlock(folio);
>> +		}
>>  		if (!folio_test_partially_mapped(folio)) {
>>  			/*
>>  			 * See try_to_map_unused_to_zeropage(): we cannot
>> @@ -4752,7 +4828,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>  			 */
>>  			if (folio_test_mlocked(folio))
>>  				goto next;
>> -			underused = thp_underused(folio);
>> +			underused = split_underused_thp && thp_underused(folio);
>>  			if (!underused)
>>  				goto next;
>>  		}
> 
> [Severity: Medium]
> Can deferred_split_scan() now call thp_underused() on a sub-PMD mTHP?
> 
> Previously, only map_anon_folio_pmd_nopf() queued folios with
> partially_mapped == false, so any folio reaching the !folio_test_partially_mapped(folio)
> branch was PMD-sized.  __folio_remove_rmap() now queues shared anonymous
> folios of any order > 1 with partially_mapped == false when a partial unmap in
> one process leaves the folio fully mapped in another.  When
> folio_mapped_shared_partially() returns false for such a sub-PMD mTHP,
> execution falls through to thp_underused(folio):
> 
> mm/huge_memory.c:thp_underused() {
>     ...
> 	for (i = 0; i < folio_nr_pages(folio); i++) {
> 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> 			if (++num_zero_pages > khugepaged_max_ptes_none)
> 				return true;
> 		} else {
> 			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
> 				return false;
> 		}
> 	}
>     ...
> }
> 
> Because thp_underused() compares against unscaled HPAGE_PMD_NR and
> khugepaged_max_ptes_none thresholds, any khugepaged_max_ptes_none below
> HPAGE_PMD_NR - 1 causes reclaim to scan subpages with pages_identical() even
> when neither threshold can be reached, or to split fully mapped sub-PMD mTHPs
> and increment THP_UNDERUSED_SPLIT_PAGE.  Checking folio_test_pmd_mappable(folio)
> before calling thp_underused(folio) would avoid this.
> 

okay, seems correct. I'll make thp_underused() return false for folios
that are not PMD-mappable in v2 then.

-- 
cheers,
jose a. p-a

