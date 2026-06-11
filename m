Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7229CCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1766B0005; Thu, 11 Jun 2026 14:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B936B0088; Thu, 11 Jun 2026 14:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A306B008C; Thu, 11 Jun 2026 14:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 602BF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:10:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC7CC1C38BF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:10:22 +0000 (UTC)
X-FDA: 84868421484.06.CDBE61B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7349A2000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:10:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WfTJfI5r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781201421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPdQHZvmvzHMhqv9JGT9CD5ktNpQerM+IV8idlHzHvk=;
	b=nTCd5Gvky1Qb+7TH9GL7A8VMrFdWI1G6hUHuhyYUbOQzx2yMyLvrZu9GAifg/AK7U6eEkz
	Bx3C3Ikw/YNhtT4uopcZhuHXCv7OqEvLggIiw3VXAqABVznkxv7gRNNvlFc4hBTB1CCrMj
	liEjNn2k3isFqcs8T8yuOJ4vD0Tpdlo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WfTJfI5r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781201421;
	b=8L+m4IVqBnMGiXv5QzA78yUFCtGnBd+B/5uCXfy6eOHOEXcuWlgT2JWHHGxjQ632It+RS1
	Z7uJRDmNQn8vKe4BAz2Kh4hiHiVYRX7+0XysmliCZ0iFk9wax+3yRd4rJSRgU2HlUJdBEO
	/HN3Si9EDBSKLEkHhn/odxLXb8TSwvY=
Date: Thu, 11 Jun 2026 11:09:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781201417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fPdQHZvmvzHMhqv9JGT9CD5ktNpQerM+IV8idlHzHvk=;
	b=WfTJfI5rZZC34ooadd63p++rPupbf2SfNROjlhgO8bl2cNrn925GYSeWmECP96zFIlNPxy
	u1fIb820RrYOYHU99Map7AYr040HWsrVuEotmMO2chgxxybzeVd5G2CRHCxg6LKpVU+aHZ
	Ul4k1fDpRb6gtJs5vscyOuMaWW40eP4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <air47cqcLUwI4D9X@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-2-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pmjqmfrzs5htgprswtzexgpy3xua1iqf
X-Rspamd-Queue-Id: 7349A2000B
X-HE-Tag: 1781201419-701493
X-HE-Meta: U2FsdGVkX19EcpZDOGtjsZ4YkOgzJeRXToJ5dsWO3tU3MQhQcbSidZZrLcyM0iFE+ANCMplqbRZQ4HGf5D18lYGtVJuRr5nXqNusw/ahTznGsQ8mj31Am4JhnNGRw8yQGXEVyOA/rUFDAG8fiIh+1V4H6eal2Z16G4B5R2Bqh/D2GW3M2q3yfSyzbio0t9cpIIi6FEnfRb2vL9J94GeUD3S0s6x+5kKoyav43OTJ62irqYbWJlrnAx9uLYp3OengW9rTa/1JhO0hROdrTSgIgb0NaJ+vHBpnNm+yktq9VaJ9hKgE2nEHZNy2kRtcqwNsZa8ZzObEejzzhGoRD87P4r0YpOLu4VftroHwvnNiNDXksliIUIF2wtIiCh8YJ/zLsRfl7bZ52Ne+8RVWmjfETL6IM3pe5DpfMIvE+UR1lp9Jwp7uKaRFJQIIvUAdFqgo9qVu8FeEuNFkkaiRM0W+bGlTjlee6ZPVCUCUSIRYZnQWGk0zDUBS1tjf2JDuA2aunnpInu40sP11B0fUts9X4M33Y8k2EKE/nLml755z0L4NwcxyTjFHhwg7b5Du5Ie8Iy6Xx++UsOG60Z+cf59ioErpdscqyQxLf57Se8ZdUXQrLcMqEe61Nak8UfiL6YGq+FecGP6zj/6K5uK1mF+oW2lT0X82oX9Xs0de/gzm0dHVKVv05B+n5O3STjoqpD4XF8/BBZjOs/1HIxoQDSo8GgRKvT/EsW2Fr1MrZIdSTuAl4/Jy0OZIo6KWZxBnqKUBwdpUutJ3ezZRcoLL9X57fnVcWIEO8kBO/3x6I4xrAXzn3WJ4M/yBzeztjASqI2cEozfJbh1BXTRvVBeHZvcNK4A0eNL0IoJVhGv62+eNkuGesnB195Qmkb3sFtStqUBpXPZGgorBfj4Aj+lhc91XivbHQXrwY8YGgR0qROGctoAjNlWO404lLQy9t7Xj5AUUl2vJ/5jAxD2bRVdwjpw
 lvY6RWkV
 13afgMGsrt64p2ieE6LdGceo+1l9korim43Qvy5257a+OL00+0Mp5OUcnxHIP0HNm0Kj9gX/yy1Q9lCsN0qMvfx2Naz+gfQsF2LDg7JBB2h40+ZLAUzxlP5BFxKVHRZyhVtPpb4xz3aa4qhrg+YUVOkcroJ1hGr1FiQINPE6K5MyqmTlI9tlYUEIS5rTaG+DvjCir3HxTKLfRqaYCEbnG5r0bdk8n1EJPKMGFAMJz0YpUfukiAlc4XcCokAVeWTiOwtZSROSfuLRWXrVUO/ylGKBwUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> We always unconditionally drain the LRU before retrying anon folio
> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> drains.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 56be920c56d7..487a34377a7b 100644
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

In your experiments, how much amount of drains were reduced due to this specific
check?

I wonder if that data can motivate to introduce lru_add_drain_folio(folio) which
only drains if the given folio is in the local lru_add cache.

>  		/*
>  		 * We cannot easily detect+handle references from
>  		 * remote LRU caches or references to LRU folios.
>  		 */
>  		lru_add_drain();
> +	}
>  	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
>  		return false;
>  	if (!folio_trylock(folio))
> -- 
> 2.39.3 (Apple Git-146)
> 

