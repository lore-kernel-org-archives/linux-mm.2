Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37DDCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABCF6B009E; Wed, 20 May 2026 03:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CFB6B009F; Wed, 20 May 2026 03:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72C36B00A1; Wed, 20 May 2026 03:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FD36B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:01:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C3B0140184
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:01:53 +0000 (UTC)
X-FDA: 84786903306.27.AA72A49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7973F4000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:01:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOFWBjlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779260511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPhfsCpAc4bB8xZOq67u18U7o/poPVjXl7qQNddEXA4=;
	b=2wwHWk41rVyFRJVaex9psURagRhn8PXz2KSp2R9NjRLyhdDPOuWTgitxvwLBHo8FDj+O+v
	ueUXyVfcT1InrmWKoojgwJ116F8kGAl9HtCcbKrswWN3tX1iMaJzTEPil5PUQY1qIdzBS6
	H7AEzaAQHeXI5+twaAGdgtudsHcfxkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779260511; a=rsa-sha256;
	cv=none;
	b=M2jIpPSyfGW+PLuftLuodRbORUPoFdT80AvhJXpUONkel9U/5PrQZ/IL/GH/m0O265FMpK
	3ErFN33PWs98U66lutFqwpPlAM5Wp2ZDqhbP1FDw+3VqJ1v34R68o43uvBc/zDvBPCcYNF
	561A4ln0zLUS5R5HQcvNxb8muStw/7Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOFWBjlJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F65143412;
	Wed, 20 May 2026 07:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDE41F000E9;
	Wed, 20 May 2026 07:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779260510;
	bh=MPhfsCpAc4bB8xZOq67u18U7o/poPVjXl7qQNddEXA4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HOFWBjlJl6bDy5fYkCOBcVmEVj8iMQxzXOXkIE9WfDCO6ELoAShFH/g0LIeoO6uqE
	 HujHBo62soO0KWGxOgNFIGttk3wu/Mw/I4BdRCa7KQUAPPu2ZBppx1deymufciSWxL
	 X3tlFZy01tg/P7+8n4tv4VMHgjTcSzG4wpgI0rXaNHEcAqlBCho6zGzSvaLqm5Y9F9
	 eRO+QB0O1pbGtvuLVK9RxvRtsEoe+E0VQ8iWvOgeMZUu1HD837uuBYG3lhBE7Xa/90
	 TYNPG9Zty2JkonQS3b5dbzHoUN9+le9cry/VtMcwRY+SG1ld0dXOQsn8R9EXJa9QPa
	 tyIWfAKyKhjbw==
Message-ID: <55d36f91-fcae-4506-9b76-4a7cad3d256d@kernel.org>
Date: Wed, 20 May 2026 16:01:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-3-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520053123.2709959-3-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7973F4000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 1rqdeptq1gh31gp7a56w556ka6kjkmrk
X-HE-Tag: 1779260511-380083
X-HE-Meta: U2FsdGVkX18RC9Mz5a24bE0TL6knK3/nMWPg72pco4TyuFlxYKZRNrBJ4IxJBVRhPnZG6VGxhtcJB/sjsdZQJY+SfB5133d/sASlb9A2UwKioK3aq+Dqya8nEFAw2nHqOzYWEG1zuHilI5g3085S5L6wIuLyx1TSb7mU7jxfuTk8e61v4d1ya7vCM1yEq5MUjeUIbxyrtehu8wMcejgULHIkbYEDjbLVqBAqGp9ZHI4LeCNGyFUuGaVKoS0PxxE7qydbYDJWeGp4OANhWhzyu+NhKQeaIPkx44V1ckgfxNLVDvbIm68yC4Til8QagLg0+Ecv11MWQK64f66KX/S9ItcVeaS09LeI0dy++JtwJA+88ns8fYTF8UEdgm0w+f2GZQmodarspAlkkW21lKsarbtkv+cuXI/fLAHAsu8hygHrrNcddAqGpCkPbaRpZOpUf0qqWmIl+oxQzUjoImjHUuj72po4M7rTyYhQUN4eypOumRb4DP3vA9qelg1FEIv6I5wpdJbUAINL27O1WYUhhb+/+B/f7Q62oWzyYQ74esiYck5XDRTU6Xm+TU75XptHjM/wupz0MSOrrPF8O+E1R7KMX4wmBeIiWRBexY7CV613RzKvqQ8vmHaEv/qDk7tL4oCS5lU+AgNWzYh5Ekt3MmiBQnOBBpmMg1IhzlLYs/AfY7jaGUf7OE4D1iAuI9B3OU0J+dWg2QEE/gcYVyuWx03BiBBf95Zdg2tKGjOvk3Lczu9tzAgCwkJTvPB0JFP4lFUeNLmmE0afYbtRhePg8kC3tt5avGpgmAh5hMTHgI6LJKCH5c8D1Dibu0DuHmoC/pnRTVYBc7UTMPYXXWfBCKigNRCVfnNG4IKJ6uEOjWDjVvWAgEgFuEVBO03rHblUJVsJidhoWir3MJcw96x9pAzsK02CFClDgnVTz2gVGu25zqapagNslIE3q538Njveyicwpm9PuEkou7ra4eT
 DN/+0gB/
 tcJQr2hUKV9e9/cwnDkOPWlJ4XA9UtMUBsG62uwLOcx4eM4EqAmzDItogv9UGw5PoB2QPjCRzRnZZ4iAUlFf17wQqo8eCG3sUdZyk4cd78ukFIY8bzHaS9BABjMWgG6hf0Jp22iuYim3rfP4at/6hViaq+esIu8l+sigl6egWVpNKConVq63kaKkOJ5QW9SsmTz+HFmUNDSvv7MiP88V7EpNwgY2mcvYbMz4ydD46vfR9fLU9n7hrGVoUZ5foovlaJV7ny/PV+tNeKli3nP4Udr5H5RDp2YRy8RW7VGx703UyNukgSFd6oo7W+AbybNgbyLve8s5CFjIRu8ROE2scV0DjsoJVWqZOFwILZ3597dvliG5XkjZpi34YaMrjsYkI4biqSZKozQ4OqVddpSbTvjocmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 2:31 PM, Shakeel Butt wrote:
> Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> shrink the per-CPU cache.
> 
> The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> U16_MAX. The accumulator also needs to stay within uint16_t between
> page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> U16_MAX + 1.
> 
> Accumulate the new total in an 'unsigned int' local, then:
> 
>    1. Flush whenever the accumulator would hit U16_MAX. Together with
>       the existing allow_uncharge flush at PAGE_SIZE, this keeps the
>       uint16_t safe on PAGE_SIZE <= 64KiB.
> 
>    2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
>       powerpc 44x), push any sub-page remainder above U16_MAX into
>       objcg->nr_charged_bytes via atomic_add before storing back, so
>       the store cannot silently truncate. The PAGE_SHIFT > 16 guard
>       folds the branch out at compile time on smaller page sizes.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---
>   mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
>   1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d7c162946719..b3d63d9f267c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   		goto out;
>   	}
>   
> +	stock_nr_bytes = stock->nr_bytes;
>   	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
>   		drain_obj_stock(stock);
>   		obj_cgroup_get(objcg);
> -		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> +		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
>   				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>   		WRITE_ONCE(stock->cached_objcg, objcg);
>   
>   		allow_uncharge = true;	/* Allow uncharge when objcg changes */
>   	}
> -	stock->nr_bytes += nr_bytes;
> +	stock_nr_bytes += nr_bytes;
> +
> +	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
> +	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
> +	    stock_nr_bytes >= U16_MAX) {

nit: This should be > U16_MAX?

> +		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
> +		stock_nr_bytes &= (PAGE_SIZE - 1);
> +
> +		/*
> +		 * On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on
> +		 * hexagon and powerpc 44x), the sub-page remainder can
> +		 * still exceed U16_MAX. Push the excess back to
> +		 * objcg->nr_charged_bytes so the store into uint16_t
> +		 * cannot silently truncate; folded out at compile time
> +		 * on smaller page sizes.
> +		 */
> +		if (PAGE_SHIFT > 16 && stock_nr_bytes > U16_MAX) {
> +			unsigned int kept = stock_nr_bytes & U16_MAX;
>   
> -	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> -		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> -		stock->nr_bytes &= (PAGE_SIZE - 1);
> +			atomic_add(stock_nr_bytes - kept,
> +				   &objcg->nr_charged_bytes);
> +			stock_nr_bytes = kept;
> +		}
>   	}
> +	stock->nr_bytes = stock_nr_bytes;
>   
>   out:
>   	if (nr_pages)

-- 
Cheers,
Harry / Hyeonggon


